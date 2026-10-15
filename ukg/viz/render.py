"""Interactive HTML renderings of the graph (``python -m ukg run --step viz``).

Outputs (``output/``):

* ``graph_overview.html`` - data nodes and relationships, coloured by subject area; every tooltip shows the node's IEC CIM
  class, match level, package and standard plus its key properties with the CIM attribute and unit each maps to;
* ``cim_alignment.html`` + ``.svg`` - the semantic layer: each ontology class -[SPECIALIZES {match}]-> its CIM class and
  the CIM superclass chain up to IdentifiedObject;
* ``schema_overview.html`` + ``.svg`` - meta-graph: one node per label (count, CIM class), one edge per relationship type;
* ``gis_map.html`` - Leaflet map of the WGS84 geometries (lines, polygons, points) with CIM popups;
* ``<question id>_subgraph.html`` - the evidence subgraph of each demo question.

Engine for the network views: ``pyvis`` (default) or ``neo4j-viz`` (``viz.engine``).
"""

from __future__ import annotations

import html
import json
import logging
import math
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

import neo4j

from ukg.kg.captions import Captioner
from ukg.kg.neo4j_client import database, get_driver
from ukg.kg.semantic import SEMANTIC_LABELS
from ukg.ontology.extract import SemanticModel
from ukg.settings import Settings

log = logging.getLogger(__name__)

LEXICAL = {"Document", "Chunk"}
HIDDEN_PROPS = {"embedding", "__tmp_internal_id"}
STD_PROPS = ("cim_class", "cim_match", "cim_package", "cim_standard", "subject_area", "source_table")


@dataclass
class VizGraph:
    nodes: dict[str, dict[str, Any]] = field(default_factory=dict)
    edges: dict[str, dict[str, Any]] = field(default_factory=dict)
    std_prefix: str = "CIM_"

    def add_node(self, n: neo4j.graph.Node) -> None:
        labels = [l for l in n.labels if not l.startswith("__") and not l.startswith(self.std_prefix)]
        props = {k: v for k, v in dict(n).items() if k not in HIDDEN_PROPS}
        std_labels = sorted(l for l in n.labels if l.startswith(self.std_prefix))
        self.nodes[n.element_id] = {"label": labels[0] if labels else "Node", "props": props, "std_labels": std_labels}

    def add_rel(self, r: neo4j.graph.Relationship) -> None:
        self.edges[r.element_id] = {"src": r.start_node.element_id, "dst": r.end_node.element_id, "type": r.type,
                                    "props": {k: v for k, v in dict(r).items() if k in ("cim_association", "match", "rule", "fk_column")}}

    def absorb(self, value: Any) -> None:
        if isinstance(value, neo4j.graph.Path):
            for n in value.nodes:
                self.add_node(n)
            for r in value.relationships:
                self.add_rel(r)
        elif isinstance(value, neo4j.graph.Node):
            self.add_node(value)
        elif isinstance(value, neo4j.graph.Relationship):
            for n in value.nodes:
                if n is not None:
                    self.add_node(n)
            self.add_rel(value)
        elif isinstance(value, list):
            for v in value:
                self.absorb(v)


