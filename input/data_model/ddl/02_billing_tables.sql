-- Utility CMM-aligned Canonical Data Model (Silver) v1.0.0 | source: Databricks lakehouse-industry-data-models energy_utilities v1 ECM | generated 2026-10-13
-- 02 | Subject area: billing | 29 tables | CIM packages: IEC61968::Customers; IEC61968::PaymentMetering; IEC61968::InfCustomers
-- Standards: IEC 61968-8; IEC 61968-10; FERC USoA; ASC 606; NAESB REQ.21 ESPI
-- Contents: tables (with PK + NOT NULL), then intra-subject-area foreign keys.
-- Unity Catalog PK/FK constraints are informational (NOT ENFORCED); NOT NULL is enforced.

USE CATALOG `utility_cmm_silver`;

-- RateSchedule  <<CIM Tariff : exact>>
CREATE TABLE IF NOT EXISTS `billing`.`rate_schedule` (
  `rate_schedule_id` BIGINT NOT NULL COMMENT 'Unique identifier for the rate schedule. Primary key for the rate schedule master reference entity.',
  `irp_scenario_id` BIGINT COMMENT 'Foreign key linking to forecast.irp_scenario. Business justification: Rate schedules are designed to recover costs projected in IRP scenarios. Regulatory rate cases reference specific IRP scenarios for cost recovery justification. Utilities track which IRP scenario info',
  `lmp_price_id` BIGINT COMMENT 'Foreign key linking to trading.lmp_price. Business justification: Dynamic retail tariffs indexed to real-time or day-ahead LMP require direct price reference for automated rate calculation, regulatory cost recovery validation, and customer bill transparency in real-',
  `peak_demand_id` BIGINT COMMENT 'Foreign key linking to forecast.peak_demand. Business justification: Demand charge rate schedules are designed to recover capacity costs allocated based on peak demand forecasts. Rate design documents reference specific peak demand forecasts (by customer class and seas',
  `rate_case_id` BIGINT COMMENT 'Foreign key linking to compliance.rate_case. Business justification: Rate schedules in billing are approved through regulatory rate case proceedings tracked in compliance. This is a fundamental regulatory relationship in utility operations - every tariff/rate schedule',
  `renewable_incentive_program_id` BIGINT COMMENT 'Foreign key linking to renewable.incentive_program. Business justification: Rate schedules incorporate renewable incentive program terms for green tariff pricing, renewable energy riders, and regulatory compliance. Tariff design requires linking incentive program rates to bil',
  `service_territory_id` BIGINT COMMENT 'Foreign key linking to distribution.service_territory. Business justification: Rate schedules are approved by regulatory jurisdiction tied to service territory. Required for tariff management, rate case filings, and ensuring customers are billed under correct jurisdictional rate',
  `billing_cycle_type` STRING COMMENT 'Standard billing frequency applicable to customers on this rate schedule. Valid values: monthly|bimonthly|quarterly|annual|on_demand.',
  `budget_billing_eligible` BOOLEAN COMMENT 'Indicates whether customers on this rate schedule are eligible for budget billing or levelized payment plans.',
  `created_by_user` STRING COMMENT 'User ID or system identifier of the person or process that created this rate schedule record.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this rate schedule record was first created in the billing system.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this rate schedule. Pattern: ^[A-Z]{3}$.',
  `customer_charge_amount` DECIMAL(10,2) COMMENT 'Fixed monthly customer charge in dollars applicable under this rate schedule. Covers meter reading, billing, and basic service costs.',
  `demand_charge_rate` DECIMAL(10,4) COMMENT 'Demand charge rate in dollars per kilowatt of peak demand. Null for rate schedules without demand charges.',
  `effective_end_date` DATE COMMENT 'Date on which this rate schedule ceases to be effective. Null for currently active rate schedules with no planned end date.',
  `effective_start_date` DATE COMMENT 'Date from which this rate schedule becomes effective and applicable to customer billing.',
  `energy_charge_rate` DECIMAL(10,6) COMMENT 'Base energy charge rate in dollars per kilowatt-hour. Represents the primary volumetric charge component for energy consumption.',
  `fuel_adjustment_clause_applicable` BOOLEAN COMMENT 'Indicates whether a fuel adjustment clause or energy cost adjustment mechanism applies to this rate schedule.',
  `has_seasonal_rates` BOOLEAN COMMENT 'Indicates whether this rate schedule includes seasonal rate variations for summer and winter periods.',
  `has_tiered_pricing` BOOLEAN COMMENT 'Indicates whether this rate schedule includes tiered or block pricing with different rates for different usage levels.',
  `has_tou_periods` BOOLEAN COMMENT 'Indicates whether this rate schedule includes time-of-use pricing periods with different rates for peak, off-peak, and shoulder periods.',
  `interruptible_service` BOOLEAN COMMENT 'Indicates whether this rate schedule provides interruptible or curtailable service with discounted rates in exchange for load reduction rights.',
  `jurisdiction` STRING COMMENT 'State or regulatory jurisdiction code where this rate schedule is approved and applicable. Uses standard state abbreviations or jurisdiction codes. Pattern: ^[A-Z]{2,3}$.',
  `maximum_demand_kw` DECIMAL(12,3) COMMENT 'Maximum demand threshold in kilowatts for customer eligibility under this rate schedule. Null if no maximum applies.',
  `maximum_usage_kwh` DECIMAL(15,3) COMMENT 'Maximum monthly energy usage in kilowatt-hours for customer eligibility. Null if no maximum applies.',
  `minimum_demand_kw` DECIMAL(12,3) COMMENT 'Minimum demand threshold in kilowatts required for customer eligibility under this rate schedule. Null if no minimum applies.',
  `minimum_power_factor` DECIMAL(4,3) COMMENT 'Minimum power factor threshold required to avoid penalties. Expressed as a decimal between 0 and 1. Null if power factor penalties do not apply.',
  `minimum_usage_kwh` DECIMAL(15,3) COMMENT 'Minimum monthly energy usage in kilowatt-hours required for customer eligibility. Null if no minimum applies.',
  `modified_by_user` STRING COMMENT 'User ID or system identifier of the person or process that last modified this rate schedule record.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this rate schedule record was last modified in the billing system.',
  `net_metering_eligible` BOOLEAN COMMENT 'Indicates whether customers on this rate schedule are eligible for net energy metering programs for distributed generation.',
  `notes` STRING COMMENT 'Additional notes, comments, or special instructions related to this rate schedule for internal reference.',
  `power_factor_penalty_applicable` BOOLEAN COMMENT 'Indicates whether power factor penalties or adjustments apply to customers on this rate schedule for poor power factor performance.',
  `prepay_eligible` BOOLEAN COMMENT 'Indicates whether customers on this rate schedule are eligible for prepaid metering programs.',
  `rate_class` STRING COMMENT 'Customer class or segment to which this rate schedule applies. Defines the primary customer category for rate applicability. Valid values: residential|commercial|industrial|agricultural|municipal|street_lighting.',
  `rate_code` STRING COMMENT 'Business identifier for the rate schedule used in billing systems and customer communications. Externally-known unique code for this tariff rate schedule. Pattern: ^[A-Z0-9]{3,12}$.',
  `rate_description` STRING COMMENT 'Detailed description of the rate schedule including applicability, terms, and conditions as filed with regulatory authorities.',
  `rate_name` STRING COMMENT 'Human-readable name of the rate schedule displayed on customer bills and tariff documents.',
  `rate_schedule_status` STRING COMMENT 'Current lifecycle status of the rate schedule in the billing system. Valid values: active|inactive|pending|superseded|suspended.',
  `rate_type` STRING COMMENT 'Type of rate structure defining the pricing methodology. TOU = Time of Use, CPP = Critical Peak Pricing. Reference-value candidates: standard|tou|cpp|tiered|demand|flat|seasonal|interruptible.',
  `regulatory_approval_date` DATE COMMENT 'Date on which the regulatory authority approved this rate schedule for implementation.',
  `regulatory_approval_number` STRING COMMENT 'Reference number of the regulatory order or docket approving this rate schedule. Links to PUC or FERC rate case proceedings.',
  `renewable_energy_rider_applicable` BOOLEAN COMMENT 'Indicates whether renewable energy riders or RPS compliance charges apply to this rate schedule.',
  `service_type` STRING COMMENT 'Type of electrical service configuration applicable to this rate schedule. Valid values: single_phase|three_phase|primary_service|secondary_service.',
  `source_system` STRING COMMENT 'Identifier of the source billing system from which this rate schedule record originated. Valid values: SAP_IS_U|ORACLE_CCB|LEGACY_CIS.',
  `tariff_book_reference` STRING COMMENT 'Reference to the section and page number in the official tariff book where this rate schedule is published.',
  `tax_inclusive` BOOLEAN COMMENT 'Indicates whether the published rates include applicable taxes or if taxes are added separately during billing.',
  `voltage_level` STRING COMMENT 'Voltage level at which service is delivered under this rate schedule. Determines applicable transmission and distribution charges. Valid values: primary|secondary|transmission|sub_transmission|distribution.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_rate_schedule` PRIMARY KEY (`rate_schedule_id`)
)
USING DELTA
COMMENT 'Master reference entity defining tariff rate schedules and their granular charge components applicable to customer accounts. At the schedule level: stores rate code, effective dates, rate class, voltage level, applicable customer segments, regulatory approval references, and jurisdiction. At the component level: captures individual charge elements including energy charges ($/kWh), demand charges ($/kW), customer charges, fuel adjustment clauses, distribution charges, transmission charges, and riders with component type, unit of measure, tier thresholds, seasonal applicability, time-of-use period mapping, and calculation formula. Sourced from SAP IS-U and Oracle CC&B rate configuration modules. SSOT for all rate definitions and charge component structures used in bill calculation. Supports rate case filings and regulatory tariff compliance. | CMM: CIM Tariff (exact), IEC61968::Customers.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'RateSchedule',
  'cmm.cim.class' = 'Tariff',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Customers',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'reference_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.rate_schedule'
);

-- RateComponent  <<CIM Charge : close>>
CREATE TABLE IF NOT EXISTS `billing`.`rate_component` (
  `rate_component_id` BIGINT NOT NULL COMMENT 'Unique identifier for the rate component. Primary key.',
  `capacity_requirement_id` BIGINT COMMENT 'Foreign key linking to forecast.capacity_requirement. Business justification: Capacity-related rate components (demand charges, capacity riders, PJM/ISO capacity cost recovery riders) are calculated to recover costs from capacity requirement forecasts. Tariff filings must refer',
  `dr_program_id` BIGINT COMMENT 'Foreign key linking to demand.dr_program. Business justification: Specific rate components (demand charges, TOU energy charges) may be waived, modified, or have special calculation rules for DR program participants. Tariff administration, billing system configuratio',
  `energy_price_id` BIGINT COMMENT 'Foreign key linking to forecast.energy_price. Business justification: Energy charge rate components often include fuel adjustment clauses indexed to forecasted energy/fuel prices. Tariff sheets reference specific price forecast scenarios for automatic rate adjustments.',
  `fuel_price_assumption_id` BIGINT COMMENT 'Foreign key linking to forecast.fuel_price_assumption. Business justification: Fuel adjustment clause rate components are calculated using specific fuel price assumptions filed with regulators. Utilities must track which fuel price forecast version was used for each rate compone',
  `primary_rate_schedule_id` BIGINT COMMENT 'Foreign key reference to the parent rate schedule that contains this component.',
  `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: Rate components must be documented in regulatory filings when utilities propose tariff changes or rate case adjustments. Links the rate component to the specific filing (rate case, tariff amendment) w',
  `adjustment_frequency` STRING COMMENT 'Frequency at which this rate component value is adjusted or recalculated. Fixed components never change, monthly adjustments are common for fuel clauses, quarterly for purchased power adjustments, annually for base rate reviews, event-driven for critical peak pricing. Valid values: fixed|monthly|quarterly|annually|event_driven.',
  `applicable_days` STRING COMMENT 'Indicates which days of the week or calendar this rate component applies to. TOU rates often differ between weekdays and weekends. Valid values: all_days|weekdays|weekends|holidays|non_holidays.',
  `approval_status` STRING COMMENT 'Current regulatory approval status of the rate component. Draft components are under development, pending_approval are submitted to PUC, approved are authorized for billing, rejected were denied, superseded were replaced by newer versions, retired are no longer in use. Valid values: draft|pending_approval|approved|rejected|superseded|retired.',
  `bill_print_sequence` INT COMMENT 'Sequence number controlling the order in which rate components appear on printed customer bills. Lower numbers print first. Null if print_on_bill_flag is False.',
  `billing_determinant` STRING COMMENT 'The measured or calculated value that this rate component is applied to. Actual usage comes from meter reads, estimated usage from profiling, contracted demand from service agreements, metered demand from interval data, billing demand from demand ratchets. Valid values: actual_usage|estimated_usage|contracted_demand|metered_demand|billing_demand|customer_count.',
  `calculation_formula` STRING COMMENT 'Mathematical formula or expression used to calculate the charge when calculation_method is \'formula\'. May reference other rate components, meter data, or external indices.',
  `calculation_method` STRING COMMENT 'Method used to calculate charges for this component. Flat applies a single rate, tiered uses progressive rate steps, block uses declining block rates, TOU (time-of-use) varies by time period, CPP (critical peak pricing) applies premium rates during peak events, real-time uses dynamic pricing, formula uses a custom calculation expression. Reference-value candidates: flat|tiered|block|tou|cpp|real_time|formula.',
  `charge_category` STRING COMMENT 'Billing category classification indicating whether this is a base tariff charge, a rider (supplemental charge), surcharge, credit (reduction), adjustment clause, or tax component. Valid values: base|rider|surcharge|credit|adjustment|tax.',
  `component_code` STRING COMMENT 'Unique business identifier code for the rate component used in billing systems and tariff filings. Pattern: ^[A-Z0-9_]{2,20}$.',
  `component_description` STRING COMMENT 'Detailed business description of the rate component, its purpose, and how it is calculated. Used for customer communications, tariff documentation, and internal training.',
  `component_name` STRING COMMENT 'Human-readable name of the rate component as it appears on customer bills and tariff documents.',
  `component_type` STRING COMMENT 'Classification of the rate component indicating the nature of the charge. Energy charges are based on kWh consumption, demand charges on peak kW usage, customer charges are fixed monthly fees, fuel adjustment clauses recover fuel cost variations, distribution charges cover local delivery infrastructure, and transmission charges cover high-voltage grid costs. Valid values: energy_charge|demand_charge|customer_charge|fuel_adjustment|distribution_charge|transmission_charge.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this rate component record was first created in the system.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the rate value (e.g., USD, CAD, MXN). Pattern: ^[A-Z]{3}$.',
  `customer_class_applicability` STRING COMMENT 'Indicates which customer classes this rate component applies to. Rate components may be specific to residential, commercial, industrial, or other customer segments. Valid values: residential|commercial|industrial|agricultural|street_lighting|all_classes.',
  `decimal_precision` INT COMMENT 'Number of decimal places to retain in charge calculations for this component. Typically 2 for dollar amounts, but may be higher for per-unit rates or regulatory calculations.',
  `effective_end_date` DATE COMMENT 'Date when this rate component expires and is no longer applied to customer bills. Null indicates the component is currently active with no planned end date.',
  `effective_start_date` DATE COMMENT 'Date when this rate component becomes effective and can be applied to customer bills. Aligns with PUC rate case approval dates.',
  `gl_account_code` STRING COMMENT 'General ledger account code in the ERP system (SAP S/4HANA) where revenue from this rate component is posted for financial accounting. Pattern: ^[0-9]{4,10}$.',
  `index_reference` STRING COMMENT 'External market index or benchmark used to calculate this component if it is formula-based or indexed (e.g., Henry Hub natural gas price, PJM LMP, CPI). Null for fixed-rate components.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this rate component record was last updated in the system.',
  `maximum_charge` DECIMAL(18,2) COMMENT 'Maximum charge cap for this component. Used to limit exposure for certain rate components or to comply with regulatory caps.',
  `minimum_charge` DECIMAL(18,2) COMMENT 'Minimum charge amount that must be applied for this component regardless of usage. Common for customer charges and demand charges with minimum billing requirements.',
  `print_on_bill_flag` BOOLEAN COMMENT 'Indicates whether this rate component should appear as a separate line item on customer bills. True for customer-visible charges, False for internal calculation components that roll up into other line items.',
  `proration_method` STRING COMMENT 'Method used to prorate charges for partial billing periods (e.g., when a customer starts or stops service mid-cycle). Daily proration divides by days in period, calendar uses actual calendar days, billing uses billing cycle days. Valid values: daily|calendar_days|billing_days|none.',
  `puc_docket_number` STRING COMMENT 'Public Utility Commission docket or case number associated with the rate case that approved this component. Used for regulatory compliance tracking and audit trails. Pattern: ^[A-Z0-9-]{5,20}$.',
  `rate_value` DECIMAL(18,6) COMMENT 'The numeric rate or price applied per unit of measure. For example, $0.085 per kWh for energy charges, $15.00 per kW for demand charges, or $12.00 per account for customer charges.',
  `regulatory_account_code` STRING COMMENT 'FERC Uniform System of Accounts code or state regulatory accounting code used for revenue recognition and regulatory reporting of charges from this component. Pattern: ^[0-9]{3,6}$.',
  `revenue_class` STRING COMMENT 'Classification of revenue type for financial and regulatory reporting. Aligns with FERC revenue categories and state regulatory reporting requirements. Valid values: base_revenue|fuel_revenue|distribution_revenue|transmission_revenue|other_revenue.',
  `rider_code` STRING COMMENT 'Short code identifying the rider or surcharge if this component is a supplemental charge (e.g., FAC for Fuel Adjustment Clause, EEC for Energy Efficiency Charge, REC for Renewable Energy Charge). Null for base rate components. Pattern: ^[A-Z]{1,5}$.',
  `rounding_rule` STRING COMMENT 'Rounding method applied to calculated charges for this component. Round_half_up is standard commercial rounding, round_down always rounds down, round_up always rounds up, truncate drops decimals. Valid values: none|round_half_up|round_down|round_up|truncate.',
  `seasonal_applicability` STRING COMMENT 'Indicates which season or time period this rate component applies to. Many utilities have different rates for summer (high cooling demand) versus winter periods. Reference-value candidates: year_round|summer|winter|spring|fall|peak_season|off_peak_season.',
  `tariff_sheet_reference` STRING COMMENT 'Reference to the specific tariff sheet number or section in the official tariff book where this rate component is documented. Used for regulatory compliance and customer inquiries.',
  `tax_exempt_flag` BOOLEAN COMMENT 'Indicates whether this rate component is exempt from sales tax or other taxes. True if exempt, False if taxable.',
  `tier_sequence` INT COMMENT 'Sequence number for tiered or block rate structures, indicating the order of rate tiers (1 for first tier, 2 for second tier, etc.). Null for non-tiered components.',
  `tier_threshold_max` DECIMAL(18,3) COMMENT 'Maximum usage threshold for this tier in the specified unit of measure. Null indicates no upper limit (open-ended tier). Null for non-tiered components.',
  `tier_threshold_min` DECIMAL(18,3) COMMENT 'Minimum usage threshold for this tier in the specified unit of measure. For example, tier 1 might be 0 kWh, tier 2 might be 500 kWh. Null for non-tiered components.',
  `tou_end_time` TIMESTAMP COMMENT 'End time for the TOU period in HH:MM format (24-hour clock). For example, on-peak might end at 21:00. Null for non-TOU components.',
  `tou_period` STRING COMMENT 'Time-of-use period classification for TOU rate structures. On-peak represents highest demand periods, off-peak represents lowest demand periods, critical-peak represents emergency high-demand events. Valid values: on_peak|mid_peak|off_peak|super_off_peak|critical_peak|all_hours.',
  `tou_start_time` TIMESTAMP COMMENT 'Start time for the TOU period in HH:MM format (24-hour clock). For example, on-peak might start at 14:00. Null for non-TOU components.',
  `unit_of_measure` STRING COMMENT 'The unit of measure for this rate component. Common values include kWh (kilowatt-hour) for energy consumption, kW (kilowatt) for demand, account for fixed customer charges, day/month for time-based charges. Reference-value candidates: kWh|kW|MWh|MW|account|day|month|therm|ccf.',
  `voltage_level` STRING COMMENT 'Voltage level at which service is delivered, affecting rate component applicability. Secondary is typical residential (120/240V), primary is distribution (4-35kV), sub-transmission (35-138kV), transmission (>138kV). Valid values: secondary|primary|sub_transmission|transmission|all_levels.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_rate_component` PRIMARY KEY (`rate_component_id`)
)
USING DELTA
COMMENT 'Granular rate component definitions within a rate schedule, capturing individual charge elements such as energy charges ($/kWh), demand charges ($/kW), customer charges, fuel adjustment clauses, distribution charges, transmission charges, and riders. Stores component type, unit of measure, tier thresholds, seasonal applicability, and calculation formula. Enables precise bill calculation for all rate structures including tiered and TOU. | CMM: CIM Charge (close), IEC61968::PaymentMetering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'RateComponent',
  'cmm.cim.class' = 'Charge',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::PaymentMetering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'reference_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.rate_component'
);

-- BillingServiceAgreement  <<CIM CustomerAgreement : close>>
CREATE TABLE IF NOT EXISTS `billing`.`billing_service_agreement` (
  `billing_service_agreement_id` BIGINT NOT NULL COMMENT 'Unique identifier for the billing service agreement. Primary key for this entity representing the contractual billing relationship between the utility and customer.',
  `account_id` BIGINT COMMENT 'Reference to the customer account that owns this billing service agreement.',
  `billing_rate_schedule_id` BIGINT COMMENT 'FK to billing.rate_schedule',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: Service agreements track DER installations at customer premises for net metering billing, export compensation, and demand response programs. Essential for calculating NEM credits, managing export limi',
  `meter_point_id` BIGINT COMMENT 'Foreign key linking to metering.meter_point. Business justification: Service agreements govern specific service points (the contract-to-location binding). Rate schedules, service voltage, and billing cycles are service-point-specific. This link is essential for service',
  `nem_account_id` BIGINT COMMENT 'Foreign key linking to renewable.nem_account. Business justification: Service agreements have 1:1 relationship with NEM accounts for net metering customers. Required to link billing terms, rate schedules, and payment arrangements to specific NEM credit tracking, true-up',
  `premise_id` BIGINT COMMENT 'Reference to the premise (service location) where energy is delivered under this agreement.',
  `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: Special contract service agreements and non-standard tariff arrangements require regulatory approval and disclosure in filings. Links agreements to the filing where they were approved or reported for',
  `service_connection_asset_registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: Service agreements reference the specific delivery asset (transformer, service lateral, connection point) serving the premise. Field operations use this for capacity planning, service upgrades, and ou',
  `agreement_number` STRING COMMENT 'Externally visible business identifier for the service agreement, used in customer communications and billing statements.',
  `agreement_type` STRING COMMENT 'Classification of the billing service agreement based on customer class and service characteristics. Determines applicable rate structures and regulatory treatment. Valid values: residential|commercial|industrial|nem|municipal|agricultural.',
  `autopay_flag` BOOLEAN COMMENT 'Indicates whether the customer is enrolled in automatic payment program where invoices are paid automatically on due date.',
  `billing_agreement_uses_rate_schedule` BIGINT COMMENT 'FK to billing.rate_schedule.rate_schedule_id — Each service agreement is assigned a rate schedule that governs how the account is billed. This is a fundamental billing relationship — without it, the billing engine cannot determine which rates to a',
  `billing_cycle_code` STRING COMMENT 'Code identifying the billing cycle schedule that determines invoice generation frequency and due dates for this agreement.',
  `billing_frequency` STRING COMMENT 'Frequency at which invoices are generated for this service agreement. Valid values: monthly|bimonthly|quarterly|annual.',
  `billing_service_agreement_status` STRING COMMENT 'Current lifecycle status of the billing service agreement indicating whether it is actively generating invoices and accepting payments. Valid values: active|pending|suspended|terminated|cancelled|inactive.',
  `budget_billing_amount` DECIMAL(15,2) COMMENT 'Fixed monthly payment amount for customers enrolled in budget billing program. Recalculated periodically based on usage history.',
  `budget_billing_flag` BOOLEAN COMMENT 'Indicates whether the customer is enrolled in budget billing program that spreads annual energy costs into equal monthly payments.',
  `contract_capacity_kw` DECIMAL(12,2) COMMENT 'Contracted maximum demand capacity in kilowatts for large commercial or industrial customers. Basis for capacity charges and penalties for exceeding contracted demand.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this billing service agreement record was first created in the system.',
  `credit_hold_flag` BOOLEAN COMMENT 'Indicates whether this service agreement is on credit hold due to payment delinquency or credit risk, potentially restricting service or requiring prepayment.',
  `demand_metered_flag` BOOLEAN COMMENT 'Indicates whether this service agreement includes demand metering and demand charges based on peak kW usage.',
  `deposit_amount` DECIMAL(15,2) COMMENT 'Amount of security deposit held for this service agreement. Subject to interest accrual per state PUC regulations.',
  `deposit_date` DATE COMMENT 'Date when the security deposit was received from the customer.',
  `deposit_required_flag` BOOLEAN COMMENT 'Indicates whether a security deposit is required for this service agreement based on credit profile or regulatory requirements.',
  `disconnect_pending_flag` BOOLEAN COMMENT 'Indicates whether a service disconnection order is pending for this agreement due to non-payment or other reasons.',
  `dunning_block_flag` BOOLEAN COMMENT 'Indicates whether collections and dunning activities are blocked for this service agreement due to payment arrangement, dispute, or special circumstances.',
  `dunning_block_reason` STRING COMMENT 'Explanation for why dunning activities are blocked, such as active payment plan, billing dispute, or regulatory protection.',
  `effective_end_date` DATE COMMENT 'Date when the billing service agreement terminates and billing ceases. Nullable for open-ended agreements. Aligns with service disconnection or move-out date.',
  `effective_start_date` DATE COMMENT 'Date when the billing service agreement becomes active and billing begins. Aligns with service connection or move-in date.',
  `last_modified_by` STRING COMMENT 'User ID or system identifier of the person or process that last modified this service agreement record.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this billing service agreement record was last updated.',
  `life_support_flag` BOOLEAN COMMENT 'Indicates whether the premise has registered life support medical equipment requiring continuous power. Provides regulatory protection from disconnection.',
  `load_profile_type` STRING COMMENT 'Classification of the customer load profile and associated rate structure. Determines whether Time of Use, Critical Peak Pricing, or Real Time Pricing applies. Valid values: flat|tou|cpp|rtp|critical_peak_rebate.',
  `low_income_assistance_flag` BOOLEAN COMMENT 'Indicates whether the customer qualifies for and is enrolled in low income energy assistance programs such as LIHEAP or CARE.',
  `nem_flag` BOOLEAN COMMENT 'Indicates whether this service agreement participates in Net Energy Metering program for distributed generation customers with solar or other renewable energy systems.',
  `nem_program_type` STRING COMMENT 'Specific NEM program version and structure applicable to this agreement. Different versions have varying compensation rates and rules. Valid values: nem_1_0|nem_2_0|nem_3_0|vnem|aggregated_nem.',
  `paperless_billing_flag` BOOLEAN COMMENT 'Indicates whether the customer has opted for electronic invoice delivery instead of paper bills.',
  `payment_arrangement_flag` BOOLEAN COMMENT 'Indicates whether the customer has an active payment arrangement or installment plan for past due balances on this service agreement.',
  `payment_method` STRING COMMENT 'Primary payment instrument the customer uses to pay invoices for this service agreement. Valid values: bank_draft|credit_card|check|cash|electronic_transfer|autopay.',
  `revenue_class` STRING COMMENT 'Revenue accounting classification for financial reporting and regulatory compliance. Determines how revenue is recognized and reported to FERC and state PUCs. Reference-value candidates: residential|small_commercial|large_commercial|industrial|agricultural|street_lighting|public_authority.',
  `service_voltage_level` STRING COMMENT 'Voltage level at which electric service is delivered to the customer. Affects rate structure and delivery charges. Valid values: secondary|primary|subtransmission|transmission.',
  `special_contract_flag` BOOLEAN COMMENT 'Indicates whether this service agreement operates under a special negotiated contract with non-standard rates or terms, typically for large industrial customers.',
  `special_contract_terms` STRING COMMENT 'Description of special contractual terms, pricing arrangements, or service level commitments that deviate from standard tariff schedules.',
  `termination_reason` STRING COMMENT 'Reason code or description explaining why the service agreement was terminated, such as customer move-out, non-payment disconnection, or service transfer.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_billing_service_agreement` PRIMARY KEY (`billing_service_agreement_id`)
)
USING DELTA
COMMENT 'Master entity representing the contractual billing relationship between the utility and a customer account for energy delivery at a specific service point. Captures agreement type (residential, commercial, industrial, NEM), assigned rate schedule, effective and end dates, deposit requirements, budget billing enrollment status, special contract terms, and service point reference. SSOT for the active billing relationship that drives invoice generation, payment application, collections, and all downstream billing activity. Sourced from SAP IS-U contract account and Oracle CC&B service agreement modules. | CMM: CIM CustomerAgreement (close), IEC61968::Customers.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'BillingServiceAgreement',
  'cmm.cim.class' = 'CustomerAgreement',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Customers',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.billing_service_agreement'
);

