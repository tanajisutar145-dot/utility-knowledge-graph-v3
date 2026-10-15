"""Answer the demo questions with GraphRAG and trace everything.

For each question in ``rag.questions_file``:

* run the **ground-truth Cypher** (deterministic, no LLM) - the verifiable answer;
* run every retriever (or only the configured best one) wrapped in ``GraphRAG``,
  timing retrieval and generation separately;
* score each answer against the question's expected facts (``must_contain``);
* print the chosen retriever's trace: generated Cypher / retrieval query,
  retrieved context, paths used, answer, timing.

Results are written to ``output/report.md`` and ``output/run_results.json``.
"""

from __future__ import annotations

import json
import logging
import re
import time
from dataclasses import asdict, dataclass, field
from typing import Any, Callable

import neo4j
import yaml
from neo4j_graphrag.generation import GraphRAG, RagTemplate

from ukg.kg.neo4j_client import database, get_driver
from ukg.ontology.extract import SemanticModel
from ukg.ontology.schema import build_extraction_schema, load_structured_schema, schema_as_text
from ukg.rag.providers import create_embedder, create_llm, preflight
from ukg.rag.report import write_report
from ukg.rag.retrievers import RETRIEVERS, CypherFragments, build_retriever
from ukg.sanitize import BrandGuard
from ukg.settings import Settings

log = logging.getLogger(__name__)


def rag_system(settings: Settings, sem: SemanticModel) -> str:
    persona = settings.section("project").get("persona", "domain analyst")
    std = sem.standard.get("name", "the standard")
    return (f"You are a {persona} answering questions from a knowledge graph whose classes are aligned to {std}. "
            "Use ONLY the provided context. Quote record identifiers (feeder, device, transformer, event, inspection, "
            "work order and clearance numbers), dates and figures exactly as they appear. When the answer is a list, give "
            f"every item. Where it helps, name the {sem.standard.get('short', 'standard')} class shown in brackets. "
            "If the context does not contain the answer, say what is missing instead of guessing.")


@dataclass
class RetrieverRun:
    retriever: str
    answer: str = ""
    cypher: str = ""
    retrieval_query: str = ""
    context: list[str] = field(default_factory=list)
    paths: list[str] = field(default_factory=list)
    retrieval_s: float = 0.0
    generation_s: float = 0.0
    total_s: float = 0.0
    score: float = 0.0
    matched: list[str] = field(default_factory=list)
    missing: list[str] = field(default_factory=list)
    error: str | None = None


@dataclass
class QuestionResult:
    id: str
    title: str
    use_case: str
    question: str
    pattern: str
    chosen: str
    justification: str
    expected_answer: str
    ground_truth: list[dict[str, Any]]
    ground_truth_cypher: str
    runs: list[RetrieverRun]

    def run(self, name: str) -> RetrieverRun | None:
        return next((r for r in self.runs if r.retriever == name), None)


def load_questions(settings: Settings) -> dict[str, Any]:
    path = settings.path(settings.section("rag").get("questions_file", "user_questions/questions.yaml"))
    return yaml.safe_load(path.read_text(encoding="utf-8"))


def score_answer(answer: str, must: list[Any]) -> tuple[float, list[str], list[str]]:
    """Fraction of expected facts present. Each fact is a string or a list of alternatives."""
    norm = re.sub(r"[\s,]+", " ", answer.lower())
    matched, missing = [], []
    for fact in must:
        options = fact if isinstance(fact, list) else [fact]
        hit = any(re.sub(r"[\s,]+", " ", str(o).lower()) in norm for o in options)
        (matched if hit else missing).append(" | ".join(map(str, options)))
    return (len(matched) / len(must) if must else 0.0), matched, missing


def populated_properties(driver: neo4j.Driver, db: str, sem: SemanticModel) -> dict[str, set[str]]:
    out = {}
    for t in sem.tables.values():
        recs = driver.execute_query(f"MATCH (n:`{t.label}`) WITH n LIMIT 500 UNWIND keys(n) AS k RETURN collect(DISTINCT k) AS ks",
                                    database_=db)[0]
        out[t.label] = set(recs[0]["ks"]) if recs else set()
    return out


