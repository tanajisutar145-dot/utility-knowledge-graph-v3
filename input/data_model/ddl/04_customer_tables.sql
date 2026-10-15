-- Utility CMM-aligned Canonical Data Model (Silver) v1.0.0 | source: Databricks lakehouse-industry-data-models energy_utilities v1 ECM | generated 2026-10-13
-- 04 | Subject area: customer | 23 tables | CIM packages: IEC61968::Customers; IEC61968::Common
-- Standards: IEC 61968-8; NAESB REQ.21 ESPI (Green Button); MultiSpeak CB
-- Contents: tables (with PK + NOT NULL), then intra-subject-area foreign keys.
-- Unity Catalog PK/FK constraints are informational (NOT ENFORCED); NOT NULL is enforced.

USE CATALOG `utility_cmm_silver`;

-- CustomerAccount  <<CIM CustomerAccount : exact>>
CREATE TABLE IF NOT EXISTS `customer`.`account` (
  `account_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for the utility customer account record in the Silver Layer lakehouse. Primary key for all downstream joins across billing, metering, and demand response domains.',
  `account_profile_id` BIGINT COMMENT 'Reference to the master customer (business partner / person) record that owns this account. Links the account to the customer identity, contact, and demographic data in the Customer domain SSOT.',
  `billing_address_id` BIGINT COMMENT 'Foreign key linking to customer.address. Business justification: Account should reference address for billing address normalization. However, examining the account attributes, I do NOT see embedded address fields (no address_line_1, city, state, etc. visible in the',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Customer accounts are assigned to control areas for energy settlement, interchange accounting, regulatory reporting, and balancing authority cost allocation. Required for billing and compliance operat',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Utility accounts are assigned to cost centers for internal cost allocation, segment profitability analysis, and management accounting. Essential for customer segment P&L reporting and regulatory cost-',
  `parent_account_id` BIGINT COMMENT 'Reference to the parent account_id for consolidated billing hierarchies and corporate account structures. Null for top-level or standalone accounts. Enables traversal of multi-level corporate hierarchies for enterprise billing and reporting.',
  `premise_id` BIGINT COMMENT 'Reference to the primary service premise (physical location) associated with this account. A premise represents the physical address where electricity is delivered. Accounts may span multiple premises in consolidated billing scenarios.',
  `primary_service_asset_registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: Accounts track primary service delivery asset (transformer, service vault) for billing context, capacity planning, and outage impact analysis. Critical for customer-asset operational linkage in utilit',
  `to_profile_id` BIGINT COMMENT 'FK to customer.profile.profile_id — Every account must reference the customer profile (person or organization) that owns it. This is the most fundamental FK in any CIS — account.profile_id → profile.profile_id. Without this, you cannot',
  `account_group` STRING COMMENT 'Grouping classification that determines billing consolidation and hierarchy rules. Consolidated billing groups multiple premises under one bill; corporate parent denotes the apex of a corporate hierarchy; municipal aggregation and Community Choice Aggregation (CCA) denote aggregated load programs; franchise denotes accounts under a specific franchise territory agreement. Valid values: standard|consolidated_billing|corporate_parent|municipal_aggregation|cca|franchise.',
  `account_number` STRING COMMENT 'Externally-known utility account number as assigned by the Customer Information System (CIS). This is the number printed on customer bills and used in all customer-facing communications. Sourced from SAP IS-U FKKVK or Oracle CC&B ACCOUNT table. Pattern: ^[A-Z0-9]{8,20}$.',
  `account_status` STRING COMMENT 'Current lifecycle state of the utility account. Governs service eligibility, billing generation, and collections processing. Transitions include: pending_activation (new account awaiting energization), active (energized and billed), suspended (temporarily halted per tariff or non-payment), disconnected (service terminated), written_off (uncollectable balance), reactivated (restored after disconnection). Valid values: active|suspended|disconnected|pending_activation|written_off|reactivated.',
  `account_type` STRING COMMENT 'Classification of the utility account by customer segment. Drives rate eligibility, billing rules, and regulatory reporting. Residential covers single-family and multi-family dwellings; commercial covers businesses; industrial covers large-load manufacturing and processing facilities. Reference-value candidates: residential|commercial|industrial|municipal|agricultural|street_lighting|transportation|government. Valid values: residential|commercial|industrial|municipal|agricultural|street_lighting.',
  `activation_timestamp` TIMESTAMP COMMENT 'Date and time when the account was first activated and service was energized. Represents the precise business event time of account creation and service commencement. Used for SLA tracking of new service connections.',
  `ami_enrolled` BOOLEAN COMMENT 'Indicates whether this account has an Advanced Metering Infrastructure (AMI) smart meter installed, enabling automated interval reads, remote connect/disconnect, and real-time usage data. Drives eligibility for TOU rates, demand response programs, and enhanced billing analytics.',
  `autopay_enrolled` BOOLEAN COMMENT 'Indicates whether this account is enrolled in automatic payment (AutoPay), where the bill amount is automatically debited from the customer\'s bank account or charged to a payment card on the due date. Reduces collections risk and improves cash flow.',
  `billing_cycle_code` STRING COMMENT 'Code identifying the billing cycle (meter reading and bill generation schedule) assigned to this account. Determines the monthly read date and bill due date. Managed in SAP IS-U Billing Order or Oracle CC&B Bill Cycle. Examples: BC01 (1st of month), BC15 (15th of month). Pattern: ^[A-Z0-9]{1,6}$.',
  `btm_flag` BOOLEAN COMMENT 'Indicates whether this account has Behind-the-Meter (BTM) generation or storage assets installed at the premise. BTM assets include solar PV, battery storage, and combined heat and power (CHP) systems that are not directly visible to the grid operator. Drives load disaggregation and DER management workflows.',
  `budget_billing_enrolled` BOOLEAN COMMENT 'Indicates whether this account is enrolled in a budget billing (levelized payment plan) program, where monthly bills are averaged over a 12-month period to smooth seasonal fluctuations. Affects bill calculation and settlement processes in SAP IS-U or Oracle CC&B.',
  `cis_account_key` STRING COMMENT 'The native primary key or account identifier as stored in the source CIS (SAP IS-U contract account number VKONT, or Oracle CC&B account ID). Enables traceability back to the operational system of record for reconciliation, audit, and issue resolution. Pattern: ^[A-Z0-9_-]{1,50}$.',
  `cis_source_system` STRING COMMENT 'Identifies the operational Customer Information System (CIS) from which this account record originates. Critical for data lineage, deduplication, and cross-system reconciliation in multi-CIS utility environments. Values: SAP_IS_U (SAP Industry Solution for Utilities), ORACLE_CCB (Oracle Customer Care and Billing), LEGACY_CIS (decommissioned legacy system). Valid values: SAP_IS_U|ORACLE_CCB|LEGACY_CIS.',
  `contract_end_date` DATE COMMENT 'Date on which the service agreement or contract associated with this account is scheduled to expire or terminate. Null for open-ended tariff service. For fixed-term commercial or industrial contracts and PPAs, this date triggers renewal or renegotiation workflows.',
  `contract_start_date` DATE COMMENT 'Date on which the service agreement or contract associated with this account became effective. For residential accounts this typically aligns with move_in_date; for commercial and industrial accounts this may reflect a separately negotiated contract effective date, Power Purchase Agreement (PPA), or special contract term.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this account record was first created in the source CIS system. Represents the audit creation time for data lineage and SOX compliance. Distinct from activation_timestamp which represents the business event of service energization.',
  `credit_class` STRING COMMENT 'Credit risk classification assigned to the account based on payment history, credit bureau data, and internal scoring. Governs deposit requirements, payment plan eligibility, and collections treatment. Managed within SAP IS-U FICA or Oracle CC&B Collections module. Valid values: excellent|good|fair|poor|no_history|collections.',
  `deposit_amount` DECIMAL(15,2) COMMENT 'Dollar amount of security deposit held by the utility for this account, as required by credit class or PUC tariff rules. Refundable upon account closure in good standing. Tracked in SAP IS-U FI-CA or Oracle CC&B.',
  `ev_charging_enrolled` BOOLEAN COMMENT 'Indicates whether this account is enrolled in a special Electric Vehicle (EV) charging rate or managed charging program. Drives eligibility for off-peak EV charging incentives and supports grid load forecasting for EV adoption planning.',
  `last_bill_date` DATE COMMENT 'Date of the most recent bill generated for this account. Used to identify unbilled accounts, support billing cycle management, and calculate days since last bill for collections and customer service workflows.',
  `last_payment_date` DATE COMMENT 'Date of the most recent payment posted to this account. Used in collections scoring, credit class review, and customer service inquiries. Sourced from SAP IS-U FI-CA payment history or Oracle CC&B payment records.',
  `last_status_change_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent change to account_status. Enables tracking of the current status duration and supports collections and reconnection SLA monitoring. Complements the account status history table for current-state queries.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this account record in the source CIS or Silver Layer. Supports incremental data loading, change data capture (CDC), and audit trail requirements for SOX and regulatory compliance.',
  `life_support_equipment` BOOLEAN COMMENT 'Indicates whether a customer at this account relies on electrically-powered life support equipment (e.g., home dialysis, ventilator, oxygen concentrator). Triggers mandatory advance disconnection notice requirements and priority restoration during outages per PUC regulations.',
  `move_in_date` DATE COMMENT 'Date on which the customer initiated service at the associated premise, triggering account activation and the start of billing. Corresponds to the service start date in CIS. Critical for proration of first bill and regulatory reporting of new connects.',
  `move_out_date` DATE COMMENT 'Date on which the customer terminated service at the associated premise, triggering final bill generation and account closure. Null for currently active accounts. Corresponds to the service end date in CIS.',
  `open_balance` DECIMAL(15,2) COMMENT 'Current outstanding balance on the account as of the last billing or payment posting. Represents the net amount owed by the customer (positive) or credit due to the customer (negative). Sourced from SAP IS-U FI-CA or Oracle CC&B AR sub-ledger. Used for collections prioritization and credit risk management.',
  `paperless_billing` BOOLEAN COMMENT 'Indicates whether this account is enrolled in paperless (electronic) billing, receiving bills via email or online portal rather than postal mail. Supports sustainability reporting and customer engagement analytics.',
  `preferred_contact_channel` STRING COMMENT 'Customer\'s preferred channel for receiving utility communications including bills, outage notifications, and program offers. Drives multi-channel engagement routing in CRM and outage notification systems (OMS). Aligns with customer consent preferences. Valid values: email|sms|phone|mail|portal|none.',
  `preferred_language` STRING COMMENT 'ISO 639-1 language code (optionally with ISO 3166-1 country subtag) representing the customer\'s preferred language for all communications. Drives bill language selection, IVR routing, and outage notification language. Examples: en, es, zh-TW, vi, ko. Pattern: ^[a-z]{2}(-[A-Z]{2})?$.',
  `rate_category` STRING COMMENT 'The tariff rate schedule or rate class assigned to this account, determining how energy consumption is priced. Examples include residential flat rate, Time-of-Use (TOU), Critical Peak Pricing (CPP), industrial demand rate, and agricultural pumping rate. Drives bill calculation in SAP IS-U or Oracle CC&B. Reference-value candidates: residential_flat|tou_residential|tou_commercial|cpp|industrial_demand|agricultural|street_lighting|ev_charging.',
  `regulatory_jurisdiction` STRING COMMENT 'Two-letter US state code (ISO 3166-2 subdivision) identifying the state Public Utility Commission (PUC) with regulatory authority over this account. Determines applicable tariff, consumer protection rules, and reporting obligations. Critical for multi-state utility operations. Pattern: ^[A-Z]{2}$.',
  `renewable_energy_plan` STRING COMMENT 'Code identifying the voluntary renewable energy plan or green tariff program in which this account is enrolled. Examples include 100% renewable, green power option, or Renewable Energy Certificate (REC) purchase programs. Supports Renewable Portfolio Standard (RPS) compliance tracking. Reference-value candidates: none|green_100pct|green_50pct|rec_purchase|community_solar|wind_option.',
  `service_territory_code` STRING COMMENT 'Code identifying the regulated service territory within which this account receives electric service. Determines applicable tariff schedules, regulatory jurisdiction, and franchise area. Aligns with PUC-approved service territory boundaries. Pattern: ^[A-Z0-9]{2,10}$.',
  `status_change_reason` STRING COMMENT 'Reason code explaining the most recent account status transition. Examples include non_payment, customer_request, move_out, returned_check, medical_baseline, regulatory_order. Supports collections analytics and regulatory compliance reporting. Reference-value candidates: non_payment|customer_request|move_out|returned_check|medical_baseline|regulatory_order|fraud|deceased.',
  `tou_rate_enrolled` BOOLEAN COMMENT 'Indicates whether this account is enrolled on a Time-of-Use (TOU) rate schedule, where energy prices vary by time of day and season to reflect grid conditions. Requires AMI metering. Supports demand flexibility analytics and rate design evaluation.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_account` PRIMARY KEY (`account_id`)
)
USING DELTA
COMMENT 'Core master entity representing a utility customer account in SAP IS-U and Oracle CC&B. Captures the authoritative account record for residential, commercial, and industrial customers including account number, account type (residential/commercial/industrial), account status, account status history (with change timestamps, reason codes, and initiating events), credit class, move-in/move-out dates, service territory, rate category, NEM participation flag, BTM flag, DER enrollment status, CIS source system identifier, regulatory jurisdiction, parent account reference for consolidated billing and corporate hierarchy, and account group classification (consolidated billing, corporate parent, franchise, municipal aggregation, CCA). SSOT for all downstream billing, metering, and demand response domains. Supports lifecycle tracking of activation, suspension, disconnection, reconnection, write-off, and reactivation events. | CMM: CIM CustomerAccount (exact), IEC61968::Customers.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CustomerAccount',
  'cmm.cim.class' = 'CustomerAccount',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Customers',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.account'
);

-- CustomerProfile  <<CIM Customer : exact>>
CREATE TABLE IF NOT EXISTS `customer`.`profile` (
  `profile_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for the customer profile record in the Silver Layer lakehouse. Primary key for all downstream joins across billing, metering, and demand response domains.',
  `mailing_address_id` BIGINT COMMENT 'Foreign key linking to customer.address. Business justification: Profile has embedded mailing address fields that should be normalized to reference the address table. The profile table has mailing_address_line1, mailing_address_line2, mailing_city, mailing_state_pr',
  `autopay_enrolled` BOOLEAN COMMENT 'Indicates whether the customer is enrolled in automatic payment (AutoPay), authorizing the utility to automatically debit the customer\'s bank account or payment card on the bill due date. Reduces collections risk and improves cash flow predictability.',
  `budget_billing_enrolled` BOOLEAN COMMENT 'Indicates whether the customer is enrolled in a budget billing (levelized payment) program, where monthly charges are averaged over 12 months to smooth seasonal bill fluctuations. Drives levelized billing calculation in SAP IS-U or Oracle CC&B.',
  `business_entity_type` STRING COMMENT 'Legal structure of the commercial or industrial customer organization. Null for residential person customers. Used for credit assessment, tax treatment, and regulatory classification. Reference-value candidates: sole_proprietor|partnership|llc|corporation|non_profit|government|trust|cooperative. Valid values: sole_proprietor|partnership|llc|corporation|non_profit|government.',
  `business_partner_number` STRING COMMENT 'Externally-known alphanumeric identifier assigned to the customer in the source Customer Information System (CIS). Maps to SAP IS-U Business Partner (BP) number or Oracle CC&B Person ID. Used for cross-system reconciliation and customer-facing correspondence.',
  `communication_preference` STRING COMMENT 'Customer\'s preferred channel for receiving utility communications including bills, outage notifications, demand response alerts, and program enrollment confirmations. Drives multi-channel engagement routing in CRM and OMS notification systems. Valid values: email|sms|postal_mail|phone|portal|none.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the customer profile record was first created in the source CIS system (SAP IS-U or Oracle CC&B). Represents the customer\'s initial enrollment date with the utility. Stored in yyyy-MM-ddTHH:mm:ss.SSSXXX format per model conventions.',
  `credit_classification` STRING COMMENT 'Internal credit risk classification assigned to the customer based on payment history, credit bureau data, and utility-specific scoring. Drives deposit requirements, payment plan eligibility, and collections treatment. Sourced from SAP IS-U FICA credit segment or Oracle CC&B credit rating. Valid values: excellent|good|fair|poor|no_history.',
  `credit_score` INT COMMENT 'Numeric credit score obtained from a third-party credit bureau or internal scoring model. Range typically 300–850 for FICO-based scores. Used for deposit waiver decisions, payment arrangement eligibility, and collections prioritization. Null if no credit history exists.',
  `customer_segment` STRING COMMENT 'Primary market segment classification of the customer. Drives rate schedule eligibility, billing treatment, and regulatory reporting. Residential covers individual households; commercial covers small-to-medium businesses; industrial covers large-load manufacturing and processing facilities; agricultural covers farming operations; government covers public sector entities. Valid values: residential|commercial|industrial|agricultural|government.',
  `customer_type` STRING COMMENT 'Indicates whether the customer is a natural person (individual) or a legal organization (business entity). Determines which identity attributes are applicable and governs data handling obligations under privacy regulations. Valid values: person|organization.',
  `date_of_birth` DATE COMMENT 'Date of birth of the residential customer individual. Used for identity verification, age-based eligibility programs (e.g., senior discount rates), and credit assessment. Null for organization customers. Stored in yyyy-MM-dd format per model conventions.',
  `demand_response_enrolled` BOOLEAN COMMENT 'Indicates whether the customer is actively enrolled in a Demand Response (DR) program, authorizing the utility or ISO/RTO to curtail or shift the customer\'s load during peak demand events. Drives DR dispatch eligibility in DERMS and EMS systems.',
  `deposit_required` BOOLEAN COMMENT 'Indicates whether the customer is required to pay a security deposit based on credit classification, payment history, or state PUC rules. True triggers deposit collection workflow in SAP IS-U FICA or Oracle CC&B.',
  `der_enrolled` BOOLEAN COMMENT 'Indicates whether the customer has one or more Distributed Energy Resources (DER) — such as rooftop solar, battery storage, or EV chargers — enrolled in the utility\'s DERMS platform. Enables participation in virtual power plant (VPP) programs and demand response dispatch.',
  `do_not_contact` BOOLEAN COMMENT 'Indicates whether the customer has requested to be excluded from non-essential marketing and outreach communications. Does not suppress legally required notices (e.g., disconnection warnings, safety alerts). Enforced in CRM and outbound communication systems.',
  `email_address` STRING COMMENT 'Primary email address for the customer used for electronic bill delivery, outage notifications, demand response program communications, and account alerts. Sourced from SAP IS-U BP email or Oracle CC&B Person email. Pattern: ^[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$.',
  `first_name` STRING COMMENT 'Given name of the residential customer individual. Null for commercial/industrial entity customers. Sourced from SAP IS-U BP first name or Oracle CC&B Person first name field.',
  `government_id_masked` STRING COMMENT 'Masked representation of the government-issued identification number, retaining only the last four digits (e.g., ***-**-1234 for SSN). Full ID is stored only in the source CIS system under restricted access. Used for identity confirmation without exposing the full identifier.',
  `government_id_type` STRING COMMENT 'Type of government-issued identification document provided by the customer for identity verification. SSN and ITIN apply to US individuals; EIN applies to business entities; passport and drivers_license apply to individuals. Paired with masked government_id_masked field. Valid values: ssn|itin|passport|drivers_license|ein|state_id.',
  `identity_verification_status` STRING COMMENT 'Current status of the customer\'s identity verification process. Verified indicates successful validation against government ID or third-party identity service; unverified indicates not yet validated; pending indicates verification in progress; failed indicates verification attempt was unsuccessful; waived indicates verification requirement was formally waived (e.g., for government accounts). Valid values: verified|unverified|pending|failed|waived.',
  `identity_verified_date` DATE COMMENT 'Date on which the customer\'s identity was most recently successfully verified. Used for compliance audit trails and periodic re-verification scheduling. Null if identity_verification_status is unverified or pending.',
  `income_tier` STRING COMMENT 'Income tier classification assigned to the customer based on self-reported or verified household income relative to the federal poverty level (FPL). Used for low-income rate program eligibility, LIHEAP enrollment, and CARE/FERA program qualification. Tier 1 represents lowest income bracket. Valid values: tier_1|tier_2|tier_3|tier_4|tier_5.',
  `language_preference` STRING COMMENT 'Customer\'s preferred language for all communications, bills, and notices. Stored as ISO 639-1 two-letter language code (e.g., en, es, zh, fr, vi). Drives multi-language bill rendering and outage notification language selection in CIS and OMS systems.',
  `last_name` STRING COMMENT 'Family name of the residential customer individual. Null for commercial/industrial entity customers. Sourced from SAP IS-U BP last name or Oracle CC&B Person last name field.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the customer profile record in the source CIS system. Used for change data capture (CDC) processing in the Silver Layer ETL pipeline and audit trail compliance.',
  `legal_name` STRING COMMENT 'Full legal name of the customer as registered with the utility. For residential customers this is the individual\'s full name; for commercial/industrial customers this is the registered business entity name. Used for billing, regulatory correspondence, and identity verification.',
  `lifecycle_status` STRING COMMENT 'Current state of the customer profile in its lifecycle. Active indicates a current utility customer; inactive indicates a former customer with no active service agreements; pending indicates a new customer application in progress; suspended indicates temporary hold due to credit or compliance issues; deceased indicates confirmed death of a residential customer; merged indicates the profile was consolidated into another record. Valid values: active|inactive|pending|suspended|deceased|merged.',
  `low_income_assistance_eligible` BOOLEAN COMMENT 'Indicates whether the customer has been determined eligible for low-income energy assistance programs such as CARE (California Alternate Rates for Energy), FERA, LIHEAP, or equivalent state-specific programs. Drives discounted rate application in billing.',
  `low_income_program_code` STRING COMMENT 'Code identifying the specific low-income assistance program the customer is enrolled in (e.g., CARE, FERA, LIHEAP, HEAP, REACH). Null if low_income_assistance_eligible is false. Used for rate discount application and regulatory reporting to state PUC.',
  `marketing_consent` BOOLEAN COMMENT 'Indicates whether the customer has provided explicit consent to receive marketing communications about energy efficiency programs, new rate plans, and utility products. Required under GDPR opt-in rules for EU-adjacent operations and CCPA for California customers.',
  `medical_baseline_eligible` BOOLEAN COMMENT 'Indicates whether the customer qualifies for a medical baseline allowance due to a life-threatening illness or condition requiring life-support equipment. Triggers additional baseline energy allocation at the lowest rate tier and special disconnection protections under state PUC rules.',
  `mobile_phone_number` STRING COMMENT 'Mobile telephone number for the customer, used specifically for SMS-based outage alerts, two-factor authentication, and demand response text notifications. Distinct from primary phone which may be a landline. Stored in E.164 format. Pattern: ^\\+?[1-9]\\d{1,14}$.',
  `nem_participant` BOOLEAN COMMENT 'Indicates whether the customer participates in a Net Energy Metering (NEM) program, meaning they have behind-the-meter (BTM) generation (typically solar PV) and receive credits for excess energy exported to the grid. Drives bidirectional metering requirements and NEM tariff application.',
  `paperless_billing` BOOLEAN COMMENT 'Indicates whether the customer has opted into electronic (paperless) bill delivery, suppressing physical mail generation. Drives bill rendering workflow in SAP IS-U or Oracle CC&B billing engine.',
  `phone_number` STRING COMMENT 'Primary contact telephone number for the customer. Used for outage notifications, payment reminders, demand response alerts, and field crew coordination. Stored in E.164 international format. Pattern: ^\\+?[1-9]\\d{1,14}$.',
  `source_system` STRING COMMENT 'Identifies the operational system of record from which this customer profile was sourced. SAP_IS_U indicates SAP Industry Solution for Utilities; ORACLE_CCB indicates Oracle Utilities Customer Care and Billing; MANUAL indicates manually entered records; MIGRATION indicates records loaded during a system migration event. Used for data lineage tracking and reconciliation. Valid values: SAP_IS_U|ORACLE_CCB|MANUAL|MIGRATION.',
  `tax_id_number` STRING COMMENT 'Federal tax identification number for commercial/industrial customers (EIN) or individual taxpayer identification for sole proprietors. Used for 1099 reporting, tax exemption validation, and regulatory filings. Masked in analytics layer; full value retained in source CIS.',
  `third_party_data_sharing_consent` BOOLEAN COMMENT 'Indicates whether the customer has consented to sharing their energy usage and profile data with authorized third parties (e.g., solar installers, EV charging providers, energy management platforms) under Green Button Connect My Data or similar data access frameworks.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_profile` PRIMARY KEY (`profile_id`)
)
USING DELTA
COMMENT 'Master entity capturing the identity and demographic attributes of a utility customer person or organization. Stores legal name, date of birth, government ID type and masked number, business entity type (sole proprietor, LLC, corporation), language preference, communication preference, income tier classification, low-income assistance program eligibility, and identity verification status. Supports both residential individuals and commercial/industrial entities. Sourced from SAP IS-U Business Partner and Oracle CC&B Person/Account. | CMM: CIM Customer (exact), IEC61968::Customers.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CustomerProfile',
  'cmm.cim.class' = 'Customer',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Customers',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.profile'
);

