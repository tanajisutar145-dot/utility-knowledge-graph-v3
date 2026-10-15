-- Utility CMM-aligned Canonical Data Model (Silver) v1.0.0 | source: Databricks lakehouse-industry-data-models energy_utilities v1 ECM | generated 2026-10-13
-- 13 | Subject area: outage | 25 tables | CIM packages: IEC61968::Operations; IEC61968::Customers
-- Standards: IEC 61968-3; IEEE 1366; MultiSpeak OD/OA; EEI Mutual Assistance
-- Contents: tables (with PK + NOT NULL), then intra-subject-area foreign keys.
-- Unity Catalog PK/FK constraints are informational (NOT ENFORCED); NOT NULL is enforced.

USE CATALOG `utility_cmm_silver`;

-- OutageEvent  <<CIM Outage : exact>>
CREATE TABLE IF NOT EXISTS `outage`.`event` (
  `event_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for each outage event record in the OMS. Primary key for the outage_event data product. Serves as the authoritative SSOT identity key for all downstream joins, lineage, and reporting.',
  `contingency_id` BIGINT COMMENT 'Foreign key linking to grid.contingency. Business justification: Outages may result from contingencies analyzed in advance (N-1, N-2 events). Linking enables post-event analysis comparing actual outage impacts vs. contingency analysis predictions for NERC complianc',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Outages within control areas impact ACE, CPS compliance, frequency response obligations, and NERC reporting. Control center operators need to track outage impacts on balancing authority performance me',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Storm restoration and emergency response costs are charged to specific cost centers for O&M expense tracking, FERC Form 1 reporting, and regulatory cost recovery filings. Standard utility financial pr',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_system. Business justification: Outage events must track DER involvement for root cause analysis, IEEE 1547 compliance verification, fault contribution assessment, and regulatory reporting. OMS systems routinely flag DER-related dis',
  `distribution_substation_id` BIGINT COMMENT 'Identifier of the substation from which the affected circuit originates. Used for substation-level outage aggregation, asset performance analysis, and transmission-to-distribution boundary reporting.',
  `emergency_response_plan_id` BIGINT COMMENT 'Foreign key linking to outage.emergency_response_plan. Business justification: Associate an outage event with the emergency response plan used for that event; many events can use the same plan.',
  `feeder_id` BIGINT COMMENT 'Identifier of the primary distribution circuit or feeder affected by the outage event, as maintained in the GIS (Esri ArcGIS Utility Network) and ADMS. Used for circuit-level reliability reporting, SAIDI/SAIFI aggregation, and feeder performance benchmarking.',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Outage events occur within forecast zones. Utilities track zone-level outage impacts for load forecast adjustments, reliability index calculations by zone, and regulatory reporting. OMS systems routin',
  `grid_switching_order_id` BIGINT COMMENT 'Foreign key linking to grid.grid_switching_order. Business justification: Planned outages require grid switching orders for safe de-energization. Linking enables coordination between OMS and EMS, ensuring switching plans align with outage schedules and customer notification',
  `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Major outage events (storms, major equipment failures) trigger internal orders to segregate restoration costs for insurance claims, PUC storm cost recovery proceedings, and FEMA reimbursement tracking',
  `isolation_device_id` BIGINT COMMENT 'Identifier of the primary switching or protective device (recloser, sectionalizer, fuse, breaker) used to isolate the fault and define the outage boundary. Sourced from GIS/ADMS network model. Used for FLISR (Fault Location, Isolation, and Service Restoration) analysis.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Outage events must be evaluated against regulatory obligations for NERC/PUC reportability. Compliance officers determine which outages trigger mandatory reporting under specific obligations (NERC EOP,',
  `reliability_index_period_id` BIGINT COMMENT 'Foreign key linking to outage.reliability_index_period. Business justification: Connect each outage event to its reporting period for reliability metrics; many events belong to one reliability_index_period.',
  `service_territory_id` BIGINT COMMENT 'Reference to the regulated service territory within which the outage occurred. Used for PUC regulatory reporting, territory-level reliability benchmarking, and rate case support.',
  `storm_event_id` BIGINT COMMENT 'Reference to the parent storm or severe weather event record when is_storm_event is True. Links individual outage events to the storm event for aggregate storm impact reporting and mutual aid cost tracking.',
  `work_order_id` BIGINT COMMENT 'Reference to the corrective maintenance or emergency repair work order created in the Asset Management system (Ventyx Asset Suite / SAP S/4HANA PM) to address the root cause of the outage. Links outage event to asset repair lifecycle.',
  `actual_restoration_timestamp` TIMESTAMP COMMENT 'The Actual Time of Restoration (ATR) — the confirmed timestamp when the last affected customer on this outage event was restored to service. Used as the authoritative end time for SAIDI/SAIFI/CAIDI duration calculations.',
  `affected_customers_commercial` INT COMMENT 'Number of commercial customer service points affected by this outage event. Subset of customers_affected_count. Used for commercial segment reliability reporting and economic impact estimation.',
  `affected_customers_industrial` INT COMMENT 'Number of industrial customer service points affected by this outage event. Subset of customers_affected_count. Used for industrial segment reliability reporting and large-customer impact notifications.',
  `affected_customers_residential` INT COMMENT 'Number of residential customer service points affected by this outage event. Subset of customers_affected_count. Used for customer class-level reliability reporting and equity analysis required by some state PUCs.',
  `caidi_minutes` DECIMAL(18,2) COMMENT 'The Customer Average Interruption Duration Index (CAIDI) for this outage event, representing the average restoration time experienced by affected customers. Calculated as total customer_minutes_interrupted divided by customers_affected_count. Stored at event level for benchmarking.',
  `call_count` INT COMMENT 'Total number of customer calls or trouble reports received and clustered to this outage event. Used to gauge customer impact severity, prioritize restoration, and assess IVR/call center load during storm events.',
  `cause_code` STRING COMMENT 'Standardized cause classification code assigned to the outage event upon investigation. Follows the IEEE 1366 cause code taxonomy (e.g., weather, equipment failure, animal contact, vegetation, human error, unknown). Reference-value candidates: weather|equipment_failure|animal_contact|vegetation|human_error|scheduled_maintenance|third_party|unknown.',
  `cause_description` STRING COMMENT 'Free-text narrative description of the root cause of the outage, as determined by field crew investigation or engineering analysis. Supplements the structured cause_code with operational detail.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the outage event record was first created in the OMS or Silver layer data product. Used for audit trail, data lineage, and SLA tracking of event creation latency.',
  `crew_dispatch_timestamp` TIMESTAMP COMMENT 'Timestamp when the first field crew was dispatched to the outage location. Used to measure dispatch response time (detection_timestamp to crew_dispatch_timestamp) as an operational KPI and for regulatory response time compliance.',
  `crew_on_site_timestamp` TIMESTAMP COMMENT 'Timestamp when the first field crew arrived on-site at the outage location. Used to measure crew travel time and assess field response performance against SLA targets.',
  `critical_facility_flag` BOOLEAN COMMENT 'Indicates whether the outage event affects one or more critical facilities (hospitals, emergency services, water treatment, telecommunications, or other life-safety infrastructure). True triggers elevated priority and mandatory regulatory notification protocols.',
  `customer_minutes_interrupted` DECIMAL(18,2) COMMENT 'Total customer minutes interrupted (CMI) contributed by this outage event, calculated as the sum of interruption duration (minutes) multiplied by customers affected for each restoration segment. Primary input to SAIDI (System Average Interruption Duration Index) calculation.',
  `customers_affected_count` INT COMMENT 'Total number of customer service points (meters) interrupted by this outage event at peak impact. Used as the primary customer impact metric for SAIFI calculation (interruptions per customer) and regulatory reporting to PUC.',
  `detection_source` STRING COMMENT 'The source or mechanism by which the outage was first detected. Supports analysis of detection method effectiveness and AMI/SCADA investment value. Values: ami_ping (AMI outage notification), scada_alarm (SCADA supervisory alarm), customer_call (inbound customer report), predictive_model (ML-based prediction), field_crew (crew observation), smart_meter_outage_notification (last gasp signal). Valid values: ami_ping|scada_alarm|customer_call|predictive_model|field_crew|smart_meter_outage_notification.',
  `detection_timestamp` TIMESTAMP COMMENT 'The principal real-world timestamp when the outage event was first detected or reported, regardless of detection source (AMI ping, SCADA alarm, customer call, or predictive model). This is the authoritative event start time used for SAIDI/SAIFI/CAIDI duration calculations per IEEE 1366.',
  `energy_not_served_mwh` DECIMAL(18,4) COMMENT 'Estimated energy not served (ENS) in MWh due to this outage event, calculated as the product of average load (MW) on the affected circuit and the outage duration (hours). Used for economic impact assessment, IRP planning, and regulatory reporting.',
  `estimated_restoration_timestamp` TIMESTAMP COMMENT 'The Estimated Time to Restoration (ETR) communicated to customers and field crews, representing the predicted date and time by which all affected customers will be restored. Updated dynamically as restoration progresses. Distinct from actual_restoration_timestamp.',
  `event_status` STRING COMMENT 'Current lifecycle status of the outage event within the OMS workflow. Transitions: new (detected, unworked) → in_progress (crew dispatched or switching underway) → restored (all customers re-energized) → closed (event verified and finalized) → cancelled (duplicate or false positive confirmed). Valid values: new|in_progress|restored|closed|cancelled.',
  `event_type` STRING COMMENT 'Classification of the outage event per IEEE 1366 definitions: sustained (interruption > 5 minutes), momentary (≤ 5 minutes), planned (scheduled maintenance), major_event_day (MED per IEEE 1366 beta method), or partial (affecting a subset of customers on a circuit). Reference-value candidates: sustained|momentary|planned|major_event_day|partial|rolling. Valid values: sustained|momentary|planned|major_event_day|partial.',
  `fault_location` STRING COMMENT 'Descriptive location of the fault or interruption point on the network (e.g., pole number, span identifier, address nearest to fault). Captured from field crew report or automated fault location indicator (FLI) in the ADMS.',
  `initial_call_receipt_timestamp` TIMESTAMP COMMENT 'Timestamp when the first customer call or report associated with this outage event was received by the Customer Information System (CIS) or IVR. Used for call clustering analysis and detection latency measurement.',
  `is_major_event_day` BOOLEAN COMMENT 'Indicates whether this outage event occurred on a day declared as a Major Event Day (MED) per the IEEE 1366 beta method. MED events are excluded from standard SAIDI/SAIFI calculations and reported separately to PUC. True = MED event; False = normal event.',
  `is_storm_event` BOOLEAN COMMENT 'Indicates whether this outage event was caused by or associated with a declared storm or severe weather event. Storm-flagged events may be subject to separate regulatory reporting thresholds and mutual aid activation criteria.',
  `isolation_method` STRING COMMENT 'Method by which the fault was isolated from the network: automatic (protective device operated automatically), manual (field crew operated device manually), remote (SCADA/ADMS remote switching), or flisr_automated (ADMS FLISR automation executed switching sequence). Valid values: automatic|manual|remote|flisr_automated.',
  `nerc_reportable_flag` BOOLEAN COMMENT 'Indicates whether this outage event meets NERC reporting thresholds (e.g., EOP-004 disturbance reporting criteria based on MW loss, customer count, or duration). True = event must be reported to NERC/DOE via OE-417 or equivalent.',
  `notification_sent_flag` BOOLEAN COMMENT 'Indicates whether automated customer outage notifications (IVR, SMS, email, or app push) have been sent for this outage event. True = at least one notification batch dispatched. Used for regulatory compliance tracking of customer communication requirements.',
  `notification_timestamp` TIMESTAMP COMMENT 'Timestamp when the first customer outage notification was dispatched for this event. Used to measure notification latency from detection and to demonstrate compliance with PUC customer communication time requirements.',
  `oms_event_code` STRING COMMENT 'The externally-known event identifier assigned by the Outage Management System (GE PowerOn ADMS). This is the operational business identifier used by field crews, dispatchers, and customer service representatives to reference the outage event across systems.',
  `predicted_cause_code` STRING COMMENT 'The cause code predicted by the OMS predictive model or ADMS fault analysis engine at the time of initial detection, before field crew investigation. Compared against final cause_code for model accuracy tracking. Reference-value candidates: weather|equipment_failure|animal_contact|vegetation|human_error|unknown.',
  `predicted_customers_affected` INT COMMENT 'The number of customers predicted to be affected by the outage at the time of initial detection, as estimated by the OMS/ADMS predictive model. Compared against actual customers_affected_count for model accuracy and ETR calibration.',
  `prediction_confidence_score` DECIMAL(5,2) COMMENT 'Confidence score (0.00–100.00) assigned by the predictive model or ADMS fault analysis engine to the initial outage prediction, including predicted cause and affected scope. Used to assess model reliability and calibrate automated dispatch thresholds.',
  `priority_level` STRING COMMENT 'Restoration priority classification assigned to the outage event, used to sequence crew dispatch and switching operations. Critical: hospitals, emergency services, critical infrastructure; High: large commercial/industrial, high customer count; Medium: standard residential; Low: single-customer or non-critical. Valid values: critical|high|medium|low.',
  `puc_reportable_flag` BOOLEAN COMMENT 'Indicates whether this outage event meets the state Public Utility Commission (PUC) threshold for mandatory individual event reporting (e.g., exceeds customer count or duration thresholds defined in the utility\'s tariff or service quality rules).',
  `reported_symptom` STRING COMMENT 'The primary symptom reported by the first customer caller or detected by the AMI/SCADA system at the time of initial report. Used for triage, cause hypothesis, and crew dispatch guidance. Valid values: no_power|flickering|partial_power|low_voltage|high_voltage|other.',
  `saidi_contribution_minutes` DECIMAL(18,4) COMMENT 'This event\'s contribution to the System Average Interruption Duration Index (SAIDI), expressed in customer-minutes per total customers served. Calculated as customer_minutes_interrupted divided by total customers served in the reporting period. Stored at event level for regulatory period aggregation.',
  `saifi_contribution` DECIMAL(18,6) COMMENT 'This event\'s contribution to the System Average Interruption Frequency Index (SAIFI), expressed as customer interruptions per total customers served. Calculated as customers_affected_count divided by total customers served. Stored at event level for regulatory period aggregation.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the outage event record. Supports change detection, incremental ETL processing, and audit compliance.',
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
  CONSTRAINT `pk_outage_event` PRIMARY KEY (`event_id`)
)
USING DELTA
COMMENT 'Core master record for every unplanned or planned power interruption event managed by the OMS. Captures the full lifecycle from initial detection (via AMI ping, SCADA alarm, customer call clustering, or predictive model) through final restoration. Includes cause classification, outage type (sustained, momentary, planned, major event per IEEE 1366), affected circuit/feeder, estimated vs. actual restoration time (ETR/ATR), initial prediction metadata (source, confidence, predicted scope, predicted cause, predicted affected segments), source call/report metadata (call receipt timestamp, source type, reported symptom, call disposition, duplicate flag, call clustering results), lifecycle status transitions with full audit trail (status code, transition timestamp, triggering actor, status notes), affected network segment detail (segment identifier, type, de-energization timestamps, isolation method, customer count, restoration sequence priority), SAIDI/SAIFI/CAIDI contribution, storm flag, Major Event Day declaration status, and OMS event identifier. This is the authoritative SSOT for outage event identity, lifecycle, initial prediction, source reporting, status history, and segment-level impact in the outage domain. | CMM: CIM Outage (exact), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'OutageEvent',
  'cmm.cim.class' = 'Outage',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.event',
  'cmm.gis.location.role' = 'Incident.Location'
);

-- CustomerInterruption  <<CIM Outage : broad>>
CREATE TABLE IF NOT EXISTS `outage`.`interruption` (
  `interruption_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for a single customer or premise-level service interruption record. Primary key for this entity.',
  `account_id` BIGINT COMMENT 'Reference to the customer account associated with the interrupted service point at the time of the interruption. Supports customer-facing outage communication and regulatory customer impact reporting.',
  `ami_meter_id` BIGINT COMMENT 'The AMI meter identifier associated with the service point at the time of the interruption. Used to correlate last-gasp and first-breath AMI signals from the MDM system for automated interruption detection and restoration confirmation.',
  `billing_service_agreement_id` BIGINT COMMENT 'Foreign key linking to billing.billing_service_agreement. Business justification: Individual customer interruptions require service agreement context to apply correct credit calculation rules based on rate schedule, service class, and contractual SLA terms. Enables automated credit',
  `distribution_substation_id` BIGINT COMMENT 'Reference to the substation serving the affected service point at the time of the interruption. Supports substation-level reliability performance reporting and outage root cause analysis.',
  `event_id` BIGINT COMMENT 'Reference to the parent outage event that caused this customer-level interruption. Links the granular interruption record to the broader outage event for SAIDI/SAIFI/CAIDI roll-up calculations.',
  `feeder_id` BIGINT COMMENT 'Reference to the distribution feeder circuit that serves the affected service point. Supports feeder-level reliability analysis, SAIDI/SAIFI benchmarking by circuit, and GIS-based outage mapping.',
  `interruption_planned_outage_window_id` BIGINT COMMENT 'Reference to the planned maintenance window associated with this interruption, when applicable. Null for unplanned outages. Links to the planned outage schedule for customer notification and regulatory reporting.',
  `outage_crew_dispatch_id` BIGINT COMMENT 'Reference to the field crew dispatch record associated with the restoration of this interruption. Links to workforce management for crew response time analysis and restoration efficiency reporting.',
  `outage_switching_order_id` BIGINT COMMENT 'Reference to the switching order executed to isolate or restore the affected circuit segment. Links the customer-level interruption to the operational switching workflow in the ADMS/OMS.',
  `service_point_id` BIGINT COMMENT 'Reference to the specific service delivery point (meter point or premise connection) that experienced the interruption. The fundamental unit of interruption tracking per IEEE 1366.',
  `to_planned_outage_window_id` BIGINT COMMENT 'FK to outage.planned_outage_window.planned_outage_window_id — Customer interruptions from planned maintenance link to the planned outage window. Required for distinguishing planned vs unplanned interruptions in reliability reporting.',
  `cause_code` STRING COMMENT 'Standardized code identifying the primary cause of the service interruption (e.g., weather, equipment failure, animal contact, vegetation, scheduled maintenance, third-party damage). Aligned with IEEE 1366 cause categories and OMS cause code taxonomy. Reference-value candidates: weather|equipment_failure|animal_contact|vegetation|scheduled_maintenance|third_party_damage|unknown|human_error|overload|lightning.',
  `cause_description` STRING COMMENT 'Free-text narrative description of the specific cause of the interruption, supplementing the standardized cause_code with field crew observations, dispatcher notes, or automated OMS event descriptions.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this interruption record was first created in the system, either by automated OMS event processing or manual dispatcher entry. Supports audit trail and data lineage requirements.',
  `critical_care_type` STRING COMMENT 'Specific category of critical care designation for the affected customer. Used to prioritize restoration sequencing and determine notification requirements. Only populated when is_critical_care is true. Valid values: medical_baseline|life_support|dialysis|oxygen_dependent|none.',
  `customer_class` STRING COMMENT 'Classification of the affected customer by service class at the time of the interruption. Used for segmented SAIDI/SAIFI/CAIDI reporting by customer class as required by state PUC reliability standards and NERC reporting. Valid values: residential|commercial|industrial|agricultural|government.',
  `customers_affected_count` INT COMMENT 'Number of customers affected by the parent outage event at the time this interruption record was created. Denormalized from the outage event for regulatory reporting convenience. Used in SAIFI numerator calculations and NERC/PUC customer impact reporting.',
  `data_quality_flag` STRING COMMENT 'Indicates the data quality status of this interruption record as assessed during Silver layer validation. \'validated\' indicates all timestamps and durations are confirmed; \'estimated\' indicates one or more fields are estimated; \'suspect\' indicates anomalies detected; \'corrected\' indicates the record has been manually revised post-initial capture. Valid values: validated|estimated|suspect|corrected.',
  `duration_minutes` INT COMMENT 'Total duration of the service interruption in whole minutes, calculated as the difference between interruption_end_timestamp and interruption_start_timestamp. Stored as a business field to support SAIDI and CAIDI reliability index calculations without requiring real-time computation. Null if interruption is still active.',
  `end_timestamp` TIMESTAMP COMMENT 'Date and time when the customer\'s service was restored, recorded to millisecond precision. Null if the interruption is still active. Used as the end point for duration calculations and CAIDI index computation per IEEE 1366.',
  `estimated_restoration_timestamp` TIMESTAMP COMMENT 'Estimated date and time of service restoration communicated to the customer and used for crew scheduling. Distinct from interruption_end_timestamp (actual restoration). Supports customer communication accuracy tracking and ETR (Estimated Time to Restore) performance measurement.',
  `interruption_status` STRING COMMENT 'Current lifecycle state of the interruption record. \'active\' indicates the customer is currently without power; \'restored\' indicates service has been re-energized; \'cancelled\' indicates the interruption was logged in error; \'pending_confirmation\' indicates restoration has been initiated but field confirmation is outstanding. Valid values: active|restored|cancelled|pending_confirmation.',
  `interruption_type` STRING COMMENT 'Classification of the interruption as planned (scheduled maintenance), unplanned (forced outage), or momentary (duration less than 5 minutes per IEEE 1366 definition). Drives separate SAIDI/SAIFI/MAIFI index tracking and regulatory reporting segmentation. Valid values: planned|unplanned|momentary.',
  `is_critical_care` BOOLEAN COMMENT 'Indicates whether the affected customer or premise is designated as a critical care account (medical baseline, life support equipment, or other medically vulnerable designation). Critical care customers receive priority restoration and mandatory advance notification under state PUC rules.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this interruption record was most recently modified, including status updates, restoration confirmation, or cause code revisions. Supports change tracking and Silver layer incremental processing.',
  `major_event_day_exclusion` BOOLEAN COMMENT 'Indicates whether this interruption has been formally excluded from the standard SAIDI/SAIFI reliability index calculations under the IEEE 1366 Major Event Day beta method. Distinct from storm_event_flag — this is the formal regulatory exclusion determination.',
  `momentary_flag` BOOLEAN COMMENT 'Indicates whether this interruption qualifies as a momentary interruption (duration less than 5 minutes per IEEE 1366 definition). Momentary interruptions are tracked separately for MAIFI (Momentary Average Interruption Frequency Index) calculations.',
  `notification_channel` STRING COMMENT 'Communication channel used to deliver the outage notification to the affected customer. Supports multi-channel notification analytics and customer preference compliance reporting. Valid values: sms|email|ivr|mobile_app|none.',
  `notification_opt_out` BOOLEAN COMMENT 'Indicates whether the customer has opted out of outage notifications for this service point. When true, notification_sent will be false by design. Supports customer preference management and regulatory opt-out compliance.',
  `notification_sent` BOOLEAN COMMENT 'Indicates whether an outage notification has been sent to the affected customer for this interruption. Supports regulatory compliance tracking for customer notification requirements mandated by state PUCs.',
  `notification_timestamp` TIMESTAMP COMMENT 'Date and time when the outage notification was dispatched to the customer. Used to measure notification lead time relative to interruption start and to demonstrate regulatory compliance with advance notice requirements for planned outages.',
  `oms_event_number` STRING COMMENT 'The externally-known event number assigned by the Outage Management System (GE PowerOn ADMS) to the parent outage event. Serves as the cross-system integration key for reconciliation between OMS, CIS, and MDM systems.',
  `protective_device_operation` STRING COMMENT 'Type of protective device that operated to isolate the fault causing this interruption. Supports equipment performance analysis, recloser operation tracking, and fuse-saving vs. trip-and-reclose strategy evaluation. Valid values: fuse|recloser|breaker|sectionalizer|none.',
  `reference_number` STRING COMMENT 'Externally visible alphanumeric reference number assigned to this interruption record, used in customer communications, regulatory filings, and OMS integration. Format: INT-YYYY-NNNNNNNN. Pattern: ^INT-[0-9]{4}-[0-9]{8}$.',
  `regulatory_reportable` BOOLEAN COMMENT 'Indicates whether this interruption must be included in regulatory reliability reports submitted to NERC, FERC, or state PUCs. Interruptions below minimum duration thresholds or excluded under MED rules may be flagged as non-reportable.',
  `restoration_confirmation_method` STRING COMMENT 'Method by which service restoration was confirmed. AMI ping uses Advanced Metering Infrastructure last-gasp/first-breath signals; field_crew indicates on-site verification; customer_callback indicates customer-reported restoration; scada indicates SCADA system re-energization signal; estimated indicates restoration assumed based on switching operations. Valid values: ami_ping|field_crew|customer_callback|scada|estimated.',
  `restoration_confirmed` BOOLEAN COMMENT 'Indicates whether service restoration has been confirmed for this interruption, either through AMI meter ping, field crew confirmation, or customer callback. Distinguishes between estimated restoration and verified restoration for CAIDI accuracy.',
  `restoration_method` STRING COMMENT 'Method used to restore service to the affected customer or premise. Supports operational analysis of restoration efficiency and crew dispatch effectiveness. Reference-value candidates: switching|repair|bypass|auto_reclosure|manual_transfer|temporary_generation. Valid values: switching|repair|bypass|auto_reclosure|manual_transfer|temporary_generation.',
  `saidi_contribution_minutes` DECIMAL(10,4) COMMENT 'This interruption\'s individual contribution to the SAIDI reliability index, expressed in customer-minutes divided by total customers served. Stored as a pre-computed business field to support regulatory reporting aggregation without requiring full recalculation. Null if interruption is active or excluded from SAIDI.',
  `service_territory_code` STRING COMMENT 'Code identifying the regulated service territory within which the interrupted service point is located. Used for jurisdictional segmentation of reliability reporting across multiple state PUC regulatory boundaries.',
  `source_system` STRING COMMENT 'Identifies the operational system of record from which this interruption record originated. Supports data lineage, reconciliation, and Silver layer provenance tracking across OMS, CIS, and MDM source systems. Valid values: GE_PowerOn_ADMS|Oracle_CC&B|SAP_ISU|Oracle_MDM|manual.',
  `start_timestamp` TIMESTAMP COMMENT 'Date and time when the customer\'s service interruption began, recorded to millisecond precision. This is the principal business event timestamp used as the start point for duration calculations and SAIDI/SAIFI index computation per IEEE 1366.',
  `storm_event_flag` BOOLEAN COMMENT 'Indicates whether this interruption occurred during a declared major event or storm. When true, the interruption may be excluded from IEEE 1366 Major Event Day (MED) calculations per the beta method, affecting SAIDI/SAIFI index reporting.',
  `to_outage_event` BIGINT COMMENT 'FK to outage.outage_event.outage_event_id — Every customer-level interruption must link to its parent outage event. This is the foundational relationship for SAIDI/SAIFI/CAIDI calculation — without it, reliability indices cannot be computed. Da',
  `voltage_level` STRING COMMENT 'Voltage classification of the circuit segment at which the interruption originated. Used to segment reliability reporting by voltage class and to identify transmission vs. distribution-level outage impacts for FERC and state PUC reporting. Valid values: transmission|subtransmission|primary_distribution|secondary_distribution.',
  `weather_condition` STRING COMMENT 'Prevailing weather condition at the time and location of the interruption. Used for weather-normalized reliability analysis, storm response performance reporting, and climate resilience planning. Reference-value candidates: clear|wind|ice|snow|lightning|flood|extreme_heat|none.',
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
  CONSTRAINT `pk_outage_interruption` PRIMARY KEY (`interruption_id`)
)
USING DELTA
COMMENT 'Granular record of a single customer or premise-level service interruption linked to a parent outage event or planned maintenance window. Tracks the specific service point, customer account reference, interruption start and end timestamps, duration in minutes, cause code, restoration method (switching, repair, bypass), planned/unplanned flag, notification sent flag, notification channel, critical care designation (medical baseline, life support), restoration confirmation, and association to planned maintenance windows. Also serves as the customer-outage association record capturing per-customer impact including notification delivery status and opt-out preferences. This is the single SSOT for ALL customer-level outage impact — feeds SAIDI, SAIFI, and CAIDI reliability index calculations, supports customer-facing outage communication, drives regulatory customer impact reporting, and provides the definitive record of which customers were affected by each event. | CMM: CIM Outage (broad), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CustomerInterruption',
  'cmm.cim.class' = 'Outage',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.interruption',
  'cmm.gis.location.role' = 'Incident.Location'
);

-- OutageSwitchingOrder  <<CIM SwitchingPlan : exact>>
CREATE TABLE IF NOT EXISTS `outage`.`outage_switching_order` (
  `outage_switching_order_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for the switching order record in the Silver Layer lakehouse. Primary key for this entity.',
  `affected_feeder_id` BIGINT COMMENT 'Identifier of the primary distribution feeder circuit affected by this switching order. Used for network topology analysis, outage impact assessment, and GIS integration with Esri ArcGIS Utility Network.',
  `approver_employee_id` BIGINT COMMENT 'Reference to the supervisor or operations manager who approved this switching order prior to execution. Supports the approval chain audit trail.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Switching orders affect control area operations (state estimation, interchange schedules, AGC). EMS operators coordinate switching with field crews to maintain system reliability and balancing authori',
  `crew_id` BIGINT COMMENT 'Reference to the field crew assigned to execute this switching order. Used for crew dispatch tracking and post-event analysis.',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_system. Business justification: Switching orders require DER isolation verification before energization per IEEE 1547 and utility operating procedures. Operators must confirm DER status (online/offline/isolated) before executing swi',
  `distribution_substation_id` BIGINT COMMENT 'Reference to the substation from which the affected feeder originates or where the primary switching devices are located. Used for geographic scoping and asset management integration.',
  `event_id` BIGINT COMMENT 'Reference to the parent outage event that triggered this switching order. Links the switching sequence to the originating interruption or planned maintenance event in the Outage Management System (OMS).',
  `grid_switching_order_id` BIGINT COMMENT 'Foreign key linking to grid.grid_switching_order. Business justification: Outage switching orders may reference or be coordinated with grid switching orders for transmission-connected substations. Linking enables cross-system switching coordination and safety compliance.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Switching orders on critical infrastructure require compliance documentation under NERC CIP or operational reliability standards. Operations must document adherence to switching protocols mandated by',
  `primary_outage_employee_id` BIGINT COMMENT 'Reference to the control room dispatcher who issued and authorized this switching order. Required for NERC compliance audit trail.',
  `actual_customers_affected` INT COMMENT 'The confirmed number of customer service points that were interrupted as a result of this switching order, validated post-restoration. Used for SAIDI/SAIFI/CAIDI reliability metric calculation and regulatory reporting to State PUCs.',
  `actual_end_timestamp` TIMESTAMP COMMENT 'The actual date and time when the final switching step was completed and the switching order was closed. Used for outage duration calculation and SAIDI/SAIFI/CAIDI reliability performance reporting.',
  `actual_start_timestamp` TIMESTAMP COMMENT 'The actual date and time when the field crew began executing the first step of the switching sequence. Used for SAIDI/SAIFI/CAIDI reliability metric calculation and post-event analysis.',
  `adms_switching_order_ref` STRING COMMENT 'The native switching order identifier assigned by the GE PowerOn Advanced Distribution Management System (ADMS). Used for cross-system reconciliation between the Silver Layer lakehouse and the operational ADMS source system.',
  `approval_chain_notes` STRING COMMENT 'Free-text notes documenting the approval chain for this switching order, including any conditional approvals, escalations, or deviations from standard authorization procedures. Supports NERC compliance audit trail.',
  `approved_timestamp` TIMESTAMP COMMENT 'The date and time when the switching order received final authorization from the approving supervisor or operations manager. Part of the approval chain audit trail required for NERC compliance.',
  `cancellation_reason` STRING COMMENT 'Free-text explanation of why this switching order was cancelled, if applicable. Populated only when order_status is \'cancelled\'. Supports post-event analysis and process improvement.',
  `completed_steps_count` INT COMMENT 'The number of individual switching steps that have been successfully executed and confirmed as of the last update. Enables real-time progress monitoring during active switching operations.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this switching order record was first created in the system, which may precede the issued timestamp if the order was drafted in advance. Used for audit trail and data lineage.',
  `customer_notification_sent_flag` BOOLEAN COMMENT 'Indicates whether advance customer notification was sent for this switching order (applicable to planned outages). Supports compliance tracking against State PUC advance notification requirements, typically 48-72 hours prior to planned interruption.',
  `de_energization_timestamp` TIMESTAMP COMMENT 'The date and time when the affected network segment was de-energized (taken out of service) as part of this switching order. Critical for outage duration measurement and SAIDI calculation start point.',
  `energization_timestamp` TIMESTAMP COMMENT 'The date and time when the affected network segment was re-energized (returned to service) following completion of the switching sequence. Marks the end of the customer interruption for SAIDI/CAIDI calculation.',
  `estimated_customers_affected` INT COMMENT 'The estimated number of customer service points that will be or are interrupted as a result of this switching order. Used for customer notification prioritization, regulatory reporting, and SAIFI calculation inputs.',
  `hazard_notes` STRING COMMENT 'Free-text field capturing known hazards, special safety precautions, or environmental conditions relevant to executing this switching order. Examples include downed conductors, flooded equipment, or proximity to energized lines. Mandatory review by crew before execution.',
  `issued_timestamp` TIMESTAMP COMMENT 'The date and time when the dispatcher formally issued this switching order to the field crew. This is the principal business event timestamp marking the start of the switching order lifecycle. Recorded in ISO 8601 format with timezone offset.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this switching order record was most recently modified. Tracks any changes to the order after initial creation, supporting audit trail requirements.',
  `nerc_reportable_flag` BOOLEAN COMMENT 'Indicates whether this switching order is associated with an event that meets NERC reportability thresholds (e.g., EOP-004 disturbance reporting). When True, the event must be included in mandatory NERC regulatory submissions.',
  `network_segment_description` STRING COMMENT 'Human-readable description of the distribution or transmission network segment affected by this switching order, including feeder name, circuit section, and geographic reference. Supports field crew orientation and post-event reporting.',
  `oms_incident_number` STRING COMMENT 'The incident or trouble call number from the Outage Management System (OMS) associated with this switching order. Enables traceability from the switching sequence back to the originating customer-reported outage or system-detected fault.',
  `order_status` STRING COMMENT 'Current lifecycle state of the switching order. Tracks progression from initial drafting through dispatcher issuance, field execution, and final completion or cancellation. Drives workflow routing in GE PowerOn ADMS. Valid values: draft|issued|in_progress|completed|cancelled|suspended.',
  `order_type` STRING COMMENT 'Classification of the switching order by operational purpose. Distinguishes planned maintenance windows from emergency outage restoration, storm response, load transfer operations, and asset commissioning/decommissioning activities. Reference-value candidates: planned_maintenance|emergency_restoration|storm_response|load_transfer|commissioning|decommissioning. Valid values: planned_maintenance|emergency_restoration|storm_response|load_transfer|commissioning|decommissioning.',
  `planned_outage_flag` BOOLEAN COMMENT 'Indicates whether this switching order is associated with a planned (scheduled) outage as opposed to an unplanned (forced) interruption. Planned outages are tracked separately for SAIDI/SAIFI reporting and customer advance notification compliance.',
  `post_event_review_flag` BOOLEAN COMMENT 'Indicates whether this switching order has been flagged for mandatory post-event review, typically triggered by NERC reportable events, major storm response, or switching errors. Drives the post-event analysis workflow.',
  `post_event_review_notes` STRING COMMENT 'Free-text findings and corrective actions documented during the post-event review of this switching order. Populated after review completion when post_event_review_flag is True. Supports continuous improvement and regulatory compliance.',
  `priority_level` STRING COMMENT 'Operational priority assigned to this switching order, used for restoration prioritization and crew dispatch sequencing. Critical priority is reserved for transmission-level or large-scale customer impact events. Valid values: critical|high|medium|low.',
  `restoration_method` STRING COMMENT 'The method used to restore service as part of this switching order. Distinguishes manual field crew switching from automated ADMS-driven Fault Location, Isolation, and Service Restoration (FLISR), remote switching via SCADA, sectionalizing, or load transfer to alternate feeders. Valid values: manual|automatic_flisr|remote_switching|sectionalizing|load_transfer.',
  `safety_clearance_number` STRING COMMENT 'The reference number of the safety clearance (hold tag or clearance order) associated with this switching order. Ensures that de-energized equipment is properly tagged and locked out before crew work begins. Mandatory for OSHA lockout/tagout compliance. Pattern: ^CLR-[0-9]{4}-[0-9]{6}$.',
  `scheduled_end_timestamp` TIMESTAMP COMMENT 'The planned date and time by which the switching sequence is expected to be completed and the network restored to target configuration. Used for outage duration estimation and customer notification.',
  `scheduled_start_timestamp` TIMESTAMP COMMENT 'The planned date and time for field crew to begin executing the switching sequence. Used for planned maintenance scheduling and crew coordination. May differ from actual execution start time.',
  `storm_event_flag` BOOLEAN COMMENT 'Indicates whether this switching order was issued in response to a major storm or declared emergency event. When True, the associated outage duration may be excluded from IEEE Std 1366 SAIDI/SAIFI calculations per major event day (MED) criteria.',
  `suspension_reason` STRING COMMENT 'Free-text explanation of why this switching order was suspended mid-execution, if applicable. Populated only when order_status is \'suspended\'. Common reasons include unexpected hazards, equipment failure, or crew safety concerns.',
  `switching_order_number` STRING COMMENT 'Externally-known alphanumeric identifier for the switching order, used by dispatchers, field crews, and control room operators. Format: SO-{YYYY}-{NNNNNN}. This is the business-facing reference number used in OMS and ADMS systems. Pattern: ^SO-[0-9]{4}-[0-9]{6}$.',
  `switching_purpose_description` STRING COMMENT 'Free-text description of the operational reason for issuing this switching order, including the specific fault, maintenance activity, or load transfer objective. Provides context beyond the structured order_type classification.',
  `switching_zone` STRING COMMENT 'The operational control zone or dispatch territory within which this switching order is executed. Aligns with the utility\'s geographic service territory divisions used for crew dispatch and reliability performance reporting.',
  `total_steps_count` INT COMMENT 'The total number of individual switching steps defined in this switching order sequence. Used for progress tracking and completeness validation during execution.',
  `version` INT COMMENT 'Version number of this switching order, incremented each time the order is revised after initial issuance. Supports audit trail requirements and ensures field crews are executing the most current approved version of the switching sequence.',
  `voltage_level_kv` DECIMAL(10,3) COMMENT 'The nominal operating voltage level in kilovolts (kV) of the network segment affected by this switching order. Determines applicable safety procedures, crew qualifications, and regulatory requirements.',
  `work_order_number` STRING COMMENT 'Reference to the associated maintenance or repair work order in the asset management system (Ventyx Asset Suite or SAP S/4HANA Plant Maintenance). Links the switching order to the underlying maintenance activity that necessitated the switching sequence.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_outage_outage_switching_order` PRIMARY KEY (`outage_switching_order_id`)
)
USING DELTA
COMMENT 'Formal switching order issued during outage restoration or planned maintenance to reconfigure the distribution network. Captures the complete switching sequence including individual step detail (step sequence number, device identifier, device type, action type — open/close/tag/verify, required safety state, completion status, actual execution timestamp, executing crew member). Also records issuing dispatcher, executing crew, affected switching devices (sectionalizers, reclosers, breakers), safety clearance references, energization/de-energization timestamps, and approval chain. Supports granular audit trail of switching sequences for NERC compliance and post-event analysis. Integrates with GE PowerOn ADMS switching management module. | CMM: CIM SwitchingPlan (exact), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'OutageSwitchingOrder',
  'cmm.cim.class' = 'SwitchingPlan',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.outage_switching_order'
);

