-- Utility CMM-aligned Canonical Data Model (Silver) v1.0.0 | source: Databricks lakehouse-industry-data-models energy_utilities v1 ECM | generated 2026-10-13
-- 10 | Subject area: grid | 32 tables | CIM packages: IEC61970::Meas; IEC61970::SCADA; IEC61970::ControlArea; IEC61970::Contingency; IEC61970::StateVariables; IEC61970::OperationalLimits; IEC61970::Topology
-- Standards: IEC 61970-452/456 (CGMES); IEC 60870-6 ICCP; IEEE C37.118; NERC BAL/TOP/IRO
-- Contents: tables (with PK + NOT NULL), then intra-subject-area foreign keys.
-- Unity Catalog PK/FK constraints are informational (NOT ENFORCED); NOT NULL is enforced.

USE CATALOG `utility_cmm_silver`;

-- ControlArea  <<CIM ControlArea : exact>>
CREATE TABLE IF NOT EXISTS `grid`.`control_area` (
  `control_area_id` BIGINT NOT NULL COMMENT 'Unique identifier for the balancing authority control area. Primary key for the control area master record.',
  `contact_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Control areas require designated responsible operator for NERC CPS1/CPS2 accountability and reliability coordinator communications. \'contact_name/phone/email\' denormalized fields should be FK to emplo',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Control areas are operational units that incur costs (staffing, SCADA, EMS maintenance). Finance tracks these costs by control area for FERC Form 1 reporting, rate case cost allocation, and operationa',
  `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Control areas represent distinct operational/geographic segments for P&L reporting. Utilities track revenue and costs by control area for segment reporting, regulatory jurisdiction analysis, and RTO/I',
  `program_id` BIGINT COMMENT 'Foreign key linking to compliance.program. Business justification: Each control area operates under a NERC Reliability Standards compliance program. This link tracks which compliance program governs the control area\'s operations, enabling audit scoping, program effec',
  `ace_tolerance_limit_mw` DECIMAL(10,2) COMMENT 'Maximum allowable Area Control Error in megawatts before corrective action is required, used for automatic generation control and NERC BAL-001 compliance.',
  `agc_mode` STRING COMMENT 'Current operating mode of the automatic generation control system for this control area. Valid values: automatic|manual|off|test.',
  `balancing_authority_name` STRING COMMENT 'Full legal name of the balancing authority organization operating this control area.',
  `contingency_analysis_enabled` BOOLEAN COMMENT 'Indicates whether real-time contingency analysis is active for N-1 and N-2 security assessment.',
  `control_area_code` STRING COMMENT 'Short alphanumeric code identifying the control area, typically 2-6 uppercase letters used in interchange scheduling and NERC reporting. Pattern: ^[A-Z]{2,6}$.',
  `cps1_target_percentage` DECIMAL(5,2) COMMENT 'Target CPS1 compliance percentage (minimum 100%) measuring the control area\'s contribution to interconnection frequency error over a rolling 12-month period.',
  `cps2_limit_percentage` DECIMAL(5,2) COMMENT 'CPS2 compliance limit percentage (minimum 90%) measuring the control area\'s ACE performance within defined bounds during 10-minute periods.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this control area master record was first created in the system.',
  `data_source_system` STRING COMMENT 'Name of the source system from which this control area record originated (e.g., EMS, SCADA, PI Historian, NERC Registry).',
  `disturbance_control_standard_mw` DECIMAL(10,2) COMMENT 'Most severe single contingency loss in megawatts that the control area must be prepared to recover from within 15 minutes, per NERC BAL-002 standard.',
  `effective_end_date` DATE COMMENT 'Date when this control area ceased operations or when the current configuration was superseded, null if currently active.',
  `effective_start_date` DATE COMMENT 'Date when this control area became operational or when the current configuration became effective.',
  `ems_system_name` STRING COMMENT 'Name or identifier of the primary EMS platform used for real-time monitoring and control of this control area.',
  `frequency_bias_setting_mw_per_hz` DECIMAL(10,2) COMMENT 'Frequency bias setting in MW per 0.1 Hz used in ACE calculation, representing the control area\'s expected response to frequency deviations.',
  `geographic_boundary_description` STRING COMMENT 'Textual description of the geographic and electrical boundaries defining the control area\'s operational footprint.',
  `installed_generation_capacity_mw` DECIMAL(10,2) COMMENT 'Total installed generation capacity in megawatts available within the control area boundaries.',
  `interconnection_name` STRING COMMENT 'Name of the major North American interconnection to which this control area belongs (Eastern, Western, Texas, or Quebec). Valid values: Eastern|Western|Texas|Quebec.',
  `l10_limit_mw` DECIMAL(10,2) COMMENT 'L10 parameter used in CPS1 (Control Performance Standard 1) calculation, representing the control area\'s frequency bias obligation in megawatts per 0.1 Hz.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this control area master record.',
  `nerc_region` STRING COMMENT 'NERC regional entity responsible for reliability oversight of this control area (e.g., WECC, NPCC, MRO, SERC, RF, TRE). Reference-value candidates: WECC|NPCC|MRO|SERC|RF|TRE|FRCC|SPP.',
  `nerc_registered_entity_code` STRING COMMENT 'Official NERC registry identifier for the balancing authority entity responsible for this control area. Pattern: ^[A-Z0-9]{4,10}$.',
  `nominal_frequency_hz` DECIMAL(5,2) COMMENT 'Target system frequency for this control area in Hertz, typically 60.00 Hz in North America or 50.00 Hz in other regions.',
  `non_spinning_reserve_mw` DECIMAL(10,2) COMMENT 'Amount of non-spinning (offline) reserve in megawatts that can be deployed within 10 minutes for contingency response.',
  `notes` STRING COMMENT 'Free-form text field for additional operational notes, configuration details, or special instructions related to this control area.',
  `operational_status` STRING COMMENT 'Current operational state of the control area in the grid operations environment. Valid values: active|inactive|suspended|testing|decommissioned.',
  `peak_load_mw` DECIMAL(10,2) COMMENT 'Historical or forecasted peak electrical load in megawatts for this control area, used for capacity planning and reserve calculations.',
  `pi_historian_tag_prefix` STRING COMMENT 'Standard tag prefix used in OSIsoft PI historian for all telemetry points associated with this control area.',
  `regulation_reserve_mw` DECIMAL(10,2) COMMENT 'Amount of regulation reserve in megawatts maintained for automatic generation control and frequency regulation.',
  `regulatory_jurisdiction` STRING COMMENT 'Primary regulatory jurisdiction governing this control area (e.g., FERC, state PUC, provincial authority).',
  `reserve_requirement_mw` DECIMAL(10,2) COMMENT 'Minimum operating reserve requirement in megawatts that must be maintained for reliability and contingency response.',
  `rto_iso_affiliation` STRING COMMENT 'Name of the RTO or ISO market operator with which this control area is affiliated, if applicable (e.g., PJM, CAISO, MISO, SPP, NYISO, ISO-NE, ERCOT).',
  `scada_integration_enabled` BOOLEAN COMMENT 'Indicates whether SCADA telemetry integration is active for real-time data collection from substations and generation facilities.',
  `spinning_reserve_mw` DECIMAL(10,2) COMMENT 'Amount of spinning (synchronized) reserve in megawatts available for immediate deployment in response to contingencies.',
  `state_estimator_enabled` BOOLEAN COMMENT 'Indicates whether the EMS state estimator function is active for real-time network model solving and contingency analysis.',
  `tie_line_count` INT COMMENT 'Number of transmission tie lines connecting this control area to adjacent control areas for interchange scheduling and metering.',
  `time_zone` STRING COMMENT 'Primary time zone for control area operations and scheduling, using standard abbreviations (e.g., EST, CST, MST, PST, EPT, CPT, MPT, PPT). Pattern: ^[A-Z]{3,4}$.',
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
  CONSTRAINT `pk_grid_control_area` PRIMARY KEY (`control_area_id`)
)
USING DELTA
COMMENT 'Master record for a balancing authority control area — the fundamental geographic and electrical boundary within which the EMS/SCADA system maintains real-time generation-load balance, frequency regulation, and interchange scheduling. Captures control area identifier, NERC registered entity ID, balancing authority code, nominal frequency (60 Hz), ACE (Area Control Error) tolerance limits, tie-line list, interchange schedule references, and regulatory jurisdiction. SSOT for control area identity used across grid operations, trading, and NERC BAL compliance reporting. | CMM: CIM ControlArea (exact), IEC61970::ControlArea.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ControlArea',
  'cmm.cim.class' = 'ControlArea',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61970::ControlArea',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.control_area',
  'cmm.gis.location.role' = 'PowerSystemResource.Location'
);

-- EmsNode  <<CIM TopologicalNode : close>>
CREATE TABLE IF NOT EXISTS `grid`.`ems_node` (
  `ems_node_id` BIGINT NOT NULL COMMENT 'Unique identifier for the electrical node (bus) in the EMS network model. Primary key for the node entity. This is the EMS model representation, distinct from physical substation assets.',
  `control_area_id` BIGINT COMMENT 'FK to grid.control_area.control_area_id — Every EMS bus/node belongs to a control area. Critical for determining which balancing authority is responsible for voltage and frequency at each node. Required for NERC TOP compliance scoping.',
  `ems_control_area_id` BIGINT COMMENT 'Reference to the balancing authority responsible for this node. Used for coordination of generation control and frequency regulation.',
  `registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: EMS nodes represent physical electrical equipment (buses, breakers, transformers) that must be tracked as capital assets for maintenance scheduling, depreciation accounting, and FERC/regulatory report',
  `voltage_zone_id` BIGINT COMMENT 'Reference to the voltage control zone or area to which this node belongs. Used for coordinated voltage control and reactive power management.',
  `agc_participation_flag` BOOLEAN COMMENT 'Indicates whether generation at this node participates in Automatic Generation Control (AGC) for frequency regulation and area control error correction.',
  `base_mva` DECIMAL(10,2) COMMENT 'Base power rating in megavolt-amperes (MVA) used for per-unit calculations in the EMS power flow model. Standardizes impedance and power values.',
  `bus_number` INT COMMENT 'Numeric identifier assigned to the bus in the EMS power flow model. Used in state estimation and contingency analysis calculations.',
  `contingency_analysis_flag` BOOLEAN COMMENT 'Indicates whether this node is included in EMS contingency analysis studies. True if the node is monitored for N-1 and N-2 contingency violations.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this node record was first created in the EMS system. Used for audit trail and data lineage tracking.',
  `effective_date` DATE COMMENT 'Date when this node configuration became effective in the EMS network model. Used for model version control and historical analysis.',
  `ems_model_version` STRING COMMENT 'Version identifier of the EMS network model in which this node definition exists. Tracks model updates and changes over time.',
  `generation_mvar` DECIMAL(12,3) COMMENT 'Reactive power generation at this node in megavolt-amperes reactive (MVAR). Represents the reactive power injection from generators connected to this bus.',
  `generation_mw` DECIMAL(12,3) COMMENT 'Real power generation at this node in megawatts (MW). Represents the active power injection from generators connected to this bus.',
  `island_reference` BIGINT COMMENT 'Reference to the electrical island (connected network segment) to which this node currently belongs. Updated during topology processing after switching events.',
  `last_state_estimation_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent successful state estimation run that included this node. Used for data quality monitoring and operational awareness.',
  `last_topology_update_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent topology processor update that affected this nodes connectivity or energization status. Used for real-time operations tracking.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the node location in decimal degrees. Used for geospatial analysis and outage visualization.',
  `load_mvar` DECIMAL(12,3) COMMENT 'Reactive power load at this node in megavolt-amperes reactive (MVAR). Represents the reactive power consumption at the bus in the EMS model.',
  `load_mw` DECIMAL(12,3) COMMENT 'Real power load at this node in megawatts (MW). Represents the active power consumption at the bus in the EMS model.',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the node location in decimal degrees. Used for geospatial analysis and outage visualization.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this node record was last modified. Used for change tracking and audit compliance.',
  `nerc_region` STRING COMMENT 'NERC regional entity jurisdiction for this node. Used for compliance reporting and reliability coordination. Reference-value candidates: WECC|ERCOT|MRO|NPCC|RF|SERC|SPP|TRE.',
  `node_name` STRING COMMENT 'Human-readable name or label for the electrical node as defined in the EMS network model. Used by operators for identification and communication.',
  `node_type` STRING COMMENT 'Classification of the node in the power flow model. Slack (reference bus), PV (voltage-controlled generator bus), PQ (load bus), or Isolated (disconnected from network). Valid values: slack|pv|pq|isolated.',
  `nominal_voltage_kv` DECIMAL(10,3) COMMENT 'The nominal voltage level of the node in kilovolts (kV). Represents the design voltage class for this bus in the transmission or distribution network.',
  `notes` STRING COMMENT 'Free-text field for operational notes, special instructions, or additional context about this node. Used by EMS engineers and operators for documentation.',
  `operational_status` STRING COMMENT 'Current operational status of the node in the EMS network model. Indicates whether the node is actively participating in state estimation and power flow calculations. Valid values: in_service|out_of_service|testing|maintenance|decommissioned.',
  `operator_code` STRING COMMENT 'Code identifying the entity responsible for operating and controlling this node. May differ from owner in cases of contracted operations.',
  `owner_code` STRING COMMENT 'Code identifying the utility or entity that owns the physical assets associated with this node. Used for multi-utility coordination and cost allocation.',
  `pi_tag_name` STRING COMMENT 'OSIsoft PI historian tag name for this nodes voltage or power measurements. Used for historical data retrieval and post-event analysis.',
  `pnode_reference` STRING COMMENT 'Locational Marginal Price (LMP) pricing node identifier used in energy market operations. Links the EMS node to wholesale market pricing and settlement.',
  `region_code` STRING COMMENT 'Geographic or operational region code to which this node belongs. Used for regional coordination and reporting to Regional Transmission Organizations (RTOs) or Independent System Operators (ISOs).',
  `retirement_date` DATE COMMENT 'Date when this node was retired or removed from the EMS network model. Null for active nodes. Used for historical model reconstruction.',
  `rto_iso_code` STRING COMMENT 'Code identifying the RTO or ISO market area in which this node operates. Used for market operations and LMP pricing coordination.',
  `shunt_mvar` DECIMAL(12,3) COMMENT 'Reactive power provided by shunt devices (capacitors, reactors) at this node in megavolt-amperes reactive (MVAR). Used for voltage support and power factor correction.',
  `state_estimation_flag` BOOLEAN COMMENT 'Indicates whether this node participates in the EMS state estimator calculations. True if the node has sufficient telemetry for state estimation.',
  `topology_status` STRING COMMENT 'Real-time topology status of the node as determined by the EMS network topology processor. Reflects current switching state and connectivity. Valid values: energized|de_energized|isolated|unknown.',
  `voltage_limit_high_kv` DECIMAL(10,3) COMMENT 'Upper voltage limit in kilovolts (kV) for this node. Used in contingency analysis and voltage violation detection.',
  `voltage_limit_low_kv` DECIMAL(10,3) COMMENT 'Lower voltage limit in kilovolts (kV) for this node. Used in contingency analysis and voltage violation detection.',
  `voltage_setpoint_kv` DECIMAL(10,3) COMMENT 'Target voltage setpoint in kilovolts (kV) for voltage-controlled nodes (PV buses). Used by automatic voltage regulators and reactive power control devices.',
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
  CONSTRAINT `pk_grid_ems_node` PRIMARY KEY (`ems_node_id`)
)
USING DELTA
COMMENT 'Master record for every electrical node (bus) modeled in the Energy Management System (EMS) state estimator and network topology processor. Captures node name, bus number, nominal voltage (kV), substation reference, voltage zone, island membership, base MVA, and EMS model version. Serves as the topological anchor for SCADA measurements, LMP pricing nodes (PNodes), and contingency analysis. Distinct from the physical substation asset (owned by asset domain) — this is the EMS network model representation. | CMM: CIM TopologicalNode (close), IEC61970::Topology.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'EmsNode',
  'cmm.cim.class' = 'TopologicalNode',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Topology',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.ems_node',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- ScadaPoint  <<CIM Measurement : close>>
CREATE TABLE IF NOT EXISTS `grid`.`scada_point` (
  `scada_point_id` BIGINT NOT NULL COMMENT 'Unique identifier for the SCADA telemetry point or PMU device. Primary key for the SCADA point master catalog.',
  `control_area_id` BIGINT COMMENT 'FK to grid.control_area.control_area_id — SCADA points belong to a specific control area\'s monitoring scope. Required for filtering telemetry by BA jurisdiction and for multi-area EMS configurations.',
  `ems_node_id` BIGINT COMMENT 'FK to grid.ems_node.ems_node_id — SCADA telemetry points are associated with specific EMS nodes or branches. This is the fundamental link between the measurement layer and the network model. Required for state estimation input mapping',
  `nerc_cip_asset_id` BIGINT COMMENT 'Foreign key linking to compliance.nerc_cip_asset. Business justification: SCADA points monitoring BES Cyber Systems are CIP-reportable assets under NERC CIP-002. This link enables CIP-007 systems security management and CIP-010 configuration change management compliance by',
  `registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: SCADA measurement points are physically installed on capital assets (transformers, breakers, capacitors). Operations and maintenance teams need to trace measurements back to asset records for predicti',
  `scada_ems_node_id` BIGINT COMMENT 'The EMS network model node identifier to which this telemetry point is associated. Used for state estimation and contingency analysis.',
  `to_ems_node_id` BIGINT COMMENT 'FK to grid.ems_node.ems_node_id — SCADA points are associated with EMS nodes (buses) or branches in the network model. This FK is essential for mapping telemetry to the network topology for state estimation and contingency analysis.',
  `agc_participation_flag` BOOLEAN COMMENT 'Indicates whether this telemetry point participates in AGC for frequency regulation and area control error (ACE) calculation. True if AGC-enabled.',
  `alarm_high_limit` DECIMAL(15,4) COMMENT 'The threshold above which an alarm is triggered. Used by EMS and SCADA alarm management systems.',
  `alarm_low_limit` DECIMAL(15,4) COMMENT 'The threshold below which an alarm is triggered. Used by EMS and SCADA alarm management systems.',
  `balancing_authority` STRING COMMENT 'The NERC-registered balancing authority responsible for this telemetry point. Used for coordination and reliability compliance.',
  `commissioning_date` DATE COMMENT 'The date this SCADA point was commissioned and placed into operational service.',
  `contingency_analysis_monitored` BOOLEAN COMMENT 'Indicates whether this telemetry point is monitored in EMS contingency analysis for N-1 and N-2 reliability assessments. True if monitored.',
  `control_area` STRING COMMENT 'The control area or operating region to which this telemetry point belongs. Used for AGC (Automatic Generation Control) and load balancing.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this SCADA point record was first created in the master catalog.',
  `critical_infrastructure_flag` BOOLEAN COMMENT 'Indicates whether this telemetry point is associated with critical infrastructure as defined by NERC CIP standards. True if subject to enhanced cybersecurity controls.',
  `data_owner` STRING COMMENT 'The organizational unit or individual responsible for the accuracy and maintenance of this telemetry point configuration (e.g., Grid Operations, Transmission Planning).',
  `deadband_value` DECIMAL(10,4) COMMENT 'The minimum change in value required to trigger an update to the historian or EMS. Used to filter noise and reduce data volume. Expressed in engineering units.',
  `ems_branch_reference` STRING COMMENT 'The EMS network model branch identifier (transmission line, transformer) to which this telemetry point is associated. Null for nodal measurements.',
  `engineering_units` STRING COMMENT 'The unit of measure for the telemetry value (e.g., MW, MVAR, kV, A, Hz, degrees, pu). Used for display, validation, and conversion.',
  `equipment_type` STRING COMMENT 'The type of equipment this telemetry point monitors (e.g., transformer, circuit breaker, transmission line, generator, capacitor bank, reactor).',
  `last_calibration_date` DATE COMMENT 'The date of the most recent calibration or accuracy verification for this telemetry point. Used for maintenance tracking and data quality assurance.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this SCADA point record was last updated. Used for change tracking and audit trails.',
  `measurement_type` STRING COMMENT 'The specific electrical or operational parameter being measured: MW (real power), MVAR (reactive power), kV (voltage), amps (current), breaker status, tap position, frequency, voltage angle, phasor magnitude, or phasor angle. Reference-value candidates: MW|MVAR|kV|amps|breaker_status|tap_position|frequency|voltage_angle|phasor_magnitude|phasor_angle.',
  `nerc_prc_002_registered` BOOLEAN COMMENT 'Indicates whether this PMU is registered under NERC PRC-002 (Disturbance Monitoring and Reporting Requirements). True if registered for compliance. Null for non-PMU points.',
  `next_calibration_due_date` DATE COMMENT 'The scheduled date for the next calibration or accuracy verification. Used for preventive maintenance planning.',
  `normal_max_value` DECIMAL(15,4) COMMENT 'The expected maximum value for this measurement under normal operating conditions. Used for validation and alarm generation.',
  `normal_min_value` DECIMAL(15,4) COMMENT 'The expected minimum value for this measurement under normal operating conditions. Used for validation and alarm generation.',
  `notes` STRING COMMENT 'Free-text field for operational notes, configuration details, or special handling instructions for this SCADA point.',
  `operational_status` STRING COMMENT 'The current operational status of the SCADA point: active (in service), inactive (out of service), testing (commissioning), maintenance (temporarily offline), or decommissioned (permanently retired). Valid values: active|inactive|testing|maintenance|decommissioned.',
  `pdc_assignment` STRING COMMENT 'The PDC (Phasor Data Concentrator) to which this PMU streams data. Used for synchrophasor data aggregation and distribution. Null for non-PMU points.',
  `pi_archive_enabled` BOOLEAN COMMENT 'Indicates whether this point is archived in the OSIsoft PI historian. True if historical data is stored for analytics and compliance.',
  `pi_compression_deviation` DECIMAL(10,4) COMMENT 'The compression deviation threshold for the PI tag. Values within this deviation are not archived. Expressed in engineering units or percentage.',
  `pi_compression_enabled` BOOLEAN COMMENT 'Indicates whether exception-based compression is enabled for this PI tag to reduce storage volume while preserving data fidelity.',
  `pmu_firmware_version` STRING COMMENT 'The firmware version installed on the PMU device. Used for compliance tracking and troubleshooting. Null for non-PMU points.',
  `pmu_gps_sync_source` STRING COMMENT 'The GPS or time synchronization source for the PMU (e.g., GPS satellite, IRIG-B, NTP). Ensures time-aligned synchrophasor measurements. Null for non-PMU points.',
  `pmu_manufacturer` STRING COMMENT 'The manufacturer of the PMU device (e.g., SEL, GE, ABB). Null for non-PMU points.',
  `pmu_model` STRING COMMENT 'The model number of the PMU device. Null for non-PMU points.',
  `pmu_reporting_rate_fps` INT COMMENT 'The reporting rate of the PMU in frames per second (e.g., 30, 60). High-speed synchrophasor data for wide-area monitoring. Null for non-PMU points.',
  `point_type` STRING COMMENT 'Classification of the telemetry point: analog (continuous measurements), digital (status/binary), calculated (derived values), or PMU synchrophasor (high-speed phasor measurements). Valid values: analog|digital|calculated|pmu_synchrophasor.',
  `quality_flag_enabled` BOOLEAN COMMENT 'Indicates whether quality flags (good, bad, questionable, substituted) are enabled for this point. True if quality validation is active.',
  `rtu_address` STRING COMMENT 'The communication address or channel identifier of the RTU/IED within the SCADA network (e.g., IP address, serial port, DNP3 address).',
  `rtu_reference` STRING COMMENT 'Identifier of the RTU or IED (Intelligent Electronic Device) that sources this telemetry point. Links to the physical field device.',
  `scan_rate_seconds` INT COMMENT 'The frequency at which the SCADA system polls this point, measured in seconds. Typical values: 2-10 seconds for critical analog points, 30-60 seconds for status points.',
  `state_estimator_observable` BOOLEAN COMMENT 'Indicates whether this telemetry point is used in the EMS state estimator for real-time network analysis. True if included in state estimation.',
  `substation_name` STRING COMMENT 'The name of the substation or generating station where this telemetry point is located. Used for geographic and operational context.',
  `tag_name` STRING COMMENT 'The unique tag identifier in the OSIsoft PI historian system. This is the canonical name used for real-time data retrieval and archival queries.',
  `voltage_level_kv` DECIMAL(10,2) COMMENT 'The nominal voltage level of the equipment associated with this telemetry point, measured in kilovolts (kV). Used for network model alignment.',
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
  CONSTRAINT `pk_grid_scada_point` PRIMARY KEY (`scada_point_id`)
)
USING DELTA
COMMENT 'Master catalog of all telemetry sources and measurement points — SCADA analog/digital points from RTUs and IEDs, plus PMU synchrophasor devices — across the transmission and generation network. SCADA point attributes include tag name (OSIsoft PI tag), point type (MW, MVAR, kV, amps, breaker status, tap position), associated EMS node or branch, RTU/IED source, scan rate, engineering units, deadband, quality flags, and PI historian archive configuration. PMU device attributes include manufacturer, model, firmware version, GPS synchronization source, reporting rate (frames/second), PDC assignment, and NERC PRC-002 registration status. SSOT for all telemetry source definitions and PI tag configuration — the unified operational and archiving metadata catalog for grid telemetry devices. | CMM: CIM Measurement (close), IEC61970::Meas.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ScadaPoint',
  'cmm.cim.class' = 'Measurement',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Meas',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.scada_point',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- GridScadaMeasurement  <<CIM MeasurementValue : close>>
CREATE TABLE IF NOT EXISTS `grid`.`grid_scada_measurement` (
  `grid_scada_measurement_id` BIGINT NOT NULL COMMENT 'Unique identifier for each grid telemetry measurement record. Primary key for the grid SCADA measurement event log. Inferred role: EVENT_LOG.',
  `control_area_id` BIGINT COMMENT 'Foreign key reference to the Balancing Authority responsible for the control area where this measurement was captured. Links telemetry to the NERC-registered Balancing Authority for compliance reporting, interchange scheduling, and frequency regulation analysis. Critical for NERC BAL and TOP standards.',
  `distribution_substation_id` BIGINT COMMENT 'Foreign key reference to the substation where this measurement was captured. Links the telemetry to the physical grid location for geographic and network topology analysis.',
  `lmp_price_id` BIGINT COMMENT 'Foreign key linking to trading.lmp_price. Business justification: Real-time SCADA measurements at pricing nodes validate LMP calculations and market outcomes. Critical for market monitoring, price validation, dispute resolution, and FERC market surveillance. Enables',
  `pmu_device_id` BIGINT COMMENT 'Foreign key reference to the Phasor Measurement Unit that captured this synchrophasor measurement. Identifies the source PMU device for high-precision time-synchronized measurements. Null for SCADA-sourced measurements.',
  `registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: Real-time SCADA measurements trigger asset condition assessments and health index calculations. Linking measurements to asset records enables predictive maintenance algorithms, thermal aging models, a',
  `scada_point_id` BIGINT COMMENT 'Foreign key reference to the SCADA point master registry that defines the telemetry point configuration, location, equipment association, and engineering metadata. Links this measurement to the grid asset or network element being monitored.',
  `active_power_mw` DECIMAL(12,4) COMMENT 'The real power flow in megawatts (MW) measured at this telemetry point. Positive values typically indicate power flowing in the defined forward direction; negative values indicate reverse flow. Used for generation dispatch monitoring, transmission loading, and energy accounting. Applicable to both SCADA and PMU measurements.',
  `agc_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this measurement is used as an input to the Automatic Generation Control (AGC) system for real-time generation dispatch and frequency regulation. True indicates the measurement (typically tie-line flows, area control error, or frequency) is part of the AGC control loop. False indicates the measurement is not used for AGC. Critical for NERC BAL-001 compliance.',
  `alarm_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this measurement triggered an alarm condition in the SCADA or EMS (Energy Management System). True indicates the value exceeded a configured threshold (high/low limit, rate-of-change limit, or deviation alarm). False indicates normal operation. Used to filter alarm-worthy events for operator notification and post-event analysis.',
  `alarm_priority` STRING COMMENT 'The priority level assigned to this measurement if it triggered an alarm. Critical indicates immediate operator action required (e.g., equipment overload, voltage collapse risk). High indicates urgent attention needed. Medium indicates abnormal condition requiring review. Low indicates informational alarm. Null if alarm_flag is false. Valid values: Critical|High|Medium|Low.',
  `breaker_status` STRING COMMENT 'The operational status of a circuit breaker for digital SCADA measurements. Open indicates the breaker is open and the circuit is de-energized. Closed indicates the breaker is closed and the circuit is energized. Intermediate indicates a transitional state during switching. Unknown indicates communication loss or indeterminate status. Critical for outage management, switching order execution, and network topology determination. Null for analog measurements. Valid values: Open|Closed|Intermediate|Unknown.',
  `contingency_analysis_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this measurement is monitored in the EMS contingency analysis application for N-1 and N-2 reliability assessments. True indicates the measurement is checked against post-contingency limits. False indicates the measurement is not part of contingency monitoring. Used to identify critical telemetry for NERC TPL (Transmission Planning) compliance.',
  `current_angle_degrees` DECIMAL(10,4) COMMENT 'The phase angle of the current phasor in degrees relative to a common time reference. Used in conjunction with voltage angle to calculate power flow direction and power factor. Null for non-current SCADA measurements.',
  `current_magnitude_amperes` DECIMAL(12,4) COMMENT 'The magnitude of the current phasor in amperes for PMU measurements. Represents the RMS current flowing through the monitored line or equipment. Used for real-time loading analysis and thermal limit monitoring. Null for non-current SCADA measurements.',
  `disturbance_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this measurement was captured during a grid disturbance event (e.g., fault, generation trip, load rejection, frequency excursion). True indicates the measurement is part of a disturbance data set for NERC PRC-002 (Disturbance Monitoring and Reporting Requirements) compliance and post-event analysis. False indicates normal operation.',
  `engineering_unit` STRING COMMENT 'The unit of measure for the engineering_value field. Common values include kV (kilovolt), MW (megawatt), MVAR (megavolt-ampere reactive), A (ampere), Hz (hertz), degrees (phase angle), percent (%). Essential for correct interpretation and aggregation of telemetry data.',
  `engineering_value` DECIMAL(18,6) COMMENT 'The measurement value converted to engineering units (e.g., kV for voltage, MW for power, Hz for frequency, degrees for phase angle). This is the business-ready value used for operational analytics, state estimation, and reporting. Derived from raw_value using the SCADA point or PMU configuration scaling factors.',
  `equipment_type` STRING COMMENT 'The type of grid equipment or network element that this measurement is monitoring. Transformer includes power transformers and autotransformers. Transmission Line includes overhead lines and underground cables. Generator includes generating units. Circuit Breaker includes all switching devices. Capacitor Bank and Reactor are reactive power devices. Bus represents substation buses. Tie Line represents interconnection points between control areas. Used for equipment-specific analytics and asset performance monitoring. Reference-value candidates: Transformer|Transmission.',
  `frequency_hz` DECIMAL(10,6) COMMENT 'The measured electrical frequency in Hertz at the measurement point. Nominal frequency is 60 Hz in North America or 50 Hz in other regions. Frequency deviations indicate generation-load imbalance and are critical for NERC BAL (Balancing and Frequency) reliability standards compliance and automatic generation control (AGC). Captured by both SCADA frequency transducers and PMUs.',
  `ingestion_timestamp_utc` TIMESTAMP COMMENT 'UTC timestamp when this measurement record was ingested from the OSIsoft PI historian into the analytics lakehouse platform. Distinct from measurement_timestamp_utc (the source event time). Used for data lineage tracking, latency analysis, and identifying data pipeline delays.',
  `limit_violation_type` STRING COMMENT 'The type of limit violation that triggered an alarm, if applicable. High indicates the value exceeded the high threshold. Low indicates the value fell below the low threshold. High-High and Low-Low indicate emergency thresholds. Rate-of-Change indicates the value changed too rapidly. None indicates no violation. Used for categorizing alarm events and compliance reporting. Valid values: High|Low|High-High|Low-Low|Rate-of-Change|None.',
  `measurement_category` STRING COMMENT 'High-level categorization of the measurement type for filtering and analytics. Voltage includes voltage magnitude and angle. Current includes current magnitude and angle. Power includes active and reactive power. Frequency includes frequency and ROCOF. Status includes breaker and switch positions. Temperature and Pressure are auxiliary measurements for equipment monitoring. Facilitates domain-specific queries and reporting. Reference-value candidates: Voltage|Current|Power|Frequency|Status|Temperature|Pressure.',
  `measurement_source_type` STRING COMMENT 'Discriminator indicating whether this measurement originated from SCADA (Supervisory Control and Data Acquisition) analog/digital telemetry or PMU (Phasor Measurement Unit) synchrophasor data. Determines the grain and attribute applicability of the record. Valid values: SCADA|PMU.',
  `measurement_timestamp_utc` TIMESTAMP COMMENT 'UTC timestamp when the telemetry measurement was captured at the source device (RTU or PMU). For SCADA measurements, precision is typically to the second or millisecond based on scan cycle. For PMU measurements, precision is to the microsecond per IEEE C37.118 synchrophasor standard. This is the principal event timestamp for the measurement.',
  `nerc_region` STRING COMMENT 'The NERC regional entity where this measurement was captured. WECC (Western Electricity Coordinating Council), ERCOT (Electric Reliability Council of Texas), MRO (Midwest Reliability Organization), NPCC (Northeast Power Coordinating Council), RF (ReliabilityFirst), SERC (SERC Reliability Corporation), SPP (Southwest Power Pool), TRE (Texas Reliability Entity). Used for regional compliance reporting and inter-regional coordination analysis. Reference-value candidates: WECC|ERCOT|MRO|NPCC|RF|SERC|SPP|TRE.',
  `pdc_reference` BIGINT COMMENT 'Foreign key reference to the Phasor Data Concentrator that aggregated and time-aligned this PMU measurement before forwarding to the historian or wide-area monitoring system. PDCs collect data from multiple PMUs and provide synchronized data streams. Null for SCADA-sourced measurements.',
  `pi_tag_name` STRING COMMENT 'The OSIsoft PI historian tag name that uniquely identifies this telemetry point in the PI system. This is the source-system identifier for SCADA measurements. Examples include substation voltage tags, transformer load tags, breaker status tags. Null for PMU-sourced measurements that may use a different naming convention.',
  `pmu_data_quality_flags` STRING COMMENT 'Comma-separated list of IEEE C37.118 data quality flags for PMU measurements. Flags include: PMU_SYNC_LOST (GPS synchronization lost), PMU_ERROR (measurement error detected), DATA_SORTING (time-order issue), PMU_TRIGGER (event trigger active), CONFIG_CHANGE (PMU configuration changed). Empty string indicates no quality issues. Used to filter high-quality synchrophasor data for oscillation detection and wide-area monitoring. Null for SCADA measurements.',
  `pmu_reporting_rate_hz` INT COMMENT 'The reporting rate in samples per second (Hz) for PMU synchrophasor measurements. Common values are 30 Hz or 60 Hz per IEEE C37.118 standard. Indicates the time resolution of the phasor data stream. Null for SCADA-sourced measurements.',
  `quality_code` STRING COMMENT 'OSIsoft PI or SCADA system quality indicator for this measurement. Good indicates valid data from the source device. Substituted indicates the value was estimated or filled by the historian due to communication loss. Bad indicates invalid or out-of-range data. Questionable indicates data that passed validation but has uncertainty flags. Annotated indicates manually adjusted data. Critical for filtering reliable data in operational analytics and NERC compliance reporting. Valid values: Good|Substituted|Bad|Questionable|Annotated.',
  `raw_value` DECIMAL(18,6) COMMENT 'The raw numeric value of the measurement as captured by the source device before any engineering unit conversion or scaling. For analog measurements, this is the unscaled sensor reading. For digital measurements, this is the binary state (0/1). For PMU measurements, this may represent the raw ADC output before phasor calculation.',
  `reactive_power_mvar` DECIMAL(12,4) COMMENT 'The reactive power flow in megavolt-amperes reactive (MVAR) measured at this telemetry point. Critical for voltage control, VAR management, and power factor optimization. Monitored for NERC VAR-001 (Voltage and Reactive Control) compliance. Applicable to both SCADA and PMU measurements.',
  `rocof_hz_per_second` DECIMAL(10,6) COMMENT 'The rate of change of frequency in Hertz per second, calculated from PMU synchrophasor data. A key indicator for detecting sudden generation loss, load rejection, or islanding events. High ROCOF values trigger under-frequency load shedding schemes and are monitored for NERC PRC-006 (Automatic Underfrequency Load Shedding) compliance. Null for SCADA measurements that do not calculate ROCOF.',
  `rtu_reference` BIGINT COMMENT 'Foreign key reference to the Remote Terminal Unit that collected and transmitted this SCADA measurement. Identifies the source device in the field for SCADA telemetry. Null for PMU-sourced measurements.',
  `scan_cycle_seconds` INT COMMENT 'The scan cycle interval in seconds at which this SCADA point is polled by the RTU or SCADA master. Typical values range from 2 seconds (critical telemetry) to 60 seconds (slower-changing measurements). Null for PMU measurements which operate on continuous streaming at fixed reporting rates (e.g., 30 or 60 samples per second).',
  `source_system` STRING COMMENT 'The name or identifier of the source system that provided this measurement to the PI historian. Examples include EMS (Energy Management System), SCADA Master, PMU Network, ADMS (Advanced Distribution Management System). Used for data lineage and troubleshooting data quality issues by tracing back to the originating system.',
  `state_estimator_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this measurement is used as an input to the EMS (Energy Management System) state estimator application. True indicates the measurement is included in the state estimation model for real-time network analysis and contingency analysis. False indicates the measurement is for monitoring only. Critical for identifying the telemetry set used for NERC TOP reliability analysis.',
  `switch_position` STRING COMMENT 'The position status of a disconnect switch or sectionalizing switch for digital SCADA measurements. Open indicates the switch is open. Closed indicates the switch is closed. Grounded indicates the switch is in a grounding position (for maintenance safety). Unknown indicates communication loss. Used for network topology modeling and switching order verification. Null for analog measurements. Valid values: Open|Closed|Grounded|Unknown.',
  `voltage_angle_degrees` DECIMAL(10,4) COMMENT 'The phase angle of the voltage phasor in degrees relative to a common time reference (typically GPS-synchronized). Critical for wide-area situational awareness, angle difference monitoring across transmission corridors, and oscillation detection. Null for non-voltage SCADA measurements.',
  `voltage_level_kv` INT COMMENT 'The nominal voltage level in kilovolts (kV) of the network element where this measurement was captured. Common values include 765, 500, 345, 230, 138, 115, 69, 34.5, 13.8, 4.16 kV. Used for segmenting telemetry by transmission vs. sub-transmission vs. distribution voltage classes and for voltage-specific analytics.',
  `voltage_magnitude_kv` DECIMAL(12,4) COMMENT 'The magnitude of the voltage phasor in kilovolts (kV) for PMU measurements. Represents the RMS voltage at the measurement point. Used for wide-area voltage monitoring, oscillation detection, and voltage stability analysis. Null for non-voltage SCADA measurements.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_grid_scada_measurement` PRIMARY KEY (`grid_scada_measurement_id`)
)
USING DELTA
COMMENT 'Time-series transactional record of all real-time and near-real-time grid telemetry readings — both SCADA analog/digital measurements and PMU synchrophasor data — ingested from OSIsoft PI historian into the analytics platform. SCADA attributes include PI tag reference, UTC timestamp, raw value, engineering-unit value, quality code (Good/Substituted/Bad), scan cycle, and source RTU. PMU attributes include voltage/current phasor magnitude and angle, frequency (Hz), ROCOF (Hz/s), microsecond-precision timestamp, and PDC data quality flags. Measurement source type discriminator (SCADA/PMU) distinguishes data origin and grain. SSOT for all grid telemetry time-series data supporting post-event review, NERC TOP reliability analysis, NERC PRC-002 disturbance monitoring, wide-area situational awareness, oscillation detection, and operational analytics. Distinct from interval meter data (owned by metering domain). | CMM: CIM MeasurementValue (close), IEC61970::Meas.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'GridScadaMeasurement',
  'cmm.cim.class' = 'MeasurementValue',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Meas',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.grid_scada_measurement'
);