-- Premise  <<CIM ServiceLocation : exact>>
CREATE TABLE IF NOT EXISTS `customer`.`premise` (
  `premise_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for the physical service location (premise) within the utility\'s Customer Information System (CIS). Primary key for all premise-level metering, billing, and outage management references. Role: MASTER_RESOURCE.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Premises must be assigned to balancing authority control areas for load forecasting, interchange scheduling, regulatory jurisdiction determination, and NERC compliance reporting. Essential for operati',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Premises are mapped to distribution cost centers for territorial cost allocation and service area profitability tracking. Critical for distribution cost management, rate design, and territorial P&L re',
  `distribution_feeder_id` BIGINT COMMENT 'Identifier of the distribution feeder circuit supplying power to the premise, as modeled in the utility\'s Advanced Distribution Management System (ADMS) and GIS. Critical for outage management, load balancing, Fault Location Isolation and Service Restoration (FLISR), and Volt-VAR optimization in GE PowerOn ADMS.',
  `distribution_substation_id` BIGINT COMMENT 'Identifier of the distribution substation supplying the feeder that serves this premise. Used for hierarchical network topology analysis, outage impact scoping, and SAIDI/SAIFI/CAIDI reliability metric calculation.',
  `distribution_transformer_id` BIGINT COMMENT 'Identifier of the distribution transformer bank serving the premise, as recorded in the utility\'s asset management system (Ventyx Asset Suite) and GIS. Used for transformer loading analysis, outage impact assessment, and asset maintenance planning.',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Premises must be mapped to forecast zones for distribution load planning, capacity requirement allocation, outage impact analysis, and DER penetration forecasting. Essential for translating zone-level',
  `meter_reading_route_id` BIGINT COMMENT 'Identifier of the meter reading route to which the premise is assigned for field meter reading operations. Used for route optimization, meter reader scheduling, and AMI walk-by/drive-by reading coordination in Oracle Utilities MDM.',
  `primary_warehouse_id` BIGINT COMMENT 'Foreign key linking to supply.warehouse. Business justification: Premises are assigned to primary warehouses based on service territory geography for emergency restoration material dispatch, routine maintenance supply, and storm response logistics. Critical for SAI',
  `ami_eligible` BOOLEAN COMMENT 'Indicates whether the premise is eligible for Advanced Metering Infrastructure (AMI) smart meter deployment based on infrastructure readiness, service voltage, and utility AMI rollout program criteria. Drives meter deployment prioritization in Oracle Utilities MDM.',
  `billing_cycle_code` STRING COMMENT 'Code identifying the billing cycle to which the premise is assigned, determining meter reading schedule and bill generation frequency. Sourced from SAP IS-U Billing Cycle or Oracle CC&B Bill Cycle configuration. Pattern: ^[A-Z0-9]{1,10}$.',
  `classification` STRING COMMENT 'Detailed structural classification of the premise beyond the high-level premise type. Used for load profile modeling, infrastructure planning, and demand response program eligibility. Examples: single-family, multi-family, high-rise, substation-fed. Reference-value candidates: single_family|multi_family|high_rise|substation_fed|mobile_home|commercial_strip|warehouse|manufacturing|farm.',
  `climate_zone` STRING COMMENT 'Climate zone designation assigned to the premise based on geographic location and DOE/ASHRAE climate classification. Used for energy efficiency program targeting, demand response (DR) program design, Integrated Resource Planning (IRP), and Renewable Portfolio Standard (RPS) compliance analysis. Pattern: ^[A-Z0-9\\-]{1,10}$.',
  `construction_year` INT COMMENT 'Year the premise structure was originally constructed. Used for energy efficiency program eligibility assessment, weatherization program targeting, load profile modeling, and infrastructure age analysis. Sourced from county assessor records or customer-provided data.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the premise record was first created in the source CIS system (SAP IS-U or Oracle CC&B). Provides audit trail for data governance, regulatory compliance, and data lineage tracking in the Databricks Silver Layer.',
  `critical_facility_flag` BOOLEAN COMMENT 'Indicates whether the premise is designated as a critical facility (e.g., hospital, emergency services, water treatment plant, telecommunications hub) requiring priority restoration during outages. Drives outage management system (OMS) prioritization and mutual aid planning.',
  `der_enrolled` BOOLEAN COMMENT 'Indicates whether the premise has an active Distributed Energy Resource (DER) enrollment, including rooftop solar, battery storage, or other behind-the-meter (BTM) generation assets registered in the utility\'s Distributed Energy Resource Management System (DERMS). Supports Virtual Power Plant (VPP) aggregation and demand response programs.',
  `ev_charging_flag` BOOLEAN COMMENT 'Indicates whether the premise has a registered electric vehicle (EV) charging installation. Used for distribution load forecasting, EV rate schedule eligibility, demand response program targeting, and grid modernization planning.',
  `floor_area_sqft` DECIMAL(10,2) COMMENT 'Total conditioned floor area of the premise structure in square feet. Used for energy intensity benchmarking (kWh per square foot), energy efficiency program eligibility, demand response capacity estimation, and load profile normalization.',
  `gis_parcel_reference` STRING COMMENT 'Assessor\'s parcel number or GIS parcel identifier linking the premise to the county tax assessor\'s spatial parcel layer in Esri ArcGIS Utility Network. Enables land-use analysis, property boundary correlation, and infrastructure planning.',
  `last_inspection_date` DATE COMMENT 'Date of the most recent utility field inspection of the premise\'s service entrance, metering equipment, or electrical infrastructure. Used for compliance tracking, safety program management, and asset maintenance scheduling in Ventyx Asset Suite.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the premise record in the source CIS system. Used for incremental data pipeline processing, change data capture (CDC), and audit trail maintenance per SOX and NERC CIP requirements.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate (WGS84 decimal degrees) of the physical service location as recorded in the utility\'s Geographic Information System (GIS). Used for outage management spatial analysis, field crew routing, and distribution network modeling in Esri ArcGIS Utility Network.',
  `life_support_flag` BOOLEAN COMMENT 'Indicates whether a registered life-support equipment user resides at the premise. Triggers disconnection protection, priority outage notification, and special field crew protocols per state PUC regulations. Distinct from medical_baseline_flag which governs billing treatment.',
  `lifecycle_status` STRING COMMENT 'Current operational state of the premise within the utility\'s service portfolio. Drives eligibility for new service connections, billing activation, and outage management inclusion. Active premises are energized and receiving service; decommissioned premises have been permanently removed from service. Valid values: active|inactive|pending_activation|decommissioned|demolished.',
  `load_profile_class` STRING COMMENT 'Utility-assigned load profile class code used to model the premise\'s expected energy consumption pattern for billing, forecasting, and settlement purposes. Applied to non-interval-metered customers for load research and wholesale market settlement. Sourced from Oracle Utilities MDM or SAP IS-U.',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate (WGS84 decimal degrees) of the physical service location as recorded in the utility\'s Geographic Information System (GIS). Used in conjunction with latitude for spatial analysis, outage polygon mapping, and DER interconnection planning.',
  `medical_baseline_flag` BOOLEAN COMMENT 'Indicates whether the premise has a registered medical baseline allowance due to a life-support or medical necessity condition. Triggers special billing treatment, outage notification priority, and disconnection protection protocols per state PUC regulations.',
  `meter_socket_count` INT COMMENT 'Number of meter sockets (meter points) installed at the premise. Multi-socket premises include multi-family dwellings, commercial complexes, and industrial facilities with multiple service points. Drives meter deployment planning in Oracle Utilities MDM and SAP IS-U Device Management.',
  `nem_eligible` BOOLEAN COMMENT 'Indicates whether the premise is eligible for Net Energy Metering (NEM) based on service territory rules, interconnection capacity, and applicable state PUC tariff provisions. Supports Distributed Energy Resource (DER) enrollment and behind-the-meter (BTM) generation tracking.',
  `num_units` INT COMMENT 'Number of individual dwelling or tenant units within the premise. Applicable to multi-family, high-rise, and mixed-use premises. Used for per-unit load analysis, master-metered billing allocation, and demand response program enrollment capacity.',
  `peak_demand_kw` DECIMAL(12,3) COMMENT 'Recorded or estimated peak electrical demand in kilowatts (kW) for the premise. Used for transformer sizing, distribution capacity planning, demand charge billing, and demand response (DR) program baseline establishment. Sourced from Oracle Utilities MDM interval data or SAP IS-U demand registers.',
  `premise_code` STRING COMMENT 'Externally-known alphanumeric business identifier for the premise as assigned by the utility\'s CIS (SAP IS-U or Oracle CC&B). Used in field operations, customer correspondence, and cross-system integration. Corresponds to SAP IS-U Premise Number or Oracle CC&B Premise ID. Pattern: ^[A-Z0-9\\-]{4,20}$.',
  `premise_type` STRING COMMENT 'High-level classification of the premise by customer segment and land use. Drives rate schedule eligibility, load profile assignment, and regulatory reporting segmentation. Reference-value candidates: residential|commercial|industrial|agricultural|municipal|mixed_use. Valid values: residential|commercial|industrial|agricultural|municipal|mixed_use.',
  `rate_schedule_code` STRING COMMENT 'Utility tariff rate schedule code applicable to the premise, as defined in the state PUC-approved tariff and configured in SAP IS-U or Oracle CC&B. Determines energy charge structure, demand charges, TOU periods, and applicable riders. Pattern: ^[A-Z0-9\\-]{2,20}$.',
  `service_address_id` BIGINT COMMENT 'Foreign key linking to customer.address. Business justification: Premise has embedded address fields that should be normalized to reference the address table. The premise table has address_line1, address_line2, city, state_code, postal_code, county, country_code wh',
  `service_end_date` DATE COMMENT 'Date on which utility service was permanently terminated at the premise (e.g., demolition, decommissioning). Null for active premises. Used for premise lifecycle management and historical reporting.',
  `service_start_date` DATE COMMENT 'Date on which utility service was first activated at the premise. Establishes the premise\'s service history baseline for billing, regulatory reporting, and infrastructure age analysis.',
  `service_territory_code` STRING COMMENT 'Utility-defined code identifying the franchised service territory zone in which the premise is located. Determines applicable tariff schedules, regulatory jurisdiction (PUC), and operational responsibility. Sourced from SAP IS-U Division or Oracle CC&B Service Territory. Pattern: ^[A-Z0-9\\-]{2,15}$.',
  `service_voltage_class` STRING COMMENT 'Nominal voltage class at which electric service is delivered to the premise. Determines applicable tariff rate schedule, metering configuration, and interconnection requirements. Critical for rate design and OATT compliance. Reference-value candidates: secondary_120v|secondary_240v|primary_4kv|primary_12kv|primary_25kv|transmission. Valid values: secondary_120v|secondary_240v|primary_4kv|primary_12kv|primary_25kv|transmission.',
  `tou_rate_eligible` BOOLEAN COMMENT 'Indicates whether the premise qualifies for Time of Use (TOU) or Critical Peak Pricing (CPP) rate schedules based on metering capability (AMI), service class, and applicable PUC tariff provisions. Drives rate schedule assignment and customer enrollment workflows.',
  `gis_location_id` BIGINT COMMENT 'Reference to the canonical CIM Location (gis.location) holding this entity\'s geometry, CRS and address. Implements CIM association Location (is-a; geometry via Location.PositionPoints).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_premise` PRIMARY KEY (`premise_id`)
)
USING DELTA
COMMENT 'Master entity representing a physical service location (premise) where utility service is delivered. Captures premise address, premise type (residential, commercial, industrial, agricultural), GIS coordinates (latitude/longitude), service territory code, distribution feeder ID, transformer bank ID, meter socket count, premise classification (single-family, multi-family, high-rise, substation-fed), load profile class, climate zone, and premise construction year. SSOT for all premise-level metering, billing, and outage management references. | CMM: CIM ServiceLocation (exact), IEC61968::Customers.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'Premise',
  'cmm.cim.class' = 'ServiceLocation',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Customers',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.premise',
  'cmm.gis.location.role' = 'Location (is-a; geometry via Location.PositionPoints)'
);

-- CustomerServiceAgreement  <<CIM CustomerAgreement : exact>>
CREATE TABLE IF NOT EXISTS `customer`.`customer_service_agreement` (
  `customer_service_agreement_id` BIGINT NOT NULL COMMENT 'Unique identifier for the customer service agreement. Primary key for this entity.',
  `customer_account_id` BIGINT COMMENT 'FK to customer.account.account_id — Every service agreement is held by an account. This is a core CIS relationship — service_agreement.account_id → account.account_id. Without this, service agreements are orphaned.',
  `customer_premise_id` BIGINT COMMENT 'Reference to the physical premise where service is delivered under this agreement.',
  `der_interconnection_point_id` BIGINT COMMENT 'Interconnection agreement identifier for customers with DER (Distributed Energy Resource) such as solar, wind, or battery storage. Links to detailed interconnection application and technical specifications. Null for customers without DER.',
  `ppa_contract_id` BIGINT COMMENT 'Foreign key linking to renewable.ppa_contract. Business justification: Behind-the-meter PPA agreements are service agreements requiring direct linkage for billing integration, rate schedule coordination, and customer account management. Critical for community solar and t',
  `premise_id` BIGINT COMMENT 'FK to customer.premise.premise_id — Every service agreement delivers service at a specific premise. service_agreement.premise_id → premise.premise_id. This is the core CIS triad: account ↔ service agreement ↔ premise.',
  `primary_customer_account_id` BIGINT COMMENT 'Reference to the customer account that holds this service agreement.',
  `service_delivery_asset_registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: Service agreements reference specific service delivery assets (transformer, switchgear) for capacity allocation, load management, and contract demand enforcement. Required for distribution capacity pl',
  `service_level_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.service_level_agreement. Business justification: Each customer service agreement is governed by a Service Level Agreement; adding FK captures this relationship and provides inbound link to service_level_agreement.',
  `vendor_id` BIGINT COMMENT 'Reference to the competitive energy supplier or Community Choice Aggregator (CCA) providing generation service in deregulated markets. Null for bundled service where utility provides both delivery and generation.',
  `agreement_number` STRING COMMENT 'Externally visible business identifier for the service agreement, used in customer communications and billing statements.',
  `agreement_status` STRING COMMENT 'Current lifecycle state of the service agreement. Draft indicates agreement is being prepared; pending approval awaiting credit or regulatory review; active means service is being delivered; suspended for temporary service interruption; terminated for completed agreements; cancelled for agreements that never went active. Valid values: draft|pending_approval|active|suspended|terminated|cancelled.',
  `agreement_type` STRING COMMENT 'Classification of the service agreement. Standard represents typical utility service; NEM (Net Energy Metering) for customers with behind-the-meter generation; DER interconnection for Distributed Energy Resource participants; community solar for shared renewable programs; green tariff for voluntary renewable energy purchase; special contract for negotiated large customer agreements. Valid values: standard|nem|der_interconnection|community_solar|green_tariff|special_contract.',
  `auto_pay_flag` BOOLEAN COMMENT 'Indicates whether automatic payment is enabled for this service agreement, allowing bills to be paid automatically from customer bank account or credit card.',
  `billing_cycle_code` STRING COMMENT 'Billing cycle assignment determining when meter reads occur and bills are generated. Typically represents a monthly cycle number (e.g., cycle 01 reads on 1st of month, cycle 15 reads on 15th).',
  `budget_billing_flag` BOOLEAN COMMENT 'Indicates whether the customer is enrolled in budget billing program, which averages annual usage to provide consistent monthly payment amounts.',
  `care_program_flag` BOOLEAN COMMENT 'Indicates enrollment in CARE or similar low-income assistance program providing discounted rates. CARE is California-specific; other states have equivalent programs (e.g., LIHEAP).',
  `contract_demand_kw` DECIMAL(12,3) COMMENT 'Contracted maximum demand in kilowatts (kW) for large commercial and industrial customers with demand-based rate schedules. Customer pays for this capacity regardless of actual usage. Null for non-demand customers.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this service agreement record was first created in the system. Audit field for data lineage and compliance.',
  `deposit_amount` DECIMAL(15,2) COMMENT 'Dollar amount of security deposit held for this service agreement, typically required for customers with poor credit or no credit history. Null if no deposit required.',
  `deposit_waiver_reason` STRING COMMENT 'Reason why security deposit was waived if deposit amount is zero. Good credit for customers meeting credit score threshold; senior citizen, low income, or military for protected classes; prior customer for returning customers with good payment history; none if deposit was not waived. Valid values: good_credit|senior_citizen|low_income|military|prior_customer|none.',
  `end_date` DATE COMMENT 'Date when service agreement terminates and service delivery ends. Null for open-ended agreements. Populated when customer requests disconnection or agreement reaches contracted term end.',
  `life_support_flag` BOOLEAN COMMENT 'Indicates whether premise has registered life support or medical equipment requiring continuous electric service. Provides special protections against disconnection and priority restoration during outages.',
  `load_profile_code` STRING COMMENT 'Statistical load profile classification used for non-interval metered customers to estimate hourly usage patterns for settlement and forecasting. Based on customer class and historical usage patterns.',
  `master_metered_flag` BOOLEAN COMMENT 'Indicates whether this agreement covers master-metered service where a single meter serves multiple dwelling units (e.g., apartment building) and the property owner sub-meters or allocates costs to tenants.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this service agreement record was last modified. Audit field for change tracking and compliance.',
  `nem_agreement_type` STRING COMMENT 'Specific NEM (Net Energy Metering) program version if customer has behind-the-meter generation. NEM 1.0, 2.0, 3.0 represent California program generations; VNEM for virtual net metering; NEMBAT for NEM with battery storage. Not applicable for customers without generation. Valid values: nem_1_0|nem_2_0|nem_3_0|vnem|nembat|not_applicable.',
  `paperless_billing_flag` BOOLEAN COMMENT 'Indicates whether customer has opted for electronic bill delivery instead of paper statements.',
  `payment_arrangement_flag` BOOLEAN COMMENT 'Indicates whether customer currently has an active payment arrangement or installment plan for past due balances.',
  `power_factor_requirement` DECIMAL(4,3) COMMENT 'Minimum power factor (ratio of real to apparent power) required for large industrial customers. Typically 0.90 or higher. Customers below threshold may incur penalties. Null for customers without power factor requirements.',
  `rate_schedule_code` STRING COMMENT 'Tariff rate schedule code assigned to this agreement, determining pricing structure and billing rules. Examples include residential flat rate, commercial TOU (Time of Use), industrial demand-based, or CPP (Critical Peak Pricing) schedules.',
  `seasonal_service_flag` BOOLEAN COMMENT 'Indicates whether this is a seasonal service agreement (e.g., vacation home, agricultural operation) with predictable periods of no usage and special billing rules.',
  `service_class` STRING COMMENT 'Customer segment classification for regulatory reporting and rate design. Residential for households; commercial for businesses; industrial for manufacturing; agricultural for farms; municipal for government facilities; street lighting for public infrastructure. Valid values: residential|commercial|industrial|agricultural|municipal|street_lighting.',
  `service_type` STRING COMMENT 'Type of utility commodity delivered under this agreement. Electric for electricity service; gas for natural gas; water for potable water; steam and chilled water for district energy systems. Valid values: electric|gas|water|steam|chilled_water.',
  `service_voltage_level` STRING COMMENT 'Voltage level at which electric service is delivered. Secondary for residential/small commercial (120/240V); primary for larger commercial (4-35kV); subtransmission (35-138kV); transmission for industrial customers (>138kV). Null for non-electric services. Valid values: secondary|primary|subtransmission|transmission.',
  `source_system` STRING COMMENT 'Operational system of record from which this service agreement was sourced. SAP IS-U for SAP Industry Solution for Utilities; Oracle CC&B for Oracle Customer Care and Billing; legacy CIS for older customer information systems being migrated. Valid values: sap_isu|oracle_ccb|legacy_cis.',
  `source_system_code` STRING COMMENT 'Native identifier of this service agreement in the source operational system. Used for data lineage, reconciliation, and troubleshooting integration issues.',
  `start_date` DATE COMMENT 'Date when service agreement becomes effective and service delivery begins. Corresponds to service turn-on date for new customers or agreement renewal date for existing customers.',
  `termination_reason` STRING COMMENT 'Reason for service agreement termination. Customer request for voluntary disconnection; move out when customer relocates; non-payment for involuntary disconnection; death of account holder; foreclosure for property repossession; service transfer when service moves to new account; contract expiration for fixed-term agreements. Reference-value candidates: customer_request|move_out|non_payment|death|foreclosure|service_transfer|contract_expiration.',
  `third_party_notification_flag` BOOLEAN COMMENT 'Indicates whether customer has designated a third party (family member, social worker, advocate) to receive copies of disconnection notices and other critical communications.',
  `tou_plan_code` STRING COMMENT 'Specific TOU (Time of Use) pricing plan code if the rate schedule includes time-differentiated pricing. Defines peak, off-peak, and shoulder period pricing structures.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_customer_service_agreement` PRIMARY KEY (`customer_service_agreement_id`)
)
USING DELTA
COMMENT 'Master entity representing the contractual service agreement between a utility and a customer account for a specific premise and rate schedule. Captures agreement start and end dates, rate schedule code, service type (electric, gas, water), TOU plan assignment, budget billing flag, auto-pay flag, paperless billing flag, deposit amount, deposit waiver reason, and agreement status. References NEM agreement type and DER interconnection ID as contractual entitlements (detailed program participation attributes are managed in enrollment). Sourced from SAP IS-U Contract and Oracle CC&B Service Agreement. SSOT for rate schedule assignment and service entitlement at the account-premise level. | CMM: CIM CustomerAgreement (exact), IEC61968::Customers.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CustomerServiceAgreement',
  'cmm.cim.class' = 'CustomerAgreement',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Customers',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.customer_service_agreement'
);

-- CustomerContact  <<CIM ElectronicAddress : close>>
CREATE TABLE IF NOT EXISTS `customer`.`contact` (
  `contact_id` BIGINT NOT NULL COMMENT 'Unique identifier for the contact record. Primary key.',
  `contact_account_id` BIGINT COMMENT 'Reference to the specific service account associated with this contact. Supports account-level contact management for multi-account customers.',
  `contact_profile_id` BIGINT COMMENT 'Reference to the customer profile or account to which this contact belongs. Links contact to customer master entity in CIS (SAP IS-U, Oracle CC&B).',
  `postal_address_id` BIGINT COMMENT 'Foreign key linking to customer.address. Business justification: Contact has embedded postal address fields that should be normalized to reference the address table. The contact table has postal_address_line1, postal_address_line2, postal_city, postal_state_provinc',
  `to_account_id` BIGINT COMMENT 'FK to customer.account.account_id — Some contacts are account-level (billing contact, emergency contact) rather than profile-level. Required for account-specific notification routing.',
  `to_profile_id` BIGINT COMMENT 'FK to customer.profile.profile_id — Contact points belong to a customer profile. contact.profile_id → profile.profile_id. Essential for multi-channel engagement.',
  `bounce_count` INT COMMENT 'Number of failed delivery attempts (email bounces, SMS failures, undeliverable mail) for this contact. High bounce counts trigger contact verification workflows.',
  `channel` STRING COMMENT 'Primary communication channel or medium for this contact point. Determines delivery method for notifications and alerts. Valid values: phone|email|sms|postal_mail|push_notification|web_portal.',
  `contact_role` STRING COMMENT 'Specific role or relationship of the contact to the account holder. Defines authorization level for account actions and information access. Valid values: account_holder|co_applicant|property_manager|landlord|authorized_representative|emergency_contact.',
  `contact_status` STRING COMMENT 'Current lifecycle status of the contact record. Determines whether the contact is eligible for notifications and communications. Valid values: active|inactive|pending_verification|bounced|opted_out|invalid.',
  `contact_type` STRING COMMENT 'Classification of the contact role within the customer relationship. Determines contact authority and notification eligibility. Valid values: primary|billing|emergency|authorized_third_party|property_manager|landlord.',
  `contact_value` DECIMAL(18,2) COMMENT 'The actual contact information value (phone number, email address, postal address, device token). Format varies by contact_channel. Classified as restricted PII.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this contact record was first created in the CIS system. Supports audit trail and data lineage.',
  `effective_end_date` DATE COMMENT 'Date when this contact record expires or is no longer valid for communications. Null indicates an open-ended contact.',
  `effective_start_date` DATE COMMENT 'Date when this contact record becomes active and eligible for use in communications.',
  `email_address` STRING COMMENT 'Primary email address for electronic communication. Used for billing statements, outage alerts, DR (Demand Response) event notifications, and regulatory communications. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `language_preference` STRING COMMENT 'Two-letter ISO 639-1 language code indicating the customers preferred language for communications through this contact channel. Pattern: ^[a-z]{2}$.',
  `last_bounce_date` DATE COMMENT 'Date of the most recent failed delivery attempt for this contact channel.',
  `last_contact_date` DATE COMMENT 'Date when this contact channel was last successfully used for customer communication. Supports contact hygiene and data quality monitoring.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this contact record was last updated. Supports change tracking and audit compliance.',
  `notification_frequency` STRING COMMENT 'Preferred frequency for non-critical notifications through this contact channel. Critical alerts (outages, safety) are always sent in real-time. Valid values: real_time|daily_digest|weekly_summary|monthly_summary|as_needed.',
  `notification_preference_billing` BOOLEAN COMMENT 'Indicates whether the customer wants to receive billing alerts and payment reminders through this contact channel.',
  `notification_preference_dr_event` BOOLEAN COMMENT 'Indicates whether the customer wants to receive DR event dispatch notifications through this contact channel. Supports demand response program participation.',
  `notification_preference_marketing` BOOLEAN COMMENT 'Indicates whether the customer wants to receive marketing communications, promotional offers, and energy efficiency program information through this contact channel.',
  `notification_preference_outage` BOOLEAN COMMENT 'Indicates whether the customer wants to receive outage notifications through this contact channel. Supports OMS (Outage Management System) alerting.',
  `notification_preference_regulatory` BOOLEAN COMMENT 'Indicates whether the customer wants to receive regulatory notices and compliance communications through this contact channel. Some regulatory notices are mandatory regardless of preference.',
  `opt_in_date` DATE COMMENT 'Date when the customer provided consent to receive communications through this contact channel.',
  `opt_in_status` STRING COMMENT 'Customer consent status for receiving communications through this contact channel. Supports TCPA and CAN-SPAM compliance. Valid values: opted_in|opted_out|pending|not_applicable.',
  `opt_out_date` DATE COMMENT 'Date when the customer withdrew consent or unsubscribed from communications through this contact channel.',
  `phone_number` STRING COMMENT 'Primary telephone number for voice contact. Supports outage notifications, billing alerts, and customer service callbacks.',
  `preferred_contact_flag` BOOLEAN COMMENT 'Indicates whether this is the customers preferred contact method for general communications. True if preferred, False otherwise.',
  `preferred_contact_time_end` STRING COMMENT 'End time of the customers preferred contact window in HH:MM format (24-hour). Used for outbound calls and scheduled notifications. Pattern: ^([01]?[0-9]|2[0-3]):[0-5][0-9]$.',
  `preferred_contact_time_start` STRING COMMENT 'Start time of the customers preferred contact window in HH:MM format (24-hour). Used for outbound calls and scheduled notifications. Pattern: ^([01]?[0-9]|2[0-3]):[0-5][0-9]$.',
  `priority_rank` INT COMMENT 'Numeric ranking of this contact within the customers contact list. Lower numbers indicate higher priority. Used for cascading notification logic.',
  `quiet_hours_end` STRING COMMENT 'End time of the do-not-disturb period in HH:MM format (24-hour). Notifications resume after quiet hours end. Pattern: ^([01]?[0-9]|2[0-3]):[0-5][0-9]$.',
  `quiet_hours_start` STRING COMMENT 'Start time of the do-not-disturb period in HH:MM format (24-hour). Notifications are suppressed during quiet hours unless critical. Pattern: ^([01]?[0-9]|2[0-3]):[0-5][0-9]$.',
  `sms_number` STRING COMMENT 'Mobile phone number for SMS text message notifications. Supports real-time outage alerts, payment reminders, and DR event dispatch.',
  `source_system` STRING COMMENT 'Originating system or channel where this contact record was created or last updated. Supports data lineage and multi-channel integration. Valid values: SAP_IS-U|Oracle_CCB|Web_Portal|Mobile_App|Call_Center|Field_Service.',
  `verification_date` DATE COMMENT 'Date when the contact information was last successfully verified by the customer.',
  `verification_status` STRING COMMENT 'Indicates whether the contact information has been validated through confirmation process (email click, SMS reply, phone verification). Valid values: verified|unverified|pending|failed.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_contact` PRIMARY KEY (`contact_id`)
)
USING DELTA
COMMENT 'Master entity capturing all contact points and notification preferences associated with a customer profile or account. Stores contact type (primary, billing, emergency, authorized third party), contact channel (phone, email, SMS, postal mail, push notification), contact value (phone number, email address), opt-in/opt-out status per channel, contact verification status, preferred contact time window, contact role (account holder, co-applicant, property manager, landlord), and notification preferences including notification type (outage, billing alert, payment reminder, DR event, regulatory), preferred notification channel, notification frequency, quiet hours, and language preference. Supports multi-channel engagement tracking, AMI outage notification, OMS customer alerting, and demand response event dispatch within CIS platforms. | CMM: CIM ElectronicAddress (close), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CustomerContact',
  'cmm.cim.class' = 'ElectronicAddress',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.contact'
);

