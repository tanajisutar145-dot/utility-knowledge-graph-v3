"""Pluggable LLM and embedder construction from ``.env``.

LLM_PROVIDER / EMBEDDING_PROVIDER values:

==================  =====================================================
``openai``          OpenAI API (``*_BASE_URL`` optional)
``openai_compatible`` any OpenAI-compatible server via ``*_BASE_URL``
                    (vLLM, LM Studio, LiteLLM proxy, Ollama's /v1 ...)
``azure_openai``    Azure OpenAI (``*_BASE_URL`` = resource endpoint,
                    ``*_MODEL`` = deployment name, ``*_API_VERSION`` optional)
``anthropic``       LLM only - there is no embeddings API, so pair it with a
                    different EMBEDDING_PROVIDER
``ollama``          local Ollama (``*_BASE_URL`` default http://localhost:11434)
==================  =====================================================
"""

from __future__ import annotations

import logging
from typing import Any

from neo4j_graphrag.embeddings import AzureOpenAIEmbeddings, Embedder, OllamaEmbeddings, OpenAIEmbeddings
from neo4j_graphrag.llm import AnthropicLLM, AzureOpenAILLM, LLMInterface, OllamaLLM, OpenAILLM

from ukg.settings import ModelSettings, Settings, require, require_model

log = logging.getLogger(__name__)

DEFAULT_AZURE_API_VERSION = "2024-10-21"


def create_llm(settings: Settings, for_extraction: bool = False) -> LLMInterface:
    """Build the configured LLM.

    With ``for_extraction`` the model must return JSON: providers with native
    structured output (OpenAI, Anthropic) use it automatically inside
    neo4j-graphrag; the others are switched to JSON mode. Set
    ``extraction.structured_output: off`` for OpenAI-compatible servers that do
    not implement JSON-schema responses.
    """
    cfg: ModelSettings = require_model(settings, "LLM")
    params: dict[str, Any] = dict(settings.config.get("rag", {}).get("llm_params", {}))
    structured = str(settings.config.get("extraction", {}).get("structured_output", "auto")).lower() != "off"
    p = cfg.provider
    llm: LLMInterface
    if p in ("openai", "openai_compatible"):
        if for_extraction and not structured:
            params["response_format"] = {"type": "json_object"}
        llm = OpenAILLM(model_name=cfg.model, model_params=params, base_url=cfg.base_url,
                        api_key=cfg.api_key or "not-needed")
    elif p == "azure_openai":
        if for_extraction:
            params["response_format"] = {"type": "json_object"}
        llm = AzureOpenAILLM(
            model_name=cfg.model,
            model_params=params,
            azure_endpoint=require(cfg.base_url, "LLM_BASE_URL (Azure endpoint)"),
            api_key=cfg.api_key,
            api_version=cfg.api_version or DEFAULT_AZURE_API_VERSION,
        )
    elif p == "anthropic":
        params.setdefault("max_tokens", 4096)
        llm = AnthropicLLM(model_name=cfg.model, model_params=params, base_url=cfg.base_url, api_key=cfg.api_key)
    elif p == "ollama":
        ollama_params: dict[str, Any] = {"options": {"temperature": params.get("temperature", 0)}}
        if for_extraction:
            ollama_params["format"] = "json"
        llm = OllamaLLM(model_name=cfg.model, model_params=ollama_params, host=cfg.base_url or "http://localhost:11434")
    else:
        raise SystemExit(f"Unsupported LLM_PROVIDER '{p}'. Use openai, openai_compatible, azure_openai, anthropic or ollama.")
    if for_extraction and not structured:
        llm.supports_structured_output = False  # instance override: use JSON prompting instead
    return llm


class _DimensionedOpenAIEmbeddings(OpenAIEmbeddings):
    """OpenAI embeddings that always request a fixed output size.

    Pipeline components call ``embed_query(text)`` without extra arguments, so
    the ``dimensions`` request parameter is bound here once.
    """

    def __init__(self, dimensions: int, **kwargs: Any):
        super().__init__(**kwargs)
        self._dimensions = dimensions

    def embed_query(self, text: str, **kwargs: Any) -> list[float]:
        return super().embed_query(text, dimensions=self._dimensions, **kwargs)


