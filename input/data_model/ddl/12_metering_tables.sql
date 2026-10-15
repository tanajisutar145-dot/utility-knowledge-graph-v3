-- Utility CMM-aligned Canonical Data Model (Silver) v1.0.0 | source: Databricks lakehouse-industry-data-models energy_utilities v1 ECM | generated 2026-10-13
-- 12 | Subject area: metering | 20 tables | CIM packages: IEC61968::Metering; IEC61968::PaymentMetering
-- Standards: IEC 61968-9; ANSI C12.19/C12.22; IEC 62056 DLMS/COSEM; NAESB REQ.21 ESPI
-- Contents: tables (with PK + NOT NULL), then intra-subject-area foreign keys.
-- Unity Catalog PK/FK constraints are informational (NOT ENFORCED); NOT NULL is enforced.

USE CATALOG `utility_cmm_silver`;

-- Meter  <<CIM Meter : exact>>
CREATE TABLE IF NOT EXISTS `metering`.`meter` (
  `meter_id` BIGINT NOT NULL COMMENT 'Unique identifier for the physical metering device. Primary key for the meter entity. System-of-record: Oracle Utilities MDM meter object.',
  `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: Meters are capitalized assets requiring depreciation tracking per FERC Uniform System of Accounts (Account 370 - Meters). Essential for plant-in-service accounting, RAB valuation, depreciation expense',
  `meter_ami_head_end_id` BIGINT COMMENT 'Foreign key linking to metering.ami_head_end. Business justification: Meters are enrolled in and managed by specific AMI head-end systems. The meter table currently has ami_head_end_system as a STRING attribute, which should be normalized to a FK relationship. This is a',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Meters must comply with regulatory obligations for accuracy (ANSI C12.20), testing frequency, certification. Supports compliance tracking, audit evidence, regulatory reporting on meter accuracy progra',
  `to_ami_head_end_id` BIGINT COMMENT 'FK to metering.ami_head_end.ami_head_end_id — Each smart meter is assigned to an AMI head-end system for communication management. Required for data collection scheduling and network management.',
  `tou_rate_program_id` BIGINT COMMENT 'Foreign key linking to metering.tou_rate_program. Business justification: Meters are configured with specific Time-of-Use (TOU) rate programs that define peak/off-peak periods, CPP event criteria, and interval data requirements. The meter table currently has tou_rate_progra',
  `accuracy_class` STRING COMMENT 'ANSI accuracy classification of the meter (e.g., Class 0.2, Class 0.5, Class 1.0, Class 2.0). Lower numbers indicate higher precision. Determines acceptable measurement error tolerance and testing requirements.',
  `ami_network_segment` STRING COMMENT 'Identifier of the AMI communication network segment or cell to which this meter is assigned. Used for network planning, troubleshooting, and load balancing across AMI infrastructure.',
  `communication_module_serial` STRING COMMENT 'Unique serial number of the communication module. Tracked separately from meter serial to support independent module replacement without replacing the entire meter. Used for module-level warranty and troubleshooting.',
  `communication_module_type` STRING COMMENT 'Technology type of the embedded or attached communication module enabling remote meter reading. RF Mesh uses radio frequency mesh networks; PLC uses power line carrier; Cellular uses mobile networks; Fiber uses optical networks; None for non-communicating meters. Valid values: RF Mesh|PLC|Cellular|Fiber|None.',
  `communication_protocol` STRING COMMENT 'Application-layer protocol used for meter-to-head-end communication (e.g., ANSI C12.22, DLMS/COSEM, SEP 2.0, Modbus). Determines data format, security features, and interoperability with AMI systems.',
  `configuration_effective_date` DATE COMMENT 'Date when the current operational configuration (interval length, TOU program, demand reset, channels) became active. Used for configuration versioning and historical data interpretation. Critical for billing accuracy during configuration changes.',
  `configuration_expiration_date` DATE COMMENT 'Date when the current operational configuration is scheduled to expire or be replaced. Nullable for open-ended configurations. Used for planned configuration change management and audit trails.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this meter record was first created in the MDM system. Used for data lineage, audit trails, and system integration reconciliation. Distinct from installation date.',
  `current_rating_amps` DECIMAL(10,2) COMMENT 'Maximum continuous current the meter can measure in amperes. Typical values: 100A, 200A, 320A. Used to ensure meter capacity matches service load requirements.',
  `demand_reset_interval_minutes` INT COMMENT 'Programmed interval in minutes for resetting the demand register (e.g., 15, 30 minutes). Determines how frequently peak demand is calculated and recorded. Critical for demand billing accuracy.',
  `disconnect_switch_status` STRING COMMENT 'Current position of the remote disconnect switch for meters with disconnect capability. Connected indicates service is on; Disconnected indicates service is off; Armed indicates ready for remote command; Not Applicable for meters without disconnect. Valid values: Connected|Disconnected|Armed|Not Applicable.',
  `firmware_version` STRING COMMENT 'Version identifier of the embedded software running on the meter device. Critical for security patching, feature enablement, and compatibility with head-end systems. Tracked for firmware upgrade campaigns.',
  `form` STRING COMMENT 'ANSI form designation describing the physical configuration and wiring arrangement of the meter (e.g., Form 2S, Form 12S, Form 16S). Determines socket compatibility and installation requirements.',
  `installation_date` DATE COMMENT 'Date the meter was physically installed at its current service location. Used for age tracking, warranty calculations, and lifecycle management. Distinct from manufacturing date.',
  `interval_length_minutes` INT COMMENT 'Programmed interval duration in minutes for load profile data collection (e.g., 15, 30, 60 minutes). Determines granularity of consumption data for billing, demand response, and grid analytics. Configurable parameter tracked for versioning.',
  `ip_address` STRING COMMENT 'Assigned IP address for meters using IP-based communication protocols (cellular, fiber). Used for direct meter communication, remote diagnostics, and firmware updates. Confidential to prevent unauthorized access. Pattern: ^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to any field in this meter record. Used for change tracking, data synchronization, and audit compliance. Updated automatically on any record modification.',
  `lifecycle_status` STRING COMMENT 'Current state of the meter in its asset lifecycle. Installed indicates active deployment; In Stock indicates warehouse inventory; In Transit indicates shipment; Retired indicates end-of-life; Failed indicates defective; Under Test indicates lab testing. Valid values: Installed|In Stock|In Transit|Retired|Failed|Under Test.',
  `load_profile_channels_enabled` STRING COMMENT 'Comma-separated list of load profile channels currently enabled for data collection (e.g., kWh Delivered, kWh Received, kVARh, Voltage, Current). Defines which measurement streams are actively recorded in interval data.',
  `mac_address` STRING COMMENT 'Hardware MAC address of the communication module network interface. Used for network device identification, AMI head-end provisioning, and communication diagnostics. Confidential to prevent network security risks. Pattern: ^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$.',
  `manufacturer` STRING COMMENT 'Name of the company that manufactured the meter device (e.g., Landis+Gyr, Itron, Sensus, Elster, Aclara). Used for vendor management, warranty tracking, and firmware compatibility.',
  `meter_type` STRING COMMENT 'Classification of meter technology and capability level. AMI Smart Meter supports two-way communication and remote operations; Interval Meter records time-series consumption; Demand Meter tracks peak demand; Electromechanical is legacy analog; Electronic is digital non-communicating; Prepaid supports prepayment programs. Valid values: AMI Smart Meter|Interval Meter|Demand Meter|Electromechanical|Electronic|Prepaid.',
  `model_number` STRING COMMENT 'Manufacturer model designation identifying the specific meter product line and capabilities. Used for configuration management, firmware updates, and technical specifications lookup.',
  `module_firmware_version` STRING COMMENT 'Version identifier of the firmware running on the communication module, tracked separately from meter firmware. Critical for communication security patches and protocol updates.',
  `module_status` STRING COMMENT 'Current operational status of the communication module. Active indicates normal operation; Inactive indicates disabled but functional; Failed indicates hardware failure; Replaced indicates module swap; Not Installed for non-AMI meters. Valid values: Active|Inactive|Failed|Replaced|Not Installed.',
  `next_test_due_date` DATE COMMENT 'Scheduled date for the next required accuracy test or calibration. Calculated based on regulatory testing intervals (typically 5-15 years depending on meter type and jurisdiction). Used for test planning and compliance tracking.',
  `notes` STRING COMMENT 'Free-text field for operational notes, special handling instructions, field observations, or historical context not captured in structured fields. Used by field technicians and operations staff.',
  `number_of_elements` INT COMMENT 'Count of independent metering elements within the device. Single-phase meters have 1 element; polyphase meters have 2 or 3 elements. Determines measurement capability for multi-phase services.',
  `ownership_status` STRING COMMENT 'Legal ownership classification of the meter asset. Utility Owned is standard for most deployments; Customer Owned for customer-purchased meters; Leased for rental arrangements; Third Party for meters owned by service providers. Valid values: Utility Owned|Customer Owned|Leased|Third Party.',
  `purchase_order_number` STRING COMMENT 'Purchase order number under which this meter was procured. Used for procurement tracking, warranty validation, and vendor management. Links to financial and supply chain systems.',
  `register_configuration` STRING COMMENT 'Description of the meter register setup including number of dials, multiplier, and measurement units (kWh, kVARh, kW demand). Defines what consumption data the meter captures and how it is displayed.',
  `remote_disconnect_capable` BOOLEAN COMMENT 'Boolean flag indicating whether the meter has remote service disconnect/reconnect capability. True enables remote service control for collections, move-in/move-out, and emergency response. False requires manual field operations.',
  `removal_date` DATE COMMENT 'Date the meter was removed from service location. Nullable for currently installed meters. Used for lifecycle tracking, inventory management, and historical service point analysis.',
  `seal_number` STRING COMMENT 'Unique identifier of the tamper-evident seal applied to the meter cover. Used to detect unauthorized meter access, tampering, and theft. Recorded during installation and verified during inspections.',
  `seal_status` STRING COMMENT 'Current condition of the meter seal. Intact indicates no tampering; Broken indicates potential unauthorized access requiring investigation; Missing indicates seal loss; Not Applicable for meters without seals. Valid values: Intact|Broken|Missing|Not Applicable.',
  `serial_number` STRING COMMENT 'Manufacturer-assigned unique serial number physically stamped on the meter device. Used for asset tracking, warranty claims, and field verification. SSOT for device identity. Pattern: ^[A-Z0-9]{8,20}$.',
  `service_point_id` BIGINT COMMENT 'Foreign key linking to metering.service_point. Business justification: A service point can host many meters; the many side (meter) gets a foreign key to the parent service_point. This eliminates the siloed service_point table and provides the needed inbound relationship.',
  `signal_strength_baseline_dbm` DECIMAL(6,2) COMMENT 'Baseline communication signal strength measurement in dBm at time of installation or last network optimization. Used to detect communication degradation and plan network improvements. Typical range: -110 to -40 dBm.',
  `test_date` DATE COMMENT 'Date of the most recent accuracy test or calibration performed on the meter. Used to track compliance with regulatory testing intervals and identify meters due for testing.',
  `voltage_class` STRING COMMENT 'Nominal voltage rating for which the meter is designed and certified. Determines appropriate deployment location (residential 120/240V, commercial 277/480V, primary voltage for large industrial). Valid values: 120V|240V|277V|480V|Primary Voltage.',
  `warranty_expiration_date` DATE COMMENT 'Date when the manufacturer warranty coverage expires. Used for warranty claim eligibility, replacement planning, and total cost of ownership analysis. Nullable if warranty terms are not date-based.',
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
  CONSTRAINT `pk_metering_meter` PRIMARY KEY (`meter_id`)
)
USING DELTA
COMMENT 'Master record for every physical metering device deployed or managed by the utility — smart meters (AMI), interval meters, demand meters, and legacy electromechanical units. Captures device identity (serial number, manufacturer, model), firmware version, meter form factor, voltage class, current rating, number of elements, register configuration, seal status, and AMI head-end system assignment. Includes embedded communication module attributes: module type (RF mesh/PLC/cellular), module serial number, MAC/IP address, signal strength baseline, module firmware version, communication protocol, assigned AMI network segment, and module status — supporting independent module replacement tracking without a separate entity. Also captures the active and historical programmed operational configuration: interval length setting (15/30/60 min), TOU rate program assignment, demand reset interval, load profile channels enabled, remote disconnect/reconnect capability, and configuration effective dates for versioning. SSOT for meter asset identity, communication endpoint, and device configuration within the metering domain; links to the asset domain for full lifecycle management. | CMM: CIM Meter (exact), IEC61968::Metering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'Meter',
  'cmm.cim.class' = 'Meter',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Metering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-9',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.meter',
  'cmm.gis.location.role' = 'Asset.Location'
);

-- MeterPoint  <<CIM UsagePoint : exact>>
CREATE TABLE IF NOT EXISTS `metering`.`meter_point` (
  `meter_point_id` BIGINT NOT NULL COMMENT 'Unique identifier for the meter point (service delivery point). This is the primary key representing the logical location where energy consumption is measured, persisting across meter device swaps.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Service points must be assigned to balancing authority control areas for load aggregation, interchange scheduling, ACE calculation, and NERC CPS1/CPS2 compliance reporting. Core operational requiremen',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Service points are assigned to cost centers for operational expense tracking and budget allocation by service territory, voltage class, and operational area. Required for monthly O&M cost allocation a',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: Service points host DER installations. NEM billing reconciliation, export limit enforcement, and interconnection compliance require linking meter_point to der_registry. Essential for behind-the-meter',
  `distribution_feeder_id` BIGINT COMMENT 'Identifier of the distribution feeder circuit serving this meter point. Critical for outage management, load balancing, and SAIDI/SAIFI reliability calculations.',
  `distribution_transformer_id` BIGINT COMMENT 'Identifier of the distribution transformer serving this meter point. Used for transformer loading analysis and secondary network modeling.',
  `lmp_price_id` BIGINT COMMENT 'Foreign key linking to trading.lmp_price. Business justification: Distribution planning and rate design require associating service points with their default pricing nodes to calculate location-based energy costs and design locational tariffs. Essential for cost-of-',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Service points subject to net metering obligations, interconnection standards, service quality requirements. Enables tariff compliance verification, regulatory reporting by service class, obligation t',
  `premise_id` BIGINT COMMENT 'Reference to the physical premise where this meter point is located. Links to the customer domain premise entity.',
  `service_point_asset_registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: Service points reference physical infrastructure assets (poles, pad-mount equipment, service cabinets) where metering is installed. Field operations, outage restoration, and capital planning require l',
  `ami_collector_code` STRING COMMENT 'Identifier of the AMI data collector or concentrator device that aggregates meter data from this service point. Pattern: ^[A-Z0-9]{6,20}$.',
  `ami_network_segment` STRING COMMENT 'AMI communication network segment or cell serving this meter point. Determines data collection routing and network performance monitoring. Pattern: ^[A-Z0-9]{4,12}$.',
  `contracted_capacity_kw` DECIMAL(12,3) COMMENT 'Contracted or subscribed service capacity in kilowatts for this meter point. Applicable to large commercial and industrial customers.',
  `cpp_eligible_flag` BOOLEAN COMMENT 'Indicates whether this meter point is eligible for critical peak pricing programs. Used for demand response event targeting.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this meter point record was first created in the MDM system. Used for data lineage and audit trail.',
  `data_quality_score` DECIMAL(5,2) COMMENT 'Composite data quality score (0-100) reflecting completeness, accuracy, and consistency of meter point attributes. Used for data stewardship prioritization.',
  `der_capacity_kw` DECIMAL(12,3) COMMENT 'Nameplate capacity in kilowatts of distributed generation or storage interconnected at this meter point. Used for hosting capacity analysis.',
  `der_interconnection_flag` BOOLEAN COMMENT 'Indicates whether a distributed energy resource is interconnected at this meter point. Triggers special metering and grid integration requirements.',
  `gps_latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the meter point in decimal degrees. Used for GIS mapping, outage analysis, and field crew navigation.',
  `gps_longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the meter point in decimal degrees. Used for GIS mapping, outage analysis, and field crew navigation.',
  `interval_data_collection_flag` BOOLEAN COMMENT 'Indicates whether this meter point supports interval data collection (15-minute, 30-minute, or hourly). Required for TOU billing and demand response.',
  `interval_length_minutes` INT COMMENT 'Length of each measurement interval in minutes for interval data collection (typically 15, 30, or 60). Determines data granularity for analytics.',
  `last_meter_reading_date` DATE COMMENT 'Date of the most recent successful meter reading for this service point. Used for billing cycle validation and data quality monitoring.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this meter point record was last updated. Used for change tracking and data synchronization.',
  `load_profile_class` STRING COMMENT 'Customer segment classification determining consumption patterns, rate structures, and demand response eligibility. Critical for load forecasting and grid planning. Valid values: residential|commercial|industrial|agricultural|street_lighting|municipal.',
  `meter_reading_cycle` STRING COMMENT 'Two-digit billing cycle code determining the scheduled meter reading date. Used for billing run scheduling and route optimization. Pattern: ^[0-9]{2}$.',
  `meter_reading_frequency` STRING COMMENT 'Frequency at which meter readings are collected for billing purposes. AMI-enabled points support continuous interval data collection. Valid values: monthly|bimonthly|quarterly|on_demand|continuous.',
  `net_metering_flag` BOOLEAN COMMENT 'Indicates whether net energy metering is enabled for this service point due to behind-the-meter generation (solar, wind, CHP).',
  `network_topology_node` STRING COMMENT 'Logical node identifier in the electrical network topology model. Used by ADMS and DMS systems for network analysis and switching operations.',
  `peak_demand_kw` DECIMAL(12,3) COMMENT 'Maximum recorded demand in kilowatts at this meter point. Used for capacity planning, rate design, and demand charge billing.',
  `phase_configuration` STRING COMMENT 'Electrical phase configuration of the service connection. Determines metering channel requirements and load balancing considerations. Valid values: single_phase|three_phase_wye|three_phase_delta|split_phase.',
  `rate_schedule_code` STRING COMMENT 'Tariff rate schedule code applicable to this meter point. Determines pricing structure, TOU periods, and billing determinants. Pattern: ^[A-Z0-9]{2,10}$.',
  `service_activation_date` DATE COMMENT 'Date when service was first activated at this meter point. Marks the beginning of the service point lifecycle.',
  `service_address_line1` STRING COMMENT 'Primary street address line for the meter point location. Used for field crew dispatch and outage management.',
  `service_address_line2` STRING COMMENT 'Secondary address line for apartment, suite, or unit number at the meter point location.',
  `service_city` STRING COMMENT 'City or municipality where the meter point is located. Used for jurisdictional rate determination and regulatory reporting.',
  `service_country_code` STRING COMMENT 'Three-letter ISO country code for the meter point location. Determines applicable national regulatory frameworks. Pattern: ^[A-Z]{3}$.',
  `service_deactivation_date` DATE COMMENT 'Date when service was permanently deactivated at this meter point. Null for active service points.',
  `service_point_number` STRING COMMENT 'Externally-known business identifier for the service delivery point. Used in customer communications, billing, and field operations. Pattern: ^[A-Z0-9]{8,20}$.',
  `service_point_status` STRING COMMENT 'Current lifecycle status of the meter point. Active indicates the point is in service and generating consumption data. Valid values: active|inactive|pending_activation|disconnected|abandoned.',
  `service_point_type` STRING COMMENT 'Classification of the commodity delivered at this meter point. Determines applicable rate schedules and measurement requirements. Valid values: electric|gas|water|steam|dual_fuel|multi_commodity.',
  `service_postal_code` STRING COMMENT 'Postal code for the meter point service address. Used for geographic analysis and service territory validation. Pattern: ^[0-9]{5}(-[0-9]{4})?$.',
  `service_state_province` STRING COMMENT 'Two-letter state or province code for the meter point location. Determines applicable PUC jurisdiction and regulatory requirements. Pattern: ^[A-Z]{2}$.',
  `service_voltage_level` STRING COMMENT 'Voltage classification at which energy is delivered to this meter point. Determines metering accuracy requirements and applicable tariffs. Valid values: low_voltage|medium_voltage|high_voltage|extra_high_voltage.',
  `service_voltage_value` DECIMAL(10,2) COMMENT 'Nominal voltage in volts at which service is delivered (e.g., 120V, 240V, 480V, 13.8kV). Used for power quality monitoring and equipment compatibility verification.',
  `source_system_code` STRING COMMENT 'Code identifying the authoritative source system for this meter point record. Supports multi-system data integration and master data governance. Valid values: MDM|CIS|GIS|ADMS|SCADA.',
  `tou_enabled_flag` BOOLEAN COMMENT 'Indicates whether time-of-use rate pricing is active for this meter point. Requires interval data collection and TOU-capable metering.',
  `vee_processing_flag` BOOLEAN COMMENT 'Indicates whether meter data from this point undergoes VEE processing for data quality assurance before billing and analytics.',
  `gis_location_id` BIGINT COMMENT 'Reference to the canonical CIM Location (gis.location) holding this entity\'s geometry, CRS and address. Implements CIM association UsagePoint.UsagePointLocation.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_metering_meter_point` PRIMARY KEY (`meter_point_id`)
)
USING DELTA
COMMENT 'Represents the physical service delivery point (premise) at which a meter is installed — the logical location where energy consumption is measured. Captures service point identifier, premise address, GPS coordinates, service voltage level, load class (residential, commercial, industrial), distribution feeder and transformer association, network topology node, and AMI network segment. Distinct from the meter device itself: a meter point persists even when meters are swapped. SSOT for the measurement location concept in the metering domain. | CMM: CIM UsagePoint (exact), IEC61968::Metering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MeterPoint',
  'cmm.cim.class' = 'UsagePoint',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Metering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-9',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.meter_point',
  'cmm.gis.location.role' = 'UsagePoint.UsagePointLocation'
);