-- CustomerInvoice  <<CIM CustomerBillingInfo : close>>
CREATE TABLE IF NOT EXISTS `billing`.`invoice` (
  `invoice_id` BIGINT NOT NULL COMMENT 'Unique system identifier for the utility invoice. Primary key.',
  `account_id` BIGINT COMMENT 'Reference to the customer account for which this invoice was generated.',
  `billing_run_id` BIGINT COMMENT 'Foreign key linking to billing.billing_run. Business justification: Each invoice is created by a specific billing run execution (batch job). This FK enables tracing invoices back to the exact run that generated them, critical for exception handling, reprocessing, and',
  `billing_service_agreement_id` BIGINT COMMENT 'Foreign key linking to billing.billing_service_agreement. Business justification: An invoice is generated FOR a specific service agreement (the contractual billing relationship between utility and customer). While invoice currently has account_id and premise_id, it lacks the direct',
  `cycle_id` BIGINT COMMENT 'Foreign key linking to billing.billing_cycle. Business justification: Each invoice is generated as part of a specific billing cycle execution. Currently invoice has billing_cycle_code (STRING) but no FK to the billing_cycle entity. This FK enables joining to retrieve cy',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Invoices post revenue to specific GL accounts for financial statement preparation and regulatory reporting. Every billed revenue transaction requires GL account assignment per FERC Uniform System of A',
  `invoice_for_service_agreement` BIGINT COMMENT 'FK to billing.billing_service_agreement.billing_service_agreement_id — Every invoice is generated for a specific service agreement. This is the core billing relationship — without it, invoices cannot be tied to the customer\'s contractual billing arrangement, rate schedul',
  `meter_point_id` BIGINT COMMENT 'Foreign key linking to metering.meter_point. Business justification: Invoices bill specific service points (meter_point). This link is fundamental for rate application, network cost allocation, and regulatory reporting by service location. Every invoice must identify w',
  `nem_account_id` BIGINT COMMENT 'Foreign key linking to renewable.nem_account. Business justification: Invoices apply NEM credits from specific NEM accounts, track cumulative credit balances, and perform annual true-up settlements. Critical for accurate billing of net metering customers, ensuring prope',
  `premise_id` BIGINT COMMENT 'Reference to the service premise where energy was consumed during this billing period.',
  `service_territory_id` BIGINT COMMENT 'Foreign key linking to distribution.service_territory. Business justification: Invoices require service territory reference for revenue allocation by jurisdiction, regulatory reporting (PUC filings), jurisdictional tax calculation, and franchise fee assessment. Critical for mult',
  `trade_id` BIGINT COMMENT 'Foreign key linking to trading.trade. Business justification: Bilateral wholesale energy trades delivered outside ISO markets generate direct customer invoices requiring trade reference for settlement reconciliation, revenue recognition, and regulatory audit tra',
  `adjustment_amount` DECIMAL(18,2) COMMENT 'Total adjustments applied to the invoice including credits, refunds, billing corrections, and dispute resolutions. Positive for credits, negative for additional charges.',
  `auto_pay_flag` BOOLEAN COMMENT 'Indicates whether this invoice is enrolled in automatic payment processing from a bank account or credit card.',
  `bill_message_code` STRING COMMENT 'Code identifying special messages or notices printed on the invoice (e.g., disconnection warning, rate change notice, energy efficiency tips).',
  `billing_cycle` BIGINT COMMENT 'FK to billing.billing_cycle.billing_cycle_id — Every invoice is generated within a billing cycle run. Critical for billing operations monitoring and batch reconciliation.',
  `billing_cycle_code` STRING COMMENT 'Code identifying the billing cycle schedule to which this invoice belongs (e.g., monthly cycle 01, cycle 15).',
  `billing_days` INT COMMENT 'Number of days in the billing period, used for prorating charges and calculating daily averages.',
  `billing_period_end_date` DATE COMMENT 'Last date of the billing period for which energy consumption and charges are calculated.',
  `billing_period_start_date` DATE COMMENT 'First date of the billing period for which energy consumption and charges are calculated.',
  `budget_billing_flag` BOOLEAN COMMENT 'Indicates whether this invoice is part of a budget billing plan where monthly charges are levelized based on annual consumption estimates.',
  `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this invoice record was first created in the billing system.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts on this invoice (e.g., USD, CAD, EUR). Pattern: ^[A-Z]{3}$.',
  `current_charges_amount` DECIMAL(18,2) COMMENT 'Total charges for the current billing period including energy, demand, customer charges, riders, and fees before taxes.',
  `delivery_method` STRING COMMENT 'Method by which the invoice was delivered to the customer. Valid values: postal_mail|email|customer_portal|sms.',
  `deposit_applied_amount` DECIMAL(18,2) COMMENT 'Customer security deposit amount applied to this invoice, typically at service termination or account closure.',
  `dispute_flag` BOOLEAN COMMENT 'Indicates whether this invoice is currently under dispute by the customer, requiring resolution before collections action.',
  `due_date` DATE COMMENT 'Date by which payment must be received to avoid late fees or service disconnection.',
  `energy_consumption_kwh` DECIMAL(18,3) COMMENT 'Total electric energy consumed during the billing period measured in kilowatt-hours (kWh). Calculated from meter readings or AMI interval data.',
  `from_billing_cycle` BIGINT COMMENT 'FK to billing.billing_cycle.billing_cycle_id — Invoices are generated as part of a billing cycle run. This FK supports billing operations monitoring, cycle-level revenue reconciliation, and workload management.',
  `gl_posting_date` DATE COMMENT 'Date when this invoice was posted to the general ledger accounts receivable.',
  `invoice_date` DATE COMMENT 'Date the invoice was generated and issued to the customer. Principal business event timestamp for the transaction.',
  `invoice_number` STRING COMMENT 'Externally visible, customer-facing invoice number printed on the bill. Unique business identifier for the invoice.',
  `invoice_status` STRING COMMENT 'Current lifecycle status of the invoice in the billing and collections workflow. Reference-value candidates: draft|issued|sent|paid|partially_paid|overdue|cancelled|disputed|adjusted|written_off.',
  `invoice_type` STRING COMMENT 'Classification of the invoice based on billing purpose: regular cycle bill, final bill at move-out, interim bill, adjustment bill, credit memo, or debit memo. Valid values: regular|final|interim|adjustment|credit|debit.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this invoice record was last updated, capturing adjustments, payment applications, or status changes.',
  `late_fee_amount` DECIMAL(18,2) COMMENT 'Late payment fee assessed on this invoice for overdue balances from prior billing periods.',
  `meter_read_end_date` DATE COMMENT 'Date of the meter reading at the end of the billing period.',
  `meter_read_start_date` DATE COMMENT 'Date of the meter reading at the beginning of the billing period.',
  `outstanding_balance_amount` DECIMAL(18,2) COMMENT 'Remaining unpaid balance on this invoice after payments have been applied.',
  `paperless_billing_flag` BOOLEAN COMMENT 'Indicates whether the customer has opted for electronic delivery of this invoice instead of paper mail.',
  `payment_arrangement_flag` BOOLEAN COMMENT 'Indicates whether this invoice is subject to a payment arrangement or installment plan for past-due balances.',
  `payment_received_amount` DECIMAL(18,2) COMMENT 'Total payments received against this invoice to date.',
  `peak_demand_kw` DECIMAL(18,3) COMMENT 'Maximum electric demand recorded during the billing period measured in kilowatts (kW). Used for demand-based rate calculations.',
  `previous_balance_amount` DECIMAL(18,2) COMMENT 'Outstanding balance carried forward from prior billing periods before current charges are applied.',
  `print_date` DATE COMMENT 'Date when the physical or electronic invoice document was generated and prepared for delivery to the customer.',
  `rate_class` STRING COMMENT 'Customer rate classification determining applicable tariff structures and regulatory treatment. Valid values: residential|commercial|industrial|agricultural|municipal|street_lighting.',
  `rate_schedule_code` STRING COMMENT 'Tariff rate schedule code applied to this invoice, defining the pricing structure for energy and demand charges.',
  `revenue_recognition_date` DATE COMMENT 'Date when revenue from this invoice is recognized in the general ledger for financial reporting purposes.',
  `service_agreement` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — Every invoice is generated for a specific service agreement. This is the core billing transaction-to-master relationship.',
  `service_end_date` DATE COMMENT 'Date when utility service ended for this billing period, relevant for disconnections or final bills.',
  `service_start_date` DATE COMMENT 'Date when utility service began for this billing period, relevant for new connections or service resumptions.',
  `tax_amount` DECIMAL(18,2) COMMENT 'Total taxes applied to the invoice including sales tax, utility tax, and other regulatory taxes.',
  `to_cycle` BIGINT COMMENT 'FK to billing.billing_cycle.billing_cycle_id — Every invoice is generated within a billing cycle run. This FK supports billing operations monitoring and revenue cycle timing.',
  `to_sa` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — Every invoice is generated for a specific service agreement. This FK is essential for tracing billed amounts back to the contractual billing relationship.',
  `total_amount_due` DECIMAL(18,2) COMMENT 'Net total amount the customer must pay, calculated as previous balance plus current charges plus taxes plus adjustments.',
  `write_off_amount` DECIMAL(18,2) COMMENT 'Amount of this invoice written off as uncollectible bad debt, subject to SOX financial controls and regulatory reporting.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_invoice` PRIMARY KEY (`invoice_id`)
)
USING DELTA
COMMENT 'Core transactional entity representing a utility bill issued to a customer for a billing period, including header-level totals and granular line-item charge detail. At the header level: captures invoice number, billing period dates, due date, total amount due, energy consumed (kWh/MWh), demand (kW), prior balance, current charges, taxes, adjustments, and payment status. At the line level: captures individual charge components including energy charges, demand charges, customer charges, fuel adjustment clauses, distribution riders, taxes, and credits with rate component reference, quantity, unit rate, calculated amount, and applicable billing determinant. Generated from Oracle CC&B and SAP IS-U billing engine. SSOT for all customer-facing billing documents and their charge detail. Supports SOX AR controls, granular revenue recognition, rate component-level analysis, and regulatory rate case evidence. | CMM: CIM CustomerBillingInfo (close), IEC61968::InfCustomers.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CustomerInvoice',
  'cmm.cim.class' = 'CustomerBillingInfo',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfCustomers',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.invoice'
);

-- InvoiceLine  <<CIM ErpInvoiceLineItem : close>>
CREATE TABLE IF NOT EXISTS `billing`.`invoice_line` (
  `invoice_line_id` BIGINT NOT NULL COMMENT 'Unique identifier for the invoice line item. Primary key for the invoice line detail record.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Revenue allocation to cost centers enables internal performance reporting, cost-of-service studies for rate cases, and regulatory reporting by functional area. Essential for FERC Form 1 preparation an',
  `dr_incentive_payment_id` BIGINT COMMENT 'Foreign key linking to demand.dr_incentive_payment. Business justification: Individual invoice line items represent specific DR incentive credits at granular level. Detailed billing reconciliation, audit trails, dispute resolution, and regulatory reporting require line-level',
  `from_rate_component_id` BIGINT COMMENT 'FK to billing.rate_component.rate_component_id — Each invoice line item is calculated from a specific rate component. This FK enables rate-component-level revenue analysis and bill audit trails. Critical for regulatory rate case support.',
  `invoice_rate_component_id` BIGINT COMMENT 'Foreign key linking to billing.rate_component. Business justification: Each invoice line item is calculated using a specific rate component definition from the rate schedule. Currently invoice_line has rate_component_code (STRING) which is a denormalized reference. Addin',
  `original_line_invoice_line_id` BIGINT COMMENT 'Reference to the original invoice line item being reversed or corrected. Null for original charges. Maintains audit trail for billing adjustments.',
  `primary_invoice_id` BIGINT COMMENT 'Reference to the parent invoice header. Links this line item to the billing document.',
  `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Revenue attribution to profit centers supports segment reporting, FERC functional classification (generation/transmission/distribution), and business unit profitability analysis. Required for regulato',
  `sox_control_test_id` BIGINT COMMENT 'Foreign key linking to compliance.sox_control_test. Business justification: SOX control testing samples specific invoice line items to verify billing accuracy controls and revenue recognition. Links the tested line item to the control test for audit evidence, sample documenta',
  `trade_id` BIGINT COMMENT 'Foreign key linking to trading.trade. Business justification: Individual invoice line items may represent specific wholesale trade settlements, particularly for bilateral contracts with retail pass-through pricing where each trade leg generates a separate billin',
  `adjustment_description` STRING COMMENT 'Human-readable description of the adjustment reason for customer communication and audit trail. Null for standard charges.',
  `adjustment_reason_code` STRING COMMENT 'Code identifying the reason for any adjustment applied to this line item (e.g., REBILL, CREDIT, DISPUTE, CORRECTION). Null for standard charges. Pattern: ^[A-Z0-9_]{2,10}$.',
  `billing_determinant_quantity` DECIMAL(18,6) COMMENT 'Quantity of the billing determinant used in the rate calculation (e.g., kWh consumed, peak kW demand, number of days). Precision supports interval meter data.',
  `billing_determinant_type` STRING COMMENT 'Type of billing determinant used to calculate this charge (e.g., kWh for energy consumption, kW for demand, days for fixed charges, percentage for adjustments). Reference-value candidates: kwh|kw|mwh|mw|days|units|flat|percentage.',
  `charge_category` STRING COMMENT 'High-level classification of the charge type for revenue recognition and financial reporting. Groups rate components into standard categories. Reference-value candidates: energy|demand|customer|distribution|transmission|generation|tax|fee|adjustment|credit|rebate|penalty.',
  `consumption_kwh` DECIMAL(18,3) COMMENT 'Energy consumption in kilowatt-hours for this line item. Primary billing determinant for energy charges. Null for non-energy charges.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this invoice line item record was first created in the billing system. Supports audit trail and data lineage for SOX compliance.',
  `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the line item amounts. Supports multi-currency billing for international operations. Valid values: USD|CAD|MXN|EUR|GBP.',
  `demand_kw` DECIMAL(18,3) COMMENT 'Peak demand in kilowatts for this line item. Primary billing determinant for demand charges. Null for non-demand charges.',
  `dispute_flag` BOOLEAN COMMENT 'Indicates whether this line item is under customer dispute. True if disputed, false otherwise. Supports dispute resolution and collections workflows.',
  `gl_account_code` STRING COMMENT 'General ledger account code for revenue recognition posting. Maps line item to chart of accounts for financial reporting and SOX compliance. Pattern: ^[0-9]{4,10}$.',
  `line_amount` DECIMAL(18,2) COMMENT 'Calculated charge amount for this line item before taxes and adjustments. Result of billing determinant quantity multiplied by unit rate, or flat charge amount.',
  `line_sequence_number` INT COMMENT 'Sequential ordering of line items within the invoice. Determines display order on customer bill.',
  `meter_read_end_date` DATE COMMENT 'Date of the ending meter read used to calculate consumption for this charge. May differ from service period end for estimated or prorated bills.',
  `meter_read_start_date` DATE COMMENT 'Date of the beginning meter read used to calculate consumption for this charge. May differ from service period start for estimated or prorated bills.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this invoice line item record was last modified. Supports audit trail and change tracking for SOX compliance.',
  `print_sequence` INT COMMENT 'Display order for this line item on the printed or electronic customer bill. Controls presentation layout for customer readability.',
  `print_suppress_flag` BOOLEAN COMMENT 'Indicates whether this line item should be suppressed from customer bill presentation. True if suppressed (internal accounting only), false if displayed to customer.',
  `proration_factor` DECIMAL(8,6) COMMENT 'Proration multiplier applied to this charge for partial billing periods (e.g., 0.5 for half-month service). Value of 1.0 indicates full period charge.',
  `rate_component_description` STRING COMMENT 'Human-readable description of the rate component or charge type for customer bill presentation (e.g., \'Energy Charge\', \'Demand Charge\', \'Customer Charge\', \'Fuel Adjustment Clause\').',
  `rate_schedule_code` STRING COMMENT 'Code identifying the tariff rate schedule applied to this line item (e.g., RES-1, COM-2, IND-3). Links to approved tariff structure. Pattern: ^[A-Z0-9_-]{2,20}$.',
  `rate_version` STRING COMMENT 'Effective date version of the rate schedule applied to this line item. Supports rate change tracking and historical billing accuracy. Pattern: ^[0-9]{4}-[0-9]{2}-[0-9]{2}$.',
  `revenue_class` STRING COMMENT 'Customer class for revenue reporting and regulatory compliance. Aligns with FERC and state PUC revenue classification requirements. Valid values: residential|commercial|industrial|agricultural|public_authority|street_lighting.',
  `reversal_flag` BOOLEAN COMMENT 'Indicates whether this line item is a reversal of a previous charge. True for reversal entries, false for original charges. Supports rebilling and correction workflows.',
  `service_period_end_date` DATE COMMENT 'End date of the service period covered by this line item charge. Defines the end of the consumption or service window.',
  `service_period_start_date` DATE COMMENT 'Start date of the service period covered by this line item charge. Defines the beginning of the consumption or service window.',
  `source_line_reference` STRING COMMENT 'Original line item identifier from the source billing system. Maintains traceability to operational system of record for reconciliation and troubleshooting.',
  `source_system_code` STRING COMMENT 'Code identifying the source billing system that generated this invoice line item. Supports multi-system integration and data lineage tracking. Valid values: SAP_ISU|ORACLE_CCB|LEGACY_CIS.',
  `tax_amount` DECIMAL(18,2) COMMENT 'Tax amount applied to this line item. May include sales tax, utility tax, franchise fees, or other jurisdiction-specific taxes.',
  `tax_jurisdiction_code` STRING COMMENT 'Code identifying the tax jurisdiction for this line item. Determines applicable tax rates and rules. Null for non-taxable items. Pattern: ^[A-Z0-9_-]{2,10}$.',
  `taxable_flag` BOOLEAN COMMENT 'Indicates whether this line item is subject to sales tax or utility tax. True if taxable, false if exempt.',
  `tier_level` INT COMMENT 'Tier number for tiered rate structures (e.g., 1 for baseline, 2 for tier 2, 3 for tier 3). Null for non-tiered charges. Supports inclining block and declining block rate designs.',
  `total_line_amount` DECIMAL(18,2) COMMENT 'Total amount for this line item including taxes and adjustments. Sum of line amount and tax amount.',
  `tou_period_code` STRING COMMENT 'Time-of-use period classification for this charge. Identifies whether consumption occurred during on-peak, off-peak, or other TOU periods. Null for non-TOU charges. Valid values: on_peak|off_peak|mid_peak|super_off_peak|critical_peak|standard.',
  `unit_rate` DECIMAL(18,8) COMMENT 'Rate per unit applied to the billing determinant (e.g., dollars per kWh, dollars per kW, daily charge). High precision supports complex tariff calculations including TOU and CPP rates.',
  `write_off_flag` BOOLEAN COMMENT 'Indicates whether this line item has been written off as uncollectible. True if written off, false otherwise. Supports bad debt accounting and SOX controls.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_invoice_line` PRIMARY KEY (`invoice_line_id`)
)
USING DELTA
COMMENT 'Line-item detail for each charge component on a utility invoice, including energy charges, demand charges, customer charges, fuel adjustment clauses, distribution riders, taxes, and credits. Stores rate component reference, quantity, unit rate, calculated amount, and applicable billing determinant. Enables granular revenue recognition and rate component-level analysis. Sourced from SAP IS-U FICA and Oracle CC&B billing line detail. | CMM: CIM ErpInvoiceLineItem (close), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'InvoiceLine',
  'cmm.cim.class' = 'ErpInvoiceLineItem',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.invoice_line'
);

-- CustomerPayment  <<CIM Transaction : close>>
CREATE TABLE IF NOT EXISTS `billing`.`payment` (
  `payment_id` BIGINT NOT NULL COMMENT 'Unique identifier for the payment transaction record. Primary key for the payment entity.',
  `account_id` BIGINT COMMENT 'Reference to the customer account against which this payment or refund is applied. Links to the customer account master record in the billing system.',
  `invoice_id` BIGINT COMMENT 'FK to billing.invoice.invoice_id — Payments are applied against invoices (or account balances). This FK is essential for AR clearing, cash application, and payment status tracking. Note: in open-item accounting (SAP FICA), payments may',
  `payment_arrangement_id` BIGINT COMMENT 'Reference to the payment arrangement or installment plan if this payment is part of a structured payment agreement. Null for standard payments.',
  `payment_invoice_id` BIGINT COMMENT 'Reference to the specific invoice being paid. Null for account-level payments or refunds not tied to a specific invoice.',
  `to_invoice_id` BIGINT COMMENT 'FK to billing.invoice.invoice_id — Payments are applied against specific invoices (or account balances). This FK is critical for cash application and AR reconciliation.',
  `amount` DECIMAL(18,2) COMMENT 'Monetary value of the payment or refund transaction in the billing currency. Positive values for inbound payments, may be positive or negative depending on system convention for refunds.',
  `application_status` STRING COMMENT 'Status indicating whether and how the payment has been applied to outstanding invoices or account balance. Tracks cash application workflow completion. Valid values: unapplied|partially_applied|fully_applied|suspended|reversed.',
  `applied_amount` DECIMAL(18,2) COMMENT 'Portion of the payment amount that has been successfully applied to invoices or account balance. May differ from payment_amount if payment is partially applied or includes unapplied credit.',
  `authorization_code` STRING COMMENT 'Authorization or approval code returned by the payment processor or card network confirming the transaction was approved. Used for reconciliation and dispute resolution.',
  `auto_pay_enrollment_flag` BOOLEAN COMMENT 'Indicates whether this payment was processed as part of an automatic payment enrollment. True for auto-pay transactions, false for manual payments.',
  `bank_account_number_masked` STRING COMMENT 'Masked or tokenized bank account number for ACH payments. Only last 4 digits visible for PCI compliance and fraud prevention. Full account number stored in secure vault.',
  `bank_routing_number` STRING COMMENT 'Nine-digit American Bankers Association routing transit number identifying the financial institution for ACH or check payments. Confidential financial data. Pattern: ^[0-9]{9}$.',
  `batch_reference` STRING COMMENT 'Identifier for the payment processing batch if this payment was processed as part of a batch run. Used for lockbox processing, bulk ACH imports, and batch reconciliation.',
  `card_expiration_month` INT COMMENT 'Month component of the payment card expiration date (1-12). Used for recurring payment validation and auto-pay processing.',
  `card_expiration_year` INT COMMENT 'Four-digit year component of the payment card expiration date. Used for recurring payment validation and auto-pay processing.',
  `card_last_four_digits` STRING COMMENT 'Last four digits of the payment card number for customer reference and dispute resolution. Full card number never stored per PCI DSS requirements. Pattern: ^[0-9]{4}$.',
  `card_type` STRING COMMENT 'Credit or debit card network brand for card-based payments. Null for non-card payment methods. Valid values: visa|mastercard|amex|discover|other.',
  `channel` STRING COMMENT 'Customer interface or channel through which the payment was submitted. Distinguishes self-service digital channels from assisted or physical channels. Reference-value candidates: web_portal|mobile_app|ivr|walk_in|mail|bank_draft|third_party_agent.',
  `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this payment record was first created in the billing system. Part of the audit trail for data lineage and SOX compliance.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the payment transaction. Typically USD for US-based utilities but may vary for international operations. Pattern: ^[A-Z]{3}$.',
  `disbursement_confirmation_number` STRING COMMENT 'Confirmation or tracking number for the refund disbursement. May be check number, ACH trace number, or wire transfer confirmation. Null for inbound payments.',
  `disbursement_date` DATE COMMENT 'Date when the refund check was issued or electronic refund was transmitted. Null for inbound payments or pending refunds.',
  `gl_account_code` STRING COMMENT 'General ledger account code to which this payment transaction is posted. Typically a cash or accounts receivable account per the utility chart of accounts.',
  `last_modified_by` STRING COMMENT 'User ID or system identifier that last modified this payment record. Part of the audit trail for SOX compliance and change management.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this payment record was last updated. Tracks all modifications for audit trail and change tracking.',
  `lockbox_number` STRING COMMENT 'Bank lockbox identifier for payments received via lockbox processing service. Null for non-lockbox payments.',
  `notes` STRING COMMENT 'Free-text notes or comments related to the payment transaction. May include customer instructions, dispute details, or special handling notes entered by customer service representatives.',
  `nsf_fee_assessed` DECIMAL(18,2) COMMENT 'Fee amount charged to the customer account for returned payment due to insufficient funds. Null if no NSF fee applies.',
  `payment_date` DATE COMMENT 'Business date when the payment was received or the refund was issued. For inbound payments, this is the date the payment was tendered by the customer. For outbound refunds, this is the disbursement date.',
  `payment_invoice` BIGINT COMMENT 'FK to billing.invoice.invoice_id — Payments are applied against specific invoices. Critical for AR balance calculation and cash application.',
  `payment_method` STRING COMMENT 'Financial instrument or mechanism used to tender the payment. Identifies whether payment was made via check, electronic funds transfer, card payment, or cash. Reference-value candidates: check|ach|credit_card|debit_card|cash|money_order|wire_transfer|online|auto_pay.',
  `payment_status` STRING COMMENT 'Current lifecycle status of the payment transaction. Tracks progression from initial receipt through clearing and application to customer account balance. Valid values: pending|applied|cleared|reversed|failed|cancelled.',
  `payment_timestamp` TIMESTAMP COMMENT 'Precise date and time when the payment transaction was recorded in the billing system. Used for audit trail and transaction sequencing.',
  `payment_type` STRING COMMENT 'Classification of the payment transaction direction and purpose. Inbound payments represent cash receipts from customers; outbound refunds represent disbursements to customers. Valid values: inbound_payment|outbound_refund|credit_memo|debit_memo|adjustment.',
  `posting_date` DATE COMMENT 'Accounting date when the payment transaction was posted to the general ledger. May differ from payment_date due to batch processing timing or period-end cutoffs.',
  `reference_number` STRING COMMENT 'External reference number or confirmation code for the payment transaction. May include check number, ACH trace number, credit card authorization code, or online payment confirmation ID.',
  `refund_approval_status` STRING COMMENT 'Workflow status for refund approval process. Tracks management review and authorization for outbound refund disbursements. Null for inbound payments. Valid values: pending_approval|approved|rejected|disbursed.',
  `refund_approval_timestamp` TIMESTAMP COMMENT 'Date and time when the refund was approved for disbursement. Part of the audit trail for financial controls. Null for inbound payments.',
  `refund_approved_by` STRING COMMENT 'User ID or name of the employee who authorized the refund disbursement. Required for SOX compliance and audit trail. Null for inbound payments.',
  `refund_method` STRING COMMENT 'Method by which the refund is disbursed to the customer. May be check, ACH transfer, account credit, or reversal to original payment method. Null for inbound payments. Valid values: check|ach|account_credit|original_payment_method.',
  `refund_reason_code` STRING COMMENT 'Standardized code indicating the business reason for issuing a refund to the customer. Null for inbound payments. Used for refund analytics and regulatory reporting. Valid values: overpayment|deposit_return|credit_balance|billing_error|service_cancellation|duplicate_payment.',
  `reversal_date` DATE COMMENT 'Date when the payment was reversed. Null if payment has not been reversed.',
  `reversal_flag` BOOLEAN COMMENT 'Indicates whether this payment transaction has been reversed due to NSF (non-sufficient funds), chargeback, or administrative correction. True if reversed, false otherwise.',
  `reversal_reason_code` STRING COMMENT 'Standardized code indicating the reason for payment reversal. Includes NSF returns, chargebacks, disputes, and administrative corrections. Null if payment has not been reversed. Valid values: nsf|chargeback|customer_dispute|bank_return|administrative_error|fraud.',
  `service_agreement` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — Payments may be applied at the account/service agreement level when not tied to a specific invoice (e.g., prepayments, deposits).',
  `source_system` STRING COMMENT 'Identifier of the source system or module that originated the payment transaction record. Examples include SAP IS-U FICA, Oracle CC&B, payment gateway integration, or third-party payment processor.',
  `to_sa` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — Payments are received for a customer service agreement. Needed when payments are applied at account level rather than invoice level.',
  `transaction_reference` STRING COMMENT 'Unique transaction identifier assigned by the payment gateway or processor. Used for reconciliation, chargebacks, and technical support inquiries.',
  `unapplied_amount` DECIMAL(18,2) COMMENT 'Portion of the payment amount that remains unapplied and held as account credit. Occurs when payment exceeds outstanding balance or when application is suspended pending dispute resolution.',
  `created_by` STRING COMMENT 'User ID or system identifier that created this payment record. May be a customer service representative, automated batch process, or payment gateway integration.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_payment` PRIMARY KEY (`payment_id`)
)
USING DELTA
COMMENT 'Transactional record of all customer payment activity including inbound payments received and outbound refunds disbursed against outstanding invoices or account balances. For inbound payments: captures payment date, amount, method (check, ACH, credit card, cash, online, auto-pay), channel (IVR, web, walk-in, mail), reference number, bank routing details, and application status. For outbound refunds: captures refund date, amount, disbursement method (check, ACH, account credit), reason code (overpayment, deposit return, credit balance, billing error), originating credit source, approval status, and disbursement confirmation. Sourced from SAP IS-U FICA and Oracle CC&B payment processing. SSOT for all cash receipts and disbursements in the revenue cycle. Supports cash application controls and SOX compliance. | CMM: CIM Transaction (close), IEC61968::PaymentMetering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CustomerPayment',
  'cmm.cim.class' = 'Transaction',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::PaymentMetering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.payment'
);

