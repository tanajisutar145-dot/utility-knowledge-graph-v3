"""Vector, full-text and point indexes used by the retrievers (all idempotent)."""

from __future__ import annotations

import logging

import neo4j
from neo4j_graphrag.indexes import create_fulltext_index, create_vector_index, drop_index_if_exists

from ukg.model.data import Rows
from ukg.ontology.extract import SemanticModel
from ukg.settings import Settings

log = logging.getLogger(__name__)


def _existing_vector_dims(driver: neo4j.Driver, name: str, db: str) -> int | None:
    records, _, _ = driver.execute_query(
        "SHOW INDEXES YIELD name, type, options WHERE name = $name AND type = 'VECTOR' RETURN options", name=name, database_=db)
    if not records:
        return None
    return int(records[0]["options"]["indexConfig"]["vector.dimensions"])


def create_text_indexes(settings: Settings, driver: neo4j.Driver, db: str, sem: SemanticModel, narrative: dict[str, list[str]],
                        dimensions: int) -> None:
    cfg = settings.section("indexes")
    vec = cfg["vector"]
    current = _existing_vector_dims(driver, vec["name"], db)
    if current is not None and current != dimensions:
        log.warning("Vector index %s has %d dims but the embedder produces %d: recreating", vec["name"], current, dimensions)
        drop_index_if_exists(driver, vec["name"], neo4j_database=db)
    create_vector_index(driver, vec["name"], label=vec["label"], embedding_property=vec["property"], dimensions=dimensions,
                        similarity_fn=vec.get("similarity", "cosine"), neo4j_database=db)
    ft = cfg["fulltext"]
    create_fulltext_index(driver, ft["name"], label=ft["label"], node_properties=ft["properties"], neo4j_database=db)
    labels = [sem.label(t) for t in narrative]
    props = sorted({c for cols in narrative.values() for c in cols})
    name = cfg.get("narrative_fulltext", {}).get("name", "row_narratives")
    if labels and props:
        driver.execute_query(f"CREATE FULLTEXT INDEX {name} IF NOT EXISTS FOR (n:{'|'.join(labels)}) "
                             f"ON EACH [{', '.join('n.' + p for p in props)}]", database_=db)
    driver.execute_query("CALL db.awaitIndexes(300)", database_=db)
    log.info("Indexes ready: vector %s (%d dims), full-text %s, full-text %s over %d labels", vec["name"], dimensions,
             ft["name"], name, len(labels))


def create_point_indexes(settings: Settings, driver: neo4j.Driver, db: str, located: dict[str, int]) -> None:
    if not settings.section("indexes").get("point", True):
        return
    prop = settings.section("gis").get("point_property", "geo_point")
    for label in located:
        driver.execute_query(f"CREATE POINT INDEX {label.lower()}_{prop}_point IF NOT EXISTS FOR (n:`{label}`) ON (n.`{prop}`)",
                             database_=db)
    log.info("Point indexes on %s for %d labels", prop, len(located))


def create_lookup_indexes(driver: neo4j.Driver, db: str, rows: Rows, sem: SemanticModel) -> None:
    """Range indexes on caption / derived-rule lookup properties (fast evidence matching)."""
    for t in sem.tables.values():
        driver.execute_query(f"CREATE INDEX {t.label.lower()}_caption IF NOT EXISTS FOR (n:`{t.label}`) ON (n.caption)", database_=db)