-- StateEstimationRun  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `grid`.`state_estimation_run` (
  `state_estimation_run_id` BIGINT NOT NULL COMMENT 'Unique identifier for each execution cycle of the Energy Management System (EMS) state estimator. Primary key for the state estimation run record.',
  `balancing_authority_control_area_id` BIGINT COMMENT 'NERC-registered identifier of the Balancing Authority responsible for the control area where this state estimation run was executed. Used for inter-BA coordination and compliance reporting.',
  `control_area_id` BIGINT COMMENT 'FK to grid.control_area.control_area_id — State estimation runs execute within the context of a specific control area\'s network model. This link is required for multi-area EMS configurations and for scoping SE results to the correct balancing',
  `ems_node_id` BIGINT COMMENT 'FK to grid.ems_node.ems_node_id — State estimation results are per-node/per-branch. After merge of state_estimation_result into state_estimation_run, the result-level grain references ems_node. Required for post-event voltage analysis',
  `state_ems_node_id` BIGINT COMMENT 'FK to grid.ems_node.ems_node_id — State estimation results (now merged into state_estimation_run) produce per-node voltage/angle estimates. The FK to ems_node is required to map results back to the network model for visualization and',
  `bad_data_detection_count` INT COMMENT 'Number of SCADA measurements flagged as bad data (outliers or erroneous readings) during the state estimation execution. High counts indicate telemetry quality issues requiring investigation.',
  `closed_switching_device_count` INT COMMENT 'Number of circuit breakers, disconnects, and other switching devices in the closed (conducting) position during this state estimation run. Defines network connectivity paths.',
  `contingency_pre_screening_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) signaling whether this state estimation solution was used as the base case for contingency analysis pre-screening to identify critical N-1 and N-2 outage scenarios.',
  `control_center_reference` STRING COMMENT 'Identifier of the physical or logical control center facility where the EMS state estimator executed this run. Used for operational audit trail and disaster recovery tracking.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this state estimation run record was first created in the data platform. Used for data lineage and audit trail.',
  `de_energized_bus_count` INT COMMENT 'Total number of electrical buses (nodes) in the network topology that are de-energized (out of service) and excluded from the state estimation solution for this execution cycle.',
  `ems_model_version` STRING COMMENT 'Version identifier of the EMS network model (bus-branch topology, equipment parameters, ratings) used for this state estimation execution. Critical for model validation and change tracking.',
  `energized_bus_count` INT COMMENT 'Total number of electrical buses (nodes) in the network topology that are energized and included in the state estimation solution for this execution cycle.',
  `execution_duration_seconds` DECIMAL(10,3) COMMENT 'Total elapsed time in seconds from state estimation run initiation to solution completion or failure. Used for EMS performance monitoring and capacity planning.',
  `iteration_count` INT COMMENT 'Number of iterative solver cycles executed before the state estimator reached convergence or divergence. High iteration counts may indicate network stress or measurement quality issues.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this state estimation run record was last modified in the data platform. Used for change tracking and data quality monitoring.',
  `mvar_mismatch_tolerance` DECIMAL(12,6) COMMENT 'The maximum allowable reactive power mismatch threshold in megavars (MVAR) used as the convergence criterion for the state estimation solver. Critical for voltage stability assessment.',
  `mw_mismatch_tolerance` DECIMAL(12,6) COMMENT 'The maximum allowable active power mismatch threshold in megawatts (MW) used as the convergence criterion for the state estimation solver. Lower values indicate tighter solution accuracy requirements.',
  `observable_island_count` INT COMMENT 'Number of electrically isolated network islands that have sufficient measurement coverage for state estimation. Each island requires independent solution processing.',
  `open_switching_device_count` INT COMMENT 'Number of circuit breakers, disconnects, and other switching devices in the open (non-conducting) position during this state estimation run. Defines network connectivity and island boundaries.',
  `operator_override_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) signaling whether a system operator manually overrode state estimation inputs, outputs, or solver parameters during this execution cycle. Used for audit trail and compliance evidence.',
  `operator_override_reason` STRING COMMENT 'Free-text explanation provided by the system operator documenting the business justification for any manual override applied during this state estimation run. Required for NERC compliance and post-event review.',
  `pi_historian_tag_prefix` STRING COMMENT 'OSIsoft PI System tag prefix or namespace used to store time-series state estimation results (voltage, angle, flow) in the PI historian for operational analytics and post-event review.',
  `pmu_measurement_count` INT COMMENT 'Total number of synchrophasor measurements from Phasor Measurement Units (PMUs) available and processed as inputs to the state estimation algorithm. PMU data provides high-precision time-synchronized voltage and current phasors.',
  `pseudo_measurement_count` INT COMMENT 'Number of pseudo-measurements (synthetic measurements derived from historical load profiles, generation schedules, or forecasts) injected into the state estimation to improve observability in areas with sparse SCADA coverage.',
  `run_status` STRING COMMENT 'Current lifecycle status of the state estimation solution indicating whether the iterative solver successfully converged to a valid network state, diverged without solution, started from flat conditions, failed due to error, was aborted by operator, or produced partial results. Valid values: converged|diverged|flat_start|failed|aborted|partial.',
  `run_timestamp` TIMESTAMP COMMENT 'The exact date and time when the state estimation execution cycle was initiated by the EMS. This is the principal business event timestamp representing when the network state was computed.',
  `scada_measurement_count` INT COMMENT 'Total number of SCADA telemetry measurements (voltage, current, MW, MVAR, breaker status) available and processed as inputs to the state estimation algorithm for this execution cycle.',
  `solution_quality_indicator` STRING COMMENT 'Qualitative assessment of the state estimation solution quality based on residual magnitude, bad data detection count, and observability metrics. Used for operator confidence and post-event analysis. Valid values: excellent|good|acceptable|marginal|poor.',
  `system_frequency_hz` DECIMAL(8,4) COMMENT 'Measured or estimated electrical system frequency in Hertz (Hz) at the time of the state estimation run. Nominal frequency is 60 Hz in North America; deviations indicate generation-load imbalance.',
  `thermal_violation_count` INT COMMENT 'Number of transmission lines, transformers, or other network branches where the estimated current or power flow exceeds thermal rating limits. Indicates potential equipment overload requiring operator intervention.',
  `topology_change_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) signaling whether the network topology connectivity state changed since the previous state estimation run due to switching operations, outages, or equipment status changes.',
  `topology_snapshot_id` STRING COMMENT 'Unique identifier or hash representing the specific network topology configuration (bus connectivity, switching device states, equipment in-service status) captured at the time of this state estimation run. Used for topology reconstruction and post-event analysis.',
  `total_generation_mw` DECIMAL(15,3) COMMENT 'Sum of active power generation in megawatts (MW) across all generating units included in the state estimation solution. Used for system-wide power balance verification and NERC BAL compliance reporting.',
  `total_interchange_mw` DECIMAL(15,3) COMMENT 'Net scheduled active power interchange in megawatts (MW) with neighboring balancing authorities or control areas. Positive values indicate net export; negative values indicate net import.',
  `total_load_mw` DECIMAL(15,3) COMMENT 'Sum of active power load in megawatts (MW) across all load buses included in the state estimation solution. Used for system-wide power balance verification and load forecasting validation.',
  `total_losses_mw` DECIMAL(15,3) COMMENT 'Calculated active power losses in megawatts (MW) across the transmission network (lines, transformers, reactors) derived from the state estimation solution. Used for loss allocation and energy accounting.',
  `unobservable_island_count` INT COMMENT 'Number of electrically isolated network islands that lack sufficient SCADA measurement coverage for state estimation. These islands cannot be solved and require operator attention.',
  `voltage_violation_count` INT COMMENT 'Number of electrical buses where the estimated voltage magnitude falls outside acceptable operating limits (typically 0.95 to 1.05 per-unit). High counts indicate voltage stability concerns requiring corrective action.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_state_estimation_run` PRIMARY KEY (`state_estimation_run_id`)
)
USING DELTA
COMMENT 'Transactional record of each EMS state estimator execution cycle including topology connectivity state, per-node/per-branch electrical results, and network island configuration. Run-level attributes include timestamp, solution status (converged/diverged/flat-start), iterations, MW mismatch tolerance, bad-data detections, observable islands, operator overrides. Topology attributes include number of energized buses, open switching devices, topology change flag, and island membership. Result-level detail (grain: one row per node/branch per run) includes estimated voltage magnitude (kV), voltage angle (degrees), active power flow (MW), reactive power flow (MVAR), current (amps), and residual. SSOT for state estimation execution, topology snapshots, and electrical results — used for NERC TOP compliance evidence, post-event voltage profile and network reconstruction analysis, contingency pre-screening, NERC FAC-002 transfer capability studies, and EMS model validation. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'StateEstimationRun',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.state_estimation_run'
);

-- StateEstimationResult  <<CIM StateVariable : close>>
CREATE TABLE IF NOT EXISTS `grid`.`state_estimation_result` (
  `state_estimation_result_id` BIGINT NOT NULL COMMENT 'Unique identifier for each state estimation result record. Primary key for the state estimation result entity.',
  `scada_point_id` BIGINT COMMENT 'The SCADA telemetry point identifier that provided the measurement for this element. Links state estimation results to real-time data sources.',
  `state_estimation_run_id` BIGINT COMMENT 'Foreign key reference to the parent state estimation run that produced this result. Links this node or branch result to the specific EMS state estimator execution.',
  `active_power_mw` DECIMAL(12,3) COMMENT 'The estimated active power flow through this branch or injected/consumed at this node in megawatts. Represents real power transfer in the network.',
  `apparent_power_mva` DECIMAL(12,3) COMMENT 'The estimated apparent power (vector sum of active and reactive power) in megavolt-amperes. Used for equipment loading and thermal limit assessment.',
  `balancing_authority` STRING COMMENT 'The balancing authority responsible for this network element. Identifies the control area for coordination and reliability compliance.',
  `contingency_violation_flag` BOOLEAN COMMENT 'Indicates whether this element would violate operating limits under contingency conditions. Used for pre-screening in contingency analysis.',
  `control_area` STRING COMMENT 'The control area to which this network element belongs. Used for area interchange control and automatic generation control (AGC).',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this state estimation result record was created in the system. Audit trail for data lineage and compliance.',
  `current_amps` DECIMAL(12,3) COMMENT 'The estimated current flow through this branch or element in amperes. Critical for thermal limit monitoring and equipment protection.',
  `current_magnitude_pu` DECIMAL(8,6) COMMENT 'The estimated current magnitude expressed in per-unit relative to the element rating. Normalized representation for loading assessment.',
  `element_identifier` STRING COMMENT 'The unique identifier or name of the network element (node, branch, bus, line) in the EMS model. Corresponds to the SCADA point or network model object.',
  `element_type` STRING COMMENT 'The type of network element this result represents. Distinguishes between nodes (buses), branches (lines, transformers), generators, and loads in the EMS network model. Reference-value candidates: node|branch|bus|line|transformer|generator|load.',
  `estimation_confidence` DECIMAL(6,4) COMMENT 'A confidence score (0.0 to 1.0) indicating the reliability of the state estimation for this element based on measurement redundancy and quality.',
  `from_bus_name` STRING COMMENT 'For branch elements, the name of the originating bus or node. Defines the topology of the power flow path.',
  `loading_percentage` DECIMAL(8,3) COMMENT 'The percentage of the element\'s rated capacity being utilized based on the estimated power flow. Used for thermal limit and contingency analysis.',
  `measurement_status` STRING COMMENT 'The quality status of the measurement used for this element in the state estimation. Indicates whether the measurement was accepted, flagged as suspect, or rejected. Valid values: valid|suspect|bad_data|missing|telemetry_failure.',
  `normalized_residual` DECIMAL(10,6) COMMENT 'The residual normalized by the measurement standard deviation. Used for bad data detection and measurement validation in state estimation.',
  `observability_flag` BOOLEAN COMMENT 'Indicates whether this network element was observable in the state estimation (sufficient measurements available to estimate its state). True if observable, False if unobservable.',
  `pi_tag_name` STRING COMMENT 'The OSIsoft PI historian tag name for this measurement point. Enables integration with PI historian for operational analytics and post-event review.',
  `power_factor` DECIMAL(6,4) COMMENT 'The ratio of active power to apparent power at this element. Indicates the efficiency of power transfer and reactive power balance.',
  `reactive_power_mvar` DECIMAL(12,3) COMMENT 'The estimated reactive power flow through this branch or injected/consumed at this node in megavolt-amperes reactive. Essential for voltage control and stability.',
  `residual` DECIMAL(12,6) COMMENT 'The difference between the measured value and the estimated value for this element. Indicates measurement quality and potential bad data.',
  `result_timestamp` TIMESTAMP COMMENT 'The timestamp when this state estimation result was calculated by the EMS state estimator. Represents the real-world event time of the solved network state.',
  `solution_convergence_flag` BOOLEAN COMMENT 'Indicates whether the state estimator solution converged for this element. False indicates numerical instability or insufficient measurements.',
  `substation_name` STRING COMMENT 'The name of the substation where this network element is located. Provides geographic and operational context for the result.',
  `thermal_violation_flag` BOOLEAN COMMENT 'Indicates whether the estimated current or power flow exceeds the thermal rating of this element. Triggers congestion management actions.',
  `to_bus_name` STRING COMMENT 'For branch elements, the name of the destination bus or node. Completes the topology definition of the power flow path.',
  `updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this state estimation result record was last updated. Tracks modifications for audit and data quality purposes.',
  `voltage_angle_degrees` DECIMAL(10,4) COMMENT 'The estimated voltage phase angle at this node in degrees. Critical for power flow analysis and system stability assessment.',
  `voltage_level_kv` DECIMAL(10,3) COMMENT 'The nominal voltage level of the network element in kilovolts. Indicates whether this is transmission (e.g., 500kV, 345kV, 230kV) or sub-transmission (e.g., 138kV, 69kV).',
  `voltage_magnitude_kv` DECIMAL(12,4) COMMENT 'The estimated voltage magnitude at this node or element in kilovolts. Core output of the state estimator representing the solved voltage level.',
  `voltage_magnitude_pu` DECIMAL(8,6) COMMENT 'The estimated voltage magnitude expressed in per-unit (pu) relative to the nominal voltage level. Standard normalized representation for power system analysis.',
  `voltage_violation_flag` BOOLEAN COMMENT 'Indicates whether the estimated voltage at this element is outside acceptable operating limits. Triggers voltage control actions.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_state_estimation_result` PRIMARY KEY (`state_estimation_result_id`)
)
USING DELTA
COMMENT 'Per-node and per-branch output record from each EMS state estimator run. Captures the estimated voltage magnitude (kV), voltage angle (degrees), active power flow (MW), reactive power flow (MVAR), current (amps), and residual for each EMS node or branch in the solved network model. Linked to a parent state_estimation_run. Enables post-event voltage profile analysis, contingency pre-screening, and NERC FAC-002 transfer capability studies. | CMM: CIM StateVariable (close), IEC61970::StateVariables.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'StateEstimationResult',
  'cmm.cim.class' = 'StateVariable',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::StateVariables',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.state_estimation_result'
);

-- Contingency  <<CIM Contingency : exact>>
CREATE TABLE IF NOT EXISTS `grid`.`contingency` (
  `contingency_id` BIGINT NOT NULL COMMENT 'Unique identifier for the contingency case definition. Primary key for the contingency master catalog.',
  `contingency_state_estimation_run_id` BIGINT COMMENT 'FK to grid.state_estimation_run.state_estimation_run_id — Each contingency analysis execution (now merged into contingency) is triggered by a converged state estimation run. This FK links the security assessment to the system state it evaluated — critical fo',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Contingencies (N-1 and N-2 scenarios) must be scoped to a specific control area for NERC compliance and operational context. Each contingency case is defined and analyzed within the boundaries of a ba',
  `created_by_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Contingency definitions require audit trail of creator for NERC FAC-011 compliance and engineering change management. \'created_by_user\' text field should be FK to employee.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Each contingency definition implements specific NERC TPL standard requirements (N-1, N-2 criteria). This link documents which obligation mandates monitoring this contingency, enabling compliance repor',
  `state_estimation_run_id` BIGINT COMMENT 'FK to grid.state_estimation_run.state_estimation_run_id — Contingency analysis runs are triggered after each converged state estimation solution. The CA run references its parent SE run. Required for tracing security assessment results back to the network st',
  `to_state_estimation_run_id` BIGINT COMMENT 'FK to grid.state_estimation_run.state_estimation_run_id — Contingency analysis runs are triggered after each converged state estimation solution. The parent SE run provides the base-case power flow against which contingencies are evaluated. This is a critica',
  `alarm_threshold_enabled` BOOLEAN COMMENT 'Boolean flag indicating whether operator alarms are triggered when violations are detected for this contingency.',
  `analysis_method` STRING COMMENT 'Power flow solution method used for contingency analysis: full AC (alternating current) power flow, linear DC (direct current) approximation, or fast decoupled method. Valid values: full_ac|linear_dc|fast_decoupled.',
  `compliance_evidence_retention_years` INT COMMENT 'Number of years that contingency analysis records and violation evidence must be retained for NERC compliance audits.',
  `contingency_category` STRING COMMENT 'NERC planning category indicating the number of simultaneous element outages (N-1 single contingency, N-2 double contingency, N-1-1 sequential, or extreme event). Valid values: N-1|N-2|N-1-1|extreme_event.',
  `contingency_code` STRING COMMENT 'Standardized alphanumeric code or identifier used in EMS and SCADA systems to reference this contingency case.',
  `contingency_name` STRING COMMENT 'Human-readable name or label for the contingency case (e.g., \'Line 345 Outage\', \'Generator Unit 2 Trip\', \'Transformer T-12 Loss\').',
  `contingency_type` STRING COMMENT 'Classification of the contingency scenario by the type of element or event being simulated. Valid values: line_outage|generator_trip|transformer_loss|bus_fault|breaker_failure|multiple_element.',
  `corrective_action_description` STRING COMMENT 'Textual description of the corrective actions, remedial action schemes, or operator interventions modeled or recommended for this contingency.',
  `corrective_action_scheme_enabled` BOOLEAN COMMENT 'Boolean flag indicating whether a remedial action scheme (RAS) or special protection system (SPS) is modeled or enabled for this contingency.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this contingency case record was first created in the EMS contingency library.',
  `data_source_system` STRING COMMENT 'Name of the source system or application from which this contingency case definition was ingested (e.g., GE ADMS, ABB EMS, manual entry).',
  `effective_end_date` DATE COMMENT 'Date when this contingency case definition was retired or became inactive. Null for currently active contingencies.',
  `effective_start_date` DATE COMMENT 'Date when this contingency case definition became active and eligible for inclusion in EMS contingency analysis runs.',
  `elements_removed_description` STRING COMMENT 'Detailed textual description of the transmission or generation elements that are removed or tripped in this contingency scenario (e.g., \'Transmission Line 345kV between Substation A and Substation B\', \'Generator Unit G2 at Plant XYZ\').',
  `ems_system_name` STRING COMMENT 'Name or identifier of the EMS platform where this contingency case is defined and executed (e.g., GE ADMS, ABB EMS, Siemens Spectrum).',
  `geographic_region` STRING COMMENT 'Geographic region, zone, or control area where the contingency elements are located.',
  `last_analysis_run_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent EMS contingency analysis execution that evaluated this contingency case.',
  `last_modified_by_user` STRING COMMENT 'Username or identifier of the EMS engineer or system operator who last modified this contingency case definition.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this contingency case record was last modified or updated.',
  `last_violation_detected_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent contingency analysis run that detected one or more violations for this contingency.',
  `monitoring_enabled` BOOLEAN COMMENT 'Boolean flag indicating whether this contingency is actively monitored in real-time EMS contingency analysis runs.',
  `nerc_standard_applicability` STRING COMMENT 'Reference to the specific NERC reliability standard(s) that mandate or govern this contingency analysis (e.g., TPL-001-5, TPL-002-4, TPL-003-1, TPL-004-1, TOP-002-4).',
  `notes` STRING COMMENT 'Free-form text field for additional comments, operational notes, or special instructions related to this contingency case.',
  `operational_status` STRING COMMENT 'Current lifecycle status of the contingency case definition in the EMS contingency library. Valid values: active|inactive|archived|under_review.',
  `operator_acknowledgment_required` BOOLEAN COMMENT 'Boolean flag indicating whether system operator acknowledgment is required when violations are detected for this contingency.',
  `pi_historian_tag_prefix` STRING COMMENT 'Tag prefix or naming convention used in the OSIsoft PI historian system for storing contingency analysis results and telemetry related to this contingency.',
  `pre_contingency_generation_mw` DECIMAL(12,2) COMMENT 'Total system generation in megawatts (MW) at the time of the base case state estimation, before the contingency is applied.',
  `pre_contingency_load_mw` DECIMAL(12,2) COMMENT 'Total system load in megawatts (MW) at the time of the base case state estimation, before the contingency is applied.',
  `primary_element_reference` STRING COMMENT 'Identifier of the primary transmission or generation asset involved in the contingency (line, transformer, generator, bus). References the asset registry or network model.',
  `regulatory_reporting_required` BOOLEAN COMMENT 'Boolean flag indicating whether violations or analysis results for this contingency must be reported to NERC, FERC, or state regulatory authorities.',
  `scada_integration_enabled` BOOLEAN COMMENT 'Boolean flag indicating whether real-time SCADA telemetry is used as input for this contingency analysis.',
  `secondary_element_reference` STRING COMMENT 'Identifier of the secondary element involved in N-2 or multiple-element contingencies. Null for single-element (N-1) contingencies.',
  `severity_classification` STRING COMMENT 'Risk severity level assigned to this contingency based on potential impact to grid stability, load loss, or cascading failure risk. Valid values: critical|high|medium|low.',
  `thermal_overload_threshold_percent` DECIMAL(5,2) COMMENT 'Percentage of rated capacity that defines a thermal overload violation for transmission elements in this contingency (e.g., 100.0 for normal rating, 120.0 for emergency rating).',
  `total_violations_detected_count` INT COMMENT 'Cumulative count of violations detected across all historical contingency analysis runs for this contingency case.',
  `voltage_level_kv` DECIMAL(10,2) COMMENT 'Nominal voltage level in kilovolts (kV) of the transmission element(s) involved in the contingency.',
  `voltage_violation_high_kv` DECIMAL(10,2) COMMENT 'Upper voltage limit in kilovolts (kV) above which a voltage violation is flagged for this contingency.',
  `voltage_violation_low_kv` DECIMAL(10,2) COMMENT 'Lower voltage limit in kilovolts (kV) below which a voltage violation is flagged for this contingency.',
  `worst_case_violation_severity` STRING COMMENT 'Highest severity level of any violation ever detected for this contingency across all historical analysis runs. Valid values: none|minor|moderate|major|critical.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_contingency` PRIMARY KEY (`contingency_id`)
)
USING DELTA
COMMENT 'Master catalog of defined contingency cases (N-1 and N-2 scenarios) with their analysis execution records and violation results from the EMS contingency analysis (CA) function. Master attributes include contingency name, type (line outage, generator trip, transformer loss, bus fault), elements removed, NERC standard applicability (TPL-001 through TPL-004), and severity classification. Analysis run attributes (grain: one row per CA execution) include run timestamp, parent state estimation run reference, contingencies evaluated count, violations detected, worst-case contingency, solution method (full AC/linear DC), and operator acknowledgment. Violation detail attributes (grain: one row per violation per run) include violated element, violation type (thermal overload %, voltage exceedance kV), pre/post-contingency values, applicable rating, and corrective action status. SSOT for contingency definitions, security assessment execution, and N-1/N-2 violation records used in NERC TPL/TOP compliance evidence and real-time operator situational awareness. | CMM: CIM Contingency (exact), IEC61970::Contingency.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'Contingency',
  'cmm.cim.class' = 'Contingency',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61970::Contingency',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.contingency'
);

-- ContingencyAnalysisRun  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `grid`.`contingency_analysis_run` (
  `contingency_analysis_run_id` BIGINT NOT NULL COMMENT 'Unique identifier for each contingency analysis execution. Primary key for the contingency analysis run record.',
  `control_area_id` BIGINT COMMENT 'Reference to the control area or balancing authority area for which this contingency analysis was executed.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Contingency analysis is performed by specific grid operations teams whose costs are tracked in cost centers. Needed for activity-based costing of reliability analysis work, NERC compliance cost tracki',
  `emergency_stock_event_id` BIGINT COMMENT 'Foreign key linking to supply.emergency_stock_event. Business justification: Contingency analysis detecting thermal/voltage violations may trigger emergency material deployment for corrective action schemes (capacitor banks, reactors, mobile transformers). Links analysis run t',
  `employee_id` BIGINT COMMENT 'User identifier of the system operator who acknowledged the contingency analysis results. Used for audit trail and compliance documentation.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: NERC TPL-001/TPL-002 standards mandate contingency analysis for transmission planning. Each analysis run must be traceable to the specific NERC obligation it satisfies for audit evidence and complianc',
  `state_estimation_run_id` BIGINT COMMENT 'Reference to the parent state estimator solution that triggered this contingency analysis. Each CA run is executed after a converged state estimation solution.',
  `worst_case_contingency_id` BIGINT COMMENT 'Identifier of the contingency scenario that produced the most severe violations or highest risk to system reliability in this analysis run.',
  `analysis_type` STRING COMMENT 'Classification of the contingency analysis execution context. Real-time runs support live operations; study mode supports planning; post-event supports incident investigation. Valid values: real_time|study_mode|post_event|training.',
  `base_case_mvar_mismatch` DECIMAL(12,3) COMMENT 'Total MVAR mismatch in the base case power flow solution before contingency evaluation. Indicates quality of reactive power balance in the state estimation input.',
  `base_case_mw_mismatch` DECIMAL(12,3) COMMENT 'Total MW mismatch in the base case power flow solution before contingency evaluation. Indicates quality of the state estimation input. Should be near zero for valid analysis.',
  `convergence_tolerance` DECIMAL(12,8) COMMENT 'The numerical convergence tolerance threshold used for power flow solutions in this contingency analysis. Smaller values provide higher accuracy but longer execution time.',
  `corrective_action_description` STRING COMMENT 'Description of recommended or required corrective actions to address violations detected in the contingency analysis. May include generation redispatch, switching orders, or load curtailment.',
  `corrective_action_required` BOOLEAN COMMENT 'Indicates whether corrective actions are required based on the violations detected. Triggers operator response procedures when true.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this contingency analysis run record was first created in the system. Used for audit trail and data lineage.',
  `data_source_system` STRING COMMENT 'Name of the source system that generated this contingency analysis run record. Typically the EMS application name and version for data lineage tracking.',
  `ems_system_name` STRING COMMENT 'Name or identifier of the EMS system that executed this contingency analysis run. Supports multi-EMS environments and system integration tracking.',
  `execution_duration_seconds` DECIMAL(10,3) COMMENT 'Total elapsed time in seconds for the contingency analysis execution from initiation to completion. Critical for monitoring EMS performance and real-time operational requirements.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this contingency analysis run record was last modified. Tracks updates to operator acknowledgment, corrective actions, or status changes.',
  `max_iterations` INT COMMENT 'Maximum number of iterations allowed for power flow convergence in each contingency scenario. Prevents excessive computation time for non-converging cases.',
  `n1_contingencies_evaluated` INT COMMENT 'Number of single-element (N-1) contingencies evaluated in this run. N-1 represents loss of a single transmission element.',
  `n2_contingencies_evaluated` INT COMMENT 'Number of double-element (N-2) contingencies evaluated in this run. N-2 represents simultaneous loss of two transmission elements.',
  `nerc_compliance_flag` BOOLEAN COMMENT 'Indicates whether this contingency analysis run meets NERC TPL compliance requirements for documentation and retention. Used for regulatory audit evidence.',
  `non_converged_contingencies` INT COMMENT 'Number of contingency scenarios that failed to converge within the iteration limit. Non-convergence may indicate severe system stress or numerical issues.',
  `notes` STRING COMMENT 'Free-text notes or comments regarding this contingency analysis run. May include operator observations, special conditions, or analysis context.',
  `operator_acknowledged` BOOLEAN COMMENT 'Indicates whether the system operator has reviewed and acknowledged the contingency analysis results and any violations detected.',
  `operator_acknowledgment_timestamp` TIMESTAMP COMMENT 'Date and time when the system operator acknowledged the contingency analysis results. Null if not yet acknowledged.',
  `pi_historian_tag_prefix` STRING COMMENT 'Tag prefix used for storing this contingency analysis run results in the OSIsoft PI historian for operational analytics and post-event review.',
  `run_status` STRING COMMENT 'Current execution status of the contingency analysis run. Tracks the lifecycle from initiation through completion or failure. Valid values: initiated|running|completed|failed|aborted|timeout.',
  `run_timestamp` TIMESTAMP COMMENT 'The date and time when this contingency analysis execution was initiated by the EMS system. Represents the real-world operational moment of the analysis.',
  `scada_snapshot_timestamp` TIMESTAMP COMMENT 'Timestamp of the SCADA telemetry snapshot used as input to the state estimator that preceded this contingency analysis. Establishes data lineage for compliance.',
  `solution_method` STRING COMMENT 'The power flow calculation method used for this contingency analysis execution. Full AC provides highest accuracy; linear DC provides faster performance for screening studies. Valid values: full_ac|linear_dc|fast_decoupled|hybrid.',
  `stability_violations_detected` INT COMMENT 'Number of system stability violations detected including transient stability, voltage stability, or oscillatory stability issues.',
  `thermal_violations_detected` INT COMMENT 'Number of thermal overload violations detected where transmission line or transformer loading exceeds emergency ratings under contingency conditions.',
  `total_contingencies_evaluated` INT COMMENT 'The total number of contingency scenarios evaluated during this analysis run. Includes N-1, N-2, and other credible contingencies per NERC TPL standards.',
  `total_violations_detected` INT COMMENT 'Total number of reliability violations detected across all contingencies evaluated. Includes thermal overloads, voltage violations, and stability issues.',
  `voltage_violations_detected` INT COMMENT 'Number of bus voltage violations detected where voltage levels fall outside acceptable operating limits under contingency conditions.',
  `worst_case_contingency_description` STRING COMMENT 'Human-readable description of the worst-case contingency scenario, typically describing the element(s) lost and the resulting system impact.',
  `worst_case_severity_index` DECIMAL(10,4) COMMENT 'Numerical severity index for the worst-case contingency, typically representing the magnitude of the most severe violation (e.g., percent overload or per-unit voltage deviation).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_contingency_analysis_run` PRIMARY KEY (`contingency_analysis_run_id`)
)
USING DELTA
COMMENT 'Transactional record of each EMS contingency analysis (CA) execution. Captures run timestamp, parent state_estimation_run reference, number of contingencies evaluated, number of violations detected (thermal, voltage), worst-case contingency identifier, solution method (full AC / linear DC), and operator acknowledgment status. Supports NERC TPL compliance evidence and real-time operator situational awareness. Runs are triggered automatically after each converged state estimator solution. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ContingencyAnalysisRun',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.contingency_analysis_run'
);

