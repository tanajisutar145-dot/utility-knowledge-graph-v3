-- Utility CMM-aligned Canonical Data Model (Silver) v1.0.0 | source: Databricks lakehouse-industry-data-models energy_utilities v1 ECM | generated 2026-10-13
-- 06 | Subject area: distribution | 23 tables | CIM packages: IEC61970::Core; IEC61970::Wires; IEC61968::Operations
-- Standards: IEC 61968-13 CDPSM; IEC 61968-3; IEEE 1366; Esri ArcGIS Utility Network; MultiSpeak
-- Contents: tables (with PK + NOT NULL), then intra-subject-area foreign keys.
-- Unity Catalog PK/FK constraints are informational (NOT ENFORCED); NOT NULL is enforced.

USE CATALOG `utility_cmm_silver`;

-- Feeder  <<CIM Feeder : exact>>
CREATE TABLE IF NOT EXISTS `distribution`.`feeder` (
  `feeder_id` BIGINT NOT NULL COMMENT 'Unique identifier for the distribution feeder. Primary key. MASTER_RESOURCE role entity.',
  `backup_feeder_id` BIGINT COMMENT 'Reference to an alternate feeder that can provide backup service to customers on this feeder through normally-open tie switches.',
  `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.program. Business justification: Feeders participate in compliance programs like reliability improvement programs, vegetation management programs, and DER integration programs. Tracking program participation enables program effective',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Feeders are capital assets with ongoing O&M costs allocated to cost centers for FERC functional cost reporting, rate case preparation, and monthly expense variance analysis. Essential for regulatory c',
  `feeder_distribution_substation_id` BIGINT COMMENT 'Reference to the substation from which this feeder emanates. Links the feeder to its source substation bus.',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Feeders are the primary distribution asset for which load forecasts are prepared. Load forecasting zones typically align with feeder service areas. Essential for capacity planning, DER hosting capacit',
  `gis_network_model_id` BIGINT COMMENT 'Reference identifier linking this feeder to its representation in the Esri ArcGIS Utility Network model for geospatial analysis and network tracing.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Feeders are subject to specific reliability obligations under IEEE 1366 standards and state PUC performance requirements (SAIDI/SAIFI/CAIDI targets). Tracking which obligations apply to which feeders',
  `owner_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Feeders require designated engineering owners for reliability analysis, performance monitoring, DER hosting capacity management, and capital planning. Essential for accountability in SAIDI/SAIFI metri',
  `scada_point_id` BIGINT COMMENT 'SCADA system point identifier for real-time telemetry and control of the feeder circuit breaker and monitoring points.',
  `to_distribution_substation_id` BIGINT COMMENT 'FK to distribution.distribution_substation.distribution_substation_id — Every feeder emanates from a substation bus. This is the fundamental parent-child relationship in distribution topology. The feeder description mentions \'associated substation bus\' — this FK is produc',
  `adms_feeder_code` STRING COMMENT 'Feeder identifier as recorded in the GE PowerOn ADMS system, used for real-time monitoring, outage management, and distribution automation.',
  `caidi_ytd_minutes` DECIMAL(10,3) COMMENT 'Year-to-date CAIDI reliability metric for this feeder, representing the average outage duration per customer interruption, expressed in minutes.',
  `circuit_configuration` STRING COMMENT 'Topology configuration of the feeder circuit describing how the feeder is electrically arranged and connected within the distribution system. Valid values: radial|loop|network|spot_network.',
  `conductor_type` STRING COMMENT 'Type and specification of the primary conductor used on the feeder mainline, including material and size designation (e.g., ACSR 336.4 kcmil).',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this feeder record was first created in the system.',
  `criticality_rating` STRING COMMENT 'Business criticality classification of the feeder based on factors such as customer type, load importance, and redundancy availability. Valid values: critical|high|medium|low.',
  `customer_count` INT COMMENT 'Total number of customer premises served by this feeder, used for reliability index calculations and outage impact assessment.',
  `der_hosting_capacity_mw` DECIMAL(10,3) COMMENT 'Maximum amount of distributed energy resources (solar, wind, storage) that can be interconnected to the feeder without violating operational constraints, expressed in megawatts.',
  `feeder_code` STRING COMMENT 'Externally-known unique business identifier for the feeder, typically used in operational systems and field communications. Often follows utility-specific naming conventions combining substation code and circuit number. Pattern: ^[A-Z0-9]{4,20}$.',
  `feeder_name` STRING COMMENT 'Human-readable descriptive name of the feeder, often including geographic or service area references for operational clarity.',
  `feeder_type` STRING COMMENT 'Physical construction type of the feeder circuit indicating whether the conductor infrastructure is overhead, underground, or a combination of both. Valid values: overhead|underground|mixed.',
  `flisr_enabled` BOOLEAN COMMENT 'Indicates whether the feeder is equipped with automated FLISR capabilities for rapid fault isolation and service restoration.',
  `in_service_date` DATE COMMENT 'Date when the feeder was first placed into operational service and began serving customer load.',
  `installed_der_capacity_mw` DECIMAL(10,3) COMMENT 'Current total installed capacity of distributed energy resources connected to the feeder, expressed in megawatts.',
  `last_inspection_date` DATE COMMENT 'Date of the most recent comprehensive inspection or assessment of the feeder infrastructure.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this feeder record was most recently updated in the system.',
  `length_miles` DECIMAL(10,3) COMMENT 'Total physical length of the feeder circuit measured in miles, including all mainline and lateral segments.',
  `next_scheduled_maintenance_date` DATE COMMENT 'Planned date for the next scheduled maintenance activity on the feeder circuit.',
  `nominal_voltage_kv` DECIMAL(10,3) COMMENT 'Nominal operating voltage of the feeder expressed in kilovolts. Typical medium-voltage distribution values include 4.16, 12.47, 13.2, 13.8, 23, 34.5 kV.',
  `operational_status` STRING COMMENT 'Current lifecycle status of the feeder indicating its availability and operational state within the distribution network. Valid values: in_service|out_of_service|under_construction|decommissioned|maintenance|standby.',
  `originates_from_substation` BIGINT COMMENT 'FK to distribution.substation.substation_id — Every distribution feeder emanates from a substation bus. This is the foundational topological relationship — load flow analysis, fault isolation, and FLISR all require knowing which substation source',
  `ownership_type` STRING COMMENT 'Ownership classification indicating whether the feeder is wholly utility-owned, jointly owned with another entity, or owned by a third party. Valid values: utility_owned|joint_owned|third_party.',
  `peak_load_mw` DECIMAL(10,3) COMMENT 'Historical peak load demand observed on the feeder expressed in megawatts, used for capacity planning and load management.',
  `phase_configuration` STRING COMMENT 'Electrical phase configuration of the feeder indicating whether it operates as a three-phase, single-phase, or two-phase circuit. Valid values: three_phase|single_phase|two_phase.',
  `protection_scheme` STRING COMMENT 'Description of the protective relay and circuit breaker coordination scheme applied to the feeder for fault detection, isolation, and system protection.',
  `rated_capacity_mva` DECIMAL(10,3) COMMENT 'Maximum rated capacity of the feeder expressed in megavolt-amperes, representing the thermal and electrical limits of the circuit under normal operating conditions.',
  `regulatory_jurisdiction` STRING COMMENT 'Public Utility Commission or regulatory body with jurisdiction over this feeder for rate-making and service quality standards.',
  `saidi_ytd_minutes` DECIMAL(10,3) COMMENT 'Year-to-date SAIDI reliability metric for this feeder, representing the average outage duration per customer served, expressed in minutes.',
  `saifi_ytd_count` DECIMAL(10,3) COMMENT 'Year-to-date SAIFI reliability metric for this feeder, representing the average number of interruptions per customer served.',
  `service_territory` STRING COMMENT 'Geographic service area or territory designation served by this feeder, used for operational planning and regulatory reporting.',
  `substation_bus_code` STRING COMMENT 'Identifier of the specific bus or breaker position within the substation from which the feeder originates.',
  `volt_var_optimization_enabled` BOOLEAN COMMENT 'Indicates whether the feeder participates in automated volt-VAR optimization for voltage regulation and reactive power management.',
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
  CONSTRAINT `pk_distribution_feeder` PRIMARY KEY (`feeder_id`)
)
USING DELTA
COMMENT 'Master record for medium-voltage distribution feeders emanating from substations. Captures feeder identifier, nominal voltage (kV), rated capacity (MVA), feeder type (overhead/underground/mixed), circuit configuration, protection scheme, associated substation bus, service territory, GIS network model reference, ADMS feeder ID from GE PowerOn, and operational status. SSOT for feeder identity in the distribution network topology. | CMM: CIM Feeder (exact), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'Feeder',
  'cmm.cim.class' = 'Feeder',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.feeder',
  'cmm.gis.location.role' = 'PowerSystemResource.Location'
);

-- DistributionSubstation  <<CIM Substation : exact>>
CREATE TABLE IF NOT EXISTS `distribution`.`distribution_substation` (
  `distribution_substation_id` BIGINT NOT NULL COMMENT 'Unique identifier for the distribution substation. Primary key. MASTER_RESOURCE role entity.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Substations operate within balancing authority control areas for ACE calculation, interchange scheduling, and frequency regulation. Required for NERC CPS1/CPS2 compliance reporting and real-time balan',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Substations are major capital facilities with dedicated cost centers for maintenance, operations, and regulatory cost tracking. Required for annual budget planning, FERC Form 1 functional cost allocat',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Substations are major load aggregation points and primary geographic units for load forecasting. Substation capacity planning and transformer sizing depend on load forecasts prepared at the substation',
  `manager_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Substations require designated managers for operational accountability, safety compliance, maintenance coordination, and regulatory reporting. Standard utility practice assigns a responsible engineer/',
  `nerc_cip_asset_id` BIGINT COMMENT 'Foreign key linking to compliance.nerc_cip_asset. Business justification: Substations are BES facilities requiring NERC CIP-002 through CIP-014 compliance tracking. CIP impact ratings, security perimeters, and cyber asset inventories are mandatory for substations meeting BE',
  `transmission_substation_id` BIGINT COMMENT 'Foreign key linking to transmission.transmission_substation. Business justification: Distribution substations receive power from transmission substations via step-down transformers. This is the fundamental grid topology relationship required for outage coordination, voltage management',
  `address_line1` STRING COMMENT 'Primary street address of the substation facility (organizational contact data, business-confidential).',
  `address_line2` STRING COMMENT 'Secondary address information such as building number, suite, or unit (organizational contact data, business-confidential).',
  `adms_node_reference` STRING COMMENT 'Node identifier in the ADMS (GE PowerOn ADMS) representing this substation in the distribution network model for outage management and FLISR automation.',
  `asset_criticality_score` INT COMMENT 'Numerical score (1-100) representing the criticality of this substation to grid reliability and customer service, used for risk-based asset management.',
  `average_load_mw` DECIMAL(10,2) COMMENT 'Average demand load in megawatts (MW) served by this substation over a defined period (typically annual), used for utilization analysis.',
  `bus_arrangement` STRING COMMENT 'Electrical bus topology: single-bus, double-bus, ring-bus, breaker-and-half, or main-and-transfer. Impacts reliability and switching flexibility. Valid values: single_bus|double_bus|ring_bus|breaker_and_half|main_and_transfer.',
  `city` STRING COMMENT 'City or municipality where the substation is located (organizational contact data, business-confidential).',
  `commissioning_date` DATE COMMENT 'Date when the substation was first placed into commercial operation and energized for customer service.',
  `country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code where the substation is located (e.g., USA, CAN, MEX). Pattern: ^[A-Z]{3}$.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this substation record was first created in the system (audit trail).',
  `data_source_system` STRING COMMENT 'Name of the operational system of record that is the authoritative source for this substation data (e.g., GE PowerOn ADMS, Esri ArcGIS, Ventyx Asset Suite).',
  `decommissioning_date` DATE COMMENT 'Date when the substation was permanently retired from service and de-energized. Null if still in service.',
  `der_interconnection_flag` BOOLEAN COMMENT 'Indicates whether this substation has interconnected DER (solar, wind, battery storage) on its feeders requiring DERMS coordination.',
  `emergency_contact_phone` STRING COMMENT 'Primary emergency contact phone number for this substation facility (organizational contact data, business-confidential).',
  `flisr_enabled_flag` BOOLEAN COMMENT 'Indicates whether this substation is equipped with automated FLISR capability for self-healing grid operations via ADMS.',
  `gis_feature_code` STRING COMMENT 'Unique feature identifier in the Esri ArcGIS Utility Network for geospatial asset location and network topology modeling.',
  `last_major_upgrade_date` DATE COMMENT 'Date of the most recent major capital upgrade or refurbishment (transformer replacement, bus reconfiguration, SCADA modernization).',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this substation record was last modified in the system (audit trail).',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate (WGS84 decimal degrees) of the substation location for GIS mapping and outage analysis.',
  `load_factor_percent` DECIMAL(5,2) COMMENT 'Ratio of average load to peak load expressed as a percentage, indicating how efficiently the substation capacity is utilized.',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate (WGS84 decimal degrees) of the substation location for GIS mapping and outage analysis.',
  `maintenance_zone` STRING COMMENT 'Maintenance planning zone or district responsible for O&M (Operations and Maintenance) activities at this substation.',
  `number_of_feeders` INT COMMENT 'Count of distribution feeders originating from this substation serving downstream customers and load zones.',
  `operational_status` STRING COMMENT 'Current lifecycle state of the substation: in-service (active), out-of-service (offline), under-construction (not yet commissioned), decommissioned (retired), standby (backup), or maintenance (temporary outage). Valid values: in_service|out_of_service|under_construction|decommissioned|standby|maintenance.',
  `ownership_type` STRING COMMENT 'Legal ownership classification: utility-owned (owned by the distribution utility), third-party-owned (IPP or DER owner), joint-venture, leased, or municipal (public entity). Valid values: utility_owned|third_party_owned|joint_venture|leased|municipal.',
  `peak_load_mw` DECIMAL(10,2) COMMENT 'Historical peak demand load in megawatts (MW) recorded at this substation, used for capacity planning and load forecasting.',
  `postal_code` STRING COMMENT 'Postal or ZIP code of the substation location (organizational contact data, business-confidential).',
  `primary_voltage_kv` DECIMAL(8,2) COMMENT 'Incoming high-side voltage level in kilovolts (e.g., 33kV, 11kV) from the transmission or sub-transmission network.',
  `rated_capacity_mva` DECIMAL(10,2) COMMENT 'Total nameplate capacity of the substation transformer bank in megavolt-amperes (MVA). Principal quantitative fact for capacity planning and load balancing.',
  `reliability_index_caidi_minutes` DECIMAL(10,2) COMMENT 'Customer Average Interruption Duration Index in minutes for this substation service area, reported to PUC for reliability compliance.',
  `reliability_index_saidi_minutes` DECIMAL(10,2) COMMENT 'System Average Interruption Duration Index in minutes for this substation service area, reported to PUC for reliability compliance.',
  `reliability_index_saifi_count` DECIMAL(10,2) COMMENT 'System Average Interruption Frequency Index (number of interruptions per customer) for this substation service area, reported to PUC for reliability compliance.',
  `scada_rtu_code` STRING COMMENT 'Identifier of the SCADA Remote Terminal Unit installed at this substation for real-time monitoring and control via OSIsoft PI or equivalent.',
  `secondary_voltage_kv` DECIMAL(8,2) COMMENT 'Outgoing low-side voltage level in kilovolts (e.g., 11kV, 0.4kV) for distribution feeders and customer service.',
  `service_territory` STRING COMMENT 'Name or code of the service territory or franchise area served by this substation, as defined by PUC (Public Utility Commission) boundaries.',
  `state_province` STRING COMMENT 'State, province, or region where the substation is located (organizational contact data, business-confidential).',
  `substation_code` STRING COMMENT 'Externally-known unique business identifier or asset tag for the substation used in operational systems (SCADA, ADMS, GIS).',
  `substation_name` STRING COMMENT 'Human-readable name or designation of the distribution substation (e.g., \'Main Street Substation\', \'Industrial Park Sub\').',
  `substation_type` STRING COMMENT 'Classification of the substation by its primary function: step-down (voltage transformation), switching (circuit reconfiguration), distribution (last-mile delivery hub), or collector (renewable energy aggregation). Valid values: step_down|switching|distribution|collector.',
  `transformer_configuration` STRING COMMENT 'Winding configuration of the transformer bank: delta-wye, wye-wye, delta-delta, wye-delta, open-delta, or scott-t. Determines phase shift and grounding. Valid values: delta_wye|wye_wye|delta_delta|wye_delta|open_delta|scott_t.',
  `volt_var_optimization_enabled_flag` BOOLEAN COMMENT 'Indicates whether this substation participates in volt-VAR optimization (VVO) for voltage regulation and reactive power management.',
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
  CONSTRAINT `pk_distribution_distribution_substation` PRIMARY KEY (`distribution_substation_id`)
)
USING DELTA
COMMENT 'Master record for distribution substations (typically 33kV/11kV or 11kV/LV) that step down transmission voltage for last-mile delivery. Captures substation name, location (GIS coordinates), voltage levels, transformer bank configuration, bus arrangement, SCADA RTU identifiers, ADMS node reference, rated capacity (MVA), commissioning date, ownership type, and operational status. Distinct from transmission substations owned by the transmission domain. SSOT for distribution substation identity and electrical configuration in the distribution network topology. | CMM: CIM Substation (exact), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DistributionSubstation',
  'cmm.cim.class' = 'Substation',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.distribution_substation',
  'cmm.gis.location.role' = 'PowerSystemResource.Location'
);

-- DistributionTransformer  <<CIM PowerTransformer : exact>>
CREATE TABLE IF NOT EXISTS `distribution`.`transformer` (
  `transformer_id` BIGINT NOT NULL COMMENT 'Primary key for transformer',
  `distribution_substation_id` BIGINT COMMENT 'Identifier of the distribution substation that serves the feeder supplying this transformer. Used for network topology analysis and outage root cause investigation.',
  `environmental_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.environmental_permit. Business justification: Distribution transformers containing PCB-contaminated oil require EPA TSCA permits and tracking. The pcb_contaminated_flag attribute signals regulatory applicability; linking to environmental_permit e',
  `feeder_id` BIGINT COMMENT 'FK to distribution.feeder.feeder_id — Distribution transformers are installed on feeders. This relationship is essential for load analysis (aggregating transformer loads to feeder level), outage impact assessment, and capacity planning.',
  `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: Distribution transformers are capitalized assets requiring fixed asset registry tracking for depreciation, FERC account classification, RAB inclusion, and rate base valuation. Core to utility asset ac',
  `inspector_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Distribution transformers require periodic inspection by qualified field personnel per OSHA and utility safety standards. Tracking the inspector enables quality assurance, certification verification,',
  `material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: Transformers are procured physical assets requiring material master linkage for lifecycle cost tracking, warranty management, spare parts planning, and standardization programs. Essential for asset ma',
  `service_territory_id` BIGINT COMMENT 'FK to distribution.service_territory',
  `transformer_feeder_id` BIGINT COMMENT 'Identifier of the distribution feeder circuit that supplies power to this transformer. Used for load analysis, outage impact assessment, and SAIDI/SAIFI/CAIDI reliability index calculations.',
  `transformer_on_feeder` BIGINT COMMENT 'FK to distribution.feeder.feeder_id — Distribution transformers are assigned to feeders. This FK supports transformer loading studies, voltage complaint investigation, and outage impact assessment (how many transformers/customers affected',
  `adms_device_code` STRING COMMENT 'Unique device identifier in the GE PowerOn ADMS for real-time monitoring, FLISR automation, and volt-VAR optimization. Links transformer to SCADA telemetry and control functions.',
  `asset_tag` STRING COMMENT 'Utility-assigned asset identification tag for internal tracking and field identification. Used by field crews and asset management systems.',
  `condition_rating` STRING COMMENT 'Overall physical and operational condition assessment based on inspection findings, test results, and maintenance history. Used for capital planning and replacement prioritization. Valid values: excellent|good|fair|poor|critical.',
  `cooling_class` STRING COMMENT 'Cooling method classification per IEEE standards. ONAN = Oil Natural Air Natural (self-cooled), ONAF = Oil Natural Air Forced (fan-cooled), dry types use air cooling. Affects loading capability and maintenance requirements. Valid values: ONAN|ONAF|OFAF|OFWF|dry_type_AA|dry_type_FA.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this transformer record was first created in the system. Used for data lineage and audit trail.',
  `criticality_rating` STRING COMMENT 'Business criticality classification based on number of customers served, load importance, and redundancy availability. Critical assets receive priority for maintenance and replacement. Valid values: critical|high|medium|low.',
  `customers_served_count` INT COMMENT 'Number of customer accounts receiving service from this transformer. Used for outage impact assessment and SAIDI/SAIFI/CAIDI reliability index calculations for PUC reporting.',
  `gis_feature_code` STRING COMMENT 'Unique identifier linking this transformer to its corresponding feature in the Esri ArcGIS Utility Network. Enables spatial analysis, network tracing, and integration with ADMS.',
  `health_index_score` DECIMAL(5,2) COMMENT 'Calculated asset health score (0-100) based on age, condition, loading, maintenance history, and failure risk factors. Higher scores indicate better health. Used for investment prioritization and risk management.',
  `impedance_percent` DECIMAL(6,3) COMMENT 'Transformer impedance expressed as a percentage of rated voltage. Used for short-circuit calculations, protective device coordination, and fault current analysis.',
  `installation_date` DATE COMMENT 'Date the transformer was installed and placed into service at its current location. Used for warranty tracking, maintenance scheduling, and asset lifecycle management.',
  `installation_type` STRING COMMENT 'Physical installation configuration of the transformer indicating mounting method and accessibility. Overhead units are pole-mounted, padmount units are ground-level enclosures, vault units are below-grade in concrete vaults. Valid values: overhead|padmount|vault|subsurface|platform.',
  `insulation_type` STRING COMMENT 'Dielectric insulation medium used in the transformer. Mineral oil is traditional, ester fluids are environmentally friendly, dry types use air or resin insulation. Impacts fire safety and environmental compliance. Valid values: mineral_oil|silicone_oil|ester_fluid|dry_type|gas_insulated.',
  `kva_rating` DECIMAL(10,2) COMMENT 'Nameplate power capacity rating of the transformer in kilovolt-amperes. Represents the maximum continuous load the transformer can serve under standard operating conditions. Critical for load analysis and transformer loading studies.',
  `last_inspection_date` DATE COMMENT 'Date of the most recent field inspection or condition assessment. Used to track inspection compliance and schedule next inspection per maintenance program.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the transformer location in decimal degrees. Used for GIS mapping, outage analysis, and field crew dispatch via Esri ArcGIS Utility Network.',
  `load_loss_watts` DECIMAL(10,2) COMMENT 'Winding resistance loss in watts at rated load. Used for energy efficiency analysis, loss accounting, and total cost of ownership calculations.',
  `load_tap_changer_equipped` BOOLEAN COMMENT 'Indicates whether the transformer is equipped with a load tap changer for automatic voltage regulation under load. True for LTC-equipped units, false for fixed-tap units.',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the transformer location in decimal degrees. Used for GIS mapping, outage analysis, and field crew dispatch via Esri ArcGIS Utility Network.',
  `manufacture_year` INT COMMENT 'Year the transformer was manufactured. Used for age-based asset management, depreciation calculations, and end-of-life planning.',
  `next_inspection_date` DATE COMMENT 'Scheduled date for the next routine inspection or condition assessment. Driven by maintenance program intervals and regulatory requirements.',
  `no_load_loss_watts` DECIMAL(10,2) COMMENT 'Core loss or excitation loss in watts when the transformer is energized but not loaded. Used for energy efficiency analysis and loss accounting.',
  `oil_volume_gallons` DECIMAL(8,2) COMMENT 'Total volume of insulating oil in gallons for liquid-filled transformers. Used for oil sampling scheduling, spill containment planning, and environmental compliance.',
  `operational_status` STRING COMMENT 'Current operational state of the transformer in the distribution network. In-service units are actively serving load, standby units are energized but not loaded, retired units are permanently removed from service. Valid values: in_service|out_of_service|standby|retired|under_test|failed.',
  `ownership_type` STRING COMMENT 'Legal ownership classification of the transformer asset. Utility-owned assets are maintained by the utility, customer-owned assets are maintained by the customer but may be utility-monitored. Valid values: utility_owned|customer_owned|third_party|joint_ownership.',
  `pcb_contaminated_flag` BOOLEAN COMMENT 'Indicates whether the transformer contains or is contaminated with PCBs above regulatory thresholds. True for PCB-contaminated units requiring special handling per EPA regulations.',
  `phase_configuration` STRING COMMENT 'Number of electrical phases the transformer is designed to handle. Single-phase units serve residential and small commercial loads, three-phase units serve larger commercial and industrial customers. Valid values: single_phase|three_phase.',
  `primary_voltage_kv` DECIMAL(8,3) COMMENT 'Rated primary winding voltage in kilovolts. Typically medium voltage (4.16 kV, 12.47 kV, 13.2 kV, 13.8 kV, 23 kV, 34.5 kV) from the distribution feeder.',
  `replacement_cost_usd` DECIMAL(12,2) COMMENT 'Estimated current replacement cost in US dollars including equipment, installation, and removal. Used for capital planning, insurance valuation, and asset valuation.',
  `scada_monitored_flag` BOOLEAN COMMENT 'Indicates whether the transformer is equipped with SCADA telemetry for real-time monitoring of load, voltage, and status. True for monitored assets, false for non-monitored.',
  `secondary_voltage_v` DECIMAL(8,3) COMMENT 'Rated secondary winding voltage in volts. Typically low voltage for customer service (120V, 240V, 208V, 480V). Used for voltage complaint investigation and service quality analysis.',
  `serial_number` STRING COMMENT 'Manufacturer-assigned serial number uniquely identifying the physical transformer unit. Used for warranty tracking, maintenance history, and asset verification.',
  `tap_position` INT COMMENT 'Current tap position setting for voltage adjustment. Positive values indicate voltage boost, negative values indicate voltage buck. Used for voltage regulation analysis.',
  `transformer_type` STRING COMMENT 'Functional classification of the transformer based on its electrical purpose and configuration within the distribution network. Valid values: distribution|network|step_down|step_up|autotransformer|regulator.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this transformer record was last modified. Used for change tracking and data quality monitoring.',
  `warranty_expiration_date` DATE COMMENT 'Date when the manufacturer warranty coverage expires. Used for warranty claim eligibility and maintenance cost planning.',
  `weight_pounds` DECIMAL(10,2) COMMENT 'Total weight of the transformer in pounds. Used for transportation planning, pole loading calculations, and installation equipment sizing.',
  `winding_configuration` STRING COMMENT 'Electrical connection arrangement of primary and secondary windings. Determines voltage transformation characteristics, grounding requirements, and harmonic performance. Valid values: delta_delta|delta_wye|wye_delta|wye_wye|open_delta|open_wye.',
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
  CONSTRAINT `pk_distribution_transformer` PRIMARY KEY (`transformer_id`)
)
USING DELTA
COMMENT 'Master record for pole-mounted and pad-mounted distribution transformers that step down medium voltage to low voltage for customer service. Captures transformer serial number, kVA rating, primary/secondary voltage, phase configuration (single/three-phase), installation type (overhead/padmount/vault), GIS location, feeder assignment, service territory, manufacturer, installation date, condition rating, and ADMS asset reference. SSOT for distribution transformer identity, electrical ratings, and network placement. Supports load analysis, transformer loading studies, and voltage complaint investigation. | CMM: CIM PowerTransformer (exact), IEC61970::Wires.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DistributionTransformer',
  'cmm.cim.class' = 'PowerTransformer',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61970::Wires',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.transformer',
  'cmm.gis.location.role' = 'PowerSystemResource.Location'
);

