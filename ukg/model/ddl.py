"""Generic SQL DDL parser -> typed relational model.

Works on any SQL dialect that writes tables in the usual shape (Databricks /
Spark SQL, ANSI, PostgreSQL, Snowflake, SQL Server style brackets):

* ``CREATE [OR REPLACE] TABLE [IF NOT EXISTS] [cat.][schema.]table ( ... )``
  with column definitions (type, ``NOT NULL``, ``DEFAULT``, ``COMMENT``,
  inline ``PRIMARY KEY`` / ``REFERENCES``) and table constraints
  (``[CONSTRAINT n] PRIMARY KEY (...)``, ``FOREIGN KEY (...) REFERENCES ...``);
* trailing table options: ``COMMENT '...'`` and ``TBLPROPERTIES ('k' = 'v', ...)``;
* ``ALTER TABLE ... ADD [CONSTRAINT n] FOREIGN KEY (...) REFERENCES ...``;
* ``CREATE SCHEMA|DATABASE ... COMMENT '...'`` (subject-area descriptions).

Identifiers may be quoted with backticks, double quotes or brackets. Statements
are split on ``;`` outside string literals; ``--`` and ``/* */`` comments are
ignored. Anything else (``USE``, ``DROP``, ``GRANT``, views...) is skipped.

The parser never needs to know the target catalog: tables are identified by
``schema.table`` (the last two name parts). One-part names get
``ddl.default_schema``.
"""

from __future__ import annotations

import glob
import logging
import re
from dataclasses import dataclass, field
from pathlib import Path

log = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Lexing helpers
# ---------------------------------------------------------------------------
_IDENT = r'(?:`[^`]+`|"[^"]+"|\[[^\]]+\]|[A-Za-z_][\w$]*)'
_QNAME = rf"{_IDENT}(?:\s*\.\s*{_IDENT}){{0,2}}"

_CREATE_TABLE = re.compile(
    rf"^\s*CREATE\s+(?:OR\s+REPLACE\s+)?(?:(?:GLOBAL\s+|LOCAL\s+)?(?:TEMPORARY|TEMP)\s+)?(?:EXTERNAL\s+)?TABLE\s+"
    rf"(?:IF\s+NOT\s+EXISTS\s+)?(?P<name>{_QNAME})\s*\(", re.I | re.S)
_CREATE_SCHEMA = re.compile(
    rf"^\s*CREATE\s+(?:SCHEMA|DATABASE)\s+(?:IF\s+NOT\s+EXISTS\s+)?(?P<name>{_QNAME})(?P<rest>.*)$", re.I | re.S)
_ALTER_FK = re.compile(
    rf"^\s*ALTER\s+TABLE\s+(?:ONLY\s+)?(?P<table>{_QNAME})\s+ADD\s+(?:CONSTRAINT\s+(?P<name>{_IDENT})\s+)?"
    rf"FOREIGN\s+KEY\s*\((?P<cols>[^)]*)\)\s*REFERENCES\s+(?P<ref>{_QNAME})\s*\((?P<rcols>[^)]*)\)", re.I | re.S)
_ALTER_PK = re.compile(
    rf"^\s*ALTER\s+TABLE\s+(?:ONLY\s+)?(?P<table>{_QNAME})\s+ADD\s+(?:CONSTRAINT\s+(?P<name>{_IDENT})\s+)?"
    rf"PRIMARY\s+KEY\s*\((?P<cols>[^)]*)\)", re.I | re.S)
_TBL_PK = re.compile(rf"^(?:CONSTRAINT\s+(?P<name>{_IDENT})\s+)?PRIMARY\s+KEY\s*\((?P<cols>[^)]*)\)", re.I | re.S)
_TBL_FK = re.compile(
    rf"^(?:CONSTRAINT\s+(?P<name>{_IDENT})\s+)?FOREIGN\s+KEY\s*\((?P<cols>[^)]*)\)\s*REFERENCES\s+(?P<ref>{_QNAME})"
    rf"\s*\((?P<rcols>[^)]*)\)", re.I | re.S)