-- ContingencyViolation  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `grid`.`contingency_violation` (
  `contingency_violation_id` BIGINT NOT NULL COMMENT 'Unique identifier for the contingency violation record. Primary key for the contingency violation entity.',
  `contingency_analysis_run_id` BIGINT COMMENT 'Reference to the parent contingency analysis execution that produced this violation. Links to the specific analysis run timestamp and configuration.',
  `contingency_id` BIGINT COMMENT 'Reference to the specific contingency scenario (N-1, N-2, etc.) that was simulated and resulted in this violation. Identifies the outage condition tested.',
  `control_area_id` BIGINT COMMENT 'Reference to the balancing authority responsible for the violated element. Identifies the operational control area where the violation occurred.',
  `distribution_substation_id` BIGINT COMMENT 'Reference to the substation where the violated element is located. Links the violation to physical infrastructure location.',
  `emergency_stock_event_id` BIGINT COMMENT 'Foreign key linking to supply.emergency_stock_event. Business justification: Contingency violations requiring physical corrective action (not just redispatch) trigger emergency stock mobilization. Essential for tracking material deployment decisions, FEMA reimbursement eligibi',
  `employee_id` BIGINT COMMENT 'Identifier of the system operator or dispatcher who acknowledged or acted on the violation. Used for audit trail and accountability.',
  `scada_point_id` BIGINT COMMENT 'SCADA telemetry point identifier for the violated element. Links the violation to real-time monitoring data in the SCADA system.',
  `acknowledged_flag` BOOLEAN COMMENT 'Indicates whether the violation alarm has been acknowledged by an operator. True if acknowledged, false if still requiring attention.',
  `acknowledged_timestamp` TIMESTAMP COMMENT 'Date and time when the violation alarm was acknowledged by an operator. Null if not yet acknowledged.',
  `alarm_priority` STRING COMMENT 'Priority level assigned to the violation alarm in the EMS operator interface. Determines visual and audible alarm presentation to operators. Valid values: critical|high|medium|low.',
  `analysis_model_version` STRING COMMENT 'Version identifier of the power flow or stability model used for the contingency analysis. Ensures traceability of analysis results to specific model configurations.',
  `contingency_case_name` STRING COMMENT 'Human-readable name of the contingency scenario tested (e.g., \'Loss of Line 345-123\', \'Generator Unit 5 Trip\'). Provides operator-friendly identification of the simulated outage.',
  `contingency_probability` DECIMAL(5,4) COMMENT 'Estimated probability of the contingency event occurring (0.0 to 1.0). Used for risk-based contingency ranking and prioritization.',
  `corrective_action_description` STRING COMMENT 'Free-text description of the corrective actions taken or planned to mitigate the violation (e.g., \'Reduce generation at Unit 3 by 50 MW\', \'Open breaker at Station A\').',
  `corrective_action_status` STRING COMMENT 'Current status of operator corrective actions to resolve the violation. Tracks the lifecycle of violation mitigation from detection to resolution. Valid values: pending|in_progress|completed|not_required|deferred.',
  `corrective_action_timestamp` TIMESTAMP COMMENT 'Date and time when corrective action was initiated or completed by the operator. Null if no action has been taken yet.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this violation record was first created in the system. Audit trail for record lifecycle tracking.',
  `data_source_system` STRING COMMENT 'Name of the source system or application that generated this violation record (e.g., \'GE EMS\', \'Siemens Spectrum PowerOn\', \'OSI Monarch\'). Used for data lineage and troubleshooting.',
  `ems_system_name` STRING COMMENT 'Name of the EMS or contingency analysis application that generated the violation record (e.g., \'GE PSLF\', \'Siemens Spectrum\', \'OSI Monarch\').',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this violation record was last modified. Tracks the most recent change to any field in the record.',
  `limit_value` DECIMAL(18,4) COMMENT 'The applicable operating limit threshold that was exceeded (e.g., thermal rating in MW, voltage limit in kV). Defines the boundary of acceptable operation.',
  `nerc_category` STRING COMMENT 'NERC TPL planning event category classification (P0 through P7) that this contingency represents. Defines the severity and likelihood of the contingency scenario. Reference-value candidates: P0|P1|P2|P3|P4|P5|P6|P7.',
  `notes` STRING COMMENT 'Free-form text field for operator comments, analysis notes, or additional context about the violation. Used for post-event review and documentation.',
  `operator_action_required` BOOLEAN COMMENT 'Flag indicating whether immediate operator intervention is required to mitigate the violation. True if corrective action is needed, false if informational only.',
  `pi_tag_name` STRING COMMENT 'OSIsoft PI historian tag name for the violated element measurement. Enables integration with PI historian for post-event analysis and trending.',
  `post_contingency_value` DECIMAL(18,4) COMMENT 'Simulated or calculated value of the monitored parameter after the contingency event. Represents the stressed system condition that triggered the violation.',
  `pre_contingency_value` DECIMAL(18,4) COMMENT 'Measured or estimated value of the monitored parameter (MW loading, voltage kV, etc.) before the contingency event. Baseline condition for comparison.',
  `rating_duration_minutes` INT COMMENT 'Time duration in minutes for which the applicable rating is valid (e.g., 15-minute emergency rating, 4-hour emergency rating). Null for continuous normal ratings.',
  `rating_type` STRING COMMENT 'Classification of the equipment rating that was violated. Identifies whether the violation is against normal, emergency, or extreme operating limits. Valid values: normal|emergency|short_term_emergency|long_term_emergency|extreme.',
  `resolution_timestamp` TIMESTAMP COMMENT 'Date and time when the violation was resolved and the system returned to secure operating limits. Null if violation is still active.',
  `risk_score` DECIMAL(10,4) COMMENT 'Calculated risk score combining violation severity, probability, and impact. Used for prioritizing violations in operator displays and reports.',
  `time_to_violation_seconds` INT COMMENT 'Simulated time in seconds from the contingency event initiation to the violation occurrence. Indicates how quickly the system degrades post-contingency.',
  `unit_of_measure` STRING COMMENT 'Unit of measurement for the violation values (MW for thermal, kV for voltage, etc.). Provides context for interpreting pre/post-contingency and limit values. Valid values: MW|MVAR|kV|amperes|percent|degrees.',
  `violated_element_name` STRING COMMENT 'Human-readable name or designation of the violated grid element (e.g., \'Line 345kV Smith-Jones\', \'Transformer T-123\'). Provides operator-friendly identification.',
  `violated_element_reference` BIGINT COMMENT 'Reference to the specific grid element (transmission line, transformer, bus, generator) that experienced the limit violation in the post-contingency state.',
  `violated_element_type` STRING COMMENT 'Classification of the grid element that experienced the violation. Categorizes the equipment type for analysis and reporting purposes. Valid values: transmission_line|transformer|bus|generator|capacitor_bank|reactor.',
  `violation_magnitude` DECIMAL(18,4) COMMENT 'Absolute difference between the post-contingency value and the limit value. Quantifies the extent of the violation in native units (MW, kV, etc.).',
  `violation_percentage` DECIMAL(8,4) COMMENT 'Percentage by which the post-contingency value exceeds the limit. Calculated as ((post_contingency_value - limit_value) / limit_value) * 100. Used for relative severity assessment.',
  `violation_severity` STRING COMMENT 'Severity classification of the violation based on magnitude and operational impact. Used for prioritization of operator corrective actions. Valid values: critical|major|minor|informational.',
  `violation_timestamp` TIMESTAMP COMMENT 'Date and time when the contingency violation was detected by the analysis engine. Represents the real-time or study timestamp of the violation occurrence.',
  `violation_type` STRING COMMENT 'Category of the limit violation detected. Identifies whether the violation is thermal (loading), voltage (magnitude), or stability-related. Valid values: thermal_overload|voltage_high|voltage_low|stability_limit|transient_instability|voltage_collapse.',
  `voltage_level_kv` DECIMAL(10,3) COMMENT 'Nominal voltage level in kilovolts of the violated element. Used for categorizing violations by voltage class (transmission vs sub-transmission).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_contingency_violation` PRIMARY KEY (`contingency_violation_id`)
)
USING DELTA
COMMENT 'Individual violation record produced by a contingency analysis run for a specific contingency case. Captures the contingency reference, violated element (line, transformer, bus), violation type (thermal overload % of rating, voltage limit exceedance kV), pre-contingency and post-contingency values, applicable rating (normal/emergency/extreme), and operator corrective action status. SSOT for real-time N-1 security violations used in NERC TPL and TOP reliability reporting. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ContingencyViolation',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.contingency_violation'
);

-- AgcSignal  <<CIM AnalogValue : broad>>
CREATE TABLE IF NOT EXISTS `grid`.`agc_signal` (
  `agc_signal_id` BIGINT NOT NULL COMMENT 'Unique identifier for the AGC signal record. Primary key for the agc_signal product.',
  `agc_control_area_id` BIGINT COMMENT 'Reference to the balancing authority control area issuing this AGC signal.',
  `generating_unit_id` BIGINT COMMENT 'Reference to the generating unit receiving this AGC regulation signal.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: AGC operations directly implement NERC BAL-001 and BAL-002 standards for frequency control and CPS compliance. Each AGC signal execution must be traceable to the governing obligation for CPS1/CPS2 com',
  `primary_control_area_id` BIGINT COMMENT 'FK to grid.control_area.control_area_id — AGC regulation signals and ACE computations are performed for a specific balancing authority control area. This link is required for NERC BAL-001 CPS1/CPS2 compliance reporting scoped to the correct B',
  `scada_point_id` BIGINT COMMENT 'The SCADA system point identifier associated with this AGC signal measurement.',
  `to_control_area_id` BIGINT COMMENT 'FK to grid.control_area.control_area_id — AGC signals and ACE records (now merged) are computed for a specific balancing authority control area. This FK is essential for multi-area operations and NERC BAL compliance reporting.',
  `trade_id` BIGINT COMMENT 'Foreign key linking to trading.trade. Business justification: AGC regulation deployment often fulfills ancillary service trades or regulation market awards. Linking enables real-time trade performance tracking, settlement quantity validation, and compliance veri',
  `actual_frequency_hz` DECIMAL(8,5) COMMENT 'The actual measured system frequency in hertz (Hz) at the time of this AGC signal. Nominal frequency is 60.000 Hz in North America.',
  `agc_mode` STRING COMMENT 'The operational mode of the Automatic Generation Control system at the time of this signal. Automatic mode means AGC is actively controlling generation; manual mode means operators are controlling generation manually. Valid values: automatic|manual|off|test.',
  `ancillary_service_type` STRING COMMENT 'The type of ancillary service being provided by this AGC signal. Regulation services provide continuous balancing, while reserve services provide contingency response. Valid values: regulation_up|regulation_down|spinning_reserve|non_spinning_reserve.',
  `base_point_mw` DECIMAL(12,3) COMMENT 'The base generation setpoint in megawatts (MW) for the generating unit before AGC regulation adjustment.',
  `cps1_compliant` BOOLEAN COMMENT 'Boolean indicator of whether this AGC signal interval meets NERC CPS1 compliance criteria. CPS1 measures the balancing authority\'s ability to follow its own generation schedule on a one-minute basis.',
  `cps2_compliant` BOOLEAN COMMENT 'Boolean indicator of whether this AGC signal interval meets NERC CPS2 compliance criteria. CPS2 measures the balancing authority\'s ability to limit unscheduled power flows on a 10-minute average basis.',
  `data_source_system` STRING COMMENT 'The name of the operational system from which this AGC signal record was sourced (e.g., OSIsoft PI, EMS, SCADA).',
  `ems_system_name` STRING COMMENT 'The name of the Energy Management System that generated this AGC signal.',
  `filtered_ace_mw` DECIMAL(12,3) COMMENT 'The filtered Area Control Error in megawatts (MW) after applying smoothing algorithms to remove noise and transient spikes.',
  `frequency_bias_setting_mw_per_0_1_hz` DECIMAL(10,3) COMMENT 'The frequency bias setting in megawatts per 0.1 hertz (MW/0.1 Hz) used in the ACE calculation. Represents the balancing authority\'s expected MW response to a 0.1 Hz frequency deviation.',
  `interconnection_name` STRING COMMENT 'The name of the North American electric interconnection to which this control area belongs. The four major interconnections are Eastern, Western, Texas (ERCOT), and Quebec. Valid values: eastern|western|texas|quebec.',
  `nerc_region` STRING COMMENT 'The NERC regional entity code responsible for reliability oversight of this control area (e.g., WECC, SERC, MRO, NPCC, RF, TRE).',
  `net_interchange_actual_mw` DECIMAL(12,3) COMMENT 'The actual net interchange power flow in megawatts (MW) across all tie lines for the control area at this timestamp.',
  `net_interchange_deviation_mw` DECIMAL(12,3) COMMENT 'The deviation between actual and scheduled net interchange in megawatts (MW). Calculated as (Actual Net Interchange - Scheduled Net Interchange).',
  `net_interchange_scheduled_mw` DECIMAL(12,3) COMMENT 'The scheduled net interchange power flow in megawatts (MW) across all tie lines for the control area at this timestamp.',
  `notes` STRING COMMENT 'Free-text field for additional comments, annotations, or operational notes related to this AGC signal event.',
  `pi_tag_name` STRING COMMENT 'The OSIsoft PI historian tag name from which this AGC signal data was sourced. Used for traceability back to the SCADA system.',
  `raw_ace_mw` DECIMAL(12,3) COMMENT 'The unfiltered Area Control Error in megawatts (MW) computed at the same time grain as the AGC signal. Raw ACE = (Actual Net Interchange - Scheduled Net Interchange) - (Frequency Bias Setting) × (Actual Frequency - Scheduled Frequency).',
  `record_created_timestamp` TIMESTAMP COMMENT 'The timestamp when this AGC signal record was first created in the data platform.',
  `record_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this AGC signal record was last updated in the data platform.',
  `regulation_direction` STRING COMMENT 'The direction of the regulation signal. Raise indicates the unit should increase generation, lower indicates decrease, neutral indicates no change. Valid values: raise|lower|neutral.',
  `regulation_reserve_deployed_mw` DECIMAL(12,3) COMMENT 'The amount of regulation reserve capacity deployed in megawatts (MW) in response to the AGC signal.',
  `regulation_signal_mw` DECIMAL(12,3) COMMENT 'The AGC regulation signal in megawatts (MW) sent to the generating unit. Positive values indicate raise signal, negative values indicate lower signal.',
  `response_rate_mw_per_min` DECIMAL(10,3) COMMENT 'The rate at which the generating unit responds to the AGC signal, measured in megawatts per minute (MW/min).',
  `rto_iso_code` STRING COMMENT 'The code identifying the RTO or ISO responsible for coordinating this control area\'s operations (e.g., PJM, MISO, CAISO, ERCOT, NYISO, ISO-NE, SPP).',
  `scheduled_frequency_hz` DECIMAL(8,5) COMMENT 'The scheduled target system frequency in hertz (Hz). Typically 60.000 Hz for North American interconnections.',
  `settlement_interval` INT COMMENT 'The settlement interval number within the operating day, used for ancillary services market settlement. Typically 5-minute or 15-minute intervals.',
  `signal_quality_code` STRING COMMENT 'Quality indicator for the AGC signal data. Good indicates reliable data, uncertain indicates questionable data, bad indicates invalid data, substituted indicates estimated or replaced data. Valid values: good|uncertain|bad|substituted.',
  `signal_timestamp` TIMESTAMP COMMENT 'The precise timestamp when this AGC signal and ACE computation were recorded. Primary event timestamp for this transactional record.',
  `ten_minute_average_ace_mw` DECIMAL(12,3) COMMENT 'The rolling 10-minute average of Area Control Error in megawatts (MW), used for NERC CPS2 compliance calculations.',
  `unit_response_status` STRING COMMENT 'The status of the generating unit\'s response to the AGC signal. Indicates whether the unit is following the signal as expected. Valid values: responding|not_responding|limited|unavailable.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_agc_signal` PRIMARY KEY (`agc_signal_id`)
)
USING DELTA
COMMENT 'Time-series transactional record of Automatic Generation Control (AGC) regulation signals and Area Control Error (ACE) computations for the balancing authority control area. AGC attributes include generating unit reference, base point (MW), regulation raise/lower signal (MW), regulation reserve deployed (MW), and response rate (MW/min). ACE attributes (same time grain) include raw ACE (MW), filtered ACE (MW), 10-minute average ACE, CPS1/CPS2 compliance indicators, frequency bias setting (MW/0.1 Hz), actual system frequency (Hz), scheduled frequency (Hz), and net interchange deviation (MW). Sourced from OSIsoft PI historian AGC and ACE tags. SSOT for all AGC regulation and ACE compliance data — used for NERC BAL-001 CPS1/CPS2 compliance evidence, NERC BAL-003 frequency response obligation, frequency regulation performance tracking, and ancillary services settlement. | CMM: CIM AnalogValue (broad), IEC61970::Meas.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AgcSignal',
  'cmm.cim.class' = 'AnalogValue',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61970::Meas',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.agc_signal'
);

-- AceRecord  <<CIM AnalogValue : broad>>
CREATE TABLE IF NOT EXISTS `grid`.`ace_record` (
  `ace_record_id` BIGINT NOT NULL COMMENT 'Unique identifier for the ACE record. Primary key for the time-series ACE dataset.',
  `control_area_id` BIGINT COMMENT 'Foreign key reference to the balancing authority control area for which this ACE value was computed.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: ACE measurements are the foundation of NERC BAL-001 compliance for balancing authorities. Every ACE record serves as evidence for CPS1/CPS2 compliance calculations. This link enables automated complia',
  `scada_point_id` BIGINT COMMENT 'SCADA system point identifier for the ACE calculation output. Links this record to the underlying SCADA telemetry infrastructure.',
  `ace_10min_avg_mw` DECIMAL(12,3) COMMENT 'Rolling 10-minute average of ACE values in megawatts. Critical metric for NERC CPS2 compliance evaluation, which requires the 10-minute average ACE to remain within L10 limits.',
  `ace_filtered_mw` DECIMAL(12,3) COMMENT 'Filtered Area Control Error value in megawatts after applying smoothing algorithms to remove noise and transient spikes. Used for AGC control actions.',
  `ace_raw_mw` DECIMAL(12,3) COMMENT 'Raw unfiltered Area Control Error value in megawatts as computed by the EMS. Represents the instantaneous imbalance between scheduled and actual interchange plus frequency bias contribution.',
  `actual_frequency_hz` DECIMAL(8,5) COMMENT 'Actual measured interconnection frequency in hertz at the time of this ACE calculation. Nominal frequency is 60.000 Hz for North American interconnections (Eastern, Western, Texas) and 50.000 Hz for other regions.',
  `agc_enabled` BOOLEAN COMMENT 'Boolean flag indicating whether AGC was enabled and actively issuing control signals to generating units at the time of this ACE measurement.',
  `agc_mode` STRING COMMENT 'Operating mode of the AGC system at the time of this ACE measurement. Automatic mode indicates AGC is actively controlling generation; manual mode indicates operators are manually balancing; off indicates AGC is disabled; test indicates AGC is in test/simulation mode. Valid values: automatic|manual|off|test.',
  `calculation_method` STRING COMMENT 'Method used to compute this ACE value. Standard indicates normal EMS calculation; backup indicates calculation by backup system; manual indicates operator calculation; estimated indicates interpolated or reconstructed value. Valid values: standard|backup|manual|estimated.',
  `cps1_compliant` BOOLEAN COMMENT 'Boolean indicator of whether this ACE measurement contributes positively to CPS1 compliance. CPS1 measures the balancing authority\'s contribution to interconnection frequency error over a rolling 12-month period.',
  `cps2_compliant` BOOLEAN COMMENT 'Boolean indicator of whether the 10-minute average ACE is within the L10 limit for this measurement period. CPS2 requires the balancing authority to maintain its 10-minute average ACE within specific bounds at least 90% of clock-10-minute periods.',
  `data_quality_code` STRING COMMENT 'Quality indicator for this ACE measurement. Good indicates validated real-time data; suspect indicates potential data quality issues; bad indicates known invalid data; estimated indicates calculated/interpolated value; manual indicates operator-entered value. Valid values: good|suspect|bad|estimated|manual.',
  `data_source_system` STRING COMMENT 'Name or identifier of the source system that provided this ACE record (e.g., EMS vendor name, PI historian instance, SCADA system identifier).',
  `disturbance_flag` BOOLEAN COMMENT 'Boolean flag indicating whether a reportable disturbance event was occurring during this ACE measurement period. Disturbances may trigger special ACE evaluation rules under NERC standards.',
  `ems_system_name` STRING COMMENT 'Name or identifier of the EMS system that computed this ACE value. Supports environments with multiple EMS instances or backup systems.',
  `frequency_bias_setting_mw_per_0_1_hz` DECIMAL(10,3) COMMENT 'The frequency bias setting in megawatts per 0.1 Hz used in the ACE calculation for this measurement period. Represents the balancing authority\'s obligation to respond to frequency deviations. Negative value indicates the BA will increase generation when frequency drops.',
  `frequency_deviation_hz` DECIMAL(8,5) COMMENT 'Difference between actual and scheduled frequency in hertz (actual minus scheduled). Positive values indicate over-frequency; negative values indicate under-frequency.',
  `ime_mw` DECIMAL(12,3) COMMENT 'Interchange meter error correction term in megawatts applied to the ACE calculation to account for known metering inaccuracies on tie lines.',
  `interconnection_name` STRING COMMENT 'Name of the North American interconnection to which this balancing authority belongs. Eastern, Western, and Texas (ERCOT) are the three major asynchronous interconnections in North America; Quebec operates as a separate interconnection. Valid values: eastern|western|texas|quebec.',
  `l10_limit_mw` DECIMAL(10,3) COMMENT 'The L10 limit in megawatts for CPS2 compliance evaluation. Represents the maximum allowable 10-minute average ACE magnitude. Calculated as 1.65 times epsilon10 (the root-mean-square of the balancing authority\'s 10-minute average ACE over 12 months).',
  `measurement_timestamp_utc` TIMESTAMP COMMENT 'UTC timestamp when the ACE measurement was captured by the EMS. Represents the real-world event time for this ACE calculation cycle, typically at 4-6 second intervals per NERC requirements.',
  `nerc_region` STRING COMMENT 'NERC regional entity code for the balancing authority. WECC=Western Electricity Coordinating Council, TRE=Texas Reliability Entity, MRO=Midwest Reliability Organization, NPCC=Northeast Power Coordinating Council, RF=ReliabilityFirst, SERC=SERC Reliability Corporation, SPP=Southwest Power Pool, FRCC=Florida Reliability Coordinating Council. Reference-value candidates: WECC|TRE|MRO|NPCC|RF|SERC|SPP|FRCC.',
  `net_actual_interchange_mw` DECIMAL(12,3) COMMENT 'Net actual interchange power flow in megawatts across all tie lines connecting this balancing authority to neighboring control areas. Positive values indicate net export; negative values indicate net import.',
  `net_interchange_deviation_mw` DECIMAL(12,3) COMMENT 'Difference between net actual interchange and net scheduled interchange in megawatts (actual minus scheduled). A key component of the ACE calculation formula.',
  `net_scheduled_interchange_mw` DECIMAL(12,3) COMMENT 'Net scheduled interchange power flow in megawatts for this measurement period, including all confirmed interchange transactions and dynamic schedules.',
  `notes` STRING COMMENT 'Free-text field for operational notes, annotations, or explanations related to this ACE measurement. May include operator comments about unusual conditions, data quality issues, or special events.',
  `pi_historian_tag` STRING COMMENT 'OSIsoft PI historian tag name for this ACE measurement point. Enables traceability to the real-time data historian for post-event analysis and compliance reporting.',
  `primary_frequency_response_adjustment_mw` DECIMAL(12,3) COMMENT 'Adjustment term in megawatts applied to ACE during primary frequency response events to account for the balancing authority\'s contribution to arresting frequency decline or rise.',
  `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this ACE record was first inserted into the data historian or lakehouse. Distinct from measurement_timestamp_utc, which represents the real-world event time.',
  `scheduled_frequency_hz` DECIMAL(8,5) COMMENT 'Scheduled interconnection frequency in hertz for this measurement period. Typically 60.000 Hz for North American grids, but may vary during time error correction periods.',
  `state_estimator_solution_valid` BOOLEAN COMMENT 'Boolean flag indicating whether the EMS state estimator had a valid converged solution at the time of this ACE calculation. Invalid state estimator solutions may affect ACE accuracy.',
  `tie_line_meter_count` INT COMMENT 'Number of tie line meters contributing to the net actual interchange calculation for this ACE measurement. Used for data quality assessment.',
  `tie_line_meter_failures` INT COMMENT 'Number of tie line meters that were unavailable or failed at the time of this ACE calculation. Non-zero values may indicate degraded ACE accuracy.',
  `time_error_correction_active` BOOLEAN COMMENT 'Boolean flag indicating whether the interconnection was in time error correction mode during this measurement period. Time error correction adjusts scheduled frequency to correct accumulated time error.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_ace_record` PRIMARY KEY (`ace_record_id`)
)
USING DELTA
COMMENT 'Time-series record of Area Control Error (ACE) computed by the EMS for the balancing authority control area. Captures UTC timestamp, raw ACE (MW), filtered ACE (MW), 10-minute average ACE (MW), CPS1 compliance indicator, CPS2 compliance indicator, frequency bias setting (MW/0.1 Hz), actual system frequency (Hz), scheduled frequency (Hz), and net interchange deviation (MW). SSOT for NERC BAL-001 CPS1/CPS2 compliance evidence and frequency regulation performance. | CMM: CIM AnalogValue (broad), IEC61970::Meas.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AceRecord',
  'cmm.cim.class' = 'AnalogValue',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61970::Meas',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.ace_record'
);

-- InterchangeSchedule  <<CIM EnergyTransaction : close>>
CREATE TABLE IF NOT EXISTS `grid`.`interchange_schedule` (
  `interchange_schedule_id` BIGINT NOT NULL COMMENT 'Unique identifier for the interchange schedule record. Primary key for the interchange schedule entity.',
  `approved_by_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Energy interchange schedules (NERC e-Tags) require documented approver for audit trails, market settlement disputes, and FERC compliance. \'approved_by\' text field should be FK to employee.',
  `counterparty_id` BIGINT COMMENT 'Identifier of the neighboring control area or counterparty entity involved in the interchange. Must be a NERC registered entity.',
  `energy_schedule_id` BIGINT COMMENT 'Foreign key linking to trading.energy_schedule. Business justification: Interchange schedules are created from or validated against energy schedules submitted by scheduling coordinators. Linking enables schedule reconciliation, e-Tag validation, and curtailment coordinati',
  `interchange_control_area_id` BIGINT COMMENT 'Identifier of the balancing authority control area that owns this interchange schedule.',
  `primary_control_area_id` BIGINT COMMENT 'FK to grid.control_area.control_area_id — Interchange schedules define energy flows between control areas. The FK to control_area identifies which balancing authority is party to the schedule — required for NERC BAL-002 compliance.',
  `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: Interchange schedules supporting market-based rate authority or transmission service must reference the authorizing FERC filing (MBR authorization, OATT tariff). This link enables rate compliance veri',
  `trade_id` BIGINT COMMENT 'Foreign key linking to trading.trade. Business justification: Interchange schedules implement physical delivery of bilateral energy trades. Direct trade linkage enables trade-to-schedule reconciliation, settlement validation, and curtailment impact analysis. Ess',
  `transmission_path_id` BIGINT COMMENT 'Identifier of the transmission path or flowgate used for this interchange. Defines the physical route of energy transfer between control areas.',
  `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the interchange schedule was approved by the balancing authority or transmission operator.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this interchange schedule record was first created in the system. Used for audit trail and data lineage.',
  `curtailment_status` STRING COMMENT 'Indicates whether the interchange schedule has been curtailed due to transmission constraints or reliability concerns. None indicates no curtailment; partial indicates reduced MW; full indicates complete curtailment. Valid values: none|partial|full.',
  `data_source_system` STRING COMMENT 'Name of the source system that originated this interchange schedule record. Typically the EMS, energy trading system, or e-Tag system.',
  `effective_end_timestamp` TIMESTAMP COMMENT 'Date and time when the interchange schedule ends and energy flow ceases. Marks the conclusion of the scheduled interchange period.',
  `effective_start_timestamp` TIMESTAMP COMMENT 'Date and time when the interchange schedule becomes effective and energy flow begins. Marks the start of the scheduled interchange period.',
  `etag_reference_number` STRING COMMENT 'Electronic tag reference number assigned by the NERC tag authority for this interchange transaction. Links to the OASIS e-Tag system.',
  `interchange_direction` STRING COMMENT 'Direction of energy flow relative to the balancing authority. Import indicates energy flowing into the control area; export indicates energy flowing out. Valid values: import|export.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this interchange schedule record was most recently modified. Tracks the latest change for audit and version control.',
  `market_type` STRING COMMENT 'Classification of the market context for the interchange schedule. Day-ahead schedules are submitted in advance; real-time schedules are for immediate delivery; bilateral schedules are direct contracts between parties. Valid values: day-ahead|real-time|bilateral.',
  `nerc_tag_reference` STRING COMMENT 'NERC-assigned tag identifier for the interchange schedule. Used for compliance reporting and audit trail.',
  `notes` STRING COMMENT 'Free-text field for additional comments, special instructions, or operational notes related to the interchange schedule. Used for context and communication between operators.',
  `oasis_posting_reference` STRING COMMENT 'Reference identifier for the OASIS posting associated with this interchange schedule. Links to the transmission reservation and available transfer capability posting.',
  `priority_level` INT COMMENT 'Numeric priority ranking for the interchange schedule used during curtailment events. Lower numbers indicate higher priority. Typically ranges from 1 to 7 per NERC curtailment procedures.',
  `ramp_rate_mw_per_minute` DECIMAL(8,3) COMMENT 'Maximum rate of change in megawatts per minute allowed for this interchange schedule. Used for ramping between hourly schedule values to maintain grid stability.',
  `schedule_number` STRING COMMENT 'Business identifier for the interchange schedule. Externally visible schedule reference number used in operational communications and settlements.',
  `schedule_status` STRING COMMENT 'Current lifecycle status of the interchange schedule. Tracks progression from submission through approval, execution, and completion or cancellation. Valid values: pending|approved|active|curtailed|completed|cancelled.',
  `schedule_type` STRING COMMENT 'Classification of the interchange schedule as firm (guaranteed delivery) or non-firm (interruptible). Firm schedules have priority during curtailment events. Valid values: firm|non-firm.',
  `scheduled_mw_hour_01` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 01:00. Positive values indicate export; negative values indicate import per NERC convention.',
  `scheduled_mw_hour_02` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 02:00.',
  `scheduled_mw_hour_03` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 03:00.',
  `scheduled_mw_hour_04` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 04:00.',
  `scheduled_mw_hour_05` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 05:00.',
  `scheduled_mw_hour_06` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 06:00.',
  `scheduled_mw_hour_07` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 07:00.',
  `scheduled_mw_hour_08` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 08:00.',
  `scheduled_mw_hour_09` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 09:00.',
  `scheduled_mw_hour_10` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 10:00.',
  `scheduled_mw_hour_11` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 11:00.',
  `scheduled_mw_hour_12` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 12:00.',
  `scheduled_mw_hour_13` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 13:00.',
  `scheduled_mw_hour_14` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 14:00.',
  `scheduled_mw_hour_15` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 15:00.',
  `scheduled_mw_hour_16` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 16:00.',
  `scheduled_mw_hour_17` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 17:00.',
  `scheduled_mw_hour_18` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 18:00.',
  `scheduled_mw_hour_19` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 19:00.',
  `scheduled_mw_hour_20` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 20:00.',
  `scheduled_mw_hour_21` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 21:00.',
  `scheduled_mw_hour_22` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 22:00.',
  `scheduled_mw_hour_23` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 23:00.',
  `scheduled_mw_hour_24` DECIMAL(10,3) COMMENT 'Scheduled interchange megawatt value for hour ending 24:00.',
  `submitted_timestamp` TIMESTAMP COMMENT 'Date and time when the interchange schedule was originally submitted for approval. Tracks the initial request time for compliance and audit purposes.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_interchange_schedule` PRIMARY KEY (`interchange_schedule_id`)
)
USING DELTA
COMMENT 'Master and transactional record of energy interchange schedules between the balancing authority and neighboring control areas or counterparties. Captures schedule ID, counterparty entity (NERC registered), interchange direction (import/export), scheduled MW by hour, e-Tag reference number, NERC TAG ID, effective start/end timestamps, schedule type (firm/non-firm), curtailment status, and OASIS posting reference. SSOT for interchange scheduling used in NERC BAL-002 compliance and energy trading settlement. | CMM: CIM EnergyTransaction (close), IEC62325::InfEnergyScheduling.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'InterchangeSchedule',
  'cmm.cim.class' = 'EnergyTransaction',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC62325::InfEnergyScheduling',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.interchange_schedule'
);