class Styler:
    """Colours by subject area, captions and CIM-aware tooltips."""

    def __init__(self, settings: Settings, sem: SemanticModel):
        self.sem = sem
        viz = settings.section("viz")
        self.domain_colors: dict[str, str] = viz.get("domain_colors", {})
        self.colors: dict[str, str] = viz.get("colors", {}) or {}
        self.captioner = Captioner(settings, sem)
        self.std = sem.standard.get("short", "STD")
        self.columns = {t.label: {c.column: c for c in t.columns} for t in sem.tables.values()}
        self.domain_of = {t.label: t.schema for t in sem.tables.values()}

    def domain(self, label: str, props: dict[str, Any] | None = None) -> str:
        if label == "OntologyClass" and (props or {}).get("subject_area"):
            return props["subject_area"]
        if label in SEMANTIC_LABELS:
            return "semantic"
        if label in LEXICAL:
            return "lexical"
        return (props or {}).get("subject_area") or self.domain_of.get(label, "extracted")

    def color(self, label: str, props: dict[str, Any] | None = None) -> str:
        if label in self.colors:
            return self.colors[label]
        if label in LEXICAL:
            return "#C8C8C8"
        return self.domain_colors.get(self.domain(label, props), self.domain_colors.get("extracted", "#7F7F7F"))

    def caption(self, label: str, props: dict[str, Any]) -> str:
        if props.get("caption"):
            return str(props["caption"])[:40]
        return str(props.get("name") or props.get("path") or label)[:40]

    def std_line(self, label: str, props: dict[str, Any]) -> str:
        if label == "CimClass":
            return f"{self.std} class · {props.get('package') or ''} · {props.get('standard') or ''}"
        if props.get("cim_class"):
            return (f"{self.std} {props['cim_class']} ({props.get('cim_match') or '-'}) · {props.get('cim_package') or ''} · "
                    f"{props.get('cim_standard') or ''}")
        return ""

    def tooltip(self, label: str, props: dict[str, Any]) -> str:
        lines = [f"{label}: {self.caption(label, props)}"]
        std = self.std_line(label, props)
        if std:
            lines.append(std)
        if props.get("mrid"):
            lines.append(f"mRID {props['mrid']}")
        keys = self.captioner.summary.get(label) or [k for k in ("name", "description", "path", "text") if k in props]
        for k in keys:
            if props.get(k) is None:
                continue
            c = self.columns.get(label, {}).get(k)
            note = ""
            if c is not None and c.standard_attribute:
                note = f"  [{self.std} {c.standard_attribute}{', ' + c.unit if c.unit else ''}]"
            elif c is not None and c.unit:
                note = f"  [{c.unit}]"
            lines.append(f"{k}: {str(props[k])[:120]}{note}")
        return "\n".join(lines)


def _query_graph(driver: neo4j.Driver, db: str, query: str, std_prefix: str, **params: Any) -> VizGraph:
    g = VizGraph(std_prefix=std_prefix)
    for rec in driver.execute_query(query, params, database_=db)[0]:
        for value in rec.values():
            g.absorb(value)
    return g


def _legend_html(items: list[tuple[str, str]], title: str, note: str = "") -> str:
    chips = "".join(f'<span style="display:inline-block;margin:2px 12px 2px 0"><span style="display:inline-block;width:12px;'
                    f'height:12px;border-radius:6px;background:{c};margin-right:5px;vertical-align:middle"></span>{html.escape(n)}</span>'
                    for n, c in items)
    return (f'<div style="font-family:Segoe UI,Arial,sans-serif;padding:8px 12px"><b>{html.escape(title)}</b>'
            f'<div style="font-size:12px;margin-top:4px">{chips}</div>'
            + (f'<div style="font-size:12px;color:#555;margin-top:4px">{html.escape(note)}</div>' if note else "") + "</div>")


def _domain_legend(g: VizGraph, styler: Styler) -> list[tuple[str, str]]:
    seen: dict[str, str] = {}
    for n in g.nodes.values():
        d = styler.domain(n["label"], n["props"])
        seen.setdefault(d, styler.color(n["label"], n["props"]))
    return sorted(seen.items())


def _write_pyvis(g: VizGraph, styler: Styler, path: Path, title: str, physics: bool = True,
                 positions: dict[str, tuple[float, float]] | None = None, sizes: dict[str, float] | None = None,
                 legend: list[tuple[str, str]] | None = None, note: str = "", edge_labels: bool = False,
                 shapes: dict[str, str] | None = None) -> None:
    from pyvis.network import Network

    net = Network(height="820px", width="100%", directed=True, bgcolor="#ffffff", font_color="#222222",
                  cdn_resources="in_line", heading="")
    for nid, n in g.nodes.items():
        kwargs: dict[str, Any] = {}
        if positions and nid in positions:
            kwargs.update(x=positions[nid][0], y=positions[nid][1], physics=False)
        net.add_node(nid, label=styler.caption(n["label"], n["props"]), title=styler.tooltip(n["label"], n["props"]),
                     color=styler.color(n["label"], n["props"]), size=(sizes or {}).get(nid, 14 if n["label"] not in LEXICAL else 8),
                     shape=(shapes or {}).get(n["label"], "dot"), group=n["label"], **kwargs)
    for e in g.edges.values():
        if e["src"] in g.nodes and e["dst"] in g.nodes:
            tip = e["type"] + "".join(f"\n{k}: {v}" for k, v in e.get("props", {}).items() if v)
            net.add_edge(e["src"], e["dst"], title=tip, label=e.get("caption", e["type"]) if (positions or edge_labels) else "",
                         arrows="to", color="#9AA0A6")
    options = {
        "physics": {"enabled": physics, "solver": "forceAtlas2Based",
                    "forceAtlas2Based": {"gravitationalConstant": -60, "springLength": 110}, "stabilization": {"iterations": 300}},
        "edges": {"font": {"size": 10, "align": "middle"}, "smooth": {"type": "dynamic"}},
        "nodes": {"font": {"size": 13}},
        "interaction": {"hover": True, "navigationButtons": True},
    }
    net.set_options(json.dumps(options))
    path.parent.mkdir(parents=True, exist_ok=True)
    text = net.generate_html(name=str(path), notebook=False)
    text = text.replace("<body>", "<body>" + _legend_html(legend or _domain_legend(g, styler), title, note), 1)
    path.write_text(text, encoding="utf-8")