-- PostalAddress  <<CIM StreetAddress : exact>>
CREATE TABLE IF NOT EXISTS `customer`.`address` (
  `address_id` BIGINT NOT NULL COMMENT 'Unique identifier for the address record. Primary key.',
  `premise_id` BIGINT COMMENT 'FK to customer.premise.premise_id — Service addresses are associated with premises. address.premise_id → premise.premise_id (for service address type). Critical for GIS integration and field operations.',
  `address_status` STRING COMMENT 'Current lifecycle status of the address: active (in use), inactive (not currently used), pending_validation (awaiting verification), retired (no longer valid), or seasonal (used only during specific periods). Valid values: active|inactive|pending_validation|retired|seasonal.',
  `address_type` STRING COMMENT 'Classification of address usage: service (physical service delivery location), mailing (correspondence destination), billing (invoice destination), third_party_notification (authorized third-party contact), premise (metered location), or correspondence (general communication). Valid values: service|mailing|billing|third_party_notification|premise|correspondence.',
  `carrier_route_code` STRING COMMENT 'USPS carrier route code identifying the mail delivery route for this address.',
  `census_block_group` STRING COMMENT 'US Census Bureau block group identifier for granular demographic and socioeconomic analysis.',
  `census_tract` STRING COMMENT 'US Census Bureau tract identifier for demographic analysis, regulatory reporting, and low-income program eligibility (e.g., LIHEAP, energy assistance programs).',
  `city` STRING COMMENT 'City or municipality name for the address.',
  `country_code` STRING COMMENT 'Three-letter ISO country code (e.g., USA, CAN, MEX). Pattern: ^[A-Z]{3}$.',
  `county_name` STRING COMMENT 'County or parish name for regulatory jurisdiction, tax district assignment, and Public Utility Commission (PUC) reporting.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this address record was first created in the system.',
  `delivery_point_barcode` STRING COMMENT 'USPS Delivery Point Barcode (DPBC) for automated mail sorting and delivery accuracy.',
  `distribution_planning_area` STRING COMMENT 'Distribution system planning zone or district for load forecasting, capacity planning, and Integrated Resource Plan (IRP) analysis.',
  `effective_end_date` DATE COMMENT 'Date when this address ceased to be effective. Null for currently active addresses.',
  `effective_start_date` DATE COMMENT 'Date when this address became effective and available for use in customer service agreements and billing.',
  `geocode_accuracy` STRING COMMENT 'Precision level of geocoding: rooftop (exact building), parcel (property boundary), street (street segment), zip_centroid (postal code center), city_centroid (city center), or unknown (not geocoded). Valid values: rooftop|parcel|street|zip_centroid|city_centroid|unknown.',
  `geocode_latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate in decimal degrees for GIS integration and outage management. Supports spatial analysis and proximity calculations.',
  `geocode_longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate in decimal degrees for GIS integration and outage management. Supports spatial analysis and proximity calculations.',
  `gis_feature_reference` STRING COMMENT 'Geographic Information System (GIS) feature identifier linking this address to the utility network model in Esri ArcGIS or equivalent GIS platform.',
  `is_primary_address` BOOLEAN COMMENT 'Indicates whether this is the primary address for the associated customer or premise. True if primary, False otherwise.',
  `is_seasonal_address` BOOLEAN COMMENT 'Indicates whether this address is used seasonally (e.g., vacation homes, seasonal businesses). True if seasonal, False otherwise.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this address record was last updated or modified.',
  `line_1` STRING COMMENT 'Primary street address line including street number, street name, and street type (e.g., 123 Main Street).',
  `line_2` STRING COMMENT 'Secondary address line for apartment, suite, unit, building, floor, or other location identifiers.',
  `municipality_name` STRING COMMENT 'Incorporated city, town, or municipal district name for franchise agreement tracking and local regulatory compliance.',
  `outage_management_zone` STRING COMMENT 'Outage Management System (OMS) zone identifier for outage tracking, crew dispatch, and SAIDI/SAIFI/CAIDI reliability metric calculation.',
  `postal_code` STRING COMMENT 'Postal or ZIP code for the address. Supports 5-digit, ZIP+4, and international postal code formats.',
  `seasonal_end_month` INT COMMENT 'Month number (1-12) when seasonal occupancy typically ends. Null for non-seasonal addresses.',
  `seasonal_start_month` INT COMMENT 'Month number (1-12) when seasonal occupancy typically begins. Null for non-seasonal addresses.',
  `service_territory_code` STRING COMMENT 'Utility service territory identifier indicating the geographic area and regulatory jurisdiction for service delivery. Used for Certificate of Public Convenience and Necessity (CPCN) compliance.',
  `source_system` STRING COMMENT 'Source system or application that created or maintains this address record (e.g., SAP IS-U, Oracle CC&B, GIS, MDM).',
  `source_system_code` STRING COMMENT 'Unique identifier for this address in the source system of record. Used for data lineage and reconciliation.',
  `state_province_code` STRING COMMENT 'Two-letter state or province code (e.g., CA for California, ON for Ontario).',
  `time_zone` STRING COMMENT 'IANA time zone identifier for the address location (e.g., America/New_York, America/Los_Angeles). Used for Time of Use (TOU) rate scheduling and Demand Response (DR) event timing.',
  `usps_standardized_address` STRING COMMENT 'USPS-standardized full address string in CASS-certified format for delivery accuracy.',
  `usps_validation_status` STRING COMMENT 'Status of USPS address validation: validated (confirmed by USPS), invalid (rejected by USPS), not_validated (not yet checked), corrected (USPS suggested correction applied), or ambiguous (multiple matches found). Valid values: validated|invalid|not_validated|corrected|ambiguous.',
  `verification_date` DATE COMMENT 'Date when the address was last verified or validated through USPS, field inspection, or customer confirmation.',
  `verification_method` STRING COMMENT 'Method used to verify the address: usps_api (USPS web service), field_inspection (physical site visit), customer_confirmation (customer-provided), gis_validation (GIS system match), or third_party_service (external validation service). Valid values: usps_api|field_inspection|customer_confirmation|gis_validation|third_party_service.',
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
  CONSTRAINT `pk_customer_address` PRIMARY KEY (`address_id`)
)
USING DELTA
COMMENT 'Master entity representing a standardized postal address used for billing, mailing, or service delivery. Captures address line 1 and 2, city, state/province, postal code, country, address type (service, mailing, billing, third-party notification), USPS validation status, USPS standardized form, geocode latitude/longitude, census tract, and address effective date. Supports address normalization and deduplication across CIS and GIS systems. | CMM: CIM StreetAddress (exact), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PostalAddress',
  'cmm.cim.class' = 'StreetAddress',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.address',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- AccountPremiseLink  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `customer`.`account_premise_link` (
  `account_premise_link_id` BIGINT NOT NULL COMMENT 'Unique identifier for the account-premise relationship record. Primary key for the account_premise_link entity.',
  `account_premise_id` BIGINT COMMENT 'Reference to the service premise associated with this account. Links to the premise entity representing the physical service location.',
  `customer_service_agreement_id` BIGINT COMMENT 'Reference to the formal service agreement governing this account-premise relationship. Links to the contract or service agreement entity.',
  `forwarding_address_id` BIGINT COMMENT 'Reference to the forwarding address for final bill delivery and correspondence after account-premise relationship termination. Used in move-out processing.',
  `primary_account_id` BIGINT COMMENT 'Reference to the customer account associated with this premise. Links to the account entity in the Customer Information System (CIS).',
  `primary_account_move_order_id` BIGINT COMMENT 'Reference to the service order that initiated this account-premise relationship. Links to the move-in or service connection order.',
  `tertiary_tenant_account_id` BIGINT COMMENT 'Reference to the tenant account when this link represents a landlord-of-record relationship. Used to track tenant accounts associated with a landlord premise. Null for non-landlord relationships.',
  `to_premise_id` BIGINT COMMENT 'FK to customer.premise.premise_id — The association entity must reference the premise it links. account_premise_link.premise_id → premise.premise_id.',
  `billing_responsibility_flag` BOOLEAN COMMENT 'Indicates whether this account has billing responsibility for the premise. In master-metered or landlord scenarios, multiple accounts may be linked to a premise but only one has billing responsibility.',
  `contact_preference` STRING COMMENT 'Preferred communication channel for outage notifications and service alerts for this account-premise relationship. Used by OMS and customer engagement systems. Valid values: email|sms|phone|mail|mobile_app|none.',
  `deposit_amount` DECIMAL(15,2) COMMENT 'Security deposit amount collected for this account-premise relationship. Null if no deposit was required. Expressed in local currency.',
  `deposit_required_flag` BOOLEAN COMMENT 'Indicates whether a security deposit was required for this account-premise relationship based on credit classification and service territory regulations.',
  `der_enrolled_flag` BOOLEAN COMMENT 'Indicates whether this account-premise relationship is enrolled in a Distributed Energy Resource (DER) program such as demand response, virtual power plant, or distributed generation program.',
  `final_bill_flag` BOOLEAN COMMENT 'Indicates whether a final bill has been issued for this account-premise relationship upon termination. Used in move-out and service disconnection workflows.',
  `link_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this account-premise link record was first created in the Customer Information System (CIS). Used for audit trail and data lineage tracking.',
  `link_end_date` DATE COMMENT 'Date when the account-premise relationship was terminated. Represents move-out date or service disconnection date. Null for active relationships.',
  `link_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this account-premise link record was last modified. Used for audit trail and change tracking in customer relationship management.',
  `link_notes` STRING COMMENT 'Free-text notes and comments regarding this account-premise relationship. Used by customer service representatives to document special circumstances, arrangements, or historical context.',
  `link_start_date` DATE COMMENT 'Date when the account-premise relationship became effective. Represents move-in date or service initiation date for the account at this premise.',
  `link_status` STRING COMMENT 'Current lifecycle status of the account-premise relationship. Indicates whether the link is currently in effect or has been terminated. Valid values: active|inactive|pending|suspended|terminated.',
  `link_termination_reason` STRING COMMENT 'Reason code for termination of the account-premise relationship. Provides business context for why the link was ended. Null for active relationships. Valid values: customer_move_out|service_disconnection|account_closure|property_sale|lease_expiration|death.',
  `link_type` STRING COMMENT 'Classification of the relationship between the account and premise. Defines the role and responsibility of the account holder at the service location. Valid values: primary_service|secondary_service|landlord_of_record|property_manager|master_metered_tenant|billing_contact.',
  `master_metered_flag` BOOLEAN COMMENT 'Indicates whether this relationship involves a master-metered configuration where a single meter serves multiple tenant accounts. Common in multi-family residential and commercial properties.',
  `nem_participant_flag` BOOLEAN COMMENT 'Indicates whether this account-premise relationship involves a Net Energy Metering (NEM) participant with Behind the Meter (BTM) generation. Used to identify customers with distributed energy resources.',
  `notification_authorization_flag` BOOLEAN COMMENT 'Indicates whether the account holder has authorized receipt of outage notifications and service alerts for this premise. Used by Outage Management System (OMS) for customer communication.',
  `occupancy_type` STRING COMMENT 'Classification of the occupancy status for this account-premise relationship. Indicates whether the account holder is an owner, tenant, or if the premise is vacant. Valid values: owner_occupied|tenant_occupied|vacant|seasonal|under_construction.',
  `priority_sequence` INT COMMENT 'Numeric ranking of this account-premise link when multiple accounts are associated with a single premise. Used to determine primary contact for outage notifications and field operations.',
  `property_management_company_code` BIGINT COMMENT 'Reference to the property management company responsible for this premise when the link type is property manager. Used in commercial and multi-family property management scenarios.',
  `source_system` STRING COMMENT 'Identifier of the operational system of record that originated this account-premise link. Used for data lineage and integration troubleshooting. Valid values: SAP_IS_U|ORACLE_CCB|LEGACY_CIS|MANUAL_ENTRY.',
  `source_system_key` STRING COMMENT 'Original primary key or unique identifier from the source system. Used for data reconciliation and bidirectional synchronization with operational systems.',
  `vacancy_billing_flag` BOOLEAN COMMENT 'Indicates whether vacancy billing is active for this account-premise relationship. When true, the landlord or property manager is billed for usage during tenant vacancy periods.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_account_premise_link` PRIMARY KEY (`account_premise_link_id`)
)
USING DELTA
COMMENT 'Association entity and SSOT for all relationships between customer accounts and premises, including active service relationships, landlord-tenant relationships, and property management roles. Stores link start date, link end date, link type (primary service, secondary service, landlord-of-record, property manager, master-metered tenant), landlord account reference, tenant account reference, move-in/move-out order references, vacancy billing flag, notification authorization flag, and link status. Enables historical tracking of which accounts have been served at a given premise, supports premise-to-account resolution for outage notifications and field operations, manages multi-family residential and commercial property management scenarios, and tracks landlord-tenant billing and notification workflows. SSOT for all account-to-premise and landlord-tenant relationship data. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AccountPremiseLink',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.account_premise_link'
);

-- CreditProfile  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `customer`.`credit_profile` (
  `credit_profile_id` BIGINT NOT NULL COMMENT 'Unique identifier for the credit profile record. Primary key for the credit profile entity.',
  `credit_account_id` BIGINT COMMENT 'Reference to the customer account to which this credit profile applies. Links credit assessment to the billing account in CIS (SAP IS-U or Oracle CC&B).',
  `to_account_id` BIGINT COMMENT 'FK to customer.account.account_id — Credit classification is assessed per account. credit_profile.account_id → account.account_id.',
  `average_monthly_payment_amount` DECIMAL(15,2) COMMENT 'Average monthly payment amount over the past 12 months. Used for deposit calculation and payment arrangement sizing.',
  `bankruptcy_discharge_date` DATE COMMENT 'Date the bankruptcy was discharged or dismissed. Credit profile may be eligible for upgrade after discharge and demonstration of payment performance.',
  `bankruptcy_filing_date` DATE COMMENT 'Date of the most recent bankruptcy filing. Used to determine if bankruptcy is still active and impacts credit classification duration.',
  `bankruptcy_flag` BOOLEAN COMMENT 'Indicates whether the customer has an active or recent bankruptcy filing. Impacts collections strategy and may trigger automatic deposit requirement per PUC rules.',
  `broken_arrangement_count` INT COMMENT 'Number of payment arrangements that were broken (customer failed to make scheduled payments). Impacts future payment arrangement eligibility and credit classification.',
  `collections_stage` STRING COMMENT 'Current stage in the collections process for past-due balances. Drives automated dunning notices, disconnection scheduling, and external collections referral. Reference-value candidates: current|reminder|final_notice|disconnection_pending|disconnected|write_off|legal_action.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this credit profile record was first created in the CIS. Required for audit trail and data lineage.',
  `credit_class_code` STRING COMMENT 'Credit classification code assigned to the customer account based on payment history, credit score, and risk assessment. Determines deposit requirements and collection strategies. Valid values: excellent|good|fair|poor|new|unrated.',
  `credit_freeze_flag` BOOLEAN COMMENT 'Indicates whether the customer has placed a credit freeze with the credit bureaus, preventing external credit checks. Requires manual credit assessment process.',
  `credit_limit_amount` DECIMAL(15,2) COMMENT 'Maximum outstanding balance allowed before service disconnection or additional deposit requirement is triggered. Based on credit class and deposit on file.',
  `credit_profile_status` STRING COMMENT 'Current status of the credit profile record. Active profiles are used for deposit and collections decisions; under_review profiles are pending credit reassessment. Valid values: active|inactive|suspended|under_review.',
  `credit_review_date` DATE COMMENT 'Date of the most recent credit review or reassessment. Credit profiles are typically reviewed annually or upon significant payment events (late payments, disconnection, bankruptcy).',
  `credit_score_band` STRING COMMENT 'Credit score range band obtained from external credit bureau (Experian, Equifax, TransUnion). Used for initial credit classification and deposit determination. Valid values: 300-579|580-669|670-739|740-799|800-850|not_available.',
  `deposit_amount` DECIMAL(15,2) COMMENT 'Security deposit amount required from the customer, typically calculated as 2-3 months of estimated billing. Null if no deposit is required.',
  `deposit_required_flag` BOOLEAN COMMENT 'Indicates whether a security deposit is required for this account based on credit classification and PUC regulations.',
  `deposit_type` STRING COMMENT 'Type of security deposit instrument held for the account. Cash deposits are held in trust accounts; surety bonds and letters of credit are third-party guarantees. Valid values: cash|surety_bond|letter_of_credit|guarantee|none.',
  `deposit_waiver_reason` STRING COMMENT 'Reason code for waiving the security deposit requirement. Regulatory exemptions include low-income program enrollment, medical necessity, and senior citizen status per PUC rules. Reference-value candidates: excellent_credit|existing_customer|low_income_program|senior_citizen|medical_necessity|regulatory_exemption|none.',
  `disconnection_history_count` INT COMMENT 'Total number of service disconnections for non-payment in the account history. Indicates chronic payment issues and impacts credit classification.',
  `effective_date` DATE COMMENT 'Date this credit profile became effective. Credit profiles are versioned; this date marks the start of this version\'s validity period.',
  `expiration_date` DATE COMMENT 'Date this credit profile version expires or is superseded by a new version. Null for the current active credit profile.',
  `external_credit_bureau` STRING COMMENT 'Credit bureau used to obtain the credit score and credit report for this customer. Required for FCRA compliance and dispute resolution. Valid values: experian|equifax|transunion|none.',
  `external_credit_check_date` DATE COMMENT 'Date the external credit bureau check was performed. Credit checks are typically performed at account establishment and periodically for high-risk accounts.',
  `highest_past_due_amount` DECIMAL(15,2) COMMENT 'Highest past-due balance amount in the account history. Indicates maximum payment risk exposure and informs deposit amount calculation.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this credit profile record. Tracks credit reassessments, manual overrides, and system updates.',
  `late_payment_count_12m` INT COMMENT 'Number of late payments (payments received after due date) in the rolling 12-month period. Key metric for credit class downgrade and disconnection eligibility.',
  `low_income_program_flag` BOOLEAN COMMENT 'Indicates whether the customer is enrolled in a low-income assistance program (LIHEAP, state-specific programs). Enrollment may waive deposit requirements and provide disconnection protections.',
  `manual_override_by` STRING COMMENT 'User ID or name of the credit management staff member who performed the manual override. Required for audit trail and SOX compliance.',
  `manual_override_date` DATE COMMENT 'Date the manual credit classification override was performed. Required for audit trail and regulatory compliance.',
  `manual_override_flag` BOOLEAN COMMENT 'Indicates whether the credit classification was manually overridden by credit management staff. Overrides require supervisor approval and documented justification.',
  `manual_override_reason` STRING COMMENT 'Free-text justification for manual credit classification override. Required for audit trail and regulatory compliance.',
  `next_review_date` DATE COMMENT 'Scheduled date for the next periodic credit review. Typically set 12 months from the last review date or earlier if triggered by payment issues.',
  `payment_arrangement_count` INT COMMENT 'Total number of payment arrangements or installment plans established for this account. Excessive arrangements may indicate chronic payment issues and impact credit classification.',
  `payment_arrangement_eligible_flag` BOOLEAN COMMENT 'Indicates whether the account is eligible for a payment arrangement or installment plan based on credit class, payment history, and PUC regulations.',
  `returned_payment_count_12m` INT COMMENT 'Number of returned payments (NSF checks, ACH returns, declined credit cards) in the rolling 12-month period. Indicates payment reliability issues and may trigger deposit requirement.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_credit_profile` PRIMARY KEY (`credit_profile_id`)
)
USING DELTA
COMMENT 'Master entity capturing the credit classification and financial risk attributes of a customer account as managed within the CIS. Stores credit class code (excellent, good, fair, poor, new), credit score band, deposit requirement flag, deposit amount, deposit type (cash, surety bond, letter of credit), deposit waiver reason, credit review date, number of late payments in rolling 12 months, disconnection history count, bankruptcy flag, low-income program enrollment flag, and collections stage. Sourced from SAP IS-U FICA credit management and Oracle CC&B credit configuration. Used by billing and collections domains for deposit calculation, disconnection eligibility, and payment arrangement qualification. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CreditProfile',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.credit_profile'
);