-- EmsLoadForecast  <<CIM ConformLoadSchedule : close>>
CREATE TABLE IF NOT EXISTS `grid`.`load_forecast` (
  `load_forecast_id` BIGINT NOT NULL COMMENT 'Primary key for load_forecast',
  `control_area_id` BIGINT COMMENT 'FK to grid.control_area.control_area_id — Operational load forecasts are produced for a specific control area. This link scopes forecasts to the correct BA for AGC and dispatch coordination.',
  `forecast_model_id` BIGINT COMMENT 'Foreign key linking to forecast.model. Business justification: Grid load forecasts should link to the forecast model used for accuracy tracking, model governance, and regulatory compliance. Model metadata (version, type, accuracy metrics) is essential for forecas',
  `forecast_run_id` BIGINT COMMENT 'Foreign key linking to forecast.run. Business justification: Grid domain load forecasts should reference the forecast run metadata for traceability, model versioning, and forecast accuracy analysis. Operators need to know which forecast run produced the values',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Grid load forecasts are spatially scoped to forecast zones for geographic aggregation, weather correlation, and substation-level planning. Forecast zones enable hierarchical load forecasting from feed',
  `load_control_area_id` BIGINT COMMENT 'Reference to the control area for which this load forecast was generated.',
  `load_forecast_for_control_area` BIGINT COMMENT 'FK to grid.control_area.control_area_id — Load forecasts are produced for a specific control area. Required for AGC and dispatch operations scoping.',
  `to_control_area_id` BIGINT COMMENT 'FK to grid.control_area.control_area_id — Operational load forecasts are produced for a specific control area. This FK scopes the forecast to the correct balancing authority boundary.',
  `actual_load_mw` DECIMAL(12,3) COMMENT 'The actual measured system load in megawatts (MW) for the target interval, populated post-interval from SCADA telemetry for forecast accuracy tracking and model tuning.',
  `agc_participation_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this forecast is actively used by the Automatic Generation Control system for real-time generation dispatch and frequency regulation.',
  `base_load_mw` DECIMAL(12,3) COMMENT 'The baseline load component in megawatts (MW) representing the minimum continuous demand independent of weather or time-of-day variations.',
  `behind_the_meter_generation_mw` DECIMAL(12,3) COMMENT 'The estimated distributed energy resource generation in megawatts (MW) occurring behind customer meters (rooftop solar, battery storage) that reduces net load visible to the grid.',
  `cloud_cover_input_percentage` DECIMAL(5,2) COMMENT 'The cloud cover percentage used as input to the load forecasting model, influencing solar radiation and temperature-driven load patterns.',
  `confidence_level_percentage` DECIMAL(5,2) COMMENT 'The statistical confidence level of the forecast expressed as a percentage, indicating the model\'s certainty in the predicted load value.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this load forecast record was first created and persisted in the data platform.',
  `data_source_system` STRING COMMENT 'The name of the source system or application that originated this load forecast record (e.g., EMS vendor name, forecasting module identifier).',
  `day_type` STRING COMMENT 'The classification of the target day used in the forecast model to account for load pattern variations (weekday, weekend, holiday, or special event day). Valid values: weekday|weekend|holiday|special-event.',
  `demand_response_adjustment_mw` DECIMAL(12,3) COMMENT 'The expected load reduction in megawatts (MW) from active demand response programs during the target interval, subtracted from gross load to calculate net forecasted load.',
  `ems_system_name` STRING COMMENT 'The name or identifier of the Energy Management System that generated this load forecast record.',
  `forecast_error_mw` DECIMAL(12,3) COMMENT 'The difference between forecasted load and actual load in megawatts (MW), calculated as (actual_load_mw - forecasted_load_mw), used for accuracy metrics and model performance evaluation.',
  `forecast_error_percentage` DECIMAL(6,3) COMMENT 'The forecast error expressed as a percentage of actual load, calculated as ((actual_load_mw - forecasted_load_mw) / actual_load_mw) * 100, used for model accuracy assessment.',
  `forecast_horizon_type` STRING COMMENT 'The temporal horizon category of the forecast indicating the planning timeframe (hour-ahead for AGC, day-ahead for unit commitment, week-ahead for resource planning). Valid values: hour-ahead|day-ahead|week-ahead|intra-hour|real-time|multi-day.',
  `forecast_lower_bound_mw` DECIMAL(12,3) COMMENT 'The lower confidence interval bound for the forecasted load in megawatts (MW), representing the low-end estimate for minimum generation and reserve planning.',
  `forecast_run_timestamp` TIMESTAMP COMMENT 'The timestamp when the forecast model was executed and this forecast record was produced by the EMS load forecasting function.',
  `forecast_status` STRING COMMENT 'The lifecycle status of the forecast record indicating whether it is preliminary, final, revised, superseded by a newer forecast, or archived. Valid values: preliminary|final|revised|superseded|archived.',
  `forecast_upper_bound_mw` DECIMAL(12,3) COMMENT 'The upper confidence interval bound for the forecasted load in megawatts (MW), representing the high-end estimate for reserve planning and contingency analysis.',
  `forecasted_load_mw` DECIMAL(12,3) COMMENT 'The predicted system load in megawatts (MW) for the target interval as calculated by the EMS load forecasting model.',
  `humidity_input_percentage` DECIMAL(5,2) COMMENT 'The relative humidity percentage used as input to the load forecasting model, influencing cooling load and weather-sensitive demand patterns.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this load forecast record was last modified or updated, typically when actual load values are populated post-interval.',
  `notes` STRING COMMENT 'Free-text field for operational notes, comments, or explanations regarding forecast anomalies, model adjustments, or special conditions affecting this forecast.',
  `peak_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether the target interval is expected to be a system peak load period, used for resource adequacy and reserve planning.',
  `pi_historian_tag` STRING COMMENT 'The OSIsoft PI historian tag name associated with this load forecast time series for integration with the real-time data historian and operational analytics.',
  `revision_number` INT COMMENT 'The sequential revision number for this forecast target interval, incremented each time a new forecast is issued for the same target timestamp.',
  `scada_integration_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this forecast record is integrated with SCADA telemetry for real-time actual load comparison and AGC feedback.',
  `season` STRING COMMENT 'The meteorological season classification for the target interval, used to apply seasonal load pattern adjustments in the forecasting model. Valid values: winter|spring|summer|fall.',
  `target_timestamp` TIMESTAMP COMMENT 'The specific date and time for which the load forecast applies (the future interval being forecasted).',
  `temperature_input_f` DECIMAL(5,2) COMMENT 'The temperature value in degrees Fahrenheit used as input to the load forecasting model, typically representing the control area weighted average or key city temperature.',
  `weather_adjusted_load_mw` DECIMAL(12,3) COMMENT 'The forecasted load in megawatts (MW) after applying weather normalization adjustments based on temperature, humidity, and other meteorological inputs.',
  `weather_sensitive_load_mw` DECIMAL(12,3) COMMENT 'The portion of forecasted load in megawatts (MW) that is driven by weather conditions (heating, cooling, and weather-dependent industrial processes).',
  `wind_speed_input_mph` DECIMAL(5,2) COMMENT 'The wind speed in miles per hour used as input to the load forecasting model, affecting heating and cooling load calculations.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_load_forecast` PRIMARY KEY (`load_forecast_id`)
)
USING DELTA
COMMENT 'Operational load forecast records produced by the EMS load forecasting function for the control area. Captures forecast run timestamp, forecast horizon type (hour-ahead, day-ahead, week-ahead), target hour, forecasted system load (MW), weather-adjusted load (MW), temperature input (°F), humidity input (%), forecast model version, and actual load (MW) populated post-interval for accuracy tracking. Distinct from the long-term capacity forecast (owned by forecast domain) — this is the real-time/short-term operational load forecast used by AGC and dispatch. | CMM: CIM ConformLoadSchedule (close), IEC61970::LoadModel.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'EmsLoadForecast',
  'cmm.cim.class' = 'ConformLoadSchedule',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::LoadModel',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.load_forecast'
);

-- GenerationDispatch  <<CIM GenUnitOpSchedule : close>>
CREATE TABLE IF NOT EXISTS `grid`.`generation_dispatch` (
  `generation_dispatch_id` BIGINT NOT NULL COMMENT 'Unique identifier for the generation dispatch instruction record. Primary key for the generation dispatch transaction.',
  `control_area_id` BIGINT COMMENT 'FK to grid.control_area.control_area_id — Dispatch instructions are issued within a control area\'s generation fleet. FK to control_area is needed for BAL compliance and to scope dispatch to the correct balancing authority.',
  `employee_id` BIGINT COMMENT 'The identifier of the system operator who issued or approved this dispatch instruction. Populated for manual dispatches or operator overrides.',
  `fuel_supply_contract_id` BIGINT COMMENT 'Foreign key linking to supply.fuel_supply_contract. Business justification: Economic dispatch optimization requires fuel contract terms (pricing index, take-or-pay obligations, delivery constraints) to calculate operating costs and ensure contract compliance during unit commi',
  `generating_unit_id` BIGINT COMMENT 'Reference to the generating unit receiving this dispatch instruction within the control area.',
  `generation_control_area_id` BIGINT COMMENT 'Reference to the control area issuing this dispatch instruction.',
  `generation_dispatch_within_control_area` BIGINT COMMENT 'FK to grid.control_area.control_area_id — Economic dispatch instructions are issued to generating units within a control area. Required for NERC BAL compliance scoping and dispatch optimization.',
  `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Economic dispatch decisions often relate to specific internal orders for fuel procurement, emissions compliance projects, or ancillary service provision. Links operational dispatch to financial commit',
  `ppa_id` BIGINT COMMENT 'Foreign key linking to trading.ppa. Business justification: Many generation dispatch instructions fulfill PPA delivery obligations. Linking enables real-time PPA compliance monitoring, settlement validation, and curtailment tracking. Essential for renewable en',
  `scada_point_id` BIGINT COMMENT 'Reference to the SCADA point used to monitor the actual output of the generating unit in response to this dispatch instruction.',
  `trade_id` BIGINT COMMENT 'Foreign key linking to trading.trade. Business justification: Dispatch instructions often execute physical delivery obligations from bilateral energy trades. Operators need trade context for dispatch compliance verification, settlement reconciliation, and audit',
  `actual_output_mw` DECIMAL(10,3) COMMENT 'The actual real power output in megawatts (MW) achieved by the generating unit in response to this dispatch instruction, as measured by SCADA telemetry. Nullable until the unit responds.',
  `agc_participation_flag` BOOLEAN COMMENT 'Indicates whether this dispatch instruction is part of an Automatic Generation Control (AGC) signal for real-time frequency regulation. True if AGC-controlled, false if manual or economic dispatch.',
  `ancillary_service_type` STRING COMMENT 'The type of ancillary service this dispatch instruction is providing, if applicable. None indicates energy-only dispatch. Reference-value candidates: regulation_up|regulation_down|spinning_reserve|non_spinning_reserve|voltage_support|black_start|none.',
  `compliance_tolerance_mw` DECIMAL(8,3) COMMENT 'The acceptable deviation in megawatts (MW) between the dispatch setpoint and actual output for the unit to be considered compliant with the dispatch instruction.',
  `contingency_flag` BOOLEAN COMMENT 'Indicates whether this dispatch instruction was issued in response to a contingency event (transmission outage, generation loss, or other reliability event). True if contingency-related, false otherwise.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this dispatch record was first created in the system. Used for audit trail and data lineage tracking.',
  `data_source_system` STRING COMMENT 'The name of the source system from which this dispatch record originated. Typically the EMS system name or SCADA integration platform.',
  `dispatch_compliance_flag` BOOLEAN COMMENT 'Indicates whether the generating unit complied with the dispatch instruction within the required tolerance and timeframe. True if compliant, false if non-compliant. Used for NERC BAL compliance reporting.',
  `dispatch_mw_setpoint` DECIMAL(10,3) COMMENT 'The target real power output in megawatts (MW) that the generating unit is instructed to achieve. This is the primary dispatch instruction value.',
  `dispatch_number` STRING COMMENT 'Business identifier for the dispatch instruction, typically generated by the Energy Management System (EMS) for operational tracking and audit purposes.',
  `dispatch_reason_code` STRING COMMENT 'The operational reason code explaining why this dispatch instruction was issued. Reference-value candidates: economic_optimization|frequency_regulation|voltage_support|congestion_management|reserve_activation|emergency_response|must_run_contract|renewable_curtailment|manual_override|load_following|spinning_reserve|non_spinning_reserve|black_start.',
  `dispatch_status` STRING COMMENT 'Current lifecycle status of the dispatch instruction: issued (sent to unit), acknowledged (received by unit), active (unit ramping or at setpoint), completed (instruction fulfilled), superseded (replaced by new instruction), or cancelled (instruction voided). Valid values: issued|acknowledged|active|completed|superseded|cancelled.',
  `dispatch_timestamp` TIMESTAMP COMMENT 'The date and time when the dispatch instruction was issued by the EMS to the generating unit. This is the principal business event timestamp for the dispatch transaction.',
  `dispatch_type` STRING COMMENT 'The classification of the dispatch instruction indicating the operational reason for the dispatch: economic (cost-optimized), emergency (reliability event), must-run (contractual or reliability requirement), regulation (frequency control), manual (operator override), or AGC (Automatic Generation Control). Valid values: economic|emergency|must_run|regulation|manual|agc.',
  `economic_merit_order_rank` INT COMMENT 'The rank of this generating unit in the economic dispatch merit order at the time of dispatch, where 1 is the lowest-cost unit. Used for economic dispatch optimization and fuel cost minimization.',
  `effective_end_timestamp` TIMESTAMP COMMENT 'The date and time when the dispatch instruction expires or is superseded by a subsequent dispatch instruction. Nullable for open-ended dispatches.',
  `effective_start_timestamp` TIMESTAMP COMMENT 'The date and time when the dispatch instruction becomes effective and the generating unit is expected to begin ramping to the target setpoint.',
  `emissions_rate_co2_lbs_per_mwh` DECIMAL(10,3) COMMENT 'The carbon dioxide emissions rate in pounds per megawatt-hour (lbs/MWh) for this generating unit at the dispatch setpoint. Used for environmental compliance and carbon accounting.',
  `ems_system_name` STRING COMMENT 'The name or identifier of the Energy Management System (EMS) that issued this dispatch instruction. Used for multi-EMS environments and data lineage tracking.',
  `fuel_type` STRING COMMENT 'The primary fuel type of the generating unit receiving this dispatch instruction. Used for fuel cost tracking and emissions reporting. Reference-value candidates: coal|natural_gas|nuclear|hydro|wind|solar|biomass|oil|geothermal.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this dispatch record was last modified. Used for audit trail and change tracking.',
  `locational_marginal_price` DECIMAL(12,4) COMMENT 'The locational marginal price in dollars per megawatt-hour ($/MWh) at the generating unit\'s point of interconnection at the time of dispatch. Used for market settlement and economic dispatch optimization.',
  `market_settlement_flag` BOOLEAN COMMENT 'Indicates whether this dispatch instruction is subject to wholesale market settlement with the RTO/ISO. True if market-settled, false if bilateral or internal dispatch.',
  `maximum_operating_limit_mw` DECIMAL(10,3) COMMENT 'The maximum continuous operating output in megawatts (MW) for the generating unit. The dispatch setpoint must be at or below this limit.',
  `minimum_operating_limit_mw` DECIMAL(10,3) COMMENT 'The minimum stable operating output in megawatts (MW) for the generating unit. The dispatch setpoint must be at or above this limit when the unit is online.',
  `notes` STRING COMMENT 'Free-text field for operational notes, comments, or special instructions related to this dispatch instruction. Used for operator communication and post-event review.',
  `operating_cost_per_mwh` DECIMAL(12,4) COMMENT 'The marginal operating cost in dollars per megawatt-hour ($/MWh) for this generating unit at the time of dispatch. Includes fuel cost, variable O&M, and emissions costs. Used for economic dispatch calculations.',
  `operator_override_flag` BOOLEAN COMMENT 'Indicates whether this dispatch instruction was manually overridden by a system operator, bypassing the automated economic dispatch algorithm. True if operator-initiated, false if system-generated.',
  `pi_tag_name` STRING COMMENT 'The OSIsoft PI historian tag name associated with this dispatch instruction for time-series data archival and post-event analysis.',
  `ramp_rate_mw_per_min` DECIMAL(8,3) COMMENT 'The maximum rate at which the generating unit can change its output in megawatts per minute (MW/min). Used by the EMS to calculate the time required to reach the dispatch setpoint.',
  `response_time_seconds` INT COMMENT 'The elapsed time in seconds from when the dispatch instruction was issued to when the generating unit reached the target setpoint within compliance tolerance. Nullable until the unit responds.',
  `rto_iso_code` STRING COMMENT 'The code identifying the RTO or ISO market in which this dispatch instruction was issued, if applicable. Examples: PJM, CAISO, ERCOT, MISO, NYISO, ISO-NE, SPP.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_generation_dispatch` PRIMARY KEY (`generation_dispatch_id`)
)
USING DELTA
COMMENT 'Transactional record of economic dispatch and unit commitment instructions issued by the EMS to generating units within the control area. Captures dispatch timestamp, generating unit reference, dispatch MW setpoint, economic merit order rank, operating cost ($/MWh), ramp rate (MW/min), minimum/maximum operating limits (MW), dispatch type (economic/emergency/must-run), and operator override indicator. Supports NERC BAL compliance, fuel cost optimization, and generation operations coordination. | CMM: CIM GenUnitOpSchedule (close), IEC61970::Generation::Production.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'GenerationDispatch',
  'cmm.cim.class' = 'GenUnitOpSchedule',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Generation::Production',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.generation_dispatch'
);

-- GridSwitchingOrder  <<CIM SwitchingPlan : exact>>
CREATE TABLE IF NOT EXISTS `grid`.`grid_switching_order` (
  `grid_switching_order_id` BIGINT NOT NULL COMMENT 'Unique identifier for the grid switching order. Primary key for this entity.',
  `affected_feeder_id` BIGINT COMMENT 'Identifier of the distribution feeder circuit impacted by the switching operation, if applicable.',
  `capex_project_id` BIGINT COMMENT 'Foreign key linking to finance.capex_project. Business justification: Many switching orders support capital project execution (new substation commissioning, equipment upgrades). Links operational switching activity to capital project tracking for AFUDC calculation, capi',
  `control_area_id` BIGINT COMMENT 'Identifier of the control area or balancing authority responsible for coordinating this switching order.',
  `distribution_substation_id` BIGINT COMMENT 'Identifier of the primary substation where the switching operations will be performed.',
  `environmental_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.environmental_permit. Business justification: Switching operations at substations with environmental permits (SF6 gas handling, oil containment systems) must comply with permit conditions. This link ensures switching orders respect environmental',
  `executing_crew_id` BIGINT COMMENT 'Identifier of the field crew or work group assigned to execute the switching order steps.',
  `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Switching orders for maintenance, capital projects, or emergency work are authorized against internal orders that track labor, materials, and contractor costs. Essential for work order cost settlement',
  `primary_grid_employee_id` BIGINT COMMENT 'Identifier of the system operator or control room operator who created and issued the switching order.',
  `registry_id` BIGINT COMMENT 'Identifier of the primary equipment asset (breaker, switch, transformer) that is the subject of the switching order.',
  `safety_incident_id` BIGINT COMMENT 'Foreign key linking to workforce.safety_incident. Business justification: Switching orders can result in safety incidents (arc flash, equipment failure injuries). Linking enables OSHA recordkeeping correlation and switching procedure safety analysis for continuous improveme',
  `staging_warehouse_id` BIGINT COMMENT 'Foreign key linking to supply.warehouse. Business justification: Switching operations require material staging location for crew dispatch planning, especially for capital projects and emergency restoration. Warehouse proximity to target substation drives crew deplo',
  `actual_completion_timestamp` TIMESTAMP COMMENT 'Actual date and time when the switching order execution was completed and verified, recorded for compliance audit and performance analysis.',
  `actual_start_timestamp` TIMESTAMP COMMENT 'Actual date and time when the switching order execution began, recorded for compliance audit and performance analysis.',
  `cancellation_reason` STRING COMMENT 'Explanation for why the switching order was cancelled or suspended, if applicable, used for operational review and lessons learned.',
  `completed_step_count` INT COMMENT 'Number of switching steps that have been successfully completed and verified.',
  `completion_notes` STRING COMMENT 'Free-text notes documenting any deviations, issues, or observations recorded during switching order execution, used for post-event review and compliance documentation.',
  `contingency_analysis_performed` BOOLEAN COMMENT 'Flag indicating whether a contingency analysis was performed to assess system reliability impacts before approving the switching order.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the switching order record was first created in the system.',
  `customer_notification_required` BOOLEAN COMMENT 'Flag indicating whether customer notifications are required due to planned service interruption resulting from the switching operation.',
  `data_source_system` STRING COMMENT 'Name of the operational system that originated this switching order record, typically the EMS, ADMS, or OMS platform.',
  `ems_integration_enabled` BOOLEAN COMMENT 'Flag indicating whether the switching order is integrated with the Energy Management System for state estimation and contingency analysis updates.',
  `estimated_customer_impact_count` INT COMMENT 'Estimated number of customers who may experience service interruption as a result of the switching operation.',
  `estimated_load_impact_mw` DECIMAL(10,3) COMMENT 'Estimated load in megawatts that will be interrupted or transferred during the switching operation, used for system balancing and contingency analysis.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when the switching order record was most recently modified, used for audit trail and data lineage tracking.',
  `nerc_compliance_flag` BOOLEAN COMMENT 'Flag indicating whether this switching order is subject to NERC TOP reliability standard compliance reporting and audit requirements.',
  `order_status` STRING COMMENT 'Current lifecycle status of the switching order from initial draft through approval, execution, and completion or cancellation. Reference-value candidates: draft|approved|issued|in_progress|completed|cancelled|suspended.',
  `order_type` STRING COMMENT 'Classification of the switching order based on operational purpose: planned maintenance, emergency response, system restoration, equipment testing, or new asset commissioning. Valid values: planned|emergency|maintenance|restoration|testing|commissioning.',
  `outage_coordination_required` BOOLEAN COMMENT 'Flag indicating whether this switching order requires coordination with neighboring utilities, Regional Transmission Organizations (RTO), or Independent System Operators (ISO).',
  `pi_historian_tag_prefix` STRING COMMENT 'Tag prefix used in the OSIsoft PI historian system for archiving switching order execution data and equipment status changes.',
  `post_switching_network_state` STRING COMMENT 'Description of the intended network topology and equipment status after the switching order is completed, used for verification and state estimation.',
  `pre_switching_network_state` STRING COMMENT 'Description of the network topology and equipment status before the switching order is executed, used for state verification and rollback planning.',
  `priority_level` STRING COMMENT 'Operational priority assigned to the switching order based on system impact, safety considerations, and business urgency. Valid values: critical|high|normal|low.',
  `safety_clearance_number` STRING COMMENT 'Reference number for the associated safety clearance or work permit authorizing personnel to work on de-energized equipment. Pattern: ^[A-Z0-9-]{6,20}$.',
  `scada_verification_enabled` BOOLEAN COMMENT 'Flag indicating whether SCADA telemetry is used to verify equipment status changes during switching order execution.',
  `scheduled_completion_timestamp` TIMESTAMP COMMENT 'Planned date and time when the switching order execution is scheduled to be completed and equipment returned to normal service.',
  `scheduled_start_timestamp` TIMESTAMP COMMENT 'Planned date and time when the switching order execution is scheduled to begin.',
  `switching_order_number` STRING COMMENT 'Externally-known unique business identifier for the switching order, used by operators and field crews for reference and communication. Pattern: ^[A-Z0-9]{8,20}$.',
  `tagging_authority` STRING COMMENT 'Name or identifier of the person or role authorized to place safety tags on equipment during the switching sequence.',
  `target_equipment_type` STRING COMMENT 'Classification of the equipment being switched: circuit breaker, disconnect switch, transformer, or other grid device. Reference-value candidates: circuit_breaker|disconnect_switch|load_break_switch|transformer|capacitor_bank|reactor|bus_tie|recloser.',
  `total_step_count` INT COMMENT 'Total number of individual switching steps defined in this switching order sequence.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_grid_switching_order` PRIMARY KEY (`grid_switching_order_id`)
)
USING DELTA
COMMENT 'Operational record of a switching order — a formal, sequenced set of switching steps issued by the system operator to field crews for network reconfiguration, isolation, or restoration. Order-level attributes include switching order number, issuing operator, target substation and equipment, safety clearance reference, pre/post-switching network state, execution timestamps, and completion status. Step-level detail (grain: one row per step) captures sequence number, device identifier, action type (open/close/tag/verify), device pre/post-action status, executing crew member, execution timestamp, and step completion status. SSOT for switching order management including granular step-by-step audit trail used in NERC TOP compliance, outage coordination, and post-event review. | CMM: CIM SwitchingPlan (exact), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'GridSwitchingOrder',
  'cmm.cim.class' = 'SwitchingPlan',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.grid_switching_order'
);

-- GridSwitchingStep  <<CIM SwitchingAction : exact>>
CREATE TABLE IF NOT EXISTS `grid`.`grid_switching_step` (
  `grid_switching_step_id` BIGINT NOT NULL COMMENT 'Unique identifier for the individual switching step within a switching order. Primary key for the grid switching step entity.',
  `distribution_substation_id` BIGINT COMMENT 'Reference to the substation where the switching device is located. Enables geographic and operational context for crew dispatch and coordination.',
  `grid_switching_order_id` BIGINT COMMENT 'Reference to the parent switching order that contains this step. Links the step to its parent switching sequence for operational coordination and audit trail.',
  `primary_grid_employee_id` BIGINT COMMENT 'Identifier of the crew member or operator who executed this switching step. Used for accountability, training assessment, and incident investigation.',
  `registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: Individual switching steps target specific assets (circuit breakers, disconnects, reclosers). Work management and safety systems require asset-level traceability to retrieve equipment specifications,',
  `scada_point_id` BIGINT COMMENT 'Reference to the SCADA telemetry point that monitors the status of the switching device. Enables automated status verification and real-time operational visibility.',
  `spare_parts_catalog_id` BIGINT COMMENT 'Foreign key linking to supply.spare_parts_catalog. Business justification: Individual switching steps may require specific spare parts (fuses, bushings, control components) for contingency scenarios. Catalog link enables pre-positioning of critical spares at substation befor',
  `action_type` STRING COMMENT 'Type of switching action to be performed on the device. Defines the specific operation required for this step in the switching sequence. Reference-value candidates: open|close|tag|verify|ground|remove_ground|rack_in|rack_out.',
  `actual_device_status` STRING COMMENT 'Actual observed status of the device after the switching action was executed. Captured from SCADA telemetry or field crew verification for audit trail and discrepancy detection. Valid values: open|closed|tagged|grounded|racked_out|unknown.',
  `actual_execution_timestamp` TIMESTAMP COMMENT 'Actual date and time when this switching step was executed. Captured from SCADA system or field crew reporting for precise audit trail and sequence timing analysis.',
  `authorization_timestamp` TIMESTAMP COMMENT 'Date and time when this switching step was authorized for execution. Documents the authorization event for operational audit trail and compliance verification.',
  `clearance_number` STRING COMMENT 'Unique identifier of the safety clearance or work permit authorizing this switching step. Links to safety management system for compliance verification.',
  `contingency_step_flag` BOOLEAN COMMENT 'Indicates whether this step is a contingency or alternate step to be executed only if primary steps fail. True for contingency steps, false for primary sequence steps.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this switching step record was first created in the system. Establishes the audit trail origin for the step record.',
  `critical_step_flag` BOOLEAN COMMENT 'Indicates whether this step is critical to grid reliability or safety. True for steps that require enhanced verification or cannot be skipped without significant operational impact.',
  `data_source_system` STRING COMMENT 'Name of the source system that originated this switching step record. Typically the Outage Management System (OMS), Advanced Distribution Management System (ADMS), or Energy Management System (EMS).',
  `device_name` STRING COMMENT 'Human-readable name or designation of the switching device for operator recognition and communication. Typically includes substation name and device position identifier.',
  `device_reference` STRING COMMENT 'Unique identifier of the switching device (breaker, disconnect switch, recloser, or sectionalizing device) that is the target of this switching action. Links to asset registry or SCADA point configuration.',
  `device_type` STRING COMMENT 'Classification of the switching device being operated. Determines operational procedures, safety protocols, and switching sequence constraints. Valid values: breaker|disconnect_switch|recloser|sectionalizer|load_break_switch|ground_switch.',
  `ems_control_command_reference` STRING COMMENT 'Unique identifier of the EMS control command issued to execute this switching step remotely. Links to EMS audit logs for cyber security compliance and operational review.',
  `executing_crew_member_name` STRING COMMENT 'Name of the crew member or operator who executed this switching step. Provides human-readable identification for operational logs and audit trails.',
  `failure_reason` STRING COMMENT 'Description of the reason why the switching step failed or could not be completed as planned. Captured for root cause analysis and procedure improvement.',
  `hold_tag_applied` BOOLEAN COMMENT 'Indicates whether a physical hold tag was applied to the device as part of this switching step. Used for lockout/tagout compliance and worker safety.',
  `hold_tag_number` STRING COMMENT 'Unique identifier of the physical hold tag applied to the device. Enables tracking of lockout/tagout devices for safety compliance and tag removal coordination.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this switching step record was last modified. Tracks the most recent change to the step record for audit trail and data quality monitoring.',
  `notes` STRING COMMENT 'Free-text field for additional operational notes, observations, or special conditions related to this switching step. Captures context not covered by structured fields.',
  `pi_tag_name` STRING COMMENT 'OSIsoft PI historian tag name for the switching device status point. Enables retrieval of historical device status data for post-event analysis and compliance reporting.',
  `post_action_device_status` STRING COMMENT 'Expected status of the device after the switching action is completed. Used for verification that the switching action achieved the intended result. Valid values: open|closed|tagged|grounded|racked_out|unknown.',
  `pre_action_device_status` STRING COMMENT 'Expected status of the device before the switching action is executed. Used for verification and safety checks to ensure proper switching sequence execution. Valid values: open|closed|tagged|grounded|racked_out|unknown.',
  `remote_operation_flag` BOOLEAN COMMENT 'Indicates whether this switching step was executed remotely via SCADA or Energy Management System (EMS) rather than by field crew. True for remote operations, false for manual field operations.',
  `retry_count` INT COMMENT 'Number of times this switching step was attempted before successful completion. Indicates operational challenges or equipment issues requiring investigation.',
  `safety_clearance_required` BOOLEAN COMMENT 'Indicates whether this switching step requires a safety clearance or work permit before execution. True for steps involving energized equipment or confined spaces.',
  `scada_status_confirmed` BOOLEAN COMMENT 'Indicates whether the device status change was confirmed via SCADA telemetry. True if SCADA confirmation received, false if manual verification only or SCADA unavailable.',
  `scheduled_execution_timestamp` TIMESTAMP COMMENT 'Planned date and time for execution of this switching step. Used for crew scheduling, outage coordination, and operational planning.',
  `step_duration_minutes` DECIMAL(10,2) COMMENT 'Actual elapsed time in minutes from step initiation to completion. Used for operational efficiency analysis, crew performance assessment, and future switching order planning.',
  `step_sequence_number` INT COMMENT 'Sequential order of this step within the parent switching order. Determines the execution order of switching actions to ensure safe and coordinated grid operations.',
  `step_status` STRING COMMENT 'Current execution status of this switching step. Tracks the lifecycle state of the step from planning through completion for operational coordination and audit purposes. Reference-value candidates: pending|in_progress|completed|verified|failed|cancelled|on_hold.',
  `switching_authority` STRING COMMENT 'Role or position of the person who authorized this switching step. Defines the level of operational authority required for the switching action. Valid values: system_operator|field_supervisor|transmission_operator|distribution_dispatcher|substation_operator.',
  `verification_timestamp` TIMESTAMP COMMENT 'Date and time when the switching step completion was verified. Documents the verification event for compliance with two-person verification protocols.',
  `verifying_crew_member_name` STRING COMMENT 'Name of the crew member or operator who verified the completion of this switching step. Provides human-readable identification for verification audit trail.',
  `voltage_level_kv` DECIMAL(10,3) COMMENT 'Nominal voltage level in kilovolts of the circuit or equipment being switched. Critical for safety protocols, crew qualifications, and switching procedure selection.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_grid_switching_step` PRIMARY KEY (`grid_switching_step_id`)
)
USING DELTA
COMMENT 'Individual step within a switching order, representing a single discrete switching action (open or close a specific breaker, disconnect switch, or recloser). Captures step sequence number, parent switching order reference, device identifier, action type (open/close/tag/verify), device pre-action status, device post-action status, executing crew member, execution timestamp, and step completion status. Enables granular audit trail of switching sequence execution for NERC TOP compliance and post-event review. | CMM: CIM SwitchingAction (exact), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'GridSwitchingStep',
  'cmm.cim.class' = 'SwitchingAction',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.grid_switching_step'
);

-- VoltageControlAction  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `grid`.`voltage_control_action` (
  `voltage_control_action_id` BIGINT NOT NULL COMMENT 'Unique identifier for the voltage control action record.',
  `contingency_id` BIGINT COMMENT 'Reference to the contingency analysis scenario that recommended or triggered this control action. Null for non-contingency-driven actions.',
  `control_area_id` BIGINT COMMENT 'Reference to the control area where the voltage control action was executed.',
  `employee_id` BIGINT COMMENT 'Identifier of the system operator who initiated or approved the control action. Null for fully automatic actions. Used for audit trail and accountability.',
  `feeder_id` BIGINT COMMENT 'Identifier of the distribution feeder affected by the voltage control action. Applicable for distribution-level voltage control actions.',
  `primary_ems_node_id` BIGINT COMMENT 'FK to grid.ems_node.ems_node_id — Voltage control actions target a specific EMS bus (node) to maintain voltage within limits. The FK to ems_node identifies the target bus for the action.',
  `scada_point_id` BIGINT COMMENT 'Reference to the SCADA telemetry point associated with the controlled device.',
  `voltage_ems_node_id` BIGINT COMMENT 'Reference to the EMS node (bus) where the voltage control action was targeted.',
  `action_duration_seconds` INT COMMENT 'Time in seconds from action initiation to completion or stabilization. Includes device response time and system settling time.',
  `action_status` STRING COMMENT 'Outcome status of the voltage control action. Successful indicates action completed and achieved desired voltage change, failed indicates action did not execute or had no effect, partial indicates action executed but did not fully achieve target, aborted indicates action was cancelled mid-execution, pending verification indicates action executed but effectiveness not yet confirmed. Valid values: successful|failed|partial|aborted|pending_verification.',
  `action_timestamp` TIMESTAMP COMMENT 'Date and time when the voltage control action was executed in the field. This is the principal business event timestamp representing when the physical control action occurred.',
  `alarm_triggered_flag` BOOLEAN COMMENT 'Indicates whether a voltage alarm was triggered that led to this control action. True if an alarm condition existed, False if action was preventive or scheduled.',
  `compliance_flag` BOOLEAN COMMENT 'Indicates whether this voltage control action was taken to maintain compliance with NERC FAC-001 voltage profile requirements or other regulatory standards. True if compliance-driven, False otherwise.',
  `control_action_type` STRING COMMENT 'Type of voltage control action executed. Capacitor bank switching adds reactive power, reactor switching removes reactive power, transformer tap change adjusts voltage ratio, generator VAR dispatch adjusts generator reactive output, static VAR compensator provides dynamic reactive support, synchronous condenser provides rotating reactive reserve. Valid values: capacitor_bank_switching|reactor_switching|transformer_tap_change|generator_var_dispatch|static_var_compensator|synchronous_condenser.',
  `control_mode` STRING COMMENT 'Operating mode under which the control action was executed. Automatic indicates system-initiated without operator intervention, manual indicates direct operator command, supervisory indicates operator-approved automatic action, emergency indicates action taken during system emergency, test indicates action performed during commissioning or testing. Valid values: automatic|manual|supervisory|emergency|test.',
  `controlled_device_name` STRING COMMENT 'Name or identifier of the physical device that was controlled (e.g., capacitor bank CB-123, transformer T-456, generator G-789).',
  `controlled_device_type` STRING COMMENT 'Classification of the controlled device. Capacitor bank provides capacitive reactive power, shunt reactor provides inductive reactive power, load tap changer adjusts transformer voltage, generator provides dynamic VAR support, SVC and STATCOM provide fast dynamic reactive compensation, synchronous condenser provides rotating inertia and reactive support. Reference-value candidates: capacitor_bank|shunt_reactor|load_tap_changer|generator|svc|statcom|synchronous_condenser.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this voltage control action record was first created in the system. Used for audit trail and data lineage.',
  `data_source_system` STRING COMMENT 'Name of the source system that originated this voltage control action record (e.g., GE ADMS, OSIsoft PI, SCADA RTU).',
  `ems_system_name` STRING COMMENT 'Name or identifier of the EMS system that executed or recorded the voltage control action (e.g., GE ADMS, ABB Symphony Plus, Siemens Spectrum).',
  `initiating_cause` STRING COMMENT 'Source or trigger that initiated the voltage control action. Automatic Volt-VAR optimization indicates EMS algorithm-driven action, automatic voltage regulator indicates local device control, operator manual indicates human-initiated action, state estimator recommendation indicates action based on network state analysis, contingency analysis recommendation indicates preventive action, scheduled maintenance indicates planned operational adjustment. Valid values: automatic_volt_var_optimization|automatic_voltage_regulator|operator_manual|state_estimator_recommendation|contingency_analysis_recommendation|scheduled_maintenance.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this voltage control action record was last modified. Used for audit trail and change tracking.',
  `mvar_change` DECIMAL(10,2) COMMENT 'Change in reactive power in megavolt-amperes reactive resulting from the control action. Positive values indicate capacitive reactive power injection (voltage support), negative values indicate inductive reactive power absorption (voltage reduction).',
  `nerc_region` STRING COMMENT 'NERC regional entity jurisdiction where the voltage control action occurred. WECC=Western Electricity Coordinating Council, ERCOT=Electric Reliability Council of Texas, MRO=Midwest Reliability Organization, NPCC=Northeast Power Coordinating Council, RF=ReliabilityFirst, SERC=SERC Reliability Corporation, SPP=Southwest Power Pool, TRE=Texas Reliability Entity. Reference-value candidates: WECC|ERCOT|MRO|NPCC|RF|SERC|SPP|TRE.',
  `notes` STRING COMMENT 'Free-text field for operator comments, special conditions, or additional context about the voltage control action.',
  `pi_tag_name` STRING COMMENT 'OSIsoft PI historian tag name associated with this voltage control action for time-series data archival and retrieval.',
  `post_action_voltage_kv` DECIMAL(10,3) COMMENT 'Measured voltage in kilovolts at the target bus after the control action was executed and the system stabilized. Used to assess the effectiveness of the control action.',
  `power_factor_post_action` DECIMAL(5,4) COMMENT 'Power factor measured at the target bus after the control action and system stabilization. Used to assess improvement in reactive power balance.',
  `power_factor_pre_action` DECIMAL(5,4) COMMENT 'Power factor measured at the target bus before the control action. Range -1.0 to 1.0, where values closer to 1.0 indicate better reactive power balance. Negative values indicate leading power factor (capacitive), positive values indicate lagging power factor (inductive).',
  `pre_action_voltage_kv` DECIMAL(10,3) COMMENT 'Measured voltage in kilovolts at the target bus immediately before the control action was executed. Used to assess the voltage deviation that triggered the action.',
  `rto_iso_code` STRING COMMENT 'Code identifying the RTO or ISO market operator responsible for the transmission system where the action occurred (e.g., CAISO, PJM, MISO, NYISO, ISO-NE, SPP).',
  `substation_name` STRING COMMENT 'Name of the substation where the controlled device is located.',
  `tap_position_change` INT COMMENT 'Number of tap positions changed for transformer tap control actions. Positive values indicate raise operations, negative values indicate lower operations. Null for non-tap control actions.',
  `target_bus_name` STRING COMMENT 'Name of the electrical bus where voltage control was targeted. This is the point in the network where voltage was being regulated.',
  `target_bus_voltage_kv` DECIMAL(10,3) COMMENT 'Nominal voltage level in kilovolts of the target bus where control action was applied.',
  `voltage_deviation_percent` DECIMAL(6,3) COMMENT 'Percentage deviation of pre-action voltage from the nominal voltage setpoint. Calculated as ((pre_action_voltage - nominal_voltage) / nominal_voltage) * 100. Positive values indicate overvoltage, negative values indicate undervoltage.',
  `voltage_limit_high_kv` DECIMAL(10,3) COMMENT 'Upper voltage limit in kilovolts for the target bus as defined by operating procedures or NERC standards. Actions are triggered when voltage approaches or exceeds this limit.',
  `voltage_limit_low_kv` DECIMAL(10,3) COMMENT 'Lower voltage limit in kilovolts for the target bus as defined by operating procedures or NERC standards. Actions are triggered when voltage approaches or falls below this limit.',
  `voltage_setpoint_kv` DECIMAL(10,3) COMMENT 'Target voltage setpoint in kilovolts that the control action was attempting to achieve or maintain at the target bus.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_voltage_control_action` PRIMARY KEY (`voltage_control_action_id`)
)
USING DELTA
COMMENT 'Transactional record of voltage control actions taken by the EMS Volt-VAR optimization or operator to maintain voltage within acceptable limits. Captures action timestamp, control type (capacitor bank switching, reactor switching, transformer tap change, generator VAR dispatch), controlled device reference, pre-action voltage (kV), post-action voltage (kV), MVAR change, initiating cause (automatic/operator), and target bus. Supports NERC FAC-001 voltage profile compliance and reactive power management reporting. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'VoltageControlAction',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.voltage_control_action'
);

