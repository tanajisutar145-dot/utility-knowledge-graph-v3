"""Semantic layer: the ontology and its standard (IEC CIM) alignment as graph nodes.

Loaded next to the data so the standard is queryable and visible:

    (:OntologyClass {name: 'Feeder'})-[:SPECIALIZES {match: 'exact'}]->(:CimClass {name: 'Feeder'})
    (:CimClass)-[:SUBCLASS_OF]->(:CimClass {name: 'EquipmentContainer'}) ... -> IdentifiedObject
    (:OntologyClass)-[:HAS_PROPERTY]->(:OntologyProperty {column: 'nominal_voltage_kv', unit: 'kV'})
                    -[:MAPS_TO {match: 'close'}]->(:CimAttribute {name: 'BaseVoltage.nominalVoltage'})
    (:OntologyClass)-[:IN_SUBJECT_AREA]->(:SubjectArea {name: 'distribution'})
    (:OntologyClass)-[:ASSOCIATION {rel_type, cim_association}]->(:OntologyClass)
    (data node)-[:INSTANCE_OF]->(:OntologyClass)
"""

from __future__ import annotations

import logging
from typing import Any

import neo4j

from ukg.ontology.extract import SemanticModel
from ukg.settings import Settings

log = logging.getLogger(__name__)

SEMANTIC_LABELS = ("OntologyClass", "CimClass", "OntologyProperty", "CimAttribute", "SubjectArea")