-- CustomerSegment  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `customer`.`segment` (
  `segment_id` BIGINT NOT NULL COMMENT 'Primary key for segment',
  `account_id` BIGINT COMMENT 'FK to customer.account.account_id — Segments classify accounts for rate design, DR targeting, and regulatory reporting. Required for tariff application and program eligibility determination. Note: this may be a many-to-many via an impli',
  `planning_assumption_id` BIGINT COMMENT 'Foreign key linking to forecast.planning_assumption. Business justification: Customer segments (residential, commercial, industrial) are the foundation for load growth assumptions in IRP filings and long-term planning. Regulatory filings require traceability from segment chara',
  `account_count` INT COMMENT 'Current number of active customer accounts assigned to this segment. Updated periodically from CIS systems for segment size tracking and program capacity planning.',
  `ami_penetration_flag` BOOLEAN COMMENT 'Indicates whether this segment has significant AMI (Advanced Metering Infrastructure) deployment, enabling interval data collection and time-of-use rate programs. True if AMI penetration exceeds utility-defined threshold (typically 75%+).',
  `annual_energy_sales_mwh` DECIMAL(18,2) COMMENT 'Total annual energy sales in megawatt-hours for all accounts in this segment. Key metric for load forecasting, resource planning (IRP), and regulatory sales reporting.',
  `annual_revenue_usd` DECIMAL(18,2) COMMENT 'Total annual billed revenue in US dollars for all accounts in this segment. Used for revenue forecasting, rate design impact analysis, and regulatory reporting. Aggregated from billing system revenue data.',
  `average_monthly_consumption_kwh` DECIMAL(12,2) COMMENT 'Typical average monthly electricity consumption in kilowatt-hours for accounts in this segment. Used for load forecasting, rate design analysis, and program targeting. Calculated from historical MDM interval and register data.',
  `average_peak_demand_kw` DECIMAL(12,2) COMMENT 'Typical peak demand in kilowatts for accounts in this segment. Relevant for commercial and industrial segments with demand-based rate components. Null for residential segments without demand metering.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this segment classification record was first created in the system. Supports audit trail and data lineage tracking.',
  `credit_risk_tier` STRING COMMENT 'Aggregate credit risk classification for accounts in this segment based on historical payment performance, deposit requirements, and collections activity. Used for deposit policy and collections strategy segmentation. Valid values: low|medium|high|very_high.',
  `critical_infrastructure_flag` BOOLEAN COMMENT 'Indicates whether this segment includes critical infrastructure customers (hospitals, emergency services, water treatment) requiring priority restoration during outages and enhanced service reliability.',
  `demand_response_eligible_flag` BOOLEAN COMMENT 'Indicates whether accounts in this segment are eligible for demand response programs (CPP, TOU, direct load control). Eligibility based on load characteristics, metering capability, and regulatory program rules.',
  `der_adoption_flag` BOOLEAN COMMENT 'Indicates whether this segment has notable DER (Distributed Energy Resource) adoption including solar PV, battery storage, or other behind-the-meter generation. Used to identify segments eligible for NEM (Net Energy Metering) and interconnection programs.',
  `effective_end_date` DATE COMMENT 'Date when this segment classification expires or is superseded. Null for currently active segments. Supports historical segment analysis and regulatory reporting for prior periods.',
  `effective_start_date` DATE COMMENT 'Date when this segment classification becomes effective for customer account assignment and rate application. Supports temporal segmentation changes driven by rate case approvals or program launches.',
  `ev_ownership_flag` BOOLEAN COMMENT 'Indicates whether this segment has significant electric vehicle ownership, making them candidates for EV-specific time-of-use rates and managed charging programs.',
  `interruptible_service_flag` BOOLEAN COMMENT 'Indicates whether accounts in this segment are on interruptible rate schedules, allowing the utility to curtail service during peak demand or emergency conditions in exchange for discounted rates.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this segment classification record was last updated. Tracks changes to segment definitions, eligibility rules, or statistical attributes.',
  `load_factor_percent` DECIMAL(5,2) COMMENT 'Average load factor (ratio of average load to peak load) for this segment, expressed as percentage. Indicates load shape characteristics and efficiency of capacity utilization. Higher values indicate flatter, more efficient load profiles.',
  `load_profile_class` STRING COMMENT 'Load profile classification code used for non-interval meter customers to estimate hourly consumption patterns. References standard load shapes maintained in MDM systems for settlement and forecasting purposes. Pattern: ^[A-Z0-9_]{1,10}$.',
  `low_income_flag` BOOLEAN COMMENT 'Indicates whether this segment represents low-income customers eligible for special rate assistance programs, payment plans, or energy efficiency subsidies as defined by state PUC income thresholds.',
  `marketing_program_eligibility` STRING COMMENT 'Comma-separated list of marketing and customer program codes that accounts in this segment are eligible for (e.g., energy efficiency rebates, solar incentives, EV charging programs). Used for targeted campaign management.',
  `net_metering_eligible_flag` BOOLEAN COMMENT 'Indicates whether accounts in this segment are eligible for NEM (Net Energy Metering) programs allowing customer-owned generation to offset consumption. Subject to state interconnection rules and capacity caps.',
  `rate_schedule_category` STRING COMMENT 'High-level rate schedule category that this segment typically maps to for tariff application. Used by billing systems to determine applicable rate structures and riders. Reference-value candidates: residential|general_service|large_power|industrial|agricultural|municipal|lighting|standby|interruptible.',
  `regulatory_reporting_class` STRING COMMENT 'Standardized customer class code used for FERC Form 1, EIA-861, and state PUC regulatory reporting. Maps segment to required reporting categories for revenue, sales, and customer count statistics. Pattern: ^[A-Z0-9_]{1,20}$.',
  `rps_eligible_flag` BOOLEAN COMMENT 'Indicates whether accounts in this segment are subject to state RPS (Renewable Portfolio Standard) requirements or eligible for voluntary green power programs. Used for renewable energy allocation and REC (Renewable Energy Certificate) tracking.',
  `seasonal_variation_flag` BOOLEAN COMMENT 'Indicates whether this segment exhibits significant seasonal consumption variation (e.g., residential cooling load in summer, agricultural irrigation in growing season). Used for seasonal rate design and forecasting adjustments.',
  `segment_code` STRING COMMENT 'Short alphanumeric code uniquely identifying the segment classification (e.g., RES_LOW, COM_MED, IND_LARGE). Used as business identifier in CIS systems (SAP IS-U, Oracle CC&B) for rate schedule assignment and regulatory reporting. Pattern: ^[A-Z0-9_]{2,20}$.',
  `segment_description` STRING COMMENT 'Detailed business description of the segment characteristics, typical customer profiles, usage patterns, and program applicability. Provides context for business users and supports segment definition documentation.',
  `segment_name` STRING COMMENT 'Full descriptive name of the customer segment (e.g., Residential Low-Use, Small Commercial, Large Industrial). Human-readable label for business users and customer-facing communications.',
  `segment_status` STRING COMMENT 'Current lifecycle status of the segment classification. Active segments are available for customer assignment; pending segments await regulatory approval; retired segments are maintained for historical reporting only. Valid values: active|inactive|pending|retired.',
  `segment_tier` STRING COMMENT 'Primary market segmentation tier defining the customer class and usage profile. Drives rate schedule eligibility, demand response program targeting, and regulatory reporting breakdowns for FERC and state PUC filings. Reference-value candidates: residential_low_use|residential_high_use|small_commercial|medium_commercial|large_commercial|industrial|agricultural|municipal|street_lighting|other.',
  `service_territory_code` STRING COMMENT 'Geographic service territory or operating division code where this segment classification applies. Supports multi-jurisdiction utilities with territory-specific segmentation rules. Pattern: ^[A-Z0-9_]{2,10}$.',
  `source_system` STRING COMMENT 'Operational system of record that originated or maintains this segment classification (e.g., SAP IS-U, Oracle CC&B, custom segmentation engine). Supports data lineage and reconciliation. Valid values: SAP_ISU|ORACLE_CCB|MDM|CUSTOM|MANUAL.',
  `time_of_use_eligible_flag` BOOLEAN COMMENT 'Indicates whether accounts in this segment are eligible for TOU (Time of Use) rate schedules with differentiated pricing by time period. Requires AMI metering capability and regulatory approval.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_segment` PRIMARY KEY (`segment_id`)
)
USING DELTA
COMMENT 'Reference entity defining market segmentation classifications applied to customer accounts for rate design, demand response targeting, regulatory reporting, and marketing programs. Captures segment code, segment name, segment tier (residential low-use, residential high-use, small commercial, medium commercial, large commercial, industrial, agricultural, municipal), load profile class, AMI penetration flag, DER adoption flag, EV ownership flag, segment effective date, and segment expiration date. Used by billing, demand response, and regulatory reporting domains to classify accounts for tariff application, program eligibility, and FERC/PUC reporting breakdowns. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CustomerSegment',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'reference_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.segment'
);

-- CustomerServiceRequest  <<CIM Request : close>>
CREATE TABLE IF NOT EXISTS `customer`.`customer_service_request` (
  `customer_service_request_id` BIGINT NOT NULL COMMENT 'Unique identifier for the service request. Primary key for the service request entity.',
  `account_id` BIGINT COMMENT 'Reference to the customer account associated with this service request. Links to the account master data in CIS.',
  `contact_id` BIGINT COMMENT 'Foreign key linking to customer.contact. Business justification: Service request has embedded contact fields (contact_name, contact_phone, contact_email) that should be normalized to reference the contact table. This establishes which contact point the service requ',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Service request costs (labor, materials, vehicle) are allocated to cost centers for activity-based costing and budget tracking. Essential for field service cost management and variance analysis. Real',
  `customer_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.customer_service_agreement. Business justification: Service request should reference the specific service agreement it pertains to. Currently service_request has account_id and premise_id but no service_agreement_id. This FK establishes which service a',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: Service requests for DER installation, maintenance, inspection, and troubleshooting require direct linkage to the specific DER asset for work order management, compliance tracking, and customer servic',
  `distribution_transformer_id` BIGINT COMMENT 'Foreign key linking to distribution.transformer. Business justification: Transformer-specific service requests (load investigations, failure analysis, maintenance) require direct transformer reference for asset work order integration, capacity planning, and reliability tra',
  `ems_alarm_id` BIGINT COMMENT 'Foreign key linking to grid.ems_alarm. Business justification: Service requests for voltage issues, power quality problems, or outage inquiries often originate from specific EMS alarms. Links customer-facing operations to grid operations for root cause analysis a',
  `feeder_id` BIGINT COMMENT 'Foreign key linking to distribution.feeder. Business justification: Field service dispatch and crew routing require direct feeder context for switching order coordination, outage correlation, and SCADA-based fault location. Feeder-level assignment is operationally dis',
  `interconnection_application_id` BIGINT COMMENT 'Foreign key linking to interconnection.application. Business justification: Service requests for DER system modifications, disconnections, export limit changes, or metering troubleshooting must reference the interconnection application for system specifications, approval hist',
  `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Field service work orders often collect costs via internal orders before settlement to assets (capitalized) or expense accounts. Critical for capital vs. expense classification and work order costing.',
  `meter_id` BIGINT COMMENT 'Foreign key linking to metering.meter. Business justification: Field service requests for meter testing, replacement, or investigation require direct meter reference. Supports work order dispatch, asset lifecycle management, and customer complaint resolution work',
  `premise_id` BIGINT COMMENT 'Reference to the service premise where the requested service will be performed. Links to premise master data.',
  `registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: Service requests often target specific customer-visible assets (streetlight, meter socket, service drop, pole guy wire). Essential for field service dispatch, asset maintenance triggering, and custome',
  `warehouse_id` BIGINT COMMENT 'Foreign key linking to supply.warehouse. Business justification: Field service requests require material dispatch from specific warehouses for repairs, installations, and maintenance. Operations teams need to track which warehouse fulfilled material requirements fo',
  `work_order_id` BIGINT COMMENT 'Reference to the field work order created to fulfill this service request. Links to work management system for field execution tracking.',
  `actual_cost` DECIMAL(15,2) COMMENT 'Actual cost incurred to complete the service request. Populated after work completion for cost tracking and billing.',
  `appointment_required_flag` BOOLEAN COMMENT 'Indicates whether the service request requires scheduling a customer appointment for premise access. True for inside-meter work.',
  `appointment_window_end` TIMESTAMP COMMENT 'End of the scheduled appointment window for customer availability. Defines the time range for field technician arrival.',
  `appointment_window_start` TIMESTAMP COMMENT 'Start of the scheduled appointment window for customer availability. Used for field dispatch coordination.',
  `assigned_to` STRING COMMENT 'Name or identifier of the CSR, team, or field technician assigned to handle this service request.',
  `billable_flag` BOOLEAN COMMENT 'Indicates whether the service request will result in a charge to the customer. True for billable services, false for no-charge requests.',
  `cancellation_reason` STRING COMMENT 'Reason code or description explaining why the service request was cancelled. Null for non-cancelled requests.',
  `completed_date` DATE COMMENT 'Date when the service request was fully resolved and closed. Null for requests still in progress.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this service request record was first created in the lakehouse silver layer. Audit trail for data ingestion.',
  `customer_satisfaction_score` INT COMMENT 'Customer satisfaction rating provided after service completion, typically on a 1-5 or 1-10 scale. Used for CRM and quality tracking.',
  `estimated_cost` DECIMAL(15,2) COMMENT 'Estimated cost to fulfill the service request, including labor, materials, and equipment. Used for customer notification and approval.',
  `priority` STRING COMMENT 'Priority level assigned to the service request based on urgency, customer class, or regulatory requirements. Drives work order scheduling. Valid values: emergency|high|normal|low.',
  `request_channel` STRING COMMENT 'Channel through which the customer initiated the service request. Tracks customer engagement interface for multi-channel analytics. Valid values: web|mobile_app|ivr|call_center|walk_in|email.',
  `request_date` DATE COMMENT 'Date when the service request was submitted by the customer or created in the CIS system.',
  `request_description` STRING COMMENT 'Detailed description of the service request provided by the customer or CSR. Free-text field capturing specific customer needs or issues.',
  `request_number` STRING COMMENT 'Business-facing unique identifier for the service request, displayed to customers and CSRs. Externally visible request tracking number.',
  `request_status` STRING COMMENT 'Current lifecycle status of the service request. Tracks progression from initiation through resolution or cancellation. Valid values: pending|in_progress|completed|cancelled|on_hold|rejected.',
  `request_timestamp` TIMESTAMP COMMENT 'Precise date and time when the service request was created in the system. Principal business event timestamp for the transaction.',
  `request_type` STRING COMMENT 'Category of service request initiated by the customer. Defines the nature of the requested action or inquiry. Reference-value candidates: start_service|stop_service|transfer_service|meter_reread|high_bill_inquiry|payment_arrangement|medical_baseline|der_interconnection|service_upgrade|outage_report|billing_dispute|name_change|other.',
  `requested_effective_date` DATE COMMENT 'Date requested by the customer for the service action to take effect. For start/stop/transfer requests, this is the desired service date.',
  `resolution_notes` STRING COMMENT 'Notes documenting how the service request was resolved, actions taken, or reasons for cancellation. Populated upon request closure.',
  `scheduled_date` DATE COMMENT 'Date scheduled by the utility for field work or service action. May differ from requested effective date based on operational constraints.',
  `sla_met_flag` BOOLEAN COMMENT 'Indicates whether the service request was completed within the SLA target timeframe. Used for performance reporting.',
  `sla_target_hours` INT COMMENT 'Target number of hours for service request resolution as defined by utility SLA or regulatory requirements.',
  `source_system` STRING COMMENT 'Originating system that created the service request record. Identifies the CIS or channel system of record. Valid values: oracle_ccb|sap_isu|mobile_app|ivr|web_portal|call_center.',
  `source_system_code` STRING COMMENT 'Unique identifier of the service request in the source system. Used for data lineage and reconciliation.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this service request record was last modified in the lakehouse silver layer. Tracks data refresh cycles.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_customer_service_request` PRIMARY KEY (`customer_service_request_id`)
)
USING DELTA
COMMENT 'Transactional entity capturing customer-initiated service requests processed through CIS channels including start service, stop service, transfer service, meter re-read, high bill inquiry, payment arrangement request, medical baseline application, and DER interconnection inquiry. Stores request type, request channel (web, IVR, call center, mobile app, walk-in), request date and time, requested effective date, assigned work order reference, resolution status, resolution date, and resolution notes. Sourced from Oracle CC&B Service Request and SAP IS-U Service Order. | CMM: CIM Request (close), IEC61968::InfWork.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CustomerServiceRequest',
  'cmm.cim.class' = 'Request',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfWork',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-6',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.customer_service_request'
);

-- CustomerInteraction  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `customer`.`interaction` (
  `interaction_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for each customer interaction record in the CIS/CRM platform. Primary key for the interaction entity.',
  `case_id` BIGINT COMMENT 'Reference to the CRM case or service request created or updated as a result of this interaction. Nullable when the interaction does not generate a case.',
  `complaint_id` BIGINT COMMENT 'Foreign key linking to customer.complaint. Business justification: Interaction currently has complaint_flag (BOOLEAN) and regulatory_complaint_reference (STRING) which are denormalized. This should be replaced with a proper FK to complaint. Many interactions can refe',
  `customer_service_request_id` BIGINT COMMENT 'Foreign key linking to customer.service_request. Business justification: Interaction currently has service_request_number (STRING) which is a denormalized reference. This should be replaced with a proper FK to service_request. Many interactions can reference one service re',
  `employee_id` BIGINT COMMENT 'Reference to the customer service representative or agent who handled this interaction. Null for fully automated IVR or self-service interactions.',
  `event_id` BIGINT COMMENT 'Foreign key linking to outage.outage_event. Business justification: Contact centers link customer service interactions to specific outage events for ETR inquiries, complaint tracking, and regulatory reporting on outage communication quality. The existing outage_event_',
  `interaction_account_id` BIGINT COMMENT 'Reference to the utility service account associated with this interaction. A customer may have multiple accounts (residential, commercial, NEM/BTM). Links to the account master.',
  `profile_id` BIGINT COMMENT 'Reference to the customer who initiated or was the subject of this interaction. Links to the customer master record in the Customer Information System (CIS).',
  `to_account_id` BIGINT COMMENT 'FK to customer.account.account_id — Customer interactions are associated with an account for CRM tracking. interaction.account_id → account.account_id.',
  `agent_queue` STRING COMMENT 'The call center queue or skill group to which this interaction was routed (e.g., \'billing\', \'technical_support\', \'collections\', \'spanish_language\', \'commercial_accounts\'). Used for workforce management and routing optimization analytics.',
  `callback_scheduled_timestamp` TIMESTAMP COMMENT 'Date and time scheduled for a return call to the customer when interaction_outcome is \'callback_scheduled\'. Null when no callback was arranged.',
  `channel_type` STRING COMMENT 'The communication channel through which the customer interaction occurred. Supports omni-channel CRM analytics and channel cost allocation. IVR (Interactive Voice Response) interactions are self-service completions without agent involvement. Reference-value candidates: inbound_call|outbound_call|web_chat|email|ivr|mobile_app|in_person.',
  `complaint_flag` BOOLEAN COMMENT 'Indicates whether this interaction was classified as a formal customer complaint. True = complaint. Drives regulatory complaint tracking and reporting to State Public Utility Commissions (PUCs) as required by retail rate regulation.',
  `contact_center_site` STRING COMMENT 'Identifier for the physical or virtual contact center site that handled this interaction (e.g., \'Phoenix_AZ\', \'Virtual_Home_Agent\', \'Offshore_Partner_Manila\'). Supports site-level performance benchmarking and cost allocation.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this interaction record was first created in the source CIS/CRM system. Serves as the audit creation timestamp for data lineage and Silver layer ingestion tracking.',
  `customer_satisfaction_score` INT COMMENT 'Post-interaction customer satisfaction score collected via IVR survey, email survey, or SMS (typically 1–5 scale). Null when no survey response was received. Supports CRM analytics and PUC service quality reporting.',
  `demand_response_enrollment_flag` BOOLEAN COMMENT 'Indicates whether the customer enrolled in or modified a Demand Response (DR) or energy efficiency program during this interaction. True = DR enrollment action taken. Supports DERMS integration and regulatory DR program reporting.',
  `direction` STRING COMMENT 'Indicates whether the interaction was initiated by the customer (inbound) or by the utility (outbound, e.g., proactive outage notification, collections call, demand response enrollment outreach). Valid values: inbound|outbound.',
  `duration_seconds` INT COMMENT 'Total elapsed time of the interaction in seconds from start to end. For calls, this is the total call handle time including hold time. Used for SLA compliance measurement and workforce management analytics.',
  `end_timestamp` TIMESTAMP COMMENT 'Date and time when the customer interaction concluded (call disconnected, chat session closed, email response sent, visit ended). Used to compute handle time and duration metrics.',
  `escalation_flag` BOOLEAN COMMENT 'Indicates whether this interaction was escalated to a supervisor, specialist team, or regulatory complaint handler during or after the session. True = escalated. Supports regulatory complaint tracking required by PUC reporting.',
  `escalation_reason` STRING COMMENT 'Free-text or coded reason for escalation when escalation_flag is True (e.g., \'customer_requested_supervisor\', \'regulatory_complaint\', \'unresolved_billing_dispute\'). Required for PUC complaint tracking and quality assurance.',
  `first_contact_resolution_flag` BOOLEAN COMMENT 'Indicates whether the customer\'s issue was fully resolved during this single interaction without requiring a follow-up contact. True = resolved at first contact. Key CRM KPI and PUC service quality metric.',
  `hold_duration_seconds` INT COMMENT 'Total time in seconds the customer was placed on hold during a call interaction. Contributes to customer experience scoring and agent performance metrics. Applicable primarily to inbound and outbound call channels.',
  `interaction_category` STRING COMMENT 'High-level business category classifying the primary purpose of the interaction. \'outage_report\' links to OMS event tracking. \'meter_inquiry\' relates to AMI/MDM data. \'billing_inquiry\' is the most frequent category in utility CRM. Reference-value candidates: billing_inquiry|outage_report|payment|complaint|general_inquiry|service_request|meter_inquiry|demand_response|new_service|disconnect_request.',
  `interaction_date` DATE COMMENT 'Calendar date on which the interaction occurred, derived from interaction_start_timestamp. Stored as a separate DATE field to support efficient date-partitioned queries, daily reporting, and regulatory complaint date tracking.',
  `interaction_status` STRING COMMENT 'Current lifecycle status of the interaction record. \'abandoned\' applies to IVR or chat sessions where the customer disconnected before resolution. \'escalated\' indicates transfer to a higher-tier agent or supervisor. Valid values: open|in_progress|completed|abandoned|escalated|cancelled.',
  `ivr_containment_flag` BOOLEAN COMMENT 'Indicates whether the customer\'s need was fully resolved within the IVR self-service system without requiring transfer to a live agent. True = IVR-contained; False = transferred to agent or unresolved. Key metric for IVR optimization and cost-to-serve analysis.',
  `ivr_menu_path` STRING COMMENT 'Sequence of IVR menu selections made by the customer during the interaction (e.g., \'1>3>2\' representing the menu tree traversal). Used for IVR design optimization and self-service analytics.',
  `language_code` STRING COMMENT 'ISO 639-1 language code for the language used during the interaction (e.g., \'en\', \'es\', \'zh-TW\'). Supports multilingual service analytics and compliance with state language access requirements for utility customers. Pattern: ^[a-z]{2}(-[A-Z]{2})?$.',
  `nem_inquiry_flag` BOOLEAN COMMENT 'Indicates whether this interaction involved a Net Energy Metering (NEM) inquiry, application, or billing question related to a customer\'s behind-the-meter (BTM) distributed energy resource (DER) such as rooftop solar. Supports NEM program analytics.',
  `notes` STRING COMMENT 'Free-text notes entered by the agent summarizing the interaction, customer concerns, actions taken, and follow-up commitments. Confidential as may contain sensitive account or personal context. Stored in Oracle CC&B or SAP IS-U CRM activity log.',
  `outcome` STRING COMMENT 'The result or disposition of the interaction at its conclusion. \'follow_up_required\' triggers a subsequent outbound contact. \'callback_scheduled\' indicates a scheduled return call was arranged. Used for first-contact resolution (FCR) measurement. Valid values: resolved|unresolved|follow_up_required|escalated|callback_scheduled.',
  `payment_arrangement_flag` BOOLEAN COMMENT 'Indicates whether a payment arrangement or deferred payment plan was established during this interaction. True = payment arrangement created. Supports collections analytics and FICA (Financial Customer Accounting) integration in SAP IS-U.',
  `reference_number` STRING COMMENT 'Externally visible alphanumeric reference number assigned to this interaction, communicated to the customer as a confirmation or tracking number (e.g., from Oracle CC&B or SAP IS-U interaction log).',
  `sentiment_classification` STRING COMMENT 'Customer sentiment assessed during or after the interaction, derived from speech analytics, text analysis, or agent classification. Supports CRM analytics, churn risk modeling, and regulatory complaint identification. \'highly_negative\' may trigger proactive follow-up. Valid values: positive|neutral|negative|highly_negative.',
  `source_system_code` STRING COMMENT 'Code identifying the operational system of record from which this interaction record originated (e.g., SAP IS-U CRM, Oracle CC&B, Genesys telephony platform). Supports data lineage and Silver layer reconciliation. Valid values: SAP_ISU|ORACLE_CCB|SALESFORCE|GENESYS|AVAYA|MANUAL.',
  `source_system_interaction_reference` STRING COMMENT 'The native interaction identifier from the originating source system (e.g., Oracle CC&B interaction log ID, SAP IS-U activity number, Genesys call GUID). Enables traceability back to the system of record for audit and reconciliation.',
  `start_timestamp` TIMESTAMP COMMENT 'Date and time when the customer interaction began (call connected, chat session opened, email received, in-person visit commenced). Principal business event timestamp per TRANSACTION_HEADER role. Stored in ISO 8601 format yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `subcategory` STRING COMMENT 'Granular sub-classification of the interaction within its category (e.g., \'high_bill_dispute\' under billing_inquiry, \'payment_arrangement\' under payment, \'tree_contact\' under outage_report). Supports root-cause analytics and agent training.',
  `survey_response_flag` BOOLEAN COMMENT 'Indicates whether the customer completed a post-interaction satisfaction survey. True = survey completed. Used to calculate survey response rates and validate CSAT score population.',
  `tou_rate_inquiry_flag` BOOLEAN COMMENT 'Indicates whether the interaction involved a Time-of-Use (TOU) or Critical Peak Pricing (CPP) rate plan inquiry, enrollment, or change request. Supports rate analytics and AMI-enabled pricing program adoption tracking.',
  `transfer_count` INT COMMENT 'Number of times the interaction was transferred between agents, queues, or departments during a single session. High transfer counts indicate routing inefficiency and negatively impact customer satisfaction scores.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this interaction record in the source system. Used for incremental data pipeline processing and audit trail compliance.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_interaction` PRIMARY KEY (`interaction_id`)
)
USING DELTA
COMMENT 'Transactional entity capturing all multi-channel customer engagement interactions including inbound calls, outbound calls, web chat sessions, email exchanges, IVR self-service completions, mobile app sessions, and in-person visits. Stores interaction date and time, channel type, interaction category (billing inquiry, outage report, payment, complaint, general inquiry), agent ID, call duration, IVR containment flag, sentiment classification, case reference, and interaction outcome. Supports CRM analytics and regulatory complaint tracking. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CustomerInteraction',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.interaction'
);