-- SectionalizingDevice  <<CIM ProtectedSwitch : close>>
CREATE TABLE IF NOT EXISTS `distribution`.`sectionalizing_device` (
  `sectionalizing_device_id` BIGINT NOT NULL COMMENT 'Unique identifier for the sectionalizing device. Primary key for the sectionalizing device master record.',
  `distribution_substation_id` BIGINT COMMENT 'Identifier of the distribution substation that serves the feeder where this device is installed. Used for hierarchical network topology and outage impact analysis.',
  `feeder_id` BIGINT COMMENT 'FK to distribution.feeder.feeder_id — Sectionalizing devices are installed on specific feeders. This FK is required for FLISR automation, protection coordination, and switching order generation.',
  `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: Reclosers, switches, and circuit breakers are capitalized distribution assets tracked in fixed asset registry for depreciation, FERC reporting, and regulatory asset base valuation. Essential for rate',
  `flisr_zone_id` BIGINT COMMENT 'Identifier of the FLISR automation zone where this device participates. Used by ADMS to execute automated fault isolation and service restoration sequences.',
  `maintainer_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Sectionalizing devices (reclosers, switches, breakers) require assigned maintenance personnel for testing, operation verification, and reliability assurance. Critical for FLISR performance, protection',
  `material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: Switches, reclosers, and circuit breakers are procured equipment requiring material master linkage for spare parts inventory planning, equipment standardization, replacement cost estimation, and emerg',
  `nerc_cip_asset_id` BIGINT COMMENT 'Foreign key linking to compliance.nerc_cip_asset. Business justification: Automated sectionalizing devices with SCADA control in substations are BES Cyber Assets under NERC CIP-005 and CIP-007. Tracking CIP applicability, security controls, and patch management for these de',
  `sectionalizing_feeder_id` BIGINT COMMENT 'Identifier of the distribution feeder circuit where this device is installed. Links device to circuit topology for load flow and reliability analysis.',
  `asset_condition_score` DECIMAL(5,2) COMMENT 'Quantitative assessment of device condition based on inspections, testing, and operational history. Scale typically 0-100 with higher scores indicating better condition.',
  `automation_capability` STRING COMMENT 'Level of automation and remote control capability. FLISR-enabled devices support Fault Location Isolation and Service Restoration automation schemes in ADMS. Valid values: manual|automated|flisr_enabled|scada_controlled|remote_controlled.',
  `capital_cost_usd` DECIMAL(15,2) COMMENT 'Original capital cost of the device in US dollars. Used for asset valuation, depreciation, and rate base calculations.',
  `commissioning_date` DATE COMMENT 'Date when the device was commissioned and placed into active service. May differ from installation date due to testing and acceptance procedures.',
  `communication_protocol` STRING COMMENT 'Communication protocol used for remote monitoring and control. Examples: DNP3, IEC 61850, Modbus, proprietary protocols.',
  `control_mode` STRING COMMENT 'Current control mode setting for automated devices. Determines whether device responds to remote commands or operates autonomously. Valid values: local|remote|automatic|disabled.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this device record was first created in the system. Used for data lineage and audit trail.',
  `criticality_rating` STRING COMMENT 'Business criticality classification based on number of customers served, load importance, and redundancy. Used for prioritizing maintenance and replacement investments. Valid values: critical|high|medium|low.',
  `current_position` STRING COMMENT 'Real-time or last-known position of the switching device. Updated by SCADA telemetry or field crew reports. Valid values: open|closed|unknown.',
  `device_name` STRING COMMENT 'Human-readable name or label for the sectionalizing device. Often includes location reference or circuit designation for field identification.',
  `device_number` STRING COMMENT 'Externally-known unique identifier or asset tag for the sectionalizing device. Used for field operations, work orders, and asset tracking. Typically assigned by utility asset management system.',
  `device_subtype` STRING COMMENT 'Detailed subclassification of the device type. Examples: hydraulic recloser, electronic recloser, expulsion fuse, current-limiting fuse, gang-operated switch.',
  `device_type` STRING COMMENT 'Classification of the sectionalizing device by functional type. Determines protection coordination strategy and operational characteristics. Reference-value candidates: recloser|sectionalizer|fuse|load_break_switch|automated_switch|circuit_breaker|disconnect_switch.',
  `expected_service_life_years` INT COMMENT 'Expected useful service life of the device in years. Used for asset replacement planning and depreciation calculations.',
  `gis_feature_code` STRING COMMENT 'Unique identifier linking this device to its corresponding feature in the GIS utility network model. Enables spatial analysis and network tracing in Esri ArcGIS.',
  `installation_date` DATE COMMENT 'Date when the device was installed in the distribution network. Used for asset age calculation and depreciation.',
  `installation_type` STRING COMMENT 'Physical installation configuration of the device. Determines accessibility, maintenance procedures, and environmental protection requirements. Valid values: overhead|pad_mounted|underground_vault|pole_mounted|ground_mounted.',
  `interrupting_capacity_amps` DECIMAL(10,2) COMMENT 'Maximum fault current the device can safely interrupt in amperes. Critical for protection coordination and system fault analysis.',
  `last_maintenance_date` DATE COMMENT 'Date of the most recent preventive or corrective maintenance activity. Used for maintenance interval tracking and compliance reporting.',
  `last_operation_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent switching operation. Used for operational history tracking and maintenance planning.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this device record was most recently modified. Used for change tracking and data quality monitoring.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the device location in decimal degrees. Used for GIS mapping, outage visualization, and crew dispatch optimization.',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the device location in decimal degrees. Used for GIS mapping, outage visualization, and crew dispatch optimization.',
  `next_maintenance_due_date` DATE COMMENT 'Scheduled date for the next preventive maintenance activity. Calculated based on manufacturer recommendations and utility maintenance standards.',
  `normal_position` STRING COMMENT 'Normal operating position of the switching device under standard network configuration. Used for network restoration and switching order generation. Valid values: open|closed|not_applicable.',
  `notes` STRING COMMENT 'Free-form text field for additional operational notes, special instructions, or historical information about the device.',
  `number_of_operations` INT COMMENT 'Cumulative count of switching operations performed by the device. Used for maintenance scheduling and end-of-life prediction.',
  `operational_status` STRING COMMENT 'Current operational state of the device in the distribution network. Determines whether device is available for protection and switching operations. Valid values: in_service|out_of_service|testing|maintenance|retired|planned.',
  `ownership_type` STRING COMMENT 'Legal ownership classification of the device. Determines maintenance responsibility and cost allocation. Valid values: utility_owned|customer_owned|third_party_owned|joint_owned.',
  `phase_configuration` STRING COMMENT 'Electrical phase configuration of the device. Determines which phases are controlled or protected by this device. Reference-value candidates: three_phase|single_phase_a|single_phase_b|single_phase_c|two_phase_ab|two_phase_bc|two_phase_ac.',
  `pole_code` STRING COMMENT 'Identifier of the utility pole where the device is mounted, if applicable. Used for pole loading analysis and joint-use coordination.',
  `protection_zone` STRING COMMENT 'Protection coordination zone designation. Used for relay coordination studies and fault isolation logic.',
  `rated_continuous_current_amps` DECIMAL(10,2) COMMENT 'Maximum continuous current rating of the device in amperes. Determines load-carrying capacity and thermal limits.',
  `rated_voltage_kv` DECIMAL(10,3) COMMENT 'Maximum system voltage rating of the device in kilovolts. Must match or exceed the nominal voltage of the distribution circuit where installed.',
  `regulatory_asset_flag` BOOLEAN COMMENT 'Indicates whether this device is included in the Regulatory Asset Base (RAB) for rate recovery purposes. Used for regulatory reporting and rate case preparation.',
  `scada_point_reference` STRING COMMENT 'Reference identifier linking this device to its SCADA point in the Energy Management System or Distribution Management System. Used for real-time monitoring and remote control.',
  `serial_number` STRING COMMENT 'Unique serial number assigned by manufacturer. Used for warranty claims, recall tracking, and individual device history.',
  `warranty_expiration_date` DATE COMMENT 'Date when manufacturer warranty coverage expires. Used for warranty claim eligibility and replacement cost planning.',
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
  CONSTRAINT `pk_distribution_sectionalizing_device` PRIMARY KEY (`sectionalizing_device_id`)
)
USING DELTA
COMMENT 'Master record for distribution network sectionalizing and protection devices including reclosers, sectionalizers, fuses, load break switches, and automated switches. Captures device type, manufacturer, model, rated voltage and current, interrupting capacity, automation capability (manual/automated/FLISR-enabled), GIS location, feeder segment assignment, SCADA point reference, communication protocol, and operational status. SSOT for all switchable and protective devices on the distribution network. Critical for FLISR automation, fault isolation, and protection coordination in GE PowerOn ADMS. | CMM: CIM ProtectedSwitch (close), IEC61970::Wires.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SectionalizingDevice',
  'cmm.cim.class' = 'ProtectedSwitch',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Wires',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.sectionalizing_device',
  'cmm.gis.location.role' = 'PowerSystemResource.Location'
);

-- ServiceDrop  <<CIM ACLineSegment : close>>
CREATE TABLE IF NOT EXISTS `distribution`.`service_drop` (
  `service_drop_id` BIGINT NOT NULL COMMENT 'Unique identifier for the service drop connection. Primary key for the service drop master record.',
  `conductor_material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: Service drops use standardized conductor materials requiring material master linkage for new service installation planning, emergency restoration inventory, and conductor standardization programs. Rol',
  `customer_service_agreement_id` BIGINT COMMENT 'Reference to the active customer service agreement governing this service drop connection.',
  `from_transformer_id` BIGINT COMMENT 'FK to distribution.transformer.transformer_id — Service drops connect to distribution transformers. This FK is essential for outage impact assessment (transformer outage → which service drops/customers affected) and voltage complaint investigation.',
  `installer_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Service drops track the installing technician for quality assurance, warranty claims, safety compliance verification, and accountability. Standard field practice for new construction, service upgrades',
  `meter_point_id` BIGINT COMMENT 'Reference to the metering point where this service drop terminates at the customer premise.',
  `network_segment_id` BIGINT COMMENT 'Reference to the secondary distribution network segment from which this service drop is fed.',
  `premise_id` BIGINT COMMENT 'Reference to the customer premise served by this service drop.',
  `service_territory_id` BIGINT COMMENT 'FK to distribution.service_territory',
  `service_transformer_id` BIGINT COMMENT 'Reference to the distribution transformer from which this service drop originates. Null for services fed directly from secondary mains.',
  `transformer_id` BIGINT COMMENT 'FK to distribution.transformer.transformer_id — Service drops connect to distribution transformers. This link is critical for tracing customer service back to the network — used in outage impact assessment, voltage complaint investigation, and tran',
  `asset_condition_code` STRING COMMENT 'Current physical condition assessment of the service drop infrastructure based on most recent inspection. Valid values: excellent|good|fair|poor|critical.',
  `attachment_height_ft` DECIMAL(6,2) COMMENT 'Height above ground level in feet where the service drop is attached to the utility pole or structure. Critical for safety clearance compliance.',
  `conductor_length_ft` DECIMAL(10,2) COMMENT 'Physical length of the service drop conductor from the distribution network attachment point to the customer meter point, measured in feet.',
  `conductor_size_awg` STRING COMMENT 'American Wire Gauge size of the service drop conductor. Examples: #2, #4, 4/0, 2/0. Determines current-carrying capacity. Pattern: ^(#[0-9]{1,3}|[0-9]{1,3}/[0-9]{1,3})$.',
  `connection_status` STRING COMMENT 'Current operational status of the service drop connection. Indicates whether the service is energized and delivering power. Valid values: active|inactive|disconnected|pending_connection|temporary|abandoned.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this service drop record was first created in the system.',
  `der_interconnection_flag` BOOLEAN COMMENT 'Indicates whether this service drop has an approved Distributed Energy Resource (solar, wind, battery) interconnection. True if DER is present, False otherwise.',
  `disconnection_date` DATE COMMENT 'Date when the service drop was disconnected or de-energized. Null if currently active.',
  `disconnection_reason` STRING COMMENT 'Reason code for service drop disconnection. Null if service is active. Valid values: non_payment|customer_request|safety_hazard|permanent_disconnect|temporary_disconnect|meter_change.',
  `estimated_remaining_life_years` INT COMMENT 'Estimated remaining useful life of the service drop in years based on condition assessment and typical asset lifecycle.',
  `gis_feature_code` STRING COMMENT 'Unique identifier for the service drop feature in the utility Geographic Information System for spatial analysis and mapping. Pattern: ^[A-Z0-9-]{10,36}$.',
  `grounding_type` STRING COMMENT 'Type of grounding electrode system used at the service entrance for electrical safety. Valid values: rod|plate|water_pipe|building_steel|ufer|none.',
  `installation_date` DATE COMMENT 'Date when the service drop was originally installed and commissioned for service.',
  `installation_type` STRING COMMENT 'Physical installation method of the service drop connection. Valid values: overhead|underground|aerial_to_underground|riser.',
  `last_inspection_date` DATE COMMENT 'Date of the most recent physical inspection of the service drop for safety and condition assessment.',
  `last_maintenance_date` DATE COMMENT 'Date of the most recent maintenance activity performed on the service drop.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the service drop connection point at the customer premise in decimal degrees.',
  `load_management_device_flag` BOOLEAN COMMENT 'Indicates whether a demand response or load management device is installed on this service drop. True if device present, False otherwise.',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the service drop connection point at the customer premise in decimal degrees.',
  `net_metering_eligible_flag` BOOLEAN COMMENT 'Indicates whether this service drop is eligible for net energy metering programs. True if eligible, False otherwise.',
  `neutral_conductor_flag` BOOLEAN COMMENT 'Indicates whether the service drop includes a dedicated neutral conductor. True if neutral is present, False if neutral is shared or absent.',
  `next_inspection_due_date` DATE COMMENT 'Scheduled date for the next required inspection of the service drop based on regulatory and utility maintenance standards.',
  `ownership_type` STRING COMMENT 'Ownership classification of the service drop infrastructure. Determines maintenance responsibility and asset accounting. Valid values: utility_owned|customer_owned|shared|third_party.',
  `phase_configuration` STRING COMMENT 'Electrical phase configuration of the service drop connection. Valid values: single_phase|three_phase_wye|three_phase_delta|split_phase.',
  `pole_code` BIGINT COMMENT 'Reference to the utility pole where the service drop attachment point is located.',
  `replacement_cost_usd` DECIMAL(12,2) COMMENT 'Estimated cost in US dollars to replace the service drop with equivalent new infrastructure. Used for capital planning and asset valuation.',
  `service_amperage_rating` INT COMMENT 'Maximum continuous current rating of the service drop in amperes. Typical residential values: 100A, 200A, 400A.',
  `service_class` STRING COMMENT 'Classification of the service drop based on customer type and usage pattern. Determines service standards and restoration priority. Valid values: residential|commercial|industrial|agricultural|street_lighting|temporary.',
  `service_drop_number` STRING COMMENT 'Business identifier for the service drop connection, typically assigned by the utility for external reference and field operations. Pattern: ^SD-[A-Z0-9]{8,12}$.',
  `service_entrance_type` STRING COMMENT 'Type of service entrance equipment at the customer premise where the service drop terminates. Valid values: mast|conduit|weatherhead|meter_socket|panel_direct.',
  `service_priority_code` STRING COMMENT 'Restoration priority classification for outage management. Critical services (hospitals, emergency facilities) receive highest priority during restoration. Valid values: critical|high|standard|low.',
  `service_voltage_nominal_v` INT COMMENT 'Nominal service voltage in volts delivered at the customer meter point. Typical values: 120, 240, 208, 277, 480.',
  `service_voltage_type` STRING COMMENT 'Voltage configuration delivered to the customer premise. Defines the electrical service characteristics. Valid values: single_phase_120_240|three_phase_120_208|three_phase_277_480|single_phase_120|single_phase_240.',
  `smart_meter_compatible_flag` BOOLEAN COMMENT 'Indicates whether the service drop infrastructure supports Advanced Metering Infrastructure (AMI) smart meter installation. True if compatible, False otherwise.',
  `to_transformer` BIGINT COMMENT 'FK to distribution.distribution_transformer.distribution_transformer_id — Service drops connect to distribution transformers (or secondary network). The description mentions \'pole or transformer association\'. This FK is critical for customer-to-network tracing and outage im',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this service drop record was last modified in the system.',
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
  CONSTRAINT `pk_distribution_service_drop` PRIMARY KEY (`service_drop_id`)
)
USING DELTA
COMMENT 'Master record for the last-mile service connection from the distribution secondary network to a customer premises. Captures service drop identifier, conductor type and size, service voltage (120/240V single-phase or 120/208V three-phase), meter point reference, pole or transformer association, GIS coordinates, installation date, service class (residential/commercial/industrial), and connection status. SSOT for the physical last-mile connection linking the distribution network to the customer metering point. Essential for outage impact assessment and service restoration prioritization. | CMM: CIM ACLineSegment (close), IEC61970::Wires.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ServiceDrop',
  'cmm.cim.class' = 'ACLineSegment',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Wires',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.service_drop',
  'cmm.gis.location.role' = 'PowerSystemResource.Location'
);

