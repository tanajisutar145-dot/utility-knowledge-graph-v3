-- Utility CMM-aligned Canonical Data Model (Silver) v1.0.0 | source: Databricks lakehouse-industry-data-models energy_utilities v1 ECM | generated 2026-10-13
-- 07 | Subject area: finance | 31 tables | CIM packages: IEC61968::InfERPSupport; IEC61968::InfWork
-- Standards: IEC 61968-10; FERC USoA (18 CFR Part 101); US GAAP (ASC 980, 740); SOX 404
-- Contents: tables (with PK + NOT NULL), then intra-subject-area foreign keys.
-- Unity Catalog PK/FK constraints are informational (NOT ENFORCED); NOT NULL is enforced.

USE CATALOG `utility_cmm_silver`;

-- CostCenter  <<CIM Organisation : extension>>
CREATE TABLE IF NOT EXISTS `finance`.`cost_center` (
  `cost_center_id` BIGINT NOT NULL COMMENT 'Unique identifier for the cost center. Primary key for the cost center master data entity in SAP S/4HANA Controlling (CO) module.',
  `primary_cost_employee_id` BIGINT COMMENT 'Employee ID of the manager or supervisor responsible for this cost center. Accountable for budget management and cost control.',
  `activity_type_allowed_flag` BOOLEAN COMMENT 'Indicates whether activity types can be posted to this cost center. Relevant for cost centers that provide internal services (e.g., maintenance hours, engineering hours).',
  `budget_profile_code` STRING COMMENT 'Budget profile defining budget control and availability checking rules for this cost center. Controls whether budget overruns are allowed and how budget warnings are triggered. Pattern: ^[A-Z0-9]{4,10}$.',
  `business_area_code` STRING COMMENT 'Business area for segment reporting. Enables cross-company code financial analysis by business line (e.g., Generation, Transmission, Distribution). Pattern: ^[A-Z0-9]{4}$.',
  `capex_opex_indicator` STRING COMMENT 'Indicates whether costs posted to this cost center are primarily capital expenditures, operational expenditures, or a mix. Used for financial planning and regulatory asset base (RAB) calculations. Valid values: CAPEX|OPEX|MIXED.',
  `commitment_management_flag` BOOLEAN COMMENT 'Indicates whether commitment management (purchase requisitions and purchase orders) is active for this cost center. Used for budget control and funds management.',
  `company_code` STRING COMMENT 'Company code representing the legal entity to which this cost center is assigned. Used for external financial reporting and SOX compliance. Pattern: ^[A-Z0-9]{4}$.',
  `controlling_area_code` STRING COMMENT 'Controlling area to which this cost center belongs. Represents the organizational unit for cost accounting and internal management reporting in SAP CO. Pattern: ^[A-Z0-9]{4}$.',
  `cost_allocation_method` STRING COMMENT 'Method used to allocate costs from this cost center to other cost objects. Direct allocation assigns costs directly; assessment and distribution use allocation bases; activity-based uses activity drivers. Valid values: direct|assessment|distribution|activity_based|none.',
  `cost_center_category` STRING COMMENT 'High-level classification of the cost center by business function. Used for cost allocation and regulatory reporting segmentation. Reference-value candidates: production|transmission|distribution|customer_service|administrative|sales|research|maintenance|corporate.',
  `cost_center_code` STRING COMMENT 'Business identifier for the cost center. Alphanumeric code used in financial reporting and cost allocation. Typically follows organizational coding standards (e.g., GEN-001 for Generation, TRN-002 for Transmission). Pattern: ^[A-Z0-9]{4,10}$.',
  `cost_center_description` STRING COMMENT 'Detailed description of the cost center\'s purpose, scope, and responsibilities. Provides context for cost allocation and management reporting.',
  `cost_center_name` STRING COMMENT 'Full descriptive name of the cost center. Human-readable label used in financial reports and management dashboards.',
  `cost_center_status` STRING COMMENT 'Current lifecycle status of the cost center. Active cost centers accept postings; inactive and blocked cost centers do not. Valid values: active|inactive|blocked|planned.',
  `cost_center_type` STRING COMMENT 'Type of cost center indicating its role in cost allocation. Standard cost centers collect direct costs; auxiliary and overhead centers allocate costs to other cost centers. Valid values: standard|auxiliary|overhead|project|service.',
  `created_by_user` STRING COMMENT 'User ID of the person who created the cost center master record in the system.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the cost center master record was created in the system.',
  `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for cost center transactions. Typically USD for US-based utilities. Pattern: ^[A-Z]{3}$.',
  `department_code` STRING COMMENT 'Department or organizational unit code to which this cost center belongs. Used for organizational reporting and workforce management. Pattern: ^[A-Z0-9]{2,6}$.',
  `environmental_compliance_flag` BOOLEAN COMMENT 'Indicates whether this cost center incurs costs related to environmental compliance (EPA emissions standards, renewable portfolio standards, environmental remediation). Used for regulatory reporting and cost recovery.',
  `ferc_account_code` STRING COMMENT 'FERC Uniform System of Accounts code for regulatory reporting. Maps cost center expenses to standardized FERC account classifications for rate case filings and compliance reporting. Pattern: ^[0-9]{3,6}$.',
  `functional_area_code` STRING COMMENT 'Functional area classification for cost-of-service studies and regulatory reporting. Aligns with FERC functional classifications (Production, Transmission, Distribution, Customer Service, Administrative & General). Pattern: ^[A-Z0-9]{4,10}$.',
  `hierarchy_area_code` STRING COMMENT 'Standard hierarchy area for organizational reporting. Defines the cost center hierarchy structure for management reporting and cost rollups. Pattern: ^[A-Z0-9]{4,10}$.',
  `last_modified_by_user` STRING COMMENT 'User ID of the person who last modified the cost center master record.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the cost center master record was last modified.',
  `location_code` STRING COMMENT 'Physical location or plant where the cost center operates. Used for geographic cost analysis and facility-level reporting. Pattern: ^[A-Z0-9]{4,10}$.',
  `lock_indicator` BOOLEAN COMMENT 'Indicates whether the cost center is locked for actual postings. Used during period-end close and budget planning cycles.',
  `nerc_cip_relevant_flag` BOOLEAN COMMENT 'Indicates whether this cost center supports NERC CIP-designated critical cyber assets or bulk electric system facilities. Used for compliance tracking and cost allocation for cybersecurity investments.',
  `overhead_allocation_flag` BOOLEAN COMMENT 'Indicates whether this cost center participates in overhead allocation cycles. Overhead cost centers distribute their costs to production and service cost centers.',
  `parent_cost_center_code` STRING COMMENT 'Parent cost center in the organizational hierarchy. Enables hierarchical cost rollup and management reporting at multiple organizational levels. Pattern: ^[A-Z0-9]{4,10}$.',
  `rab_eligible_flag` BOOLEAN COMMENT 'Indicates whether costs from this cost center are eligible for inclusion in the regulatory asset base for rate recovery. Critical for rate case preparation and return on equity (ROE) calculations.',
  `sox_relevant_flag` BOOLEAN COMMENT 'Indicates whether this cost center is subject to SOX internal controls and audit requirements. Typically true for cost centers involved in financial reporting and material account balances.',
  `statistical_cost_center_flag` BOOLEAN COMMENT 'Indicates whether this is a statistical cost center used for informational purposes only, without actual cost postings.',
  `valid_from_date` DATE COMMENT 'Start date of the cost center\'s validity period. Cost center becomes active for postings from this date.',
  `valid_to_date` DATE COMMENT 'End date of the cost center\'s validity period. Cost center is no longer active for postings after this date. Null indicates open-ended validity.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_cost_center` PRIMARY KEY (`cost_center_id`)
)
USING DELTA
COMMENT 'SAP S/4HANA CO master data entity representing organizational units to which costs are assigned for internal management reporting. Captures cost center ID, name, hierarchy node, responsible manager, controlling area, profit center assignment, currency, validity period, and activity type. SSOT for OPEX cost collection, overhead allocation, and FERC cost-of-service study segmentation across generation, transmission, distribution, and corporate functions. | CMM: CIM Organisation (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CostCenter',
  'cmm.cim.class' = 'Organisation',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.cost_center'
);

-- ProfitCenter  <<CIM Organisation : extension>>
CREATE TABLE IF NOT EXISTS `finance`.`profit_center` (
  `profit_center_id` BIGINT NOT NULL COMMENT 'Unique identifier for the profit center or cost center organizational unit within SAP S/4HANA Controlling (CO) module. Primary key for internal management reporting hierarchy.',
  `employee_id` BIGINT COMMENT 'Foreign key reference to the employee who is accountable for the financial performance and operational results of this organizational unit. Used for management accountability reporting.',
  `parent_profit_center_id` BIGINT COMMENT 'Foreign key reference to the parent organizational unit in the management reporting hierarchy. Null for top-level units. Enables roll-up reporting and hierarchical cost allocation.',
  `activity_type` STRING COMMENT 'Primary activity type for cost center activity-based costing. Represents the unit of work output (e.g., labor hours, machine hours, MWh generated) used for internal cost allocation and overhead distribution.',
  `budget_amount` DECIMAL(18,2) COMMENT 'Approved annual budget amount for this organizational unit in the units currency. Used for variance analysis, budget vs. actual reporting, and financial performance management.',
  `budget_fiscal_year` INT COMMENT 'Fiscal year for which the budget amount is applicable. Supports multi-year budget tracking and historical budget analysis.',
  `business_area` STRING COMMENT 'SAP business area classification for cross-company code segment reporting. Used for consolidated financial statements across multiple legal entities.',
  `business_unit_classification` STRING COMMENT 'Strategic business unit classification for profit centers. Regulated units operate under PUC rate regulation; unregulated units operate in competitive markets; merchant units trade energy; renewable units manage clean energy assets; wholesale units serve bulk power markets; retail units serve end customers. Valid values: regulated|unregulated|merchant|renewable|wholesale|retail.',
  `capex_opex_classification` STRING COMMENT 'Primary expenditure classification for this organizational unit. CAPEX units manage capital projects and asset investments; OPEX units manage operating costs and maintenance; mixed units handle both capital and operating activities. Valid values: capex|opex|mixed.',
  `company_code` STRING COMMENT 'SAP company code representing the legal entity to which this organizational unit is assigned for external financial reporting and statutory compliance. Pattern: ^[A-Z0-9]{4}$.',
  `controlling_area` STRING COMMENT 'SAP Controlling Area code to which this organizational unit belongs. Represents the highest level of cost accounting and internal management reporting. Pattern: ^[A-Z0-9]{4}$.',
  `cost_center_category` STRING COMMENT 'Classification of cost center type for cost allocation methodology. Production centers directly support generation/transmission/distribution; service centers provide internal services; administrative centers are corporate overhead; overhead centers are indirect costs; project centers track capital initiatives. Valid values: production|service|administrative|overhead|project.',
  `cost_element_group` STRING COMMENT 'Primary cost element group classification for this organizational unit. Groups related cost types (labor, materials, services, depreciation) for financial analysis and variance reporting.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this organizational unit record was first created in the system. Used for audit trail and data lineage tracking.',
  `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for financial transactions and reporting in this organizational unit. Typically USD for US utilities. Pattern: ^[A-Z]{3}$.',
  `depreciation_method` STRING COMMENT 'Depreciation methodology applied to assets assigned to this organizational unit. Straight-line is standard for utility rate-making; declining balance for tax purposes; units of production for generation assets; group composite for T&D infrastructure. Valid values: straight_line|declining_balance|units_of_production|group_composite.',
  `ferc_functional_classification` STRING COMMENT 'FERC functional classification for cost-of-service studies and rate case filings. Maps organizational unit to generation, transmission, distribution, or corporate support functions per FERC Uniform System of Accounts. Valid values: generation|transmission|distribution|corporate|customer_service|administrative.',
  `geographic_region` STRING COMMENT 'Geographic region or service territory associated with this organizational unit. Used for regional performance analysis, regulatory jurisdiction mapping, and geographic cost allocation.',
  `hierarchy_level` INT COMMENT 'Numeric level in the organizational hierarchy tree. Level 1 represents top-level units, with increasing numbers for deeper nesting. Used for hierarchical aggregation and drill-down reporting.',
  `hierarchy_node_path` STRING COMMENT 'Full path from root to this node in the organizational hierarchy, represented as a delimited string of profit center codes. Enables efficient ancestor and descendant queries.',
  `last_modified_by` STRING COMMENT 'User ID or system identifier of the person or process that last modified this organizational unit record. Supports SOX compliance and audit requirements.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this organizational unit record was last updated. Used for change tracking and data quality monitoring.',
  `nerc_region` STRING COMMENT 'NERC regional entity jurisdiction for reliability compliance. Used for CIP (Critical Infrastructure Protection) compliance tracking and reliability reporting segmentation. Reference-value candidates: WECC|TRE|SERC|RFC|MRO|NPCC|SPP|FRCC.',
  `overhead_allocation_basis` STRING COMMENT 'Allocation basis used to distribute overhead costs from this cost center to other organizational units or products. Critical for FERC cost-of-service studies and rate case preparation. Valid values: direct_labor|headcount|square_footage|mwh_generated|asset_value|revenue.',
  `profit_center_code` STRING COMMENT 'Business identifier code for the organizational unit as defined in SAP Controlling Area. Used in financial reporting, cost allocation, and FERC account mapping. Pattern: ^[A-Z0-9]{4,10}$.',
  `profit_center_description` STRING COMMENT 'Detailed business description of the organizational units purpose, scope, and responsibilities. Provides context for financial analysis and management reporting.',
  `profit_center_name` STRING COMMENT 'Full business name of the profit center or cost center organizational unit. Human-readable label for management reporting and financial consolidation.',
  `profit_center_status` STRING COMMENT 'Current lifecycle status of the organizational unit. Active units accept cost postings; inactive units are retained for historical reporting; planned units are future organizational changes; closed units are archived. Valid values: active|inactive|planned|closed.',
  `rab_inclusion_flag` BOOLEAN COMMENT 'Boolean indicator whether costs from this organizational unit are included in the Regulatory Asset Base for rate-making purposes. True for regulated utility operations; false for unregulated competitive businesses.',
  `responsibility` STRING COMMENT 'Level of P&L accountability for profit centers. Full P&L includes both revenue and cost responsibility; revenue-only tracks top-line performance; cost-only tracks expense management; none indicates cost center classification. Valid values: full_pl|revenue_only|cost_only|none.',
  `roe_target` DECIMAL(5,4) COMMENT 'Target return on equity rate for this profit center as authorized by regulatory commission or established by corporate finance policy. Expressed as a decimal (e.g., 0.0950 for 9.50%). Critical for rate case filings and performance evaluation.',
  `rto_iso_affiliation` STRING COMMENT 'RTO or ISO market affiliation for this organizational unit (e.g., PJM, CAISO, ERCOT, MISO, NYISO, ISO-NE, SPP). Relevant for generation and transmission units participating in wholesale energy markets.',
  `segment` STRING COMMENT 'Segment classification for IFRS and US GAAP segment reporting requirements. Represents reportable business segments for external financial disclosure.',
  `short_name` STRING COMMENT 'Abbreviated name for the organizational unit used in reports and dashboards where space is constrained.',
  `sox_control_scope_flag` BOOLEAN COMMENT 'Boolean indicator whether this organizational unit is within the scope of SOX financial controls and audit requirements. True for units with material financial impact; false for immaterial or non-financial units.',
  `unit_type` STRING COMMENT 'Classification of the organizational unit as either a cost center (cost collection only) or profit center (autonomous business segment with P&L responsibility). Valid values: cost_center|profit_center.',
  `valid_from_date` DATE COMMENT 'Effective start date for this organizational unit configuration. Supports time-dependent organizational structures and historical reporting.',
  `valid_to_date` DATE COMMENT 'Effective end date for this organizational unit configuration. Null for currently active configurations. Supports organizational restructuring and historical analysis.',
  `wacc_rate` DECIMAL(5,4) COMMENT 'Weighted average cost of capital rate applied to this organizational unit for capital budgeting and investment analysis. Expressed as a decimal (e.g., 0.0725 for 7.25%). Used in NPV calculations and rate case ROE filings.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_profit_center` PRIMARY KEY (`profit_center_id`)
)
USING DELTA
COMMENT 'SAP S/4HANA CO organizational master representing the full internal management reporting hierarchy — both cost collection units (cost centers) and autonomous business segments (profit centers). Captures organizational unit ID, name, hierarchy node and level, controlling area, responsible manager, parent unit, unit type (cost center or profit center), currency, validity period, activity type, segment classification, and FERC functional classification (generation, transmission, distribution, corporate). Cost center attributes include overhead allocation basis, activity type, and cost element group. Profit center attributes include segment P&L responsibility and business unit classification. SSOT for OPEX cost collection, overhead allocation, segment P&L reporting, and FERC cost-of-service study segmentation. Replaces separate cost_center and profit_center entities to reflect the unified organizational hierarchy used in utility finance operations. | CMM: CIM Organisation (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ProfitCenter',
  'cmm.cim.class' = 'Organisation',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.profit_center'
);

-- GlAccount  <<CIM ErpChartOfAccounts : close>>
CREATE TABLE IF NOT EXISTS `finance`.`gl_account` (
  `gl_account_id` BIGINT NOT NULL COMMENT 'Unique identifier for the general ledger account. Primary key for the GL account master data.',
  `account_group` STRING COMMENT 'SAP account group that controls field status, number range, and screen layout for the account. Examples: ASSETS, LIABILITIES, REVENUE, EXPENSE.',
  `account_name` STRING COMMENT 'Short descriptive name of the GL account. Human-readable label used in financial statements and reports.',
  `account_number` STRING COMMENT 'The externally-known GL account number used in SAP S/4HANA chart of accounts. This is the business identifier displayed on financial reports, journal entries, and trial balances. Pattern: ^[A-Z0-9]{4,16}$.',
  `account_status` STRING COMMENT 'Current lifecycle status of the GL account. Active accounts accept postings; inactive accounts are temporarily disabled; blocked accounts prevent all activity; retired accounts are permanently closed. Valid values: active|inactive|blocked|retired.',
  `account_type` STRING COMMENT 'High-level classification of the account into one of the five fundamental accounting categories: asset, liability, equity, revenue, or expense. Determines financial statement placement and normal balance (debit or credit). Valid values: asset|liability|equity|revenue|expense.',
  `alternative_account_number` STRING COMMENT 'Alternative or legacy account number used for cross-reference purposes during system migrations or consolidations. Maintains traceability to prior chart of accounts structures.',
  `balance_sheet_indicator` BOOLEAN COMMENT 'Flag indicating whether this account appears on the balance sheet (true) or profit and loss statement (false). Balance sheet accounts carry balances forward; P&L accounts reset annually.',
  `capex_opex_indicator` STRING COMMENT 'Classifies the account as capital expenditure (CAPEX - capitalized and depreciated), operational expenditure (OPEX - expensed immediately), or not applicable. Critical for regulatory reporting and financial planning. Valid values: CAPEX|OPEX|N/A.',
  `chart_of_accounts` STRING COMMENT 'Identifier of the chart of accounts to which this GL account belongs. Utilities typically maintain a FERC-aligned chart of accounts.',
  `company_code` STRING COMMENT 'SAP company code to which this GL account belongs. Company code represents a legal entity for financial reporting and consolidation purposes.',
  `controlling_relevance_flag` BOOLEAN COMMENT 'Indicates whether postings to this account are relevant for Controlling (CO) module and should flow to cost centers, internal orders, or profitability segments.',
  `cost_element` STRING COMMENT 'Cost element code used in SAP Controlling (CO) module for cost center accounting, internal orders, and profitability analysis. Links financial accounting to management accounting.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this GL account master record was first created in the system. Part of the audit trail for SOX compliance.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the account. Most utility accounts use USD, but multi-national utilities may have accounts in other currencies. Pattern: ^[A-Z]{3}$.',
  `depreciation_relevant_flag` BOOLEAN COMMENT 'Indicates whether this account is subject to depreciation calculations. Typically true for fixed asset accounts and false for expense or liability accounts.',
  `effective_end_date` DATE COMMENT 'Date after which this GL account is no longer active for new postings. Null for currently active accounts. Used for account retirement and chart of accounts cleanup.',
  `effective_start_date` DATE COMMENT 'Date from which this GL account becomes active and available for posting. Used for phased chart of accounts implementations and regulatory changes.',
  `ferc_account_code` STRING COMMENT 'FERC Uniform System of Accounts (USoA) account code. Mandatory for regulated utilities to classify assets, liabilities, revenues, and expenses according to federal regulatory standards. Examples: 101 (Electric Plant in Service), 254 (Accounts Payable), 400 (Operation Expense), 440 (Rent Expense). Pattern: ^[1-9][0-9]{2,5}$.',
  `field_status_group` STRING COMMENT 'SAP field status group that controls which fields are required, optional, or hidden when posting to this account. Enforces data entry rules and compliance requirements.',
  `financial_statement_item` STRING COMMENT 'Code that maps the GL account to a specific line item on the balance sheet or profit and loss statement. Used for financial statement generation and consolidation reporting.',
  `functional_area` STRING COMMENT 'Functional area classification for segment reporting and management accounting. Examples: generation, transmission, distribution, customer service, administration. Used for FERC functional cost allocation.',
  `line_item_display_flag` BOOLEAN COMMENT 'Indicates whether individual line items can be displayed for this account. Required for detailed transaction analysis and audit trails.',
  `long_description` STRING COMMENT 'Extended description providing detailed explanation of the account purpose, usage guidelines, and posting rules. Used for training and audit documentation.',
  `modified_by` STRING COMMENT 'User ID of the person who last modified this GL account master record. Used for change tracking and audit trail.',
  `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this GL account master record was last modified. Part of the audit trail for SOX compliance and change management.',
  `open_item_management_flag` BOOLEAN COMMENT 'Indicates whether this account uses open item management, where individual line items remain open until explicitly cleared. Typically used for accounts receivable, accounts payable, and clearing accounts.',
  `planning_blocked_flag` BOOLEAN COMMENT 'Indicates whether this account is blocked for planning and budgeting activities. Used to exclude certain accounts from budget allocation processes.',
  `posting_blocked_flag` BOOLEAN COMMENT 'Indicates whether direct postings to this account are blocked. Used to prevent accidental postings to control accounts or retired accounts.',
  `profit_loss_indicator` BOOLEAN COMMENT 'Flag indicating whether this account appears on the profit and loss statement (income statement). P&L accounts measure periodic performance and are closed to retained earnings at year-end.',
  `rab_eligible_flag` BOOLEAN COMMENT 'Indicates whether costs posted to this account are eligible for inclusion in the Regulatory Asset Base (RAB) for rate-making purposes. RAB-eligible assets earn a regulated return on equity (ROE).',
  `reconciliation_account_flag` BOOLEAN COMMENT 'Indicates whether this is a reconciliation account (subledger control account) that summarizes detailed transactions from subsidiary ledgers such as accounts receivable, accounts payable, or asset accounting. Reconciliation accounts cannot be posted to directly.',
  `sort_key` STRING COMMENT 'Sorting rule that determines how line items are sorted within the account (e.g., by posting date, document number, or amount). Used for account display and reconciliation.',
  `sox_control_flag` BOOLEAN COMMENT 'Indicates whether this account is subject to SOX internal control requirements and enhanced audit scrutiny. Typically true for material accounts affecting financial statement accuracy.',
  `tax_category` STRING COMMENT 'Tax classification code that determines how transactions posted to this account are treated for tax reporting purposes. Examples: taxable income, non-taxable expense, capital expenditure.',
  `created_by` STRING COMMENT 'User ID of the person who created this GL account master record. Used for audit trail and accountability.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_gl_account` PRIMARY KEY (`gl_account_id`)
)
USING DELTA
COMMENT 'General ledger chart of accounts master aligned to FERC Uniform System of Accounts (USoA) and SAP S/4HANA FI-GL. Captures FERC account code, account type (asset, liability, equity, revenue, expense), balance sheet vs. P&L indicator, tax category, reconciliation account flag, and controlling relevance. SSOT for all financial account classifications. | CMM: CIM ErpChartOfAccounts (close), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'GlAccount',
  'cmm.cim.class' = 'ErpChartOfAccounts',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.gl_account'
);

-- JournalEntry  <<CIM ErpJournal : close>>
CREATE TABLE IF NOT EXISTS `finance`.`journal_entry` (
  `journal_entry_id` BIGINT NOT NULL COMMENT 'Unique identifier for the journal entry record. Primary key for the journal entry entity.',
  `approver_user_employee_id` BIGINT COMMENT 'SAP user ID of the individual who approved this journal entry for posting. Populated only when approval_status is approved or posted. Required for SOX compliance and segregation of duties evidence.',
  `capex_project_id` BIGINT COMMENT 'Identifier of the capital project or work order associated with this journal entry. Links financial postings to specific infrastructure projects, generation plant construction, grid modernization initiatives, or renewable energy integration projects.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Journal entries can have default cost center assignments at the header level (in addition to line-level assignments). The cost_center (STRING) should be replaced with FK to cost_center.cost_center_id.',
  `generating_unit_id` BIGINT COMMENT 'Foreign key linking to generation.generating_unit. Business justification: Manual journal entries adjust unit-level costs (accruals, reclassifications). Essential for period-end close, audit trail, and regulatory accounting adjustments.',
  `power_plant_id` BIGINT COMMENT 'Foreign key linking to generation.power_plant. Business justification: Plant-level journal entries for cost allocations and corrections. Required for regulatory accounting adjustments and FERC compliance.',
  `primary_journal_employee_id` BIGINT COMMENT 'SAP user ID of the individual who created and posted this journal entry. Used for audit trail, SOX compliance, segregation of duties monitoring, and user activity analysis.',
  `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Journal entries can have default profit center assignments at the header level (in addition to line-level assignments). The profit_center (STRING) should be replaced with FK to profit_center.profit_ce',
  `recurring_entry_template_id` BIGINT COMMENT 'Identifier of the recurring entry template that generated this journal entry. Populated only when recurring_entry_indicator is true. Links the posted entry back to its master template for audit and maintenance purposes.',
  `approval_status` STRING COMMENT 'Current state of the journal entry in the approval workflow. Draft = entry created but not submitted; Pending Approval = submitted for review; Approved = authorized for posting; Rejected = denied by approver; Posted = successfully posted to GL. Supports SOX-compliant maker-checker controls. Valid values: draft|pending_approval|approved|rejected|posted.',
  `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the journal entry was approved by the authorized approver. Populated only when approval_status is approved or posted. Part of the SOX control evidence and audit trail.',
  `asset_class` STRING COMMENT 'Classification of the fixed asset associated with this journal entry (e.g., Generation Plant, Transmission Lines, Distribution Equipment, Substation Assets, Metering Infrastructure). Used for depreciation calculation, asset lifecycle management, and regulatory reporting.',
  `business_area` STRING COMMENT 'High-level business segment code for external financial statement reporting. Represents major lines of business (e.g., Electric Utility Operations, Gas Distribution, Renewable Energy Services) for segment disclosure under GAAP/IFRS.',
  `capital_vs_expense_indicator` STRING COMMENT 'Classification of the journal entry as either CAPEX (capital expenditure - capitalized to balance sheet) or OPEX (operational expenditure - expensed to income statement). Critical for regulatory asset base (RAB) calculations, rate case filings, and EBITDA reporting. Valid values: CAPEX|OPEX.',
  `company_code` STRING COMMENT 'Four-character alphanumeric code identifying the legal entity or operating company within the utility enterprise. Represents the organizational unit for which a complete self-contained set of accounts can be drawn up for purposes of external reporting. Pattern: ^[A-Z0-9]{4}$.',
  `cost_allocation_method` STRING COMMENT 'Method used to allocate costs across company codes, business units, or regulatory jurisdictions. Direct = costs directly assigned to a single entity; Allocated = costs distributed using allocation keys (e.g., headcount, revenue); Apportioned = costs split based on regulatory formulas; Shared Services = costs from centralized service centers. Critical for rate case cost-of-service studies. Valid values: direct|allocated|apportioned|shared_services.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the transaction currency of this journal entry (e.g., USD, EUR, GBP, CAD). All monetary amounts in the journal entry lines are denominated in this currency. Pattern: ^[A-Z]{3}$.',
  `depreciation_method` STRING COMMENT 'Depreciation calculation method applied for this journal entry. Straight Line = equal annual depreciation; Declining Balance = accelerated depreciation; Units of Production = usage-based depreciation; Regulatory Prescribed = depreciation rates mandated by FERC or state PUC. Populated for depreciation-related journal entries. Valid values: straight_line|declining_balance|units_of_production|regulatory_prescribed.',
  `document_date` DATE COMMENT 'The date printed on the source document or invoice that originated this journal entry. Used for document aging, payment terms calculation, and audit trail reconciliation. May differ from posting date due to processing delays.',
  `document_number` STRING COMMENT 'Ten-digit unique accounting document number assigned by SAP FI-GL upon posting. Serves as the externally-known business identifier for this journal entry across all financial reporting and audit trails. Pattern: ^[0-9]{10}$.',
  `document_type` STRING COMMENT 'Two-character code classifying the nature and origin of the journal entry. Examples: SA (G/L account document), AB (Accounting document), AF (Depreciation posting), DR (Customer invoice), KR (Vendor invoice), RE (Invoice receipt), RV (Billing document), WA (Goods issue), WE (Goods receipt), ZP (Payment document). Controls number ranges, account types allowed, and posting rules. Reference-value candidates: SA|AB|AF|DR|DZ|KA|KG|KN|KR|RE|RV|WA|WE|ZP.',
  `entry_date` DATE COMMENT 'The calendar date on which the journal entry was physically entered into the SAP system by the user. Used for audit trail, user activity tracking, and SOX compliance evidence.',
  `exchange_rate` DECIMAL(15,5) COMMENT 'Exchange rate applied to convert foreign currency amounts to the company code\'s local currency. Populated for journal entries involving foreign currency transactions. Expressed as local currency per one unit of foreign currency.',
  `ferc_account_code` STRING COMMENT 'Three-digit FERC Uniform System of Accounts code classifying the journal entry for regulatory reporting. Examples: 101 (Electric Plant in Service), 108 (Accumulated Depreciation), 400 (Operation Expense), 500 (Maintenance Expense). Required for FERC Form 1 and state PUC filings. Pattern: ^[0-9]{3}$.',
  `fiscal_year` INT COMMENT 'Four-digit fiscal year in which the journal entry is posted. Aligns with the utility\'s fiscal calendar and determines the accounting period structure for regulatory and financial reporting.',
  `functional_area` STRING COMMENT 'Classification of the journal entry by business function (e.g., Power Generation, Grid Operations, Customer Service, Regulatory Affairs, Corporate Administration). Used for functional cost analysis and segment reporting.',
  `header_text` STRING COMMENT 'Free-form text field providing a descriptive explanation or memo for the entire journal entry. Typically includes the business reason for the posting, project references, or special instructions for auditors and reviewers.',
  `intercompany_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether this journal entry involves intercompany transactions between multiple company codes within the utility enterprise. True for entries requiring intercompany elimination in consolidated financial statements.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the journal entry record was last updated in the system. Captures any changes to header fields, approval status, or document attributes after initial creation. Part of the audit trail for change tracking.',
  `ledger_group` STRING COMMENT 'Two-character code identifying the ledger in which this entry is recorded. 0L = Leading Ledger (statutory GAAP reporting), 2L = Non-Leading Ledger (IFRS or management reporting), 3L = Extension Ledger (regulatory adjustments for FERC/PUC), 9L = Tax Ledger. Supports parallel accounting for multiple reporting frameworks. Valid values: 0L|2L|3L|9L.',
  `parked_document_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether this journal entry is parked (saved but not yet posted to the general ledger). True for entries awaiting additional information, approval, or final review before posting. Parked documents do not update account balances.',
  `posting_date` DATE COMMENT 'The date on which the journal entry is posted to the general ledger. Determines the fiscal period assignment and is the primary date for financial statement reporting and regulatory compliance. Distinct from document date and entry date.',
  `posting_period` INT COMMENT 'Numeric posting period (1-16) within the fiscal year. Periods 1-12 represent standard monthly periods; periods 13-16 are special periods for year-end adjustments, accruals, and closing entries required for regulatory filings.',
  `posting_timestamp` TIMESTAMP COMMENT 'Date and time when the journal entry was successfully posted to the general ledger. Represents the exact moment the entry became part of the official books of record. Used for audit trail and transaction sequencing.',
  `rab_eligible_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether the costs in this journal entry are eligible for inclusion in the utility\'s regulatory asset base (RAB) for rate-making purposes. True for prudent capital investments approved by the PUC for cost recovery through customer rates.',
  `rate_case_reference` STRING COMMENT 'Reference identifier linking this journal entry to a specific rate case filing or regulatory proceeding. Used to track costs and investments that are subject to regulatory review and rate recovery approval.',
  `recurring_entry_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether this journal entry was generated from a recurring entry template. True for automated postings such as monthly depreciation, lease payments, insurance premiums, and other predictable periodic entries.',
  `reference_document_number` STRING COMMENT 'Free-text field capturing the external reference number from the source document (e.g., vendor invoice number, purchase order number, contract reference, regulatory filing reference). Used for cross-referencing and audit trail documentation.',
  `regulatory_adjustment_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether this journal entry represents a regulatory accounting adjustment required by FERC, state PUC, or other utility regulatory bodies. True for entries that adjust GAAP results to regulatory accounting principles for rate case filings and regulatory asset base (RAB) calculations.',
  `reversal_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether this journal entry is a reversal of a prior entry. True if this document reverses a previous posting (e.g., accrual reversal, error correction). Used to identify offsetting entries in audit and reconciliation processes.',
  `reversed_document_number` STRING COMMENT 'The document number of the original journal entry that this entry reverses. Populated only when reversal_indicator is true. Establishes the audit trail linkage between the original posting and its reversal.',
  `sox_control_reference` STRING COMMENT 'Reference code linking this journal entry to the specific SOX internal control that governs its creation, approval, and posting. Examples include control IDs for manual journal entry reviews, segregation of duties, and management review controls. Required for SOX 404 compliance documentation.',
  `trading_partner_company_code` STRING COMMENT 'The company code of the intercompany trading partner for this journal entry. Populated only when intercompany_indicator is true. Used for intercompany reconciliation and elimination entries in consolidated reporting.',
  `wbs_element` STRING COMMENT 'Work Breakdown Structure element code identifying the specific phase or component of a capital project to which this journal entry is assigned. Enables detailed project cost tracking and earned value management.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_journal_entry` PRIMARY KEY (`journal_entry_id`)
)
USING DELTA
COMMENT 'SAP S/4HANA FI-GL journal entry header capturing all financial postings including manual entries, accruals, reversals, recurring entries, intercompany eliminations, and regulatory adjustments. Records document number, document type, posting date, fiscal year/period, company code, ledger group (leading/non-leading/extension), reference document, posting user, approval workflow status, and SOX control evidence reference. Core transactional record for the general ledger — every financial event in the utility ultimately creates or references a journal entry. | CMM: CIM ErpJournal (close), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'JournalEntry',
  'cmm.cim.class' = 'ErpJournal',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.journal_entry'
);