-- PaymentArrangement  <<CIM AuxiliaryAgreement : close>>
CREATE TABLE IF NOT EXISTS `billing`.`payment_arrangement` (
  `payment_arrangement_id` BIGINT NOT NULL COMMENT 'Unique identifier for the payment arrangement. Primary key for this entity.',
  `account_id` BIGINT COMMENT 'Reference to the customer account for which this payment arrangement was established.',
  `employee_id` BIGINT COMMENT 'Reference to the customer service representative or collections agent who approved the payment arrangement terms.',
  `interconnection_application_id` BIGINT COMMENT 'Foreign key linking to interconnection.application. Business justification: High interconnection costs (impact studies, network upgrades, inspection fees) often require payment arrangements. Business process: Customers unable to pay upfront interconnection fees negotiate inst',
  `approval_date` DATE COMMENT 'Date when the payment arrangement was formally approved and became binding.',
  `arrangement_end_date` DATE COMMENT 'Scheduled date when the final installment is due and the arrangement is expected to be completed. Nullable for open-ended arrangements.',
  `arrangement_for_collections_case` BIGINT COMMENT 'FK to billing.collections_case.collections_case_id — Payment arrangements are negotiated to resolve a collections case. This FK links the installment plan to the delinquent balance being resolved.',
  `arrangement_number` STRING COMMENT 'Business-facing unique identifier for the payment arrangement, typically displayed on customer correspondence and used in collections workflows. Pattern: ^PA[0-9]{10}$.',
  `arrangement_start_date` DATE COMMENT 'Effective date when the payment arrangement becomes binding and the first installment schedule begins.',
  `arrangement_status` STRING COMMENT 'Current lifecycle state of the payment arrangement. Draft indicates pending approval; active means in effect and customer is making payments; completed when all obligations fulfilled; breached when customer missed payment(s) per terms; cancelled when voided before completion; suspended when temporarily paused by mutual agreement. Valid values: draft|active|completed|breached|cancelled|suspended.',
  `arrangement_to_sa` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — Payment arrangements are established for a specific service agreement with past-due balances.',
  `arrangement_type` STRING COMMENT 'Classification of the payment arrangement structure. Installment plan spreads balance over fixed payments; deferred payment postpones full payment to future date; settlement agreement resolves disputed balance; budget billing equalizes monthly payments; hardship plan offers reduced terms for financial distress; promise to pay is short-term commitment. Valid values: installment_plan|deferred_payment|settlement_agreement|budget_billing|hardship_plan|promise_to_pay.',
  `auto_pay_enrolled_flag` BOOLEAN COMMENT 'Indicates whether customer enrolled in automatic payment processing for installments, reducing risk of missed payments.',
  `breach_date` DATE COMMENT 'Date when the payment arrangement was breached due to missed payments exceeding the threshold. Nullable if arrangement has not been breached.',
  `breach_reason` STRING COMMENT 'Explanation of why the arrangement was breached, typically referencing specific missed payments or violation of terms. Nullable if not breached.',
  `breach_threshold` INT COMMENT 'Maximum number of missed installments allowed before the arrangement is automatically breached and collections actions resume. Typically 1 or 2 missed payments.',
  `cancellation_date` DATE COMMENT 'Date when the payment arrangement was cancelled before completion. Nullable if arrangement was not cancelled.',
  `cancellation_reason` STRING COMMENT 'Explanation of why the arrangement was cancelled, such as customer request, account closure, or administrative error. Nullable if not cancelled.',
  `completion_date` DATE COMMENT 'Date when all installment obligations were fulfilled and the arrangement was successfully completed. Nullable if not yet completed.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the payment arrangement record was first created in the system.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this arrangement. Typically USD for US utilities. Pattern: ^[A-Z]{3}$.',
  `customer_signature_received_flag` BOOLEAN COMMENT 'Indicates whether customer signature or electronic acceptance was obtained for the arrangement terms, required for enforceability.',
  `down_payment_amount` DECIMAL(18,2) COMMENT 'Initial payment required at arrangement establishment to demonstrate good faith and reduce the principal balance before installments begin. Zero if no down payment required.',
  `down_payment_received_date` DATE COMMENT 'Date when the down payment was actually received and posted to the account. Nullable if down payment not yet received or not required.',
  `first_installment_due_date` DATE COMMENT 'Date when the first scheduled installment payment is due, typically 30 days after arrangement start date or aligned with customer billing cycle.',
  `installment_amount` DECIMAL(18,2) COMMENT 'Fixed amount due for each regular installment payment. Calculated by dividing remaining balance after down payment by number of installments.',
  `installment_frequency` STRING COMMENT 'Cadence at which installment payments are scheduled. Monthly is most common for utility payment arrangements. Valid values: weekly|biweekly|monthly|quarterly.',
  `installments_missed_count` INT COMMENT 'Number of scheduled installment payments that were not received by their due date. Exceeding the allowed threshold triggers breach status.',
  `installments_paid_count` INT COMMENT 'Number of installment payments successfully received and posted to date. Used to track customer compliance with arrangement terms.',
  `interest_accrued_amount` DECIMAL(18,2) COMMENT 'Total interest charges accumulated on the outstanding balance since arrangement start. Updated periodically based on interest calculation schedule.',
  `interest_rate` DECIMAL(5,2) COMMENT 'Annual interest rate applied to the outstanding balance, expressed as a percentage. Zero if arrangement is interest-free per utility policy or regulatory requirement.',
  `last_installment_due_date` DATE COMMENT 'Date when the final installment payment is due, marking the scheduled completion of the arrangement.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the payment arrangement record was most recently updated, reflecting status changes, payment postings, or term modifications.',
  `late_fee_amount` DECIMAL(18,2) COMMENT 'Total late payment fees assessed for missed or delayed installments. May be waived under hardship arrangements.',
  `notes` STRING COMMENT 'Free-text field for customer service representatives to document special circumstances, negotiation details, or customer commitments related to the arrangement.',
  `notification_preference` STRING COMMENT 'Customer preferred channel for receiving payment reminders and arrangement status updates. Valid values: email|sms|mail|phone|none.',
  `number_of_installments` INT COMMENT 'Total count of scheduled installment payments in the arrangement. Typically ranges from 3 to 24 months depending on utility policy and customer circumstances.',
  `payment_method_code` STRING COMMENT 'Primary payment instrument the customer will use for installment payments. Valid values: bank_draft|credit_card|debit_card|check|cash|electronic_funds_transfer.',
  `remaining_balance` DECIMAL(18,2) COMMENT 'Current outstanding balance under the payment arrangement after subtracting down payment and any installments paid to date. Updated as payments are received.',
  `service_agreement` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — Payment arrangements are established for a specific service agreement/account.',
  `total_amount_owed` DECIMAL(18,2) COMMENT 'Total outstanding balance at the time the payment arrangement was established, representing the principal amount to be repaid through the arrangement.',
  `waived_fees_amount` DECIMAL(18,2) COMMENT 'Total amount of late fees, interest, or other charges waived as part of the arrangement negotiation or hardship consideration.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_payment_arrangement` PRIMARY KEY (`payment_arrangement_id`)
)
USING DELTA
COMMENT 'Master entity representing a formal installment or deferred payment plan negotiated with a customer to resolve past-due balances. Captures arrangement type, total amount owed, number of installments, installment amounts, scheduled payment dates, down payment, arrangement status, breach conditions, and associated collections case. Managed within SAP IS-U FICA and Oracle CC&B collections modules. | CMM: CIM AuxiliaryAgreement (close), IEC61968::PaymentMetering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PaymentArrangement',
  'cmm.cim.class' = 'AuxiliaryAgreement',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::PaymentMetering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.payment_arrangement'
);

-- BillingDeterminant  <<CIM Reading : broad>>
CREATE TABLE IF NOT EXISTS `billing`.`determinant` (
  `determinant_id` BIGINT NOT NULL COMMENT 'Unique identifier for the billing determinant record. Primary key for this entity.',
  `billing_period_id` BIGINT COMMENT 'Reference to the billing period for which these determinants apply. Defines the start and end dates of the consumption window used for rate calculation.',
  `billing_service_agreement_id` BIGINT COMMENT 'Reference to the service agreement for which this billing determinant was calculated. Links to the customer service agreement that defines the rate schedule and billing terms.',
  `cycle_id` BIGINT COMMENT 'Foreign key linking to billing.billing_cycle. Business justification: Billing determinants are calculated for a specific billing cycle execution. Currently billing_determinant has billing_cycle_code (STRING) but no FK to billing_cycle. This FK enables joining to retriev',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: Billing determinants calculate net metering export/import quantities from specific DER installations. Required to attribute generation, apply correct export rates, calculate demand charges with DER of',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_system. Business justification: Billing determinants for DER customers must account for system-specific characteristics (nameplate capacity, export capability, inverter type) to calculate net metering correctly. Business process: Mo',
  `dr_event_id` BIGINT COMMENT 'Foreign key linking to demand.dr_event. Business justification: Billing determinants (peak demand, TOU consumption) may be affected by DR events that alter normal consumption patterns. Baseline calculations, billing validation, and dispute resolution require under',
  `feeder_id` BIGINT COMMENT 'Foreign key linking to distribution.feeder. Business justification: Advanced metering analytics aggregate consumption by feeder for load forecasting, capacity planning, demand response program design, and feeder-level revenue analysis. Supports distribution planning a',
  `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Billing determinants are consumed during invoice generation to calculate charges. This FK links determinants to the invoice they contributed to, enabling traceability from invoice back to source deter',
  `lmp_price_id` BIGINT COMMENT 'Foreign key linking to trading.lmp_price. Business justification: Real-time pricing tariffs calculate interval-specific charges using LMP data matched to customer consumption intervals; critical for TOU programs, dynamic pricing pilots, and regulatory cost-of-servic',
  `meter_id` BIGINT COMMENT 'Reference to the meter from which the interval data was sourced. Links to the physical or virtual meter device in the Advanced Metering Infrastructure (AMI).',
  `meter_point_id` BIGINT COMMENT 'Foreign key linking to metering.meter_point. Business justification: Billing determinants calculate usage for service points, incorporating network topology (feeder, transformer) and rate schedule context. Service point is the fundamental unit for TOU period assignment',
  `rate_schedule_id` BIGINT COMMENT 'Foreign key linking to billing.rate_schedule. Business justification: Billing determinants are calculated according to a specific rate schedule\'s rules and structure. Currently billing_determinant has rate_schedule_code (STRING) but no FK to the rate_schedule master ent',
  `adjustment_reason_code` STRING COMMENT 'Code indicating why the billing determinants were manually adjusted after initial calculation. Used for audit trail and to track common data quality issues requiring manual intervention. Examples include meter malfunction, CT/PT ratio correction, or billing dispute resolution.',
  `billing_cycle_code` STRING COMMENT 'Code identifying the billing cycle schedule to which this service agreement belongs. Used to group customers for batch billing processing and to coordinate meter reading, determinant calculation, and invoice generation schedules.',
  `billing_days` INT COMMENT 'Number of calendar days in the billing period. Used for pro-ration calculations, average daily usage metrics, and normalization of consumption data for year-over-year comparisons.',
  `billing_multiplier` DECIMAL(10,6) COMMENT 'Multiplier applied to meter readings to account for Current Transformer (CT) and Potential Transformer (PT) ratios in high-voltage metering installations. Converts secondary meter readings to primary consumption values. Typically greater than 1 for commercial and industrial customers.',
  `calculation_method` STRING COMMENT 'Method used to derive the billing determinants from meter data. Indicates whether values were calculated from actual interval data, estimated due to missing data, or derived using special algorithms for net metering or demand windowing. Valid values: interval_sum|demand_window|tou_allocation|net_metering|estimated.',
  `calculation_timestamp` TIMESTAMP COMMENT 'The date and time when the billing determinants were calculated from validated meter interval data. Represents the business event time when MDM output was transformed into billing inputs.',
  `comments` STRING COMMENT 'Free-text field for billing analysts to document special circumstances, data quality issues, manual adjustments, or other notes relevant to this billing determinant record. Used for audit trail and knowledge transfer.',
  `contract_demand_kw` DECIMAL(18,3) COMMENT 'The contracted maximum demand level agreed upon between the utility and customer. Used for rate schedules where customers commit to a minimum demand level in exchange for favorable pricing. Excess demand above this level may incur penalty charges.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this billing determinant record was first created in the system. Used for audit trail and data lineage tracking.',
  `critical_peak_kwh` DECIMAL(18,3) COMMENT 'Energy consumption during Critical Peak Pricing (CPP) event hours. Used for CPP rate schedules where utilities invoke premium pricing during grid stress events (typically 10-15 days per year).',
  `data_quality_score` DECIMAL(5,2) COMMENT 'Composite score (0-100) representing the quality of the underlying meter interval data used to calculate these determinants. Considers factors such as percentage of actual vs estimated readings, validation rule pass rate, and data completeness. Used to flag determinants requiring manual review.',
  `estimated_interval_count` INT COMMENT 'Number of meter intervals that were estimated rather than actual readings. Used for data quality assessment and to flag billing determinants that may require review due to missing or invalid meter data.',
  `interval_count` INT COMMENT 'Number of meter interval readings used to calculate these billing determinants. Typically 2,880 intervals for 15-minute data over a 30-day period, or 1,440 intervals for 30-minute data. Used for data quality validation.',
  `is_final_determinant` BOOLEAN COMMENT 'Flag indicating whether this is the final, validated billing determinant record for the billing period (true) or a preliminary/estimated version (false). Used to prevent duplicate billing and ensure only validated determinants are passed to the billing engine.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this billing determinant record was last updated. Used for audit trail, change tracking, and identifying records that have been manually adjusted after initial calculation.',
  `load_factor` DECIMAL(5,4) COMMENT 'Ratio of average load to peak load during the billing period, calculated as (total_kwh / (peak_demand_kw * billing_hours)). Indicates how efficiently the customer uses their peak capacity. Values range from 0 to 1, with higher values indicating more consistent usage patterns.',
  `mid_peak_kwh` DECIMAL(18,3) COMMENT 'Energy consumption during mid-peak TOU periods (shoulder hours between on-peak and off-peak). Used for TOU rate schedules with three-tier time-based pricing.',
  `modified_by_user` STRING COMMENT 'User ID or system identifier of the person or process that last modified this billing determinant record. Used for audit trail and accountability in SOX compliance reporting.',
  `net_metering_export_kwh` DECIMAL(18,3) COMMENT 'Energy exported to the grid from customer-owned Distributed Energy Resources (DER) such as rooftop solar. Used for Net Energy Metering (NEM) rate schedules where exported energy is credited against consumption or compensated at a specified rate.',
  `net_metering_import_kwh` DECIMAL(18,3) COMMENT 'Energy imported from the grid by customers with Distributed Energy Resources (DER). Used for Net Energy Metering (NEM) rate schedules to calculate net consumption after accounting for on-site generation.',
  `off_peak_demand_kw` DECIMAL(18,3) COMMENT 'Maximum power demand during off-peak TOU periods. Used for rate schedules that apply separate demand charges for off-peak periods.',
  `off_peak_kwh` DECIMAL(18,3) COMMENT 'Energy consumption during off-peak TOU periods (typically nights and weekends when grid demand is lower). Used for TOU rate calculations with discounted pricing.',
  `on_peak_demand_kw` DECIMAL(18,3) COMMENT 'Maximum power demand during on-peak TOU periods. Used for rate schedules that apply separate demand charges for on-peak versus off-peak periods.',
  `on_peak_kwh` DECIMAL(18,3) COMMENT 'Energy consumption during on-peak TOU periods (typically weekday afternoons when grid demand is highest). Used for TOU and CPP rate calculations with premium pricing.',
  `peak_demand_kw` DECIMAL(18,3) COMMENT 'Maximum instantaneous power demand in kilowatts recorded during the billing period. Used for demand-based rate schedules common in commercial and industrial tariffs. Typically measured as the highest 15-minute or 30-minute interval average.',
  `peak_demand_timestamp` TIMESTAMP COMMENT 'Date and time when the peak demand (kW) occurred during the billing period. Used for demand response analysis, load profiling, and customer engagement regarding demand management opportunities.',
  `power_factor` DECIMAL(5,4) COMMENT 'Ratio of real power (kW) to apparent power (kVA) during the billing period, typically calculated at the time of peak demand. Used to assess power quality and apply power factor adjustment charges. Values range from 0 to 1, with 1.0 representing ideal unity power factor.',
  `ratchet_demand_kw` DECIMAL(18,3) COMMENT 'Demand value used for ratchet clause billing, typically a percentage (e.g., 80%) of the highest demand recorded in the previous 11 months. Used in commercial and industrial rate schedules to ensure minimum demand charges even during low-usage months.',
  `reactive_demand_kvar` DECIMAL(18,3) COMMENT 'Maximum reactive power demand in kilovolt-amperes reactive during the billing period. Used for power factor penalties or reactive power charges in industrial and large commercial rate schedules.',
  `source_system` STRING COMMENT 'System of record from which the meter interval data originated. Indicates whether data came from Meter Data Management (MDM), Advanced Metering Infrastructure (AMI), manual meter reading, estimation algorithms, or SCADA systems. Valid values: mdm|ami|manual_entry|estimated|scada.',
  `temperature_normalized_kwh` DECIMAL(18,3) COMMENT 'Energy consumption adjusted for weather variations using heating degree days (HDD) and cooling degree days (CDD). Used for load forecasting, energy efficiency program evaluation, and customer usage comparisons across different weather conditions.',
  `total_kwh` DECIMAL(18,3) COMMENT 'Total energy consumption in kilowatt-hours for the billing period. Sum of all interval data across all Time-of-Use (TOU) periods. Primary determinant for energy charges.',
  `tou_period_1_kwh` DECIMAL(18,3) COMMENT 'Energy consumption for TOU period 1 as defined in the rate schedule. Supports rate schedules with custom TOU period definitions beyond standard on-peak/off-peak/mid-peak classifications.',
  `tou_period_2_kwh` DECIMAL(18,3) COMMENT 'Energy consumption for TOU period 2 as defined in the rate schedule. Supports rate schedules with custom TOU period definitions beyond standard on-peak/off-peak/mid-peak classifications.',
  `tou_period_3_kwh` DECIMAL(18,3) COMMENT 'Energy consumption for TOU period 3 as defined in the rate schedule. Supports rate schedules with custom TOU period definitions beyond standard on-peak/off-peak/mid-peak classifications.',
  `tou_period_4_kwh` DECIMAL(18,3) COMMENT 'Energy consumption for TOU period 4 as defined in the rate schedule. Supports rate schedules with custom TOU period definitions beyond standard on-peak/off-peak/mid-peak classifications.',
  `validation_status` STRING COMMENT 'Current validation state of the billing determinants. Indicates whether the calculated values have passed automated validation rules, require manual review, or have been adjusted by billing analysts. Valid values: validated|pending_review|failed_validation|manually_adjusted|estimated.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_determinant` PRIMARY KEY (`determinant_id`)
)
USING DELTA
COMMENT 'Calculated billing determinant records derived from validated meter interval data for a specific service agreement and billing period. Stores total kWh, on-peak/off-peak kWh, peak demand (kW), reactive demand (kVAR), power factor, billing multiplier, and TOU period breakdowns. Bridges metering domain MDM output to the billing engine for rate calculation. Critical for TOU, CPP, and demand-based rate schedules. | CMM: CIM Reading (broad), IEC61968::Metering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'BillingDeterminant',
  'cmm.cim.class' = 'Reading',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61968::Metering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-9',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.determinant'
);

-- BillingAdjustment  <<CIM Transaction : close>>
CREATE TABLE IF NOT EXISTS `billing`.`adjustment` (
  `adjustment_id` BIGINT NOT NULL COMMENT 'Unique identifier for the financial adjustment transaction. Primary key.',
  `account_id` BIGINT COMMENT 'Reference to the customer account to which this adjustment is applied.',
  `adjustment_created_by_user_employee_id` BIGINT COMMENT 'User ID of the person or system process that initiated the adjustment transaction. Required for audit trails and segregation of duties controls.',
  `adjustment_employee_id` BIGINT COMMENT 'User ID of the person who approved the adjustment. Required for SOX audit trails and segregation of duties controls.',
  `adjustment_invoice_id` BIGINT COMMENT 'Reference to the source invoice affected by this adjustment. Nullable for account-level adjustments not tied to a specific invoice.',
  `audit_finding_id` BIGINT COMMENT 'Foreign key linking to compliance.audit_finding. Business justification: Billing adjustments frequently result from audit findings requiring correction of billing errors, rate misapplication, or compliance violations. Links adjustment to the specific finding that triggered',
  `bill_dispute_id` BIGINT COMMENT 'Reference to the customer dispute or complaint case that resulted in this adjustment. Null if not dispute-related. Links to customer service case management system.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Adjustments allocated to cost centers for variance analysis, budget tracking, and regulatory cost recovery. Essential for identifying systematic billing errors by department and supporting rate case c',
  `dr_incentive_payment_id` BIGINT COMMENT 'Foreign key linking to demand.dr_incentive_payment. Business justification: DR incentive payments are frequently posted as billing adjustments when credited after initial invoice generation. GL reconciliation, audit trails, and financial reporting require linking adjustments',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Billing adjustments (credits, rebates, corrections) post to specific GL accounts for accurate financial statements and audit trails. Reusing existing unlinked gl_account_code as denormalized reference',
  `grid_reliability_event_id` BIGINT COMMENT 'Foreign key linking to grid.grid_reliability_event. Business justification: When grid reliability events (outages, voltage issues) impact customers, utilities issue billing adjustments as service credits. Real business process: customer compensation for reliability events. Ad',
  `interconnection_application_id` BIGINT COMMENT 'Foreign key linking to interconnection.application. Business justification: Billing adjustments frequently result from interconnection process errors: wrong meter configuration during commissioning, delayed PTO affecting rate effective dates, or disputed export credit calcula',
  `invoice_id` BIGINT COMMENT 'FK to billing.invoice.invoice_id — Adjustments are typically applied against a specific invoice or billing period. This FK enables audit trail from adjustment back to the original billed amount. Critical for SOX controls.',
  `market_settlement_id` BIGINT COMMENT 'Foreign key linking to trading.market_settlement. Business justification: ISO settlement re-runs and true-ups trigger billing adjustments for retail customers on pass-through rates; direct settlement linkage enables automated correction posting, variance analysis, and regul',
  `meter_point_id` BIGINT COMMENT 'Foreign key linking to metering.meter_point. Business justification: Adjustments frequently result from meter test failures, VEE corrections, or service point configuration errors. This link identifies which service point triggered the adjustment, supports regulatory a',
  `outage_event_id` BIGINT COMMENT 'Foreign key linking to generation.generation_outage_event. Business justification: Utilities issue billing adjustments (credits/refunds) to customers affected by generation outages. Regulatory and audit requirements mandate traceability from customer billing adjustment to the causal',
  `reversed_adjustment_id` BIGINT COMMENT 'Reference to the original adjustment_id that this transaction reverses. Null if this is not a reversal. Used to maintain audit trail of adjustment corrections.',
  `to_invoice_id` BIGINT COMMENT 'FK to billing.invoice.invoice_id — Adjustments are frequently applied against a specific invoice (rate correction, estimated-to-actual true-up). This FK supports audit trail and SOX controls.',
  `trade_id` BIGINT COMMENT 'Foreign key linking to trading.trade. Business justification: Billing adjustments for wholesale trade settlement discrepancies require trade reference for complete audit trail, dispute resolution with counterparties, and regulatory compliance documentation when',
  `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: Billing adjustments frequently result from field work: meter test failures, equipment malfunctions, service quality issues. Customer service representatives and auditors require traceability from adju',
  `adjustment_date` DATE COMMENT 'The business date when the adjustment transaction was created and recorded in the billing system. This is the principal business event timestamp for the adjustment.',
  `adjustment_invoice` BIGINT COMMENT 'FK to billing.invoice.invoice_id — Adjustments are applied against specific invoices or billing periods. Critical for AR reconciliation and SOX controls.',
  `adjustment_number` STRING COMMENT 'Human-readable business identifier for the adjustment transaction, often displayed on customer correspondence and used for customer service reference.',
  `adjustment_type` STRING COMMENT 'Classification of the adjustment transaction indicating the nature of the financial change applied to the account or invoice. Reference-value candidates: credit|debit|rebate|rate_correction|estimated_to_actual_trueup|regulatory_surcharge|nem_credit|write_off|late_fee_reversal|deposit_refund|billing_error_correction.',
  `affected_billing_period_end` DATE COMMENT 'End date of the billing period to which this adjustment applies. Used for period-specific rate corrections and estimated-to-actual true-ups.',
  `affected_billing_period_start` DATE COMMENT 'Start date of the billing period to which this adjustment applies. Used for period-specific rate corrections and estimated-to-actual true-ups.',
  `amount` DECIMAL(18,2) COMMENT 'The monetary value of the adjustment. Positive values represent debits (charges to customer), negative values represent credits (refunds or reductions). Expressed in the account\'s billing currency.',
  `approval_date` DATE COMMENT 'Date when the adjustment was approved by an authorized user or system process. Null if still pending approval.',
  `approval_status` STRING COMMENT 'Current approval state of the adjustment in the workflow. Supports SOX financial controls requiring segregation of duties for material adjustments. Valid values: pending|approved|rejected|auto_approved|escalated|cancelled.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code indicating the currency in which the adjustment amount is denominated. Pattern: ^[A-Z]{3}$.',
  `dispute_flag` BOOLEAN COMMENT 'Indicates whether this adjustment is related to a customer dispute or complaint resolution. True if dispute-related, False otherwise.',
  `effective_date` DATE COMMENT 'The date from which the adjustment becomes effective for accounting and revenue recognition purposes. May differ from adjustment_date for backdated corrections.',
  `gl_posting_date` DATE COMMENT 'The date when this adjustment was posted to the general ledger. Null if not yet posted. Used for financial period reconciliation and revenue recognition.',
  `nem_credit_amount` DECIMAL(18,2) COMMENT 'For NEM credit adjustments: the total monetary credit amount calculated as nem_exported_kwh multiplied by nem_credit_rate. This amount is applied as a credit to the customer account. Null for non-NEM adjustments.',
  `nem_credit_expiration_date` DATE COMMENT 'For NEM credit adjustments: the date when unused NEM credits expire per the applicable NEM tariff rules (typically 12 months from generation). Null for non-NEM adjustments or jurisdictions without credit expiration.',
  `nem_credit_rate` DECIMAL(10,6) COMMENT 'For NEM credit adjustments: the per-kWh credit rate applied to exported energy, expressed in currency per kWh. Rate is determined by the applicable NEM tariff and may vary by time-of-use period. Null for non-NEM adjustments.',
  `nem_cumulative_credit_balance` DECIMAL(18,2) COMMENT 'For NEM credit adjustments: the cumulative balance of NEM credits on the customer account after this adjustment is applied. Used to track credit carryover across billing periods. Null for non-NEM adjustments.',
  `nem_exported_kwh` DECIMAL(15,3) COMMENT 'For NEM credit adjustments: the quantity of energy in kilowatt-hours exported by the customer\'s behind-the-meter generation system to the grid during the billing period. Null for non-NEM adjustments.',
  `nem_tariff_version` STRING COMMENT 'For NEM credit adjustments: the version identifier of the NEM tariff applied to this adjustment (e.g., NEM 1.0, NEM 2.0, NEM 3.0). Different tariff versions have different credit calculation rules. Null for non-NEM adjustments.',
  `notes` STRING COMMENT 'Free-form text field for additional notes, comments, or context about the adjustment. Used by customer service representatives and billing analysts for documentation.',
  `posted_to_gl_flag` BOOLEAN COMMENT 'Indicates whether this adjustment has been posted to the general ledger for financial reporting. True if posted, False if pending. Supports SOX financial controls and month-end close processes.',
  `reason_code` STRING COMMENT 'Standardized code indicating the business reason for the adjustment (e.g., meter read correction, customer complaint resolution, regulatory mandate, billing system error).',
  `reason_description` STRING COMMENT 'Free-text explanation providing additional context and details about why the adjustment was made, often used for audit trails and customer communication.',
  `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this adjustment record was first created in the source system. Used for audit trails and data lineage.',
  `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this adjustment record was last modified in the source system. Used for audit trails and change tracking.',
  `regulatory_reporting_flag` BOOLEAN COMMENT 'Indicates whether this adjustment must be included in regulatory compliance reporting to state PUC, FERC, or other governing bodies. True if reportable, False otherwise.',
  `revenue_class` STRING COMMENT 'Classification of the adjustment by revenue category for regulatory reporting and financial analysis. Aligns with FERC Uniform System of Accounts and state PUC reporting requirements. Reference-value candidates: energy_sales|distribution_charges|transmission_charges|regulatory_surcharges|ancillary_services|nem_credits|other.',
  `reversal_flag` BOOLEAN COMMENT 'Indicates whether this adjustment is a reversal of a previous adjustment transaction. True if this is a reversal, False otherwise.',
  `service_agreement` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — Adjustments are posted to a service agreement. Required for account-level balance tracking.',
  `source_document_reference` STRING COMMENT 'Reference identifier to the originating document or transaction in the source system (e.g., work order number, service request ID, regulatory filing reference). Used for audit trails and root cause analysis.',
  `source_system` STRING COMMENT 'The operational system or process that originated this adjustment transaction. Used for data lineage and reconciliation. Valid values: SAP_ISU|Oracle_CCB|MDM|Manual_Entry|Automated_Process|Customer_Portal.',
  `tariff_code` STRING COMMENT 'Rate schedule or tariff code applicable to this adjustment, particularly for rate corrections and regulatory surcharge adjustments. References the approved tariff on file with the regulatory authority.',
  `tax_amount` DECIMAL(18,2) COMMENT 'The tax component of the adjustment amount, if applicable. Null for non-taxable adjustments. Used for sales tax, utility tax, and other applicable taxes.',
  `tax_jurisdiction_code` STRING COMMENT 'Code identifying the tax jurisdiction applicable to this adjustment. Used for multi-jurisdictional tax compliance and reporting.',
  `to_sa` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — Adjustments are applied to a service agreement when not tied to a specific invoice (e.g., account-level credits, NEM credits).',
  `write_off_flag` BOOLEAN COMMENT 'Indicates whether this adjustment represents a bad debt write-off. True if this is a write-off, False otherwise. Used for accounts receivable aging and collections reporting.',
  `write_off_reason_code` STRING COMMENT 'Standardized code indicating the reason for write-off (e.g., bankruptcy, uncollectible, deceased customer, small balance). Null for non-write-off adjustments.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_adjustment` PRIMARY KEY (`adjustment_id`)
)
USING DELTA
COMMENT 'Transactional record of a financial adjustment applied to a customer account or invoice, including credits, debits, rebates, rate corrections, estimated-to-actual true-ups, regulatory surcharge adjustments, and NEM (Net Energy Metering) credits for behind-the-meter generation. Captures adjustment type, reason code, amount, affected billing period, approval status, authorizing user, and source invoice reference. For NEM credit adjustments: stores exported kWh, credit rate ($/kWh), credit amount, cumulative credit balance, credit expiration date, and applicable NEM tariff version. Sourced from SAP IS-U FICA, Oracle CC&B adjustment processing, and NEM billing modules. SSOT for all financial adjustments including NEM credits. Supports SOX financial controls, revenue recognition, and state NEM/RPS regulatory compliance reporting. | CMM: CIM Transaction (close), IEC61968::PaymentMetering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'BillingAdjustment',
  'cmm.cim.class' = 'Transaction',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::PaymentMetering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.adjustment'
);

