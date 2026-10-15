"""Convert the semantic model into neo4j-graphrag ``GraphSchema`` objects and prompt text.

* **structured schema** - one ``NodeType`` per in-scope ontology class
  (properties = mapped columns, typed from the DDL, described by the ontology
  and annotated with the standard attribute they map to), one
  ``RelationshipType`` per FK object property (+ polymorphic, derived and
  spatial relationships), the ``(source, rel, target)`` patterns and a
  UNIQUENESS constraint per primary key. Used by the loader, the constraint
  setup and Text2Cypher.
* **extraction schema** - entity types the LLM may extract from narrative
  text, each *promoted* from ontology datatype properties listed in
  ``extraction.entity_types`` (validated against the ontology subset).
"""

from __future__ import annotations

import json
import logging
from typing import Any

import rdflib
from neo4j_graphrag.components.schema import (
    ConstraintType,
    GraphConstraintType,
    GraphSchema,
    NodeType,
    Pattern,
    PropertyType,
    RelationshipType,
)
from rdflib import RDFS, URIRef

from ukg.ontology.extract import SemanticModel
from ukg.settings import Settings

log = logging.getLogger(__name__)

SQL_TO_NEO4J = {
    "BIGINT": "INTEGER", "INT": "INTEGER", "INTEGER": "INTEGER", "SMALLINT": "INTEGER", "TINYINT": "INTEGER",
    "DECIMAL": "FLOAT", "NUMERIC": "FLOAT", "DOUBLE": "FLOAT", "FLOAT": "FLOAT", "REAL": "FLOAT",
    "STRING": "STRING", "VARCHAR": "STRING", "CHAR": "STRING", "TEXT": "STRING",
    "BOOLEAN": "BOOLEAN", "DATE": "DATE", "TIMESTAMP": "LOCAL_DATETIME", "TIMESTAMP_NTZ": "LOCAL_DATETIME",
}


def short(text: str | None, limit: int = 240) -> str:
    text = " ".join((text or "").split())
    return text if len(text) <= limit else text[: limit - 3].rstrip() + "..."


def neo4j_type(sql_type: str) -> str:
    return SQL_TO_NEO4J.get(sql_type.split("(")[0].upper(), "STRING")


def extra_relationships(settings: Settings, sem: SemanticModel) -> list[dict[str, Any]]:
    """Polymorphic, derived and spatial relationship types configured in config.yaml."""
    g = settings.section("graph")
    out = [{"type": p["type"], "description": f"Polymorphic link {p['table']}.{p['id_column']} "
            f"(target table named in {p['table_column']}); {p.get('cim_association', '')}".strip(),
            "source": sem.label(p["table"]) if p["table"] in sem.tables else None, "target": None}
           for p in g.get("polymorphic_links", []) if p["table"] in sem.tables]
    out += [{"type": d["name"], "description": short(d.get("description", ""), 300), "source": None, "target": None}
            for d in g.get("derived_relationships", [])]
    sp = (settings.section("gis").get("spatial_relationships") or {}) if settings.section("gis").get("enabled", True) else {}
    region = sp.get("region_table")
    if region in sem.tables:
        for key, desc in (("within_type", "entity geometry lies inside the region polygon (GeoSPARQL sfWithin)"),
                          ("intersects_type", "entity geometry crosses the region boundary (GeoSPARQL sfIntersects)")):
            if sp.get(key):
                out.append({"type": sp[key], "description": desc, "source": None, "target": sem.label(region)})
    return out


