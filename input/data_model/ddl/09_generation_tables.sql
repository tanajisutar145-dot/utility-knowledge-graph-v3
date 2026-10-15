-- Utility CMM-aligned Canonical Data Model (Silver) v1.0.0 | source: Databricks lakehouse-industry-data-models energy_utilities v1 ECM | generated 2026-10-13
-- 09 | Subject area: generation | 20 tables | CIM packages: IEC61970::Generation::Production; IEC61970::Core
-- Standards: NERC GADS; EPA CEMS (40 CFR Part 75); EIA-860/923; IEC 62325-301
-- Contents: tables (with PK + NOT NULL), then intra-subject-area foreign keys.
-- Unity Catalog PK/FK constraints are informational (NOT ENFORCED); NOT NULL is enforced.

USE CATALOG `utility_cmm_silver`;

-- GeneratingUnit  <<CIM GeneratingUnit : exact>>
CREATE TABLE IF NOT EXISTS `generation`.`generating_unit` (
  `generating_unit_id` BIGINT NOT NULL COMMENT 'Unique identifier for the generating unit. Primary key. _canonical_skip_reason: MASTER_RESOURCE role inferred; all required categories present.',
  `book_id` BIGINT COMMENT 'Foreign key linking to trading.trading_book. Business justification: Generation assets are assigned to trading books for P&L tracking, position management, and risk limit enforcement. Essential for financial reporting and market risk management in energy trading operat',
  `contingency_id` BIGINT COMMENT 'Foreign key linking to grid.contingency. Business justification: Generating units are primary elements in N-1/N-2 contingency definitions for reliability studies. Required for NERC TPL-001 compliance and operations planning.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Generating units are cost centers for O&M expense tracking, FERC accounting, and rate case cost allocation. Essential for monthly variance analysis and regulatory reporting.',
  `critical_spare_part_material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: Generating units consume spare parts (bearings, seals, filters) tracked in material master for maintenance planning and MRO procurement. Standard asset-material linkage in EAM/ERP systems for work ord',
  `ems_alarm_id` BIGINT COMMENT 'Foreign key linking to grid.ems_alarm. Business justification: Generator alarms (trip, limit violation, AVR failure) are monitored in EMS. Required for real-time operator response and equipment protection.',
  `ems_node_id` BIGINT COMMENT 'Foreign key linking to grid.ems_node. Business justification: Generating units connect to grid at specific EMS nodes (injection points). Required for state estimation, power flow analysis, and LMP calculation.',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Generating units operate within specific forecast zones for dispatch optimization, locational marginal pricing, and zonal capacity planning. Required for day-ahead market bidding, real-time dispatch c',
  `generating_belongs_to_power_plant` BIGINT COMMENT 'FK to generation.power_plant.power_plant_id — Every generating unit physically resides within a power plant. This is the fundamental parent-child hierarchy of the generation fleet. Without this FK, unit records are orphaned from their plant conte',
  `generating_power_plant_id` BIGINT COMMENT 'Identifier of the generation plant or facility to which this unit belongs. Links unit to plant-level master data.',
  `hedge_strategy_id` BIGINT COMMENT 'Foreign key linking to trading.hedge_strategy. Business justification: Physical generation assets are hedged via specific hedge strategies to mitigate price and volume risk. Critical for integrated risk management programs that link physical assets to financial hedges.',
  `maintenance_plan_id` BIGINT COMMENT 'Foreign key linking to asset.maintenance_plan. Business justification: Generating units require preventive maintenance plans (time-based, condition-based, regulatory-mandated) to ensure reliability, compliance, and optimal performance. Maintenance planning drives work or',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Units must track applicable regulatory obligations (NERC reliability standards, emissions limits, operational requirements) for compliance tracking, audit preparation, and regulatory reporting. Essent',
  `operating_limit_id` BIGINT COMMENT 'Foreign key linking to grid.operating_limit. Business justification: Generating units have operating limits (Pmin/Pmax, Qmin/Qmax) modeled in EMS. Required for economic dispatch, AGC, and voltage control.',
  `pmu_device_id` BIGINT COMMENT 'Foreign key linking to grid.pmu_device. Business justification: PMUs monitor generator terminal voltage/current phasors. Required for NERC PRC-002 synchrophasor data and oscillation detection.',
  `power_plant_id` BIGINT COMMENT 'FK to generation.power_plant.power_plant_id — Fundamental parent-child relationship: every generating unit physically resides within a power plant. This is the most critical FK in the domain — without it, you cannot aggregate unit-level data to p',
  `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Units are profit centers in merchant markets for P&L tracking, ISO settlement reconciliation, and unit-level profitability analysis. Critical for competitive generation operations.',
  `registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: Generating units are physical assets requiring comprehensive asset management for maintenance scheduling, depreciation, valuation, regulatory rate base reporting, and capital planning. Every generatio',
  `scada_point_id` BIGINT COMMENT 'Primary SCADA point identifier for real-time generation telemetry and monitoring. Used for integration with OSIsoft PI historian.',
  `spare_parts_catalog_id` BIGINT COMMENT 'Foreign key linking to supply.spare_parts_catalog. Business justification: Units have critical spare parts catalogs defining recommended stock levels for maintenance planning. Asset reliability management requires linking units to their spare parts catalogs for inventory opt',
  `transmission_substation_id` BIGINT COMMENT 'Foreign key linking to transmission.transmission_substation. Business justification: Every generating unit physically interconnects to the grid at a specific transmission substation (point of interconnection). Critical for interconnection agreements, dispatch instructions, settlement',
  `unit_environmental_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.environmental_permit. Business justification: Individual units operate under specific air/water permits with unit-level emissions limits and CEMS monitoring requirements, distinct from plant-level permits. Required for permit condition tracking,',
  `unit_operator_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Generating units have assigned certified operators per shift for control room operations, NERC CIP personnel accountability, and operational decision tracking. Critical for safety incidents, NERC GADS',
  `actual_retirement_date` DATE COMMENT 'Actual date when the generating unit was permanently retired from service. Null if unit is still active.',
  `ancillary_services_capable_flag` BOOLEAN COMMENT 'Indicates whether the unit is capable of providing ancillary services (regulation, spinning reserve, non-spinning reserve, voltage support) to the grid.',
  `balancing_authority` STRING COMMENT 'NERC-registered balancing authority area in which the generating unit operates. Determines scheduling and settlement rules.',
  `black_start_capable_flag` BOOLEAN COMMENT 'Indicates whether the unit can start and energize the grid without external power supply, critical for system restoration after blackouts.',
  `capacity_factor_design_pct` DECIMAL(5,2) COMMENT 'Design or expected capacity factor as a percentage, representing the ratio of actual output to maximum possible output over a period. Used for LCOE and IRP modeling.',
  `commercial_operation_date` DATE COMMENT 'Date when the generating unit entered commercial service and began producing electricity for sale. Key milestone for asset lifecycle and depreciation.',
  `dcs_asset_tag` STRING COMMENT 'Asset tag or identifier in the ABB Ability Symphony Plus DCS system for real-time SCADA integration and plant control. Links to telemetry and control points.',
  `emissions_controlled_flag` BOOLEAN COMMENT 'Indicates whether the unit is equipped with emissions control equipment (scrubbers, SCR, baghouse, etc.) to meet EPA standards.',
  `emissions_rate_co2_lb_per_mwh` DECIMAL(10,2) COMMENT 'Carbon dioxide emissions rate in pounds per megawatt-hour (MWh) of electricity generated. Used for environmental compliance and carbon accounting.',
  `emissions_rate_nox_lb_per_mwh` DECIMAL(10,4) COMMENT 'Nitrogen oxides emissions rate in pounds per megawatt-hour. Used for air quality compliance and NOx budget trading programs.',
  `emissions_rate_so2_lb_per_mwh` DECIMAL(10,4) COMMENT 'Sulfur dioxide emissions rate in pounds per megawatt-hour. Used for acid rain program compliance and SO2 allowance trading.',
  `ems_resource_code` STRING COMMENT 'Resource identifier in the Energy Management System used for unit commitment, economic dispatch, and real-time grid operations.',
  `fuel_type` STRING COMMENT 'Primary fuel or energy source used by the generating unit for power production. Reference-value candidates: natural_gas|coal|nuclear|water|wind|solar|biomass|diesel|geothermal|mixed.',
  `geographic_latitude` DECIMAL(10,7) COMMENT 'Latitude coordinate of the generating unit location in decimal degrees. Used for GIS mapping and spatial analysis.',
  `geographic_longitude` DECIMAL(10,7) COMMENT 'Longitude coordinate of the generating unit location in decimal degrees. Used for GIS mapping and spatial analysis.',
  `heat_rate_design_btu_per_kwh` DECIMAL(10,2) COMMENT 'Design-point heat rate of the unit in British Thermal Units (BTU) per kilowatt-hour (kWh), representing thermal efficiency. Lower values indicate higher efficiency. Used for LCOE analysis and fuel cost forecasting.',
  `heat_rate_full_load_btu_per_kwh` DECIMAL(10,2) COMMENT 'Heat rate at full load operating conditions in BTU per kWh. Used for economic dispatch and fuel consumption modeling.',
  `iso_rto_market` STRING COMMENT 'ISO or RTO market in which the unit participates for energy and ancillary services trading. Reference-value candidates: caiso|ercot|isone|miso|nyiso|pjm|spp|non_iso.',
  `minimum_down_time_hours` DECIMAL(6,2) COMMENT 'Minimum time in hours the unit must remain offline after shutdown before it can be restarted. Constraint for unit commitment.',
  `minimum_run_time_hours` DECIMAL(6,2) COMMENT 'Minimum time in hours the unit must remain online once started. Constraint for unit commitment and dispatch.',
  `minimum_stable_load_mw` DECIMAL(10,3) COMMENT 'Minimum electrical output in megawatts (MW) at which the unit can operate continuously without shutdown. Critical for unit commitment and dispatch optimization.',
  `nameplate_capacity_mw` DECIMAL(10,3) COMMENT 'Maximum rated electrical output capacity of the generating unit in megawatts (MW) under ideal conditions. Principal quantitative fact about the resource.',
  `nerc_unit_code` STRING COMMENT 'NERC-assigned unique identifier for the generating unit, required for reliability reporting and compliance.',
  `net_capacity_mw` DECIMAL(10,3) COMMENT 'Net electrical output capacity in megawatts (MW) after accounting for auxiliary loads and station service consumption.',
  `operational_status` STRING COMMENT 'Current operational state of the generating unit in its lifecycle. Determines availability for dispatch and capacity planning. Valid values: in_service|out_of_service|standby|mothballed|under_construction|retired.',
  `operator_entity` STRING COMMENT 'Entity responsible for day-to-day operations and maintenance of the generating unit. May differ from owner in PPA or tolling arrangements.',
  `owner_entity` STRING COMMENT 'Legal entity or business unit that owns the generating unit. Used for financial reporting and regulatory filings.',
  `planned_retirement_date` DATE COMMENT 'Scheduled date for permanent retirement or decommissioning of the generating unit. Used for long-term capacity planning and IRP.',
  `pnode_code` STRING COMMENT 'ISO/RTO pricing node identifier where the generating unit is interconnected to the transmission grid. Used for LMP settlement and energy trading.',
  `ramp_rate_down_mw_per_min` DECIMAL(8,3) COMMENT 'Maximum rate at which the unit can decrease electrical output, measured in megawatts per minute. Used for dispatch scheduling and grid balancing.',
  `ramp_rate_up_mw_per_min` DECIMAL(8,3) COMMENT 'Maximum rate at which the unit can increase electrical output, measured in megawatts per minute. Used for dispatch scheduling and grid balancing.',
  `rec_eligible_flag` BOOLEAN COMMENT 'Indicates whether the unit is eligible to generate Renewable Energy Certificates for compliance and trading.',
  `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this generating unit record was first created in the system. Audit trail for data lineage.',
  `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this generating unit record was last modified. Audit trail for change tracking.',
  `regulatory_classification` STRING COMMENT 'Regulatory classification of the generating unit under FERC and state PUC rules. Determines rate treatment and market participation rules. Valid values: rate_base|merchant|qualifying_facility|exempt_wholesale_generator|independent_power_producer.',
  `renewable_energy_flag` BOOLEAN COMMENT 'Indicates whether the unit qualifies as a renewable energy resource under state RPS and federal standards.',
  `startup_time_cold_hours` DECIMAL(6,2) COMMENT 'Time in hours required to bring the unit from cold shutdown to minimum stable load. Used for unit commitment optimization.',
  `startup_time_hot_hours` DECIMAL(6,2) COMMENT 'Time in hours required to bring the unit from hot shutdown to minimum stable load. Used for unit commitment optimization.',
  `unit_code` STRING COMMENT 'Externally-known unique code for the generating unit, used across operational systems and regulatory filings. Business identifier for the resource.',
  `unit_name` STRING COMMENT 'Human-readable name or designation of the generating unit (e.g., \'Turbine 3A\', \'Solar Array East\', \'CCGT Unit 1\'). Identity label for the resource.',
  `unit_type` STRING COMMENT 'Classification of the generating unit by technology type. Categorical field that segments the generation fleet. Reference-value candidates: ccgt|coal|nuclear|hydro|wind|solar|biomass|gas_turbine|steam_turbine|diesel|geothermal.',
  `voltage_level_kv` DECIMAL(8,2) COMMENT 'Nominal voltage level in kilovolts (kV) at which the unit interconnects to the grid.',
  `gis_location_id` BIGINT COMMENT 'Reference to the canonical CIM Location (gis.location) holding this entity\'s geometry, CRS and address. Implements CIM association PowerSystemResource.Location.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_generating_unit` PRIMARY KEY (`generating_unit_id`)
)
USING DELTA
COMMENT 'Master record for each individual generation unit (CCGT, coal, nuclear, hydro, wind turbine, solar array, biomass boiler) within the generation fleet. Captures nameplate capacity (MW), unit type, fuel type, commercial operation date, retirement date, ISO/RTO interconnection node (PNode), NERC unit code, regulatory classification, heat rate design point (BTU/kWh), minimum stable load, ramp rate limits, and ABB Ability Symphony Plus DCS asset tag. SSOT for generation unit identity across the enterprise. | CMM: CIM GeneratingUnit (exact), IEC61970::Generation::Production.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'GeneratingUnit',
  'cmm.cim.class' = 'GeneratingUnit',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61970::Generation::Production',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.generating_unit',
  'cmm.gis.location.role' = 'PowerSystemResource.Location'
);

-- PowerPlant  <<CIM Plant : close>>
CREATE TABLE IF NOT EXISTS `generation`.`power_plant` (
  `power_plant_id` BIGINT NOT NULL COMMENT 'Unique identifier for the power generation facility. Primary key for the power plant master record.',
  `book_id` BIGINT COMMENT 'Foreign key linking to trading.trading_book. Business justification: Power plants (aggregated units) are assigned to trading books for portfolio-level P&L attribution, risk limits, and regulatory reporting. Standard practice in utility trading operations.',
  `contingency_id` BIGINT COMMENT 'Foreign key linking to grid.contingency. Business justification: Multi-unit plants are modeled as contingency elements (loss of entire plant). Required for NERC TPL standards and worst-case contingency analysis.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Power plants operate within a balancing authority/control area for scheduling, ACE accounting, and reserve obligations. Essential for interchange scheduling and CPS compliance reporting.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Plants are primary cost centers for aggregated O&M, fuel, and labor costs. Required for budget vs actual reporting and FERC Form 1 preparation.',
  `ems_node_id` BIGINT COMMENT 'Foreign key linking to grid.ems_node. Business justification: Power plants connect at substation/node level for aggregate injection modeling. Required for EMS network topology and voltage control.',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Power plants are assigned to forecast zones for load planning, generation forecasting, and market operations. Zone assignment drives capacity adequacy assessments and transmission planning. Essential',
  `grid_topology_snapshot_id` BIGINT COMMENT 'Foreign key linking to grid.topology_snapshot. Business justification: Plant topology (bus configuration, breaker status) is captured in EMS snapshots. Required for state estimation and switching order validation.',
  `operating_limit_id` BIGINT COMMENT 'Foreign key linking to grid.operating_limit. Business justification: Power plants have aggregate operating limits for multi-unit dispatch. Required for plant-level economic dispatch and reserve allocation.',
  `plant_manager_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Power plants require designated plant managers for operational oversight, safety compliance, regulatory reporting (NERC, EPA), and personnel management. Essential for organizational accountability and',
  `pmu_device_id` BIGINT COMMENT 'Foreign key linking to grid.pmu_device. Business justification: Plant-level PMUs monitor common bus and aggregate generation. Required for WAMS and inter-area oscillation monitoring.',
  `poi_transmission_substation_id` BIGINT COMMENT 'Foreign key linking to transmission.transmission_substation. Business justification: Power plants connect to transmission grid at a point of interconnection (POI) substation. Essential for interconnection studies, FERC generator interconnection agreements, transmission service request',
  `primary_warehouse_id` BIGINT COMMENT 'Foreign key linking to supply.warehouse. Business justification: Plants receive materials from designated warehouses for operations and maintenance. Physical supply chain requires tracking which warehouse serves each plant for inventory planning, emergency restorat',
  `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Plants are profit centers for consolidated financial performance tracking, executive dashboards, and regulatory ROE calculations. Standard in utility financial structures.',
  `registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: Power plants are major capital assets requiring asset registry tracking for regulatory rate base inclusion, depreciation schedules, insurance valuation, capital project planning, and PUC prudency revi',
  `renewable_ppa_contract_id` BIGINT COMMENT 'Foreign key linking to renewable.ppa_contract. Business justification: Renewable power plants operate under PPAs defining energy pricing, capacity payments, REC ownership, and delivery obligations. Finance and settlements teams require this link for revenue recognition,',
  `address_line_1` STRING COMMENT 'Primary street address of the generation facility including street number and name.',
  `address_line_2` STRING COMMENT 'Secondary address information such as building, suite, or unit number.',
  `annual_generation_gwh` DECIMAL(12,3) COMMENT 'Total electricity generation in the most recent calendar year, measured in gigawatt-hours (GWh).',
  `capacity_factor_percent` DECIMAL(5,2) COMMENT 'Historical average capacity factor representing actual generation as a percentage of maximum potential generation.',
  `city` STRING COMMENT 'City or municipality where the generation facility is located.',
  `commercial_operation_date` DATE COMMENT 'Date when the generation facility first entered commercial service and began delivering power to the grid.',
  `country_code` STRING COMMENT 'Three-letter ISO country code where the generation facility is located. Pattern: ^[A-Z]{3}$.',
  `cpcn_number` STRING COMMENT 'State Public Utility Commission certificate number authorizing construction and operation of the generation facility.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this power plant record was first created in the system.',
  `dcs_system_code` STRING COMMENT 'Plant identifier in the Distributed Control System used for process control and automation.',
  `der_flag` BOOLEAN COMMENT 'Indicates whether the facility is classified as a Distributed Energy Resource (DER) connected at distribution voltage levels.',
  `eia_plant_code` STRING COMMENT 'EIA-assigned plant code used for federal energy data reporting and statistical analysis. Pattern: ^[0-9]{4,6}$.',
  `emissions_rate_co2_tons_per_mwh` DECIMAL(10,4) COMMENT 'Average carbon dioxide emissions rate in tons per MWh of generation.',
  `ferc_license_number` STRING COMMENT 'FERC license number for hydroelectric projects or other federally-licensed generation facilities.',
  `fuel_mix_classification` STRING COMMENT 'Primary fuel or energy source used by the generation facility. For multi-fuel plants, indicates the predominant fuel type. Reference-value candidates: coal|natural_gas|nuclear|hydro|wind|solar|biomass|geothermal|oil|dual_fuel|multi_fuel.',
  `gis_feature_code` STRING COMMENT 'Unique feature identifier for the plant in the enterprise GIS system.',
  `heat_rate_btu_per_kwh` DECIMAL(10,2) COMMENT 'Average heat rate of the facility in BTU per kWh, representing thermal efficiency of fuel-to-electricity conversion.',
  `interconnection_voltage_kv` DECIMAL(10,2) COMMENT 'Voltage level in kilovolts (kV) at which the plant connects to the transmission grid at the Point of Interconnection (POI).',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the plant location in decimal degrees (WGS84 datum).',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the plant location in decimal degrees (WGS84 datum).',
  `minimum_load_mw` DECIMAL(10,3) COMMENT 'Minimum stable generation level in megawatts below which the plant cannot operate economically or safely.',
  `nerc_plant_code` STRING COMMENT 'NERC-assigned unique identifier for the generation facility used in reliability reporting and compliance. Pattern: ^[A-Z0-9]{4,10}$.',
  `operational_status` STRING COMMENT 'Current operational state of the generation facility in its lifecycle. Valid values: operational|standby|mothballed|retired|under_construction|planned.',
  `operator_entity_name` STRING COMMENT 'Legal name of the entity responsible for day-to-day operations and maintenance of the facility.',
  `owner_entity_name` STRING COMMENT 'Legal name of the entity that owns the generation facility.',
  `ownership_percentage` DECIMAL(5,2) COMMENT 'Percentage of the facility owned by the reporting utility (for jointly-owned plants).',
  `planned_retirement_date` DATE COMMENT 'Anticipated date for permanent retirement or decommissioning of the generation facility.',
  `plant_name` STRING COMMENT 'Official business name of the generation facility as registered with regulatory authorities.',
  `plant_type` STRING COMMENT 'High-level classification of the generation facility based on primary energy source category. Valid values: conventional|renewable|hybrid|storage.',
  `postal_code` STRING COMMENT 'Postal or ZIP code for the facility location.',
  `primary_power_environmental_permit_id` BIGINT COMMENT 'Primary environmental operating permit number issued by EPA or state environmental agency.',
  `ramp_rate_mw_per_minute` DECIMAL(8,2) COMMENT 'Maximum rate at which the plant can increase or decrease generation output, measured in MW per minute.',
  `renewable_energy_flag` BOOLEAN COMMENT 'Indicates whether the facility qualifies as a renewable energy resource under state Renewable Portfolio Standard (RPS) programs.',
  `scada_system_code` STRING COMMENT 'Unique identifier for the plant in the SCADA or Energy Management System (EMS) used for real-time monitoring and control.',
  `startup_time_hours` DECIMAL(6,2) COMMENT 'Typical time in hours required to bring the plant from offline to minimum load (cold start).',
  `state_province` STRING COMMENT 'Two-letter state or province code where the facility is located (ISO 3166-2 subdivision code). Pattern: ^[A-Z]{2}$.',
  `tertiary_power_water_permit_environmental_permit_id` BIGINT COMMENT 'National Pollutant Discharge Elimination System (NPDES) permit number or equivalent state water discharge permit.',
  `total_installed_capacity_mw` DECIMAL(12,3) COMMENT 'Aggregate nameplate generation capacity across all generating units at the facility, measured in megawatts (MW).',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this power plant record was last modified.',
  `gis_location_id` BIGINT COMMENT 'Reference to the canonical CIM Location (gis.location) holding this entity\'s geometry, CRS and address. Implements CIM association PowerSystemResource.Location.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_power_plant` PRIMARY KEY (`power_plant_id`)
)
USING DELTA
COMMENT 'Master record for each physical generation facility (plant/station) that may contain one or more generating units. Captures plant name, NERC plant code, EIA plant ID, geographic coordinates, ISO/RTO balancing authority, state/jurisdiction, fuel mix classification, total installed capacity (MW), interconnection voltage level, environmental permit IDs, and operational status. Parent entity for generating_unit records. | CMM: CIM Plant (close), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PowerPlant',
  'cmm.cim.class' = 'Plant',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.power_plant',
  'cmm.gis.location.role' = 'PowerSystemResource.Location'
);