-- CustomerComplaint  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `customer`.`complaint` (
  `complaint_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for each formal customer complaint record in the Customer Information System (CIS). Primary key for the complaint data product.',
  `complaint_account_id` BIGINT COMMENT 'Reference to the utility service account associated with the complaint. A customer may have multiple accounts; this identifies the specific account under dispute.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Complaint resolution costs (investigation time, remediation work, customer credits) are allocated to cost centers for cost-of-quality tracking and regulatory compliance reporting. Real business proces',
  `customer_service_agreement_id` BIGINT COMMENT 'Reference to the specific service agreement (rate schedule, tariff contract, or NEM agreement) under which the complaint arises. Relevant for rate dispute, NEM, and DER-related complaints.',
  `der_registry_id` BIGINT COMMENT 'Foreign key linking to renewable.der_registry. Business justification: Complaints about DER performance, interconnection issues, NEM billing disputes, or export credit discrepancies require tracking the specific DER asset for root cause analysis, regulatory reporting, an',
  `employee_id` BIGINT COMMENT 'Reference to the internal employee or team responsible for resolving the complaint. Used for workload management, SLA accountability, and performance reporting.',
  `ems_alarm_id` BIGINT COMMENT 'Foreign key linking to grid.ems_alarm. Business justification: Customer complaints about power quality, voltage sags, or flickering frequently reference specific EMS alarms. Essential for root cause investigation, regulatory response documentation, and PUC case e',
  `event_id` BIGINT COMMENT 'Reference to the outage event in the Outage Management System (OMS) that is the subject of or contributed to the complaint. Populated for outage_response and service_quality complaint types to enable cross-domain analysis.',
  `feeder_id` BIGINT COMMENT 'Foreign key linking to distribution.feeder. Business justification: Power quality complaints, voltage deviation issues, and outage-related complaints are investigated and resolved at feeder level. Direct feeder link supports reliability root cause analysis, SAIDI/SAIF',
  `grid_reliability_event_id` BIGINT COMMENT 'Foreign key linking to grid.grid_reliability_event. Business justification: Formal customer complaints reference NERC-reportable reliability events for regulatory filings, customer communication, and claims processing. Direct operational link required for OE-417 reporting and',
  `interconnection_application_id` BIGINT COMMENT 'Foreign key linking to interconnection.application. Business justification: Complaints about interconnection process delays, queue position disputes, export limitations, or metering accuracy must reference the specific application for regulatory reporting (PUC case tracking)',
  `meter_id` BIGINT COMMENT 'Reference to the Advanced Metering Infrastructure (AMI) meter associated with the complaint. Populated for meter accuracy, estimated read, or AMI-related complaints to enable cross-domain investigation with the MDM system.',
  `premise_id` BIGINT COMMENT 'Reference to the service premise (physical location) related to the complaint, such as the address experiencing a service quality issue or outage-related grievance.',
  `prior_complaint_id` BIGINT COMMENT 'Reference to the most recent prior complaint from the same customer on the same issue, when is_repeat_complaint is true. Enables complaint chain analysis and chronic issue identification.',
  `profile_id` BIGINT COMMENT 'Reference to the customer who filed the complaint. Links to the customer master record in the CIS (SAP IS-U or Oracle CC&B).',
  `registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: Customer complaints frequently reference specific problematic assets (noisy transformer, leaning pole, damaged streetlight). Critical for asset condition monitoring, failure pattern analysis, and regu',
  `to_account_id` BIGINT COMMENT 'FK to customer.account.account_id — Complaints are filed by/about a customer account. complaint.account_id → account.account_id. Required for PUC regulatory reporting.',
  `assigned_department` STRING COMMENT 'Name or code of the internal department or business unit assigned ownership of the complaint resolution (e.g., Customer Service, Billing, Regulatory Affairs, Field Operations).',
  `billing_dispute_amount` DECIMAL(15,2) COMMENT 'Monetary amount in dispute for billing-related complaints, expressed in the local currency (USD). Populated only when complaint_type is billing_dispute or rate_dispute. Used for financial impact analysis and regulatory reporting on disputed revenue.',
  `complaint_description` STRING COMMENT 'Full narrative text of the complaint as submitted by the customer or regulatory body. Contains the customer\'s account of the issue, relevant dates, and requested remedy. Treated as confidential due to potential inclusion of sensitive account details.',
  `complaint_number` STRING COMMENT 'Externally visible, human-readable complaint reference number assigned at intake. Used in all customer-facing correspondence, regulatory filings, and PUC/PSC docket cross-references. Format: CMP-YYYY-NNNNNNN. Pattern: ^CMP-[0-9]{4}-[0-9]{7}$.',
  `complaint_source` STRING COMMENT 'Channel or originating party through which the complaint was received. Distinguishes internally filed complaints from those escalated via regulatory bodies (PUC referral), third-party mediators (BBB), or legislative offices. Valid values: customer_direct|puc_referral|bbb|social_media|legislative_inquiry|ombudsman.',
  `complaint_status` STRING COMMENT 'Current lifecycle state of the complaint within the resolution workflow. Drives SLA monitoring, regulatory reporting, and workload management for the customer service and regulatory affairs teams. Reference-value candidates: open|under_review|pending_customer|escalated|resolved|closed|withdrawn.',
  `complaint_type` STRING COMMENT 'Primary classification of the complaint subject matter. Drives routing, regulatory reporting, and resolution workflow. Reference-value candidates: billing_dispute|service_quality|outage_response|disconnection|rate_dispute|discrimination|safety|meter_accuracy|net_energy_metering|demand_response|deposit_dispute|other.',
  `contact_channel` STRING COMMENT 'Channel through which the customer submitted the complaint to the utility (distinct from complaint_source which identifies the originating party). Used for multi-channel engagement analytics and CRM reporting. Valid values: phone|email|web_portal|in_person|mail|mobile_app.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the complaint record was first created in the CIS or data platform. Audit trail field for data lineage and SOX internal controls. Distinct from filed_timestamp which captures the business event time.',
  `credit_issued_amount` DECIMAL(15,2) COMMENT 'Monetary credit applied to the customer\'s account as part of the complaint resolution, expressed in USD. Tracks financial remedies granted to customers and supports revenue adjustment reporting and SOX controls.',
  `customer_satisfaction_outcome` STRING COMMENT 'Categorical outcome of the customer\'s satisfaction assessment following complaint resolution. Derived from post-resolution survey or follow-up contact. Complements the numeric satisfaction score for reporting and segmentation. Valid values: satisfied|neutral|dissatisfied|no_response.',
  `customer_satisfaction_score` INT COMMENT 'Post-resolution satisfaction rating provided by the customer, typically on a 1–5 or 1–10 scale. Captured via follow-up survey after complaint closure. Used for service quality analytics and CRM performance reporting.',
  `customer_segment` STRING COMMENT 'Classification of the customer\'s service segment at the time of complaint filing. Used for regulatory reporting breakdowns (e.g., low-income customer complaints, NEM participant disputes) and service quality analytics by segment. Valid values: residential|commercial|industrial|nem_participant|der_enrolled|low_income.',
  `escalation_tier` STRING COMMENT 'Escalation level of the complaint within the internal resolution hierarchy. Tier 1 is front-line customer service; Tier 2 is supervisor/specialist; Tier 3 is executive or legal; Regulatory indicates PUC/PSC or FERC involvement. Valid values: tier_1|tier_2|tier_3|regulatory.',
  `filed_timestamp` TIMESTAMP COMMENT 'Date and time when the complaint was formally received and logged in the CIS. This is the principal business event timestamp used to calculate regulatory response deadlines and SLA compliance.',
  `first_response_timestamp` TIMESTAMP COMMENT 'Date and time when the utility first acknowledged or responded to the complaint. Used to measure initial response time against regulatory and SLA targets.',
  `is_regulatory_formal` BOOLEAN COMMENT 'Indicates whether the complaint has been formally filed with or referred by a regulatory authority (PUC, PSC, FERC). Formal regulatory complaints trigger mandatory response timelines and are included in regulatory reporting submissions.',
  `is_repeat_complaint` BOOLEAN COMMENT 'Indicates whether this complaint is a repeat filing by the same customer for the same or substantially similar issue within a defined lookback period. Used to identify chronic service failures and customers at risk of regulatory escalation.',
  `is_safety_related` BOOLEAN COMMENT 'Indicates whether the complaint involves a safety concern (e.g., downed power lines, gas leak, electrical hazard, unsafe disconnection). Safety-related complaints require immediate escalation and are subject to OSHA and NERC CIP reporting obligations.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the complaint record in the CIS or data platform. Used for incremental data pipeline processing, audit trails, and SOX internal controls.',
  `notes` STRING COMMENT 'Free-text field for internal case notes, follow-up actions, and investigative findings recorded by the assigned resolution owner throughout the complaint lifecycle. Not shared externally.',
  `priority` STRING COMMENT 'Business priority assigned to the complaint based on regulatory sensitivity, safety risk, customer segment, or escalation source. Drives SLA response time targets and resource allocation. Valid values: low|medium|high|critical.',
  `puc_case_reference` STRING COMMENT 'Official case or docket number assigned by the state Public Utility Commission (PUC) or Public Service Commission (PSC) when the complaint is filed through or referred to the regulatory body. Required for regulatory reporting and docket tracking.',
  `regulatory_docket_number` STRING COMMENT 'Formal docket or proceeding number assigned by FERC, state PUC/PSC, or other regulatory authority for complaints that escalate to formal regulatory proceedings. Distinct from the PUC case reference which may be an informal tracking number.',
  `regulatory_jurisdiction` STRING COMMENT 'State or federal regulatory jurisdiction governing the complaint (e.g., state abbreviation for PUC/PSC jurisdiction, or \'FERC\' for federal wholesale market complaints). Required for multi-state utility regulatory reporting segmentation.',
  `resolution_description` STRING COMMENT 'Narrative explanation of the actions taken and outcome achieved to resolve the complaint. Documents the remedy offered, root cause identified, and any corrective actions applied to the customer\'s account or service.',
  `resolution_due_date` DATE COMMENT 'Deadline by which the complaint must be fully resolved, as defined by regulatory mandate, internal SLA policy, or PUC/PSC order. Distinct from the initial response due date.',
  `resolution_timestamp` TIMESTAMP COMMENT 'Date and time when the complaint was formally resolved and closed. Used to calculate total resolution cycle time for regulatory reporting on complaint resolution rates and response times.',
  `resolution_type` STRING COMMENT 'Outcome classification of the complaint resolution. Indicates whether the complaint was upheld in the customer\'s favor, dismissed, settled by mutual agreement, withdrawn by the customer, referred to another authority, or partially upheld. Valid values: upheld|dismissed|settled|withdrawn|referred|partially_upheld.',
  `response_due_date` DATE COMMENT 'Deadline by which the utility must provide an initial response to the complaint, as mandated by state PUC/PSC service standards or FERC regulations. Used for SLA compliance monitoring and regulatory reporting.',
  `root_cause_code` STRING COMMENT 'Standardized code identifying the underlying root cause of the complaint (e.g., billing system error, meter read failure, field crew delay, tariff misapplication). Used for trend analysis, process improvement, and regulatory root cause reporting. Reference-value candidates: billing_system_error|meter_read_failure|field_crew_delay|tariff_misapplication|estimated_read|disconnection_error|payment_processing|communication_failure|equipment_failure|other.',
  `sla_resolution_met` BOOLEAN COMMENT 'Indicates whether the utility met the regulatory or internal SLA target for full complaint resolution. Derived at record closure from resolution_timestamp vs. resolution_due_date. Key metric for PUC/PSC complaint resolution rate reporting.',
  `sla_response_met` BOOLEAN COMMENT 'Indicates whether the utility met the regulatory or internal SLA target for initial response to the complaint. Derived at record closure from first_response_timestamp vs. response_due_date. Used for SLA compliance reporting to PUC/PSC.',
  `subject` STRING COMMENT 'Brief, structured subject line summarizing the nature of the complaint. Used for search, reporting, and initial triage by customer service representatives.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_complaint` PRIMARY KEY (`complaint_id`)
)
USING DELTA
COMMENT 'Transactional entity capturing formal customer complaints filed through regulatory channels (PUC/PSC), internal escalation paths, or third-party mediators. Stores complaint date, complaint type (billing dispute, service quality, outage response, disconnection, rate dispute, discrimination, safety), complaint source (customer direct, PUC referral, BBB, social media, legislative inquiry), assigned resolution owner, regulatory docket number, PUC/PSC case reference, resolution deadline, resolution date, resolution type (upheld, dismissed, settled, withdrawn), customer satisfaction outcome, and escalation tier. Required for FERC, PUC, and state PSC regulatory reporting on complaint volumes, resolution rates, and response times. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CustomerComplaint',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.complaint'
);

-- CustomerEnrollment  <<CIM Agreement : extension>>
CREATE TABLE IF NOT EXISTS `customer`.`customer_enrollment` (
  `customer_enrollment_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for each customer program enrollment record in the utility\'s Customer Information System (CIS). Primary key for the enrollment entity.',
  `account_id` BIGINT COMMENT 'Reference to the utility service account under which the enrollment is registered. A customer may have multiple accounts (premises) with independent enrollments.',
  `customer_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.customer_service_agreement. Business justification: Enrollment represents program participation and should reference the specific service agreement under which the customer is enrolled. Currently enrollment has account_id and premise_id but no service_',
  `der_registry_id` BIGINT COMMENT 'The unique registration identifier assigned to the customer\'s DER asset in the utility\'s Distributed Energy Resource Management System (DERMS). Used for dispatch, telemetry, and FERC Order 2222 aggregation tracking.',
  `dr_program_id` BIGINT COMMENT 'Foreign key linking to demand.dr_program. Business justification: Customer DR program enrollment requires proper FK to dr_program for tracking enrollment terms, incentive structures, and regulatory compliance. Currently uses denormalized program_code/name. Essential',
  `financial_assistance_program_id` BIGINT COMMENT 'Foreign key linking to billing.assistance_program. Business justification: Low-income and medical baseline enrollments must reference the authoritative financial assistance program in billing to ensure correct discount application, verify eligibility criteria match, and supp',
  `incentive_program_id` BIGINT COMMENT 'Foreign key linking to renewable.incentive_program. Business justification: Customer enrollments in solar, storage, and renewable incentive programs require direct linkage for payment processing, compliance verification, budget tracking, and regulatory reporting. Essential fo',
  `interconnection_application_id` BIGINT COMMENT 'Foreign key linking to interconnection.application. Business justification: Customer DER program enrollments (NEM, demand response, VPP) originate from interconnection applications; tracking the originating application enables program eligibility verification, capacity valida',
  `interconnection_asset_registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: DER enrollments must reference the interconnection asset (inverter, generation equipment, storage system) for NEM export tracking, Rule 21 compliance, and grid impact studies. Mandated by interconnect',
  `material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: DER/NEM program enrollments require specific equipment installations (inverters, smart meters, interconnection hardware). Tracking approved equipment specifications ensures regulatory compliance, warr',
  `meter_id` BIGINT COMMENT 'Foreign key linking to metering.meter. Business justification: NEM and DER program enrollments require specific meter configurations (bidirectional metering, interval data collection). Supports interconnection approval workflows, export credit calculations, and r',
  `premise_id` BIGINT COMMENT 'Reference to the physical service premise (metered location) associated with this enrollment. Required for NEM, DER, and demand response programs tied to a specific service point.',
  `profile_id` BIGINT COMMENT 'Reference to the customer account holder enrolled in the program. Links to the master customer record in the CIS (SAP IS-U or Oracle CC&B).',
  `vpp_configuration_id` BIGINT COMMENT 'Foreign key linking to renewable.vpp_configuration. Business justification: Customer DER enrollments in VPP programs require tracking which VPP configuration the asset participates in for dispatch authorization, performance incentives, capacity payments, and ISO/RTO settlemen',
  `additional_baseline_kwh_per_day` DECIMAL(8,3) COMMENT 'The approved additional daily energy allowance in kilowatt-hours (kWh/day) granted to the customer under the medical baseline program, above the standard baseline allocation. Used in billing rate calculations.',
  `aggregator_name` STRING COMMENT 'The name of the third-party aggregator managing the customer\'s DER asset within a Virtual Power Plant (VPP) or demand response aggregation program. Required for FERC Order 2222 compliance and aggregator settlement.',
  `annual_true_up_month` INT COMMENT 'The calendar month (1–12) in which the customer\'s annual NEM true-up billing cycle is settled. Determines when net export credits are reconciled against consumption charges for the 12-month period.',
  `approved_date` DATE COMMENT 'The date on which the enrollment application was formally approved by the utility or regulatory authority. Relevant for NEM interconnection approvals, medical baseline certifications, and low-income program eligibility approvals.',
  `arrearage_forgiveness_amount` DECIMAL(15,2) COMMENT 'Total amount of past-due balance forgiven under an arrearage management program. [Moved from assistance_program: Arrearage forgiveness is applied at enrollment time and varies by account based on outstanding balance, making it enrollment-specific.]',
  `arrearage_forgiveness_date` DATE COMMENT 'Date when the arrearage forgiveness was applied to the customer account. [Moved from assistance_program: The date arrearage forgiveness was applied is specific to each enrollment instance.]',
  `arrearage_plan_balance` DECIMAL(12,2) COMMENT 'The outstanding balance (in USD) enrolled in the customer\'s Arrearage Management Plan (AMP). Tracks the deferred debt amount being managed under the structured repayment program. Null for non-AMP enrollments.',
  `certification_expiration_date` DATE COMMENT 'The date on which the medical baseline or life-support certification expires and must be renewed. Used to trigger renewal reminder notifications and manage disconnection protection eligibility.',
  `channel` STRING COMMENT 'The channel through which the customer enrolled in the program. Supports multi-channel engagement analytics and channel effectiveness reporting. Reference-value candidates: web|mobile_app|ivr|call_center|field_agent|mail|third_party|auto_enrolled.',
  `communication_protocol` STRING COMMENT 'The communication protocol used for telemetry and dispatch signaling between the utility/DERMS and the customer\'s DER device. Determines interoperability requirements for demand response and VPP dispatch. Valid values: IEEE_2030.5|OpenADR_2.0a|OpenADR_2.0b|Modbus|DNP3|other.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when the enrollment record was first created in the system. Audit trail field for data lineage, regulatory compliance, and SOX internal controls.',
  `cumulative_export_credits` DECIMAL(12,4) COMMENT 'The running balance of net energy export credits (in kWh) accumulated by the customer under the NEM program since the last annual true-up. Used for billing reconciliation and NEM settlement calculations.',
  `demand_response_program` STRING COMMENT 'Code identifying the Demand Response (DR) program in which this account is enrolled, such as interruptible load, direct load control, or automated demand response. Null if not enrolled. Drives DR dispatch eligibility and incentive payment calculations. Reference-value candidates: interruptible_load|direct_load_control|auto_dr|peak_time_rebate|emergency_dr|none. [Moved from account: This code identifies a single DR program but does not support enrollment in multiple DR programs simultaneously, nor does it capture enrollment dates, participation level, or tier. Should be replaced by enrollment records linking to DR program records.]',
  `der_enrollment_status` STRING COMMENT 'Enrollment status of this account in a Distributed Energy Resource Management System (DERMS) or Virtual Power Plant (VPP) program. Enrolled accounts may have their DER assets dispatched by the utility or grid operator for demand response, frequency regulation, or capacity services. [Moved from account: This status field indicates DER program enrollment status but belongs to the specific account-program enrollment relationship, not to the account itself. An account may be enrolled in multiple DER programs with different statuses. Should be captured as enrollment.status for DER program enrollments.] Valid values: not_enrolled|pending|enrolled|suspended|terminated.',
  `der_technology_type` STRING COMMENT 'The technology type of the customer\'s Distributed Energy Resource (DER) asset enrolled in the program. Used for DERMS registration, VPP aggregation, and FERC Order 2222 compliance reporting. Reference-value candidates: pv_solar|wind|chp|battery_storage|ev_charger|smart_thermostat|generator|fuel_cell.',
  `disconnection_protected` BOOLEAN COMMENT 'Indicates whether the customer\'s account is protected from service disconnection due to medical baseline, life-support, or low-income program enrollment. True = disconnection protection active; False = no protection. Critical for collections and field operations.',
  `discount_percentage` DECIMAL(5,2) COMMENT 'Percentage discount applied to the customer bill under the assistance program (e.g., 20.00 for 20% discount). [Moved from assistance_program: While programs may have standard discount rates, the actual discount applied can vary by account based on rate class, usage tier, or household size, making it enrollment-specific.]',
  `dispatch_authorization_level` STRING COMMENT 'The level of dispatch authority granted by the customer for their DER asset in demand response or VPP programs. \'full_auto\' = utility can dispatch without customer action; \'semi_auto\' = customer notified before dispatch; \'manual\' = customer initiates; \'opt_in_only\' = customer must opt in per event. Valid values: full_auto|semi_auto|manual|opt_in_only.',
  `effective_end_date` DATE COMMENT 'The date on which the enrollment ceases to be effective. Null for open-ended enrollments. Used for term-limited programs, certification expirations, and contract end dates.',
  `effective_start_date` DATE COMMENT 'The date on which the enrollment becomes operationally effective and the customer begins receiving program benefits, rates, or obligations. May differ from enrollment_date due to billing cycle alignment or approval processing.',
  `eligibility_verification_date` DATE COMMENT 'Date when customer eligibility was verified for the assistance program. [Moved from assistance_program: Verification date varies by enrollment instance based on when the customer submitted documentation.]',
  `eligibility_verification_status` STRING COMMENT 'Current status of the customer eligibility verification process for the assistance program. [Moved from assistance_program: Verification status is specific to each account\'s enrollment application and documentation submission.] Valid values: pending|verified|rejected|expired|under_review.',
  `enrollment_date` DATE COMMENT 'The calendar date on which the customer submitted or was enrolled in the program. Represents the principal business event date (application/enrollment action date), distinct from the effective start date when benefits begin.',
  `enrollment_status` STRING COMMENT 'Current lifecycle state of the enrollment record. \'pending\' = application submitted, awaiting approval; \'active\' = currently participating; \'suspended\' = temporarily paused (e.g., medical review); \'cancelled\' = voluntarily withdrawn; \'expired\' = past effective end date; \'rejected\' = application denied. Valid values: pending|active|suspended|cancelled|expired|rejected.',
  `expiration_date` DATE COMMENT 'Date when the enrollment expires and requires re-certification or renewal. [Moved from assistance_program: Enrollment expiration is specific to each account-program enrollment, not to the program definition.]',
  `export_compensation_rate` DECIMAL(10,6) COMMENT 'The per-kilowatt-hour ($/kWh) rate at which the utility compensates the customer for net energy exported to the grid under the NEM tariff. Rate is locked at enrollment for grandfathered NEM versions. Null for non-NEM enrollments.',
  `green_energy_percentage` DECIMAL(5,2) COMMENT 'The percentage of the customer\'s energy supply sourced from renewable energy under a green energy program enrollment (0–100%). Used for Renewable Energy Certificate (REC) allocation and Renewable Portfolio Standard (RPS) compliance reporting.',
  `household_size` INT COMMENT 'Number of individuals in the customer household used for eligibility determination. [Moved from assistance_program: Household size is captured at enrollment time for eligibility determination and may change between recertifications, making it enrollment-specific.]',
  `income_verification_date` DATE COMMENT 'The date on which the customer\'s income eligibility was last verified for low-income assistance programs (CARE, FERA, LIHEAP). Used for periodic re-certification compliance and audit trails.',
  `installed_capacity_kw_dc` DECIMAL(10,3) COMMENT 'The nameplate DC capacity in kilowatts (kW-DC) of the customer\'s installed distributed generation or storage system. Used for NEM eligibility sizing, export limit calculations, and DERMS registration. Applicable to NEM and DER/VPP enrollments.',
  `interconnection_application_date` DATE COMMENT 'The date on which the customer submitted the interconnection application for a distributed generation system (e.g., rooftop solar, battery storage). Applicable to NEM and DER enrollments. Required for FERC Order 2222 and state PUC interconnection tracking.',
  `inverter_type` STRING COMMENT 'The type of inverter installed with the customer\'s solar PV or battery storage system. Relevant for NEM technical review, grid interconnection safety assessment, and DERMS telemetry compatibility. Valid values: string|microinverter|power_optimizer|hybrid|battery_inverter.',
  `last_recertification_date` DATE COMMENT 'Date of the most recent eligibility recertification completed by the customer. [Moved from assistance_program: Recertification history is specific to each account\'s enrollment, not to the program.]',
  `last_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when the enrollment record was most recently modified. Used for change data capture (CDC), audit trails, and downstream incremental processing in the Databricks Silver layer.',
  `life_support_equipment_type` STRING COMMENT 'The type of electrically powered life-support medical equipment used by the customer or household member. Determines disconnection protection rules and priority restoration status during outages. Null for non-life-support enrollments. Valid values: oxygen_concentrator|dialysis|ventilator|infusion_pump|other.',
  `low_income_program` STRING COMMENT 'Code identifying the low-income assistance program in which this account is enrolled, such as CARE (California Alternate Rates for Energy), FERA (Family Electric Rate Assistance), LIHEAP, or utility-specific low-income discount programs. Drives rate discounts and disconnection protections. Reference-value candidates: care|fera|liheap|utility_discount|none. [Moved from account: This code identifies a single low-income program (CARE/FERA) but does not support enrollment in multiple assistance programs, nor does it capture enrollment date, eligibility verification date, tier assignment, or recertification schedule. Should be replaced by enrollment records.]',
  `med_certification_type` STRING COMMENT 'The type of medical program certification for the customer. \'life_support\' = customer or household member depends on electrically powered life-support equipment; \'medical_baseline_allowance\' = customer qualifies for additional baseline energy allowance due to medical condition. Null for non-medical enrollments. Valid values: life_support|medical_baseline_allowance.',
  `medical_baseline` BOOLEAN COMMENT 'Indicates whether this account has been approved for a Medical Baseline Allowance, providing additional low-cost energy allocation to customers with qualifying medical conditions that require life-support equipment or climate control. Governs disconnection protections and rate adjustments per PUC rules. [Moved from account: This boolean flag indicates medical baseline approval but does not capture approval date, expiration date, recertification schedule, or participation level. Should be replaced by enrollment records linking to the Medical Baseline Program with full lifecycle attributes.]',
  `monthly_credit_amount` DECIMAL(15,2) COMMENT 'Fixed monthly credit amount applied to the customer bill under the assistance program. [Moved from assistance_program: The monthly credit amount may vary by enrollment based on account characteristics, usage patterns, or tiered benefit structures.]',
  `nem_participant` BOOLEAN COMMENT 'Indicates whether this account is enrolled in a Net Energy Metering (NEM) program, meaning the customer has behind-the-meter generation (typically solar PV) and receives bill credits for excess energy exported to the grid. Drives bidirectional metering requirements and NEM tariff application. [Moved from account: This boolean flag indicates NEM program participation but does not capture which NEM program, enrollment dates, or participation level. The flag should be replaced by enrollment records in the enrollment association that link to specific NEM program records with full lifecycle tracking.]',
  `nem_version` STRING COMMENT 'The version of the Net Energy Metering tariff under which the customer is enrolled. Determines export compensation rate structure and true-up methodology. Null for non-NEM enrollments. Valid values: NEM-1.0|NEM-2.0|NEM-3.0|NEM-ST.',
  `opt_out_date` DATE COMMENT 'The date on which the customer voluntarily opted out of the program. Null if the customer has not opted out. Distinct from effective_end_date which may be system-driven.',
  `opt_out_reason` STRING COMMENT 'Reason code for the customer\'s voluntary withdrawal from the program. Used for churn analysis, program improvement, and regulatory reporting. Reference-value candidates: customer_request|moved|rate_change|financial_hardship|program_change|ineligible|other.',
  `permission_to_operate_date` DATE COMMENT 'The date on which the utility granted Permission to Operate (PTO) for the customer\'s distributed energy resource (DER) system. Marks the official start of NEM or DER export eligibility.',
  `physician_certification_date` DATE COMMENT 'The date on which a licensed physician certified the customer\'s medical condition for the medical baseline allowance or life-support program. Required for PUC medical tariff compliance.',
  `qualifying_condition` STRING COMMENT 'The medical condition or diagnosis that qualifies the customer for the medical baseline allowance or life-support program. Protected Health Information (PHI) — classified as restricted. Null for non-medical enrollments.',
  `recertification_due_date` DATE COMMENT 'Date by which the customer must complete eligibility recertification to maintain program enrollment. [Moved from assistance_program: Recertification cycles are specific to each enrollment instance based on initial enrollment date and program rules.]',
  `renewal_reminder_date` DATE COMMENT 'The date on which the utility should send a renewal reminder notification to the customer for medical baseline or life-support certification renewal. Typically set a defined number of days before certification_expiration_date.',
  `telemetry_available` BOOLEAN COMMENT 'Indicates whether real-time telemetry data is available from the customer\'s DER device for DERMS monitoring and dispatch. True = telemetry enabled; False = no real-time telemetry (manual or estimated dispatch).',
  `total_benefit_received_amount` DECIMAL(15,2) COMMENT 'Cumulative total benefit amount the customer has received to date under the current enrollment. [Moved from assistance_program: This is a cumulative metric specific to each account\'s enrollment, tracking total benefits received to date for this enrollment instance.]',
  `tou_rate_plan_code` STRING COMMENT 'The specific Time-of-Use (TOU) or Critical Peak Pricing (CPP) rate plan code assigned to the customer under this enrollment. Maps to the tariff schedule in the billing system. Null for non-rate-plan enrollments.',
  `vpp_program_code` STRING COMMENT 'The utility-assigned code for the Virtual Power Plant (VPP) aggregation program in which the customer\'s DER is enrolled. Used for dispatch scheduling, settlement, and FERC Order 2222 reporting.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_customer_enrollment` PRIMARY KEY (`customer_enrollment_id`)
)
USING DELTA
COMMENT 'Transactional entity and SSOT for all customer program participation across the utility. Captures enrollments in demand response (DR), time-of-use (TOU) rate plans, critical peak pricing (CPP) tariffs, budget billing, auto-pay, paperless billing, Net Energy Metering (NEM 1.0/2.0/3.0/NEM-ST) including interconnection application date, approval date, permission-to-operate date, installed capacity (kW-DC), inverter type, technology type (PV, wind, CHP), export compensation rate, annual true-up month, and cumulative export credits. Captures DER/VPP aggregation program enrollments including DER asset type (rooftop solar, battery storage, EV charger, smart thermostat, generator), DER registration ID, DERMS system reference, aggregator name, VPP program code, telemetry availability flag, communication protocol (IEEE 2030.5, OpenADR, Modbus), and dispatch authorization level. Captures medical baseline allowance certifications including certification type (life support, medical baseline allowance), qualifying condition, physician certification date, certification expiration, renewal reminder date, approved additional baseline kWh per day, and life-support equipment type (oxygen concentrator, dialysis, ventilator). Captures low-income assistance program enrollments (LIHEAP, CARE, FERA), green energy programs, EV charging incentive programs, and arrearage management plans. Stores program code, enrollment date, enrollment channel, enrollment status, effective start and end dates, opt-out date and reason, and all program-specific eligibility and technical attributes. Supports FERC Order 2222 compliance, PUC medical baseline tariff compliance, disconnection protection rules, and regulatory reporting. | CMM: CIM Agreement (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CustomerEnrollment',
  'cmm.cim.class' = 'Agreement',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.customer_enrollment'
);

