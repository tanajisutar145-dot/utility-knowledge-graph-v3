"""Unstructured path: narrative columns -> Documents, Chunks, embeddings (+ optional LLM extraction).

For every row with narrative text a small document is built: a header naming
the row (label, caption, standard class) and its FK neighbours, so a retrieved
chunk describes itself, followed by the narrative columns.

``extraction.mode``:

* ``embed`` - split, embed and write the lexical graph
  ``(:Chunk {text, index, embedding})-[:FROM_DOCUMENT]->(:Document)``. Fast and
  deterministic apart from the embedder; enables the vector/hybrid retrievers.
* ``extract`` - additionally run neo4j-graphrag's ``SimpleKGPipeline`` with the
  ontology-promoted extraction schema (entities such as ``Defect``,
  ``RootCause``), resolve duplicates and link rows to entities (``MENTIONS``).
* ``off`` - nothing.

Every source row is linked to its document with ``HAS_NARRATIVE``. Documents
carry a content hash; unchanged documents are skipped on re-runs.
"""

from __future__ import annotations

import asyncio
import hashlib
import logging
import re
import time
from dataclasses import dataclass
from typing import Any

import neo4j
from neo4j_graphrag.components.kg_writer import Neo4jWriter
from neo4j_graphrag.components.resolver import SinglePropertyExactMatchResolver
from neo4j_graphrag.components.schema import GraphSchema
from neo4j_graphrag.components.text_splitters.fixed_size_splitter import FixedSizeSplitter
from neo4j_graphrag.embeddings import Embedder
from neo4j_graphrag.experimental.pipeline.kg_builder import SimpleKGPipeline
from neo4j_graphrag.llm import LLMInterface

from ukg.kg.captions import Captioner
from ukg.model.data import Rows
from ukg.ontology.extract import SemanticModel
from ukg.settings import Settings

log = logging.getLogger(__name__)
_FREE_TEXT = re.compile(r"(description|notes?|comments?|findings|narrative|remarks|summary|recommend\w*|plan)$")


@dataclass(frozen=True)
class NarrativeDoc:
    path: str  # "<table id>/<pk>" - stable identity of the Document node
    label: str
    key: str
    source_id: str
    text: str

    @property
    def content_hash(self) -> str:
        return hashlib.sha256(self.text.encode("utf-8")).hexdigest()[:16]


def _human(column: str) -> str:
    return column.replace("_", " ").capitalize()


def narrative_columns(settings: Settings, sem: SemanticModel, rows: Rows) -> dict[str, list[str]]:
    cfg = settings.section("extraction").get("narrative_columns", "auto")
    if cfg != "auto":
        return {t: cols for t, cols in cfg.items() if t in sem.tables}
    out: dict[str, list[str]] = {}
    for tid, t in sem.tables.items():
        cols = []
        for c in t.columns:
            if c.sql_type.upper().startswith("STRING") and _FREE_TEXT.search(c.column):
                values = [r[c.column] for r in rows[tid] if isinstance(r.get(c.column), str)]
                if values and sum(len(v) for v in values) / len(values) > 40:
                    cols.append(c.column)
        if cols:
            out[tid] = cols
    return out


def build_documents(settings: Settings, sem: SemanticModel, rows: Rows) -> list[NarrativeDoc]:
    """One document per row that has at least one non-empty narrative column."""
    captioner = Captioner(settings, sem)
    std = sem.standard.get("short", "STD")
    by_pk = {tid: {r[t.primary_key]: r for r in rows[tid]} for tid, t in sem.tables.items()}
    docs: list[NarrativeDoc] = []
    for tid, cols in narrative_columns(settings, sem, rows).items():
        tmap = sem.tables[tid]
        loc_table = settings.section("gis").get("location_table")
        rels = [r for r in sem.relationships if r.from_table == tid and r.to_table != loc_table]
        for row in rows[tid]:
            parts = [f"{_human(c)}: {row[c]}" for c in cols if row.get(c)]
            if not parts:
                continue
            tag = f" [{std} {tmap.standard_class}]" if tmap.standard_class else ""
            header = [f"{tmap.label} {captioner.caption(tmap.label, row)}{tag}"]
            for r in rels:
                target = by_pk[r.to_table].get(row.get(r.from_column))
                if target is not None:
                    to_label = sem.label(r.to_table)
                    header.append(f"{r.rel_type.replace('_', ' ').lower()}: {to_label} {captioner.caption(to_label, target)}")
            docs.append(NarrativeDoc(f"{tid}/{row[tmap.primary_key]}", tmap.label, tmap.primary_key,
                                     str(row[tmap.primary_key]), "\n".join(header[:12] + [""] + parts)))
    limit = int(settings.section("extraction").get("max_documents", 0) or 0)
    return docs[:limit] if limit else docs