-- JournalEntryLine  <<CIM ErpJournalEntry : exact>>
CREATE TABLE IF NOT EXISTS `finance`.`journal_entry_line` (
  `journal_entry_line_id` BIGINT NOT NULL COMMENT 'Unique identifier for the journal entry line item. Primary key for granular financial transaction detail.',
  `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: Journal entry lines can post to fixed assets for capitalization, depreciation, and asset-related adjustments. The asset_number (STRING) should be replaced with FK to fixed_asset.fixed_asset_id, enabli',
  `journal_cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Journal entry lines are assigned to cost centers for cost allocation and management reporting. The cost_center_code (STRING) should be replaced with FK to cost_center.cost_center_id, enabling JOIN to',
  `journal_gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Journal entry lines post to GL accounts. This is a core financial posting relationship. The gl_account_code (STRING) should be replaced with a proper FK to gl_account.gl_account_id, allowing JOIN to r',
  `journal_profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Journal entry lines are assigned to profit centers for internal management reporting and segment analysis. The profit_center_code (STRING) should be replaced with FK to profit_center.profit_center_id,',
  `primary_journal_entry_id` BIGINT COMMENT 'Foreign key reference to the parent journal entry header document. Links line-item detail to the overall posting document.',
  `to_cost_center_id` BIGINT COMMENT 'FK to finance.cost_center.cost_center_id — Journal entry lines for expense postings must reference a cost center for cost allocation and OPEX tracking. Critical for management reporting and FERC cost-of-service studies.',
  `to_gl_account_id` BIGINT COMMENT 'FK to finance.gl_account.gl_account_id — Every journal entry line posts to a GL account. This is the core debit/credit posting relationship. Without this FK, you cannot produce a trial balance or any financial statement.',
  `to_journal_entry_id` BIGINT COMMENT 'FK to finance.journal_entry.journal_entry_id — Fundamental header-to-line relationship. Every journal entry line must reference its parent journal entry header. This is the most critical FK in the GL — without it, line items are orphaned and the l',
  `to_profit_center_id` BIGINT COMMENT 'FK to finance.profit_center.profit_center_id — Journal entry lines reference profit centers for segment reporting. Required for internal P&L by business segment (generation, T&D, retail).',
  `asset_subnumber` STRING COMMENT 'Sub-asset identifier for component-level tracking within a main asset. Supports detailed depreciation and retirement accounting. Pattern: ^[0-9]{4}$.',
  `assignment_reference` STRING COMMENT 'Free-text assignment field for additional line item context. Often contains invoice numbers, purchase order references, or payment identifiers.',
  `baseline_date` DATE COMMENT 'Baseline date for payment terms calculation. Determines due date for accounts payable and receivable line items.',
  `business_area_code` STRING COMMENT 'Business area for segment reporting and divisional financial statements. Supports multi-segment utility operations (generation, transmission, distribution). Pattern: ^[A-Z0-9]{4,6}$.',
  `clearing_date` DATE COMMENT 'Date on which this line item was cleared (paid or offset). Null for open items.',
  `clearing_document_number` STRING COMMENT 'Document number of the clearing entry that settled this open item. Null for uncleared items; populated when payment or offset is posted. Pattern: ^[0-9]{10}$.',
  `created_by_user` STRING COMMENT 'User ID of the person or system account that created this journal entry line. Supports SOX compliance and audit requirements. Pattern: ^[A-Z0-9]{6,12}$.',
  `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this journal entry line record was first created in the source system. Audit trail for data lineage.',
  `debit_credit_indicator` STRING COMMENT 'Indicates whether this line is a debit (D) or credit (C) posting. Fundamental double-entry bookkeeping classification. Valid values: D|C.',
  `exchange_rate` DECIMAL(12,6) COMMENT 'Foreign exchange rate applied to convert transaction amount to local amount. Null if transaction and local currencies are identical.',
  `ferc_account_code` STRING COMMENT 'FERC Uniform System of Accounts code for regulatory reporting. Mandatory for rate case filings and regulatory asset base (RAB) valuations. Pattern: ^[0-9]{3,6}$.',
  `functional_area_code` STRING COMMENT 'Functional area classification for cross-organizational cost allocation. Supports activity-based costing and functional expense reporting. Pattern: ^[A-Z0-9]{2,6}$.',
  `line_item_number` INT COMMENT 'Sequential line number within the journal entry document. Determines the ordering and position of this line in the posting.',
  `line_item_text` STRING COMMENT 'Descriptive text explaining the business purpose or nature of this journal entry line. Provides audit trail and user context.',
  `local_amount` DECIMAL(18,2) COMMENT 'Monetary amount converted to the company code local currency. Used for consolidated financial reporting and statutory books.',
  `local_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the local amount. Typically USD for US-based utilities. Pattern: ^[A-Z]{3}$.',
  `modified_by_user` STRING COMMENT 'User ID of the person or system account that last modified this journal entry line. Supports SOX compliance and change tracking. Pattern: ^[A-Z0-9]{6,12}$.',
  `modified_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent modification to this journal entry line record. Tracks change history for audit and compliance.',
  `payment_terms_code` STRING COMMENT 'Payment terms key defining discount periods and due dates. Applicable to AP and AR line items. Pattern: ^[A-Z0-9]{4}$.',
  `posting_key` STRING COMMENT 'SAP posting key determining account type (GL, customer, vendor, asset) and debit/credit direction. Controls document entry behavior. Pattern: ^[0-9]{2}$.',
  `quantity` DECIMAL(15,3) COMMENT 'Physical quantity associated with this line item (e.g., MWh for energy purchases, units for materials). Supports quantity-based cost allocation.',
  `reference_document_number` STRING COMMENT 'External reference document number (e.g., vendor invoice number, customer bill number). Links financial posting to source operational document.',
  `reversal_indicator` BOOLEAN COMMENT 'Flag indicating whether this line item is a reversal of a prior posting. True if this is a correcting or reversing entry.',
  `reversed_document_number` STRING COMMENT 'Document number of the original entry being reversed by this line item. Null if this is not a reversal. Pattern: ^[0-9]{10}$.',
  `special_gl_indicator` STRING COMMENT 'Special GL transaction type code (e.g., down payment, bill of exchange, guarantee). Enables specialized accounting treatment. Pattern: ^[A-Z]$.',
  `tax_amount` DECIMAL(18,2) COMMENT 'Calculated tax amount for this line item in local currency. Supports tax reconciliation and regulatory tax reporting.',
  `tax_code` STRING COMMENT 'Tax jurisdiction and rate code applied to this line item. Determines sales tax, use tax, or VAT calculation for the transaction. Pattern: ^[A-Z0-9]{2,4}$.',
  `to_journal_entry` BIGINT COMMENT 'FK to finance.journal_entry.journal_entry_id — Every journal entry line belongs to exactly one journal entry header. This is the most fundamental header→line relationship in the GL. Without this FK, you cannot reconstruct a balanced journal entry',
  `to_org_unit` BIGINT COMMENT 'FK to finance.organizational_unit.organizational_unit_id — Journal entry lines reference cost centers and profit centers (merged into organizational_unit) for cost allocation and segment reporting. Required for management reporting and FERC cost-of-service st',
  `to_organizational_unit` BIGINT COMMENT 'FK to finance.profit_center.profit_center_id — Journal entry lines reference cost centers and profit centers (merged into organizational_unit) for internal management reporting, FERC cost-of-service segmentation, and segment P&L. Critical for cost',
  `trading_partner_code` STRING COMMENT 'Intercompany trading partner identifier for elimination entries. Supports consolidated financial statements and intercompany reconciliation. Pattern: ^[A-Z0-9]{4,10}$.',
  `transaction_amount` DECIMAL(18,2) COMMENT 'Monetary amount of the line item in the original transaction currency. Unsigned value; sign is determined by debit_credit_indicator.',
  `transaction_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the transaction amount. Supports multi-currency operations and foreign exchange tracking. Pattern: ^[A-Z]{3}$.',
  `unit_of_measure` STRING COMMENT 'Unit of measure for the quantity field. Common values: MWH (megawatt-hour), KWH (kilowatt-hour), EA (each), TON (ton). Pattern: ^[A-Z]{2,3}$.',
  `value_date` DATE COMMENT 'Value date for cash management and interest calculation. Represents the effective date for financial impact, distinct from posting date.',
  `wbs_element_code` STRING COMMENT 'WBS element for capital project tracking. Links line items to specific capital expenditure (CAPEX) projects for asset capitalization and depreciation. Pattern: ^[A-Z0-9\\-\\.]{6,24}$.',
  `withholding_tax_amount` DECIMAL(18,2) COMMENT 'Calculated withholding tax amount in local currency. Deducted from vendor payment and remitted to tax authority.',
  `withholding_tax_code` STRING COMMENT 'Withholding tax type and rate code for vendor payments. Supports IRS 1099 reporting and international withholding compliance. Pattern: ^[A-Z0-9]{2,4}$.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_journal_entry_line` PRIMARY KEY (`journal_entry_line_id`)
)
USING DELTA
COMMENT 'Line-item detail of SAP S/4HANA FI-GL journal entries. Each line captures GL account, cost center, profit center, WBS element, functional area, debit/credit indicator, amount in transaction and local currency, tax code, and FERC account code. Enables granular cost allocation and regulatory account-level reporting. | CMM: CIM ErpJournalEntry (exact), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'JournalEntryLine',
  'cmm.cim.class' = 'ErpJournalEntry',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.journal_entry_line'
);

-- ApInvoice  <<CIM ErpPayable : close>>
CREATE TABLE IF NOT EXISTS `finance`.`ap_invoice` (
  `ap_invoice_id` BIGINT NOT NULL COMMENT 'Unique system identifier for the accounts payable invoice record. Primary key for the AP invoice entity.',
  `bank_account_id` BIGINT COMMENT 'Identifier of the company bank account from which payment was disbursed. Used for cash management and bank reconciliation.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: AP invoices are assigned to cost centers for cost allocation and budget tracking. The cost_center (STRING) should be replaced with FK to cost_center.cost_center_id, enabling JOIN to retrieve cost_cent',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: AP invoices post to GL accounts for expense or asset classification. The gl_account_code (STRING) should be replaced with FK to gl_account.gl_account_id, enabling JOIN to retrieve account_name, accoun',
  `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: AP invoices can be charged to internal orders for project or activity-specific cost tracking. The internal_order_number (STRING) should be replaced with FK to internal_order.internal_order_id, enablin',
  `journal_entry_id` BIGINT COMMENT 'FK to finance.journal_entry.journal_entry_id — Every AP invoice/payment posting creates a journal entry in the GL. This FK enables AP subledger to GL reconciliation — a core SOX control and month-end close requirement.',
  `vendor_id` BIGINT COMMENT 'Reference to the vendor (supplier) from whom goods or services were procured. Links to the vendor master data.',
  `baseline_date` DATE COMMENT 'The reference date from which payment terms are calculated. Typically the invoice date or goods receipt date depending on payment term configuration.',
  `clearing_date` DATE COMMENT 'The date on which the invoice was cleared (paid) in the accounts payable ledger. Marks the completion of the payable lifecycle.',
  `company_code` STRING COMMENT 'Four-character organizational unit representing the legal entity for which the invoice is posted. Used for financial consolidation and reporting. Pattern: ^[A-Z0-9]{4}$.',
  `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the invoice record was first created in the system. Used for audit trail and data lineage.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which the invoice is denominated (e.g., USD, EUR, GBP). Pattern: ^[A-Z]{3}$.',
  `discount_amount` DECIMAL(18,2) COMMENT 'Cash discount amount available if payment is made within the discount period as defined in payment terms. Incentivizes early payment.',
  `document_date` DATE COMMENT 'The date on which the invoice document was created or entered into the system. Used for document control and audit trail purposes.',
  `due_date` DATE COMMENT 'The date by which payment is due to the vendor according to the agreed payment terms. Used for cash flow planning and payment scheduling.',
  `exchange_rate` DECIMAL(12,5) COMMENT 'Exchange rate applied for foreign currency invoices to convert to local company currency. Used for multi-currency accounting.',
  `expenditure_type` STRING COMMENT 'Classification of the invoice as operational expenditure (OPEX) or capital expenditure (CAPEX). Critical for financial reporting and regulatory asset base (RAB) calculations. Valid values: OPEX|CAPEX.',
  `ferc_account_code` STRING COMMENT 'Three-digit FERC account code for regulatory reporting compliance. Required for utilities subject to FERC jurisdiction. Pattern: ^[0-9]{3}$|^$.',
  `fiscal_year` INT COMMENT 'The fiscal year in which the invoice is posted, used for period-based financial reporting and year-end closing processes.',
  `goods_receipt_number` STRING COMMENT 'Reference to the goods receipt document confirming physical receipt of materials or services. Part of three-way match process. Pattern: ^[0-9]{10}$|^$.',
  `gross_invoice_amount` DECIMAL(18,2) COMMENT 'Total invoice amount before any deductions, including line item charges, freight, and taxes. Represents the vendor\'s billed amount.',
  `invoice_date` DATE COMMENT 'The date on which the vendor issued the invoice. This is the business event date used for aging analysis and payment term calculations.',
  `invoice_description` STRING COMMENT 'Free-text description of the goods or services covered by the invoice. Provides business context for the transaction.',
  `invoice_status` STRING COMMENT 'Current lifecycle status of the invoice in the procure-to-pay workflow. Tracks progression from receipt through payment execution. Reference-value candidates: draft|posted|parked|blocked|approved|paid|cancelled|reversed.',
  `modified_by` STRING COMMENT 'User ID of the person who last modified the invoice record. Supports change tracking and SOX compliance audit requirements.',
  `modified_timestamp` TIMESTAMP COMMENT 'System timestamp when the invoice record was last modified. Critical for change audit trail and SOX compliance.',
  `net_payable_amount` DECIMAL(18,2) COMMENT 'Net amount payable to the vendor after deducting withholding tax and applying any discounts. This is the actual cash disbursement amount.',
  `payment_block_code` STRING COMMENT 'Single-character code indicating if the invoice is blocked for payment. Blank if not blocked. Common values include A (blocked for payment), R (blocked for review). Pattern: ^[A-Z]{1}$|^$.',
  `payment_block_reason` STRING COMMENT 'Textual explanation for why the invoice is blocked for payment, such as pricing discrepancy, quantity variance, or pending approval.',
  `payment_document_number` STRING COMMENT 'The SAP document number of the payment document that cleared this invoice. Used to trace payment execution and bank reconciliation. Pattern: ^[0-9]{10}$|^$.',
  `payment_method` STRING COMMENT 'The payment instrument used to disburse funds to the vendor, such as ACH, wire transfer, check, or electronic payment. Valid values: ACH|wire|check|electronic_funds_transfer|credit_card|virtual_card.',
  `payment_run_date` DATE COMMENT 'The date on which the automatic payment program was executed to generate payment for this invoice. Null if not yet paid.',
  `payment_terms` STRING COMMENT 'Four-character code defining the payment terms agreed with the vendor, including net due days, discount periods, and discount percentages. Pattern: ^[A-Z0-9]{4}$.',
  `posting_date` DATE COMMENT 'The date on which the invoice was posted to the general ledger. Determines the accounting period and fiscal year assignment.',
  `posting_period` INT COMMENT 'The accounting period (typically 1-12 for monthly periods) in which the invoice was posted. Used for period-based financial reporting.',
  `purchase_order_number` STRING COMMENT 'Reference to the purchase order against which this invoice is matched. Used for three-way match validation (PO/GR/IR). Pattern: ^[0-9]{10}$|^$.',
  `sap_document_number` STRING COMMENT 'The internal SAP accounting document number generated upon invoice posting. Ten-digit numeric identifier used for financial document traceability. Pattern: ^[0-9]{10}$.',
  `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount charged on the invoice, including sales tax, use tax, VAT, or other applicable taxes based on jurisdiction.',
  `three_way_match_status` STRING COMMENT 'Status of the three-way match validation comparing purchase order, goods receipt, and invoice receipt. Identifies discrepancies requiring resolution. Valid values: matched|variance_quantity|variance_price|variance_date|not_applicable|pending.',
  `vendor_bank_account_number` STRING COMMENT 'The vendor\'s bank account number to which payment was sent. Confidential financial information used for electronic payment processing.',
  `vendor_bank_routing_number` STRING COMMENT 'Nine-digit ABA routing number for the vendor\'s bank. Used for ACH and wire transfer payment processing in the United States. Pattern: ^[0-9]{9}$|^$.',
  `vendor_invoice_number` STRING COMMENT 'The invoice number assigned by the vendor. This is the externally-known identifier used for vendor reconciliation and three-way matching.',
  `wbs_element` STRING COMMENT 'WBS element for capital project cost tracking. Links invoice to specific phases of capital construction or infrastructure projects.',
  `withholding_tax_amount` DECIMAL(18,2) COMMENT 'Amount of tax withheld at source as required by tax regulations. Reduces the net payment to the vendor.',
  `created_by` STRING COMMENT 'User ID of the person who created or entered the invoice record into the system. Used for audit trail and accountability.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_ap_invoice` PRIMARY KEY (`ap_invoice_id`)
)
USING DELTA
COMMENT 'Accounts payable lifecycle record in SAP S/4HANA FI-AP covering the full payable lifecycle from invoice receipt through payment execution. Invoice attributes: vendor invoice number, invoice date, posting date, payment terms, gross amount, tax amount, withholding tax, payment block status, three-way match status (PO/GR/IR), and due date. Payment attributes: payment run date, payment method (ACH, wire, check), bank account, clearing document, payment amount, discount taken, vendor bank details, and payment status. Supports OPEX and CAPEX payable tracking for utility procurement including fuel, materials, EPC contractors, and equipment vendors. Tracks the complete procure-to-pay financial lifecycle from obligation recognition through cash disbursement. | CMM: CIM ErpPayable (close), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ApInvoice',
  'cmm.cim.class' = 'ErpPayable',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.ap_invoice'
);

-- ApPayment  <<CIM ErpPayment : exact>>
CREATE TABLE IF NOT EXISTS `finance`.`ap_payment` (
  `ap_payment_id` BIGINT NOT NULL COMMENT 'Unique identifier for the accounts payable payment transaction. Primary key.',
  `ap_invoice_id` BIGINT COMMENT 'FK to finance.ap_invoice.ap_invoice_id — AP payments clear AP invoices. This is the core payables clearing relationship. Without it, you cannot track which invoices are paid vs. open, breaking AP aging and cash flow reporting.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: AP payments can be assigned to cost centers for tracking payment-related costs. The cost_center (STRING) should be replaced with FK to cost_center.cost_center_id, enabling JOIN to retrieve cost center',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: AP payments post to GL accounts for cash, clearing accounts, and payment-related entries. The gl_account_code (STRING) should be replaced with FK to gl_account.gl_account_id, enabling JOIN to retrieve',
  `payment_run_id` BIGINT COMMENT 'Identifier of the automated payment run batch that generated this payment. Used for grouping payments processed together. Pattern: ^[A-Z0-9]{10}$.',
  `primary_ap_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ap_invoice. Business justification: AP payments clear AP invoices. This is a core accounts payable relationship linking payment transactions to the invoices they settle. The invoice_reference_number (STRING) should be replaced with FK t',
  `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: AP payments can be assigned to profit centers for internal management reporting. The profit_center (STRING) should be replaced with FK to profit_center.profit_center_id, enabling JOIN to retrieve prof',
  `vendor_bank_account_id` BIGINT COMMENT 'Identifier of the vendor bank account receiving the payment. May be IBAN for SEPA payments or domestic account number. Pattern: ^[A-Z0-9]{10,34}$.',
  `vendor_id` BIGINT COMMENT 'Identifier of the vendor receiving payment. Links to vendor master data for fuel suppliers, EPC contractors, equipment vendors, and service providers.',
  `baseline_date` DATE COMMENT 'The baseline date from which payment terms are calculated. Typically the invoice date or goods receipt date.',
  `clearing_document_number` STRING COMMENT 'The SAP clearing document number that links the payment to the original invoice(s) being settled. Used for accounts payable reconciliation. Pattern: ^[A-Z0-9]{10}$.',
  `company_code` STRING COMMENT 'The SAP company code representing the legal entity making the payment. Used for financial consolidation and SOX-compliant segregation of duties. Pattern: ^[A-Z0-9]{4}$.',
  `created_by_user` STRING COMMENT 'The SAP user ID who created or initiated the payment transaction. Used for SOX audit trails and segregation of duties compliance. Pattern: ^[A-Z0-9]{12}$.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when the payment record was first created in the system. Used for audit trail and record lifecycle tracking.',
  `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code for the payment transaction (e.g., USD, EUR, GBP). Pattern: ^[A-Z]{3}$.',
  `discount_amount` DECIMAL(18,2) COMMENT 'The cash discount amount taken during payment processing for early payment terms (e.g., 2/10 net 30). Reduces the net payment amount.',
  `document_date` DATE COMMENT 'The external document date of the payment. May differ from posting date for backdated or forward-dated transactions.',
  `due_date` DATE COMMENT 'The calculated due date for the payment based on baseline date and payment terms. Used for cash flow forecasting and working capital management.',
  `fiscal_period` INT COMMENT 'The fiscal period (month) within the fiscal year when the payment was posted. Used for monthly financial close and reporting.',
  `fiscal_year` INT COMMENT 'The fiscal year in which the payment was posted. Used for financial reporting and year-end closing.',
  `modified_by_user` STRING COMMENT 'The SAP user ID who last modified the payment transaction. Used for change tracking and SOX compliance. Pattern: ^[A-Z0-9]{12}$.',
  `modified_timestamp` TIMESTAMP COMMENT 'The timestamp when the payment record was last modified. Used for audit trail and change tracking.',
  `net_payment_amount` DECIMAL(18,2) COMMENT 'The final net amount disbursed to the vendor after applying discounts and withholding taxes. Equals payment_amount minus discount_amount minus withholding_tax_amount.',
  `payment_advice_number` STRING COMMENT 'The remittance advice document number sent to the vendor. Used for vendor reconciliation and inquiry resolution. Pattern: ^[A-Z0-9]{10,20}$.',
  `payment_amount` DECIMAL(18,2) COMMENT 'The gross payment amount disbursed to the vendor before any adjustments. Represents the total outgoing cash flow.',
  `payment_block_indicator` STRING COMMENT 'Single-character code indicating if payment is blocked for manual review. Common values: A (blocked for payment), B (blocked for approval), blank (not blocked). Pattern: ^[A-Z]$.',
  `payment_channel` STRING COMMENT 'The system or interface through which the payment was initiated. Distinct from payment method - represents the operational channel. Valid values: SAP|treasury_workstation|bank_portal|manual.',
  `payment_document_number` STRING COMMENT 'The externally-known unique payment document number assigned by SAP S/4HANA FI-AP during the payment run. Used for audit trails and reconciliation. Pattern: ^[A-Z0-9]{10}$.',
  `payment_method` STRING COMMENT 'The payment instrument used to disburse funds. ACH (Automated Clearing House) for domestic electronic transfers, wire for urgent or international transfers, check for physical payments, EFT (Electronic Funds Transfer), RTGS (Real-Time Gross Settlement), SEPA (Single Euro Payments Area). Valid values: ACH|wire|check|EFT|RTGS|SEPA.',
  `payment_reference_text` STRING COMMENT 'Free-form reference text included with the payment for vendor reconciliation. May contain invoice numbers, contract references, or remittance advice.',
  `payment_run_date` DATE COMMENT 'The date when the payment run was executed in SAP S/4HANA FI-AP. Represents the principal business event timestamp for this transaction.',
  `payment_status` STRING COMMENT 'Current lifecycle status of the payment transaction. Tracks progression from draft through clearing or reversal. Valid values: draft|pending|cleared|voided|reversed|failed.',
  `payment_terms` STRING COMMENT 'The payment terms code defining the due date calculation and cash discount conditions (e.g., 0001 for net 30 days, Z001 for 2/10 net 30). Pattern: ^[A-Z0-9]{4}$.',
  `posting_date` DATE COMMENT 'The accounting posting date when the payment transaction was recorded in the general ledger. Used for financial period assignment.',
  `purchase_order_number` STRING COMMENT 'The purchase order number associated with the payment. Links payment to procurement transaction for three-way match validation. Pattern: ^[0-9]{10}$.',
  `reversal_document_number` STRING COMMENT 'The document number of the reversal transaction if this payment was reversed. Null if payment has not been reversed. Pattern: ^[A-Z0-9]{10}$.',
  `reversal_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether this payment has been reversed. True if payment was voided or reversed due to error or stop payment.',
  `reversal_reason_code` STRING COMMENT 'Two-character code indicating the reason for payment reversal (e.g., 01 for error, 02 for stop payment, 03 for duplicate). Pattern: ^[A-Z0-9]{2}$.',
  `value_date` DATE COMMENT 'The value date when funds are actually debited from the company bank account. Used for cash position management and bank reconciliation.',
  `vendor_bank_name` STRING COMMENT 'The name of the financial institution holding the vendor bank account.',
  `vendor_bank_routing_number` STRING COMMENT 'The bank routing number (ABA for US, SWIFT/BIC for international) for the vendor bank account. Used for electronic payment routing. Pattern: ^[0-9]{9}$|^[A-Z0-9]{8,11}$.',
  `wbs_element` STRING COMMENT 'The WBS element for capital project tracking. Used when payment is for CAPEX items such as generation plant construction or transmission line upgrades. Pattern: ^[A-Z0-9\\-]{8,24}$.',
  `withholding_tax_amount` DECIMAL(18,2) COMMENT 'The withholding tax amount deducted from the payment per regulatory requirements. Remitted separately to tax authorities.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_ap_payment` PRIMARY KEY (`ap_payment_id`)
)
USING DELTA
COMMENT 'Accounts payable payment transaction in SAP S/4HANA FI-AP. Records payment run date, payment method (ACH, wire, check), bank account, clearing document, payment amount, discount taken, and vendor bank details. Tracks outgoing cash flows for vendor obligations including fuel suppliers, EPC contractors, and equipment vendors. | CMM: CIM ErpPayment (exact), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ApPayment',
  'cmm.cim.class' = 'ErpPayment',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.ap_payment'
);

