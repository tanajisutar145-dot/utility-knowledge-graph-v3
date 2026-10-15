"""Read the input data files and type every value from the DDL.

Files are located with ``input.data.path_template`` (``{schema}/{table}.csv`` by
default; ``{table}`` and ``{schema}`` placeholders). Supported formats: ``csv``
(header row) and ``jsonl`` (one JSON object per line). Values are coerced to
Python types from the column's SQL type; empty strings and configured
``null_values`` become ``None``. Columns present in a file but missing from the
DDL are kept as strings (and reported).
"""

from __future__ import annotations

import csv
import json
import logging
from datetime import date, datetime
from pathlib import Path
from typing import Any, Callable

from ukg.model.ddl import Column, DataModel, Table
from ukg.settings import Settings

log = logging.getLogger(__name__)

Rows = dict[str, list[dict[str, Any]]]  # table id -> rows

_TRUE = {"true", "t", "1", "yes", "y"}
_FALSE = {"false", "f", "0", "no", "n"}


def _to_bool(v: str) -> bool | None:
    s = v.strip().lower()
    if s in _TRUE:
        return True
    if s in _FALSE:
        return False
    raise ValueError(f"not a boolean: {v!r}")


def _to_date(v: str) -> date:
    return date.fromisoformat(v.strip()[:10])


def _to_ts(v: str) -> datetime:
    s = v.strip().replace("Z", "")
    return datetime.fromisoformat(s.replace(" ", "T") if "T" not in s and len(s) > 10 else s)


CONVERTERS: dict[str, Callable[[str], Any]] = {
    "BIGINT": int, "INT": int, "INTEGER": int, "SMALLINT": int, "TINYINT": int, "LONG": int,
    "DECIMAL": float, "NUMERIC": float, "DOUBLE": float, "FLOAT": float, "REAL": float,
    "BOOLEAN": _to_bool, "BOOL": _to_bool,
    "DATE": _to_date,
    "TIMESTAMP": _to_ts, "TIMESTAMP_NTZ": _to_ts, "TIMESTAMP_LTZ": _to_ts, "DATETIME": _to_ts,
}


def convert(column: Column, raw: Any) -> Any:
    if raw is None:
        return None
    if not isinstance(raw, str):  # JSON already typed
        return raw
    if column.base_type in ("BINARY", "VARBINARY", "BLOB"):
        return None
    fn = CONVERTERS.get(column.base_type)
    if fn is None:
        return raw
    if fn is int and "." in raw:
        return int(float(raw))
    return fn(raw)


def data_file(settings: Settings, table: Table) -> Path:
    cfg = settings.section("input")["data"]
    rel = cfg.get("path_template", "{schema}/{table}.csv").format(schema=table.schema, table=table.name)
    return settings.path(cfg.get("dir", "input/data")) / rel


def resolve_scope(settings: Settings, full: DataModel) -> list[str]:
    """Table ids in scope (config order). ``"*"`` takes every table of a schema."""
    out: list[str] = []
    skip_missing = settings.section("scope").get("skip_tables_without_data", True)
    for schema, tables in settings.scope.items():
        names = sorted(t.name for t in full.tables.values() if t.schema == schema) if tables in ("*", ["*"]) else tables
        for name in names:
            tid = f"{schema}.{name}"
            if tid not in full.tables:
                raise SystemExit(f"Scope table {tid} is not defined in the DDL files")
            if not data_file(settings, full.tables[tid]).exists():
                if skip_missing:
                    log.warning("No data file for %s (%s): table skipped", tid, data_file(settings, full.tables[tid]))
                    continue
                raise SystemExit(f"Missing data file for {tid}: {data_file(settings, full.tables[tid])}")
            out.append(tid)
    if not out:
        raise SystemExit("Scope is empty: no table has a data file")
    return out


def read_table(settings: Settings, table: Table) -> list[dict[str, Any]]:
    cfg = settings.section("input")["data"]
    path = data_file(settings, table)
    nulls = set(cfg.get("null_values", [""]))
    fmt = cfg.get("format", "csv").lower()
    by_name = {c.name: c for c in table.columns}
    rows: list[dict[str, Any]] = []
    if fmt == "csv":
        with path.open(encoding=cfg.get("encoding", "utf-8"), newline="") as fh:
            raw_rows = list(csv.DictReader(fh))
    elif fmt in ("jsonl", "ndjson"):
        raw_rows = [json.loads(line) for line in path.read_text(encoding=cfg.get("encoding", "utf-8")).splitlines() if line.strip()]
    else:
        raise SystemExit(f"Unsupported input.data.format '{fmt}' (csv | jsonl)")
    unknown: set[str] = set()
    for i, raw in enumerate(raw_rows, start=2):
        row: dict[str, Any] = {}
        for k, v in raw.items():
            if k is None:
                continue
            if isinstance(v, str) and v in nulls:
                v = None
            col = by_name.get(k)
            if col is None:
                unknown.add(k)
                row[k] = v
                continue
            try:
                row[k] = convert(col, v)
            except (ValueError, TypeError) as exc:
                raise SystemExit(f"{path.name} line {i}: column {k} ({col.type}) cannot read {v!r}: {exc}") from exc
        rows.append(row)
    if unknown:
        log.warning("%s: columns not in the DDL kept as text: %s", table.id, ", ".join(sorted(unknown)))
    return rows


def read_all(settings: Settings, model: DataModel) -> Rows:
    rows = {tid: read_table(settings, t) for tid, t in model.tables.items()}
    log.info("Read %d rows from %d data files", sum(len(r) for r in rows.values()), len(rows))
    return rows
