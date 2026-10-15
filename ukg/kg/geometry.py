"""Minimal OGC Simple Features helpers (WKT POINT / LINESTRING / POLYGON, lon-lat order).

Enough for GeoSPARQL-style ``sfWithin`` / ``sfIntersects`` between entity
geometries and region polygons, without a GIS library dependency.
"""

from __future__ import annotations

import re

Point = tuple[float, float]  # (lon, lat)

_NUM = r"-?\d+(?:\.\d+)?(?:[eE][-+]?\d+)?"
_PAIR = re.compile(rf"({_NUM})\s+({_NUM})")


def parse_wkt(wkt: str | None) -> tuple[str, list[list[Point]]] | None:
    """Return (kind, rings/parts). POINT -> [[p]], LINESTRING -> [[p...]], POLYGON -> [outer, holes...]."""
    if not wkt:
        return None
    s = wkt.strip()
    kind = s.split("(", 1)[0].strip().upper().split()[0] if "(" in s else ""
    if kind not in ("POINT", "LINESTRING", "POLYGON", "MULTIPOINT", "MULTILINESTRING", "MULTIPOLYGON"):
        return None
    body = s[s.index("("):]
    if kind in ("POINT", "LINESTRING", "MULTIPOINT"):
        pts = [(float(a), float(b)) for a, b in _PAIR.findall(body)]
        return kind, [pts]
    parts = [[(float(a), float(b)) for a, b in _PAIR.findall(ring)] for ring in re.findall(r"\(([^()]+)\)", body)]
    return kind, parts


def point_in_ring(p: Point, ring: list[Point]) -> bool:
    x, y = p
    inside = False
    n = len(ring)
    for i in range(n):
        x1, y1 = ring[i]
        x2, y2 = ring[(i + 1) % n]
        if (y1 > y) != (y2 > y):
            xin = x1 + (y - y1) * (x2 - x1) / (y2 - y1)
            if x < xin:
                inside = not inside
    return inside


def point_in_polygon(p: Point, rings: list[list[Point]]) -> bool:
    if not rings or not point_in_ring(p, rings[0]):
        return False
    return not any(point_in_ring(p, hole) for hole in rings[1:])


def _ccw(a: Point, b: Point, c: Point) -> float:
    return (b[0] - a[0]) * (c[1] - a[1]) - (b[1] - a[1]) * (c[0] - a[0])


def segments_cross(p1: Point, p2: Point, q1: Point, q2: Point) -> bool:
    d1, d2 = _ccw(q1, q2, p1), _ccw(q1, q2, p2)
    d3, d4 = _ccw(p1, p2, q1), _ccw(p1, p2, q2)
    return (d1 * d2 < 0) and (d3 * d4 < 0)


def relate(entity: tuple[str, list[list[Point]]], region: tuple[str, list[list[Point]]]) -> str | None:
    """'within' if every vertex is inside the region, 'intersects' if it crosses the boundary, else None."""
    _, rings = region
    if not rings:
        return None
    kind, parts = entity
    vertices = [p for part in (parts[:1] if kind.endswith("POLYGON") else parts) for p in part]
    if not vertices:
        return None
    inside = [point_in_polygon(p, rings) for p in vertices]
    if all(inside):
        return "within"
    if any(inside):
        return "intersects"
    if kind in ("LINESTRING", "MULTILINESTRING", "POLYGON", "MULTIPOLYGON"):
        outer = rings[0]
        edges = list(zip(outer, outer[1:] + outer[:1]))
        for part in parts:
            for a, b in zip(part, part[1:]):
                if any(segments_cross(a, b, e1, e2) for e1, e2 in edges):
                    return "intersects"
    return None