def build_structured_schema(settings: Settings, sem: SemanticModel) -> GraphSchema:
    node_types, constraints = [], []
    std = sem.standard.get("short", "STD")
    for t in sem.tables.values():
        props = []
        for c in t.columns:
            extra = f" [{std} {c.standard_attribute} ({c.standard_match})]" if c.standard_attribute else ""
            unit = f" unit {c.unit}." if c.unit else ""
            props.append(PropertyType(name=c.column, type=neo4j_type(c.sql_type),
                                      description=short(c.description, 150) + unit + extra))
        desc = short(t.description, 200)
        if t.standard_class:
            desc += f" [{std} {t.standard_class} ({t.standard_match}); {t.standard_package}; {t.standard_standard}]"
        node_types.append(NodeType(label=t.label, description=desc, properties=props, additional_properties=True))
        if t.primary_key:
            constraints.append(ConstraintType(type=GraphConstraintType.UNIQUENESS, node_type=t.label,
                                              property_names=(t.primary_key,)))
    rel_types: dict[str, RelationshipType] = {}
    patterns: list[Pattern] = []
    for r in sem.relationships:
        if r.rel_type not in rel_types:
            assoc = f" [{std} association {r.standard_association}]" if r.standard_association else ""
            rel_types[r.rel_type] = RelationshipType(label=r.rel_type, description=short(r.description, 200) + assoc,
                                                     properties=[PropertyType(name="fk_column", type="STRING")],
                                                     additional_properties=True)
        patterns.append(Pattern(source=sem.label(r.from_table), relationship=r.rel_type, target=sem.label(r.to_table)))
    for x in extra_relationships(settings, sem):
        rel_types.setdefault(x["type"], RelationshipType(label=x["type"], description=x["description"], additional_properties=True))
    schema = GraphSchema(node_types=tuple(node_types), relationship_types=tuple(rel_types.values()),
                         patterns=tuple(dict.fromkeys(patterns)), constraints=tuple(constraints),
                         additional_node_types=True, additional_relationship_types=True, additional_patterns=True)
    path = settings.build_dir / "graph_schema.json"
    path.write_text(json.dumps(schema.model_dump(mode="json"), indent=2), encoding="utf-8")
    log.info("Graph schema: %d node types, %d relationship types, %d patterns, %d constraints -> %s",
             len(schema.node_types), len(schema.relationship_types), len(schema.patterns), len(schema.constraints), path.name)
    return schema


def load_structured_schema(settings: Settings) -> GraphSchema:
    path = settings.build_dir / "graph_schema.json"
    if not path.exists():
        raise SystemExit(f"Missing {path}. Run `python -m ukg run --step model` first.")
    return GraphSchema.model_validate(json.loads(path.read_text(encoding="utf-8")))


def build_extraction_schema(settings: Settings) -> GraphSchema:
    """Entity/relationship types for LLM extraction, promoted from ontology properties."""
    cfg = settings.section("extraction")
    g = rdflib.Graph().parse(settings.build_dir / "ontology_subset.ttl", format="turtle")
    node_types = []
    for et in cfg.get("entity_types", []):
        comments = []
        for prop in et["from_ontology_properties"]:
            iri = URIRef(g.namespace_manager.expand_curie(prop)) if ":" in prop and not prop.startswith("http") else URIRef(prop)
            if (iri, None, None) not in g:
                raise SystemExit(f"Extraction type {et['label']}: ontology property '{prop}' is not in the ontology subset "
                                 "(is its table in scope?)")
            comments.append(short(str(g.value(iri, RDFS.comment) or ""), 160))
        node_types.append(NodeType(
            label=et["label"],
            description=f"Promoted from ontology properties {', '.join(et['from_ontology_properties'])}. " + " ".join(comments),
            properties=[PropertyType(name="name", type="STRING", description="Short canonical name, lower case"),
                        PropertyType(name="description", type="STRING", description="One-sentence explanation")],
            additional_properties=False))
    rels = [RelationshipType(label=r["label"], description=r.get("description", "")) for r in cfg.get("relationship_types", [])]
    patterns = [Pattern(source=s, relationship=r, target=t) for s, r, t in cfg.get("patterns", [])]
    return GraphSchema(node_types=tuple(node_types), relationship_types=tuple(rels), patterns=tuple(patterns),
                       additional_node_types=False, additional_relationship_types=False, additional_patterns=False)


