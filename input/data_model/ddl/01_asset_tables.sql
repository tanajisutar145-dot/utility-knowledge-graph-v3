-- Utility CMM-aligned Canonical Data Model (Silver) v1.0.0 | source: Databricks lakehouse-industry-data-models energy_utilities v1 ECM | generated 2026-10-13
-- 01 | Subject area: asset | 21 tables | CIM packages: IEC61968::Assets; IEC61968::Work; IEC61968::InfERPSupport
-- Standards: IEC 61968-4; IEC 61968-6; ISO 55000/55001; ISO 14224
-- Contents: tables (with PK + NOT NULL), then intra-subject-area foreign keys.
-- Unity Catalog PK/FK constraints are informational (NOT ENFORCED); NOT NULL is enforced.

USE CATALOG `utility_cmm_silver`;

-- AssetRegistry  <<CIM Asset : exact>>
CREATE TABLE IF NOT EXISTS `asset`.`registry` (
  `registry_id` BIGINT NOT NULL COMMENT 'Unique identifier for the asset registry record. Primary key for the asset registry product.',
  `class_id` BIGINT COMMENT 'Foreign key linking to asset.asset_class. Business justification: asset_registry currently has asset_class (STRING) attribute storing class name/code. This should be normalized to FK pointing to asset_class reference table. The asset_class product is the authoritati',
  `manufacturer_vendor_id` BIGINT COMMENT 'Foreign key linking to supply.vendor. Business justification: Assets have OEM manufacturers tracked as vendors for warranty claims, technical support, and spare parts procurement. Formalizes manufacturer field into vendor master for supplier performance tracking',
  `parent_asset_registry_id` BIGINT COMMENT 'Reference to the parent asset in a hierarchical asset structure (e.g., a relay\'s parent transformer, a component\'s parent assembly). Enables bill-of-materials and asset hierarchy navigation.',
  `acquisition_cost` DECIMAL(18,2) COMMENT 'Original purchase or construction cost of the asset in USD. Used for depreciation calculations and financial reporting.',
  `asset_class` STRING COMMENT 'High-level classification of the asset type based on utility functional area. Used for portfolio segmentation and regulatory reporting. Reference-value candidates: generation|transmission|distribution|substation|protection|metering|fleet|facility.',
  `asset_condition_rating` STRING COMMENT 'Current physical and operational condition assessment of the asset based on inspection and testing. Drives maintenance prioritization and replacement planning. Valid values: excellent|good|fair|poor|critical.',
  `asset_name` STRING COMMENT 'Human-readable name or title of the asset for identification and reporting purposes.',
  `asset_tag` STRING COMMENT 'Externally-known unique asset identifier assigned by the utility for tracking and identification purposes. Used across maintenance, inventory, and financial systems. Pattern: ^[A-Z0-9]{8,20}$.',
  `asset_type` STRING COMMENT 'Detailed asset type within the asset class (e.g., power transformer, circuit breaker, transmission tower, distribution pole, generation turbine, relay). Reference-value candidates: power_transformer|circuit_breaker|transmission_tower|distribution_pole|generation_turbine|combustion_turbine|steam_turbine|relay|capacitor_bank|voltage_regulator|recloser|sectionalizer|switchgear|substation_battery|diesel_generator|service_vehicle|bucket_truck|operations_center|warehouse.',
  `book_value` DECIMAL(18,2) COMMENT 'Current net book value of the asset after accumulated depreciation. Updated periodically based on depreciation schedules.',
  `capacity_unit` STRING COMMENT 'Unit of measure for the rated capacity field (Megawatt, Megavolt-Ampere, Kilovolt, Kilovolt-Ampere, Ampere, Kiloampere). Valid values: MW|MVA|kV|kVA|A|kA.',
  `commissioning_date` DATE COMMENT 'Date when the asset was placed into service and became operational. Used for depreciation calculations and lifecycle planning.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this asset registry record was first created in the system. Used for data lineage and audit trail.',
  `criticality_score` INT COMMENT 'Numerical score (typically 1-10) representing the asset\'s criticality to grid reliability and customer service. Used for maintenance prioritization and risk assessment.',
  `data_source_system` STRING COMMENT 'Name of the source system that provided this asset record (e.g., Ventyx Asset Suite, SAP PM, GIS). Used for data lineage and reconciliation.',
  `depreciation_method` STRING COMMENT 'Accounting method used to calculate depreciation for this asset class. Typically prescribed by regulatory authority. Valid values: straight_line|declining_balance|units_of_production|regulatory.',
  `environmental_compliance_flag` BOOLEAN COMMENT 'Indicates whether this asset is subject to EPA environmental regulations (e.g., emissions monitoring, hazardous materials handling, PCB transformer tracking).',
  `failure_risk_category` STRING COMMENT 'Risk category for asset failure based on condition, age, and operational stress. Drives preventive maintenance and replacement strategies. Valid values: low|medium|high|critical.',
  `ferc_account_code` STRING COMMENT 'FERC Uniform System of Accounts code for financial classification of the asset. Required for regulatory financial reporting and rate case filings. Pattern: ^[0-9]{3}(\\.[0-9]{1,2})?$.',
  `installation_date` DATE COMMENT 'Date when the asset was physically installed at its location, which may precede commissioning date.',
  `last_inspection_date` DATE COMMENT 'Date of the most recent formal inspection or condition assessment performed on the asset.',
  `last_maintenance_date` DATE COMMENT 'Date of the most recent completed maintenance work order for this asset. Used to calculate next maintenance due dates.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this asset registry record was most recently modified. Used for change tracking and data synchronization.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the asset location in decimal degrees. Used for GIS mapping and outage analysis.',
  `location_description` STRING COMMENT 'Human-readable description of the asset\'s physical location (e.g., substation name, pole number, facility address).',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the asset location in decimal degrees. Used for GIS mapping and outage analysis.',
  `maintenance_strategy` STRING COMMENT 'Assigned maintenance approach for this asset based on criticality, failure modes, and cost-benefit analysis. Determines work order generation rules. Valid values: reactive|preventive|predictive|condition_based|run_to_failure.',
  `model_number` STRING COMMENT 'Manufacturer\'s model or part number for the asset. Used for spare parts procurement and technical specifications lookup.',
  `nerc_critical_asset_flag` BOOLEAN COMMENT 'Indicates whether this asset is designated as a NERC Critical Cyber Asset or Critical Infrastructure Protection (CIP) asset, requiring enhanced security and compliance controls.',
  `next_inspection_due_date` DATE COMMENT 'Scheduled date for the next required inspection based on regulatory requirements or maintenance strategy.',
  `next_maintenance_due_date` DATE COMMENT 'Scheduled date for the next planned maintenance activity based on maintenance strategy and interval rules.',
  `operational_status` STRING COMMENT 'Current operational state of the asset in its lifecycle. Determines availability for grid operations and maintenance planning. Valid values: in_service|out_of_service|standby|retired|under_construction|commissioned.',
  `ownership_type` STRING COMMENT 'Legal ownership classification of the asset. Determines financial treatment, maintenance responsibility, and regulatory reporting requirements. Valid values: owned|leased|joint_ownership|customer_owned|third_party.',
  `rab_inclusion_flag` BOOLEAN COMMENT 'Indicates whether this asset is included in the Regulatory Asset Base for rate-making purposes. Critical for CAPEX planning and rate case preparation.',
  `rated_capacity` DECIMAL(18,4) COMMENT 'Nameplate capacity or rating of the asset in its primary unit of measure (MW for generation, MVA for transformers, kV for voltage equipment). Critical for grid planning and load management.',
  `record_active_flag` BOOLEAN COMMENT 'Indicates whether this asset registry record is currently active and valid. Used for soft deletes and historical record retention.',
  `retirement_date` DATE COMMENT 'Date when the asset was permanently removed from service and retired. Triggers final depreciation and asset disposal processes.',
  `serial_number` STRING COMMENT 'Unique serial number assigned by the manufacturer to this specific asset unit. Critical for warranty tracking and asset identity verification.',
  `service_territory` STRING COMMENT 'Utility service territory or operating region where the asset is located. Used for regulatory reporting and operational planning.',
  `useful_life_years` INT COMMENT 'Expected useful life of the asset in years as determined by engineering standards or regulatory guidance. Used for depreciation and replacement planning.',
  `voltage_class_kv` DECIMAL(10,2) COMMENT 'Nominal voltage class of the asset in kilovolts. Used for grid segmentation and equipment compatibility analysis.',
  `warranty_expiration_date` DATE COMMENT 'Date when the manufacturer\'s warranty coverage expires. Important for maintenance cost planning and vendor claims.',
  `gis_location_id` BIGINT COMMENT 'Reference to the canonical CIM Location (gis.location) holding this entity\'s geometry, CRS and address. Implements CIM association Asset.Location.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_registry` PRIMARY KEY (`registry_id`)
)
USING DELTA
COMMENT 'Master record for all utility physical assets including generation units, transmission towers, distribution poles, transformers, switchgear, protection relays, substation equipment, fleet vehicles, and facilities. Captures asset identity, classification, installation details, location (GIS coordinates), manufacturer, model, serial number, commissioning date, rated capacity, voltage class, asset condition rating, operational status, regulatory classification, and RAB (Regulatory Asset Base) inclusion flag. SSOT for asset identity across the enterprise, sourced from Ventyx Asset Suite EAM. | CMM: CIM Asset (exact), IEC61968::Assets.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AssetRegistry',
  'cmm.cim.class' = 'Asset',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Assets',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.registry',
  'cmm.gis.location.role' = 'Asset.Location'
);

-- AssetHierarchy  <<CIM AssetContainer : close>>
CREATE TABLE IF NOT EXISTS `asset`.`hierarchy` (
  `hierarchy_id` BIGINT NOT NULL COMMENT 'Unique identifier for the asset hierarchy relationship record. Primary key for the asset hierarchy product.',
  `child_asset_asset_registry_id` BIGINT COMMENT 'Reference to the child asset in the hierarchy structure. Links to the asset registry for the lower-level asset (e.g., equipment, component, device).',
  `hierarchy_employee_id` BIGINT COMMENT 'Identifier of the user or system account that created this hierarchy relationship record. Used for audit trail and data governance. Links to enterprise identity management system.',
  `hierarchy_last_modified_by_user_employee_id` BIGINT COMMENT 'Identifier of the user or system account that last modified this hierarchy relationship record. Used for audit trail and change tracking. Links to enterprise identity management system.',
  `hierarchy_registry_id` BIGINT COMMENT 'Reference to the parent asset in the hierarchy structure. Links to the asset registry for the higher-level asset (e.g., substation, facility, network segment).',
  `cost_allocation_percentage` DECIMAL(5,2) COMMENT 'Percentage of OPEX and CAPEX costs allocated to this hierarchical relationship. Used when a child asset serves multiple parent facilities or network segments and costs must be apportioned. Value between 0.00 and 100.00. Supports regulatory cost allocation and rate case preparation.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this hierarchy relationship record was first created in the system. Used for audit trail, data lineage tracking, and regulatory compliance. Immutable after initial creation.',
  `criticality_inherited_flag` BOOLEAN COMMENT 'Indicates whether the child asset inherits the criticality classification from the parent asset in the hierarchy. True means child criticality is derived from parent (e.g., all equipment in a critical substation is critical). False means child has independent criticality assessment. Used for risk-based maintenance prioritization and outage impact analysis.',
  `depth` INT COMMENT 'Total depth of the hierarchy tree from this relationship to the deepest leaf node. Used for hierarchy complexity analysis and query optimization. Updated when child relationships are added or removed.',
  `effective_end_date` DATE COMMENT 'Date when this hierarchical relationship ended or was superseded. Null for currently active relationships. Supports historical hierarchy reconstruction for regulatory reporting, asset lifecycle analysis, and audit trails.',
  `effective_start_date` DATE COMMENT 'Date when this hierarchical relationship became active. Supports temporal hierarchy tracking for asset relocations, network reconfigurations, and organizational restructuring. Used for point-in-time hierarchy queries and historical CAPEX/OPEX roll-up.',
  `functional_location_code` STRING COMMENT 'Structured functional location identifier from the enterprise asset management system representing the hierarchical path (e.g., NORTH-SUB132-BAY03-CB01). Aligns with SAP S/4HANA Plant Maintenance functional location structure and Ventyx Asset Suite location hierarchy. Used for work order assignment, maintenance planning, and cost center allocation.',
  `geographic_zone_code` STRING COMMENT 'Geographic or service territory zone identifier for the hierarchical relationship. Used for regional reporting, storm response planning, mutual aid coordination, and geographic cost allocation. Aligns with GIS-based service territory boundaries.',
  `hierarchy_level` INT COMMENT 'Numeric level in the hierarchy tree structure where level 1 is the top-most parent (e.g., network segment, region) and higher numbers represent deeper nesting (e.g., level 5 might be a component within equipment within a bay within a substation within a zone). Supports depth-based queries and roll-up aggregations.',
  `hierarchy_type` STRING COMMENT 'Classification of the hierarchical relationship type. Functional location represents organizational structure (e.g., substation > bay > equipment). Electrical connectivity represents electrical network topology. Linear asset represents sequential physical assets (e.g., transmission line spans). Spatial containment represents physical location nesting. Logical grouping represents business-defined asset groups. System subsystem represents system decomposition. Valid values: functional_location|electrical_connectivity|linear_asset|spatial_containment|logical_grouping|system_subsystem.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this hierarchy relationship record was last modified. Updated whenever any attribute changes. Used for audit trail, change detection, and incremental data processing.',
  `maintenance_responsibility_code` STRING COMMENT 'Code identifying the organizational unit or crew responsible for maintenance of assets in this hierarchical relationship. Used for work order routing, preventive maintenance scheduling, and O&M cost tracking. May differ from parent asset responsibility for shared or outsourced maintenance scenarios.',
  `network_segment_code` STRING COMMENT 'Business identifier for the top-level network segment or zone in the hierarchy (e.g., Northern Transmission Zone, Metro Distribution Area). Used for regulatory reporting by network segment, RAB valuation aggregation, and CAPEX/OPEX planning at the network level.',
  `outage_impact_propagation_flag` BOOLEAN COMMENT 'Indicates whether an outage of the parent asset automatically impacts the child asset in this hierarchical relationship. True means child is dependent on parent (e.g., feeder outage when substation is out). False means child can operate independently. Used for outage management, customer impact analysis, and SAIDI/SAIFI calculation.',
  `ownership_percentage` DECIMAL(5,2) COMMENT 'Percentage of ownership or allocation of the child asset to this parent relationship. Used for jointly-owned assets, shared facilities, or cost allocation scenarios where a single asset may have multiple parent relationships with fractional ownership. Value between 0.00 and 100.00. Null for full ownership (100%).',
  `path` STRING COMMENT 'Materialized path representation of the full hierarchical lineage from root to this relationship (e.g., /REGION_NORTH/ZONE_132KV/SUB_NORTHSIDE/BAY_03/). Enables efficient ancestor and descendant queries without recursive joins. Updated when hierarchy structure changes.',
  `planning_area_code` STRING COMMENT 'Integrated resource planning area or load zone identifier for the hierarchical relationship. Used for CAPEX planning, load forecasting aggregation, and IRP scenario modeling. Aligns with transmission planning zones and distribution planning areas.',
  `rab_allocation_flag` BOOLEAN COMMENT 'Indicates whether this hierarchical relationship is used for RAB valuation roll-up and regulatory rate base calculations. True means the relationship is included in RAB aggregation. False means the relationship is excluded (e.g., non-regulated assets, assets under construction). Critical for regulatory financial reporting and rate case preparation.',
  `relationship_notes` STRING COMMENT 'Free-text notes documenting special conditions, exceptions, or business context for this hierarchical relationship. May include reasons for non-standard configurations, temporary arrangements during capital projects, or regulatory reporting exceptions.',
  `relationship_sequence` INT COMMENT 'Ordinal position of the child asset among siblings under the same parent. Used for ordered hierarchies such as linear assets (transmission tower sequence along a line) or bay numbering within a substation. Null for unordered hierarchies.',
  `relationship_status` STRING COMMENT 'Current lifecycle status of the hierarchical relationship. Active indicates the relationship is currently in effect. Inactive indicates the relationship has been terminated. Pending indicates a planned future relationship. Superseded indicates the relationship was replaced by a newer configuration. Planned indicates a relationship scheduled for future capital projects. Valid values: active|inactive|pending|superseded|planned.',
  `scada_aggregation_flag` BOOLEAN COMMENT 'Indicates whether SCADA measurements from child assets are aggregated to the parent level in this hierarchy. True means real-time data is rolled up (e.g., substation total load from individual feeders). False means no aggregation. Used for EMS and DMS real-time monitoring and control.',
  `source_system_code` STRING COMMENT 'Identifier of the operational system of record that is the authoritative source for this hierarchy relationship (e.g., VENTYX_ASSET_SUITE, SAP_PM, ARCGIS_UTILITY_NETWORK). Used for data lineage tracking, reconciliation, and master data management. Critical for multi-system integration scenarios.',
  `source_system_record_code` STRING COMMENT 'Primary key or unique identifier of this hierarchy relationship record in the source operational system. Used for bidirectional traceability, data synchronization, and issue resolution. Enables drill-back to source system for detailed investigation.',
  `voltage_level_kv` DECIMAL(10,3) COMMENT 'Nominal voltage level in kilovolts for electrical connectivity hierarchies. Represents the voltage class of the hierarchical relationship (e.g., 500kV transmission, 132kV sub-transmission, 11kV distribution). Used for network topology analysis and voltage-based asset segmentation. Null for non-electrical hierarchies.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_hierarchy` PRIMARY KEY (`hierarchy_id`)
)
USING DELTA
COMMENT 'Defines the parent-child structural hierarchy of utility assets, enabling roll-up from component level (e.g., circuit breaker trip coil) to equipment level (e.g., 132kV circuit breaker) to functional location (e.g., substation bay 3) to facility (e.g., Northside 132kV Substation) to network segment (e.g., Northern Transmission Zone). Each hierarchy record captures parent asset reference, child asset reference, hierarchy level, hierarchy type (functional location, linear asset, electrical connectivity), and effective date range. Supports CAPEX/OPEX cost roll-up, condition aggregation, RAB valuation at any hierarchy level, and regulatory reporting by network segment. Aligned with Ventyx Asset Suite functional location structure, SAP S/4HANA Plant Maintenance hierarchy, and IEC 61968 CIM asset model. | CMM: CIM AssetContainer (close), IEC61968::Assets.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AssetHierarchy',
  'cmm.cim.class' = 'AssetContainer',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Assets',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.hierarchy'
);