_TBL_OTHER = re.compile(r"^(?:CONSTRAINT\s+\S+\s+)?(?:UNIQUE|CHECK|INDEX|KEY)\b", re.I)
_COL = re.compile(rf"^(?P<name>{_IDENT})\s+(?P<type>[A-Za-z_][\w ]*?(?:\s*\([^)]*\))?(?:<[^>]*>)?)(?=\s|$)(?P<rest>.*)$", re.I | re.S)
_STRING = re.compile(r"'((?:[^'\\]|\\.|'')*)'", re.S)
_COMMENT_KW = re.compile(r"\bCOMMENT\s+(?:IS\s+)?'((?:[^'\\]|\\.|'')*)'", re.I | re.S)
_TBLPROPS = re.compile(r"\bTBLPROPERTIES\s*\((?P<body>.*?)\)\s*$", re.I | re.S)
_PROP = re.compile(r"'((?:[^'\\]|\\.)*)'\s*=\s*'((?:[^'\\]|\\.)*)'")
_INLINE_REF = re.compile(rf"\bREFERENCES\s+(?P<ref>{_QNAME})\s*\((?P<rcols>[^)]*)\)", re.I)

# Hints embedded in column comments (used for validation, enums and the UI).
_VALID_VALUES = [re.compile(r"Valid values are `([^`]+)`"), re.compile(r"Valid values:\s*([^\s.][^.]*?)\.(?:\s|$)")]
_PATTERN = re.compile(r"Pattern:\s*(\^\S+?\$)")
_TYPE_WORDS = {"NOT", "NULL", "DEFAULT", "COMMENT", "PRIMARY", "REFERENCES", "GENERATED", "CONSTRAINT", "CHECK",
               "UNIQUE", "COLLATE", "MASK", "IDENTITY", "AUTO_INCREMENT", "AUTOINCREMENT"}


def unquote(ident: str) -> str:
    ident = ident.strip()
    if len(ident) >= 2 and ident[0] in "`\"[" and ident[-1] in "`\"]":
        return ident[1:-1]
    return ident


def split_qname(qname: str) -> list[str]:
    parts, cur, quote = [], "", None
    for ch in qname.strip():
        if quote:
            cur += ch
            if ch == quote:
                quote = None
        elif ch in "`\"":
            quote = ch
            cur += ch
        elif ch == "[":
            quote = "]"
            cur += ch
        elif ch == ".":
            parts.append(unquote(cur))
            cur = ""
        elif not ch.isspace():
            cur += ch
    if cur:
        parts.append(unquote(cur))
    return parts


def unescape(text: str) -> str:
    return text.replace("''", "'").replace("\\'", "'").replace('\\"', '"').replace("\\\\", "\\")


def split_statements(sql: str) -> list[str]:
    """Split on ``;`` outside strings/identifiers; drop ``--`` and ``/* */`` comments."""
    out: list[str] = []
    buf: list[str] = []
    i, n = 0, len(sql)
    quote: str | None = None
    while i < n:
        ch = sql[i]
        if quote:
            buf.append(ch)
            if ch == "\\" and quote == "'" and i + 1 < n:
                buf.append(sql[i + 1])
                i += 2
                continue
            if ch == quote:
                if quote == "'" and i + 1 < n and sql[i + 1] == "'":
                    buf.append("'")
                    i += 2
                    continue
                quote = None
            i += 1
            continue
        if ch == "-" and sql.startswith("--", i):
            j = sql.find("\n", i)
            i = n if j < 0 else j
            continue
        if ch == "/" and sql.startswith("/*", i):
            j = sql.find("*/", i + 2)
            i = n if j < 0 else j + 2
            continue
        if ch in "'`\"":
            quote = ch
        elif ch == "[":
            quote = "]"
        if ch == ";":
            stmt = "".join(buf).strip()
            if stmt:
                out.append(stmt)
            buf = []
        else:
            buf.append(ch)
        i += 1
    tail = "".join(buf).strip()
    if tail:
        out.append(tail)
    return out