-- UnitCommitment  <<CIM GenUnitOpSchedule : close>>
CREATE TABLE IF NOT EXISTS `generation`.`unit_commitment` (
  `unit_commitment_id` BIGINT NOT NULL COMMENT 'Unique identifier for the unit commitment record. Primary key for this transactional record of day-ahead and intra-day unit commitment decisions.',
  `commitment_obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Unit commitment decisions governed by ISO/RTO market rules including must-offer obligations and capacity performance requirements. Essential for market rule compliance, offer validation, and regulator',
  `contingency_analysis_run_id` BIGINT COMMENT 'Foreign key linking to grid.contingency_analysis_run. Business justification: Unit commitments define available generation for day-ahead contingency analysis. Required for NERC TPL standards and next-day reliability assessment.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Unit commitments are control-area-specific for reserve requirements, capacity obligations, and day-ahead scheduling. Required for CPS1/CPS2 compliance and reserve adequacy tracking.',
  `dr_event_id` BIGINT COMMENT 'Foreign key linking to demand.dr_event. Business justification: ISO/RTO operators coordinate generation unit commitments with demand response events for real-time grid balancing. Market settlement and reliability reporting require tracking which DR events influenc',
  `environmental_permit_id` BIGINT COMMENT 'Reference to the air quality permit or emissions allowance under which this commitment operates. Links to EPA and state environmental compliance tracking.',
  `event_id` BIGINT COMMENT 'Foreign key linking to outage.outage_event. Business justification: ISO/RTO real-time market operations adjust unit commitments in response to major grid outages affecting transmission constraints or load pockets. Emergency dispatch protocols require linking commitmen',
  `interchange_schedule_id` BIGINT COMMENT 'Foreign key linking to grid.interchange_schedule. Business justification: Unit commitments enable firm interchange transactions (capacity backing for e-Tags). Required for NERC INT standards and transmission reservation coordination.',
  `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Market commitments trigger internal orders for fuel procurement, maintenance deferrals, and startup cost tracking. Essential for commitment cost settlement and variance analysis.',
  `load_id` BIGINT COMMENT 'Foreign key linking to forecast.load. Business justification: Unit commitments are scheduled based on specific load forecasts for day-ahead and real-time markets. ISO/RTO dispatch instructions reference load forecasts to determine economic commitment. Essential',
  `operator_log_id` BIGINT COMMENT 'Foreign key linking to grid.operator_log. Business justification: Unit commitments are logged for day-ahead planning and real-time coordination. Required for NERC reliability standards and market operations audit.',
  `primary_generating_unit_id` BIGINT COMMENT 'Reference to the specific generating unit (turbine, generator, or plant unit) for which this commitment decision applies. Links to the generation asset registry.',
  `tertiary_generating_unit_id` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — Every commitment decision is made for a specific generating unit. Without this FK, commitment records cannot be associated with the unit they authorize, breaking day-ahead scheduling and AGC workflows',
  `trade_id` BIGINT COMMENT 'Foreign key linking to trading.trade. Business justification: Unit commitments often originate from bilateral trades or self-schedules recorded as trade records. Essential for linking trade execution to physical unit commitment in ISO markets.',
  `transmission_path_id` BIGINT COMMENT 'Foreign key linking to transmission.path. Business justification: ISO/RTO unit commitment decisions must consider transmission path constraints and available transfer capability. Security-constrained unit commitment (SCUC) algorithms evaluate generation commitments',
  `agc_participation_flag` BOOLEAN COMMENT 'Indicates whether the unit is participating in Automatic Generation Control during this commitment period, allowing real-time dispatch adjustments for frequency regulation.',
  `ancillary_service_flag` BOOLEAN COMMENT 'Indicates whether this commitment includes provision of ancillary services (regulation, spinning reserve, non-spinning reserve, voltage support) in addition to energy.',
  `commitment_notes` STRING COMMENT 'Free-text notes providing additional context about the commitment decision, special operating instructions, or coordination requirements with transmission operators.',
  `commitment_number` STRING COMMENT 'Business identifier for the commitment decision. Externally-known reference number used in market submissions, dispatch communications, and regulatory reporting.',
  `commitment_period_end` TIMESTAMP COMMENT 'End date and time of the operating period for which the unit is committed. Defines the conclusion of the commitment window.',
  `commitment_period_start` TIMESTAMP COMMENT 'Start date and time of the operating period for which the unit is committed. Defines the beginning of the commitment window.',
  `commitment_reason_code` STRING COMMENT 'Code indicating the business reason for this commitment decision. Examples: economic dispatch, reliability requirement, voltage support, black start capability, renewable integration support.',
  `commitment_revision_number` INT COMMENT 'Sequential revision number for this commitment. Increments when commitment parameters are updated due to market re-runs, unit availability changes, or dispatch adjustments.',
  `commitment_source` STRING COMMENT 'Origin of the commitment decision. Indicates whether commitment resulted from ISO/RTO Security-Constrained Unit Commitment (SCUC), self-schedule, reliability requirement, or other source. Valid values: scuc|self_schedule|reliability_must_run|manual_dispatch|emergency_dispatch|ancillary_service.',
  `commitment_status` STRING COMMENT 'Current lifecycle status of the unit commitment. Tracks progression from initial commitment decision through dispatch execution to unit synchronization and operation. Reference-value candidates: pending|confirmed|dispatched|synchronized|operating|ramping_down|offline|cancelled|failed.',
  `commitment_timestamp` TIMESTAMP COMMENT 'Date and time when the commitment decision was made by the ISO/RTO or internal scheduling system. Principal business event timestamp for this transaction.',
  `committed_capacity_mw` DECIMAL(10,3) COMMENT 'The committed generation capacity in megawatts (MW) for the commitment period. Represents the output level the unit is scheduled to provide.',
  `created_by_user` STRING COMMENT 'User ID or system identifier that created this commitment record. Supports audit trail and accountability for commitment decisions.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this commitment record was first created in the system. Audit trail for record creation.',
  `dispatch_priority` INT COMMENT 'Numeric priority ranking for dispatch order. Lower numbers indicate higher priority. Used in economic dispatch and Automatic Generation Control (AGC) sequencing.',
  `economic_maximum_mw` DECIMAL(10,3) COMMENT 'Maximum generation level in megawatts at which the unit can operate economically under normal conditions. Represents the upper bound of the economic operating range.',
  `economic_minimum_mw` DECIMAL(10,3) COMMENT 'Minimum stable generation level in megawatts at which the unit can operate economically. Below this level, unit efficiency degrades significantly.',
  `estimated_co2_emissions_tons` DECIMAL(12,3) COMMENT 'Estimated carbon dioxide emissions in tons for the commitment period, calculated from fuel type, heat rate, and generation output.',
  `estimated_fuel_cost_usd` DECIMAL(15,2) COMMENT 'Estimated total fuel cost in US dollars for the commitment period, based on committed capacity, expected heat rate, and fuel price.',
  `estimated_nox_emissions_lbs` DECIMAL(12,3) COMMENT 'Estimated nitrogen oxides emissions in pounds for the commitment period. Critical for compliance with EPA NOx Budget Trading Program and regional air quality standards.',
  `estimated_so2_emissions_lbs` DECIMAL(12,3) COMMENT 'Estimated sulfur dioxide emissions in pounds for the commitment period. Required for EPA Acid Rain Program compliance and SO2 allowance tracking.',
  `estimated_startup_cost_usd` DECIMAL(15,2) COMMENT 'Estimated cost in US dollars to start the unit for this commitment, including fuel, maintenance wear, and auxiliary power. Varies by startup type.',
  `estimated_variable_om_cost_usd` DECIMAL(15,2) COMMENT 'Estimated variable operations and maintenance cost in US dollars for the commitment period, based on generation output and unit-specific O&M rates.',
  `expected_heat_rate_btu_per_kwh` DECIMAL(10,3) COMMENT 'Expected thermal efficiency of the unit during this commitment, measured in British Thermal Units (BTU) per kilowatt-hour. Lower values indicate higher efficiency.',
  `fuel_type` STRING COMMENT 'Primary fuel source for this commitment period. Examples: natural gas, coal, nuclear, hydro, wind, solar, biomass, oil, dual-fuel. Impacts emissions and cost calculations.',
  `iso_rto_code` STRING COMMENT 'Code identifying the Independent System Operator (ISO) or Regional Transmission Organization (RTO) that issued or cleared this commitment. Examples: CAISO, PJM, ERCOT, MISO, NYISO, ISO-NE, SPP.',
  `lmp_forecast_usd_per_mwh` DECIMAL(10,4) COMMENT 'Forecasted Locational Marginal Price in US dollars per megawatt-hour at the unit\'s pricing node (PNode) for the commitment period. Used in economic dispatch decisions.',
  `market_interval_end` TIMESTAMP COMMENT 'End timestamp of the market interval or trading period associated with this commitment. Defines the market settlement window.',
  `market_interval_start` TIMESTAMP COMMENT 'Start timestamp of the market interval or trading period associated with this commitment. Aligns commitment with specific market clearing results.',
  `market_type` STRING COMMENT 'Type of energy market associated with this commitment. Distinguishes Day-Ahead Market (DAM), Real-Time Market (RTM), hour-ahead, intra-hour, or bilateral arrangements. Valid values: dam|rtm|hour_ahead|intra_hour|bilateral.',
  `minimum_down_time_hours` DECIMAL(6,2) COMMENT 'Minimum offline time in hours required before the unit can be restarted. Technical constraint based on cooling requirements and equipment protection.',
  `minimum_run_time_hours` DECIMAL(6,2) COMMENT 'Minimum continuous operating time in hours required once the unit is started. Technical constraint based on unit design and thermal stress limits.',
  `modified_by_user` STRING COMMENT 'User ID or system identifier that last modified this commitment record. Supports audit trail for commitment revisions.',
  `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this commitment record was last modified. Audit trail for record updates and revisions.',
  `must_run_flag` BOOLEAN COMMENT 'Indicates whether this is a reliability-must-run (RMR) commitment required for transmission system reliability, voltage support, or local capacity requirements regardless of economics.',
  `ramp_rate_down_mw_per_min` DECIMAL(8,3) COMMENT 'Maximum rate at which the unit can decrease generation output, measured in megawatts per minute. Important for load-following and emergency response.',
  `ramp_rate_up_mw_per_min` DECIMAL(8,3) COMMENT 'Maximum rate at which the unit can increase generation output, measured in megawatts per minute. Critical for AGC response and frequency regulation.',
  `shutdown_time_hours` DECIMAL(6,2) COMMENT 'Expected time in hours from shutdown initiation to complete unit offline status, including controlled ramp-down and equipment securing.',
  `startup_time_hours` DECIMAL(6,2) COMMENT 'Expected time in hours from startup initiation to unit synchronization and minimum load, based on the startup type (hot/warm/cold).',
  `startup_type` STRING COMMENT 'Classification of the unit startup based on time offline and equipment temperature. Determines startup time, fuel consumption, and emissions profile. Valid values: hot|warm|cold|emergency.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_unit_commitment` PRIMARY KEY (`unit_commitment_id`)
)
USING DELTA
COMMENT 'Transactional record of the day-ahead and intra-day unit commitment decisions for each generating unit. Captures commitment period (start/end timestamp), committed capacity (MW), minimum run time, minimum down time, startup type (hot/warm/cold), commitment source (ISO/RTO security-constrained unit commitment or self-schedule), associated DAM or RTM market interval, and commitment status. Feeds AGC and dispatch scheduling workflows. Supports NERC TOP (Transmission Operations) and IRO (Interconnection Reliability Operations) standard compliance for reliability-must-run commitments and FERC market monitoring of self-scheduled vs market-committed units. | CMM: CIM GenUnitOpSchedule (close), IEC61970::Generation::Production.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'UnitCommitment',
  'cmm.cim.class' = 'GenUnitOpSchedule',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Generation::Production',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.unit_commitment'
);

-- DispatchSchedule  <<CIM GenUnitOpSchedule : exact>>
CREATE TABLE IF NOT EXISTS `generation`.`dispatch_schedule` (
  `dispatch_schedule_id` BIGINT NOT NULL COMMENT 'Unique identifier for the dispatch schedule record. Primary key for the dispatch schedule entity.',
  `congestion_event_id` BIGINT COMMENT 'Foreign key linking to transmission.congestion_event. Business justification: Real-time dispatch schedules are adjusted in response to transmission congestion events. When binding constraints occur, ISO/RTO operators redispatch generation to relieve congestion. Links dispatch i',
  `contingency_analysis_run_id` BIGINT COMMENT 'Foreign key linking to grid.contingency_analysis_run. Business justification: Dispatch setpoints are inputs to real-time contingency analysis for thermal and voltage limit checking. Required for NERC TPL-001 and real-time operations.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Dispatch instructions are issued by control area operators for AGC and economic dispatch. Essential for ACE calculation and real-time balancing operations.',
  `dispatch_generating_unit_id` BIGINT COMMENT 'Foreign key reference to the generating unit receiving this dispatch instruction. Links to the specific turbine, generator, or generation asset being dispatched.',
  `dispatch_unit_commitment_id` BIGINT COMMENT 'Foreign key reference to the unit commitment decision that authorized this dispatch schedule. Links to the day-ahead or real-time commitment that placed the unit online.',
  `dr_event_id` BIGINT COMMENT 'Foreign key linking to demand.dr_event. Business justification: Real-time dispatch schedules are adjusted based on active DR events. Operators need to track which DR events caused dispatch modifications for settlement, performance analysis, and regulatory reportin',
  `energy_schedule_id` BIGINT COMMENT 'Foreign key linking to trading.energy_schedule. Business justification: Dispatch instructions are matched to energy schedules (e-Tags) for settlement reconciliation and variance analysis. Core process in ISO market operations for physical vs. financial schedule alignment.',
  `event_id` BIGINT COMMENT 'Foreign key linking to outage.outage_event. Business justification: Major distribution or transmission outages trigger emergency dispatch schedule revisions, load shedding, and black-start procedures. Linking dispatch changes to causative outage events supports NERC e',
  `generating_unit_id` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — Every dispatch instruction targets a specific generating unit. Without this FK, dispatch records float without unit context, breaking real-time generation control and settlement reconciliation.',
  `load_id` BIGINT COMMENT 'Foreign key linking to forecast.load. Business justification: Dispatch schedules execute against specific load forecasts in real-time operations. AGC setpoints and economic dispatch orders reference load forecast intervals. Required for dispatch variance analysi',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Dispatch operations must comply with ISO/RTO market rules and NERC standards (BAL-001, INT-006). Required for market compliance validation, settlement dispute resolution, and demonstrating adherence t',
  `operator_log_id` BIGINT COMMENT 'Foreign key linking to grid.operator_log. Business justification: Dispatch instructions are logged for audit trail and compliance verification. Required for NERC BAL standards and market settlement disputes.',
  `primary_generating_unit_id` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — Dispatch schedules are issued per generating unit. This FK is essential for real-time generation control — the EMS/SCADA system must know which unit to dispatch. generating_unit_id is required on disp',
  `primary_unit_commitment_id` BIGINT COMMENT 'FK to generation.unit_commitment.unit_commitment_id — Dispatch schedules are derived from unit commitment decisions. unit_commitment_id links the dispatch instruction back to the commitment that authorized it, enabling settlement reconciliation.',
  `state_estimation_run_id` BIGINT COMMENT 'Foreign key linking to grid.state_estimation_run. Business justification: Dispatch schedules provide generation setpoints for state estimator base case. Required for real-time network analysis and contingency screening.',
  `unit_commitment_id` BIGINT COMMENT 'FK to generation.unit_commitment.unit_commitment_id — Dispatch instructions are authorized by unit commitment decisions. This link enables traceability from real-time dispatch back to the commitment that authorized it — critical for market settlement and',
  `actual_output_mw` DECIMAL(12,3) COMMENT 'The actual measured generation output in MW during this dispatch interval as reported by SCADA telemetry. Used for settlement reconciliation, AGC performance scoring, and dispatch compliance analysis. Compared against scheduled_output_mw to calculate dispatch variance.',
  `agc_setpoint_mw` DECIMAL(12,3) COMMENT 'The AGC setpoint in megawatts sent to the generating unit\'s automatic generation control system. This is the real-time control signal that adjusts unit output to maintain system frequency and balance generation with load. May differ slightly from scheduled_output_mw due to real-time balancing requirements.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this dispatch schedule record was first created in the system. Audit trail field for data lineage and compliance reporting.',
  `curtailment_reason_code` STRING COMMENT 'Categorical code indicating the reason for curtailment if the is_curtailed flag is true. Supports root cause analysis of generation curtailment events and regulatory reporting. Reference-value candidates: transmission_constraint|over_generation|market_condition|environmental_limit|fuel_limitation|equipment_derate|none.',
  `dispatch_acknowledgement_timestamp` TIMESTAMP COMMENT 'The timestamp when the generating unit operator or control system acknowledged receipt of this dispatch instruction. Used to measure response time and operator compliance.',
  `dispatch_compliance_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the generating unit\'s actual output was within acceptable tolerance of the scheduled output for this dispatch interval. True if compliant, false if variance exceeded threshold. Used for operator performance evaluation and NERC compliance reporting.',
  `dispatch_instruction_timestamp` TIMESTAMP COMMENT 'The timestamp when this dispatch instruction was issued by the EMS/SCADA system or received from the ISO/RTO. Represents when the instruction was communicated to plant operators or control systems. Used for performance analysis and compliance verification.',
  `dispatch_priority_code` STRING COMMENT 'Categorical code indicating the dispatch priority classification of this generating unit for this interval. Baseload units run continuously, intermediate units cycle daily, peaking units run during high-demand periods, renewable units dispatch when available, emergency units are last resort, and test dispatches are for commissioning or maintenance verification. Valid values: baseload|intermediate|peaking|renewable|emergency|test.',
  `dispatch_schedule_number` STRING COMMENT 'Business identifier for the dispatch schedule. Human-readable reference number used in operational communications and SCADA displays.',
  `dispatch_source_system` STRING COMMENT 'The source system that generated this dispatch instruction. Identifies whether the dispatch came from the internal EMS/SCADA dispatch engine (ABB Symphony Plus), an external ISO/RTO market dispatch, or manual operator entry. Valid values: ems|scada|iso_rto|manual|abb_symphony_plus.',
  `dispatch_status` STRING COMMENT 'Current lifecycle status of the dispatch schedule. Tracks whether the dispatch instruction is pending execution, actively being followed, completed, or cancelled. Valid values: scheduled|active|completed|cancelled|superseded|failed.',
  `dispatch_variance_mw` DECIMAL(12,3) COMMENT 'The difference between actual output and scheduled output in MW (actual_output_mw minus scheduled_output_mw). Positive values indicate over-generation; negative values indicate under-generation. Used for AGC performance scoring and NERC BAL compliance reporting.',
  `economic_dispatch_order` INT COMMENT 'The merit order ranking of this generating unit in the economic dispatch stack for this interval. Lower numbers indicate lower incremental cost and higher dispatch priority. Used for economic optimization of generation fleet.',
  `emissions_rate_co2_lbs_per_mwh` DECIMAL(10,3) COMMENT 'The carbon dioxide emissions rate in pounds per MWh for this generating unit at the scheduled output level during this dispatch interval. Used for environmental compliance reporting, carbon accounting, and emissions trading programs.',
  `fuel_type` STRING COMMENT 'The primary fuel type used by the generating unit for this dispatch interval. Supports fuel-specific dispatch optimization, emissions tracking, and renewable portfolio standard (RPS) compliance reporting. Reference-value candidates: natural_gas|coal|nuclear|hydro|wind|solar|biomass|oil|geothermal.',
  `heat_rate_btu_per_kwh` DECIMAL(10,2) COMMENT 'The heat rate in BTU per kWh for this generating unit at the scheduled output level during this dispatch interval. Represents the thermal efficiency of the unit. Lower heat rates indicate higher efficiency. Used for fuel cost calculation and LCOE analysis.',
  `incremental_cost_curve_reference` BIGINT COMMENT 'Foreign key reference to the incremental cost curve (heat rate curve) used to calculate the economic dispatch order for this unit during this interval. Links to the cost function that defines the relationship between output level and marginal cost.',
  `is_curtailed` BOOLEAN COMMENT 'Boolean flag indicating whether this dispatch schedule represents a curtailment instruction (reduction from maximum available output). True if the unit is being dispatched below its available capacity due to transmission constraints, over-generation conditions, or market conditions.',
  `is_must_run` BOOLEAN COMMENT 'Boolean flag indicating whether this generating unit is operating under a must-run designation for this interval. Must-run units are required to operate for reliability, voltage support, or contractual reasons regardless of economic dispatch order.',
  `iso_rto_dispatch_reference` STRING COMMENT 'External dispatch instruction identifier from the ISO or RTO if this dispatch schedule originated from a wholesale market dispatch signal. Used for settlement reconciliation and market compliance verification.',
  `locational_marginal_price_usd_per_mwh` DECIMAL(12,4) COMMENT 'The locational marginal price in USD per MWh at the generating unit\'s pricing node (PNode) for this dispatch interval. Represents the marginal cost of serving the next increment of load at this location. Used for settlement and economic analysis.',
  `market_type` STRING COMMENT 'The type of energy market or scheduling process that produced this dispatch instruction. Distinguishes between day-ahead market (DAM), real-time market (RTM), ancillary service dispatch, capacity market obligations, bilateral contracts, or internal economic dispatch. Valid values: day_ahead|real_time|ancillary_service|capacity|bilateral|internal.',
  `maximum_generation_limit_mw` DECIMAL(12,3) COMMENT 'The maximum available generation capacity in MW for this generating unit during this dispatch interval. Represents the technical upper bound considering current equipment status, ambient conditions, and operational constraints. Used to validate dispatch feasibility.',
  `minimum_generation_limit_mw` DECIMAL(12,3) COMMENT 'The minimum stable generation level in MW for this generating unit during this dispatch interval. Represents the technical lower bound below which the unit cannot operate reliably. Used to validate dispatch feasibility.',
  `modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this dispatch schedule record was last modified. Audit trail field for change tracking and data quality monitoring.',
  `must_run_reason_code` STRING COMMENT 'Categorical code indicating the reason for must-run designation if the is_must_run flag is true. Documents the reliability or contractual basis for out-of-merit dispatch. Valid values: reliability|voltage_support|black_start|contractual|local_capacity|none.',
  `operator_notes` STRING COMMENT 'Free-text field for plant operators or dispatch coordinators to record notes, observations, or special instructions related to this dispatch schedule. Supports operational knowledge capture and incident investigation.',
  `ramp_rate_mw_per_minute` DECIMAL(8,3) COMMENT 'The maximum allowable rate of change in generation output in MW per minute for this dispatch interval. Constrains how quickly the unit can increase or decrease output to protect equipment and maintain grid stability.',
  `regulation_down_mw` DECIMAL(10,3) COMMENT 'The amount of downward regulation capacity in MW that this generating unit is providing during this dispatch interval. Regulation down is the ability to decrease output below the scheduled setpoint to provide frequency regulation ancillary service.',
  `regulation_up_mw` DECIMAL(10,3) COMMENT 'The amount of upward regulation capacity in MW that this generating unit is providing during this dispatch interval. Regulation up is the ability to increase output above the scheduled setpoint to provide frequency regulation ancillary service.',
  `schedule_interval_end_timestamp` TIMESTAMP COMMENT 'The timestamp marking the end of the dispatch interval. Defines the duration for which this dispatch instruction is valid.',
  `schedule_interval_start_timestamp` TIMESTAMP COMMENT 'The timestamp marking the beginning of the dispatch interval. Represents the real-world time when this dispatch instruction becomes effective. Aligns with FERC Order 764 15-minute scheduling intervals or ISO/RTO market intervals.',
  `scheduled_output_mw` DECIMAL(12,3) COMMENT 'The target generation output in megawatts (MW) that the generating unit is instructed to produce during this dispatch interval. Core dispatch setpoint used by plant operators and AGC systems.',
  `settlement_amount_usd` DECIMAL(15,2) COMMENT 'The financial settlement amount in USD for this dispatch interval. Calculated as actual output (MWh) multiplied by the applicable LMP or contract price. Used for revenue recognition and market settlement reconciliation.',
  `spinning_reserve_mw` DECIMAL(10,3) COMMENT 'The amount of spinning reserve capacity in MW that this generating unit is providing during this dispatch interval. Spinning reserve is synchronized generation capacity that can respond within 10 minutes to replace lost generation.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_dispatch_schedule` PRIMARY KEY (`dispatch_schedule_id`)
)
USING DELTA
COMMENT 'Hourly and sub-hourly generation dispatch instructions for each generating unit, produced by the EMS/SCADA dispatch engine or received as ISO/RTO dispatch instructions per FERC Order 764 (15-minute scheduling intervals). Captures schedule interval timestamp, scheduled output (MW), economic dispatch order, incremental cost curve reference, curtailment flag, must-run flag, AGC setpoint, and source system (ABB Symphony Plus / EMS). Links to unit commitment decisions that authorize the dispatch. Supports real-time generation control, NERC BAL standard compliance (balancing authority ACE), AGC performance scoring, and settlement reconciliation against actual output telemetry. | CMM: CIM GenUnitOpSchedule (exact), IEC61970::Generation::Production.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DispatchSchedule',
  'cmm.cim.class' = 'GenUnitOpSchedule',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61970::Generation::Production',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.dispatch_schedule'
);