-- FinanceReceivable  <<CIM ErpReceivable : exact>>
CREATE TABLE IF NOT EXISTS `finance`.`receivable` (
  `receivable_id` BIGINT NOT NULL COMMENT 'Primary key for receivable',
  `account_id` BIGINT COMMENT 'Unique identifier for the business partner (debtor) who owes this receivable. May reference wholesale counterparties, ISO/RTO entities, renewable energy certificate buyers, transmission customers, or inter-affiliate entities.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Receivables can be assigned to cost centers for tracking revenue or receivable-related costs by organizational unit. The cost_center (STRING) should be replaced with FK to cost_center.cost_center_id.',
  `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Accounts receivable entries in finance originate from customer invoices in billing. The finance.receivable table currently has account_id linking to customer but lacks the direct link to the source in',
  `journal_entry_id` BIGINT COMMENT 'FK to finance.journal_entry.journal_entry_id — Every AR posting creates a journal entry in the GL. This FK enables AR subledger to GL reconciliation for wholesale energy sales, REC sales, OATT charges, and intercompany receivables.',
  `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Receivables can be assigned to profit centers for internal management reporting and segment analysis. The profit_center (STRING) should be replaced with FK to profit_center.profit_center_id.',
  `receivable_gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Receivables post to GL accounts for accounts receivable classification. The gl_account_code (STRING) should be replaced with FK to gl_account.gl_account_id, enabling JOIN to retrieve account details a',
  `to_gl_account_id` BIGINT COMMENT 'FK to finance.gl_account.gl_account_id — AR items post to reconciliation GL accounts. Required for AR subledger-to-GL reconciliation and FERC revenue account reporting.',
  `amount_document_currency` DECIMAL(18,2) COMMENT 'The gross receivable amount in the original transaction currency (document currency). Represents the total amount due before any payments or adjustments.',
  `amount_local_currency` DECIMAL(18,2) COMMENT 'The receivable amount converted to the company code local currency (typically USD for US utilities). Used for consolidated financial reporting and general ledger posting.',
  `assignment_field` STRING COMMENT 'SAP assignment field used for payment matching and reconciliation. Often contains purchase order number, contract number, or settlement period identifier.',
  `baseline_date` DATE COMMENT 'The reference date from which payment terms are calculated. Typically the document date or posting date depending on configuration.',
  `business_area` STRING COMMENT 'SAP business area code for segment reporting (e.g., generation, transmission, distribution, trading). Enables profitability analysis by line of business. Pattern: ^[A-Z0-9]{4}$.',
  `business_partner_name` STRING COMMENT 'The legal name of the business partner debtor. Denormalized for reporting convenience.',
  `clearing_date` DATE COMMENT 'The date when the receivable was cleared (fully paid or offset). Null for open items. Used to calculate days sales outstanding (DSO).',
  `clearing_document_number` STRING COMMENT 'The accounting document number that cleared this receivable (payment document, credit memo, offset). Null for open items.',
  `clearing_status` STRING COMMENT 'Current clearing status of the receivable item. Open indicates unpaid, partially_cleared indicates partial payment received, fully_cleared indicates payment complete, written_off indicates bad debt write-off, disputed indicates customer dispute in progress. Valid values: open|partially_cleared|fully_cleared|written_off|disputed.',
  `company_code` STRING COMMENT 'SAP company code representing the legal entity that owns this receivable. Used for multi-entity consolidation and inter-company reconciliation. Pattern: ^[A-Z0-9]{4}$.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this receivable record was first created in the SAP S/4HANA FI-AR system. Used for audit trail and data lineage.',
  `dispute_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the receivable is currently under dispute (true = disputed, false = not disputed). Disputed items are typically excluded from aging analysis and may have dunning blocked.',
  `dispute_reason_code` STRING COMMENT 'Code indicating the reason for dispute if dispute_flag is true (e.g., pricing error, quantity discrepancy, contract interpretation, metering issue). Null if no dispute.',
  `document_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the original transaction (e.g., USD, CAD, MXN). Determines the currency in which the receivable was invoiced. Pattern: ^[A-Z]{3}$.',
  `document_date` DATE COMMENT 'The date printed on the source document (invoice, settlement statement, billing document). May differ from posting date due to processing delays.',
  `document_number` STRING COMMENT 'The externally-known unique accounting document number assigned by SAP S/4HANA FI-AR for this receivable item. Used for reconciliation and audit trails. Pattern: ^[A-Z0-9]{10}$.',
  `document_type` STRING COMMENT 'SAP document type code classifying the receivable: DR (Customer Invoice), DZ (Customer Payment), RV (Billing Document), AB (Accounting Document), KR (Vendor Credit Memo), KG (Vendor Invoice). Determines posting rules and workflow. Valid values: DR|DZ|RV|AB|KR|KG.',
  `due_date` DATE COMMENT 'The date by which payment is contractually due. Used for aging analysis, dunning, and collections prioritization.',
  `dunning_block_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether dunning is blocked for this receivable (true = blocked, false = eligible for dunning). Set when disputes are under review or payment arrangements are in place.',
  `dunning_level` INT COMMENT 'The current dunning level (0 = no dunning, 1 = first reminder, 2 = second reminder, 3+ = escalated collections). Increments with each dunning run for overdue items.',
  `exchange_rate` DECIMAL(12,6) COMMENT 'The exchange rate used to convert document currency to local currency at posting time. Stored for audit and revaluation purposes.',
  `ferc_jurisdictional_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this receivable falls under FERC jurisdiction (true = FERC-jurisdictional wholesale transaction, false = non-jurisdictional or state-regulated). Determines regulatory reporting requirements.',
  `iso_rto_code` STRING COMMENT 'The ISO or RTO market code if this receivable originates from wholesale market settlements. CAISO = California ISO, ERCOT = Electric Reliability Council of Texas, ISONE = ISO New England, MISO = Midcontinent ISO, NYISO = New York ISO, PJM = PJM Interconnection, SPP = Southwest Power Pool. Reference-value candidates: CAISO|ERCOT|ISONE|MISO|NYISO|PJM|SPP.',
  `last_dunning_date` DATE COMMENT 'The date of the most recent dunning notice sent for this receivable. Used to schedule next dunning action.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this receivable record was last updated. Tracks changes to clearing status, amounts, or other attributes.',
  `local_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the company code local currency. Typically USD for US-based utilities. Pattern: ^[A-Z]{3}$.',
  `outstanding_amount_document_currency` DECIMAL(18,2) COMMENT 'The remaining unpaid balance in document currency after partial payments or credits. Equals amount_document_currency for open items, zero for fully cleared items.',
  `outstanding_amount_local_currency` DECIMAL(18,2) COMMENT 'The remaining unpaid balance in local currency. Used for cash flow forecasting and working capital management.',
  `payment_block_code` STRING COMMENT 'SAP payment block code if payment processing is temporarily blocked (e.g., pending approval, dispute resolution, credit hold). Null if no block is active.',
  `payment_method` STRING COMMENT 'The expected or actual payment method for this receivable. Wire transfer and ACH are common for wholesale energy settlements, check for smaller counterparties, offset for inter-affiliate netting. Valid values: wire_transfer|ach|check|eft|credit_card|offset.',
  `payment_terms_code` STRING COMMENT 'SAP payment terms code defining the due date calculation and discount terms (e.g., Z001 for Net 30, Z002 for 2/10 Net 30). Determines dunning and collections strategy. Pattern: ^[A-Z0-9]{4}$.',
  `posting_date` DATE COMMENT 'The date when the receivable was posted to the general ledger. Represents the accounting period assignment and is the principal business event timestamp for financial reporting.',
  `receivable_category` STRING COMMENT 'Business classification of the receivable type. Wholesale_energy covers ISO/RTO energy market settlements, rec_sales covers renewable energy certificate transactions, transmission_access covers OATT charges, capacity_market covers capacity auction settlements, ancillary_services covers frequency regulation and reserves, intercompany covers inter-affiliate charges. Reference-value candidates: wholesale_energy|rec_sales|transmission_access|capacity_market|ancillary_services|intercompany|other.',
  `reference_document_number` STRING COMMENT 'External reference number from the source system (e.g., ISO/RTO settlement statement number, REC transaction ID, OATT invoice number, inter-affiliate billing reference). Enables traceability to originating transaction.',
  `settlement_period_end_date` DATE COMMENT 'The end date of the settlement period for wholesale energy or capacity market receivables. Defines the revenue recognition period.',
  `settlement_period_start_date` DATE COMMENT 'The start date of the settlement period for wholesale energy or capacity market receivables. Used for period-based revenue recognition and reconciliation.',
  `text_description` STRING COMMENT 'Free-text description of the receivable item. May include details such as \'Wholesale energy sales - January 2024\', \'REC sales - Q1 2024\', \'Transmission access charges - OATT Schedule 1\', or \'Inter-affiliate services - shared services allocation\'.',
  `write_off_date` DATE COMMENT 'The date when the receivable was written off. Null if not written off. Used for bad debt reporting and recovery tracking.',
  `write_off_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this receivable has been written off as uncollectible bad debt (true = written off, false = active). Write-offs are posted to bad debt expense accounts.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_receivable` PRIMARY KEY (`receivable_id`)
)
USING DELTA
COMMENT 'Accounts receivable open item in SAP S/4HANA FI-AR representing non-customer-billing receivables such as wholesale energy sales, renewable energy certificate (REC) sales, transmission access charges (OATT), capacity market settlements, and intercompany receivables. Captures document number, posting date, due date, amount, GL account, business partner, payment terms, dunning level, clearing status, and collection activity. Distinct from billing domain customer invoices — this entity covers enterprise-level AR outside the CIS/billing system including FERC-jurisdictional wholesale receivables, ISO/RTO settlement receivables, and inter-affiliate charges. | CMM: CIM ErpReceivable (exact), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'FinanceReceivable',
  'cmm.cim.class' = 'ErpReceivable',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.receivable'
);

-- FixedAsset  <<CIM FinancialInfo : close>>
CREATE TABLE IF NOT EXISTS `finance`.`fixed_asset` (
  `fixed_asset_id` BIGINT NOT NULL COMMENT 'Unique identifier for the fixed asset record. Primary key for the fixed asset master data in SAP S/4HANA FI-AA. This is the system-generated asset number that uniquely identifies each capitalized utility infrastructure asset throughout its lifecycle from acquisition through retirement.',
  `capital_project_id` BIGINT COMMENT 'Reference to the capital project (CAPEX project) under which this asset was acquired or constructed. Links the asset to project budgets, work breakdown structures, and capital expenditure tracking.',
  `class_id` BIGINT COMMENT 'Foreign key linking to asset.asset_class. Business justification: Fixed assets require asset class reference for depreciation method, useful life parameters, FERC account alignment, and regulatory reporting consistency. New FK needed; removes denormalized asset_clas',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Fixed assets (transmission lines, substations, generation units) are physically located within control areas. Essential for asset register by jurisdiction, depreciation allocation, rate base calculati',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Fixed assets are assigned to cost centers for depreciation expense allocation and cost tracking. The cost_center (STRING) should be replaced with FK to cost_center.cost_center_id, enabling JOIN to ret',
  `gl_account_id` BIGINT COMMENT 'FK to finance.gl_account.gl_account_id — Fixed assets post to FERC plant accounts (GL accounts 101-106). This FK enables asset-to-GL reconciliation, RAB valuation, and FERC Form 1 plant schedule reporting.',
  `power_plant_id` BIGINT COMMENT 'Foreign key linking to generation.power_plant. Business justification: Plant-level fixed assets (buildings, land, common equipment) are assigned to plants for asset registry reconciliation, insurance valuation, and FERC reporting.',
  `regulatory_asset_id` BIGINT COMMENT 'FK to finance.regulatory_asset.regulatory_asset_id — Fixed assets with RAB inclusion flag contribute to the regulatory asset base. This FK enables RAB roll-forward calculations by linking individual assets to their RAB valuation treatment.',
  `accumulated_depreciation` DECIMAL(18,2) COMMENT 'Total depreciation expense recognized to date since the asset was placed in service. Represents the cumulative reduction in asset value due to wear, obsolescence, and passage of time. Used to calculate net book value.',
  `acquisition_date` DATE COMMENT 'Date the asset was acquired or purchased by the utility. May differ from capitalization date for assets that require installation or commissioning before being placed in service.',
  `acquisition_value` DECIMAL(18,2) COMMENT 'Original acquisition cost or capitalized value of the asset including purchase price, installation costs, freight, and other costs necessary to bring the asset to its intended use. This is the gross book value before accumulated depreciation.',
  `annual_depreciation_amount` DECIMAL(18,2) COMMENT 'Calculated annual depreciation expense for the current fiscal year. For straight-line depreciation, this is acquisition value divided by useful life. Posted monthly or quarterly to the general ledger as depreciation expense.',
  `asset_condition_rating` STRING COMMENT 'Current physical condition assessment of the asset based on inspections, maintenance history, and performance monitoring. Used for asset health indexing, replacement prioritization, and risk assessment. Valid values: excellent|good|fair|poor|critical.',
  `asset_description` STRING COMMENT 'Detailed textual description of the fixed asset including make, model, specifications, capacity, and distinguishing characteristics. Used for asset identification, inventory management, and regulatory documentation.',
  `asset_location_latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the asset location in decimal degrees. Used for GIS mapping, spatial analysis, outage correlation, and field service routing. Integrates with Esri ArcGIS Utility Network.',
  `asset_location_longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the asset location in decimal degrees. Used for GIS mapping, spatial analysis, outage correlation, and field service routing. Integrates with Esri ArcGIS Utility Network.',
  `asset_number` STRING COMMENT 'Business-facing asset number or tag used for external identification and physical labeling. This is the human-readable identifier displayed on asset tags, used in field operations, and referenced in maintenance work orders and regulatory filings.',
  `asset_status` STRING COMMENT 'Current lifecycle status of the fixed asset. In-service assets are operational and depreciating; under-construction assets are CWIP (Construction Work in Progress) not yet placed in service; retired assets are no longer operational; disposed assets have been sold or scrapped; transferred assets have moved between cost centers or legal entities. Valid values: in_service|under_construction|retired|disposed|transferred|held_for_sale.',
  `capacity_rating` DECIMAL(18,4) COMMENT 'Nameplate capacity or rated output of the asset in appropriate units (MW for generation, MVA for transformers, kV for transmission lines, etc.). Used for load planning, capacity analysis, and regulatory reporting.',
  `capacity_unit_of_measure` STRING COMMENT 'Unit of measure for the capacity rating field. Common units include MW (megawatts) for generation, MVA (megavolt-amperes) for transformers, kV (kilovolts) for voltage, and circuit miles for transmission lines. Reference-value candidates: MW|MVA|kV|kVA|MWh|GWh|miles|circuit_miles|units.',
  `capitalization_date` DATE COMMENT 'Date the asset was placed in service and capitalized on the balance sheet. This is the date depreciation begins and marks the transition from CWIP to depreciable plant. Critical for depreciation calculations, RAB valuations, and regulatory reporting.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time this asset master record was first created in the system. Used for audit trails and data lineage tracking.',
  `criticality_classification` STRING COMMENT 'Business criticality rating indicating the impact of asset failure on operations, customer service, safety, and regulatory compliance. Used for maintenance prioritization and risk-based asset management. Valid values: critical|high|medium|low.',
  `depreciation_area` STRING COMMENT 'Valuation perspective for depreciation calculation. Book depreciation for financial statements, tax depreciation for IRS filings, regulatory depreciation for rate case and PUC reporting. SAP supports parallel depreciation areas for the same asset. Valid values: book|tax|regulatory|ifrs|gaap.',
  `depreciation_method` STRING COMMENT 'Depreciation calculation method applied to the asset. Straight-line is most common for utility plant. Regulatory method follows PUC-approved depreciation rates. Method determines how acquisition value is allocated over useful life. Valid values: straight_line|declining_balance|sum_of_years_digits|units_of_production|regulatory.',
  `disposal_date` DATE COMMENT 'Date the asset was physically disposed of through sale, scrap, or transfer. May occur after retirement date. Used for gain/loss on disposal calculations and regulatory reporting.',
  `disposal_proceeds` DECIMAL(18,2) COMMENT 'Cash or fair market value received from disposal of the asset through sale or salvage. Used to calculate gain or loss on disposal (proceeds minus net book value at disposal).',
  `environmental_compliance_flag` BOOLEAN COMMENT 'Indicates whether the asset is subject to environmental regulations such as EPA emissions standards, hazardous materials handling, or environmental permitting. Used for compliance tracking and environmental reporting.',
  `ferc_account_code` STRING COMMENT 'FERC Uniform System of Accounts plant account code (e.g., 101-399 for electric plant accounts). Critical for regulatory reporting, rate case filings, and depreciation studies. Examples: Account 310 (Transmission Plant), Account 360 (Distribution Plant), Account 340 (Generation Plant).',
  `functional_location` STRING COMMENT 'SAP Plant Maintenance (PM) functional location representing the physical or logical location of the asset within the utility infrastructure hierarchy. Used for maintenance planning, work order assignment, and asset tracking.',
  `geographic_location` STRING COMMENT 'Physical location or address of the asset including site name, substation, service territory, or facility. Used for GIS integration, outage management, field service dispatch, and regulatory reporting by jurisdiction.',
  `installation_date` DATE COMMENT 'Date the asset was physically installed or constructed at its current location. May differ from capitalization date if commissioning or testing was required before the asset was placed in service.',
  `last_depreciation_run_date` DATE COMMENT 'Date of the most recent depreciation calculation and posting run. Depreciation is typically calculated monthly or quarterly. This date tracks when accumulated depreciation was last updated.',
  `last_modified_by_user` STRING COMMENT 'User ID of the person who last modified this asset master record. Used for audit trails, change management, and SOX compliance documentation.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time this asset master record was last updated. Used for change tracking, audit trails, and data quality monitoring.',
  `manufacturer` STRING COMMENT 'Name of the equipment manufacturer or vendor. Used for warranty tracking, spare parts sourcing, maintenance planning, and vendor performance analysis.',
  `model_number` STRING COMMENT 'Manufacturer model or part number for the asset. Used for technical specifications lookup, spare parts identification, and standardization analysis.',
  `nerc_cip_classification` STRING COMMENT 'NERC CIP cyber security classification level for assets that are part of the Bulk Electric System. High and medium impact assets require enhanced physical and cyber security controls per NERC CIP standards. Valid values: high|medium|low|not_applicable.',
  `net_book_value` DECIMAL(18,2) COMMENT 'Current carrying value of the asset calculated as acquisition value minus accumulated depreciation. Represents the remaining capitalized value on the balance sheet. Critical for RAB calculations and financial reporting.',
  `rab_inclusion_flag` BOOLEAN COMMENT 'Indicates whether this asset is included in the Regulatory Asset Base for rate-making purposes. RAB assets are used to calculate allowed return on equity (ROE) and revenue requirements in rate cases filed with PUCs.',
  `remaining_useful_life_years` DECIMAL(10,2) COMMENT 'Remaining depreciable life of the asset in years calculated as useful life minus elapsed time since capitalization. Used for depreciation forecasting, asset replacement planning, and rate case projections.',
  `retirement_date` DATE COMMENT 'Date the asset was retired from service and removed from the active plant inventory. Depreciation ceases on this date. Used for asset lifecycle analysis and regulatory plant retirement reporting.',
  `serial_number` STRING COMMENT 'Unique serial number assigned by the manufacturer. Used for warranty claims, recall tracking, and individual asset identification in the field.',
  `sox_material_flag` BOOLEAN COMMENT 'Indicates whether the asset value is material for SOX financial reporting and internal controls testing. Material assets require enhanced documentation, approval workflows, and audit trails.',
  `useful_life_years` INT COMMENT 'Expected useful life of the asset in years as determined by depreciation studies and regulatory guidance. Used to calculate annual depreciation expense. Varies by asset class (e.g., 30-50 years for transmission lines, 10-15 years for vehicles).',
  `warranty_expiration_date` DATE COMMENT 'Date the manufacturer warranty expires. Used for maintenance planning decisions (repair vs. replace) and warranty claim tracking.',
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
  CONSTRAINT `pk_finance_fixed_asset` PRIMARY KEY (`fixed_asset_id`)
)
USING DELTA
COMMENT 'SAP S/4HANA FI-AA fixed asset master and depreciation record representing capitalized utility infrastructure and its periodic depreciation lifecycle. Asset master attributes: asset class, FERC plant account (e.g., Account 101-106), capitalization date, useful life, depreciation method, RAB inclusion flag, accumulated depreciation, net book value, and location/functional assignment. Depreciation attributes: depreciation run date, fiscal period, depreciation area (book, tax, regulatory), depreciation amount, accumulated depreciation balance, and remaining useful life. SSOT for CAPEX tracking, RAB valuation inputs, FERC depreciation studies, rate case filings, and regulatory plant account reporting submitted to PUCs and FERC. | CMM: CIM FinancialInfo (close), IEC61968::Assets.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'FixedAsset',
  'cmm.cim.class' = 'FinancialInfo',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Assets',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.fixed_asset',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- AssetDepreciation  <<CIM FinancialInfo : broad>>
CREATE TABLE IF NOT EXISTS `finance`.`asset_depreciation` (
  `asset_depreciation_id` BIGINT NOT NULL COMMENT 'Unique identifier for the asset depreciation posting record. Primary key for the asset_depreciation product.',
  `class_id` BIGINT COMMENT 'Foreign key linking to asset.asset_class. Business justification: Depreciation runs require asset class for rate tables, useful life parameters, depreciation method selection, and FERC regulatory reporting. New FK needed; removes denormalized asset_class_code.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Depreciation postings are assigned to cost centers for expense allocation. The cost_center (STRING) should be replaced with FK to cost_center.cost_center_id, enabling JOIN to retrieve cost center mast',
  `depreciation_expense_gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Depreciation postings hit GL accounts for depreciation expense. The gl_account_depreciation_expense (STRING) should be replaced with FK to gl_account.gl_account_id, enabling JOIN to retrieve account d',
  `depreciation_run_id` BIGINT COMMENT 'Identifier for the batch depreciation calculation run that generated this posting. Used to group all depreciation postings from a single execution.',
  `fixed_asset_id` BIGINT COMMENT 'FK to finance.fixed_asset.fixed_asset_id — Every depreciation posting must reference the fixed asset being depreciated. Without this FK, depreciation records are meaningless and RAB calculations cannot be performed.',
  `generating_unit_id` BIGINT COMMENT 'Foreign key linking to generation.generating_unit. Business justification: Depreciation expense is tracked at the unit level for rate base calculations, FERC depreciation studies, and rate case testimony. Critical for regulatory accounting.',
  `journal_entry_id` BIGINT COMMENT 'Reference to the original asset_depreciation_id that this record reverses, if this is a reversal posting. Null for original postings.',
  `power_plant_id` BIGINT COMMENT 'Foreign key linking to generation.power_plant. Business justification: Plant-level depreciation for aggregated asset classes. Required for monthly depreciation runs, RAB valuation, and regulatory reporting.',
  `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Depreciation postings are assigned to profit centers for internal management reporting and segment analysis. The profit_center (STRING) should be replaced with FK to profit_center.profit_center_id, en',
  `registry_id` BIGINT COMMENT 'Reference to the fixed asset for which depreciation is being posted. Links to the asset registry master data.',
  `accumulated_depreciation` DECIMAL(18,2) COMMENT 'The cumulative total depreciation posted for this asset from acquisition date through the current period. Represents the total reduction in asset value to date.',
  `acquisition_value` DECIMAL(18,2) COMMENT 'The original acquisition or capitalized cost of the asset. Used as the basis for depreciation calculations and remains constant unless revaluation occurs.',
  `asset_location` STRING COMMENT 'The physical location or plant where the asset is installed. Used for geographic cost allocation and service territory reporting to state PUCs.',
  `business_area` STRING COMMENT 'The business area or segment (e.g., generation, transmission, distribution, retail) to which this depreciation expense is assigned. Used for segment reporting and regulatory cost allocation.',
  `company_code` STRING COMMENT 'The legal entity or company code for which this depreciation posting is recorded. Supports multi-entity consolidation and separate regulatory reporting by operating company.',
  `created_by_user` STRING COMMENT 'The user ID or system account that created this depreciation posting record. Used for audit trail and SOX compliance.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this depreciation posting record was first created in the system. Used for audit trail and data lineage.',
  `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code for all monetary amounts in this record. Typically USD for US utilities. Pattern: ^[A-Z]{3}$.',
  `depreciation_amount` DECIMAL(18,2) COMMENT 'The periodic depreciation expense amount posted for this asset in this period. Represents the reduction in asset value for the reporting period.',
  `depreciation_area` STRING COMMENT 'The depreciation area or valuation view for which this posting applies. Supports parallel depreciation calculations for book accounting, tax reporting, regulatory filings (FERC), and international standards (IFRS/GAAP). Valid values: book|tax|regulatory|ifrs|gaap|ferc.',
  `depreciation_key` STRING COMMENT 'The depreciation method key that defines the calculation rules applied (e.g., straight-line, declining balance, units of production). Controls how depreciation is computed for this asset.',
  `depreciation_method` STRING COMMENT 'The depreciation calculation method applied for this posting. Straight-line is most common for utility assets; composite and group methods are used for transmission and distribution assets per FERC guidelines. Valid values: straight_line|declining_balance|sum_of_years_digits|units_of_production|composite|group.',
  `depreciation_rate_percent` DECIMAL(7,4) COMMENT 'The annual depreciation rate applied as a percentage of acquisition value. For straight-line depreciation, calculated as 100 divided by useful life years.',
  `depreciation_run_date` DATE COMMENT 'The date on which the depreciation calculation batch was executed. Represents the business event timestamp for this depreciation posting.',
  `document_number` STRING COMMENT 'The financial document number assigned to this depreciation posting in the general ledger. Used for audit trail and reconciliation with FI-GL.',
  `ferc_account_code` STRING COMMENT 'The FERC Uniform System of Accounts code for this asset. Required for regulatory reporting to FERC and state Public Utility Commissions (PUCs). Examples: 311 (Structures), 353 (Station Equipment), 364 (Poles and Fixtures).',
  `fiscal_period` INT COMMENT 'The fiscal period (month) within the fiscal year for which this depreciation posting applies. Typically 1-12 for monthly periods.',
  `fiscal_year` INT COMMENT 'The fiscal year for which this depreciation posting applies. Used for financial period reporting and regulatory filings.',
  `gl_account_accumulated_depreciation` STRING COMMENT 'The general ledger account number to which accumulated depreciation is posted as a contra-asset. Typically maps to FERC Account 108 (Accumulated Depreciation) for utility assets.',
  `modified_by_user` STRING COMMENT 'The user ID or system account that last modified this depreciation posting record. Used for audit trail and SOX compliance.',
  `modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this depreciation posting record was last modified. Used for audit trail and change tracking.',
  `net_book_value` DECIMAL(18,2) COMMENT 'The net book value of the asset after this depreciation posting, calculated as acquisition value minus accumulated depreciation. Represents the current carrying value of the asset.',
  `notes` STRING COMMENT 'Free-text notes or comments related to this depreciation posting. Used to document adjustments, corrections, or special circumstances.',
  `posting_date` DATE COMMENT 'The date on which the depreciation transaction was posted to the general ledger. May differ from the depreciation run date due to period-end processing.',
  `posting_status` STRING COMMENT 'The current status of this depreciation posting. Indicates whether the posting has been successfully recorded to the general ledger, reversed due to error, or is pending approval. Valid values: posted|reversed|cancelled|pending.',
  `rab_eligible_flag` BOOLEAN COMMENT 'Indicates whether this asset is eligible for inclusion in the Regulatory Asset Base (RAB) for rate-making purposes. True if the asset is used and useful in providing regulated utility service.',
  `regulatory_jurisdiction` STRING COMMENT 'The regulatory jurisdiction (state PUC or FERC) under which this asset and its depreciation are reported. Critical for rate case filings and cost recovery.',
  `remaining_useful_life_years` DECIMAL(5,2) COMMENT 'The remaining useful life of the asset in years after this depreciation posting. Calculated as original useful life minus elapsed life. Critical for rate case filings and asset replacement planning.',
  `retirement_date` DATE COMMENT 'The date on which the asset was retired or disposed of, if applicable. Null for active assets. Used to stop depreciation calculations and trigger retirement accounting.',
  `reversal_indicator` BOOLEAN COMMENT 'Indicates whether this depreciation posting is a reversal of a previous posting. True if this record reverses a prior depreciation entry due to correction or adjustment.',
  `salvage_value` DECIMAL(18,2) COMMENT 'The estimated residual value of the asset at the end of its useful life. Used in depreciation calculations and retirement accounting. May be negative for assets with removal costs.',
  `sox_control_flag` BOOLEAN COMMENT 'Indicates whether this depreciation posting is subject to SOX financial controls and audit requirements. True for publicly traded utilities with material asset values.',
  `useful_life_years` DECIMAL(5,2) COMMENT 'The total estimated useful life of the asset in years as defined at acquisition. Used to calculate straight-line depreciation rates and supports FERC depreciation study requirements.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_asset_depreciation` PRIMARY KEY (`asset_depreciation_id`)
)
USING DELTA
COMMENT 'Periodic depreciation posting records for fixed assets in SAP FI-AA. Captures depreciation run date, fiscal period, depreciation area (book, tax, regulatory), depreciation amount, accumulated depreciation balance, and remaining useful life. Supports FERC depreciation studies, rate case filings, and RAB calculations submitted to PUCs. | CMM: CIM FinancialInfo (broad), IEC61968::Assets.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AssetDepreciation',
  'cmm.cim.class' = 'FinancialInfo',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61968::Assets',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.asset_depreciation'
);

