-- Utility CMM-aligned Canonical Data Model (Silver) v1.0.0 | source: Databricks lakehouse-industry-data-models energy_utilities v1 ECM | generated 2026-10-13
-- 05 | Subject area: demand | 17 tables | CIM packages: IEC61968::Metering (DemandResponseProgram, EndDeviceControl); IEC61968-5 DER
-- Standards: IEC 61968-9; IEC 61968-5; OpenADR 2.0b; IEEE 2030.5; FERC Order 2222; NAESB WEQ-015
-- Contents: tables (with PK + NOT NULL), then intra-subject-area foreign keys.
-- Unity Catalog PK/FK constraints are informational (NOT ENFORCED); NOT NULL is enforced.

USE CATALOG `utility_cmm_silver`;

-- DrProgram  <<CIM DemandResponseProgram : exact>>
CREATE TABLE IF NOT EXISTS `demand`.`dr_program` (
  `dr_program_id` BIGINT NOT NULL COMMENT 'Unique identifier for the demand response program. Primary key.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: DR programs are designed within control area operational boundaries to meet reserve requirements and reliability standards. Needed for capacity planning, NERC reserve margin calculations, and coordina',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: DR programs are managed as cost centers for budget tracking and expense allocation. Program_budget_annual and operational costs require cost center assignment for financial reporting and regulatory co',
  `equipment_vendor_id` BIGINT COMMENT 'Foreign key linking to supply.vendor. Business justification: DR programs contract with vendors for equipment/services (smart thermostats, load control devices). Business process: vendor performance tracking, procurement management, warranty administration for p',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: DR programs are designed for specific geographic zones with zone-specific load characteristics, peak demand patterns, and capacity requirements. Essential for program design, enrollment targeting, and',
  `interconnection_application_id` BIGINT COMMENT 'Foreign key linking to interconnection.application. Business justification: DR programs require DER interconnection approval before enrollment eligibility. ISO/RTO capacity market registration tracking needs interconnection status verification. Program managers validate inter',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: DR programs must comply with specific regulatory obligations (NERC reliability standards, FERC Order 2222, state PUC DR requirements). Essential for compliance tracking, audit evidence, and regulatory',
  `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: DR programs generate revenue through capacity payments and incentive structures that must be allocated to profit centers for P&L reporting, FERC Form 1 functional classification, and rate case cost-be',
  `program_manager_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: DR programs are managed by specific utility employees who design incentive structures, manage budgets, coordinate with ISO/RTOs, and ensure regulatory compliance. Program_manager_name denormalizes emp',
  `service_territory_id` BIGINT COMMENT 'Foreign key linking to distribution.service_territory. Business justification: DR programs are designed, approved, and operated within specific service territories due to regulatory jurisdiction, franchise boundaries, tariff structures, and eligibility rules. Essential for progr',
  `transmission_planning_study_id` BIGINT COMMENT 'Foreign key linking to transmission.planning_study. Business justification: Transmission planning studies evaluate DR programs as non-wires alternatives to transmission upgrades. FERC Order 1000 and state IRP processes require utilities to assess DR capacity in transmission p',
  `ami_required_flag` BOOLEAN COMMENT 'Indicates whether customer must have Advanced Metering Infrastructure (smart meter) installed to participate in this demand response program. True for programs requiring interval data; False for programs using deemed savings or aggregated measurements.',
  `baseline_adjustment_cap_percent` DECIMAL(5,2) COMMENT 'Maximum percentage adjustment allowed to baseline calculation to account for day-of variations. Prevents gaming and ensures baseline accuracy.',
  `baseline_calculation_method` STRING COMMENT 'Specific algorithm used to calculate customer baseline load for measurement and verification. High 10 of Last 10 averages the highest 10 days from the last 10 similar days; Average 5 of 10 averages middle 5 of last 10 days; Day Matching uses same day-of-week; Regression uses statistical model; Weather Normalized adjusts for temperature. Valid values: high_10_of_last_10|average_5_of_10|day_matching|regression|weather_normalized.',
  `behavioral_dr_delivery_channel` STRING COMMENT 'Primary communication channel used to deliver behavioral demand response messages and engagement content to customers. Applicable only to behavioral DR program types. Reference-value candidates: email|sms|mobile_app|web_portal|home_energy_report|in_home_display|none.',
  `behavioral_dr_engagement_scoring_parameters` STRING COMMENT 'Parameters and weights used to calculate customer engagement scores in behavioral demand response programs, including message open rates, web portal logins, mobile app usage, survey responses, and behavioral action completion.',
  `behavioral_dr_gamification_rules` STRING COMMENT 'Description of gamification elements used in behavioral demand response campaigns, including points systems, leaderboards, badges, challenges, and rewards structures designed to drive sustained engagement and load reduction.',
  `behavioral_dr_peer_comparison_methodology` STRING COMMENT 'Methodology used to compare customer energy usage to peers in behavioral demand response campaigns. Neighbor Comparison uses geographic proximity; Similar Home Comparison uses home characteristics; Percentile Ranking shows position in distribution. None if peer comparison not used. Valid values: neighbor_comparison|similar_home_comparison|percentile_ranking|none.',
  `cost_effectiveness_ratio` DECIMAL(8,4) COMMENT 'Calculated benefit-cost ratio for this demand response program using the specified cost-effectiveness test method. Values greater than 1.0 indicate program is cost-effective. Updated annually based on actual performance.',
  `cost_effectiveness_test_method` STRING COMMENT 'Regulatory cost-effectiveness test used to evaluate this demand response program. Total Resource Cost (TRC) test includes all costs and benefits; Program Administrator Cost (PAC) test uses utility perspective; Ratepayer Impact Measure (RIM) test evaluates rate impacts; Participant Cost Test (PCT) evaluates customer economics; Societal Cost Test (SCT) includes externalities. Valid values: trc|pac|rim|pct|sct.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this demand response program record was first created in the system.',
  `effective_end_date` DATE COMMENT 'Date when the demand response program is scheduled to terminate. Null for open-ended programs.',
  `effective_start_date` DATE COMMENT 'Date when the demand response program becomes active and eligible for customer enrollment and event dispatch.',
  `eligible_customer_segment` STRING COMMENT 'Customer segment(s) eligible to enroll in this demand response program. Segmentation based on rate class and usage characteristics. Valid values: residential|commercial|industrial|agricultural|all_segments.',
  `enrolled_capacity_actual_mw` DECIMAL(12,3) COMMENT 'Current actual aggregate enrolled load reduction capacity in megawatts across all active customer enrollments in this program.',
  `enrolled_capacity_target_mw` DECIMAL(12,3) COMMENT 'Target aggregate load reduction capacity in megawatts that the utility aims to enroll in this demand response program. Used for resource adequacy planning and regulatory performance reporting.',
  `event_notification_lead_time_hours` DECIMAL(5,2) COMMENT 'Minimum number of hours advance notice provided to customers before a demand response event is dispatched. Regulatory requirement varies by program type and jurisdiction.',
  `incentive_amount` DECIMAL(15,2) COMMENT 'Base incentive amount paid to customers. Units depend on incentive_structure_type: dollars per year for fixed payment, dollars per kWh for per-kWh curtailed, dollars per kW-month for capacity payment.',
  `incentive_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for incentive payments. USD for United States utilities. Valid values: USD.',
  `incentive_structure_type` STRING COMMENT 'Classification of how customer incentives are calculated and paid. Fixed Payment provides flat annual amount; Per kWh Curtailed pays based on measured load reduction; Capacity Payment compensates for availability; Energy Payment compensates for actual curtailment; Bill Credit reduces customer bill; Tiered Incentive varies payment by performance level. Valid values: fixed_payment|per_kwh_curtailed|capacity_payment|energy_payment|bill_credit|tiered_incentive.',
  `iso_rto_name` STRING COMMENT 'Name of the ISO or RTO where this demand response program is registered for wholesale market participation. None indicates retail-only program. Reference-value candidates: CAISO|ERCOT|MISO|PJM|NYISO|ISO_NE|SPP|none.',
  `iso_rto_registration_number` STRING COMMENT 'Registration identifier assigned by the ISO or RTO for wholesale market participation. Required for programs that bid demand response capacity into day-ahead or real-time markets.',
  `max_event_duration_hours` DECIMAL(5,2) COMMENT 'Maximum allowable duration in hours for a single demand response event under this program. Protects customers from excessive curtailment.',
  `max_event_hours_per_year` DECIMAL(8,2) COMMENT 'Maximum cumulative hours of demand response events that can be dispatched in a calendar year. Protects customers from excessive annual curtailment burden.',
  `max_events_per_year` INT COMMENT 'Maximum number of demand response events that can be called in a calendar year under this program. Regulatory limit to ensure customer participation remains voluntary and reasonable.',
  `measurement_verification_methodology` STRING COMMENT 'Methodology used to calculate baseline load and measure actual load reduction during demand response events. Customer Baseline uses historical usage patterns; Meter Before-After compares pre-event and event-period readings; Control Group compares participants to non-participants; Regression Analysis uses statistical models; Deemed Savings applies fixed reduction values. Valid values: customer_baseline|meter_before_after|control_group|regression_analysis|deemed_savings.',
  `minimum_load_requirement_kw` DECIMAL(12,3) COMMENT 'Minimum peak demand in kilowatts that a customer must have to be eligible for enrollment in this demand response program. Null if no minimum applies.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this demand response program record was last modified in the system.',
  `opt_out_allowed_flag` BOOLEAN COMMENT 'Indicates whether customers are allowed to opt out of individual demand response events without penalty. True for voluntary programs; False for firm interruptible tariffs.',
  `opt_out_penalty_amount` DECIMAL(15,2) COMMENT 'Financial penalty assessed to customers who opt out of a demand response event when opt-out is allowed but discouraged. Null if no penalty applies.',
  `performance_reporting_frequency` STRING COMMENT 'Frequency at which program performance metrics must be reported to ISO/RTO and PUC. Event-based reporting required for wholesale market programs; periodic reporting for retail programs. Valid values: monthly|quarterly|annual|event_based.',
  `performance_reporting_obligation` STRING COMMENT 'Description of specific performance metrics and reporting obligations required by regulators and market operators, including enrolled capacity, event performance, customer participation rates, and measurement and verification results.',
  `program_budget_annual` DECIMAL(15,2) COMMENT 'Total annual budget allocated for this demand response program, including incentive payments, marketing, administration, measurement and verification, and technology costs.',
  `program_code` STRING COMMENT 'Externally-known unique business identifier for the DR program used in regulatory filings, ISO/RTO registration, and customer communications. Pattern: ^[A-Z0-9_-]{3,20}$.',
  `program_name` STRING COMMENT 'Human-readable name of the demand response program as marketed to customers and reported to regulators.',
  `program_status` STRING COMMENT 'Current lifecycle status of the demand response program. Draft indicates program design phase; Pending Approval awaits PUC/FERC authorization; Active means program is enrolling customers and dispatching events; Suspended indicates temporary halt; Closed means no new enrollments but existing customers remain; Retired indicates program termination. Valid values: draft|pending_approval|active|suspended|closed|retired.',
  `program_type` STRING COMMENT 'Classification of the demand response program type. Direct Load Control (DLC) allows utility to remotely control customer devices; Interruptible Tariff provides bill credits for load curtailment; Critical Peak Pricing (CPP) charges higher rates during peak events; Time of Use (TOU) varies rates by time period; Behavioral DR uses engagement and gamification; Virtual Power Plant (VPP) aggregates distributed resources; Wholesale Market DR participates in ISO/RTO markets; Emergency DR responds to grid emergencies. Reference-value candidates: direct_load_control|interruptible_tariff|cpp|tou|behavioral_dr|vpp_aggregation|wholesale_market_dr|emergency_dr.',
  `regulatory_approval_date` DATE COMMENT 'Date when the PUC or FERC issued final approval for this demand response program to commence operations.',
  `regulatory_authorization_type` STRING COMMENT 'Type of regulatory authorization under which this demand response program operates. PUC Tariff for state-approved retail programs; FERC Tariff for wholesale programs; Pilot Program for experimental initiatives; Emergency Authorization for grid reliability programs; Market Rule for ISO/RTO market products. Valid values: puc_tariff|ferc_tariff|pilot_program|emergency_authorization|market_rule.',
  `regulatory_docket_number` STRING COMMENT 'PUC or FERC docket number under which this demand response program was approved. Used for regulatory compliance tracking and audit trail.',
  `vpp_aggregation_model` STRING COMMENT 'Business model for aggregating distributed energy resources into a virtual power plant. Utility-Owned means utility directly controls customer devices; Third-Party Aggregator uses external aggregator; Hybrid combines both models. None if not a VPP program. Valid values: utility_owned|third_party_aggregator|hybrid|none.',
  `vpp_dispatch_protocol` STRING COMMENT 'Communication protocol used to dispatch demand response signals to distributed energy resources in virtual power plant programs. OpenADR is open standard; IEEE 2030.5 is smart grid standard; Proprietary uses vendor-specific protocol. None if not applicable. Valid values: openadr|ieee_2030_5|proprietary|none.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_demand_dr_program` PRIMARY KEY (`dr_program_id`)
)
USING DELTA
COMMENT 'Master record for each Demand Response program offered by the utility, including direct load control, interruptible tariff, CPP, TOU, behavioral DR (with delivery channel, peer comparison methodology, gamification rules, and engagement scoring parameters), VPP aggregation, and wholesale market DR products. Captures program type, ISO/RTO registration, enrolled capacity targets, incentive structure, measurement and verification methodology, regulatory authorization (PUC/FERC), program lifecycle status, performance reporting obligations, and behavioral campaign parameters. SSOT for all DR program definitions including behavioral DR campaign configurations. | CMM: CIM DemandResponseProgram (exact), IEC61968::Metering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DrProgram',
  'cmm.cim.class' = 'DemandResponseProgram',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Metering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-9',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.demand.dr_program'
);

-- DemandDrEnrollment  <<CIM Agreement : extension>>
CREATE TABLE IF NOT EXISTS `demand`.`demand_dr_enrollment` (
  `demand_dr_enrollment_id` BIGINT NOT NULL COMMENT 'Unique identifier for the demand response enrollment record. Primary key for the DR enrollment entity.',
  `account_id` BIGINT COMMENT 'Reference to the customer account enrolled in the demand response program. Links to the customer account master record in the Customer Information System (CIS).',
  `aggregator_id` BIGINT COMMENT 'Reference to the third-party demand response aggregator managing this customer enrollment on behalf of the utility. Null for direct utility-managed enrollments. Links to the aggregator master record defining aggregator contracts, settlement terms, and performance obligations.',
  `customer_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.customer_service_agreement. Business justification: DR enrollment must reference the specific service agreement governing rate schedule, service class, and contractual terms. Critical for tariff compliance, billing integration, and ensuring enrolled lo',
  `der_interconnection_point_id` BIGINT COMMENT 'Foreign key linking to distribution.der_interconnection_point. Business justification: Premises with DER assets (solar, battery storage) enrolled in DR/VPP programs require linkage to their interconnection point for telemetry, dispatch control, baseline calculation, and settlement. Esse',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_system. Business justification: DR enrollment tracks specific DER system providing curtailment capability. Measurement & verification requires system nameplate capacity, inverter specifications, and export limits. Baseline calculati',
  `distribution_transformer_id` BIGINT COMMENT 'Foreign key linking to distribution.transformer. Business justification: DR enrollments must track the distribution transformer serving the enrolled premise for capacity planning, hosting capacity analysis, and assessing grid impact during curtailment events. Essential for',
  `dr_program_id` BIGINT COMMENT 'Reference to the specific demand response program in which the customer is enrolled. Links to the DR program master record defining program rules, incentives, and dispatch protocols.',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Enrollments are aggregated by zone for ISO/RTO reporting, baseline calculation, and capacity market participation. Zone-level aggregation is required for settlement, performance reporting, and resourc',
  `interconnection_application_id` BIGINT COMMENT 'Foreign key linking to interconnection.application. Business justification: Customer DR enrollment requires completed interconnection for behind-the-meter DER. Enrollment verification validates interconnection approval status and export capacity limits. ISO/RTO registration a',
  `interruptible_tariff_agreement_id` BIGINT COMMENT 'Reference to the interruptible tariff agreement contract that governs the terms, conditions, and compensation for load curtailment. Links to the tariff agreement master record defining rate discounts, curtailment obligations, and penalty provisions.',
  `material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: Enrollments track specific equipment installed at customer premises (thermostats, control switches). Business process: asset tracking, warranty management, spare parts planning, equipment lifecycle ma',
  `meter_id` BIGINT COMMENT 'Reference to the Advanced Metering Infrastructure (AMI) meter device used to measure interval load data for baseline calculation and measurement and verification (M&V). Links to the meter device master record in Meter Data Management (MDM).',
  `meter_point_id` BIGINT COMMENT 'Reference to the physical service delivery point where demand response load curtailment will be measured. Links to the service point master record in the Customer Information System (CIS).',
  `average_curtailment_kw` DECIMAL(12,3) COMMENT 'The average actual load curtailment in kilowatts (kW) achieved by the customer across all participated DR events during the current enrollment period. Used for program performance analysis and capacity planning.',
  `baseline_adjustment_enabled_flag` BOOLEAN COMMENT 'Indicates whether day-of or morning-of baseline adjustments are enabled for this enrollment to account for real-time load variations. True: adjustments are applied. False: unadjusted baseline is used for M&V.',
  `baseline_calculation_method` STRING COMMENT 'The methodology used to calculate the customer baseline load (CBL) for measurement and verification (M&V) of load curtailment performance. High X of Y: average of highest X days in prior Y days. Mid X of Y: average of middle X days in prior Y days. Regression: statistical regression model. Control Group: comparison to similar non-participating customers. Meter Before Meter After: direct comparison of meter readings. Valid values: high_x_of_y|mid_x_of_y|regression|control_group|meter_before_meter_after.',
  `capacity_market_participation_flag` BOOLEAN COMMENT 'Indicates whether this enrollment is registered to participate in the ISO/RTO capacity market and is eligible to receive capacity payments for committed load reduction. True: participating in capacity market. False: energy-only or retail program participation.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this enrollment record was first created in the data platform. System-generated audit timestamp for data lineage and compliance.',
  `direct_load_control_enabled_flag` BOOLEAN COMMENT 'Indicates whether the utility has direct load control capability to remotely curtail customer load via smart thermostats, water heaters, or other controllable devices. True: DLC enabled. False: behavioral or manual curtailment only.',
  `enrolled_load_capacity_kw` DECIMAL(12,3) COMMENT 'The committed load reduction capacity in kilowatts (kW) that the customer has enrolled to curtail during demand response events. This is the System of Record (SSOT) for enrolled capacity reported to ISO/RTO for capacity market settlements and to PUC for program performance audits.',
  `enrollment_channel` STRING COMMENT 'The channel or method through which the customer enrolled in the demand response program. Web Portal: customer self-service online. Mobile App: enrollment via utility mobile application. Call Center: enrollment via customer service representative. Field Enrollment: enrollment by field agent or installer. Aggregator: enrollment through third-party demand response aggregator. Auto Enrollment: automatic enrollment based on rate class or program rules. Utility Initiated: proactive enrollment by utility for targeted customers. Reference-value candidates: web_portal|mobile_app|call_center|field_enrollment|aggregator|auto_enrollment|utility_initiated.',
  `enrollment_effective_date` DATE COMMENT 'The date on which the demand response enrollment becomes active and the customer becomes eligible to participate in DR events and receive incentive payments. Must align with program enrollment windows and ISO/RTO capacity commitment deadlines.',
  `enrollment_expiration_date` DATE COMMENT 'The date on which the demand response enrollment expires and the customer is no longer eligible for DR event dispatch or incentive payments. Null for open-ended enrollments subject to annual renewal or customer opt-out.',
  `enrollment_number` STRING COMMENT 'Business-facing unique enrollment number assigned to the customer for this DR program participation. Used in customer communications, billing statements, and regulatory reporting. Format: DR-XXXXXXXXXX. Pattern: ^DR-[0-9]{10}$.',
  `enrollment_source_system` STRING COMMENT 'The name of the operational system of record from which this enrollment record originated. Examples: SAP IS-U, Oracle CC&B, proprietary DR management system, aggregator platform.',
  `enrollment_source_system_code` STRING COMMENT 'The unique identifier of this enrollment record in the source operational system. Used for data lineage traceability and reconciliation with upstream systems.',
  `enrollment_status` STRING COMMENT 'Current lifecycle status of the demand response enrollment. Pending: enrollment submitted but not yet active. Active: enrollment is in effect and customer is eligible for DR events. Suspended: temporarily inactive due to non-compliance or customer request. Terminated: enrollment ended by utility or customer. Expired: enrollment period ended. Opted Out: customer exercised opt-out right. Valid values: pending|active|suspended|terminated|expired|opted_out.',
  `enrollment_timestamp` TIMESTAMP COMMENT 'The date and time when the customer enrollment was submitted and recorded in the system. Represents the business event time of enrollment initiation, distinct from audit timestamps.',
  `iso_rto_registration_number` STRING COMMENT 'The unique registration identifier assigned by the ISO or RTO for this demand response resource enrollment. Used for wholesale market participation, capacity market bidding, and settlement reconciliation with the ISO/RTO.',
  `last_opt_out_date` DATE COMMENT 'The date of the most recent opt-out event when the customer declined to participate in a dispatched DR event. Null if the customer has never opted out during the current enrollment period.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this enrollment record was most recently modified in the data platform. System-generated audit timestamp for change tracking and data quality monitoring.',
  `notification_lead_time_minutes` INT COMMENT 'The minimum advance notice time in minutes required to notify the customer before a demand response event dispatch. Defined by program rules and customer agreement. Typical values range from 15 minutes to 24 hours.',
  `notification_preference` STRING COMMENT 'The customer preferred method for receiving demand response event notifications and dispatch alerts. Email: email notification. SMS: text message. Phone: automated phone call. Mobile App: push notification via utility mobile app. None: no notification requested. Valid values: email|sms|phone|mobile_app|none.',
  `opt_out_count` INT COMMENT 'The cumulative number of times the customer has exercised their opt-out right to decline participation in a dispatched DR event during the current enrollment period. Used to track customer engagement and enforce program opt-out limits.',
  `participation_rate_percent` DECIMAL(5,2) COMMENT 'The percentage of dispatched DR events in which the customer successfully participated and achieved the required load curtailment during the current enrollment period. Calculated as (successful events / total dispatched events) * 100. Used for program performance reporting and customer incentive tier determination.',
  `puc_reporting_flag` BOOLEAN COMMENT 'Indicates whether this enrollment must be included in Public Utility Commission (PUC) demand response program participation and performance reports. True: include in PUC reporting. False: exclude from regulatory reporting.',
  `telemetry_enabled_flag` BOOLEAN COMMENT 'Indicates whether real-time telemetry data from the customer meter or behind-the-meter (BTM) devices is enabled for this enrollment to support real-time dispatch verification and settlement. True: telemetry enabled. False: interval data only.',
  `termination_date` DATE COMMENT 'The date on which the enrollment was terminated. Null for active, pending, or suspended enrollments. Populated when enrollment status transitions to terminated.',
  `termination_reason` STRING COMMENT 'The reason code for enrollment termination when enrollment status is terminated. Customer Request: customer voluntarily withdrew. Non-Compliance: customer failed to meet program requirements. Program Ended: DR program was discontinued. Account Closed: customer account was closed. Moved: customer moved out of service territory. Aggregator Change: customer switched to different aggregator. Other: other termination reason. Reference-value candidates: customer_request|non_compliance|program_ended|account_closed|moved|aggregator_change|other.',
  `total_incentive_payments_usd` DECIMAL(15,2) COMMENT 'The cumulative total of all incentive payments in United States Dollars (USD) paid to the customer for demand response participation during the current enrollment period. Includes capacity payments, energy payments, and performance bonuses.',
  `vpp_enrollment_flag` BOOLEAN COMMENT 'Indicates whether this enrollment is part of a Virtual Power Plant (VPP) aggregation that dispatches distributed energy resources (DER) as a single coordinated resource. True: enrolled in VPP. False: standalone DR enrollment.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_demand_demand_dr_enrollment` PRIMARY KEY (`demand_dr_enrollment_id`)
)
USING DELTA
COMMENT 'Master record capturing a customer account\'s enrollment in a specific DR program, including enrolled load capacity (kW), service point, meter, enrollment effective and expiration dates, enrollment channel, opt-out history, interruptible tariff agreement reference, and current enrollment status. SSOT for enrolled load capacity by customer and program. Supports ISO/RTO capacity reporting and PUC program participation audits. | CMM: CIM Agreement (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DemandDrEnrollment',
  'cmm.cim.class' = 'Agreement',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.demand.demand_dr_enrollment'
);