-- MeterInstallation  <<CIM MeterServiceWork : close>>
CREATE TABLE IF NOT EXISTS `metering`.`meter_installation` (
  `meter_installation_id` BIGINT NOT NULL COMMENT 'Unique identifier for the meter installation record. Primary key for the meter installation entity.',
  `audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: Installation work audited for safety compliance, metering accuracy, proper sealing per regulatory standards. Supports audit trail for regulatory inspections, SOX controls over revenue metering, eviden',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Installation labor and materials are charged to cost centers for field service cost tracking. Essential for FERC Form 1 regulatory reporting (Account 586 - Meter Expenses) and operational budget varia',
  `customer_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.customer_service_agreement. Business justification: Meter installations are performed under specific service agreements that define rate schedules, metering requirements, and billing start dates. Supports billing determinism, regulatory compliance for',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: Physical meter installations at DER sites require bidirectional metering equipment. DER commissioning verification and permission-to-operate inspections link meter installation records to registered D',
  `installation_capex_project_id` BIGINT COMMENT 'Foreign key linking to finance.capex_project. Business justification: New meter installations are often part of capital projects (AMI deployment, service territory expansion, voltage upgrades). Required for capital project cost accumulation, WBS tracking, and rate case',
  `meter_work_order_id` BIGINT COMMENT 'Reference to the work order that authorized and tracked the meter installation activity. Links to asset management and field service systems.',
  `premise_id` BIGINT COMMENT 'Reference to the premise where the meter is physically installed. Provides geographic and customer context.',
  `primary_meter_employee_id` BIGINT COMMENT 'Reference to the field technician or crew who performed the meter installation. Used for quality tracking and accountability.',
  `primary_meter_id` BIGINT COMMENT 'Reference to the physical meter device that was installed at the meter point. Links to the meter asset registry.',
  `primary_meter_point_id` BIGINT COMMENT 'Reference to the meter point (service point) where the meter is installed. The logical location for energy measurement.',
  `primary_meter_removal_work_order_id` BIGINT COMMENT 'Reference to the work order that authorized and tracked the meter removal activity. Links to asset management and field service systems.',
  `to_meter_id` BIGINT COMMENT 'FK to metering.meter.meter_id — Every installation record MUST reference the meter device being installed. This is the core association that enables meter-to-premise traceability. Without this FK, you cannot determine which meter is',
  `to_meter_point_id` BIGINT COMMENT 'FK to metering.meter_point.meter_point_id — Every installation record MUST reference the meter point (location) where the meter is installed. This completes the meter-device-to-location association that is the foundation of the metering domain.',
  `trade_id` BIGINT COMMENT 'Foreign key linking to trading.trade. Business justification: Behind-the-meter generation contracts and renewable PPAs require tracking which meter installation measures energy delivery for specific trade contracts. Critical for contract settlement, compliance v',
  `accuracy_class` STRING COMMENT 'Meter accuracy classification per ANSI C12.20 standard. Lower values indicate higher precision. Class 0.2 and 0.5 are used for revenue-grade metering. Valid values: 0.2|0.5|1.0|2.0.',
  `ami_enabled_flag` BOOLEAN COMMENT 'Indicates whether the meter installation supports AMI (Advanced Metering Infrastructure) remote reading and two-way communication. True for smart meters with network connectivity.',
  `bidirectional_metering_flag` BOOLEAN COMMENT 'Indicates whether the meter can measure energy flow in both directions (consumption and generation). Required for NEM (Net Energy Metering) and DER (Distributed Energy Resource) customers.',
  `billing_end_date` DATE COMMENT 'Date when billing ends for this meter installation. Used for final bill calculation and account closure processing.',
  `billing_start_date` DATE COMMENT 'Date when billing begins for this meter installation. May differ from installation_date due to service agreement terms or proration rules.',
  `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the meter installation record was first created in the MDM (Meter Data Management) system. Used for audit trail and data lineage.',
  `ct_ratio` STRING COMMENT 'Current Transformer ratio in effect for this installation (e.g., 200:5, 400:5). Used for high-voltage metering where direct measurement is not feasible.',
  `end_reading` DECIMAL(18,3) COMMENT 'Meter register reading captured at the time of removal. Used to calculate final consumption and validate billing for the installation period.',
  `installation_date` DATE COMMENT 'Date when the meter was physically installed at the meter point. Marks the start of the installation period.',
  `installation_notes` STRING COMMENT 'Free-text field for technician notes captured during installation. May include site conditions, access issues, or special configuration details.',
  `installation_number` STRING COMMENT 'Business identifier for the meter installation record. Used for external reference and work order tracking.',
  `installation_reason_code` STRING COMMENT 'Business reason for the meter installation. Used for program tracking, cost allocation, and regulatory reporting. Valid values: new_service|meter_upgrade|meter_failure|ami_deployment|customer_request|regulatory_compliance.',
  `installation_status` STRING COMMENT 'Current lifecycle status of the meter installation. Active indicates the meter is currently in service at the meter point. Valid values: active|removed|pending|suspended|failed.',
  `installation_timestamp` TIMESTAMP COMMENT 'Precise date and time when the meter installation was completed. Used for interval data alignment and VEE (Validation, Estimation, and Editing) processing.',
  `installation_type` STRING COMMENT 'Classification of the installation based on its intended duration and purpose. Permanent installations are standard service; temporary installations support construction or events. Valid values: permanent|temporary|test|emergency.',
  `meter_location_code` STRING COMMENT 'Physical location classification of the meter at the premise. Used for field service routing, safety planning, and AMI (Advanced Metering Infrastructure) signal strength analysis. Valid values: indoor|outdoor|basement|utility_room|pole_mount|pad_mount.',
  `multiplier` DECIMAL(10,4) COMMENT 'Multiplier factor applied to meter readings to calculate actual consumption. Used when Current Transformer (CT) or Potential Transformer (PT) ratios are in effect.',
  `phase_configuration` STRING COMMENT 'Electrical phase configuration of the service. Single-phase for residential; three-phase for commercial and industrial customers. Valid values: single_phase|three_phase_wye|three_phase_delta.',
  `pt_ratio` STRING COMMENT 'Potential Transformer ratio in effect for this installation (e.g., 7200:120). Used in conjunction with CT ratio for accurate high-voltage metering.',
  `rate_schedule_code` STRING COMMENT 'Rate schedule in effect for this meter installation. Determines pricing structure (flat, TOU, CPP) and billing determinants.',
  `reading_uom` STRING COMMENT 'Unit of measure for the meter readings. Typically kWh (Kilowatt-Hour) for electric meters, therms or ccf for gas meters. Reference-value candidates: kWh|MWh|kW|kVAh|kVArh|therms|ccf|mcf.',
  `register_count` INT COMMENT 'Number of registers (dials) on the meter. Multi-register meters support TOU (Time of Use) and demand metering programs.',
  `remote_disconnect_capable_flag` BOOLEAN COMMENT 'Indicates whether the meter has remote service disconnect/reconnect capability. Used for credit management and demand response programs.',
  `removal_date` DATE COMMENT 'Date when the meter was removed from the meter point. Marks the end of the installation period. Null for active installations.',
  `removal_notes` STRING COMMENT 'Free-text field for technician notes captured during removal. May include meter condition, seal integrity, or reasons for discrepancies in final readings.',
  `removal_reason_code` STRING COMMENT 'Business reason for the meter removal. Used for asset lifecycle tracking, failure analysis, and warranty claims. Valid values: meter_failure|service_disconnect|meter_upgrade|customer_move|testing|end_of_life.',
  `removal_timestamp` TIMESTAMP COMMENT 'Precise date and time when the meter was removed. Used for final interval data cutoff and back-billing calculations.',
  `seal_number_1` STRING COMMENT 'Primary tamper-evident seal number applied to the meter at installation. Used for security and regulatory audit purposes.',
  `seal_number_2` STRING COMMENT 'Secondary tamper-evident seal number applied to the meter at installation. Provides additional security for high-value or critical installations.',
  `service_amperage` DECIMAL(10,2) COMMENT 'Maximum service amperage rating at the meter point in amps. Determines meter sizing and load capacity.',
  `service_voltage` DECIMAL(10,2) COMMENT 'Nominal service voltage at the meter point in volts. Used for meter configuration, safety planning, and load analysis.',
  `start_reading` DECIMAL(18,3) COMMENT 'Meter register reading captured at the time of installation. Used as the baseline for consumption calculations during this installation period.',
  `test_date` DATE COMMENT 'Date when the meter was last tested for accuracy before or after installation. Used for regulatory compliance and quality assurance.',
  `test_result` STRING COMMENT 'Result of the most recent meter accuracy test. Passed indicates the meter meets accuracy standards; failed triggers meter replacement. Valid values: passed|failed|not_tested.',
  `updated_timestamp` TIMESTAMP COMMENT 'System timestamp when the meter installation record was last modified. Used for change tracking and data quality monitoring.',
  `vee_profile_code` STRING COMMENT 'Reference to the VEE (Validation, Estimation, and Editing) rule set applied to interval data from this installation. Determines data quality thresholds and estimation algorithms.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_metering_meter_installation` PRIMARY KEY (`meter_installation_id`)
)
USING DELTA
COMMENT 'Tracks the active and historical association between a meter device and a meter point — the physical installation record. Captures installation date, removal date, meter reading at installation (start index), meter reading at removal (end index), installation technician, seal numbers applied, multiplier/CT ratio in effect, and installation status. Enables meter-to-premise traceability for billing, VEE, and regulatory audit. Supports meter swap history and back-billing calculations. | CMM: CIM MeterServiceWork (close), IEC61968::Metering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MeterInstallation',
  'cmm.cim.class' = 'MeterServiceWork',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Metering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-9',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.meter_installation'
);

-- IntervalReading  <<CIM IntervalReading : exact>>
CREATE TABLE IF NOT EXISTS `metering`.`interval_reading` (
  `interval_reading_id` BIGINT NOT NULL COMMENT 'Unique identifier for the interval reading record. Primary key for raw interval energy consumption and demand data collected from AMI smart meters.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Interval consumption data feeds real-time control area load calculations for AGC signals, state estimation, and balancing authority settlement. Required for NERC compliance and operational balancing.',
  `cycle_id` BIGINT COMMENT 'Identifier of the billing cycle to which this interval reading contributes. Links interval data to the billing period for invoice generation and revenue recognition.',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: Interval data from DER meters feeds REC issuance, curtailment verification, and generation forecasting. REC certificate generation process requires validated interval readings linked to specific DER f',
  `interval_meter_id` BIGINT COMMENT 'Identifier of the smart meter device that generated this interval reading. Links to the physical AMI meter asset.',
  `lmp_price_id` BIGINT COMMENT 'Foreign key linking to trading.lmp_price. Business justification: Raw interval consumption data must be priced using LMP at the meter\'s pricing node for preliminary settlement calculations before VEE processing. Required for real-time cost allocation and interval bi',
  `meter_point_id` BIGINT COMMENT 'Identifier of the service point (delivery location) where energy consumption was measured. Represents the physical location of energy delivery.',
  `to_meter_id` BIGINT COMMENT 'FK to metering.meter.meter_id — Raw interval readings must reference the meter device that produced them. This is the fundamental data provenance link for all consumption data.',
  `channel_number` STRING COMMENT 'Channel identifier on the meter device. Multi-channel meters track multiple measurement types (kWh delivered, kWh received, kW demand, voltage, power factor). Typically 1-99. Pattern: ^[0-9]{1,3}$.',
  `collection_method` STRING COMMENT 'Method by which the interval data was collected. AMI_PUSH = meter initiated transmission, AMI_POLL = head-end system requested, MANUAL = field reading, ESTIMATED = system generated, SCADA = real-time system, IMPORT = bulk file load. Valid values: AMI_PUSH|AMI_POLL|MANUAL|ESTIMATED|SCADA|IMPORT.',
  `collection_run_code` BIGINT COMMENT 'Identifier of the batch collection run or polling cycle that retrieved this reading. Groups readings collected in the same operational batch for traceability and reprocessing.',
  `correction_reason_code` STRING COMMENT 'Code identifying the reason for manual correction or substitution of the original reading value. Examples: METER_ERROR, COMM_FAILURE, CUSTOMER_DISPUTE, DATA_QUALITY. Empty if no correction.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this interval reading record was first inserted into the MDM system. Audit field for data lineage and record creation tracking.',
  `data_completeness_percentage` DECIMAL(5,2) COMMENT 'Percentage of expected interval data received for the associated collection period. 100.00 = complete, <100.00 = partial data. Used for data quality monitoring and VEE prioritization.',
  `data_source_system` STRING COMMENT 'Name or identifier of the source system that provided this interval reading. Examples: AMI_HEAD_END, SCADA_HISTORIAN, MANUAL_ENTRY, BILLING_SYSTEM. Supports multi-source MDM environments.',
  `daylight_saving_flag` BOOLEAN COMMENT 'Indicates whether daylight saving time was in effect during this interval. True = DST active, False = standard time. Critical for accurate time-of-use rate application and demand response event timing.',
  `demand_response_event_flag` BOOLEAN COMMENT 'Indicates whether a demand response event was active during this interval. True = DR event in progress, False = normal operation. Used for curtailment measurement and settlement.',
  `estimation_method_code` STRING COMMENT 'Code identifying the estimation algorithm applied if the reading was estimated. Examples: LIKE_DAY, LINEAR_INTERPOLATION, AVERAGE_USAGE, ZERO_FILL. Empty for actual meter readings.',
  `interval_duration_minutes` INT COMMENT 'Duration of the measurement interval in minutes. Common values: 15 (quarter-hourly), 30 (half-hourly), 60 (hourly). Supports variable interval lengths for different meter configurations.',
  `interval_end_timestamp` TIMESTAMP COMMENT 'Timestamp marking the end of the measurement interval. Defines the close of the accumulation period for this reading.',
  `interval_start_timestamp` TIMESTAMP COMMENT 'Timestamp marking the beginning of the measurement interval. Represents the real-world event time when the meter began accumulating energy for this interval. Typically aligned to 15-minute or 60-minute boundaries.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this interval reading record. Tracks modifications during VEE processing, manual corrections, or reprocessing events.',
  `load_profile_segment` STRING COMMENT 'Customer load profile classification segment for this service point. Used for load forecasting, rate design, and demand response targeting. Examples: RESIDENTIAL_STANDARD, COMMERCIAL_SMALL, INDUSTRIAL_LARGE.',
  `meter_read_status` STRING COMMENT 'Status of the meter read operation that produced this interval. SUCCESS = complete read, PARTIAL = incomplete data, FAILED = read failure, TIMEOUT = communication timeout, COMM_ERROR = network error. Valid values: SUCCESS|PARTIAL|FAILED|TIMEOUT|COMM_ERROR.',
  `net_metering_flag` BOOLEAN COMMENT 'Indicates whether this service point is enrolled in net energy metering (solar or DER generation). True = NEM active, False = standard consumption-only metering. Affects billing credit calculations.',
  `original_reading_value` DECIMAL(18,3) COMMENT 'Original raw reading value before any estimation, substitution, or manual correction. Preserved for audit trail and comparison with corrected values. Null if no correction occurred.',
  `power_outage_flag` BOOLEAN COMMENT 'Indicates whether a power outage was detected during this interval based on meter status flags or zero-consumption patterns. True = outage detected, False = normal operation.',
  `quality_code` STRING COMMENT 'Data quality indicator for the raw interval reading. RAW = actual meter reading, ESTIMATED = calculated by estimation algorithm, SUBSTITUTED = replaced due to validation failure, EDITED = manually corrected, REJECTED = failed validation, MISSING = no data received. Valid values: RAW|ESTIMATED|SUBSTITUTED|EDITED|REJECTED|MISSING.',
  `rate_schedule_code` STRING COMMENT 'Rate schedule or tariff code in effect for this service point at the time of the interval. Used to determine applicable TOU (Time of Use) or CPP (Critical Peak Pricing) rates for billing.',
  `reading_value` DECIMAL(18,3) COMMENT 'Raw numeric value of the interval measurement as collected from the meter. Represents energy consumption (kWh) or demand (kW) depending on channel configuration. Immutable raw value before VEE processing.',
  `received_timestamp` TIMESTAMP COMMENT 'Timestamp when the interval reading was received by the head-end system or MDM platform. Used for latency analysis and data freshness monitoring. Distinct from the interval measurement time.',
  `reprocessing_flag` BOOLEAN COMMENT 'Indicates whether this interval reading has been reprocessed after initial load. True = reprocessed due to correction or VEE re-run, False = original processing. Supports data lineage tracking.',
  `reverse_flow_flag` BOOLEAN COMMENT 'Indicates whether energy flowed in reverse direction (customer generation exported to grid) during this interval. True = export/generation, False = import/consumption. Critical for NEM and DER settlement.',
  `temperature_celsius` DECIMAL(5,2) COMMENT 'Ambient temperature at the service point location during the interval, if available from weather data integration. Used for weather normalization and load forecasting. Null if not available.',
  `time_zone_offset` STRING COMMENT 'UTC offset for the interval timestamps in ISO 8601 format (e.g., -05:00, +00:00). Ensures correct temporal alignment across service territories and daylight saving transitions. Pattern: ^[+-]\\d{2}:\\d{2}$.',
  `tou_bucket` STRING COMMENT 'Time-of-use pricing period classification for this interval based on rate schedule and timestamp. Determines the applicable energy rate tier for billing calculations. Valid values: ON_PEAK|OFF_PEAK|SHOULDER|SUPER_OFF_PEAK|CRITICAL_PEAK.',
  `unit_of_measure` STRING COMMENT 'Unit of measurement for the reading value. kWh (kilowatt-hour) for energy consumption, kW (kilowatt) for demand, kVArh for reactive energy, kVAr for reactive demand, kVAh for apparent energy, kVA for apparent demand. Valid values: kWh|kW|kVArh|kVAr|kVAh|kVA.',
  `updated_by_user` STRING COMMENT 'User ID or system account that last modified this interval reading record. Supports audit trail and accountability for manual edits or system corrections.',
  `validation_exception_code` STRING COMMENT 'Code identifying the specific validation rule or exception that flagged this reading during VEE processing. Examples: HIGH_USAGE, NEGATIVE_VALUE, MISSING_INTERVAL, SPIKE_DETECTED. Empty if no exceptions.',
  `validation_status` STRING COMMENT 'Status of VEE (Validation, Estimation, and Editing) processing for this raw reading. PENDING = awaiting validation, VALIDATED = passed validation rules, FAILED = validation exceptions detected, BYPASSED = validation skipped. Valid values: PENDING|VALIDATED|FAILED|BYPASSED.',
  `voltage_level` STRING COMMENT 'Voltage classification of the service point where this interval was measured. LOW = residential/small commercial (<1kV), MEDIUM = commercial/industrial (1-35kV), HIGH = large industrial (35-230kV), TRANSMISSION = bulk power (>230kV). Valid values: LOW|MEDIUM|HIGH|TRANSMISSION.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_metering_interval_reading` PRIMARY KEY (`interval_reading_id`)
)
USING DELTA
COMMENT 'Raw interval energy consumption and demand data collected from AMI smart meters at sub-hourly or hourly granularity (typically 15-min or 60-min intervals). Stores channel identifier, interval start timestamp, interval end timestamp, raw kWh or kW value, quality code (raw/estimated/substituted), data collection method (AMI push, manual, estimated), head-end system receipt timestamp, and collection run reference. This is the foundational time-series dataset feeding Oracle Utilities MDM VEE processing, billing, demand response, and grid operations. Immutable raw record — validated versions are stored in validated_interval_reading. High-volume transactional entity; typical utility processes millions of interval records daily. | CMM: CIM IntervalReading (exact), IEC61968::Metering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'IntervalReading',
  'cmm.cim.class' = 'IntervalReading',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Metering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-9',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.interval_reading'
);