-- CapexProject  <<CIM Project : close>>
CREATE TABLE IF NOT EXISTS `finance`.`capex_project` (
  `capex_project_id` BIGINT NOT NULL COMMENT 'Unique identifier for the capital expenditure project. Primary key.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Capital projects are planned and executed within specific control areas for asset location tracking, regulatory jurisdiction assignment, and rate base allocation by service territory. Essential for ge',
  `profit_center_id` BIGINT COMMENT 'FK to finance.profit_center.profit_center_id — CAPEX projects are assigned to organizational units (business units) for budget governance and segment reporting. Critical for CAPEX variance analysis by business segment.',
  `actual_completion_date` DATE COMMENT 'Actual date when the project was completed and the asset placed in service. Null if project is still in progress.',
  `actual_spend_amount` DECIMAL(18,2) COMMENT 'Cumulative actual expenditure to date for this project, in USD. Sum of all posted costs including purchase orders, goods receipts, invoices, and internal labor.',
  `actual_start_date` DATE COMMENT 'Actual date when project work commenced. May differ from planned start date due to delays or early starts.',
  `approved_budget_amount` DECIMAL(18,2) COMMENT 'Total capital budget approved by the board or executive management for this project, in USD. Represents the authorized spending limit.',
  `auc_account_code` STRING COMMENT 'General ledger account code used to accumulate project costs before capitalization. Typically a balance sheet account in the 100-series per FERC Uniform System of Accounts.',
  `capitalization_date` DATE COMMENT 'Date when the asset under construction (AuC) was settled to the fixed asset register and depreciation commenced. Marks the transition from CAPEX project to operational asset.',
  `capitalization_status` STRING COMMENT 'Indicates whether the project costs have been transferred from asset under construction (AuC) to the fixed asset register: not capitalized (still in AuC), partially capitalized (some WBS elements settled), or fully capitalized (all costs settled and project closed). Valid values: not_capitalized|partially_capitalized|fully_capitalized.',
  `committed_amount` DECIMAL(18,2) COMMENT 'Total committed funds for this project, in USD. Includes purchase orders issued but not yet invoiced. Used for budget availability checks.',
  `cpcn_approval_date` DATE COMMENT 'Date when the Public Utility Commission (PUC) granted the CPCN for this project. Null if CPCN is not required or not yet approved.',
  `cpcn_reference_number` STRING COMMENT 'Regulatory approval reference number for the Certificate of Public Convenience and Necessity (CPCN) issued by the Public Utility Commission (PUC) authorizing this capital project. Required for major transmission and generation projects.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this capital project record was first created in the system.',
  `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts in this project (e.g., USD, CAD, EUR). Pattern: ^[A-Z]{3}$.',
  `environmental_permit_number` STRING COMMENT 'Reference number for environmental permits required for this project (e.g., EPA air quality permit, wetlands permit, NEPA clearance). Multiple permits may be concatenated or stored in related tables.',
  `ferc_account_code` STRING COMMENT 'FERC Uniform System of Accounts code to which the capitalized asset will be assigned (e.g., 350 for transmission lines, 360 for distribution lines, 310 for generation plant). Used for regulatory rate base reporting.',
  `forecast_at_completion_amount` DECIMAL(18,2) COMMENT 'Projected total cost at project completion, in USD. Updated periodically by project managers based on actual spend, commitments, and remaining work estimates.',
  `irp_alignment_flag` BOOLEAN COMMENT 'Indicates whether this capital project is included in the utility\'s approved Integrated Resource Plan (IRP) filed with the Public Utility Commission (PUC). True if aligned; false otherwise.',
  `irp_reference_number` STRING COMMENT 'Reference identifier linking this project to the specific IRP filing or docket number with the Public Utility Commission (PUC).',
  `last_modified_by` STRING COMMENT 'User ID or name of the person who last modified this capital project record.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this capital project record was last updated in the system.',
  `nerc_compliance_flag` BOOLEAN COMMENT 'Indicates whether this project involves assets subject to NERC Critical Infrastructure Protection (CIP) standards or other NERC reliability requirements. True if subject to NERC compliance; false otherwise.',
  `planned_completion_date` DATE COMMENT 'Scheduled date for project completion and asset in-service, as defined in the project plan.',
  `planned_start_date` DATE COMMENT 'Scheduled date for project initiation and commencement of work, as defined in the project plan.',
  `priority_rank` INT COMMENT 'Relative priority ranking of this project within the capital portfolio, used for resource allocation and budget decisions. Lower numbers indicate higher priority.',
  `project_category` STRING COMMENT 'Nature of the capital investment: new construction (greenfield), replacement (asset retirement and new installation), expansion (capacity increase), upgrade (technology improvement), maintenance (major overhaul capitalized per FERC), compliance (mandated by regulation), or other. Reference-value candidates: new_construction|replacement|expansion|upgrade|maintenance|compliance|other.',
  `project_description` STRING COMMENT 'Detailed business justification and scope description of the capital project, including technical specifications and strategic rationale.',
  `project_manager_name` STRING COMMENT 'Full name of the individual assigned as project manager, accountable for delivery, budget, and schedule.',
  `project_name` STRING COMMENT 'Descriptive name of the capital project (e.g., \'Substation XYZ Transformer Replacement\', \'Solar Farm Phase 2 Expansion\').',
  `project_number` STRING COMMENT 'Business-facing unique project identifier used in SAP S/4HANA PS and external communications. Corresponds to SAP Project Definition number.',
  `project_phase` STRING COMMENT 'Current lifecycle phase of the capital project: planning (feasibility and design), engineering (detailed design and permitting), procurement (vendor selection and contracting), construction (physical build), commissioning (testing and startup), in-service (asset capitalized and operational), or closed (project administratively complete). Reference-value candidates: planning|engineering|procurement|construction|commissioning|in_service|closed.',
  `project_sponsor_name` STRING COMMENT 'Full name of the executive sponsor who approved the project and provides strategic oversight.',
  `project_status` STRING COMMENT 'Administrative status of the project: approved (budget authorized), active (work in progress), on hold (temporarily suspended), cancelled (terminated before completion), or completed (all work finished and capitalized). Valid values: approved|active|on_hold|cancelled|completed.',
  `project_type` STRING COMMENT 'Classification of the capital project by asset category: generation (power plant construction/upgrade), transmission (high-voltage lines and towers), distribution (local grid infrastructure), substation (transformer and switching equipment), renewable integration (solar/wind/storage), grid modernization (AMI, ADMS, smart grid), customer systems (CIS, billing, MDM), regulatory compliance (environmental, safety, NERC CIP), or other. Reference-value candidates: generation|transmission|distribution|substation|renewable_integration|grid_modernization|customer_systems|regulatory_compliance|other.',
  `rab_inclusion_date` DATE COMMENT 'Date when the capitalized asset was added to the Regulatory Asset Base (RAB) for rate-making purposes, allowing cost recovery through customer rates.',
  `rate_case_docket_number` STRING COMMENT 'Public Utility Commission (PUC) docket number for the rate case in which this capital project was included for cost recovery.',
  `rate_case_inclusion_flag` BOOLEAN COMMENT 'Indicates whether this capital project has been included in a rate case filing for cost recovery through the Regulatory Asset Base (RAB). True if included; false otherwise.',
  `responsible_business_unit` STRING COMMENT 'Name or code of the business unit or division responsible for executing this capital project (e.g., Transmission Operations, Distribution Engineering, Generation Services).',
  `risk_rating` STRING COMMENT 'Overall risk assessment for the capital project based on technical complexity, regulatory uncertainty, budget size, and schedule constraints: low (routine project), medium (moderate complexity), high (significant challenges), or critical (major strategic initiative with high uncertainty). Valid values: low|medium|high|critical.',
  `sox_control_flag` BOOLEAN COMMENT 'Indicates whether this capital project is subject to SOX internal controls for financial reporting due to materiality thresholds. True if SOX controls apply; false otherwise.',
  `strategic_initiative_alignment` STRING COMMENT 'Name or code of the corporate strategic initiative or program to which this project is aligned (e.g., Grid Modernization 2025, Renewable Integration Program, Customer Experience Transformation).',
  `variance_amount` DECIMAL(18,2) COMMENT 'Difference between approved budget and forecast at completion, in USD. Positive indicates under budget; negative indicates over budget.',
  `wbs_element` STRING COMMENT 'Top-level WBS element code representing the project hierarchy in SAP PS. Used for cost collection and budget control.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_capex_project` PRIMARY KEY (`capex_project_id`)
)
USING DELTA
COMMENT 'Capital expenditure project master and expenditure detail in SAP S/4HANA PS/IM covering the full CAPEX lifecycle from approval through capitalization. Project master attributes: WBS structure, approved CAPEX budget, actual spend to date, forecast at completion, project phase (planning, execution, in-service), responsible business unit, IRP alignment, CPCN reference, and capitalization status. Expenditure detail attributes: purchase order reference, goods receipt date, invoice amount, asset under construction (AuC) account, settlement rule, capitalization event, and FERC account code. Supports capital budget governance, project cost tracking by WBS element, rate case CAPEX justification, and regulatory reporting of capital additions to the rate base. | CMM: CIM Project (close), IEC61968::InfWork.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CapexProject',
  'cmm.cim.class' = 'Project',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfWork',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-6',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.capex_project'
);

-- CapexExpenditure  <<CIM WorkCostDetail : close>>
CREATE TABLE IF NOT EXISTS `finance`.`capex_expenditure` (
  `capex_expenditure_id` BIGINT NOT NULL COMMENT 'Unique identifier for the capital expenditure transaction record. Primary key for the CAPEX expenditure entity.',
  `capital_project_id` BIGINT COMMENT 'Reference to the capital project under which this expenditure is incurred. Links to the capital project master record.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Individual capital expenditures must be assigned to control areas for geographic cost tracking, regulatory reporting by jurisdiction, and rate case support documentation. Enables rate base calculation',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: CAPEX expenditures are assigned to cost centers for tracking capital spending by organizational unit. The cost_center (STRING) should be replaced with FK to cost_center.cost_center_id, enabling JOIN t',
  `employee_id` BIGINT COMMENT 'Reference to the employee or manager who approved this capital expenditure. Links to the workforce or employee master record for audit trail.',
  `generating_unit_id` BIGINT COMMENT 'Foreign key linking to generation.generating_unit. Business justification: Capex expenditures capitalize to specific generating units (new equipment, upgrades). Essential for asset capitalization, depreciation start, and unit-level rate base tracking.',
  `irp_scenario_id` BIGINT COMMENT 'Foreign key linking to forecast.irp_scenario. Business justification: Capital expenditures must be tracked against approved IRP scenario forecasts for variance analysis and regulatory compliance. Utilities demonstrate actual spending aligns with IRP plans during prudenc',
  `power_plant_id` BIGINT COMMENT 'Foreign key linking to generation.power_plant. Business justification: Plant-level capex (substation upgrades, common facilities) capitalizes to the plant. Required for FERC plant-in-service accounting and rate base calculations.',
  `vendor_id` BIGINT COMMENT 'Reference to the vendor or supplier from whom goods or services were procured for this capital expenditure. Links to the vendor master record.',
  `approval_date` DATE COMMENT 'The date on which this capital expenditure was approved by the authorized approver. Required for SOX compliance and audit trail.',
  `approval_status` STRING COMMENT 'The approval workflow status of this capital expenditure transaction. Indicates whether the expenditure has been authorized per internal controls and SOX compliance. Valid values: pending|approved|rejected|cancelled.',
  `asset_class` STRING COMMENT 'The classification of the asset being constructed or acquired (e.g., Generation Equipment, Transmission Lines, Distribution Infrastructure, IT Systems). Used for depreciation and asset management.',
  `asset_number` STRING COMMENT 'The fixed asset number to which this expenditure was settled upon capitalization. Links the expenditure to the final asset record in the asset register.',
  `auc_account_code` STRING COMMENT 'The general ledger account code for the Asset Under Construction (AuC) to which this expenditure is posted. Represents the interim capitalization account before final asset settlement.',
  `budget_line_item` STRING COMMENT 'The budget line item or budget category against which this capital expenditure is tracked. Used for budget vs. actual variance reporting.',
  `capex_expenditure_description` STRING COMMENT 'A detailed textual description of the capital expenditure transaction, including the nature of goods or services procured and any relevant context.',
  `capitalization_date` DATE COMMENT 'The date on which this expenditure was capitalized and transferred from the AuC account to a fixed asset. Marks the start of depreciation.',
  `capitalization_status` STRING COMMENT 'The current capitalization lifecycle status of this expenditure. Indicates whether the expenditure has been capitalized to an asset or is still in the AuC account. Valid values: pending|capitalized|settled|reversed.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this capital expenditure record was first created in the system. Used for audit trail and data lineage.',
  `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code in which this expenditure was transacted (e.g., USD, EUR, GBP). Pattern: ^[A-Z]{3}$.',
  `depreciation_start_date` DATE COMMENT 'The date on which depreciation begins for the asset created from this capital expenditure. Typically aligns with the capitalization date or asset in-service date.',
  `document_date` DATE COMMENT 'The date of the source document (e.g., invoice, receipt) that originated this expenditure transaction. May differ from posting date.',
  `expenditure_amount` DECIMAL(18,2) COMMENT 'The gross monetary value of this capital expenditure transaction before any adjustments or allocations. Represents the invoice or payment amount.',
  `expenditure_type` STRING COMMENT 'The category of capital expenditure (e.g., materials, labor, contractor services, engineering). Used for cost breakdown analysis and project management. Reference-value candidates: material|labor|equipment|contractor_services|engineering|permits|land_acquisition|other.',
  `ferc_account_code` STRING COMMENT 'The FERC Uniform System of Accounts code that classifies this capital expenditure for regulatory reporting. Required for rate case filings and regulatory asset base (RAB) calculations.',
  `fiscal_period` INT COMMENT 'The fiscal period (month) within the fiscal year in which this capital expenditure was posted. Enables monthly CAPEX tracking and variance analysis.',
  `fiscal_year` INT COMMENT 'The fiscal year in which this capital expenditure was posted. Used for annual CAPEX budgeting, tracking, and regulatory reporting.',
  `goods_receipt_date` DATE COMMENT 'The date on which goods or services were received and confirmed in the system. Triggers the capitalization eligibility for the expenditure.',
  `invoice_date` DATE COMMENT 'The date on which the vendor invoice was issued. Used for payment terms calculation and aging analysis.',
  `invoice_number` STRING COMMENT 'The vendor invoice number corresponding to this CAPEX expenditure. Used for accounts payable reconciliation and audit trail.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this capital expenditure record was last updated or modified. Used for change tracking and audit trail.',
  `net_amount` DECIMAL(18,2) COMMENT 'The net monetary value of this capital expenditure after deducting taxes and other adjustments. Represents the capitalizable base amount.',
  `payment_date` DATE COMMENT 'The date on which payment was made to the vendor for this capital expenditure. Null if payment is still pending.',
  `payment_status` STRING COMMENT 'The current payment status of this capital expenditure invoice. Indicates whether the vendor has been paid and tracks accounts payable aging. Valid values: pending|paid|partially_paid|overdue|cancelled.',
  `posting_date` DATE COMMENT 'The accounting date on which this CAPEX expenditure transaction was posted to the general ledger. Determines the fiscal period for financial reporting.',
  `purchase_order_number` STRING COMMENT 'The purchase order number associated with this capital expenditure transaction. Links the expenditure to the procurement document.',
  `rab_eligible_flag` BOOLEAN COMMENT 'Boolean indicator of whether this capital expenditure is eligible for inclusion in the Regulatory Asset Base (RAB) for rate-making purposes. True if eligible, False otherwise.',
  `rab_inclusion_date` DATE COMMENT 'The date on which this capital expenditure was included in the Regulatory Asset Base (RAB) for rate recovery. Used for Return on Equity (ROE) and Weighted Average Cost of Capital (WACC) calculations.',
  `reversal_date` DATE COMMENT 'The date on which this capital expenditure transaction was reversed or cancelled. Null if the transaction has not been reversed.',
  `reversal_flag` BOOLEAN COMMENT 'Boolean indicator of whether this capital expenditure transaction has been reversed or cancelled. True if reversed, False otherwise.',
  `reversal_reason` STRING COMMENT 'A textual explanation of why this capital expenditure transaction was reversed or cancelled. Used for audit trail and root cause analysis.',
  `settlement_rule` STRING COMMENT 'The settlement rule code that defines how this CAPEX expenditure is allocated or settled to one or more fixed assets. May specify percentage splits or allocation keys.',
  `source_document_reference` STRING COMMENT 'The unique document identifier in the source system (e.g., SAP document number) that originated this capital expenditure transaction. Used for traceability and reconciliation.',
  `source_system` STRING COMMENT 'The name or code of the source operational system from which this capital expenditure record was extracted (e.g., SAP S/4HANA, Oracle ERP).',
  `tax_amount` DECIMAL(18,2) COMMENT 'The total tax amount (sales tax, VAT, GST) included in this CAPEX expenditure. Used for tax reporting and recovery calculations.',
  `useful_life_years` INT COMMENT 'The estimated useful life of the asset in years, used for calculating depreciation expense. Determined by asset class and regulatory guidelines.',
  `wbs_element` STRING COMMENT 'The WBS element code against which this CAPEX expenditure is posted. Represents a specific phase or component of the capital project for granular cost tracking.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_capex_expenditure` PRIMARY KEY (`capex_expenditure_id`)
)
USING DELTA
COMMENT 'Individual capital expenditure transaction posted against a CAPEX project WBS element. Records purchase order reference, goods receipt date, invoice amount, asset under construction (AuC) account, settlement rule, and capitalization event. Enables granular CAPEX tracking by project, asset class, and FERC account for regulatory reporting. | CMM: CIM WorkCostDetail (close), IEC61968::InfWork.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CapexExpenditure',
  'cmm.cim.class' = 'WorkCostDetail',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfWork',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-6',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.capex_expenditure'
);

-- OpexBudget  <<CIM ErpLedgerBudget : close>>
CREATE TABLE IF NOT EXISTS `finance`.`opex_budget` (
  `opex_budget_id` BIGINT NOT NULL COMMENT 'Unique identifier for the operational expenditure budget record. Primary key for the OPEX budget entity.',
  `cost_center_id` BIGINT COMMENT 'Reference to the cost center responsible for this OPEX budget allocation. Links to organizational cost center hierarchy in SAP CO-CCA.',
  `cost_element_group_id` BIGINT COMMENT 'Reference to the cost element group categorizing the type of operational expenditure (e.g., fuel costs, maintenance labor, administrative overhead).',
  `employee_id` BIGINT COMMENT 'The user ID or employee identifier of the person who last modified this budget record. Used for audit trail and accountability.',
  `generating_unit_id` BIGINT COMMENT 'Foreign key linking to generation.generating_unit. Business justification: O&M budgets are set at the unit level for cost control, budget preparation, and monthly variance reporting. Standard in utility operations.',
  `load_id` BIGINT COMMENT 'Foreign key linking to forecast.load. Business justification: Operating expense budgets are developed using load forecasts as primary drivers. O&M costs scale with forecasted energy delivery and peak demand. Critical for annual budgeting cycle and operational pl',
  `owner_employee_id` BIGINT COMMENT 'Reference to the employee or manager who owns and is accountable for managing this budget line. Links to the workforce or employee master data.',
  `power_plant_id` BIGINT COMMENT 'Foreign key linking to generation.power_plant. Business justification: Plant-level O&M budgets for aggregated operations. Required for annual budget cycle, regulatory filings, and executive reporting.',
  `primary_opex_employee_id` BIGINT COMMENT 'Reference to the employee or manager who approved this budget version. Links to the workforce or employee master data for audit trail purposes.',
  `profit_center_id` BIGINT COMMENT 'FK to finance.profit_center.profit_center_id — OPEX budgets are set by cost center (merged into organizational_unit). This FK enables budget vs. actual variance reporting by organizational unit — a core management reporting requirement.',
  `actual_spend_amount` DECIMAL(18,2) COMMENT 'The actual operational expenditure incurred to date for this budget line, sourced from posted cost transactions in SAP FI/CO. Used for variance analysis against planned and approved amounts.',
  `approved_opex_amount` DECIMAL(18,2) COMMENT 'The approved operational expenditure amount after management and regulatory review. This is the authorized spending limit for the period.',
  `available_budget_amount` DECIMAL(18,2) COMMENT 'The remaining budget available for new commitments or expenditures, calculated as approved_opex_amount minus (actual_spend_amount plus commitment_amount).',
  `budget_approval_date` DATE COMMENT 'The date on which this budget version was formally approved by management or the board, transitioning from draft or submitted status to approved status.',
  `budget_category` STRING COMMENT 'High-level categorization of the OPEX budget line by expenditure type, enabling roll-up reporting and analysis by major cost driver (e.g., fuel costs for generation, maintenance for T&D assets). Reference-value candidates: fuel|labor|maintenance|materials|contracted_services|administrative|regulatory|environmental|technology.',
  `budget_effective_date` DATE COMMENT 'The date from which this budget version becomes effective and active for spending authorization and control.',
  `budget_expiration_date` DATE COMMENT 'The date on which this budget version expires and is no longer valid for new commitments or expenditures. Typically the end of the fiscal period or year.',
  `budget_lock_status` STRING COMMENT 'Indicates whether this budget line is open for changes (unlocked), locked to prevent further modifications, or frozen for regulatory reporting purposes. Valid values: unlocked|locked|frozen.',
  `budget_notes` STRING COMMENT 'Free-text field for capturing additional context, assumptions, or justifications related to this budget line. Used for documenting budget planning rationale and variance explanations.',
  `budget_status` STRING COMMENT 'Current lifecycle status of the budget record indicating its approval and activation state within the budget planning and execution workflow. Valid values: draft|submitted|approved|active|closed|cancelled.',
  `budget_version` STRING COMMENT 'The version of the budget record indicating whether this is the original approved budget, a revised budget after adjustments, a forecast update, or a supplemental allocation. Valid values: original|revised|forecast|supplemental|baseline.',
  `business_unit_code` STRING COMMENT 'Code identifying the business unit or division (e.g., Generation, Transmission and Distribution, Corporate) responsible for this OPEX budget line.',
  `commitment_amount` DECIMAL(18,2) COMMENT 'The total amount of purchase orders, contracts, or other financial commitments issued against this budget line but not yet posted as actual expenditure. Used for funds availability checking.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this OPEX budget record was first created in the system. Used for audit trail and data lineage tracking.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this budget record (e.g., USD, CAD, EUR). Pattern: ^[A-Z]{3}$.',
  `ferc_account_code` STRING COMMENT 'The FERC Uniform System of Accounts code that classifies this OPEX expenditure for regulatory reporting purposes. Ensures compliance with FERC financial reporting requirements.',
  `fiscal_period` INT COMMENT 'The fiscal period (month or quarter) within the fiscal year for which this budget line applies. Typically 1-12 for monthly periods.',
  `fiscal_year` INT COMMENT 'The fiscal year for which this OPEX budget is planned and tracked. Typically a four-digit year (e.g., 2024).',
  `forecast_amount` DECIMAL(18,2) COMMENT 'The forecasted or projected OPEX expenditure for this budget line based on current run-rate and known future commitments. Used for EBITDA forecasting and financial planning.',
  `functional_area` STRING COMMENT 'The functional area of utility operations to which this OPEX budget applies, enabling segmentation by core business process (e.g., power generation, T&D operations, customer service). Reference-value candidates: generation|transmission|distribution|customer_service|corporate|regulatory|trading|renewable_energy.',
  `is_capital_conversion_candidate` BOOLEAN COMMENT 'Boolean flag indicating whether this OPEX expenditure may be eligible for capitalization or conversion to CAPEX under regulatory accounting rules. Used for financial planning and rate base optimization.',
  `is_regulatory_reportable` BOOLEAN COMMENT 'Boolean flag indicating whether this OPEX budget line must be included in regulatory financial reports submitted to PUC or FERC. True if reportable; false otherwise.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this OPEX budget record was last updated or modified. Used for audit trail and change tracking.',
  `planned_opex_amount` DECIMAL(18,2) COMMENT 'The planned operational expenditure amount for this cost center and cost element group for the specified fiscal period. Represents the initial budget target before approvals or adjustments.',
  `prior_year_actual_amount` DECIMAL(18,2) COMMENT 'The actual OPEX expenditure for the same cost center and cost element group in the prior fiscal year. Used for year-over-year trend analysis and budget benchmarking.',
  `regulatory_allowance_reference` STRING COMMENT 'Reference identifier or docket number for the regulatory filing or rate case order that established the regulatory OPEX allowance for this budget line.',
  `regulatory_opex_allowance` DECIMAL(18,2) COMMENT 'The OPEX spending level approved by the Public Utility Commission (PUC) or regulatory authority for this cost category and period. Used to ensure spending aligns with rate case approvals and regulatory compliance.',
  `variance_amount` DECIMAL(18,2) COMMENT 'The monetary variance between approved OPEX budget and actual spend (approved_opex_amount minus actual_spend_amount). Positive values indicate under-spend; negative values indicate over-spend.',
  `variance_percentage` DECIMAL(5,2) COMMENT 'The percentage variance between approved OPEX budget and actual spend, calculated as (variance_amount / approved_opex_amount) * 100. Used for management reporting and exception flagging.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_opex_budget` PRIMARY KEY (`opex_budget_id`)
)
USING DELTA
COMMENT 'Operational expenditure budget plan in SAP S/4HANA CO-CCA capturing approved O&M spending targets by cost center and cost element group. Records budget version (original, revised, forecast), fiscal year, planned OPEX amount, approved amount, actual spend to date, variance amount and percentage, and regulatory OPEX allowance reference. Supports O&M cost planning against PUC-approved levels, EBITDA forecasting by business unit, and management variance reporting for generation fuel, T&D maintenance, and corporate overhead. | CMM: CIM ErpLedgerBudget (close), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'OpexBudget',
  'cmm.cim.class' = 'ErpLedgerBudget',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.opex_budget'
);

-- InternalOrder  <<CIM ErpProjectAccounting : close>>
CREATE TABLE IF NOT EXISTS `finance`.`internal_order` (
  `internal_order_id` BIGINT NOT NULL COMMENT 'Unique identifier for the SAP CO internal order. Primary key for cost collection and monitoring of short-term activities.',
  `internal_cost_center_id` BIGINT COMMENT 'FK to finance.cost_center.cost_center_id — Internal orders settle to cost centers. The responsible cost center is a required organizational assignment for every internal order in SAP CO.',
  `internal_profit_center_id` BIGINT COMMENT 'Identifier of the profit center to which internal order costs are allocated for segment profitability analysis and management reporting.',
  `internal_responsible_cost_center_id` BIGINT COMMENT 'Identifier of the cost center accountable for planning, executing, and settling the internal order costs. Links to the organizational unit managing the activity.',
  `primary_settlement_gl_account_id` BIGINT COMMENT 'Identifier of the primary GL account to which internal order costs are settled, typically a FERC account code for regulatory cost tracking.',
  `to_profit_center_id` BIGINT COMMENT 'FK to finance.profit_center.profit_center_id — Internal orders are assigned to responsible cost centers (merged into organizational_unit) for cost collection and settlement. Critical for storm cost tracking and regulatory cost segregation.',
  `wbs_element_id` BIGINT COMMENT 'Optional reference to a WBS element if this internal order is part of a larger capital project structure, enabling hierarchical cost rollup.',
  `actual_cost_amount` DECIMAL(18,2) COMMENT 'Total actual costs posted to the internal order to date, including labor, materials, services, and overhead allocations, in the company currency.',
  `actual_end_date` DATE COMMENT 'Actual date when work on the internal order activity was completed, triggering technical completion status and final settlement processing.',
  `actual_start_date` DATE COMMENT 'Actual date when work on the internal order activity commenced, captured from work order confirmations or time entry records.',
  `audit_trail_required_flag` BOOLEAN COMMENT 'Indicates whether detailed change history and approval documentation must be retained for this internal order to support regulatory audits or rate case proceedings.',
  `budget_amount` DECIMAL(18,2) COMMENT 'Approved budget allocation for the internal order in the company currency, representing the planned cost ceiling for the activity.',
  `business_area` STRING COMMENT 'Cross-company code segment for internal financial reporting, often aligned with business divisions such as Generation, Transmission, Distribution, or Retail.',
  `capex_opex_indicator` STRING COMMENT 'Classification of internal order costs as capital expenditure (CAPEX) for asset capitalization and depreciation, or operational expenditure (OPEX) for immediate expense recognition. Valid values: CAPEX|OPEX.',
  `closure_date` DATE COMMENT 'Date when the internal order was closed and archived, indicating all costs have been settled and the order is no longer active for any postings.',
  `commitment_amount` DECIMAL(18,2) COMMENT 'Total committed costs (purchase requisitions and purchase orders) assigned to the internal order but not yet invoiced, used for funds availability checking and budget monitoring.',
  `company_code` STRING COMMENT 'SAP company code representing the legal entity to which this internal order belongs, used for financial consolidation and regulatory reporting. Pattern: ^[A-Z0-9]{4}$.',
  `controlling_area` STRING COMMENT 'SAP Controlling (CO) area code representing the organizational unit for cost accounting and internal reporting, may span multiple company codes. Pattern: ^[A-Z0-9]{4}$.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the internal order master record was first created in the system, in ISO 8601 format with timezone.',
  `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this internal order (e.g., USD, CAD, EUR). Pattern: ^[A-Z]{3}$.',
  `ferc_account_code` STRING COMMENT 'FERC Uniform System of Accounts code to which internal order costs are ultimately allocated for regulatory financial reporting and rate case filings. Pattern: ^[0-9]{3,6}$.',
  `functional_area` STRING COMMENT 'Classification of the internal order by business function for cost-of-sales accounting and segment reporting (e.g., Operations, Maintenance, Administration, Sales).',
  `long_description` STRING COMMENT 'Detailed narrative describing the scope, purpose, and business justification for the internal order, including work location, asset references, and regulatory drivers.',
  `modified_by` STRING COMMENT 'SAP user ID of the person who last modified the internal order master record.',
  `modified_timestamp` TIMESTAMP COMMENT 'Date and time when the internal order master record was last modified, in ISO 8601 format with timezone.',
  `order_category` STRING COMMENT 'Business classification of the activity being tracked: planned outage repairs, storm restoration events, vegetation management campaigns, regulatory compliance initiatives, customer-funded projects, asset replacement programs, grid modernization efforts, or other activities. Reference-value candidates: planned_outage|storm_restoration|vegetation_management|regulatory_compliance|customer_project|asset_replacement|grid_modernization|other.',
  `order_number` STRING COMMENT 'Business-facing alphanumeric identifier for the internal order, used in work requests, cost reports, and regulatory filings. Pattern: ^[A-Z0-9]{8,12}$.',
  `order_status` STRING COMMENT 'Current lifecycle status of the internal order: created (initial setup), released (active for posting), technically complete (work finished, final costs pending), closed (settled and archived), or locked (posting blocked for corrections). Valid values: created|released|technically_complete|closed|locked.',
  `order_type` STRING COMMENT 'Classification of the internal order by accounting treatment: overhead (O&M expense), investment (CAPEX capitalization), accrual (period-end allocation), statistical (non-financial tracking), or settlement (cost redistribution). Valid values: overhead|investment|accrual|statistical|settlement.',
  `planned_end_date` DATE COMMENT 'Scheduled date when work on the internal order activity is planned to be completed, used for milestone tracking and settlement scheduling.',
  `planned_start_date` DATE COMMENT 'Scheduled date when work on the internal order activity is planned to begin, used for resource planning and project scheduling.',
  `rab_eligible_flag` BOOLEAN COMMENT 'Indicates whether costs accumulated on this internal order are eligible for inclusion in the Regulatory Asset Base (RAB) for rate-of-return calculations and rate case filings.',
  `requesting_department` STRING COMMENT 'Name or code of the business department that initiated the internal order request (e.g., Transmission Operations, Distribution Maintenance, Regulatory Affairs).',
  `settled_cost_amount` DECIMAL(18,2) COMMENT 'Total costs that have been settled (distributed) from this internal order to receiving cost objects, used to track settlement completeness and reconcile order balances.',
  `settlement_period` STRING COMMENT 'Fiscal period (YYYY-MM format) in which internal order costs are settled to receiving cost objects, used for period-end closing and financial reporting. Pattern: ^[0-9]{4}-(0[1-9]|1[0-2])$.',
  `settlement_receiver_type` STRING COMMENT 'Type of cost object that receives settled costs from this internal order: GL account (direct expense posting), cost center (overhead allocation), asset (capitalization), WBS element (project assignment), or profitability segment (CO-PA). Valid values: gl_account|cost_center|asset|wbs_element|profitability_segment.',
  `settlement_rule_profile` STRING COMMENT 'Configuration key defining how costs accumulated on this internal order are settled (distributed) to receiving cost objects such as GL accounts, cost centers, assets, or WBS elements at period-end.',
  `short_description` STRING COMMENT 'Brief title or summary of the internal order activity, typically 40-60 characters, used in reports and work order references.',
  `sox_control_flag` BOOLEAN COMMENT 'Indicates whether this internal order is subject to SOX financial controls and audit requirements, triggering additional approval workflows and documentation retention.',
  `system_status` STRING COMMENT 'SAP system-controlled status codes concatenated as a string (e.g., CRTD REL SETC TECO CLSD), reflecting automated status transitions based on business transactions.',
  `technical_completion_date` DATE COMMENT 'Date when the internal order was set to technically complete status, preventing further primary cost postings while allowing settlement and final adjustments.',
  `user_status` STRING COMMENT 'User-defined status value from a configured status profile, enabling business-specific workflow states such as Approved, In Progress, Pending Review, or Rejected.',
  `variance_amount` DECIMAL(18,2) COMMENT 'Difference between actual costs and budget amount (actual minus budget), used for cost control reporting and management variance analysis.',
  `created_by` STRING COMMENT 'SAP user ID of the person who created the internal order master record in the system.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_internal_order` PRIMARY KEY (`internal_order_id`)
)
USING DELTA
COMMENT 'SAP CO internal order used to collect and monitor costs for specific short-term activities such as planned outage repairs, storm restoration events, vegetation management campaigns, or overhead projects not warranting a full WBS structure. Captures order type (overhead, investment, accrual), responsible cost center, settlement rule, budget, actual costs, commitment values, and lifecycle status (created, released, technically complete, closed). Used for O&M job costing, regulatory cost segregation, and FERC account-level cost tracking. | CMM: CIM ErpProjectAccounting (close), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'InternalOrder',
  'cmm.cim.class' = 'ErpProjectAccounting',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.internal_order'
);

