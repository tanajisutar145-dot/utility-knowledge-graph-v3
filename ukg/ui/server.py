"""FastAPI server for the web UI (``python -m ukg ui``).

Pages:

* ``GET /``           - chat + detailed answer + evidence graph (CIM overlay, geo layout)
* ``GET /model``      - Model & CIM explorer: classes, CIM alignment, columns -> CIM attributes, relationships
* ``GET /trace``      - "How it was checked" window (follows the latest question)
* ``GET /questions``  - question library window (sends the chosen question to the chat)

API:

* ``GET  /api/model``         - semantic model (works without Neo4j: read from build/semantic_model.json)
* ``GET  /api/info``          - models, database, graph stats, questions (needs Neo4j)
* ``POST /api/ask``           - start answering a question; returns a job id
* ``GET  /api/jobs/{id}``     - job state: trace steps, answer, graph, verification
* ``GET  /api/jobs/latest``   - state of the most recent question
* ``GET  /api/class/{label}`` - a few instances of a class as an evidence-style graph

The QA engine (Neo4j + LLM) starts lazily on the first request that needs it,
so the Model & CIM page is usable before the graph is loaded.
"""

from __future__ import annotations

import logging
import threading
from pathlib import Path
from typing import Any

import pyvis
from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel, Field

from ukg.ontology.extract import SemanticModel
from ukg.settings import Settings

log = logging.getLogger(__name__)

STATIC = Path(__file__).parent / "static"
VIS_LIB = Path(pyvis.__file__).parent / "templates" / "lib" / "vis-9.1.2"


class AskRequest(BaseModel):
    question: str = Field(min_length=1, max_length=2000)
    mode: str = "auto"
    history: list[dict[str, str]] = Field(default_factory=list)


def model_payload(settings: Settings, sem: SemanticModel) -> dict[str, Any]:
    colors = settings.section("viz").get("domain_colors", {})
    return {
        "project": settings.section("project"),
        "standard": sem.standard,
        "namespace": sem.namespace,
        "sources": sem.sources,
        "domains": [{"domain": d, "color": colors.get(d, "#888"), "comment": sem.schemas.get(d, "")}
                    for d in dict.fromkeys(t.schema for t in sem.tables.values())],
        "colors": colors,
        "tables": [{"table": t.table_id, "schema": t.schema, "label": t.label, "class_iri": t.class_iri, "description": t.description,
                    "primary_key": t.primary_key, "standard_class": t.standard_class, "standard_match": t.standard_match,
                    "standard_package": t.standard_package, "standard_standard": t.standard_standard,
                    "standard_ancestors": t.standard_ancestors, "subject_areas": t.subject_areas,
                    "data_classification": t.data_classification, "location_role": t.location_role,
                    "standard_reference": t.standard_reference, "resolution": t.resolution,
                    "columns": [{"column": c.column, "sql_type": c.sql_type, "nullable": c.nullable, "label": c.label,
                                 "description": c.description, "business_term": c.business_term,
                                 "standard_attribute": c.standard_attribute, "standard_match": c.standard_match,
                                 "datatype": c.datatype, "unit": c.unit, "enum_values": c.enum_values,
                                 "sensitivity": c.sensitivity, "resolution": c.resolution} for c in t.columns]}
                   for t in sem.tables.values()],
        "relationships": [{"from": sem.label(r.from_table), "to": sem.label(r.to_table), "type": r.rel_type,
                           "fk": f"{r.from_table}.{r.from_column}", "standard_association": r.standard_association,
                           "cross_domain": r.cross_domain, "resolution": r.resolution} for r in sem.relationships],
        "extra_relationships": [{"type": p["type"], "table": p["table"], "kind": "polymorphic", "cim": p.get("cim_association")}
                                for p in settings.section("graph").get("polymorphic_links", [])]
                               + [{"type": d["name"], "kind": "derived", "cim": d.get("description")}
                                  for d in settings.section("graph").get("derived_relationships", [])],
        "standard_classes": sem.standard_classes,
        "subject_areas": sem.subject_areas,
    }