-- NetworkSegment  <<CIM EquipmentContainer : broad>>
CREATE TABLE IF NOT EXISTS `distribution`.`network_segment` (
  `network_segment_id` BIGINT NOT NULL COMMENT 'Unique identifier for the distribution network segment. Primary key representing a topologically distinct section between two sectionalizing points.',
  `conductor_material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: Network segments (overhead/underground conductors) are material assets requiring material master linkage for replacement planning, emergency stock management, and conductor standardization. Critical f',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Network segments (conductor runs) have associated O&M costs for maintenance, vegetation management, and reliability improvements tracked by cost center. Required for feeder-level cost allocation in ra',
  `distribution_substation_id` BIGINT COMMENT 'Reference to the distribution substation that serves as the electrical source for this segment. Used for tracing power flow and outage impact analysis.',
  `feeder_id` BIGINT COMMENT 'FK to distribution.feeder.feeder_id — Every network segment belongs to a feeder. The segment description mentions \'feeder association\'. Critical for fault location and load flow analysis.',
  `load_zone_id` BIGINT COMMENT 'Foreign key linking to distribution.load_zone. Business justification: Network segments belong to load zones for load balancing and voltage regulation purposes. Currently network_segment has load_zone_code as STRING, but this should be a proper FK to load_zone.load_zone_',
  `maintenance_crew_id` BIGINT COMMENT 'Foreign key linking to workforce.crew. Business justification: Network segments are assigned to specific crews for routine maintenance, vegetation management, and emergency response. Essential for territory management, crew dispatch optimization, storm restoratio',
  `network_feeder_id` BIGINT COMMENT 'Reference to the parent distribution feeder that this segment belongs to. Links segment to the primary circuit originating from a substation.',
  `network_segment_belongs_to_feeder` BIGINT COMMENT 'FK to distribution.feeder.feeder_id — Network segments are sections of a feeder between sectionalizing points. Feeder assignment is required for load flow analysis, fault location, and FLISR switching logic. Without this FK, segments are',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Network segments have specific vegetation management obligations (NERC FAC-003), inspection frequency requirements, and maintenance standards. Tracking which obligations apply to which segments enable',
  `sectionalizing_device_id` BIGINT COMMENT 'FK to distribution.sectionalizing_device.sectionalizing_device_id — Each network segment is bounded by upstream and downstream sectionalizing devices. This FK defines the topological connectivity that FLISR uses to determine isolation boundaries. Critical for automate',
  `average_load_kw` DECIMAL(12,2) COMMENT 'Typical average load carried by this segment under normal operating conditions. Used for load flow analysis and loss calculations.',
  `condition_score` DECIMAL(5,2) COMMENT 'Numerical assessment of the physical condition of the segment on a standardized scale (typically 0-100). Based on inspection findings, age, failure history, and predictive analytics. Used for prioritizing capital investments.',
  `conductor_size_awg` STRING COMMENT 'Cross-sectional size of the conductor expressed in AWG or kcmil (thousand circular mils). Determines current-carrying capacity and voltage drop characteristics. Common sizes: 4/0, 336.4 kcmil, 477 kcmil.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this network segment record was first created in the system. Used for data lineage and audit trail purposes.',
  `criticality_rating` STRING COMMENT 'Business criticality classification based on customer count, load served, presence of critical facilities (hospitals, emergency services), and redundancy availability. Critical segments receive priority during restoration and maintenance planning. Valid values: critical|high|medium|low.',
  `customer_count` INT COMMENT 'Number of customer premises served by this network segment. Used for outage impact assessment and SAIDI/SAIFI/CAIDI reliability index calculations for PUC reporting.',
  `data_source_system` STRING COMMENT 'Name of the operational system that is the authoritative source for this segment record (e.g., GE PowerOn ADMS, Esri ArcGIS Utility Network). Used for data lineage and integration troubleshooting.',
  `downstream_device_id` BIGINT COMMENT 'Reference to the downstream boundary sectionalizing device that defines the end of this network segment. Used in automated switching sequences during fault restoration.',
  `emergency_ampacity_amps` DECIMAL(10,2) COMMENT 'Short-term current-carrying capacity allowed during emergency conditions or contingency operations. Typically 120-150% of rated ampacity for limited duration.',
  `flisr_enabled_flag` BOOLEAN COMMENT 'Indicates whether this segment is included in automated FLISR switching logic. FLISR-enabled segments can be automatically isolated and restored during fault conditions to minimize outage duration and customer impact.',
  `gis_polyline_reference` STRING COMMENT 'Reference identifier to the corresponding polyline feature in the GIS system (Esri ArcGIS Utility Network). Links operational data to geographic representation for mapping and spatial analysis.',
  `hosting_capacity_kw` DECIMAL(12,2) COMMENT 'Maximum amount of distributed generation (solar, wind, storage) that can be interconnected to this segment without causing voltage, thermal, or protection violations. Critical for DER interconnection studies and renewable integration planning.',
  `installation_date` DATE COMMENT 'Date when the network segment was originally installed and energized. Used for asset age analysis and replacement planning.',
  `last_inspection_date` DATE COMMENT 'Date of the most recent physical inspection of the segment. Used for compliance with maintenance schedules and condition assessment programs.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this network segment record. Tracks data currency and change history for operational and compliance purposes.',
  `modified_by_user` STRING COMMENT 'Identifier of the user or system process that last modified this record. Supports audit trail and data governance requirements.',
  `neutral_configuration` STRING COMMENT 'Method of neutral conductor grounding. Multi-grounded neutrals are grounded at multiple points for safety, unigrounded at one point, ungrounded systems have no neutral ground, impedance-grounded use resistors or reactors. Valid values: multi_grounded|unigrounded|ungrounded|impedance_grounded.',
  `next_inspection_due_date` DATE COMMENT 'Scheduled date for the next required inspection based on regulatory requirements and utility maintenance policies.',
  `nominal_voltage_kv` DECIMAL(8,3) COMMENT 'Design voltage level of the distribution segment in kilovolts. Common distribution voltages: 4.16 kV, 12.47 kV, 13.2 kV, 13.8 kV, 23 kV, 34.5 kV.',
  `operational_status` STRING COMMENT 'Current operational state of the network segment in the distribution grid. Determines whether the segment is actively carrying load, isolated for maintenance, or permanently retired. Valid values: in_service|out_of_service|under_construction|decommissioned|temporarily_isolated|maintenance.',
  `ownership_type` STRING COMMENT 'Legal ownership classification of the segment. Most distribution segments are utility-owned, but some may be customer-owned (behind-the-meter), jointly owned with municipalities, or owned by third parties. Valid values: utility_owned|customer_owned|joint_ownership|third_party.',
  `peak_load_kw` DECIMAL(12,2) COMMENT 'Historical maximum load observed on this segment in kilowatts. Used for capacity planning, load balancing, and identifying overloaded segments requiring reinforcement.',
  `phase_configuration` STRING COMMENT 'Electrical phase arrangement of the segment. Three-phase segments serve large loads and industrial customers, two-phase serve medium loads, single-phase serve residential areas. Phase rotation (ABC vs ACB) affects motor operation. Reference-value candidates: three_phase_abc|three_phase_acb|two_phase_ab|two_phase_bc|two_phase_ac|single_phase_a|single_phase_b|single_phase_c.',
  `positive_sequence_reactance_ohms_per_km` DECIMAL(12,6) COMMENT 'Positive sequence inductive reactance of the conductor per unit length. Critical for power flow modeling and voltage regulation analysis.',
  `positive_sequence_resistance_ohms_per_km` DECIMAL(12,6) COMMENT 'Positive sequence resistance of the conductor per unit length. Used in load flow analysis, voltage drop calculations, and short circuit studies in GE PowerOn ADMS.',
  `rated_ampacity_amps` DECIMAL(10,2) COMMENT 'Maximum continuous current-carrying capacity of the conductor in amperes under normal operating conditions. Determined by conductor size, material, installation method, and ambient temperature.',
  `record_effective_date` DATE COMMENT 'Date from which this version of the segment record is effective. Supports temporal data management and historical analysis of network topology changes.',
  `record_expiration_date` DATE COMMENT 'Date when this version of the segment record expires and is superseded by a new version. Null for current active records. Enables tracking of network topology evolution over time.',
  `regulatory_jurisdiction` STRING COMMENT 'State or provincial Public Utility Commission (PUC) that has regulatory authority over this segment. Determines applicable reliability standards, reporting requirements, and rate recovery mechanisms.',
  `scada_monitored_flag` BOOLEAN COMMENT 'Indicates whether this segment has real-time SCADA telemetry for current, voltage, and power flow monitoring. SCADA-monitored segments provide operational visibility for grid operators.',
  `segment_code` STRING COMMENT 'Externally-known business identifier for the network segment used in operational systems and field communications. Typically derived from GIS naming conventions. Pattern: ^[A-Z0-9]{6,20}$.',
  `segment_length_km` DECIMAL(10,3) COMMENT 'Physical length of the network segment measured in kilometers. Used for impedance calculations, voltage drop analysis, and hosting capacity studies.',
  `segment_name` STRING COMMENT 'Human-readable descriptive name for the network segment, often including geographic or operational context (e.g., \'Main St Feeder 12A Section 3\').',
  `segment_type` STRING COMMENT 'Classification of the segment based on its role in the distribution network hierarchy. Primary feeders carry bulk power from substations, laterals branch from primaries, sub-laterals branch from laterals, service backbones serve multiple service drops, express feeders bypass load areas, and tie lines connect feeders. Valid values: primary_feeder|lateral|sub_lateral|service_backbone|express_feeder|tie_line.',
  `service_territory_code` STRING COMMENT 'Geographic service territory classification for regulatory and operational reporting. Segments are grouped by franchise area or service district.',
  `upstream_device_id` BIGINT COMMENT 'Reference to the upstream boundary sectionalizing device (recloser, breaker, switch) that defines the beginning of this network segment. Critical for FLISR automation and fault isolation logic.',
  `volt_var_optimization_zone` STRING COMMENT 'Identifier for the voltage optimization zone this segment belongs to. VVO zones are coordinated groups of segments and voltage control devices managed together to reduce losses and maintain voltage within acceptable limits.',
  `zero_sequence_reactance_ohms_per_km` DECIMAL(12,6) COMMENT 'Zero sequence inductive reactance per unit length. Essential for fault current calculations and protection system design.',
  `zero_sequence_resistance_ohms_per_km` DECIMAL(12,6) COMMENT 'Zero sequence resistance per unit length. Used in ground fault analysis and protective relay coordination studies.',
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
  CONSTRAINT `pk_distribution_network_segment` PRIMARY KEY (`network_segment_id`)
)
USING DELTA
COMMENT 'Master record representing a topologically distinct section of the distribution network between two sectionalizing points. Captures segment identifier, upstream and downstream boundary devices, conductor type and size, length (km), rated ampacity, nominal voltage, phase configuration, feeder association, GIS polyline reference, and load zone classification. SSOT for distribution network topology between switching points. Used for load flow analysis, fault location, FLISR switching logic, and hosting capacity analysis in GE PowerOn ADMS. | CMM: CIM EquipmentContainer (broad), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'NetworkSegment',
  'cmm.cim.class' = 'EquipmentContainer',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.network_segment',
  'cmm.gis.location.role' = 'PowerSystemResource.Location'
);

-- LoadZone  <<CIM SubLoadArea : close>>
CREATE TABLE IF NOT EXISTS `distribution`.`load_zone` (
  `load_zone_id` BIGINT NOT NULL COMMENT 'Unique identifier for the distribution load zone. Primary key. This is the SSOT identifier used across GE PowerOn ADMS and Esri ArcGIS Utility Network for zone-level control and planning.',
  `distribution_substation_id` BIGINT COMMENT 'Foreign key reference to the parent substation that supplies this load zone. Links the zone to its source substation in the transmission-distribution interface.',
  `feeder_id` BIGINT COMMENT 'FK to distribution.feeder.feeder_id — Load zones are logical groupings that include one or more feeders. This many-to-many relationship (or zone FK on feeder) is needed for VVO dispatch, demand forecasting, and capacity planning at the zo',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Distribution load zones are operational constructs that directly map to forecast zones for planning. Essential for integrated distribution planning, voltage optimization planning, and capacity studies',
  `load_feeder_id` BIGINT COMMENT 'FK to distribution.feeder.feeder_id — Load zones are associated with feeders. The description mentions \'associated feeders\'. This is a many-to-many but the primary association is critical for load balancing operations.',
  `load_zone_includes_feeder` BIGINT COMMENT 'FK to distribution.feeder.feeder_id — Load zones are logical groupings that include one or more feeders. This FK supports VVO dispatch zone definition and capacity planning by zone.',
  `planning_engineer_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Load zones require planning engineers for capacity analysis, load forecasting, DER hosting capacity studies, and capital investment planning. Essential for distribution planning processes, capacity st',
  `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Load zones represent service territories or planning areas that align with profit center structures for revenue and cost tracking by geographic/functional area. Essential for territorial profitability',
  `capacity_mva` DECIMAL(12,3) COMMENT 'Total installed capacity of the load zone in megavolt-amperes, representing the maximum apparent power the zone infrastructure can support. Used for capacity planning and load transfer studies.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this load zone record was first created in the system. Used for audit trail and data lineage tracking.',
  `customer_count` INT COMMENT 'Total number of customer premises served by this load zone. Used for reliability index calculations (SAIDI, SAIFI, CAIDI) and outage impact assessment.',
  `der_penetration_mw` DECIMAL(12,3) COMMENT 'Total installed capacity of distributed energy resources (solar PV, wind, storage, etc.) within the load zone, measured in megawatts. Used for DER hosting capacity analysis and grid integration planning.',
  `dms_zone_classification` STRING COMMENT 'Classification of the zone within the DMS/ADMS for automation capabilities. VVO-enabled zones support Volt-VAR Optimization, FLISR-enabled zones support Fault Location Isolation and Service Restoration, manual zones require operator intervention, hybrid zones have partial automation, and advanced zones support full ADMS integration. Valid values: vvo_enabled|flisr_enabled|manual|hybrid|advanced.',
  `effective_date` DATE COMMENT 'Date when the load zone configuration became or will become effective. Used for tracking zone boundary changes, capacity upgrades, and operational transitions.',
  `expiration_date` DATE COMMENT 'Date when the load zone configuration expires or is scheduled for decommissioning. Null for active zones with no planned end date.',
  `feeder_count` INT COMMENT 'Number of distribution feeders associated with this load zone. Used for network topology analysis and load balancing.',
  `flisr_enabled_flag` BOOLEAN COMMENT 'Indicates whether FLISR automation is enabled for this load zone. True means automated fault detection, isolation, and restoration; false means manual switching operations.',
  `geographic_boundary_wkt` STRING COMMENT 'Geographic boundary of the load zone represented as a WKT (Well-Known Text) polygon. Used for spatial analysis, outage mapping, and GIS integration with Esri ArcGIS Utility Network.',
  `hosting_capacity_mw` DECIMAL(12,3) COMMENT 'Maximum amount of additional DER capacity the zone can accommodate without infrastructure upgrades or operational issues, measured in megawatts. Used for interconnection screening and DER integration planning.',
  `last_capacity_study_date` DATE COMMENT 'Date of the most recent distribution capacity study performed for this load zone. Used to track planning cycle compliance and identify zones requiring updated analysis.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this load zone record was last updated. Used for audit trail, change tracking, and data synchronization across systems.',
  `load_profile_type` STRING COMMENT 'Dominant customer class or load profile characteristic of the zone. Residential zones peak in evening, commercial zones peak mid-day, industrial zones have steady load, mixed zones have diverse profiles, and agricultural zones have seasonal patterns. Valid values: residential|commercial|industrial|mixed|agricultural.',
  `next_capacity_study_date` DATE COMMENT 'Scheduled date for the next distribution capacity study for this load zone. Used for planning resource allocation and ensuring regulatory compliance with capacity planning cycles.',
  `nominal_load_mvar` DECIMAL(12,3) COMMENT 'Typical or average reactive power load of the zone under normal operating conditions, measured in megavolt-amperes reactive. Used for Volt-VAR optimization and power factor management.',
  `nominal_load_mw` DECIMAL(12,3) COMMENT 'Typical or average real power load of the zone under normal operating conditions, measured in megawatts. Used for load balancing and capacity planning.',
  `nominal_voltage_kv` DECIMAL(10,3) COMMENT 'Nominal operating voltage of the load zone in kilovolts. Typical distribution voltages range from 4.16 kV to 34.5 kV.',
  `notes` STRING COMMENT 'Free-text field for operational notes, special considerations, or additional context about the load zone. May include information about unique load characteristics, planned projects, or operational constraints.',
  `peak_demand_mw` DECIMAL(12,3) COMMENT 'Historical or forecasted peak real power demand for the zone, measured in megawatts. Critical for capacity planning and infrastructure investment decisions.',
  `peak_demand_timestamp` TIMESTAMP COMMENT 'Date and time when the peak demand was recorded or is forecasted to occur. Used for load profile analysis and demand response planning.',
  `planning_area_code` BIGINT COMMENT 'Foreign key reference to the broader distribution planning area or service territory that contains this load zone. Used for regional capacity planning and resource allocation.',
  `power_factor_target` DECIMAL(5,4) COMMENT 'Target power factor for the load zone, typically between 0.95 and 1.00. Used for Volt-VAR optimization dispatch and capacitor bank control to minimize reactive power losses.',
  `reliability_caidi_minutes` DECIMAL(10,2) COMMENT 'Customer Average Interruption Duration Index for the load zone, measured in minutes per interruption. Calculated as SAIDI/SAIFI. Indicates average restoration time. Key reliability metric reported to PUC.',
  `reliability_saidi_minutes` DECIMAL(10,2) COMMENT 'System Average Interruption Duration Index for the load zone, measured in minutes per customer per year. Key reliability metric reported to PUC. Lower values indicate better reliability.',
  `reliability_saifi_count` DECIMAL(10,2) COMMENT 'System Average Interruption Frequency Index for the load zone, measured as number of interruptions per customer per year. Key reliability metric reported to PUC. Lower values indicate better reliability.',
  `scada_integration_status` STRING COMMENT 'Level of SCADA system integration for real-time monitoring and control of the load zone. Fully integrated zones have complete telemetry and control, partially integrated zones have limited coverage, not integrated zones rely on manual operations, and planned zones are scheduled for integration. Valid values: fully_integrated|partially_integrated|not_integrated|planned.',
  `utilization_factor` DECIMAL(5,4) COMMENT 'Ratio of peak demand to installed capacity, indicating how heavily the zone infrastructure is utilized. Values approaching 1.0 indicate need for capacity expansion.',
  `voltage_regulation_target_max_pu` DECIMAL(6,4) COMMENT 'Maximum acceptable voltage level for the zone expressed in per-unit (pu) of nominal voltage. Typically 1.05 pu per ANSI C84.1 Range A. Used by VVO algorithms to maintain voltage within acceptable limits.',
  `voltage_regulation_target_min_pu` DECIMAL(6,4) COMMENT 'Minimum acceptable voltage level for the zone expressed in per-unit (pu) of nominal voltage. Typically 0.95 pu per ANSI C84.1 Range A. Used by VVO algorithms to maintain voltage within acceptable limits.',
  `vvo_enabled_flag` BOOLEAN COMMENT 'Indicates whether Volt-VAR Optimization is enabled for this load zone. True means VVO algorithms actively control voltage and reactive power devices; false means manual or legacy control.',
  `zone_code` STRING COMMENT 'Business identifier for the load zone, typically a human-readable alphanumeric code used in operational systems and dispatch communications. Externally known identifier for the zone. Pattern: ^[A-Z0-9]{4,12}$.',
  `zone_name` STRING COMMENT 'Descriptive name of the load zone, often reflecting geographic area or substation association (e.g., \'Downtown West Zone\', \'Substation 5 North\').',
  `zone_status` STRING COMMENT 'Current operational status of the load zone. Active zones are in service, inactive zones are temporarily out of service, planned zones are under construction, decommissioned zones are retired, and maintenance zones are undergoing scheduled work. Valid values: active|inactive|planned|decommissioned|maintenance.',
  `zone_type` STRING COMMENT 'Classification of the load zone based on its role in the distribution network hierarchy. Primary zones serve major load centers, secondary zones serve neighborhood clusters, tertiary zones serve smaller segments, and special zones serve unique loads (industrial parks, critical infrastructure). Valid values: primary|secondary|tertiary|special.',
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
  CONSTRAINT `pk_distribution_load_zone` PRIMARY KEY (`load_zone_id`)
)
USING DELTA
COMMENT 'Master record for distribution load zones — logical groupings of network segments used for load balancing, volt-VAR optimization dispatch, demand forecasting, and capacity planning. Captures zone identifier, zone name, geographic boundary (GIS polygon), nominal load (MW/MVAr), peak demand (MW), associated feeders, voltage regulation targets, power factor targets, and DMS zone classification. Serves as the control zone for VVO dispatch actions and the planning unit for distribution capacity studies. SSOT for load zone definition in GE PowerOn ADMS. | CMM: CIM SubLoadArea (close), IEC61970::LoadModel.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'LoadZone',
  'cmm.cim.class' = 'SubLoadArea',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::LoadModel',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.load_zone',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- DistributionSwitchingOrder  <<CIM SwitchingPlan : exact>>
CREATE TABLE IF NOT EXISTS `distribution`.`distribution_switching_order` (
  `distribution_switching_order_id` BIGINT NOT NULL COMMENT 'Unique identifier for the distribution switching order. Primary key for this entity.',
  `audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: Switching orders are standard audit scope items for NERC compliance audits examining switching procedures, clearance protocols, and operational safety. Linking orders to audits enables evidence sampli',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Switching orders incur labor, equipment, and overhead costs that must be allocated to cost centers for O&M expense tracking, budget variance analysis, and regulatory cost reporting. Core to work order',
  `crew_id` BIGINT COMMENT 'Foreign key reference to the field crew assigned to execute this switching order. Links to workforce management system for crew tracking and dispatch.',
  `emergency_stock_event_id` BIGINT COMMENT 'Foreign key linking to supply.emergency_stock_event. Business justification: Emergency switching operations during major storms trigger emergency stock deployment. Links switching orders to emergency material events for cost tracking, FEMA reimbursement documentation, and post',
  `event_id` BIGINT COMMENT 'Foreign key reference to the outage event that necessitated this switching order. Populated for emergency and restoration switching operations.',
  `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Planned switching work for maintenance or capital projects is tracked via internal orders for cost collection before settlement to fixed assets or expense accounts. Essential for capital vs. expense w',
  `notification_account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Planned outage notifications for switching orders require direct account links for customer communication workflows. Critical customers, medical baseline accounts, and large commercial accounts need p',
  `primary_distribution_employee_id` BIGINT COMMENT 'User identifier of the system operator or supervisor who authorized the switching order for execution. Critical for audit trail and compliance with NERC CIP standards.',
  `quaternary_distribution_created_by_user_employee_id` BIGINT COMMENT 'User identifier of the system operator or automated process that created this switching order record. Part of the audit trail.',
  `quinary_distribution_last_modified_by_user_employee_id` BIGINT COMMENT 'User identifier of the person who last modified this switching order record. Part of the audit trail.',
  `safety_clearance_id` BIGINT COMMENT 'Foreign key reference to the safety clearance record that authorizes work on de-energized equipment. Required for all switching orders that create safe work zones.',
  `staging_warehouse_id` BIGINT COMMENT 'Foreign key linking to supply.warehouse. Business justification: Planned switching orders requiring equipment installation/replacement need material staging from specific warehouses. Tracks where materials are pulled from for work execution, supports logistics plan',
  `tertiary_distribution_cancelled_by_user_employee_id` BIGINT COMMENT 'User identifier of the person who cancelled the switching order. Part of the cancellation audit trail.',
  `work_order_id` BIGINT COMMENT 'Foreign key reference to the maintenance or construction work order that requires this switching operation. Populated for planned maintenance switching.',
  `actual_end_timestamp` TIMESTAMP COMMENT 'Actual date and time when the switching operation was completed. Captured when the final switching step is confirmed and the order is closed.',
  `actual_start_timestamp` TIMESTAMP COMMENT 'Actual date and time when the switching operation began execution. Captured when the first switching step is initiated.',
  `affected_customer_count` INT COMMENT 'Estimated number of customers whose service may be interrupted or affected by this switching operation. Used for customer notification and impact analysis.',
  `affected_feeder_count` INT COMMENT 'Number of distribution feeders impacted by this switching operation. Used for impact assessment and planning.',
  `approval_required` BOOLEAN COMMENT 'Indicates whether this switching order requires supervisory or management approval before execution. Typically true for high-impact or high-risk operations.',
  `approval_status` STRING COMMENT 'Current approval status of the switching order. Tracks whether the order is awaiting approval, has been approved, or has been rejected. Valid values: not_required|pending|approved|rejected.',
  `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the switching order was approved. Part of the approval workflow audit trail.',
  `authorization_timestamp` TIMESTAMP COMMENT 'Date and time when the switching order was authorized for execution. Part of the approval workflow audit trail.',
  `cancellation_reason` STRING COMMENT 'Free-text explanation of why the switching order was cancelled. Populated only when order_status is cancelled.',
  `cancellation_timestamp` TIMESTAMP COMMENT 'Date and time when the switching order was cancelled. Part of the cancellation audit trail.',
  `completed_switching_steps` INT COMMENT 'Number of switching steps that have been successfully completed. Used to track progress and calculate completion percentage.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this switching order record was first created in the system. Part of the audit trail.',
  `crew_assignment_timestamp` TIMESTAMP COMMENT 'Date and time when the crew was assigned to this switching order. Used for crew utilization tracking and dispatch analytics.',
  `failed_switching_steps` INT COMMENT 'Number of switching steps that failed during execution. Indicates operational issues or equipment failures that require attention.',
  `flisr_automation_enabled` BOOLEAN COMMENT 'Indicates whether this switching order was executed automatically by FLISR automation logic. True for automated fault isolation and restoration sequences, false for manual operations.',
  `flisr_sequence_code` STRING COMMENT 'Unique identifier for the FLISR automation sequence that generated this switching order. Populated only for FLISR-automated orders.',
  `initiating_event_reference` STRING COMMENT 'Reference identifier to the event that triggered this switching order, such as an outage event ID, maintenance work order number, or FLISR automation event. Links the switching order to its business context.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this switching order record was last modified. Part of the audit trail.',
  `load_transfer_mw` DECIMAL(10,3) COMMENT 'Amount of load in megawatts being transferred between feeders or circuits as a result of this switching operation. Populated for load-transfer type orders.',
  `notes` STRING COMMENT 'Free-text field for operational notes, special instructions, or comments related to the switching order. Used by operators and crews to communicate important context.',
  `order_status` STRING COMMENT 'Current lifecycle state of the switching order. Tracks progression from draft through approval, execution, and completion or cancellation. Reference-value candidates: draft|pending_approval|approved|in_progress|completed|cancelled|failed.',
  `order_type` STRING COMMENT 'Classification of the switching order based on the operational context and urgency. Planned orders are scheduled in advance, emergency orders respond to unplanned events, FLISR-automated orders are executed by Fault Location Isolation and Service Restoration automation, and load-transfer orders redistribute load across feeders. Valid values: planned|emergency|flisr_automated|load_transfer|maintenance|storm_restoration.',
  `post_switch_network_topology_snapshot` STRING COMMENT 'Serialized representation of the distribution network topology state after the switching operation. Captures the new device states, connectivity, and energization status for validation and record-keeping.',
  `pre_switch_network_topology_snapshot` STRING COMMENT 'Serialized representation of the distribution network topology state before the switching operation. Captures device states, connectivity, and energization status for rollback and analysis purposes.',
  `priority_level` STRING COMMENT 'Operational priority assigned to this switching order. Critical priority is assigned to emergency restoration and public safety situations, high to major outages, medium to planned maintenance, and low to routine operations. Valid values: critical|high|medium|low.',
  `safety_clearance_status` STRING COMMENT 'Current status of the safety clearance associated with this switching order. Tracks whether the clearance has been issued, is active, or has been released after work completion. Valid values: not_required|pending|issued|released|expired.',
  `scheduled_end_timestamp` TIMESTAMP COMMENT 'Planned date and time when the switching operation is expected to be completed. Used for resource planning and customer communication.',
  `scheduled_start_timestamp` TIMESTAMP COMMENT 'Planned date and time when the switching operation is scheduled to begin. For planned orders, this is set during scheduling; for emergency orders, this may be set at order creation.',
  `source_system` STRING COMMENT 'Name of the operational system that originated this switching order record. Typically GE PowerOn ADMS for distribution switching operations.',
  `source_system_record_code` STRING COMMENT 'Unique identifier of this switching order in the source operational system. Used for data lineage and reconciliation.',
  `switching_order_number` STRING COMMENT 'Externally-known business identifier for the switching order, typically formatted with prefix and sequence number for tracking and reference. Pattern: ^[A-Z]{2,4}-[0-9]{6,10}$.',
  `total_switching_steps` INT COMMENT 'Total number of individual switching steps defined in this switching order. Each step represents a discrete device operation (open, close, tag, untag).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_distribution_distribution_switching_order` PRIMARY KEY (`distribution_switching_order_id`)
)
USING DELTA
COMMENT 'Transactional record capturing planned and emergency switching operations on the distribution network, including the full sequence of individual switching steps. Captures switching order number, order type (planned/emergency/FLISR-automated/load-transfer), initiating event reference, crew assignment, authorization approvals, safety clearances, and completion status. Each order contains an ordered sequence of switching steps, each with: step sequence number, target device, operation type (open/close/tag/untag), required pre/post device state, execution timestamp, operator ID, confirmed device state, and step completion status. Records pre-switch and post-switch network topology for each order. SSOT for all distribution switching operations including FLISR-automated sequences, load transfer operations, and step-level audit trail. Sourced from GE PowerOn ADMS switching management module. | CMM: CIM SwitchingPlan (exact), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DistributionSwitchingOrder',
  'cmm.cim.class' = 'SwitchingPlan',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.distribution_switching_order'
);

