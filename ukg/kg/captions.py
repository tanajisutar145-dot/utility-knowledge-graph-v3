"""Node captions and summary properties, derived from config + the semantic model.

A caption is stored on every data node (property ``caption``) at load time, so
retrievers, the evidence graph and visualisations can name a node with one
property whatever its label. ``graph.caption_property`` gives a property name
or a ``{property}`` template per label; other labels use the first column that
matches ``graph.auto_caption`` (``name``, ``*_number``, ``*_code``, ``*_name``).
"""

from __future__ import annotations

import fnmatch
import re
from typing import Any

from ukg.ontology.extract import SemanticModel
from ukg.settings import Settings

PRIMARY_LABEL_EXCLUDE = ("__",)
_PLACEHOLDER = re.compile(r"\{([a-zA-Z0-9_]+)\}")
_SUMMARY_HINT = re.compile(r"(status|type|kind|severity|date|timestamp|count|kv|mva|mw|kw|score|risk|cost|rating)")
_AUDIT = re.compile(r"(created|modified|updated|last_edited|record_|_by$|_user$)")


def primary_label_expr(var: str, std_prefix: str = "CIM_") -> str:
    """Cypher expression for a node's primary (ontology-class) label."""
    return f"[l IN labels({var}) WHERE NOT l STARTS WITH '__' AND NOT l STARTS WITH '{std_prefix}'][0]"


class Captioner:
    def __init__(self, settings: Settings, sem: SemanticModel):
        g = settings.section("graph")
        self.std_prefix = (g.get("standard_labels") or {}).get("prefix", "CIM_")
        overrides: dict[str, str] = g.get("caption_property", {}) or {}
        patterns: list[str] = g.get("auto_caption", ["name", "*_number", "*_code", "*_name"])
        self.spec: dict[str, str] = {}
        self.summary: dict[str, list[str]] = {}
        given = g.get("summary_properties", {}) or {}
        for t in sem.tables.values():
            cols = [c.column for c in t.columns]
            if t.label in overrides:
                self.spec[t.label] = overrides[t.label]
            else:
                pick = next((c for pat in patterns for c in cols if fnmatch.fnmatch(c, pat)), t.primary_key)
                self.spec[t.label] = pick
            if t.label in given:
                self.summary[t.label] = list(given[t.label])
            else:
                first = self.caption_columns(t.label)
                usable = [c for c in t.columns if c.column not in first and not c.column.startswith("cmm_")
                          and not c.column.endswith("_id") and not _AUDIT.search(c.column) and c.column != "mrid"]
                enums = [c.column for c in usable if c.enum_values]
                hints = [c.column for c in usable if _SUMMARY_HINT.search(c.column) and c.column not in enums]
                self.summary[t.label] = (first + enums + hints)[:6]

    def caption_columns(self, label: str) -> list[str]:
        spec = self.spec.get(label, "name")
        found = _PLACEHOLDER.findall(spec)
        return found or [spec]

    def caption(self, label: str, props: dict[str, Any]) -> str:
        spec = self.spec.get(label)
        if spec is None:
            return str(props.get("caption") or props.get("name") or props.get("path") or label)[:60]
        if "{" in spec:
            text = _PLACEHOLDER.sub(lambda m: _fmt(props.get(m.group(1))), spec).strip()
        else:
            text = _fmt(props.get(spec))
        return (text or f"{label} {props.get('_pk', '')}").strip()[:60]


def _fmt(v: Any) -> str:
    if v is None:
        return ""
    if hasattr(v, "isoformat"):
        s = v.isoformat()
        return s[:16].replace("T", " ") if "T" in s else s
    return str(v)