-- MoveOrder  <<CIM Work : close>>
CREATE TABLE IF NOT EXISTS `customer`.`move_order` (
  `move_order_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for the move order record in the Silver layer lakehouse. Primary key for this entity.',
  `customer_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.customer_service_agreement. Business justification: Move order (move-in, move-out, transfer) should reference the service agreement being initiated or terminated. Currently move_order has account_id and premise_id but no service_agreement_id. This FK e',
  `field_order_id` BIGINT COMMENT 'Reference to the field work order created in the asset/workforce management system (Ventyx Asset Suite) to execute the physical service connection, disconnection, or meter read associated with this move order. Links the CIS move order to the field operations domain.',
  `meter_id` BIGINT COMMENT 'Reference to the meter device installed at the service point at the time of the move order. Used to schedule move-in/move-out meter reads and link final read values to the correct device record in the Metering domain.',
  `meter_point_id` BIGINT COMMENT 'Reference to the specific service point (metering point / point of delivery) at the premise where service is being initiated or terminated. A premise may have multiple service points (e.g., electric and gas).',
  `move_account_id` BIGINT COMMENT 'FK to customer.account.account_id — Move orders initiate/terminate service for an account. move_order.account_id → account.account_id.',
  `move_premise_id` BIGINT COMMENT 'Reference to the service premise (physical location) at which the move order is being executed. Central linkage to the premise master record for address, meter, and distribution asset context.',
  `primary_move_prior_account_id` BIGINT COMMENT 'Reference to the existing service account being closed or vacated as part of this move order. Populated for move-out and transfer order types. Used to trigger final bill generation and deposit disposition in the billing domain.',
  `profile_id` BIGINT COMMENT 'Reference to the customer party initiating the move order. Links to the customer master record in the Customer domain. For a transfer, this is the incoming customer (move-in party).',
  `tertiary_move_prior_occupant_account_id` BIGINT COMMENT 'Reference to the account of the previous occupant at the premise, if known at the time of the move-in order. Used to coordinate final bill issuance for the departing customer and to identify any outstanding balance or deposit transfer obligations.',
  `to_premise_id` BIGINT COMMENT 'FK to customer.premise.premise_id — Move orders reference the premise where service starts/stops. move_order.premise_id → premise.premise_id.',
  `budget_billing_enrolled` BOOLEAN COMMENT 'Indicates whether the customer is enrolled in a budget billing (levelized payment) plan at the time of the move order. When true, the final bill calculation must account for any budget billing true-up balance upon move-out.',
  `cancellation_reason` STRING COMMENT 'Free-text or coded reason explaining why the move order was cancelled or rejected. Populated only when order_status is \'cancelled\' or \'rejected\'. Used for operational quality analysis and customer service improvement.',
  `channel` STRING COMMENT 'The customer engagement channel through which the move order was submitted. Supports multi-channel analytics and CRM reporting. Reference-value candidates: web_portal|mobile_app|call_center|walk_in|field_crew|ivr|third_party.',
  `completion_timestamp` TIMESTAMP COMMENT 'The date and time when the move order was fully completed and all downstream actions (meter read, billing, account activation/deactivation) were confirmed. Distinct from effective_date (the business date of service change) and submitted_timestamp (when the order was placed).',
  `created_timestamp` TIMESTAMP COMMENT 'Audit timestamp recording when this move order record was first created in the Silver layer data store. Distinct from submitted_timestamp which reflects the business event time.',
  `credit_check_required` BOOLEAN COMMENT 'Indicates whether a credit check was required for this move-in or transfer order based on the customer\'s credit classification or account history. When true, the move order may be held pending credit review and deposit determination per SAP IS-U FICA or Oracle CC&B Collections rules.',
  `credit_check_status` STRING COMMENT 'The outcome of the credit check performed for this move order. Not_required: credit check was not triggered. Passed: customer met credit criteria. Failed: customer did not meet criteria (deposit required). Pending: check in progress. Waived: credit check bypassed per business rules (e.g., existing customer in good standing). Valid values: not_required|passed|failed|pending|waived.',
  `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code applicable to all monetary amounts on this move order (deposit_amount, final_bill_amount). Typically USD for North American utilities. Supports multi-currency operations for utilities with international operations. Pattern: ^[A-Z]{3}$.',
  `demand_response_enrolled` BOOLEAN COMMENT 'Indicates whether the customer or premise is enrolled in a Demand Response (DR) program at the time of the move order. When true, the DR program administrator must be notified to update enrollment records and avoid erroneous dispatch signals.',
  `deposit_amount` DECIMAL(18,2) COMMENT 'The monetary value of the security deposit associated with the prior or new account at the time of the move order. Used to determine deposit disposition (refund, transfer, or application to final bill balance) upon move-out or transfer.',
  `deposit_disposition` STRING COMMENT 'The outcome or planned treatment of the security deposit upon move-out or transfer. Refund: returned to customer. Applied_to_balance: offset against outstanding final bill. Transferred: moved to new account. Forfeited: retained by utility per tariff terms. Pending: disposition not yet determined. Valid values: refund|applied_to_balance|transferred|forfeited|pending.',
  `der_enrolled` BOOLEAN COMMENT 'Indicates whether the premise associated with this move order has an active Distributed Energy Resource (DER) enrollment (e.g., battery storage, EV charger, demand response program). When true, triggers DERMS notification and DER agreement review upon move-out or transfer.',
  `effective_date` DATE COMMENT 'The actual date on which the service change (move-in, move-out, or transfer) became effective at the premise. Used as the billing boundary date for final bill generation and new account activation. May differ from requested_date due to scheduling constraints or field execution timing.',
  `final_bill_amount` DECIMAL(18,2) COMMENT 'The total monetary amount of the final bill generated as a result of the move-out or transfer order. Represents the net amount owed by or to the customer after applying the final meter read, applicable tariff rates, taxes, and deposit disposition.',
  `final_read_value` DECIMAL(18,4) COMMENT 'The meter register reading (in kWh or applicable unit) captured at the time of the move order. For move-out, this is the closing read used to calculate the final bill. For move-in, this is the opening read establishing the new billing baseline.',
  `landlord_notification_required` BOOLEAN COMMENT 'Indicates whether the property owner or landlord must be notified of the service change per tariff rules or regulatory requirements. Relevant for rental properties where the landlord has a standing notification agreement with the utility.',
  `landlord_notified_date` DATE COMMENT 'The date on which the landlord or property owner was notified of the service change associated with this move order. Populated only when landlord_notification_required is true. Used for regulatory compliance documentation.',
  `medical_baseline` BOOLEAN COMMENT 'Indicates whether the customer has an approved medical baseline allowance (life support or medical necessity designation) that requires special handling during service disconnection or move-out. When true, additional notification and regulatory compliance steps are required before service termination.',
  `meter_read_date` DATE COMMENT 'The date on which the meter was physically or remotely read in connection with this move order. Used as the billing cut-off date for the final bill (move-out) or the start-of-service read date (move-in). Sourced from Oracle Utilities MDM or SAP IS-U Device Management.',
  `nem_participant` BOOLEAN COMMENT 'Indicates whether the customer associated with this move order is enrolled in a Net Energy Metering (NEM) program, typically due to rooftop solar or other behind-the-meter (BTM) generation. When true, triggers specialized NEM billing and interconnection review processes upon move-in or move-out.',
  `order_number` STRING COMMENT 'Externally-known business identifier for the move order, assigned by the source system (SAP IS-U or Oracle CC&B). Used for customer-facing correspondence and cross-system reconciliation. Pattern: ^MO-[0-9]{10}$.',
  `order_status` STRING COMMENT 'Current lifecycle state of the move order workflow. Pending: submitted but not yet processed. In_progress: actively being executed (meter read scheduled, field crew dispatched). Completed: service change fully effected. Cancelled: withdrawn before execution. Rejected: failed validation or business rules. Valid values: pending|in_progress|completed|cancelled|rejected.',
  `order_type` STRING COMMENT 'Classifies the nature of the service order: move_in (new service activation at a premise), move_out (service termination at a premise), transfer (simultaneous move-out and move-in for a change of occupant), reconnect (restoration of previously disconnected service), or disconnect (non-payment or voluntary disconnection). Reference-value candidates: move_in|move_out|transfer|reconnect|disconnect. Valid values: move_in|move_out|transfer|reconnect|disconnect.',
  `rate_schedule_code` STRING COMMENT 'The tariff rate schedule code assigned to the new service account upon move-in or transfer. Determines the billing rate class (e.g., residential, small commercial, large industrial, TOU, CPP). Sourced from the applicable PUC-approved tariff.',
  `read_type` STRING COMMENT 'Indicates how the move-order meter read was obtained: actual (field technician physical read), estimated (calculated based on usage history when actual read is unavailable), AMI_remote (automated read via Advanced Metering Infrastructure), or customer_self_read (customer-reported reading). Valid values: actual|estimated|AMI_remote|customer_self_read.',
  `read_unit_of_measure` STRING COMMENT 'The unit of measure for the final_read_value. Typically kWh for electric meters, but may be therms, CCF, or MCF for gas service points. Ensures correct interpretation of the meter read value across commodity types. Valid values: kWh|MWh|kW|therm|CCF|MCF.',
  `remarks` STRING COMMENT 'Free-text field for operational notes, special instructions, or exceptions associated with this move order. May include field crew instructions, customer-specific handling notes, or escalation details entered by customer service representatives.',
  `requested_date` DATE COMMENT 'The date the customer requested the service change to take effect. This is the customer-stated desired effective date, which may differ from the actual effective date after scheduling and field execution.',
  `scheduled_read_date` DATE COMMENT 'The date on which the meter read associated with this move order is scheduled to be performed. May differ from meter_read_date (actual read date) if the read is rescheduled or delayed. Used for field crew scheduling and MDM read request management.',
  `service_class` STRING COMMENT 'Customer service classification at the time of the move order, determining applicable tariff, billing rules, and regulatory reporting category. Residential, small commercial, large commercial, industrial, agricultural, or lighting. Valid values: residential|small_commercial|large_commercial|industrial|agricultural|lighting.',
  `service_territory_code` STRING COMMENT 'Code identifying the utility\'s regulated service territory within which the premise is located. Used for regulatory reporting to State PUCs, FERC Form 1 filings, and NERC reliability reporting. Determines applicable tariff jurisdiction.',
  `source_system` STRING COMMENT 'Identifies the operational system of record from which this move order record was sourced. SAP_IS-U: SAP Industry Solution for Utilities. Oracle_CCB: Oracle Utilities Customer Care and Billing. Manual: entered directly into the data platform. Used for data lineage and reconciliation. Valid values: SAP_IS-U|Oracle_CCB|manual.',
  `source_system_order_reference` STRING COMMENT 'The native primary key or order identifier from the originating operational system (SAP IS-U or Oracle CC&B). Enables traceability back to the source system record for audit, reconciliation, and issue resolution.',
  `submitted_timestamp` TIMESTAMP COMMENT 'The date and time when the move order was first submitted into the CIS system (SAP IS-U or Oracle CC&B). Represents the principal business event timestamp for order creation. Used for SLA tracking and order aging analysis.',
  `updated_timestamp` TIMESTAMP COMMENT 'Audit timestamp recording when this move order record was most recently modified in the Silver layer data store. Used for change data capture and incremental processing.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_move_order` PRIMARY KEY (`move_order_id`)
)
USING DELTA
COMMENT 'Transactional entity capturing move-in, move-out, and transfer-of-service orders that initiate or terminate service at a premise. Stores order type (move-in, move-out, transfer), requested date, actual effective date, prior account reference, new account reference, premise reference, meter read date at move, final read value, deposit disposition, and order status. Sourced from SAP IS-U Move-In/Move-Out and Oracle CC&B Start/Stop Service. Triggers meter read scheduling and final bill generation in downstream domains. | CMM: CIM Work (close), IEC61968::Work.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MoveOrder',
  'cmm.cim.class' = 'Work',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Work',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.move_order'
);

-- ThirdPartyAuthorization  <<CIM Agreement : extension>>
CREATE TABLE IF NOT EXISTS `customer`.`third_party_authorization` (
  `third_party_authorization_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for each third-party authorization or consent record. Primary key for the third_party_authorization data product within the customer domain SSOT.',
  `account_id` BIGINT COMMENT 'FK to customer.account.account_id — Third-party authorizations are granted per account. third_party_authorization.account_id → account.account_id.',
  `customer_enrollment_id` BIGINT COMMENT 'Reference to the DER program enrollment record associated with this authorization. Populated when the authorization grants a DERMS provider or aggregator access to dispatch or monitor a customer\'s distributed energy resource (solar, battery, EV charger, etc.).',
  `dr_program_id` BIGINT COMMENT 'Identifier of the demand response program for which this authorization grants aggregator or DERMS provider access. Links the authorization to a specific DR or Virtual Power Plant (VPP) program managed by the utility or ISO/RTO.',
  `employee_id` BIGINT COMMENT 'Employee or agent identifier of the utility customer service representative who processed or witnessed this authorization on behalf of the customer (e.g., for paper, verbal, or IVR-assisted consents). Null for fully self-service digital consents.',
  `ferc_aggregator_id` BIGINT COMMENT 'FERC-registered identifier for the demand response or DER aggregator authorized under FERC Order 2222. Required when authorization_type is \'aggregator\' or \'derms_provider\'. Enables regulatory traceability of aggregator participation in wholesale markets.',
  `notification_preference_id` BIGINT COMMENT 'Foreign key linking to customer.notification_preference. Business justification: Third-party authorizations reference a notification preference code; replace with FK to notification_preference to normalize and give inbound link to notification_preference.',
  `ppa_contract_id` BIGINT COMMENT 'Foreign key linking to renewable.ppa_contract. Business justification: Third-party PPA agreements require explicit customer authorization for data sharing, billing coordination, and account access. Critical for community solar subscriptions and third-party ownership mode',
  `premise_id` BIGINT COMMENT 'Reference to the service premise (physical location) covered by this authorization. Relevant for landlord, property manager, and aggregator authorizations scoped to a specific service address.',
  `profile_id` BIGINT COMMENT 'Reference to the customer account holder who granted this authorization or consent. Links to the master customer record in the CIS (SAP IS-U / Oracle CC&B).',
  `third_account_id` BIGINT COMMENT 'Reference to the specific utility service account to which this authorization applies. A customer may have multiple accounts (residential, commercial, NEM, DER-enrolled) and authorizations are scoped at the account level.',
  `to_account_id` BIGINT COMMENT 'FK to customer.account.account_id — Authorizations and consent records are granted by a customer account. Required for FERC Order 2222 aggregator access, Green Button compliance, and CCPA/GDPR data sharing.',
  `authorization_number` STRING COMMENT 'Externally-known business identifier for this authorization record, used in customer correspondence, audit trails, and regulatory submissions. Formatted as AUTH- followed by a 10-digit sequence. Pattern: ^AUTH-[0-9]{10}$.',
  `authorization_scope` STRING COMMENT 'Textual description of the specific data, services, or actions covered by this authorization. Examples include: interval usage data, billing history, account balance, demand response enrollment, Green Button data, DER dispatch commands. Captures the granular scope agreed to by the customer.',
  `authorization_status` STRING COMMENT 'Current lifecycle state of the authorization record. Active indicates the authorization is in force; pending indicates awaiting customer confirmation; suspended indicates temporarily paused; revoked indicates customer-initiated withdrawal; expired indicates the authorization end date has passed. Valid values: active|pending|suspended|revoked|expired.',
  `authorization_type` STRING COMMENT 'Categorical classification of the access level or relationship type granted to the third party. Determines what actions the authorized party may perform: view_only (read-only data access), full_access (read and transact), notification_only (receive alerts), landlord (property owner access), property_manager (delegated property management), aggregator (demand response or VPP aggregator per FERC Order 2222), derms_provider (Distributed Energy Resource Management System provider access). Reference-value candidates: view_only|full_access|notification_only|landlord|property_manager|aggregator|derms_provider.',
  `authorized_party_identifier` STRING COMMENT 'External registration or license number identifying the authorized third party, such as a FERC-registered aggregator ID, state PUC license number, or business registration number. Used for regulatory verification and audit.',
  `authorized_party_name` STRING COMMENT 'Legal name of the third party (individual, company, or organization) to whom access or authority has been granted. May be a landlord, property management company, demand response aggregator, DERMS provider, or other authorized entity.',
  `authorized_party_type` STRING COMMENT 'Classification of the authorized third party entity type. Distinguishes between individual persons (e.g., family member, tenant), commercial companies (e.g., property management firm), aggregators (demand response or VPP aggregators per FERC Order 2222), government agencies, and non-profit organizations. Valid values: individual|company|aggregator|government|non_profit|other.',
  `ccpa_applicable` BOOLEAN COMMENT 'Indicates whether this authorization record is subject to CCPA consumer rights obligations (right to know, right to delete, right to opt-out of sale). Relevant for California utility customers and California-regulated service territories.',
  `consent_channel` STRING COMMENT 'The channel or medium through which the customer provided consent or authorization. Captures: web_portal (online self-service), mobile_app (utility mobile application), ivr (Interactive Voice Response system), paper (physical form), written (written correspondence), electronic (email or e-sign), verbal (recorded phone call). Required for regulatory proof of consent method. Reference-value candidates: web_portal|mobile_app|ivr|paper|written|electronic|verbal.',
  `consent_text_reference` STRING COMMENT 'Document reference or URL pointing to the exact consent language text presented to the customer. Used for legal and regulatory audit to confirm the precise wording agreed to at the time of consent.',
  `consent_timestamp` TIMESTAMP COMMENT 'The exact date and time (with timezone) at which the customer provided consent or authorization. This is the principal real-world event time for the consent act, distinct from the record creation audit timestamp. Critical for GDPR, CCPA, and state PUC compliance audit trails.',
  `consent_type` STRING COMMENT 'Classification of the consent event captured in this record. Covers: data_sharing (general data access consent), marketing (communications consent), green_button (Green Button Connect My Data consent), electronic_signature (e-sign agreement), aggregator (third-party aggregator authorization), der_enrollment (DER program enrollment consent), nem_participation (Net Energy Metering participation consent). Reference-value candidates: data_sharing|marketing|green_button|electronic_signature|aggregator|der_enrollment|nem_participation|demand_response.',
  `consent_version` STRING COMMENT 'Version identifier of the consent text or terms presented to the customer at the time of consent capture. Enables tracking of which version of the consent language was agreed to, supporting regulatory audit and re-consent workflows when terms change. Pattern: ^[0-9]+\\.[0-9]+(\\.[0-9]+)?$.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time at which this authorization record was first created in the system. Audit timestamp for data lineage and regulatory record-keeping. Distinct from consent_timestamp, which captures the real-world consent event time.',
  `data_access_end_date` DATE COMMENT 'The latest date through which data may be accessed by the authorized third party. Defines the forward boundary of the data sharing window. Distinct from effective_end_date, which governs the authorization itself; this field governs the data time range.',
  `data_access_start_date` DATE COMMENT 'The earliest date from which historical usage or account data may be accessed by the authorized third party under this authorization. Defines the lookback window for Green Button data sharing, aggregator access, and DERMS data feeds.',
  `effective_end_date` DATE COMMENT 'The date on which this authorization or consent expires and the authorized party\'s access terminates. Nullable for open-ended authorizations. When populated, the system must enforce access revocation on or after this date.',
  `effective_start_date` DATE COMMENT 'The date on which this authorization or consent becomes effective and the authorized party may begin exercising the granted access or permissions. May differ from consent_timestamp if a future start date was agreed.',
  `electronic_signature_reference` STRING COMMENT 'Reference identifier for the electronic signature record associated with this authorization, stored in the e-signature platform. Provides legal proof of customer agreement for electronically executed authorizations. Populated when consent_channel is \'electronic\' or \'electronic_signature\'.',
  `gdpr_applicable` BOOLEAN COMMENT 'Indicates whether this authorization record is subject to GDPR data subject rights obligations (right to access, right to erasure, right to portability). Relevant for utility customers in GDPR-applicable jurisdictions.',
  `green_button_enabled` BOOLEAN COMMENT 'Indicates whether this authorization enables Green Button Connect My Data (CMD) access for the authorized third party. When true, the authorized party may retrieve interval energy usage data via the Green Button API. Supports DOE Green Button initiative compliance.',
  `ip_address` STRING COMMENT 'IP address of the device from which the customer submitted the consent or authorization via a digital channel (web portal or mobile app). Used for fraud detection, audit trail, and regulatory proof of digital consent. Null for non-digital channels (paper, IVR, verbal).',
  `last_reviewed_date` DATE COMMENT 'The most recent date on which the customer confirmed, reviewed, or re-consented to this authorization. Used to track the currency of consent and trigger re-consent workflows when the review interval has elapsed.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time at which this authorization record was most recently modified in the system. Supports change data capture, audit trails, and incremental lakehouse processing.',
  `marketing_consent` BOOLEAN COMMENT 'Indicates whether the customer has provided explicit consent to receive marketing communications from the utility or its authorized partners. Distinct from data sharing consent. Required for GDPR Article 6 and CCPA opt-in/opt-out compliance.',
  `nem_participant` BOOLEAN COMMENT 'Indicates whether this authorization is associated with a Net Energy Metering (NEM) enrolled customer account. When true, the authorization may cover behind-the-meter (BTM) generation data sharing with aggregators or DERMS providers.',
  `paper_form_reference` STRING COMMENT 'Document management reference or scan identifier for the physical paper authorization form submitted by the customer. Populated when consent_channel is \'paper\' or \'written\'. Enables retrieval of the original signed document for audit.',
  `puc_jurisdiction` STRING COMMENT 'Two-letter US state code identifying the state Public Utility Commission (PUC) jurisdiction governing this authorization. Determines which state-specific data privacy and customer authorization rules apply. Required for multi-state utility operations. Pattern: ^[A-Z]{2}$.',
  `renewal_frequency_days` INT COMMENT 'Number of days between required authorization renewals when renewal_required is true. Common values are 365 (annual) or 730 (biennial) per state PUC requirements. Drives automated renewal reminder workflows in the CIS.',
  `renewal_required` BOOLEAN COMMENT 'Indicates whether this authorization requires periodic renewal by the customer. When true, the system must generate renewal notifications before the effective_end_date. Supports compliance with state PUC rules requiring periodic re-consent for ongoing data sharing.',
  `revocation_date` DATE COMMENT 'The date on which the customer withdrew or revoked this authorization prior to its scheduled end date. Populated only when the customer initiates early termination. Triggers downstream access revocation in CIS, DERMS, and Green Button systems.',
  `revocation_reason` STRING COMMENT 'Reason code explaining why this authorization was revoked or withdrawn. Supports regulatory reporting and customer service analytics. Values: customer_request (voluntary withdrawal), account_closure (account terminated), fraud_reported (suspected unauthorized access), regulatory_order (PUC or FERC directive), system_expiry (automated expiry), other. Valid values: customer_request|account_closure|fraud_reported|regulatory_order|system_expiry|other.',
  `session_token` STRING COMMENT 'Authenticated session token or transaction reference from the digital channel (web portal or mobile app) at the time of consent capture. Provides a cryptographic audit trail linking the consent event to a verified authenticated session. Null for non-digital channels.',
  `source_system` STRING COMMENT 'The operational system of record from which this authorization record originated. Identifies whether the record was created in SAP IS-U, Oracle CC&B, the customer web portal, mobile app, IVR system, or via manual data entry. Supports data lineage and reconciliation. Valid values: sap_isu|oracle_ccb|web_portal|mobile_app|ivr|manual_entry.',
  `source_system_reference_code` STRING COMMENT 'The native identifier of this authorization record in the originating operational system (SAP IS-U or Oracle CC&B). Enables bidirectional traceability between the lakehouse silver layer and the CIS system of record.',
  `verbal_recording_reference` STRING COMMENT 'Reference identifier for the call recording in which verbal consent was captured (e.g., IVR or agent-assisted phone call). Links to the call recording archive for regulatory audit. Populated only when consent_channel is \'verbal\' or \'ivr\'.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_third_party_authorization` PRIMARY KEY (`third_party_authorization_id`)
)
USING DELTA
COMMENT 'Master entity and SSOT for all customer-granted authorizations, explicit consent events, and data-sharing permissions. Captures third-party access authorizations including authorized party name, authorization type (view-only, full access, notification-only, landlord, property manager, aggregator, DERMS provider), and authorization scope. Captures all consent events including consent for data sharing, marketing communications, Green Button data access, electronic signature agreements, and third-party aggregator authorization. Stores consent type and version, consent channel (web portal, mobile app, IVR, paper, written, electronic, verbal with recording reference), consent date and time, consent text version reference, IP address or session token, authorization start and end dates, revocation/withdrawal date and reason. Required for FERC Order 2222 DER aggregator access, Green Button data sharing compliance, GDPR, CCPA, and state PUC data privacy requirements. | CMM: CIM Agreement (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ThirdPartyAuthorization',
  'cmm.cim.class' = 'Agreement',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.third_party_authorization'
);