def _write(settings: Settings, g: VizGraph, styler: Styler, path: Path, title: str, note: str = "") -> None:
    if settings.section("viz").get("engine", "pyvis") == "neo4j-viz":
        from neo4j_viz import Node, Relationship, VisualizationGraph

        nodes = [Node(id=nid, caption=styler.caption(n["label"], n["props"]), color=styler.color(n["label"], n["props"]),
                      size=12, properties={"label": n["label"], **{k: str(v) for k, v in n["props"].items()}})
                 for nid, n in g.nodes.items()]
        rels = [Relationship(id=rid, source=e["src"], target=e["dst"], caption=e["type"])
                for rid, e in g.edges.items() if e["src"] in g.nodes and e["dst"] in g.nodes]
        rendered = VisualizationGraph(nodes=nodes, relationships=rels).render(height="820px")
        path.write_text(f"<!DOCTYPE html><html><head><meta charset='utf-8'><title>{html.escape(title)}</title></head><body>"
                        f"{_legend_html(_domain_legend(g, styler), title, note)}{rendered.data}</body></html>", encoding="utf-8")
    else:
        _write_pyvis(g, styler, path, title, note=note)
    log.info("Wrote %s (%d nodes, %d relationships)", path.name, len(g.nodes), len(g.edges))


# ---------------------------------------------------------------------------
# CIM alignment (semantic layer)
# ---------------------------------------------------------------------------
def _cim_alignment(driver: neo4j.Driver, db: str, styler: Styler, sem: SemanticModel, out_dir: Path, std_prefix: str) -> None:
    g = _query_graph(driver, db, "MATCH p = (c:OntologyClass)-[:SPECIALIZES]->(:CimClass)-[:SUBCLASS_OF*0..8]->(:CimClass) RETURN p",
                     std_prefix)
    for e in g.edges.values():
        if e["type"] == "SPECIALIZES":
            e["caption"] = f"{e['props'].get('match', '')}"
    for n in g.nodes.values():  # colour ontology classes by their subject area
        if n["label"] == "OntologyClass":
            t = sem.by_label(n["props"].get("name", ""))
            if t:
                n["props"]["subject_area"] = t.schema
    std = sem.standard.get("short", "STD")
    legend = [(f"{d} class", c) for d, c in styler.domain_colors.items() if d in {t.schema for t in sem.tables.values()}]
    legend.append((f"{std} class (IEC 61970 / 61968)", styler.domain_colors.get("semantic", "#9D755D")))
    _write_pyvis(g, styler, out_dir / "cim_alignment.html", f"Ontology classes aligned to {sem.standard.get('name')}",
                 legend=legend, edge_labels=True, shapes={"CimClass": "box"},
                 note="Edge labels on SPECIALIZES show the mapping level (exact / close / broad / extension). Boxes are "
                      f"{std} classes with their superclass chain; hover for package and standard.")
    # static SVG: ontology classes (left) -> CIM classes (right), grouped by subject area
    tables = sorted(sem.tables.values(), key=lambda t: (t.schema, t.label))
    cims = sorted({t.standard_class for t in tables if t.standard_class})
    row_h, w = 18, 1100
    h = max(len(tables), len(cims)) * row_h + 80
    ypos = {t.label: 60 + i * row_h for i, t in enumerate(tables)}
    cpos = {c: 60 + i * (row_h * len(tables) / max(len(cims), 1)) for i, c in enumerate(cims)}
    svg = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{w}" height="{h:.0f}" font-family="Segoe UI, Arial, sans-serif" font-size="12">',
           '<rect width="100%" height="100%" fill="#fff"/>',
           f'<text x="20" y="28" font-size="16" font-weight="bold">Ontology classes (by subject area) aligned to {html.escape(sem.standard.get("name", ""))} classes</text>']
    dash = {"exact": "", "close": "6,3", "broad": "2,3", "extension": "1,4"}
    for t in tables:
        if t.standard_class:
            y1, y2 = ypos[t.label], cpos[t.standard_class]
            svg.append(f'<path d="M330,{y1 - 4} C 550,{y1 - 4} 600,{y2 - 4} 760,{y2 - 4}" fill="none" stroke="#9AA0A6" '
                       f'stroke-dasharray="{dash.get(t.standard_match or "", "")}"/>')
    for t in tables:
        col = styler.domain_colors.get(t.schema, "#888")
        svg.append(f'<circle cx="20" cy="{ypos[t.label] - 4}" r="5" fill="{col}"/><text x="32" y="{ypos[t.label]}">'
                   f'{html.escape(t.schema)} · {html.escape(t.label)}</text><text x="330" y="{ypos[t.label]}" text-anchor="end" fill="#666">'
                   f'{html.escape(t.standard_match or "")}</text>')
    for c in cims:
        info = sem.standard_classes.get(c, {})
        svg.append(f'<rect x="762" y="{cpos[c] - 14}" width="12" height="12" fill="#9D755D"/><text x="780" y="{cpos[c] - 4}">'
                   f'{html.escape(std)}:{html.escape(c)} <tspan fill="#666">{html.escape(info.get("package") or "")}</tspan></text>')
    svg.append("</svg>")
    (out_dir / "cim_alignment.svg").write_text("\n".join(svg), encoding="utf-8")
    log.info("Wrote cim_alignment.html / .svg (%d ontology classes -> %d %s classes)", len(tables), len(cims), std)