-- RegulatoryAsset  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `finance`.`regulatory_asset` (
  `regulatory_asset_id` BIGINT NOT NULL COMMENT 'Unique identifier for the regulatory asset or liability record. Primary key for the regulatory asset base (RAB) master.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Regulatory assets (deferred storm costs, stranded costs) are often jurisdiction-specific and must be tracked by control area for rate recovery, FERC reporting, state PUC filings, and amortization allo',
  `cost_center_id` BIGINT COMMENT 'Foreign key reference to the cost center responsible for the originating costs or credits that created this regulatory asset or liability.',
  `gl_account_id` BIGINT COMMENT 'Foreign key reference to the general ledger account in SAP S/4HANA FI where this regulatory asset or liability is recorded.',
  `power_plant_id` BIGINT COMMENT 'Foreign key linking to generation.power_plant. Business justification: Plant-level regulatory assets (deferred major maintenance, storm costs). Required for FERC account 182.3 tracking and rate recovery.',
  `accrued_carrying_cost` DECIMAL(18,2) COMMENT 'Cumulative carrying costs (interest or return) accrued on the regulatory asset balance, calculated using the authorized rate of return or weighted average cost of capital (WACC).',
  `allowed_return_amount` DECIMAL(18,2) COMMENT 'Dollar amount of return on equity (ROE) and debt return that the utility is allowed to earn on this regulatory asset base component during the period, calculated as RAB × WACC.',
  `amortization_end_date` DATE COMMENT 'Scheduled date on which the regulatory asset or liability will be fully amortized and recovered, based on the authorized amortization period.',
  `amortization_period_months` INT COMMENT 'Total number of months over which the regulatory asset or liability is authorized to be amortized and recovered through customer rates.',
  `amortization_start_date` DATE COMMENT 'Date on which amortization and rate recovery of the regulatory asset or liability began.',
  `asset_liability_indicator` STRING COMMENT 'Indicates whether this record represents a regulatory asset (deferred cost recoverable from customers) or a regulatory liability (deferred credit owed to customers). Valid values: asset|liability.',
  `asset_type` STRING COMMENT 'Classification of the regulatory asset or liability. Storm costs, pension obligations, environmental remediation, deferred fuel costs, construction work in progress (CWIP), deferred tax, regulatory liability, or other. Reference-value candidates: storm_costs|pension_obligation|environmental_remediation|deferred_fuel|cwip|deferred_tax|regulatory_liability|other.',
  `authorization_date` DATE COMMENT 'Date on which the regulatory authority issued the order authorizing this regulatory asset or liability treatment.',
  `authorization_order_number` STRING COMMENT 'Public Utility Commission (PUC) or FERC order number authorizing the deferral and recovery of this regulatory asset, or the refund mechanism for this regulatory liability.',
  `authorized_return_rate` DECIMAL(5,4) COMMENT 'Annual rate of return authorized by the regulatory body for calculating carrying costs on the regulatory asset balance. Expressed as a decimal (e.g., 0.0725 for 7.25%).',
  `capex_additions` DECIMAL(18,2) COMMENT 'Capital expenditure additions to the regulatory asset base during the valuation period, representing new plant and equipment placed in service.',
  `carrying_amount` DECIMAL(18,2) COMMENT 'Current net book value of the regulatory asset or liability after amortization, adjustments, and accrued carrying costs. This is the balance sheet amount.',
  `closing_rab_amount` DECIMAL(18,2) COMMENT 'Closing balance of the regulatory asset base at the end of the valuation period, after all additions, depreciation, disposals, and indexation adjustments.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this regulatory asset record was first created in the system.',
  `cumulative_amortization` DECIMAL(18,2) COMMENT 'Total amount of the regulatory asset or liability that has been amortized and recovered through customer rates to date.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this record (e.g., USD, CAD, GBP). Pattern: ^[A-Z]{3}$.',
  `depreciation_charge` DECIMAL(18,2) COMMENT 'Depreciation expense charged against the regulatory asset base during the valuation period, reducing the net book value of rate base assets.',
  `disallowed_amount` DECIMAL(18,2) COMMENT 'Portion of the regulatory asset that was disallowed by the regulator during prudence review and cannot be recovered from customers.',
  `disposals_retirements` DECIMAL(18,2) COMMENT 'Net book value of assets retired or disposed from the regulatory asset base during the valuation period.',
  `effective_end_date` DATE COMMENT 'Date on which this regulatory asset or liability record ceased to be effective. Null for currently active records.',
  `effective_start_date` DATE COMMENT 'Date on which this regulatory asset or liability record became effective and active in the system.',
  `ferc_account_code` STRING COMMENT 'FERC Uniform System of Accounts code for the regulatory asset or liability (e.g., 182.3 for Other Regulatory Assets, 254 for Other Regulatory Liabilities). Pattern: ^[0-9]{3}(\\.[0-9]{1,2})?$.',
  `inflation_indexation` DECIMAL(18,2) COMMENT 'Inflation adjustment applied to the regulatory asset base in jurisdictions that use indexed RAB methodologies (e.g., RPI or CPI indexation). Zero in non-indexed jurisdictions.',
  `modified_by` STRING COMMENT 'User ID or name of the person who last modified this regulatory asset record.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this regulatory asset record was last modified in the system.',
  `monthly_amortization_amount` DECIMAL(18,2) COMMENT 'Fixed monthly amortization amount recovered through customer rates, calculated as the original amount divided by the amortization period.',
  `notes` STRING COMMENT 'Free-text notes providing additional context, regulatory guidance, or special conditions related to this regulatory asset or liability.',
  `opening_rab_amount` DECIMAL(18,2) COMMENT 'Opening balance of the regulatory asset base at the beginning of the valuation period, before CAPEX additions, depreciation, and disposals.',
  `original_amount` DECIMAL(18,2) COMMENT 'Original principal amount of the regulatory asset or liability at the time of initial recognition, in the reporting currency.',
  `prudence_review_status` STRING COMMENT 'Status of the regulatory prudence review for this asset: pending review, approved for full recovery, partially approved (some costs disallowed), or disallowed. Valid values: pending|approved|partially_approved|disallowed.',
  `rab_inclusion_flag` BOOLEAN COMMENT 'Indicates whether this regulatory asset is included in the regulatory asset base (RAB) for calculating the allowed return on equity (ROE) and revenue requirement.',
  `rab_valuation_date` DATE COMMENT 'As-of date for the RAB valuation roll-forward calculation. Typically the end of a reporting period (month-end, quarter-end, or year-end).',
  `rate_recovery_status` STRING COMMENT 'Current status of rate recovery for this regulatory asset or liability: not started, in progress (actively being recovered), completed (fully recovered), suspended, or denied by regulator. Valid values: not_started|in_progress|completed|suspended|denied.',
  `rate_schedule_reference` STRING COMMENT 'Reference to the specific rate schedule or tariff rider through which this regulatory asset or liability is being recovered from or refunded to customers.',
  `regulatory_asset_name` STRING COMMENT 'Descriptive name of the regulatory asset or liability (e.g., Storm Cost Recovery 2023, Deferred Fuel Costs Q4 2024, Environmental Remediation Reserve).',
  `regulatory_asset_number` STRING COMMENT 'Business identifier for the regulatory asset or liability, used in rate case filings and regulatory correspondence. Format: RA-NNNNNNNN. Pattern: ^RA-[0-9]{8}$.',
  `regulatory_asset_status` STRING COMMENT 'Current lifecycle status of the regulatory asset: pending regulatory approval, approved for recovery, actively being recovered through rates, fully amortized, written off, or suspended. Valid values: pending_approval|approved|active_recovery|fully_amortized|written_off|suspended.',
  `regulatory_jurisdiction` STRING COMMENT 'Regulatory body with jurisdiction over this asset or liability (e.g., California PUC, FERC, Texas PUC, New York PSC). Determines applicable accounting and rate recovery rules.',
  `roe_rate` DECIMAL(5,4) COMMENT 'Authorized return on equity rate used in the revenue requirement calculation for this regulatory asset. Expressed as a decimal (e.g., 0.0950 for 9.50%).',
  `sox_control_flag` BOOLEAN COMMENT 'Indicates whether this regulatory asset is subject to Sarbanes-Oxley Act internal control requirements due to materiality or financial statement impact.',
  `unamortized_balance` DECIMAL(18,2) COMMENT 'Remaining principal balance of the regulatory asset or liability that has not yet been amortized or recovered through customer rates.',
  `wacc_rate` DECIMAL(5,4) COMMENT 'Weighted average cost of capital authorized by the regulator for calculating the allowed return on this regulatory asset. Expressed as a decimal (e.g., 0.0675 for 6.75%).',
  `created_by` STRING COMMENT 'User ID or name of the person who created this regulatory asset record in the system.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_regulatory_asset` PRIMARY KEY (`regulatory_asset_id`)
)
USING DELTA
COMMENT 'Regulatory asset base (RAB) master representing both individual regulatory assets/liabilities and the periodic RAB valuation roll-forward. Individual asset attributes: regulatory asset type (storm costs, pension, environmental remediation, deferred fuel, CWIP), authorization order reference, amortization period, carrying amount, and rate recovery status. RAB valuation attributes: valuation date, opening RAB, CAPEX additions, depreciation charge, disposals, inflation indexation, closing RAB, regulatory jurisdiction, and allowed return amount. Core to rate case financial models, revenue requirement calculations, and PUC/FERC rate proceedings. SSOT for all regulatory assets, deferred cost recovery items, and the net asset base on which the utility earns its regulated return. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'RegulatoryAsset',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.regulatory_asset'
);

-- RateCaseFiling  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `finance`.`rate_case_filing` (
  `rate_case_filing_id` BIGINT NOT NULL COMMENT 'Unique identifier for the rate case filing record. Primary key for the rate case filing entity.',
  `irp_scenario_id` BIGINT COMMENT 'Foreign key linking to forecast.irp_scenario. Business justification: Rate cases reference specific IRP scenarios to justify revenue requirements and capital investments. Test year assumptions must align with filed IRP forecasts. Essential for regulatory rate case prepa',
  `power_plant_id` BIGINT COMMENT 'Foreign key linking to generation.power_plant. Business justification: Rate cases reference specific plants for cost-of-service calculations, test year data compilation, and rate base valuation. Essential for regulatory proceedings.',
  `primary_regulatory_asset_id` BIGINT COMMENT 'FK to finance.regulatory_asset.regulatory_asset_id — Rate case filings reference the RAB valuation as a core input to revenue requirement calculations. This FK links the regulatory proceeding to the asset base on which return is earned.',
  `rate_regulatory_asset_id` BIGINT COMMENT 'FK to finance.regulatory_asset.regulatory_asset_id — Rate case filings include regulatory assets (deferred costs) in the revenue requirement. The filing must reference which regulatory assets are being recovered.',
  `annual_revenue_impact` DECIMAL(18,2) COMMENT 'Estimated annual revenue impact to the utility resulting from the approved rate changes, calculated as the difference between approved and current revenue levels.',
  `approved_rate_base` DECIMAL(18,2) COMMENT 'Total value of utility plant and other assets approved by the regulatory commission for earning a return, which may differ from the requested rate base due to disallowances or adjustments.',
  `approved_revenue_requirement` DECIMAL(18,2) COMMENT 'Total annual revenue requirement approved by the regulatory commission in the final order, which may differ from the requested amount due to adjustments and disallowances.',
  `approved_roe` DECIMAL(5,4) COMMENT 'Return on equity percentage approved by the regulatory commission in the final order. Expressed as a decimal (e.g., 0.0950 for 9.50%).',
  `approved_wacc` DECIMAL(5,4) COMMENT 'Weighted average cost of capital approved by the regulatory commission in the final order. Expressed as a decimal (e.g., 0.0675 for 6.75%).',
  `capital_structure_debt_ratio` DECIMAL(5,4) COMMENT 'Proportion of debt in the approved capital structure used for rate-making purposes. Expressed as a decimal (e.g., 0.4800 for 48%).',
  `capital_structure_equity_ratio` DECIMAL(5,4) COMMENT 'Proportion of equity in the approved capital structure used for rate-making purposes. Expressed as a decimal (e.g., 0.5200 for 52%).',
  `cost_of_debt` DECIMAL(5,4) COMMENT 'Weighted average interest rate on the utility\'s debt used in the rate case calculation. Expressed as a decimal (e.g., 0.0450 for 4.50%).',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this rate case filing record was first created in the system.',
  `customer_class_coverage` STRING COMMENT 'Customer classes affected by this rate case filing (e.g., residential, commercial, industrial, or all classes). Pipe-separated list if multiple classes.',
  `depreciation_expense` DECIMAL(18,2) COMMENT 'Annual depreciation expense included in the revenue requirement, calculated based on approved depreciation rates and depreciable plant balances.',
  `docket_number` STRING COMMENT 'Official docket or case number assigned by the regulatory commission (PUC or FERC) to uniquely identify this rate case proceeding.',
  `effective_date` DATE COMMENT 'Date on which the approved rates become effective and are implemented for customer billing.',
  `filing_date` DATE COMMENT 'Date on which the rate case application was officially filed with the regulatory commission.',
  `filing_document_reference` STRING COMMENT 'Reference identifier or URL to the official rate case filing documents, testimony, exhibits, and supporting materials submitted to the regulatory commission.',
  `filing_status` STRING COMMENT 'Current lifecycle status of the rate case filing within the regulatory review process. Reference-value candidates: draft|filed|pending_review|suspended|hearing_scheduled|settlement_negotiations|final_order_issued|approved|denied|withdrawn.',
  `filing_type` STRING COMMENT 'Classification of the rate case filing indicating the nature of the regulatory request (e.g., general rate case, formula rate update, fuel adjustment clause, purchased power adjustment, rider, tariff amendment). Valid values: general_rate_case|formula_rate|fuel_adjustment|purchased_power_adjustment|rider|tariff_amendment.',
  `final_order_date` DATE COMMENT 'Date on which the regulatory commission issued its final order or decision on the rate case.',
  `final_order_outcome` STRING COMMENT 'Overall outcome of the rate case as determined in the final commission order. Valid values: approved_as_filed|approved_with_modifications|partially_approved|denied|withdrawn|remanded.',
  `hearing_scheduled_date` DATE COMMENT 'Date on which the regulatory hearing or evidentiary proceeding is scheduled to begin for this rate case.',
  `intervenor_count` INT COMMENT 'Number of intervenor parties formally participating in the rate case proceeding (e.g., consumer advocates, industrial customer groups, environmental organizations).',
  `intervenor_positions_summary` STRING COMMENT 'Summary of key positions and recommendations submitted by intervenor parties during the rate case proceeding.',
  `jurisdiction` STRING COMMENT 'Level of regulatory jurisdiction for this rate case (federal for FERC-jurisdictional wholesale rates, state for retail rates under state PUC authority, municipal for locally-regulated utilities). Valid values: federal|state|municipal.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this rate case filing record was last modified or updated in the system.',
  `operating_expenses` DECIMAL(18,2) COMMENT 'Total annual operating expenses included in the revenue requirement calculation, covering operations and maintenance costs, administrative expenses, and customer service costs.',
  `rate_design_methodology` STRING COMMENT 'Description of the rate design methodology proposed or approved in the rate case (e.g., cost-of-service, performance-based ratemaking, decoupling mechanism, time-of-use rates).',
  `rate_increase_percentage` DECIMAL(5,4) COMMENT 'Overall percentage increase in customer rates resulting from the approved revenue requirement. Expressed as a decimal (e.g., 0.0350 for 3.50% increase). Negative values indicate rate decreases.',
  `regulatory_commission` STRING COMMENT 'Name of the regulatory body with jurisdiction over this rate case (e.g., Federal Energy Regulatory Commission, California Public Utilities Commission, New York Public Service Commission).',
  `requested_rate_base` DECIMAL(18,2) COMMENT 'Total value of utility plant and other assets on which the utility requests to earn a return, also known as Regulatory Asset Base (RAB). Includes net plant in service, working capital, and other rate base components.',
  `requested_revenue_requirement` DECIMAL(18,2) COMMENT 'Total annual revenue requirement requested by the utility in the rate case filing, representing the sum of operating expenses, depreciation, taxes, and return on rate base.',
  `requested_roe` DECIMAL(5,4) COMMENT 'Return on equity percentage requested by the utility, representing the rate of return on shareholder equity investment. Expressed as a decimal (e.g., 0.1050 for 10.50%).',
  `requested_wacc` DECIMAL(5,4) COMMENT 'Weighted average cost of capital requested by the utility, representing the blended cost of debt and equity financing. Expressed as a decimal (e.g., 0.0725 for 7.25%).',
  `service_territory` STRING COMMENT 'Geographic service territory or region covered by this rate case filing (e.g., state name, county list, or service area designation).',
  `settlement_date` DATE COMMENT 'Date on which the settlement agreement was executed by the parties, if applicable.',
  `settlement_reached_flag` BOOLEAN COMMENT 'Indicates whether a settlement agreement was reached among parties prior to final commission decision (True if settlement reached, False otherwise).',
  `settlement_terms_summary` STRING COMMENT 'High-level summary of key settlement terms and conditions agreed upon by the parties, including revenue requirement, ROE, rate base adjustments, and other material provisions.',
  `sox_control_flag` BOOLEAN COMMENT 'Indicates whether this rate case filing is subject to SOX financial reporting controls and audit requirements (True for publicly-traded utilities, False otherwise).',
  `tax_expense` DECIMAL(18,2) COMMENT 'Total tax expense included in the revenue requirement, including federal and state income taxes, property taxes, and other applicable taxes.',
  `test_year_end_date` DATE COMMENT 'Ending date of the test year period used as the basis for revenue requirement calculations and rate design in the filing.',
  `test_year_start_date` DATE COMMENT 'Beginning date of the test year period used as the basis for revenue requirement calculations and rate design in the filing.',
  `test_year_type` STRING COMMENT 'Classification of the test year methodology used in the rate case (historical actual data, future projected data, or hybrid approach combining historical with known adjustments). Valid values: historical|future|hybrid.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_rate_case_filing` PRIMARY KEY (`rate_case_filing_id`)
)
USING DELTA
COMMENT 'Rate case financial model and filing record submitted to PUC or FERC. Captures filing date, docket number, test year, requested revenue requirement, allowed ROE, WACC, rate base (RAB), proposed rate schedules, intervenor positions, settlement terms, and final order outcome. SSOT for regulatory financial proceedings and revenue requirement determinations. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'RateCaseFiling',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.rate_case_filing'
);

-- RabValuation  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `finance`.`rab_valuation` (
  `rab_valuation_id` BIGINT NOT NULL COMMENT 'Unique identifier for the regulatory asset base valuation record.',
  `fixed_asset_id` BIGINT COMMENT 'FK to finance.fixed_asset.fixed_asset_id — RAB valuations are computed from the net book value of regulated fixed assets. The RAB must reference the underlying asset base to support rate case filings and PUC audits.',
  `irp_scenario_id` BIGINT COMMENT 'Foreign key linking to forecast.irp_scenario. Business justification: RAB valuations are calculated within IRP scenario contexts for different planning futures. Regulatory asset base projections depend on scenario-specific capex and depreciation assumptions for long-ter',
  `power_plant_id` BIGINT COMMENT 'Foreign key linking to generation.power_plant. Business justification: RAB valuations are performed at the plant level for regulatory returns, annual RAB roll-forward, and allowed return calculations. Critical for UK/international regulatory models.',
  `rate_case_filing_id` BIGINT COMMENT 'Foreign key linking to finance.rate_case_filing. Business justification: RAB valuations are prepared for and submitted as part of rate case filings to regulatory commissions. The rate_case_docket_number (STRING) should be replaced with FK to rate_case_filing.rate_case_fili',
  `accumulated_deferred_income_tax_amount` DECIMAL(18,2) COMMENT 'The accumulated deferred income tax liability that is deducted from the RAB, representing the tax benefit of accelerated depreciation and other timing differences between book and tax accounting.',
  `allowed_return_amount` DECIMAL(18,2) COMMENT 'The total dollar amount of return the utility is permitted to earn on the closing RAB, calculated as closing RAB multiplied by the allowed WACC or ROE. This is a key component of the revenue requirement.',
  `allowed_roe_percentage` DECIMAL(5,4) COMMENT 'The regulatory-approved return on equity percentage that the utility is permitted to earn on the equity portion of its RAB, expressed as a decimal (e.g., 0.0950 for 9.50%).',
  `approval_date` DATE COMMENT 'The date on which the regulatory commission formally approved this RAB valuation and associated revenue requirement.',
  `asset_category_code` STRING COMMENT 'The functional classification of assets included in this RAB valuation (generation, transmission, distribution, general plant, intangible assets, or common/shared assets). Valid values: GENERATION|TRANSMISSION|DISTRIBUTION|GENERAL_PLANT|INTANGIBLE|COMMON.',
  `asset_disposal_amount` DECIMAL(18,2) COMMENT 'The net book value of assets retired, sold, or otherwise removed from the rate base during the valuation period, including plant retirements and decommissioning.',
  `audit_trail_reference` STRING COMMENT 'A reference identifier linking this RAB valuation to supporting audit documentation, workpapers, and regulatory filings for compliance and audit trail purposes.',
  `business_area_code` STRING COMMENT 'The business segment or division code (e.g., electric, gas, water) to which this RAB valuation is allocated, used for segment reporting and cost allocation.',
  `capex_additions_amount` DECIMAL(18,2) COMMENT 'The total value of capital investments added to the rate base during the valuation period, including new generation, transmission, distribution assets, and major upgrades placed into service.',
  `closing_rab_amount` DECIMAL(18,2) COMMENT 'The net book value of rate base assets at the end of the valuation period, calculated as opening RAB plus CAPEX additions minus depreciation minus disposals plus inflation adjustments. This is the base on which the allowed return is calculated.',
  `company_code` STRING COMMENT 'The internal company or legal entity code for the utility operating company to which this RAB valuation applies, used for multi-entity consolidation.',
  `construction_work_in_progress_amount` DECIMAL(18,2) COMMENT 'The value of capital projects under construction that are included in the RAB before they are placed into service, subject to regulatory approval for CWIP-in-rate-base treatment.',
  `cost_of_debt_percentage` DECIMAL(5,4) COMMENT 'The weighted average interest rate on the utility\'s debt obligations, expressed as a decimal (e.g., 0.0450 for 4.50%). Used to calculate the debt component of WACC.',
  `created_by_user` STRING COMMENT 'The user ID or name of the person who created this RAB valuation record in the financial system.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this RAB valuation record was first created in the system.',
  `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code for all monetary amounts in this RAB valuation record (typically USD for US utilities). Pattern: ^[A-Z]{3}$.',
  `customer_advances_amount` DECIMAL(18,2) COMMENT 'The amount of customer contributions and advances for construction that are deducted from the RAB, representing funds provided by customers for line extensions and service installations.',
  `debt_ratio_percentage` DECIMAL(5,4) COMMENT 'The proportion of the RAB financed by debt capital, expressed as a decimal (e.g., 0.5000 for 50%). Used in conjunction with equity ratio to calculate WACC.',
  `depreciation_charge_amount` DECIMAL(18,2) COMMENT 'The total depreciation expense recognized during the valuation period, reducing the RAB in accordance with approved depreciation rates and asset useful lives.',
  `effective_end_date` DATE COMMENT 'The date on which this RAB valuation ceases to be effective for rate-making purposes, typically the end of a rate period or the start of a new rate case.',
  `effective_start_date` DATE COMMENT 'The date from which this RAB valuation becomes effective for rate-making purposes, typically the start of a new rate period.',
  `equity_ratio_percentage` DECIMAL(5,4) COMMENT 'The proportion of the RAB financed by equity capital, expressed as a decimal (e.g., 0.5000 for 50%). Used in conjunction with debt ratio to calculate WACC.',
  `inflation_indexation_amount` DECIMAL(18,2) COMMENT 'The adjustment to RAB for inflation indexation where applicable, used in jurisdictions that apply real-terms or indexed RAB methodologies (common in UK-style regulatory frameworks, less common in US FERC jurisdictions).',
  `jurisdiction_name` STRING COMMENT 'The full name of the regulatory jurisdiction or commission (e.g., \'California Public Utilities Commission\', \'Federal Energy Regulatory Commission\').',
  `last_modified_by_user` STRING COMMENT 'The user ID or name of the person who last modified this RAB valuation record.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this RAB valuation record was last modified in the system.',
  `notes` STRING COMMENT 'Free-form text field for additional comments, explanations, or context regarding this RAB valuation, including regulatory adjustments, special circumstances, or variance explanations.',
  `opening_rab_amount` DECIMAL(18,2) COMMENT 'The net book value of rate base assets at the beginning of the valuation period, representing the starting point for RAB roll-forward calculations.',
  `regulatory_asset_amount` DECIMAL(18,2) COMMENT 'The value of regulatory assets (deferred costs approved for future recovery) included in the RAB, such as deferred storm costs, pension obligations, or environmental remediation expenses.',
  `regulatory_jurisdiction_code` STRING COMMENT 'The regulatory authority governing this RAB valuation (FERC for interstate transmission, State PUC for retail distribution, ISO/RTO for market operations, or multi-jurisdictional for utilities operating across multiple territories). Valid values: FERC|STATE_PUC|MUNICIPAL|COOPERATIVE|ISO_RTO|MULTI_JURISDICTIONAL.',
  `regulatory_liability_amount` DECIMAL(18,2) COMMENT 'The value of regulatory liabilities (deferred credits to be returned to customers) that reduce the RAB, such as excess deferred taxes or over-collected revenues.',
  `sox_control_flag` BOOLEAN COMMENT 'Indicates whether this RAB valuation record is subject to SOX internal controls and audit requirements (True for publicly traded utilities, False otherwise).',
  `valuation_date` DATE COMMENT 'The date on which this RAB valuation is calculated and recorded, typically aligned with regulatory reporting periods (annual or rate case filing dates).',
  `valuation_method_code` STRING COMMENT 'The methodology used to value the RAB (historical cost, fair value, replacement cost, inflation-indexed, or hybrid approach), as prescribed by the regulatory jurisdiction. Valid values: HISTORICAL_COST|FAIR_VALUE|REPLACEMENT_COST|INDEXED|HYBRID.',
  `valuation_status` STRING COMMENT 'The current status of this RAB valuation in the regulatory review and approval process. Reference-value candidates: DRAFT|SUBMITTED|UNDER_REVIEW|APPROVED|REJECTED|AMENDED|FINAL.',
  `wacc_percentage` DECIMAL(5,4) COMMENT 'The blended cost of capital (debt and equity) approved by the regulator for calculating the allowed return on the RAB, expressed as a decimal (e.g., 0.0725 for 7.25%).',
  `working_capital_allowance_amount` DECIMAL(18,2) COMMENT 'The amount of working capital included in the RAB to cover the utility\'s operational cash flow needs, typically calculated as a percentage of operating expenses or using a lead-lag study.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_rab_valuation` PRIMARY KEY (`rab_valuation_id`)
)
USING DELTA
COMMENT 'Regulatory Asset Base valuation record representing the net value of utility assets on which a regulated return is earned. Captures valuation date, opening RAB, CAPEX additions, depreciation charge, disposals, inflation indexation, closing RAB, regulatory jurisdiction, and allowed return amount. Core input to revenue requirement calculations in PUC and FERC rate proceedings. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'RabValuation',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.rab_valuation'
);