-- AssetClass  <<CIM AssetInfo : extension>>
CREATE TABLE IF NOT EXISTS `asset`.`class` (
  `class_id` BIGINT NOT NULL COMMENT 'Unique identifier for the asset class record. Primary key.',
  `standard_material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: Asset classes define standard material types for procurement planning and inventory stocking strategies. Utilities standardize materials by asset class for economies of scale and interoperability—crit',
  `annual_om_cost_per_unit_usd` DECIMAL(12,2) COMMENT 'Standard annual Operations and Maintenance cost per asset unit in this class. Includes routine maintenance, inspections, and minor repairs. Used for OPEX budgeting and lifecycle cost analysis.',
  `asset_category` STRING COMMENT 'High-level functional category of the asset class within the utility value chain. Determines applicable regulatory frameworks and operational management systems. Reference-value candidates: generation|transmission|distribution|metering|fleet|facility|substation|protection|scada.',
  `asset_class_code` STRING COMMENT 'Standardized alphanumeric code uniquely identifying the asset class within the utility\'s asset taxonomy. Used for regulatory reporting and financial accounting groupings. Pattern: ^[A-Z0-9]{4,12}$.',
  `asset_class_name` STRING COMMENT 'Full descriptive name of the asset class (e.g., \'Combined Cycle Gas Turbine\', \'Power Transformer 230kV\', \'Underground Distribution Cable\').',
  `asset_type` STRING COMMENT 'Specific technology or equipment type within the asset category (e.g., \'CCGT\', \'Wind Turbine\', \'Overhead Line\', \'Underground Cable\', \'Circuit Breaker\', \'Relay\').',
  `capacity_rating_mw` DECIMAL(12,3) COMMENT 'Nameplate capacity rating in megawatts for generation assets or power handling capacity for transmission/distribution equipment. Null for non-power assets.',
  `capital_expenditure_flag` BOOLEAN COMMENT 'Indicates whether acquisition of assets in this class is typically capitalized (true) or expensed as Operations and Maintenance (OPEX) (false) per accounting policies.',
  `class_status` STRING COMMENT 'Current lifecycle status of this asset class definition in the utility\'s asset taxonomy. Only active classes are available for new asset registration. Valid values: active|inactive|deprecated|proposed.',
  `condition_assessment_method` STRING COMMENT 'Primary technique(s) used for condition-based health assessment of assets in this class. Supports predictive maintenance and asset replacement prioritization. Reference-value candidates: visual_inspection|diagnostic_testing|dissolved_gas_analysis|thermography|partial_discharge|vibration_analysis|oil_analysis.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this asset class record was first created in the system. Supports audit trail and data lineage tracking.',
  `criticality_rating` STRING COMMENT 'Standard criticality classification for assets in this class based on impact to grid reliability, customer service, and safety. Influences maintenance prioritization and spare parts stocking. Valid values: critical|high|medium|low.',
  `cybersecurity_classification` STRING COMMENT 'NERC Critical Infrastructure Protection (CIP) cybersecurity impact classification for assets in this class. Determines required cyber controls and monitoring. Valid values: high_impact|medium_impact|low_impact|not_applicable.',
  `depreciation_method` STRING COMMENT 'Standard accounting depreciation method applied to assets in this class for financial reporting and Regulatory Asset Base (RAB) valuation. Valid values: straight_line|declining_balance|sum_of_years_digits|units_of_production.',
  `distributed_energy_resource_flag` BOOLEAN COMMENT 'Indicates whether assets in this class are Distributed Energy Resources requiring integration with Distributed Energy Resource Management System (DERMS) and Advanced Distribution Management System (ADMS).',
  `effective_date` DATE COMMENT 'Date when this asset class definition became effective for use in asset registry and capital planning. Supports historical asset classification tracking.',
  `environmental_impact_category` STRING COMMENT 'Classification of potential environmental impact from operation or failure of assets in this class. Drives EPA compliance requirements and environmental monitoring protocols. Valid values: high|medium|low|none.',
  `expected_useful_life_years` INT COMMENT 'Standard expected service life in years for this asset class. Used for depreciation calculations, capital planning, and replacement forecasting.',
  `expiration_date` DATE COMMENT 'Date when this asset class definition was retired or superseded. Null for currently active asset classes. Supports asset taxonomy version control.',
  `failure_mode_profile` STRING COMMENT 'Typical failure modes and mechanisms for assets in this class (e.g., \'insulation degradation\', \'mechanical wear\', \'corrosion\'). Informs reliability-centered maintenance strategies.',
  `ferc_account_code` STRING COMMENT 'FERC Uniform System of Accounts code for capitalization and depreciation reporting. Maps asset class to regulatory accounting categories. Pattern: ^[0-9]{3,6}$.',
  `gis_layer_name` STRING COMMENT 'Standard GIS feature class or layer name in Esri ArcGIS Utility Network where assets of this class are spatially represented for network modeling and outage analysis.',
  `grid_modernization_category` STRING COMMENT 'Classification of assets in this class within utility grid modernization and smart grid investment programs. Used for capital planning and regulatory cost recovery filings. Valid values: advanced_metering|distribution_automation|grid_sensors|energy_storage|ev_infrastructure|legacy.',
  `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether assets in this class contain or use hazardous materials (e.g., PCBs in transformers, SF6 in switchgear) requiring special handling and disposal procedures.',
  `iec_standard_reference` STRING COMMENT 'Applicable IEC international standard(s) governing design, testing, and operation of assets in this class (e.g., \'IEC 60076\' for power transformers).',
  `ieee_standard_reference` STRING COMMENT 'Applicable IEEE standard(s) for equipment specifications, testing, and maintenance practices (e.g., \'IEEE C57.12.00\' for transformers).',
  `inspection_frequency_months` INT COMMENT 'Standard interval in months between scheduled inspections for assets in this class. Null if inspection frequency is condition-based rather than time-based.',
  `interoperability_standard` STRING COMMENT 'Communication protocol or interoperability standard for assets in this class (e.g., \'DNP3\', \'IEC 61850\', \'Modbus\', \'IEEE 2030.5\'). Ensures integration with utility control systems.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this asset class record. Supports change tracking and data quality monitoring.',
  `maintenance_strategy` STRING COMMENT 'Standard maintenance approach for assets in this class. Drives work order scheduling, inspection intervals, and Operations and Maintenance (O&M) cost planning. Valid values: preventive|predictive|condition_based|run_to_failure|reliability_centered.',
  `manufacturer_diversity_required_flag` BOOLEAN COMMENT 'Indicates whether reliability standards or utility policy require multiple manufacturers for assets in this class to mitigate common-mode failure risk.',
  `mean_time_between_failures_hours` DECIMAL(12,2) COMMENT 'Industry-standard or utility-specific average operating hours between failures for assets in this class. Used for reliability modeling and spare parts planning.',
  `mean_time_to_repair_hours` DECIMAL(10,2) COMMENT 'Average time in hours required to restore an asset in this class to service following a failure. Includes diagnosis, parts procurement, repair, and testing time.',
  `nerc_asset_type` STRING COMMENT 'NERC-defined asset type classification for bulk electric system reliability reporting and Critical Infrastructure Protection (CIP) compliance.',
  `obsolescence_risk_rating` STRING COMMENT 'Assessment of technology obsolescence and spare parts availability risk for assets in this class. High risk indicates limited vendor support or discontinued product lines. Valid values: high|medium|low|none.',
  `rab_eligible_flag` BOOLEAN COMMENT 'Indicates whether assets in this class are eligible for inclusion in the Regulatory Asset Base for rate recovery and Return on Equity (ROE) calculation.',
  `renewable_energy_flag` BOOLEAN COMMENT 'Indicates whether assets in this class are renewable energy generation or Distributed Energy Resource (DER) equipment eligible for Renewable Energy Certificate (REC) generation and Renewable Portfolio Standard (RPS) compliance.',
  `replacement_lead_time_months` INT COMMENT 'Typical procurement and installation lead time in months for new assets in this class. Critical for capital project planning and long-lead equipment identification.',
  `safety_classification` STRING COMMENT 'Primary safety hazard category for work on assets in this class. Determines required safety training, personal protective equipment (PPE), and work clearance procedures. Valid values: high_voltage|confined_space|elevated_work|heavy_equipment|standard.',
  `scada_monitoring_required_flag` BOOLEAN COMMENT 'Indicates whether assets in this class require real-time SCADA monitoring and integration with Energy Management System (EMS) or Distribution Management System (DMS).',
  `spare_parts_stocking_strategy` STRING COMMENT 'Standard inventory management approach for spare parts supporting assets in this class. Balances inventory carrying costs against outage risk and restoration time. Valid values: critical_spare|insurance_spare|consignment|just_in_time|no_stock.',
  `standard_unit_cost_usd` DECIMAL(15,2) COMMENT 'Baseline unit acquisition cost in USD for assets in this class. Used for capital budgeting, business case analysis, and Regulatory Asset Base (RAB) valuation. Excludes installation and commissioning costs.',
  `technology_generation` STRING COMMENT 'Technology vintage or generation for assets in this class (e.g., \'Gen 1\', \'Gen 2\', \'Legacy\', \'Current\', \'Next-Gen\'). Tracks technology evolution and obsolescence risk.',
  `voltage_class_kv` DECIMAL(10,2) COMMENT 'Nominal voltage rating in kilovolts for electrical assets. Null for non-electrical assets (fleet, facilities). Determines applicable safety and maintenance protocols.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_class` PRIMARY KEY (`class_id`)
)
USING DELTA
COMMENT 'Reference classification taxonomy for utility asset types defining asset class codes, asset category (generation, transmission, distribution, metering, fleet, facility), voltage class, technology type (CCGT, wind turbine, overhead line, underground cable, power transformer, circuit breaker, etc.), expected useful life, standard depreciation method, and applicable NERC/IEC/IEEE standards. Drives depreciation schedules, maintenance strategies, and regulatory reporting groupings. | CMM: CIM AssetInfo (extension), IEC61968::Assets.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AssetClass',
  'cmm.cim.class' = 'AssetInfo',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Assets',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'reference_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.class'
);

-- WorkOrder  <<CIM Work : exact>>
CREATE TABLE IF NOT EXISTS `asset`.`work_order` (
  `work_order_id` BIGINT NOT NULL COMMENT 'Unique identifier for the work order. Primary key for the work order entity.',
  `asset_registry_id` BIGINT COMMENT 'FK to asset.asset_registry.asset_registry_id — Every work order is executed against a specific asset. This is the most fundamental FK in any EAM system — work orders without asset references are unroutable and uncosted.',
  `assigned_crew_id` BIGINT COMMENT 'Reference to the internal utility crew or work group assigned to execute this work order. May be null if work is assigned to an external contractor.',
  `compliance_obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Work orders are frequently driven by regulatory compliance obligations (NERC CIP maintenance requirements, environmental permit conditions, safety inspection mandates). Compliance-driven maintenance s',
  `contractor_worker_id` BIGINT COMMENT 'Reference to the external contractor or service provider assigned to execute this work order. May be null if work is performed by internal crews.',
  `cost_center_id` BIGINT COMMENT 'Financial cost center code to which this work order cost is allocated. Used for departmental budgeting, OPEX vs CAPEX classification, and regulatory reporting.',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: Maintenance and repair work orders issued against DER assets for O&M cost tracking, warranty claim documentation, and reliability metrics (SAIDI/SAIFI). Critical for performance guarantee compliance i',
  `employee_id` BIGINT COMMENT 'Reference to the supervisor or manager responsible for approving and overseeing this work order. Used for approval workflow and accountability.',
  `feeder_id` BIGINT COMMENT 'Reference to the distribution or transmission circuit affected by this work order. Used for outage impact analysis and load transfer planning.',
  `gl_account_id` BIGINT COMMENT 'General ledger account code for financial posting of work order costs. Aligns with FERC Uniform System of Accounts for utility financial reporting.',
  `interconnection_application_id` BIGINT COMMENT 'Foreign key linking to interconnection.application. Business justification: Work orders are created to perform interconnection-related construction (meter installation, service upgrades, POI modifications) and inspection support activities. Essential for tracking utility labo',
  `maintenance_plan_id` BIGINT COMMENT 'FK to asset.maintenance_plan.maintenance_plan_id — Preventive work orders are generated from maintenance plans. This FK enables tracking of PM compliance rates and plan execution history.',
  `material_purchase_order_id` BIGINT COMMENT 'Foreign key linking to supply.purchase_order. Business justification: Work orders often trigger direct material procurement for non-stock items or emergency purchases. Links work order to originating PO for cost tracking, capex/opex classification, and regulatory cost r',
  `parent_work_order_id` BIGINT COMMENT 'Reference to a parent work order if this is a child or sub-work order. Used for complex projects broken into multiple work packages.',
  `registry_id` BIGINT COMMENT 'Reference to the utility asset (generation unit, transformer, transmission tower, distribution pole, switchgear, protection relay, substation equipment, fleet vehicle, or facility) that is the subject of this work order.',
  `to_maintenance_plan_id` BIGINT COMMENT 'FK to asset.maintenance_plan.maintenance_plan_id — Preventive maintenance work orders are auto-generated from maintenance plans. The FK traces which plan triggered the work order for compliance tracking and schedule adherence reporting.',
  `transmission_line_id` BIGINT COMMENT 'Foreign key linking to transmission.line. Business justification: Maintenance work orders on transmission lines (conductor replacement, tower repair, insulator replacement, vegetation management) require direct linkage to the specific line for work planning, outage',
  `transmission_substation_id` BIGINT COMMENT 'Foreign key linking to transmission.transmission_substation. Business justification: Work orders for transmission substation maintenance (transformer servicing, breaker testing, relay calibration) require direct linkage to the specific transmission substation for work scheduling, outa',
  `work_maintenance_plan_id` BIGINT COMMENT 'Reference to the preventive maintenance schedule or plan that generated this work order. Used for PM compliance tracking and maintenance strategy optimization.',
  `actual_completion_timestamp` TIMESTAMP COMMENT 'Actual date and time when work was completed and asset returned to service. Used for outage duration reporting, SAIDI/SAIFI calculation, and maintenance cycle analysis.',
  `actual_start_timestamp` TIMESTAMP COMMENT 'Actual date and time when work commenced on site. Used for labor tracking, outage duration calculation, and performance analysis.',
  `approved_by` STRING COMMENT 'Name of the person who approved the work order for execution. Used for audit trail and authorization verification.',
  `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the work order was approved for execution. Used for approval cycle time analysis and audit trail.',
  `asset` BIGINT COMMENT 'FK to asset.asset_registry.asset_registry_id — Every work order must reference the asset it is performed against. This is the most fundamental FK in asset management — without it, maintenance costs cannot be attributed to assets, and asset history',
  `capex_flag` BOOLEAN COMMENT 'Indicates whether this work order represents capital expenditure (true) or operational expenditure (false). Capital work orders contribute to RAB valuation and depreciation schedules.',
  `closed_timestamp` TIMESTAMP COMMENT 'Date and time when the work order was administratively closed and finalized. Used for cycle time analysis and completion reporting.',
  `closure_code` STRING COMMENT 'Standardized code indicating the reason and manner of work order closure. Used for completion analysis, deferral tracking, and maintenance effectiveness metrics. Valid values: completed_as_planned|completed_with_variance|deferred|cancelled_duplicate|cancelled_not_required|cancelled_no_access.',
  `closure_notes` STRING COMMENT 'Detailed narrative notes entered by the crew or supervisor upon work order completion, documenting work performed, findings, issues encountered, and recommendations for future maintenance.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the work order record was first created in the system. Used for work order aging analysis and backlog tracking.',
  `equipment_cost` DECIMAL(15,2) COMMENT 'Cost of specialized equipment, tools, and machinery rental or usage allocated to this work order. Includes bucket trucks, cranes, diagnostic equipment, and specialized tooling.',
  `failure_mode` STRING COMMENT 'For corrective and emergency work orders, describes the observed failure or defect mode (e.g., insulation breakdown, mechanical wear, corrosion, overheating, control malfunction) that triggered the work order.',
  `labor_cost` DECIMAL(15,2) COMMENT 'Total labor cost including wages, benefits, and contractor fees for this work order. Used for O&M cost tracking and rate case justification.',
  `labor_hours` DECIMAL(10,2) COMMENT 'Total labor hours expended on this work order across all crew members and contractors. Used for OPEX tracking, productivity analysis, and cost allocation.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the work site in decimal degrees. Used for crew dispatch optimization, GIS integration, and spatial analysis.',
  `location_description` STRING COMMENT 'Textual description of the work site location including street address, nearest intersection, substation name, or geographic landmark to assist crew dispatch and navigation.',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the work site in decimal degrees. Used for crew dispatch optimization, GIS integration, and spatial analysis.',
  `material_cost` DECIMAL(15,2) COMMENT 'Total cost of materials, spare parts, and consumables used in this work order. Sourced from inventory withdrawals and purchase orders. Used for OPEX and CAPEX tracking.',
  `modified_timestamp` TIMESTAMP COMMENT 'Date and time when the work order record was last modified. Used for audit trail and change tracking.',
  `outage_required_flag` BOOLEAN COMMENT 'Indicates whether this work order requires a planned outage or de-energization of the asset or circuit. Used for outage coordination and customer notification.',
  `priority` STRING COMMENT 'Business priority level indicating urgency and resource allocation precedence. Critical for emergency outages, high for reliability-impacting work, medium for routine preventive maintenance, low for deferred work. Valid values: critical|high|medium|low.',
  `regulatory_reportable_flag` BOOLEAN COMMENT 'Indicates whether this work order must be reported to regulatory authorities (PUC, NERC, FERC) due to safety incidents, major equipment failures, or compliance events.',
  `requester_contact` STRING COMMENT 'Phone number or email address of the work order requester for follow-up communication and status updates.',
  `requester_name` STRING COMMENT 'Name of the person or department that originated the work order request. Used for accountability and follow-up communication.',
  `safety_permit_number` STRING COMMENT 'Reference number for the safety work permit or clearance authorization required before work can commence. Ensures compliance with OSHA and utility safety protocols.',
  `scheduled_completion_date` DATE COMMENT 'Planned date when work is scheduled to be completed. Used for outage window planning and service restoration commitments.',
  `scheduled_start_date` DATE COMMENT 'Planned date when work is scheduled to begin. Used for resource planning, outage coordination, and customer notification.',
  `to_asset` BIGINT COMMENT 'FK to asset.asset_registry.asset_registry_id — Every work order is raised against a specific asset. This is the most fundamental transactional-to-master FK in any EAM system. Without it, work orders are orphaned.',
  `total_cost` DECIMAL(15,2) COMMENT 'Total cost of the work order including labor, materials, equipment, and contractor fees. Used for OPEX reporting, RAB valuation, and regulatory rate case filings.',
  `warranty_flag` BOOLEAN COMMENT 'Indicates whether this work order is covered under manufacturer or contractor warranty. Used for cost recovery and warranty claim tracking.',
  `work_order_description` STRING COMMENT 'Detailed narrative description of the work to be performed, including scope, specific tasks, safety considerations, and any special instructions for the crew or contractor.',
  `work_order_number` STRING COMMENT 'Externally visible business identifier for the work order, used for tracking and communication across systems and with contractors. Pattern: ^WO-[0-9]{8,12}$.',
  `work_order_status` STRING COMMENT 'Current lifecycle state of the work order. Draft (created but not approved), approved (authorized for scheduling), scheduled (crew assigned and date set), in_progress (work underway), on_hold (temporarily suspended), completed (work finished pending closure), closed (administratively finalized), cancelled (work not performed). Reference-value candidates: draft|approved|scheduled|in_progress|on_hold|completed|closed|cancelled.',
  `work_order_type` STRING COMMENT 'Classification of the work order by maintenance strategy: preventive (scheduled maintenance), corrective (repair of known defect), emergency (unplanned urgent repair), inspection (condition assessment), capital_project (major upgrade or replacement), or condition_assessment (detailed asset evaluation). Valid values: preventive|corrective|emergency|inspection|capital_project|condition_assessment.',
  `gis_location_id` BIGINT COMMENT 'Reference to the canonical CIM Location (gis.location) holding this entity\'s geometry, CRS and address. Implements CIM association BaseWork.WorkLocation.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_work_order` PRIMARY KEY (`work_order_id`)
)
USING DELTA
COMMENT 'Core transactional record for all planned and unplanned maintenance activities on utility assets. Captures work order number, type (preventive, corrective, emergency, inspection, capital project), priority, originating asset, work description, assigned crew/contractor, scheduled start and completion dates, actual start and completion dates, labor hours, material costs, total O&M cost, work order status, safety permit references, and closure codes. Sourced from Ventyx Asset Suite Work Management module and SAP S/4HANA Plant Maintenance (PM) orders. | CMM: CIM Work (exact), IEC61968::Work.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'WorkOrder',
  'cmm.cim.class' = 'Work',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Work',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.work_order',
  'cmm.gis.location.role' = 'BaseWork.WorkLocation'
);

