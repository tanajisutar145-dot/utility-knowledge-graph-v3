"""Brand guard.

Upstream comments occasionally name commercial systems. This module replaces
those spans with a neutral placeholder and scans generated files so no brand
name leaks into DDL, data, ontology or reports.

The deny-list is stored as truncated SHA-256 hashes in ``config.yaml`` so the
repository itself never contains the names it removes. Matching is token based:
a token whose hash is on the list starts a span, and the span grows over the
following capitalised tokens (product names are usually multi-word, e.g.
"<Vendor> Asset Suite EAM").
"""

from __future__ import annotations

import hashlib
import re
from dataclasses import dataclass
from pathlib import Path

_TOKEN = re.compile(r"[A-Za-z0-9][A-Za-z0-9/&\-]*")


def _h(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()[:16]


@dataclass(frozen=True)
class BrandGuard:
    case_insensitive: frozenset[str]
    case_sensitive: frozenset[str]
    replacement: str = "[vendor system]"

    @classmethod
    def from_config(cls, cfg: dict) -> "BrandGuard":
        s = cfg.get("sanitize", {}) or {}
        if not s.get("enabled", True):
            return cls(frozenset(), frozenset(), s.get("replacement", "[vendor system]"))
        return cls(
            case_insensitive=frozenset(s.get("case_insensitive_sha256", [])),
            case_sensitive=frozenset(s.get("case_sensitive_sha256", [])),
            replacement=s.get("replacement", "[vendor system]"),
        )

    def is_brand(self, token: str) -> bool:
        if _h(token) in self.case_sensitive:
            return True
        return len(token) > 3 and _h(token.lower()) in self.case_insensitive

    def clean(self, text: str) -> str:
        """Replace every brand span in ``text`` with the placeholder."""
        if not text:
            return text
        tokens = list(_TOKEN.finditer(text))
        out: list[str] = []
        pos = 0
        i = 0
        while i < len(tokens):
            tok = tokens[i]
            if not self.is_brand(tok.group()):
                i += 1
                continue
            start, end = tok.start(), tok.end()
            j = i + 1
            # Extend over following capitalised / brand tokens separated by one space.
            while j < len(tokens):
                gap = text[end : tokens[j].start()]
                nxt = tokens[j].group()
                if gap != " " or not (nxt[0].isupper() or self.is_brand(nxt)):
                    break
                end = tokens[j].end()
                j += 1
            out.append(text[pos:start])
            out.append(self.replacement)
            pos = end
            i = j
        out.append(text[pos:])
        return "".join(out)

    def find(self, text: str) -> list[str]:
        """Return the brand tokens present in ``text`` (as hashes, never names)."""
        return sorted({_h(t.group()) for t in _TOKEN.finditer(text) if self.is_brand(t.group())})

    def scan_paths(self, paths: list[Path]) -> dict[str, int]:
        """Count brand tokens per generated file. Empty dict means clean."""
        hits: dict[str, int] = {}
        for base in paths:
            files = [base] if base.is_file() else [p for p in base.rglob("*") if p.is_file()]
            for f in files:
                if f.suffix.lower() not in {".sql", ".csv", ".ttl", ".json", ".md", ".html", ".txt", ".yaml"}:
                    continue
                n = len(self.find(f.read_text(encoding="utf-8", errors="ignore")))
                if n:
                    hits[str(f)] = n
        return hits