# ---------------------------------------------------------------------------
# Schema meta-graph
# ---------------------------------------------------------------------------
def _schema_overview(driver: neo4j.Driver, db: str, styler: Styler, sem: SemanticModel, out_dir: Path, hide: set[str]) -> None:
    labels = {t.label: t for t in sem.tables.values() if t.label not in hide}
    counts = {r["label"]: r["c"] for r in driver.execute_query(
        "UNWIND $labels AS l RETURN l AS label, COUNT { MATCH (n) WHERE l IN labels(n) } AS c",
        labels=list(labels), database_=db)[0]}
    rel_counts = driver.execute_query(
        f"MATCH (a)-[r]->(b) WHERE NOT a:Chunk AND NOT a:Document AND NOT a:OntologyClass AND NOT a:CimClass "
        f"AND NOT a:OntologyProperty AND NOT a:CimAttribute AND NOT a:SubjectArea AND type(r) <> 'INSTANCE_OF' "
        f"WITH [l IN labels(a) WHERE NOT l STARTS WITH '__' AND NOT l STARTS WITH '{styler.captioner.std_prefix}'][0] AS s, type(r) AS t, "
        f"[l IN labels(b) WHERE NOT l STARTS WITH '__' AND NOT l STARTS WITH '{styler.captioner.std_prefix}'][0] AS d "
        "RETURN s, t, d, count(*) AS c ORDER BY c DESC", database_=db)[0]
    order = sorted(labels, key=lambda l: (labels[l].schema, l))
    n = len(order)
    radius = 420
    pos = {l: (radius * math.cos(2 * math.pi * i / n), radius * math.sin(2 * math.pi * i / n)) for i, l in enumerate(order)}
    size = {l: 10 + 5 * math.log10(1 + counts.get(l, 0)) * 2 for l in order}
    std = sem.standard.get("short", "STD")
    g = VizGraph()
    for l in order:
        t = labels[l]
        g.nodes[l] = {"label": l, "props": {"caption": f"{l} ({counts.get(l, 0)})", "subject_area": t.schema,
                                            "cim_class": t.standard_class, "cim_match": t.standard_match,
                                            "cim_package": t.standard_package, "cim_standard": t.standard_standard}}
    for r in rel_counts:
        if r["s"] in pos and r["d"] in pos:
            g.edges[f"{r['s']}-{r['t']}-{r['d']}"] = {"src": r["s"], "dst": r["d"], "type": f"{r['t']} ({r['c']})", "caption": r["t"],
                                                     "props": {}}
    _write_pyvis(g, styler, out_dir / "schema_overview.html", f"Knowledge graph schema - labels ({std} class in tooltip) and relationship types",
                 physics=False, positions=pos, sizes=size)
    w = h = 1100
    cx = cy = w / 2
    svg = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{w}" height="{h}" viewBox="0 0 {w} {h}" font-family="Segoe UI, Arial, sans-serif">'
           '<rect width="100%" height="100%" fill="#ffffff"/><defs><marker id="a" markerWidth="8" markerHeight="8" refX="7" refY="4" '
           'orient="auto"><path d="M0,0 L8,4 L0,8 z" fill="#9AA0A6"/></marker></defs>']
    for e in g.edges.values():
        (x1, y1), (x2, y2) = pos[e["src"]], pos[e["dst"]]
        if e["src"] == e["dst"]:
            svg.append(f'<circle cx="{cx + x1 * 1.1:.0f}" cy="{cy + y1 * 1.1:.0f}" r="16" fill="none" stroke="#9AA0A6"/>')
            continue
        svg.append(f'<path d="M{cx + x1:.0f},{cy + y1:.0f} Q{cx + (x1 + x2) * 0.25:.0f},{cy + (y1 + y2) * 0.25:.0f} {cx + x2:.0f},{cy + y2:.0f}" '
                   'fill="none" stroke="#C0C4C8" stroke-width="1" marker-end="url(#a)"/>')
    for l in order:
        x, y = pos[l]
        t = labels[l]
        anchor = "start" if x >= 0 else "end"
        dx = size[l] + 6 if x >= 0 else -(size[l] + 6)
        svg.append(f'<circle cx="{cx + x:.0f}" cy="{cy + y:.0f}" r="{size[l]:.0f}" fill="{styler.color(l, {"subject_area": t.schema})}" stroke="#333" stroke-width="0.6"/>')
        svg.append(f'<text x="{cx + x + dx:.0f}" y="{cy + y + 4:.0f}" font-size="11" text-anchor="{anchor}">{html.escape(l)} '
                   f'<tspan fill="#777">{std}:{html.escape(t.standard_class or "-")}</tspan></text>')
    svg.append(f'<text x="20" y="30" font-size="18" font-weight="bold">Knowledge graph schema - {len(order)} labels, '
               f'{sum(counts.values())} nodes, {sum(r["c"] for r in rel_counts)} relationships</text></svg>')
    (out_dir / "schema_overview.svg").write_text("\n".join(svg), encoding="utf-8")
    log.info("Wrote schema_overview.html and schema_overview.svg (%d labels)", len(order))