-- OutputTelemetry  <<CIM AnalogValue : close>>
CREATE TABLE IF NOT EXISTS `generation`.`output_telemetry` (
  `output_telemetry_id` BIGINT NOT NULL COMMENT 'Primary key for output_telemetry',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Generation telemetry aggregates to control area for ACE calculation, CPS1/CPS2 compliance, and real-time balancing. Required for NERC BAL standards reporting.',
  `generating_unit_id` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — Actual generation output telemetry is measured at the generating unit level. Without this FK, telemetry data cannot be attributed to the unit that produced it. Critical for settlement metering and per',
  `market_settlement_id` BIGINT COMMENT 'Foreign key linking to trading.market_settlement. Business justification: Actual generation telemetry is the basis for market settlement calculations and invoice reconciliation. Fundamental meter-to-cash process linking physical generation to financial settlement.',
  `output_for_generating_unit` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — Every telemetry reading comes from a specific generating unit. Without this FK, actual generation data cannot be attributed to units, breaking settlement metering, NERC compliance, and LCOE calculatio',
  `output_generating_unit_id` BIGINT COMMENT 'Foreign key reference to the specific generating unit (turbine, generator, or plant unit) that produced this telemetry reading. Links to the asset registry for unit-level attribution.',
  `primary_generating_unit_id` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — Generation output telemetry is measured per generating unit via SCADA/DCS. This FK is critical for settlement metering, NERC compliance, and LCOE calculations. generating_unit_id is required on output',
  `state_estimation_run_id` BIGINT COMMENT 'Foreign key linking to grid.state_estimation_run. Business justification: Generation telemetry measurements feed state estimator for real-time power flow solution. Required for EMS observability and bad data detection.',
  `ambient_temperature_c` DECIMAL(6,2) COMMENT 'Ambient air temperature at the generating unit location during the interval, measured in degrees Celsius. Impacts heat rate, efficiency calculations, and capacity derating for thermal units.',
  `ancillary_service_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether the generating unit was providing ancillary services (regulation, spinning reserve, non-spinning reserve, voltage support) during this interval.',
  `auxiliary_load_mwh` DECIMAL(18,6) COMMENT 'Electrical energy consumed by the generating unit\'s auxiliary equipment and station service during the interval, measured in megawatt-hours (MWh). Represents the difference between gross and net generation.',
  `availability_status` STRING COMMENT 'Operational availability status of the generating unit during the interval. Indicates whether the unit was available for dispatch, unavailable due to outage, operating at reduced capacity, or in a transitional state. Valid values: available|unavailable|derated|testing|startup|shutdown.',
  `capacity_factor_percent` DECIMAL(5,2) COMMENT 'Ratio of actual generation to maximum possible generation during the interval, expressed as a percentage. Indicates unit utilization and performance relative to nameplate capacity. Range: 0.00 to 100.00.',
  `data_quality_flag` STRING COMMENT 'Quality indicator for the telemetry reading. Flags whether the data point is validated, estimated due to sensor failure, missing, suspect and requiring review, or manually overridden by operations staff. Valid values: valid|estimated|missing|suspect|manual_override.',
  `data_source_system` STRING COMMENT 'Name of the upstream operational system that provided this telemetry record to the lakehouse. Typically OSIsoft PI, ABB Ability Symphony Plus, or GE PowerOn. Used for data lineage and integration monitoring.',
  `dispatch_status` STRING COMMENT 'Dispatch instruction status for the generating unit during the interval. Indicates whether the unit was actively dispatched by the ISO/RTO, committed for reliability, operating economically, or offline. Valid values: dispatched|committed|economic|must_run|curtailed|offline.',
  `emissions_co2_tons` DECIMAL(18,6) COMMENT 'Estimated carbon dioxide emissions produced during the interval, measured in metric tons. Calculated from fuel consumption and emission factors. Used for environmental compliance reporting and carbon accounting.',
  `emissions_nox_lbs` DECIMAL(18,6) COMMENT 'Estimated nitrogen oxides emissions produced during the interval, measured in pounds. Critical for air quality compliance and emissions trading programs.',
  `emissions_so2_lbs` DECIMAL(18,6) COMMENT 'Estimated sulfur dioxide emissions produced during the interval, measured in pounds. Used for environmental compliance and emissions allowance tracking.',
  `forced_outage_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether the generating unit experienced a forced outage or unplanned derate during this interval. Used for reliability reporting and NERC GADS compliance.',
  `frequency_deviation_hz` DECIMAL(8,4) COMMENT 'Deviation from nominal grid frequency (typically 60 Hz in North America or 50 Hz elsewhere) during the interval, measured in hertz. Used for grid stability monitoring and NERC compliance reporting.',
  `fuel_consumption_mmbtu` DECIMAL(18,4) COMMENT 'Total fuel consumed by the generating unit during the interval, measured in million British Thermal Units (MMBtu). Used for fuel inventory management, cost allocation, and emissions calculations.',
  `gross_generation_mwh` DECIMAL(18,6) COMMENT 'Total electrical energy generated by the unit during the interval, measured in megawatt-hours (MWh), before deducting auxiliary load or station service. Primary metric for generation capacity and output tracking.',
  `heat_rate_btu_per_kwh` DECIMAL(10,2) COMMENT 'Thermal efficiency of the generating unit during the interval, expressed as British Thermal Units (BTU) of fuel input per kilowatt-hour of electrical output. Lower values indicate higher efficiency. Critical for LCOE analysis and fuel cost optimization.',
  `historian_tag_name` STRING COMMENT 'The specific tag name or point identifier in the OSIsoft PI historian or equivalent time-series database that stores this telemetry reading. Used for data lineage, audit trails, and integration with real-time monitoring systems.',
  `interval_duration_minutes` INT COMMENT 'The duration of the measurement interval in minutes. Common values include 5, 15, or 60 minutes. Used to normalize interval data for aggregation and settlement calculations.',
  `interval_timestamp` TIMESTAMP COMMENT 'The precise timestamp marking the end of the measurement interval for this telemetry reading. Represents the real-world event time when the generation output was recorded by the DCS or SCADA system. Typically aligned to 5-minute, 15-minute, or hourly intervals depending on settlement and reporting requirements.',
  `lmp_pricing_node` STRING COMMENT 'The pricing node (PNode) identifier at which this generation output is settled in the wholesale market. Used to associate generation with locational marginal pricing for revenue settlement.',
  `market_settlement_amount_usd` DECIMAL(18,2) COMMENT 'Financial settlement amount for this generation interval in US dollars, calculated based on net generation and applicable LMP or contract rates. Used for revenue recognition and financial reporting.',
  `net_generation_mwh` DECIMAL(18,6) COMMENT 'Net electrical energy delivered to the grid during the interval, measured in megawatt-hours (MWh), after deducting auxiliary load and station service consumption. Used for settlement metering, revenue calculations, and LCOE analysis.',
  `planned_outage_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether the generating unit was on a scheduled planned outage or maintenance during this interval. Used for capacity planning and reliability reporting.',
  `power_factor` DECIMAL(5,4) COMMENT 'Ratio of real power to apparent power during the interval, expressed as a decimal between 0 and 1. Indicates the efficiency of power delivery and compliance with grid interconnection standards. Typical range: 0.85 to 1.00.',
  `ramp_rate_mw_per_min` DECIMAL(10,4) COMMENT 'Rate of change in generation output during the interval, measured in megawatts per minute. Indicates the unit\'s ability to respond to dispatch signals and grid frequency changes. Critical for AGC and frequency response compliance.',
  `reactive_power_mvar` DECIMAL(18,6) COMMENT 'Reactive power output during the interval, measured in megavolt-amperes reactive (MVAr). Critical for voltage support, grid stability, and compliance with interconnection agreements.',
  `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this telemetry record was first inserted into the lakehouse silver layer. Used for data lineage, audit trails, and ETL troubleshooting. Distinct from interval_timestamp which represents the business event time.',
  `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this telemetry record was last modified in the lakehouse silver layer. Used for change tracking, audit trails, and data quality monitoring. Updated whenever VEE processes or manual corrections are applied.',
  `scada_source_system` STRING COMMENT 'Identifier of the SCADA or DCS system that originated this telemetry reading. Typically references ABB Ability Symphony Plus, OSIsoft PI, or other plant control systems. Used for data lineage and troubleshooting.',
  `settlement_meter_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether this telemetry reading is used for financial settlement with the ISO/RTO or wholesale market. True indicates the reading is settlement-quality and used for revenue calculations.',
  `validation_method` STRING COMMENT 'Method used to validate or estimate the telemetry reading. Indicates whether the data was automatically validated, manually reviewed, processed through Validation Estimation and Editing (VEE) algorithms, or verified by SCADA/historian systems. Valid values: automated|manual|vee|scada_verified|historian_validated.',
  `voltage_kv` DECIMAL(10,3) COMMENT 'Terminal voltage at the generator output during the interval, measured in kilovolts (kV). Used for voltage regulation monitoring and compliance with interconnection requirements.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_output_telemetry` PRIMARY KEY (`output_telemetry_id`)
)
USING DELTA
COMMENT 'Interval-level actual generation output telemetry for each generating unit, sourced from OSIsoft PI historian via ABB Ability Symphony Plus DCS integration. Captures interval timestamp (5-min, 15-min, hourly), gross generation (MWh), net generation (MWh), auxiliary load (MWh), reactive power (MVAr), power factor, frequency deviation, and data quality flag. Primary source for settlement metering, NERC compliance, and LCOE calculations. | CMM: CIM AnalogValue (close), IEC61970::Meas.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'OutputTelemetry',
  'cmm.cim.class' = 'AnalogValue',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Meas',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.output_telemetry'
);

-- HeatRateTest  <<CIM HeatRateCurve : close>>
CREATE TABLE IF NOT EXISTS `generation`.`heat_rate_test` (
  `heat_rate_test_id` BIGINT NOT NULL COMMENT 'Unique identifier for the heat rate test record. Primary key for the heat_rate_test product.',
  `generating_unit_id` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — Performance tests (heat rate and capacity) are conducted on specific generating units. generating_unit_id is required for NERC MOD compliance tracking and IRP modeling.',
  `heat_for_generating_unit` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — Every performance/capability test is conducted on a specific generating unit. Without this FK, test results cannot be linked to the unit they measure, breaking NERC MOD-025 compliance and capacity acc',
  `heat_generating_unit_id` BIGINT COMMENT 'Reference to the generating unit on which the heat rate test was conducted. Links to the generating unit asset registry.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Heat rate tests satisfy ISO/RTO market qualification rules and FERC requirements for market-based rate authority. Essential for market participation compliance, rate case support, and regulatory submi',
  `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: Heat rate tests are performed as part of commissioning work orders, post-maintenance validation, or ISO/RTO performance verification requirements. Linking tests to work orders tracks labor costs, sche',
  `acceptance_criteria_description` STRING COMMENT 'Textual description of the acceptance criteria applied to this test, including tolerance bands, correction factors, and contractual requirements. Provides context for the test acceptance flag.',
  `ambient_pressure_psia` DECIMAL(8,4) COMMENT 'Ambient barometric pressure in pounds per square inch absolute during the test. Affects air density and combustion turbine performance.',
  `ambient_temperature_f` DECIMAL(6,2) COMMENT 'Ambient air temperature in degrees Fahrenheit during the test. Ambient conditions significantly affect gas turbine and combined cycle performance, so temperature correction factors are applied to normalize results.',
  `auxiliary_load_mw` DECIMAL(12,4) COMMENT 'Station auxiliary electrical load in megawatts during the test period. Includes cooling water pumps, fans, fuel handling equipment, and other plant auxiliary systems.',
  `corrected_net_heat_rate_btu_per_kwh` DECIMAL(12,4) COMMENT 'Net heat rate corrected to ISO base conditions (59°F, 14.7 psia, 60% RH) or other contractual reference conditions. Allows apples-to-apples comparison across tests conducted under different ambient conditions.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this heat rate test record was first created in the system. Audit trail for data lineage.',
  `design_net_heat_rate_btu_per_kwh` DECIMAL(12,4) COMMENT 'The design or guaranteed net heat rate for the generating unit at the tested load level and ambient conditions, expressed in BTU/kWh. Used as the baseline for performance comparison.',
  `fuel_consumption_rate` DECIMAL(15,4) COMMENT 'Rate of fuel consumption during the test period. Units vary by fuel type (e.g., scf/hr for natural gas, lb/hr for coal, gallons/hr for oil). Used to calculate total heat input.',
  `fuel_consumption_unit` STRING COMMENT 'Unit of measure for the fuel consumption rate. Must align with the fuel type and HHV units for accurate heat rate calculation. Valid values: scf_per_hr|lb_per_hr|gallon_per_hr|mmbtu_per_hr|kg_per_hr.',
  `fuel_hhv_btu_per_unit` DECIMAL(12,4) COMMENT 'Higher heating value of the fuel used during the test, expressed in BTU per unit (e.g., BTU/scf for natural gas, BTU/lb for coal). HHV is used in heat rate calculations to determine thermal efficiency.',
  `fuel_type` STRING COMMENT 'Type of fuel consumed during the heat rate test. Heat rate calculations require accurate fuel heating value and composition data specific to the fuel type. Valid values: natural_gas|coal|nuclear|oil|biomass|waste_heat.',
  `gross_output_mw` DECIMAL(12,4) COMMENT 'Gross electrical output of the generating unit during the test in megawatts, measured at the generator terminals before auxiliary load deduction.',
  `heat_rate_deviation_percent` DECIMAL(8,4) COMMENT 'Percentage deviation of measured heat rate from design heat rate. Positive values indicate performance degradation (higher heat rate than design). Negative values indicate better-than-design performance. Calculated as ((measured - design) / design) * 100.',
  `iso_rto_submission_date` DATE COMMENT 'Date on which the test results were submitted to the ISO or RTO. Null if not submitted.',
  `iso_rto_submission_flag` BOOLEAN COMMENT 'Indicates whether this test result was submitted to the ISO or RTO for capacity market accreditation or resource adequacy purposes. True if submitted, False if not.',
  `load_level_percent` DECIMAL(6,2) COMMENT 'The load level at which the test was conducted, expressed as a percentage of the unit\'s rated net capacity. Heat rate varies with load level, so this context is critical for performance analysis.',
  `measured_net_heat_rate_btu_per_kwh` DECIMAL(12,4) COMMENT 'The actual net heat rate measured during the test, expressed in British Thermal Units per kilowatt-hour. Lower values indicate better thermal efficiency. This is the primary performance metric for generating unit efficiency and is used for LCOE analysis and IRP modeling.',
  `nerc_compliance_flag` BOOLEAN COMMENT 'Indicates whether this test was conducted to satisfy NERC MOD-025 generator verification requirements. True if conducted for NERC compliance, False otherwise.',
  `net_output_mw` DECIMAL(12,4) COMMENT 'Net electrical output of the generating unit during the test in megawatts, measured at the point of interconnection after deducting station auxiliary load. This is the load level at which the heat rate was tested.',
  `relative_humidity_percent` DECIMAL(5,2) COMMENT 'Relative humidity as a percentage during the test. Humidity affects combustion turbine performance and is used in correction factor calculations.',
  `scada_data_source` STRING COMMENT 'Identifier of the SCADA or DCS system from which real-time telemetry data was collected during the test. Typically references OSIsoft PI tags or ABB Ability Symphony Plus data points.',
  `test_acceptance_flag` BOOLEAN COMMENT 'Indicates whether the test results met acceptance criteria. True if the measured heat rate was within contractual tolerance of design heat rate, False if performance was out of tolerance.',
  `test_date` DATE COMMENT 'The date on which the heat rate test was conducted. Primary business event timestamp for the test.',
  `test_duration_minutes` DECIMAL(10,2) COMMENT 'Total duration of the heat rate test in minutes. ASME PTC 46 typically requires minimum 2-4 hours of steady-state operation for valid heat rate tests.',
  `test_end_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the heat rate test data collection concluded. Used to calculate test duration and validate steady-state conditions.',
  `test_engineer_name` STRING COMMENT 'Name of the lead engineer responsible for conducting and supervising the heat rate test. Provides accountability and contact for test methodology questions.',
  `test_notes` STRING COMMENT 'Free-form notes documenting test conditions, anomalies, equipment issues, or other contextual information relevant to interpreting the test results.',
  `test_number` STRING COMMENT 'Business identifier for the heat rate test. Externally-known unique code used for tracking and reporting purposes.',
  `test_report_document_reference` STRING COMMENT 'Reference identifier for the formal test report document stored in the document management system. Links to detailed test methodology, data sheets, and analysis.',
  `test_start_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the heat rate test data collection began. Used for correlating with SCADA telemetry and operational logs.',
  `test_status` STRING COMMENT 'Current lifecycle status of the heat rate test. Scheduled tests are planned but not started. In-progress tests are actively being conducted. Completed tests have finished data collection. Validated tests have passed quality review. Rejected tests failed validation criteria. Cancelled tests were aborted before completion. Valid values: scheduled|in_progress|completed|validated|rejected|cancelled.',
  `test_type` STRING COMMENT 'Classification of the heat rate test. Acceptance tests validate new or refurbished units against design specifications. Periodic tests are routine performance assessments. Diagnostic tests investigate performance degradation. Baseline tests establish reference performance. Warranty tests verify vendor guarantees. Performance verification tests support capacity market accreditation. Valid values: acceptance|periodic|diagnostic|baseline|warranty|performance_verification.',
  `test_witness_organization` STRING COMMENT 'Name of the independent third-party organization that witnessed the test, if applicable. Common for acceptance tests, warranty tests, and ISO/RTO capacity accreditation tests.',
  `total_heat_input_mmbtu` DECIMAL(15,4) COMMENT 'Total heat input to the generating unit during the test period in million BTU. Calculated as fuel consumption rate multiplied by fuel HHV and test duration. Used as the numerator in heat rate calculation.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this heat rate test record was last modified. Audit trail for data lineage and change tracking.',
  `validated_by` STRING COMMENT 'Name of the engineer or manager who validated and approved the test results. Provides accountability for data quality.',
  `validation_date` DATE COMMENT 'Date on which the test results were validated and approved. Null if validation is pending or rejected.',
  `validation_status` STRING COMMENT 'Status of the engineering validation review for the test results. Pending indicates awaiting review. Approved indicates results passed quality checks. Rejected indicates results failed validation. Under review indicates active engineering analysis. Valid values: pending|approved|rejected|under_review.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_heat_rate_test` PRIMARY KEY (`heat_rate_test_id`)
)
USING DELTA
COMMENT 'Records of periodic performance and capability tests conducted on generating units. For heat rate tests: captures test date, test type (acceptance, periodic, diagnostic), measured net heat rate (BTU/kWh), design heat rate, ambient temperature, load level tested (MW), fuel type and HHV used, test duration, and deviation from design. For capacity tests: captures demonstrated net capability (MW), net dependable capability (MW), test type (summer peak, winter peak, seasonal), ambient conditions, test duration, and ISO/RTO submission status. Used for LCOE analysis, IRP modeling, NERC MOD-025 compliance, and capacity market accreditation. SSOT for all generating unit performance and capability test results. | CMM: CIM HeatRateCurve (close), IEC61970::Generation::Production.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'HeatRateTest',
  'cmm.cim.class' = 'HeatRateCurve',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Generation::Production',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.heat_rate_test'
);