-- OutageSwitchingStep  <<CIM SwitchingAction : exact>>
CREATE TABLE IF NOT EXISTS `outage`.`outage_switching_step` (
  `outage_switching_step_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for each individual step within a switching order. Primary key for the outage_switching_step entity in the Silver Layer lakehouse.',
  `crew_id` BIGINT COMMENT 'Reference to the field crew unit dispatched to execute this switching step. A crew may execute multiple steps across one or more switching orders. Used for crew workload tracking and dispatch optimization.',
  `device_asset_registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: Switching steps operate on physical distribution assets (circuit breakers, reclosers, sectionalizers, switches). Linking to asset_registry enables maintenance history correlation, asset condition trac',
  `device_id` BIGINT COMMENT 'Reference to the specific switchable grid device (breaker, recloser, disconnect switch, sectionalizer, fuse, capacitor bank, or regulator) targeted by this switching step. Sourced from the GIS network model.',
  `distribution_substation_id` BIGINT COMMENT 'Reference to the substation associated with the target device. Supports substation-level switching activity reporting, transformer loading analysis, and geographic outage impact assessment.',
  `event_id` BIGINT COMMENT 'Reference to the outage event (planned or unplanned) that this switching step is associated with. Links the granular switching activity to the broader outage lifecycle for SAIDI/SAIFI/CAIDI reporting and OMS event correlation.',
  `feeder_id` BIGINT COMMENT 'Reference to the distribution feeder circuit on which the target device resides. Enables feeder-level aggregation of switching activity for reliability performance reporting and load management analysis.',
  `outage_switching_order_id` BIGINT COMMENT 'Reference to the parent switching order that contains this step. Establishes the header-to-line relationship between the switching order and its individual device operation steps.',
  `primary_outage_employee_id` BIGINT COMMENT 'Reference to the qualified crew member who physically performed this switching step. Required for NERC compliance audit trail and post-event accountability. Must be a certified switching operator per utility qualification standards.',
  `protection_device_id` BIGINT COMMENT 'Reference to the protective relay associated with the target device for this switching step. Relevant for steps involving circuit breakers where relay coordination must be verified before switching. Supports protection coordination analysis.',
  `scada_point_id` BIGINT COMMENT 'Foreign key linking to grid.scada_point. Business justification: Switching steps operate devices monitored by SCADA points. Linking enables remote verification of device status, automated switching validation, and ADMS/OMS integration for coordinated switching.',
  `work_order_id` BIGINT COMMENT 'Reference to the maintenance or construction work order in the asset management system that necessitated this switching step. Links switching activity to planned maintenance work for O&M cost tracking and asset lifecycle management.',
  `action_type` STRING COMMENT 'The discrete device operation to be performed in this switching step. \'Open\' de-energizes a circuit segment; \'Close\' re-energizes; \'Tag\' applies a hold tag for safety isolation; \'Verify\' confirms device state without operating it; \'Ground\' applies protective grounding; \'De-energize\'/\'Energize\' for non-switching state changes. Reference-value candidates: open|close|tag|verify|ground|de-energize|energize.',
  `actual_duration_minutes` INT COMMENT 'Actual time in minutes taken to execute this switching step, calculated from actual_execution_timestamp to completion_timestamp. Used for switching performance benchmarking, crew efficiency analysis, and future switching order planning.',
  `actual_execution_timestamp` TIMESTAMP COMMENT 'Actual date and time at which this switching step was physically executed in the field, expressed in ISO 8601 format with timezone offset. Critical for NERC compliance audit trails, SAIDI/SAIFI/CAIDI reliability metric calculation, and post-event analysis.',
  `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this switching step received formal authorization from the control room operator or switching supervisor. Distinct from created_timestamp (authoring) and actual_execution_timestamp (field execution). Required for NERC compliance audit trail.',
  `clearance_number` STRING COMMENT 'Safety clearance authorization number issued by the control room for this switching step. Required for high-voltage operations and provides the formal authorization reference linking the field operation to the control room approval record.',
  `completion_notes` STRING COMMENT 'Free-text field for the executing crew member to record observations, anomalies, or deviations encountered during step execution. Captured at time of completion and preserved for post-event analysis and NERC compliance documentation.',
  `completion_timestamp` TIMESTAMP COMMENT 'Date and time at which the step was confirmed complete and the result was recorded in the OMS. May differ from actual_execution_timestamp if there is a delay between physical execution and system confirmation (e.g., radio communication lag or SCADA confirmation delay).',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this switching step record was first created in the OMS/ADMS system. Establishes the audit trail start point for the step lifecycle. Expressed in ISO 8601 format with timezone offset.',
  `customers_affected_count` INT COMMENT 'Number of end-use customers whose service is interrupted or restored as a direct result of this switching step. Used in real-time SAIDI/SAIFI/CAIDI calculation and customer notification prioritization. Derived from the network topology model at time of execution.',
  `device_state_after` STRING COMMENT 'Confirmed state of the target device immediately after this switching step was executed. Verified by the executing crew member and/or SCADA telemetry. Used to confirm successful execution and update the real-time network model. Valid values: open|closed|tagged|grounded|unknown.',
  `device_state_before` STRING COMMENT 'Confirmed state of the target device immediately before this switching step was executed (e.g., \'open\', \'closed\', \'tagged\'). Verified by the executing crew member and recorded for audit trail integrity and post-event sequence reconstruction. Valid values: open|closed|tagged|grounded|unknown.',
  `device_type` STRING COMMENT 'Classification of the switchable device targeted by this step. Determines applicable safety procedures, required PPE, and permissible action types. Reference-value candidates: circuit_breaker|disconnect_switch|recloser|sectionalizer|fuse|capacitor_bank|voltage_regulator.',
  `estimated_duration_minutes` INT COMMENT 'Planned duration in minutes for executing this switching step, as estimated during switching order planning. Used for outage window scheduling, crew time allocation, and customer notification of expected restoration times.',
  `failure_reason` STRING COMMENT 'Documented reason why this switching step failed to execute successfully. Populated only when step_status is \'failed\'. Used for root cause analysis, equipment reliability tracking, and corrective action planning.',
  `hazard_description` STRING COMMENT 'Free-text description of the specific hazard condition identified at the device location. Populated only when hazard_flag is True. Provides field crew with critical safety information before approaching the device.',
  `hazard_flag` BOOLEAN COMMENT 'Indicates whether a known hazard condition (e.g., downed conductor, flooded equipment, damaged structure) has been identified at the device location for this step. When True, additional safety precautions and supervisor approval are required before execution.',
  `hold_tag_number` STRING COMMENT 'Physical hold tag or clearance tag number applied to the device as part of a lockout/tagout (LOTO) procedure for this switching step. Required for \'tag\' action types. Provides traceability between the physical safety tag and the digital switching record.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this switching step record was most recently modified. Tracks the latest change to step details, status, or execution data. Used for data lineage, change detection in ETL pipelines, and audit compliance.',
  `load_transferred_mw` DECIMAL(10,3) COMMENT 'Estimated or measured electrical load in megawatts (MW) transferred as a result of this switching step. Relevant for load transfer switching operations during outage restoration. Used for grid loading analysis and post-event load flow validation.',
  `nerc_reportable` BOOLEAN COMMENT 'Indicates whether this switching step is part of a switching sequence that must be reported to NERC under applicable reliability standards (e.g., FAC-001, FAC-002, or CIP standards). Drives automated regulatory reporting workflows.',
  `oms_step_reference` STRING COMMENT 'Native step identifier from the source Outage Management System (GE PowerOn ADMS) for this switching step record. Enables bidirectional traceability between the Silver Layer data product and the operational OMS for reconciliation and audit purposes.',
  `planned_execution_timestamp` TIMESTAMP COMMENT 'Scheduled date and time at which this switching step is planned to be executed, expressed in ISO 8601 format with timezone offset. Used for crew scheduling, outage window coordination, and customer notification timing.',
  `remote_operated` BOOLEAN COMMENT 'Indicates whether this switching step was executed remotely via SCADA/ADMS control (True) or required physical field crew intervention (False). Supports FLISR (Fault Location Isolation and Service Restoration) automation performance tracking and remote switching capability analytics.',
  `required_safety_state` STRING COMMENT 'Mandatory pre-condition safety state that the device or circuit segment must be in before this step can be executed. Enforces OSHA lockout/tagout (LOTO) and NERC safety rule compliance. Field crew must verify this state before proceeding. Valid values: de-energized|grounded|tagged_out|isolated|energized|any.',
  `scada_confirmation_timestamp` TIMESTAMP COMMENT 'Date and time at which SCADA telemetry confirmed the device state change for this switching step. Populated only when scada_confirmed is True. Used to measure SCADA response latency and validate field execution timing.',
  `scada_confirmed` BOOLEAN COMMENT 'Indicates whether the device state change for this step was confirmed via SCADA telemetry in addition to field crew verbal confirmation. True when SCADA telemetry corroborates the reported device state; False when confirmation is based solely on field crew report (e.g., non-telemetered device).',
  `skip_reason` STRING COMMENT 'Documented justification for skipping this switching step, populated only when step_status is \'skipped\'. Must be authorized by the control room operator and recorded for NERC compliance audit trail.',
  `step_instruction` STRING COMMENT 'Detailed written instruction describing exactly how this switching step is to be performed, including specific device location, approach direction, required tools, and safety precautions. Authored by the switching order planner and reviewed by the authorizing operator.',
  `step_sequence_number` INT COMMENT 'Ordinal position of this step within the parent switching order. Defines the mandatory execution order of device operations to ensure safe and correct switching sequences. Steps must be executed in ascending sequence order unless the switching order explicitly permits parallel execution.',
  `step_status` STRING COMMENT 'Current lifecycle state of this switching step. \'Pending\' indicates awaiting execution; \'In Progress\' indicates crew is actively performing the operation; \'Completed\' indicates successfully executed; \'Skipped\' indicates bypassed per approved deviation; \'Failed\' indicates execution attempted but unsuccessful; \'Cancelled\' indicates step voided prior to execution. Valid values: pending|in_progress|completed|skipped|failed|cancelled.',
  `switching_order_type` STRING COMMENT 'Classification of the parent switching order that contextualizes this step. Determines applicable approval workflows, safety requirements, and reporting categories. Reference-value candidates: planned_maintenance|emergency_restoration|load_transfer|commissioning|decommissioning|storm_response. Valid values: planned_maintenance|emergency_restoration|load_transfer|commissioning|decommissioning|storm_response.',
  `voltage_level_kv` DECIMAL(8,3) COMMENT 'Nominal operating voltage level in kilovolts (kV) of the circuit or bus associated with the target device. Determines applicable safety clearance distances, PPE requirements, and qualified worker certifications required for this step.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_outage_outage_switching_step` PRIMARY KEY (`outage_switching_step_id`)
)
USING DELTA
COMMENT 'Individual step within a switching order defining a discrete device operation (open, close, tag, verify). Tracks step sequence number, device identifier, action type, required safety state, completion status, actual execution timestamp, and executing crew member. Enables granular audit trail of switching sequences for NERC compliance and post-event analysis. | CMM: CIM SwitchingAction (exact), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'OutageSwitchingStep',
  'cmm.cim.class' = 'SwitchingAction',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.outage_switching_step'
);

-- OutageCrewDispatch  <<CIM FieldDispatchHistory : close>>
CREATE TABLE IF NOT EXISTS `outage`.`outage_crew_dispatch` (
  `outage_crew_dispatch_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for each crew dispatch record within the outage management system. Primary key for the crew_dispatch data product.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Crew dispatches to transmission-connected substations affect control area operations. Coordination between field crews and control center operators is essential for safe switching and maintaining syst',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Crew labor, vehicle, and equipment costs are allocated to cost centers for O&M expense tracking, budget variance analysis, and FERC account classification. Required for labor cost accounting and regul',
  `crew_id` BIGINT COMMENT 'Reference to the field crew assigned to this dispatch. Links to the workforce domain crew master record without duplicating workforce data. Crew composition and qualifications are owned by the workforce domain.',
  `event_id` BIGINT COMMENT 'Reference to the outage event that triggered this crew dispatch. Links the dispatch record to the parent outage lifecycle managed in the Outage Management System (OMS).',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Crew dispatches are assigned to forecast zones for resource tracking, mutual aid coordination, and operational planning. Utilities use zone-level crew deployment data for storm response planning, reso',
  `grid_switching_order_id` BIGINT COMMENT 'Foreign key linking to grid.grid_switching_order. Business justification: Crew dispatches execute grid switching orders. Linking enables tracking of switching order execution status, crew assignment, and field crew coordination with control center operators.',
  `restoration_action_id` BIGINT COMMENT 'Reference to the specific restoration action or switching order this dispatch is fulfilling. Enables traceability from dispatch to restoration workflow step.',
  `training_record_id` BIGINT COMMENT 'Foreign key linking to compliance.training_record. Business justification: Crew dispatches to critical infrastructure or NERC CIP assets require verification that crew members have completed required compliance training (NERC CIP personnel risk assessments, safety certificat',
  `actual_arrival_at` TIMESTAMP COMMENT 'Actual timestamp when the crew arrived at the outage location and confirmed on-site presence. Captured via mobile device check-in or OMS field update. Used to measure travel time actuals vs. estimates.',
  `actual_restoration_at` TIMESTAMP COMMENT 'Timestamp when power was actually restored to affected customers following crew repair work. Used as the definitive restoration time for SAIDI (System Average Interruption Duration Index) and CAIDI (Customer Average Interruption Duration Index) calculations.',
  `cancellation_reason` STRING COMMENT 'Reason code for dispatch cancellation when dispatch_status is \'cancelled\'. Captures why the crew was stood down before completing the assignment (e.g., outage restored via FLISR/remote switching, duplicate dispatch, crew reassigned to higher priority). Reference-value candidates: duplicate_dispatch|outage_restored_remotely|crew_reassigned|weather_stand_down|customer_cancelled|other. Valid values: duplicate_dispatch|outage_restored_remotely|crew_reassigned|weather_stand_down|customer_cancelled|other.',
  `cause_code` STRING COMMENT 'Standardized cause code assigned by the crew upon arrival or completion, classifying the root cause of the outage (e.g., equipment failure, tree contact, animal contact, weather, vehicle accident). Aligns with IEEE 1366 cause code taxonomy for reliability reporting.',
  `cleared_at` TIMESTAMP COMMENT 'Timestamp when the crew was formally released from the outage site and cleared for reassignment. May differ from work_completed_at if post-work safety checks, documentation, or switching order closeout is required.',
  `contractor_company_name` STRING COMMENT 'Name of the external contractor company providing the crew, when crew_type is \'contractor\' or mutual_aid_flag is true. Used for contractor performance tracking, invoice reconciliation, and mutual aid cost recovery.',
  `created_at` TIMESTAMP COMMENT 'Timestamp when the crew dispatch record was first created in the Outage Management System (OMS). Used for audit trail and data lineage tracking.',
  `crew_identifier` STRING COMMENT 'Human-readable operational identifier for the dispatched crew (e.g., crew badge number, radio call sign, or crew unit code) as used by dispatchers and field supervisors in OMS communications.',
  `crew_size` INT COMMENT 'Number of personnel included in the dispatched crew. Used for resource planning, storm response staffing analytics, and mutual aid tracking.',
  `crew_type` STRING COMMENT 'Classification of the dispatched crew by functional role and capability. Determines the type of work the crew is qualified to perform at the outage site. Reference-value candidates: line_crew|troubleshooter|contractor|tree_crew|substation_crew|damage_assessment. Valid values: line_crew|troubleshooter|contractor|tree_crew|substation_crew|damage_assessment.',
  `critical_facility_flag` BOOLEAN COMMENT 'Indicates whether the outage site or affected area includes a critical facility (e.g., hospital, emergency services, water treatment plant, military installation). Drives elevated dispatch priority and regulatory notification requirements.',
  `customers_affected_count` INT COMMENT 'Number of customer service points affected by the outage event at the time of dispatch. Used for prioritization, regulatory reporting, and SAIFI (System Average Interruption Frequency Index) calculations.',
  `damage_assessment_code` STRING COMMENT 'Field crew assessment of infrastructure damage severity at the outage site. Used for storm response resource planning, mutual aid requests, and post-event damage reporting to regulators. Valid values: none|minor|moderate|major|catastrophic.',
  `dispatch_location_description` STRING COMMENT 'Free-text description of the outage site location provided to the crew at dispatch time, including landmarks, access instructions, or hazard notes. Supplements GIS coordinates for field navigation.',
  `dispatch_number` STRING COMMENT 'Externally-known alphanumeric identifier for the dispatch record, used by field crews, dispatchers, and OMS operators for cross-system reference and communication. Format: DSP-YYYY-NNNNNN. Pattern: ^DSP-[0-9]{4}-[0-9]{6}$.',
  `dispatch_priority` STRING COMMENT 'Priority tier assigned to this dispatch, reflecting urgency based on outage impact (e.g., critical infrastructure, hospital, large customer count). Drives restoration sequencing and resource allocation decisions. Valid values: critical|high|medium|low.',
  `dispatch_source` STRING COMMENT 'Originating channel or system through which the dispatch was initiated. Distinguishes automated OMS-driven dispatches from manual dispatcher assignments, storm center activations, or mutual aid requests. Valid values: oms_auto|dispatcher_manual|storm_center|mutual_aid|contractor_portal.',
  `dispatch_status` STRING COMMENT 'Current lifecycle state of the crew dispatch record, tracking progression from initial assignment through field completion. Reference-value candidates: pending|dispatched|en_route|on_site|work_in_progress|completed|cancelled.',
  `dispatched_at` TIMESTAMP COMMENT 'The principal real-world event timestamp when the crew was formally dispatched from the operations center to the outage location. Used as the primary business event time for SAIDI/SAIFI/CAIDI reliability metric calculations.',
  `dispatcher_notes` STRING COMMENT 'Free-text notes entered by the dispatcher at the time of crew assignment, including special instructions, hazard warnings, customer contact information, or access restrictions for the outage site.',
  `estimated_arrival_at` TIMESTAMP COMMENT 'Calculated timestamp for when the crew is expected to arrive on-site at the outage location. Derived at dispatch time from dispatched_at plus estimated_travel_time_min. Used for customer ETR (Estimated Time to Restore) communications.',
  `estimated_restoration_at` TIMESTAMP COMMENT 'Estimated Time to Restore (ETR) as assessed by the crew or dispatcher after on-site evaluation. Used for customer notification updates and regulatory ETR reporting requirements. Distinct from estimated_arrival_at.',
  `estimated_travel_time_min` INT COMMENT 'Estimated travel time in minutes from the crew\'s current location or staging area to the outage site at the time of dispatch. Used for restoration time estimation and customer notification ETAs.',
  `field_crew_notes` STRING COMMENT 'Free-text notes entered by the field crew upon arrival or completion, documenting observed conditions, equipment findings, repair actions taken, or follow-up work required. Captured via mobile OMS interface.',
  `follow_up_required_flag` BOOLEAN COMMENT 'Indicates whether the crew identified additional work required beyond the initial restoration scope (e.g., permanent repair after temporary restoration, equipment replacement, vegetation management). Triggers follow-up work order creation.',
  `mutual_aid_flag` BOOLEAN COMMENT 'Indicates whether the dispatched crew is a mutual aid crew provided by another utility or contractor under a mutual assistance agreement. Used for storm cost tracking, mutual aid settlement, and NERC EOP-011 compliance reporting.',
  `oms_incident_number` STRING COMMENT 'The incident or trouble call number assigned by the Outage Management System (OMS) that initiated this dispatch. Provides cross-system traceability between the OMS incident record and the dispatch record.',
  `operating_district_code` STRING COMMENT 'Internal operating district or division code for the area where the outage occurred. Used for crew assignment routing, regional performance reporting, and SAIDI/SAIFI district-level aggregation.',
  `safety_clearance_number` STRING COMMENT 'Unique identifier for the safety clearance or hold tag issued to the crew before commencing energized work. Required for OSHA lockout/tagout compliance and NERC CIP physical security documentation.',
  `service_territory_code` STRING COMMENT 'Code identifying the utility service territory or operating district in which the outage site is located. Used for regulatory reporting to State Public Utility Commissions (PUCs) and for regional resource allocation.',
  `site_latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate (decimal degrees, WGS84) of the outage site to which the crew is dispatched. Sourced from GIS or OMS outage location data for field navigation and spatial analytics.',
  `site_longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate (decimal degrees, WGS84) of the outage site to which the crew is dispatched. Sourced from GIS or OMS outage location data for field navigation and spatial analytics.',
  `storm_event_flag` BOOLEAN COMMENT 'Indicates whether this dispatch is associated with a declared storm or major event. When true, the dispatch may be excluded from standard SAIDI/SAIFI calculations per IEEE 1366 major event day (MED) exclusion criteria.',
  `switching_order_number` STRING COMMENT 'Reference number of the switching order issued to the crew for safe isolation and restoration of the affected circuit segment. Links to the switching order management workflow in the ADMS.',
  `updated_at` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the crew dispatch record. Supports change tracking, audit compliance, and incremental data pipeline processing.',
  `vehicle_identifier` STRING COMMENT 'Operational identifier for the assigned vehicle (e.g., fleet unit number, license plate, or radio unit ID) as used by dispatchers for field tracking and resource management.',
  `vehicle_number` BIGINT COMMENT 'Reference to the vehicle assigned to this dispatch from the fleet management system. Links to the asset management domain vehicle master record.',
  `work_completed_at` TIMESTAMP COMMENT 'Timestamp when the crew completed all assigned repair or restoration work at the outage site and confirmed task closure in the OMS. Used for SAIDI/CAIDI calculation and restoration performance reporting.',
  `work_order_number` STRING COMMENT 'Reference to the associated work order in the asset management or ERP system (Ventyx Asset Suite or SAP S/4HANA Plant Maintenance) that governs the repair or restoration task assigned to this crew.',
  `work_start_at` TIMESTAMP COMMENT 'Timestamp when the crew began active repair or restoration work at the outage site. Distinct from arrival time — accounts for safety setup, hazard assessment, and switching order receipt before work commences.',
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
  CONSTRAINT `pk_outage_outage_crew_dispatch` PRIMARY KEY (`outage_crew_dispatch_id`)
)
USING DELTA
COMMENT 'Record of a field crew assignment dispatched to an outage location for investigation, repair, or restoration. Captures dispatched crew identifier, dispatch timestamp, estimated travel time, on-site arrival time, work start and completion times, crew type (line crew, troubleshooter, contractor), vehicle assignment, dispatch priority tier, and dispatch status lifecycle. Links to outage events and restoration actions without duplicating workforce master data owned by the workforce domain. | CMM: CIM FieldDispatchHistory (close), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'OutageCrewDispatch',
  'cmm.cim.class' = 'FieldDispatchHistory',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.outage_crew_dispatch',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- RestorationAction  <<CIM SwitchingAction : broad>>
CREATE TABLE IF NOT EXISTS `outage`.`restoration_action` (
  `restoration_action_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for each discrete restoration action record within the outage management system. Primary key for the restoration_action data product.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Restoration actions change load/generation balance within control areas, requiring AGC adjustments and interchange schedule updates. Essential for coordinating distribution restoration with transmissi',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Restoration work costs (switching operations, load transfers, FLISR actions) are charged to cost centers for O&M expense allocation and variance analysis against distribution operations budgets. Stand',
  `crew_id` BIGINT COMMENT 'Reference to the field crew assigned to execute this restoration action. Populated only for manual crew-dispatched actions; null for fully automated FLISR actions.',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_system. Business justification: FLISR and manual restoration sequences must account for DER presence on segments (anti-islanding protection, voltage regulation impact, fault current contribution). Restoration logic checks DER status',
  `distribution_substation_id` BIGINT COMMENT 'Identifier of the substation serving the network segment affected by this restoration action. Used for substation-level outage aggregation and reliability reporting.',
  `event_id` BIGINT COMMENT 'Reference to the parent outage event that this restoration action is associated with. Links the discrete action to the broader outage lifecycle managed in the OMS.',
  `feeder_id` BIGINT COMMENT 'Identifier of the distribution feeder circuit on which this restoration action was performed, as defined in the GIS and ADMS network model. Used for feeder-level reliability performance tracking.',
  `outage_switching_order_id` BIGINT COMMENT 'Reference to the switching order that authorized or directed this restoration action, if applicable. Switching orders govern the sequence of switching operations for safe restoration.',
  `primary_restoration_network_segment_id` BIGINT COMMENT 'Reference to the distribution network segment (feeder section, lateral, or zone) affected by this restoration action. Identifies the portion of the grid being isolated, sectionalized, or re-energized.',
  `scada_point_id` BIGINT COMMENT 'Foreign key linking to grid.scada_point. Business justification: Restoration actions involve SCADA-monitored devices (reclosers, switches). Linking enables real-time status verification, FLISR automation, and coordinated distribution automation with EMS operations.',
  `sectionalizing_device_id` BIGINT COMMENT 'Identifier of the switching device (recloser, sectionalizer, circuit breaker, or fuse) operated to isolate the faulted segment during this action. References the device asset in the GIS or ADMS network model.',
  `action_completed_timestamp` TIMESTAMP COMMENT 'Timestamp when the restoration action was confirmed complete and verified by the crew or automated system. Used to calculate action duration and assess restoration efficiency.',
  `action_duration_minutes` DECIMAL(8,2) COMMENT 'Elapsed time in minutes from action initiation (action_timestamp) to action completion (action_completed_timestamp). Used in CAIDI calculations and crew performance benchmarking.',
  `action_notes` STRING COMMENT 'Free-text field for operator or crew notes describing the specific conditions, complications, or observations encountered during this restoration action. Supports post-event analysis and lessons-learned documentation.',
  `action_number` STRING COMMENT 'Externally visible, human-readable identifier for this restoration action as recorded in the OMS or switching order log (e.g., RA-2024-00451). Used by field crews, control room operators, and regulators to reference specific actions.',
  `action_sequence` INT COMMENT 'Ordinal sequence number of this action within the parent outage event\'s restoration workflow. Enables step-by-step reconstruction of the restoration sequence for post-event analysis and SAIDI/SAIFI/CAIDI reporting.',
  `action_status` STRING COMMENT 'Current lifecycle status of the restoration action. Pending: scheduled but not yet started. In_progress: crew or automation is actively executing. Completed: action successfully finished. Failed: action attempted but unsuccessful. Cancelled: action voided before execution. Valid values: pending|in_progress|completed|failed|cancelled.',
  `action_timestamp` TIMESTAMP COMMENT 'The principal real-world timestamp when this restoration action was executed or initiated in the field or by the automated system. Used as the primary event time for SAIDI/SAIFI/CAIDI calculations and restoration timeline analysis.',
  `action_type` STRING COMMENT 'Classification of the type of restoration action performed. Isolation: de-energizes a faulted segment. Sectionalizing: divides a feeder to limit the outage zone. Load transfer: moves load to an alternate feeder. Temporary bypass: restores power via a temporary path. Permanent repair: physical repair restoring normal configuration. FLISR automated: Fault Location Isolation and Service Restoration (FLISR) algorithm-driven action. Valid values: isolation|sectionalizing|load_transfer|temporary_bypass|permanent_repair|flisr_automated.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this restoration action record was first created in the OMS or data platform. Supports audit trail and data lineage requirements.',
  `crew_arrival_timestamp` TIMESTAMP COMMENT 'Timestamp when the field crew arrived on-site to begin executing this manual restoration action. Used to calculate crew travel time and on-site restoration duration for workforce performance analytics.',
  `crew_dispatched_timestamp` TIMESTAMP COMMENT 'Timestamp when the field crew was dispatched from the control room or dispatch center to execute this restoration action. Used to measure dispatch-to-arrival interval and overall crew response time.',
  `customer_notification_sent` BOOLEAN COMMENT 'Indicates whether a customer notification (outage alert, ETR update, or restoration confirmation) was sent to affected customers as a result of this restoration action. Supports compliance with state PUC customer communication requirements.',
  `customers_affected_count` INT COMMENT 'Total number of customer service points that were de-energized or affected by the segment targeted by this action at the time of action execution. Provides context for partial vs. full restoration assessment.',
  `customers_requiring_manual` INT COMMENT 'Number of customers within the affected segment that could not be restored by FLISR automation and required manual crew dispatch for restoration. Highlights FLISR coverage gaps.',
  `customers_restored_automatically` INT COMMENT 'Number of customers restored through fully automated Fault Location Isolation and Service Restoration (FLISR) self-healing actions without manual crew intervention. Key metric for FLISR performance analytics.',
  `customers_restored_count` INT COMMENT 'Number of customer service points restored to power as a direct result of this specific restoration action. Used in SAIDI, SAIFI, and CAIDI index calculations and regulatory reliability reporting.',
  `estimated_restoration_time` TIMESTAMP COMMENT 'Estimated Time to Restore (ETR) for the remaining affected customers at the time this action was recorded. Updated as each restoration action is completed to refine the ETR communicated to customers and regulators.',
  `execution_mode` STRING COMMENT 'Indicates whether the restoration action was executed manually by a field crew or control room operator, fully automated by the FLISR algorithm, or semi-automated (system-initiated but operator-confirmed). Valid values: manual|automated|semi_automated.',
  `fault_detected_timestamp` TIMESTAMP COMMENT 'Timestamp when the fault triggering this restoration action was first detected by SCADA, FLISR, or field crew. Distinct from action_timestamp; used to calculate fault-to-isolation and fault-to-restoration intervals.',
  `flisr_algorithm_version` STRING COMMENT 'Version identifier of the Fault Location Isolation and Service Restoration (FLISR) algorithm that executed this automated restoration action. Enables performance benchmarking across algorithm versions and supports software change management.',
  `flisr_isolation_actions_taken` INT COMMENT 'Number of automated switching operations performed by the FLISR algorithm to isolate the faulted segment during this restoration action. Supports FLISR performance analytics and switching operation audits.',
  `flisr_load_transfer_actions_taken` INT COMMENT 'Number of automated load transfer switching operations performed by the FLISR algorithm to restore power to non-faulted segments during this action. Key metric for FLISR self-healing effectiveness.',
  `flisr_outcome` STRING COMMENT 'Outcome of the FLISR automated restoration attempt for this action. Success: FLISR fully restored the affected segment. Partial_success: FLISR restored a portion; manual intervention required for remainder. Failure: FLISR could not restore; full manual restoration required. Not_applicable: action was manual, not FLISR-driven. Valid values: success|partial_success|failure|not_applicable.',
  `is_major_event_day` BOOLEAN COMMENT 'Indicates whether this restoration action occurred during a Major Event Day (MED) as defined by IEEE 1366 beta method. MED events are typically excluded from standard SAIDI/SAIFI calculations and reported separately to regulators.',
  `is_partial_restoration` BOOLEAN COMMENT 'Indicates whether this action resulted in a partial restoration (True) — restoring power to a subset of affected customers — or a full restoration of the affected segment (False). Drives ETR refinement and customer notification logic.',
  `is_planned_outage` BOOLEAN COMMENT 'Indicates whether this restoration action is associated with a planned maintenance outage (True) or an unplanned/forced outage (False). Planned outages are tracked separately for SAIDI/SAIFI reporting and customer notification compliance.',
  `load_transfer_source_feeder` STRING COMMENT 'Identifier of the source feeder or substation bus from which load is transferred during a load transfer restoration action. Populated when action_type is load_transfer or flisr_automated.',
  `load_transfer_target_feeder` STRING COMMENT 'Identifier of the target feeder or substation bus receiving the transferred load during a load transfer restoration action. Used to assess feeder loading and capacity constraints post-transfer.',
  `oms_action_reference` STRING COMMENT 'Source system reference key for this restoration action as recorded in the GE PowerOn ADMS Outage Management System (OMS). Enables traceability and reconciliation between the lakehouse silver layer and the operational OMS.',
  `outage_cause_code` STRING COMMENT 'Standardized cause code for the fault or outage condition that necessitated this restoration action (e.g., equipment failure, tree contact, animal contact, storm, vehicle accident, planned maintenance). Aligns with IEEE 1366 cause code taxonomy. Reference-value candidates: equipment_failure|tree_contact|animal_contact|storm|vehicle_accident|planned_maintenance|unknown|other.',
  `regulatory_reportable` BOOLEAN COMMENT 'Indicates whether this restoration action is associated with an outage event that must be reported to a regulatory body (NERC, FERC, State PUC, or DOE). Drives inclusion in regulatory reliability reports and OE-417 emergency incident filings.',
  `scada_event_reference` STRING COMMENT 'Reference identifier linking this restoration action to the corresponding SCADA (Supervisory Control and Data Acquisition) event or alarm in OSIsoft PI historian. Enables correlation between OMS restoration records and real-time grid telemetry.',
  `to_crew` BIGINT COMMENT 'FK to outage.crew_dispatch.crew_dispatch_id — Each restoration action is performed by a dispatched crew. Links action to the crew that executed it for accountability and performance tracking.',
  `to_crew_dispatch` BIGINT COMMENT 'FK to outage.crew_dispatch.crew_dispatch_id — Restoration actions are performed by dispatched crews. This FK links the action to the crew that executed it, enabling crew performance tracking and accountability.',
  `to_outage_event` BIGINT COMMENT 'FK to outage.outage_event.outage_event_id — Every restoration action is performed within the context of an outage event. Required for step-by-step restoration tracking and ETR refinement.',
  `transferred_load_mw` DECIMAL(10,3) COMMENT 'Magnitude of electrical load in Megawatts (MW) transferred from the faulted segment to an alternate feeder during a load transfer action. Used for grid capacity analysis and post-event load flow validation.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this restoration action record was last modified. Tracks updates to status, customer counts, or FLISR outcome fields throughout the restoration lifecycle.',
  `voltage_level_kv` DECIMAL(8,3) COMMENT 'Nominal voltage level in kilovolts (kV) of the network segment on which this restoration action was performed (e.g., 4.16, 12.47, 34.5, 69, 115 kV). Used to classify the action within transmission vs. distribution tiers.',
  `weather_condition_code` STRING COMMENT 'Weather condition code at the time of the outage event and restoration action. Used for storm-related reliability analysis, SAIDI/SAIFI major event day (MED) exclusion calculations, and regulatory storm reporting. Reference-value candidates: normal|wind|ice|lightning|flood|extreme_heat|other.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_outage_restoration_action` PRIMARY KEY (`restoration_action_id`)
)
USING DELTA
COMMENT 'Discrete restoration action taken during an outage event to restore power to a portion of affected customers, covering both manual and automated (FLISR) restoration. Records action type (isolation, sectionalizing, temporary bypass, permanent repair, load transfer, automated FLISR), execution mode (manual crew action vs automated grid self-healing), affected segment, customers restored by this action, action timestamp, crew performing the action (if manual), partial vs. full restoration flag, FLISR-specific attributes (fault detection timestamp, faulted segment, isolation actions taken automatically, load transfer actions, FLISR algorithm version, success/failure outcome, customers restored automatically vs requiring manual intervention). Enables step-by-step restoration tracking, ETR refinement, and FLISR performance analytics. | CMM: CIM SwitchingAction (broad), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'RestorationAction',
  'cmm.cim.class' = 'SwitchingAction',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.restoration_action'
);