-- SecurityDeposit  <<CIM AuxiliaryAccount : close>>
CREATE TABLE IF NOT EXISTS `billing`.`deposit` (
  `deposit_id` BIGINT NOT NULL COMMENT 'Unique identifier for the customer security deposit record. Primary key.',
  `account_id` BIGINT COMMENT 'Reference to the customer account for which this deposit is held. Links to the customer billing account in CIS.',
  `billing_service_agreement_id` BIGINT COMMENT 'FK to billing.billing_service_agreement.billing_service_agreement_id — Security deposits are collected against a specific service agreement. This FK enables deposit tracking, refund eligibility, and regulatory compliance for deposit rules.',
  `employee_id` BIGINT COMMENT 'User ID of the system user or CSR who last modified the deposit record. Supports SOX audit requirements and internal control documentation for financial transactions.',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Customer deposits held in specific liability GL accounts per regulatory requirements and GAAP. Link enables proper balance sheet classification, interest accrual tracking, and regulatory reporting of',
  `accrued_interest_amount` DECIMAL(15,2) COMMENT 'Total interest earned on the deposit from collection date to current date, calculated per regulatory interest rate requirements. Many PUCs mandate interest payment on customer deposits held beyond specified periods.',
  `amount` DECIMAL(15,2) COMMENT 'Original principal amount of the deposit collected from or guaranteed by the customer, in the utility\'s functional currency. Does not include accrued interest.',
  `collection_date` DATE COMMENT 'Date the deposit was collected from the customer or the guarantee instrument became effective. Serves as the start date for interest accrual and regulatory holding period calculations.',
  `collection_method` STRING COMMENT 'Payment method or mechanism used to collect the cash deposit from the customer. Does not apply to surety bonds or letters of credit which are third-party guarantees. Valid values: cash|check|credit_card|bank_transfer|payroll_deduction|installment_plan.',
  `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the deposit record was first created in the CIS or FICA system. Used for audit trail and data lineage tracking.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the deposit amount. Supports multi-currency operations for utilities operating across jurisdictions. Pattern: ^[A-Z]{3}$.',
  `deposit_number` STRING COMMENT 'Business-facing unique identifier for the deposit, used in customer communications and financial reporting. Externally visible deposit reference number. Pattern: ^DEP-[0-9]{8,12}$.',
  `deposit_status` STRING COMMENT 'Current lifecycle state of the deposit. Active deposits are held and earning interest, refunded deposits have been returned to customer, forfeited deposits applied to outstanding balances, transferred deposits moved to new account, expired deposits past regulatory holding period, and pending refund deposits awaiting disbursement approval. Valid values: active|refunded|forfeited|transferred|expired|pending_refund.',
  `deposit_type` STRING COMMENT 'Classification of the deposit instrument held by the utility. Cash deposits are held in utility accounts, surety bonds and letters of credit are third-party guarantees, bank guarantees are financial institution commitments, and escrow deposits are held by third-party trustees. Valid values: cash|surety_bond|letter_of_credit|bank_guarantee|escrow.',
  `forfeiture_amount` DECIMAL(15,2) COMMENT 'Amount of deposit (including accrued interest) applied to customer account balance upon forfeiture. May be partial if deposit exceeds outstanding balance. Null for deposits not forfeited.',
  `forfeiture_date` DATE COMMENT 'Date the deposit was forfeited and applied to outstanding customer account balance due to payment default, service disconnection, or final bill settlement. Null for deposits not forfeited.',
  `forfeiture_reason` STRING COMMENT 'Business reason for forfeiting the deposit and applying it to customer account balance. Payment default and service disconnection are most common triggers per PUC tariff rules. Valid values: payment_default|service_disconnection|final_bill_settlement|account_closure|regulatory_violation.',
  `guarantee_expiration_date` DATE COMMENT 'Expiration date of the surety bond, letter of credit, or bank guarantee. Utility must ensure renewal or replacement before expiration to maintain deposit coverage. Null for cash deposits and perpetual guarantees.',
  `guarantee_instrument_number` STRING COMMENT 'Reference number or policy number of the surety bond, letter of credit, or bank guarantee instrument. Used for verification and claim processing. Null for cash deposits.',
  `guarantee_provider_name` STRING COMMENT 'Name of the financial institution or surety company providing the letter of credit, surety bond, or bank guarantee. Applicable only for non-cash deposit types. Null for cash deposits.',
  `interest_calculation_method` STRING COMMENT 'Method used to calculate interest accrual on the deposit. Simple interest calculates on principal only, compound methods add accrued interest to principal at specified intervals. Method is typically mandated by PUC tariff rules. Valid values: simple|compound_monthly|compound_quarterly|compound_annually|none.',
  `interest_rate_percent` DECIMAL(5,3) COMMENT 'Annual interest rate applied to the deposit balance, expressed as a percentage. Rate is typically set by state PUC regulations and may be tied to treasury rates or fixed by tariff.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when the deposit record was last updated. Tracks changes to deposit status, interest accrual, or refund processing for audit and compliance purposes.',
  `last_review_date` DATE COMMENT 'Date the deposit record was last reviewed for refund eligibility, interest accrual accuracy, or regulatory compliance. Utilities typically perform periodic deposit reviews per PUC requirements.',
  `next_review_date` DATE COMMENT 'Scheduled date for the next deposit review cycle. Used for workflow management and compliance tracking to ensure timely refund processing and interest payment.',
  `notes` STRING COMMENT 'Free-text field for recording special circumstances, customer disputes, regulatory exceptions, or other relevant information about the deposit. Used for audit trail and customer service reference.',
  `reason_code` STRING COMMENT 'Business reason for requiring or collecting the deposit. Regulatory requirements mandate deposits for certain customer risk profiles, payment defaults trigger deposit collection, and voluntary deposits may be offered for budget management. Valid values: new_service|poor_credit|payment_default|high_usage|regulatory_requirement|voluntary.',
  `refund_amount` DECIMAL(15,2) COMMENT 'Total amount refunded to customer, including original deposit principal plus accrued interest, minus any forfeitures or adjustments. Null for deposits not yet refunded.',
  `refund_date` DATE COMMENT 'Actual date the deposit (plus accrued interest) was refunded to the customer or applied to their account balance. Null for deposits not yet refunded.',
  `refund_eligibility_date` DATE COMMENT 'Date on which the deposit becomes eligible for refund to the customer, calculated based on PUC-mandated holding periods and customer payment history criteria. Typically 12-24 months of on-time payment history.',
  `refund_method` STRING COMMENT 'Method used to return the deposit to the customer. Account credit applies deposit to outstanding balance, check and direct deposit return funds directly to customer, wire transfer used for large amounts. Valid values: check|direct_deposit|account_credit|wire_transfer.',
  `regulatory_holding_period_months` INT COMMENT 'Minimum number of months the utility must hold the deposit before refund eligibility, as mandated by state PUC regulations. Typically 12 or 24 months depending on jurisdiction and customer class.',
  `service_agreement` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — Security deposits are held against a specific service agreement. Required for deposit refund eligibility tracking.',
  `sox_control_flag` BOOLEAN COMMENT 'Indicates whether this deposit record is subject to SOX financial controls and audit requirements. True for publicly traded utilities with material deposit balances requiring internal control documentation.',
  `to_sa` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — Security deposits are collected for a specific service agreement, often at service initiation or after credit events.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_deposit` PRIMARY KEY (`deposit_id`)
)
USING DELTA
COMMENT 'Master entity tracking customer security deposits held by the utility, including deposit amount, deposit type (cash, surety bond, letter of credit), collection date, interest accrual, refund eligibility date, refund status, and regulatory basis for deposit requirement. Managed within SAP IS-U FICA and Oracle CC&B deposit management. Supports PUC-mandated deposit rules and customer financial risk management. | CMM: CIM AuxiliaryAccount (close), IEC61968::PaymentMetering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SecurityDeposit',
  'cmm.cim.class' = 'AuxiliaryAccount',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::PaymentMetering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.deposit'
);

-- DunningNotice  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `billing`.`dunning_notice` (
  `dunning_notice_id` BIGINT NOT NULL COMMENT 'Unique identifier for the dunning or collections notice record. Primary key.',
  `account_id` BIGINT COMMENT 'Reference to the customer account that received this dunning notice.',
  `bill_dispute_id` BIGINT COMMENT 'Reference to a billing dispute or complaint case opened by the customer in response to this dunning notice.',
  `billing_service_agreement_id` BIGINT COMMENT 'Reference to the active service agreement or utility contract under which the past due charges were incurred.',
  `disconnect_order_id` BIGINT COMMENT 'Reference to the service disconnection work order issued as a result of this dunning notice, if escalated to disconnect.',
  `dunning_run_id` BIGINT COMMENT 'Identifier for the batch dunning process or collections run that generated this notice. Used for audit and reconciliation.',
  `payment_arrangement_id` BIGINT COMMENT 'Reference to a payment arrangement or installment plan established in response to this dunning notice, if applicable.',
  `premise_id` BIGINT COMMENT 'Reference to the service premise or property associated with the delinquent account.',
  `action_date` DATE COMMENT 'Date on which the resulting action was taken or the dunning case was resolved.',
  `action_taken` STRING COMMENT 'Resulting action or outcome following the dunning notice. Tracks how the collections case was resolved or escalated. Reference-value candidates: none|payment_received|payment_arrangement|service_disconnected|account_written_off|legal_action|dispute_opened.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time this dunning notice record was first created in the system.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the past due amount (e.g., USD, CAD, EUR). Pattern: ^[A-Z]{3}$.',
  `customer_contact_name` STRING COMMENT 'Name of the customer or authorized contact person to whom the dunning notice was addressed.',
  `days_past_due` INT COMMENT 'Number of days the oldest invoice has been overdue at the time of dunning notice issuance.',
  `delivery_address` STRING COMMENT 'Physical or electronic address to which the dunning notice was sent (mailing address, email address, or phone number).',
  `delivery_channel` STRING COMMENT 'Method by which the dunning notice was delivered to the customer. Valid values: mail|email|sms|door_hanger|phone_call|customer_portal.',
  `delivery_status` STRING COMMENT 'Confirmation status of the delivery attempt. Indicates whether the notice successfully reached the customer. Valid values: sent|delivered|bounced|failed|pending.',
  `delivery_timestamp` TIMESTAMP COMMENT 'Date and time the dunning notice was successfully delivered or sent to the customer.',
  `due_date` DATE COMMENT 'Deadline by which the customer must respond or make payment to avoid further escalation.',
  `dunning_block_code` STRING COMMENT 'Code indicating if dunning was blocked or suppressed for this account due to special circumstances (e.g., hardship, bankruptcy, medical emergency).',
  `dunning_block_reason` STRING COMMENT 'Explanation or justification for why dunning was blocked or why this notice was cancelled.',
  `dunning_fee` DECIMAL(18,2) COMMENT 'Administrative fee charged for issuing the dunning notice, as permitted by regulatory tariff.',
  `dunning_level` STRING COMMENT 'Escalation stage of the collections process. Indicates severity and urgency of the notice. Valid values: first_notice|second_notice|final_notice|disconnect_warning|disconnect_order|legal_referral.',
  `dunning_notice_number` STRING COMMENT 'Externally-visible business identifier for the dunning notice, used in customer correspondence and payment references.',
  `dunning_status` STRING COMMENT 'Current lifecycle status of the dunning notice. Tracks whether the notice is active, resolved, or superseded. Reference-value candidates: issued|acknowledged|paid|disputed|cancelled|expired|escalated.',
  `in_collections_case` BIGINT COMMENT 'FK to billing.collections_case.collections_case_id — Dunning notices are issued within the context of a collections case. This FK tracks the escalation lifecycle from first notice through disconnect warning. Note: if merge recommendation is accepted, th',
  `issue_date` DATE COMMENT 'Date the dunning notice was generated and issued to the customer. Principal business event timestamp for this transaction.',
  `language_code` STRING COMMENT 'Two-letter ISO 639-1 language code indicating the language in which the dunning notice was issued (e.g., en, es, fr). Pattern: ^[a-z]{2}$.',
  `late_payment_fee` DECIMAL(18,2) COMMENT 'Additional fee or penalty assessed for late payment, included in the total amount due.',
  `modified_by` STRING COMMENT 'User ID or system identifier of the person or process that last modified this dunning notice record.',
  `modified_timestamp` TIMESTAMP COMMENT 'Date and time this dunning notice record was last updated in the system.',
  `notes` STRING COMMENT 'Free-text notes or comments recorded by collections staff regarding this dunning notice or customer interaction.',
  `oldest_invoice_date` DATE COMMENT 'Date of the oldest unpaid invoice included in the past due balance. Indicates how long the debt has been outstanding.',
  `past_due_amount` DECIMAL(18,2) COMMENT 'Total outstanding balance that triggered this dunning notice, in the account\'s billing currency.',
  `print_suppression_flag` BOOLEAN COMMENT 'Indicates whether physical printing and mailing of this notice was suppressed in favor of electronic delivery only.',
  `protected_customer_flag` BOOLEAN COMMENT 'Indicates whether the customer is classified as a protected or vulnerable customer (e.g., medical baseline, low-income, elderly) subject to special collections rules.',
  `regulatory_notice_days` INT COMMENT 'Minimum number of days required by regulation between dunning notice issuance and service disconnection.',
  `regulatory_notice_required` BOOLEAN COMMENT 'Flag indicating whether this dunning notice is subject to regulatory notification requirements (e.g., PUC-mandated disconnect notice periods).',
  `template_code` STRING COMMENT 'Identifier for the dunning notice template or form used to generate the customer communication.',
  `total_amount_due` DECIMAL(18,2) COMMENT 'Total amount the customer must pay to resolve the dunning notice, including past due balance, late fees, and dunning fees.',
  `created_by` STRING COMMENT 'User ID or system identifier of the person or automated process that created this dunning notice record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_dunning_notice` PRIMARY KEY (`dunning_notice_id`)
)
USING DELTA
COMMENT 'Transactional record of a dunning or collections notice issued to a customer with a past-due balance. Captures dunning level (first notice, final notice, disconnect warning, disconnect order), issue date, past-due amount, response deadline, delivery channel (mail, email, SMS, door hanger), and resulting action taken. Sourced from SAP IS-U FICA dunning program and Oracle CC&B collections workflow. Tracks the full collections escalation lifecycle. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DunningNotice',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.dunning_notice'
);

-- CollectionsCase  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `billing`.`collections` (
  `collections_id` BIGINT NOT NULL COMMENT 'Primary key for collections',
  `account_id` BIGINT COMMENT 'Reference to the customer account associated with this collections case.',
  `employee_id` BIGINT COMMENT 'Reference to the collections agent or team member assigned to manage this case.',
  `payment_arrangement_id` BIGINT COMMENT 'Reference to the payment arrangement or installment plan established to resolve this collections case.',
  `bankruptcy_filing_date` DATE COMMENT 'Date when the customer filed for bankruptcy protection.',
  `bankruptcy_flag` BOOLEAN COMMENT 'Indicates whether the customer has filed for bankruptcy, which may halt collections activity per legal requirements.',
  `case_close_date` DATE COMMENT 'Date when the collections case was closed, either through payment, payment arrangement, write-off, or other resolution.',
  `case_number` STRING COMMENT 'Business identifier for the collections case, externally visible and used for tracking and correspondence.',
  `case_open_date` DATE COMMENT 'Date when the collections case was opened due to delinquent balance exceeding threshold or aging criteria.',
  `case_resolution_outcome` STRING COMMENT 'Final outcome classification for how the collections case was resolved. Reference-value candidates: paid_in_full|payment_arrangement|partial_payment|written_off|bankruptcy|disputed|transferred.',
  `case_status` STRING COMMENT 'Current lifecycle status of the collections case indicating its stage in the collections workflow. Reference-value candidates: open|in_progress|pending_payment|payment_arrangement|escalated|closed|written_off.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this collections case record was first created in the system.',
  `delinquent_amount` DECIMAL(18,2) COMMENT 'Total outstanding delinquent balance in USD that triggered or is associated with this collections case.',
  `disconnect_executed_date` DATE COMMENT 'Date when service disconnection was actually executed in the field.',
  `disconnect_scheduled_date` DATE COMMENT 'Date when service disconnection is scheduled to occur if payment is not received.',
  `disconnect_status` STRING COMMENT 'Current status of service disconnection action for this collections case. Valid values: not_applicable|pending|scheduled|executed|cancelled|reconnected.',
  `dispute_flag` BOOLEAN COMMENT 'Indicates whether the customer has disputed the charges associated with this collections case.',
  `dispute_reason` STRING COMMENT 'Customer-provided reason for disputing the delinquent charges in this collections case.',
  `dunning_level` INT COMMENT 'Numeric dunning level indicating the escalation tier of collection notices sent (1=first notice, 2=second notice, etc.).',
  `escalation_count` INT COMMENT 'Number of times this collections case has been escalated to higher dunning levels or collection stages.',
  `external_agency_code` STRING COMMENT 'Identifier for the external collections agency to which this case has been referred.',
  `last_contact_date` DATE COMMENT 'Date of the most recent contact attempt or interaction with the customer regarding this collections case.',
  `last_contact_method` STRING COMMENT 'Communication channel used for the most recent customer contact regarding this collections case. Valid values: phone|email|sms|mail|door_hanger|in_person.',
  `last_escalation_date` DATE COMMENT 'Date when the collections case was last escalated to a higher dunning level or collections stage.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this collections case record was last updated in the system.',
  `last_payment_amount` DECIMAL(18,2) COMMENT 'Amount in USD of the most recent payment received against this collections case.',
  `last_payment_date` DATE COMMENT 'Date of the most recent payment received against the delinquent balance in this collections case.',
  `legal_referral_date` DATE COMMENT 'Date when the collections case was referred to legal counsel or external collections agency.',
  `legal_referral_flag` BOOLEAN COMMENT 'Indicates whether this collections case has been referred to legal counsel or external collections agency.',
  `next_action_date` DATE COMMENT 'Scheduled date for the next collections action or follow-up activity.',
  `next_action_type` STRING COMMENT 'Type of next scheduled collections action (e.g., send notice, phone call, disconnect order, legal referral).',
  `notes` STRING COMMENT 'Free-text notes and comments from collectors documenting interactions, customer circumstances, and case-specific details.',
  `original_delinquent_amount` DECIMAL(18,2) COMMENT 'Initial delinquent balance in USD at the time the collections case was opened, used for tracking payment progress.',
  `past_due_days` INT COMMENT 'Number of days the oldest invoice in the case has been past due, used for aging analysis and escalation triggers.',
  `promise_kept_flag` BOOLEAN COMMENT 'Indicates whether the customer honored their promise to pay commitment.',
  `promise_to_pay_amount` DECIMAL(18,2) COMMENT 'Amount in USD that the customer committed to pay by the promise to pay date.',
  `promise_to_pay_date` DATE COMMENT 'Date when the customer committed to making payment on the delinquent balance.',
  `reconnect_condition` STRING COMMENT 'Business conditions that must be met for service reconnection, such as payment in full, payment arrangement, or deposit.',
  `reconnect_date` DATE COMMENT 'Date when service was reconnected after disconnection.',
  `service_agreement` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — Collections cases are opened against a delinquent service agreement/account. Critical for collections workflow and disconnect processing.',
  `stage` STRING COMMENT 'Current stage in the collections escalation process indicating severity and next actions. Valid values: early_stage|mid_stage|late_stage|pre_disconnect|disconnect|legal.',
  `to_sa` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — Collections cases are opened for a delinquent service agreement. This FK is essential for collections workflow and disconnect processing.',
  `write_off_amount` DECIMAL(18,2) COMMENT 'Amount in USD written off as bad debt for this collections case.',
  `write_off_date` DATE COMMENT 'Date when the delinquent balance was written off as uncollectible bad debt.',
  `write_off_eligible_flag` BOOLEAN COMMENT 'Indicates whether this collections case meets business criteria for bad debt write-off consideration.',
  `write_off_reason_code` STRING COMMENT 'Code indicating the business reason for write-off (e.g., bankruptcy, deceased, uncollectible, small balance).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_collections` PRIMARY KEY (`collections_id`)
)
USING DELTA
COMMENT 'Master and transactional entity representing collections cases and their associated dunning notices for customer accounts with delinquent balances. At the case level: captures case open date, delinquent amount, collections stage, assigned collector, escalation history, disconnect status, reconnect conditions, write-off eligibility, and case resolution outcome. At the notice level: captures dunning level (first notice, final notice, disconnect warning, disconnect order), issue date, past-due amount, response deadline, delivery channel (mail, email, SMS, door hanger), and resulting action taken. Managed within SAP IS-U FICA dunning program and Oracle CC&B collections workflow. SSOT for all collections activity and dunning communications supporting SOX AR aging and bad debt controls. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CollectionsCase',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.collections'
);

-- WriteOff  <<CIM Transaction : close>>
CREATE TABLE IF NOT EXISTS `billing`.`write_off` (
  `write_off_id` BIGINT NOT NULL COMMENT 'Unique identifier for the accounts receivable write-off transaction. Primary key.',
  `account_id` BIGINT COMMENT 'Reference to the customer account for which the balance is being written off.',
  `approved_by_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Write-off approval requires explicit employee authorization tracking for SOX compliance, audit trail, and segregation of duties. Energy utilities must document approval authority per FERC/PUC requirem',
  `collections_id` BIGINT COMMENT 'Reference to the collections case that led to this write-off decision, if applicable.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Write-offs allocated to cost centers for performance tracking, collections effectiveness analysis, and regulatory cost recovery. Supports identification of high-risk customer segments and justificatio',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Bad debt write-offs post to specific expense GL accounts for financial reporting and regulatory cost recovery. Link supports allowance for doubtful accounts reconciliation, FERC reporting, and rate ca',
  `aging_bucket` STRING COMMENT 'The accounts receivable aging category at the time of write-off: 0-30 days, 31-60 days, 61-90 days, 91-120 days, 121-180 days, over_180 days. Valid values: 0-30|31-60|61-90|91-120|121-180|over_180.',
  `amount` DECIMAL(18,2) COMMENT 'The total dollar amount of the accounts receivable balance being written off as uncollectable.',
  `approval_authority` STRING COMMENT 'Name or identifier of the manager, director, or executive who authorized the write-off transaction per SOX approval hierarchy.',
  `approval_date` DATE COMMENT 'The date on which the write-off was formally approved by the designated authority.',
  `approval_level` STRING COMMENT 'Hierarchical approval level required for this write-off based on dollar threshold: supervisor (under $500), manager ($500-$2,500), director ($2,500-$10,000), vp ($10,000-$50,000), cfo (over $50,000). Valid values: supervisor|manager|director|vp|cfo.',
  `bankruptcy_case_number` STRING COMMENT 'The court-assigned bankruptcy case number if the write-off reason is bankruptcy, used for tracking potential distributions.',
  `bankruptcy_chapter` STRING COMMENT 'The chapter of bankruptcy filed by the customer: chapter_7 (liquidation), chapter_11 (reorganization), chapter_13 (individual debt adjustment). Valid values: chapter_7|chapter_11|chapter_13.',
  `collection_agency_referral_date` DATE COMMENT 'The date on which the account was referred to an external collection agency for recovery efforts.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this write-off record was first created in the system.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the write-off amount (e.g., USD, CAD, MXN). Pattern: ^[A-Z]{3}$.',
  `days_past_due` INT COMMENT 'The number of days the account balance was past due at the time of write-off, calculated from the original due date to the write-off date.',
  `external_collection_agency` STRING COMMENT 'Name of the third-party collection agency to which the account was referred before write-off, if applicable.',
  `fiscal_period` STRING COMMENT 'The fiscal year and period (YYYY-MM format) in which the write-off was recognized for financial reporting purposes. Pattern: ^[0-9]{4}-(0[1-9]|1[0-2])$.',
  `from_collections_case` BIGINT COMMENT 'FK to billing.collections_case.collections_case_id — Write-offs are the terminal outcome of a collections case. This FK is required for bad debt tracking, recovery management, and SOX AR aging controls.',
  `interest_amount` DECIMAL(18,2) COMMENT 'The portion of the write-off amount representing accrued interest or late payment charges.',
  `last_payment_amount` DECIMAL(18,2) COMMENT 'The dollar amount of the last payment received from the customer before the account was written off.',
  `last_payment_date` DATE COMMENT 'The date of the last payment received from the customer before the account was written off.',
  `modified_by` STRING COMMENT 'User ID or system identifier of the person or process that last modified the write-off record.',
  `modified_timestamp` TIMESTAMP COMMENT 'The date and time when this write-off record was last modified.',
  `penalty_amount` DECIMAL(18,2) COMMENT 'The portion of the write-off amount representing penalties, fees, or other charges assessed to the account.',
  `posting_date` DATE COMMENT 'The date on which the write-off transaction was posted to the general ledger and accounts receivable subledger.',
  `principal_amount` DECIMAL(18,2) COMMENT 'The portion of the write-off amount representing the original principal balance owed by the customer.',
  `puc_reporting_category` STRING COMMENT 'The regulatory reporting category for this write-off as required by state Public Utility Commission uncollectable expense reporting. Valid values: residential_uncollectable|commercial_uncollectable|industrial_uncollectable|other_uncollectable.',
  `rate_class` STRING COMMENT 'The customer rate classification for the account at the time of write-off: residential, commercial, industrial, municipal, or agricultural. Valid values: residential|commercial|industrial|municipal|agricultural.',
  `reason_code` STRING COMMENT 'Categorical code indicating the primary reason for the write-off: bankruptcy (customer filed for bankruptcy protection), deceased (customer is deceased with no estate recovery), skip (customer location unknown), hardship (financial hardship waiver), uncollectable (exhausted collection efforts), fraud (fraudulent account). Valid values: bankruptcy|deceased|skip|hardship|uncollectable|fraud.',
  `reason_description` STRING COMMENT 'Detailed narrative explanation of the circumstances leading to the write-off decision, including supporting documentation references.',
  `recovery_amount` DECIMAL(18,2) COMMENT 'The cumulative dollar amount recovered from this write-off through subsequent collection efforts, bankruptcy distributions, or estate settlements.',
  `recovery_date` DATE COMMENT 'The date of the most recent recovery payment or distribution applied against this written-off balance.',
  `recovery_eligible_flag` BOOLEAN COMMENT 'Indicates whether the written-off balance is eligible for future recovery efforts (true) or permanently closed (false).',
  `reversal_date` DATE COMMENT 'The date on which the write-off was reversed, if applicable (e.g., due to error correction or subsequent payment arrangement).',
  `reversal_reason` STRING COMMENT 'Explanation of why the write-off was reversed, including reference to correcting documentation or payment arrangement.',
  `service_territory_code` STRING COMMENT 'The geographic service territory or operating district in which the customer account was located. Pattern: ^[A-Z0-9]{2,6}$.',
  `service_type` STRING COMMENT 'The type of utility service for which the written-off balance was incurred: electric, gas, water, steam, or combined services. Valid values: electric|gas|water|steam|combined.',
  `tax_reporting_year` INT COMMENT 'The calendar year in which the write-off is reported for income tax purposes (may differ from fiscal period for tax accounting).',
  `write_off_date` DATE COMMENT 'The date on which the accounts receivable balance was officially written off. This is the principal business event timestamp for the transaction.',
  `write_off_number` STRING COMMENT 'Business-facing unique identifier for the write-off transaction, used in financial reporting and audit trails. Pattern: ^WO-[0-9]{8,12}$.',
  `write_off_status` STRING COMMENT 'Current lifecycle status of the write-off transaction: pending (awaiting approval), approved (authorized but not yet posted), posted (recorded to GL), reversed (write-off reversed), recovered (partial or full recovery after write-off). Valid values: pending|approved|posted|reversed|recovered.',
  `created_by` STRING COMMENT 'User ID or system identifier of the person or process that created the write-off record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_write_off` PRIMARY KEY (`write_off_id`)
)
USING DELTA
COMMENT 'Transactional record of an accounts receivable write-off for an uncollectable customer balance. Captures write-off date, amount, reason (bankruptcy, skip, hardship, deceased), approval authority, associated collections case, bad debt GL account, and recovery tracking. Sourced from SAP IS-U FICA and Oracle CC&B. Critical for SOX bad debt reserve management and PUC uncollectable expense reporting. | CMM: CIM Transaction (close), IEC61968::PaymentMetering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'WriteOff',
  'cmm.cim.class' = 'Transaction',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::PaymentMetering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.write_off'
);

-- BudgetPlan  <<CIM AuxiliaryAgreement : broad>>
CREATE TABLE IF NOT EXISTS `billing`.`budget_plan` (
  `budget_plan_id` BIGINT NOT NULL COMMENT 'Primary key for budget_plan',
  `account_id` BIGINT COMMENT 'Reference to the customer account enrolled in this budget billing plan.',
  `billing_service_agreement_id` BIGINT COMMENT 'Foreign key linking to billing.billing_service_agreement. Business justification: Budget billing plans are configured at the service agreement level, not just the account level. A customer account may have multiple service agreements (e.g., residential and commercial), each with di',
  `load_id` BIGINT COMMENT 'Foreign key linking to forecast.load. Business justification: Budget billing plans calculate levelized monthly payments based on forecasted annual usage for each customer class. Customer service systems reference specific load forecasts (by rate class and season',
  `payment_arrangement_id` BIGINT COMMENT 'Reference to an associated payment arrangement if the budget plan is part of a broader affordability or collections program.',
  `affordability_program_code` STRING COMMENT 'Code identifying the customer affordability or assistance program under which this budget plan is offered (low-income, senior, medical baseline, etc.).',
  `annual_budget_amount` DECIMAL(15,2) COMMENT 'Total estimated annual energy cost used as the basis for calculating monthly installments, typically based on historical usage and current rates.',
  `auto_renew_flag` BOOLEAN COMMENT 'Indicates whether the budget billing plan automatically renews at the end of the term or requires customer re-enrollment.',
  `budget_plan_status` STRING COMMENT 'Current lifecycle status of the budget billing plan enrollment. Valid values: active|pending|suspended|cancelled|completed|true_up_pending.',
  `budget_to_sa` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — Budget billing plans are enrolled for a specific service agreement to smooth seasonal bill variability.',
  `cancellation_date` DATE COMMENT 'Date when the budget billing plan was cancelled by the customer or utility. Null if plan is active or completed normally.',
  `cancellation_reason_code` STRING COMMENT 'Code indicating the reason for plan cancellation (customer request, payment default, account closure, service disconnection, etc.).',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this budget billing plan record was first created in the system.',
  `cumulative_actual_amount` DECIMAL(15,2) COMMENT 'Total actual energy charges incurred by the customer since enrollment, based on actual consumption and applicable rates.',
  `cumulative_billed_amount` DECIMAL(15,2) COMMENT 'Total amount billed to the customer under the budget plan since enrollment, representing the sum of all monthly installments charged.',
  `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts in this budget plan. Valid values: USD|CAD|EUR|GBP|AUD|MXN.',
  `effective_end_date` DATE COMMENT 'Date when the budget billing plan ends or is scheduled to end. Null for open-ended plans.',
  `effective_start_date` DATE COMMENT 'Date when the budget billing plan becomes effective and monthly installment billing begins.',
  `eligibility_verified_date` DATE COMMENT 'Date when customer eligibility for the budget billing plan or associated affordability program was last verified.',
  `enrollment_channel` STRING COMMENT 'Channel through which the customer enrolled in the budget billing plan. Valid values: web|mobile_app|call_center|in_person|mail|auto_enrolled.',
  `enrollment_date` DATE COMMENT 'Date when the customer was enrolled into the budget billing plan.',
  `historical_usage_kwh` DECIMAL(15,2) COMMENT 'Total historical annual energy consumption in kilowatt-hours used as the basis for calculating the budget amount, typically from the prior 12-month period.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this budget billing plan record was last updated.',
  `last_true_up_amount` DECIMAL(15,2) COMMENT 'Amount settled at the most recent true-up. Positive values represent credits issued to customer; negative values represent additional charges.',
  `last_true_up_date` DATE COMMENT 'Date of the most recent annual true-up reconciliation when variance was settled and plan was recalculated.',
  `modified_by_user` STRING COMMENT 'User ID or system identifier of the person or process that last modified this budget billing plan record.',
  `monthly_installment_amount` DECIMAL(15,2) COMMENT 'Fixed monthly payment amount charged to the customer under the budget billing plan, calculated to smooth seasonal bill variability.',
  `next_review_date` DATE COMMENT 'Scheduled date for the next plan review or recalculation, typically mid-cycle or at true-up to adjust installments based on actual usage trends.',
  `notes` STRING COMMENT 'Free-text notes or comments regarding the budget billing plan, including special arrangements, customer requests, or operational remarks.',
  `plan_number` STRING COMMENT 'Externally visible unique identifier for the budget billing plan, used in customer communications and billing statements.',
  `plan_term_months` INT COMMENT 'Duration of the budget billing plan cycle in months, typically 12 months for annual levelized billing.',
  `plan_type` STRING COMMENT 'Classification of the budget billing methodology used to calculate monthly installments (levelized over 12 months, rolling average, fixed amount, seasonal adjustment, or custom calculation). Valid values: levelized|equal_payment|rolling_average|fixed_amount|seasonal_adjustment|custom.',
  `rate_schedule_code` STRING COMMENT 'Tariff rate schedule code applied to calculate the budget amount and actual charges for this plan.',
  `recalculation_frequency` STRING COMMENT 'Frequency at which the monthly installment amount is recalculated based on updated usage patterns and rate changes. Valid values: annual|semi_annual|quarterly|monthly|on_demand.',
  `service_agreement` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — Budget billing plans are enrolled for a specific service agreement. Required for levelized billing calculation.',
  `true_up_month` INT COMMENT 'Month number (1-12) when the annual true-up reconciliation occurs, settling the variance between budget installments and actual charges.',
  `variance_amount` DECIMAL(15,2) COMMENT 'Current difference between cumulative billed amount and cumulative actual amount. Positive variance indicates customer has been overbilled (credit due at true-up); negative variance indicates underbilled (balance due at true-up).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_budget_plan` PRIMARY KEY (`budget_plan_id`)
)
USING DELTA
COMMENT 'Master entity representing a customer enrollment in a budget billing (levelized billing) program, where monthly charges are averaged over a 12-month period to smooth seasonal bill variability. Captures enrolled amount, plan start date, true-up month, cumulative actual vs. budget variance, annual true-up amount, and plan status. Managed within Oracle CC&B and SAP IS-U. Supports customer affordability programs and revenue smoothing. | CMM: CIM AuxiliaryAgreement (broad), IEC61968::PaymentMetering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'BudgetPlan',
  'cmm.cim.class' = 'AuxiliaryAgreement',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61968::PaymentMetering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.budget_plan'
);

