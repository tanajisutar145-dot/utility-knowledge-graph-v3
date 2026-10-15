"""Question-answering engine behind the web UI.

Reuses the batch pipeline's pieces (providers, retrievers, ``GraphRAG`` via
``runner.run_one``) and adds what an interactive chat needs:

* **routing** - pick a retriever for a free-form question (curated questions use
  their configured retriever; keyword rules come from ``rag.routing``);
* **fallback** - Text2Cypher errors or empty results fall back to hybrid
  search; empty vector/hybrid results fall back to Text2Cypher;
* **evidence graph** - the subgraph shown next to the answer: the question's
  ``subgraph_cypher`` for curated questions, otherwise the records that
  appeared in the retrieved context plus the relationships between them. Every
  node carries its IEC CIM alignment and WGS84 position for the CIM overlay and
  the geo layout;
* **trace** - every step (routing, retrieval, context, generation,
  verification) with timings for the "How it was checked" window.
"""

from __future__ import annotations

import json
import logging
import re
import threading
import time
import uuid
from dataclasses import asdict, dataclass, field
from typing import Any

import neo4j
from neo4j_graphrag.generation import RagTemplate

from ukg.kg.neo4j_client import database, get_driver
from ukg.ontology.extract import SemanticModel
from ukg.ontology.schema import build_extraction_schema, load_structured_schema, schema_as_text
from ukg.rag.providers import create_embedder, create_llm, preflight
from ukg.rag.retrievers import RETRIEVERS, CypherFragments
from ukg.rag.runner import (has_chunks, has_entities, load_questions, populated_properties, rag_system, run_one,
                            score_answer, text2cypher_examples)
from ukg.sanitize import BrandGuard
from ukg.settings import Settings
from ukg.viz.render import LEXICAL, Styler, VizGraph

log = logging.getLogger(__name__)

NO_CONTEXT = "__NO_CONTEXT__"
RETRIEVER_LABELS = {"text2cypher": "Text2Cypher", "vector_cypher": "Vector + graph", "hybrid_cypher": "Hybrid + graph"}

_SMALL_TALK = [
    ("greeting", re.compile(r"^(hi+|hello|hey+|hiya|yo|greetings|good (morning|afternoon|evening|day)|namaste)"
                            r"( there| team| all| everyone| bot)?[\s!.,:)]*$", re.I)),
    ("how_are_you", re.compile(r"^(hi |hello |hey )?(how are (you|u)|how's it going|how do you do)[\s?!.]*$", re.I)),
    ("thanks", re.compile(r"^(thanks|thank you|thank u|thx|ty|many thanks|cheers)( a lot| so much| very much)?[\s!.,)]*$", re.I)),
    ("ack", re.compile(r"^(great|cool|nice|awesome|perfect|ok|okay|got it|good|understood|makes sense)( thanks| job| one)?[\s!.,)]*$", re.I)),
    ("help", re.compile(r"^(help|\?|what can (you|i) (do|ask)( here)?|what do you (do|know)|how (does|do) (this|it|you) work|"
                        r"what (kind of|sort of)? ?questions( can i ask)?|capabilities|menu|examples?)[\s?!.]*$", re.I)),
    ("who", re.compile(r"^(who|what) are you[\s?!.]*$|^(what'?s|what is) your name[\s?!.]*$", re.I)),
    ("bye", re.compile(r"^(bye|goodbye|good bye|see (you|ya)|cya|that'?s all|done)( for now)?[\s!.]*$", re.I)),
]


@dataclass
class Step:
    key: str
    title: str
    status: str = "pending"  # pending | running | done | error | skipped
    seconds: float | None = None
    summary: str = ""
    detail: dict[str, Any] = field(default_factory=dict)


@dataclass
class Job:
    id: str
    question: str
    mode: str
    status: str = "queued"  # queued | running | done | error
    steps: list[Step] = field(default_factory=list)
    answer: str = ""
    retriever: str = ""
    runs: list[dict[str, Any]] = field(default_factory=list)
    graph: dict[str, Any] = field(default_factory=lambda: {"nodes": [], "edges": []})
    verification: dict[str, Any] | None = None
    error: str | None = None
    started: float = field(default_factory=time.time)
    finished: float | None = None

    def step(self, key: str) -> Step:
        return next(s for s in self.steps if s.key == key)

    def to_json(self) -> dict[str, Any]:
        data = asdict(self)
        data["elapsed"] = (self.finished or time.time()) - self.started
        return data