-- FuelInventory  <<CIM FossilFuel : broad>>
CREATE TABLE IF NOT EXISTS `generation`.`fuel_inventory` (
  `fuel_inventory_id` BIGINT NOT NULL COMMENT 'Unique identifier for the fuel inventory record. Primary key for fuel inventory positions and receipt transactions at thermal generation facilities.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Fuel inventory is charged to specific cost centers for expense allocation, fuel cost recovery filings, and inventory valuation. Standard in utility accounting.',
  `fuel_contract_id` BIGINT COMMENT 'FK to generation.fuel_contract.fuel_contract_id — Fuel receipts (now merged into fuel_inventory) reference the supply contract under which fuel was delivered. fuel_contract_id is needed for contract compliance monitoring and cost allocation.',
  `fuel_power_plant_id` BIGINT COMMENT 'Identifier of the thermal generation facility where the fuel inventory is held. Links to the generation plant master data.',
  `generating_unit_id` BIGINT COMMENT 'Identifier of the specific generation unit consuming or storing this fuel. Links to the generation unit master data.',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Fuel inventory must post to specific GL accounts (FERC 151, 152) for monthly close, balance sheet reconciliation, and regulatory reporting.',
  `goods_receipt_id` BIGINT COMMENT 'Foreign key linking to supply.goods_receipt. Business justification: Fuel receipts create inventory records in fuel_inventory. Standard materials management flow requires linking inventory transactions to goods receipts for traceability, quality certification tracking,',
  `material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: Fuel inventory items are materials with master data (specifications, procurement type, valuation class). Standard ERP integration where fuel_inventory extends material_master with generation-specific',
  `power_plant_id` BIGINT COMMENT 'FK to generation.power_plant.power_plant_id — Fuel inventory is tracked at the plant/facility level (coal piles, gas storage, fuel oil tanks are plant-level assets). Without this FK, fuel positions cannot be associated with the plant they supply.',
  `primary_power_plant_id` BIGINT COMMENT 'FK to generation.power_plant.power_plant_id — Fuel inventory is tracked at the plant/facility level (coal piles, gas interconnects, oil tanks are plant-level assets). power_plant_id is required on fuel_inventory for fuel supply planning and gener',
  `warehouse_id` BIGINT COMMENT 'Foreign key linking to supply.warehouse. Business justification: Fuel stored in specific warehouse locations (coal yards, oil tanks, gas storage). Physical inventory management requires linking fuel records to warehouse for stock tracking, cycle counts, and days-of',
  `adjustment_reason` STRING COMMENT 'Explanation for inventory adjustments or corrections. Examples include physical inventory count variance, measurement error correction, fuel quality degradation, evaporation loss, or system reconciliation. Required for SOX audit trail and internal controls.',
  `carbon_content_percent` DECIMAL(6,3) COMMENT 'Carbon content of the fuel as a percentage by weight. Used to calculate carbon dioxide (CO2) emissions for EPA greenhouse gas reporting, carbon pricing programs, and Renewable Portfolio Standard (RPS) compliance. Higher carbon content increases CO2 emissions per unit of energy.',
  `chlorine_content_ppm` DECIMAL(10,3) COMMENT 'Chlorine content of the fuel measured in parts per million (ppm). Contributes to boiler corrosion and hydrochloric acid (HCl) emissions. Monitored for EPA air toxics compliance and boiler materials integrity management.',
  `comments` STRING COMMENT 'Free-text comments or notes regarding this fuel inventory record. Captures operational context, special handling instructions, quality issues, delivery exceptions, or other relevant information for fuel management and audit purposes.',
  `contract_reference` STRING COMMENT 'Reference number or identifier of the fuel supply contract or Power Purchase Agreement (PPA) governing this receipt. Links fuel deliveries to contractual terms, pricing agreements, and procurement commitments. Business-confidential contract data.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this fuel inventory record was first created in the system. Supports data lineage, audit trail, and SOX compliance for financial controls. Distinct from inventory date or receipt timestamp which represent business event times.',
  `data_quality_flag` STRING COMMENT 'Indicator of data quality status for this fuel inventory record. Verified indicates quality-assured data, estimated for calculated or interpolated values, pending verification for preliminary data awaiting confirmation, failed validation for records with quality issues requiring correction. Valid values: verified|estimated|pending_verification|failed_validation.',
  `days_of_supply` DECIMAL(8,2) COMMENT 'Calculated number of days the current fuel inventory can support generation operations at average burn rate. Critical metric for fuel supply planning, generation availability forecasting, and risk management during supply disruptions.',
  `eia_plant_code` STRING COMMENT 'Federal Energy Information Administration (EIA) unique plant identifier. Required for EIA Form 923 monthly fuel receipt and cost reporting. Links internal fuel inventory data to federal regulatory reporting requirements.',
  `ferc_account_code` STRING COMMENT 'Federal Energy Regulatory Commission (FERC) Uniform System of Accounts code for fuel inventory accounting. Typically account 151 for fuel stock. Required for FERC Form 1 financial reporting and rate case filings.',
  `fixed_carbon_percent` DECIMAL(6,3) COMMENT 'Fixed carbon content of coal as a percentage by weight. Represents the solid combustible residue after volatile matter is driven off. Higher fixed carbon indicates higher energy content and coal rank. Critical for coal quality classification and heat rate calculations.',
  `inventory_date` DATE COMMENT 'Date of the inventory position snapshot or receipt transaction. For positions, represents the as-of date for stock levels. For receipts, represents the date fuel was received at the facility.',
  `inventory_status` STRING COMMENT 'Current status of the fuel inventory. Available for generation use, reserved for specific unit commitment, in transit from supplier, quarantined pending quality verification, or consumed (historical record). Supports inventory allocation and generation scheduling. Valid values: available|reserved|in_transit|quarantined|consumed.',
  `invoice_number` STRING COMMENT 'Supplier invoice number for the fuel receipt transaction. Links fuel deliveries to accounts payable, supports invoice reconciliation, and provides audit trail for financial controls per Sarbanes-Oxley Act (SOX) requirements.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this fuel inventory record was last modified. Tracks data changes for audit purposes, supports change data capture for downstream analytics, and provides data freshness indicator for operational dashboards.',
  `mercury_content_ppm` DECIMAL(10,6) COMMENT 'Mercury content of coal fuel measured in parts per million (ppm). Required for EPA Mercury and Air Toxics Standards (MATS) compliance. High mercury content requires additional emissions controls such as activated carbon injection or scrubber upgrades.',
  `minimum_operating_reserve` DECIMAL(18,3) COMMENT 'Minimum fuel quantity required to maintain safe and reliable plant operations. Expressed in same unit of measure as quantity. Used for fuel supply planning and procurement trigger points to ensure generation availability.',
  `nitrogen_content_percent` DECIMAL(6,4) COMMENT 'Nitrogen content of the fuel as a percentage by weight. Affects nitrogen oxide (NOx) emissions formation during combustion. Critical for EPA air quality compliance, NOx emissions calculations, and selective catalytic reduction (SCR) system design.',
  `origin_location` STRING COMMENT 'Geographic origin or source location of the fuel. Examples include coal mine name and state, natural gas production basin, nuclear fuel fabrication facility, or biomass harvest region. Supports supply chain tracking and sourcing analysis.',
  `quality_certification_number` STRING COMMENT 'Certificate or lab analysis number documenting fuel quality test results. Links to third-party laboratory reports for heat content, sulfur, moisture, and ash analysis. Provides audit trail for fuel quality assurance and contract compliance.',
  `quantity` DECIMAL(18,3) COMMENT 'Quantity of fuel in inventory or received. Measured in tons for coal and biomass, Million British Thermal Units (MMBtu) for natural gas and oil, or fuel assemblies for nuclear fuel. Precision supports accurate fuel accounting and EIA reporting.',
  `receipt_timestamp` TIMESTAMP COMMENT 'Precise date and time when fuel was received at the generation facility. Captured from weigh station, pipeline meter, or receiving dock systems. Supports just-in-time inventory management and delivery performance tracking.',
  `source_system` STRING COMMENT 'Identifier of the operational system that originated this fuel inventory record. Examples include SAP Materials Management (MM), OSIsoft PI historian, plant fuel management system, or manual entry. Supports data lineage and system-of-record tracking.',
  `supplier_name` STRING COMMENT 'Name of the fuel supplier or vendor for receipt transactions. Tracks fuel procurement sources for contract management, supplier performance evaluation, and supply chain risk assessment. Business-confidential supplier relationship data.',
  `total_cost` DECIMAL(18,2) COMMENT 'Total cost of the fuel inventory position or receipt transaction in US dollars. Calculated as quantity multiplied by unit cost, adjusted for energy content. Used for financial reporting, Capital Expenditure (CAPEX) and Operational Expenditure (OPEX) tracking, and regulatory rate case filings.',
  `transaction_type` STRING COMMENT 'Type of fuel inventory transaction. Position represents current stock level, receipt captures incoming fuel deliveries, consumption tracks fuel burned for generation, adjustment handles inventory corrections, and transfer records inter-facility movements. Valid values: position|receipt|consumption|adjustment|transfer.',
  `transportation_mode` STRING COMMENT 'Method of fuel transportation for receipt transactions. Rail for coal unit trains, truck for short-haul deliveries, pipeline for natural gas, barge for waterway transport, or ship for international coal imports. Affects delivery costs and supply chain logistics. Valid values: rail|truck|pipeline|barge|ship.',
  `unit_cost` DECIMAL(18,4) COMMENT 'Cost per unit of fuel expressed in dollars per Million British Thermal Units ($/MMBtu). Supports Operations and Maintenance (O&M) cost tracking, Levelized Cost of Energy (LCOE) analysis, and generation dispatch economics. Business-confidential pricing data.',
  `volatile_matter_percent` DECIMAL(6,3) COMMENT 'Volatile matter content of coal as a percentage by weight. Indicates the portion of coal that vaporizes when heated. Affects ignition characteristics, flame stability, and combustion efficiency. Higher volatile matter improves combustion but may increase emissions.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_fuel_inventory` PRIMARY KEY (`fuel_inventory_id`)
)
USING DELTA
COMMENT 'Current and historical fuel inventory positions and receipt transactions for thermal generation facilities. For inventory positions: tracks fuel type (natural gas, coal, nuclear fuel, oil, biomass), inventory quantity (tons, MMBtu, or fuel assemblies), storage location, minimum operating reserve level, days-of-supply, and unit cost ($/MMBtu). For receipt transactions: captures receipt date, quantity received, supplier name, contract reference, invoice number, as-received heat content (BTU/lb or BTU/SCF), sulfur content, moisture content, transportation mode, and unit cost. Supports fuel supply planning, O&M cost tracking, generation availability forecasting, EIA Form 923 reporting, and emissions calculations. SSOT for fuel stock position, receipt transactions, and fuel quality data at generation facilities. | CMM: CIM FossilFuel (broad), IEC61970::Generation::Production.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'FuelInventory',
  'cmm.cim.class' = 'FossilFuel',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61970::Generation::Production',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.fuel_inventory'
);

-- EmissionsReading  <<CIM EmissionAccount : close>>
CREATE TABLE IF NOT EXISTS `generation`.`emissions_reading` (
  `emissions_reading_id` BIGINT NOT NULL COMMENT 'Unique identifier for the emissions reading record. Primary key for the emissions_reading product.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Emissions reporting often aggregates by control area for regional air quality compliance (e.g., RGGI, CAIR). Required for EPA and state environmental reporting.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Emissions compliance costs (allowances, penalties, monitoring) are allocated to cost centers for environmental cost tracking and rate recovery filings.',
  `emissions_generating_unit_id` BIGINT COMMENT 'Foreign key reference to the generating unit that produced this emissions reading. Links to the generation asset registry.',
  `generating_unit_id` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — CEMS monitors are installed on specific generating units (stacks). Without this FK, emissions data cannot be attributed to the unit that produced them, breaking EPA Part 75 compliance reporting.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Each emissions measurement ties to specific regulatory obligations (Clean Air Act, state SIPs, emissions trading programs) for compliance demonstration, allowance tracking, and violation detection. Cr',
  `power_plant_id` BIGINT COMMENT 'Foreign key reference to the generation facility where this emissions reading was recorded. A facility may contain multiple generating units.',
  `primary_generating_unit_id` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — CEMS data is monitored per generating unit (each unit has its own CEMS stack). generating_unit_id is required for EPA Part 75 compliance reporting which is unit-level.',
  `allowance_deduction_required` BOOLEAN COMMENT 'Boolean flag indicating whether emissions allowances must be surrendered for this reading under cap-and-trade compliance programs. True if allowance deduction is required, False if not required or if the unit is exempt.',
  `allowance_quantity_deducted` DECIMAL(12,3) COMMENT 'The quantity of emissions allowances (in tons) deducted from the facility\'s allowance account to cover the emissions recorded in this reading. Only populated for cap-and-trade compliance programs.',
  `allowance_vintage_year` INT COMMENT 'The vintage year of the emissions allowances used to cover this reading. Allowances are typically issued for specific compliance years and may be banked or borrowed across years subject to program rules.',
  `ambient_temperature_f` DECIMAL(6,2) COMMENT 'The ambient air temperature in degrees Fahrenheit at the time of the emissions measurement. Used for temperature correction factors in emissions calculations.',
  `barometric_pressure_inhg` DECIMAL(6,2) COMMENT 'The barometric pressure in inches of mercury (inHg) at the time of the emissions measurement. Used for pressure correction factors in emissions calculations.',
  `carbon_cost_usd` DECIMAL(18,2) COMMENT 'The calculated carbon cost in US dollars associated with this emissions reading, based on allowance market prices or internal carbon pricing. Used for carbon cost accounting and financial planning.',
  `cems_monitor_code` STRING COMMENT 'The unique identifier for the specific CEMS monitor that recorded this reading. Links to the physical monitoring equipment installed on the generating unit.',
  `compliance_program` STRING COMMENT 'The environmental compliance program under which this emissions reading is reported. EPA_ARP (Acid Rain Program), RGGI (Regional Greenhouse Gas Initiative), California_Cap_and_Trade, CSAPR (Cross-State Air Pollution Rule), MATS (Mercury and Air Toxics Standards), State_SIP (State Implementation Plan). Valid values: EPA_ARP|RGGI|California_Cap_and_Trade|CSAPR|MATS|State_SIP.',
  `data_quality_indicator` STRING COMMENT 'Overall data quality indicator for this emissions reading based on QA/QC test results and validation rules. Passed indicates the reading meets all quality standards, failed indicates quality issues, not_available indicates quality assessment is incomplete, conditionally_valid indicates the reading is usable subject to documented conditions. Valid values: passed|failed|not_available|conditionally_valid.',
  `data_source_system` STRING COMMENT 'The name of the source system that provided this emissions reading data. Typically ABB Ability Symphony Plus DCS, OSIsoft PI Historian, or direct CEMS data acquisition system.',
  `emission_rate` DECIMAL(18,6) COMMENT 'The measured emission rate for the pollutant. Units depend on pollutant type and are specified in emission_rate_unit field.',
  `emission_rate_unit` STRING COMMENT 'The unit of measure for the emission rate. Common units include lbs/MMBtu (pounds per million British thermal units), lbs/hr (pounds per hour), tons/hr, kg/MWh (kilograms per megawatt-hour), g/kWh (grams per kilowatt-hour). Valid values: lbs/MMBtu|lbs/hr|tons/hr|kg/MWh|g/kWh.',
  `epa_submission_date` DATE COMMENT 'The date when this emissions reading was submitted to the EPA through ECMPS. Only populated when submitted_to_epa_flag is True.',
  `flow_rate_scfh` DECIMAL(18,3) COMMENT 'The volumetric flow rate of exhaust gas in standard cubic feet per hour (SCFH) at the time of the emissions measurement. Used for total mass emissions calculations.',
  `fuel_type` STRING COMMENT 'The primary fuel type being consumed by the generating unit during this emissions measurement. Used for emissions factor calculations and compliance program categorization. Reference-value candidates: coal|natural_gas|oil|biomass|nuclear|hydro|wind|solar.',
  `gross_load_mw` DECIMAL(12,3) COMMENT 'The gross electrical load output of the generating unit in megawatts (MW) at the time of the emissions measurement. Used for emissions rate calculations and compliance verification.',
  `heat_input_mmbtu` DECIMAL(18,3) COMMENT 'The total heat input to the generating unit in millions of British thermal units (MMBtu) during the measurement period. Used for emissions rate calculations and fuel consumption analysis.',
  `measurement_timestamp` TIMESTAMP COMMENT 'The precise date and time when the emissions measurement was recorded by the CEMS (Continuous Emissions Monitoring System). This is the principal business event timestamp for the reading.',
  `moisture_content_percent` DECIMAL(5,2) COMMENT 'The moisture content percentage in the exhaust gas stream at the time of the emissions measurement. Used for dry-basis emissions rate calculations.',
  `monitor_status` STRING COMMENT 'The operational status of the CEMS monitor at the time of the reading. Operational indicates normal functioning, calibration indicates the monitor was being calibrated, maintenance indicates scheduled maintenance, failed indicates equipment failure, out_of_service indicates the monitor was not in service. Valid values: operational|calibration|maintenance|failed|out_of_service.',
  `operating_hour_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the generating unit was in operation during this measurement hour. True if operating, False if not operating. Used for compliance hour calculations.',
  `operating_mode` STRING COMMENT 'The operating mode of the generating unit at the time of the emissions measurement. Baseload indicates continuous operation, cycling indicates variable operation, peaking indicates high-demand operation, startup/shutdown indicate transitional states, standby indicates ready but not generating. Valid values: baseload|cycling|peaking|startup|shutdown|standby.',
  `orispl_code` STRING COMMENT 'The unique EPA-assigned ORISPL code identifying the power plant facility. This is the standard identifier used in all EPA emissions reporting systems.',
  `oxygen_concentration_percent` DECIMAL(5,2) COMMENT 'The oxygen concentration percentage in the exhaust gas stream at the time of the emissions measurement. Used for combustion efficiency calculations and emissions rate corrections.',
  `pollutant_type` STRING COMMENT 'The type of pollutant measured in this reading. SO2 (Sulfur Dioxide), NOx (Nitrogen Oxides), CO2 (Carbon Dioxide), Hg (Mercury), PM (Particulate Matter), CO (Carbon Monoxide). Valid values: SO2|NOx|CO2|Hg|PM|CO.',
  `qa_certification_status` STRING COMMENT 'The quality assurance and quality control (QA/QC) certification status of this emissions reading. Certified indicates the reading passed all QA/QC tests, provisional indicates temporary certification pending full testing, conditionally_valid indicates the reading is valid subject to conditions, invalid indicates the reading failed QA/QC, pending_certification indicates certification testing is in progress. Valid values: certified|provisional|conditionally_valid|invalid|pending_certification.',
  `qa_test_date` DATE COMMENT 'The date when the most recent QA/QC certification test was performed on the CEMS monitor that recorded this reading. Used to verify data quality and compliance with EPA testing requirements.',
  `record_created_timestamp` TIMESTAMP COMMENT 'The timestamp when this emissions reading record was first created in the system. Used for data lineage and audit trail purposes.',
  `record_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this emissions reading record was last updated in the system. Used for data lineage and audit trail purposes.',
  `reporting_period` STRING COMMENT 'The time period granularity for which this emissions reading is aggregated and reported to regulatory agencies. Hourly is the most granular level required by EPA Part 75. Valid values: hourly|daily|monthly|quarterly|annual.',
  `reporting_quarter` INT COMMENT 'The calendar quarter (1-4) in which this emissions reading occurred. Used for quarterly compliance reporting aggregation.',
  `reporting_year` INT COMMENT 'The calendar year in which this emissions reading occurred. Used for annual compliance reporting and allowance reconciliation.',
  `stack_code` STRING COMMENT 'The unique identifier for the exhaust stack or flue where the CEMS monitor is installed and from which emissions are measured. A single stack may serve multiple generating units.',
  `submitted_to_epa_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this emissions reading has been submitted to the EPA through the Emissions Collection and Monitoring Plan System (ECMPS). True if submitted, False if not yet submitted.',
  `substitute_data_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this reading is substitute data rather than actual measured data. True if substitute data was used due to monitor downtime or failure, False if actual measured data. Substitute data is calculated using EPA-approved methodologies.',
  `substitute_data_method` STRING COMMENT 'The EPA-approved methodology used to calculate substitute data when actual CEMS measurements are unavailable. Only populated when substitute_data_flag is True. Valid values: maximum_potential_concentration|maximum_potential_flow_rate|fuel_sampling|default_high_range|missing_data_procedure.',
  `total_mass_emissions` DECIMAL(18,3) COMMENT 'The total mass of pollutant emitted during the measurement period, calculated from emission rate and operating time. Units are typically pounds (lbs) or tons depending on pollutant type and reporting requirements.',
  `total_mass_emissions_unit` STRING COMMENT 'The unit of measure for total mass emissions. Common units include lbs (pounds), tons (short tons), kg (kilograms), metric_tons. Valid values: lbs|tons|kg|metric_tons.',
  `unit_type` STRING COMMENT 'The type of generating unit technology that produced this emissions reading. Used for emissions factor selection and compliance program applicability determination. Valid values: boiler|combustion_turbine|combined_cycle|reciprocating_engine|fuel_cell.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_emissions_reading` PRIMARY KEY (`emissions_reading_id`)
)
USING DELTA
COMMENT 'Continuous Emissions Monitoring System (CEMS) data and emissions allowance registry records for generating units subject to environmental compliance programs. For CEMS data: captures measurement timestamp, pollutant type (SO2, NOx, CO2, Hg, PM), measured emission rate (lbs/MMBtu or lbs/hr), gross load, operating hour flag, CEMS monitor status, substitute data flag, and QA/QC certification status. For allowances: captures allowance type, vintage year, quantity (tons), program (EPA ARP, RGGI, California Cap-and-Trade), acquisition date/cost, account balance, and transfer history. Required for EPA Part 75 compliance, cap-and-trade program compliance, and carbon cost accounting. SSOT for generation emissions monitoring and allowance management. | CMM: CIM EmissionAccount (close), IEC61970::Generation::Production.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'EmissionsReading',
  'cmm.cim.class' = 'EmissionAccount',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Generation::Production',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.emissions_reading'
);