-- BillingCycle  <<CIM TimeSchedule : extension>>
CREATE TABLE IF NOT EXISTS `billing`.`cycle` (
  `cycle_id` BIGINT NOT NULL COMMENT 'Unique identifier for the billing cycle configuration and execution record. Primary key.',
  `billing_run_id` BIGINT COMMENT 'Unique identifier for the specific batch billing run execution instance (e.g., BR2024011501). Generated when billing engine executes the cycle.',
  `cycle_approved_by_employee_id` BIGINT COMMENT 'User ID of the supervisor who approved the billing run for invoice release. Null if approval not required or not yet approved.',
  `cycle_employee_id` BIGINT COMMENT 'User ID or system account that initiated or executed the billing run. Used for audit trail and accountability.',
  `accounts_processed_count` INT COMMENT 'Total number of customer accounts successfully processed during this billing run execution.',
  `approval_required_flag` BOOLEAN COMMENT 'Indicates whether this billing cycle run requires supervisory approval before invoice release (True) or can be automatically released (False). Typically True for high-value commercial/industrial cycles.',
  `approval_timestamp` TIMESTAMP COMMENT 'Timestamp when the billing run was approved for invoice release. Null if approval not required or not yet approved.',
  `assigned_account_count` INT COMMENT 'Total number of customer accounts assigned to this billing cycle for workload distribution and capacity planning.',
  `bill_due_date_offset_days` INT COMMENT 'Number of days after bill generation date to set the payment due date (e.g., 21 days for residential, 30 days for commercial).',
  `billing_period_end_date` DATE COMMENT 'The last date of the consumption period covered by this billing cycle run (inclusive).',
  `billing_period_start_date` DATE COMMENT 'The first date of the consumption period covered by this billing cycle run (inclusive).',
  `billing_run_date` DATE COMMENT 'The actual date when the billing batch processing was executed for this cycle. May differ from scheduled date due to operational adjustments.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this billing cycle record was first created in the system. Used for audit trail and data lineage.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this billing cycle (e.g., USD, CAD, MXN). Pattern: ^[A-Z]{3}$.',
  `cycle_code` STRING COMMENT 'Business identifier for the billing cycle configuration (e.g., RES01, COM15, IND30). Used for scheduling and grouping accounts into billing batches. Pattern: ^[A-Z0-9]{2,10}$.',
  `cycle_name` STRING COMMENT 'Human-readable name describing the billing cycle (e.g., Residential Monthly Cycle 1, Commercial Bi-Monthly East).',
  `cycle_status` STRING COMMENT 'Current lifecycle status of the billing cycle configuration. Active: in use for billing operations. Inactive: temporarily disabled. Suspended: on hold pending review. Archived: retired from active use. Valid values: active|inactive|suspended|archived.',
  `cycle_type` STRING COMMENT 'Classification of the billing cycle frequency and purpose. Monthly for standard monthly billing, bi-monthly for every-other-month, quarterly for seasonal, on-demand for ad-hoc billing, final for account closure billing. Valid values: monthly|bi-monthly|quarterly|on-demand|final.',
  `effective_end_date` DATE COMMENT 'The date when this billing cycle configuration was retired or superseded. Null for currently active cycles.',
  `effective_start_date` DATE COMMENT 'The date when this billing cycle configuration became active and available for use in billing operations.',
  `exception_count` INT COMMENT 'Number of accounts that encountered errors or exceptions during billing run processing (e.g., missing meter reads, rate errors, validation failures). Requires manual review.',
  `exception_summary` STRING COMMENT 'Brief summary of the types of exceptions encountered during the billing run (e.g., 15 missing reads, 3 rate lookup failures, 2 validation errors).',
  `invoice_delivery_method` STRING COMMENT 'Primary method used to deliver invoices to customers in this billing cycle. Paper: postal mail. Email: electronic delivery. Portal: customer self-service. SMS: text message notification. Suppressed: no delivery (e.g., zero-balance accounts). Valid values: paper|email|portal|sms|suppressed.',
  `invoice_print_date` DATE COMMENT 'The date when physical invoices were printed or electronic bills were released to customers. May differ from billing run date due to approval workflows.',
  `invoices_generated_count` INT COMMENT 'Total number of invoices (bills) generated during this billing run execution. May differ from accounts processed if some accounts had zero consumption or credits.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this billing cycle record was last updated. Used for audit trail and change tracking.',
  `notes` STRING COMMENT 'Free-text field for operational notes, special instructions, or comments about this billing cycle or run (e.g., holiday adjustments, system issues, rate changes).',
  `rate_class` STRING COMMENT 'Customer rate classification this billing cycle primarily serves. Determines applicable tariff schedules and rate structures. Valid values: residential|commercial|industrial|agricultural|municipal.',
  `read_frequency_days` INT COMMENT 'Number of days between scheduled meter reads for this billing cycle (e.g., 30 for monthly, 60 for bi-monthly).',
  `run_duration_minutes` INT COMMENT 'Total elapsed time in minutes for the billing run execution. Used for capacity planning and performance optimization.',
  `run_end_timestamp` TIMESTAMP COMMENT 'Timestamp when the billing batch processing completed or terminated. Used for performance monitoring and SLA tracking.',
  `run_start_timestamp` TIMESTAMP COMMENT 'Timestamp when the billing batch processing began execution. Used for performance monitoring and SLA tracking.',
  `run_status` STRING COMMENT 'Current execution status of the billing run. Pending: scheduled but not started. In-progress: actively processing. Completed: finished successfully. Completed-with-exceptions: finished but some accounts had errors. Error: run failed. Cancelled: run was aborted. Valid values: pending|in-progress|completed|completed-with-exceptions|error|cancelled.',
  `scheduled_bill_generation_date` DATE COMMENT 'The date when invoice generation batch processing is scheduled to execute for this billing cycle.',
  `scheduled_read_end_date` DATE COMMENT 'The date by which all meter reading activities should be completed for this billing cycle period.',
  `scheduled_read_start_date` DATE COMMENT 'The date when meter reading activities are scheduled to begin for this billing cycle period.',
  `service_territory_code` STRING COMMENT 'Geographic service territory identifier this billing cycle serves (e.g., EAST, WEST, METRO1). Used for regional billing operations. Pattern: ^[A-Z0-9]{2,6}$.',
  `total_billed_amount` DECIMAL(18,2) COMMENT 'Sum of all invoice amounts generated during this billing run execution, before payments and adjustments. Represents gross revenue for the cycle.',
  `total_kwh_billed` DECIMAL(15,3) COMMENT 'Sum of all energy consumption in kilowatt-hours billed across all accounts in this billing run. Key operational metric for load forecasting and revenue analysis.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_cycle` PRIMARY KEY (`cycle_id`)
)
USING DELTA
COMMENT 'Reference and operational entity defining billing cycle configurations and their execution history. At the cycle level: stores cycle code, read frequency (monthly, bi-monthly), scheduled read and bill generation dates, due date offset, and assigned account count. At the run level: captures batch billing run execution records including run date, billing cycle reference, accounts processed, invoices generated, total billed amount, run status (pending, in-progress, completed, error), exception count, and operator. Drives billing run scheduling, workload distribution, and revenue cycle timing. Sourced from SAP IS-U and Oracle CC&B billing engine. SSOT for billing cycle definitions and all batch billing run execution records. | CMM: CIM TimeSchedule (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'BillingCycle',
  'cmm.cim.class' = 'TimeSchedule',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'reference_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.cycle'
);

-- BillingRun  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `billing`.`billing_run` (
  `billing_run_id` BIGINT NOT NULL COMMENT 'Unique identifier for the billing run execution. Primary key for the billing run entity.',
  `employee_id` BIGINT COMMENT 'User identifier or system account that initiated or executed the billing run, used for audit trail and accountability in billing operations.',
  `reversed_run_billing_run_id` BIGINT COMMENT 'Reference to the original billing run that is being reversed by this run, establishing audit trail for billing corrections and dispute resolution.',
  `accounts_failed` INT COMMENT 'Number of customer accounts or service agreements that failed to complete billing due to data errors, validation failures, or system exceptions.',
  `accounts_processed` INT COMMENT 'Number of customer accounts or service agreements that were successfully processed and completed billing calculations without errors.',
  `accounts_targeted` INT COMMENT 'Total number of customer accounts or service agreements that were selected and targeted for billing in this run based on billing cycle criteria.',
  `actual_end_timestamp` TIMESTAMP COMMENT 'Actual date and time when the billing run execution completed or terminated, used to calculate run duration and identify performance issues.',
  `actual_start_timestamp` TIMESTAMP COMMENT 'Actual date and time when the billing run execution began, capturing the real-world event time for performance monitoring and audit purposes.',
  `approval_status` STRING COMMENT 'Approval state of the billing run results, indicating whether the run output has been reviewed and approved for invoice release and accounts receivable posting. Valid values: pending_approval|approved|rejected|not_required.',
  `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the billing run was approved for invoice release, establishing the audit trail for revenue recognition timing.',
  `approved_by` STRING COMMENT 'User identifier of the supervisor or manager who approved the billing run results for release, supporting SOX segregation of duties requirements.',
  `batch_job_reference` STRING COMMENT 'Technical identifier of the underlying batch job or process execution in the billing system, used for technical troubleshooting and system integration.',
  `billing_period_end_date` DATE COMMENT 'End date of the billing period covered by this run, defining the conclusion of the consumption or service period being invoiced.',
  `billing_period_start_date` DATE COMMENT 'Start date of the billing period covered by this run, defining the beginning of the consumption or service period being invoiced.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this billing run record was first created in the system, establishing the audit trail for billing operations tracking.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this billing run, typically USD for US-based energy utilities. Pattern: ^[A-Z]{3}$.',
  `duration_seconds` INT COMMENT 'Total elapsed time in seconds from actual start to actual end of the billing run, used for performance analysis and capacity planning.',
  `error_count` INT COMMENT 'Total number of critical errors encountered during billing run execution that prevented successful processing of accounts or invoice generation.',
  `exception_count` INT COMMENT 'Total number of billing exceptions, warnings, or validation issues encountered during the run that require manual review or correction.',
  `execution_mode` STRING COMMENT 'Method by which the billing run was triggered, indicating whether it was automatically scheduled, manually initiated, or executed on-demand. Valid values: automatic|manual|scheduled|on_demand.',
  `gl_posting_date` DATE COMMENT 'Accounting date when the billing run results were posted to the general ledger for revenue recognition and accounts receivable booking.',
  `gl_posting_status` STRING COMMENT 'Status of the financial posting to the general ledger, indicating whether accounts receivable and revenue entries have been successfully recorded. Valid values: not_posted|posted|posting_failed|reversed.',
  `invoice_due_date` DATE COMMENT 'Standard payment due date applied to invoices generated in this billing run, used for accounts receivable management and collections planning.',
  `invoices_generated` INT COMMENT 'Total number of billing invoices or statements successfully generated and created during this billing run execution.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this billing run record was last updated, supporting change tracking and audit compliance for billing operations.',
  `notes` STRING COMMENT 'Free-text operational notes or comments about the billing run execution, capturing special circumstances, manual interventions, or issues requiring follow-up.',
  `print_batch_reference` STRING COMMENT 'Identifier of the print or output batch associated with this billing run, linking invoices to physical or electronic delivery processes.',
  `rate_schedule_version` STRING COMMENT 'Version identifier of the rate schedules and tariff structures applied during this billing run, ensuring regulatory compliance and audit traceability.',
  `reversal_flag` BOOLEAN COMMENT 'Indicator of whether this billing run is a reversal run intended to cancel or reverse invoices from a previous billing run due to errors or corrections.',
  `run_number` STRING COMMENT 'Business-facing identifier for the billing run, typically formatted as a sequential or date-based code used for operational tracking and reference in billing operations.',
  `run_status` STRING COMMENT 'Current lifecycle status of the billing run execution indicating whether the batch process is pending, actively running, successfully completed, completed with exceptions, failed, or cancelled. Valid values: pending|in_progress|completed|completed_with_errors|failed|cancelled.',
  `run_type` STRING COMMENT 'Classification of the billing run indicating whether it is a regular scheduled run, interim billing, final billing, correction run, reversal run, or special ad-hoc billing event. Valid values: regular|interim|final|correction|reversal|special.',
  `scheduled_start_timestamp` TIMESTAMP COMMENT 'Planned date and time when the billing run was scheduled to begin execution, used for operational planning and SLA tracking.',
  `total_adjustment_amount` DECIMAL(18,2) COMMENT 'Aggregate sum of all billing adjustments, credits, and corrections applied during this billing run, including late fees, discounts, and dispute resolutions.',
  `total_billed_amount` DECIMAL(18,2) COMMENT 'Aggregate sum of all invoice amounts generated in this billing run before adjustments, representing the gross revenue recognized for the billing period.',
  `total_net_amount` DECIMAL(18,2) COMMENT 'Final aggregate net amount due across all invoices after applying taxes and adjustments, representing the total accounts receivable created by this billing run.',
  `total_tax_amount` DECIMAL(18,2) COMMENT 'Aggregate sum of all tax charges calculated and applied across invoices in this billing run, supporting tax reporting and remittance.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_billing_run` PRIMARY KEY (`billing_run_id`)
)
USING DELTA
COMMENT 'Transactional record of a batch billing run execution that generates invoices for a set of service agreements within a billing cycle. Captures run date, billing cycle, number of accounts processed, number of invoices generated, total billed amount, run status (pending, in-progress, completed, error), exception count, and operator. Sourced from SAP IS-U and Oracle CC&B billing engine execution logs. Supports billing operations monitoring and revenue cycle management. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'BillingRun',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.billing_run'
);

-- RevenueRecognition  <<CIM ErpLedgerEntry : close>>
CREATE TABLE IF NOT EXISTS `billing`.`revenue_recognition` (
  `revenue_recognition_id` BIGINT NOT NULL COMMENT 'Primary key for revenue_recognition',
  `audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: External and internal audits test revenue recognition entries for compliance with accounting standards and regulatory requirements. Links revenue entries to the audit engagement where they were tested',
  `billing_account_id` BIGINT COMMENT 'Reference to the billing account associated with this revenue recognition entry. Supports multi-account revenue tracking.',
  `billing_service_agreement_id` BIGINT COMMENT 'Reference to the customer service agreement for which revenue is being recognized. Links this revenue recognition entry to the underlying customer contract.',
  `invoice_id` BIGINT COMMENT 'FK to billing.invoice.invoice_id — Revenue recognition entries may reference the source invoice for billed revenue. Supports ASC 606 compliance and audit trail.',
  `journal_entry_id` BIGINT COMMENT 'Foreign key linking to finance.journal_entry. Business justification: Revenue recognition entries create or reference journal entries for GL posting. Direct linkage ensures audit trail from billing subledger to general ledger, required for SOX compliance, external audit',
  `original_entry_revenue_recognition_id` BIGINT COMMENT 'Reference to the original revenue recognition entry being reversed. Populated only when reversal_flag is True. Maintains audit trail for reversals.',
  `ppa_id` BIGINT COMMENT 'Foreign key linking to trading.ppa. Business justification: PPA revenue recognition requires contract-specific treatment for bundled energy and RECs under GAAP; direct PPA reference enables proper allocation between energy and environmental attribute revenue s',
  `rate_schedule_id` BIGINT COMMENT 'Foreign key linking to billing.rate_schedule. Business justification: Revenue recognition entries are calculated according to rate schedule rules and must be traceable to the rate schedule version in effect. Currently revenue_recognition has rate_schedule_code (STRING)',
  `renewable_ppa_settlement_id` BIGINT COMMENT 'Foreign key linking to renewable.ppa_settlement. Business justification: Revenue from PPA settlements must be recognized in correct accounting periods per ASC 606. Financial reporting requires linking settlement amounts to revenue recognition entries for matching generatio',
  `revenue_invoice_id` BIGINT COMMENT 'Reference to the invoice document from which this revenue recognition entry was derived. Null for unbilled revenue accruals.',
  `sox_control_id` BIGINT COMMENT 'Foreign key linking to compliance.sox_control. Business justification: Revenue recognition is a key SOX control area for financial statement accuracy. Links specific revenue entries to the SOX control they satisfy, enabling control testing, evidence collection, and audit',
  `trade_id` BIGINT COMMENT 'Foreign key linking to trading.trade. Business justification: Revenue from wholesale bilateral trades must be recognized per ASC 606 performance obligations; direct trade linkage enables proper revenue timing, contract modification tracking, and GAAP-compliant f',
  `accounting_period` STRING COMMENT 'The fiscal accounting period (YYYY-MM format) for which revenue is being recognized. Aligns with financial close calendar and regulatory reporting periods. Pattern: ^\\d{4}-(0[1-9]|1[0-2])$.',
  `adjustment_amount` DECIMAL(18,2) COMMENT 'Any adjustments applied to revenue recognition for corrections, disputes, write-offs, or regulatory true-ups. Positive or negative value.',
  `approval_status` STRING COMMENT 'The approval workflow status of this revenue recognition entry. Ensures SOX-compliant segregation of duties for revenue posting. Valid values: draft|pending_approval|approved|rejected|posted.',
  `approved_by` STRING COMMENT 'The user ID or name of the person who approved this revenue recognition entry for posting to the general ledger.',
  `approved_timestamp` TIMESTAMP COMMENT 'The date and time when this revenue recognition entry was approved for posting. Part of SOX audit trail.',
  `billed_revenue_amount` DECIMAL(18,2) COMMENT 'The portion of recognized revenue that has been invoiced to the customer. Sourced from SAP IS-U billing documents.',
  `business_area` STRING COMMENT 'The business area classification for this revenue (e.g., generation, transmission, distribution, retail). Supports segment reporting under GAAP.',
  `consumption_kwh` DECIMAL(15,3) COMMENT 'The kilowatt-hours of energy consumption for which revenue is being recognized. Sourced from meter data management system.',
  `cost_center` STRING COMMENT 'The organizational cost center responsible for this revenue stream. Supports internal management accounting and profitability analysis.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this revenue recognition entry record was first created in the system. Part of audit trail for record lifecycle.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this revenue recognition entry. Typically USD for US utilities. Pattern: ^[A-Z]{3}$.',
  `deferred_revenue_amount` DECIMAL(18,2) COMMENT 'The portion of billed revenue that has been collected but not yet earned. Represents liability for future service delivery under ASC 606.',
  `demand_kw` DECIMAL(15,3) COMMENT 'The peak kilowatt demand for which demand charges are being recognized. Applicable to commercial and industrial rate schedules.',
  `gl_account_code` STRING COMMENT 'The general ledger account code to which this revenue recognition entry is posted in SAP S/4HANA FI. Maps to FERC account structure.',
  `last_modified_by` STRING COMMENT 'The user ID or name of the person or system process that last modified this revenue recognition entry record.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this revenue recognition entry record was last modified. Supports change tracking and audit compliance.',
  `meter_read_date` DATE COMMENT 'The date of the meter reading that forms the basis for billed revenue in this entry. Null for unbilled accruals or non-metered charges.',
  `notes` STRING COMMENT 'Free-text notes providing additional context for this revenue recognition entry, including explanations for adjustments or special circumstances.',
  `performance_obligation` STRING COMMENT 'Description of the performance obligation satisfied by this revenue recognition entry under ASC 606 (e.g., electricity delivery, capacity reservation).',
  `posting_date` DATE COMMENT 'The date this revenue recognition entry was posted to the general ledger in SAP S/4HANA FI. May differ from recognition_date due to period-end adjustments.',
  `profit_center` STRING COMMENT 'The profit center to which this revenue is allocated for segment reporting and profitability analysis.',
  `recognition_date` DATE COMMENT 'The specific date on which revenue was recognized in the general ledger. Represents the business event timestamp for this revenue recognition transaction.',
  `recognition_method` STRING COMMENT 'The accounting method used to recognize this revenue under ASC 606. Indicates whether revenue is recognized at a point in time or over time. Valid values: point_in_time|over_time|accrual|deferral|straight_line.',
  `recognized_revenue_amount` DECIMAL(18,2) COMMENT 'The total revenue amount recognized in this accounting period for this service agreement and revenue category. Represents earned revenue under ASC 606.',
  `regulatory_account_code` STRING COMMENT 'The regulatory accounting code as defined by FERC or state PUC for revenue classification and reporting. Supports regulatory financial statements.',
  `revenue_category` STRING COMMENT 'Classification of the revenue type being recognized. Distinguishes between energy consumption charges, demand charges, fixed customer charges, regulatory riders, and ancillary services. Valid values: energy|demand|customer_charge|rider|ancillary_service|late_fee.',
  `revenue_class` STRING COMMENT 'Customer class for which revenue is being recognized. Aligns with rate class segmentation and regulatory reporting requirements. Valid values: residential|commercial|industrial|wholesale|municipal|agricultural.',
  `revenue_invoice` BIGINT COMMENT 'FK to billing.invoice.invoice_id — Revenue recognition entries may reference specific invoices for billed revenue. Supports GL reconciliation.',
  `reversal_flag` BOOLEAN COMMENT 'Indicates whether this revenue recognition entry is a reversal of a previous entry. True for reversals, False for original entries.',
  `reversal_reason` STRING COMMENT 'The business reason for reversing this revenue recognition entry (e.g., billing error, customer dispute, regulatory adjustment). Populated only when reversal_flag is True.',
  `revrec_to_sa` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — Revenue recognition entries are derived from billed/unbilled revenue for a specific service agreement and accounting period.',
  `rider_code` STRING COMMENT 'The regulatory rider or surcharge code applied to this revenue recognition entry (e.g., fuel adjustment clause, renewable energy surcharge).',
  `service_agreement` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — Revenue recognition entries are derived from billed/unbilled revenue for a specific service agreement. Required for ASC 606 compliance.',
  `service_period_end_date` DATE COMMENT 'The end date of the service period for which revenue is being recognized. Defines the end of the consumption or service delivery window.',
  `service_period_start_date` DATE COMMENT 'The start date of the service period for which revenue is being recognized. Defines the beginning of the consumption or service delivery window.',
  `source_document_number` STRING COMMENT 'The document number in the source system that originated this revenue recognition entry (e.g., SAP IS-U billing document number, FI document number).',
  `source_system` STRING COMMENT 'The operational system from which this revenue recognition entry was sourced (SAP IS-U FICA, Oracle CC&B, SAP S/4HANA FI, or manual entry). Valid values: SAP_IS-U|Oracle_CC&B|SAP_S4HANA|Manual_Entry.',
  `tariff_version` STRING COMMENT 'The version of the tariff rate schedule applied for this revenue recognition entry. Ensures auditability of rate changes.',
  `tax_amount` DECIMAL(18,2) COMMENT 'The total tax amount included in recognized revenue (sales tax, utility tax, franchise fees). Excluded from net revenue for regulatory reporting.',
  `unbilled_revenue_amount` DECIMAL(18,2) COMMENT 'The portion of recognized revenue that has been earned but not yet invoiced. Represents accrued revenue for consumption between last meter read and period end.',
  `created_by` STRING COMMENT 'The user ID or name of the person or system process that created this revenue recognition entry record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_revenue_recognition` PRIMARY KEY (`revenue_recognition_id`)
)
USING DELTA
COMMENT 'Transactional record capturing revenue recognition entries derived from billed and unbilled revenue for a service agreement and accounting period. Stores recognized revenue amount, deferred revenue amount, unbilled revenue accrual, revenue category (energy, demand, customer charge, rider), accounting period, GL account code, and recognition method. Supports SOX-compliant revenue recognition under ASC 606 and regulatory accounting requirements. Sourced from SAP IS-U FICA and SAP S/4HANA FI integration. | CMM: CIM ErpLedgerEntry (close), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'RevenueRecognition',
  'cmm.cim.class' = 'ErpLedgerEntry',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.revenue_recognition'
);

-- BillDispute  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `billing`.`bill_dispute` (
  `bill_dispute_id` BIGINT NOT NULL COMMENT 'Unique identifier for the bill dispute record. Primary key.',
  `account_id` BIGINT COMMENT 'Reference to the customer account that initiated the dispute.',
  `bill_invoice_id` BIGINT COMMENT 'Reference to the invoice being disputed by the customer.',
  `credit_memo_id` BIGINT COMMENT 'Reference to the credit memo document issued to the customer account if a credit was granted as part of the resolution.',
  `employee_id` BIGINT COMMENT 'User ID of the customer service representative or analyst currently assigned to investigate and resolve the dispute.',
  `grid_reliability_event_id` BIGINT COMMENT 'Foreign key linking to grid.grid_reliability_event. Business justification: Customers dispute bills due to outages or voltage issues caused by grid reliability events. Real business process: dispute investigation requires referencing the causal grid event to validate customer',
  `invoice_id` BIGINT COMMENT 'FK to billing.invoice.invoice_id — Bill disputes reference a specific invoice being contested. This FK is essential for dispute resolution workflow and PUC complaint tracking.',
  `meter_point_id` BIGINT COMMENT 'Foreign key linking to metering.meter_point. Business justification: Disputes often involve meter accuracy, AMI communication failures, or service point configuration issues. This link identifies the physical metering location for field investigation, meter test schedu',
  `adjustment_amount` DECIMAL(18,2) COMMENT 'Monetary amount credited or debited to the customer account as a result of the dispute resolution. Positive values represent credits to customer; negative values represent additional charges.',
  `assigned_to_team` STRING COMMENT 'Name or code of the team or department responsible for handling the dispute (e.g., Billing Operations, Meter Services, Revenue Protection).',
  `bill_dispute_to_invoice` BIGINT COMMENT 'FK to billing.invoice.invoice_id — Bill disputes are filed against a specific invoice or charge. This FK is essential for dispute investigation and resolution tracking.',
  `bill_invoice` BIGINT COMMENT 'FK to billing.invoice.invoice_id — Bill disputes are raised against a specific invoice. Critical for dispute resolution workflow and PUC complaint tracking.',
  `created_by_user` STRING COMMENT 'User ID of the system user or customer service representative who created the dispute record.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this dispute record was first created in the system.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the disputed amount. Pattern: ^[A-Z]{3}$.',
  `customer_satisfaction_rating` INT COMMENT 'Customer-provided satisfaction score for the dispute resolution process, typically on a scale of 1-5 or 1-10.',
  `dispute_number` STRING COMMENT 'Externally visible unique dispute case number assigned by the Customer Information System (CIS) for tracking and customer communication.',
  `dispute_open_date` DATE COMMENT 'Date when the dispute was formally opened and logged in the system. Represents the business event timestamp for dispute initiation.',
  `dispute_open_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the dispute record was created in the CIS, including time-of-day for SLA tracking.',
  `dispute_reason_code` STRING COMMENT 'Standardized code categorizing the primary reason for the dispute as reported by the customer or identified during investigation. Reference-value candidates: estimated_read|meter_malfunction|rate_error|billing_calculation_error|unauthorized_charge|duplicate_charge|service_quality|high_bill_complaint|tariff_misapplication|proration_error|other.',
  `dispute_reason_description` STRING COMMENT 'Detailed free-text explanation of the dispute reason provided by the customer or customer service representative.',
  `dispute_source_channel` STRING COMMENT 'Channel through which the customer initiated the dispute. Reference-value candidates: call_center|web_portal|mobile_app|email|mail|in_person|field_service|automated_system.',
  `dispute_status` STRING COMMENT 'Current lifecycle status of the dispute case in the resolution workflow. Reference-value candidates: open|under_investigation|pending_customer_response|pending_meter_test|pending_field_inspection|resolved|closed|escalated_to_puc|withdrawn.',
  `dispute_to_sa` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — Bill disputes are associated with a service agreement for customer service tracking and PUC complaint reporting.',
  `disputed_amount` DECIMAL(18,2) COMMENT 'Total monetary amount in dispute as claimed by the customer. Represents the portion of the invoice the customer contests.',
  `field_inspection_date` DATE COMMENT 'Date when the field inspection was conducted at the customer premise.',
  `field_inspection_required_flag` BOOLEAN COMMENT 'Indicates whether a field technician visit to the premise is required to investigate the dispute.',
  `investigation_notes` STRING COMMENT 'Detailed notes and findings documented during the dispute investigation process, including meter test results, field inspection outcomes, and billing recalculations.',
  `investigation_start_date` DATE COMMENT 'Date when formal investigation of the dispute began.',
  `meter_test_required_flag` BOOLEAN COMMENT 'Indicates whether a physical meter accuracy test is required as part of the dispute investigation.',
  `meter_test_result` STRING COMMENT 'Outcome of the meter accuracy test if performed, indicating whether the meter was found to be within acceptable tolerance. Valid values: passed|failed|inconclusive|not_performed.',
  `modified_by_user` STRING COMMENT 'User ID of the system user who last modified the dispute record.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this dispute record was last updated.',
  `preventable_flag` BOOLEAN COMMENT 'Indicates whether the dispute was caused by a preventable error or process failure on the utility\'s part, used for quality metrics and process improvement.',
  `priority_level` STRING COMMENT 'Priority classification assigned to the dispute based on factors such as disputed amount, customer segment, regulatory risk, or service impact. Valid values: low|medium|high|critical.',
  `puc_complaint_number` STRING COMMENT 'Official complaint case number assigned by the Public Utility Commission if the dispute was escalated to regulatory review.',
  `puc_escalation_date` DATE COMMENT 'Date when the dispute was formally escalated to the Public Utility Commission.',
  `regulatory_escalation_flag` BOOLEAN COMMENT 'Indicates whether the dispute has been escalated to the Public Utility Commission (PUC) or other regulatory body for formal complaint review.',
  `resolution_date` DATE COMMENT 'Date when the dispute was formally resolved and closed.',
  `resolution_notes` STRING COMMENT 'Detailed explanation of the resolution decision, including justification for credit issuance, bill upholding, or other actions taken.',
  `resolution_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the dispute status was changed to resolved or closed.',
  `resolution_type` STRING COMMENT 'Classification of how the dispute was resolved, indicating the action taken to close the case. Reference-value candidates: credit_issued|bill_upheld|partial_adjustment|rebill_issued|payment_plan_offered|service_correction|meter_replaced|dispute_withdrawn.',
  `root_cause_category` STRING COMMENT 'Classification of the underlying root cause identified during investigation, used for process improvement and quality tracking. Reference-value candidates: meter_issue|billing_system_error|rate_application_error|customer_misunderstanding|data_entry_error|estimation_error|system_integration_issue|process_failure|other.',
  `service_agreement` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — Bill disputes are associated with a service agreement/account. Required for customer service case management.',
  `sla_breach_flag` BOOLEAN COMMENT 'Indicates whether the dispute resolution exceeded the target SLA timeframe.',
  `sla_target_resolution_date` DATE COMMENT 'Target date by which the dispute must be resolved according to internal service level agreements or regulatory requirements.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_bill_dispute` PRIMARY KEY (`bill_dispute_id`)
)
USING DELTA
COMMENT 'Master entity representing a customer-initiated dispute against a billed amount or charge on an invoice. Captures dispute open date, disputed invoice, disputed amount, dispute reason (estimated read, rate error, meter malfunction, unauthorized charge), investigation status, resolution type (credit issued, bill upheld, partial adjustment), resolution date, and regulatory escalation flag. Managed within Oracle CC&B and SAP IS-U. Supports PUC complaint tracking and customer service SLAs. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'BillDispute',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.bill_dispute'
);