# ---------------------------------------------------------------------------
# GIS map (Leaflet)
# ---------------------------------------------------------------------------
def gis_features(driver: neo4j.Driver, db: str, settings: Settings, sem: SemanticModel, styler: Styler) -> list[dict[str, Any]]:
    """GeoJSON-like features of the located data nodes (geometry from their GIS location)."""
    gis = settings.section("gis")
    loc_table = gis.get("location_table")
    if loc_table not in sem.tables:
        return []
    loc_label = sem.label(loc_table)
    tables = [t for t in (gis.get("spatial_relationships") or {}).get("source_tables", []) if t in sem.tables]
    region = (gis.get("spatial_relationships") or {}).get("region_table")
    feats = []
    for tid in tables + ([region] if region in sem.tables else []):
        t = sem.tables[tid]
        recs = driver.execute_query(
            f"MATCH (n:`{t.label}`)-[:HAS_LOCATION|LOCATION]->(l:`{loc_label}`) WHERE l.geometry_geojson IS NOT NULL "
            "RETURN properties(n) AS p, l.geometry_geojson AS g LIMIT 2000", database_=db)[0]
        for r in recs:
            p = {k: v for k, v in r["p"].items() if k not in HIDDEN_PROPS}
            feats.append({"label": t.label, "domain": t.schema, "color": styler.color(t.label, p),
                          "geometry": json.loads(r["g"]), "caption": styler.caption(t.label, p),
                          "tooltip": styler.tooltip(t.label, {k: (v.isoformat() if hasattr(v, "isoformat") else v) for k, v in p.items()}),
                          "region": tid == region, "kind": p.get("region_kind")})
    return feats