-- MaintenancePlan  <<CIM Procedure : close>>
CREATE TABLE IF NOT EXISTS `asset`.`maintenance_plan` (
  `maintenance_plan_id` BIGINT NOT NULL COMMENT 'Unique identifier for the maintenance plan record. Primary key.',
  `asset_class_id` BIGINT COMMENT 'FK to asset.asset_class.asset_class_id — Maintenance plans are often defined at the asset class level (e.g., all 132kV power transformers get DGA every 2 years). This FK enables class-level maintenance strategy inheritance.',
  `asset_registry_id` BIGINT COMMENT 'FK to asset.asset_registry.asset_registry_id — Maintenance plans are defined for specific assets or asset classes. The asset-level FK enables automatic work order generation for the correct asset.',
  `class_id` BIGINT COMMENT 'Reference to the asset class or equipment category for which this maintenance plan is defined. Used for template-based maintenance strategies applied across multiple assets of the same type.',
  `compliance_obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Maintenance plans implement regulatory requirements (NERC PRC-005 protection system maintenance, FERC gas pipeline integrity management, environmental permit conditions). Linking plans to obligations',
  `cost_center_id` BIGINT COMMENT 'Financial cost center to which maintenance costs (labor, materials, contractors) are charged. Used for OPEX tracking, departmental budgeting, and RAB (Regulatory Asset Base) cost allocation.',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: Preventive maintenance schedules for DER equipment (inverter inspections, battery health checks, panel cleaning) required for warranty compliance, performance guarantee tracking in PPAs, and interconn',
  `distribution_transformer_id` BIGINT COMMENT 'Foreign key linking to distribution.transformer. Business justification: Transformer maintenance plans (oil sampling, dissolved gas analysis, thermography, load tap changer servicing) are mandated by IEEE/NETA standards and insurance requirements. Links preventive maintena',
  `feeder_id` BIGINT COMMENT 'Foreign key linking to distribution.feeder. Business justification: Preventive maintenance plans are organized by feeder for patrol inspections, vegetation management, reliability-centered maintenance programs, and regulatory compliance. Enables automated work order g',
  `primary_maintenance_employee_id` BIGINT COMMENT 'Reference to the maintenance planner or engineer responsible for managing this maintenance plan, including plan updates, work order review, and execution oversight.',
  `registry_id` BIGINT COMMENT 'Reference to the specific asset (generation unit, transformer, transmission tower, distribution pole, switchgear, protection relay, substation equipment, fleet vehicle, or facility) to which this maintenance plan applies. Links to the asset registry.',
  `responsible_crew_id` BIGINT COMMENT 'Reference to the maintenance crew or work center assigned to execute work orders generated by this plan. Used for resource capacity planning and crew scheduling.',
  `service_supplier_contract_id` BIGINT COMMENT 'Foreign key linking to supply.supplier_contract. Business justification: Recurring maintenance services (vegetation management, transformer oil analysis, substation cleaning) are often contracted. Links maintenance plan to service contract for cost forecasting, contractor',
  `standard_material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: Preventive maintenance plans specify standard materials (oils, filters, consumables) for bill-of-materials planning and auto-generation of material requisitions. Essential for MRP planning, inventory',
  `transmission_line_id` BIGINT COMMENT 'Foreign key linking to transmission.line. Business justification: Transmission line maintenance plans (patrol inspections, ROW clearing, structure inspections, conductor monitoring) are line-specific. Utilities schedule preventive maintenance by line for NERC compli',
  `transmission_substation_id` BIGINT COMMENT 'Foreign key linking to transmission.transmission_substation. Business justification: Preventive maintenance plans for substation equipment (transformer oil analysis, breaker testing, relay calibration, battery testing) are organized by substation. Utilities schedule and track maintena',
  `auto_generate_work_order_flag` BOOLEAN COMMENT 'Indicates whether work orders are automatically created by the system when the maintenance plan becomes due (True) or require manual initiation by a planner (False).',
  `compliance_mandatory_flag` BOOLEAN COMMENT 'Indicates whether this maintenance plan is legally or regulatorily mandated (True) or discretionary for asset optimization (False). Mandatory plans cannot be deferred without regulatory approval.',
  `condition_trigger_parameter` STRING COMMENT 'For condition-based maintenance plans, the specific asset health parameter or SCADA measurement that triggers maintenance (e.g., oil_dielectric_strength, vibration_amplitude, temperature_differential, partial_discharge_level). Empty for time-based plans.',
  `condition_trigger_threshold` DECIMAL(12,4) COMMENT 'Numeric threshold value for the condition trigger parameter. When the monitored parameter exceeds (or falls below) this threshold, maintenance is triggered. Empty for time-based plans.',
  `condition_trigger_unit` STRING COMMENT 'Unit of measure for the condition trigger threshold (e.g., kV, ppm, mm/s, degrees_celsius, percent). Empty for time-based plans.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this maintenance plan record was first created in the system. Used for audit trail and data lineage tracking.',
  `cycle_interval_unit` STRING COMMENT 'Unit of measure for the maintenance interval: calendar units (days, weeks, months, years), operational hours, operational cycles, or energy production (MWh for generation assets). Reference-value candidates: days|weeks|months|years|hours|cycles|mwh.',
  `cycle_interval_value` INT COMMENT 'Numeric value representing the maintenance interval (e.g., 12 for annual, 5 for five-year). Used in conjunction with cycle_interval_unit to calculate next due date.',
  `cycle_type` STRING COMMENT 'Frequency or trigger pattern for maintenance execution. Time-based cycles are calendar-driven; on-condition cycles are triggered by asset health thresholds; on-demand cycles are manually initiated. Reference-value candidates: daily|weekly|monthly|quarterly|semi_annual|annual|biennial|five_year|ten_year|on_condition|on_demand.',
  `effective_end_date` DATE COMMENT 'Date when this maintenance plan is scheduled to expire or be retired. Nullable for ongoing plans. Used for asset decommissioning or maintenance strategy transitions.',
  `effective_start_date` DATE COMMENT 'Date when this maintenance plan becomes active and begins generating work orders. Used for phased rollout of new maintenance strategies or asset commissioning.',
  `estimated_contractor_cost_usd` DECIMAL(12,2) COMMENT 'Estimated cost of external contractor services required for maintenance execution, expressed in US dollars. Used for OPEX budgeting and procurement planning.',
  `estimated_labor_hours` DECIMAL(8,2) COMMENT 'Estimated total labor hours required to complete all tasks defined in the maintenance plan. Used for crew scheduling, OPEX forecasting, and resource capacity planning.',
  `estimated_material_cost_usd` DECIMAL(12,2) COMMENT 'Estimated total cost of spare parts, consumables, and materials required for maintenance execution, expressed in US dollars. Used for OPEX budgeting and inventory planning.',
  `functional_location` STRING COMMENT 'Hierarchical location identifier in the asset management system representing the physical or logical location of the asset (e.g., substation, plant, transmission line section). Used for geographic and organizational reporting.',
  `last_execution_date` DATE COMMENT 'Date when maintenance activities under this plan were last completed. Used to calculate the next due date for time-based and usage-based maintenance cycles.',
  `last_execution_work_order_number` STRING COMMENT 'Work order number of the most recent maintenance execution under this plan. Provides traceability to historical maintenance records and completion documentation. Pattern: ^WO-[A-Z0-9]{8,12}$.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this maintenance plan record was most recently updated. Used for change tracking and audit compliance.',
  `lead_time_days` INT COMMENT 'Number of days before the scheduled due date that the work order should be generated, allowing time for planning, material procurement, crew scheduling, and outage coordination.',
  `maintenance_strategy` STRING COMMENT 'High-level maintenance philosophy applied to the asset: preventive (scheduled), predictive (condition monitoring), reliability-centered (RCM analysis-driven), risk-based (prioritized by failure impact), or run-to-failure (no proactive maintenance). Valid values: preventive|predictive|reliability_centered|risk_based|run_to_failure.',
  `next_due_date` DATE COMMENT 'Calculated date when the next maintenance execution is scheduled or required. System-calculated based on last execution date, cycle interval, and usage/condition triggers.',
  `next_scheduled_work_order_number` STRING COMMENT 'Work order number of the upcoming maintenance execution that has been generated but not yet completed. Empty if no future work order has been created. Pattern: ^WO-[A-Z0-9]{8,12}$.',
  `outage_required_flag` BOOLEAN COMMENT 'Indicates whether execution of this maintenance plan requires taking the asset out of service (True) or can be performed while the asset is energized or in standby (False). Critical for outage coordination and reliability planning.',
  `plan_asset_class` BIGINT COMMENT 'FK to asset.asset_class.asset_class_id — Maintenance plans are typically defined at the asset class level (all 132kV transformers get the same PM plan). This FK enables plan-to-class association.',
  `plan_description` STRING COMMENT 'Detailed textual description of the maintenance plan objectives, scope, and special instructions. Provides context for planners and technicians executing the work.',
  `plan_name` STRING COMMENT 'Descriptive name of the maintenance plan for human identification and reporting purposes.',
  `plan_number` STRING COMMENT 'Business identifier for the maintenance plan, externally visible and used in work order generation and asset management reporting. Pattern: ^MP-[A-Z0-9]{8,12}$.',
  `plan_status` STRING COMMENT 'Current lifecycle status of the maintenance plan. Active plans generate work orders automatically; suspended plans are temporarily paused; inactive plans are disabled but retained for historical reference; retired plans are archived. Valid values: draft|active|suspended|inactive|retired.',
  `plan_type` STRING COMMENT 'Classification of the maintenance strategy: time-based (calendar-driven), condition-based (triggered by asset condition thresholds), usage-based (driven by operational hours or cycles), predictive (AI/ML-driven forecasting), regulatory (compliance-mandated), or corrective (reactive repair). Valid values: time_based|condition_based|usage_based|predictive|regulatory|corrective.',
  `planning_plant_code` STRING COMMENT 'Organizational unit responsible for maintenance planning and execution. Aligns with SAP PM planning plant structure for multi-site utility operations. Pattern: ^PP-[A-Z0-9]{4,8}$.',
  `priority` STRING COMMENT 'Business priority level for maintenance execution. Critical plans address safety or regulatory compliance; high priority plans prevent major outages; medium and low priority plans optimize asset performance and lifecycle cost. Valid values: critical|high|medium|low.',
  `regulatory_driver` STRING COMMENT 'Specific regulatory standard, code, or compliance requirement that mandates this maintenance plan (e.g., NERC FAC-003 Transmission Vegetation Management, NERC PRC-005 Protection System Maintenance, OSHA 1910.269 Electric Power Generation). Empty if not compliance-driven.',
  `safety_requirements` STRING COMMENT 'Specific safety protocols, personal protective equipment (PPE), lockout/tagout (LOTO) procedures, or clearance requirements mandated for maintenance execution under this plan. Ensures OSHA 1910.269 compliance.',
  `scheduling_window_days` INT COMMENT 'Allowable time window (in days) after the due date within which maintenance can be performed without being considered overdue. Provides scheduling flexibility for resource optimization and outage coordination.',
  `task_list_reference` STRING COMMENT 'Reference code to the detailed task list or work instruction document that defines the specific maintenance activities, inspection points, and procedures to be executed under this plan. Pattern: ^TL-[A-Z0-9]{6,10}$.',
  `to_asset` BIGINT COMMENT 'FK to asset.asset_registry.asset_registry_id — Maintenance plans are assigned to specific assets or asset classes. The FK to asset_registry enables plan-to-asset resolution for work order generation.',
  `usage_trigger_parameter` STRING COMMENT 'For usage-based maintenance plans, the operational metric that triggers maintenance (e.g., operating hours for turbines, breaker operations for circuit breakers, MWh generated for generators). Empty for time-based and condition-based plans. Valid values: operating_hours|start_stop_cycles|mwh_generated|breaker_operations|tap_changer_operations.',
  `usage_trigger_threshold` DECIMAL(12,2) COMMENT 'Numeric threshold value for the usage trigger parameter. When cumulative usage since last maintenance reaches this threshold, maintenance is triggered. Empty for time-based and condition-based plans.',
  `work_order_type` STRING COMMENT 'Classification of work orders automatically generated by this maintenance plan. Determines work order routing, approval workflows, and cost accounting treatment in Ventyx Asset Suite and SAP PM. Reference-value candidates: preventive_maintenance|predictive_maintenance|inspection|calibration|testing|overhaul|refurbishment.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_maintenance_plan` PRIMARY KEY (`maintenance_plan_id`)
)
USING DELTA
COMMENT 'Preventive and predictive maintenance strategy definition for an asset class or individual asset. Captures maintenance plan type (time-based, condition-based, usage-based), maintenance cycle (e.g., annual, 5-year), task list reference, required materials, estimated labor hours, regulatory compliance driver (e.g., NERC FAC-003, OSHA), last execution date, next due date, and plan active status. Drives automatic work order generation in Ventyx Asset Suite and SAP PM. | CMM: CIM Procedure (close), IEC61968::Assets.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MaintenancePlan',
  'cmm.cim.class' = 'Procedure',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Assets',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.maintenance_plan'
);

-- FailureEvent  <<CIM FailureEvent : exact>>
CREATE TABLE IF NOT EXISTS `asset`.`failure_event` (
  `failure_event_id` BIGINT NOT NULL COMMENT 'Unique identifier for the asset failure event record. Primary key.',
  `asset_registry_id` BIGINT COMMENT 'FK to asset.asset_registry.asset_registry_id — Failure events must reference the failed asset for reliability analysis, MTBF calculations, and NERC reporting. Core FK for RCM analysis.',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: DER equipment failures (inverter trips, battery faults, turbine blade damage) tracked for reliability analysis, warranty claims, RPS compliance reporting, and NERC event reporting. Required for root c',
  `distribution_transformer_id` BIGINT COMMENT 'Foreign key linking to distribution.transformer. Business justification: Transformer failures are major reliability events requiring detailed tracking for warranty claims, manufacturer defect analysis, fleet health assessment, and replacement prioritization. Essential for',
  `dr_event_id` BIGINT COMMENT 'Foreign key linking to demand.dr_event. Business justification: Asset failures may be triggered by DR events (transformer overload during rapid load restoration, relay misoperation during curtailment) or cause DR event cancellation. Reliability engineers analyze c',
  `event_id` BIGINT COMMENT 'Reference to the associated outage event if the failure caused a customer outage. Links to outage management system.',
  `failed_component_material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: Failure events identify specific failed components for reliability analysis, warranty claims, and defect tracking. Links failure to material master for supplier quality management, mean-time-between-f',
  `failure_work_order_id` BIGINT COMMENT 'Reference to the corrective maintenance work order created to address the failure.',
  `feeder_id` BIGINT COMMENT 'Foreign key linking to distribution.feeder. Business justification: Failure events must be attributed to feeders for IEEE 1366 reliability reporting (SAIDI/SAIFI/CAIDI), root cause analysis, worst-performing feeder identification, and targeted reliability improvement',
  `primary_work_order_id` BIGINT COMMENT 'FK to asset.work_order.work_order_id — Failure events typically generate corrective work orders. Linking failure to repair enables cost-of-failure analysis and RCM.',
  `registry_id` BIGINT COMMENT 'Reference to the asset that experienced the failure. Links to the asset registry in Ventyx Asset Suite.',
  `self_report_id` BIGINT COMMENT 'Foreign key linking to compliance.self_report. Business justification: Certain asset failures trigger mandatory self-reporting to NERC (bulk electric system events) or state regulators (major outages, safety incidents). Direct link enables regulatory incident reporting w',
  `to_work_order_id` BIGINT COMMENT 'FK to asset.work_order.work_order_id — Failure events typically generate corrective work orders. The FK links the failure to its remediation for root cause analysis and cost tracking.',
  `transmission_line_id` BIGINT COMMENT 'Foreign key linking to transmission.line. Business justification: Equipment failures on transmission lines must be tracked to the specific line for reliability analysis (SAIDI/SAIFI metrics), root cause analysis, NERC reporting, and maintenance optimization. Essenti',
  `transmission_substation_id` BIGINT COMMENT 'Foreign key linking to transmission.transmission_substation. Business justification: Substation equipment failures require linkage to the specific substation for reliability metrics, outage analysis, root cause investigation, and regulatory reporting. Utilities track failure history b',
  `affected_component` STRING COMMENT 'Specific component or subsystem of the asset that failed (e.g., transformer winding, circuit breaker mechanism).',
  `asset_age_years` DECIMAL(6,2) COMMENT 'Age of the asset in years at the time of failure. Used for age-based reliability analysis.',
  `caidi_contribution_minutes` DECIMAL(10,2) COMMENT 'Contribution of this failure event to the overall CAIDI reliability metric for the reporting period.',
  `corrective_action_plan` STRING COMMENT 'Description of preventive measures and process improvements to prevent recurrence of similar failures.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this failure event record was first created in the asset management system.',
  `customers_affected_count` INT COMMENT 'Number of customers who experienced service interruption due to this failure. Used for SAIFI calculation.',
  `detection_timestamp` TIMESTAMP COMMENT 'Date and time when the failure was detected by SCADA, protection relays, or field personnel.',
  `energy_not_supplied_mwh` DECIMAL(12,3) COMMENT 'Total energy in megawatt-hours that could not be delivered to customers due to the failure.',
  `failure_asset` BIGINT COMMENT 'FK to asset.asset_registry.asset_registry_id — Every failure event must reference the failed asset. Critical for reliability analysis, MTBF calculations, and NERC reporting.',
  `failure_cause_code` STRING COMMENT 'Standardized code identifying the root cause of the failure per utility taxonomy.',
  `failure_cause_description` STRING COMMENT 'Detailed narrative description of the failure cause including contributing factors and conditions.',
  `failure_cost_amount` DECIMAL(15,2) COMMENT 'Total cost of the failure including repair labor, materials, equipment replacement, and lost revenue.',
  `failure_cost_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for the failure cost amount. Pattern: ^[A-Z]{3}$.',
  `failure_location` STRING COMMENT 'Physical location or component within the asset where the failure occurred.',
  `failure_mode` STRING COMMENT 'Primary mode of failure categorizing the physical mechanism of breakdown. Valid values: electrical|mechanical|thermal|insulation|corrosion|external_damage.',
  `failure_number` STRING COMMENT 'Business identifier for the failure event, typically auto-generated by the asset management system.',
  `failure_status` STRING COMMENT 'Current lifecycle status of the failure event record in the asset management workflow. Valid values: open|under_investigation|rca_in_progress|resolved|closed.',
  `failure_timestamp` TIMESTAMP COMMENT 'Date and time when the asset failure occurred. Critical for reliability analysis and SAIDI/SAIFI calculations.',
  `failure_type` STRING COMMENT 'Classification of the failure event by operational impact and planning status. Valid values: forced_outage|planned_outage|degraded_operation|partial_failure.',
  `investigated_by` STRING COMMENT 'Name or identifier of the engineer or team responsible for investigating the failure.',
  `last_maintenance_date` DATE COMMENT 'Date of the most recent preventive or corrective maintenance performed on the asset prior to failure.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this failure event record was most recently modified.',
  `load_interrupted_mw` DECIMAL(12,3) COMMENT 'Amount of electrical load in megawatts that was interrupted by the failure event.',
  `nerc_report_submitted_date` DATE COMMENT 'Date when the NERC reliability report was submitted for this failure event, if applicable.',
  `nerc_reportable_flag` BOOLEAN COMMENT 'Indicates whether this failure event meets NERC reporting thresholds for reliability compliance.',
  `operating_hours_at_failure` DECIMAL(12,2) COMMENT 'Cumulative operating hours of the asset at the time of failure. Used for MTBF analysis.',
  `outage_duration_minutes` DECIMAL(10,2) COMMENT 'Total duration of the forced outage in minutes from failure to restoration. Used for SAIDI calculation.',
  `puc_reportable_flag` BOOLEAN COMMENT 'Indicates whether this failure event must be reported to the state Public Utility Commission.',
  `repair_action_taken` STRING COMMENT 'Description of the corrective action performed to restore the asset to service.',
  `reported_by` STRING COMMENT 'Name or identifier of the person or system that reported the failure event.',
  `restoration_timestamp` TIMESTAMP COMMENT 'Date and time when the asset was restored to normal operation following repair.',
  `root_cause_analysis_completed_flag` BOOLEAN COMMENT 'Indicates whether a formal root cause analysis has been completed for this failure event.',
  `root_cause_analysis_findings` STRING COMMENT 'Summary of root cause analysis findings including identified systemic issues and contributing factors.',
  `saidi_contribution_minutes` DECIMAL(10,2) COMMENT 'Contribution of this failure event to the overall SAIDI reliability metric for the reporting period.',
  `saifi_contribution` DECIMAL(10,6) COMMENT 'Contribution of this failure event to the overall SAIFI reliability metric for the reporting period.',
  `severity_level` STRING COMMENT 'Severity classification based on safety risk, customer impact, and asset damage extent. Valid values: critical|major|moderate|minor.',
  `to_asset` BIGINT COMMENT 'FK to asset.asset_registry.asset_registry_id — Failure events record which asset failed. Without this FK, reliability analysis (MTBF, failure rate by asset class) is impossible.',
  `weather_condition` STRING COMMENT 'Weather conditions at the time of failure (e.g., storm, lightning, high wind, ice) if weather-related.',
  `gis_location_id` BIGINT COMMENT 'Reference to the canonical CIM Location (gis.location) holding this entity\'s geometry, CRS and address. Implements CIM association IdentifiedObject -> Location (CMM extension association).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_failure_event` PRIMARY KEY (`failure_event_id`)
)
USING DELTA
COMMENT 'Records of asset failures, forced outages, and equipment breakdowns including failure date and time, failure mode (electrical, mechanical, thermal, insulation, corrosion, external damage), failure cause, affected asset, associated outage reference, repair action taken, root cause analysis findings, failure cost, and SAIDI/SAIFI impact contribution. Supports reliability-centered maintenance (RCM) analysis and NERC reliability reporting. | CMM: CIM FailureEvent (exact), IEC61968::Assets.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'FailureEvent',
  'cmm.cim.class' = 'FailureEvent',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Assets',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.failure_event',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- CapitalProject  <<CIM Project : close>>