def schema_as_text(settings: Settings, schema: GraphSchema, sem: SemanticModel, populated: dict[str, set[str]] | None = None,
                   extraction: GraphSchema | None = None, has_chunks: bool = False) -> str:
    """Compact schema description for Text2Cypher prompts (with the standard alignment of each label)."""
    std = sem.standard.get("short", "STD")
    gcfg = settings.section("graph")
    lines = ["Node labels (standard class in brackets) and properties:"]
    for nt in schema.node_types:
        t = sem.by_label(nt.label)
        keep = [p for p in nt.properties if populated is None or p.name in populated.get(nt.label, set())]
        props = ", ".join(f"{p.name}: {p.type}" for p in keep)
        tag = f" [{std} {t.standard_class}]" if t and t.standard_class else ""
        lines.append(f"(:{nt.label}{tag} {{{props}}})")
    if gcfg.get("standard_properties", True):
        lines.append(f"Every data node also has: cim_class, cim_match, cim_package, cim_standard, subject_area, source_table "
                     f"(strings), and mrid ({std} IdentifiedObject.mRID).")
    sl = gcfg.get("standard_labels") or {}
    if sl.get("enabled"):
        lines.append(f"Every data node also carries {std} labels '{sl.get('prefix', 'CIM_')}<Class>' for its {std} class"
                     + (" and its superclasses" if sl.get("ancestors") else "")
                     + f", e.g. (:{sl.get('prefix', 'CIM_')}PowerTransformer) matches distribution and power transformers.")
    gis = settings.section("gis")
    if gis.get("enabled", True):
        lines.append(f"Located nodes have {gis.get('point_property', 'geo_point')}: POINT (WGS84). Distance in metres: "
                     f"point.distance(a.{gis.get('point_property', 'geo_point')}, point({{latitude: 38.6, longitude: -121.0}})).")
    if gcfg.get("semantic_layer", {}).get("enabled"):
        lines.append(f"Semantic layer: (:OntologyClass {{name, label, table, cim_class, cim_match}})-[:SPECIALIZES]->(:CimClass {{name, package, standard}})"
                     f"-[:SUBCLASS_OF]->(:CimClass); (:OntologyClass)-[:HAS_PROPERTY]->(:OntologyProperty {{name, column, unit, cim_attribute, cim_match}})"
                     f"-[:MAPS_TO]->(:CimAttribute {{name}}); (:OntologyClass)-[:IN_SUBJECT_AREA]->(:SubjectArea {{name, label}}); "
                     f"(data node)-[:INSTANCE_OF]->(:OntologyClass).")
    if extraction is not None:
        lines.append("Text-derived entity labels (property `name` is lower case):")
        for nt in extraction.node_types:
            lines.append(f"(:{nt.label} {{name: STRING, description: STRING}})")
    if has_chunks:
        lines.append("(:Document {path, source_label, source_key, source_id}), (:Chunk {text, index}); "
                     "(data node)-[:HAS_NARRATIVE]->(:Document)<-[:FROM_DOCUMENT]-(:Chunk)")
    lines.append("Relationships (direction matters: FK holder -> referenced row):")
    for p in schema.patterns:
        lines.append(f"(:{p.source})-[:{p.relationship}]->(:{p.target})")
    for x in extra_relationships(settings, sem):
        src = f":{x['source']}" if x.get("source") else ""
        dst = f":{x['target']}" if x.get("target") else ""
        lines.append(f"({src})-[:{x['type']}]->({dst})  // {short(x['description'], 160)}")
    if extraction is not None:
        for p in extraction.patterns:
            lines.append(f"(:{p.source})-[:{p.relationship}]->(:{p.target})")
        lines.append("(data node)-[:MENTIONS]->(text-derived entity)")
    return "\n".join(lines)