-- ValidatedIntervalReading  <<CIM IntervalReading : close>>
CREATE TABLE IF NOT EXISTS `metering`.`validated_interval_reading` (
  `validated_interval_reading_id` BIGINT NOT NULL COMMENT 'Unique identifier for the validated interval reading record. Primary key for this entity representing a single VEE-processed meter reading interval.',
  `audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: Interval data validation processes audited for VEE rule compliance, estimation methodology, data quality standards. Provides audit evidence for billing accuracy, regulatory data quality reviews, SOX t',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: VEE-validated readings are the authoritative source for control area load profiles used in state estimation, load forecasting, and balancing authority financial settlement. Regulatory and operational',
  `cycle_id` BIGINT COMMENT 'Reference to the billing cycle that this interval reading contributes to. Links interval data to the billing period for invoice generation.',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: VEE-processed interval data from DER meters supports PPA settlement calculations, RPS compliance reporting, and curtailment event compensation. Monthly PPA settlements require validated generation dat',
  `dr_event_id` BIGINT COMMENT 'Reference to the demand response event that was active during this interval, if applicable. Null if no DR event was in effect.',
  `event_id` BIGINT COMMENT 'Reference to the specific outage event record if this interval was affected by a service interruption. Null if no outage occurred.',
  `interval_reading_id` BIGINT COMMENT 'Reference to the source raw interval reading record from which this validated reading was derived. Establishes lineage from raw to validated data.',
  `lmp_price_id` BIGINT COMMENT 'Foreign key linking to trading.lmp_price. Business justification: Settlement systems match validated interval consumption with LMP at the same timestamp and pricing node to calculate accurate energy costs for billing and cost allocation. This join happens in every w',
  `meter_id` BIGINT COMMENT 'Reference to the physical meter device that captured this interval reading. Links to the meter asset registry.',
  `primary_interval_reading_id` BIGINT COMMENT 'FK to metering.interval_reading.interval_reading_id — Each validated interval reading must trace back to its source raw interval reading for audit trail and VEE processing lineage. Regulatory requirement for billing data integrity.',
  `primary_meter_point_id` BIGINT COMMENT 'FK to metering.meter_point.meter_point_id — Validated interval data is associated with the meter point (not just the meter device) because billing and downstream consumers need location-based consumption. This is the SSOT consumption record key',
  `primary_validated_employee_id` BIGINT COMMENT 'The identifier of the user or system process that performed manual editing on this reading. Null for automated VEE processing.',
  `primary_vee_rule_id` BIGINT COMMENT 'FK to metering.vee_rule.vee_rule_id — Each validated reading should reference the VEE rule that was applied during validation/estimation. Required for regulatory audit of data quality processing.',
  `rate_schedule_id` BIGINT COMMENT 'Reference to the rate schedule (tariff) that was active for this service point during this interval. Used to determine applicable TOU or CPP pricing periods.',
  `validated_meter_point_id` BIGINT COMMENT 'Reference to the service delivery point (premise connection) where energy consumption was measured. The logical metering location.',
  `validated_vee_rule_id` BIGINT COMMENT 'FK to metering.vee_rule.vee_rule_id — Each validated interval reading references the VEE rule that was applied during validation/estimation. Critical for audit trail and understanding how data quality was assured.',
  `vee_cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: VEE processing operations (meter data management, validation software, analyst labor) have associated costs allocated to cost centers. Required for MDM operational cost tracking, billing quality assur',
  `approval_status` STRING COMMENT 'The workflow approval state for this validated reading. Indicates whether the reading has been reviewed and approved for downstream consumption by billing and analytics systems. Valid values: pending|approved|rejected|under_review.',
  `approval_timestamp` TIMESTAMP COMMENT 'The date and time when this validated reading was approved for billing and operational use. Null if not yet approved.',
  `billing_quality_flag` BOOLEAN COMMENT 'Boolean indicator of whether this reading meets the quality standards required for billing purposes. True indicates the reading is approved for billing calculations.',
  `channel_number` INT COMMENT 'The specific meter channel or register from which this reading was captured. Multi-channel meters track different measurement types on separate channels.',
  `consumption_kwh` DECIMAL(18,3) COMMENT 'The validated energy consumption for this interval measured in kilowatt-hours. This is the authoritative billing-quality consumption value after VEE processing.',
  `cpp_event_flag` BOOLEAN COMMENT 'Boolean indicator of whether this interval occurred during a declared Critical Peak Pricing event. True indicates CPP premium rates apply.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this validated interval reading record was first created in the MDM system.',
  `data_quality_score` DECIMAL(5,2) COMMENT 'A composite quality score (0-100) calculated by the VEE engine based on validation rules, estimation confidence, and data completeness. Higher scores indicate higher quality.',
  `data_source_system` STRING COMMENT 'The originating system or channel from which the raw interval data was collected before VEE processing. Valid values: ami_headend|manual_read|scada|estimated|customer_portal.',
  `demand_kw` DECIMAL(18,3) COMMENT 'The maximum instantaneous power demand recorded during this interval, measured in kilowatts. Used for demand-based billing and capacity planning.',
  `edit_comment` STRING COMMENT 'Free-text notes provided by the editor explaining the context or justification for manual edits to this reading.',
  `edit_reason_code` STRING COMMENT 'The business reason code explaining why this reading was manually edited. Examples include meter malfunction, data transmission error, or customer dispute resolution.',
  `estimation_confidence_score` DECIMAL(5,2) COMMENT 'A numerical score (0-100) indicating the confidence level in the estimated value. Higher scores indicate greater confidence in the estimation accuracy.',
  `estimation_method` STRING COMMENT 'The algorithm or technique used to estimate this reading if the original data was missing or invalid. Set to \'none\' for non-estimated readings. Valid values: none|linear_interpolation|historical_average|similar_day|regression|manual.',
  `exception_code` STRING COMMENT 'The specific exception rule code that was triggered during VEE processing. Examples include high-usage threshold breach, negative consumption, or data gap detection.',
  `exception_flag` BOOLEAN COMMENT 'Boolean indicator of whether this reading triggered any VEE exception rules requiring manual review. True indicates the reading requires analyst attention.',
  `interval_duration_minutes` INT COMMENT 'The length of the measurement interval in minutes. Common values include 15, 30, or 60 minutes depending on meter configuration and rate program requirements.',
  `interval_end_timestamp` TIMESTAMP COMMENT 'The precise date and time when this measurement interval ended. Defines the end boundary of the consumption period.',
  `interval_start_timestamp` TIMESTAMP COMMENT 'The precise date and time when this measurement interval began. Defines the start boundary of the consumption period.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this validated interval reading record was most recently updated or edited.',
  `meter_read_type` STRING COMMENT 'Classification of how the meter reading was obtained: automatically via AMI, manually by field personnel, estimated by system, or provided by customer. Valid values: automatic|manual|estimated|customer_provided.',
  `original_consumption_kwh` DECIMAL(18,3) COMMENT 'The raw, unmodified consumption value before VEE processing. Preserved for audit trail and comparison purposes. Null if no original value existed.',
  `outage_flag` BOOLEAN COMMENT 'Boolean indicator of whether a power outage was recorded at this service point during this interval. True indicates zero consumption due to service interruption.',
  `power_factor` DECIMAL(5,4) COMMENT 'The ratio of real power to apparent power, ranging from 0 to 1. Indicates the efficiency of power usage and may trigger power factor penalties or credits.',
  `reactive_power_kvar` DECIMAL(18,3) COMMENT 'The reactive power component measured in kilovolt-amperes reactive. Used for power factor calculations and grid stability analysis.',
  `reading_timestamp` TIMESTAMP COMMENT 'The timestamp when the meter physically recorded this interval data. May differ from interval_end_timestamp in cases of delayed meter reads or backfill scenarios.',
  `temperature_fahrenheit` DECIMAL(5,2) COMMENT 'The ambient temperature in degrees Fahrenheit recorded at the associated weather station during this interval. Used for load forecasting and weather normalization.',
  `tou_period_code` STRING COMMENT 'The time-of-use pricing period classification for this interval (e.g., on-peak, off-peak, shoulder). Determines the rate tier applied for billing.',
  `unit_of_measure` STRING COMMENT 'The measurement unit for the primary consumption value. Standardizes interpretation of numeric readings across different meter types and configurations. Valid values: kWh|kW|kVAR|kVA|MWh|MW.',
  `validation_status` STRING COMMENT 'The quality status assigned by the VEE process indicating whether the reading is original valid data, was estimated, edited, substituted, flagged as suspect, or missing. Valid values: valid|estimated|edited|substituted|suspect|missing.',
  `vee_processing_timestamp` TIMESTAMP COMMENT 'The date and time when the VEE process completed validation and transformation of this reading into its final billing-quality state.',
  `vee_run_code` BIGINT COMMENT 'Reference to the VEE processing batch run that produced this validated reading. Enables traceability of which VEE execution cycle processed this data.',
  `voltage_volts` DECIMAL(10,2) COMMENT 'The average voltage level measured during this interval in volts. Used for power quality monitoring and voltage regulation analysis.',
  `weather_station_code` BIGINT COMMENT 'Reference to the weather station used for temperature normalization and weather-adjusted load analysis for this service point location.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_metering_validated_interval_reading` PRIMARY KEY (`validated_interval_reading_id`)
)
USING DELTA
COMMENT 'VEE-processed (Validation, Estimation, and Editing) interval data representing the authoritative, billing-quality energy consumption record for each meter point and interval. Stores validated kWh, kW demand, reactive power (kVAR), power factor, VEE rule applied, estimation method (if estimated), editor identifier, validation status (valid/estimated/edited/substituted), and VEE processing run reference. This is the SSOT for consumption data consumed by billing, demand response, and grid operations domains. Distinct from raw interval_reading by lifecycle stage and quality assurance. | CMM: CIM IntervalReading (close), IEC61968::Metering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ValidatedIntervalReading',
  'cmm.cim.class' = 'IntervalReading',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Metering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-9',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.validated_interval_reading'
);

-- MeterRead  <<CIM Reading : exact>>
CREATE TABLE IF NOT EXISTS `metering`.`meter_read` (
  `meter_read_id` BIGINT NOT NULL COMMENT 'Unique identifier for the meter read record. Primary key. Role: TRANSACTION_HEADER (scalar meter reading event with lifecycle and scheduling governance).',
  `account_id` BIGINT COMMENT 'Reference to the customer account responsible for this service point. Enables customer-level consumption reporting.',
  `ami_event_id` BIGINT COMMENT 'Unique identifier from the AMI head-end system for this read event. Used to correlate the scalar read with interval data and AMI system logs. Null for non-AMI reads.',
  `billing_run_id` BIGINT COMMENT 'Reference to the billing run that consumed this meter read for invoice calculation. Null if not yet billed. Used for billing audit and revenue assurance.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Aggregated meter reads feed control area load profiles for interchange accounting and NERC reporting. Standard practice for balancing authority operations and compliance.',
  `cycle_id` BIGINT COMMENT 'Reference to the billing cycle for which this read was captured. Links the read to the billing run and invoice generation process.',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: Register-based reads from DER meters support NEM annual true-up calculations, monthly generation reporting, and capacity factor verification. NEM true-up process requires cumulative meter reads linked',
  `meter_id` BIGINT COMMENT 'Reference to the physical meter device from which this reading was captured. Links to the meter asset registry.',
  `premise_id` BIGINT COMMENT 'Reference to the service premise where the meter is installed. Enables geographic and customer aggregation of reads.',
  `primary_meter_point_id` BIGINT COMMENT 'Reference to the logical service point (delivery point) associated with this meter read. Used for billing and consumption analysis.',
  `rate_schedule_id` BIGINT COMMENT 'Reference to the rate schedule (tariff) in effect for this service point at the time of the read. Used to determine Time-of-Use (TOU) periods, Critical Peak Pricing (CPP) applicability, and billing determinants.',
  `reader_employee_id` BIGINT COMMENT 'Reference to the employee (field technician or meter reader) who captured the reading. Null for automated AMI/AMR reads. Used for workforce productivity analysis and audit trails.',
  `register_id` BIGINT COMMENT 'Reference to the specific register on the meter (e.g., kWh delivered, kWh received, kVArh). Multi-register meters have multiple read records per read event.',
  `route_id` BIGINT COMMENT 'Reference to the meter reading route assignment for manual reads. Defines the geographic sequence and schedule for field crews. Null for automated reads.',
  `to_meter_point_id` BIGINT COMMENT 'FK to metering.meter_point.meter_point_id — Scalar meter reads must reference the meter point where the read was taken. Essential for billing cycle consumption calculation.',
  `vee_rule_id` BIGINT COMMENT 'Reference to the VEE (Validation, Estimation, and Editing) rule that processed this read. Links to the validation rule configuration for audit and troubleshooting.',
  `average_daily_usage` DECIMAL(18,3) COMMENT 'Consumption divided by consumption days. Expressed in kWh per day or MWh per day. Used for customer usage profiling, demand response eligibility, and anomaly detection.',
  `billed_flag` BOOLEAN COMMENT 'Indicates whether this meter read has been used in a billing run and invoice generation. True if billed; False if pending or unbilled. Used to prevent duplicate billing and support billing cycle reconciliation.',
  `consumption_days` INT COMMENT 'Number of days between the current read date and the previous read date. Used to normalize consumption for billing and to calculate average daily usage.',
  `consumption_kwh` DECIMAL(18,3) COMMENT 'Calculated energy consumption for the period (current read value minus previous read value). Expressed in kilowatt-hours (kWh) or megawatt-hours (MWh). This is the billable quantity fed to the billing domain.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this meter read record was first created in the MDM (Meter Data Management) system. Used for data lineage and audit trails.',
  `demand_kw` DECIMAL(18,3) COMMENT 'Peak demand recorded during the read period, expressed in kilowatts (kW) or megawatts (MW). Captured for commercial and industrial customers on demand-based rate schedules. Null for residential meters without demand registers.',
  `demand_timestamp` TIMESTAMP COMMENT 'Date and time when the peak demand occurred during the read period. Used for Time-of-Use (TOU) and Critical Peak Pricing (CPP) rate application.',
  `estimation_method` STRING COMMENT 'Algorithm or rule used to estimate the read value when actual read was unavailable. Examples: HIST_AVG (historical average), PREV_YEAR (same period prior year), PRO_RATA (prorated from partial period), ADL (average daily load). Null for actual reads.',
  `exception_code` STRING COMMENT 'Code identifying any exception or anomaly detected during read capture or validation. Examples: HIGH_USAGE, LOW_USAGE, ZERO_CONSUMPTION, NEGATIVE_CONSUMPTION, TAMPER, COMM_FAILURE. Used to trigger investigation workflows.',
  `multiplier` DECIMAL(10,4) COMMENT 'Constant multiplier applied to the raw register reading to calculate actual consumption. Used for current transformer (CT) and potential transformer (PT) ratios on high-voltage meters. Default is 1.0 for direct-connected meters.',
  `previous_read_date` DATE COMMENT 'Date of the prior valid read for this register. Used to calculate the consumption period length (days between reads) and validate read sequence.',
  `previous_read_value` DECIMAL(18,3) COMMENT 'The register value from the prior valid read. Used to calculate consumption (current read minus previous read) and detect anomalies such as reverse flow or register rollover.',
  `read_cycle_code` STRING COMMENT 'Code identifying the recurring read schedule pattern. Examples: M01 (monthly cycle 1), B15 (bi-monthly cycle 15), D (daily), W (weekly). Aligns with billing cycle and route planning.',
  `read_date` DATE COMMENT 'The calendar date on which the meter reading was captured. Principal business event timestamp for billing cycle alignment and consumption period determination.',
  `read_frequency` STRING COMMENT 'The recurring interval at which reads are scheduled for this meter. Monthly: standard residential. Bi-monthly: some residential jurisdictions. Daily: large commercial/industrial or AMI. On-demand: special reads only. Valid values: monthly|bi-monthly|quarterly|daily|on-demand.',
  `read_method` STRING COMMENT 'Technical method used to capture the reading. Optical: infrared port. RF: radio frequency. PLC: power line carrier. Cellular: mobile network. Visual: technician reads display. Handheld: portable reader device. Valid values: optical|RF|PLC|cellular|visual|handheld.',
  `read_quality_code` STRING COMMENT 'Standardized code indicating the quality or exception condition of the read. Examples: OK (normal), EST (estimated), REV (reverse flow), OVF (overflow), PWR (power outage), TMR (tamper detected). Aligns with ANSI C12.19 quality flags.',
  `read_reason_code` STRING COMMENT 'Business reason for the read event. Examples: BILL (billing cycle), MOVE (move-in/move-out), DISC (disconnect), RECON (reconnect), INSP (inspection), COMP (complaint investigation). Used for operational reporting and audit.',
  `read_sequence_number` STRING COMMENT 'Business identifier for the meter read, often formatted as meter number plus read date. Used for external reference and audit trails.',
  `read_source` STRING COMMENT 'Method by which the reading was obtained. AMI: Advanced Metering Infrastructure (two-way automated). AMR: Automated Meter Reading (one-way drive-by). Manual: field technician on-site. Estimated: calculated by VEE (Validation, Estimation, and Editing) process. Customer: self-reported. Remote: handheld or mobile device. Valid values: AMI|AMR|manual|estimated|customer|remote.',
  `read_status` STRING COMMENT 'Current lifecycle status of the meter read. Valid: passed VEE (Validation, Estimation, and Editing) and accepted for billing. Estimated: calculated value pending actual read. Suspect: flagged for review. Failed: read attempt unsuccessful. Pending_validation: awaiting VEE processing. Corrected: replaced by subsequent correction read. Valid values: valid|estimated|suspect|failed|pending_validation|corrected.',
  `read_timestamp` TIMESTAMP COMMENT 'Precise date and time when the meter reading was captured, including time zone. Used for interval boundary alignment and AMI (Advanced Metering Infrastructure) event correlation.',
  `read_type` STRING COMMENT 'Classification of the read event. Scheduled: routine billing cycle read. Special: off-cycle read for move-in/move-out or investigation. Final: account closure. Initial: new service activation. Test: commissioning or validation. Correction: replacement of erroneous prior read. Valid values: scheduled|special|final|initial|test|correction.',
  `read_uom` STRING COMMENT 'Unit of measure for the read value. Common values: kWh (kilowatt-hour), MWh (megawatt-hour), kVArh (kilovolt-ampere reactive hour) for electric; CCF, MCF, Therms for gas; Gallons for water. Reference-value candidates: kWh|MWh|kVArh|MVArh|kW|MW|kVA|MVA|CCF|MCF|Therms|Gallons.',
  `read_value` DECIMAL(18,3) COMMENT 'The cumulative register value captured at the read timestamp. For energy meters, typically kilowatt-hours (kWh) or megawatt-hours (MWh). This is the raw scalar reading before consumption calculation.',
  `register_digits` INT COMMENT 'Number of digits on the meter register display. Used to detect register rollover (e.g., a 5-digit register rolls from 99999 to 00000). Typical values: 5, 6, 7.',
  `register_rollover_flag` BOOLEAN COMMENT 'Indicates whether the register rolled over during this read period (current read value is less than previous read value due to register capacity limit). True if rollover detected; False otherwise.',
  `scheduled_read_date` DATE COMMENT 'The planned date for this meter read as defined by the read schedule. Used to measure on-time read performance and identify late or early reads.',
  `tou_period` STRING COMMENT 'The TOU rate period for this register reading. On-peak: highest rate hours. Off-peak: lowest rate hours. Shoulder: mid-tier hours. Super-off-peak: ultra-low rate hours (e.g., overnight EV charging). Null for non-TOU registers. Valid values: on-peak|off-peak|shoulder|super-off-peak.',
  `tou_register_flag` BOOLEAN COMMENT 'Indicates whether this register captures Time-of-Use (TOU) segmented consumption (e.g., on-peak, off-peak, shoulder). True for TOU registers; False for cumulative registers. TOU meters have multiple read records per read event.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this meter read record was last modified. Tracks VEE corrections, status changes, and data quality improvements.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_metering_meter_read` PRIMARY KEY (`meter_read_id`)
)
USING DELTA
COMMENT 'Scalar (register-level) meter reading record and associated read scheduling — capturing both the cumulative register value at a specific point in time and the recurring schedule governing when reads are collected. For readings: stores read date, read time, register identifier, read value, read type (scheduled/special/final/initial), read source (AMR/AMI/manual/estimated), reader employee reference, and read quality flag. For scheduling: defines read cycle (monthly/bi-monthly/daily), read method (AMI automated/manual route), scheduled read date, route assignment, billing cycle alignment, schedule code, and active status. Drives field crew routing for manual reads and AMI polling schedules for automated collection. Feeds billing domain consumption calculation. Distinct from interval_reading (which is time-series) — this is the periodic scalar snapshot and its collection governance. | CMM: CIM Reading (exact), IEC61968::Metering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MeterRead',
  'cmm.cim.class' = 'Reading',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Metering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-9',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.meter_read'
);

-- VeeRule  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `metering`.`vee_rule` (
  `vee_rule_id` BIGINT NOT NULL COMMENT 'Unique identifier for the VEE rule. Primary key for the VEE rule reference entity.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: VEE rules implement regulatory obligations for data quality, estimation limits, validation thresholds mandated by state PUC orders. Enables compliance mapping, regulatory justification for VEE algorit',
  `algorithm_type` STRING COMMENT 'The computational algorithm or method used by the rule to validate, estimate, or edit meter data (e.g., threshold-based, statistical analysis, linear regression, interpolation). Reference-value candidates: threshold|statistical|regression|interpolation|substitution|comparison|pattern_matching.',
  `applicable_meter_types` STRING COMMENT 'Comma-separated list of meter types to which this VEE rule applies (e.g., AMI electric, AMI gas, interval demand, TOU residential). Defines the scope of rule application within the meter population.',
  `applicable_rate_schedules` STRING COMMENT 'Comma-separated list of rate schedule codes to which this VEE rule applies. Enables rate-specific validation and estimation logic for TOU and CPP programs.',
  `applicable_service_types` STRING COMMENT 'Type of utility service to which this VEE rule applies (electric, gas, water, steam). Ensures rules are applied to appropriate commodity data streams. Valid values: electric|gas|water|steam.',
  `approval_required_flag` BOOLEAN COMMENT 'Indicates whether changes to this VEE rule require formal approval before activation. True for rules impacting billing or regulatory compliance.',
  `approved_by` STRING COMMENT 'User identifier of the person who approved this VEE rule for production use. Applicable when approval_required_flag is true.',
  `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when this VEE rule was formally approved for production use. Supports governance and compliance documentation.',
  `audit_trail_enabled_flag` BOOLEAN COMMENT 'Indicates whether detailed audit logging is enabled for this rule, capturing every application of the rule and its outcomes for compliance and troubleshooting.',
  `billing_quality_flag` BOOLEAN COMMENT 'Indicates whether data passing this VEE rule is considered billing-quality and suitable for revenue calculation. True if the rule ensures billing-grade accuracy.',
  `confidence_threshold_percent` DECIMAL(5,2) COMMENT 'Minimum confidence level (as a percentage) required for estimated values to be accepted as billing-quality. Used in statistical estimation algorithms.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this VEE rule record was first created in the MDM system. Supports audit trail and data lineage.',
  `effective_end_date` DATE COMMENT 'Date after which the VEE rule is no longer active. Nullable for open-ended rules. Supports rule lifecycle management and historical analysis.',
  `effective_start_date` DATE COMMENT 'Date from which the VEE rule becomes active and is applied to meter data. Supports temporal rule management and regulatory compliance.',
  `estimation_method` STRING COMMENT 'Specific estimation technique used when the rule type is estimation. Defines how missing or invalid interval data is calculated (e.g., linear interpolation, historical average, same-day-last-week). Reference-value candidates: linear_interpolation|historical_average|same_day_last_week|same_day_last_year|regression|zero_fill|prior_value.',
  `exception_handling_action` STRING COMMENT 'Action taken when the rule detects a data quality exception: flag for review, automatically estimate, reject the data, route to manual review, or substitute with a default value. Valid values: flag_only|estimate|reject|manual_review|substitute.',
  `execution_frequency` STRING COMMENT 'Frequency at which the VEE rule is executed against incoming or historical meter data (real-time, hourly, daily, weekly, on-demand). Valid values: real_time|hourly|daily|weekly|on_demand.',
  `last_modified_by` STRING COMMENT 'User identifier of the person who last modified this VEE rule record. Supports change tracking and accountability.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this VEE rule record was last modified. Supports audit trail and change management.',
  `lookback_period_days` INT COMMENT 'Number of days of historical data the rule examines for validation or estimation purposes. Used by statistical and pattern-matching algorithms.',
  `lower_limit` DECIMAL(18,4) COMMENT 'Minimum acceptable value for validation rules. Interval data below this limit triggers a validation exception or editing action.',
  `notes` STRING COMMENT 'Free-text field for additional notes, implementation guidance, or special considerations related to this VEE rule. Supports knowledge transfer and operational documentation.',
  `owner_group` STRING COMMENT 'Business unit or team responsible for maintaining and governing this VEE rule (e.g., Metering Operations, Revenue Assurance, Data Quality Team).',
  `priority_order` INT COMMENT 'Execution sequence priority for the rule within the VEE processing engine. Lower numbers execute first. Determines the order in which multiple rules are applied to the same interval data.',
  `regulatory_basis` STRING COMMENT 'Citation of the regulatory requirement, tariff provision, or PUC order that mandates or justifies this VEE rule. Supports compliance documentation and audit trails.',
  `rule_category` STRING COMMENT 'Functional category of the rule indicating the specific data quality issue it addresses (e.g., spike detection, zero consumption validation, missing data estimation). Valid values: spike_detection|zero_consumption|negative_value|missing_data|high_low_limit|consistency_check.',
  `rule_code` STRING COMMENT 'Business identifier code for the VEE rule, used for external reference and system integration. Typically a short alphanumeric code following utility naming conventions. Pattern: ^[A-Z0-9_]{3,20}$.',
  `rule_description` STRING COMMENT 'Detailed description of the VEE rule including its business logic, application context, and expected outcomes when applied to interval meter data.',
  `rule_name` STRING COMMENT 'Human-readable name of the VEE rule describing its purpose and function within the meter data management process.',
  `rule_status` STRING COMMENT 'Current lifecycle status of the VEE rule indicating whether it is actively applied to meter data processing or in a non-operational state. Valid values: active|inactive|draft|testing|retired|suspended.',
  `rule_type` STRING COMMENT 'Classification of the rule within the VEE process: validation (checks data quality), estimation (fills missing data), or editing (corrects erroneous data). Valid values: validation|estimation|editing.',
  `threshold_unit` STRING COMMENT 'Unit of measure for the threshold value (e.g., kWh, MWh, percentage, count, standard deviations) providing context for threshold interpretation. Valid values: kWh|MWh|percentage|count|standard_deviation|ratio.',
  `threshold_value` DECIMAL(18,4) COMMENT 'Numeric threshold parameter used by the rule algorithm to determine data quality exceptions. For example, spike tolerance percentage, maximum consumption limit, or minimum expected value.',
  `upper_limit` DECIMAL(18,4) COMMENT 'Maximum acceptable value for validation rules. Interval data above this limit triggers a validation exception or editing action.',
  `version_number` INT COMMENT 'Version number of the VEE rule configuration. Incremented with each modification to support change tracking and rollback capabilities.',
  `created_by` STRING COMMENT 'User identifier of the person who created this VEE rule record. Supports accountability and audit requirements.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_metering_vee_rule` PRIMARY KEY (`vee_rule_id`)
)
USING DELTA
COMMENT 'Defines the business rules applied during the VEE (Validation, Estimation, and Editing) process in Oracle Utilities MDM. Each rule specifies the rule type (validation/estimation/editing), rule algorithm, threshold parameters (e.g., spike tolerance percentage, zero-consumption threshold), applicable meter types, priority order, effective date range, and regulatory basis. Governs data quality for billing-quality interval data. Reference entity managed by the metering operations team. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'VeeRule',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'reference_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.vee_rule'
);

