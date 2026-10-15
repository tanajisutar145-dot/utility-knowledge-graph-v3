-- Utility CMM-aligned Canonical Data Model (Silver) v1.0.0 | source: Databricks lakehouse-industry-data-models energy_utilities v1 ECM | generated 2026-10-13
-- 11 | Subject area: interconnection | 18 tables | CIM packages: IEC61970::Wires (PowerElectronicsConnection); IEC61968::InfWork
-- Standards: IEEE 1547-2018; UL 1741 SB; FERC Order 2023; FERC Order 2222; IEC 61968-5
-- Contents: tables (with PK + NOT NULL), then intra-subject-area foreign keys.
-- Unity Catalog PK/FK constraints are informational (NOT ENFORCED); NOT NULL is enforced.

USE CATALOG `utility_cmm_silver`;

-- InterconnectionApplication  <<CIM Request : close>>
CREATE TABLE IF NOT EXISTS `interconnection`.`application` (
  `application_id` BIGINT NOT NULL COMMENT 'Primary key for application',
  `billing_service_agreement_id` BIGINT COMMENT 'Foreign key linking to billing.billing_service_agreement. Business justification: Interconnection applications require an active service agreement to establish billing continuity. Business process: Application intake verifies existing service, and post-PTO billing continues under t',
  `compliance_environmental_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.environmental_permit. Business justification: DER installations often require environmental permits (air quality, land use, wetlands protection). Application review verifies permit status before approval. Critical for large solar/storage projects',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: DER interconnection applications must specify the balancing authority/control area for operational coordination, AGC participation eligibility, NERC CPS1/CPS2 compliance reporting, and interchange sch',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Interconnection application processing costs (engineering reviews, inspections, administrative labor) are allocated to utility cost centers for internal cost tracking, overhead allocation, and regulat',
  `der_installer_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_installer. Business justification: application tracks installer_name and installer_license_number as STRING attributes. The der_installer product is the authoritative master for licensed DER installers. Adding installer_id FK normalize',
  `distribution_substation_id` BIGINT COMMENT 'Reference to the distribution substation serving the proposed interconnection point. Links to the Asset Management domain for substation capacity analysis.',
  `employee_id` BIGINT COMMENT 'Reference to the utility engineer assigned to perform technical review of the interconnection application. Links to the Workforce domain.',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: DER interconnection applications must specify forecast zone for load impact analysis, hosting capacity assessment, and IRP planning. Standard engineering practice - every interconnection study evaluat',
  `meter_point_id` BIGINT COMMENT 'Foreign key linking to metering.meter_point. Business justification: DER interconnection applications must specify the service point where generation will be metered for net energy accounting, billing integration, and regulatory compliance. Essential for linking applic',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: DER interconnection applications must comply with specific regulatory obligations (FERC Order 2222, IEEE 1547, state interconnection rules). Application processing tracks applicable obligations to ens',
  `profile_id` BIGINT COMMENT 'Reference to the utility customer account associated with the service address where the DER will be installed. Links to the Customer domain.',
  `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Interconnection services are a regulated utility function requiring P&L tracking by profit center (e.g., Distribution Services, Customer Connections) for rate case support, regulatory financial report',
  `rate_schedule_id` BIGINT COMMENT 'Foreign key linking to billing.rate_schedule. Business justification: NEM-eligible DER applications must reference the specific rate schedule (NEM 2.0, NEM 3.0 tariff) that governs export compensation methodology and billing treatment. Critical for determining customer\'',
  `service_address_id` BIGINT COMMENT 'Reference to the service address where the distributed energy resource will be physically located and interconnected.',
  `applicant_email` STRING COMMENT 'Primary email address for the applicant, used for all interconnection application correspondence and notifications. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `applicant_name` STRING COMMENT 'Full legal name of the customer or third-party entity submitting the interconnection application.',
  `applicant_phone` STRING COMMENT 'Primary contact phone number for the applicant to facilitate technical review discussions and site inspections.',
  `application_date` DATE COMMENT 'Date the interconnection application was officially submitted to the utility. Establishes queue position and triggers regulatory review timelines.',
  `application_number` STRING COMMENT 'Externally-known business identifier for the interconnection application, typically assigned by the utility upon receipt. Used for customer communication and tracking.',
  `application_status` STRING COMMENT 'Current lifecycle status of the interconnection application. Tracks progression through submission, technical review, approval, and completion stages. Reference-value candidates: draft|submitted|under_review|pending_info|approved|rejected|withdrawn|on_hold|completed.',
  `application_tier` STRING COMMENT 'Interconnection review tier assigned based on DER capacity, technology type, and grid location. Determines review complexity, timeline, and cost per applicable interconnection rules. Valid values: level_1|level_2|level_3|fast_track|study_process.',
  `approval_date` DATE COMMENT 'Date the interconnection application was officially approved by the utility, granting permission to proceed with installation.',
  `circuit_code` STRING COMMENT 'Identifier of the distribution circuit where the DER will interconnect. Used for circuit capacity analysis and impact study scoping.',
  `completion_date` DATE COMMENT 'Date the DER installation was completed, inspected, and granted permission to operate by the utility.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the interconnection application record was first created in the system. Used for audit trail and data lineage.',
  `der_technology_type` STRING COMMENT 'Type of distributed energy resource technology being proposed for interconnection. Determines applicable technical review requirements and interconnection standards. Reference-value candidates: solar_pv|battery_storage|wind|ev_charger|chp|fuel_cell|microturbine.',
  `export_capacity_kw` DECIMAL(12,3) COMMENT 'Maximum capacity in kilowatts that the DER system is authorized to export to the utility grid. May differ from nameplate capacity for BTM systems.',
  `fee_amount` DECIMAL(10,2) COMMENT 'Fee charged by the utility for processing the interconnection application, as specified in the applicable tariff.',
  `fee_paid` BOOLEAN COMMENT 'Indicates whether the required application fee has been paid by the applicant. Payment is typically required before review commences.',
  `impact_study_cost` DECIMAL(12,2) COMMENT 'Estimated or actual cost of the interconnection impact study, typically borne by the applicant per utility tariff.',
  `impact_study_required` BOOLEAN COMMENT 'Indicates whether a detailed impact study is required to assess the effects of the proposed DER on grid stability, voltage, and protection systems.',
  `interconnection_agreement_id` BIGINT COMMENT 'Reference to the executed interconnection agreement contract governing the terms and conditions of grid connection. Links to the Billing domain.',
  `inverter_manufacturer` STRING COMMENT 'Manufacturer of the inverter equipment proposed for the DER installation. Used to verify UL 1741 certification and compliance with IEEE 1547.',
  `inverter_model` STRING COMMENT 'Model number of the inverter equipment. Must be on the utility approved equipment list and certified to applicable standards.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the interconnection application record was last modified. Tracks changes throughout the application lifecycle.',
  `nem_agreement_id` BIGINT COMMENT 'Reference to the executed NEM agreement if the application includes net metering enrollment. Links to the Billing domain.',
  `nem_eligible` BOOLEAN COMMENT 'Indicates whether the DER installation is eligible for net energy metering under applicable state or utility programs.',
  `poi_description` STRING COMMENT 'Detailed description of the proposed point of interconnection on the utility distribution grid, including circuit name, voltage level, and physical location.',
  `poi_voltage_kv` DECIMAL(8,3) COMMENT 'Distribution system voltage level at the proposed point of interconnection in kilovolts. Determines applicable interconnection equipment and protection requirements.',
  `proposed_capacity_kva` DECIMAL(12,3) COMMENT 'Apparent power capacity of the proposed DER system in kilovolt-amperes. Used for inverter sizing and power factor analysis.',
  `proposed_capacity_kw` DECIMAL(12,3) COMMENT 'Nameplate capacity of the proposed DER system in kilowatts. Critical for determining application tier, impact study requirements, and grid integration feasibility.',
  `pto_date` DATE COMMENT 'Date the utility issued permission to operate, allowing the DER system to energize and begin exporting power to the grid.',
  `queue_position` INT COMMENT 'Numerical position of this application in the utility interconnection queue. Determines review priority and processing order for impact studies.',
  `regulatory_framework` STRING COMMENT 'Applicable regulatory framework governing this interconnection application, determining review procedures, timelines, and technical requirements. Valid values: cpuc_rule_21|ferc_order_2023|state_specific|utility_tariff.',
  `rejection_date` DATE COMMENT 'Date the interconnection application was rejected by the utility due to technical, safety, or regulatory non-compliance issues.',
  `rejection_reason` STRING COMMENT 'Detailed explanation of why the interconnection application was rejected, including specific technical or regulatory deficiencies that must be addressed.',
  `review_completion_date` DATE COMMENT 'Date when technical review was completed and a determination was issued. Tracks adherence to regulatory timeline mandates.',
  `review_start_date` DATE COMMENT 'Date when technical review of the application officially commenced. Used to track compliance with regulatory review timeline requirements.',
  `sgip_eligible` BOOLEAN COMMENT 'Indicates whether the DER project qualifies for SGIP incentives for energy storage or distributed generation technologies.',
  `ul_1741_certified` BOOLEAN COMMENT 'Indicates whether the proposed inverter equipment is certified to UL 1741 standard for inverters, converters, controllers and interconnection system equipment.',
  `withdrawal_date` DATE COMMENT 'Date the applicant voluntarily withdrew the interconnection application from the review process.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_interconnection_application` PRIMARY KEY (`application_id`)
)
USING DELTA
COMMENT 'Master record for a customer or third-party application to interconnect a distributed energy resource (DER) — solar PV, battery storage, EV charger, CHP, wind, or other BTM resource — to the utility distribution grid. Captures applicant identity, DER technology type, proposed capacity (kW/kVA), point of interconnection (POI), service address, application tier (Level 1/2/3 or Fast Track per applicable interconnection rules), applicable regulatory framework (CPUC Rule 21, FERC Order 2023, state-specific), application date, current queue position, assigned review engineer, and overall application lifecycle status. Also manages the complete application document package — including document type (single-line diagram, site plan, equipment specification sheet, inverter datasheet, UL 1741 certification, load calculation, executed agreement, insurance certificate, permit, as-built drawing), document name, file reference, submission date, submitted by (applicant or utility), document status (received, under review, accepted, rejected, superseded), rejection reason, required resubmission deadline, and completeness determination outcome. This is the SSOT for all interconnection requests and the anchor entity for the entire interconnection domain, including full document lifecycle management for application completeness determination. | CMM: CIM Request (close), IEC61968::InfWork.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'InterconnectionApplication',
  'cmm.cim.class' = 'Request',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfWork',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-6',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.interconnection.application'
);