CREATE TABLE IF NOT EXISTS `asset`.`capital_project` (
  `capital_project_id` BIGINT NOT NULL COMMENT 'Unique identifier for the capital expenditure project. Primary key for the capital project entity.',
  `asset_registry_id` BIGINT COMMENT 'FK to asset.asset_registry.asset_registry_id — Capital projects create or refurbish assets. Linking project to resulting asset enables CAPEX-to-RAB traceability and in-service date tracking.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Capital projects track costs by cost center for budget control, variance analysis, and FERC account allocation in rate base filings. New FK needed; removes denormalized cost_center string.',
  `cpcn_application_id` BIGINT COMMENT 'Foreign key linking to compliance.cpcn_application. Business justification: Major capital projects require Certificate of Public Convenience and Necessity approval from state regulators. Tracking which CPCN application authorized each project is essential for regulatory compl',
  `distribution_substation_id` BIGINT COMMENT 'Foreign key linking to distribution.distribution_substation. Business justification: Substation capital projects (transformer additions, bus upgrades, protection modernization, capacity expansion) are major utility investments requiring detailed tracking for FERC/PUC reporting, RAB in',
  `feeder_id` BIGINT COMMENT 'Foreign key linking to distribution.feeder. Business justification: Capital projects for feeder upgrades (reconductoring, capacity expansion, automation, undergrounding) require feeder attribution for investment planning, rate case justification, RAB tracking, and rel',
  `irp_scenario_id` BIGINT COMMENT 'Foreign key linking to forecast.irp_scenario. Business justification: Capital projects are planned and justified based on specific IRP scenarios. Project timing, scope, and budget are driven by IRP load growth, capacity needs, and retirement assumptions. Standard utilit',
  `master_supplier_contract_id` BIGINT COMMENT 'Foreign key linking to supply.supplier_contract. Business justification: Large capital projects often use frame contracts for multi-year procurement of standardized equipment (transformers, poles, conductors). Links project to master supply agreement for pricing validation',
  `primary_equipment_material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: Capital projects specify primary equipment being installed (transformer model, circuit breaker type) for asset registry creation and depreciation setup. Links project to material master for standardiz',
  `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Capital projects allocate to profit centers for business unit P&L tracking, rate base segmentation by service territory, and regulatory jurisdiction reporting. New FK needed for financial consolidatio',
  `project_manager_employee_id` BIGINT COMMENT 'Employee identifier for the project manager, linking to the workforce management system.',
  `rate_case_id` BIGINT COMMENT 'Foreign key linking to compliance.rate_case. Business justification: Capital projects are justified and approved for cost recovery in rate cases. Utilities must track which rate case authorized capital investments for regulatory accounting, prudency reviews, and rate b',
  `actual_completion_date` DATE COMMENT 'Actual date when the capital project completed all construction and commissioning activities.',
  `actual_in_service_date` DATE COMMENT 'Actual date when the asset or infrastructure resulting from the capital project was placed into operational service and began providing utility function.',
  `actual_spend_to_date` DECIMAL(18,2) COMMENT 'Cumulative actual capital expenditure incurred and paid to date for the project, including all invoiced and settled costs.',
  `actual_start_date` DATE COMMENT 'Actual date when the capital project execution activities commenced.',
  `approved_capex_budget` DECIMAL(18,2) COMMENT 'Total capital expenditure budget approved for the project by the appropriate governance authority. Represents the authorized spending limit.',
  `budget_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this capital project record. Pattern: ^[A-Z]{3}$.',
  `capacity_mw` DECIMAL(12,2) COMMENT 'Rated capacity in megawatts for generation or transmission projects. Represents the power handling capability of the infrastructure being built or upgraded.',
  `committed_spend` DECIMAL(18,2) COMMENT 'Total amount of capital expenditure committed through purchase orders, contracts, and other binding obligations, but not yet paid.',
  `contractor_name` STRING COMMENT 'Name of the primary contractor or engineering-procurement-construction (EPC) firm executing the capital project.',
  `cpcn_reference_number` STRING COMMENT 'Reference number for the Certificate of Public Convenience and Necessity issued by the state Public Utility Commission authorizing the capital project. Required for major utility infrastructure investments.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the capital project record was first created in the system.',
  `depreciation_method` STRING COMMENT 'Accounting depreciation method to be applied to the assets resulting from the capital project once placed in service. Valid values: straight_line|declining_balance|units_of_production|regulatory.',
  `estimated_useful_life_years` INT COMMENT 'Expected useful life in years for the assets resulting from the capital project, used for depreciation and asset management planning.',
  `ferc_reportable_flag` BOOLEAN COMMENT 'Indicates whether the capital project must be reported to FERC for regulatory oversight and rate case proceedings.',
  `funding_source` STRING COMMENT 'Primary source of capital funding for the project: internal cash reserves, debt financing, equity issuance, government grants, customer contributions, or rate recovery mechanisms. Valid values: internal_cash|debt_financing|equity|grants|customer_contributions|rate_recovery.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the capital project record was last updated or modified.',
  `nerc_compliance_flag` BOOLEAN COMMENT 'Indicates whether the capital project is subject to NERC reliability standards and compliance requirements.',
  `planned_completion_date` DATE COMMENT 'Target date for the capital project to complete all construction and commissioning activities.',
  `planned_in_service_date` DATE COMMENT 'Target date for the asset or infrastructure resulting from the capital project to be placed into operational service.',
  `planned_start_date` DATE COMMENT 'Planned date for the capital project to commence execution activities.',
  `project_asset` BIGINT COMMENT 'FK to asset.asset_registry.asset_registry_id — Capital projects create or refurbish assets. The link from project to resulting asset(s) is required for CAPEX-to-RAB traceability and commissioning workflows.',
  `project_category` STRING COMMENT 'High-level asset category that the capital project targets: generation units, transmission infrastructure, distribution network, substation equipment, facilities, fleet vehicles, or IT infrastructure. Reference-value candidates: generation|transmission|distribution|substation|facilities|fleet|it_infrastructure.',
  `project_closeout_date` DATE COMMENT 'Date when the capital project was formally closed out, including final cost reconciliation, asset capitalization, and administrative closure.',
  `project_description` STRING COMMENT 'Detailed narrative description of the capital project scope, objectives, deliverables, and expected benefits.',
  `project_justification` STRING COMMENT 'Primary business driver or justification for the capital project: reliability improvement, capacity expansion, regulatory compliance, safety enhancement, operational efficiency, customer service improvement, or environmental requirement. Reference-value candidates: reliability|capacity|compliance|safety|efficiency|customer_service|environmental.',
  `project_name` STRING COMMENT 'Human-readable name or title of the capital project describing its purpose and scope.',
  `project_number` STRING COMMENT 'Externally-known unique business identifier for the capital project, typically assigned by the ERP system. Used for cross-system reference and reporting. Pattern: ^[A-Z0-9]{8,20}$.',
  `project_phase` STRING COMMENT 'Current execution phase of the capital project within the project delivery lifecycle. Valid values: feasibility|design|procurement|construction|commissioning|closeout.',
  `project_priority` STRING COMMENT 'Business priority level assigned to the capital project for resource allocation and scheduling decisions. Valid values: critical|high|medium|low.',
  `project_status` STRING COMMENT 'Current lifecycle status of the capital project indicating its phase in the project delivery workflow. Reference-value candidates: feasibility|design|approved|procurement|construction|commissioning|closeout|cancelled|on_hold.',
  `project_type` STRING COMMENT 'Classification of the capital project by its primary purpose: new asset construction, asset replacement, system upgrade, major refurbishment, regulatory compliance, or network augmentation. Valid values: new_build|replacement|upgrade|refurbishment|compliance|augmentation.',
  `rab_allocation_percentage` DECIMAL(5,2) COMMENT 'Percentage of the project capital expenditure that is eligible for inclusion in the Regulatory Asset Base. May be less than 100% if only portions are rate-recoverable.',
  `rab_eligible_flag` BOOLEAN COMMENT 'Indicates whether the capital expenditure from this project is eligible for inclusion in the Regulatory Asset Base for rate recovery purposes.',
  `risk_level` STRING COMMENT 'Overall risk assessment level for the capital project considering technical, financial, regulatory, and execution risks. Valid values: low|medium|high|critical.',
  `service_territory` STRING COMMENT 'Geographic service territory or region where the capital project assets will be located and provide utility service.',
  `source_system_code` STRING COMMENT 'Code identifying the source system from which the capital project record originated: SAP Project System, Ventyx Asset Suite, SAP S/4HANA, or manual entry. Valid values: SAP_PS|VENTYX|S4HANA|MANUAL.',
  `source_system_record_code` STRING COMMENT 'Unique identifier for the capital project record in the source system, used for data lineage and reconciliation.',
  `sponsoring_business_unit` STRING COMMENT 'The business unit or division that owns and sponsors the capital project, responsible for funding and business case justification.',
  `to_asset` BIGINT COMMENT 'FK to asset.asset_registry.asset_registry_id — Capital projects create or refurbish assets. The FK links project spend to the resulting asset for RAB capitalization and commissioning tracking.',
  `variance_to_budget` DECIMAL(18,2) COMMENT 'Calculated variance between actual spend to date and approved CAPEX budget. Positive values indicate over-budget, negative values indicate under-budget.',
  `voltage_level_kv` DECIMAL(10,2) COMMENT 'Primary voltage level in kilovolts for electrical infrastructure projects. Applicable to transmission, distribution, and substation projects.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_capital_project` PRIMARY KEY (`capital_project_id`)
)
USING DELTA
COMMENT 'Capital expenditure project record for new asset construction, major refurbishment, or network augmentation. Captures project number, project name, project type (new build, replacement, upgrade, compliance), sponsoring business unit, project manager, approved CAPEX budget, committed spend, actual spend to date, project phase (feasibility, design, procurement, construction, commissioning, closeout), planned in-service date, actual in-service date, CPCN reference, and RAB eligibility flag. Sourced from SAP S/4HANA Project System (PS) and Ventyx Asset Suite. | CMM: CIM Project (close), IEC61968::InfWork.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CapitalProject',
  'cmm.cim.class' = 'Project',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfWork',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-6',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.capital_project'
);

-- DepreciationSchedule  <<CIM FinancialInfo : close>>
CREATE TABLE IF NOT EXISTS `asset`.`depreciation_schedule` (
  `depreciation_schedule_id` BIGINT NOT NULL COMMENT 'Unique identifier for the depreciation schedule record. Primary key for the depreciation schedule entity.',
  `asset_class_id` BIGINT COMMENT 'FK to asset.asset_class.asset_class_id — Depreciation methods and useful life defaults are driven by asset class. This FK enables class-level depreciation policy inheritance.',
  `asset_registry_id` BIGINT COMMENT 'FK to asset.asset_registry.asset_registry_id — Depreciation schedules are defined per asset. Without this FK, depreciation charges cannot be allocated to specific assets for RAB valuation and financial reporting.',
  `class_id` BIGINT COMMENT 'Foreign key linking to asset.asset_class. Business justification: depreciation_schedule has both asset_registry_id (for asset-specific schedules) and asset_class_code (STRING) for class-level depreciation schedules. The asset_class_code should be normalized to FK as',
  `employee_id` BIGINT COMMENT 'User ID of the person or system account that created this depreciation schedule record.',
  `last_modified_by_user_employee_id` BIGINT COMMENT 'User ID of the person or system account that last modified this depreciation schedule record.',
  `registry_id` BIGINT COMMENT 'Reference to the utility asset (generation unit, transformer, transmission tower, distribution pole, switchgear, protection relay, substation equipment, fleet vehicle, or facility) to which this depreciation schedule applies.',
  `accounting_period` INT COMMENT 'Accounting period (month) within the fiscal year to which this depreciation schedule record applies. Typically 1-12.',
  `accumulated_depreciation` DECIMAL(18,2) COMMENT 'Total depreciation expense recognized to date since the asset was placed in service. Increases each period by the depreciation charge.',
  `accumulated_depreciation_gl_account_code` STRING COMMENT 'General ledger account code for the accumulated depreciation contra-asset account on the balance sheet.',
  `acquisition_date` DATE COMMENT 'Date the asset was acquired or placed in service. Marks the start of the depreciation period.',
  `annual_depreciation_charge` DECIMAL(18,2) COMMENT 'Annual depreciation expense allocated to the asset under the selected depreciation method. For straight-line: depreciable base divided by useful life years.',
  `business_area_code` STRING COMMENT 'Business area or operating segment (e.g., generation, transmission, distribution, retail) to which this asset and its depreciation expense are allocated.',
  `capex_opex_classification` STRING COMMENT 'Classification of the asset as capital expenditure (CAPEX) or operational expenditure (OPEX) for financial planning and regulatory reporting purposes. CAPEX assets are capitalized and depreciated; OPEX items are expensed immediately. Valid values: capex|opex.',
  `company_code` STRING COMMENT 'Company code or legal entity to which this depreciation schedule belongs. Supports multi-entity utility holding companies.',
  `cost_center_code` STRING COMMENT 'Cost center to which depreciation expense is allocated for internal management accounting and OPEX tracking.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this depreciation schedule record was first created in the source system.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this depreciation schedule (e.g., USD, EUR, GBP). Pattern: ^[A-Z]{3}$.',
  `depreciable_base` DECIMAL(18,2) COMMENT 'Amount subject to depreciation, calculated as original cost minus salvage value. Used as the basis for annual depreciation charge calculation.',
  `depreciation_area_code` STRING COMMENT 'Code identifying the depreciation area or ledger (e.g., book depreciation, tax depreciation, regulatory depreciation) to which this schedule applies. Utilities often maintain parallel depreciation schedules for different reporting purposes.',
  `depreciation_asset` BIGINT COMMENT 'FK to asset.asset_registry.asset_registry_id — Depreciation schedules must reference the asset being depreciated. Required for RAB valuation and financial reporting.',
  `depreciation_end_date` DATE COMMENT 'Date on which depreciation calculation ends for this asset. Typically the date the asset is fully depreciated, retired, or disposed of.',
  `depreciation_method` STRING COMMENT 'Method used to calculate depreciation expense over the asset\'s useful life. Straight-line is most common for utility assets; units of production may be used for generation equipment; regulatory composite may be mandated by PUC for rate-regulated assets. Valid values: straight_line|declining_balance|units_of_production|sum_of_years_digits|regulatory_composite.',
  `depreciation_start_date` DATE COMMENT 'Date on which depreciation calculation begins for this asset. Typically the placed-in-service date or the first day of the following month.',
  `depreciation_status` STRING COMMENT 'Current status of the depreciation schedule. Active indicates ongoing depreciation; fully depreciated indicates the asset has reached its salvage value; suspended indicates temporary halt; retired/disposed indicates asset is no longer in service. Valid values: active|fully_depreciated|suspended|retired|disposed.',
  `depreciation_to_asset` BIGINT COMMENT 'FK to asset.asset_registry.asset_registry_id — Each depreciation schedule is assigned to a specific asset for financial reporting, RAB valuation, and SOX compliance. This is a mandatory FK for fixed asset accounting.',
  `fiscal_year` INT COMMENT 'Fiscal year to which this depreciation schedule record applies. Enables year-over-year tracking of depreciation expense and accumulated depreciation.',
  `functional_area_code` STRING COMMENT 'Functional area (e.g., operations, maintenance, administration) to which depreciation expense is allocated for cost analysis.',
  `gl_account_code` STRING COMMENT 'General ledger account code to which depreciation expense is posted. Typically a depreciation expense account in the income statement.',
  `impairment_indicator_flag` BOOLEAN COMMENT 'Indicates whether the asset has been identified as potentially impaired (carrying value may exceed recoverable amount). Triggers impairment testing under GAAP ASC 360.',
  `last_depreciation_run_date` DATE COMMENT 'Date of the most recent depreciation calculation run for this asset. Used to track depreciation processing and ensure timely financial close.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this depreciation schedule record was last modified in the source system.',
  `net_book_value` DECIMAL(18,2) COMMENT 'Current carrying value of the asset on the balance sheet, calculated as original cost minus accumulated depreciation. Also known as book value or carrying amount.',
  `notes` STRING COMMENT 'Free-text notes or comments regarding this depreciation schedule, including adjustments, regulatory guidance, or special circumstances.',
  `original_cost` DECIMAL(18,2) COMMENT 'Original acquisition or construction cost of the asset, including capitalized installation, engineering, and AFUDC (Allowance for Funds Used During Construction). Basis for depreciation calculation.',
  `placed_in_service_date` DATE COMMENT 'Date the asset was placed into operational service and began generating revenue or providing utility function. Depreciation typically begins on this date.',
  `rab_depreciation_treatment` STRING COMMENT 'Treatment of this asset\'s depreciation in the Regulatory Asset Base (RAB) for rate-making purposes. Determines whether depreciation expense is recoverable through customer rates. Valid values: included|excluded|deferred|accelerated|regulatory_lag.',
  `rab_inclusion_flag` BOOLEAN COMMENT 'Indicates whether this asset is included in the Regulatory Asset Base (RAB) for rate-making purposes. True if included; false if excluded.',
  `regulatory_depreciation_rate_percent` DECIMAL(7,4) COMMENT 'Depreciation rate (as a percentage of original cost) approved by the Public Utility Commission (PUC) for rate-making purposes. May differ from book depreciation rate.',
  `remaining_useful_life_years` DECIMAL(5,2) COMMENT 'Estimated remaining useful life of the asset in years as of the current reporting period. Calculated as original useful life minus elapsed time since placed in service.',
  `salvage_value` DECIMAL(18,2) COMMENT 'Estimated residual value of the asset at the end of its useful life. Subtracted from original cost to determine depreciable base.',
  `source_system_code` STRING COMMENT 'Code identifying the source system from which this depreciation schedule record originated (e.g., SAP_S4HANA, VENTYX_ASSET_SUITE).',
  `source_system_record_code` STRING COMMENT 'Unique identifier of this depreciation schedule record in the source system. Enables traceability and reconciliation.',
  `tax_depreciation_method` STRING COMMENT 'Depreciation method used for tax reporting purposes. May differ from book depreciation method. MACRS (Modified Accelerated Cost Recovery System) is common in the US. Valid values: macrs|straight_line|declining_balance|bonus_depreciation|section_179.',
  `tax_useful_life_years` DECIMAL(5,2) COMMENT 'Useful life of the asset for tax depreciation purposes, as defined by tax regulations. May differ from book useful life.',
  `useful_life_years` DECIMAL(5,2) COMMENT 'Expected useful life of the asset in years, as determined by engineering assessment and regulatory guidance. Used to calculate annual depreciation charge under straight-line or declining balance methods.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_depreciation_schedule` PRIMARY KEY (`depreciation_schedule_id`)
)
USING DELTA
COMMENT 'Asset depreciation schedule defining the financial depreciation profile for each utility asset or asset class. Captures depreciation method (straight-line, declining balance, units of production), useful life (years), salvage value, annual depreciation charge, accumulated depreciation, net book value, regulatory depreciation rate (as approved by PUC), and RAB depreciation treatment. Supports CAPEX/OPEX planning, regulatory asset base (RAB) valuation, and SOX-compliant financial reporting. Sourced from SAP S/4HANA Fixed Asset Accounting (FI-AA). | CMM: CIM FinancialInfo (close), IEC61968::Assets.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DepreciationSchedule',
  'cmm.cim.class' = 'FinancialInfo',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Assets',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.depreciation_schedule'
);

-- SparePartsInventory  <<CIM ErpInventory : close>>
CREATE TABLE IF NOT EXISTS `asset`.`spare_parts_inventory` (
  `spare_parts_inventory_id` BIGINT NOT NULL COMMENT 'Unique identifier for the spare parts inventory record. Primary key for the spare parts inventory product.',
  `asset_class_id` BIGINT COMMENT 'FK to asset.asset_class.asset_class_id — Spare parts are stocked for specific asset classes (e.g., bushings for 132kV transformers). This FK enables parts applicability lookup during work order planning.',
  `class_id` BIGINT COMMENT 'Foreign key linking to asset.asset_class. Business justification: spare_parts_inventory has asset_class_applicability (STRING) which appears to store which asset class(es) the spare part is applicable to. This should be normalized to FK asset_class_id → asset_class.',
  `direct_load_control_device_id` BIGINT COMMENT 'Foreign key linking to demand.direct_load_control_device. Business justification: Spare parts inventory for DLC devices (communication modules, control relays, thermostats) supports DR program reliability. Warehouse management links spare parts to device models for reorder point ca',
  `primary_spare_employee_id` BIGINT COMMENT 'System user identifier of the person who created the spare parts inventory record in the enterprise asset management system.',
  `abc_classification` STRING COMMENT 'Inventory classification based on value and usage frequency. A items are high-value or high-usage requiring tight control and frequent review, B items are moderate-value with standard controls, C items are low-value with minimal controls. Used for cycle counting frequency and inventory management prioritization. Valid values: A|B|C.',
  `bin_location` STRING COMMENT 'Specific bin, shelf, or rack location within the stocking location where the material is stored. Supports warehouse picking and cycle counting operations.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the spare parts inventory record was first created in the system. Supports audit trail and data lineage requirements.',
  `criticality_classification` STRING COMMENT 'Business criticality rating of the spare part based on impact to operations if unavailable. Critical items are essential for emergency restoration and grid reliability, high items support major assets, medium items are standard maintenance spares, and low items are non-essential consumables. Valid values: critical|high|medium|low.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the unit cost valuation (e.g., USD, CAD, EUR, GBP). Pattern: ^[A-Z]{3}$.',
  `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether the material is classified as hazardous and requires special handling, storage, and disposal procedures per OSHA and EPA regulations. True if hazardous, False if non-hazardous.',
  `last_issue_date` DATE COMMENT 'Date when the material was most recently issued from inventory to a work order or maintenance activity. Used for inventory turnover analysis and obsolescence management.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the spare parts inventory record was most recently updated. Supports change tracking and audit compliance.',
  `last_physical_count_date` DATE COMMENT 'Date when the last physical cycle count or annual inventory audit was performed for this material at this stocking location. Supports inventory accuracy and SOX compliance requirements.',
  `last_purchase_date` DATE COMMENT 'Date when the material was most recently purchased via a purchase order. Used for inventory aging analysis and procurement pattern tracking.',
  `last_purchase_order_number` STRING COMMENT 'Most recent purchase order number used to procure this material. Provides audit trail and reference for pricing, lead time, and supplier performance analysis.',
  `lead_time_days` INT COMMENT 'Expected number of calendar days from purchase order placement to material receipt at the stocking location. Used for reorder point calculation and emergency procurement planning.',
  `manufacturer_name` STRING COMMENT 'Name of the original equipment manufacturer (OEM) or supplier who produces the spare part. Used for warranty tracking, quality management, and supplier performance analysis.',
  `manufacturer_part_number` STRING COMMENT 'Original equipment manufacturer\'s part number or catalog number for the spare part. Used for cross-referencing, procurement, and ensuring correct part substitution.',
  `material_description` STRING COMMENT 'Detailed textual description of the spare part or consumable item including technical specifications, manufacturer details, and usage context.',
  `material_group_code` STRING COMMENT 'Hierarchical classification code grouping similar materials for procurement, reporting, and spend analysis. Examples include electrical components, mechanical parts, safety equipment, or consumables. Pattern: ^[A-Z0-9]{4,8}$.',
  `material_number` STRING COMMENT 'Unique material master identifier assigned to the spare part or consumable item in the enterprise asset management system. This is the externally-known business identifier used across procurement, inventory, and maintenance operations. Pattern: ^[A-Z0-9]{8,18}$.',
  `material_status` STRING COMMENT 'Current lifecycle status of the material master record. Active materials are available for procurement and issue, inactive materials are temporarily blocked, obsolete materials are phased out, pending approval materials are under review, and discontinued materials are no longer supported by the manufacturer. Valid values: active|inactive|obsolete|pending_approval|discontinued.',
  `material_type` STRING COMMENT 'Classification of the inventory item by usage category. Spare parts are replaceable components for assets, consumables are items used up during maintenance, critical spares are high-value low-turnover items essential for emergency restoration, tools are reusable equipment, safety equipment includes PPE and protective gear, and bulk materials are commodities purchased in volume. Valid values: spare_part|consumable|critical_spare|tool|safety_equipment|bulk_material.',
  `maximum_stock_level` DECIMAL(15,3) COMMENT 'Maximum inventory quantity threshold to avoid overstocking and excess capital tied up in inventory. Used for inventory optimization and storage capacity planning.',
  `minimum_stock_level` DECIMAL(15,3) COMMENT 'Minimum inventory quantity threshold below which replenishment should be triggered. Set based on lead time, usage rate, and criticality to ensure availability for planned and emergency maintenance.',
  `obsolete_flag` BOOLEAN COMMENT 'Indicates whether the material has been marked as obsolete and should no longer be procured or issued. True if obsolete, False if active. Obsolete materials may still have on-hand inventory for legacy asset support.',
  `plant_code` STRING COMMENT 'Identifier for the organizational plant or business unit to which this inventory record belongs. Used for multi-site inventory management and cost allocation across generation, transmission, and distribution operations. Pattern: ^[A-Z0-9]{4,6}$.',
  `preferred_supplier_code` STRING COMMENT 'Identifier for the preferred or primary supplier from whom this material should be procured. Links to vendor master data in the enterprise resource planning system. Pattern: ^[A-Z0-9]{6,10}$.',
  `quantity_on_hand` DECIMAL(15,3) COMMENT 'Current physical inventory quantity available in stock at the stocking location. Measured in the material\'s unit of measure.',
  `reorder_point` DECIMAL(15,3) COMMENT 'Inventory level at which a purchase requisition or replenishment order should be automatically generated. Calculated based on lead time demand plus safety stock.',
  `serial_number_tracking_flag` BOOLEAN COMMENT 'Indicates whether individual units of this material are tracked by unique serial numbers for warranty, calibration, or asset lifecycle management. True if serial-tracked, False if batch-tracked or non-serialized.',
  `shelf_life_months` INT COMMENT 'Maximum number of months the material can be stored before it expires or degrades and must be disposed of. Applicable to consumables, lubricants, chemicals, and time-sensitive spare parts. Null for non-perishable items.',
  `source_system_code` STRING COMMENT 'Identifier for the operational system of record from which this inventory data originated. VENTYX for Ventyx Asset Suite Inventory module, SAP_MM for SAP S/4HANA Materials Management, SAP_PM for SAP Plant Maintenance, MANUAL for manually entered records. Valid values: VENTYX|SAP_MM|SAP_PM|MANUAL.',
  `source_system_record_code` STRING COMMENT 'Unique identifier or primary key of this inventory record in the source operational system. Used for data lineage, reconciliation, and bidirectional synchronization.',
  `spare_part_applicability` BIGINT COMMENT 'FK to asset.asset_class.asset_class_id — Spare parts are stocked for specific asset classes. This FK enables identification of which parts serve which equipment types for inventory optimization.',
  `spare_parts_to_asset_class` BIGINT COMMENT 'FK to asset.asset_class.asset_class_id — Spare parts are stocked for specific asset classes (e.g., transformer bushings for 132kV power transformers). This FK enables bill-of-materials resolution and critical spare identification.',
  `stocking_location_code` STRING COMMENT 'Identifier for the warehouse, storeroom, or facility where the spare part inventory is physically held. May reference central warehouses, regional depots, or substation storerooms. Pattern: ^[A-Z0-9]{4,10}$.',
  `stocking_location_name` STRING COMMENT 'Human-readable name of the warehouse or storeroom where the inventory is held.',
  `storage_condition_code` STRING COMMENT 'Required environmental storage conditions for the material. Ambient for standard warehouse conditions, climate controlled for temperature and humidity sensitive items, refrigerated for cold storage, outdoor for weather-resistant bulk materials, and hazmat storage for hazardous materials requiring special containment. Valid values: ambient|climate_controlled|refrigerated|outdoor|hazmat_storage.',
  `total_inventory_value` DECIMAL(18,2) COMMENT 'Total monetary value of the on-hand inventory calculated as quantity on hand multiplied by unit cost. Used for Regulatory Asset Base (RAB) valuation, financial reporting, and Capital Expenditure (CAPEX) / Operational Expenditure (OPEX) tracking.',
  `unit_cost` DECIMAL(15,2) COMMENT 'Standard or moving average cost per unit of measure for the material. Used for inventory valuation, work order costing, and Operations and Maintenance (O&M) expense tracking.',
  `unit_of_measure` STRING COMMENT 'Standard unit in which the material quantity is tracked and issued. EA=each, FT=feet, M=meters, KG=kilograms, LB=pounds, GAL=gallons, L=liters, BOX=box, ROLL=roll, SET=set. Reference-value candidates: EA|FT|M|KG|LB|GAL|L|BOX|ROLL|SET.',
  `valuation_class` STRING COMMENT 'Accounting classification code used to assign inventory value to specific general ledger accounts for financial reporting. Links material inventory to chart of accounts for CAPEX, OPEX, and balance sheet reporting. Pattern: ^[A-Z0-9]{4,10}$.',
  `warranty_months` INT COMMENT 'Number of months of manufacturer warranty coverage from the date of purchase or installation. Used for warranty claim management and total cost of ownership analysis. Null if no warranty applies.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_spare_parts_inventory` PRIMARY KEY (`spare_parts_inventory_id`)
)
USING DELTA
COMMENT 'Inventory management for spare parts, consumables, and critical spares held for utility asset maintenance and emergency restoration. Captures material master data (number, description, asset class applicability, criticality classification), stocking details (location, quantity on hand, min stock, reorder point, lead time), valuation (unit cost, total inventory value), and supplier references. Also records material issue and return transactions against work orders including issue date, quantity, receiving technician, and cost allocation. Supports O&M material cost tracking, inventory replenishment triggers, and critical spare availability assurance. Sourced from Ventyx Asset Suite Inventory module and SAP S/4HANA Materials Management (MM). | CMM: CIM ErpInventory (close), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SparePartsInventory',
  'cmm.cim.class' = 'ErpInventory',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.spare_parts_inventory'
);