def has_chunks(driver: neo4j.Driver, db: str) -> bool:
    labels = driver.execute_query("CALL db.labels() YIELD label RETURN collect(label) AS ls", database_=db)[0][0]["ls"]
    if "Chunk" not in labels:
        return False
    return driver.execute_query("MATCH (c:Chunk) WHERE c.embedding IS NOT NULL RETURN count(c) > 0 AS ok", database_=db)[0][0]["ok"]


def has_entities(driver: neo4j.Driver, db: str) -> bool:
    return driver.execute_query("MATCH ()-[r:MENTIONS]->() RETURN count(r) > 0 AS ok", database_=db)[0][0]["ok"]


def text2cypher_examples(spec: dict[str, Any]) -> list[str]:
    return [f"USER INPUT: '{e['question']}' QUERY: {' '.join(e['cypher'].split())}" for e in spec.get("text2cypher_examples", [])]


def _truncate(text: str, limit: int) -> str:
    return text if len(text) <= limit else text[:limit] + f"\n... [{len(text) - limit} more characters]"


def run_questions(settings: Settings, only: str | None = None) -> list[QuestionResult]:
    driver = get_driver(settings)
    db = database(settings)
    sem = SemanticModel.load(settings)
    structured = load_structured_schema(settings)
    chunks = has_chunks(driver, db)
    extraction = build_extraction_schema(settings) if has_entities(driver, db) else None
    schema_text = schema_as_text(settings, structured, sem, populated_properties(driver, db, sem), extraction, chunks)
    out_dir = settings.output_dir
    out_dir.mkdir(parents=True, exist_ok=True)
    (out_dir / "text2cypher_schema.txt").write_text(schema_text, encoding="utf-8")

    llm = create_llm(settings)
    embedder = create_embedder(settings)
    preflight(llm, embedder)
    fragments = CypherFragments(settings, sem)
    spec = load_questions(settings)
    examples = text2cypher_examples(spec)
    template = RagTemplate(system_instructions=rag_system(settings, sem))
    rag = settings.section("rag")
    compare_all = bool(rag.get("compare_all_retrievers", True))
    max_chars = int(rag.get("max_context_chars", 12000))

    results: list[QuestionResult] = []
    for q in spec["questions"]:
        if only and q["id"].lower() != only.lower():
            continue
        truth = [r.data() for r in driver.execute_query(q["ground_truth_cypher"], database_=db, routing_=neo4j.RoutingControl.READ)[0]]
        names = list(RETRIEVERS) if compare_all else [q["best_retriever"]]
        if not chunks:
            names = [n for n in names if n == "text2cypher"]
            log.warning("No embedded narrative chunks in the graph: vector/hybrid retrievers skipped")
        runs = [run_one(n, q, settings, driver, db, llm, embedder, fragments, schema_text, examples, template) for n in names]
        chosen = q["best_retriever"] if any(r.retriever == q["best_retriever"] for r in runs) else runs[0].retriever
        result = QuestionResult(q["id"], q["title"], q.get("use_case", ""), q["question"].strip(), q.get("pattern", ""), chosen,
                                " ".join(q.get("why_best", "").split()), " ".join(q.get("expected_answer", "").split()),
                                truth, q["ground_truth_cypher"].strip(), runs)
        results.append(result)
        _print_trace(result, max_chars)

    guard = BrandGuard.from_config(settings.config)
    for r in results:
        for run in r.runs:
            run.answer = guard.clean(run.answer)
    (out_dir / "run_results.json").write_text(json.dumps([asdict(r) for r in results], indent=2, default=str), encoding="utf-8")
    report = write_report(settings, results, schema_text)
    log.info("Report written to %s", report)
    driver.close()
    return results


EventFn = Callable[[str, dict[str, Any]], None]