-- DerSystem  <<CIM PowerElectronicsConnection : close>>
CREATE TABLE IF NOT EXISTS `interconnection`.`der_system` (
  `der_system_id` BIGINT NOT NULL COMMENT 'Unique identifier for the distributed energy resource system record. Primary key for the DER system entity.',
  `commissioning_engineer_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: DER system commissioning requires utility engineer sign-off for safety verification, IEEE 1547 compliance, protection settings validation, and operational readiness. Critical for PTO authorization pro',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Operational DER systems must report to specific control area for real-time dispatch coordination, frequency response obligations, ACE calculation impacts, and ancillary service provision. Essential fo',
  `der_application_id` BIGINT COMMENT 'FK to interconnection.interconnection_application.interconnection_application_id — Every DER system is proposed through an interconnection application. This is the fundamental master-detail relationship: one application may propose one or more DER systems (e.g., solar + battery comb',
  `der_installer_id` BIGINT COMMENT 'FK to interconnection.der_installer.der_installer_id — Each DER system is installed by a specific licensed installer. This FK enables installer quality tracking and streamlined review program eligibility.',
  `der_interconnection_application_id` BIGINT COMMENT 'Reference to the interconnection application that initiated this DER system registration.',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: DER systems going through interconnection application process should be registered in the renewable.der_registry once operational. The interconnection.der_system table tracks systems during applicatio',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Installed DER systems affect zone-level load forecasts, peak demand calculations, and resource adequacy assessments. Operations teams track aggregate DER penetration by forecast zone for distribution',
  `meter_id` BIGINT COMMENT 'Foreign key linking to metering.meter. Business justification: Operational DER systems require bidirectional meter assignment for generation measurement, net metering credit calculation, and export limit enforcement. Critical for revenue metering and grid operati',
  `nerc_cip_asset_id` BIGINT COMMENT 'Foreign key linking to compliance.nerc_cip_asset. Business justification: Large DER systems (especially aggregated resources >20MW) may qualify as BES Cyber Assets under NERC CIP-002, requiring cybersecurity compliance tracking. Links DER registry to CIP asset inventory for',
  `primary_der_installer_id` BIGINT COMMENT 'Reference to the licensed contractor or installer responsible for the physical installation of the DER system.',
  `to_der_installer_id` BIGINT COMMENT 'FK to interconnection.der_installer.der_installer_id — Each DER system is installed by a specific installer/contractor. This FK links the system to its installer — essential for installer performance tracking, inspection routing, and quality management.',
  `approval_date` DATE COMMENT 'Date when the utility granted final approval for the DER system to interconnect to the grid.',
  `battery_storage_capacity_kwh` DECIMAL(12,3) COMMENT 'Total energy storage capacity in kilowatt-hours for battery energy storage systems (BESS). Null for non-storage DER types.',
  `btm_flag` BOOLEAN COMMENT 'Indicates whether the DER system is located behind the customer meter and primarily serves on-site load.',
  `commissioning_date` DATE COMMENT 'Date when the DER system was officially commissioned and authorized to begin operation and grid interconnection.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this DER system record was first created in the system.',
  `decommission_date` DATE COMMENT 'Date when the DER system was permanently disconnected from the grid and taken out of service.',
  `der_technology_type` STRING COMMENT 'Classification of the distributed energy resource technology. Identifies the primary generation or storage technology deployed. Valid values: solar_pv|battery_storage|ev_charger|chp|fuel_cell|wind.',
  `equipment_manufacturer` STRING COMMENT 'Name of the primary equipment manufacturer for the DER generation or storage technology (e.g., solar panel manufacturer, battery manufacturer).',
  `equipment_model` STRING COMMENT 'Specific model number or designation of the primary DER generation or storage equipment.',
  `export_capability_flag` BOOLEAN COMMENT 'Indicates whether the DER system is configured and approved to export power back to the utility grid. True if export is enabled, False if system is limited to behind-the-meter consumption only.',
  `ieee_1547_mandatory_functions` STRING COMMENT 'Comma-separated list of mandatory grid support and protection functions required by IEEE 1547-2018 standard (e.g., voltage ride-through, frequency ride-through, anti-islanding).',
  `installation_address_line1` STRING COMMENT 'Primary street address line where the DER system is physically installed.',
  `installation_address_line2` STRING COMMENT 'Secondary address line for apartment, suite, or unit number where the DER system is installed.',
  `installation_city` STRING COMMENT 'City or municipality where the DER system is physically installed.',
  `installation_date` DATE COMMENT 'Date when the physical installation of the DER system equipment was completed.',
  `installation_latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the DER system installation site in decimal degrees.',
  `installation_longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the DER system installation site in decimal degrees.',
  `installation_postal_code` STRING COMMENT 'ZIP or postal code for the DER system installation location.',
  `installation_state` STRING COMMENT 'State or province where the DER system is physically installed, using two-letter postal abbreviation.',
  `inverter_based_resource_flag` BOOLEAN COMMENT 'Indicates whether the DER system is an inverter-based resource requiring special grid integration considerations per NERC reliability standards.',
  `inverter_certification_standard` STRING COMMENT 'Industry certification standard to which the inverter has been tested and approved for grid interconnection. Valid values: ul_1741|ul_1741_sa|ieee_1547_2018.',
  `inverter_manufacturer` STRING COMMENT 'Name of the company that manufactured the inverter equipment used in the DER system.',
  `inverter_model` STRING COMMENT 'Specific model number or designation of the inverter equipment installed in the DER system.',
  `inverter_type` STRING COMMENT 'Classification of the inverter technology used to convert DC power to AC power for grid interconnection. Valid values: string|micro|central|hybrid.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this DER system record was last modified or updated.',
  `nameplate_capacity_kw_ac` DECIMAL(12,3) COMMENT 'Maximum continuous AC power output rating of the DER system in kilowatts as measured at the point of interconnection.',
  `nameplate_capacity_kw_dc` DECIMAL(12,3) COMMENT 'Maximum DC power rating of the DER system in kilowatts, applicable primarily to solar PV arrays before inverter conversion.',
  `nem_eligible_flag` BOOLEAN COMMENT 'Indicates whether the DER system qualifies for net energy metering programs that credit customers for excess generation exported to the grid.',
  `notes` STRING COMMENT 'Free-form text field for additional notes, comments, or special considerations related to the DER system interconnection.',
  `poi_specification` STRING COMMENT 'Technical specification describing the exact electrical point where the DER system connects to the utility distribution system.',
  `protection_compliance_status` STRING COMMENT 'Current verification status of the DER systems compliance with all required protection system functions and settings. Valid values: pending|verified|non_compliant|waived.',
  `protection_relay_model` STRING COMMENT 'Specific model number of the protective relay equipment installed or required for the DER system.',
  `protection_relay_required_flag` BOOLEAN COMMENT 'Indicates whether utility-grade protective relaying equipment is required for this DER system interconnection based on capacity and grid impact.',
  `resource_classification` STRING COMMENT 'Functional classification of the DER system indicating whether it primarily generates energy, stores energy, or serves as a controllable load. Valid values: generation|storage|hybrid|load.',
  `sgip_eligible_flag` BOOLEAN COMMENT 'Indicates whether the DER system qualifies for SGIP incentives for distributed energy storage and generation technologies.',
  `system_name` STRING COMMENT 'Business name or identifier assigned to the distributed energy resource system by the applicant or utility.',
  `system_status` STRING COMMENT 'Current lifecycle status of the DER system in the interconnection and operational process. Valid values: proposed|approved|installed|commissioned|operational|decommissioned.',
  `utility_additional_protection_requirements` STRING COMMENT 'Description of any additional protection system requirements imposed by the utility beyond IEEE 1547 mandatory functions.',
  `warranty_expiration_date` DATE COMMENT 'Date when the manufacturer warranty coverage for the DER system equipment expires.',
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
  CONSTRAINT `pk_interconnection_der_system` PRIMARY KEY (`der_system_id`)
)
USING DELTA
COMMENT 'Master record for a specific distributed energy resource (DER) system proposed or approved for grid interconnection. Captures DER technology type and classification (solar PV, BESS, EV charger, CHP, fuel cell, wind, micro-hydro, diesel — replacing the former der_technology_type reference table), nameplate capacity (kW AC/DC), inverter type and certification (UL 1741 / UL 1741 SA / IEEE 1547-2018), battery storage capacity (kWh), export capability flag, generation vs. storage classification, inverter-based resource flag, behind-the-meter (BTM) flag, NEM eligibility, SGIP eligibility, equipment manufacturer and model, protective relay and protection system requirements (IEEE 1547 mandatory functions, utility-required additional protection, relay model, settings ranges, compliance verification status), installer reference, installation address, and commissioning date. Distinct from the renewable domain\'s resource management — this entity tracks the physical DER asset and its technical protection requirements as part of the interconnection approval process. | CMM: CIM PowerElectronicsConnection (close), IEC61970::Wires.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DerSystem',
  'cmm.cim.class' = 'PowerElectronicsConnection',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Wires',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.interconnection.der_system',
  'cmm.gis.location.role' = 'PowerSystemResource.Location'
);

-- PoiSpecification  <<CIM ConnectivityNode : close>>
CREATE TABLE IF NOT EXISTS `interconnection`.`poi_specification` (
  `poi_specification_id` BIGINT NOT NULL COMMENT 'Unique identifier for the POI specification record. Primary key.',
  `ems_node_id` BIGINT COMMENT 'Foreign key linking to grid.ems_node. Business justification: Point of interconnection specifications must reference the specific EMS bus/node where DER connects for state estimation modeling, power flow analysis, and contingency analysis. Required for accurate',
  `feeder_id` BIGINT COMMENT 'Identifier of the distribution feeder circuit where the POI is located. Links to the distribution network topology managed in the distribution domain.',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Point of interconnection specifications are evaluated within forecast zone context for available hosting capacity, voltage regulation requirements, and grid impact studies. Engineering standard - POI',
  `meter_point_id` BIGINT COMMENT 'Foreign key linking to metering.meter_point. Business justification: Point of interconnection specifications define the exact service point for metering configuration, CT/PT ratios, and interval data collection requirements. Engineering design depends on this link.',
  `poi_application_id` BIGINT COMMENT 'FK to interconnection.interconnection_application.interconnection_application_id — Each POI specification is defined for a specific interconnection application. The POI is where the applicant\'s DER connects to the grid. Without this FK, you cannot associate the technical POI details',
  `poi_interconnection_application_id` BIGINT COMMENT 'Reference to the parent interconnection application that this POI specification supports.',
  `primary_poi_employee_id` BIGINT COMMENT 'User identifier of the utility engineer who created the POI specification.',
  `transformer_id` BIGINT COMMENT 'Identifier of the distribution transformer serving the POI location. Used for hosting capacity analysis and voltage impact studies.',
  `anti_islanding_protection_required` BOOLEAN COMMENT 'Indicates whether anti-islanding protection is required at this POI to prevent the DER from energizing a de-energized portion of the utility grid.',
  `approved_date` DATE COMMENT 'Date when the POI specification was formally approved by utility engineering for interconnection.',
  `available_hosting_capacity_kw` DECIMAL(12,3) COMMENT 'Available hosting capacity in kilowatts at the POI at the time of application. Represents the maximum DER generation that can be accommodated without distribution system upgrades.',
  `circuit_segment_code` STRING COMMENT 'Identifier of the specific circuit segment or span where the POI is located on the distribution network.',
  `communication_protocol` STRING COMMENT 'Communication protocol required for DER monitoring and control at the POI. Used for DERMS integration and demand response programs. Valid values: modbus|dnp3|ieee_2030_5|sunspec|none.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the POI specification record was first created in the system.',
  `disconnect_switch_required` BOOLEAN COMMENT 'Indicates whether a visible, lockable disconnect switch is required at the POI for utility access and safety.',
  `distribution_upgrades_required` BOOLEAN COMMENT 'Indicates whether distribution system upgrades (transformer replacement, conductor upgrades, voltage regulator additions) are required to accommodate the DER interconnection at this POI.',
  `engineering_notes` STRING COMMENT 'Free-text engineering notes and special considerations for the POI specification. Captures site-specific constraints and technical requirements.',
  `estimated_upgrade_cost_usd` DECIMAL(15,2) COMMENT 'Estimated cost in US dollars for any required distribution system upgrades to enable interconnection at this POI. May be allocated to the interconnection customer.',
  `fault_current_contribution_limit_a` DECIMAL(10,2) COMMENT 'Maximum allowable fault current contribution in amperes from the DER system to the utility grid during fault conditions. Used to ensure protective device coordination.',
  `frequency_response_capability_required` BOOLEAN COMMENT 'Indicates whether the DER system must provide frequency-watt droop response capability to support grid frequency stability.',
  `gis_latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the POI location in decimal degrees. Used for spatial analysis and network modeling.',
  `gis_longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the POI location in decimal degrees. Used for spatial analysis and network modeling.',
  `grounding_requirements` STRING COMMENT 'Grounding and bonding requirements at the POI to ensure electrical safety and proper fault current paths.',
  `interconnection_equipment_requirements` STRING COMMENT 'Detailed description of all interconnection equipment required at the POI including disconnect switches, protective relays, meters, and communication devices.',
  `interconnection_study_required` STRING COMMENT 'Type of interconnection impact study required for this POI based on DER size and hosting capacity. Determines review process and timeline. Valid values: none|screening|supplemental|facilities.',
  `maximum_export_limit_kw` DECIMAL(12,3) COMMENT 'Maximum allowable export power in kilowatts from the DER system to the utility grid at this POI. May be less than the DER nameplate capacity.',
  `maximum_import_limit_kw` DECIMAL(12,3) COMMENT 'Maximum allowable import power in kilowatts from the utility grid to the customer premises at this POI. Relevant for battery storage and EV charging applications.',
  `meter_socket_type` STRING COMMENT 'Type of meter socket required at the POI for bidirectional metering of DER generation and consumption. Specifies form factor and AMI compatibility.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the POI specification record was last modified.',
  `nem_eligible` BOOLEAN COMMENT 'Indicates whether this POI is eligible for Net Energy Metering tariff enrollment based on location, voltage level, and hosting capacity.',
  `phase_configuration` STRING COMMENT 'Electrical phase configuration at the POI (single-phase or three-phase). Critical for inverter selection and protection coordination. Valid values: single_phase|three_phase_wye|three_phase_delta|split_phase.',
  `poi_identifier` STRING COMMENT 'Utility-assigned unique identifier for the POI location on the distribution network. This is the externally-known business identifier used in engineering documents and interconnection agreements.',
  `power_quality_monitoring_required` BOOLEAN COMMENT 'Indicates whether power quality monitoring equipment is required at the POI to track voltage, frequency, harmonics, and power factor.',
  `protective_relay_required` BOOLEAN COMMENT 'Indicates whether a protective relay is required at the POI for over/under voltage, over/under frequency, and fault protection.',
  `ride_through_capability_required` BOOLEAN COMMENT 'Indicates whether the DER system must remain connected during voltage and frequency disturbances (low/high voltage ride-through and low/high frequency ride-through).',
  `service_voltage_level` STRING COMMENT 'Nominal voltage level at the POI where the DER system will interconnect. Determines equipment requirements and protection schemes. Valid values: 120V|240V|208V|277V|480V|12kV|13.2kV|13.8kV|25kV|34.5kV.',
  `sgip_eligible` BOOLEAN COMMENT 'Indicates whether this POI location is eligible for SGIP incentives for battery storage and other distributed energy resources.',
  `specification_date` DATE COMMENT 'Date when the POI specification was created or last revised by utility engineering.',
  `specification_status` STRING COMMENT 'Current lifecycle status of the POI specification in the technical review and approval process. Valid values: draft|under_review|approved|rejected|superseded|archived.',
  `telemetry_required` BOOLEAN COMMENT 'Indicates whether real-time telemetry data from the POI must be transmitted to utility SCADA or DERMS systems.',
  `voltage_regulation_capability_required` BOOLEAN COMMENT 'Indicates whether the DER inverter must provide voltage regulation capability (volt-VAR or volt-watt control) at the POI.',
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
  CONSTRAINT `pk_interconnection_poi_specification` PRIMARY KEY (`poi_specification_id`)
)
USING DELTA
COMMENT 'Technical specification record defining the Point of Interconnection (POI) on the utility distribution network where a DER system will connect. Captures POI location (GIS coordinates, feeder ID, transformer ID, circuit segment), voltage level (120V/240V/480V/12kV), phase configuration (single-phase/three-phase), available hosting capacity (kW) at the POI at time of application, maximum export limit (kW), anti-islanding protection requirements, interconnection equipment requirements (disconnect switch, meter socket, protective relay), and utility-assigned POI identifier. Links to the distribution network topology managed in the distribution domain. | CMM: CIM ConnectivityNode (close), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PoiSpecification',
  'cmm.cim.class' = 'ConnectivityNode',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.interconnection.poi_specification',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- TechnicalReview  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `interconnection`.`technical_review` (
  `technical_review_id` BIGINT NOT NULL COMMENT 'Unique identifier for the technical review record. Primary key.',
  `application_id` BIGINT COMMENT 'FK to interconnection.application.application_id — Technical reviews are conducted FOR a specific application. One application may have multiple sequential reviews. This FK is essential for tracking review outcomes back to the application.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Technical reviews assess DER impact on control area operations including reserve requirements, regulation capacity, CPS1/CPS2 performance, and frequency response obligations. Determines whether DER ca',
  `distribution_substation_id` BIGINT COMMENT 'Identifier of the distribution substation serving the interconnection point. Used for system impact analysis and capacity planning.',
  `feeder_id` BIGINT COMMENT 'Identifier of the distribution feeder or circuit where the Distributed Energy Resource (DER) will interconnect. Used for load flow analysis and capacity assessment.',
  `load_id` BIGINT COMMENT 'Foreign key linking to forecast.load. Business justification: Technical reviews reference specific load forecasts to assess feeder capacity and hosting capacity. IEEE 1547 fast-track screening criteria explicitly compare DER capacity to feeder minimum load from',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Technical reviews verify compliance with specific regulatory standards (IEEE 1547-2018, UL 1741-SA, state technical requirements). Each review validates adherence to applicable obligations. Essential',
  `primary_technical_employee_id` BIGINT COMMENT 'Reference to the utility engineer responsible for conducting this technical review. Links to the workforce or employee registry.',
  `technical_application_id` BIGINT COMMENT 'FK to interconnection.application.application_id — Technical reviews are performed FOR a specific interconnection application. One application may have multiple sequential reviews. This is the core workflow link.',
  `technical_interconnection_application_id` BIGINT COMMENT 'Reference to the interconnection application being reviewed. Links this technical review to the parent application record.',
  `aggregate_der_capacity_kw` DECIMAL(12,3) COMMENT 'Total aggregate capacity in kilowatts of all Distributed Energy Resources (DERs) on the line section including the proposed DER. Used for Fast Track Screen 2 evaluation (100% rule).',
  `assigned_engineer_name` STRING COMMENT 'Full name of the utility engineer assigned to conduct the technical review. Denormalized for reporting convenience.',
  `conditional_approval_conditions` STRING COMMENT 'Specific conditions, requirements, or constraints that must be met for a conditionally approved interconnection. May include operational limits, equipment specifications, or testing requirements.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this technical review record was first created in the system. Used for audit trail and data lineage tracking.',
  `der_capacity_kw` DECIMAL(12,3) COMMENT 'Nameplate capacity of the Distributed Energy Resource (DER) in kilowatts. Used for screening criteria evaluation (15% rule, 100% rule) and impact assessment.',
  `estimated_mitigation_cost_usd` DECIMAL(15,2) COMMENT 'Estimated cost in USD for implementing required mitigation measures and system upgrades. Used for cost allocation and customer notification.',
  `fast_track_screen_1_result` STRING COMMENT 'Result of Fast Track Screen 1 evaluation (Distributed Energy Resource (DER) capacity vs feeder minimum load). Pass indicates the DER meets the 15% rule threshold. Valid values: pass|fail|not_applicable.',
  `fast_track_screen_2_result` STRING COMMENT 'Result of Fast Track Screen 2 evaluation (aggregate DER capacity on the line section). Pass indicates compliance with the 100% rule. Valid values: pass|fail|not_applicable.',
  `fast_track_screen_3_result` STRING COMMENT 'Result of Fast Track Screen 3 evaluation (voltage and power quality impact assessment). Valid values: pass|fail|not_applicable.',
  `fast_track_screen_4_result` STRING COMMENT 'Result of Fast Track Screen 4 evaluation (safety and reliability screen for protective equipment and fault current). Valid values: pass|fail|not_applicable.',
  `fast_track_screen_5_result` STRING COMMENT 'Result of Fast Track Screen 5 evaluation (customer transformer capacity screen). Valid values: pass|fail|not_applicable.',
  `feeder_minimum_load_kw` DECIMAL(12,3) COMMENT 'Minimum load in kilowatts on the distribution feeder over the past 12 months. Used for Fast Track Screen 1 evaluation (15% rule).',
  `ieee_1547_compliance_verified` BOOLEAN COMMENT 'Indicates whether the proposed Distributed Energy Resource (DER) equipment and interconnection design comply with IEEE 1547 interconnection standards. True if compliance verified.',
  `impact_study_required` BOOLEAN COMMENT 'Indicates whether a detailed impact study (System Impact Study or Facilities Study) is required based on the technical review findings. True if further study needed.',
  `impact_study_type_recommended` STRING COMMENT 'Type of detailed impact study recommended based on technical review findings. Determines the next phase of the interconnection process. Valid values: system_impact_study|facilities_study|both|none.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this technical review record was last modified. Used for audit trail and change tracking.',
  `line_section_peak_load_kw` DECIMAL(12,3) COMMENT 'Peak load in kilowatts on the line section where the Distributed Energy Resource (DER) will interconnect. Used for Fast Track Screen 2 evaluation (100% rule).',
  `mitigation_measures_required` STRING COMMENT 'Description of required mitigation measures, system upgrades, or modifications needed to address identified technical issues. May include equipment upgrades, protection scheme changes, or operational constraints.',
  `overall_screening_result` STRING COMMENT 'Aggregate result of all screening criteria applied. Determines whether the interconnection can proceed without additional impact studies. Valid values: pass|fail|conditional_pass|requires_further_study.',
  `poi_voltage_level_kv` DECIMAL(8,3) COMMENT 'Voltage level in kilovolts at the Point of Interconnection (POI) where the Distributed Energy Resource (DER) will connect to the utility system. Critical for technical screening and equipment specification.',
  `power_quality_concern_identified` BOOLEAN COMMENT 'Indicates whether power quality concerns (harmonics, flicker, unbalance) were identified during the technical review. True if power quality issues detected.',
  `protection_coordination_conflict` BOOLEAN COMMENT 'Indicates whether protection coordination conflicts with existing utility protective devices were identified. True if coordination issues detected.',
  `review_completion_date` DATE COMMENT 'Date when the technical review was completed and disposition determined. Nullable until review is finalized.',
  `review_disposition` STRING COMMENT 'Final disposition or outcome of the technical review. Determines whether the interconnection application can proceed, requires additional study, or is denied. Valid values: approved|conditionally_approved|requires_impact_study|rejected|withdrawn.',
  `review_due_date` DATE COMMENT 'Target completion date for the technical review based on regulatory timelines and Service Level Agreement (SLA) commitments.',
  `review_number` STRING COMMENT 'Business identifier for the technical review. Human-readable unique number assigned to this review for tracking and reference purposes. Pattern: ^TR-[0-9]{6,10}$.',
  `review_start_date` DATE COMMENT 'Date when the technical review was initiated. Used to track review cycle time and Service Level Agreement (SLA) compliance.',
  `review_status` STRING COMMENT 'Current lifecycle status of the technical review. Tracks the review workflow state from initiation through completion. Valid values: not_started|in_progress|on_hold|completed|cancelled.',
  `review_to_application` BIGINT COMMENT 'FK to interconnection.interconnection_application.interconnection_application_id — Technical reviews are conducted FOR a specific interconnection application. One application may have multiple sequential reviews. This is the core workflow FK — without it, review results cannot be as',
  `review_type` STRING COMMENT 'Classification of the technical review being conducted. Determines the scope, depth, and screening criteria applied during the review process. Valid values: initial_completeness_check|supplemental_review|independent_study|fast_track_screen|detailed_study|witness_test_review.',
  `reviewer_notes` STRING COMMENT 'Internal notes and observations from the reviewing engineer. May include technical details, coordination notes, or follow-up items for internal use.',
  `screening_criteria_applied` STRING COMMENT 'Description of the technical screening criteria and rules applied during the review. May reference Fast Track screens (15% rule, 100% rule per FERC Order 2023), IEEE 1547 screens, or utility-specific criteria.',
  `short_circuit_ratio` DECIMAL(8,4) COMMENT 'Ratio of the available short circuit current at the Point of Interconnection (POI) to the Distributed Energy Resource (DER) rated current. Used to assess system strength and fault contribution.',
  `technical_issues_summary` STRING COMMENT 'Comprehensive narrative summary of all technical issues, concerns, and findings identified during the review. Includes voltage violations, thermal constraints, protection conflicts, and power quality concerns.',
  `thermal_overload_identified` BOOLEAN COMMENT 'Indicates whether thermal overload conditions on conductors or equipment were identified during the technical review. True if thermal issues detected.',
  `ul_1741_certification_verified` BOOLEAN COMMENT 'Indicates whether the proposed inverter equipment has valid Underwriters Laboratories (UL) 1741 certification for grid interconnection. True if certification verified.',
  `voltage_violation_identified` BOOLEAN COMMENT 'Indicates whether voltage regulation violations were identified during the technical review. True if voltage issues detected.',
  `witness_test_required` BOOLEAN COMMENT 'Indicates whether a utility witness test of the Distributed Energy Resource (DER) equipment and protective functions is required before final approval. True if witness test needed.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_interconnection_technical_review` PRIMARY KEY (`technical_review_id`)
)
USING DELTA
COMMENT 'Record of the utility engineering technical review conducted for an interconnection application. Captures review type (initial completeness check, supplemental review, independent study), assigned engineer, review start and completion dates, screening criteria applied (15% rule, 100% rule, Fast Track screens per FERC Order 2023), screening pass/fail result, identified technical issues (voltage violations, thermal overloads, protection coordination conflicts, power quality concerns), required mitigation measures, and review disposition (approved, conditionally approved, requires impact study). One application may have multiple sequential technical reviews. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'TechnicalReview',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.interconnection.technical_review'
);

-- ImpactStudy  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `interconnection`.`impact_study` (
  `impact_study_id` BIGINT NOT NULL COMMENT 'Unique identifier for the grid impact study record. Primary key for the impact study entity.',
  `application_id` BIGINT COMMENT 'FK to interconnection.application.application_id — Impact studies are ordered for applications that fail Fast Track screens. After cluster_study_group merge, impact_study also carries the cluster grouping — but each study still traces back to one or m',
  `cluster_study_group_id` BIGINT COMMENT 'Identifier for the cluster study group formed under FERC Order 2023. Multiple interconnection applications may be grouped together for efficient processing. Null for individual application studies.',
  `contingency_id` BIGINT COMMENT 'Foreign key linking to grid.contingency. Business justification: Impact studies evaluate how proposed DER affects existing NERC-defined contingency scenarios (N-1, N-2) and may trigger new contingency definitions. Required for NERC TPL standard compliance and deter',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Impact study costs (internal engineering labor, contractor fees, software tools) are charged to cost centers for cost tracking, overhead allocation, and study cost recovery from applicants per interco',
  `impact_application_id` BIGINT COMMENT 'FK to interconnection.application.application_id — Impact studies are ordered when an application fails Fast Track screens. The study determines what network upgrades are needed for that specific application (or cluster of applications).',
  `impact_interconnection_application_id` BIGINT COMMENT 'Reference to the interconnection application that triggered this impact study. Links the study to the originating DER interconnection request.',
  `irp_scenario_id` BIGINT COMMENT 'Foreign key linking to forecast.irp_scenario. Business justification: Clustered impact studies inform IRP scenario planning for DER penetration assumptions, grid investment needs, and capacity expansion plans. Regulatory filing requirement - utilities must demonstrate h',
  `load_id` BIGINT COMMENT 'Foreign key linking to forecast.load. Business justification: Impact studies model DER effects on forecasted load profiles using load flow and stability analysis. Study scope requires baseline load forecast as input for voltage, thermal, and protection coordinat',
  `affected_network_segments` STRING COMMENT 'List or description of transmission and distribution network segments that may be impacted by the proposed interconnection. Includes feeders, substations, and transmission lines.',
  `applicable_tariff_reference` STRING COMMENT 'Reference to the applicable interconnection tariff or rule governing the study process, such as FERC pro forma LGIP or state-specific interconnection rules.',
  `cluster_application_count` INT COMMENT 'Number of interconnection applications included in the cluster study group. Null for individual application studies.',
  `cluster_cost_allocation_methodology` STRING COMMENT 'Specific cost allocation methodology applied to cluster study groups, such as pro-rata by capacity, equal share, or impact-based allocation. Null for individual studies.',
  `cluster_geographic_area` STRING COMMENT 'Geographic study area for cluster studies, such as feeder, substation zone, or planning area. Defines the network boundary for grouped impact analysis.',
  `cluster_group_formation_date` DATE COMMENT 'Date when the cluster study group was formed under FERC Order 2023 cluster study process. Null for individual application studies.',
  `contingency_scenarios` STRING COMMENT 'Description of contingency scenarios analyzed in the study, such as N-1 or N-2 outage conditions, to assess grid reliability and stability impacts.',
  `cost_responsibility_allocation_method` STRING COMMENT 'Description of the methodology used to allocate study costs among applicants in cluster studies or between utility and applicant in individual studies.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the impact study record was first created in the system. Used for audit trail and data lineage tracking.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the impact study record was last modified. Tracks the most recent update to any field in the record.',
  `load_flow_analysis_performed_flag` BOOLEAN COMMENT 'Boolean indicator of whether load flow analysis was performed to assess voltage and thermal impacts on the distribution or transmission system.',
  `network_upgrade_cost_estimate_amount` DECIMAL(18,2) COMMENT 'Estimated total cost of required network upgrades identified in the impact study. Expressed in USD. Critical for applicant financial feasibility assessment.',
  `network_upgrades_description` STRING COMMENT 'Detailed description of the network upgrades identified as necessary by the impact study. Includes equipment additions, replacements, and system modifications.',
  `network_upgrades_required_flag` BOOLEAN COMMENT 'Boolean indicator of whether the study identified network upgrades as necessary for safe and reliable interconnection. True if upgrades are required.',
  `poi_specification` STRING COMMENT 'Detailed specification of the Point of Interconnection (POI) where the DER will connect to the utility grid. Includes voltage level, substation, and feeder information.',
  `protection_coordination_review_flag` BOOLEAN COMMENT 'Boolean indicator of whether protection coordination review was performed to ensure proper operation of protective devices with the new DER interconnection.',
  `record_source_system` STRING COMMENT 'Name of the source system from which this impact study record originated, such as interconnection queue management system or CIS module.',
  `regulatory_jurisdiction` STRING COMMENT 'Regulatory jurisdiction governing the interconnection study process, such as FERC for wholesale or state PUC for retail interconnections.',
  `short_circuit_analysis_performed_flag` BOOLEAN COMMENT 'Boolean indicator of whether short circuit analysis was performed as part of the impact study. Required for system impact and facilities studies.',
  `stability_analysis_performed_flag` BOOLEAN COMMENT 'Boolean indicator of whether transient or dynamic stability analysis was performed for larger interconnections that may impact grid stability.',
  `study_actual_completion_date` DATE COMMENT 'Actual date when the impact study was completed and results delivered. Used to track adherence to regulatory timelines and SLA compliance.',
  `study_agreement_executed_date` DATE COMMENT 'Date when the study agreement was executed between the utility and the interconnection applicant. Formalizes the study scope and cost responsibility.',
  `study_contractor` STRING COMMENT 'Name of the organization conducting the impact study. May be utility internal engineering team or third-party consultant.',
  `study_contractor_type` STRING COMMENT 'Classification of the study contractor as utility internal resources, third-party consultant, or ISO/RTO staff. Valid values: utility_internal|third_party_consultant|iso_rto.',
  `study_cost_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for study cost amounts. Typically USD for North American utilities. Pattern: ^[A-Z]{3}$.',
  `study_cost_estimate_amount` DECIMAL(18,2) COMMENT 'Estimated total cost to conduct the impact study, including engineering analysis, modeling, and reporting. Expressed in USD.',
  `study_deposit_amount` DECIMAL(18,2) COMMENT 'Deposit amount paid by the applicant to initiate the impact study. Typically applied against final study costs. Expressed in USD.',
  `study_deposit_received_date` DATE COMMENT 'Date when the study deposit was received from the applicant. Triggers the start of the study timeline in many jurisdictions.',
  `study_findings_summary` STRING COMMENT 'Executive summary of the impact study findings, including key conclusions, identified issues, and recommended next steps for interconnection approval.',
  `study_initiation_date` DATE COMMENT 'Date when the impact study was formally initiated. Marks the start of the study timeline and triggers contractual obligations.',
  `study_number` STRING COMMENT 'Business identifier for the impact study, typically assigned by the utility or ISO/RTO. Used for external communication and tracking.',
  `study_report_document_reference` STRING COMMENT 'Reference to the formal impact study report document, typically stored in a document management system. Used for audit trail and regulatory compliance.',
  `study_scope_description` STRING COMMENT 'Detailed description of the study scope including affected network segments, contingency scenarios, and analysis boundaries. Defines what will be evaluated in the impact study.',
  `study_status` STRING COMMENT 'Current lifecycle status of the impact study. Tracks progression from initiation through completion or cancellation. Valid values: pending|in_progress|on_hold|completed|cancelled|superseded.',
  `study_target_completion_date` DATE COMMENT 'Target date for completion of the impact study as defined by interconnection agreement or regulatory timeline requirements.',
  `study_to_application` BIGINT COMMENT 'FK to interconnection.interconnection_application.interconnection_application_id — Impact studies are ordered for applications that fail screening. This FK links the study results back to the originating application. Essential for tracking study status and costs per application.',
  `study_type` STRING COMMENT 'Classification of the impact study type per FERC Order 2023 or state PUC rules. Determines the scope and depth of analysis required for grid interconnection approval. Valid values: feasibility_study|system_impact_study|facilities_study|cluster_feasibility_study|cluster_system_impact_study|cluster_facilities_study.',
  `technical_feasibility_determination` STRING COMMENT 'Overall determination of technical feasibility for the proposed interconnection based on study results. Drives approval or rejection decision. Valid values: feasible|feasible_with_upgrades|not_feasible|requires_further_study.',
  `upgrade_cost_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for network upgrade cost amounts. Typically USD for North American utilities. Pattern: ^[A-Z]{3}$.',
  `voltage_level_kv` DECIMAL(10,3) COMMENT 'Voltage level at the Point of Interconnection expressed in kilovolts (kV). Critical parameter for equipment specification and protection coordination.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_interconnection_impact_study` PRIMARY KEY (`impact_study_id`)
)
USING DELTA
COMMENT 'Record of a formal grid impact study ordered for an interconnection application that fails Fast Track or simplified review screens. Captures study type (Feasibility Study, System Impact Study, Facilities Study per FERC Order 2023 or state PUC rules), study scope (affected network segments, contingency scenarios), study contractor (utility internal or third-party), study initiation and completion dates, study cost estimate, cost responsibility allocation reference, identified network upgrades required, upgrade cost estimate, and study findings summary. Also manages cluster/group study cohorts formed under FERC Order 2023 — including cluster study group identifier, geographic study area (feeder, substation zone, planning area), study group formation date, number of applications in group, group study cost allocation methodology, study type classification (cluster feasibility, cluster system impact, cluster facilities), and group study contractor assignment. Supports both individual application studies and FERC Order 2023 cluster study processing for efficient handling of high-volume DER interconnection queues. Drives the determination of required network upgrades and cost allocation across grouped applications. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ImpactStudy',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.interconnection.impact_study'
);