-- DrEvent  <<CIM EndDeviceControl : close>>
CREATE TABLE IF NOT EXISTS `demand`.`dr_event` (
  `dr_event_id` BIGINT NOT NULL COMMENT 'Unique identifier for the demand response event. Primary key for the DR event record.',
  `aggregator_id` BIGINT COMMENT 'Reference to the third-party demand response aggregator managing this event on behalf of the utility or ISO/RTO, if applicable.',
  `audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: DR events are subject to performance audits by ISO/RTO and regulatory bodies to verify curtailment delivery and baseline accuracy. Required for audit evidence collection, performance verification, and',
  `congestion_event_id` BIGINT COMMENT 'Foreign key linking to transmission.congestion_event. Business justification: DR events are dispatched in direct response to transmission congestion events. Linking DR dispatch to the triggering congestion event enables cost-benefit analysis, settlement reconciliation, and regu',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: DR events are dispatched to manage control area ACE and frequency deviations. Operators must track which control area initiated each event for NERC CPS1/CPS2 compliance reporting and real-time balanci',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: DR events incur operational costs (dispatch, settlement, M&V) that must be charged to cost centers. Total_incentive_payment represents expense requiring cost center assignment for budget variance anal',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_system. Business justification: DR event dispatch targets specific DER systems for curtailment. VPP aggregation and DERMS integration require system-level identification for telemetry and control commands. Event performance measurem',
  `dispatch_operator_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: DR events are dispatched by control room operators (employees) who make real-time decisions to trigger load curtailment based on grid conditions, market signals, or emergency situations. Critical for',
  `distribution_substation_id` BIGINT COMMENT 'Reference to the specific distribution substation targeted by this DR event, if geographic_scope is substation-level.',
  `dr_program_id` BIGINT COMMENT 'FK to demand.dr_program.dr_program_id — Every DR event is dispatched under a specific program. Required for program-level performance reporting and settlement.',
  `feeder_id` BIGINT COMMENT 'Reference to the specific distribution feeder targeted by this DR event, if geographic_scope is feeder-level.',
  `iso_rto_event_id` BIGINT COMMENT 'The external event identifier assigned by the Independent System Operator (ISO) or Regional Transmission Organization (RTO) for market-based DR events, used for settlement reconciliation.',
  `load_id` BIGINT COMMENT 'Foreign key linking to forecast.load. Business justification: Event dispatch decisions require load forecasts to determine timing, magnitude, and necessity of curtailment. Operators compare forecasted peak load against available capacity to trigger DR events for',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: DR events must comply with dispatch protocols mandated by regulatory obligations (e.g., NERC EOP-011 emergency operations, ISO/RTO market rules). Essential for event compliance validation, audit trail',
  `primary_dr_program_id` BIGINT COMMENT 'Reference to the parent demand response program under which this event was dispatched (e.g., CPP, TOU, direct load control, interruptible tariff).',
  `supporting_vendor_id` BIGINT COMMENT 'Foreign key linking to supply.vendor. Business justification: DR events may require vendor support services (dispatch coordination, technical support, equipment maintenance). Business process: vendor performance evaluation during events, service level agreement',
  `to_dr_program_id` BIGINT COMMENT 'FK to demand.dr_program.dr_program_id — Every DR event is dispatched under a specific program. This FK is required for program-level performance reporting and ISO/RTO settlement.',
  `transmission_outage_id` BIGINT COMMENT 'Foreign key linking to transmission.transmission_outage. Business justification: DR events are called during transmission outages to manage system loading and prevent cascading failures. Emergency DR dispatch during N-1 or N-2 contingencies is standard grid operations. Links DR re',
  `transmission_path_id` BIGINT COMMENT 'Foreign key linking to transmission.path. Business justification: DR events are dispatched to relieve congestion on specific transmission paths. Operators call DR to manage path loading, avoid TLR procedures, and maintain ATC. Critical for congestion management and',
  `triggering_outage_event_id` BIGINT COMMENT 'Foreign key linking to outage.outage_event. Business justification: DR events are frequently dispatched in response to grid emergencies that manifest as outage risks or actual supply shortfalls. Emergency operations centers coordinate DR dispatch with OMS to manage sy',
  `zone_id` BIGINT COMMENT 'Reference to the specific load zone or pricing zone targeted by this DR event, if geographic_scope is zone-level.',
  `actual_curtailment_mw` DECIMAL(12,3) COMMENT 'The actual load reduction in megawatts (MW) achieved during this DR event, calculated through baseline comparison and M&V processes.',
  `actual_duration_minutes` INT COMMENT 'The actual duration of the DR event in minutes, calculated from actual_start_timestamp to actual_end_timestamp, used for settlement.',
  `actual_end_timestamp` TIMESTAMP COMMENT 'The actual date and time when load curtailment ended, used for M&V and settlement calculations.',
  `actual_start_timestamp` TIMESTAMP COMMENT 'The actual date and time when load curtailment began, used for measurement and verification (M&V) and settlement calculations.',
  `baseline_load_mw` DECIMAL(12,3) COMMENT 'The calculated baseline load in megawatts (MW) representing what the load would have been without the DR event, used as the reference for curtailment measurement.',
  `baseline_methodology` STRING COMMENT 'The calculation method used to determine the baseline load for this event (e.g., 10-of-10, 5-of-10, regression-based, customer-specific), critical for M&V accuracy and settlement.',
  `cancellation_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether this DR event was cancelled before execution. True indicates the event was cancelled.',
  `cancellation_reason` STRING COMMENT 'Free-text explanation of why the DR event was cancelled, used for operational review and reporting.',
  `cancellation_timestamp` TIMESTAMP COMMENT 'The date and time when the DR event was cancelled, if cancellation_flag is True.',
  `compliance_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether this DR event met all regulatory and contractual compliance requirements (notification timing, curtailment delivery, reporting).',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this DR event record was first created in the system, used for audit trail and data lineage.',
  `dispatch_source_system` STRING COMMENT 'The operational system that originated the DR event dispatch (e.g., ADMS, DERMS, EMS, manual dispatch console), used for system integration tracking.',
  `dispatch_timestamp` TIMESTAMP COMMENT 'The exact date and time when the DR event was dispatched or issued to participants. This is the official event start trigger time.',
  `duration_minutes` INT COMMENT 'The planned duration of the DR event in minutes, calculated as the difference between scheduled_start_timestamp and scheduled_end_timestamp.',
  `event_number` STRING COMMENT 'Business-facing unique identifier or reference number for the DR event, used for external communication and reporting to ISO/RTO and customers.',
  `event_status` STRING COMMENT 'Current lifecycle status of the DR event: scheduled (future event), active (currently dispatched), completed (finished successfully), cancelled (terminated before start), aborted (terminated during execution), or pending (awaiting approval). Valid values: scheduled|active|completed|cancelled|aborted|pending.',
  `event_type` STRING COMMENT 'Classification of the DR event based on its purpose and trigger: emergency (grid reliability), economic (price-driven), test (program validation), scheduled (planned curtailment), voluntary (opt-in), or mandatory (contractual obligation). Valid values: emergency|economic|test|scheduled|voluntary|mandatory.',
  `geographic_scope` STRING COMMENT 'The geographic extent of the DR event: system_wide (entire service territory), zone (load zone or pricing zone), substation (specific substation), feeder (distribution feeder), or premise (individual customer site). Valid values: system_wide|zone|substation|feeder|premise.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this DR event record was last updated, used for audit trail and change tracking.',
  `lmp_at_dispatch` DECIMAL(10,2) COMMENT 'The locational marginal price in dollars per MWh at the relevant pricing node (PNode) at the time of event dispatch, used for economic DR event valuation.',
  `market_product_type` STRING COMMENT 'The wholesale market product associated with this DR event (e.g., day-ahead energy, real-time energy, regulation, spinning reserve, non-spinning reserve), if dispatched through ISO/RTO markets.',
  `notes` STRING COMMENT 'Free-text field for operational notes, special circumstances, or additional context about the DR event execution and outcomes.',
  `notification_lead_time_minutes` INT COMMENT 'The advance notice period in minutes provided to participants between notification and event start, measured as the difference between notification_timestamp and dispatch_timestamp.',
  `notification_timestamp` TIMESTAMP COMMENT 'The date and time when participants were notified of the upcoming DR event, used to calculate notification lead time compliance.',
  `opted_out_count` INT COMMENT 'The number of enrolled customers who opted out of this specific DR event, tracked for program compliance and customer behavior analysis.',
  `participant_count` INT COMMENT 'The total number of customers or premises that participated in this DR event, used for program performance reporting.',
  `performance_ratio` DECIMAL(5,2) COMMENT 'The ratio of actual curtailment to target curtailment expressed as a percentage (0-100), used to measure event effectiveness and participant compliance.',
  `scheduled_end_timestamp` TIMESTAMP COMMENT 'The planned date and time when load curtailment is scheduled to end for this DR event.',
  `scheduled_start_timestamp` TIMESTAMP COMMENT 'The planned date and time when load curtailment is scheduled to begin for this DR event.',
  `settlement_price` DECIMAL(10,2) COMMENT 'The final price in dollars per MWh used for customer incentive payment settlement for this DR event, may differ from LMP based on program rules.',
  `target_curtailment_mw` DECIMAL(12,3) COMMENT 'The target load reduction in megawatts (MW) requested for this DR event across all participating customers and assets.',
  `temperature_fahrenheit` DECIMAL(5,2) COMMENT 'The average ambient temperature in degrees Fahrenheit during the DR event, used for weather normalization in M&V calculations.',
  `total_incentive_payment` DECIMAL(12,2) COMMENT 'The total incentive payment amount in dollars paid to all participants for this DR event, calculated based on actual curtailment and settlement price.',
  `triggering_entity` STRING COMMENT 'The organization or system that initiated the DR event: utility (internal dispatch), ISO/RTO (market operator), aggregator (third-party DR provider), customer (self-curtailment), or system (automated trigger). Valid values: utility|iso|rto|aggregator|customer|system.',
  `vpp_dispatch_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether this DR event was dispatched as part of a virtual power plant (VPP) aggregation strategy.',
  `weather_condition` STRING COMMENT 'Description of the prevailing weather conditions during the DR event (e.g., extreme heat, cold snap, normal), used for baseline adjustment and event analysis.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_demand_dr_event` PRIMARY KEY (`dr_event_id`)
)
USING DELTA
COMMENT 'Transactional record of each DR dispatch event issued by the utility, ISO/RTO, or aggregator, including event type (emergency, economic, test), triggering entity, dispatch timestamp, notification lead time, target curtailment MW, geographic scope (zone, feeder, substation), event duration, cancellation flag, and post-event status. Core operational record for DR event lifecycle management and OMS/ADMS integration. | CMM: CIM EndDeviceControl (close), IEC61968::Metering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DrEvent',
  'cmm.cim.class' = 'EndDeviceControl',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Metering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-9',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.demand.dr_event'
);

-- DrEventParticipant  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `demand`.`dr_event_participant` (
  `dr_event_participant_id` BIGINT NOT NULL COMMENT 'Unique identifier for the demand response event participant record. Primary key for this transactional entity linking a customer, aggregated resource, or Direct Load Control (DLC) device to a specific DR event.',
  `account_id` BIGINT COMMENT 'Reference to the customer account participating in the DR event. Used for billing, incentive payment processing, and customer-level performance aggregation.',
  `aggregator_id` BIGINT COMMENT 'Reference to the third-party aggregator managing this participant resource. Used for wholesale market DR programs and aggregated DER portfolios. Null for utility-direct programs.',
  `caused_interruption_id` BIGINT COMMENT 'Foreign key linking to outage.interruption. Business justification: Direct load control actions during DR events can cause brief service interruptions to participating customers (cycling equipment, load shedding). Business process: Reconciling DR-induced interruptions',
  `demand_dr_enrollment_id` BIGINT COMMENT 'Reference to the customer enrollment record that authorized participation in this DR event. Links to the active enrollment in the DR program at the time of event dispatch.',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_system. Business justification: Participant-level performance measurement requires DER system technical specifications for baseline calculation and curtailment verification. Device command type and target setpoint validation depend',
  `direct_load_control_device_id` BIGINT COMMENT 'Reference to the specific Direct Load Control (DLC) device or Distributed Energy Resource (DER) that was dispatched during the event. Applicable for DLC programs, smart thermostats, battery storage, and VPP resources. Null for behavioral DR programs.',
  `dr_event_id` BIGINT COMMENT 'FK to demand.dr_event.dr_event_id — Core header-line relationship. Every participant record must reference the event it responds to. Required for event-level curtailment aggregation.',
  `interconnection_application_id` BIGINT COMMENT 'Foreign key linking to interconnection.application. Business justification: Compliance reporting and settlement require linking participant response to approved interconnection application for capacity verification. Incentive payment eligibility validation checks interconnect',
  `load_id` BIGINT COMMENT 'Foreign key linking to forecast.load. Business justification: Participant-level performance measurement requires comparing actual response against forecasted baseline load for the event window. Essential for M&V, settlement calculation, and performance ratio det',
  `premise_id` BIGINT COMMENT 'Reference to the physical premise location where the DR event participation occurred. Used for geographic analysis, load zone aggregation, and distribution system impact assessment.',
  `primary_dr_event_id` BIGINT COMMENT 'Reference to the parent DR event that this participant record is associated with. Links to the specific dispatch event across all DR program types (DLC, behavioral, interruptible, VPP, wholesale market).',
  `to_dr_event_id` BIGINT COMMENT 'FK to demand.dr_event.dr_event_id — Every participant response record must reference the event it responds to. This is the core header-to-line relationship for DR event performance tracking.',
  `acknowledgment_timestamp` TIMESTAMP COMMENT 'Date and time when the participant device or system acknowledged receipt of the dispatch command. Used to measure communication latency and confirm successful command delivery for DLC and VPP resources.',
  `actual_load_kw` DECIMAL(12,3) COMMENT 'Measured actual load in kilowatts consumed by the participant during the DR event window. Sourced from Advanced Metering Infrastructure (AMI) interval data or SCADA telemetry for real-time measurement.',
  `baseline_calculation_method` STRING COMMENT 'Methodology used to calculate the baseline load for this participant. Common methods include high X of Y days, regression-based, or control group comparison. Must align with program rules and regulatory requirements for Measurement and Verification (M&V). Valid values: high_10_of_10|high_5_of_10|mid_4_of_6|regression|control_group|customer_baseline.',
  `baseline_load_kw` DECIMAL(12,3) COMMENT 'Calculated baseline load in kilowatts representing what the participant would have consumed absent the DR event. Used as the reference point for measuring actual curtailment performance. Calculated using the baseline methodology specified in the program rules.',
  `committed_curtailment_kw` DECIMAL(12,3) COMMENT 'Load reduction in kilowatts that the participant committed to provide during the DR event. Used for interruptible tariff, VPP, and wholesale market programs where participants bid or contract specific curtailment amounts.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this participant event record was first created in the system. Audit field for data lineage and record lifecycle tracking.',
  `curtailment_duration_minutes` INT COMMENT 'Total duration in minutes that the participant actively curtailed load during the DR event. Used for calculating energy reduction (kWh) and validating minimum participation requirements.',
  `data_quality_flag` STRING COMMENT 'Indicator of the quality and reliability of the meter data used for performance measurement. Flags estimated or missing interval data that may affect settlement accuracy and require manual review. Valid values: verified|estimated|missing|suspect|adjusted.',
  `device_command_type` STRING COMMENT 'Type of control command issued to the DLC device or DER during the event. Applicable for direct load control programs. Null for behavioral and interruptible tariff programs. Valid values: shed|restore|cycle|setpoint_adjust|charge|discharge.',
  `dispatch_timestamp` TIMESTAMP COMMENT 'Date and time when the DR event dispatch command was issued to this participant. Represents the moment the utility or aggregator initiated the curtailment request or device control signal.',
  `energy_reduction_kwh` DECIMAL(12,3) COMMENT 'Total energy reduction in kilowatt-hours achieved by the participant during the DR event, calculated as measured curtailment (kW) multiplied by duration (hours). Used for program impact reporting and wholesale market settlement.',
  `engagement_score` DECIMAL(5,2) COMMENT 'Calculated engagement score for behavioral DR participants based on notification interaction (open, click, response). Used for segmentation, targeted messaging, and gamification strategies to improve participation rates.',
  `failure_reason` STRING COMMENT 'Categorized reason for participant non-response or under-performance during the DR event. Used for root cause analysis, device maintenance prioritization, and program improvement initiatives. Valid values: communication_failure|device_malfunction|customer_override|insufficient_load|weather_exception|system_error.',
  `incentive_payment_amount` DECIMAL(12,2) COMMENT 'Calculated incentive payment amount in local currency earned by the participant for this DR event based on measured curtailment, program rate structure, and performance ratio. Subject to final settlement and adjustment.',
  `incentive_payment_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the incentive payment amount. Supports multi-currency operations for utilities operating across international jurisdictions. Valid values: USD|CAD|EUR|GBP|AUD.',
  `incentive_payment_eligible_flag` BOOLEAN COMMENT 'Boolean indicator of whether this participant performance qualifies for incentive payment based on program rules, minimum performance thresholds, and compliance requirements. False indicates disqualification due to non-performance or rule violation.',
  `measured_curtailment_kw` DECIMAL(12,3) COMMENT 'Actual measured load reduction in kilowatts achieved by the participant during the DR event, calculated as baseline load minus actual load. This is the verified performance used for incentive payment calculation and program reporting.',
  `mv_method` STRING COMMENT 'Measurement and Verification method applied to validate the participant curtailment performance. Determines the data sources and calculation approach used for performance settlement and regulatory reporting. Valid values: meter_before_after|meter_comparison|stipulated|engineering_estimate|telemetry.',
  `non_performance_penalty_flag` BOOLEAN COMMENT 'Boolean indicator of whether a penalty applies to this participant for failing to meet committed curtailment obligations. Applicable for interruptible tariff and wholesale market programs with contractual performance requirements.',
  `notification_channel` STRING COMMENT 'Communication channel used to notify or dispatch this participant. For behavioral DR: notification method. For DLC: control protocol. Used for engagement analysis and communication effectiveness tracking. Valid values: email|sms|mobile_app|ivr|web_portal|direct_control.',
  `notification_delivery_status` STRING COMMENT 'Status of the event notification delivery to the participant for behavioral DR programs. Tracks email, SMS, or mobile app notification delivery confirmation and engagement. Valid values: delivered|failed|pending|bounced|opened|clicked.',
  `opt_out_reason` STRING COMMENT 'Participant-provided reason for opting out of the DR event. Used for customer satisfaction analysis and program design refinement to reduce opt-out frequency. Valid values: comfort_concern|health_safety|business_operations|prior_commitment|no_reason_given.',
  `opt_out_timestamp` TIMESTAMP COMMENT 'Date and time when the participant exercised their opt-out right to decline participation in this specific DR event. Applicable for programs allowing per-event opt-out within contractual limits.',
  `participant_to_enrollment` BIGINT COMMENT 'FK to demand.dr_enrollment.dr_enrollment_id — Links event participation back to the enrolled resource. Required to validate that participants are enrolled and to track per-enrollment performance history.',
  `participant_type` STRING COMMENT 'Classification of the DR participant type indicating the program mechanism and dispatch method. Determines which performance metrics and measurement methods apply to this participation record. Valid values: direct_load_control|behavioral|interruptible_tariff|vpp_resource|wholesale_market|aggregated_der.',
  `participation_status` STRING COMMENT 'Current lifecycle status of this participant record within the DR event. Tracks progression from dispatch through acknowledgment, response, and completion or failure. Reference-value candidates: dispatched|acknowledged|responding|completed|failed|opted_out|non_responsive.',
  `peer_comparison_percentile` INT COMMENT 'Percentile ranking of this participant performance relative to similar participants in the same program cohort. Used for behavioral DR feedback and social comparison messaging (e.g., You performed better than 75% of your neighbors).',
  `penalty_amount` DECIMAL(12,2) COMMENT 'Calculated penalty amount in local currency assessed against the participant for non-performance or under-performance during the DR event. Applied per contractual terms for interruptible and wholesale market programs.',
  `performance_ratio` DECIMAL(5,4) COMMENT 'Ratio of measured curtailment to committed curtailment, expressed as a decimal (e.g., 0.95 for 95% performance). Used to assess participant compliance with contractual obligations and determine penalty or bonus payment eligibility.',
  `response_classification` STRING COMMENT 'Categorical classification of the participant response quality based on performance ratio thresholds. Used for behavioral segmentation, program effectiveness analysis, and targeted engagement strategies. Valid values: full_response|partial_response|no_response|over_response|negative_response.',
  `response_end_timestamp` TIMESTAMP COMMENT 'Date and time when the participant response concluded, either by event completion, restore command, or participant opt-out. Marks the end of the performance measurement window.',
  `response_start_timestamp` TIMESTAMP COMMENT 'Date and time when the participant began actively responding to the DR event, as measured by load reduction or device state change. Marks the beginning of the performance measurement window.',
  `settlement_status` STRING COMMENT 'Current status of the financial settlement process for this participant event record. Tracks progression from initial calculation through approval, payment, and any dispute resolution. Valid values: pending|calculated|approved|paid|disputed|adjusted.',
  `settlement_timestamp` TIMESTAMP COMMENT 'Date and time when the financial settlement for this participant event was finalized and approved for payment processing. Used for payment reconciliation and audit trail.',
  `target_setpoint_unit` STRING COMMENT 'Unit of measure for the target setpoint value. Ensures correct interpretation of device control parameters across different resource types. Valid values: celsius|fahrenheit|kw|kw_per_hour|percent.',
  `target_setpoint_value` DECIMAL(10,2) COMMENT 'Target setpoint value commanded to the device during the DR event (e.g., thermostat temperature in degrees, battery discharge rate in kW). Applicable for DLC and VPP resources with adjustable setpoints.',
  `to_dr_enrollment` BIGINT COMMENT 'FK to demand.dr_enrollment.dr_enrollment_id — Every participant response must reference the enrollment that authorized participation. Required for incentive eligibility validation and capacity reporting.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this participant event record was last modified. Audit field for tracking changes to performance metrics, settlement status, or data quality adjustments.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_demand_dr_event_participant` PRIMARY KEY (`dr_event_participant_id`)
)
USING DELTA
COMMENT 'Transactional record linking an enrolled customer, aggregated resource, or DLC device to a specific DR event, serving as the single authoritative response record across ALL DR program types. For direct load control: captures device commands (shed/restore/cycle with target setpoints), acknowledgment status, actual device response, load shed achieved, dispatch duration, and failure reasons. For behavioral DR: captures notification delivery confirmation, peer comparison data, engagement scoring, pre-event baseline consumption, actual consumption during event window, calculated reduction, and response classification. For interruptible tariff, VPP, and wholesale market dispatch: captures committed curtailment (kW), actual measured curtailment (kW), performance ratio, incentive payment eligibility, non-performance penalty flag, and M&V method applied. SSOT for per-resource event performance tracking across all DR program types including DLC device-level response and behavioral DR customer engagement. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DrEventParticipant',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.demand.dr_event_participant'
);