-- AssetInspection  <<CIM InspectionDataSet : exact>>
CREATE TABLE IF NOT EXISTS `asset`.`inspection` (
  `inspection_id` BIGINT NOT NULL COMMENT 'Unique identifier for the asset inspection record. Primary key.',
  `compliance_obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Asset inspections are mandated by specific regulatory obligations (FERC dam safety, NERC vegetation management, state PUC equipment inspection requirements). Direct link enables compliance reporting,',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: Regular inspections of DER installations for safety compliance, performance verification, and interconnection agreement requirements. Mandated by most jurisdictions for NEM programs, feed-in tariffs,',
  `distribution_transformer_id` BIGINT COMMENT 'Foreign key linking to distribution.transformer. Business justification: Transformer inspections (visual, oil sampling, dissolved gas analysis, thermography) are mandated by NFPA 70B, IEEE C57 standards, and insurance requirements. Links inspection results to specific tran',
  `feeder_id` BIGINT COMMENT 'Foreign key linking to distribution.feeder. Business justification: Feeder inspections (patrol, infrared thermography, detailed climbing inspections) are regulatory requirements (NERC FAC standards, state PUC mandates) and reliability best practices. Links inspection',
  `inspection_approved_by_user_employee_id` BIGINT COMMENT 'Identifier of the supervisor or engineer who reviewed and approved the inspection findings and recommendations.',
  `inspection_employee_id` BIGINT COMMENT 'Identifier of the employee, contractor, or assessor who performed the inspection.',
  `registry_id` BIGINT COMMENT 'Identifier of the utility asset being inspected (generation unit, transmission tower, distribution pole, transformer, switchgear, protection relay, substation equipment, fleet vehicle, or facility).',
  `transmission_line_id` BIGINT COMMENT 'Foreign key linking to transmission.line. Business justification: Transmission line inspections (aerial patrols, ground inspections, LiDAR surveys, drone inspections) are line-specific and required for NERC FAC standards compliance, vegetation management, and struct',
  `transmission_substation_id` BIGINT COMMENT 'Foreign key linking to transmission.transmission_substation. Business justification: Substation inspections (thermographic surveys, equipment condition assessments, oil sampling, visual inspections) are performed at specific substations and must be tracked for NERC compliance, mainten',
  `work_order_id` BIGINT COMMENT 'Identifier of the work order in Ventyx Asset Suite that authorized or scheduled this inspection activity.',
  `ambient_temperature_c` DECIMAL(5,2) COMMENT 'Ambient temperature in degrees Celsius at the time of inspection, relevant for temperature-sensitive diagnostic tests (e.g., thermography, oil analysis).',
  `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the inspection record was reviewed and approved by a supervisor or engineer.',
  `asset_load_percent` DECIMAL(5,2) COMMENT 'Percentage of rated capacity at which the asset was operating during the inspection, relevant for load-dependent diagnostic tests.',
  `condition_rating` STRING COMMENT 'Qualitative condition rating corresponding to the overall condition score. Valid values: excellent|good|fair|poor|critical.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the inspection record was first created in the system.',
  `defect_description` STRING COMMENT 'Detailed narrative description of the defects, anomalies, or conditions observed during the inspection.',
  `defect_severity` STRING COMMENT 'Highest severity classification of defects identified: critical (immediate safety/reliability risk), major (near-term failure risk), minor (long-term degradation), or informational (observation only). Valid values: critical|major|minor|informational.',
  `defects_identified_count` INT COMMENT 'Number of defects, anomalies, or non-conformances identified during the inspection.',
  `document_attachment_count` INT COMMENT 'Number of supporting documents (test reports, certificates, checklists) attached to the inspection record.',
  `duration_hours` DECIMAL(6,2) COMMENT 'Total time in hours required to complete the inspection, including travel, setup, testing, and documentation.',
  `estimated_remediation_cost` DECIMAL(15,2) COMMENT 'Estimated cost in USD to remediate identified defects or perform recommended actions. Used for CAPEX/OPEX planning and maintenance budget forecasting.',
  `frequency_months` INT COMMENT 'Interval in months between scheduled inspections for this asset, based on regulatory mandates, asset criticality, or condition-based maintenance strategy.',
  `health_index` DECIMAL(5,2) COMMENT 'Composite health index score (0-100 scale) calculated from inspection results, test data, and condition indicators. Feeds asset health analytics and predictive maintenance models.',
  `inspection_date` DATE COMMENT 'The date on which the inspection or condition assessment was performed.',
  `inspection_method` STRING COMMENT 'The technical method or technology used to perform the inspection or diagnostic test. Reference-value candidates: visual|infrared_thermography|ultrasonic|vibration|oil_analysis|electrical_test|drone_aerial|manual_measurement|scada_online_monitoring.',
  `inspection_number` STRING COMMENT 'Business identifier for the inspection, typically generated by the work management system or field inspection application. Pattern: ^[A-Z0-9-]{6,20}$.',
  `inspection_status` STRING COMMENT 'Current lifecycle status of the inspection record in the work management system. Valid values: scheduled|in_progress|completed|cancelled|pending_review|approved.',
  `inspection_type` STRING COMMENT 'Classification of the inspection activity: routine patrol (visual), post-storm assessment, vegetation management inspection, scheduled condition assessment, or advanced diagnostic test type. Reference-value candidates: routine_patrol|post_storm|vegetation_management|scheduled_condition_assessment|thermographic_survey|dissolved_gas_analysis|partial_discharge_test|oil_sampling|vibration_analysis|ultrasonic_testing.',
  `inspector_name` STRING COMMENT 'Full name of the inspector or assessor who conducted the inspection.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the inspection record was last updated or modified.',
  `next_inspection_due_date` DATE COMMENT 'Scheduled date for the next inspection or condition assessment based on regulatory requirements, manufacturer recommendations, or condition-based maintenance triggers.',
  `notes` STRING COMMENT 'Free-text field for additional observations, context, or comments recorded by the inspector during the inspection.',
  `overall_condition_score` INT COMMENT 'Overall asset condition rating on a 1-5 scale per IEEE/IEC standards (1=excellent, 2=good, 3=fair, 4=poor, 5=very poor/critical).',
  `pass_fail_status` STRING COMMENT 'Indicates whether the test result meets acceptance criteria or threshold limits defined by manufacturer specifications or industry standards. Valid values: pass|fail|marginal|not_applicable.',
  `photo_attachment_count` INT COMMENT 'Number of photos or images attached to the inspection record for documentation purposes.',
  `recommended_action` STRING COMMENT 'Recommended follow-up action based on inspection findings: repair, replace, continue monitoring, no action required, further investigation needed, or emergency repair. Valid values: repair|replace|monitor|no_action|further_investigation|emergency_repair.',
  `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether this inspection is mandated by regulatory requirements (e.g., NERC FAC-003 vegetation management, OSHA confined space entry, state PUC inspection mandates).',
  `regulatory_standard_code` STRING COMMENT 'Code or reference to the specific regulatory standard or requirement that mandates this inspection (e.g., NERC FAC-003, OSHA 1910.269, IEEE Std 62.2).',
  `risk_score` DECIMAL(5,2) COMMENT 'Calculated risk score based on condition assessment results, asset criticality, and consequence of failure. Used for risk-based maintenance prioritization.',
  `scada_data_source_flag` BOOLEAN COMMENT 'Indicates whether inspection data was sourced from SCADA-integrated online monitoring systems (true) or from manual field inspection (false).',
  `source_system_code` STRING COMMENT 'Code identifying the source system from which the inspection data originated (Ventyx Asset Suite, SCADA, field inspection mobile app, OSIsoft PI, or GE PowerOn ADMS). Valid values: VENTYX|SCADA|MOBILE_APP|PI|ADMS.',
  `source_system_record_code` STRING COMMENT 'Unique identifier of the inspection record in the source system, used for data lineage and reconciliation.',
  `test_result_unit` STRING COMMENT 'Unit of measure for the test result value (e.g., ppm, pC, mm/s, kV, degrees Celsius, ohms).',
  `test_result_value` DECIMAL(18,4) COMMENT 'Numeric result of the diagnostic test or measurement (e.g., dissolved gas concentration in ppm, partial discharge magnitude in pC, vibration amplitude in mm/s, oil dielectric strength in kV).',
  `threshold_limit` DECIMAL(18,4) COMMENT 'The acceptance threshold or limit value against which the test result is compared to determine pass/fail status.',
  `weather_conditions` STRING COMMENT 'Description of weather conditions at the time of inspection, relevant for outdoor asset inspections (e.g., clear, rain, snow, high wind, extreme temperature).',
  `gis_location_id` BIGINT COMMENT 'Reference to the canonical CIM Location (gis.location) holding this entity\'s geometry, CRS and address. Implements CIM association IdentifiedObject -> Location (CMM extension association).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_inspection` PRIMARY KEY (`inspection_id`)
)
USING DELTA
COMMENT 'Periodic, event-driven, or regulatory-mandated evaluation of utility asset condition encompassing routine patrol inspections (visual, post-storm, vegetation management), scheduled condition assessments, and advanced diagnostic tests (thermographic survey, dissolved gas analysis, partial discharge test, oil sampling, vibration analysis, ultrasonic testing). Records inspection/assessment date, method/type, inspector or assessor identity, overall condition score (1-5 scale per IEEE/IEC standards), individual test results with pass/fail thresholds, defects identified with severity classification (critical, major, minor), recommended follow-up actions (repair, replace, monitor, no action), estimated remediation cost, next assessment due date, and regulatory compliance flags (e.g., NERC FAC-003 vegetation management, OSHA confined space). Feeds asset health indices, risk-based maintenance prioritization, reliability-centered maintenance analysis, and condition-based maintenance triggers. SSOT for all asset condition evaluation data. Sourced from Ventyx Asset Suite Condition Monitoring, field inspection mobile apps, and SCADA-integrated online monitoring systems. | CMM: CIM InspectionDataSet (exact), IEC61968::Assets.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AssetInspection',
  'cmm.cim.class' = 'InspectionDataSet',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Assets',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.inspection',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- AssetValuation  <<CIM FinancialInfo : close>>
CREATE TABLE IF NOT EXISTS `asset`.`valuation` (
  `valuation_id` BIGINT NOT NULL COMMENT 'Unique identifier for the asset valuation record. Primary key for the asset valuation entity.',
  `employee_id` BIGINT COMMENT 'Identifier of the user who approved this valuation for regulatory submission or financial reporting. Provides audit trail for governance.',
  `registry_id` BIGINT COMMENT 'Reference to the utility asset being valued (generation unit, transmission tower, distribution pole, transformer, switchgear, protection relay, substation equipment, fleet vehicle, or facility).',
  `accumulated_depreciation` DECIMAL(18,2) COMMENT 'The total depreciation accumulated on the asset from its in-service date to the valuation date. Calculated based on approved depreciation rates and asset age.',
  `appraiser_certification_number` STRING COMMENT 'Professional certification or license number of the appraiser, demonstrating qualifications to perform utility asset valuations. Required for regulatory acceptance.',
  `appraiser_name` STRING COMMENT 'Name of the individual or firm that performed the valuation. Required for independent appraisals and regulatory submissions.',
  `approval_timestamp` TIMESTAMP COMMENT 'Date and time when this valuation was formally approved for use in regulatory filings or financial reporting.',
  `basis` STRING COMMENT 'The source or basis for the valuation: independent appraisal (external certified appraiser), internal estimate (utility staff assessment), regulatory formula (PUC-prescribed calculation), indexed cost (inflation-adjusted historical cost), engineering assessment (technical evaluation), or third party valuation (consultant report). Valid values: independent_appraisal|internal_estimate|regulatory_formula|indexed_cost|engineering_assessment|third_party_valuation.',
  `condition_assessment_score` DECIMAL(5,2) COMMENT 'Numerical score representing the physical condition of the asset at the valuation date, typically on a scale of 1-10 or 1-100. Influences depreciation adjustments and replacement prioritization.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this valuation record was first created in the system. Part of audit trail for data lineage.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary values in this valuation record. Typically USD for US utilities. Pattern: ^[A-Z]{3}$.',
  `depreciation_rate_percent` DECIMAL(5,2) COMMENT 'The annual depreciation rate applied to this asset, expressed as a percentage. Approved by the PUC and used to calculate accumulated depreciation and remaining life.',
  `economic_obsolescence_factor` DECIMAL(5,4) COMMENT 'Adjustment factor (0 to 1) representing the impact of external economic factors on asset value, such as changes in market demand, regulatory environment, or competitive conditions.',
  `effective_end_date` DATE COMMENT 'The date on which this valuation ceases to be effective, typically when superseded by a new valuation or when the asset is retired. Null for current valuations.',
  `effective_start_date` DATE COMMENT 'The date from which this valuation becomes effective for regulatory and financial reporting purposes. May differ from valuation date for prospective valuations.',
  `fair_market_value` DECIMAL(18,2) COMMENT 'The estimated price at which the asset would change hands between a willing buyer and willing seller in an arm\'s length transaction. Used for financial reporting and M&A activities.',
  `functional_obsolescence_factor` DECIMAL(5,4) COMMENT 'Adjustment factor (0 to 1) representing the degree of functional obsolescence due to technological advances or changes in operational requirements. Applied to reduce replacement cost for outdated assets.',
  `gross_replacement_cost` DECIMAL(18,2) COMMENT 'The estimated cost to replace the asset with a new equivalent asset at current prices, before any depreciation. Represents the full reproduction cost of the asset in today\'s dollars.',
  `inflation_adjustment_factor` DECIMAL(8,4) COMMENT 'The cumulative inflation factor applied to convert historical asset costs to current replacement costs. Derived from the selected inflation index over the asset\'s life.',
  `inflation_index_applied` STRING COMMENT 'The inflation index used to trend historical costs to current replacement costs, such as Handy-Whitman Index, GDP deflator, or CPI. Specifies the index name and base year.',
  `insurance_value` DECIMAL(18,2) COMMENT 'The value used for insurance coverage determination, representing the cost to replace the asset in the event of loss or damage. May include additional costs for expedited replacement and business interruption.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this valuation record was most recently updated. Tracks changes for audit and compliance purposes.',
  `methodology` STRING COMMENT 'The primary methodology used to determine the asset value: cost approach (replacement cost basis), market approach (comparable sales), income approach (discounted cash flows), hybrid (combination of methods), index trending (inflation-adjusted historical cost), or engineering estimate (technical assessment). Valid values: cost_approach|market_approach|income_approach|hybrid|index_trending|engineering_estimate.',
  `net_book_value` DECIMAL(18,2) COMMENT 'The current book value of the asset calculated as original cost minus accumulated depreciation. Represents the accounting value on the balance sheet.',
  `notes` STRING COMMENT 'Free-text field for additional context, assumptions, limitations, or special considerations related to this valuation. May include references to supporting documentation or regulatory guidance.',
  `odrc_value` DECIMAL(18,2) COMMENT 'The optimised depreciated replacement cost representing the current cost of replacing the asset with its modern equivalent, adjusted for technological improvements and optimised capacity. Critical for RAB determination in regulatory proceedings.',
  `puc_submission_reference` STRING COMMENT 'Reference number for the PUC regulatory filing or rate case submission that includes this valuation. Critical for tracking regulatory approval and RAB determination.',
  `rab_inclusion_flag` BOOLEAN COMMENT 'Indicates whether this asset valuation is included in the Regulatory Asset Base for rate-making purposes. True if the asset is rate-base eligible and approved by the PUC.',
  `rate_case_docket_number` STRING COMMENT 'The official docket number assigned by the PUC for the rate case proceeding in which this valuation was submitted. Used for regulatory tracking and compliance.',
  `remaining_useful_life_years` INT COMMENT 'The estimated number of years of useful service life remaining for the asset at the valuation date. Used for depreciation calculations and capital planning.',
  `report_reference` STRING COMMENT 'Reference number or identifier for the detailed valuation report or appraisal document supporting this valuation record. Links to document management system.',
  `salvage_value` DECIMAL(18,2) COMMENT 'The estimated residual value of the asset at the end of its useful life, representing the amount recoverable through sale or scrap. Used in depreciation calculations and retirement planning.',
  `source_system_code` STRING COMMENT 'Code identifying the source system from which this valuation record originated, such as Ventyx Asset Suite, SAP S/4HANA Asset Accounting, or external appraisal system.',
  `source_system_record_code` STRING COMMENT 'The unique identifier of this valuation record in the source system. Enables traceability and reconciliation with operational systems.',
  `valuation_date` DATE COMMENT 'The date on which the asset valuation was performed or is effective. Critical for regulatory reporting and RAB determination.',
  `valuation_number` STRING COMMENT 'Business identifier for the valuation record, typically assigned by the valuation process or external appraiser. Used for tracking and referencing in regulatory filings.',
  `valuation_status` STRING COMMENT 'Current lifecycle status of the valuation record: draft (initial preparation), under review (internal validation), approved (management sign-off), submitted to PUC (regulatory filing), accepted (PUC approval), rejected (requires revision), or superseded (replaced by newer valuation). Reference-value candidates: draft|under_review|approved|submitted_to_puc|accepted|rejected|superseded.',
  `valuation_type` STRING COMMENT 'The type or purpose of the valuation: RAB (Regulatory Asset Base) for rate case filings, insurance replacement cost for coverage determination, fair value for financial reporting, depreciated replacement cost for asset management, market value for disposal decisions, or liquidation value for decommissioning scenarios. Valid values: rab|insurance_replacement_cost|fair_value|depreciated_replacement_cost|market_value|liquidation_value.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_valuation` PRIMARY KEY (`valuation_id`)
)
USING DELTA
COMMENT 'Periodic valuation record for utility assets supporting RAB (Regulatory Asset Base) determination, insurance valuation, and fair value assessment. Captures valuation date, valuation type (RAB, insurance replacement cost, fair value, depreciated replacement cost), gross replacement cost, accumulated depreciation, optimised depreciated replacement cost (ODRC), valuation methodology, valuation basis (independent appraisal, internal estimate), appraiser reference, and PUC/regulatory submission reference. Critical for IRP and rate case filings. | CMM: CIM FinancialInfo (close), IEC61968::Assets.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AssetValuation',
  'cmm.cim.class' = 'FinancialInfo',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Assets',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.valuation'
);

