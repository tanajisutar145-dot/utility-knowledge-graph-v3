"""Neo4j driver creation and environment checks (version, APOC, target database)."""

from __future__ import annotations

import logging

import neo4j

from ukg.settings import Settings, require

log = logging.getLogger(__name__)

MIN_VERSION = (5, 13)


def _ensure_database(driver: neo4j.Driver, name: str, create: bool) -> None:
    if name in ("neo4j", "system"):
        return
    try:
        records = driver.execute_query("SHOW DATABASES YIELD name RETURN collect(name) AS names", database_="system")[0]
    except neo4j.exceptions.Neo4jError:
        return  # no permission to list databases: let the first query report the problem
    if name in records[0]["names"]:
        return
    if not create:
        raise SystemExit(f"Neo4j database '{name}' does not exist. Create it or set NEO4J_DATABASE=neo4j.")
    try:
        driver.execute_query(f"CREATE DATABASE `{name}` IF NOT EXISTS WAIT", database_="system")
        log.info("Created Neo4j database %s", name)
    except neo4j.exceptions.Neo4jError as exc:
        raise SystemExit(f"Database '{name}' is missing and could not be created ({exc.message}). Community edition "
                         "has a single database: set NEO4J_DATABASE=neo4j.") from exc


def get_driver(settings: Settings) -> neo4j.Driver:
    """Connect, verify connectivity, ensure the database, check Neo4j >= 5.13 with APOC."""
    cfg = require(settings.neo4j, "Neo4j (NEO4J_URI, NEO4J_USER, NEO4J_PASSWORD, NEO4J_DATABASE)")
    driver = neo4j.GraphDatabase.driver(cfg.uri, auth=(cfg.user, cfg.password))
    try:
        driver.verify_connectivity()
    except Exception as exc:  # noqa: BLE001 - surface any connection problem clearly
        raise SystemExit(f"Cannot connect to Neo4j at {cfg.uri}: {exc}") from exc
    _ensure_database(driver, cfg.database, bool(settings.section("neo4j").get("create_database_if_missing", True)))

    records, _, _ = driver.execute_query(
        "CALL dbms.components() YIELD name, versions, edition RETURN name, versions[0] AS version, edition",
        database_=cfg.database,
    )
    version = records[0]["version"]
    parts = tuple(int(p) for p in version.split(".")[:2] if p.isdigit())
    if parts < MIN_VERSION:
        raise SystemExit(f"Neo4j {version} found; {MIN_VERSION[0]}.{MIN_VERSION[1]}+ is required for vector indexes.")
    try:
        apoc = driver.execute_query("RETURN apoc.version() AS v", database_=cfg.database)[0][0]["v"]
    except neo4j.exceptions.ClientError as exc:
        raise SystemExit(
            "APOC is not available. In Neo4j Desktop open the DBMS > Plugins tab, install APOC, then restart."
        ) from exc
    log.info("Connected to Neo4j %s (%s) db=%s, APOC %s", version, records[0]["edition"], cfg.database, apoc)
    return driver


def database(settings: Settings) -> str:
    return require(settings.neo4j, "Neo4j").database


def reset_database(driver: neo4j.Driver, db: str) -> None:
    """Delete every node and relationship (batched). Constraints and indexes are kept."""
    subquery = "CALL (n) { DETACH DELETE n }" if _supports_call_scope(driver, db) else "CALL { WITH n DETACH DELETE n }"
    # CALL ... IN TRANSACTIONS must run in an implicit (auto-commit) transaction.
    with driver.session(database=db) as session:
        session.run(f"MATCH (n) {subquery} IN TRANSACTIONS OF 5000 ROWS").consume()
    log.info("Database %s emptied", db)


def _supports_call_scope(driver: neo4j.Driver, db: str) -> bool:
    version = driver.execute_query("CALL dbms.components() YIELD versions RETURN versions[0] AS v", database_=db)[0][0]["v"]
    major, minor = (int(x) for x in version.split(".")[:2])
    return (major, minor) >= (5, 23)