-- DistributionSwitchingStep  <<CIM SwitchingAction : exact>>
CREATE TABLE IF NOT EXISTS `distribution`.`distribution_switching_step` (
  `distribution_switching_step_id` BIGINT NOT NULL COMMENT 'Unique identifier for the distribution switching step record. Primary key for this transactional line entity.',
  `distribution_sectionalizing_device_id` BIGINT COMMENT 'Identifier of the distribution device (breaker, recloser, switch, sectionalizer) to be operated in this step.',
  `distribution_substation_id` BIGINT COMMENT 'Identifier of the substation where the switching device is located. Links to asset location hierarchy.',
  `distribution_switching_order_id` BIGINT COMMENT 'FK to distribution.distribution_switching_order.distribution_switching_order_id — Classic header-detail relationship. Each switching step belongs to exactly one switching order. Production-critical for switching execution and audit trail.',
  `employee_id` BIGINT COMMENT 'Identifier of the system operator or field crew member who executed this switching step. Links to workforce management system.',
  `feeder_id` BIGINT COMMENT 'Identifier of the distribution feeder circuit affected by this switching step. Links to distribution network topology.',
  `primary_distribution_switching_order_id` BIGINT COMMENT 'Foreign key reference to the parent switching order. Links this step to the overall switching operation header.',
  `safety_clearance_id` BIGINT COMMENT 'Reference to the safety clearance authorization required before executing this switching step. Ensures worker safety compliance.',
  `scada_point_id` BIGINT COMMENT 'SCADA system point identifier for the switching device. Used for real-time telemetry and remote control integration.',
  `sectionalizing_device_id` BIGINT COMMENT 'FK to distribution.sectionalizing_device.sectionalizing_device_id — Each switching step operates a specific device. The step description says \'device to be operated\'. Critical for FLISR automation and switching validation.',
  `actual_duration_minutes` INT COMMENT 'Actual time in minutes taken to complete this switching step. Used for performance analysis and future planning.',
  `actual_execution_timestamp` TIMESTAMP COMMENT 'Actual date and time when the switching step was executed. Provides audit trail and timing analysis for switching operations.',
  `actual_state_after` STRING COMMENT 'Actual confirmed device state after the switching operation was executed. Captured via SCADA or field verification. Valid values: open|closed|tagged|unknown|not_verified.',
  `actual_state_before` STRING COMMENT 'Actual confirmed device state before the switching operation was executed. Captured via SCADA or field verification. Valid values: open|closed|tagged|unknown|not_verified.',
  `affected_customers_count` INT COMMENT 'Number of customers impacted by this switching step. Used for outage impact analysis and customer notification.',
  `completion_timestamp` TIMESTAMP COMMENT 'Date and time when the switching step was marked as completed. Used for duration analysis and operational reporting.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this switching step record was first created in the system. Audit trail for record lifecycle.',
  `device_type` STRING COMMENT 'Classification of the switching device being operated. Determines operational characteristics and safety protocols. Reference-value candidates: circuit_breaker|recloser|sectionalizer|disconnect_switch|load_break_switch|fuse|tie_switch|capacitor_switch.',
  `estimated_duration_minutes` INT COMMENT 'Estimated time in minutes to complete this switching step. Used for scheduling and resource planning.',
  `execution_method` STRING COMMENT 'Method by which the switching step was executed. Distinguishes between automated, remote, and manual field operations. Valid values: scada_remote|manual_local|flisr_automated|dms_automated|field_crew.',
  `failure_reason` STRING COMMENT 'Detailed explanation if the switching step failed to execute or complete successfully. Used for root cause analysis.',
  `flisr_sequence_code` STRING COMMENT 'Identifier for the automated FLISR sequence that generated this switching step. Links to automated fault response operations.',
  `is_critical_step` BOOLEAN COMMENT 'Indicates whether this switching step is critical to the overall switching order success. Critical steps require additional verification.',
  `is_reversible` BOOLEAN COMMENT 'Indicates whether this switching step can be reversed or undone. Used for rollback planning in case of failures.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this switching step record was last updated. Tracks record change history for audit purposes.',
  `load_transferred_mw` DECIMAL(10,3) COMMENT 'Amount of electrical load in megawatts transferred or affected by this switching step. Used for load balancing analysis.',
  `operation_type` STRING COMMENT 'Type of switching action to be performed on the device. Defines the specific operation required in this step. Valid values: open|close|tag|untag|verify|test.',
  `operator_name` STRING COMMENT 'Name of the operator who executed the switching step. Provides human-readable audit trail.',
  `required_state_after` STRING COMMENT 'Expected device state after executing this switching step. Used for post-operation validation and confirmation. Valid values: open|closed|tagged|unknown.',
  `required_state_before` STRING COMMENT 'Expected device state before executing this switching step. Used for pre-operation validation and safety verification. Valid values: open|closed|tagged|unknown.',
  `retry_count` INT COMMENT 'Number of times this switching step was attempted before successful completion or final failure. Tracks operational challenges.',
  `scheduled_execution_timestamp` TIMESTAMP COMMENT 'Planned date and time for executing this switching step. Used for coordinated switching sequences and outage planning.',
  `step_notes` STRING COMMENT 'Free-text notes or comments about this switching step. Captures operational context, special instructions, or field observations.',
  `step_sequence_number` INT COMMENT 'Sequential order of this switching step within the parent switching order. Determines execution order for switching operations.',
  `step_status` STRING COMMENT 'Current execution status of this switching step. Tracks lifecycle from planning through completion or failure. Valid values: pending|in_progress|completed|failed|cancelled|skipped.',
  `verification_method` STRING COMMENT 'Method used to verify the switching step was completed successfully. Critical for safety and operational integrity. Valid values: scada_telemetry|visual_inspection|voltage_test|continuity_test|not_verified.',
  `verification_timestamp` TIMESTAMP COMMENT 'Date and time when the switching step completion was verified. Provides audit trail for safety compliance.',
  `voltage_level_kv` DECIMAL(8,2) COMMENT 'Operating voltage level in kilovolts of the circuit where the switching device is located. Critical for safety protocols.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_distribution_distribution_switching_step` PRIMARY KEY (`distribution_switching_step_id`)
)
USING DELTA
COMMENT 'Transactional record for each individual switching action within a switching order. Captures step sequence number, device to be operated, operation type (open/close/tag/untag), required state before and after, execution timestamp, operator ID, actual device state confirmed, and step completion status. Provides granular audit trail for switching operations and supports FLISR automated switching sequences. | CMM: CIM SwitchingAction (exact), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DistributionSwitchingStep',
  'cmm.cim.class' = 'SwitchingAction',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.distribution_switching_step'
);

-- DistributionFlisrEvent  <<CIM PSREvent : extension>>
CREATE TABLE IF NOT EXISTS `distribution`.`distribution_flisr_event` (
  `distribution_flisr_event_id` BIGINT NOT NULL COMMENT 'Unique identifier for the FLISR automation event record. Primary key.',
  `distribution_network_segment_id` BIGINT COMMENT 'Identifier of the distribution network segment (feeder section) identified by FLISR algorithm as containing the fault. References GIS utility network topology.',
  `distribution_substation_id` BIGINT COMMENT 'Identifier of the distribution substation serving the affected feeder. Used for substation-level outage aggregation and reporting.',
  `employee_id` BIGINT COMMENT 'Identifier of the ADMS operator who intervened in the FLISR sequence, if operator override occurred. Null for fully automated events.',
  `ems_alarm_id` BIGINT COMMENT 'Foreign key linking to grid.ems_alarm. Business justification: FLISR automation events trigger EMS alarms that grid operators monitor for real-time situational awareness, disturbance analysis, and NERC compliance reporting. Critical for integrated distribution-tr',
  `event_id` BIGINT COMMENT 'Identifier of the parent outage event record in the Outage Management System (OMS) that this FLISR event is associated with. Links FLISR automation to broader outage lifecycle.',
  `feeder_id` BIGINT COMMENT 'Identifier of the primary distribution feeder on which the FLISR event occurred. Used for feeder-level reliability analysis and SAIDI/SAIFI calculation.',
  `network_segment_id` BIGINT COMMENT 'FK to distribution.network_segment.network_segment_id — FLISR events identify a faulted segment. The description mentions \'faulted segment identified\'. Critical for fault isolation logic and reliability reporting.',
  `storm_event_id` BIGINT COMMENT 'Identifier linking this FLISR event to a declared storm event, if the fault occurred during a major weather event. Used for storm impact aggregation and mutual aid reporting.',
  `caidi_contribution_minutes` DECIMAL(10,4) COMMENT 'Calculated contribution of this FLISR event to the CAIDI reliability index, in minutes. Computed as total customer-minutes / customers affected. Measures average restoration time per affected customer.',
  `communication_failure_flag` BOOLEAN COMMENT 'Indicates whether communication failures with field devices occurred during the FLISR sequence. True if communication issues impacted automation; false otherwise.',
  `customers_affected_initial` INT COMMENT 'Number of customer meters that lost service when the fault occurred and before FLISR restoration actions. Used for SAIFI numerator calculation.',
  `customers_affected_post_restoration` INT COMMENT 'Number of customer meters that remain without service after FLISR restoration sequence completed. Represents customers on the isolated faulted segment awaiting manual repair.',
  `customers_restored_count` INT COMMENT 'Number of customer meters that had service restored by FLISR automation (initial affected minus post-restoration affected). Measures FLISR effectiveness in minimizing outage scope.',
  `der_impacted_count` INT COMMENT 'Number of Distributed Energy Resource (DER) installations (solar, storage, generators) affected by the FLISR event. Used for DER impact analysis and IEEE 1547 compliance reporting.',
  `event_status` STRING COMMENT 'Current lifecycle status of the FLISR automation event. Tracks progression from initiation through completion or failure. Valid values: initiated|in_progress|completed|failed|partially_completed|aborted.',
  `event_timestamp` TIMESTAMP COMMENT 'Date and time when the FLISR automation event was triggered by the Advanced Distribution Management System (ADMS). Represents the real-world moment the fault was detected and FLISR sequence initiated.',
  `failure_reason` STRING COMMENT 'Detailed explanation of why FLISR automation failed or was aborted, if applicable. Captures system errors, communication failures, operator intervention reasons, or topology constraints.',
  `fault_current_amps` DECIMAL(10,2) COMMENT 'Magnitude of fault current measured at the triggering fault indicator, in amperes. Used for fault severity analysis and protective device coordination validation.',
  `fault_type` STRING COMMENT 'Classification of the fault condition that triggered FLISR. Permanent faults require manual repair; temporary faults may clear after isolation; transient faults clear on recloser operation. Valid values: permanent|temporary|transient.',
  `flisr_algorithm_version` STRING COMMENT 'Version identifier of the FLISR algorithm logic deployed in ADMS at the time of this event. Used for performance trending and algorithm tuning analysis.',
  `flisr_event_number` STRING COMMENT 'Business identifier for the FLISR event, typically generated by GE PowerOn ADMS. Used for external reference and operational tracking.',
  `flisr_outcome_status` STRING COMMENT 'Final outcome classification of the FLISR automation attempt. Full success indicates all restoration actions completed; partial success indicates some customers restored; failed indicates no restoration achieved. Valid values: full_success|partial_success|failed|aborted_operator|aborted_system.',
  `isolation_devices_operated` STRING COMMENT 'Comma-separated list of switching device IDs (reclosers, sectionalizers, automated switches) that were operated to isolate the faulted segment. Captures the isolation sequence executed by FLISR.',
  `isolation_time_seconds` INT COMMENT 'Elapsed time in seconds from fault detection to completion of fault isolation switching. Subset of total restoration time, measures speed of fault containment.',
  `load_transferred_kw` DECIMAL(12,2) COMMENT 'Amount of electrical load in kilowatts transferred to alternate feeders during FLISR restoration. Used for load balancing analysis and feeder capacity validation.',
  `major_event_exclusion_flag` BOOLEAN COMMENT 'Indicates whether this FLISR event qualifies for exclusion from reliability indices under IEEE 1366 Major Event Day criteria. True if excluded; false if included in normal reliability calculations.',
  `operator_override_flag` BOOLEAN COMMENT 'Indicates whether a human operator intervened to override or abort the automated FLISR sequence. True if operator action occurred; false if fully automated.',
  `puc_reportable_flag` BOOLEAN COMMENT 'Indicates whether this FLISR event meets the threshold criteria for mandatory reporting to the state Public Utility Commission. True if reportable; false otherwise.',
  `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this FLISR event record was first created in the data system. Used for data lineage and audit trail.',
  `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this FLISR event record was last modified in the data system. Used for data lineage and audit trail.',
  `restoration_devices_operated` STRING COMMENT 'Comma-separated list of switching device IDs operated to restore service to de-energized segments downstream of the fault. Captures the restoration switching sequence executed by FLISR.',
  `restoration_time_seconds` INT COMMENT 'Elapsed time in seconds from fault detection to completion of FLISR restoration switching sequence. Critical metric for CAIDI calculation and FLISR performance benchmarking.',
  `saidi_contribution_minutes` DECIMAL(10,4) COMMENT 'Calculated contribution of this FLISR event to the SAIDI reliability index, in customer-minutes. Computed as (customers affected × duration) / total customers served. Critical for PUC reliability reporting.',
  `saifi_contribution` DECIMAL(10,6) COMMENT 'Calculated contribution of this FLISR event to the SAIFI reliability index. Computed as customers affected / total customers served. Critical for PUC reliability reporting.',
  `scada_alarm_count` INT COMMENT 'Number of SCADA alarms generated during the FLISR event. High alarm counts may indicate cascading issues or communication problems.',
  `source_system` STRING COMMENT 'Identifier of the source system that generated this FLISR event record, typically GE PowerOn ADMS. Used for data lineage and multi-system integration scenarios.',
  `switching_operations_count` INT COMMENT 'Total number of switching device operations (open/close commands) executed during the FLISR sequence. Used for device wear analysis and maintenance planning.',
  `topology_validation_status` STRING COMMENT 'Status of network topology validation performed by ADMS before executing FLISR switching. Invalid topology may prevent or abort FLISR automation. Valid values: valid|invalid|uncertain|not_checked.',
  `triggering_fault_indicator_code` STRING COMMENT 'Identifier of the fault indicator device (FCI or FPI) that detected the fault condition and triggered the FLISR automation sequence. Links to SCADA point or asset registry.',
  `voltage_sag_percent` DECIMAL(5,2) COMMENT 'Percentage voltage drop observed during the fault condition, relative to nominal voltage. Indicates severity of power quality disturbance.',
  `weather_condition` STRING COMMENT 'Prevailing weather condition at the time of the FLISR event, if available from weather data integration. Used for fault cause correlation and storm impact analysis. Reference-value candidates: clear|rain|snow|ice|wind|lightning|fog|extreme_heat.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_distribution_distribution_flisr_event` PRIMARY KEY (`distribution_flisr_event_id`)
)
USING DELTA
COMMENT 'Transactional record capturing Fault Location, Isolation, and Service Restoration (FLISR) automation events triggered by GE PowerOn ADMS. Captures event timestamp, triggering fault indicator, faulted segment identified, isolation devices operated, restoration switching sequence executed, customers affected before and after restoration, restoration time (seconds), FLISR algorithm version, and outcome status. SSOT for FLISR automation event history. Critical for SAIDI/SAIFI/CAIDI reliability index calculation, FLISR performance benchmarking, and PUC reporting. | CMM: CIM PSREvent (extension), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DistributionFlisrEvent',
  'cmm.cim.class' = 'PSREvent',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.distribution_flisr_event'
);

-- VoltVarAction  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `distribution`.`volt_var_action` (
  `volt_var_action_id` BIGINT NOT NULL COMMENT 'Unique identifier for the Volt-VAR Optimization control action record. Primary key.',
  `distribution_substation_id` BIGINT COMMENT 'Identifier of the distribution substation serving the control zone where the action occurred.',
  `employee_id` BIGINT COMMENT 'Identifier of the system operator who initiated or approved the VVO action (for manual or advisory modes). Null for fully automatic actions.',
  `feeder_id` BIGINT COMMENT 'Identifier of the distribution feeder circuit on which the VVO action was performed.',
  `load_zone_id` BIGINT COMMENT 'FK to distribution.load_zone.load_zone_id — VVO actions are executed within a control zone. The description mentions \'control zone\'. Critical for volt-VAR optimization tracking.',
  `volt_load_zone_id` BIGINT COMMENT 'Identifier of the distribution control zone where the VVO action was executed. Links to the geographic/electrical zone managed by ADMS.',
  `volt_var_device_id` BIGINT COMMENT 'Unique identifier of the distribution device operated during this action (capacitor bank, voltage regulator, LTC transformer, or other VVO-capable device).',
  `volt_vvo_action_in_zone` BIGINT COMMENT 'FK to distribution.load_zone.load_zone_id — VVO actions are dispatched per control zone. This FK links operational actions to the load zone they optimize, supporting CVR program performance measurement by zone.',
  `volt_vvo_action_targets_zone` BIGINT COMMENT 'FK to distribution.load_zone.load_zone_id — VVO control actions are dispatched per control zone. The load_zone FK identifies which zone the optimization action targets, enabling zone-level VVO performance analysis.',
  `action_status` STRING COMMENT 'Outcome status of the VVO action execution: successful, failed, partial (some devices operated), aborted (cancelled mid-execution), or pending. Valid values: successful|failed|partial|aborted|pending.',
  `action_timestamp` TIMESTAMP COMMENT 'Date and time when the VVO control action was executed on the distribution network. Principal business event timestamp for this transaction.',
  `action_type` STRING COMMENT 'Classification of the VVO action: voltage regulation, reactive power compensation, power factor correction, Conservation Voltage Reduction (CVR), energy loss reduction, or combined optimization. Valid values: voltage_regulation|reactive_power_compensation|power_factor_correction|cvr|loss_reduction|combined.',
  `affected_customer_count` INT COMMENT 'Number of customer premises affected by the VVO action within the control zone.',
  `approval_required_flag` BOOLEAN COMMENT 'Indicates whether operator approval was required before executing this VVO action (True/False).',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this VVO action record was first created in the system. Audit trail field.',
  `cvr_factor` DECIMAL(6,4) COMMENT 'CVR factor achieved by the action: ratio of percent change in demand to percent change in voltage. Typical range 0.5 to 1.5.',
  `demand_reduction_kw` DECIMAL(12,2) COMMENT 'Peak demand reduction achieved by the VVO action (typically through CVR), measured in kilowatts (kW).',
  `der_active_flag` BOOLEAN COMMENT 'Indicates whether Distributed Energy Resources (solar, wind, storage) were actively generating/discharging in the control zone during the VVO action (True/False).',
  `der_impact_mw` DECIMAL(12,4) COMMENT 'Estimated impact of DER generation/discharge on the VVO optimization, measured in megawatts (MW). Null if no DER active.',
  `device_name` STRING COMMENT 'Human-readable name or label of the device operated (e.g., \'CAP-BANK-12A-01\', \'REG-SUBSTATION-5\').',
  `device_type` STRING COMMENT 'Type of distribution device operated: capacitor bank, voltage regulator, Load Tap Changer (LTC) transformer, switched capacitor, static VAR compensator, or other VVO-capable equipment. Valid values: capacitor_bank|voltage_regulator|ltc_transformer|switched_capacitor|static_var_compensator|other.',
  `energy_loss_reduction_kwh` DECIMAL(12,2) COMMENT 'Estimated energy loss reduction achieved by the VVO action over the optimization period, measured in kilowatt-hours (kWh).',
  `execution_duration_seconds` INT COMMENT 'Time taken to execute the VVO action from command initiation to device confirmation, measured in seconds.',
  `execution_mode` STRING COMMENT 'Mode in which the VVO action was executed: automatic (ADMS-initiated), manual (operator-initiated), scheduled (pre-planned), or advisory (recommended but not executed). Valid values: automatic|manual|scheduled|advisory.',
  `load_level` STRING COMMENT 'Distribution load level at the time of the VVO action: light, medium, heavy, or peak. Used for optimization performance analysis. Valid values: light|medium|heavy|peak.',
  `optimization_duration_seconds` INT COMMENT 'Time duration over which the VVO optimization was calculated and applied, measured in seconds.',
  `optimization_objective` STRING COMMENT 'Primary objective of the VVO action: Conservation Voltage Reduction (CVR), power factor correction, loss minimization, voltage profile improvement, peak demand reduction, or multi-objective optimization. Valid values: cvr|power_factor_correction|loss_minimization|voltage_profile_improvement|peak_demand_reduction|multi_objective.',
  `power_factor_after` DECIMAL(5,4) COMMENT 'Power factor in the control zone after the VVO action (ratio of real power to apparent power, range 0.0 to 1.0).',
  `power_factor_before` DECIMAL(5,4) COMMENT 'Power factor in the control zone before the VVO action (ratio of real power to apparent power, range 0.0 to 1.0).',
  `power_factor_improvement` DECIMAL(5,4) COMMENT 'Improvement in power factor achieved by the VVO action. Positive value indicates power factor increased (closer to unity).',
  `reactive_power_after_mvar` DECIMAL(12,4) COMMENT 'Reactive power flow in the control zone after the VVO action, measured in Megavolt-Amperes Reactive (MVAr).',
  `reactive_power_before_mvar` DECIMAL(12,4) COMMENT 'Reactive power flow in the control zone before the VVO action, measured in Megavolt-Amperes Reactive (MVAr).',
  `reactive_power_reduction_mvar` DECIMAL(12,4) COMMENT 'Reduction in reactive power flow achieved by the VVO action, measured in MVAr. Positive value indicates successful VAR reduction.',
  `scada_command_code` STRING COMMENT 'SCADA system command identifier that initiated the device operation. Links to SCADA command log.',
  `setpoint_after` DECIMAL(10,4) COMMENT 'Device setpoint value after the VVO action was executed. Units depend on device type.',
  `setpoint_before` DECIMAL(10,4) COMMENT 'Device setpoint value before the VVO action (tap position for LTC/regulator, switch state for capacitor, VAR output for SVC). Units depend on device type.',
  `setpoint_unit` STRING COMMENT 'Unit of measure for the setpoint values: tap position (integer), switch state (on/off), MVAr, kVAr, percent, or per-unit (pu). Valid values: tap_position|switch_state|mvar|kvar|percent|pu.',
  `source_system` STRING COMMENT 'Name of the source system that generated this VVO action record (e.g., \'GE PowerOn ADMS\', \'OSIsoft PI\', \'Manual Entry\').',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this VVO action record was last updated. Audit trail field.',
  `violation_description` STRING COMMENT 'Description of any voltage or operational violations detected (e.g., \'Voltage exceeded upper limit at node XYZ\', \'Device operation count exceeded daily limit\'). Null if no violations.',
  `violation_detected_flag` BOOLEAN COMMENT 'Indicates whether any voltage or operational violations were detected during or after the VVO action (True/False).',
  `voltage_after_pu` DECIMAL(8,6) COMMENT 'Average voltage profile in the control zone after the VVO action, measured in per-unit (pu) relative to nominal voltage.',
  `voltage_before_pu` DECIMAL(8,6) COMMENT 'Average voltage profile in the control zone before the VVO action, measured in per-unit (pu) relative to nominal voltage.',
  `voltage_improvement_pu` DECIMAL(8,6) COMMENT 'Change in voltage profile achieved by the VVO action, measured in per-unit (pu). Positive value indicates voltage increase, negative indicates reduction (CVR).',
  `weather_condition` STRING COMMENT 'Weather condition at the time of the VVO action (e.g., \'clear\', \'rain\', \'snow\', \'high_wind\'). Used for performance correlation analysis.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_distribution_volt_var_action` PRIMARY KEY (`volt_var_action_id`)
)
USING DELTA
COMMENT 'Transactional record for Volt-VAR Optimization (VVO) control actions executed by GE PowerOn ADMS on the distribution network. Captures action timestamp, control zone, device operated (capacitor bank, voltage regulator, LTC transformer), setpoint before and after, voltage profile improvement (pu), reactive power reduction (MVAr), energy loss reduction (kWh), optimization objective (conservation voltage reduction/power factor correction), and execution mode (automatic/manual). SSOT for VVO operational action history. Supports CVR program performance measurement and energy loss reduction reporting. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'VoltVarAction',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.volt_var_action'
);