-- NetworkUpgrade  <<CIM Project : close>>
CREATE TABLE IF NOT EXISTS `interconnection`.`network_upgrade` (
  `network_upgrade_id` BIGINT NOT NULL COMMENT 'Unique identifier for the network upgrade record. Primary key for the network upgrade entity.',
  `application_id` BIGINT COMMENT 'FK to interconnection.application.application_id — Network upgrades are ultimately required by specific applications (or groups of applications in cluster studies). This FK enables cost allocation back to the responsible applicant(s).',
  `capacity_requirement_id` BIGINT COMMENT 'Foreign key linking to forecast.capacity_requirement. Business justification: Network upgrades triggered by DER interconnection affect capacity requirement calculations and resource adequacy assessments. Planning process - upgrades increase available capacity and must be reflec',
  `capital_project_id` BIGINT COMMENT 'Reference to the capital project record in the asset management domain that tracks the execution of this network upgrade. Links interconnection-driven upgrades to capital planning and execution.',
  `contingency_id` BIGINT COMMENT 'Foreign key linking to grid.contingency. Business justification: Network upgrades are often driven by specific contingency analysis violations that DER interconnection would cause. Links upgrade requirements to the contingency scenario that triggered the need, supp',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Network upgrade costs (design, construction, project management) are allocated to responsible cost centers for internal accounting, departmental budgeting, overhead allocation, and cost recovery track',
  `feeder_id` BIGINT COMMENT 'Foreign key linking to distribution.feeder. Business justification: Network upgrades triggered by interconnection applications target specific distribution feeders for capacity expansion, protection coordination, or voltage regulation improvements. Capital project tra',
  `impact_study_id` BIGINT COMMENT 'FK to interconnection.impact_study.impact_study_id — Network upgrades are identified BY impact studies. One study may identify multiple required upgrades. This FK traces upgrade requirements back to the study that identified them — critical for cost all',
  `material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: Network upgrades for interconnection (transformer replacements, conductor upgrades, protection equipment installations) consume utility materials from inventory. Capital project material planning and',
  `network_application_id` BIGINT COMMENT 'FK to interconnection.application.application_id — Network upgrades are required to accommodate specific DER interconnection applications. While identified through impact studies, the cost responsibility and completion tracking ties back to the origin',
  `network_impact_study` BIGINT COMMENT 'FK to interconnection.impact_study.impact_study_id — Network upgrades are identified BY impact studies. The study determines what upgrades are needed and their cost estimates. This FK is essential for tracing upgrade requirements back to study findings.',
  `network_impact_study_id` BIGINT COMMENT 'Reference to the interconnection impact study that identified the need for this network upgrade. Links to the engineering analysis that determined upgrade requirements.',
  `network_interconnection_application_id` BIGINT COMMENT 'Reference to the interconnection request that triggered or is associated with this network upgrade. Links to the interconnection application that identified the need for this upgrade.',
  `network_segment_id` BIGINT COMMENT 'Foreign key linking to distribution.network_segment. Business justification: Upgrades often target specific line segments (reconductoring, sectionalizing device installation, transformer additions). Work order planning, construction management, and as-built documentation requi',
  `project_manager_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Network upgrade projects require utility project manager assignment for capital project coordination, contractor oversight, budget tracking, and regulatory compliance reporting. Replaces denormalized',
  `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supply.purchase_order. Business justification: Network upgrades often require procurement of specialized equipment (distribution transformers, switchgear, protection relays, reconductoring materials) not available from stock. Utilities track procu',
  `registry_id` BIGINT COMMENT 'Reference to the specific grid asset (feeder, transformer, substation, circuit segment) that requires upgrade. Links to the asset registry for detailed asset information.',
  `to_impact_study_id` BIGINT COMMENT 'FK to interconnection.impact_study.impact_study_id — Network upgrades are identified BY impact studies. The study findings drive the upgrade requirements. This is the causal link between analysis and capital action.',
  `work_order_id` BIGINT COMMENT 'Reference to the work order used to execute the network upgrade construction or installation. Links to field operations and maintenance management systems.',
  `actual_completion_date` DATE COMMENT 'Date when the network upgrade was actually completed and placed in service. Used to track project delivery performance and enable DER energization.',
  `actual_cost_amount` DECIMAL(18,2) COMMENT 'Final settled cost of the completed network upgrade, in USD. Recorded after project completion and final invoicing. May differ from estimated cost.',
  `affected_asset_type` STRING COMMENT 'Type of grid asset that requires upgrade or modification. Categorizes the infrastructure component impacted by the DER interconnection. Reference-value candidates: feeder|transformer|substation|circuit_segment|transmission_line|distribution_line|protection_device|voltage_control_device.',
  `affected_substation_name` STRING COMMENT 'Name of the substation where the upgrade will be performed or that serves the affected circuit. Key geographic and operational reference point.',
  `applicant_funded_amount` DECIMAL(18,2) COMMENT 'Portion of the upgrade cost to be funded by the interconnection applicant, in USD. Represents the customer\'s financial responsibility for network improvements.',
  `cancellation_reason` STRING COMMENT 'Explanation for why the network upgrade was cancelled, if applicable. Documents the business or technical rationale for project termination (e.g., interconnection request withdrawn, alternative solution found).',
  `capacity_increase_mw` DECIMAL(10,3) COMMENT 'Additional hosting capacity in megawatts (MW) that will be enabled by this network upgrade. Quantifies the incremental DER integration capability created by the improvement.',
  `construction_start_date` DATE COMMENT 'Date when physical construction or installation work for the network upgrade began. Marks the start of field implementation.',
  `contractor_name` STRING COMMENT 'Name of the construction contractor or vendor responsible for executing the network upgrade work. Identifies the external party performing the physical installation.',
  `cost_allocation_method` STRING COMMENT 'Methodology used to allocate upgrade costs among applicant, utility, and other beneficiaries. Defines the financial responsibility framework per regulatory requirements. Valid values: applicant_funded|utility_funded|shared_network_upgrade|pro_rata|capacity_based.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the network upgrade record was first created in the system. Audit field tracking initial record capture.',
  `design_completion_date` DATE COMMENT 'Date when engineering design for the network upgrade was finalized and approved. Enables progression to permitting and procurement phases.',
  `design_start_date` DATE COMMENT 'Date when engineering design work for the network upgrade commenced. Marks the beginning of detailed engineering phase.',
  `engineering_firm_name` STRING COMMENT 'Name of the engineering consulting firm that designed the network upgrade, if external engineering services were used. Identifies the design authority.',
  `environmental_review_required_flag` BOOLEAN COMMENT 'Indicates whether environmental impact review or assessment is required for this network upgrade per EPA or state environmental regulations. True if review is needed, false otherwise.',
  `estimated_cost_amount` DECIMAL(18,2) COMMENT 'Initial engineering estimate of the total cost to complete the network upgrade, in USD. Used for budgeting and cost allocation during the interconnection application review process.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the network upgrade record was most recently updated. Audit field tracking the latest change to any attribute in the record.',
  `permit_required_flag` BOOLEAN COMMENT 'Indicates whether regulatory or municipal permits are required to execute this network upgrade. True if permitting is needed, false otherwise.',
  `permit_status` STRING COMMENT 'Current status of permit applications required for the network upgrade. Tracks regulatory approval progress for projects requiring external authorization. Valid values: not_required|pending|submitted|approved|denied|expired.',
  `poi_location` STRING COMMENT 'Geographic or network location description of the point where the DER will interconnect to the utility grid. Defines the specific connection point driving the upgrade need.',
  `queue_position` INT COMMENT 'Position of the associated interconnection request in the interconnection queue. Used to prioritize network upgrades when multiple DER projects compete for limited grid capacity.',
  `required_completion_date` DATE COMMENT 'Target date by which the network upgrade must be completed to enable the DER interconnection. Drives project scheduling and interconnection agreement milestones.',
  `sgip_eligible_flag` BOOLEAN COMMENT 'Indicates whether this network upgrade is eligible for cost recovery or incentives under the Self-Generation Incentive Program (SGIP) or similar state DER incentive programs. True if eligible, false otherwise.',
  `shared_cost_amount` DECIMAL(18,2) COMMENT 'Portion of the upgrade cost to be shared between multiple interconnection applicants or beneficiaries, in USD. Used when upgrade benefits multiple DER projects.',
  `source_system` STRING COMMENT 'Name of the operational system that originated this network upgrade record (e.g., interconnection management system, capital project system, GIS). Identifies the system of record for data lineage.',
  `technical_justification` STRING COMMENT 'Engineering rationale explaining why this network upgrade is required to safely accommodate the DER interconnection. Documents the technical need based on impact study results.',
  `upgrade_description` STRING COMMENT 'Detailed narrative description of the network upgrade scope, including technical specifications, equipment to be installed or modified, and work to be performed.',
  `upgrade_number` STRING COMMENT 'Business identifier for the network upgrade, typically assigned by engineering or project management systems. Used for external communication and tracking.',
  `upgrade_status` STRING COMMENT 'Current lifecycle status of the network upgrade project. Tracks progression from initial identification through design, permitting, construction, and completion phases. Reference-value candidates: identified|designed|permitted|contracted|in_progress|completed|cancelled.',
  `upgrade_type` STRING COMMENT 'Classification of the type of network upgrade required to accommodate DER interconnection. Defines the nature of the physical grid improvement needed for safe integration. Reference-value candidates: transformer_upsizing|line_reconductoring|protection_relay_replacement|protection_relay_addition|voltage_regulator_addition|capacitor_bank_addition|communication_infrastructure|transfer_trip|substation_expansion|feeder_extension|other.',
  `utility_funded_amount` DECIMAL(18,2) COMMENT 'Portion of the upgrade cost to be funded by the utility through rate base or other utility funding mechanisms, in USD. Represents utility\'s share of network improvement costs.',
  `voltage_level_kv` DECIMAL(10,3) COMMENT 'Operating voltage level in kilovolts (kV) of the grid infrastructure being upgraded. Defines the electrical system tier (distribution vs transmission) affected by the upgrade.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_interconnection_network_upgrade` PRIMARY KEY (`network_upgrade_id`)
)
USING DELTA
COMMENT 'Record of a distribution or transmission network upgrade identified as required to accommodate one or more DER interconnections. Captures upgrade type (transformer upsizing, line reconductoring, protection relay replacement/addition, voltage regulator addition, capacitor bank addition, communication infrastructure for transfer trip), affected asset (feeder, transformer, substation, circuit segment), estimated cost, applicant-funded vs. utility-funded vs. shared cost split (references fee product for detailed cost responsibility allocation), upgrade status (identified, designed, permitted, contracted, in-progress, completed, cancelled), required completion date, actual completion date, and final settled cost. Tracks the physical grid improvements needed to enable safe DER integration and drives capital project initiation in the asset domain. | CMM: CIM Project (close), IEC61968::InfWork.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'NetworkUpgrade',
  'cmm.cim.class' = 'Project',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfWork',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-6',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.interconnection.network_upgrade'
);

-- InterconnectionAgreement  <<CIM Agreement : extension>>
CREATE TABLE IF NOT EXISTS `interconnection`.`interconnection_agreement` (
  `interconnection_agreement_id` BIGINT NOT NULL COMMENT 'Unique identifier for the interconnection agreement record. Primary key.',
  `administrator_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Interconnection agreements require utility staff oversight for contract administration, compliance monitoring, amendment processing, and customer communication. Essential for operational accountabilit',
  `application_id` BIGINT COMMENT 'Reference to the interconnection application that resulted in this agreement.',
  `meter_point_id` BIGINT COMMENT 'Foreign key linking to metering.meter_point. Business justification: Executed interconnection agreements specify the metered service point for export/import measurement, billing reconciliation, and compliance verification. Legal contract enforcement requires this link.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Interconnection agreements incorporate specific regulatory obligations as binding contractual terms (protection requirements, operating restrictions, reporting duties, IEEE 1547 mandatory functions).',
  `premise_id` BIGINT COMMENT 'Foreign key linking to customer.premise. Business justification: Interconnection agreements specify the physical point of interconnection at a premise for metering configuration, service territory validation, and operational dispatch authorization. No existing prem',
  `profile_id` BIGINT COMMENT 'Reference to the customer or third-party applicant who is the counterparty to this interconnection agreement.',
  `agreement_number` STRING COMMENT 'Externally-known unique business identifier for the interconnection agreement, used in correspondence and regulatory filings.',
  `agreement_status` STRING COMMENT 'Current lifecycle status of the interconnection agreement. Draft = under negotiation, Pending Execution = awaiting signatures, Executed = signed but not yet effective, Active = in force, Suspended = temporarily inactive, Terminated = ended by mutual consent or breach, Expired = reached end date. Reference-value candidates: Draft|Pending.',
  `agreement_type` STRING COMMENT 'Classification of the interconnection agreement based on capacity, complexity, and regulatory framework. SGIA = Small Generator Interconnection Agreement (typically <20 MW), LGIA = Large Generator Interconnection Agreement (typically >=20 MW), Simplified for expedited low-impact projects, NEM for net metering programs, Rule 21 for California-specific interconnection, Wholesale for RTO/ISO market participation. Valid values: SGIA|LGIA|Simplified Interconnection Agreement|Net Energy Metering Agreement|Rule 21 Agreement|Wholesale Market Interconnection Agreement.',
  `applicable_tariff_schedule` STRING COMMENT 'Utility rate schedule or tariff code that governs billing and compensation for the interconnected DER. This determines the rates for energy import, export credits, and any standby or interconnection charges.',
  `commissioning_date` DATE COMMENT 'Date on which the DER was commissioned and began commercial operation under this interconnection agreement. This is the actual in-service date, which may differ from the effective date of the agreement.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this interconnection agreement record was first created in the system. Used for audit trail and data lineage tracking.',
  `customer_funded_upgrade_cost_usd` DECIMAL(15,2) COMMENT 'Portion of network upgrade costs in US dollars that the DER applicant is responsible for funding under the terms of the interconnection agreement. Null if all upgrades are utility-funded.',
  `der_technology_type` STRING COMMENT 'Primary technology type of the distributed energy resource covered by this interconnection agreement. Used for portfolio analysis, renewable energy tracking, and compliance reporting. Reference-value candidates: Solar.',
  `document_url` STRING COMMENT 'URL or file path to the executed interconnection agreement document stored in the enterprise document management system. Used for audit, compliance, and customer service reference.',
  `effective_date` DATE COMMENT 'Date on which the interconnection agreement terms become binding and the DER is authorized to interconnect to the grid, subject to all technical and safety requirements being met.',
  `execution_date` DATE COMMENT 'Date on which the interconnection agreement was signed by all parties. This is the legal signature date, distinct from the effective date when terms become binding.',
  `expiration_date` DATE COMMENT 'Date on which the interconnection agreement terminates by its own terms. Nullable for agreements with indefinite term or subject to renewal provisions.',
  `export_limitation_required_flag` BOOLEAN COMMENT 'Indicates whether the DER is required to limit or prevent export of power to the grid due to local system constraints, safety concerns, or tariff restrictions. Export limitation may be enforced through inverter settings or physical controls.',
  `indemnification_terms` STRING COMMENT 'Summary of the contractual indemnification provisions, specifying which party bears liability for damages, injuries, or losses arising from the operation of the DER or interconnection facilities.',
  `insurance_certificate_expiration_date` DATE COMMENT 'Expiration date of the current insurance certificate on file for this interconnection agreement. Used to track compliance with ongoing insurance requirements.',
  `insurance_minimum_coverage_usd` DECIMAL(15,2) COMMENT 'Minimum liability insurance coverage amount in US dollars that the DER owner must maintain under the terms of the interconnection agreement. Null if no insurance is required.',
  `insurance_required_flag` BOOLEAN COMMENT 'Indicates whether the interconnection agreement requires the DER owner to maintain liability insurance coverage as a condition of interconnection.',
  `interconnection_study_cost_usd` DECIMAL(15,2) COMMENT 'Total cost in US dollars charged to the applicant for interconnection studies (feasibility, system impact, facilities studies). Null if no study was required or cost was waived.',
  `interconnection_study_required_flag` BOOLEAN COMMENT 'Indicates whether a formal interconnection impact study (feasibility, system impact, or facilities study) was required as part of the agreement approval process. Typically required for larger or more complex DER projects.',
  `inverter_certification_standard` STRING COMMENT 'Technical standard to which the DER inverter or interconnection equipment is certified, ensuring compliance with grid safety and power quality requirements. Common standards include IEEE 1547-2018, UL 1741, IEC 62109.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this interconnection agreement record was last updated in the system. Used for audit trail and change tracking.',
  `maximum_export_capacity_kw` DECIMAL(15,3) COMMENT 'Maximum electrical power in kilowatts that the DER is authorized to export to the utility grid under this interconnection agreement. This is the contractual limit, which may differ from the nameplate capacity of the generation equipment.',
  `maximum_import_capacity_kw` DECIMAL(15,3) COMMENT 'Maximum electrical power in kilowatts that the customer site is authorized to import from the utility grid under this interconnection agreement. Relevant for sites with bi-directional flow such as battery storage or EV charging facilities.',
  `metering_configuration` STRING COMMENT 'Type of metering arrangement specified in the interconnection agreement. Net Metering = single meter measuring net flow, Gross Metering = separate meters for import and export, Bi-Directional = single meter capable of measuring both directions, Import Only = consumption only, Export Only = generation only. Valid values: Net Metering|Gross Metering|Bi-Directional|Import Only|Export Only.',
  `modified_by_user` STRING COMMENT 'User ID or name of the person who last modified this interconnection agreement record. Used for audit trail and accountability.',
  `nameplate_capacity_kw` DECIMAL(15,3) COMMENT 'Manufacturer-rated maximum continuous output capacity of the DER equipment in kilowatts. This is the equipment rating, which may differ from the contractual maximum export capacity.',
  `nem_program_enrolled_flag` BOOLEAN COMMENT 'Indicates whether the interconnection agreement includes enrollment in a Net Energy Metering program, allowing the customer to receive bill credits for excess generation exported to the grid.',
  `nem_program_version` STRING COMMENT 'Specific version or tariff schedule of the NEM program under which the customer is enrolled (e.g., NEM 2.0, NEM 3.0, grandfathered NEM 1.0). Different versions have different compensation rates and rules.',
  `network_upgrade_cost_usd` DECIMAL(15,2) COMMENT 'Estimated or actual cost in US dollars of utility system upgrades required for this interconnection. Cost allocation (customer-funded vs. utility-funded) depends on regulatory framework and agreement type.',
  `network_upgrade_required_flag` BOOLEAN COMMENT 'Indicates whether utility distribution or transmission system upgrades are required to accommodate the interconnection of this DER. Upgrades may include transformer replacements, line reconductoring, or protection system enhancements.',
  `parallel_operation_allowed_flag` BOOLEAN COMMENT 'Indicates whether the DER is authorized to operate in parallel with the utility grid (exporting power) or is restricted to islanded/backup operation only. Most modern interconnection agreements allow parallel operation.',
  `poi_location_description` STRING COMMENT 'Textual description of the physical location where the DER interconnects to the utility distribution or transmission system. Includes substation name, feeder ID, transformer location, or other technical reference points.',
  `poi_voltage_level_kv` DECIMAL(10,3) COMMENT 'Nominal voltage in kilovolts at the point where the DER interconnects to the utility system. Common values include 0.12, 0.24, 0.48, 4.16, 12.47, 13.8, 34.5, 69, 115, 138, 230, 345, 500 kV.',
  `sgip_application_number` STRING COMMENT 'Unique identifier for the SGIP or other incentive program application associated with this interconnection agreement. Null if no incentive application exists.',
  `sgip_eligible_flag` BOOLEAN COMMENT 'Indicates whether the DER project is eligible for California Self-Generation Incentive Program rebates or other state/federal incentive programs. Used for customer incentive tracking and regulatory compliance.',
  `termination_date` DATE COMMENT 'Actual date on which the interconnection agreement was terminated prior to its natural expiration, due to breach, mutual consent, or other contractual provisions. Null if agreement has not been terminated.',
  `termination_reason` STRING COMMENT 'Business reason or contractual clause under which the interconnection agreement was terminated. Examples include breach of terms, failure to maintain insurance, decommissioning of DER, customer request, or utility system changes.',
  `witness_test_date` DATE COMMENT 'Date on which the utility conducted a witness test or commissioning inspection to verify that the DER installation meets all technical and safety requirements specified in the interconnection agreement.',
  `witness_test_result` STRING COMMENT 'Outcome of the utility witness test or commissioning inspection. Passed = DER meets all requirements, Failed = deficiencies identified, Conditional Pass = minor issues to be resolved, Not Required = test waived for low-impact projects, Pending = test scheduled but not yet completed. Valid values: Passed|Failed|Conditional Pass|Not Required|Pending.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_interconnection_interconnection_agreement` PRIMARY KEY (`interconnection_agreement_id`)
)
USING DELTA
COMMENT 'Executed legal agreement between the utility and the DER applicant governing the terms and conditions of grid interconnection. Captures agreement type (Small Generator Interconnection Agreement — SGIA, Large Generator Interconnection Agreement — LGIA, Simplified Interconnection Agreement), execution date, effective date, expiration date, maximum export capacity (kW), metering configuration (net metering, gross metering, bi-directional), NEM program enrollment flag, applicable tariff schedule, indemnification terms, insurance requirements, and termination conditions. This is the SSOT for the contractual interconnection relationship — distinct from the application (pre-approval) and the NEM agreement (billing program enrollment). | CMM: CIM Agreement (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'InterconnectionAgreement',
  'cmm.cim.class' = 'Agreement',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.interconnection.interconnection_agreement'
);