-- LoadBaseline  <<CIM Curve : extension>>
CREATE TABLE IF NOT EXISTS `demand`.`load_baseline` (
  `load_baseline_id` BIGINT NOT NULL COMMENT 'Unique identifier for the load baseline calculation record. Primary key for the load baseline entity.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Load baselines must be calculated within control area boundaries for accurate curtailment measurement in ISO/RTO settlements. Control area load forecasts and actual interchange schedules are used to v',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_system. Business justification: Baseline calculation for behind-the-meter DER requires system capacity and export capability from interconnection approval. ISO/RTO baseline methodology depends on interconnection configuration (expor',
  `dr_event_id` BIGINT COMMENT 'Reference to the specific DR event for which this baseline is applicable. Null if this is a standing baseline not tied to a specific event.',
  `dr_program_id` BIGINT COMMENT 'Reference to the Demand Response program under which this baseline is calculated. Links to the DR program master record.',
  `load_id` BIGINT COMMENT 'Foreign key linking to forecast.load. Business justification: Baselines are calculated using historical load patterns and must align with load forecasts for accuracy validation, adjustment factor calculation, and weather normalization. Critical for ISO/RTO basel',
  `meter_id` BIGINT COMMENT 'Reference to the Advanced Metering Infrastructure (AMI) meter device used to capture interval data for baseline calculation.',
  `premise_id` BIGINT COMMENT 'Reference to the service premise where the baseline load is measured. Links to the premise master record.',
  `profile_id` BIGINT COMMENT 'Reference to the customer for whom this baseline load profile is calculated. Links to the customer master record in the Customer Information System (CIS).',
  `superseded_by_baseline_load_baseline_id` BIGINT COMMENT 'Reference to the baseline record that supersedes this one. Null if this is the current active baseline. Used to maintain baseline version history.',
  `adjustment_factor` DECIMAL(10,6) COMMENT 'Multiplicative adjustment factor applied to the baseline to account for day-of conditions (e.g., weather, operational changes). Typically ranges from 0.8 to 1.2. A value of 1.0 indicates no adjustment.',
  `adjustment_method` STRING COMMENT 'The method used to adjust the baseline for day-of conditions. Options include none (no adjustment), additive (add/subtract a fixed amount), multiplicative (apply a scaling factor), weather-normalized (adjust based on weather data), or pre-event-hours (adjust based on load in hours immediately before the event). Valid values: none|additive|multiplicative|weather-normalized|pre-event-hours.',
  `approval_timestamp` TIMESTAMP COMMENT 'Timestamp when this baseline was approved for use. Required for regulatory audit trail and compliance reporting.',
  `approved_by` STRING COMMENT 'Username or identifier of the person who approved this baseline for use in M&V calculations. Required for regulatory audit trail.',
  `baseline_calculation_date` DATE COMMENT 'The date on which this baseline load profile was calculated. Used for version control and audit trail purposes.',
  `baseline_effective_date` DATE COMMENT 'The date from which this baseline load profile becomes effective for Measurement and Verification (M&V) purposes.',
  `baseline_expiration_date` DATE COMMENT 'The date on which this baseline load profile expires and is no longer valid for M&V calculations. Null if the baseline remains valid until superseded.',
  `baseline_load_profile_json` STRING COMMENT 'JSON-encoded array of baseline load values (kWh) for each interval within the event window. Each element represents the expected load for a specific time interval. Format: [{"interval_start":"2024-07-15T14:00:00","load_kwh":125.4},{"interval_start":"2024-07-15T14:15:00","load_kwh":128.2}].',
  `baseline_methodology` STRING COMMENT 'The methodology used to calculate the customer baseline load. Common methods include 10-of-10 (average of 10 most recent similar days), high-10-of-10 (highest 10 days), mid-8-of-10 (middle 8 of 10), regression-based, weather-adjusted, or customer-specific algorithms approved by the ISO/RTO or PUC. Valid values: 10-of-10|high-10-of-10|mid-8-of-10|regression|weather-adjusted|customer-specific.',
  `baseline_source_days` STRING COMMENT 'Comma-separated list of dates (YYYY-MM-DD) used as source data for calculating this baseline. Provides traceability to the historical load data used in the calculation.',
  `baseline_status` STRING COMMENT 'Current lifecycle status of the baseline record. Indicates whether the baseline is in draft, pending approval, approved for use, actively in use, superseded by a newer version, or rejected. Valid values: draft|pending-approval|approved|active|superseded|rejected.',
  `baseline_to_enrollment` BIGINT COMMENT 'FK to demand.dr_enrollment.dr_enrollment_id — Baselines are calculated per enrolled resource. Required for M&V — you cannot measure curtailment without linking baseline to the enrolled customer/resource.',
  `baseline_version` INT COMMENT 'Version number of this baseline calculation. Increments with each recalculation or adjustment. Used for audit trail and historical comparison.',
  `calculation_engine` STRING COMMENT 'Name and version of the software system or calculation engine used to compute this baseline (e.g., Oracle MDM Baseline Calculator v3.2, Custom Python Engine v1.5). Used for audit and reproducibility.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this baseline record was first created in the system. Used for audit trail and data lineage.',
  `data_quality_score` DECIMAL(5,2) COMMENT 'Quality score (0-100) indicating the reliability of the input meter data used for baseline calculation. Based on completeness, accuracy, and validation status of interval data.',
  `estimation_method` STRING COMMENT 'Method used to estimate missing interval data in the baseline calculation. Options include none (no estimation), linear interpolation, similar-day substitution, regression-based estimation, or carry-forward from previous interval. Valid values: none|linear-interpolation|similar-day|regression|carry-forward.',
  `event_window_end_timestamp` TIMESTAMP COMMENT 'The end timestamp of the DR event window for which this baseline applies. Defines the conclusion of the curtailment measurement period.',
  `event_window_start_timestamp` TIMESTAMP COMMENT 'The start timestamp of the DR event window for which this baseline applies. Defines the beginning of the curtailment measurement period.',
  `exclusion_days` STRING COMMENT 'Comma-separated list of dates (YYYY-MM-DD) that were excluded from the baseline calculation due to holidays, prior DR events, or anomalous load conditions.',
  `interval_duration_minutes` INT COMMENT 'The duration of each interval in the baseline load profile, typically 15 or 60 minutes. Aligns with AMI meter reading intervals.',
  `iso_rto_submission_timestamp` TIMESTAMP COMMENT 'Timestamp when this baseline was submitted to the ISO/RTO for settlement. Null if not yet submitted.',
  `iso_rto_submitted_flag` BOOLEAN COMMENT 'Indicates whether this baseline has been submitted to the ISO/RTO for settlement purposes. True if submitted, False otherwise.',
  `last_modified_by` STRING COMMENT 'Username or identifier of the user or system process that last modified this baseline record. Required for audit trail.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this baseline record was last modified. Updated whenever any field in the record changes.',
  `missing_interval_count` INT COMMENT 'Number of intervals with missing or invalid meter data that were estimated or excluded from the baseline calculation. Used to assess baseline reliability.',
  `notes` STRING COMMENT 'Free-text notes documenting special circumstances, manual adjustments, or exceptions applied during baseline calculation. Used for audit trail and operational transparency.',
  `peak_baseline_demand_kw` DECIMAL(18,3) COMMENT 'The maximum demand (kW) observed in the baseline load profile during the event window. Used for capacity-based DR program settlement.',
  `puc_reporting_flag` BOOLEAN COMMENT 'Indicates whether this baseline is included in PUC program performance reporting. True if included, False otherwise.',
  `temperature_sensitivity_flag` BOOLEAN COMMENT 'Indicates whether this customer\'s load is temperature-sensitive and requires weather-adjusted baseline methodology. True if temperature-sensitive, False otherwise.',
  `to_dr_enrollment` BIGINT COMMENT 'FK to demand.dr_enrollment.dr_enrollment_id — Baselines are calculated per enrolled resource. Without this FK, you cannot match baselines to the correct customer enrollment for M&V calculations.',
  `total_baseline_energy_kwh` DECIMAL(18,3) COMMENT 'The sum of all interval baseline load values across the entire event window, expressed in kilowatt-hours (kWh). Used for aggregate curtailment measurement.',
  `weather_station_code` STRING COMMENT 'Identifier of the weather station used for weather-adjusted baseline calculations. Links to external weather data sources (e.g., NOAA, local meteorological services).',
  `created_by` STRING COMMENT 'Username or identifier of the user or system process that created this baseline record. Required for audit trail.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_demand_load_baseline` PRIMARY KEY (`load_baseline_id`)
)
USING DELTA
COMMENT 'Calculated customer baseline load profile used as the reference point for measuring curtailment during DR events. Stores baseline methodology (e.g., 10-of-10, regression, weather-adjusted), baseline interval values (kWh per 15-min or hourly), calculation date, applicable event window, adjustment factors, and version history. SSOT for M&V baseline data required by ISO/RTO settlement and PUC program reporting. | CMM: CIM Curve (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'LoadBaseline',
  'cmm.cim.class' = 'Curve',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.demand.load_baseline'
);

-- CurtailmentMeasurement  <<CIM MeasurementValue : extension>>
CREATE TABLE IF NOT EXISTS `demand`.`curtailment_measurement` (
  `curtailment_measurement_id` BIGINT NOT NULL COMMENT 'Unique identifier for the curtailment measurement record. Primary key for post-event measurement records capturing actual load reduction achieved during a Demand Response (DR) event interval.',
  `audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: Measurement & verification data serves as primary audit evidence for DR performance audits. Essential for M&V audit support, compliance documentation, and providing granular interval data to auditors',
  `curtailment_dr_event_participant_id` BIGINT COMMENT 'FK to demand.dr_event_participant.dr_event_participant_id — Curtailment measurements are interval-level detail records for a participant\'s event performance. Required for M&V settlement calculations.',
  `curtailment_load_baseline_id` BIGINT COMMENT 'FK to demand.load_baseline.load_baseline_id — Each curtailment measurement references the baseline used for comparison. Required for auditable M&V calculations.',
  `demand_dr_enrollment_id` BIGINT COMMENT 'Reference to the enrolled DR resource (customer premise, aggregated load zone, or DER asset) that participated in the curtailment event.',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_system. Business justification: Measurement & verification of curtailment performance requires DER system nameplate capacity, inverter specifications, and export limits from interconnection approval. Settlement quantity calculation',
  `dr_event_id` BIGINT COMMENT 'Reference to the parent DR event during which this curtailment was measured. Links to the DR event dispatch record that triggered the load reduction.',
  `employee_id` BIGINT COMMENT 'Identifier of the user or system that validated this measurement record. Used for audit trail and accountability in the M&V process.',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Curtailment measurements drive financial settlements with incentive_amount and penalty_amount requiring GL account posting for journal entries. Essential for accrual accounting, month-end close, and r',
  `lmp_price_id` BIGINT COMMENT 'Identifier of the LMP pricing node or zone where this curtailment resource is located. Used for wholesale market settlement and valuation of the load reduction at the nodal or zonal LMP.',
  `load_id` BIGINT COMMENT 'Foreign key linking to forecast.load. Business justification: M&V processes compare actual curtailment against forecasted load to calculate performance and settlement quantities. Required for ISO/RTO settlement, incentive payment calculation, and regulatory comp',
  `meter_id` BIGINT COMMENT 'Reference to the meter or metering point from which interval data was sourced for this measurement. May be an AMI meter, SCADA point, or aggregated virtual meter.',
  `to_dr_event_participant_id` BIGINT COMMENT 'FK to demand.dr_event_participant.dr_event_participant_id — Curtailment measurements are taken per participant per event. This FK links measured load reduction to the specific participant response record.',
  `to_load_baseline_id` BIGINT COMMENT 'FK to demand.load_baseline.load_baseline_id — Each curtailment measurement references the baseline used to calculate the reduction. Required for M&V audit trail.',
  `baseline_adjustment_factor` DECIMAL(8,4) COMMENT 'Multiplicative adjustment factor applied to the baseline to account for day-of conditions (weather, operational changes). Typically ranges from 0.8 to 1.2. A value of 1.0 indicates no adjustment.',
  `baseline_demand_kw` DECIMAL(18,3) COMMENT 'Calculated baseline power demand in kilowatts (kW) representing what the resource would have demanded absent the DR event. Used as the reference for curtailment calculation.',
  `baseline_load_kwh` DECIMAL(18,3) COMMENT 'Calculated baseline energy consumption in kilowatt-hours (kWh) representing what the resource would have consumed absent the DR event. Calculated using the baseline methodology specified in the DR program rules.',
  `baseline_method_code` STRING COMMENT 'Code identifying the baseline calculation methodology applied for this measurement. Common methods include High X of Y (e.g., average of highest 3 of last 10 similar days), Mid X of Y, regression-based, control group, meter-before, or customer-provided baseline. Valid values: HIGH_X_OF_Y|MID_X_OF_Y|REGRESSION|CONTROL_GROUP|METER_BEFORE|CUSTOMER_BASELINE.',
  `bid_quantity_kw` DECIMAL(18,3) COMMENT 'The bid quantity in kilowatts (kW) submitted by the resource or aggregator for this DR event interval. May differ from enrolled_capacity_kw if the resource bid a different amount for this specific event.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this curtailment measurement record was first created in the system. Represents the initial calculation or data ingestion time.',
  `curtailment_kw` DECIMAL(18,3) COMMENT 'Calculated load curtailment achieved during the interval in kilowatts (kW). Computed as baseline_demand_kw minus metered_demand_kw. Positive values indicate successful load reduction; negative values indicate load increase.',
  `curtailment_kwh` DECIMAL(18,3) COMMENT 'Calculated energy curtailment achieved during the interval in kilowatt-hours (kWh). Computed as baseline_load_kwh minus metered_load_kwh. Used for settlement and incentive payment calculation.',
  `data_quality_code` STRING COMMENT 'Code indicating the quality status of the metered data. ACTUAL indicates raw meter data; ESTIMATED indicates VEE-filled gaps; VALIDATED indicates passed quality checks; SUSPECT indicates potential data issues; MISSING indicates no data received; REJECTED indicates failed validation. Valid values: ACTUAL|ESTIMATED|VALIDATED|SUSPECT|MISSING|REJECTED.',
  `data_source_code` STRING COMMENT 'Code identifying the source of the metered load data. Values include AMI (Advanced Metering Infrastructure), SCADA (Supervisory Control and Data Acquisition), MANUAL (manual meter read), ESTIMATED (VEE-estimated), AGGREGATED (sum of multiple meters), or TELEMETRY (real-time sensor data). Valid values: AMI|SCADA|MANUAL|ESTIMATED|AGGREGATED|TELEMETRY.',
  `enrolled_capacity_kw` DECIMAL(18,3) COMMENT 'The enrolled or nominated load reduction capacity in kilowatts (kW) for this resource during the DR event. Represents the committed curtailment target used for performance evaluation and settlement.',
  `incentive_amount` DECIMAL(18,2) COMMENT 'Calculated incentive payment amount in currency for this measurement interval. Computed as settlement_quantity_kw multiplied by incentive_rate_per_kwh and interval duration. Subject to program caps and adjustments.',
  `incentive_rate_per_kwh` DECIMAL(18,6) COMMENT 'The incentive payment rate in currency per kilowatt-hour ($/kWh) applicable to this measurement interval. Rate may vary by time-of-use period, event type, or performance tier.',
  `interval_duration_minutes` INT COMMENT 'Duration of the measurement interval in minutes. Common values are 5, 15, or 60 minutes depending on ISO/RTO market settlement rules and meter data granularity.',
  `interval_end_timestamp` TIMESTAMP COMMENT 'End timestamp of the measurement interval during the DR event. Defines the boundary of the measurement period for load curtailment calculation.',
  `interval_start_timestamp` TIMESTAMP COMMENT 'Start timestamp of the measurement interval during the DR event. Typically aligned to 5-minute, 15-minute, or hourly intervals per ISO/RTO settlement rules.',
  `iso_rto_market_code` STRING COMMENT 'Code identifying the ISO/RTO wholesale market to which this curtailment measurement is reported for settlement. Values include CAISO, ERCOT, ISONE, MISO, NYISO, PJM, SPP, or NONE for retail-only programs. Reference-value candidates: CAISO|ERCOT|ISONE|MISO|NYISO|PJM|SPP|NONE.',
  `lmp_price_per_mwh` DECIMAL(18,6) COMMENT 'The Locational Marginal Price in currency per megawatt-hour ($/MWh) at the resource location during this interval. Used to value the curtailment for wholesale market settlement or avoided cost calculation.',
  `measurement_status_code` STRING COMMENT 'Lifecycle status of the curtailment measurement record. PRELIMINARY indicates initial calculation; VALIDATED indicates passed M&V review; SETTLED indicates used for payment calculation; DISPUTED indicates under review; ADJUSTED indicates corrected after dispute; FINAL indicates locked for regulatory reporting. Valid values: PRELIMINARY|VALIDATED|SETTLED|DISPUTED|ADJUSTED|FINAL.',
  `metered_demand_kw` DECIMAL(18,3) COMMENT 'Actual power demand measured during the interval in kilowatts (kW). Represents the average or peak demand during the measurement period depending on metering configuration.',
  `metered_load_kwh` DECIMAL(18,3) COMMENT 'Actual energy consumption measured during the interval in kilowatt-hours (kWh). Sourced from AMI meter data, SCADA telemetry, or estimated via Validation Estimation and Editing (VEE) process.',
  `mv_method_code` STRING COMMENT 'Code identifying the Measurement and Verification (M&V) protocol applied to validate the curtailment calculation. Common protocols include IPMVP Options A-D (International Performance Measurement and Verification Protocol) or utility-specific custom methods. Valid values: OPTION_A|OPTION_B|OPTION_C|OPTION_D|IPMVP|CUSTOM.',
  `penalty_amount` DECIMAL(18,2) COMMENT 'Penalty amount in currency assessed for under-performance or non-compliance during this interval. Applied when actual curtailment falls below minimum performance thresholds defined in the DR program agreement.',
  `performance_ratio` DECIMAL(8,4) COMMENT 'Ratio of actual curtailment achieved to the enrolled capacity or bid quantity for this resource during the interval. Calculated as curtailment_kw divided by enrolled_capacity_kw. Values above 1.0 indicate over-performance; below 1.0 indicate under-performance.',
  `reported_to_iso_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this measurement has been reported to the ISO/RTO for wholesale market settlement. True indicates the record was included in the ISO/RTO performance report; False indicates retail-only or not yet reported.',
  `reported_to_iso_timestamp` TIMESTAMP COMMENT 'Timestamp when this measurement was submitted to the ISO/RTO for wholesale market settlement. Used for tracking reporting deadlines and settlement cycles.',
  `reported_to_puc_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this measurement has been included in regulatory reporting to the state Public Utility Commission (PUC). True indicates the record was included in DR program performance reports; False indicates not yet reported.',
  `settlement_quantity_kw` DECIMAL(18,3) COMMENT 'The final settled curtailment quantity in kilowatts (kW) used for incentive payment calculation. May differ from curtailment_kw after applying performance thresholds, caps, or adjustments per program rules.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this curtailment measurement record was last modified. Tracks revisions due to data corrections, dispute resolution, or re-calculation with updated baseline methods.',
  `validated_timestamp` TIMESTAMP COMMENT 'Timestamp when this measurement record was validated and approved for settlement. Marks the transition from preliminary to validated status in the measurement lifecycle.',
  `validation_notes` STRING COMMENT 'Free-text notes documenting validation findings, data quality issues, adjustments applied, or dispute resolution details for this measurement record. Used for audit trail and M&V documentation.',
  `vee_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the metered data was processed through Validation Estimation and Editing (VEE) logic. True indicates VEE was applied to fill gaps or correct suspect data; False indicates raw meter data was used.',
  `vee_method_code` STRING COMMENT 'Code identifying the VEE estimation method applied when metered data was missing or suspect. Common methods include linear interpolation, historical average, similar day substitution, regression-based estimation, or NONE if no VEE was applied. Valid values: LINEAR_INTERPOLATION|HISTORICAL_AVERAGE|SIMILAR_DAY|REGRESSION|NONE.',
  `weather_humidity_percent` DECIMAL(5,2) COMMENT 'Relative humidity percentage at the resource location during the measurement interval. Used for baseline adjustment in weather-sensitive load profiles.',
  `weather_temperature_f` DECIMAL(6,2) COMMENT 'Ambient temperature in degrees Fahrenheit at the resource location during the measurement interval. Used for baseline adjustment and performance analysis. May be sourced from weather station data or utility weather service.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_demand_curtailment_measurement` PRIMARY KEY (`curtailment_measurement_id`)
)
USING DELTA
COMMENT 'Post-event measurement record capturing actual load curtailment achieved by an enrolled resource during a DR event interval. Stores interval-level metered load (kWh/kW), baseline load, calculated curtailment (kW), data source (AMI, SCADA, estimated), validation status, VEE flags, and M&V method applied. Feeds DR settlement, incentive payment calculation, and ISO/RTO performance reporting. | CMM: CIM MeasurementValue (extension), IEC61970::Meas.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CurtailmentMeasurement',
  'cmm.cim.class' = 'MeasurementValue',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Meas',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.demand.curtailment_measurement'
);