-- CapacitorBank  <<CIM LinearShuntCompensator : exact>>
CREATE TABLE IF NOT EXISTS `distribution`.`capacitor_bank` (
  `capacitor_bank_id` BIGINT NOT NULL COMMENT 'Unique identifier for the capacitor bank asset. Primary key for the capacitor bank master record.',
  `distribution_substation_id` BIGINT COMMENT 'Reference to the parent distribution substation serving the feeder on which this capacitor bank is installed.',
  `feeder_id` BIGINT COMMENT 'Reference to the distribution feeder circuit to which this capacitor bank is connected for load balancing and voltage support.',
  `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: Capacitor banks are capitalized distribution assets requiring fixed asset registry tracking for depreciation, FERC account classification, and RAB inclusion. Essential for regulatory asset base report',
  `flisr_zone_id` BIGINT COMMENT 'Reference to the FLISR automation zone in which this capacitor bank operates for coordinated fault isolation and service restoration.',
  `material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: Capacitor banks are procured volt-var control equipment requiring material master linkage for maintenance parts planning, replacement cost tracking, and equipment standardization. Supports power quali',
  `nerc_cip_asset_id` BIGINT COMMENT 'Foreign key linking to compliance.nerc_cip_asset. Business justification: SCADA-controlled capacitor banks in substations can be BES Cyber Assets requiring CIP compliance when they impact BES reliability. The scada_point_id and volt_var_optimization_enabled attributes indic',
  `scada_point_id` BIGINT COMMENT 'SCADA system telemetry point reference for real-time monitoring and remote control of the capacitor bank through the Distribution Management System (DMS) or Advanced Distribution Management System (ADMS).',
  `technician_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Capacitor banks require assigned technicians for switching operations, maintenance testing, and control system verification. Essential for volt-var optimization programs, power factor correction, and',
  `acquisition_cost` DECIMAL(15,2) COMMENT 'Total cost incurred to acquire and install the capacitor bank, including equipment, labor, and materials.',
  `ambient_temperature_rating_c` DECIMAL(6,2) COMMENT 'Maximum ambient temperature rating in degrees Celsius at which the capacitor bank can safely operate per manufacturer specifications.',
  `asset_condition_score` DECIMAL(5,2) COMMENT 'Quantitative health index or condition score (typically 0-100) representing the current physical and operational condition of the capacitor bank based on inspection and diagnostic data.',
  `bank_name` STRING COMMENT 'Human-readable name or designation of the capacitor bank, typically including location or circuit reference.',
  `bank_number` STRING COMMENT 'Business identifier or asset tag assigned to the capacitor bank for operational reference and field identification.',
  `bank_type` STRING COMMENT 'Classification of the capacitor bank switching capability: fixed (always on), switched (manual or remote control), or automated (SCADA-controlled for volt-VAR optimization). Valid values: fixed|switched|automated.',
  `control_mode` STRING COMMENT 'Primary control strategy governing capacitor bank switching operations: time-based scheduling, voltage-based, VAr-based, temperature-based, power factor correction, or manual operation. Valid values: time|voltage|var|temperature|power_factor|manual.',
  `control_voltage_v` DECIMAL(8,2) COMMENT 'Control circuit voltage in volts required for operating the capacitor bank switching mechanism and control relays.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this capacitor bank record was first created in the system.',
  `criticality_rating` STRING COMMENT 'Business criticality classification of the capacitor bank based on its impact on system reliability, voltage support, and customer service. Valid values: critical|high|medium|low.',
  `fuse_rating_amperes` DECIMAL(10,2) COMMENT 'Current rating in amperes of the protective fuses installed to protect the capacitor bank from overcurrent and fault conditions.',
  `gis_feature_code` STRING COMMENT 'Unique feature identifier in the utility GIS system linking the capacitor bank to the geospatial network model and asset location database.',
  `in_service_date` DATE COMMENT 'Date when the capacitor bank was placed into active service and began providing reactive power compensation to the distribution network.',
  `installation_date` DATE COMMENT 'Date when the capacitor bank was installed and commissioned in the distribution network.',
  `last_maintenance_date` DATE COMMENT 'Date of the most recent preventive or corrective maintenance activity performed on the capacitor bank.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the capacitor bank installation location in decimal degrees for GIS mapping and spatial analysis.',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the capacitor bank installation location in decimal degrees for GIS mapping and spatial analysis.',
  `next_inspection_date` DATE COMMENT 'Planned date for the next routine inspection of the capacitor bank per the utility maintenance schedule.',
  `notes` STRING COMMENT 'Free-text field for capturing additional operational notes, special instructions, or historical information about the capacitor bank.',
  `number_of_steps` INT COMMENT 'Count of discrete switching steps or stages available in the capacitor bank for granular reactive power control. Single-step banks have a value of 1.',
  `operational_status` STRING COMMENT 'Current operational state of the capacitor bank in the distribution network lifecycle. Valid values: in_service|out_of_service|maintenance|retired|planned.',
  `ownership_type` STRING COMMENT 'Classification of asset ownership indicating whether the capacitor bank is owned by the utility, customer, third party, or leased. Valid values: utility_owned|customer_owned|third_party|leased.',
  `phase_connection` STRING COMMENT 'Electrical phase configuration indicating which phase(s) of the distribution circuit the capacitor bank is connected to for reactive power compensation. Reference-value candidates: three_phase|phase_a|phase_b|phase_c|phase_ab|phase_bc|phase_ca.',
  `pole_number` STRING COMMENT 'Identifier of the distribution pole or structure on which the capacitor bank is mounted, used for field location and maintenance planning.',
  `purchase_order_number` STRING COMMENT 'Procurement purchase order number under which the capacitor bank was acquired.',
  `rated_kvar` DECIMAL(12,2) COMMENT 'Nameplate reactive power rating of the capacitor bank in kilovolt-amperes reactive, representing the total reactive power compensation capacity.',
  `serial_number` STRING COMMENT 'Unique serial number assigned by the manufacturer for individual unit identification and warranty tracking.',
  `switching_device_type` STRING COMMENT 'Type of switching mechanism used to energize and de-energize the capacitor bank for reactive power control. Valid values: vacuum_switch|oil_switch|sf6_breaker|contactor|relay.',
  `switching_operations_count` INT COMMENT 'Total number of switching operations (on/off cycles) performed by the capacitor bank since installation, used for condition monitoring and maintenance planning.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this capacitor bank record was last modified in the system.',
  `volt_var_optimization_enabled` BOOLEAN COMMENT 'Indicates whether this capacitor bank is integrated into the ADMS volt-VAR optimization control scheme for automated voltage and reactive power management.',
  `voltage_rating_kv` DECIMAL(10,2) COMMENT 'Nominal voltage rating of the capacitor bank in kilovolts, indicating the distribution voltage level at which the bank operates.',
  `warranty_expiration_date` DATE COMMENT 'Date when the manufacturer warranty coverage for the capacitor bank expires.',
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
  CONSTRAINT `pk_distribution_capacitor_bank` PRIMARY KEY (`capacitor_bank_id`)
)
USING DELTA
COMMENT 'Master record for shunt capacitor banks installed on the distribution network for reactive power compensation and voltage support. Captures bank identifier, rated kVAr, voltage rating, number of steps, switching type (fixed/switched/automated), control mode (time/voltage/VAr/temperature), GIS location, feeder and phase assignment, SCADA point reference, installation date, and operational status. Managed through GE PowerOn ADMS for volt-VAR optimization. | CMM: CIM LinearShuntCompensator (exact), IEC61970::Wires.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CapacitorBank',
  'cmm.cim.class' = 'LinearShuntCompensator',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61970::Wires',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.capacitor_bank',
  'cmm.gis.location.role' = 'PowerSystemResource.Location'
);

-- VoltVarDevice  <<CIM RegulatingCondEq : close>>
CREATE TABLE IF NOT EXISTS `distribution`.`volt_var_device` (
  `volt_var_device_id` BIGINT NOT NULL COMMENT 'Primary key for volt_var_device',
  `control_engineer_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Voltage regulators and var devices require designated control engineers for setpoint management, CVR optimization, and performance tuning. Critical for volt-var optimization programs, conservation vol',
  `distribution_substation_id` BIGINT COMMENT 'Identifier of the distribution substation that serves the feeder on which this device is located. Used for hierarchical network modeling and regional voltage management strategies.',
  `feeder_id` BIGINT COMMENT 'Identifier of the distribution feeder circuit on which this volt-VAR device is installed. Links the device to the distribution network topology for load flow analysis, outage management, and VVO optimization.',
  `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: Voltage regulators and reactive power control devices are capitalized assets tracked in fixed asset registry for depreciation, FERC reporting, and RAB valuation. Core to utility asset accounting and r',
  `material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: Voltage regulators and reactive power devices are physical assets requiring material master linkage for procurement tracking, spare parts management, lifecycle costing, and equipment standardization.',
  `asset_criticality` STRING COMMENT 'Risk-based classification of the device importance to grid reliability and customer service. Critical devices serve large customer populations or critical infrastructure, high criticality devices impact significant load, medium and low criticality devices have localized impact. Used for maintenance prioritization and spare parts stocking. Valid values: critical|high|medium|low.',
  `bandwidth_voltage_kv` DECIMAL(6,3) COMMENT 'Voltage deadband or tolerance range within which the device will not initiate tap changes or switching operations, expressed in kilovolts. Prevents excessive switching due to minor voltage fluctuations. Typical values are 1.0 to 2.0 kV.',
  `commissioning_date` DATE COMMENT 'Date when the device was tested, verified, and placed into active service. May differ from installation date if testing and acceptance procedures span multiple days. Used for warranty start date and performance baseline establishment.',
  `communication_protocol` STRING COMMENT 'Communication protocol used for SCADA integration and remote control. DNP3 and Modbus are legacy protocols, IEC 61850 is the modern standard for substation automation, proprietary protocols are vendor-specific, and none indicates no remote communication capability. Valid values: dnp3|modbus|iec61850|proprietary|none.',
  `control_mode` STRING COMMENT 'Operating control strategy for the volt-VAR device. Time-based uses scheduled switching, voltage-based responds to local voltage measurements, VAR-based responds to reactive power flow, temperature-based adjusts for ambient conditions, bandwidth control maintains voltage within a deadband, and remote SCADA enables centralized dispatch from ADMS. Valid values: time_based|voltage_based|var_based|temperature_based|bandwidth_control|remote_scada.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this volt-VAR device record was first created in the system. Used for data lineage, audit trails, and record lifecycle tracking.',
  `cvr_enabled_flag` BOOLEAN COMMENT 'Boolean indicator of whether this device participates in conservation voltage reduction programs that intentionally lower distribution voltage to reduce energy consumption. True indicates the device is included in CVR dispatch strategies, false indicates exclusion from CVR operations.',
  `device_identifier` STRING COMMENT 'Externally-known unique identifier for the volt-VAR device, typically assigned by the utility and used in SCADA systems, field operations, and ADMS integration. May be asset tag, equipment number, or SCADA point reference. Pattern: ^[A-Z0-9]{6,20}$.',
  `device_name` STRING COMMENT 'Human-readable name or label for the volt-VAR device, often including location or feeder reference for operational identification.',
  `device_type` STRING COMMENT 'Classification of the volt-VAR device by technology and function. Capacitor banks provide reactive power support, step regulators adjust voltage levels, LTC (Load Tap Changer) transformers provide dynamic voltage control, static VAR compensators offer fast reactive power injection, and synchronous condensers provide rotating reactive power reserves. Valid values: capacitor_bank|step_regulator|ltc_transformer|static_var_compensator|synchronous_condenser.',
  `expected_useful_life_years` INT COMMENT 'Estimated operational lifespan of the device in years, based on manufacturer specifications and utility experience. Used for depreciation schedules, capital planning, and asset replacement forecasting.',
  `gis_feature_code` STRING COMMENT 'Unique identifier linking this volt-VAR device to its corresponding feature in the utility GIS system (Esri ArcGIS Utility Network). Enables spatial queries, network tracing, and integration between ADMS and GIS for topology-aware VVO.',
  `installation_date` DATE COMMENT 'Date when the volt-VAR device was installed and commissioned on the distribution network. Used for age-based maintenance scheduling, depreciation calculations, and asset replacement planning.',
  `last_maintenance_date` DATE COMMENT 'Date of the most recent preventive or corrective maintenance activity performed on the device. Used for maintenance interval tracking and reliability analysis.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this device record. Used for change tracking, data quality monitoring, and synchronization with upstream systems.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the device installation location in decimal degrees. Used for GIS mapping, spatial analysis, outage visualization, and field crew dispatch.',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the device installation location in decimal degrees. Used for GIS mapping, spatial analysis, outage visualization, and field crew dispatch.',
  `next_maintenance_date` DATE COMMENT 'Scheduled date for the next planned maintenance activity. Derived from maintenance plan intervals and last maintenance date. Used for work order generation and resource planning.',
  `notes` STRING COMMENT 'Free-form text field for operational notes, special instructions, configuration details, or historical context relevant to the device. Used by field crews, engineers, and operations staff for knowledge capture.',
  `number_of_steps` INT COMMENT 'Total number of discrete tap positions or switching steps available on the device. For step regulators and LTCs, this defines the granularity of voltage adjustment. Typical values range from 16 to 33 steps. For capacitor banks, this represents the number of switchable stages.',
  `operational_status` STRING COMMENT 'Current lifecycle state of the volt-VAR device indicating availability for grid operations. In-service devices are actively controlled by VVO algorithms, out-of-service devices are temporarily unavailable, maintenance indicates scheduled work, testing indicates commissioning or validation, retired indicates permanent removal, and standby indicates reserve capacity. Valid values: in_service|out_of_service|maintenance|testing|retired|standby.',
  `ownership_type` STRING COMMENT 'Classification of asset ownership. Utility-owned devices are capitalized on the utility balance sheet, customer-owned devices (behind-the-meter DER) are not, third-party-owned devices may be under PPA or service agreements, and leased devices have specific accounting treatment. Valid values: utility_owned|customer_owned|third_party_owned|leased.',
  `phase_configuration` STRING COMMENT 'Electrical phase assignment of the volt-VAR device on the distribution circuit. Three-phase devices serve balanced loads, single-phase devices serve lateral taps, and two-phase devices serve open-wye or open-delta configurations. Critical for unbalanced load flow analysis. Reference-value candidates: three_phase|single_phase_a|single_phase_b|single_phase_c|two_phase_ab|two_phase_bc|two_phase_ac.',
  `rated_capacity_kva` DECIMAL(12,2) COMMENT 'Nameplate apparent power capacity of the device in kilovolt-amperes (kVA). Applicable primarily to voltage regulators and LTC transformers. Used for thermal loading calculations and capacity planning.',
  `rated_capacity_kvar` DECIMAL(12,2) COMMENT 'Nameplate reactive power capacity of the device in kilovolt-amperes reactive (kVAr). For capacitor banks, this is the total reactive power injection capability. For regulators and LTCs, this represents the maximum reactive power handling capability. Critical for VVO optimization calculations and grid planning.',
  `remote_control_enabled_flag` BOOLEAN COMMENT 'Boolean indicator of whether the device can be operated remotely via SCADA or ADMS. True indicates remote control capability is active, false indicates local-only or manual operation. Critical for FLISR automation and real-time grid optimization.',
  `scada_point_reference` STRING COMMENT 'SCADA system tag or point identifier used to monitor and control this device in real-time. Links the device to telemetry streams for voltage, current, tap position, and switch status. Essential for ADMS integration and remote operations.',
  `serial_number` STRING COMMENT 'Unique serial number assigned by the manufacturer to this specific device unit. Used for warranty claims, maintenance history tracking, and asset lifecycle management.',
  `switching_type` STRING COMMENT 'Switching capability classification. Fixed devices are permanently connected, switched devices can be manually operated, and automated devices support remote control via SCADA or ADMS for real-time VVO and FLISR operations. Valid values: fixed|switched|automated.',
  `tap_range_percent` DECIMAL(6,2) COMMENT 'Total voltage adjustment range available through tap changing, expressed as a percentage of nominal voltage. Typical ranges are ±10% or ±5%. Used by VVO algorithms to determine available voltage control authority.',
  `time_delay_seconds` INT COMMENT 'Intentional delay period before the device responds to a control signal or voltage deviation, expressed in seconds. Prevents nuisance operations during transient conditions. Typical values range from 15 to 120 seconds.',
  `voltage_rating_kv` DECIMAL(8,2) COMMENT 'Nominal voltage level at which the device operates, expressed in kilovolts (kV). Typical distribution voltages include 4.16, 12.47, 13.2, 13.8, 23, 34.5 kV. Essential for network topology modeling and voltage compliance verification per ANSI C84.1.',
  `voltage_setpoint_kv` DECIMAL(8,3) COMMENT 'Target voltage level that the device is configured to maintain, expressed in kilovolts. For voltage regulators and LTCs, this is the desired output voltage. For capacitor banks with voltage control, this is the threshold for switching. Updated by VVO optimization and CVR programs.',
  `vvo_enabled_flag` BOOLEAN COMMENT 'Boolean indicator of whether this device is actively participating in automated volt-VAR optimization algorithms executed by the ADMS. True indicates the device accepts remote control commands for voltage and reactive power management, false indicates manual-only operation.',
  `warranty_expiration_date` DATE COMMENT 'Date when the manufacturer warranty coverage ends. Used for maintenance cost forecasting and replacement planning decisions.',
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
  CONSTRAINT `pk_distribution_volt_var_device` PRIMARY KEY (`volt_var_device_id`)
)
USING DELTA
COMMENT 'Master record for all voltage and reactive power regulation devices deployed on distribution feeders, including shunt capacitor banks, step-voltage regulators, and load tap changer (LTC) transformers. Captures device identifier, device type (capacitor_bank/step_regulator/LTC), rated capacity (kVAr or kVA), voltage rating, control mode (time/voltage/VAr/temperature/bandwidth), switching type (fixed/switched/automated), tap range and setpoints, GIS location, feeder and phase assignment, SCADA point reference, installation date, and operational status. SSOT for all volt-VAR optimization devices on the distribution network. Integral to VVO dispatch, conservation voltage reduction (CVR) programs, and ANSI C84.1 voltage compliance. Managed through GE PowerOn ADMS. | CMM: CIM RegulatingCondEq (close), IEC61970::Wires.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'VoltVarDevice',
  'cmm.cim.class' = 'RegulatingCondEq',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Wires',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.volt_var_device',
  'cmm.gis.location.role' = 'PowerSystemResource.Location'
);

-- DistributionReliabilityEvent  <<CIM Outage : close>>
CREATE TABLE IF NOT EXISTS `distribution`.`distribution_reliability_event` (
  `distribution_reliability_event_id` BIGINT NOT NULL COMMENT 'Unique identifier for the distribution reliability interruption event. Primary key for IEEE 1366 reliability index calculation and PUC reporting.',
  `distribution_substation_id` BIGINT COMMENT 'Identifier of the distribution substation serving the affected feeder. Used for substation-level reliability aggregation and asset performance correlation.',
  `emergency_stock_event_id` BIGINT COMMENT 'Foreign key linking to supply.emergency_stock_event. Business justification: Major reliability events (storms, cascading failures) trigger emergency material deployment for restoration. Links outage events to emergency stock for cost allocation, FEMA reimbursement tracking, re',
  `ems_alarm_id` BIGINT COMMENT 'Foreign key linking to grid.ems_alarm. Business justification: Distribution reliability events generate EMS alarms for grid operator awareness during major outages. Required for integrated outage management systems (OMS-EMS integration) and regulatory SAIDI/SAIFI',
  `feeder_id` BIGINT COMMENT 'Identifier of the distribution feeder (primary circuit) affected by the reliability event. Used for worst-performing feeder analysis and targeted reliability improvement programs.',
  `grid_reliability_event_id` BIGINT COMMENT 'Foreign key linking to grid.grid_reliability_event. Business justification: Major distribution reliability events escalate to grid-level reliability events for transmission-impacting outages. Required for NERC OE-417 reporting, major event day classification, and integrated r',
  `network_segment_id` BIGINT COMMENT 'Foreign key linking to distribution.network_segment. Business justification: Reliability events (interruptions) occur on specific network segments. Currently reliability_event has segment_id as STRING, but this should be a proper FK to network_segment.network_segment_id for re',
  `oms_event_id` BIGINT COMMENT 'Source system identifier from the Outage Management System (OMS) or ADMS. Used for cross-system reconciliation and audit trail back to operational systems.',
  `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: Reliability events are aggregated into IEEE 1366 reports and PUC performance filings. The puc_reportable_flag indicates filing requirement; linking events to filings enables automated report generatio',
  `responding_crew_id` BIGINT COMMENT 'Foreign key linking to workforce.crew. Business justification: Reliability events track which crew responded for performance metrics, labor cost allocation, crew efficiency analysis, and storm restoration reporting. Essential for PUC reporting, mutual aid cost re',
  `scada_alarm_id` BIGINT COMMENT 'SCADA alarm identifier that triggered the reliability event detection. Used for SCADA integration validation and event correlation.',
  `sectionalizing_device_id` BIGINT COMMENT 'Identifier of the specific protective device that operated during the event. Links to asset registry for device maintenance history and performance tracking.',
  `storm_event_id` BIGINT COMMENT 'Foreign key reference to the storm event record if this reliability event was part of a larger storm or weather system. Enables storm-level reliability aggregation and mutual aid analysis.',
  `cause_code` STRING COMMENT 'Root cause classification per IEEE 1366 Appendix categories: equipment failure, weather, animal contact, vegetation, vehicle accident, scheduled maintenance, unknown, or other utility-specific cause codes.',
  `cause_description` STRING COMMENT 'Detailed narrative description of the root cause of the reliability event, including specific equipment failures, weather conditions, or external factors.',
  `crew_arrival_timestamp` TIMESTAMP COMMENT 'Date and time when field crew arrived at the fault location. Used to calculate crew travel time and on-site restoration duration.',
  `crew_dispatch_timestamp` TIMESTAMP COMMENT 'Date and time when field crew was dispatched to investigate and repair the fault. Used to calculate crew response time and restoration performance metrics.',
  `critical_customer_affected_flag` BOOLEAN COMMENT 'Boolean indicator whether any critical customers (hospitals, emergency services, water treatment, etc.) were affected by the interruption. Used for priority restoration and regulatory notification.',
  `customer_minutes_interrupted` DECIMAL(18,2) COMMENT 'Total customer-minutes of interruption calculated as customers_interrupted × duration_minutes. Used to calculate SAIDI (System Average Interruption Duration Index) per IEEE 1366.',
  `customers_interrupted` INT COMMENT 'Total number of customer accounts experiencing service interruption during this event. Used to calculate SAIFI (System Average Interruption Frequency Index) per IEEE 1366.',
  `customers_restored_by_flisr` INT COMMENT 'Number of customers automatically restored by FLISR automation without manual crew intervention. Used to quantify FLISR benefit and avoided customer-minutes interrupted.',
  `data_source_system` STRING COMMENT 'Name of the operational system that originated this reliability event record (e.g., GE PowerOn ADMS, OSIsoft PI, SAP IS-U). Used for data lineage and source system reconciliation.',
  `duration_minutes` DECIMAL(10,2) COMMENT 'Total duration of the interruption event in minutes, calculated as the difference between restoration_timestamp and event_start_timestamp. Used for IEEE 1366 sustained vs. momentary classification.',
  `energy_not_served_mwh` DECIMAL(12,3) COMMENT 'Total energy not delivered to customers in megawatt-hours (MWh) due to the interruption, calculated as load_interrupted_mw × duration_hours. Used for economic impact analysis and PUC reporting.',
  `equipment_age_years` INT COMMENT 'Age in years of the failed equipment at the time of the event. Used for asset health correlation and age-based replacement program justification.',
  `equipment_failed` STRING COMMENT 'Type of distribution equipment that failed and caused the interruption (e.g., transformer, conductor, insulator, pole, underground cable). Used for asset failure analysis and replacement prioritization.',
  `estimated_restoration_time` TIMESTAMP COMMENT 'Initial estimated time of restoration communicated to customers and regulators when the event began. Used to measure ERT accuracy and customer communication effectiveness.',
  `event_number` STRING COMMENT 'Business identifier for the reliability event, typically generated by the Outage Management System (OMS) or Advanced Distribution Management System (ADMS). Used for external reporting and cross-system correlation.',
  `event_start_timestamp` TIMESTAMP COMMENT 'Date and time when the reliability event began (first customer interruption detected). Captured from SCADA, AMI, or customer call-in data via OMS/ADMS.',
  `event_type` STRING COMMENT 'Classification of the interruption event per IEEE 1366 definitions: sustained (>5 minutes), momentary (≤5 minutes), or planned (scheduled maintenance outage). Valid values: sustained|momentary|planned.',
  `exclusion_reason` STRING COMMENT 'Detailed explanation of why the event is excluded from IEEE 1366 reliability index calculations, if ieee_1366_exclusion_flag is true. References specific IEEE 1366 exclusion criteria.',
  `fault_latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the fault location in decimal degrees. Used for spatial reliability analysis and vegetation management correlation.',
  `fault_location_description` STRING COMMENT 'Textual description of the physical location where the fault occurred (e.g., street address, pole number, landmark). Used for crew dispatch and asset maintenance correlation.',
  `fault_longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the fault location in decimal degrees. Used for spatial reliability analysis and vegetation management correlation.',
  `flisr_operated_flag` BOOLEAN COMMENT 'Boolean indicator whether FLISR automation successfully operated to isolate the fault and restore service to unaffected customers. Used to measure FLISR effectiveness and MAIFI (Momentary Average Interruption Frequency Index) reduction.',
  `flisr_operation_time_seconds` DECIMAL(10,2) COMMENT 'Time in seconds for FLISR automation to isolate the fault and restore service to unaffected segments. Used to measure FLISR performance and reduction in customer-minutes interrupted.',
  `ieee_1366_exclusion_flag` BOOLEAN COMMENT 'Boolean indicator whether this event should be excluded from IEEE 1366 reliability index calculations per standard exclusion criteria (e.g., loss of supply, prearranged interruption, customer-owned equipment failure).',
  `load_interrupted_mw` DECIMAL(10,3) COMMENT 'Total electrical load in megawatts (MW) interrupted during the event, captured from SCADA or estimated from customer count and load profiles. Used for energy not served (ENS) calculations.',
  `major_event_day_flag` BOOLEAN COMMENT 'Boolean indicator whether this event occurred on a Major Event Day per IEEE 1366 2.5-beta method. Major Event Days are excluded from annual reliability index calculations to prevent catastrophic events from skewing performance metrics.',
  `protective_device_type` STRING COMMENT 'Type of protective device that operated to isolate the fault (e.g., recloser, circuit breaker, fuse, sectionalizer). Used for protective device performance analysis and coordination studies.',
  `puc_report_date` DATE COMMENT 'Date when the reliability event was reported to the Public Utility Commission, if puc_reportable_flag is true. Used to track regulatory reporting compliance.',
  `puc_reportable_flag` BOOLEAN COMMENT 'Boolean indicator whether this event must be reported to the state Public Utility Commission per regulatory requirements. Typically true for sustained interruptions affecting a threshold number of customers.',
  `record_created_timestamp` TIMESTAMP COMMENT 'Date and time when this reliability event record was first created in the data warehouse. Used for data lineage and audit trail.',
  `record_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this reliability event record was last modified. Used for change tracking and data quality monitoring.',
  `repair_description` STRING COMMENT 'Detailed description of the repair work performed by field crew to restore service, including equipment replaced, temporary repairs, or permanent fixes.',
  `restoration_timestamp` TIMESTAMP COMMENT 'Date and time when service was fully restored to all affected customers. Used to calculate event duration and customer-minutes interrupted.',
  `voltage_level_kv` DECIMAL(8,2) COMMENT 'Nominal voltage level in kilovolts (kV) of the distribution circuit affected by the event (e.g., 12.47, 13.2, 34.5). Used for voltage-class reliability analysis.',
  `weather_condition` STRING COMMENT 'Weather conditions at the time of the event (e.g., thunderstorm, ice storm, high winds, lightning, normal). Used for weather-related reliability analysis and correlation with cause codes.',
  `gis_location_id` BIGINT COMMENT 'Reference to the canonical CIM Location (gis.location) holding this entity\'s geometry, CRS and address. Implements CIM association Incident.Location.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_distribution_distribution_reliability_event` PRIMARY KEY (`distribution_reliability_event_id`)
)
USING DELTA
COMMENT 'Transactional record for distribution reliability interruption events used to calculate IEEE 1366 reliability indices (SAIDI, SAIFI, CAIDI, MAIFI) for PUC reporting. Captures event identifier, event type (sustained/momentary/planned), cause code per IEEE 1366 Appendix (equipment failure/weather/animal/vegetation/scheduled/unknown), affected feeder and segment, number of customers interrupted, customer-minutes interrupted (CMI), event start and restoration timestamps, duration (minutes), major event day (MED) threshold flag, and IEEE 1366 2.5-beta exclusion flag. SSOT for PUC reliability reporting and IEEE 1366 index calculation. Supports annual reliability filings, worst-performing feeder analysis, and reliability improvement program tracking. | CMM: CIM Outage (close), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DistributionReliabilityEvent',
  'cmm.cim.class' = 'Outage',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.distribution_reliability_event',
  'cmm.gis.location.role' = 'Incident.Location'
);