-- NemAgreement  <<CIM CustomerAgreement : close>>
CREATE TABLE IF NOT EXISTS `interconnection`.`nem_agreement` (
  `nem_agreement_id` BIGINT NOT NULL COMMENT 'Primary key for nem_agreement',
  `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: NEM billing credits, export compensation, and annual true-up calculations are account-level financial transactions requiring direct account linkage for billing system integration and credit reconcilia',
  `customer_service_agreement_id` BIGINT COMMENT 'Reference to the billing service agreement under which NEM credits and charges are applied.',
  `employee_id` BIGINT COMMENT 'Reference to the utility employee or system user who approved the NEM agreement.',
  `interconnection_agreement_id` BIGINT COMMENT 'Reference to the technical interconnection agreement that governs the physical connection of the DER to the utility grid. The NEM agreement governs billing and compensation; the interconnection agreement governs technical and safety requirements.',
  `interconnection_application_id` BIGINT COMMENT 'Reference to the parent interconnection application that this NEM agreement is associated with.',
  `meter_id` BIGINT COMMENT 'Reference to the bi-directional meter installed at the customer premises to measure both energy consumption and generation for NEM billing purposes.',
  `nem_account_id` BIGINT COMMENT 'Foreign key linking to renewable.nem_account. Business justification: Billing and settlement systems must link the formal NEM interconnection agreement to the operational NEM account for export credit calculations, banking policy application, and annual true-up reconcil',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: NEM agreements implement specific regulatory obligations from state NEM programs (tariff compliance, metering requirements, reporting rules, RPS credit eligibility). Essential for tracking program com',
  `profile_id` BIGINT COMMENT 'Reference to the customer who owns the Distributed Energy Resource (DER) and is enrolled in the NEM program.',
  `sgip_application_id` BIGINT COMMENT 'The SGIP application identifier if the customer has applied for or received SGIP incentives for the DER system. Null if not applicable.',
  `agreement_number` STRING COMMENT 'Externally visible unique identifier for the NEM agreement, used in customer communications and regulatory filings.',
  `annual_true_up_month` INT COMMENT 'The calendar month (1-12) in which the annual NEM true-up reconciliation occurs for customers on annual true-up billing. Null for monthly true-up customers.',
  `approval_date` DATE COMMENT 'The date on which the utility approved the customer\'s NEM agreement application.',
  `banking_credits_policy` STRING COMMENT 'The policy governing how excess NEM credits are carried forward. Indefinite (credits roll over indefinitely until used), Annual Expiration (credits expire at annual true-up), Monthly Expiration (credits expire at end of each billing cycle), No Banking (no credit carryover, excess generation compensated at lower rate). Valid values: indefinite|annual_expiration|monthly_expiration|no_banking.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this NEM agreement record was first created in the system.',
  `cumulative_credit_balance_kwh` DECIMAL(15,3) COMMENT 'The current cumulative balance of NEM energy credits in kilowatt-hours (kWh) that the customer has banked and not yet consumed. Updated after each billing cycle.',
  `cumulative_credit_balance_usd` DECIMAL(15,2) COMMENT 'The current cumulative monetary value in US dollars of NEM credits that the customer has banked and not yet applied to billing charges. Updated after each billing cycle.',
  `der_technology_type` STRING COMMENT 'The primary technology type of the DER system covered by this NEM agreement. Solar PV (photovoltaic solar panels), Wind (small wind turbine), Battery Storage (standalone or paired with generation), Fuel Cell (hydrogen or natural gas fuel cell), Combined Heat and Power (CHP cogeneration), Micro Hydro (small-scale hydroelectric). Valid values: solar_pv|wind|battery_storage|fuel_cell|combined_heat_power|micro_hydro.',
  `effective_end_date` DATE COMMENT 'The date on which the NEM agreement expires or is terminated. Null for open-ended agreements or active agreements without a defined end date.',
  `effective_start_date` DATE COMMENT 'The date from which NEM billing and credit calculations begin. May differ from enrollment date if retroactive application is approved.',
  `enrollment_date` DATE COMMENT 'The date the customer was officially enrolled in the NEM program and the agreement became effective.',
  `export_compensation_rate` DECIMAL(10,6) COMMENT 'The per-kilowatt-hour (kWh) rate at which the customer is compensated for energy exported to the grid, expressed in dollars per kWh.',
  `export_compensation_rate_type` STRING COMMENT 'The methodology used to compensate the customer for energy exported to the grid. Retail Rate (full retail electricity rate, typical for NEM 1.0), Avoided Cost (utility\'s avoided cost of generation, typical for NEM 3.0), NEM Tariff Rate (specific tariff rate defined by PUC for NEM program), Wholesale Rate (market-based wholesale energy price). Valid values: retail_rate|avoided_cost|nem_tariff_rate|wholesale_rate.',
  `grandfathered_flag` BOOLEAN COMMENT 'Indicates whether this NEM agreement is grandfathered under a previous program version\'s terms and conditions, protecting the customer from changes in subsequent tariff revisions. True if grandfathered, False otherwise.',
  `grandfathered_until_date` DATE COMMENT 'The date until which the grandfathered status is valid. After this date, the customer may be transitioned to the current NEM program terms. Null if not grandfathered or if grandfathering is indefinite.',
  `installed_system_size_kw` DECIMAL(10,3) COMMENT 'The actual nameplate capacity in kilowatts (kW) of the customer\'s installed DER system as verified during interconnection inspection.',
  `interconnection_agreement` BIGINT COMMENT 'FK to interconnection.agreement.agreement_id — NEM enrollment requires an executed interconnection agreement. The NEM agreement references the underlying interconnection agreement for the same DER system.',
  `last_true_up_date` DATE COMMENT 'The date of the most recent NEM true-up reconciliation for this agreement.',
  `maximum_system_size_kw` DECIMAL(10,3) COMMENT 'The maximum nameplate capacity in kilowatts (kW) of the customer\'s Distributed Energy Resource (DER) system that is eligible for NEM under this agreement. Typically based on customer\'s historical peak demand or regulatory cap.',
  `nem_program_type` STRING COMMENT 'The specific NEM program version under which the customer is enrolled. NEM 1.0 (legacy retail rate compensation), NEM 2.0 (retail rate minus non-bypassable charges), NEM 3.0 / NEM-ST (successor tariff with export compensation based on avoided cost), VNEM (Virtual Net Energy Metering for multi-tenant or community solar), NEMA (NEM Aggregation for multiple meters under single customer). Valid values: NEM 1.0|NEM 2.0|NEM 3.0|NEM-ST|VNEM|NEMA.',
  `nema_aggregation_type` STRING COMMENT 'For NEM Aggregation (NEMA) agreements, the type of meter aggregation allowed. On Site (multiple meters on same parcel), Adjacent Parcels (meters on contiguous parcels owned by same customer), Same Customer (meters under same customer account within service territory). Null for non-NEMA agreements. Valid values: on_site|adjacent_parcels|same_customer.',
  `next_true_up_date` DATE COMMENT 'The scheduled date of the next NEM true-up reconciliation for this agreement.',
  `notes` STRING COMMENT 'Free-text field for additional notes, comments, or special conditions related to the NEM agreement.',
  `poi_location` STRING COMMENT 'The physical location description of the Point of Interconnection where the customer\'s DER system connects to the utility distribution grid.',
  `program_status` STRING COMMENT 'Current lifecycle status of the NEM agreement. Pending (application submitted, awaiting approval), Active (agreement in force, customer receiving NEM credits), Suspended (temporarily inactive due to non-compliance or system outage), Terminated (customer or utility ended agreement), Expired (agreement reached end of term). Valid values: pending|active|suspended|terminated|expired.',
  `sgip_incentive_eligible_flag` BOOLEAN COMMENT 'Indicates whether the DER system under this NEM agreement is eligible for Self-Generation Incentive Program (SGIP) incentives. True if eligible, False otherwise.',
  `tariff_schedule_code` STRING COMMENT 'The Public Utility Commission (PUC) approved tariff schedule code that governs the rates, terms, and conditions of this NEM agreement.',
  `tariff_schedule_name` STRING COMMENT 'The human-readable name of the tariff schedule applicable to this NEM agreement (e.g., \'Residential NEM 2.0\', \'Commercial NEM-ST\').',
  `termination_date` DATE COMMENT 'The date on which the NEM agreement was terminated by the customer or utility. Null if agreement is still active.',
  `termination_reason` STRING COMMENT 'The reason for termination of the NEM agreement (e.g., customer request, system decommissioned, non-compliance, property sale). Null if agreement is still active.',
  `to_agreement` BIGINT COMMENT 'FK to interconnection.agreement.agreement_id — NEM enrollment is contingent on having an executed interconnection agreement. The NEM agreement governs billing/compensation while the interconnection agreement governs technical/legal terms. They are',
  `true_up_period` STRING COMMENT 'The billing cycle frequency at which net energy consumption and generation are reconciled and excess credits are settled. Monthly (credits reconciled each billing cycle), Annual (credits accumulated over 12 months and reconciled at year-end). Valid values: monthly|annual.',
  `updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this NEM agreement record was last modified in the system.',
  `vnem_allocation_method` STRING COMMENT 'For Virtual NEM (VNEM) agreements, the method by which generation credits are allocated among multiple beneficiary accounts. Proportional (based on each account\'s usage), Fixed Percentage (predefined allocation percentages), Custom (customer-defined allocation rules). Null for non-VNEM agreements. Valid values: proportional|fixed_percentage|custom.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_interconnection_nem_agreement` PRIMARY KEY (`nem_agreement_id`)
)
USING DELTA
COMMENT 'Net Energy Metering (NEM) program enrollment agreement for a customer with an approved DER interconnection. Captures NEM program type (NEM 1.0, NEM 2.0, NEM 3.0 / NEM-ST, VNEM for virtual NEM, NEMA for NEM aggregation), enrollment date, true-up period (monthly, annual), export compensation rate (retail rate, avoided cost, NEM tariff rate), banking credits policy, maximum system size eligibility, applicable PUC tariff schedule, and program expiration date. Distinct from the interconnection agreement (technical/legal) — the NEM agreement governs the billing and compensation mechanism for exported energy. | CMM: CIM CustomerAgreement (close), IEC61968::Customers.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'NemAgreement',
  'cmm.cim.class' = 'CustomerAgreement',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Customers',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.interconnection.nem_agreement'
);

-- ApplicationStatusHistory  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `interconnection`.`application_status_history` (
  `application_status_history_id` BIGINT NOT NULL COMMENT 'Unique identifier for each status transition record in the interconnection application lifecycle audit trail.',
  `primary_application_employee_id` BIGINT COMMENT 'Identifier of the system user or automated process that created this status transition record, supporting audit trail and accountability requirements.',
  `primary_interconnection_application_id` BIGINT COMMENT 'Reference to the parent interconnection application for which this status transition occurred.',
  `tertiary_application_id` BIGINT COMMENT 'FK to interconnection.application.application_id — Status history records are audit trail entries FOR a specific application. This is the most obvious parent-child FK in the domain.',
  `business_days_in_prior_status` INT COMMENT 'Number of business days (excluding weekends and holidays) the application remained in the prior status, used for regulatory compliance milestone tracking per FERC Order 2023.',
  `communication_channel` STRING COMMENT 'The medium or channel through which the formal communication was sent or received during this status transition. Valid values: email|postal_mail|portal|phone|in_person|fax.',
  `communication_received_timestamp` TIMESTAMP COMMENT 'Date and time when a response or acknowledgment communication was received from the applicant or other party, recorded in ISO 8601 format.',
  `communication_reference_number` STRING COMMENT 'Unique tracking number or identifier assigned to the formal communication document associated with this status transition, enabling audit trail linkage.',
  `communication_sent_timestamp` TIMESTAMP COMMENT 'Date and time when the formal communication was sent to the applicant or other party, recorded in ISO 8601 format.',
  `communication_type` STRING COMMENT 'Type of formal regulatory or business communication associated with this status transition. Reference-value candidates: deficiency_notice|completeness_determination|study_offer_letter|cost_estimate_letter|agreement_offer|pto_notification|withdrawal_notice|information_request|technical_review_report|impact_study_report|feasibility_study_report|system_impact_study|facilities_study.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this status transition record was first created in the system, recorded in ISO 8601 format for audit trail purposes.',
  `days_in_prior_status` INT COMMENT 'Number of calendar days the application remained in the prior status before this transition occurred, used for SLA tracking and bottleneck analysis.',
  `internal_notes` STRING COMMENT 'Confidential internal notes recorded by utility staff regarding this status transition, not shared with the applicant, used for internal coordination and decision documentation.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this status transition record was last modified in the system, recorded in ISO 8601 format for audit trail purposes.',
  `new_status` STRING COMMENT 'The status of the interconnection application after this transition, representing the current state following the triggering event. Reference-value candidates: submitted|under_review|incomplete|study_in_progress|study_complete|agreement_pending|approved.',
  `notification_sent_flag` BOOLEAN COMMENT 'Boolean indicator of whether an automated notification was sent to the applicant or other stakeholders regarding this status transition.',
  `notification_sent_timestamp` TIMESTAMP COMMENT 'Date and time when the automated notification was sent to stakeholders regarding this status transition, recorded in ISO 8601 format.',
  `prior_status` STRING COMMENT 'The status of the interconnection application immediately before this transition occurred. Reference-value candidates: submitted|under_review|incomplete|study_in_progress|study_complete|agreement_pending|approved.',
  `queue_position` INT COMMENT 'The position of the interconnection application in the utility interconnection queue at the time of this status transition, used for queue management and priority tracking.',
  `regulatory_milestone_met_flag` BOOLEAN COMMENT 'Boolean indicator of whether the regulatory milestone timing requirement was met for this status transition, supporting FERC Order 2023 compliance reporting.',
  `regulatory_milestone_type` STRING COMMENT 'Classification of the regulatory milestone associated with this status transition, aligned with FERC Order 2023 interconnection process requirements. Valid values: completeness_determination|study_offer|cost_estimate|agreement_execution|pto_authorization.',
  `response_deadline_date` DATE COMMENT 'The date by which the applicant or responsible party must respond to the communication or complete required actions to maintain application progress.',
  `response_received_date` DATE COMMENT 'The actual date on which the required response was received from the applicant or responsible party.',
  `response_received_flag` BOOLEAN COMMENT 'Boolean indicator of whether a required response was received from the applicant or responsible party by the deadline date.',
  `responsible_party_name` STRING COMMENT 'Name of the individual, organization, or system entity that initiated or was responsible for this status transition.',
  `responsible_party_type` STRING COMMENT 'Classification of the party responsible for initiating or causing this status transition. Valid values: applicant|utility|regulator|third_party|system.',
  `sla_compliance_flag` BOOLEAN COMMENT 'Boolean indicator of whether this status transition occurred within the defined SLA timeframe for the prior status, supporting queue management and regulatory reporting.',
  `sla_target_days` INT COMMENT 'The target number of business days defined in the SLA for completing the prior status phase, used as the benchmark for compliance measurement.',
  `sla_variance_days` INT COMMENT 'The difference between actual business days in prior status and the SLA target days, with positive values indicating delays and negative values indicating early completion.',
  `source_system` STRING COMMENT 'Name or identifier of the operational system that originated this status transition record, supporting data lineage and integration tracking.',
  `source_system_record_reference` STRING COMMENT 'Unique identifier of this status transition record in the source operational system, enabling traceability and reconciliation across systems.',
  `system_generated_flag` BOOLEAN COMMENT 'Boolean indicator of whether this status transition record was automatically generated by the system based on business rules or manually created by a user.',
  `transition_comments` STRING COMMENT 'Free-text comments or notes recorded by utility staff or system administrators regarding this status transition, providing additional context for audit and operational review.',
  `transition_timestamp` TIMESTAMP COMMENT 'Precise date and time when the application status changed from the prior status to the new status, recorded in ISO 8601 format.',
  `triggering_event_description` STRING COMMENT 'Detailed narrative description of the specific event or action that triggered this status transition, providing context for audit and compliance purposes.',
  `triggering_event_type` STRING COMMENT 'Classification of the event that caused this status transition, such as applicant submission, utility review completion, regulatory deadline expiration, or formal communication exchange. Valid values: applicant_action|utility_action|regulatory_deadline|communication_sent|communication_received|system_update.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_interconnection_application_status_history` PRIMARY KEY (`application_status_history_id`)
)
USING DELTA
COMMENT 'Audit trail record capturing each lifecycle state transition and formal regulatory communication for an interconnection application from submission through final disposition. Captures prior status, new status, transition timestamp, triggering event (applicant action, utility action, regulatory deadline, formal communication sent/received), responsible party, communication type (deficiency notice, completeness determination, study offer letter, cost estimate letter, agreement offer, PTO notification, withdrawal notice), communication channel, response deadline, response received flag, comments, and days elapsed in each status. Enables queue management SLA tracking, FERC Order 2023 milestone compliance reporting (completeness determination within 10 business days, study offer within 30 days, etc.), regulatory communication audit trail, and identification of bottlenecks in the interconnection review process. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ApplicationStatusHistory',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.interconnection.application_status_history'
);