_EXISTING = "MATCH (d:Document) WHERE d.path IS NOT NULL RETURN d.path AS path, d.content_hash AS h"
_DELETE_DOC = """
MATCH (d:Document {path: $path})
OPTIONAL MATCH (c:Chunk)-[:FROM_DOCUMENT]->(d)
OPTIONAL MATCH (e)-[:FROM_CHUNK]->(c)
WITH d, collect(DISTINCT c) AS chunks, collect(DISTINCT e) AS entities
FOREACH (c IN chunks | DETACH DELETE c)
DETACH DELETE d
WITH entities
UNWIND entities AS e
WITH e WHERE e IS NOT NULL AND NOT (e)-[:FROM_CHUNK]->()
DETACH DELETE e
"""
_WRITE_DOC = """
MERGE (d:Document {path: $doc.path})
SET d.source_label = $doc.label, d.source_key = $doc.key, d.source_id = $doc.source_id, d.content_hash = $doc.hash,
    d.caption = $doc.path
WITH d
UNWIND $chunks AS ch
MERGE (c:Chunk {id: $doc.path + '#' + toString(ch.index)})
SET c.text = ch.text, c.index = ch.index, c.embedding = ch.embedding
MERGE (c)-[:FROM_DOCUMENT]->(d)
"""


async def _embed_only(docs: list[NarrativeDoc], embedder: Embedder, driver: neo4j.Driver, db: str, cfg: dict[str, Any]) -> tuple[int, int]:
    splitter = FixedSizeSplitter(chunk_size=int(cfg.get("chunk_size", 1200)), chunk_overlap=int(cfg.get("chunk_overlap", 100)))
    ok = failed = 0
    t0 = time.perf_counter()
    for i, doc in enumerate(docs, start=1):
        try:
            chunks = (await splitter.run(doc.text)).chunks
            payload = [{"index": c.index, "text": c.text, "embedding": [float(x) for x in embedder.embed_query(c.text)]}
                       for c in chunks]
            driver.execute_query(_WRITE_DOC, doc={"path": doc.path, "label": doc.label, "key": doc.key,
                                                  "source_id": doc.source_id, "hash": doc.content_hash},
                                 chunks=payload, database_=db)
            ok += 1
        except Exception as exc:  # noqa: BLE001 - one bad document must not stop the load
            failed += 1
            log.warning("  embedding failed for %s: %s", doc.path, exc)
        if i % 25 == 0:
            log.info("  embedded %d/%d documents (%.1fs)", i, len(docs), time.perf_counter() - t0)
    return ok, failed