def create_app(settings: Settings) -> FastAPI:
    sem = SemanticModel.load(settings)
    model = model_payload(settings, sem)
    state: dict[str, Any] = {"engine": None, "error": None}
    lock = threading.Lock()

    def engine():
        if state["engine"] is not None:
            return state["engine"]
        with lock:
            if state["engine"] is None:
                from ukg.ui.engine import QAEngine
                try:
                    state["engine"] = QAEngine(settings, sem)
                    state["error"] = None
                except SystemExit as exc:  # connection / configuration problems
                    state["error"] = str(exc)
                    raise HTTPException(503, f"Knowledge graph not available: {exc}") from exc
        return state["engine"]

    app = FastAPI(title=settings.section("project").get("name", "Knowledge Graph"), docs_url=None, redoc_url=None)
    app.mount("/static", StaticFiles(directory=STATIC), name="static")
    app.mount("/vendor", StaticFiles(directory=VIS_LIB), name="vendor")  # vis-network served locally (offline)

    for route, page in (("/", "index.html"), ("/trace", "trace.html"), ("/questions", "questions.html"), ("/model", "model.html")):
        app.add_api_route(route, (lambda p=page: FileResponse(STATIC / p)), methods=["GET"])

    @app.get("/api/model")
    def api_model() -> dict:
        return model

    @app.get("/api/info")
    def info() -> dict:
        return engine().info()

    @app.post("/api/ask")
    def ask(req: AskRequest) -> dict:
        eng = engine()
        reply = eng.small_talk(req.question)
        if reply is not None:
            return {"reply": reply}
        if len(req.question.strip()) < 4:
            return {"reply": "Could you ask a full question? For example: which feeders cross the High Fire Threat District? "
                             "Or type help to see what I can do."}
        allowed = {"auto", "compare", "text2cypher", "vector_cypher", "hybrid_cypher"}
        if req.mode not in allowed:
            raise HTTPException(400, f"mode must be one of {sorted(allowed)}")
        if req.mode in ("vector_cypher", "hybrid_cypher") and not eng.has_chunks:
            raise HTTPException(400, "No embedded narrative chunks are loaded; run the load step with extraction.mode embed.")
        job = eng.submit(req.question, req.mode, req.history)
        return {"job_id": job.id}

    @app.get("/api/jobs/latest")
    def latest() -> dict:
        eng = engine()
        if eng.latest_id is None:
            raise HTTPException(404, "no question asked yet")
        return eng.jobs[eng.latest_id].to_json()

    @app.get("/api/jobs/{job_id}")
    def job(job_id: str) -> dict:
        j = engine().jobs.get(job_id)
        if j is None:
            raise HTTPException(404, "unknown job")
        return j.to_json()

    @app.get("/api/class/{label}")
    def class_sample(label: str, limit: int = 12) -> dict:
        t = sem.by_label(label)
        if t is None:
            raise HTTPException(404, "unknown class")
        eng = engine()
        g = eng.graph_from_query(f"MATCH (n:`{label}`) WITH n LIMIT $limit OPTIONAL MATCH (n)-[r]-(m) "
                                 "WHERE NOT m:GisLocation AND NOT m:Chunk AND NOT m:Document AND NOT m:OntologyProperty "
                                 "AND NOT m:PositionPoint AND NOT m:Terminal AND type(r) <> 'INSTANCE_OF' "
                                 "RETURN n, collect(r)[..6] AS rels", limit=max(1, min(limit, 40)))
        return eng.vis_json(g, set())

    return app


def serve(settings: Settings, host: str = "127.0.0.1", port: int = 8502) -> None:
    import uvicorn

    app = create_app(settings)
    log.info("Web UI on http://%s:%d  (Ctrl+C to stop)", host, port)
    uvicorn.run(app, host=host, port=port, log_level="warning")