class QAEngine:
    """Long-lived engine: one Neo4j driver, one LLM and embedder, cached schema text."""

    def __init__(self, settings: Settings, sem: SemanticModel):
        self.settings = settings
        self.sem = sem
        self.driver = get_driver(settings)
        self.db = database(settings)
        self.styler = Styler(settings, sem)
        self.std_prefix = self.styler.captioner.std_prefix
        self.guard = BrandGuard.from_config(settings.config)
        structured = load_structured_schema(settings)
        self.has_chunks = has_chunks(self.driver, self.db)
        extraction = build_extraction_schema(settings) if has_entities(self.driver, self.db) else None
        self.schema_text = schema_as_text(settings, structured, sem, populated_properties(self.driver, self.db, sem), extraction,
                                          self.has_chunks)
        self.llm = create_llm(settings)
        self.embedder = create_embedder(settings)
        self.fragments = CypherFragments(settings, sem)
        spec = load_questions(settings)
        self.examples = text2cypher_examples(spec)
        self.demo = spec.get("questions", [])
        self.samples = spec.get("sample_questions", [])
        self.system_prompt = rag_system(settings, sem)
        self.template = RagTemplate(system_instructions=self.system_prompt)
        routing = settings.section("rag").get("routing", {}) or {}
        self.rx = {k: re.compile(routing[k], re.I) for k in ("similar", "structured", "causal") if routing.get(k)}
        self.route_templates = routing.get("templates", {}) or {}
        self._preflight_ok = False
        self._lock = threading.Lock()
        self.jobs: dict[str, Job] = {}
        self.latest_id: str | None = None
        self._captions = self._caption_index()

    # ------------------------------------------------------------------ info
    def info(self) -> dict[str, Any]:
        llm, emb = self.settings.llm, self.settings.embedding
        counts = self.driver.execute_query(
            f"MATCH (n) WHERE NOT n:Chunk AND NOT n:Document "
            f"WITH [l IN labels(n) WHERE NOT l STARTS WITH '__' AND NOT l STARTS WITH '{self.std_prefix}'][0] AS label "
            "RETURN label, count(*) AS c ORDER BY c DESC", database_=self.db)[0]
        rels = self.driver.execute_query("MATCH ()-[r]->() RETURN count(r) AS c", database_=self.db)[0][0]["c"]

        def brief(q: dict[str, Any], kind: str) -> dict[str, Any]:
            return {"id": q["id"], "kind": kind, "title": q.get("title", ""), "question": " ".join(q["question"].split()),
                    "retriever": q.get("best_retriever", ""), "pattern": q.get("pattern", ""), "use_case": q.get("use_case", "")}

        domains = [{"domain": d, "color": c} for d, c in self.styler.domain_colors.items()]
        return {
            "project": self.settings.section("project"),
            "standard": self.sem.standard,
            "llm": f"{llm.provider} / {llm.model}" if llm else "not configured",
            "embedder": f"{emb.provider} / {emb.model}" if emb else "not configured",
            "database": self.db,
            "labels": [{"label": r["label"], "count": r["c"],
                        "color": self.styler.color(r["label"], {"subject_area": self.styler.domain_of.get(r["label"])})}
                       for r in counts if r["label"]],
            "domains": domains,
            "relationships": rels,
            "has_chunks": self.has_chunks,
            "demo_questions": [brief(q, "demo") for q in self.demo],
            "sample_questions": [brief(q, "sample") for q in self.samples],
            "retrievers": [{"id": "auto", "label": "Auto (route + fallback)"}]
                          + [{"id": r, "label": RETRIEVER_LABELS[r]} for r in RETRIEVERS]
                          + [{"id": "compare", "label": "Compare all three"}],
        }

    # ------------------------------------------------------------------ small talk
    def small_talk(self, message: str) -> str | None:
        text = " ".join(message.strip().split())
        if len(text.split()) > 8:
            return None
        kind = next((k for k, rx in _SMALL_TALK if rx.match(text)), None)
        if kind is None:
            return None
        examples = self.demo[:3]
        ex = "\n".join(f"• {' '.join(q['question'].split())}" for q in examples)
        areas = ", ".join(sorted({t.schema for t in self.sem.tables.values()}))
        std = self.sem.standard.get("name", "the standard")
        scope = f"the {areas} subject areas of a {std}-aligned utility data model"
        replies = {
            "greeting": f"Hi! I answer questions from the knowledge graph built over {scope}.\n\nTry one of these, or click Browse questions:\n{ex}",
            "how_are_you": "Doing well - the graph is loaded and ready. What would you like to know?",
            "thanks": "You're welcome. Ask a follow-up any time; I keep the last few turns as context.",
            "ack": "Great. What would you like to look at next? Browse questions has more ideas.",
            "help": f"I turn your question into a graph lookup and show three things:\n"
                    f"• Detailed answer, with a fact check for the demo questions\n"
                    f"• Evidence graph: the records and relationships the answer came from, with their {self.sem.standard.get('short')} "
                    f"classes (toggle the CIM overlay or the geo layout)\n"
                    f"• How it was checked: each backend step, including the generated Cypher\n\n"
                    f"The Model & CIM page shows how every table, column and relationship maps to {std}.\n\nExamples:\n{ex}",
            "who": f"I'm the {self.settings.section('project').get('name', 'knowledge graph')} assistant. I answer from a Neo4j knowledge "
                   f"graph built from DDL, an OWL ontology aligned to {std}, and data files, using GraphRAG retrievers.",
            "bye": "Goodbye! The graph will be here when you come back.",
        }
        return replies[kind]

    # ------------------------------------------------------------------ jobs
    def submit(self, question: str, mode: str, history: list[dict[str, str]]) -> Job:
        job = Job(id=uuid.uuid4().hex[:12], question=question.strip(), mode=mode)
        job.steps = [Step("route", "1. Routing"), Step("retrieve", "2. Retrieval"), Step("context", "3. Context sent to the LLM"),
                     Step("generate", "4. Answer generation"), Step("graph", "5. Evidence graph"), Step("verify", "6. Verification")]
        self.jobs[job.id] = job
        self.latest_id = job.id
        threading.Thread(target=self._run_job, args=(job, history), daemon=True).start()
        return job

    def _run_job(self, job: Job, history: list[dict[str, str]]) -> None:
        with self._lock:  # one question at a time: local LLMs are CPU-bound
            job.status = "running"
            try:
                self._answer(job, history)
                job.status = "done"
            except Exception as exc:  # noqa: BLE001 - surface in the UI instead of killing the worker
                log.exception("Question failed")
                job.status, job.error = "error", f"{type(exc).__name__}: {exc}"
            except SystemExit as exc:
                job.status, job.error = "error", str(exc)
            finally:
                for s in job.steps:
                    if s.status in ("pending", "running"):
                        s.status = "skipped" if job.status == "done" else "error"
                job.finished = time.time()

    # ------------------------------------------------------------------ routing
    def _known(self, question: str) -> dict[str, Any] | None:
        norm = " ".join(question.lower().split())
        return next((q for q in self.demo + self.samples if " ".join(q["question"].lower().split()) == norm), None)

    def route(self, question: str, known: dict[str, Any] | None) -> tuple[str, str, str]:
        """Return ``(retriever, retrieval_template, reason)``."""
        tpl = self.route_templates
        if known:
            return (known["best_retriever"], known.get("retrieval_template", "neighbourhood"),
                    f"{known['id']} is a curated question ({known.get('use_case', '')}); its configured retriever is used. "
                    + " ".join(known.get("why_best", "").split()))
        if not self.has_chunks:
            return "text2cypher", "neighbourhood", "No embedded narrative chunks are loaded, so only Text2Cypher is available."
        if "similar" in self.rx and self.rx["similar"].search(question):
            return ("hybrid_cypher", tpl.get("similar", "class_peers"),
                    "Asks for similarity / warning signs: hybrid (keyword + vector) search finds matching wording, then the peers "
                    "expansion adds records of the same class with their events.")
        if "structured" in self.rx and self.rx["structured"].search(question) and not (
                "causal" in self.rx and self.rx["causal"].search(question)):
            return ("text2cypher", tpl.get("default", "neighbourhood"),
                    "Asks for an exact set, count, distance, trace or ranking: Text2Cypher compiles it into one graph query.")
        if "causal" in self.rx and self.rx["causal"].search(question):
            return ("vector_cypher", tpl.get("causal", "causal_chain"),
                    "Asks about causes or a chain of events: vector search finds the narrative, then the causal-chain expansion "
                    "walks the related records.")
        return ("hybrid_cypher", tpl.get("default", "neighbourhood"),
                "General question: hybrid search over narratives, expanded to each record's direct neighbours.")

    # ------------------------------------------------------------------ answer
    def _answer(self, job: Job, history: list[dict[str, str]]) -> None:
        known = self._known(job.question)
        route = job.step("route")
        route.status = "running"
        t0 = time.perf_counter()
        if job.mode in ("auto", "compare"):
            retriever, template, reason = self.route(job.question, known)
            if job.mode == "compare":
                reason = f"Compare mode: all three retrievers run; the routed one ({RETRIEVER_LABELS[retriever]}) is shown first. {reason}"
        else:
            retriever = job.mode
            template = (known or {}).get("retrieval_template") or self.route(job.question, None)[1]
            reason = f"Retriever chosen manually: {RETRIEVER_LABELS[retriever]}."
        route.detail = {"retriever": retriever, "template": template, "reason": reason, "question_id": known["id"] if known else None}
        route.summary = f"{RETRIEVER_LABELS[retriever]}" + (f" · template {template}" if retriever != "text2cypher" else "")
        route.status, route.seconds = "done", time.perf_counter() - t0

        if not self._preflight_ok:
            preflight(self.llm, self.embedder)
            self._preflight_ok = True
        q = {"id": known["id"] if known else "chat", "question": job.question, "retrieval_template": template,
             "top_k": (known or {}).get("top_k"), "must_contain": (known or {}).get("must_contain", [])}
        msgs = [{"role": m["role"], "content": m["content"]} for m in history[-6:] if m.get("content")]
        order = [retriever] + ([r for r in RETRIEVERS if r != retriever] if job.mode == "compare" else [])
        if not self.has_chunks:
            order = [r for r in order if r == "text2cypher"] or ["text2cypher"]
        runs = [self._run(job, name, q, msgs) for name in order]
        primary = runs[0]
        if job.mode == "auto" and (primary.error or primary.answer == NO_CONTEXT or not primary.context):
            fb = "hybrid_cypher" if retriever == "text2cypher" else "text2cypher"
            if fb == "hybrid_cypher" and not self.has_chunks:
                fb = None
            if fb:
                why = primary.error or "no records were returned"
                route.detail["fallback"] = f"{RETRIEVER_LABELS[retriever]} failed ({why[:200]}); fell back to {RETRIEVER_LABELS[fb]}."
                route.summary += f" → fallback {RETRIEVER_LABELS[fb]}"
                q_fb = dict(q, retrieval_template=template if template != "neighbourhood" else "event_context")
                fb_run = self._run(job, fb, q_fb, msgs)
                runs = [fb_run] + runs
                primary = fb_run
        for r in runs:
            if r.answer == NO_CONTEXT:
                r.answer = "The retriever returned no records, so no answer was generated."
            r.answer = self.guard.clean(r.answer)
        job.retriever = primary.retriever
        job.answer = primary.answer or f"**Error:** {primary.error}"
        job.runs = [{"retriever": r.retriever, "label": RETRIEVER_LABELS[r.retriever], "answer": r.answer, "error": r.error,
                     "cypher": r.cypher, "retrieval_query": r.retrieval_query, "context": r.context, "paths": r.paths,
                     "retrieval_s": r.retrieval_s, "generation_s": r.generation_s, "total_s": r.total_s,
                     "score": r.score if known and known.get("must_contain") else None, "matched": r.matched, "missing": r.missing}
                    for r in runs]
        gen = job.step("generate")
        gen.status, gen.seconds = ("error" if primary.error else "done"), primary.generation_s
        model = f"{self.settings.llm.provider}/{self.settings.llm.model}" if self.settings.llm else "-"
        gen.summary = f"{model} · {primary.generation_s:.1f}s"
        gen.detail = {"model": model, "system_prompt": self.system_prompt, "history_turns": len(msgs), "error": primary.error}
        self._build_graph(job, known, primary)
        self._verify(job, known, primary)

    def _run(self, job: Job, name: str, q: dict[str, Any], msgs: list[dict[str, str]]):
        retrieve, context = job.step("retrieve"), job.step("context")
        retrieve.status, context.status = "running", "running"
        retrieve.summary = f"running {RETRIEVER_LABELS[name]}…"
        gen = job.step("generate")

        def on_event(stage: str, data: dict[str, Any]) -> None:
            if stage != "retrieved":
                return
            runs = retrieve.detail.setdefault("runs", [])
            runs.append({"retriever": name, "label": RETRIEVER_LABELS[name], "seconds": data["seconds"], "cypher": data["cypher"],
                         "items": len(data["items"]), "paths": data["paths"][:30], "retrieval_query": ""})
            retrieve.status, retrieve.seconds = "done", data["seconds"]
            retrieve.summary = f"{RETRIEVER_LABELS[name]} · {len(data['items'])} item(s) · {data['seconds']:.1f}s"
            context.detail.setdefault("runs", []).append({"retriever": name, "items": data["items"]})
            context.status = "done"
            context.summary = f"{len(data['items'])} item(s), {sum(len(i) for i in data['items']):,} characters"
            gen.status, gen.summary = "running", "waiting for the LLM…"

        run = run_one(name, q, self.settings, self.driver, self.db, self.llm, self.embedder, self.fragments, self.schema_text,
                      self.examples, self.template, on_event=on_event, message_history=msgs, response_fallback=NO_CONTEXT)
        runs = retrieve.detail.setdefault("runs", [])
        if runs and runs[-1]["retriever"] == name:
            runs[-1]["retrieval_query"] = run.retrieval_query
        else:
            runs.append({"retriever": name, "label": RETRIEVER_LABELS[name], "seconds": run.retrieval_s, "cypher": run.cypher,
                         "items": 0, "paths": [], "retrieval_query": run.retrieval_query, "error": run.error})
            retrieve.status = "error" if len(runs) == 1 or all(r.get("error") for r in runs) else "done"
            retrieve.summary = f"{RETRIEVER_LABELS[name]} failed: {(run.error or '')[:120]}"
        return run

    # ------------------------------------------------------------------ graph
    def _caption_index(self) -> list[tuple[str, str]]:
        records = self.driver.execute_query(
            "MATCH (n) WHERE n.caption IS NOT NULL AND NOT n:Chunk AND NOT n:Document AND NOT n:OntologyProperty "
            "AND NOT n:PositionPoint AND NOT n:Terminal RETURN elementId(n) AS id, n.caption AS caption", database_=self.db)[0]
        return [(r["id"], r["caption"]) for r in records if r["caption"] and len(r["caption"]) >= 5]

    def graph_from_query(self, query: str, **params: Any) -> VizGraph:
        g = VizGraph(std_prefix=self.std_prefix)
        for rec in self.driver.execute_query(query, params, database_=self.db, routing_=neo4j.RoutingControl.READ)[0]:
            for v in rec.values():
                g.absorb(v)
        return g

    def _evidence_graph(self, texts: list[str]) -> tuple[VizGraph, list[str]]:
        blob = "\n".join(texts)
        hits = [nid for nid, cap in self._captions if cap in blob][:60]
        if not hits:
            return VizGraph(std_prefix=self.std_prefix), []
        g = self.graph_from_query("MATCH (n) WHERE elementId(n) IN $ids OPTIONAL MATCH (n)-[r]-(m) WHERE elementId(m) IN $ids "
                                  "RETURN n, collect(r) AS rels", ids=hits)
        bridge = self.graph_from_query(
            "MATCH (a)-[r1]-(m)-[r2]-(b) WHERE elementId(a) IN $ids AND elementId(b) IN $ids AND a <> b "
            "AND NOT elementId(m) IN $ids AND NOT m:Chunk AND NOT m:Document AND NOT m:OntologyClass AND NOT m:GisLocation "
            "RETURN r1, r2 LIMIT 40", ids=hits)
        g.nodes.update(bridge.nodes)
        g.edges.update(bridge.edges)
        return g, hits

    def _build_graph(self, job: Job, known: dict[str, Any] | None, primary: Any) -> None:
        step = job.step("graph")
        step.status = "running"
        t0 = time.perf_counter()
        g, highlight = self._evidence_graph(primary.context + [primary.answer or ""])
        source = "records found in the retrieved context"
        if known and known.get("subgraph_cypher"):
            curated = self.graph_from_query(known["subgraph_cypher"])
            if curated.nodes:
                g = curated
                source = f"{known['id']} answer subgraph (subgraph_cypher in questions.yaml)"
                step.detail["cypher"] = known["subgraph_cypher"].strip()
        job.graph = self.vis_json(g, set(highlight))
        step.status, step.seconds = "done", time.perf_counter() - t0
        step.summary = f"{len(job.graph['nodes'])} nodes, {len(job.graph['edges'])} relationships · {source}"
        step.detail["source"] = source

    def vis_json(self, g: VizGraph, highlight: set[str]) -> dict[str, Any]:
        gp = self.settings.section("gis").get("point_property", "geo_point")
        nodes, edges = [], []
        for nid, n in g.nodes.items():
            if n["label"] in LEXICAL:
                continue
            props = n["props"]
            point = props.get(gp)
            lat = getattr(point, "y", None) if point is not None else None
            lon = getattr(point, "x", None) if point is not None else None
            clean = {k: (v.isoformat() if hasattr(v, "isoformat") else (None if k == gp else v)) for k, v in props.items()
                     if k not in ("caption",)}
            clean = json.loads(json.dumps(clean, default=str))
            nodes.append({"id": nid, "label": self.styler.caption(n["label"], props), "group": n["label"],
                          "domain": self.styler.domain(n["label"], props), "color": self.styler.color(n["label"], props),
                          "title": self.styler.tooltip(n["label"], clean), "evidence": nid in highlight, "props": clean,
                          "std": {k: props.get(k) for k in ("cim_class", "cim_match", "cim_package", "cim_standard", "mrid")},
                          "std_labels": n.get("std_labels", []), "lat": lat, "lon": lon})
        ids = {n["id"] for n in nodes}
        for eid, e in g.edges.items():
            if e["src"] in ids and e["dst"] in ids:
                edges.append({"id": eid, "from": e["src"], "to": e["dst"], "label": e["type"],
                              "cim": (e.get("props") or {}).get("cim_association")})
        return {"nodes": nodes, "edges": edges}

    # ------------------------------------------------------------------ verify
    def _verify(self, job: Job, known: dict[str, Any] | None, primary: Any) -> None:
        step = job.step("verify")
        step.status = "running"
        t0 = time.perf_counter()
        checks: list[str] = []
        if primary.cypher:
            checks.append("Generated Cypher was checked with EXPLAIN and executed only because it is read-only.")
        if primary.retrieval_query:
            checks.append("Graph expansion ran a fixed, read-only retrieval query generated from the semantic model and config.")
        checks.append("Answer prompt instructs the model to use only the retrieved context and to quote record ids.")
        detail: dict[str, Any] = {"checks": checks}
        if known and known.get("ground_truth_cypher"):
            truth = [r.data() for r in self.driver.execute_query(known["ground_truth_cypher"], database_=self.db,
                                                                routing_=neo4j.RoutingControl.READ)[0]]
            score, matched, missing = score_answer(primary.answer or "", known.get("must_contain", []))
            detail.update({"ground_truth_cypher": known["ground_truth_cypher"].strip(),
                           "ground_truth": json.loads(json.dumps(truth, default=str)),
                           "expected_answer": " ".join(known.get("expected_answer", "").split()),
                           "score": score, "matched": matched, "missing": missing})
            step.summary = (f"{len(matched)}/{len(matched) + len(missing)} expected facts found · ground truth {len(truth)} row(s)"
                            if (matched or missing) else f"ground truth {len(truth)} row(s)")
            job.verification = detail
        else:
            step.summary = "sample question: no ground truth defined" if known else "free-form question: no ground truth; see checks"
        step.detail = detail
        step.status, step.seconds = "done", time.perf_counter() - t0