-- AssetRetirement  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `asset`.`retirement` (
  `retirement_id` BIGINT NOT NULL COMMENT 'Unique identifier for the asset retirement event record. Primary key for the asset retirement data product.',
  `capital_project_id` BIGINT COMMENT 'Reference to the capital project under which the asset retirement was executed, if part of a planned capital program. Links to capital project management for CAPEX tracking and program reporting.',
  `disposal_vendor_id` BIGINT COMMENT 'Reference to the vendor or contractor who performed the asset disposal or environmental remediation services. Links to vendor master for procurement and payment tracking.',
  `distribution_transformer_id` BIGINT COMMENT 'Foreign key linking to distribution.transformer. Business justification: Transformer retirements must be tracked for RAB removal, gain/loss on disposal accounting, salvage value recovery, environmental compliance (PCB disposal), and replacement asset linkage. Required for',
  `environmental_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.environmental_permit. Business justification: Asset retirements must comply with environmental permits governing decommissioning, hazardous material disposal, and site remediation. Tracking which permit governs each retirement ensures environment',
  `feeder_id` BIGINT COMMENT 'Foreign key linking to distribution.feeder. Business justification: Feeder retirements (decommissioning, reconfiguration, voltage conversion) require tracking for RAB removal, regulatory accounting (FERC Form 1), salvage value recovery, and system planning updates. Es',
  `irp_scenario_id` BIGINT COMMENT 'Foreign key linking to forecast.irp_scenario. Business justification: Asset retirements are planned within IRP scenarios. Retirement schedules are key IRP inputs and outputs. Tracking which IRP scenario drove a retirement decision is required for regulatory filings, rat',
  `retirement_approved_by_user_employee_id` BIGINT COMMENT 'Reference to the user who approved the asset retirement transaction. Used for audit trail and SOX compliance.',
  `retirement_employee_id` BIGINT COMMENT 'Reference to the user who initiated the asset retirement transaction. Used for audit trail and accountability.',
  `retirement_registry_id` BIGINT COMMENT 'Reference to the asset being retired. Links to the master asset registry for generation units, transmission towers, distribution poles, transformers, switchgear, protection relays, substation equipment, fleet vehicles, and facilities.',
  `retirement_replacement_asset_asset_registry_id` BIGINT COMMENT 'Reference to the new asset that replaced the retired asset, if applicable. Links to the master asset registry for tracking asset replacement programs and capital project execution.',
  `work_order_id` BIGINT COMMENT 'Reference to the work order that executed the asset retirement and decommissioning activities. Links to Ventyx Asset Suite work management for labor, materials, and cost tracking.',
  `approval_date` DATE COMMENT 'The date on which the asset retirement was approved by management or regulatory authority. Part of the retirement lifecycle audit trail.',
  `asset_class_code` STRING COMMENT 'FERC or utility-specific asset class code for the retired asset. Used for financial reporting, depreciation studies, and regulatory rate case filings.',
  `cost_center_code` STRING COMMENT 'The cost center to which retirement and decommissioning costs are charged. Used for Operations and Maintenance (O&M) cost tracking and financial reporting.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this asset retirement record was first created in the system. Part of the audit trail for data lineage and compliance.',
  `decommissioning_cost` DECIMAL(18,2) COMMENT 'The total cost incurred to decommission and remove the asset from service, including labor, equipment, environmental remediation, and disposal fees. Expressed in the utility\'s functional currency.',
  `depreciation_reserve_released` DECIMAL(18,2) COMMENT 'The accumulated depreciation reserve amount released upon asset retirement. Used for financial reconciliation and regulatory reporting.',
  `disposal_date` DATE COMMENT 'The date on which the physical disposal or transfer of the retired asset was completed. May differ from retirement date if asset remained in inventory or storage after retirement from service.',
  `disposal_method` STRING COMMENT 'The method by which the retired asset was disposed of or removed from inventory. Values include scrap (recycled or scrapped for materials), sale (sold to third party), transfer (transferred to another entity or business unit), donation (donated to external organization), write-off (financial write-off with no physical disposal), environmental disposal (specialized disposal for hazardous materials such as PCB transformers or asbestos-containing equipment). Valid values: scrap|sale|transfer|donation|write_off|environmental_disposal.',
  `environmental_compliance_flag` BOOLEAN COMMENT 'Boolean indicator of whether the asset retirement and disposal process complied with all applicable environmental regulations. True indicates full compliance with EPA standards for hazardous material disposal (e.g., PCB transformers, asbestos-containing equipment, SF6 gas handling).',
  `environmental_disposal_permit_number` STRING COMMENT 'Reference number for the environmental disposal permit or certification obtained for hazardous material disposal. Required for assets containing PCBs, asbestos, lead, or other regulated substances.',
  `functional_location_code` STRING COMMENT 'The functional location or network position where the retired asset was installed. Used for geographic and network topology analysis of retirement patterns.',
  `gain_loss_on_disposal` DECIMAL(18,2) COMMENT 'The calculated financial gain or loss on asset disposal, computed as salvage value realized minus net book value at retirement minus decommissioning cost. Positive values indicate gain, negative values indicate loss.',
  `gl_account_code` STRING COMMENT 'The general ledger account code to which the retirement transaction is posted. Used for financial accounting and FERC Uniform System of Accounts compliance.',
  `insurance_claim_reference` STRING COMMENT 'Reference number for any insurance claim filed related to the asset retirement, particularly for catastrophic failure or damage events. Used for insurance recovery tracking.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this asset retirement record was last modified. Part of the audit trail for data lineage and compliance.',
  `net_book_value_at_retirement` DECIMAL(18,2) COMMENT 'The net book value of the asset at the time of retirement, calculated as original cost less accumulated depreciation. Used to calculate gain or loss on disposal and for regulatory asset base (RAB) adjustments.',
  `notes` STRING COMMENT 'Free-form text field for additional notes, comments, or special circumstances related to the asset retirement. Used for capturing context not covered by structured fields.',
  `rab_removal_amount` DECIMAL(18,2) COMMENT 'The monetary amount removed from the regulatory asset base upon asset retirement. Used for rate case filings and regulatory reporting to state Public Utility Commissions (PUCs) and FERC.',
  `rab_removal_date` DATE COMMENT 'The date on which the asset was removed from the regulatory asset base for rate-making purposes. Critical for regulatory compliance and revenue requirement calculations. May differ from retirement date based on regulatory approval timing.',
  `reason_code` STRING COMMENT 'Categorical code indicating the primary reason for asset retirement. Values include end of life (asset reached expected useful life), catastrophic failure (unrecoverable damage or failure), obsolescence (technology or standards obsolete), regulatory mandate (compliance requirement), network reconfiguration (grid modernization or topology change), replacement (planned upgrade or substitution), performance degradation (no longer meets operational standards). Reference-value candidates: end_of_life|catastrophic_failure|obsolescence|regulatory_mandate|network_reconfiguration|replacement|performance_degradation.',
  `reason_description` STRING COMMENT 'Detailed narrative explanation of the specific circumstances and business justification for the asset retirement. Provides context beyond the categorical reason code for audit, regulatory reporting, and asset management analysis.',
  `regulatory_approval_date` DATE COMMENT 'The date on which regulatory approval for asset retirement was granted by FERC, state PUC, or other governing body. Null if regulatory approval was not required.',
  `regulatory_approval_required_flag` BOOLEAN COMMENT 'Boolean indicator of whether regulatory approval was required prior to asset retirement. True for assets subject to Certificate of Public Convenience and Necessity (CPCN) or other regulatory oversight.',
  `regulatory_notification_reference` STRING COMMENT 'Reference number or identifier for the regulatory notification or filing submitted to FERC, state PUC, or other governing body regarding the asset retirement. Required for major transmission and generation asset retirements.',
  `retirement_category` STRING COMMENT 'High-level categorization of the retired asset by utility functional area. Used for portfolio analysis and regulatory reporting segmentation. Valid values: generation|transmission|distribution|substation|fleet|facility.',
  `retirement_date` DATE COMMENT 'The date on which the asset was officially retired from service. This is the principal business event timestamp for the retirement transaction and marks the end of the asset\'s operational lifecycle.',
  `retirement_number` STRING COMMENT 'Business identifier for the retirement transaction. Externally-known reference number used in regulatory filings, financial reporting, and audit trails.',
  `retirement_status` STRING COMMENT 'Current lifecycle status of the retirement transaction. Values include planned (scheduled for future retirement), in progress (decommissioning underway), completed (retirement and disposal finalized), cancelled (retirement cancelled), pending approval (awaiting regulatory or management approval). Valid values: planned|in_progress|completed|cancelled|pending_approval.',
  `salvage_value_realized` DECIMAL(18,2) COMMENT 'The actual monetary value recovered from the disposal of the retired asset through sale, scrap, or other means. Expressed in the utility\'s functional currency. Used for financial reconciliation and variance analysis against estimated salvage value.',
  `source_system_code` STRING COMMENT 'Code identifying the source system from which the retirement record originated. Primary sources are SAP S/4HANA FI-AA for financial asset retirement and Ventyx Asset Suite for operational retirement tracking. Valid values: SAP_S4HANA|VENTYX|MANUAL.',
  `source_system_record_code` STRING COMMENT 'The unique identifier of this retirement record in the source system. Used for data lineage, reconciliation, and troubleshooting.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_retirement` PRIMARY KEY (`retirement_id`)
)
USING DELTA
COMMENT 'Record of asset decommissioning, disposal, or retirement events. Captures retirement date, retirement reason (end of life, failure, regulatory, network reconfiguration, replacement), disposal method (scrap, sale, transfer, write-off), salvage value realised, environmental disposal compliance flag (e.g., PCB transformer disposal, asbestos), decommissioning cost, RAB removal date, and regulatory notification reference. Sourced from SAP S/4HANA FI-AA asset retirement and Ventyx Asset Suite. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AssetRetirement',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.retirement'
);

-- AssetWarranty  <<CIM Agreement : extension>>
CREATE TABLE IF NOT EXISTS `asset`.`warranty` (
  `warranty_id` BIGINT NOT NULL COMMENT 'Unique identifier for the asset warranty record. Primary key for the asset warranty product.',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: Manufacturer warranties on DER equipment (inverters 10-25 years, batteries 10 years, turbines 5-10 years) critical for O&M cost forecasting, replacement planning, and failure cost recovery. Required f',
  `provider_vendor_id` BIGINT COMMENT 'Foreign key linking to supply.vendor. Business justification: Warranties are contractual agreements with vendors (OEMs or third-party providers). Formalizes manufacturer_name into vendor master for warranty claim processing, vendor performance evaluation, and tr',
  `registry_id` BIGINT COMMENT 'Reference to the utility asset covered by this warranty. Links to the asset registry for generation units, transformers, switchgear, protection relays, substation equipment, transmission towers, distribution poles, fleet vehicles, and facilities.',
  `warranty_employee_id` BIGINT COMMENT 'Identifier of the user who created the warranty record in the system. Used for audit trail and data governance.',
  `warranty_last_modified_by_user_employee_id` BIGINT COMMENT 'Identifier of the user who last modified the warranty record. Used for audit trail and change tracking.',
  `claim_documentation_required` STRING COMMENT 'Description of documentation required to support warranty claims, such as failure reports, inspection records, maintenance logs, photographs, or condition monitoring data from SCADA or OSIsoft PI.',
  `claim_submission_method` STRING COMMENT 'Preferred or required method for submitting warranty claims to the manufacturer. Online portals provide fastest processing; email and phone are common alternatives; fax and mail are legacy methods. Valid values: online_portal|email|phone|fax|mail.',
  `claims_approved_count` INT COMMENT 'Total number of warranty claims approved and settled to date. Used to calculate claim approval rate and supplier responsiveness metrics.',
  `claims_limit_amount` DECIMAL(18,2) COMMENT 'Maximum aggregate claim amount in USD allowed during the coverage period. Nullable if unlimited claim value is permitted. Used for financial exposure management.',
  `claims_limit_count` INT COMMENT 'Maximum number of warranty claims allowed during the coverage period. Nullable if unlimited claims are permitted. Used to track claim utilization and prevent warranty abuse.',
  `claims_rejected_count` INT COMMENT 'Total number of warranty claims rejected by the manufacturer to date. Used to identify warranty coverage disputes and supplier performance issues.',
  `claims_submitted_count` INT COMMENT 'Total number of warranty claims submitted to date for this warranty agreement. Used to track claim utilization against claims limit and for supplier performance analysis.',
  `contract_reference_number` STRING COMMENT 'Reference number for the master service contract or extended warranty agreement. Used to link warranty records to contract management systems.',
  `coverage_scope` STRING COMMENT 'Detailed description of what components, failures, and conditions are covered under the warranty. Specifies inclusions such as parts, labor, travel, and exclusions such as normal wear, misuse, or environmental damage.',
  `covered_components` STRING COMMENT 'Comma-separated list or detailed enumeration of specific asset components covered by the warranty. For transformers may include windings, bushings, tap changers; for generators may include rotor, stator, bearings, exciter.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the warranty record was first created in the system. Audit trail field for data lineage and compliance reporting.',
  `deductible_amount` DECIMAL(18,2) COMMENT 'Deductible amount in USD that the utility must pay before warranty coverage applies. Common in extended warranty agreements and service contracts.',
  `document_url` STRING COMMENT 'URL or file path to the digital warranty certificate, terms and conditions document, or service agreement. Provides quick access to warranty documentation for claim processing.',
  `duration_months` INT COMMENT 'Total duration of warranty coverage expressed in months. Standard manufacturer warranties typically range from 12 to 60 months; extended warranties may exceed 120 months for critical utility assets.',
  `end_date` DATE COMMENT 'Expiration date when warranty coverage terminates. Used for proactive warranty expiry management and planning for post-warranty maintenance strategies. Nullable for lifetime warranties.',
  `exclusions` STRING COMMENT 'Detailed description of conditions, failures, or circumstances explicitly excluded from warranty coverage. Common exclusions include normal wear and tear, misuse, unauthorized modifications, environmental damage, and force majeure events.',
  `labor_covered_flag` BOOLEAN COMMENT 'Indicates whether labor costs for repair or replacement are covered under the warranty. True if labor is included; false if parts-only warranty.',
  `last_claim_date` DATE COMMENT 'Date of the most recent warranty claim submission. Used to track claim frequency and identify assets with recurring failures.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the warranty record was last updated. Audit trail field for tracking warranty status changes, claim updates, and data corrections.',
  `maintenance_requirements` STRING COMMENT 'Description of preventive maintenance activities required to maintain warranty validity. May include inspection frequency, lubrication schedules, condition monitoring, and use of OEM parts. Non-compliance may void warranty.',
  `manufacturer_contact_email` STRING COMMENT 'Email address for the manufacturer warranty contact. Business-confidential organizational contact information used for claim correspondence. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `manufacturer_contact_name` STRING COMMENT 'Primary contact person at the manufacturer or supplier for warranty administration and claim processing.',
  `manufacturer_contact_phone` STRING COMMENT 'Phone number for the manufacturer warranty contact. Business-confidential organizational contact information.',
  `notes` STRING COMMENT 'Free-text field for additional warranty information, special terms, claim history notes, or internal comments. Used for warranty administration and knowledge management.',
  `parts_covered_flag` BOOLEAN COMMENT 'Indicates whether replacement parts are covered under the warranty. True if parts are included; false if labor-only warranty.',
  `performance_guarantee_flag` BOOLEAN COMMENT 'Indicates whether the warranty includes performance guarantees such as minimum efficiency, capacity factor, or availability. Common for generation units and renewable energy assets under Power Purchase Agreements (PPA).',
  `prorated_flag` BOOLEAN COMMENT 'Indicates whether warranty coverage or claim value is prorated based on asset age or usage. True if prorated; false if full coverage throughout warranty period.',
  `purchase_order_number` STRING COMMENT 'Purchase order number associated with the asset acquisition and warranty agreement. Links warranty to procurement records in SAP S/4HANA Materials Management (MM).',
  `registration_date` DATE COMMENT 'Date when the warranty was registered with the manufacturer. Some warranties require registration within a specified period after installation to activate coverage.',
  `repair_time_hours` INT COMMENT 'Maximum time in hours for the manufacturer to complete repair or replacement under warranty. Service Level Agreement (SLA) metric impacting System Average Interruption Duration Index (SAIDI) for critical assets.',
  `response_time_hours` INT COMMENT 'Maximum time in hours for the manufacturer to respond to a warranty claim or service request. Service Level Agreement (SLA) metric for critical utility infrastructure.',
  `start_date` DATE COMMENT 'Effective start date when warranty coverage begins. Typically aligned with asset commissioning date or installation date. Critical for determining coverage eligibility and expiry calculation.',
  `total_claims_recovered_amount` DECIMAL(18,2) COMMENT 'Cumulative amount in USD recovered through approved warranty claims to date. Used for Operational Expenditure (OPEX) cost recovery tracking and supplier performance analysis.',
  `total_warranty_value` DECIMAL(18,2) COMMENT 'Total monetary value of the warranty coverage in USD. Represents the maximum potential claim recovery or the insured value of covered components. Used for financial risk assessment and Capital Expenditure (CAPEX) planning.',
  `transferable_flag` BOOLEAN COMMENT 'Indicates whether the warranty can be transferred to a new owner if the asset is sold or relocated. Relevant for fleet vehicles, mobile equipment, and assets subject to ownership changes.',
  `travel_covered_flag` BOOLEAN COMMENT 'Indicates whether technician travel and mobilization costs are covered under the warranty. Particularly relevant for remote utility assets such as transmission towers and rural substations.',
  `warranty_number` STRING COMMENT 'Unique warranty certificate or agreement number issued by the manufacturer or supplier. Business identifier for external reference and claim submission.',
  `warranty_status` STRING COMMENT 'Current lifecycle state of the warranty agreement. Active warranties are in force and eligible for claims; expired warranties have passed their coverage period; cancelled warranties were terminated early; suspended warranties are temporarily inactive; pending activation warranties are registered but not yet effective. Valid values: active|expired|cancelled|suspended|pending_activation.',
  `warranty_type` STRING COMMENT 'Classification of warranty coverage. Manufacturer standard warranties are included with equipment purchase; extended warranties provide coverage beyond standard terms; service contracts cover ongoing maintenance; performance guarantees ensure operational specifications. Reference-value candidates: manufacturer_standard|extended|service_contract|performance_guarantee|parts_only|labor_only|comprehensive.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_warranty` PRIMARY KEY (`warranty_id`)
)
USING DELTA
COMMENT 'Warranty records and claim management for utility assets and equipment. Covers manufacturer warranty terms, extended warranty agreements, warranty start and expiry dates, covered components, and supplier/OEM contact details. Also captures warranty claim transactions including claim date, failure description, claim status (submitted, acknowledged, accepted, rejected, settled), replacement or repair outcome, credit value, and resolution date. Enables proactive warranty expiry management, claim cost recovery tracking, and supplier performance analysis. Sourced from Ventyx Asset Suite and SAP S/4HANA MM contract management. | CMM: CIM Agreement (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AssetWarranty',
  'cmm.cim.class' = 'Agreement',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.warranty'
);