-- DrIncentivePayment  <<CIM Transaction : broad>>
CREATE TABLE IF NOT EXISTS `demand`.`dr_incentive_payment` (
  `dr_incentive_payment_id` BIGINT NOT NULL COMMENT 'Unique identifier for the demand response incentive payment transaction. Primary key for the DR incentive payment record.',
  `account_id` BIGINT COMMENT 'Reference to the customer account associated with this incentive payment for billing integration.',
  `aggregator_id` BIGINT COMMENT 'Reference to the demand response aggregator managing the customer enrollment and receiving payment on behalf of enrolled customers.',
  `audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: Incentive payments are audited for accuracy and regulatory compliance, especially for cost recovery in rate cases. Required for financial audit trail, settlement verification, and demonstrating pruden',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Incentive payments are expenses charged to cost centers for budget tracking and variance analysis. Utility_net_cost requires cost center assignment to enable budget-to-actual reporting and cost alloca',
  `dr_event_id` BIGINT COMMENT 'FK to demand.dr_event.dr_event_id — Incentive payments and settlements are calculated per event (or per settlement period covering events). This FK links financial obligations to the triggering event for reconciliation.',
  `dr_program_id` BIGINT COMMENT 'FK to demand.dr_program.dr_program_id — Payments are issued under program-specific incentive structures. Required for program-level financial reporting.',
  `energy_price_id` BIGINT COMMENT 'Foreign key linking to forecast.energy_price. Business justification: Payment calculations for energy-based DR programs use LMP forecasts for valuation and settlement pricing. Essential for economic dispatch decisions, participant compensation, and cost-effectiveness an',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Incentive payments must post to specific GL accounts (typically FERC 565 - Customer Assistance Expenses or similar) for financial statement preparation, journal entry creation, and regulatory reportin',
  `interconnection_application_id` BIGINT COMMENT 'Foreign key linking to interconnection.application. Business justification: Payment eligibility verification requires confirmed interconnection approval status. Capacity payments are tied to interconnection-approved export capacity limits. ISO/RTO settlement reconciliation va',
  `primary_dr_event_id` BIGINT COMMENT 'Reference to the specific demand response event that triggered this incentive payment.',
  `primary_dr_event_participant_id` BIGINT COMMENT 'FK to demand.dr_event_participant.dr_event_participant_id — Incentive payments are calculated based on participant performance in events. Required for financial reconciliation and customer payment accuracy.',
  `primary_dr_program_id` BIGINT COMMENT 'Reference to the demand response program under which this payment is made (e.g., CPP, TOU, direct load control, interruptible tariff).',
  `profile_id` BIGINT COMMENT 'Reference to the customer receiving the incentive payment. May be null if payment is made to an aggregator on behalf of multiple customers.',
  `to_dr_event_participant_id` BIGINT COMMENT 'FK to demand.dr_event_participant.dr_event_participant_id — Incentive payments are calculated based on participant event performance. This FK links financial records to the performance data that generated them.',
  `to_dr_program_id` BIGINT COMMENT 'FK to demand.dr_program.dr_program_id — Financial settlements must reference the program for rate structure, incentive rules, and regulatory reporting.',
  `actual_load_kw` DECIMAL(15,3) COMMENT 'The measured actual load in kilowatts during the demand response event. Used to calculate curtailment performance.',
  `aggregator_share_amount` DECIMAL(15,2) COMMENT 'Dollar amount of the payment allocated to the aggregator based on the aggregator share percentage.',
  `aggregator_share_percentage` DECIMAL(5,2) COMMENT 'Percentage of the gross payment retained by the aggregator as commission for program management and customer enrollment services.',
  `approval_timestamp` TIMESTAMP COMMENT 'Timestamp when the incentive payment was approved for disbursement by authorized personnel.',
  `approved_by` STRING COMMENT 'Username or identifier of the person who approved this incentive payment for disbursement.',
  `baseline_load_kw` DECIMAL(15,3) COMMENT 'The calculated baseline load in kilowatts representing the customers expected consumption without demand response curtailment. Used for measurement and verification (M&V) calculations.',
  `calculation_basis` STRING COMMENT 'Detailed description of the calculation methodology used for this payment, including baseline calculation method, M&V approach, and rate application logic.',
  `capacity_payment_amount` DECIMAL(15,2) COMMENT 'The calculated capacity payment amount in dollars based on enrolled capacity and capacity rate. Represents payment for availability.',
  `capacity_rate_per_kw` DECIMAL(12,4) COMMENT 'The contracted capacity payment rate in dollars per kilowatt for the enrolled demand response capacity. Basis for capacity payment calculations.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this incentive payment record was first created in the system.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this payment record (e.g., USD, CAD). Pattern: ^[A-Z]{3}$.',
  `curtailment_duration_minutes` INT COMMENT 'Total duration in minutes that the customer maintained load curtailment during the demand response event.',
  `customer_net_payment_amount` DECIMAL(15,2) COMMENT 'Net payment amount in dollars disbursed to the customer after aggregator share and penalty deductions.',
  `disbursement_date` DATE COMMENT 'Date on which the incentive payment was disbursed to the customer or aggregator.',
  `disbursement_reference` STRING COMMENT 'Reference number for the payment disbursement transaction (e.g., check number, wire confirmation, EFT trace number) for reconciliation with financial systems.',
  `energy_curtailed_kwh` DECIMAL(15,3) COMMENT 'Total energy curtailed in kilowatt-hours during the settlement period, calculated as measured curtailment multiplied by duration. Used for energy payment calculations.',
  `energy_payment_amount` DECIMAL(15,2) COMMENT 'The calculated energy payment amount in dollars based on measured curtailment and energy rate or LMP. Represents payment for actual performance.',
  `energy_rate_per_kwh` DECIMAL(12,6) COMMENT 'The contracted energy payment rate in dollars per kilowatt-hour for verified load curtailment. Used for retail-level energy payment calculations.',
  `enrolled_capacity_kw` DECIMAL(15,3) COMMENT 'The committed demand response capacity in kilowatts that the customer or aggregator enrolled for this settlement period. Basis for capacity payments.',
  `gross_payment_amount` DECIMAL(15,2) COMMENT 'Total gross incentive payment amount in dollars before aggregator share and deductions. Sum of capacity, energy, and bonus payments.',
  `iso_rto_name` STRING COMMENT 'Name of the ISO or RTO wholesale market from which this payment originates (e.g., PJM, CAISO, ERCOT, NYISO, ISO-NE, MISO, SPP). Null for retail-only programs.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this incentive payment record was last updated, reflecting the most recent change to payment status, amounts, or reconciliation status.',
  `lmp_price_per_mwh` DECIMAL(12,4) COMMENT 'The locational marginal price in dollars per megawatt-hour at the pricing node (PNode) during the demand response event. Used for wholesale market energy payment calculations.',
  `measured_curtailment_kw` DECIMAL(15,3) COMMENT 'The verified load reduction in kilowatts achieved during the demand response event, calculated as baseline load minus actual load. Basis for energy payments.',
  `notes` STRING COMMENT 'Free-text notes regarding special circumstances, adjustments, disputes, or other relevant information about this incentive payment.',
  `payment_method` STRING COMMENT 'Method by which the incentive payment is disbursed: bill credit applied to customer account, direct deposit to bank account, physical check, wire transfer, or settlement through aggregator. Valid values: bill_credit|direct_deposit|check|wire_transfer|aggregator_settlement.',
  `payment_reference_number` STRING COMMENT 'Unique business identifier for this incentive payment transaction, used for customer communication and payment tracking.',
  `payment_status` STRING COMMENT 'Current lifecycle status of the incentive payment: pending calculation (awaiting M&V), pending approval (awaiting management review), approved (ready for disbursement), disbursed (payment issued), reconciled (matched with wholesale settlement), disputed (under review), or cancelled (voided). Reference-value candidates: pending_calculation|pending_approval|approved|disbursed|reconciled|disputed|cancelled.',
  `payment_to_enrollment` BIGINT COMMENT 'FK to demand.dr_enrollment.dr_enrollment_id — Payments are issued to enrolled customers/aggregators. This FK links the payment to the enrollment record for customer identification and payment routing.',
  `payment_type` STRING COMMENT 'Classification of the incentive payment type: capacity payment for enrolled load, energy payment for actual curtailment, performance bonus for exceeding targets, penalty deduction for non-performance, reconciliation adjustment for settlement corrections, or aggregator commission for program management. Valid values: capacity_payment|energy_payment|performance_bonus|penalty_deduction|reconciliation_adjustment|aggregator_commission.',
  `penalty_deduction_amount` DECIMAL(15,2) COMMENT 'Penalty amount in dollars deducted from payment for non-performance, failure to curtail, or non-compliance with program requirements.',
  `performance_bonus_amount` DECIMAL(15,2) COMMENT 'Additional incentive payment in dollars awarded for exceeding curtailment targets or achieving exceptional performance metrics.',
  `pnode_identifier` STRING COMMENT 'Identifier for the pricing node in the wholesale market where the demand response resource is located. Used for LMP-based settlement calculations.',
  `reconciliation_status` STRING COMMENT 'Status of reconciliation between retail incentive payment and wholesale market settlement: not reconciled, reconciled (matched), variance identified (discrepancy found), under review (investigating), or resolved (variance corrected). Valid values: not_reconciled|reconciled|variance_identified|under_review|resolved.',
  `settlement_period_end` TIMESTAMP COMMENT 'End timestamp of the settlement period covered by this incentive payment. Defines the billing cycle or market settlement window.',
  `settlement_period_start` TIMESTAMP COMMENT 'Start timestamp of the settlement period covered by this incentive payment. Aligns with ISO/RTO settlement intervals for wholesale market payments.',
  `settlement_statement_reference` STRING COMMENT 'Cross-reference to the ISO/RTO wholesale market settlement statement from which this payment originates. Used for reconciliation with wholesale market settlements.',
  `utility_net_cost` DECIMAL(15,2) COMMENT 'Net cost to the utility in dollars for this demand response incentive payment after accounting for wholesale market revenue offsets and ISO/RTO settlements.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_demand_dr_incentive_payment` PRIMARY KEY (`dr_incentive_payment_id`)
)
USING DELTA
COMMENT 'Transactional record of all DR financial settlements and incentive payments, serving as the single authoritative financial record for the demand domain. Covers wholesale market settlement (ISO/RTO capacity and energy payments, LMP-based calculations, performance adjustments, settlement statement references, settlement period reconciliation) and retail-level incentive disbursements (capacity payments, energy payments, performance bonuses, penalty deductions). Captures settlement period, calculation basis, enrolled capacity, measured curtailment, gross and net amounts, aggregator share, utility net cost, payment approval status, disbursement reference, reconciliation status, and ISO/RTO settlement statement cross-reference. SSOT for ALL DR financial obligations — wholesale settlement, retail incentives, aggregator payments, customer disbursements, and settlement reconciliation with wholesale markets. | CMM: CIM Transaction (broad), IEC61968::PaymentMetering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DrIncentivePayment',
  'cmm.cim.class' = 'Transaction',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61968::PaymentMetering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.demand.dr_incentive_payment'
);

-- DrAggregator  <<CIM MarketParticipant : close>>
CREATE TABLE IF NOT EXISTS `demand`.`aggregator` (
  `aggregator_id` BIGINT NOT NULL COMMENT 'Unique identifier for the demand response aggregator or curtailment service provider (CSP). Primary key for the aggregator master record.',
  `audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: Aggregators undergo compliance audits by FERC and regional entities to verify performance, telemetry accuracy, and contractual compliance. Required for aggregator performance audits, compliance verifi',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Aggregator relationships incur administrative and settlement costs that must be tracked by cost center. Performance_bond_amount and contracted_capacity_mw represent financial obligations requiring cos',
  `der_installer_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_installer. Business justification: Aggregators partner with certified DER installers for customer acquisition and enrollment pipeline development. Installer performance metrics (application completeness rate, average time to PTO) infor',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Aggregators operate in specific geographic zones/service territories for capacity aggregation and ISO/RTO market participation. Zone assignment is required for local capacity requirements, transmissio',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Aggregators must comply with FERC Order 2222 registration obligations and regional entity operational requirements. Essential for aggregator compliance tracking, registration validation, and ensuring',
  `primary_contact_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Aggregator relationships are managed by specific utility account managers (employees) who coordinate contracts, performance monitoring, and settlement. Primary_contact fields denormalize employee data',
  `vendor_id` BIGINT COMMENT 'Foreign key linking to supply.vendor. Business justification: Aggregators are registered as vendors for payment processing and contract management. Business process: financial settlement, invoice verification, payment terms administration, performance bond track',
  `aggregation_platform` STRING COMMENT 'Name or description of the technology platform or system used by the aggregator to manage and dispatch aggregated customer load.',
  `aggregator_code` STRING COMMENT 'Short business code or abbreviation used internally to identify the aggregator in operational systems and reports.',
  `aggregator_name` STRING COMMENT 'Full legal name of the third-party demand response aggregator or curtailment service provider as registered with regulatory authorities.',
  `aggregator_status` STRING COMMENT 'Current operational status of the aggregator relationship with the utility, indicating whether the aggregator is authorized to aggregate customer load. Valid values: active|inactive|suspended|pending_approval|terminated.',
  `aggregator_type` STRING COMMENT 'Classification of the aggregator based on its primary business model and service offering in the demand response ecosystem. Valid values: curtailment_service_provider|demand_response_aggregator|virtual_power_plant_operator|energy_service_company|load_serving_entity.',
  `baseline_methodology` STRING COMMENT 'Approved methodology used to calculate customer baseline load for measurement and verification of demand response performance (e.g., high-X-of-Y, regression-based).',
  `business_address_line1` STRING COMMENT 'First line of the aggregators primary business address, typically including street number and street name.',
  `business_address_line2` STRING COMMENT 'Second line of the aggregators business address for suite, floor, or building information.',
  `business_city` STRING COMMENT 'City or municipality of the aggregators primary business address.',
  `business_country_code` STRING COMMENT 'Three-letter ISO country code for the aggregators primary business address location. Valid values: USA|CAN|MEX.',
  `business_postal_code` STRING COMMENT 'Postal code or ZIP code of the aggregators primary business address.',
  `business_state_province` STRING COMMENT 'State, province, or region of the aggregators primary business address.',
  `capacity_payment_rate_per_mw` DECIMAL(10,4) COMMENT 'Monthly or annual capacity payment rate in dollars per megawatt of enrolled demand response capacity, paid to the aggregator for maintaining availability.',
  `compliance_status` STRING COMMENT 'Current compliance status of the aggregator with respect to regulatory requirements, performance obligations, and contractual terms. Valid values: compliant|non_compliant|under_review|conditional.',
  `contract_end_date` DATE COMMENT 'Scheduled end date or expiration date of the aggregator service agreement, after which the contract must be renewed or terminated.',
  `contract_start_date` DATE COMMENT 'Effective start date of the aggregator service agreement with the utility, marking the beginning of the contractual relationship.',
  `contracted_capacity_mw` DECIMAL(12,3) COMMENT 'Total contracted demand response capacity in megawatts that the aggregator has committed to provide under the service agreement.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the aggregator record was first created in the system, capturing the initial registration date.',
  `dispatch_notification_method` STRING COMMENT 'Primary method used to notify the aggregator of demand response event dispatch instructions (e.g., API, email, phone). Valid values: api|email|phone|sms|platform.',
  `duns_number` STRING COMMENT 'Dun & Bradstreet DUNS number for the aggregator organization, used for business identity verification and credit assessment.',
  `enrolled_capacity_mw` DECIMAL(12,3) COMMENT 'Current enrolled demand response capacity in megawatts from customer accounts aggregated by this provider, representing actual load available for curtailment.',
  `ferc_registration_number` STRING COMMENT 'FERC-issued registration identifier for the aggregator entity, required for participation in wholesale demand response markets.',
  `incentive_rate_per_mwh` DECIMAL(10,4) COMMENT 'Standard incentive payment rate in dollars per megawatt-hour of verified demand response performance delivered by the aggregator.',
  `iso_rto_registration_number` STRING COMMENT 'ISO or RTO market participant identifier assigned to the aggregator for wholesale demand response market participation and settlement.',
  `last_compliance_review_date` DATE COMMENT 'Date of the most recent compliance review or audit conducted to assess the aggregators adherence to regulatory and contractual requirements.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update or modification to the aggregator record, used for audit trail and data lineage.',
  `maximum_event_duration_hours` DECIMAL(5,2) COMMENT 'Maximum allowable duration in hours for a single demand response event under the aggregator service agreement.',
  `maximum_events_per_year` INT COMMENT 'Maximum number of demand response events that can be called per calendar year under the aggregator service agreement.',
  `measurement_verification_protocol` STRING COMMENT 'Specific measurement and verification protocol or standard applied to validate demand response performance and calculate incentive payments.',
  `minimum_notice_hours` DECIMAL(5,2) COMMENT 'Minimum advance notice time in hours required before a demand response event can be dispatched to the aggregator.',
  `next_compliance_review_date` DATE COMMENT 'Scheduled date for the next compliance review or audit of the aggregators operations and performance.',
  `notes` STRING COMMENT 'Free-form text field for additional notes, comments, or special instructions related to the aggregator relationship and operations.',
  `payment_terms` STRING COMMENT 'Standard payment terms for incentive payments and settlements with the aggregator, such as net-30 or net-60 days.',
  `performance_bond_amount` DECIMAL(15,2) COMMENT 'Dollar value of the performance bond or financial guarantee posted by the aggregator to ensure compliance with contractual capacity commitments and performance obligations.',
  `performance_bond_expiry_date` DATE COMMENT 'Expiration date of the current performance bond or financial guarantee, after which the bond must be renewed or replaced.',
  `performance_penalty_rate` DECIMAL(10,4) COMMENT 'Financial penalty rate applied per MW of underperformance when the aggregator fails to deliver committed demand response capacity during an event.',
  `service_territory` STRING COMMENT 'Geographic service territory or jurisdiction where the aggregator is authorized to operate and aggregate customer demand response load.',
  `settlement_frequency` STRING COMMENT 'Frequency at which demand response performance settlements and incentive payments are calculated and paid to the aggregator. Valid values: monthly|quarterly|event_based|annual.',
  `tax_identification_number` STRING COMMENT 'Federal tax identification number (EIN or TIN) for the aggregator legal entity, used for financial reporting and tax compliance.',
  `telemetry_interval_minutes` INT COMMENT 'Frequency in minutes at which telemetry data must be transmitted from aggregated customer sites to the utility or ISO/RTO (e.g., 5-minute intervals).',
  `telemetry_required_flag` BOOLEAN COMMENT 'Indicates whether real-time telemetry data from aggregated customer sites is required for dispatch and settlement purposes.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_demand_aggregator` PRIMARY KEY (`aggregator_id`)
)
USING DELTA
COMMENT 'Master record for third-party demand response aggregators and curtailment service providers (CSPs) registered to aggregate customer load for ISO/RTO wholesale DR markets. Captures aggregator legal entity, FERC/ISO registration ID, service territory, aggregation technology platform, contractual capacity commitment (MW), performance bond, compliance status, and active program associations. SSOT for aggregator identity and contractual management. | CMM: CIM MarketParticipant (close), IEC62325::MarketCommon.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DrAggregator',
  'cmm.cim.class' = 'MarketParticipant',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC62325::MarketCommon',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.demand.aggregator'
);

