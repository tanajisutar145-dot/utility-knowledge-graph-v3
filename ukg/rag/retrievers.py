"""Retriever construction: VectorCypher, HybridCypher and Text2Cypher.

The two vector-based retrievers start from narrative chunks and then walk the
graph with a *retrieval query*. The queries are generated from
``rag.templates`` in config.yaml, so they work for any model:

* ``neighbourhood`` - the chunk's source row and its one-hop neighbours (FK,
  polymorphic and derived relationships);
* ``paths`` - paths of up to ``max_hops`` over the listed relationship types
  (e.g. ``causal_chain``: inspection -> failure -> outage -> work orders;
  ``topology``: FEEDS / feeder / substation);
* ``peers`` - the source row's member record (e.g. its asset), the hub it
  belongs to (e.g. its asset class) and every other member of that hub with
  the events recorded against them (``class_peers``).

Every node in the returned context is rendered as ``Label caption [CIM class]
{key properties}`` so the LLM sees the standard alignment of each record.
"""

from __future__ import annotations

import json
import logging
import re
from typing import Any

import neo4j
from neo4j_graphrag.embeddings import Embedder
from neo4j_graphrag.llm import LLMInterface
from neo4j_graphrag.retrievers import HybridCypherRetriever, Text2CypherRetriever, VectorCypherRetriever
from neo4j_graphrag.retrievers.base import Retriever
from neo4j_graphrag.types import RetrieverResultItem

from ukg.kg.captions import Captioner, primary_label_expr
from ukg.ontology.extract import SemanticModel
from ukg.settings import Settings

log = logging.getLogger(__name__)

RETRIEVERS = ("vector_cypher", "hybrid_cypher", "text2cypher")
_LUCENE_SPECIAL = re.compile(r'([+\-&|!(){}\[\]^"~*?:\\/])')


class SafeHybridCypherRetriever(HybridCypherRetriever):
    """``HybridCypherRetriever`` that escapes Lucene syntax in the full-text half."""

    def get_search_results(self, query_text: str, query_vector: list[float] | None = None, **kwargs: Any):  # type: ignore[override]
        if query_vector is None and self.embedder is not None:
            query_vector = self.embedder.embed_query(query_text)
        escaped = _LUCENE_SPECIAL.sub(r"\\\1", query_text)
        return super().get_search_results(escaped, query_vector=query_vector, **kwargs)


def _rels(names: list[str]) -> str:
    return "|".join(f"`{n}`" for n in names)