-- OutageCause  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `outage`.`cause` (
  `cause_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for each outage cause code record in the reference classification table. Primary key. [REFERENCE_LOOKUP role — canonical_skip_reason: This entity is a reference/lookup table of cause codes; per-role minimum categories do not apply.]',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Specific outage cause codes trigger different regulatory reporting obligations (e.g., vegetation management failures vs. equipment failures have different NERC reporting rules). Compliance teams map c',
  `asset_class_applicability` STRING COMMENT 'Identifies the class(es) of utility assets to which this cause code applies (e.g., \'Overhead Distribution\', \'Underground Transmission\', \'Substation Equipment\', \'Generation Unit\'). Supports asset-cause correlation in reliability and asset management analytics.',
  `cause_category` STRING COMMENT 'High-level grouping of the outage cause into standard industry categories. Drives SAIDI/SAIFI/CAIDI segmentation in reliability analytics and PUC regulatory reporting. Reference-value candidates: equipment_failure|weather|vegetation|animal_contact|human_error|third_party_damage|unknown.',
  `cause_code` STRING COMMENT 'Alphanumeric code uniquely identifying the outage cause within the classification system. Used as the business-facing key in OMS, regulatory filings, and reliability reports. Sourced from GE PowerOn ADMS cause code configuration. Pattern: ^[A-Z0-9_]{2,20}$.',
  `cause_description` STRING COMMENT 'Full narrative description of the outage cause, including typical failure modes, contributing conditions, and examples. Used for training, documentation, and regulatory submissions.',
  `cause_group` STRING COMMENT 'Operational grouping of cause codes for internal reporting and benchmarking purposes (e.g., \'Overhead T&D\', \'Underground T&D\', \'Substation\', \'Generation\', \'External\'). Supports drill-down analysis in reliability dashboards.',
  `cause_name` STRING COMMENT 'Human-readable short name for the outage cause (e.g., \'Tree Contact\', \'Equipment Failure - Transformer\', \'Animal Contact\'). Displayed in OMS dashboards and regulatory reports.',
  `cause_status` STRING COMMENT 'Current lifecycle status of the cause code record. Active codes are available for OMS event classification; deprecated codes are retained for historical reporting only; pending_review codes are under regulatory or operational review. Valid values: active|inactive|deprecated|pending_review.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this cause code record was first created in the data platform. Supports data lineage, audit trail, and change management for the reference classification table.',
  `crew_type_required` STRING COMMENT 'Identifies the type of field crew typically required to restore outages of this cause (e.g., \'Line Crew\', \'Cable Crew\', \'Substation Technician\', \'Tree Crew\', \'Damage Assessment\'). Supports automated crew dispatch recommendations in OMS.',
  `customer_notification_required` BOOLEAN COMMENT 'Indicates whether outages with this cause trigger mandatory proactive customer notification obligations (e.g., via IVR, SMS, or email). Supports compliance with PUC customer communication requirements.',
  `effective_date` DATE COMMENT 'The date from which this cause code is valid and available for use in outage event classification. Supports temporal versioning of the cause code reference table for historical reporting accuracy.',
  `epa_cause_indicator` STRING COMMENT 'Indicates whether the outage cause has environmental reporting implications under EPA regulations (e.g., spill events, emissions exceedances triggered by unplanned generation outages). Used for environmental compliance tracking.',
  `expiry_date` DATE COMMENT 'The date after which this cause code is no longer valid for new outage event classification. Null indicates the code is currently active with no planned expiry. Supports cause code lifecycle management and historical data integrity.',
  `ieee_1366_category` STRING COMMENT 'Classification of the outage cause under IEEE Standard 1366 for electric power distribution reliability indices. Determines how interruptions associated with this cause are counted in SAIDI, SAIFI, and CAIDI calculations. Valid values: sustained|momentary|major_event_day|planned|unknown.',
  `insurance_claimable` BOOLEAN COMMENT 'Indicates whether outage events attributed to this cause are eligible for insurance claim submission (e.g., storm damage, third-party damage). Supports financial recovery tracking and CAPEX/OPEX classification.',
  `is_controllable` BOOLEAN COMMENT 'Indicates whether the outage cause is considered controllable by the utility (i.e., preventable through operational or maintenance actions). Used in reliability improvement program targeting and PUC performance benchmarking.',
  `is_doe_reportable` BOOLEAN COMMENT 'Indicates whether outage events with this cause require submission to the U.S. Department of Energy via the OE-417 Electric Emergency Incident and Disturbance Report. True = DOE OE-417 filing required.',
  `is_med_exclusion` BOOLEAN COMMENT 'Indicates whether outage events attributed to this cause qualify for exclusion from SAIDI/SAIFI/CAIDI baseline calculations as a Major Event Day (MED) under IEEE 1366. True = MED-eligible exclusion; False = included in standard reliability indices.',
  `is_momentary` BOOLEAN COMMENT 'Indicates whether this cause code is associated with momentary interruptions (duration less than 5 minutes per IEEE 1366). Momentary events are tracked separately in MAIFI (Momentary Average Interruption Frequency Index) calculations.',
  `is_nerc_reportable` BOOLEAN COMMENT 'Indicates whether outage events attributed to this cause trigger mandatory NERC event reporting obligations (e.g., EOP-004 threshold events). True = NERC reporting required; False = not required.',
  `is_planned` BOOLEAN COMMENT 'Indicates whether this cause code applies to planned (scheduled) outages rather than unplanned interruptions. Planned outages are excluded from SAIDI/SAIFI/CAIDI calculations per IEEE 1366. True = planned; False = unplanned.',
  `is_puc_reportable` BOOLEAN COMMENT 'Indicates whether outage events with this cause must be reported to the state Public Utility Commission (PUC) under applicable regulatory reporting requirements. True = mandatory PUC notification required; False = not required.',
  `is_weather_related` BOOLEAN COMMENT 'Indicates whether the outage cause is classified as weather-related. Drives storm response analytics, MED determination, and insurance/force-majeure reporting. Distinct from the cause_category field as some sub-causes may be weather-adjacent.',
  `nerc_cause_category` STRING COMMENT 'NERC-defined top-level cause category label corresponding to the nerc_cause_code. Supports direct mapping to NERC event reporting taxonomy without requiring a separate lookup. Examples: \'Electrical\', \'Environmental\', \'Human Error\', \'Other\'.',
  `nerc_cause_code` STRING COMMENT 'Standardized cause code as defined by NERC for transmission and bulk electric system outage reporting. Required for NERC event reporting (EOP-004) and DOE OE-417 submissions. Maps the internal cause code to the NERC taxonomy. Pattern: ^[A-Z0-9]{1,10}$.',
  `oms_cause_code` STRING COMMENT 'The native cause code identifier as configured in the GE PowerOn ADMS/OMS system. Used for direct system integration, data lineage tracing, and reconciliation between the silver layer and the source OMS. Pattern: ^[A-Z0-9_]{1,20}$.',
  `puc_cause_code` STRING COMMENT 'The cause code as defined in the applicable state Public Utility Commission (PUC) reporting taxonomy. Required for annual reliability reports and service quality filings. May differ from internal cause_code. Pattern: ^[A-Z0-9_]{1,20}$.',
  `regulatory_reporting_notes` STRING COMMENT 'Free-text field capturing specific regulatory reporting instructions, exceptions, or conditions associated with this cause code. Used by compliance teams to document PUC, NERC, or DOE reporting nuances for this cause.',
  `reliability_index_impact` STRING COMMENT 'Identifies which reliability performance indices (SAIDI, SAIFI, CAIDI, MAIFI) are impacted by outage events attributed to this cause. Drives automated index calculation logic in the reliability analytics platform. Valid values: saidi|saifi|caidi|maifi|all|none.',
  `saidi_weight_factor` DECIMAL(10,6) COMMENT 'Numeric weighting factor applied to SAIDI calculations for outages of this cause type. Allows regulatory-mandated cause-specific weighting adjustments in reliability index computations. Default is 1.0 (no adjustment).',
  `sort_order` INT COMMENT 'Numeric value controlling the display sequence of cause codes in OMS dropdown lists, regulatory report templates, and analytics dashboards. Lower values appear first.',
  `source_system` STRING COMMENT 'Identifies the operational system of record from which this cause code was sourced or synchronized (e.g., GE PowerOn ADMS, SAP IS-U). Supports data lineage and reconciliation in the Databricks silver layer. Valid values: GE_PowerOn_ADMS|SAP_ISU|Oracle_CCB|Manual|Other.',
  `sub_cause_code` STRING COMMENT 'Secondary classification code providing finer granularity within a cause category (e.g., within \'equipment_failure\': transformer, cable, switch, fuse). Enables detailed root-cause analysis and asset failure trending. Pattern: ^[A-Z0-9_]{2,30}$.',
  `sub_cause_name` STRING COMMENT 'Human-readable label for the sub-cause code (e.g., \'Overhead Conductor\', \'Underground Cable Fault\', \'Fuse Operation\'). Used in OMS event classification and crew dispatch workflows.',
  `switching_order_required` BOOLEAN COMMENT 'Indicates whether outages attributed to this cause typically require a formal switching order to be issued before restoration work can begin. Drives workflow automation in OMS switching order management.',
  `third_party_liability_flag` BOOLEAN COMMENT 'Indicates whether outages attributed to this cause may involve third-party liability (e.g., contractor damage, vehicle contact, excavation damage). Triggers claims management and legal notification workflows.',
  `typical_duration_minutes` INT COMMENT 'Historical average or benchmark restoration duration in minutes for outages attributed to this cause. Used for crew dispatch planning, customer estimated restoration time (ERT) communications, and CAIDI benchmarking.',
  `typical_restoration_priority` STRING COMMENT 'Default restoration priority level associated with outages of this cause type. Used to pre-populate restoration prioritization workflows in OMS and crew dispatch systems. Overridable at the individual outage event level. Valid values: critical|high|medium|low.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this cause code record. Used for incremental data pipeline processing, change detection, and audit compliance.',
  `version_number` INT COMMENT 'Incremental version number tracking revisions to the cause code definition, category mapping, or regulatory alignment. Supports audit trail and change management for the reference classification table.',
  `voltage_level_applicability` STRING COMMENT 'Indicates the voltage level(s) at which this cause code is applicable: transmission (>= 115 kV), sub-transmission, distribution (< 35 kV), or all levels. Ensures correct cause code assignment during OMS event classification. Valid values: transmission|sub_transmission|distribution|all.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_outage_cause` PRIMARY KEY (`cause_id`)
)
USING DELTA
COMMENT 'Reference classification of outage cause codes used to categorize the root cause of interruption events. Includes cause category (equipment failure, weather, vegetation, animal contact, human error, third-party damage, unknown), sub-cause code, NERC cause code mapping, PUC reportable flag, and whether the cause qualifies as a Major Event Day (MED) exclusion under IEEE 1366. Drives regulatory reporting and reliability analytics. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'OutageCause',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'reference_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.cause'
);

-- PlannedOutageWindow  <<CIM PlannedOutage : close>>
CREATE TABLE IF NOT EXISTS `outage`.`planned_outage_window` (
  `planned_outage_window_id` BIGINT NOT NULL COMMENT 'Primary key for planned_outage_window',
  `distribution_substation_id` BIGINT COMMENT 'Identifier of the substation from which the affected feeder or circuit originates. Used for switching coordination, crew dispatch, and geographic impact analysis.',
  `feeder_id` BIGINT COMMENT 'Identifier of the primary distribution feeder or circuit segment to be de-energized during the planned outage window. Sourced from the GIS network model (Esri ArcGIS Utility Network) and used for switching order generation.',
  `interconnection_application_id` BIGINT COMMENT 'Foreign key linking to interconnection.application. Business justification: Tariff rules require notifying customers with pending interconnection applications of planned outages affecting their POI. Coordination prevents construction conflicts and ensures applicants can sched',
  `oms_event_id` BIGINT COMMENT 'Identifier of the corresponding event record in the Outage Management System (OMS), such as GE PowerOn ADMS. Provides traceability between the planned outage window record and the operational OMS event for reconciliation and audit.',
  `premise_id` BIGINT COMMENT 'Foreign key linking to customer.premise. Business justification: Planned maintenance windows often target specific premises for equipment upgrades, service line work, or meter replacements. Utilities must track affected premises for advance customer notification (r',
  `actual_duration_minutes` INT COMMENT 'Actual duration of the de-energization in minutes, recorded upon restoration. Used to compute duration variance against planned_duration_minutes and to feed SAIDI/SAIFI/CAIDI reliability indices.',
  `actual_end_timestamp` TIMESTAMP COMMENT 'Actual date and time at which the network segment was re-energized and service restored. Used to compute actual outage duration and variance against planned duration for SAIDI/SAIFI/CAIDI performance reporting.',
  `actual_start_timestamp` TIMESTAMP COMMENT 'Actual date and time at which the network segment was de-energized. Compared against planned_start_timestamp to compute schedule variance for reliability reporting and SAIDI/SAIFI tracking.',
  `advance_notice_period_hours` INT COMMENT 'Minimum advance notice period in hours required before the planned outage commences, as mandated by state PUC tariff rules or internal SLA policy. Drives the customer notification scheduling workflow.',
  `affected_customer_count` INT COMMENT 'Estimated number of customer service points (meters) that will experience interruption during the planned outage window. Used for customer notification prioritization, regulatory reporting, and SAIFI impact assessment.',
  `alternate_feed_available` BOOLEAN COMMENT 'Indicates whether an alternate supply path exists to maintain service to some or all affected customers during the planned outage window. Informs restoration strategy and customer notification messaging.',
  `approval_status` STRING COMMENT 'Approval workflow status for the planned outage window, tracking whether the request has been reviewed and authorized by the appropriate operations or grid control authority before execution. Valid values: pending|approved|rejected|withdrawn.',
  `approved_by` STRING COMMENT 'Identifier or name of the operations supervisor, grid control authority, or system operator who authorized the planned outage window. Required for audit trail and NERC compliance documentation.',
  `approved_timestamp` TIMESTAMP COMMENT 'Date and time at which the planned outage window received formal authorization from the approving authority. Part of the approval audit trail required for NERC and PUC compliance.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time at which the planned outage window record was first created in the system. Used for audit trail, workflow SLA tracking, and advance notice compliance verification.',
  `critical_customer_count` INT COMMENT 'Number of critical or life-support customers (medical baseline, hospitals, emergency services) within the affected area. Drives mandatory advance notification requirements and restoration prioritization per PUC rules.',
  `customer_notification_required` BOOLEAN COMMENT 'Indicates whether customer advance notification is required for this planned outage window based on PUC tariff rules, affected customer count thresholds, or presence of critical customers.',
  `customer_notification_sent` BOOLEAN COMMENT 'Indicates whether the required customer advance notification has been dispatched for this planned outage window. Used for compliance tracking and audit trail against PUC notification obligations.',
  `duration_variance_minutes` INT COMMENT 'Difference between actual and planned outage duration in minutes (actual_duration_minutes minus planned_duration_minutes). Positive values indicate overrun; negative values indicate early restoration. Key metric for reliability performance reporting.',
  `estimated_load_mw` DECIMAL(12,3) COMMENT 'Estimated peak load in megawatts (MW) that will be interrupted during the planned outage window. Used for grid stability assessment, load transfer planning, and RTO/ISO notification thresholds.',
  `geographic_region` STRING COMMENT 'Geographic region or district within the service territory where the planned outage is located (e.g., North District, Urban Core, Rural East). Used for crew dispatch routing and regional reliability reporting.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time at which the planned outage window record was most recently modified. Used for change tracking, data lineage, and Silver layer incremental processing.',
  `load_transfer_required` BOOLEAN COMMENT 'Indicates whether load transfer switching is required to maintain service to customers via alternate feed paths during the planned outage window. Triggers switching order generation and crew coordination.',
  `notification_channel` STRING COMMENT 'Primary channel used to deliver the planned outage advance notification to affected customers (e.g., IVR automated call, SMS, email, postal mail, online portal, or field visit for critical customers). Valid values: ivr|sms|email|mail|portal|field_visit.',
  `notification_sent_timestamp` TIMESTAMP COMMENT 'Date and time at which the customer advance notification was dispatched. Used to verify compliance with the required advance_notice_period_hours and to support PUC audit inquiries.',
  `outage_cause_code` STRING COMMENT 'Standardized cause code classifying the reason for the planned de-energization (e.g., scheduled maintenance, capital project, vegetation management, equipment replacement). Aligns with IEEE 1366 cause code taxonomy for reliability reporting. Reference-value candidates: scheduled_maintenance|capital_project|vegetation_management|equipment_replacement|inspection|testing|new_connection.',
  `outage_reference_number` STRING COMMENT 'Externally-known business identifier for the planned outage window, used in customer notifications, regulatory filings, and OMS records. Format: POW-{YYYY}-{NNNNNN}. Pattern: ^POW-[0-9]{4}-[0-9]{6}$.',
  `outage_window_status` STRING COMMENT 'Current lifecycle state of the planned outage window through its approval and execution workflow. Tracks progression from initial draft through approval, active execution, and final completion or cancellation. Valid values: draft|pending_approval|approved|in_progress|completed|cancelled.',
  `outage_window_type` STRING COMMENT 'Classification of the planned outage window by the nature of the work activity requiring de-energization. Drives notification requirements, crew dispatch, and regulatory filing obligations. Reference-value candidates: maintenance|construction|upgrade|inspection|testing|emergency_planned|commissioning|decommissioning. Valid values: maintenance|construction|upgrade|inspection|testing|emergency_planned.',
  `planned_duration_minutes` INT COMMENT 'Planned duration of the de-energization window in minutes, derived from planned start and end timestamps at scheduling time. Stored explicitly for scheduling, crew planning, and customer notification purposes.',
  `planned_end_timestamp` TIMESTAMP COMMENT 'Scheduled date and time at which the network segment is planned to be re-energized and service restored. Used to calculate planned outage duration and customer notification windows.',
  `planned_start_timestamp` TIMESTAMP COMMENT 'Scheduled date and time at which the network segment is planned to be de-energized to begin the maintenance or construction activity. Used for customer advance notification and crew scheduling.',
  `planned_window_to_outage_event` BIGINT COMMENT 'FK to outage.outage_event.outage_event_id — When a planned outage window is executed, it creates an outage event. Links planned scheduling to actual execution for variance tracking.',
  `regulatory_filing_reference` STRING COMMENT 'Reference number or docket number of the regulatory filing submitted to the PUC, NERC, or FERC for this planned outage. Populated only when regulatory_filing_required is true.',
  `regulatory_filing_required` BOOLEAN COMMENT 'Indicates whether this planned outage window requires a formal regulatory filing with the state PUC, NERC, or FERC prior to execution (e.g., for high-voltage transmission outages or outages affecting critical infrastructure).',
  `requested_by` STRING COMMENT 'Identifier or name of the employee, crew supervisor, or project manager who submitted the planned outage window request. Used for accountability tracking and workflow routing.',
  `requesting_department` STRING COMMENT 'Name or code of the business unit or department (e.g., T&D Engineering, Asset Management, Construction) that initiated the planned outage window request. Used for resource allocation and OPEX/CAPEX tracking.',
  `rto_iso_notification_required` BOOLEAN COMMENT 'Indicates whether the planned outage must be reported to the Regional Transmission Organization (RTO) or Independent System Operator (ISO) due to transmission-level impact or market implications under NERC/FERC requirements.',
  `rto_iso_outage_code` STRING COMMENT 'Outage coordination identifier assigned by the RTO or ISO (e.g., MISO, PJM, CAISO) when the planned outage is registered in the transmission outage coordination system. Populated only when rto_iso_notification_required is true.',
  `saidi_contribution_minutes` DECIMAL(10,4) COMMENT 'Contribution of this planned outage window to the annual System Average Interruption Duration Index (SAIDI) in customer-minutes per customer served. Calculated as (actual_duration_minutes × affected_customer_count) / total_customers_served. Used for IEEE 1366 reliability reporting.',
  `saifi_contribution` DECIMAL(10,6) COMMENT 'Contribution of this planned outage window to the annual System Average Interruption Frequency Index (SAIFI), calculated as affected_customer_count / total_customers_served. Used for IEEE 1366 reliability performance reporting to PUC.',
  `service_territory_code` STRING COMMENT 'Code identifying the regulated service territory within which the planned outage window occurs. Used for PUC jurisdictional reporting, rate case filings, and geographic performance analysis.',
  `storm_event_flag` BOOLEAN COMMENT 'Indicates whether this planned outage window is associated with a declared storm or major event, which may qualify for IEEE 1366 major event day (MED) exclusion from SAIDI/SAIFI reliability index calculations.',
  `switching_order_number` STRING COMMENT 'Reference number of the switching order issued in the ADMS or OMS to execute the de-energization and re-energization sequence for this planned outage window. Links to the operational switching workflow.',
  `to_outage_event` BIGINT COMMENT 'FK to outage.outage_event.outage_event_id — Planned maintenance windows result in planned outage events. This FK links the scheduling/approval workflow to the actual outage event record.',
  `voltage_level_kv` DECIMAL(10,3) COMMENT 'Nominal operating voltage level in kilovolts (kV) of the network segment being de-energized. Determines safety protocols, crew qualifications, and regulatory notification thresholds.',
  `work_description` STRING COMMENT 'Free-text description of the maintenance, construction, or upgrade activity to be performed during the planned outage window. Provides context for crew briefings, customer communications, and regulatory filings.',
  `work_order_number` STRING COMMENT 'Reference number of the associated work order in the asset management or ERP system (e.g., SAP S/4HANA PM or Ventyx Asset Suite) that drives the maintenance, construction, or upgrade activity requiring de-energization.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_outage_planned_outage_window` PRIMARY KEY (`planned_outage_window_id`)
)
USING DELTA
COMMENT 'Scheduled planned outage window for maintenance, construction, or upgrade activities requiring deliberate de-energization of network segments. Captures planned start and end times, affected feeder/circuit, work order reference, customer notification requirement, advance notice period, regulatory filing requirement, and actual vs. planned duration variance. Distinct from unplanned outage events — has its own approval and notification workflow. | CMM: CIM PlannedOutage (close), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PlannedOutageWindow',
  'cmm.cim.class' = 'PlannedOutage',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.planned_outage_window'
);

-- AffectedCustomer  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `outage`.`affected_customer` (
  `affected_customer_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for the affected customer association record linking a customer service point to an outage or planned maintenance event.',
  `billing_service_agreement_id` BIGINT COMMENT 'Foreign key linking to billing.billing_service_agreement. Business justification: Affected customer records need service agreement link to determine applicable credit/adjustment rules, verify eligibility for outage compensation programs, and ensure credits are posted to correct bil',
  `compliance_exception_id` BIGINT COMMENT 'Foreign key linking to compliance.exception. Business justification: Critical care customers experiencing outages may trigger compliance exceptions if notification protocols weren\'t followed per regulatory requirements. Compliance monitors critical customer outages for',
  `customer_account_id` BIGINT COMMENT 'Reference to the customer account record in the Customer Information System (CIS). Sourced from SAP IS-U or Oracle CC&B customer account master.',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_system. Business justification: Tracks DER-owning customers experiencing outages for NEM credit adjustments (energy not exported during outage), performance guarantee calculations, and regulatory reporting (CPUC Rule 21 requires tra',
  `distribution_substation_id` BIGINT COMMENT 'Identifier of the substation serving this customer service point at the time of the outage. Used for substation-level reliability performance reporting and asset management correlation.',
  `event_id` BIGINT COMMENT 'Reference to the parent outage or planned maintenance event that caused this customer interruption. Links to the outage event record in the Outage Management System (OMS).',
  `feeder_id` BIGINT COMMENT 'Identifier of the distribution feeder circuit serving this customer service point at the time of the outage. Used for feeder-level reliability analysis and SAIDI/SAIFI segmentation.',
  `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: When customers are affected by outages, credits are applied to specific invoices; direct link streamlines adjustment posting, enables invoice-level outage credit tracking for regulatory reporting, and',
  `meter_id` BIGINT COMMENT 'Reference to the meter installed at the affected service point. Used to correlate outage impact with Advanced Metering Infrastructure (AMI) last-gasp signals and meter data.',
  `outage_crew_dispatch_id` BIGINT COMMENT 'Reference to the crew dispatch or work order assigned to restore power at this customer service point. Links to the field crew assignment in the OMS or Work Management System.',
  `outage_switching_order_id` BIGINT COMMENT 'Reference to the switching order or planned maintenance work order that caused this customer interruption. Populated for planned outages; null for unplanned events.',
  `service_point_id` BIGINT COMMENT 'Reference to the specific service point (premise delivery point) associated with this customer interruption. Corresponds to the service point or premise identifier in the CIS and GIS.',
  `trouble_call_id` BIGINT COMMENT 'Reference identifier for the customer trouble call or service request that reported this outage, as recorded in the Customer Information System (CIS) or CRM. Populated when customer_reported_flag is True.',
  `account_number` STRING COMMENT 'The externally-known customer account number as assigned by the Customer Information System (CIS). Used for customer-facing communications and regulatory impact reporting.',
  `advance_notice_hours` DECIMAL(5,2) COMMENT 'Number of hours of advance notice provided to this customer prior to a planned interruption. Used to verify compliance with PUC minimum advance notification requirements for planned outages (typically 48–72 hours).',
  `cause_code` STRING COMMENT 'Standardized cause code classifying the root cause of the outage affecting this customer (e.g., equipment failure, tree contact, animal contact, weather, vehicle accident). Sourced from OMS cause code taxonomy aligned with EEI/NERC reporting categories. Reference-value candidates: equipment_failure|tree_contact|animal_contact|weather|vehicle_accident|scheduled_maintenance|unknown|other.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this affected customer association record was first created in the system, typically when the outage event was declared and customer impact was identified by the OMS.',
  `critical_care_flag` BOOLEAN COMMENT 'Indicates whether the customer at this service point is registered as a critical care or life support customer (e.g., medical baseline, home oxygen, dialysis). Critical care customers receive priority restoration and mandatory advance notification per PUC regulations.',
  `critical_care_type` STRING COMMENT 'Specific type of critical care or life support designation for the affected customer. Populated only when critical_care_flag is True. Classified as restricted health information per HIPAA and state PUC medical baseline program rules. Valid values: medical_baseline|life_support|home_oxygen|dialysis|other.',
  `customer_class` STRING COMMENT 'Regulatory and rate classification of the customer affected by the outage. Used for segmented reliability reporting and prioritization of restoration efforts per PUC requirements. Valid values: residential|commercial|industrial|agricultural|municipal.',
  `customer_reported_flag` BOOLEAN COMMENT 'Indicates whether this outage was identified through a customer trouble call or self-reported via web/app, as opposed to being detected automatically via AMI last-gasp, SCADA, or OMS prediction. Used for outage detection source analysis.',
  `data_source_system` STRING COMMENT 'Identifies the operational source system from which this affected customer record was ingested into the Silver Layer lakehouse. Used for data lineage, reconciliation, and audit purposes. Valid values: GE_PowerOn_ADMS|SAP_ISU|Oracle_CCB|Oracle_MDM|ArcGIS|manual.',
  `der_customer_flag` BOOLEAN COMMENT 'Indicates whether the affected customer has a registered Distributed Energy Resource (DER) such as rooftop solar, battery storage, or a Net Energy Metering (NEM) arrangement. Relevant for assessing behind-the-meter (BTM) resilience and grid impact during outages.',
  `estimated_restoration_timestamp` TIMESTAMP COMMENT 'The estimated date and time of power restoration communicated to this customer. Corresponds to the Estimated Restoration Time (ERT) published in customer-facing outage communications and OMS crew dispatch workflows.',
  `interruption_duration_minutes` INT COMMENT 'Total duration of the power interruption at this customer service point in minutes, calculated from interruption start to end timestamp. Used directly in SAIDI (System Average Interruption Duration Index) and CAIDI (Customer Average Interruption Duration Index) regulatory reporting.',
  `interruption_end_timestamp` TIMESTAMP COMMENT 'The date and time when power supply was restored at this customer service point. Null if restoration has not yet occurred. Used in SAIDI/CAIDI duration calculations.',
  `interruption_start_timestamp` TIMESTAMP COMMENT 'The date and time when power supply was interrupted at this customer service point. Used as the principal business event timestamp for SAIDI/SAIFI/CAIDI reliability index calculations and regulatory reporting.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this affected customer association record was most recently modified, such as when restoration status was updated, notification was sent, or duration was recalculated.',
  `major_event_flag` BOOLEAN COMMENT 'Indicates whether this customer interruption is associated with a declared Major Event Day (MED) per IEEE 1366 criteria. Major event interruptions are excluded from standard SAIDI/SAIFI calculations and reported separately to regulators.',
  `momentary_flag` BOOLEAN COMMENT 'Indicates whether this interruption is classified as a momentary interruption (duration under 5 minutes per IEEE 1366 definition). Momentary interruptions are counted in MAIFI (Momentary Average Interruption Frequency Index) rather than SAIDI/SAIFI.',
  `notification_channel` STRING COMMENT 'The communication channel used to deliver the outage notification to this customer (e.g., SMS text, email, Interactive Voice Response (IVR) call, mobile app push notification). Supports multi-channel outage communication tracking. Valid values: sms|email|ivr|app_push|none.',
  `notification_sent_flag` BOOLEAN COMMENT 'Indicates whether an outage notification has been sent to this customer for the associated outage event. Used to track compliance with PUC customer notification requirements.',
  `notification_timestamp` TIMESTAMP COMMENT 'The date and time when the outage notification was sent to this customer. Used for regulatory compliance reporting on customer notification timeliness.',
  `oms_customer_ref` STRING COMMENT 'External customer reference identifier as recorded in the Outage Management System (OMS), used for cross-system reconciliation between OMS and CIS records.',
  `outage_type` STRING COMMENT 'Classification of the outage event type affecting this customer. \'unplanned\' = unexpected fault-driven interruption, \'planned\' = scheduled maintenance window, \'momentary\' = interruption under 5 minutes per IEEE 1366, \'major_event\' = declared major event excluded from standard reliability indices. Valid values: unplanned|planned|momentary|major_event.',
  `planned_interruption_end_timestamp` TIMESTAMP COMMENT 'The originally scheduled end time of the planned maintenance interruption for this customer service point. Populated only for planned outages. Compared against actual interruption_end_timestamp for schedule adherence reporting.',
  `planned_interruption_start_timestamp` TIMESTAMP COMMENT 'The originally scheduled start time of the planned maintenance interruption for this customer service point. Populated only for planned outages. Compared against actual interruption_start_timestamp for schedule adherence reporting.',
  `regulatory_exclusion_reason` STRING COMMENT 'Reason code indicating why this customer interruption is excluded from standard IEEE 1366 reliability index calculations. \'major_event\' = IEEE 1366 MED exclusion, \'planned\' = scheduled maintenance exclusion, \'momentary\' = under 5-minute threshold, \'none\' = included in standard indices. Valid values: major_event|planned|momentary|none.',
  `restoration_confirmation_method` STRING COMMENT 'The method by which power restoration was confirmed at this customer service point. \'ami_signal\' = AMI meter power-on event, \'crew_verification\' = field crew confirmation, \'customer_callback\' = customer reported power restored, \'scada\' = SCADA system indication. Valid values: ami_signal|crew_verification|customer_callback|scada|none.',
  `restoration_confirmed_flag` BOOLEAN COMMENT 'Indicates whether power restoration at this customer service point has been confirmed, either via AMI last-gasp/power-on signal, crew field verification, or customer callback. Distinguishes crew-reported restoration from confirmed restoration.',
  `restoration_status` STRING COMMENT 'Current restoration lifecycle status for this customer service point. \'interrupted\' = power out, \'restored\' = power confirmed back, \'partial\' = partial restoration, \'pending_confirmation\' = crew reports restored but not yet confirmed, \'excluded\' = excluded from reliability indices per IEEE 1366 major event criteria. Valid values: interrupted|restored|partial|pending_confirmation|excluded.',
  `saidi_contribution_minutes` DECIMAL(10,4) COMMENT 'This customer\'s individual contribution to the SAIDI reliability index in customer-minutes. Equals the interruption duration in minutes for this customer record. Aggregated across all affected customers to compute system-level SAIDI per IEEE 1366.',
  `saifi_contribution` DECIMAL(10,6) COMMENT 'This customer\'s individual contribution to the SAIFI reliability index (value of 1 per sustained interruption, 0 for momentary). Aggregated across all affected customers to compute system-level SAIFI per IEEE 1366.',
  `service_point_number` STRING COMMENT 'The externally-known alphanumeric identifier for the customer service point (premise delivery point) where the interruption occurred. Used in field crew dispatch and restoration confirmation.',
  `service_territory_code` STRING COMMENT 'Code identifying the regulated service territory in which this customer service point is located. Used for jurisdictional reliability reporting to the applicable State Public Utility Commission (PUC).',
  `storm_event_flag` BOOLEAN COMMENT 'Indicates whether this customer interruption occurred during a declared storm or major weather event. Used for storm response performance reporting and potential major event day exclusion analysis.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_outage_affected_customer` PRIMARY KEY (`affected_customer_id`)
)
USING DELTA
COMMENT 'Association record linking a specific customer service point to an outage event or planned maintenance window, capturing the customer-level impact. Records customer account reference, service point identifier, interruption start and end times, duration, notification sent flag, notification channel, critical care flag (medical baseline, life support), and restoration confirmation. Enables customer-facing outage communication and regulatory customer impact reporting. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AffectedCustomer',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.affected_customer'
);