-- VeeException  <<CIM ReadingQuality : close>>
CREATE TABLE IF NOT EXISTS `metering`.`vee_exception` (
  `vee_exception_id` BIGINT NOT NULL COMMENT 'Unique identifier for the VEE exception record. Primary key for the VEE exception entity.',
  `account_id` BIGINT COMMENT 'Reference to the customer account associated with the meter and service point for this VEE exception. Used for customer impact analysis and billing hold workflows.',
  `audit_finding_id` BIGINT COMMENT 'Foreign key linking to compliance.audit_finding. Business justification: VEE exceptions identified as audit findings when indicating systematic data quality issues or control deficiencies. Supports audit evidence collection, corrective action tracking, regulatory reporting',
  `employee_id` BIGINT COMMENT 'Reference to the employee or system user who reviewed and resolved this VEE exception. Null if exception is still open or was auto-resolved without manual review.',
  `event_id` BIGINT COMMENT 'Foreign key linking to outage.outage_event. Business justification: VEE analysts investigate whether missing/anomalous interval readings stem from power interruptions. Regulatory VEE reports require cross-referencing exceptions with outage events to justify estimation',
  `meter_id` BIGINT COMMENT 'Reference to the meter that generated the interval data which triggered this VEE exception.',
  `meter_point_id` BIGINT COMMENT 'Reference to the service point (delivery location) associated with the meter that generated the interval data for this exception. Used to link exceptions to customer accounts and premises.',
  `primary_vee_rule_id` BIGINT COMMENT 'Reference to the VEE rule that was triggered and caused this exception to be raised.',
  `rate_schedule_id` BIGINT COMMENT 'Reference to the rate schedule (tariff) applicable to the service point at the time of the exception. Used to determine billing impact and priority for resolution, especially for Time-of-Use (TOU) and Critical Peak Pricing (CPP) customers.',
  `to_interval_reading_id` BIGINT COMMENT 'FK to metering.interval_reading.interval_reading_id — VEE exceptions must reference the interval reading(s) that failed validation. Without this link, operators cannot identify and resolve data quality issues.',
  `to_vee_rule_id` BIGINT COMMENT 'FK to metering.vee_rule.vee_rule_id — Each VEE exception must reference the VEE rule that triggered it. This is essential for exception resolution workflows and rule tuning.',
  `vee_interval_reading_id` BIGINT COMMENT 'Reference to the specific interval data record that failed VEE validation and raised this exception.',
  `auto_resolution_attempted` BOOLEAN COMMENT 'Boolean flag indicating whether the VEE engine attempted automatic resolution of this exception through estimation algorithms. True if auto-resolution was attempted; False if exception was immediately flagged for manual review.',
  `auto_resolution_successful` BOOLEAN COMMENT 'Boolean flag indicating whether automatic resolution by the VEE engine was successful. True if the engine successfully estimated a replacement value that passed validation; False if auto-resolution failed and manual intervention is required.',
  `billing_impact_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this VEE exception affects customer billing. True if the affected interval data is used in billing determinants and the exception must be resolved before bill calculation; False if the exception is for non-billing data (e.g., operational monitoring, grid analytics).',
  `corrected_value` DECIMAL(18,3) COMMENT 'Final corrected interval data value (in kWh or other unit of measure) after manual review and editing. This is the value that will be used for billing if the exception is resolved. Null if not yet corrected.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this VEE exception record was first created in the MDM system. Audit field for data lineage and record lifecycle tracking.',
  `data_quality_score` DECIMAL(5,2) COMMENT 'Numeric data quality score (0.00 to 100.00) assigned to the interval data by the VEE engine, indicating confidence in the data accuracy. Lower scores trigger exceptions. Used for trending meter health and VEE rule tuning.',
  `estimated_value` DECIMAL(18,3) COMMENT 'Estimated interval data value (in kWh or other unit of measure) calculated by the VEE engine to replace the invalid or missing original value. Null if estimation was not performed or failed.',
  `estimation_method` STRING COMMENT 'Method used by the VEE engine or analyst to estimate the corrected interval value. Linear interpolation: average of adjacent intervals. Historical average: average of same interval from prior days. Similar day: value from comparable day (same day-of-week, season). Regression: statistical model. Manual entry: analyst-provided value. None: no estimation performed. Valid values: linear_interpolation|historical_average|similar_day|regression|manual_entry|none.',
  `exception_disposition` STRING COMMENT 'Final disposition category of the VEE exception indicating how it was ultimately handled. Resolved: data corrected and validated. Escalated: sent to engineering or management for further investigation. Waived: accepted without correction per approved business rule or regulatory guidance. Valid values: resolved|escalated|waived.',
  `exception_number` STRING COMMENT 'Business-facing unique exception number assigned to this VEE exception for tracking and audit purposes. Format: VEE-xxxxxxxxxx. Pattern: ^VEE-[0-9]{10}$.',
  `exception_raised_timestamp` TIMESTAMP COMMENT 'Timestamp when the VEE exception was first raised by the MDM VEE engine during interval data validation processing. Represents the business event time of exception detection.',
  `exception_severity` STRING COMMENT 'Severity level of the VEE exception indicating business impact and urgency for resolution. Critical exceptions block billing; high exceptions require immediate review; medium and low exceptions are tracked for quality metrics; informational exceptions are logged for audit only. Valid values: critical|high|medium|low|informational.',
  `exception_source_system` STRING COMMENT 'Source system that originated the interval data which triggered this VEE exception. Typically MDM (Meter Data Management) for AMI data, AMI head-end for direct meter reads, SCADA for grid operations data, manual entry for field reads, or billing system for estimated reads. Valid values: MDM|AMI_head_end|SCADA|manual_entry|billing_system.',
  `exception_status` STRING COMMENT 'Current lifecycle status of the VEE exception. Open: newly raised and awaiting review. In Review: assigned to analyst for investigation. Resolved: corrective action taken and data corrected. Escalated: requires supervisor or engineering review. Waived: exception accepted without correction per business rule. Closed: final disposition recorded and exception archived. Valid values: open|in_review|resolved|escalated|waived|closed.',
  `exception_type` STRING COMMENT 'Classification of the VEE exception indicating the nature of the data quality issue: validation failure (data failed validation rule), estimation failure (unable to estimate missing interval), editing failure (manual edit rejected), missing data (no interval data received), suspect data (data flagged as questionable), or out of range (value exceeds expected bounds). Valid values: validation_failure|estimation_failure|editing_failure|missing_data|suspect_data|out_of_range.',
  `interval_count` INT COMMENT 'Number of individual interval readings affected by this VEE exception. For 15-minute interval meters, a 1-hour exception would affect 4 intervals.',
  `interval_end_timestamp` TIMESTAMP COMMENT 'End timestamp of the interval data range affected by this VEE exception. Defines the end of the time window containing suspect or invalid data.',
  `interval_start_timestamp` TIMESTAMP COMMENT 'Start timestamp of the interval data range affected by this VEE exception. Defines the beginning of the time window containing suspect or invalid data.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this VEE exception record was last updated. Audit field for tracking changes to exception status, resolution actions, and data corrections.',
  `original_value` DECIMAL(18,3) COMMENT 'Original raw interval data value (in kWh or other unit of measure) that triggered the VEE exception before any estimation or editing was applied.',
  `regulatory_reportable_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this VEE exception must be reported to regulatory authorities (e.g., state Public Utility Commission) as part of data quality and billing accuracy compliance reporting. True if reportable; False otherwise.',
  `resolution_action` STRING COMMENT 'Action taken to resolve the VEE exception. Re-estimate: apply different estimation algorithm. Manual edit: analyst manually corrected the value. Accept original: original value accepted despite exception. Override: supervisor approved exception without correction. Escalate: sent to engineering for investigation. Waive: exception acknowledged but no correction required per business rule. Valid values: re_estimate|manual_edit|accept_original|override|escalate|waive.',
  `resolution_notes` STRING COMMENT 'Free-text notes entered by the analyst or system documenting the resolution action, rationale for the decision, and any additional context for audit purposes.',
  `resolution_timestamp` TIMESTAMP COMMENT 'Timestamp when the VEE exception was resolved (status changed to resolved, waived, or closed). Null if exception is still open or in review. Used to calculate exception aging and VEE team performance metrics.',
  `reviewer_name` STRING COMMENT 'Full name of the analyst or system user who reviewed and resolved this VEE exception. Captured for audit trail and operational reporting.',
  `threshold_value` DECIMAL(18,3) COMMENT 'Numeric threshold value defined in the VEE rule that was exceeded or violated, triggering this exception. For example, maximum expected consumption in kWh, or maximum percent deviation from historical average.',
  `unit_of_measure` STRING COMMENT 'Unit of measure for the interval data values associated with this exception. Typically kWh (kilowatt-hour) for electric energy consumption, kW for demand, or gas volume units. Reference-value candidates: kWh|MWh|kW|kVAR|kVA|CCF|MCF|therms.',
  `vee_batch_code` BIGINT COMMENT 'Reference to the VEE processing batch run that raised this exception. Used to group exceptions by processing cycle for operational dashboards and batch-level quality metrics.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_metering_vee_exception` PRIMARY KEY (`vee_exception_id`)
)
USING DELTA
COMMENT 'Operational record of a VEE processing exception raised during interval data validation or estimation — capturing intervals that failed validation rules and required manual review, automatic re-estimation, or override. Stores exception type, severity, affected interval range (start/end timestamps), VEE rule triggered, auto-resolution status, manual reviewer identifier, resolution action taken (re-estimate/edit/accept/override), resolution timestamp, and exception disposition (resolved/escalated/waived). Supports MDM data quality workflows, operational dashboards for VEE pass rates, and regulatory audit trails for billing data integrity. Key metric: exception rate by rule type drives VEE rule tuning. | CMM: CIM ReadingQuality (close), IEC61968::Metering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'VeeException',
  'cmm.cim.class' = 'ReadingQuality',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Metering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-9',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.vee_exception'
);

-- AmiHeadEnd  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `metering`.`ami_head_end` (
  `ami_head_end_id` BIGINT NOT NULL COMMENT 'Unique identifier for the AMI head-end system instance. Primary key.',
  `capex_project_id` BIGINT COMMENT 'Foreign key linking to finance.capex_project. Business justification: AMI head-end deployments are major capital projects requiring CPCN approval and IRP alignment. Essential for smart grid investment tracking, project cost-to-completion monitoring, RAB inclusion date d',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: AMI infrastructure O&M costs (software licenses, maintenance, network operations) are allocated to cost centers. Required for smart grid program cost tracking, rate case O&M justification, and regulat',
  `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: AMI head-end systems are capital assets (FERC Account 397 - Communication Equipment). Required for smart grid capital asset tracking, depreciation calculation, asset retirement obligation accounting,',
  `nerc_cip_asset_id` BIGINT COMMENT 'Foreign key linking to compliance.nerc_cip_asset. Business justification: AMI head-end systems classified as BES Cyber Systems under NERC CIP-002, requiring cybersecurity controls. Enables CIP compliance tracking, vulnerability assessment scheduling, cyber security incident',
  `registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: AMI head-end systems are capital network infrastructure assets requiring asset tagging, depreciation, maintenance plans, warranty tracking, and rate base inclusion. Utilities manage these as major IT/',
  `actual_uptime_percent` DECIMAL(5,2) COMMENT 'Actual measured network uptime availability for the head-end system over the most recent reporting period, expressed as a percentage.',
  `average_collection_success_rate_percent` DECIMAL(5,2) COMMENT 'Rolling average success rate for scheduled collection runs over a defined reporting period (e.g., 30 days), expressed as a percentage.',
  `commissioning_date` DATE COMMENT 'Date when the head-end system was officially commissioned and placed into production service.',
  `communication_protocol` STRING COMMENT 'Primary communication protocol used by the head-end system to communicate with smart meters (e.g., RF Mesh, Power Line Carrier, Cellular, Hybrid). Valid values: RF Mesh|PLC|Cellular|Hybrid|Other.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this head-end system record was first created in the system.',
  `current_enrolled_device_count` INT COMMENT 'Current number of smart meters or devices actively enrolled and communicating with this head-end system instance.',
  `data_retention_days` INT COMMENT 'Number of days that raw interval data and collection logs are retained in the head-end system before archival or purging.',
  `firmware_update_capability_flag` BOOLEAN COMMENT 'Indicates whether the head-end system has the capability to perform over-the-air firmware updates to enrolled smart meters.',
  `geographic_coverage_area` STRING COMMENT 'Geographic region or service territory covered by this head-end system instance (e.g., \'Northern District\', \'Metro Service Area\', \'Region 3\').',
  `installation_date` DATE COMMENT 'Date when the head-end system was installed and commissioned for operational use.',
  `last_collection_completeness_percent` DECIMAL(5,2) COMMENT 'Data completeness metric for the most recent collection run, representing the percentage of expected interval data records successfully retrieved.',
  `last_collection_duration_minutes` INT COMMENT 'Duration in minutes required to complete the most recent scheduled meter data collection run.',
  `last_collection_success_rate_percent` DECIMAL(5,2) COMMENT 'Success rate of the most recent scheduled collection run, expressed as a percentage of meters successfully read versus total meters attempted.',
  `last_maintenance_date` DATE COMMENT 'Date of the most recent scheduled or unscheduled maintenance activity performed on the head-end system.',
  `last_scheduled_collection_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent scheduled meter data collection run executed by the head-end system.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this head-end system record was most recently updated or modified.',
  `maximum_device_capacity` INT COMMENT 'Maximum number of smart meters or devices that this head-end system instance is designed to support concurrently.',
  `mdm_integration_endpoint_url` STRING COMMENT 'URL or network endpoint address used for integration and data exchange between the head-end system and the MDM system (Oracle Utilities MDM).',
  `mdm_integration_protocol` STRING COMMENT 'Communication protocol or method used for data exchange between the head-end system and the MDM system (e.g., REST API, SOAP, FTP, SFTP, Message Queue, Kafka). Reference-value candidates: REST.',
  `mdm_integration_status` STRING COMMENT 'Current operational status of the integration link between the head-end system and the MDM system. Valid values: Active|Inactive|Error|Pending.',
  `network_topology` STRING COMMENT 'Network architecture topology employed by the head-end system for meter communication (e.g., Mesh, Star, Point-to-Point, Hybrid). Valid values: Mesh|Star|Point-to-Point|Hybrid.',
  `network_uptime_sla_percent` DECIMAL(5,2) COMMENT 'Contractual or operational target for network uptime availability expressed as a percentage (e.g., 99.95%).',
  `next_scheduled_maintenance_date` DATE COMMENT 'Date when the next scheduled maintenance activity is planned for the head-end system.',
  `on_demand_collection_enabled_flag` BOOLEAN COMMENT 'Indicates whether the head-end system supports and has enabled on-demand (ad-hoc) meter reading requests.',
  `operational_status` STRING COMMENT 'Current operational state of the head-end system in its lifecycle (Active, Inactive, Maintenance, Decommissioned, Testing). Valid values: Active|Inactive|Maintenance|Decommissioned|Testing.',
  `outage_detection_enabled_flag` BOOLEAN COMMENT 'Indicates whether the head-end system has outage detection and last-gasp notification capabilities enabled for integration with Outage Management System (OMS).',
  `primary_contact_email` STRING COMMENT 'Email address of the primary technical contact or system administrator for this head-end system instance. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `primary_contact_name` STRING COMMENT 'Name of the primary technical contact or system administrator responsible for this head-end system instance.',
  `primary_contact_phone` STRING COMMENT 'Phone number of the primary technical contact or system administrator for this head-end system instance.',
  `remote_disconnect_capability_flag` BOOLEAN COMMENT 'Indicates whether the head-end system supports remote service connect/disconnect commands to smart meters.',
  `scheduled_collection_frequency` STRING COMMENT 'Frequency at which the head-end system executes scheduled meter data collection runs (e.g., Hourly, Daily, Weekly, Monthly, On-Demand). Valid values: Hourly|Daily|Weekly|Monthly|On-Demand.',
  `software_version` STRING COMMENT 'Current software version or release number of the head-end system, used for compatibility tracking and upgrade planning.',
  `system_identifier` STRING COMMENT 'Externally-known unique code or serial number for the head-end system instance, used for vendor support and integration references.',
  `system_name` STRING COMMENT 'Business name or designation of the AMI head-end system instance (e.g., \'North Region AMI HES\', \'Metro Area Head-End\').',
  `system_notes` STRING COMMENT 'Free-text field for additional notes, comments, or special configuration details about the head-end system instance.',
  `vendor_name` STRING COMMENT 'Name of the vendor or manufacturer that provides the AMI head-end system platform. Pattern: Itron|Landis+Gyr|Sensus|Aclara|Elster|Honeywell|Trilliant|Silver Spring Networks|Other.',
  `vendor_support_contract_number` STRING COMMENT 'Contract or agreement number for vendor support and maintenance services for this head-end system instance.',
  `vendor_support_expiration_date` DATE COMMENT 'Date when the current vendor support and maintenance contract expires for this head-end system instance.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_metering_ami_head_end` PRIMARY KEY (`ami_head_end_id`)
)
USING DELTA
COMMENT 'Master record for each AMI head-end system instance managing a population of smart meters — the central communication hub for the AMI network. Captures head-end system name, vendor, software version, communication protocol (RF mesh, PLC, cellular), geographic coverage area, maximum device capacity, current enrolled device count, network uptime SLA, integration endpoint details for MDM, and data collection run statistics (scheduled/on-demand collection execution, success rates, timing, and completeness metrics). Supports multi-vendor AMI environments, head-end performance monitoring, and MDM data completeness tracking for VEE processing readiness. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AmiHeadEnd',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.ami_head_end'
);

-- AmiEvent  <<CIM EndDeviceEvent : exact>>
CREATE TABLE IF NOT EXISTS `metering`.`ami_event` (
  `ami_event_id` BIGINT NOT NULL COMMENT 'Unique identifier for the AMI event record. Primary key for the AMI event entity.',
  `ami_meter_id` BIGINT COMMENT 'Identifier of the smart meter that generated this event. Links to the meter asset registry.',
  `customer_account_id` BIGINT COMMENT 'Identifier of the customer account associated with the meter that generated this event. Links event to billing and customer service systems.',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_system. Business justification: AMI tamper and reverse-flow events on DER-connected meters require DER system context for investigation, export limit compliance verification, and anti-islanding protection validation. Critical for gr',
  `employee_id` BIGINT COMMENT 'Identifier of the field technician or investigator assigned to investigate this event. Applicable primarily to tamper and high-severity events requiring field investigation. Null for auto-resolved or low-priority events.',
  `feeder_id` BIGINT COMMENT 'Identifier of the distribution feeder circuit serving the meter. Used for outage correlation, load analysis, and SAIDI/SAIFI reliability calculations. Null if feeder association is not available.',
  `premise_id` BIGINT COMMENT 'Identifier of the service premise (physical location) where the meter is installed and the event occurred. Links event to geographic and network topology data.',
  `primary_ami_head_end_id` BIGINT COMMENT 'Foreign key linking to metering.ami_head_end. Business justification: AMI events are received, processed, and managed by specific AMI head-end systems. While ami_event already links to meter (which links to head-end), adding a direct FK to ami_head_end is operationally',
  `scada_point_id` BIGINT COMMENT 'Foreign key linking to grid.scada_point. Business justification: AMI outage/tamper events correlate with SCADA breaker/recloser operations for distribution automation, outage management system integration, and coordinated restoration. Reuses existing scada_point_id',
  `self_report_id` BIGINT COMMENT 'Foreign key linking to compliance.self_report. Business justification: Certain AMI events (widespread outage detection failures, tamper detection system failures) trigger self-report obligations to regulators. Supports regulatory notification workflow, self-report docume',
  `to_ami_head_end_id` BIGINT COMMENT 'FK to metering.ami_head_end.ami_head_end_id — AMI events are received by a specific head-end system. This link supports multi-vendor AMI environments and event routing.',
  `to_meter_id` BIGINT COMMENT 'FK to metering.meter.meter_id — AMI events (tamper alerts, outage notifications, voltage events) must reference the meter device that generated them. Core operational link for event triage.',
  `transformer_id` BIGINT COMMENT 'Identifier of the distribution transformer serving the meter. Used for outage correlation and grid operations analysis. Null if transformer association is not available.',
  `transmission_outage_id` BIGINT COMMENT 'Foreign key linking to transmission.transmission_outage. Business justification: Outage management systems correlate transmission facility outages with AMI last-gasp/restoration events to determine root cause, calculate SAIDI/SAIFI metrics, and assess customer impact. Standard uti',
  `communication_failure_reason` STRING COMMENT 'Root cause classification for communication failure events between the meter and head-end system. Applicable only to communication failure event types. Null for non-communication events. Valid values: SIGNAL_LOSS|NETWORK_CONGESTION|DEVICE_OFFLINE|AUTHENTICATION_FAILURE|PROTOCOL_ERROR|UNKNOWN.',
  `confirmed_theft_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether the tamper event has been confirmed as theft of service following field investigation. True indicates confirmed theft; False indicates dismissed or unconfirmed.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this AMI event record was first created in the MDM system. System audit field for data lineage and compliance.',
  `downstream_notification_status` STRING COMMENT 'Status of event notification to downstream systems. Tracks whether the event has been successfully propagated to Outage Management System (OMS), billing, grid operations, or other consuming systems. Valid values: PENDING|NOTIFIED_OMS|NOTIFIED_BILLING|NOTIFIED_GRID_OPS|NOTIFICATION_FAILED|NOT_REQUIRED.',
  `estimated_unbilled_consumption_kwh` DECIMAL(15,3) COMMENT 'Estimated kilowatt-hours of electricity consumed but not billed due to tampering or theft. Calculated using VEE algorithms and historical consumption patterns. Null for non-tamper events.',
  `event_acknowledged_by` STRING COMMENT 'User ID or system identifier that acknowledged the event. Null for unacknowledged events.',
  `event_acknowledged_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the event has been acknowledged by an operator or automated system. True indicates acknowledged; False indicates pending acknowledgment.',
  `event_acknowledged_timestamp` TIMESTAMP COMMENT 'Date and time when the event was acknowledged. Null for unacknowledged events.',
  `event_sequence_number` INT COMMENT 'Sequential number assigned by the meter to this event within its local event log. Used to detect missing events and ensure event ordering during head-end synchronization.',
  `event_severity` STRING COMMENT 'Severity classification of the AMI event indicating the urgency and business impact. Critical events require immediate investigation; informational events are logged for audit purposes. Valid values: CRITICAL|HIGH|MEDIUM|LOW|INFORMATIONAL.',
  `event_timestamp` TIMESTAMP COMMENT 'Date and time when the event occurred at the meter location, as recorded by the meter device. This is the real-world event time, distinct from system receipt time.',
  `event_type_code` STRING COMMENT 'Classification code identifying the type of AMI event: tamper alerts, power outage notifications (last gasp), power restoration notifications (first breath), communication failures, voltage sag/swell events, reverse energy flow detections, and firmware update events. Reference-value candidates: TAMPER|OUTAGE_LAST_GASP|RESTORATION_FIRST_BREATH|COMM_FAILURE|VOLTAGE_SAG|VOLTAGE_SWELL|REVERSE_FLOW|FIRMWARE_UPDATE.',
  `firmware_version_after` STRING COMMENT 'Meter firmware version identifier after successful firmware update. Applicable only to firmware update events. Null for non-firmware events or failed updates.',
  `firmware_version_before` STRING COMMENT 'Meter firmware version identifier prior to the firmware update event. Applicable only to firmware update events. Null for non-firmware events.',
  `head_end_receipt_timestamp` TIMESTAMP COMMENT 'Date and time when the AMI head-end system received and logged the event from the meter. Used to calculate communication latency and event processing delays.',
  `investigation_closure_timestamp` TIMESTAMP COMMENT 'Date and time when the investigation was closed and final disposition recorded. Null for open or in-progress investigations.',
  `investigation_notes` STRING COMMENT 'Free-text field capturing investigator observations, findings, and resolution details. Used for audit trail and knowledge management. Null for events not requiring investigation.',
  `investigation_start_timestamp` TIMESTAMP COMMENT 'Date and time when the investigation of this event was initiated. Null for events not requiring investigation.',
  `investigation_status` STRING COMMENT 'Current status of the investigation workflow for this event. Tracks the lifecycle from initial detection through resolution. Applicable primarily to tamper and theft events. Valid values: OPEN|IN_PROGRESS|PENDING_FIELD_VISIT|CONFIRMED|DISMISSED|CLOSED.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this AMI event record was last updated. System audit field for change tracking and data governance.',
  `law_enforcement_referral_status` STRING COMMENT 'Status of referral to law enforcement authorities for criminal prosecution of theft of service. Applicable only to confirmed theft cases meeting prosecution thresholds. Null for non-theft events. Valid values: NOT_REFERRED|PENDING_REFERRAL|REFERRED|CASE_FILED|CASE_CLOSED.',
  `outage_duration_minutes` INT COMMENT 'Duration of the power outage in minutes, calculated from last gasp to first breath timestamps. Applicable only to outage and restoration event pairs. Null for non-outage events.',
  `raw_event_payload` STRING COMMENT 'Complete raw data payload transmitted by the meter for this event, stored in native format (typically XML or JSON). Preserves full event detail for forensic analysis and regulatory audit.',
  `regulatory_reporting_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this event must be included in regulatory compliance reports to the Public Utility Commission (PUC) or other governing bodies. True for reportable events such as confirmed theft, major outages, or safety incidents.',
  `revenue_recovery_amount` DECIMAL(15,2) COMMENT 'Monetary amount (in local currency) to be recovered from the customer for unbilled consumption due to confirmed theft. Calculated by applying applicable tariff rates to estimated unbilled consumption. Null for non-theft events.',
  `reverse_flow_kwh` DECIMAL(12,3) COMMENT 'Amount of energy flowing in reverse direction (from customer to grid) in kilowatt-hours, detected during the event period. Applicable to reverse flow events, typically associated with distributed energy resources (DER) or net metering. Null for non-reverse-flow events.',
  `tamper_detection_method` STRING COMMENT 'Source or method by which the tamper event was detected. Applicable only to tamper event types. Null for non-tamper events. Valid values: AMI_ALERT|FIELD_INSPECTION|VEE_ANOMALY|CUSTOMER_REPORT|ROUTINE_AUDIT.',
  `tamper_type` STRING COMMENT 'Specific classification of the tamper method detected. Applicable only to tamper event types. Describes the physical or electronic tampering technique identified. Valid values: COVER_REMOVAL|BYPASS|REVERSE_INSTALLATION|UNAUTHORIZED_RECONNECT|MAGNETIC_INTERFERENCE|INTERNAL_TAMPERING.',
  `to_ami_head_end` BIGINT COMMENT 'FK to metering.ami_head_end.ami_head_end_id — AMI events are received and processed by a specific head-end system. Critical for head-end performance monitoring and event routing.',
  `voltage_measurement` DECIMAL(8,2) COMMENT 'Voltage level measured at the time of the event, in volts. Applicable to voltage sag, voltage swell, and power quality events. Null for non-voltage events.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_metering_ami_event` PRIMARY KEY (`ami_event_id`)
)
USING DELTA
COMMENT 'Operational event and investigation record generated by AMI smart meters and transmitted to the head-end system — covering the full spectrum of AMI-originated events and their investigation lifecycle. Event types include: tamper alerts (with detection method, tamper type such as cover removal/bypass/reverse installation/unauthorized reconnect, investigation status, confirmed theft indicator, estimated unbilled consumption, revenue recovery amount, and law enforcement referral status), power outage notifications (last gasp), power restoration notifications (first breath), communication failures, voltage sag/swell events, reverse energy flow detections, and firmware update events. Stores event type code, event timestamp, meter identifier, event severity, raw event payload, head-end receipt timestamp, downstream notification status, and for tamper/theft events: detection source (AMI alert, field inspection, VEE anomaly), case status, and closure date. SSOT for all AMI-originated events including tamper/theft investigation within the metering domain. Feeds outage management, grid operations, and revenue protection workflows. Supports non-technical loss reporting and PUC-mandated theft-of-service regulatory filings. | CMM: CIM EndDeviceEvent (exact), IEC61968::Metering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AmiEvent',
  'cmm.cim.class' = 'EndDeviceEvent',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Metering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-9',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.ami_event'
);