class CypherFragments:
    """Reusable Cypher expressions derived from config + the semantic model."""

    def __init__(self, settings: Settings, sem: SemanticModel):
        self.captioner = Captioner(settings, sem)
        self.summary = self.captioner.summary
        self.std_prefix = self.captioner.std_prefix
        self.std_short = sem.standard.get("short", "STD")
        self.templates: dict[str, dict[str, Any]] = settings.section("rag").get("templates", {}) or {
            "neighbourhood": {"type": "neighbourhood"}}

    def label(self, v: str) -> str:
        return primary_label_expr(v, self.std_prefix)

    def caption(self, v: str) -> str:
        return f"{self.label(v)} + ' ' + toString(coalesce({v}.caption, {v}.name, {v}.path, ''))"

    def summary_map(self) -> str:
        return "{" + ", ".join(f"`{lbl}`: {json.dumps(props)}" for lbl, props in self.summary.items()) + "}"

    def summarize(self, v: str) -> str:
        return (f"{self.caption(v)} + coalesce(' [{self.std_short} ' + {v}.cim_class + ']', '') + ' ' + "
                f"apoc.convert.toJson(apoc.map.submap(properties({v}), coalesce(summary[{self.label(v)}], []), null, false))")

    def path_string(self, p: str) -> str:
        n0 = self.caption(f"nodes({p})[0]")
        step = (f"CASE WHEN startNode(relationships({p})[i]) = nodes({p})[i] "
                f"THEN ' -[:' + type(relationships({p})[i]) + ']-> ' "
                f"ELSE ' <-[:' + type(relationships({p})[i]) + ']- ' END + {self.caption(f'nodes({p})[i+1]')}")
        return f"reduce(s = {n0}, i IN range(0, length({p}) - 1) | s + {step})"

    def _head(self) -> str:
        return (f"WITH node, score, {self.summary_map()} AS summary\n"
                "MATCH (node)-[:FROM_DOCUMENT]->(d:Document)\n"
                "OPTIONAL MATCH (d)<-[:HAS_NARRATIVE]-(src)\n")

    # -- template types ---------------------------------------------------------------
    def neighbourhood(self, cfg: dict[str, Any]) -> str:
        limit = int(cfg.get("limit", 25))
        return (self._head() +
                "OPTIONAL MATCH (src)-[r]-(nb) WHERE (r.fk_column IS NOT NULL OR r.derived) AND NOT nb:GisLocation\n"
                f"WITH node, score, summary, src, collect(DISTINCT type(r) + ': ' + {self.summarize('nb')})[..{limit}] AS neighbours\n"
                f"RETURN {self.summarize('src')} AS source, node.text AS chunk, neighbours, [] AS paths, score")

    def paths(self, cfg: dict[str, Any]) -> str:
        rels, hops = _rels(cfg["relationships"]), int(cfg.get("max_hops", 4))
        return (self._head() +
                f"OPTIONAL MATCH p = (src)-[:{rels}*1..{hops}]-(x)\n"
                "WITH node, score, summary, src, p ORDER BY length(p) DESC\n"
                "WITH node, score, summary, src, collect(p)[..12] AS ps\n"
                "WITH node, score, summary, src, ps, apoc.coll.toSet(apoc.coll.flatten([q IN ps | nodes(q)])) AS pathNodes\n"
                f"RETURN {self.summarize('src')} AS source, node.text AS chunk,\n"
                f"       [q IN ps | {self.path_string('q')}] AS paths,\n"
                f"       [n IN pathNodes | {self.summarize('n')}][..25] AS neighbours, score")

    def peers(self, cfg: dict[str, Any]) -> str:
        member, hub = cfg["member_label"], cfg["hub_label"]
        src_rels, hub_rels, ev_rels = _rels(cfg["source_member_rels"]), _rels(cfg["member_hub_rels"]), _rels(cfg["event_rels"])
        return (self._head() +
                f"OPTIONAL MATCH (src)-[:{src_rels}]-(m:`{member}`)\n"
                f"WITH node, score, summary, src, coalesce(m, CASE WHEN src:`{member}` THEN src END) AS member\n"
                f"OPTIONAL MATCH (member)-[:{hub_rels}]->(h:`{hub}`)<-[:{hub_rels}]-(peer:`{member}`) WHERE peer <> member\n"
                f"OPTIONAL MATCH (peer)<-[:{ev_rels}]-(ev) WHERE (ev)-[:HAS_NARRATIVE]->()\n"
                "WITH node, score, summary, src, member, h, peer, ev\n"
                f"WITH node, score, summary, src, member, h, collect(DISTINCT {self.caption('peer')} + ' | ' + "
                f"coalesce({self.summarize('ev')}, 'no events'))[..25] AS peers\n"
                f"RETURN {self.summarize('src')} AS source, node.text AS chunk,\n"
                f"       ['MEMBER ' + coalesce({self.summarize('member')}, 'n/a') + ' | {hub.upper()} ' + coalesce({self.caption('h')}, 'n/a')] AS paths,\n"
                "       peers AS neighbours, score")

    def template(self, name: str) -> str:
        cfg = self.templates.get(name) or self.templates.get("neighbourhood") or {"type": "neighbourhood"}
        return {"neighbourhood": self.neighbourhood, "paths": self.paths, "peers": self.peers}[cfg.get("type", "neighbourhood")](cfg)


def format_chunk_record(record: neo4j.Record) -> RetrieverResultItem:
    parts = [f"SOURCE ROW: {record.get('source')}", f"NARRATIVE: {record.get('chunk')}"]
    if record.get("paths"):
        parts.append("GRAPH PATHS:\n  " + "\n  ".join(record["paths"]))
    if record.get("neighbours"):
        parts.append("RELATED RECORDS:\n  " + "\n  ".join(record["neighbours"]))
    return RetrieverResultItem(content="\n".join(parts),
                               metadata={"score": record.get("score"), "source": record.get("source"), "paths": record.get("paths") or []})


def format_cypher_record(record: neo4j.Record) -> RetrieverResultItem:
    return RetrieverResultItem(content=json.dumps(record.data(), default=str), metadata={})


def build_retriever(name: str, settings: Settings, driver: neo4j.Driver, db: str, llm: LLMInterface, embedder: Embedder,
                    fragments: CypherFragments, template: str, schema_text: str, examples: list[str]
                    ) -> tuple[Retriever, dict[str, Any], str]:
    """Return ``(retriever, retriever_config, retrieval_query_or_empty)``."""
    idx = settings.section("indexes")
    top_k = int(settings.section("rag").get("top_k", 5))
    if name == "vector_cypher":
        query = fragments.template(template)
        r = VectorCypherRetriever(driver, index_name=idx["vector"]["name"], retrieval_query=query, embedder=embedder,
                                  result_formatter=format_chunk_record, neo4j_database=db)
        return r, {"top_k": top_k}, query
    if name == "hybrid_cypher":
        query = fragments.template(template)
        r = SafeHybridCypherRetriever(driver, vector_index_name=idx["vector"]["name"], fulltext_index_name=idx["fulltext"]["name"],
                                      retrieval_query=query, embedder=embedder, result_formatter=format_chunk_record, neo4j_database=db)
        return r, {"top_k": top_k}, query
    if name == "text2cypher":
        r = Text2CypherRetriever(driver, llm=llm, neo4j_schema=schema_text, examples=examples,
                                 result_formatter=format_cypher_record, neo4j_database=db)
        return r, {}, ""
    raise ValueError(f"Unknown retriever '{name}' (expected one of {RETRIEVERS})")