-- CustomerNotification  <<CIM CustomerNotification : close>>
CREATE TABLE IF NOT EXISTS `outage`.`customer_notification` (
  `customer_notification_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for each customer notification record in the outage management system. Primary key for the customer_notification data product.',
  `account_id` BIGINT COMMENT 'Reference to the customer account receiving this notification. Sourced from the Customer Information System (CIS) in SAP IS-U or Oracle CC&B.',
  `customer_preference_id` BIGINT COMMENT 'Reference to the customer\'s communication preference profile that governed channel selection and opt-in/opt-out status at the time this notification was generated. Enables preference-driven communication auditing.',
  `etr_revision_id` BIGINT COMMENT 'FK to outage.etr_revision.etr_revision_id — ETR update notifications are triggered by ETR revisions. This FK enables audit trail from revision to customer communication.',
  `event_id` BIGINT COMMENT 'Reference to the outage event that triggered this notification. Links the notification to the specific unplanned interruption or planned maintenance window in the Outage Management System (OMS).',
  `message_template_id` BIGINT COMMENT 'Reference to the approved message template used to compose this notification. Templates are pre-approved for regulatory compliance and brand consistency. Enables template performance analytics and A/B testing of communication effectiveness.',
  `service_point_id` BIGINT COMMENT 'Reference to the specific service delivery point (premise) affected by the outage for which this notification was issued. Enables geographic and network-level analysis of notification coverage.',
  `acknowledgment_timestamp` TIMESTAMP COMMENT 'Timestamp when the customer acknowledged receipt of this notification. Null if no acknowledgment was received. Used for life-support welfare check compliance and two-way communication analytics.',
  `advance_notice_hours` DECIMAL(6,2) COMMENT 'Number of hours of advance notice provided to the customer prior to a planned outage, calculated as the difference between notification sent timestamp and planned outage start timestamp. Used to verify compliance with state PUC minimum advance notice requirements (typically 48–72 hours).',
  `cause_description` STRING COMMENT 'Human-readable description of the outage cause as communicated to the customer in this notification (e.g., \'equipment failure on Main St. feeder\', \'storm damage to transmission line\'). Supports customer transparency and regulatory reporting.',
  `cis_account_number` STRING COMMENT 'The customer account number as recorded in the Customer Information System (CIS) — SAP IS-U or Oracle CC&B — at the time of notification. Provides a direct cross-reference to the billing and service account for regulatory audit and dispute resolution.',
  `contact_address` STRING COMMENT 'The specific contact address (email address, phone number, or device token) used for this notification delivery attempt, as resolved from the customer\'s preference profile. Stored for audit and delivery confirmation purposes. Classified as restricted PII.',
  `created_timestamp` TIMESTAMP COMMENT 'Audit timestamp when this notification record was first created in the outage management system. Supports data lineage, audit trail, and regulatory record-keeping requirements.',
  `customer_acknowledgment_flag` BOOLEAN COMMENT 'Indicates whether the customer explicitly acknowledged receipt of this notification (e.g., via IVR keypress, SMS reply, or mobile app confirmation). True = acknowledged. Supports two-way communication tracking and life-support customer welfare checks.',
  `customers_affected_count` INT COMMENT 'Total number of customers affected by the associated outage event at the time this notification was generated. Included in the notification for context and used in SAIFI (System Average Interruption Frequency Index) reporting.',
  `delivered_timestamp` TIMESTAMP COMMENT 'Timestamp when delivery confirmation was received from the channel provider, confirming the notification reached the customer\'s device, inbox, or IVR endpoint. Null if delivery has not been confirmed or failed.',
  `delivery_status` STRING COMMENT 'Current lifecycle state of the notification delivery attempt. pending: queued for dispatch; sent: transmitted to channel provider; delivered: confirmed receipt by customer device or inbox; failed: delivery attempt unsuccessful; bounced: message returned undeliverable; opted_out: customer has opted out of this channel. Valid values: pending|sent|delivered|failed|bounced|opted_out.',
  `etr_timestamp` TIMESTAMP COMMENT 'The Estimated Time to Restore (ETR) communicated to the customer in this notification. Represents the utility\'s best estimate of when power will be restored to the affected service point. Critical for customer satisfaction and regulatory ETR accuracy reporting.',
  `failure_reason` STRING COMMENT 'Reason code for notification delivery failure when delivery_status is \'failed\' or \'bounced\'. Supports channel quality monitoring, contact data hygiene initiatives, and SLA root cause analysis. Reference-value candidates: invalid_contact|channel_unavailable|provider_error|customer_opted_out|number_disconnected|mailbox_full|unknown.',
  `language_code` STRING COMMENT 'ISO 639-1 language code (optionally with ISO 3166-1 country subtag) of the language in which the notification was composed and delivered. Supports multilingual customer communication compliance requirements mandated by state PUCs in diverse service territories. Pattern: ^[a-z]{2}(-[A-Z]{2})?$.',
  `last_retry_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent delivery retry attempt for this notification. Null if no retries have been attempted. Used in conjunction with retry_count to assess delivery persistence and channel failure patterns.',
  `life_support_flag` BOOLEAN COMMENT 'Indicates whether the customer is registered as a life support or medical baseline customer at the time of this notification. True = life support customer. Triggers priority notification handling and regulatory reporting obligations under state PUC medical baseline rules.',
  `message_body` STRING COMMENT 'Full text content of the notification message as delivered to the customer, including outage details, Estimated Time to Restore (ETR), and restoration instructions. Stored for regulatory audit and dispute resolution.',
  `message_subject` STRING COMMENT 'Subject line or headline of the notification as delivered to the customer. Applicable primarily to email and mobile app push notifications. Stored for audit, regulatory review, and communication effectiveness analysis.',
  `notification_batch_number` STRING COMMENT 'Identifier for the batch or campaign in which this notification was grouped and dispatched. Multiple customer notifications for the same outage event are typically dispatched in batches. Supports batch-level delivery performance analysis and storm response coordination.',
  `notification_channel` STRING COMMENT 'Communication channel through which the notification was dispatched to the customer. IVR: Interactive Voice Response automated call; SMS: text message; email: electronic mail; mobile_app: push notification via utility mobile application; web_portal: in-portal alert; postal_mail: physical letter for regulatory advance notice. Valid values: ivr|sms|email|mobile_app|web_portal|postal_mail.',
  `notification_number` STRING COMMENT 'Externally visible, human-readable business identifier for this notification record. Used in customer correspondence, regulatory audit trails, and SLA compliance tracking. Format: NTF- followed by 10-digit sequence. Pattern: ^NTF-[0-9]{10}$.',
  `notification_priority` STRING COMMENT 'Priority level assigned to this notification, governing dispatch queue order and retry escalation logic. Critical priority is used for life-support customers and medical baseline accounts. Supports regulatory requirements for prioritized restoration communication. Valid values: critical|high|standard|low.',
  `notification_to_outage_event` BIGINT COMMENT 'FK to outage.outage_event.outage_event_id — Customer notifications are triggered by outage events (alerts, ETR updates, restoration confirmations). Must link to the event for communication audit trail.',
  `notification_type` STRING COMMENT 'Classification of the notification purpose. outage_alert: initial unplanned outage alert; etr_update: Estimated Time to Restore (ETR) revision; restoration_confirmation: power restored confirmation; planned_outage_notice: advance notice of scheduled maintenance; safety_alert: safety-related communication; demand_response_event: Demand Response (DR) program event notice. Valid values: outage_alert|etr_update|restoration_confirmation|planned_outage_notice|safety_alert|demand_response_event.',
  `oms_notification_ref` STRING COMMENT 'External reference identifier assigned by the Outage Management System (OMS), specifically GE PowerOn ADMS, to this notification record. Enables bidirectional traceability between the lakehouse silver layer and the operational OMS source system.',
  `opt_out_flag` BOOLEAN COMMENT 'Indicates whether the customer had opted out of this notification channel or notification type at the time of dispatch. True = customer opted out; notification may have been suppressed or sent via alternate channel per preference rules. Critical for TCPA and state PUC opt-out compliance.',
  `outage_start_timestamp` TIMESTAMP COMMENT 'The timestamp of the outage event start as communicated to the customer in this notification. Provides the customer with context on when the interruption began. Used in SAIDI/SAIFI/CAIDI reliability index calculations.',
  `outage_type` STRING COMMENT 'Classification of the outage event type associated with this notification. Distinguishes between unplanned interruptions, scheduled maintenance windows, storm-related events, equipment failures, and transmission faults. Supports SAIDI/SAIFI/CAIDI reliability metric segmentation. Valid values: unplanned|planned|storm_related|equipment_failure|transmission_fault.',
  `planned_outage_end_timestamp` TIMESTAMP COMMENT 'For planned maintenance outage notifications, the scheduled end time of the planned interruption communicated to the customer. Null for unplanned outage notifications. Supports advance notice compliance and customer impact duration communication.',
  `planned_outage_start_timestamp` TIMESTAMP COMMENT 'For planned maintenance outage notifications, the scheduled start time of the planned interruption communicated to the customer. Null for unplanned outage notifications. Supports advance notice compliance tracking required by state PUCs.',
  `regulatory_notice_flag` BOOLEAN COMMENT 'Indicates whether this notification fulfills a specific regulatory advance notice obligation (e.g., state PUC-mandated 48-hour advance notice for planned outages). True = this notification is a regulatory compliance notice. Supports regulatory reporting and audit evidence.',
  `retry_count` INT COMMENT 'Number of delivery retry attempts made for this notification after an initial failure. Used to track delivery persistence, diagnose channel reliability issues, and support SLA compliance reporting.',
  `sent_timestamp` TIMESTAMP COMMENT 'The principal real-world event timestamp when the notification was dispatched from the utility\'s outage communication platform to the delivery channel provider. Used as the primary business event time for SLA measurement and regulatory compliance reporting.',
  `sla_met_flag` BOOLEAN COMMENT 'Indicates whether this notification was dispatched within the required Service Level Agreement (SLA) target time. True = SLA met; False = SLA breached. Supports regulatory SLA compliance reporting to state PUCs and internal performance dashboards.',
  `sla_target_minutes` INT COMMENT 'The Service Level Agreement (SLA) target time in minutes within which this notification type must be dispatched following the triggering outage event. Defined by state PUC regulations and internal communication standards. Used as the benchmark for SLA compliance measurement.',
  `source_system` STRING COMMENT 'Identifies the operational system of record that originated this notification record. Primarily GE PowerOn ADMS for OMS-driven notifications, but may include SAP IS-U, Oracle CC&B for billing-related outage notices, or manual OMS entries during storm response. Valid values: GE_PowerOn_ADMS|SAP_ISU|Oracle_CCB|OMS_Manual|DERMS.',
  `territory_code` STRING COMMENT 'Code identifying the utility\'s service territory or operating division within which the affected customer and service point are located. Supports territory-level SLA compliance reporting to individual state PUCs and regional storm response performance analysis. Pattern: ^[A-Z]{2,6}$.',
  `to_outage_event` BIGINT COMMENT 'FK to outage.outage_event.outage_event_id — Notifications are sent in the context of an outage event or planned outage. Required for communication SLA compliance tracking.',
  `updated_timestamp` TIMESTAMP COMMENT 'Audit timestamp of the most recent modification to this notification record, such as a delivery status update or retry attempt. Supports change tracking and SLA audit.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_outage_customer_notification` PRIMARY KEY (`customer_notification_id`)
)
USING DELTA
COMMENT 'Record of outage-related notifications sent to customers via IVR, SMS, email, or mobile app. Captures notification type (outage alert, ETR update, restoration confirmation, planned outage advance notice), channel, delivery timestamp, delivery status, customer preference reference, and opt-out flag. Supports regulatory requirements for advance notice of planned outages and tracks communication SLA compliance. | CMM: CIM CustomerNotification (close), IEC61968::Customers.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CustomerNotification',
  'cmm.cim.class' = 'CustomerNotification',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Customers',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.customer_notification'
);

-- EventStatusHistory  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `outage`.`event_status_history` (
  `event_status_history_id` BIGINT NOT NULL COMMENT 'Primary key for event_status_history',
  `crew_id` BIGINT COMMENT 'Identifier of the field crew associated with this status transition, particularly relevant for CREW_DISPATCHED and PARTIAL_RESTORE transitions. Links to the crew or work order management record in Ventyx Asset Suite or SAP S/4HANA Plant Maintenance.',
  `employee_id` BIGINT COMMENT 'System identifier of the specific dispatcher, crew member, or automated system process that triggered this status transition. References the workforce or system actor record. Used for accountability auditing and OMS workflow traceability.',
  `event_id` BIGINT COMMENT 'Reference to the parent outage event whose lifecycle this status record belongs to. Links each status transition to the originating outage event in the OMS. Serves as the EVENT_SOURCE_REFERENCE for this event log entity.',
  `outage_switching_order_id` BIGINT COMMENT 'Reference to the switching order executed as part of this status transition, applicable when the OMS issues switching instructions to isolate faults or restore service segments. Links to the switching order record in GE PowerOn ADMS.',
  `work_order_id` BIGINT COMMENT 'Reference to the work order created or updated in conjunction with this status transition. Links the outage event status history to the maintenance and restoration work order in Ventyx Asset Suite or SAP S/4HANA Plant Maintenance for integrated O&M tracking.',
  `actual_restoration_time` TIMESTAMP COMMENT 'The actual date and time at which service was fully restored, populated only when status_code transitions to RESTORED. Used as the definitive restoration timestamp for SAIDI/SAIFI/CAIDI calculations and regulatory outage duration reporting. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `affected_customer_count` INT COMMENT 'Number of customers without power at the time of this status transition. Updated at each transition to reflect partial restorations. Used for SAIDI/SAIFI/CAIDI calculations, customer notification prioritization, and regulatory outage reporting to State PUCs and NERC.',
  `cause_code` STRING COMMENT 'Standardized cause classification code assigned or updated at this status transition point, following IEEE 1366 or utility-specific cause code taxonomy. May be refined as investigation progresses (e.g., initially UNKNOWN, later updated to EQUIPMENT_FAILURE or TREE_CONTACT). Reference-value candidates: UNKNOWN|EQUIPMENT_FAILURE|TREE_CONTACT|ANIMAL_CONTACT|WEATHER|VEHICLE_ACCIDENT|SCHEDULED_MAINTENANCE|OVERLOAD|THIRD_PARTY.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time at which this status history record was first created in the Silver layer data product. Distinct from transition_timestamp (the business event time). Used for data lineage, audit trail, and Silver layer ingestion monitoring. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `critical_facility_flag` BOOLEAN COMMENT 'Indicates whether one or more critical facilities (hospitals, emergency services, water treatment plants, NERC CIP-designated assets) are among the affected customers at this status transition. Triggers escalation protocols and mandatory regulatory notification timelines.',
  `ert_confidence_level` STRING COMMENT 'Dispatcher or system assessment of the confidence level in the estimated_restoration_time at this transition. Supports customer communication tiering (e.g., only publish ERT to customers when confidence is HIGH or MEDIUM) and ERT accuracy analytics. Valid values: HIGH|MEDIUM|LOW|UNKNOWN.',
  `estimated_restoration_time` TIMESTAMP COMMENT 'The estimated date and time by which full service restoration is expected, as assessed at the time of this status transition. ERT may be revised at each transition as field conditions evolve. Used for customer notifications, dispatcher planning, and regulatory ERT accuracy reporting. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `flisr_activated_flag` BOOLEAN COMMENT 'Indicates whether the GE PowerOn ADMS Fault Location, Isolation, and Service Restoration (FLISR) automation was activated during this status transition. FLISR activations represent automated restoration actions and are tracked separately for reliability performance and automation benefit reporting.',
  `major_event_day_flag` BOOLEAN COMMENT 'Indicates whether this status transition occurred during a declared IEEE 1366 Major Event Day (MED), where system-wide outage levels exceed the 2.5 beta threshold. MED-flagged records are excluded from normalized SAIDI/SAIFI regulatory reporting.',
  `notification_channel` STRING COMMENT 'The primary communication channel used to notify affected customers of this status transition. Populated when notification_sent_flag is True. Supports multi-channel notification analytics and State PUC communication compliance reporting. Valid values: SMS|IVR|EMAIL|APP_PUSH|NONE.',
  `notification_sent_flag` BOOLEAN COMMENT 'Indicates whether a customer notification (SMS, IVR, email, or app push) was dispatched to affected customers as a result of this status transition. Supports notification compliance tracking and customer communication audit trails per State PUC notification requirements.',
  `oms_event_number` STRING COMMENT 'The externally-known OMS event reference number assigned by GE PowerOn ADMS at the time of outage event creation. Carried on each status history record to enable direct cross-reference with OMS reports, dispatcher logs, and regulatory filings without requiring a join to the parent event table.',
  `outage_duration_minutes` INT COMMENT 'Elapsed duration in minutes from the initial outage report timestamp to this status transition timestamp. Provides a running duration metric at each lifecycle stage without requiring a join to the parent event. Used for real-time SAIDI contribution monitoring and SLA tracking.',
  `outage_type` STRING COMMENT 'Classification of the outage event type at the time of this status record. Distinguishes unplanned interruptions (equipment failure, fault), planned maintenance windows, storm-related events, and emergency outages. Denormalized from the parent event for efficient status history reporting and SAIDI/SAIFI segmentation. Valid values: UNPLANNED|PLANNED|STORM|EMERGENCY.',
  `previous_status_code` STRING COMMENT 'The OMS workflow state code that was active immediately before this transition occurred. Enables reconstruction of the full state machine path and supports regression analysis of outage event progressions. Null for the initial status record. Reference-value candidates: same. Valid values: REPORTED|INVESTIGATING|CREW_DISPATCHED|PARTIAL_RESTORE|RESTORED|CANCELLED.',
  `priority_level` STRING COMMENT 'Restoration priority classification assigned at this status transition, reflecting the urgency of restoration based on affected customer types (e.g., hospitals, critical infrastructure), customer count, and storm response protocols. Drives crew dispatch sequencing and resource allocation. Valid values: CRITICAL|HIGH|MEDIUM|LOW.',
  `regulatory_notification_required_flag` BOOLEAN COMMENT 'Indicates whether this status transition triggers a mandatory regulatory notification obligation to NERC, FERC, State PUC, or other governing bodies based on outage severity thresholds (e.g., NERC EOP-004 event reporting, State PUC major outage notification). Drives compliance workflow automation.',
  `regulatory_notification_sent_flag` BOOLEAN COMMENT 'Indicates whether the required regulatory notification has been submitted to the applicable governing body (NERC, FERC, State PUC) as of this status transition. Supports compliance audit trails and ensures no mandatory notifications are missed.',
  `restored_customer_count` INT COMMENT 'Cumulative number of customers whose service has been restored as of this status transition. Enables tracking of partial restoration progress and supports incremental SAIDI/SAIFI credit calculations. Particularly relevant for PARTIAL_RESTORE status transitions.',
  `scada_alarm_reference` STRING COMMENT 'Reference identifier of the SCADA alarm or event in OSIsoft PI or GE PowerOn ADMS that triggered or is associated with this status transition. Enables cross-system traceability between the OMS event lifecycle and real-time SCADA/EMS alarm data.',
  `source_system` STRING COMMENT 'Identifies the operational system of record that originated this status transition record. Primarily GE PowerOn ADMS for automated OMS transitions, but may include SAP IS-U, Oracle CC&B, or MANUAL for dispatcher-entered records. Supports data lineage and Silver layer reconciliation. Valid values: GE_POWERON_ADMS|SAP_ISU|ORACLE_CCB|MANUAL.',
  `source_system_record_code` STRING COMMENT 'The native record identifier assigned by the source system (e.g., GE PowerOn ADMS internal status log ID) for this status transition. Enables bidirectional traceability between the Silver layer and the operational system of record for reconciliation and audit purposes.',
  `status_code` STRING COMMENT 'Standardized OMS workflow state code representing the current lifecycle stage of the outage event at the time of this transition. Drives the OMS state machine and is used for SAIDI/SAIFI/CAIDI milestone tracking. Serves as the EVENT_TYPE_OR_CHANNEL discriminator for this event log. Reference-value candidates: REPORTED|INVESTIGATING|CREW_DISPATCHED|PARTIAL_RESTORE|RESTORED|CANCELLED|ON_HOLD|ESCALATED|PENDING_VERIFICATION. Valid values: REPORTED|INVESTIGATING|CREW_DISPATCHED|PARTIAL_RESTORE|RESTORED|CANCELLED.',
  `status_description` STRING COMMENT 'Human-readable label or narrative description corresponding to the status_code at the time of this transition. Provides dispatcher-facing context for the OMS workflow state and supports customer notification messaging. Serves as the EVENT_PAYLOAD_OR_VALUE for this event log.',
  `status_notes` STRING COMMENT 'Free-text notes entered by the dispatcher, crew, or system at the time of this status transition. Captures contextual information such as field conditions, equipment findings, partial restoration scope, or escalation reasons. Supports OMS audit trail and post-event analysis.',
  `storm_event_flag` BOOLEAN COMMENT 'Indicates whether this outage event is classified as part of a declared storm or major event at the time of this status transition. Storm-classified events are typically excluded from IEEE 1366 SAIDI/SAIFI calculations per the Major Event Day (MED) exclusion methodology.',
  `to_outage_event` BIGINT COMMENT 'FK to outage.outage_event.outage_event_id — Status history records belong to a parent outage event. This is the core audit trail FK for OMS workflow state machine.',
  `transition_sequence` INT COMMENT 'Ordinal sequence number of this status transition within the parent outage event lifecycle, starting at 1 for the initial reported status. Used to order status history records chronologically and to identify the current (latest) status without relying solely on timestamps.',
  `transition_timestamp` TIMESTAMP COMMENT 'The exact date and time (with timezone offset) at which the outage event transitioned into this status. This is the principal EVENT_TIMESTAMP for the log record and is used for SAIDI/SAIFI/CAIDI duration calculations and OMS audit trail. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `triggering_actor_name` STRING COMMENT 'Display name of the dispatcher, crew member, or automated system process that triggered this status transition. Retained for audit trail readability independent of workforce record changes. For system-triggered transitions, contains the system or process name (e.g., \'GE PowerOn ADMS Auto-Restore\').',
  `triggering_actor_type` STRING COMMENT 'Category of the actor (person, crew, or automated system) that initiated this status transition. Distinguishes between manual dispatcher actions, field crew updates, automated OMS/SCADA system triggers, customer-initiated reports, and supervisory overrides. Supports workflow accountability and automation rate analytics. Valid values: DISPATCHER|CREW|SYSTEM|CUSTOMER|SUPERVISOR.',
  `updated_timestamp` TIMESTAMP COMMENT 'The date and time at which this status history record was last modified in the Silver layer data product. Supports change detection, incremental processing, and audit trail requirements. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `volt_var_impact_flag` BOOLEAN COMMENT 'Indicates whether GE PowerOn ADMS Volt-VAR Optimization (VVO) actions were taken in conjunction with this status transition to manage voltage and reactive power during the outage or restoration. Supports grid operations analytics and ADMS performance reporting.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_outage_event_status_history` PRIMARY KEY (`event_status_history_id`)
)
USING DELTA
COMMENT 'Lifecycle status history of an outage event, capturing each state transition from initial report through investigation, crew dispatch, partial restoration, and full restoration. Records status code, transition timestamp, triggering actor (dispatcher, system, crew), and status notes. Enables full audit trail of outage event progression and supports OMS workflow state machine. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'EventStatusHistory',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.event_status_history'
);

-- StormEvent  <<CIM Incident : extension>>
CREATE TABLE IF NOT EXISTS `outage`.`storm_event` (
  `storm_event_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for the storm event record in the Outage Management System (OMS). Primary key for the storm_event entity.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Storm response costs are tracked to dedicated cost centers for PUC storm cost recovery filings, insurance claims, FEMA disaster reimbursement, and major event day (MED) cost exclusion from reliability',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Storm events impact specific forecast zones. Utilities track zone-level storm impacts for Major Event Day (MED) threshold calculations, mutual aid resource allocation, and regulatory reporting (IEEE 1',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Major storm events trigger specific regulatory reporting obligations (NERC EOP-004 emergency operations, state PUC emergency reporting requirements). Compliance teams track which obligations are activ',
  `service_territory_id` BIGINT COMMENT 'Reference to the primary service territory affected by the storm event. Links to the geographic service area definition used for regulatory reporting and customer impact scoping.',
  `affected_distribution_circuits` INT COMMENT 'Number of distribution circuits (below 69kV) that experienced outages or damage during this storm event. Key metric for distribution storm damage assessment and restoration prioritization.',
  `affected_region_description` STRING COMMENT 'Free-text description of the geographic area impacted by the storm, including counties, cities, or distribution circuits affected. Supplements the service territory reference for regulatory filings and public communications.',
  `affected_transmission_lines` INT COMMENT 'Number of transmission lines (69kV and above) that experienced outages or damage during this storm event. Used for NERC reliability reporting and transmission damage assessment.',
  `after_action_report_reference` STRING COMMENT 'Document management reference number or URL for the post-storm After-Action Report (AAR) filed following storm demobilization. Used for continuous improvement tracking and regulatory compliance.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time this storm event record was first created in the OMS or data platform. Used for audit trail and data lineage tracking.',
  `critical_facilities_affected` INT COMMENT 'Number of critical facilities (hospitals, emergency services, water treatment plants, shelters) that experienced power interruptions during this storm event. Drives restoration prioritization and regulatory reporting.',
  `customer_notification_issued` BOOLEAN COMMENT 'Indicates whether proactive customer notifications (via IVR, SMS, email, or web portal) were issued for this storm event. Supports PUC customer communication compliance tracking.',
  `declared_end_time` TIMESTAMP COMMENT 'The date and time at which the storm event was officially closed and storm response operations were demobilized. Null if the storm is still active.',
  `declared_start_time` TIMESTAMP COMMENT 'The date and time at which the storm event was officially declared by the utility\'s emergency operations center, triggering storm response activation. Principal business event timestamp for the storm lifecycle.',
  `emergency_operations_center_activated` BOOLEAN COMMENT 'Indicates whether the utility\'s Emergency Operations Center (EOC) was formally activated for this storm event. EOC activation triggers escalated staffing, executive involvement, and enhanced regulatory reporting obligations.',
  `eoc_activation_time` TIMESTAMP COMMENT 'Date and time the Emergency Operations Center (EOC) was formally activated for this storm event. Null if EOC was not activated.',
  `eoc_deactivation_time` TIMESTAMP COMMENT 'Date and time the Emergency Operations Center (EOC) was formally deactivated following storm response demobilization. Null if EOC is still active.',
  `estimated_storm_cost_usd` DECIMAL(18,2) COMMENT 'Estimated total cost of storm response operations in US dollars, including labor (internal and mutual aid), materials, equipment, and contractor costs. Used for regulatory cost recovery filings and executive reporting. Actual costs tracked in SAP S/4HANA.',
  `external_crews_deployed` INT COMMENT 'Actual number of external line crews that arrived and were deployed during this storm event. Compared against requested count for mutual aid effectiveness analysis.',
  `external_crews_requested` INT COMMENT 'Number of external line crews requested through mutual aid for this storm event. Used for resource planning, cost tracking, and post-storm mutual aid reconciliation.',
  `fema_disaster_declaration_number` STRING COMMENT 'FEMA federal disaster declaration number associated with this storm event, if applicable. Required for federal cost reimbursement claims and regulatory filings when a presidential disaster declaration is issued.',
  `first_customer_notification_time` TIMESTAMP COMMENT 'Date and time the first proactive customer notification was issued for this storm event. Used for PUC compliance reporting on customer communication timeliness.',
  `incident_commander` STRING COMMENT 'Name of the designated Incident Commander responsible for overall storm response operations under the Incident Command System (ICS). Used for accountability, communications, and post-storm after-action review.',
  `is_major_event_day` BOOLEAN COMMENT 'Indicates whether this storm event qualifies as a Major Event Day (MED) per IEEE 1366-2012 statistical threshold methodology. When True, outages during this event are excluded from SAIDI/SAIFI/CAIDI reliability index calculations for regulatory reporting.',
  `is_mutual_aid_requested` BOOLEAN COMMENT 'Indicates whether mutual aid from other utilities or the regional mutual aid group was formally requested for this storm event. Triggers mutual aid tracking, cost allocation, and regulatory reporting obligations.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time this storm event record was most recently modified. Used for change tracking, data freshness monitoring, and audit compliance.',
  `med_threshold_saidi` DECIMAL(10,4) COMMENT 'The calculated SAIDI threshold value (in minutes per customer) used to determine MED qualification for this event year, per IEEE 1366-2012 beta method. Stored for audit and regulatory verification purposes.',
  `meteorological_end_time` TIMESTAMP COMMENT 'The date and time the weather event physically ended impacting the service territory per NWS or internal meteorological data. Used for IEEE 1366 MED exclusion period boundary calculations.',
  `meteorological_start_time` TIMESTAMP COMMENT 'The date and time the weather event physically began impacting the service territory, as reported by the National Weather Service or internal meteorological data. May precede the declared start time.',
  `mutual_aid_coordinator` STRING COMMENT 'Name of the regional mutual aid coordinator organization or agreement (e.g., \'EEI Mutual Aid\', \'Southeast Mutual Aid Group\') through which external crews were requested.',
  `mutual_aid_request_time` TIMESTAMP COMMENT 'Date and time the formal mutual aid request was submitted to the regional mutual aid coordinator or neighboring utilities. Null if no mutual aid was requested.',
  `nerc_event_type` STRING COMMENT 'NERC event classification code for mandatory regulatory reporting. EEA1/EEA2/EEA3 indicate Emergency Energy Alert levels; MEA indicates a Misoperation Event Alert; OE417 indicates a DOE Electric Emergency Incident and Disturbance Report filing requirement. Reference-value candidates: EEA1|EEA2|EEA3|MEA|OE417|other|not_applicable.',
  `nws_storm_code` STRING COMMENT 'External identifier assigned by the National Weather Service (NWS) to the weather event, used to cross-reference official meteorological data, storm tracks, and NWS storm reports for regulatory and insurance purposes.',
  `oe417_filing_required` BOOLEAN COMMENT 'Indicates whether this storm event meets the threshold requiring a DOE OE-417 Electric Emergency Incident and Disturbance Report filing. Triggered when 50,000+ customers are affected or critical infrastructure is impacted.',
  `oe417_filing_timestamp` TIMESTAMP COMMENT 'Date and time the DOE OE-417 Electric Emergency Incident and Disturbance Report was submitted for this storm event. Null if filing not required or not yet submitted.',
  `peak_customers_affected` INT COMMENT 'Maximum number of customers simultaneously without power at any point during the storm event. Key metric for regulatory reporting, mutual aid justification, and public communications. Sourced from OMS outage aggregation.',
  `puc_notification_required` BOOLEAN COMMENT 'Indicates whether this storm event requires formal notification to the state Public Utility Commission (PUC) per state-specific emergency reporting thresholds (e.g., >10% of customers affected or extended outage duration).',
  `puc_notification_timestamp` TIMESTAMP COMMENT 'Date and time the formal notification was submitted to the state Public Utility Commission (PUC) for this storm event. Null if notification not required or not yet submitted.',
  `response_activation_level` INT COMMENT 'Numeric level (1–5) indicating the severity of the storm response activation, where Level 1 is routine and Level 5 is maximum emergency mobilization. Determines staffing, resource deployment, and executive notification thresholds.',
  `response_status` STRING COMMENT 'Current lifecycle state of the storm response operation. Drives workflow routing in OMS and determines whether mutual aid, crew dispatch, and cost tracking are active. Valid values: declared|active|demobilizing|closed|cancelled.',
  `storm_cost_reference` STRING COMMENT 'Reference code linking this storm event to the corresponding cost collection object in SAP S/4HANA (e.g., WBS element, internal order, or cost center) for storm cost tracking, regulatory cost recovery filings, and OPEX reporting.',
  `storm_name` STRING COMMENT 'Human-readable name assigned to the storm event (e.g., \'Hurricane Ida\', \'Winter Storm Uri\', \'Derecho 2023-07\'). Used for communications, regulatory reporting, and historical reference.',
  `storm_notes` STRING COMMENT 'Free-text operational notes and situational awareness comments entered by storm coordinators during the event lifecycle. Captures key decisions, escalations, and observations not captured in structured fields.',
  `storm_number` STRING COMMENT 'Externally-known business identifier for the storm event, used in OMS, regulatory filings, and mutual aid coordination. Format: STM-{YYYY}-{NNNNN}. Pattern: ^STM-[0-9]{4}-[0-9]{5}$.',
  `storm_to_outage_events` BIGINT COMMENT 'FK to outage.outage_event.outage_event_id — A storm event groups multiple outage events under coordinated response. This parent-child link is essential for storm response management and MED calculations.',
  `storm_type` STRING COMMENT 'Classification of the weather event type driving storm response operations. Determines response protocols, mutual aid triggers, and IEEE 1366 Major Event Day (MED) classification criteria. Reference-value candidates: hurricane|ice_storm|derecho|tornado|heat_event|winter_storm|thunderstorm|flood|wildfire|other.',
  `total_customer_interruptions` INT COMMENT 'Cumulative count of individual customer interruption events associated with this storm, accounting for customers who experienced multiple outages. Used in SAIFI calculation inputs for IEEE 1366 reporting.',
  `total_outage_events` INT COMMENT 'Total number of discrete outage events (trouble calls, switching events, fault isolations) grouped under this storm event in the OMS. Used for storm complexity assessment and resource planning.',
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
  CONSTRAINT `pk_outage_storm_event` PRIMARY KEY (`storm_event_id`)
)
USING DELTA
COMMENT 'Master record for a declared storm or major weather event that triggers storm response operations. Captures storm name, storm type (hurricane, ice storm, derecho, tornado, heat event), declared start and end times, affected service territory, Major Event Day (MED) declaration flag per IEEE 1366, storm response activation level (e.g., Level 1-5), mutual aid request flag, total estimated affected customers at peak, and storm cost tracking reference. Parent entity for grouping multiple outage events and mutual aid requests under a single coordinated storm response. | CMM: CIM Incident (extension), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'StormEvent',
  'cmm.cim.class' = 'Incident',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.storm_event',
  'cmm.gis.location.role' = 'Incident.Location'
);