-- GenerationOutageEvent  <<CIM Outage : close>>
CREATE TABLE IF NOT EXISTS `generation`.`outage_event` (
  `outage_event_id` BIGINT NOT NULL COMMENT 'Unique identifier for the generation outage event record. Primary key for the generation outage event entity.',
  `capex_project_id` BIGINT COMMENT 'Foreign key linking to finance.capex_project. Business justification: Major outages often tie to capital projects (turbine overhauls, emissions upgrades). Critical for capitalization decisions, AFUDC calculations, and distinguishing capital vs expense.',
  `contingency_id` BIGINT COMMENT 'Foreign key linking to grid.contingency. Business justification: Forced outages are modeled as N-1 contingencies in reliability analysis. Required for NERC TPL standards and real-time contingency analysis.',
  `contingency_violation_id` BIGINT COMMENT 'Foreign key linking to grid.contingency_violation. Business justification: Generation outages cause contingency violations (loss of largest unit). Required for NERC TPL standards and operating reserve adequacy assessment.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Outages impact control area reserve margins and must be reported to balancing authority for resource adequacy assessment and contingency reserve deployment.',
  `corrective_action_plan_id` BIGINT COMMENT 'Identifier of the corrective action plan developed to prevent recurrence of similar outages. Links to the quality management or asset management system. Null if no corrective action plan is required.',
  `emergency_purchase_order_id` BIGINT COMMENT 'Foreign key linking to supply.purchase_order. Business justification: Forced outages trigger expedited material purchases (replacement parts, contractor services). Outage cost tracking requires linking to emergency POs for financial reconciliation and NERC GADS reportin',
  `emergency_stock_event_id` BIGINT COMMENT 'Foreign key linking to supply.emergency_stock_event. Business justification: Major forced outages trigger emergency stock mobilization (mutual aid, expedited procurement). Storm restoration and NERC event reporting require linking outage events to emergency stock events for co',
  `ems_alarm_id` BIGINT COMMENT 'Foreign key linking to grid.ems_alarm. Business justification: Generation outages trigger EMS alarms for operator notification. Required for real-time situational awareness and reserve deployment.',
  `energy_schedule_id` BIGINT COMMENT 'Foreign key linking to trading.energy_schedule. Business justification: Forced outages trigger schedule curtailments and re-tagging. Critical operational workflow linking outage notifications to schedule adjustments and ISO curtailment instructions.',
  `generating_unit_id` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — Every outage event occurs on a specific generating unit. Without this FK, outage records cannot be linked to units, breaking NERC GADS reporting and availability analysis (EAF, EFOR).',
  `goods_issue_id` BIGINT COMMENT 'Foreign key linking to supply.goods_issue. Business justification: Materials issued from inventory for outage repairs are documented via goods issues. Work order material tracking requires linking outage events to goods issues for cost accounting and inventory reconc',
  `grid_reliability_event_id` BIGINT COMMENT 'Foreign key linking to grid.grid_reliability_event. Business justification: Forced generation outages can trigger or constitute NERC reportable reliability events (EOP-004). Required for NERC OE-417 reporting and root cause analysis.',
  `grid_switching_order_id` BIGINT COMMENT 'Foreign key linking to grid.grid_switching_order. Business justification: Planned outages require switching orders for isolation. Required for outage coordination and safe work clearance.',
  `operator_log_id` BIGINT COMMENT 'Foreign key linking to grid.operator_log. Business justification: Generation outages are logged by operators for real-time situational awareness and NERC reporting. Required for EOP-004 and shift handoff documentation.',
  `outage_generating_unit_id` BIGINT COMMENT 'Identifier of the generation unit (turbine, boiler, generator set) affected by the outage event. Links to the generation unit asset registry.',
  `power_plant_id` BIGINT COMMENT 'Identifier of the generation plant or facility where the outage occurred. Links to the plant asset registry.',
  `primary_generating_unit_id` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — Outage events occur at the generating unit level. generating_unit_id is required for NERC GADS reporting, capacity planning, and EFOR calculations.',
  `primary_outage_employee_id` BIGINT COMMENT 'User identifier of the person or system that created the outage event record. Used for audit trail and accountability.',
  `protection_event_id` BIGINT COMMENT 'Foreign key linking to grid.protection_event. Business justification: Generation outages often result from protection relay operations. Required for NERC PRC-004 compliance and root cause determination.',
  `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: Major outages require regulatory notification per NERC EOP standards and state PUC reporting requirements. Essential for reliability reporting, prudence demonstration in rate cases, and regulatory com',
  `responsible_crew_id` BIGINT COMMENT 'Identifier of the maintenance crew or team responsible for outage work and unit restoration. Links to workforce management system.',
  `transmission_outage_id` BIGINT COMMENT 'Foreign key linking to transmission.transmission_outage. Business justification: Generation outages often cause or correlate with transmission outages (equipment failures, protection system operations, cascading events). NERC reliability coordination and root cause analysis requir',
  `work_order_id` BIGINT COMMENT 'Identifier of the maintenance work order associated with the outage event. Links to the asset management work order system for tracking repair activities, labor, and materials.',
  `capacity_lost_mw` DECIMAL(10,3) COMMENT 'Amount of generation capacity (in Megawatts) unavailable due to the outage. For full outages, this equals the unit nameplate capacity. For deratings, this is the reduction amount. Critical for NERC GADS EAF and EFOR calculations.',
  `cause_description` STRING COMMENT 'Detailed narrative description of the outage root cause, failure mode, and contributing factors. Supplements the NERC GADS cause code with plant-specific context.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the outage event record was first created in the system. Used for audit trail and data lineage tracking.',
  `environmental_incident_flag` BOOLEAN COMMENT 'Indicates whether the outage resulted in or was caused by an environmental incident (emissions exceedance, spill, discharge violation). True if environmental incident occurred. False otherwise. Triggers EPA reporting workflow.',
  `equipment_component_code` STRING COMMENT 'Code identifying the specific equipment component or system that failed or required maintenance. Examples: turbine blade, boiler tube, generator exciter, condenser, cooling tower. Aligns with plant equipment hierarchy.',
  `equipment_component_description` STRING COMMENT 'Detailed description of the equipment component affected by the outage, including location within the unit and technical specifications.',
  `estimated_repair_cost_usd` DECIMAL(15,2) COMMENT 'Estimated cost in US Dollars for outage-related repairs, parts replacement, and labor. Includes direct maintenance costs but excludes revenue loss. Used for O&M budget tracking.',
  `estimated_return_to_service_timestamp` TIMESTAMP COMMENT 'Projected date and time when the unit is expected to return to service. Updated as outage work progresses. Used for generation scheduling and market commitment planning.',
  `estimated_revenue_loss_usd` DECIMAL(15,2) COMMENT 'Estimated revenue loss in US Dollars due to the outage, calculated based on lost generation capacity, market prices, and outage duration. Used for financial impact analysis and IRP planning.',
  `forced_outage_rate_impact_flag` BOOLEAN COMMENT 'Indicates whether this outage event impacts the unit Equivalent Forced Outage Rate (EFOR) calculation. True for forced outages and unplanned deratings. False for planned maintenance.',
  `fuel_type` STRING COMMENT 'Primary fuel type of the generation unit affected by the outage. Used for fuel-specific outage analysis and generation fleet planning. Reference-value candidates: coal|natural_gas|nuclear|hydro|wind|solar|biomass|oil.',
  `grid_impact_severity` STRING COMMENT 'Assessment of the outage impact on grid reliability and system operations. Critical: caused or contributed to grid emergency. Major: significant capacity loss during peak demand. Moderate: noticeable but manageable. Minor: minimal impact. None: no grid impact. Valid values: none|minor|moderate|major|critical.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the outage event record was last updated. Used for audit trail and change tracking. Updated whenever any attribute is modified.',
  `market_commitment_impact_flag` BOOLEAN COMMENT 'Indicates whether the outage caused the unit to fail to meet day-ahead or real-time market commitments. True if the outage resulted in market penalties or buy-back costs. False if no market impact.',
  `nerc_gads_cause_code` STRING COMMENT 'Standardized NERC GADS cause code identifying the root cause of the outage. Four-character alphanumeric code from the NERC GADS cause code taxonomy. Mandatory for NERC GADS reporting submissions.',
  `nerc_gads_reportable_flag` BOOLEAN COMMENT 'Indicates whether this outage event must be reported to NERC GADS. True if the outage meets NERC GADS reporting thresholds (duration, capacity, or cause criteria). False for minor events below reporting thresholds.',
  `nerc_gads_submission_date` DATE COMMENT 'Date when the outage event data was submitted to NERC GADS. Null if not yet submitted or not reportable. Used for regulatory compliance tracking.',
  `outage_duration_hours` DECIMAL(10,2) COMMENT 'Total duration of the outage in hours, calculated as the difference between outage end and start timestamps. Null if outage is still active. Used for NERC GADS availability metrics and maintenance planning.',
  `outage_end_timestamp` TIMESTAMP COMMENT 'Date and time when the generation unit returned to service and was synchronized to the grid. Null if outage is still active. Used to calculate outage duration and unit availability metrics.',
  `outage_event_number` STRING COMMENT 'Business identifier for the outage event, typically assigned by the plant operations or outage management system. Used for external reporting and cross-system reference.',
  `outage_notes` STRING COMMENT 'Free-text field for additional outage details, operational context, lessons learned, and cross-functional coordination notes. Used for knowledge capture and future reference.',
  `outage_priority` STRING COMMENT 'Business priority level for outage resolution. Critical: immediate grid reliability impact. High: significant capacity loss. Medium: moderate impact. Low: minimal impact or planned maintenance. Valid values: critical|high|medium|low.',
  `outage_season` STRING COMMENT 'Season during which the outage occurred. Used for seasonal outage pattern analysis and maintenance planning optimization. Valid values: winter|spring|summer|fall.',
  `outage_start_timestamp` TIMESTAMP COMMENT 'Date and time when the generation unit outage began. For forced outages, this is the trip or shutdown time. For planned outages, this is the scheduled start time. Critical for NERC GADS reporting and availability calculations.',
  `outage_status` STRING COMMENT 'Current lifecycle status of the outage event. Active: outage is ongoing. Completed: unit returned to service. Cancelled: planned outage was cancelled. Extended: outage duration was extended beyond original estimate. Valid values: active|completed|cancelled|extended.',
  `outage_type` STRING COMMENT 'Classification of the outage event. Forced: unplanned immediate shutdown. Planned: scheduled in advance. Maintenance: scheduled preventive or corrective work. Derating: partial capacity reduction. Seasonal: planned seasonal shutdown. Valid values: forced|planned|maintenance|derating|seasonal.',
  `root_cause_analysis_completed_flag` BOOLEAN COMMENT 'Indicates whether a formal root cause analysis (RCA) has been completed for the outage event. True if RCA is complete. False if pending or not required. Used for continuous improvement tracking.',
  `rto_iso_notification_timestamp` TIMESTAMP COMMENT 'Date and time when the RTO or ISO was notified of the outage event. Required for forced outages and deratings per market rules. Used for compliance verification.',
  `safety_incident_flag` BOOLEAN COMMENT 'Indicates whether the outage involved a worker safety incident (injury, near-miss, OSHA recordable event). True if safety incident occurred. False otherwise. Triggers OSHA reporting workflow.',
  `unit_nameplate_capacity_mw` DECIMAL(10,3) COMMENT 'Maximum rated generation capacity of the unit in Megawatts. Denormalized from unit master data for outage analysis and capacity planning calculations.',
  `weather_related_flag` BOOLEAN COMMENT 'Indicates whether the outage was caused or exacerbated by weather conditions (extreme temperature, lightning, wind, ice, flooding). True if weather was a contributing factor. False otherwise.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_outage_event` PRIMARY KEY (`outage_event_id`)
)
USING DELTA
COMMENT 'Records of planned and unplanned generation outage events at the unit level. Captures outage start and end timestamps, outage type (forced, planned, maintenance, derating), capacity lost (MW), cause code (NERC GADS cause code), equipment component affected, responsible crew, estimated return-to-service date, actual return-to-service date, and NERC GADS reporting flag. Feeds NERC GADS submissions, generation availability analysis (EAF, EFOR), and IRP capacity planning. SSOT for generation unit outage history. | CMM: CIM Outage (close), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'GenerationOutageEvent',
  'cmm.cim.class' = 'Outage',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.outage_event'
);

-- StartupEvent  <<CIM StartupModel : broad>>
CREATE TABLE IF NOT EXISTS `generation`.`startup_event` (
  `startup_event_id` BIGINT NOT NULL COMMENT 'Unique identifier for the generating unit startup event. Primary key for the startup_event product.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Startups affect control area generation availability and reserve margins. Required for real-time unit status tracking and reserve adequacy monitoring.',
  `dispatch_schedule_id` BIGINT COMMENT 'Reference to the specific dispatch instruction or unit commitment order that initiated the startup. Links to energy management system (EMS) dispatch records.',
  `employee_id` BIGINT COMMENT 'Identifier of the control room operator or automated system that initiated the startup sequence. Used for training analysis and human factors review.',
  `ems_alarm_id` BIGINT COMMENT 'Foreign key linking to grid.ems_alarm. Business justification: Startup failures trigger EMS alarms for operator intervention. Required for unit availability tracking and commitment compliance.',
  `environmental_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.environmental_permit. Business justification: Startups trigger specific permit conditions including startup emissions limits, notification requirements, and excess emissions reporting. Critical for permit compliance tracking, exceedance detection',
  `event_id` BIGINT COMMENT 'Reference to the preceding outage event that this startup terminates. Links to NERC GADS outage reporting for cause code correlation and availability analysis.',
  `frequency_event_id` BIGINT COMMENT 'Foreign key linking to grid.frequency_event. Business justification: Startups can trigger or respond to frequency events (black start capability, primary frequency response). Required for NERC BAL-003 and EOP-005 compliance.',
  `generating_unit_id` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — Every startup event occurs on a specific generating unit. Without this FK, startup cost tracking and hot/warm/cold analysis cannot be attributed to units.',
  `grid_reliability_event_id` BIGINT COMMENT 'Foreign key linking to grid.grid_reliability_event. Business justification: Generator startups during system restoration are part of reliability event response (black start). Required for NERC EOP-005 compliance and restoration reporting.',
  `grid_switching_order_id` BIGINT COMMENT 'Foreign key linking to grid.grid_switching_order. Business justification: Generator startups require switching orders for synchronization. Required for safe energization and breaker coordination.',
  `market_commitment_id` BIGINT COMMENT 'Reference to the day-ahead market (DAM) or real-time market (RTM) commitment that triggered this startup. Links to energy trading system for settlement reconciliation.',
  `operator_log_id` BIGINT COMMENT 'Foreign key linking to grid.operator_log. Business justification: Generator startups are logged by control room operators for shift turnover and event reconstruction. Required for NERC compliance evidence and operational audits.',
  `power_plant_id` BIGINT COMMENT 'Reference to the generation facility where the startup event occurred. Links to the plant master registry.',
  `primary_generating_unit_id` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — Startup events occur on specific generating units. Without this FK, startup cost and performance data cannot be attributed to the unit. Critical for O&M cost tracking.',
  `startup_consumables_material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: Startups consume specific materials (startup fuel, chemicals, lubricants) tracked in material master. Startup cost accounting requires linking material consumption to events for accurate cost-per-star',
  `startup_generating_unit_id` BIGINT COMMENT 'Reference to the specific generating unit (turbine, boiler, generator set) that underwent the startup event. Links to the generation asset registry.',
  `actual_load_achieved_mw` DECIMAL(10,2) COMMENT 'Actual generation output in megawatts (MW) achieved at the end of the startup ramp phase. Used to assess startup performance against target and market commitment.',
  `ambient_temperature_f` DECIMAL(5,2) COMMENT 'Ambient air temperature in degrees Fahrenheit at startup initiation. Impacts startup duration, fuel consumption, and unit performance for combustion turbines and combined cycle units.',
  `auxiliary_power_consumption_mwh` DECIMAL(10,3) COMMENT 'Station service and auxiliary equipment power consumption during startup measured in megawatt-hours (MWh). Includes boiler feed pumps, fans, cooling systems, and control systems.',
  `completion_timestamp` TIMESTAMP COMMENT 'Timestamp when the startup event was formally closed in the operational system. May differ from full_load_timestamp if post-startup validation or stabilization is required.',
  `control_mode` STRING COMMENT 'Operating mode during startup: automatic (DCS-controlled sequence), manual (operator-driven), remote (dispatch center control), or test (commissioning mode). Valid values: automatic|manual|remote|test.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this startup event record was first created in the system. Audit trail for data lineage and regulatory compliance.',
  `data_source_system` STRING COMMENT 'Identifier of the source system that provided this startup event data. Typically ABB Ability Symphony Plus (DCS), OSIsoft PI (historian), or manual entry system. Supports data lineage and reconciliation.',
  `emissions_co2_tons` DECIMAL(10,3) COMMENT 'Total carbon dioxide emissions during the startup event measured in short tons. Required for EPA greenhouse gas reporting and carbon compliance tracking.',
  `emissions_nox_lbs` DECIMAL(10,3) COMMENT 'Total nitrogen oxides emissions during the startup event measured in pounds. Critical for air quality permit compliance and emissions allowance tracking.',
  `emissions_so2_lbs` DECIMAL(10,3) COMMENT 'Total sulfur dioxide emissions during the startup event measured in pounds. Required for acid rain program compliance and state implementation plan (SIP) reporting.',
  `failure_description` STRING COMMENT 'Detailed narrative description of the failure or abort condition for unsuccessful startup events. Supports root cause analysis and corrective action tracking.',
  `failure_reason_code` STRING COMMENT 'Primary cause code for failed or aborted startup events. Maps to NERC GADS cause codes for reliability reporting. Set to \'none\' for successful startups. Reference-value candidates: equipment_malfunction|fuel_supply_issue|grid_constraint|operator_error|environmental_limit|control_system_fault|none.',
  `fuel_type` STRING COMMENT 'Primary fuel type used during the startup event. May differ from unit\'s primary fuel for dual-fuel units that use oil or gas for startup. Reference-value candidates: natural_gas|coal|nuclear|hydro|wind|solar|biomass|oil|dual_fuel.',
  `full_load_timestamp` TIMESTAMP COMMENT 'Timestamp when the generating unit reached its committed or maximum continuous rating (MCR). Marks completion of the startup ramp phase.',
  `initiation_timestamp` TIMESTAMP COMMENT 'Timestamp when the startup sequence was initiated (first ignition or turbine roll command issued). Marks the beginning of the startup event for duration and cost tracking.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this startup event record was last updated. Tracks data changes for audit trail and data quality monitoring.',
  `nerc_gads_reported_flag` BOOLEAN COMMENT 'Boolean indicator of whether this startup event has been reported to NERC Generating Availability Data System (GADS). Required for failed startups and startups following forced outages.',
  `notes` STRING COMMENT 'Free-text operational notes and observations recorded by control room operators during the startup event. Captures non-standard conditions, equipment behavior, and operational context.',
  `previous_shutdown_timestamp` TIMESTAMP COMMENT 'Timestamp of the preceding unit shutdown event. Used to calculate unit_offline_hours and determine thermal state for startup type classification.',
  `ramp_duration_minutes` DECIMAL(10,2) COMMENT 'Elapsed time in minutes from synchronization to full load. Measures the load ramping phase performance and flexibility capability.',
  `scada_data_quality_flag` STRING COMMENT 'Quality indicator for SCADA telemetry data captured during the startup event. Good indicates validated real-time data, estimated indicates gap-filled data, manual indicates operator-entered values, missing indicates data loss. Valid values: good|estimated|manual|missing.',
  `startup_cost_usd` DECIMAL(12,2) COMMENT 'Total direct cost of the startup event in US dollars, including fuel cost, auxiliary power, consumables, and incremental wear. Used for market offer development, unit commitment optimization, and O&M cost tracking.',
  `startup_duration_minutes` DECIMAL(10,2) COMMENT 'Total elapsed time in minutes from initiation to synchronization. Used for heat rate degradation analysis, unit commitment optimization, and startup cost curve calibration.',
  `startup_event_number` STRING COMMENT 'Business identifier for the startup event, typically formatted as PLANT-YYYYMMDD-SEQN. Used for operational tracking and NERC GADS reporting. Pattern: ^[A-Z0-9]{3,4}-[0-9]{8}-[0-9]{4}$.',
  `startup_fuel_consumed_mmbtu` DECIMAL(12,2) COMMENT 'Total fuel energy consumed during the startup event measured in million British thermal units (MMBtu). Includes ignition fuel, warm-up fuel, and ramp fuel. Critical for startup cost calculation and heat rate analysis.',
  `startup_fuel_cost_per_mmbtu` DECIMAL(10,4) COMMENT 'Unit fuel cost in USD per MMBtu applied to the startup fuel consumption. May differ from normal operating fuel cost if startup uses premium fuel (e.g., distillate oil).',
  `startup_heat_rate_btu_per_kwh` DECIMAL(10,2) COMMENT 'Effective heat rate during the startup event calculated as total fuel consumed (Btu) divided by net energy generated (kWh). Significantly higher than normal operating heat rate; used for startup cost curve calibration.',
  `startup_reason_code` STRING COMMENT 'Primary business reason for initiating the startup event. Economic dispatch indicates market-driven startup, reliability indicates grid stability requirement, test indicates commissioning or post-maintenance validation. Valid values: economic_dispatch|reliability_must_run|scheduled_maintenance_return|test_startup|market_commitment|reserve_activation.',
  `startup_status` STRING COMMENT 'Current lifecycle status of the startup event. Tracks progression from initiation through synchronization, load ramping, to completion or failure. Valid values: initiated|synchronizing|ramping|completed|failed|aborted.',
  `startup_success_flag` BOOLEAN COMMENT 'Boolean indicator of whether the startup event completed successfully (true) or failed/aborted (false). Failed startups trigger root cause analysis and NERC GADS event reporting.',
  `startup_type` STRING COMMENT 'Classification of startup based on unit offline duration and temperature: hot (< 8 hours offline), warm (8-72 hours), cold (> 72 hours), emergency (unplanned reliability startup). Determines startup cost curve and duration expectations. Valid values: hot|warm|cold|emergency.',
  `synchronization_timestamp` TIMESTAMP COMMENT 'Timestamp when the generating unit was synchronized to the grid (breaker closed, unit online). Critical milestone for market settlement and reliability reporting.',
  `target_load_mw` DECIMAL(10,2) COMMENT 'Committed or target generation output in megawatts (MW) for this startup event. Represents the dispatch instruction or market commitment level.',
  `unit_offline_hours` DECIMAL(10,2) COMMENT 'Total hours the generating unit was offline prior to this startup event. Primary determinant of startup type classification (hot/warm/cold) and expected startup duration.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_startup_event` PRIMARY KEY (`startup_event_id`)
)
USING DELTA
COMMENT 'Transactional record of each generating unit startup event, capturing startup type (hot/warm/cold), initiation timestamp, synchronization timestamp, full-load timestamp, startup fuel consumed (MMBtu), startup cost ($), startup duration (minutes), reason for startup (economic dispatch, reliability, test), and success/failure outcome. Feeds NERC GADS event reporting (cause code linkage to outage_event), O&M cost tracking, heat rate degradation analysis, and unit commitment optimization models. Supports startup cost curve calibration for day-ahead market offers. | CMM: CIM StartupModel (broad), IEC61970::Generation::Production.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'StartupEvent',
  'cmm.cim.class' = 'StartupModel',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61970::Generation::Production',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.startup_event'
);

-- CapacityPlan  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `generation`.`capacity_plan` (
  `capacity_plan_id` BIGINT NOT NULL COMMENT 'Unique identifier for the generation capacity plan record. Primary key for the capacity planning entity supporting Integrated Resource Plan (IRP) analysis and regulatory submissions.',
  `capacity_obligation_id` BIGINT COMMENT 'Foreign key linking to trading.capacity_obligation. Business justification: Capacity expansion plans are driven by ISO capacity obligations and must demonstrate how they satisfy them. Essential for IRP filings and capacity procurement planning.',
  `capacity_power_plant_id` BIGINT COMMENT 'FK to generation.power_plant.power_plant_id — Capacity plans reference existing and planned generation facilities for IRP modeling. power_plant_id links planned additions/retirements to specific facilities.',
  `capex_project_id` BIGINT COMMENT 'Foreign key linking to finance.capex_project. Business justification: Capacity plans drive capital project portfolios (new builds, retirements). Essential for IRP-to-budget alignment, CPCN filings, and multi-year capital planning.',
  `capital_project_id` BIGINT COMMENT 'Foreign key linking to asset.capital_project. Business justification: Capacity plans (IRP filings) identify specific capital projects for new generation capacity, retirements, or upgrades. Linking plans to projects enables tracking of planned vs. actual capex, regulator',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Capacity planning scenarios model control area peak demand, reserve margins, and resource adequacy. Required for IRP filings and NERC long-term reliability assessments.',
  `dr_program_id` BIGINT COMMENT 'Foreign key linking to demand.dr_program. Business justification: Integrated resource plans explicitly model demand response programs as capacity resources. IRP filings to PUCs require quantifying DR contributions to reserve margins and peak demand reduction. Essent',
  `irp_filing_id` BIGINT COMMENT 'Reference to the parent Integrated Resource Plan document under which this capacity plan was developed. Links to the overarching IRP submission cycle.',
  `peak_demand_id` BIGINT COMMENT 'Foreign key linking to forecast.peak_demand. Business justification: Capacity plans are driven by peak demand forecasts to determine required capacity additions and reserve margins. Core input for IRP filings, capacity market participation, and generation investment de',
  `power_plant_id` BIGINT COMMENT 'FK to generation.power_plant.power_plant_id — IRP capacity plans reference existing and planned generation facilities. This link enables traceability from planning scenarios to the physical fleet. Medium confidence because capacity plans may also',
  `renewable_interconnection_queue_id` BIGINT COMMENT 'Foreign key linking to renewable.interconnection_queue. Business justification: Capacity planning incorporates projects in the interconnection queue to forecast future renewable supply and assess transmission upgrade needs. IRP teams track queue positions to model realistic comme',
  `rps_obligation_id` BIGINT COMMENT 'Foreign key linking to renewable.rps_obligation. Business justification: Integrated resource planning (IRP) must model renewable capacity additions to meet state RPS mandates. Planners link capacity plans to specific RPS obligations to demonstrate compliance pathways, opti',
  `transmission_planning_study_id` BIGINT COMMENT 'Foreign key linking to transmission.planning_study. Business justification: Generation capacity expansion plans must reference transmission planning studies to demonstrate deliverability and grid adequacy. IRP filings cite transmission studies showing new generation can be re',
  `capacity_shortfall_surplus_mw` DECIMAL(12,3) COMMENT 'Projected capacity shortfall (negative value) or surplus (positive value) in megawatts (MW) after accounting for demand, reserve margin requirements, additions, and retirements.',
  `carbon_intensity_kg_per_mwh` DECIMAL(10,3) COMMENT 'Projected carbon intensity in kilograms of carbon dioxide equivalent per megawatt-hour (kg CO2e/MWh), representing emissions per unit of energy generated.',
  `created_by_user` STRING COMMENT 'User identifier or name of the person who created this capacity plan record, supporting accountability and audit requirements.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this capacity plan record was first created in the system, supporting audit trail and data lineage requirements.',
  `der_capacity_additions_mw` DECIMAL(12,3) COMMENT 'Subset of planned capacity additions in megawatts (MW) from Distributed Energy Resources (DER) including rooftop solar, community solar, and Behind the Meter (BTM) generation.',
  `existing_capacity_mw` DECIMAL(12,3) COMMENT 'Total installed generation capacity in megawatts (MW) from existing generation fleet at the start of the planning horizon, before planned additions or retirements.',
  `ferc_submission_date` DATE COMMENT 'Date when this capacity plan was submitted to the Federal Energy Regulatory Commission (FERC) for review and approval, if applicable for interstate transmission planning.',
  `fossil_capacity_additions_mw` DECIMAL(12,3) COMMENT 'Subset of planned capacity additions in megawatts (MW) from conventional fossil fuel sources including Combined Cycle Gas Turbine (CCGT), coal, and simple cycle gas turbines.',
  `fossil_capex_estimate_million` DECIMAL(15,2) COMMENT 'Subset of total CAPEX in millions of dollars allocated to conventional fossil fuel capacity additions for the planning horizon year.',
  `fossil_lcoe_per_mwh` DECIMAL(10,2) COMMENT 'Average Levelized Cost of Energy (LCOE) in dollars per megawatt-hour ($/MWh) for conventional fossil fuel capacity additions in the planning horizon year.',
  `last_modified_by_user` STRING COMMENT 'User identifier or name of the person who last modified this capacity plan record, supporting accountability and audit requirements.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this capacity plan record was last updated or modified, supporting audit trail and change tracking requirements.',
  `net_capacity_change_mw` DECIMAL(12,3) COMMENT 'Net change in generation capacity in megawatts (MW) for the planning horizon year, calculated as planned additions minus planned retirements.',
  `nuclear_capacity_additions_mw` DECIMAL(12,3) COMMENT 'Subset of planned capacity additions in megawatts (MW) from nuclear generation facilities, including new builds and uprates of existing plants.',
  `plan_name` STRING COMMENT 'Business-friendly name or title for this capacity plan scenario, used for identification in regulatory filings and internal planning documents.',
  `plan_status` STRING COMMENT 'Current lifecycle status of the capacity plan within the regulatory approval and internal governance process. Reference-value candidates: draft|under_review|approved|submitted_to_puc|submitted_to_ferc|final|superseded.',
  `plan_version_number` INT COMMENT 'Version number of this capacity plan, incremented with each revision or update to track changes over the planning and approval lifecycle.',
  `planned_capacity_additions_mw` DECIMAL(12,3) COMMENT 'Total new generation capacity in megawatts (MW) planned to be added during the planning horizon year across all generation technologies.',
  `planned_capacity_retirements_mw` DECIMAL(12,3) COMMENT 'Total generation capacity in megawatts (MW) planned to be retired or decommissioned during the planning horizon year due to age, economics, or environmental regulations.',
  `planning_assumptions_summary` STRING COMMENT 'Summary of key planning assumptions used in developing this capacity plan, including demand growth rates, fuel price forecasts, technology cost assumptions, and policy scenarios.',
  `planning_horizon_year` INT COMMENT 'Target year for which this capacity plan projects generation resource needs, typically ranging from 1 to 20 years into the future.',
  `projected_carbon_emissions_tons` DECIMAL(15,2) COMMENT 'Projected annual carbon dioxide equivalent emissions in metric tons (CO2e) from the generation fleet for the planning horizon year, used for environmental compliance and carbon reduction planning.',
  `projected_energy_demand_gwh` DECIMAL(15,3) COMMENT 'Forecasted annual energy consumption in gigawatt-hours (GWh) for the planning horizon year, representing total electricity usage over the year.',
  `projected_peak_demand_mw` DECIMAL(12,3) COMMENT 'Forecasted peak electricity demand in megawatts (MW) for the planning horizon year, representing the maximum instantaneous load the system must serve.',
  `puc_submission_date` DATE COMMENT 'Date when this capacity plan was submitted to the state Public Utility Commission (PUC) for review and approval as part of the IRP filing process.',
  `regulatory_approval_date` DATE COMMENT 'Date when this capacity plan received formal approval from the relevant regulatory authority (PUC or FERC), authorizing execution of the planned capacity changes.',
  `reliability_index_target` DECIMAL(8,4) COMMENT 'Target reliability index metric (e.g., Loss of Load Expectation - LOLE, Loss of Load Probability - LOLP) for the planning horizon year, representing acceptable risk of capacity shortfall.',
  `renewable_capacity_additions_mw` DECIMAL(12,3) COMMENT 'Subset of planned capacity additions in megawatts (MW) from renewable energy sources including wind, solar, hydro, and biomass to meet Renewable Portfolio Standard (RPS) requirements.',
  `renewable_capex_estimate_million` DECIMAL(15,2) COMMENT 'Subset of total CAPEX in millions of dollars allocated to renewable energy capacity additions for the planning horizon year.',
  `renewable_lcoe_per_mwh` DECIMAL(10,2) COMMENT 'Average Levelized Cost of Energy (LCOE) in dollars per megawatt-hour ($/MWh) for renewable capacity additions in the planning horizon year.',
  `renewable_portfolio_percent` DECIMAL(5,2) COMMENT 'Projected percentage of total generation capacity from renewable energy sources for the planning horizon year, used to track compliance with Renewable Portfolio Standard (RPS) requirements.',
  `required_reserve_margin_percent` DECIMAL(5,2) COMMENT 'Minimum planning reserve margin percentage required to maintain system reliability, calculated as excess capacity above peak demand divided by peak demand.',
  `risk_assessment_summary` STRING COMMENT 'Summary of identified risks and uncertainties associated with this capacity plan, including demand forecast risk, technology performance risk, regulatory risk, and market risk.',
  `scenario_name` STRING COMMENT 'Name of the planning scenario or case (e.g., Base Case, High Growth, Low Carbon, Accelerated Renewables) representing different demand and policy assumptions.',
  `scenario_type` STRING COMMENT 'Classification of the planning scenario type used for capacity modeling and resource adequacy analysis. Reference-value candidates: base_case|high_growth|low_growth|high_renewable|low_carbon|regulatory_compliance|sensitivity.',
  `storage_capacity_additions_mw` DECIMAL(12,3) COMMENT 'Subset of planned capacity additions in megawatts (MW) from energy storage systems including battery storage, pumped hydro, and other storage technologies.',
  `total_capex_estimate_million` DECIMAL(15,2) COMMENT 'Total estimated capital expenditure in millions of dollars for all planned capacity additions in the planning horizon year, including construction, interconnection, and Balance of System (BOS) costs.',
  `weighted_average_lcoe_per_mwh` DECIMAL(10,2) COMMENT 'Weighted average Levelized Cost of Energy (LCOE) in dollars per megawatt-hour ($/MWh) across all planned capacity additions, representing the lifetime cost per unit of energy produced.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_capacity_plan` PRIMARY KEY (`capacity_plan_id`)
)
USING DELTA
COMMENT 'Long-range generation capacity planning records supporting the Integrated Resource Plan (IRP). Captures planning horizon year, scenario name, projected peak demand (MW), required reserve margin (%), planned new capacity additions (MW by technology), planned retirements (MW), capacity shortfall or surplus (MW), CAPEX estimate ($M), LCOE by technology ($/MWh), and regulatory submission status (PUC/FERC). Supports resource adequacy analysis, technology selection, and regulatory rate case filings. SSOT for IRP capacity modeling and generation fleet planning. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CapacityPlan',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.capacity_plan'
);