-- NemCredit  <<CIM Transaction : broad>>
CREATE TABLE IF NOT EXISTS `billing`.`nem_credit` (
  `nem_credit_id` BIGINT NOT NULL COMMENT 'Primary key for nem_credit',
  `account_id` BIGINT COMMENT 'Reference to the customer account that earned this NEM credit. Links to the customer billing account with behind-the-meter generation.',
  `billing_service_agreement_id` BIGINT COMMENT 'Foreign key linking to billing.billing_service_agreement. Business justification: NEM credits are earned under a specific service agreement that has NEM tariff terms and interconnection agreement details. Currently nem_credit has account_id and premise_id but no direct link to the',
  `compliance_rec_certificate_id` BIGINT COMMENT 'Foreign key linking to compliance.rec_certificate. Business justification: Net energy metering credits for customer-sited generation are often tied to renewable energy certificates for RPS compliance tracking. Links NEM export credits to the REC issued for that generation fo',
  `der_interconnection_point_id` BIGINT COMMENT 'Foreign key linking to distribution.der_interconnection_point. Business justification: NEM credits must reference the specific DER interconnection point for export metering validation, tariff rate application (location-specific export rates), interconnection agreement compliance, and IE',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: NEM credits originate from specific DER installations and must track source system for generation verification, capacity validation, and program eligibility. Required for REC tracking, interconnection',
  `dr_program_id` BIGINT COMMENT 'Foreign key linking to demand.dr_program. Business justification: Emerging VPP programs allow DR participation for NEM customers with battery storage or controllable DER. Billing systems must track both NEM export credits and DR incentive payments for same customer.',
  `generation_asset_registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: Net metering credits are generated by specific distributed generation assets (solar, wind) registered in asset_registry. Interconnection compliance, regulatory reporting, credit validation, and capaci',
  `invoice_id` BIGINT COMMENT 'Reference to the billing invoice on which this NEM credit was applied or carried forward.',
  `lmp_price_id` BIGINT COMMENT 'Foreign key linking to trading.lmp_price. Business justification: NEM export compensation rates in market-based programs reference real-time or day-ahead LMP at premise location for avoided cost valuation; required for tariff compliance, customer bill calculation, a',
  `nem_for_agreement` BIGINT COMMENT 'FK to billing.billing_service_agreement.billing_service_agreement_id — NEM credits are earned by a specific service agreement with behind-the-meter generation. This FK links credits to the customer\'s NEM billing arrangement.',
  `net_energy_metering_id` BIGINT COMMENT 'Foreign key linking to metering.net_energy_metering. Business justification: NEM credits are generated from specific DER installations (net_energy_metering records). This link tracks which solar/storage system produced the export, supports RPS compliance reporting, interconnec',
  `original_credit_nem_credit_id` BIGINT COMMENT 'Reference to the original NEM credit transaction that this record adjusts or corrects, establishing audit trail for credit modifications.',
  `premise_id` BIGINT COMMENT 'Reference to the service premise where the behind-the-meter generation equipment (solar, battery storage) is installed.',
  `rate_schedule_id` BIGINT COMMENT 'Reference to the underlying retail rate schedule that determines the credit valuation methodology for exported energy.',
  `rec_holding_id` BIGINT COMMENT 'Foreign key linking to trading.rec_holding. Business justification: Net metering programs bundling RECs with energy credits require tracking which REC inventory supports customer credits for RPS compliance verification, renewable portfolio standard reporting, and envi',
  `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: NEM credits and distributed generation exports must be reported in RPS compliance filings and renewable energy program reports. Links NEM credits to the regulatory filing where they were reported for',
  `renewable_ppa_contract_id` BIGINT COMMENT 'Foreign key linking to renewable.ppa_contract. Business justification: Some NEM arrangements involve PPA contracts for pricing export compensation above standard tariff rates. Business model for community solar, virtual net metering, and third-party owned systems where P',
  `adjustment_flag` BOOLEAN COMMENT 'Indicates whether this credit transaction is an adjustment or correction to a previously posted NEM credit.',
  `adjustment_reason_code` STRING COMMENT 'Code identifying the reason for adjustment to the NEM credit (e.g., meter read correction, tariff change, billing error correction).',
  `billing_cycle_code` STRING COMMENT 'Code identifying the billing cycle schedule during which this NEM credit was calculated and posted.',
  `created_by_user` STRING COMMENT 'User ID or system process identifier that created this NEM credit record, supporting audit and compliance requirements.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this NEM credit record was first created in the system.',
  `credit_amount` DECIMAL(18,2) COMMENT 'Total dollar value of NEM credits earned during this period, calculated as exported_energy_kwh multiplied by credit_rate_per_kwh.',
  `credit_applied_amount` DECIMAL(18,2) COMMENT 'Dollar amount of NEM credits applied to offset current billing period charges, reducing the customer\'s net invoice amount.',
  `credit_expiration_date` DATE COMMENT 'Date on which unused NEM credits from this transaction will expire if not applied, per state NEM program rules (typically 12 months).',
  `credit_period_end_date` DATE COMMENT 'End date of the billing period during which the excess energy was exported to the grid and NEM credits were earned.',
  `credit_period_start_date` DATE COMMENT 'Start date of the billing period during which the excess energy was exported to the grid and NEM credits were earned.',
  `credit_rate_per_kwh` DECIMAL(12,6) COMMENT 'Dollar amount per kWh credited to the customer for exported energy, as defined by the applicable NEM tariff schedule.',
  `credit_status` STRING COMMENT 'Current lifecycle status of the NEM credit transaction in the billing and accounts receivable system. Valid values: earned|applied|expired|forfeited|pending|disputed.',
  `credit_transaction_number` STRING COMMENT 'Business identifier for the NEM credit transaction, used for customer communication and dispute resolution.',
  `credit_type` STRING COMMENT 'Classification of the NEM credit based on the value stream being compensated (energy, capacity, environmental attributes). Valid values: energy_export|capacity_credit|renewable_energy_certificate|ancillary_service.',
  `cumulative_credit_balance` DECIMAL(18,2) COMMENT 'Running total of unused NEM credits available on the customer account after this transaction, including prior period carryover.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this credit transaction (typically USD). Pattern: ^[A-Z]{3}$.',
  `dispute_flag` BOOLEAN COMMENT 'Indicates whether the customer has disputed the NEM credit calculation or application, triggering investigation and resolution workflow.',
  `dispute_reason_code` STRING COMMENT 'Code identifying the reason for customer dispute of the NEM credit (e.g., incorrect meter reading, wrong tariff applied, calculation error).',
  `exported_energy_kwh` DECIMAL(18,3) COMMENT 'Total kilowatt-hours of excess energy exported from the customer\'s behind-the-meter generation to the utility grid during the credit period.',
  `generation_technology_type` STRING COMMENT 'Type of behind-the-meter distributed energy resource (DER) technology generating the exported energy. Valid values: solar_pv|battery_storage|wind|combined_heat_power|fuel_cell|other.',
  `gl_account_code` STRING COMMENT 'General ledger account code for posting NEM credit transactions to the financial accounting system, supporting revenue recognition and regulatory reporting.',
  `installed_capacity_kw` DECIMAL(12,3) COMMENT 'Nameplate capacity in kilowatts of the customer\'s behind-the-meter generation equipment registered for NEM participation.',
  `interconnection_agreement_number` STRING COMMENT 'Unique identifier of the utility interconnection agreement authorizing the customer\'s DER to export energy to the grid.',
  `jurisdiction_code` STRING COMMENT 'State or regulatory jurisdiction code governing the NEM program rules and tariff provisions applicable to this credit.',
  `meter_number` STRING COMMENT 'Identifier of the bidirectional meter measuring both imported and exported energy at the customer premise.',
  `modified_by_user` STRING COMMENT 'User ID or system process identifier that last modified this NEM credit record, supporting audit and compliance requirements.',
  `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this NEM credit record was last modified or updated.',
  `nem_tariff_code` STRING COMMENT 'Code identifying the specific NEM tariff schedule version applicable to this credit transaction (e.g., NEM 1.0, NEM 2.0, NEM 3.0).',
  `nem_tariff_version` STRING COMMENT 'Version identifier of the NEM tariff schedule, reflecting regulatory changes and grandfathering provisions.',
  `posted_timestamp` TIMESTAMP COMMENT 'Date and time when the NEM credit transaction was posted to the customer account in the billing system.',
  `regulatory_account_code` STRING COMMENT 'Regulatory accounting code for tracking NEM program costs and benefits in rate case filings and PUC compliance reports.',
  `renewable_energy_certificate_flag` BOOLEAN COMMENT 'Indicates whether renewable energy certificates associated with the exported energy are retained by the customer or transferred to the utility.',
  `rps_compliance_eligible_flag` BOOLEAN COMMENT 'Indicates whether the exported energy qualifies for the utility\'s RPS compliance obligations under state renewable energy mandates.',
  `service_territory_code` STRING COMMENT 'Utility service territory code where the customer premise and DER interconnection are located.',
  `tou_period_code` STRING COMMENT 'Time-of-use period classification for exported energy, affecting credit rate when NEM tariff includes TOU differentiation.',
  `true_up_period_flag` BOOLEAN COMMENT 'Indicates whether this credit transaction is part of an annual true-up reconciliation period where unused credits are settled or forfeited.',
  `true_up_settlement_date` DATE COMMENT 'Date of the annual true-up settlement when cumulative NEM credits are reconciled and excess credits are either paid out or forfeited per tariff rules.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_nem_credit` PRIMARY KEY (`nem_credit_id`)
)
USING DELTA
COMMENT 'Transactional record of NEM (Net Energy Metering) credits earned by a customer with behind-the-meter generation (rooftop solar, battery storage) for excess energy exported to the grid. Captures credit period, exported kWh, credit rate ($/kWh), credit amount, cumulative credit balance, credit expiration date, and applicable NEM tariff version. Sourced from Oracle CC&B NEM billing module. Supports state RPS and NEM regulatory compliance reporting. | CMM: CIM Transaction (broad), IEC61968::PaymentMetering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'NemCredit',
  'cmm.cim.class' = 'Transaction',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61968::PaymentMetering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.nem_credit'
);

-- AssistanceProgram  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `billing`.`assistance_program` (
  `assistance_program_id` BIGINT NOT NULL COMMENT 'Primary key for assistance_program',
  `billing_service_agreement_id` BIGINT COMMENT 'Reference to the service agreement receiving the assistance program benefit.',
  `interconnection_application_id` BIGINT COMMENT 'Foreign key linking to interconnection.application. Business justification: Equity-focused interconnection programs (SGIP equity resiliency budget, community solar for low-income) coordinate with utility financial assistance programs. Business process: Eligibility verificatio',
  `irp_scenario_id` BIGINT COMMENT 'Foreign key linking to forecast.irp_scenario. Business justification: Low-income assistance programs are designed and funded based on rate impact projections from IRP scenarios. Program budgets and eligibility thresholds reference specific IRP scenarios to ensure afford',
  `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: Low-income assistance programs require annual reporting to regulatory commissions on enrollment, costs, and effectiveness. Links the program to the regulatory filing where program performance and cost',
  `renewable_incentive_program_id` BIGINT COMMENT 'Foreign key linking to renewable.incentive_program. Business justification: Low-income assistance programs often stack with renewable incentives for solar installations, energy efficiency, and green tariffs. Regulatory coordination required to ensure customers receive combine',
  `application_date` DATE COMMENT 'Date the customer submitted the application for the assistance program.',
  `application_method` STRING COMMENT 'Method by which the customer applied for the assistance program. Valid values: online|phone|mail|in_person|agency_referral|auto_enrollment.',
  `approval_date` DATE COMMENT 'Date the customer application was approved for enrollment in the assistance program.',
  `approved_by_user` STRING COMMENT 'User ID or name of the representative who approved the assistance program enrollment.',
  `assistance_to_sa` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — After merging program_enrollment, the assistance_program entity needs a link to service_agreement to track which accounts are enrolled in which programs.',
  `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether the enrollment is eligible for automatic renewal without re-application.',
  `benefit_type` STRING COMMENT 'Type of financial benefit provided by the assistance program. Valid values: percentage_discount|fixed_credit|tiered_discount|arrearage_forgiveness|rate_reduction.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this assistance program enrollment record was first created in the system.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this record (e.g., USD). Pattern: ^[A-Z]{3}$.',
  `disenrollment_date` DATE COMMENT 'Date the customer was disenrolled or removed from the assistance program.',
  `disenrollment_reason` STRING COMMENT 'Reason for customer disenrollment from the assistance program (e.g., income exceeded threshold, failed recertification, customer request, account closed, moved out of service territory).',
  `effective_end_date` DATE COMMENT 'Date when the assistance program benefits cease applying to the customer account. Null for open-ended enrollments.',
  `effective_start_date` DATE COMMENT 'Date when the assistance program benefits begin applying to the customer account.',
  `eligibility_criteria` STRING COMMENT 'Description of the eligibility requirements for the assistance program (e.g., income threshold, household size, participation in other programs).',
  `enrollment_date` DATE COMMENT 'Date the customer was enrolled in the financial assistance program.',
  `enrollment_status` STRING COMMENT 'Current lifecycle status of the customer enrollment in the assistance program. Valid values: pending|active|suspended|expired|terminated|denied.',
  `funding_source` STRING COMMENT 'Primary source of funding for the assistance program benefits. Valid values: federal|state|utility|ratepayer|grant|other.',
  `income_threshold_amount` DECIMAL(15,2) COMMENT 'Maximum annual household income threshold for program eligibility.',
  `income_threshold_percentage_fpl` DECIMAL(5,2) COMMENT 'Income threshold expressed as a percentage of the Federal Poverty Level (e.g., 200.00 for 200% of FPL).',
  `last_modified_by_user` STRING COMMENT 'User ID or name of the representative who last modified this assistance program enrollment record.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this assistance program enrollment record was last updated in the system.',
  `maximum_benefit_amount` DECIMAL(15,2) COMMENT 'Maximum total benefit amount the customer can receive under the assistance program during the enrollment period.',
  `notes` STRING COMMENT 'Free-text notes or comments regarding the assistance program enrollment, eligibility determination, or special circumstances.',
  `program_code` STRING COMMENT 'Unique code identifying the assistance program type (e.g., LIHEAP, CARE, FERA, AMP). Pattern: ^[A-Z0-9_]{2,20}$.',
  `program_name` STRING COMMENT 'Full name of the financial assistance program (e.g., Low Income Home Energy Assistance Program, California Alternate Rates for Energy, Family Electric Rate Assistance).',
  `program_period_end_date` DATE COMMENT 'End date of the program period or program year for which this enrollment is valid.',
  `program_period_start_date` DATE COMMENT 'Start date of the program period or program year for which this enrollment is valid.',
  `program_type` STRING COMMENT 'Classification of the assistance program benefit structure. Valid values: discount|credit|arrearage_forgiveness|payment_plan|energy_efficiency.',
  `puc_docket_number` STRING COMMENT 'PUC docket or proceeding number under which the assistance program was approved. Pattern: ^[A-Z0-9\\-\\.]{5,30}$.',
  `regulatory_mandate` STRING COMMENT 'Regulatory requirement or mandate authorizing the assistance program (e.g., PUC decision number, state statute reference).',
  `service_agreement` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — Program enrollments (now within assistance_program) are linked to a specific service agreement. Required for benefit application and eligibility tracking.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_assistance_program` PRIMARY KEY (`assistance_program_id`)
)
USING DELTA
COMMENT 'Reference and transactional entity defining utility-administered financial assistance programs and tracking individual customer enrollments. At the program level: captures program name (LIHEAP, CARE, FERA, arrearage management), eligibility criteria, benefit type (discount rate, bill credit, arrearage forgiveness), maximum benefit amount, funding source, regulatory mandate, and program period. At the enrollment level: captures enrollment date, enrolled service agreement, program type, eligibility verification status, benefit amount, enrollment expiration date, re-certification due date, disenrollment reason, and enrollment status. Sourced from Oracle CC&B program management and SAP IS-U. SSOT for all financial assistance program definitions and customer enrollment records. Supports PUC low-income program compliance reporting and customer affordability tracking. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AssistanceProgram',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'reference_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.assistance_program'
);

-- BillingProgramEnrollment  <<CIM Agreement : extension>>
CREATE TABLE IF NOT EXISTS `billing`.`billing_program_enrollment` (
  `billing_program_enrollment_id` BIGINT NOT NULL COMMENT 'Unique identifier for the customer program enrollment record. Primary key for the program enrollment entity.',
  `account_id` BIGINT COMMENT 'Reference to the customer account enrolled in the program. Links to the customer account master entity.',
  `billing_employee_id` BIGINT COMMENT 'User identifier of the utility employee who approved the program enrollment application. Used for audit trail and accountability.',
  `billing_last_modified_by_user_employee_id` BIGINT COMMENT 'User identifier of the person who last modified this program enrollment record. Used for audit trail and accountability.',
  `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.program. Business justification: Customer program enrollments (demand response, energy efficiency, low-income assistance) are tracked under compliance programs for regulatory reporting and program administration. Links enrollment to',
  `demand_dr_enrollment_id` BIGINT COMMENT 'Foreign key linking to demand.dr_enrollment. Business justification: Generic program enrollment table tracks all utility program participation including DR alongside low-income assistance, budget billing, etc. Customer service, program administration, and unified custo',
  `green_tariff_subscription_id` BIGINT COMMENT 'Foreign key linking to renewable.green_tariff_subscription. Business justification: Green tariff subscriptions are a specific type of program enrollment where customers purchase renewable energy blocks or percentages. Direct relationship required for billing premium charges, allocati',
  `payment_arrangement_id` BIGINT COMMENT 'Reference to the associated payment arrangement for arrearage management program enrollments. Links to payment arrangement master entity.',
  `premise_id` BIGINT COMMENT 'Reference to the service premise associated with this program enrollment. Links to the premise master entity.',
  `renewable_incentive_program_id` BIGINT COMMENT 'Foreign key linking to renewable.incentive_program. Business justification: Customers enroll in renewable incentive programs through utility billing systems for solar rebates, green tariffs, and DER programs. Enrollment tracking links customer accounts to program eligibility,',
  `sgip_enrollment_id` BIGINT COMMENT 'Foreign key linking to interconnection.sgip_enrollment. Business justification: SGIP (Self-Generation Incentive Program) enrollment for battery storage requires coordinated enrollment in specific utility rate schedules (TOU rates for optimal dispatch). Business process: Program a',
  `application_date` DATE COMMENT 'Date the customer submitted the program enrollment application. Used for tracking application processing time and eligibility determination.',
  `approval_date` DATE COMMENT 'Date on which the program enrollment application was approved by the utility. Used for processing time metrics and audit trail.',
  `auto_renew_flag` BOOLEAN COMMENT 'Indicates whether the program enrollment automatically renews upon expiration (True) or requires manual re-enrollment (False). Used for enrollment lifecycle management.',
  `benefit_amount` DECIMAL(15,2) COMMENT 'Monthly or per-billing-cycle discount or credit amount provided to the customer under this program enrollment. Used for rate calculation and revenue impact analysis. Expressed in local currency.',
  `benefit_percentage` DECIMAL(5,2) COMMENT 'Percentage discount applied to eligible charges under this program enrollment (e.g., 20% discount on energy charges for CARE customers). Used when benefit is calculated as a percentage rather than fixed amount.',
  `budget_billing_amount` DECIMAL(15,2) COMMENT 'Fixed monthly payment amount for budget billing program enrollments. Calculated based on historical usage and periodically adjusted. Expressed in local currency.',
  `budget_billing_review_date` DATE COMMENT 'Next scheduled date for budget billing amount review and adjustment. Typically occurs annually or semi-annually to true-up actual vs. budgeted usage.',
  `consent_date` DATE COMMENT 'Date on which customer consent or authorization was obtained. Used for compliance tracking and audit trail.',
  `consent_method` STRING COMMENT 'Method by which customer consent was obtained: written signature, electronic acceptance, verbal authorization (recorded), or implied consent. Valid values: written|electronic|verbal|implied.',
  `consent_received_flag` BOOLEAN COMMENT 'Indicates whether customer consent or authorization was received for program enrollment (True/False). Required for regulatory compliance and audit purposes.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this program enrollment record was first created in the system. Used for audit trail and data lineage tracking.',
  `discount_type` STRING COMMENT 'Type of discount calculation method applied: fixed amount (flat monthly credit), percentage (percent off eligible charges), tiered (discount varies by usage tier), usage-based (discount calculated from consumption). Valid values: fixed_amount|percentage|tiered|usage_based.',
  `disenrollment_date` DATE COMMENT 'Date the customer was disenrolled or removed from the program. Null for active enrollments. Used for churn analysis and program retention metrics.',
  `disenrollment_initiated_by` STRING COMMENT 'Party that initiated the disenrollment: customer (voluntary opt-out), utility (administrative removal), automatic (system-triggered expiration), regulator (compliance action). Valid values: customer|utility|automatic|regulator.',
  `disenrollment_reason` STRING COMMENT 'Reason for program disenrollment: customer request (voluntary withdrawal), ineligibility (no longer qualifies), non-payment (payment arrangement breach), moved (service transfer), deceased, program ended (utility discontinued), failed re-certification (did not complete renewal). Reference-value candidates: customer_request|ineligibility|non_payment|moved|deceased|program_ended|failed_recertification.',
  `effective_end_date` DATE COMMENT 'Date on which the program enrollment expires or terminates. Null for open-ended enrollments. Used for automatic disenrollment processing and re-certification scheduling.',
  `effective_start_date` DATE COMMENT 'Date from which the program benefits and terms become effective for billing and rate calculation purposes. May differ from enrollment date due to billing cycle alignment.',
  `eligibility_verification_date` DATE COMMENT 'Date on which eligibility verification was completed and approved. Used for audit trail and compliance reporting to regulatory authorities.',
  `eligibility_verification_method` STRING COMMENT 'Method used to verify customer eligibility for the program: income documentation (pay stubs/tax returns), categorical eligibility (participation in other assistance programs), third-party verification (government database check), self-certification, or automatic enrollment. Valid values: income_documentation|categorical_eligibility|third_party_verification|self_certification|automatic_enrollment.',
  `eligibility_verification_status` STRING COMMENT 'Status of the eligibility verification process for income-qualified or regulated programs: not verified (initial state), verified (eligibility confirmed), pending verification (under review), verification failed (did not meet criteria), exempt (no verification required). Valid values: not_verified|verified|pending_verification|verification_failed|exempt.',
  `enrollment_channel` STRING COMMENT 'Channel through which the customer enrolled in the program: online portal, phone call center, mail application, in-person at office, automatic enrollment by utility, or third-party agency. Valid values: online|phone|mail|in_person|automatic|third_party.',
  `enrollment_date` DATE COMMENT 'Date the customer was officially enrolled in the program and benefits became effective. Key business event timestamp for program participation lifecycle.',
  `enrollment_number` STRING COMMENT 'Business-facing unique enrollment number assigned to this program participation record. Used for customer communication and service inquiries.',
  `enrollment_status` STRING COMMENT 'Current lifecycle status of the program enrollment: pending (application submitted), active (enrolled and receiving benefits), suspended (temporarily inactive), expired (term ended), cancelled (customer or utility terminated), denied (application rejected). Valid values: pending|active|suspended|expired|cancelled|denied.',
  `expiration_date` DATE COMMENT 'Scheduled expiration date for time-limited program enrollments requiring periodic re-certification (e.g., annual CARE/FERA re-qualification). Triggers re-certification workflow.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this program enrollment record was last updated. Used for change tracking and audit trail.',
  `last_recertification_date` DATE COMMENT 'Date of the most recent successful re-certification or eligibility verification. Used to calculate next re-certification due date and track compliance history.',
  `notes` STRING COMMENT 'Free-text notes or comments regarding the program enrollment. Used for documenting special circumstances, customer requests, or processing exceptions.',
  `priority_flag` BOOLEAN COMMENT 'Indicates whether this enrollment has priority status for special handling (True/False). Used for life support, medical baseline, or critical care programs requiring expedited service.',
  `program_code` STRING COMMENT 'Standardized code identifying the utility billing program type (e.g., CARE, FERA, BUDGET, AUTOPAY, PAPERLESS, ARREARAGE, TOU, CPP, NEM, DR).',
  `program_name` STRING COMMENT 'Full descriptive name of the utility billing program (e.g., California Alternate Rates for Energy, Family Electric Rate Assistance, Budget Billing Plan, Auto-Pay Enrollment, Paperless Billing, Arrearage Management Program).',
  `program_type` STRING COMMENT 'High-level classification of the program category: rate assistance programs (CARE/FERA), payment plans (budget billing/arrearage management), billing convenience (auto-pay/paperless), energy efficiency, demand response, net metering, or other. Reference-value candidates: rate_assistance|payment_plan|billing_convenience|energy_efficiency|demand_response|net_metering|other.',
  `puc_approval_number` STRING COMMENT 'PUC decision or resolution number authorizing this program. Required for regulatory compliance and audit documentation.',
  `rate_schedule_code` STRING COMMENT 'Rate schedule or tariff code applicable to this program enrollment. Used for billing calculation and rate application. May differ from standard rate for discount programs.',
  `recertification_due_date` DATE COMMENT 'Date by which the customer must complete re-certification to maintain program eligibility. Applicable to income-qualified and regulatory programs requiring periodic eligibility verification.',
  `regulatory_program_code` STRING COMMENT 'Regulatory or compliance program code assigned by the Public Utility Commission (PUC) or governing body. Used for regulatory reporting and cost recovery tracking.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_billing_program_enrollment` PRIMARY KEY (`billing_program_enrollment_id`)
)
USING DELTA
COMMENT 'Transactional master entity representing a customer account enrollment in a utility billing program such as CARE, FERA, budget billing, auto-pay, paperless billing, or arrearage management. Captures enrollment date, program type, eligibility verification status, benefit amount, enrollment expiration date, re-certification due date, and disenrollment reason. Managed within Oracle CC&B and SAP IS-U. SSOT for all customer program participation records in the billing domain. | CMM: CIM Agreement (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'BillingProgramEnrollment',
  'cmm.cim.class' = 'Agreement',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.billing_program_enrollment'
);

