"""Idempotent KG writer built on neo4j-graphrag's ``Neo4jWriter``.

``Neo4jWriter`` (v1.21) CREATEs every node, which duplicates data on re-runs
(or fails once uniqueness constraints exist). ``MergingNeo4jWriter`` keeps the
library's batching, relationship upsert (``apoc.merge.relationship``) and
temporary-id handling, and only swaps node creation for a MERGE on the node's
primary key. It also adds per-label extra labels (the ``CIM_<class>`` labels of
the standard alignment). Labels without a configured key fall back to the
parent behaviour.
"""

from __future__ import annotations

from typing import Any

import neo4j
from neo4j_graphrag.components.kg_writer import Neo4jWriter
from neo4j_graphrag.components.types import LexicalGraphConfig, Neo4jNode

_MERGE_NODES = """
UNWIND $rows AS row
CALL apoc.merge.node([row.label], row.key, {}, {}) YIELD node
WITH node AS n, row
SET n = row.properties
SET n.__tmp_internal_id = row.id
WITH n, row
CALL apoc.create.addLabels(n, row.labels + ['__KGBuilder__']) YIELD node
RETURN count(node) AS written
"""


class MergingNeo4jWriter(Neo4jWriter):
    """``Neo4jWriter`` that MERGEs nodes on ``merge_keys[label]`` instead of CREATE.

    Args:
        driver: Neo4j driver.
        merge_keys: node label -> primary-key property used as MERGE identity.
        extra_labels: node label -> additional labels (e.g. ``["CIM_Feeder", "CIM_EquipmentContainer"]``).
        neo4j_database: target database.
        batch_size: rows per write transaction.
    """

    def __init__(
        self,
        driver: neo4j.Driver,
        merge_keys: dict[str, str],
        extra_labels: dict[str, list[str]] | None = None,
        neo4j_database: str | None = None,
        batch_size: int = 1000,
        clean_db: bool = True,
    ):
        super().__init__(driver=driver, neo4j_database=neo4j_database, batch_size=batch_size, clean_db=clean_db)
        self.merge_keys = merge_keys
        self.extra_labels = extra_labels or {}

    def _upsert_nodes(self, nodes: list[Neo4jNode], lexical_graph_config: LexicalGraphConfig) -> None:
        keyed = [n for n in nodes if n.label in self.merge_keys]
        other = [n for n in nodes if n.label not in self.merge_keys]
        if other:
            super()._upsert_nodes(other, lexical_graph_config)
        if not keyed:
            return
        rows: list[dict[str, Any]] = self._nodes_to_rows(keyed, lexical_graph_config)
        for row in rows:
            key = self.merge_keys[row["label"]]
            if key not in row["properties"]:
                raise ValueError(f"Node {row['id']} has no merge key '{key}'")
            row["key"] = {key: row["properties"][key]}
            row["labels"] = row["labels"] + self.extra_labels.get(row["label"], [])
        self.driver.execute_query(_MERGE_NODES, parameters_={"rows": rows}, database_=self.neo4j_database)
