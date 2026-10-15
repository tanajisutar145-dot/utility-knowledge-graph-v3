"""Logging setup shared by every step."""

from __future__ import annotations

import logging
import sys


def setup_logging(verbose: bool = False) -> None:
    """Configure root logging once; quiet the chattier third-party loggers."""
    level = logging.DEBUG if verbose else logging.INFO
    logging.basicConfig(
        level=level,
        format="%(asctime)s %(levelname)-7s %(name)s | %(message)s",
        datefmt="%H:%M:%S",
        stream=sys.stdout,
        force=True,
    )
    for noisy in ("neo4j", "httpx", "httpx2", "httpcore", "openai", "anthropic", "urllib3"):
        logging.getLogger(noisy).setLevel(logging.WARNING)
    # Server notifications (deprecated syntax inside library queries, not-yet-created labels) are
    # informational for this POC; show them only with --verbose.
    logging.getLogger("neo4j.notifications").setLevel(logging.DEBUG if verbose else logging.ERROR)
    if not verbose:
        logging.getLogger("neo4j_graphrag").setLevel(logging.WARNING)