def split_top_level(body: str, sep: str = ",") -> list[str]:
    """Split on ``sep`` outside parentheses, angle brackets and quotes."""
    parts, buf, depth, quote = [], [], 0, None
    i = 0
    while i < len(body):
        ch = body[i]
        if quote:
            buf.append(ch)
            if ch == "\\" and quote == "'" and i + 1 < len(body):
                buf.append(body[i + 1])
                i += 2
                continue
            if ch == quote:
                quote = None
            i += 1
            continue
        if ch in "'`\"":
            quote = ch
        elif ch in "(<":
            depth += 1
        elif ch in ")>":
            depth -= 1
        if ch == sep and depth == 0:
            parts.append("".join(buf).strip())
            buf = []
        else:
            buf.append(ch)
        i += 1
    if "".join(buf).strip():
        parts.append("".join(buf).strip())
    return parts


def _matching_paren(text: str, start: int) -> int:
    """Index of the ``)`` matching the ``(`` at ``start`` (quotes respected)."""
    depth, quote, i = 0, None, start
    while i < len(text):
        ch = text[i]
        if quote:
            if ch == "\\" and quote == "'":
                i += 2
                continue
            if ch == quote:
                quote = None
        elif ch in "'`\"":
            quote = ch
        elif ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1
            if depth == 0:
                return i
        i += 1
    raise ValueError("unbalanced parentheses in CREATE TABLE")


# ---------------------------------------------------------------------------
# Model
# ---------------------------------------------------------------------------
@dataclass
class Column:
    name: str
    type: str
    nullable: bool = True
    comment: str = ""

    @property
    def base_type(self) -> str:
        return re.split(r"[\s(<]", self.type.strip(), maxsplit=1)[0].upper()

    @property
    def enum_values(self) -> list[str]:
        """Allowed values declared in the comment (``Valid values: a|b|c``)."""
        for rx in _VALID_VALUES:
            m = rx.search(self.comment)
            if m and "|" in m.group(1) and not m.group(1).startswith("^"):
                return [v.strip() for v in m.group(1).split("|") if v.strip()]
        return []

    @property
    def pattern(self) -> str | None:
        m = _PATTERN.search(self.comment)
        return m.group(1) if m else None


@dataclass(frozen=True)
class ForeignKey:
    name: str
    schema: str
    table: str
    column: str
    ref_schema: str
    ref_table: str
    ref_column: str

    @property
    def table_id(self) -> str:
        return f"{self.schema}.{self.table}"

    @property
    def ref_table_id(self) -> str:
        return f"{self.ref_schema}.{self.ref_table}"

    @property
    def is_self(self) -> bool:
        return self.table_id == self.ref_table_id

    @property
    def is_cross_domain(self) -> bool:
        return self.schema != self.ref_schema


@dataclass
class Table:
    schema: str
    name: str
    columns: list[Column] = field(default_factory=list)
    primary_key: list[str] = field(default_factory=list)
    comment: str = ""
    properties: dict[str, str] = field(default_factory=dict)
    source_file: str = ""

    @property
    def id(self) -> str:
        return f"{self.schema}.{self.name}"

    @property
    def pk(self) -> str | None:
        """Single-column primary key (composite keys are joined with '|')."""
        return "|".join(self.primary_key) if self.primary_key else None

    def column(self, name: str) -> Column:
        for c in self.columns:
            if c.name == name:
                return c
        raise KeyError(f"{self.id}.{name}")

    def has_column(self, name: str) -> bool:
        return any(c.name == name for c in self.columns)

    @property
    def column_names(self) -> list[str]:
        return [c.name for c in self.columns]