-- InterruptibleTariffAgreement  <<CIM CustomerAgreement : close>>
CREATE TABLE IF NOT EXISTS `demand`.`interruptible_tariff_agreement` (
  `interruptible_tariff_agreement_id` BIGINT NOT NULL COMMENT 'Unique identifier for the interruptible service tariff agreement. Primary key for this entity.',
  `account_id` BIGINT COMMENT 'Reference to the customer account enrolled in this interruptible tariff agreement. Links to the customer account that holds the contractual relationship.',
  `account_manager_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Interruptible tariff agreements are negotiated and managed by key account managers (employees) who work with large commercial/industrial customers on contract terms, compliance testing, and curtailmen',
  `aggregator_id` BIGINT COMMENT 'Reference to the third-party demand response aggregator managing this interruptible load resource on behalf of the customer. Nullable if the utility manages the resource directly.',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Tariff agreements create bill credits (revenue reductions) that must post to specific GL accounts for revenue recognition. Bill_credit_rate_per_kw drives monthly journal entries requiring GL account m',
  `interconnection_application_id` BIGINT COMMENT 'Foreign key linking to interconnection.application. Business justification: Interruptible tariff enrollment for behind-the-meter generation requires completed interconnection approval. Tariff bill credits are calculated based on interconnection-approved export capacity. Compl',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Tariff agreements must comply with approved tariff schedules filed with PUCs. Essential for tariff compliance validation, rate case support, and ensuring interruptible rate offerings match regulatory',
  `peak_demand_id` BIGINT COMMENT 'Foreign key linking to forecast.peak_demand. Business justification: Interruptible tariffs are designed to reduce peak demand; agreements reference peak demand forecasts for capacity credit calculation, rate design, and avoided capacity cost determination. Essential fo',
  `planned_outage_window_id` BIGINT COMMENT 'Foreign key linking to outage.planned_outage_window. Business justification: Interruptible tariff customers have contractual notification requirements and bill credit terms for planned interruptions. Business process: Coordinating planned maintenance outages with interruptible',
  `premise_id` BIGINT COMMENT 'Reference to the service premise where the interruptible load is located. Identifies the physical location subject to load curtailment.',
  `agreement_number` STRING COMMENT 'Externally-visible unique business identifier for the interruptible tariff agreement. Used in customer communications, billing statements, and regulatory filings.',
  `agreement_type` STRING COMMENT 'Classification of the interruptible service agreement based on firmness and curtailment conditions. Determines the priority and conditions under which load may be interrupted. Valid values: firm_interruptible|non_firm_interruptible|curtailable|emergency_interruptible.',
  `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether the agreement automatically renews at expiration unless either party provides notice of termination. True for evergreen agreements, false for fixed-term agreements.',
  `baseline_calculation_method` STRING COMMENT 'The methodology used to calculate the customer\'s baseline load for measurement and verification (M&V) of curtailment performance. Determines how actual load reduction is measured against expected load. Valid values: high_10_of_last_10|average_of_similar_days|customer_baseline_load|iso_rto_standard.',
  `bill_credit_rate_per_kw` DECIMAL(12,4) COMMENT 'The monthly bill credit rate in dollars per kilowatt ($/kW) that the customer receives for enrolling contracted interruptible capacity. Compensates the customer for maintaining load curtailment capability.',
  `compliance_status` STRING COMMENT 'Current compliance status of the customer with respect to their interruptible tariff obligations. Reflects whether the customer has successfully curtailed load during recent dispatch events. Valid values: compliant|non_compliant|under_review|not_tested.',
  `contracted_interruptible_load_kw` DECIMAL(15,3) COMMENT 'The committed load capacity in kilowatts (kW) that the customer agrees to curtail upon utility request. This is the baseline interruptible capacity used for billing credits and compliance measurement.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this interruptible tariff agreement record was first created in the system. Establishes the record creation audit trail.',
  `dispatch_priority_level` INT COMMENT 'Numeric priority ranking for dispatching this interruptible load resource relative to other demand response resources. Lower numbers indicate higher priority for dispatch.',
  `effective_date` DATE COMMENT 'Date when the interruptible tariff agreement becomes binding and the utility gains the contractual right to curtail load. Marks the start of the agreement term.',
  `expiration_date` DATE COMMENT 'Date when the interruptible tariff agreement expires and the utility no longer has the right to curtail load under this agreement. Nullable for evergreen agreements subject to annual renewal.',
  `interruptible_tariff_agreement_status` STRING COMMENT 'Current lifecycle status of the interruptible tariff agreement. Indicates whether the agreement is currently in force and eligible for dispatch. Valid values: active|suspended|expired|terminated|pending_activation.',
  `interruption_notice_period_minutes` INT COMMENT 'Minimum advance notice time in minutes that the utility must provide before initiating a load curtailment event. Defines the customer\'s preparation window.',
  `iso_rto_enrollment_flag` BOOLEAN COMMENT 'Indicates whether this interruptible load capacity is enrolled in an ISO (Independent System Operator) or RTO (Regional Transmission Organization) wholesale demand response program. True if enrolled in wholesale market programs.',
  `iso_rto_resource_code` STRING COMMENT 'The unique resource identifier assigned by the ISO (Independent System Operator) or RTO (Regional Transmission Organization) for this interruptible load in wholesale market programs. Nullable if not enrolled in ISO/RTO programs.',
  `last_compliance_test_date` DATE COMMENT 'Date of the most recent compliance test or actual curtailment event used to verify the customer\'s ability to meet their contracted interruptible load obligation.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this interruptible tariff agreement record. Used for audit trail and change tracking.',
  `maximum_annual_interruption_hours` DECIMAL(8,2) COMMENT 'The maximum total number of hours per year that the utility may interrupt service under this agreement. Protects the customer from excessive curtailment and defines the upper bound of utility dispatch rights.',
  `maximum_curtailment_duration_hours` DECIMAL(6,2) COMMENT 'The maximum duration in hours for a single load curtailment event. Protects the customer from excessively long interruptions.',
  `maximum_events_per_year` INT COMMENT 'The maximum number of discrete curtailment events that the utility may dispatch in a calendar year under this agreement. Limits the frequency of customer disruption.',
  `minimum_curtailment_duration_minutes` INT COMMENT 'The minimum duration in minutes for which a load curtailment event must be sustained once initiated. Ensures operational effectiveness of demand response dispatch.',
  `non_compliance_penalty_rate_per_kw` DECIMAL(12,4) COMMENT 'The penalty rate in dollars per kilowatt ($/kW) assessed when the customer fails to curtail the contracted load during a dispatch event. Enforces contractual compliance.',
  `notes` STRING COMMENT 'Free-form text field for capturing additional terms, conditions, special provisions, or operational notes related to this interruptible tariff agreement.',
  `signed_date` DATE COMMENT 'Date when the interruptible tariff agreement was executed by both the utility and the customer. Establishes the legal binding date of the contract.',
  `tariff_agreement_to_enrollment` BIGINT COMMENT 'FK to demand.dr_enrollment.dr_enrollment_id — Interruptible tariff agreements formalize the enrollment of large C&I customers. Required to link contractual obligations to program participation.',
  `tariff_schedule_code` STRING COMMENT 'Code identifying the specific interruptible service tariff schedule under which this agreement operates. References the PUC (Public Utility Commission) approved rate schedule.',
  `termination_notice_days` INT COMMENT 'Number of days advance notice required by either party to terminate the agreement. Defines the notice period for voluntary termination.',
  `to_dr_enrollment` BIGINT COMMENT 'FK to demand.dr_enrollment.dr_enrollment_id — Interruptible tariff agreements are linked to specific DR enrollments for the customer. Required for tariff compliance tracking.',
  `year_to_date_event_count` INT COMMENT 'Cumulative count of discrete curtailment events dispatched under this agreement in the current calendar year. Tracked against the maximum events per year limit.',
  `year_to_date_interruption_hours` DECIMAL(8,2) COMMENT 'Cumulative total hours of load interruption dispatched under this agreement in the current calendar year. Tracked against the maximum annual interruption hours limit.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_demand_interruptible_tariff_agreement` PRIMARY KEY (`interruptible_tariff_agreement_id`)
)
USING DELTA
COMMENT 'Master record for interruptible service tariff agreements between the utility and large commercial/industrial customers, capturing tariff schedule reference, contracted interruptible load (kW), maximum annual interruption hours, interruption notice period, bill credit rate ($/kW), penalty for non-compliance, agreement effective and expiration dates, and current compliance status. SSOT for interruptible tariff obligations and load curtailment rights. | CMM: CIM CustomerAgreement (close), IEC61968::Customers.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'InterruptibleTariffAgreement',
  'cmm.cim.class' = 'CustomerAgreement',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Customers',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.demand.interruptible_tariff_agreement'
);

-- DirectLoadControlDevice  <<CIM EndDevice : close>>
CREATE TABLE IF NOT EXISTS `demand`.`direct_load_control_device` (
  `direct_load_control_device_id` BIGINT NOT NULL COMMENT 'Unique identifier for the direct load control device. Primary key for the DLC device master record.',
  `account_id` BIGINT COMMENT 'Identifier of the customer at whose premise the DLC device is installed. Links the device to customer account for billing, enrollment, and service management.',
  `aggregator_id` BIGINT COMMENT 'Identifier of the third-party demand response aggregator managing this device, if applicable. Used for settlement, performance reporting, and multi-party DR programs.',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_system. Business justification: Direct load control devices control specific DER systems for demand response events. Device commissioning requires DER system interconnection approval and IEEE 1547 protection settings. Control strate',
  `distribution_transformer_id` BIGINT COMMENT 'Foreign key linking to distribution.transformer. Business justification: DLC devices control loads served by specific distribution transformers; transformer capacity, loading, and thermal limits are critical for DLC program design, dispatch constraints, and avoiding overlo',
  `dr_program_id` BIGINT COMMENT 'Identifier of the demand response program under which this device is enrolled. Determines control rules, incentive rates, and event dispatch eligibility.',
  `employee_id` BIGINT COMMENT 'Identifier of the field technician who installed the device. Used for quality assurance, installation defect tracking, and technician performance evaluation.',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: DLC devices are deployed and controlled by geographic zone for targeted load management during peak periods. Zone-level control enables localized demand reduction for distribution constraint managemen',
  `last_caused_interruption_id` BIGINT COMMENT 'Foreign key linking to outage.interruption. Business justification: DLC device activations can cause momentary or sustained interruptions when switching loads. Business process: Tracking device-induced interruptions for reliability reporting, distinguishing programmat',
  `material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: DLC devices are physical inventory items with part numbers, specifications, procurement requirements. Business process: spare parts management, warranty tracking, procurement planning, inventory valua',
  `meter_id` BIGINT COMMENT 'Identifier of the electric meter serving the premise where the DLC device is installed. Used for baseline calculation and measurement and verification of load curtailment.',
  `nerc_cip_asset_id` BIGINT COMMENT 'Foreign key linking to compliance.nerc_cip_asset. Business justification: DLC devices controlling critical loads (substations, generation) are NERC CIP assets requiring cyber security controls per CIP-005, CIP-007. Essential for CIP compliance, cyber security asset inventor',
  `premise_id` BIGINT COMMENT 'Identifier of the physical premise where the DLC device is installed. Used for geographic analysis, outage correlation, and multi-device premise management.',
  `registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: DLC devices are utility-owned physical assets requiring lifecycle management: depreciation tracking, maintenance scheduling, warranty management, capital cost allocation to rate base. Asset registry i',
  `storage_warehouse_id` BIGINT COMMENT 'Foreign key linking to supply.warehouse. Business justification: DLC devices are stored in warehouses before field installation. Business process: inventory management, deployment logistics, stock level monitoring, installation crew dispatch planning, emergency rep',
  `vendor_id` BIGINT COMMENT 'Foreign key linking to supply.vendor. Business justification: DLC devices are procured from vendors requiring vendor management. Business process: warranty claims processing, maintenance contract administration, procurement sourcing, vendor performance evaluatio',
  `average_curtailment_kw` DECIMAL(10,3) COMMENT 'Average measured load reduction in kilowatts achieved by this device during DR events. Calculated from baseline and actual load measurements for M&V reporting.',
  `baseline_calculation_method` STRING COMMENT 'Algorithm used to calculate the customer baseline load for this device. Determines how curtailment is measured and verified for incentive payments.',
  `communication_protocol` STRING COMMENT 'Primary communication protocol used by the DLC device to receive control signals and report status. Determines network infrastructure requirements and latency characteristics. Valid values: zigbee|wifi|cellular|rf_mesh|ami_network|openadr.',
  `control_strategy` STRING COMMENT 'The control algorithm applied to this device during DR events. Defines how the device modulates load to achieve curtailment while minimizing customer comfort impact. Valid values: cycling|duty_cycle|temperature_offset|load_shed|charge_delay|discharge_control.',
  `controlled_load_type` STRING COMMENT 'Type of electrical load that the DLC device controls. Used for load forecasting, curtailment planning, and customer comfort impact assessment. Reference-value candidates: hvac_cooling|hvac_heating|water_heater|ev_charger|pool_pump|battery_storage|general_appliance.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this DLC device record was first created in the system. Used for data lineage and audit trail purposes.',
  `decommission_date` DATE COMMENT 'Date when the DLC device was permanently removed from service. Used for asset lifecycle tracking and program capacity reporting.',
  `decommission_reason` STRING COMMENT 'Explanation for why the device was decommissioned. Used for failure analysis, vendor performance evaluation, and program improvement.',
  `device_ownership` STRING COMMENT 'Indicates who owns the physical DLC device. Determines maintenance responsibility, asset capitalization, and end-of-life disposition. Valid values: utility_owned|customer_owned|third_party_owned.',
  `device_serial_number` STRING COMMENT 'Manufacturer-assigned unique serial number for the DLC device. Used for warranty tracking, field service identification, and device authentication.',
  `device_to_enrollment` BIGINT COMMENT 'FK to demand.dr_enrollment.dr_enrollment_id — DLC devices are installed at enrolled customer premises. Required to dispatch the correct devices during events and track device-level performance.',
  `dlc_device_to_enrollment` BIGINT COMMENT 'FK to demand.dr_enrollment.dr_enrollment_id — DLC devices are installed at enrolled customer premises. This FK links the device to the enrollment for dispatch targeting and performance tracking.',
  `enrollment_date` DATE COMMENT 'Date when the device was enrolled in the current DR program. Used for program participation tracking and incentive eligibility determination.',
  `enrollment_status` STRING COMMENT 'Current enrollment status of the device in the DR program. Determines whether the device can be dispatched during DR events and is eligible for incentive payments. Valid values: enrolled|pending|opted_out|suspended|terminated.',
  `firmware_version` STRING COMMENT 'Current firmware version installed on the DLC device. Critical for security patch management, feature availability, and protocol compatibility.',
  `installation_date` DATE COMMENT 'Date when the DLC device was physically installed at the customer premise. Used for warranty period calculation and device lifecycle tracking.',
  `iso_rto_resource_code` STRING COMMENT 'Resource identifier assigned by the ISO/RTO for wholesale market participation. Used for market settlement and capacity credit tracking.',
  `last_communication_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent successful communication between the DLC device and the utility control system. Used for device health monitoring and connectivity issue detection.',
  `last_control_event_timestamp` TIMESTAMP COMMENT 'Timestamp when the device last responded to a DR control signal. Used for performance verification and device responsiveness tracking.',
  `last_maintenance_date` DATE COMMENT 'Date of the most recent maintenance or service activity performed on the device. Used for preventive maintenance scheduling and device reliability tracking.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this DLC device record was most recently modified. Used for change tracking and data synchronization across systems.',
  `max_curtailment_duration_minutes` INT COMMENT 'Maximum number of consecutive minutes the device can be curtailed during a single DR event. Enforces customer comfort limits and program rules.',
  `network_address` STRING COMMENT 'IP address, MAC address, or protocol-specific network identifier for the DLC device. Used for device provisioning, network troubleshooting, and security monitoring.',
  `next_scheduled_maintenance_date` DATE COMMENT 'Date when the next preventive maintenance activity is scheduled for the device. Used for field service planning and resource allocation.',
  `operational_status` STRING COMMENT 'Current operational state of the DLC device. Determines whether the device is available for DR event dispatch and eligible for incentive payments. Valid values: active|inactive|suspended|maintenance|decommissioned|failed.',
  `opt_out_allowed_flag` BOOLEAN COMMENT 'Indicates whether the customer is permitted to opt out of individual DR events. Determines event dispatch logic and customer notification requirements.',
  `opt_out_count_ytd` INT COMMENT 'Number of times the customer has opted out of DR events in the current calendar year. Used to enforce program opt-out limits and track customer engagement.',
  `rated_load_kw` DECIMAL(10,3) COMMENT 'Nameplate rated power consumption of the controlled load in kilowatts. Used for calculating total enrolled capacity and expected curtailment during DR events.',
  `security_certificate_expiration_date` DATE COMMENT 'Expiration date of the digital security certificate used for encrypted communication. Critical for maintaining secure command and control of DLC devices.',
  `telemetry_interval_seconds` INT COMMENT 'Frequency in seconds at which the device reports status and operational data. Determines data granularity for M&V and real-time monitoring.',
  `to_dr_enrollment` BIGINT COMMENT 'FK to demand.dr_enrollment.dr_enrollment_id — DLC devices are installed at customer premises under a specific DR enrollment. Required for device-to-program mapping during event dispatch.',
  `total_curtailment_hours_ytd` DECIMAL(10,2) COMMENT 'Cumulative hours of load curtailment delivered by this device in the current calendar year. Used for incentive calculation and program impact reporting.',
  `total_events_dispatched_ytd` INT COMMENT 'Total number of DR events this device has been dispatched for in the current calendar year. Used for program performance reporting and customer communication.',
  `warranty_expiration_date` DATE COMMENT 'Date when the manufacturer warranty for the DLC device expires. Used for maintenance planning and replacement cost forecasting.',
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
  CONSTRAINT `pk_demand_direct_load_control_device` PRIMARY KEY (`direct_load_control_device_id`)
)
USING DELTA
COMMENT 'Master record for utility-owned or utility-managed direct load control (DLC) devices installed at customer premises, including smart thermostats, load control switches, water heater controllers, and EV charger controllers. Captures device type, manufacturer, firmware version, installation date, controlled load type (HVAC, water heater, EV), rated load (kW), communication protocol (AMI, RF, cellular), operational status, and last communication timestamp. | CMM: CIM EndDevice (close), IEC61968::Metering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DirectLoadControlDevice',
  'cmm.cim.class' = 'EndDevice',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Metering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-9',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.demand.direct_load_control_device',
  'cmm.gis.location.role' = 'Asset.Location'
);

-- VppDispatch  <<CIM DERGroupDispatch : close>>
CREATE TABLE IF NOT EXISTS `demand`.`vpp_dispatch` (
  `vpp_dispatch_id` BIGINT NOT NULL COMMENT 'Unique identifier for the VPP dispatch instruction. Primary key for the VPP dispatch transaction.',
  `aggregator_id` BIGINT COMMENT 'Reference to the third-party aggregator or utility entity managing the VPP portfolio and coordinating DER dispatch.',
  `audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: VPP dispatch operations are audited for market participation compliance and anti-manipulation rules (FERC market behavior surveillance). Required for market behavior audit trail, dispatch compliance v',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: VPP dispatches provide regulation reserves and frequency response within specific control areas. Link required for AGC signal coordination, ACE management, and balancing authority settlement. Control',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: VPP dispatch operations incur costs (DERMS platform, settlement processing, telemetry) that must be allocated to cost centers. Settlement_amount represents expense requiring cost center assignment for',
  `der_interconnection_point_id` BIGINT COMMENT 'Foreign key linking to distribution.der_interconnection_point. Business justification: VPP dispatch commands target specific DER interconnection points for real-time control, telemetry validation, and settlement. Critical for DERMS operations, IEEE 1547 compliance, and market participat',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_system. Business justification: VPP dispatch commands target specific DER systems for aggregated response. DERMS integration requires system-level interconnection specifications, telemetry configuration, and communication protocol d',
  `dispatch_operator_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: VPP dispatches are executed by control room operators (employees) who coordinate distributed energy resources in real-time for grid services. Dispatch_operator is text field denormalizing employee dat',
  `dispatch_schedule_id` BIGINT COMMENT 'Foreign key linking to generation.dispatch_schedule. Business justification: Virtual power plant dispatches are coordinated with generation dispatch schedules by ISO/RTO for integrated grid balancing. Operators track both supply-side and demand-side dispatch instructions for r',
  `dr_capacity_registration_id` BIGINT COMMENT 'FK to demand.dr_capacity_registration.dr_capacity_registration_id — VPP dispatches target registered DER portfolios. This FK links the dispatch instruction to the capacity registration for performance tracking and settlement.',
  `energy_price_id` BIGINT COMMENT 'Foreign key linking to forecast.energy_price. Business justification: VPP dispatch optimization uses energy price forecasts to maximize revenue and minimize costs in wholesale markets. Essential for economic dispatch decisions, market bidding strategies, and real-time d',
  `forecast_generation_id` BIGINT COMMENT 'Foreign key linking to forecast.forecast_generation. Business justification: VPP dispatch coordinates with generation forecasts (especially renewable DERs) to balance supply-demand and optimize bidding. Critical for VPP portfolio optimization, renewable integration, and ancill',
  `load_id` BIGINT COMMENT 'Foreign key linking to forecast.load. Business justification: VPP dispatch decisions require real-time and short-term load forecasts to optimize DER dispatch and market participation. Essential for economic dispatch, grid services provision, and wholesale market',
  `registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: VPP dispatch targets specific distribution assets (substations, feeders, transformers) for locational demand response to defer capital upgrades, manage thermal constraints, and provide voltage support',
  `to_dr_event_id` BIGINT COMMENT 'FK to demand.dr_event.dr_event_id — VPP dispatches may be coordinated with or triggered by DR events. This FK enables correlation of VPP grid service dispatches with DR event lifecycle.',
  `transmission_substation_id` BIGINT COMMENT 'Foreign key linking to transmission.transmission_substation. Business justification: VPP dispatches address transmission substation constraints by reducing load in specific service territories. Grid operators coordinate VPP dispatch with transmission operations to manage substation th',
  `vpp_configuration_id` BIGINT COMMENT 'Reference to the aggregated portfolio of Distributed Energy Resources (DERs) that received this dispatch instruction.',
  `vpp_dr_event_id` BIGINT COMMENT 'FK to demand.dr_event.dr_event_id — VPP dispatches occur in the context of DR events or market signals. Required to correlate VPP actions with overall DR event management.',
  `acknowledgement_timestamp` TIMESTAMP COMMENT 'Date and time when the aggregator or DERMS platform acknowledged receipt of the VPP dispatch instruction. Used to track communication latency and dispatch readiness.',
  `actual_mw` DECIMAL(10,3) COMMENT 'Actual measured power response in megawatts (MW) delivered by the VPP portfolio during the dispatch period. Used for measurement and verification (M&V) and settlement calculations.',
  `baseline_mw` DECIMAL(10,3) COMMENT 'Calculated baseline power level in megawatts (MW) representing what the VPP portfolio would have consumed or generated without the dispatch instruction. Used for measurement and verification (M&V) to calculate actual response.',
  `bidirectional_flag` BOOLEAN COMMENT 'Indicates whether the VPP dispatch instruction utilized bidirectional DER capabilities (both charging and discharging). True for dispatches involving energy storage or vehicle-to-grid (V2G) resources; false for unidirectional load curtailment.',
  `cancellation_reason` STRING COMMENT 'Explanation for why the VPP dispatch instruction was cancelled. Examples include grid condition change, market price change, or operational constraint. Null if the dispatch was not cancelled.',
  `cancellation_timestamp` TIMESTAMP COMMENT 'Date and time when the VPP dispatch instruction was cancelled before completion. Null if the dispatch was not cancelled.',
  `completion_timestamp` TIMESTAMP COMMENT 'Date and time when the VPP dispatch instruction was completed and DER resources returned to normal operation. Marks the end of the dispatch lifecycle.',
  `compliance_flag` BOOLEAN COMMENT 'Indicates whether the VPP dispatch met the minimum performance requirements for the contracted service type. True if performance ratio exceeded the compliance threshold; false otherwise. Used for capacity accreditation and penalty assessment.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this VPP dispatch record was first created in the system. Used for audit trail and data lineage tracking.',
  `der_count` INT COMMENT 'Number of individual DER assets (batteries, electric vehicles, smart inverters, controllable loads) that participated in this VPP dispatch instruction.',
  `der_response_rate` DECIMAL(5,4) COMMENT 'Percentage of DER assets in the VPP portfolio that successfully responded to the dispatch instruction, expressed as a decimal (e.g., 0.92 for 92% response rate). Used to assess portfolio reliability.',
  `derms_integration_reference` STRING COMMENT 'External reference identifier linking this VPP dispatch to the corresponding instruction or transaction in the Distributed Energy Resource Management System (DERMS). Enables traceability between utility dispatch systems and DER control platforms.',
  `dispatch_duration_minutes` INT COMMENT 'Total duration of the VPP dispatch instruction in minutes. Calculated as the difference between dispatch end time and dispatch start time.',
  `dispatch_end_time` TIMESTAMP COMMENT 'Scheduled date and time when the VPP dispatch instruction expires and DER resources should return to normal operation.',
  `dispatch_number` STRING COMMENT 'Business identifier for the VPP dispatch instruction, formatted as VPP- followed by 10 digits. Used for external communication with ISO/RTO and aggregators. Pattern: ^VPP-[0-9]{10}$.',
  `dispatch_priority` STRING COMMENT 'Priority level of the VPP dispatch instruction. Emergency dispatches override normal operations; high priority dispatches support critical grid conditions; normal and low priority dispatches support economic optimization. Valid values: emergency|high|normal|low.',
  `dispatch_reason` STRING COMMENT 'Business justification or operational reason for issuing the VPP dispatch instruction. Examples include peak demand management, renewable integration, frequency response, voltage support, or market arbitrage.',
  `dispatch_source` STRING COMMENT 'Originating system or entity that initiated the VPP dispatch instruction. Distinguishes between utility Energy Management System (EMS), ISO/RTO market dispatch, aggregator platform, Distributed Energy Resource Management System (DERMS), or manual operator dispatch. Valid values: utility_ems|iso_rto|aggregator_platform|derms|manual.',
  `dispatch_start_time` TIMESTAMP COMMENT 'Scheduled date and time when the VPP dispatch instruction becomes effective and DER resources should begin responding.',
  `dispatch_status` STRING COMMENT 'Current lifecycle status of the VPP dispatch instruction. Tracks progression from issuance through execution to completion or cancellation. Reference-value candidates: pending|issued|acknowledged|active|completed|cancelled|failed.',
  `dispatch_timestamp` TIMESTAMP COMMENT 'Date and time when the VPP dispatch instruction was issued to the aggregated DER portfolio. Represents the principal business event time for this transaction.',
  `iso_rto_code` STRING COMMENT 'Code identifying the ISO or RTO market region where the VPP dispatch is being executed. Examples include CAISO, ERCOT, MISO, PJM, NYISO, ISO-NE, and SPP. Reference-value candidates: CAISO|ERCOT|MISO|PJM|NYISO|ISO-NE|SPP.',
  `lmp_energy_price` DECIMAL(10,4) COMMENT 'Locational Marginal Price for energy at the pricing node during the dispatch interval, expressed in dollars per megawatt-hour ($/MWh). Used for settlement and revenue calculation.',
  `market_product` STRING COMMENT 'Specific wholesale market product or ancillary service that the VPP dispatch is fulfilling. Examples include Day-Ahead Market (DAM) energy, Real-Time Market (RTM) energy, regulation up/down, or operating reserves. Maps to ISO/RTO product definitions.',
  `notes` STRING COMMENT 'Free-text field for operational notes, special instructions, or contextual information about the VPP dispatch. Used to capture non-standard conditions or operator observations.',
  `performance_ratio` DECIMAL(5,4) COMMENT 'Ratio of actual MW response to target MW dispatch, expressed as a decimal (e.g., 0.95 for 95% performance). Used to assess VPP portfolio compliance and reliability for capacity accreditation.',
  `pricing_node` STRING COMMENT 'Locational Marginal Price (LMP) node or pricing point where the VPP portfolio is registered and settled in the wholesale market. Used for financial settlement and locational value calculation.',
  `ramp_rate_mw_per_min` DECIMAL(8,3) COMMENT 'Required rate of change in power output in megawatts per minute (MW/min). Specifies how quickly the VPP portfolio must transition from current state to target dispatch level.',
  `service_type` STRING COMMENT 'Type of grid service requested from the VPP portfolio. Includes energy arbitrage, capacity provision, frequency regulation, spinning reserve, non-spinning reserve, and voltage support. Determines the operational mode and response requirements for the DER fleet. Valid values: energy|capacity|frequency_regulation|spinning_reserve|non_spinning_reserve|voltage_support.',
  `settlement_amount` DECIMAL(12,2) COMMENT 'Total financial settlement amount in dollars for the VPP dispatch performance. Calculated based on actual MW response, LMP energy price, and applicable market product rates. Used for aggregator and customer incentive payments.',
  `settlement_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for the settlement amount. Typically USD for North American energy markets. Valid values: USD.',
  `settlement_interval` STRING COMMENT 'Time granularity for measuring and settling the VPP dispatch performance. Aligns with ISO/RTO market settlement intervals (typically 5-minute, 15-minute, or hourly). Valid values: 5min|15min|hourly.',
  `target_mw` DECIMAL(10,3) COMMENT 'Target power output or curtailment in megawatts (MW) requested from the VPP portfolio. Positive values indicate generation or discharge; negative values indicate load reduction or charging.',
  `telemetry_interval_seconds` INT COMMENT 'Frequency in seconds at which real-time telemetry data was collected from the VPP portfolio during the dispatch. Typical values range from 1 to 60 seconds depending on service type and ISO/RTO requirements.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this VPP dispatch record was last modified. Used for audit trail and change tracking.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_demand_vpp_dispatch` PRIMARY KEY (`vpp_dispatch_id`)
)
USING DELTA
COMMENT 'Transactional record of a Virtual Power Plant (VPP) dispatch instruction issued to an aggregated portfolio of DERs (batteries, EVs, smart inverters, controllable loads) to provide grid services beyond traditional DR curtailment. Captures dispatch timestamp, service type (energy, capacity, frequency regulation, spinning reserve, voltage support), target MW, ramp rate, dispatch duration, ISO/RTO market product, settlement interval, actual response (MW), DERMS integration reference, and dispatch source (utility, ISO/RTO, aggregator). Distinct from standard DR events as VPP dispatches coordinate bidirectional DER resources for wholesale market products and ancillary services. | CMM: CIM DERGroupDispatch (close), IEC61968::DER.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'VppDispatch',
  'cmm.cim.class' = 'DERGroupDispatch',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::DER',
  'cmm.cim.standard' = 'IEC 61968-5',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.demand.vpp_dispatch'
);

