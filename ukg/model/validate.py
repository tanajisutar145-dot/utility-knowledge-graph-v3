"""Read-only validation of the input data against the DDL (no data is changed).

Checks per table: primary-key uniqueness, NOT NULL, FK orphans (in-scope FKs),
declared enumerations, declared regex patterns and WGS84 coordinate ranges.
``validation.fail_on`` lists the checks that stop the run; the others are
reported as warnings. The summary is written to ``output/data_validation.json``.
"""

from __future__ import annotations

import logging
import re
from typing import Any

from ukg.model.data import Rows
from ukg.model.ddl import DataModel
from ukg.settings import Settings

log = logging.getLogger(__name__)


def validate(settings: Settings, model: DataModel, rows: Rows) -> dict[str, Any]:
    cfg = settings.section("validation")
    fail_on = set(cfg.get("fail_on", ["pk_duplicates", "fk_orphans", "not_null"]))
    coord_pairs = cfg.get("coordinate_columns", [["latitude", "longitude"]])
    pk_sets = {tid: {r.get(t.primary_key[0]) for r in rows[tid]} for tid, t in model.tables.items() if t.primary_key}
    issues: dict[str, list[str]] = {k: [] for k in ("pk_duplicates", "not_null", "fk_orphans", "enum", "pattern", "coordinates")}
    tables: dict[str, Any] = {}
    for tid, t in model.tables.items():
        data = rows[tid]
        pk = t.primary_key[0] if t.primary_key else None
        if pk:
            seen: set[Any] = set()
            dups = {r[pk] for r in data if r.get(pk) in seen or seen.add(r.get(pk))}  # type: ignore[func-returns-value]
            if dups:
                issues["pk_duplicates"].append(f"{tid}.{pk}: {len(dups)} duplicate keys")
        for c in t.columns:
            if not c.nullable:
                n = sum(1 for r in data if r.get(c.name) is None)
                if n:
                    issues["not_null"].append(f"{tid}.{c.name}: {n} NULLs")
            values = c.enum_values
            if values:
                bad = sorted({str(r[c.name]) for r in data if r.get(c.name) is not None and str(r[c.name]) not in values})
                if bad:
                    issues["enum"].append(f"{tid}.{c.name}: {bad[:5]}")
            if c.pattern:
                try:
                    rx = re.compile(c.pattern)
                except re.error:
                    rx = None
                if rx:
                    bad = [r[c.name] for r in data if isinstance(r.get(c.name), str) and not rx.match(r[c.name])]
                    if bad:
                        issues["pattern"].append(f"{tid}.{c.name}: {len(bad)} values, e.g. {bad[0]!r}")
        for fk in model.fks_from(tid):
            parents = pk_sets.get(fk.ref_table_id, set())
            orphans = [r[fk.column] for r in data if r.get(fk.column) is not None and r[fk.column] not in parents]
            if orphans:
                issues["fk_orphans"].append(f"{tid}.{fk.column} -> {fk.ref_table_id}: {len(orphans)} orphans, e.g. {orphans[0]}")
        for lat_c, lon_c in coord_pairs:
            if t.has_column(lat_c) and t.has_column(lon_c):
                bad = [r for r in data if r.get(lat_c) is not None and not (-90 <= r[lat_c] <= 90 and -180 <= (r.get(lon_c) or 0) <= 180)]
                if bad:
                    issues["coordinates"].append(f"{tid}.{lat_c}/{lon_c}: {len(bad)} out of WGS84 range")
        fk_count = len(model.fks_from(tid))
        tables[tid] = {"rows": len(data), "columns": len(t.columns), "in_scope_fks": fk_count,
                       "populated_columns": sum(1 for c in t.columns if any(r.get(c.name) is not None for r in data))}
    failed = {k: v for k, v in issues.items() if v and k in fail_on}
    for k, v in issues.items():
        for msg in v[:10]:
            (log.error if k in failed else log.warning)("validation %s: %s", k, msg)
    summary = {
        "tables": tables,
        "rows": sum(t["rows"] for t in tables.values()),
        "foreign_keys": len(model.foreign_keys),
        "cross_domain_foreign_keys": sum(fk.is_cross_domain for fk in model.foreign_keys),
        "issues": {k: v for k, v in issues.items() if v},
        "passed": not failed,
    }
    if failed:
        raise SystemExit("Data validation failed: " + "; ".join(f"{k} ({len(v)})" for k, v in failed.items()))
    log.info("Data validation passed: %d rows, %d tables, %d in-scope FKs (%d cross-domain), 0 orphans",
             summary["rows"], len(tables), summary["foreign_keys"], summary["cross_domain_foreign_keys"])
    return summary
