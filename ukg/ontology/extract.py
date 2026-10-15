"""Extract the in-scope semantic model from the input ontology (TTL).

For every in-scope table the extractor resolves:

* the **ontology class** (``class_resolution``: the ``physical_table``
  annotation, else ``PascalCase(table)``);
* its **standard alignment** (IEC CIM by default): the standard superclass, its
  ancestor chain, mapping level (exact/close/broad/extension), package and
  standard (e.g. ``Feeder`` -> ``cim:Feeder``, IEC61970::Core, IEC 61970-301);
* its subject areas (``dcterms:subject`` -> SKOS concepts);
* every **column** -> datatype property (``physical_column`` annotation on the
  class or one of its ancestors, else naming conventions) with description,
  business term, unit and the standard attribute it maps to
  (``cmm:cimCloseMatch cim:BaseVoltage.nominalVoltage``...);
* every **in-scope FK** -> object property (``fk_constraint`` annotation, else
  ``physical_column`` + range, else naming), the relationship type and the
  standard association role (``cmm:cimAssociation``).

Nothing is hard-coded to the CMM: the annotation names, namespaces and
resolution order come from ``config.yaml`` -> ``ontology``. Classes or
properties missing from the ontology degrade gracefully (the table is still
loaded, with a warning and without standard alignment).

Outputs (``output.build_dir``): ``semantic_model.json`` (single source of truth
for the loader, retrievers and UI) and ``ontology_subset.ttl`` (the classes,
properties, standard classes/attributes and subject areas actually used,
re-parsed to validate).
"""

from __future__ import annotations

import json
import logging
import re
import time
from collections import Counter, defaultdict
from dataclasses import asdict, dataclass, field
from pathlib import Path
from typing import Any

import rdflib
from rdflib import OWL, RDF, RDFS, SKOS, Literal, URIRef

from ukg.model.ddl import DataModel
from ukg.settings import Settings

log = logging.getLogger(__name__)
VANN = rdflib.Namespace("http://purl.org/vocab/vann/")


# ---------------------------------------------------------------------------
# naming helpers
# ---------------------------------------------------------------------------
def camel(snake: str) -> str:
    head, *tail = snake.split("_")
    return head + "".join(t[:1].upper() + t[1:] for t in tail)


def pascal(snake: str) -> str:
    return "".join(t[:1].upper() + t[1:] for t in snake.split("_"))


def upper_snake(name: str) -> str:
    return re.sub(r"(?<=[a-z0-9])(?=[A-Z])", "_", name).upper()


def local(iri: str | URIRef | None) -> str:
    if iri is None:
        return ""
    s = str(iri)
    return s.rsplit("#", 1)[-1] if "#" in s else s.rstrip("/").rsplit("/", 1)[-1]


# ---------------------------------------------------------------------------
# model
# ---------------------------------------------------------------------------
@dataclass
class ColumnMap:
    column: str
    sql_type: str
    nullable: bool
    property_iri: str | None = None
    label: str = ""
    description: str = ""
    business_term: str | None = None
    standard_attribute: str | None = None      # e.g. "BaseVoltage.nominalVoltage"
    standard_match: str | None = None          # exact | close | broad | surrogate-key | association | ...
    datatype: str | None = None                # standard datatype (Voltage, ActivePower...)
    unit: str | None = None                    # e.g. "kV"
    enum_values: list[str] = field(default_factory=list)
    sensitivity: list[str] = field(default_factory=list)
    resolution: str = ""


@dataclass
class RelationshipMap:
    fk_name: str
    from_table: str
    from_column: str
    to_table: str
    to_column: str
    rel_type: str
    property_iri: str | None
    standard_association: str | None
    description: str
    resolution: str
    cross_domain: bool


@dataclass
class TableMap:
    table_id: str
    schema: str
    table: str
    label: str
    class_iri: str | None
    primary_key: str
    description: str = ""
    standard_class: str | None = None          # e.g. "Feeder"
    standard_match: str | None = None
    standard_package: str | None = None
    standard_standard: str | None = None
    standard_ancestors: list[str] = field(default_factory=list)  # nearest first, excluding the root
    subject_areas: list[str] = field(default_factory=list)
    data_classification: str | None = None
    location_role: str | None = None
    standard_reference: str | None = None
    columns: list[ColumnMap] = field(default_factory=list)
    resolution: str = ""

    def column(self, name: str) -> ColumnMap | None:
        return next((c for c in self.columns if c.column == name), None)