-- FrequencyEvent  <<CIM PSREvent : extension>>
CREATE TABLE IF NOT EXISTS `grid`.`frequency_event` (
  `frequency_event_id` BIGINT NOT NULL COMMENT 'Unique identifier for the frequency excursion event. Primary key for the frequency event record.',
  `corrective_action_plan_id` BIGINT COMMENT 'Identifier of the corrective action plan developed in response to this frequency event to prevent recurrence or mitigate future impacts.',
  `emergency_stock_event_id` BIGINT COMMENT 'Foreign key linking to supply.emergency_stock_event. Business justification: Frequency excursion events causing generation/transmission equipment damage trigger emergency stock deployment for restoration. Essential for tracking material response to interconnection-wide disturb',
  `ems_alarm_id` BIGINT COMMENT 'Identifier of the EMS alarm that was triggered when the frequency event was detected. Links the event to the real-time alarm sequence.',
  `event_id` BIGINT COMMENT 'Foreign key linking to outage.outage_event. Business justification: Large outages trigger frequency events (generation/load imbalance). Linking enables analysis of frequency response, UFLS activation, and NERC BAL-003 compliance for disturbance control standard.',
  `frequency_control_area_id` BIGINT COMMENT 'Identifier of the control area or balancing authority where the frequency event was detected.',
  `scada_point_id` BIGINT COMMENT 'Identifier of the primary SCADA measurement point used to detect and monitor the frequency event, typically a system frequency measurement point.',
  `to_control_area_id` BIGINT COMMENT 'FK to grid.control_area.control_area_id — Frequency events are detected within a specific control area\'s EMS. FK to control_area scopes the event for NERC BAL-003 frequency response obligation reporting.',
  `agc_response_enabled_flag` BOOLEAN COMMENT 'Boolean flag indicating whether Automatic Generation Control (AGC) was active and responding during the frequency event to provide corrective generation adjustments.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this frequency event record was first created in the data system.',
  `data_source_system` STRING COMMENT 'Name of the source system that captured and recorded the frequency event data, typically the Energy Management System (EMS) or SCADA system.',
  `disturbance_mw` DECIMAL(12,2) COMMENT 'Magnitude of the generation or load disturbance in Megawatts (MW) that caused the frequency event. Represents the MW imbalance introduced into the system.',
  `event_duration_seconds` DECIMAL(10,2) COMMENT 'Total duration of the frequency excursion event measured in seconds, from initial detection to restoration or stabilization.',
  `event_end_timestamp` TIMESTAMP COMMENT 'Timestamp when the frequency excursion event concluded and system frequency returned to acceptable operating range or stabilized.',
  `event_severity` STRING COMMENT 'Severity classification of the frequency event based on magnitude of frequency deviation, duration, and system impact. Used for prioritization and post-event analysis. Valid values: low|medium|high|critical.',
  `event_start_timestamp` TIMESTAMP COMMENT 'Timestamp when the frequency excursion event was first detected by the Energy Management System (EMS). Represents the moment system frequency deviated beyond normal operating thresholds.',
  `event_type` STRING COMMENT 'Classification of the frequency event based on the direction of frequency deviation: under-frequency (frequency drop), over-frequency (frequency rise), or frequency oscillation (sustained fluctuation). Valid values: under_frequency|over_frequency|frequency_oscillation.',
  `frequency_deviation_hz` DECIMAL(8,4) COMMENT 'Maximum deviation of system frequency from nominal frequency (typically 60 Hz in North America or 50 Hz elsewhere) during the event, measured in Hertz.',
  `frequency_response_mw_per_hz` DECIMAL(12,4) COMMENT 'Measured frequency response of the balancing authority in Megawatts per Hertz (MW/Hz), calculated as the change in generation output divided by the change in frequency. Key metric for NERC BAL-003 compliance.',
  `generation_response_mw` DECIMAL(12,2) COMMENT 'Total generation response in Megawatts (MW) provided by generating units through governor action, Automatic Generation Control (AGC), or manual dispatch to arrest frequency deviation.',
  `interconnection_name` STRING COMMENT 'Name of the North American interconnection where the frequency event occurred: Eastern Interconnection, Western Interconnection, Texas (ERCOT) Interconnection, or Quebec Interconnection. Valid values: eastern|western|texas|quebec.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this frequency event record was last modified or updated with additional information.',
  `load_shed_mw` DECIMAL(12,2) COMMENT 'Total amount of load shed in Megawatts (MW) through UFLS or manual operator actions to restore frequency balance during the event.',
  `max_rocof_hz_per_second` DECIMAL(10,6) COMMENT 'Maximum rate of change of frequency observed during the event in Hertz per second (Hz/s). Peak ROCOF value used for worst-case analysis.',
  `nadir_frequency_hz` DECIMAL(8,4) COMMENT 'Lowest system frequency in Hertz (Hz) reached during the under-frequency event. Critical metric for assessing severity of frequency decline and system stability.',
  `nerc_region` STRING COMMENT 'NERC regional entity with jurisdiction over the balancing authority where the event occurred (e.g., WECC, SERC, MRO, NPCC, RF, TRE).',
  `operator_notes` STRING COMMENT 'Free-text notes entered by system operators documenting observations, actions taken, and contextual information about the frequency event.',
  `peak_frequency_hz` DECIMAL(8,4) COMMENT 'Highest system frequency in Hertz (Hz) reached during an over-frequency event. Used for over-frequency disturbance analysis.',
  `pi_tag_name` STRING COMMENT 'OSIsoft PI historian tag name for the frequency measurement time series data associated with this event. Used for detailed post-event analysis and trending.',
  `pre_event_frequency_hz` DECIMAL(8,4) COMMENT 'System frequency in Hertz (Hz) immediately before the disturbance event occurred, representing baseline operating frequency.',
  `recovery_frequency_hz` DECIMAL(8,4) COMMENT 'System frequency in Hertz (Hz) at the point of stabilization or restoration after the disturbance, indicating the settling point after corrective actions.',
  `reportable_event_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the frequency event meets NERC EOP-004 criteria for mandatory reporting to regulatory authorities and the Electricity Reliability Organization (ERO).',
  `restoration_timestamp` TIMESTAMP COMMENT 'Timestamp when system frequency was fully restored to normal operating range and all corrective actions were completed.',
  `rocof_hz_per_second` DECIMAL(10,6) COMMENT 'Rate of Change of Frequency measured in Hertz per second (Hz/s). Indicates how rapidly system frequency is changing and is critical for assessing system inertia and disturbance severity.',
  `root_cause_analysis_completed_flag` BOOLEAN COMMENT 'Boolean flag indicating whether a formal root cause analysis has been completed for this frequency event.',
  `triggering_cause` STRING COMMENT 'Root cause or initiating event that triggered the frequency excursion. Common causes include generation unit trip, sudden load loss, transmission fault, system islanding, or tie-line trip. Valid values: generation_trip|load_loss|transmission_fault|islanding|tie_line_trip|other.',
  `ufls_activated_flag` BOOLEAN COMMENT 'Boolean flag indicating whether Under-Frequency Load Shedding (UFLS) schemes were activated during the event to arrest frequency decline and prevent system collapse.',
  `ufls_stage_activated` STRING COMMENT 'Identifier of the UFLS stage or stages that were activated during the event (e.g., Stage 1, Stage 2). Multiple stages may be activated in severe events.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_frequency_event` PRIMARY KEY (`frequency_event_id`)
)
USING DELTA
COMMENT 'Transactional record of a system frequency excursion event detected by the EMS. Captures event start timestamp, nadir frequency (Hz), recovery frequency (Hz), rate of change of frequency (ROCOF in Hz/s), duration (seconds), triggering cause (generation trip, load loss, islanding), under-frequency load shedding (UFLS) activation flag, MW of load shed, and restoration timestamp. SSOT for frequency disturbance events used in NERC BAL-003 frequency response obligation reporting and post-event analysis. | CMM: CIM PSREvent (extension), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'FrequencyEvent',
  'cmm.cim.class' = 'PSREvent',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.frequency_event'
);

-- PmuMeasurement  <<CIM AnalogValue : close>>
CREATE TABLE IF NOT EXISTS `grid`.`pmu_measurement` (
  `pmu_measurement_id` BIGINT NOT NULL COMMENT 'Unique identifier for the PMU synchrophasor measurement record. Primary key for the pmu_measurement product.',
  `pmu_device_id` BIGINT COMMENT 'Reference to the PMU device that generated this measurement. Links to the physical PMU asset in the asset registry.',
  `scada_point_id` BIGINT COMMENT 'Reference to the SCADA point configuration associated with this PMU measurement stream. Links to the SCADA point registry for metadata and configuration.',
  `wams_event_id` BIGINT COMMENT 'Reference to a WAMS disturbance or oscillation event that this measurement is associated with. Null for routine measurements outside of event windows.',
  `active_power_mw` DECIMAL(12,3) COMMENT 'Real power flow in megawatts calculated from voltage and current phasors. Positive values indicate power flowing in the defined direction.',
  `apparent_power_mva` DECIMAL(12,3) COMMENT 'Apparent power in megavolt-amperes, the vector sum of active and reactive power. Represents total power flow magnitude.',
  `balancing_authority_code` STRING COMMENT 'NERC-registered balancing authority code for the control area where this PMU is located. Used for jurisdictional reporting and inter-BA coordination.',
  `current_angle_degrees` DECIMAL(10,6) COMMENT 'Phase angle of the current phasor in degrees relative to the system reference. Used to calculate power flow and detect phase imbalances.',
  `current_magnitude_amps` DECIMAL(12,6) COMMENT 'Magnitude of the current phasor measured in amperes. Represents the RMS current flowing through the monitored circuit element.',
  `data_quality_flag` STRING COMMENT 'Quality indicator for the PMU measurement data. Good indicates valid GPS-synchronized data; questionable indicates potential issues; invalid indicates data should not be used for analysis. Valid values: good|questionable|invalid|missing|estimated|test.',
  `data_source_system` STRING COMMENT 'Name of the source system that provided this PMU measurement data. Typically the PDC system name or OSIsoft PI interface identifier.',
  `equipment_type` STRING COMMENT 'Type of electrical equipment being monitored by this PMU measurement. Determines the interpretation and application of the phasor data. Valid values: bus|line|transformer|generator|load.',
  `frequency_hz` DECIMAL(10,6) COMMENT 'Measured system frequency in Hertz at the PMU location. Nominal frequency is 60 Hz in North America or 50 Hz in other regions. Frequency deviations indicate generation-load imbalances.',
  `ingestion_timestamp` TIMESTAMP COMMENT 'Timestamp when this PMU measurement record was ingested into the Silver layer lakehouse. Used for data lineage and latency monitoring.',
  `interconnection_name` STRING COMMENT 'North American interconnection where this PMU is located. The four major interconnections operate asynchronously from each other. Valid values: eastern|western|texas|quebec.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the PMU device location in decimal degrees. Used for geospatial visualization and propagation analysis.',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the PMU device location in decimal degrees. Used for geospatial visualization and propagation analysis.',
  `measurement_timestamp_utc` TIMESTAMP COMMENT 'Precise UTC timestamp of the synchrophasor measurement with microsecond resolution. GPS-synchronized time reference for wide-area situational awareness and event correlation.',
  `negative_sequence_voltage_kv` DECIMAL(12,6) COMMENT 'Negative sequence component of the three-phase voltage in kilovolts. Indicates voltage imbalance and potential phase faults.',
  `nerc_prc_002_registered` BOOLEAN COMMENT 'Indicates whether this PMU measurement point is registered for NERC PRC-002 disturbance monitoring compliance. Registered points must retain data for reportable disturbances.',
  `notes` STRING COMMENT 'Free-text field for operational notes, data quality annotations, or event context related to this PMU measurement record.',
  `oscillation_damping_ratio` DECIMAL(6,4) COMMENT 'Damping ratio of the detected oscillation mode. Values below 0.03 indicate poorly damped oscillations requiring operator attention. Null if no oscillation detected.',
  `oscillation_detected_flag` BOOLEAN COMMENT 'Indicates whether an inter-area or local oscillation was detected in this measurement window by the WAMS analytics engine. Used for modal analysis and stability assessment.',
  `oscillation_frequency_hz` DECIMAL(8,4) COMMENT 'Dominant oscillation frequency detected in Hertz. Typical inter-area oscillations range from 0.1 to 1.0 Hz. Null if no oscillation detected.',
  `pdc_reference` BIGINT COMMENT 'Reference to the PDC that aggregated and forwarded this PMU measurement. PDCs collect synchrophasor data from multiple PMUs for wide-area monitoring.',
  `pi_archive_enabled` BOOLEAN COMMENT 'Indicates whether this PMU measurement stream is actively archived in the OSIsoft PI historian for long-term storage and analysis.',
  `pi_tag_name` STRING COMMENT 'OSIsoft PI historian tag name where this PMU measurement stream is archived. Enables correlation with other SCADA and operational data in the PI system.',
  `pmu_configuration_version` STRING COMMENT 'Version identifier of the PMU configuration frame active when this measurement was captured. Used to track configuration changes over time.',
  `pmu_sync_status` STRING COMMENT 'Overall synchronization status of the PMU device. Synchronized indicates the PMU is GPS-locked and producing valid time-aligned measurements. Valid values: synchronized|unsynchronized|error.',
  `positive_sequence_voltage_kv` DECIMAL(12,6) COMMENT 'Positive sequence component of the three-phase voltage in kilovolts. Represents the balanced component of the voltage phasor.',
  `power_factor` DECIMAL(5,4) COMMENT 'Ratio of active power to apparent power, ranging from -1.0 to 1.0. Indicates the efficiency of power transmission and the phase relationship between voltage and current.',
  `reactive_power_mvar` DECIMAL(12,3) COMMENT 'Reactive power flow in megavolt-amperes reactive calculated from voltage and current phasors. Used for voltage control and power factor management.',
  `record_version` INT COMMENT 'Version number of this measurement record. Incremented if the record is corrected or reprocessed. Initial version is 1.',
  `reporting_rate_fps` INT COMMENT 'PMU reporting rate in frames per second. Common rates are 30, 60, or 120 FPS. Higher rates provide better temporal resolution for transient event analysis.',
  `rocof_hz_per_second` DECIMAL(10,6) COMMENT 'Rate of change of frequency measured in Hz per second. High ROCOF values indicate rapid frequency excursions and potential grid instability events requiring immediate response.',
  `substation_name` STRING COMMENT 'Name of the substation where the PMU device is installed. Provides geographic and operational context for the measurement.',
  `time_quality_flag` STRING COMMENT 'GPS time synchronization status. Locked indicates accurate GPS time; unlocked indicates loss of GPS signal; holdover indicates operating on internal clock. Valid values: locked|unlocked|holdover|degraded.',
  `total_harmonic_distortion_current_percent` DECIMAL(6,3) COMMENT 'Total harmonic distortion of the current waveform expressed as a percentage. Indicates non-linear load effects and power quality issues.',
  `total_harmonic_distortion_voltage_percent` DECIMAL(6,3) COMMENT 'Total harmonic distortion of the voltage waveform expressed as a percentage. Measures power quality and the presence of harmonic frequencies.',
  `voltage_angle_degrees` DECIMAL(10,6) COMMENT 'Phase angle of the voltage phasor in degrees relative to the system reference. Critical for detecting angular separation and stability issues across the wide-area grid.',
  `voltage_level_kv` DECIMAL(8,2) COMMENT 'Nominal voltage level of the bus or circuit where the PMU is measuring. Common transmission levels include 115, 230, 345, 500, and 765 kV.',
  `voltage_magnitude_kv` DECIMAL(12,6) COMMENT 'Magnitude of the voltage phasor measured in kilovolts. Represents the RMS voltage at the PMU measurement point.',
  `zero_sequence_voltage_kv` DECIMAL(12,6) COMMENT 'Zero sequence component of the three-phase voltage in kilovolts. Indicates ground faults and neutral voltage displacement.',
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
  CONSTRAINT `pk_grid_pmu_measurement` PRIMARY KEY (`pmu_measurement_id`)
)
USING DELTA
COMMENT 'Time-series record of Phasor Measurement Unit (PMU) synchrophasor data ingested from the wide-area measurement system (WAMS) into the OSIsoft PI historian and Silver layer. Captures PMU device reference, UTC timestamp (microsecond precision), voltage phasor magnitude (kV) and angle (degrees), current phasor magnitude (amps) and angle, frequency (Hz), ROCOF (Hz/s), and PDC data quality flags. Supports wide-area situational awareness, oscillation detection, and NERC PRC-002 disturbance monitoring compliance. | CMM: CIM AnalogValue (close), IEC61970::Meas.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PmuMeasurement',
  'cmm.cim.class' = 'AnalogValue',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Meas',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.pmu_measurement',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- PmuDevice  <<CIM RemoteUnit : close>>
CREATE TABLE IF NOT EXISTS `grid`.`pmu_device` (
  `pmu_device_id` BIGINT NOT NULL COMMENT 'Unique identifier for the Phasor Measurement Unit device. Primary key for the PMU device master record.',
  `control_area_id` BIGINT COMMENT 'Reference to the balancing authority or control area responsible for the grid region where this PMU is deployed.',
  `distribution_substation_id` BIGINT COMMENT 'Reference to the substation where the PMU device is physically installed and commissioned.',
  `ems_node_id` BIGINT COMMENT 'FK to grid.ems_node.ems_node_id — PMU devices monitor specific buses/lines in the EMS network model. FK to ems_node identifies which network element the PMU is measuring — required for WAMS data integration with state estimation.',
  `nerc_cip_asset_id` BIGINT COMMENT 'Foreign key linking to compliance.nerc_cip_asset. Business justification: PMUs at control centers and critical substations are BES Cyber Assets under NERC CIP-002. Each PMU must be categorized and tracked in the CIP asset inventory for CIP-007 and CIP-010 compliance (system',
  `registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: PMU devices are capital assets requiring maintenance, calibration, warranty tracking, depreciation accounting, and spare parts inventory management. Asset management systems need direct linkage to tra',
  `commissioning_date` DATE COMMENT 'Date when the PMU device was commissioned and began operational data reporting in the WAMS network.',
  `communication_protocol` STRING COMMENT 'Network protocol used by the PMU to transmit synchrophasor data to the PDC (IEEE C37.118, IEC 61850-90-5, DNP3, or Modbus TCP). Valid values: ieee_c37_118|iec_61850_90_5|dnp3|modbus_tcp.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this PMU device record was first created in the system.',
  `critical_infrastructure_flag` BOOLEAN COMMENT 'Indicates whether this PMU device is designated as critical infrastructure requiring enhanced cybersecurity and physical security controls per NERC CIP standards.',
  `data_latency_ms` INT COMMENT 'Typical end-to-end latency in milliseconds from PMU measurement to PDC receipt, critical for real-time wide-area monitoring applications.',
  `data_quality_threshold_pct` DECIMAL(5,2) COMMENT 'Minimum acceptable data quality percentage for this PMU device, below which alarms are triggered for investigation.',
  `data_source_system` STRING COMMENT 'Name of the source system or application from which this PMU device master data originated (e.g., WAMS configuration system, asset registry, EMS).',
  `device_name` STRING COMMENT 'Human-readable name or label assigned to the PMU device for operational identification and reference in WAMS configuration.',
  `device_serial_number` STRING COMMENT 'Manufacturer-assigned unique serial number for the PMU hardware unit, used for warranty tracking and asset management.',
  `device_type` STRING COMMENT 'Classification of the PMU device form factor: standalone dedicated PMU, relay with embedded PMU functionality, meter with embedded PMU, or portable PMU for temporary deployment. Valid values: standalone_pmu|relay_embedded_pmu|meter_embedded_pmu|portable_pmu.',
  `firmware_version` STRING COMMENT 'Current firmware version installed on the PMU device, critical for compatibility and feature support in synchrophasor data collection.',
  `gps_sync_source` STRING COMMENT 'Time synchronization method used by the PMU to achieve microsecond-level timestamp accuracy required for synchrophasor measurements (GPS antenna, IRIG-B, Precision Time Protocol, Network Time Protocol, or internal clock). Valid values: gps_antenna|irig_b|ptp_ieee1588|ntp|internal_clock.',
  `installation_date` DATE COMMENT 'Date when the PMU device was physically installed at the substation location, which may precede commissioning date.',
  `interconnection_name` STRING COMMENT 'Name of the major North American power grid interconnection where the PMU is deployed (Eastern, Western, Texas, or Quebec). Valid values: eastern|western|texas|quebec.',
  `ip_address` STRING COMMENT 'Network IP address assigned to the PMU device for communication with the PDC and WAMS applications.',
  `last_calibration_date` DATE COMMENT 'Date of the most recent calibration or accuracy verification test performed on the PMU device to ensure measurement quality.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this PMU device record was most recently modified.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the PMU device installation location in decimal degrees.',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the PMU device installation location in decimal degrees.',
  `maintenance_contract_number` STRING COMMENT 'Reference number for the maintenance service contract covering this PMU device.',
  `manufacturer` STRING COMMENT 'Name of the company that manufactured the PMU device (e.g., SEL, GE, ABB, Schweitzer Engineering Laboratories).',
  `model` STRING COMMENT 'Manufacturer model number or designation for the PMU device, identifying the specific product line and capabilities.',
  `monitored_bus_name` STRING COMMENT 'Name of the electrical bus or node that this PMU is monitoring for voltage phasor measurements.',
  `monitored_line_name` STRING COMMENT 'Name of the transmission line or branch that this PMU is monitoring for current phasor and power flow measurements.',
  `nerc_prc_002_registered` BOOLEAN COMMENT 'Indicates whether this PMU device is registered with NERC as part of the disturbance monitoring equipment required under PRC-002 reliability standard.',
  `nerc_region` STRING COMMENT 'North American Electric Reliability Corporation regional entity jurisdiction where the PMU is located (WECC, ERCOT, MRO, NPCC, RF, SERC, SPP, TRE). Reference-value candidates: WECC|ERCOT|MRO|NPCC|RF|SERC|SPP|TRE.',
  `nerc_registration_code` STRING COMMENT 'NERC-assigned registration identifier for this PMU device when registered under PRC-002 disturbance monitoring requirements.',
  `next_calibration_due_date` DATE COMMENT 'Scheduled date for the next required calibration or accuracy verification test of the PMU device.',
  `notes` STRING COMMENT 'Free-form text field for additional notes, comments, or special considerations related to the PMU device configuration or operation.',
  `operational_status` STRING COMMENT 'Current operational state of the PMU device in the WAMS network, indicating whether it is actively reporting synchrophasor data. Valid values: in_service|out_of_service|testing|maintenance|decommissioned|standby.',
  `operator_organization` STRING COMMENT 'Name of the utility or organization responsible for operating and maintaining the PMU device, which may differ from the owner.',
  `owner_organization` STRING COMMENT 'Name of the utility or organization that owns the PMU device asset.',
  `pdc_reference` BIGINT COMMENT 'Reference to the Phasor Data Concentrator that aggregates and time-aligns synchrophasor data from this PMU device.',
  `pdc_stream_reference` STRING COMMENT 'Unique stream identifier or channel number assigned by the PDC for this PMU data feed.',
  `pi_tag_prefix` STRING COMMENT 'Prefix used for all OSIsoft PI historian tags associated with this PMU device, enabling integration with PI for synchrophasor data archival and analytics.',
  `reporting_rate_fps` INT COMMENT 'Number of synchrophasor data frames transmitted per second by the PMU device, typically 30, 60, or 120 frames per second depending on application requirements.',
  `retirement_date` DATE COMMENT 'Date when the PMU device was decommissioned and removed from operational service in the WAMS network.',
  `total_error_vector_limit_pct` DECIMAL(5,2) COMMENT 'Maximum allowable Total Error Vector percentage for synchrophasor measurements, per IEEE C37.118 accuracy requirements.',
  `voltage_level_kv` DECIMAL(10,3) COMMENT 'Nominal voltage level in kilovolts of the electrical equipment being monitored by the PMU device.',
  `warranty_expiration_date` DATE COMMENT 'Date when the manufacturer warranty coverage for the PMU device expires.',
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
  CONSTRAINT `pk_grid_pmu_device` PRIMARY KEY (`pmu_device_id`)
)
USING DELTA
COMMENT 'Master record for each Phasor Measurement Unit (PMU) deployed in the wide-area measurement system (WAMS). Captures PMU device name, manufacturer, model, firmware version, GPS synchronization source, reporting rate (frames/second), installed substation reference, monitored bus/line, PDC (Phasor Data Concentrator) assignment, commissioning date, and NERC PRC-002 registration status. SSOT for PMU device inventory used in WAMS configuration and synchrophasor data quality management. | CMM: CIM RemoteUnit (close), IEC61970::SCADA.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PmuDevice',
  'cmm.cim.class' = 'RemoteUnit',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::SCADA',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.pmu_device',
  'cmm.gis.location.role' = 'PowerSystemResource.Location'
);

-- OperatorLog  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `grid`.`operator_log` (
  `operator_log_id` BIGINT NOT NULL COMMENT 'Unique identifier for the operator log entry. Primary key for the operator log record.',
  `audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: Operator logs are primary evidence during NERC audits for TOP and IRO standards. Auditors review logs to verify operator actions during system events and compliance with operating procedures. This lin',
  `employee_id` BIGINT COMMENT 'Unique identifier of the system operator who created the log entry. Used for accountability, audit trails, and NERC compliance verification.',
  `ems_node_id` BIGINT COMMENT 'Reference to the EMS node or bus associated with the log entry. Applicable when the entry relates to a specific electrical node in the network model.',
  `event_id` BIGINT COMMENT 'Foreign key linking to outage.outage_event. Business justification: Operators log actions during outage events for audit trail, shift handover, and regulatory compliance. Linking enables comprehensive event reconstruction and NERC compliance documentation.',
  `operator_scada_point_id` BIGINT COMMENT 'Reference to the SCADA telemetry point associated with the log entry. Links the entry to specific real-time measurement or control points.',
  `primary_operator_control_area_id` BIGINT COMMENT 'Reference to the control area or balancing authority area where the logged event occurred. Links the entry to the responsible operational jurisdiction.',
  `registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: Operators frequently log observations about specific equipment (unusual noise, oil leak, temperature anomaly, visual damage). These narrative entries feed asset condition assessments, health index cal',
  `scada_point_id` BIGINT COMMENT 'FK to grid.scada_point.scada_point_id — After merging ems_alarm and voltage_control_action into operator_log, alarm entries reference associated SCADA points. Required for alarm-to-measurement correlation.',
  `shift_assignment_id` BIGINT COMMENT 'Identifier for the operational shift during which the log entry was created. Links entries to specific shift periods for crew accountability and handover analysis.',
  `state_estimation_run_id` BIGINT COMMENT 'Reference to the state estimation solution run active at the time of the log entry. Links operator actions to the network state model.',
  `abnormal_condition_category` STRING COMMENT 'Classification of the abnormal condition when entry_type is abnormal_condition_noted. Categorizes the type of operational anomaly observed. Valid values: frequency_deviation|voltage_deviation|equipment_malfunction|weather_impact|load_forecast_error|other.',
  `ace_mw` DECIMAL(10,2) COMMENT 'Area control error in megawatts at the time of the log entry. Key metric for balancing authority performance and CPS compliance.',
  `agc_mode_at_entry` STRING COMMENT 'Operating mode of the automatic generation control system at the time of the log entry. Documents the AGC state for operational context. Valid values: automatic|manual|off.',
  `alarm_acknowledgment_timestamp` TIMESTAMP COMMENT 'Date and time when the alarm was acknowledged by the operator. Used for alarm response time analysis and operator performance metrics.',
  `alarm_clearance_timestamp` TIMESTAMP COMMENT 'Date and time when the alarm condition was cleared or resolved. Marks the end of the alarm lifecycle for duration analysis.',
  `alarm_message_text` STRING COMMENT 'System-generated alarm message text when entry_type is alarm. Captures the exact alarm notification presented to the operator.',
  `alarm_priority` STRING COMMENT 'Priority classification of the alarm when entry_type is alarm. Indicates the operational severity and required response urgency. Valid values: critical|major|minor.',
  `alarm_type` STRING COMMENT 'Classification of the alarm when entry_type is alarm. Categorizes the nature of the alarm condition for alarm management and performance tracking. Valid values: limit_violation|equipment_status_change|communication_failure|protection_relay_operation|other.',
  `communication_method` STRING COMMENT 'Method or channel used for the communication when entry_type is verbal_communication. Documents the communication medium for audit purposes. Valid values: phone|radio|ems_messaging|email|other.',
  `communication_party` STRING COMMENT 'Identifier or name of the external party involved in the communication when entry_type is verbal_communication. May include other control areas, reliability coordinators, or field personnel.',
  `contingency_analysis_flag` BOOLEAN COMMENT 'Flag indicating whether the log entry is related to a contingency analysis result or violation. Links operator actions to contingency assessment outcomes.',
  `control_initiating_cause` STRING COMMENT 'Classification of what triggered the voltage control action. Distinguishes between automatic system responses, manual operator interventions, scheduled actions, and emergency responses. Valid values: automatic|operator_manual|scheduled|emergency.',
  `controlled_device` STRING COMMENT 'Identifier or name of the device that was controlled when entry_type is voltage_control_action. Specifies the equipment operated for voltage regulation.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the operator log record was first created in the lakehouse silver layer. Audit field for data lineage tracking.',
  `entry_narrative` STRING COMMENT 'Free-text narrative description of the operator action, observation, or event. Provides detailed context and operator commentary for post-event analysis and regulatory review.',
  `entry_timestamp` TIMESTAMP COMMENT 'Date and time when the operator log entry was recorded in the EMS system. This is the principal event timestamp for the log entry, critical for chronological reconstruction of grid operations and NERC TOP-001 compliance.',
  `entry_type` STRING COMMENT 'Classification of the operator log entry type. Discriminates between operator actions, system alarms, voltage control activities, communications, abnormal conditions, and switching orders. Valid values: action_taken|alarm|voltage_control_action|verbal_communication|abnormal_condition_noted|switching_order_issued.',
  `equipment_reference` STRING COMMENT 'Free-text reference to the equipment, device, or facility associated with the log entry. May include breaker names, transformer IDs, line designations, or substation names.',
  `frequency_hz` DECIMAL(6,3) COMMENT 'System frequency in hertz at the time of the log entry. Critical measurement for frequency regulation and NERC BAL standard compliance.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the operator log record was last modified in the lakehouse silver layer. Audit field for change tracking.',
  `mvar_change` DECIMAL(10,2) COMMENT 'Change in reactive power in megavolt-amperes reactive resulting from the voltage control action. Quantifies the reactive power adjustment made.',
  `nerc_reportable_event` BOOLEAN COMMENT 'Flag indicating whether the logged event meets NERC EOP-004 criteria for mandatory event reporting. Used for regulatory compliance tracking.',
  `notes` STRING COMMENT 'Additional free-text notes or comments added by operators or analysts during post-event review. Supplementary information for investigation and compliance documentation.',
  `pi_tag_name` STRING COMMENT 'OSIsoft PI historian tag name associated with the log entry. Links the operator log to time-series telemetry data for integrated analysis.',
  `post_action_voltage_kv` DECIMAL(10,3) COMMENT 'Voltage level in kilovolts measured after the voltage control action was completed. Result measurement for evaluating control effectiveness.',
  `pre_action_voltage_kv` DECIMAL(10,3) COMMENT 'Voltage level in kilovolts measured before the voltage control action was taken. Baseline measurement for evaluating control effectiveness.',
  `priority_level` STRING COMMENT 'Operational priority or severity level assigned to the log entry. Used for filtering critical events and prioritizing post-event review activities. Valid values: critical|high|medium|low|informational.',
  `reliability_coordinator_notified` BOOLEAN COMMENT 'Flag indicating whether the reliability coordinator was notified of the event or condition. Critical for NERC TOP-001 compliance verification.',
  `source_system` STRING COMMENT 'Name of the source system that generated or recorded the operator log entry. Typically the EMS, SCADA, or operator logging application.',
  `switching_order_number` STRING COMMENT 'Unique identifier of the switching order when entry_type is switching_order_issued. Links the log entry to the formal switching procedure documentation.',
  `to_switching_order` BIGINT COMMENT 'FK to grid.switching_order.switching_order_id — Operator log entries frequently reference switching orders being issued or executed. This FK enables audit trail linkage between operator actions and switching operations for NERC TOP compliance.',
  `voltage_control_type` STRING COMMENT 'Classification of the voltage control action when entry_type is voltage_control_action. Identifies the specific control mechanism employed. Valid values: capacitor_bank_switching|reactor_switching|transformer_tap_change|generator_var_dispatch|other.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_operator_log` PRIMARY KEY (`operator_log_id`)
)
USING DELTA
COMMENT 'Chronological record of all system operator actions, EMS alarms, voltage control actions, and observations recorded during grid operations. Operator log attributes include entry timestamp, operator ID, shift reference, entry type (action taken, alarm, voltage control action, verbal communication, abnormal condition noted, switching order issued), free-text narrative, associated equipment or event reference, and priority level. Alarm attributes (entry_type=alarm) include alarm type (limit violation, equipment status change, communication failure, protection relay operation), alarm priority (critical/major/minor), associated SCADA point or EMS node, alarm message text, acknowledgment timestamp, and clearance timestamp. Voltage control attributes (entry_type=voltage_control) include control type (capacitor bank switching, reactor switching, transformer tap change, generator VAR dispatch), controlled device, pre/post-action voltage (kV), MVAR change, and initiating cause (automatic/operator). SSOT for the unified operational event log required by NERC TOP-001, NERC FAC-001 voltage profile compliance, alarm management performance tracking, post-event investigations, and regulatory audits. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'OperatorLog',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.operator_log'
);

