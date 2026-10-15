"""Pipeline steps. Each step can run on its own and is idempotent.

    model  parse DDL + data + ontology -> validation report, semantic model, ontology subset, graph schema (offline)
    load   Neo4j: constraints, structured load, GIS points, spatial + derived relationships, semantic (CIM) layer,
           narrative documents/chunks (+ optional LLM extraction), indexes
    rag    answer the demo questions with every retriever; write output/report.md
    viz    interactive HTML renderings (overview, CIM alignment, geo view, schema, per-question subgraphs)
"""

from __future__ import annotations

import json
import logging
import time
from typing import Any

from ukg.model.data import read_all, resolve_scope
from ukg.model.ddl import DataModel, load_data_model
from ukg.sanitize import BrandGuard
from ukg.settings import Settings, missing_model_keys

log = logging.getLogger(__name__)


def scoped_model(settings: Settings) -> DataModel:
    inp = settings.section("input")
    full = load_data_model(inp.get("ddl", []), settings.root, inp.get("ddl_default_schema", "default"))
    model = full.scoped(resolve_scope(settings, full))
    log.info("Scope: %d tables in %d subject areas, %d foreign keys (%d cross-domain)", len(model.tables),
             len({t.schema for t in model.tables.values()}), len(model.foreign_keys),
             sum(fk.is_cross_domain for fk in model.foreign_keys))
    return model


def _write_json(settings: Settings, name: str, data: Any) -> None:
    out = settings.output_dir
    out.mkdir(parents=True, exist_ok=True)
    (out / name).write_text(json.dumps(data, indent=2, default=str), encoding="utf-8")


def step_model(settings: Settings) -> dict[str, Any]:
    from ukg.model.validate import validate
    from ukg.ontology.extract import build_semantic_model
    from ukg.ontology.schema import build_extraction_schema, build_structured_schema

    model = scoped_model(settings)
    rows = read_all(settings, model)
    summary = validate(settings, model, rows)
    _write_json(settings, "data_validation.json", summary)
    sem = build_semantic_model(settings, model)
    build_structured_schema(settings, sem)
    if settings.section("extraction").get("mode") == "extract":
        ext = build_extraction_schema(settings)
        log.info("Extraction schema: %s", ", ".join(nt.label for nt in ext.node_types))
    guard = BrandGuard.from_config(settings.config)
    if settings.section("sanitize").get("enabled"):
        hits = guard.scan_paths([settings.build_dir])
        if hits:
            log.warning("Brand guard: vendor/product names in derived files: %s", hits)
    return summary


def step_load(settings: Settings, reset: bool = False, skip_text: bool = False) -> dict[str, Any]:
    from ukg.kg.gis import assign_points, spatial_relationships
    from ukg.kg.indexes import create_lookup_indexes, create_point_indexes, create_text_indexes
    from ukg.kg.neo4j_client import database, get_driver, reset_database
    from ukg.kg.semantic import load_semantic_layer, run_derived
    from ukg.kg.structured import load_structured
    from ukg.kg.unstructured import load_unstructured, narrative_columns
    from ukg.ontology.extract import SemanticModel
    from ukg.ontology.schema import build_extraction_schema, load_structured_schema
    from ukg.rag.providers import create_embedder, create_llm, embedding_dimensions, preflight

    model = scoped_model(settings)
    rows = read_all(settings, model)
    sem = SemanticModel.load(settings)
    missing_tables = set(model.tables) - set(sem.tables)
    if missing_tables:
        raise SystemExit(f"Semantic model is out of date (missing {sorted(missing_tables)}); run --step model first.")
    schema = load_structured_schema(settings)
    driver = get_driver(settings)
    db = database(settings)
    result: dict[str, Any] = {}
    try:
        if reset:
            reset_database(driver, db)
        log.info("--- load: structured graph (deterministic)")
        result["structured"] = load_structured(settings, driver, db, schema, sem, rows)
        create_lookup_indexes(driver, db, rows, sem)
        if settings.section("gis").get("enabled", True):
            log.info("--- load: GIS points and spatial relationships")
            result["points"] = assign_points(settings, driver, db, sem)
            result["spatial"] = spatial_relationships(settings, driver, db, sem, rows)
            create_point_indexes(settings, driver, db, result["points"])
        log.info("--- load: derived relationships")
        result["derived"] = run_derived(settings, driver, db)
        log.info("--- load: semantic (ontology / %s) layer", sem.standard.get("short"))
        result["semantic"] = load_semantic_layer(settings, driver, db, sem)

        mode = settings.section("extraction").get("mode", "embed")
        want_text = mode != "off" and not skip_text
        need = ("EMBEDDING", "LLM") if mode == "extract" else ("EMBEDDING",)
        missing = missing_model_keys(settings, need) if want_text else []
        if missing:
            log.warning("Skipping narrative documents and vector indexes - empty in .env: %s", "; ".join(missing))
            want_text = False
        if want_text:
            log.info("--- load: narrative documents (%s)", mode)
            embedder = create_embedder(settings)
            llm = create_llm(settings, for_extraction=True) if mode == "extract" else None
            preflight(llm, embedder)
            ext = build_extraction_schema(settings) if mode == "extract" else None
            result["unstructured"] = load_unstructured(settings, driver, db, sem, rows, embedder, llm, ext)
            create_text_indexes(settings, driver, db, sem, narrative_columns(settings, sem, rows),
                                embedding_dimensions(settings, embedder))
        nodes = driver.execute_query("MATCH (n) RETURN count(n) AS c", database_=db)[0][0]["c"]
        rels = driver.execute_query("MATCH ()-[r]->() RETURN count(r) AS c", database_=db)[0][0]["c"]
        log.info("Graph now holds %d nodes and %d relationships", nodes, rels)
        result["graph"] = {"nodes": nodes, "relationships": rels}
        _write_json(settings, "load_summary.json", result)
    finally:
        driver.close()
    return result


def step_rag(settings: Settings, question: str | None = None) -> None:
    from ukg.rag.runner import run_questions

    missing = missing_model_keys(settings)
    if missing:
        raise SystemExit(f"Step rag needs an LLM and an embedder - empty in .env: {'; '.join(missing)}")
    run_questions(settings, only=question)


def step_viz(settings: Settings, question: str | None = None) -> None:
    from ukg.viz.render import render_all

    for p in render_all(settings, only=question):
        log.info("  %s", p)


def run(settings: Settings, step: str, reset: bool = False, skip_text: bool = False, question: str | None = None) -> None:
    order = ["model", "load", "rag", "viz"] if step == "all" else [step]
    for s in order:
        t0 = time.perf_counter()
        log.info("===== step: %s =====", s)
        if s == "model":
            step_model(settings)
        elif s == "load":
            step_load(settings, reset=reset, skip_text=skip_text)
        elif s == "rag":
            step_rag(settings, question)
        elif s == "viz":
            step_viz(settings, question)
        log.info("===== step %s finished in %.1fs =====", s, time.perf_counter() - t0)