-- ArLedger  <<CIM ErpReceivable : close>>
CREATE TABLE IF NOT EXISTS `billing`.`ar_ledger` (
  `ar_ledger_id` BIGINT NOT NULL COMMENT 'Primary key for ar_ledger',
  `account_id` BIGINT COMMENT 'Reference to the customer account associated with this AR ledger entry. Links to the customer account master.',
  `ar_gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: AR ledger entries directly map to GL accounts for subledger-to-GL reconciliation. Essential for month-end close, external audits, SOX compliance, and ensuring billing subledger balances tie to general',
  `ar_invoice_id` BIGINT COMMENT 'Reference to the invoice document that originated this AR ledger entry, if applicable. Null for non-invoice postings such as payments or adjustments.',
  `collections_id` BIGINT COMMENT 'Reference to the associated collections case if this AR ledger entry is part of an active collections effort. Null if no collections case exists.',
  `invoice_id` BIGINT COMMENT 'FK to billing.invoice.invoice_id — AR ledger postings reference specific invoices for open item management. Required for FICA clearing and SOX controls.',
  `payment_arrangement_id` BIGINT COMMENT 'Reference to the payment arrangement plan if this AR ledger entry is covered by an installment agreement. Null if no payment arrangement exists.',
  `primary_ar_employee_id` BIGINT COMMENT 'User ID of the authorized approver who approved this write-off. Null for non-write-off entries. Required for SOX internal controls and audit trail.',
  `primary_invoice_id` BIGINT COMMENT 'FK to billing.invoice.invoice_id — AR ledger entries reference the source invoice document for open item management and clearing.',
  `aging_bucket` STRING COMMENT 'Classification of this AR ledger entry based on the number of days past due. Used for aging reports and collections prioritization. Calculated from posting date and due date. Valid values: current|1_30_days|31_60_days|61_90_days|over_90_days.',
  `ar_to_sa` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — AR ledger entries are posted for a specific service agreement. This FK is the backbone of the customer AR sub-ledger.',
  `bad_debt_gl_account_code` STRING COMMENT 'The general ledger account code for bad debt expense associated with this write-off. Null for non-write-off entries. Used for financial statement preparation.',
  `clearing_date` DATE COMMENT 'The date on which this AR ledger entry was cleared (fully paid or offset). Null for open items.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this AR ledger entry record was first created in the system. Used for audit trail and data lineage tracking.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the amounts in this AR ledger entry. Typically USD for US utilities. Pattern: ^[A-Z]{3}$.',
  `debit_credit_indicator` STRING COMMENT 'Indicates whether this AR ledger entry is a debit (increases receivable balance) or credit (decreases receivable balance). Invoices and adjustments are typically debits; payments and refunds are credits. Valid values: debit|credit.',
  `dispute_date` DATE COMMENT 'The date on which the customer initiated a dispute for this AR ledger entry. Null if no dispute exists.',
  `dispute_flag` BOOLEAN COMMENT 'Indicates whether this AR ledger entry is under dispute by the customer. True if disputed; false otherwise. Disputed items may be excluded from collections activity.',
  `dispute_reason_code` STRING COMMENT 'Standardized code indicating the reason for the customer dispute. Examples include billing error, meter reading issue, rate dispute. Null if no dispute exists.',
  `document_date` DATE COMMENT 'The business date of the underlying transaction or event that gave rise to this AR ledger entry. May differ from posting date for backdated or future-dated transactions.',
  `document_number` STRING COMMENT 'The externally-known unique document number for this AR ledger entry as recorded in the financial system. Used for audit trail and reconciliation.',
  `document_type` STRING COMMENT 'Type of financial document represented by this AR ledger entry. Determines the nature of the posting and its impact on the customer balance. Reference-value candidates: invoice|payment|adjustment|write-off|refund|credit_memo|debit_memo|reversal.',
  `due_date` DATE COMMENT 'The date by which payment is expected for this AR ledger entry. Used for aging calculations and collections prioritization. Null for non-invoice postings.',
  `fiscal_period` INT COMMENT 'The fiscal period (month) within the fiscal year in which this AR ledger entry was posted. Used for monthly financial reporting and variance analysis.',
  `fiscal_year` INT COMMENT 'The fiscal year in which this AR ledger entry was posted. Used for period-based financial reporting and year-end closing processes.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this AR ledger entry record was last updated in the system. Used for audit trail and change tracking.',
  `notes` STRING COMMENT 'Free-form text field for additional comments, explanations, or special handling instructions related to this AR ledger entry. Used for audit trail and customer service reference.',
  `original_amount` DECIMAL(18,2) COMMENT 'The original posted amount of this AR ledger entry in the transaction currency. Represents the gross amount before any partial payments or adjustments.',
  `outstanding_amount` DECIMAL(18,2) COMMENT 'The remaining unpaid balance of this AR ledger entry in the transaction currency. Equals original amount minus any payments or offsets applied. Zero for cleared items.',
  `payment_method_code` STRING COMMENT 'The payment method used for this AR ledger entry if it represents a payment. Examples include check, credit card, ACH, cash. Null for non-payment entries.',
  `payment_reference_number` STRING COMMENT 'External reference number for the payment transaction, such as check number, credit card authorization code, or ACH trace number. Null for non-payment entries.',
  `posting_date` DATE COMMENT 'The date on which this AR ledger entry was posted to the financial system. Used for period-based financial reporting and aging analysis.',
  `posting_status` STRING COMMENT 'Current lifecycle status of the AR ledger entry. Open items represent outstanding receivables; cleared items have been fully paid or offset. Valid values: open|cleared|partially_cleared|reversed|disputed.',
  `recovery_tracking_status` STRING COMMENT 'Status of efforts to recover a written-off receivable. Tracks whether the utility is still pursuing collection or has abandoned recovery efforts. Not applicable for non-write-off entries. Valid values: not_applicable|pending_recovery|recovered|abandoned.',
  `revenue_class` STRING COMMENT 'Classification of revenue type for regulatory and financial reporting purposes. Examples include residential, commercial, industrial, street lighting.',
  `revenue_recognition_date` DATE COMMENT 'The date on which revenue associated with this AR ledger entry is recognized for financial reporting purposes. May differ from posting date based on revenue recognition policies.',
  `reversal_flag` BOOLEAN COMMENT 'Indicates whether this AR ledger entry is a reversal of a previous posting. True for reversal entries; false otherwise. Used for audit trail and error correction tracking.',
  `reversed_document_number` STRING COMMENT 'The document number of the original AR ledger entry that this reversal entry is offsetting. Null for non-reversal entries. Establishes audit trail linkage.',
  `service_agreement` BIGINT COMMENT 'FK to billing.service_agreement.service_agreement_id — AR ledger postings are recorded against a service agreement/account. SSOT for customer AR balance.',
  `service_territory_code` STRING COMMENT 'Code identifying the geographic service territory or regulatory jurisdiction associated with this AR ledger entry. Used for regulatory reporting and revenue allocation.',
  `write_off_amount` DECIMAL(18,2) COMMENT 'The amount written off as uncollectable bad debt. Null for non-write-off entries. Represents the reduction in accounts receivable and corresponding bad debt expense.',
  `write_off_date` DATE COMMENT 'The date on which this receivable was written off as uncollectable. Null for non-write-off entries. Used for bad debt expense tracking and PUC reporting.',
  `write_off_flag` BOOLEAN COMMENT 'Indicates whether this AR ledger entry represents a write-off of uncollectable debt. True for write-off postings; false otherwise.',
  `write_off_reason_code` STRING COMMENT 'Standardized code indicating the reason for writing off this receivable. Used for bad debt analysis and regulatory reporting. Null for non-write-off entries. Valid values: bankruptcy|skip|hardship|deceased|small_balance|statute_of_limitations.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_ar_ledger` PRIMARY KEY (`ar_ledger_id`)
)
USING DELTA
COMMENT 'Transactional entity representing the accounts receivable sub-ledger for customer billing activity, capturing all open item postings including invoiced amounts, payments applied, adjustments, write-offs, balance carry-forwards, and bad debt entries. Stores posting date, document type (invoice, payment, adjustment, write-off, refund), debit/credit indicator, amount, clearing status, clearing date, and GL account. For write-off postings: captures write-off date, write-off amount, reason (bankruptcy, skip, hardship, deceased), approval authority, bad debt GL account, recovery tracking status, and associated collections case reference. Sourced from SAP IS-U FICA open item management and SAP S/4HANA AR sub-ledger. SSOT for customer AR balance, write-off tracking, and bad debt management supporting SOX financial controls and PUC uncollectable expense reporting. | CMM: CIM ErpReceivable (close), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ArLedger',
  'cmm.cim.class' = 'ErpReceivable',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.ar_ledger'
);

-- CustomerRefund  <<CIM Transaction : close>>
CREATE TABLE IF NOT EXISTS `billing`.`refund` (
  `refund_id` BIGINT NOT NULL COMMENT 'Unique identifier for the refund transaction. Primary key for the refund product.',
  `account_id` BIGINT COMMENT 'Reference to the customer account that received the refund. Links to the billing account in the customer domain.',
  `bill_dispute_id` BIGINT COMMENT 'Reference to the customer dispute or complaint case that triggered this refund. Links to customer service resolution tracking.',
  `credit_memo_id` BIGINT COMMENT 'Reference to the credit memo document that authorized this refund. Links to the billing adjustment that created the refundable credit.',
  `deposit_id` BIGINT COMMENT 'FK to billing.deposit.deposit_id — Deposit refunds are a primary refund type. This FK links the refund disbursement back to the originating deposit for financial reconciliation. Note: not all refunds are deposit-related, so this is a n',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Refunds post to specific GL accounts to reverse revenue or record expense. Link enables proper financial statement presentation, cash flow tracking, and regulatory reporting of customer refunds and ov',
  `invoice_id` BIGINT COMMENT 'Reference to the original invoice that generated the credit or overpayment leading to this refund. May be null for deposit returns.',
  `payment_id` BIGINT COMMENT 'Foreign key linking to billing.payment. Business justification: Refunds can be issued for overpayments, and linking to the original payment enables full audit trail and reconciliation. Currently refund has account_id and invoice_id but no link to the payment being',
  `refund_employee_id` BIGINT COMMENT 'System user identifier of the employee who authorized the refund. Required for SOX audit trail and segregation of duties compliance.',
  `refund_modified_by_user_employee_id` BIGINT COMMENT 'System user identifier of the employee who last modified this refund record. Required for SOX audit trail and change tracking.',
  `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: Refunds often result from service quality issues, meter inaccuracies, or outage credits documented in work orders. Customer service, audit trails, and regulatory compliance require traceability from r',
  `amount` DECIMAL(18,2) COMMENT 'The gross monetary value of the refund issued to the customer before any adjustments or withholdings.',
  `approval_date` DATE COMMENT 'The date when the refund was formally approved by an authorized user. Establishes the point of financial commitment.',
  `approval_status` STRING COMMENT 'Current state of the refund approval workflow. Tracks whether the refund has passed required authorization controls. Valid values: pending|approved|rejected|escalated.',
  `approval_threshold_level` STRING COMMENT 'The authorization level required for this refund based on amount thresholds and business rules. Supports tiered approval workflows. Valid values: auto|supervisor|manager|director|executive.',
  `bank_account_number` STRING COMMENT 'The customer bank account number for ACH or wire transfer refunds. Encrypted at rest per PCI-DSS requirements.',
  `bank_routing_number` STRING COMMENT 'The ABA routing transit number for the customer financial institution. Required for ACH and wire transfer processing.',
  `cleared_date` DATE COMMENT 'The date when the refund payment was confirmed as cleared or cashed by the customer or their bank. Used for cash flow reconciliation.',
  `cost_center_code` STRING COMMENT 'The organizational cost center responsible for this refund. Used for internal financial reporting and budget tracking.',
  `created_timestamp` TIMESTAMP COMMENT 'The system timestamp when this refund record was first created in the billing system. Used for audit trail and data lineage.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the refund transaction. Typically USD for US-based utilities. Pattern: ^[A-Z]{3}$.',
  `disbursement_date` DATE COMMENT 'The date when the refund payment was physically issued or electronically transmitted to the customer or their financial institution.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The system timestamp when this refund record was last updated. Tracks the most recent change for audit and reconciliation purposes.',
  `net_refund_amount` DECIMAL(18,2) COMMENT 'The final amount disbursed to the customer after all adjustments, withholdings, and offsets have been applied.',
  `notes` STRING COMMENT 'Free-form text field for additional context, special instructions, or audit notes related to the refund transaction.',
  `originating_credit_source` STRING COMMENT 'The upstream transaction or business process that created the credit balance leading to this refund. Enables traceability to root cause. Valid values: payment|deposit|adjustment|rate_change|meter_correction|billing_reversal.',
  `payee_address_line1` STRING COMMENT 'Primary street address line for the refund recipient. Used for check mailing and payment verification.',
  `payee_address_line2` STRING COMMENT 'Secondary address line for apartment, suite, or unit number. Optional address component for refund delivery.',
  `payee_city` STRING COMMENT 'City name for the refund recipient address. Required for payment processing and tax reporting.',
  `payee_country_code` STRING COMMENT 'Three-letter ISO country code for the refund recipient address. Used for international payment processing and compliance. Pattern: ^[A-Z]{3}$.',
  `payee_name` STRING COMMENT 'The legal name of the individual or entity receiving the refund. May differ from account holder for third-party payments.',
  `payee_postal_code` STRING COMMENT 'ZIP or postal code for the refund recipient address. Required for payment delivery and address validation.',
  `payee_state_province` STRING COMMENT 'State or province code for the refund recipient address. Used for tax jurisdiction determination and regulatory reporting.',
  `payment_instrument_number` STRING COMMENT 'The check number, ACH trace number, wire confirmation number, or other instrument identifier for the disbursement. Used for reconciliation.',
  `reason_code` STRING COMMENT 'Detailed code identifying the specific reason for the refund. Used for root cause analysis and process improvement tracking.',
  `reason_description` STRING COMMENT 'Human-readable explanation of why the refund was issued. Provides context for customer service and audit purposes.',
  `refund_date` DATE COMMENT 'The business date when the refund was officially issued or approved for disbursement. Principal business event timestamp for this transaction.',
  `refund_method` STRING COMMENT 'The disbursement instrument or mechanism used to deliver the refund to the customer. Determines processing time and cost. Valid values: check|ach|wire_transfer|account_credit|debit_card|prepaid_card.',
  `refund_number` STRING COMMENT 'Business-facing unique refund document number used for customer communication and audit trails. Externally visible identifier.',
  `refund_status` STRING COMMENT 'Current lifecycle status of the refund transaction. Tracks progression from approval through disbursement and clearing. Reference-value candidates: pending|approved|rejected|issued|cleared|cancelled|voided.',
  `refund_type` STRING COMMENT 'Classification of the refund based on the originating business reason. Determines accounting treatment and regulatory reporting category. Valid values: overpayment|deposit_return|billing_error|credit_balance|rate_adjustment|meter_error.',
  `regulatory_reporting_flag` BOOLEAN COMMENT 'Indicates whether this refund must be included in regulatory filings to state PUC or FERC. True if reportable under utility commission rules.',
  `revenue_class` STRING COMMENT 'The customer class or rate category associated with this refund. Used for regulatory reporting and revenue analysis. Valid values: residential|commercial|industrial|agricultural|public_authority.',
  `service_territory_code` STRING COMMENT 'The geographic service territory or jurisdiction where the refunded service was provided. Used for regulatory compliance reporting.',
  `sox_control_flag` BOOLEAN COMMENT 'Indicates whether this refund is subject to SOX internal control testing and audit procedures. True for material transactions requiring enhanced controls.',
  `tax_amount` DECIMAL(18,2) COMMENT 'Portion of the refund amount representing sales tax, utility tax, or other regulatory taxes being returned to the customer.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_refund` PRIMARY KEY (`refund_id`)
)
USING DELTA
COMMENT 'Transactional record of a refund issued to a customer for overpayment, deposit return, credit balance, or billing error correction. Captures refund date, amount, method (check, ACH, account credit), reason code, originating credit source, approval status, and disbursement confirmation. Sourced from SAP IS-U FICA and Oracle CC&B. Supports cash disbursement controls and SOX compliance. | CMM: CIM Transaction (close), IEC61968::PaymentMetering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CustomerRefund',
  'cmm.cim.class' = 'Transaction',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::PaymentMetering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.refund'
);

-- ServiceAgreementIncentiveEnrollment  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `billing`.`service_agreement_incentive_enrollment` (
  `service_agreement_incentive_enrollment_id` BIGINT NOT NULL COMMENT 'Unique identifier for this enrollment record. Primary key for the association.',
  `billing_service_agreement_id` BIGINT COMMENT 'Foreign key to the billing service agreement participating in this enrollment.',
  `renewable_incentive_program_id` BIGINT COMMENT 'Foreign key linking to the renewable incentive program in which the service agreement is enrolled',
  `service_agreement_billing_service_agreement_id` BIGINT COMMENT 'Foreign key linking to the billing service agreement enrolled in the incentive program',
  `application_reference_number` STRING COMMENT 'External reference number from the program application or approval process for this enrollment.',
  `approved_incentive_amount` DECIMAL(18,2) COMMENT 'Total incentive amount approved for this service agreement under this specific program in USD. Explicitly identified in detection phase relationship data.',
  `compliance_status` STRING COMMENT 'Current compliance status of this enrollment indicating whether the service agreement meets ongoing program requirements. Explicitly identified in detection phase relationship data.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this enrollment record was created in the system.',
  `effective_end_date` DATE COMMENT 'Date when incentive payments cease for this enrollment. Null for active enrollments with no scheduled end date.',
  `effective_start_date` DATE COMMENT 'Date when incentive payments begin for this enrollment. May differ from enrollment_date due to approval processing time.',
  `enrollment_date` DATE COMMENT 'Date when the service agreement was enrolled into this specific incentive program. Explicitly identified in detection phase relationship data.',
  `enrollment_status` STRING COMMENT 'Current lifecycle status of this enrollment indicating whether it is actively receiving incentive payments.',
  `last_compliance_check_date` DATE COMMENT 'Date of the most recent compliance verification for this enrollment.',
  `next_payment_due_date` DATE COMMENT 'Scheduled date for the next incentive payment for this enrollment. Null for one-time payments already disbursed.',
  `payment_schedule_type` STRING COMMENT 'Type of payment schedule for this enrollment: one_time, monthly, quarterly, annual, or per_kwh_generated. Explicitly identified in detection phase relationship data.',
  `total_paid_amount` DECIMAL(18,2) COMMENT 'Cumulative amount paid to date for this specific enrollment in USD. Tracks actual payments made under this program-agreement combination. Explicitly identified in detection phase relationship data.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this enrollment record was last modified.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_service_agreement_incentive_enrollment` PRIMARY KEY (`service_agreement_incentive_enrollment_id`)
)
USING DELTA
COMMENT 'This association product represents the enrollment relationship between a billing service agreement and a renewable incentive program. It captures the operational enrollment of a specific service agreement into a specific incentive program, tracking approval, payment, and compliance status. Each record links one billing service agreement to one incentive program with attributes that exist only in the context of this enrollment relationship.. Existence Justification: In energy utilities operations, a single billing service agreement can simultaneously participate in multiple renewable incentive programs (e.g., a residential solar customer enrolled in both a solar rebate program and a green tariff program and a low-income assistance program). Conversely, each incentive program serves many service agreements across the utility\'s customer base. The business actively manages these enrollments as operational entities, tracking approval amounts, payment schedules, compliance status, and payment history for each program-agreement combination. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ServiceAgreementIncentiveEnrollment',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.service_agreement_incentive_enrollment'
);

-- CreditMemo  <<CIM ErpReceivable : close>>
CREATE TABLE IF NOT EXISTS `billing`.`credit_memo` (
  `credit_memo_id` BIGINT NOT NULL COMMENT 'Primary key for credit_memo',
  `account_id` BIGINT COMMENT 'Account to which the credit memo is applied.',
  `original_invoice_id` BIGINT COMMENT 'Identifier of the invoice that the credit memo offsets.',
  `profile_id` BIGINT COMMENT 'Identifier of the customer receiving the credit.',
  `reversal_of_memo_id` BIGINT COMMENT 'If this memo reverses a prior credit memo, reference to that memo.',
  `original_credit_memo_id` BIGINT COMMENT 'Self-referencing FK on credit_memo (original_credit_memo_id)',
  `adjustment_type` STRING COMMENT 'Category of financial adjustment represented by the credit memo.',
  `amount_gross` DECIMAL(15,2) COMMENT 'Total credit amount before taxes, discounts, or adjustments.',
  `amount_net` DECIMAL(15,2) COMMENT 'Final credit amount after tax and discount adjustments.',
  `approval_status` STRING COMMENT 'Current approval state of the credit memo.',
  `approved_by` BIGINT COMMENT 'Identifier of the employee who approved the credit memo.',
  `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the credit memo was approved.',
  `batch_number` STRING COMMENT 'Identifier of the batch run that created or processed the credit memo.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the credit memo record was first created in the system.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 code of the currency for the credit memo.',
  `discount_amount` DECIMAL(15,2) COMMENT 'Any discount applied to the credit memo.',
  `due_date` DATE COMMENT 'Date by which the credit must be applied or settled.',
  `external_reference_code` STRING COMMENT 'Identifier linking the credit memo to an external system (e.g., SAP, Oracle).',
  `is_refund` BOOLEAN COMMENT 'True if the credit memo results in a cash refund to the customer.',
  `memo_date` TIMESTAMP COMMENT 'Date and time when the credit memo was issued to the customer.',
  `memo_number` STRING COMMENT 'External reference number assigned to the credit memo for customer and accounting purposes.',
  `notes` STRING COMMENT 'Additional free-form comments or remarks about the credit memo.',
  `original_invoice_number` STRING COMMENT 'External invoice number associated with the original charge.',
  `payment_channel` STRING COMMENT 'Channel through which the payment or refund was executed.',
  `payment_method` STRING COMMENT 'Method used to process any refund associated with the credit memo.',
  `processing_status` STRING COMMENT 'Internal status of the credit memo processing workflow.',
  `reason_code` STRING COMMENT 'Standard code indicating why the credit memo was issued (e.g., overpayment, service credit).',
  `reason_description` STRING COMMENT 'Free-text description of the reason for the credit.',
  `reversal_flag` BOOLEAN COMMENT 'True if the credit memo is a reversal of a previous transaction.',
  `settlement_date` DATE COMMENT 'Date the credit memo was settled against the account.',
  `status` STRING COMMENT 'Current processing state of the credit memo.',
  `tax_amount` DECIMAL(15,2) COMMENT 'Tax component of the credit memo.',
  `tax_code` STRING COMMENT 'Applicable tax code used for tax calculation on the credit.',
  `tax_exempt_flag` BOOLEAN COMMENT 'Indicates whether the credit memo is exempt from tax.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the credit memo record.',
  `write_off_flag` BOOLEAN COMMENT 'True if the credit memo amount was written off as uncollectible.',
  `created_by` BIGINT COMMENT 'Identifier of the employee who created the credit memo record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_credit_memo` PRIMARY KEY (`credit_memo_id`)
)
USING DELTA
COMMENT 'Master reference table for credit_memo. Referenced by credit_memo_id. | CMM: CIM ErpReceivable (close), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CreditMemo',
  'cmm.cim.class' = 'ErpReceivable',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.credit_memo'
);

-- BillingPeriod  <<CIM TimeSchedule : extension>>
CREATE TABLE IF NOT EXISTS `billing`.`billing_period` (
  `billing_period_id` BIGINT NOT NULL COMMENT 'Primary key for billing_period',
  `previous_billing_period_id` BIGINT COMMENT 'Self-referencing FK on billing_period (previous_billing_period_id)',
  `adjustment_flag` BOOLEAN COMMENT 'Indicates whether the period includes post-billing adjustments.',
  `billing_cycle_code` STRING COMMENT 'Code that identifies the recurring billing cycle associated with the period.',
  `budgeted_amount` DECIMAL(15,2) COMMENT 'Financial budget allocated for the period before actual usage is recorded.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the billing period record was first created in the system.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 code of the currency used for monetary values in the period.',
  `days_in_period` INT COMMENT 'Total count of calendar days covered by the billing period.',
  `description` STRING COMMENT 'Free-form text describing special characteristics of the period.',
  `effective_from` DATE COMMENT 'Date from which the billing period definition is effective for reporting.',
  `effective_until` DATE COMMENT 'Date until which the billing period definition remains effective; null for open-ended periods.',
  `fiscal_quarter` STRING COMMENT 'Quarter of the fiscal year for the billing period.',
  `fiscal_year` INT COMMENT 'Four-digit fiscal year to which the billing period belongs.',
  `is_pro_rata` BOOLEAN COMMENT 'Flag indicating whether the period is calculated on a pro-rata basis.',
  `period_end_date` DATE COMMENT 'Calendar date on which the billing period ends.',
  `period_name` STRING COMMENT 'Human-readable name for the billing period, e.g., "Jan 2024".',
  `period_start_date` DATE COMMENT 'Calendar date on which the billing period begins.',
  `period_type` STRING COMMENT 'Classification of the period purpose, such as regular billing, adjustment, forecast, or reversal.',
  `settlement_date` DATE COMMENT 'Date on which financial settlement for the period is performed.',
  `status` STRING COMMENT 'Current lifecycle status of the billing period.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the billing period record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_billing_period` PRIMARY KEY (`billing_period_id`)
)
USING DELTA
COMMENT 'Master reference table for billing_period. Referenced by billing_period_id. | CMM: CIM TimeSchedule (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'BillingPeriod',
  'cmm.cim.class' = 'TimeSchedule',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.billing_period'
);

-- DisconnectOrder  <<CIM MeterServiceWork : close>>
CREATE TABLE IF NOT EXISTS `billing`.`disconnect_order` (
  `disconnect_order_id` BIGINT NOT NULL COMMENT 'Primary key for disconnect_order',
  `account_id` BIGINT COMMENT 'Unique identifier of the customer associated with the disconnect order.',
  `employee_id` BIGINT COMMENT 'Identifier of the field technician assigned to execute the disconnect.',
  `meter_id` BIGINT COMMENT 'Unique identifier of the electric meter associated with the service point.',
  `service_point_id` BIGINT COMMENT 'Identifier of the physical location where service is delivered.',
  `superseded_disconnect_order_id` BIGINT COMMENT 'Self-referencing FK on disconnect_order (superseded_disconnect_order_id)',
  `actual_disconnect_date` DATE COMMENT 'Date on which the service was actually disconnected.',
  `adjustment_amount` DECIMAL(12,2) COMMENT 'Sum of all adjustments (taxes, fees, discounts) applied to the gross amount.',
  `approval_date` DATE COMMENT 'Date on which the disconnect order received formal approval.',
  `approved_by` STRING COMMENT 'Name or identifier of the employee who approved the disconnect order.',
  `cancellation_reason` STRING COMMENT 'Reason provided if the disconnect order was cancelled.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the disconnect order record was first persisted in the lakehouse.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 code of the currency used for the order.',
  `deposit_amount` DECIMAL(12,2) COMMENT 'Security deposit held for the account at the time of disconnect.',
  `disconnect_reason` STRING COMMENT 'Reason why the service disconnect is being requested or mandated.',
  `disconnect_type` STRING COMMENT 'Classification of the disconnect (e.g., voluntary customer request vs. involuntary for safety).',
  `dispute_flag` BOOLEAN COMMENT 'True if the disconnect order is under a customer dispute.',
  `estimated_duration_minutes` INT COMMENT 'Projected time in minutes required to complete the disconnect.',
  `gross_amount` DECIMAL(12,2) COMMENT 'Total amount before any adjustments, taxes, or discounts.',
  `net_amount` DECIMAL(12,2) COMMENT 'Final amount payable after adjustments.',
  `notes` STRING COMMENT 'Free-form text for additional comments or special instructions.',
  `order_number` STRING COMMENT 'External reference number assigned to the disconnect order for customer-facing communication.',
  `order_timestamp` TIMESTAMP COMMENT 'Date-time when the disconnect order was created or submitted by the customer.',
  `priority` STRING COMMENT 'Urgency level assigned to the disconnect order.',
  `regulatory_flag` BOOLEAN COMMENT 'Indicates whether the order is subject to special regulatory reporting (e.g., SOX, NERC).',
  `reversal_flag` BOOLEAN COMMENT 'Indicates whether the disconnect order was later reversed or reinstated.',
  `scheduled_disconnect_date` DATE COMMENT 'Planned calendar date for the disconnection to occur.',
  `status` STRING COMMENT 'Current processing state of the disconnect order.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the disconnect order record.',
  `write_off_flag` BOOLEAN COMMENT 'True if the outstanding balance was written off as uncollectible.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_disconnect_order` PRIMARY KEY (`disconnect_order_id`)
)
USING DELTA
COMMENT 'Master reference table for disconnect_order. Referenced by disconnect_order_id. | CMM: CIM MeterServiceWork (close), IEC61968::Metering.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DisconnectOrder',
  'cmm.cim.class' = 'MeterServiceWork',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Metering',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-9',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.disconnect_order'
);

-- DunningRun  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `billing`.`dunning_run` (
  `dunning_run_id` BIGINT NOT NULL COMMENT 'Primary key for dunning_run',
  `account_id` BIGINT COMMENT 'Identifier of the primary customer account targeted by the dunning run.',
  `employee_id` BIGINT COMMENT 'User responsible for initiating or overseeing the dunning run.',
  `last_run_id` BIGINT COMMENT 'Identifier of the previous dunning run that this run may be a retry of.',
  `schedule_id` BIGINT COMMENT 'Reference to the schedule definition that triggered the run.',
  `previous_dunning_run_id` BIGINT COMMENT 'Self-referencing FK on dunning_run (previous_dunning_run_id)',
  `accounting_period` STRING COMMENT 'Fiscal period (e.g., 2023Q4) for which the dunning run is accounted.',
  `adjustment_amount` DECIMAL(18,2) COMMENT 'Total of discounts, fees, or write-offs applied during the run.',
  `batch_number` STRING COMMENT 'External batch identifier used by the processing engine.',
  `contact_method` STRING COMMENT 'Preferred communication channel used for dunning (letter, email, phone, sms).',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the dunning run record was first created in the data lake.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 code of the currency for monetary values.',
  `deposit_flag` BOOLEAN COMMENT 'True if the run processes deposit-related dunning actions.',
  `description` STRING COMMENT 'Free-form text describing the purpose or notes for the run.',
  `due_date` DATE COMMENT 'Date by which the outstanding balances should be collected.',
  `dunning_level` INT COMMENT 'Highest escalation level applied in this run (e.g., 1-3).',
  `dunning_strategy_code` STRING COMMENT 'Code representing the collection strategy (e.g., standard, aggressive).',
  `end_timestamp` TIMESTAMP COMMENT 'Timestamp when the dunning run completed or was terminated.',
  `error_count` INT COMMENT 'Count of error records encountered during processing.',
  `failure_count` INT COMMENT 'Number of accounts that failed processing.',
  `financial_period` STRING COMMENT 'Financial reporting period aligned with the run\'s revenue recognition.',
  `gl_account` STRING COMMENT 'GL account code to which dunning write-offs are posted.',
  `gross_amount` DECIMAL(18,2) COMMENT 'Sum of original invoice amounts before any adjustments.',
  `net_amount` DECIMAL(18,2) COMMENT 'Final amount due after adjustments; used for accounting postings.',
  `notes` STRING COMMENT 'Additional operational comments captured during execution.',
  `payment_plan_flag` BOOLEAN COMMENT 'Indicates whether the run includes accounts on a payment arrangement.',
  `priority_code` STRING COMMENT 'Business priority assigned to the run for scheduling purposes.',
  `reconciliation_status` STRING COMMENT 'Status of financial reconciliation for the run\'s postings.',
  `region_code` STRING COMMENT 'Geographic region identifier (e.g., three-letter ISO region) associated with the run.',
  `retry_count` INT COMMENT 'Number of times the run has been re-executed after failure.',
  `run_comment` STRING COMMENT 'Additional free-form comment captured at run completion.',
  `run_number` STRING COMMENT 'Human-readable sequential number assigned to the dunning run.',
  `run_type` STRING COMMENT 'Indicates whether the run was generated automatically by the system or initiated manually.',
  `scheduled_timestamp` TIMESTAMP COMMENT 'Planned start time for the dunning run as defined by scheduling logic.',
  `start_timestamp` TIMESTAMP COMMENT 'Timestamp when the dunning run processing began.',
  `status` STRING COMMENT 'Current lifecycle status of the dunning run.',
  `success_count` INT COMMENT 'Number of accounts successfully processed without errors.',
  `tax_code` STRING COMMENT 'Tax classification applied to adjustments within the run.',
  `territory_code` STRING COMMENT 'Sub-regional sales or service territory linked to the accounts in the run.',
  `total_accounts` INT COMMENT 'Number of distinct accounts included in this dunning run.',
  `total_outstanding_amount` DECIMAL(18,2) COMMENT 'Aggregate amount overdue across all accounts in the run.',
  `updated_by` BIGINT COMMENT 'System user identifier who last modified the dunning run record.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the dunning run record.',
  `created_by` BIGINT COMMENT 'System user identifier who created the dunning run record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_dunning_run` PRIMARY KEY (`dunning_run_id`)
)
USING DELTA
COMMENT 'Master reference table for dunning_run. Referenced by dunning_run_id. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DunningRun',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.dunning_run'
);

