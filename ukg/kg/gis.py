"""GIS enrichment after the structured load.

1. **Points.** Every node with a configured latitude/longitude column pair gets a
   WGS84 ``point`` property (``gis.point_property``); nodes without coordinates
   inherit the point of the location they reference (``gis.location_fk_columns``
   -> ``gis.location``). ``point.distance()`` then works on any located label.
2. **Spatial relationships.** Region polygons (``gis.spatial_relationships``)
   are related to entity geometries (their location WKT, or their point) with
   GeoSPARQL simple-feature semantics: ``SF_WITHIN`` when the geometry lies
   inside the region and ``SF_INTERSECTS`` when it crosses the boundary.
   Computed in Python from the input rows, written idempotently with MERGE.
"""

from __future__ import annotations

import logging
from collections import defaultdict
from typing import Any

import neo4j

from ukg.kg.geometry import parse_wkt, relate
from ukg.model.data import Rows
from ukg.ontology.extract import SemanticModel
from ukg.settings import Settings

log = logging.getLogger(__name__)


def _location_fk(settings: Settings, sem: SemanticModel, table_id: str):
    cfg = settings.section("gis")
    loc_table = cfg.get("location_table")
    for r in sem.relationships:
        if r.from_table == table_id and r.to_table == loc_table and r.from_column in cfg.get("location_fk_columns", []):
            return r
    return None


def assign_points(settings: Settings, driver: neo4j.Driver, db: str, sem: SemanticModel) -> dict[str, int]:
    cfg = settings.section("gis")
    prop = cfg.get("point_property", "geo_point")
    pairs = [tuple(p) for p in cfg.get("lat_lon_columns", [["latitude", "longitude"]])]
    for t in sem.tables.values():
        cols = {c.column for c in t.columns}
        for lat, lon in pairs:
            if lat in cols and lon in cols:
                driver.execute_query(
                    f"MATCH (n:`{t.label}`) WHERE n.`{prop}` IS NULL AND n.`{lat}` IS NOT NULL AND n.`{lon}` IS NOT NULL "
                    f"SET n.`{prop}` = point({{latitude: toFloat(n.`{lat}`), longitude: toFloat(n.`{lon}`)}})", database_=db)
    loc_table = cfg.get("location_table")
    if loc_table in sem.tables:
        loc_label = sem.label(loc_table)
        for t in sem.tables.values():
            for r in sem.relationships:
                if r.from_table == t.table_id and r.to_table == loc_table and r.from_column in cfg.get("location_fk_columns", []):
                    driver.execute_query(
                        f"MATCH (n:`{t.label}`)-[x:`{r.rel_type}`]->(l:`{loc_label}`) "
                        f"WHERE n.`{prop}` IS NULL AND l.`{prop}` IS NOT NULL AND x.fk_column = $fk SET n.`{prop}` = l.`{prop}`",
                        fk=f"{r.from_table}.{r.from_column}", database_=db)
    counts = {}
    for t in sem.tables.values():
        n = driver.execute_query(f"MATCH (n:`{t.label}`) WHERE n.`{prop}` IS NOT NULL RETURN count(n) AS c", database_=db)[0][0]["c"]
        if n:
            counts[t.label] = n
    log.info("GIS points (%s) on %d nodes across %d labels", prop, sum(counts.values()), len(counts))
    return counts


def spatial_relationships(settings: Settings, driver: neo4j.Driver, db: str, sem: SemanticModel, rows: Rows) -> dict[str, int]:
    cfg = settings.section("gis")
    sp = cfg.get("spatial_relationships") or {}
    region_table, loc_table = sp.get("region_table"), cfg.get("location_table")
    if region_table not in sem.tables or loc_table not in sem.tables:
        return {}
    loc_pk = sem.tables[loc_table].primary_key
    wkt_col = cfg.get("location_wkt", "geometry_wkt")
    lat_c, lon_c = cfg.get("location_lat_lon", ["latitude", "longitude"])
    locations = {r[loc_pk]: r for r in rows[loc_table]}
    rt = sem.tables[region_table]
    kinds = set(sp.get("region_kinds") or [])
    regions = []
    for r in rows[region_table]:
        if kinds and r.get("region_kind") not in kinds:
            continue
        loc = locations.get(r.get(sp.get("region_location_column", "location_id")))
        geom = parse_wkt(loc.get(wkt_col)) if loc else None
        if geom and geom[0].endswith("POLYGON"):
            regions.append((r[rt.primary_key], geom))
    pairs = [tuple(p) for p in cfg.get("lat_lon_columns", [["latitude", "longitude"]])]
    found: dict[tuple[str, str], list[dict[str, Any]]] = defaultdict(list)
    for tid in sp.get("source_tables", []):
        if tid not in sem.tables:
            continue
        t = sem.tables[tid]
        fk = _location_fk(settings, sem, tid)
        for row in rows[tid]:
            geom = None
            if fk is not None and row.get(fk.from_column) in locations:
                loc = locations[row[fk.from_column]]
                geom = parse_wkt(loc.get(wkt_col)) or (
                    ("POINT", [[(loc[lon_c], loc[lat_c])]]) if loc.get(lat_c) is not None else None)
            if geom is None:
                for la, lo in pairs:
                    if row.get(la) is not None and row.get(lo) is not None:
                        geom = ("POINT", [[(row[lo], row[la])]])
                        break
            if geom is None:
                continue
            for rpk, rgeom in regions:
                rel = relate(geom, rgeom)
                if rel:
                    rtype = sp.get("within_type", "SF_WITHIN") if rel == "within" else sp.get("intersects_type", "SF_INTERSECTS")
                    found[(t.label, rtype)].append({"a": row[t.primary_key], "r": rpk})
    counts = {}
    for (label, rtype), items in found.items():
        t = sem.by_label(label)
        driver.execute_query(
            f"UNWIND $rows AS row MATCH (a:`{label}` {{`{t.primary_key}`: row.a}}) MATCH (g:`{rt.label}` {{`{rt.primary_key}`: row.r}}) "
            f"MERGE (a)-[x:`{rtype}`]->(g) SET x.derived = true, x.rule = 'GeoSPARQL simple features (polygon test on WGS84 WKT)'",
            rows=items, database_=db)
        counts[f"{label}-{rtype}"] = len(items)
    log.info("Spatial relationships: %d (%s)", sum(counts.values()),
             ", ".join(f"{k}={v}" for k, v in sorted(counts.items())))
    return counts