async def _extract(docs: list[NarrativeDoc], llm: LLMInterface, embedder: Embedder, driver: neo4j.Driver, db: str,
                   schema: GraphSchema, cfg: dict[str, Any]) -> tuple[int, int]:
    sem_ = asyncio.Semaphore(int(cfg.get("concurrency", 4)))
    writer = Neo4jWriter(driver, neo4j_database=db, clean_db=False)
    ok = failed = 0

    async def one(doc: NarrativeDoc) -> None:
        nonlocal ok, failed
        async with sem_:
            pipeline = SimpleKGPipeline(
                llm=llm, driver=driver, embedder=embedder, schema=schema, from_file=False,
                text_splitter=FixedSizeSplitter(chunk_size=int(cfg.get("chunk_size", 1200)), chunk_overlap=int(cfg.get("chunk_overlap", 100))),
                kg_writer=writer, on_error="IGNORE", perform_entity_resolution=False, neo4j_database=db)
            t0 = time.perf_counter()
            try:
                await pipeline.run_async(file_path=doc.path, text=doc.text,
                                         document_metadata={"source_label": doc.label, "source_key": doc.key,
                                                            "source_id": doc.source_id, "content_hash": doc.content_hash})
                ok += 1
                log.info("  extracted %-34s (%.1fs)", doc.path, time.perf_counter() - t0)
            except Exception as exc:  # noqa: BLE001
                failed += 1
                log.warning("  extraction failed for %s: %s", doc.path, exc)

    await asyncio.gather(*(one(d) for d in docs))
    driver.execute_query("MATCH (n:__KGBuilder__) WHERE n.__tmp_internal_id IS NOT NULL SET n.__tmp_internal_id = NULL", database_=db)
    return ok, failed


def load_unstructured(settings: Settings, driver: neo4j.Driver, db: str, sem: SemanticModel, rows: Rows,
                      embedder: Embedder, llm: LLMInterface | None = None, extraction_schema: GraphSchema | None = None) -> dict[str, Any]:
    cfg = settings.section("extraction")
    mode = cfg.get("mode", "embed")
    docs = build_documents(settings, sem, rows)
    existing = {r["path"]: r["h"] for r in driver.execute_query(_EXISTING, database_=db)[0]}
    todo = [d for d in docs if existing.get(d.path) != d.content_hash]
    stale = set(existing) - {d.path for d in docs}
    for path in [d.path for d in todo if d.path in existing] + sorted(stale):
        driver.execute_query(_DELETE_DOC, path=path, database_=db)
    log.info("Narrative documents: %d total, %d unchanged (skipped), %d to %s", len(docs), len(docs) - len(todo), len(todo),
             "extract" if mode == "extract" else "embed")
    ok = failed = 0
    if todo:
        if mode == "extract" and llm is not None and extraction_schema is not None:
            ok, failed = asyncio.run(_extract(todo, llm, embedder, driver, db, extraction_schema, cfg))
        else:
            ok, failed = asyncio.run(_embed_only(todo, embedder, driver, db, cfg))
    entities: dict[str, int] = {}
    if mode == "extract" and extraction_schema is not None:
        labels = [nt.label for nt in extraction_schema.node_types]
        flt = " OR ".join(f"entity:`{lab}`" for lab in labels)
        driver.execute_query(f"MATCH (entity:__Entity__) WHERE ({flt}) AND entity.name IS NOT NULL "
                             "SET entity.name = toLower(trim(entity.name))", database_=db)
        stats = asyncio.run(SinglePropertyExactMatchResolver(driver, filter_query=f"WHERE {flt}", neo4j_database=db).run())
        log.info("Entity resolution: %s considered, %s after merge", stats.number_of_nodes_to_resolve, stats.number_of_created_nodes)
        entities = {lab: driver.execute_query(f"MATCH (n:`{lab}`) RETURN count(n) AS c", database_=db)[0][0]["c"] for lab in labels}
    for t in sem.tables.values():
        driver.execute_query(
            f"MATCH (d:Document {{source_label: $label}}) MATCH (n:`{t.label}`) WHERE toString(n.`{t.primary_key}`) = d.source_id "
            "MERGE (n)-[:HAS_NARRATIVE]->(d)", label=t.label, database_=db)
    if mode == "extract":
        driver.execute_query("MATCH (n)-[:HAS_NARRATIVE]->(:Document)<-[:FROM_DOCUMENT]-(:Chunk)<-[:FROM_CHUNK]-(e:__Entity__) "
                             "MERGE (n)-[:MENTIONS]->(e)", database_=db)
    chunks = driver.execute_query("MATCH (c:Chunk) RETURN count(c) AS c", database_=db)[0][0]["c"]
    log.info("Lexical graph: %d chunks; %d documents written, %d failed", chunks, ok, failed)
    return {"mode": mode, "documents": len(docs), "written": ok, "failed": failed, "skipped": len(docs) - len(todo),
            "chunks": chunks, "entities": entities}