@dataclass
class DataModel:
    """Every table, schema comment and FK found in the DDL files."""

    tables: dict[str, Table] = field(default_factory=dict)  # "schema.table" -> Table
    foreign_keys: list[ForeignKey] = field(default_factory=list)
    schemas: dict[str, str] = field(default_factory=dict)  # schema -> comment

    def table(self, table_id: str) -> Table:
        return self.tables[table_id]

    def fks_from(self, table_id: str) -> list[ForeignKey]:
        return [fk for fk in self.foreign_keys if fk.table_id == table_id]

    def fk_for(self, table_id: str, column: str) -> ForeignKey | None:
        return next((fk for fk in self.foreign_keys if fk.table_id == table_id and fk.column == column), None)

    def scoped(self, wanted: list[str]) -> "DataModel":
        """Keep ``wanted`` table ids and only the FKs whose both ends are kept."""
        keep = set(wanted)
        missing = sorted(keep - set(self.tables))
        if missing:
            raise SystemExit(f"Tables not defined in the DDL: {', '.join(missing)}")
        return DataModel(
            tables={t: self.tables[t] for t in wanted},
            foreign_keys=[fk for fk in self.foreign_keys if fk.table_id in keep and fk.ref_table_id in keep],
            schemas={s: c for s, c in self.schemas.items() if any(t.split(".")[0] == s for t in keep)},
        )

    def dangling_reference_columns(self, table_id: str) -> set[str]:
        """FK columns declared in the full model whose target is out of scope (filled by nothing)."""
        return {fk.column for fk in self.foreign_keys if fk.table_id == table_id and fk.ref_table_id not in self.tables}

    def topological_tables(self) -> list[str]:
        """Parents before children (self references and cycles tolerated)."""
        deps = {t: {fk.ref_table_id for fk in self.fks_from(t) if not fk.is_self and fk.ref_table_id in self.tables}
                for t in self.tables}
        order: list[str] = []
        while deps:
            ready = sorted(t for t, d in deps.items() if not (d - set(order)))
            if not ready:  # cycle: break it at the table with the fewest unmet dependencies
                ready = [min(deps, key=lambda t: (len(deps[t] - set(order)), t))]
            order.extend(ready)
            for t in ready:
                deps.pop(t)
        return order