-- TouRateProgram  <<CIM TimeTariffInterval : close>>
CREATE TABLE IF NOT EXISTS `metering`.`tou_rate_program` (
  `tou_rate_program_id` BIGINT NOT NULL COMMENT 'Unique identifier for the TOU or CPP rate program. Primary key.',
  `primary_meter_point_id` BIGINT COMMENT 'FK to metering.meter_point.meter_point_id — After merging tou_enrollment into tou_rate_program, the enrollment records within tou_rate_program reference specific meter points. Required for billing to apply correct TOU rate periods.',
  `tou_meter_point_id` BIGINT COMMENT 'FK to metering.meter_point.meter_point_id — After merging tou_enrollment into tou_rate_program, the enrollment association linking programs to meter points must be maintained. Essential for billing domain to apply correct TOU periods.',
  `ami_meter_required` BOOLEAN COMMENT 'Indicates whether an AMI smart meter with interval data capability is required for enrollment in this program. True if AMI is mandatory; False if standard meters are acceptable.',
  `billing_cycle_alignment_required` BOOLEAN COMMENT 'Indicates whether enrollment effective dates must align with billing cycle boundaries. True if enrollment can only start at the beginning of a billing cycle.',
  `contact_email` STRING COMMENT 'Email address for inquiries about the rate program. Used by customer service representatives and external stakeholders. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `contact_phone` STRING COMMENT 'Phone number for inquiries about the rate program. Used by customer service representatives and external stakeholders. Pattern: ^\\+?[1-9]\\d{1,14}$.',
  `cpp_event_trigger_criteria` STRING COMMENT 'Business rules or thresholds that trigger a CPP event (e.g., \'Forecasted system load >95% capacity\', \'Day-ahead LMP >$150/MWh\', \'Heat index >105F\'). Nullable for non-CPP programs.',
  `cpp_max_event_duration_hours` DECIMAL(5,2) COMMENT 'Maximum duration in hours for a single CPP event. Nullable for non-CPP programs.',
  `cpp_max_events_per_year` INT COMMENT 'Maximum number of CPP events that can be called in a calendar year, as defined in the tariff. Nullable for non-CPP programs.',
  `cpp_notification_lead_time_hours` DECIMAL(5,2) COMMENT 'Minimum advance notice in hours that must be provided to customers before a CPP event begins. Nullable for non-CPP programs.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this rate program record was first created in the system. Audit trail for record lifecycle.',
  `customer_segment` STRING COMMENT 'Customer class or segment eligible for this rate program. Defines which customer types can enroll. Valid values: RESIDENTIAL|COMMERCIAL|INDUSTRIAL|AGRICULTURAL|MUNICIPAL|ALL.',
  `effective_end_date` DATE COMMENT 'Date when the rate program expires or is superseded. Nullable for open-ended programs. After this date, no new enrollments are accepted.',
  `effective_start_date` DATE COMMENT 'Date when the rate program becomes effective and available for customer enrollment. Aligns with regulatory approval effective date.',
  `enrollment_eligibility_criteria` STRING COMMENT 'Detailed criteria that customers must meet to be eligible for enrollment (e.g., \'Residential customers with annual usage >5000 kWh\', \'Commercial customers with demand >50 kW\').',
  `enrollment_method` STRING COMMENT 'Defines how customers are enrolled in the program. OPT_IN: customer must actively enroll; OPT_OUT: customer is enrolled by default but can opt out; DEFAULT: automatic enrollment for new customers; MANDATORY: required for customer segment. Valid values: OPT_IN|OPT_OUT|DEFAULT|MANDATORY.',
  `estimated_annual_cost_savings_usd` DECIMAL(12,2) COMMENT 'Estimated average annual cost savings in US dollars for a typical customer enrolled in this program. Used for program marketing and benefit analysis.',
  `estimated_annual_savings_kwh` DECIMAL(12,2) COMMENT 'Estimated average annual energy savings in kilowatt-hours (kWh) for a typical customer enrolled in this program. Used for program marketing and benefit analysis.',
  `integration_system_code` STRING COMMENT 'Code identifying the source system or integration point for this program record (e.g., \'MDM\', \'CC&B\', \'CIS\'). Used for data lineage and system-of-record tracking.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this rate program record was last updated. Audit trail for record lifecycle and change tracking.',
  `marketing_campaign_code` STRING COMMENT 'Reference code linking this rate program to marketing campaigns and customer acquisition initiatives. Nullable if no active marketing campaign.',
  `minimum_enrollment_period_months` INT COMMENT 'Minimum number of months a customer must remain enrolled in the program before they can opt out or switch to another rate. Nullable if no minimum commitment.',
  `minimum_interval_data_frequency_minutes` INT COMMENT 'Minimum frequency in minutes at which interval data must be collected for this program (e.g., 15, 30, 60). Defines the granularity required for TOU period classification.',
  `modified_by_user` STRING COMMENT 'User ID or system account that last modified this rate program record. Audit trail for accountability and compliance.',
  `off_peak_period_definition` STRING COMMENT 'Textual or structured definition of off-peak period hours (e.g., \'All other hours\', \'Weekdays 8pm-2pm, All day weekends\'). Defines when off-peak TOU rates apply.',
  `opt_out_allowed_flag` BOOLEAN COMMENT 'Indicates whether customers are allowed to opt out of the program after enrollment. False for mandatory programs; True for voluntary programs.',
  `opt_out_notice_period_days` INT COMMENT 'Number of days advance notice required for a customer to opt out of the program. Nullable if opt-out is not allowed or has no notice requirement.',
  `peak_period_definition` STRING COMMENT 'Textual or structured definition of peak period hours (e.g., \'Weekdays 2pm-8pm\', \'Mon-Fri 14:00-20:00\'). Defines when peak TOU rates apply.',
  `program_code` STRING COMMENT 'Business identifier for the rate program, used in billing systems and customer communications. Externally-known unique code for this TOU or CPP program. Pattern: ^[A-Z0-9_-]{3,20}$.',
  `program_description` STRING COMMENT 'Detailed business description of the rate program, including objectives, benefits, and customer value proposition. Used in customer communications and marketing materials.',
  `program_name` STRING COMMENT 'Human-readable name of the TOU or CPP rate program (e.g., \'Residential Time-of-Use Summer 2024\', \'Commercial Critical Peak Pricing\').',
  `program_owner_department` STRING COMMENT 'Business unit or department responsible for managing and administering this rate program (e.g., \'Metering Operations\', \'Demand Response\', \'Regulatory Affairs\').',
  `program_status` STRING COMMENT 'Current lifecycle status of the rate program. DRAFT: under development; PENDING_APPROVAL: submitted to PUC; ACTIVE: available for enrollment; SUSPENDED: temporarily inactive; RETIRED: no longer offered; CANCELLED: terminated before activation. Valid values: DRAFT|PENDING_APPROVAL|ACTIVE|SUSPENDED|RETIRED|CANCELLED.',
  `program_type` STRING COMMENT 'Classification of the rate program structure: TOU (Time-of-Use with fixed peak/off-peak periods), CPP (Critical Peak Pricing with event-driven pricing), TOU_CPP_HYBRID (combination), DYNAMIC_PRICING, or REAL_TIME_PRICING. Valid values: TOU|CPP|TOU_CPP_HYBRID|DYNAMIC_PRICING|REAL_TIME_PRICING.',
  `regulatory_approval_date` DATE COMMENT 'Date when the regulatory body (PUC) approved this rate program. Critical for compliance and audit trails.',
  `regulatory_approval_reference` STRING COMMENT 'Reference number or docket ID of the PUC or regulatory body approval authorizing this rate program (e.g., \'PUC Docket 2024-E-001\', \'Tariff Sheet 123-A\').',
  `season_type` STRING COMMENT 'Defines whether the program applies year-round or only during specific seasons. SEASONAL_VARIABLE indicates different rate periods apply in different seasons. Valid values: SUMMER|WINTER|YEAR_ROUND|SEASONAL_VARIABLE.',
  `shoulder_period_definition` STRING COMMENT 'Textual or structured definition of shoulder (mid-peak) period hours, if applicable. Nullable if program has only peak/off-peak structure.',
  `summer_end_month_day` STRING COMMENT 'Month and day when summer season ends (MM-DD format, e.g., \'09-30\' for September 30th). Applicable when season_type includes summer periods. Pattern: ^(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$.',
  `summer_start_month_day` STRING COMMENT 'Month and day when summer season begins (MM-DD format, e.g., \'06-01\' for June 1st). Applicable when season_type includes summer periods. Pattern: ^(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$.',
  `tariff_sheet_reference` STRING COMMENT 'Reference to the official tariff sheet or rate schedule document that defines this program. Links to regulatory filing documentation.',
  `vee_validation_rule_set` STRING COMMENT 'Reference to the VEE rule set applied to interval data for this program. Defines validation, estimation, and editing processes for data quality assurance.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_metering_tou_rate_program` PRIMARY KEY (`tou_rate_program_id`)
)
USING DELTA
COMMENT 'Defines Time-of-Use (TOU) and Critical Peak Pricing (CPP) rate program structures and manages meter point enrollments in those programs. For program definition: specifies program code, peak/off-peak/shoulder period definitions, seasonal schedules, CPP event trigger criteria, applicable customer segments, effective date range, rate period definitions, and regulatory approval reference. For enrollment: tracks meter point association via enrollment records with enrollment ID, enrollment effective date, program end date, enrollment channel (web/CSR/auto), opt-in/opt-out status, and program-specific meter configuration requirements triggered by enrollment. Owned by metering as the SSOT for rate period time definitions that govern interval data classification and enrollment lifecycle; pricing amounts are owned by the billing domain. Enables billing domain to apply correct TOU rate periods to validated interval data and supports demand response domain for CPP event targeting. | CMM: CIM TimeTariffInterval (close), IEC61968::PaymentMetering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'TouRateProgram',
  'cmm.cim.class' = 'TimeTariffInterval',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::PaymentMetering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'reference_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.tou_rate_program'
);

-- NetEnergyMetering  <<CIM CustomerAgreement : close>>
CREATE TABLE IF NOT EXISTS `metering`.`net_energy_metering` (
  `net_energy_metering_id` BIGINT NOT NULL COMMENT 'Unique identifier for the net energy metering enrollment record. Primary key for the NEM master registry.',
  `account_id` BIGINT COMMENT 'Reference to the customer account responsible for the NEM enrollment. Links to billing and customer master data.',
  `compliance_rec_certificate_id` BIGINT COMMENT 'Foreign key linking to compliance.rec_certificate. Business justification: NEM generation produces RECs tracked for RPS compliance, ownership determination per state renewable energy programs. Enables REC accounting, compliance credit calculation, renewable energy reporting',
  `customer_enrollment_id` BIGINT COMMENT 'Foreign key linking to customer.enrollment. Business justification: NEM is a specific program enrollment type requiring lifecycle tracking (application, approval, termination). Supports regulatory reporting, program administration, and customer service where enrollmen',
  `der_interconnection_point_id` BIGINT COMMENT 'Foreign key linking to distribution.der_interconnection_point. Business justification: NEM program enrollment must link to physical DER interconnection asset for export capacity validation, permission-to-operate verification, tariff eligibility confirmation, and reconciling billing cred',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_system. Business justification: NEM enrollment must track the specific DER system for generation credit reconciliation, true-up calculations, and system capacity verification against tariff limits. Required for billing accuracy.',
  `meter_id` BIGINT COMMENT 'Reference to the bi-directional meter installed at the premise to measure both import and export energy flows. Must be AMI-capable for interval data collection.',
  `meter_point_id` BIGINT COMMENT 'FK to metering.meter_point.meter_point_id — NEM enrollment must reference the meter point where bi-directional metering is configured. Essential for identifying NEM premises and applying special billing treatment.',
  `net_meter_point_id` BIGINT COMMENT 'Foreign key linking to metering.meter_point. Business justification: Net Energy Metering (NEM) enrollment is tied to a specific service delivery point (meter_point) where the distributed energy resource (DER) system is physically interconnected. While net_energy_meteri',
  `ppa_id` BIGINT COMMENT 'Foreign key linking to trading.ppa. Business justification: NEM customers with solar installations often have underlying power purchase agreements; tracking which PPA supplies the generation measured by the NEM meter is essential for compliance verification, s',
  `premise_id` BIGINT COMMENT 'Reference to the customer premise enrolled in the NEM program. Links to the physical service location with behind-the-meter generation.',
  `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: NEM programs require periodic regulatory filings (annual reports on enrollment, generation, credits issued per state PUC requirements). Supports regulatory reporting obligations, rate case support, pr',
  `application_date` DATE COMMENT 'Date the customer submitted the NEM interconnection application to the utility. Used to determine applicable tariff version and grandfathering provisions.',
  `banking_balance_kwh` DECIMAL(12,3) COMMENT 'The cumulative net excess generation (kWh) banked as a credit within the current true-up period. Positive balance indicates customer has exported more than imported; negative balance indicates net import. Balance is carried forward month-to-month until true-up settlement.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this NEM enrollment record was first created in the system. Used for audit trail and data lineage tracking.',
  `eligible_for_rec` BOOLEAN COMMENT 'Indicates whether the generation system is eligible to generate Renewable Energy Certificates (RECs) under state RPS programs. True if eligible; False if ineligible or RECs have been contractually assigned to the utility.',
  `enrollment_status` STRING COMMENT 'Current lifecycle status of the NEM enrollment. Pending indicates application submitted but not yet approved; Active indicates interconnection complete and bi-directional metering operational; Suspended indicates temporary hold; Terminated indicates customer-initiated cancellation; Expired indicates end of program eligibility period. Valid values: pending|active|suspended|terminated|expired.',
  `export_capacity_limit_kw` DECIMAL(10,3) COMMENT 'The maximum instantaneous power (kW) the customer is authorized to export to the grid. May be less than nameplate capacity due to grid constraints or inverter settings. Enforced by inverter configuration.',
  `export_credit_rate_type` STRING COMMENT 'The methodology used to calculate the monetary credit for energy exported to the grid. Retail Rate (NEM 1.0) credits at full retail rate; Avoided Cost credits at utility\'s marginal generation cost; NEM 3.0 Export Rate uses time-varying export compensation rates; Wholesale Rate credits at market energy price. Valid values: retail_rate|avoided_cost|nem_3_export_rate|wholesale_rate.',
  `generation_technology_type` STRING COMMENT 'The type of behind-the-meter generation technology installed at the premise. Solar PV is the most common; other eligible technologies include wind turbines, fuel cells, biogas generators, micro-hydro, combined heat and power (CHP), and battery storage systems. Reference-value candidates: solar_pv|wind|fuel_cell|biogas|micro_hydro|combined_heat_power|battery_storage.',
  `grandfathered_expiration_date` DATE COMMENT 'The date the grandfathered tariff protection expires and the customer transitions to the current NEM tariff. Null if not grandfathered or if grandfathering is perpetual.',
  `grandfathered_tariff_flag` BOOLEAN COMMENT 'Indicates whether the customer is grandfathered under a prior NEM tariff version due to application date. True if grandfathered; False if subject to current tariff. Grandfathering typically lasts 20 years from PTO date.',
  `has_energy_storage` BOOLEAN COMMENT 'Indicates whether the NEM system includes a battery energy storage system (BESS) for behind-the-meter storage. True if storage is present; False if generation-only. Storage systems may be subject to additional tariff rules and export limitations.',
  `inspection_date` DATE COMMENT 'The date the utility conducted the field inspection of the generation system. Null if inspection is not required or has not yet occurred.',
  `inspection_status` STRING COMMENT 'The status of the utility\'s field inspection of the installed generation system. Pending indicates inspection scheduled but not completed; Passed indicates system meets interconnection requirements; Failed indicates deficiencies found; Not Required for systems under simplified interconnection threshold. Valid values: pending|passed|failed|not_required.',
  `installer_company_name` STRING COMMENT 'The name of the contractor or company that installed the behind-the-meter generation system. Required for warranty claims and quality assurance tracking.',
  `installer_license_number` STRING COMMENT 'The state-issued contractor license number of the installer. Required to verify installer is properly licensed and bonded per state electrical code requirements.',
  `interconnection_agreement_number` STRING COMMENT 'The unique identifier for the signed interconnection agreement between the customer and the utility. Governs technical and operational requirements for grid interconnection.',
  `interconnection_approval_date` DATE COMMENT 'Date the utility approved the interconnection application and authorized the customer to energize the behind-the-meter generation system. Marks the start of NEM program participation.',
  `inverter_manufacturer` STRING COMMENT 'The manufacturer of the inverter that converts DC power from the generation source to AC power for grid export. Required for equipment certification and warranty tracking.',
  `inverter_model` STRING COMMENT 'The specific model number of the inverter installed. Must be on the utility\'s approved equipment list and comply with IEEE 1547 anti-islanding and voltage/frequency ride-through requirements.',
  `inverter_serial_number` STRING COMMENT 'The unique serial number of the inverter unit installed at the premise. Used for warranty claims, equipment recalls, and field service tracking.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this NEM enrollment record was last updated. Used for audit trail and change tracking.',
  `last_true_up_date` DATE COMMENT 'The date of the most recent annual NEM true-up settlement. Used to track true-up cycle and determine next true-up anniversary.',
  `nameplate_capacity_kw` DECIMAL(10,3) COMMENT 'The rated maximum output capacity of the behind-the-meter generation system in kilowatts (kW). Used to determine interconnection study requirements and export limits.',
  `nem_program_type` STRING COMMENT 'The specific NEM tariff program under which the customer is enrolled. NEM 1.0 provides full retail rate credit for exports; NEM 2.0 includes non-bypassable charges; NEM 3.0 uses export compensation rates; VNEM is Virtual Net Energy Metering for multi-tenant properties; NEM-ST is NEM with energy storage. Valid values: NEM 1.0|NEM 2.0|NEM 3.0|VNEM|NEM-ST.',
  `notes` STRING COMMENT 'Free-text field for additional notes, special conditions, or operational comments related to the NEM enrollment. May include interconnection study findings, customer requests, or billing exceptions.',
  `permission_to_operate_date` DATE COMMENT 'Date the utility issued Permission to Operate (PTO), authorizing the customer to begin exporting energy to the grid. Bi-directional metering and export credit calculations commence from this date.',
  `rate_schedule_code` STRING COMMENT 'The tariff rate schedule applicable to this NEM customer. Determines import energy charges, export credit rates, and non-bypassable charges. Common NEM rate schedules include residential TOU and commercial demand rates.',
  `rec_ownership` STRING COMMENT 'Identifies who retains ownership of the RECs generated by the system. Customer retains RECs unless contractually assigned to the utility or sold to a third party. Not Applicable if system is not REC-eligible. Valid values: customer|utility|third_party|not_applicable.',
  `storage_capacity_kwh` DECIMAL(10,3) COMMENT 'The rated energy storage capacity of the battery system in kilowatt-hours (kWh). Null if no storage is present. Used to assess demand response and grid services potential.',
  `storage_power_rating_kw` DECIMAL(10,3) COMMENT 'The maximum charge/discharge power rating of the battery system in kilowatts (kW). Null if no storage is present. Determines instantaneous grid support capability.',
  `system_installation_date` DATE COMMENT 'The date the behind-the-meter generation system was physically installed at the premise. May precede Permission to Operate date. Used for warranty tracking and system age analysis.',
  `tariff_reference` STRING COMMENT 'The specific tariff rule or schedule reference governing this NEM enrollment. Includes tariff book section, effective date, and any rider or special condition references. Used for regulatory compliance and billing validation.',
  `termination_date` DATE COMMENT 'Date the NEM enrollment was terminated or expired. Null for active enrollments. Used to calculate final true-up and settle remaining kWh credit balance.',
  `true_up_anniversary_month` INT COMMENT 'The calendar month (1-12) in which the annual NEM true-up settlement occurs. Determines when banked kWh credits are reconciled and any remaining balance is settled or forfeited.',
  `true_up_period_months` INT COMMENT 'The number of months in the NEM billing cycle before a true-up settlement occurs. Typically 12 months. During the true-up period, excess generation credits are banked; at true-up, remaining credits are settled or forfeited per tariff rules.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_metering_net_energy_metering` PRIMARY KEY (`net_energy_metering_id`)
)
USING DELTA
COMMENT 'Master record for customer premises enrolled in Net Energy Metering (NEM) programs — tracking bi-directional energy flow measurement for customers with behind-the-meter generation (rooftop solar, battery storage). Captures NEM program type (NEM 1.0/2.0/3.0), interconnection approval date, export capacity (kW), generation technology type, inverter details, true-up period, banking balance (kWh credits), and regulatory tariff reference. Distinct from standard metering — NEM requires bi-directional meter configuration and special billing treatment including export credit calculations. | CMM: CIM CustomerAgreement (close), IEC61968::Customers.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'NetEnergyMetering',
  'cmm.cim.class' = 'CustomerAgreement',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Customers',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.net_energy_metering'
);

