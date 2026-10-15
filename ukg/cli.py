"""Command line: ``python -m ukg run --step all|model|load|rag|viz`` and ``python -m ukg ui``."""

from __future__ import annotations

import argparse
from pathlib import Path

from ukg.log import setup_logging
from ukg.settings import load_settings
from ukg.steps import run


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(prog="python -m ukg", description="Utility knowledge graph v3 (CIM-aligned)")
    sub = parser.add_subparsers(dest="command", required=True)
    r = sub.add_parser("run", help="run one step or the whole pipeline")
    r.add_argument("--step", choices=["all", "model", "load", "rag", "viz"], default="all",
                   help="model = parse DDL/TTL/data, validate, extract ontology + schema (offline); load = Neo4j; "
                        "rag = answer the questions; viz = HTML renderings")
    r.add_argument("--config", type=Path, default=None, help="path to config.yaml (default: $UKG_CONFIG or project root)")
    r.add_argument("--reset", action="store_true", help="empty the Neo4j database before loading")
    r.add_argument("--skip-text", action="store_true", help="structured load only (no embeddings, no LLM)")
    r.add_argument("--question", help="only this question id for rag/viz (e.g. Q2)")
    r.add_argument("-v", "--verbose", action="store_true", help="debug logging (includes library prompts)")

    u = sub.add_parser("ui", help="start the web UI (chat + answer, evidence graph, CIM model and trace)")
    u.add_argument("--config", type=Path, default=None)
    u.add_argument("--host", default=None, help="bind address (default: ui.host, localhost)")
    u.add_argument("--port", type=int, default=None, help="port (default: ui.port)")
    u.add_argument("-v", "--verbose", action="store_true")
    args = parser.parse_args(argv)

    setup_logging(args.verbose)
    settings = load_settings(args.config)
    if args.command == "ui":
        from ukg.ui.server import serve

        ui = settings.section("ui")
        serve(settings, host=args.host or ui.get("host", "127.0.0.1"), port=args.port or int(ui.get("port", 8502)))
        return 0
    run(settings, args.step, reset=args.reset, skip_text=args.skip_text, question=args.question)
    return 0