-- IncentiveEnrollment  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `customer`.`incentive_enrollment` (
  `incentive_enrollment_id` BIGINT NOT NULL COMMENT 'Unique surrogate identifier for this incentive program enrollment record. Primary key for the association.',
  `account_id` BIGINT COMMENT 'Foreign key linking to the utility customer account enrolled in the incentive program',
  `renewable_incentive_program_id` BIGINT COMMENT 'Foreign key linking to the renewable energy incentive program in which the account is enrolled',
  `application_date` DATE COMMENT 'Date when the customer submitted the application for this incentive program. Used for determining eligibility windows and processing timelines.',
  `application_number` STRING COMMENT 'Externally-known unique application number assigned when the customer applied for this specific incentive program. Used for customer communication and regulatory tracking.',
  `application_status` STRING COMMENT 'Current status of the incentive program application for this account-program enrollment. Tracks the application lifecycle from submission through final disposition.',
  `approved_amount` DECIMAL(18,2) COMMENT 'Total dollar amount of incentive funding approved for this specific account-program enrollment in USD. Represents the committed program budget allocation for this participant.',
  `compliance_status` STRING COMMENT 'Current compliance status of this account with the requirements of this specific incentive program. Tracks whether the participant is meeting ongoing program obligations such as REC transfer, interconnection standards, or reporting requirements.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this enrollment record was first created in the system. Used for audit tracking and data lineage.',
  `enrollment_date` DATE COMMENT 'Date when the account was officially enrolled in the incentive program following application approval. Marks the start of the enrollment relationship.',
  `enrollment_status` STRING COMMENT 'Current lifecycle status of this account\'s enrollment in this incentive program. Governs whether payments can be processed and compliance is being monitored.',
  `installed_system_size_kw` DECIMAL(12,3) COMMENT 'Actual installed capacity in kilowatts (kW) of the renewable energy system for which this account is receiving incentives under this program. Used for calculating incentive amounts and verifying eligibility.',
  `interconnection_approval_date` DATE COMMENT 'Date when utility interconnection approval was granted for the renewable energy system associated with this enrollment. Required for programs where requires_interconnection_approval is true.',
  `last_compliance_verification_date` DATE COMMENT 'Date when compliance with program requirements was last verified for this enrollment. Used for tracking ongoing compliance monitoring schedules.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this enrollment record was last updated. Used for change tracking and data synchronization.',
  `last_payment_date` DATE COMMENT 'Date of the most recent incentive payment disbursed to this account for this program enrollment. Used for payment tracking and schedule management.',
  `next_payment_date` DATE COMMENT 'Date when the next incentive payment is scheduled to be disbursed to this account for this program enrollment, based on the payment_schedule and compliance_status.',
  `payment_schedule` STRING COMMENT 'Schedule on which incentive payments will be disbursed to this account for this program enrollment. Determines payment frequency and timing for this specific enrollment.',
  `rec_transfer_agreement_signed` BOOLEAN COMMENT 'Indicates whether the customer has signed the Renewable Energy Certificate (REC) transfer agreement required for this program enrollment. Required for programs where requires_rec_transfer is true.',
  `remaining_balance` DECIMAL(18,2) COMMENT 'Remaining dollar amount of approved incentive funding that has not yet been paid to this account for this program enrollment in USD. Calculated as approved_amount minus total_paid_amount.',
  `technology_type` STRING COMMENT 'Specific renewable energy technology type for which this account is receiving incentives under this program enrollment. Must match one of the eligible_technology_types for the program.',
  `termination_date` DATE COMMENT 'Date when this account\'s enrollment in this incentive program was terminated, either due to program completion, non-compliance, or voluntary withdrawal. Null for active enrollments.',
  `termination_reason` STRING COMMENT 'Reason code or description explaining why this enrollment was terminated. Examples include program_completed, non_compliance, customer_withdrawal, program_expired, system_decommissioned.',
  `total_paid_amount` DECIMAL(18,2) COMMENT 'Cumulative dollar amount of incentive payments that have been disbursed to this account for this program enrollment to date in USD. Used for budget tracking and payment reconciliation.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_incentive_enrollment` PRIMARY KEY (`incentive_enrollment_id`)
)
USING DELTA
COMMENT 'This association product represents the enrollment contract between a utility customer account and a renewable energy incentive program. It captures the application, approval, payment tracking, and compliance verification lifecycle for each account\'s participation in each incentive program. Each record links one account to one incentive program with attributes that exist only in the context of this specific enrollment relationship, including application details, approved funding amounts, payment schedules, disbursement tracking, and ongoing compliance status.. Existence Justification: In utility renewable energy operations, a customer account can simultaneously participate in multiple incentive programs (e.g., a residential customer with solar PV enrolled in both an ITC rebate program and an SREC program, plus a separate battery storage incentive). Conversely, each incentive program serves hundreds or thousands of customer accounts. The utility actively manages these enrollments as operational business entities, tracking application workflows, approval processes, payment disbursements, compliance verification, and budget allocation for each account-program combination. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'IncentiveEnrollment',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.incentive_enrollment'
);

-- PremiseAssetConnection  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `customer`.`premise_asset_connection` (
  `premise_asset_connection_id` BIGINT NOT NULL COMMENT 'Primary key for the premise_asset_connection association',
  `metering_point_id` BIGINT COMMENT 'Identifier of the specific metering point or meter socket associated with this premise-asset connection. Links to metering infrastructure for billing and load monitoring',
  `premise_id` BIGINT COMMENT 'Foreign key linking to the premise receiving utility service',
  `registry_id` BIGINT COMMENT 'Foreign key linking to the utility asset providing service',
  `capacity_allocation_kva` DECIMAL(12,3) COMMENT 'Allocated transformer capacity in kilovolt-amperes (kVA) reserved for this premise on this asset. Used for load planning and capacity management when multiple premises share a transformer',
  `connection_date` DATE COMMENT 'Date when this premise was physically connected to this specific asset for service delivery',
  `connection_status` STRING COMMENT 'Current operational status of this service connection (active and energized, inactive/disconnected, temporarily suspended, or pending activation)',
  `connection_type` STRING COMMENT 'Classification of the service connection relationship (primary service path, secondary/redundant path, backup connection, or temporary connection during maintenance)',
  `disconnection_date` DATE COMMENT 'Date when this premise was disconnected from this specific asset (due to asset retirement, premise reconfiguration, or grid topology changes). Null if connection is currently active',
  `service_voltage` DECIMAL(10,2) COMMENT 'Actual voltage delivered at this specific premise-asset connection point in volts. May differ from premise service_voltage_class due to transformer configuration or multi-voltage service',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_premise_asset_connection` PRIMARY KEY (`premise_asset_connection_id`)
)
USING DELTA
COMMENT 'This association product represents the physical service connection between a premise and utility assets. It captures the operational topology of how distribution assets (transformers, poles, service vaults) deliver electric service to customer premises. Each record links one premise to one asset with connection-specific attributes including service voltage, capacity allocation, connection dates, and metering configuration that exist only in the context of this service relationship.. Existence Justification: In utility distribution operations, a single premise is routinely served by multiple physical assets: a primary distribution transformer, potentially a secondary/backup transformer for redundancy, service poles, service vaults, and switchgear. Conversely, a single distribution transformer typically serves 5-50 premises (residential) or multiple commercial premises. The service connection topology is actively managed by distribution engineering and outage management teams, with connection-specific data including service voltage, capacity allocation, connection/disconnection dates, metering point configuration, and connection status (active/backup/temporary). | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PremiseAssetConnection',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.premise_asset_connection'
);

-- PremiseServiceContract  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `customer`.`premise_service_contract` (
  `premise_service_contract_id` BIGINT NOT NULL COMMENT 'Unique identifier for this premise-vendor service contract record. Primary key.',
  `premise_id` BIGINT COMMENT 'Foreign key linking to the premise receiving vendor services under this contract',
  `vendor_id` BIGINT COMMENT 'Foreign key linking to the vendor providing services under this contract',
  `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether this service contract automatically renews at the end of the contract term unless explicitly cancelled. Used for contract management and renewal tracking.',
  `billing_frequency` STRING COMMENT 'Frequency at which the vendor invoices for services under this contract. Defines the billing cycle for this premise-vendor service relationship.',
  `contract_end_date` DATE COMMENT 'Expiration or termination date of the service contract. Used for contract renewal tracking and vendor performance evaluation scheduling.',
  `contract_start_date` DATE COMMENT 'Effective start date of the service contract. Defines when vendor service obligations begin for this premise.',
  `contract_status` STRING COMMENT 'Current lifecycle status of the service contract. ACTIVE = contract in force, EXPIRED = contract term ended, TERMINATED = contract cancelled before end date, SUSPENDED = services temporarily halted, PENDING_RENEWAL = approaching expiration and under renewal negotiation.',
  `contract_value` DECIMAL(15,2) COMMENT 'Total monetary value of the service contract in the vendor\'s currency. Represents the committed spend for vendor services at this premise over the contract period. Used for budget tracking and vendor spend analysis.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this service contract record was created in the system.',
  `last_service_date` DATE COMMENT 'Date of the most recent service visit or maintenance activity performed by the vendor at this premise under this contract. Used for service frequency tracking and compliance monitoring.',
  `next_scheduled_service_date` DATE COMMENT 'Date of the next planned preventive maintenance or service visit by the vendor at this premise. Used for service scheduling and coordination.',
  `primary_contact_name` STRING COMMENT 'Name of the vendor\'s primary service contact assigned to this premise. The technician or account manager responsible for service delivery at this specific location.',
  `primary_contact_phone` STRING COMMENT 'Phone number of the vendor\'s primary service contact for this premise. Used for emergency service requests and routine coordination.',
  `response_time_sla_hours` DECIMAL(6,2) COMMENT 'Service Level Agreement response time in hours. Defines the maximum time the vendor has to respond to a service request or emergency call for this premise. Used for SLA compliance monitoring.',
  `service_contract_number` STRING COMMENT 'Business identifier for the service contract as assigned by procurement or vendor management. Externally known contract reference number used in invoicing and service tickets.',
  `service_type` STRING COMMENT 'Classification of the service provided under this contract. Defines the scope of vendor responsibilities for this premise (e.g., HVAC maintenance, generator service, substation maintenance, emergency restoration).',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this service contract record was last modified.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_premise_service_contract` PRIMARY KEY (`premise_service_contract_id`)
)
USING DELTA
COMMENT 'This association product represents the service contract relationship between a premise and a vendor. It captures vendor-provided maintenance and service agreements for specific premises, including HVAC maintenance, generator service, substation maintenance, and emergency restoration services. Each record links one premise to one vendor with contract-specific terms, SLAs, service scope, and commercial terms that exist only in the context of this contractual relationship.. Existence Justification: In utility operations, large commercial and industrial premises routinely have multiple concurrent service contracts with different vendors (e.g., one vendor for HVAC maintenance, another for generator service, a third for substation maintenance). Simultaneously, each vendor serves multiple premises across the utility\'s service territory. The business actively manages these service contracts as operational entities with contract-specific terms, SLAs, service scopes, and performance tracking. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PremiseServiceContract',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.premise_service_contract'
);

-- CustomerDrEnrollment  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `customer`.`customer_dr_enrollment` (
  `customer_dr_enrollment_id` BIGINT NOT NULL COMMENT 'Primary key for customer_dr_enrollment',
  `dr_enrollment_id` BIGINT COMMENT 'Unique surrogate identifier for this demand response enrollment record. Primary key.',
  `dr_program_id` BIGINT COMMENT 'Foreign key linking to the demand response program in which the premise is enrolled',
  `premise_id` BIGINT COMMENT 'Foreign key linking to the premise enrolled in the demand response program',
  `baseline_calculation_method` STRING COMMENT 'Premise-specific override of the baseline calculation methodology used for this enrollment. Allows individual premises to use different baseline methods than the program default when justified by meter configuration, load volatility, or regulatory requirements. If null, inherits from dr_program.baseline_calculation_method.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this enrollment record was created in the system',
  `demand_response_enrolled` BOOLEAN COMMENT 'Indicates whether the premise is currently enrolled in a utility Demand Response (DR) or load control program. Supports DR dispatch eligibility, load curtailment planning, and RTO/ISO demand response market participation reporting. [Moved from premise: This boolean flag on premise indicates whether the premise is enrolled in ANY DR program. This is a derived/aggregated attribute that can be calculated from the existence of active dr_enrollment records. It does not belong on the premise master record—it should be derived from the enrollment association. Removing this flag enforces single source of truth in the enrollment table.]',
  `enrolled_load_capacity_kw` DECIMAL(12,3) COMMENT 'Premise-specific committed load reduction capacity in kilowatts for this enrollment. Represents the load curtailment the premise has agreed to provide when DR events are dispatched. Aggregated across all enrollments to calculate program-level enrolled_capacity_actual_mw.',
  `enrollment_channel` STRING COMMENT 'Channel through which this premise was enrolled in the DR program. Used for marketing attribution, enrollment cost analysis, and channel effectiveness measurement.',
  `enrollment_effective_date` DATE COMMENT 'Date when this premise enrollment becomes active and the premise is eligible for DR event dispatch and incentive payments. Must fall within the parent dr_program effective date range.',
  `enrollment_end_date` DATE COMMENT 'Date when this premise enrollment terminates. Null for open-ended enrollments. Used to track enrollment history and calculate active enrollment counts.',
  `enrollment_status` STRING COMMENT 'Current lifecycle status of this enrollment. Active indicates premise is eligible for dispatch. Suspended indicates temporary ineligibility (e.g., equipment failure, customer request). Terminated indicates permanent end. Pending Activation indicates enrollment approved but not yet effective.',
  `incentive_override_amount` DECIMAL(15,2) COMMENT 'Premise-specific incentive amount override. If populated, this value supersedes the program-level dr_program.incentive_amount for this enrollment. Used for negotiated rates with large commercial/industrial customers or pilot program participants. Null indicates use of program default.',
  `participation_rate_percent` DECIMAL(5,2) COMMENT 'Historical participation rate percentage for this premise across past DR events in this program. Calculated as (number of events participated / number of events dispatched) * 100. Used for performance tracking, incentive adjustments, and enrollment retention analysis.',
  `telemetry_enabled_flag` BOOLEAN COMMENT 'Indicates whether real-time telemetry data (AMI interval data, DER telemetry, or SCADA signals) is enabled for this premise enrollment. Required for direct load control programs and VPP aggregation. Determines whether premise participates in automated dispatch or manual notification-based DR.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this enrollment record was last modified',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_customer_dr_enrollment` PRIMARY KEY (`customer_dr_enrollment_id`)
)
USING DELTA
COMMENT 'This association product represents the enrollment contract between a premise and a demand response program. It captures premise-specific participation terms, load capacity commitments, telemetry configuration, and baseline methodology overrides. Each record links one premise to one DR program with attributes that exist only in the context of this enrollment relationship. SSOT for all premise-level DR participation tracking.. Existence Justification: In utility demand response operations, premises participate in multiple DR programs simultaneously (e.g., a commercial premise enrolled in both an interruptible tariff program and a behavioral DR campaign), and each DR program enrolls thousands of premises across the service territory. The enrollment relationship is an operational business entity that DR program managers actively create, monitor, and terminate, with premise-specific attributes like committed load capacity, telemetry configuration, and baseline methodology overrides. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CustomerDrEnrollment',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.customer_dr_enrollment'
);

-- CustomerCase  <<CIM TroubleTicket : close>>
CREATE TABLE IF NOT EXISTS `customer`.`case` (
  `case_id` BIGINT NOT NULL COMMENT 'Primary key for case',
  `employee_id` BIGINT COMMENT 'Identifier of the individual support agent assigned to the case.',
  `meter_id` BIGINT COMMENT 'Identifier of the utility meter associated with the case, if applicable.',
  `profile_id` BIGINT COMMENT 'Identifier of the customer who owns the case.',
  `parent_case_id` BIGINT COMMENT 'Self-referencing FK on case (parent_case_id)',
  `amount_gross` DECIMAL(12,2) COMMENT 'Total gross monetary amount associated with the case (e.g., fees before taxes).',
  `amount_net` DECIMAL(12,2) COMMENT 'Net monetary amount after taxes and adjustments.',
  `amount_tax` DECIMAL(12,2) COMMENT 'Tax component applied to the case monetary amount.',
  `assigned_group` STRING COMMENT 'Internal support group or department responsible for handling the case.',
  `attachment_count` INT COMMENT 'Number of files or documents attached to the case.',
  `case_number` STRING COMMENT 'Business-visible alphanumeric case number assigned at creation.',
  `case_type` STRING COMMENT 'Category describing the nature of the case.',
  `closed_date` DATE COMMENT 'Date on which the case was officially closed.',
  `compliance_status` STRING COMMENT 'Current compliance state of the case with relevant regulations.',
  `cost_actual` DECIMAL(12,2) COMMENT 'Final cost incurred to resolve the case.',
  `cost_estimate` DECIMAL(12,2) COMMENT 'Estimated cost associated with resolving the case.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for monetary values.',
  `description` STRING COMMENT 'Detailed narrative provided by the customer describing the issue or request.',
  `due_date` DATE COMMENT 'Target date by which the case is expected to be resolved.',
  `escalation_flag` BOOLEAN COMMENT 'Indicates whether the case has been escalated to a higher support tier.',
  `estimated_restoration_time` TIMESTAMP COMMENT 'Projected timestamp for service restoration communicated to the customer.',
  `external_reference_number` STRING COMMENT 'Reference number from an external system (e.g., regulator, partner).',
  `field_technician_notes` STRING COMMENT 'Notes entered by field personnel during on-site work.',
  `opened_timestamp` TIMESTAMP COMMENT 'Timestamp when the case was initially opened.',
  `outage_end` TIMESTAMP COMMENT 'Timestamp when the outage was restored.',
  `outage_flag` BOOLEAN COMMENT 'True if the case pertains to a service outage.',
  `outage_start` TIMESTAMP COMMENT 'Timestamp when the reported outage began.',
  `priority` STRING COMMENT 'Business-assigned priority indicating urgency.',
  `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the case record was first captured in the system.',
  `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the case record.',
  `regulatory_flag` BOOLEAN COMMENT 'True if the case is subject to regulatory reporting or compliance.',
  `resolution_description` STRING COMMENT 'Narrative of how the case was resolved or closed.',
  `sla_actual_hours` INT COMMENT 'Actual time taken to resolve the case in hours.',
  `sla_target_hours` INT COMMENT 'Service Level Agreement target resolution time in hours.',
  `source_channel` STRING COMMENT 'Origin channel through which the case was submitted.',
  `status` STRING COMMENT 'Current lifecycle status of the case.',
  `warranty_flag` BOOLEAN COMMENT 'Indicates whether the case involves warranty-covered equipment.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_case` PRIMARY KEY (`case_id`)
)
USING DELTA
COMMENT 'Master reference table for case. Referenced by case_id. | CMM: CIM TroubleTicket (close), IEC61968::Customers.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CustomerCase',
  'cmm.cim.class' = 'TroubleTicket',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Customers',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.case'
);

-- FieldOrder  <<CIM WorkTask : close>>
CREATE TABLE IF NOT EXISTS `customer`.`field_order` (
  `field_order_id` BIGINT NOT NULL COMMENT 'Primary key for field_order',
  `address_id` BIGINT COMMENT 'Identifier of the physical location where the field work is to be performed.',
  `assigned_crew_id` BIGINT COMMENT 'Identifier of the crew assigned to execute the field order.',
  `billing_account_id` BIGINT COMMENT 'Identifier of the billing account to which charges are applied.',
  `employee_id` BIGINT COMMENT 'Identifier of the system user who created the field order.',
  `last_modified_by_user_employee_id` BIGINT COMMENT 'Identifier of the system user who last modified the field order.',
  `meter_id` BIGINT COMMENT 'Identifier of the meter associated with the field order, if applicable.',
  `profile_id` BIGINT COMMENT 'Identifier of the customer associated with the field order.',
  `registry_id` BIGINT COMMENT 'Identifier of the asset related to the field order.',
  `follow_up_field_order_id` BIGINT COMMENT 'Self-referencing FK on field_order (follow_up_field_order_id)',
  `actual_duration_minutes` INT COMMENT 'Actual time taken to complete the field work.',
  `actual_end_timestamp` TIMESTAMP COMMENT 'Actual date and time when field work was completed.',
  `actual_start_timestamp` TIMESTAMP COMMENT 'Actual date and time when field work commenced.',
  `amount_adjustments` DECIMAL(18,2) COMMENT 'Sum of monetary adjustments (taxes, fees, discounts) applied to the field order.',
  `amount_gross` DECIMAL(18,2) COMMENT 'Total gross monetary amount before adjustments for the field order.',
  `amount_net` DECIMAL(18,2) COMMENT 'Final net monetary amount after adjustments for the field order.',
  `approval_status` STRING COMMENT 'Current approval state of the field order.',
  `approval_timestamp` TIMESTAMP COMMENT 'Timestamp when the field order was approved.',
  `approved_by` STRING COMMENT 'Name or identifier of the person who approved the field order.',
  `compliance_flag` BOOLEAN COMMENT 'Indicates if the field order complies with regulatory requirements.',
  `cost_center_code` STRING COMMENT 'Internal cost center code for financial tracking of the field order.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the field order record was first captured in the system.',
  `currency_code` STRING COMMENT 'Three-letter ISO currency code for the monetary amounts.',
  `dispatch_method` STRING COMMENT 'Method used to dispatch the field order to a crew.',
  `estimated_duration_minutes` INT COMMENT 'Estimated time required to complete the field work.',
  `external_order_reference` STRING COMMENT 'Reference to an external order system identifier.',
  `external_system_ref` STRING COMMENT 'Reference identifier from an external system linked to this field order.',
  `field_order_version` INT COMMENT 'Version number for optimistic concurrency control.',
  `is_billable` BOOLEAN COMMENT 'Indicates whether the field order is billable to the customer.',
  `is_deleted` BOOLEAN COMMENT 'Soft delete indicator for the field order record.',
  `is_emergency` BOOLEAN COMMENT 'Indicates whether the field order is an emergency response.',
  `notes` STRING COMMENT 'Free-form notes related to the field order.',
  `order_number` STRING COMMENT 'External reference number assigned to the field order.',
  `order_timestamp` TIMESTAMP COMMENT 'Timestamp when the field order was created or placed.',
  `priority` STRING COMMENT 'Priority assigned to the field order indicating urgency.',
  `regulatory_status` STRING COMMENT 'Regulatory compliance status of the field order.',
  `required_permits` STRING COMMENT 'List of permits required to perform the field work.',
  `safety_risk_level` STRING COMMENT 'Assessed safety risk level for the field work.',
  `scheduled_end_timestamp` TIMESTAMP COMMENT 'Planned end date and time for the field work.',
  `scheduled_start_timestamp` TIMESTAMP COMMENT 'Planned start date and time for the field work.',
  `service_type` STRING COMMENT 'Category of service to be performed in the field order.',
  `status` STRING COMMENT 'Current lifecycle status of the field order.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the field order record.',
  `work_description` STRING COMMENT 'Detailed description of the tasks to be performed.',
  `work_order_type` STRING COMMENT 'Classification of the work order based on planning horizon.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_field_order` PRIMARY KEY (`field_order_id`)
)
USING DELTA
COMMENT 'Master reference table for field_order. Referenced by field_order_id. | CMM: CIM WorkTask (close), IEC61968::Work.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'FieldOrder',
  'cmm.cim.class' = 'WorkTask',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Work',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.field_order'
);