-- MutualAidRequest  <<CIM Request : close>>
CREATE TABLE IF NOT EXISTS `outage`.`mutual_aid_request` (
  `mutual_aid_request_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for the mutual aid request record. Primary key for this entity in the Silver Layer lakehouse.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Mutual aid costs (crew deployment, equipment, lodging) are charged to cost centers for reimbursement tracking, interstate billing, and regulatory reporting. Required for cost recovery from requesting',
  `event_id` BIGINT COMMENT 'Reference to the outage event that triggered this mutual aid request. Links the aid request to the specific storm, major outage, or emergency event driving the need for external resources.',
  `mutual_storm_event_id` BIGINT COMMENT 'FK to outage.storm_event.storm_event_id — Mutual aid requests are issued in response to storm events. Required for storm cost tracking and NERC EOP mutual aid reporting.',
  `primary_storm_event_id` BIGINT COMMENT 'FK to outage.storm_event.storm_event_id — Mutual aid requests are issued in context of a storm event. Must link to parent storm for coordination and cost tracking.',
  `regulatory_correspondence_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_correspondence. Business justification: Mutual aid coordination often involves regulatory notifications and correspondence with state commissions or NERC regarding emergency response. Emergency operations centers document regulatory communi',
  `acknowledgement_timestamp` TIMESTAMP COMMENT 'Date and time when the responding utility formally acknowledged receipt of the mutual aid request. Used to measure response time SLA compliance.',
  `actual_cost_usd` DECIMAL(18,2) COMMENT 'Actual total cost in US dollars incurred for the mutual aid deployment upon demobilization, as submitted by the responding utility for reimbursement. Populated after demobilization and cost reconciliation.',
  `affected_customers_count` INT COMMENT 'Number of customers without power at the time the mutual aid request was issued. Provides context for the scale of the outage event and justifies the level of external resource request.',
  `arrival_date` DATE COMMENT 'Actual date on which the responding utility\'s crews arrived at the staging area or work location within the requesting utility\'s service territory and became available for restoration work.',
  `commitment_timestamp` TIMESTAMP COMMENT 'Date and time when the responding utility formally committed to providing the requested resources, transitioning the request from acknowledged to committed status.',
  `cost_reimbursement_flag` BOOLEAN COMMENT 'Indicates whether the requesting utility has agreed to reimburse the responding utility for costs incurred during the mutual aid deployment. True = reimbursable; False = non-reimbursable (goodwill aid). Drives cost tracking and invoice generation workflows.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this mutual aid request record was first created in the system. Audit trail field for data lineage and compliance purposes.',
  `crew_count_committed` INT COMMENT 'Number of crew units actually committed by the responding utility. May be less than crew_count_requested if the responding utility has limited available resources.',
  `crew_count_deployed` INT COMMENT 'Actual number of crew units that physically arrived and performed restoration work in the requesting utility\'s territory. May differ from committed count due to last-minute changes or attrition during transit.',
  `crew_count_requested` INT COMMENT 'Number of crew units (typically crew trucks or work teams) requested from the responding utility. A crew unit typically consists of a truck and associated personnel per ESOP standards.',
  `crew_type_committed` STRING COMMENT 'Classification of crew type actually committed by the responding utility. May differ from crew_type_requested if the responding utility can only provide a partial or alternative resource match. Reference-value candidates: line_crew|tree_crew|damage_assessment|substation|transmission|logistics.',
  `crew_type_requested` STRING COMMENT 'Classification of crew type requested by the requesting utility (e.g., line crew, tree trimming crew, damage assessment crew, substation crew, transmission crew, logistics crew). Drives resource matching in ESOP coordination. Reference-value candidates: line_crew|tree_crew|damage_assessment|substation|transmission|logistics.',
  `demobilization_date` DATE COMMENT 'Actual date on which the responding utility\'s crews completed their assignment and were released to return to their home utility. Marks the end of active mutual aid deployment.',
  `equipment_count_committed` INT COMMENT 'Number of equipment units of the specified type actually committed by the responding utility.',
  `equipment_count_requested` INT COMMENT 'Number of equipment units of the specified type requested from the responding utility.',
  `equipment_type_requested` STRING COMMENT 'Type of specialized equipment requested alongside crews, such as bucket trucks, digger derricks, cable pullers, generators, or mobile command units. Supplements crew type in resource matching.',
  `esop_reference_number` STRING COMMENT 'Reference number of the Emergency Support Operations Plan (ESOP) or mutual aid agreement under which this request is issued. Ties the request to the governing bilateral or regional aid compact.',
  `estimated_cost_usd` DECIMAL(18,2) COMMENT 'Estimated total cost in US dollars for the mutual aid deployment, including labor, equipment, lodging, and travel expenses. Used for budget planning and pre-authorization of reimbursable aid.',
  `event_type` STRING COMMENT 'Classification of the weather or emergency event that triggered the mutual aid request. Used for post-event analysis, NERC regulatory reporting, and storm response benchmarking. Reference-value candidates: hurricane|ice_storm|tornado|wildfire|flood|earthquake|major_outage|other.',
  `invoice_number` STRING COMMENT 'Invoice number issued by the responding utility to the requesting utility for cost reimbursement of mutual aid services. Links to the accounts receivable/payable process in SAP S/4HANA.',
  `invoice_status` STRING COMMENT 'Current status of the cost reimbursement invoice associated with this mutual aid request. Tracks the financial settlement lifecycle from invoice submission through payment or dispute resolution. Valid values: not_applicable|pending|submitted|approved|paid|disputed.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this mutual aid request record was most recently modified. Supports change tracking, audit compliance, and Silver Layer incremental processing.',
  `mobilization_date` DATE COMMENT 'Planned or actual date on which the committed crews and resources depart from the responding utility and begin travel to the requesting utility\'s service territory.',
  `nerc_reportable_flag` BOOLEAN COMMENT 'Indicates whether this mutual aid request must be reported to NERC under EOP-005-3 or other applicable reliability standards. True = reportable event requiring NERC submission.',
  `nerc_submission_timestamp` TIMESTAMP COMMENT 'Date and time when this mutual aid event was submitted to NERC for regulatory reporting. Null if nerc_reportable_flag is False or submission is pending.',
  `notes` STRING COMMENT 'Free-text field for operational notes, special instructions, or coordination details associated with the mutual aid request. May include staging instructions, safety briefing requirements, or special equipment needs.',
  `oms_event_reference` STRING COMMENT 'Reference identifier from the Outage Management System (GE PowerOn ADMS) for the outage event associated with this mutual aid request. Enables traceability between the aid request and the OMS event record.',
  `priority_level` STRING COMMENT 'Priority classification of the mutual aid request, reflecting the severity of the outage event and urgency of resource need. Drives dispatch sequencing when multiple requests compete for limited responding utility resources. Valid values: critical|high|medium|low.',
  `regional_mutual_aid_group` STRING COMMENT 'Name of the regional mutual aid compact or group under which this request is coordinated (e.g., Southeast Electric Exchange, Mid-Atlantic Mutual Aid Group, Midwest Mutual Aid Group). Identifies the regional coordination framework.',
  `request_date` TIMESTAMP COMMENT 'Date and time when the mutual aid request was formally submitted by the requesting utility. Serves as the principal business event timestamp for the request lifecycle.',
  `request_number` STRING COMMENT 'Externally-known business identifier for the mutual aid request, used in inter-utility communications, ESOP documentation, and regulatory reporting. Format: MAR-{YYYY}-{NNNNNN}. Pattern: ^MAR-[0-9]{4}-[0-9]{6}$.',
  `request_status` STRING COMMENT 'Current lifecycle state of the mutual aid request, tracking progression from initial submission through crew mobilization, active deployment, and final demobilization or cancellation. Reference-value candidates: draft|submitted|acknowledged|committed|active|demobilized|cancelled|closed.',
  `request_type` STRING COMMENT 'Indicates whether this utility is the requesting party (outbound — this utility is seeking aid from a neighbor) or the responding party (inbound — this utility is providing aid to a neighbor). Valid values: outbound|inbound.',
  `requesting_contact_name` STRING COMMENT 'Name of the primary operational contact at the requesting utility responsible for coordinating the mutual aid request and managing incoming crews.',
  `requesting_contact_phone` STRING COMMENT 'Direct phone number for the primary operational contact at the requesting utility. Used for real-time coordination during storm response. Pattern: ^\\+?[0-9\\-\\s()]{7,20}$.',
  `requesting_utility_name` STRING COMMENT 'Legal name of the utility that is requesting mutual aid resources. Identifies the party in need of crew or equipment support during a major outage or storm event.',
  `requesting_utility_nerc_code` STRING COMMENT 'NERC-assigned registered entity identifier for the requesting utility, used for regulatory reporting and inter-utility coordination under NERC EOP standards.',
  `responding_contact_name` STRING COMMENT 'Name of the primary operational contact at the responding utility responsible for coordinating crew dispatch and resource commitment.',
  `responding_contact_phone` STRING COMMENT 'Direct phone number for the primary operational contact at the responding utility. Used for real-time coordination during crew mobilization. Pattern: ^\\+?[0-9\\-\\s()]{7,20}$.',
  `responding_utility_name` STRING COMMENT 'Legal name of the utility that is committing resources in response to the mutual aid request. Identifies the aid-providing party.',
  `responding_utility_nerc_code` STRING COMMENT 'NERC-assigned registered entity identifier for the responding (aid-providing) utility, used for regulatory reporting and inter-utility coordination.',
  `service_territory_state` STRING COMMENT 'Two-letter US state code for the primary service territory where restoration work will be performed. Used for jurisdictional compliance, state PUC reporting, and logistics planning. Pattern: ^[A-Z]{2}$.',
  `staging_location` STRING COMMENT 'Name or address of the staging area designated for incoming mutual aid crews within the requesting utility\'s service territory. Used for logistics coordination and crew check-in management.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_outage_mutual_aid_request` PRIMARY KEY (`mutual_aid_request_id`)
)
USING DELTA
COMMENT 'Record of a mutual aid request issued to or received from neighboring utilities during large-scale storm response or major outage events. Captures requesting utility, responding utility, request date, crew type and count requested, crew type and count committed, mobilization date, demobilization date, ESOP (Emergency Support Operations Plan) reference, and cost reimbursement tracking flag. Supports NERC EOP mutual aid obligations and storm recovery coordination. | CMM: CIM Request (close), IEC61968::InfWork.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MutualAidRequest',
  'cmm.cim.class' = 'Request',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfWork',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-6',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.mutual_aid_request'
);

-- ReliabilityIndexPeriod  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `outage`.`reliability_index_period` (
  `reliability_index_period_id` BIGINT NOT NULL COMMENT 'Primary key for reliability_index_period',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: SAIDI/SAIFI/CAIDI reporting is mandated by specific PUC obligations with defined performance thresholds and filing deadlines. Regulatory affairs maps each reporting period to the governing obligation',
  `amendment_reason` STRING COMMENT 'Free-text description of the reason for amending or recomputing this reliability index period record (e.g., data correction from OMS, reclassification of MED events, customer count correction). Required for version_number greater than 1. Supports regulatory audit trail and PUC amendment filing documentation.',
  `approved_by` STRING COMMENT 'Identifier or name of the authorized utility employee (typically a Reliability Engineer or Director of Grid Operations) who approved this reliability index period record for regulatory filing. Supports SOX internal control documentation and regulatory audit requirements.',
  `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this reliability index period record was formally approved for regulatory filing. Supports SOX internal control audit trails and regulatory submission documentation.',
  `caidi_minutes` DECIMAL(10,4) COMMENT 'Customer Average Interruption Duration Index expressed in minutes per interruption. Computed as total_customer_minutes_interrupted divided by total_customer_interruptions (equivalently, SAIDI divided by SAIFI). Represents the average duration of each interruption experienced by affected customers. Used to assess restoration performance.',
  `caidi_normalized_minutes` DECIMAL(10,4) COMMENT 'CAIDI value computed after excluding Major Event Day (MED) interruptions per IEEE 1366 normalization methodology. Derived from normalized SAIDI and SAIFI values. Used for PUC performance standard compliance and restoration performance benchmarking.',
  `computation_method` STRING COMMENT 'Identifies the specific computational methodology applied to derive the reliability indices in this record. IEEE_1366_STANDARD applies the full IEEE 1366 methodology including MEDs; IEEE_1366_MED_EXCLUDED applies the normalized MED-excluded methodology; PUC_CUSTOM applies a state-specific PUC-mandated variation; NERC_BENCHMARK applies NERC benchmarking methodology. Valid values: IEEE_1366_STANDARD|IEEE_1366_MED_EXCLUDED|PUC_CUSTOM|NERC_BENCHMARK.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this reliability index period record was first created in the system. Supports data lineage, audit trail, and SOX internal control requirements.',
  `customers_served` INT COMMENT 'Total number of customers served within the reporting entity boundary during the reporting period. This is the denominator used in SAIDI and SAIFI index calculations per IEEE 1366. Typically represents the average or end-of-period customer count as defined by the applicable PUC methodology.',
  `equipment_failure_outage_events` INT COMMENT 'Number of outage events during the reporting period caused by equipment failure (excluding storm and third-party causes). Supports asset reliability analysis, maintenance planning, and capital investment justification for aging infrastructure programs.',
  `filed_date` DATE COMMENT 'Actual date on which this reliability index period record was submitted to the applicable regulatory authority. Null if not yet filed. Used to verify on-time filing compliance and support regulatory audit trails.',
  `filing_due_date` DATE COMMENT 'Deadline date by which this reliability index period record must be submitted to the applicable regulatory authority (PUC or NERC). Used to track filing compliance and trigger workflow notifications. Determined by PUC tariff or NERC standard reporting schedule.',
  `filing_status` STRING COMMENT 'Current lifecycle state of the reliability index period record in the regulatory submission workflow. DRAFT indicates preliminary computation; UNDER_REVIEW indicates internal QA; APPROVED indicates sign-off for submission; FILED indicates submission to PUC or NERC; AMENDED indicates a corrected re-submission; SUPERSEDED indicates replaced by a newer version. Valid values: DRAFT|UNDER_REVIEW|APPROVED|FILED|AMENDED|SUPERSEDED.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this reliability index period record was most recently modified. Tracks amendments, recomputations, and corrections to the reliability indices. Supports audit trail and regulatory amendment documentation.',
  `maifi_index` DECIMAL(10,4) COMMENT 'Momentary Average Interruption Frequency Index computed as total momentary customer interruptions divided by customers served. Measures the frequency of brief power interruptions (five minutes or less) per customer. Increasingly required by PUCs as a power quality metric alongside SAIDI and SAIFI.',
  `med_event_count` INT COMMENT 'Number of calendar days during the reporting period that qualified as Major Event Days (MEDs) per the IEEE 1366 beta + 2.5 sigma threshold methodology. Used to assess storm and extreme weather impact on reliability performance.',
  `med_excluded_customer_interruptions` INT COMMENT 'Total customer interruptions attributable to Major Event Days (MEDs) that are excluded from the normalized IEEE 1366 index calculations. MEDs are days where the daily SAIDI exceeds a statistically derived threshold (beta + 2.5 sigma). Tracking this separately enables both total and MED-excluded reporting as required by most PUCs.',
  `med_excluded_customer_minutes` DECIMAL(18,2) COMMENT 'Total customer minutes interrupted attributable to Major Event Days (MEDs) that are excluded from the normalized IEEE 1366 index calculations. Used to compute MED-normalized SAIDI and SAIFI values required for PUC regulatory filings and NERC benchmarking.',
  `med_threshold_saidi_minutes` DECIMAL(10,4) COMMENT 'The computed daily SAIDI threshold (beta + 2.5 sigma) used to classify a calendar day as a Major Event Day for this reporting period. Derived from the five-year historical daily SAIDI distribution per IEEE 1366 methodology. Documents the MED classification boundary applied to this period.',
  `momentary_interruption_count` INT COMMENT 'Total number of momentary interruptions (duration five minutes or less per IEEE 1366 definition) experienced by customers during the reporting period. Used to compute MAIFI (Momentary Average Interruption Frequency Index) and assess power quality performance.',
  `nerc_registered_entity_code` STRING COMMENT 'NERC Compliance Registry identifier for the utility entity responsible for this reliability report. Required for NERC reliability standard compliance submissions and benchmarking participation. Aligns with the NERC Transmission Planner, Distribution Provider, or Load-Serving Entity registration.',
  `oms_source_system_code` STRING COMMENT 'Identifier of the Outage Management System (OMS) instance from which the underlying outage event data was sourced for this reliability index computation. Supports data lineage tracing back to GE PowerOn ADMS or equivalent OMS. Critical for audit and regulatory filing validation.',
  `period_end_date` DATE COMMENT 'Calendar date marking the inclusive end of the reliability reporting period. Combined with period_start_date to define the exact window over which SAIDI, SAIFI, and CAIDI indices are computed.',
  `period_start_date` DATE COMMENT 'Calendar date marking the inclusive start of the reliability reporting period. Combined with period_end_date to define the exact window over which SAIDI, SAIFI, and CAIDI indices are computed.',
  `period_type` STRING COMMENT 'Classification of the reporting period granularity. Determines the aggregation window for SAIDI, SAIFI, and CAIDI index calculations. MONTHLY is used for operational monitoring; QUARTERLY and ANNUAL are used for PUC regulatory filings; ROLLING_12_MONTH is used for NERC benchmarking. Valid values: MONTHLY|QUARTERLY|ANNUAL|ROLLING_12_MONTH.',
  `planned_interruption_customer_minutes` DECIMAL(18,2) COMMENT 'Customer minutes interrupted attributable to planned (scheduled maintenance) outage events during the reporting period. Some PUC jurisdictions require separate reporting of planned vs. unplanned interruptions. Enables decomposition of total CMI into planned and unplanned components.',
  `prior_period_saidi_minutes` DECIMAL(10,4) COMMENT 'SAIDI value from the immediately preceding equivalent reporting period (e.g., prior month, prior quarter, prior year) for the same reporting entity. Stored on the record to support period-over-period variance analysis in regulatory filings without requiring a self-join.',
  `prior_period_saifi_index` DECIMAL(10,4) COMMENT 'SAIFI value from the immediately preceding equivalent reporting period for the same reporting entity. Stored on the record to support period-over-period variance analysis in regulatory filings without requiring a self-join.',
  `puc_jurisdiction_code` STRING COMMENT 'Two-letter state code plus PUC suffix identifying the state Public Utility Commission jurisdiction under which this reliability index period record is filed (e.g., CA-PUC, NY-PUC, TX-PUC). Determines applicable performance standards, reporting formats, and filing deadlines. Pattern: ^[A-Z]{2}-PUC$.',
  `puc_saidi_performance_target` DECIMAL(10,4) COMMENT 'Regulatory SAIDI performance target (in minutes) established by the applicable state PUC for the reporting period and reporting entity. Used to assess compliance with performance-based rate mechanisms and potential penalty or incentive triggers. Null if no PUC target applies to this reporting level.',
  `puc_saifi_performance_target` DECIMAL(10,4) COMMENT 'Regulatory SAIFI performance target established by the applicable state PUC for the reporting period and reporting entity. Used to assess compliance with performance-based rate mechanisms and potential penalty or incentive triggers. Null if no PUC target applies to this reporting level.',
  `puc_target_met` BOOLEAN COMMENT 'Indicates whether the utility met all applicable PUC reliability performance targets (SAIDI and SAIFI) for this reporting period and reporting entity. True if all applicable targets were met; False if one or more targets were missed. Null if no PUC targets apply. Drives performance-based rate adjustment calculations.',
  `reporting_entity_code` STRING COMMENT 'Business identifier for the specific entity (circuit ID, substation code, PUC territory code, operating area code, or system-level identifier) at which the reliability indices are reported. Corresponds to the reporting_level classification. For SYSTEM level, this is the utility NERC registered entity identifier.',
  `reporting_entity_name` STRING COMMENT 'Human-readable name of the reporting entity (e.g., circuit name, substation name, PUC territory name, operating area name). Used for display in regulatory filings and reliability performance dashboards.',
  `reporting_level` STRING COMMENT 'Organizational or geographic granularity at which the reliability indices are computed and reported. SYSTEM represents the full utility service territory; CIRCUIT and SUBSTATION represent distribution-level granularity; PUC_TERRITORY aligns with regulatory jurisdiction boundaries; OPERATING_AREA represents internal operational divisions. Valid values: SYSTEM|CIRCUIT|SUBSTATION|PUC_TERRITORY|OPERATING_AREA.',
  `reporting_period_code` STRING COMMENT 'Externally-known business identifier for the reporting period, encoding the period type and calendar reference (e.g., MONTHLY-2024-03, QUARTERLY-2024-Q1, ANNUAL-2024). Used as the primary business key for regulatory filings and cross-system reconciliation. Pattern: ^(MONTHLY|QUARTERLY|ANNUAL)-[0-9]{4}(-Q[1-4]|-[0-1][0-9])?$.',
  `saidi_minutes` DECIMAL(10,4) COMMENT 'System Average Interruption Duration Index expressed in minutes per customer. Computed as total_customer_minutes_interrupted divided by customers_served. Represents the average total duration of interruptions experienced per customer during the reporting period. Primary reliability metric for PUC regulatory filings and NERC benchmarking.',
  `saidi_normalized_minutes` DECIMAL(10,4) COMMENT 'SAIDI value computed after excluding Major Event Day (MED) interruptions per IEEE 1366 normalization methodology. Computed as (total_customer_minutes_interrupted minus med_excluded_customer_minutes) divided by customers_served. This is the primary metric used for year-over-year performance benchmarking and PUC performance standard compliance.',
  `saifi_index` DECIMAL(10,4) COMMENT 'System Average Interruption Frequency Index expressed as interruptions per customer. Computed as total_customer_interruptions divided by customers_served. Represents the average number of interruptions experienced per customer during the reporting period. Key reliability metric for PUC regulatory filings.',
  `saifi_normalized_index` DECIMAL(10,4) COMMENT 'SAIFI value computed after excluding Major Event Day (MED) interruptions per IEEE 1366 normalization methodology. Computed as (total_customer_interruptions minus med_excluded_customer_interruptions) divided by customers_served. Used for PUC performance standard compliance and NERC benchmarking.',
  `storm_related_outage_events` INT COMMENT 'Number of outage events during the reporting period that were classified as storm-related (weather-caused). Supports storm impact analysis, MED classification validation, and regulatory storm reporting requirements. Sourced from OMS event cause codes.',
  `third_party_outage_events` INT COMMENT 'Number of outage events during the reporting period caused by third parties (e.g., vehicle accidents, dig-ins, animal contacts, vegetation encroachment by non-utility parties). Some PUC jurisdictions allow exclusion of third-party caused outages from performance standard calculations.',
  `total_customer_interruptions` INT COMMENT 'Total number of customer interruptions (sum of customers affected across all outage events) during the reporting period. This is the numerator for SAIFI calculation. Each customer affected by each distinct outage event counts as one interruption.',
  `total_customer_minutes_interrupted` DECIMAL(18,2) COMMENT 'Sum of the product of customers affected multiplied by outage duration in minutes across all outage events in the reporting period. This is the numerator for SAIDI calculation, expressed in customer-minutes. Also referred to as Customer Minutes of Interruption (CMI) in regulatory filings.',
  `total_outage_events` INT COMMENT 'Total number of distinct outage events (interruption incidents) that occurred within the reporting entity boundary during the reporting period. Provides context for interpreting SAIDI and SAIFI values and supports frequency-based reliability analysis.',
  `unplanned_interruption_customer_minutes` DECIMAL(18,2) COMMENT 'Customer minutes interrupted attributable to unplanned (forced/fault) outage events during the reporting period. Unplanned interruptions are the primary driver of reliability index degradation and are the focus of most PUC performance standards.',
  `version_number` INT COMMENT 'Sequential version number incremented each time this reliability index period record is amended or recomputed. Version 1 represents the initial filing; subsequent versions represent amendments. Supports regulatory amendment tracking and audit trail requirements.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_outage_reliability_index_period` PRIMARY KEY (`reliability_index_period_id`)
)
USING DELTA
COMMENT 'Periodic reliability performance record capturing computed SAIDI, SAIFI, and CAIDI index values for a defined reporting period (monthly, quarterly, annual) at a given reporting level (system, circuit, substation, PUC territory). Stores total customer minutes interrupted, total interruptions, customers served, MED-excluded values, and IEEE 1366 normalized values. This is the authoritative operational record — NOT an analytics aggregate — used for PUC regulatory filings and NERC reliability reporting. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ReliabilityIndexPeriod',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.reliability_index_period'
);

-- OutagePrediction  <<CIM Incident : close>>
CREATE TABLE IF NOT EXISTS `outage`.`prediction` (
  `prediction_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for the outage prediction record. Primary key for this entity in the Silver Layer lakehouse.',
  `circuit_feeder_id` BIGINT COMMENT 'Identifier of the primary distribution circuit predicted to be affected by the outage. Sourced from the GIS network model and used for crew routing and switching order preparation.',
  `distribution_substation_id` BIGINT COMMENT 'Identifier of the substation associated with the predicted outage scope. Used for crew dispatch routing and switching order coordination.',
  `employee_id` BIGINT COMMENT 'Identifier of the system operator or dispatcher who created or last modified this prediction record when prediction_source is \'dispatcher_manual\'. Provides accountability and audit trail for manually-entered predictions.',
  `feeder_id` BIGINT COMMENT 'Identifier of the distribution feeder predicted to be affected. A feeder is a primary distribution line segment fed from a substation bus. Used for network topology analysis and switching order preparation.',
  `load_id` BIGINT COMMENT 'Foreign key linking to forecast.load. Business justification: Predictive outage management systems integrate load forecasts to estimate customer impact (count, MW interrupted) and prioritize response. Advanced OMS platforms reference specific load forecast runs',
  `oms_event_id` BIGINT COMMENT 'Externally-known identifier assigned by the Outage Management System (OMS) to the predicted outage event. Used to correlate this prediction record with the OMS event lifecycle and downstream actual outage records.',
  `predictive_model_id` BIGINT COMMENT 'Identifier of the predictive analytics model version that generated this prediction, when prediction_source is \'predictive_model\'. Enables model performance tracking, auditability, and retraining feedback loops.',
  `scada_alarm_id` BIGINT COMMENT 'Identifier of the SCADA (Supervisory Control and Data Acquisition) alarm that triggered or corroborated this outage prediction. Provides traceability back to the real-time operational data historian (OSIsoft PI) or ADMS alarm log.',
  `service_territory_id` BIGINT COMMENT 'Reference to the regulated service territory within which the predicted outage falls. Used for regulatory reporting to State Public Utility Commissions (PUCs) and SAIDI/SAIFI/CAIDI performance tracking.',
  `storm_event_id` BIGINT COMMENT 'Reference to the storm or major weather event record associated with this prediction, if applicable. Links the prediction to the storm response management workflow for resource mobilization and regulatory major event day (MED) classification.',
  `weather_input_id` BIGINT COMMENT 'Foreign key linking to forecast.weather_input. Business justification: Outage prediction models consume weather forecast inputs (wind speed, precipitation, temperature) to predict storm-related outage likelihood and severity. Utilities use this linkage for storm prepared',
  `ami_meter_count` INT COMMENT 'Number of Advanced Metering Infrastructure (AMI) smart meters within the predicted outage scope that contributed last-gasp or ping-failure signals to the prediction. Indicates the AMI signal density supporting the prediction confidence.',
  `confidence_level_pct` DECIMAL(5,2) COMMENT 'Numeric confidence score (0.00–100.00) representing the model\'s or system\'s certainty in the predicted outage scope, cause, and affected area. Higher values indicate greater confidence. Used to prioritize crew dispatch and ETR communication decisions.',
  `created_timestamp` TIMESTAMP COMMENT 'Audit timestamp recording when this outage prediction record was first persisted in the data platform. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `crew_preplacement_flag` BOOLEAN COMMENT 'Indicates whether field crews have been pre-positioned based on this outage prediction prior to field confirmation of the actual outage. When True, crew dispatch records are linked to this prediction in the workforce management system.',
  `critical_customer_flag` BOOLEAN COMMENT 'Indicates whether the predicted outage scope includes one or more critical customers (e.g., hospitals, emergency services, life-support customers, large industrial accounts with SLA obligations). When True, triggers priority restoration protocols and mandatory customer notification.',
  `customer_call_count` INT COMMENT 'Number of inbound customer outage calls received and clustered to generate or corroborate this prediction. Used to assess the customer-reported signal strength and prioritize crew dispatch.',
  `der_impact_flag` BOOLEAN COMMENT 'Indicates whether the predicted outage scope includes Distributed Energy Resources (DERs) such as rooftop solar, battery storage, or microgrids that may be islanded or require isolation procedures. When True, DERMS coordination is required.',
  `expiry_timestamp` TIMESTAMP COMMENT 'Date and time after which this prediction is considered stale and should no longer be used for crew dispatch or ETR communication without refresh. Typically set to a configurable window (e.g., 2 hours) after prediction_timestamp. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `flisr_eligible_flag` BOOLEAN COMMENT 'Indicates whether the predicted outage scope is within a network segment eligible for automated Fault Location, Isolation, and Service Restoration (FLISR) execution via the ADMS. When True, automated switching sequences may be initiated without manual dispatcher intervention.',
  `major_event_day_flag` BOOLEAN COMMENT 'Indicates whether this prediction is associated with a Major Event Day (MED) as defined by IEEE 1366. MED events are excluded from standard SAIDI/SAIFI/CAIDI calculations and reported separately to state PUCs and NERC.',
  `medical_baseline_customer_flag` BOOLEAN COMMENT 'Indicates whether the predicted outage scope includes customers enrolled in a medical baseline or life-support program. When True, triggers mandatory proactive notification and priority restoration per state PUC regulations.',
  `notification_sent_flag` BOOLEAN COMMENT 'Indicates whether an outage notification has been sent to affected customers based on this prediction. When True, the notification timestamp and channel are tracked in the customer notification log. Supports state PUC notification compliance reporting.',
  `notification_timestamp` TIMESTAMP COMMENT 'Date and time at which the first customer notification was dispatched based on this outage prediction. Used for state PUC compliance reporting on notification timeliness. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `outage_type` STRING COMMENT 'Classification of the predicted outage by its nature. \'unplanned\' = unexpected equipment or system failure; \'planned\' = scheduled maintenance window; \'storm\' = weather-driven event; \'momentary\' = predicted to be a brief interruption (< 5 minutes per IEEE 1366); \'sustained\' = predicted to exceed the momentary threshold. Valid values: unplanned|planned|storm|momentary|sustained.',
  `predicted_affected_segments` STRING COMMENT 'Comma-delimited list of distribution circuit segment identifiers predicted to be de-energized. Sourced from the GIS network model topology analysis. Used for switching order preparation and crew routing.',
  `predicted_cause_code` STRING COMMENT 'Standardized cause code representing the predicted root cause of the outage at time of initial assessment (e.g., equipment failure, tree contact, animal contact, weather, vehicle accident, unknown). Aligned with IEEE 1366 cause code taxonomy. Reference-value candidates: equipment_failure|tree_contact|animal_contact|weather|vehicle_accident|planned_maintenance|unknown|overload|lightning|ice_loading.',
  `predicted_cause_description` STRING COMMENT 'Free-text narrative describing the predicted cause of the outage as assessed at the time of prediction creation. Supplements the structured cause code with dispatcher or model-generated context.',
  `predicted_customer_count` INT COMMENT 'Estimated number of customers predicted to be without power based on the initial assessment. Used for crew pre-positioning, ETR communication, and SAIDI/SAIFI/CAIDI impact estimation. Distinct from the confirmed customer count on the actual outage event record.',
  `predicted_etr` TIMESTAMP COMMENT 'Initial estimated date and time by which power is predicted to be restored to affected customers. Communicated to customers and field crews at the time of prediction creation. Distinct from the revised ETR updated during active restoration. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `predicted_fault_latitude` DECIMAL(10,7) COMMENT 'WGS-84 decimal latitude coordinate of the predicted fault location. Used for GIS-based crew dispatch and outage mapping.',
  `predicted_fault_location` STRING COMMENT 'Predicted geographic or network location of the fault, expressed as a GIS asset identifier, address, or coordinate reference. Used to direct first-responder crews to the most probable fault point before field confirmation.',
  `predicted_fault_longitude` DECIMAL(10,7) COMMENT 'WGS-84 decimal longitude coordinate of the predicted fault location. Used for GIS-based crew dispatch and outage mapping.',
  `predicted_load_mw` DECIMAL(10,3) COMMENT 'Estimated megawatts (MW) of load predicted to be interrupted based on the affected circuit segments and customer mix. Used for grid operations impact assessment and load restoration prioritization.',
  `predicted_outage_duration_min` INT COMMENT 'Estimated duration of the outage in minutes as assessed at the time of prediction creation. Derived from historical restoration times for similar cause codes and circuit configurations. Used for CAIDI estimation and crew resource planning.',
  `prediction_source` STRING COMMENT 'The originating signal or mechanism that triggered the outage prediction. \'ami_ping\' = Advanced Metering Infrastructure (AMI) last-gasp or ping failure; \'scada_alarm\' = SCADA system alarm from field device; \'customer_call_cluster\' = clustering of inbound customer outage calls; \'predictive_model\' = ML/analytics model output; \'dispatcher_manual\' = manually entered by a system operator or dispatcher; \'smart_meter_outage_notification\' = direct outage notification from smart meter. Valid values: ami_ping|scada_alarm|customer_call_cluster|predictive_model|dispatcher_manual|smart_meter_outage_notification.',
  `prediction_status` STRING COMMENT 'Current lifecycle state of the outage prediction record. \'pending\' = generated but not yet dispatched; \'active\' = in use for crew pre-positioning and ETR communication; \'confirmed\' = field crew has validated the predicted scope; \'superseded\' = replaced by a newer prediction; \'cancelled\' = prediction voided before confirmation; \'expired\' = prediction window elapsed without field confirmation. Valid values: pending|active|confirmed|superseded|cancelled|expired.',
  `prediction_timestamp` TIMESTAMP COMMENT 'The date and time at which the outage prediction was system-generated or dispatcher-created. Represents the principal real-world event time for this prediction record. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `predictive_model_version` STRING COMMENT 'Version string of the predictive analytics model that generated this prediction. Used alongside predictive_model_id for model governance, auditability, and performance benchmarking.',
  `protection_zone` STRING COMMENT 'The protection zone or relay zone within which the predicted fault is located. Used by switching order coordinators to identify the correct protective device (recloser, fuse, breaker) to operate for isolation and restoration.',
  `source_system_code` STRING COMMENT 'Code identifying the operational system of record that originated this outage prediction record. Used for data lineage, reconciliation, and Silver Layer provenance tracking. Valid values: GE_POWERON_ADMS|OSI_PI|ORACLE_MDM|SAP_ISU|MANUAL.',
  `updated_timestamp` TIMESTAMP COMMENT 'Audit timestamp recording when this outage prediction record was last modified in the data platform. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `voltage_level` STRING COMMENT 'Voltage classification of the network segment predicted to be affected. Determines the severity tier, crew qualification requirements, and regulatory reporting category. Valid values: transmission|sub_transmission|primary_distribution|secondary_distribution.',
  `weather_condition_code` STRING COMMENT 'Standardized code representing the weather conditions at the time of prediction creation (e.g., clear, wind, ice, lightning, flood). Used for cause analysis, storm classification, and reliability reporting. Reference-value candidates: clear|wind|ice|lightning|flood|snow|extreme_heat|fog|tornado|hurricane.',
  `wind_speed_mph` DECIMAL(6,2) COMMENT 'Recorded or forecast wind speed in miles per hour at the predicted fault location at the time of prediction creation. Used for storm severity assessment and major event day (MED) classification.',
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
  CONSTRAINT `pk_outage_prediction` PRIMARY KEY (`prediction_id`)
)
USING DELTA
COMMENT 'Operational record of a system-generated or dispatcher-created predicted outage scope at the time of initial event creation, capturing estimated number of affected customers, predicted cause, predicted affected circuit segments, confidence level, and prediction source (AMI ping, SCADA alarm, customer call clustering, predictive model). Distinct from the actual outage event — represents the initial assessment used for crew pre-positioning and ETR communication before field confirmation. | CMM: CIM Incident (close), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'OutagePrediction',
  'cmm.cim.class' = 'Incident',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.prediction',
  'cmm.gis.location.role' = 'Incident.Location'
);

-- EtrRevision  <<CIM EstimatedRestorationTime : exact>>
CREATE TABLE IF NOT EXISTS `outage`.`etr_revision` (
  `etr_revision_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for each ETR revision record within the outage management system. Primary key for the etr_revision data product.',
  `affected_feeder_id` BIGINT COMMENT 'Reference to the primary distribution feeder affected by the outage event at the time of this ETR revision. Supports feeder-level reliability analysis and SAIDI/SAIFI/CAIDI reporting.',
  `employee_id` BIGINT COMMENT 'Reference to the dispatcher or control room operator who issued this ETR revision. Supports dispatcher performance review and accountability tracking.',
  `event_id` BIGINT COMMENT 'Reference to the parent outage event for which this ETR revision was issued. Links the revision to its originating outage lifecycle record in the OMS.',
  `outage_switching_order_id` BIGINT COMMENT 'Reference to the switching order associated with the restoration effort at the time of this ETR revision. Links the ETR revision to the specific switching sequence being executed. Null if no switching order was active.',
  `regulatory_correspondence_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_correspondence. Business justification: ETR revisions for major outages may require regulatory notifications or explanations to PUC regarding restoration delays. Customer service and regulatory affairs teams document regulatory communicatio',
  `work_order_id` BIGINT COMMENT 'Reference to the field work order created for the restoration effort associated with this ETR revision. Links to the asset management and workforce management system for crew and material tracking.',
  `auto_generated` BOOLEAN COMMENT 'Indicates whether this ETR revision was automatically generated by the OMS/ADMS system (e.g., via predictive restoration algorithms or rule-based triggers) rather than manually entered by a dispatcher. True if system-generated; False if manually entered.',
  `confidence_level` STRING COMMENT 'Dispatcher or system-assigned confidence level for the revised ETR at the time of issuance. Reflects the degree of certainty based on available information (crew on-site, damage assessment status, resource availability). Used in ETR accuracy analytics. Valid values: HIGH|MEDIUM|LOW|UNKNOWN.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time at which this ETR revision record was first created in the data platform. Serves as the audit trail creation timestamp for the Silver layer record. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `crew_dispatched` BOOLEAN COMMENT 'Indicates whether a field crew had been dispatched to the outage location at the time this ETR revision was issued. True if crew dispatch had occurred; False if crew was not yet dispatched. Supports correlation between crew availability and ETR accuracy.',
  `crew_on_site` BOOLEAN COMMENT 'Indicates whether a field crew had arrived on-site at the outage location at the time this ETR revision was issued. True if crew was confirmed on-site; False otherwise. Supports analysis of ETR accuracy improvement after crew arrival.',
  `customer_notification_triggered` BOOLEAN COMMENT 'Indicates whether this ETR revision triggered an outbound customer notification (SMS, IVR, email, or web portal update). True if notifications were dispatched; False if the revision was internal only. Supports customer communication audit trail.',
  `customers_affected_count` INT COMMENT 'Number of customer service points affected by the outage event at the time this ETR revision was issued. May change between revisions as the outage scope is refined. Used for prioritization and SAIDI/SAIFI/CAIDI reliability metric calculations.',
  `customers_restored_count` INT COMMENT 'Cumulative number of customer service points that had been restored at the time this ETR revision was issued. Enables tracking of restoration progress across the outage lifecycle and supports CAIDI calculation.',
  `damage_assessment_complete` BOOLEAN COMMENT 'Indicates whether a formal damage assessment had been completed prior to this ETR revision. True if damage assessment was finalized; False if the revision was issued before full assessment. ETR revisions post-assessment are typically more accurate.',
  `dispatcher_notes` STRING COMMENT 'Free-text operational notes entered by the dispatcher at the time of this ETR revision. May include field crew communications, equipment status updates, or coordination details not captured in structured fields. Supports dispatcher performance review and post-event analysis.',
  `estimated_mw_interrupted` DECIMAL(12,3) COMMENT 'Estimated load in megawatts (MW) interrupted by the outage event at the time of this ETR revision. Used for NERC EOP-004 regulatory reporting thresholds and for grid impact assessment.',
  `etr_shift_minutes` INT COMMENT 'Signed integer representing the change in estimated restoration time in minutes between the previous ETR and the revised ETR. Positive values indicate a later restoration estimate; negative values indicate an earlier estimate. Derived at ingestion for analytical convenience — not a KPI aggregate.',
  `mutual_aid_requested` BOOLEAN COMMENT 'Indicates whether mutual aid from neighboring utilities or contractors had been requested for this outage event at the time of this ETR revision. True if mutual aid was requested; False otherwise. Mutual aid requests often correlate with extended ETR windows.',
  `nerc_event_type` STRING COMMENT 'NERC EOP-004 event type classification applicable to the outage at the time of this ETR revision. Populated only when regulatory_reportable is True. Reference-value candidates: LOSS_OF_LOAD|TRANSMISSION_LOSS|GENERATION_LOSS|VOLTAGE_DEVIATION|FREQUENCY_DEVIATION|CYBER_SECURITY|PHYSICAL_SECURITY|NATURAL_DISASTER.',
  `notification_channel` STRING COMMENT 'Primary channel through which customer notifications were dispatched for this ETR revision. Null or NONE if customer_notification_triggered is False. Supports multi-channel communication audit and regulatory compliance reporting. Valid values: SMS|IVR|EMAIL|WEB_PORTAL|NONE.',
  `notification_timestamp` TIMESTAMP COMMENT 'Date and time at which customer notifications were dispatched following this ETR revision. Null if no notification was triggered. Enables measurement of lag between ETR revision and customer communication. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `oms_incident_number` STRING COMMENT 'External incident number assigned by the GE PowerOn ADMS Outage Management System to the parent outage event. Serves as the cross-system business identifier for traceability between the OMS and downstream reporting systems.',
  `outage_cause_code` STRING COMMENT 'Standardized cause code for the outage event as known at the time of this ETR revision. May be updated across revisions as field crews refine the root cause. Aligns with IEEE 1366 cause code taxonomy. Reference-value candidates: WEATHER|EQUIPMENT_FAILURE|TREE_CONTACT|ANIMAL_CONTACT|VEHICLE_ACCIDENT|PLANNED_MAINTENANCE|UNKNOWN|THIRD_PARTY|OVERLOAD|LIGHTNING.',
  `outage_type` STRING COMMENT 'Classification of the outage event type at the time of this ETR revision. UNPLANNED covers unexpected equipment failures; PLANNED covers scheduled maintenance windows; STORM covers major weather events; EMERGENCY covers safety-driven de-energizations. Valid values: UNPLANNED|PLANNED|STORM|EMERGENCY.',
  `partial_restoration_flag` BOOLEAN COMMENT 'Indicates whether a partial restoration of service had been achieved for a subset of affected customers prior to this ETR revision being issued. True if partial restoration was in effect; False if no customers had been restored yet.',
  `previous_etr` TIMESTAMP COMMENT 'The ETR value that was in effect immediately before this revision was applied. Null for the initial ETR issuance (revision_sequence_number = 1). Enables before/after comparison for ETR accuracy analysis. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `priority_level` STRING COMMENT 'Restoration priority assigned to the outage event at the time of this ETR revision. CRITICAL typically covers medical baseline customers, hospitals, or critical infrastructure; HIGH covers large commercial/industrial customers; MEDIUM and LOW cover standard residential and commercial segments. Valid values: CRITICAL|HIGH|MEDIUM|LOW.',
  `regulatory_reportable` BOOLEAN COMMENT 'Indicates whether the parent outage event meets the threshold for mandatory regulatory reporting to NERC, FERC, or State PUC at the time of this ETR revision. True if reportable thresholds (e.g., customer count, duration, MW lost) are met; False otherwise.',
  `revised_etr` TIMESTAMP COMMENT 'The new ETR value established by this revision. Represents the dispatcher\'s best estimate of when service will be restored to affected customers at the time of revision. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `revision_reason_code` STRING COMMENT 'Standardized code indicating the primary reason for this ETR revision. Used for root-cause analysis of ETR accuracy and dispatcher performance reporting. Reference-value candidates: INITIAL_ESTIMATE|CREW_ASSESSMENT|SCOPE_CHANGE|RESOURCE_DELAY|WEATHER_UPDATE|RESTORATION_PARTIAL|EQUIPMENT_COMPLEXITY|SAFETY_HOLD|MUTUAL_AID_DELAY|DAMAGE_REASSESSMENT. Valid values: INITIAL_ESTIMATE|CREW_ASSESSMENT|SCOPE_CHANGE|RESOURCE_DELAY|WEATHER_UPDATE|RESTORATION_PARTIAL.',
  `revision_reason_description` STRING COMMENT 'Free-text narrative provided by the dispatcher explaining the specific circumstances that necessitated this ETR revision. Supplements the structured reason code with operational context.',
  `revision_sequence_number` INT COMMENT 'Ordinal sequence number of this revision within the outage event, starting at 1 for the initial ETR issuance. Enables chronological ordering of all ETR revisions for a given outage and supports ETR accuracy trend analysis.',
  `revision_source` STRING COMMENT 'Indicates the originating source of this ETR revision — whether it was manually entered by a dispatcher, automatically generated by the OMS/ADMS system, submitted by a field crew, escalated by a supervisor, or issued from a storm operations center. Valid values: DISPATCHER|SYSTEM_AUTO|CREW_FIELD|SUPERVISOR|STORM_CENTER.',
  `revision_status` STRING COMMENT 'Current lifecycle status of this ETR revision record. ACTIVE indicates the revision is the current operative ETR; SUPERSEDED indicates it has been replaced by a later revision; CANCELLED indicates the revision was voided; FINAL indicates the outage has been restored and this was the last ETR. Valid values: ACTIVE|SUPERSEDED|CANCELLED|FINAL.',
  `revision_timestamp` TIMESTAMP COMMENT 'Date and time (with timezone offset) at which this ETR revision was recorded in the OMS. Serves as the principal business event timestamp for the revision lifecycle. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `saidi_contribution_minutes` DECIMAL(12,6) COMMENT 'Incremental SAIDI contribution in customer-minutes attributable to this outage event as projected at the time of this ETR revision, calculated as (customers_affected_count × projected_duration_minutes) / total_customers_served. Supports real-time reliability index tracking.',
  `service_territory_code` STRING COMMENT 'Code identifying the regulated service territory within which the outage event occurred. Used for jurisdictional regulatory reporting to State PUCs and for territory-level reliability benchmarking.',
  `source_system_code` STRING COMMENT 'Code identifying the operational system of record from which this ETR revision record was sourced. Supports data lineage tracking and Silver layer provenance in the Databricks Lakehouse. Valid values: GE_POWERON_ADMS|SAP_ISU|ORACLE_CC_B|MANUAL.',
  `storm_event_flag` BOOLEAN COMMENT 'Indicates whether this ETR revision was issued during an active declared storm event or major weather emergency. True if a storm event declaration was active; False for normal operations. Supports storm vs. non-storm ETR accuracy benchmarking.',
  `to_outage_event` BIGINT COMMENT 'FK to outage.outage_event.outage_event_id — Every ETR revision is for a specific outage event. Required for ETR accuracy tracking and customer communication audit.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date and time at which this ETR revision record was last modified in the data platform. Supports audit trail and change tracking for the Silver layer. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `voltage_level_kv` DECIMAL(10,3) COMMENT 'Nominal voltage level in kilovolts (kV) of the affected circuit or equipment at the time of this ETR revision. Distinguishes transmission-level (>69 kV) from distribution-level (<69 kV) outages for regulatory classification and restoration complexity assessment.',
  `weather_condition_code` STRING COMMENT 'Standardized weather condition code recorded at the time of this ETR revision. Used to correlate ETR accuracy and outage duration with prevailing weather conditions for storm hardening and reliability planning. Reference-value candidates: CLEAR|WIND|RAIN|ICE|SNOW|LIGHTNING|EXTREME_HEAT|FLOOD.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_outage_etr_revision` PRIMARY KEY (`etr_revision_id`)
)
USING DELTA
COMMENT 'Record of each revision to the Estimated Time of Restoration (ETR) for an outage event. Captures revision sequence number, previous ETR, revised ETR, revision timestamp, revision reason code, issuing dispatcher, and whether customer notifications were triggered by the revision. Enables ETR accuracy tracking, customer communication audit trail, and dispatcher performance review. | CMM: CIM EstimatedRestorationTime (exact), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'EtrRevision',
  'cmm.cim.class' = 'EstimatedRestorationTime',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.etr_revision'
);

