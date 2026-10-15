# 01 · Knowledge Graphs at Power Utilities — Research, Challenges and Top 10 Use Cases

This note collects what major power utilities have said publicly about knowledge graphs (KGs) and graph-based network models. It then derives the 10 use cases this application targets and confirms which 5 subject areas of the CMM-aligned canonical data model (`input/data_model`) the synthetic data covers.

> **Scope of the evidence.** Most large investor-owned utilities do not publish their data architecture. The searches found no public knowledge-graph disclosures for Duke Energy, Exelon, Con Edison, Xcel Energy, AEP, Iberdrola (as a group), TenneT, Elia, RTE, Hydro-Québec, Vattenfall or Fingrid. The list below is therefore "the 10 most significant **publicly documented**" utility programmes, not a ranking by revenue. Figures from vendor case studies are vendor-reported and marked as such.

## 1. Who is doing what

| # | Utility (type, region) | What was built | Technology | Problem it solves | Evidence |
|---|---|---|---|---|---|
| 1 | **Enel** (integrated utility / DSO, Italy, Spain, LatAm) | The whole grid rebuilt as a graph digital twin: 600M+ nodes, 800M relationships, ~500k queries per day across 10 country databases | Neo4j | Multi-hop topology queries were slow and error-prone in SQL. Connection quotes relied on overnight batch jobs. Automated quotes rose from 10% to 80% and traversal queries ran about 100x faster (vendor-reported) | [Neo4j customer story](https://neo4j.com/customer-stories/enel/) |
| 2 | **State Grid Corporation of China** (TSO/DSO, China) | Graph-based energy management system (power flow, state estimation) prototyped by GEIRINA in one province. Separately, KG research for equipment O&M, dispatch search and substation digital twins | TigerGraph, graph databases | Relational joins took about 25% of power-flow and 35% of state-estimation compute. Dispatch and equipment data were spread over many systems | [TigerGraph case study](https://www.tigergraph.com/stategrid/), [launch release](https://www.tigergraph.com/wp-content/uploads/2017/09/TigerGraph-Launch_PressRelease.pdf), [dispatch search (SJTU)](https://xuebao.sjtu.edu.cn/EN/abstract/article/1006-2467/43936), [substation twin (VDE)](https://www.vde-verlag.de/proceedings-en/565961155.html) |
| 3 | **China Southern Power Grid** (TSO/DSO, China) | KGs for fault handling, equipment lifecycle data and same-batch ("familial") defect attribution | Domain KGs + NLP | Large volumes of unstructured defect records that existing methods cannot mine. Dispatchers need help during fault disposal | [Frontiers review (CSG co-authors)](https://www.frontiersin.org/journals/energy-research/articles/10.3389/fenrg.2022.988280/full), [defect attribution preprint](https://essopenarchive.org/doi/full/10.22541/au.168511405.53187640/v1), [defect-record KG (FITEE)](https://academic.hep.com.cn/fitee/CN/10.1631/FITEE.1800260) |
| 4 | **ScottishPower Energy Networks** (DNO, UK; Iberdrola group) | Multi-layer distribution KG: asset topology, geospatial context and socio-economic indicators, linked to a domain ontology by a reproducible ETL | Neo4j (development), Amazon Neptune (private cloud) | Data "fragmented across different formats and systems". Covers equity-aware planning, EV-charger access and criticality scored against social vulnerability | [Comillas repository](https://repositorio.comillas.edu/xmlui/handle/11531/99392) |
| 5 | **Statnett** (TSO, Norway) | *Talk2PowerSystem*: natural-language questions over a CIM knowledge graph, answered by LLM-generated SPARQL | GraphDB, IEC CIM, LLMs | Engineers cannot be expected to write graph queries. Answers must be explainable, traceable and consistent with the CIM standards | [GitHub](https://github.com/statnett/Talk2PowerSystem), [Graphwise](https://graphwise.ai/?p=252472) |
| 6 | **Southern California Edison** (IOU, USA) | Network digital twin of the whole ~50,000 sq mi territory, fusing LiDAR and imagery with the network, for wildfire and vegetation risk | Neara platform | Ranking vegetation and ignition risk along circuits. Clearance guidance in under two weeks instead of three to four months (press-reported) | [BusinessWire](https://www.businesswire.com/news/home/20230927480271/en/Neara-Partners-with-Southern-California-Edison-to-Enhance-Wildfire-Risk-Mitigation), [TechCrunch](https://techcrunch.com/2024/02/15/neara-ai/amp), [TIME](https://time.com/6979530/neara) |
| 7 | **Oregon Trail Electric Cooperative** (co-op, USA) | Graph digital twin of substations, feeders, weather and wire sensors | Neo4j (via enxchange) | Wildfire risk and Public Safety Power Shutoffs: shut off one feeder instead of a whole substation | [Neo4j customer story](https://neo4j.com/customer-stories/enxchange/) |
| 8 | **EDF** (integrated utility, France) | Ontology reasoning (HermiT) for energy-saving advice to 265k customers. EDF R&D works on energy ontologies for European data spaces (OMEGA-X). Listed as a GraphDB user | OWL reasoner, RDF | Personalised advice from semantic customer models. Interoperable energy data spaces | [Oxford HermiT case](https://www.cs.ox.ac.uk/innovation/research-impact/case-hermit.html), [MINES Saint-Etienne](https://ci.mines-stetienne.fr/jobs/2023-OMEGA-X-ENERSHARE-Postdoc.html), [Graphwise](https://graphwise.ai/?p=252472) |
| 9 | **Alliander** (DSO, Netherlands) | *Linked Energy Data* programme with TNO: the same asset appears under different IEC-CIM class attributes in SCADA and in fault reporting | Linked data / RDF, CIM | Identity reconciliation and a shared vocabulary across operational systems | [data.overheid.nl presentation](https://data.overheid.nl/sites/default/files/uploaded_files/data.overheid.nl.pdf) |
| 10 | **E.ON** (DSO group, Germany and Europe) | Energy Networks data platforms that "transform data into a digital twin of our grid" (about 20 standard solutions). Not described as a KG, but the canonical foundation a KG sits on | Databricks (E.ON Data House), Confluent streaming | Disjointed data consolidated into reusable data products | [Databricks story](https://www.databricks.com/customers/eon), [Diginomica](https://diginomica.com/eon-streams-real-time-energy-data-power-europes-green-transition-confluent) |

**Related public work that shapes the pattern:**
- [PNNL GridAPPS-D](https://www.energy.gov/sites/default/files/2022-10/DOE%20OSS%20Workshop%2C%20Andy%20Reiman%2C%20Pacific%20Northwest%20National%20Laboratories.pdf) stores CIM distribution feeder models in a Blazegraph triple store because a triple store is [better suited to CIM than SQL tables](https://cimhub.readthedocs.io/en/latest/CDPSM.html). [CIMantic Graphs](https://cimantic-graphs.readthedocs.io/en/latest/01_overview.html) loads the same CIM models into Neo4j or GraphDB.
- Microsoft published a [CIM-derived DTDL energy-grid ontology](https://github.com/azure/opendigitaltwins-energygrid) for outage and impact analysis and predictive maintenance (archived in 2021).
- An unnamed TSO built an [*Electric Grid Assets* knowledge graph](https://graphwise.ai/?p=243370) to unify siloed sensor, IoT and monitoring data (vendor case study).
- A [2022 survey](https://arxiv.org/abs/2211.00901v1) groups smart-grid KG applications into grid operations, consumer services, dispatch decision support, and equipment operation and maintenance.

## 2. Common challenges (why utilities turn to graphs)

| Challenge | What the evidence says | Seen at |
|---|---|---|
| **The network is a graph, the database is not** | Multi-hop traversals (trace, isolate, roll up) become slow and error-prone as joins pile up | Enel, SGCC |
| **Siloed systems disagree about the network** | GIS, OMS, ADMS, EAM, SCADA and DER registries each hold their own version of the network. When those versions conflict, response slows and [operational risk rises](https://utilityanalytics.com/common-information-model-cim-for-utilities/) | Alliander, E.ON, unnamed TSO |
| **Identity resolution** | The same transformer has different identifiers in drawings, maintenance, protection and customer systems | Alliander, [Graphwise TSO](https://graphwise.ai/?p=243370) |
| **Unstructured knowledge** | Inspection findings, defect records and root-cause narratives are free text | CSG, SGCC |
| **Query-skill barrier** | Engineers need answers, not Cypher or SPARQL. Answers must be traceable | Statnett |
| **Spatial plus electrical context** | Wildfire, vegetation and storm decisions need network topology joined with geography and environment | SCE, OTEC, SPEN |
| **Standards compliance** | CIM and CGMES are mandatory exchange formats, but CIM is [hard to query](https://graphwise.ai/?p=252472) and needs extension and harmonisation | Statnett, ENTSO-E members |
| **Scale and real time** | Hundreds of millions of elements and sub-second operational queries | Enel, SGCC |

## 3. What a knowledge graph adds

1. **Connectivity is native.** Feeder → device → transformer → service point is a path, not a chain of joins. Upstream and downstream trace, isolation and roll-up become single queries.
2. **A semantic layer tied to a standard.** Every node carries its IEC CIM class, package and standard, and every property its CIM attribute and unit, so systems that use different names still mean the same thing (`mRID`, `Location`, `Terminal`, `ConnectivityNode`).
3. **Cross-domain joins are relationships.** Asset, network, GIS and outage records connect through explicit, typed edges (`ASSET`, `FEEDER`, `GIS_LOCATION`, `CONDUCTING_EQUIPMENT`).
4. **Structured plus unstructured.** Narrative text (inspection findings, causes, damage reports) is linked to the record it describes and to extracted entities.
5. **Explainable AI.** GraphRAG grounds an LLM answer in retrieved nodes and paths, and the evidence subgraph shows exactly which records were used. This is the Talk2PowerSystem pattern.
6. **Spatial reasoning.** Nodes carry WGS84 points (Neo4j `point`) and WKT geometry, so "within 2 km of", "inside the High Fire Threat District" and "along this corridor" can be combined with topology.

## 4. Top 10 knowledge-graph use cases on the CMM-aligned data model

Each use case lists the CMM tables (subject area `.` table), the IEC CIM classes involved and the graph pattern that makes it hard in SQL. The demo questions shipped with the app (`user_questions/questions.yaml`) are mapped in section 6.

| # | Use case | Who does it publicly | CMM tables | CIM classes | Graph pattern |
|---|---|---|---|---|---|
| UC1 | **Network topology and connectivity tracing** (upstream/downstream, isolation devices, alternate feeds) | Enel, SGCC, OTEC | `distribution.feeder`, `distribution.transformer`, `distribution.sectionalizing_device`, `distribution.distribution_substation`, `gis.terminal`, `gis.connectivity_node`, `gis.network_feature`, `gis.network_association` | Feeder, PowerTransformer, ProtectedSwitch, Terminal, ConnectivityNode | Variable-length traversal Terminal–ConnectivityNode; containment |
| UC2 | **Outage impact and restoration analysis** (affected devices, customers, cause, ETR, restoration steps) | SGCC/CSG (fault handling), OMS practice | `outage.event`, `outage.interruption`, `outage.call`, `outage.cause`, `outage.restoration_action`, `outage.etr_revision`, `distribution.*` | Outage, TroubleTicket, SwitchingAction, EstimatedRestorationTime | Event → device → feeder → downstream equipment; time-ordered actions |
| UC3 | **Asset health, risk and predictive maintenance** (inspection → failure → work order, risk roll-up over hierarchy) | Enel, CSG, unnamed TSO | `asset.registry`, `asset.hierarchy`, `asset.class`, `asset.inspection`, `asset.failure_event`, `asset.work_order`, `asset.maintenance_plan`, `asset.asset_risk_assessment` | Asset, AssetContainer, AssetInfo, InspectionDataSet, FailureEvent, Work | Causal chain + recursive hierarchy + class peers |
| UC4 | **Wildfire and vegetation risk** (lines in High Fire Threat Districts, corridor clearance, ignition-prone equipment) | SCE, OTEC | `transmission.line`, `transmission.right_of_way_corridor`, `gis.geographical_region`, `gis.linear_reference`, `gis.location`, `distribution.feeder` | Line, ACLineSegment, GeographicalRegion, Location | Spatial (region containment, linear referencing) + topology |
| UC5 | **Transmission–distribution interface and contingency impact** (which feeders and customers depend on a transmission substation or transformer) | SGCC, Statnett | `transmission.transmission_substation`, `transmission.power_transformer`, `transmission.line`, `transmission.transmission_outage`, `distribution.distribution_substation`, `distribution.feeder` | Substation, PowerTransformer, Line, Outage | Cross-domain multi-hop fan-out with aggregation |
| UC6 | **Storm and emergency response** (storm → events → damage assessments → crew dispatch) | OTEC (PSPS), SGCC dispatch | `outage.storm_event`, `outage.event`, `outage.damage_assessment`, `outage.outage_crew_dispatch`, `gis.geographical_region` | Incident, Outage, FieldDispatchHistory | Event aggregation over a region and a time window |
| UC7 | **DER hosting capacity and connection quotes** (headroom per feeder and transformer, queue impact) | Enel (80% automated quotes), SPEN | `distribution.der_interconnection_point`, `distribution.feeder`, `distribution.transformer`, `distribution.distribution_substation` | ConnectivityNode, Feeder, PowerTransformer | Nearest feasible connection point by topology and distance |
| UC8 | **Reliability and regulatory reporting** (SAIDI, SAIFI, CAIDI per feeder and territory, IEEE 1366, worst-performing circuits) | All DSOs (regulatory) | `distribution.distribution_reliability_event`, `outage.interruption`, `distribution.feeder`, `distribution.service_territory` | Outage, SubGeographicalRegion | Roll-up of events to feeder and territory |
| UC9 | **GIS–asset data quality and identity reconciliation** (GIS feature without an asset record, mRID mismatches, missing locations) | Alliander, unnamed TSO | `gis.network_feature`, `gis.location`, `gis.location_assignment`, `asset.registry`, any locatable entity | IdentifiedObject.mRID, Location, PowerSystemResource | Anti-joins and polymorphic links across systems |
| UC10 | **Switching and safety-clearance verification** (which clearances isolate which devices, and are the devices really isolating) | TSO and DSO control rooms | `outage.safety_clearance`, `distribution.distribution_switching_order`, `distribution.distribution_switching_step`, `distribution.sectionalizing_device`, `transmission.protection_device` | SwitchingPlan, SwitchingAction, ClearanceDocument, ProtectedSwitch | Order → steps → devices → topology |

**Cross-cutting access layer:** natural-language questions answered by GraphRAG over the KG (Statnett's Talk2PowerSystem pattern). It is implemented in this app with Text2Cypher, vector + graph and hybrid + graph retrievers. Every answer comes with its evidence subgraph and a trace.

## 5. Confirming the top 5 domains

The matrix shows which CMM subject areas each use case needs (● required, ○ helpful).

| Use case | asset | distribution | transmission | gis | outage | customer | metering | workforce | grid |
|---|---|---|---|---|---|---|---|---|---|
| UC1 Topology tracing | ○ | ● | ○ | ● | | ○ | ○ | | |
| UC2 Outage impact | ○ | ● | | ○ | ● | ○ | ○ | ○ | |
| UC3 Asset health | ● | ○ | ○ | ○ | ○ | | | ○ | |
| UC4 Wildfire / vegetation | ○ | ○ | ● | ● | ○ | | | | |
| UC5 T–D interface | | ● | ● | ○ | ○ | | | | ○ |
| UC6 Storm response | ○ | ○ | | ● | ● | | | ○ | |
| UC7 DER hosting | | ● | | ○ | | ○ | ○ | | |
| UC8 Reliability | | ● | | ○ | ● | ○ | | | |
| UC9 GIS–asset DQ | ● | ○ | ○ | ● | | | | | |
| UC10 Switching / clearance | ○ | ● | ○ | | ● | | | ○ | |
| **Required count** | **2** | **5** | **2** | **4** | **3** | 0 | 0 | 0 | 0 |

**Confirmed for this version: `asset`, `distribution`, `transmission`, `gis`, `outage`.** Every one of the 10 use cases is answerable with these five. `customer`, `metering`, `workforce` and `grid` only enrich them; foreign keys into those areas are left NULL in the generated data. They are the natural next domains: adding them is a change to `config.yaml` → `scope`, and data files dropped into `input/data/`.

## 6. How this application demonstrates the use cases

The synthetic dataset (`input/data/`) plants one fully connected scenario per use case in a fictional service territory, with real WGS84 coordinates (see `input/data/README.md`). The demo questions in `user_questions/questions.yaml` exercise them:

| Question | Use case |
|---|---|
| Q1 Downstream trace from a recloser to transformers and DER | UC1 |
| Q2 Outage impact, cause and restoration chain for a feeder outage | UC2 |
| Q3 Inspection → failure → work order chain and risk roll-up | UC3 |
| Q4 Transmission lines and feeders crossing the High Fire Threat District | UC4 |
| Q5 Customers and feeders dependent on a transmission substation | UC5 |
| Q6 Storm damage, crews and events by region | UC6 |
| Q7 Feeders with DER hosting headroom near a location | UC7 |
| Q8 Worst-performing feeders by SAIDI and their events | UC8 |
| Q9 GIS features with no canonical asset record or mismatched mRID | UC9 |
| Q10 Devices isolated by a safety clearance and its switching steps | UC10 |

## Sources

- Enel — https://neo4j.com/customer-stories/enel/
- State Grid / GEIRINA — https://www.tigergraph.com/stategrid/ ; https://www.tigergraph.com/wp-content/uploads/2017/09/TigerGraph-Launch_PressRelease.pdf ; https://xuebao.sjtu.edu.cn/EN/abstract/article/1006-2467/43936 ; https://www.vde-verlag.de/proceedings-en/565961155.html
- China Southern Power Grid — https://www.frontiersin.org/journals/energy-research/articles/10.3389/fenrg.2022.988280/full ; https://essopenarchive.org/doi/full/10.22541/au.168511405.53187640/v1 ; https://academic.hep.com.cn/fitee/CN/10.1631/FITEE.1800260
- ScottishPower Energy Networks — https://repositorio.comillas.edu/xmlui/handle/11531/99392
- Statnett — https://github.com/statnett/Talk2PowerSystem ; https://graphwise.ai/?p=252472
- Southern California Edison — https://www.businesswire.com/news/home/20230927480271/en/Neara-Partners-with-Southern-California-Edison-to-Enhance-Wildfire-Risk-Mitigation ; https://techcrunch.com/2024/02/15/neara-ai/amp ; https://time.com/6979530/neara
- Oregon Trail Electric Cooperative — https://neo4j.com/customer-stories/enxchange/
- EDF — https://www.cs.ox.ac.uk/innovation/research-impact/case-hermit.html ; https://ci.mines-stetienne.fr/jobs/2023-OMEGA-X-ENERSHARE-Postdoc.html
- Alliander — https://data.overheid.nl/sites/default/files/uploaded_files/data.overheid.nl.pdf
- E.ON — https://www.databricks.com/customers/eon ; https://diginomica.com/eon-streams-real-time-energy-data-power-europes-green-transition-confluent
- PNNL GridAPPS-D / CIMHub / CIMantic Graphs — https://www.energy.gov/sites/default/files/2022-10/DOE%20OSS%20Workshop%2C%20Andy%20Reiman%2C%20Pacific%20Northwest%20National%20Laboratories.pdf ; https://cimhub.readthedocs.io/en/latest/CDPSM.html ; https://cimantic-graphs.readthedocs.io/en/latest/01_overview.html
- Microsoft energy-grid ontology — https://github.com/azure/opendigitaltwins-energygrid
- Graphwise unnamed TSO — https://graphwise.ai/?p=243370
- Smart-grid KG survey — https://arxiv.org/abs/2211.00901v1
- CIM and silos — https://utilityanalytics.com/common-information-model-cim-for-utilities/
