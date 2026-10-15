# Input data - Riverbend Electric (fictional) sample

One-time synthetic dataset for the CMM-aligned canonical data model in `../data_model`. It was generated **once, outside
the application** (the application only reads it) and covers the five subject areas confirmed in
`docs/01_Utility_KG_Research_and_Use_Cases.md`: **asset, distribution, transmission, gis, outage**.

| | |
|---|---|
| Layout | `<schema>/<table>.csv` (matches `input.data.path_template` in `config.yaml`) |
| Columns | every DDL column, in DDL order; empty cell = NULL; booleans `true`/`false`; timestamps ISO-8601 (local, no zone) |
| Tables / rows | 46 tables, 3,405 rows (see `manifest.json`) |
| Integrity | every in-scope FK resolves (0 orphans); PKs unique; NOT NULL respected; mRIDs are deterministic UUIDv5 |
| Envelope | CMM silver envelope filled (`mrid`, `cmm_src_system_code`, `cmm_row_hash`, `cmm_dq_status`, ...) |
| Geometry | WGS84 (EPSG:4326). `gis.location` holds WKT + GeoJSON + bbox + length/area; `gis.position_point` holds the ordered vertices. H3 cells are left NULL |
| Out-of-scope FKs | references to other subject areas (customer, workforce, finance, ...) are NULL |

The utility is fictional; the coordinates are real places in the Sierra Nevada foothills so maps make sense.

## Network

- **Transmission:** Granite Peak 230 kV (GPK), Lakeview 230 kV (LKV), Oak Hollow 115 kV (OKH); four lines
  (GPK-LKV-230-1, LKV-OKH-115-1, GPK-OKH-115-1, LKV-OKH-115-2) with right-of-way corridors; six power transformers;
  eight protective relays.
- **Distribution:** six substations (Pine Ridge, Cedar Flat ← GPK; Harbor Road, Mill Creek ← LKV; Willow Bend,
  Quarry Hill ← OKH), twelve 12.47 kV feeders. Each feeder: breaker CB → section S01 → recloser R1 → section S02 →
  in-line disconnect D1 → section S03; lateral fuse F1 → lateral S04; six transformers; capacitor bank; DER points;
  a normally-open tie switch between the two feeders of each substation.
- **CIM topology:** every piece of conducting equipment has `gis.terminal` rows (sequence 1 = source side,
  2 = load side) on `gis.connectivity_node`s. The application derives `FEEDS` from them.
- **GIS:** service territories, HFTD Tier 3 (`HFTD-T3-GR`) and Tier 2 (`HFTD-T2-FW`) polygons, counties, storm zones,
  Esri Utility Network features (`gis.network_feature`) with containment/connectivity associations, linear references
  of findings along transmission lines.

## Planted storylines (one per use case)

| Use case | Storyline |
|---|---|
| UC1 topology | Recloser PRD1201-R1 feeds S02, D1, S03, F1, S04, five transformers (141 customers), two DER points, capacitor C1 and tie switch PRD1201-TIE |
| UC2 outage | OE-2025-0115 (Winter Storm Kestrel, 15 Jan 2025): oak limb on S02, R1 lockout, D1 opened, tie closed (48 restored), repair, R1 closed (93 restored); 4 ETR revisions, 8 calls, 3 crews, 2 damage assessments |
| UC3 asset health | INS-2024-DT-0412 (hotspot, oil leak on CFL2101-T04) → FE-2025-0012 → OE-2025-0311 → WO-2025030211 tree (USD 27,000); class peers PRD1201-T03, MLC4102-T05, QHL6101-T02; GPK-T2 DGA acetylene trend (critical risk) |
| UC4 wildfire | Lines GPK-LKV-230-1 and GPK-OKH-115-1 cross HFTD Tier 3; feeders PRD1201/PRD1202 inside it; vegetation findings INS-2024-VG-1210, INS-2025-VG-0118/0121; vegetation outages OE-2025-0115, OE-2025-0120, TO-2025-0003; PSPS OE-2025-0702 |
| UC5 T–D | GPK supplies Pine Ridge and Cedar Flat (four feeders, 546 customers) |
| UC6 storm | Kestrel (6 events, Foothill) and Atmospheric River Juniper (4 events, Valley/Riverside) |
| UC7 DER | Hosting capacity vs installed DER per feeder; WLB5101/WLB5102 within 8 km of (38.62, -120.99) with ≥ 2 MW headroom |
| UC8 reliability | 19 events over Oct 2024 – Sep 2025, sustained/momentary/planned, major-event-day flags for Kestrel |
| UC9 GIS DQ | 3 GIS features without a canonical record, 2 mRID mismatches, 2 transformers without location, 2 without registry record, 1 with coordinates 1.2 km off |
| UC10 clearance | SC-2025-0042 / DSW-2501150 isolates S02 with R1 and D1 tagged, but lateral fuse F1 (battery POI-PRD1201-02 beyond it) is never operated |