def create_embedder(settings: Settings) -> Embedder:
    """Build the configured embedder (independent of the LLM provider)."""
    cfg: ModelSettings = require_model(settings, "EMBEDDING")
    p = cfg.provider
    if p in ("openai", "openai_compatible"):
        kwargs: dict[str, Any] = {"model": cfg.model, "api_key": cfg.api_key or "not-needed"}
        if cfg.base_url:
            kwargs["base_url"] = cfg.base_url
        # Only text-embedding-3* style models accept a `dimensions` request parameter.
        if cfg.dimensions and p == "openai" and cfg.model.startswith("text-embedding-3"):
            return _DimensionedOpenAIEmbeddings(dimensions=cfg.dimensions, **kwargs)
        return OpenAIEmbeddings(**kwargs)
    if p == "azure_openai":
        return AzureOpenAIEmbeddings(
            model=cfg.model,
            azure_endpoint=require(cfg.base_url, "EMBEDDING_BASE_URL (Azure endpoint)"),
            api_key=cfg.api_key,
            api_version=cfg.api_version or DEFAULT_AZURE_API_VERSION,
        )
    if p == "ollama":
        return OllamaEmbeddings(model=cfg.model, host=cfg.base_url or "http://localhost:11434")
    if p == "anthropic":
        raise SystemExit("Anthropic has no embeddings API: set EMBEDDING_PROVIDER to openai, azure_openai, ollama "
                         "or openai_compatible.")
    raise SystemExit(f"Unsupported EMBEDDING_PROVIDER '{p}'.")


_FATAL_HINTS = {
    "insufficient_quota": "the account has no API credit left - add credit in the provider's billing settings",
    "credit_balance": "the account has no API credit left - add credit in the provider's billing settings",
    "invalid_api_key": "the API key is invalid",
    "authentication": "the API key was rejected",
    "model_not_found": "the model name is wrong or your key has no access to it",
    "not_found_error": "the model name is wrong or your key has no access to it",
}


def preflight(llm: LLMInterface | None, embedder: Embedder | None) -> None:
    """One tiny LLM call and one embedding before any batch work.

    Billing and auth errors come back as HTTP 429/401, which neo4j-graphrag's
    rate-limit handler would otherwise retry for every document.
    """
    checks = []
    if embedder is not None:
        checks.append(("Embedding", lambda: embedder.embed_query("ping")))
    if llm is not None:
        checks.append(("LLM", lambda: llm.invoke("Reply with the single word OK.")))
    for what, call in checks:
        try:
            call()
        except Exception as exc:  # noqa: BLE001 - translate provider errors into one clear message
            # Unwrap the retry wrapper and exception chain to reach the provider's own message.
            parts, cur = [], exc
            while cur is not None and len(parts) < 6:
                last = getattr(getattr(cur, "last_attempt", None), "exception", None)
                inner = last() if callable(last) else None
                parts.append(str(cur))
                cur = inner or cur.__cause__ or cur.__context__
            text = " | ".join(parts)
            hint = next((h for k, h in _FATAL_HINTS.items() if k in text.lower()), None)
            raise SystemExit(f"{what} pre-flight call failed: {hint or text[:300]}") from exc
    log.info("Pre-flight calls succeeded: %s", ", ".join(w for w, _ in checks))


def embedding_dimensions(settings: Settings, embedder: Embedder) -> int:
    """Dimensions from .env, or probe the embedder once when not configured."""
    cfg = require(settings.embedding, "embedding")
    if cfg.dimensions:
        return cfg.dimensions
    dims = len(embedder.embed_query("dimension probe"))
    log.info("EMBEDDING_DIMENSIONS not set; probed %d from the model", dims)
    return dims