-- IntercompanyTransaction  <<CIM ErpLedgerEntry : broad>>
CREATE TABLE IF NOT EXISTS `finance`.`intercompany_transaction` (
  `intercompany_transaction_id` BIGINT NOT NULL COMMENT 'Unique identifier for the intercompany transaction record. Primary key for this entity.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Intercompany transactions can be assigned to cost centers for tracking intercompany charges by organizational unit. The cost_center (STRING) should be replaced with FK to cost_center.cost_center_id.',
  `employee_id` BIGINT COMMENT 'Identifier of the person or role who approved the intercompany transaction.',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Intercompany transactions post to GL accounts for intercompany receivables, payables, and revenue/expense. The gl_account_code (STRING) should be replaced with FK to gl_account.gl_account_id.',
  `intercompany_journal_entry_id` BIGINT COMMENT 'FK to finance.journal_entry.journal_entry_id — Intercompany transactions generate journal entries in both sending and receiving company codes. The link to the GL posting is required for elimination processing and consolidated reporting.',
  `primary_journal_entry_id` BIGINT COMMENT 'FK to finance.journal_entry.journal_entry_id — Intercompany transactions generate journal entries for both sending and receiving entities. Required for consolidated financial reporting and elimination entries.',
  `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Intercompany transactions can be assigned to profit centers for internal management reporting and segment analysis. The profit_center (STRING) should be replaced with FK to profit_center.profit_center',
  `reversed_transaction_intercompany_transaction_id` BIGINT COMMENT 'Reference to the original intercompany transaction ID that this transaction reverses, if applicable.',
  `approval_date` DATE COMMENT 'Date when the intercompany transaction was approved by the designated authority.',
  `approval_status` STRING COMMENT 'Current approval status of the intercompany transaction in the workflow. Valid values: pending|approved|rejected.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the intercompany transaction record was first created in the system.',
  `cross_subsidy_prevention_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) marking transactions that require special scrutiny to ensure regulated utility customers do not subsidize unregulated business activities.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the transaction amount (e.g., USD, EUR, CAD). Pattern: ^[A-Z]{3}$.',
  `elimination_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) specifying whether this transaction should be eliminated during consolidated financial reporting to prevent double-counting.',
  `ferc_account_code` STRING COMMENT 'FERC Uniform System of Accounts code for regulatory financial reporting and compliance.',
  `ferc_affiliate_transaction_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) identifying whether this transaction must be disclosed under FERC affiliate transaction rules to prevent cross-subsidization.',
  `fiscal_period` INT COMMENT 'Fiscal period (month) within the fiscal year when the transaction is recorded.',
  `fiscal_year` INT COMMENT 'Fiscal year in which the intercompany transaction is recorded for financial reporting purposes.',
  `intercompany_transaction_description` STRING COMMENT 'Detailed textual description of the intercompany transaction, including business purpose and context.',
  `modified_by` STRING COMMENT 'User ID or name of the person who last modified the intercompany transaction record.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the intercompany transaction record was last modified in the system.',
  `net_amount` DECIMAL(18,2) COMMENT 'Net monetary value of the intercompany transaction after taxes and adjustments.',
  `netting_status` STRING COMMENT 'Indicates whether the intercompany transaction has been netted with offsetting transactions for settlement efficiency. Valid values: not_netted|netted|pending_netting.',
  `payment_terms` STRING COMMENT 'Payment terms agreed upon for the intercompany transaction (e.g., Net 30, Due on Receipt, Quarterly).',
  `posting_date` DATE COMMENT 'Date when the intercompany transaction was posted to the general ledger in the financial system.',
  `receiving_company_code` STRING COMMENT 'Company code of the legal entity receiving the intercompany transaction within the utility holding company group.',
  `receiving_company_name` STRING COMMENT 'Legal name of the receiving company entity (e.g., shared services company, fuel procurement entity).',
  `reference_document_number` STRING COMMENT 'Reference to the originating document, invoice, or agreement that supports this intercompany transaction.',
  `reversal_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) marking whether this transaction is a reversal or correction of a previous intercompany transaction.',
  `sending_company_code` STRING COMMENT 'Company code of the legal entity originating or sending the intercompany transaction within the utility holding company group.',
  `sending_company_name` STRING COMMENT 'Legal name of the sending company entity (e.g., regulated T&D utility, unregulated generation subsidiary).',
  `settlement_date` DATE COMMENT 'Date when the intercompany transaction was settled or cash was transferred between entities.',
  `source_document_reference` STRING COMMENT 'Unique identifier of the transaction in the source system for traceability and reconciliation.',
  `source_system` STRING COMMENT 'Name or identifier of the source system from which the intercompany transaction originated (e.g., SAP S/4HANA, Oracle ERP).',
  `sox_control_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) marking whether this transaction is subject to SOX internal control requirements and audit trails.',
  `tax_amount` DECIMAL(18,2) COMMENT 'Tax amount associated with the intercompany transaction, if applicable.',
  `transaction_amount` DECIMAL(18,2) COMMENT 'Gross monetary value of the intercompany transaction before any adjustments or taxes.',
  `transaction_date` DATE COMMENT 'Business date when the intercompany transaction occurred or was executed.',
  `transaction_number` STRING COMMENT 'Business-facing unique transaction number or document number assigned to this intercompany transaction for tracking and reference purposes.',
  `transaction_status` STRING COMMENT 'Current lifecycle status of the intercompany transaction in the financial workflow. Reference-value candidates: draft|pending_approval|approved|posted|settled|reversed|cancelled.',
  `transaction_type` STRING COMMENT 'Classification of the intercompany transaction indicating the nature of the financial exchange between legal entities. Reference-value candidates: management_fee|shared_service_allocation|intercompany_loan|dividend|cost_recharge|power_purchase|asset_transfer|royalty|interest_payment|capital_contribution.',
  `transfer_pricing_method` STRING COMMENT 'Method used to determine the pricing of the intercompany transaction to ensure arms-length compliance and regulatory adherence. Valid values: cost_plus|market_price|comparable_uncontrolled_price|resale_price|profit_split|transactional_net_margin.',
  `created_by` STRING COMMENT 'User ID or name of the person who created the intercompany transaction record in the system.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_intercompany_transaction` PRIMARY KEY (`intercompany_transaction_id`)
)
USING DELTA
COMMENT 'Intercompany financial transaction record between legal entities within the utility holding company group (e.g., regulated T&D utility, unregulated generation subsidiary, shared services company, fuel procurement entity). Captures sending and receiving company codes, transaction type (management fee, shared service allocation, intercompany loan, dividend, cost recharge, power purchase), amount, transfer pricing method, netting status, elimination flag for consolidation, and SOX/FERC affiliate transaction compliance reference. Supports consolidated financial reporting, FERC affiliate transaction disclosure (18 CFR 35.39), and cross-subsidy prevention controls. | CMM: CIM ErpLedgerEntry (broad), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'IntercompanyTransaction',
  'cmm.cim.class' = 'ErpLedgerEntry',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.intercompany_transaction'
);

-- TaxProvision  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `finance`.`tax_provision` (
  `tax_provision_id` BIGINT NOT NULL COMMENT 'Unique identifier for the corporate income tax provision record. Primary key for the tax provision entity.',
  `employee_id` BIGINT COMMENT 'Reference to the user who last modified this tax provision record.',
  `legal_entity_id` BIGINT COMMENT 'Reference to the legal entity for which this tax provision is recorded. Supports multi-entity consolidated financial reporting.',
  `primary_tax_employee_id` BIGINT COMMENT 'Reference to the user or employee who prepared this tax provision record.',
  `reviewer_employee_id` BIGINT COMMENT 'Reference to the user or employee who reviewed and approved this tax provision record.',
  `sox_control_id` BIGINT COMMENT 'The SOX control identifier associated with this tax provision record for internal control testing and audit trail purposes.',
  `tax_journal_entry_id` BIGINT COMMENT 'FK to finance.journal_entry.journal_entry_id — Tax provisions generate journal entries for current and deferred tax expense postings. Required for tax close process and FERC Form 1 tax schedules.',
  `to_journal_entry_id` BIGINT COMMENT 'FK to finance.journal_entry.journal_entry_id — Tax provisions are posted as journal entries for current tax expense, deferred tax movements, and ADIT adjustments. This FK enables tax-to-GL reconciliation and FERC Form 1 tax schedule preparation.',
  `adit_balance` DECIMAL(18,2) COMMENT 'The net accumulated deferred income tax balance (DTL minus DTA) used in regulatory rate base calculations per FERC requirements.',
  `adit_movement` DECIMAL(18,2) COMMENT 'The change in ADIT balance during the fiscal period, critical for regulatory asset base (RAB) adjustments and rate case filings.',
  `approval_date` DATE COMMENT 'The date on which this tax provision record was formally approved by the reviewer.',
  `audit_status` STRING COMMENT 'The current status of external audit review for this tax provision record. Valid values: not_audited|in_progress|completed|accepted|disputed.',
  `auditor_notes` STRING COMMENT 'Notes or comments from external auditors regarding this tax provision record, including any adjustments or findings.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this tax provision record was first created in the system.',
  `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code in which all monetary amounts in this tax provision record are denominated (e.g., USD). Pattern: ^[A-Z]{3}$.',
  `current_tax_expense` DECIMAL(18,2) COMMENT 'The portion of total income tax expense that is currently payable to tax authorities for the fiscal period.',
  `deferred_tax_asset` DECIMAL(18,2) COMMENT 'The cumulative balance of deferred tax assets arising from temporary differences, net operating losses, and tax credits that will reduce future tax payments.',
  `deferred_tax_expense` DECIMAL(18,2) COMMENT 'The portion of total income tax expense attributable to changes in deferred tax assets and liabilities for the fiscal period.',
  `deferred_tax_liability` DECIMAL(18,2) COMMENT 'The cumulative balance of deferred tax liabilities arising from temporary differences that will result in future tax payments.',
  `effective_tax_rate` DECIMAL(5,4) COMMENT 'The actual tax rate after adjustments for permanent differences, credits, and other items, expressed as a decimal. Key metric for FERC Form 1 and rate case filings.',
  `excess_adit_amortization` DECIMAL(18,2) COMMENT 'The amount of excess ADIT amortized during the fiscal period per average rate assumption method (ARAM) or other IRS-approved method.',
  `excess_adit_balance` DECIMAL(18,2) COMMENT 'The excess deferred income tax balance arising from the Tax Cuts and Jobs Act rate reduction, requiring amortization per IRS normalization rules.',
  `ferc_form1_schedule_reference` STRING COMMENT 'The FERC Form 1 schedule number(s) to which this tax provision record maps for regulatory reporting purposes (e.g., Schedule 261, 262, 263).',
  `fiscal_period` INT COMMENT 'The fiscal period (month or quarter) within the fiscal year for which the tax provision applies.',
  `fiscal_year` INT COMMENT 'The fiscal year for which the tax provision is calculated and recorded.',
  `flow_through_treatment_flag` BOOLEAN COMMENT 'Indicates whether the tax provision uses flow-through accounting treatment (True) or normalized accounting treatment (False) per regulatory requirements.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this tax provision record was last modified in the system.',
  `normalized_treatment_flag` BOOLEAN COMMENT 'Indicates whether the tax provision uses normalized accounting treatment (True) where tax benefits are deferred and amortized over the life of the related asset.',
  `notes` STRING COMMENT 'Free-form notes or comments regarding this tax provision record, including explanations of significant adjustments or unusual items.',
  `permanent_difference_adjustment` DECIMAL(18,2) COMMENT 'The net adjustment to tax expense for permanent book-tax differences that do not reverse over time (e.g., non-deductible expenses, tax-exempt income).',
  `pre_tax_income` DECIMAL(18,2) COMMENT 'Income before income taxes for the legal entity and fiscal period, serving as the base for tax provision calculation.',
  `provision_date` DATE COMMENT 'The date on which the tax provision was calculated and recorded in the financial system.',
  `provision_status` STRING COMMENT 'Current lifecycle status of the tax provision record indicating its stage in the financial close and reporting process. Valid values: draft|preliminary|final|amended|audited|filed.',
  `puc_filing_reference` STRING COMMENT 'The state PUC filing or docket number associated with this tax provision for rate case or regulatory reporting purposes.',
  `rab_impact_amount` DECIMAL(18,2) COMMENT 'The impact of this tax provision on the regulatory asset base calculation, primarily driven by ADIT adjustments that reduce rate base.',
  `rate_case_year` INT COMMENT 'The year of the rate case filing for which this tax provision data is used in revenue requirement calculations and ROE filings.',
  `source_document_reference` STRING COMMENT 'The unique document identifier in the source system that generated this tax provision record for audit trail and reconciliation purposes.',
  `source_system` STRING COMMENT 'The name of the source system from which this tax provision record originated (e.g., SAP S/4HANA, Oracle ERP).',
  `sox_certification_flag` BOOLEAN COMMENT 'Indicates whether this tax provision record has been reviewed and certified under SOX internal control procedures (True) or not (False).',
  `statutory_tax_rate` DECIMAL(5,4) COMMENT 'The statutory federal and state combined income tax rate applicable to the legal entity for the fiscal period, expressed as a decimal (e.g., 0.2100 for 21%).',
  `tax_credit_amount` DECIMAL(18,2) COMMENT 'The total tax credits claimed during the fiscal period, including renewable energy credits, research credits, and other federal and state credits.',
  `temporary_difference_adjustment` DECIMAL(18,2) COMMENT 'The net adjustment to deferred tax expense for temporary book-tax differences that will reverse in future periods (e.g., depreciation timing differences).',
  `total_tax_expense` DECIMAL(18,2) COMMENT 'The sum of current and deferred tax expense for the fiscal period, representing the total income tax provision recorded in the financial statements.',
  `uncertain_tax_position_reserve` DECIMAL(18,2) COMMENT 'The reserve for uncertain tax positions per FIN 48 (ASC 740-10) representing tax benefits that may not be sustained upon examination by tax authorities.',
  `utp_movement` DECIMAL(18,2) COMMENT 'The change in uncertain tax position reserve during the fiscal period due to new positions, settlements, or statute expirations.',
  `valuation_allowance` DECIMAL(18,2) COMMENT 'The valuation allowance against deferred tax assets when it is more likely than not that some or all of the DTA will not be realized.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_tax_provision` PRIMARY KEY (`tax_provision_id`)
)
USING DELTA
COMMENT 'Corporate income tax provision record capturing current and deferred tax components per legal entity and fiscal period. Records pre-tax income, statutory tax rate, effective tax rate, current tax expense, deferred tax asset and liability movements (ADIT), uncertain tax positions (FIN 48), and regulatory flow-through vs. normalized accounting treatment per FERC/PUC requirements. Includes excess deferred income tax (EDIT) tracking per Tax Cuts and Jobs Act provisions. Supports SOX tax controls, FERC Form 1 tax schedules, and rate case tax normalization filings. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'TaxProvision',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.tax_provision'
);

-- TreasuryPosition  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `finance`.`treasury_position` (
  `treasury_position_id` BIGINT NOT NULL COMMENT 'Unique identifier for the treasury position record. Primary key for the treasury position entity.',
  `primary_gl_account_id` BIGINT COMMENT 'FK to finance.gl_account.gl_account_id — Treasury positions (cash, debt instruments) must reconcile to GL accounts. Each treasury instrument maps to a GL account for balance sheet reporting.',
  `primary_treasury_employee_id` BIGINT COMMENT 'The SAP user ID of the treasury analyst or accountant who prepared the bank reconciliation. Part of the SOX control evidence for segregation of duties.',
  `reviewer_user_employee_id` BIGINT COMMENT 'The SAP user ID of the supervisor or manager who reviewed and approved the bank reconciliation. Part of the SOX control evidence for segregation of duties.',
  `to_gl_account_id` BIGINT COMMENT 'FK to finance.gl_account.gl_account_id — Treasury positions (cash, debt instruments, bank reconciliation items) map to GL accounts for balance sheet reporting. This FK enables treasury-to-GL reconciliation and daily cash position verificatio',
  `treasury_gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Treasury positions (debt instruments, cash positions) are tracked in GL accounts. The gl_account_code (STRING) should be replaced with FK to gl_account.gl_account_id, enabling JOIN to retrieve account',
  `approval_date` DATE COMMENT 'The date on which the bank reconciliation was formally approved by the reviewer. Used to track timeliness of reconciliation approval for SOX compliance.',
  `bank_account_number` STRING COMMENT 'The bank account number associated with cash positions. Used for bank reconciliation and cash management. Confidential business information.',
  `bank_charges_amount` DECIMAL(18,2) COMMENT 'The total amount of bank service charges, fees, and other deductions reflected on the bank statement but not yet recorded in the GL as of the reconciliation date.',
  `bank_key` STRING COMMENT 'The bank routing number or bank key used to identify the financial institution in SAP S/4HANA (e.g., ABA routing number in the US).',
  `bank_name` STRING COMMENT 'The name of the financial institution holding the cash account or providing the credit facility.',
  `company_code` STRING COMMENT 'SAP company code representing the legal entity for which this treasury position is maintained. Links to the organizational structure in SAP S/4HANA. Pattern: ^[A-Z0-9]{4}$.',
  `covenant_compliance_status` STRING COMMENT 'Indicates whether the utility is in compliance with all financial covenants associated with the debt instrument. Non-compliance may trigger default provisions or require remediation. Valid values: compliant|non_compliant|waived|not_applicable.',
  `covenant_description` STRING COMMENT 'Textual description of the key financial covenants associated with the debt instrument (e.g., minimum debt service coverage ratio, maximum leverage ratio, minimum equity requirements).',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this treasury position record was first created in the system. Audit trail field for data lineage and SOX compliance.',
  `credit_rating` STRING COMMENT 'The current credit rating assigned to the debt instrument by a recognized rating agency (e.g., Moody\'s, S&P, Fitch). Format examples: AAA, AA+, BBB-, etc.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the outstanding balance and related monetary amounts. Pattern: ^[A-Z]{3}$.',
  `debt_service_coverage_ratio` DECIMAL(7,4) COMMENT 'The ratio of cash available for debt servicing to interest, principal, and lease payments. Calculated as operating income divided by total debt service. A key covenant metric for utility debt instruments.',
  `deposits_in_transit_amount` DECIMAL(18,2) COMMENT 'The total amount of deposits recorded in the GL that have not yet been reflected in the bank statement as of the reconciliation date.',
  `ferc_account_code` STRING COMMENT 'The FERC Uniform System of Accounts code applicable to this treasury position for regulatory financial reporting (e.g., Account 131 for Cash, Account 221 for Bonds).',
  `gl_balance` DECIMAL(18,2) COMMENT 'The balance recorded in the general ledger for the cash account as of the reconciliation date. Used in the bank reconciliation process to identify discrepancies with the bank statement balance.',
  `instrument_number` STRING COMMENT 'Unique identifier or reference number for the specific financial instrument (e.g., bond CUSIP, loan agreement number, credit facility ID).',
  `instrument_type` STRING COMMENT 'Classification of the financial instrument held in the treasury position. Includes cash, short-term investments, credit facilities, commercial paper, first mortgage bonds, pollution control revenue bonds, tax-exempt bonds, and other debt instruments. Reference-value candidates: cash|short_term_investment|credit_facility|commercial_paper|first_mortgage_bond|pollution_control_revenue_bond|tax_exempt_bond|revolving_credit|term_loan.',
  `interest_rate` DECIMAL(7,4) COMMENT 'The current interest rate applicable to the instrument, expressed as a decimal percentage (e.g., 0.0525 for 5.25%). For debt instruments, this is the coupon or borrowing rate; for investments, this is the yield.',
  `interest_rate_index` STRING COMMENT 'The benchmark index used for variable or floating rate instruments (e.g., SOFR, LIBOR, Prime Rate). Null for fixed-rate instruments.',
  `interest_rate_type` STRING COMMENT 'Classification of the interest rate structure: fixed (constant rate), variable (adjusts periodically based on index), floating (market-based adjustment), or zero coupon (no periodic interest payments). Valid values: fixed|variable|floating|zero_coupon.',
  `issue_date` DATE COMMENT 'The date on which the debt instrument was originally issued or the investment was initiated.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this treasury position record was most recently updated. Audit trail field for data lineage and SOX compliance.',
  `liquidity_classification` STRING COMMENT 'Classification of the instrument based on its liquidity profile: immediate (cash and cash equivalents available on demand), short-term (maturities within one year), or long-term (maturities beyond one year). Valid values: immediate|short_term|long_term.',
  `maturity_date` DATE COMMENT 'The date on which the principal amount of the debt instrument is due for repayment, or the date when the investment matures. Null for perpetual instruments or demand deposits.',
  `notes` STRING COMMENT 'Free-text field for additional comments, explanations, or context related to the treasury position, reconciliation variances, or covenant compliance issues.',
  `outstanding_balance` DECIMAL(18,2) COMMENT 'The current outstanding principal balance or cash position for the instrument as of the position date. Positive values represent assets (cash, investments); negative values may represent overdrafts or liabilities.',
  `outstanding_checks_amount` DECIMAL(18,2) COMMENT 'The total amount of checks issued by the utility that have been recorded in the GL but have not yet cleared the bank as of the reconciliation date.',
  `position_date` DATE COMMENT 'The business date for which this treasury position snapshot is recorded. Represents the as-of date for cash and debt balances.',
  `position_status` STRING COMMENT 'The current lifecycle status of the treasury position: active (currently held), matured (reached maturity date), closed (position liquidated or paid off), or suspended (temporarily inactive). Valid values: active|matured|closed|suspended.',
  `preparer_name` STRING COMMENT 'The full name of the treasury analyst or accountant who prepared the bank reconciliation.',
  `rating_agency` STRING COMMENT 'The name of the credit rating agency that assigned the credit rating (e.g., Moody\'s Investors Service, Standard & Poor\'s, Fitch Ratings).',
  `reconciliation_date` DATE COMMENT 'The date on which the most recent bank reconciliation was performed for this cash position. Used to track the timeliness of reconciliation activities for SOX compliance.',
  `reconciliation_status` STRING COMMENT 'The current status of the bank reconciliation process for this cash position. Tracks the workflow from initial reconciliation through review and approval for SOX compliance. Valid values: reconciled|pending|variance_under_review|approved.',
  `reconciling_items_amount` DECIMAL(18,2) COMMENT 'The total amount of reconciling items identified during the bank reconciliation process (e.g., outstanding checks, deposits in transit, bank charges, errors). Sum of all reconciling adjustments.',
  `reviewer_name` STRING COMMENT 'The full name of the supervisor or manager who reviewed and approved the bank reconciliation.',
  `sox_control_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether this treasury position is subject to SOX internal control requirements. True for material cash accounts and debt instruments requiring enhanced reconciliation and approval controls.',
  `statement_balance` DECIMAL(18,2) COMMENT 'The balance reported on the bank statement as of the reconciliation date. Used in the bank reconciliation process to identify discrepancies with the GL balance.',
  `variance_amount` DECIMAL(18,2) COMMENT 'The net difference between the statement balance and the GL balance after accounting for all known reconciling items. A non-zero variance indicates unresolved discrepancies requiring investigation.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_treasury_position` PRIMARY KEY (`treasury_position_id`)
)
USING DELTA
COMMENT 'Treasury operations master in SAP S/4HANA covering cash and debt position management, liquidity monitoring, and bank reconciliation. Position attributes: position date, instrument type (cash, short-term investment, credit facility, commercial paper, first mortgage bond, pollution control revenue bond, tax-exempt bond), outstanding balance, interest rate (fixed/variable), maturity date, credit rating, debt covenant compliance status, and debt service coverage ratio. Bank reconciliation attributes: reconciliation date, bank account, statement balance, GL balance, reconciling items (outstanding checks, deposits in transit, bank charges), variance amount, reconciliation status, and preparer/reviewer sign-off. Supports daily cash positioning, liquidity risk management, bond covenant monitoring, bank statement reconciliation, SOX control evidence for cash accounts, and FERC balance sheet reporting. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'TreasuryPosition',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.treasury_position'
);

-- BankReconciliation  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `finance`.`bank_reconciliation` (
  `bank_reconciliation_id` BIGINT NOT NULL COMMENT 'Unique identifier for the bank reconciliation record. Primary key for the bank reconciliation entity.',
  `approver_user_employee_id` BIGINT COMMENT 'System user ID of the person who approved the bank reconciliation. Final sign-off authority per SOX control framework.',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Bank reconciliations reconcile bank accounts to GL accounts (cash accounts). The gl_account_code (STRING) should be replaced with FK to gl_account.gl_account_id, enabling JOIN to retrieve GL account m',
  `primary_bank_employee_id` BIGINT COMMENT 'System user ID of the person who prepared the bank reconciliation. Part of SOX-compliant segregation of duties control framework.',
  `reviewer_user_employee_id` BIGINT COMMENT 'System user ID of the person who reviewed the bank reconciliation. Must be different from preparer per SOX segregation of duties requirements.',
  `sox_control_id` BIGINT COMMENT 'Reference to the SOX control framework identifier for bank reconciliation controls. Links this reconciliation to the entity-level control testing program.',
  `treasury_position_id` BIGINT COMMENT 'FK to finance.treasury_position.treasury_position_id — Bank reconciliation references the bank account tracked in treasury positions. Required for daily cash position verification and liquidity management.',
  `prior_bank_reconciliation_id` BIGINT COMMENT 'Self-referencing FK on bank_reconciliation (prior_bank_reconciliation_id)',
  `adjusted_bank_balance` DECIMAL(18,2) COMMENT 'The bank statement balance after applying outstanding checks, deposits in transit, and other timing differences. Should equal the adjusted GL balance when reconciliation is complete.',
  `adjusted_gl_balance` DECIMAL(18,2) COMMENT 'The GL balance after applying all necessary adjustments for bank charges, interest, NSF checks, and other items. Should equal the adjusted bank balance when reconciliation is complete.',
  `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the bank reconciliation was approved. Final step in SOX-compliant reconciliation workflow.',
  `approver_name` STRING COMMENT 'Full name of the person who approved the bank reconciliation. Provides human-readable audit trail for SOX compliance.',
  `bank_charges_amount` DECIMAL(18,2) COMMENT 'Total amount of bank service charges, fees, and other deductions appearing on the bank statement but not yet recorded in the GL. Requires GL adjustment entry.',
  `bank_interest_earned_amount` DECIMAL(18,2) COMMENT 'Total amount of interest income credited by the bank but not yet recorded in the GL. Requires GL adjustment entry.',
  `bank_statement_reference` STRING COMMENT 'The bank\'s statement number or reference identifier for the statement being reconciled. Provides audit trail to source bank documents.',
  `clearing_document_count` INT COMMENT 'Number of payment clearing documents and bank statement line items matched during this reconciliation. Provides volume metric for reconciliation complexity.',
  `company_code` STRING COMMENT 'SAP company code identifying the legal entity for which the bank reconciliation is performed. Supports multi-entity financial consolidation.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the bank account and all monetary amounts in this reconciliation record. Pattern: ^[A-Z]{3}$.',
  `deposits_in_transit_amount` DECIMAL(18,2) COMMENT 'Total amount of deposits recorded in the GL but not yet reflected on the bank statement. Reconciling item increasing bank balance to GL balance.',
  `ferc_account_code` STRING COMMENT 'FERC Uniform System of Accounts code for the cash account. Required for regulatory financial reporting to FERC for utilities under federal jurisdiction.',
  `fiscal_period` INT COMMENT 'The fiscal period (month) within the fiscal year for this bank reconciliation. Supports monthly close processes and period-over-period analysis.',
  `fiscal_year` INT COMMENT 'The fiscal year to which this bank reconciliation belongs. Used for financial period reporting and SOX control testing organization.',
  `gl_balance` DECIMAL(18,2) COMMENT 'The balance in the general ledger cash account as of the reconciliation date. Represents the company\'s book balance before reconciling items.',
  `notes` STRING COMMENT 'Free-text field for preparer, reviewer, or approver comments regarding unusual items, variances, or resolution actions. Provides narrative audit trail.',
  `nsf_checks_amount` DECIMAL(18,2) COMMENT 'Total amount of customer checks returned by the bank due to insufficient funds. Requires GL adjustment to reverse the original deposit entry.',
  `other_reconciling_items_amount` DECIMAL(18,2) COMMENT 'Total amount of miscellaneous reconciling items not classified in standard categories. Includes wire transfer fees, foreign exchange adjustments, and other bank-initiated transactions.',
  `outstanding_checks_amount` DECIMAL(18,2) COMMENT 'Total amount of checks issued by the company that have been recorded in the GL but have not yet cleared the bank. Reconciling item reducing bank balance to GL balance.',
  `preparation_timestamp` TIMESTAMP COMMENT 'Date and time when the bank reconciliation was initially prepared. Establishes timeline for SOX control testing and audit evidence.',
  `preparer_name` STRING COMMENT 'Full name of the person who prepared the bank reconciliation. Provides human-readable audit trail for SOX compliance.',
  `reconciliation_date` DATE COMMENT 'The business date on which the bank reconciliation was performed. Represents the as-of date for the reconciliation snapshot.',
  `reconciliation_method` STRING COMMENT 'The method used to perform the bank reconciliation. Indicates level of automation and manual intervention required. Valid values: manual|semi_automated|fully_automated.',
  `reconciliation_status` STRING COMMENT 'Current workflow status of the bank reconciliation. Tracks progression from initial draft through review and approval stages. Valid values: draft|in_progress|balanced|unbalanced|approved|rejected.',
  `review_timestamp` TIMESTAMP COMMENT 'Date and time when the bank reconciliation was reviewed. Establishes timeline for SOX control testing and demonstrates timely review.',
  `reviewer_name` STRING COMMENT 'Full name of the person who reviewed the bank reconciliation. Provides human-readable audit trail for SOX compliance.',
  `source_document_reference` STRING COMMENT 'The unique identifier of this reconciliation record in the source system. Enables traceability back to the operational system for audit purposes.',
  `source_system` STRING COMMENT 'The system of record from which this bank reconciliation data originated. Typically SAP S/4HANA FI or treasury management system.',
  `sox_control_evidence_flag` BOOLEAN COMMENT 'Indicates whether this reconciliation record serves as evidence for SOX control testing. True for reconciliations selected for audit sample testing.',
  `statement_balance` DECIMAL(18,2) COMMENT 'The ending balance reported on the bank statement for the reconciliation period. Represents the bank\'s view of cash position.',
  `statement_date` DATE COMMENT 'The ending date of the bank statement being reconciled. Typically the last day of the statement period.',
  `unmatched_bank_items_count` INT COMMENT 'Number of bank statement line items that could not be matched to GL postings. Indicates potential missing entries or errors requiring investigation.',
  `unmatched_gl_items_count` INT COMMENT 'Number of GL postings that could not be matched to bank statement line items. Indicates potential timing differences or errors requiring investigation.',
  `variance_amount` DECIMAL(18,2) COMMENT 'The difference between adjusted bank balance and adjusted GL balance. A zero variance indicates a successful reconciliation; non-zero variance requires investigation and resolution.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_bank_reconciliation` PRIMARY KEY (`bank_reconciliation_id`)
)
USING DELTA
COMMENT 'Bank reconciliation record matching SAP S/4HANA FI bank statement line items to GL postings and payment clearing documents. Captures reconciliation date, bank account, statement balance, GL balance, reconciling items (outstanding checks, deposits in transit, bank charges), variance amount, reconciliation status, and preparer/reviewer sign-off. Supports daily cash position verification, SOX control evidence for cash accounts, and treasury audit trail. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'BankReconciliation',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.bank_reconciliation'
);