-- EmsAlarm  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `grid`.`ems_alarm` (
  `ems_alarm_id` BIGINT NOT NULL COMMENT 'Unique identifier for the EMS alarm record. Primary key for the alarm transaction.',
  `audit_finding_id` BIGINT COMMENT 'Foreign key linking to compliance.audit_finding. Business justification: EMS alarms indicating limit violations or equipment failures can be audit findings under NERC TOP or FAC standards. Auditors review alarm response times and operator actions. This link enables finding',
  `control_area_id` BIGINT COMMENT 'Reference to the control area or balancing authority responsible for the grid segment where the alarm originated. Supports multi-area alarm management and NERC reporting.',
  `distribution_substation_id` BIGINT COMMENT 'Reference to the substation where the alarm condition originated, enabling geographic and asset-based alarm analysis.',
  `emergency_stock_event_id` BIGINT COMMENT 'Foreign key linking to supply.emergency_stock_event. Business justification: Critical EMS alarms (equipment failure, thermal overload) may trigger emergency material deployment for equipment replacement before catastrophic failure. Links alarm escalation to emergency stock mob',
  `employee_id` BIGINT COMMENT 'User ID or employee identifier of the operator who acknowledged the alarm. Supports accountability and audit trail for alarm handling.',
  `ems_node_id` BIGINT COMMENT 'Reference to the EMS node (bus) associated with the alarm, if the alarm pertains to a specific electrical node in the power system model.',
  `ems_scada_point_id` BIGINT COMMENT 'Reference to the SCADA point that triggered the alarm, if the alarm is associated with a specific telemetry measurement or control point.',
  `event_id` BIGINT COMMENT 'Foreign key linking to outage.outage_event. Business justification: EMS alarms (voltage violations, equipment overloads) may trigger or result from outages. Linking enables alarm correlation, root cause analysis, and coordinated response between transmission and distr',
  `registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: EMS alarms often indicate asset-level issues (overheating transformer, breaker failure, capacitor bank malfunction). Linking alarms to asset records enables automated work order creation, asset health',
  `scada_point_id` BIGINT COMMENT 'FK to grid.scada_point.scada_point_id — EMS alarms are triggered by SCADA point limit violations or status changes. The FK to scada_point identifies which measurement or status point generated the alarm — essential for alarm management and',
  `acknowledged_by_operator_name` STRING COMMENT 'Full name of the operator who acknowledged the alarm. Provides human-readable audit trail for alarm management.',
  `acknowledgment_timestamp` TIMESTAMP COMMENT 'Date and time when the alarm was acknowledged by an operator. Null if the alarm has not yet been acknowledged. Used to track operator response time and alarm management performance.',
  `alarm_category` STRING COMMENT 'High-level categorization of the alarm for filtering and reporting purposes. Groups alarms into operational, equipment, communication, protection, system, and security categories. Valid values: operational|equipment|communication|protection|system|security.',
  `alarm_duration_seconds` INT COMMENT 'Total duration in seconds from alarm generation to clearance. Calculated field used for alarm management performance analysis and NERC TOP situational awareness metrics.',
  `alarm_message` STRING COMMENT 'Detailed textual description of the alarm condition generated by the EMS system. Provides context and specifics about the abnormal condition for operator situational awareness.',
  `alarm_number` STRING COMMENT 'Business identifier for the alarm, typically a sequential or formatted alarm number assigned by the EMS system for operator reference and tracking.',
  `alarm_source` STRING COMMENT 'Identifies the functional source or subsystem within the EMS that generated the alarm: SCADA telemetry, state estimator, contingency analysis, AGC, protection system, or manual operator entry. Valid values: scada|state_estimator|contingency_analysis|agc|protection_system|operator_entry.',
  `alarm_state` STRING COMMENT 'Current lifecycle state of the alarm. Active indicates the condition persists and has not been acknowledged. Acknowledged means an operator has reviewed it. Cleared indicates the condition has resolved. Suppressed and shelved indicate operator-managed alarm filtering. Valid values: active|acknowledged|cleared|suppressed|shelved.',
  `alarm_timestamp` TIMESTAMP COMMENT 'The precise date and time when the alarm condition was detected and generated by the SCADA/EMS system. This is the principal business event timestamp for the alarm.',
  `alarm_type` STRING COMMENT 'Classification of the alarm based on the nature of the abnormal condition detected. Includes limit violations, equipment status changes, communication failures, protection relay operations, state estimation failures, and topology changes. Valid values: limit_violation|equipment_status_change|communication_failure|protection_relay_operation|state_estimation_failure|topology_change.',
  `balancing_authority` STRING COMMENT 'Name or code of the balancing authority responsible for the area where the alarm occurred. Used for coordination and regulatory reporting.',
  `clearance_timestamp` TIMESTAMP COMMENT 'Date and time when the alarm condition was resolved and the alarm was cleared. Null if the alarm is still active. Used to calculate alarm duration and system performance metrics.',
  `contingency_flag` BOOLEAN COMMENT 'Indicates whether the alarm is related to a contingency analysis violation or post-contingency condition. True if the alarm resulted from contingency analysis.',
  `corrective_action` STRING COMMENT 'Description of the corrective action taken to resolve the alarm condition. Used for operational documentation and continuous improvement.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this alarm record was first inserted into the data system. Used for data lineage and audit trail purposes.',
  `data_source_system` STRING COMMENT 'Name or identifier of the source system that provided this alarm record, such as the specific EMS vendor system or SCADA master. Supports multi-system data integration and lineage tracking.',
  `disturbance_flag` BOOLEAN COMMENT 'Indicates whether the alarm is associated with a system disturbance event requiring NERC reporting. True if the alarm is part of a reportable disturbance.',
  `ems_system_name` STRING COMMENT 'Name or identifier of the EMS system that generated the alarm. Supports multi-EMS environments and system-specific alarm analysis.',
  `engineering_unit` STRING COMMENT 'Unit of measure for the limit value and measured value, such as MW, MVAR, kV, Amps, Hz, or degrees. Essential for interpreting alarm magnitude.',
  `equipment_name` STRING COMMENT 'Human-readable name or designation of the specific equipment associated with the alarm, as known to operators and maintenance personnel.',
  `equipment_type` STRING COMMENT 'Type of equipment associated with the alarm condition, such as transformer, breaker, line, generator, capacitor bank, or relay. Supports equipment-specific alarm analysis.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this alarm record was last modified. Tracks changes to alarm state, acknowledgment, clearance, or operator notes.',
  `limit_type` STRING COMMENT 'For limit violation alarms, specifies the type of limit that was exceeded: high, low, high-high (critical high), low-low (critical low), rate of change, or deadband violation. Valid values: high|low|high_high|low_low|rate_of_change|deadband.',
  `limit_value` DECIMAL(18,6) COMMENT 'The threshold value that was exceeded to trigger the alarm. Provides context for the severity of the limit violation.',
  `measured_value` DECIMAL(18,6) COMMENT 'The actual measured value at the time the alarm was triggered. Allows operators to assess the magnitude of the deviation from normal or limit conditions.',
  `nerc_region` STRING COMMENT 'NERC regional entity code (e.g., WECC, ERCOT, NPCC, SERC, MRO, RFC, SPP, TRE) for the geographic region where the alarm originated. Required for NERC compliance reporting.',
  `nerc_reportable_flag` BOOLEAN COMMENT 'Indicates whether the alarm condition meets NERC criteria for mandatory event reporting under EOP-004 or other reliability standards. True if reportable to NERC.',
  `operator_notes` STRING COMMENT 'Free-text notes entered by operators regarding the alarm, including actions taken, root cause observations, or coordination with other entities. Supports knowledge capture and post-event review.',
  `pi_tag_name` STRING COMMENT 'OSIsoft PI historian tag name associated with the alarm, enabling integration with PI data for post-event analysis and trending.',
  `priority_level` STRING COMMENT 'Severity classification of the alarm indicating the urgency of operator response required. Critical alarms require immediate action, major alarms require prompt attention, minor alarms are monitored, and informational alarms are logged for awareness. Valid values: critical|major|minor|informational.',
  `related_alarm_count` INT COMMENT 'Number of related or cascading alarms that occurred within a defined time window of this alarm. Helps identify alarm floods and system-wide events.',
  `response_time_seconds` INT COMMENT 'Time in seconds from alarm generation to operator acknowledgment. Key performance indicator for alarm management and operator situational awareness.',
  `root_cause_code` STRING COMMENT 'Standardized code identifying the root cause of the alarm condition, assigned during post-event analysis. Supports trending and reliability improvement initiatives.',
  `rtu_reference` BIGINT COMMENT 'Reference to the RTU that reported the alarm condition, if applicable. Links alarm to field communication infrastructure.',
  `suppression_rule` STRING COMMENT 'Name or identifier of the alarm suppression rule applied to this alarm, if any. Supports intelligent alarm management and reduction of alarm floods.',
  `voltage_level_kv` DECIMAL(10,3) COMMENT 'Nominal voltage level in kilovolts of the equipment or node associated with the alarm. Critical for prioritizing alarms based on system criticality.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_ems_alarm` PRIMARY KEY (`ems_alarm_id`)
)
USING DELTA
COMMENT 'Transactional record of EMS alarms generated by the SCADA/EMS system for abnormal conditions on the grid. Captures alarm timestamp, alarm type (limit violation, equipment status change, communication failure, protection relay operation), priority level (critical/major/minor), associated SCADA point or EMS node, alarm message text, operator acknowledgment timestamp, operator ID, and alarm clearance timestamp. Supports NERC TOP situational awareness requirements and alarm management performance tracking. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'EmsAlarm',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.ems_alarm'
);

-- GridReliabilityEvent  <<CIM PSREvent : extension>>
CREATE TABLE IF NOT EXISTS `grid`.`grid_reliability_event` (
  `grid_reliability_event_id` BIGINT NOT NULL COMMENT 'Unique identifier for the grid reliability event record. Primary key for the grid reliability event entity.',
  `audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: NERC and regional entities audit reliability events (especially EOP-004 reportable events) to verify utility response and compliance. This link tracks which events were examined during compliance audi',
  `control_area_id` BIGINT COMMENT 'Reference to the control area or balancing authority where the reliability event occurred.',
  `emergency_stock_event_id` BIGINT COMMENT 'Foreign key linking to supply.emergency_stock_event. Business justification: NERC-reportable reliability events (OE-417 reports) trigger emergency procurement and mutual aid material requests. Essential for tracking restoration material costs, FEMA reimbursement documentation,',
  `event_id` BIGINT COMMENT 'Foreign key linking to outage.outage_event. Business justification: Grid reliability events (NERC reportable) often involve customer outages. Linking enables consolidated DOE OE-417 reporting, reliability metrics calculation, and regulatory compliance documentation.',
  `operator_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: NERC reliability events (OE-417 reports) require documented operator accountability. \'operator_on_duty\' text field should be FK to employee for regulatory audit trails and operator performance analysi',
  `safety_incident_id` BIGINT COMMENT 'Foreign key linking to workforce.safety_incident. Business justification: NERC reliability events can involve personnel safety incidents. Linking enables correlation of NERC OE-417 reports with OSHA recordables for comprehensive event investigation and regulatory reporting.',
  `affected_facilities` STRING COMMENT 'Comma-separated list or free-text description of generation plants, substations, transmission lines, and other facilities impacted by the reliability event.',
  `corrective_actions_taken` STRING COMMENT 'Detailed description of immediate corrective actions and operator interventions taken to mitigate and resolve the reliability event. Includes switching orders, generation redispatch, and emergency procedures.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this reliability event record was first created in the system, in UTC. Audit field for data lineage and record lifecycle tracking.',
  `customers_affected_count` INT COMMENT 'Number of customer accounts impacted by the reliability event, if the event resulted in customer outages. Used for regulatory reporting and impact assessment.',
  `data_source_system` STRING COMMENT 'Name of the source system or application that created or last updated this reliability event record. Used for data lineage and integration troubleshooting.',
  `ems_system_name` STRING COMMENT 'Name of the EMS system that detected and recorded the reliability event. Used for data lineage and system integration.',
  `event_duration_minutes` DECIMAL(10,2) COMMENT 'Total duration of the reliability event from start to resolution, measured in minutes. Calculated from event start and end timestamps.',
  `event_end_timestamp` TIMESTAMP COMMENT 'Date and time when the reliability event was resolved or system returned to normal operating conditions, in UTC. Null if event is still ongoing.',
  `event_start_timestamp` TIMESTAMP COMMENT 'Date and time when the reliability event was first detected or initiated, in UTC. This is the principal business event timestamp for the reliability event.',
  `event_status` STRING COMMENT 'Current lifecycle status of the reliability event in the investigation and resolution workflow. Valid values: open|under_investigation|corrective_action_pending|resolved|closed|reported_to_nerc.',
  `event_type` STRING COMMENT 'Classification of the reliability event according to NERC reporting categories. Determines which NERC standards and reporting requirements apply. Reference-value candidates: disturbance|emergency|unusual_occurrence|frequency_excursion|voltage_excursion|load_shed|generation_loss|transmission_loss|islanding.',
  `frequency_excursion_duration_seconds` DECIMAL(10,2) COMMENT 'Duration of the frequency excursion from initial deviation to recovery within acceptable limits, measured in seconds. Used for NERC BAL-003 compliance assessment.',
  `frequency_excursion_flag` BOOLEAN COMMENT 'Indicates whether this event involved a system frequency excursion outside normal operating limits. True if frequency deviated beyond acceptable thresholds per NERC BAL-003.',
  `frequency_excursion_trigger` STRING COMMENT 'Specific triggering cause of the frequency excursion event. Categorizes the type of disturbance that caused frequency deviation. Valid values: generation_trip|load_loss|islanding|tie_line_trip|other.',
  `initiating_cause` STRING COMMENT 'Root cause or triggering event that initiated the reliability event. Free-text description of the primary causal factor (e.g., generator trip, transmission line fault, equipment failure, weather event).',
  `initiating_cause_category` STRING COMMENT 'Standardized classification of the root cause category for analytics and trend analysis. Aligns with NERC cause code taxonomy. Reference-value candidates: equipment_failure|weather|human_error|cyber_security|physical_security|fuel_supply|load_forecast_error|unknown|other.',
  `interconnection_name` STRING COMMENT 'North American interconnection in which the reliability event occurred. Determines applicable reliability standards and coordination requirements. Valid values: eastern|western|texas|quebec.',
  `investigation_complete_flag` BOOLEAN COMMENT 'Indicates whether the root cause investigation and analysis of the reliability event has been completed. True when final investigation report is approved.',
  `investigation_report_url` STRING COMMENT 'URL or file path to the detailed investigation report document for this reliability event. Used for audit trail and knowledge repository access.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this reliability event record was most recently modified, in UTC. Audit field for change tracking and data quality monitoring.',
  `lessons_learned` STRING COMMENT 'Summary of key lessons learned from the reliability event investigation. Used for knowledge management and continuous improvement of grid operations.',
  `mw_impact` DECIMAL(12,2) COMMENT 'Total megawatt impact of the reliability event, representing generation loss, load shed, or transmission capacity reduction. Positive value indicates magnitude of impact.',
  `nadir_frequency_hz` DECIMAL(6,3) COMMENT 'Lowest system frequency reached during a frequency excursion event, measured in Hertz. Applicable only when event_type is frequency_excursion. Critical metric for NERC BAL-003 frequency response obligation.',
  `nerc_oe417_report_number` STRING COMMENT 'Reference number for the DOE OE-417 Electric Emergency Incident and Disturbance Report filed for this event, if applicable. Used to track regulatory submission.',
  `nerc_region` STRING COMMENT 'NERC regional entity with jurisdiction over the control area where the event occurred. Determines regional compliance and reporting requirements. Reference-value candidates: WECC|ERCOT|MRO|NPCC|RF|SERC|TRE|SPP.',
  `nerc_reportable_flag` BOOLEAN COMMENT 'Indicates whether this event meets NERC criteria for mandatory reporting to regulatory authorities. True if event must be reported per NERC EOP-004.',
  `nerc_standard_applicability` STRING COMMENT 'Comma-separated list of applicable NERC reliability standards triggered by this event (e.g., EOP-004, BAL-003, TOP-001). Determines regulatory reporting obligations.',
  `nerc_submission_status` STRING COMMENT 'Status of regulatory report submission to NERC and other governing bodies. Tracks compliance with mandatory reporting timelines. Valid values: not_required|pending|submitted|acknowledged|under_review|closed.',
  `nerc_submission_timestamp` TIMESTAMP COMMENT 'Date and time when the event report was submitted to NERC or other regulatory authorities, in UTC. Used to verify compliance with reporting deadlines.',
  `notes` STRING COMMENT 'Additional free-form notes and comments about the reliability event. Used for supplementary information not captured in structured fields.',
  `pi_historian_tag_prefix` STRING COMMENT 'Tag prefix in the OSIsoft PI historian system for retrieving detailed telemetry data associated with this reliability event. Enables post-event analysis and forensics.',
  `preventive_actions_recommended` STRING COMMENT 'Recommended preventive measures and long-term corrective actions to prevent recurrence of similar reliability events. Used for continuous improvement and reliability planning.',
  `recovery_frequency_hz` DECIMAL(6,3) COMMENT 'System frequency after initial recovery and stabilization following a frequency excursion, measured in Hertz. Used to assess frequency response adequacy.',
  `restoration_timestamp` TIMESTAMP COMMENT 'Date and time when all affected facilities and customer load were fully restored to normal service following the reliability event, in UTC.',
  `rocof_hz_per_second` DECIMAL(8,4) COMMENT 'Maximum rate of change of frequency during the excursion event, measured in Hertz per second. Critical parameter for assessing system inertia and frequency response performance.',
  `rto_iso_name` STRING COMMENT 'Name of the RTO or ISO responsible for grid operations in the affected area, if applicable. Used for coordination and reporting.',
  `scada_snapshot_timestamp` TIMESTAMP COMMENT 'Timestamp of the SCADA system snapshot captured at the time of event detection, in UTC. Used to correlate event data with real-time telemetry.',
  `severity_index` DECIMAL(5,2) COMMENT 'Calculated severity score for the reliability event based on MW impact, duration, frequency deviation, and customer impact. Used for prioritization and trend analysis.',
  `ufls_activation_flag` BOOLEAN COMMENT 'Indicates whether automatic under-frequency load shedding relays were activated during the event. True if UFLS protection operated to arrest frequency decline.',
  `ufls_load_shed_mw` DECIMAL(12,2) COMMENT 'Total amount of load automatically shed by UFLS relays during the frequency excursion, measured in megawatts. Null if UFLS was not activated.',
  `weather_conditions` STRING COMMENT 'Description of weather conditions at the time of the reliability event, if weather was a contributing factor. Includes temperature, wind, precipitation, and severe weather events.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_grid_reliability_event` PRIMARY KEY (`grid_reliability_event_id`)
)
USING DELTA
COMMENT 'Transactional record of reportable reliability events as defined by NERC reliability standards (EOP, TOP, BAL), including frequency excursion events. General event attributes include event date/time, event type (disturbance, emergency, unusual occurrence, frequency excursion), NERC standard applicability, affected facilities, initiating cause, MW impact, duration, corrective actions taken, NERC OE-417 report reference, and regulatory submission status. Frequency excursion attributes (event_type=frequency_excursion) include nadir frequency (Hz), recovery frequency (Hz), ROCOF (Hz/s), excursion duration (seconds), triggering cause (generation trip, load loss, islanding), UFLS activation flag, MW of load shed, and restoration timestamp. SSOT for all NERC reliability event reporting including NERC BAL-003 frequency response obligation — distinct from outage records (owned by outage domain) which focus on customer impact. | CMM: CIM PSREvent (extension), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'GridReliabilityEvent',
  'cmm.cim.class' = 'PSREvent',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.grid_reliability_event'
);

-- OperatingLimit  <<CIM OperationalLimit : exact>>
CREATE TABLE IF NOT EXISTS `grid`.`operating_limit` (
  `operating_limit_id` BIGINT NOT NULL COMMENT 'Unique identifier for the operating limit record. Primary key for the operating limit entity.',
  `control_area_id` BIGINT COMMENT 'Identifier of the balancing authority responsible for monitoring and enforcing this operating limit. Links to the control area entity for jurisdictional and operational responsibility.',
  `ems_node_id` BIGINT COMMENT 'FK to grid.ems_node.ems_node_id — Operating limits (thermal, voltage, stability) are defined for specific transmission elements and interfaces in the EMS network model, referenced by EMS node or branch. Required for contingency analys',
  `operating_ems_node_id` BIGINT COMMENT 'FK to grid.ems_node.ems_node_id — Operating limits (now including real-time ratings) are defined for transmission elements referenced in the EMS network model. FK to ems_node anchors limits to the network topology.',
  `operating_limit_for_ems_element` BIGINT COMMENT 'FK to grid.ems_node.ems_node_id — Operating limits and real-time ratings apply to specific transmission elements referenced by EMS nodes/branches. Required for contingency analysis limit checking and operator displays.',
  `ambient_temperature_f` DECIMAL(5,2) COMMENT 'Ambient air temperature in degrees Fahrenheit used for ambient-adjusted or dynamic rating calculations. Real-time weather data input for AAR and DLR methodologies.',
  `conductor_temperature_c` DECIMAL(6,2) COMMENT 'Actual or calculated conductor temperature in degrees Celsius. For dynamic line ratings, this may be measured directly via fiber optic sensors or calculated from current flow and weather conditions. Maximum allowable conductor temperature determines thermal rating.',
  `contingency_analysis_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this operating limit is monitored and enforced during EMS contingency analysis (N-1, N-2 studies). True means the limit is included in contingency screening and violation detection.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this operating limit record was first created in the system. Audit trail for data lineage and regulatory compliance.',
  `data_source_system` STRING COMMENT 'Name of the source system that provided this operating limit data (e.g., EMS, DLR system, engineering study database). Used for data lineage, reconciliation, and troubleshooting.',
  `element_name` STRING COMMENT 'Human-readable name of the transmission element (e.g., line name, transformer designation, interface name) for operator displays and reporting.',
  `element_reference` STRING COMMENT 'Unique identifier for the transmission element (line, transformer, interface) to which this operating limit applies. References the network model element in the EMS system.',
  `element_type` STRING COMMENT 'Classification of the transmission element type to which the operating limit applies. Determines the applicable limit categories and rating methodologies. Valid values: transmission_line|transformer|interface|generator|tie_line|bus.',
  `emergency_rating_mva` DECIMAL(10,2) COMMENT 'Emergency operating limit in MVA for the transmission element under post-contingency conditions. This higher rating is allowed for a limited duration (typically 15 minutes to 4 hours) following a system disturbance.',
  `ems_model_version` STRING COMMENT 'Version identifier of the EMS network model in which this operating limit is defined. Critical for change management, model synchronization, and audit trails.',
  `ems_system_name` STRING COMMENT 'Name of the EMS system (e.g., GE ADMS, Siemens Spectrum, ABB Network Manager) that manages and enforces this operating limit. Used for multi-EMS environments and data lineage tracking.',
  `from_bus_name` STRING COMMENT 'Name of the originating bus or substation for transmission line or transformer elements. Defines the topology and network connectivity for EMS modeling.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this operating limit record was last modified. Tracks changes to ratings, limits, or metadata for change management and audit purposes.',
  `limit_type` STRING COMMENT 'Category of operating limit being defined: normal MVA rating, emergency MVA rating, voltage upper limit, voltage lower limit, stability limit in MW, or thermal limit in MW. Determines the constraint type enforced by EMS contingency analysis. Valid values: normal_mva|emergency_mva|voltage_upper_kv|voltage_lower_kv|stability_mw|thermal_mw.',
  `max_conductor_temperature_c` DECIMAL(6,2) COMMENT 'Maximum allowable conductor temperature in degrees Celsius before thermal damage, excessive sag, or loss of tensile strength occurs. Typically 75-100°C for ACSR conductors. Defines the thermal constraint for rating calculations.',
  `nerc_fac_002_study_reference` STRING COMMENT 'Reference identifier for the NERC FAC-002 facility interconnection study or FAC-008 facility ratings methodology study that established this operating limit. Provides traceability to engineering analysis and regulatory compliance documentation.',
  `nerc_region` STRING COMMENT 'NERC regional entity responsible for reliability oversight of this transmission element: WECC (Western), ERCOT (Texas), MRO (Midwest), NPCC (Northeast), RF (ReliabilityFirst), SERC (Southeast), SPP (Southwest), or TRE (Texas RE). Reference-value candidates: WECC|ERCOT|MRO|NPCC|RF|SERC|SPP|TRE.',
  `normal_rating_mva` DECIMAL(10,2) COMMENT 'Normal continuous operating limit in MVA for the transmission element under normal system conditions. This is the baseline capacity used for day-to-day operations and pre-contingency analysis.',
  `notes` STRING COMMENT 'Free-text notes providing additional context, special operating instructions, temporary limit adjustments, or engineering rationale for this operating limit. Used by operators and engineers for situational awareness.',
  `operational_status` STRING COMMENT 'Current operational status of the transmission element and its associated operating limits. In-service limits are actively enforced by EMS; out-of-service limits are inactive due to equipment outages. Valid values: in_service|out_of_service|testing|maintenance|retired.',
  `operator_code` STRING COMMENT 'Code identifying the transmission operator responsible for real-time operation and monitoring of this element and its limits. May differ from owner in joint-use or RTO-operated facilities.',
  `operator_display_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this operating limit is displayed on EMS operator screens and alarm systems. True means operators receive real-time visibility and alarms for limit violations.',
  `owner_code` STRING COMMENT 'Code identifying the transmission asset owner responsible for the physical equipment and its ratings. Used for cost allocation, maintenance responsibility, and regulatory reporting.',
  `pi_tag_name` STRING COMMENT 'OSIsoft PI historian tag name for archiving this operating limit time-series data. Enables historical trending, post-event analysis, and integration with asset performance analytics.',
  `rating_method` STRING COMMENT 'Method used to determine the operating limit: static (fixed rating), seasonal (varies by season), ambient-adjusted (AAR based on weather), or dynamic (DLR with real-time conductor monitoring). Indicates the sophistication and real-time responsiveness of the rating. Valid values: static|seasonal|ambient_adjusted|dynamic.',
  `rating_timestamp` TIMESTAMP COMMENT 'Timestamp when this operating limit or dynamic rating was calculated or became effective. For dynamic ratings, this represents the real-time calculation timestamp. Critical for time-series analysis and operational decision-making.',
  `rto_iso_code` STRING COMMENT 'Code identifying the RTO or ISO market region in which this transmission element operates. Relevant for market-based congestion management and transmission capacity allocation.',
  `season` STRING COMMENT 'Season for which this operating limit is applicable. Seasonal ratings account for ambient temperature variations that affect conductor thermal capacity. Year-round indicates a single rating applies across all seasons. Valid values: summer|winter|spring|fall|year_round.',
  `solar_irradiance_w_per_m2` DECIMAL(7,2) COMMENT 'Solar irradiance in watts per square meter incident on the conductor. Affects conductor heating and is a key input for dynamic line rating calculations, particularly during high solar exposure periods.',
  `stability_limit_mw` DECIMAL(10,2) COMMENT 'Maximum power transfer in MW constrained by system stability considerations (transient stability, voltage stability, or oscillatory stability). Derived from stability studies and enforced to prevent system instability following disturbances.',
  `study_date` DATE COMMENT 'Date when the engineering study establishing this operating limit was completed. Used for tracking study vintage and determining when re-studies are required per NERC standards.',
  `to_bus_name` STRING COMMENT 'Name of the terminating bus or substation for transmission line or transformer elements. Defines the topology and network connectivity for EMS modeling.',
  `validity_end_timestamp` TIMESTAMP COMMENT 'Timestamp when this operating limit expires or is superseded by a new rating. For dynamic ratings, defines the end of the rating validity window. Null indicates an open-ended validity period.',
  `validity_start_timestamp` TIMESTAMP COMMENT 'Timestamp when this operating limit becomes valid and enforceable in EMS operations. For dynamic ratings, defines the beginning of the rating validity window.',
  `voltage_level_kv` DECIMAL(8,2) COMMENT 'Nominal voltage level in kV of the transmission element (e.g., 69 kV, 138 kV, 230 kV, 345 kV, 500 kV). Used for classification, reporting, and determining applicable standards.',
  `voltage_lower_limit_kv` DECIMAL(8,2) COMMENT 'Minimum allowable voltage in kV for the transmission element or bus. Falling below this limit may cause voltage collapse, equipment malfunction, or customer service quality issues. Used by EMS voltage control and contingency analysis.',
  `voltage_upper_limit_kv` DECIMAL(8,2) COMMENT 'Maximum allowable voltage in kV for the transmission element or bus. Exceeding this limit may cause equipment damage or insulation breakdown. Used by EMS voltage control and contingency analysis.',
  `wind_speed_mph` DECIMAL(5,2) COMMENT 'Wind speed in miles per hour at the transmission element location. Critical input for dynamic line rating calculations as wind cooling significantly increases conductor thermal capacity.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_operating_limit` PRIMARY KEY (`operating_limit_id`)
)
USING DELTA
COMMENT 'Master and transactional record defining all operating limits for transmission elements and interfaces — static seasonal ratings, ambient-adjusted ratings (AAR), and dynamic line ratings (DLR) — within the EMS network model. Static/seasonal attributes include element reference (line, transformer, interface), limit type (normal/emergency MVA, voltage upper/lower kV, stability MW), applicable season, ambient temperature condition, and NERC FAC-002 study reference. Dynamic real-time rating attributes (grain: one row per element per rating timestamp) include ambient-adjusted or dynamic normal and emergency MVA, ambient temperature (°F), wind speed (mph), solar irradiance (W/m²), conductor temperature (°C), rating method (static/ambient-adjusted/dynamic), and validity window. SSOT for all operating limits and real-time ratings used by EMS contingency analysis, operator displays, NERC FAC-001/FAC-008 compliance, and transmission capacity optimization. | CMM: CIM OperationalLimit (exact), IEC61970::OperationalLimits.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'OperatingLimit',
  'cmm.cim.class' = 'OperationalLimit',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61970::OperationalLimits',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.operating_limit'
);

