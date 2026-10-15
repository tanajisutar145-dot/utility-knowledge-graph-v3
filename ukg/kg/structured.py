"""Deterministic structured load (no LLM).

Rows -> ``Neo4jGraph`` (``Neo4jNode`` / ``Neo4jRelationship``) following the
semantic model, written in batches with ``MergingNeo4jWriter``:

* one node per row, labelled with its ontology class (``Feeder``...) plus the
  standard labels (``CIM_Feeder``, ``CIM_EquipmentContainer``...); properties =
  the row's non-NULL mapped columns, ``caption``, and the standard alignment
  (``cim_class``, ``cim_match``, ``cim_package``, ``cim_standard``,
  ``subject_area``, ``source_table``);
* one relationship per non-NULL FK value, typed with the FK's ontology object
  property and carrying ``fk_column`` and the standard association role;
* one relationship per resolvable **polymorphic reference**
  (``graph.polymorphic_links``: a table-name column + an id column, e.g.
  ``gis.terminal.conducting_equipment_*``). Unresolvable references are
  counted and reported (they are data-quality findings, not load errors).

Uniqueness constraints on every primary key are created first, and node and
relationship counts are verified against the input rows afterwards.
"""

from __future__ import annotations

import asyncio
import logging
from collections import Counter
from typing import Any

import neo4j
from neo4j_graphrag.components.schema import GraphSchema
from neo4j_graphrag.components.types import Neo4jGraph, Neo4jNode, Neo4jRelationship

from ukg.kg.captions import Captioner
from ukg.kg.writer import MergingNeo4jWriter
from ukg.model.data import Rows
from ukg.ontology.extract import SemanticModel
from ukg.settings import Settings

log = logging.getLogger(__name__)


def node_id(label: str, pk: Any) -> str:
    return f"{label}:{pk}"


def create_constraints(driver: neo4j.Driver, schema: GraphSchema, db: str) -> None:
    """UNIQUENESS constraints declared in the graph schema (idempotent)."""
    for c in schema.constraints:
        prop = c.property_names[0]
        name = f"{c.node_type.lower()}_{prop}_unique"
        driver.execute_query(
            f"CREATE CONSTRAINT {name} IF NOT EXISTS FOR (n:`{c.node_type}`) REQUIRE n.`{prop}` IS UNIQUE", database_=db)
    log.info("Ensured %d uniqueness constraints", len(schema.constraints))


def standard_labels(settings: Settings, sem: SemanticModel) -> dict[str, list[str]]:
    cfg = settings.section("graph").get("standard_labels") or {}
    if not cfg.get("enabled"):
        return {}
    prefix = cfg.get("prefix", "CIM_")
    out = {}
    for t in sem.tables.values():
        names = ([t.standard_class] if t.standard_class else []) + (t.standard_ancestors if cfg.get("ancestors") else [])
        out[t.label] = [prefix + n for n in dict.fromkeys(names) if n and n != sem.standard.get("root_class")]
    return out


def _table_index(sem: SemanticModel) -> dict[str, str]:
    """Accepts 'schema.table' or bare 'table' (when unique) as polymorphic table names."""
    idx = {tid: tid for tid in sem.tables}
    names = Counter(t.table for t in sem.tables.values())
    idx.update({t.table: tid for tid, t in sem.tables.items() if names[t.table] == 1})
    return idx