# ---------------------------------------------------------------------------
# Parser
# ---------------------------------------------------------------------------
class DDLParser:
    def __init__(self, default_schema: str = "default"):
        self.default_schema = default_schema

    def _schema_table(self, qname: str) -> tuple[str, str]:
        parts = split_qname(qname)
        if len(parts) == 1:
            return self.default_schema, parts[0]
        return parts[-2], parts[-1]

    def parse_files(self, patterns: list[str], root: Path) -> DataModel:
        files: list[Path] = []
        for pat in patterns:
            matches = sorted(Path(p) for p in glob.glob(str(root / pat)))
            if not matches:
                log.warning("DDL pattern matched no files: %s", pat)
            files.extend(m for m in matches if m not in files)
        if not files:
            raise SystemExit(f"No DDL files found for {patterns} under {root}")
        model = DataModel()
        pending_fks: list[ForeignKey] = []
        pending_pks: list[tuple[str, list[str]]] = []
        for f in files:
            self._parse_text(f.read_text(encoding="utf-8", errors="replace"), f.name, model, pending_fks, pending_pks)
        for tid, cols in pending_pks:
            if tid in model.tables and not model.tables[tid].primary_key:
                model.tables[tid].primary_key = cols
        seen: set[tuple[str, str]] = set()
        for fk in pending_fks:
            key = (fk.table_id, fk.column)
            if key not in seen:
                seen.add(key)
                model.foreign_keys.append(fk)
        log.info("DDL: %d files, %d schemas, %d tables, %d foreign keys", len(files), len(model.schemas),
                 len(model.tables), len(model.foreign_keys))
        return model

    def _parse_text(self, text: str, source: str, model: DataModel, fks: list[ForeignKey],
                    pks: list[tuple[str, list[str]]]) -> None:
        for stmt in split_statements(text):
            head = stmt.lstrip()[:40].upper()
            if head.startswith("CREATE") and " TABLE" in stmt[:120].upper() and (m := _CREATE_TABLE.match(stmt)):
                table, table_fks = self._parse_create(stmt, m, source)
                model.tables[table.id] = table
                fks.extend(table_fks)
            elif head.startswith("CREATE") and (m := _CREATE_SCHEMA.match(stmt)):
                parts = split_qname(m.group("name"))
                c = _COMMENT_KW.search(m.group("rest"))
                model.schemas[parts[-1]] = unescape(c.group(1)) if c else model.schemas.get(parts[-1], "")
            elif head.startswith("ALTER"):
                if m := _ALTER_FK.match(stmt):
                    fks.extend(self._fks(m.group("table"), m.group("name"), m.group("cols"), m.group("ref"), m.group("rcols")))
                elif m := _ALTER_PK.match(stmt):
                    s, t = self._schema_table(m.group("table"))
                    pks.append((f"{s}.{t}", [unquote(c) for c in m.group("cols").split(",")]))

    def _fks(self, table: str, name: str | None, cols: str, ref: str, rcols: str) -> list[ForeignKey]:
        s, t = self._schema_table(table)
        rs, rt = self._schema_table(ref)
        col_list = [unquote(c) for c in cols.split(",")]
        ref_list = [unquote(c) for c in rcols.split(",")]
        fk_name = unquote(name) if name else f"fk_{s}_{t}_{'_'.join(col_list)}"
        # Composite FKs are kept as one FK per column pair (graph edges are single-valued here).
        return [ForeignKey(fk_name, s, t, c, rs, rt, r) for c, r in zip(col_list, ref_list)]

    def _parse_create(self, stmt: str, m: re.Match[str], source: str) -> tuple[Table, list[ForeignKey]]:
        schema, name = self._schema_table(m.group("name"))
        table = Table(schema=schema, name=name, source_file=source)
        open_at = m.end() - 1
        close_at = _matching_paren(stmt, open_at)
        body, tail = stmt[open_at + 1 : close_at], stmt[close_at + 1 :]
        fks: list[ForeignKey] = []
        for item in split_top_level(body):
            if not item:
                continue
            if pk := _TBL_PK.match(item):
                table.primary_key = [unquote(c) for c in pk.group("cols").split(",")]
                continue
            if fk := _TBL_FK.match(item):
                fks.extend(self._fks(m.group("name"), fk.group("name"), fk.group("cols"), fk.group("ref"), fk.group("rcols")))
                continue
            if _TBL_OTHER.match(item):
                continue
            col = self._parse_column(item)
            if col is None:
                continue
            table.columns.append(col)
            rest_upper = item.upper()
            if re.search(r"\bPRIMARY\s+KEY\b", rest_upper) and not table.primary_key:
                table.primary_key = [col.name]
            if ref := _INLINE_REF.search(item):
                fks.extend(self._fks(m.group("name"), None, col.name, ref.group("ref"), ref.group("rcols")))
        # Table options after the column list.
        props = _TBLPROPS.search(tail)
        if props:
            table.properties = {unescape(k): unescape(v) for k, v in _PROP.findall(props.group("body"))}
            tail = tail[: props.start()]
        c = _COMMENT_KW.search(tail)
        table.comment = unescape(c.group(1)) if c else ""
        return table, fks

    def _parse_column(self, item: str) -> Column | None:
        m = _COL.match(item.strip())
        if not m:
            return None
        type_words, rest = [], m.group("type").split()
        # The type regex is greedy over words; keep words until a keyword starts the constraints.
        for w in rest:
            if w.upper().split("(")[0] in _TYPE_WORDS:
                break
            type_words.append(w)
        col_type = " ".join(type_words) or m.group("type")
        tail = item[m.start("type") + len(col_type):] if col_type else m.group("rest")
        comment = _COMMENT_KW.search(item)
        return Column(
            name=unquote(m.group("name")),
            type=col_type.upper().replace(" (", "("),
            nullable=not re.search(r"\bNOT\s+NULL\b", tail, re.I) and not re.search(r"\bPRIMARY\s+KEY\b", tail, re.I),
            comment=unescape(comment.group(1)) if comment else "",
        )


def load_data_model(patterns: list[str], root: Path, default_schema: str = "default") -> DataModel:
    return DDLParser(default_schema).parse_files(patterns, root)