-- QueuePosition  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `interconnection`.`queue_position` (
  `queue_position_id` BIGINT NOT NULL COMMENT 'Primary key for queue_position',
  `application_id` BIGINT COMMENT 'FK to interconnection.application.application_id — Queue position tracks where a specific application sits in the interconnection queue. One queue record per application as stated in the description.',
  `cluster_study_group_id` BIGINT COMMENT 'Identifier for the cluster or group study cohort to which this application has been assigned. Used for FERC Order 2023 cluster study processes where multiple applications are studied together.',
  `queue_application_id` BIGINT COMMENT 'FK to interconnection.application.application_id — Each queue position record tracks exactly one application\'s position in the interconnection queue. One-to-one relationship — the queue record is the application\'s place in line.',
  `queue_interconnection_application_id` BIGINT COMMENT 'Reference to the interconnection application that this queue position represents. Links to the parent application record.',
  `queue_manager_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Interconnection queue management requires dedicated utility staff for application processing, milestone tracking, study coordination, and regulatory compliance. FK enables workload balancing, performa',
  `affected_system_operator` STRING COMMENT 'Name of any neighboring transmission or distribution system operator whose system may be impacted by this interconnection. Null if no affected systems identified.',
  `affected_system_study_required` BOOLEAN COMMENT 'Indicates whether an affected system study is required due to potential impacts on neighboring utility systems.',
  `commercial_readiness_deposit_amount` DECIMAL(15,2) COMMENT 'Dollar amount of the commercial readiness deposit paid by the applicant. Typically calculated as dollars per kilowatt of proposed capacity.',
  `commercial_readiness_deposit_date` DATE COMMENT 'Date when the commercial readiness deposit was received by the utility.',
  `commercial_readiness_deposit_paid` BOOLEAN COMMENT 'Indicates whether the applicant has paid the required commercial readiness deposit to maintain queue position. Required under FERC Order 2023 financial security provisions.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this queue position record was first created in the system.',
  `estimated_study_completion_date` DATE COMMENT 'Projected date for completion of all required interconnection studies (feasibility, system impact, facilities study). Updated as studies progress.',
  `facilities_study_completion_date` DATE COMMENT 'Date when the facilities study was completed. Null if study is not yet complete.',
  `facilities_study_start_date` DATE COMMENT 'Date when the facilities study phase began for this queue position.',
  `feasibility_study_completion_date` DATE COMMENT 'Date when the feasibility study was completed. Null if study is not yet complete.',
  `feasibility_study_start_date` DATE COMMENT 'Date when the feasibility study phase began for this queue position.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this queue position record was last updated. Tracks the most recent change to any field in the record.',
  `next_milestone_description` STRING COMMENT 'Description of the next required milestone action for this queue position.',
  `next_milestone_due_date` DATE COMMENT 'Date by which the next required milestone (payment, study agreement execution, information submission) must be completed to maintain queue position.',
  `notes` STRING COMMENT 'Free-text notes capturing additional context, special circumstances, or coordination requirements for this queue position.',
  `queue_entry_date` DATE COMMENT 'Date when the interconnection application was formally entered into the utility interconnection queue. Establishes priority for processing.',
  `queue_hold_reason` STRING COMMENT 'Explanation for why the queue position was placed on hold. May include pending information, payment issues, or technical review requirements.',
  `queue_hold_start_date` DATE COMMENT 'Date when the queue position was placed on hold. Null if never placed on hold or currently active.',
  `queue_hold_status` BOOLEAN COMMENT 'Indicates whether the queue position is currently on hold. True if processing is temporarily suspended pending resolution of issues or additional information.',
  `queue_manager_assigned` STRING COMMENT 'Name or identifier of the utility staff member assigned to manage this queue position and coordinate study activities.',
  `queue_number` STRING COMMENT 'Utility-assigned sequential identifier for the position in the interconnection queue. Typically formatted as year-sequence (e.g., 2024-001).',
  `queue_position` INT COMMENT 'Numeric position of this application in the interconnection queue. Lower numbers indicate higher priority for study and processing.',
  `queue_priority_points` DECIMAL(10,2) COMMENT 'Numeric score used to determine queue priority under FERC Order 2023 scoring criteria. Higher scores may receive priority processing.',
  `queue_status` STRING COMMENT 'Current lifecycle status of the queue position. Indicates whether the application is actively progressing, on hold, withdrawn, or completed through the interconnection process. Valid values: active|on_hold|withdrawn|completed|suspended|under_review.',
  `queue_transition_cycle` STRING COMMENT 'Identifier for the transition cycle or window during which this application entered the queue. Used for FERC Order 2023 transition from serial to cluster study processes.',
  `queue_withdrawal_date` DATE COMMENT 'Date when the application was withdrawn from the interconnection queue. Null if the application remains active.',
  `site_control_demonstrated` BOOLEAN COMMENT 'Indicates whether the applicant has demonstrated site control (ownership, lease, or option) for the proposed interconnection location. Required milestone under FERC Order 2023.',
  `site_control_demonstration_date` DATE COMMENT 'Date when site control documentation was submitted and verified by the utility.',
  `study_group_assignment_date` DATE COMMENT 'Date when the application was assigned to a specific cluster or group study cohort.',
  `system_impact_study_completion_date` DATE COMMENT 'Date when the system impact study was completed. Null if study is not yet complete.',
  `system_impact_study_start_date` DATE COMMENT 'Date when the system impact study phase began for this queue position.',
  `withdrawal_reason` STRING COMMENT 'Categorized reason for withdrawal from the interconnection queue. Captures whether withdrawal was due to applicant request, non-payment of fees, failure to meet milestones, or other factors. Valid values: applicant_request|non_payment|failed_milestone|site_unavailable|project_cancelled|other.',
  `withdrawal_reason_notes` STRING COMMENT 'Additional free-text details explaining the circumstances of the queue withdrawal.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_interconnection_queue_position` PRIMARY KEY (`queue_position_id`)
)
USING DELTA
COMMENT 'Queue management record tracking the position and priority of pending interconnection applications in the utility\'s interconnection queue. Captures queue number (utility-assigned sequential identifier), queue entry date, queue position, study group assignment (for cluster/group study processes), queue withdrawal date (if applicable), withdrawal reason, queue hold status, and estimated study completion date. Manages the orderly processing of DER interconnection requests per FERC Order 2023 cluster study rules and state PUC interconnection procedures. One queue record per application. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'QueuePosition',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.interconnection.queue_position'
);

-- HostingCapacity  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `interconnection`.`hosting_capacity` (
  `hosting_capacity_id` BIGINT NOT NULL COMMENT 'Unique identifier for the hosting capacity assessment record. Primary key for this entity.',
  `assessment_analyst_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Hosting capacity assessments are performed by utility distribution engineers. FK enables technical accountability, quality assurance, workload tracking, and regulatory reporting for ICA compliance. Re',
  `distribution_substation_id` BIGINT COMMENT 'Reference to the substation load area associated with this hosting capacity assessment.',
  `ems_node_id` BIGINT COMMENT 'Foreign key linking to grid.ems_node. Business justification: Hosting capacity assessments calculate available DER capacity at specific EMS node locations before thermal, voltage, or protection violations occur. Required for Integration Capacity Analysis (ICA) m',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Hosting capacity assessments are published and tracked by forecast zone for transparency, customer planning, and regulatory compliance. California Rule 21 and similar regulations require zone-level ho',
  `load_id` BIGINT COMMENT 'Foreign key linking to forecast.load. Business justification: Hosting capacity calculations use load forecasts (specifically daytime_minimum_load_kw) as primary input for thermal and voltage constraint analysis. Direct operational dependency - hosting capacity c',
  `poi_specification_id` BIGINT COMMENT 'FK to interconnection.poi_specification.poi_specification_id — Hosting capacity assessments are for specific distribution circuit locations that correspond to potential POIs. This FK enables applicants and reviewers to cross-reference hosting capacity at a propos',
  `assessment_date` DATE COMMENT 'Date when the hosting capacity assessment was performed or published.',
  `assessment_methodology` STRING COMMENT 'The analytical methodology used to calculate hosting capacity: deterministic (worst-case snapshot), stochastic (probabilistic scenarios), time-series (chronological simulation), or hybrid approach. Valid values: deterministic|stochastic|time_series|hybrid.',
  `assessment_software_tool` STRING COMMENT 'Name and version of the software tool or platform used to perform the hosting capacity analysis (e.g., EPRI DRIVE, OpenDSS, CYME, Synergi Electric).',
  `available_hosting_capacity_kw` DECIMAL(12,2) COMMENT 'Net available hosting capacity in kilowatts (kW) after accounting for existing and queued DER capacity. This is the capacity available for new interconnection applications without triggering network upgrades.',
  `binding_constraint_type` STRING COMMENT 'The type of network constraint that limits the hosting capacity at this location. Identifies which technical factor (thermal, voltage, protection coordination, power quality, stability) is the bottleneck. Valid values: thermal|voltage|protection_coordination|power_quality|stability|other.',
  `circuit_code` BIGINT COMMENT 'Reference to the distribution circuit or feeder for which this hosting capacity assessment was performed.',
  `confidence_level_percent` DECIMAL(5,2) COMMENT 'Statistical confidence level (as a percentage) associated with the hosting capacity estimate, particularly relevant for stochastic or probabilistic assessments. For example, 95% confidence means the capacity is available 95% of the time under modeled conditions.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this hosting capacity assessment record was first created in the system.',
  `data_vintage_date` DATE COMMENT 'Date of the network model, load data, and DER penetration data used as inputs to the hosting capacity assessment. Indicates the currency of the underlying data.',
  `daytime_minimum_load_kw` DECIMAL(12,2) COMMENT 'The assumed daytime minimum load in kilowatts (kW) used in the hosting capacity calculation. Critical for assessing reverse power flow and overvoltage risk from solar generation during low-load periods.',
  `der_type_scope` STRING COMMENT 'The type(s) of Distributed Energy Resource (DER) for which this hosting capacity assessment applies. May be specific to solar PV, battery storage, EV chargers, or applicable to all DER types. Valid values: solar_pv|battery_storage|ev_charger|wind|combined_heat_power|all_der_types.',
  `existing_der_capacity_kw` DECIMAL(12,2) COMMENT 'Total existing DER capacity in kilowatts (kW) already interconnected at this location or on this circuit segment at the time of assessment. Used to calculate remaining available capacity.',
  `feeder_segment_code` STRING COMMENT 'Identifier for the specific feeder segment or node location where the hosting capacity was assessed. May reference a GIS node, pole, or transformer location.',
  `ica_compliance_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this hosting capacity assessment complies with CPUC Integration Capacity Analysis (ICA) requirements or equivalent state-level interconnection transparency mandates.',
  `interconnection_voltage_level` STRING COMMENT 'The voltage level of the distribution network at the assessed location: low voltage (secondary, typically <1 kV), medium voltage (primary distribution, typically 4-35 kV), or high voltage (sub-transmission, typically >35 kV). Valid values: low_voltage|medium_voltage|high_voltage.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this hosting capacity assessment record was last modified or updated.',
  `minimum_hosting_capacity_kw` DECIMAL(12,2) COMMENT 'The binding (minimum) hosting capacity in kilowatts (kW) across all constraint types (thermal, voltage, protection). This is the effective maximum DER capacity that can be interconnected without network upgrades.',
  `nem_agreement_applicable_flag` BOOLEAN COMMENT 'Boolean flag indicating whether Net Energy Metering (NEM) agreements are applicable for DER interconnections at this location, based on hosting capacity and tariff rules.',
  `next_reassessment_date` DATE COMMENT 'Scheduled date for the next hosting capacity reassessment at this location. Reassessments are triggered by major network reconfigurations, significant DER additions, or load changes.',
  `notes` STRING COMMENT 'Free-text notes capturing additional context, assumptions, limitations, or special conditions related to the hosting capacity assessment.',
  `phase_configuration` STRING COMMENT 'The electrical phase configuration at the assessed location: single-phase, three-phase, or split-phase. Impacts the hosting capacity calculation and interconnection requirements. Valid values: single_phase|three_phase|split_phase.',
  `poi_location_code` STRING COMMENT 'Geographic or network location code identifying the Point of Interconnection (POI) where DER capacity is being assessed.',
  `protection_hosting_capacity_kw` DECIMAL(12,2) COMMENT 'Maximum additional DER capacity in kilowatts (kW) that can be interconnected at this location without requiring protection coordination upgrades (relay settings, fuse coordination, or fault current impacts).',
  `public_map_url` STRING COMMENT 'URL link to the public-facing hosting capacity map where this assessment is displayed, enabling applicant self-screening and pre-screening of POI feasibility.',
  `publication_status` STRING COMMENT 'Current publication status of the hosting capacity assessment. Indicates whether the assessment is available on public hosting capacity maps per CPUC Rule 21 or equivalent state requirements. Valid values: draft|published|archived|under_review.',
  `queued_der_capacity_kw` DECIMAL(12,2) COMMENT 'Total DER capacity in kilowatts (kW) currently in the interconnection queue (pending applications) for this location or circuit segment. Reduces the available hosting capacity for new applicants.',
  `sgip_eligible_flag` BOOLEAN COMMENT 'Boolean flag indicating whether DER projects at this location are eligible for Self-Generation Incentive Program (SGIP) incentives based on hosting capacity availability and program rules.',
  `thermal_hosting_capacity_kw` DECIMAL(12,2) COMMENT 'Maximum additional Distributed Energy Resource (DER) capacity in kilowatts (kW) that can be interconnected at this location without exceeding thermal (conductor or transformer) limits.',
  `upgrade_cost_estimate_usd` DECIMAL(15,2) COMMENT 'Estimated cost in US dollars (USD) for network upgrades required to increase hosting capacity beyond the current binding constraint. Provided for applicant planning purposes.',
  `upgrade_description` STRING COMMENT 'Textual description of the network upgrades (e.g., conductor reconductoring, transformer replacement, voltage regulator installation, protection relay upgrades) that would be required to increase hosting capacity.',
  `voltage_hosting_capacity_kw` DECIMAL(12,2) COMMENT 'Maximum additional DER capacity in kilowatts (kW) that can be interconnected at this location without causing voltage regulation violations (overvoltage or undervoltage conditions).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_interconnection_hosting_capacity` PRIMARY KEY (`hosting_capacity_id`)
)
USING DELTA
COMMENT 'Hosting capacity assessment record for a distribution circuit, feeder segment, or substation load area, capturing the maximum additional DER capacity (kW) that can be interconnected at that location without triggering network upgrades. Captures feeder/circuit identifier, node or segment location, assessment date, thermal hosting capacity (kW), voltage hosting capacity (kW), protection hosting capacity (kW), binding constraint type (thermal, voltage, protection coordination, power quality), assessment methodology (deterministic, stochastic, time-series), daytime minimum load assumption, confidence level, data vintage, next scheduled reassessment date, and publication status for public hosting capacity maps per CPUC Rule 21 / ICA or equivalent state requirements. Updated after major network reconfigurations, DER additions, or load changes. Enables applicant self-screening and utility pre-screening of POI feasibility before formal application submission. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'HostingCapacity',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.interconnection.hosting_capacity'
);