-- RemoteServiceOrder  <<CIM EndDeviceControl : close>>
CREATE TABLE IF NOT EXISTS `metering`.`remote_service_order` (
  `remote_service_order_id` BIGINT NOT NULL COMMENT 'Unique identifier for the remote service order executed via Advanced Metering Infrastructure (AMI) on a smart meter.',
  `account_id` BIGINT COMMENT 'Customer account identifier associated with the remote service order, used for meter-to-cash workflows.',
  `ami_head_end_id` BIGINT COMMENT 'Foreign key linking to metering.ami_head_end. Business justification: Remote service orders (disconnect, reconnect, load limit, firmware update, on-demand read) are executed through specific AMI head-end systems. The remote_service_order table currently has ami_head_end',
  `capital_project_id` BIGINT COMMENT 'Foreign key linking to asset.capital_project. Business justification: Remote service operations (mass disconnects/reconnects, load limiting) during grid modernization or construction projects require tracking against capital projects for cost allocation, project managem',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Remote connect/disconnect operations have associated costs (system usage, labor oversight) tracked by cost center. Required for customer operations cost allocation, efficiency metrics vs. truck rolls,',
  `customer_service_request_id` BIGINT COMMENT 'Foreign key linking to customer.service_request. Business justification: Remote disconnect/reconnect operations are often initiated by customer service requests (non-payment, move-in/out, safety concerns). Supports customer service workflows, SLA tracking, and audit trails',
  `cycle_id` BIGINT COMMENT 'Identifier of the billing cycle during which the remote service order was executed, used for meter-to-cash reconciliation and revenue assurance.',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: Remote disconnect/reconnect commands for DER sites during emergency curtailment events, interconnection violations, or VPP dispatch. Emergency curtailment dispatch process requires remote service orde',
  `dr_event_id` BIGINT COMMENT 'Identifier of the demand response event that triggered the remote service order, if the order is part of a load management or curtailment program.',
  `employee_id` BIGINT COMMENT 'User identifier of the person who initiated the remote service order, if manually requested; null for system-initiated orders.',
  `meter_point_id` BIGINT COMMENT 'Identifier of the service point associated with the meter receiving the remote service action.',
  `remote_meter_id` BIGINT COMMENT 'Identifier of the smart meter on which the remote service action was executed.',
  `scada_point_id` BIGINT COMMENT 'Foreign key linking to grid.scada_point. Business justification: Remote disconnect/reconnect commands coordinate with SCADA-controlled distribution switching for load management, demand response, and safety interlocks. Distribution automation integration requiremen',
  `to_meter_id` BIGINT COMMENT 'FK to metering.meter.meter_id — Remote service orders (connect/disconnect/on-demand read) must reference the target meter device. Core operational link for AMI remote operations.',
  `work_order_id` BIGINT COMMENT 'Identifier of the associated field work order if the remote service order was initiated as part of a broader field service activity (e.g., meter installation, maintenance).',
  `actual_execution_timestamp` TIMESTAMP COMMENT 'Date and time when the remote service order was actually executed on the meter, recorded by the AMI head-end system upon completion.',
  `ami_transaction_code` STRING COMMENT 'Unique transaction identifier assigned by the AMI head-end system for tracking the command execution at the network layer.',
  `command_payload` STRING COMMENT 'Technical payload or command string sent to the meter by the AMI head-end system, stored for audit and troubleshooting purposes.',
  `communication_protocol` STRING COMMENT 'Communication protocol used by the AMI network to transmit the remote service command to the meter (e.g., ZigBee, cellular, RF mesh, power line carrier, Wi-Fi). Valid values: zigbee|cellular|rf_mesh|plc|wifi.',
  `completion_timestamp` TIMESTAMP COMMENT 'Date and time when the remote service order reached a terminal state (success, failed, cancelled, or timeout) and was closed in the system.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the remote service order record was first created in the system, supporting audit trail and data lineage requirements.',
  `customer_notification_sent` BOOLEAN COMMENT 'Indicates whether a customer notification (email, SMS, IVR call) was sent prior to or after the remote service order execution, as required by regulatory or business policy.',
  `customer_notification_timestamp` TIMESTAMP COMMENT 'Date and time when the customer notification was sent regarding the remote service order, used for regulatory compliance documentation.',
  `disconnect_reason` STRING COMMENT 'Business reason for a remote disconnect order, supporting meter-to-cash workflows and regulatory compliance reporting (e.g., non-payment, customer request, safety hazard). Valid values: non_payment|customer_request|safety|maintenance|meter_replacement|load_management.',
  `execution_result_code` STRING COMMENT 'Standardized code returned by the AMI head-end system indicating the outcome of the remote service order execution (e.g., SUCCESS, METER_OFFLINE, COMMAND_REJECTED, TIMEOUT).',
  `failure_reason_code` STRING COMMENT 'Detailed code explaining why the remote service order failed, populated only when order_status is failed; used for root cause analysis and retry logic.',
  `failure_reason_description` STRING COMMENT 'Human-readable description of the failure reason, providing additional context for troubleshooting and customer communication.',
  `firmware_version_after` STRING COMMENT 'Target meter firmware version to be installed by the over-the-air (OTA) update, verified upon successful completion.',
  `firmware_version_before` STRING COMMENT 'Meter firmware version installed before the over-the-air (OTA) update, used for version control and rollback tracking.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when the remote service order record was last modified, supporting audit trail and change tracking requirements.',
  `load_limit_threshold_kw` DECIMAL(10,3) COMMENT 'Power threshold in kilowatts (kW) set for load limiting activation orders, restricting customer consumption to prevent overload or support demand response programs.',
  `max_retry_count` INT COMMENT 'Maximum number of retry attempts allowed for this remote service order before it is marked as permanently failed.',
  `meter_reading_timestamp` TIMESTAMP COMMENT 'Date and time when the meter reading was captured at the meter during an on-demand read remote service order.',
  `meter_reading_uom` STRING COMMENT 'Unit of measure for the meter reading value captured during on-demand read (e.g., kWh for energy, kW for demand, kVAh for apparent energy). Valid values: kWh|MWh|kW|kVAh|kVArh.',
  `meter_reading_value` DECIMAL(15,3) COMMENT 'Meter register reading value captured during an on-demand read remote service order, used for billing validation or dispute resolution.',
  `notes` STRING COMMENT 'Free-text notes or comments entered by users or systems regarding the remote service order, capturing additional context, special instructions, or resolution details.',
  `order_number` STRING COMMENT 'Externally visible unique business identifier for the remote service order, used for tracking and customer communication. Pattern: ^RSO-[0-9]{10}$.',
  `order_status` STRING COMMENT 'Current lifecycle status of the remote service order: pending (queued), in progress (executing), success (completed successfully), failed (execution error), cancelled (user/system cancelled), or timeout (no response from meter). Valid values: pending|in_progress|success|failed|cancelled|timeout.',
  `order_type` STRING COMMENT 'Type of remote service action executed via AMI: remote connect, remote disconnect, on-demand meter read, load limiting activation/deactivation, or firmware over-the-air (OTA) update. Valid values: remote_connect|remote_disconnect|on_demand_read|load_limit_activation|load_limit_deactivation|firmware_ota_update.',
  `priority` STRING COMMENT 'Priority level assigned to the remote service order, determining execution sequence in the AMI command queue (critical for safety/emergency, high for revenue protection, normal for routine, low for bulk operations). Valid values: critical|high|normal|low.',
  `reconnect_reason` STRING COMMENT 'Business reason for a remote reconnect order, typically following payment receipt or resolution of the disconnect condition. Valid values: payment_received|customer_request|service_restored|meter_replacement_complete|load_management_end.',
  `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether the remote service order execution complies with applicable Public Utility Commission (PUC) regulations for disconnect/reconnect procedures and customer notification requirements.',
  `requested_timestamp` TIMESTAMP COMMENT 'Date and time when the remote service order was requested by the system or user, representing the business event initiation time.',
  `requesting_system` STRING COMMENT 'Name or identifier of the source system that initiated the remote service order (e.g., CC&B, OMS, MDM, manual CSR entry).',
  `response_payload` STRING COMMENT 'Technical response payload returned by the meter to the AMI head-end system, stored for audit and troubleshooting purposes.',
  `retry_count` INT COMMENT 'Number of times the remote service order has been retried after initial failure, used to track execution persistence and prevent infinite retry loops.',
  `scheduled_execution_timestamp` TIMESTAMP COMMENT 'Date and time when the remote service order is scheduled to be executed on the meter, may differ from requested timestamp for planned actions.',
  `signal_strength_dbm` DECIMAL(6,2) COMMENT 'Signal strength in decibels-milliwatts (dBm) measured at the time of remote service order execution, used to diagnose communication failures.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_metering_remote_service_order` PRIMARY KEY (`remote_service_order_id`)
)
USING DELTA
COMMENT 'Operational record of a remote service action executed via AMI on a smart meter — including remote connect, remote disconnect, remote meter read on demand, load limiting activation, and firmware over-the-air (OTA) update commands. Captures order type, requested timestamp, execution timestamp, requesting system or user, execution result (success/failure/pending), failure reason code, and retry count. Supports meter-to-cash workflows (disconnect for non-payment, reconnect after payment) and field operations efficiency tracking. | CMM: CIM EndDeviceControl (close), IEC61968::Metering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'RemoteServiceOrder',
  'cmm.cim.class' = 'EndDeviceControl',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Metering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-9',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.remote_service_order'
);

-- MeterTest  <<CIM TestDataSet : close>>
CREATE TABLE IF NOT EXISTS `metering`.`meter_test` (
  `meter_test_id` BIGINT NOT NULL COMMENT 'Unique identifier for the meter test record. Primary key.',
  `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Meter accuracy test failures trigger billing adjustments that must be tracked to specific customer accounts. Supports revenue protection, regulatory compliance for meter accuracy standards, and custom',
  `adjustment_id` BIGINT COMMENT 'Foreign key linking to billing.adjustment. Business justification: Failed meter tests trigger billing adjustments for inaccurate metering periods (regulatory requirement). This link directly connects test results to financial corrections, supports PUC audit trails, a',
  `audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: Meter testing programs audited for compliance with testing frequency, accuracy standards, documentation requirements. Provides audit evidence for measurement accuracy programs, regulatory inspection s',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Meter testing activities are cost-accounted to specific cost centers (meter shop operations). Required for meter shop budgeting, labor cost allocation, and regulatory compliance testing cost tracking',
  `customer_service_request_id` BIGINT COMMENT 'Reference to the customer service request that initiated the meter test, if applicable. Links to the customer service system for complaint tracking and resolution.',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: Accuracy testing of bidirectional meters at DER installations for regulatory compliance and revenue assurance. Annual DER meter testing program requires test records linked to DER for compliance repor',
  `employee_id` BIGINT COMMENT 'Reference to the technician or engineer who performed the meter test. Links to the workforce or employee registry for accountability and certification tracking.',
  `environmental_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.environmental_permit. Business justification: Meter test facilities require environmental permits for calibration equipment, hazardous waste disposal (mercury switches, electronic waste). Enables permit compliance tracking for test labs, regulato',
  `inspection_id` BIGINT COMMENT 'Foreign key linking to asset.asset_inspection. Business justification: Meter testing is a specialized asset inspection activity. Utilities integrate meter test results (accuracy, condition ratings, defects) into asset health monitoring and condition-based maintenance pro',
  `primary_meter_id` BIGINT COMMENT 'Reference to the meter that was tested. Links to the meter asset registry.',
  `to_meter_id` BIGINT COMMENT 'FK to metering.meter.meter_id — Meter test results must reference the meter device tested. Required for regulatory compliance (PUC meter testing requirements) and accuracy tracking.',
  `work_order_id` BIGINT COMMENT 'Reference to the work order that authorized or triggered the meter test. Links to the work management system for scheduling, labor tracking, and cost allocation.',
  `accuracy_percentage` DECIMAL(8,4) COMMENT 'Measured accuracy of the meter expressed as a percentage error. Positive values indicate the meter is running fast (over-registering); negative values indicate the meter is running slow (under-registering). Calculated as ((measured - actual) / actual) * 100.',
  `as_found_reading` DECIMAL(15,3) COMMENT 'Meter register reading captured at the beginning of the test, before any adjustments or repairs. Represents the meter state as found in the field or upon receipt at the test facility. Measured in kilowatt-hours (kWh).',
  `as_left_reading` DECIMAL(15,3) COMMENT 'Meter register reading captured at the conclusion of the test, after any adjustments, calibrations, or repairs. Represents the meter state after corrective action. Measured in kilowatt-hours (kWh).',
  `billing_adjustment_amount` DECIMAL(12,2) COMMENT 'Calculated billing adjustment amount resulting from the meter test, measured in local currency. Positive values indicate customer credit (meter was over-registering); negative values indicate back-billing (meter was under-registering). Calculated based on accuracy error, consumption history, and regulatory back-billing limits.',
  `billing_adjustment_required_flag` BOOLEAN COMMENT 'Indicates whether the test results require a billing adjustment (back-billing or credit). True if meter was found out of tolerance and billing correction is needed; false otherwise. Triggers downstream billing adjustment workflow.',
  `corrective_action_code` STRING COMMENT 'Standardized code representing the corrective action taken. None indicates meter passed without adjustment; calibrated indicates meter was adjusted to meet accuracy standards; repaired indicates component-level repair; replaced indicates meter was swapped; sealed indicates new tamper seal applied; retired indicates meter removed from service. Valid values: none|calibrated|repaired|replaced|sealed|retired.',
  `corrective_action_taken` STRING COMMENT 'Description of any corrective action performed on the meter following the test. May include calibration adjustments, component replacement, seal replacement, or meter replacement. Empty if no action was required (meter passed as-found).',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this meter test record was first created in the system. Audit trail field for data lineage and compliance.',
  `customer_notification_date` DATE COMMENT 'Date on which the customer was notified of the test results. Required for regulatory compliance when test results trigger billing adjustments or service actions.',
  `customer_notified_flag` BOOLEAN COMMENT 'Indicates whether the customer was notified of the test results. True if notification was sent; false if not yet notified. Required for customer-requested tests and tests resulting in billing adjustments.',
  `failure_code` STRING COMMENT 'Standardized code categorizing the failure mode. Examples include accuracy-out-of-tolerance, display-failure, communication-failure, mechanical-damage, tampering-detected, seal-broken, internal-component-failure. Empty if meter passed. Reference-value candidates: accuracy_out_of_tolerance|display_failure|communication_failure|mechanical_damage|tampering_detected|seal_broken|internal_component_failure|environmental_damage|calibration_drift|manufacturing_defect.',
  `failure_reason` STRING COMMENT 'Detailed description of why the meter failed the test, if applicable. May include root cause analysis such as component wear, environmental damage, tampering, manufacturing defect, or calibration drift. Empty if meter passed.',
  `power_factor` DECIMAL(5,3) COMMENT 'Power factor applied during the test, expressed as a decimal between 0 and 1. Represents the phase relationship between voltage and current. Unity power factor (1.0) represents purely resistive load; lagging power factor (e.g., 0.5 lag) simulates inductive loads common in industrial settings.',
  `regulatory_report_submitted_flag` BOOLEAN COMMENT 'Indicates whether the test results have been included in regulatory reporting to the Public Utility Commission (PUC). True if reported; false if pending. Required for periodic meter testing compliance reports.',
  `regulatory_tolerance_percentage` DECIMAL(6,3) COMMENT 'The maximum allowable percentage error defined by the applicable regulatory standard. Meters exceeding this tolerance fail the test and require adjustment or replacement. Typical values range from ±2% to ±3% depending on meter class and jurisdiction.',
  `test_cost` DECIMAL(10,2) COMMENT 'Total cost incurred to perform the meter test, including labor, equipment usage, and materials. Measured in local currency. Used for cost recovery and regulatory rate case support.',
  `test_current_amperes` DECIMAL(8,2) COMMENT 'Current level applied during the meter test, measured in amperes. Test standards typically specify light load, full load, and heavy load current levels to validate accuracy across the meter\'s operating range.',
  `test_date` DATE COMMENT 'The date on which the meter test was performed. This is the principal business event timestamp for the test.',
  `test_duration_minutes` INT COMMENT 'Total time required to complete the meter test, measured in minutes. Includes setup, test execution, and teardown. Used for labor costing and scheduling optimization.',
  `test_equipment_code` BIGINT COMMENT 'Reference to the test equipment or meter test bench used to perform the test. Links to the asset registry for calibration tracking and equipment certification.',
  `test_equipment_serial_number` STRING COMMENT 'Serial number of the test equipment used. Captured for traceability and to ensure test equipment is within its calibration period.',
  `test_facility_code` BIGINT COMMENT 'Reference to the facility or service center where the test was performed. Links to the facility registry for location tracking and certification management.',
  `test_load_kwh` DECIMAL(10,3) COMMENT 'The known reference load applied during the test, measured in kilowatt-hours. This is the standard energy quantity used to calculate meter accuracy by comparing the meter\'s measured value against this reference.',
  `test_location` STRING COMMENT 'Physical location where the meter test was conducted. Field indicates in-situ testing at the customer premise; shop indicates utility service center; laboratory indicates independent testing facility; customer-premise indicates on-site testing; service-center indicates utility-operated test facility. Valid values: field|shop|laboratory|customer_premise|service_center.',
  `test_notes` STRING COMMENT 'Free-form notes captured by the test technician. May include observations about meter condition, environmental factors, customer interactions, or any anomalies encountered during testing.',
  `test_number` STRING COMMENT 'Business identifier for the meter test, typically assigned by the testing system or laboratory. Used for external reference and tracking.',
  `test_result` STRING COMMENT 'Overall pass/fail determination for the meter test based on regulatory accuracy thresholds. Pass indicates meter meets accuracy standards; fail indicates meter is out of tolerance; inconclusive means test could not produce a definitive result. Valid values: pass|fail|inconclusive.',
  `test_standard_applied` STRING COMMENT 'The regulatory or industry standard used to conduct and evaluate the meter test. Typically references ANSI C12.1, ANSI C12.20, or state Public Utility Commission (PUC) meter testing requirements. Defines the accuracy thresholds and test procedures applied.',
  `test_status` STRING COMMENT 'Current lifecycle status of the meter test. Scheduled indicates the test is planned; in-progress means testing is underway; completed indicates test finished successfully; cancelled means test was aborted; failed indicates test could not be completed due to technical issues; pending-review means results await validation. Valid values: scheduled|in_progress|completed|cancelled|failed|pending_review.',
  `test_technician_name` STRING COMMENT 'Full name of the technician who performed the meter test. Captured for audit trail and regulatory reporting purposes.',
  `test_timestamp` TIMESTAMP COMMENT 'Precise date and time when the meter test was initiated, including time zone. Provides granular event tracking for audit and scheduling purposes.',
  `test_type` STRING COMMENT 'Classification of the meter test. In-service tests are conducted in the field without removing the meter; shop tests are performed in a controlled laboratory environment; referee tests are independent third-party tests to resolve disputes; customer-requested tests are initiated by customer complaint; post-complaint tests follow service quality issues; periodic tests meet regulatory schedules; installation tests verify new meter accuracy; removal tests validate meter condition at decommissioning. Reference-value candidates: in_service|shop|referee|customer_requested|post_complaint|periodic|installation|removal.',
  `test_voltage` DECIMAL(8,2) COMMENT 'Voltage level applied during the meter test, measured in volts. Typically matches the meter\'s rated voltage (e.g., 120V, 240V, 480V) to simulate field operating conditions.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this meter test record was last modified. Audit trail field for change tracking and data quality monitoring.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_metering_meter_test` PRIMARY KEY (`meter_test_id`)
)
USING DELTA
COMMENT 'Records the results of meter accuracy and performance tests conducted in the field or at a test laboratory — including periodic in-service tests, customer-requested tests, and post-complaint investigations. Captures test type (in-service/shop/referee), test date, test technician, test equipment used, accuracy result (percentage error), as-found and as-left readings, pass/fail determination, regulatory standard applied (ANSI C12.1), and any corrective action taken. Supports regulatory compliance with PUC meter testing requirements and back-billing adjustments. | CMM: CIM TestDataSet (close), IEC61968::Assets.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MeterTest',
  'cmm.cim.class' = 'TestDataSet',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Assets',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.meter_test'
);