-- DrCapacityRegistration  <<CIM RegisteredLoad : close>>
CREATE TABLE IF NOT EXISTS `demand`.`dr_capacity_registration` (
  `dr_capacity_registration_id` BIGINT NOT NULL COMMENT 'Unique identifier for the DR capacity registration record. Primary key for this entity.',
  `account_id` BIGINT COMMENT 'Identifier of the individual customer for single-customer registrations. Null for aggregator portfolios or VPP resource pools.',
  `aggregator_id` BIGINT COMMENT 'FK to demand.aggregator.aggregator_id — Aggregator portfolios register capacity with ISO/RTOs. After merging aggregator_portfolio into dr_capacity_registration, the aggregator FK is essential.',
  `approved_by_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Capacity registrations require management approval before ISO/RTO submission due to financial obligations and performance penalties. Approved_by is text field. Essential for internal controls, authori',
  `capacity_requirement_id` BIGINT COMMENT 'Foreign key linking to forecast.capacity_requirement. Business justification: DR capacity registrations must align with ISO/RTO capacity requirements for resource adequacy planning. Registrations are validated against capacity requirements to ensure sufficient installed capacit',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Capacity registrations have administrative costs (ISO/RTO fees, compliance testing, certification) and generate revenue (annual_capacity_payment_usd) that must be tracked by cost center for budget man',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_system. Business justification: Capacity registration portfolio composition requires DER system technical specifications from interconnection approval. Performance testing uses interconnection-approved nameplate capacity and inverte',
  `dr_aggregator_id` BIGINT COMMENT 'Identifier of the curtailment service provider or aggregator managing this DR capacity portfolio. Null for utility-managed or individual customer registrations.',
  `dr_capacity_registration_to_aggregator` BIGINT COMMENT 'FK to demand.aggregator.aggregator_id — Many capacity registrations are submitted by aggregators. This FK links the registration to the aggregator entity for portfolio management and FERC Order 2222 compliance.',
  `dr_capacity_registration_to_program` BIGINT COMMENT 'FK to demand.dr_program.dr_program_id — Capacity registrations are made under specific DR programs for ISO/RTO market participation. This FK links the registered capacity to the program for reporting and settlement.',
  `dr_program_id` BIGINT COMMENT 'FK to demand.dr_program.dr_program_id — Capacity is registered under specific DR programs for ISO/RTO markets. Required for program-level capacity reporting.',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Capacity registrations are zone-specific for local capacity requirements and transmission constraint management. Zone assignment is required for ISO/RTO capacity market participation, zonal capacity a',
  `interconnection_application_id` BIGINT COMMENT 'Foreign key linking to interconnection.application. Business justification: ISO/RTO capacity market registration requires proof of interconnection approval for DER resources. Registered capacity cannot exceed interconnection-approved export capacity. Certification and complia',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Capacity registrations must comply with ISO/RTO market rules and FERC Order 719 demand response obligations. Essential for capacity market compliance, registration validation, and ensuring DR resource',
  `premise_id` BIGINT COMMENT 'Identifier of the service premise for single-premise registrations. Null for multi-premise portfolios.',
  `primary_dr_program_id` BIGINT COMMENT 'Identifier of the utility DR program under which this capacity is enrolled. Links to retail program structure and incentive rules.',
  `to_aggregator_id` BIGINT COMMENT 'FK to demand.aggregator.aggregator_id — Aggregator portfolio registrations must reference the aggregator entity. Required for aggregator performance tracking and settlement.',
  `to_dr_program_id` BIGINT COMMENT 'FK to demand.dr_program.dr_program_id — Capacity registrations are made under specific DR programs for ISO/RTO market participation. Required for capacity reporting.',
  `annual_capacity_payment_usd` DECIMAL(15,2) COMMENT 'Total annual capacity payment in USD for this registration, calculated as registered_capacity_mw × capacity_payment_rate_per_mw_day × days_in_season. Used for revenue forecasting and financial reporting.',
  `approval_timestamp` TIMESTAMP COMMENT 'Timestamp when this registration was approved by the ISO/RTO or utility. Marks the transition to certified status.',
  `baseline_methodology` STRING COMMENT 'The ISO/RTO-approved baseline methodology used for measuring demand reduction performance (e.g., High 5 of 10, Mid 8 of 10, Regression-based). Determines how capacity performance is calculated during events.',
  `capacity_obligation_mw` DECIMAL(12,3) COMMENT 'The firm capacity obligation in megawatts (MW) that must be delivered during performance assessment hours. May differ from registered capacity due to derating factors or performance adjustments.',
  `capacity_payment_rate_per_mw_day` DECIMAL(12,2) COMMENT 'The capacity payment rate in dollars per megawatt per day ($/MW-day) for this registration, as determined by the ISO/RTO capacity auction clearing price for the zone and season.',
  `capacity_season` STRING COMMENT 'The capacity delivery year or season for which this registration is effective (e.g., 2024/2025, Summer 2024). Aligns with ISO/RTO capacity auction and delivery periods.',
  `certification_date` DATE COMMENT 'Date on which the DR capacity registration was certified by the ISO/RTO as meeting all technical, metering, and performance requirements.',
  `certification_status` STRING COMMENT 'Current certification status of the DR capacity registration with the ISO/RTO. Certified status is required for capacity payments and market participation. Valid values: pending|certified|provisional|suspended|revoked|expired.',
  `compliance_test_date` DATE COMMENT 'Date of the most recent ISO/RTO compliance test or capacity performance verification test for this registration.',
  `compliance_test_result_mw` DECIMAL(12,3) COMMENT 'Measured demand reduction in megawatts (MW) achieved during the most recent compliance test. Used to validate registered capacity and adjust capacity credits.',
  `compliance_test_status` STRING COMMENT 'Outcome status of the most recent compliance test. Failed tests may result in capacity derating or registration suspension. Valid values: passed|failed|pending|waived|not_required.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this registration record was first created in the system. Used for audit trail and data lineage tracking.',
  `iso_rto_market` STRING COMMENT 'The ISO/RTO market in which this DR capacity is registered. Determines market rules, capacity auction structure, and performance obligations. Reference-value candidates: PJM|NYISO|ISO-NE|CAISO|MISO|SPP|ERCOT.',
  `iso_rto_registration_number` STRING COMMENT 'External registration identifier assigned by the ISO/RTO capacity market for this DR resource or portfolio. This is the business identifier used in wholesale market communications and settlements.',
  `last_modified_by` STRING COMMENT 'Username or identifier of the user who last modified this registration record. Used for audit trail and accountability.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this registration record was last modified. Used for change tracking and audit trail.',
  `notes` STRING COMMENT 'Free-text notes capturing special conditions, exceptions, or operational details related to this DR capacity registration. Used for operational coordination and issue tracking.',
  `performance_penalty_rate_per_mwh` DECIMAL(12,2) COMMENT 'Penalty rate in dollars per megawatt-hour ($/MWh) applied for non-performance during ISO/RTO performance assessment hours. Varies by market and performance tier.',
  `performance_tier` STRING COMMENT 'Performance classification tier assigned by the ISO/RTO based on historical performance, resource type, and telemetry capabilities (e.g., Tier 1, Tier 2, Emergency-Only). Affects capacity credit and payment rates.',
  `portfolio_composition_json` STRING COMMENT 'JSON structure containing detailed composition of the DR portfolio, including individual customer IDs, premise IDs, meter IDs, resource types, and individual capacity contributions. Used for portfolio management and settlement allocation.',
  `portfolio_name` STRING COMMENT 'Business name or designation for the DR capacity portfolio. May represent an aggregator portfolio, utility program portfolio, or Virtual Power Plant (VPP) resource pool.',
  `puc_reporting_flag` BOOLEAN COMMENT 'Indicates whether this registration must be included in state Public Utility Commission (PUC) demand response program reporting and Renewable Portfolio Standard (RPS) compliance filings.',
  `registered_capacity_mw` DECIMAL(12,3) COMMENT 'Total registered demand response capacity in megawatts (MW) committed to the ISO/RTO capacity market. This is the capacity obligation that must be available during performance periods.',
  `registration_effective_date` DATE COMMENT 'Date on which this DR capacity registration becomes effective and capacity obligations begin. Typically aligns with the start of the capacity delivery season.',
  `registration_expiration_date` DATE COMMENT 'Date on which this DR capacity registration expires and capacity obligations end. Typically aligns with the end of the capacity delivery season.',
  `registration_status` STRING COMMENT 'Current lifecycle status of the DR capacity registration. Active status is required for capacity payments and dispatch eligibility. Valid values: active|inactive|pending_approval|suspended|withdrawn|expired.',
  `registration_type` STRING COMMENT 'Classification of the DR capacity registration structure. Determines reporting obligations, settlement processes, and performance measurement methodologies. Valid values: individual_customer|aggregator_portfolio|vpp_resource_pool|utility_program.',
  `resource_type_mix` STRING COMMENT 'Comma-separated list or JSON structure describing the mix of resource types in this registration (e.g., load_curtailment, battery_storage, solar_der, ev_charging, chp). Captures the composition of the portfolio for capacity credit calculations.',
  `submission_timestamp` TIMESTAMP COMMENT 'Timestamp when this registration was submitted to the ISO/RTO capacity market. Used for tracking registration timelines and auction participation.',
  `submitted_by` STRING COMMENT 'Username or identifier of the user who submitted this registration to the ISO/RTO. Used for audit trail and accountability.',
  `telemetry_interval_seconds` INT COMMENT 'Required telemetry reporting interval in seconds (e.g., 4, 10, 60) for real-time performance monitoring. Null if telemetry is not required.',
  `telemetry_required_flag` BOOLEAN COMMENT 'Indicates whether real-time telemetry data submission to the ISO/RTO is required for this registration. Typically required for Tier 1 performance resources and VPP registrations.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_demand_dr_capacity_registration` PRIMARY KEY (`dr_capacity_registration_id`)
)
USING DELTA
COMMENT 'Master record of DR capacity registered with an ISO/RTO or utility capacity market, representing individual customer resources, aggregator portfolios, and VPP resource pools. Captures registration ID, ISO/RTO market, portfolio name, resource type mix (load curtailment, DER, battery, EV), capacity season, registered MW, geographic zone, performance tier and obligation, capacity payment rate ($/MW-day), compliance test results, certification status, registration effective date, portfolio composition details, and aggregator portfolio metadata (ISO/RTO registration ID, resource type mix, total registered capacity). SSOT for wholesale DR capacity positions, aggregator portfolio registrations, VPP resource pools, and ISO/RTO capacity reporting obligations. | CMM: CIM RegisteredLoad (close), IEC62325::MarketCommon.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DrCapacityRegistration',
  'cmm.cim.class' = 'RegisteredLoad',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC62325::MarketCommon',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.demand.dr_capacity_registration'
);