-- InspectionMilestone  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `interconnection`.`inspection_milestone` (
  `inspection_milestone_id` BIGINT NOT NULL COMMENT 'Unique identifier for the inspection milestone record in the DER interconnection process.',
  `application_id` BIGINT COMMENT 'FK to interconnection.application.application_id — Inspections and PTO milestones are conducted for a specific application. The PTO milestone marks the transition from application to active operation.',
  `audit_finding_id` BIGINT COMMENT 'Foreign key linking to compliance.audit_finding. Business justification: Failed inspections revealing non-compliance with interconnection standards (protection settings, equipment certification, safety violations) generate audit findings requiring corrective action plans a',
  `created_by_user_employee_id` BIGINT COMMENT 'Reference to the system user who created this inspection milestone record.',
  `employee_id` BIGINT COMMENT 'Reference to the utility employee or contractor who performed the inspection or milestone verification.',
  `inspection_application_id` BIGINT COMMENT 'FK to interconnection.interconnection_application.interconnection_application_id — Inspections and milestones (including PTO) are performed for a specific application. This FK links field verification steps back to the application, enabling milestone tracking and PTO issuance.',
  `inspection_interconnection_application_id` BIGINT COMMENT 'Reference to the parent DER interconnection application that this inspection milestone belongs to.',
  `last_modified_by_user_employee_id` BIGINT COMMENT 'Reference to the system user who last modified this inspection milestone record.',
  `premise_id` BIGINT COMMENT 'Foreign key linking to customer.premise. Business justification: Field inspections for permission-to-operate occur at physical premises; inspectors require premise address, access instructions, site characteristics, and service territory for scheduling and safety c',
  `actual_completion_date` DATE COMMENT 'The actual date on which the inspection or milestone was completed.',
  `actual_completion_timestamp` TIMESTAMP COMMENT 'The precise timestamp when the inspection or milestone was completed, used for SLA tracking and audit purposes.',
  `contractor_present_flag` BOOLEAN COMMENT 'Indicates whether the installation contractor or electrician was present during the inspection. True if present, False otherwise.',
  `corrective_action_due_date` DATE COMMENT 'The deadline by which corrective actions must be completed and verified, typically set by the inspector or regulatory timeline.',
  `corrective_actions_required` STRING COMMENT 'Specific corrective actions or remediation steps required to address identified deficiencies before the milestone can be marked as passed.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this inspection milestone record was first created in the system.',
  `customer_present_flag` BOOLEAN COMMENT 'Indicates whether the customer or their authorized representative was present during the inspection. True if present, False otherwise.',
  `deficiencies_identified` STRING COMMENT 'Detailed description of any deficiencies, non-compliance issues, or corrective actions identified during the inspection. Null if inspection passed without issues.',
  `document_repository_path` STRING COMMENT 'File path or URI to the document repository location where inspection photos, reports, and supporting documentation are stored.',
  `inspection_checklist_template_code` BIGINT COMMENT 'Reference to the standardized inspection checklist template used for this milestone type, ensuring consistent evaluation criteria across inspections.',
  `inspection_duration_minutes` INT COMMENT 'The total duration of the inspection or site visit in minutes, used for resource planning and efficiency analysis.',
  `inspection_location_address` STRING COMMENT 'The physical address where the inspection or site visit was conducted, typically the customer\'s service address or DER installation site.',
  `inspection_location_gis_coordinates` STRING COMMENT 'The GIS coordinates (latitude, longitude) of the inspection site, used for mapping, routing, and spatial analysis. Typically stored as a comma-separated string or WKT format.',
  `inspection_notes` STRING COMMENT 'Free-text field for inspector notes, observations, and additional context captured during the inspection or milestone verification.',
  `inspection_result` STRING COMMENT 'Outcome of the inspection milestone. Values: pass (all requirements met), fail (deficiencies identified, corrective action required), conditional_pass (passed with minor conditions or follow-up required), not_applicable (milestone waived or not required for this application). Valid values: pass|fail|conditional_pass|not_applicable.',
  `inspector_certification_number` STRING COMMENT 'Professional certification or license number of the inspector, required for regulatory compliance and quality assurance.',
  `inspector_name` STRING COMMENT 'Full name of the inspector who performed the milestone verification, captured for audit and accountability purposes.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this inspection milestone record was last updated or modified.',
  `milestone_number` STRING COMMENT 'Business identifier for the inspection milestone, typically a sequential or hierarchical number within the interconnection application workflow.',
  `milestone_status` STRING COMMENT 'Current lifecycle status of the inspection milestone. Values: scheduled (appointment set), in_progress (inspection underway), completed (passed successfully), failed (did not pass), conditional_pass (passed with conditions or corrective actions required), cancelled (milestone no longer required), pending_reschedule (awaiting new appointment after failure or cancellation). Reference-value candidates: scheduled|in_progress|completed|failed|conditional_pass|cancelled|pending_reschedule.',
  `milestone_type` STRING COMMENT 'Classification of the inspection milestone. Values: pre_installation_site_visit (utility site assessment before installation), electrical_rough_in_inspection (inspection of electrical work before final connection), final_interconnection_inspection (final verification before energization), witness_test (utility-witnessed commissioning test), meter_installation_verification (confirmation of metering equipment), pto_authorization (Permission to Operate issuance), other (additional milestone types). Reference-value candidates: pre_installation_site_visit|electrical_rough_in_inspection|final_interconnection_inspection|witness_test|meter_installation_verification|pto_authorization|other.',
  `nem_enrollment_triggered_flag` BOOLEAN COMMENT 'Indicates whether the issuance of this PTO milestone has triggered the activation of the customer\'s NEM enrollment. True if NEM enrollment was activated as a result of this PTO, False otherwise.',
  `photos_attached_flag` BOOLEAN COMMENT 'Indicates whether inspection photos or documentation have been attached to this milestone record. True if photos attached, False otherwise.',
  `pto_as_built_drawing_accepted_flag` BOOLEAN COMMENT 'Indicates whether the as-built electrical drawings and single-line diagrams have been submitted, reviewed, and accepted by the utility. Populated only for PTO milestone records. True if accepted, False otherwise.',
  `pto_authorization_date` DATE COMMENT 'The official date on which Permission to Operate was granted, marking the customer\'s authorization to energize and operate the DER system. Populated only when milestone_type is pto_authorization and inspection_result is pass.',
  `pto_authorized_export_capacity_kw` DECIMAL(10,3) COMMENT 'The maximum export capacity in kilowatts (kW) authorized for the DER system under the PTO. This value may differ from the applied-for capacity based on technical review and grid constraints. Populated only for PTO milestone records.',
  `pto_issued_flag` BOOLEAN COMMENT 'Indicates whether this milestone represents the issuance of Permission to Operate authorization. True if this is the PTO milestone and PTO has been granted, False otherwise. This flag marks the definitive transition from interconnection application to active DER operation.',
  `pto_metering_configuration_confirmed_flag` BOOLEAN COMMENT 'Indicates whether the metering configuration (bidirectional meter, net meter, or production meter) has been verified and confirmed as compliant with NEM and interconnection requirements. Populated only for PTO milestone records. True if confirmed, False otherwise.',
  `pto_operating_mode_restrictions` STRING COMMENT 'Any operating mode restrictions or limitations imposed on the DER system as a condition of PTO issuance, such as export limitations, time-of-use restrictions, or voltage support requirements. Populated only for PTO milestone records.',
  `pto_protective_relay_settings_verified_flag` BOOLEAN COMMENT 'Indicates whether the protective relay settings and anti-islanding protection have been verified and meet IEEE 1547 and utility interconnection standards. Populated only for PTO milestone records. True if verified, False otherwise.',
  `reinspection_date` DATE COMMENT 'The scheduled date for the follow-up reinspection after corrective actions have been completed. Null if no reinspection is required.',
  `reinspection_required_flag` BOOLEAN COMMENT 'Indicates whether a follow-up reinspection is required after corrective actions are completed. True if reinspection needed, False otherwise.',
  `safety_incident_flag` BOOLEAN COMMENT 'Indicates whether any safety incident or near-miss occurred during the inspection. True if incident occurred, False otherwise. Triggers incident reporting workflow.',
  `scheduled_date` DATE COMMENT 'The date on which the inspection or milestone activity is scheduled to occur.',
  `scheduled_time_window_end` TIMESTAMP COMMENT 'The end timestamp of the scheduled time window for the inspection or site visit.',
  `scheduled_time_window_start` TIMESTAMP COMMENT 'The start timestamp of the scheduled time window for the inspection or site visit.',
  `sgip_incentive_payment_triggered_flag` BOOLEAN COMMENT 'Indicates whether the issuance of this PTO milestone has triggered the release of SGIP incentive payment to the customer. True if SGIP payment was triggered, False otherwise.',
  `sla_compliance_flag` BOOLEAN COMMENT 'Indicates whether the milestone was completed within the SLA target timeline. True if compliant, False if SLA was missed.',
  `sla_target_completion_date` DATE COMMENT 'The target date by which this milestone should be completed per the utility\'s interconnection SLA or regulatory timeline requirements.',
  `weather_conditions` STRING COMMENT 'Description of weather conditions at the time of the inspection, relevant for outdoor site visits and safety considerations.',
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
  CONSTRAINT `pk_interconnection_inspection_milestone` PRIMARY KEY (`inspection_milestone_id`)
)
USING DELTA
COMMENT 'Record of a required inspection, field verification, or authorization milestone in the DER interconnection process. Captures milestone type (utility pre-installation site visit, electrical rough-in inspection, final interconnection inspection, witness test, meter installation verification, Permission to Operate — PTO authorization), scheduled date, actual completion date, inspector identity, inspection result (pass, fail, conditional pass), deficiencies identified, corrective actions required, re-inspection date, and PTO-specific attributes when milestone type is PTO (authorized export capacity kW, operating mode restrictions, metering configuration confirmed, protective relay settings verified, as-built drawing accepted). This entity now also serves as the SSOT for PTO issuance — the PTO milestone record marks the definitive transition from the interconnection application process to active DER operation and triggers NEM enrollment activation and SGIP incentive payment. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'InspectionMilestone',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.interconnection.inspection_milestone',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- SgipEnrollment  <<CIM Agreement : extension>>
CREATE TABLE IF NOT EXISTS `interconnection`.`sgip_enrollment` (
  `sgip_enrollment_id` BIGINT NOT NULL COMMENT 'Unique identifier for the SGIP enrollment record. Primary key for tracking a specific DER system\'s participation in California\'s Self-Generation Incentive Program or equivalent state battery storage incentive program.',
  `customer_service_agreement_id` BIGINT COMMENT 'Reference to the billing service agreement under which the DER system is installed. Links the incentive to the customer\'s utility account.',
  `der_installer_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_installer. Business justification: sgip_enrollment tracks installer_name and installer_license_number as STRING attributes. The der_installer product is the authoritative master for licensed DER installers with company_name, license_nu',
  `der_system_id` BIGINT COMMENT 'FK to interconnection.der_system.der_system_id — SGIP incentives are for a specific DER system (typically battery storage). The enrollment tracks the incentive lifecycle for that system.',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: SGIP incentive payments are financial transactions requiring GL account posting for regulatory reporting, cash disbursement tracking, and program cost recovery. Essential for California PUC compliance',
  `incentive_application_id` BIGINT COMMENT 'Foreign key linking to renewable.incentive_application. Business justification: Incentive payment processing requires linking SGIP-specific enrollment records to the broader incentive application tracking system for payment reconciliation, compliance reporting, and program budget',
  `interconnection_application_id` BIGINT COMMENT 'Reference to the underlying interconnection application that this SGIP enrollment is associated with. Links the incentive enrollment to the grid connection request.',
  `meter_point_id` BIGINT COMMENT 'Foreign key linking to metering.meter_point. Business justification: SGIP incentive programs require service point identification for program eligibility verification, performance monitoring, and greenhouse gas reduction metric validation. Regulatory reporting depends',
  `profile_id` BIGINT COMMENT 'Reference to the customer (residential, commercial, or industrial) who owns or operates the DER system and is applying for SGIP incentives.',
  `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: SGIP incentive claims require regulatory filings to CPUC documenting program compliance, budget utilization, equity budget allocation, and performance metrics. Program administrators file quarterly re',
  `sgip_der_system_id` BIGINT COMMENT 'FK to interconnection.der_system.der_system_id — SGIP incentives are tied to a specific DER system (battery, fuel cell, etc.). This FK links the incentive enrollment to the physical system it subsidizes. Required for incentive payment verification a',
  `application_submission_date` DATE COMMENT 'The date the SGIP enrollment application was submitted to the program administrator. Determines queue position and applicable program year rules.',
  `cancellation_reason` STRING COMMENT 'The reason for cancellation if the SGIP enrollment was cancelled before incentive payment. Examples: customer withdrawal, project abandonment, failed inspection, budget exhaustion, reservation expiration.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this SGIP enrollment record was first created in the system. Used for audit trail and data lineage tracking.',
  `critical_facility_flag` BOOLEAN COMMENT 'Indicates whether the DER system is installed at a critical facility (True) such as a hospital, fire station, water treatment plant, or emergency shelter, qualifying for equity resiliency incentives. False if not a critical facility.',
  `disadvantaged_community_flag` BOOLEAN COMMENT 'Indicates whether the installation site is located in a CalEnviroScreen-designated disadvantaged community (True), qualifying for equity budget incentives. False if not in a disadvantaged community.',
  `equipment_manufacturer` STRING COMMENT 'The manufacturer of the DER system equipment (battery, fuel cell, wind turbine, etc.). Required for SGIP equipment eligibility verification.',
  `equipment_model` STRING COMMENT 'The specific model number of the DER system equipment. Must match CPUC-approved equipment list for SGIP eligibility.',
  `equipment_serial_number` STRING COMMENT 'The unique serial number of the installed DER system equipment. Required for final incentive claim verification and warranty tracking.',
  `equity_budget_flag` BOOLEAN COMMENT 'Indicates whether this enrollment is funded from the SGIP equity budget (True) or general market budget (False). Equity budget is reserved for low-income customers and disadvantaged communities.',
  `equity_resiliency_flag` BOOLEAN COMMENT 'Indicates whether this enrollment qualifies for the equity resiliency budget (True), which provides higher incentive rates for equity customers in high fire-threat districts or critical facilities. False if not applicable.',
  `greenhouse_gas_reduction_metric_tons` DECIMAL(12,3) COMMENT 'The estimated annual greenhouse gas emissions reduction in metric tons of CO2 equivalent achieved by the DER system. Used for SGIP program impact reporting.',
  `high_fire_threat_district_flag` BOOLEAN COMMENT 'Indicates whether the installation site is located in a CPUC-designated high fire-threat district (True), qualifying for equity resiliency incentives. False if not in a high fire-threat district.',
  `incentive_claim_submission_date` DATE COMMENT 'The date the customer or installer submitted the incentive payment claim to the program administrator after installation completion. Triggers payment processing.',
  `incentive_payment_amount_usd` DECIMAL(15,2) COMMENT 'The actual incentive amount paid in US dollars. May differ from reservation amount due to final capacity verification, adjustments, or partial payments.',
  `incentive_payment_date` DATE COMMENT 'The date the SGIP incentive payment was issued to the customer or installer. Marks the completion of the incentive lifecycle.',
  `incentive_rate_per_w` DECIMAL(10,4) COMMENT 'The SGIP incentive rate in dollars per watt ($/W) applicable to this enrollment for generation technologies (fuel cells, wind, combustion). Rate varies by program year, tier, and technology category.',
  `incentive_rate_per_wh` DECIMAL(10,4) COMMENT 'The SGIP incentive rate in dollars per watt-hour ($/Wh) applicable to this enrollment for battery storage systems. Rate varies by program year, tier, and technology category.',
  `incentive_tier` STRING COMMENT 'The SGIP incentive tier under which this enrollment is categorized. Determines incentive rate and budget allocation: general_market (standard), equity (low-income or disadvantaged community), equity_resiliency (equity + critical facility or high fire-threat district). Valid values: general_market|equity|equity_resiliency.',
  `installation_completion_date` DATE COMMENT 'The date the DER system installation was completed and passed final inspection. Required for incentive payment claim submission.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this SGIP enrollment record was last updated. Used for audit trail and change tracking.',
  `low_income_flag` BOOLEAN COMMENT 'Indicates whether the customer qualifies as low-income (True) based on CPUC income thresholds, qualifying for equity budget incentives. False if not low-income.',
  `notes` STRING COMMENT 'Free-text notes and comments related to this SGIP enrollment. Used for documenting special circumstances, program administrator communications, or processing exceptions.',
  `payment_status` STRING COMMENT 'Current status of the SGIP incentive payment lifecycle. Tracks progression from initial application through final payment or cancellation. Reference-value candidates: pending|reserved|claim_submitted|under_review|approved|paid|cancelled|expired.',
  `performance_requirement_met_flag` BOOLEAN COMMENT 'Indicates whether the installed DER system met SGIP performance requirements during the measurement period (True) or failed to meet requirements (False). Affects final incentive payment eligibility.',
  `program_administrator` STRING COMMENT 'The CPUC-designated program administrator responsible for processing this SGIP enrollment. One of: PG&E (Pacific Gas & Electric), SCE (Southern California Edison), SoCalGas (Southern California Gas Company), SDG&E (San Diego Gas & Electric), CSE (Center for Sustainable Energy). Valid values: PG&E|SCE|SoCalGas|SDG&E|CSE.',
  `program_year` INT COMMENT 'The SGIP program year (calendar year) under which this enrollment was submitted. Determines applicable incentive rates, budget allocations, and program rules.',
  `queue_position` INT COMMENT 'The position of this enrollment in the SGIP application queue for the applicable program year and budget category. Lower numbers indicate earlier queue position and higher priority for funding.',
  `reservation_amount_usd` DECIMAL(15,2) COMMENT 'The total incentive amount in US dollars reserved for this SGIP enrollment upon application approval. Calculated as system capacity multiplied by applicable incentive rate.',
  `reservation_confirmation_date` DATE COMMENT 'The date the program administrator confirmed the incentive reservation for this enrollment. Marks the start of the installation completion deadline period.',
  `reservation_expiration_date` DATE COMMENT 'The date by which the DER system installation must be completed and claimed, or the incentive reservation will expire. Typically 18-24 months from reservation confirmation date.',
  `system_capacity_kw` DECIMAL(12,3) COMMENT 'The nameplate power capacity of the DER system in kilowatts (kW). Used for calculating incentives for generation technologies (fuel cells, wind, combustion engines).',
  `system_capacity_kwh` DECIMAL(12,3) COMMENT 'The energy storage capacity of the battery system in kilowatt-hours (kWh). Used for calculating incentives for battery storage technologies (residential and non-residential batteries).',
  `technology_category` STRING COMMENT 'The type of self-generation technology for which SGIP incentives are being requested. Categories align with CPUC-defined eligible technologies and determine incentive rates. Reference-value candidates: residential_battery|non_residential_battery|fuel_cell|wind_turbine|internal_combustion_engine|gas_turbine|microturbine.',
  `warranty_years` INT COMMENT 'The duration of the manufacturer\'s warranty for the DER system equipment in years. SGIP requires minimum warranty periods for eligible equipment.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_interconnection_sgip_enrollment` PRIMARY KEY (`sgip_enrollment_id`)
)
USING DELTA
COMMENT 'Self-Generation Incentive Program (SGIP) enrollment record for a DER system applying for California SGIP incentives (or equivalent state battery storage incentive program). Captures SGIP program year, technology category (residential battery, non-residential battery, fuel cell, wind), incentive tier, reservation amount ($), incentive rate ($/Wh or $/W), system capacity (kWh/kW), equity budget flag, equity resiliency flag, application submission date, reservation confirmation date, installation completion date, incentive payment status, and program administrator (CPUC-designated). Tracks the incentive lifecycle from reservation through final payment. | CMM: CIM Agreement (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SgipEnrollment',
  'cmm.cim.class' = 'Agreement',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.interconnection.sgip_enrollment'
);

-- CostResponsibility  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `interconnection`.`cost_responsibility` (
  `cost_responsibility_id` BIGINT NOT NULL COMMENT 'Unique identifier for the cost responsibility allocation record. Primary key for this entity.',
  `ap_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ap_invoice. Business justification: When utilities pay contractors for interconnection studies or network upgrades, AP invoices are created and linked to cost responsibility records for cost reconciliation, payment tracking, and applica',
  `cost_estimator_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Cost estimates for interconnection upgrades require utility engineer accountability for regulatory compliance, dispute resolution, and audit trails. Replaces denormalized cost_estimator_name. Critical',
  `interconnection_application_id` BIGINT COMMENT 'Reference to the interconnection application for which costs are being allocated. Links this cost responsibility record to the specific DER interconnection request.',
  `payment_id` BIGINT COMMENT 'Foreign key linking to billing.payment. Business justification: Applicants make payments toward interconnection cost responsibilities (study costs, network upgrade costs) through standard utility payment channels. Business process: Interconnection cost invoices ar',
  `allocation_approval_date` DATE COMMENT 'Date when the cost allocation was formally approved by the utility and accepted by the applicant. Establishes binding cost responsibility.',
  `allocation_status` STRING COMMENT 'Current lifecycle status of the cost responsibility allocation. Tracks progression from initial estimate through final settlement. Reference-value candidates: draft|approved|invoiced|paid|disputed|settled|cancelled.',
  `applicant_cost_share_amount` DECIMAL(18,2) COMMENT 'Dollar amount of cost responsibility assigned to the interconnection applicant in USD. Represents the applicant\'s financial obligation for this cost category.',
  `applicant_cost_share_percentage` DECIMAL(5,2) COMMENT 'Percentage of total cost assigned to the applicant (0.00 to 100.00). Provides proportional view of applicant responsibility.',
  `capital_cost_recovery_method` STRING COMMENT 'Method by which the utility will recover its cost share from ratepayers. Defines the regulatory accounting treatment for utility-funded interconnection costs. Valid values: rate_base|direct_assignment|deferred_account|regulatory_asset|expense.',
  `cost_allocation_methodology` STRING COMMENT 'Method used to determine how interconnection costs are divided between parties. Defines the regulatory or contractual basis for cost sharing. Valid values: beneficiary_pays|socialized|pro_rata|participant_funded|utility_funded|hybrid.',
  `cost_category` STRING COMMENT 'Classification of the interconnection cost type. Defines the nature of the cost being allocated (study costs, upgrade costs, or facilities costs). Valid values: feasibility_study|system_impact_study|facilities_study|distribution_upgrade|transmission_upgrade|interconnection_facilities.',
  `cost_estimate_date` DATE COMMENT 'Date when the cost estimate was prepared by the utility. Establishes the baseline for cost allocation and applicant decision-making.',
  `cost_estimate_valid_until_date` DATE COMMENT 'Date until which the cost estimate remains valid. After this date, costs may be re-estimated due to market changes or project delays.',
  `cost_variance_amount` DECIMAL(18,2) COMMENT 'Difference between estimated and final settled cost in USD (final minus estimated). Positive values indicate cost overruns, negative values indicate cost savings.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this cost responsibility record was first created in the system. Audit trail for record creation.',
  `deposit_amount_collected` DECIMAL(18,2) COMMENT 'Dollar amount of deposit collected from the applicant in USD. Represents upfront payment to secure interconnection queue position and fund initial studies.',
  `deposit_collection_date` DATE COMMENT 'Date when the deposit was collected from the applicant. Critical for tracking payment milestones and queue position security.',
  `dispute_filed_date` DATE COMMENT 'Date when the formal dispute was filed by the applicant. Starts the dispute resolution timeline.',
  `dispute_flag` BOOLEAN COMMENT 'Indicates whether the applicant has disputed the cost allocation. True if formal dispute or challenge has been filed.',
  `dispute_reason` STRING COMMENT 'Description of the reason for cost allocation dispute. Captures applicant\'s objection to cost estimate, allocation methodology, or scope of work.',
  `dispute_resolution_date` DATE COMMENT 'Date when the dispute was resolved through negotiation, mediation, or regulatory decision. Closes the dispute lifecycle.',
  `final_settled_cost` DECIMAL(18,2) COMMENT 'Actual final cost after project completion and true-up in USD. Represents the reconciled cost after all work is completed and invoiced.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this cost responsibility record was last updated. Audit trail for record changes.',
  `modified_by_user` STRING COMMENT 'Username or identifier of the user who last modified this record. Provides accountability for data changes.',
  `notes` STRING COMMENT 'Free-text notes providing additional context on cost allocation, special terms, assumptions, or conditions. Captures nuances not represented in structured fields.',
  `payment_due_date` DATE COMMENT 'Date by which the applicant must pay their cost share. Failure to pay by this date may result in queue withdrawal or penalties.',
  `payment_schedule_terms` STRING COMMENT 'Description of the payment schedule and milestone-based payment terms. Defines when and how the applicant must pay their cost share (e.g., 50% at study completion, 50% at construction start).',
  `refund_amount` DECIMAL(18,2) COMMENT 'Dollar amount eligible for refund to the applicant in USD. Applicable when actual costs are lower than estimated or when refund provisions are triggered.',
  `refund_eligibility_flag` BOOLEAN COMMENT 'Indicates whether the applicant is eligible for a refund of any portion of their cost share. True if refund provisions exist per agreement or tariff.',
  `regulatory_docket_number` STRING COMMENT 'PUC or FERC docket number associated with cost allocation approval or dispute. Links cost responsibility to regulatory proceedings.',
  `sgip_eligible_flag` BOOLEAN COMMENT 'Indicates whether this cost is eligible for SGIP incentive reimbursement (California-specific program). True if costs qualify for SGIP offset.',
  `sgip_incentive_amount` DECIMAL(18,2) COMMENT 'Dollar amount of SGIP incentive applied to offset applicant cost share in USD. Reduces net applicant financial obligation.',
  `total_estimated_cost` DECIMAL(18,2) COMMENT 'Total estimated cost for this cost category in USD. Represents the full cost before allocation between applicant and utility.',
  `utility_cost_share_amount` DECIMAL(18,2) COMMENT 'Dollar amount of cost responsibility assigned to the utility in USD. Represents the utility\'s financial obligation for this cost category, typically recovered through rates.',
  `utility_cost_share_percentage` DECIMAL(5,2) COMMENT 'Percentage of total cost assigned to the utility (0.00 to 100.00). Provides proportional view of utility responsibility.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_interconnection_cost_responsibility` PRIMARY KEY (`cost_responsibility_id`)
)
USING DELTA
COMMENT 'Cost responsibility allocation record defining how interconnection-related costs (impact study costs, network upgrade costs, interconnection facilities costs) are allocated between the applicant and the utility. Captures cost category (feasibility study, system impact study, facilities study, distribution upgrade, transmission upgrade, interconnection facilities), total estimated cost, applicant share ($ and %), utility share ($ and %), cost allocation methodology (beneficiary pays, socialized, pro-rata), payment schedule, deposit amount collected, refund eligibility, and final settled cost. Drives billing of interconnection fees and capital cost recovery. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CostResponsibility',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.interconnection.cost_responsibility'
);