-- AssetRiskAssessment  <<CIM RiskScore : close>>
CREATE TABLE IF NOT EXISTS `asset`.`asset_risk_assessment` (
  `asset_risk_assessment_id` BIGINT NOT NULL COMMENT 'Unique identifier for the asset risk assessment record.',
  `assessor_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Risk assessments determine asset replacement priorities and capital investment decisions worth millions. Regulatory prudency reviews require documented qualified assessor credentials. This link provid',
  `asset_registry_id` BIGINT COMMENT 'FK to asset.asset_registry.asset_registry_id — Risk assessments evaluate specific assets. This FK is essential for risk-based maintenance prioritization and IRP investment justification.',
  `compliance_obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Risk assessments evaluate compliance with regulatory standards (NERC TPL transmission planning, distribution reliability requirements, FERC dam safety). Linking assessments to obligations enables comp',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: Risk scoring for DER assets considering technology obsolescence, performance degradation rates, grid integration challenges, and stranded asset risk. Supports investment planning, rate case prudency d',
  `irp_scenario_id` BIGINT COMMENT 'Foreign key linking to forecast.irp_scenario. Business justification: Risk assessments inform IRP scenario development. High-risk assets identified in assessments feed into IRP capacity expansion and replacement plans. Essential for risk-informed integrated resource pla',
  `registry_id` BIGINT COMMENT 'Reference to the utility asset being assessed in the asset registry.',
  `assessment_confidence_level` STRING COMMENT 'Confidence level in the risk assessment results based on data quality, methodology rigor, and subject matter expert validation. Valid values: high|medium|low.',
  `assessment_date` DATE COMMENT 'Date when the risk assessment was performed.',
  `assessment_notes` STRING COMMENT 'Free-text notes and observations from the risk assessment including assumptions, limitations, and special considerations.',
  `assessment_status` STRING COMMENT 'Current lifecycle status of the risk assessment record. Valid values: draft|submitted|under_review|approved|superseded|archived.',
  `assessment_type` STRING COMMENT 'Type of risk assessment performed indicating the trigger or purpose of the assessment. Valid values: initial|periodic|condition-triggered|event-triggered|pre-investment|post-incident.',
  `benefit_cost_ratio` DECIMAL(7,2) COMMENT 'Cost-benefit ratio calculated as risk reduction benefit divided by intervention cost estimate, used for investment justification and IRP (Integrated Resource Plan) prioritization.',
  `consequence_of_failure_rating` STRING COMMENT 'Qualitative consequence of failure rating band derived from the aggregate CoF score. Valid values: negligible|minor|moderate|major|severe|catastrophic.',
  `consequence_of_failure_score` DECIMAL(5,2) COMMENT 'Aggregate consequence of failure score combining safety, environmental, reliability, financial, and regulatory impact categories.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this risk assessment record was first created in the lakehouse.',
  `data_quality_score` DECIMAL(5,2) COMMENT 'Quality score for the input data used in the risk assessment including asset condition data, failure history, loading data, and environmental factors. Scale 0-100.',
  `environmental_consequence_score` DECIMAL(5,2) COMMENT 'Impact score for environmental consequences of asset failure including emissions, spills, contamination, and EPA violations.',
  `financial_consequence_score` DECIMAL(5,2) COMMENT 'Impact score for direct financial consequences including replacement cost, emergency repair cost, lost revenue, and regulatory penalties.',
  `intervention_cost_estimate` DECIMAL(15,2) COMMENT 'Estimated cost in USD to execute the recommended intervention including materials, labor, outage costs, and project management.',
  `intervention_priority` STRING COMMENT 'Priority level for executing the recommended intervention based on risk-informed maintenance planning. Valid values: immediate|urgent|high|medium|low|deferred.',
  `irp_inclusion_flag` BOOLEAN COMMENT 'Indicates whether this risk assessment and recommended intervention are included in the utility\'s Integrated Resource Plan for PUC review and approval.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this risk assessment record was last modified in the lakehouse.',
  `nerc_compliance_flag` BOOLEAN COMMENT 'Indicates whether this risk assessment is required for NERC CIP (Critical Infrastructure Protection) compliance or other NERC reliability standards.',
  `net_present_value` DECIMAL(15,2) COMMENT 'Net present value in USD of the recommended intervention considering risk reduction benefits, intervention costs, and discount rate over the planning horizon.',
  `next_assessment_due_date` DATE COMMENT 'Scheduled date for the next periodic risk assessment based on asset criticality and risk band.',
  `overall_risk_score` DECIMAL(7,2) COMMENT 'Composite risk score calculated as the product or weighted combination of probability of failure and consequence of failure scores per the selected risk methodology.',
  `payback_period_years` DECIMAL(5,2) COMMENT 'Estimated payback period in years for the intervention investment based on annual risk reduction benefits.',
  `probability_of_failure_rating` STRING COMMENT 'Qualitative probability of failure rating band derived from the quantitative PoF score. Valid values: very_low|low|medium|high|very_high|critical.',
  `probability_of_failure_score` DECIMAL(5,2) COMMENT 'Quantitative probability of failure score based on asset age, condition, loading, and environmental factors. Scale typically 0-100 or 0-1 depending on methodology.',
  `puc_prudency_evidence_flag` BOOLEAN COMMENT 'Indicates whether this risk assessment serves as prudency review evidence for capital investment justification to the Public Utility Commission.',
  `rab_impact_flag` BOOLEAN COMMENT 'Indicates whether the recommended intervention will impact the Regulatory Asset Base valuation and rate base calculations.',
  `recommended_intervention` STRING COMMENT 'Recommended risk mitigation intervention strategy based on the risk assessment results. Reference-value candidates: replace|refurbish|upgrade|increase_monitoring|condition_assessment|accept_risk|no_action.',
  `regulatory_consequence_score` DECIMAL(5,2) COMMENT 'Impact score for regulatory and compliance consequences including NERC CIP violations, FERC penalties, PUC sanctions, and service level agreement breaches.',
  `reliability_consequence_score` DECIMAL(5,2) COMMENT 'Impact score for system reliability consequences measured by customer interruptions, SAIDI (System Average Interruption Duration Index), SAIFI (System Average Interruption Frequency Index), and load at risk.',
  `review_date` DATE COMMENT 'Date when the risk assessment was reviewed and approved.',
  `reviewer_name` STRING COMMENT 'Name of the senior engineer or manager who reviewed and approved the risk assessment.',
  `risk_assessment_asset` BIGINT COMMENT 'FK to asset.asset_registry.asset_registry_id — Risk assessments evaluate specific assets. The FK is required for risk-based maintenance prioritization and investment planning.',
  `risk_assessment_to_asset` BIGINT COMMENT 'FK to asset.asset_registry.asset_registry_id — Risk assessments are performed on specific assets. The FK enables risk-ranked asset registers and investment prioritization for IRP submissions.',
  `risk_band` STRING COMMENT 'Overall risk classification band derived from the overall risk score used for prioritization and investment planning. Valid values: critical|high|medium|low|negligible.',
  `risk_methodology` STRING COMMENT 'Industry-standard risk assessment methodology applied (risk matrix, Monte Carlo simulation, Weibull analysis, Fault Tree Analysis, Bow-Tie, Failure Mode and Effects Analysis). Valid values: risk_matrix|monte_carlo|weibull_analysis|fault_tree|bow_tie|fmea.',
  `risk_rank` INT COMMENT 'Relative ranking of this asset risk within the asset portfolio or asset class for prioritization purposes.',
  `risk_reduction_benefit` DECIMAL(15,2) COMMENT 'Estimated monetary benefit in USD from risk reduction achieved by the recommended intervention, calculated as avoided consequence cost weighted by probability reduction.',
  `safety_consequence_score` DECIMAL(5,2) COMMENT 'Impact score for public and worker safety consequences of asset failure including potential injuries, fatalities, and OSHA reportable incidents.',
  `source_system_code` STRING COMMENT 'Code identifying the source system that generated this risk assessment record (e.g., Ventyx Asset Suite Risk module, enterprise risk management system).',
  `source_system_record_code` STRING COMMENT 'Unique identifier of this risk assessment record in the source system for traceability and reconciliation.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_asset_risk_assessment` PRIMARY KEY (`asset_risk_assessment_id`)
)
USING DELTA
COMMENT 'Risk-based assessment record for utility assets evaluating probability of failure (PoF), consequence of failure (CoF), and overall asset risk score using industry-standard methodologies. Captures assessment date, risk methodology (risk matrix, Monte Carlo simulation, Weibull analysis), probability of failure rating based on age, condition, loading, and environment, consequence categories (safety, environment, reliability/SAIDI-SAIFI impact, financial, regulatory/compliance), overall risk score, risk band (critical, high, medium, low), recommended intervention (replace, refurbish, increase monitoring, accept risk), cost-benefit analysis of intervention, and risk-informed maintenance priority ranking. Supports risk-based asset management (RBAM) per ISO 55000, IRP investment justification, and PUC prudency review evidence. Sourced from Ventyx Asset Suite Risk module and enterprise risk management systems. | CMM: CIM RiskScore (close), IEC61968::Assets.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AssetRiskAssessment',
  'cmm.cim.class' = 'RiskScore',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Assets',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.asset_risk_assessment'
);

-- WorkOrderMaterialIssue  <<CIM MaterialItem : close>>
CREATE TABLE IF NOT EXISTS `asset`.`work_order_material_issue` (
  `work_order_material_issue_id` BIGINT NOT NULL COMMENT 'Unique identifier for the material issue transaction record. Primary key for the association.',
  `issued_by_employee_id` BIGINT COMMENT 'Reference to the storeroom clerk, technician, or employee who physically issued the material from inventory. Used for accountability and audit purposes.',
  `spare_parts_inventory_id` BIGINT COMMENT 'Foreign key linking to the spare parts inventory item that was issued. Identifies which material master record was consumed.',
  `work_order_id` BIGINT COMMENT 'Foreign key linking to the work order that consumed the material. Identifies which maintenance activity the spare part was issued against.',
  `cost_center_charged` STRING COMMENT 'Financial cost center code to which this material consumption cost is allocated. May differ from the work order cost center if material is charged to a different organizational unit.',
  `gl_account_code` STRING COMMENT 'General ledger account code for financial posting of the material cost. Aligns with chart of accounts for O&M expense or capital project accounting.',
  `issue_date` DATE COMMENT 'Calendar date when the material was issued from inventory to the work order. Used for inventory transaction history and cost period allocation.',
  `issue_timestamp` TIMESTAMP COMMENT 'Precise date and time when the material issue transaction was recorded in the EAM system. Provides audit trail and chronological sequencing of material movements.',
  `material_document_number` STRING COMMENT 'Unique document identifier for the material issue transaction in the EAM or ERP system (e.g., SAP Material Document, Maximo Issue Record). Provides audit trail and cross-system reconciliation.',
  `quantity_issued` DECIMAL(15,3) COMMENT 'Quantity of the spare part or material issued from inventory to the work order. Measured in the unit of measure defined in the spare parts inventory record. This is the primary consumption metric.',
  `quantity_returned` DECIMAL(15,3) COMMENT 'Quantity of the spare part or material returned to inventory after work order completion (unused or excess material). Used to adjust actual consumption and inventory levels.',
  `reservation_number` STRING COMMENT 'Material reservation or requisition number that pre-allocated this inventory item to the work order. Links the issue transaction to the planning phase reservation record.',
  `return_date` DATE COMMENT 'Calendar date when unused or excess material was returned to inventory from the work order. Null if no return occurred.',
  `unit_cost_at_issue` DECIMAL(15,2) COMMENT 'Standard or moving average cost per unit at the time the material was issued. Captures the cost basis for work order cost allocation, which may differ from current inventory unit cost due to price changes over time.',
  `work_order_line_number` STRING COMMENT 'Line item sequence number within the work order material list. Used for organizing and referencing multiple material issues on the same work order.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_work_order_material_issue` PRIMARY KEY (`work_order_material_issue_id`)
)
USING DELTA
COMMENT 'This association product represents the Material Issue Transaction between work_order and spare_parts_inventory. It captures the consumption of spare parts, materials, and consumables against maintenance work orders in utility asset management operations. Each record links one work order to one spare part inventory item with transactional attributes including quantities issued and returned, costs at time of issue, timestamps, material document references, and cost allocation codes. This is a core operational entity in EAM/CMMS systems (Ventyx Asset Suite, SAP PM, Maximo) that enables material cost tracking, inventory consumption analysis, and work order cost rollup.. Existence Justification: In utility asset management operations, maintenance work orders consume multiple spare parts and materials (transformers, insulators, cables, tools, consumables), and each spare part in inventory is issued to multiple work orders over its lifecycle. Material issue transactions are actively created by storeroom clerks and technicians during work execution, with each transaction recording quantities, costs, timestamps, and document references. This is a recognized operational entity in EAM systems called Material Issue, Parts Consumption, or Material Document. | CMM: CIM MaterialItem (close), IEC61968::Work.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'WorkOrderMaterialIssue',
  'cmm.cim.class' = 'MaterialItem',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Work',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.work_order_material_issue'
);

-- AssetProgramEnrollment  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `asset`.`asset_program_enrollment` (
  `asset_program_enrollment_id` BIGINT NOT NULL COMMENT 'Primary key for asset_program_enrollment',
  `dr_program_id` BIGINT COMMENT 'Foreign key linking to the demand response program',
  `program_id` BIGINT COMMENT 'Unique identifier for this asset-program enrollment record. Primary key.',
  `registry_id` BIGINT COMMENT 'Foreign key linking to the enrolled asset in the asset registry',
  `average_performance_percentage` DECIMAL(5,2) COMMENT 'Rolling average of actual load reduction achieved versus committed enrolled capacity across all dispatch events for this asset-program combination. Used for performance tier assignment.',
  `baseline_methodology` STRING COMMENT 'The specific baseline calculation methodology applied to this asset for this program. May differ from program default if asset has unique operational characteristics requiring customized M&V approach.',
  `cumulative_dispatch_hours_ytd` DECIMAL(8,2) COMMENT 'Year-to-date cumulative hours this asset has been dispatched under this program. Used to monitor compliance with max_event_hours_per_year program limits.',
  `enrolled_capacity_kw` DECIMAL(12,3) COMMENT 'The committed load reduction capacity in kilowatts for this specific asset under this DR program. Aggregated across all asset enrollments to calculate program-level enrolled_capacity_actual_mw.',
  `enrollment_date` DATE COMMENT 'Date when this specific asset was enrolled into this DR program. Used for eligibility calculations and incentive accrual start date.',
  `enrollment_end_date` DATE COMMENT 'Date when this asset\'s enrollment in this DR program ended or is scheduled to end. Null for active ongoing enrollments.',
  `incentive_rate` DECIMAL(15,2) COMMENT 'The specific incentive payment rate ($/kW or $/kWh) applicable to this asset for this program. May vary from program base rate based on performance tier, asset criticality, or negotiated terms.',
  `last_dispatch_date` DATE COMMENT 'Date of the most recent DR event dispatch where this asset was called to reduce load under this program. Used for performance tracking and compliance monitoring.',
  `participation_status` STRING COMMENT 'Current status of this asset\'s participation in this DR program. Active indicates asset is eligible for dispatch. Suspended indicates temporary exclusion. Withdrawn indicates permanent removal. Pending indicates enrollment awaiting approval.',
  `performance_tier` STRING COMMENT 'Performance classification for this asset within this program based on historical dispatch compliance and load reduction achievement. Used to determine incentive rates and dispatch priority.',
  `withdrawal_reason` STRING COMMENT 'Business reason for asset withdrawal from program (e.g., asset retired, performance non-compliance, program requirements changed, operational constraints). Populated when participation_status is Withdrawn.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_asset_program_enrollment` PRIMARY KEY (`asset_program_enrollment_id`)
)
USING DELTA
COMMENT 'This association product represents the enrollment relationship between physical utility assets and demand response programs. It captures the operational participation of specific assets (substations, feeders, transformers) in DR programs, including capacity commitments, performance tracking, and settlement parameters. Each record links one asset to one DR program with attributes that exist only in the context of this enrollment relationship.. Existence Justification: In energy utility operations, physical distribution assets (substations, feeders, transformers) are enrolled in multiple demand response programs simultaneously to serve different grid reliability and market participation objectives. A single substation may participate in ISO capacity markets, emergency DR programs, economic dispatch programs, and voltage support programs concurrently. Each enrollment has distinct capacity commitments, performance metrics, baseline methodologies, and settlement rates that are managed independently by the demand response operations team. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AssetProgramEnrollment',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.asset_program_enrollment'
);

-- AssetCompliance  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `asset`.`asset_compliance` (
  `asset_compliance_id` BIGINT NOT NULL COMMENT 'Primary key for asset_compliance',
  `compliance_obligation_id` BIGINT COMMENT 'Unique identifier for this asset-obligation compliance tracking record. Primary key.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to the regulatory compliance obligation being verified',
  `registry_id` BIGINT COMMENT 'Foreign key linking to the physical utility asset being tracked for compliance',
  `remediation_plan_id` BIGINT COMMENT 'Reference to the remediation or mitigation plan if this asset-obligation pair is in non-compliance or conditional status.',
  `applicability_determination_date` DATE COMMENT 'Date when it was determined that this obligation applies to this asset, based on asset characteristics (voltage class, criticality, location) and obligation scope.',
  `compliance_status` STRING COMMENT 'Current compliance status of this specific asset with respect to this specific obligation. Explicitly identified in detection reasoning as relationship data.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this asset-obligation compliance tracking record was created in the system.',
  `evidence_reference` STRING COMMENT 'Reference identifier or location of compliance evidence documentation for this asset-obligation pair (e.g., inspection report ID, test result document, audit file reference). Explicitly identified in detection reasoning as relationship data.',
  `last_audit_finding` STRING COMMENT 'Most recent audit finding specific to this asset\'s compliance with this obligation (pass, minor-finding, major-finding, observation).',
  `last_compliance_verification_date` DATE COMMENT 'Date when compliance of this asset with this obligation was most recently verified through inspection, testing, or audit. Explicitly identified in detection reasoning as relationship data.',
  `next_compliance_due_date` DATE COMMENT 'Next scheduled date by which this asset must be verified for compliance with this obligation, based on the obligation\'s compliance frequency and asset-specific factors. Explicitly identified in detection reasoning as relationship data.',
  `non_compliance_risk_score` INT COMMENT 'Calculated risk score for this asset-obligation pair based on asset criticality, obligation VRF/VSL, and current compliance status. Used for audit prioritization.',
  `responsible_party` STRING COMMENT 'Name or identifier of the individual or organizational unit responsible for ensuring this asset\'s compliance with this obligation. Explicitly identified in detection reasoning as relationship data.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this compliance record was last updated, reflecting changes in status, verification dates, or responsible parties.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_asset_compliance` PRIMARY KEY (`asset_compliance_id`)
)
USING DELTA
COMMENT 'This association product represents the compliance tracking relationship between physical utility assets and regulatory obligations. It captures the compliance status, verification history, and evidence management for each asset-obligation pair. Each record links one asset to one regulatory obligation with attributes that track compliance verification dates, responsible parties, and audit evidence specific to that asset\'s compliance with that particular obligation.. Existence Justification: In energy utilities operations, individual physical assets (transformers, transmission towers, substations, protection relays) are each subject to multiple regulatory obligations from different governing bodies (NERC CIP cybersecurity standards, EPA emissions limits, OSHA safety mandates, FERC reliability requirements). Simultaneously, each regulatory obligation applies to many assets across the utility\'s asset base based on asset characteristics like voltage class, criticality score, and operational function. Compliance teams actively manage this many-to-many relationship by tracking verification dates, collecting evidence, assigning responsible parties, and preparing for audits on each asset-obligation pair. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AssetCompliance',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.asset_compliance'
);

-- PpaAllocation  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `asset`.`ppa_allocation` (
  `ppa_allocation_id` BIGINT NOT NULL COMMENT 'Unique identifier for this asset-PPA allocation record. Primary key.',
  `registry_id` BIGINT COMMENT 'Foreign key linking to the physical generation asset being allocated to this PPA contract',
  `renewable_ppa_contract_id` BIGINT COMMENT 'Foreign key linking to the renewable PPA contract receiving this asset allocation',
  `settlement_meter_id` BIGINT COMMENT 'Identifier of the revenue-quality meter used to measure generation from this asset for settlement under this PPA contract. Critical for multi-PPA scenarios where different meters or meter channels track output allocated to different contracts.',
  `allocation_notes` STRING COMMENT 'Free-text field capturing business context for this allocation, such as contract amendment references, reallocation justifications, or special settlement terms applicable to this asset-PPA pairing.',
  `allocation_percentage` DECIMAL(5,2) COMMENT 'Percentage of the asset\'s generation capacity or output allocated to this specific PPA contract. Allows partial allocation where a single asset serves multiple contracts or where portfolio PPAs aggregate multiple assets. Sum of allocation percentages across all PPAs for a given asset may equal or be less than 100%.',
  `allocation_status` STRING COMMENT 'Current operational status of this asset-PPA allocation: active (currently generating and settling), pending (approved but not yet effective), suspended (temporarily halted due to maintenance or curtailment), terminated (ended early), expired (reached contract_end_date). Drives settlement processing and REC transfer eligibility.',
  `contract_end_date` DATE COMMENT 'Effective end date when this asset\'s allocation to this PPA contract terminates. May differ from the PPA contract\'s overall effective_end_date if assets are removed from the contract early due to retirement, reallocation, or contract amendment.',
  `contract_start_date` DATE COMMENT 'Effective start date when this specific asset began contributing generation to this PPA contract. May differ from the PPA contract\'s overall effective_start_date if assets are added to the contract over time or if the asset was commissioned after contract inception.',
  `contracted_capacity_mw` DECIMAL(12,3) COMMENT 'Portion of the asset\'s rated capacity (in MW) that is contractually committed to this specific PPA. For portfolio PPAs, this represents the asset\'s contribution to the total contracted capacity. Used for capacity payment calculations and contract compliance tracking.',
  `contracted_price_per_mwh` DECIMAL(12,4) COMMENT 'Energy price in USD per MWh applicable to this specific asset-PPA pairing. May differ from the PPA\'s base_price_per_mwh if the contract has asset-specific pricing tiers, vintage-based pricing, or technology-specific rates. Used for settlement calculations.',
  `rec_allocation_flag` BOOLEAN COMMENT 'Indicates whether Renewable Energy Certificates (RECs) generated by this asset under this allocation are transferred to the utility per the PPA\'s rec_ownership terms. Supports scenarios where energy and RECs are sold separately or where only a portion of an asset\'s RECs are allocated to a specific PPA.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_ppa_allocation` PRIMARY KEY (`ppa_allocation_id`)
)
USING DELTA
COMMENT 'This association product represents the allocation relationship between physical generation assets and renewable power purchase agreement contracts. It captures the contractual assignment of specific assets (or portions thereof) to PPA contracts for renewable attribute tracking, settlement, and RPS compliance. Each record links one asset to one PPA contract with allocation percentage, contracted capacity, pricing terms, and effective dates that exist only in the context of this specific asset-contract pairing.. Existence Justification: In utility-scale renewable energy procurement, portfolio PPAs routinely allocate generation from multiple physical assets (e.g., individual wind turbines, solar array sections, or entire generation facilities) to a single contract to aggregate capacity and meet volume commitments. Conversely, a single asset can participate in multiple PPAs simultaneously through time-slicing (baseload energy sold to one contract, renewable attributes to another), partial capacity allocation, or sequential contract assignments. The allocation relationship itself carries critical operational data including allocation percentage, asset-specific pricing, effective dates, and settlement meter assignments that belong to neither the asset nor the PPA alone. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PpaAllocation',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.ppa_allocation'
);