def load_semantic_layer(settings: Settings, driver: neo4j.Driver, db: str, sem: SemanticModel) -> dict[str, int]:
    cfg = settings.section("graph").get("semantic_layer") or {}
    if not cfg.get("enabled", True):
        return {}
    q = lambda cypher, **p: driver.execute_query(cypher, p, database_=db)  # noqa: E731
    for label, key in (("OntologyClass", "name"), ("CimClass", "name"), ("OntologyProperty", "key"),
                       ("CimAttribute", "name"), ("SubjectArea", "name")):
        q(f"CREATE CONSTRAINT {label.lower()}_{key}_unique IF NOT EXISTS FOR (n:{label}) REQUIRE n.{key} IS UNIQUE")
    std = sem.standard
    classes = [{"name": k, "label": v["label"], "iri": v["iri"], "comment": v["comment"], "package": v["package"],
                "standard": v["standard"], "parents": v["parents"]} for k, v in sem.standard_classes.items()]
    q("UNWIND $rows AS r MERGE (c:CimClass {name: r.name}) "
      "SET c.label = r.label, c.iri = r.iri, c.description = r.comment, c.package = r.package, c.standard = r.standard, "
      "c.namespace = $ns, c.caption = $short + ':' + r.name", rows=classes, ns=std.get("namespace"), short=std.get("short", "STD"))
    q("UNWIND $rows AS r UNWIND r.parents AS p MATCH (c:CimClass {name: r.name}) MATCH (s:CimClass {name: p}) "
      "MERGE (c)-[:SUBCLASS_OF]->(s)", rows=classes)
    areas = [{"name": k, **v} for k, v in sem.subject_areas.items()]
    q("UNWIND $rows AS r MERGE (s:SubjectArea {name: r.name}) SET s.label = r.label, s.iri = r.iri, "
      "s.definition = r.definition, s.scope_note = r.scope_note, s.caption = r.label", rows=areas)
    q("UNWIND $rows AS r UNWIND r.broader AS b MATCH (s:SubjectArea {name: r.name}) MATCH (p:SubjectArea {name: b}) "
      "MERGE (s)-[:BROADER]->(p)", rows=areas)
    tables = []
    props: list[dict[str, Any]] = []
    for t in sem.tables.values():
        tables.append({"name": t.label, "table": t.table_id, "iri": t.class_iri, "description": t.description[:400],
                       "cim_class": t.standard_class, "cim_match": t.standard_match, "cim_package": t.standard_package,
                       "cim_standard": t.standard_standard, "classification": t.data_classification,
                       "location_role": t.location_role, "areas": t.subject_areas, "columns": len(t.columns)})
        if cfg.get("properties", True):
            for c in t.columns:
                props.append({"key": f"{t.table_id}.{c.column}", "class": t.label, "column": c.column,
                              "name": c.label or c.column, "iri": c.property_iri, "description": c.description[:300],
                              "sql_type": c.sql_type, "unit": c.unit, "datatype": c.datatype, "business_term": c.business_term,
                              "cim_attribute": c.standard_attribute, "cim_match": c.standard_match,
                              "enum_values": c.enum_values[:20], "nullable": c.nullable})
    q("UNWIND $rows AS r MERGE (c:OntologyClass {name: r.name}) SET c.table = r.table, c.iri = r.iri, "
      "c.description = r.description, c.cim_class = r.cim_class, c.cim_match = r.cim_match, c.cim_package = r.cim_package, "
      "c.cim_standard = r.cim_standard, c.data_classification = r.classification, c.location_role = r.location_role, "
      "c.column_count = r.columns, c.caption = r.name "
      "WITH c, r MATCH (k:CimClass {name: r.cim_class}) MERGE (c)-[s:SPECIALIZES]->(k) SET s.match = r.cim_match", rows=tables)
    q("UNWIND $rows AS r UNWIND r.areas AS a MATCH (c:OntologyClass {name: r.name}) MATCH (s:SubjectArea {name: a}) "
      "MERGE (c)-[:IN_SUBJECT_AREA]->(s)", rows=tables)
    if props:
        q("UNWIND $rows AS r MATCH (c:OntologyClass {name: r.class}) MERGE (p:OntologyProperty {key: r.key}) "
          "SET p.column = r.column, p.name = r.name, p.iri = r.iri, p.description = r.description, p.sql_type = r.sql_type, "
          "p.unit = r.unit, p.datatype = r.datatype, p.business_term = r.business_term, p.cim_attribute = r.cim_attribute, "
          "p.cim_match = r.cim_match, p.enum_values = r.enum_values, p.nullable = r.nullable, p.caption = r.column "
          "MERGE (c)-[:HAS_PROPERTY]->(p)", rows=props)
        attrs = [{"name": k, **v} for k, v in sem.standard_attributes.items()]
        q("UNWIND $rows AS r MERGE (a:CimAttribute {name: r.name}) SET a.label = r.label, a.iri = r.iri, a.domain = r.domain, "
          "a.caption = $short + ':' + r.name WITH a, r MATCH (k:CimClass {name: r.domain}) MERGE (a)-[:ATTRIBUTE_OF]->(k)",
          rows=attrs, short=std.get("short", "STD"))
        q("UNWIND $rows AS r WITH r WHERE r.cim_attribute IS NOT NULL MATCH (p:OntologyProperty {key: r.key}) "
          "MATCH (a:CimAttribute {name: r.cim_attribute}) MERGE (p)-[m:MAPS_TO]->(a) SET m.match = r.cim_match", rows=props)
    assoc = [{"from": sem.label(r.from_table), "to": sem.label(r.to_table), "type": r.rel_type, "fk": f"{r.from_table}.{r.from_column}",
              "cim": r.standard_association} for r in sem.relationships]
    q("UNWIND $rows AS r MATCH (a:OntologyClass {name: r.from}) MATCH (b:OntologyClass {name: r.to}) "
      "MERGE (a)-[x:ASSOCIATION {fk_column: r.fk}]->(b) SET x.rel_type = r.type, x.cim_association = r.cim", rows=assoc)
    if cfg.get("instance_links", True):
        for t in sem.tables.values():
            q(f"MATCH (n:`{t.label}`) WHERE NOT n:OntologyClass MATCH (c:OntologyClass {{name: $name}}) MERGE (n)-[:INSTANCE_OF]->(c)",
              name=t.label)
    counts = {lab: driver.execute_query(f"MATCH (n:{lab}) RETURN count(n) AS c", database_=db)[0][0]["c"] for lab in SEMANTIC_LABELS}
    log.info("Semantic layer: %s", ", ".join(f"{k}={v}" for k, v in counts.items()))
    return counts


def run_derived(settings: Settings, driver: neo4j.Driver, db: str) -> dict[str, int]:
    """Derived relationships from ``graph.derived_relationships`` (each an idempotent Cypher statement)."""
    counts = {}
    for d in settings.section("graph").get("derived_relationships", []):
        with driver.session(database=db) as session:
            session.run(d["cypher"]).consume()
        counts[d["name"]] = driver.execute_query(f"MATCH ()-[r:`{d['name']}`]->() RETURN count(r) AS c", database_=db)[0][0]["c"]
    if counts:
        log.info("Derived relationships: %s", ", ".join(f"{k}={v}" for k, v in counts.items()))
    return counts