-- RegulatoryAssetRateCaseInclusion  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `finance`.`regulatory_asset_rate_case_inclusion` (
  `regulatory_asset_rate_case_inclusion_id` BIGINT NOT NULL COMMENT 'Unique identifier for this regulatory asset rate case inclusion record. Primary key.',
  `rate_case_filing_id` BIGINT COMMENT 'Foreign key linking to the rate case filing in which the regulatory asset is presented for recovery',
  `regulatory_asset_id` BIGINT COMMENT 'Foreign key linking to the regulatory asset or liability being included in the rate case filing',
  `approval_date` DATE COMMENT 'Date on which the regulatory commission issued its final order approving (or disallowing) recovery of this regulatory asset in this rate case. Null if still under review or withdrawn.',
  `approved_amortization_period_months` INT COMMENT 'Amortization period in months approved by the regulatory commission for this regulatory asset in this rate case. Becomes the basis for rate recovery implementation.',
  `approved_carrying_cost_rate` DECIMAL(5,4) COMMENT 'Annual carrying cost rate approved by the regulatory commission for this regulatory asset in this rate case. Used to calculate ongoing carrying costs during the amortization period.',
  `approved_recovery_amount` DECIMAL(18,2) COMMENT 'Total recovery amount for this regulatory asset approved by the regulatory commission in the final order for this rate case. May differ from requested amount due to commission disallowances or adjustments.',
  `disallowance_amount` DECIMAL(18,2) COMMENT 'Amount of the regulatory asset disallowed by the regulatory commission in this rate case (requested amount minus approved amount). Represents costs deemed imprudent or not recoverable.',
  `disallowance_reason` STRING COMMENT 'Regulatory commission\'s stated reason for any disallowance of the requested recovery amount for this regulatory asset in this rate case (e.g., imprudent costs, lack of documentation, alternative cost recovery method required).',
  `implementation_date` DATE COMMENT 'Date on which the approved recovery terms for this regulatory asset became effective in customer rates following this rate case. Used to trigger rate schedule updates and amortization schedule adjustments.',
  `inclusion_date` DATE COMMENT 'Date on which this regulatory asset was formally included in this rate case filing. Typically the filing date, but may differ if asset was added via amendment or supplemental filing.',
  `inclusion_status` STRING COMMENT 'Current lifecycle status of this regulatory asset\'s inclusion in this rate case filing. Values: proposed (internal planning), filed (submitted to commission), under_review (in regulatory proceeding), approved (commission approved full request), partially_approved (commission approved reduced amount), disallowed (commission rejected recovery), withdrawn (utility withdrew from filing).',
  `intervenor_position` STRING COMMENT 'Summary of intervenor or commission staff positions on this regulatory asset\'s recovery in this rate case (e.g., consumer advocate recommended 50% disallowance, staff recommended approval with modified amortization period). Captures regulatory proceeding dynamics.',
  `requested_amortization_period_months` INT COMMENT 'Amortization period in months requested by the utility for this regulatory asset in this rate case filing. May differ from the asset\'s authorized period if the utility is requesting a change.',
  `requested_carrying_cost_rate` DECIMAL(5,4) COMMENT 'Annual carrying cost rate (return rate) requested by the utility for this regulatory asset in this rate case filing. Typically based on WACC or authorized ROE.',
  `requested_recovery_amount` DECIMAL(18,2) COMMENT 'Total recovery amount for this regulatory asset requested by the utility in this specific rate case filing. This amount is specific to the asset-filing combination and may differ from the asset\'s carrying amount due to rate case strategy or partial recovery requests.',
  `settlement_included_flag` BOOLEAN COMMENT 'Indicates whether this regulatory asset was included in a settlement agreement reached during this rate case proceeding. If true, approved amounts reflect settlement terms rather than litigated outcome.',
  `testimony_reference` STRING COMMENT 'Reference to the specific witness testimony exhibit or schedule in the rate case filing that presents this regulatory asset (e.g., Exhibit RRA-3, Schedule 5.2). Used for regulatory proceeding tracking and audit trail.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_regulatory_asset_rate_case_inclusion` PRIMARY KEY (`regulatory_asset_rate_case_inclusion_id`)
)
USING DELTA
COMMENT 'This association product represents the inclusion and presentation of regulatory assets and liabilities in rate case filings submitted to regulatory commissions (PUC or FERC). Each record captures the requested and approved recovery amounts, amortization periods, carrying cost rates, and regulatory outcomes for a specific regulatory asset within a specific rate case proceeding. This is a core business entity in utility regulatory accounting, actively managed by rate case analysts and regulatory accountants throughout the rate case lifecycle from filing preparation through commission approval and implementation.. Existence Justification: In utility regulatory accounting, a single regulatory asset can be presented in multiple rate case filings over time (initial authorization, subsequent rate cases for continued recovery, or re-authorization after regulatory changes), and each rate case filing includes multiple regulatory assets in its revenue requirement calculation. Rate case analysts actively manage the inclusion of each asset in each filing, tracking requested vs. approved amounts, amortization periods, carrying cost rates, and commission rulings. This is a core operational business process with its own lifecycle (preparation, filing, testimony, commission review, approval/disallowance, implementation) that is tracked in regulatory accounting systems. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'RegulatoryAssetRateCaseInclusion',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.regulatory_asset_rate_case_inclusion'
);

-- ProjectCostAllocation  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `finance`.`project_cost_allocation` (
  `project_cost_allocation_id` BIGINT NOT NULL COMMENT 'Unique identifier for this project-cost center allocation relationship. Primary key.',
  `approved_by_employee_id` BIGINT COMMENT 'Employee ID of the manager who approved this cost allocation (typically the cost center manager or project sponsor). Links to employee master data.',
  `capex_project_id` BIGINT COMMENT 'Foreign key linking to the capital expenditure project receiving cost center funding',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to the cost center providing funding or charging costs to the project',
  `settlement_rule_id` BIGINT COMMENT 'SAP CO settlement rule identifier governing how costs are transferred from the cost center to the project WBS element. Links to SAP configuration for automated cost allocation.',
  `actual_cost_to_date` DECIMAL(18,2) COMMENT 'Cumulative actual costs posted to this project-cost center allocation to date, in USD. Tracks actual spend against the allocated budget for variance monitoring.',
  `allocation_end_date` DATE COMMENT 'Effective end date when this cost center stopped funding or charging costs to this capital project. Null if allocation is still active.',
  `allocation_start_date` DATE COMMENT 'Effective start date when this cost center began funding or charging costs to this capital project. Supports time-phased allocation tracking.',
  `allocation_status` STRING COMMENT 'Current lifecycle status of this cost allocation: approved (budget authorized but not yet active), active (costs being posted), suspended (temporarily halted), closed (project complete), cancelled (allocation revoked).',
  `allocation_type` STRING COMMENT 'Nature of the cost allocation relationship: direct_funding (cost center directly funds project), overhead_allocation (indirect cost distribution), shared_service (shared resource costs), interdepartmental_charge (cross-functional cost recovery).',
  `approval_date` DATE COMMENT 'Date when this cost allocation was approved by both the project manager and cost center manager. Required for budget governance and audit trail.',
  `budget_allocation_amount` DECIMAL(18,2) COMMENT 'The approved budget amount allocated from this cost center to this capital project, in USD. Represents the cost center\'s committed funding contribution to the project.',
  `notes` STRING COMMENT 'Free-text notes documenting the business justification for this allocation, special terms, or variance explanations. Used for audit trail and management reporting.',
  `percentage_allocation` DECIMAL(5,2) COMMENT 'Percentage of the project\'s total budget funded by this cost center, or percentage of the cost center\'s budget allocated to this project. Used for proportional cost distribution and variance analysis.',
  `variance_amount` DECIMAL(18,2) COMMENT 'Difference between allocated budget and actual cost to date for this specific cost center-project allocation, in USD. Positive indicates under-spend, negative indicates over-spend.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_project_cost_allocation` PRIMARY KEY (`project_cost_allocation_id`)
)
USING DELTA
COMMENT 'This association product represents the cost allocation agreement between capital projects and cost centers in SAP S/4HANA PS/CO integration. It captures the negotiated budget allocations, actual cost tracking, and variance analysis for cross-organizational capital project funding. Each record links one CAPEX project to one cost center with allocation percentages, budget amounts, and actual spend that exist only in the context of this funding relationship. This is a core operational entity in utility capital project management where projects are funded by multiple organizational units and cost centers contribute to multiple capital initiatives.. Existence Justification: In utility capital project management, projects are routinely funded by multiple cost centers (e.g., a substation upgrade funded by transmission operations, engineering services, and corporate IT), and cost centers contribute to multiple capital projects simultaneously. Project managers and cost center managers negotiate and actively manage these allocation agreements with specific budget amounts, approval workflows, and variance tracking. This is a core operational process in SAP PS/CO integration where the allocation itself is a managed business entity with its own lifecycle. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ProjectCostAllocation',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.project_cost_allocation'
);

-- VendorBankAccount  <<CIM ErpBankAccount : exact>>
CREATE TABLE IF NOT EXISTS `finance`.`vendor_bank_account` (
  `vendor_bank_account_id` BIGINT NOT NULL COMMENT 'Primary key for vendor_bank_account',
  `vendor_id` BIGINT COMMENT 'Identifier of the vendor that owns this bank account.',
  `replaced_vendor_bank_account_id` BIGINT COMMENT 'Self-referencing FK on vendor_bank_account (replaced_vendor_bank_account_id)',
  `account_classification` STRING COMMENT 'Indicates whether the account is domestic or foreign for regulatory reporting.',
  `account_holder_name` STRING COMMENT 'Legal name of the individual or entity that holds the account; may contain PII.',
  `account_name` STRING COMMENT 'Human-readable name or nickname for the bank account as used by the vendor.',
  `account_number` STRING COMMENT 'Primary bank account number used for payments; sensitive financial identifier.',
  `account_type` STRING COMMENT 'Category of the bank account indicating its purpose and transaction capabilities.',
  `bank_branch` STRING COMMENT 'Specific branch or location of the bank where the account is held.',
  `bank_name` STRING COMMENT 'Legal name of the financial institution holding the account.',
  `created_timestamp` TIMESTAMP COMMENT 'Date-time when the bank account record was first created in the system.',
  `credit_limit` DECIMAL(18,2) COMMENT 'Maximum credit amount authorized for the vendor on this account.',
  `currency_code` STRING COMMENT 'Three-letter ISO currency code of the account (e.g., USD, EUR).',
  `description` STRING COMMENT 'Free-form notes or remarks about the bank account.',
  `effective_from` DATE COMMENT 'Date when the bank account became effective for vendor payments.',
  `effective_until` DATE COMMENT 'Date when the bank account is no longer valid; null if open-ended.',
  `iban` STRING COMMENT 'Standardized international account identifier for cross-border transactions.',
  `is_primary` BOOLEAN COMMENT 'True if this is the vendor\'s primary bank account for payments.',
  `last_verified_date` DATE COMMENT 'Date when the bank account details were last validated by finance.',
  `routing_number` STRING COMMENT 'Domestic routing number (e.g., ABA) used to identify the bank in national payments.',
  `status` STRING COMMENT 'Current operational status of the bank account.',
  `swift_code` STRING COMMENT 'Bank Identifier Code used for international wire transfers.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date-time of the most recent modification to the bank account record.',
  `verification_status` STRING COMMENT 'Result of the most recent verification of the bank account information.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_vendor_bank_account` PRIMARY KEY (`vendor_bank_account_id`)
)
USING DELTA
COMMENT 'Master reference table for vendor_bank_account. Referenced by vendor_bank_account_id. | CMM: CIM ErpBankAccount (exact), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'VendorBankAccount',
  'cmm.cim.class' = 'ErpBankAccount',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.vendor_bank_account'
);

-- PaymentRun  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `finance`.`payment_run` (
  `payment_run_id` BIGINT NOT NULL COMMENT 'Primary key for payment_run',
  `vendor_id` BIGINT COMMENT 'Identifier of the vendor or counter-party receiving the payments in this run.',
  `previous_payment_run_id` BIGINT COMMENT 'Self-referencing FK on payment_run (previous_payment_run_id)',
  `approval_status` STRING COMMENT 'Current approval state of the payment run.',
  `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when the payment run received final approval.',
  `batch_number` STRING COMMENT 'Identifier used by external banking or clearing houses to reference this batch of payments.',
  `comments` STRING COMMENT 'Additional remarks or notes entered by users.',
  `cost_center_code` STRING COMMENT 'Internal cost-center code to which the payment run expenses are charged.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the payment run record was first created in the system.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the amounts in the payment run.',
  `description` STRING COMMENT 'Free-form text describing the purpose or context of the payment run.',
  `external_reference_code` STRING COMMENT 'Reference identifier from a third-party system (e.g., treasury platform) linked to this payment run.',
  `fiscal_period` STRING COMMENT 'Fiscal period (quarter) for reporting purposes.',
  `fiscal_year` INT COMMENT 'Fiscal year to which the payment run belongs.',
  `gross_amount` DECIMAL(18,2) COMMENT 'Total gross amount of all payments before taxes, fees, or discounts.',
  `is_automated` BOOLEAN COMMENT 'Flag indicating whether the payment run was generated automatically by a scheduled job.',
  `net_amount` DECIMAL(18,2) COMMENT 'Total net amount after taxes, fees, and discounts.',
  `payment_channel` STRING COMMENT 'Technical channel through which the payment run was processed.',
  `payment_method` STRING COMMENT 'Instrument used to execute the payments (e.g., ACH, wire, check).',
  `payment_run_type` STRING COMMENT 'Categorization of the payment run purpose.',
  `run_end_timestamp` TIMESTAMP COMMENT 'Timestamp when the payment run processing completed or was terminated.',
  `run_number` STRING COMMENT 'Human-readable identifier or code assigned to the payment run for tracking and reporting.',
  `run_start_timestamp` TIMESTAMP COMMENT 'Timestamp when the payment run processing actually started.',
  `run_timestamp` TIMESTAMP COMMENT 'Timestamp of the business event that triggered the payment run (e.g., scheduled execution time).',
  `scheduled_date` DATE COMMENT 'Planned calendar date for the payment run execution.',
  `source_system` STRING COMMENT 'Name of the source ERP or financial system that originated the payment run (e.g., SAP S/4HANA).',
  `status` STRING COMMENT 'Current processing state of the payment run.',
  `tax_amount` DECIMAL(18,2) COMMENT 'Aggregate tax component applied to the payment run.',
  `total_payments` INT COMMENT 'Number of individual payment line items included in this run.',
  `updated_by` STRING COMMENT 'User identifier of the person who last modified the payment run record.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the payment run record.',
  `created_by` STRING COMMENT 'User identifier of the person who created the payment run record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_payment_run` PRIMARY KEY (`payment_run_id`)
)
USING DELTA
COMMENT 'Master reference table for payment_run. Referenced by payment_run_id. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PaymentRun',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.payment_run'
);

-- DepreciationRun  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `finance`.`depreciation_run` (
  `depreciation_run_id` BIGINT NOT NULL COMMENT 'Primary key for depreciation_run',
  `previous_depreciation_run_id` BIGINT COMMENT 'Self-referencing FK on depreciation_run (previous_depreciation_run_id)',
  `actual_end_timestamp` TIMESTAMP COMMENT 'Exact timestamp when the depreciation run finished execution.',
  `actual_start_timestamp` TIMESTAMP COMMENT 'Exact timestamp when the depreciation run actually began execution.',
  `adjustment_amount` DECIMAL(18,2) COMMENT 'Net adjustments (e.g., reversals, corrections) applied to the gross depreciation total.',
  `assets_processed_count` INT COMMENT 'Number of individual fixed-asset records included in the depreciation calculation.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the depreciation run record was first created in the data lake.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 code of the currency in which depreciation amounts are expressed.',
  `depreciation_method` STRING COMMENT 'Accounting method used to calculate depreciation for the run.',
  `depreciation_rate_percent` DECIMAL(5,2) COMMENT 'Rate applied (as a percentage) when the depreciation method requires a rate, e.g., declining balance.',
  `effective_from` DATE COMMENT 'Start date of the accounting period to which the depreciation amounts apply.',
  `effective_until` DATE COMMENT 'End date of the accounting period covered by the depreciation run.',
  `error_flag` BOOLEAN COMMENT 'Indicates whether any errors occurred (true) or the run completed without errors (false).',
  `errors_count` INT COMMENT 'Number of errors or exceptions encountered during the run.',
  `fiscal_year` INT COMMENT 'Four-digit fiscal year to which the depreciation run belongs.',
  `net_depreciation_amount` DECIMAL(18,2) COMMENT 'Final depreciation amount after adjustments; used for financial reporting.',
  `notes` STRING COMMENT 'Additional free-form comments or observations about the depreciation run.',
  `period` STRING COMMENT 'Quarterly reporting period for the depreciation run.',
  `rab_valuation` DECIMAL(18,2) COMMENT 'Valuation of the asset base used for regulatory accounting, captured at run time.',
  `regulatory_report_flag` BOOLEAN COMMENT 'True if the run is generated for regulatory reporting purposes (e.g., FERC).',
  `run_description` STRING COMMENT 'Free-form text describing the purpose or special characteristics of the run.',
  `run_number` STRING COMMENT 'Human-readable identifier or code assigned to the depreciation run.',
  `run_type` STRING COMMENT 'Specifies whether the run is a full calculation, incremental update, or a re-process of prior data.',
  `scheduled_date` DATE COMMENT 'Planned calendar date on which the depreciation run is scheduled to start.',
  `status` STRING COMMENT 'Current processing state of the depreciation run.',
  `total_depreciation_amount` DECIMAL(18,2) COMMENT 'Gross sum of depreciation calculated in the run before any adjustments.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the depreciation run record.',
  `wacc_used` DECIMAL(5,2) COMMENT 'WACC percentage applied in the depreciation calculations for cost of capital considerations.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_depreciation_run` PRIMARY KEY (`depreciation_run_id`)
)
USING DELTA
COMMENT 'Master reference table for depreciation_run. Referenced by depreciation_run_id. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DepreciationRun',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.depreciation_run'
);

-- WbsElement  <<CIM ErpProjectAccounting : close>>
CREATE TABLE IF NOT EXISTS `finance`.`wbs_element` (
  `wbs_element_id` BIGINT NOT NULL COMMENT 'Primary key for wbs_element',
  `org_unit_id` BIGINT COMMENT 'Identifier of the organization unit accountable for the WBS element.',
  `parent_wbs_element_id` BIGINT COMMENT 'Identifier of the immediate parent WBS element in the hierarchy.',
  `project_id` BIGINT COMMENT 'Identifier of the overarching project to which the WBS element belongs.',
  `actual_cost` DECIMAL(18,2) COMMENT 'Actual cost incurred to date for the WBS element.',
  `budget_amount` DECIMAL(18,2) COMMENT 'Planned budget amount allocated to the WBS element.',
  `cost_center_code` STRING COMMENT 'Internal cost-center identifier responsible for the WBS element\'s expenses.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the WBS element record was first created in the system.',
  `description` STRING COMMENT 'Detailed textual description of the work scope represented by the WBS element.',
  `effective_from` DATE COMMENT 'Date when the WBS element becomes active for cost allocation.',
  `effective_until` DATE COMMENT 'Date when the WBS element is retired or no longer used for cost allocation (nullable).',
  `is_summary` BOOLEAN COMMENT 'Indicates whether the element aggregates child elements (true) or represents a leaf work package (false).',
  `profit_center_code` STRING COMMENT 'Internal profit-center identifier linked to the WBS element.',
  `status` STRING COMMENT 'Current lifecycle state of the WBS element.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the WBS element record.',
  `wbs_code` STRING COMMENT 'Hierarchical alphanumeric code that uniquely identifies the WBS element within the project hierarchy (e.g., 1.2.3).',
  `wbs_level` INT COMMENT 'Numeric depth of the element within the WBS hierarchy (root = 1).',
  `wbs_name` STRING COMMENT 'Human-readable name or title of the WBS element.',
  `wbs_path` STRING COMMENT 'Concatenated path of WBS codes from root to this element (e.g., 1/1.2/1.2.3).',
  `wbs_type` STRING COMMENT 'Category of the WBS element indicating its role in the project hierarchy.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_wbs_element` PRIMARY KEY (`wbs_element_id`)
)
USING DELTA
COMMENT 'Master reference table for wbs_element. Referenced by wbs_element_id. | CMM: CIM ErpProjectAccounting (close), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'WbsElement',
  'cmm.cim.class' = 'ErpProjectAccounting',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.wbs_element'
);

-- RecurringEntryTemplate  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `finance`.`recurring_entry_template` (
  `recurring_entry_template_id` BIGINT NOT NULL COMMENT 'Primary key for recurring_entry_template',
  `source_recurring_entry_template_id` BIGINT COMMENT 'Self-referencing FK on recurring_entry_template (source_recurring_entry_template_id)',
  `adjustment_amount` DECIMAL(18,2) COMMENT 'Monetary value of the adjustment (tax, fee, discount, etc.).',
  `adjustment_type` STRING COMMENT 'Type of monetary adjustment applied to the base amount.',
  `amount` DECIMAL(18,2) COMMENT 'Base monetary amount defined in the template before adjustments.',
  `cost_center` STRING COMMENT 'Cost center to which the recurring entry is allocated.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the template record was first created in the system.',
  `credit_account` STRING COMMENT 'GL account to be credited when the template is applied.',
  `currency_code` STRING COMMENT 'Three-letter ISO currency code for the template amount.',
  `debit_account` STRING COMMENT 'GL account to be debited when the template is applied.',
  `department_code` STRING COMMENT 'Organizational department responsible for the recurring entry.',
  `description` STRING COMMENT 'Free-text description of the purpose and usage of the template.',
  `end_date` DATE COMMENT 'Date when the recurring entry template expires; null for open-ended templates.',
  `frequency` STRING COMMENT 'Recurrence interval for the journal entry generated from the template.',
  `interval_multiplier` INT COMMENT 'Multiplier applied to the base frequency (e.g., every 2 weeks).',
  `is_taxable` BOOLEAN COMMENT 'Indicates whether the recurring entry amount is subject to tax.',
  `net_amount` DECIMAL(18,2) COMMENT 'Resulting amount after applying adjustments to the base amount.',
  `posting_day_of_month` INT COMMENT 'Day of month on which the entry is posted when frequency is monthly or higher.',
  `posting_month` INT COMMENT 'Month of year for annual postings; null for other frequencies.',
  `start_date` DATE COMMENT 'Date when the recurring entry template becomes effective for posting.',
  `status` STRING COMMENT 'Current lifecycle state of the template.',
  `tax_rate` DECIMAL(5,2) COMMENT 'Applicable tax rate percentage when is_taxable is true.',
  `template_code` STRING COMMENT 'External code or number used to reference the recurring entry template in finance processes.',
  `template_name` STRING COMMENT 'Human-readable name of the recurring entry template.',
  `template_type` STRING COMMENT 'Category of the recurring entry template indicating its financial purpose.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the template record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_recurring_entry_template` PRIMARY KEY (`recurring_entry_template_id`)
)
USING DELTA
COMMENT 'Master reference table for recurring_entry_template. Referenced by recurring_entry_template_id. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'RecurringEntryTemplate',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.recurring_entry_template'
);

-- CostElementGroup  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `finance`.`cost_element_group` (
  `cost_element_group_id` BIGINT NOT NULL COMMENT 'Primary key for cost_element_group',
  `parent_group_id` BIGINT COMMENT 'Identifier of the parent cost element group for hierarchical grouping.',
  `parent_cost_element_group_id` BIGINT COMMENT 'Self-referencing FK on cost_element_group (parent_cost_element_group_id)',
  `approved_by` STRING COMMENT 'Name of the individual who approved the cost element group configuration.',
  `cost_allocation_method` STRING COMMENT 'Method used to allocate costs from this group to downstream cost objects.',
  `cost_element_count` INT COMMENT 'Number of individual cost elements assigned to this group.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the cost element group record was first created in the system.',
  `default_currency` STRING COMMENT 'Three-letter ISO currency code for monetary values associated with the group.',
  `description` STRING COMMENT 'Detailed free-text description of the group purpose and scope.',
  `effective_from` DATE COMMENT 'Date on which the cost element group becomes effective for accounting.',
  `effective_until` DATE COMMENT 'Date on which the cost element group ceases to be effective; null if open-ended.',
  `external_reference` STRING COMMENT 'Identifier used by external ERP or reporting systems to reference this cost element group.',
  `financial_reporting_category` STRING COMMENT 'Category used for external financial reporting and regulatory filings.',
  `group_code` STRING COMMENT 'Short alphanumeric code used to reference the cost element group in external systems.',
  `group_name` STRING COMMENT 'Human-readable name of the cost element group.',
  `group_type` STRING COMMENT 'Classification of the group indicating its accounting nature.',
  `hierarchy_level` INT COMMENT 'Numeric level of the group within the cost element hierarchy (0 = top level).',
  `is_deprecated` BOOLEAN COMMENT 'Indicates whether the group is deprecated and should no longer be used for new postings.',
  `last_review_date` DATE COMMENT 'Date when the cost element group was last reviewed for accuracy and relevance.',
  `rab_valuation_method` STRING COMMENT 'Method used to value the group for regulatory asset base calculations.',
  `regulatory_reporting_flag` BOOLEAN COMMENT 'True if the group is included in mandatory regulatory reports (e.g., FERC).',
  `status` STRING COMMENT 'Current lifecycle status of the cost element group.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the cost element group record.',
  `wacc_applicable` BOOLEAN COMMENT 'Indicates whether the Weighted Average Cost of Capital is applied to this group for valuation.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_cost_element_group` PRIMARY KEY (`cost_element_group_id`)
)
USING DELTA
COMMENT 'Master reference table for cost_element_group. Referenced by cost_element_group_id. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CostElementGroup',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.cost_element_group'
);

-- FinanceLegalEntity  <<CIM Organisation : close>>
CREATE TABLE IF NOT EXISTS `finance`.`legal_entity` (
  `legal_entity_id` BIGINT NOT NULL COMMENT 'Primary key for legal_entity',
  `parent_legal_entity_id` BIGINT COMMENT 'Identifier of the immediate parent legal entity, if any.',
  `ultimate_parent_legal_entity_id` BIGINT COMMENT 'Identifier of the top-most parent legal entity in the corporate hierarchy.',
  `address_line1` STRING COMMENT 'First line of the entity\'s primary address.',
  `address_line2` STRING COMMENT 'Second line of the entity\'s primary address.',
  `annual_revenue` DECIMAL(18,2) COMMENT 'Total revenue reported for the most recent fiscal year.',
  `business_segment` STRING COMMENT 'Primary business segment or line of operation for the entity.',
  `city` STRING COMMENT 'City of the entity\'s primary address.',
  `cost_center_code` STRING COMMENT 'Internal cost-center identifier used for expense allocation.',
  `country` STRING COMMENT 'Three-letter ISO country code of the entity\'s primary location.',
  `credit_rating` STRING COMMENT 'External credit rating assigned to the entity.',
  `dissolution_date` DATE COMMENT 'Date the entity was legally dissolved, if applicable.',
  `entity_type` STRING COMMENT 'Classification of the entity\'s legal structure.',
  `financial_reporting_standard` STRING COMMENT 'Accounting framework applied by the entity for financial statements.',
  `fiscal_year_end_month` INT COMMENT 'Month (1-12) in which the entity\'s fiscal year ends.',
  `incorporation_date` DATE COMMENT 'Date the entity was legally formed.',
  `industry_code` STRING COMMENT 'Six-digit NAICS code representing the entity\'s primary industry.',
  `is_public` BOOLEAN COMMENT 'True if the entity is publicly listed; otherwise false.',
  `legal_entity_status_date` DATE COMMENT 'Date when the current status became effective.',
  `legal_name` STRING COMMENT 'The full registered legal name of the entity.',
  `market` STRING COMMENT 'Name of the exchange where the entity\'s securities are listed.',
  `number_of_employees` BIGINT COMMENT 'Total headcount employed by the entity.',
  `postal_code` STRING COMMENT 'Postal/ZIP code of the primary address.',
  `primary_contact_email` STRING COMMENT 'Email address of the primary contact.',
  `primary_contact_name` STRING COMMENT 'Name of the primary business contact for the entity.',
  `primary_contact_phone` STRING COMMENT 'Phone number of the primary contact.',
  `primary_contact_role` STRING COMMENT 'Job role of the primary contact within the entity.',
  `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the legal entity record was first created in the system.',
  `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the legal entity record.',
  `registration_number` STRING COMMENT 'Official registration number assigned by the jurisdiction of incorporation.',
  `registration_state` STRING COMMENT 'State or province where the entity is legally registered.',
  `regulatory_asset_base` DECIMAL(18,2) COMMENT 'Value of assets used for regulatory accounting purposes.',
  `reporting_currency` STRING COMMENT 'ISO currency code used for the entity\'s financial reporting.',
  `state` STRING COMMENT 'State or province of the entity\'s primary address.',
  `status` STRING COMMENT 'Current operational status of the entity.',
  `stock_ticker` STRING COMMENT 'Ticker symbol under which the entity trades on a public exchange.',
  `tax_identifier` STRING COMMENT 'Government-issued tax identifier for the entity.',
  `tax_jurisdiction` STRING COMMENT 'Jurisdiction (state/country) governing the entity\'s tax obligations.',
  `trade_name` STRING COMMENT 'Commonly used business name or brand of the entity.',
  `wacc` DECIMAL(5,4) COMMENT 'Entity\'s weighted average cost of capital expressed as a decimal.',
  `website` STRING COMMENT 'Public website URL of the entity.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_legal_entity` PRIMARY KEY (`legal_entity_id`)
)
USING DELTA
COMMENT 'Master reference table for legal_entity. Referenced by legal_entity_id. | CMM: CIM Organisation (close), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'FinanceLegalEntity',
  'cmm.cim.class' = 'Organisation',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.legal_entity'
);