-- OutageCall  <<CIM TroubleTicket : exact>>
CREATE TABLE IF NOT EXISTS `outage`.`call` (
  `call_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for each inbound customer trouble call or AMI-generated outage report record in the Outage Management System (OMS). Primary key for this entity.',
  `account_id` BIGINT COMMENT 'Reference to the utility customer account associated with the caller or AMI device that originated this outage report. Links to the Customer Information System (CIS) account record.',
  `distribution_substation_id` BIGINT COMMENT 'Identifier of the distribution substation serving the reported outage location, resolved from the GIS network model. Used for geographic grouping of calls, outage event scoping, and storm response coordination.',
  `duplicate_of_call_id` BIGINT COMMENT 'Reference to the original (first-received) outage call record of which this call is a duplicate. Populated only when is_duplicate = True. Enables deduplication lineage tracing in OMS call clustering.',
  `employee_id` BIGINT COMMENT 'Employee identifier of the call center agent who received and logged this trouble call. Populated only when call_source_type = AGENT. Used for quality assurance, workforce management, and call handling performance reporting.',
  `event_id` BIGINT COMMENT 'Reference to the parent outage event record once this call has been matched or clustered to a confirmed outage event in the OMS. Null until the call is correlated to an event.',
  `feeder_id` BIGINT COMMENT 'Identifier of the distribution circuit (feeder) serving the reported outage location, resolved from the GIS network model based on the service address or premise. Used for OMS call clustering by circuit and outage event correlation.',
  `meter_id` BIGINT COMMENT 'Reference to the smart meter or AMI endpoint that generated an automated outage ping or last-gasp signal, if the call source is AMI-initiated rather than a human caller.',
  `premise_id` BIGINT COMMENT 'Reference to the utility service premise (physical delivery point) associated with the reported outage location. Links to the GIS/network model for spatial outage clustering and distribution circuit identification.',
  `storm_event_id` BIGINT COMMENT 'Reference to the declared storm or major weather event record associated with this outage call, when weather_event_flag = True. Links to the storm event management entity for storm response coordination and MED exclusion processing.',
  `affected_customers_reported` INT COMMENT 'Number of customers the caller reports as being affected by the outage (e.g., \'my whole street is out\'). This is a caller-provided estimate, not a system-confirmed count. Used as an early indicator for outage scope assessment and crew dispatch prioritization.',
  `ami_device_code` STRING COMMENT 'Unique identifier of the AMI endpoint (smart meter) that generated an automated last-gasp outage notification or power-off ping. Populated only when call_source_type = AMI_PING. Used to correlate AMI-detected outages with customer account and network topology.',
  `ami_signal_type` STRING COMMENT 'Type of automated signal received from the AMI endpoint that triggered this outage report. LAST_GASP = meter-detected power loss notification; POWER_RESTORE = meter-detected power restoration; TAMPER = tamper event; BLINK = momentary interruption blink count; POWER_QUALITY = voltage sag/swell event. Populated only when call_source_type = AMI_PING. Valid values: LAST_GASP|POWER_RESTORE|TAMPER|BLINK|POWER_QUALITY.',
  `call_status` STRING COMMENT 'Current lifecycle status of the outage call record within the OMS workflow. RECEIVED = call logged, not yet processed; PENDING_MATCH = awaiting correlation to an outage event; MATCHED = successfully linked to an outage event; DUPLICATE = identified as a duplicate of an existing call or event; CLOSED = call resolved and closed; CANCELLED = call withdrawn or invalid. Valid values: RECEIVED|PENDING_MATCH|MATCHED|DUPLICATE|CLOSED|CANCELLED.',
  `caller_name` STRING COMMENT 'Full name of the individual who placed the trouble call, as provided at time of call. May differ from the account holder name if a third party is reporting on behalf of the customer. Classified as confidential PII per GDPR/CCPA.',
  `caller_phone_number` STRING COMMENT 'Phone number provided by or captured from the caller at time of call receipt. Used for call-back confirmation and customer notification of restoration. Classified as restricted PII per GDPR/CCPA. Pattern: ^\\+?[0-9\\s\\-().]{7,20}$.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time at which this outage call record was first created in the data platform (Silver Layer ingestion timestamp). Serves as the audit creation timestamp for data lineage and regulatory record-keeping. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `customer_class` STRING COMMENT 'Classification of the customer associated with this outage call by service type. Used for restoration prioritization, regulatory reporting, and SAIDI/SAIFI index segmentation per IEEE 1366 and PUC requirements. Valid values: RESIDENTIAL|COMMERCIAL|INDUSTRIAL|AGRICULTURAL|MUNICIPAL.',
  `data_quality_flag` STRING COMMENT 'Indicates the data quality status of this outage call record as assessed during Silver Layer ingestion and validation. VALID = passed all validation rules; SUSPECT = passed ingestion but has anomalies requiring review; INVALID = failed critical validation; PENDING_REVIEW = awaiting manual data quality review. Valid values: VALID|SUSPECT|INVALID|PENDING_REVIEW.',
  `disposition_code` STRING COMMENT 'Standardized code indicating the final outcome or resolution action taken on this call (e.g., EVENT_CREATED, ADDED_TO_EVENT, DUPLICATE_CLOSED, NO_OUTAGE_FOUND, REFERRED_TO_CREW, CUSTOMER_CALLBACK_SCHEDULED). Sourced from OMS disposition reference table. Reference-value candidates: EVENT_CREATED|ADDED_TO_EVENT|DUPLICATE_CLOSED|NO_OUTAGE_FOUND|REFERRED_TO_CREW|CUSTOMER_CALLBACK_SCHEDULED|INVALID.',
  `duration_seconds` INT COMMENT 'Duration of the customer call in seconds from answer to disconnect, for calls received via IVR or live agent channels. Used for call center operational reporting, SLA (Service Level Agreement) compliance, and customer experience analytics.',
  `estimated_restoration_timestamp` TIMESTAMP COMMENT 'Estimated date and time of power restoration communicated to the customer at the time of call handling or subsequent notification. Sourced from OMS restoration forecasting. Used for customer expectation management and SLA (Service Level Agreement) tracking. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `hazard_indicator` BOOLEAN COMMENT 'Indicates whether the caller reported a safety hazard associated with the outage (e.g., downed power line, sparking equipment, fire, flooding near electrical equipment). True = hazard reported; False = no hazard reported. Triggers priority escalation in OMS crew dispatch and public safety notification workflows.',
  `hazard_type` STRING COMMENT 'Specific type of safety hazard reported by the caller when hazard_indicator = True. Used to determine emergency response protocol, crew safety briefing requirements, and coordination with emergency services (fire, police). Reference-value candidates: DOWNED_LINE|SPARKING|FIRE|FLOODING|EQUIPMENT_DAMAGE|TREE_ON_LINE|VEHICLE_ACCIDENT|OTHER.',
  `is_duplicate` BOOLEAN COMMENT 'Indicates whether this call has been identified as a duplicate report of an outage already captured by a prior call or AMI notification for the same event and location. True = duplicate; False = unique first report. Used by OMS call clustering logic to avoid double-counting in reliability metrics.',
  `ivr_session_code` STRING COMMENT 'Unique session identifier assigned by the Interactive Voice Response (IVR) system for calls received through the automated phone channel. Used for call traceability, IVR system reconciliation, and customer experience analytics. Populated only when call_source_type = IVR.',
  `matched_timestamp` TIMESTAMP COMMENT 'Date and time at which this call was successfully matched or correlated to a confirmed outage event in the OMS. Populated when call_status transitions to MATCHED. Used for OMS processing latency analysis and reliability reporting timelines. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `medical_baseline_flag` BOOLEAN COMMENT 'Indicates whether the affected customer account is registered on the utility\'s medical baseline or life-support program, requiring priority restoration and proactive notification per PUC regulations. True = medical baseline customer; False = standard customer. Classified as confidential due to sensitivity of health-related program enrollment.',
  `notification_sent_flag` BOOLEAN COMMENT 'Indicates whether an outage acknowledgement or estimated restoration time (ERT) notification has been sent to the customer associated with this call. True = notification sent; False = not yet sent. Supports PUC customer notification compliance tracking.',
  `notification_timestamp` TIMESTAMP COMMENT 'Date and time at which the outage acknowledgement or estimated restoration time (ERT) notification was dispatched to the customer. Populated when notification_sent_flag = True. Used for PUC notification compliance reporting. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `oms_call_cluster_code` STRING COMMENT 'Identifier of the OMS call cluster to which this call has been assigned during the outage prediction and event correlation process. Multiple calls from the same geographic area or circuit are grouped into a cluster to predict the probable outage location and initiate crew dispatch before a formal event is confirmed.',
  `outage_start_reported_timestamp` TIMESTAMP COMMENT 'Date and time the caller reports the outage began, as stated by the customer or detected by the AMI device. May differ from the OMS-confirmed outage start time. Used as an input to outage event timeline reconstruction and SAIDI/CAIDI calculations. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `priority_level` STRING COMMENT 'Restoration priority level assigned to this outage call based on hazard indicators, medical baseline status, customer class, and outage scope. CRITICAL = life-safety or critical infrastructure; HIGH = medical baseline or large commercial/industrial; MEDIUM = standard residential or small commercial; LOW = non-urgent or duplicate. Drives OMS crew dispatch sequencing. Valid values: CRITICAL|HIGH|MEDIUM|LOW.',
  `received_timestamp` TIMESTAMP COMMENT 'Date and time at which the outage call or AMI-generated outage report was received by the utility system. This is the principal business event timestamp used for OMS call clustering, outage prediction, and SAIDI/SAIFI/CAIDI reliability index calculations. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `reference_number` STRING COMMENT 'Externally visible alphanumeric reference number assigned to this trouble call at receipt, used for customer-facing acknowledgement (e.g., IVR confirmation code, agent ticket number, web portal confirmation). Sourced from the CIS or OMS call intake module.',
  `reported_symptom_code` STRING COMMENT 'Standardized code representing the symptom or problem reported by the caller or detected by the AMI system (e.g., FULL_OUTAGE, PARTIAL_OUTAGE, FLICKERING, LOW_VOLTAGE, DOWNED_LINE, BURNING_SMELL). Sourced from the OMS symptom code reference table. Reference-value candidates: FULL_OUTAGE|PARTIAL_OUTAGE|FLICKERING|LOW_VOLTAGE|DOWNED_LINE|BURNING_SMELL|SPARKING|BUZZING.',
  `reported_symptom_description` STRING COMMENT 'Free-text description of the outage symptom or problem as reported by the caller or transcribed by the call center agent. Supplements the structured symptom code with verbatim customer language for OMS analysis and crew dispatch context.',
  `service_address` STRING COMMENT 'Street address of the service location reported as experiencing the outage, as provided by the caller or resolved from the account record. Used for geographic clustering in the OMS and crew dispatch routing.',
  `service_territory_code` STRING COMMENT 'Code identifying the utility\'s regulated service territory or operating division in which the reported outage is located. Used for regulatory reporting segmentation to State PUCs and NERC reliability reporting.',
  `source_system_call_code` STRING COMMENT 'Original call or ticket identifier assigned by the source operational system (e.g., OMS call number from GE PowerOn ADMS, CIS interaction ID from SAP IS-U or Oracle CC&B). Enables traceability and reconciliation between the Silver Layer data product and the system of record.',
  `source_type` STRING COMMENT 'Channel or mechanism through which the outage report was received. IVR = Interactive Voice Response automated phone system; AGENT = live call center agent; AMI_PING = Advanced Metering Infrastructure last-gasp or outage notification; MOBILE_APP = utility mobile application; WEB_PORTAL = online self-service portal; FIELD_CREW = field crew-initiated report. Valid values: IVR|AGENT|AMI_PING|MOBILE_APP|WEB_PORTAL|FIELD_CREW.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date and time at which this outage call record was last modified in the data platform, reflecting any status updates, event matching, or data corrections applied during the call lifecycle. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `weather_event_flag` BOOLEAN COMMENT 'Indicates whether the outage reported in this call is associated with a declared weather event (storm, hurricane, ice storm, heat wave, etc.). True = weather-related; False = non-weather. Relevant for IEEE 1366 Major Event Day (MED) exclusion determination and storm response activation.',
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
  CONSTRAINT `pk_outage_call` PRIMARY KEY (`call_id`)
)
USING DELTA
COMMENT 'Record of an inbound customer trouble call or AMI-generated outage report received by the utility, used to initiate or corroborate an outage event. Captures call receipt timestamp, source type (IVR, agent, AMI ping, mobile app, web portal), reported symptom, caller account reference, associated outage event (once matched), call disposition, and whether the call was a duplicate of an existing event. Feeds OMS call clustering and outage prediction logic. | CMM: CIM TroubleTicket (exact), IEC61968::Customers.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'OutageCall',
  'cmm.cim.class' = 'TroubleTicket',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Customers',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.call',
  'cmm.gis.location.role' = 'Incident.Location'
);

-- SegmentImpact  <<CIM OutageArea : close>>
CREATE TABLE IF NOT EXISTS `outage`.`segment_impact` (
  `segment_impact_id` BIGINT NOT NULL COMMENT 'Primary key for segment_impact',
  `cause_id` BIGINT COMMENT 'Reference to the outage cause classification record describing the root cause of the de-energization event for this segment.',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_system. Business justification: Network segment analysis must identify DER on affected segments for hosting capacity recalculation, protection coordination verification, and restoration priority determination. Engineering studies po',
  `distribution_substation_id` BIGINT COMMENT 'Identifier of the distribution substation that supplies this network segment. Used for substation-level outage impact aggregation and transmission-distribution boundary analysis.',
  `event_id` BIGINT COMMENT 'Reference to the parent outage event that caused this segment to be de-energized. Links the segment impact to the originating outage lifecycle record.',
  `feeder_id` BIGINT COMMENT 'Identifier of the distribution feeder circuit that this segment belongs to. Used for feeder-level outage aggregation, reliability reporting, and ADMS topology navigation. Sourced from Esri ArcGIS Utility Network feeder model.',
  `nerc_cip_asset_id` BIGINT COMMENT 'Foreign key linking to compliance.nerc_cip_asset. Business justification: Network segment impacts may affect NERC CIP-designated BES Cyber Systems, triggering CIP incident reporting obligations. Cybersecurity teams assess whether outages impacted CIP assets to determine CIP',
  `network_segment_id` BIGINT COMMENT 'Reference to the distribution network segment (feeder section, lateral, transformer zone) affected by the outage. Sourced from the GIS network model in Esri ArcGIS Utility Network.',
  `outage_crew_dispatch_id` BIGINT COMMENT 'Reference to the crew dispatch assignment record for field crews assigned to restore this segment. Links to workforce and work order management in Ventyx Asset Suite.',
  `sectionalizing_device_id` BIGINT COMMENT 'Identifier of the switching device (recloser, sectionalizer, fuse, breaker) that performed the isolation of this segment. Sourced from the GIS network model and ADMS device registry. Used for asset performance tracking in Ventyx Asset Suite.',
  `storm_event_id` BIGINT COMMENT 'Reference to the storm or major weather event record associated with this segment impact. Null for non-storm outages. Used for storm response coordination, MED exclusion processing, and FEMA/state emergency reporting.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this segment impact record was first created in the OMS or lakehouse system. Used for audit trail, data lineage, and record provenance tracking.',
  `critical_infrastructure_flag` BOOLEAN COMMENT 'Indicates whether this segment serves critical infrastructure facilities (hospitals, emergency services, water treatment, telecommunications). When true, triggers elevated restoration priority and mandatory regulatory notification.',
  `customers_on_segment` INT COMMENT 'Total number of customer service points (meters) located on this network segment at the time of the outage event. Used as the customer count denominator for SAIDI, SAIFI, and CAIDI reliability index calculations per IEEE 1366.',
  `customers_partially_restored` INT COMMENT 'Number of customers on this segment restored during partial restoration switching operations prior to full segment restoration. Used to accurately credit partial restoration in SAIDI/CAIDI calculations per IEEE 1366.',
  `customers_restored` INT COMMENT 'Number of customer service points on this segment that have been restored to service. Incremented as partial restoration switching operations are completed. Enables real-time tracking of restoration progress.',
  `de_energization_end_timestamp` TIMESTAMP COMMENT 'Date and time when the network segment was fully restored to energized state. Null if the segment has not yet been restored. Used with de_energization_start_timestamp to compute segment outage duration for SAIDI/CAIDI calculations.',
  `de_energization_start_timestamp` TIMESTAMP COMMENT 'Date and time when the network segment was de-energized (lost power) as recorded by the OMS or SCADA system. This is the principal business event timestamp used for SAIDI/SAIFI/CAIDI reliability index calculations per IEEE 1366.',
  `doe_reportable_flag` BOOLEAN COMMENT 'Indicates whether this segment impact is part of an event requiring reporting to the U.S. Department of Energy (DOE) via Form OE-417 (Electric Emergency Incident and Disturbance Report).',
  `estimated_restoration_timestamp` TIMESTAMP COMMENT 'Estimated date and time when the segment is expected to be restored to service. Published to customer notification systems and field crews. Updated dynamically as restoration progresses. Supports ETR (Estimated Time to Restore) commitments to regulators and customers.',
  `fault_location_description` STRING COMMENT 'Textual description of the fault or damage location on this segment as identified by field crews or FLISR analysis (e.g., \'Pole 47 on Oak Street\', \'Underground cable section between manholes MH-12 and MH-14\'). Supports crew navigation and post-event analysis.',
  `flisr_action_type` STRING COMMENT 'Type of Fault Location, Isolation, and Service Restoration (FLISR) automated action applied to this segment. Indicates whether the segment was handled by automatic FLISR logic or required manual crew intervention. Valid values: fault_location|isolation|service_restoration|manual_override|none.',
  `flisr_automated_flag` BOOLEAN COMMENT 'Indicates whether the FLISR (Fault Location, Isolation, and Service Restoration) action for this segment was executed automatically by the ADMS system (true) or required manual crew switching (false). Used to measure ADMS automation effectiveness.',
  `gis_segment_ref` STRING COMMENT 'Reference identifier for this network segment in the Esri ArcGIS Utility Network geospatial model. Enables spatial analysis, outage mapping, and topology-based impact assessment.',
  `impact_status` STRING COMMENT 'Current lifecycle status of the segment impact record. Tracks the progression from initial de-energization through isolation, partial restoration, and full restoration. Drives OMS workflow state transitions in GE PowerOn ADMS. Valid values: de-energized|isolated|partially_restored|restored|cancelled.',
  `is_med_exclusion` BOOLEAN COMMENT 'Indicates whether this segment impact qualifies for Major Event Day (MED) exclusion from SAIDI/SAIFI reliability index calculations per IEEE 1366-2012 beta method. MED exclusions apply during catastrophic storm or disaster events.',
  `is_momentary` BOOLEAN COMMENT 'Indicates whether this segment impact qualifies as a momentary interruption (typically less than 5 minutes per IEEE 1366 definition). Momentary interruptions are counted in MAIFI (Momentary Average Interruption Frequency Index) rather than SAIDI/SAIFI.',
  `is_planned` BOOLEAN COMMENT 'Indicates whether this segment de-energization was a planned maintenance outage (true) or an unplanned/forced interruption (false). Planned outages are typically excluded from SAIDI/SAIFI calculations per IEEE 1366 and state PUC rules.',
  `isolation_method` STRING COMMENT 'The switching or protective device operation method used to isolate this segment from the energized network. Critical for FLISR (Fault Location, Isolation, and Service Restoration) workflow analysis and switching order documentation. Reference-value candidates: automatic_switch|manual_switch|fuse_operation|recloser|sectionalizer|breaker_trip. Valid values: automatic_switch|manual_switch|fuse_operation|recloser|sectionalizer|breaker_trip.',
  `life_support_customers` INT COMMENT 'Number of customers on this segment registered as life-support or medical baseline customers. Elevates restoration priority and triggers mandatory notification protocols per state PUC regulations.',
  `load_mw_at_outage` DECIMAL(10,3) COMMENT 'Estimated electrical load in megawatts (MW) on this segment at the time of de-energization. Sourced from SCADA/OSIsoft PI historian data. Used for load loss reporting, demand response impact assessment, and grid restoration planning.',
  `nerc_reportable_flag` BOOLEAN COMMENT 'Indicates whether this segment impact contributes to a reportable event under NERC reliability standards (e.g., EOP-004 disturbance reporting thresholds). Drives mandatory NERC event reporting workflows.',
  `oms_segment_ref` STRING COMMENT 'Source system reference identifier for this segment impact record as assigned by the GE PowerOn ADMS Outage Management System. Used for cross-system reconciliation and data lineage tracing between the OMS and the lakehouse silver layer.',
  `outage_duration_minutes` INT COMMENT 'Total duration of the de-energization event for this segment in minutes, calculated from de_energization_start_timestamp to de_energization_end_timestamp. Null if segment is not yet restored. Used directly in SAIDI and CAIDI reliability index calculations per IEEE 1366.',
  `partial_restoration_timestamp` TIMESTAMP COMMENT 'Date and time when partial restoration of this segment was achieved (i.e., a subset of customers on the segment were restored via switching operations before full restoration). Null if no partial restoration occurred.',
  `puc_reportable_flag` BOOLEAN COMMENT 'Indicates whether this segment impact must be included in mandatory reliability reporting submissions to the state Public Utility Commission (PUC). Determined by customer count thresholds, duration thresholds, and critical infrastructure involvement.',
  `restoration_method` STRING COMMENT 'Method used to restore this segment to service. Distinguishes between switching-based restoration (no repair needed), physical repair of damaged equipment, temporary bypass, or load transfer to alternate feeder. Valid values: switching|repair|temporary_bypass|load_transfer|none.',
  `restoration_sequence_priority` INT COMMENT 'Numeric priority rank assigned to this segment for restoration sequencing within the outage event. Lower values indicate higher priority. Drives crew dispatch order and switching plan execution. Considers life-support customers, critical infrastructure, and load size.',
  `segment_code` STRING COMMENT 'Externally-known alphanumeric identifier for the distribution network segment as maintained in the GIS and ADMS systems (e.g., feeder section code, lateral identifier). Used for cross-system reconciliation with GE PowerOn ADMS and Esri ArcGIS Utility Network. Pattern: ^[A-Z0-9_-]{3,30}$.',
  `segment_name` STRING COMMENT 'Human-readable descriptive name of the impacted distribution network segment (e.g., \'Oak Street Lateral 3\', \'Feeder 12A Section 4\'). Used in operational dashboards and crew dispatch communications.',
  `segment_type` STRING COMMENT 'Classification of the distribution network segment topology type. Determines the scope of impact and applicable FLISR (Fault Location, Isolation, and Service Restoration) switching logic. Reference-value candidates: feeder_section|lateral|transformer_zone|substation_bus|service_point_group|tie_line. Valid values: feeder_section|lateral|transformer_zone|substation_bus|service_point_group|tie_line.',
  `switching_order_number` STRING COMMENT 'Reference number of the switching order issued to field crews for isolating or restoring this segment. Links to the switching order management workflow in GE PowerOn ADMS. Required for audit trail of all switching operations. Pattern: ^[A-Z0-9-]{4,30}$.',
  `to_outage_event` BIGINT COMMENT 'FK to outage.outage_event.outage_event_id — Network segment impacts are recorded per outage event. Required for topology-based outage analysis and FLISR workflow tracking.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this segment impact record was last modified. Tracks updates to restoration status, customer counts, ETR, and other operational fields throughout the outage lifecycle.',
  `voltage_level_kv` DECIMAL(6,2) COMMENT 'Nominal operating voltage of the impacted network segment in kilovolts (kV). Used to classify the segment within the distribution voltage hierarchy (e.g., 4kV, 12kV, 25kV, 34.5kV) and determine applicable switching procedures.',
  `weather_condition` STRING COMMENT 'Prevailing weather condition at the time of the segment de-energization. Used for storm-related outage analysis, MED exclusion determination, and regulatory storm reporting. Reference-value candidates: normal|wind|ice|lightning|flood|heat|snow|hurricane|tornado.',
  `work_order_number` STRING COMMENT 'Work order number from the asset management system (Ventyx Asset Suite or SAP S/4HANA Plant Maintenance) associated with the restoration or repair activity for this segment impact. Pattern: ^[A-Z0-9-]{4,30}$.',
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
  CONSTRAINT `pk_outage_segment_impact` PRIMARY KEY (`segment_impact_id`)
)
USING DELTA
COMMENT 'Record of a specific distribution network segment (feeder section, lateral, transformer zone) impacted by an outage event. Captures segment identifier, segment type, de-energization start and end timestamps, isolation method, number of customers on segment, and restoration sequence priority. Enables network topology-based outage analysis and supports FLISR (Fault Location, Isolation, and Service Restoration) workflow tracking. | CMM: CIM OutageArea (close), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SegmentImpact',
  'cmm.cim.class' = 'OutageArea',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.segment_impact',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- OutageFlisrEvent  <<CIM PSREvent : extension>>
CREATE TABLE IF NOT EXISTS `outage`.`outage_flisr_event` (
  `outage_flisr_event_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for each automated FLISR execution event record in the distribution network self-healing system.',
  `audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: Automated FLISR operations on critical infrastructure are audited for compliance with operational reliability standards. Compliance audits review FLISR algorithm performance, operator override decisio',
  `cause_id` BIGINT COMMENT 'Reference to the outage cause classification record that categorizes the root cause of the fault triggering this FLISR event (e.g., equipment failure, tree contact, animal contact, lightning). Links to the outage_cause reference product for NERC/PUC cause code reporting.',
  `distribution_substation_id` BIGINT COMMENT 'Reference to the substation from which the faulted feeder originates. Used for geographic and operational scoping of the FLISR event.',
  `event_id` BIGINT COMMENT 'Reference to the parent outage event that triggered this FLISR execution. Links the automated self-healing action to the broader outage lifecycle record in the Outage Management System (OMS).',
  `network_segment_id` BIGINT COMMENT 'Identifier of the specific distribution network segment (line section, cable section, or switch zone) determined by the FLISR algorithm to contain the fault. Sourced from the GIS/Utility Network model.',
  `primary_outage_feeder_id` BIGINT COMMENT 'Reference to the distribution feeder on which the fault was detected and FLISR was triggered. Identifies the primary circuit affected by the fault event.',
  `sectionalizing_device_id` BIGINT COMMENT 'Identifier of the normally-open tie switch operated by the FLISR algorithm to transfer load to the alternate feeder during restoration. Sourced from the GIS/Utility Network model. Critical for post-event switching order reconciliation.',
  `tie_switch_asset_registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: FLISR (Fault Location, Isolation, Service Restoration) events use tie switches to transfer load between feeders. Linking to asset_registry enables tracking tie switch operation counts, maintenance nee',
  `adms_event_ref` STRING COMMENT 'Native event reference identifier assigned by the GE PowerOn ADMS system for this FLISR execution. Enables cross-system traceability between the data lakehouse record and the operational ADMS source system.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this FLISR event record was first created in the data platform. Serves as the audit trail creation marker for data lineage and compliance purposes.',
  `customers_affected_total` INT COMMENT 'Total number of customer service points de-energized as a result of the fault event prior to any FLISR restoration actions. Used as the baseline for SAIFI and SAIDI reliability index calculations per IEEE 1366.',
  `customers_requiring_manual` INT COMMENT 'Number of customer service points within the faulted segment that could not be restored automatically by FLISR and require manual crew dispatch and switching operations for restoration. Drives crew dispatch prioritization.',
  `customers_restored_auto` INT COMMENT 'Number of customer service points successfully restored to service by the FLISR automated switching and load transfer actions, without requiring manual crew intervention. Key metric for measuring FLISR effectiveness and SAIDI/CAIDI improvement.',
  `doe_reportable_flag` BOOLEAN COMMENT 'Indicates whether this FLISR event is associated with an outage that meets DOE OE-417 reporting thresholds (e.g., affecting 50,000+ customers or critical infrastructure). Triggers mandatory federal emergency reporting.',
  `event_status` STRING COMMENT 'Current lifecycle status of the FLISR execution event. \'initiated\' = algorithm triggered; \'in_progress\' = isolation/restoration actions underway; \'completed\' = full automated restoration achieved; \'failed\' = algorithm could not restore; \'partial\' = some customers restored automatically, remainder require manual intervention; \'cancelled\' = FLISR aborted before completion. Valid values: initiated|in_progress|completed|failed|partial|cancelled.',
  `failure_reason` STRING COMMENT 'Descriptive reason code or message explaining why the FLISR execution failed or was aborted. Populated only when outcome is \'failure\' or \'aborted\'. Examples: capacity constraint on alternate feeder, communication failure to remote switch, operator override, protection relay lockout.',
  `fault_detected_timestamp` TIMESTAMP COMMENT 'Date and time when the fault on the distribution network was first detected by the ADMS/FLISR system, triggering the automated response sequence. This is the principal business event timestamp for SAIDI/SAIFI/CAIDI reliability index calculations per IEEE 1366.',
  `fault_distance_m` DECIMAL(10,2) COMMENT 'Estimated distance in meters from the substation or reference point to the calculated fault location on the feeder, as determined by the FLISR impedance-based fault location algorithm. Used for crew dispatch and asset inspection prioritization.',
  `fault_location_confidence` STRING COMMENT 'Confidence level assigned by the FLISR algorithm to its fault location determination. Influences whether automated restoration proceeds or is held pending manual verification. High confidence enables full automation; low confidence may trigger manual review. Valid values: high|medium|low|unconfirmed.',
  `fault_type` STRING COMMENT 'Electrical classification of the fault detected on the distribution network. Determines the FLISR algorithm\'s isolation and restoration strategy. Phase-to-ground is the most common distribution fault type. Valid values: phase_to_ground|phase_to_phase|three_phase|open_conductor|unknown.',
  `flisr_algorithm_version` STRING COMMENT 'Version identifier of the FLISR algorithm deployed in the ADMS at the time of this event execution. Critical for reproducibility analysis, algorithm performance benchmarking, and post-event audit of automated decision logic.',
  `flisr_event_number` STRING COMMENT 'Human-readable, externally referenceable identifier for this FLISR execution event, as assigned by the Advanced Distribution Management System (ADMS). Used in operational reports, regulatory filings, and cross-system correlation.',
  `is_momentary` BOOLEAN COMMENT 'Indicates whether the fault event was classified as a momentary interruption (duration ≤ 5 minutes per IEEE 1366) rather than a sustained outage. Momentary events are tracked under MAIFI rather than SAIFI/SAIDI for reliability reporting.',
  `isolation_completed_timestamp` TIMESTAMP COMMENT 'Date and time when the FLISR algorithm completed all automated isolation switching actions to contain the faulted segment. Marks the end of the isolation phase and the start of the restoration phase.',
  `isolation_duration_seconds` INT COMMENT 'Elapsed time in seconds from fault detection to completion of all automated isolation switching actions. Key performance indicator for FLISR speed and ADMS response time benchmarking.',
  `isolation_switch_count` INT COMMENT 'Total number of automated switching operations executed by the FLISR algorithm during the isolation phase to contain the faulted segment. Used for asset wear tracking and switching order audit.',
  `life_support_customers_affected` INT COMMENT 'Number of registered life support or medical baseline customers within the affected area of this FLISR event. Used to prioritize restoration sequencing and trigger mandatory customer notification per state PUC medical baseline rules.',
  `load_transferred_mw` DECIMAL(10,3) COMMENT 'Total electrical load in megawatts (MW) transferred to alternate feeders or tie switches by the FLISR algorithm during the restoration phase. Used to assess grid capacity utilization and validate load transfer feasibility.',
  `nerc_reportable_flag` BOOLEAN COMMENT 'Indicates whether this FLISR event is associated with an outage that meets NERC reporting thresholds and must be reported to NERC under applicable reliability standards (e.g., EOP-004). Drives regulatory reporting workflow.',
  `oms_incident_number` STRING COMMENT 'Incident number assigned by the Outage Management System (OMS) to the outage event associated with this FLISR execution. Enables correlation between automated FLISR actions and the broader outage incident record for regulatory reporting.',
  `operator_override_flag` BOOLEAN COMMENT 'Indicates whether a dispatcher or system operator manually intervened to override, modify, or abort the FLISR automated execution sequence. True = operator intervention occurred; False = fully automated execution without human intervention.',
  `operator_override_reason` STRING COMMENT 'Free-text description of the reason a dispatcher or operator overrode the FLISR automated execution. Populated only when operator_override_flag is True. Used for post-event analysis and FLISR algorithm improvement.',
  `outcome` STRING COMMENT 'Overall outcome of the FLISR execution event. \'success\' = all restorable customers restored automatically; \'partial_success\' = some customers restored, remainder require manual intervention; \'failure\' = FLISR could not execute any restoration; \'aborted\' = execution halted due to constraint violation or operator override. Valid values: success|partial_success|failure|aborted.',
  `pre_fault_load_mw` DECIMAL(10,3) COMMENT 'Total electrical load in megawatts (MW) on the affected feeder immediately prior to the fault event, as recorded by the ADMS/SCADA historian. Used to assess load transfer feasibility and post-restoration capacity margin.',
  `protection_relay_operated_flag` BOOLEAN COMMENT 'Indicates whether a protection relay (recloser, sectionalizer, or breaker) operated to initiate the fault isolation sequence that triggered FLISR. True = relay operation confirmed; False = FLISR triggered by other detection method (e.g., SCADA alarm, voltage sag detection).',
  `recloser_operations_count` INT COMMENT 'Number of automatic recloser operations that occurred on the faulted circuit prior to FLISR lockout and isolation. Used to distinguish momentary interruptions from sustained outages for IEEE 1366 MAIFI vs SAIFI classification.',
  `restoration_completed_timestamp` TIMESTAMP COMMENT 'Date and time when the FLISR algorithm completed all automated load transfer and service restoration actions. Customers restored after this timestamp required manual crew intervention.',
  `restoration_duration_seconds` INT COMMENT 'Elapsed time in seconds from completion of fault isolation to completion of all automated load transfer and service restoration actions. Used to measure FLISR restoration speed and its contribution to CAIDI reduction.',
  `restoration_switch_count` INT COMMENT 'Total number of automated switching operations executed by the FLISR algorithm during the load transfer and service restoration phase. Distinct from isolation switch count — represents the re-energization actions.',
  `scada_communication_status` STRING COMMENT 'Status of SCADA communication to the affected field devices (switches, reclosers, sensors) at the time of FLISR execution. \'degraded\' or \'failed\' communication may limit FLISR automation capability and is a key factor in partial or failed outcomes. Valid values: normal|degraded|failed.',
  `storm_event_flag` BOOLEAN COMMENT 'Indicates whether this FLISR event occurred during a declared major event or storm. Major event exclusions per IEEE 1366 may apply to SAIDI/SAIFI calculations when this flag is True.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this FLISR event record was most recently modified in the data platform. Supports audit trail and incremental data pipeline processing.',
  `voltage_level_kv` DECIMAL(6,2) COMMENT 'Nominal operating voltage in kilovolts (kV) of the distribution circuit on which the FLISR event occurred. Determines applicable switching procedures, safety clearances, and regulatory reporting thresholds.',
  `weather_condition` STRING COMMENT 'Prevailing weather condition recorded at the time of the fault event (e.g., clear, wind, lightning, ice, flooding). Used for outage cause analysis, storm event classification, and reliability reporting under IEEE 1366 Major Event Day criteria. Reference-value candidates: clear|wind|lightning|ice|flooding|snow|fog|extreme_heat|unknown.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_outage_outage_flisr_event` PRIMARY KEY (`outage_flisr_event_id`)
)
USING DELTA
COMMENT 'Record of an automated FLISR (Fault Location, Isolation, and Service Restoration) execution triggered by a fault on the distribution network. Captures fault detection timestamp, faulted segment, isolation actions taken automatically, load transfer actions, customers restored automatically vs. requiring manual intervention, FLISR algorithm version, and success/failure outcome. Distinct from manual switching orders — represents automated grid self-healing actions. | CMM: CIM PSREvent (extension), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'OutageFlisrEvent',
  'cmm.cim.class' = 'PSREvent',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.outage_flisr_event'
);