def build_graph(settings: Settings, sem: SemanticModel, rows: Rows) -> tuple[Neo4jGraph, dict[str, Any]]:
    """Map typed rows to a ``Neo4jGraph`` according to the semantic model."""
    gcfg = settings.section("graph")
    captioner = Captioner(settings, sem)
    std_props = gcfg.get("standard_properties", True)
    nodes: list[Neo4jNode] = []
    pk_sets: dict[str, set[Any]] = {}
    for tid, tmap in sem.tables.items():
        cols = [c.column for c in tmap.columns]
        pk_sets[tid] = set()
        meta = {}
        if std_props:
            meta = {"cim_class": tmap.standard_class, "cim_match": tmap.standard_match, "cim_package": tmap.standard_package,
                    "cim_standard": tmap.standard_standard, "subject_area": tmap.schema, "source_table": tid}
            meta = {k: v for k, v in meta.items() if v is not None}
        for row in rows[tid]:
            pk = row[tmap.primary_key]
            pk_sets[tid].add(pk)
            props = {c: row[c] for c in cols if row.get(c) is not None}
            props["caption"] = captioner.caption(tmap.label, props)
            props.update(meta)
            nodes.append(Neo4jNode(id=node_id(tmap.label, pk), label=tmap.label, properties=props))

    rels: list[Neo4jRelationship] = []
    for r in sem.relationships:
        src, dst = sem.tables[r.from_table], sem.tables[r.to_table]
        extra = {"fk_column": f"{r.from_table}.{r.from_column}"}
        if r.standard_association:
            extra["cim_association"] = r.standard_association
        for row in rows[r.from_table]:
            value = row.get(r.from_column)
            if value is None:
                continue
            rels.append(Neo4jRelationship(start_node_id=node_id(src.label, row[src.primary_key]),
                                          end_node_id=node_id(dst.label, value), type=r.rel_type, properties=dict(extra)))

    index = _table_index(sem)
    unresolved: dict[str, list[Any]] = {}
    for p in gcfg.get("polymorphic_links", []):
        if p["table"] not in sem.tables:
            continue
        src = sem.tables[p["table"]]
        miss: list[Any] = []
        for row in rows[p["table"]]:
            name, value = row.get(p["table_column"]), row.get(p["id_column"])
            if not name or value in (None, 0):
                continue
            if p.get("schema_column") and row.get(p["schema_column"]):
                name = f"{row[p['schema_column']]}.{name}"
            target = index.get(name)
            if target is None or value not in pk_sets[target]:
                miss.append({"from": row[src.primary_key], "table": name, "id": value})
                continue
            rels.append(Neo4jRelationship(
                start_node_id=node_id(src.label, row[src.primary_key]), end_node_id=node_id(sem.label(target), value),
                type=p["type"], properties={"fk_column": f"{p['table']}.{p['table_column']}+{p['id_column']}",
                                            "polymorphic": True, "cim_association": p.get("cim_association", "")}))
        if miss:
            unresolved[f"{p['table']} -[{p['type']}]->"] = miss
    for k, v in unresolved.items():
        log.warning("Polymorphic link %s: %d references point to records that do not exist (data-quality finding), e.g. %s",
                    k, len(v), v[0])
    return Neo4jGraph(nodes=nodes, relationships=rels), {"unresolved_polymorphic": unresolved}


def load_structured(settings: Settings, driver: neo4j.Driver, db: str, schema: GraphSchema, sem: SemanticModel,
                    rows: Rows) -> dict[str, Any]:
    """Create constraints, write the graph, then verify counts against the input rows."""
    create_constraints(driver, schema, db)
    graph, info = build_graph(settings, sem, rows)
    writer = MergingNeo4jWriter(driver, merge_keys={t.label: t.primary_key for t in sem.tables.values()},
                                extra_labels=standard_labels(settings, sem), neo4j_database=db,
                                batch_size=int(settings.section("graph").get("batch_size", 500)))
    result = asyncio.run(writer.run(graph))
    if result.status != "SUCCESS":
        raise SystemExit(f"Structured load failed: {result.metadata}")

    expected_nodes = Counter(n.label for n in graph.nodes)
    expected_rels = Counter(r.type for r in graph.relationships)
    actual_nodes = {lab: driver.execute_query(f"MATCH (n:`{lab}`) RETURN count(n) AS c", database_=db)[0][0]["c"]
                    for lab in expected_nodes}
    actual_rels = {t: driver.execute_query(f"MATCH ()-[r:`{t}`]->() WHERE r.fk_column IS NOT NULL RETURN count(r) AS c",
                                           database_=db)[0][0]["c"] for t in expected_rels}
    mismatches = [f"{k}: expected {v}, found {actual_nodes[k]}" for k, v in expected_nodes.items() if actual_nodes[k] != v]
    mismatches += [f"{k}: expected {v}, found {actual_rels[k]}" for k, v in expected_rels.items() if actual_rels[k] < v]
    if mismatches:
        raise SystemExit("Structured load verification failed:\n  " + "\n  ".join(mismatches))
    log.info("Structured load verified: %d nodes (%d labels), %d relationships (%d types) - counts match the input rows",
             sum(expected_nodes.values()), len(expected_nodes), sum(expected_rels.values()), len(expected_rels))
    return {"nodes": dict(expected_nodes), "relationships": dict(expected_rels),
            "unresolved_polymorphic": {k: len(v) for k, v in info["unresolved_polymorphic"].items()},
            "unresolved_examples": {k: v[:5] for k, v in info["unresolved_polymorphic"].items()}}