-- InterconnectionFee  <<CIM Charge : close>>
CREATE TABLE IF NOT EXISTS `interconnection`.`fee` (
  `fee_id` BIGINT NOT NULL COMMENT 'Primary key for fee',
  `application_id` BIGINT COMMENT 'FK to interconnection.application.application_id — Fees and cost responsibilities are charged against a specific interconnection application. After cost_responsibility merge, fee is the single SSOT for all financial obligations tied to an application.',
  `fee_application_id` BIGINT COMMENT 'FK to interconnection.application.application_id — All interconnection fees are charged in the context of a specific application. After merging cost_responsibility into fee, this link carries both fee transactions and cost allocation records.',
  `fee_interconnection_application_id` BIGINT COMMENT 'Reference to the interconnection application to which this fee applies. Links fee obligations to the specific DER interconnection request.',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Interconnection fees (application fees, study deposits, upgrade cost recovery) are posted to specific GL accounts for revenue recognition, cash application, regulatory reporting, and FERC account clas',
  `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Interconnection fees (application fees, study deposits, inspection fees) are invoiced through the utility\'s standard billing system and appear on customer invoices. Business process: Interconnection f',
  `receivable_id` BIGINT COMMENT 'Foreign key linking to finance.receivable. Business justification: Interconnection fees billed to applicants create accounts receivable tracked in AR for cash collection, aging analysis, dunning, and write-off management. Essential for cash forecasting and DSO report',
  `amount` DECIMAL(15,2) COMMENT 'Total monetary value of the fee obligation in USD. Represents the gross amount invoiced to the applicant before any payments or adjustments.',
  `applicant_cost_share_amount` DECIMAL(15,2) COMMENT 'Dollar amount of the total estimated cost allocated to the interconnection applicant. Represents the applicant\'s financial responsibility for interconnection work.',
  `applicant_cost_share_percent` DECIMAL(5,2) COMMENT 'Percentage of the total estimated cost allocated to the applicant (0-100%). Calculated as (applicant_cost_share_amount / total_estimated_cost) * 100.',
  `cost_allocation_methodology` STRING COMMENT 'Method used to allocate interconnection-related costs between the applicant and the utility. Defines the cost-sharing framework per FERC Order 2003 and state tariff rules. Valid values: beneficiary_pays|socialized|pro_rata|tariff_based|negotiated.',
  `cost_category` STRING COMMENT 'Classification of the interconnection cost being allocated. Distinguishes between study costs, facility construction costs, and system upgrade costs. Reference-value candidates: impact_study|interconnection_facilities|network_upgrades|distribution_upgrades|transmission_upgrades|metering|protection|administrative.',
  `cost_center_code` STRING COMMENT 'Cost center responsible for managing this fee transaction. Typically the interconnection services department or distributed generation operations group.',
  `cost_reconciliation_date` DATE COMMENT 'Date when final costs were reconciled against deposits and estimates. Triggers final invoicing or refund processing.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this fee record was first created in the system. Audit field for data lineage and compliance tracking.',
  `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the fee amount. Standardized to USD for domestic utility operations. Valid values: USD.',
  `deposit_amount_collected` DECIMAL(15,2) COMMENT 'Total deposit amount collected from the applicant to secure interconnection work or study costs. Held in escrow until work is completed or application is withdrawn.',
  `dispute_flag` BOOLEAN COMMENT 'Indicates whether the applicant has formally disputed this fee. True if a dispute case has been opened; triggers dispute resolution workflow.',
  `dispute_reason` STRING COMMENT 'Applicant\'s stated reason for disputing the fee. Captures the nature of the disagreement (amount, applicability, calculation methodology, tariff interpretation).',
  `dispute_resolution_date` DATE COMMENT 'Date the fee dispute was resolved. Null if dispute is still open. Resolution may result in fee adjustment, waiver, or confirmation of original amount.',
  `due_date` DATE COMMENT 'Date by which payment of the fee is required. Determined by tariff payment terms (typically 30 days from invoice date). Late payments may result in application suspension or penalties.',
  `fee_category` STRING COMMENT 'Categorization of the fee based on payment structure and refund eligibility. Distinguishes between upfront deposits, one-time charges, and ongoing service fees. Valid values: one_time|recurring|deposit|refundable|non_refundable.',
  `fee_number` STRING COMMENT 'Business identifier for the fee transaction. Externally-known reference number used in invoicing, payment tracking, and customer correspondence.',
  `fee_status` STRING COMMENT 'Current lifecycle status of the fee obligation. Tracks the fee from initial assessment through payment, refund, or cancellation. Reference-value candidates: pending|invoiced|partially_paid|paid|overdue|waived|refunded|cancelled|disputed.',
  `fee_type` STRING COMMENT 'Classification of the fee obligation. Defines the nature of the charge within the interconnection lifecycle (application processing, technical study, construction, ongoing service). Reference-value candidates: application_fee|study_deposit|supplemental_study_fee|inspection_fee|facilities_charge|standby_charge|interconnection_facilities_cost|network_upgrade_cost|impact_study_cost|witness_test_fee|commissioning_fee|administrative_fee.',
  `final_settled_cost` DECIMAL(15,2) COMMENT 'Actual final cost of the interconnection work or study after completion. Used to reconcile deposits and determine final applicant payment or refund amounts.',
  `last_modified_by` STRING COMMENT 'User ID or system identifier that last modified this fee record. Audit field for accountability and compliance tracking.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this fee record was last updated. Audit field for change tracking and data lineage.',
  `notes` STRING COMMENT 'Free-text field for additional context, special instructions, or clarifications related to this fee. Used for documenting non-standard situations, payment arrangements, or regulatory exceptions.',
  `outstanding_balance` DECIMAL(15,2) COMMENT 'Remaining unpaid amount for this fee (fee_amount minus payment_amount). Zero indicates full payment; positive values indicate amounts due.',
  `payment_amount` DECIMAL(15,2) COMMENT 'Total amount paid by the applicant toward this fee obligation. May differ from fee_amount if partial payments or overpayments occur.',
  `payment_method` STRING COMMENT 'Financial instrument used by the applicant to remit payment. Determines processing time and reconciliation procedures. Reference-value candidates: check|wire_transfer|ach|credit_card|debit_card|cash|money_order.',
  `payment_received_date` DATE COMMENT 'Date the utility received payment for this fee. Used to calculate payment timeliness and release application holds.',
  `payment_reference_number` STRING COMMENT 'External reference number from the payment transaction (check number, wire confirmation, ACH trace number). Used for payment reconciliation and dispute resolution.',
  `refund_amount` DECIMAL(15,2) COMMENT 'Amount refunded to the applicant for this fee. Applies to refundable deposits or overpayments. Null if no refund has been issued.',
  `refund_date` DATE COMMENT 'Date the refund was processed and issued to the applicant. Null if no refund has been issued.',
  `refund_eligibility_flag` BOOLEAN COMMENT 'Indicates whether this fee is eligible for refund under tariff rules. True for refundable deposits; false for non-refundable application fees and administrative charges.',
  `tariff_effective_date` DATE COMMENT 'Effective date of the tariff schedule under which this fee was assessed. Ensures fee amounts comply with the tariff version in effect at the time of application.',
  `tariff_schedule_reference` STRING COMMENT 'Reference to the applicable utility tariff schedule or rate schedule that governs this fee. Identifies the regulatory authority and fee structure (e.g., Electric Rule 21, Schedule DG).',
  `total_estimated_cost` DECIMAL(15,2) COMMENT 'Total estimated cost for the interconnection work or study associated with this fee. Represents the full project cost before allocation between applicant and utility.',
  `utility_cost_share_amount` DECIMAL(15,2) COMMENT 'Dollar amount of the total estimated cost allocated to the utility. Represents the utility\'s financial responsibility for interconnection work, typically for system upgrades that benefit multiple customers.',
  `utility_cost_share_percent` DECIMAL(5,2) COMMENT 'Percentage of the total estimated cost allocated to the utility (0-100%). Calculated as (utility_cost_share_amount / total_estimated_cost) * 100.',
  `waiver_approval_date` DATE COMMENT 'Date the fee waiver was approved. Establishes the effective date of the waiver for accounting and compliance purposes.',
  `waiver_approved_by` STRING COMMENT 'Name or identifier of the utility employee or system that approved the fee waiver. Used for audit trail and compliance verification.',
  `waiver_flag` BOOLEAN COMMENT 'Indicates whether this fee has been waived by the utility. True if waived due to regulatory program (e.g., low-income assistance), utility discretion, or tariff exemption.',
  `waiver_reason` STRING COMMENT 'Business justification for fee waiver. Documents the regulatory program, tariff provision, or management approval that authorized the waiver.',
  `created_by` STRING COMMENT 'User ID or system identifier that created this fee record. Audit field for accountability and compliance tracking.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_interconnection_fee` PRIMARY KEY (`fee_id`)
)
USING DELTA
COMMENT 'Master record for all financial obligations, fee transactions, and cost responsibility allocations between the utility and a DER interconnection applicant throughout the application lifecycle. Captures fee type (application fee, study deposit, supplemental study fee, inspection fee, facilities charge, standby charge), fee amount, invoice date, due date, payment received date, payment method, payment status (invoiced, paid, overdue, refunded), and applicable tariff schedule reference. Also serves as the SSOT for cost responsibility allocation — defining how interconnection-related costs (impact study costs, network upgrade costs, interconnection facilities costs) are split between applicant and utility, including cost category, total estimated cost, applicant share ($ and %), utility share ($ and %), cost allocation methodology (beneficiary pays, socialized, pro-rata), payment schedule, deposit amount collected, refund eligibility, and final settled cost. This is the single authoritative source for all interconnection-related monetary transactions, cost allocations, applicant invoicing, deposit tracking, refund processing, and capital cost recovery reporting. | CMM: CIM Charge (close), IEC61968::PaymentMetering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'InterconnectionFee',
  'cmm.cim.class' = 'Charge',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::PaymentMetering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.interconnection.fee'
);

-- DerInstaller  <<CIM OrganisationRole : close>>
CREATE TABLE IF NOT EXISTS `interconnection`.`der_installer` (
  `der_installer_id` BIGINT NOT NULL COMMENT 'Unique identifier for the DER installer or electrical contractor record. Primary key.',
  `active_flag` BOOLEAN COMMENT 'Indicates whether the installer is currently active and eligible to submit interconnection applications. Inactive status may result from expired credentials, program suspension, or voluntary withdrawal.',
  `application_completeness_rate_percent` DECIMAL(5,2) COMMENT 'Percentage of interconnection applications submitted by this installer that were complete and did not require resubmission due to missing or incorrect information. Measures installer quality and process adherence.',
  `approved_installer_program_flag` BOOLEAN COMMENT 'Indicates whether the installer is enrolled in the utilitys approved installer program, which may provide streamlined interconnection review and expedited processing.',
  `average_time_to_pto_days` DECIMAL(8,2) COMMENT 'Average number of days from interconnection application submission to PTO issuance for installations completed by this installer. Lower values indicate higher installer efficiency and quality.',
  `background_check_date` DATE COMMENT 'Date the most recent background check was completed for the installer.',
  `background_check_status` STRING COMMENT 'Status of background check for installer company principals, if required by utility approved installer program. Valid values: Passed|Failed|Pending|Not Required|Expired.',
  `bond_amount` DECIMAL(15,2) COMMENT 'Dollar amount of the contractor bond in USD maintained by the installer.',
  `bonding_status` STRING COMMENT 'Indicates whether the installer maintains a contractor bond as required by state law and utility programs. Valid values: Bonded|Not Bonded|Expired|Pending Verification.',
  `business_address_line1` STRING COMMENT 'Primary street address line for the installers business location.',
  `business_address_line2` STRING COMMENT 'Secondary address line for suite, unit, or building information for the installers business location.',
  `business_city` STRING COMMENT 'City where the installers business is located.',
  `business_country` STRING COMMENT 'Country where the installers business is located. Three-letter ISO country code. Valid values: USA|CAN|MEX.',
  `business_postal_code` STRING COMMENT 'ZIP or postal code for the installers business address.',
  `business_state` STRING COMMENT 'State or province where the installers business is located. Two-letter state code.',
  `company_name` STRING COMMENT 'Legal business name of the DER installer or electrical contractor company authorized to perform DER installations.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the installer record was first created in the utility system.',
  `dba_name` STRING COMMENT 'Trade name or DBA name under which the installer operates, if different from legal company name.',
  `inactivation_date` DATE COMMENT 'Date the installer was marked inactive in the utility system. Null if installer is currently active.',
  `inactivation_reason` STRING COMMENT 'Reason the installer was marked inactive (e.g., expired license, insurance lapse, program violation, voluntary withdrawal, business closure).',
  `inspection_pass_rate_percent` DECIMAL(5,2) COMMENT 'Percentage of DER installations by this installer that passed utility inspection on the first attempt. Key performance metric for approved installer program standing.',
  `insurance_certificate_status` STRING COMMENT 'Status of the general liability and workers compensation insurance certificate on file with the utility. Required for approved installer program participation. Valid values: Current|Expired|Pending|Not Provided|Insufficient Coverage.',
  `insurance_coverage_amount` DECIMAL(15,2) COMMENT 'Total liability coverage amount in USD provided by the installers insurance policy. Utilities typically require minimum coverage thresholds.',
  `insurance_expiration_date` DATE COMMENT 'Expiration date of the current insurance certificate on file. Installers must maintain continuous coverage.',
  `license_expiration_date` DATE COMMENT 'Date the contractor license expires and requires renewal. Critical for determining installer eligibility for interconnection work.',
  `license_issue_date` DATE COMMENT 'Date the contractor license was originally issued by the state licensing authority.',
  `license_number` STRING COMMENT 'State-issued contractor license number for the installer. Primary credential for performing electrical and DER installation work.',
  `license_status` STRING COMMENT 'Current status of the contractor license with the state licensing board. Valid values: Active|Expired|Suspended|Revoked|Inactive|Pending Renewal.',
  `license_type` STRING COMMENT 'Classification of contractor license held by the installer. C-10 covers electrical work, C-46 covers solar installations, General Contractor covers broad construction work. Valid values: C-10 Electrical|C-46 Solar|General Contractor|General Engineering|Specialty Contractor|Multi-License.',
  `nabcep_certification_number` STRING COMMENT 'NABCEP certification credential number if the installer is NABCEP certified.',
  `nabcep_certified_flag` BOOLEAN COMMENT 'Indicates whether the installer holds NABCEP certification for solar PV installation. NABCEP is the gold standard for solar installer certification in North America.',
  `nabcep_expiration_date` DATE COMMENT 'Expiration date of the NABCEP certification, requiring renewal to maintain certified status.',
  `notes` STRING COMMENT 'Free-text notes field for utility staff to record additional information about the installer, including performance issues, special accommodations, or historical context.',
  `primary_contact_email` STRING COMMENT 'Email address of the primary contact for interconnection application communications and notifications. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `primary_contact_name` STRING COMMENT 'Full name of the primary contact person at the installer company for interconnection application coordination.',
  `primary_contact_phone` STRING COMMENT 'Primary phone number for reaching the installer contact regarding interconnection applications and technical coordination.',
  `program_enrollment_date` DATE COMMENT 'Date the installer was accepted into the utilitys approved installer program.',
  `program_status` STRING COMMENT 'Current standing of the installer within the utilitys approved installer program. Suspension or termination may result from poor performance metrics or compliance violations. Valid values: Active|Suspended|Probation|Terminated|Pending Review.',
  `service_territory_coverage` STRING COMMENT 'Geographic service territories or regions where the installer is authorized and actively performs DER installations. May be pipe-delimited list of territory codes.',
  `specialization_technologies` STRING COMMENT 'Pipe-delimited list of DER technology types the installer specializes in (e.g., Solar PV, Battery Storage, EV Chargers, Wind, CHP). Helps match installers to customer needs.',
  `tax_id_number` STRING COMMENT 'Federal Employer Identification Number (FEIN) or Tax ID for the installer company. Used for regulatory reporting and payment processing.',
  `total_capacity_installed_kw` DECIMAL(15,3) COMMENT 'Cumulative nameplate capacity in kW of all DER systems installed by this installer within the utilitys service territory.',
  `total_installations_count` INT COMMENT 'Total number of DER systems installed by this installer within the utilitys service territory. Indicates installer experience level.',
  `training_completion_date` DATE COMMENT 'Date the installer completed required utility interconnection training program. May be prerequisite for approved installer program enrollment.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the installer record was last modified in the utility system. Tracks most recent change to any field.',
  `website_url` STRING COMMENT 'Public website URL for the installer company. Provides customers and utility staff access to company information and credentials.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_interconnection_der_installer` PRIMARY KEY (`der_installer_id`)
)
USING DELTA
COMMENT 'Master record for a licensed DER installer or electrical contractor authorized to perform DER installations for interconnection applications submitted to the utility. Captures installer company name, license number, license type (C-10 electrical, C-46 solar, general contractor), license expiration date, NABCEP certification flag, insurance certificate status, bonding status, approved installer program enrollment (utility-specific), service territory coverage, and installer performance metrics (inspection pass rate, application completeness rate, average time-to-PTO). Enables the utility to pre-screen installer qualifications, track installer quality for streamlined review programs, and support regulatory reporting on installer compliance. | CMM: CIM OrganisationRole (close), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DerInstaller',
  'cmm.cim.class' = 'OrganisationRole',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.interconnection.der_installer'
);

-- ApplicationDocument  <<CIM Document : close>>
CREATE TABLE IF NOT EXISTS `interconnection`.`application_document` (
  `application_document_id` BIGINT NOT NULL COMMENT 'Unique identifier for the interconnection application document record. Primary key.',
  `evidence_record_id` BIGINT COMMENT 'Foreign key linking to compliance.evidence_record. Business justification: Key interconnection documents (UL 1741 certifications, witness test reports, as-built drawings, protection settings) serve as compliance evidence for regulatory audits verifying interconnection standa',
  `interconnection_application_id` BIGINT COMMENT 'Reference to the parent interconnection application to which this document belongs. Links document to the application package.',
  `primary_application_employee_id` BIGINT COMMENT 'Reference to the utility engineer or reviewer who performed the technical or administrative review of the document.',
  `superseded_by_document_application_document_id` BIGINT COMMENT 'Reference to the newer document that replaces this document when a revised version is submitted.',
  `tertiary_application_modified_by_user_employee_id` BIGINT COMMENT 'Reference to the user or system account that last modified the document record in the interconnection application system.',
  `acceptance_date` DATE COMMENT 'Date when the document was formally accepted by the utility as meeting all requirements for the interconnection application.',
  `certification_expiration_date` DATE COMMENT 'Date when the certification or permit documented expires and may require renewal for continued interconnection operation.',
  `certification_type` STRING COMMENT 'Type of certification or standard that the document evidences (e.g., UL 1741, IEEE 1547, ISO 9001) when the document is a certification or compliance document.',
  `confidential_flag` BOOLEAN COMMENT 'Indicates whether the document contains confidential or proprietary information that requires restricted access. True if confidential, False if public or internal.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the document record was first created in the interconnection application system.',
  `document_description` STRING COMMENT 'Detailed description of the document content, purpose, or scope to provide context for reviewers and stakeholders.',
  `document_language` STRING COMMENT 'Primary language in which the document is written, using ISO 639-1 two-letter language codes (e.g., EN for English, ES for Spanish).',
  `document_name` STRING COMMENT 'Human-readable name or title of the document as provided by the submitter or assigned by the utility.',
  `document_number` STRING COMMENT 'Business identifier or tracking number assigned to the document for reference and retrieval purposes.',
  `document_status` STRING COMMENT 'Current lifecycle status of the document in the interconnection application review process. Tracks progression from submission through acceptance or rejection. Reference-value candidates: received|under_review|accepted|rejected|superseded|pending_resubmission|archived.',
  `document_to_application` BIGINT COMMENT 'FK to interconnection.interconnection_application.interconnection_application_id — Documents are submitted as part of a specific application package. This FK links documents to their parent application — essential for completeness determination and document management.',
  `document_type` STRING COMMENT 'Classification of the document submitted or issued as part of the interconnection application. Identifies the nature and purpose of the document in the application package. Reference-value candidates: single_line_diagram|site_plan|equipment_specification_sheet|inverter_datasheet|ul_1741_certification|load_calculation|executed_agreement|insurance_certificate|permit|as_built_drawing|nem_agreement|sgip_application|electrical_permit|building_permit|utility_interconnection_agreement|proof_of_ownership|authorization_letter|technical_review_report|impact_study_report|commissioning_report|other.',
  `document_version` STRING COMMENT 'Version number or identifier of the document to track revisions and superseded versions throughout the application lifecycle.',
  `file_format` STRING COMMENT 'Format or file type of the document (e.g., PDF, DOCX, DWG, image formats) to support proper rendering and compatibility checks. Reference-value candidates: pdf|docx|xlsx|dwg|jpg|png|tiff|xml|csv|other.',
  `file_name` STRING COMMENT 'Original file name of the uploaded or stored document including file extension.',
  `file_reference` STRING COMMENT 'File path, URI, or storage location reference pointing to the physical or digital document in the document management system or file repository.',
  `file_size_bytes` BIGINT COMMENT 'Size of the document file in bytes for storage management and upload validation purposes.',
  `issuing_authority` STRING COMMENT 'Name of the organization, agency, or authority that issued the document, certification, or permit (e.g., UL, local building department, state PUC).',
  `modified_timestamp` TIMESTAMP COMMENT 'Date and time when the document record was last modified or updated in the interconnection application system.',
  `rejection_category` STRING COMMENT 'Classification of the rejection reason to enable tracking and analysis of common document deficiencies. Reference-value candidates: incomplete|non_compliant|incorrect_format|missing_signature|expired|insufficient_detail|technical_deficiency|other.',
  `rejection_date` DATE COMMENT 'Date when the document was rejected by the utility due to non-compliance, incompleteness, or other deficiencies.',
  `rejection_reason` STRING COMMENT 'Detailed explanation of why the document was rejected, including specific deficiencies, missing information, or non-compliance issues that must be addressed.',
  `required_for_completeness_flag` BOOLEAN COMMENT 'Indicates whether this document is mandatory for the interconnection application to be deemed complete. True if required, False if optional or supplementary.',
  `resubmission_deadline_date` DATE COMMENT 'Date by which the document must be resubmitted to avoid delays or withdrawal of the interconnection application.',
  `resubmission_required_flag` BOOLEAN COMMENT 'Indicates whether the document must be resubmitted to proceed with the interconnection application. True if resubmission is mandatory, False otherwise.',
  `review_completion_date` DATE COMMENT 'Date when the utility or reviewing authority completed the review of the document and issued a determination.',
  `review_start_date` DATE COMMENT 'Date when the utility or reviewing authority began formal review of the submitted document.',
  `reviewer_notes` STRING COMMENT 'Internal notes or comments recorded by the utility reviewer during the document review process, capturing observations, questions, or follow-up items.',
  `submission_date` DATE COMMENT 'Date when the document was submitted to the utility as part of the interconnection application package.',
  `submission_timestamp` TIMESTAMP COMMENT 'Precise date and time when the document was submitted or uploaded to the interconnection application system.',
  `submitted_by_email` STRING COMMENT 'Email address of the individual or organization that submitted the document for correspondence and notification purposes. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `submitted_by_name` STRING COMMENT 'Name of the individual or organization that submitted the document.',
  `submitted_by_party` STRING COMMENT 'Classification of the party who submitted the document (applicant, utility, third-party engineer, installer, contractor, regulatory authority). Reference-value candidates: applicant|utility|third_party_engineer|installer|contractor|regulatory_authority|other.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_interconnection_application_document` PRIMARY KEY (`application_document_id`)
)
USING DELTA
COMMENT 'Record of documents submitted or issued as part of an interconnection application package. Captures document type (single-line diagram, site plan, equipment specification sheet, inverter datasheet, UL 1741 certification, load calculation, executed agreement, insurance certificate, permit, as-built drawing), document name, file reference, submission date, submitted by (applicant or utility), document status (received, under review, accepted, rejected, superseded), rejection reason, and required resubmission deadline. Manages the document lifecycle for interconnection application completeness determination. | CMM: CIM Document (close), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ApplicationDocument',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.interconnection.application_document'
);