-- AncillaryServiceOffer  <<CIM ResourceBid : close>>
CREATE TABLE IF NOT EXISTS `generation`.`ancillary_service_offer` (
  `ancillary_service_offer_id` BIGINT NOT NULL COMMENT 'Unique identifier for the ancillary service offer record. Primary key for this entity.',
  `ancillary_generating_unit_id` BIGINT COMMENT 'Identifier of the generating unit submitting the ancillary service offer. Links to the generation asset registry.',
  `ancillary_service_award_id` BIGINT COMMENT 'Foreign key linking to trading.ancillary_service_award. Business justification: Ancillary service offers submitted to ISO markets result in awards. Core market participation workflow linking offer submission to award receipt and settlement.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Ancillary services (regulation, spinning reserve) are procured and dispatched by control area operators for real-time balancing and frequency control.',
  `employee_id` BIGINT COMMENT 'Identifier of the individual trader or scheduler who submitted the ancillary service offer on behalf of the utility.',
  `from_generating_unit_id` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — Ancillary service offers are submitted based on a specific generating unit\'s physical capability (ramp rate, response time). Without this FK, offers cannot be traced to the unit providing the service.',
  `generating_unit_id` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — Ancillary service offers are submitted per generating unit to ISO/RTO markets. generating_unit_id is required for market revenue tracking and NERC reliability compliance.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Ancillary service participation governed by ISO/RTO market rules and NERC standards (frequency response, voltage support). Required for market compliance validation, settlement dispute resolution, and',
  `primary_generating_unit_id` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — Ancillary service offers are submitted for specific generating units based on their capability. Without this FK, offers cannot be traced to the offering unit. Critical for market revenue tracking.',
  `award_timestamp` TIMESTAMP COMMENT 'Date and time when the ISO/RTO awarded the ancillary service offer or published the market clearing results.',
  `awarded_capacity_mw` DECIMAL(12,3) COMMENT 'The capacity in megawatts (MW) that was actually awarded by the ISO/RTO for this ancillary service offer. May be less than or equal to offered capacity.',
  `clearing_price_per_mw` DECIMAL(12,2) COMMENT 'The market clearing price in dollars per megawatt ($/MW) at which the ancillary service capacity was awarded.',
  `clearing_price_per_mwh` DECIMAL(12,2) COMMENT 'The market clearing price in dollars per megawatt-hour ($/MWh) at which the energy-based ancillary service was awarded.',
  `compliance_notes` STRING COMMENT 'Free-text field for recording compliance-related notes, regulatory reporting requirements, or NERC reliability standard adherence details related to this ancillary service offer.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this ancillary service offer record was first created in the system. Audit trail field for record lifecycle tracking.',
  `iso_rto_market` STRING COMMENT 'The ISO or RTO market to which this ancillary service offer was submitted (PJM, MISO, CAISO, ERCOT, NYISO, ISO-NE, SPP). Reference-value candidates: PJM|MISO|CAISO|ERCOT|NYISO|ISONE|SPP.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this ancillary service offer record was last updated or modified. Audit trail field for record lifecycle tracking.',
  `market_type` STRING COMMENT 'The type of market for which the ancillary service offer was submitted: day-ahead market (DAM), real-time market (RTM), or hour-ahead market. Valid values: day_ahead|real_time|hour_ahead.',
  `maximum_run_time_minutes` DECIMAL(8,2) COMMENT 'The maximum continuous operating time in minutes that the generating unit can sustain the offered ancillary service capacity.',
  `minimum_run_time_minutes` DECIMAL(8,2) COMMENT 'The minimum continuous operating time in minutes that the generating unit must maintain once dispatched for the ancillary service.',
  `must_offer_obligation_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the generating unit is under a must-offer obligation to provide ancillary services as part of its capacity commitment or interconnection agreement.',
  `offer_curve_segment_count` INT COMMENT 'The number of price-quantity segments in the ancillary service offer curve, if the offer is structured as a multi-segment bid.',
  `offer_interval_end_timestamp` TIMESTAMP COMMENT 'End date and time of the operating interval for which the ancillary service is offered.',
  `offer_interval_start_timestamp` TIMESTAMP COMMENT 'Start date and time of the operating interval for which the ancillary service is offered.',
  `offer_number` STRING COMMENT 'External business identifier for the ancillary service offer as assigned by the ISO/RTO or internal trading system.',
  `offer_price_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the offer price (USD for United States Dollar, CAD for Canadian Dollar, MXN for Mexican Peso). Valid values: USD|CAD|MXN.',
  `offer_price_per_mw` DECIMAL(12,2) COMMENT 'The price in dollars per megawatt ($/MW) for capacity-based ancillary services such as spinning reserve or non-spinning reserve.',
  `offer_price_per_mwh` DECIMAL(12,2) COMMENT 'The price in dollars per megawatt-hour ($/MWh) for energy-based ancillary services such as regulation up or regulation down.',
  `offer_revision_number` INT COMMENT 'Sequential revision number for this ancillary service offer, incremented each time the offer is modified and resubmitted before the market closes.',
  `offer_source_system` STRING COMMENT 'Name or identifier of the source system from which the ancillary service offer originated (e.g., OpenLink Endur, ABB Ability Symphony Plus, manual entry).',
  `offer_status` STRING COMMENT 'Current lifecycle status of the ancillary service offer: draft, submitted, accepted, rejected, partially awarded, withdrawn, or expired. Reference-value candidates: draft|submitted|accepted|rejected|partially_awarded|withdrawn|expired.',
  `offer_submission_timestamp` TIMESTAMP COMMENT 'Date and time when the ancillary service offer was submitted to the ISO/RTO market. Principal business event timestamp for this transaction.',
  `offered_capacity_mw` DECIMAL(12,3) COMMENT 'The capacity in megawatts (MW) that the generating unit is offering for the specified ancillary service.',
  `pricing_node` STRING COMMENT 'The pricing node or location identifier within the ISO/RTO market where the generating unit is interconnected and the ancillary service is offered.',
  `ramp_rate_mw_per_min` DECIMAL(10,3) COMMENT 'The rate at which the generating unit can increase or decrease output, measured in megawatts per minute (MW/min), relevant for regulation and spinning reserve services.',
  `rejection_reason_code` STRING COMMENT 'Code indicating the reason the ancillary service offer was rejected by the ISO/RTO, if applicable (e.g., insufficient capacity, late submission, technical constraint violation).',
  `rejection_reason_description` STRING COMMENT 'Detailed textual description of why the ancillary service offer was rejected by the ISO/RTO, if applicable.',
  `response_time_minutes` DECIMAL(8,2) COMMENT 'The time in minutes required for the generating unit to respond and deliver the offered ancillary service capacity from the time of dispatch signal.',
  `self_schedule_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this ancillary service offer is a self-schedule (fixed commitment) rather than an economic offer subject to market clearing.',
  `service_type` STRING COMMENT 'Type of ancillary service being offered: regulation up, regulation down, spinning reserve, non-spinning reserve, reactive power, or voltage support. Valid values: regulation_up|regulation_down|spinning_reserve|non_spinning_reserve|reactive_power|voltage_support.',
  `trading_desk_code` BIGINT COMMENT 'Identifier of the internal trading desk or energy trading team responsible for submitting this ancillary service offer.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_ancillary_service_offer` PRIMARY KEY (`ancillary_service_offer_id`)
)
USING DELTA
COMMENT 'Records of ancillary service capability offers submitted by generating units to ISO/RTO markets, including regulation up/down, spinning reserve, non-spinning reserve, and reactive power. Captures offer interval, service type, offered capacity (MW), offer price ($/MW or $/MWh), ramp rate capability, response time, ISO/RTO market (PJM, MISO, CAISO, ERCOT), and award status. Supports market revenue optimization and NERC reliability standard compliance. | CMM: CIM ResourceBid (close), IEC62325::ParticipantInterfaces.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AncillaryServiceOffer',
  'cmm.cim.class' = 'ResourceBid',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC62325::ParticipantInterfaces',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.ancillary_service_offer'
);

-- CapacityMarketOffer  <<CIM Bid : close>>
CREATE TABLE IF NOT EXISTS `generation`.`capacity_market_offer` (
  `capacity_market_offer_id` BIGINT NOT NULL COMMENT 'Unique identifier for the capacity market offer record. Primary key for this entity.',
  `capacity_generating_unit_id` BIGINT COMMENT 'Reference to the generating unit participating in the capacity market auction. Links to the generation asset registry.',
  `capacity_obligation_id` BIGINT COMMENT 'Foreign key linking to trading.capacity_obligation. Business justification: Capacity offers are submitted to satisfy specific capacity obligations. Essential for tracking how LSE capacity obligations are met through capacity market participation.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Capacity market offers are control-area or RTO-wide for resource adequacy. Required for capacity auction clearing and obligation tracking.',
  `dr_capacity_registration_id` BIGINT COMMENT 'Foreign key linking to demand.dr_capacity_registration. Business justification: Capacity markets clear both generation and demand response resources together. Market operators need to link supply-side and demand-side capacity offers for auction clearing, settlement, and performan',
  `from_generating_unit_id` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — Capacity market offers are based on a specific generating unit\'s demonstrated capability. Without this FK, capacity obligations cannot be traced to the unit responsible for delivery.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Capacity market participation governed by ISO/RTO tariffs, FERC orders, and must-offer obligations. Essential for MOPR compliance, market rule adherence, offer cap validation, and audit defense of cap',
  `primary_generating_unit_id` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — Capacity market offers and awards are per generating unit. generating_unit_id is required for capacity revenue planning and performance obligation tracking.',
  `auction_date` DATE COMMENT 'Date on which the capacity auction was conducted and results were determined.',
  `auction_name` STRING COMMENT 'Name or identifier of the specific capacity auction (e.g., PJM RPM Base Residual Auction, ISO-NE Forward Capacity Auction).',
  `auction_year` INT COMMENT 'Calendar year in which the capacity auction was conducted.',
  `avoidable_cost_rate_per_mw_day` DECIMAL(12,2) COMMENT 'Unit-specific avoidable cost rate used to determine the offer floor for existing resources under market power mitigation rules, expressed in dollars per megawatt per day ($/MW-day).',
  `capacity_accreditation_mw` DECIMAL(12,3) COMMENT 'ISO/RTO-determined accredited capacity value for the resource, which may differ from nameplate capacity based on performance factors, measured in megawatts (MW).',
  `capacity_import_limit_flag` BOOLEAN COMMENT 'Indicates whether the capacity offer is subject to import limits from external control areas (True) or is internal capacity (False).',
  `capacity_obligation_end_date` DATE COMMENT 'Last date of the delivery year when the capacity obligation expires.',
  `capacity_obligation_start_date` DATE COMMENT 'First date of the delivery year when the capacity obligation becomes effective.',
  `capacity_performance_flag` BOOLEAN COMMENT 'Indicates whether the offer is for Capacity Performance (CP) product with enhanced performance obligations and penalty exposure (True) or Base Capacity (False).',
  `capacity_transfer_right_flag` BOOLEAN COMMENT 'Indicates whether the cleared capacity includes or is subject to capacity transfer rights allowing delivery to another zone (True) or not (False).',
  `cleared_capacity_mw` DECIMAL(12,3) COMMENT 'Amount of capacity that cleared in the auction and was awarded to the generating unit, measured in megawatts (MW).',
  `clearing_price_per_mw_day` DECIMAL(12,2) COMMENT 'Market clearing price determined by the auction for the delivery year, expressed in dollars per megawatt per day ($/MW-day).',
  `commercial_operation_date` DATE COMMENT 'Date when the generating unit is expected to achieve commercial operation and be available to meet capacity obligations. For existing units, this is the historical COD.',
  `delivery_year` INT COMMENT 'Calendar year for which the capacity obligation applies (typically 1-3 years after auction year).',
  `effective_load_carrying_capability_mw` DECIMAL(12,3) COMMENT 'Effective Load Carrying Capability value for intermittent resources (wind, solar), representing the capacity contribution based on availability during peak periods, measured in megawatts (MW).',
  `fuel_type` STRING COMMENT 'Primary fuel source or technology type of the generating unit offering capacity. Reference-value candidates: natural_gas|coal|nuclear|hydro|wind|solar|biomass|oil|dual_fuel|battery_storage.',
  `interconnection_queue_position` INT COMMENT 'Position in the ISO/RTO interconnection queue for new or planned resources. Null for existing resources.',
  `iso_rto_code` STRING COMMENT 'Code identifying the ISO or RTO administering the capacity market auction (e.g., PJM, ISO-NE, MISO). Reference-value candidates: PJM|ISONE|NYISO|MISO|CAISO|SPP|ERCOT.',
  `locational_deliverability_area` STRING COMMENT 'Geographic zone or constrained area within the ISO/RTO footprint where the capacity is deliverable (e.g., EMAAC, SWMAAC, RTO).',
  `mopr_floor_price_per_mw_day` DECIMAL(12,2) COMMENT 'Minimum offer price floor applied under MOPR mitigation rules for resources receiving state subsidies, expressed in dollars per megawatt per day ($/MW-day). Null if MOPR does not apply.',
  `must_offer_obligation_flag` BOOLEAN COMMENT 'Indicates whether the generating unit is subject to a must-offer obligation requiring participation in the capacity auction (True) or participation is voluntary (False).',
  `net_capacity_revenue_usd` DECIMAL(15,2) COMMENT 'Total net revenue earned from the capacity market award for the delivery year, calculated as cleared capacity (MW) × clearing price ($/MW-day) × days in delivery year, expressed in US dollars.',
  `net_cost_of_new_entry_per_mw_day` DECIMAL(12,2) COMMENT 'ISO/RTO-determined Net Cost of New Entry benchmark used to set demand curves and offer caps for new resources, expressed in dollars per megawatt per day ($/MW-day).',
  `offer_cap_applied_flag` BOOLEAN COMMENT 'Indicates whether a market power mitigation offer cap was applied to this offer (True) or not (False).',
  `offer_price_per_mw_day` DECIMAL(12,2) COMMENT 'Price at which capacity was offered, expressed in dollars per megawatt per day ($/MW-day).',
  `offer_status` STRING COMMENT 'Current status of the capacity market offer in the auction lifecycle. Valid values: submitted|accepted|rejected|partially_cleared|withdrawn|revised.',
  `offer_submission_timestamp` TIMESTAMP COMMENT 'Date and time when the capacity offer was submitted to the ISO/RTO auction platform.',
  `offered_capacity_mw` DECIMAL(12,3) COMMENT 'Total capacity offered into the auction by the generating unit, measured in megawatts (MW).',
  `penalty_exposure_usd` DECIMAL(15,2) COMMENT 'Maximum potential financial penalty exposure for non-performance during the delivery year, applicable to Capacity Performance products, expressed in US dollars.',
  `planning_year` STRING COMMENT 'ISO/RTO planning year designation for the capacity obligation period (e.g., 2024/2025 for June 2024 - May 2025).',
  `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this capacity market offer record was first created in the system.',
  `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this capacity market offer record was last modified in the system.',
  `replacement_capacity_flag` BOOLEAN COMMENT 'Indicates whether this offer represents replacement capacity procured to substitute for a unit that failed to meet its obligation (True) or is an original auction offer (False).',
  `resource_type` STRING COMMENT 'Classification of the generating resource participating in the auction (existing unit, new build, planned capacity, uprate, or reactivation). Valid values: existing|new|planned|uprate|reactivation.',
  `seasonal_capacity_flag` BOOLEAN COMMENT 'Indicates whether the capacity offer is for seasonal capacity with different summer and winter ratings (True) or annual capacity (False).',
  `source_system` STRING COMMENT 'Name of the operational system from which this capacity market offer record originated (e.g., OpenLink Endur, ISO/RTO auction platform).',
  `state_subsidy_flag` BOOLEAN COMMENT 'Indicates whether the generating unit receives state subsidies (e.g., Zero Emission Credits, Renewable Energy Credits) that may subject it to Minimum Offer Price Rule (MOPR) mitigation (True) or not (False).',
  `summer_capacity_mw` DECIMAL(12,3) COMMENT 'Generating unit capacity rating for summer months (typically June-September), measured in megawatts (MW). Applicable when seasonal capacity flag is True.',
  `unit_specific_exemption_flag` BOOLEAN COMMENT 'Indicates whether the generating unit received a unit-specific exemption from the standard offer cap or other auction rules (True) or not (False).',
  `winter_capacity_mw` DECIMAL(12,3) COMMENT 'Generating unit capacity rating for winter months (typically December-February), measured in megawatts (MW). Applicable when seasonal capacity flag is True.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_capacity_market_offer` PRIMARY KEY (`capacity_market_offer_id`)
)
USING DELTA
COMMENT 'Records of capacity market offers and awards for generating units participating in ISO/RTO forward capacity markets (PJM RPM, ISO-NE FCA, MISO PRCP). Captures auction year, delivery year, offered capacity (MW), offer price ($/MW-day), cleared capacity (MW), clearing price ($/MW-day), capacity performance obligations, penalty exposure, and net capacity revenue ($). Supports generation revenue planning and CAPEX justification. | CMM: CIM Bid (close), IEC62325::ParticipantInterfaces.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CapacityMarketOffer',
  'cmm.cim.class' = 'Bid',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC62325::ParticipantInterfaces',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.capacity_market_offer'
);