-- ImpactAssessment  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `asset`.`impact_assessment` (
  `impact_assessment_id` BIGINT NOT NULL COMMENT 'Primary key for the asset_impact_assessment association',
  `analyzed_by_employee_id` BIGINT COMMENT 'Reference to the utility engineer who performed the technical impact analysis for this asset-application combination. Used for accountability, quality assurance, and workload tracking.',
  `cluster_study_group_id` BIGINT COMMENT 'Reference to the cluster study group that includes this asset impact assessment, if applicable. Under FERC Order 2023, multiple interconnection applications that impact the same assets may be grouped into cluster studies for coordinated analysis and cost allocation.',
  `interconnection_application_id` BIGINT COMMENT 'Foreign key linking to the interconnection application being reviewed',
  `registry_id` BIGINT COMMENT 'Foreign key linking to the utility asset being impacted by the interconnection application',
  `affected_capacity_kw` DECIMAL(12,3) COMMENT 'Amount of asset capacity in kilowatts that is affected or consumed by the proposed DER interconnection. Used to determine hosting capacity impacts and whether the asset has sufficient remaining capacity for additional interconnection applications in the queue.',
  `analysis_date` DATE COMMENT 'Date when the technical impact analysis for this asset-application combination was performed by the utility review engineer. Used to track review timeline compliance with regulatory deadlines and to determine whether re-analysis is required if grid conditions change.',
  `analysis_status` STRING COMMENT 'Current status of the impact analysis for this asset-application combination. Tracks progression through the technical review workflow and identifies when supplemental studies are required.',
  `estimated_cost` DECIMAL(18,2) COMMENT 'Estimated cost in USD to upgrade or replace this asset to accommodate the proposed DER interconnection. Used for cost allocation across applications in cluster studies and to determine applicant financial responsibility under interconnection agreements.',
  `impact_severity` STRING COMMENT 'Engineering assessment of the severity of impact the proposed DER has on this asset. Determines review tier escalation, supplemental study requirements, and priority for upgrade planning.',
  `impact_type` STRING COMMENT 'Category of technical impact the proposed DER has on this specific asset (thermal loading, voltage regulation, protection coordination, fault current contribution, stability, power quality). Determines the type of engineering analysis required and potential mitigation measures.',
  `mitigation_required` STRING COMMENT 'Description of mitigation measures required to address the impact on this asset, such as protection relay upgrades, voltage regulator adjustments, transformer replacement, or operational restrictions on DER output.',
  `upgrade_required_flag` BOOLEAN COMMENT 'Indicates whether this asset requires upgrade or replacement to accommodate the proposed DER interconnection. Drives cost allocation and determines whether the application triggers network upgrade costs that may be shared across multiple applications in a cluster study.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_impact_assessment` PRIMARY KEY (`impact_assessment_id`)
)
USING DELTA
COMMENT 'This association product represents the technical impact assessment between a utility asset and an interconnection application. It captures the engineering analysis of how a proposed distributed energy resource (DER) interconnection affects specific grid assets, including thermal loading, voltage regulation, protection coordination, and required upgrades. Each record links one asset to one interconnection application with impact-specific attributes that exist only in the context of this relationship. This is the foundation for cluster study formation, cost allocation, and queue management under FERC Order 2023 and state interconnection rules.. Existence Justification: In utility interconnection operations, a single interconnection application routinely impacts multiple grid assets (transformer, feeder, substation, protection devices) that must be analyzed for thermal, voltage, and protection impacts. Conversely, a single asset can be affected by multiple pending interconnection applications in the queue, requiring coordinated analysis to determine cumulative impacts and shared upgrade costs. Utilities actively manage these asset-application impact assessments as part of the technical review process, tracking impact type, severity, upgrade requirements, and cost allocation for each asset-application combination. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ImpactAssessment',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.impact_assessment'
);

-- DerConnection  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `asset`.`der_connection` (
  `der_connection_id` BIGINT NOT NULL COMMENT 'Unique identifier for this specific connection between a utility asset and a DER system. Primary key for the association.',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to the distributed energy resource system that is physically connected to the utility asset',
  `registry_id` BIGINT COMMENT 'Foreign key linking to the utility asset (transformer, meter, disconnect switch, protection relay) that serves as a connection point for the DER system',
  `commissioning_date` DATE COMMENT 'Date when this specific DER-asset connection was commissioned and placed into operational service. Marks the point when the physical connection was energized and the DER system began operating in coordination with the utility asset.',
  `connection_capacity_kw` DECIMAL(12,3) COMMENT 'Maximum power capacity in kilowatts approved for this specific DER-asset connection point. May be lower than the DER system nameplate capacity if the utility asset has capacity constraints or if multiple DER systems share the same asset.',
  `connection_type` STRING COMMENT 'Classification of the physical connection point type between the DER system and the utility asset. Identifies the specific electrical interface and connection configuration used for the interconnection.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this connection record was created in the system.',
  `disconnect_switch_accessible_flag` BOOLEAN COMMENT 'Indicates whether the utility-accessible disconnect switch for this DER-asset connection is readily accessible to utility crews for maintenance and emergency operations. Critical for outage response and safety procedures.',
  `export_limit_kw` DECIMAL(12,3) COMMENT 'Maximum power export limit in kilowatts allowed for this specific DER-asset connection. May be constrained by asset capacity, feeder capacity, or interconnection agreement terms. Null if no export is permitted.',
  `last_inspection_date` DATE COMMENT 'Date of the most recent physical inspection or testing of this DER-asset connection point. Used for maintenance tracking and compliance verification.',
  `metering_configuration` STRING COMMENT 'Specification of the metering arrangement and measurement configuration for this specific DER-asset connection. Defines how energy flow is measured and recorded for billing, settlement, and grid monitoring purposes.',
  `next_inspection_due_date` DATE COMMENT 'Scheduled date for the next required inspection or testing of this DER-asset connection based on utility maintenance standards and regulatory requirements.',
  `operating_status` STRING COMMENT 'Current operational status of this specific DER-asset connection. Indicates whether the connection is actively energized, temporarily suspended, under maintenance, or permanently decommissioned. Used for outage management and operational coordination.',
  `poi_voltage_level_kv` DECIMAL(10,3) COMMENT 'Nominal voltage level in kilovolts at the specific point where the DER system connects to this utility asset. Critical for protection coordination and equipment specification.',
  `protection_scheme` STRING COMMENT 'Description of the protection coordination scheme and relay settings applied to this specific DER-asset connection. Captures the protective relay configuration, trip settings, and coordination with upstream/downstream protection devices to ensure safe operation and fault isolation.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this connection record was last updated.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_der_connection` PRIMARY KEY (`der_connection_id`)
)
USING DELTA
COMMENT 'This association product represents the physical electrical connection between a utility asset and a distributed energy resource (DER) system. It captures the technical configuration, protection coordination, metering arrangement, and operational status of each connection point. Each record links one asset_registry entry to one der_system with attributes that exist only in the context of this specific interconnection configuration. Essential for distribution operations, protection coordination, outage management, and maintenance planning of DER-integrated grid infrastructure.. Existence Justification: In utility distribution operations, a single DER system (solar PV, battery storage, EV charger) physically connects to multiple utility assets at the point of interconnection - typically a service transformer, revenue meter, utility-accessible disconnect switch, and protection relay. Conversely, a single utility asset such as a distribution transformer or secondary service panel can serve multiple DER systems installed at different customer premises or even multiple DER systems at the same location. Each connection has unique technical attributes including metering configuration, protection coordination settings, connection capacity limits, and operational status that belong to the specific DER-asset pairing, not to either entity alone. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DerConnection',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.der_connection'
);

-- ProjectPermit  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `asset`.`project_permit` (
  `project_permit_id` BIGINT NOT NULL COMMENT 'Unique identifier for this project-permit compliance relationship. Primary key.',
  `capital_project_id` BIGINT COMMENT 'Foreign key linking to the capital project requiring environmental permit compliance',
  `compliance_environmental_permit_id` BIGINT COMMENT 'Foreign key linking to the environmental permit governing this project',
  `compliance_status` STRING COMMENT 'Current compliance status of the capital project with respect to this specific permit and condition. Tracks whether the project meets permit requirements.',
  `environmental_permit_number` STRING COMMENT 'Reference number for environmental permits required for the capital project, issued by EPA or state environmental agencies. [Moved from capital_project: This attribute in capital_project appears to reference a single permit, but in reality capital projects require multiple permits. This attribute should be removed from capital_project as the relationship is properly modeled through the project_permit association, which can link to multiple permits and track permit-specific compliance details.]',
  `mitigation_measure_description` STRING COMMENT 'Description of specific mitigation measures, controls, or corrective actions implemented for this project to comply with this permit condition. May include engineering controls, monitoring protocols, or operational restrictions.',
  `next_inspection_date` DATE COMMENT 'Scheduled date for the next regulatory inspection or compliance verification for this project-permit combination.',
  `notes` STRING COMMENT 'Additional notes, comments, or documentation references related to permit compliance for this specific project.',
  `permit_application_date` DATE COMMENT 'Date when the permit application was submitted for this specific project. Relevant for project-specific permits or permit modifications required for the capital project.',
  `permit_approval_date` DATE COMMENT 'Date when the permit was approved or modified to cover this capital project. Critical for tracking project schedule dependencies on regulatory approvals.',
  `permit_condition_number` STRING COMMENT 'Specific permit condition number or reference that applies to this capital project. Each permit may have multiple conditions, and projects must track compliance with specific applicable conditions.',
  `responsible_party` STRING COMMENT 'Name or identifier of the individual or team responsible for ensuring compliance with this permit condition for this specific project. May be project manager, environmental coordinator, or compliance officer.',
  `verification_date` DATE COMMENT 'Date when compliance with this permit condition was last verified by environmental compliance staff or regulatory inspectors.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_asset_project_permit` PRIMARY KEY (`project_permit_id`)
)
USING DELTA
COMMENT 'This association product represents the regulatory compliance relationship between capital projects and environmental permits. It captures permit-specific compliance tracking, verification activities, and mitigation measures required for each project-permit combination. Each record links one capital project to one environmental permit with attributes that exist only in the context of this regulatory compliance relationship.. Existence Justification: Capital projects in energy utilities require multiple environmental permits (EPA Title V air permits, NPDES water discharge permits, wetlands permits, endangered species authorizations) depending on project scope and location. Each permit applies to multiple projects over its validity period. Environmental compliance officers actively manage project-permit relationships by tracking compliance with specific permit conditions, conducting verification activities, documenting mitigation measures, and coordinating regulatory inspections for each project-permit combination. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ProjectPermit',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.asset.project_permit'
);

-- ========= FOREIGN KEYS within asset (44) =========
ALTER TABLE `asset`.`registry` DROP CONSTRAINT IF EXISTS `fk_asset_registry_class_id`;
ALTER TABLE `asset`.`registry` ADD CONSTRAINT `fk_asset_registry_class_id` FOREIGN KEY (`class_id`) REFERENCES `asset`.`class` (`class_id`);

ALTER TABLE `asset`.`registry` DROP CONSTRAINT IF EXISTS `fk_asset_registry_parent_asset_registry_id`;
ALTER TABLE `asset`.`registry` ADD CONSTRAINT `fk_asset_registry_parent_asset_registry_id` FOREIGN KEY (`parent_asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`hierarchy` DROP CONSTRAINT IF EXISTS `fk_asset_hierarchy_child_asset_asset_registry_id`;
ALTER TABLE `asset`.`hierarchy` ADD CONSTRAINT `fk_asset_hierarchy_child_asset_asset_registry_id` FOREIGN KEY (`child_asset_asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`hierarchy` DROP CONSTRAINT IF EXISTS `fk_asset_hierarchy_hierarchy_registry_id`;
ALTER TABLE `asset`.`hierarchy` ADD CONSTRAINT `fk_asset_hierarchy_hierarchy_registry_id` FOREIGN KEY (`hierarchy_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`work_order` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_asset_registry_id`;
ALTER TABLE `asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_asset_registry_id` FOREIGN KEY (`asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`work_order` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_maintenance_plan_id`;
ALTER TABLE `asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_maintenance_plan_id` FOREIGN KEY (`maintenance_plan_id`) REFERENCES `asset`.`maintenance_plan` (`maintenance_plan_id`);

ALTER TABLE `asset`.`work_order` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_parent_work_order_id`;
ALTER TABLE `asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_parent_work_order_id` FOREIGN KEY (`parent_work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `asset`.`work_order` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_registry_id`;
ALTER TABLE `asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`work_order` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_to_maintenance_plan_id`;
ALTER TABLE `asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_to_maintenance_plan_id` FOREIGN KEY (`to_maintenance_plan_id`) REFERENCES `asset`.`maintenance_plan` (`maintenance_plan_id`);

ALTER TABLE `asset`.`work_order` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_work_maintenance_plan_id`;
ALTER TABLE `asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_work_maintenance_plan_id` FOREIGN KEY (`work_maintenance_plan_id`) REFERENCES `asset`.`maintenance_plan` (`maintenance_plan_id`);

ALTER TABLE `asset`.`maintenance_plan` DROP CONSTRAINT IF EXISTS `fk_asset_maintenance_plan_asset_class_id`;
ALTER TABLE `asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_asset_class_id` FOREIGN KEY (`asset_class_id`) REFERENCES `asset`.`class` (`class_id`);

ALTER TABLE `asset`.`maintenance_plan` DROP CONSTRAINT IF EXISTS `fk_asset_maintenance_plan_asset_registry_id`;
ALTER TABLE `asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_asset_registry_id` FOREIGN KEY (`asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`maintenance_plan` DROP CONSTRAINT IF EXISTS `fk_asset_maintenance_plan_class_id`;
ALTER TABLE `asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_class_id` FOREIGN KEY (`class_id`) REFERENCES `asset`.`class` (`class_id`);

ALTER TABLE `asset`.`maintenance_plan` DROP CONSTRAINT IF EXISTS `fk_asset_maintenance_plan_registry_id`;
ALTER TABLE `asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`failure_event` DROP CONSTRAINT IF EXISTS `fk_asset_failure_event_asset_registry_id`;
ALTER TABLE `asset`.`failure_event` ADD CONSTRAINT `fk_asset_failure_event_asset_registry_id` FOREIGN KEY (`asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`failure_event` DROP CONSTRAINT IF EXISTS `fk_asset_failure_event_failure_work_order_id`;
ALTER TABLE `asset`.`failure_event` ADD CONSTRAINT `fk_asset_failure_event_failure_work_order_id` FOREIGN KEY (`failure_work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `asset`.`failure_event` DROP CONSTRAINT IF EXISTS `fk_asset_failure_event_primary_work_order_id`;
ALTER TABLE `asset`.`failure_event` ADD CONSTRAINT `fk_asset_failure_event_primary_work_order_id` FOREIGN KEY (`primary_work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `asset`.`failure_event` DROP CONSTRAINT IF EXISTS `fk_asset_failure_event_registry_id`;
ALTER TABLE `asset`.`failure_event` ADD CONSTRAINT `fk_asset_failure_event_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`failure_event` DROP CONSTRAINT IF EXISTS `fk_asset_failure_event_to_work_order_id`;
ALTER TABLE `asset`.`failure_event` ADD CONSTRAINT `fk_asset_failure_event_to_work_order_id` FOREIGN KEY (`to_work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `asset`.`capital_project` DROP CONSTRAINT IF EXISTS `fk_asset_capital_project_asset_registry_id`;
ALTER TABLE `asset`.`capital_project` ADD CONSTRAINT `fk_asset_capital_project_asset_registry_id` FOREIGN KEY (`asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`depreciation_schedule` DROP CONSTRAINT IF EXISTS `fk_asset_depreciation_schedule_asset_class_id`;
ALTER TABLE `asset`.`depreciation_schedule` ADD CONSTRAINT `fk_asset_depreciation_schedule_asset_class_id` FOREIGN KEY (`asset_class_id`) REFERENCES `asset`.`class` (`class_id`);

ALTER TABLE `asset`.`depreciation_schedule` DROP CONSTRAINT IF EXISTS `fk_asset_depreciation_schedule_asset_registry_id`;
ALTER TABLE `asset`.`depreciation_schedule` ADD CONSTRAINT `fk_asset_depreciation_schedule_asset_registry_id` FOREIGN KEY (`asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`depreciation_schedule` DROP CONSTRAINT IF EXISTS `fk_asset_depreciation_schedule_class_id`;
ALTER TABLE `asset`.`depreciation_schedule` ADD CONSTRAINT `fk_asset_depreciation_schedule_class_id` FOREIGN KEY (`class_id`) REFERENCES `asset`.`class` (`class_id`);

ALTER TABLE `asset`.`depreciation_schedule` DROP CONSTRAINT IF EXISTS `fk_asset_depreciation_schedule_registry_id`;
ALTER TABLE `asset`.`depreciation_schedule` ADD CONSTRAINT `fk_asset_depreciation_schedule_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`spare_parts_inventory` DROP CONSTRAINT IF EXISTS `fk_asset_spare_parts_inventory_asset_class_id`;
ALTER TABLE `asset`.`spare_parts_inventory` ADD CONSTRAINT `fk_asset_spare_parts_inventory_asset_class_id` FOREIGN KEY (`asset_class_id`) REFERENCES `asset`.`class` (`class_id`);

ALTER TABLE `asset`.`spare_parts_inventory` DROP CONSTRAINT IF EXISTS `fk_asset_spare_parts_inventory_class_id`;
ALTER TABLE `asset`.`spare_parts_inventory` ADD CONSTRAINT `fk_asset_spare_parts_inventory_class_id` FOREIGN KEY (`class_id`) REFERENCES `asset`.`class` (`class_id`);

ALTER TABLE `asset`.`inspection` DROP CONSTRAINT IF EXISTS `fk_asset_inspection_registry_id`;
ALTER TABLE `asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`inspection` DROP CONSTRAINT IF EXISTS `fk_asset_inspection_work_order_id`;
ALTER TABLE `asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `asset`.`valuation` DROP CONSTRAINT IF EXISTS `fk_asset_valuation_registry_id`;
ALTER TABLE `asset`.`valuation` ADD CONSTRAINT `fk_asset_valuation_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`retirement` DROP CONSTRAINT IF EXISTS `fk_asset_retirement_capital_project_id`;
ALTER TABLE `asset`.`retirement` ADD CONSTRAINT `fk_asset_retirement_capital_project_id` FOREIGN KEY (`capital_project_id`) REFERENCES `asset`.`capital_project` (`capital_project_id`);

ALTER TABLE `asset`.`retirement` DROP CONSTRAINT IF EXISTS `fk_asset_retirement_retirement_registry_id`;
ALTER TABLE `asset`.`retirement` ADD CONSTRAINT `fk_asset_retirement_retirement_registry_id` FOREIGN KEY (`retirement_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`retirement` DROP CONSTRAINT IF EXISTS `fk_asset_retirement_retirement_replacement_asset_asset_registry_id`;
ALTER TABLE `asset`.`retirement` ADD CONSTRAINT `fk_asset_retirement_retirement_replacement_asset_asset_registry_id` FOREIGN KEY (`retirement_replacement_asset_asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`retirement` DROP CONSTRAINT IF EXISTS `fk_asset_retirement_work_order_id`;
ALTER TABLE `asset`.`retirement` ADD CONSTRAINT `fk_asset_retirement_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `asset`.`warranty` DROP CONSTRAINT IF EXISTS `fk_asset_warranty_registry_id`;
ALTER TABLE `asset`.`warranty` ADD CONSTRAINT `fk_asset_warranty_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`asset_risk_assessment` DROP CONSTRAINT IF EXISTS `fk_asset_asset_risk_assessment_asset_registry_id`;
ALTER TABLE `asset`.`asset_risk_assessment` ADD CONSTRAINT `fk_asset_asset_risk_assessment_asset_registry_id` FOREIGN KEY (`asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`asset_risk_assessment` DROP CONSTRAINT IF EXISTS `fk_asset_asset_risk_assessment_registry_id`;
ALTER TABLE `asset`.`asset_risk_assessment` ADD CONSTRAINT `fk_asset_asset_risk_assessment_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`work_order_material_issue` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_material_issue_spare_parts_inventory_id`;
ALTER TABLE `asset`.`work_order_material_issue` ADD CONSTRAINT `fk_asset_work_order_material_issue_spare_parts_inventory_id` FOREIGN KEY (`spare_parts_inventory_id`) REFERENCES `asset`.`spare_parts_inventory` (`spare_parts_inventory_id`);

ALTER TABLE `asset`.`work_order_material_issue` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_material_issue_work_order_id`;
ALTER TABLE `asset`.`work_order_material_issue` ADD CONSTRAINT `fk_asset_work_order_material_issue_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `asset`.`asset_program_enrollment` DROP CONSTRAINT IF EXISTS `fk_asset_asset_program_enrollment_registry_id`;
ALTER TABLE `asset`.`asset_program_enrollment` ADD CONSTRAINT `fk_asset_asset_program_enrollment_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`asset_compliance` DROP CONSTRAINT IF EXISTS `fk_asset_asset_compliance_registry_id`;
ALTER TABLE `asset`.`asset_compliance` ADD CONSTRAINT `fk_asset_asset_compliance_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`ppa_allocation` DROP CONSTRAINT IF EXISTS `fk_asset_ppa_allocation_registry_id`;
ALTER TABLE `asset`.`ppa_allocation` ADD CONSTRAINT `fk_asset_ppa_allocation_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`impact_assessment` DROP CONSTRAINT IF EXISTS `fk_asset_impact_assessment_registry_id`;
ALTER TABLE `asset`.`impact_assessment` ADD CONSTRAINT `fk_asset_impact_assessment_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`der_connection` DROP CONSTRAINT IF EXISTS `fk_asset_der_connection_registry_id`;
ALTER TABLE `asset`.`der_connection` ADD CONSTRAINT `fk_asset_der_connection_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `asset`.`project_permit` DROP CONSTRAINT IF EXISTS `fk_asset_project_permit_capital_project_id`;
ALTER TABLE `asset`.`project_permit` ADD CONSTRAINT `fk_asset_project_permit_capital_project_id` FOREIGN KEY (`capital_project_id`) REFERENCES `asset`.`capital_project` (`capital_project_id`);