-- ServiceLevelAgreement  <<CIM ServiceGuarantee : close>>
CREATE TABLE IF NOT EXISTS `customer`.`service_level_agreement` (
  `service_level_agreement_id` BIGINT NOT NULL COMMENT 'Primary key for service_level_agreement',
  `superseded_service_level_agreement_id` BIGINT COMMENT 'Self-referencing FK on service_level_agreement (superseded_service_level_agreement_id)',
  `availability_target` DECIMAL(5,2) COMMENT 'Target service availability expressed as a percentage.',
  `compliance_requirements` STRING COMMENT 'Regulatory or internal compliance obligations tied to the SLA.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the SLA record was created.',
  `description` STRING COMMENT 'Detailed description of the SLA scope and purpose.',
  `effective_from` DATE COMMENT 'Date when the SLA becomes binding.',
  `effective_until` DATE COMMENT 'Date when the SLA expires or is terminated (null for open-ended).',
  `escalation_contact_email` STRING COMMENT 'Email address for the escalation contact.',
  `escalation_contact_name` STRING COMMENT 'Name of the person to contact for SLA escalations.',
  `escalation_contact_phone` STRING COMMENT 'Phone number for the escalation contact.',
  `measurement_frequency` STRING COMMENT 'How often SLA performance is measured.',
  `measurement_units` STRING COMMENT 'Units used for SLA metrics (e.g., percent, seconds).',
  `monitoring_contact_email` STRING COMMENT 'Email address for the monitoring contact.',
  `monitoring_contact_name` STRING COMMENT 'Name of the person responsible for monitoring SLA performance.',
  `monitoring_contact_phone` STRING COMMENT 'Phone number for the monitoring contact.',
  `name` STRING COMMENT 'Human-readable name of the SLA.',
  `notes` STRING COMMENT 'Free-form notes or comments about the SLA.',
  `penalty_amount` DECIMAL(12,2) COMMENT 'Monetary penalty applied for SLA breach.',
  `penalty_currency` STRING COMMENT 'Currency code for the penalty amount.',
  `priority` STRING COMMENT 'Business priority assigned to the SLA.',
  `regulatory_reporting_flag` BOOLEAN COMMENT 'Indicates whether the SLA is subject to regulatory reporting.',
  `resolution_time_target_seconds` INT COMMENT 'Maximum allowed time to resolve an incident.',
  `response_time_target_seconds` INT COMMENT 'Maximum allowed time to respond to a service request.',
  `service_type` STRING COMMENT 'Utility service type to which the SLA applies.',
  `sla_number` STRING COMMENT 'External reference number assigned to the SLA by the business.',
  `status` STRING COMMENT 'Current lifecycle state of the SLA.',
  `type` STRING COMMENT 'Category of service covered by the SLA.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the SLA record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_service_level_agreement` PRIMARY KEY (`service_level_agreement_id`)
)
USING DELTA
COMMENT 'Master reference table for service_level_agreement. Referenced by service_level_agreement_id. | CMM: CIM ServiceGuarantee (close), IEC61968::InfCustomers.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ServiceLevelAgreement',
  'cmm.cim.class' = 'ServiceGuarantee',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfCustomers',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.service_level_agreement'
);

-- NotificationPreference  <<CIM CustomerNotification : close>>
CREATE TABLE IF NOT EXISTS `customer`.`notification_preference` (
  `notification_preference_id` BIGINT NOT NULL COMMENT 'Primary key for notification_preference',
  `superseded_notification_preference_id` BIGINT COMMENT 'Self-referencing FK on notification_preference (superseded_notification_preference_id)',
  `channel_type` STRING COMMENT 'The communication channel through which the notification is delivered.',
  `code` STRING COMMENT 'Compact alphanumeric code used to reference the notification preference in downstream systems.',
  `compliance_flag` STRING COMMENT 'Indicates the regulatory regime governing this notification preference.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the preference record was first created in the system.',
  `delivery_method` STRING COMMENT 'Indicates whether the notification is sent automatically by the system or manually by an operator.',
  `description` STRING COMMENT 'Detailed description of what the notification preference entails and when it is used.',
  `effective_from` DATE COMMENT 'Date on which the notification preference becomes active.',
  `effective_until` DATE COMMENT 'Date after which the notification preference is no longer valid; null if open-ended.',
  `format` STRING COMMENT 'Specifies whether the notification content is formatted as HTML or plain text.',
  `is_default` BOOLEAN COMMENT 'True if this preference is the default option for customers who have not selected a specific preference.',
  `is_opt_in_required` BOOLEAN COMMENT 'True if customers must explicitly opt-in to receive notifications via this channel.',
  `language` STRING COMMENT 'ISO 639-1 two-letter code representing the language of the notification content.',
  `max_retry_attempts` INT COMMENT 'Maximum number of retry attempts if delivery fails.',
  `name` STRING COMMENT 'Human-readable name of the notification preference.',
  `priority_order` INT COMMENT 'Numeric rank used to order preferences when multiple are applicable; lower numbers indicate higher priority.',
  `regulatory_reference` STRING COMMENT 'Reference to the specific regulation or policy that mandates this notification preference.',
  `retry_interval_minutes` INT COMMENT 'Number of minutes to wait between successive retry attempts.',
  `status` STRING COMMENT 'Current lifecycle status of the notification preference.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the preference record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_customer_notification_preference` PRIMARY KEY (`notification_preference_id`)
)
USING DELTA
COMMENT 'Master reference table for notification_preference. Referenced by customer_preference_id. | CMM: CIM CustomerNotification (close), IEC61968::Customers.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'NotificationPreference',
  'cmm.cim.class' = 'CustomerNotification',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Customers',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.customer.notification_preference'
);

-- ========= FOREIGN KEYS within customer (74) =========
ALTER TABLE `customer`.`account` DROP CONSTRAINT IF EXISTS `fk_customer_account_account_profile_id`;
ALTER TABLE `customer`.`account` ADD CONSTRAINT `fk_customer_account_account_profile_id` FOREIGN KEY (`account_profile_id`) REFERENCES `customer`.`profile` (`profile_id`);

ALTER TABLE `customer`.`account` DROP CONSTRAINT IF EXISTS `fk_customer_account_billing_address_id`;
ALTER TABLE `customer`.`account` ADD CONSTRAINT `fk_customer_account_billing_address_id` FOREIGN KEY (`billing_address_id`) REFERENCES `customer`.`address` (`address_id`);

ALTER TABLE `customer`.`account` DROP CONSTRAINT IF EXISTS `fk_customer_account_parent_account_id`;
ALTER TABLE `customer`.`account` ADD CONSTRAINT `fk_customer_account_parent_account_id` FOREIGN KEY (`parent_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`account` DROP CONSTRAINT IF EXISTS `fk_customer_account_premise_id`;
ALTER TABLE `customer`.`account` ADD CONSTRAINT `fk_customer_account_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `customer`.`account` DROP CONSTRAINT IF EXISTS `fk_customer_account_to_profile_id`;
ALTER TABLE `customer`.`account` ADD CONSTRAINT `fk_customer_account_to_profile_id` FOREIGN KEY (`to_profile_id`) REFERENCES `customer`.`profile` (`profile_id`);

ALTER TABLE `customer`.`profile` DROP CONSTRAINT IF EXISTS `fk_customer_profile_mailing_address_id`;
ALTER TABLE `customer`.`profile` ADD CONSTRAINT `fk_customer_profile_mailing_address_id` FOREIGN KEY (`mailing_address_id`) REFERENCES `customer`.`address` (`address_id`);

ALTER TABLE `customer`.`customer_service_agreement` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_agreement_customer_account_id`;
ALTER TABLE `customer`.`customer_service_agreement` ADD CONSTRAINT `fk_customer_customer_service_agreement_customer_account_id` FOREIGN KEY (`customer_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`customer_service_agreement` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_agreement_customer_premise_id`;
ALTER TABLE `customer`.`customer_service_agreement` ADD CONSTRAINT `fk_customer_customer_service_agreement_customer_premise_id` FOREIGN KEY (`customer_premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `customer`.`customer_service_agreement` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_agreement_premise_id`;
ALTER TABLE `customer`.`customer_service_agreement` ADD CONSTRAINT `fk_customer_customer_service_agreement_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `customer`.`customer_service_agreement` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_agreement_primary_customer_account_id`;
ALTER TABLE `customer`.`customer_service_agreement` ADD CONSTRAINT `fk_customer_customer_service_agreement_primary_customer_account_id` FOREIGN KEY (`primary_customer_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`customer_service_agreement` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_agreement_service_level_agreement_id`;
ALTER TABLE `customer`.`customer_service_agreement` ADD CONSTRAINT `fk_customer_customer_service_agreement_service_level_agreement_id` FOREIGN KEY (`service_level_agreement_id`) REFERENCES `customer`.`service_level_agreement` (`service_level_agreement_id`);

ALTER TABLE `customer`.`contact` DROP CONSTRAINT IF EXISTS `fk_customer_contact_contact_account_id`;
ALTER TABLE `customer`.`contact` ADD CONSTRAINT `fk_customer_contact_contact_account_id` FOREIGN KEY (`contact_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`contact` DROP CONSTRAINT IF EXISTS `fk_customer_contact_contact_profile_id`;
ALTER TABLE `customer`.`contact` ADD CONSTRAINT `fk_customer_contact_contact_profile_id` FOREIGN KEY (`contact_profile_id`) REFERENCES `customer`.`profile` (`profile_id`);

ALTER TABLE `customer`.`contact` DROP CONSTRAINT IF EXISTS `fk_customer_contact_postal_address_id`;
ALTER TABLE `customer`.`contact` ADD CONSTRAINT `fk_customer_contact_postal_address_id` FOREIGN KEY (`postal_address_id`) REFERENCES `customer`.`address` (`address_id`);

ALTER TABLE `customer`.`contact` DROP CONSTRAINT IF EXISTS `fk_customer_contact_to_account_id`;
ALTER TABLE `customer`.`contact` ADD CONSTRAINT `fk_customer_contact_to_account_id` FOREIGN KEY (`to_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`contact` DROP CONSTRAINT IF EXISTS `fk_customer_contact_to_profile_id`;
ALTER TABLE `customer`.`contact` ADD CONSTRAINT `fk_customer_contact_to_profile_id` FOREIGN KEY (`to_profile_id`) REFERENCES `customer`.`profile` (`profile_id`);

ALTER TABLE `customer`.`address` DROP CONSTRAINT IF EXISTS `fk_customer_address_premise_id`;
ALTER TABLE `customer`.`address` ADD CONSTRAINT `fk_customer_address_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `customer`.`account_premise_link` DROP CONSTRAINT IF EXISTS `fk_customer_account_premise_link_account_premise_id`;
ALTER TABLE `customer`.`account_premise_link` ADD CONSTRAINT `fk_customer_account_premise_link_account_premise_id` FOREIGN KEY (`account_premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `customer`.`account_premise_link` DROP CONSTRAINT IF EXISTS `fk_customer_account_premise_link_customer_service_agreement_id`;
ALTER TABLE `customer`.`account_premise_link` ADD CONSTRAINT `fk_customer_account_premise_link_customer_service_agreement_id` FOREIGN KEY (`customer_service_agreement_id`) REFERENCES `customer`.`customer_service_agreement` (`customer_service_agreement_id`);

ALTER TABLE `customer`.`account_premise_link` DROP CONSTRAINT IF EXISTS `fk_customer_account_premise_link_forwarding_address_id`;
ALTER TABLE `customer`.`account_premise_link` ADD CONSTRAINT `fk_customer_account_premise_link_forwarding_address_id` FOREIGN KEY (`forwarding_address_id`) REFERENCES `customer`.`address` (`address_id`);

ALTER TABLE `customer`.`account_premise_link` DROP CONSTRAINT IF EXISTS `fk_customer_account_premise_link_primary_account_id`;
ALTER TABLE `customer`.`account_premise_link` ADD CONSTRAINT `fk_customer_account_premise_link_primary_account_id` FOREIGN KEY (`primary_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`account_premise_link` DROP CONSTRAINT IF EXISTS `fk_customer_account_premise_link_primary_account_move_order_id`;
ALTER TABLE `customer`.`account_premise_link` ADD CONSTRAINT `fk_customer_account_premise_link_primary_account_move_order_id` FOREIGN KEY (`primary_account_move_order_id`) REFERENCES `customer`.`move_order` (`move_order_id`);

ALTER TABLE `customer`.`account_premise_link` DROP CONSTRAINT IF EXISTS `fk_customer_account_premise_link_tertiary_tenant_account_id`;
ALTER TABLE `customer`.`account_premise_link` ADD CONSTRAINT `fk_customer_account_premise_link_tertiary_tenant_account_id` FOREIGN KEY (`tertiary_tenant_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`account_premise_link` DROP CONSTRAINT IF EXISTS `fk_customer_account_premise_link_to_premise_id`;
ALTER TABLE `customer`.`account_premise_link` ADD CONSTRAINT `fk_customer_account_premise_link_to_premise_id` FOREIGN KEY (`to_premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `customer`.`credit_profile` DROP CONSTRAINT IF EXISTS `fk_customer_credit_profile_credit_account_id`;
ALTER TABLE `customer`.`credit_profile` ADD CONSTRAINT `fk_customer_credit_profile_credit_account_id` FOREIGN KEY (`credit_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`credit_profile` DROP CONSTRAINT IF EXISTS `fk_customer_credit_profile_to_account_id`;
ALTER TABLE `customer`.`credit_profile` ADD CONSTRAINT `fk_customer_credit_profile_to_account_id` FOREIGN KEY (`to_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`segment` DROP CONSTRAINT IF EXISTS `fk_customer_segment_account_id`;
ALTER TABLE `customer`.`segment` ADD CONSTRAINT `fk_customer_segment_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`customer_service_request` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_request_account_id`;
ALTER TABLE `customer`.`customer_service_request` ADD CONSTRAINT `fk_customer_customer_service_request_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`customer_service_request` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_request_contact_id`;
ALTER TABLE `customer`.`customer_service_request` ADD CONSTRAINT `fk_customer_customer_service_request_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `customer`.`contact` (`contact_id`);

ALTER TABLE `customer`.`customer_service_request` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_request_customer_service_agreement_id`;
ALTER TABLE `customer`.`customer_service_request` ADD CONSTRAINT `fk_customer_customer_service_request_customer_service_agreement_id` FOREIGN KEY (`customer_service_agreement_id`) REFERENCES `customer`.`customer_service_agreement` (`customer_service_agreement_id`);

ALTER TABLE `customer`.`customer_service_request` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_request_premise_id`;
ALTER TABLE `customer`.`customer_service_request` ADD CONSTRAINT `fk_customer_customer_service_request_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `customer`.`interaction` DROP CONSTRAINT IF EXISTS `fk_customer_interaction_case_id`;
ALTER TABLE `customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_case_id` FOREIGN KEY (`case_id`) REFERENCES `customer`.`case` (`case_id`);

ALTER TABLE `customer`.`interaction` DROP CONSTRAINT IF EXISTS `fk_customer_interaction_complaint_id`;
ALTER TABLE `customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_complaint_id` FOREIGN KEY (`complaint_id`) REFERENCES `customer`.`complaint` (`complaint_id`);

ALTER TABLE `customer`.`interaction` DROP CONSTRAINT IF EXISTS `fk_customer_interaction_customer_service_request_id`;
ALTER TABLE `customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_customer_service_request_id` FOREIGN KEY (`customer_service_request_id`) REFERENCES `customer`.`customer_service_request` (`customer_service_request_id`);

ALTER TABLE `customer`.`interaction` DROP CONSTRAINT IF EXISTS `fk_customer_interaction_interaction_account_id`;
ALTER TABLE `customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_interaction_account_id` FOREIGN KEY (`interaction_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`interaction` DROP CONSTRAINT IF EXISTS `fk_customer_interaction_profile_id`;
ALTER TABLE `customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `customer`.`profile` (`profile_id`);

ALTER TABLE `customer`.`interaction` DROP CONSTRAINT IF EXISTS `fk_customer_interaction_to_account_id`;
ALTER TABLE `customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_to_account_id` FOREIGN KEY (`to_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`complaint` DROP CONSTRAINT IF EXISTS `fk_customer_complaint_complaint_account_id`;
ALTER TABLE `customer`.`complaint` ADD CONSTRAINT `fk_customer_complaint_complaint_account_id` FOREIGN KEY (`complaint_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`complaint` DROP CONSTRAINT IF EXISTS `fk_customer_complaint_customer_service_agreement_id`;
ALTER TABLE `customer`.`complaint` ADD CONSTRAINT `fk_customer_complaint_customer_service_agreement_id` FOREIGN KEY (`customer_service_agreement_id`) REFERENCES `customer`.`customer_service_agreement` (`customer_service_agreement_id`);

ALTER TABLE `customer`.`complaint` DROP CONSTRAINT IF EXISTS `fk_customer_complaint_premise_id`;
ALTER TABLE `customer`.`complaint` ADD CONSTRAINT `fk_customer_complaint_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `customer`.`complaint` DROP CONSTRAINT IF EXISTS `fk_customer_complaint_prior_complaint_id`;
ALTER TABLE `customer`.`complaint` ADD CONSTRAINT `fk_customer_complaint_prior_complaint_id` FOREIGN KEY (`prior_complaint_id`) REFERENCES `customer`.`complaint` (`complaint_id`);

ALTER TABLE `customer`.`complaint` DROP CONSTRAINT IF EXISTS `fk_customer_complaint_profile_id`;
ALTER TABLE `customer`.`complaint` ADD CONSTRAINT `fk_customer_complaint_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `customer`.`profile` (`profile_id`);

ALTER TABLE `customer`.`complaint` DROP CONSTRAINT IF EXISTS `fk_customer_complaint_to_account_id`;
ALTER TABLE `customer`.`complaint` ADD CONSTRAINT `fk_customer_complaint_to_account_id` FOREIGN KEY (`to_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`customer_enrollment` DROP CONSTRAINT IF EXISTS `fk_customer_customer_enrollment_account_id`;
ALTER TABLE `customer`.`customer_enrollment` ADD CONSTRAINT `fk_customer_customer_enrollment_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`customer_enrollment` DROP CONSTRAINT IF EXISTS `fk_customer_customer_enrollment_customer_service_agreement_id`;
ALTER TABLE `customer`.`customer_enrollment` ADD CONSTRAINT `fk_customer_customer_enrollment_customer_service_agreement_id` FOREIGN KEY (`customer_service_agreement_id`) REFERENCES `customer`.`customer_service_agreement` (`customer_service_agreement_id`);

ALTER TABLE `customer`.`customer_enrollment` DROP CONSTRAINT IF EXISTS `fk_customer_customer_enrollment_premise_id`;
ALTER TABLE `customer`.`customer_enrollment` ADD CONSTRAINT `fk_customer_customer_enrollment_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `customer`.`customer_enrollment` DROP CONSTRAINT IF EXISTS `fk_customer_customer_enrollment_profile_id`;
ALTER TABLE `customer`.`customer_enrollment` ADD CONSTRAINT `fk_customer_customer_enrollment_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `customer`.`profile` (`profile_id`);

ALTER TABLE `customer`.`move_order` DROP CONSTRAINT IF EXISTS `fk_customer_move_order_customer_service_agreement_id`;
ALTER TABLE `customer`.`move_order` ADD CONSTRAINT `fk_customer_move_order_customer_service_agreement_id` FOREIGN KEY (`customer_service_agreement_id`) REFERENCES `customer`.`customer_service_agreement` (`customer_service_agreement_id`);

ALTER TABLE `customer`.`move_order` DROP CONSTRAINT IF EXISTS `fk_customer_move_order_field_order_id`;
ALTER TABLE `customer`.`move_order` ADD CONSTRAINT `fk_customer_move_order_field_order_id` FOREIGN KEY (`field_order_id`) REFERENCES `customer`.`field_order` (`field_order_id`);

ALTER TABLE `customer`.`move_order` DROP CONSTRAINT IF EXISTS `fk_customer_move_order_move_account_id`;
ALTER TABLE `customer`.`move_order` ADD CONSTRAINT `fk_customer_move_order_move_account_id` FOREIGN KEY (`move_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`move_order` DROP CONSTRAINT IF EXISTS `fk_customer_move_order_move_premise_id`;
ALTER TABLE `customer`.`move_order` ADD CONSTRAINT `fk_customer_move_order_move_premise_id` FOREIGN KEY (`move_premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `customer`.`move_order` DROP CONSTRAINT IF EXISTS `fk_customer_move_order_primary_move_prior_account_id`;
ALTER TABLE `customer`.`move_order` ADD CONSTRAINT `fk_customer_move_order_primary_move_prior_account_id` FOREIGN KEY (`primary_move_prior_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`move_order` DROP CONSTRAINT IF EXISTS `fk_customer_move_order_profile_id`;
ALTER TABLE `customer`.`move_order` ADD CONSTRAINT `fk_customer_move_order_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `customer`.`profile` (`profile_id`);

ALTER TABLE `customer`.`move_order` DROP CONSTRAINT IF EXISTS `fk_customer_move_order_tertiary_move_prior_occupant_account_id`;
ALTER TABLE `customer`.`move_order` ADD CONSTRAINT `fk_customer_move_order_tertiary_move_prior_occupant_account_id` FOREIGN KEY (`tertiary_move_prior_occupant_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`move_order` DROP CONSTRAINT IF EXISTS `fk_customer_move_order_to_premise_id`;
ALTER TABLE `customer`.`move_order` ADD CONSTRAINT `fk_customer_move_order_to_premise_id` FOREIGN KEY (`to_premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `customer`.`third_party_authorization` DROP CONSTRAINT IF EXISTS `fk_customer_third_party_authorization_account_id`;
ALTER TABLE `customer`.`third_party_authorization` ADD CONSTRAINT `fk_customer_third_party_authorization_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`third_party_authorization` DROP CONSTRAINT IF EXISTS `fk_customer_third_party_authorization_customer_enrollment_id`;
ALTER TABLE `customer`.`third_party_authorization` ADD CONSTRAINT `fk_customer_third_party_authorization_customer_enrollment_id` FOREIGN KEY (`customer_enrollment_id`) REFERENCES `customer`.`customer_enrollment` (`customer_enrollment_id`);

ALTER TABLE `customer`.`third_party_authorization` DROP CONSTRAINT IF EXISTS `fk_customer_third_party_authorization_notification_preference_id`;
ALTER TABLE `customer`.`third_party_authorization` ADD CONSTRAINT `fk_customer_third_party_authorization_notification_preference_id` FOREIGN KEY (`notification_preference_id`) REFERENCES `customer`.`notification_preference` (`notification_preference_id`);

ALTER TABLE `customer`.`third_party_authorization` DROP CONSTRAINT IF EXISTS `fk_customer_third_party_authorization_premise_id`;
ALTER TABLE `customer`.`third_party_authorization` ADD CONSTRAINT `fk_customer_third_party_authorization_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `customer`.`third_party_authorization` DROP CONSTRAINT IF EXISTS `fk_customer_third_party_authorization_profile_id`;
ALTER TABLE `customer`.`third_party_authorization` ADD CONSTRAINT `fk_customer_third_party_authorization_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `customer`.`profile` (`profile_id`);

ALTER TABLE `customer`.`third_party_authorization` DROP CONSTRAINT IF EXISTS `fk_customer_third_party_authorization_third_account_id`;
ALTER TABLE `customer`.`third_party_authorization` ADD CONSTRAINT `fk_customer_third_party_authorization_third_account_id` FOREIGN KEY (`third_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`third_party_authorization` DROP CONSTRAINT IF EXISTS `fk_customer_third_party_authorization_to_account_id`;
ALTER TABLE `customer`.`third_party_authorization` ADD CONSTRAINT `fk_customer_third_party_authorization_to_account_id` FOREIGN KEY (`to_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`incentive_enrollment` DROP CONSTRAINT IF EXISTS `fk_customer_incentive_enrollment_account_id`;
ALTER TABLE `customer`.`incentive_enrollment` ADD CONSTRAINT `fk_customer_incentive_enrollment_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`premise_asset_connection` DROP CONSTRAINT IF EXISTS `fk_customer_premise_asset_connection_premise_id`;
ALTER TABLE `customer`.`premise_asset_connection` ADD CONSTRAINT `fk_customer_premise_asset_connection_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `customer`.`premise_service_contract` DROP CONSTRAINT IF EXISTS `fk_customer_premise_service_contract_premise_id`;
ALTER TABLE `customer`.`premise_service_contract` ADD CONSTRAINT `fk_customer_premise_service_contract_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `customer`.`customer_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_customer_customer_dr_enrollment_premise_id`;
ALTER TABLE `customer`.`customer_dr_enrollment` ADD CONSTRAINT `fk_customer_customer_dr_enrollment_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `customer`.`case` DROP CONSTRAINT IF EXISTS `fk_customer_case_profile_id`;
ALTER TABLE `customer`.`case` ADD CONSTRAINT `fk_customer_case_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `customer`.`profile` (`profile_id`);

ALTER TABLE `customer`.`case` DROP CONSTRAINT IF EXISTS `fk_customer_case_parent_case_id`;
ALTER TABLE `customer`.`case` ADD CONSTRAINT `fk_customer_case_parent_case_id` FOREIGN KEY (`parent_case_id`) REFERENCES `customer`.`case` (`case_id`);

ALTER TABLE `customer`.`field_order` DROP CONSTRAINT IF EXISTS `fk_customer_field_order_address_id`;
ALTER TABLE `customer`.`field_order` ADD CONSTRAINT `fk_customer_field_order_address_id` FOREIGN KEY (`address_id`) REFERENCES `customer`.`address` (`address_id`);

ALTER TABLE `customer`.`field_order` DROP CONSTRAINT IF EXISTS `fk_customer_field_order_billing_account_id`;
ALTER TABLE `customer`.`field_order` ADD CONSTRAINT `fk_customer_field_order_billing_account_id` FOREIGN KEY (`billing_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `customer`.`field_order` DROP CONSTRAINT IF EXISTS `fk_customer_field_order_profile_id`;
ALTER TABLE `customer`.`field_order` ADD CONSTRAINT `fk_customer_field_order_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `customer`.`profile` (`profile_id`);

ALTER TABLE `customer`.`field_order` DROP CONSTRAINT IF EXISTS `fk_customer_field_order_follow_up_field_order_id`;
ALTER TABLE `customer`.`field_order` ADD CONSTRAINT `fk_customer_field_order_follow_up_field_order_id` FOREIGN KEY (`follow_up_field_order_id`) REFERENCES `customer`.`field_order` (`field_order_id`);

ALTER TABLE `customer`.`service_level_agreement` DROP CONSTRAINT IF EXISTS `fk_customer_service_level_agreement_superseded_service_level_agreement_id`;
ALTER TABLE `customer`.`service_level_agreement` ADD CONSTRAINT `fk_customer_service_level_agreement_superseded_service_level_agreement_id` FOREIGN KEY (`superseded_service_level_agreement_id`) REFERENCES `customer`.`service_level_agreement` (`service_level_agreement_id`);

ALTER TABLE `customer`.`notification_preference` DROP CONSTRAINT IF EXISTS `fk_customer_notification_preference_superseded_notification_preference_id`;
ALTER TABLE `customer`.`notification_preference` ADD CONSTRAINT `fk_customer_notification_preference_superseded_notification_preference_id` FOREIGN KEY (`superseded_notification_preference_id`) REFERENCES `customer`.`notification_preference` (`notification_preference_id`);

