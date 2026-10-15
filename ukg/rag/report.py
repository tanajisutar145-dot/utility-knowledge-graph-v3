"""Markdown run report (``output/report.md``)."""

from __future__ import annotations

import json
from datetime import datetime
from pathlib import Path
from typing import TYPE_CHECKING

from ukg.settings import Settings

if TYPE_CHECKING:
    from ukg.rag.runner import QuestionResult


def _fence(text: str, lang: str = "") -> str:
    return f"```{lang}\n{text.strip()}\n```"


def _cut(text: str, limit: int) -> str:
    return text if len(text) <= limit else text[:limit] + f"\n... [{len(text) - limit} more characters]"


def write_report(settings: Settings, results: list["QuestionResult"], schema_text: str) -> Path:
    path = settings.path(settings.section("output").get("report", "output/report.md"))
    max_chars = int(settings.section("rag").get("max_context_chars", 12000))
    llm = settings.llm
    emb = settings.embedding
    out = [
        f"# {settings.section('project').get('name', 'Knowledge graph')} - GraphRAG run report",
        "",
        f"Generated {datetime.now():%Y-%m-%d %H:%M}. LLM: `{llm.provider}/{llm.model}`"
        + (f"; embedder: `{emb.provider}/{emb.model}`" if emb else "") if llm else "",
        "",
        "## Summary",
        "",
        "| # | Use case | Question | Chosen retriever | Facts found (chosen) | Time (s) | Other retrievers |",
        "|---|---|---|---|---|---|---|",
    ]
    for r in results:
        c = r.run(r.chosen)
        others = ", ".join(
            f"{x.retriever}: {'error' if x.error else f'{x.score:.0%}'}" for x in r.runs if x.retriever != r.chosen
        )
        out.append(f"| {r.id} | {r.use_case} | {r.title} | `{r.chosen}` | {c.score:.0%} | {c.total_s:.1f} | {others or '-'} |"
                   if c else f"| {r.id} | {r.use_case} | {r.title} | - | - | - | - |")
    out += ["", "Facts found = share of the question's expected facts (`must_contain` in questions.yaml) that "
            "appear in the generated answer. The ground-truth Cypher below each question is deterministic.", ""]

    for r in results:
        out += [f"## {r.id} - {r.title}", "", f"**Use case.** {r.use_case}", "", f"**Question.** {r.question}", "", f"**Graph pattern.** {r.pattern}", "",
                f"**Chosen retriever:** `{r.chosen}` - {r.justification}", ""]
        c = r.run(r.chosen)
        if c:
            out += ["### Answer", "", c.answer or f"_error: {c.error}_", ""]
            out += [f"Timing: retrieval {c.retrieval_s:.2f}s, generation {c.generation_s:.2f}s, total {c.total_s:.2f}s. "
                    f"Expected facts found: {len(c.matched)}/{len(c.matched) + len(c.missing)}"
                    + (f" (missing: {', '.join(c.missing)})" if c.missing else "") + ".", ""]
            if c.cypher:
                out += ["### Generated Cypher", "", _fence(c.cypher, "cypher"), ""]
            if c.retrieval_query:
                out += ["### Retrieval query", "", _fence(c.retrieval_query, "cypher"), ""]
            if c.paths:
                out += ["### Paths used", ""] + [f"- `{p}`" for p in c.paths[:20]] + [""]
            out += ["### Retrieved context", "", _fence(_cut("\n---\n".join(c.context) or "(empty)", max_chars)), ""]
        out += ["### Expected answer (from the input data)", "", r.expected_answer, "",
                "### Ground truth (deterministic Cypher)", "", _fence(r.ground_truth_cypher, "cypher"), ""]
        if r.ground_truth:
            keys = list(r.ground_truth[0].keys())
            out += ["| " + " | ".join(keys) + " |", "|" + "---|" * len(keys)]
            for row in r.ground_truth[:25]:
                out.append("| " + " | ".join(json.dumps(row[k], default=str).strip('"') for k in keys) + " |")
            out.append("")
        if len(r.runs) > 1:
            out += ["### Retriever comparison", "", "| Retriever | Facts found | Retrieval s | Generation s | Answer (start) |",
                    "|---|---|---|---|---|"]
            for x in r.runs:
                snippet = (x.error or x.answer).replace("\n", " ").replace("|", "/")[:160]
                out.append(f"| `{x.retriever}`{' (chosen)' if x.retriever == r.chosen else ''} | "
                           f"{'-' if x.error else f'{x.score:.0%}'} | {x.retrieval_s:.2f} | {x.generation_s:.2f} | {snippet} |")
            out.append("")
    out += ["## Schema given to Text2Cypher", "", _fence(schema_text), ""]
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(out), encoding="utf-8")
    return path