-- FeederLoadReading  <<CIM AnalogValue : close>>
CREATE TABLE IF NOT EXISTS `distribution`.`feeder_load_reading` (
  `feeder_load_reading_id` BIGINT NOT NULL COMMENT 'Unique identifier for the feeder load reading record. Primary key for this transactional measurement event.',
  `distribution_flisr_event_id` BIGINT COMMENT 'Identifier linking this reading to a FLISR automation event if the reading was captured during an automated switching sequence. Null if no FLISR event was active.',
  `event_id` BIGINT COMMENT 'Identifier linking this reading to an outage event if the reading was captured during or immediately after an outage. Null if no outage was active at reading time.',
  `load_id` BIGINT COMMENT 'Foreign key linking to forecast.load. Business justification: Actual feeder load readings must be compared against load forecasts for accuracy measurement and model calibration. Essential for forecast accuracy tracking, MAPE calculation, model validation, and co',
  `measurement_point_id` BIGINT COMMENT 'Unique identifier for the specific monitoring point on the feeder where the reading was captured (e.g., feeder head, midpoint sensor, tie point). Corresponds to SCADA tag or PI point identifier.',
  `primary_feeder_id` BIGINT COMMENT 'Identifier of the distribution feeder or circuit segment where the load measurement was taken. Links to the feeder asset in the distribution network topology.',
  `state_estimation_run_id` BIGINT COMMENT 'Foreign key linking to grid.state_estimation_run. Business justification: Feeder load measurements provide boundary condition inputs to transmission state estimators for distribution-transmission interface modeling. Essential for accurate voltage/power flow analysis and con',
  `tertiary_feeder_id` BIGINT COMMENT 'FK to distribution.feeder.feeder_id — Feeder load readings are measurements taken at feeder head or monitoring points. The feeder FK is essential for associating readings with the correct feeder for load analysis and capacity planning.',
  `active_power_mw` DECIMAL(12,4) COMMENT 'Real power measured in megawatts (MW) at the monitoring point. Represents the actual power flowing through the feeder segment at the reading timestamp. Used for load balancing and capacity planning.',
  `ambient_temperature_celsius` DECIMAL(6,2) COMMENT 'Ambient temperature in degrees Celsius at or near the monitoring point. Used for thermal rating adjustments and equipment derating calculations under high-temperature conditions.',
  `apparent_power_mva` DECIMAL(12,4) COMMENT 'Apparent power measured in megavolt-amperes (MVA) at the monitoring point. Represents the total power (vector sum of active and reactive power) and is used for equipment rating and capacity calculations.',
  `current_phase_a_amperes` DECIMAL(10,2) COMMENT 'Current measured on Phase A conductor in amperes at the monitoring point. Used for load balancing across phases and thermal limit monitoring.',
  `current_phase_b_amperes` DECIMAL(10,2) COMMENT 'Current measured on Phase B conductor in amperes at the monitoring point. Used for load balancing across phases and thermal limit monitoring.',
  `current_phase_c_amperes` DECIMAL(10,2) COMMENT 'Current measured on Phase C conductor in amperes at the monitoring point. Used for load balancing across phases and thermal limit monitoring.',
  `data_quality_flag` STRING COMMENT 'Quality indicator for the reading. Good indicates validated data; suspect indicates data outside normal range but not rejected; bad indicates failed validation; estimated indicates imputed value; missing indicates no data received. Aligns with VEE (Validation, Estimation, and Editing) processes. Valid values: good|suspect|bad|estimated|missing.',
  `data_retention_category` STRING COMMENT 'Classification determining the retention period for this reading. Operational (1-2 years); regulatory (5-7 years per FERC/PUC requirements); historical (10+ years for trend analysis); archive (permanent retention for critical events). Valid values: operational|regulatory|historical|archive.',
  `data_source_type` STRING COMMENT 'Classification of the data acquisition method. SCADA realtime indicates live telemetry; historian archive indicates retrieved from PI or similar historian; manual entry indicates operator-entered value; estimated indicates calculated/imputed value. Valid values: scada_realtime|historian_archive|manual_entry|estimated.',
  `der_generation_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether DER generation (solar, wind, battery storage) was active on this feeder segment at the time of reading. Used for DER impact analysis and reverse power flow detection.',
  `emergency_rating_mva` DECIMAL(12,4) COMMENT 'Emergency short-term thermal rating of the feeder segment in MVA. Represents the maximum load that can be carried for a limited duration (typically 15 minutes to 4 hours) during contingency conditions.',
  `estimation_method` STRING COMMENT 'Method used to estimate the reading value if actual data was missing or invalid. None indicates no estimation was performed; other values indicate the specific estimation algorithm applied per MDM VEE rules. Valid values: none|linear_interpolation|historical_average|similar_day|regression_model.',
  `frequency_hz` DECIMAL(6,3) COMMENT 'System frequency measured in hertz at the monitoring point. Nominal value is 60 Hz in North America; deviations indicate grid stability issues and are monitored per NERC reliability standards.',
  `loading_percentage` DECIMAL(6,2) COMMENT 'Percentage of normal rating currently being utilized, calculated as (apparent_power_mva / normal_rating_mva) * 100. Key metric for capacity planning and identifying overloaded feeders.',
  `measurement_point_type` STRING COMMENT 'Classification of the monitoring location on the distribution network. Feeder head represents the substation exit point; midpoint and tie point represent intermediate monitoring locations; recloser, capacitor bank, and regulator represent device-level monitoring points. Valid values: feeder_head|midpoint|tie_point|recloser|capacitor_bank|regulator.',
  `normal_rating_mva` DECIMAL(12,4) COMMENT 'Normal continuous thermal rating of the feeder segment in MVA under standard ambient conditions. Used to calculate loading percentage and identify overload conditions.',
  `peak_demand_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether this reading occurred during a system peak demand period. Used for peak demand analysis and capacity planning studies.',
  `pi_point_name` STRING COMMENT 'OSIsoft PI point tag name or equivalent historian tag identifier for this measurement. Provides traceability back to the source SCADA tag in the historian system.',
  `power_factor` DECIMAL(5,4) COMMENT 'Ratio of active power to apparent power (dimensionless, range -1.0 to +1.0). Indicates the efficiency of power delivery and is a key input for volt-VAR optimization and capacitor bank control.',
  `reactive_power_mvar` DECIMAL(12,4) COMMENT 'Reactive power measured in megavolt-amperes reactive (MVAr) at the monitoring point. Critical for volt-VAR optimization and power factor management on the distribution network.',
  `reading_timestamp` TIMESTAMP COMMENT 'Date and time when the load measurement was recorded by the SCADA system or data historian. Represents the actual event time of the observation, distinct from record creation time.',
  `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this record was first inserted into the lakehouse silver layer. Distinct from reading_timestamp which represents the actual measurement event time. Used for data lineage and audit trail.',
  `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this record was last modified in the lakehouse silver layer. Updated when VEE processes revise data quality flags or estimation values. Used for change tracking and audit trail.',
  `reverse_power_flow_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether power was flowing in the reverse direction (from customer premises back to substation) at the time of reading. Indicates high DER penetration or net export conditions.',
  `scada_source_system` STRING COMMENT 'Name or identifier of the SCADA system or data historian that originated this reading (e.g., OSIsoft PI, GE iFIX, Schneider ClearSCADA). Used for data lineage and troubleshooting.',
  `validation_status` STRING COMMENT 'Status of the VEE (Validation, Estimation, and Editing) process for this reading. Validated indicates the reading passed all quality checks; pending indicates awaiting validation; failed indicates rejected by validation rules; bypassed indicates validation was skipped. Valid values: validated|pending|failed|bypassed.',
  `voltage_phase_a_kv` DECIMAL(10,4) COMMENT 'Voltage measured on Phase A in kilovolts at the monitoring point. Critical for voltage regulation and ANSI C84.1 compliance monitoring.',
  `voltage_phase_b_kv` DECIMAL(10,4) COMMENT 'Voltage measured on Phase B in kilovolts at the monitoring point. Critical for voltage regulation and ANSI C84.1 compliance monitoring.',
  `voltage_phase_c_kv` DECIMAL(10,4) COMMENT 'Voltage measured on Phase C in kilovolts at the monitoring point. Critical for voltage regulation and ANSI C84.1 compliance monitoring.',
  `weather_condition` STRING COMMENT 'General weather condition at the time of reading. Used for correlating load patterns with weather events and for storm impact analysis. Reference-value candidates: clear|cloudy|rain|snow|storm|extreme_heat|extreme_cold.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_distribution_feeder_load_reading` PRIMARY KEY (`feeder_load_reading_id`)
)
USING DELTA
COMMENT 'Transactional record for interval load measurements at feeder head and key monitoring points on the distribution network, sourced from SCADA/OSIsoft PI historian or similar data historian. Captures reading timestamp, feeder or segment identifier, measurement point type (feeder head/midpoint/tie point), active power (MW), reactive power (MVAr), apparent power (MVA), current (A per phase), voltage (kV per phase), power factor, temperature, and data quality flag. SSOT for distribution-level load telemetry distinct from AMI meter interval data owned by the metering domain. Supports load balancing, capacity planning, peak demand analysis, volt-VAR optimization feedback, and normal/emergency rating calculations. | CMM: CIM AnalogValue (close), IEC61970::Meas.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'FeederLoadReading',
  'cmm.cim.class' = 'AnalogValue',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Meas',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.feeder_load_reading'
);

-- DerInterconnectionPoint  <<CIM ConnectivityNode : close>>
CREATE TABLE IF NOT EXISTS `distribution`.`der_interconnection_point` (
  `der_interconnection_point_id` BIGINT NOT NULL COMMENT 'Unique identifier for the physical point of interconnection where a DER connects to the distribution network. Primary key for the DER interconnection point master record.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: DER interconnection studies, inspections, and ongoing monitoring incur costs tracked to cost centers for potential cost recovery in rates or DER program cost allocation. Required for regulatory cost r',
  `der_network_segment_id` BIGINT COMMENT 'Reference to the specific segment of the feeder where the DER connects. Used for granular hosting capacity analysis and voltage profile management.',
  `distribution_substation_id` BIGINT COMMENT 'Reference to the distribution substation serving this interconnection point. Used for substation-level DER aggregation and transformer loading analysis.',
  `environmental_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.environmental_permit. Business justification: DER installations require environmental permits for land use, stormwater management, and emissions (for fossil-fuel DER). Interconnection approval processes verify permit compliance before permission',
  `feeder_id` BIGINT COMMENT 'FK to distribution.feeder.feeder_id — DER interconnection points are assigned to feeders. This FK supports hosting capacity analysis (how much DER can this feeder absorb?) and reverse power flow monitoring.',
  `forecast_renewable_id` BIGINT COMMENT 'Foreign key linking to forecast.forecast_renewable. Business justification: DER interconnection points are the physical assets for which renewable generation forecasts are prepared. Essential for DER dispatch, hosting capacity analysis, grid impact studies, and managing distr',
  `interconnection_engineer_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: DER interconnections require designated engineers for technical review, IEEE 1547 compliance verification, hosting capacity analysis, and ongoing performance monitoring. Regulatory requirement under s',
  `inverter_material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: DER inverters and interconnection equipment are procured materials requiring material master linkage for approved equipment lists, warranty tracking, and standardization. Supports DER interconnection',
  `meter_id` BIGINT COMMENT 'Foreign key linking to metering.meter. Business justification: DER interconnection points require dedicated revenue-quality metering for net metering billing, export credit calculation, IEEE 1547 compliance monitoring, and interconnection agreement validation. Re',
  `ppa_id` BIGINT COMMENT 'Foreign key linking to trading.ppa. Business justification: DER facilities often operate under power purchase agreements. Interconnection points track the physical delivery infrastructure for PPA generation, essential for contract compliance, settlement reconc',
  `primary_feeder_id` BIGINT COMMENT 'Reference to the distribution feeder circuit to which this DER is connected. Critical for hosting capacity analysis, reverse power flow monitoring, and feeder-level DER aggregation.',
  `primary_network_segment_id` BIGINT COMMENT 'FK to distribution.network_segment.network_segment_id — DER interconnection points connect at specific network segments. Segment-level assignment is needed for detailed hosting capacity analysis and voltage impact studies.',
  `scada_point_id` BIGINT COMMENT 'Reference to the SCADA telemetry point monitoring this DER interconnection. Links to real-time power flow, voltage, and status data in the distribution management system.',
  `service_point_id` BIGINT COMMENT 'Reference to the customer service point (meter location) associated with this DER interconnection. Links DER to billing, metering, and customer account systems.',
  `tertiary_feeder_id` BIGINT COMMENT 'FK to distribution.feeder.feeder_id — DER interconnection points are located on specific feeders. This FK is required for hosting capacity analysis, reverse power flow monitoring, and feeder-level DER penetration tracking.',
  `anti_islanding_protection` STRING COMMENT 'Type of anti-islanding protection implemented to prevent the DER from energizing a de-energized section of the grid. Required by IEEE 1547 for all grid-connected DERs. Valid values: passive|active|hybrid.',
  `commissioning_date` DATE COMMENT 'Date the DER system was commissioned and tested for proper operation. Precedes permission to operate and marks completion of installation.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this DER interconnection point record was first created in the system. Used for data lineage and audit trail.',
  `decommissioning_date` DATE COMMENT 'Date the DER was permanently disconnected from the grid and removed from service. Triggers termination of interconnection agreement and NEM enrollment.',
  `der_subtype` STRING COMMENT 'Detailed classification of the DER technology, such as lithium-ion battery, rooftop solar, ground-mount solar, Level 2 EV charger, DC fast charger, natural gas CHP, etc.',
  `der_type` STRING COMMENT 'Classification of the distributed energy resource technology connected at this point. Determines applicable interconnection standards, protection requirements, and DERMS control capabilities. Reference-value candidates: solar_pv|battery_storage|ev_charger|chp|wind|fuel_cell|microgrid.',
  `derms_device_code` STRING COMMENT 'Unique identifier for this DER in the DERMS platform. Used for real-time monitoring, dispatch commands, and aggregation into virtual power plants.',
  `derms_integration_enabled` BOOLEAN COMMENT 'Indicates whether this DER is integrated with the utility DERMS for monitoring and control. True enables participation in demand response, VPP aggregation, and grid services programs.',
  `export_capacity_kw` DECIMAL(12,3) COMMENT 'Maximum power the DER is authorized to export to the distribution grid in kilowatts. May be less than nameplate capacity due to interconnection agreement limits or hosting capacity constraints.',
  `export_limit_control_method` STRING COMMENT 'Method used to enforce export capacity limits: inverter setpoint, revenue-grade meter with control, or DERMS dispatch. Determines compliance verification approach.',
  `frequency_watt_control_enabled` BOOLEAN COMMENT 'Indicates whether the DER inverter is configured to provide frequency-watt droop control for grid frequency support. Category B IEEE 1547 capability for frequency stability.',
  `gis_feature_code` STRING COMMENT 'Unique identifier for the DER interconnection point in the utility GIS system. Links to network topology, asset location, and spatial analysis tools.',
  `hosting_capacity_impact_mw` DECIMAL(10,3) COMMENT 'Estimated impact of this DER on the feeder hosting capacity in megawatts. Used for cumulative hosting capacity tracking and interconnection queue management.',
  `ieee_1547_category` STRING COMMENT 'IEEE 1547 classification based on DER capabilities. Category A: basic interconnection functions. Category B: advanced grid support functions including voltage/frequency ride-through and reactive power control. Valid values: category_a|category_b.',
  `ieee_1547_compliance_status` STRING COMMENT 'Certification status indicating whether the DER interconnection meets IEEE 1547 standard requirements for grid interconnection and interoperability. Grandfathered indicates pre-2018 installations under prior standards. Valid values: compliant|non_compliant|pending_verification|grandfathered.',
  `interconnection_agreement_number` STRING COMMENT 'Unique identifier for the legal interconnection agreement between the utility and the DER owner. References the contract governing technical requirements, liability, and operational terms.',
  `interconnection_agreement_status` STRING COMMENT 'Current status of the interconnection agreement in its approval and execution lifecycle. Executed status required before DER can be energized. Valid values: pending|approved|executed|expired|terminated.',
  `interconnection_application_date` DATE COMMENT 'Date the customer submitted the interconnection application to the utility. Used for queue management and regulatory timeline compliance tracking.',
  `interconnection_approval_date` DATE COMMENT 'Date the utility approved the interconnection application after technical review and impact studies. Marks transition from pending to approved status.',
  `interconnection_voltage_level_kv` DECIMAL(8,3) COMMENT 'Distribution system voltage level at which the DER connects, typically 0.12 kV (120V), 0.24 kV (240V), 0.48 kV (480V), 4.16 kV, 12.47 kV, or 34.5 kV. Determines applicable interconnection standards and protection requirements.',
  `inverter_serial_number` STRING COMMENT 'Unique serial number of the inverter unit. Used for asset tracking, warranty claims, and field service management.',
  `inverter_type` STRING COMMENT 'Classification of the inverter technology used to convert DC power to AC for grid interconnection. Determines control capabilities, grid support functions, and IEEE 1547 compliance requirements. Valid values: string|central|micro|hybrid|battery_integrated.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the DER interconnection point in decimal degrees. Used for GIS mapping, spatial analysis, and solar irradiance modeling.',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the DER interconnection point in decimal degrees. Used for GIS mapping, spatial analysis, and solar irradiance modeling.',
  `nameplate_capacity_kw` DECIMAL(12,3) COMMENT 'Maximum rated power output of the DER in kilowatts as specified by the manufacturer. Critical for hosting capacity analysis, interconnection approval, and grid impact studies.',
  `nem_eligible` BOOLEAN COMMENT 'Indicates whether this DER interconnection qualifies for net energy metering under state tariffs. True if the DER meets NEM program requirements for capacity, technology type, and customer class.',
  `nem_program_type` STRING COMMENT 'Specific NEM program under which this DER is enrolled, such as NEM 2.0, NEM 3.0, virtual net metering, or aggregate net metering. Determines compensation rates and billing treatment.',
  `notes` STRING COMMENT 'Free-text field for additional information about the interconnection point, such as special operating conditions, equipment modifications, or field observations.',
  `operational_status` STRING COMMENT 'Current operational state of the DER interconnection point in its lifecycle. Active indicates the DER is energized and may export/import power; pending_approval indicates interconnection application under review. Valid values: active|inactive|pending_approval|commissioned|decommissioned|suspended.',
  `ownership_type` STRING COMMENT 'Classification of DER ownership structure. Determines billing treatment, incentive eligibility, and operational control rights. Valid values: customer_owned|third_party_owned|utility_owned|community_solar.',
  `permission_to_operate_date` DATE COMMENT 'Date the utility granted permission for the DER to begin exporting power to the grid. Follows successful inspection and commissioning. Required for NEM billing start.',
  `phase_connection` STRING COMMENT 'Electrical phase configuration of the interconnection. Single-phase for residential; three-phase for commercial/industrial. Impacts load balancing and voltage regulation. Valid values: single_phase|three_phase_wye|three_phase_delta.',
  `poi_name` STRING COMMENT 'Descriptive name for the interconnection point, typically including customer name or site identifier for operational reference.',
  `poi_number` STRING COMMENT 'Business identifier for the point of interconnection assigned by the utility. Used in interconnection agreements, DERMS integration, and regulatory filings.',
  `premise_id` BIGINT COMMENT 'Reference to the customer premise where the DER is installed. Used for customer communication, site access coordination, and premise-level energy analytics.',
  `reverse_power_flow_enabled` BOOLEAN COMMENT 'Indicates whether this DER is authorized to export power back to the grid (reverse power flow). False for load-only or self-consumption-only installations.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this DER interconnection point record was last modified. Used for change tracking and data synchronization.',
  `volt_var_control_enabled` BOOLEAN COMMENT 'Indicates whether the DER inverter is configured to provide autonomous volt-VAR control for voltage regulation. Category B IEEE 1547 capability supporting grid voltage stability.',
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
  CONSTRAINT `pk_distribution_der_interconnection_point` PRIMARY KEY (`der_interconnection_point_id`)
)
USING DELTA
COMMENT 'Master record for the physical point of interconnection (POI) where a Distributed Energy Resource connects to the distribution network. Captures POI identifier, DER type (solar PV/battery/EV charger/CHP/wind), nameplate capacity (kW), inverter type and settings, interconnection voltage level, feeder and segment assignment, GIS location, NEM eligibility, anti-islanding protection scheme, DERMS reference, IEEE 1547 compliance status, and interconnection agreement status. SSOT for DER physical connection points on the distribution network. Supports hosting capacity analysis, DERMS integration, reverse power flow monitoring, and state interconnection rule compliance (e.g., Rule 21, SB 700). | CMM: CIM ConnectivityNode (close), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DerInterconnectionPoint',
  'cmm.cim.class' = 'ConnectivityNode',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.der_interconnection_point',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- ServiceTerritory  <<CIM SubGeographicalRegion : close>>
CREATE TABLE IF NOT EXISTS `distribution`.`service_territory` (
  `service_territory_id` BIGINT NOT NULL COMMENT 'Unique identifier for the service territory. Primary key.',
  `emergency_response_plan_id` BIGINT COMMENT 'Identifier for the emergency response and storm restoration plan specific to this territory.',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Service territories are top-level geographic planning units; forecast zones are typically subdivisions or aggregations within territories. Required for IRP filings, regulatory reporting, territorial l',
  `operating_org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Service territories map to organizational units for management structure, cost center allocation, union jurisdiction, and operational accountability. Fundamental for financial reporting, labor cost al',
  `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Service territories are the primary geographic/functional units for revenue and cost tracking, directly mapping to profit center structures for regulatory reporting, rate case revenue requirement allo',
  `rate_case_id` BIGINT COMMENT 'Foreign key linking to compliance.rate_case. Business justification: Service territories define the geographic and customer scope for rate cases. Rate base, revenue requirements, and rate design are calculated per service territory. Essential for linking territory-leve',
  `service_level_agreement_id` BIGINT COMMENT 'Identifier for the Service Level Agreement (SLA) defining performance commitments for this territory.',
  `ami_deployment_percent` DECIMAL(5,2) COMMENT 'Percentage of customers within this territory equipped with Advanced Metering Infrastructure (AMI) smart meters.',
  `annual_energy_consumption_mwh` DECIMAL(15,2) COMMENT 'Total annual energy consumption in megawatt-hours (MWh) for all customers within this territory.',
  `caidi_index` DECIMAL(8,2) COMMENT 'Customer Average Interruption Duration Index (CAIDI) in minutes for this territory, measuring average restoration time.',
  `circuit_miles` DECIMAL(12,2) COMMENT 'Total length of distribution circuits in miles within this territory.',
  `commercial_customer_count` INT COMMENT 'Number of commercial customer accounts within this territory.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this service territory record was first created in the system.',
  `customer_count` INT COMMENT 'Total number of active customer accounts served within this territory as of the last reporting period.',
  `der_penetration_percent` DECIMAL(5,2) COMMENT 'Percentage of total connected load represented by Distributed Energy Resources (DER) such as solar PV and battery storage.',
  `feeder_count` INT COMMENT 'Number of distribution feeders operating within this territory.',
  `flisr_enabled` BOOLEAN COMMENT 'Indicates whether Fault Location Isolation and Service Restoration (FLISR) automation is enabled for this territory.',
  `franchise_agreement_reference` STRING COMMENT 'Reference identifier to the legal franchise agreement or Certificate of Public Convenience and Necessity (CPCN) authorizing service in this territory.',
  `franchise_effective_date` DATE COMMENT 'Date when the franchise agreement became effective and the utility assumed obligation to serve.',
  `franchise_expiration_date` DATE COMMENT 'Date when the current franchise agreement expires, if applicable. Null for perpetual franchises.',
  `geographic_area_sq_miles` DECIMAL(12,2) COMMENT 'Total geographic area of the service territory measured in square miles.',
  `geographic_boundary_wkt` STRING COMMENT 'Geographic boundary of the service territory represented as a Well-Known Text (WKT) polygon for GIS integration.',
  `gis_feature_code` STRING COMMENT 'Unique feature identifier in the Esri ArcGIS Utility Network system linking this territory to the geospatial layer.',
  `industrial_customer_count` INT COMMENT 'Number of industrial customer accounts within this territory.',
  `jurisdiction_state_code` STRING COMMENT 'Two-letter state code identifying the primary regulatory jurisdiction. Pattern: ^[A-Z]{2}$.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this service territory record was last modified.',
  `notes` STRING COMMENT 'Additional notes or comments regarding the service territory, including special conditions or historical context.',
  `operational_status` STRING COMMENT 'Current operational status of the service territory indicating whether it is actively serving customers. Valid values: active|inactive|pending|decommissioned|transferred.',
  `ownership_type` STRING COMMENT 'Type of utility ownership for this service territory. Valid values: investor_owned|municipal|cooperative|federal.',
  `peak_demand_mw` DECIMAL(12,2) COMMENT 'Historical peak demand in megawatts (MW) recorded for this territory, used for capacity planning.',
  `peak_demand_timestamp` TIMESTAMP COMMENT 'Date and time when the historical peak demand was recorded.',
  `primary_voltage_kv` DECIMAL(8,2) COMMENT 'Primary distribution voltage level in kilovolts (kV) used for the majority of feeders in this territory.',
  `rate_schedule_reference` STRING COMMENT 'Reference to the primary rate schedule or tariff applicable to customers in this territory.',
  `regulatory_jurisdiction` STRING COMMENT 'State Public Utility Commission (PUC) or regulatory body with oversight authority for this territory.',
  `reliability_reporting_period` STRING COMMENT 'Reporting period for the reliability indices (format: YYYY or YYYY-QN for quarterly). Pattern: ^\\d{4}-Q[1-4]$|^\\d{4}$.',
  `residential_customer_count` INT COMMENT 'Number of residential customer accounts within this territory.',
  `saidi_index` DECIMAL(8,2) COMMENT 'System Average Interruption Duration Index (SAIDI) in minutes for this territory, measuring average outage duration per customer.',
  `saifi_index` DECIMAL(8,2) COMMENT 'System Average Interruption Frequency Index (SAIFI) for this territory, measuring average number of interruptions per customer.',
  `substation_count` INT COMMENT 'Number of distribution substations serving this territory.',
  `territory_code` STRING COMMENT 'Business identifier code for the service territory used in regulatory filings and operational systems. Pattern: ^[A-Z0-9]{2,10}$.',
  `territory_name` STRING COMMENT 'Official name of the service territory as recognized by regulatory authorities.',
  `territory_type` STRING COMMENT 'Classification of the service territory based on customer density and land use characteristics. Valid values: urban|suburban|rural|mixed|industrial|commercial.',
  `total_connected_load_mw` DECIMAL(12,2) COMMENT 'Total connected load capacity in megawatts (MW) for all customers and equipment within this territory.',
  `volt_var_optimization_enabled` BOOLEAN COMMENT 'Indicates whether Volt-VAR Optimization (VVO) is enabled for this territory to improve voltage regulation and reduce losses.',
  `voltage_service_levels` STRING COMMENT 'Comma-separated list of voltage levels (kV) provided within this territory (e.g., 4.16, 12.47, 34.5).',
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
  CONSTRAINT `pk_distribution_service_territory` PRIMARY KEY (`service_territory_id`)
)
USING DELTA
COMMENT 'Master reference record defining geographic franchise areas within which the utility holds the obligation to serve. Captures territory identifier, territory name, regulatory jurisdiction (state PUC), geographic boundary (GIS polygon), voltage service levels, customer count, total connected load (MW), associated substations, and franchise agreement reference. Used as a grouping dimension for PUC reliability reporting (SAIDI/SAIFI by territory), load planning, rate case filings, and regulatory compliance. SSOT for service territory boundaries in the distribution network. | CMM: CIM SubGeographicalRegion (close), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ServiceTerritory',
  'cmm.cim.class' = 'SubGeographicalRegion',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'reference_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.service_territory',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- SwitchingOrderFeederImpact  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `distribution`.`switching_order_feeder_impact` (
  `switching_order_feeder_impact_id` BIGINT NOT NULL COMMENT 'Unique identifier for this switching order feeder impact record. Primary key.',
  `distribution_switching_order_id` BIGINT COMMENT 'Foreign key linking to the distribution switching order that impacts this feeder',
  `feeder_id` BIGINT COMMENT 'Foreign key linking to the feeder impacted by this switching order',
  `affected_customer_count` INT COMMENT 'Number of customers on this specific feeder who are impacted by the switching operation. Used for customer notification and impact assessment per feeder.',
  `feeder_impact_timestamp` TIMESTAMP COMMENT 'Date and time when this specific feeder was impacted during the switching operation execution. Used for precise sequencing and audit trail.',
  `feeder_role` STRING COMMENT 'The operational role this feeder plays in the switching operation (e.g., SOURCE feeder losing load, TARGET feeder receiving load, ISOLATION feeder being isolated, BACKUP feeder providing alternate path).',
  `isolation_status` STRING COMMENT 'Current isolation state of this feeder within the context of this switching order. Tracks whether the feeder is isolated, energized, or in transition.',
  `load_transferred_mw` DECIMAL(10,3) COMMENT 'Amount of load in megawatts transferred to or from this specific feeder as part of the switching operation. This is feeder-specific and differs from the total load_transfer_mw on the switching order.',
  `outage_duration_minutes` INT COMMENT 'Duration in minutes that this feeder experienced outage as part of the switching operation. Zero if switching was performed without interruption. Used for reliability metrics (SAIDI/SAIFI).',
  `post_switch_load_mw` DECIMAL(10,3) COMMENT 'Load on this feeder after the switching operation completed. Used to verify successful load transfer and network rebalancing.',
  `pre_switch_load_mw` DECIMAL(10,3) COMMENT 'Load on this feeder immediately before the switching operation began. Used for operational planning and post-operation analysis.',
  `restoration_priority` INT COMMENT 'Priority ranking for restoring this feeder if the switching operation involves outage restoration. Lower numbers indicate higher priority based on customer criticality and load importance.',
  `switching_sequence_number` INT COMMENT 'The order in which this feeder is addressed within the multi-feeder switching operation. Critical for coordinating the sequence of switching steps across multiple feeders.',
  `switching_steps_for_feeder` INT COMMENT 'Number of individual switching steps in the overall order that specifically target devices on this feeder. Subset of total_switching_steps on the order.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_distribution_switching_order_feeder_impact` PRIMARY KEY (`switching_order_feeder_impact_id`)
)
USING DELTA
COMMENT 'This association product represents the operational impact relationship between distribution switching orders and feeders. It captures the specific role, sequence, and operational parameters for each feeder involved in a multi-feeder switching operation. Each record links one distribution switching order to one feeder with attributes that exist only in the context of this switching operation, including load transfer amounts, customer impact counts, isolation status, and restoration priority.. Existence Justification: In utility distribution operations, switching orders routinely coordinate actions across multiple feeders to perform load transfers, isolations, and network reconfigurations. A single switching order can impact 3-5 feeders simultaneously (e.g., isolating one feeder, transferring load to two backup feeders, and energizing a fourth). Conversely, each feeder participates in dozens of switching orders over its operational lifetime for maintenance, emergency response, and load balancing. The relationship carries substantial operational data including load transfer amounts, customer impacts, sequence coordination, and feeder-specific roles. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SwitchingOrderFeederImpact',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.switching_order_feeder_impact'
);