-- RealTimeRating  <<CIM OperationalUpdatedRating : close>>
CREATE TABLE IF NOT EXISTS `grid`.`real_time_rating` (
  `real_time_rating_id` BIGINT NOT NULL COMMENT 'Unique identifier for each real-time rating record. Primary key for the real_time_rating product.',
  `control_area_id` BIGINT COMMENT 'Identifier of the balancing authority responsible for this transmission element. Links rating to operational control area.',
  `distribution_substation_id` BIGINT COMMENT 'Identifier of the substation where this transmission element originates or terminates. Links rating to physical grid location.',
  `employee_id` BIGINT COMMENT 'User identifier of the system operator who reviewed or overrode this rating. Supports accountability and audit requirements.',
  `registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: Dynamic line ratings are calculated for specific transmission line and transformer assets. Asset management uses these ratings for thermal aging models, risk-based replacement prioritization, and capi',
  `scada_point_id` BIGINT COMMENT 'Identifier of the SCADA measurement point providing real-time loading or temperature data for this element.',
  `ambient_temperature_f` DECIMAL(6,2) COMMENT 'Measured or forecasted ambient air temperature in degrees Fahrenheit at the element location. Primary environmental input for thermal rating calculations.',
  `circuit_reference` STRING COMMENT 'Circuit identifier distinguishing parallel transmission paths between the same bus pair. Used in switching orders and outage coordination.',
  `conductor_temperature_c` DECIMAL(6,2) COMMENT 'Measured or calculated conductor surface temperature in degrees Celsius. Must not exceed maximum design temperature to prevent annealing and sag violations.',
  `contingency_analysis_flag` BOOLEAN COMMENT 'Indicates whether this rating is actively used in real-time contingency analysis. True for critical elements monitored for N-1 and N-2 contingencies.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this rating record was first inserted into the data platform. Supports data lineage and audit trail requirements.',
  `data_source_system` STRING COMMENT 'Name of the source system or application that generated this rating record (e.g., DLR system, EMS rating module, weather integration service).',
  `element_name` STRING COMMENT 'Human-readable name or designation of the transmission element as known in operational systems and switching orders.',
  `element_reference` STRING COMMENT 'Unique identifier of the transmission element (line, transformer, cable) being rated. References the asset or network element in the EMS model.',
  `element_type` STRING COMMENT 'Type of transmission equipment being rated. Determines applicable rating methodology and thermal limits. Valid values: transmission_line|transformer|cable|series_capacitor|phase_shifting_transformer.',
  `emergency_rating_mva` DECIMAL(12,3) COMMENT 'Real-time emergency thermal rating in megavolt-amperes. Maximum load the element can carry for a limited duration (typically 15 minutes to 4 hours) during contingency conditions.',
  `ems_system_name` STRING COMMENT 'Name of the EMS or SCADA system that received and is using this real-time rating for state estimation and contingency analysis.',
  `from_bus_name` STRING COMMENT 'Name of the originating bus or node in the EMS network model. Defines one end of a transmission line or branch element.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this rating record was last modified. Tracks changes to ratings due to recalculation or operator override.',
  `load_shed_rating_mva` DECIMAL(12,3) COMMENT 'Short-term emergency rating used during system restoration or load shedding events. Highest permissible loading for very brief durations to prevent cascading outages.',
  `max_conductor_temperature_c` DECIMAL(6,2) COMMENT 'Maximum allowable conductor temperature in degrees Celsius per design specifications. Exceeding this limit risks permanent conductor damage and clearance violations.',
  `nerc_region` STRING COMMENT 'NERC regional entity with jurisdiction over this transmission element. Determines applicable reliability standards and reporting requirements. Reference-value candidates: WECC|ERCOT|MRO|NPCC|RF|SERC|TRE|SPP.',
  `normal_rating_mva` DECIMAL(12,3) COMMENT 'Real-time normal (continuous) thermal rating in megavolt-amperes. Maximum load the element can carry indefinitely under current ambient conditions without exceeding design limits.',
  `notes` STRING COMMENT 'Free-text field for additional context, special conditions, or operational notes related to this rating. Used for documentation and knowledge transfer.',
  `operational_status` STRING COMMENT 'Current operational status of the transmission element. Out-of-service elements do not require active rating updates. Valid values: in_service|out_of_service|testing|maintenance|forced_outage.',
  `operator_override_flag` BOOLEAN COMMENT 'Indicates whether a system operator manually overrode the calculated rating. True when operator judgment supersedes automated calculation.',
  `operator_override_reason` STRING COMMENT 'Free-text explanation provided by the operator for manually overriding the calculated rating. Required for audit trail and compliance documentation.',
  `pi_tag_name` STRING COMMENT 'PI historian tag name where this rating value is archived for historical analysis, trending, and post-event review.',
  `rating_calculation_timestamp` TIMESTAMP COMMENT 'Timestamp when the rating calculation algorithm executed. May differ from rating_timestamp if calculation is performed ahead of validity period.',
  `rating_confidence_level` STRING COMMENT 'Overall confidence in the calculated rating based on data quality, sensor availability, and model accuracy. Low confidence may trigger operator alerts. Valid values: high|medium|low.',
  `rating_method` STRING COMMENT 'Methodology used to calculate the real-time rating. Static uses fixed seasonal values; ambient-adjusted incorporates weather; dynamic line rating (DLR) uses real-time sensor data. Valid values: static|seasonal|ambient_adjusted|dynamic_line_rating|real_time_monitoring.',
  `rating_timestamp` TIMESTAMP COMMENT 'Date and time when this real-time rating was calculated and became effective. Represents the moment the rating applies to grid operations.',
  `rating_validity_end_timestamp` TIMESTAMP COMMENT 'Timestamp when this rating expires and must be replaced by a new rating calculation. Ensures stale ratings are not used in operations.',
  `rating_validity_start_timestamp` TIMESTAMP COMMENT 'Timestamp when this rating becomes valid and can be used by EMS for operational decisions and contingency analysis.',
  `rto_iso_code` STRING COMMENT 'Code identifying the RTO or ISO market operator if this element participates in organized wholesale markets.',
  `sag_clearance_ft` DECIMAL(8,3) COMMENT 'Calculated vertical clearance in feet between conductor at current temperature and ground or obstacles. Must maintain minimum clearances per NESC standards.',
  `solar_irradiance_w_per_m2` DECIMAL(8,2) COMMENT 'Solar radiation intensity in watts per square meter. Solar heating reduces available thermal capacity, especially for overhead conductors.',
  `to_bus_name` STRING COMMENT 'Name of the terminating bus or node in the EMS network model. Defines the other end of a transmission line or branch element.',
  `voltage_level_kv` DECIMAL(10,3) COMMENT 'Nominal operating voltage level of the transmission element in kilovolts. Critical for determining thermal and electrical limits.',
  `weather_data_quality_code` STRING COMMENT 'Quality indicator for weather inputs used in rating calculation. Poor quality data may require conservative rating adjustments or operator review. Valid values: good|uncertain|estimated|default|stale.',
  `weather_data_source` STRING COMMENT 'Source of weather data used in rating calculation. Real-time sensors provide highest accuracy; forecasts or seasonal defaults are fallback options. Valid values: scada_sensor|weather_station|forecast_model|satellite|default_seasonal.',
  `wind_direction_degrees` DECIMAL(5,2) COMMENT 'Wind direction in degrees (0-360) relative to true north. Wind angle relative to conductor affects cooling efficiency.',
  `wind_speed_mph` DECIMAL(6,2) COMMENT 'Measured or forecasted wind speed in miles per hour at conductor height. Wind cooling significantly increases thermal capacity of overhead lines.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_real_time_rating` PRIMARY KEY (`real_time_rating_id`)
)
USING DELTA
COMMENT 'Transactional record of dynamic or ambient-adjusted real-time thermal ratings (AAR/DLR) for transmission lines and transformers, replacing static seasonal ratings in the EMS. Captures element reference, rating timestamp, real-time normal rating (MVA), real-time emergency rating (MVA), ambient temperature (°F), wind speed (mph), solar irradiance (W/m²), conductor temperature (°C), rating method (static/ambient-adjusted/dynamic), and validity window. Supports NERC FAC-001 compliance and transmission capacity optimization. | CMM: CIM OperationalUpdatedRating (close), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'RealTimeRating',
  'cmm.cim.class' = 'OperationalUpdatedRating',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.real_time_rating'
);

-- TopologySnapshot  <<CIM TopologicalIsland : broad>>
CREATE TABLE IF NOT EXISTS `grid`.`topology_snapshot` (
  `topology_snapshot_id` BIGINT NOT NULL COMMENT 'Primary key for topology_snapshot',
  `control_area_id` BIGINT COMMENT 'Reference to the control area or balancing authority whose network topology is captured in this snapshot.',
  `employee_id` BIGINT COMMENT 'User identifier of the control center operator who acknowledged or reviewed this topology snapshot.',
  `state_estimation_run_id` BIGINT COMMENT 'Reference to the state estimation run that triggered or is associated with this topology snapshot. Links the topological state to the electrical state analysis.',
  `closed_switching_device_count` INT COMMENT 'Total number of breakers, switches, and other switching devices in the closed position at the time of this snapshot. Closed devices maintain network connectivity.',
  `convergence_status` STRING COMMENT 'Indicates whether the topology processor successfully converged to a valid network connectivity solution for this snapshot. Valid values: converged|non_converged|partial|timeout.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this topology snapshot record was first created in the system. Used for audit trail and data lineage.',
  `data_quality_score` DECIMAL(5,2) COMMENT 'Numerical score (0-100) representing the overall quality and completeness of the SCADA data used to generate this topology snapshot. Higher scores indicate better data quality.',
  `data_source_system` STRING COMMENT 'Name or identifier of the source EMS or SCADA system that generated this topology snapshot (e.g., GE ADMS, ABB EMS, Siemens Spectrum).',
  `de_energized_bus_count` INT COMMENT 'Total number of buses (nodes) that are de-energized or isolated from power sources in this topology snapshot.',
  `de_energized_line_count` INT COMMENT 'Total number of transmission and distribution lines that are de-energized or out of service in this topology snapshot.',
  `de_energized_transformer_count` INT COMMENT 'Total number of transformers that are de-energized or out of service in this topology snapshot.',
  `disturbance_event_flag` BOOLEAN COMMENT 'Boolean indicator showing whether this topology snapshot was captured during or immediately following a grid disturbance event. Used for post-event reconstruction and NERC reporting.',
  `ems_model_version` STRING COMMENT 'Version identifier of the EMS network model used for this topology snapshot. Critical for ensuring consistency in post-event analysis and model validation.',
  `energized_bus_count` INT COMMENT 'Total number of buses (nodes) that are energized and connected to an active power source in this topology snapshot.',
  `energized_line_count` INT COMMENT 'Total number of transmission and distribution lines that are energized and in service in this topology snapshot.',
  `energized_transformer_count` INT COMMENT 'Total number of transformers that are energized and in service in this topology snapshot.',
  `execution_duration_seconds` DECIMAL(10,3) COMMENT 'Total time in seconds required to execute the topology processor and generate this snapshot. Used for performance monitoring and optimization.',
  `interconnection_name` STRING COMMENT 'Name of the North American electrical interconnection to which this topology snapshot applies (Eastern, Western, Texas, or Quebec). Valid values: Eastern|Western|Texas|Quebec.',
  `island_count` INT COMMENT 'Total number of electrically isolated network islands detected in this topology snapshot. A single interconnected grid has island_count = 1; multiple islands indicate network separation.',
  `iteration_count` INT COMMENT 'Number of iterations required by the topology processor to reach convergence or termination for this snapshot.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this topology snapshot record was last modified. Used for audit trail and change tracking.',
  `nerc_compliance_flag` BOOLEAN COMMENT 'Boolean indicator showing whether this topology snapshot meets NERC TOP-001 and TOP-002 requirements for transmission operations and real-time monitoring.',
  `nerc_region` STRING COMMENT 'NERC regional entity code for the geographic region covered by this topology snapshot (e.g., WECC, SERC, MRO, NPCC, RF, TRE).',
  `notes` STRING COMMENT 'Free-text field for operator comments, special conditions, or additional context related to this topology snapshot.',
  `open_switching_device_count` INT COMMENT 'Total number of breakers, switches, and other switching devices in the open position at the time of this snapshot. Open devices create network separation.',
  `operator_acknowledged` BOOLEAN COMMENT 'Boolean indicator showing whether an operator has reviewed and acknowledged this topology snapshot.',
  `operator_acknowledgment_required` BOOLEAN COMMENT 'Boolean indicator showing whether this topology snapshot requires operator review and acknowledgment due to unexpected topology changes or alarm conditions.',
  `operator_acknowledgment_timestamp` TIMESTAMP COMMENT 'Date and time when an operator acknowledged this topology snapshot, if applicable.',
  `pi_historian_tag_prefix` STRING COMMENT 'OSIsoft PI historian tag prefix used to archive this topology snapshot data for long-term storage and post-event analysis.',
  `rto_iso_code` STRING COMMENT 'Code identifying the RTO or ISO responsible for the control area covered by this topology snapshot (e.g., PJM, CAISO, ERCOT, MISO, SPP, NYISO, ISO-NE).',
  `scada_snapshot_timestamp` TIMESTAMP COMMENT 'Timestamp of the SCADA data snapshot used as input for this topology processor run. May differ slightly from snapshot_timestamp due to processing latency.',
  `snapshot_status` STRING COMMENT 'Current status of the topology snapshot indicating its validity and usability for analysis and compliance reporting. Valid values: valid|invalid|partial|under_review|archived.',
  `snapshot_timestamp` TIMESTAMP COMMENT 'The precise date and time when the topology snapshot was captured by the EMS topology processor. Represents the real-world moment of the network connectivity state.',
  `switching_order_reference` STRING COMMENT 'Reference identifier to the switching order or operational instruction that caused the topology change captured in this snapshot, if applicable.',
  `topology_change_flag` BOOLEAN COMMENT 'Boolean indicator showing whether the network topology changed compared to the previous snapshot. True indicates a switching operation or connectivity change occurred.',
  `topology_processor_algorithm` STRING COMMENT 'Name or identifier of the topology processing algorithm or method used to generate this snapshot (e.g., depth-first search, breadth-first search, matrix-based).',
  `topology_processor_run_reference` STRING COMMENT 'Unique reference identifier or sequence number assigned by the EMS topology processor for this specific run. Used for traceability and audit purposes.',
  `validation_error_count` INT COMMENT 'Number of validation errors or inconsistencies detected in this topology snapshot during quality checks.',
  `validation_status` STRING COMMENT 'Status of the validation checks performed on this topology snapshot to ensure consistency with physical network constraints and operational rules. Valid values: validated|pending|failed|bypassed.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_topology_snapshot` PRIMARY KEY (`topology_snapshot_id`)
)
USING DELTA
COMMENT 'Periodic snapshot of the EMS network topology model capturing the real-time connectivity state of the grid — which breakers and switches are open or closed, resulting in the active network islands and energized/de-energized sections. Captures snapshot timestamp, topology processor run reference, number of islands, number of energized buses, number of open switching devices, and topology change flag. Used for post-event network reconstruction, NERC TOP compliance, and EMS model validation. Complements state_estimation_run by capturing the topological (connectivity) state separately from the electrical (power flow) state. | CMM: CIM TopologicalIsland (broad), IEC61970::Topology.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'TopologySnapshot',
  'cmm.cim.class' = 'TopologicalIsland',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61970::Topology',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.topology_snapshot'
);

-- ProtectionEvent  <<CIM PSREvent : extension>>
CREATE TABLE IF NOT EXISTS `grid`.`protection_event` (
  `protection_event_id` BIGINT NOT NULL COMMENT 'Unique identifier for the protection system event record. Primary key for the protection event entity.',
  `audit_finding_id` BIGINT COMMENT 'Foreign key linking to compliance.audit_finding. Business justification: Protection system misoperations are auditable findings under NERC PRC-004. When auditors identify a misoperation during compliance reviews, the finding must link to the specific protection event for e',
  `control_area_id` BIGINT COMMENT 'Reference to the balancing authority control area responsible for the electrical system where the event occurred.',
  `distribution_substation_id` BIGINT COMMENT 'Reference to the substation where the protection event occurred. Links to the physical location of the protection system.',
  `emergency_stock_event_id` BIGINT COMMENT 'Foreign key linking to supply.emergency_stock_event. Business justification: Protection relay trips causing equipment damage (fault current, breaker failure) trigger emergency material deployment for restoration. Links protection event to emergency procurement, mutual aid requ',
  `employee_id` BIGINT COMMENT 'Reference to the control room operator who acknowledged or responded to the protection event.',
  `ems_alarm_id` BIGINT COMMENT 'Reference to the EMS alarm record generated by this protection event, linking to operator notification and acknowledgment workflow.',
  `ems_node_id` BIGINT COMMENT 'FK to grid.ems_node.ems_node_id — Protection system operations occur at specific locations in the network model. Linking to EMS node enables correlation with state estimation results and contingency analysis for post-fault review.',
  `event_id` BIGINT COMMENT 'Foreign key linking to outage.outage_event. Business justification: Protection relay operations cause customer outages. Essential for root cause analysis, misoperation investigation, NERC PRC-004 compliance reporting, and correlating transmission events with distribut',
  `protection_device_id` BIGINT COMMENT 'Reference to the protection device (relay, recloser, breaker) that detected and initiated the protection operation.',
  `protection_scada_point_id` BIGINT COMMENT 'Reference to the SCADA telemetry point that captured the protection event data from the relay or RTU.',
  `registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: Protection relay operations are tied to specific relay assets. NERC PRC-004 misoperation investigations require linking events to asset maintenance records, inspection history, and firmware versions.',
  `safety_incident_id` BIGINT COMMENT 'Foreign key linking to workforce.safety_incident. Business justification: Protection events (relay trips, breaker failures) can cause or result from safety incidents. Linking enables equipment failure vs. human error root cause analysis for NERC PRC compliance.',
  `scada_point_id` BIGINT COMMENT 'FK to grid.scada_point.scada_point_id — Protection relay operations are detected via SCADA status points. Linking protection events to their associated SCADA points enables correlation with telemetry data for fault analysis.',
  `initiating_protection_event_id` BIGINT COMMENT 'Self-referencing FK on protection_event (initiating_protection_event_id)',
  `balancing_authority_code` STRING COMMENT 'NERC-registered balancing authority code responsible for the area where the protection event occurred.',
  `breaker_operation_status` STRING COMMENT 'Outcome of the circuit breaker operation command issued by the protection relay, indicating whether the breaker successfully interrupted the fault. Valid values: successful_trip|failed_to_trip|breaker_failure|trip_coil_supervision_alarm|slow_trip|partial_trip.',
  `clearing_time_cycles` DECIMAL(8,3) COMMENT 'Time elapsed from fault initiation to circuit breaker interruption, measured in power system cycles (60 Hz = 16.67 ms per cycle). Critical for coordination studies.',
  `corrective_action_description` STRING COMMENT 'Detailed description of the corrective actions taken or planned to prevent recurrence of similar protection events.',
  `corrective_action_required_flag` BOOLEAN COMMENT 'Indicates whether corrective actions (relay setting changes, equipment repairs, vegetation clearance) are required based on investigation findings.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this protection event record was first created in the data system.',
  `customers_affected_count` INT COMMENT 'Estimated number of customer accounts that experienced a service interruption as a result of this protection event.',
  `data_source_system` STRING COMMENT 'Name of the source system that provided the protection event data (e.g., GE PowerOn ADMS, SEL relay, ABB MicroSCADA, OSIsoft PI).',
  `disturbance_flag` BOOLEAN COMMENT 'Indicates whether this protection event was part of a larger system disturbance involving multiple facilities or widespread impact.',
  `event_timestamp` TIMESTAMP COMMENT 'Precise date and time when the protection system operation was initiated, typically synchronized to GPS time for accurate sequence-of-events analysis.',
  `fault_current_magnitude_amps` DECIMAL(12,2) COMMENT 'Peak magnitude of the fault current measured by the protection relay at the time of the event, expressed in amperes.',
  `fault_location_miles` DECIMAL(10,3) COMMENT 'Estimated distance from the relay terminal to the fault location, measured in miles along the protected line or feeder.',
  `fault_type` STRING COMMENT 'Classification of the electrical fault that triggered the protection operation, indicating the phases involved and whether ground was involved. Reference-value candidates: single_line_to_ground|line_to_line|double_line_to_ground|three_phase|phase_to_phase|phase_a_to_ground|phase_b_to_ground|phase_c_to_ground|phase_ab|phase_bc|phase_ca.',
  `initiating_cause` STRING COMMENT 'Root cause or trigger for the protection operation (e.g., lightning strike, equipment failure, vegetation contact, animal contact, insulator flashover, human error).',
  `initiating_cause_category` STRING COMMENT 'High-level classification of the root cause for analytics and trending purposes. Reference-value candidates: weather|equipment_failure|vegetation|animal|human_error|unknown|planned_operation.',
  `investigation_required_flag` BOOLEAN COMMENT 'Indicates whether this protection event requires formal engineering investigation per utility protection system review procedures or NERC PRC-004 requirements.',
  `investigation_status` STRING COMMENT 'Current status of the protection event investigation workflow, tracking progress from initiation to closure. Valid values: not_required|pending|in_progress|completed|closed.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this protection event record was most recently modified, tracking investigation updates and status changes.',
  `load_interrupted_mw` DECIMAL(12,3) COMMENT 'Amount of electrical load that was interrupted by the protection operation, measured in megawatts (MW).',
  `misoperation_flag` BOOLEAN COMMENT 'Indicates whether the protection operation has been classified as a misoperation per NERC PRC-004 criteria (failure to operate, slow operation, or unnecessary operation).',
  `misoperation_type` STRING COMMENT 'Classification of the misoperation if the misoperation flag is true, per NERC PRC-004 definitions. Valid values: not_applicable|failure_to_operate|slow_operation|unnecessary_operation|correct_operation.',
  `nerc_prc_standard_applicability` STRING COMMENT 'Identifies which NERC Protection and Control (PRC) reliability standards apply to this event (e.g., PRC-004, PRC-005, PRC-023, PRC-025).',
  `nerc_region` STRING COMMENT 'North American Electric Reliability Corporation regional entity with jurisdiction over the location of the event. Reference-value candidates: WECC|ERCOT|MRO|NPCC|RF|SERC|TRE|SPP.',
  `nerc_reportable_flag` BOOLEAN COMMENT 'Indicates whether this protection event meets NERC criteria for mandatory reporting to the Electric Reliability Organization (ERO).',
  `notes` STRING COMMENT 'Free-form text field for additional context, operator observations, or engineering comments related to the protection event.',
  `operator_acknowledged_flag` BOOLEAN COMMENT 'Indicates whether a control room operator has reviewed and acknowledged the protection event in the EMS or SCADA system.',
  `operator_acknowledgment_timestamp` TIMESTAMP COMMENT 'Date and time when the control room operator acknowledged the protection event alarm.',
  `outage_duration_minutes` DECIMAL(10,2) COMMENT 'Total duration of the customer outage from protection event initiation to full service restoration, measured in minutes.',
  `pi_tag_name` STRING COMMENT 'OSIsoft PI historian tag name used to archive time-series data associated with this protection event for long-term analytics and post-event review.',
  `protected_element_name` STRING COMMENT 'Business name or identifier of the specific electrical equipment that was protected (e.g., line name, feeder ID, transformer designation).',
  `protected_element_type` STRING COMMENT 'Classification of the electrical equipment protected by the relay that operated (transmission line, distribution feeder, transformer, generator, etc.). Reference-value candidates: transmission_line|distribution_feeder|transformer|generator|bus|capacitor_bank|reactor|cable.',
  `reclose_attempt_status` STRING COMMENT 'Status of the automatic reclosing sequence following the initial trip, indicating whether the line was successfully re-energized or locked out. Valid values: not_applicable|reclose_successful|reclose_failed|lockout|reclose_in_progress|reclose_blocked.',
  `reclose_shot_number` INT COMMENT 'Sequential number of the reclosing attempt (1 for first shot, 2 for second shot, etc.). Null if no reclose was attempted.',
  `relay_function_code` STRING COMMENT 'IEEE device function number identifying the specific protection function that operated (e.g., 21 for distance, 50 for instantaneous overcurrent, 51 for time overcurrent, 87 for differential).',
  `relay_type` STRING COMMENT 'Classification of the protection relay that operated, indicating the protection principle used (distance, overcurrent, differential, pilot scheme, etc.). Reference-value candidates: distance|overcurrent|differential|pilot|ground_fault|directional|voltage|frequency|transformer|generator|motor|bus|breaker_failure.',
  `restoration_timestamp` TIMESTAMP COMMENT 'Date and time when electrical service was fully restored following the protection event. Null if restoration is still in progress.',
  `trip_zone` STRING COMMENT 'The protection zone or stage that initiated the trip (e.g., Zone 1, Zone 2, Zone 3 for distance relays; instantaneous, time-delayed for overcurrent relays).',
  `voltage_level_kv` DECIMAL(8,2) COMMENT 'Nominal voltage level of the protected equipment where the event occurred, expressed in kilovolts (kV).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_protection_event` PRIMARY KEY (`protection_event_id`)
)
USING DELTA
COMMENT 'Transactional record of protection system operations (relay trips, recloser operations, breaker failure initiations) detected on the transmission and distribution network. Captures event timestamp, protection device reference, relay type (distance, overcurrent, differential, pilot), trip zone, fault type (single-line-to-ground, phase-to-phase, three-phase), fault current magnitude (amps), fault location (miles from terminal), clearing time (cycles), reclose attempt status, and associated NERC PRC standard applicability. SSOT for protection system event records used in NERC PRC-004 relay misoperation analysis, post-fault review, and protection coordination studies. | CMM: CIM PSREvent (extension), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ProtectionEvent',
  'cmm.cim.class' = 'PSREvent',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.protection_event'
);

-- ContingencyElement  <<CIM ContingencyEquipment : exact>>
CREATE TABLE IF NOT EXISTS `grid`.`contingency_element` (
  `contingency_element_id` BIGINT NOT NULL COMMENT 'Unique identifier for this contingency-asset association record. Primary key for the contingency_element association.',
  `contingency_id` BIGINT COMMENT 'Foreign key linking to the contingency case definition in the EMS contingency analysis catalog',
  `registry_id` BIGINT COMMENT 'Foreign key linking to the physical asset (transmission line, generator, transformer) that is removed or affected in this contingency scenario',
  `corrective_action_required_flag` BOOLEAN COMMENT 'Boolean flag indicating whether operator intervention or remedial action scheme (RAS) activation is required for this asset in this contingency scenario to maintain system reliability.',
  `created_by_user` STRING COMMENT 'Username or identifier of the grid operations engineer or system administrator who created this contingency element association. Used for accountability and audit purposes.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this contingency-asset association was first created in the EMS contingency catalog. Used for audit trail and change tracking.',
  `criticality_rank` INT COMMENT 'Numerical ranking (1 = most critical) of this asset\'s importance within this specific contingency scenario based on its impact to system stability, voltage profile, and thermal limits. Rank is contingency-specific, not a global asset criticality score.',
  `element_removal_order` STRING COMMENT 'Classification of the removal order for this element in the contingency: PRIMARY (first element removed in N-1), SECONDARY (second element in N-2), TERTIARY (third element in N-3), or SIMULTANEOUS (removed at same time as other elements). Used for NERC category classification.',
  `element_role_in_contingency` STRING COMMENT 'Role of this asset in the contingency analysis: OUTAGED_ELEMENT (asset is removed), MONITORED_ELEMENT (asset is monitored for violations but not removed), AFFECTED_ELEMENT (asset experiences loading or voltage changes due to outage of other elements).',
  `element_sequence` INT COMMENT 'Sequential order in which this asset is removed in the contingency scenario. Critical for N-2 and cascading outage analysis where removal order affects system response. Value 1 indicates primary element, 2 indicates secondary element in multi-element contingencies.',
  `last_analysis_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent EMS contingency analysis execution that evaluated this specific asset in this contingency scenario. Used for data freshness validation and audit trail.',
  `last_modified_by_user` STRING COMMENT 'Username or identifier of the user who most recently modified this contingency element association. Used for accountability and audit trail.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this contingency element record (sequence change, status update, criticality re-ranking). Used for change tracking and data lineage.',
  `operational_status` STRING COMMENT 'Current lifecycle status of this asset\'s participation in this contingency definition: ACTIVE (included in analysis), INACTIVE (temporarily excluded), EXCLUDED (permanently removed from scenario), UNDER_REVIEW (pending engineering validation).',
  `post_contingency_loading_percent` DECIMAL(5,2) COMMENT 'Loading level of this specific asset (if not removed) or affected neighboring assets as a percentage of rated capacity after the contingency event. Used to identify thermal overload violations and system stress points.',
  `pre_contingency_loading_percent` DECIMAL(5,2) COMMENT 'Loading level of this specific asset as a percentage of its rated capacity immediately before the contingency event, based on the base case state estimation. Used to assess whether the asset was already stressed before removal.',
  `violation_detected_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this specific asset experienced a thermal overload or voltage violation in the most recent contingency analysis run. Used for targeted corrective action planning.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_contingency_element` PRIMARY KEY (`contingency_element_id`)
)
USING DELTA
COMMENT 'This association product represents the participation of specific transmission and generation assets in NERC-mandated contingency analysis scenarios. It captures the element-specific attributes that exist only in the context of a contingency case definition, including removal sequence, pre/post-contingency loading conditions, and criticality ranking. Each record links one contingency scenario to one physical asset that is removed or affected in that scenario, supporting NERC TPL compliance evidence and EMS contingency analysis execution.. Existence Justification: In utility grid operations, contingency analysis scenarios (N-1, N-2) are defined by specifying which physical assets (transmission lines, generators, transformers) are removed from service and in what sequence. A single contingency case removes multiple assets (e.g., N-2 removes two elements), and each physical asset participates in multiple contingency definitions across different scenarios. Grid operators actively manage these contingency-asset associations as part of NERC TPL compliance, updating element sequences, criticality rankings, and monitoring thresholds based on seasonal conditions and system topology changes. | CMM: CIM ContingencyEquipment (exact), IEC61970::Contingency.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ContingencyElement',
  'cmm.cim.class' = 'ContingencyEquipment',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61970::Contingency',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.contingency_element'
);

-- ControlAreaObligation  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `grid`.`control_area_obligation` (
  `control_area_obligation_id` BIGINT NOT NULL COMMENT 'Unique identifier for this control area-obligation applicability and compliance tracking record. Primary key for the association.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to the balancing authority control area subject to this compliance obligation',
  `mitigation_plan_id` BIGINT COMMENT 'Reference to the mitigation plan record if non-compliance or partial compliance has been identified for this control area-obligation pair and a formal mitigation plan is in place.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to the regulatory compliance obligation that applies to this control area',
  `applicability_determination` STRING COMMENT 'Determination of whether this specific obligation applies to this specific control area, based on operational scope, asset type, and regulatory jurisdiction analysis. Values: applicable, not-applicable, conditionally-applicable, under-review.',
  `applicability_rationale` STRING COMMENT 'Business justification and regulatory analysis explaining why this obligation does or does not apply to this control area, including references to scope criteria, asset characteristics, and jurisdictional factors.',
  `assessment_method` STRING COMMENT 'Method used to assess compliance with this obligation for this control area. Values: automated, manual, hybrid, third-party-audit.',
  `compliance_status` STRING COMMENT 'Current compliance status of this specific control area with respect to this specific obligation. Values: compliant, non-compliant, partial-compliance, not-assessed, not-applicable.',
  `created_date` TIMESTAMP COMMENT 'Timestamp when this control area-obligation applicability record was created in the compliance management system.',
  `effective_date` DATE COMMENT 'Date on which this obligation became applicable to this control area, which may differ from the obligations general effective date based on control area commissioning or operational changes.',
  `evidence_location` STRING COMMENT 'Reference to the storage location, document management system path, or evidence repository where compliance evidence for this control area-obligation pair is maintained for audit defense.',
  `expiration_date` DATE COMMENT 'Date on which this obligation ceased or will cease to apply to this control area, due to control area decommissioning, regulatory changes, or scope modifications. Null if still applicable.',
  `last_assessment_date` DATE COMMENT 'Date of the most recent compliance assessment or audit for this control area-obligation pair.',
  `last_audit_finding` STRING COMMENT 'Summary of the most recent audit finding or assessment result for this control area-obligation pair, including any deficiencies identified or corrective actions required.',
  `last_updated_date` TIMESTAMP COMMENT 'Timestamp when this control area-obligation compliance record was last updated.',
  `next_due_date` DATE COMMENT 'Next scheduled date by which compliance evidence or reporting is due for this specific control area-obligation combination.',
  `responsible_person` STRING COMMENT 'Name or employee identifier of the individual responsible for ensuring compliance with this obligation for this specific control area.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_control_area_obligation` PRIMARY KEY (`control_area_obligation_id`)
)
USING DELTA
COMMENT 'This association product represents the applicability and compliance tracking relationship between a balancing authority control area and a specific regulatory obligation. It captures which NERC reliability standards, FERC requirements, and other regulatory obligations apply to each control area, along with the compliance status, assessment history, and evidence location for that specific control area-obligation pair. Each record links one control area to one obligation with attributes that exist only in the context of this applicability determination and compliance tracking relationship.. Existence Justification: In energy utility operations, each balancing authority control area must comply with multiple NERC reliability standards (BAL-001 through BAL-006 for balancing, TOP standards for transmission operations, IRO standards for reliability coordination, MOD standards for modeling), FERC regulations, and state PUC requirements. Conversely, each regulatory obligation applies to multiple control areas across the utility\'s operational footprint. The business actively manages this relationship through compliance tracking workflows, audit preparation, evidence collection, and regulatory reporting processes. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ControlAreaObligation',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.control_area_obligation'
);

-- ContingencyMonitoredElement  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `grid`.`contingency_monitored_element` (
  `contingency_monitored_element_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for this contingency-line monitoring relationship record. Primary key.',
  `analysis_run_id` BIGINT COMMENT 'Reference to the specific EMS contingency analysis execution run that produced this monitored element record. Links to the parent state estimation and analysis timestamp.',
  `contingency_id` BIGINT COMMENT 'Foreign key linking to the contingency case definition under which this line is being evaluated',
  `transmission_line_id` BIGINT COMMENT 'Foreign key linking to the transmission line master record being analyzed in this contingency scenario',
  `applicable_rating_mva` DECIMAL(10,2) COMMENT 'The thermal rating in MVA used to evaluate this line under this contingency scenario. May be normal, emergency, or load-dump rating depending on the contingency duration and severity classification.',
  `contingency_severity_index` DECIMAL(10,4) COMMENT 'Numerical severity index quantifying the impact of this contingency on this specific transmission line. Calculated based on post-contingency loading, voltage deviation, and other performance metrics. Higher values indicate more severe impacts requiring operator attention or corrective action.',
  `corrective_action_required_flag` BOOLEAN COMMENT 'Boolean flag indicating whether operator corrective action or remedial action scheme (RAS) activation is required to mitigate violations on this line under this contingency.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this contingency monitored element record, typically corresponding to the latest EMS contingency analysis execution.',
  `limiting_element_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this transmission line is the limiting element (most severely impacted) for this contingency scenario. The limiting element determines the severity classification of the contingency.',
  `monitored_element_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this transmission line is designated as a monitored element in this specific contingency scenario. Monitored elements are tracked for violations during contingency analysis execution.',
  `operator_acknowledged_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the system operator has acknowledged the violation or alarm associated with this contingency-line combination in the EMS interface.',
  `post_contingency_flow_mw` DECIMAL(10,2) COMMENT 'Active power flow in megawatts (MW) on this transmission line immediately following the contingency event, calculated by the EMS contingency analysis function.',
  `post_contingency_loading_percent` DECIMAL(7,2) COMMENT 'Calculated loading percentage of the transmission line immediately following the contingency event, expressed as a percentage of the applicable thermal rating (normal, emergency, or load-dump). Used to identify thermal overload violations.',
  `pre_contingency_flow_mw` DECIMAL(10,2) COMMENT 'Active power flow in megawatts (MW) on this transmission line in the base case (pre-contingency) state, derived from the parent state estimation run.',
  `violation_type` STRING COMMENT 'Classification of the violation detected on this transmission line under this contingency scenario. Values include NONE (no violation), THERMAL_OVERLOAD (exceeds thermal rating), VOLTAGE_HIGH (voltage exceeds upper limit), VOLTAGE_LOW (voltage below lower limit), or STABILITY (transient or voltage stability issue).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_contingency_monitored_element` PRIMARY KEY (`contingency_monitored_element_id`)
)
USING DELTA
COMMENT 'This association product represents the operational relationship between transmission lines and contingency scenarios in NERC-compliant security analysis. Each record captures a specific transmission line\'s behavior under a defined contingency case, including whether the line is a monitored element, a limiting element, post-contingency loading levels, violation types, and severity indices. This data is essential for real-time EMS contingency analysis, NERC TPL compliance evidence, and operator situational awareness during N-1 and N-2 security assessments.. Existence Justification: In NERC-compliant transmission operations, each contingency scenario (N-1, N-2) must be analyzed against multiple transmission lines to identify thermal overloads, voltage violations, and stability issues. Conversely, each transmission line must be evaluated under multiple contingency scenarios to determine its vulnerability and limiting conditions. The EMS contingency analysis function actively manages this many-to-many relationship, tracking which lines are monitored vs. limiting elements per contingency, post-contingency loading levels, violation types, and severity indices. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ContingencyMonitoredElement',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.contingency_monitored_element'
);