-- GadsReport  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `generation`.`gads_report` (
  `gads_report_id` BIGINT NOT NULL COMMENT 'Unique identifier for the NERC GADS monthly performance report record. Primary key for the GADS report entity.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: NERC GADS reporting includes balancing authority context for regional reliability benchmarking and forced outage rate analysis.',
  `gads_generating_unit_id` BIGINT COMMENT 'Foreign key reference to the generating unit for which this GADS report is submitted. Links to the generation asset registry.',
  `generating_unit_id` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — NERC GADS reports are submitted per generating unit. Without this FK, GADS compliance records cannot be linked to the unit they report on, breaking NERC compliance.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: GADS reporting is mandatory NERC obligation for bulk electric system reliability tracking. Direct link required for compliance tracking, audit evidence, regulatory submissions, and demonstrating adher',
  `primary_generating_unit_id` BIGINT COMMENT 'FK to generation.generating_unit.generating_unit_id — NERC GADS reports are submitted per generating unit. Without this FK, GADS performance metrics cannot be associated with the reported unit. Critical for NERC compliance.',
  `available_hours` DECIMAL(10,2) COMMENT 'The total number of hours during the reporting period that the unit was capable of service, whether or not it was actually in service. Includes service hours plus reserve shutdown hours.',
  `capacity_factor_pct` DECIMAL(5,2) COMMENT 'The ratio of actual net generation to the maximum possible generation if the unit operated at full nameplate capacity for the entire reporting period. Calculated as (Net Generation MWh / (Nameplate Capacity MW * Period Hours)) * 100.',
  `cause_code_group` STRING COMMENT 'The high-level NERC GADS cause code category for the most significant outage event during the reporting period (e.g., boiler, turbine, generator, electrical, external). Reference-value candidates: boiler|turbine|generator|electrical|balance_of_plant|external|fuel_supply|environmental|other.',
  `comments` STRING COMMENT 'Free-text field for additional context, explanations of unusual performance, or notes regarding data quality issues. Supports regulatory compliance documentation.',
  `commercial_operation_date` DATE COMMENT 'The date the generating unit entered commercial service. Used to determine unit age and applicable GADS reporting requirements.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this GADS report record was first created in the system. Used for audit trail and data lineage tracking.',
  `data_source_system` STRING COMMENT 'The name of the operational system from which the GADS performance data was extracted (e.g., OSIsoft PI, ABB Ability Symphony Plus, plant DCS). Used for data lineage and quality assurance.',
  `equivalent_availability_factor_pct` DECIMAL(5,2) COMMENT 'The percentage of time the unit was available to generate at full capacity, accounting for both full and partial outages. Key NERC GADS performance metric calculated as (Available Hours - Equivalent Forced Outage Hours - Equivalent Planned Outage Hours) / Period Hours * 100.',
  `equivalent_forced_outage_rate_pct` DECIMAL(5,2) COMMENT 'The percentage of time the unit was unavailable due to forced outages, accounting for both full and partial forced deratings. Key NERC GADS reliability metric calculated as Equivalent Forced Outage Hours / (Service Hours + Equivalent Forced Outage Hours) * 100.',
  `equivalent_planned_outage_factor_pct` DECIMAL(5,2) COMMENT 'The percentage of time the unit was unavailable due to planned outages, accounting for both full and partial planned deratings. NERC GADS metric calculated as Equivalent Planned Outage Hours / Period Hours * 100.',
  `forced_outage_hours` DECIMAL(10,2) COMMENT 'The total number of hours the unit was unavailable due to unplanned events requiring immediate removal from service, including equipment failures and emergency conditions.',
  `forced_outage_rate_pct` DECIMAL(5,2) COMMENT 'The percentage of time the unit was on full forced outage. Calculated as Forced Outage Hours / (Service Hours + Forced Outage Hours) * 100. Differs from EFOR by excluding partial deratings.',
  `gross_generation_mwh` DECIMAL(12,3) COMMENT 'The total gross electrical energy in megawatt-hours (MWh) produced by the unit during the reporting period, before deducting station service and auxiliary loads.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this GADS report record was most recently updated. Used for change tracking and audit trail purposes.',
  `maintenance_outage_hours` DECIMAL(10,2) COMMENT 'The total number of hours the unit was unavailable due to maintenance work that could be deferred beyond the end of the next weekend but requires removal from service within six weeks.',
  `nameplate_capacity_mw` DECIMAL(10,3) COMMENT 'The maximum rated output of the generating unit in megawatts (MW) as specified by the manufacturer. Used as the denominator for capacity factor calculations.',
  `nerc_unit_code` STRING COMMENT 'The unique NERC-assigned identifier for the generating unit. Used for regulatory reporting and cross-utility benchmarking. Pattern: ^[A-Z0-9]{1,10}$.',
  `nerc_validation_status` STRING COMMENT 'The outcome of NERC automated data validation checks applied to this report. Failed validations require correction and resubmission. Valid values: pending|passed|failed|warning.',
  `net_dependable_capacity_mw` DECIMAL(10,3) COMMENT 'The net capacity in megawatts (MW) that the unit can be relied upon to deliver during peak demand periods, adjusted for seasonal and operational constraints.',
  `net_generation_mwh` DECIMAL(12,3) COMMENT 'The total net electrical energy in megawatt-hours (MWh) delivered by the unit to the grid during the reporting period, after deducting station service and auxiliary loads.',
  `net_maximum_capacity_mw` DECIMAL(10,3) COMMENT 'The maximum net electrical output in megawatts (MW) that the unit can sustain over a specified period under normal operating conditions, accounting for station service loads.',
  `number_of_forced_outages` INT COMMENT 'The total count of discrete forced outage events during the reporting period. Used to calculate forced outage frequency metrics.',
  `number_of_starts` INT COMMENT 'The total count of unit synchronization events during the reporting period, including both successful and failed start attempts.',
  `period_hours` DECIMAL(10,2) COMMENT 'The total number of hours in the reporting period. Typically 720 hours for a 30-day month or 744 hours for a 31-day month. Used as the denominator for availability calculations.',
  `planned_outage_hours` DECIMAL(10,2) COMMENT 'The total number of hours the unit was unavailable due to scheduled maintenance, inspections, or overhauls that were planned in advance and approved by system operations.',
  `primary_fuel_type` STRING COMMENT 'The predominant fuel source used by the generating unit during the reporting period. Used for fuel-specific performance benchmarking. Reference-value candidates: coal|natural_gas|nuclear|hydro|wind|solar|oil|biomass|geothermal|other.',
  `report_approval_date` DATE COMMENT 'The date on which this GADS report was reviewed and approved by authorized personnel before submission to NERC.',
  `report_approver_name` STRING COMMENT 'The name of the authorized individual who approved this GADS report for submission to NERC. Used for internal compliance audit trail.',
  `report_preparer_email` STRING COMMENT 'The email address of the individual who prepared this GADS report. Used for follow-up questions and validation issue resolution. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `report_preparer_name` STRING COMMENT 'The name of the individual who prepared this GADS report. Used for internal audit trail and quality assurance purposes.',
  `report_submission_date` DATE COMMENT 'The date on which this GADS report was submitted to NERC. Used to track compliance with NERC submission deadlines.',
  `reporting_entity_name` STRING COMMENT 'The legal name of the utility or generation owner responsible for submitting this GADS report to NERC. May differ from the operating entity.',
  `reporting_entity_nerc_code` STRING COMMENT 'The unique NERC-assigned identifier for the reporting entity. Used to aggregate performance data across multiple generating units owned by the same entity. Pattern: ^[A-Z0-9]{1,10}$.',
  `reporting_period_end_date` DATE COMMENT 'The last day of the monthly reporting period covered by this GADS report. Typically the last day of the calendar month.',
  `reporting_period_start_date` DATE COMMENT 'The first day of the monthly reporting period covered by this GADS report. Typically the first day of the calendar month.',
  `retirement_date` DATE COMMENT 'The date the generating unit was permanently retired from service. Null for active units. Determines the end of GADS reporting obligations.',
  `service_hours` DECIMAL(10,2) COMMENT 'The total number of hours during the reporting period that the unit was in active service and synchronized to the grid, regardless of output level.',
  `starting_reliability_pct` DECIMAL(5,2) COMMENT 'The percentage of attempted unit starts that were successful. Calculated as Successful Starts / Total Attempted Starts * 100. Applicable primarily to peaking and cycling units.',
  `submission_status` STRING COMMENT 'The current status of this GADS report in the NERC submission and validation workflow. Tracks compliance with regulatory reporting requirements. Valid values: draft|submitted|accepted|rejected|revised.',
  `unit_type` STRING COMMENT 'The primary technology classification of the generating unit as defined by NERC GADS taxonomy. Determines applicable performance metrics and cause codes. Reference-value candidates: fossil_steam|combined_cycle|combustion_turbine|nuclear|hydro_conventional|hydro_pumped_storage|wind|solar_pv|solar_thermal|biomass|geothermal.',
  `validation_error_message` STRING COMMENT 'Detailed error or warning messages returned by NERC validation logic. Provides guidance for correcting data quality issues before resubmission.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_gads_report` PRIMARY KEY (`gads_report_id`)
)
USING DELTA
COMMENT 'NERC Generating Availability Data System (GADS) monthly performance report records submitted for each generating unit. Captures reporting period, equivalent availability factor (EAF), equivalent forced outage rate (EFOR), equivalent planned outage factor (EPOF), net generation (MWh), capacity factor (%), total outage hours by cause code, and NERC submission status. SSOT for NERC GADS compliance and generation fleet benchmarking. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'GadsReport',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.gads_report'
);

-- FuelContract  <<CIM Agreement : extension>>
CREATE TABLE IF NOT EXISTS `generation`.`fuel_contract` (
  `fuel_contract_id` BIGINT NOT NULL COMMENT 'Unique identifier for the fuel supply contract record. Primary key.',
  `ap_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ap_invoice. Business justification: Fuel contracts generate AP invoices for payment processing. Required for three-way match (contract-receipt-invoice), accrual accounting, and fuel cost reconciliation.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Fuel contracts are assigned to cost centers for budget tracking and fuel budget variance reporting. Standard in utility fuel management.',
  `fuel_power_plant_id` BIGINT COMMENT 'Identifier of the generation facility or plant that this fuel contract serves.',
  `fuel_price_assumption_id` BIGINT COMMENT 'Foreign key linking to forecast.fuel_price_assumption. Business justification: Fuel contracts are negotiated and evaluated against fuel price forecasts for procurement strategy and hedging decisions. Contract pricing formulas reference forecast assumptions. Essential for fuel co',
  `fuel_supplies_power_plant` BIGINT COMMENT 'FK to generation.power_plant.power_plant_id — Fuel contracts are typically negotiated for delivery to specific plant locations. Without this FK, fuel supply planning cannot associate contracts with the plants they serve.',
  `hedge_strategy_id` BIGINT COMMENT 'Foreign key linking to trading.hedge_strategy. Business justification: Fuel procurement contracts are integrated into hedge strategies for spark spread hedging. Essential for coordinated fuel and power hedging programs in generation portfolio management.',
  `power_plant_id` BIGINT COMMENT 'FK to generation.power_plant.power_plant_id — Fuel supply contracts are typically executed for specific generation facilities (delivery point is plant-level). power_plant_id links contracts to the plants they supply.',
  `primary_fuel_vendor_id` BIGINT COMMENT 'Unique identifier for the fuel supplier in the vendor master system.',
  `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supply.purchase_order. Business justification: Fuel contracts generate purchase orders for scheduled deliveries. Procurement execution requires linking contracts to POs for delivery tracking, invoice verification, and contract compliance monitorin',
  `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: Major fuel contracts require FERC/PUC approval and inclusion in rate cases for prudence review and cost recovery. Essential for linking fuel procurement decisions to regulatory approval processes and',
  `base_price` DECIMAL(18,4) COMMENT 'Base or fixed price per unit of fuel as specified in the contract, expressed in the currency defined by price_currency_code.',
  `contract_document_reference` STRING COMMENT 'File path, document management system reference, or URL to the executed contract document and amendments.',
  `contract_manager_email` STRING COMMENT 'Email address of the contract manager for operational communications regarding this fuel supply agreement. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `contract_manager_name` STRING COMMENT 'Name of the utility employee responsible for managing and administering this fuel supply contract.',
  `contract_name` STRING COMMENT 'Descriptive name or title of the fuel supply contract for business reference and reporting.',
  `contract_number` STRING COMMENT 'Externally-known business identifier for the fuel supply contract, used in procurement systems and supplier communications.',
  `contract_status` STRING COMMENT 'Current lifecycle status of the fuel supply contract indicating its operational state. Valid values: draft|active|suspended|expired|terminated|pending_approval.',
  `contract_term_months` INT COMMENT 'Duration of the contract term expressed in months from effective start to end date.',
  `contract_value_total` DECIMAL(18,2) COMMENT 'Total estimated monetary value of the contract over its full term, expressed in price_currency_code. Used for CAPEX and budget planning.',
  `contracted_volume_annual` DECIMAL(18,2) COMMENT 'Total annual volume of fuel contracted for delivery, expressed in the unit specified by volume_unit_of_measure.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this fuel contract record was first created in the system.',
  `delivery_point_address` STRING COMMENT 'Physical address of the fuel delivery point including street, city, state, and postal code.',
  `delivery_point_name` STRING COMMENT 'Named location or facility where fuel is delivered under the contract (e.g., plant gate, pipeline interconnect, rail siding).',
  `effective_end_date` DATE COMMENT 'Date when the fuel supply contract expires or terminates, ending delivery obligations. Nullable for evergreen contracts.',
  `effective_start_date` DATE COMMENT 'Date when the fuel supply contract becomes legally binding and fuel delivery obligations commence.',
  `environmental_compliance_notes` STRING COMMENT 'Notes on environmental compliance requirements related to this fuel supply, including emissions standards, sulfur limits, or renewable content mandates.',
  `escalation_rate_percent` DECIMAL(5,2) COMMENT 'Annual percentage rate for price escalation or inflation adjustment built into the contract pricing terms.',
  `force_majeure_provision` STRING COMMENT 'Description of force majeure events and remedies that excuse non-performance under the contract (e.g., natural disasters, strikes, regulatory changes).',
  `fuel_type` STRING COMMENT 'Type of fuel covered by this supply contract, aligned with generation facility fuel requirements. Valid values: natural_gas|coal|nuclear_fuel|oil|biomass|diesel.',
  `heat_content_mmbtu_per_unit` DECIMAL(10,4) COMMENT 'Guaranteed or average heat content of the fuel expressed in MMBtu per unit (ton, barrel, cubic meter) for heat rate and LCOE calculations.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this fuel contract record was last updated or modified.',
  `maximum_take_limit` DECIMAL(18,2) COMMENT 'Maximum volume of fuel that can be purchased annually under contract terms, expressed in volume_unit_of_measure.',
  `minimum_take_obligation` DECIMAL(18,2) COMMENT 'Minimum volume of fuel that must be purchased annually under take-or-pay provisions, expressed in volume_unit_of_measure.',
  `modified_by_user` STRING COMMENT 'Username or identifier of the user who last modified this fuel contract record.',
  `payment_method` STRING COMMENT 'Approved method of payment to the supplier for fuel deliveries under this contract. Valid values: wire_transfer|ach|check|letter_of_credit.',
  `payment_terms_days` INT COMMENT 'Number of days from invoice date within which payment is due to the supplier.',
  `price_adjustment_formula` STRING COMMENT 'Mathematical formula or description of how contract price adjusts based on indices, escalation factors, or other variables.',
  `price_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary values in this contract. Valid values: USD|EUR|GBP|CAD|MXN|JPY.',
  `price_index_reference` STRING COMMENT 'Name of the pricing index or benchmark used for index-based contracts (e.g., Henry Hub, NYMEX Natural Gas, API2 Coal Index).',
  `price_structure_type` STRING COMMENT 'Pricing mechanism used in the contract: fixed price, index-linked (e.g., Henry Hub, NYMEX), formula-based, hybrid, or negotiated per delivery. Valid values: fixed|index_based|formula_based|hybrid|negotiated.',
  `quality_specification` STRING COMMENT 'Technical specifications for fuel quality including heat content, sulfur content, ash content, moisture, or other relevant parameters.',
  `regulatory_approval_date` DATE COMMENT 'Date when regulatory approval was granted for this fuel contract, if applicable.',
  `regulatory_approval_required` BOOLEAN COMMENT 'Indicates whether this fuel contract requires approval from state PUC or FERC for cost recovery in rate base.',
  `renewal_notice_days` INT COMMENT 'Number of days advance notice required to exercise or decline contract renewal option.',
  `renewal_option` STRING COMMENT 'Type of renewal provision in the contract specifying how the agreement may be extended beyond the initial term. Valid values: automatic|mutual_agreement|utility_option|supplier_option|none.',
  `termination_clause` STRING COMMENT 'Conditions and notice requirements under which either party may terminate the contract prior to expiration.',
  `transportation_arrangement` STRING COMMENT 'Party responsible for arranging and paying for fuel transportation from supplier to delivery point. Valid values: supplier_arranged|utility_arranged|third_party|pipeline_firm|pipeline_interruptible.',
  `transportation_cost_responsibility` STRING COMMENT 'Party responsible for bearing the cost of fuel transportation under contract terms. Valid values: supplier|utility|shared|included_in_price.',
  `volume_unit_of_measure` STRING COMMENT 'Unit of measure for contracted fuel volume (MMBtu for gas, tons for coal/biomass, barrels for oil, cubic meters for gas, MWh thermal for nuclear). Valid values: mmbtu|tons|barrels|cubic_meters|mwh_thermal.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_fuel_contract` PRIMARY KEY (`fuel_contract_id`)
)
USING DELTA
COMMENT 'Master records for fuel supply contracts covering natural gas, coal, nuclear fuel, oil, and biomass procurement for generation facilities. Captures fuel type, supplier name, contract term, contracted volume (MMBtu/year or tons/year), price terms (fixed, index, formula), delivery point, transportation arrangement, force majeure provisions, minimum take obligation, and contract status. Supports fuel supply security and generation cost planning. | CMM: CIM Agreement (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'FuelContract',
  'cmm.cim.class' = 'Agreement',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.fuel_contract'
);

-- PlantVendorAgreement  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `generation`.`plant_vendor_agreement` (
  `plant_vendor_agreement_id` BIGINT NOT NULL COMMENT 'Unique identifier for this plant-vendor agreement record. Primary key.',
  `power_plant_id` BIGINT COMMENT 'Foreign key linking to the power generation facility that is party to this vendor agreement.',
  `vendor_id` BIGINT COMMENT 'Foreign key linking to the vendor that is party to this plant-specific agreement.',
  `agreement_status` STRING COMMENT 'Current lifecycle status of this plant-vendor agreement. Active = in force, Pending = negotiated but not yet effective, Expired = past end date, Terminated = ended early, Suspended = temporarily inactive.',
  `annual_spend_usd` DECIMAL(15,2) COMMENT 'Total annual procurement spend in USD for this plant-vendor relationship. Used for vendor performance analysis and strategic sourcing decisions.',
  `contract_end_date` DATE COMMENT 'Expiration or termination date of the plant-specific vendor contract. Used for contract renewal tracking.',
  `contract_start_date` DATE COMMENT 'Effective start date of the plant-specific vendor contract or service agreement.',
  `contract_type` STRING COMMENT 'Classification of the primary service or product category covered by this plant-vendor agreement.',
  `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this plant-vendor agreement record was created.',
  `preferred_vendor_flag` BOOLEAN COMMENT 'Indicates whether this vendor has preferred status for this specific plant. A vendor may be preferred at one plant but not another based on local performance, proximity, or specialized capabilities.',
  `response_time_hours` DECIMAL(8,2) COMMENT 'Contractually committed response time in hours for emergency service calls or critical supply requests at this plant. Varies by plant criticality and vendor capability.',
  `service_level_agreement` STRING COMMENT 'Description or reference to the service level agreement terms specific to this plant-vendor relationship. May include uptime guarantees, quality standards, or delivery commitments.',
  `updated_timestamp` TIMESTAMP COMMENT 'System timestamp when this plant-vendor agreement record was last modified.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_plant_vendor_agreement` PRIMARY KEY (`plant_vendor_agreement_id`)
)
USING DELTA
COMMENT 'This association product represents the contractual relationship between a power generation facility and its suppliers/service vendors. It captures plant-specific procurement contracts, service level agreements, and vendor performance tracking. Each record links one power plant to one vendor with commercial terms, service commitments, and spend tracking that exist only in the context of this specific plant-vendor relationship.. Existence Justification: Power plants maintain contractual relationships with multiple vendors for different services (fuel supply, parts, maintenance, emergency response), and vendors serve multiple generation facilities across the utility\'s portfolio. Each plant-vendor relationship has its own contract terms, service level agreements, response time commitments, and spend tracking that vary by plant criticality, location, and vendor capability. This is an operational relationship actively managed by plant operators and procurement teams. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PlantVendorAgreement',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.plant_vendor_agreement'
);

-- UnitCrewAssignment  <<CIM Assignment : close>>
CREATE TABLE IF NOT EXISTS `generation`.`unit_crew_assignment` (
  `unit_crew_assignment_id` BIGINT NOT NULL COMMENT 'Primary key for unit_crew_assignment',
  `assignment_id` BIGINT COMMENT 'Unique identifier for the unit crew assignment. Primary key.',
  `crew_id` BIGINT COMMENT 'Foreign key linking to the crew assigned to the unit',
  `generating_unit_id` BIGINT COMMENT 'Foreign key linking to the generating unit being staffed',
  `assignment_priority` INT COMMENT 'Priority ranking for this assignment when crew is assigned to multiple units. Used for dispatch decisions during emergencies or outages.',
  `assignment_status` STRING COMMENT 'Current status of the assignment (active, planned, suspended, completed). Determines crew availability and scheduling.',
  `certification_level` STRING COMMENT 'Required or actual certification level for this crew assignment to this unit type. Used for NERC personnel qualification tracking and work authorization.',
  `created_by_user` STRING COMMENT 'User ID of the generation supervisor or workforce planner who created the assignment.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the assignment record was created in the system.',
  `crew_role` STRING COMMENT 'Role or function the crew performs for this generating unit (e.g., lead operator, auxiliary operator, maintenance crew, outage crew). Determines work authorization and NERC qualification requirements.',
  `end_date` DATE COMMENT 'Date when the crew assignment to the generating unit ends. Null for ongoing assignments. Used for rotation tracking and historical analysis.',
  `last_modified_by_user` STRING COMMENT 'User ID of person who last modified the assignment record.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of most recent modification to the assignment record.',
  `last_qualification_date` DATE COMMENT 'Date of most recent NERC qualification verification or training for this crew on this unit type. Used for compliance tracking and requalification scheduling.',
  `nerc_qualification_verified` BOOLEAN COMMENT 'Indicates whether NERC personnel qualification requirements have been verified for this crew-unit assignment. Required before crew can operate the unit.',
  `next_qualification_due_date` DATE COMMENT 'Date when NERC requalification is due for this crew-unit assignment. Triggers training scheduling and compliance alerts.',
  `shift_pattern` STRING COMMENT 'Shift rotation pattern for this assignment (e.g., 12-hour rotating, 8-hour fixed, day shift, night shift). Critical for 24/7 generation operations staffing.',
  `start_date` DATE COMMENT 'Date when the crew assignment to the generating unit begins. Used for shift scheduling and outage planning.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_unit_crew_assignment` PRIMARY KEY (`unit_crew_assignment_id`)
)
USING DELTA
COMMENT 'This association product represents the operational assignment of field crews to generating units for operations, maintenance, and outage work. It captures the assignment lifecycle, crew role, shift pattern, and certification requirements for NERC personnel qualification tracking. Each record links one generating unit to one crew with attributes that exist only in the context of this assignment relationship, supporting shift scheduling, outage planning, and regulatory compliance reporting.. Existence Justification: In energy utilities generation operations, generating units require multiple specialized crews rotating across shifts for 24/7 operations, planned maintenance, and outage execution. A single generating unit has multiple crews assigned simultaneously (e.g., day shift operators, night shift operators, maintenance crew, outage crew), and each crew is qualified to work on multiple generating units within the fleet. The business actively manages these assignments with specific roles, shift patterns, and NERC qualification tracking. | CMM: CIM Assignment (close), IEC61968::InfWork.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'UnitCrewAssignment',
  'cmm.cim.class' = 'Assignment',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfWork',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-6',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.unit_crew_assignment'
);

-- UnitCertificationRequirement  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `generation`.`unit_certification_requirement` (
  `unit_certification_requirement_id` BIGINT NOT NULL COMMENT 'Unique identifier for this unit-certification requirement record. Primary key.',
  `certification_id` BIGINT COMMENT 'Foreign key linking to the certification that is required for this generating unit',
  `generating_unit_id` BIGINT COMMENT 'Foreign key linking to the generating unit for which this certification is required',
  `created_date` TIMESTAMP COMMENT 'Timestamp when this unit-certification requirement record was created in the system.',
  `effective_date` DATE COMMENT 'Date when this certification requirement became or will become effective for this generating unit. Used to track regulatory changes and phase-in periods for new requirements.',
  `expiration_date` DATE COMMENT 'Date when this certification requirement expires or is superseded for this generating unit. Null if the requirement is ongoing. Used when unit modifications or regulatory changes eliminate a requirement.',
  `last_updated_by` STRING COMMENT 'User ID or system identifier that last updated this requirement record.',
  `last_updated_date` TIMESTAMP COMMENT 'Timestamp of the most recent update to this requirement record.',
  `mandatory_flag` BOOLEAN COMMENT 'Indicates whether this certification is absolutely mandatory (regulatory requirement) or recommended (best practice) for personnel working with this generating unit in the specified role.',
  `nerc_cip_requirement_flag` BOOLEAN COMMENT 'Indicates whether this certification requirement is driven by NERC CIP (Critical Infrastructure Protection) standards for cyber security and physical access to bulk electric system assets. True when the generating unit is classified as a BES Cyber Asset and personnel require CIP-specific clearances.',
  `regulatory_citation` STRING COMMENT 'Specific regulation, NERC standard, OSHA rule, or state PUC order that mandates this certification for this unit type or voltage class. Provides traceability for compliance audits.',
  `required_for_role` STRING COMMENT 'The operational role or job function for which this certification is required when working with this specific generating unit. Determines which personnel must hold this certification based on their interaction with the unit.',
  `requirement_status` STRING COMMENT 'Current lifecycle status of this certification requirement. ACTIVE = currently enforced, PENDING = future requirement, SUPERSEDED = replaced by newer requirement, WAIVED = exception granted, GRANDFATHERED = existing personnel exempt.',
  `unit_type_applicability` STRING COMMENT 'The generating unit technology types for which this certification is required. Comma-separated list (e.g., \'CCGT,COAL,NUCLEAR\' or \'ALL\'). Different unit types require different operator qualifications and safety certifications.',
  `voltage_class_applicability` STRING COMMENT 'The voltage class range for which this certification requirement applies. Certain certifications (e.g., high voltage safety, arc flash) are only required when the generating unit operates at or above specific voltage thresholds.',
  `created_by` STRING COMMENT 'User ID or system identifier that created this requirement record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_unit_certification_requirement` PRIMARY KEY (`unit_certification_requirement_id`)
)
USING DELTA
COMMENT 'This association product represents the regulatory and operational certification requirements between generating units and workforce certifications. It captures which certifications are mandatory for personnel operating, maintaining, or accessing specific generating units based on unit type, voltage class, fuel type, and NERC CIP classification. Each record links one generating unit to one certification with attributes that define the requirement context, applicability rules, and compliance tracking metadata.. Existence Justification: In energy utility operations, generating units require multiple certifications based on unit characteristics (unit type, voltage class, fuel type, NERC CIP classification), and each certification applies to multiple generating units across the fleet. The business actively manages these requirements through safety compliance and workforce qualification programs, tracking which certifications are mandatory for which unit types, voltage classes, and operational roles. This is an operational regulatory compliance relationship, not an analytical correlation. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'UnitCertificationRequirement',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.unit_certification_requirement'
);