-- FeederZoneAssignment  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `distribution`.`feeder_zone_assignment` (
  `feeder_zone_assignment_id` BIGINT NOT NULL COMMENT 'Unique identifier for this feeder-zone assignment record. Primary key.',
  `feeder_id` BIGINT COMMENT 'Foreign key linking to the distribution feeder that serves this load zone assignment.',
  `load_zone_id` BIGINT COMMENT 'Foreign key linking to the load zone served by this feeder assignment.',
  `switching_device_id` BIGINT COMMENT 'Identifier of the sectionalizing switch, recloser, or breaker that controls this feeder-zone connection. Used by ADMS for automated switching operations during FLISR and VVO dispatch.',
  `assignment_status` STRING COMMENT 'Current operational status of this feeder-zone assignment. Active assignments are in service, Planned assignments are scheduled for future network reconfigurations, Temporary assignments are used during maintenance or emergency switching operations.',
  `assignment_type` STRING COMMENT 'Classification of the assignment role. Primary indicates normal serving configuration, Backup indicates redundancy path, Emergency indicates temporary restoration configuration, Seasonal indicates load-dependent switching schemes.',
  `circuit_miles_in_zone` DECIMAL(10,3) COMMENT 'Total length of feeder circuit infrastructure (mainline and laterals) physically located within this load zone boundary, measured in miles. Used for maintenance planning and reliability analysis.',
  `created_date` TIMESTAMP COMMENT 'Timestamp when this assignment record was created in the system.',
  `customer_count_in_zone` INT COMMENT 'Number of customer premises served by this specific feeder within this load zone. Used for reliability metrics (SAIDI/SAIFI) calculation and outage impact assessment.',
  `effective_date` DATE COMMENT 'Date when this feeder-zone assignment became active in the distribution network topology. Used for historical tracking of network reconfigurations.',
  `expiration_date` DATE COMMENT 'Date when this feeder-zone assignment was deactivated or reconfigured. Null for currently active assignments. Used for historical analysis of network topology changes.',
  `last_modified_by` STRING COMMENT 'User or system identifier that last modified this assignment record.',
  `last_modified_date` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this assignment record.',
  `load_allocation_percentage` DECIMAL(5,2) COMMENT 'Percentage of the feeder\'s total load capacity allocated to serving this specific load zone. Used for load balancing calculations and capacity planning. Sum of all allocations for a feeder across zones should approach 100%.',
  `normally_open_flag` BOOLEAN COMMENT 'Indicates whether the switching device controlling this assignment is normally open (tie point) or normally closed (radial feed). Used for network topology analysis and switching sequence planning.',
  `priority_rank` INT COMMENT 'Priority ranking of this feeder for serving the load zone, used during outage restoration and FLISR automation. Rank 1 indicates primary feeder, higher numbers indicate backup feeders for redundancy.',
  `created_by` STRING COMMENT 'User or system identifier that created this assignment record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_distribution_feeder_zone_assignment` PRIMARY KEY (`feeder_zone_assignment_id`)
)
USING DELTA
COMMENT 'This association product represents the operational assignment between distribution feeders and load zones. It captures the many-to-many relationship where a single feeder can serve multiple load zones (feeder branches across zone boundaries) and a single load zone can be served by multiple feeders (for redundancy, load balancing, and reliability). Each record represents an active or historical assignment with load allocation percentages, circuit topology data, and customer distribution metrics used by DMS/ADMS for volt-VAR optimization dispatch and FLISR automation decisions.. Existence Justification: In utility distribution operations, feeders routinely serve multiple load zones as their circuits branch across geographic boundaries, and load zones are deliberately served by multiple feeders for redundancy, load balancing, and reliability. Distribution planners actively manage these assignments through switching operations, network reconfigurations, and seasonal load transfers. This is a core operational relationship tracked in DMS/ADMS systems for real-time control decisions. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'FeederZoneAssignment',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.feeder_zone_assignment'
);

-- SubstationAuditCoverage  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `distribution`.`substation_audit_coverage` (
  `substation_audit_coverage_id` BIGINT NOT NULL COMMENT 'Unique identifier for this substation audit coverage record. Primary key.',
  `audit_id` BIGINT COMMENT 'Foreign key linking to the compliance audit that examined this substation',
  `distribution_substation_id` BIGINT COMMENT 'Foreign key to the distribution substation examined in this audit',
  `substation_distribution_substation_id` BIGINT COMMENT 'Foreign key linking to the distribution substation that was examined in this audit',
  `audit_result` STRING COMMENT 'Overall audit result for this substation within this audit: Compliant (no violations), Non-Compliant (violations found), Observation (improvement recommended but not violation), Not Applicable (substation not subject to this audit standard)',
  `auditor_notes` STRING COMMENT 'Free-text notes from the auditor regarding this specific substation examination, including observations, context, or follow-up items',
  `corrective_action_completed_date` DATE COMMENT 'Actual date when corrective actions for this substation were completed and submitted for verification',
  `corrective_action_due_date` DATE COMMENT 'Deadline date by which corrective actions for this substation must be completed per the audit finding requirements',
  `corrective_action_status` STRING COMMENT 'Current status of corrective actions for findings at this substation: Not Required, Planned, In Progress, Completed, Verified (by auditor), Overdue',
  `corrective_actions_required` BOOLEAN COMMENT 'Indicates whether corrective actions are required for this substation as a result of this audit (true if findings require remediation, false if compliant or observation only)',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this substation audit coverage record was created in the system',
  `findings_count` INT COMMENT 'Number of audit findings, violations, or observations identified for this specific substation during this audit',
  `last_audit_date` DATE COMMENT 'Date when this substation was last examined as part of this audit (field visit date or records review completion date)',
  `scope_description` STRING COMMENT 'Detailed description of what aspects of this specific substation were examined during the audit (e.g., NERC CIP physical security controls, transformer maintenance records, SCADA cybersecurity, environmental compliance)',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this substation audit coverage record was last updated',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_distribution_substation_audit_coverage` PRIMARY KEY (`substation_audit_coverage_id`)
)
USING DELTA
COMMENT 'This association product represents the audit coverage relationship between distribution substations and compliance audits. It captures which substations were included in which audits, the scope of examination for each substation, findings specific to that substation within the audit, and corrective action status. Each record links one distribution substation to one audit with attributes that exist only in the context of this specific substation-audit examination.. Existence Justification: In energy utilities compliance operations, a single audit (NERC CIP, PUC, EPA) routinely examines multiple distribution substations across the service territory, and each substation is subject to multiple audits over time from different regulatory bodies covering different compliance domains. The business actively manages audit coverage planning, tracks findings per substation per audit, and monitors corrective action status for each substation-audit combination. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SubstationAuditCoverage',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.substation_audit_coverage'
);

-- SubstationScenarioPlan  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `distribution`.`substation_scenario_plan` (
  `substation_scenario_plan_id` BIGINT NOT NULL COMMENT 'Unique identifier for this substation-scenario planning record. Primary key.',
  `distribution_substation_id` BIGINT COMMENT 'Foreign key linking to the distribution substation being planned for in this scenario',
  `irp_scenario_id` BIGINT COMMENT 'Foreign key linking to the IRP scenario containing this substation plan',
  `capacity_utilization_pct` DECIMAL(5,2) COMMENT 'Forecasted capacity utilization percentage for this substation in this scenario year (load_forecast_mw / total_capacity_mva). Used to identify capacity constraints and trigger investment decisions.',
  `capital_expenditure_usd` DECIMAL(15,2) COMMENT 'Estimated capital expenditure in US dollars for substation upgrades or expansions in this scenario year. Used for NPV analysis and rate case planning.',
  `created_date` TIMESTAMP COMMENT 'Timestamp when this substation scenario plan record was created in the IRP planning system.',
  `deferral_opportunity` STRING COMMENT 'Identified non-wires alternative or demand-side solution that could defer traditional substation investment in this scenario (e.g., \'Battery storage\', \'Demand response program\', \'Energy efficiency\', \'None\').',
  `investment_trigger` STRING COMMENT 'Business rule or condition that triggers capital investment in this scenario (e.g., \'Utilization exceeds 80%\', \'Load growth exceeds 5% annually\', \'Reliability standard violation\', \'None\').',
  `last_updated_date` TIMESTAMP COMMENT 'Timestamp when this substation scenario plan record was last modified by planning staff.',
  `load_forecast_mw` DECIMAL(10,2) COMMENT 'Forecasted peak load in megawatts (MW) for this substation in this scenario year, reflecting scenario-specific load growth assumptions (electrification, DER penetration, demand response).',
  `plan_status` STRING COMMENT 'Lifecycle status of this substation plan within the scenario: draft (initial planning), under_review (stakeholder review), approved (included in final IRP), deferred (postponed to later year), cancelled (no longer needed).',
  `planned_capacity_additions_mva` DECIMAL(10,2) COMMENT 'Planned transformer capacity additions or upgrades for this substation in this scenario year, measured in megavolt-amperes (MVA). Zero if no expansion planned.',
  `planned_transformer_upgrades` STRING COMMENT 'Description of planned transformer bank upgrades or replacements for this substation in this scenario (e.g., \'Add third 10MVA transformer\', \'Replace aging 33/11kV bank\', \'None\').',
  `planning_notes` STRING COMMENT 'Free-text notes from planning engineers regarding assumptions, constraints, or alternatives considered for this substation in this scenario.',
  `scenario_year` INT COMMENT 'Planning year within the IRP scenario horizon for which this substation plan applies (e.g., 2025, 2030, 2035). Allows year-by-year capacity planning.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_distribution_substation_scenario_plan` PRIMARY KEY (`substation_scenario_plan_id`)
)
USING DELTA
COMMENT 'This association product represents the planning relationship between distribution substations and IRP scenarios. It captures scenario-specific capacity expansion plans, upgrade schedules, and capital investment forecasts for each substation across different planning futures (base case, high growth, accelerated decarbonization). Each record links one distribution substation to one IRP scenario with year-by-year planning data that exists only in the context of that specific scenario-substation combination. Enables comparison of substation investment needs across alternative futures for regulatory IRP filings.. Existence Justification: In IRP planning, each distribution substation can appear in multiple scenario plans (base case, high growth, accelerated decarbonization), and each IRP scenario models capacity expansion needs for multiple substations across the service territory. Planning teams actively create and manage scenario-specific substation investment plans with year-by-year capacity additions, capital expenditure forecasts, and load projections that vary by scenario assumptions. This is an operational planning relationship, not an analytical correlation. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SubstationScenarioPlan',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.substation_scenario_plan'
);

-- SwitchingOrderMaterialRequisition  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `distribution`.`switching_order_material_requisition` (
  `switching_order_material_requisition_id` BIGINT NOT NULL COMMENT 'Unique identifier for this switching order material requisition record. Primary key.',
  `distribution_switching_order_id` BIGINT COMMENT 'Foreign key linking to the distribution switching order that requires this material',
  `issued_by_employee_id` BIGINT COMMENT 'Foreign key reference to the warehouse or inventory employee who issued this material to the field crew. Used for accountability and audit trail.',
  `material_master_id` BIGINT COMMENT 'Foreign key linking to the material master record for the required material',
  `received_by_employee_id` BIGINT COMMENT 'Foreign key reference to the field crew member who received this material for the switching order. Used for chain of custody tracking.',
  `issue_timestamp` TIMESTAMP COMMENT 'Date and time when this material was issued from inventory for this switching order. Used for inventory transaction tracking and crew logistics.',
  `quantity_issued` DECIMAL(13,3) COMMENT 'Actual quantity of this material issued from inventory to the crew for this switching order. May differ from quantity required due to availability or field adjustments.',
  `quantity_required` DECIMAL(13,3) COMMENT 'Planned quantity of this material required for the switching order, expressed in the material\'s base unit of measure. Determined during switching order planning phase.',
  `requisition_status` STRING COMMENT 'Current lifecycle status of this material requisition. Tracks progression from planning through issuance to return or consumption.',
  `reservation_number` STRING COMMENT 'Inventory reservation identifier linking this requisition to the inventory management system. Used to reserve materials prior to physical issuance.',
  `return_quantity` DECIMAL(13,3) COMMENT 'Quantity of this material returned to inventory after switching order completion. Unused materials are returned to maintain accurate inventory levels.',
  `return_timestamp` TIMESTAMP COMMENT 'Date and time when unused material was returned to inventory after switching order completion. Null if no return occurred.',
  `staging_location` STRING COMMENT 'Physical location where this material is staged for pickup by the field crew executing the switching order. May be a warehouse, yard, or field staging area identifier.',
  `unit_of_measure` STRING COMMENT 'Unit of measure for quantities in this requisition record. Typically matches the material\'s base unit of measure but may differ for operational convenience.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_distribution_switching_order_material_requisition` PRIMARY KEY (`switching_order_material_requisition_id`)
)
USING DELTA
COMMENT 'This association product represents the material requisition relationship between distribution switching orders and materials. It captures the specific materials required for each switching operation, including quantities planned, quantities issued from inventory, staging locations, and material returns. Each record links one switching order to one material with attributes that exist only in the context of this specific requisition.. Existence Justification: In utility distribution operations, switching orders routinely require multiple different materials (poles, transformers, conductors, insulators, hardware, protective equipment), and the same materials are used across many different switching orders over time. The business actively manages material requisitions as operational records, tracking planned quantities, actual issuance from inventory, staging locations for crew pickup, and returns of unused materials after job completion. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SwitchingOrderMaterialRequisition',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.switching_order_material_requisition'
);