-- SettlementRule  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `finance`.`settlement_rule` (
  `settlement_rule_id` BIGINT NOT NULL COMMENT 'Primary key for settlement_rule',
  `superseded_settlement_rule_id` BIGINT COMMENT 'Self-referencing FK on settlement_rule (superseded_settlement_rule_id)',
  `amount_cap` DECIMAL(15,2) COMMENT 'Upper limit on the settlement amount that can be generated by this rule.',
  `amount_floor` DECIMAL(15,2) COMMENT 'Lower limit on the settlement amount for this rule.',
  `applicable_region` STRING COMMENT 'ISO-3166-1 alpha-3 country code(s) where the rule applies.',
  `calculation_method` STRING COMMENT 'Method used to compute settlement amounts under this rule.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the settlement rule record was first created.',
  `currency_code` STRING COMMENT 'Three-letter ISO currency code for monetary amounts in the rule.',
  `effective_from` DATE COMMENT 'Date when the rule becomes effective for settlement calculations.',
  `effective_until` DATE COMMENT 'Date when the rule expires; null for open-ended rules.',
  `fixed_amount` DECIMAL(15,2) COMMENT 'Fixed monetary amount used when the rule is not percentage based.',
  `is_percentage_based` BOOLEAN COMMENT 'Indicates whether the rule uses a percentage rate instead of a fixed amount.',
  `last_review_date` DATE COMMENT 'Date when the rule was last reviewed for compliance or relevance.',
  `notes` STRING COMMENT 'Free-form comments or additional information about the rule.',
  `percentage_rate` DECIMAL(5,2) COMMENT 'Percentage rate applied when the rule is percentage based (e.g., 2.5%).',
  `rounding_method` STRING COMMENT 'Rounding approach applied to the calculated settlement amount.',
  `rule_code` STRING COMMENT 'Short alphanumeric code used to reference the settlement rule in financial systems.',
  `rule_description` STRING COMMENT 'Detailed description of the rule logic and purpose.',
  `rule_name` STRING COMMENT 'Human-readable name of the settlement rule.',
  `rule_type` STRING COMMENT 'Category of the rule indicating the calculation basis.',
  `rule_version` STRING COMMENT 'Version identifier for the rule, allowing tracking of changes over time.',
  `settlement_frequency` STRING COMMENT 'How often settlements are executed using this rule.',
  `source_system` STRING COMMENT 'Name of the source system (e.g., SAP S/4HANA FI/CO) where the rule originates.',
  `status` STRING COMMENT 'Current lifecycle state of the rule.',
  `tax_inclusion_flag` BOOLEAN COMMENT 'True if taxes are included in the settlement amount; otherwise false.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the settlement rule.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_finance_settlement_rule` PRIMARY KEY (`settlement_rule_id`)
)
USING DELTA
COMMENT 'Master reference table for settlement_rule. Referenced by settlement_rule_id. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SettlementRule',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.finance.settlement_rule'
);

-- ========= FOREIGN KEYS within finance (87) =========
ALTER TABLE `finance`.`profit_center` DROP CONSTRAINT IF EXISTS `fk_finance_profit_center_parent_profit_center_id`;
ALTER TABLE `finance`.`profit_center` ADD CONSTRAINT `fk_finance_profit_center_parent_profit_center_id` FOREIGN KEY (`parent_profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `finance`.`journal_entry` DROP CONSTRAINT IF EXISTS `fk_finance_journal_entry_capex_project_id`;
ALTER TABLE `finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_capex_project_id` FOREIGN KEY (`capex_project_id`) REFERENCES `finance`.`capex_project` (`capex_project_id`);

ALTER TABLE `finance`.`journal_entry` DROP CONSTRAINT IF EXISTS `fk_finance_journal_entry_cost_center_id`;
ALTER TABLE `finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `finance`.`journal_entry` DROP CONSTRAINT IF EXISTS `fk_finance_journal_entry_profit_center_id`;
ALTER TABLE `finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `finance`.`journal_entry` DROP CONSTRAINT IF EXISTS `fk_finance_journal_entry_recurring_entry_template_id`;
ALTER TABLE `finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_recurring_entry_template_id` FOREIGN KEY (`recurring_entry_template_id`) REFERENCES `finance`.`recurring_entry_template` (`recurring_entry_template_id`);

ALTER TABLE `finance`.`journal_entry_line` DROP CONSTRAINT IF EXISTS `fk_finance_journal_entry_line_fixed_asset_id`;
ALTER TABLE `finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `finance`.`fixed_asset` (`fixed_asset_id`);

ALTER TABLE `finance`.`journal_entry_line` DROP CONSTRAINT IF EXISTS `fk_finance_journal_entry_line_journal_cost_center_id`;
ALTER TABLE `finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_journal_cost_center_id` FOREIGN KEY (`journal_cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `finance`.`journal_entry_line` DROP CONSTRAINT IF EXISTS `fk_finance_journal_entry_line_journal_gl_account_id`;
ALTER TABLE `finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_journal_gl_account_id` FOREIGN KEY (`journal_gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `finance`.`journal_entry_line` DROP CONSTRAINT IF EXISTS `fk_finance_journal_entry_line_journal_profit_center_id`;
ALTER TABLE `finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_journal_profit_center_id` FOREIGN KEY (`journal_profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `finance`.`journal_entry_line` DROP CONSTRAINT IF EXISTS `fk_finance_journal_entry_line_primary_journal_entry_id`;
ALTER TABLE `finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_primary_journal_entry_id` FOREIGN KEY (`primary_journal_entry_id`) REFERENCES `finance`.`journal_entry` (`journal_entry_id`);

ALTER TABLE `finance`.`journal_entry_line` DROP CONSTRAINT IF EXISTS `fk_finance_journal_entry_line_to_cost_center_id`;
ALTER TABLE `finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_to_cost_center_id` FOREIGN KEY (`to_cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `finance`.`journal_entry_line` DROP CONSTRAINT IF EXISTS `fk_finance_journal_entry_line_to_gl_account_id`;
ALTER TABLE `finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_to_gl_account_id` FOREIGN KEY (`to_gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `finance`.`journal_entry_line` DROP CONSTRAINT IF EXISTS `fk_finance_journal_entry_line_to_journal_entry_id`;
ALTER TABLE `finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_to_journal_entry_id` FOREIGN KEY (`to_journal_entry_id`) REFERENCES `finance`.`journal_entry` (`journal_entry_id`);

ALTER TABLE `finance`.`journal_entry_line` DROP CONSTRAINT IF EXISTS `fk_finance_journal_entry_line_to_profit_center_id`;
ALTER TABLE `finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_to_profit_center_id` FOREIGN KEY (`to_profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `finance`.`ap_invoice` DROP CONSTRAINT IF EXISTS `fk_finance_ap_invoice_cost_center_id`;
ALTER TABLE `finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `finance`.`ap_invoice` DROP CONSTRAINT IF EXISTS `fk_finance_ap_invoice_gl_account_id`;
ALTER TABLE `finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `finance`.`ap_invoice` DROP CONSTRAINT IF EXISTS `fk_finance_ap_invoice_internal_order_id`;
ALTER TABLE `finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `finance`.`internal_order` (`internal_order_id`);

ALTER TABLE `finance`.`ap_invoice` DROP CONSTRAINT IF EXISTS `fk_finance_ap_invoice_journal_entry_id`;
ALTER TABLE `finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `finance`.`journal_entry` (`journal_entry_id`);

ALTER TABLE `finance`.`ap_payment` DROP CONSTRAINT IF EXISTS `fk_finance_ap_payment_ap_invoice_id`;
ALTER TABLE `finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_ap_invoice_id` FOREIGN KEY (`ap_invoice_id`) REFERENCES `finance`.`ap_invoice` (`ap_invoice_id`);

ALTER TABLE `finance`.`ap_payment` DROP CONSTRAINT IF EXISTS `fk_finance_ap_payment_cost_center_id`;
ALTER TABLE `finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `finance`.`ap_payment` DROP CONSTRAINT IF EXISTS `fk_finance_ap_payment_gl_account_id`;
ALTER TABLE `finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `finance`.`ap_payment` DROP CONSTRAINT IF EXISTS `fk_finance_ap_payment_payment_run_id`;
ALTER TABLE `finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_payment_run_id` FOREIGN KEY (`payment_run_id`) REFERENCES `finance`.`payment_run` (`payment_run_id`);

ALTER TABLE `finance`.`ap_payment` DROP CONSTRAINT IF EXISTS `fk_finance_ap_payment_primary_ap_invoice_id`;
ALTER TABLE `finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_primary_ap_invoice_id` FOREIGN KEY (`primary_ap_invoice_id`) REFERENCES `finance`.`ap_invoice` (`ap_invoice_id`);

ALTER TABLE `finance`.`ap_payment` DROP CONSTRAINT IF EXISTS `fk_finance_ap_payment_profit_center_id`;
ALTER TABLE `finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `finance`.`ap_payment` DROP CONSTRAINT IF EXISTS `fk_finance_ap_payment_vendor_bank_account_id`;
ALTER TABLE `finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_vendor_bank_account_id` FOREIGN KEY (`vendor_bank_account_id`) REFERENCES `finance`.`vendor_bank_account` (`vendor_bank_account_id`);

ALTER TABLE `finance`.`receivable` DROP CONSTRAINT IF EXISTS `fk_finance_receivable_cost_center_id`;
ALTER TABLE `finance`.`receivable` ADD CONSTRAINT `fk_finance_receivable_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `finance`.`receivable` DROP CONSTRAINT IF EXISTS `fk_finance_receivable_journal_entry_id`;
ALTER TABLE `finance`.`receivable` ADD CONSTRAINT `fk_finance_receivable_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `finance`.`journal_entry` (`journal_entry_id`);

ALTER TABLE `finance`.`receivable` DROP CONSTRAINT IF EXISTS `fk_finance_receivable_profit_center_id`;
ALTER TABLE `finance`.`receivable` ADD CONSTRAINT `fk_finance_receivable_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `finance`.`receivable` DROP CONSTRAINT IF EXISTS `fk_finance_receivable_receivable_gl_account_id`;
ALTER TABLE `finance`.`receivable` ADD CONSTRAINT `fk_finance_receivable_receivable_gl_account_id` FOREIGN KEY (`receivable_gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `finance`.`receivable` DROP CONSTRAINT IF EXISTS `fk_finance_receivable_to_gl_account_id`;
ALTER TABLE `finance`.`receivable` ADD CONSTRAINT `fk_finance_receivable_to_gl_account_id` FOREIGN KEY (`to_gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `finance`.`fixed_asset` DROP CONSTRAINT IF EXISTS `fk_finance_fixed_asset_cost_center_id`;
ALTER TABLE `finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `finance`.`fixed_asset` DROP CONSTRAINT IF EXISTS `fk_finance_fixed_asset_gl_account_id`;
ALTER TABLE `finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `finance`.`fixed_asset` DROP CONSTRAINT IF EXISTS `fk_finance_fixed_asset_regulatory_asset_id`;
ALTER TABLE `finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_regulatory_asset_id` FOREIGN KEY (`regulatory_asset_id`) REFERENCES `finance`.`regulatory_asset` (`regulatory_asset_id`);

ALTER TABLE `finance`.`asset_depreciation` DROP CONSTRAINT IF EXISTS `fk_finance_asset_depreciation_cost_center_id`;
ALTER TABLE `finance`.`asset_depreciation` ADD CONSTRAINT `fk_finance_asset_depreciation_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `finance`.`asset_depreciation` DROP CONSTRAINT IF EXISTS `fk_finance_asset_depreciation_depreciation_expense_gl_account_id`;
ALTER TABLE `finance`.`asset_depreciation` ADD CONSTRAINT `fk_finance_asset_depreciation_depreciation_expense_gl_account_id` FOREIGN KEY (`depreciation_expense_gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `finance`.`asset_depreciation` DROP CONSTRAINT IF EXISTS `fk_finance_asset_depreciation_depreciation_run_id`;
ALTER TABLE `finance`.`asset_depreciation` ADD CONSTRAINT `fk_finance_asset_depreciation_depreciation_run_id` FOREIGN KEY (`depreciation_run_id`) REFERENCES `finance`.`depreciation_run` (`depreciation_run_id`);

ALTER TABLE `finance`.`asset_depreciation` DROP CONSTRAINT IF EXISTS `fk_finance_asset_depreciation_fixed_asset_id`;
ALTER TABLE `finance`.`asset_depreciation` ADD CONSTRAINT `fk_finance_asset_depreciation_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `finance`.`fixed_asset` (`fixed_asset_id`);

ALTER TABLE `finance`.`asset_depreciation` DROP CONSTRAINT IF EXISTS `fk_finance_asset_depreciation_journal_entry_id`;
ALTER TABLE `finance`.`asset_depreciation` ADD CONSTRAINT `fk_finance_asset_depreciation_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `finance`.`journal_entry` (`journal_entry_id`);

ALTER TABLE `finance`.`asset_depreciation` DROP CONSTRAINT IF EXISTS `fk_finance_asset_depreciation_profit_center_id`;
ALTER TABLE `finance`.`asset_depreciation` ADD CONSTRAINT `fk_finance_asset_depreciation_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `finance`.`capex_project` DROP CONSTRAINT IF EXISTS `fk_finance_capex_project_profit_center_id`;
ALTER TABLE `finance`.`capex_project` ADD CONSTRAINT `fk_finance_capex_project_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `finance`.`capex_expenditure` DROP CONSTRAINT IF EXISTS `fk_finance_capex_expenditure_cost_center_id`;
ALTER TABLE `finance`.`capex_expenditure` ADD CONSTRAINT `fk_finance_capex_expenditure_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `finance`.`opex_budget` DROP CONSTRAINT IF EXISTS `fk_finance_opex_budget_cost_center_id`;
ALTER TABLE `finance`.`opex_budget` ADD CONSTRAINT `fk_finance_opex_budget_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `finance`.`opex_budget` DROP CONSTRAINT IF EXISTS `fk_finance_opex_budget_cost_element_group_id`;
ALTER TABLE `finance`.`opex_budget` ADD CONSTRAINT `fk_finance_opex_budget_cost_element_group_id` FOREIGN KEY (`cost_element_group_id`) REFERENCES `finance`.`cost_element_group` (`cost_element_group_id`);

ALTER TABLE `finance`.`opex_budget` DROP CONSTRAINT IF EXISTS `fk_finance_opex_budget_profit_center_id`;
ALTER TABLE `finance`.`opex_budget` ADD CONSTRAINT `fk_finance_opex_budget_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `finance`.`internal_order` DROP CONSTRAINT IF EXISTS `fk_finance_internal_order_internal_cost_center_id`;
ALTER TABLE `finance`.`internal_order` ADD CONSTRAINT `fk_finance_internal_order_internal_cost_center_id` FOREIGN KEY (`internal_cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `finance`.`internal_order` DROP CONSTRAINT IF EXISTS `fk_finance_internal_order_internal_profit_center_id`;
ALTER TABLE `finance`.`internal_order` ADD CONSTRAINT `fk_finance_internal_order_internal_profit_center_id` FOREIGN KEY (`internal_profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `finance`.`internal_order` DROP CONSTRAINT IF EXISTS `fk_finance_internal_order_internal_responsible_cost_center_id`;
ALTER TABLE `finance`.`internal_order` ADD CONSTRAINT `fk_finance_internal_order_internal_responsible_cost_center_id` FOREIGN KEY (`internal_responsible_cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `finance`.`internal_order` DROP CONSTRAINT IF EXISTS `fk_finance_internal_order_primary_settlement_gl_account_id`;
ALTER TABLE `finance`.`internal_order` ADD CONSTRAINT `fk_finance_internal_order_primary_settlement_gl_account_id` FOREIGN KEY (`primary_settlement_gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `finance`.`internal_order` DROP CONSTRAINT IF EXISTS `fk_finance_internal_order_to_profit_center_id`;
ALTER TABLE `finance`.`internal_order` ADD CONSTRAINT `fk_finance_internal_order_to_profit_center_id` FOREIGN KEY (`to_profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `finance`.`internal_order` DROP CONSTRAINT IF EXISTS `fk_finance_internal_order_wbs_element_id`;
ALTER TABLE `finance`.`internal_order` ADD CONSTRAINT `fk_finance_internal_order_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `finance`.`wbs_element` (`wbs_element_id`);

ALTER TABLE `finance`.`regulatory_asset` DROP CONSTRAINT IF EXISTS `fk_finance_regulatory_asset_cost_center_id`;
ALTER TABLE `finance`.`regulatory_asset` ADD CONSTRAINT `fk_finance_regulatory_asset_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `finance`.`regulatory_asset` DROP CONSTRAINT IF EXISTS `fk_finance_regulatory_asset_gl_account_id`;
ALTER TABLE `finance`.`regulatory_asset` ADD CONSTRAINT `fk_finance_regulatory_asset_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `finance`.`rate_case_filing` DROP CONSTRAINT IF EXISTS `fk_finance_rate_case_filing_primary_regulatory_asset_id`;
ALTER TABLE `finance`.`rate_case_filing` ADD CONSTRAINT `fk_finance_rate_case_filing_primary_regulatory_asset_id` FOREIGN KEY (`primary_regulatory_asset_id`) REFERENCES `finance`.`regulatory_asset` (`regulatory_asset_id`);

ALTER TABLE `finance`.`rate_case_filing` DROP CONSTRAINT IF EXISTS `fk_finance_rate_case_filing_rate_regulatory_asset_id`;
ALTER TABLE `finance`.`rate_case_filing` ADD CONSTRAINT `fk_finance_rate_case_filing_rate_regulatory_asset_id` FOREIGN KEY (`rate_regulatory_asset_id`) REFERENCES `finance`.`regulatory_asset` (`regulatory_asset_id`);

ALTER TABLE `finance`.`rab_valuation` DROP CONSTRAINT IF EXISTS `fk_finance_rab_valuation_fixed_asset_id`;
ALTER TABLE `finance`.`rab_valuation` ADD CONSTRAINT `fk_finance_rab_valuation_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `finance`.`fixed_asset` (`fixed_asset_id`);

ALTER TABLE `finance`.`rab_valuation` DROP CONSTRAINT IF EXISTS `fk_finance_rab_valuation_rate_case_filing_id`;
ALTER TABLE `finance`.`rab_valuation` ADD CONSTRAINT `fk_finance_rab_valuation_rate_case_filing_id` FOREIGN KEY (`rate_case_filing_id`) REFERENCES `finance`.`rate_case_filing` (`rate_case_filing_id`);

ALTER TABLE `finance`.`intercompany_transaction` DROP CONSTRAINT IF EXISTS `fk_finance_intercompany_transaction_cost_center_id`;
ALTER TABLE `finance`.`intercompany_transaction` ADD CONSTRAINT `fk_finance_intercompany_transaction_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `finance`.`intercompany_transaction` DROP CONSTRAINT IF EXISTS `fk_finance_intercompany_transaction_gl_account_id`;
ALTER TABLE `finance`.`intercompany_transaction` ADD CONSTRAINT `fk_finance_intercompany_transaction_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `finance`.`intercompany_transaction` DROP CONSTRAINT IF EXISTS `fk_finance_intercompany_transaction_intercompany_journal_entry_id`;
ALTER TABLE `finance`.`intercompany_transaction` ADD CONSTRAINT `fk_finance_intercompany_transaction_intercompany_journal_entry_id` FOREIGN KEY (`intercompany_journal_entry_id`) REFERENCES `finance`.`journal_entry` (`journal_entry_id`);

ALTER TABLE `finance`.`intercompany_transaction` DROP CONSTRAINT IF EXISTS `fk_finance_intercompany_transaction_primary_journal_entry_id`;
ALTER TABLE `finance`.`intercompany_transaction` ADD CONSTRAINT `fk_finance_intercompany_transaction_primary_journal_entry_id` FOREIGN KEY (`primary_journal_entry_id`) REFERENCES `finance`.`journal_entry` (`journal_entry_id`);

ALTER TABLE `finance`.`intercompany_transaction` DROP CONSTRAINT IF EXISTS `fk_finance_intercompany_transaction_profit_center_id`;
ALTER TABLE `finance`.`intercompany_transaction` ADD CONSTRAINT `fk_finance_intercompany_transaction_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `finance`.`intercompany_transaction` DROP CONSTRAINT IF EXISTS `fk_finance_intercompany_transaction_reversed_transaction_intercompany_transaction_id`;
ALTER TABLE `finance`.`intercompany_transaction` ADD CONSTRAINT `fk_finance_intercompany_transaction_reversed_transaction_intercompany_transaction_id` FOREIGN KEY (`reversed_transaction_intercompany_transaction_id`) REFERENCES `finance`.`intercompany_transaction` (`intercompany_transaction_id`);

ALTER TABLE `finance`.`tax_provision` DROP CONSTRAINT IF EXISTS `fk_finance_tax_provision_legal_entity_id`;
ALTER TABLE `finance`.`tax_provision` ADD CONSTRAINT `fk_finance_tax_provision_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `finance`.`legal_entity` (`legal_entity_id`);

ALTER TABLE `finance`.`tax_provision` DROP CONSTRAINT IF EXISTS `fk_finance_tax_provision_tax_journal_entry_id`;
ALTER TABLE `finance`.`tax_provision` ADD CONSTRAINT `fk_finance_tax_provision_tax_journal_entry_id` FOREIGN KEY (`tax_journal_entry_id`) REFERENCES `finance`.`journal_entry` (`journal_entry_id`);

ALTER TABLE `finance`.`tax_provision` DROP CONSTRAINT IF EXISTS `fk_finance_tax_provision_to_journal_entry_id`;
ALTER TABLE `finance`.`tax_provision` ADD CONSTRAINT `fk_finance_tax_provision_to_journal_entry_id` FOREIGN KEY (`to_journal_entry_id`) REFERENCES `finance`.`journal_entry` (`journal_entry_id`);

ALTER TABLE `finance`.`treasury_position` DROP CONSTRAINT IF EXISTS `fk_finance_treasury_position_primary_gl_account_id`;
ALTER TABLE `finance`.`treasury_position` ADD CONSTRAINT `fk_finance_treasury_position_primary_gl_account_id` FOREIGN KEY (`primary_gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `finance`.`treasury_position` DROP CONSTRAINT IF EXISTS `fk_finance_treasury_position_to_gl_account_id`;
ALTER TABLE `finance`.`treasury_position` ADD CONSTRAINT `fk_finance_treasury_position_to_gl_account_id` FOREIGN KEY (`to_gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `finance`.`treasury_position` DROP CONSTRAINT IF EXISTS `fk_finance_treasury_position_treasury_gl_account_id`;
ALTER TABLE `finance`.`treasury_position` ADD CONSTRAINT `fk_finance_treasury_position_treasury_gl_account_id` FOREIGN KEY (`treasury_gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `finance`.`bank_reconciliation` DROP CONSTRAINT IF EXISTS `fk_finance_bank_reconciliation_gl_account_id`;
ALTER TABLE `finance`.`bank_reconciliation` ADD CONSTRAINT `fk_finance_bank_reconciliation_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `finance`.`bank_reconciliation` DROP CONSTRAINT IF EXISTS `fk_finance_bank_reconciliation_treasury_position_id`;
ALTER TABLE `finance`.`bank_reconciliation` ADD CONSTRAINT `fk_finance_bank_reconciliation_treasury_position_id` FOREIGN KEY (`treasury_position_id`) REFERENCES `finance`.`treasury_position` (`treasury_position_id`);

ALTER TABLE `finance`.`bank_reconciliation` DROP CONSTRAINT IF EXISTS `fk_finance_bank_reconciliation_prior_bank_reconciliation_id`;
ALTER TABLE `finance`.`bank_reconciliation` ADD CONSTRAINT `fk_finance_bank_reconciliation_prior_bank_reconciliation_id` FOREIGN KEY (`prior_bank_reconciliation_id`) REFERENCES `finance`.`bank_reconciliation` (`bank_reconciliation_id`);

ALTER TABLE `finance`.`regulatory_asset_rate_case_inclusion` DROP CONSTRAINT IF EXISTS `fk_finance_regulatory_asset_rate_case_inclusion_rate_case_filing_id`;
ALTER TABLE `finance`.`regulatory_asset_rate_case_inclusion` ADD CONSTRAINT `fk_finance_regulatory_asset_rate_case_inclusion_rate_case_filing_id` FOREIGN KEY (`rate_case_filing_id`) REFERENCES `finance`.`rate_case_filing` (`rate_case_filing_id`);

ALTER TABLE `finance`.`regulatory_asset_rate_case_inclusion` DROP CONSTRAINT IF EXISTS `fk_finance_regulatory_asset_rate_case_inclusion_regulatory_asset_id`;
ALTER TABLE `finance`.`regulatory_asset_rate_case_inclusion` ADD CONSTRAINT `fk_finance_regulatory_asset_rate_case_inclusion_regulatory_asset_id` FOREIGN KEY (`regulatory_asset_id`) REFERENCES `finance`.`regulatory_asset` (`regulatory_asset_id`);

ALTER TABLE `finance`.`project_cost_allocation` DROP CONSTRAINT IF EXISTS `fk_finance_project_cost_allocation_capex_project_id`;
ALTER TABLE `finance`.`project_cost_allocation` ADD CONSTRAINT `fk_finance_project_cost_allocation_capex_project_id` FOREIGN KEY (`capex_project_id`) REFERENCES `finance`.`capex_project` (`capex_project_id`);

ALTER TABLE `finance`.`project_cost_allocation` DROP CONSTRAINT IF EXISTS `fk_finance_project_cost_allocation_cost_center_id`;
ALTER TABLE `finance`.`project_cost_allocation` ADD CONSTRAINT `fk_finance_project_cost_allocation_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `finance`.`project_cost_allocation` DROP CONSTRAINT IF EXISTS `fk_finance_project_cost_allocation_settlement_rule_id`;
ALTER TABLE `finance`.`project_cost_allocation` ADD CONSTRAINT `fk_finance_project_cost_allocation_settlement_rule_id` FOREIGN KEY (`settlement_rule_id`) REFERENCES `finance`.`settlement_rule` (`settlement_rule_id`);

ALTER TABLE `finance`.`vendor_bank_account` DROP CONSTRAINT IF EXISTS `fk_finance_vendor_bank_account_replaced_vendor_bank_account_id`;
ALTER TABLE `finance`.`vendor_bank_account` ADD CONSTRAINT `fk_finance_vendor_bank_account_replaced_vendor_bank_account_id` FOREIGN KEY (`replaced_vendor_bank_account_id`) REFERENCES `finance`.`vendor_bank_account` (`vendor_bank_account_id`);

ALTER TABLE `finance`.`payment_run` DROP CONSTRAINT IF EXISTS `fk_finance_payment_run_previous_payment_run_id`;
ALTER TABLE `finance`.`payment_run` ADD CONSTRAINT `fk_finance_payment_run_previous_payment_run_id` FOREIGN KEY (`previous_payment_run_id`) REFERENCES `finance`.`payment_run` (`payment_run_id`);

ALTER TABLE `finance`.`depreciation_run` DROP CONSTRAINT IF EXISTS `fk_finance_depreciation_run_previous_depreciation_run_id`;
ALTER TABLE `finance`.`depreciation_run` ADD CONSTRAINT `fk_finance_depreciation_run_previous_depreciation_run_id` FOREIGN KEY (`previous_depreciation_run_id`) REFERENCES `finance`.`depreciation_run` (`depreciation_run_id`);

ALTER TABLE `finance`.`wbs_element` DROP CONSTRAINT IF EXISTS `fk_finance_wbs_element_parent_wbs_element_id`;
ALTER TABLE `finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_parent_wbs_element_id` FOREIGN KEY (`parent_wbs_element_id`) REFERENCES `finance`.`wbs_element` (`wbs_element_id`);

ALTER TABLE `finance`.`wbs_element` DROP CONSTRAINT IF EXISTS `fk_finance_wbs_element_project_id`;
ALTER TABLE `finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_project_id` FOREIGN KEY (`project_id`) REFERENCES `finance`.`capex_project` (`capex_project_id`);

ALTER TABLE `finance`.`recurring_entry_template` DROP CONSTRAINT IF EXISTS `fk_finance_recurring_entry_template_source_recurring_entry_template_id`;
ALTER TABLE `finance`.`recurring_entry_template` ADD CONSTRAINT `fk_finance_recurring_entry_template_source_recurring_entry_template_id` FOREIGN KEY (`source_recurring_entry_template_id`) REFERENCES `finance`.`recurring_entry_template` (`recurring_entry_template_id`);

ALTER TABLE `finance`.`cost_element_group` DROP CONSTRAINT IF EXISTS `fk_finance_cost_element_group_parent_group_id`;
ALTER TABLE `finance`.`cost_element_group` ADD CONSTRAINT `fk_finance_cost_element_group_parent_group_id` FOREIGN KEY (`parent_group_id`) REFERENCES `finance`.`cost_element_group` (`cost_element_group_id`);

ALTER TABLE `finance`.`cost_element_group` DROP CONSTRAINT IF EXISTS `fk_finance_cost_element_group_parent_cost_element_group_id`;
ALTER TABLE `finance`.`cost_element_group` ADD CONSTRAINT `fk_finance_cost_element_group_parent_cost_element_group_id` FOREIGN KEY (`parent_cost_element_group_id`) REFERENCES `finance`.`cost_element_group` (`cost_element_group_id`);

ALTER TABLE `finance`.`legal_entity` DROP CONSTRAINT IF EXISTS `fk_finance_legal_entity_parent_legal_entity_id`;
ALTER TABLE `finance`.`legal_entity` ADD CONSTRAINT `fk_finance_legal_entity_parent_legal_entity_id` FOREIGN KEY (`parent_legal_entity_id`) REFERENCES `finance`.`legal_entity` (`legal_entity_id`);

ALTER TABLE `finance`.`legal_entity` DROP CONSTRAINT IF EXISTS `fk_finance_legal_entity_ultimate_parent_legal_entity_id`;
ALTER TABLE `finance`.`legal_entity` ADD CONSTRAINT `fk_finance_legal_entity_ultimate_parent_legal_entity_id` FOREIGN KEY (`ultimate_parent_legal_entity_id`) REFERENCES `finance`.`legal_entity` (`legal_entity_id`);

ALTER TABLE `finance`.`settlement_rule` DROP CONSTRAINT IF EXISTS `fk_finance_settlement_rule_superseded_settlement_rule_id`;
ALTER TABLE `finance`.`settlement_rule` ADD CONSTRAINT `fk_finance_settlement_rule_superseded_settlement_rule_id` FOREIGN KEY (`superseded_settlement_rule_id`) REFERENCES `finance`.`settlement_rule` (`settlement_rule_id`);