-- ControlCenter  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `grid`.`control_center` (
  `control_center_id` BIGINT NOT NULL COMMENT 'Primary key for control_center',
  `backup_control_center_id` BIGINT COMMENT 'Identifier of an alternate control center used for redundancy.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Control centers are organizational entities that belong to a specific control area; adding control_center.control_area_id creates the necessary parent relationship and eliminates the silo.',
  `address` STRING COMMENT 'Street address of the control center facility.',
  `audit_status` STRING COMMENT 'Result of the most recent audit.',
  `capacity_mw` DECIMAL(10,2) COMMENT 'Maximum electrical power capacity the control center can manage, expressed in megawatts.',
  `city` STRING COMMENT 'City where the control center is located.',
  `code` STRING COMMENT 'External business code or tag used to reference the control center in operational systems.',
  `commissioning_date` DATE COMMENT 'Date the control center became operational and entered service.',
  `communication_protocol` STRING COMMENT 'Primary protocol used for SCADA/EMS communications with the control center.',
  `control_center_description` STRING COMMENT 'Free-form description of the control center’s purpose, capabilities, and notable features.',
  `country_code` STRING COMMENT 'Three-letter ISO country code of the control center location.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the control center record was first created in the data lake.',
  `data_retention_days` INT COMMENT 'Number of days operational data from the control center is retained in the lakehouse.',
  `decommission_date` DATE COMMENT 'Date the control center was retired or taken out of service, if applicable.',
  `emergency_shutdown_capable` BOOLEAN COMMENT 'Indicates if the control center can initiate an emergency grid shutdown.',
  `ems_system` STRING COMMENT 'Energy Management System platform supporting the control center.',
  `installation_date` DATE COMMENT 'Date the control center facility was physically installed.',
  `is_critical` BOOLEAN COMMENT 'Indicates whether the control center is designated as critical for grid reliability.',
  `last_audit_date` DATE COMMENT 'Date of the most recent compliance or security audit of the control center.',
  `last_maintenance_date` DATE COMMENT 'Most recent date on which scheduled maintenance was performed.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude of the control center (decimal degrees).',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude of the control center (decimal degrees).',
  `maintenance_window` STRING COMMENT 'Preferred time window for routine maintenance activities.',
  `max_operating_temperature_c` DECIMAL(5,2) COMMENT 'Highest ambient temperature at which the control center equipment is rated to operate.',
  `min_operating_temperature_c` DECIMAL(5,2) COMMENT 'Lowest ambient temperature at which the control center equipment is rated to operate.',
  `name` STRING COMMENT 'Human-readable name of the control center.',
  `nerc_bal_compliance_status` STRING COMMENT 'Compliance status with NERC Balancing Authority Requirements.',
  `nerc_top_compliance_status` STRING COMMENT 'Compliance status with NERC Transmission Operator Performance standards.',
  `operator` STRING COMMENT 'Organization or business unit responsible for operating the control center.',
  `power_flow_model` STRING COMMENT 'Model type used for power flow calculations within the control center.',
  `primary_contact_email` STRING COMMENT 'Email address for the primary operational contact of the control center.',
  `primary_contact_phone` STRING COMMENT 'Phone number for the primary operational contact of the control center.',
  `region` STRING COMMENT 'Geographic region where the control center is located or primarily serves.',
  `scada_system` STRING COMMENT 'SCADA platform used for telemetry collection at the control center.',
  `security_classification` STRING COMMENT 'Internal security classification of the control center data.',
  `state` STRING COMMENT 'State or province of the control center location.',
  `status` STRING COMMENT 'Current lifecycle status of the control center.',
  `timezone` STRING COMMENT 'Time zone of the control center for scheduling and timestamp alignment.',
  `type` STRING COMMENT 'Classification of the control center based on its functional role.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the control center record.',
  `voltage_level_kv` DECIMAL(8,2) COMMENT 'Nominal voltage level of the network segments overseen by the control center, in kilovolts.',
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
  CONSTRAINT `pk_grid_control_center` PRIMARY KEY (`control_center_id`)
)
USING DELTA
COMMENT 'Master reference table for control_center. Referenced by control_center_id. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ControlCenter',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.control_center',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- DispatchInstruction  <<CIM GenUnitOpSchedule : broad>>
CREATE TABLE IF NOT EXISTS `grid`.`dispatch_instruction` (
  `dispatch_instruction_id` BIGINT NOT NULL COMMENT 'Primary key for dispatch_instruction',
  `approved_by_user_employee_id` BIGINT COMMENT 'Identifier of the user who approved the dispatch instruction.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Dispatch instructions are issued within a control area context; adding dispatch_instruction.control_area_id links each instruction to its control area, providing the required inbound relationship.',
  `employee_id` BIGINT COMMENT 'Identifier of the user who created the dispatch instruction record.',
  `generating_unit_id` BIGINT COMMENT 'Identifier of the generation asset or resource to which the instruction applies.',
  `last_modified_by_user_employee_id` BIGINT COMMENT 'Identifier of the user who performed the most recent update.',
  `market_participant_id` BIGINT COMMENT 'Identifier of the party (e.g., utility, balancing authority) that originated the dispatch instruction.',
  `transmission_path_id` BIGINT COMMENT 'Identifier of the transmission corridor associated with the dispatch.',
  `superseded_dispatch_instruction_id` BIGINT COMMENT 'Self-referencing FK on dispatch_instruction (superseded_dispatch_instruction_id)',
  `approval_timestamp` TIMESTAMP COMMENT 'Timestamp when the dispatch instruction received formal approval.',
  `audit_trail_reference` BIGINT COMMENT 'Reference to the detailed audit log entry for this instruction.',
  `comments` STRING COMMENT 'Free-form text field for additional notes or operator remarks.',
  `compliance_flag` BOOLEAN COMMENT 'True if the instruction meets applicable NERC BAL/TOP reliability standards.',
  `created_location` STRING COMMENT 'Plant or control center code where the instruction was originated.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the dispatch instruction record was first captured in the data lake.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 code of the currency used for monetary values.',
  `dispatch_price_usd_per_mwh` DECIMAL(12,4) COMMENT 'Unit price applied to the dispatched energy, expressed in US dollars per megawatt-hour.',
  `dispatch_quantity_mw` DECIMAL(10,2) COMMENT 'Amount of electrical power, in megawatts, to be dispatched.',
  `dispatch_status_detail` STRING COMMENT 'Additional free-form status information (e.g., \'awaiting acknowledgment\').',
  `dispatch_total_cost_usd` DECIMAL(14,2) COMMENT 'Total monetary cost of the dispatch instruction (quantity × price).',
  `effective_end_time` TIMESTAMP COMMENT 'Timestamp when the dispatch instruction expires or is superseded.',
  `effective_start_time` TIMESTAMP COMMENT 'Timestamp when the dispatch instruction becomes operationally effective.',
  `event_timestamp` TIMESTAMP COMMENT 'The real-world time when the dispatch instruction was generated or issued.',
  `external_system_reference` STRING COMMENT 'Reference identifier linking to the originating system (e.g., OSIsoft PI tag).',
  `instruction_number` STRING COMMENT 'External reference number assigned to the dispatch instruction by the market or operating entity.',
  `instruction_type` STRING COMMENT 'Category of the dispatch action, such as start, stop, ramp up, ramp down, or set point adjustment.',
  `instruction_version` INT COMMENT 'Version number of the instruction for amendment tracking.',
  `is_emergency` BOOLEAN COMMENT 'Indicates whether the instruction is an emergency action (true) or routine (false).',
  `is_manual_override` BOOLEAN COMMENT 'Indicates if the instruction was manually overridden by an operator.',
  `last_modified_location` STRING COMMENT 'Control center or system code where the last modification occurred.',
  `load_zone` STRING COMMENT 'Geographic load zone or balancing area impacted by the instruction.',
  `market_session` STRING COMMENT 'Identifier of the market session (e.g., DA, RT) for the instruction.',
  `market_type` STRING COMMENT 'Market segment to which the dispatch instruction belongs.',
  `max_duration_minutes` INT COMMENT 'Maximum allowed duration for the instruction to remain active.',
  `min_duration_minutes` INT COMMENT 'Minimum required duration for the instruction to be effective.',
  `priority` INT COMMENT 'Numeric priority level (higher value indicates higher urgency) used for instruction sequencing.',
  `ramp_rate_mw_per_min` DECIMAL(8,2) COMMENT 'Maximum allowed change in MW per minute for ramp-up or ramp-down.',
  `reason_code` STRING COMMENT 'Standardized code describing the operational or market reason for the dispatch instruction.',
  `revision_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent revision to the instruction content.',
  `scheduled_end_time` TIMESTAMP COMMENT 'Planned end time for the dispatch action.',
  `scheduled_start_time` TIMESTAMP COMMENT 'Planned start time for the dispatch action, may differ from effective start.',
  `source_type` STRING COMMENT 'System or process that generated the instruction.',
  `status` STRING COMMENT 'Current workflow state of the dispatch instruction.',
  `target_frequency_hz` DECIMAL(5,2) COMMENT 'Desired system frequency to be maintained by the instruction.',
  `target_voltage_kv` DECIMAL(6,2) COMMENT 'Desired voltage level for the affected transmission zone.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the dispatch instruction record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_grid_dispatch_instruction` PRIMARY KEY (`dispatch_instruction_id`)
)
USING DELTA
COMMENT 'Master reference table for dispatch_instruction. Referenced by dispatch_instruction_id. | CMM: CIM GenUnitOpSchedule (broad), IEC61970::Generation::Production.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DispatchInstruction',
  'cmm.cim.class' = 'GenUnitOpSchedule',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61970::Generation::Production',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.grid.dispatch_instruction'
);

-- ========= FOREIGN KEYS within grid (90) =========
ALTER TABLE `grid`.`ems_node` DROP CONSTRAINT IF EXISTS `fk_grid_ems_node_control_area_id`;
ALTER TABLE `grid`.`ems_node` ADD CONSTRAINT `fk_grid_ems_node_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`ems_node` DROP CONSTRAINT IF EXISTS `fk_grid_ems_node_ems_control_area_id`;
ALTER TABLE `grid`.`ems_node` ADD CONSTRAINT `fk_grid_ems_node_ems_control_area_id` FOREIGN KEY (`ems_control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`scada_point` DROP CONSTRAINT IF EXISTS `fk_grid_scada_point_control_area_id`;
ALTER TABLE `grid`.`scada_point` ADD CONSTRAINT `fk_grid_scada_point_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`scada_point` DROP CONSTRAINT IF EXISTS `fk_grid_scada_point_ems_node_id`;
ALTER TABLE `grid`.`scada_point` ADD CONSTRAINT `fk_grid_scada_point_ems_node_id` FOREIGN KEY (`ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `grid`.`scada_point` DROP CONSTRAINT IF EXISTS `fk_grid_scada_point_scada_ems_node_id`;
ALTER TABLE `grid`.`scada_point` ADD CONSTRAINT `fk_grid_scada_point_scada_ems_node_id` FOREIGN KEY (`scada_ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `grid`.`scada_point` DROP CONSTRAINT IF EXISTS `fk_grid_scada_point_to_ems_node_id`;
ALTER TABLE `grid`.`scada_point` ADD CONSTRAINT `fk_grid_scada_point_to_ems_node_id` FOREIGN KEY (`to_ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `grid`.`grid_scada_measurement` DROP CONSTRAINT IF EXISTS `fk_grid_grid_scada_measurement_control_area_id`;
ALTER TABLE `grid`.`grid_scada_measurement` ADD CONSTRAINT `fk_grid_grid_scada_measurement_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`grid_scada_measurement` DROP CONSTRAINT IF EXISTS `fk_grid_grid_scada_measurement_pmu_device_id`;
ALTER TABLE `grid`.`grid_scada_measurement` ADD CONSTRAINT `fk_grid_grid_scada_measurement_pmu_device_id` FOREIGN KEY (`pmu_device_id`) REFERENCES `grid`.`pmu_device` (`pmu_device_id`);

ALTER TABLE `grid`.`grid_scada_measurement` DROP CONSTRAINT IF EXISTS `fk_grid_grid_scada_measurement_scada_point_id`;
ALTER TABLE `grid`.`grid_scada_measurement` ADD CONSTRAINT `fk_grid_grid_scada_measurement_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `grid`.`state_estimation_run` DROP CONSTRAINT IF EXISTS `fk_grid_state_estimation_run_balancing_authority_control_area_id`;
ALTER TABLE `grid`.`state_estimation_run` ADD CONSTRAINT `fk_grid_state_estimation_run_balancing_authority_control_area_id` FOREIGN KEY (`balancing_authority_control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`state_estimation_run` DROP CONSTRAINT IF EXISTS `fk_grid_state_estimation_run_control_area_id`;
ALTER TABLE `grid`.`state_estimation_run` ADD CONSTRAINT `fk_grid_state_estimation_run_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`state_estimation_run` DROP CONSTRAINT IF EXISTS `fk_grid_state_estimation_run_ems_node_id`;
ALTER TABLE `grid`.`state_estimation_run` ADD CONSTRAINT `fk_grid_state_estimation_run_ems_node_id` FOREIGN KEY (`ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `grid`.`state_estimation_run` DROP CONSTRAINT IF EXISTS `fk_grid_state_estimation_run_state_ems_node_id`;
ALTER TABLE `grid`.`state_estimation_run` ADD CONSTRAINT `fk_grid_state_estimation_run_state_ems_node_id` FOREIGN KEY (`state_ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `grid`.`state_estimation_result` DROP CONSTRAINT IF EXISTS `fk_grid_state_estimation_result_scada_point_id`;
ALTER TABLE `grid`.`state_estimation_result` ADD CONSTRAINT `fk_grid_state_estimation_result_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `grid`.`state_estimation_result` DROP CONSTRAINT IF EXISTS `fk_grid_state_estimation_result_state_estimation_run_id`;
ALTER TABLE `grid`.`state_estimation_result` ADD CONSTRAINT `fk_grid_state_estimation_result_state_estimation_run_id` FOREIGN KEY (`state_estimation_run_id`) REFERENCES `grid`.`state_estimation_run` (`state_estimation_run_id`);

ALTER TABLE `grid`.`contingency` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_contingency_state_estimation_run_id`;
ALTER TABLE `grid`.`contingency` ADD CONSTRAINT `fk_grid_contingency_contingency_state_estimation_run_id` FOREIGN KEY (`contingency_state_estimation_run_id`) REFERENCES `grid`.`state_estimation_run` (`state_estimation_run_id`);

ALTER TABLE `grid`.`contingency` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_control_area_id`;
ALTER TABLE `grid`.`contingency` ADD CONSTRAINT `fk_grid_contingency_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`contingency` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_state_estimation_run_id`;
ALTER TABLE `grid`.`contingency` ADD CONSTRAINT `fk_grid_contingency_state_estimation_run_id` FOREIGN KEY (`state_estimation_run_id`) REFERENCES `grid`.`state_estimation_run` (`state_estimation_run_id`);

ALTER TABLE `grid`.`contingency` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_to_state_estimation_run_id`;
ALTER TABLE `grid`.`contingency` ADD CONSTRAINT `fk_grid_contingency_to_state_estimation_run_id` FOREIGN KEY (`to_state_estimation_run_id`) REFERENCES `grid`.`state_estimation_run` (`state_estimation_run_id`);

ALTER TABLE `grid`.`contingency_analysis_run` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_analysis_run_control_area_id`;
ALTER TABLE `grid`.`contingency_analysis_run` ADD CONSTRAINT `fk_grid_contingency_analysis_run_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`contingency_analysis_run` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_analysis_run_state_estimation_run_id`;
ALTER TABLE `grid`.`contingency_analysis_run` ADD CONSTRAINT `fk_grid_contingency_analysis_run_state_estimation_run_id` FOREIGN KEY (`state_estimation_run_id`) REFERENCES `grid`.`state_estimation_run` (`state_estimation_run_id`);

ALTER TABLE `grid`.`contingency_analysis_run` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_analysis_run_worst_case_contingency_id`;
ALTER TABLE `grid`.`contingency_analysis_run` ADD CONSTRAINT `fk_grid_contingency_analysis_run_worst_case_contingency_id` FOREIGN KEY (`worst_case_contingency_id`) REFERENCES `grid`.`contingency` (`contingency_id`);

ALTER TABLE `grid`.`contingency_violation` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_violation_contingency_analysis_run_id`;
ALTER TABLE `grid`.`contingency_violation` ADD CONSTRAINT `fk_grid_contingency_violation_contingency_analysis_run_id` FOREIGN KEY (`contingency_analysis_run_id`) REFERENCES `grid`.`contingency_analysis_run` (`contingency_analysis_run_id`);

ALTER TABLE `grid`.`contingency_violation` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_violation_contingency_id`;
ALTER TABLE `grid`.`contingency_violation` ADD CONSTRAINT `fk_grid_contingency_violation_contingency_id` FOREIGN KEY (`contingency_id`) REFERENCES `grid`.`contingency` (`contingency_id`);

ALTER TABLE `grid`.`contingency_violation` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_violation_control_area_id`;
ALTER TABLE `grid`.`contingency_violation` ADD CONSTRAINT `fk_grid_contingency_violation_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`contingency_violation` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_violation_scada_point_id`;
ALTER TABLE `grid`.`contingency_violation` ADD CONSTRAINT `fk_grid_contingency_violation_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `grid`.`agc_signal` DROP CONSTRAINT IF EXISTS `fk_grid_agc_signal_agc_control_area_id`;
ALTER TABLE `grid`.`agc_signal` ADD CONSTRAINT `fk_grid_agc_signal_agc_control_area_id` FOREIGN KEY (`agc_control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`agc_signal` DROP CONSTRAINT IF EXISTS `fk_grid_agc_signal_primary_control_area_id`;
ALTER TABLE `grid`.`agc_signal` ADD CONSTRAINT `fk_grid_agc_signal_primary_control_area_id` FOREIGN KEY (`primary_control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`agc_signal` DROP CONSTRAINT IF EXISTS `fk_grid_agc_signal_scada_point_id`;
ALTER TABLE `grid`.`agc_signal` ADD CONSTRAINT `fk_grid_agc_signal_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `grid`.`agc_signal` DROP CONSTRAINT IF EXISTS `fk_grid_agc_signal_to_control_area_id`;
ALTER TABLE `grid`.`agc_signal` ADD CONSTRAINT `fk_grid_agc_signal_to_control_area_id` FOREIGN KEY (`to_control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`ace_record` DROP CONSTRAINT IF EXISTS `fk_grid_ace_record_control_area_id`;
ALTER TABLE `grid`.`ace_record` ADD CONSTRAINT `fk_grid_ace_record_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`ace_record` DROP CONSTRAINT IF EXISTS `fk_grid_ace_record_scada_point_id`;
ALTER TABLE `grid`.`ace_record` ADD CONSTRAINT `fk_grid_ace_record_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `grid`.`interchange_schedule` DROP CONSTRAINT IF EXISTS `fk_grid_interchange_schedule_interchange_control_area_id`;
ALTER TABLE `grid`.`interchange_schedule` ADD CONSTRAINT `fk_grid_interchange_schedule_interchange_control_area_id` FOREIGN KEY (`interchange_control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`interchange_schedule` DROP CONSTRAINT IF EXISTS `fk_grid_interchange_schedule_primary_control_area_id`;
ALTER TABLE `grid`.`interchange_schedule` ADD CONSTRAINT `fk_grid_interchange_schedule_primary_control_area_id` FOREIGN KEY (`primary_control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`load_forecast` DROP CONSTRAINT IF EXISTS `fk_grid_load_forecast_control_area_id`;
ALTER TABLE `grid`.`load_forecast` ADD CONSTRAINT `fk_grid_load_forecast_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`load_forecast` DROP CONSTRAINT IF EXISTS `fk_grid_load_forecast_load_control_area_id`;
ALTER TABLE `grid`.`load_forecast` ADD CONSTRAINT `fk_grid_load_forecast_load_control_area_id` FOREIGN KEY (`load_control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`load_forecast` DROP CONSTRAINT IF EXISTS `fk_grid_load_forecast_load_forecast_for_control_area`;
ALTER TABLE `grid`.`load_forecast` ADD CONSTRAINT `fk_grid_load_forecast_load_forecast_for_control_area` FOREIGN KEY (`load_forecast_for_control_area`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`load_forecast` DROP CONSTRAINT IF EXISTS `fk_grid_load_forecast_to_control_area_id`;
ALTER TABLE `grid`.`load_forecast` ADD CONSTRAINT `fk_grid_load_forecast_to_control_area_id` FOREIGN KEY (`to_control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`generation_dispatch` DROP CONSTRAINT IF EXISTS `fk_grid_generation_dispatch_control_area_id`;
ALTER TABLE `grid`.`generation_dispatch` ADD CONSTRAINT `fk_grid_generation_dispatch_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`generation_dispatch` DROP CONSTRAINT IF EXISTS `fk_grid_generation_dispatch_generation_control_area_id`;
ALTER TABLE `grid`.`generation_dispatch` ADD CONSTRAINT `fk_grid_generation_dispatch_generation_control_area_id` FOREIGN KEY (`generation_control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`generation_dispatch` DROP CONSTRAINT IF EXISTS `fk_grid_generation_dispatch_generation_dispatch_within_control_area`;
ALTER TABLE `grid`.`generation_dispatch` ADD CONSTRAINT `fk_grid_generation_dispatch_generation_dispatch_within_control_area` FOREIGN KEY (`generation_dispatch_within_control_area`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`generation_dispatch` DROP CONSTRAINT IF EXISTS `fk_grid_generation_dispatch_scada_point_id`;
ALTER TABLE `grid`.`generation_dispatch` ADD CONSTRAINT `fk_grid_generation_dispatch_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `grid`.`grid_switching_order` DROP CONSTRAINT IF EXISTS `fk_grid_grid_switching_order_control_area_id`;
ALTER TABLE `grid`.`grid_switching_order` ADD CONSTRAINT `fk_grid_grid_switching_order_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`grid_switching_step` DROP CONSTRAINT IF EXISTS `fk_grid_grid_switching_step_grid_switching_order_id`;
ALTER TABLE `grid`.`grid_switching_step` ADD CONSTRAINT `fk_grid_grid_switching_step_grid_switching_order_id` FOREIGN KEY (`grid_switching_order_id`) REFERENCES `grid`.`grid_switching_order` (`grid_switching_order_id`);

ALTER TABLE `grid`.`grid_switching_step` DROP CONSTRAINT IF EXISTS `fk_grid_grid_switching_step_scada_point_id`;
ALTER TABLE `grid`.`grid_switching_step` ADD CONSTRAINT `fk_grid_grid_switching_step_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `grid`.`voltage_control_action` DROP CONSTRAINT IF EXISTS `fk_grid_voltage_control_action_contingency_id`;
ALTER TABLE `grid`.`voltage_control_action` ADD CONSTRAINT `fk_grid_voltage_control_action_contingency_id` FOREIGN KEY (`contingency_id`) REFERENCES `grid`.`contingency` (`contingency_id`);

ALTER TABLE `grid`.`voltage_control_action` DROP CONSTRAINT IF EXISTS `fk_grid_voltage_control_action_control_area_id`;
ALTER TABLE `grid`.`voltage_control_action` ADD CONSTRAINT `fk_grid_voltage_control_action_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`voltage_control_action` DROP CONSTRAINT IF EXISTS `fk_grid_voltage_control_action_primary_ems_node_id`;
ALTER TABLE `grid`.`voltage_control_action` ADD CONSTRAINT `fk_grid_voltage_control_action_primary_ems_node_id` FOREIGN KEY (`primary_ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `grid`.`voltage_control_action` DROP CONSTRAINT IF EXISTS `fk_grid_voltage_control_action_scada_point_id`;
ALTER TABLE `grid`.`voltage_control_action` ADD CONSTRAINT `fk_grid_voltage_control_action_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `grid`.`voltage_control_action` DROP CONSTRAINT IF EXISTS `fk_grid_voltage_control_action_voltage_ems_node_id`;
ALTER TABLE `grid`.`voltage_control_action` ADD CONSTRAINT `fk_grid_voltage_control_action_voltage_ems_node_id` FOREIGN KEY (`voltage_ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `grid`.`frequency_event` DROP CONSTRAINT IF EXISTS `fk_grid_frequency_event_ems_alarm_id`;
ALTER TABLE `grid`.`frequency_event` ADD CONSTRAINT `fk_grid_frequency_event_ems_alarm_id` FOREIGN KEY (`ems_alarm_id`) REFERENCES `grid`.`ems_alarm` (`ems_alarm_id`);

ALTER TABLE `grid`.`frequency_event` DROP CONSTRAINT IF EXISTS `fk_grid_frequency_event_frequency_control_area_id`;
ALTER TABLE `grid`.`frequency_event` ADD CONSTRAINT `fk_grid_frequency_event_frequency_control_area_id` FOREIGN KEY (`frequency_control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`frequency_event` DROP CONSTRAINT IF EXISTS `fk_grid_frequency_event_scada_point_id`;
ALTER TABLE `grid`.`frequency_event` ADD CONSTRAINT `fk_grid_frequency_event_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `grid`.`frequency_event` DROP CONSTRAINT IF EXISTS `fk_grid_frequency_event_to_control_area_id`;
ALTER TABLE `grid`.`frequency_event` ADD CONSTRAINT `fk_grid_frequency_event_to_control_area_id` FOREIGN KEY (`to_control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`pmu_measurement` DROP CONSTRAINT IF EXISTS `fk_grid_pmu_measurement_pmu_device_id`;
ALTER TABLE `grid`.`pmu_measurement` ADD CONSTRAINT `fk_grid_pmu_measurement_pmu_device_id` FOREIGN KEY (`pmu_device_id`) REFERENCES `grid`.`pmu_device` (`pmu_device_id`);

ALTER TABLE `grid`.`pmu_measurement` DROP CONSTRAINT IF EXISTS `fk_grid_pmu_measurement_scada_point_id`;
ALTER TABLE `grid`.`pmu_measurement` ADD CONSTRAINT `fk_grid_pmu_measurement_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `grid`.`pmu_device` DROP CONSTRAINT IF EXISTS `fk_grid_pmu_device_control_area_id`;
ALTER TABLE `grid`.`pmu_device` ADD CONSTRAINT `fk_grid_pmu_device_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`pmu_device` DROP CONSTRAINT IF EXISTS `fk_grid_pmu_device_ems_node_id`;
ALTER TABLE `grid`.`pmu_device` ADD CONSTRAINT `fk_grid_pmu_device_ems_node_id` FOREIGN KEY (`ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `grid`.`operator_log` DROP CONSTRAINT IF EXISTS `fk_grid_operator_log_ems_node_id`;
ALTER TABLE `grid`.`operator_log` ADD CONSTRAINT `fk_grid_operator_log_ems_node_id` FOREIGN KEY (`ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `grid`.`operator_log` DROP CONSTRAINT IF EXISTS `fk_grid_operator_log_operator_scada_point_id`;
ALTER TABLE `grid`.`operator_log` ADD CONSTRAINT `fk_grid_operator_log_operator_scada_point_id` FOREIGN KEY (`operator_scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `grid`.`operator_log` DROP CONSTRAINT IF EXISTS `fk_grid_operator_log_primary_operator_control_area_id`;
ALTER TABLE `grid`.`operator_log` ADD CONSTRAINT `fk_grid_operator_log_primary_operator_control_area_id` FOREIGN KEY (`primary_operator_control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`operator_log` DROP CONSTRAINT IF EXISTS `fk_grid_operator_log_scada_point_id`;
ALTER TABLE `grid`.`operator_log` ADD CONSTRAINT `fk_grid_operator_log_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `grid`.`operator_log` DROP CONSTRAINT IF EXISTS `fk_grid_operator_log_state_estimation_run_id`;
ALTER TABLE `grid`.`operator_log` ADD CONSTRAINT `fk_grid_operator_log_state_estimation_run_id` FOREIGN KEY (`state_estimation_run_id`) REFERENCES `grid`.`state_estimation_run` (`state_estimation_run_id`);

ALTER TABLE `grid`.`ems_alarm` DROP CONSTRAINT IF EXISTS `fk_grid_ems_alarm_control_area_id`;
ALTER TABLE `grid`.`ems_alarm` ADD CONSTRAINT `fk_grid_ems_alarm_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`ems_alarm` DROP CONSTRAINT IF EXISTS `fk_grid_ems_alarm_ems_node_id`;
ALTER TABLE `grid`.`ems_alarm` ADD CONSTRAINT `fk_grid_ems_alarm_ems_node_id` FOREIGN KEY (`ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `grid`.`ems_alarm` DROP CONSTRAINT IF EXISTS `fk_grid_ems_alarm_ems_scada_point_id`;
ALTER TABLE `grid`.`ems_alarm` ADD CONSTRAINT `fk_grid_ems_alarm_ems_scada_point_id` FOREIGN KEY (`ems_scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `grid`.`ems_alarm` DROP CONSTRAINT IF EXISTS `fk_grid_ems_alarm_scada_point_id`;
ALTER TABLE `grid`.`ems_alarm` ADD CONSTRAINT `fk_grid_ems_alarm_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `grid`.`grid_reliability_event` DROP CONSTRAINT IF EXISTS `fk_grid_grid_reliability_event_control_area_id`;
ALTER TABLE `grid`.`grid_reliability_event` ADD CONSTRAINT `fk_grid_grid_reliability_event_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`operating_limit` DROP CONSTRAINT IF EXISTS `fk_grid_operating_limit_control_area_id`;
ALTER TABLE `grid`.`operating_limit` ADD CONSTRAINT `fk_grid_operating_limit_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`operating_limit` DROP CONSTRAINT IF EXISTS `fk_grid_operating_limit_ems_node_id`;
ALTER TABLE `grid`.`operating_limit` ADD CONSTRAINT `fk_grid_operating_limit_ems_node_id` FOREIGN KEY (`ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `grid`.`operating_limit` DROP CONSTRAINT IF EXISTS `fk_grid_operating_limit_operating_ems_node_id`;
ALTER TABLE `grid`.`operating_limit` ADD CONSTRAINT `fk_grid_operating_limit_operating_ems_node_id` FOREIGN KEY (`operating_ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `grid`.`operating_limit` DROP CONSTRAINT IF EXISTS `fk_grid_operating_limit_operating_limit_for_ems_element`;
ALTER TABLE `grid`.`operating_limit` ADD CONSTRAINT `fk_grid_operating_limit_operating_limit_for_ems_element` FOREIGN KEY (`operating_limit_for_ems_element`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `grid`.`real_time_rating` DROP CONSTRAINT IF EXISTS `fk_grid_real_time_rating_control_area_id`;
ALTER TABLE `grid`.`real_time_rating` ADD CONSTRAINT `fk_grid_real_time_rating_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`real_time_rating` DROP CONSTRAINT IF EXISTS `fk_grid_real_time_rating_scada_point_id`;
ALTER TABLE `grid`.`real_time_rating` ADD CONSTRAINT `fk_grid_real_time_rating_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `grid`.`topology_snapshot` DROP CONSTRAINT IF EXISTS `fk_grid_topology_snapshot_control_area_id`;
ALTER TABLE `grid`.`topology_snapshot` ADD CONSTRAINT `fk_grid_topology_snapshot_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`topology_snapshot` DROP CONSTRAINT IF EXISTS `fk_grid_topology_snapshot_state_estimation_run_id`;
ALTER TABLE `grid`.`topology_snapshot` ADD CONSTRAINT `fk_grid_topology_snapshot_state_estimation_run_id` FOREIGN KEY (`state_estimation_run_id`) REFERENCES `grid`.`state_estimation_run` (`state_estimation_run_id`);

ALTER TABLE `grid`.`protection_event` DROP CONSTRAINT IF EXISTS `fk_grid_protection_event_control_area_id`;
ALTER TABLE `grid`.`protection_event` ADD CONSTRAINT `fk_grid_protection_event_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`protection_event` DROP CONSTRAINT IF EXISTS `fk_grid_protection_event_ems_alarm_id`;
ALTER TABLE `grid`.`protection_event` ADD CONSTRAINT `fk_grid_protection_event_ems_alarm_id` FOREIGN KEY (`ems_alarm_id`) REFERENCES `grid`.`ems_alarm` (`ems_alarm_id`);

ALTER TABLE `grid`.`protection_event` DROP CONSTRAINT IF EXISTS `fk_grid_protection_event_ems_node_id`;
ALTER TABLE `grid`.`protection_event` ADD CONSTRAINT `fk_grid_protection_event_ems_node_id` FOREIGN KEY (`ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `grid`.`protection_event` DROP CONSTRAINT IF EXISTS `fk_grid_protection_event_protection_scada_point_id`;
ALTER TABLE `grid`.`protection_event` ADD CONSTRAINT `fk_grid_protection_event_protection_scada_point_id` FOREIGN KEY (`protection_scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `grid`.`protection_event` DROP CONSTRAINT IF EXISTS `fk_grid_protection_event_scada_point_id`;
ALTER TABLE `grid`.`protection_event` ADD CONSTRAINT `fk_grid_protection_event_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `grid`.`protection_event` DROP CONSTRAINT IF EXISTS `fk_grid_protection_event_initiating_protection_event_id`;
ALTER TABLE `grid`.`protection_event` ADD CONSTRAINT `fk_grid_protection_event_initiating_protection_event_id` FOREIGN KEY (`initiating_protection_event_id`) REFERENCES `grid`.`protection_event` (`protection_event_id`);

ALTER TABLE `grid`.`contingency_element` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_element_contingency_id`;
ALTER TABLE `grid`.`contingency_element` ADD CONSTRAINT `fk_grid_contingency_element_contingency_id` FOREIGN KEY (`contingency_id`) REFERENCES `grid`.`contingency` (`contingency_id`);

ALTER TABLE `grid`.`control_area_obligation` DROP CONSTRAINT IF EXISTS `fk_grid_control_area_obligation_control_area_id`;
ALTER TABLE `grid`.`control_area_obligation` ADD CONSTRAINT `fk_grid_control_area_obligation_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`contingency_monitored_element` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_monitored_element_analysis_run_id`;
ALTER TABLE `grid`.`contingency_monitored_element` ADD CONSTRAINT `fk_grid_contingency_monitored_element_analysis_run_id` FOREIGN KEY (`analysis_run_id`) REFERENCES `grid`.`contingency_analysis_run` (`contingency_analysis_run_id`);

ALTER TABLE `grid`.`contingency_monitored_element` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_monitored_element_contingency_id`;
ALTER TABLE `grid`.`contingency_monitored_element` ADD CONSTRAINT `fk_grid_contingency_monitored_element_contingency_id` FOREIGN KEY (`contingency_id`) REFERENCES `grid`.`contingency` (`contingency_id`);

ALTER TABLE `grid`.`control_center` DROP CONSTRAINT IF EXISTS `fk_grid_control_center_backup_control_center_id`;
ALTER TABLE `grid`.`control_center` ADD CONSTRAINT `fk_grid_control_center_backup_control_center_id` FOREIGN KEY (`backup_control_center_id`) REFERENCES `grid`.`control_center` (`control_center_id`);

ALTER TABLE `grid`.`control_center` DROP CONSTRAINT IF EXISTS `fk_grid_control_center_control_area_id`;
ALTER TABLE `grid`.`control_center` ADD CONSTRAINT `fk_grid_control_center_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`dispatch_instruction` DROP CONSTRAINT IF EXISTS `fk_grid_dispatch_instruction_control_area_id`;
ALTER TABLE `grid`.`dispatch_instruction` ADD CONSTRAINT `fk_grid_dispatch_instruction_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `grid`.`dispatch_instruction` DROP CONSTRAINT IF EXISTS `fk_grid_dispatch_instruction_superseded_dispatch_instruction_id`;
ALTER TABLE `grid`.`dispatch_instruction` ADD CONSTRAINT `fk_grid_dispatch_instruction_superseded_dispatch_instruction_id` FOREIGN KEY (`superseded_dispatch_instruction_id`) REFERENCES `grid`.`dispatch_instruction` (`dispatch_instruction_id`);