@dataclass
class SemanticModel:
    namespace: str
    standard: dict[str, Any]
    tables: dict[str, TableMap]
    relationships: list[RelationshipMap]
    standard_classes: dict[str, dict[str, Any]] = field(default_factory=dict)
    standard_attributes: dict[str, dict[str, Any]] = field(default_factory=dict)
    subject_areas: dict[str, dict[str, Any]] = field(default_factory=dict)
    schemas: dict[str, str] = field(default_factory=dict)
    sources: dict[str, Any] = field(default_factory=dict)

    # -- lookups -----------------------------------------------------------------
    def label(self, table_id: str) -> str:
        return self.tables[table_id].label

    def by_label(self, label: str) -> TableMap | None:
        return next((t for t in self.tables.values() if t.label == label), None)

    @property
    def labels(self) -> list[str]:
        return [t.label for t in self.tables.values()]

    def to_json(self) -> dict[str, Any]:
        return {
            "namespace": self.namespace, "standard": self.standard, "schemas": self.schemas, "sources": self.sources,
            "tables": {k: asdict(v) for k, v in self.tables.items()},
            "relationships": [asdict(r) for r in self.relationships],
            "standard_classes": self.standard_classes, "standard_attributes": self.standard_attributes,
            "subject_areas": self.subject_areas,
        }

    @classmethod
    def from_json(cls, data: dict[str, Any]) -> "SemanticModel":
        tables = {k: TableMap(**{**v, "columns": [ColumnMap(**c) for c in v["columns"]]}) for k, v in data["tables"].items()}
        return cls(data["namespace"], data["standard"], tables, [RelationshipMap(**r) for r in data["relationships"]],
                   data.get("standard_classes", {}), data.get("standard_attributes", {}), data.get("subject_areas", {}),
                   data.get("schemas", {}), data.get("sources", {}))

    @classmethod
    def load(cls, settings: Settings) -> "SemanticModel":
        path = settings.build_dir / "semantic_model.json"
        if not path.exists():
            raise SystemExit(f"Missing {path}. Run `python -m ukg run --step model` first.")
        return cls.from_json(json.loads(path.read_text(encoding="utf-8")))