-- DrComplianceReport  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `demand`.`dr_compliance_report` (
  `dr_compliance_report_id` BIGINT NOT NULL COMMENT 'Unique identifier for the demand response compliance report record. Primary key.',
  `audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: Compliance reports are submitted as audit evidence and may trigger follow-up audits if performance thresholds are not met. Required for audit documentation, regulatory submission tracking, and linking',
  `capacity_requirement_id` BIGINT COMMENT 'Foreign key linking to forecast.capacity_requirement. Business justification: Compliance reports validate DR capacity against capacity requirements for resource adequacy assessments. Required for ISO/RTO capacity market compliance, NERC reliability standards, and state PUC reso',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Compliance reporting is a cost center activity with direct costs (auditor fees, M&V, staff time) and potential penalties (penalty_amount_usd). Cost center assignment enables budget tracking and regula',
  `dr_program_id` BIGINT COMMENT 'FK to demand.dr_program.dr_program_id — Compliance reports are filed per DR program. This FK links the regulatory filing to the program for audit trail and reporting obligation tracking.',
  `interconnection_application_id` BIGINT COMMENT 'Foreign key linking to interconnection.application. Business justification: Regulatory compliance reporting requires linking enrolled DR capacity to approved interconnection applications for audit trail. Submitted capacity verification validates against interconnection-approv',
  `irp_scenario_id` BIGINT COMMENT 'Foreign key linking to forecast.irp_scenario. Business justification: DR compliance reports feed into IRP scenarios as validated demand-side resource capacity for long-term planning. Actual DR performance data informs IRP assumptions on achievable demand response capaci',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Compliance reports document adherence to specific regulatory obligations (e.g., annual DR performance reporting to PUC, ISO/RTO compliance filings). Essential for regulatory reporting, obligation fulf',
  `primary_dr_program_id` BIGINT COMMENT 'Reference to the demand response program for which this compliance report is submitted.',
  `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: DR compliance reports are often submitted as regulatory filings to PUCs or FERC (e.g., annual DR program performance reports, RPS compliance filings). Essential for filing documentation, regulatory su',
  `submitted_by_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Compliance reports to PUCs and ISO/RTOs must be submitted by authorized utility employees with regulatory filing authority. Tracks accountability for regulatory submissions, audit trails, and attestat',
  `to_dr_program_id` BIGINT COMMENT 'FK to demand.dr_program.dr_program_id — Compliance reports are filed per program. This FK is required for regulatory reporting workflows.',
  `acceptance_timestamp` TIMESTAMP COMMENT 'Date and time when the regulatory body or ISO/RTO formally accepted this compliance report as complete and compliant.',
  `actual_events_called` INT COMMENT 'Actual number of demand response events dispatched or called during the reporting period, including both economic and emergency events.',
  `audit_timestamp` TIMESTAMP COMMENT 'Date and time when the compliance report was audited and validated for accuracy and completeness.',
  `auditor_name` STRING COMMENT 'Name of the third-party auditor or internal compliance officer who reviewed and validated this compliance report prior to submission.',
  `baseline_methodology` STRING COMMENT 'The baseline calculation methodology used for measurement and verification (M&V) in this compliance report (e.g., \'High 5 of 10\', \'High 4 of 5\', \'Meter Before/Meter After\', \'Regression-based\').',
  `compliance_status` STRING COMMENT 'Overall compliance determination for the reporting period. compliant = met all performance and reporting requirements; non_compliant = failed to meet minimum thresholds; conditional_compliance = compliant with conditions or waivers; under_investigation = compliance determination pending; penalty_assessed = non-compliance with financial penalties imposed. Valid values: compliant|non_compliant|conditional_compliance|under_investigation|penalty_assessed.',
  `contact_email` STRING COMMENT 'Email address of the utility representative responsible for this compliance report. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `contact_name` STRING COMMENT 'Name of the utility representative or program manager responsible for this compliance report and available for regulatory inquiries.',
  `contact_phone` STRING COMMENT 'Phone number of the utility representative responsible for this compliance report.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this compliance report record was first created in the system.',
  `data_quality_score` DECIMAL(5,4) COMMENT 'Composite data quality score (0.0000 to 1.0000) reflecting completeness, accuracy, and timeliness of the underlying meter data and baseline calculations used in this compliance report.',
  `enrolled_capacity_mw` DECIMAL(12,3) COMMENT 'Total enrolled demand response capacity in megawatts (MW) committed for the reporting period, representing the baseline program commitment.',
  `iso_rto_name` STRING COMMENT 'Name of the ISO or RTO market operator receiving this report (e.g., PJM, CAISO, ERCOT, NYISO, ISO-NE, MISO, SPP).',
  `last_modified_by` STRING COMMENT 'User ID or name of the person who last modified this compliance report record.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this compliance report record was last updated or modified.',
  `measurement_verification_method` STRING COMMENT 'The measurement and verification approach used to calculate demand response performance (e.g., \'Interval Meter Data\', \'Aggregated AMI Data\', \'Direct Load Control Telemetry\', \'Stipulated Load Reduction\').',
  `methodology_attestation_flag` BOOLEAN COMMENT 'Indicates whether the utility has formally attested that the baseline and performance measurement methodology complies with ISO/RTO and regulatory requirements. True = attestation provided; False = not attested.',
  `minimum_performance_threshold` DECIMAL(5,4) COMMENT 'Minimum required performance ratio (e.g., 0.7500 for 75%) that the program must achieve to remain compliant and avoid penalties.',
  `notes` STRING COMMENT 'Additional notes, comments, or explanatory information regarding this compliance report, including any special circumstances, waivers, or clarifications provided to the regulatory body.',
  `penalty_amount_usd` DECIMAL(15,2) COMMENT 'Financial penalty amount in US dollars assessed for non-compliance or underperformance during the reporting period. Null if no penalty assessed.',
  `penalty_reason` STRING COMMENT 'Explanation of the basis for any financial penalty assessed, including specific performance shortfalls or reporting violations.',
  `performance_period_type` STRING COMMENT 'Classification of the performance measurement period. summer_capability = June-September peak season; winter_capability = December-February peak season; annual_compliance = full calendar or program year; monthly_operational = single month assessment; capacity_performance_year = ISO/RTO capacity market delivery year. Valid values: summer_capability|winter_capability|annual_compliance|monthly_operational|capacity_performance_year.',
  `performance_ratio` DECIMAL(5,4) COMMENT 'Average performance ratio (delivered MW / committed MW) across all events during the reporting period. A value of 1.0000 indicates 100% performance; values below minimum threshold may trigger penalties.',
  `regulatory_body` STRING COMMENT 'The regulatory authority or market operator to which this compliance report is submitted. FERC = Federal Energy Regulatory Commission; ISO_RTO = Independent System Operator or Regional Transmission Organization; PUC = Public Utility Commission; NERC = North American Electric Reliability Corporation; state_commission = state-level regulatory commission; municipal_authority = local municipal utility regulator. Valid values: FERC|ISO_RTO|PUC|NERC|state_commission|municipal_authority.',
  `rejection_reason` STRING COMMENT 'Explanation provided by the regulatory body or ISO/RTO if the compliance report was rejected or requires resubmission, detailing deficiencies or missing information.',
  `report_number` STRING COMMENT 'Externally-known unique identifier or tracking number assigned to this compliance report by the utility or regulatory body.',
  `report_status` STRING COMMENT 'Current lifecycle status of the compliance report. draft = report being prepared; submitted = filed with regulatory body; under_review = regulatory review in progress; accepted = approved by regulatory body; rejected = not accepted, corrections required; resubmission_required = must be refiled with corrections; closed = final status, no further action. Reference-value candidates: draft|submitted|under_review|accepted|rejected|resubmission_required|closed.',
  `report_to_period` BIGINT COMMENT 'FK to demand.dr_performance_period.dr_performance_period_id — Compliance reports cover specific performance periods. Required for regulatory audit trail linking reports to measured performance.',
  `report_type` STRING COMMENT 'Classification of the compliance report type. DADS = Demand Response Availability Data System report submitted to ISO/RTO; annual_dr_report = annual program performance summary; capacity_performance_filing = capacity market performance documentation; summer_capability_report = summer peak season capability assessment; winter_capability_report = winter peak season capability assessment; monthly_performance_report = monthly operational performance summary. Valid values: DADS|annual_dr_report|capacity_performance_filing|summer_capability_report|winter_capability_report|monthly_performance_report.',
  `reporting_period_end_date` DATE COMMENT 'The end date of the performance measurement period covered by this compliance report (e.g., September 30 for summer capability period).',
  `reporting_period_start_date` DATE COMMENT 'The start date of the performance measurement period covered by this compliance report (e.g., June 1 for summer capability period).',
  `required_test_events` INT COMMENT 'Minimum number of demand response test or performance verification events required by the regulatory body or ISO/RTO during the reporting period.',
  `submission_deadline` DATE COMMENT 'Regulatory or ISO/RTO deadline date by which this compliance report must be submitted to avoid penalties or non-compliance status.',
  `submission_timestamp` TIMESTAMP COMMENT 'Date and time when this compliance report was submitted to the regulatory body or ISO/RTO.',
  `submitted_capacity_mw` DECIMAL(12,3) COMMENT 'Total demand response capacity in megawatts (MW) reported as available or delivered during the performance period.',
  `supporting_documentation_url` STRING COMMENT 'URL or file path to supporting documentation, attachments, or detailed performance data submitted with this compliance report.',
  `total_energy_curtailed_mwh` DECIMAL(15,3) COMMENT 'Total energy reduction in megawatt-hours (MWh) delivered across all demand response events during the reporting period.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_demand_dr_compliance_report` PRIMARY KEY (`dr_compliance_report_id`)
)
USING DELTA
COMMENT 'Master record of regulatory compliance reports and performance period assessments submitted to ISO/RTO, FERC, or PUC for DR program performance, capacity availability, and market participation. Captures reporting period (summer capability, annual compliance window), report type (DADS, annual DR report, capacity performance filing), performance measurement period details (minimum threshold, required test events, actual events called, average performance ratio), submitted MW, methodology attestation, submission timestamp, regulatory body, acceptance status, and PUC reporting deadlines. SSOT for DR regulatory reporting obligations and program performance period tracking. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DrComplianceReport',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.demand.dr_compliance_report'
);

-- DrAggregation  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `demand`.`aggregation` (
  `aggregation_id` BIGINT NOT NULL COMMENT 'Unique identifier for this aggregation contract record. Primary key.',
  `aggregator_id` BIGINT COMMENT 'Foreign key linking to the demand response aggregator party in this aggregation contract',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to the distributed energy resource system being aggregated under this contract',
  `settlement_account_id` BIGINT COMMENT 'Financial account or sub-account identifier used for revenue settlements specific to this aggregation contract. Enables tracking of payments and reconciliation at the individual DER system level.',
  `aggregation_status` STRING COMMENT 'Current operational status of this specific aggregation contract. Explicitly identified in detection phase relationship data. Indicates whether the DER system is actively participating, pending approval, temporarily suspended, or no longer aggregated.',
  `baseline_methodology` STRING COMMENT 'Specific baseline calculation methodology agreed upon for this aggregation contract to measure demand response performance. May differ from the aggregators default methodology based on DER system characteristics or program requirements.',
  `contract_document_reference` STRING COMMENT 'Reference identifier or URI to the legal contract document governing this specific aggregation relationship, stored in the document management system.',
  `contracted_capacity_kw` DECIMAL(12,3) COMMENT 'The specific capacity in kilowatts that this DER system has committed to provide under this aggregation contract. Explicitly identified in detection phase relationship data. This is distinct from the DER systems total nameplate capacity, as a system may allocate different capacities to different aggregators or reserve capacity for on-site use.',
  `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this aggregation contract record was created in the data platform.',
  `dispatch_priority` INTEGER COMMENT 'Numeric priority ranking for dispatch instructions when the DER system is aggregated by multiple aggregators. Lower numbers indicate higher priority. Ensures conflict resolution when multiple aggregators attempt to dispatch the same resource simultaneously.',
  `end_date` DATE COMMENT 'Scheduled or actual end date when the DER system exits the aggregators portfolio, either due to contract expiration, customer withdrawal, or system decommissioning.',
  `performance_tier` STRING COMMENT 'Classification of the DER systems performance obligations and incentive structure under this aggregation contract. Explicitly identified in detection phase relationship data. Higher tiers may require faster response times, higher availability, or more frequent dispatch capability in exchange for higher compensation.',
  `revenue_share_percentage` DECIMAL(5,2) COMMENT 'Percentage of demand response revenues or incentive payments that the DER system owner receives from this aggregation contract. Explicitly identified in detection phase relationship data. The remainder goes to the aggregator as compensation for market participation services.',
  `start_date` DATE COMMENT 'Effective start date when the DER system was enrolled into the aggregators portfolio under this specific contract. Explicitly identified in detection phase relationship data.',
  `telemetry_interval_seconds` INTEGER COMMENT 'Required frequency in seconds at which the DER system must report real-time operational data (power output, state of charge, availability status) to the aggregators platform for this contract. Explicitly identified in detection phase relationship data. Different aggregators or programs may require different telemetry frequencies (e.g., 15 seconds for ISO/RTO markets, 5 minutes for utility programs).',
  `updated_by` STRING COMMENT 'User or system identifier that last modified this aggregation contract record.',
  `updated_timestamp` TIMESTAMP COMMENT 'System timestamp when this aggregation contract record was last modified.',
  `created_by` STRING COMMENT 'User or system identifier that created this aggregation contract record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_demand_aggregation` PRIMARY KEY (`aggregation_id`)
)
USING DELTA
COMMENT 'This association product represents the contractual relationship between a demand response aggregator and a specific distributed energy resource (DER) system. It captures the commercial and operational terms under which an aggregator includes a DER system in its portfolio for participation in ISO/RTO wholesale markets or utility demand response programs. Each record links one aggregator to one DER system with attributes that exist only in the context of this aggregation contract, including capacity allocation, revenue sharing, performance obligations, and telemetry requirements.. Existence Justification: In energy utilities demand response operations, a single DER system can be contracted by multiple aggregators simultaneously to participate in different markets or programs (e.g., one aggregator for ISO/RTO wholesale capacity markets, another for utility-managed demand response programs). Each aggregator manages a portfolio of many DER systems. The aggregation relationship is an active contractual arrangement with specific commercial terms (capacity allocation, revenue sharing, performance tiers) and operational requirements (telemetry intervals, dispatch priority, baseline methodology) that vary by aggregator-system combination. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DrAggregation',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.demand.aggregation'
);

-- DemandEnrollment  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `demand`.`demand_enrollment` (
  `demand_enrollment_id` BIGINT NOT NULL COMMENT 'Primary key for demand_enrollment',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to the distributed energy resource system enrolled in the DR program',
  `dr_program_id` BIGINT COMMENT 'Foreign key linking to the demand response program in which the DER system is enrolled',
  `capacity_kw` DECIMAL(12,3) COMMENT 'The specific load reduction capacity in kilowatts that this DER system has committed to provide under this DR program. May differ from the DER system\'s total nameplate capacity if the system is enrolled in multiple programs or only partially enrolled. Explicitly identified in detection phase relationship data.',
  `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this enrollment record was created.',
  `demand_enrollment_date` DATE COMMENT 'Date when the DER system was enrolled into the DR program and became eligible for dispatch events. Explicitly identified in detection phase relationship data.',
  `demand_enrollment_status` STRING COMMENT 'Current lifecycle status of this specific enrollment. Active indicates the DER is eligible for dispatch. Suspended indicates temporary ineligibility. Withdrawn indicates permanent termination. Pending indicates enrollment application under review. Explicitly identified in detection phase relationship data.',
  `dispatch_priority` INT COMMENT 'Numeric priority ranking (1=highest) determining the order in which this DER system is dispatched during DR events for this program. Priority may be based on response reliability, capacity size, location, or contractual terms. Explicitly identified in detection phase relationship data.',
  `effective_end_date` DATE COMMENT 'Date when this enrollment is scheduled to terminate. Null for open-ended enrollments. Supports tracking of enrollment history and program participation lifecycle.',
  `effective_start_date` DATE COMMENT 'Date when this enrollment becomes operationally effective and the DER system can be dispatched under this program. May differ from enrollment_date if there is a waiting period or future start date.',
  `performance_score` DECIMAL(5,2) COMMENT 'Calculated performance score (0-100) measuring this DER system\'s historical response reliability and load reduction accuracy for this specific DR program. Used for dispatch priority optimization and incentive adjustments.',
  `program_specific_baseline_method` STRING COMMENT 'The baseline calculation methodology applied to this specific DER system for this specific DR program. May override or refine the program\'s default baseline_calculation_method based on DER technology type or customer agreement. Explicitly identified in detection phase relationship data.',
  `telemetry_configuration` STRING COMMENT 'Technical configuration specifying how real-time telemetry data from this DER system is collected, transmitted, and processed for this DR program. Includes polling frequency, communication protocol, data points monitored, and aggregation rules. Explicitly identified in detection phase relationship data.',
  `total_event_hours` DECIMAL(8,2) COMMENT 'Cumulative hours this DER system has been dispatched under this program since enrollment. Supports compliance tracking against max_event_hours_per_year program limits.',
  `total_events_dispatched` INT COMMENT 'Cumulative count of DR events in which this DER system has been dispatched under this program since enrollment. Supports compliance tracking against max_events_per_year program limits.',
  `updated_timestamp` TIMESTAMP COMMENT 'System timestamp when this enrollment record was last modified.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_demand_demand_enrollment` PRIMARY KEY (`demand_enrollment_id`)
)
USING DELTA
COMMENT 'This association product represents the enrollment relationship between a demand response program and a distributed energy resource system. It captures the operational configuration and performance tracking for each DER system\'s participation in each DR program. Each record links one DR program to one DER system with program-specific capacity allocation, baseline methodology, telemetry configuration, and enrollment lifecycle attributes that exist only in the context of this participation relationship.. Existence Justification: In energy utilities operations, a single DER system (solar+battery, EV charger, etc.) can simultaneously participate in multiple demand response programs - for example, enrolling in both an emergency load reduction program and an economic dispatch program and a capacity market program. Conversely, each DR program enrolls many DER systems across its service territory to aggregate sufficient capacity. The enrollment relationship is an operational business entity that DR program managers actively create, configure, monitor, and terminate. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DemandEnrollment',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.demand.demand_enrollment'
);

-- StormAggregatorDeployment  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `demand`.`storm_aggregator_deployment` (
  `storm_aggregator_deployment_id` BIGINT NOT NULL COMMENT 'Unique identifier for this storm aggregator deployment record',
  `aggregator_id` BIGINT COMMENT 'Foreign key linking to the demand response aggregator deployed during this storm event',
  `storm_event_id` BIGINT COMMENT 'Foreign key linking to the storm event during which this aggregator was activated',
  `activation_timestamp` TIMESTAMP COMMENT 'Date and time when this aggregator was officially activated for emergency demand response during this storm event, marks the start of the deployment period for settlement calculation',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time this deployment record was created in the system',
  `deactivation_timestamp` TIMESTAMP COMMENT 'Date and time when this aggregator deployment was officially deactivated and released from emergency response duty for this storm event, marks the end of the deployment period',
  `deployed_capacity_mw` DECIMAL(12,3) COMMENT 'Actual demand response capacity in megawatts deployed by this aggregator during this specific storm event, may differ from contracted capacity based on storm severity and customer availability',
  `deployment_status` STRING COMMENT 'Current lifecycle status of this aggregator deployment for this storm event, drives workflow for activation, monitoring, and settlement processes',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time this deployment record was most recently modified',
  `performance_notes` STRING COMMENT 'Free-text notes documenting aggregator performance, issues encountered, or special circumstances during this storm deployment, used for post-event review and compliance documentation',
  `performance_ratio` DECIMAL(5,4) COMMENT 'Ratio of actual deployed capacity to requested capacity for this storm deployment, calculated as deployed_capacity_mw divided by requested_capacity_mw, used for aggregator performance scoring',
  `requested_capacity_mw` DECIMAL(12,3) COMMENT 'Demand response capacity in megawatts requested from this aggregator by the utility for this specific storm event, based on storm severity and load relief requirements',
  `response_time_minutes` INT COMMENT 'Elapsed time in minutes from storm activation notification to aggregator achieving target deployed capacity, used for performance evaluation and compliance tracking',
  `settlement_amount` DECIMAL(15,2) COMMENT 'Total settlement payment in US dollars owed to the aggregator for this specific storm deployment, calculated based on deployed capacity, duration, and contracted rates',
  `settlement_status` STRING COMMENT 'Current status of the financial settlement process for this deployment, tracks progression from calculation through payment',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_demand_storm_aggregator_deployment` PRIMARY KEY (`storm_aggregator_deployment_id`)
)
USING DELTA
COMMENT 'This association product represents the emergency demand response deployment between aggregator and storm_event. It captures the operational activation of demand response aggregators during declared storm events for emergency load relief and mutual aid coordination. Each record links one aggregator to one storm_event with deployment-specific capacity, performance metrics, and settlement data that exist only in the context of this emergency response relationship.. Existence Justification: In energy utility emergency operations, demand response aggregators are activated during major storm events to provide emergency load relief and support mutual aid coordination. A single aggregator participates in multiple storm events over time (Hurricane Ida, Winter Storm Uri, etc.), and each major storm event involves activating multiple aggregators simultaneously to achieve required load reduction targets. The utility actively manages these deployments as operational records with specific capacity commitments, performance tracking, and financial settlements for each aggregator-storm combination. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'StormAggregatorDeployment',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.demand.storm_aggregator_deployment'
);

-- IrpDrProgramAssumption  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `demand`.`irp_dr_program_assumption` (
  `irp_dr_program_assumption_id` BIGINT NOT NULL COMMENT 'Unique identifier for this scenario-specific DR program assumption record. Primary key.',
  `dr_program_id` BIGINT COMMENT 'Foreign key linking to the demand response program being modeled in this IRP scenario',
  `irp_scenario_id` BIGINT COMMENT 'Foreign key linking to the IRP scenario that contains these DR program assumptions',
  `assumed_capacity_mw` DECIMAL(12,3) COMMENT 'Scenario-specific assumed load reduction capacity in megawatts for this DR program under this scenario\'s assumptions. Used in resource adequacy calculations and capacity gap analysis.',
  `assumed_cost_per_mw` DECIMAL(15,2) COMMENT 'Scenario-specific assumed annual cost per megawatt of DR capacity for this program. Includes incentive payments, program administration, and M&V costs. Used in total resource cost calculations.',
  `assumed_participation_rate_percent` DECIMAL(5,2) COMMENT 'Scenario-specific assumption for customer participation rate in this DR program, expressed as percentage of eligible customers. Varies by scenario (base case may assume 15%, high DR scenario may assume 30%).',
  `assumption_notes` STRING COMMENT 'Free-text notes documenting the rationale for scenario-specific DR program assumptions, including references to historical performance data, regulatory requirements, or stakeholder input.',
  `capacity_credit_percent` DECIMAL(5,2) COMMENT 'Scenario-specific capacity credit percentage applied to DR program enrolled capacity for resource adequacy calculations. Accounts for uncertainty in DR performance. Typically 70-90% of enrolled capacity.',
  `created_date` TIMESTAMP COMMENT 'Timestamp when this scenario-specific DR program assumption record was created by IRP modeling team.',
  `deployment_year` INT COMMENT 'Year within the planning horizon when this DR program is assumed to be deployed or reach target capacity in this scenario. Enables phased DR deployment modeling.',
  `last_modified_by` STRING COMMENT 'User ID of the IRP analyst who last modified this scenario-specific DR program assumption.',
  `last_modified_date` TIMESTAMP COMMENT 'Timestamp when this scenario-specific DR program assumption was last updated.',
  `ramp_up_schedule` STRING COMMENT 'Scenario-specific assumption for how quickly the DR program scales from deployment year to full capacity. Values: Immediate (full capacity in deployment year), Linear_3yr (linear ramp over 3 years), Linear_5yr, S_Curve (slow start, rapid middle, slow end).',
  `created_by` STRING COMMENT 'User ID of the IRP analyst who created this scenario-specific DR program assumption.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_demand_irp_dr_program_assumption` PRIMARY KEY (`irp_dr_program_assumption_id`)
)
USING DELTA
COMMENT 'This association product represents the scenario-specific modeling assumptions for a demand response program within an Integrated Resource Plan scenario. Each IRP scenario models the same DR program portfolio with different participation rates, capacity credits, costs, and deployment timing to evaluate resource adequacy under various planning assumptions. Each record links one DR program to one IRP scenario with the scenario-specific assumptions used in capacity expansion modeling and regulatory filings.. Existence Justification: In IRP planning, utilities model the same portfolio of DR programs across multiple scenarios (base case, high DR penetration, low carbon, accelerated retirement) with different participation rates, capacity credits, costs, and deployment timing for each scenario. Each DR program appears in multiple IRP scenarios with scenario-specific assumptions, and each IRP scenario models multiple DR programs. IRP analysts actively create and manage these scenario-specific DR program assumptions as part of regulatory filing preparation and resource adequacy sensitivity analysis. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'IrpDrProgramAssumption',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.demand.irp_dr_program_assumption'
);