def run_one(name: str, q: dict[str, Any], settings: Settings, driver: neo4j.Driver, db: str, llm: Any, embedder: Any,
            fragments: CypherFragments, schema_text: str, examples: list[str], template: RagTemplate,
            on_event: EventFn | None = None, message_history: list[dict[str, str]] | None = None,
            response_fallback: str | None = None) -> RetrieverRun:
    """Run one retriever through GraphRAG for question ``q``.

    ``on_event(stage, data)`` is called when retrieval finishes (stage
    ``"retrieved"``) so a UI can show progress; ``response_fallback`` skips the
    LLM call when retrieval returns nothing.
    """
    run = RetrieverRun(retriever=name)
    emit = on_event or (lambda stage, data: None)
    try:
        retriever, cfg, query = build_retriever(name, settings, driver, db, llm, embedder, fragments,
                                                q.get("retrieval_template", "neighbourhood"), schema_text, examples)
        run.retrieval_query = query
        if "top_k" in cfg and q.get("top_k"):
            cfg["top_k"] = int(q["top_k"])
        timing: dict[str, float] = {}
        original = retriever.search

        def timed_search(*args: Any, **kwargs: Any) -> Any:
            t = time.perf_counter()
            try:
                result = original(*args, **kwargs)
            finally:
                timing["retrieval"] = time.perf_counter() - t
            emit("retrieved", {"retriever": name, "seconds": timing["retrieval"],
                               "cypher": (result.metadata or {}).get("cypher", "") or "",
                               "items": [str(i.content) for i in result.items],
                               "paths": [p for i in result.items for p in (i.metadata or {}).get("paths", [])]})
            return result

        retriever.search = timed_search  # type: ignore[method-assign]  # instance-level timing hook
        graph_rag = GraphRAG(retriever=retriever, llm=llm, prompt_template=template)
        t0 = time.perf_counter()
        res = graph_rag.search(query_text=q["question"].strip(), retriever_config=cfg, return_context=True,
                               message_history=message_history, response_fallback=response_fallback)
        run.total_s = time.perf_counter() - t0
        run.retrieval_s = timing.get("retrieval", 0.0)
        run.generation_s = run.total_s - run.retrieval_s
        run.answer = res.answer.strip()
        if res.retriever_result is not None:
            run.cypher = (res.retriever_result.metadata or {}).get("cypher", "") or ""
            run.context = [str(i.content) for i in res.retriever_result.items]
            for item in res.retriever_result.items:
                run.paths.extend((item.metadata or {}).get("paths", []))
    except Exception as exc:  # noqa: BLE001 - keep comparing other retrievers
        run.error = f"{type(exc).__name__}: {exc}"
        log.warning("%s / %s failed: %s", q.get("id", "chat"), name, run.error)
    run.score, run.matched, run.missing = score_answer(run.answer, q.get("must_contain", []))
    return run


def _print_trace(r: QuestionResult, max_chars: int) -> None:
    bar = "=" * 100
    chosen = r.run(r.chosen)
    lines = [bar, f"{r.id}  {r.title}  ({r.use_case})", bar, f"Question : {r.question}", f"Pattern  : {r.pattern}",
             f"Retriever: {r.chosen}  (why: {r.justification})"]
    if chosen:
        if chosen.cypher:
            lines += ["Generated Cypher:", "  " + chosen.cypher.replace("\n", "\n  ")]
        if chosen.retrieval_query:
            lines += ["Retrieval query (graph expansion after vector/full-text search):", "  " + chosen.retrieval_query.replace("\n", "\n  ")]
        lines += [f"Retrieved context ({len(chosen.context)} items):", _truncate("\n---\n".join(chosen.context) or "(empty)", max_chars)]
        if chosen.paths:
            lines += ["Paths used:"] + [f"  {p}" for p in chosen.paths[:15]]
        lines += ["Answer:", "  " + (chosen.answer or f"(error: {chosen.error})").replace("\n", "\n  "),
                  f"Timing   : retrieval {chosen.retrieval_s:.2f}s + generation {chosen.generation_s:.2f}s = {chosen.total_s:.2f}s",
                  f"Check    : {chosen.score:.0%} of expected facts ({len(chosen.matched)}/{len(chosen.matched) + len(chosen.missing)})"
                  + (f"; missing: {', '.join(chosen.missing)}" if chosen.missing else "")]
    lines += [f"Ground truth (deterministic Cypher, {len(r.ground_truth)} rows):"]
    lines += [f"  {json.dumps(row, default=str)}" for row in r.ground_truth[:12]]
    if len(r.runs) > 1:
        lines += ["Retriever comparison:"]
        for run in r.runs:
            status = f"error: {run.error}" if run.error else f"{run.score:.0%} facts, {run.total_s:.1f}s"
            lines.append(f" {'*' if run.retriever == r.chosen else ' '} {run.retriever:<14} {status}")
    print("\n".join(lines) + "\n", flush=True)