-- SafetyClearance  <<CIM ClearanceDocument : exact>>
CREATE TABLE IF NOT EXISTS `outage`.`safety_clearance` (
  `safety_clearance_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for the safety clearance record in the lakehouse. Primary key for the safety_clearance data product. Entity role: TRANSACTION_HEADER — a discrete, lifecycle-managed safety authorization event issued to protect field crews working on de-energized equipment.',
  `approver_employee_id` BIGINT COMMENT 'Reference to the supervisor, lead dispatcher, or safety officer who approved the issuance of this safety clearance, where a dual-authorization workflow is required. May be the same as the issuing dispatcher in single-authority configurations.',
  `compliance_sox_control_id` BIGINT COMMENT 'Foreign key linking to compliance.sox_control. Business justification: Safety clearance processes for critical infrastructure work may be subject to SOX internal controls over operational safety and asset protection. Internal audit tests safety clearance controls as part',
  `distribution_substation_id` BIGINT COMMENT 'Reference to the substation where the de-energized equipment covered by this clearance is located. Used for geographic scoping of the clearance and for SAIDI/SAIFI reliability reporting.',
  `event_id` BIGINT COMMENT 'Reference to the outage event during which this safety clearance was issued. Links the clearance to the associated unplanned interruption or planned maintenance outage driving the switching and restoration work.',
  `feeder_id` BIGINT COMMENT 'Reference to the distribution feeder or circuit segment on which the safety clearance applies. Enables feeder-level aggregation of active clearances for dispatcher situational awareness and restoration sequencing.',
  `grid_switching_order_id` BIGINT COMMENT 'Foreign key linking to grid.grid_switching_order. Business justification: Safety clearances are issued for grid switching orders to protect field crews. Linking enables safety compliance tracking, OSHA documentation, and lockout/tagout procedure enforcement.',
  `primary_safety_employee_id` BIGINT COMMENT 'Reference to the control room dispatcher or system operator who formally issued this safety clearance. The issuing authority is accountable for verifying equipment de-energization and isolation before granting clearance. Satisfies PARTY_REFERENCE category for TRANSACTION_HEADER role.',
  `registry_id` BIGINT COMMENT 'Reference to the primary electrical equipment asset (transformer, circuit breaker, switch, line segment, cable, bus section) covered by this safety clearance. Sourced from the asset registry in Ventyx Asset Suite or Esri ArcGIS Utility Network.',
  `tertiary_safety_release_authorized_by_employee_id` BIGINT COMMENT 'Reference to the dispatcher or supervisor who authorized the release of this safety clearance after confirming all crew members are clear of the work zone and equipment is ready for re-energization. May differ from the original issuing dispatcher.',
  `work_order_id` BIGINT COMMENT 'Reference to the maintenance or restoration work order in the asset management system (Ventyx Asset Suite / SAP S/4HANA PM) that this safety clearance supports. Enables traceability between safety clearances and planned work activities.',
  `adms_switching_ref` STRING COMMENT 'Reference identifier from the GE PowerOn Advanced Distribution Management System (ADMS) linking this safety clearance to the associated switching sequence or network model state. Enables traceability to the ADMS network topology at the time of clearance issuance.',
  `cancellation_reason` STRING COMMENT 'Free-text description of the reason this safety clearance was cancelled before use or suspended mid-work. Populated only when clearance_status is \'cancelled\' or \'suspended\'. Required for safety audit trail and incident investigation.',
  `clearance_number` STRING COMMENT 'Externally-known, human-readable alphanumeric identifier for the safety clearance, as assigned by the OMS or switching management system (e.g., GE PowerOn ADMS). Used by dispatchers, field crews, and control room operators to reference the clearance in verbal and written communications. Satisfies BUSINESS_IDENTIFIER category for TRANSACTION_HEADER role.',
  `clearance_purpose` STRING COMMENT 'Business purpose for which the safety clearance was issued. Outage Restoration: unplanned outage repair. Planned Maintenance: scheduled preventive or corrective maintenance. Emergency Repair: urgent unplanned repair outside normal outage workflow. Inspection: equipment inspection requiring de-energization. Construction: new construction or capital project work. Storm Response: clearance issued during declared storm event. Valid values: outage_restoration|planned_maintenance|emergency_repair|inspection|construction|storm_response.',
  `clearance_status` STRING COMMENT 'Current lifecycle state of the safety clearance. Requested: clearance has been requested but not yet issued. Issued: clearance has been formally issued to the holding crew member. Active: crew is actively working under the clearance. Suspended: clearance temporarily suspended (e.g., weather hold). Released: clearance has been formally released and equipment may be re-energized. Cancelled: clearance voided before use. Expired: clearance lapsed without formal release. Satisfies LIFECYCLE_STATUS category for TRANSACTION_HEADER role. Reference-value candidates: requested|issued|active|suspended|released|cancelled|expired.',
  `clearance_to_switching_order` BIGINT COMMENT 'FK to outage.switching_order.switching_order_id — Safety clearances are issued in context of switching orders to protect crews. Must link for safety compliance and clearance release workflow.',
  `clearance_type` STRING COMMENT 'Classification of the safety clearance instrument issued to protect field crew. Hold Tag: prevents re-energization while crew is on equipment. Clearance Tag: formal authorization to work on de-energized equipment. Ground Placement: physical grounding of conductors for crew protection. Danger Tag: prohibits operation of tagged device. Caution Tag: advisory restriction. Equipment Tag: equipment-specific isolation marker. Reference-value candidates: hold_tag|clearance_tag|ground_placement|danger_tag|caution_tag|equipment_tag. Valid values: hold_tag|clearance_tag|ground_placement|danger_tag|caution_tag|equipment_tag.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this safety clearance record was first created in the OMS or switching management system. Satisfies RECORD_AUDIT_CREATED category for TRANSACTION_HEADER role. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `crew_count` INT COMMENT 'Number of field crew members working under this safety clearance. Used for crew accountability tracking and to ensure all crew members are clear of the work zone before the clearance is released and equipment is re-energized.',
  `crew_type` STRING COMMENT 'Classification of the field crew holding this safety clearance. Line Crew: distribution line workers. Substation Crew: substation maintenance technicians. Transmission Crew: high-voltage transmission workers. Contractor Crew: third-party contracted crew. Mutual Aid Crew: crew deployed under a mutual aid agreement from another utility. Valid values: line_crew|substation_crew|transmission_crew|contractor_crew|mutual_aid_crew.',
  `customers_affected_count` INT COMMENT 'Number of customers de-energized as a result of the switching and isolation actions associated with this safety clearance. Used for SAIDI/SAIFI/CAIDI reliability index calculation and customer notification prioritization.',
  `equipment_description` STRING COMMENT 'Human-readable description of the electrical equipment covered by this safety clearance, including equipment name, type, and location identifier as recorded in the OMS or GIS. Supplements the equipment_id for dispatcher and crew reference.',
  `grounds_applied` BOOLEAN COMMENT 'Indicates whether physical protective grounds have been applied to the de-energized conductors or equipment covered by this clearance. True = grounds applied; False = no grounds applied. Grounding is mandatory for certain voltage levels and work types per OSHA 29 CFR 1910.269.',
  `grounds_location_description` STRING COMMENT 'Textual description of the specific locations where protective grounds have been applied (e.g., \'North side of pole 47A, phase A-B-C\'). Required when grounds_applied is True. Used for crew safety verification and clearance release sequencing.',
  `hazard_notes` STRING COMMENT 'Free-text field capturing specific hazard conditions, safety warnings, or special precautions associated with this clearance (e.g., proximity to energized conductors, confined space entry, asbestos presence, wildlife hazards). Communicated to field crew at time of clearance issuance.',
  `isolation_point_description` STRING COMMENT 'Textual description of the electrical isolation boundary for this safety clearance, identifying all open points, switches, and disconnects that define the de-energized zone. Critical for crew safety verification and dispatcher situational awareness.',
  `issued_timestamp` TIMESTAMP COMMENT 'Date and time when the safety clearance was formally issued to the holding crew member by the issuing dispatcher. This is the principal real-world business event time for the clearance lifecycle. Satisfies BUSINESS_EVENT_TIMESTAMP category for TRANSACTION_HEADER role. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `life_support_customers_flag` BOOLEAN COMMENT 'Indicates whether any customers dependent on life support equipment (medical baseline, life support registry) are within the de-energized zone covered by this safety clearance. True = life support customers affected. Triggers priority restoration and mandatory customer notification per PUC rules.',
  `lockout_tagout_ref` STRING COMMENT 'Reference number for the associated Lockout/Tagout (LOTO) procedure document or energy control program record, as required by OSHA 29 CFR 1910.147 for control of hazardous energy. Links the safety clearance to the formal LOTO documentation package.',
  `nerc_reportable_flag` BOOLEAN COMMENT 'Indicates whether the switching and clearance activity associated with this safety clearance is subject to NERC reliability standard reporting requirements (e.g., FAC-001, FAC-002, or CIP-related switching). True = NERC reportable.',
  `network_segment_description` STRING COMMENT 'Description of the electrical network segment (feeder section, bus section, transmission line segment) covered by this safety clearance, including circuit identifiers and geographic boundaries. Used for dispatcher situational awareness and restoration sequencing.',
  `oms_clearance_ref` STRING COMMENT 'Native clearance or safety tag identifier as recorded in the source Outage Management System (GE PowerOn ADMS). Used for cross-system traceability between the lakehouse silver layer record and the operational OMS source record.',
  `osha_compliance_verified` BOOLEAN COMMENT 'Indicates whether all applicable OSHA 29 CFR 1910.269 electrical safety requirements have been verified and documented prior to issuing this clearance, including minimum approach distances, PPE requirements, and lockout/tagout procedures. True = OSHA compliance verified.',
  `planned_outage_flag` BOOLEAN COMMENT 'Indicates whether this safety clearance was issued in support of a planned (scheduled) outage rather than an unplanned interruption. True = planned outage; False = unplanned/emergency outage. Used for SAIDI/SAIFI planned vs. unplanned reliability index segregation.',
  `priority_level` STRING COMMENT 'Priority classification for this safety clearance, reflecting the urgency of the associated restoration or maintenance work. Critical: life safety or critical infrastructure. High: large customer impact or time-sensitive restoration. Normal: standard planned or unplanned work. Low: minor maintenance with minimal customer impact. Valid values: critical|high|normal|low.',
  `regulatory_notes` STRING COMMENT 'Free-text field for regulatory compliance notes associated with this safety clearance, including NERC FAC, OSHA, or PUC-specific documentation requirements, special reporting obligations, or compliance exceptions noted at time of issuance.',
  `released_timestamp` TIMESTAMP COMMENT 'Date and time when the safety clearance was formally released by the holding crew member and acknowledged by the issuing dispatcher, signaling that the equipment may be re-energized. Null if the clearance has not yet been released. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `requested_timestamp` TIMESTAMP COMMENT 'Date and time when the field crew or work planner submitted the request for this safety clearance to the control room. Used to measure dispatcher response time and clearance issuance latency for safety performance reporting. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `safety_state_verified` BOOLEAN COMMENT 'Indicates whether the issuing dispatcher has formally verified that the equipment is in a safe de-energized state (confirmed open isolation points, absence of voltage, and grounding where required) prior to issuing the clearance. True = verified; False = not yet verified. Required for OSHA and NERC FAC compliance.',
  `scheduled_end_timestamp` TIMESTAMP COMMENT 'Planned date and time when field work under this safety clearance is expected to be completed and the clearance released. Used for outage duration estimation and customer notification ETR (Estimated Time of Restoration). Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `scheduled_start_timestamp` TIMESTAMP COMMENT 'Planned date and time when field work under this safety clearance is scheduled to begin. Used for planned maintenance windows and pre-scheduled outage coordination. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `storm_event_flag` BOOLEAN COMMENT 'Indicates whether this safety clearance was issued during a declared major event or storm restoration. True = storm event clearance. Used to segregate storm-related clearances for major event day (MED) exclusion in IEEE 1366 reliability reporting.',
  `to_switching_order` BIGINT COMMENT 'FK to outage.switching_order.switching_order_id — Safety clearances are issued in conjunction with switching orders. Required for OSHA/NERC FAC compliance — every clearance must trace to the switching activity it protects.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this safety clearance record was last modified in the source system. Satisfies RECORD_AUDIT_UPDATED category for TRANSACTION_HEADER role. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `version_number` INT COMMENT 'Incremental version counter for this safety clearance record, tracking revisions such as scope extensions, crew changes, or re-issuance after suspension. Supports audit trail requirements and change history for regulatory compliance.',
  `voltage_level_kv` DECIMAL(10,3) COMMENT 'Nominal operating voltage level in kilovolts (kV) of the equipment covered by this safety clearance. Determines the applicable OSHA electrical safety standards, required personal protective equipment (PPE), and minimum approach distances for field crew.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_outage_safety_clearance` PRIMARY KEY (`safety_clearance_id`)
)
USING DELTA
COMMENT 'Formal safety clearance (hold tag, clearance tag, or ground placement) issued to protect field crews working on de-energized equipment during outage restoration or planned maintenance. Captures clearance type, issuing authority, equipment covered, clearance issue and release timestamps, crew member holding the clearance, and safety state verification. Required for OSHA and NERC FAC compliance during switching and restoration operations. | CMM: CIM ClearanceDocument (exact), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SafetyClearance',
  'cmm.cim.class' = 'ClearanceDocument',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.safety_clearance'
);

-- PucOutageReport  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `outage`.`puc_outage_report` (
  `puc_outage_report_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for each PUC outage report record in the silver layer lakehouse. Primary key for this entity.',
  `event_id` BIGINT COMMENT 'Reference to the underlying outage event that triggered this PUC regulatory report. Links the formal filing to the operational outage record in the Outage Management System (OMS).',
  `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: PUC outage reports are a specific type of regulatory filing with docket numbers, submission tracking, and approval workflows. Compliance teams manage outage reports within the broader regulatory filin',
  `superseded_by_report_puc_outage_report_id` BIGINT COMMENT 'Reference to the newer puc_outage_report_id that supersedes this record when a corrected or amended report has been filed. Null if this is the current active version. Enables version chain traversal for audit purposes.',
  `actual_filing_timestamp` TIMESTAMP COMMENT 'Date and time when this report was actually submitted to the state PUC. Compared against filing_deadline_timestamp to determine on-time compliance. This is the principal business event timestamp for the report transaction.',
  `affected_counties` STRING COMMENT 'Comma-separated list of county names within the utility service territory that experienced customer interruptions during this outage event. Required by many state PUCs for geographic impact assessment and emergency management coordination.',
  `affected_service_territory` STRING COMMENT 'Description of the geographic service territory area impacted by the outage, such as county names, city names, or distribution circuit identifiers. Used in PUC reports to communicate the geographic scope of the event to regulators.',
  `cause_narrative` STRING COMMENT 'Free-text narrative description of the root cause of the outage event as submitted in the PUC report. Provides detailed explanation beyond the cause category code, including contributing factors, sequence of events, and any relevant environmental or equipment conditions.',
  `corrective_action_due_date` DATE COMMENT 'Target completion date for the corrective action plan committed to in the final PUC report. Used for regulatory follow-up tracking and compliance monitoring.',
  `corrective_action_plan` STRING COMMENT 'Free-text description of the corrective actions taken or planned to prevent recurrence of the outage event. Required in final PUC reports. Includes infrastructure improvements, maintenance program changes, vegetation management, and operational procedure updates.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this PUC outage report record was first created in the lakehouse silver layer. Represents the audit trail creation timestamp for data governance and lineage tracking.',
  `customers_affected_count` INT COMMENT 'Total number of customer accounts that experienced an interruption during this outage event. Used to determine whether the event meets PUC reportable customer threshold (e.g., >50,000 customers) and for System Average Interruption Frequency Index (SAIFI) calculations.',
  `customers_restored_count` INT COMMENT 'Number of customer accounts that have been restored to service as of the time this report was filed. For final reports, this should equal customers_affected_count. For initial and update reports, tracks restoration progress.',
  `estimated_restoration_timestamp` TIMESTAMP COMMENT 'Estimated date and time by which all affected customers are expected to be restored, as reported in initial and update PUC filings. The Estimated Time of Restoration (ETR) is a key metric for customer communication and regulatory scrutiny during major events.',
  `filing_deadline_timestamp` TIMESTAMP COMMENT 'Regulatory deadline by which this report type (initial, update, or final) must be submitted to the state PUC. Calculated based on outage_start_timestamp and the applicable PUC reporting rules for the jurisdiction. Used for compliance monitoring and SLA tracking.',
  `is_filed_on_time` BOOLEAN COMMENT 'Indicates whether the report was submitted to the PUC at or before the filing_deadline_timestamp. Used for regulatory compliance tracking, internal audit, and PUC performance reporting.',
  `is_major_event_day` BOOLEAN COMMENT 'Indicates whether this outage occurred on a day classified as a Major Event Day (MED) per IEEE 1366 beta method. MED events are typically excluded from SAIDI/SAIFI baseline calculations but must still be reported to the PUC separately.',
  `is_nerc_reportable` BOOLEAN COMMENT 'Indicates whether this outage event also meets NERC EOP-004 reporting thresholds and has been or must be filed with NERC in addition to the state PUC. Enables cross-regulatory compliance tracking.',
  `is_storm_event` BOOLEAN COMMENT 'Indicates whether this outage was caused by or associated with a declared storm event. Storm-related outages may have different PUC reporting requirements, extended restoration time allowances, and separate cost recovery treatment.',
  `life_support_customers_affected` INT COMMENT 'Number of customers registered on the utility\'s life support or medical baseline program who were affected by this outage. PUC regulations typically require special notification and prioritized restoration for life support customers, and this count is a required field in many state PUC outage reports.',
  `mutual_aid_activated` BOOLEAN COMMENT 'Indicates whether mutual aid assistance from other utilities was requested and activated in response to this outage event. Mutual aid activation is a reportable fact in many state PUC major event reports and NERC EOP-004 filings.',
  `nerc_event_report_number` STRING COMMENT 'NERC-assigned event report number for the corresponding NERC EOP-004 filing, when applicable. Enables cross-referencing between the state PUC report and the federal NERC submission for the same outage event.',
  `oms_incident_number` STRING COMMENT 'Reference number of the corresponding incident record in the Outage Management System (OMS), specifically GE PowerOn ADMS. Enables traceability between the regulatory PUC report and the operational OMS incident record.',
  `outage_cause_category` STRING COMMENT 'High-level cause category for the outage event as reported to the PUC. Derived from the OMS outage cause classification and mapped to PUC-required cause taxonomy. Distinct from the detailed cause code in the outage_cause reference product. Valid values: weather|equipment_failure|human_error|third_party|unknown|other.',
  `outage_duration_minutes` INT COMMENT 'Total duration of the outage event in minutes, measured from outage_start_timestamp to outage_end_timestamp. Used to assess whether the event meets PUC reportable duration thresholds (e.g., >8 hours) and for SAIDI/CAIDI reliability index calculations.',
  `outage_end_timestamp` TIMESTAMP COMMENT 'Date and time when the last affected customer was restored and the outage event was officially closed. Used to calculate total outage duration for SAIDI/CAIDI reporting and to confirm restoration completion.',
  `outage_start_timestamp` TIMESTAMP COMMENT 'Date and time when the reportable outage event began, as recorded in the Outage Management System (OMS). This is the principal real-world event time used to calculate outage duration and filing deadline compliance.',
  `outage_type` STRING COMMENT 'Classification of the outage by the level of the electric grid affected. Transmission-level events typically have lower PUC reporting thresholds than distribution events. Used to route reports to the appropriate regulatory body and apply correct reporting rules. Valid values: transmission|distribution|generation|substation.',
  `prepared_by_name` STRING COMMENT 'Full name of the utility employee responsible for preparing and submitting this PUC outage report. Required for regulatory accountability and as the point of contact for PUC inquiries about the filing.',
  `prepared_by_phone` STRING COMMENT 'Direct phone number of the utility employee who prepared this PUC outage report. Provided to the PUC as the contact number for follow-up questions regarding the filing.',
  `prepared_by_title` STRING COMMENT 'Job title of the utility employee who prepared this PUC outage report (e.g., \'Manager, Regulatory Affairs\', \'Director, Grid Operations\'). Required by some PUCs to confirm appropriate organizational authority for the filing.',
  `puc_acknowledgment_status` STRING COMMENT 'Status of the PUC\'s formal acknowledgment or acceptance of this report filing. \'pending\' indicates awaiting PUC response; \'acknowledged\' indicates receipt confirmed; \'accepted\' indicates formally accepted without deficiency; \'rejected\' indicates returned with deficiency notice requiring resubmission. Valid values: pending|acknowledged|accepted|rejected.',
  `puc_acknowledgment_timestamp` TIMESTAMP COMMENT 'Date and time when the state PUC formally acknowledged or responded to this report filing. Null if acknowledgment has not yet been received.',
  `puc_docket_number` STRING COMMENT 'Official docket or case number assigned by the state PUC upon receipt of the outage report. Used for tracking the regulatory proceeding and all subsequent correspondence with the commission.',
  `puc_jurisdiction_state` STRING COMMENT 'Two-letter US state code identifying the state Public Utility Commission (PUC) to which this report is filed. Determines applicable reporting thresholds, deadlines, and format requirements. Pattern: ^[A-Z]{2}$.',
  `puc_rejection_reason` STRING COMMENT 'Free-text description of the reason provided by the PUC for rejecting or returning this report filing. Populated only when puc_acknowledgment_status is \'rejected\'. Used to guide corrective resubmission.',
  `puc_report_to_outage_event` BIGINT COMMENT 'FK to outage.outage_event.outage_event_id — PUC reports are filed for specific qualifying outage events. Must link to the event(s) being reported for regulatory traceability.',
  `report_number` STRING COMMENT 'Externally-known, human-readable report identifier assigned by the reporting utility and submitted to the state PUC. Used as the official reference number in all regulatory correspondence and acknowledgment tracking (e.g., PUC-2024-OUT-00123).',
  `report_status` STRING COMMENT 'Current lifecycle status of this regulatory report filing. \'draft\' indicates preparation in progress; \'submitted\' indicates filed with PUC; \'acknowledged\' indicates PUC receipt confirmed; \'accepted\' indicates PUC formally accepted; \'rejected\' indicates PUC returned for correction; \'superseded\' indicates replaced by a subsequent filing. Valid values: draft|submitted|acknowledged|accepted|rejected|superseded.',
  `report_type` STRING COMMENT 'Indicates the filing stage of this report submission: \'initial\' (first notification within required timeframe), \'update\' (interim progress report), or \'final\' (complete post-restoration report with root cause and corrective actions). Multiple report types may exist per outage event. Valid values: initial|update|final.',
  `report_version` INT COMMENT 'Sequential version number of this report record, incremented each time the report is revised and resubmitted to the PUC. Version 1 represents the original submission; subsequent versions represent amendments or corrections.',
  `reporting_utility_name` STRING COMMENT 'Legal name of the electric utility entity filing this PUC outage report. Required on all regulatory submissions to identify the responsible regulated entity.',
  `reporting_utility_nerc_code` STRING COMMENT 'NERC-assigned registered entity identifier for the reporting utility. Used to cross-reference NERC EOP-004 filings and to uniquely identify the utility across multi-state regulatory submissions.',
  `saidi_contribution_minutes` DECIMAL(10,4) COMMENT 'This outage event\'s contribution to the utility\'s System Average Interruption Duration Index (SAIDI), calculated as (customer_interruption_minutes / total_customers_served). Reported to the PUC as part of annual reliability performance metrics.',
  `saifi_contribution` DECIMAL(10,6) COMMENT 'This outage event\'s contribution to the utility\'s System Average Interruption Frequency Index (SAIFI), calculated as (customers_affected / total_customers_served). Reported to the PUC as part of annual reliability performance metrics.',
  `to_outage_event` BIGINT COMMENT 'FK to outage.outage_event.outage_event_id — PUC reports are filed for specific qualifying outage events. Required for regulatory compliance tracking.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this PUC outage report record was last modified in the lakehouse silver layer. Used for incremental data processing, change detection, and audit trail maintenance.',
  `voltage_level_kv` DECIMAL(10,3) COMMENT 'Nominal voltage level in kilovolts (kV) of the highest-voltage facility involved in the outage event. Used to classify the outage as transmission-level (typically ≥69 kV) or distribution-level, which determines applicable PUC and NERC reporting thresholds.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_outage_puc_outage_report` PRIMARY KEY (`puc_outage_report_id`)
)
USING DELTA
COMMENT 'Formal regulatory outage report filed with the state Public Utility Commission (PUC) for qualifying outage events meeting reportable thresholds (e.g., >50,000 customers, >8 hours, transmission-level events). Captures report type (initial, update, final), filing deadline, actual filing timestamp, reporting utility, affected customer count, outage duration, cause narrative, corrective action plan, and PUC acknowledgment status. Supports NERC EOP-004 and state PUC reporting obligations. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PucOutageReport',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.puc_outage_report'
);

