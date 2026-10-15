"""Configuration loading.

Two sources, deliberately separated:

* ``config.yaml`` - everything that shapes the run: input locations (DDL, TTL,
  data), scope, ontology annotation vocabulary, graph rules, retrievers, UI.
  Safe to commit. Point the app at another model by editing it (or by passing
  ``--config``/setting ``UKG_CONFIG``); no code change is needed.
* ``.env`` - secrets and host settings (Neo4j and LLM/embedding endpoints).
  Never committed; ``.env.example`` documents the keys.

Every relative path in ``config.yaml`` is resolved against the directory that
contains the config file, so a config can live next to its own inputs.
"""

from __future__ import annotations

import os
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

import yaml
from dotenv import load_dotenv

PROJECT_ROOT = Path(__file__).resolve().parent.parent


@dataclass(frozen=True)
class Neo4jSettings:
    uri: str
    user: str
    password: str
    database: str


@dataclass(frozen=True)
class ModelSettings:
    """Provider settings for either the LLM or the embedder."""

    provider: str
    model: str
    base_url: str | None
    api_key: str | None
    dimensions: int | None = None
    api_version: str | None = None


@dataclass
class Settings:
    """Merged view of config.yaml and environment variables."""

    root: Path
    config: dict[str, Any]
    neo4j: Neo4jSettings | None = None
    llm: ModelSettings | None = None
    embedding: ModelSettings | None = None
    extra: dict[str, Any] = field(default_factory=dict)

    # ---- convenience accessors -------------------------------------------------
    def path(self, relative: str) -> Path:
        """Resolve a config-relative path."""
        p = Path(relative)
        return p if p.is_absolute() else (self.root / p).resolve()

    def section(self, name: str) -> dict[str, Any]:
        return self.config.get(name) or {}

    @property
    def build_dir(self) -> Path:
        return self.path(self.section("output").get("build_dir", "build"))

    @property
    def output_dir(self) -> Path:
        return self.path(self.section("output").get("dir", "output"))

    @property
    def scope(self) -> dict[str, list[str] | str]:
        return self.section("scope").get("domains", {})


def _env(name: str, default: str | None = None) -> str | None:
    value = os.getenv(name, default)
    return value if value not in ("", None) else default


def _model_settings(prefix: str) -> ModelSettings | None:
    provider = _env(f"{prefix}_PROVIDER")
    model = _env(f"{prefix}_MODEL")
    if not provider or not model:
        return None
    dims = _env(f"{prefix}_DIMENSIONS")
    return ModelSettings(
        provider=provider.strip().lower(),
        model=model,
        base_url=_env(f"{prefix}_BASE_URL"),
        api_key=_env(f"{prefix}_API_KEY"),
        dimensions=int(dims) if dims else None,
        api_version=_env(f"{prefix}_API_VERSION"),
    )


def load_settings(config_path: Path | None = None) -> Settings:
    """Load ``config.yaml`` (``--config`` > ``UKG_CONFIG`` > project root) and ``.env``."""
    env_cfg = os.getenv("UKG_CONFIG")
    config_path = Path(config_path or env_cfg or PROJECT_ROOT / "config.yaml").resolve()
    if not config_path.exists():
        raise SystemExit(f"Config file not found: {config_path}")
    with config_path.open(encoding="utf-8") as fh:
        config = yaml.safe_load(fh) or {}

    # .env next to the config wins; the project-root .env is the fallback.
    for env_file in (config_path.parent / ".env", PROJECT_ROOT / ".env"):
        if env_file.exists():
            load_dotenv(env_file, override=False)

    neo4j = None
    if _env("NEO4J_URI"):
        neo4j = Neo4jSettings(
            uri=_env("NEO4J_URI", "neo4j://localhost:7687") or "",
            user=_env("NEO4J_USER", "neo4j") or "neo4j",
            password=_env("NEO4J_PASSWORD", "") or "",
            database=_env("NEO4J_DATABASE", "neo4j") or "neo4j",
        )

    return Settings(
        root=config_path.parent,
        config=config,
        neo4j=neo4j,
        llm=_model_settings("LLM"),
        embedding=_model_settings("EMBEDDING"),
    )


def require_model(settings: Settings, prefix: str) -> ModelSettings:
    """Return LLM/EMBEDDING settings or exit naming exactly which .env keys are empty."""
    cfg = settings.llm if prefix == "LLM" else settings.embedding
    missing = [k for k in (f"{prefix}_PROVIDER", f"{prefix}_MODEL") if not _env(k)]
    if cfg is not None and cfg.provider in ("openai", "azure_openai", "anthropic") and not cfg.api_key:
        missing.append(f"{prefix}_API_KEY")
    if cfg is None or missing:
        raise SystemExit(f"{prefix} settings incomplete in .env: set {', '.join(missing)}.")
    return cfg


def missing_model_keys(settings: Settings, prefixes: tuple[str, ...] = ("LLM", "EMBEDDING")) -> list[str]:
    """Names of the LLM/EMBEDDING keys that still need a value (empty list = ready)."""
    missing = []
    for prefix in prefixes:
        try:
            require_model(settings, prefix)
        except SystemExit as exc:
            missing.append(str(exc).split(": set ")[-1].rstrip("."))
    return missing


def require(value: Any, what: str) -> Any:
    """Fail with an actionable message when a required .env block is missing."""
    if value is None:
        raise SystemExit(f"Missing {what} settings. Copy .env.example to .env and fill in the {what} block.")
    return value