-- FacilityAuditScope  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `generation`.`facility_audit_scope` (
  `facility_audit_scope_id` BIGINT NOT NULL COMMENT 'Unique identifier for this facility-audit scope record. Primary key.',
  `audit_id` BIGINT COMMENT 'Foreign key linking to the compliance audit under which this facility is being examined',
  `power_plant_id` BIGINT COMMENT 'Foreign key linking to the generation facility included in the audit scope',
  `audit_date` DATE COMMENT 'Date when audit activities were conducted at this specific facility (site visit, inspection, or evidence review). May differ from overall audit start/end dates when audit covers multiple facilities over time.',
  `closure_status` STRING COMMENT 'Current closure status for this facility\'s portion of the audit. Tracks whether findings for this specific facility have been addressed and closed by the auditing body. Status can vary by facility within a multi-facility audit.',
  `critical_findings_count` INT COMMENT 'Number of critical or severe findings identified specifically for this facility during this audit.',
  `facility_closure_date` DATE COMMENT 'Date when all findings and corrective actions for this specific facility were closed by the auditing body. May differ from overall audit closure date when facilities close at different times.',
  `facility_coordinator_email` STRING COMMENT 'Email address of the facility audit coordinator for this facility-audit scope.',
  `facility_coordinator_name` STRING COMMENT 'Name of the utility employee at this facility who coordinated audit activities, provided access, and gathered evidence for this facility\'s portion of the audit.',
  `facility_penalty_amount` DECIMAL(15,2) COMMENT 'Monetary penalty assessed specifically for violations identified at this facility during this audit. Penalties are often assessed per facility based on facility-specific violations.',
  `findings_count` INT COMMENT 'Number of audit findings, violations, or observations identified specifically for this facility during this audit. Derived from child finding records but denormalized for reporting.',
  `included_in_scope_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this facility was ultimately included in the final audit scope. Facilities may be initially listed but excluded during scoping phase.',
  `lead_auditor_name` STRING COMMENT 'Name of the auditor from the auditing body who led the audit activities at this specific facility. May differ from the overall audit lead auditor when audit teams are divided across multiple facilities.',
  `scope_added_date` DATE COMMENT 'Date when this facility was added to the audit scope. Tracks when the facility-audit relationship was established.',
  `scope_description` STRING COMMENT 'Detailed description of what aspects of this specific facility are included in the audit scope (e.g., \'NERC CIP-002 through CIP-009 compliance for critical cyber assets\', \'EPA Title V air emissions permit compliance\', \'Generation unit 1 and 2 only\'). Scope varies by facility even within the same audit.',
  `scope_removed_date` DATE COMMENT 'Date when this facility was removed from the audit scope, if applicable. Null if facility remains in scope.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_facility_audit_scope` PRIMARY KEY (`facility_audit_scope_id`)
)
USING DELTA
COMMENT 'This association product represents the audit scope relationship between power_plant and audit. It captures the specific inclusion of a generation facility within a compliance audit\'s scope, including facility-specific findings, audit activities, and closure status. Each record links one power_plant to one audit with attributes that exist only in the context of this facility being audited.. Existence Justification: In energy utilities compliance operations, audits routinely cover multiple generation facilities (a NERC CIP audit may examine 10+ plants, an EPA inspection may cover all coal plants in a region), and each facility undergoes multiple audits over time (NERC reliability, FERC market behavior, state PUC, EPA environmental). The business actively manages facility-specific audit scope, tracks findings per facility, assigns facility coordinators, and closes findings independently per facility even within the same audit. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'FacilityAuditScope',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.facility_audit_scope'
);

-- PlantCrewAssignment  <<CIM Assignment : close>>
CREATE TABLE IF NOT EXISTS `generation`.`plant_crew_assignment` (
  `plant_crew_assignment_id` BIGINT NOT NULL COMMENT 'Unique identifier for the plant-crew assignment record. Primary key.',
  `assigned_by_employee_id` BIGINT COMMENT 'Reference to the plant manager or operations supervisor who authorized this crew assignment. Used for audit trail and assignment approval workflow.',
  `crew_id` BIGINT COMMENT 'Foreign key linking to the field crew assigned to the generation facility',
  `power_plant_id` BIGINT COMMENT 'Foreign key linking to the generation facility where the crew is assigned',
  `assignment_end_date` DATE COMMENT 'Date when the crew assignment to the generation facility ended or is planned to end. Null for ongoing assignments. Critical for tracking temporary assignments during outages or mutual aid deployments.',
  `assignment_notes` STRING COMMENT 'Free-text notes about the assignment including special instructions, temporary restrictions, or coordination requirements with other crews.',
  `assignment_start_date` DATE COMMENT 'Date when the crew assignment to the generation facility became effective. Used for resource planning and historical tracking of crew deployments.',
  `assignment_status` STRING COMMENT 'Current lifecycle status of the crew assignment. Active assignments are used for dispatch and cost allocation. Suspended assignments indicate temporary unavailability (e.g., crew deployed elsewhere).',
  `cost_allocation_percentage` DECIMAL(5,2) COMMENT 'Percentage of crew labor costs allocated to this plant assignment. Used when a crew is split across multiple facilities. Sum of percentages across all assignments for a crew should equal 100%.',
  `crew_type` STRING COMMENT 'Classification of the crew function for this specific assignment. A crew may serve different functions at different plants. Determines work authorization, safety protocols, and regulatory compliance requirements.',
  `emergency_response_role` STRING COMMENT 'Defines the crew\'s role in emergency response scenarios at this facility. Critical for NERC CIP compliance, emergency action plan (EAP) execution, and mutual aid coordination during grid emergencies.',
  `nerc_cip_compliance_verified_date` DATE COMMENT 'Date when crew members\' NERC CIP personnel risk assessments were verified for this specific facility. Required for crews working in CIP-designated critical cyber assets or physical security perimeters.',
  `primary_assignment_flag` BOOLEAN COMMENT 'Indicates whether this is the crew\'s primary plant assignment (true) or a secondary/backup assignment (false). Primary assignments determine home base for crew scheduling and cost allocation.',
  `work_authorization_level` STRING COMMENT 'Level of access and work authorization the crew has at this specific facility. Varies by NERC CIP security zone, plant type, and crew certification level. Determines which work orders can be assigned.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_generation_plant_crew_assignment` PRIMARY KEY (`plant_crew_assignment_id`)
)
USING DELTA
COMMENT 'This association product represents the Assignment between power_plant and crew. It captures the operational assignment of field crews to generation facilities for operations, maintenance, environmental compliance, security, and emergency response work. Each record links one power_plant to one crew with attributes that define the assignment period, crew function, assignment priority, and emergency response role. Critical for resource planning, mutual aid coordination, regulatory staffing compliance (NERC CIP personnel requirements), and outage work scheduling.. Existence Justification: In energy utilities generation operations, power plants require multiple specialized crews assigned simultaneously for different functions (operations, maintenance, environmental compliance, security, outage work). Crews are routinely assigned to multiple plants within a generation fleet, particularly in regions where plants are geographically clustered. The business actively manages these assignments with specific start/end dates, primary vs. backup designations, emergency response roles, and NERC CIP compliance tracking. | CMM: CIM Assignment (close), IEC61968::InfWork.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PlantCrewAssignment',
  'cmm.cim.class' = 'Assignment',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfWork',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-6',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.generation.plant_crew_assignment'
);

-- ========= FOREIGN KEYS within generation (57) =========
ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_generating_belongs_to_power_plant`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_generating_belongs_to_power_plant` FOREIGN KEY (`generating_belongs_to_power_plant`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_generating_power_plant_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_generating_power_plant_id` FOREIGN KEY (`generating_power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_power_plant_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `generation`.`unit_commitment` DROP CONSTRAINT IF EXISTS `fk_generation_unit_commitment_primary_generating_unit_id`;
ALTER TABLE `generation`.`unit_commitment` ADD CONSTRAINT `fk_generation_unit_commitment_primary_generating_unit_id` FOREIGN KEY (`primary_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`unit_commitment` DROP CONSTRAINT IF EXISTS `fk_generation_unit_commitment_tertiary_generating_unit_id`;
ALTER TABLE `generation`.`unit_commitment` ADD CONSTRAINT `fk_generation_unit_commitment_tertiary_generating_unit_id` FOREIGN KEY (`tertiary_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`dispatch_schedule` DROP CONSTRAINT IF EXISTS `fk_generation_dispatch_schedule_dispatch_generating_unit_id`;
ALTER TABLE `generation`.`dispatch_schedule` ADD CONSTRAINT `fk_generation_dispatch_schedule_dispatch_generating_unit_id` FOREIGN KEY (`dispatch_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`dispatch_schedule` DROP CONSTRAINT IF EXISTS `fk_generation_dispatch_schedule_dispatch_unit_commitment_id`;
ALTER TABLE `generation`.`dispatch_schedule` ADD CONSTRAINT `fk_generation_dispatch_schedule_dispatch_unit_commitment_id` FOREIGN KEY (`dispatch_unit_commitment_id`) REFERENCES `generation`.`unit_commitment` (`unit_commitment_id`);

ALTER TABLE `generation`.`dispatch_schedule` DROP CONSTRAINT IF EXISTS `fk_generation_dispatch_schedule_generating_unit_id`;
ALTER TABLE `generation`.`dispatch_schedule` ADD CONSTRAINT `fk_generation_dispatch_schedule_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`dispatch_schedule` DROP CONSTRAINT IF EXISTS `fk_generation_dispatch_schedule_primary_generating_unit_id`;
ALTER TABLE `generation`.`dispatch_schedule` ADD CONSTRAINT `fk_generation_dispatch_schedule_primary_generating_unit_id` FOREIGN KEY (`primary_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`dispatch_schedule` DROP CONSTRAINT IF EXISTS `fk_generation_dispatch_schedule_primary_unit_commitment_id`;
ALTER TABLE `generation`.`dispatch_schedule` ADD CONSTRAINT `fk_generation_dispatch_schedule_primary_unit_commitment_id` FOREIGN KEY (`primary_unit_commitment_id`) REFERENCES `generation`.`unit_commitment` (`unit_commitment_id`);

ALTER TABLE `generation`.`dispatch_schedule` DROP CONSTRAINT IF EXISTS `fk_generation_dispatch_schedule_unit_commitment_id`;
ALTER TABLE `generation`.`dispatch_schedule` ADD CONSTRAINT `fk_generation_dispatch_schedule_unit_commitment_id` FOREIGN KEY (`unit_commitment_id`) REFERENCES `generation`.`unit_commitment` (`unit_commitment_id`);

ALTER TABLE `generation`.`output_telemetry` DROP CONSTRAINT IF EXISTS `fk_generation_output_telemetry_generating_unit_id`;
ALTER TABLE `generation`.`output_telemetry` ADD CONSTRAINT `fk_generation_output_telemetry_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`output_telemetry` DROP CONSTRAINT IF EXISTS `fk_generation_output_telemetry_output_for_generating_unit`;
ALTER TABLE `generation`.`output_telemetry` ADD CONSTRAINT `fk_generation_output_telemetry_output_for_generating_unit` FOREIGN KEY (`output_for_generating_unit`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`output_telemetry` DROP CONSTRAINT IF EXISTS `fk_generation_output_telemetry_output_generating_unit_id`;
ALTER TABLE `generation`.`output_telemetry` ADD CONSTRAINT `fk_generation_output_telemetry_output_generating_unit_id` FOREIGN KEY (`output_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`output_telemetry` DROP CONSTRAINT IF EXISTS `fk_generation_output_telemetry_primary_generating_unit_id`;
ALTER TABLE `generation`.`output_telemetry` ADD CONSTRAINT `fk_generation_output_telemetry_primary_generating_unit_id` FOREIGN KEY (`primary_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`heat_rate_test` DROP CONSTRAINT IF EXISTS `fk_generation_heat_rate_test_generating_unit_id`;
ALTER TABLE `generation`.`heat_rate_test` ADD CONSTRAINT `fk_generation_heat_rate_test_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`heat_rate_test` DROP CONSTRAINT IF EXISTS `fk_generation_heat_rate_test_heat_for_generating_unit`;
ALTER TABLE `generation`.`heat_rate_test` ADD CONSTRAINT `fk_generation_heat_rate_test_heat_for_generating_unit` FOREIGN KEY (`heat_for_generating_unit`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`heat_rate_test` DROP CONSTRAINT IF EXISTS `fk_generation_heat_rate_test_heat_generating_unit_id`;
ALTER TABLE `generation`.`heat_rate_test` ADD CONSTRAINT `fk_generation_heat_rate_test_heat_generating_unit_id` FOREIGN KEY (`heat_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`fuel_inventory` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_inventory_fuel_contract_id`;
ALTER TABLE `generation`.`fuel_inventory` ADD CONSTRAINT `fk_generation_fuel_inventory_fuel_contract_id` FOREIGN KEY (`fuel_contract_id`) REFERENCES `generation`.`fuel_contract` (`fuel_contract_id`);

ALTER TABLE `generation`.`fuel_inventory` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_inventory_fuel_power_plant_id`;
ALTER TABLE `generation`.`fuel_inventory` ADD CONSTRAINT `fk_generation_fuel_inventory_fuel_power_plant_id` FOREIGN KEY (`fuel_power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `generation`.`fuel_inventory` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_inventory_generating_unit_id`;
ALTER TABLE `generation`.`fuel_inventory` ADD CONSTRAINT `fk_generation_fuel_inventory_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`fuel_inventory` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_inventory_power_plant_id`;
ALTER TABLE `generation`.`fuel_inventory` ADD CONSTRAINT `fk_generation_fuel_inventory_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `generation`.`fuel_inventory` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_inventory_primary_power_plant_id`;
ALTER TABLE `generation`.`fuel_inventory` ADD CONSTRAINT `fk_generation_fuel_inventory_primary_power_plant_id` FOREIGN KEY (`primary_power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `generation`.`emissions_reading` DROP CONSTRAINT IF EXISTS `fk_generation_emissions_reading_emissions_generating_unit_id`;
ALTER TABLE `generation`.`emissions_reading` ADD CONSTRAINT `fk_generation_emissions_reading_emissions_generating_unit_id` FOREIGN KEY (`emissions_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`emissions_reading` DROP CONSTRAINT IF EXISTS `fk_generation_emissions_reading_generating_unit_id`;
ALTER TABLE `generation`.`emissions_reading` ADD CONSTRAINT `fk_generation_emissions_reading_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`emissions_reading` DROP CONSTRAINT IF EXISTS `fk_generation_emissions_reading_power_plant_id`;
ALTER TABLE `generation`.`emissions_reading` ADD CONSTRAINT `fk_generation_emissions_reading_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `generation`.`emissions_reading` DROP CONSTRAINT IF EXISTS `fk_generation_emissions_reading_primary_generating_unit_id`;
ALTER TABLE `generation`.`emissions_reading` ADD CONSTRAINT `fk_generation_emissions_reading_primary_generating_unit_id` FOREIGN KEY (`primary_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_generating_unit_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_outage_generating_unit_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_outage_generating_unit_id` FOREIGN KEY (`outage_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_power_plant_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_primary_generating_unit_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_primary_generating_unit_id` FOREIGN KEY (`primary_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`startup_event` DROP CONSTRAINT IF EXISTS `fk_generation_startup_event_dispatch_schedule_id`;
ALTER TABLE `generation`.`startup_event` ADD CONSTRAINT `fk_generation_startup_event_dispatch_schedule_id` FOREIGN KEY (`dispatch_schedule_id`) REFERENCES `generation`.`dispatch_schedule` (`dispatch_schedule_id`);

ALTER TABLE `generation`.`startup_event` DROP CONSTRAINT IF EXISTS `fk_generation_startup_event_generating_unit_id`;
ALTER TABLE `generation`.`startup_event` ADD CONSTRAINT `fk_generation_startup_event_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`startup_event` DROP CONSTRAINT IF EXISTS `fk_generation_startup_event_market_commitment_id`;
ALTER TABLE `generation`.`startup_event` ADD CONSTRAINT `fk_generation_startup_event_market_commitment_id` FOREIGN KEY (`market_commitment_id`) REFERENCES `generation`.`unit_commitment` (`unit_commitment_id`);

ALTER TABLE `generation`.`startup_event` DROP CONSTRAINT IF EXISTS `fk_generation_startup_event_power_plant_id`;
ALTER TABLE `generation`.`startup_event` ADD CONSTRAINT `fk_generation_startup_event_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `generation`.`startup_event` DROP CONSTRAINT IF EXISTS `fk_generation_startup_event_primary_generating_unit_id`;
ALTER TABLE `generation`.`startup_event` ADD CONSTRAINT `fk_generation_startup_event_primary_generating_unit_id` FOREIGN KEY (`primary_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`startup_event` DROP CONSTRAINT IF EXISTS `fk_generation_startup_event_startup_generating_unit_id`;
ALTER TABLE `generation`.`startup_event` ADD CONSTRAINT `fk_generation_startup_event_startup_generating_unit_id` FOREIGN KEY (`startup_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`capacity_plan` DROP CONSTRAINT IF EXISTS `fk_generation_capacity_plan_capacity_power_plant_id`;
ALTER TABLE `generation`.`capacity_plan` ADD CONSTRAINT `fk_generation_capacity_plan_capacity_power_plant_id` FOREIGN KEY (`capacity_power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `generation`.`capacity_plan` DROP CONSTRAINT IF EXISTS `fk_generation_capacity_plan_power_plant_id`;
ALTER TABLE `generation`.`capacity_plan` ADD CONSTRAINT `fk_generation_capacity_plan_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `generation`.`ancillary_service_offer` DROP CONSTRAINT IF EXISTS `fk_generation_ancillary_service_offer_ancillary_generating_unit_id`;
ALTER TABLE `generation`.`ancillary_service_offer` ADD CONSTRAINT `fk_generation_ancillary_service_offer_ancillary_generating_unit_id` FOREIGN KEY (`ancillary_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`ancillary_service_offer` DROP CONSTRAINT IF EXISTS `fk_generation_ancillary_service_offer_from_generating_unit_id`;
ALTER TABLE `generation`.`ancillary_service_offer` ADD CONSTRAINT `fk_generation_ancillary_service_offer_from_generating_unit_id` FOREIGN KEY (`from_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`ancillary_service_offer` DROP CONSTRAINT IF EXISTS `fk_generation_ancillary_service_offer_generating_unit_id`;
ALTER TABLE `generation`.`ancillary_service_offer` ADD CONSTRAINT `fk_generation_ancillary_service_offer_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`ancillary_service_offer` DROP CONSTRAINT IF EXISTS `fk_generation_ancillary_service_offer_primary_generating_unit_id`;
ALTER TABLE `generation`.`ancillary_service_offer` ADD CONSTRAINT `fk_generation_ancillary_service_offer_primary_generating_unit_id` FOREIGN KEY (`primary_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`capacity_market_offer` DROP CONSTRAINT IF EXISTS `fk_generation_capacity_market_offer_capacity_generating_unit_id`;
ALTER TABLE `generation`.`capacity_market_offer` ADD CONSTRAINT `fk_generation_capacity_market_offer_capacity_generating_unit_id` FOREIGN KEY (`capacity_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`capacity_market_offer` DROP CONSTRAINT IF EXISTS `fk_generation_capacity_market_offer_from_generating_unit_id`;
ALTER TABLE `generation`.`capacity_market_offer` ADD CONSTRAINT `fk_generation_capacity_market_offer_from_generating_unit_id` FOREIGN KEY (`from_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`capacity_market_offer` DROP CONSTRAINT IF EXISTS `fk_generation_capacity_market_offer_primary_generating_unit_id`;
ALTER TABLE `generation`.`capacity_market_offer` ADD CONSTRAINT `fk_generation_capacity_market_offer_primary_generating_unit_id` FOREIGN KEY (`primary_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`gads_report` DROP CONSTRAINT IF EXISTS `fk_generation_gads_report_gads_generating_unit_id`;
ALTER TABLE `generation`.`gads_report` ADD CONSTRAINT `fk_generation_gads_report_gads_generating_unit_id` FOREIGN KEY (`gads_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`gads_report` DROP CONSTRAINT IF EXISTS `fk_generation_gads_report_generating_unit_id`;
ALTER TABLE `generation`.`gads_report` ADD CONSTRAINT `fk_generation_gads_report_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`gads_report` DROP CONSTRAINT IF EXISTS `fk_generation_gads_report_primary_generating_unit_id`;
ALTER TABLE `generation`.`gads_report` ADD CONSTRAINT `fk_generation_gads_report_primary_generating_unit_id` FOREIGN KEY (`primary_generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`fuel_contract` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_contract_fuel_power_plant_id`;
ALTER TABLE `generation`.`fuel_contract` ADD CONSTRAINT `fk_generation_fuel_contract_fuel_power_plant_id` FOREIGN KEY (`fuel_power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `generation`.`fuel_contract` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_contract_fuel_supplies_power_plant`;
ALTER TABLE `generation`.`fuel_contract` ADD CONSTRAINT `fk_generation_fuel_contract_fuel_supplies_power_plant` FOREIGN KEY (`fuel_supplies_power_plant`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `generation`.`fuel_contract` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_contract_power_plant_id`;
ALTER TABLE `generation`.`fuel_contract` ADD CONSTRAINT `fk_generation_fuel_contract_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `generation`.`plant_vendor_agreement` DROP CONSTRAINT IF EXISTS `fk_generation_plant_vendor_agreement_power_plant_id`;
ALTER TABLE `generation`.`plant_vendor_agreement` ADD CONSTRAINT `fk_generation_plant_vendor_agreement_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `generation`.`unit_crew_assignment` DROP CONSTRAINT IF EXISTS `fk_generation_unit_crew_assignment_generating_unit_id`;
ALTER TABLE `generation`.`unit_crew_assignment` ADD CONSTRAINT `fk_generation_unit_crew_assignment_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`unit_certification_requirement` DROP CONSTRAINT IF EXISTS `fk_generation_unit_certification_requirement_generating_unit_id`;
ALTER TABLE `generation`.`unit_certification_requirement` ADD CONSTRAINT `fk_generation_unit_certification_requirement_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `generation`.`facility_audit_scope` DROP CONSTRAINT IF EXISTS `fk_generation_facility_audit_scope_power_plant_id`;
ALTER TABLE `generation`.`facility_audit_scope` ADD CONSTRAINT `fk_generation_facility_audit_scope_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `generation`.`plant_crew_assignment` DROP CONSTRAINT IF EXISTS `fk_generation_plant_crew_assignment_power_plant_id`;
ALTER TABLE `generation`.`plant_crew_assignment` ADD CONSTRAINT `fk_generation_plant_crew_assignment_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