-- DamageAssessment  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `outage`.`damage_assessment` (
  `damage_assessment_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for the field damage assessment record. Primary key for the damage_assessment data product in the outage domain.',
  `compliance_environmental_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.environmental_permit. Business justification: Damage assessments may identify environmental permit violations (oil spills from damaged transformers, hazardous material releases). Environmental compliance officers review damage reports to assess p',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Damage assessment labor and vehicle costs are allocated to cost centers for O&M expense tracking and storm cost accounting. Essential for separating assessment costs from restoration costs in regulato',
  `crew_id` BIGINT COMMENT 'Reference to the field crew that performed this damage assessment. Used for crew accountability, workload tracking, and mutual aid resource estimation.',
  `distribution_substation_id` BIGINT COMMENT 'Reference to the substation serving the damaged location. Used for outage scope analysis, switching order coordination, and reliability reporting at the substation level.',
  `event_id` BIGINT COMMENT 'Reference to the parent outage event that triggered this damage assessment. Links the assessment to the outage lifecycle for restoration planning and OMS integration.',
  `feeder_id` BIGINT COMMENT 'Identifier of the distribution circuit (feeder) on which the damage was assessed. Used for outage scope determination, SAIDI/SAIFI/CAIDI calculations, and restoration sequencing by feeder.',
  `material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: Damage assessments identify specific materials needed for repairs (poles, transformers, wire). Field crews use this to requisition parts from inventory. The materials_required text field should be rep',
  `primary_damage_assessor_employee_id` BIGINT COMMENT 'Employee identifier of the field crew member who performed and submitted the damage assessment. Used for accountability, quality review, and training program analysis. References the workforce management system.',
  `registry_id` BIGINT COMMENT 'Reference to the specific utility infrastructure asset record in the asset management system that was assessed as damaged. Links to Ventyx Asset Suite and Esri ArcGIS Utility Network for asset lifecycle and geospatial tracking.',
  `assessment_number` STRING COMMENT 'Externally-known business identifier for the damage assessment record, formatted as DA-YYYY-NNNNNN. Used in OMS incident tracking, insurance claims, regulatory damage reports, and mutual aid coordination. Pattern: ^DA-[0-9]{4}-[0-9]{6}$.',
  `assessment_status` STRING COMMENT 'Current lifecycle state of the damage assessment record. Drives restoration planning workflow: draft (field entry in progress), submitted (crew submitted for review), verified (supervisor confirmed), approved (cleared for work order creation), closed (repair completed), cancelled (assessment voided). Valid values: draft|submitted|verified|approved|closed|cancelled.',
  `assessment_timestamp` TIMESTAMP COMMENT 'Date and time when the field crew performed the physical damage assessment at the site. Principal real-world event time used for SAIDI/SAIFI/CAIDI reliability index calculations and storm response timeline reporting.',
  `asset_type` STRING COMMENT 'Type of utility infrastructure asset that sustained damage. Used for asset class reporting, material procurement planning, and reliability performance analysis by asset category. Aligns with Esri ArcGIS Utility Network asset classification. Reference-value candidates: conductor|transformer|pole|crossarm|insulator|fuse|switch|cable|substation_equipment|meter|service_drop|other.',
  `cause_code` STRING COMMENT 'Standardized cause code identifying the root cause of the damage (e.g., wind, lightning, vehicle contact, equipment failure, vegetation). Aligns with IEEE 1366 and NERC cause code taxonomy for reliability reporting. References outage.outage_cause for full cause hierarchy.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the damage assessment record was first created in the system. Used for audit trail, data lineage, and SLA compliance tracking.',
  `crew_count_required` INT COMMENT 'Number of crew members estimated to be required to complete the repair. Used for resource planning, mutual aid request sizing, and restoration workforce management during major storm events.',
  `critical_facility_flag` BOOLEAN COMMENT 'Indicates whether the damage location affects a critical facility such as a hospital, emergency services, water treatment plant, or life-support customer. Triggers elevated restoration priority and regulatory notification requirements.',
  `customers_affected_count` INT COMMENT 'Number of customers estimated to be without power due to the damage at this assessed location. Used for restoration prioritization, SAIDI/SAIFI/CAIDI index calculations, and regulatory reporting thresholds.',
  `damage_description` STRING COMMENT 'Free-text narrative description of the damage observed by the field crew. Captures details not covered by structured fields such as extent of damage, contributing factors, and site conditions. Used in insurance claims and regulatory damage reports.',
  `damage_severity` STRING COMMENT 'Severity rating of the assessed damage. Used for restoration prioritization, mutual aid resource estimation, and insurance/regulatory damage reporting. Critical indicates immediate public safety risk or bulk power system impact. Valid values: minor|moderate|major|critical.',
  `damage_type` STRING COMMENT 'Classification of the primary infrastructure damage identified during assessment. Drives material procurement, crew skill requirements, and restoration sequencing. Reference-value candidates: broken_conductor|damaged_transformer|downed_pole|equipment_failure|vegetation_contact|damaged_crossarm|fuse_blown|insulator_damage|underground_cable_fault|substation_damage|meter_damage|service_drop_damage.',
  `doe_reportable_flag` BOOLEAN COMMENT 'Indicates whether the damage event meets DOE OE-417 reporting thresholds (e.g., affecting 50,000+ customers or critical infrastructure). Triggers DOE emergency reporting workflow.',
  `estimated_repair_hours` DECIMAL(6,2) COMMENT 'Field crew estimate of the time in hours required to complete repairs for the assessed damage. Used for estimated time of restoration (ETR) calculation, customer notification, and restoration planning prioritization.',
  `gis_feature_code` STRING COMMENT 'Feature identifier from Esri ArcGIS Utility Network corresponding to the damaged asset or network segment. Enables geospatial analysis, damage heatmap generation, and network topology impact assessment.',
  `insurance_claimable_flag` BOOLEAN COMMENT 'Indicates whether the damage is eligible for an insurance claim (e.g., third-party vehicle contact, natural disaster coverage). Triggers insurance claim initiation workflow and cost recovery tracking.',
  `latitude` DECIMAL(10,7) COMMENT 'GPS latitude coordinate (WGS84 decimal degrees) of the damage location recorded by the field crew. Enables geospatial mapping in GIS, storm damage heatmaps, and precise crew dispatch routing.',
  `life_support_flag` BOOLEAN COMMENT 'Indicates whether the damage location affects one or more customers registered on the life support or medical baseline program. Triggers immediate escalation and priority restoration per state PUC requirements.',
  `location_description` STRING COMMENT 'Free-text description of the damage location including street address, landmark references, or cross-street information. Supplements GPS coordinates for field crew navigation and customer communication.',
  `longitude` DECIMAL(10,7) COMMENT 'GPS longitude coordinate (WGS84 decimal degrees) of the damage location recorded by the field crew. Enables geospatial mapping in GIS, storm damage heatmaps, and precise crew dispatch routing.',
  `nerc_reportable_flag` BOOLEAN COMMENT 'Indicates whether the damage event meets NERC reporting thresholds (e.g., bulk electric system impact, transmission-level damage). Triggers NERC EOP-004 event reporting workflow.',
  `oms_incident_number` STRING COMMENT 'Incident number from the GE PowerOn ADMS Outage Management System associated with this damage assessment. Enables bidirectional traceability between the field assessment record and the OMS outage incident for restoration coordination.',
  `photo_evidence_ref` STRING COMMENT 'Reference path or URL to photographic evidence captured by the field crew during the damage assessment. Stored in the enterprise document management system. Used for insurance claims, regulatory damage reports, and contractor work verification.',
  `pole_number` STRING COMMENT 'Utility pole identifier at or nearest to the damage location. Standard field reference used by field crews, GIS systems, and OMS for precise location identification on the distribution network.',
  `puc_reportable_flag` BOOLEAN COMMENT 'Indicates whether the damage event meets state Public Utility Commission reporting thresholds for major outage or infrastructure damage notification. Triggers state regulatory reporting workflow.',
  `repair_completed_timestamp` TIMESTAMP COMMENT 'Date and time when the repair identified in this damage assessment was completed and the asset was returned to service. Used for actual vs. estimated repair time analysis, SAIDI/CAIDI calculations, and post-storm performance reporting.',
  `repair_type` STRING COMMENT 'Classification of the repair approach required based on the damage assessment. Drives work order type creation in SAP S/4HANA Plant Maintenance and material procurement in Ventyx Asset Suite. Valid values: emergency_repair|temporary_repair|permanent_repair|replacement|no_repair_required.',
  `service_territory_code` STRING COMMENT 'Code identifying the utility service territory or operating district where the damage occurred. Used for regulatory reporting by jurisdiction, mutual aid resource allocation, and storm damage aggregation by territory.',
  `specialized_equipment_flag` BOOLEAN COMMENT 'Indicates whether the repair requires specialized equipment such as a digger derrick, aerial lift, cable puller, or transformer handling equipment. Used for resource dispatch planning and mutual aid equipment requests.',
  `storm_event_flag` BOOLEAN COMMENT 'Indicates whether this damage assessment is associated with a declared storm or major event. Used for Major Event Day (MED) exclusion from SAIDI/SAIFI calculations and storm cost recovery regulatory filings.',
  `third_party_liability_flag` BOOLEAN COMMENT 'Indicates whether the damage was caused by a third party (e.g., vehicle accident, contractor damage, excavation). Triggers third-party liability claim process and cost recovery actions.',
  `to_outage_event` BIGINT COMMENT 'FK to outage.outage_event.outage_event_id — Damage assessments are performed during outage response. Required for restoration planning and insurance/regulatory damage reporting.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date and time when the damage assessment record was last modified. Used for change tracking, audit trail, and data synchronization with OMS and work management systems.',
  `verified_timestamp` TIMESTAMP COMMENT 'Date and time when the damage assessment was verified by a supervisor or field operations manager. Used for quality assurance tracking, SLA compliance, and audit trail of the assessment lifecycle.',
  `voltage_level_kv` DECIMAL(8,3) COMMENT 'Nominal voltage level in kilovolts (kV) of the damaged infrastructure. Determines crew safety requirements, switching order complexity, restoration priority, and NERC/FERC reportability thresholds.',
  `weather_condition` STRING COMMENT 'Weather condition observed at the damage site at the time of assessment. Used for storm damage correlation, MED classification, insurance claims, and predictive analytics for future storm hardening investments. Reference-value candidates: clear|wind|rain|ice|snow|lightning|hurricane|tornado|flood|extreme_heat|other.',
  `work_order_number` STRING COMMENT 'SAP S/4HANA Plant Maintenance work order number created as a result of this damage assessment. Links the assessment to the repair execution workflow for cost tracking, O&M reporting, and CAPEX/OPEX classification.',
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
  CONSTRAINT `pk_outage_damage_assessment` PRIMARY KEY (`damage_assessment_id`)
)
USING DELTA
COMMENT 'Field damage assessment record capturing infrastructure damage identified during outage response or storm patrol. Records assessment timestamp, assessed location (GPS coordinates, circuit, pole number), damage type (broken conductor, damaged transformer, downed pole, equipment failure, vegetation contact), severity rating, estimated repair time, materials required, crew performing assessment, and photographic evidence reference. Feeds restoration planning, material procurement, mutual aid resource estimation, and insurance/regulatory damage reporting. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DamageAssessment',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.damage_assessment',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- StormDerImpact  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `outage`.`storm_der_impact` (
  `storm_der_impact_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for this storm-DER impact assessment record. Primary key for the association.',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to the distributed energy resource system record. Identifies which specific DER installation experienced this storm impact.',
  `employee_id` BIGINT COMMENT 'Reference to the utility staff member or system user who performed or validated this storm impact assessment. Used for accountability and data quality tracking.',
  `storm_event_id` BIGINT COMMENT 'Foreign key linking to the storm event record. Identifies which declared storm or major weather event this DER impact assessment belongs to.',
  `der_availability_during_storm` STRING COMMENT 'Operational availability classification of the DER system during the storm event. Indicates whether the system remained online, went offline, or operated in islanded mode. Used for resilience analysis and DER program evaluation.',
  `grid_support_provided_flag` BOOLEAN COMMENT 'Indicates whether the DER system provided measurable grid support services during the storm event, such as voltage support, frequency regulation, or black start capability. Used for regulatory filings and DER value assessment.',
  `impact_assessment_timestamp` TIMESTAMP COMMENT 'Date and time when this storm-DER impact assessment record was created or last updated by operations staff. Used for audit trail and data quality verification.',
  `islanding_attempts_count` INT COMMENT 'Number of times the DER system attempted to island (disconnect from grid and serve local load independently) during the storm event. Relevant for advanced inverter systems with IEEE 1547-2018 capabilities. Used to assess microgrid and resilience functionality.',
  `performance_rating` STRING COMMENT 'Qualitative assessment of the DER system\'s overall performance during the storm event based on availability, grid support contribution, and reconnection behavior. Used for after-action reports and DER program evaluation.',
  `reconnection_delay_hours` DECIMAL(10,2) COMMENT 'Number of hours between grid restoration at the DER installation location and successful DER system reconnection to the grid. Measures compliance with IEEE 1547 reconnection requirements and identifies potential protection system issues.',
  `regulatory_reporting_flag` BOOLEAN COMMENT 'Indicates whether this specific DER impact record is included in regulatory filings such as DOE OE-417 reports or state commission after-action reports. Used to filter records for compliance reporting.',
  `storm_damage_to_der_flag` BOOLEAN COMMENT 'Indicates whether the DER system sustained physical damage from the storm event requiring repair or replacement. Used for insurance claims, damage assessment reporting, and equipment reliability analysis.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_outage_storm_der_impact` PRIMARY KEY (`storm_der_impact_id`)
)
USING DELTA
COMMENT 'This association product represents the operational impact assessment between a storm event and a distributed energy resource system. It captures DER performance, availability, and grid interaction behavior during major weather events for regulatory reporting, after-action analysis, and DER program evaluation. Each record links one storm event to one DER system with metrics that exist only in the context of that specific storm\'s impact on that specific DER asset.. Existence Justification: In energy utility operations, storm events impact multiple DER systems across the affected service territory (one storm affects hundreds or thousands of DER installations), and each DER system experiences multiple storm events over its operational lifetime (10-25 years). Utilities actively manage and track DER performance during Major Event Days for regulatory compliance (DOE OE-417 filings, IEEE 1366 MED reporting), after-action analysis, mutual aid coordination, and DER program evaluation. This is an operational assessment process, not an analytical correlation. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'StormDerImpact',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.storm_der_impact'
);

-- EmergencyResponsePlan  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `outage`.`emergency_response_plan` (
  `emergency_response_plan_id` BIGINT NOT NULL COMMENT 'Primary key for emergency_response_plan',
  `notification_template_id` BIGINT COMMENT 'Reference to the template used for automated alerts.',
  `superseded_emergency_response_plan_id` BIGINT COMMENT 'Self-referencing FK on emergency_response_plan (superseded_emergency_response_plan_id)',
  `activation_criteria` STRING COMMENT 'Conditions that trigger the activation of the plan.',
  `actual_response_time_minutes` INT COMMENT 'Measured time taken to start response during the last activation.',
  `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the plan received formal approval.',
  `approved_by` STRING COMMENT 'Name or identifier of the person who approved the plan.',
  `budget_amount` DECIMAL(15,2) COMMENT 'Allocated budget for plan execution and drills.',
  `communication_channels` STRING COMMENT 'Preferred channels for stakeholder notifications.',
  `compliance_notes` STRING COMMENT 'Additional notes on compliance gaps or exemptions.',
  `contact_email` STRING COMMENT 'Email address of the primary contact.',
  `contact_name` STRING COMMENT 'Primary contact person for the plan.',
  `contact_phone` STRING COMMENT 'Phone number of the primary contact.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the plan record was first created in the system.',
  `currency_code` STRING COMMENT 'Three-letter ISO currency code for the budget.',
  `deactivation_criteria` STRING COMMENT 'Conditions that signal the plan can be retired or paused.',
  `drill_frequency_days` INT COMMENT 'Number of days between scheduled emergency drills.',
  `drill_results_summary` STRING COMMENT 'High-level findings and lessons learned from the last drill.',
  `effective_end_date` DATE COMMENT 'Date when the plan expires or is superseded; null if open-ended.',
  `effective_start_date` DATE COMMENT 'Date when the plan becomes effective.',
  `escalation_procedure` STRING COMMENT 'Defined steps for escalating incidents beyond initial responders.',
  `estimated_response_time_minutes` INT COMMENT 'Target time to initiate response after an event is detected.',
  `funding_source` STRING COMMENT 'Origin of funds (e.g., capital budget, operational budget).',
  `is_test_plan` BOOLEAN COMMENT 'True if the plan is used for testing or training purposes only.',
  `last_drill_date` DATE COMMENT 'Date of the most recent emergency drill.',
  `mitigation_measures` STRING COMMENT 'Key actions defined to reduce impact during an emergency.',
  `next_review_date` DATE COMMENT 'Scheduled date for the next formal review of the plan.',
  `plan_code` STRING COMMENT 'Business-visible code used to reference the plan in operations and reporting.',
  `plan_name` STRING COMMENT 'Descriptive name of the emergency response plan.',
  `plan_type` STRING COMMENT 'Category of emergency the plan addresses.',
  `priority_level` STRING COMMENT 'Business priority assigned to the plan for resource allocation.',
  `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether the plan meets all applicable regulatory requirements.',
  `resource_requirements` STRING COMMENT 'Summary of personnel, equipment, and material needed to execute the plan.',
  `responsible_department` STRING COMMENT 'Organizational department accountable for maintaining the plan.',
  `review_cycle_months` INT COMMENT 'Number of months between mandatory plan reviews.',
  `revision_number` INT COMMENT 'Sequential number indicating the revision of the plan.',
  `risk_level` STRING COMMENT 'Overall risk rating associated with the plan\'s scope.',
  `status` STRING COMMENT 'Current lifecycle status of the plan.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the plan record.',
  `version` STRING COMMENT 'Human-readable version label (e.g., v1.2).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_outage_emergency_response_plan` PRIMARY KEY (`emergency_response_plan_id`)
)
USING DELTA
COMMENT 'Master reference table for emergency_response_plan. Referenced by emergency_response_plan_id. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'EmergencyResponsePlan',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.emergency_response_plan'
);

-- MessageTemplate  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `outage`.`message_template` (
  `message_template_id` BIGINT NOT NULL COMMENT 'Primary key for message_template',
  `base_message_template_id` BIGINT COMMENT 'Self-referencing FK on message_template (base_message_template_id)',
  `audience` STRING COMMENT 'Customer segment for which the template is intended.',
  `body` STRING COMMENT 'Full text or HTML content of the communication.',
  `channel` STRING COMMENT 'Medium through which the message is sent to customers.',
  `compliance_required` BOOLEAN COMMENT 'True if the template must meet specific regulatory disclosure requirements.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the template record was first created in the system.',
  `effective_from` DATE COMMENT 'Date from which the template may be used in outbound communications.',
  `effective_until` DATE COMMENT 'Date after which the template should no longer be used (null if indefinite).',
  `is_active` BOOLEAN COMMENT 'Indicates whether the template is currently usable in production.',
  `language` STRING COMMENT 'ISO language code of the template content.',
  `name` STRING COMMENT 'Human-readable name of the template used to identify it in catalogs and UI.',
  `placeholder_variables` STRING COMMENT 'Comma-separated list of variable names (e.g., {customer_name},{outage_start}) that the template expects.',
  `priority` INT COMMENT 'Numeric priority (1 = highest) used for routing and escalation.',
  `subject` STRING COMMENT 'Subject line or headline displayed to the recipient.',
  `template_type` STRING COMMENT 'Category of communication the template supports, e.g., outage notification or maintenance notice.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the template record.',
  `version_number` INT COMMENT 'Sequential version of the template for change management.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_outage_message_template` PRIMARY KEY (`message_template_id`)
)
USING DELTA
COMMENT 'Master reference table for message_template. Referenced by message_template_id. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MessageTemplate',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.outage.message_template'
);

-- ========= FOREIGN KEYS within outage (49) =========
ALTER TABLE `outage`.`event` DROP CONSTRAINT IF EXISTS `fk_outage_event_emergency_response_plan_id`;
ALTER TABLE `outage`.`event` ADD CONSTRAINT `fk_outage_event_emergency_response_plan_id` FOREIGN KEY (`emergency_response_plan_id`) REFERENCES `outage`.`emergency_response_plan` (`emergency_response_plan_id`);

ALTER TABLE `outage`.`event` DROP CONSTRAINT IF EXISTS `fk_outage_event_reliability_index_period_id`;
ALTER TABLE `outage`.`event` ADD CONSTRAINT `fk_outage_event_reliability_index_period_id` FOREIGN KEY (`reliability_index_period_id`) REFERENCES `outage`.`reliability_index_period` (`reliability_index_period_id`);

ALTER TABLE `outage`.`event` DROP CONSTRAINT IF EXISTS `fk_outage_event_storm_event_id`;
ALTER TABLE `outage`.`event` ADD CONSTRAINT `fk_outage_event_storm_event_id` FOREIGN KEY (`storm_event_id`) REFERENCES `outage`.`storm_event` (`storm_event_id`);

ALTER TABLE `outage`.`interruption` DROP CONSTRAINT IF EXISTS `fk_outage_interruption_event_id`;
ALTER TABLE `outage`.`interruption` ADD CONSTRAINT `fk_outage_interruption_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `outage`.`interruption` DROP CONSTRAINT IF EXISTS `fk_outage_interruption_interruption_planned_outage_window_id`;
ALTER TABLE `outage`.`interruption` ADD CONSTRAINT `fk_outage_interruption_interruption_planned_outage_window_id` FOREIGN KEY (`interruption_planned_outage_window_id`) REFERENCES `outage`.`planned_outage_window` (`planned_outage_window_id`);

ALTER TABLE `outage`.`interruption` DROP CONSTRAINT IF EXISTS `fk_outage_interruption_outage_crew_dispatch_id`;
ALTER TABLE `outage`.`interruption` ADD CONSTRAINT `fk_outage_interruption_outage_crew_dispatch_id` FOREIGN KEY (`outage_crew_dispatch_id`) REFERENCES `outage`.`outage_crew_dispatch` (`outage_crew_dispatch_id`);

ALTER TABLE `outage`.`interruption` DROP CONSTRAINT IF EXISTS `fk_outage_interruption_outage_switching_order_id`;
ALTER TABLE `outage`.`interruption` ADD CONSTRAINT `fk_outage_interruption_outage_switching_order_id` FOREIGN KEY (`outage_switching_order_id`) REFERENCES `outage`.`outage_switching_order` (`outage_switching_order_id`);

ALTER TABLE `outage`.`interruption` DROP CONSTRAINT IF EXISTS `fk_outage_interruption_to_planned_outage_window_id`;
ALTER TABLE `outage`.`interruption` ADD CONSTRAINT `fk_outage_interruption_to_planned_outage_window_id` FOREIGN KEY (`to_planned_outage_window_id`) REFERENCES `outage`.`planned_outage_window` (`planned_outage_window_id`);

ALTER TABLE `outage`.`outage_switching_order` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_order_event_id`;
ALTER TABLE `outage`.`outage_switching_order` ADD CONSTRAINT `fk_outage_outage_switching_order_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `outage`.`outage_switching_step` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_step_event_id`;
ALTER TABLE `outage`.`outage_switching_step` ADD CONSTRAINT `fk_outage_outage_switching_step_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `outage`.`outage_switching_step` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_step_outage_switching_order_id`;
ALTER TABLE `outage`.`outage_switching_step` ADD CONSTRAINT `fk_outage_outage_switching_step_outage_switching_order_id` FOREIGN KEY (`outage_switching_order_id`) REFERENCES `outage`.`outage_switching_order` (`outage_switching_order_id`);

ALTER TABLE `outage`.`outage_crew_dispatch` DROP CONSTRAINT IF EXISTS `fk_outage_outage_crew_dispatch_event_id`;
ALTER TABLE `outage`.`outage_crew_dispatch` ADD CONSTRAINT `fk_outage_outage_crew_dispatch_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `outage`.`outage_crew_dispatch` DROP CONSTRAINT IF EXISTS `fk_outage_outage_crew_dispatch_restoration_action_id`;
ALTER TABLE `outage`.`outage_crew_dispatch` ADD CONSTRAINT `fk_outage_outage_crew_dispatch_restoration_action_id` FOREIGN KEY (`restoration_action_id`) REFERENCES `outage`.`restoration_action` (`restoration_action_id`);

ALTER TABLE `outage`.`restoration_action` DROP CONSTRAINT IF EXISTS `fk_outage_restoration_action_event_id`;
ALTER TABLE `outage`.`restoration_action` ADD CONSTRAINT `fk_outage_restoration_action_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `outage`.`restoration_action` DROP CONSTRAINT IF EXISTS `fk_outage_restoration_action_outage_switching_order_id`;
ALTER TABLE `outage`.`restoration_action` ADD CONSTRAINT `fk_outage_restoration_action_outage_switching_order_id` FOREIGN KEY (`outage_switching_order_id`) REFERENCES `outage`.`outage_switching_order` (`outage_switching_order_id`);

ALTER TABLE `outage`.`planned_outage_window` DROP CONSTRAINT IF EXISTS `fk_outage_planned_outage_window_oms_event_id`;
ALTER TABLE `outage`.`planned_outage_window` ADD CONSTRAINT `fk_outage_planned_outage_window_oms_event_id` FOREIGN KEY (`oms_event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `outage`.`affected_customer` DROP CONSTRAINT IF EXISTS `fk_outage_affected_customer_event_id`;
ALTER TABLE `outage`.`affected_customer` ADD CONSTRAINT `fk_outage_affected_customer_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `outage`.`affected_customer` DROP CONSTRAINT IF EXISTS `fk_outage_affected_customer_outage_crew_dispatch_id`;
ALTER TABLE `outage`.`affected_customer` ADD CONSTRAINT `fk_outage_affected_customer_outage_crew_dispatch_id` FOREIGN KEY (`outage_crew_dispatch_id`) REFERENCES `outage`.`outage_crew_dispatch` (`outage_crew_dispatch_id`);

ALTER TABLE `outage`.`affected_customer` DROP CONSTRAINT IF EXISTS `fk_outage_affected_customer_outage_switching_order_id`;
ALTER TABLE `outage`.`affected_customer` ADD CONSTRAINT `fk_outage_affected_customer_outage_switching_order_id` FOREIGN KEY (`outage_switching_order_id`) REFERENCES `outage`.`outage_switching_order` (`outage_switching_order_id`);

ALTER TABLE `outage`.`affected_customer` DROP CONSTRAINT IF EXISTS `fk_outage_affected_customer_trouble_call_id`;
ALTER TABLE `outage`.`affected_customer` ADD CONSTRAINT `fk_outage_affected_customer_trouble_call_id` FOREIGN KEY (`trouble_call_id`) REFERENCES `outage`.`call` (`call_id`);

ALTER TABLE `outage`.`customer_notification` DROP CONSTRAINT IF EXISTS `fk_outage_customer_notification_etr_revision_id`;
ALTER TABLE `outage`.`customer_notification` ADD CONSTRAINT `fk_outage_customer_notification_etr_revision_id` FOREIGN KEY (`etr_revision_id`) REFERENCES `outage`.`etr_revision` (`etr_revision_id`);

ALTER TABLE `outage`.`customer_notification` DROP CONSTRAINT IF EXISTS `fk_outage_customer_notification_event_id`;
ALTER TABLE `outage`.`customer_notification` ADD CONSTRAINT `fk_outage_customer_notification_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `outage`.`customer_notification` DROP CONSTRAINT IF EXISTS `fk_outage_customer_notification_message_template_id`;
ALTER TABLE `outage`.`customer_notification` ADD CONSTRAINT `fk_outage_customer_notification_message_template_id` FOREIGN KEY (`message_template_id`) REFERENCES `outage`.`message_template` (`message_template_id`);

ALTER TABLE `outage`.`event_status_history` DROP CONSTRAINT IF EXISTS `fk_outage_event_status_history_event_id`;
ALTER TABLE `outage`.`event_status_history` ADD CONSTRAINT `fk_outage_event_status_history_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `outage`.`event_status_history` DROP CONSTRAINT IF EXISTS `fk_outage_event_status_history_outage_switching_order_id`;
ALTER TABLE `outage`.`event_status_history` ADD CONSTRAINT `fk_outage_event_status_history_outage_switching_order_id` FOREIGN KEY (`outage_switching_order_id`) REFERENCES `outage`.`outage_switching_order` (`outage_switching_order_id`);

ALTER TABLE `outage`.`mutual_aid_request` DROP CONSTRAINT IF EXISTS `fk_outage_mutual_aid_request_event_id`;
ALTER TABLE `outage`.`mutual_aid_request` ADD CONSTRAINT `fk_outage_mutual_aid_request_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `outage`.`mutual_aid_request` DROP CONSTRAINT IF EXISTS `fk_outage_mutual_aid_request_mutual_storm_event_id`;
ALTER TABLE `outage`.`mutual_aid_request` ADD CONSTRAINT `fk_outage_mutual_aid_request_mutual_storm_event_id` FOREIGN KEY (`mutual_storm_event_id`) REFERENCES `outage`.`storm_event` (`storm_event_id`);

ALTER TABLE `outage`.`mutual_aid_request` DROP CONSTRAINT IF EXISTS `fk_outage_mutual_aid_request_primary_storm_event_id`;
ALTER TABLE `outage`.`mutual_aid_request` ADD CONSTRAINT `fk_outage_mutual_aid_request_primary_storm_event_id` FOREIGN KEY (`primary_storm_event_id`) REFERENCES `outage`.`storm_event` (`storm_event_id`);

ALTER TABLE `outage`.`prediction` DROP CONSTRAINT IF EXISTS `fk_outage_prediction_oms_event_id`;
ALTER TABLE `outage`.`prediction` ADD CONSTRAINT `fk_outage_prediction_oms_event_id` FOREIGN KEY (`oms_event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `outage`.`prediction` DROP CONSTRAINT IF EXISTS `fk_outage_prediction_storm_event_id`;
ALTER TABLE `outage`.`prediction` ADD CONSTRAINT `fk_outage_prediction_storm_event_id` FOREIGN KEY (`storm_event_id`) REFERENCES `outage`.`storm_event` (`storm_event_id`);

ALTER TABLE `outage`.`etr_revision` DROP CONSTRAINT IF EXISTS `fk_outage_etr_revision_event_id`;
ALTER TABLE `outage`.`etr_revision` ADD CONSTRAINT `fk_outage_etr_revision_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `outage`.`etr_revision` DROP CONSTRAINT IF EXISTS `fk_outage_etr_revision_outage_switching_order_id`;
ALTER TABLE `outage`.`etr_revision` ADD CONSTRAINT `fk_outage_etr_revision_outage_switching_order_id` FOREIGN KEY (`outage_switching_order_id`) REFERENCES `outage`.`outage_switching_order` (`outage_switching_order_id`);

ALTER TABLE `outage`.`call` DROP CONSTRAINT IF EXISTS `fk_outage_call_duplicate_of_call_id`;
ALTER TABLE `outage`.`call` ADD CONSTRAINT `fk_outage_call_duplicate_of_call_id` FOREIGN KEY (`duplicate_of_call_id`) REFERENCES `outage`.`call` (`call_id`);

ALTER TABLE `outage`.`call` DROP CONSTRAINT IF EXISTS `fk_outage_call_event_id`;
ALTER TABLE `outage`.`call` ADD CONSTRAINT `fk_outage_call_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `outage`.`call` DROP CONSTRAINT IF EXISTS `fk_outage_call_storm_event_id`;
ALTER TABLE `outage`.`call` ADD CONSTRAINT `fk_outage_call_storm_event_id` FOREIGN KEY (`storm_event_id`) REFERENCES `outage`.`storm_event` (`storm_event_id`);

ALTER TABLE `outage`.`segment_impact` DROP CONSTRAINT IF EXISTS `fk_outage_segment_impact_cause_id`;
ALTER TABLE `outage`.`segment_impact` ADD CONSTRAINT `fk_outage_segment_impact_cause_id` FOREIGN KEY (`cause_id`) REFERENCES `outage`.`cause` (`cause_id`);

ALTER TABLE `outage`.`segment_impact` DROP CONSTRAINT IF EXISTS `fk_outage_segment_impact_event_id`;
ALTER TABLE `outage`.`segment_impact` ADD CONSTRAINT `fk_outage_segment_impact_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `outage`.`segment_impact` DROP CONSTRAINT IF EXISTS `fk_outage_segment_impact_outage_crew_dispatch_id`;
ALTER TABLE `outage`.`segment_impact` ADD CONSTRAINT `fk_outage_segment_impact_outage_crew_dispatch_id` FOREIGN KEY (`outage_crew_dispatch_id`) REFERENCES `outage`.`outage_crew_dispatch` (`outage_crew_dispatch_id`);

ALTER TABLE `outage`.`segment_impact` DROP CONSTRAINT IF EXISTS `fk_outage_segment_impact_storm_event_id`;
ALTER TABLE `outage`.`segment_impact` ADD CONSTRAINT `fk_outage_segment_impact_storm_event_id` FOREIGN KEY (`storm_event_id`) REFERENCES `outage`.`storm_event` (`storm_event_id`);

ALTER TABLE `outage`.`outage_flisr_event` DROP CONSTRAINT IF EXISTS `fk_outage_outage_flisr_event_cause_id`;
ALTER TABLE `outage`.`outage_flisr_event` ADD CONSTRAINT `fk_outage_outage_flisr_event_cause_id` FOREIGN KEY (`cause_id`) REFERENCES `outage`.`cause` (`cause_id`);

ALTER TABLE `outage`.`outage_flisr_event` DROP CONSTRAINT IF EXISTS `fk_outage_outage_flisr_event_event_id`;
ALTER TABLE `outage`.`outage_flisr_event` ADD CONSTRAINT `fk_outage_outage_flisr_event_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `outage`.`safety_clearance` DROP CONSTRAINT IF EXISTS `fk_outage_safety_clearance_event_id`;
ALTER TABLE `outage`.`safety_clearance` ADD CONSTRAINT `fk_outage_safety_clearance_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `outage`.`puc_outage_report` DROP CONSTRAINT IF EXISTS `fk_outage_puc_outage_report_event_id`;
ALTER TABLE `outage`.`puc_outage_report` ADD CONSTRAINT `fk_outage_puc_outage_report_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `outage`.`puc_outage_report` DROP CONSTRAINT IF EXISTS `fk_outage_puc_outage_report_superseded_by_report_puc_outage_report_id`;
ALTER TABLE `outage`.`puc_outage_report` ADD CONSTRAINT `fk_outage_puc_outage_report_superseded_by_report_puc_outage_report_id` FOREIGN KEY (`superseded_by_report_puc_outage_report_id`) REFERENCES `outage`.`puc_outage_report` (`puc_outage_report_id`);

ALTER TABLE `outage`.`damage_assessment` DROP CONSTRAINT IF EXISTS `fk_outage_damage_assessment_event_id`;
ALTER TABLE `outage`.`damage_assessment` ADD CONSTRAINT `fk_outage_damage_assessment_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `outage`.`storm_der_impact` DROP CONSTRAINT IF EXISTS `fk_outage_storm_der_impact_storm_event_id`;
ALTER TABLE `outage`.`storm_der_impact` ADD CONSTRAINT `fk_outage_storm_der_impact_storm_event_id` FOREIGN KEY (`storm_event_id`) REFERENCES `outage`.`storm_event` (`storm_event_id`);

ALTER TABLE `outage`.`emergency_response_plan` DROP CONSTRAINT IF EXISTS `fk_outage_emergency_response_plan_notification_template_id`;
ALTER TABLE `outage`.`emergency_response_plan` ADD CONSTRAINT `fk_outage_emergency_response_plan_notification_template_id` FOREIGN KEY (`notification_template_id`) REFERENCES `outage`.`message_template` (`message_template_id`);

ALTER TABLE `outage`.`emergency_response_plan` DROP CONSTRAINT IF EXISTS `fk_outage_emergency_response_plan_superseded_emergency_response_plan_id`;
ALTER TABLE `outage`.`emergency_response_plan` ADD CONSTRAINT `fk_outage_emergency_response_plan_superseded_emergency_response_plan_id` FOREIGN KEY (`superseded_emergency_response_plan_id`) REFERENCES `outage`.`emergency_response_plan` (`emergency_response_plan_id`);

ALTER TABLE `outage`.`message_template` DROP CONSTRAINT IF EXISTS `fk_outage_message_template_base_message_template_id`;
ALTER TABLE `outage`.`message_template` ADD CONSTRAINT `fk_outage_message_template_base_message_template_id` FOREIGN KEY (`base_message_template_id`) REFERENCES `outage`.`message_template` (`message_template_id`);