-- ClusterStudyGroup  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `interconnection`.`cluster_study_group` (
  `cluster_study_group_id` BIGINT NOT NULL COMMENT 'Unique identifier for the cluster study group cohort formed under FERC Order 2023 cluster interconnection study rules. Primary key for the cluster study group entity.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Cluster studies group multiple DER applications by control area to assess cumulative impact on balancing authority operations, reserve requirements, and frequency response capability. Required for eff',
  `distribution_substation_id` BIGINT COMMENT 'Primary substation serving the geographic area of this cluster study group. Reference to the substation asset where multiple DER interconnections are proposed.',
  `employee_id` BIGINT COMMENT 'User identifier of the system user who created the cluster study group record. Audit trail for accountability and data governance.',
  `feeder_id` BIGINT COMMENT 'Primary distribution feeder circuit serving the cluster study group area. Reference to the feeder where DER applications are concentrated.',
  `irp_scenario_id` BIGINT COMMENT 'Foreign key linking to forecast.irp_scenario. Business justification: Cluster study results feed IRP scenario development for DER penetration assumptions, grid investment planning, and capacity expansion decisions. Regulatory requirement - utilities must incorporate int',
  `study_manager_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Cluster studies require internal utility engineer coordination for multi-application analysis, stakeholder communication, regulatory milestone tracking, and cost allocation oversight. Essential for st',
  `actual_completion_date` DATE COMMENT 'Actual date when the cluster study was completed and final study report was issued to all participating applicants.',
  `affected_network_segments` STRING COMMENT 'List or description of distribution and transmission network segments potentially impacted by the aggregate DER capacity in the cluster study group. Identifies circuits, substations, and transmission lines requiring analysis.',
  `applicable_tariff_reference` STRING COMMENT 'Reference to the utility tariff or interconnection procedures document governing the cluster study process. Identifies the regulatory framework and rules applied.',
  `application_count` INT COMMENT 'Total number of interconnection applications included in this cluster study group cohort. Reflects the volume of DER projects being evaluated simultaneously.',
  `contingency_scenarios_evaluated` STRING COMMENT 'Description of the contingency scenarios and operating conditions analyzed in the cluster study. Includes N-1, N-2, and other reliability scenarios per NERC standards.',
  `cost_allocation_methodology` STRING COMMENT 'Method used to allocate the total cluster study cost among participating interconnection applications. Describes the formula or approach for distributing costs (e.g., pro-rata by capacity, equal share, tiered allocation).',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the cluster study group record was first created in the system. Audit trail for data lineage and record creation tracking.',
  `formation_date` DATE COMMENT 'Date when the cluster study group cohort was officially formed and applications were grouped together for simultaneous study processing under FERC Order 2023 rules.',
  `geographic_study_area` STRING COMMENT 'Geographic boundary or service territory area encompassing all interconnection applications included in this cluster study group. May reference feeder, substation zone, planning area, or transmission zone.',
  `load_flow_analysis_performed_flag` BOOLEAN COMMENT 'Indicates whether load flow analysis was performed as part of the cluster study. True if steady-state power flow and voltage profile were evaluated.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the cluster study group record was last modified. Audit trail for data lineage and change tracking.',
  `network_upgrade_cost_estimate_amount` DECIMAL(15,2) COMMENT 'Total estimated cost for all network upgrades identified in the cluster study. Represents the capital investment required to enable interconnection of the cluster group capacity.',
  `network_upgrades_description` STRING COMMENT 'Detailed description of the network upgrades identified as necessary by the cluster study. Includes equipment additions, replacements, and system modifications required for safe interconnection.',
  `network_upgrades_required_flag` BOOLEAN COMMENT 'Indicates whether the cluster study identified the need for distribution or transmission network upgrades to accommodate the aggregate DER capacity. True if upgrades are required.',
  `planning_area_code` STRING COMMENT 'Utility planning area or zone code where the cluster study group applications are located. Used for resource planning and grid impact analysis.',
  `protection_coordination_review_flag` BOOLEAN COMMENT 'Indicates whether protection coordination review was performed as part of the cluster study. True if protective relay settings and coordination were evaluated.',
  `regulatory_jurisdiction` STRING COMMENT 'Regulatory authority or jurisdiction governing the cluster study process and interconnection requirements. Typically state PUC or FERC for wholesale interconnections.',
  `short_circuit_analysis_performed_flag` BOOLEAN COMMENT 'Indicates whether short circuit analysis was performed as part of the cluster study. True if fault current contribution and protective device coordination were evaluated.',
  `stability_analysis_performed_flag` BOOLEAN COMMENT 'Indicates whether dynamic stability analysis was performed as part of the cluster study. True if transient and voltage stability were evaluated.',
  `study_agreement_executed_date` DATE COMMENT 'Date when the cluster study agreement was executed by all participating applicants. Marks the contractual commitment to proceed with the study.',
  `study_contractor` STRING COMMENT 'Name of the engineering firm or consultant performing the cluster study analysis. May be internal utility engineering team or external third-party contractor.',
  `study_contractor_type` STRING COMMENT 'Classification of the entity performing the cluster study work. Indicates whether study is conducted by utility staff or external resources. Valid values: internal|external_consultant|independent_engineer.',
  `study_cost_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the study cost estimate amount. Typically USD for US utilities. Pattern: ^[A-Z]{3}$.',
  `study_cost_estimate_amount` DECIMAL(15,2) COMMENT 'Total estimated cost for performing the cluster study analysis. Includes engineering labor, modeling, analysis, and report preparation costs.',
  `study_deposit_amount` DECIMAL(15,2) COMMENT 'Total deposit amount collected from participating applicants to fund the cluster study. Typically a percentage of the estimated study cost.',
  `study_deposit_received_date` DATE COMMENT 'Date when the required study deposit was received from all participating applicants. Triggers the start of study work.',
  `study_duration_days` INT COMMENT 'Total number of calendar days from study initiation to actual completion. Used for performance tracking and regulatory compliance reporting.',
  `study_findings_summary` STRING COMMENT 'Executive summary of the cluster study technical findings, conclusions, and recommendations. Provides high-level overview of study results for stakeholders.',
  `study_group_name` STRING COMMENT 'Descriptive name assigned to the cluster study group, often reflecting the geographic area or study cycle identifier.',
  `study_group_number` STRING COMMENT 'Business identifier assigned to the cluster study group for external reference and tracking. Typically follows utility-specific numbering convention for cluster studies.',
  `study_group_status` STRING COMMENT 'Current lifecycle status of the cluster study group. Tracks progression from formation through completion or cancellation. Valid values: forming|active|in_progress|completed|suspended|cancelled.',
  `study_initiation_date` DATE COMMENT 'Date when the cluster study work officially commenced. Marks the beginning of technical analysis and impact assessment activities.',
  `study_report_document_reference` STRING COMMENT 'Document management system reference or file path to the final cluster study report. Provides link to the complete technical study documentation.',
  `study_scope_description` STRING COMMENT 'Detailed description of the technical scope and analysis activities included in the cluster study. Outlines the specific assessments, models, and scenarios to be evaluated.',
  `study_type` STRING COMMENT 'Classification of the cluster study being performed. Determines the scope and depth of technical analysis required under FERC Order 2023 cluster study process. Valid values: cluster_feasibility|cluster_system_impact|cluster_facilities|combined_cluster.',
  `target_completion_date` DATE COMMENT 'Planned or estimated date for completion of the cluster study. Established based on FERC Order 2023 timelines and study scope.',
  `technical_feasibility_determination` STRING COMMENT 'Overall determination of technical feasibility for interconnecting the cluster study group capacity. Indicates whether the aggregate DER can be safely interconnected with or without network upgrades. Valid values: feasible|feasible_with_upgrades|not_feasible|conditional.',
  `total_proposed_capacity_kw` DECIMAL(15,3) COMMENT 'Aggregate nameplate capacity in kilowatts of all DER systems included in the cluster study group. Sum of all application capacities within the cohort.',
  `total_proposed_capacity_mw` DECIMAL(12,3) COMMENT 'Aggregate nameplate capacity in megawatts of all DER systems included in the cluster study group. Calculated for transmission-level impact assessment.',
  `upgrade_cost_allocation_methodology` STRING COMMENT 'Method used to allocate network upgrade costs among participating interconnection applications in the cluster study group. Describes the formula or approach for distributing upgrade financial responsibility.',
  `upgrade_cost_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the network upgrade cost estimate amount. Typically USD for US utilities. Pattern: ^[A-Z]{3}$.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_interconnection_cluster_study_group` PRIMARY KEY (`cluster_study_group_id`)
)
USING DELTA
COMMENT 'Record of a cluster or group study cohort formed under FERC Order 2023 cluster interconnection study rules, grouping multiple DER applications in the same geographic area for simultaneous impact study processing. Captures study group identifier, geographic study area (feeder, substation zone, planning area), study group formation date, number of applications in group, study type (cluster feasibility, cluster system impact, cluster facilities), study contractor, study start date, estimated completion date, and group study cost allocation methodology. Enables efficient processing of high-volume DER interconnection queues. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ClusterStudyGroup',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.interconnection.cluster_study_group'
);

-- ========= FOREIGN KEYS within interconnection (46) =========
ALTER TABLE `interconnection`.`application` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_der_installer_id`;
ALTER TABLE `interconnection`.`application` ADD CONSTRAINT `fk_interconnection_application_der_installer_id` FOREIGN KEY (`der_installer_id`) REFERENCES `interconnection`.`der_installer` (`der_installer_id`);

ALTER TABLE `interconnection`.`der_system` DROP CONSTRAINT IF EXISTS `fk_interconnection_der_system_der_application_id`;
ALTER TABLE `interconnection`.`der_system` ADD CONSTRAINT `fk_interconnection_der_system_der_application_id` FOREIGN KEY (`der_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`der_system` DROP CONSTRAINT IF EXISTS `fk_interconnection_der_system_der_installer_id`;
ALTER TABLE `interconnection`.`der_system` ADD CONSTRAINT `fk_interconnection_der_system_der_installer_id` FOREIGN KEY (`der_installer_id`) REFERENCES `interconnection`.`der_installer` (`der_installer_id`);

ALTER TABLE `interconnection`.`der_system` DROP CONSTRAINT IF EXISTS `fk_interconnection_der_system_der_interconnection_application_id`;
ALTER TABLE `interconnection`.`der_system` ADD CONSTRAINT `fk_interconnection_der_system_der_interconnection_application_id` FOREIGN KEY (`der_interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`der_system` DROP CONSTRAINT IF EXISTS `fk_interconnection_der_system_primary_der_installer_id`;
ALTER TABLE `interconnection`.`der_system` ADD CONSTRAINT `fk_interconnection_der_system_primary_der_installer_id` FOREIGN KEY (`primary_der_installer_id`) REFERENCES `interconnection`.`der_installer` (`der_installer_id`);

ALTER TABLE `interconnection`.`der_system` DROP CONSTRAINT IF EXISTS `fk_interconnection_der_system_to_der_installer_id`;
ALTER TABLE `interconnection`.`der_system` ADD CONSTRAINT `fk_interconnection_der_system_to_der_installer_id` FOREIGN KEY (`to_der_installer_id`) REFERENCES `interconnection`.`der_installer` (`der_installer_id`);

ALTER TABLE `interconnection`.`poi_specification` DROP CONSTRAINT IF EXISTS `fk_interconnection_poi_specification_poi_application_id`;
ALTER TABLE `interconnection`.`poi_specification` ADD CONSTRAINT `fk_interconnection_poi_specification_poi_application_id` FOREIGN KEY (`poi_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`poi_specification` DROP CONSTRAINT IF EXISTS `fk_interconnection_poi_specification_poi_interconnection_application_id`;
ALTER TABLE `interconnection`.`poi_specification` ADD CONSTRAINT `fk_interconnection_poi_specification_poi_interconnection_application_id` FOREIGN KEY (`poi_interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`technical_review` DROP CONSTRAINT IF EXISTS `fk_interconnection_technical_review_application_id`;
ALTER TABLE `interconnection`.`technical_review` ADD CONSTRAINT `fk_interconnection_technical_review_application_id` FOREIGN KEY (`application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`technical_review` DROP CONSTRAINT IF EXISTS `fk_interconnection_technical_review_technical_application_id`;
ALTER TABLE `interconnection`.`technical_review` ADD CONSTRAINT `fk_interconnection_technical_review_technical_application_id` FOREIGN KEY (`technical_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`technical_review` DROP CONSTRAINT IF EXISTS `fk_interconnection_technical_review_technical_interconnection_application_id`;
ALTER TABLE `interconnection`.`technical_review` ADD CONSTRAINT `fk_interconnection_technical_review_technical_interconnection_application_id` FOREIGN KEY (`technical_interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`impact_study` DROP CONSTRAINT IF EXISTS `fk_interconnection_impact_study_application_id`;
ALTER TABLE `interconnection`.`impact_study` ADD CONSTRAINT `fk_interconnection_impact_study_application_id` FOREIGN KEY (`application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`impact_study` DROP CONSTRAINT IF EXISTS `fk_interconnection_impact_study_cluster_study_group_id`;
ALTER TABLE `interconnection`.`impact_study` ADD CONSTRAINT `fk_interconnection_impact_study_cluster_study_group_id` FOREIGN KEY (`cluster_study_group_id`) REFERENCES `interconnection`.`cluster_study_group` (`cluster_study_group_id`);

ALTER TABLE `interconnection`.`impact_study` DROP CONSTRAINT IF EXISTS `fk_interconnection_impact_study_impact_application_id`;
ALTER TABLE `interconnection`.`impact_study` ADD CONSTRAINT `fk_interconnection_impact_study_impact_application_id` FOREIGN KEY (`impact_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`impact_study` DROP CONSTRAINT IF EXISTS `fk_interconnection_impact_study_impact_interconnection_application_id`;
ALTER TABLE `interconnection`.`impact_study` ADD CONSTRAINT `fk_interconnection_impact_study_impact_interconnection_application_id` FOREIGN KEY (`impact_interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`network_upgrade` DROP CONSTRAINT IF EXISTS `fk_interconnection_network_upgrade_application_id`;
ALTER TABLE `interconnection`.`network_upgrade` ADD CONSTRAINT `fk_interconnection_network_upgrade_application_id` FOREIGN KEY (`application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`network_upgrade` DROP CONSTRAINT IF EXISTS `fk_interconnection_network_upgrade_impact_study_id`;
ALTER TABLE `interconnection`.`network_upgrade` ADD CONSTRAINT `fk_interconnection_network_upgrade_impact_study_id` FOREIGN KEY (`impact_study_id`) REFERENCES `interconnection`.`impact_study` (`impact_study_id`);

ALTER TABLE `interconnection`.`network_upgrade` DROP CONSTRAINT IF EXISTS `fk_interconnection_network_upgrade_network_application_id`;
ALTER TABLE `interconnection`.`network_upgrade` ADD CONSTRAINT `fk_interconnection_network_upgrade_network_application_id` FOREIGN KEY (`network_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`network_upgrade` DROP CONSTRAINT IF EXISTS `fk_interconnection_network_upgrade_network_impact_study`;
ALTER TABLE `interconnection`.`network_upgrade` ADD CONSTRAINT `fk_interconnection_network_upgrade_network_impact_study` FOREIGN KEY (`network_impact_study`) REFERENCES `interconnection`.`impact_study` (`impact_study_id`);

ALTER TABLE `interconnection`.`network_upgrade` DROP CONSTRAINT IF EXISTS `fk_interconnection_network_upgrade_network_impact_study_id`;
ALTER TABLE `interconnection`.`network_upgrade` ADD CONSTRAINT `fk_interconnection_network_upgrade_network_impact_study_id` FOREIGN KEY (`network_impact_study_id`) REFERENCES `interconnection`.`impact_study` (`impact_study_id`);

ALTER TABLE `interconnection`.`network_upgrade` DROP CONSTRAINT IF EXISTS `fk_interconnection_network_upgrade_network_interconnection_application_id`;
ALTER TABLE `interconnection`.`network_upgrade` ADD CONSTRAINT `fk_interconnection_network_upgrade_network_interconnection_application_id` FOREIGN KEY (`network_interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`network_upgrade` DROP CONSTRAINT IF EXISTS `fk_interconnection_network_upgrade_to_impact_study_id`;
ALTER TABLE `interconnection`.`network_upgrade` ADD CONSTRAINT `fk_interconnection_network_upgrade_to_impact_study_id` FOREIGN KEY (`to_impact_study_id`) REFERENCES `interconnection`.`impact_study` (`impact_study_id`);

ALTER TABLE `interconnection`.`interconnection_agreement` DROP CONSTRAINT IF EXISTS `fk_interconnection_interconnection_agreement_application_id`;
ALTER TABLE `interconnection`.`interconnection_agreement` ADD CONSTRAINT `fk_interconnection_interconnection_agreement_application_id` FOREIGN KEY (`application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`nem_agreement` DROP CONSTRAINT IF EXISTS `fk_interconnection_nem_agreement_interconnection_agreement_id`;
ALTER TABLE `interconnection`.`nem_agreement` ADD CONSTRAINT `fk_interconnection_nem_agreement_interconnection_agreement_id` FOREIGN KEY (`interconnection_agreement_id`) REFERENCES `interconnection`.`interconnection_agreement` (`interconnection_agreement_id`);

ALTER TABLE `interconnection`.`nem_agreement` DROP CONSTRAINT IF EXISTS `fk_interconnection_nem_agreement_interconnection_application_id`;
ALTER TABLE `interconnection`.`nem_agreement` ADD CONSTRAINT `fk_interconnection_nem_agreement_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`nem_agreement` DROP CONSTRAINT IF EXISTS `fk_interconnection_nem_agreement_sgip_application_id`;
ALTER TABLE `interconnection`.`nem_agreement` ADD CONSTRAINT `fk_interconnection_nem_agreement_sgip_application_id` FOREIGN KEY (`sgip_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`application_status_history` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_status_history_primary_interconnection_application_id`;
ALTER TABLE `interconnection`.`application_status_history` ADD CONSTRAINT `fk_interconnection_application_status_history_primary_interconnection_application_id` FOREIGN KEY (`primary_interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`application_status_history` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_status_history_tertiary_application_id`;
ALTER TABLE `interconnection`.`application_status_history` ADD CONSTRAINT `fk_interconnection_application_status_history_tertiary_application_id` FOREIGN KEY (`tertiary_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`queue_position` DROP CONSTRAINT IF EXISTS `fk_interconnection_queue_position_application_id`;
ALTER TABLE `interconnection`.`queue_position` ADD CONSTRAINT `fk_interconnection_queue_position_application_id` FOREIGN KEY (`application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`queue_position` DROP CONSTRAINT IF EXISTS `fk_interconnection_queue_position_cluster_study_group_id`;
ALTER TABLE `interconnection`.`queue_position` ADD CONSTRAINT `fk_interconnection_queue_position_cluster_study_group_id` FOREIGN KEY (`cluster_study_group_id`) REFERENCES `interconnection`.`cluster_study_group` (`cluster_study_group_id`);

ALTER TABLE `interconnection`.`queue_position` DROP CONSTRAINT IF EXISTS `fk_interconnection_queue_position_queue_application_id`;
ALTER TABLE `interconnection`.`queue_position` ADD CONSTRAINT `fk_interconnection_queue_position_queue_application_id` FOREIGN KEY (`queue_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`queue_position` DROP CONSTRAINT IF EXISTS `fk_interconnection_queue_position_queue_interconnection_application_id`;
ALTER TABLE `interconnection`.`queue_position` ADD CONSTRAINT `fk_interconnection_queue_position_queue_interconnection_application_id` FOREIGN KEY (`queue_interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`hosting_capacity` DROP CONSTRAINT IF EXISTS `fk_interconnection_hosting_capacity_poi_specification_id`;
ALTER TABLE `interconnection`.`hosting_capacity` ADD CONSTRAINT `fk_interconnection_hosting_capacity_poi_specification_id` FOREIGN KEY (`poi_specification_id`) REFERENCES `interconnection`.`poi_specification` (`poi_specification_id`);

ALTER TABLE `interconnection`.`inspection_milestone` DROP CONSTRAINT IF EXISTS `fk_interconnection_inspection_milestone_application_id`;
ALTER TABLE `interconnection`.`inspection_milestone` ADD CONSTRAINT `fk_interconnection_inspection_milestone_application_id` FOREIGN KEY (`application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`inspection_milestone` DROP CONSTRAINT IF EXISTS `fk_interconnection_inspection_milestone_inspection_application_id`;
ALTER TABLE `interconnection`.`inspection_milestone` ADD CONSTRAINT `fk_interconnection_inspection_milestone_inspection_application_id` FOREIGN KEY (`inspection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`inspection_milestone` DROP CONSTRAINT IF EXISTS `fk_interconnection_inspection_milestone_inspection_interconnection_application_id`;
ALTER TABLE `interconnection`.`inspection_milestone` ADD CONSTRAINT `fk_interconnection_inspection_milestone_inspection_interconnection_application_id` FOREIGN KEY (`inspection_interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`sgip_enrollment` DROP CONSTRAINT IF EXISTS `fk_interconnection_sgip_enrollment_der_installer_id`;
ALTER TABLE `interconnection`.`sgip_enrollment` ADD CONSTRAINT `fk_interconnection_sgip_enrollment_der_installer_id` FOREIGN KEY (`der_installer_id`) REFERENCES `interconnection`.`der_installer` (`der_installer_id`);

ALTER TABLE `interconnection`.`sgip_enrollment` DROP CONSTRAINT IF EXISTS `fk_interconnection_sgip_enrollment_der_system_id`;
ALTER TABLE `interconnection`.`sgip_enrollment` ADD CONSTRAINT `fk_interconnection_sgip_enrollment_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `interconnection`.`sgip_enrollment` DROP CONSTRAINT IF EXISTS `fk_interconnection_sgip_enrollment_interconnection_application_id`;
ALTER TABLE `interconnection`.`sgip_enrollment` ADD CONSTRAINT `fk_interconnection_sgip_enrollment_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`sgip_enrollment` DROP CONSTRAINT IF EXISTS `fk_interconnection_sgip_enrollment_sgip_der_system_id`;
ALTER TABLE `interconnection`.`sgip_enrollment` ADD CONSTRAINT `fk_interconnection_sgip_enrollment_sgip_der_system_id` FOREIGN KEY (`sgip_der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `interconnection`.`cost_responsibility` DROP CONSTRAINT IF EXISTS `fk_interconnection_cost_responsibility_interconnection_application_id`;
ALTER TABLE `interconnection`.`cost_responsibility` ADD CONSTRAINT `fk_interconnection_cost_responsibility_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`fee` DROP CONSTRAINT IF EXISTS `fk_interconnection_fee_application_id`;
ALTER TABLE `interconnection`.`fee` ADD CONSTRAINT `fk_interconnection_fee_application_id` FOREIGN KEY (`application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`fee` DROP CONSTRAINT IF EXISTS `fk_interconnection_fee_fee_application_id`;
ALTER TABLE `interconnection`.`fee` ADD CONSTRAINT `fk_interconnection_fee_fee_application_id` FOREIGN KEY (`fee_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`fee` DROP CONSTRAINT IF EXISTS `fk_interconnection_fee_fee_interconnection_application_id`;
ALTER TABLE `interconnection`.`fee` ADD CONSTRAINT `fk_interconnection_fee_fee_interconnection_application_id` FOREIGN KEY (`fee_interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`application_document` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_document_interconnection_application_id`;
ALTER TABLE `interconnection`.`application_document` ADD CONSTRAINT `fk_interconnection_application_document_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `interconnection`.`application_document` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_document_superseded_by_document_application_document_id`;
ALTER TABLE `interconnection`.`application_document` ADD CONSTRAINT `fk_interconnection_application_document_superseded_by_document_application_document_id` FOREIGN KEY (`superseded_by_document_application_document_id`) REFERENCES `interconnection`.`application_document` (`application_document_id`);