-- DunningSchedule  <<CIM TimeSchedule : extension>>
CREATE TABLE IF NOT EXISTS `billing`.`dunning_schedule` (
  `dunning_schedule_id` BIGINT NOT NULL COMMENT 'Primary key for dunning_schedule',
  `superseded_dunning_schedule_id` BIGINT COMMENT 'Self-referencing FK on dunning_schedule (superseded_dunning_schedule_id)',
  `action_type` STRING COMMENT 'Method used to contact the customer for this dunning step.',
  `amount_threshold` DECIMAL(12,2) COMMENT 'Minimum outstanding amount that must be met before this dunning step applies.',
  `compliance_code` STRING COMMENT 'Regulatory or internal compliance code associated with this dunning schedule (e.g., SOX control reference).',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the dunning schedule record was first created in the system.',
  `days_before_action` INT COMMENT 'Number of days after the invoice due date before this dunning action is triggered.',
  `description` STRING COMMENT 'Free-form description of the schedule purpose and any special handling notes.',
  `dunning_level` INT COMMENT 'Ordinal level of the dunning step (e.g., 1 = first reminder, 2 = second reminder).',
  `effective_from` DATE COMMENT 'Date on which the dunning schedule becomes effective.',
  `effective_until` DATE COMMENT 'Date on which the dunning schedule expires; null for open-ended schedules.',
  `escalation_level` INT COMMENT 'Numeric indicator of how far the dunning process has escalated.',
  `grace_period_days` INT COMMENT 'Additional days granted after the action before further escalation.',
  `interest_rate` DECIMAL(5,2) COMMENT 'Interest rate applied to the overdue balance for this dunning step, expressed as a percentage.',
  `max_attempts` INT COMMENT 'Maximum number of times this dunning step may be repeated before moving to the next level.',
  `notes` STRING COMMENT 'Additional internal comments or audit notes related to the schedule.',
  `notification_method` STRING COMMENT 'Channel used to deliver the dunning notice.',
  `penalty_fee` DECIMAL(12,2) COMMENT 'Fixed penalty fee charged when this dunning step is executed.',
  `schedule_name` STRING COMMENT 'Human-readable name of the dunning schedule used for reporting and UI display.',
  `schedule_type` STRING COMMENT 'Classification of the schedule indicating whether it follows a standard, custom, or regulatory pattern.',
  `status` STRING COMMENT 'Current lifecycle status of the schedule.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the dunning schedule record.',
  `waive_interest_flag` BOOLEAN COMMENT 'Indicates whether interest is waived for this dunning step (true = waived).',
  `waive_penalty_flag` BOOLEAN COMMENT 'Indicates whether the penalty fee is waived for this dunning step (true = waived).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_billing_dunning_schedule` PRIMARY KEY (`dunning_schedule_id`)
)
USING DELTA
COMMENT 'Master reference table for dunning_schedule. Referenced by schedule_id. | CMM: CIM TimeSchedule (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DunningSchedule',
  'cmm.cim.class' = 'TimeSchedule',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.billing.dunning_schedule'
);

-- ========= FOREIGN KEYS within billing (72) =========
ALTER TABLE `billing`.`rate_component` DROP CONSTRAINT IF EXISTS `fk_billing_rate_component_primary_rate_schedule_id`;
ALTER TABLE `billing`.`rate_component` ADD CONSTRAINT `fk_billing_rate_component_primary_rate_schedule_id` FOREIGN KEY (`primary_rate_schedule_id`) REFERENCES `billing`.`rate_schedule` (`rate_schedule_id`);

ALTER TABLE `billing`.`billing_service_agreement` DROP CONSTRAINT IF EXISTS `fk_billing_billing_service_agreement_billing_rate_schedule_id`;
ALTER TABLE `billing`.`billing_service_agreement` ADD CONSTRAINT `fk_billing_billing_service_agreement_billing_rate_schedule_id` FOREIGN KEY (`billing_rate_schedule_id`) REFERENCES `billing`.`rate_schedule` (`rate_schedule_id`);

ALTER TABLE `billing`.`invoice` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_billing_run_id`;
ALTER TABLE `billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_billing_run_id` FOREIGN KEY (`billing_run_id`) REFERENCES `billing`.`billing_run` (`billing_run_id`);

ALTER TABLE `billing`.`invoice` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_billing_service_agreement_id`;
ALTER TABLE `billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_billing_service_agreement_id` FOREIGN KEY (`billing_service_agreement_id`) REFERENCES `billing`.`billing_service_agreement` (`billing_service_agreement_id`);

ALTER TABLE `billing`.`invoice` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_cycle_id`;
ALTER TABLE `billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_cycle_id` FOREIGN KEY (`cycle_id`) REFERENCES `billing`.`cycle` (`cycle_id`);

ALTER TABLE `billing`.`invoice` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_invoice_for_service_agreement`;
ALTER TABLE `billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_invoice_for_service_agreement` FOREIGN KEY (`invoice_for_service_agreement`) REFERENCES `billing`.`billing_service_agreement` (`billing_service_agreement_id`);

ALTER TABLE `billing`.`invoice_line` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_line_from_rate_component_id`;
ALTER TABLE `billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_from_rate_component_id` FOREIGN KEY (`from_rate_component_id`) REFERENCES `billing`.`rate_component` (`rate_component_id`);

ALTER TABLE `billing`.`invoice_line` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_line_invoice_rate_component_id`;
ALTER TABLE `billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_invoice_rate_component_id` FOREIGN KEY (`invoice_rate_component_id`) REFERENCES `billing`.`rate_component` (`rate_component_id`);

ALTER TABLE `billing`.`invoice_line` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_line_original_line_invoice_line_id`;
ALTER TABLE `billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_original_line_invoice_line_id` FOREIGN KEY (`original_line_invoice_line_id`) REFERENCES `billing`.`invoice_line` (`invoice_line_id`);

ALTER TABLE `billing`.`invoice_line` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_line_primary_invoice_id`;
ALTER TABLE `billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_primary_invoice_id` FOREIGN KEY (`primary_invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

ALTER TABLE `billing`.`payment` DROP CONSTRAINT IF EXISTS `fk_billing_payment_invoice_id`;
ALTER TABLE `billing`.`payment` ADD CONSTRAINT `fk_billing_payment_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

ALTER TABLE `billing`.`payment` DROP CONSTRAINT IF EXISTS `fk_billing_payment_payment_arrangement_id`;
ALTER TABLE `billing`.`payment` ADD CONSTRAINT `fk_billing_payment_payment_arrangement_id` FOREIGN KEY (`payment_arrangement_id`) REFERENCES `billing`.`payment_arrangement` (`payment_arrangement_id`);

ALTER TABLE `billing`.`payment` DROP CONSTRAINT IF EXISTS `fk_billing_payment_payment_invoice_id`;
ALTER TABLE `billing`.`payment` ADD CONSTRAINT `fk_billing_payment_payment_invoice_id` FOREIGN KEY (`payment_invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

ALTER TABLE `billing`.`payment` DROP CONSTRAINT IF EXISTS `fk_billing_payment_to_invoice_id`;
ALTER TABLE `billing`.`payment` ADD CONSTRAINT `fk_billing_payment_to_invoice_id` FOREIGN KEY (`to_invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

ALTER TABLE `billing`.`determinant` DROP CONSTRAINT IF EXISTS `fk_billing_determinant_billing_period_id`;
ALTER TABLE `billing`.`determinant` ADD CONSTRAINT `fk_billing_determinant_billing_period_id` FOREIGN KEY (`billing_period_id`) REFERENCES `billing`.`billing_period` (`billing_period_id`);

ALTER TABLE `billing`.`determinant` DROP CONSTRAINT IF EXISTS `fk_billing_determinant_billing_service_agreement_id`;
ALTER TABLE `billing`.`determinant` ADD CONSTRAINT `fk_billing_determinant_billing_service_agreement_id` FOREIGN KEY (`billing_service_agreement_id`) REFERENCES `billing`.`billing_service_agreement` (`billing_service_agreement_id`);

ALTER TABLE `billing`.`determinant` DROP CONSTRAINT IF EXISTS `fk_billing_determinant_cycle_id`;
ALTER TABLE `billing`.`determinant` ADD CONSTRAINT `fk_billing_determinant_cycle_id` FOREIGN KEY (`cycle_id`) REFERENCES `billing`.`cycle` (`cycle_id`);

ALTER TABLE `billing`.`determinant` DROP CONSTRAINT IF EXISTS `fk_billing_determinant_invoice_id`;
ALTER TABLE `billing`.`determinant` ADD CONSTRAINT `fk_billing_determinant_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

ALTER TABLE `billing`.`determinant` DROP CONSTRAINT IF EXISTS `fk_billing_determinant_rate_schedule_id`;
ALTER TABLE `billing`.`determinant` ADD CONSTRAINT `fk_billing_determinant_rate_schedule_id` FOREIGN KEY (`rate_schedule_id`) REFERENCES `billing`.`rate_schedule` (`rate_schedule_id`);

ALTER TABLE `billing`.`adjustment` DROP CONSTRAINT IF EXISTS `fk_billing_adjustment_adjustment_invoice_id`;
ALTER TABLE `billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_adjustment_invoice_id` FOREIGN KEY (`adjustment_invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

ALTER TABLE `billing`.`adjustment` DROP CONSTRAINT IF EXISTS `fk_billing_adjustment_bill_dispute_id`;
ALTER TABLE `billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_bill_dispute_id` FOREIGN KEY (`bill_dispute_id`) REFERENCES `billing`.`bill_dispute` (`bill_dispute_id`);

ALTER TABLE `billing`.`adjustment` DROP CONSTRAINT IF EXISTS `fk_billing_adjustment_invoice_id`;
ALTER TABLE `billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

ALTER TABLE `billing`.`adjustment` DROP CONSTRAINT IF EXISTS `fk_billing_adjustment_reversed_adjustment_id`;
ALTER TABLE `billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_reversed_adjustment_id` FOREIGN KEY (`reversed_adjustment_id`) REFERENCES `billing`.`adjustment` (`adjustment_id`);

ALTER TABLE `billing`.`adjustment` DROP CONSTRAINT IF EXISTS `fk_billing_adjustment_to_invoice_id`;
ALTER TABLE `billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_to_invoice_id` FOREIGN KEY (`to_invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

ALTER TABLE `billing`.`deposit` DROP CONSTRAINT IF EXISTS `fk_billing_deposit_billing_service_agreement_id`;
ALTER TABLE `billing`.`deposit` ADD CONSTRAINT `fk_billing_deposit_billing_service_agreement_id` FOREIGN KEY (`billing_service_agreement_id`) REFERENCES `billing`.`billing_service_agreement` (`billing_service_agreement_id`);

ALTER TABLE `billing`.`dunning_notice` DROP CONSTRAINT IF EXISTS `fk_billing_dunning_notice_bill_dispute_id`;
ALTER TABLE `billing`.`dunning_notice` ADD CONSTRAINT `fk_billing_dunning_notice_bill_dispute_id` FOREIGN KEY (`bill_dispute_id`) REFERENCES `billing`.`bill_dispute` (`bill_dispute_id`);

ALTER TABLE `billing`.`dunning_notice` DROP CONSTRAINT IF EXISTS `fk_billing_dunning_notice_billing_service_agreement_id`;
ALTER TABLE `billing`.`dunning_notice` ADD CONSTRAINT `fk_billing_dunning_notice_billing_service_agreement_id` FOREIGN KEY (`billing_service_agreement_id`) REFERENCES `billing`.`billing_service_agreement` (`billing_service_agreement_id`);

ALTER TABLE `billing`.`dunning_notice` DROP CONSTRAINT IF EXISTS `fk_billing_dunning_notice_disconnect_order_id`;
ALTER TABLE `billing`.`dunning_notice` ADD CONSTRAINT `fk_billing_dunning_notice_disconnect_order_id` FOREIGN KEY (`disconnect_order_id`) REFERENCES `billing`.`disconnect_order` (`disconnect_order_id`);

ALTER TABLE `billing`.`dunning_notice` DROP CONSTRAINT IF EXISTS `fk_billing_dunning_notice_dunning_run_id`;
ALTER TABLE `billing`.`dunning_notice` ADD CONSTRAINT `fk_billing_dunning_notice_dunning_run_id` FOREIGN KEY (`dunning_run_id`) REFERENCES `billing`.`dunning_run` (`dunning_run_id`);

ALTER TABLE `billing`.`dunning_notice` DROP CONSTRAINT IF EXISTS `fk_billing_dunning_notice_payment_arrangement_id`;
ALTER TABLE `billing`.`dunning_notice` ADD CONSTRAINT `fk_billing_dunning_notice_payment_arrangement_id` FOREIGN KEY (`payment_arrangement_id`) REFERENCES `billing`.`payment_arrangement` (`payment_arrangement_id`);

ALTER TABLE `billing`.`collections` DROP CONSTRAINT IF EXISTS `fk_billing_collections_payment_arrangement_id`;
ALTER TABLE `billing`.`collections` ADD CONSTRAINT `fk_billing_collections_payment_arrangement_id` FOREIGN KEY (`payment_arrangement_id`) REFERENCES `billing`.`payment_arrangement` (`payment_arrangement_id`);

ALTER TABLE `billing`.`write_off` DROP CONSTRAINT IF EXISTS `fk_billing_write_off_collections_id`;
ALTER TABLE `billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_collections_id` FOREIGN KEY (`collections_id`) REFERENCES `billing`.`collections` (`collections_id`);

ALTER TABLE `billing`.`budget_plan` DROP CONSTRAINT IF EXISTS `fk_billing_budget_plan_billing_service_agreement_id`;
ALTER TABLE `billing`.`budget_plan` ADD CONSTRAINT `fk_billing_budget_plan_billing_service_agreement_id` FOREIGN KEY (`billing_service_agreement_id`) REFERENCES `billing`.`billing_service_agreement` (`billing_service_agreement_id`);

ALTER TABLE `billing`.`budget_plan` DROP CONSTRAINT IF EXISTS `fk_billing_budget_plan_payment_arrangement_id`;
ALTER TABLE `billing`.`budget_plan` ADD CONSTRAINT `fk_billing_budget_plan_payment_arrangement_id` FOREIGN KEY (`payment_arrangement_id`) REFERENCES `billing`.`payment_arrangement` (`payment_arrangement_id`);

ALTER TABLE `billing`.`cycle` DROP CONSTRAINT IF EXISTS `fk_billing_cycle_billing_run_id`;
ALTER TABLE `billing`.`cycle` ADD CONSTRAINT `fk_billing_cycle_billing_run_id` FOREIGN KEY (`billing_run_id`) REFERENCES `billing`.`billing_run` (`billing_run_id`);

ALTER TABLE `billing`.`billing_run` DROP CONSTRAINT IF EXISTS `fk_billing_billing_run_reversed_run_billing_run_id`;
ALTER TABLE `billing`.`billing_run` ADD CONSTRAINT `fk_billing_billing_run_reversed_run_billing_run_id` FOREIGN KEY (`reversed_run_billing_run_id`) REFERENCES `billing`.`billing_run` (`billing_run_id`);

ALTER TABLE `billing`.`revenue_recognition` DROP CONSTRAINT IF EXISTS `fk_billing_revenue_recognition_billing_service_agreement_id`;
ALTER TABLE `billing`.`revenue_recognition` ADD CONSTRAINT `fk_billing_revenue_recognition_billing_service_agreement_id` FOREIGN KEY (`billing_service_agreement_id`) REFERENCES `billing`.`billing_service_agreement` (`billing_service_agreement_id`);

ALTER TABLE `billing`.`revenue_recognition` DROP CONSTRAINT IF EXISTS `fk_billing_revenue_recognition_invoice_id`;
ALTER TABLE `billing`.`revenue_recognition` ADD CONSTRAINT `fk_billing_revenue_recognition_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

ALTER TABLE `billing`.`revenue_recognition` DROP CONSTRAINT IF EXISTS `fk_billing_revenue_recognition_original_entry_revenue_recognition_id`;
ALTER TABLE `billing`.`revenue_recognition` ADD CONSTRAINT `fk_billing_revenue_recognition_original_entry_revenue_recognition_id` FOREIGN KEY (`original_entry_revenue_recognition_id`) REFERENCES `billing`.`revenue_recognition` (`revenue_recognition_id`);

ALTER TABLE `billing`.`revenue_recognition` DROP CONSTRAINT IF EXISTS `fk_billing_revenue_recognition_rate_schedule_id`;
ALTER TABLE `billing`.`revenue_recognition` ADD CONSTRAINT `fk_billing_revenue_recognition_rate_schedule_id` FOREIGN KEY (`rate_schedule_id`) REFERENCES `billing`.`rate_schedule` (`rate_schedule_id`);

ALTER TABLE `billing`.`revenue_recognition` DROP CONSTRAINT IF EXISTS `fk_billing_revenue_recognition_revenue_invoice_id`;
ALTER TABLE `billing`.`revenue_recognition` ADD CONSTRAINT `fk_billing_revenue_recognition_revenue_invoice_id` FOREIGN KEY (`revenue_invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

ALTER TABLE `billing`.`bill_dispute` DROP CONSTRAINT IF EXISTS `fk_billing_bill_dispute_bill_invoice_id`;
ALTER TABLE `billing`.`bill_dispute` ADD CONSTRAINT `fk_billing_bill_dispute_bill_invoice_id` FOREIGN KEY (`bill_invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

ALTER TABLE `billing`.`bill_dispute` DROP CONSTRAINT IF EXISTS `fk_billing_bill_dispute_credit_memo_id`;
ALTER TABLE `billing`.`bill_dispute` ADD CONSTRAINT `fk_billing_bill_dispute_credit_memo_id` FOREIGN KEY (`credit_memo_id`) REFERENCES `billing`.`credit_memo` (`credit_memo_id`);

ALTER TABLE `billing`.`bill_dispute` DROP CONSTRAINT IF EXISTS `fk_billing_bill_dispute_invoice_id`;
ALTER TABLE `billing`.`bill_dispute` ADD CONSTRAINT `fk_billing_bill_dispute_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

ALTER TABLE `billing`.`nem_credit` DROP CONSTRAINT IF EXISTS `fk_billing_nem_credit_billing_service_agreement_id`;
ALTER TABLE `billing`.`nem_credit` ADD CONSTRAINT `fk_billing_nem_credit_billing_service_agreement_id` FOREIGN KEY (`billing_service_agreement_id`) REFERENCES `billing`.`billing_service_agreement` (`billing_service_agreement_id`);

ALTER TABLE `billing`.`nem_credit` DROP CONSTRAINT IF EXISTS `fk_billing_nem_credit_invoice_id`;
ALTER TABLE `billing`.`nem_credit` ADD CONSTRAINT `fk_billing_nem_credit_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

ALTER TABLE `billing`.`nem_credit` DROP CONSTRAINT IF EXISTS `fk_billing_nem_credit_nem_for_agreement`;
ALTER TABLE `billing`.`nem_credit` ADD CONSTRAINT `fk_billing_nem_credit_nem_for_agreement` FOREIGN KEY (`nem_for_agreement`) REFERENCES `billing`.`billing_service_agreement` (`billing_service_agreement_id`);

ALTER TABLE `billing`.`nem_credit` DROP CONSTRAINT IF EXISTS `fk_billing_nem_credit_original_credit_nem_credit_id`;
ALTER TABLE `billing`.`nem_credit` ADD CONSTRAINT `fk_billing_nem_credit_original_credit_nem_credit_id` FOREIGN KEY (`original_credit_nem_credit_id`) REFERENCES `billing`.`nem_credit` (`nem_credit_id`);

ALTER TABLE `billing`.`nem_credit` DROP CONSTRAINT IF EXISTS `fk_billing_nem_credit_rate_schedule_id`;
ALTER TABLE `billing`.`nem_credit` ADD CONSTRAINT `fk_billing_nem_credit_rate_schedule_id` FOREIGN KEY (`rate_schedule_id`) REFERENCES `billing`.`rate_schedule` (`rate_schedule_id`);

ALTER TABLE `billing`.`assistance_program` DROP CONSTRAINT IF EXISTS `fk_billing_assistance_program_billing_service_agreement_id`;
ALTER TABLE `billing`.`assistance_program` ADD CONSTRAINT `fk_billing_assistance_program_billing_service_agreement_id` FOREIGN KEY (`billing_service_agreement_id`) REFERENCES `billing`.`billing_service_agreement` (`billing_service_agreement_id`);

ALTER TABLE `billing`.`billing_program_enrollment` DROP CONSTRAINT IF EXISTS `fk_billing_billing_program_enrollment_payment_arrangement_id`;
ALTER TABLE `billing`.`billing_program_enrollment` ADD CONSTRAINT `fk_billing_billing_program_enrollment_payment_arrangement_id` FOREIGN KEY (`payment_arrangement_id`) REFERENCES `billing`.`payment_arrangement` (`payment_arrangement_id`);

ALTER TABLE `billing`.`ar_ledger` DROP CONSTRAINT IF EXISTS `fk_billing_ar_ledger_ar_invoice_id`;
ALTER TABLE `billing`.`ar_ledger` ADD CONSTRAINT `fk_billing_ar_ledger_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

ALTER TABLE `billing`.`ar_ledger` DROP CONSTRAINT IF EXISTS `fk_billing_ar_ledger_collections_id`;
ALTER TABLE `billing`.`ar_ledger` ADD CONSTRAINT `fk_billing_ar_ledger_collections_id` FOREIGN KEY (`collections_id`) REFERENCES `billing`.`collections` (`collections_id`);

ALTER TABLE `billing`.`ar_ledger` DROP CONSTRAINT IF EXISTS `fk_billing_ar_ledger_invoice_id`;
ALTER TABLE `billing`.`ar_ledger` ADD CONSTRAINT `fk_billing_ar_ledger_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

ALTER TABLE `billing`.`ar_ledger` DROP CONSTRAINT IF EXISTS `fk_billing_ar_ledger_payment_arrangement_id`;
ALTER TABLE `billing`.`ar_ledger` ADD CONSTRAINT `fk_billing_ar_ledger_payment_arrangement_id` FOREIGN KEY (`payment_arrangement_id`) REFERENCES `billing`.`payment_arrangement` (`payment_arrangement_id`);

ALTER TABLE `billing`.`ar_ledger` DROP CONSTRAINT IF EXISTS `fk_billing_ar_ledger_primary_invoice_id`;
ALTER TABLE `billing`.`ar_ledger` ADD CONSTRAINT `fk_billing_ar_ledger_primary_invoice_id` FOREIGN KEY (`primary_invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

ALTER TABLE `billing`.`refund` DROP CONSTRAINT IF EXISTS `fk_billing_refund_bill_dispute_id`;
ALTER TABLE `billing`.`refund` ADD CONSTRAINT `fk_billing_refund_bill_dispute_id` FOREIGN KEY (`bill_dispute_id`) REFERENCES `billing`.`bill_dispute` (`bill_dispute_id`);

ALTER TABLE `billing`.`refund` DROP CONSTRAINT IF EXISTS `fk_billing_refund_credit_memo_id`;
ALTER TABLE `billing`.`refund` ADD CONSTRAINT `fk_billing_refund_credit_memo_id` FOREIGN KEY (`credit_memo_id`) REFERENCES `billing`.`credit_memo` (`credit_memo_id`);

ALTER TABLE `billing`.`refund` DROP CONSTRAINT IF EXISTS `fk_billing_refund_deposit_id`;
ALTER TABLE `billing`.`refund` ADD CONSTRAINT `fk_billing_refund_deposit_id` FOREIGN KEY (`deposit_id`) REFERENCES `billing`.`deposit` (`deposit_id`);

ALTER TABLE `billing`.`refund` DROP CONSTRAINT IF EXISTS `fk_billing_refund_invoice_id`;
ALTER TABLE `billing`.`refund` ADD CONSTRAINT `fk_billing_refund_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

ALTER TABLE `billing`.`refund` DROP CONSTRAINT IF EXISTS `fk_billing_refund_payment_id`;
ALTER TABLE `billing`.`refund` ADD CONSTRAINT `fk_billing_refund_payment_id` FOREIGN KEY (`payment_id`) REFERENCES `billing`.`payment` (`payment_id`);

ALTER TABLE `billing`.`service_agreement_incentive_enrollment` DROP CONSTRAINT IF EXISTS `fk_billing_service_agreement_incentive_enrollment_billing_service_agreement_id`;
ALTER TABLE `billing`.`service_agreement_incentive_enrollment` ADD CONSTRAINT `fk_billing_service_agreement_incentive_enrollment_billing_service_agreement_id` FOREIGN KEY (`billing_service_agreement_id`) REFERENCES `billing`.`billing_service_agreement` (`billing_service_agreement_id`);

ALTER TABLE `billing`.`service_agreement_incentive_enrollment` DROP CONSTRAINT IF EXISTS `fk_billing_service_agreement_incentive_enrollment_service_agreement_billing_service_agreement_id`;
ALTER TABLE `billing`.`service_agreement_incentive_enrollment` ADD CONSTRAINT `fk_billing_service_agreement_incentive_enrollment_service_agreement_billing_service_agreement_id` FOREIGN KEY (`service_agreement_billing_service_agreement_id`) REFERENCES `billing`.`billing_service_agreement` (`billing_service_agreement_id`);

ALTER TABLE `billing`.`credit_memo` DROP CONSTRAINT IF EXISTS `fk_billing_credit_memo_original_invoice_id`;
ALTER TABLE `billing`.`credit_memo` ADD CONSTRAINT `fk_billing_credit_memo_original_invoice_id` FOREIGN KEY (`original_invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

ALTER TABLE `billing`.`credit_memo` DROP CONSTRAINT IF EXISTS `fk_billing_credit_memo_reversal_of_memo_id`;
ALTER TABLE `billing`.`credit_memo` ADD CONSTRAINT `fk_billing_credit_memo_reversal_of_memo_id` FOREIGN KEY (`reversal_of_memo_id`) REFERENCES `billing`.`credit_memo` (`credit_memo_id`);

ALTER TABLE `billing`.`credit_memo` DROP CONSTRAINT IF EXISTS `fk_billing_credit_memo_original_credit_memo_id`;
ALTER TABLE `billing`.`credit_memo` ADD CONSTRAINT `fk_billing_credit_memo_original_credit_memo_id` FOREIGN KEY (`original_credit_memo_id`) REFERENCES `billing`.`credit_memo` (`credit_memo_id`);

ALTER TABLE `billing`.`billing_period` DROP CONSTRAINT IF EXISTS `fk_billing_billing_period_previous_billing_period_id`;
ALTER TABLE `billing`.`billing_period` ADD CONSTRAINT `fk_billing_billing_period_previous_billing_period_id` FOREIGN KEY (`previous_billing_period_id`) REFERENCES `billing`.`billing_period` (`billing_period_id`);

ALTER TABLE `billing`.`disconnect_order` DROP CONSTRAINT IF EXISTS `fk_billing_disconnect_order_superseded_disconnect_order_id`;
ALTER TABLE `billing`.`disconnect_order` ADD CONSTRAINT `fk_billing_disconnect_order_superseded_disconnect_order_id` FOREIGN KEY (`superseded_disconnect_order_id`) REFERENCES `billing`.`disconnect_order` (`disconnect_order_id`);

ALTER TABLE `billing`.`dunning_run` DROP CONSTRAINT IF EXISTS `fk_billing_dunning_run_last_run_id`;
ALTER TABLE `billing`.`dunning_run` ADD CONSTRAINT `fk_billing_dunning_run_last_run_id` FOREIGN KEY (`last_run_id`) REFERENCES `billing`.`dunning_run` (`dunning_run_id`);

ALTER TABLE `billing`.`dunning_run` DROP CONSTRAINT IF EXISTS `fk_billing_dunning_run_schedule_id`;
ALTER TABLE `billing`.`dunning_run` ADD CONSTRAINT `fk_billing_dunning_run_schedule_id` FOREIGN KEY (`schedule_id`) REFERENCES `billing`.`dunning_schedule` (`dunning_schedule_id`);

ALTER TABLE `billing`.`dunning_run` DROP CONSTRAINT IF EXISTS `fk_billing_dunning_run_previous_dunning_run_id`;
ALTER TABLE `billing`.`dunning_run` ADD CONSTRAINT `fk_billing_dunning_run_previous_dunning_run_id` FOREIGN KEY (`previous_dunning_run_id`) REFERENCES `billing`.`dunning_run` (`dunning_run_id`);

ALTER TABLE `billing`.`dunning_schedule` DROP CONSTRAINT IF EXISTS `fk_billing_dunning_schedule_superseded_dunning_schedule_id`;
ALTER TABLE `billing`.`dunning_schedule` ADD CONSTRAINT `fk_billing_dunning_schedule_superseded_dunning_schedule_id` FOREIGN KEY (`superseded_dunning_schedule_id`) REFERENCES `billing`.`dunning_schedule` (`dunning_schedule_id`);