-- MdmUsageTransaction  <<CIM MeterReading : close>>
CREATE TABLE IF NOT EXISTS `metering`.`mdm_usage_transaction` (
  `mdm_usage_transaction_id` BIGINT NOT NULL COMMENT 'Unique identifier for the MDM usage transaction record. Primary key for this billing-ready consumption record derived from validated interval data.',
  `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Usage transactions are the authoritative source data for billing calculations and must link directly to customer accounts for billing determinism, dispute resolution, and regulatory audit trails. Supp',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: MDM-calculated usage transactions for DER accounts include generation offsets, export credits, and net metering calculations. NEM billing calculation process requires usage transactions linked to DER',
  `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: MDM usage transactions are the pre-billing usage records that feed invoice generation. This link traces billed charges back to source usage calculations, supports billing dispute investigation, revenu',
  `mdm_meter_point_id` BIGINT COMMENT 'Reference to the meter point (service point) for which this usage transaction was calculated. Links to the physical metering location.',
  `mdm_validated_interval_reading_id` BIGINT COMMENT 'FK to metering.validated_interval_reading.validated_interval_reading_id — Usage transactions are derived from validated interval data. This lineage link supports billing audit and consumption reconciliation.',
  `original_transaction_mdm_usage_transaction_id` BIGINT COMMENT 'Reference to the original usage transaction that this record reverses or replaces. Maintains audit trail for billing corrections.',
  `primary_meter_point_id` BIGINT COMMENT 'FK to metering.meter_point.meter_point_id — MDM usage transactions (billing determinants) must reference the meter point for which consumption was calculated. This is the primary billing handoff link.',
  `primary_validated_interval_reading_id` BIGINT COMMENT 'FK to metering.validated_interval_reading.validated_interval_reading_id — Usage transactions are derived from validated interval data. This FK enables billing reconciliation and audit — tracing a bill back to its source validated readings.',
  `adjustment_amount_kwh` DECIMAL(18,3) COMMENT 'The amount of energy (in kWh) added or subtracted from the calculated usage due to manual adjustment. Positive for additions, negative for reductions.',
  `adjustment_reason_code` STRING COMMENT 'Code indicating the reason for any manual adjustment applied to this usage transaction. Used for audit trail and dispute resolution.',
  `billing_handoff_timestamp` TIMESTAMP COMMENT 'Timestamp when this usage transaction was successfully handed off to the billing domain for invoice generation. Marks the completion of the meter-to-cash data flow from metering to billing.',
  `billing_period_end_date` DATE COMMENT 'The end date of the billing period for which this usage transaction was calculated. Defines the end of the consumption measurement window.',
  `billing_period_start_date` DATE COMMENT 'The start date of the billing period for which this usage transaction was calculated. Defines the beginning of the consumption measurement window.',
  `billing_ready_flag` BOOLEAN COMMENT 'Indicates whether this usage transaction has passed all validation checks and is ready to be handed off to the billing system for invoice generation.',
  `consumption_kwh` DECIMAL(18,3) COMMENT 'Total energy consumption in kilowatt-hours (kWh) for this billing period and rate component. Primary billing determinant for energy charges.',
  `cpp_event_kwh` DECIMAL(18,3) COMMENT 'Energy consumption during Critical Peak Pricing (CPP) events. Highest-priced energy period triggered during grid stress conditions for demand response.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this usage transaction record was first created in the MDM system. Used for audit trail and data lineage tracking.',
  `current_read_timestamp` TIMESTAMP COMMENT 'Timestamp of the current meter read that marks the end of the consumption period for this usage transaction. Used for interval data boundary definition.',
  `data_source` STRING COMMENT 'The source system or method from which the underlying interval or register data was obtained. Indicates data collection channel for quality assessment. Valid values: ami|manual_read|estimated|customer_read|remote_read.',
  `edited_interval_count` INT COMMENT 'Number of interval data records that were manually or automatically edited during Validation, Estimation, and Editing (VEE) processing. Indicates data correction activity.',
  `estimated_interval_count` INT COMMENT 'Number of interval data records that were estimated rather than measured during Validation, Estimation, and Editing (VEE) processing. Indicates data quality and estimation reliance.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this usage transaction record was last modified. Tracks updates during VEE processing, adjustments, or corrections.',
  `mdm_processing_run_code` STRING COMMENT 'Identifier of the MDM batch processing run that generated this usage transaction. Used for traceability, reprocessing, and audit purposes.',
  `multiplier` DECIMAL(10,4) COMMENT 'Multiplier applied to raw meter readings to account for Current Transformer (CT) and Potential Transformer (PT) ratios. Converts instrument readings to actual consumption values.',
  `net_generation_kwh` DECIMAL(18,3) COMMENT 'Energy exported back to the grid from customer-owned Distributed Energy Resources (DER) under Net Energy Metering (NEM) programs. Negative consumption for billing credit calculation.',
  `off_peak_kwh` DECIMAL(18,3) COMMENT 'Energy consumption during off-peak hours as defined by the Time of Use (TOU) rate schedule. Lower-priced energy period for demand management.',
  `on_peak_kwh` DECIMAL(18,3) COMMENT 'Energy consumption during on-peak hours as defined by the Time of Use (TOU) rate schedule. Higher-priced energy period for demand management.',
  `peak_demand_kw` DECIMAL(18,3) COMMENT 'Maximum demand in kilowatts (kW) recorded during the billing period for this rate component. Used for demand-based billing and capacity planning.',
  `previous_read_timestamp` TIMESTAMP COMMENT 'Timestamp of the previous meter read that marks the start of the consumption period for this usage transaction. Used for interval data boundary definition.',
  `rate_component_code` STRING COMMENT 'The rate component or tariff element for which this usage was calculated (e.g., on-peak energy, off-peak energy, demand charge, reactive power). Determines how the usage is priced in billing.',
  `reactive_demand_kvar` DECIMAL(18,3) COMMENT 'Maximum reactive power demand in kilovolt-amperes reactive (kVAR) during the billing period. Used for power factor billing and grid stability management.',
  `reversal_flag` BOOLEAN COMMENT 'Indicates whether this usage transaction is a reversal of a previously posted transaction. Used for billing corrections and reprocessing scenarios.',
  `shoulder_kwh` DECIMAL(18,3) COMMENT 'Energy consumption during shoulder (mid-peak) hours as defined by the Time of Use (TOU) rate schedule. Mid-tier pricing period between on-peak and off-peak.',
  `temperature_normalized_flag` BOOLEAN COMMENT 'Indicates whether this usage transaction has been adjusted for weather normalization to account for temperature variations. Used for load forecasting and customer comparisons.',
  `total_interval_count` INT COMMENT 'Total number of interval data records aggregated to produce this usage transaction. Used for data quality assessment and completeness validation.',
  `unit_of_measure` STRING COMMENT 'The unit of measure for the primary usage value in this transaction. Standardizes measurement units across different rate components and meter types. Valid values: kWh|kW|kVAR|MWh|MW|MVAR.',
  `usage_calculation_method` STRING COMMENT 'The method used by MDM to calculate this usage transaction. Indicates whether the value was derived from interval data aggregation, register reads, estimation algorithms, proration, or manual adjustment. Valid values: interval_aggregation|register_read|estimated|prorated|adjusted.',
  `usage_quality_code` STRING COMMENT 'Data quality indicator code assigned by MDM to this usage transaction. Reflects confidence level in the calculated usage based on source data quality and VEE results.',
  `usage_transaction_number` STRING COMMENT 'Business identifier for the usage transaction. Human-readable reference number used in billing and customer service interactions.',
  `vee_completion_timestamp` TIMESTAMP COMMENT 'Timestamp when the VEE processing was completed for this usage transaction. Marks when the data became billing-ready.',
  `vee_status` STRING COMMENT 'Overall status of the Validation, Estimation, and Editing (VEE) process for the interval data underlying this usage transaction. Indicates data quality and readiness for billing. Valid values: validated|estimated|edited|failed|pending.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_metering_mdm_usage_transaction` PRIMARY KEY (`mdm_usage_transaction_id`)
)
USING DELTA
COMMENT 'The Oracle Utilities MDM usage transaction — the aggregated, billing-ready consumption record derived from validated interval data for a specific meter point, billing period, and rate component. Represents the output of MDM interval-to-usage processing: stores billing determinants (on-peak kWh, off-peak kWh, peak demand kW, reactive demand kVAR), billing period start/end, usage calculation method, and MDM processing run identifier. This is the primary handoff record from the metering domain to the billing domain for invoice generation. | CMM: CIM MeterReading (close), IEC61968::Metering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MdmUsageTransaction',
  'cmm.cim.class' = 'MeterReading',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Metering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-9',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.mdm_usage_transaction'
);

-- MeteringDrEnrollment  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `metering`.`metering_dr_enrollment` (
  `metering_dr_enrollment_id` BIGINT NOT NULL COMMENT 'Primary key for metering_dr_enrollment',
  `aggregator_id` BIGINT COMMENT 'Foreign key to the third-party aggregator managing this enrollment, if enrollment_source is Aggregator. Null for utility-direct enrollments.',
  `dr_enrollment_id` BIGINT COMMENT 'Unique identifier for this meter enrollment in this DR program. Primary key.',
  `dr_program_id` BIGINT COMMENT 'Foreign key linking to the demand response program',
  `meter_id` BIGINT COMMENT 'Foreign key linking to the enrolled meter device',
  `baseline_calculation_method_override` STRING COMMENT 'Enrollment-specific override of the baseline calculation method defined at the program level. Allows customer-specific baseline methodology when negotiated or required by customer characteristics. Null indicates use of program default method.',
  `capacity_kw` DECIMAL(12,3) COMMENT 'Committed load reduction capacity in kilowatts for this specific meter enrollment. Used for program capacity aggregation and ISO/RTO registration. May differ from meter peak demand based on customer commitment.',
  `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this enrollment record was created in the DR management system.',
  `effective_end_date` DATE COMMENT 'Date when this enrollment terminates. Null for active open-ended enrollments. Populated for withdrawn or expired enrollments.',
  `effective_start_date` DATE COMMENT 'Date when this enrollment becomes effective for event dispatch and incentive eligibility. May differ from enrollment_date due to program rules or customer request.',
  `enrollment_source` STRING COMMENT 'Channel or mechanism through which this enrollment was created. Direct indicates utility direct enrollment; Aggregator indicates third-party aggregator enrollment; Auto-Enroll indicates automatic enrollment based on tariff or meter type; Tariff-Linked indicates enrollment required by rate schedule; ISO-RTO indicates wholesale market enrollment.',
  `last_event_participation_date` DATE COMMENT 'Date of the most recent demand response event in which this meter participated. Used for engagement tracking and inactive enrollment identification.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this enrollment record was last updated.',
  `metering_dr_enrollment_date` DATE COMMENT 'Date when the meter was enrolled into this demand response program. Used for eligibility determination and incentive calculation start date.',
  `metering_dr_enrollment_status` STRING COMMENT 'Current lifecycle status of this enrollment. Active indicates eligible for event dispatch; Pending indicates enrollment submitted but not yet effective; Suspended indicates temporarily ineligible; Withdrawn indicates customer-initiated termination; Expired indicates program end date reached.',
  `opt_out_count` INT COMMENT 'Cumulative count of demand response events from which this meter opted out (if program allows opt-outs). Used for compliance tracking and penalty assessment.',
  `participation_rate_percent` DECIMAL(5,2) COMMENT 'Calculated participation performance metric representing the percentage of dispatched events in which this meter achieved the committed load reduction. Used for program performance reporting and customer engagement scoring.',
  `total_incentive_payments_usd` DECIMAL(15,2) COMMENT 'Cumulative total of all incentive payments earned by this meter for participation in this DR program since enrollment. Used for settlement reconciliation and customer billing integration.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_metering_metering_dr_enrollment` PRIMARY KEY (`metering_dr_enrollment_id`)
)
USING DELTA
COMMENT 'This association product represents the enrollment relationship between a meter and a demand response program. It captures the operational enrollment lifecycle, participation tracking, and settlement data for each meter enrolled in each DR program. Each record links one meter to one DR program with enrollment-specific attributes including enrollment dates, status, enrolled capacity commitment, baseline calculation method override, participation performance metrics, opt-out history, and cumulative incentive payments earned. This is the SSOT for DR program enrollment administration, event dispatch eligibility, M&V settlement, and regulatory compliance reporting.. Existence Justification: In energy utilities operations, a single meter can simultaneously enroll in multiple demand response programs (e.g., ISO/RTO capacity market + utility peak-time rebate + behavioral DR campaign), and each DR program enrolls thousands of meters across the service territory. The business actively manages enrollments as operational entities with lifecycle status, capacity commitments, participation tracking, opt-out history, and settlement data. Enrollment is a recognized business concept with dedicated administration, event dispatch eligibility determination, M&V settlement processes, and regulatory compliance reporting obligations. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MeteringDrEnrollment',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.metering_dr_enrollment'
);

-- MeterReadingRoute  <<CIM TimeSchedule : extension>>
CREATE TABLE IF NOT EXISTS `metering`.`meter_reading_route` (
  `meter_reading_route_id` BIGINT NOT NULL COMMENT 'Primary key for meter_reading_route',
  `employee_id` BIGINT COMMENT 'Identifier of the employee responsible for the route.',
  `meter_route_id` BIGINT COMMENT 'Foreign key linking to metering.meter_route. Business justification: Meter reading routes are specific instances of broader meter routes; the child route (meter_reading_route) should reference its parent meter_route.',
  `parent_meter_reading_route_id` BIGINT COMMENT 'Self-referencing FK on meter_reading_route (parent_meter_reading_route_id)',
  `assigned_region` STRING COMMENT 'Region code (e.g., ISO-3166-2) where the route operates.',
  `assigned_zone` STRING COMMENT 'Operational zone or service area within the region.',
  `compliance_flag` BOOLEAN COMMENT 'Indicates whether the route complies with regulatory or internal standards.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the route record was first created in the system.',
  `description` STRING COMMENT 'Free-form text describing the route, special instructions, or notes.',
  `effective_end_date` DATE COMMENT 'Date when the route is retired or no longer used (nullable).',
  `effective_start_date` DATE COMMENT 'Date when the route becomes valid for scheduling.',
  `estimated_duration_minutes` INT COMMENT 'Planned time to complete the route, in minutes.',
  `last_run_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent execution of the route.',
  `max_distance_km` DECIMAL(10,2) COMMENT 'Maximum travel distance covered by the route.',
  `meter_reading_frequency_minutes` INT COMMENT 'Target interval between successive meter reads on this route.',
  `next_scheduled_timestamp` TIMESTAMP COMMENT 'Planned start time for the next execution of the route.',
  `number_of_meters` INT COMMENT 'Count of meters assigned to the route.',
  `priority_level` INT COMMENT 'Business priority of the route (1 = highest).',
  `route_code` STRING COMMENT 'External code or alphanumeric identifier assigned to the route.',
  `route_creation_method` STRING COMMENT 'How the route record was created.',
  `route_name` STRING COMMENT 'Human-readable name of the route used by field crews.',
  `route_sequence` INT COMMENT 'Ordinal position of the route in a larger schedule set.',
  `route_shift` STRING COMMENT 'Work shift during which the route is executed.',
  `route_type` STRING COMMENT 'Category of customers served by the route.',
  `route_vehicle_type` STRING COMMENT 'Typical vehicle used to service the route.',
  `route_version` INT COMMENT 'Version number for change tracking of the route definition.',
  `schedule_type` STRING COMMENT 'Frequency at which the route is scheduled.',
  `status` STRING COMMENT 'Current operational status of the route.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the route record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_metering_meter_reading_route` PRIMARY KEY (`meter_reading_route_id`)
)
USING DELTA
COMMENT 'Master reference table for meter_reading_route. Referenced by meter_reading_route_id. | CMM: CIM TimeSchedule (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MeterReadingRoute',
  'cmm.cim.class' = 'TimeSchedule',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.meter_reading_route'
);

-- MeterRegister  <<CIM Register : exact>>
CREATE TABLE IF NOT EXISTS `metering`.`register` (
  `register_id` BIGINT NOT NULL COMMENT 'Primary key for register',
  `location_id` BIGINT COMMENT 'Identifier of the geographic location or asset where the register is installed.',
  `meter_id` BIGINT COMMENT 'Identifier of the physical meter to which this register belongs.',
  `parent_register_id` BIGINT COMMENT 'Self-referencing FK on register (parent_register_id)',
  `billing_cycle` STRING COMMENT 'Billing frequency associated with the register.',
  `calibration_date` DATE COMMENT 'Date of the last calibration performed on the register.',
  `calibration_due_date` DATE COMMENT 'Planned date for the next calibration of the register.',
  `confidentiality_level` STRING COMMENT 'Data classification level for the register metadata.',
  `connection_type` STRING COMMENT 'Physical connection type of the register to the meter.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the register record was first created in the system.',
  `current_rating` DECIMAL(8,2) COMMENT 'Rated current for the register (amperes).',
  `data_quality_flag` STRING COMMENT 'Overall quality assessment of the register\'s data.',
  `description` STRING COMMENT 'Free-form description of the register\'s purpose and characteristics.',
  `edit_flag` STRING COMMENT 'Indicates whether the register\'s data can be manually edited.',
  `effective_from` DATE COMMENT 'Date when the register became active for data collection.',
  `effective_until` DATE COMMENT 'Date when the register is scheduled to be retired or become inactive (null if open-ended).',
  `estimation_method` STRING COMMENT 'Algorithm used to estimate missing or corrupted readings.',
  `is_billable` BOOLEAN COMMENT 'True if the register\'s readings are used for billing.',
  `is_cumulative` BOOLEAN COMMENT 'True if the register accumulates values over time (e.g., total kWh).',
  `is_virtual` BOOLEAN COMMENT 'True if the register is a calculated/virtual register, false if physical.',
  `last_reading_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent reading recorded for the register.',
  `last_reading_value` DECIMAL(15,3) COMMENT 'Value of the most recent reading for the register.',
  `maintenance_window` STRING COMMENT 'Scheduled maintenance window description for the register.',
  `max_capacity` DECIMAL(12,2) COMMENT 'Maximum measurable capacity of the register (in its unit).',
  `measurement_multiplier` DECIMAL(10,6) COMMENT 'Factor applied to raw readings to obtain engineering units.',
  `measurement_unit` STRING COMMENT 'Unit of measure for the register\'s readings.',
  `min_capacity` DECIMAL(12,2) COMMENT 'Minimum measurable capacity of the register (in its unit).',
  `notes` STRING COMMENT 'Free-form notes for operational or engineering remarks.',
  `owner_department` STRING COMMENT 'Internal department responsible for the register.',
  `phase` STRING COMMENT 'Phase configuration of the register.',
  `rate_schedule` STRING COMMENT 'Identifier of the rate schedule (e.g., TOU, CPP) linked to the register.',
  `reading_precision` INT COMMENT 'Number of decimal places stored for each reading.',
  `register_category` STRING COMMENT 'Logical grouping of the register within the meter.',
  `register_code` STRING COMMENT 'External code or number assigned to the register by the utility.',
  `register_name` STRING COMMENT 'Human-readable name of the register used in reports and UI.',
  `register_type` STRING COMMENT 'Category of measurement the register provides.',
  `regulatory_reporting_flag` BOOLEAN COMMENT 'True if the register must be included in regulatory reports.',
  `settlement_type` STRING COMMENT 'Whether the register uses net or gross settlement for billing.',
  `source_system` STRING COMMENT 'Originating system that supplied the register definition (e.g., Oracle Utilities MDM).',
  `status` STRING COMMENT 'Current operational status of the register.',
  `tariff_code` STRING COMMENT 'Code of the tariff schedule applied to the register\'s consumption.',
  `uom_conversion_factor` DECIMAL(10,6) COMMENT 'Factor to convert raw device units to the engineering unit.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the register record.',
  `validation_method` STRING COMMENT 'Method used to validate raw interval data for this register.',
  `voltage_rating` DECIMAL(8,2) COMMENT 'Rated voltage for the register (volts).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_metering_register` PRIMARY KEY (`register_id`)
)
USING DELTA
COMMENT 'Master reference table for register. Referenced by register_id. | CMM: CIM Register (exact), IEC61968::Metering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MeterRegister',
  'cmm.cim.class' = 'Register',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Metering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-9',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.register'
);

-- MeterRoute  <<CIM TimeSchedule : extension>>
CREATE TABLE IF NOT EXISTS `metering`.`meter_route` (
  `meter_route_id` BIGINT NOT NULL COMMENT 'Primary key for meter_route',
  `service_territory_id` BIGINT COMMENT 'Identifier of the service area to which the route belongs.',
  `parent_meter_route_id` BIGINT COMMENT 'Self-referencing FK on meter_route (parent_meter_route_id)',
  `average_meter_spacing_m` DECIMAL(10,2) COMMENT 'Average distance between consecutive meters on the route.',
  `created_timestamp` TIMESTAMP COMMENT 'Date-time when the route record was first created in the system.',
  `effective_from` DATE COMMENT 'Date when the route becomes operational and eligible for meter reads.',
  `effective_until` DATE COMMENT 'Date when the route is retired or superseded; null for open-ended routes.',
  `notes` STRING COMMENT 'Free-form comments or special instructions for the route.',
  `number_of_meters` INT COMMENT 'Count of individual meters assigned to this route.',
  `region_code` STRING COMMENT 'Logical region identifier used for operational planning and reporting.',
  `route_classification` STRING COMMENT 'Secondary classification indicating the route\'s priority tier within the distribution network.',
  `route_code` STRING COMMENT 'Business-visible alphanumeric code used to reference the meter route in operational systems.',
  `route_manager_name` STRING COMMENT 'Name of the manager overseeing the route.',
  `route_name` STRING COMMENT 'Human-readable name describing the meter collection route.',
  `route_owner_department` STRING COMMENT 'Organizational department responsible for the route\'s operation.',
  `route_priority` INT COMMENT 'Numeric priority (1 = highest) used for dispatch sequencing.',
  `route_status` STRING COMMENT 'Current lifecycle status of the route.',
  `route_type` STRING COMMENT 'Classification of the route based on the customer mix it serves.',
  `schedule_end_time` STRING COMMENT 'Planned daily end time for meter reads on this route (HH:MM, 24-hour).',
  `schedule_start_time` STRING COMMENT 'Planned daily start time for meter reads on this route (HH:MM, 24-hour).',
  `total_route_length_km` DECIMAL(10,2) COMMENT 'Cumulative length of the route measured in kilometers.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date-time of the most recent modification to the route record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_metering_meter_route` PRIMARY KEY (`meter_route_id`)
)
USING DELTA
COMMENT 'Master reference table for meter_route. Referenced by route_id. | CMM: CIM TimeSchedule (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MeterRoute',
  'cmm.cim.class' = 'TimeSchedule',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.meter_route'
);