# ---------------------------------------------------------------------------
# extractor
# ---------------------------------------------------------------------------
class OntologyExtractor:
    def __init__(self, settings: Settings):
        self.settings = settings
        self.cfg = settings.section("ontology")
        self.g = rdflib.Graph()
        files = [settings.path(p) for p in settings.section("input").get("ontology", [])]
        if not files:
            raise SystemExit("input.ontology lists no TTL files")
        t0 = time.perf_counter()
        for f in files:
            if not f.exists():
                raise SystemExit(f"Ontology file not found: {f}")
            log.info("Parsing ontology %s (%.1f MB)", f.name, f.stat().st_size / 1e6)
            self.g.parse(f, format="turtle" if f.suffix.lower() in (".ttl", ".n3") else None)
        self.files = files
        log.info("Ontology parsed: %d triples in %.1fs", len(self.g), time.perf_counter() - t0)
        self.ann = {k: self.term(v) for k, v in (self.cfg.get("annotations") or {}).items()}
        self.matches = {self.term(k): v for k, v in (self.cfg.get("standard_matches") or {}).items()}
        std = self.cfg.get("standard") or {}
        self.std_ns = std.get("namespace") or ""
        self.std_root = std.get("root_class", "")
        self.generic_roots = {self.term(x) for x in self.cfg.get("generic_roots", [])}
        self.ns = self._namespace()
        log.info("Ontology namespace: %s; standard namespace: %s", self.ns, self.std_ns or "(none)")
        self._index()

    # -- vocabulary ----------------------------------------------------------------
    def term(self, name: str) -> URIRef:
        if name.startswith("http://") or name.startswith("https://") or name.startswith("urn:"):
            return URIRef(name)
        try:
            return URIRef(self.g.namespace_manager.expand_curie(name))
        except (ValueError, TypeError) as exc:
            raise SystemExit(f"Cannot expand '{name}': prefix not declared in the ontology files") from exc

    def _namespace(self) -> str:
        configured = self.cfg.get("namespace", "auto")
        if configured and configured != "auto":
            return configured
        classes = [str(c) for c in set(self.g.subjects(RDF.type, OWL.Class)) | set(self.g.subjects(RDF.type, RDFS.Class))
                   if isinstance(c, URIRef)]
        counts = Counter(c.rsplit("#", 1)[0] + "#" if "#" in c else c.rsplit("/", 1)[0] + "/" for c in classes)
        declared = [str(o) for o in self.g.objects(None, VANN.preferredNamespaceUri)]
        candidates = [d for d in declared if d != self.std_ns] or [n for n, _ in counts.most_common() if n != self.std_ns]
        if not candidates:
            raise SystemExit("Cannot determine the ontology namespace; set ontology.namespace in config.yaml")
        return max(candidates, key=lambda n: counts.get(n, 0))

    def _index(self) -> None:
        g = self.g
        self.classes = {c for c in set(g.subjects(RDF.type, OWL.Class)) | set(g.subjects(RDF.type, RDFS.Class))
                        if isinstance(c, URIRef)}
        self.by_physical_table: dict[str, URIRef] = {}
        if "physical_table" in self.ann:
            for s, o in g.subject_objects(self.ann["physical_table"]):
                self.by_physical_table[str(o).lower()] = s
        self.by_domain_column: dict[tuple[URIRef, str], URIRef] = {}
        if "physical_column" in self.ann:
            for s, o in g.subject_objects(self.ann["physical_column"]):
                for d in g.objects(s, RDFS.domain):
                    self.by_domain_column[(d, str(o))] = s
        self.by_fk: dict[str, URIRef] = {}
        if "fk_constraint" in self.ann:
            for s, o in g.subject_objects(self.ann["fk_constraint"]):
                self.by_fk[str(o)] = s

    def val(self, s: URIRef, key: str) -> str | None:
        p = self.ann.get(key)
        if p is None:
            return None
        v = self.g.value(s, p)
        return str(v) if v is not None else None

    def vals(self, s: URIRef, key: str) -> list[str]:
        p = self.ann.get(key)
        return [str(v) for v in self.g.objects(s, p)] if p is not None else []

    def text(self, s: URIRef, pred: URIRef) -> str:
        values = list(self.g.objects(s, pred))
        en = [v for v in values if isinstance(v, Literal) and v.language in (None, "en")]
        return str((en or values or [""])[0])

    def is_std(self, iri: URIRef | None) -> bool:
        return bool(iri is not None and self.std_ns and str(iri).startswith(self.std_ns))

    def ancestors(self, cls: URIRef) -> list[URIRef]:
        out, frontier = [], [cls]
        while frontier:
            nxt = []
            for c in frontier:
                for p in self.g.objects(c, RDFS.subClassOf):
                    if isinstance(p, URIRef) and p not in out:
                        out.append(p)
                        nxt.append(p)
            frontier = nxt
        return out

    def std_match_of(self, s: URIRef) -> tuple[URIRef | None, str | None]:
        """(standard term, match level) from the standard-match annotations on ``s``."""
        for pred, level in self.matches.items():
            o = self.g.value(s, pred)
            if o is not None:
                return (o if isinstance(o, URIRef) else None), level
        return None, None

    # -- resolution ------------------------------------------------------------------
    def resolve_class(self, schema: str, table: str) -> tuple[URIRef | None, str]:
        for how in self.cfg.get("class_resolution", ["annotation", "pascal_case"]):
            if how == "annotation" and self.by_physical_table:
                for key in (f"{schema}.{table}".lower(), table.lower()):
                    hit = next((c for v, c in self.by_physical_table.items() if v == key or v.endswith("." + key)), None)
                    if hit is not None:
                        return hit, f"annotation {local(self.ann['physical_table'])}"
            elif how == "pascal_case":
                for name in (pascal(table), pascal(f"{schema}_{table}")):
                    iri = URIRef(self.ns + name)
                    if iri in self.classes:
                        return iri, f"naming: PascalCase -> {name}"
        return None, "not found"

    def resolve_property(self, cls: URIRef | None, ancestors: list[URIRef], column: str) -> tuple[URIRef | None, str]:
        if cls is None:
            return None, "no class"
        for how in self.cfg.get("property_resolution", ["annotation", "class_dot_camel", "camel_case"]):
            if how == "annotation":
                for owner in [cls, *ancestors]:
                    hit = self.by_domain_column.get((owner, column))
                    if hit is not None:
                        return hit, f"annotation on {local(owner)}"
            elif how == "class_dot_camel":
                iri = URIRef(f"{cls}.{camel(column)}")
                if (iri, None, None) in self.g:
                    return iri, "naming: Class.camelCase"
            elif how == "camel_case":
                iri = URIRef(self.ns + camel(column))
                if (iri, None, None) in self.g:
                    return iri, "naming: camelCase"
        return None, "not found"

    # -- main ------------------------------------------------------------------------
    def extract(self, model: DataModel) -> SemanticModel:
        gcfg = self.settings.section("graph")
        overrides = self.cfg.get("standard", {}).get("column_overrides", {}) or {}
        label_from = gcfg.get("label_from", "ontology")
        tables: dict[str, TableMap] = {}
        used_std_classes: set[URIRef] = set()
        used_std_attrs: set[URIRef] = set()
        used_props: set[URIRef] = set()
        used_concepts: set[URIRef] = set()
        missing_props = 0
        for tid, t in model.tables.items():
            cls, how = self.resolve_class(t.schema, t.name)
            if cls is None:
                log.warning("No ontology class for %s; loaded as %s without standard alignment", tid, pascal(t.name))
            label = local(cls) if (cls is not None and label_from == "ontology") else pascal(t.name)
            anc = self.ancestors(cls) if cls is not None else []
            std_cls, level = (self.std_match_of(cls) if cls is not None else (None, None))
            std_parents = [a for a in anc if self.is_std(a)]
            if std_cls is None and std_parents:
                std_cls = std_parents[0]
            if cls is not None and self.val(cls, "mapping_level"):
                level = self.val(cls, "mapping_level")
            std_anc = self.ancestors(std_cls) if std_cls is not None else []
            if std_cls is not None:
                used_std_classes.update([std_cls, *[a for a in std_anc if self.is_std(a)]])
            tm = TableMap(
                table_id=tid, schema=t.schema, table=t.name, label=label, class_iri=str(cls) if cls else None,
                primary_key=t.primary_key[0] if t.primary_key else "", resolution=how,
                description=(self.text(cls, RDFS.comment) if cls is not None else "") or t.comment.split(" | CMM:")[0],
                standard_class=local(std_cls) if std_cls is not None else None, standard_match=level,
                standard_package=(self.val(cls, "package") if cls is not None else None) or (self.val(std_cls, "package") if std_cls is not None else None),
                standard_standard=(self.val(cls, "standard") if cls is not None else None) or (self.val(std_cls, "standard") if std_cls is not None else None),
                standard_ancestors=[local(a) for a in std_anc if self.is_std(a) and local(a) != self.std_root],
                data_classification=self.val(cls, "classification") if cls is not None else None,
                location_role=self.val(cls, "location_role") if cls is not None else None,
                standard_reference=self.val(cls, "standard_reference") if cls is not None else None,
            )
            if cls is not None:
                for concept in self.g.objects(cls, self.ann["subject"]) if "subject" in self.ann else []:
                    if isinstance(concept, URIRef):
                        used_concepts.add(concept)
                        tm.subject_areas.append(local(concept))
            excluded = set(gcfg.get("exclude_columns", []))
            for c in t.columns:
                if c.name in excluded:
                    continue
                prop, phow = self.resolve_property(cls, anc, c.name)
                cm = ColumnMap(column=c.name, sql_type=c.type, nullable=c.nullable, enum_values=c.enum_values, resolution=phow,
                               description=c.comment[:400])
                if prop is not None:
                    used_props.add(prop)
                    cm.property_iri = str(prop)
                    cm.label = self.text(prop, RDFS.label)
                    cm.description = (self.text(prop, RDFS.comment) or c.comment)[:400]
                    cm.business_term = self.val(prop, "business_term")
                    attr, alevel = self.std_match_of(prop)
                    cm.standard_attribute = local(attr) if attr is not None else None
                    if attr is not None:
                        used_std_attrs.add(attr)
                    cm.standard_match = alevel or self.val(prop, "mapping_level")
                    cm.datatype = self.val(prop, "datatype")
                    unit, mult = self.val(prop, "unit_symbol"), self.val(prop, "unit_multiplier")
                    cm.unit = f"{mult or ''}{unit}" if unit else None
                    cm.sensitivity = self.vals(prop, "sensitivity")
                elif c.name not in overrides:
                    missing_props += 1
                if c.name in overrides:
                    o = overrides[c.name]
                    cm.standard_attribute, cm.standard_match = o.get("attribute"), o.get("match", "exact")
                    cm.description = o.get("description", cm.description)
                    if self.std_ns:
                        used_std_attrs.add(URIRef(self.std_ns + cm.standard_attribute))
                tm.columns.append(cm)
            tables[tid] = tm
        if missing_props:
            log.warning("%d columns have no ontology property (kept as plain properties)", missing_props)
        rels = self._relationships(model, tables, used_props)
        std_classes = {
            local(c): {"iri": str(c), "label": self.text(c, RDFS.label) or local(c), "comment": self.text(c, RDFS.comment)[:300],
                       "package": self.val(c, "package"), "standard": self.val(c, "standard"),
                       "parents": [local(p) for p in self.g.objects(c, RDFS.subClassOf) if self.is_std(p)]}
            for c in used_std_classes
        }
        std_attrs = {local(a): {"iri": str(a), "label": self.text(a, RDFS.label) or local(a),
                                "domain": local(self.g.value(a, RDFS.domain)) or local(a).split(".")[0]}
                     for a in used_std_attrs}
        concepts = {}
        for cpt in used_concepts:
            broader = [b for b in self.g.objects(cpt, SKOS.broader)]
            concepts[local(cpt)] = {"iri": str(cpt), "label": self.text(cpt, SKOS.prefLabel) or local(cpt),
                                    "definition": self.text(cpt, SKOS.definition)[:300],
                                    "scope_note": self.text(cpt, SKOS.scopeNote)[:300],
                                    "broader": [local(b) for b in broader]}
            for b in broader:
                if local(b) not in concepts:
                    concepts[local(b)] = {"iri": str(b), "label": self.text(b, SKOS.prefLabel) or local(b),
                                          "definition": self.text(b, SKOS.definition)[:300],
                                          "scope_note": self.text(b, SKOS.scopeNote)[:300], "broader": []}
        sem = SemanticModel(
            namespace=self.ns,
            standard={"name": self.cfg.get("standard", {}).get("name", "standard"),
                      "short": self.cfg.get("standard", {}).get("short", "STD"), "namespace": self.std_ns,
                      "root_class": self.std_root},
            tables=tables, relationships=rels, standard_classes=std_classes, standard_attributes=std_attrs,
            subject_areas=concepts, schemas=model.schemas,
            sources={"ontology": [f.name for f in self.files], "triples": len(self.g)},
        )
        self._subset = (used_props, used_std_classes, used_std_attrs, used_concepts)
        aligned = sum(1 for t in tables.values() if t.standard_class)
        attr_mapped = sum(1 for t in tables.values() for c in t.columns if c.standard_attribute)
        log.info("Semantic model: %d classes (%d aligned to %s), %d columns (%d mapped to standard attributes), "
                 "%d relationships", len(tables), aligned, sem.standard["short"], sum(len(t.columns) for t in tables.values()),
                 attr_mapped, len(rels))
        return sem

    def _relationships(self, model: DataModel, tables: dict[str, TableMap], used_props: set[URIRef]) -> list[RelationshipMap]:
        gcfg = self.settings.section("graph")
        naming = gcfg.get("relationship_naming", "ontology")
        overrides = {}
        for k, v in (gcfg.get("relationship_overrides") or {}).items():
            overrides[str(self.term(k)) if ":" in k and not k.count(".") == 2 else k] = v
        rels: list[RelationshipMap] = []
        for fk in model.foreign_keys:
            src = tables[fk.table_id]
            cls = URIRef(src.class_iri) if src.class_iri else None
            prop, how = None, "not found"
            for step in self.cfg.get("fk_resolution", ["fk_constraint", "annotation", "name"]):
                if step == "fk_constraint" and fk.name in self.by_fk:
                    prop, how = self.by_fk[fk.name], "annotation fk_constraint"
                elif step == "annotation" and cls is not None:
                    for owner in [cls, *self.ancestors(cls)]:
                        hit = self.by_domain_column.get((owner, fk.column))
                        if hit is not None:
                            prop, how = hit, f"annotation physical_column on {local(owner)}"
                            break
                elif step == "name" and cls is not None:
                    for name in (f"{cls}.{camel(re.sub(r'_id$', '', fk.column))}", self.ns + camel(fk.column)):
                        if (URIRef(name), None, None) in self.g:
                            prop, how = URIRef(name), "naming"
                            break
                if prop is not None:
                    break
            key = f"{fk.table_id}.{fk.column}"
            if key in overrides:
                rel_type = overrides[key]
            elif prop is not None and str(prop) in overrides:
                rel_type = overrides[str(prop)]
            elif naming == "ontology" and prop is not None:
                rel_type = upper_snake(re.sub(r"Id$", "", local(prop).split(".")[-1]))
            else:
                rel_type = upper_snake(camel(re.sub(r"_id$", "", fk.column)))
            if prop is not None:
                used_props.add(prop)
            else:
                log.warning("FK %s.%s: no ontology property; relationship named after the column", fk.table_id, fk.column)
            rels.append(RelationshipMap(
                fk_name=fk.name, from_table=fk.table_id, from_column=fk.column, to_table=fk.ref_table_id, to_column=fk.ref_column,
                rel_type=rel_type, property_iri=str(prop) if prop else None,
                standard_association=self.val(prop, "association") if prop is not None else None,
                description=(self.text(prop, RDFS.comment) if prop is not None else f"FK {key}")[:300],
                resolution=how, cross_domain=fk.is_cross_domain))
        # The same type twice on one source table would merge two FKs: fall back to the column name.
        seen = Counter((r.from_table, r.rel_type) for r in rels)
        for r in rels:
            if seen[(r.from_table, r.rel_type)] > 1:
                r.rel_type = upper_snake(camel(re.sub(r"_id$", "", r.from_column)))
        return rels

    # -- subset ------------------------------------------------------------------------
    def write_subset(self, sem: SemanticModel, path: Path) -> int:
        used_props, std_classes, std_attrs, concepts = self._subset
        selected: set[URIRef] = set(used_props) | std_classes | std_attrs | concepts
        for t in sem.tables.values():
            if t.class_iri:
                selected.add(URIRef(t.class_iri))
                selected.update(a for a in self.ancestors(URIRef(t.class_iri)) if not self.is_std(a))
        sub = rdflib.Graph()
        for prefix, ns in self.g.namespaces():
            if prefix in ("rdf", "rdfs", "owl", "xsd", "skos", "dcterms", "vann", "geo", "cim", "cmm", "cmmsa"):
                sub.bind(prefix, ns)
        def copy_bnode(node: rdflib.BNode) -> None:  # RDF lists such as owl:hasKey ( ... )
            for triple in self.g.triples((node, None, None)):
                sub.add(triple)
                if isinstance(triple[2], rdflib.BNode):
                    copy_bnode(triple[2])

        for s in selected:
            for p, o in self.g.predicate_objects(s):
                sub.add((s, p, o))
                if isinstance(o, rdflib.BNode):
                    copy_bnode(o)
        # annotation property declarations used by the subset
        for p in set(sub.predicates()):
            for triple in self.g.triples((p, None, None)):
                sub.add(triple)
        path.parent.mkdir(parents=True, exist_ok=True)
        header = ("# Subset of the input ontology for the in-scope tables (classes, properties, standard classes and\n"
                  "# attributes, subject areas). Generated by `python -m ukg run --step model`; do not edit.\n")
        path.write_text(header + sub.serialize(format="turtle"), encoding="utf-8")
        check = rdflib.Graph().parse(path, format="turtle")
        log.info("Wrote %s: %d triples (re-parsed OK)", path.name, len(check))
        return len(check)


def _hash_inputs(settings: Settings) -> dict[str, Any]:
    files = [settings.path(p) for p in settings.section("input").get("ontology", [])]
    return {f.name: [f.stat().st_size, int(f.stat().st_mtime)] for f in files if f.exists()}


def build_semantic_model(settings: Settings, model: DataModel) -> SemanticModel:
    extractor = OntologyExtractor(settings)
    sem = extractor.extract(model)
    sem.sources["inputs"] = _hash_inputs(settings)
    out = settings.build_dir
    out.mkdir(parents=True, exist_ok=True)
    sem.sources["subset_triples"] = extractor.write_subset(sem, out / "ontology_subset.ttl")
    (out / "semantic_model.json").write_text(json.dumps(sem.to_json(), indent=2), encoding="utf-8")
    by_domain: dict[str, list[str]] = defaultdict(list)
    for t in sem.tables.values():
        by_domain[t.schema].append(f"{t.label}->{sem.standard['short']}:{t.standard_class or '-'}({t.standard_match or '-'})")
    for d, items in by_domain.items():
        log.info("  %-12s %s", d, ", ".join(items))
    return sem