_MAP_HTML = """<!DOCTYPE html><html><head><meta charset="utf-8"><title>{title}</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">
<style>html,body{{margin:0;height:100%;font-family:Segoe UI,Arial,sans-serif}}#map{{position:absolute;top:64px;bottom:0;left:0;right:0}}
.hdr{{padding:8px 12px}}pre{{margin:0;font-size:11px;white-space:pre-wrap;max-width:420px}}</style></head><body>
<div class="hdr"><b>{title}</b><div style="font-size:12px">{legend} Region polygons (HFTD, storm zones, service territories) are outlined.
Base map: OpenStreetMap (needs internet); geometry is WGS84 from the CIM Location / PositionPoint tables.</div></div>
<div id="map"></div>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
const feats = {features};
const map = L.map('map');
L.tileLayer('https://{{s}}.tile.openstreetmap.org/{{z}}/{{x}}/{{y}}.png', {{maxZoom: 18, attribution: '&copy; OpenStreetMap contributors'}}).addTo(map);
const layers = {{}};
const all = L.featureGroup();
for (const f of feats) {{
  const style = f.region ? {{color: f.kind === 'sub_geographical_region' ? '#B3402F' : '#555', weight: 1.5, fillOpacity: 0.06, dashArray: '4 3'}}
                         : {{color: f.color, weight: 3, fillOpacity: 0.15}};
  const layer = L.geoJSON(f.geometry, {{style: () => style,
      pointToLayer: (_, ll) => L.circleMarker(ll, {{radius: 5, color: '#333', weight: 1, fillColor: f.color, fillOpacity: 0.9}})}});
  layer.bindPopup('<pre>' + f.tooltip.replace(/[<>&]/g, c => ({{'<':'&lt;','>':'&gt;','&':'&amp;'}}[c])) + '</pre>');
  layer.bindTooltip(f.caption);
  (layers[f.label] = layers[f.label] || L.featureGroup()).addLayer(layer);
  all.addLayer(layer);
}}
for (const g of Object.values(layers)) g.addTo(map);
L.control.layers(null, layers, {{collapsed: false}}).addTo(map);
map.fitBounds(all.getBounds().pad(0.05));
</script></body></html>"""


def _gis_map(driver: neo4j.Driver, db: str, settings: Settings, sem: SemanticModel, styler: Styler, out_dir: Path) -> None:
    feats = gis_features(driver, db, settings, sem, styler)
    if not feats:
        return
    legend = " ".join(f'<span style="color:{c}">&#9679;</span> {html.escape(d)}' for d, c in styler.domain_colors.items()
                      if d in {f["domain"] for f in feats})
    (out_dir / "gis_map.html").write_text(_MAP_HTML.format(title="GIS view - CIM Location geometry (WGS84)", legend=legend,
                                                           features=json.dumps(feats, default=str)), encoding="utf-8")
    log.info("Wrote gis_map.html (%d features)", len(feats))


def render_all(settings: Settings, only: str | None = None) -> list[Path]:
    from ukg.rag.runner import load_questions

    driver = get_driver(settings)
    db = database(settings)
    sem = SemanticModel.load(settings)
    styler = Styler(settings, sem)
    std_prefix = styler.captioner.std_prefix
    out_dir = settings.output_dir
    out_dir.mkdir(parents=True, exist_ok=True)
    viz = settings.section("viz")
    hide = set(viz.get("hide_labels", []))
    limit = int(viz.get("max_nodes", 700))
    written: list[Path] = []
    if not only:
        skip = list(hide | LEXICAL | set(SEMANTIC_LABELS) | {"GisLocation"})
        g = _query_graph(driver, db,
                         "MATCH (n) WHERE none(l IN labels(n) WHERE l IN $skip) WITH n LIMIT $limit "
                         "OPTIONAL MATCH (n)-[r]->(m) WHERE none(l IN labels(m) WHERE l IN $skip) RETURN n, collect(r) AS rels",
                         std_prefix, skip=skip, limit=limit)
        path = out_dir / "graph_overview.html"
        _write(settings, g, styler, path, "Utility knowledge graph - overview (coloured by subject area)",
               note=f"Hover a node for its {sem.standard.get('short')} class, package, standard, mRID and key properties with the "
                    f"{sem.standard.get('short')} attribute and unit each maps to.")
        written.append(path)
        _cim_alignment(driver, db, styler, sem, out_dir, std_prefix)
        written += [out_dir / "cim_alignment.html", out_dir / "cim_alignment.svg"]
        _schema_overview(driver, db, styler, sem, out_dir, hide)
        written += [out_dir / "schema_overview.html", out_dir / "schema_overview.svg"]
        _gis_map(driver, db, settings, sem, styler, out_dir)
        written.append(out_dir / "gis_map.html")
    spec = load_questions(settings)
    for q in spec.get("questions", []) + spec.get("sample_questions", []):
        if only and q["id"].lower() != only.lower():
            continue
        if not q.get("subgraph_cypher"):
            continue
        g = _query_graph(driver, db, q["subgraph_cypher"], std_prefix)
        path = out_dir / f"{q['id'].lower()}_subgraph.html"
        _write(settings, g, styler, path, f"{q['id']} - {q['title']} ({q.get('use_case', '')})")
        written.append(path)
    driver.close()
    return written