-- ServicePoint  <<CIM UsagePoint : close>>
CREATE TABLE IF NOT EXISTS `metering`.`service_point` (
  `service_point_id` BIGINT NOT NULL COMMENT 'Primary key for service_point',
  `billing_cycle_id` BIGINT COMMENT 'Identifier of the billing cycle applied to the service point.',
  `meter_id` BIGINT COMMENT 'Identifier of the meter installed at the service point.',
  `rate_schedule_id` BIGINT COMMENT 'Identifier of the rate plan governing charges.',
  `parent_service_point_id` BIGINT COMMENT 'Self-referencing FK on service_point (parent_service_point_id)',
  `activation_timestamp` TIMESTAMP COMMENT 'Date-time when the service point became active.',
  `connection_type` STRING COMMENT 'Electrical connection configuration of the service point.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the service point record was first created in the system.',
  `data_quality_score` DECIMAL(5,2) COMMENT 'Numeric score representing the quality of the interval data for this service point.',
  `data_quality_status` STRING COMMENT 'Categorical assessment of data quality.',
  `deactivation_timestamp` TIMESTAMP COMMENT 'Date-time when the service point was deactivated or retired.',
  `demand_response_eligible` BOOLEAN COMMENT 'Indicates if the service point can participate in demand-response programs.',
  `external_code` STRING COMMENT 'Identifier used by external systems or regulatory filings.',
  `installation_date` DATE COMMENT 'Date the meter and service point were installed.',
  `last_maintenance_date` DATE COMMENT 'Date when the most recent maintenance was performed.',
  `last_read_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent validated meter reading.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude of the service point.',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude of the service point.',
  `maintenance_status` STRING COMMENT 'Current status of the maintenance schedule.',
  `name` STRING COMMENT 'Human-readable name or label for the service point.',
  `net_metering_capacity_kw` DECIMAL(10,2) COMMENT 'Maximum generation capacity allowed under net-metering.',
  `net_metering_flag` BOOLEAN COMMENT 'True if the service point is enrolled in net-metering.',
  `next_maintenance_date` DATE COMMENT 'Scheduled date for the next maintenance activity.',
  `outage_end_timestamp` TIMESTAMP COMMENT 'Date-time when the outage was resolved.',
  `outage_flag` BOOLEAN COMMENT 'True if the service point is currently experiencing an outage.',
  `outage_start_timestamp` TIMESTAMP COMMENT 'Date-time when the current outage began.',
  `rated_capacity_kw` DECIMAL(10,2) COMMENT 'Maximum electrical capacity the service point is authorized to deliver.',
  `reading_interval_minutes` INT COMMENT 'Configured interval between meter reads.',
  `renewable_energy_source_flag` BOOLEAN COMMENT 'Indicates if the service point is supplied by renewable generation.',
  `renewable_source_type` STRING COMMENT 'Type of renewable energy associated with the service point.',
  `service_address_line1` STRING COMMENT 'Primary street address of the service point.',
  `service_address_line2` STRING COMMENT 'Secondary address information (suite, unit, etc.).',
  `service_city` STRING COMMENT 'City where the service point is located.',
  `service_country` STRING COMMENT 'ISO-3 country code of the service point location.',
  `service_end_date` DATE COMMENT 'Date the service point ceased delivering utility service, if applicable.',
  `service_postal_code` STRING COMMENT 'Postal/ZIP code for the service point address.',
  `service_start_date` DATE COMMENT 'Date the service point began delivering utility service.',
  `service_state` STRING COMMENT 'State or province of the service point location.',
  `status` STRING COMMENT 'Current operational status of the service point.',
  `tariff_code` STRING COMMENT 'Code representing the tariff applied to the service point.',
  `type` STRING COMMENT 'Category of the service point based on customer class or usage.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the service point record.',
  `voltage_level` STRING COMMENT 'Design voltage classification for the service point.',
  `gis_location_id` BIGINT COMMENT 'Reference to the canonical CIM Location (gis.location) holding this entity\'s geometry, CRS and address. Implements CIM association UsagePoint.UsagePointLocation.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_metering_service_point` PRIMARY KEY (`service_point_id`)
)
USING DELTA
COMMENT 'Master reference table for service_point. Referenced by service_point_id. | CMM: CIM UsagePoint (close), IEC61968::Metering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ServicePoint',
  'cmm.cim.class' = 'UsagePoint',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Metering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-9',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.metering.service_point',
  'cmm.gis.location.role' = 'UsagePoint.UsagePointLocation'
);

-- ========= FOREIGN KEYS within metering (58) =========
ALTER TABLE `metering`.`meter` DROP CONSTRAINT IF EXISTS `fk_metering_meter_meter_ami_head_end_id`;
ALTER TABLE `metering`.`meter` ADD CONSTRAINT `fk_metering_meter_meter_ami_head_end_id` FOREIGN KEY (`meter_ami_head_end_id`) REFERENCES `metering`.`ami_head_end` (`ami_head_end_id`);

ALTER TABLE `metering`.`meter` DROP CONSTRAINT IF EXISTS `fk_metering_meter_to_ami_head_end_id`;
ALTER TABLE `metering`.`meter` ADD CONSTRAINT `fk_metering_meter_to_ami_head_end_id` FOREIGN KEY (`to_ami_head_end_id`) REFERENCES `metering`.`ami_head_end` (`ami_head_end_id`);

ALTER TABLE `metering`.`meter` DROP CONSTRAINT IF EXISTS `fk_metering_meter_tou_rate_program_id`;
ALTER TABLE `metering`.`meter` ADD CONSTRAINT `fk_metering_meter_tou_rate_program_id` FOREIGN KEY (`tou_rate_program_id`) REFERENCES `metering`.`tou_rate_program` (`tou_rate_program_id`);

ALTER TABLE `metering`.`meter_installation` DROP CONSTRAINT IF EXISTS `fk_metering_meter_installation_primary_meter_id`;
ALTER TABLE `metering`.`meter_installation` ADD CONSTRAINT `fk_metering_meter_installation_primary_meter_id` FOREIGN KEY (`primary_meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `metering`.`meter_installation` DROP CONSTRAINT IF EXISTS `fk_metering_meter_installation_primary_meter_point_id`;
ALTER TABLE `metering`.`meter_installation` ADD CONSTRAINT `fk_metering_meter_installation_primary_meter_point_id` FOREIGN KEY (`primary_meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `metering`.`meter_installation` DROP CONSTRAINT IF EXISTS `fk_metering_meter_installation_to_meter_id`;
ALTER TABLE `metering`.`meter_installation` ADD CONSTRAINT `fk_metering_meter_installation_to_meter_id` FOREIGN KEY (`to_meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `metering`.`meter_installation` DROP CONSTRAINT IF EXISTS `fk_metering_meter_installation_to_meter_point_id`;
ALTER TABLE `metering`.`meter_installation` ADD CONSTRAINT `fk_metering_meter_installation_to_meter_point_id` FOREIGN KEY (`to_meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `metering`.`interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_interval_reading_interval_meter_id`;
ALTER TABLE `metering`.`interval_reading` ADD CONSTRAINT `fk_metering_interval_reading_interval_meter_id` FOREIGN KEY (`interval_meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `metering`.`interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_interval_reading_meter_point_id`;
ALTER TABLE `metering`.`interval_reading` ADD CONSTRAINT `fk_metering_interval_reading_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `metering`.`interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_interval_reading_to_meter_id`;
ALTER TABLE `metering`.`interval_reading` ADD CONSTRAINT `fk_metering_interval_reading_to_meter_id` FOREIGN KEY (`to_meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `metering`.`validated_interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_validated_interval_reading_interval_reading_id`;
ALTER TABLE `metering`.`validated_interval_reading` ADD CONSTRAINT `fk_metering_validated_interval_reading_interval_reading_id` FOREIGN KEY (`interval_reading_id`) REFERENCES `metering`.`interval_reading` (`interval_reading_id`);

ALTER TABLE `metering`.`validated_interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_validated_interval_reading_meter_id`;
ALTER TABLE `metering`.`validated_interval_reading` ADD CONSTRAINT `fk_metering_validated_interval_reading_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `metering`.`validated_interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_validated_interval_reading_primary_interval_reading_id`;
ALTER TABLE `metering`.`validated_interval_reading` ADD CONSTRAINT `fk_metering_validated_interval_reading_primary_interval_reading_id` FOREIGN KEY (`primary_interval_reading_id`) REFERENCES `metering`.`interval_reading` (`interval_reading_id`);

ALTER TABLE `metering`.`validated_interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_validated_interval_reading_primary_meter_point_id`;
ALTER TABLE `metering`.`validated_interval_reading` ADD CONSTRAINT `fk_metering_validated_interval_reading_primary_meter_point_id` FOREIGN KEY (`primary_meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `metering`.`validated_interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_validated_interval_reading_primary_vee_rule_id`;
ALTER TABLE `metering`.`validated_interval_reading` ADD CONSTRAINT `fk_metering_validated_interval_reading_primary_vee_rule_id` FOREIGN KEY (`primary_vee_rule_id`) REFERENCES `metering`.`vee_rule` (`vee_rule_id`);

ALTER TABLE `metering`.`validated_interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_validated_interval_reading_validated_meter_point_id`;
ALTER TABLE `metering`.`validated_interval_reading` ADD CONSTRAINT `fk_metering_validated_interval_reading_validated_meter_point_id` FOREIGN KEY (`validated_meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `metering`.`validated_interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_validated_interval_reading_validated_vee_rule_id`;
ALTER TABLE `metering`.`validated_interval_reading` ADD CONSTRAINT `fk_metering_validated_interval_reading_validated_vee_rule_id` FOREIGN KEY (`validated_vee_rule_id`) REFERENCES `metering`.`vee_rule` (`vee_rule_id`);

ALTER TABLE `metering`.`meter_read` DROP CONSTRAINT IF EXISTS `fk_metering_meter_read_ami_event_id`;
ALTER TABLE `metering`.`meter_read` ADD CONSTRAINT `fk_metering_meter_read_ami_event_id` FOREIGN KEY (`ami_event_id`) REFERENCES `metering`.`ami_event` (`ami_event_id`);

ALTER TABLE `metering`.`meter_read` DROP CONSTRAINT IF EXISTS `fk_metering_meter_read_meter_id`;
ALTER TABLE `metering`.`meter_read` ADD CONSTRAINT `fk_metering_meter_read_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `metering`.`meter_read` DROP CONSTRAINT IF EXISTS `fk_metering_meter_read_primary_meter_point_id`;
ALTER TABLE `metering`.`meter_read` ADD CONSTRAINT `fk_metering_meter_read_primary_meter_point_id` FOREIGN KEY (`primary_meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `metering`.`meter_read` DROP CONSTRAINT IF EXISTS `fk_metering_meter_read_register_id`;
ALTER TABLE `metering`.`meter_read` ADD CONSTRAINT `fk_metering_meter_read_register_id` FOREIGN KEY (`register_id`) REFERENCES `metering`.`register` (`register_id`);

ALTER TABLE `metering`.`meter_read` DROP CONSTRAINT IF EXISTS `fk_metering_meter_read_route_id`;
ALTER TABLE `metering`.`meter_read` ADD CONSTRAINT `fk_metering_meter_read_route_id` FOREIGN KEY (`route_id`) REFERENCES `metering`.`meter_route` (`meter_route_id`);

ALTER TABLE `metering`.`meter_read` DROP CONSTRAINT IF EXISTS `fk_metering_meter_read_to_meter_point_id`;
ALTER TABLE `metering`.`meter_read` ADD CONSTRAINT `fk_metering_meter_read_to_meter_point_id` FOREIGN KEY (`to_meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `metering`.`meter_read` DROP CONSTRAINT IF EXISTS `fk_metering_meter_read_vee_rule_id`;
ALTER TABLE `metering`.`meter_read` ADD CONSTRAINT `fk_metering_meter_read_vee_rule_id` FOREIGN KEY (`vee_rule_id`) REFERENCES `metering`.`vee_rule` (`vee_rule_id`);

ALTER TABLE `metering`.`vee_exception` DROP CONSTRAINT IF EXISTS `fk_metering_vee_exception_meter_id`;
ALTER TABLE `metering`.`vee_exception` ADD CONSTRAINT `fk_metering_vee_exception_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `metering`.`vee_exception` DROP CONSTRAINT IF EXISTS `fk_metering_vee_exception_meter_point_id`;
ALTER TABLE `metering`.`vee_exception` ADD CONSTRAINT `fk_metering_vee_exception_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `metering`.`vee_exception` DROP CONSTRAINT IF EXISTS `fk_metering_vee_exception_primary_vee_rule_id`;
ALTER TABLE `metering`.`vee_exception` ADD CONSTRAINT `fk_metering_vee_exception_primary_vee_rule_id` FOREIGN KEY (`primary_vee_rule_id`) REFERENCES `metering`.`vee_rule` (`vee_rule_id`);

ALTER TABLE `metering`.`vee_exception` DROP CONSTRAINT IF EXISTS `fk_metering_vee_exception_to_interval_reading_id`;
ALTER TABLE `metering`.`vee_exception` ADD CONSTRAINT `fk_metering_vee_exception_to_interval_reading_id` FOREIGN KEY (`to_interval_reading_id`) REFERENCES `metering`.`interval_reading` (`interval_reading_id`);

ALTER TABLE `metering`.`vee_exception` DROP CONSTRAINT IF EXISTS `fk_metering_vee_exception_to_vee_rule_id`;
ALTER TABLE `metering`.`vee_exception` ADD CONSTRAINT `fk_metering_vee_exception_to_vee_rule_id` FOREIGN KEY (`to_vee_rule_id`) REFERENCES `metering`.`vee_rule` (`vee_rule_id`);

ALTER TABLE `metering`.`vee_exception` DROP CONSTRAINT IF EXISTS `fk_metering_vee_exception_vee_interval_reading_id`;
ALTER TABLE `metering`.`vee_exception` ADD CONSTRAINT `fk_metering_vee_exception_vee_interval_reading_id` FOREIGN KEY (`vee_interval_reading_id`) REFERENCES `metering`.`interval_reading` (`interval_reading_id`);

ALTER TABLE `metering`.`ami_event` DROP CONSTRAINT IF EXISTS `fk_metering_ami_event_ami_meter_id`;
ALTER TABLE `metering`.`ami_event` ADD CONSTRAINT `fk_metering_ami_event_ami_meter_id` FOREIGN KEY (`ami_meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `metering`.`ami_event` DROP CONSTRAINT IF EXISTS `fk_metering_ami_event_primary_ami_head_end_id`;
ALTER TABLE `metering`.`ami_event` ADD CONSTRAINT `fk_metering_ami_event_primary_ami_head_end_id` FOREIGN KEY (`primary_ami_head_end_id`) REFERENCES `metering`.`ami_head_end` (`ami_head_end_id`);

ALTER TABLE `metering`.`ami_event` DROP CONSTRAINT IF EXISTS `fk_metering_ami_event_to_ami_head_end_id`;
ALTER TABLE `metering`.`ami_event` ADD CONSTRAINT `fk_metering_ami_event_to_ami_head_end_id` FOREIGN KEY (`to_ami_head_end_id`) REFERENCES `metering`.`ami_head_end` (`ami_head_end_id`);

ALTER TABLE `metering`.`ami_event` DROP CONSTRAINT IF EXISTS `fk_metering_ami_event_to_meter_id`;
ALTER TABLE `metering`.`ami_event` ADD CONSTRAINT `fk_metering_ami_event_to_meter_id` FOREIGN KEY (`to_meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `metering`.`tou_rate_program` DROP CONSTRAINT IF EXISTS `fk_metering_tou_rate_program_primary_meter_point_id`;
ALTER TABLE `metering`.`tou_rate_program` ADD CONSTRAINT `fk_metering_tou_rate_program_primary_meter_point_id` FOREIGN KEY (`primary_meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `metering`.`tou_rate_program` DROP CONSTRAINT IF EXISTS `fk_metering_tou_rate_program_tou_meter_point_id`;
ALTER TABLE `metering`.`tou_rate_program` ADD CONSTRAINT `fk_metering_tou_rate_program_tou_meter_point_id` FOREIGN KEY (`tou_meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `metering`.`net_energy_metering` DROP CONSTRAINT IF EXISTS `fk_metering_net_energy_metering_meter_id`;
ALTER TABLE `metering`.`net_energy_metering` ADD CONSTRAINT `fk_metering_net_energy_metering_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `metering`.`net_energy_metering` DROP CONSTRAINT IF EXISTS `fk_metering_net_energy_metering_meter_point_id`;
ALTER TABLE `metering`.`net_energy_metering` ADD CONSTRAINT `fk_metering_net_energy_metering_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `metering`.`net_energy_metering` DROP CONSTRAINT IF EXISTS `fk_metering_net_energy_metering_net_meter_point_id`;
ALTER TABLE `metering`.`net_energy_metering` ADD CONSTRAINT `fk_metering_net_energy_metering_net_meter_point_id` FOREIGN KEY (`net_meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `metering`.`remote_service_order` DROP CONSTRAINT IF EXISTS `fk_metering_remote_service_order_ami_head_end_id`;
ALTER TABLE `metering`.`remote_service_order` ADD CONSTRAINT `fk_metering_remote_service_order_ami_head_end_id` FOREIGN KEY (`ami_head_end_id`) REFERENCES `metering`.`ami_head_end` (`ami_head_end_id`);

ALTER TABLE `metering`.`remote_service_order` DROP CONSTRAINT IF EXISTS `fk_metering_remote_service_order_meter_point_id`;
ALTER TABLE `metering`.`remote_service_order` ADD CONSTRAINT `fk_metering_remote_service_order_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `metering`.`remote_service_order` DROP CONSTRAINT IF EXISTS `fk_metering_remote_service_order_remote_meter_id`;
ALTER TABLE `metering`.`remote_service_order` ADD CONSTRAINT `fk_metering_remote_service_order_remote_meter_id` FOREIGN KEY (`remote_meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `metering`.`remote_service_order` DROP CONSTRAINT IF EXISTS `fk_metering_remote_service_order_to_meter_id`;
ALTER TABLE `metering`.`remote_service_order` ADD CONSTRAINT `fk_metering_remote_service_order_to_meter_id` FOREIGN KEY (`to_meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `metering`.`meter_test` DROP CONSTRAINT IF EXISTS `fk_metering_meter_test_primary_meter_id`;
ALTER TABLE `metering`.`meter_test` ADD CONSTRAINT `fk_metering_meter_test_primary_meter_id` FOREIGN KEY (`primary_meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `metering`.`meter_test` DROP CONSTRAINT IF EXISTS `fk_metering_meter_test_to_meter_id`;
ALTER TABLE `metering`.`meter_test` ADD CONSTRAINT `fk_metering_meter_test_to_meter_id` FOREIGN KEY (`to_meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `metering`.`mdm_usage_transaction` DROP CONSTRAINT IF EXISTS `fk_metering_mdm_usage_transaction_mdm_meter_point_id`;
ALTER TABLE `metering`.`mdm_usage_transaction` ADD CONSTRAINT `fk_metering_mdm_usage_transaction_mdm_meter_point_id` FOREIGN KEY (`mdm_meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `metering`.`mdm_usage_transaction` DROP CONSTRAINT IF EXISTS `fk_metering_mdm_usage_transaction_mdm_validated_interval_reading_id`;
ALTER TABLE `metering`.`mdm_usage_transaction` ADD CONSTRAINT `fk_metering_mdm_usage_transaction_mdm_validated_interval_reading_id` FOREIGN KEY (`mdm_validated_interval_reading_id`) REFERENCES `metering`.`validated_interval_reading` (`validated_interval_reading_id`);

ALTER TABLE `metering`.`mdm_usage_transaction` DROP CONSTRAINT IF EXISTS `fk_metering_mdm_usage_transaction_original_transaction_mdm_usage_transaction_id`;
ALTER TABLE `metering`.`mdm_usage_transaction` ADD CONSTRAINT `fk_metering_mdm_usage_transaction_original_transaction_mdm_usage_transaction_id` FOREIGN KEY (`original_transaction_mdm_usage_transaction_id`) REFERENCES `metering`.`mdm_usage_transaction` (`mdm_usage_transaction_id`);

ALTER TABLE `metering`.`mdm_usage_transaction` DROP CONSTRAINT IF EXISTS `fk_metering_mdm_usage_transaction_primary_meter_point_id`;
ALTER TABLE `metering`.`mdm_usage_transaction` ADD CONSTRAINT `fk_metering_mdm_usage_transaction_primary_meter_point_id` FOREIGN KEY (`primary_meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `metering`.`mdm_usage_transaction` DROP CONSTRAINT IF EXISTS `fk_metering_mdm_usage_transaction_primary_validated_interval_reading_id`;
ALTER TABLE `metering`.`mdm_usage_transaction` ADD CONSTRAINT `fk_metering_mdm_usage_transaction_primary_validated_interval_reading_id` FOREIGN KEY (`primary_validated_interval_reading_id`) REFERENCES `metering`.`validated_interval_reading` (`validated_interval_reading_id`);

ALTER TABLE `metering`.`metering_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_metering_metering_dr_enrollment_meter_id`;
ALTER TABLE `metering`.`metering_dr_enrollment` ADD CONSTRAINT `fk_metering_metering_dr_enrollment_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `metering`.`meter_reading_route` DROP CONSTRAINT IF EXISTS `fk_metering_meter_reading_route_meter_route_id`;
ALTER TABLE `metering`.`meter_reading_route` ADD CONSTRAINT `fk_metering_meter_reading_route_meter_route_id` FOREIGN KEY (`meter_route_id`) REFERENCES `metering`.`meter_route` (`meter_route_id`);

ALTER TABLE `metering`.`meter_reading_route` DROP CONSTRAINT IF EXISTS `fk_metering_meter_reading_route_parent_meter_reading_route_id`;
ALTER TABLE `metering`.`meter_reading_route` ADD CONSTRAINT `fk_metering_meter_reading_route_parent_meter_reading_route_id` FOREIGN KEY (`parent_meter_reading_route_id`) REFERENCES `metering`.`meter_reading_route` (`meter_reading_route_id`);

ALTER TABLE `metering`.`register` DROP CONSTRAINT IF EXISTS `fk_metering_register_meter_id`;
ALTER TABLE `metering`.`register` ADD CONSTRAINT `fk_metering_register_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `metering`.`register` DROP CONSTRAINT IF EXISTS `fk_metering_register_parent_register_id`;
ALTER TABLE `metering`.`register` ADD CONSTRAINT `fk_metering_register_parent_register_id` FOREIGN KEY (`parent_register_id`) REFERENCES `metering`.`register` (`register_id`);

ALTER TABLE `metering`.`meter_route` DROP CONSTRAINT IF EXISTS `fk_metering_meter_route_parent_meter_route_id`;
ALTER TABLE `metering`.`meter_route` ADD CONSTRAINT `fk_metering_meter_route_parent_meter_route_id` FOREIGN KEY (`parent_meter_route_id`) REFERENCES `metering`.`meter_route` (`meter_route_id`);

ALTER TABLE `metering`.`service_point` DROP CONSTRAINT IF EXISTS `fk_metering_service_point_meter_id`;
ALTER TABLE `metering`.`service_point` ADD CONSTRAINT `fk_metering_service_point_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `metering`.`service_point` DROP CONSTRAINT IF EXISTS `fk_metering_service_point_parent_service_point_id`;
ALTER TABLE `metering`.`service_point` ADD CONSTRAINT `fk_metering_service_point_parent_service_point_id` FOREIGN KEY (`parent_service_point_id`) REFERENCES `metering`.`service_point` (`service_point_id`);