-- FeederCrewAssignment  <<CIM Assignment : close>>
CREATE TABLE IF NOT EXISTS `distribution`.`feeder_crew_assignment` (
  `feeder_crew_assignment_id` BIGINT NOT NULL COMMENT 'Unique identifier for this feeder-crew assignment record. Primary key.',
  `crew_id` BIGINT COMMENT 'Foreign key linking to the field crew assigned to this feeder for maintenance, inspection, or restoration work.',
  `employee_id` BIGINT COMMENT 'Identifier of the user or system process that created this assignment record. Used for audit trail and accountability.',
  `feeder_id` BIGINT COMMENT 'Foreign key linking to the distribution feeder being maintained or served by this crew assignment.',
  `last_modified_by_user_employee_id` BIGINT COMMENT 'Identifier of the user or system process that last modified this assignment record. Used for audit trail.',
  `assignment_end_date` DATE COMMENT 'Date when this crew assignment to the feeder ended or is planned to end. Null for active assignments. Used to track assignment lifecycle and crew rotation history.',
  `assignment_start_date` DATE COMMENT 'Date when this crew assignment to the feeder became effective. Used to track assignment history and calculate crew tenure on feeder for knowledge continuity.',
  `assignment_status` STRING COMMENT 'Current lifecycle status of the crew assignment. ACTIVE assignments are operational and used for dispatch. SUSPENDED assignments are temporarily inactive (crew on mutual aid deployment, equipment out of service). ENDED assignments are historical. PLANNED assignments are future-dated for crew rotation planning.',
  `assignment_type` STRING COMMENT 'Classification of the crew\'s responsibility for this feeder. PRIMARY_MAINTENANCE crews handle routine maintenance and are first responders for outages. BACKUP crews provide coverage during peak periods or when primary crew is unavailable. VEGETATION_MANAGEMENT crews handle tree trimming cycles. EMERGENCY_RESTORATION crews are assigned during storm events. Determines dispatch priority and work order routing in OMS/ADMS.',
  `average_response_time_minutes` INT COMMENT 'Historical average time in minutes for this crew to respond to outage calls on this specific feeder, measured from dispatch to arrival. Used for restoration time estimation and crew assignment optimization. Varies by crew-feeder combination due to travel distance and familiarity with feeder topology.',
  `coverage_area_description` STRING COMMENT 'Textual description of the geographic coverage area or feeder segments this crew is responsible for within the feeder territory. May reference mile markers, geographic boundaries, or circuit sections. Used when a feeder spans multiple crew territories or when specialized crews handle specific segments (e.g., underground vs overhead sections).',
  `created_date` TIMESTAMP COMMENT 'Timestamp when this assignment record was created in the system. Used for audit trail and data lineage.',
  `dispatch_priority_rank` INT COMMENT 'Numeric ranking for dispatch priority when multiple crews are assigned to the same feeder. Lower numbers indicate higher priority. Used by OMS/ADMS to route emergency work orders to the most appropriate crew based on assignment type, crew location, and current workload.',
  `last_modified_date` TIMESTAMP COMMENT 'Timestamp when this assignment record was last updated. Used for change tracking and data freshness assessment.',
  `last_work_order_date` DATE COMMENT 'Date of the most recent work order completed by this crew on this feeder. Used to track crew activity levels, identify underutilized assignments, and ensure regular crew familiarity with feeder infrastructure.',
  `primary_responsibility_flag` BOOLEAN COMMENT 'Indicates whether this crew has primary operational responsibility for the feeder (true) or is a backup/secondary assignment (false). Only one crew should have primary responsibility for a feeder at any time for a given assignment type. Used for dispatch routing and accountability.',
  `work_order_count_ytd` INT COMMENT 'Total number of work orders completed by this crew on this feeder in the current calendar year. Used for workload balancing, crew performance assessment, and assignment optimization.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_distribution_feeder_crew_assignment` PRIMARY KEY (`feeder_crew_assignment_id`)
)
USING DELTA
COMMENT 'This association product represents the operational assignment of field crews to distribution feeders for maintenance, inspection, vegetation management, and emergency restoration work. It captures the assignment lifecycle, responsibility type (primary maintenance crew, backup crew, vegetation management crew), coverage area within the feeder territory, and assignment dates. Each record links one feeder to one crew with attributes that exist only in the context of this assignment relationship. Critical for dispatch optimization in OMS/ADMS, storm restoration planning, crew workload balancing, and regulatory compliance reporting (vegetation management cycles, inspection frequency).. Existence Justification: In energy utility distribution operations, feeders require maintenance, inspection, and emergency restoration services from multiple specialized crews (line crews for electrical work, vegetation management crews for tree trimming, cable crews for underground sections), and each crew is assigned to multiple feeders within their service territory. The business actively manages these assignments with specific responsibility types (primary/backup), coverage areas, and assignment dates to optimize dispatch routing in OMS/ADMS, ensure regulatory compliance (vegetation management cycles), and coordinate storm restoration efforts. This is an operational assignment process, not an analytical correlation. | CMM: CIM Assignment (close), IEC61968::InfWork.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'FeederCrewAssignment',
  'cmm.cim.class' = 'Assignment',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfWork',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-6',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.distribution.feeder_crew_assignment'
);

-- ========= FOREIGN KEYS within distribution (70) =========
ALTER TABLE `distribution`.`feeder` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_backup_feeder_id`;
ALTER TABLE `distribution`.`feeder` ADD CONSTRAINT `fk_distribution_feeder_backup_feeder_id` FOREIGN KEY (`backup_feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`feeder` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_feeder_distribution_substation_id`;
ALTER TABLE `distribution`.`feeder` ADD CONSTRAINT `fk_distribution_feeder_feeder_distribution_substation_id` FOREIGN KEY (`feeder_distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `distribution`.`feeder` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_to_distribution_substation_id`;
ALTER TABLE `distribution`.`feeder` ADD CONSTRAINT `fk_distribution_feeder_to_distribution_substation_id` FOREIGN KEY (`to_distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `distribution`.`transformer` DROP CONSTRAINT IF EXISTS `fk_distribution_transformer_distribution_substation_id`;
ALTER TABLE `distribution`.`transformer` ADD CONSTRAINT `fk_distribution_transformer_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `distribution`.`transformer` DROP CONSTRAINT IF EXISTS `fk_distribution_transformer_feeder_id`;
ALTER TABLE `distribution`.`transformer` ADD CONSTRAINT `fk_distribution_transformer_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`transformer` DROP CONSTRAINT IF EXISTS `fk_distribution_transformer_service_territory_id`;
ALTER TABLE `distribution`.`transformer` ADD CONSTRAINT `fk_distribution_transformer_service_territory_id` FOREIGN KEY (`service_territory_id`) REFERENCES `distribution`.`service_territory` (`service_territory_id`);

ALTER TABLE `distribution`.`transformer` DROP CONSTRAINT IF EXISTS `fk_distribution_transformer_transformer_feeder_id`;
ALTER TABLE `distribution`.`transformer` ADD CONSTRAINT `fk_distribution_transformer_transformer_feeder_id` FOREIGN KEY (`transformer_feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`transformer` DROP CONSTRAINT IF EXISTS `fk_distribution_transformer_transformer_on_feeder`;
ALTER TABLE `distribution`.`transformer` ADD CONSTRAINT `fk_distribution_transformer_transformer_on_feeder` FOREIGN KEY (`transformer_on_feeder`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`sectionalizing_device` DROP CONSTRAINT IF EXISTS `fk_distribution_sectionalizing_device_distribution_substation_id`;
ALTER TABLE `distribution`.`sectionalizing_device` ADD CONSTRAINT `fk_distribution_sectionalizing_device_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `distribution`.`sectionalizing_device` DROP CONSTRAINT IF EXISTS `fk_distribution_sectionalizing_device_feeder_id`;
ALTER TABLE `distribution`.`sectionalizing_device` ADD CONSTRAINT `fk_distribution_sectionalizing_device_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`sectionalizing_device` DROP CONSTRAINT IF EXISTS `fk_distribution_sectionalizing_device_sectionalizing_feeder_id`;
ALTER TABLE `distribution`.`sectionalizing_device` ADD CONSTRAINT `fk_distribution_sectionalizing_device_sectionalizing_feeder_id` FOREIGN KEY (`sectionalizing_feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`service_drop` DROP CONSTRAINT IF EXISTS `fk_distribution_service_drop_from_transformer_id`;
ALTER TABLE `distribution`.`service_drop` ADD CONSTRAINT `fk_distribution_service_drop_from_transformer_id` FOREIGN KEY (`from_transformer_id`) REFERENCES `distribution`.`transformer` (`transformer_id`);

ALTER TABLE `distribution`.`service_drop` DROP CONSTRAINT IF EXISTS `fk_distribution_service_drop_network_segment_id`;
ALTER TABLE `distribution`.`service_drop` ADD CONSTRAINT `fk_distribution_service_drop_network_segment_id` FOREIGN KEY (`network_segment_id`) REFERENCES `distribution`.`network_segment` (`network_segment_id`);

ALTER TABLE `distribution`.`service_drop` DROP CONSTRAINT IF EXISTS `fk_distribution_service_drop_service_territory_id`;
ALTER TABLE `distribution`.`service_drop` ADD CONSTRAINT `fk_distribution_service_drop_service_territory_id` FOREIGN KEY (`service_territory_id`) REFERENCES `distribution`.`service_territory` (`service_territory_id`);

ALTER TABLE `distribution`.`service_drop` DROP CONSTRAINT IF EXISTS `fk_distribution_service_drop_service_transformer_id`;
ALTER TABLE `distribution`.`service_drop` ADD CONSTRAINT `fk_distribution_service_drop_service_transformer_id` FOREIGN KEY (`service_transformer_id`) REFERENCES `distribution`.`transformer` (`transformer_id`);

ALTER TABLE `distribution`.`service_drop` DROP CONSTRAINT IF EXISTS `fk_distribution_service_drop_transformer_id`;
ALTER TABLE `distribution`.`service_drop` ADD CONSTRAINT `fk_distribution_service_drop_transformer_id` FOREIGN KEY (`transformer_id`) REFERENCES `distribution`.`transformer` (`transformer_id`);

ALTER TABLE `distribution`.`network_segment` DROP CONSTRAINT IF EXISTS `fk_distribution_network_segment_distribution_substation_id`;
ALTER TABLE `distribution`.`network_segment` ADD CONSTRAINT `fk_distribution_network_segment_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `distribution`.`network_segment` DROP CONSTRAINT IF EXISTS `fk_distribution_network_segment_feeder_id`;
ALTER TABLE `distribution`.`network_segment` ADD CONSTRAINT `fk_distribution_network_segment_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`network_segment` DROP CONSTRAINT IF EXISTS `fk_distribution_network_segment_load_zone_id`;
ALTER TABLE `distribution`.`network_segment` ADD CONSTRAINT `fk_distribution_network_segment_load_zone_id` FOREIGN KEY (`load_zone_id`) REFERENCES `distribution`.`load_zone` (`load_zone_id`);

ALTER TABLE `distribution`.`network_segment` DROP CONSTRAINT IF EXISTS `fk_distribution_network_segment_network_feeder_id`;
ALTER TABLE `distribution`.`network_segment` ADD CONSTRAINT `fk_distribution_network_segment_network_feeder_id` FOREIGN KEY (`network_feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`network_segment` DROP CONSTRAINT IF EXISTS `fk_distribution_network_segment_network_segment_belongs_to_feeder`;
ALTER TABLE `distribution`.`network_segment` ADD CONSTRAINT `fk_distribution_network_segment_network_segment_belongs_to_feeder` FOREIGN KEY (`network_segment_belongs_to_feeder`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`network_segment` DROP CONSTRAINT IF EXISTS `fk_distribution_network_segment_sectionalizing_device_id`;
ALTER TABLE `distribution`.`network_segment` ADD CONSTRAINT `fk_distribution_network_segment_sectionalizing_device_id` FOREIGN KEY (`sectionalizing_device_id`) REFERENCES `distribution`.`sectionalizing_device` (`sectionalizing_device_id`);

ALTER TABLE `distribution`.`load_zone` DROP CONSTRAINT IF EXISTS `fk_distribution_load_zone_distribution_substation_id`;
ALTER TABLE `distribution`.`load_zone` ADD CONSTRAINT `fk_distribution_load_zone_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `distribution`.`load_zone` DROP CONSTRAINT IF EXISTS `fk_distribution_load_zone_feeder_id`;
ALTER TABLE `distribution`.`load_zone` ADD CONSTRAINT `fk_distribution_load_zone_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`load_zone` DROP CONSTRAINT IF EXISTS `fk_distribution_load_zone_load_feeder_id`;
ALTER TABLE `distribution`.`load_zone` ADD CONSTRAINT `fk_distribution_load_zone_load_feeder_id` FOREIGN KEY (`load_feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`load_zone` DROP CONSTRAINT IF EXISTS `fk_distribution_load_zone_load_zone_includes_feeder`;
ALTER TABLE `distribution`.`load_zone` ADD CONSTRAINT `fk_distribution_load_zone_load_zone_includes_feeder` FOREIGN KEY (`load_zone_includes_feeder`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`distribution_switching_step` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_step_distribution_sectionalizing_device_id`;
ALTER TABLE `distribution`.`distribution_switching_step` ADD CONSTRAINT `fk_distribution_distribution_switching_step_distribution_sectionalizing_device_id` FOREIGN KEY (`distribution_sectionalizing_device_id`) REFERENCES `distribution`.`sectionalizing_device` (`sectionalizing_device_id`);

ALTER TABLE `distribution`.`distribution_switching_step` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_step_distribution_substation_id`;
ALTER TABLE `distribution`.`distribution_switching_step` ADD CONSTRAINT `fk_distribution_distribution_switching_step_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `distribution`.`distribution_switching_step` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_step_distribution_switching_order_id`;
ALTER TABLE `distribution`.`distribution_switching_step` ADD CONSTRAINT `fk_distribution_distribution_switching_step_distribution_switching_order_id` FOREIGN KEY (`distribution_switching_order_id`) REFERENCES `distribution`.`distribution_switching_order` (`distribution_switching_order_id`);

ALTER TABLE `distribution`.`distribution_switching_step` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_step_feeder_id`;
ALTER TABLE `distribution`.`distribution_switching_step` ADD CONSTRAINT `fk_distribution_distribution_switching_step_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`distribution_switching_step` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_step_primary_distribution_switching_order_id`;
ALTER TABLE `distribution`.`distribution_switching_step` ADD CONSTRAINT `fk_distribution_distribution_switching_step_primary_distribution_switching_order_id` FOREIGN KEY (`primary_distribution_switching_order_id`) REFERENCES `distribution`.`distribution_switching_order` (`distribution_switching_order_id`);

ALTER TABLE `distribution`.`distribution_switching_step` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_step_sectionalizing_device_id`;
ALTER TABLE `distribution`.`distribution_switching_step` ADD CONSTRAINT `fk_distribution_distribution_switching_step_sectionalizing_device_id` FOREIGN KEY (`sectionalizing_device_id`) REFERENCES `distribution`.`sectionalizing_device` (`sectionalizing_device_id`);

ALTER TABLE `distribution`.`distribution_flisr_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_flisr_event_distribution_network_segment_id`;
ALTER TABLE `distribution`.`distribution_flisr_event` ADD CONSTRAINT `fk_distribution_distribution_flisr_event_distribution_network_segment_id` FOREIGN KEY (`distribution_network_segment_id`) REFERENCES `distribution`.`network_segment` (`network_segment_id`);

ALTER TABLE `distribution`.`distribution_flisr_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_flisr_event_distribution_substation_id`;
ALTER TABLE `distribution`.`distribution_flisr_event` ADD CONSTRAINT `fk_distribution_distribution_flisr_event_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `distribution`.`distribution_flisr_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_flisr_event_feeder_id`;
ALTER TABLE `distribution`.`distribution_flisr_event` ADD CONSTRAINT `fk_distribution_distribution_flisr_event_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`distribution_flisr_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_flisr_event_network_segment_id`;
ALTER TABLE `distribution`.`distribution_flisr_event` ADD CONSTRAINT `fk_distribution_distribution_flisr_event_network_segment_id` FOREIGN KEY (`network_segment_id`) REFERENCES `distribution`.`network_segment` (`network_segment_id`);

ALTER TABLE `distribution`.`volt_var_action` DROP CONSTRAINT IF EXISTS `fk_distribution_volt_var_action_distribution_substation_id`;
ALTER TABLE `distribution`.`volt_var_action` ADD CONSTRAINT `fk_distribution_volt_var_action_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `distribution`.`volt_var_action` DROP CONSTRAINT IF EXISTS `fk_distribution_volt_var_action_feeder_id`;
ALTER TABLE `distribution`.`volt_var_action` ADD CONSTRAINT `fk_distribution_volt_var_action_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`volt_var_action` DROP CONSTRAINT IF EXISTS `fk_distribution_volt_var_action_load_zone_id`;
ALTER TABLE `distribution`.`volt_var_action` ADD CONSTRAINT `fk_distribution_volt_var_action_load_zone_id` FOREIGN KEY (`load_zone_id`) REFERENCES `distribution`.`load_zone` (`load_zone_id`);

ALTER TABLE `distribution`.`volt_var_action` DROP CONSTRAINT IF EXISTS `fk_distribution_volt_var_action_volt_load_zone_id`;
ALTER TABLE `distribution`.`volt_var_action` ADD CONSTRAINT `fk_distribution_volt_var_action_volt_load_zone_id` FOREIGN KEY (`volt_load_zone_id`) REFERENCES `distribution`.`load_zone` (`load_zone_id`);

ALTER TABLE `distribution`.`volt_var_action` DROP CONSTRAINT IF EXISTS `fk_distribution_volt_var_action_volt_var_device_id`;
ALTER TABLE `distribution`.`volt_var_action` ADD CONSTRAINT `fk_distribution_volt_var_action_volt_var_device_id` FOREIGN KEY (`volt_var_device_id`) REFERENCES `distribution`.`volt_var_device` (`volt_var_device_id`);

ALTER TABLE `distribution`.`volt_var_action` DROP CONSTRAINT IF EXISTS `fk_distribution_volt_var_action_volt_vvo_action_in_zone`;
ALTER TABLE `distribution`.`volt_var_action` ADD CONSTRAINT `fk_distribution_volt_var_action_volt_vvo_action_in_zone` FOREIGN KEY (`volt_vvo_action_in_zone`) REFERENCES `distribution`.`load_zone` (`load_zone_id`);

ALTER TABLE `distribution`.`volt_var_action` DROP CONSTRAINT IF EXISTS `fk_distribution_volt_var_action_volt_vvo_action_targets_zone`;
ALTER TABLE `distribution`.`volt_var_action` ADD CONSTRAINT `fk_distribution_volt_var_action_volt_vvo_action_targets_zone` FOREIGN KEY (`volt_vvo_action_targets_zone`) REFERENCES `distribution`.`load_zone` (`load_zone_id`);

ALTER TABLE `distribution`.`capacitor_bank` DROP CONSTRAINT IF EXISTS `fk_distribution_capacitor_bank_distribution_substation_id`;
ALTER TABLE `distribution`.`capacitor_bank` ADD CONSTRAINT `fk_distribution_capacitor_bank_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `distribution`.`capacitor_bank` DROP CONSTRAINT IF EXISTS `fk_distribution_capacitor_bank_feeder_id`;
ALTER TABLE `distribution`.`capacitor_bank` ADD CONSTRAINT `fk_distribution_capacitor_bank_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`volt_var_device` DROP CONSTRAINT IF EXISTS `fk_distribution_volt_var_device_distribution_substation_id`;
ALTER TABLE `distribution`.`volt_var_device` ADD CONSTRAINT `fk_distribution_volt_var_device_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `distribution`.`volt_var_device` DROP CONSTRAINT IF EXISTS `fk_distribution_volt_var_device_feeder_id`;
ALTER TABLE `distribution`.`volt_var_device` ADD CONSTRAINT `fk_distribution_volt_var_device_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`distribution_reliability_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_reliability_event_distribution_substation_id`;
ALTER TABLE `distribution`.`distribution_reliability_event` ADD CONSTRAINT `fk_distribution_distribution_reliability_event_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `distribution`.`distribution_reliability_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_reliability_event_feeder_id`;
ALTER TABLE `distribution`.`distribution_reliability_event` ADD CONSTRAINT `fk_distribution_distribution_reliability_event_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`distribution_reliability_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_reliability_event_network_segment_id`;
ALTER TABLE `distribution`.`distribution_reliability_event` ADD CONSTRAINT `fk_distribution_distribution_reliability_event_network_segment_id` FOREIGN KEY (`network_segment_id`) REFERENCES `distribution`.`network_segment` (`network_segment_id`);

ALTER TABLE `distribution`.`distribution_reliability_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_reliability_event_sectionalizing_device_id`;
ALTER TABLE `distribution`.`distribution_reliability_event` ADD CONSTRAINT `fk_distribution_distribution_reliability_event_sectionalizing_device_id` FOREIGN KEY (`sectionalizing_device_id`) REFERENCES `distribution`.`sectionalizing_device` (`sectionalizing_device_id`);

ALTER TABLE `distribution`.`feeder_load_reading` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_load_reading_distribution_flisr_event_id`;
ALTER TABLE `distribution`.`feeder_load_reading` ADD CONSTRAINT `fk_distribution_feeder_load_reading_distribution_flisr_event_id` FOREIGN KEY (`distribution_flisr_event_id`) REFERENCES `distribution`.`distribution_flisr_event` (`distribution_flisr_event_id`);

ALTER TABLE `distribution`.`feeder_load_reading` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_load_reading_primary_feeder_id`;
ALTER TABLE `distribution`.`feeder_load_reading` ADD CONSTRAINT `fk_distribution_feeder_load_reading_primary_feeder_id` FOREIGN KEY (`primary_feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`feeder_load_reading` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_load_reading_tertiary_feeder_id`;
ALTER TABLE `distribution`.`feeder_load_reading` ADD CONSTRAINT `fk_distribution_feeder_load_reading_tertiary_feeder_id` FOREIGN KEY (`tertiary_feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`der_interconnection_point` DROP CONSTRAINT IF EXISTS `fk_distribution_der_interconnection_point_der_network_segment_id`;
ALTER TABLE `distribution`.`der_interconnection_point` ADD CONSTRAINT `fk_distribution_der_interconnection_point_der_network_segment_id` FOREIGN KEY (`der_network_segment_id`) REFERENCES `distribution`.`network_segment` (`network_segment_id`);

ALTER TABLE `distribution`.`der_interconnection_point` DROP CONSTRAINT IF EXISTS `fk_distribution_der_interconnection_point_distribution_substation_id`;
ALTER TABLE `distribution`.`der_interconnection_point` ADD CONSTRAINT `fk_distribution_der_interconnection_point_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `distribution`.`der_interconnection_point` DROP CONSTRAINT IF EXISTS `fk_distribution_der_interconnection_point_feeder_id`;
ALTER TABLE `distribution`.`der_interconnection_point` ADD CONSTRAINT `fk_distribution_der_interconnection_point_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`der_interconnection_point` DROP CONSTRAINT IF EXISTS `fk_distribution_der_interconnection_point_primary_feeder_id`;
ALTER TABLE `distribution`.`der_interconnection_point` ADD CONSTRAINT `fk_distribution_der_interconnection_point_primary_feeder_id` FOREIGN KEY (`primary_feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`der_interconnection_point` DROP CONSTRAINT IF EXISTS `fk_distribution_der_interconnection_point_primary_network_segment_id`;
ALTER TABLE `distribution`.`der_interconnection_point` ADD CONSTRAINT `fk_distribution_der_interconnection_point_primary_network_segment_id` FOREIGN KEY (`primary_network_segment_id`) REFERENCES `distribution`.`network_segment` (`network_segment_id`);

ALTER TABLE `distribution`.`der_interconnection_point` DROP CONSTRAINT IF EXISTS `fk_distribution_der_interconnection_point_tertiary_feeder_id`;
ALTER TABLE `distribution`.`der_interconnection_point` ADD CONSTRAINT `fk_distribution_der_interconnection_point_tertiary_feeder_id` FOREIGN KEY (`tertiary_feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`switching_order_feeder_impact` DROP CONSTRAINT IF EXISTS `fk_distribution_switching_order_feeder_impact_distribution_switching_order_id`;
ALTER TABLE `distribution`.`switching_order_feeder_impact` ADD CONSTRAINT `fk_distribution_switching_order_feeder_impact_distribution_switching_order_id` FOREIGN KEY (`distribution_switching_order_id`) REFERENCES `distribution`.`distribution_switching_order` (`distribution_switching_order_id`);

ALTER TABLE `distribution`.`switching_order_feeder_impact` DROP CONSTRAINT IF EXISTS `fk_distribution_switching_order_feeder_impact_feeder_id`;
ALTER TABLE `distribution`.`switching_order_feeder_impact` ADD CONSTRAINT `fk_distribution_switching_order_feeder_impact_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`feeder_zone_assignment` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_zone_assignment_feeder_id`;
ALTER TABLE `distribution`.`feeder_zone_assignment` ADD CONSTRAINT `fk_distribution_feeder_zone_assignment_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `distribution`.`feeder_zone_assignment` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_zone_assignment_load_zone_id`;
ALTER TABLE `distribution`.`feeder_zone_assignment` ADD CONSTRAINT `fk_distribution_feeder_zone_assignment_load_zone_id` FOREIGN KEY (`load_zone_id`) REFERENCES `distribution`.`load_zone` (`load_zone_id`);

ALTER TABLE `distribution`.`feeder_zone_assignment` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_zone_assignment_switching_device_id`;
ALTER TABLE `distribution`.`feeder_zone_assignment` ADD CONSTRAINT `fk_distribution_feeder_zone_assignment_switching_device_id` FOREIGN KEY (`switching_device_id`) REFERENCES `distribution`.`sectionalizing_device` (`sectionalizing_device_id`);

ALTER TABLE `distribution`.`substation_audit_coverage` DROP CONSTRAINT IF EXISTS `fk_distribution_substation_audit_coverage_distribution_substation_id`;
ALTER TABLE `distribution`.`substation_audit_coverage` ADD CONSTRAINT `fk_distribution_substation_audit_coverage_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `distribution`.`substation_audit_coverage` DROP CONSTRAINT IF EXISTS `fk_distribution_substation_audit_coverage_substation_distribution_substation_id`;
ALTER TABLE `distribution`.`substation_audit_coverage` ADD CONSTRAINT `fk_distribution_substation_audit_coverage_substation_distribution_substation_id` FOREIGN KEY (`substation_distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `distribution`.`substation_scenario_plan` DROP CONSTRAINT IF EXISTS `fk_distribution_substation_scenario_plan_distribution_substation_id`;
ALTER TABLE `distribution`.`substation_scenario_plan` ADD CONSTRAINT `fk_distribution_substation_scenario_plan_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `distribution`.`switching_order_material_requisition` DROP CONSTRAINT IF EXISTS `fk_distribution_switching_order_material_requisition_distribution_switching_order_id`;
ALTER TABLE `distribution`.`switching_order_material_requisition` ADD CONSTRAINT `fk_distribution_switching_order_material_requisition_distribution_switching_order_id` FOREIGN KEY (`distribution_switching_order_id`) REFERENCES `distribution`.`distribution_switching_order` (`distribution_switching_order_id`);

ALTER TABLE `distribution`.`feeder_crew_assignment` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_crew_assignment_feeder_id`;
ALTER TABLE `distribution`.`feeder_crew_assignment` ADD CONSTRAINT `fk_distribution_feeder_crew_assignment_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