-- ========= FOREIGN KEYS within demand (52) =========
ALTER TABLE `demand`.`demand_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_demand_demand_dr_enrollment_aggregator_id`;
ALTER TABLE `demand`.`demand_dr_enrollment` ADD CONSTRAINT `fk_demand_demand_dr_enrollment_aggregator_id` FOREIGN KEY (`aggregator_id`) REFERENCES `demand`.`aggregator` (`aggregator_id`);

ALTER TABLE `demand`.`demand_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_demand_demand_dr_enrollment_dr_program_id`;
ALTER TABLE `demand`.`demand_dr_enrollment` ADD CONSTRAINT `fk_demand_demand_dr_enrollment_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `demand`.`demand_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_demand_demand_dr_enrollment_interruptible_tariff_agreement_id`;
ALTER TABLE `demand`.`demand_dr_enrollment` ADD CONSTRAINT `fk_demand_demand_dr_enrollment_interruptible_tariff_agreement_id` FOREIGN KEY (`interruptible_tariff_agreement_id`) REFERENCES `demand`.`interruptible_tariff_agreement` (`interruptible_tariff_agreement_id`);

ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_aggregator_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_aggregator_id` FOREIGN KEY (`aggregator_id`) REFERENCES `demand`.`aggregator` (`aggregator_id`);

ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_dr_program_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_primary_dr_program_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_primary_dr_program_id` FOREIGN KEY (`primary_dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_to_dr_program_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_to_dr_program_id` FOREIGN KEY (`to_dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `demand`.`dr_event_participant` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_participant_aggregator_id`;
ALTER TABLE `demand`.`dr_event_participant` ADD CONSTRAINT `fk_demand_dr_event_participant_aggregator_id` FOREIGN KEY (`aggregator_id`) REFERENCES `demand`.`aggregator` (`aggregator_id`);

ALTER TABLE `demand`.`dr_event_participant` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_participant_demand_dr_enrollment_id`;
ALTER TABLE `demand`.`dr_event_participant` ADD CONSTRAINT `fk_demand_dr_event_participant_demand_dr_enrollment_id` FOREIGN KEY (`demand_dr_enrollment_id`) REFERENCES `demand`.`demand_dr_enrollment` (`demand_dr_enrollment_id`);

ALTER TABLE `demand`.`dr_event_participant` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_participant_direct_load_control_device_id`;
ALTER TABLE `demand`.`dr_event_participant` ADD CONSTRAINT `fk_demand_dr_event_participant_direct_load_control_device_id` FOREIGN KEY (`direct_load_control_device_id`) REFERENCES `demand`.`direct_load_control_device` (`direct_load_control_device_id`);

ALTER TABLE `demand`.`dr_event_participant` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_participant_dr_event_id`;
ALTER TABLE `demand`.`dr_event_participant` ADD CONSTRAINT `fk_demand_dr_event_participant_dr_event_id` FOREIGN KEY (`dr_event_id`) REFERENCES `demand`.`dr_event` (`dr_event_id`);

ALTER TABLE `demand`.`dr_event_participant` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_participant_primary_dr_event_id`;
ALTER TABLE `demand`.`dr_event_participant` ADD CONSTRAINT `fk_demand_dr_event_participant_primary_dr_event_id` FOREIGN KEY (`primary_dr_event_id`) REFERENCES `demand`.`dr_event` (`dr_event_id`);

ALTER TABLE `demand`.`dr_event_participant` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_participant_to_dr_event_id`;
ALTER TABLE `demand`.`dr_event_participant` ADD CONSTRAINT `fk_demand_dr_event_participant_to_dr_event_id` FOREIGN KEY (`to_dr_event_id`) REFERENCES `demand`.`dr_event` (`dr_event_id`);

ALTER TABLE `demand`.`load_baseline` DROP CONSTRAINT IF EXISTS `fk_demand_load_baseline_dr_event_id`;
ALTER TABLE `demand`.`load_baseline` ADD CONSTRAINT `fk_demand_load_baseline_dr_event_id` FOREIGN KEY (`dr_event_id`) REFERENCES `demand`.`dr_event` (`dr_event_id`);

ALTER TABLE `demand`.`load_baseline` DROP CONSTRAINT IF EXISTS `fk_demand_load_baseline_dr_program_id`;
ALTER TABLE `demand`.`load_baseline` ADD CONSTRAINT `fk_demand_load_baseline_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `demand`.`load_baseline` DROP CONSTRAINT IF EXISTS `fk_demand_load_baseline_superseded_by_baseline_load_baseline_id`;
ALTER TABLE `demand`.`load_baseline` ADD CONSTRAINT `fk_demand_load_baseline_superseded_by_baseline_load_baseline_id` FOREIGN KEY (`superseded_by_baseline_load_baseline_id`) REFERENCES `demand`.`load_baseline` (`load_baseline_id`);

ALTER TABLE `demand`.`curtailment_measurement` DROP CONSTRAINT IF EXISTS `fk_demand_curtailment_measurement_curtailment_dr_event_participant_id`;
ALTER TABLE `demand`.`curtailment_measurement` ADD CONSTRAINT `fk_demand_curtailment_measurement_curtailment_dr_event_participant_id` FOREIGN KEY (`curtailment_dr_event_participant_id`) REFERENCES `demand`.`dr_event_participant` (`dr_event_participant_id`);

ALTER TABLE `demand`.`curtailment_measurement` DROP CONSTRAINT IF EXISTS `fk_demand_curtailment_measurement_curtailment_load_baseline_id`;
ALTER TABLE `demand`.`curtailment_measurement` ADD CONSTRAINT `fk_demand_curtailment_measurement_curtailment_load_baseline_id` FOREIGN KEY (`curtailment_load_baseline_id`) REFERENCES `demand`.`load_baseline` (`load_baseline_id`);

ALTER TABLE `demand`.`curtailment_measurement` DROP CONSTRAINT IF EXISTS `fk_demand_curtailment_measurement_demand_dr_enrollment_id`;
ALTER TABLE `demand`.`curtailment_measurement` ADD CONSTRAINT `fk_demand_curtailment_measurement_demand_dr_enrollment_id` FOREIGN KEY (`demand_dr_enrollment_id`) REFERENCES `demand`.`demand_dr_enrollment` (`demand_dr_enrollment_id`);

ALTER TABLE `demand`.`curtailment_measurement` DROP CONSTRAINT IF EXISTS `fk_demand_curtailment_measurement_dr_event_id`;
ALTER TABLE `demand`.`curtailment_measurement` ADD CONSTRAINT `fk_demand_curtailment_measurement_dr_event_id` FOREIGN KEY (`dr_event_id`) REFERENCES `demand`.`dr_event` (`dr_event_id`);

ALTER TABLE `demand`.`curtailment_measurement` DROP CONSTRAINT IF EXISTS `fk_demand_curtailment_measurement_to_dr_event_participant_id`;
ALTER TABLE `demand`.`curtailment_measurement` ADD CONSTRAINT `fk_demand_curtailment_measurement_to_dr_event_participant_id` FOREIGN KEY (`to_dr_event_participant_id`) REFERENCES `demand`.`dr_event_participant` (`dr_event_participant_id`);

ALTER TABLE `demand`.`curtailment_measurement` DROP CONSTRAINT IF EXISTS `fk_demand_curtailment_measurement_to_load_baseline_id`;
ALTER TABLE `demand`.`curtailment_measurement` ADD CONSTRAINT `fk_demand_curtailment_measurement_to_load_baseline_id` FOREIGN KEY (`to_load_baseline_id`) REFERENCES `demand`.`load_baseline` (`load_baseline_id`);

ALTER TABLE `demand`.`dr_incentive_payment` DROP CONSTRAINT IF EXISTS `fk_demand_dr_incentive_payment_aggregator_id`;
ALTER TABLE `demand`.`dr_incentive_payment` ADD CONSTRAINT `fk_demand_dr_incentive_payment_aggregator_id` FOREIGN KEY (`aggregator_id`) REFERENCES `demand`.`aggregator` (`aggregator_id`);

ALTER TABLE `demand`.`dr_incentive_payment` DROP CONSTRAINT IF EXISTS `fk_demand_dr_incentive_payment_dr_event_id`;
ALTER TABLE `demand`.`dr_incentive_payment` ADD CONSTRAINT `fk_demand_dr_incentive_payment_dr_event_id` FOREIGN KEY (`dr_event_id`) REFERENCES `demand`.`dr_event` (`dr_event_id`);

ALTER TABLE `demand`.`dr_incentive_payment` DROP CONSTRAINT IF EXISTS `fk_demand_dr_incentive_payment_dr_program_id`;
ALTER TABLE `demand`.`dr_incentive_payment` ADD CONSTRAINT `fk_demand_dr_incentive_payment_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `demand`.`dr_incentive_payment` DROP CONSTRAINT IF EXISTS `fk_demand_dr_incentive_payment_primary_dr_event_id`;
ALTER TABLE `demand`.`dr_incentive_payment` ADD CONSTRAINT `fk_demand_dr_incentive_payment_primary_dr_event_id` FOREIGN KEY (`primary_dr_event_id`) REFERENCES `demand`.`dr_event` (`dr_event_id`);

ALTER TABLE `demand`.`dr_incentive_payment` DROP CONSTRAINT IF EXISTS `fk_demand_dr_incentive_payment_primary_dr_event_participant_id`;
ALTER TABLE `demand`.`dr_incentive_payment` ADD CONSTRAINT `fk_demand_dr_incentive_payment_primary_dr_event_participant_id` FOREIGN KEY (`primary_dr_event_participant_id`) REFERENCES `demand`.`dr_event_participant` (`dr_event_participant_id`);

ALTER TABLE `demand`.`dr_incentive_payment` DROP CONSTRAINT IF EXISTS `fk_demand_dr_incentive_payment_primary_dr_program_id`;
ALTER TABLE `demand`.`dr_incentive_payment` ADD CONSTRAINT `fk_demand_dr_incentive_payment_primary_dr_program_id` FOREIGN KEY (`primary_dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `demand`.`dr_incentive_payment` DROP CONSTRAINT IF EXISTS `fk_demand_dr_incentive_payment_to_dr_event_participant_id`;
ALTER TABLE `demand`.`dr_incentive_payment` ADD CONSTRAINT `fk_demand_dr_incentive_payment_to_dr_event_participant_id` FOREIGN KEY (`to_dr_event_participant_id`) REFERENCES `demand`.`dr_event_participant` (`dr_event_participant_id`);

ALTER TABLE `demand`.`dr_incentive_payment` DROP CONSTRAINT IF EXISTS `fk_demand_dr_incentive_payment_to_dr_program_id`;
ALTER TABLE `demand`.`dr_incentive_payment` ADD CONSTRAINT `fk_demand_dr_incentive_payment_to_dr_program_id` FOREIGN KEY (`to_dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `demand`.`interruptible_tariff_agreement` DROP CONSTRAINT IF EXISTS `fk_demand_interruptible_tariff_agreement_aggregator_id`;
ALTER TABLE `demand`.`interruptible_tariff_agreement` ADD CONSTRAINT `fk_demand_interruptible_tariff_agreement_aggregator_id` FOREIGN KEY (`aggregator_id`) REFERENCES `demand`.`aggregator` (`aggregator_id`);

ALTER TABLE `demand`.`direct_load_control_device` DROP CONSTRAINT IF EXISTS `fk_demand_direct_load_control_device_aggregator_id`;
ALTER TABLE `demand`.`direct_load_control_device` ADD CONSTRAINT `fk_demand_direct_load_control_device_aggregator_id` FOREIGN KEY (`aggregator_id`) REFERENCES `demand`.`aggregator` (`aggregator_id`);

ALTER TABLE `demand`.`direct_load_control_device` DROP CONSTRAINT IF EXISTS `fk_demand_direct_load_control_device_dr_program_id`;
ALTER TABLE `demand`.`direct_load_control_device` ADD CONSTRAINT `fk_demand_direct_load_control_device_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `demand`.`vpp_dispatch` DROP CONSTRAINT IF EXISTS `fk_demand_vpp_dispatch_aggregator_id`;
ALTER TABLE `demand`.`vpp_dispatch` ADD CONSTRAINT `fk_demand_vpp_dispatch_aggregator_id` FOREIGN KEY (`aggregator_id`) REFERENCES `demand`.`aggregator` (`aggregator_id`);

ALTER TABLE `demand`.`vpp_dispatch` DROP CONSTRAINT IF EXISTS `fk_demand_vpp_dispatch_dr_capacity_registration_id`;
ALTER TABLE `demand`.`vpp_dispatch` ADD CONSTRAINT `fk_demand_vpp_dispatch_dr_capacity_registration_id` FOREIGN KEY (`dr_capacity_registration_id`) REFERENCES `demand`.`dr_capacity_registration` (`dr_capacity_registration_id`);

ALTER TABLE `demand`.`vpp_dispatch` DROP CONSTRAINT IF EXISTS `fk_demand_vpp_dispatch_to_dr_event_id`;
ALTER TABLE `demand`.`vpp_dispatch` ADD CONSTRAINT `fk_demand_vpp_dispatch_to_dr_event_id` FOREIGN KEY (`to_dr_event_id`) REFERENCES `demand`.`dr_event` (`dr_event_id`);

ALTER TABLE `demand`.`vpp_dispatch` DROP CONSTRAINT IF EXISTS `fk_demand_vpp_dispatch_vpp_dr_event_id`;
ALTER TABLE `demand`.`vpp_dispatch` ADD CONSTRAINT `fk_demand_vpp_dispatch_vpp_dr_event_id` FOREIGN KEY (`vpp_dr_event_id`) REFERENCES `demand`.`dr_event` (`dr_event_id`);

ALTER TABLE `demand`.`dr_capacity_registration` DROP CONSTRAINT IF EXISTS `fk_demand_dr_capacity_registration_aggregator_id`;
ALTER TABLE `demand`.`dr_capacity_registration` ADD CONSTRAINT `fk_demand_dr_capacity_registration_aggregator_id` FOREIGN KEY (`aggregator_id`) REFERENCES `demand`.`aggregator` (`aggregator_id`);

ALTER TABLE `demand`.`dr_capacity_registration` DROP CONSTRAINT IF EXISTS `fk_demand_dr_capacity_registration_dr_aggregator_id`;
ALTER TABLE `demand`.`dr_capacity_registration` ADD CONSTRAINT `fk_demand_dr_capacity_registration_dr_aggregator_id` FOREIGN KEY (`dr_aggregator_id`) REFERENCES `demand`.`aggregator` (`aggregator_id`);

ALTER TABLE `demand`.`dr_capacity_registration` DROP CONSTRAINT IF EXISTS `fk_demand_dr_capacity_registration_dr_capacity_registration_to_aggregator`;
ALTER TABLE `demand`.`dr_capacity_registration` ADD CONSTRAINT `fk_demand_dr_capacity_registration_dr_capacity_registration_to_aggregator` FOREIGN KEY (`dr_capacity_registration_to_aggregator`) REFERENCES `demand`.`aggregator` (`aggregator_id`);

ALTER TABLE `demand`.`dr_capacity_registration` DROP CONSTRAINT IF EXISTS `fk_demand_dr_capacity_registration_dr_capacity_registration_to_program`;
ALTER TABLE `demand`.`dr_capacity_registration` ADD CONSTRAINT `fk_demand_dr_capacity_registration_dr_capacity_registration_to_program` FOREIGN KEY (`dr_capacity_registration_to_program`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `demand`.`dr_capacity_registration` DROP CONSTRAINT IF EXISTS `fk_demand_dr_capacity_registration_dr_program_id`;
ALTER TABLE `demand`.`dr_capacity_registration` ADD CONSTRAINT `fk_demand_dr_capacity_registration_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `demand`.`dr_capacity_registration` DROP CONSTRAINT IF EXISTS `fk_demand_dr_capacity_registration_primary_dr_program_id`;
ALTER TABLE `demand`.`dr_capacity_registration` ADD CONSTRAINT `fk_demand_dr_capacity_registration_primary_dr_program_id` FOREIGN KEY (`primary_dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `demand`.`dr_capacity_registration` DROP CONSTRAINT IF EXISTS `fk_demand_dr_capacity_registration_to_aggregator_id`;
ALTER TABLE `demand`.`dr_capacity_registration` ADD CONSTRAINT `fk_demand_dr_capacity_registration_to_aggregator_id` FOREIGN KEY (`to_aggregator_id`) REFERENCES `demand`.`aggregator` (`aggregator_id`);

ALTER TABLE `demand`.`dr_capacity_registration` DROP CONSTRAINT IF EXISTS `fk_demand_dr_capacity_registration_to_dr_program_id`;
ALTER TABLE `demand`.`dr_capacity_registration` ADD CONSTRAINT `fk_demand_dr_capacity_registration_to_dr_program_id` FOREIGN KEY (`to_dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `demand`.`dr_compliance_report` DROP CONSTRAINT IF EXISTS `fk_demand_dr_compliance_report_dr_program_id`;
ALTER TABLE `demand`.`dr_compliance_report` ADD CONSTRAINT `fk_demand_dr_compliance_report_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `demand`.`dr_compliance_report` DROP CONSTRAINT IF EXISTS `fk_demand_dr_compliance_report_primary_dr_program_id`;
ALTER TABLE `demand`.`dr_compliance_report` ADD CONSTRAINT `fk_demand_dr_compliance_report_primary_dr_program_id` FOREIGN KEY (`primary_dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `demand`.`dr_compliance_report` DROP CONSTRAINT IF EXISTS `fk_demand_dr_compliance_report_to_dr_program_id`;
ALTER TABLE `demand`.`dr_compliance_report` ADD CONSTRAINT `fk_demand_dr_compliance_report_to_dr_program_id` FOREIGN KEY (`to_dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `demand`.`aggregation` DROP CONSTRAINT IF EXISTS `fk_demand_aggregation_aggregator_id`;
ALTER TABLE `demand`.`aggregation` ADD CONSTRAINT `fk_demand_aggregation_aggregator_id` FOREIGN KEY (`aggregator_id`) REFERENCES `demand`.`aggregator` (`aggregator_id`);

ALTER TABLE `demand`.`demand_enrollment` DROP CONSTRAINT IF EXISTS `fk_demand_demand_enrollment_dr_program_id`;
ALTER TABLE `demand`.`demand_enrollment` ADD CONSTRAINT `fk_demand_demand_enrollment_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `demand`.`storm_aggregator_deployment` DROP CONSTRAINT IF EXISTS `fk_demand_storm_aggregator_deployment_aggregator_id`;
ALTER TABLE `demand`.`storm_aggregator_deployment` ADD CONSTRAINT `fk_demand_storm_aggregator_deployment_aggregator_id` FOREIGN KEY (`aggregator_id`) REFERENCES `demand`.`aggregator` (`aggregator_id`);

ALTER TABLE `demand`.`irp_dr_program_assumption` DROP CONSTRAINT IF EXISTS `fk_demand_irp_dr_program_assumption_dr_program_id`;
ALTER TABLE `demand`.`irp_dr_program_assumption` ADD CONSTRAINT `fk_demand_irp_dr_program_assumption_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

