-- Utility CMM-aligned Canonical Data Model (Silver) v1.0.0 | source: Databricks lakehouse-industry-data-models energy_utilities v1 ECM | generated 2026-10-13
-- 16 | Subject area: trading | 35 tables | CIM packages: IEC62325::MarketCommon; IEC62325::ParticipantInterfaces; IEC62325::MarketResults; IEC62325::ReferenceData; IEC62325::CongestionRevenueRights
-- Standards: IEC 62325-301; IEC 62325-351; NAESB WEQ; FERC EQR; EEI/ISDA Master Agreements
-- Contents: tables (with PK + NOT NULL), then intra-subject-area foreign keys.
-- Unity Catalog PK/FK constraints are informational (NOT ENFORCED); NOT NULL is enforced.

USE CATALOG `utility_cmm_silver`;

-- Trade  <<CIM Trade : close>>
CREATE TABLE IF NOT EXISTS `trading`.`trade` (
  `trade_id` BIGINT NOT NULL COMMENT 'Unique identifier for the wholesale energy trade transaction. Primary key for the trade entity.',
  `audit_finding_id` BIGINT COMMENT 'Foreign key linking to compliance.audit_finding. Business justification: Specific trades are cited in audit findings for unauthorized trading, limit breaches, or confirmation failures. Audit findings reference specific trade IDs as evidence of control deficiencies, enablin',
  `book_id` BIGINT COMMENT 'FK to trading.trading_book',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Energy trades must be allocated to cost centers for internal P&L tracking and monthly financial close. Real business process: management accounting requires trade-level cost center assignment for vari',
  `counterparty_id` BIGINT COMMENT 'FK to trading.counterparty.counterparty_id — Every trade has a counterparty. This FK is essential for credit exposure calculation, ISDA netting, and FERC EQR reporting. Without it, credit risk management is impossible.',
  `employee_id` BIGINT COMMENT 'Unique identifier of the employee or trading desk that executed the trade. Used for performance tracking and compliance monitoring.',
  `energy_price_id` BIGINT COMMENT 'Foreign key linking to forecast.energy_price. Business justification: Trades are priced and valued using forward LMP forecasts at delivery points. Hedging decisions, mark-to-market valuation, and trade approval workflows require linking trades to the price forecast scen',
  `hedge_strategy_id` BIGINT COMMENT 'Foreign key linking to trading.hedge_strategy. Business justification: Trades executed as part of board-approved hedging programs should reference the governing hedge_strategy to enable hedge effectiveness testing, regulatory reporting, and hedge accounting designation t',
  `master_agreement_id` BIGINT COMMENT 'Reference to the governing master trading agreement (e.g., ISDA, EEI, NAESB) under which this trade is executed. Defines legal terms and credit provisions.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Trades must comply with specific regulatory obligations (FERC EQR reporting, NERC reliability standards, market manipulation rules). Compliance officers trace trades to governing obligations for audit',
  `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Trades must roll up to profit centers for segment reporting and executive dashboards. Real business process: quarterly earnings reporting aggregates trading P&L by profit center for investor disclosur',
  `registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: Physical energy trades reference specific generation or transmission assets for delivery scheduling, settlement validation, and asset utilization tracking. Critical for reconciling financial trades wi',
  `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: Individual trades are reported in FERC EQR quarterly filings and other regulatory submissions. Regulatory teams must trace filed transactions back to source trade records for audit defense, filing ame',
  `scheduling_coordinator_id` BIGINT COMMENT 'Identifier of the Scheduling Coordinator (SC) responsible for submitting schedules to the ISO/RTO for this trade. Required for ISO/RTO market transactions.',
  `to_counterparty_id` BIGINT COMMENT 'FK to trading.counterparty.counterparty_id — Every trade has a counterparty. This is a fundamental master-transaction relationship required for credit exposure calculation, settlement, and FERC EQR reporting.',
  `trade_broker_counterparty_id` BIGINT COMMENT 'Identifier of the intermediary broker who facilitated the trade, if applicable. Null for direct bilateral or exchange trades.',
  `trade_counterparty_id` BIGINT COMMENT 'Unique identifier of the external party with whom the trade was executed. Links to the counterparty master for credit exposure and settlement tracking.',
  `vendor_id` BIGINT COMMENT 'Foreign key linking to supply.vendor. Business justification: Physical commodity trades (coal, natural gas, uranium fuel) are procured from vendors. Links trading desk fuel purchases to vendor master for invoice reconciliation, payment processing, and vendor per',
  `ancillary_service_type` STRING COMMENT 'Type of ancillary service procured if the trade is for grid support services: regulation, spinning reserve, non-spinning reserve, voltage support, or black start. Null for energy-only trades. Reference-value candidates: regulation|spinning_reserve|non_spinning_reserve|voltage_support|black_start|frequency_response|reactive_power.',
  `collateral_posted` DECIMAL(18,2) COMMENT 'Amount of collateral posted by the counterparty to secure this trade under the master agreement credit provisions.',
  `commodity` STRING COMMENT 'The energy commodity being traded: electric power, natural gas, Renewable Energy Certificate (REC), capacity, ancillary services, or Financial Transmission Right (FTR). Valid values: power|gas|rec|capacity|ancillary_services|ftr.',
  `confirmation_method` STRING COMMENT 'The mechanism used to confirm the trade with the counterparty: International Swaps and Derivatives Association (ISDA) agreement, broker confirmation, electronic platform, manual process, or exchange clearing. Valid values: isda|broker|electronic|manual|exchange.',
  `confirmation_status` STRING COMMENT 'Status of the trade confirmation workflow: unconfirmed (awaiting counterparty acknowledgment), confirmed (both parties agree), disputed (discrepancy identified), or resolved (dispute settled). Valid values: unconfirmed|confirmed|disputed|resolved.',
  `confirmation_timestamp` TIMESTAMP COMMENT 'Date and time when the trade was confirmed by the counterparty. Null if trade remains unconfirmed.',
  `counterparty_acknowledgment_received` BOOLEAN COMMENT 'Boolean flag indicating whether formal acknowledgment of the trade has been received from the counterparty. True if received, False otherwise.',
  `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the trade record was first created in the ETRM system. Used for audit trail and data lineage.',
  `credit_exposure_amount` DECIMAL(18,2) COMMENT 'The current credit exposure to the counterparty resulting from this trade, calculated based on mark-to-market valuation and collateral posted. Used for credit risk management.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the trade price and settlement amounts. Valid values: USD|CAD|EUR|GBP|MXN.',
  `deal_number` STRING COMMENT 'External business identifier for the trade as recorded in the Energy Trading and Risk Management (ETRM) system. Used for cross-system reconciliation and counterparty communication.',
  `delivery_end_date` DATE COMMENT 'The final date on which physical delivery or financial settlement of the commodity is completed.',
  `delivery_point` STRING COMMENT 'Physical or financial location where the commodity is delivered. For power: Pricing Node (PNode) or hub. For gas: pipeline interconnect or city gate.',
  `delivery_start_date` DATE COMMENT 'The first date on which physical delivery or financial settlement of the commodity begins.',
  `discrepancy_details` STRING COMMENT 'Free-text description of any discrepancies identified during the confirmation process, such as quantity mismatches, price differences, or delivery point errors. Null if no discrepancies exist.',
  `execution_timestamp` TIMESTAMP COMMENT 'Precise date and time when the trade was executed in the trading system. Critical for Day-Ahead Market (DAM) and Real-Time Market (RTM) sequencing and audit trails.',
  `ferc_reporting_category` STRING COMMENT 'Classification of the trade for FERC Form 552 reporting purposes: short-term sales, long-term sales, purchases for resale, or other categories. Null if not subject to FERC reporting. Reference-value candidates: short_term_sales|long_term_sales|purchases_for_resale|transmission_services|ancillary_services|other.',
  `internal_notes` STRING COMMENT 'Free-text field for internal trading desk notes, strategy rationale, or special instructions related to the trade. Not shared with counterparties.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when the trade record was last updated. Tracks amendments, status changes, and data corrections.',
  `lmp_pricing_node` STRING COMMENT 'The specific Pricing Node (PNode) used for Locational Marginal Price (LMP) calculation in ISO/RTO markets. Determines the settlement price for power trades.',
  `market_type` STRING COMMENT 'Classification of the market in which the trade was executed: Day-Ahead Market (DAM), Real-Time Market (RTM), term contract, or spot market. Valid values: day_ahead|real_time|term|spot.',
  `modified_by_user` STRING COMMENT 'Identifier of the system user who last modified the trade record. Used for audit trail and accountability.',
  `price` DECIMAL(18,4) COMMENT 'Unit price of the commodity. For power: dollars per MWh. For gas: dollars per MMBtu. Represents the agreed-upon price at trade execution.',
  `quantity` DECIMAL(18,3) COMMENT 'Volume of the commodity traded. For power: Megawatt-hours (MWh). For gas: Million British Thermal Units (MMBtu). For RECs: certificate count.',
  `rec_tracking_system_code` STRING COMMENT 'Identifier from the regional REC tracking system (e.g., WREGIS, M-RETS, PJM-GATS) for REC trades. Null for non-REC trades.',
  `rec_vintage_year` INT COMMENT 'The year in which the renewable energy was generated for Renewable Energy Certificate (REC) trades. Used for Renewable Portfolio Standard (RPS) compliance tracking. Null for non-REC trades.',
  `regulatory_reporting_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this trade must be reported to regulatory authorities such as Federal Energy Regulatory Commission (FERC) or state Public Utility Commissions (PUCs). True if reporting required, False otherwise.',
  `settlement_method` STRING COMMENT 'Indicates how the trade will be settled: physical delivery of the commodity, financial settlement based on market price, or cash payment. Valid values: physical|financial|cash.',
  `total_value` DECIMAL(18,2) COMMENT 'Total monetary value of the trade calculated as quantity multiplied by price. Represents the gross settlement amount before adjustments.',
  `trade_date` DATE COMMENT 'The calendar date on which the trade was executed and agreed upon by both parties.',
  `trade_status` STRING COMMENT 'Current lifecycle state of the trade: pending confirmation, confirmed by counterparty, amended after execution, cancelled before settlement, settled and closed, or voided due to error. Valid values: pending|confirmed|amended|cancelled|settled|voided.',
  `trade_type` STRING COMMENT 'Indicates whether the utility is buying or selling the commodity in this transaction. Valid values: buy|sell.',
  `transaction_category` STRING COMMENT 'Classification of the trade execution method: bilateral contract, exchange-traded, over-the-counter (OTC), Independent System Operator (ISO) or Regional Transmission Organization (RTO) market, or Power Purchase Agreement (PPA). Valid values: bilateral|exchange|otc|iso_rto|ppa.',
  `unit_of_measure` STRING COMMENT 'The unit in which the trade quantity is expressed: Megawatt-hour (MWh), Million British Thermal Units (MMBtu), Megawatt (MW), certificates, or rights. Valid values: MWh|MMBtu|MW|certificates|rights.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_trade` PRIMARY KEY (`trade_id`)
)
USING DELTA
COMMENT 'Core master record for every wholesale energy trade executed by the utility, capturing bilateral, exchange-traded, and OTC transactions for power, gas, and RECs. Sourced from OpenLink Endur position management. Stores trade type (buy/sell), commodity, quantity in MWh/MMBtu, price, currency, trade date, execution timestamp, trader ID, book, counterparty, and trade status lifecycle (confirmed, amended, cancelled). Includes confirmation workflow tracking: confirmation method (ISDA, broker, electronic), confirmation status, discrepancy details, and counterparty acknowledgment. SSOT for all trade identity and confirmation state within the trading domain. | CMM: CIM Trade (close), IEC62325::ParticipantInterfaces.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'Trade',
  'cmm.cim.class' = 'Trade',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC62325::ParticipantInterfaces',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.trade'
);

-- TradeLeg  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `trading`.`trade_leg` (
  `trade_leg_id` BIGINT NOT NULL COMMENT 'Unique identifier for the individual trade leg within a multi-leg wholesale energy transaction. Primary key.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Complex structured trades require leg-level cost center allocation for accurate margin analysis. Real business process: monthly financial close allocates multi-leg transaction costs to different cost',
  `counterparty_id` BIGINT COMMENT 'Reference to the counterparty entity on the opposite side of this leg. Critical for credit exposure monitoring and settlement.',
  `primary_trade_id` BIGINT COMMENT 'Reference to the parent wholesale energy trade transaction that this leg belongs to. A single trade may contain multiple legs representing different delivery periods, pricing structures, or settlement mechanisms.',
  `scheduling_coordinator_id` BIGINT COMMENT 'The identifier of the scheduling coordinator responsible for submitting energy schedules to the ISO/RTO for this leg. Required for physical delivery legs.',
  `to_trade_id` BIGINT COMMENT 'FK to trading.trade.trade_id — Every trade leg must reference its parent trade. This is the fundamental header→line relationship in the trading domain. Without this FK, trade legs are orphaned and cannot be aggregated to the trade',
  `ancillary_services_included` BOOLEAN COMMENT 'Indicates whether this leg includes procurement of ancillary services such as regulation, spinning reserves, or voltage support required for grid reliability.',
  `approval_timestamp` TIMESTAMP COMMENT 'The date and time when this trade leg was approved for execution by authorized personnel.',
  `approved_by_user` STRING COMMENT 'The username or identifier of the supervisor or risk manager who approved this trade leg for execution.',
  `booking_entity` STRING COMMENT 'The legal entity or business unit within the utility that booked this trade leg. Used for regulatory reporting and internal profit/loss attribution.',
  `collateral_requirement_amount` DECIMAL(18,2) COMMENT 'The amount of collateral required to be posted by the counterparty to secure performance on this leg, based on credit exposure and credit terms.',
  `congestion_revenue_rights_quantity` DECIMAL(18,3) COMMENT 'The quantity of Congestion Revenue Rights or Financial Transmission Rights associated with this leg, used to hedge transmission congestion costs.',
  `created_by_user` STRING COMMENT 'The username or identifier of the trader or system user who created this trade leg record.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this trade leg record was first created in the Energy Trading and Risk Management (ETRM) system.',
  `credit_exposure_amount` DECIMAL(18,2) COMMENT 'The calculated credit exposure or mark-to-market value of this leg, used for counterparty credit risk management and collateral determination.',
  `delivery_end_date` DATE COMMENT 'The final date on which physical delivery or financial settlement obligations conclude for this leg. Used to determine the leg\'s active period.',
  `delivery_point_hub` STRING COMMENT 'The trading hub or aggregated pricing zone for delivery. Hubs represent weighted averages of multiple PNodes and are commonly used in bilateral contracts.',
  `delivery_point_pnode` STRING COMMENT 'The specific pricing node or delivery location where physical energy is delivered or financially settled. PNodes are defined by the ISO/RTO and determine locational pricing.',
  `delivery_start_date` DATE COMMENT 'The first date on which physical delivery or financial settlement obligations begin for this leg. Critical for scheduling and settlement calculations.',
  `fixed_price` DECIMAL(18,6) COMMENT 'The predetermined price per unit for fixed-price legs. Null for floating-price legs where price is determined by market index or formula.',
  `heat_rate` DECIMAL(10,4) COMMENT 'For tolling agreements or gas-fired generation legs, the heat rate (MMBtu per MWh) used to convert fuel costs to energy pricing. Represents generation efficiency.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this trade leg record was last updated or modified in the ETRM system.',
  `leg_direction` STRING COMMENT 'Indicates whether this leg represents a buy, sell, receive, or pay position from the utility\'s perspective. Critical for position management and risk exposure calculation. Valid values: buy|sell|receive|pay.',
  `leg_sequence_number` INT COMMENT 'Sequential ordering of this leg within the parent trade. Used to maintain the chronological or logical order of legs in complex structured products.',
  `leg_status` STRING COMMENT 'Current lifecycle status of the trade leg indicating whether it is active, pending approval, executed, settled, cancelled, or expired. Valid values: active|pending|executed|settled|cancelled|expired.',
  `leg_type` STRING COMMENT 'Classification of the trade leg indicating whether it represents a fixed-price obligation, floating-price exposure, physical energy delivery, financial cash settlement, option right, or swap exchange. Valid values: fixed|floating|physical_delivery|financial_settlement|option|swap.',
  `market_type` STRING COMMENT 'Identifies the market in which this leg was transacted: day-ahead market (DAM), real-time market (RTM), bilateral contract, forward market, or futures exchange. Valid values: day_ahead|real_time|bilateral|forward|futures.',
  `notional_quantity` DECIMAL(18,3) COMMENT 'The contracted volume or capacity for this leg, typically expressed in megawatt-hours (MWh) for energy transactions or megawatts (MW) for capacity products.',
  `option_exercise_style` STRING COMMENT 'Defines when the option can be exercised: American (any time before expiry), European (only at expiry), or Bermudan (specific dates). Null for non-option legs. Valid values: american|european|bermudan|none.',
  `option_type` STRING COMMENT 'For option legs, specifies whether this is a call option (right to buy), put option (right to sell), swaption (option on a swap), or collar (combination). Null for non-option legs. Valid values: call|put|swaption|collar|none.',
  `premium_amount` DECIMAL(18,2) COMMENT 'The upfront payment made for option legs. Represents the cost of acquiring the option right. Null for non-option legs.',
  `price_formula` STRING COMMENT 'Mathematical formula or index reference used to calculate floating prices. May reference LMP (Locational Marginal Price) nodes, market indices, or custom calculation logic for structured products.',
  `price_index_reference` STRING COMMENT 'External market price index or benchmark used for floating-price legs. Examples include ISO day-ahead LMP, real-time LMP, or published hub indices.',
  `price_unit_of_measure` STRING COMMENT 'The unit of measure for pricing, indicating the currency and quantity basis. Typically USD per MWh for energy or USD per MW for capacity products. Valid values: USD_per_MWh|USD_per_MW|USD_per_kW_month|USD_per_MMBtu.',
  `product_type` STRING COMMENT 'The type of wholesale product being traded in this leg: energy (MWh), capacity (MW), ancillary services, transmission rights, RECs, or financial instruments. Reference-value candidates: energy|capacity|ancillary_services|transmission|REC|CRR|FTR.',
  `quantity_unit_of_measure` STRING COMMENT 'The unit of measure for the notional quantity. Common values include MWh (megawatt-hour) for energy, MW (megawatt) for capacity, and MMBtu for gas-fired generation fuel. Valid values: MWh|MW|GWh|kWh|MMBtu|Dth.',
  `rec_vintage_year` INT COMMENT 'The year in which the renewable energy was generated, determining the vintage of associated RECs. Some RPS programs require specific vintage years.',
  `renewable_energy_certificate_quantity` DECIMAL(18,3) COMMENT 'The number of Renewable Energy Certificates associated with this leg. RECs represent the environmental attributes of renewable generation and may be bundled or unbundled from energy.',
  `settlement_currency` STRING COMMENT 'The currency in which financial settlement for this leg will be executed. Typically USD for North American wholesale energy markets. Valid values: USD|CAD|EUR|GBP|MXN.',
  `settlement_date` DATE COMMENT 'The date on which financial settlement for this leg is completed and payment is exchanged between counterparties.',
  `settlement_method` STRING COMMENT 'Indicates whether the leg settles through physical delivery of energy, financial cash settlement, or netting against other positions. Valid values: physical|financial|cash|netting.',
  `strike_price` DECIMAL(18,6) COMMENT 'The predetermined price at which an option can be exercised. Applicable only to option legs; null for other leg types.',
  `time_of_use_profile` STRING COMMENT 'Defines the hours during which this leg is active. Common profiles include on-peak (weekday business hours), off-peak (nights and weekends), and flat (all hours). Reference-value candidates: on_peak|off_peak|super_peak|flat|7x24|5x16|2x16H.',
  `tolling_agreement_flag` BOOLEAN COMMENT 'Indicates whether this leg is part of a tolling agreement where one party provides fuel and the other provides generation capacity and conversion services.',
  `transmission_rights_included` BOOLEAN COMMENT 'Indicates whether this leg includes associated transmission capacity rights or Financial Transmission Rights (FTRs) for moving energy across the grid.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_trade_leg` PRIMARY KEY (`trade_leg_id`)
)
USING DELTA
COMMENT 'Individual delivery leg or payment leg of a multi-leg wholesale energy trade. Captures leg type (fixed, floating, physical delivery, financial settlement), notional quantity, price formula, start and end delivery dates, delivery point (PNode/hub), and settlement currency. Supports complex structured products such as swaps, options, and tolling agreements managed in OpenLink Endur. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'TradeLeg',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.trade_leg'
);

-- TradingPosition  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `trading`.`trading_position` (
  `trading_position_id` BIGINT NOT NULL COMMENT 'Unique identifier for the energy trading position record. Primary key for the position entity.',
  `book_id` BIGINT COMMENT 'Reference to the trading book under which this position is held. Trading books organize positions by business unit, strategy, or portfolio.',
  `contract_id` BIGINT COMMENT 'Reference to the underlying Power Purchase Agreement (PPA), bilateral contract, or master trading agreement governing this position. Nullable for ISO/RTO centrally cleared positions.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Trading positions are assigned to cost centers for risk capital allocation and performance attribution. Real business process: monthly risk reporting aggregates VaR and mark-to-market P&L by cost cent',
  `counterparty_id` BIGINT COMMENT 'Reference to the counterparty entity for bilateral positions or the ISO/RTO for centrally cleared positions. Used for credit exposure tracking and settlement.',
  `delivery_point_id` BIGINT COMMENT 'Reference to the physical or financial delivery point (PNode, hub, zone, or interconnection point) where the commodity is delivered or settled.',
  `dr_program_id` BIGINT COMMENT 'Foreign key linking to demand.dr_program. Business justification: Trading positions track exposure to DR capacity commitments. Real business process: mark-to-market valuation of DR capacity positions for risk management and regulatory capital adequacy reporting (FER',
  `employee_id` BIGINT COMMENT 'Reference to the trader or scheduling coordinator responsible for managing this position. Used for attribution and accountability.',
  `energy_price_id` BIGINT COMMENT 'Foreign key linking to forecast.energy_price. Business justification: Position mark-to-market valuation and VaR calculations depend on forward price curves. Risk managers link positions to specific price forecast scenarios to calculate unrealized P&L and exposure metric',
  `lmp_price_id` BIGINT COMMENT 'Foreign key linking to trading.lmp_price. Business justification: Trading positions are marked-to-market using official LMP prices for the delivery point and snapshot timestamp. Linking position to the authoritative lmp_price record ensures valuation consistency and',
  `portfolio_id` BIGINT COMMENT 'Reference to the trading portfolio or strategy grouping to which this position belongs. Used for portfolio-level risk aggregation and performance reporting.',
  `price_curve_id` BIGINT COMMENT 'Reference to the forward price curve or index used for position valuation. Links to market data and pricing models.',
  `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Positions must roll up to profit centers for segment P&L and regulatory capital reporting. Real business process: quarterly segment reporting requires position-level profit center assignment for GAAP',
  `trade_id` BIGINT COMMENT 'Reference to the originating deal or transaction in the ETRM system that created this position. Links position to trade capture and deal management.',
  `ancillary_service_type` STRING COMMENT 'Type of ancillary service if this position represents capacity or ancillary services procurement (e.g., regulation up, regulation down, spinning reserve, non-spinning reserve, voltage support). Nullable for energy-only positions.',
  `business_date` DATE COMMENT 'Business date for which this position snapshot is reported. Used for end-of-day position reconciliation and historical trend analysis.',
  `commodity_type` STRING COMMENT 'Type of energy commodity being traded. Defines the product category for the position. Reference-value candidates: power|natural_gas|coal|renewable_energy_certificate|emissions_allowance|capacity|ancillary_services.',
  `congestion_revenue_right_flag` BOOLEAN COMMENT 'Indicates whether this position includes Congestion Revenue Rights (CRRs) or Financial Transmission Rights (FTRs) used to hedge congestion costs.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this position record was first created in the system. Used for audit trail and data lineage.',
  `credit_exposure_amount` DECIMAL(18,2) COMMENT 'Current credit exposure to the counterparty for this position. Represents the potential loss if the counterparty defaults. Used for credit risk management and collateral calculations.',
  `delivery_end_date` DATE COMMENT 'End date of the delivery period for the energy commodity. Defines when physical or financial settlement concludes.',
  `delivery_start_date` DATE COMMENT 'Start date of the delivery period for the energy commodity. Defines when physical or financial settlement begins.',
  `hedge_designation` STRING COMMENT 'Accounting hedge designation for the position under GAAP or IFRS hedge accounting rules. Determines financial reporting treatment. Valid values: cash_flow_hedge|fair_value_hedge|net_investment_hedge|not_designated.',
  `iso_rto_code` STRING COMMENT 'Code identifying the ISO or RTO market jurisdiction where the position is held. Used for market-specific settlement and reporting. Reference-value candidates: CAISO|ERCOT|PJM|MISO|NYISO|ISO_NE|SPP.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this position record was last modified. Used for change tracking and audit trail.',
  `mark_to_market_value` DECIMAL(18,2) COMMENT 'Current market value of the position based on prevailing market prices (LMP, forward curves, or settlement prices). Represents the fair value of the position at the snapshot timestamp.',
  `market_type` STRING COMMENT 'Type of energy market in which the position is held. Distinguishes between Day-Ahead Market (DAM), Real-Time Market (RTM), forward markets, bilateral contracts, and ancillary services markets. Valid values: day_ahead|real_time|forward|bilateral|ancillary_services.',
  `net_position_quantity` DECIMAL(18,3) COMMENT 'Net long or short position quantity for the delivery period. Positive values indicate long positions, negative values indicate short positions. Measured in MWh for power or MMBtu for gas.',
  `pnode_code` STRING COMMENT 'ISO or RTO pricing node identifier used for Locational Marginal Price (LMP) settlement and valuation. Applicable for power positions.',
  `position_status` STRING COMMENT 'Current lifecycle status of the position. Indicates whether the position is actively held, closed, or in settlement process. Valid values: open|closed|settled|pending_settlement|cancelled.',
  `rec_quantity` DECIMAL(18,3) COMMENT 'Quantity of Renewable Energy Certificates (RECs) associated with this position, measured in MWh or certificate units. Nullable if rec_tracking_flag is false.',
  `rec_tracking_flag` BOOLEAN COMMENT 'Indicates whether this position includes Renewable Energy Certificates (RECs) that must be tracked separately for Renewable Portfolio Standard (RPS) compliance.',
  `settlement_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for financial settlement of the position. Typically USD for North American energy markets. Valid values: USD|CAD|EUR|GBP|MXN.',
  `snapshot_timestamp` TIMESTAMP COMMENT 'Timestamp when the position snapshot was captured. Used for intraday position monitoring and end-of-day valuation time-series analysis.',
  `unit_of_measure` STRING COMMENT 'Unit of measure for the net position quantity. Typically MWh (Megawatt-Hour) for power, MMBtu (Million British Thermal Units) for gas, or other commodity-specific units. Reference-value candidates: MWh|MMBtu|MW|GWh|metric_ton|allowance|certificate.',
  `unrealized_pnl` DECIMAL(18,2) COMMENT 'Unrealized profit or loss on the position calculated as the difference between current mark-to-market value and original book value. Positive values indicate gains, negative values indicate losses.',
  `valuation_method` STRING COMMENT 'Method used to calculate the mark-to-market value of the position. Defines the pricing source and calculation approach. Valid values: lmp_spot|forward_curve|bilateral_price|cost_plus|index_based.',
  `value_at_risk` DECIMAL(18,2) COMMENT 'Statistical measure of potential loss exposure for the position over a defined time horizon and confidence interval. Used for risk management and regulatory capital calculations.',
  `var_confidence_level` DECIMAL(5,2) COMMENT 'Confidence level percentage used for VaR calculation (e.g., 95.00 or 99.00). Indicates the probability that losses will not exceed the VaR amount.',
  `var_time_horizon_days` INT COMMENT 'Time horizon in days over which the VaR exposure is calculated (e.g., 1 day, 10 days). Defines the holding period assumption for risk measurement.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_trading_position` PRIMARY KEY (`trading_position_id`)
)
USING DELTA
COMMENT 'Real-time and end-of-day energy trading position record aggregated by book, commodity, delivery period, and delivery point. Tracks net long/short position in MWh or MMBtu, mark-to-market (MtM) value, unrealized P&L, and value-at-risk (VaR) exposure. Captures position valuation snapshots at configurable intervals for trend analysis and intraday risk monitoring. Includes LMP reference data: Locational Marginal Price records by PNode and market interval with energy component, congestion component, and loss component ($/MWh), market type (DAM/RTM/FMM), and ISO source — used for position valuation, settlement price verification, congestion analysis, and hedging strategy support. Sourced from OpenLink Endur position management module and ISO market data feeds. Supports intraday risk monitoring, end-of-day P&L reporting, MtM valuation time-series, and FERC market reporting. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'TradingPosition',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.trading_position'
);

-- TradingPpa  <<CIM Agreement : extension>>
CREATE TABLE IF NOT EXISTS `trading`.`ppa` (
  `ppa_id` BIGINT NOT NULL COMMENT 'Unique identifier for the power purchase agreement record. Primary key for the PPA entity.',
  `counterparty_id` BIGINT COMMENT 'FK to trading.counterparty.counterparty_id — Every PPA is executed with a counterparty (generator, developer, marketer). Essential for contract management, credit exposure, and FERC reporting.',
  `delivery_point_id` BIGINT COMMENT 'Identifier of the physical or virtual delivery point (substation, interconnection point, or pricing node) where energy is transferred under this PPA.',
  `generating_unit_id` BIGINT COMMENT 'Foreign key linking to generation.generating_unit. Business justification: PPAs specify which generation unit(s) deliver the contracted energy. Critical for PPA delivery obligation tracking, compliance reporting, and settlement reconciliation.',
  `generation_asset_registry_id` BIGINT COMMENT 'Foreign key linking to asset.asset_registry. Business justification: PPAs are contracts tied to specific generation facilities. Essential for PPA performance monitoring, capacity verification, contract compliance auditing, and renewable energy credit tracking. Role pre',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: PPAs are governed by regulatory obligations including PURPA compliance, state RPS requirements, and FERC filing mandates. Regulatory affairs teams must demonstrate PPA compliance with renewable energy',
  `ppa_counterparty_id` BIGINT COMMENT 'Identifier of the counterparty entity (generator, IPP, or buyer) with whom the utility has entered into this PPA.',
  `ppa_created_by_user_employee_id` BIGINT COMMENT 'User ID of the system user who created this PPA record.',
  `ppa_employee_id` BIGINT COMMENT 'Identifier of the internal employee or team responsible for managing and administering this PPA contract.',
  `ppa_updated_by_user_employee_id` BIGINT COMMENT 'User ID of the system user who last modified this PPA record.',
  `scheduling_coordinator_id` BIGINT COMMENT 'Identifier of the scheduling coordinator entity responsible for submitting energy schedules and bids to the ISO/RTO on behalf of this PPA. Null for non-ISO/RTO contracts.',
  `to_counterparty_id` BIGINT COMMENT 'FK to trading.counterparty.counterparty_id — Every PPA has a counterparty. Required for credit exposure aggregation and contract management.',
  `vendor_id` BIGINT COMMENT 'Foreign key linking to supply.vendor. Business justification: PPA counterparties (renewable generation facility owners) are vendors for accounts payable purposes. Links renewable energy contracts to vendor master for payment processing, tax reporting (1099), and',
  `annual_energy_volume_mwh` DECIMAL(15,3) COMMENT 'Expected or contracted annual energy volume in megawatt-hours (MWh) to be delivered under this PPA. Used for performance tracking and settlement forecasting.',
  `capacity_factor_pct` DECIMAL(5,2) COMMENT 'Expected or historical capacity factor (ratio of actual output to maximum possible output) of the generation asset, expressed as a percentage. Used for performance benchmarking.',
  `collateral_posted_usd` DECIMAL(15,2) COMMENT 'Total collateral amount in USD posted by the counterparty to secure performance under this PPA, as of the most recent valuation date.',
  `contract_amendment_count` INT COMMENT 'Total number of amendments or modifications made to the original PPA contract since execution. Used for contract version tracking.',
  `contract_name` STRING COMMENT 'Human-readable name or title of the PPA contract, typically including counterparty and generation source (e.g., \'ABC Wind Farm PPA 2024\').',
  `contract_number` STRING COMMENT 'Externally-known unique business identifier for the PPA contract, used in all regulatory filings, invoices, and counterparty communications. Pattern: ^PPA-[A-Z0-9]{8,12}$.',
  `contract_status` STRING COMMENT 'Current lifecycle status of the PPA contract. Active indicates deliveries are occurring; executed means signed but not yet delivering; terminated or expired indicates contract has ended. Reference-value candidates: draft|executed|active|suspended|terminated|expired|amended.',
  `contract_term_years` INT COMMENT 'Duration of the PPA contract in years, calculated from effective start to end date. Typical renewable PPAs range from 10 to 25 years.',
  `contract_type` STRING COMMENT 'Classification of the PPA by structure: renewable (wind/solar/hydro), conventional (gas/coal), tolling (fuel supplied by buyer), capacity (MW commitment), energy_only (MWh only), or bundled (energy + capacity + ancillary services). Valid values: renewable|conventional|tolling|capacity|energy_only|bundled.',
  `contracted_capacity_mw` DECIMAL(12,3) COMMENT 'Maximum generation capacity in megawatts (MW) that the counterparty is obligated to make available under this PPA.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this PPA record was first created in the ETRM system.',
  `credit_rating_requirement` STRING COMMENT 'Minimum credit rating required of the counterparty under the PPA contract (e.g., \'BBB-\', \'Investment Grade\'). Used for credit risk management and collateral determination.',
  `curtailment_allowed_flag` BOOLEAN COMMENT 'Indicates whether the utility has the contractual right to curtail (reduce or halt) energy deliveries under specified conditions (e.g., grid congestion, negative pricing).',
  `curtailment_compensation_rate` DECIMAL(12,4) COMMENT 'Compensation rate in USD per MWh paid to the counterparty for curtailed energy, if applicable. Null if no compensation is provided for curtailment.',
  `effective_end_date` DATE COMMENT 'Date on which the PPA contract terms expire and energy deliveries are scheduled to cease. Nullable for contracts with indefinite terms or renewal options.',
  `effective_start_date` DATE COMMENT 'Date on which the PPA contract terms become effective and energy deliveries are scheduled to commence.',
  `execution_date` DATE COMMENT 'Date on which the PPA contract was signed and became legally binding between the parties.',
  `ferc_filing_reference` STRING COMMENT 'FERC docket number or filing reference associated with this PPA, if the contract required regulatory approval or was filed under FERC jurisdiction.',
  `fixed_price_per_mwh` DECIMAL(12,4) COMMENT 'Fixed contract price in USD per megawatt-hour for energy deliveries, applicable when pricing_structure is \'fixed\'. Null for indexed or LMP-based contracts.',
  `force_majeure_clause_flag` BOOLEAN COMMENT 'Indicates whether the PPA contract includes a force majeure clause that excuses non-performance due to extraordinary events beyond the parties\' control (e.g., natural disasters, grid emergencies).',
  `generation_source` STRING COMMENT 'Primary energy source or technology type of the generation asset covered by this PPA. Reference-value candidates: wind|solar|hydro|natural_gas|coal|nuclear|biomass|geothermal|battery_storage.',
  `iso_rto_market` STRING COMMENT 'Name of the ISO or RTO market in which this PPA operates (e.g., \'PJM\', \'CAISO\', \'ERCOT\', \'MISO\', \'SPP\'). Null for bilateral contracts outside organized markets.',
  `last_amendment_date` DATE COMMENT 'Date of the most recent amendment or modification to the PPA contract. Null if no amendments have been made.',
  `minimum_take_obligation_mwh` DECIMAL(15,3) COMMENT 'Minimum annual energy volume in MWh that the utility is contractually obligated to purchase, regardless of actual need. Null if no minimum take obligation exists.',
  `price_escalation_rate_pct` DECIMAL(5,2) COMMENT 'Annual percentage rate at which the contract price escalates over the term of the PPA. Null if no escalation clause exists.',
  `price_index_reference` STRING COMMENT 'Name of the commodity price index or market reference used for indexed pricing (e.g., \'Henry Hub Natural Gas\', \'PJM West Hub Day-Ahead LMP\'). Applicable when pricing_structure is \'indexed\' or \'lmp_based\'.',
  `pricing_structure` STRING COMMENT 'Mechanism by which energy prices are determined under this PPA: fixed (flat rate per MWh), indexed (tied to commodity index), LMP-based (locational marginal pricing), heat_rate (fuel cost pass-through), or hybrid (combination). Valid values: fixed|indexed|lmp_based|heat_rate|hybrid.',
  `rec_bundled_flag` BOOLEAN COMMENT 'Indicates whether Renewable Energy Certificates (RECs) are bundled with energy deliveries (true) or unbundled and sold separately (false). Applicable only to renewable PPAs.',
  `rec_tracking_system` STRING COMMENT 'Name of the REC tracking system or registry used to certify and transfer RECs associated with this PPA (e.g., \'WREGIS\', \'M-RETS\', \'PJM-GATS\'). Null if RECs are not bundled.',
  `renewal_option_flag` BOOLEAN COMMENT 'Indicates whether the PPA contract includes an option for either party to renew the agreement upon expiration.',
  `settlement_frequency` STRING COMMENT 'Frequency at which energy deliveries are settled and invoiced under this PPA (e.g., monthly for most bilateral contracts, hourly for ISO/RTO market-based PPAs). Valid values: hourly|daily|monthly|quarterly|annual.',
  `termination_notice_days` INT COMMENT 'Number of days advance notice required by either party to terminate the PPA contract, as specified in the termination clause.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this PPA record was last modified in the ETRM system.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_ppa` PRIMARY KEY (`ppa_id`)
)
USING DELTA
COMMENT 'Power Purchase Agreement master record with integrated delivery tracking for long-term bilateral contracts for the purchase or sale of electricity from generation assets, including renewable PPAs (wind, solar, hydro) and conventional source agreements. Captures contract identity: counterparty, contracted capacity (MW), energy volume (MWh), contract term, delivery point, pricing structure (fixed, indexed, LMP-based), REC bundling flag, and FERC filing reference. Tracks delivery performance at interval granularity: scheduled MWh, actual delivered MWh, curtailment volume, delivery point, interval start/end timestamps, and settlement status for each delivery period. Supports PPA performance tracking, curtailment reconciliation, invoice generation against contracted volumes, and FERC reporting. SSOT for PPA contract identity and all delivery records within the trading domain. | CMM: CIM Agreement (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'TradingPpa',
  'cmm.cim.class' = 'Agreement',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.ppa'
);

-- PpaDelivery  <<CIM EnergyTransaction : broad>>
CREATE TABLE IF NOT EXISTS `trading`.`ppa_delivery` (
  `ppa_delivery_id` BIGINT NOT NULL COMMENT 'Unique identifier for the PPA delivery record. Primary key for the ppa_delivery product.',
  `delivery_point_id` BIGINT COMMENT 'Reference to the physical or virtual delivery point (PNode, pricing node, or interconnection point) where energy was delivered under the PPA. Critical for settlement and locational marginal pricing (LMP) reconciliation.',
  `der_system_id` BIGINT COMMENT 'Reference to the generation asset or facility that produced the energy delivered under this PPA interval. Links to the renewable or conventional generation resource master data.',
  `distribution_substation_id` BIGINT COMMENT 'Foreign key linking to distribution.distribution_substation. Business justification: Larger PPA facilities deliver at substation level. Substation delivery tracking is required for transmission-distribution coordination, substation capacity planning, contract settlement, and system im',
  `event_id` BIGINT COMMENT 'Foreign key linking to outage.outage_event. Business justification: PPA delivery shortfalls caused by generation facility outages or transmission outages must be tracked for force majeure claims, curtailment compensation calculations, and contract performance analysis',
  `feeder_id` BIGINT COMMENT 'Foreign key linking to distribution.feeder. Business justification: PPA deliveries from distributed generation specify feeder-level delivery points. Tracking feeder delivery is essential for contract settlement, curtailment management, hosting capacity monitoring, and',
  `forecast_renewable_id` BIGINT COMMENT 'Foreign key linking to forecast.forecast_renewable. Business justification: Actual PPA deliveries are compared against renewable generation forecasts for deviation analysis and settlement dispute resolution. Settlement analysts link delivery records to the forecasts used for',
  `output_telemetry_id` BIGINT COMMENT 'Foreign key linking to generation.output_telemetry. Business justification: PPA delivery records are reconciled against actual generation telemetry for settlement accuracy. Core PPA settlement process linking contracted delivery to metered generation.',
  `ppa_contract_id` BIGINT COMMENT 'Reference to the parent PPA contract under which this delivery occurred. Links to the master PPA agreement defining commercial terms, pricing, and delivery obligations.',
  `ppa_id` BIGINT COMMENT 'FK to trading.ppa.ppa_id — PPA delivery records are the line-level detail of a PPA contract. Without this FK, delivery tracking and curtailment reconciliation against contracted volumes is impossible.',
  `scheduling_coordinator_id` BIGINT COMMENT 'Reference to the scheduling coordinator entity responsible for submitting energy schedules and bids to the ISO/RTO on behalf of the PPA counterparty. Required for CAISO and other ISO/RTO markets.',
  `vendor_id` BIGINT COMMENT 'Foreign key linking to supply.vendor. Business justification: Each PPA delivery event generates a payable to the generation facility owner (vendor). Links delivery records to vendor master for three-way match (contract price, meter data, invoice) in accounts pay',
  `actual_delivered_mwh` DECIMAL(18,6) COMMENT 'The actual quantity of energy in megawatt-hours (MWh) that was physically delivered during this interval, as measured by the ISO/RTO or metering infrastructure. Used for settlement and invoice reconciliation.',
  `ancillary_services_charge` DECIMAL(18,2) COMMENT 'The total charge for ancillary services (regulation, spinning reserves, non-spinning reserves, voltage support) allocated to this delivery interval by the ISO/RTO.',
  `congestion_charge` DECIMAL(18,2) COMMENT 'The congestion component of the locational marginal price (LMP) charged or credited for this delivery interval. Reflects transmission constraints and nodal price differences.',
  `contract_price_per_mwh` DECIMAL(18,4) COMMENT 'The contracted price per megawatt-hour (MWh) applicable to this delivery interval under the PPA. May vary by time-of-use (TOU), season, or other contract terms. Used for invoice calculation.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this delivery record was first created in the energy trading and risk management (ETRM) system. Used for audit trail and data lineage tracking.',
  `currency_code` STRING COMMENT 'The ISO 4217 three-letter currency code for the settlement amount. Typically USD for North American energy markets. Valid values: USD|CAD|EUR|GBP|MXN.',
  `curtailment_instruction_timestamp` TIMESTAMP COMMENT 'The timestamp when the curtailment instruction was issued by the ISO/RTO or grid operator. Used for compliance verification and dispute resolution.',
  `curtailment_mwh` DECIMAL(18,6) COMMENT 'The quantity of energy in megawatt-hours (MWh) that was curtailed (not delivered) during this interval due to grid constraints, economic dispatch, or ISO/RTO instructions. Calculated as scheduled minus actual delivered.',
  `curtailment_reason_code` STRING COMMENT 'The reason code explaining why energy was curtailed during this interval. Used for PPA performance analysis, force majeure claims, and curtailment credit reconciliation. Valid values: grid_congestion|economic_dispatch|forced_outage|maintenance|iso_instruction|environmental_limit.',
  `data_quality_flag` STRING COMMENT 'Indicates the quality and reliability of the delivery data for this interval. Estimated or missing data may require subsequent true-up settlement runs. Valid values: valid|estimated|missing|suspect|verified.',
  `delivery_interval_end` TIMESTAMP COMMENT 'The timestamp marking the end of the delivery interval for which energy was scheduled and delivered under the PPA. Defines the close of the measurement period.',
  `delivery_interval_start` TIMESTAMP COMMENT 'The timestamp marking the beginning of the delivery interval for which energy was scheduled and delivered under the PPA. Typically aligned with ISO/RTO market intervals (5-minute, 15-minute, or hourly).',
  `deviation_mwh` DECIMAL(18,6) COMMENT 'The net deviation in megawatt-hours (MWh) between scheduled and actual delivered energy. Positive values indicate over-delivery; negative values indicate under-delivery. Used for imbalance settlement.',
  `dispute_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this delivery interval is under dispute between the PPA counterparties. Triggers dispute resolution workflow and may delay final settlement.',
  `dispute_reason` STRING COMMENT 'Free-text description of the reason for dispute on this delivery interval. May reference metering discrepancies, pricing disagreements, or curtailment credit disputes.',
  `energy_charge` DECIMAL(18,2) COMMENT 'The energy component of the locational marginal price (LMP) charged or credited for this delivery interval. Represents the marginal cost of generation.',
  `force_majeure_flag` BOOLEAN COMMENT 'Boolean flag indicating whether a force majeure event (natural disaster, grid emergency, regulatory order) affected delivery during this interval. Used for contractual excuse and penalty waiver determination.',
  `invoice_date` DATE COMMENT 'The date on which the invoice containing this delivery interval was issued. Used for payment terms calculation and accounts payable tracking.',
  `invoice_number` STRING COMMENT 'The invoice number under which this delivery interval was billed to the purchasing utility. Links delivery records to accounts payable and revenue management systems.',
  `iso_rto_code` STRING COMMENT 'The code identifying the ISO or RTO market in which this delivery occurred. Critical for market-specific settlement rules and regulatory reporting. Reference-value candidates: CAISO|ERCOT|PJM|MISO|NYISO|ISO_NE|SPP.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this delivery record was last modified in the ETRM system. Tracks settlement run updates, dispute resolution, and data quality corrections.',
  `lmp_price_per_mwh` DECIMAL(18,4) COMMENT 'The locational marginal price (LMP) in USD per megawatt-hour (MWh) at the delivery point for this interval, as published by the ISO/RTO. Used for market settlement and PPA performance benchmarking.',
  `loss_charge` DECIMAL(18,2) COMMENT 'The marginal loss component of the locational marginal price (LMP) charged or credited for this delivery interval. Reflects transmission line losses between generation and load.',
  `market_type` STRING COMMENT 'The type of energy market in which this delivery occurred. Day-ahead market (DAM) schedules are submitted one day prior; real-time market (RTM) reflects actual dispatch; bilateral contracts are direct counterparty agreements. Valid values: day_ahead|real_time|bilateral|ancillary_services.',
  `meter_reading_source` STRING COMMENT 'The source system or method used to obtain the actual delivered MWh measurement. SCADA provides real-time telemetry; revenue meters provide billing-quality data; ISO settlement data is the final authoritative source. Valid values: scada|revenue_meter|iso_settlement|estimated.',
  `payment_due_date` DATE COMMENT 'The date by which payment for this delivery interval is due per the PPA payment terms. Used for cash flow forecasting and accounts receivable management.',
  `rec_quantity` DECIMAL(18,6) COMMENT 'The quantity of renewable energy certificates (RECs) generated by this delivery interval, typically one REC per MWh of renewable energy delivered. Used for RPS compliance and environmental attribute tracking.',
  `rec_serial_number` STRING COMMENT 'The unique serial number or identifier assigned to the renewable energy certificate(s) associated with this delivery interval, as registered in a REC tracking system (e.g., WREGIS, M-RETS, PJM-GATS).',
  `scheduled_mwh` DECIMAL(18,6) COMMENT 'The quantity of energy in megawatt-hours (MWh) that was scheduled for delivery during this interval under the PPA contract. Represents the day-ahead or real-time schedule submitted to the ISO/RTO.',
  `settlement_amount` DECIMAL(18,2) COMMENT 'The total settlement amount in USD for this delivery interval, calculated as actual delivered MWh multiplied by the contract price, adjusted for any curtailment credits or penalties per the PPA terms.',
  `settlement_run_type` STRING COMMENT 'The type of settlement run that produced this delivery record. ISO/RTO markets typically perform multiple settlement runs (initial, recalculation, final) as metering and pricing data are refined. Valid values: initial|recalculation_1|recalculation_2|final|true_up.',
  `settlement_status` STRING COMMENT 'The current status of the settlement process for this delivery interval. Tracks progression from preliminary ISO/RTO settlement through final invoice and payment. Valid values: pending|preliminary|final|invoiced|paid|disputed.',
  `source_system` STRING COMMENT 'The name of the source system that provided this delivery record. Typically OpenLink Endur for ETRM position management, ISO settlement files, or meter data management (MDM) systems. Valid values: openlink_endur|iso_settlement|scada|mdm|manual_entry.',
  `source_system_record_code` STRING COMMENT 'The unique identifier of this delivery record in the source system. Used for data reconciliation and traceability back to the operational system of record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_ppa_delivery` PRIMARY KEY (`ppa_delivery_id`)
)
USING DELTA
COMMENT 'Scheduled and actual energy delivery records under a PPA contract for a given delivery interval. Captures scheduled MWh, actual delivered MWh, curtailment volume, delivery point, interval start/end timestamps, and settlement status. Supports PPA performance tracking, curtailment reconciliation, and invoice generation against contracted volumes. | CMM: CIM EnergyTransaction (broad), IEC62325::InfEnergyScheduling.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PpaDelivery',
  'cmm.cim.class' = 'EnergyTransaction',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC62325::InfEnergyScheduling',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.ppa_delivery'
);

-- MarketBid  <<CIM Bid : exact>>
CREATE TABLE IF NOT EXISTS `trading`.`market_bid` (
  `market_bid_id` BIGINT NOT NULL COMMENT 'Unique identifier for the market bid record. Primary key for the market_bid product.',
  `battery_storage_asset_id` BIGINT COMMENT 'Foreign key linking to renewable.battery_storage_asset. Business justification: Battery storage systems bid into ISO markets for energy arbitrage and ancillary services. Links bids to specific battery assets for SOC management, ramp rate validation, and performance tracking.',
  `book_id` BIGINT COMMENT 'FK to trading.trading_book',
  `counterparty_id` BIGINT COMMENT 'FK to trading.counterparty',
  `der_system_id` BIGINT COMMENT 'Unique identifier for the generation or demand response resource submitting the bid. Corresponds to the ISO/RTO registered resource ID.',
  `dr_event_id` BIGINT COMMENT 'Foreign key linking to demand.dr_event. Business justification: Market bids submitted for DR resources during dispatch events. Real business process: ISO/RTO day-ahead and real-time market participation where aggregated DR resources bid load curtailment as supply,',
  `employee_id` BIGINT COMMENT 'The identifier of the trader or scheduling coordinator who submitted this bid. Used for audit trails and performance tracking.',
  `forecast_generation_id` BIGINT COMMENT 'Foreign key linking to forecast.forecast_generation. Business justification: Generation resource bids require unit-specific generation forecasts (especially for renewables and variable resources) to determine available capacity. Schedulers link bids to generation forecasts to',
  `load_id` BIGINT COMMENT 'Foreign key linking to forecast.load. Business justification: Day-ahead and real-time market bids are informed by load forecasts to optimize dispatch strategy and avoid imbalance charges. Bid desk analysts reference load forecasts when determining bid quantities',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: ISO/RTO market bids must comply with market behavior rules, tariff requirements, and FERC anti-manipulation regulations. Compliance monitoring systems flag bids violating specific obligations for pre-',
  `scheduling_coordinator_id` BIGINT COMMENT 'FK to trading.scheduling_coordinator.scheduling_coordinator_id — Market bids are submitted through a scheduling coordinator registered with the ISO/RTO. This FK establishes market participation authority and NAESB compliance.',
  `ancillary_service_type` STRING COMMENT 'The specific type of ancillary service being procured. Ancillary services are grid support services required to maintain reliability and balance supply and demand. Reference-value candidates: regulation_up|regulation_down|spinning_reserve|non_spinning_reserve|supplemental_reserve|voltage_support|black_start.',
  `award_timestamp` TIMESTAMP COMMENT 'The timestamp when the ISO/RTO issued the market clearing award for this bid. Marks the transition from bid submission to awarded status.',
  `awarded_mw` DECIMAL(12,3) COMMENT 'The quantity of energy or capacity awarded to this bid after market clearing, measured in megawatts. May be less than bid_quantity_mw for partially awarded bids.',
  `bid_curve_segments` STRING COMMENT 'JSON or delimited representation of multi-segment bid curves, capturing incremental MW quantities and corresponding prices. Allows for non-linear supply curves reflecting marginal cost increases.',
  `bid_price_per_mwh` DECIMAL(12,2) COMMENT 'The price at which the bidder is willing to supply energy or capacity, expressed in dollars per megawatt-hour. For multi-segment bids, this represents the starting price.',
  `bid_quantity_mw` DECIMAL(12,3) COMMENT 'The total quantity of energy or capacity being offered in this bid, measured in megawatts. For energy bids, this represents the MW available for dispatch.',
  `bid_reference_number` STRING COMMENT 'External reference number assigned by the ISO/RTO or internal ETRM system (OpenLink Endur) to uniquely identify this bid submission.',
  `bid_status` STRING COMMENT 'Current lifecycle status of the bid. Tracks progression from draft through submission, ISO acceptance, market clearing award, and final settlement. Reference-value candidates: draft|submitted|accepted|rejected|partially_awarded|fully_awarded|cancelled|expired.',
  `bid_strategy_code` STRING COMMENT 'Internal code representing the bidding strategy or algorithm used to generate this bid. Confidential business information used for strategy analysis.',
  `bid_to_pnode` BIGINT COMMENT 'FK to trading.pnode.pnode_id — Market bids are submitted for specific PNodes. Required for bid validation and market participation tracking.',
  `bid_type` STRING COMMENT 'The type of market product being bid. Energy bids are for physical power delivery; ancillary service bids are for grid support services; capacity bids are for resource adequacy; FTR and CRR bids are for financial hedging instruments. Valid values: energy|ancillary_service|capacity|financial_transmission_right|congestion_revenue_right.',
  `clearing_price_lmp` DECIMAL(12,2) COMMENT 'The Locational Marginal Price at which the market cleared for this bid. Represents the market-determined price for energy at the specified PNode and interval.',
  `cost_allocation_tariff` STRING COMMENT 'The tariff category to which ancillary service costs are allocated. Determines whether costs are recovered through transmission, distribution, or other rate components. Valid values: transmission|distribution|generation|customer.',
  `counterparty_credit_rating` STRING COMMENT 'The credit rating of the counterparty, used for credit exposure management and risk assessment in bilateral trading.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this market bid record was first created in the ETRM system. Used for audit trails and data lineage.',
  `curtailment_instructions` STRING COMMENT 'ISO/RTO instructions for curtailing or reducing the scheduled energy delivery due to transmission constraints, reliability events, or market conditions.',
  `etag_reference_number` STRING COMMENT 'The NAESB-compliant e-Tag reference number for the physical energy schedule associated with this bid. Links the market award to the transmission scheduling and tagging system.',
  `ferc_eqr_reported_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this bid has been included in the quarterly FERC EQR filing. FERC requires reporting of all wholesale electricity transactions.',
  `iso_award_reference` STRING COMMENT 'The ISO/RTO award reference number specific to ancillary service procurement. Used for settlement and cost allocation.',
  `iso_confirmation_reference` STRING COMMENT 'The confirmation or award reference number issued by the ISO/RTO after market clearing. Used for reconciliation and settlement.',
  `iso_rto_code` STRING COMMENT 'The ISO or RTO market to which this bid was submitted. Identifies the wholesale electricity market operator. Reference-value candidates: CAISO|MISO|PJM|ERCOT|NYISO|ISONE|SPP.',
  `market_interval_end` TIMESTAMP COMMENT 'The end timestamp of the market interval for which this bid applies. Together with market_interval_start, defines the delivery window.',
  `market_interval_start` TIMESTAMP COMMENT 'The start timestamp of the market interval (typically hourly or sub-hourly) for which this bid applies. Defines the delivery period.',
  `market_type` STRING COMMENT 'The market timeframe for this bid. Day-Ahead Market (DAM) clears one day prior to delivery; Real-Time Market (RTM) clears closer to the operating hour. Valid values: day_ahead|real_time|hour_ahead|intraday.',
  `modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this market bid record was last modified. Tracks updates to bid status, awards, schedules, or settlement data.',
  `naesb_compliant_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this bid and associated scheduling comply with NAESB WEQ standards for wholesale energy transactions and e-Tag requirements.',
  `pnode_code` STRING COMMENT 'The pricing node or location at which energy is being bid or delivered. PNodes are the granular pricing locations within the ISO/RTO market used to calculate Locational Marginal Prices (LMP).',
  `procured_mw` DECIMAL(12,3) COMMENT 'The quantity of ancillary service capacity procured through this bid, measured in megawatts. Represents the reserved capacity for grid support.',
  `procurement_price_per_mw_hr` DECIMAL(12,2) COMMENT 'The price paid for procured ancillary services, expressed in dollars per megawatt-hour. Reflects the capacity reservation cost.',
  `rec_tracking_number` STRING COMMENT 'The tracking number for Renewable Energy Certificates associated with this bid, if the energy is from renewable sources. Used for RPS compliance and environmental attribute tracking.',
  `schedule_status` STRING COMMENT 'Current status of the physical energy schedule (e-Tag). Tracks progression from submission through ISO confirmation, curtailment events, and expiration. Valid values: submitted|confirmed|curtailed|expired|cancelled.',
  `scheduled_mw_by_interval` STRING COMMENT 'JSON or delimited representation of scheduled MW quantities for each sub-interval within the market interval. Captures granular scheduling data for real-time dispatch.',
  `settlement_amount` DECIMAL(15,2) COMMENT 'The total financial settlement amount for this bid after market clearing and final settlement calculations. Includes energy payments, ancillary service payments, and any adjustments.',
  `settlement_date` DATE COMMENT 'The date on which financial settlement for this bid was completed by the ISO/RTO or counterparty.',
  `sink_pnode` STRING COMMENT 'The sink PNode for the scheduled energy transaction. Identifies the load or withdrawal point for the physical energy flow.',
  `source_pnode` STRING COMMENT 'The source PNode for the scheduled energy transaction. Identifies the generation or injection point for the physical energy flow.',
  `source_system` STRING COMMENT 'The name of the source system from which this bid record originated, typically OpenLink Endur ETRM or ISO/RTO market interface systems.',
  `submission_timestamp` TIMESTAMP COMMENT 'The exact timestamp when the bid was submitted to the ISO/RTO market. Critical for compliance with market submission deadlines and audit trails.',
  `transmission_path` STRING COMMENT 'The transmission path or corridor used for the scheduled energy delivery. May reference a named path or a set of transmission facilities.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_market_bid` PRIMARY KEY (`market_bid_id`)
)
USING DELTA
COMMENT 'Unified market participation record covering the complete ISO/RTO market lifecycle from bid submission through clearing award, physical energy scheduling, and ancillary service procurement. Captures DAM and RTM bid/offer submissions to ISO/RTO markets (CAISO, MISO, PJM, ERCOT, NYISO, ISO-NE) including bid type (energy, ancillary service, capacity), resource ID, PNode, bid quantity (MW), bid price ($/MWh), bid curve segments, market interval, and submission timestamp. Tracks award phase: awarded MW, clearing price (LMP), ISO confirmation reference, award interval, and market type (DAM/RTM). Tracks scheduling phase: e-Tag reference number, source/sink PNodes, transmission path, scheduled MW by interval, curtailment instructions, schedule status (submitted, confirmed, curtailed, expired), and NAESB e-Tag compliance. Covers ancillary service procurement: service type (regulation up/down, spinning reserve, non-spinning reserve, supplemental), resource ID, procured MW, procurement price ($/MW-hr), ISO award reference, and cost allocation to transmission or distribution tariff. Supports FERC EQR reporting, NAESB e-Tag compliance, ancillary service cost reporting, and complete market participation audit trail. SSOT for all ISO/RTO market participation data in the trading domain. | CMM: CIM Bid (exact), IEC62325::ParticipantInterfaces.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MarketBid',
  'cmm.cim.class' = 'Bid',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC62325::ParticipantInterfaces',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.market_bid'
);

-- MarketAward  <<CIM ResourceAwardInstruction : close>>
CREATE TABLE IF NOT EXISTS `trading`.`market_award` (
  `market_award_id` BIGINT NOT NULL COMMENT 'Unique identifier for the ISO/RTO market clearing award record. Primary key for the market award entity.',
  `battery_storage_asset_id` BIGINT COMMENT 'Foreign key linking to renewable.battery_storage_asset. Business justification: Battery market awards drive charge/discharge schedules. Links awards to battery assets for SOC tracking, cycle counting, degradation monitoring, and settlement validation against actual performance.',
  `der_system_id` BIGINT COMMENT 'Identifier of the generation or demand response resource that received the market award. Links to the resource master data in the generation or demand response domain.',
  `dr_event_id` BIGINT COMMENT 'Foreign key linking to demand.dr_event. Business justification: Market awards result from DR resource bids during events. Real business process: ISO settlement of DR dispatch, allocating clearing prices and payments to DR events for revenue recognition and partici',
  `energy_schedule_id` BIGINT COMMENT 'Identifier of the physical energy schedule created from this market award. Links to the scheduling and dispatch domain.',
  `feeder_id` BIGINT COMMENT 'Foreign key linking to distribution.feeder. Business justification: Market awards for distributed energy resources specify feeder-level delivery. Feeder tracking is essential for DER aggregation settlement, distribution locational marginal pricing pilots, and coordina',
  `lmp_price_id` BIGINT COMMENT 'Foreign key linking to trading.lmp_price. Business justification: Market awards are cleared at Locational Marginal Prices published by the ISO/RTO. Each award should reference the official LMP price record for the pnode and market interval to ensure price consistenc',
  `market_bid_id` BIGINT COMMENT 'FK to trading.market_bid.market_bid_id — Market awards are the ISO response to market bids. This bid→award linkage is essential for market participation tracking, bid-to-award reconciliation, and FERC compliance.',
  `market_participant_id` BIGINT COMMENT 'Identifier of the scheduling coordinator or market participant who submitted the bid or offer that resulted in this award.',
  `pnode_id` BIGINT COMMENT 'Identifier of the pricing node (PNode) or location at which the LMP was calculated and the award was made. Represents the electrical location for settlement.',
  `primary_market_bid_id` BIGINT COMMENT 'Identifier of the original bid or offer submitted by the market participant that resulted in this award. Links to the bid submission record.',
  `settlement_statement_id` BIGINT COMMENT 'Identifier of the ISO/RTO settlement statement that includes this award. Used for invoice reconciliation and payment tracking.',
  `transmission_constraint_id` BIGINT COMMENT 'Identifier of the binding transmission constraint that influenced this award, if applicable. Used for congestion analysis and FTR allocation.',
  `award_confirmation_number` STRING COMMENT 'Unique confirmation reference number issued by the ISO/RTO for this market award. Used for settlement reconciliation and dispute resolution.',
  `award_interval_end_timestamp` TIMESTAMP COMMENT 'End date and time of the market interval for which this award applies. Defines the end of the delivery period.',
  `award_interval_start_timestamp` TIMESTAMP COMMENT 'Start date and time of the market interval for which this award applies. Defines the beginning of the delivery period.',
  `award_status` STRING COMMENT 'Current lifecycle status of the market award. CONFIRMED = initial award issued, REVISED = award modified by ISO, CANCELLED = award voided, SETTLED = financially settled, DISPUTED = under dispute resolution. Valid values: CONFIRMED|REVISED|CANCELLED|SETTLED|DISPUTED.',
  `award_timestamp` TIMESTAMP COMMENT 'Date and time when the ISO/RTO issued this market award confirmation. Represents the official award notification time.',
  `award_version` INT COMMENT 'Version number of this award record. Increments with each revision or correction issued by the ISO/RTO. Used for change tracking.',
  `awarded_quantity_mw` DECIMAL(18,6) COMMENT 'Quantity of energy or ancillary service capacity awarded to the resource for the market interval, measured in megawatts (MW). Represents the cleared MW obligation.',
  `awarded_quantity_mwh` DECIMAL(18,6) COMMENT 'Energy quantity awarded for the interval expressed in megawatt-hours (MWh). Calculated as awarded_quantity_mw multiplied by interval duration.',
  `block_dispatch_flag` BOOLEAN COMMENT 'Indicates whether this award is part of a block or all-or-nothing dispatch instruction. True = block dispatch, False = divisible award.',
  `clearing_price_per_mwh` DECIMAL(18,6) COMMENT 'Locational Marginal Price (LMP) or market clearing price at which the award was made, expressed in currency per MWh. Determines settlement value.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this market award record was first created in the ETRM system. Used for audit trail and data lineage.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this award record. Typically USD for US markets, CAD for Canadian markets. Valid values: USD|CAD|MXN.',
  `dispute_flag` BOOLEAN COMMENT 'Indicates whether this award is currently under dispute by the market participant. True = disputed, False = accepted.',
  `dispute_reason` STRING COMMENT 'Description of the reason for disputing this award, if dispute_flag is true. Captures the nature of the disagreement for resolution tracking.',
  `interval_duration_minutes` INT COMMENT 'Duration of the market interval in minutes. Typically 5, 15, or 60 minutes depending on ISO/RTO market design.',
  `iso_rto_code` STRING COMMENT 'Code identifying the ISO or RTO that issued this market award. Indicates the market jurisdiction. Reference-value candidates: CAISO|ERCOT|ISONE|MISO|NYISO|PJM|SPP.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this market award record was last updated. Tracks revisions and corrections to the award data.',
  `market_type` STRING COMMENT 'Type of market in which the award was issued. DAM = Day-Ahead Market, RTM = Real-Time Market, FTR = Financial Transmission Rights, CRR = Congestion Revenue Rights, ANCILLARY = Ancillary Services Market. Valid values: DAM|RTM|FTR|CRR|ANCILLARY.',
  `minimum_run_time_minutes` INT COMMENT 'Minimum continuous run time in minutes that the resource must operate if awarded, as specified in the bid parameters. Reflects operational constraints.',
  `must_run_flag` BOOLEAN COMMENT 'Indicates whether this award was issued under a reliability must-run (RMR) or similar out-of-market commitment. True = must-run, False = economic dispatch.',
  `no_load_cost` DECIMAL(18,2) COMMENT 'No-load cost in currency units for operating the resource at minimum output. Used for commitment and settlement calculations.',
  `pnode_name` STRING COMMENT 'Descriptive name of the pricing node or location. Provides human-readable identification of the settlement location.',
  `product_type` STRING COMMENT 'Specific energy or ancillary service product awarded. ENERGY = energy commodity, REGULATION_UP/DOWN = frequency regulation, SPINNING_RESERVE = synchronized reserve, NON_SPINNING_RESERVE = supplemental reserve, REACTIVE_POWER = voltage support, BLACK_START = restoration service. Reference-value candidates: ENERGY|REGULATION_UP|REGULATION_DOWN|SPINNING_RESERVE|NON_SPINNING_RESERVE|REACTIVE_POWER|BLACK_START.',
  `ramp_rate_mw_per_minute` DECIMAL(10,3) COMMENT 'Maximum rate at which the resource can change output, measured in MW per minute. Used for dispatch feasibility and scheduling.',
  `self_schedule_flag` BOOLEAN COMMENT 'Indicates whether this award resulted from a self-schedule (price-taker) bid rather than an economic (price-setter) bid. True = self-schedule, False = economic bid.',
  `settlement_amount` DECIMAL(18,2) COMMENT 'Total financial settlement amount for this award, calculated as awarded_quantity_mwh multiplied by clearing_price_per_mwh. Represents the revenue or cost obligation.',
  `settlement_run_type` STRING COMMENT 'Type of settlement calculation run that produced this award record. INITIAL = first settlement, FINAL = final settlement after meter data, RESETTLEMENT = correction run, TRUE_UP = annual reconciliation. Valid values: INITIAL|FINAL|RESETTLEMENT|TRUE_UP.',
  `shadow_price` DECIMAL(18,6) COMMENT 'Shadow price of the binding constraint that limited the award quantity. Represents the marginal value of relaxing the constraint.',
  `source_system` STRING COMMENT 'Name of the source system from which this award record originated. Typically the ETRM system (e.g., OpenLink Endur) or ISO/RTO interface.',
  `startup_cost` DECIMAL(18,2) COMMENT 'Startup cost in currency units associated with this award if the resource was committed from an offline state. Used for make-whole payments.',
  `trading_date` DATE COMMENT 'The operating day for which the energy or ancillary service was awarded. Represents the physical delivery date.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_market_award` PRIMARY KEY (`market_award_id`)
)
USING DELTA
COMMENT 'ISO/RTO market clearing award record confirming accepted energy or ancillary service quantities for a given resource and market interval. Captures awarded MW, clearing price (LMP), market type (DAM/RTM), resource ID, PNode, award interval, and ISO confirmation reference. Drives physical scheduling and settlement obligations. | CMM: CIM ResourceAwardInstruction (close), IEC62325::MarketResults.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MarketAward',
  'cmm.cim.class' = 'ResourceAwardInstruction',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC62325::MarketResults',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.market_award'
);

-- LmpPrice  <<CIM PnodeResults : close>>
CREATE TABLE IF NOT EXISTS `trading`.`lmp_price` (
  `lmp_price_id` BIGINT NOT NULL COMMENT 'Unique identifier for the LMP price record. Primary key for the LMP price data product.',
  `market_run_id` BIGINT COMMENT 'Identifier for the specific market run or market clearing execution that produced this LMP. Used to track revisions and re-runs of market settlements.',
  `pnode_id` BIGINT COMMENT 'Identifier for the pricing node (PNode) where the LMP is calculated. Links to the pricing node master data.',
  `actual_load_mw` DECIMAL(18,4) COMMENT 'Actual measured load in megawatts (MW) at this pricing node for the market interval. Used for real-time market settlement and forecast accuracy analysis.',
  `ancillary_service_flag` BOOLEAN COMMENT 'Indicates whether this LMP record includes ancillary service pricing components (regulation, spinning reserve, non-spinning reserve).',
  `congestion_status` STRING COMMENT 'Indicates whether transmission congestion was binding at this location during the market interval. BINDING = congestion constraint was active, NON_BINDING = no active congestion. Valid values: NONE|BINDING|NON_BINDING.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the LMP values. Typically USD for US markets, CAD for Canadian markets. Valid values: USD|CAD.',
  `current_record_flag` BOOLEAN COMMENT 'Indicates whether this is the current active record for the pricing node and market interval. True for current records, False for historical versions.',
  `data_quality_flag` STRING COMMENT 'Indicates the quality status of the LMP data. VALID = verified data, ESTIMATED = calculated estimate, MISSING = data not available, SUSPECT = data flagged for review, REVISED = corrected data. Valid values: VALID|ESTIMATED|MISSING|SUSPECT|REVISED.',
  `iso_rto_code` STRING COMMENT 'Code identifying the ISO or RTO that published this LMP. Examples: CAISO, ERCOT, ISONE, MISO, NYISO, PJM, SPP. Reference-value candidates: CAISO|ERCOT|ISONE|MISO|NYISO|PJM|SPP.',
  `lmp_congestion_component` DECIMAL(18,4) COMMENT 'Congestion component of the LMP in $/MWh. Represents the cost of transmission congestion between the pricing node and the reference bus.',
  `lmp_energy_component` DECIMAL(18,4) COMMENT 'Energy component of the LMP in $/MWh. Represents the marginal cost of serving the next increment of load at the reference bus.',
  `lmp_loss_component` DECIMAL(18,4) COMMENT 'Loss component of the LMP in $/MWh. Represents the marginal cost of transmission losses between the pricing node and the reference bus.',
  `lmp_to_pnode` BIGINT COMMENT 'FK to trading.pnode.pnode_id — LMP prices are published per PNode per interval. This is the fundamental reference relationship for all price-based calculations in the trading domain.',
  `lmp_total` DECIMAL(18,4) COMMENT 'Total locational marginal price in dollars per megawatt-hour ($/MWh). Sum of energy component, congestion component, and loss component.',
  `load_forecast_mw` DECIMAL(18,4) COMMENT 'Forecasted load in megawatts (MW) at this pricing node for the market interval. Used for day-ahead market clearing and price formation analysis.',
  `location_type` STRING COMMENT 'Type of location for which the LMP is calculated. GENERATOR = generation resource, LOAD = load zone, HUB = trading hub, ZONE = pricing zone, INTERFACE = transmission interface, AGGREGATE = aggregated pricing point. Valid values: GENERATOR|LOAD|HUB|ZONE|INTERFACE|AGGREGATE.',
  `marginal_loss_factor` DECIMAL(10,6) COMMENT 'Marginal loss factor at the pricing node. Represents the incremental transmission losses per unit of power injected or withdrawn at this location.',
  `market_date` DATE COMMENT 'The calendar date for which the LMP applies. Used for day-level aggregation and reporting.',
  `market_hour` INT COMMENT 'The hour of the day (0-23) for which the LMP applies. Used for hourly market analysis and reporting.',
  `market_interval_end_timestamp` TIMESTAMP COMMENT 'End timestamp of the market interval for which the LMP applies. Represents the conclusion of the trading interval.',
  `market_interval_start_timestamp` TIMESTAMP COMMENT 'Start timestamp of the market interval for which the LMP applies. Represents the beginning of the trading interval (typically 5-minute or hourly intervals depending on ISO/RTO).',
  `market_run_type` STRING COMMENT 'Type of market run. INITIAL = first published results, RESETTLEMENT = revised settlement, FINAL = final binding settlement after all adjustments. Valid values: INITIAL|RESETTLEMENT|FINAL.',
  `market_type` STRING COMMENT 'Type of energy market for which the LMP is published. DAM = Day-Ahead Market, RTM = Real-Time Market, FMM = Fifteen-Minute Market, IDM = Intra-Day Market. Valid values: DAM|RTM|FMM|IDM.',
  `price_unit_of_measure` STRING COMMENT 'Unit of measure for the LMP price. Standard is dollars per megawatt-hour ($/MWh). Valid values: USD_PER_MWH|CAD_PER_MWH.',
  `pricing_zone_code` STRING COMMENT 'Code identifying the pricing zone or load zone to which the pricing node belongs. Used for zonal price aggregation.',
  `publication_timestamp` TIMESTAMP COMMENT 'Timestamp when the LMP data was published by the ISO/RTO. Used to track data latency and timeliness of market information.',
  `record_effective_timestamp` TIMESTAMP COMMENT 'Timestamp when this LMP record became effective in the data warehouse. Used for temporal tracking and historical analysis.',
  `record_end_timestamp` TIMESTAMP COMMENT 'Timestamp when this LMP record was superseded or expired. Null for current records. Used for slowly changing dimension Type 2 tracking.',
  `reference_bus_name` STRING COMMENT 'Name of the reference bus used for LMP calculation. The reference bus is the baseline location against which congestion and loss components are measured.',
  `scarcity_pricing_flag` BOOLEAN COMMENT 'Indicates whether scarcity pricing or operating reserve demand curve pricing was applied during this market interval. Used to identify periods of tight supply conditions.',
  `source_system_code` STRING COMMENT 'Code identifying the source system from which the LMP data was extracted. Typically the ISO/RTO market data feed or ETRM system identifier.',
  `trading_hub_flag` BOOLEAN COMMENT 'Indicates whether this pricing node is a designated trading hub. Trading hubs are commonly used reference points for bilateral contracts and financial hedging.',
  `voltage_level_kv` DECIMAL(10,2) COMMENT 'Voltage level in kilovolts (kV) at which the pricing node is located. Used for transmission planning and loss analysis.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_lmp_price` PRIMARY KEY (`lmp_price_id`)
)
USING DELTA
COMMENT 'Locational Marginal Price (LMP) records published by ISO/RTO for each PNode and market interval. Captures LMP components: energy component, congestion component, and loss component ($/MWh), market type (DAM/RTM/FMM), interval timestamp, and ISO source. Used for trade valuation, settlement calculations, congestion analysis, and hedging strategy. Sourced from ISO market data feeds. | CMM: CIM PnodeResults (close), IEC62325::MarketResults.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'LmpPrice',
  'cmm.cim.class' = 'PnodeResults',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC62325::MarketResults',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.lmp_price'
);

-- SchedulingCoordinator  <<CIM SchedulingCoordinator : exact>>
CREATE TABLE IF NOT EXISTS `trading`.`scheduling_coordinator` (
  `scheduling_coordinator_id` BIGINT NOT NULL COMMENT 'Unique identifier for the scheduling coordinator entity registered with an ISO/RTO. Primary key for the scheduling coordinator product.',
  `compliance_environmental_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.environmental_permit. Business justification: Scheduling coordinators operating generation resources must hold environmental permits for air quality and water discharge. Compliance teams verify SC registrations align with permitted facilities to',
  `ancillary_services_flag` BOOLEAN COMMENT 'Indicates whether this scheduling coordinator is authorized to bid and provide ancillary services (regulation, spinning reserve, non-spinning reserve, voltage support) in the ISO/RTO markets.',
  `business_address_line1` STRING COMMENT 'The first line of the scheduling coordinator\'s registered business address (street number and name) on file with the ISO/RTO.',
  `business_address_line2` STRING COMMENT 'The second line of the scheduling coordinator\'s registered business address (suite, floor, building) on file with the ISO/RTO.',
  `business_city` STRING COMMENT 'The city of the scheduling coordinator\'s registered business address on file with the ISO/RTO.',
  `business_country_code` STRING COMMENT 'The three-letter ISO country code of the scheduling coordinator\'s registered business address. Typically USA, CAN (Canada), or MEX (Mexico) for North American energy markets. Valid values: USA|CAN|MEX.',
  `business_postal_code` STRING COMMENT 'The postal code or ZIP code of the scheduling coordinator\'s registered business address on file with the ISO/RTO.',
  `business_state_province` STRING COMMENT 'The state or province of the scheduling coordinator\'s registered business address on file with the ISO/RTO.',
  `collateral_posted_usd` DECIMAL(18,2) COMMENT 'The total amount of financial collateral (cash, letter of credit, surety bond) posted by the scheduling coordinator with the ISO/RTO to secure market obligations and credit exposure.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this scheduling coordinator record was first created in the data system. Used for data lineage and audit trail purposes.',
  `credit_limit_usd` DECIMAL(18,2) COMMENT 'The maximum credit exposure limit in USD established by the ISO/RTO for this scheduling coordinator based on creditworthiness assessment. Determines the maximum unsecured market position the SC can hold.',
  `dam_participation_flag` BOOLEAN COMMENT 'Indicates whether this scheduling coordinator is authorized and actively participates in the ISO/RTO day-ahead energy market for forward scheduling and financial hedging.',
  `duns_number` STRING COMMENT 'The nine-digit DUNS number assigned by Dun & Bradstreet to uniquely identify the scheduling coordinator entity for credit assessment and business verification purposes. Pattern: ^[0-9]{9}$.',
  `etrm_system_code` STRING COMMENT 'The internal identifier for this scheduling coordinator in the utility\'s ETRM system (e.g., OpenLink Endur). Used for linking ISO/RTO market positions to internal trading books and risk management.',
  `ferc_mbr_authorization` STRING COMMENT 'Reference to the FERC docket number or authorization identifier granting this scheduling coordinator market-based rate authority for wholesale energy sales. Required for entities selling energy at market rates rather than cost-based rates.',
  `ftr_crr_eligibility_flag` BOOLEAN COMMENT 'Indicates whether this scheduling coordinator is eligible to hold and trade financial transmission rights or congestion revenue rights for hedging transmission congestion costs.',
  `iso_rto_affiliation` STRING COMMENT 'The ISO or RTO with which this scheduling coordinator is registered and authorized to submit schedules, bids, and participate in market operations. Reference-value candidates: CAISO|ERCOT|MISO|PJM|SPP|NYISO|ISO_NE|other.',
  `last_audit_date` DATE COMMENT 'The date of the most recent compliance audit or review conducted by the ISO/RTO or internal audit team to verify scheduling coordinator adherence to market rules and OATT requirements.',
  `last_audit_result` STRING COMMENT 'The outcome of the most recent compliance audit: passed (no issues), passed with findings (minor issues noted), failed (material non-compliance), or not applicable (no audit conducted). Valid values: passed|passed_with_findings|failed|not_applicable.',
  `naesb_certification_date` DATE COMMENT 'The date on which the scheduling coordinator received NAESB WEQ certification for electronic scheduling authority.',
  `naesb_certification_status` STRING COMMENT 'Indicates whether the scheduling coordinator holds current NAESB WEQ certification for electronic scheduling (e-Tag) authority. Certified status is required for submitting NERC e-Tags for interchange transactions. Valid values: certified|not_certified|expired|pending.',
  `nerc_company_code` STRING COMMENT 'The unique company identifier assigned by NERC for compliance reporting and reliability coordination. Used for linking scheduling coordinator activities to NERC CIP and operational standards.',
  `notes` STRING COMMENT 'Free-form text field for capturing additional information, special conditions, operational notes, or historical context related to this scheduling coordinator registration and market participation.',
  `oatt_compliance_status` STRING COMMENT 'Indicates whether the scheduling coordinator is in compliance with FERC-mandated Open Access Transmission Tariff requirements for non-discriminatory transmission access and scheduling practices. Valid values: compliant|non_compliant|conditional|under_review.',
  `primary_contact_email` STRING COMMENT 'The primary email address for the scheduling coordinator contact used for ISO/RTO market notices, settlement statements, and operational communications. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `primary_contact_name` STRING COMMENT 'The full name of the primary business contact person responsible for scheduling coordinator operations and ISO/RTO communications.',
  `primary_contact_phone` STRING COMMENT 'The primary telephone number for the scheduling coordinator contact used for urgent market operations and real-time coordination with the ISO/RTO.',
  `registered_resource_count` INT COMMENT 'The total number of generation and/or load resources currently registered under this scheduling coordinator for market participation and settlement purposes.',
  `registration_date` DATE COMMENT 'The date on which the scheduling coordinator was officially registered and authorized by the ISO/RTO to participate in wholesale energy markets.',
  `registration_expiration_date` DATE COMMENT 'The date on which the scheduling coordinator registration expires and must be renewed. Null if registration is perpetual subject to compliance.',
  `registration_status` STRING COMMENT 'Current lifecycle status of the scheduling coordinator registration with the ISO/RTO. Active indicates full market participation authority; inactive indicates voluntary withdrawal; suspended indicates temporary restriction; pending_approval indicates application under review; revoked indicates termination by ISO/RTO. Valid values: active|inactive|suspended|pending_approval|revoked.',
  `rtm_participation_flag` BOOLEAN COMMENT 'Indicates whether this scheduling coordinator is authorized and actively participates in the ISO/RTO real-time energy market for balancing and spot transactions.',
  `sc_code` STRING COMMENT 'The externally-known unique alphanumeric code assigned by the ISO/RTO to identify this scheduling coordinator in market operations, e-Tag submissions, and settlement processes. Pattern: ^[A-Z0-9]{4,10}$.',
  `sc_name` STRING COMMENT 'The legal business name of the scheduling coordinator entity as registered with the ISO/RTO.',
  `sc_type` STRING COMMENT 'Classification of the scheduling coordinator based on the primary role in the wholesale energy market: generator (represents generation resources), load-serving entity (represents load), marketer (third-party intermediary), trader (financial participant), aggregator (pools multiple resources), or hybrid (multiple roles). Valid values: generator|load_serving_entity|marketer|trader|aggregator|hybrid.',
  `scheduling_contact_email` STRING COMMENT 'The email address for the scheduling contact used for schedule confirmations, e-Tag notifications, and market bid acknowledgments. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `scheduling_contact_name` STRING COMMENT 'The full name of the designated contact person responsible for submitting energy schedules, e-Tags, and day-ahead/real-time market bids on behalf of the scheduling coordinator.',
  `scheduling_contact_phone` STRING COMMENT 'The telephone number for the scheduling contact used for real-time schedule adjustments, curtailment notifications, and emergency coordination.',
  `settlement_contact_email` STRING COMMENT 'The email address for the settlement contact used for receiving settlement statements, invoices, and payment notifications from the ISO/RTO. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `settlement_contact_name` STRING COMMENT 'The full name of the designated contact person responsible for reviewing market settlement statements, invoice reconciliation, and financial dispute resolution.',
  `settlement_contact_phone` STRING COMMENT 'The telephone number for the settlement contact used for resolving billing disputes, payment coordination, and financial reconciliation inquiries.',
  `tax_identification_number` STRING COMMENT 'The federal tax identification number (EIN for US entities, Business Number for Canadian entities) used for tax reporting and financial settlement with the ISO/RTO.',
  `total_registered_capacity_mw` DECIMAL(12,2) COMMENT 'The aggregate nameplate capacity in megawatts (MW) of all generation resources registered under this scheduling coordinator. Used for market monitoring and concentration analysis.',
  `updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this scheduling coordinator record was last modified in the data system. Used for tracking data currency and change management.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_scheduling_coordinator` PRIMARY KEY (`scheduling_coordinator_id`)
)
USING DELTA
COMMENT 'Scheduling coordinator (SC) entity registered with an ISO/RTO to submit energy schedules, market bids, and settlement on behalf of the utility\'s generation and load resources. Captures SC ID, ISO/RTO affiliation, registered resource list, SC type (generator, load-serving entity, marketer), OATT compliance status, NAESB scheduling certification, FERC market-based rate authorization reference, contact information, and active/inactive status. Required for ISO market participation eligibility and NAESB e-Tag scheduling authority. | CMM: CIM SchedulingCoordinator (exact), IEC62325::MarketOpCommon.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SchedulingCoordinator',
  'cmm.cim.class' = 'SchedulingCoordinator',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC62325::MarketOpCommon',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.scheduling_coordinator'
);

-- EnergySchedule  <<CIM EnergyTransaction : close>>
CREATE TABLE IF NOT EXISTS `trading`.`energy_schedule` (
  `energy_schedule_id` BIGINT NOT NULL COMMENT 'Unique identifier for the energy schedule record. Primary key for the energy schedule entity.',
  `counterparty_id` BIGINT COMMENT 'Identifier of the counterparty entity involved in this energy schedule transaction. May be a bilateral trading partner, ISO/RTO, or scheduling coordinator.',
  `dr_event_id` BIGINT COMMENT 'Foreign key linking to demand.dr_event. Business justification: Energy schedules must account for DR event curtailments. Real business process: transmission scheduling and balancing where DR events create load deviations requiring e-Tag adjustments and imbalance s',
  `energy_scheduling_coordinator_id` BIGINT COMMENT 'Identifier of the scheduling coordinator responsible for submitting and managing this schedule with the ISO/RTO. The SC acts as the interface between market participants and the system operator.',
  `event_id` BIGINT COMMENT 'Foreign key linking to outage.outage_event. Business justification: Energy schedules (e-Tags) are curtailed or modified when transmission/generation outages occur. NERC/NAESB coordination requires tracking which outage event caused schedule adjustments. Essential for',
  `forecast_generation_id` BIGINT COMMENT 'Foreign key linking to forecast.forecast_generation. Business justification: E-tags and transmission schedules are created based on generation forecasts. Scheduling coordinators use generation forecasts to submit balanced schedules to ISOs/RTOs and avoid imbalance penalties. L',
  `load_id` BIGINT COMMENT 'Foreign key linking to forecast.load. Business justification: Transmission schedules must account for load forecasts at sink points to ensure adequate delivery and avoid congestion. Schedulers link schedules to load forecasts to optimize transmission path select',
  `market_participant_id` BIGINT COMMENT 'The unique identifier assigned to the market participant by the ISO/RTO for this energy schedule. Used for market settlement and reporting. Pattern: ^[A-Z0-9]{4,10}$.',
  `planned_outage_window_id` BIGINT COMMENT 'Foreign key linking to outage.planned_outage_window. Business justification: Schedulers coordinate energy schedules with planned transmission/generation maintenance windows to avoid scheduling through de-energized facilities. Required for OASIS posting compliance and day-ahead',
  `scheduling_coordinator_id` BIGINT COMMENT 'FK to trading.scheduling_coordinator.scheduling_coordinator_id — Energy schedules (e-Tags) are submitted by scheduling coordinators. This FK is required for NAESB compliance and schedule authorization tracking.',
  `trade_id` BIGINT COMMENT 'Unique identifier linking this schedule to the underlying energy trading transaction in the Energy Trading and Risk Management (ETRM) system. References the deal or position in OpenLink Endur.',
  `trading_position_id` BIGINT COMMENT 'Identifier linking this schedule to a Financial Transmission Right (FTR) position that hedges congestion risk between the source and sink nodes.',
  `transmission_path_id` BIGINT COMMENT 'Identifier of the transmission path or corridor used for this energy schedule. Links to the transmission network topology and Available Transfer Capability (ATC) calculations.',
  `transmission_service_agreement_id` BIGINT COMMENT 'Identifier of the transmission service agreement under which this schedule is executed. References the OATT-compliant service reservation.',
  `ancillary_service_type` STRING COMMENT 'The type of ancillary service being scheduled, if applicable. Ancillary services support grid reliability and include regulation, reserves, and voltage support. Valid values: regulation_up|regulation_down|spinning_reserve|non_spinning_reserve|replacement_reserve|voltage_support.',
  `balancing_authority_code` STRING COMMENT 'The four-letter code identifying the NERC-registered Balancing Authority responsible for maintaining load-resource balance for this energy schedule. Pattern: ^[A-Z]{4}$.',
  `comments` STRING COMMENT 'Free-text field for operational notes, special instructions, or additional context related to this energy schedule.',
  `confirmation_timestamp` TIMESTAMP COMMENT 'The date and time when this energy schedule was confirmed by the ISO/RTO or counterparty, indicating acceptance and readiness for execution.',
  `congestion_charge_usd` DECIMAL(15,2) COMMENT 'The congestion charge in US dollars associated with this energy schedule, calculated based on Locational Marginal Pricing (LMP) differences between source and sink nodes.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this energy schedule record was first created in the system. Used for audit trail and data lineage.',
  `curtailment_flag` BOOLEAN COMMENT 'Indicates whether this energy schedule has been subject to curtailment instructions from the transmission operator or ISO/RTO due to system constraints or reliability concerns.',
  `curtailment_mw` DECIMAL(12,3) COMMENT 'The megawatt amount by which this schedule has been curtailed. Represents the reduction from the originally scheduled MW due to transmission constraints or reliability directives.',
  `curtailment_reason` STRING COMMENT 'Textual explanation of the reason for schedule curtailment, such as transmission congestion, system emergency, or reliability constraint.',
  `curtailment_timestamp` TIMESTAMP COMMENT 'The date and time when the curtailment instruction was issued for this energy schedule.',
  `dynamic_schedule_flag` BOOLEAN COMMENT 'Indicates whether this is a dynamic schedule that allows real-time adjustments to scheduled MW values based on actual generation or load conditions, as opposed to a static schedule with fixed intervals.',
  `etag_reference_number` STRING COMMENT 'Unique electronic tag identifier assigned to this energy schedule for transmission system coordination and NERC compliance. The e-Tag is the industry-standard mechanism for scheduling energy transactions across transmission systems. Pattern: ^[A-Z0-9]{10,20}$.',
  `interval_duration_minutes` INT COMMENT 'The duration of each scheduling interval in minutes. Common values are 15, 30, or 60 minutes depending on ISO/RTO market rules.',
  `iso_rto_code` STRING COMMENT 'The code identifying the ISO or RTO jurisdiction where this energy schedule is executed. Major North American ISOs/RTOs include CAISO, ERCOT, MISO, PJM, NYISO, ISO-NE, and SPP. Reference-value candidates: CAISO|ERCOT|MISO|PJM|NYISO|ISO_NE|SPP.',
  `loss_factor` DECIMAL(8,6) COMMENT 'The percentage factor representing energy losses during transmission from source to sink. Used to adjust scheduled quantities for line losses.',
  `modified_by` STRING COMMENT 'The username or identifier of the system user who last modified this energy schedule record.',
  `modified_timestamp` TIMESTAMP COMMENT 'The date and time when this energy schedule record was last modified in the system. Used for audit trail and change tracking.',
  `number_of_intervals` INT COMMENT 'The total count of scheduling intervals covered by this energy schedule. Calculated based on schedule duration and interval length.',
  `priority_code` STRING COMMENT 'The priority classification of this energy schedule under OATT rules. Firm schedules have higher priority than non-firm during curtailment events. Valid values: firm|non_firm|conditional_firm|network.',
  `rec_quantity` DECIMAL(15,3) COMMENT 'The quantity of Renewable Energy Certificates (RECs) in MWh associated with this energy schedule, if applicable. Used for renewable portfolio standard (RPS) compliance.',
  `rec_tracking_flag` BOOLEAN COMMENT 'Indicates whether this energy schedule is associated with renewable energy generation and requires Renewable Energy Certificate (REC) tracking for compliance or trading purposes.',
  `schedule_end_timestamp` TIMESTAMP COMMENT 'The date and time when the scheduled energy delivery ends. Marks the end of the last interval in the schedule.',
  `schedule_start_timestamp` TIMESTAMP COMMENT 'The date and time when the scheduled energy delivery begins. Marks the start of the first interval in the schedule.',
  `schedule_status` STRING COMMENT 'Current lifecycle status of the energy schedule indicating its operational state in the scheduling workflow. Reference-value candidates: draft|submitted|confirmed|approved|active|curtailed|expired|cancelled|rejected.',
  `schedule_type` STRING COMMENT 'Classification of the energy schedule indicating the nature of the transaction: bilateral contract, day-ahead market (DAM), real-time market (RTM), ancillary services, wheel-through transmission, or dynamic schedule. Valid values: bilateral|day_ahead_market|real_time_market|ancillary_service|wheel_through|dynamic.',
  `scheduled_mw` DECIMAL(12,3) COMMENT 'The total megawatt capacity scheduled for delivery in this energy schedule. Represents the aggregate power flow across all intervals.',
  `scheduled_mwh` DECIMAL(15,3) COMMENT 'The total energy quantity in megawatt-hours scheduled for delivery across the entire schedule period. Calculated as the sum of interval-level MWh values.',
  `scheduling_fee_usd` DECIMAL(10,2) COMMENT 'The administrative fee in US dollars charged by the ISO/RTO or scheduling coordinator for processing and managing this energy schedule.',
  `settlement_period` STRING COMMENT 'The year-month period (YYYY-MM format) for which this energy schedule will be financially settled by the ISO/RTO or counterparty. Pattern: ^[0-9]{4}-(0[1-9]|1[0-2])$.',
  `settlement_status` STRING COMMENT 'The current status of financial settlement for this energy schedule. Tracks progression from preliminary to final settlement and any disputes or adjustments. Valid values: pending|preliminary|final|disputed|adjusted.',
  `sink_pnode` STRING COMMENT 'The pricing node or location identifier where energy is delivered or withdrawn from the transmission system. Used for Locational Marginal Pricing (LMP) calculations. Pattern: ^[A-Z0-9_]{4,20}$.',
  `source_pnode` STRING COMMENT 'The pricing node or location identifier where energy is sourced or injected into the transmission system. Used for Locational Marginal Pricing (LMP) calculations. Pattern: ^[A-Z0-9_]{4,20}$.',
  `submission_timestamp` TIMESTAMP COMMENT 'The date and time when this energy schedule was submitted to the ISO/RTO or counterparty for approval and coordination.',
  `transmission_charge_usd` DECIMAL(15,2) COMMENT 'The transmission service charge in US dollars for using the transmission system to deliver energy under this schedule. Based on OATT rates.',
  `created_by` STRING COMMENT 'The username or identifier of the system user who created this energy schedule record in the ETRM system.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_energy_schedule` PRIMARY KEY (`energy_schedule_id`)
)
USING DELTA
COMMENT 'Physical energy delivery schedule (e-Tag) submitted to ISO/RTO and counterparties for bilateral and market transactions. Captures schedule ID, source/sink PNodes, transmission path, scheduled MW by interval, e-Tag reference number, curtailment instructions, and schedule status (submitted, confirmed, curtailed, expired). Supports NAESB e-Tag compliance and real-time dispatch coordination. | CMM: CIM EnergyTransaction (close), IEC62325::InfEnergyScheduling.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'EnergySchedule',
  'cmm.cim.class' = 'EnergyTransaction',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC62325::InfEnergyScheduling',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.energy_schedule'
);

-- MarketSettlement  <<CIM Settlement : close>>
CREATE TABLE IF NOT EXISTS `trading`.`market_settlement` (
  `market_settlement_id` BIGINT NOT NULL COMMENT 'Unique identifier for the market settlement record. Primary key for all wholesale energy transaction settlements across ISO/RTO markets, bilateral OTC trades, PPA contracts, FTR congestion revenue, and capacity markets.',
  `contract_id` BIGINT COMMENT 'Reference to the underlying contract or agreement governing this settlement. Applicable for PPA settlements, bilateral contract settlements, and FTR holdings. Null for spot market settlements.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: ISO/RTO settlements must be allocated to cost centers for cost recovery tracking and variance analysis. Real business process: monthly settlement reconciliation requires cost center assignment for acc',
  `counterparty_id` BIGINT COMMENT 'Reference to the counterparty entity involved in the settlement. For ISO/RTO settlements, this is the ISO/RTO organization; for bilateral trades, this is the trading counterparty; for PPA settlements, this is the power purchase agreement counterparty.',
  `dr_event_id` BIGINT COMMENT 'Foreign key linking to demand.dr_event. Business justification: Market settlements reconcile DR event performance payments. Real business process: ISO settlement statements allocating energy and capacity payments for DR dispatch, requiring event linkage for paymen',
  `energy_price_id` BIGINT COMMENT 'Foreign key linking to forecast.energy_price. Business justification: Settlement price reconciliation compares actual LMPs to forecasted prices for variance analysis and dispute resolution. Settlement analysts link settlements to the price forecasts used for budgeting a',
  `ftr_holding_id` BIGINT COMMENT 'FK to trading.ftr_holding.ftr_holding_id — FTR congestion revenue settlements (now in unified market_settlement) must link to the FTR holding for P&L calculation against acquisition cost.',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Every settlement transaction must post to a specific GL account for financial statement preparation. Real business process: daily settlement posting to general ledger requires GL account mapping for e',
  `market_award_id` BIGINT COMMENT 'FK to trading.market_award.market_award_id — Settlements reconcile awarded quantities against actuals. The settlement→award FK is required for the settlement reconciliation process and dispute resolution.',
  `market_bid_id` BIGINT COMMENT 'FK to trading.market_bid.market_bid_id — ISO/RTO market settlements must link to the originating market bid/award for settlement verification and dispute resolution. Essential for DAM/RTM settlement reconciliation.',
  `market_participant_id` BIGINT COMMENT 'The unique identifier assigned by the ISO/RTO to the market participant (scheduling coordinator or qualified scheduling entity) for this settlement. Used for ISO/RTO market reconciliation.',
  `market_trade_id` BIGINT COMMENT 'FK to trading.trade.trade_id — Settlement records must reference the trade they settle for reconciliation, P&L tracking, and audit trail. This is the core settlement→trade linkage in any ETRM system.',
  `ppa_id` BIGINT COMMENT 'FK to trading.ppa.ppa_id — PPA settlements (now unified in market_settlement) must link back to the PPA contract for delivery reconciliation and invoice generation.',
  `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Market settlements impact profit center P&L and must be tracked for segment reporting. Real business process: FERC Form 1 and state regulatory filings require profit center-level settlement data for j',
  `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: Market settlements with disputes or unusual charges trigger regulatory filings including FERC complaints, tariff interpretation requests, and cost recovery proceedings. Regulatory affairs references s',
  `trade_id` BIGINT COMMENT 'FK to trading.trade.trade_id — Settlements must trace back to the originating trade for reconciliation, dispute resolution, and audit trail. This is the fundamental transaction→settlement link.',
  `transaction_trade_id` BIGINT COMMENT 'Reference to the underlying energy transaction or trade record in the ETRM system that generated this settlement. Links settlement to the originating position or deal.',
  `vendor_id` BIGINT COMMENT 'Foreign key linking to supply.vendor. Business justification: ISO/RTO market settlements with generation owners or transmission providers who are registered vendors. Links market clearing charges/payments to vendor master for accounts payable processing and cash',
  `accounting_period` STRING COMMENT 'The financial accounting period (e.g., 2024-Q1, 2024-03) to which this settlement is allocated for financial reporting purposes. Used for revenue recognition and accounts receivable/payable posting.',
  `ancillary_service_charge_amount` DECIMAL(18,2) COMMENT 'The total charges for ancillary services procured in conjunction with the energy settlement. Includes regulation, spinning reserve, non-spinning reserve, and voltage support charges as applicable.',
  `capacity_charge_amount` DECIMAL(18,2) COMMENT 'Charges for capacity obligations or capacity market settlements. Represents the cost of securing generation capacity to meet future demand, separate from energy commodity charges.',
  `congestion_charge_amount` DECIMAL(18,2) COMMENT 'The congestion component of the locational marginal price settlement. Represents the cost of transmission congestion between the generation source and the delivery point. May be positive (charge) or negative (credit).',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this settlement record was first created in the system. Audit trail field for data lineage and compliance.',
  `cumulative_profit_loss_amount` DECIMAL(18,2) COMMENT 'The running cumulative profit or loss for this trading position or contract through this settlement date. Calculated by summing all settlement amounts for the position from inception to current settlement. Used for mark-to-market valuation and position tracking.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this settlement. Typically USD for US markets or CAD for Canadian markets. Valid values: USD|CAD.',
  `delivery_end_timestamp` TIMESTAMP COMMENT 'The precise date and time when energy delivery ended for the transaction being settled. For interval-based settlements, this marks the end of the settlement interval.',
  `delivery_start_timestamp` TIMESTAMP COMMENT 'The precise date and time when energy delivery began for the transaction being settled. For interval-based settlements, this marks the beginning of the settlement interval.',
  `dispute_flag` BOOLEAN COMMENT 'Boolean indicator of whether this settlement is currently under dispute. True indicates an active dispute has been raised by either party; false indicates no dispute.',
  `dispute_raised_date` DATE COMMENT 'The date on which the settlement dispute was formally raised. Null if no dispute exists.',
  `dispute_reason` STRING COMMENT 'Free-text description of the reason for the settlement dispute. Captures the business justification for challenging the settlement calculation or amount. Null if no dispute exists.',
  `dispute_resolution_date` DATE COMMENT 'The date on which the settlement dispute was resolved and closed. Null if dispute is still open or if no dispute exists.',
  `energy_charge_amount` DECIMAL(18,2) COMMENT 'The base energy charge calculated as settlement quantity multiplied by settlement price. Represents the core energy commodity cost before adjustments for ancillary services, congestion, losses, or uplift.',
  `ftr_congestion_revenue_amount` DECIMAL(18,2) COMMENT 'Revenue earned or owed from financial transmission right holdings based on the locational marginal price differential between source and sink nodes. Hedges congestion cost exposure in ISO/RTO markets.',
  `gl_posting_date` DATE COMMENT 'The date on which this settlement was posted to the general ledger. Null if GL posting has not yet occurred.',
  `gl_posting_flag` BOOLEAN COMMENT 'Boolean indicator of whether this settlement has been posted to the general ledger in the ERP system. True indicates GL posting is complete; false indicates posting is pending.',
  `imbalance_charge_amount` DECIMAL(18,2) COMMENT 'Charges or credits resulting from deviations between scheduled and actual energy delivery. Calculated as the difference between day-ahead schedule and real-time delivery, settled at real-time market prices.',
  `iso_rto_code` STRING COMMENT 'The code identifying the ISO or RTO market in which the settlement occurred. Applicable only for ISO/RTO market settlements; null for bilateral and PPA settlements. Reference-value candidates: CAISO|ERCOT|MISO|PJM|NYISO|ISO-NE|SPP|AESO.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this settlement record was most recently updated. Audit trail field for change tracking and compliance.',
  `loss_charge_amount` DECIMAL(18,2) COMMENT 'The marginal loss component of the locational marginal price settlement. Represents the cost of electrical losses incurred during transmission from generation to load.',
  `modified_by_user` STRING COMMENT 'The user identifier or system account that last modified this settlement record. Used for audit trail and accountability.',
  `netting_adjustment_amount` DECIMAL(18,2) COMMENT 'Adjustments applied during settlement netting process to reconcile multiple transactions, correct billing errors, or apply contractual netting provisions. May be positive or negative.',
  `payment_date` DATE COMMENT 'The actual date on which payment was made or received for this settlement. Null if payment is still pending.',
  `payment_due_date` DATE COMMENT 'The date by which payment for this settlement must be made or received. Determined by ISO/RTO market rules or bilateral contract payment terms.',
  `payment_status` STRING COMMENT 'Current status of the payment obligation for this settlement: pending processing, scheduled for payment, payment completed, payment received from counterparty, overdue past due date, or defaulted by counterparty. Valid values: pending|scheduled|paid|received|overdue|defaulted.',
  `pnode_code` STRING COMMENT 'The pricing node or location identifier where energy was delivered or received. Used for locational marginal pricing (LMP) settlements in ISO/RTO markets.',
  `rec_price_per_certificate` DECIMAL(18,4) COMMENT 'The unit price in dollars per renewable energy certificate. Applicable when RECs are bundled with energy settlement or traded separately. Null for non-renewable settlements.',
  `rec_quantity` DECIMAL(18,3) COMMENT 'The quantity of renewable energy certificates associated with this settlement, measured in MWh-equivalent. Applicable for renewable energy transactions and PPA settlements with REC bundling. Null for non-renewable settlements.',
  `settlement_date` DATE COMMENT 'The business date on which the settlement was calculated and finalized. Represents the principal event timestamp for this transaction header.',
  `settlement_interval_minutes` INT COMMENT 'The duration of the settlement interval in minutes. Typically 5 minutes for real-time market settlements, 60 minutes for day-ahead market settlements, or custom intervals for bilateral contracts.',
  `settlement_price_per_mwh` DECIMAL(18,4) COMMENT 'The unit price in dollars per megawatt-hour at which the energy quantity is settled. For ISO/RTO markets, this is the locational marginal price (LMP); for bilateral trades, this is the contract price.',
  `settlement_quantity_mwh` DECIMAL(18,3) COMMENT 'The total quantity of energy settled in megawatt-hours (MWh). Represents the volume of energy delivered or received for which financial settlement is being calculated.',
  `settlement_reference_number` STRING COMMENT 'External business identifier for the settlement. May be ISO statement reference number, counterparty invoice number, or internal settlement batch identifier depending on settlement type.',
  `settlement_status` STRING COMMENT 'Current lifecycle state of the settlement record in the settlement workflow: draft calculation, pending approval, approved for payment, invoiced to/from counterparty, payment completed, under dispute, dispute resolved, or cancelled. Reference-value candidates: draft|pending_approval|approved|invoiced|paid|disputed|resolved|cancelled.',
  `settlement_type` STRING COMMENT 'Discriminator identifying the category of wholesale energy transaction being settled: ISO/RTO real-time market energy, ISO/RTO day-ahead market energy, ISO/RTO ancillary services, bilateral over-the-counter trade, power purchase agreement contract, financial transmission right congestion revenue, or capacity market settlement. Reference-value candidates: iso_rtm_energy|iso_dam_energy|iso_ancillary_service|bilateral_otc|ppa_contract|ftr_congestion_revenue|capacity_market.',
  `total_settlement_amount` DECIMAL(18,2) COMMENT 'The net total settlement amount in US dollars after summing all charge components: energy, ancillary services, congestion, losses, uplift, imbalance, capacity, FTR revenue, and netting adjustments. Positive values indicate amounts owed to the utility; negative values indicate amounts payable.',
  `trade_date` DATE COMMENT 'The date on which the underlying energy transaction or trade was executed. For ISO/RTO markets, this is the operating day; for bilateral trades, this is the trade execution date.',
  `uplift_charge_amount` DECIMAL(18,2) COMMENT 'Additional charges allocated by the ISO/RTO to recover costs not captured in the energy and ancillary service prices. Includes make-whole payments, reliability unit commitment costs, and other out-of-market payments.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_market_settlement` PRIMARY KEY (`market_settlement_id`)
)
USING DELTA
COMMENT 'Unified settlement record for all wholesale energy transaction types within the trading domain: ISO/RTO market settlements (DAM/RTM energy and ancillary services), bilateral OTC trade settlements, PPA contract settlements, FTR congestion revenue settlements, and capacity market settlements. Captures settlement type discriminator, settlement amount ($), quantity (MWh), settlement price, energy imbalance charges, ancillary service charges, congestion charges, loss charges, uplift charges, netting adjustments, payment due date, payment status, settlement interval, ISO statement reference or counterparty invoice reference, dispute status, dispute resolution date, and cumulative P&L tracking. For FTR settlements: congestion revenue earned/owed based on LMP differential, settlement period, and P&L against acquisition cost. Reconciled in OpenLink Endur and feeds accounts receivable/payable. SSOT for all settlement data in the trading domain. Supports FERC market reporting, bilateral contract compliance, and settlement dispute management. | CMM: CIM Settlement (close), IEC62325::MarketResults.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MarketSettlement',
  'cmm.cim.class' = 'Settlement',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC62325::MarketResults',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.market_settlement'
);

-- Counterparty  <<CIM MarketParticipant : close>>
CREATE TABLE IF NOT EXISTS `trading`.`counterparty` (
  `counterparty_id` BIGINT NOT NULL COMMENT 'Unique identifier for the trading counterparty. Primary key for the counterparty master record.',
  `address_line_1` STRING COMMENT 'First line of the counterparty\'s registered business address, typically street number and name.',
  `address_line_2` STRING COMMENT 'Second line of the counterparty\'s registered business address, typically suite or building information.',
  `approval_date` DATE COMMENT 'Date on which the counterparty was approved for trading by credit and legal departments.',
  `city` STRING COMMENT 'City name of the counterparty\'s registered business address.',
  `counterparty_status` STRING COMMENT 'Current operational status of the counterparty relationship indicating whether trading is permitted. Valid values: active|inactive|suspended|pending_approval|terminated.',
  `counterparty_type` STRING COMMENT 'Classification of the counterparty based on their primary business function in energy markets. Valid values: generator|marketer|utility|financial_institution|municipality|cooperative.',
  `country_code` STRING COMMENT 'Three-letter ISO country code for the counterparty\'s primary country of operation. Valid values: USA|CAN|MEX.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the counterparty record was first created in the system.',
  `credit_rating_date` DATE COMMENT 'The date on which the current credit rating became effective. Used to track rating staleness and trigger re-evaluation.',
  `credit_rating_fitch` STRING COMMENT 'Current long-term issuer credit rating assigned by Fitch Ratings. Used for credit risk assessment and collateral determination. Pattern: AAA|AA\\+|AA|AA-|A\\+|A|A-|BBB\\+|BBB|BBB-|BB\\+|BB|BB-|B\\+|B|B-|CCC|CC|C|RD|D|NR.',
  `credit_rating_moodys` STRING COMMENT 'Current long-term issuer credit rating assigned by Moody\'s Investors Service. Used for credit risk assessment and collateral determination. Reference-value candidates: Aaa|Aa1|Aa2|Aa3|A1|A2|A3|Baa1|Baa2|Baa3|Ba1|Ba2|Ba3|B1|B2|B3|Caa1|Caa2|Caa3|Ca|C|NR.',
  `credit_rating_sp` STRING COMMENT 'Current long-term issuer credit rating assigned by Standard & Poor\'s rating agency. Used for credit risk assessment and collateral determination. Pattern: AAA|AA\\+|AA|AA-|A\\+|A|A-|BBB\\+|BBB|BBB-|BB\\+|BB|BB-|B\\+|B|B-|CCC\\+|CCC|CCC-|CC|C|D|NR.',
  `csa_effective_date` DATE COMMENT 'The date on which the Credit Support Annex with this counterparty became effective.',
  `csa_reference` STRING COMMENT 'Reference number or identifier for the Credit Support Annex governing collateral posting requirements for this counterparty.',
  `duns_number` STRING COMMENT 'Nine-digit unique identifier assigned by Dun & Bradstreet for business entity identification and credit assessment. Pattern: ^[0-9]{9}$.',
  `eic_code` STRING COMMENT 'Standardized 16-character code for identifying parties in international energy markets, particularly for cross-border transactions. Pattern: ^[0-9]{2}[A-Z0-9]{14}[A-Z]{1}$.',
  `ferc_eqr_counterparty_code` STRING COMMENT 'FERC-assigned identifier for counterparty used in Electric Quarterly Report filings for wholesale power transactions.',
  `internal_credit_limit` DECIMAL(18,2) COMMENT 'Maximum credit exposure amount in USD that the utility is willing to extend to this counterparty based on internal credit policy.',
  `isda_effective_date` DATE COMMENT 'The date on which the ISDA Master Agreement with this counterparty became effective.',
  `isda_master_agreement_reference` STRING COMMENT 'Reference number or identifier for the ISDA Master Agreement governing derivative transactions with this counterparty.',
  `iso_rto_participant_flag` BOOLEAN COMMENT 'Indicates whether the counterparty is a registered market participant in one or more ISO/RTO markets.',
  `jurisdiction` STRING COMMENT 'The primary legal jurisdiction or state/province where the counterparty is registered and operates, governing contract law and dispute resolution.',
  `last_review_date` DATE COMMENT 'Date of the most recent periodic credit review for this counterparty, used to trigger annual re-evaluation.',
  `legal_entity_name` STRING COMMENT 'The full legal name of the counterparty entity as registered with regulatory authorities. Used for contract execution and regulatory reporting.',
  `nerc_entity_code` STRING COMMENT 'NERC-assigned unique identifier for registered entities in the bulk electric system.',
  `nerc_registered_entity_flag` BOOLEAN COMMENT 'Indicates whether the counterparty is registered with NERC as a functional entity subject to reliability standards.',
  `netting_agreement_flag` BOOLEAN COMMENT 'Indicates whether a payment netting agreement is in place with this counterparty, allowing offsetting of payables and receivables.',
  `next_review_date` DATE COMMENT 'Scheduled date for the next periodic credit review of this counterparty.',
  `notes` STRING COMMENT 'Free-form text field for capturing additional information, special instructions, or historical context about the counterparty relationship.',
  `parent_company_duns` STRING COMMENT 'DUNS number of the parent company for hierarchical credit risk aggregation. Pattern: ^[0-9]{9}$.',
  `parent_company_name` STRING COMMENT 'Legal name of the ultimate parent company or holding company for credit aggregation and consolidated risk assessment.',
  `postal_code` STRING COMMENT 'Postal or ZIP code of the counterparty\'s registered business address.',
  `primary_contact_email` STRING COMMENT 'Email address of the primary business contact for trading communications and confirmations. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `primary_contact_name` STRING COMMENT 'Full name of the primary business contact for trading operations and contract administration.',
  `primary_contact_phone` STRING COMMENT 'Business phone number of the primary contact for urgent trading matters and operational coordination.',
  `short_name` STRING COMMENT 'Abbreviated or trading name used for operational reference and system displays.',
  `state_province` STRING COMMENT 'State or province code of the counterparty\'s registered business address.',
  `tax_identification_number` STRING COMMENT 'Federal tax identification number (EIN or SSN) for the counterparty entity used for tax reporting and 1099 generation.',
  `termination_date` DATE COMMENT 'Date on which the trading relationship with the counterparty was terminated or suspended.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the counterparty record was last modified.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_counterparty` PRIMARY KEY (`counterparty_id`)
)
USING DELTA
COMMENT 'Trading counterparty master record for all entities with whom the utility executes wholesale energy trades, PPAs, capacity transactions, or ancillary service agreements. Captures legal entity name, DUNS number, EIC code (for international), FERC EQR counterparty ID, credit rating (S&P/Moody\'s/Fitch), credit rating date, jurisdiction, ISDA master agreement reference, CSA (Credit Support Annex) reference, netting agreement flag, and counterparty type (generator, marketer, utility, financial institution, municipality, cooperative). SSOT for counterparty identity in the trading domain. | CMM: CIM MarketParticipant (close), IEC62325::MarketCommon.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'Counterparty',
  'cmm.cim.class' = 'MarketParticipant',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC62325::MarketCommon',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.counterparty'
);

-- CreditExposure  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `trading`.`credit_exposure` (
  `credit_exposure_id` BIGINT NOT NULL COMMENT 'Unique identifier for the counterparty credit exposure record.',
  `audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: Credit exposure calculations are audited for compliance with credit policies and FERC credit risk reporting requirements. Internal and external auditors test credit exposure methodology, limit complia',
  `counterparty_id` BIGINT COMMENT 'FK to trading.counterparty.counterparty_id — Credit exposure is calculated per counterparty. This is a fundamental master-detail relationship required for credit risk management and margin call processing.',
  `credit_counterparty_id` BIGINT COMMENT 'Identifier of the trading counterparty for which credit exposure is being tracked.',
  `credit_for_counterparty` BIGINT COMMENT 'FK to trading.counterparty.counterparty_id — Credit exposure is calculated per counterparty. Without this FK, exposure records cannot be attributed to the correct counterparty for credit limit monitoring and margin call management.',
  `employee_id` BIGINT COMMENT 'Identifier of the risk manager responsible for monitoring and managing this counterparty credit exposure.',
  `netting_agreement_id` BIGINT COMMENT 'Identifier of the master netting agreement governing the offsetting of exposures with this counterparty.',
  `to_counterparty_id` BIGINT COMMENT 'FK to trading.counterparty.counterparty_id — Credit exposure is calculated per counterparty. This FK is essential for credit limit monitoring, margin call triggers, and FERC credit reporting.',
  `trading_desk_id` BIGINT COMMENT 'Identifier of the trading desk or business unit responsible for transactions with this counterparty.',
  `collateral_posted_amount` DECIMAL(18,2) COMMENT 'Total value of collateral posted by the counterparty to secure credit exposure, including cash and letters of credit.',
  `collateral_type` STRING COMMENT 'Type of collateral instrument posted by the counterparty to mitigate credit risk. Valid values: cash|letter_of_credit|parent_guarantee|surety_bond|other.',
  `comments` STRING COMMENT 'Free-text field for risk management notes, special conditions, or explanations related to this credit exposure record.',
  `confidence_level_pct` DECIMAL(5,2) COMMENT 'Statistical confidence level used in the potential future exposure calculation, typically 95% or 99%.',
  `counterparty_credit_rating` STRING COMMENT 'External credit rating assigned to the counterparty by recognized rating agencies such as Moody\'s, S&P, or Fitch.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this credit exposure record was first created in the system.',
  `credit_breach_flag` BOOLEAN COMMENT 'Indicator of whether the counterparty has breached their approved credit limit, triggering risk management actions.',
  `credit_limit_amount` DECIMAL(18,2) COMMENT 'Maximum credit limit approved for this counterparty, representing the threshold beyond which additional trading is restricted.',
  `credit_limit_utilization_pct` DECIMAL(5,2) COMMENT 'Percentage of the approved credit limit currently utilized, calculated as net exposure divided by credit limit.',
  `exposure_as_of_date` DATE COMMENT 'The business date for which this credit exposure snapshot is calculated.',
  `exposure_calculation_method` STRING COMMENT 'Methodology used to calculate potential future exposure, such as Monte Carlo simulation, historical simulation, or variance-covariance approach. Valid values: current_exposure|peak_exposure|monte_carlo|historical_simulation|variance_covariance.',
  `exposure_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which the credit exposure is denominated. Pattern: ^[A-Z]{3}$.',
  `exposure_status` STRING COMMENT 'Current status of the credit exposure indicating the risk management posture for this counterparty. Valid values: normal|watch|breach|suspended|default.',
  `ferc_reporting_flag` BOOLEAN COMMENT 'Indicator of whether this credit exposure must be included in FERC regulatory credit risk reporting.',
  `internal_credit_score` INT COMMENT 'Internally calculated credit score for the counterparty based on proprietary risk assessment models.',
  `iso_rto_code` STRING COMMENT 'Code identifying the ISO or RTO market in which the counterparty trades, such as CAISO, ERCOT, PJM, MISO, NYISO, ISO-NE, or SPP.',
  `last_review_date` DATE COMMENT 'Date when the counterparty credit exposure was last reviewed by the credit risk management team.',
  `margin_call_due_date` DATE COMMENT 'Date by which the counterparty must satisfy the margin call by posting additional collateral.',
  `margin_call_issued_flag` BOOLEAN COMMENT 'Indicator of whether a margin call has been issued to the counterparty for this exposure date.',
  `margin_call_threshold_amount` DECIMAL(18,2) COMMENT 'Exposure threshold amount that triggers a margin call requiring the counterparty to post additional collateral.',
  `mtm_exposure_amount` DECIMAL(18,2) COMMENT 'Current mark-to-market exposure representing the replacement cost of all outstanding positions with this counterparty.',
  `net_exposure_amount` DECIMAL(18,2) COMMENT 'Net credit exposure after deducting collateral posted, representing the unsecured credit risk to the utility.',
  `netting_agreement_flag` BOOLEAN COMMENT 'Indicator of whether a master netting agreement is in place with the counterparty, allowing offsetting of positive and negative exposures.',
  `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review of the counterparty credit exposure.',
  `pfe_amount` DECIMAL(18,2) COMMENT 'Estimated potential future exposure representing the maximum expected credit exposure over the life of the transactions, calculated using statistical models and market volatility.',
  `rec_tracking_flag` BOOLEAN COMMENT 'Indicator of whether this exposure includes positions in renewable energy certificates requiring separate tracking for compliance.',
  `time_horizon_days` INT COMMENT 'Number of days over which the potential future exposure is projected, representing the expected liquidation period.',
  `total_exposure_amount` DECIMAL(18,2) COMMENT 'Total credit exposure calculated as the sum of mark-to-market exposure and potential future exposure before collateral adjustments.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this credit exposure record was last modified.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_credit_exposure` PRIMARY KEY (`credit_exposure_id`)
)
USING DELTA
COMMENT 'Counterparty credit exposure record tracking mark-to-market exposure, potential future exposure (PFE), credit limit, collateral posted, and net exposure for each trading counterparty. Captures exposure as of date, credit limit utilization percentage, margin call threshold, collateral type (cash, letter of credit), and credit breach flag. Supports credit risk management and FERC credit reporting obligations. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CreditExposure',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.credit_exposure'
);

-- FtrHolding  <<CIM CRR : close>>
CREATE TABLE IF NOT EXISTS `trading`.`ftr_holding` (
  `ftr_holding_id` BIGINT NOT NULL COMMENT 'Unique identifier for the FTR holding record. Primary key for the FTR holding entity representing a congestion hedging instrument acquired through ISO/RTO auctions.',
  `counterparty_id` BIGINT COMMENT 'Identifier for the counterparty in secondary market FTR transactions. For auction-acquired FTRs, this references the ISO/RTO as counterparty. For bilateral transfers, references the selling party.',
  `energy_price_id` BIGINT COMMENT 'Foreign key linking to forecast.energy_price. Business justification: FTR valuation depends on congestion price forecasts between source and sink nodes. Portfolio managers link FTR holdings to price forecasts to calculate expected congestion revenue, assess hedge effect',
  `hedge_strategy_id` BIGINT COMMENT 'Foreign key linking to trading.hedge_strategy. Business justification: FTR holdings are congestion hedging instruments that should be linked to the formal hedge_strategy that authorized their acquisition. The existing \'hedging_strategy\' STRING attribute is a denormalized',
  `portfolio_id` BIGINT COMMENT 'Identifier linking this FTR holding to a trading portfolio or book within the Energy Trading and Risk Management (ETRM) system. Used for position aggregation and risk reporting.',
  `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: FTR holdings and auction results are reported in FERC market power analyses and transmission rate cases. Regulatory affairs reports FTR positions in market-based rate triennial filings and transmissio',
  `sink_pnode_id` BIGINT COMMENT 'The ISO/RTO pricing node identifier representing the sink (withdrawal) point of the FTR path. Used to calculate Locational Marginal Price (LMP) differences for congestion revenue.',
  `source_pnode_id` BIGINT COMMENT 'The ISO/RTO pricing node identifier representing the source (injection) point of the FTR path. Used to calculate Locational Marginal Price (LMP) differences for congestion revenue.',
  `accounting_treatment` STRING COMMENT 'The financial accounting method applied to this FTR holding. Hedge accounting defers gains/losses to match hedged items; mark-to-market recognizes fair value changes immediately; accrual recognizes revenue as earned. Valid values: hedge_accounting|mark_to_market|accrual.',
  `accumulated_payout` DECIMAL(18,2) COMMENT 'The cumulative congestion revenue (or charge for obligations) in USD received from the ISO/RTO since the FTR became effective. Positive values indicate net revenue; negative values indicate net charges.',
  `acquisition_price_per_mw` DECIMAL(18,4) COMMENT 'The price paid per MW in the FTR auction to acquire this holding, expressed in USD per MW. Used to calculate total acquisition cost and evaluate hedging effectiveness.',
  `auction_date` DATE COMMENT 'The date on which the FTR auction was conducted and this holding was acquired. Critical for tracking acquisition timing and market conditions.',
  `auction_period` STRING COMMENT 'The time period identifier for which this FTR was auctioned, typically in format YYYY-MM or YYYY for annual auctions. Defines the delivery period for the hedging instrument.',
  `auction_type` STRING COMMENT 'Classification of the ISO/RTO auction through which this FTR was acquired. Annual and monthly are standard forward auctions; long-term covers multi-year; reconfiguration allows secondary market adjustments. Valid values: annual|monthly|long-term|reconfiguration.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this FTR holding record was first created in the ETRM system. Used for audit trails and data lineage tracking.',
  `credit_requirement_amount` DECIMAL(18,2) COMMENT 'The collateral or credit amount in USD required by the ISO/RTO to maintain this FTR position. Based on market exposure and counterparty credit rating.',
  `current_market_value` DECIMAL(18,2) COMMENT 'The current estimated market value in USD of this FTR holding based on recent auction clearing prices or secondary market transactions. Updated periodically for mark-to-market valuation.',
  `effective_end_date` DATE COMMENT 'The date when this FTR holding expires and stops accruing congestion revenue or charges. Marks the end of the delivery period.',
  `effective_start_date` DATE COMMENT 'The date when this FTR holding becomes effective and begins accruing congestion revenue or charges. Marks the beginning of the delivery period.',
  `ftr_class` STRING COMMENT 'Time-of-use classification defining when the FTR is effective. On-peak covers high-demand hours, off-peak covers low-demand hours, 24-hour covers all hours. Valid values: on-peak|off-peak|24-hour.',
  `ftr_contract_number` STRING COMMENT 'The externally-known unique contract identifier assigned by the ISO/RTO for this FTR holding. Used for market settlement reconciliation and regulatory reporting.',
  `ftr_in_book` BIGINT COMMENT 'FK to trading.trading_book.trading_book_id — FTR holdings are managed within trading books for P&L attribution and congestion hedging strategy tracking.',
  `ftr_sink_pnode` BIGINT COMMENT 'FK to trading.pnode.pnode_id — FTR holdings require both source and sink PNode references for congestion revenue calculation.',
  `ftr_source_pnode` BIGINT COMMENT 'FK to trading.pnode.pnode_id — FTR holdings define source and sink PNodes — the congestion path. Without PNode FKs, FTR valuation against LMP differentials is impossible.',
  `ftr_type` STRING COMMENT 'Classification of the FTR instrument. Obligation FTRs pay or charge based on congestion price differences; Option FTRs only pay when positive. Critical for risk management and hedging strategy. Valid values: obligation|option.',
  `hedge_effectiveness_ratio` DECIMAL(5,4) COMMENT 'A calculated metric (0 to 1) representing how effectively this FTR hedges the underlying congestion exposure. Values near 1 indicate highly effective hedges; values near 0 indicate poor correlation.',
  `holding_status` STRING COMMENT 'Current lifecycle status of the FTR holding. Active holdings are accruing revenue; expired holdings have passed their end date; transferred holdings have been sold or reassigned; terminated holdings were cancelled before expiration. Valid values: active|expired|transferred|terminated.',
  `iso_registration_reference` STRING COMMENT 'The ISO/RTO system reference number or registration ID linking this FTR holding to the market operators records. Used for settlement reconciliation and dispute resolution.',
  `iso_rto_code` STRING COMMENT 'The ISO or RTO market operator code where this FTR was acquired and is registered. Critical for market-specific settlement rules and reporting requirements. Reference-value candidates: CAISO|ERCOT|ISONE|MISO|NYISO|PJM|SPP.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this FTR holding record was most recently updated. Used for change tracking and audit compliance.',
  `last_settlement_date` DATE COMMENT 'The date of the most recent ISO/RTO settlement payment or charge for this FTR holding. Used to track payment timing and reconcile accumulated payouts.',
  `modified_by_user` STRING COMMENT 'The username or identifier of the person or system that last modified this FTR holding record. Used for audit trails and accountability.',
  `mw_quantity` DECIMAL(18,6) COMMENT 'The contracted capacity in megawatts for this FTR holding. Represents the hedging volume for congestion cost exposure between source and sink nodes.',
  `next_settlement_date` DATE COMMENT 'The expected date of the next ISO/RTO settlement payment or charge for this FTR holding. Used for cash flow forecasting and liquidity management.',
  `notes` STRING COMMENT 'Free-text field for additional comments, special conditions, or operational notes related to this FTR holding. Used for audit trails and business context.',
  `regulatory_reporting_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether this FTR holding must be included in regulatory filings to FERC, state PUCs, or other governing bodies. True indicates reportable position.',
  `risk_category` STRING COMMENT 'Internal risk classification for this FTR holding based on factors such as path volatility, counterparty credit, and portfolio concentration. Used for risk management and reporting. Valid values: low|medium|high|critical.',
  `settlement_frequency` STRING COMMENT 'The frequency at which the ISO/RTO settles and pays out congestion revenue for this FTR holding. Most ISOs settle monthly; some offer quarterly or annual options. Valid values: monthly|quarterly|annual.',
  `total_acquisition_cost` DECIMAL(18,2) COMMENT 'The total cost in USD paid to acquire this FTR holding, calculated as MW quantity multiplied by acquisition price per MW. Represents the upfront investment in the congestion hedge.',
  `transmission_path_description` STRING COMMENT 'A human-readable description of the transmission path covered by this FTR, typically including geographic or operational context (e.g., \'West Zone to East Zone\', \'Generator X to Load Center Y\').',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_ftr_holding` PRIMARY KEY (`ftr_holding_id`)
)
USING DELTA
COMMENT 'Financial Transmission Right (FTR) holding record representing the utility\'s congestion hedging instruments acquired through ISO/RTO FTR auctions. Captures FTR type (obligation/option), source PNode, sink PNode, MW quantity, auction period, acquisition price, current market value, and ISO registration reference. Used for congestion revenue management and hedging strategy. | CMM: CIM CRR (close), IEC62325::CongestionRevenueRights.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'FtrHolding',
  'cmm.cim.class' = 'CRR',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC62325::CongestionRevenueRights',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.ftr_holding'
);

-- RecHolding  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `trading`.`rec_holding` (
  `rec_holding_id` BIGINT NOT NULL COMMENT 'Unique identifier for the REC holding record. Primary key for the REC inventory and transaction ledger.',
  `compliance_rec_certificate_id` BIGINT COMMENT 'Foreign key linking to compliance.rec_certificate. Business justification: REC holdings in trading systems must reconcile with compliance REC certificates in registry systems. Compliance teams verify trading positions match registry certificates for RPS compliance reporting,',
  `counterparty_id` BIGINT COMMENT 'Unique identifier for the counterparty in the ETRM system. Links to the counterparty master for credit limit and settlement tracking.',
  `ppa_contract_id` BIGINT COMMENT 'Identifier of the PPA contract under which this REC was acquired, if applicable. Links the REC to the underlying bilateral power purchase agreement.',
  `renewable_rec_certificate_id` BIGINT COMMENT 'Foreign key linking to renewable.renewable_rec_certificate. Business justification: Links REC trading positions to physical certificates issued by renewable facilities. Essential for registry reconciliation, compliance reporting, and settlement validation. Removes denormalized facili',
  `acquisition_cost_usd` DECIMAL(18,2) COMMENT 'Total cost paid by the utility to acquire this REC holding, denominated in US dollars. Used for cost basis tracking and financial reporting.',
  `acquisition_date` DATE COMMENT 'Date when the utility acquired ownership of this REC. Used for cost basis tracking and inventory aging analysis.',
  `acquisition_type` STRING COMMENT 'Method by which the utility acquired this REC. Indicates whether the REC was purchased from a third party, generated by utility-owned assets, or transferred from another account. Valid values: purchase|self_generation|transfer_in|import|allocation.',
  `compliance_program` STRING COMMENT 'Type of compliance or voluntary program for which this REC is designated. Indicates whether the REC is used for mandatory RPS compliance, voluntary green power programs, or carbon offset initiatives. Valid values: state_rps|voluntary|green_e|carbon_offset|none.',
  `compliance_year` INT COMMENT 'Calendar year for which this REC is or was used to meet RPS compliance obligations. May differ from vintage year due to banking and forward compliance rules.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this REC holding record was first created in the system. Used for audit trail and data lineage tracking.',
  `etrm_deal_code` STRING COMMENT 'Unique deal identifier in the OpenLink Endur ETRM system. Links the REC holding to the trading deal for position management and risk reporting. Pattern: ^[A-Z0-9-]{6,30}$.',
  `expiration_date` DATE COMMENT 'Date when this REC expires and can no longer be used for compliance or sold. Based on registry rules and state-specific banking limitations.',
  `generation_date` DATE COMMENT 'Date when the renewable energy generation occurred. Used for vintage year determination and compliance tracking.',
  `green_e_certified_flag` BOOLEAN COMMENT 'Indicates whether this REC meets Green-e certification standards for voluntary renewable energy programs. Green-e certification requires additional eligibility criteria beyond basic RPS compliance.',
  `holding_status` STRING COMMENT 'Current lifecycle status of the REC holding. Indicates whether the REC is available for use, has been retired for compliance, sold to a counterparty, or is in a pending transaction state. Valid values: active|retired|sold|transferred|expired|pending.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this REC holding record was last updated. Used for change tracking and audit trail.',
  `notes` STRING COMMENT 'Free-text notes and comments related to this REC holding. Used for documenting special circumstances, compliance decisions, or transaction details.',
  `portfolio_name` STRING COMMENT 'Name of the trading portfolio or book to which this REC holding is assigned. Used for position aggregation and P&L reporting.',
  `quantity_mwh` DECIMAL(18,3) COMMENT 'Quantity of renewable energy represented by this REC holding, measured in megawatt-hours. One REC typically represents one MWh of renewable generation.',
  `registry_transaction_code` STRING COMMENT 'Unique transaction identifier assigned by the REC registry system for this transfer, retirement, or issuance. Provides audit trail linkage to the external registry. Pattern: ^[A-Z0-9-]{8,50}$.',
  `retirement_date` DATE COMMENT 'Date when this REC was retired in the registry system. Null if the REC has not been retired. Used for compliance period tracking and audit trail.',
  `retirement_reason` STRING COMMENT 'Business reason for retiring this REC. Provides audit trail for compliance filings and voluntary program tracking.',
  `retirement_status` STRING COMMENT 'Indicates whether and why this REC has been retired. Retired RECs cannot be sold or transferred and represent the final disposition of the environmental attribute. Valid values: not_retired|retired_compliance|retired_voluntary|retired_green_power|retired_carbon.',
  `rps_compliance_eligible_flag` BOOLEAN COMMENT 'Indicates whether this REC is eligible for use in meeting state RPS compliance obligations. Eligibility is determined by fuel type, vintage, generation location, and state-specific rules.',
  `rps_tier` STRING COMMENT 'RPS tier classification for this REC based on state-specific renewable energy portfolio standards. Different tiers have different compliance values and eligibility rules. Valid values: tier_1|tier_2|tier_3|not_eligible.',
  `settlement_date` DATE COMMENT 'Date when financial settlement for this REC transaction occurred. Used for cash flow tracking and accounts payable/receivable reconciliation.',
  `transaction_date` DATE COMMENT 'Date when the REC transaction was executed. Represents the business event timestamp for inventory movement and financial settlement.',
  `transaction_price_usd` DECIMAL(18,4) COMMENT 'Price per megawatt-hour for this REC transaction. Used for mark-to-market valuation, revenue recognition, and market price benchmarking.',
  `transaction_type` STRING COMMENT 'Type of transaction that created or modified this REC holding record. Tracks all movements in the REC inventory ledger. Reference-value candidates: purchase|sale|retirement|transfer_in|transfer_out|import|export.',
  `unit_cost_usd` DECIMAL(18,4) COMMENT 'Cost per megawatt-hour paid for this REC. Calculated as acquisition cost divided by quantity. Used for market pricing analysis and portfolio valuation.',
  `vintage_year` INT COMMENT 'Calendar year in which the renewable energy generation occurred that created this REC. Critical for RPS compliance eligibility and market valuation.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_rec_holding` PRIMARY KEY (`rec_holding_id`)
)
USING DELTA
COMMENT 'Renewable Energy Certificate (REC) inventory master and transaction ledger tracking the complete lifecycle of RECs acquired, generated, retired, sold, or transferred by the utility. Captures holding state: REC registry ID (WREGIS/NEPOOL-GIS/M-RETS/NC-RETS), vintage year, fuel type, generation facility, state of generation, RPS compliance eligibility, quantity (MWh), acquisition cost, current status, and retirement status. Tracks all transaction movements: transaction type (purchase, sale, retirement, transfer, import, export), quantity (MWh), transaction price, counterparty, registry transaction ID, compliance program (RPS, voluntary, green-e), retirement reason, and transaction timestamp. Supports WREGIS/NEPOOL-GIS reporting, RPS compliance filings, voluntary green power program tracking, and REC audit trail. SSOT for all REC inventory and movement within the trading domain. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'RecHolding',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.rec_holding'
);

-- RecTransaction  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `trading`.`rec_transaction` (
  `rec_transaction_id` BIGINT NOT NULL COMMENT 'Unique identifier for the REC transaction record. Primary key for the rec_transaction product.',
  `compliance_rec_certificate_id` BIGINT COMMENT 'Foreign key linking to compliance.rec_certificate. Business justification: REC transactions (purchases, sales, retirements) must reference specific compliance certificates being transferred. Essential audit trail from trading transaction to registry certificate retirement fo',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: REC transactions are allocated to cost centers for compliance cost tracking and RPS program accounting. Real business process: state RPS compliance reports require cost center-level REC transaction da',
  `counterparty_id` BIGINT COMMENT 'FK to trading.counterparty',
  `der_interconnection_point_id` BIGINT COMMENT 'Foreign key linking to distribution.der_interconnection_point. Business justification: REC transactions must track generation source facility. DER interconnection points identify the physical generation asset, essential for REC registry compliance, renewable attribute verification, and',
  `der_system_id` BIGINT COMMENT 'Foreign key linking to interconnection.der_system. Business justification: REC sale/purchase/retirement transactions require linking to originating DER facility for audit trail, eligibility verification, and compliance reporting. Enables tracking which interconnected systems',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: REC transactions must post to specific GL accounts for revenue recognition and inventory accounting. Real business process: monthly close requires REC sales/purchases to hit correct GL accounts for GA',
  `primary_rec_counterparty_account_id` BIGINT COMMENT 'Registry account identifier for the counterparty organization. This is the account number in the REC registry system (WREGIS, NEPOOL-GIS, etc.) from which RECs are received or to which RECs are sent.',
  `rec_holding_id` BIGINT COMMENT 'FK to trading.rec_holding.rec_holding_id — REC transactions (purchase, sale, retirement) modify REC holdings. This FK is required for inventory reconciliation and RPS compliance tracking.',
  `renewable_rec_certificate_id` BIGINT COMMENT 'Foreign key linking to renewable.renewable_rec_certificate. Business justification: Connects REC buy/sell transactions to underlying physical certificates for registry transfer validation, compliance tracking, and audit trails. Removes denormalized facility attributes now available t',
  `broker_name` STRING COMMENT 'Name of the broker or intermediary who facilitated the REC transaction, if applicable. Null for direct bilateral transactions or internal transfers.',
  `compliance_program` STRING COMMENT 'Name of the regulatory compliance program or voluntary program for which these RECs are intended. Examples: California RPS, Oregon RPS, Washington RPS, voluntary green power program, corporate sustainability commitment. May be null for speculative trading positions.',
  `compliance_year` INT COMMENT 'Calendar year for which these RECs will be applied toward compliance obligations or voluntary commitments. RECs are typically vintage-dated and must be used within specified timeframes per program rules.',
  `contract_reference` STRING COMMENT 'Reference number or identifier for the underlying contract or Power Purchase Agreement (PPA) associated with this REC transaction. Links the REC transaction to the commercial agreement. Null for spot market transactions.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this REC transaction record was first created in the internal system. Audit trail field for data lineage and compliance reporting.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the transaction amount. Typically USD for North American REC markets. Pattern: ^[A-Z]{3}$.',
  `delivery_method` STRING COMMENT 'Method by which the renewable energy and RECs were delivered. Bundled: RECs delivered with the physical electricity. Unbundled: RECs traded separately from electricity. Firmed and shaped: intermittent renewable energy firmed with conventional generation. Delivery method affects RPS compliance eligibility in many states. Valid values: bundled|unbundled|firmed_shaped.',
  `eligibility_flags` STRING COMMENT 'Comma-separated list of compliance program eligibility certifications for these RECs. Examples: CA_RPS_Tier1, OR_RPS_Bundled, WA_RPS_Eligible, Green-e_Certified. Programs have specific eligibility criteria based on fuel type, location, vintage, and delivery method.',
  `generation_end_date` DATE COMMENT 'End date of the generation period for the renewable energy represented by these RECs. Defines the vintage period along with generation_start_date.',
  `generation_start_date` DATE COMMENT 'Start date of the generation period for the renewable energy represented by these RECs. RECs are typically issued for monthly or quarterly generation periods.',
  `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this REC transaction record was last modified in the internal system. Audit trail field for change tracking and compliance reporting.',
  `notes` STRING COMMENT 'Free-text field for additional notes, comments, or special instructions related to the REC transaction. May include details about transaction purpose, special handling requirements, or reconciliation notes.',
  `rec_quantity_mwh` DECIMAL(18,3) COMMENT 'Quantity of RECs transferred in this transaction, measured in megawatt-hours (MWh). Each REC typically represents 1 MWh of renewable energy generation.',
  `registry_transaction_code` STRING COMMENT 'External transaction identifier assigned by the REC registry system (WREGIS, NEPOOL-GIS, M-RETS, NAR, etc.). This is the authoritative reference number for the transaction in the external registry. Pattern: ^[A-Z0-9-]{8,50}$.',
  `retirement_beneficiary` STRING COMMENT 'Name of the organization or program on whose behalf the RECs are being retired. For compliance retirements, this is typically the utility itself. For voluntary programs, this may be a customer or corporate partner. Null for non-retirement transactions.',
  `retirement_reason` STRING COMMENT 'Business reason for retiring the RECs, if transaction_type is retirement. Examples: RPS compliance obligation, voluntary green power program, corporate sustainability goal, customer green tariff fulfillment. Null for non-retirement transactions.',
  `settlement_date` DATE COMMENT 'Date when the REC transaction was fully settled and ownership transfer was completed in the registry. May differ from transaction_timestamp for multi-day settlement cycles.',
  `total_transaction_amount` DECIMAL(18,2) COMMENT 'Total monetary value of the REC transaction, calculated as rec_quantity_mwh multiplied by transaction_price_per_rec. Denominated in USD. Zero for non-monetary transactions (transfers, retirements without purchase).',
  `trade_confirmation_number` STRING COMMENT 'Confirmation number from the Energy Trading and Risk Management (ETRM) system (e.g., OpenLink Endur) that links this REC transaction to the trading deal. Used for reconciliation between registry transactions and trading positions.',
  `transaction_price_per_rec` DECIMAL(18,4) COMMENT 'Unit price paid or received per REC in this transaction, denominated in USD. For purchases this is the acquisition cost; for sales this is the revenue per REC. May be zero for internal transfers or retirements.',
  `transaction_status` STRING COMMENT 'Current lifecycle status of the REC transaction: pending (awaiting approval), approved (authorized but not yet settled), completed (fully executed and settled), rejected (denied by registry or counterparty), cancelled (withdrawn before completion), reversed (unwound after completion). Valid values: pending|approved|completed|rejected|cancelled|reversed.',
  `transaction_timestamp` TIMESTAMP COMMENT 'Date and time when the REC transaction was executed or recorded in the registry system. This is the authoritative business event timestamp for the transaction.',
  `transaction_type` STRING COMMENT 'Type of REC transaction: purchase (acquiring RECs from counterparty), sale (selling RECs to counterparty), transfer (internal account movement), retirement (permanent removal from circulation for compliance or voluntary use), import (receiving from another registry), export (sending to another registry). Valid values: purchase|sale|transfer|retirement|import|export.',
  `vintage_year` INT COMMENT 'Calendar year in which the renewable energy was generated. RECs are vintage-dated and many compliance programs have vintage eligibility windows (e.g., current year plus 2 prior years).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_rec_transaction` PRIMARY KEY (`rec_transaction_id`)
)
USING DELTA
COMMENT 'REC transfer and retirement transaction record capturing the movement of RECs between registry accounts. Captures transaction type (purchase, sale, retirement, transfer), quantity (MWh), transaction price, counterparty, registry transaction ID, compliance program (RPS, voluntary), retirement reason, and transaction timestamp. Supports WREGIS/NEPOOL-GIS reporting and RPS compliance filings. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'RecTransaction',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.rec_transaction'
);

-- AncillaryServiceAward  <<CIM AncillaryServiceClearing : close>>
CREATE TABLE IF NOT EXISTS `trading`.`ancillary_service_award` (
  `ancillary_service_award_id` BIGINT NOT NULL COMMENT 'Primary key for ancillary_service_award',
  `contract_id` BIGINT COMMENT 'Identifier of the bilateral contract or master agreement governing this ancillary service procurement. Null for ISO/RTO market procurements without underlying contracts.',
  `counterparty_id` BIGINT COMMENT 'Identifier of the counterparty providing the ancillary service in bilateral contracts. Null for ISO/RTO market procurements or self-supply arrangements.',
  `der_system_id` BIGINT COMMENT 'Identifier of the generation or demand response resource providing the ancillary service. May reference utility-owned assets or third-party resources registered with the ISO/RTO.',
  `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: Ancillary service procurement costs are reported in rate cases and cost recovery filings. Regulatory affairs justifies ancillary service costs in rate proceedings with specific procurement records, de',
  `scheduling_coordinator_id` BIGINT COMMENT 'Identifier of the scheduling coordinator responsible for submitting bids and managing settlements for this ancillary service. Relevant in ISO/RTO markets with SC intermediaries.',
  `settlement_statement_id` BIGINT COMMENT 'Reference to the ISO/RTO settlement statement or invoice that includes this ancillary service charge. Used for financial reconciliation and dispute management.',
  `actual_deployment_mw` DECIMAL(12,3) COMMENT 'Actual megawatts of ancillary service deployed or dispatched during the interval. May differ from procured capacity if the service was not called upon or only partially deployed.',
  `award_reference_number` STRING COMMENT 'External reference number assigned by the ISO/RTO or bilateral contract for this ancillary service award. Used for reconciliation with market settlement statements.',
  `award_status` STRING COMMENT 'Current lifecycle status of the ancillary service award. Tracks progression from initial award through confirmation, settlement, and any dispute resolution. Valid values: awarded|confirmed|settled|disputed|cancelled.',
  `cleared_price_per_mw` DECIMAL(12,4) COMMENT 'Market clearing price or contract price for the ancillary service, expressed in currency per megawatt per hour. Used to calculate total procurement cost.',
  `cost_allocation_category` STRING COMMENT 'Regulatory cost allocation category determining how the ancillary service cost is recovered through tariffs. Aligns with FERC and state PUC rate design principles. Valid values: transmission_tariff|distribution_tariff|generation_cost|wholesale_market.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this ancillary service procurement record was first created in the system. Supports audit trail and data lineage tracking.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this record. Typically USD for North American utilities. Valid values: USD|CAD|MXN.',
  `deployment_payment` DECIMAL(15,2) COMMENT 'Additional payment for actual deployment or dispatch of the ancillary service, separate from the capacity procurement cost. Applies when the ISO/RTO calls upon the resource to provide the service.',
  `ferc_account_code` STRING COMMENT 'FERC Uniform System of Accounts code for booking the ancillary service cost. Typically accounts 447 (Sales for Resale) or 565 (Transmission of Electricity by Others).',
  `ferc_reporting_category` STRING COMMENT 'FERC reporting category for this ancillary service transaction as required by Electric Quarterly Report (EQR) filing. Classifies the transaction for regulatory transparency.',
  `internal_notes` STRING COMMENT 'Free-text field for internal operational notes, exceptions, or special circumstances related to this ancillary service procurement. Not shared externally.',
  `iso_rto_code` STRING COMMENT 'Code identifying the Independent System Operator or Regional Transmission Organization market where the ancillary service was procured. Null for bilateral contracts outside organized markets. Reference-value candidates: CAISO|ERCOT|MISO|PJM|NYISO|ISO_NE|SPP.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this record was last updated. Tracks changes through the award lifecycle from initial award through settlement and any subsequent adjustments.',
  `market_interval_end` TIMESTAMP COMMENT 'End timestamp of the market interval or delivery period for which the ancillary service was procured. Defines the duration of service obligation.',
  `market_interval_start` TIMESTAMP COMMENT 'Start timestamp of the market interval or delivery period for which the ancillary service was procured. Typically aligned with ISO/RTO settlement intervals (5-minute, 15-minute, or hourly).',
  `performance_obligation_met` BOOLEAN COMMENT 'Indicates whether the resource successfully met its performance obligation during the service interval. False may trigger penalties or non-performance charges.',
  `pricing_node` STRING COMMENT 'Specific pricing node or location where the ancillary service was procured in nodal markets. Used for locational marginal pricing and congestion analysis.',
  `procured_capacity_mw` DECIMAL(12,3) COMMENT 'Quantity of ancillary service capacity procured, measured in megawatts. Represents the resource capability committed to provide the service during the market interval.',
  `procurement_method` STRING COMMENT 'Method by which the ancillary service was procured. Distinguishes between ISO/RTO market purchases, bilateral contracts with third parties, and self-supply from utility-owned resources. Valid values: iso_day_ahead_market|iso_real_time_market|bilateral_contract|self_supply|rto_capacity_market.',
  `regulatory_reporting_flag` BOOLEAN COMMENT 'Indicates whether this ancillary service procurement must be included in regulatory reports to FERC, state PUCs, or other governing bodies. True for transactions meeting reporting thresholds.',
  `service_type` STRING COMMENT 'Type of ancillary service procured to support grid reliability and stability. Includes regulation, reserves, and voltage support services as defined by NERC and ISO/RTO tariffs. Valid values: regulation_up|regulation_down|spinning_reserve|non_spinning_reserve|replacement_reserve|voltage_support.',
  `total_procurement_cost` DECIMAL(15,2) COMMENT 'Total cost of the ancillary service procurement for the market interval, calculated as procured capacity multiplied by cleared price and interval duration. Expressed in the utility\'s reporting currency.',
  `transmission_zone` STRING COMMENT 'Transmission zone or load zone where the ancillary service was procured. Reflects geographic pricing and reliability requirements within the ISO/RTO footprint.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_ancillary_service_award` PRIMARY KEY (`ancillary_service_award_id`)
)
USING DELTA
COMMENT 'Ancillary service procurement record capturing the utility\'s acquisition of grid support services through ISO/RTO markets or bilateral contracts. Captures service type, resource ID, procured MW, procurement price ($/MW-hr), market interval, ISO award reference, and cost allocation to transmission or distribution tariff. Supports FERC ancillary service cost reporting. | CMM: CIM AncillaryServiceClearing (close), IEC62325::MarketResults.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AncillaryServiceAward',
  'cmm.cim.class' = 'AncillaryServiceClearing',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC62325::MarketResults',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.ancillary_service_award'
);

-- TradingBook  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `trading`.`book` (
  `book_id` BIGINT NOT NULL COMMENT 'Unique identifier for the trading book within the Energy Trading and Risk Management (ETRM) system. Primary key.',
  `approver_employee_id` BIGINT COMMENT 'Identifier of the risk officer or executive who approved the establishment of this trading book and its risk limits.',
  `book_employee_id` BIGINT COMMENT 'Identifier of the trader or portfolio manager responsible for managing positions and P&L within this trading book.',
  `book_last_modified_by_user_employee_id` BIGINT COMMENT 'Identifier of the user who last modified this trading book record. Supports audit trail and change management requirements.',
  `compliance_sox_control_id` BIGINT COMMENT 'Foreign key linking to compliance.sox_control. Business justification: Trading books are subject to SOX controls for valuation, position limits, and P&L reporting. SOX control testing validates trading book mark-to-market processes, segregation of duties, and limit monit',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Trading books are assigned to cost centers for overhead allocation and budget tracking. Real business process: annual budgeting allocates trading desk operating costs to responsible cost centers for c',
  `legal_entity_id` BIGINT COMMENT 'Identifier of the legal entity under which trades in this book are executed. Critical for regulatory reporting, tax accounting, and counterparty credit agreements.',
  `market_participant_id` BIGINT COMMENT 'Unique identifier assigned by the ISO/RTO for this trading book\'s market participation. Used in day-ahead and real-time market bids, offers, and settlements. Pattern: ^[A-Z0-9]{4,20}$.',
  `trading_desk_id` BIGINT COMMENT 'FK to trading.trading_desk',
  `approval_date` DATE COMMENT 'Date on which the risk committee or authorized governance body approved the creation and risk limits of this trading book.',
  `book_code` STRING COMMENT 'Short alphanumeric code uniquely identifying the trading book for operational reference and reporting. Used in trade capture, position reporting, and regulatory filings. Pattern: ^[A-Z0-9_-]{2,20}$.',
  `book_name` STRING COMMENT 'Full descriptive name of the trading book used for display and business communication. Examples: \'West Region Physical Power\', \'Gas Hedging Portfolio\', \'REC Trading Desk\'.',
  `book_status` STRING COMMENT 'Current operational status of the trading book. Active books accept new trades; suspended books are temporarily inactive; closed books are archived; pending approval books await risk committee authorization. Valid values: active|suspended|closed|pending_approval.',
  `book_type` STRING COMMENT 'Classification of the trading book by its primary business purpose. Physical books manage delivery obligations; financial books manage price risk; hedging books offset exposure; proprietary books capture speculative positions; structured books manage complex deals; ancillary services books manage grid support products. Valid values: physical|financial|hedging|proprietary|structured|ancillary_services.',
  `business_unit_code` STRING COMMENT 'Code identifying the business unit or division that owns this trading book. Used for segment reporting and management accounting. Pattern: ^[A-Z0-9]{2,10}$.',
  `collateral_management_flag` BOOLEAN COMMENT 'Indicates whether this trading book requires active collateral management (margin calls, credit support annexes) for counterparty credit risk mitigation.',
  `commodity` STRING COMMENT 'Primary commodity or product traded within this book. Determines applicable market rules, settlement conventions, and regulatory reporting requirements. Reference-value candidates: power|natural_gas|coal|renewable_energy_credits|emissions_allowances|capacity|ancillary_services|fuel_oil.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this trading book record was first created in the ETRM system. Used for audit trails and data lineage.',
  `credit_limit_amount` DECIMAL(18,2) COMMENT 'Maximum aggregate credit exposure allowed across all counterparties for trades booked to this trading book, expressed in USD. Used for pre-trade credit checks.',
  `effective_date` DATE COMMENT 'Date on which this trading book became active and eligible to accept trades. Used for historical analysis and audit trails.',
  `emissions_allowance_registry_code` STRING COMMENT 'Identifier for the emissions allowance registry account (e.g., EPA CATR, RGGI COATS) associated with this trading book. Required for books trading carbon or NOx allowances. Pattern: ^[A-Z0-9_-]{2,20}$.',
  `ferc_reporting_category` STRING COMMENT 'Federal Energy Regulatory Commission reporting category for this trading book. Determines which FERC forms and schedules apply (e.g., FERC Form 552 for wholesale power, FERC Form 2 for utilities). Valid values: wholesale_power|natural_gas|transmission_rights|ancillary_services|exempt.',
  `hedge_accounting_designation` STRING COMMENT 'Accounting treatment designation under ASC 815 (Derivatives and Hedging). Determines whether mark-to-market gains/losses flow through earnings or other comprehensive income. Valid values: cash_flow_hedge|fair_value_hedge|net_investment_hedge|not_designated.',
  `internal_notes` STRING COMMENT 'Free-text field for internal operational notes, special instructions, or context about this trading book. Not visible to external parties or regulatory filings.',
  `iso_rto_code` STRING COMMENT 'Primary ISO or RTO market in which this trading book operates. Determines market rules, settlement procedures, and scheduling protocols. Non-ISO indicates bilateral or over-the-counter trading. Reference-value candidates: CAISO|ERCOT|MISO|PJM|NYISO|ISO-NE|SPP|non_iso.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this trading book record. Tracks changes to risk limits, status, or organizational assignments.',
  `master_netting_agreement_flag` BOOLEAN COMMENT 'Indicates whether trades in this book are subject to master netting agreements (e.g., ISDA, EEI) that allow offsetting of exposures across multiple transactions with the same counterparty.',
  `position_limit_quantity` DECIMAL(18,2) COMMENT 'Maximum net position quantity (long or short) allowed in this book, expressed in the commodity\'s standard unit of measure (MWh for power, MMBtu for gas). Enforces concentration risk controls.',
  `position_limit_uom` STRING COMMENT 'Unit of measure for the position limit quantity. Must align with the commodity type traded in this book. Valid values: MWh|MMBtu|tons|certificates|allowances.',
  `rec_tracking_system_code` STRING COMMENT 'Identifier for the REC tracking system registry account associated with this trading book (e.g., WREGIS, M-RETS, PJM-GATS). Required for books trading renewable energy certificates. Pattern: ^[A-Z0-9_-]{2,20}$.',
  `region_code` STRING COMMENT 'Code representing the primary geographic region or market area for this trading book (e.g., WEST, EAST, ERCOT, MISO). Used for regional P&L reporting and market analysis. Pattern: ^[A-Z]{2,10}$.',
  `risk_limit_var` DECIMAL(18,2) COMMENT 'Maximum allowable Value at Risk for this trading book, expressed in USD. Represents the risk appetite approved by the risk committee. Breaches trigger escalation and position reduction requirements.',
  `scheduling_coordinator_flag` BOOLEAN COMMENT 'Indicates whether this trading book acts as a Scheduling Coordinator (SC) responsible for submitting schedules and bids to the ISO/RTO on behalf of generation or load resources.',
  `settlement_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for financial settlements of trades in this book. Typically USD for North American energy markets. Pattern: ^[A-Z]{3}$.',
  `termination_date` DATE COMMENT 'Date on which this trading book was closed or deactivated. Null for active books. Used for historical reporting and compliance retention.',
  `valuation_method` STRING COMMENT 'Method used to value positions in this trading book for financial reporting. Mark-to-market uses observable market prices; mark-to-model uses pricing models for illiquid products; accrual recognizes value at settlement. Valid values: mark_to_market|mark_to_model|accrual|lower_of_cost_or_market.',
  `var_confidence_level` DECIMAL(5,2) COMMENT 'Statistical confidence level used for VaR calculation, typically 95% or 99%. Defines the probability threshold for the risk limit.',
  `var_time_horizon_days` INT COMMENT 'Time horizon in days over which VaR is calculated, typically 1 day for daily risk monitoring or 10 days for regulatory capital calculations.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_book` PRIMARY KEY (`book_id`)
)
USING DELTA
COMMENT 'Trading book master record defining the organizational unit within the ETRM system (OpenLink Endur) used to aggregate and manage related trades for P&L reporting, risk limits, and regulatory reporting. Captures book name, book type (physical, financial, hedging, proprietary), commodity, responsible trader/desk, risk limit (VaR), and FERC reporting category. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'TradingBook',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.book'
);

-- FercEqrFiling  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `trading`.`ferc_eqr_filing` (
  `ferc_eqr_filing_id` BIGINT NOT NULL COMMENT 'Unique identifier for the FERC EQR filing record. Primary key for this entity.',
  `counterparty_id` BIGINT COMMENT 'FK to trading.counterparty.counterparty_id — FERC EQR requires counterparty identification for every reported transaction. FK ensures regulatory reporting accuracy.',
  `ferc_counterparty_id` BIGINT COMMENT 'Identifier of the counterparty involved in the wholesale energy transactions reported in this EQR filing.',
  `ferc_trade_id` BIGINT COMMENT 'FK to trading.trade.trade_id — FERC EQR filings report specific wholesale transactions. The filing must reference the underlying trades for audit trail and compliance verification.',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: FERC EQR filings must reference GL accounts for audit trail and reconciliation to financial statements. Real business process: external auditors trace EQR reported transactions to GL postings to verif',
  `irp_scenario_id` BIGINT COMMENT 'Foreign key linking to forecast.irp_scenario. Business justification: FERC EQR filings reference IRP scenarios to demonstrate that wholesale transactions align with prudent resource planning and regulatory commitments. Compliance officers link EQR filings to IRP scenari',
  `original_filing_ferc_eqr_filing_id` BIGINT COMMENT 'Reference to the original FERC EQR filing that this amendment corrects or updates. Null if this is an original filing.',
  `preparer_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: FERC EQR filings require employee accountability for regulatory compliance. Preparer_name/contact fields are denormalized employee data. New FK enables workforce qualification tracking (FERC filing ce',
  `primary_counterparty_id` BIGINT COMMENT 'FK to trading.counterparty.counterparty_id — FERC EQR requires counterparty identification for every reported transaction. This FK ensures regulatory reporting accuracy.',
  `primary_trade_id` BIGINT COMMENT 'FK to trading.trade.trade_id — FERC EQR filings report wholesale transactions — each filing line must trace to the originating trade for audit compliance and amendment tracking.',
  `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: FERC EQR filings are a specific type of regulatory filing that should reference the master filing record. Regulatory affairs maintains a comprehensive filing log including EQR submissions alongside ra',
  `trade_id` BIGINT COMMENT 'FK to trading.trade.trade_id — FERC EQR filings report specific wholesale transactions. The FK to trade ensures audit trail from regulatory filing back to source transaction.',
  `amendment_flag` BOOLEAN COMMENT 'Indicates whether this filing is an amendment to a previously submitted EQR filing (True) or an original filing (False).',
  `amendment_reason` STRING COMMENT 'Detailed explanation of why this amendment was filed, including the nature of corrections or updates made to the original submission.',
  `ancillary_services_included` BOOLEAN COMMENT 'Indicates whether the reported transactions include ancillary services procurement (e.g., regulation, spinning reserves, non-spinning reserves).',
  `attestation_flag` BOOLEAN COMMENT 'Indicates whether the authorized officer has attested to the accuracy and completeness of the information in this EQR filing, as required by FERC regulations.',
  `attestation_officer_name` STRING COMMENT 'The name of the authorized officer who attested to the accuracy and completeness of this EQR filing.',
  `attestation_officer_title` STRING COMMENT 'The job title of the authorized officer who attested to the accuracy and completeness of this EQR filing.',
  `attestation_timestamp` TIMESTAMP COMMENT 'The date and time when the authorized officer attested to the accuracy and completeness of this EQR filing.',
  `congestion_revenue_rights_flag` BOOLEAN COMMENT 'Indicates whether the reported transactions involve or are hedged by Congestion Revenue Rights or Financial Transmission Rights.',
  `contract_type` STRING COMMENT 'The type of contractual arrangement under which the reported transactions occurred (e.g., bilateral contract, ISO/RTO market participation, power purchase agreement). Valid values: bilateral|iso_rto_market|ppa|tolling|other.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this EQR filing record was first created in the system.',
  `currency_code` STRING COMMENT 'The ISO 4217 three-letter currency code for all monetary values in this filing. Typically USD for FERC EQR filings. Valid values: USD.',
  `data_extraction_timestamp` TIMESTAMP COMMENT 'The date and time when the transaction data was extracted from the source ETRM system for preparation of this EQR filing.',
  `delivery_point_count` INT COMMENT 'The number of distinct delivery points or pricing nodes involved in the transactions reported in this EQR filing.',
  `ferc_acceptance_date` DATE COMMENT 'The date on which FERC officially accepted the EQR filing as complete and compliant.',
  `ferc_confirmation_number` STRING COMMENT 'The confirmation number issued by FERC upon successful receipt of the EQR filing. Serves as proof of submission and regulatory acknowledgment.',
  `filing_comments` STRING COMMENT 'Additional comments or explanatory notes provided by the reporting entity to clarify or contextualize the information in this EQR filing.',
  `filing_number` STRING COMMENT 'The official FERC-assigned filing number for this EQR submission. Serves as the external business identifier for regulatory tracking and correspondence.',
  `filing_quarter` INT COMMENT 'The calendar quarter for which this EQR filing reports transactions (1=Q1, 2=Q2, 3=Q3, 4=Q4).',
  `filing_status` STRING COMMENT 'Current lifecycle status of the EQR filing in the regulatory submission workflow. Valid values: draft|submitted|accepted|rejected|amended|withdrawn.',
  `filing_year` INT COMMENT 'The calendar year for which this EQR filing reports transactions.',
  `ftr_quantity` DECIMAL(18,3) COMMENT 'The total quantity of Financial Transmission Rights or Congestion Revenue Rights associated with the reported transactions, measured in megawatts.',
  `iso_rto_code` STRING COMMENT 'The code identifying the ISO or RTO market in which the reported transactions occurred (e.g., CAISO, PJM, ERCOT, MISO, NYISO, ISO-NE, SPP).',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this EQR filing record was last updated or modified in the system.',
  `market_type` STRING COMMENT 'The type of wholesale energy market in which the reported transactions were executed (e.g., day-ahead market, real-time market, bilateral market, ancillary services market). Valid values: day_ahead|real_time|bilateral|ancillary_services.',
  `rec_quantity` DECIMAL(18,3) COMMENT 'The total quantity of Renewable Energy Certificates associated with the transactions reported in this EQR filing, if applicable.',
  `rec_tracking_system` STRING COMMENT 'The name of the REC tracking system or registry used to track renewable energy certificates associated with the reported transactions (e.g., WREGIS, M-RETS, NEPOOL GIS).',
  `reporting_entity_ferc_code` STRING COMMENT 'The FERC-assigned identifier for the utility or energy company submitting this EQR filing.',
  `reporting_entity_name` STRING COMMENT 'The legal name of the utility or energy company submitting this EQR filing to FERC.',
  `source_system` STRING COMMENT 'The name of the Energy Trading and Risk Management (ETRM) system or other operational system from which the transaction data for this EQR filing was extracted (e.g., OpenLink Endur).',
  `submission_method` STRING COMMENT 'The method or channel used to submit the EQR filing to FERC (e.g., eFiling portal, paper submission, electronic batch upload). Valid values: eFiling|paper|electronic_batch|api.',
  `submission_timestamp` TIMESTAMP COMMENT 'The date and time when this EQR filing was officially submitted to FERC. Represents the principal business event timestamp for regulatory compliance tracking.',
  `total_quantity_mwh` DECIMAL(18,3) COMMENT 'The total volume of energy transacted and reported in this EQR filing, measured in megawatt-hours.',
  `total_transaction_value` DECIMAL(18,2) COMMENT 'The total monetary value of all wholesale energy transactions reported in this EQR filing, expressed in US dollars.',
  `transaction_category` STRING COMMENT 'Classification of the wholesale energy transactions reported in this filing by contract duration (long-term: >1 year, short-term: 1 day to 1 year, spot: same-day or next-day). Valid values: long_term|short_term|spot.',
  `validation_error_count` INT COMMENT 'The number of data quality validation errors identified during internal review of the EQR filing data.',
  `validation_notes` STRING COMMENT 'Detailed notes documenting any data quality issues, validation errors, or exceptions identified during internal review of the EQR filing data.',
  `validation_status` STRING COMMENT 'The status of internal data quality validation checks performed on the EQR filing data before submission to FERC. Valid values: pending|passed|failed|waived.',
  `weighted_average_price` DECIMAL(18,4) COMMENT 'The weighted average price per megawatt-hour for all transactions reported in this EQR filing, expressed in US dollars.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_ferc_eqr_filing` PRIMARY KEY (`ferc_eqr_filing_id`)
)
USING DELTA
COMMENT 'FERC Electric Quarterly Report (EQR) filing record capturing the utility\'s mandatory wholesale market transaction reporting to FERC. Captures filing period (quarter/year), transaction category (long-term, short-term, spot), counterparty, contract type, quantity (MWh), price ($/MWh), filing submission timestamp, FERC confirmation number, and amendment status. Supports FERC Order 2001 compliance. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'FercEqrFiling',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.ferc_eqr_filing'
);

-- HedgeStrategy  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `trading`.`hedge_strategy` (
  `hedge_strategy_id` BIGINT NOT NULL COMMENT 'Unique identifier for the hedge strategy record. Primary key.',
  `book_id` BIGINT COMMENT 'Identifier of the trading book in the ETRM system (OpenLink Endur) that executes trades under this hedge strategy.',
  `capex_project_id` BIGINT COMMENT 'Foreign key linking to finance.capex_project. Business justification: Hedging strategies for capital projects (construction cost hedges, fuel hedges for new generation) must link to projects for cost-of-capital tracking. Real business process: IRP filings require disclo',
  `compliance_sox_control_id` BIGINT COMMENT 'Foreign key linking to compliance.sox_control. Business justification: Hedge strategies designated for hedge accounting must be tested for effectiveness under SOX controls. Internal audit tests hedge effectiveness quarterly as part of SOX 404 financial reporting controls',
  `employee_id` BIGINT COMMENT 'Identifier of the employee or trader responsible for managing and executing this hedge strategy.',
  `energy_price_id` BIGINT COMMENT 'Foreign key linking to forecast.energy_price. Business justification: Hedge strategies are designed around price forecast scenarios. Risk managers link hedge strategies to price forecasts for hedge effectiveness testing (ASC 815), prospective/retrospective testing, and',
  `authorized_instruments` STRING COMMENT 'Comma-separated list of authorized derivative instruments that may be used to execute this hedge strategy (e.g., forwards, futures, swaps, options, collars).',
  `board_approval_date` DATE COMMENT 'Date on which the board of directors approved this hedge strategy.',
  `board_resolution_reference` STRING COMMENT 'Reference number or identifier of the board resolution that authorized this hedge strategy.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this hedge strategy record was first created in the system.',
  `cvar_target_usd` DECIMAL(18,2) COMMENT 'Target Conditional Value at Risk (CVaR) or Expected Shortfall limit in USD for tail risk management.',
  `dedesignation_date` DATE COMMENT 'Date on which the hedge accounting designation was terminated or de-designated, if applicable.',
  `dedesignation_reason` STRING COMMENT 'Explanation of why the hedge accounting designation was terminated.',
  `dedesignation_trigger_conditions` STRING COMMENT 'Description of conditions that would trigger de-designation of the hedge accounting relationship (e.g., effectiveness falls outside 80-125%, forecasted transaction no longer probable).',
  `delivery_period_end` DATE COMMENT 'End date of the delivery period covered by this hedge strategy.',
  `delivery_period_start` DATE COMMENT 'Start date of the delivery period covered by this hedge strategy.',
  `effective_end_date` DATE COMMENT 'Date on which this hedge strategy is scheduled to end or was terminated.',
  `effective_start_date` DATE COMMENT 'Date on which this hedge strategy became effective and operational.',
  `effectiveness_test_method` STRING COMMENT 'Method used to assess hedge effectiveness: dollar-offset, regression analysis, critical terms match, or VaR reduction. Valid values: dollar_offset|regression_analysis|critical_terms_match|var_reduction.',
  `ferc_reporting_category` STRING COMMENT 'FERC reporting category or classification code applicable to this hedge strategy for regulatory filings.',
  `hedge_accounting_designation` STRING COMMENT 'ASC 815 hedge accounting designation type: fair value hedge, cash flow hedge, net investment hedge, or not designated for hedge accounting. Valid values: fair_value|cash_flow|net_investment|not_designated.',
  `hedge_designation_date` DATE COMMENT 'Date on which the hedge accounting designation was formally documented and became effective.',
  `hedge_executed_in_book` BIGINT COMMENT 'FK to trading.trading_book.trading_book_id — Hedge strategies are executed through specific trading books. This FK links board-approved hedging programs to the books that implement them.',
  `hedge_horizon_months` INT COMMENT 'Time horizon in months over which the hedge strategy is executed and maintained.',
  `hedge_objective` STRING COMMENT 'Primary risk management objective of the hedge strategy: price risk, basis risk, volumetric risk, credit risk, operational risk, or regulatory compliance. Valid values: price_risk|basis_risk|volumetric_risk|credit_risk|operational_risk|regulatory_compliance.',
  `hedge_ratio_target_pct` DECIMAL(5,2) COMMENT 'Target hedge ratio as a percentage of the underlying exposure that the strategy aims to hedge (0-100%).',
  `hedge_to_book` BIGINT COMMENT 'FK to trading.trading_book.trading_book_id — Hedge strategies are typically aligned to trading books for ASC 815 hedge accounting designation and effectiveness testing.',
  `hedged_item_description` STRING COMMENT 'Description of the underlying hedged item or forecasted transaction being protected by this strategy.',
  `internal_notes` STRING COMMENT 'Free-text field for internal comments, strategy rationale, or special instructions related to this hedge strategy.',
  `irp_alignment_flag` BOOLEAN COMMENT 'Indicates whether this hedge strategy is aligned with the utility\'s Integrated Resource Plan (IRP) as filed with the Public Utility Commission (PUC).',
  `irp_filing_reference` STRING COMMENT 'Reference to the specific IRP filing or docket number that supports this hedge strategy.',
  `last_effectiveness_ratio_pct` DECIMAL(7,4) COMMENT 'Calculated effectiveness ratio from the most recent test, expressed as a percentage.',
  `last_effectiveness_test_date` DATE COMMENT 'Date of the most recent hedge effectiveness test performed for this strategy.',
  `last_effectiveness_test_result` STRING COMMENT 'Result of the most recent hedge effectiveness test: highly effective, effective, ineffective, or not tested. Valid values: highly_effective|effective|ineffective|not_tested.',
  `prospective_test_threshold_pct` DECIMAL(5,2) COMMENT 'Threshold percentage for prospective hedge effectiveness testing (typically 80-125% range per ASC 815).',
  `retrospective_test_threshold_pct` DECIMAL(5,2) COMMENT 'Threshold percentage for retrospective hedge effectiveness testing (typically 80-125% range per ASC 815).',
  `risk_committee_approval_date` DATE COMMENT 'Date on which the risk committee approved this hedge strategy.',
  `risk_committee_approval_flag` BOOLEAN COMMENT 'Indicates whether this hedge strategy has been reviewed and approved by the enterprise risk committee.',
  `strategy_code` STRING COMMENT 'Business identifier code for the hedge strategy, used for external reference and reporting. Pattern: ^[A-Z0-9_-]{3,20}$.',
  `strategy_name` STRING COMMENT 'Descriptive name of the hedge strategy program as approved by the board.',
  `strategy_status` STRING COMMENT 'Current lifecycle status of the hedge strategy: active, suspended, terminated, pending approval, or under review. Valid values: active|suspended|terminated|pending_approval|under_review.',
  `strategy_type` STRING COMMENT 'Classification of the hedge strategy type: fixed-price forward, basis swap, collar, option, heat rate, CRR/FTR (Congestion Revenue Rights/Financial Transmission Rights), volumetric, or credit hedge. Reference-value candidates: fixed_price_forward|basis_swap|collar|option|heat_rate|crr_ftr|volumetric|credit.',
  `target_commodity` STRING COMMENT 'The commodity or product being hedged: electricity, natural gas, coal, renewable energy certificate (REC), capacity, or ancillary services. Valid values: electricity|natural_gas|coal|renewable_energy_certificate|capacity|ancillary_services.',
  `target_volume_mmbtu` DECIMAL(15,2) COMMENT 'Target volume in million British thermal units (MMBtu) to be hedged under this strategy for natural gas commodities.',
  `target_volume_mwh` DECIMAL(15,2) COMMENT 'Target volume in megawatt-hours (MWh) to be hedged under this strategy for electricity commodities.',
  `test_frequency` STRING COMMENT 'Frequency at which hedge effectiveness testing is performed: monthly, quarterly, annually, at inception, or event-driven. Valid values: monthly|quarterly|annually|at_inception|event_driven.',
  `to_trading_book` BIGINT COMMENT 'FK to trading.trading_book.trading_book_id — Hedge strategies are executed through trading books. This FK links strategy definition to execution and enables hedge effectiveness tracking against actual positions.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this hedge strategy record was last modified.',
  `var_confidence_level_pct` DECIMAL(5,2) COMMENT 'Confidence level percentage used for VaR calculation (e.g., 95%, 99%).',
  `var_target_usd` DECIMAL(18,2) COMMENT 'Target Value at Risk (VaR) limit in USD that the hedge strategy aims to maintain for the portfolio.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_hedge_strategy` PRIMARY KEY (`hedge_strategy_id`)
)
USING DELTA
COMMENT 'Hedge strategy master record defining the utility\'s board-approved hedging programs for managing commodity price risk, basis risk, volumetric risk, and credit risk in the wholesale energy portfolio. Captures strategy name, hedge type (fixed-price forward, basis swap, collar, option, heat rate, CRR/FTR), target commodity and delivery period, hedge ratio and target volume, hedge horizon, risk metric targets (VaR, CVaR, expected shortfall), authorized instruments, board approval date and reference, IRP alignment flag, and ASC 815 hedge designation (fair value, cash flow, net investment). Includes hedge effectiveness testing: prospective and retrospective test methods (dollar-offset, regression, critical terms match), effectiveness thresholds, test frequency, test results history, and de-designation triggers. Links to trading books that execute the strategy. Supports hedge accounting documentation, ASC 815/IFRS 9 compliance, effectiveness testing audit trail, and risk committee reporting. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'HedgeStrategy',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.hedge_strategy'
);

-- CapacityObligation  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `trading`.`capacity_obligation` (
  `capacity_obligation_id` BIGINT NOT NULL COMMENT 'Unique identifier for the capacity obligation record in the ISO/RTO capacity market.',
  `battery_storage_asset_id` BIGINT COMMENT 'Foreign key linking to renewable.battery_storage_asset. Business justification: Battery storage provides capacity in ISO markets with specific performance requirements. Links capacity obligations to battery assets for availability tracking, discharge duration validation, and perf',
  `bilateral_counterparty_id` BIGINT COMMENT 'Identifier of the counterparty in a bilateral capacity purchase agreement, if applicable.',
  `capacity_requirement_id` BIGINT COMMENT 'Foreign key linking to forecast.capacity_requirement. Business justification: Capacity obligations must satisfy ISO/RTO capacity requirements derived from resource adequacy assessments. Compliance officers link obligations to formal capacity requirements to demonstrate fulfillm',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Capacity obligations and associated costs are allocated to cost centers for rate case cost-of-service calculations. Real business process: rate case testimony requires capacity costs by functional cos',
  `demand_dr_enrollment_id` BIGINT COMMENT 'Foreign key linking to demand.dr_enrollment. Business justification: Specific DR enrollments satisfy capacity obligations. Real business process: granular capacity resource tracking for ISO capacity market audits, performance measurement, and capacity payment allocatio',
  `der_system_id` BIGINT COMMENT 'Identifier of the primary capacity resource (generation unit, demand response program, or import contract) committed to satisfy this obligation.',
  `dr_program_id` BIGINT COMMENT 'Foreign key linking to demand.dr_program. Business justification: Capacity obligations met through DR program enrollment. Real business process: PJM/NYISO/ISO-NE capacity market compliance where load-serving entities use DR programs to satisfy resource adequacy requ',
  `employee_id` BIGINT COMMENT 'Identifier of the capacity planning analyst or resource adequacy manager responsible for managing this obligation.',
  `load_serving_entity_id` BIGINT COMMENT 'Identifier of the load serving entity responsible for this capacity obligation.',
  `market_bid_id` BIGINT COMMENT 'FK to trading.market_bid.market_bid_id — Capacity obligations may be fulfilled through market participation (capacity auctions). This FK links the obligation to the market bid/award that satisfies it.',
  `peak_demand_id` BIGINT COMMENT 'Foreign key linking to forecast.peak_demand. Business justification: Capacity obligations are sized based on peak demand forecasts. Load-serving entities link capacity obligations to the peak demand forecasts used to determine required capacity purchases and demonstrat',
  `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Capacity obligations impact profit center economics and must be tracked for segment profitability analysis. Real business process: monthly management reporting shows capacity costs by profit center fo',
  `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: Capacity obligations and procurement are reported in state IRP filings and resource adequacy compliance reports. Regulatory teams demonstrate capacity procurement meets state reliability requirements',
  `auction_date` DATE COMMENT 'The date on which the capacity auction was conducted and clearing prices were established.',
  `auction_reference_code` STRING COMMENT 'Reference identifier for the ISO/RTO capacity auction in which the capacity was procured (e.g., BRA, incremental auction identifier).',
  `auction_type` STRING COMMENT 'Type of capacity procurement mechanism: base residual auction (BRA), incremental auction, reconfiguration auction, or bilateral capacity purchase. Valid values: base_residual|incremental|reconfiguration|bilateral.',
  `bilateral_contract_flag` BOOLEAN COMMENT 'Indicates whether the capacity was procured through a bilateral contract outside of the ISO/RTO auction (True) or through the auction mechanism (False).',
  `bilateral_contract_number` STRING COMMENT 'Contract reference number for bilateral capacity purchase agreements.',
  `capacity_clearing_price_per_mw_day` DECIMAL(18,6) COMMENT 'The auction clearing price in dollars per megawatt-day for capacity in this zone and planning year, representing the market cost of capacity.',
  `capacity_market_program` STRING COMMENT 'Name of the specific capacity market program (e.g., PJM Reliability Pricing Model, MISO Planning Resource Auction, NYISO Installed Capacity Market, ISO-NE Forward Capacity Market).',
  `capacity_performance_obligation_mw` DECIMAL(18,6) COMMENT 'The portion of committed capacity that is designated as Capacity Performance (CP) and subject to enhanced performance requirements and penalties during emergency conditions.',
  `capacity_shortfall_mw` DECIMAL(18,6) COMMENT 'The difference between required capacity and committed capacity, representing unmet obligation exposure (negative values indicate surplus).',
  `committed_capacity_mw` DECIMAL(18,6) COMMENT 'The total capacity in megawatts that has been committed through generation resources, demand response, imports, or bilateral contracts to satisfy the obligation.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this capacity obligation record was first created in the system.',
  `deficiency_charge_rate_per_mw_day` DECIMAL(18,6) COMMENT 'The penalty rate in dollars per megawatt-day that applies if the utility fails to meet its capacity obligation, typically set by ISO/RTO tariff.',
  `deficiency_exposure_usd` DECIMAL(18,2) COMMENT 'The potential financial exposure in USD if the capacity shortfall is not resolved, calculated as capacity_shortfall_mw * deficiency_charge_rate_per_mw_day * days_in_period.',
  `ferc_reporting_flag` BOOLEAN COMMENT 'Indicates whether this capacity obligation must be included in FERC Form 1 or other FERC regulatory filings (True) or is exempt (False).',
  `filing_date` DATE COMMENT 'The date on which the capacity obligation and resource commitment were filed with the ISO/RTO for the planning year.',
  `forced_outage_rate_pct` DECIMAL(5,2) COMMENT 'The expected forced outage rate percentage applied to convert installed capacity (ICAP) to unforced capacity (UCAP) for the committed resources.',
  `iso_rto_code` STRING COMMENT 'Code identifying the ISO or RTO capacity market in which this obligation exists (PJM RPM, MISO PRA, NYISO ICAP, ISO-NE FCM). Reference-value candidates: PJM|MISO|NYISO|ISO-NE|CAISO|ERCOT|SPP.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this capacity obligation record was last modified, reflecting changes to committed resources, shortfalls, or status.',
  `nerc_compliance_flag` BOOLEAN COMMENT 'Indicates whether the capacity obligation and committed resources meet NERC reliability standards for resource adequacy (True) or have compliance gaps (False).',
  `notes` STRING COMMENT 'Free-text field for internal notes, comments, or special conditions related to the capacity obligation, resource procurement strategy, or compliance considerations.',
  `obligation_period_end_date` DATE COMMENT 'The end date of the capacity obligation period, typically May 31 of the following year for most ISO/RTO markets.',
  `obligation_period_start_date` DATE COMMENT 'The start date of the capacity obligation period, typically June 1 for most ISO/RTO markets.',
  `obligation_reference_number` STRING COMMENT 'External business identifier for the capacity obligation, used in ISO/RTO filings and internal tracking.',
  `obligation_status` STRING COMMENT 'Current lifecycle status of the capacity obligation: draft (planning), active (obligation period in effect), satisfied (fully committed), deficient (shortfall exists), or closed (period ended). Valid values: draft|active|satisfied|deficient|closed.',
  `obligation_type` STRING COMMENT 'Type of capacity obligation: ICAP (Installed Capacity), UCAP (Unforced Capacity), PLC (Peak Load Contribution), or CONE (Cost of New Entry). Valid values: ICAP|UCAP|PLC|CONE.',
  `peak_load_forecast_mw` DECIMAL(18,6) COMMENT 'The forecasted peak load in megawatts for the obligation period, used as the basis for calculating the capacity requirement.',
  `performance_penalty_risk_flag` BOOLEAN COMMENT 'Indicates whether the committed capacity resources are subject to performance penalties during shortage events (True for capacity performance resources in PJM, False otherwise).',
  `planning_year` STRING COMMENT 'The planning year or delivery year for which the capacity obligation applies, typically formatted as YYYY/YYYY (e.g., 2024/2025).',
  `puc_reporting_flag` BOOLEAN COMMENT 'Indicates whether this capacity obligation must be reported to the state Public Utility Commission for resource adequacy compliance (True) or not (False).',
  `required_capacity_mw` DECIMAL(18,6) COMMENT 'The total capacity requirement in megawatts that the utility must procure or demonstrate to meet resource adequacy standards.',
  `reserve_margin_pct` DECIMAL(5,2) COMMENT 'The planning reserve margin percentage applied to determine the capacity obligation, representing the buffer above forecasted peak load.',
  `total_capacity_cost_usd` DECIMAL(18,2) COMMENT 'The total cost in USD for procuring the committed capacity over the obligation period, calculated as committed_capacity_mw * capacity_clearing_price_per_mw_day * days_in_period.',
  `zone_name` STRING COMMENT 'Name of the capacity zone or locational deliverability area (LDA) where the obligation applies.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_capacity_obligation` PRIMARY KEY (`capacity_obligation_id`)
)
USING DELTA
COMMENT 'Capacity market obligation and resource adequacy record capturing the utility\'s installed capacity (ICAP) or unforced capacity (UCAP) requirements and committed capacity resources in ISO/RTO capacity markets (PJM RPM, MISO PRA, NYISO ICAP, ISO-NE FCM). Captures obligation period, planning year, required MW, committed resource ID, capacity type (generation, demand response, energy efficiency, import), capacity price ($/MW-day), auction clearing reference, bilateral capacity purchase details, deficiency charge exposure, performance penalty risk, and NERC reliability standard compliance flag. Supports resource adequacy planning and capacity cost allocation. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CapacityObligation',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.capacity_obligation'
);

-- SettlementStatement  <<CIM MarketStatement : close>>
CREATE TABLE IF NOT EXISTS `trading`.`settlement_statement` (
  `settlement_statement_id` BIGINT NOT NULL COMMENT 'Primary key for settlement_statement',
  `contract_id` BIGINT COMMENT 'Identifier of the power purchase agreement or bilateral contract associated with the settlement.',
  `counterparty_id` BIGINT COMMENT 'Identifier of the counterparty (buyer or seller) involved in the settlement.',
  `trade_id` BIGINT COMMENT 'Identifier of the underlying trade that this settlement statement settles.',
  `corrected_settlement_statement_id` BIGINT COMMENT 'Self-referencing FK on settlement_statement (corrected_settlement_statement_id)',
  `adjustment_amount` DECIMAL(18,2) COMMENT 'Net adjustments (taxes, fees, penalties) applied to the gross amount.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the settlement statement record was first created in the data lake.',
  `currency_code` STRING COMMENT 'Three-letter ISO currency code for the monetary values.',
  `gross_amount` DECIMAL(18,2) COMMENT 'Total amount before adjustments, in settlement currency.',
  `invoice_number` STRING COMMENT 'Reference number of the invoice generated for this settlement.',
  `market_type` STRING COMMENT 'Market segment for which the settlement applies (e.g., day-ahead, real-time).',
  `net_amount` DECIMAL(18,2) COMMENT 'Final amount payable after adjustments, in settlement currency.',
  `payment_due_date` DATE COMMENT 'Date by which the net settlement amount must be paid.',
  `payment_status` STRING COMMENT 'Current payment status of the settlement.',
  `posted_timestamp` TIMESTAMP COMMENT 'Timestamp when the settlement statement was posted to the ledger.',
  `price_per_mwh` DECIMAL(18,6) COMMENT 'Settlement price applied per megawatt-hour.',
  `product_type` STRING COMMENT 'Energy product category settled by this statement.',
  `quantity_mwh` DECIMAL(18,4) COMMENT 'Energy quantity settled, expressed in megawatt-hours.',
  `remarks` STRING COMMENT 'Free-form comments or notes related to the settlement.',
  `reversal_flag` BOOLEAN COMMENT 'Indicates whether this settlement statement represents a reversal of a prior settlement.',
  `settlement_date` DATE COMMENT 'Date on which the settlement transaction is considered effective.',
  `settlement_method` STRING COMMENT 'Process used to generate the settlement (automated, manual, or batch).',
  `settlement_period_end` DATE COMMENT 'End date of the settlement period covered by this statement.',
  `settlement_period_start` DATE COMMENT 'Start date of the settlement period covered by this statement.',
  `settlement_version` INT COMMENT 'Version number for the settlement statement to support amendments.',
  `source_system` STRING COMMENT 'Originating system that produced the settlement data (e.g., OpenLink Endur).',
  `statement_number` STRING COMMENT 'External reference number assigned to the settlement statement by the trading system.',
  `status` STRING COMMENT 'Current lifecycle status of the settlement statement.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the settlement statement record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_settlement_statement` PRIMARY KEY (`settlement_statement_id`)
)
USING DELTA
COMMENT 'Master reference table for settlement_statement. Referenced by settlement_statement_id. | CMM: CIM MarketStatement (close), IEC62325::MarketManagement.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SettlementStatement',
  'cmm.cim.class' = 'MarketStatement',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC62325::MarketManagement',
  'cmm.cim.standard' = 'IEC 62325-301 / IEC 62325-351',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.settlement_statement'
);

-- TradingContract  <<CIM Agreement : extension>>
CREATE TABLE IF NOT EXISTS `trading`.`contract` (
  `contract_id` BIGINT NOT NULL COMMENT 'Primary key for contract',
  `counterparty_id` BIGINT COMMENT 'Unique identifier of the counterparty organization associated with the contract.',
  `master_contract_id` BIGINT COMMENT 'Self-referencing FK on contract (master_contract_id)',
  `collateral_amount` DECIMAL(18,4) COMMENT 'Monetary collateral posted to secure the contract.',
  `collateral_currency` STRING COMMENT 'Currency of the collateral amount.',
  `contract_description` STRING COMMENT 'Free-text description providing additional details about the contract.',
  `contract_name` STRING COMMENT 'Descriptive name of the contract for easy reference by traders and analysts.',
  `contract_number` STRING COMMENT 'External business identifier assigned to the contract, used in trading and regulatory reporting.',
  `contract_status` STRING COMMENT 'Current lifecycle state of the contract (e.g., active, pending, suspended, terminated).',
  `contract_type` STRING COMMENT 'Category of the agreement such as Power Purchase Agreement, Capacity Contract, Ancillary Service, or Financial Swap.',
  `counterparty_credit_rating` STRING COMMENT 'Credit rating assigned to the counterparty (e.g., A+, BBB).',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the contract record was first created in the system.',
  `credit_limit` DECIMAL(18,4) COMMENT 'Maximum credit exposure allowed for the counterparty under this contract.',
  `credit_limit_currency` STRING COMMENT 'Currency of the credit limit amount.',
  `delivery_point_code` STRING COMMENT 'Identifier of the delivery location or node in the grid.',
  `effective_end_date` DATE COMMENT 'Date on which the contract expires or terminates, if applicable.',
  `effective_start_date` DATE COMMENT 'Date on which the contract becomes legally binding and operational.',
  `ferc_reportable_flag` BOOLEAN COMMENT 'True if the contract must be reported to the Federal Energy Regulatory Commission.',
  `index_price` DECIMAL(18,4) COMMENT 'Most recent value of the price index used for the contract.',
  `index_price_currency` STRING COMMENT 'Currency of the index price, using ISO 4217 code.',
  `is_exercisable` BOOLEAN COMMENT 'True if the contract includes exercisable options (e.g., call/put).',
  `is_firm` BOOLEAN COMMENT 'Indicates whether the contract is firm (obligatory) or non-firm (optional).',
  `is_hedge` BOOLEAN COMMENT 'True if the contract is used for hedging market exposure.',
  `is_indexed` BOOLEAN COMMENT 'True if the contract price is tied to an external index.',
  `is_renewable` BOOLEAN COMMENT 'True if the contract pertains to renewable energy generation.',
  `jurisdiction` STRING COMMENT 'Regulatory jurisdiction governing the contract (state, province, or country).',
  `market` STRING COMMENT 'Electricity market or ISO/RTO where the contract is executed (e.g., CAISO, ERCOT).',
  `naesb_compliance_flag` BOOLEAN COMMENT 'True if the contract complies with NAESB standards.',
  `payment_due_date` DATE COMMENT 'Standard due date for each payment cycle.',
  `payment_frequency` STRING COMMENT 'How often payments are due (e.g., monthly, quarterly).',
  `payment_terms` STRING COMMENT 'Textual description of payment conditions (e.g., net 30, net 45).',
  `price_amount` DECIMAL(18,4) COMMENT 'Monetary amount associated with the contract price per unit.',
  `price_currency` STRING COMMENT 'Three-letter ISO 4217 code of the currency used for the contract price.',
  `pricing_type` STRING COMMENT 'Method used to calculate contract price (e.g., fixed, indexed, variable).',
  `product_type` STRING COMMENT 'Type of energy product covered (e.g., energy, capacity, ancillary service).',
  `regulatory_reporting_code` STRING COMMENT 'Code used for mandatory regulatory filings (e.g., FERC schedule code).',
  `renewal_option` STRING COMMENT 'Indicates whether the contract includes an automatic renewal clause (e.g., none, optional, mandatory).',
  `renewal_term_months` INT COMMENT 'Length of the renewal period in months when a renewal option is exercised.',
  `settlement_point_code` STRING COMMENT 'Identifier of the settlement location used for financial settlement.',
  `signed_date` DATE COMMENT 'Date the contract was signed by all parties.',
  `tax_exempt_flag` BOOLEAN COMMENT 'True if the contract is exempt from applicable taxes.',
  `termination_date` DATE COMMENT 'Actual date the contract was terminated before its scheduled end, if applicable.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the contract record.',
  `volume_quantity` DECIMAL(18,4) COMMENT 'Total energy volume covered by the contract.',
  `volume_unit` STRING COMMENT 'Unit of measure for the contract volume (e.g., MWh, GWh).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_contract` PRIMARY KEY (`contract_id`)
)
USING DELTA
COMMENT 'Master reference table for contract. Referenced by contract_id. | CMM: CIM Agreement (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'TradingContract',
  'cmm.cim.class' = 'Agreement',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.contract'
);

-- LoadServingEntity  <<CIM MarketParticipant : close>>
CREATE TABLE IF NOT EXISTS `trading`.`load_serving_entity` (
  `load_serving_entity_id` BIGINT NOT NULL COMMENT 'Primary key for load_serving_entity',
  `parent_load_serving_entity_id` BIGINT COMMENT 'Self-referencing FK on load_serving_entity (parent_load_serving_entity_id)',
  `address_line1` STRING COMMENT 'First line of the entity’s mailing address.',
  `address_line2` STRING COMMENT 'Second line of the entity’s mailing address (optional).',
  `capacity_mw` DECIMAL(12,2) COMMENT 'Maximum electrical capacity the entity can serve or transmit, expressed in megawatts.',
  `city` STRING COMMENT 'City component of the entity’s address.',
  `country_code` STRING COMMENT 'Three-letter ISO country code where the entity is located.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the load serving entity record was first created in the system.',
  `description` STRING COMMENT 'Free-form text describing the entity’s role, ownership, or special characteristics.',
  `effective_from` DATE COMMENT 'Date when the entity became effective for operational purposes.',
  `effective_until` DATE COMMENT 'Date when the entity ceases to be effective; null if open-ended.',
  `entity_name` STRING COMMENT 'Human-readable name of the load serving entity (e.g., utility name, balancing authority).',
  `entity_type` STRING COMMENT 'Categorizes the entity by its functional role in the power system.',
  `is_federal_entity` BOOLEAN COMMENT 'True if the entity is a federal or government-owned organization.',
  `jurisdiction` STRING COMMENT 'Regulatory jurisdiction (state or province) governing the entity.',
  `lse_code` STRING COMMENT 'External business identifier assigned to the load serving entity by market operators or regulatory bodies.',
  `market_participation_flag` BOOLEAN COMMENT 'Indicates whether the entity participates in wholesale energy markets.',
  `postal_code` STRING COMMENT 'Postal/ZIP code for the entity’s address.',
  `primary_contact_email` STRING COMMENT 'Email address of the primary contact.',
  `primary_contact_name` STRING COMMENT 'Name of the primary business contact for the entity.',
  `primary_contact_phone` STRING COMMENT 'Phone number of the primary contact.',
  `region` STRING COMMENT 'Broad geographic region where the entity operates (e.g., Northeast, Midwest).',
  `regulatory_reporting_flag` BOOLEAN COMMENT 'True if the entity is subject to mandatory regulatory reporting (e.g., FERC, NAESB).',
  `state` STRING COMMENT 'State or province component of the entity’s address.',
  `status` STRING COMMENT 'Current lifecycle status of the entity within the utility\'s master data.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_load_serving_entity` PRIMARY KEY (`load_serving_entity_id`)
)
USING DELTA
COMMENT 'Master reference table for load_serving_entity. Referenced by load_serving_entity_id. | CMM: CIM MarketParticipant (close), IEC62325::MarketCommon.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'LoadServingEntity',
  'cmm.cim.class' = 'MarketParticipant',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC62325::MarketCommon',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.load_serving_entity'
);

-- NettingAgreement  <<CIM Agreement : extension>>
CREATE TABLE IF NOT EXISTS `trading`.`netting_agreement` (
  `netting_agreement_id` BIGINT NOT NULL COMMENT 'Primary key for netting_agreement',
  `counterparty_id` BIGINT COMMENT 'Unique identifier of the primary counterparty to the netting agreement.',
  `legal_entity_id` BIGINT COMMENT 'Identifier of the legal entity that owns or signs the netting agreement.',
  `superseded_netting_agreement_id` BIGINT COMMENT 'Self-referencing FK on netting_agreement (superseded_netting_agreement_id)',
  `agreement_name` STRING COMMENT 'Human-readable name or title of the netting agreement.',
  `agreement_number` STRING COMMENT 'External reference number assigned to the netting agreement by the trading system.',
  `agreement_type` STRING COMMENT 'Category of netting agreement indicating the structure of parties involved.',
  `amendment_indicator` BOOLEAN COMMENT 'True if the record represents an amendment to an existing agreement.',
  `amendment_number` INT COMMENT 'Sequential number of the amendment applied to the original agreement.',
  `audit_trail_reference` BIGINT COMMENT 'Reference to the audit log entry that captures change history for this agreement.',
  `collateral_amount` DECIMAL(18,2) COMMENT 'Monetary value of the posted collateral.',
  `collateral_currency` STRING COMMENT 'Currency of the collateral amount.',
  `collateral_type` STRING COMMENT 'Form of collateral posted to support the netting agreement.',
  `comments` STRING COMMENT 'Free-form notes or remarks about the agreement.',
  `compliance_status` STRING COMMENT 'Current compliance posture of the agreement with regulatory requirements.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the netting agreement record was first created in the system.',
  `credit_limit` DECIMAL(18,2) COMMENT 'Maximum credit exposure allowed under the agreement, expressed in the agreement currency.',
  `effective_end_date` DATE COMMENT 'Date on which the netting agreement terminates; null for open-ended agreements.',
  `effective_start_date` DATE COMMENT 'Date on which the netting agreement becomes legally binding.',
  `effective_version` INT COMMENT 'Version of the agreement reflecting the latest set of terms after amendments.',
  `exposure_limit` DECIMAL(18,2) COMMENT 'Maximum net exposure permitted for the agreement.',
  `ftr_holding_quantity` DECIMAL(18,2) COMMENT 'Quantity of FTRs held under the agreement, expressed in the holding unit.',
  `ftr_holding_unit` STRING COMMENT 'Unit of measure for the FTR holding quantity.',
  `internal_reference_code` STRING COMMENT 'Internal code used for cross-system reference or tracking.',
  `is_eligible_for_ftr` BOOLEAN COMMENT 'Indicates whether the agreement qualifies for Financial Transmission Rights participation.',
  `jurisdiction_code` STRING COMMENT 'ISO-3166-1 alpha-3 code of the regulatory jurisdiction governing the agreement.',
  `last_review_date` DATE COMMENT 'Date when the agreement was last reviewed for compliance or operational relevance.',
  `margin_requirement_percent` DECIMAL(5,2) COMMENT 'Required margin as a percentage of the netted exposure.',
  `netting_currency` STRING COMMENT 'ISO 4217 currency code used for all monetary calculations in the agreement.',
  `netting_frequency` STRING COMMENT 'How often netting calculations are performed.',
  `netting_method` STRING COMMENT 'Method used to calculate net positions across the parties.',
  `regulatory_reporting_flag` BOOLEAN COMMENT 'Indicates whether the agreement is subject to mandatory regulatory reporting (e.g., FERC, NAESB).',
  `review_cycle_months` INT COMMENT 'Number of months between mandatory agreement reviews.',
  `settlement_terms` STRING COMMENT 'Textual description of settlement procedures, timing, and payment mechanisms.',
  `status` STRING COMMENT 'Current lifecycle state of the netting agreement.',
  `termination_date` DATE COMMENT 'Actual date the agreement was terminated, if earlier than the effective end date.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the netting agreement record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_netting_agreement` PRIMARY KEY (`netting_agreement_id`)
)
USING DELTA
COMMENT 'Master reference table for netting_agreement. Referenced by netting_agreement_id. | CMM: CIM Agreement (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'NettingAgreement',
  'cmm.cim.class' = 'Agreement',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.netting_agreement'
);

-- TradingDesk  <<CIM Organisation : extension>>
CREATE TABLE IF NOT EXISTS `trading`.`trading_desk` (
  `trading_desk_id` BIGINT NOT NULL COMMENT 'Primary key for trading_desk',
  `parent_trading_desk_id` BIGINT COMMENT 'Self-referencing FK on trading_desk (parent_trading_desk_id)',
  `capacity_mw` DECIMAL(12,3) COMMENT 'Maximum megawatt capacity the desk is authorized to trade.',
  `compliance_status` STRING COMMENT 'Current compliance standing of the desk.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the desk record was first created in the system.',
  `description` STRING COMMENT 'Free-form description of the desk\'s purpose and responsibilities.',
  `desk_code` STRING COMMENT 'External code or abbreviation used to reference the desk in trading systems.',
  `desk_level` STRING COMMENT 'Organizational seniority tier of the desk.',
  `desk_name` STRING COMMENT 'Human-readable name of the trading desk.',
  `desk_type` STRING COMMENT 'Category describing the desk\'s operational mode.',
  `effective_from` DATE COMMENT 'Date when the desk became operational or was officially recognized.',
  `effective_until` DATE COMMENT 'Date when the desk ceased operations or was retired (null if still active).',
  `ferc_registered` BOOLEAN COMMENT 'Indicates whether the desk is registered with the Federal Energy Regulatory Commission.',
  `iso_rto` STRING COMMENT 'Independent System Operator / Regional Transmission Organization the desk interacts with.',
  `last_audit_date` DATE COMMENT 'Date of the most recent compliance audit for the desk.',
  `location_city` STRING COMMENT 'City where the desk\'s primary office is located.',
  `location_country` STRING COMMENT 'Three-letter ISO country code of the desk\'s location.',
  `location_state` STRING COMMENT 'State or province of the desk\'s primary office.',
  `manager_email` STRING COMMENT 'Primary email address of the desk manager.',
  `manager_name` STRING COMMENT 'Full legal name of the desk manager.',
  `manager_phone` STRING COMMENT 'Contact phone number for the desk manager.',
  `naesb_compliant` BOOLEAN COMMENT 'Indicates compliance with NAESB scheduling standards.',
  `primary_market` STRING COMMENT 'Main market segment the desk participates in.',
  `region` STRING COMMENT 'Broad geographic region (e.g., North America, Europe) where the desk primarily trades.',
  `reporting_group` STRING COMMENT 'Grouping used for internal reporting and analytics.',
  `risk_limit_usd` DECIMAL(18,2) COMMENT 'Maximum monetary risk exposure allowed for the desk.',
  `settlement_currency` STRING COMMENT 'Three-letter ISO currency code used for settlements.',
  `status` STRING COMMENT 'Current operational status of the desk.',
  `trading_strategy` STRING COMMENT 'Primary trading strategy employed by the desk.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the desk record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_trading_desk` PRIMARY KEY (`trading_desk_id`)
)
USING DELTA
COMMENT 'Master reference table for trading_desk. Referenced by trading_desk_id. | CMM: CIM Organisation (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'TradingDesk',
  'cmm.cim.class' = 'Organisation',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.trading_desk'
);

-- MarketParticipant  <<CIM MarketParticipant : exact>>
CREATE TABLE IF NOT EXISTS `trading`.`market_participant` (
  `market_participant_id` BIGINT NOT NULL COMMENT 'Primary key for market_participant',
  `parent_market_participant_id` BIGINT COMMENT 'Self-referencing FK on market_participant (parent_market_participant_id)',
  `address_line1` STRING COMMENT 'First line of the participant\'s primary address.',
  `address_line2` STRING COMMENT 'Second line of the address, if applicable.',
  `bank_account_number` STRING COMMENT 'Bank account number for settlements.',
  `bank_routing_number` STRING COMMENT 'Routing number of the settlement bank.',
  `city` STRING COMMENT 'City of the primary address.',
  `classification_code` STRING COMMENT 'Internal classification code for reporting and segmentation.',
  `compliance_status` STRING COMMENT 'Current compliance status with regulatory requirements.',
  `country` STRING COMMENT 'Three-letter ISO country code of the participant\'s primary location.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the market participant record was first created in the system.',
  `credit_limit` DECIMAL(15,2) COMMENT 'Maximum credit exposure allowed for the participant.',
  `credit_rating` STRING COMMENT 'External credit rating assigned to the participant.',
  `default_settlement_method` STRING COMMENT 'Preferred method for settling financial transactions.',
  `duns_number` STRING COMMENT 'Dun & Bradstreet unique identifier.',
  `effective_from` DATE COMMENT 'Date when the participant became active in the market.',
  `effective_until` DATE COMMENT 'Date when the participant\'s market participation ends, if applicable.',
  `ferc_code` STRING COMMENT 'Identifier used for FERC market reporting.',
  `is_active` BOOLEAN COMMENT 'Indicates whether the participant is currently active (true) or not (false).',
  `iso_participant_code` STRING COMMENT 'Identifier assigned by the Independent System Operator.',
  `last_credit_review_date` DATE COMMENT 'Date of the most recent credit review.',
  `market_participant_code` STRING COMMENT 'Internal code used for trading system identification.',
  `naesb_code` STRING COMMENT 'Identifier used in NAESB reporting.',
  `name` STRING COMMENT 'Full legal name of the market participant as registered.',
  `notes` STRING COMMENT 'Free-text field for additional remarks or notes about the participant.',
  `participant_role` STRING COMMENT 'Primary role of the participant in market transactions.',
  `participant_type` STRING COMMENT 'Category of the participant in the electricity market.',
  `postal_code` STRING COMMENT 'Postal/ZIP code of the primary address.',
  `primary_contact_email` STRING COMMENT 'Email address of the primary contact.',
  `primary_contact_name` STRING COMMENT 'Name of the primary contact person for the participant.',
  `primary_contact_phone` STRING COMMENT 'Phone number of the primary contact.',
  `registration_number` STRING COMMENT 'Official registration number assigned by regulatory authority.',
  `reporting_entity_flag` BOOLEAN COMMENT 'True if the participant is required to submit regulatory reports.',
  `risk_category` STRING COMMENT 'Internal risk classification based on credit and exposure.',
  `settlement_currency` STRING COMMENT 'Currency used for financial settlements with the participant.',
  `short_name` STRING COMMENT 'Abbreviated or commonly used name for the participant.',
  `state` STRING COMMENT 'State or province of the primary address.',
  `status` STRING COMMENT 'Current operational status of the participant.',
  `tax_identifier` STRING COMMENT 'Tax ID used for reporting and withholding.',
  `tax_status` STRING COMMENT 'Tax status applicable to the participant.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the market participant record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_market_participant` PRIMARY KEY (`market_participant_id`)
)
USING DELTA
COMMENT 'Master reference table for market_participant. Referenced by market_participant_id. | CMM: CIM MarketParticipant (exact), IEC62325::MarketCommon.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MarketParticipant',
  'cmm.cim.class' = 'MarketParticipant',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC62325::MarketCommon',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.market_participant'
);

-- TradingPnode  <<CIM Pnode : exact>>
CREATE TABLE IF NOT EXISTS `trading`.`pnode` (
  `pnode_id` BIGINT NOT NULL COMMENT 'Primary key for pnode',
  `aggregate_pnode_id` BIGINT COMMENT 'Self-referencing FK on pnode (aggregate_pnode_id)',
  `capacity_mw` DECIMAL(12,2) COMMENT 'Maximum generation or load capacity at the node in megawatts.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the node record was first created in the system.',
  `description` STRING COMMENT 'Free-form text describing the node\'s characteristics, location notes, or operational remarks.',
  `effective_from` DATE COMMENT 'Date when the node became effective for market participation.',
  `effective_until` DATE COMMENT 'Date when the node ceased to be effective; null if still active.',
  `iso_rto` STRING COMMENT 'Regional transmission organization or independent system operator that governs the node.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude of the node in decimal degrees.',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude of the node in decimal degrees.',
  `market_zone` STRING COMMENT 'Market pricing zone to which the node belongs.',
  `name` STRING COMMENT 'Human-readable name of the node used in market and operational contexts.',
  `node_code` STRING COMMENT 'Standardized alphanumeric code assigned to the node by the ISO/RTO or internal system.',
  `node_owner` STRING COMMENT 'Name of the entity that owns or operates the physical node.',
  `node_type` STRING COMMENT 'Category describing the functional role of the node in the grid.',
  `settlement_group` STRING COMMENT 'Grouping used for settlement calculations, often aligned with market zones or pricing points.',
  `status` STRING COMMENT 'Current operational status of the node.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the node record.',
  `voltage_level_kv` DECIMAL(10,2) COMMENT 'Nominal voltage level of the node expressed in kilovolts.',
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
  CONSTRAINT `pk_trading_pnode` PRIMARY KEY (`pnode_id`)
)
USING DELTA
COMMENT 'Master reference table for pnode. Referenced by source_pnode_id. | CMM: CIM Pnode (exact), IEC62325::ReferenceData.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'TradingPnode',
  'cmm.cim.class' = 'Pnode',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC62325::ReferenceData',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.pnode',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- TradingPortfolio  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `trading`.`portfolio` (
  `portfolio_id` BIGINT NOT NULL COMMENT 'Primary key for portfolio',
  `employee_id` BIGINT COMMENT 'Identifier of the business owner responsible for the portfolio.',
  `manager_employee_id` BIGINT COMMENT 'Identifier of the manager overseeing the portfolio\'s trading activities.',
  `parent_portfolio_id` BIGINT COMMENT 'Self-referencing FK on portfolio (parent_portfolio_id)',
  `compliance_status` STRING COMMENT 'Current compliance status of the portfolio with regulatory requirements.',
  `creation_timestamp` TIMESTAMP COMMENT 'Timestamp when the portfolio record was first created in the system.',
  `currency_code` STRING COMMENT 'ISO 4217 currency code for monetary values associated with the portfolio.',
  `description` STRING COMMENT 'Free-text description providing additional context about the portfolio.',
  `effective_from` DATE COMMENT 'Date when the portfolio became effective.',
  `effective_until` DATE COMMENT 'Date when the portfolio expires or is terminated; null if open-ended.',
  `is_historical` BOOLEAN COMMENT 'Indicates whether the portfolio is historical (true) or active (false).',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the portfolio record.',
  `last_valuation_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent portfolio valuation.',
  `market` STRING COMMENT 'Market segment in which the portfolio participates.',
  `portfolio_code` STRING COMMENT 'External business code used to reference the portfolio in contracts and reports.',
  `portfolio_name` STRING COMMENT 'Human-readable name of the portfolio.',
  `portfolio_type` STRING COMMENT 'Category indicating the nature of the portfolio.',
  `region` STRING COMMENT 'Primary geographic region associated with the portfolio.',
  `risk_score` DECIMAL(5,2) COMMENT 'Quantitative risk metric representing the portfolio\'s risk exposure.',
  `status` STRING COMMENT 'Current lifecycle status of the portfolio.',
  `valuation_amount` DECIMAL(18,2) COMMENT 'Monetary valuation of the portfolio at the valuation date.',
  `valuation_date` DATE COMMENT 'Date on which the portfolio valuation was performed.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_portfolio` PRIMARY KEY (`portfolio_id`)
)
USING DELTA
COMMENT 'Master reference table for portfolio. Referenced by portfolio_id. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'TradingPortfolio',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.portfolio'
);

-- MarketRun  <<CIM MarketRun : exact>>
CREATE TABLE IF NOT EXISTS `trading`.`market_run` (
  `market_run_id` BIGINT NOT NULL COMMENT 'Primary key for market_run',
  `market_participant_id` BIGINT COMMENT 'Identifier of the primary market participant associated with the run.',
  `superseded_market_run_id` BIGINT COMMENT 'Self-referencing FK on market_run (superseded_market_run_id)',
  `ancillary_service_flag` BOOLEAN COMMENT 'True if ancillary services (e.g., regulation, spinning reserve) were priced.',
  `approval_timestamp` TIMESTAMP COMMENT 'Timestamp when the run was formally approved.',
  `approved_by` STRING COMMENT 'User name or identifier of the person who approved the run results.',
  `compliance_status` STRING COMMENT 'Current compliance assessment of the run against market rules.',
  `congestion_price_flag` BOOLEAN COMMENT 'True if congestion pricing was applied in this run.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the market run record was first created in the data lake.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for monetary amounts.',
  `data_quality_score` DECIMAL(5,2) COMMENT 'Numeric score (0-100) representing the overall data quality of the run.',
  `data_source_system` STRING COMMENT 'Originating system that generated the market run data (e.g., OpenLink, Eikon).',
  `end_timestamp` TIMESTAMP COMMENT 'Exact time when the market run execution finished.',
  `forecast_flag` BOOLEAN COMMENT 'Indicates whether the run is a forecast (true) or actual market outcome (false).',
  `iso_rto_code` STRING COMMENT 'Three-letter code identifying the ISO or RTO.',
  `last_modified_by` STRING COMMENT 'User who performed the most recent update to the record.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the record.',
  `market_date` DATE COMMENT 'The calendar date for which the market run prices apply.',
  `price_type` STRING COMMENT 'Type of price produced by the run (e.g., Locational Marginal Price).',
  `pricing_method` STRING COMMENT 'Methodology used to calculate market prices.',
  `region` STRING COMMENT 'Regional transmission organization or independent system operator associated with the run.',
  `regulatory_report_flag` BOOLEAN COMMENT 'Indicates whether the run data is required for regulatory reporting.',
  `run_category` STRING COMMENT 'Business categorization of the run for reporting purposes.',
  `run_code` STRING COMMENT 'System-generated code used to reference the run in downstream systems.',
  `run_duration_minutes` INT COMMENT 'Total elapsed time of the run in minutes.',
  `run_name` STRING COMMENT 'Human-readable name describing the market run (e.g., "DA 2024-05-01").',
  `run_notes` STRING COMMENT 'Free-form comments or observations about the run.',
  `run_priority` INT COMMENT 'Numeric priority used to order runs when multiple are scheduled.',
  `run_result_summary` STRING COMMENT 'Brief textual summary of key outcomes from the run.',
  `run_status_reason` STRING COMMENT 'Explanation for the current status, especially when failed or cancelled.',
  `run_type` STRING COMMENT 'Category of the market run indicating the market horizon or purpose.',
  `run_version` STRING COMMENT 'Version identifier for the run logic or configuration.',
  `settlement_date` DATE COMMENT 'Date on which financial settlement for the run occurs.',
  `start_timestamp` TIMESTAMP COMMENT 'Exact time when the market run execution began.',
  `status` STRING COMMENT 'Current processing state of the market run.',
  `test_run_flag` BOOLEAN COMMENT 'True if the run was executed for testing or validation purposes.',
  `total_value_usd` DECIMAL(18,2) COMMENT 'Total monetary value of the cleared energy, expressed in US dollars.',
  `total_volume_mwh` DECIMAL(15,3) COMMENT 'Aggregate energy volume cleared by the run, measured in megawatt-hours.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the market run record.',
  `created_by` STRING COMMENT 'User name or identifier of the person who created the record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_market_run` PRIMARY KEY (`market_run_id`)
)
USING DELTA
COMMENT 'Master reference table for market_run. Referenced by market_run_id. | CMM: CIM MarketRun (exact), IEC62325::MarketPlan.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MarketRun',
  'cmm.cim.class' = 'MarketRun',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC62325::MarketPlan',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.market_run'
);

-- MarketTransmissionConstraint  <<CIM SecurityConstraints : close>>
CREATE TABLE IF NOT EXISTS `trading`.`transmission_constraint` (
  `transmission_constraint_id` BIGINT NOT NULL COMMENT 'Primary key for transmission_constraint',
  `parent_transmission_constraint_id` BIGINT COMMENT 'Self-referencing FK on transmission_constraint (parent_transmission_constraint_id)',
  `capacity_mw` DECIMAL(12,3) COMMENT 'Maximum MW capacity limited by the constraint.',
  `congestion_cost_usd` DECIMAL(12,2) COMMENT 'Monetary estimate of congestion cost attributable to the constraint.',
  `constraint_category` STRING COMMENT 'Higher-level grouping such as capacity, ramp, must-run, or reliability.',
  `constraint_code` STRING COMMENT 'External code or identifier used in market filings and operational systems.',
  `constraint_direction` STRING COMMENT 'Direction of power flow to which the constraint applies.',
  `constraint_group` STRING COMMENT 'Logical group identifier for related constraints (e.g., corridor group).',
  `constraint_name` STRING COMMENT 'Human-readable name of the transmission constraint.',
  `constraint_owner` STRING COMMENT 'Entity (e.g., utility, transmission operator) that owns or administers the constraint.',
  `constraint_priority` INT COMMENT 'Numeric priority used for conflict resolution when multiple constraints overlap.',
  `constraint_region` STRING COMMENT 'Geographic region or ISO/RTO jurisdiction where the constraint applies.',
  `constraint_source` STRING COMMENT 'Originating system or application that supplied the constraint data (e.g., OpenLink Endur).',
  `constraint_status_reason` STRING COMMENT 'Free-text reason explaining the current status (e.g., maintenance, regulatory hold).',
  `constraint_type` STRING COMMENT 'Category of the constraint describing its physical or operational nature.',
  `constraint_zone` STRING COMMENT 'Specific market zone or congestion zone impacted by the constraint.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the constraint record was first created in the system.',
  `description` STRING COMMENT 'Detailed free-text description of the constraint, including operational notes.',
  `effective_end_date` DATE COMMENT 'Date when the constraint expires or is superseded; null if open-ended.',
  `effective_start_date` DATE COMMENT 'Date when the constraint becomes effective.',
  `is_regulatory` BOOLEAN COMMENT 'True if the constraint is mandated by a regulator (e.g., FERC).',
  `lmp_impact_flag` BOOLEAN COMMENT 'Indicates whether the constraint directly influences Locational Marginal Pricing.',
  `notes` STRING COMMENT 'Additional free-form remarks or operational comments.',
  `reporting_requirement` STRING COMMENT 'Regulatory reporting regime applicable to the constraint.',
  `status` STRING COMMENT 'Current lifecycle state of the constraint.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the constraint record.',
  `version_number` INT COMMENT 'Incremental version used for change management and audit.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_transmission_constraint` PRIMARY KEY (`transmission_constraint_id`)
)
USING DELTA
COMMENT 'Master reference table for transmission_constraint. Referenced by transmission_constraint_id. | CMM: CIM SecurityConstraints (close), IEC62325::ExternalInputs.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MarketTransmissionConstraint',
  'cmm.cim.class' = 'SecurityConstraints',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC62325::ExternalInputs',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.transmission_constraint'
);

-- DeliveryPoint  <<CIM ServicePoint : close>>
CREATE TABLE IF NOT EXISTS `trading`.`delivery_point` (
  `delivery_point_id` BIGINT NOT NULL COMMENT 'Primary key for delivery_point',
  `meter_id` BIGINT COMMENT 'Unique identifier of the meter associated with the delivery point.',
  `aggregate_delivery_point_id` BIGINT COMMENT 'Self-referencing FK on delivery_point (aggregate_delivery_point_id)',
  `address_line1` STRING COMMENT 'Primary street address of the delivery point.',
  `ancillary_service_eligible` BOOLEAN COMMENT 'True if the delivery point can provide or receive ancillary services.',
  `capacity_mw` DECIMAL(12,3) COMMENT 'Maximum power transfer capacity of the delivery point in megawatts.',
  `city` STRING COMMENT 'City where the delivery point is located.',
  `congestion_price_zone` STRING COMMENT 'Identifier of the congestion pricing zone applicable to the delivery point.',
  `contract_number` STRING COMMENT 'External contract identifier governing the delivery point.',
  `country` STRING COMMENT 'Three-letter ISO country code of the delivery point location.',
  `created_timestamp` TIMESTAMP COMMENT 'Date-time when the delivery point record was first created in the lakehouse.',
  `data_source_system` STRING COMMENT 'Name of the operational system of record that supplied the data (e.g., OpenLink Endur).',
  `delivery_point_code` STRING COMMENT 'External code or alphanumeric identifier used in trading and settlement systems.',
  `description` STRING COMMENT 'Free-form description or notes about the delivery point.',
  `effective_from` DATE COMMENT 'Date when the delivery point became legally effective for trading.',
  `effective_until` DATE COMMENT 'Date when the delivery point ceases to be effective; null if open-ended.',
  `is_grid_connected` BOOLEAN COMMENT 'Indicates whether the delivery point is physically connected to the transmission grid.',
  `last_meter_read_timestamp` TIMESTAMP COMMENT 'Date-time of the most recent meter reading.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude of the delivery point in decimal degrees.',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude of the delivery point in decimal degrees.',
  `market_zone` STRING COMMENT 'ISO/RTO market zone to which the delivery point belongs.',
  `meter_reading_interval_minutes` INT COMMENT 'Scheduled interval between meter reads.',
  `meter_type` STRING COMMENT 'Technology type of the meter.',
  `metered` BOOLEAN COMMENT 'Indicates whether the delivery point has an active meter for usage measurement.',
  `name` STRING COMMENT 'Human-readable name of the delivery point (e.g., "North Substation" or "Customer Site A").',
  `ownership_type` STRING COMMENT 'Entity that owns the delivery point.',
  `point_type` STRING COMMENT 'Category of the delivery point within the grid topology.',
  `postal_code` STRING COMMENT 'Postal or ZIP code for the delivery point location.',
  `region_code` STRING COMMENT 'Internal code representing the geographic or market region of the delivery point.',
  `regulatory_reporting_required` BOOLEAN COMMENT 'True if the delivery point must be included in mandatory regulatory reports (e.g., FERC).',
  `settlement_point_code` STRING COMMENT 'Code used for market settlement and LMP calculations.',
  `state` STRING COMMENT 'State or province of the delivery point.',
  `status` STRING COMMENT 'Current operational status of the delivery point.',
  `tariff_code` STRING COMMENT 'Code representing the tariff schedule applied to the delivery point.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date-time of the most recent modification to the delivery point record.',
  `voltage_kv` DECIMAL(10,2) COMMENT 'Rated voltage level of the delivery point expressed in kilovolts.',
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
  CONSTRAINT `pk_trading_delivery_point` PRIMARY KEY (`delivery_point_id`)
)
USING DELTA
COMMENT 'Master reference table for delivery_point. Referenced by delivery_point_id. | CMM: CIM ServicePoint (close), IEC62325::InfEnergyScheduling.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DeliveryPoint',
  'cmm.cim.class' = 'ServicePoint',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC62325::InfEnergyScheduling',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.delivery_point',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- PriceCurve  <<CIM Curve : close>>
CREATE TABLE IF NOT EXISTS `trading`.`price_curve` (
  `price_curve_id` BIGINT NOT NULL COMMENT 'Primary key for price_curve',
  `base_price_curve_id` BIGINT COMMENT 'Self-referencing FK on price_curve (base_price_curve_id)',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the curve record was first created in the system.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 code of the currency used in the price values.',
  `curve_code` STRING COMMENT 'Business code or ticker used to reference the price curve in trading systems.',
  `curve_name` STRING COMMENT 'Human-readable name describing the price curve.',
  `curve_type` STRING COMMENT 'Classification of the curve based on market usage or calculation method.',
  `data_quality_score` DECIMAL(5,2) COMMENT 'Numeric score (0-100) representing the confidence in the curve\'s source data.',
  `description` STRING COMMENT 'Free-form text describing the purpose, methodology, or notes for the curve.',
  `effective_end_date` DATE COMMENT 'Date on which the price curve ceases to be effective; null if open-ended.',
  `effective_start_date` DATE COMMENT 'Date on which the price curve becomes effective for market calculations.',
  `frequency` STRING COMMENT 'Temporal granularity of the price points in the curve.',
  `interpolation_method` STRING COMMENT 'Algorithm used to derive intermediate price values between defined points.',
  `is_default` BOOLEAN COMMENT 'Indicates whether this curve is the default for its market/region combination.',
  `is_public` BOOLEAN COMMENT 'True if the curve may be shared with external market participants; false if internal only.',
  `market` STRING COMMENT 'Electricity market or ISO/RTO to which the curve applies.',
  `point_count` INT COMMENT 'Total number of price points contained in the curve.',
  `price_unit` STRING COMMENT 'Unit of measure for the price values (e.g., USD/MWh).',
  `region` STRING COMMENT 'Primary geographic region or balancing authority for the curve.',
  `regulatory_reporting_flag` BOOLEAN COMMENT 'True if the curve must be included in mandatory market or FERC reporting.',
  `settlement_type` STRING COMMENT 'Indicates whether the curve is used for energy, capacity, or ancillary service settlement.',
  `source_system` STRING COMMENT 'Name of the upstream system (e.g., OpenLink Endur) that supplied the curve data.',
  `status` STRING COMMENT 'Current lifecycle status of the price curve.',
  `timezone` STRING COMMENT 'Time zone identifier (e.g., America/Los_Angeles) for timestamp alignment.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the curve record.',
  `version_number` INT COMMENT 'Incremental version of the curve definition for change management.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_price_curve` PRIMARY KEY (`price_curve_id`)
)
USING DELTA
COMMENT 'Master reference table for price_curve. Referenced by price_curve_id. | CMM: CIM Curve (close), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PriceCurve',
  'cmm.cim.class' = 'Curve',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.price_curve'
);

-- MasterAgreement  <<CIM Agreement : extension>>
CREATE TABLE IF NOT EXISTS `trading`.`master_agreement` (
  `master_agreement_id` BIGINT NOT NULL COMMENT 'Primary key for master_agreement',
  `counterparty_id` BIGINT COMMENT 'Unique identifier of the counter-party (trader, generator, load-servicer) associated with the agreement.',
  `superseded_master_agreement_id` BIGINT COMMENT 'Self-referencing FK on master_agreement (superseded_master_agreement_id)',
  `agreement_name` STRING COMMENT 'Human-readable name or title of the agreement.',
  `agreement_number` STRING COMMENT 'External reference number assigned to the agreement by the trading system.',
  `agreement_type` STRING COMMENT 'Classification of the contract (e.g., Power Purchase Agreement, bilateral trade, spot market, futures, capacity, ancillary services).',
  `compliance_status` STRING COMMENT 'Current compliance posture of the agreement with respect to FERC/NAESB reporting requirements.',
  `contract_amount` DECIMAL(18,2) COMMENT 'Total monetary value of the agreement, expressed in the contract currency.',
  `contract_currency` STRING COMMENT 'ISO 4217 three-letter currency code used for monetary amounts in the agreement.',
  `created_timestamp` TIMESTAMP COMMENT 'Date-time when the master agreement record was first created in the system.',
  `delivery_end_date` DATE COMMENT 'Last date on which the contracted energy delivery ends.',
  `delivery_point` STRING COMMENT 'Identifier of the physical or virtual hub where energy is delivered or received.',
  `delivery_start_date` DATE COMMENT 'First date on which the contracted energy delivery begins.',
  `effective_end_date` DATE COMMENT 'Date on which the agreement terminates or expires; null for open-ended contracts.',
  `effective_start_date` DATE COMMENT 'Date on which the agreement becomes legally binding.',
  `last_amended_by` STRING COMMENT 'User identifier of the person who performed the most recent update.',
  `payment_terms` STRING COMMENT 'Standard payment condition applied to invoices generated from the agreement.',
  `price_per_mwh` DECIMAL(12,5) COMMENT 'Unit price of energy in the contract, expressed in the contract currency per megawatt-hour.',
  `pricing_mechanism` STRING COMMENT 'Method used to calculate energy price under the agreement.',
  `regulatory_reporting_flag` BOOLEAN COMMENT 'Indicates whether the agreement must be included in mandatory market-settlement or FERC reports.',
  `remarks` STRING COMMENT 'Free-form comments or notes about the agreement.',
  `renewal_option` STRING COMMENT 'Indicates whether the agreement auto-renews, requires manual renewal, or does not renew.',
  `settlement_cycle` STRING COMMENT 'Frequency at which financial settlement occurs for the contract.',
  `status` STRING COMMENT 'Current lifecycle state of the agreement.',
  `termination_notice_period_days` INT COMMENT 'Number of days the party must notify the counter-party before terminating the agreement.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date-time of the most recent modification to the master agreement record.',
  `volume_mwh` DECIMAL(12,3) COMMENT 'Total energy volume committed under the agreement, measured in megawatt-hours.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_master_agreement` PRIMARY KEY (`master_agreement_id`)
)
USING DELTA
COMMENT 'Master reference table for master_agreement. Referenced by master_agreement_id. | CMM: CIM Agreement (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MasterAgreement',
  'cmm.cim.class' = 'Agreement',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.master_agreement'
);

-- TradingLegalEntity  <<CIM Organisation : close>>
CREATE TABLE IF NOT EXISTS `trading`.`legal_entity` (
  `legal_entity_id` BIGINT NOT NULL COMMENT 'Primary key for legal_entity',
  `parent_legal_entity_id` BIGINT COMMENT 'Identifier of the immediate parent entity in corporate hierarchy.',
  `ultimate_parent_id` BIGINT COMMENT 'Identifier of the top-most parent entity in the corporate structure.',
  `address_line1` STRING COMMENT 'First line of the entity\'s primary address.',
  `address_line2` STRING COMMENT 'Second line of the entity\'s primary address, if applicable.',
  `business_line` STRING COMMENT 'Specific line of business the entity participates in.',
  `city` STRING COMMENT 'City of the entity\'s primary registration address.',
  `classification` STRING COMMENT 'High-level classification of the legal entity within the trading ecosystem.',
  `compliance_status` STRING COMMENT 'Current compliance standing of the entity with applicable market rules.',
  `country_of_incorporation` STRING COMMENT 'ISO 3166-1 alpha-3 code of the country where the entity was incorporated.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the legal entity record was first created.',
  `credit_limit` DECIMAL(18,2) COMMENT 'Maximum credit exposure the firm is willing to extend to the entity.',
  `credit_rating` STRING COMMENT 'External credit rating of the entity. Reference-value candidates: AAA|AA|A|BBB|BB|B|CCC|CC|C|D.',
  `currency_code` STRING COMMENT 'Default currency used for transactions with the entity.',
  `data_source_system` STRING COMMENT 'System of record that originally supplied the entity data.',
  `default_probability` DECIMAL(5,4) COMMENT 'Probability of default for the entity as calculated by risk models.',
  `duns_number` STRING COMMENT 'Unique DUNS number assigned to the entity.',
  `effective_end_date` DATE COMMENT 'Date when the entity was deactivated or ceased operations (null if still active).',
  `effective_start_date` DATE COMMENT 'Date when the entity became active in the system.',
  `email_address` STRING COMMENT 'Primary business email address for the entity.',
  `exposure_limit` DECIMAL(18,2) COMMENT 'Maximum aggregate exposure allowed for the entity across all trading positions.',
  `industry_code` STRING COMMENT 'NAICS code representing the primary industry of the entity. Reference-value candidates: 2211|2212|2213|....',
  `legal_entity_identifier` STRING COMMENT 'Global identifier for the legal entity as defined by ISO 17442.',
  `legal_entity_type` STRING COMMENT 'Category describing the legal form of the entity.',
  `legal_name` STRING COMMENT 'Official registered name of the legal entity.',
  `phone_number` STRING COMMENT 'Primary business telephone number for the entity.',
  `postal_code` STRING COMMENT 'Postal / ZIP code of the entity\'s primary address.',
  `primary_contact_email` STRING COMMENT 'Email address of the primary contact person.',
  `primary_contact_name` STRING COMMENT 'Name of the primary contact person for the entity.',
  `primary_contact_phone` STRING COMMENT 'Phone number of the primary contact person.',
  `primary_contact_role` STRING COMMENT 'Business role of the primary contact within the entity.',
  `registration_number` STRING COMMENT 'State or jurisdiction registration number of the entity.',
  `regulatory_status` STRING COMMENT 'Regulatory registration status of the entity.',
  `risk_rating` STRING COMMENT 'Internal risk rating assigned to the entity. Reference-value candidates: AAA|AA|A|BBB|BB|B|CCC|CC|C|D.',
  `sector` STRING COMMENT 'Broad business sector in which the entity operates.',
  `settlement_cycle` STRING COMMENT 'Frequency at which settlements are performed with the entity.',
  `settlement_method` STRING COMMENT 'Preferred method for settling financial obligations with the entity.',
  `short_name` STRING COMMENT 'Abbreviated or commonly used name for the legal entity.',
  `state_province` STRING COMMENT 'State or province of the entity\'s primary registration address.',
  `status` STRING COMMENT 'Current operational status of the legal entity.',
  `tax_exempt_flag` BOOLEAN COMMENT 'Indicates whether the entity is exempt from certain taxes.',
  `tax_identifier` STRING COMMENT 'Government-issued tax identification number for the entity.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the legal entity record.',
  `website_url` STRING COMMENT 'Public website URL of the entity.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_trading_legal_entity` PRIMARY KEY (`legal_entity_id`)
)
USING DELTA
COMMENT 'Master reference table for legal_entity. Referenced by legal_entity_id. | CMM: CIM Organisation (close), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'TradingLegalEntity',
  'cmm.cim.class' = 'Organisation',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.trading.legal_entity'
);

-- ========= FOREIGN KEYS within trading (112) =========
ALTER TABLE `trading`.`trade` DROP CONSTRAINT IF EXISTS `fk_trading_trade_book_id`;
ALTER TABLE `trading`.`trade` ADD CONSTRAINT `fk_trading_trade_book_id` FOREIGN KEY (`book_id`) REFERENCES `trading`.`book` (`book_id`);

ALTER TABLE `trading`.`trade` DROP CONSTRAINT IF EXISTS `fk_trading_trade_counterparty_id`;
ALTER TABLE `trading`.`trade` ADD CONSTRAINT `fk_trading_trade_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`trade` DROP CONSTRAINT IF EXISTS `fk_trading_trade_hedge_strategy_id`;
ALTER TABLE `trading`.`trade` ADD CONSTRAINT `fk_trading_trade_hedge_strategy_id` FOREIGN KEY (`hedge_strategy_id`) REFERENCES `trading`.`hedge_strategy` (`hedge_strategy_id`);

ALTER TABLE `trading`.`trade` DROP CONSTRAINT IF EXISTS `fk_trading_trade_master_agreement_id`;
ALTER TABLE `trading`.`trade` ADD CONSTRAINT `fk_trading_trade_master_agreement_id` FOREIGN KEY (`master_agreement_id`) REFERENCES `trading`.`master_agreement` (`master_agreement_id`);

ALTER TABLE `trading`.`trade` DROP CONSTRAINT IF EXISTS `fk_trading_trade_scheduling_coordinator_id`;
ALTER TABLE `trading`.`trade` ADD CONSTRAINT `fk_trading_trade_scheduling_coordinator_id` FOREIGN KEY (`scheduling_coordinator_id`) REFERENCES `trading`.`scheduling_coordinator` (`scheduling_coordinator_id`);

ALTER TABLE `trading`.`trade` DROP CONSTRAINT IF EXISTS `fk_trading_trade_to_counterparty_id`;
ALTER TABLE `trading`.`trade` ADD CONSTRAINT `fk_trading_trade_to_counterparty_id` FOREIGN KEY (`to_counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`trade` DROP CONSTRAINT IF EXISTS `fk_trading_trade_trade_broker_counterparty_id`;
ALTER TABLE `trading`.`trade` ADD CONSTRAINT `fk_trading_trade_trade_broker_counterparty_id` FOREIGN KEY (`trade_broker_counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`trade` DROP CONSTRAINT IF EXISTS `fk_trading_trade_trade_counterparty_id`;
ALTER TABLE `trading`.`trade` ADD CONSTRAINT `fk_trading_trade_trade_counterparty_id` FOREIGN KEY (`trade_counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`trade_leg` DROP CONSTRAINT IF EXISTS `fk_trading_trade_leg_counterparty_id`;
ALTER TABLE `trading`.`trade_leg` ADD CONSTRAINT `fk_trading_trade_leg_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`trade_leg` DROP CONSTRAINT IF EXISTS `fk_trading_trade_leg_primary_trade_id`;
ALTER TABLE `trading`.`trade_leg` ADD CONSTRAINT `fk_trading_trade_leg_primary_trade_id` FOREIGN KEY (`primary_trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `trading`.`trade_leg` DROP CONSTRAINT IF EXISTS `fk_trading_trade_leg_scheduling_coordinator_id`;
ALTER TABLE `trading`.`trade_leg` ADD CONSTRAINT `fk_trading_trade_leg_scheduling_coordinator_id` FOREIGN KEY (`scheduling_coordinator_id`) REFERENCES `trading`.`scheduling_coordinator` (`scheduling_coordinator_id`);

ALTER TABLE `trading`.`trade_leg` DROP CONSTRAINT IF EXISTS `fk_trading_trade_leg_to_trade_id`;
ALTER TABLE `trading`.`trade_leg` ADD CONSTRAINT `fk_trading_trade_leg_to_trade_id` FOREIGN KEY (`to_trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `trading`.`trading_position` DROP CONSTRAINT IF EXISTS `fk_trading_trading_position_book_id`;
ALTER TABLE `trading`.`trading_position` ADD CONSTRAINT `fk_trading_trading_position_book_id` FOREIGN KEY (`book_id`) REFERENCES `trading`.`book` (`book_id`);

ALTER TABLE `trading`.`trading_position` DROP CONSTRAINT IF EXISTS `fk_trading_trading_position_contract_id`;
ALTER TABLE `trading`.`trading_position` ADD CONSTRAINT `fk_trading_trading_position_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `trading`.`contract` (`contract_id`);

ALTER TABLE `trading`.`trading_position` DROP CONSTRAINT IF EXISTS `fk_trading_trading_position_counterparty_id`;
ALTER TABLE `trading`.`trading_position` ADD CONSTRAINT `fk_trading_trading_position_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`trading_position` DROP CONSTRAINT IF EXISTS `fk_trading_trading_position_delivery_point_id`;
ALTER TABLE `trading`.`trading_position` ADD CONSTRAINT `fk_trading_trading_position_delivery_point_id` FOREIGN KEY (`delivery_point_id`) REFERENCES `trading`.`delivery_point` (`delivery_point_id`);

ALTER TABLE `trading`.`trading_position` DROP CONSTRAINT IF EXISTS `fk_trading_trading_position_lmp_price_id`;
ALTER TABLE `trading`.`trading_position` ADD CONSTRAINT `fk_trading_trading_position_lmp_price_id` FOREIGN KEY (`lmp_price_id`) REFERENCES `trading`.`lmp_price` (`lmp_price_id`);

ALTER TABLE `trading`.`trading_position` DROP CONSTRAINT IF EXISTS `fk_trading_trading_position_portfolio_id`;
ALTER TABLE `trading`.`trading_position` ADD CONSTRAINT `fk_trading_trading_position_portfolio_id` FOREIGN KEY (`portfolio_id`) REFERENCES `trading`.`portfolio` (`portfolio_id`);

ALTER TABLE `trading`.`trading_position` DROP CONSTRAINT IF EXISTS `fk_trading_trading_position_price_curve_id`;
ALTER TABLE `trading`.`trading_position` ADD CONSTRAINT `fk_trading_trading_position_price_curve_id` FOREIGN KEY (`price_curve_id`) REFERENCES `trading`.`price_curve` (`price_curve_id`);

ALTER TABLE `trading`.`trading_position` DROP CONSTRAINT IF EXISTS `fk_trading_trading_position_trade_id`;
ALTER TABLE `trading`.`trading_position` ADD CONSTRAINT `fk_trading_trading_position_trade_id` FOREIGN KEY (`trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `trading`.`ppa` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_counterparty_id`;
ALTER TABLE `trading`.`ppa` ADD CONSTRAINT `fk_trading_ppa_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`ppa` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_delivery_point_id`;
ALTER TABLE `trading`.`ppa` ADD CONSTRAINT `fk_trading_ppa_delivery_point_id` FOREIGN KEY (`delivery_point_id`) REFERENCES `trading`.`delivery_point` (`delivery_point_id`);

ALTER TABLE `trading`.`ppa` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_ppa_counterparty_id`;
ALTER TABLE `trading`.`ppa` ADD CONSTRAINT `fk_trading_ppa_ppa_counterparty_id` FOREIGN KEY (`ppa_counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`ppa` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_scheduling_coordinator_id`;
ALTER TABLE `trading`.`ppa` ADD CONSTRAINT `fk_trading_ppa_scheduling_coordinator_id` FOREIGN KEY (`scheduling_coordinator_id`) REFERENCES `trading`.`scheduling_coordinator` (`scheduling_coordinator_id`);

ALTER TABLE `trading`.`ppa` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_to_counterparty_id`;
ALTER TABLE `trading`.`ppa` ADD CONSTRAINT `fk_trading_ppa_to_counterparty_id` FOREIGN KEY (`to_counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`ppa_delivery` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_delivery_delivery_point_id`;
ALTER TABLE `trading`.`ppa_delivery` ADD CONSTRAINT `fk_trading_ppa_delivery_delivery_point_id` FOREIGN KEY (`delivery_point_id`) REFERENCES `trading`.`delivery_point` (`delivery_point_id`);

ALTER TABLE `trading`.`ppa_delivery` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_delivery_ppa_id`;
ALTER TABLE `trading`.`ppa_delivery` ADD CONSTRAINT `fk_trading_ppa_delivery_ppa_id` FOREIGN KEY (`ppa_id`) REFERENCES `trading`.`ppa` (`ppa_id`);

ALTER TABLE `trading`.`ppa_delivery` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_delivery_scheduling_coordinator_id`;
ALTER TABLE `trading`.`ppa_delivery` ADD CONSTRAINT `fk_trading_ppa_delivery_scheduling_coordinator_id` FOREIGN KEY (`scheduling_coordinator_id`) REFERENCES `trading`.`scheduling_coordinator` (`scheduling_coordinator_id`);

ALTER TABLE `trading`.`market_bid` DROP CONSTRAINT IF EXISTS `fk_trading_market_bid_book_id`;
ALTER TABLE `trading`.`market_bid` ADD CONSTRAINT `fk_trading_market_bid_book_id` FOREIGN KEY (`book_id`) REFERENCES `trading`.`book` (`book_id`);

ALTER TABLE `trading`.`market_bid` DROP CONSTRAINT IF EXISTS `fk_trading_market_bid_counterparty_id`;
ALTER TABLE `trading`.`market_bid` ADD CONSTRAINT `fk_trading_market_bid_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`market_bid` DROP CONSTRAINT IF EXISTS `fk_trading_market_bid_scheduling_coordinator_id`;
ALTER TABLE `trading`.`market_bid` ADD CONSTRAINT `fk_trading_market_bid_scheduling_coordinator_id` FOREIGN KEY (`scheduling_coordinator_id`) REFERENCES `trading`.`scheduling_coordinator` (`scheduling_coordinator_id`);

ALTER TABLE `trading`.`market_award` DROP CONSTRAINT IF EXISTS `fk_trading_market_award_energy_schedule_id`;
ALTER TABLE `trading`.`market_award` ADD CONSTRAINT `fk_trading_market_award_energy_schedule_id` FOREIGN KEY (`energy_schedule_id`) REFERENCES `trading`.`energy_schedule` (`energy_schedule_id`);

ALTER TABLE `trading`.`market_award` DROP CONSTRAINT IF EXISTS `fk_trading_market_award_lmp_price_id`;
ALTER TABLE `trading`.`market_award` ADD CONSTRAINT `fk_trading_market_award_lmp_price_id` FOREIGN KEY (`lmp_price_id`) REFERENCES `trading`.`lmp_price` (`lmp_price_id`);

ALTER TABLE `trading`.`market_award` DROP CONSTRAINT IF EXISTS `fk_trading_market_award_market_bid_id`;
ALTER TABLE `trading`.`market_award` ADD CONSTRAINT `fk_trading_market_award_market_bid_id` FOREIGN KEY (`market_bid_id`) REFERENCES `trading`.`market_bid` (`market_bid_id`);

ALTER TABLE `trading`.`market_award` DROP CONSTRAINT IF EXISTS `fk_trading_market_award_market_participant_id`;
ALTER TABLE `trading`.`market_award` ADD CONSTRAINT `fk_trading_market_award_market_participant_id` FOREIGN KEY (`market_participant_id`) REFERENCES `trading`.`market_participant` (`market_participant_id`);

ALTER TABLE `trading`.`market_award` DROP CONSTRAINT IF EXISTS `fk_trading_market_award_pnode_id`;
ALTER TABLE `trading`.`market_award` ADD CONSTRAINT `fk_trading_market_award_pnode_id` FOREIGN KEY (`pnode_id`) REFERENCES `trading`.`pnode` (`pnode_id`);

ALTER TABLE `trading`.`market_award` DROP CONSTRAINT IF EXISTS `fk_trading_market_award_primary_market_bid_id`;
ALTER TABLE `trading`.`market_award` ADD CONSTRAINT `fk_trading_market_award_primary_market_bid_id` FOREIGN KEY (`primary_market_bid_id`) REFERENCES `trading`.`market_bid` (`market_bid_id`);

ALTER TABLE `trading`.`market_award` DROP CONSTRAINT IF EXISTS `fk_trading_market_award_settlement_statement_id`;
ALTER TABLE `trading`.`market_award` ADD CONSTRAINT `fk_trading_market_award_settlement_statement_id` FOREIGN KEY (`settlement_statement_id`) REFERENCES `trading`.`settlement_statement` (`settlement_statement_id`);

ALTER TABLE `trading`.`market_award` DROP CONSTRAINT IF EXISTS `fk_trading_market_award_transmission_constraint_id`;
ALTER TABLE `trading`.`market_award` ADD CONSTRAINT `fk_trading_market_award_transmission_constraint_id` FOREIGN KEY (`transmission_constraint_id`) REFERENCES `trading`.`transmission_constraint` (`transmission_constraint_id`);

ALTER TABLE `trading`.`lmp_price` DROP CONSTRAINT IF EXISTS `fk_trading_lmp_price_market_run_id`;
ALTER TABLE `trading`.`lmp_price` ADD CONSTRAINT `fk_trading_lmp_price_market_run_id` FOREIGN KEY (`market_run_id`) REFERENCES `trading`.`market_run` (`market_run_id`);

ALTER TABLE `trading`.`lmp_price` DROP CONSTRAINT IF EXISTS `fk_trading_lmp_price_pnode_id`;
ALTER TABLE `trading`.`lmp_price` ADD CONSTRAINT `fk_trading_lmp_price_pnode_id` FOREIGN KEY (`pnode_id`) REFERENCES `trading`.`pnode` (`pnode_id`);

ALTER TABLE `trading`.`energy_schedule` DROP CONSTRAINT IF EXISTS `fk_trading_energy_schedule_counterparty_id`;
ALTER TABLE `trading`.`energy_schedule` ADD CONSTRAINT `fk_trading_energy_schedule_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`energy_schedule` DROP CONSTRAINT IF EXISTS `fk_trading_energy_schedule_energy_scheduling_coordinator_id`;
ALTER TABLE `trading`.`energy_schedule` ADD CONSTRAINT `fk_trading_energy_schedule_energy_scheduling_coordinator_id` FOREIGN KEY (`energy_scheduling_coordinator_id`) REFERENCES `trading`.`scheduling_coordinator` (`scheduling_coordinator_id`);

ALTER TABLE `trading`.`energy_schedule` DROP CONSTRAINT IF EXISTS `fk_trading_energy_schedule_market_participant_id`;
ALTER TABLE `trading`.`energy_schedule` ADD CONSTRAINT `fk_trading_energy_schedule_market_participant_id` FOREIGN KEY (`market_participant_id`) REFERENCES `trading`.`market_participant` (`market_participant_id`);

ALTER TABLE `trading`.`energy_schedule` DROP CONSTRAINT IF EXISTS `fk_trading_energy_schedule_scheduling_coordinator_id`;
ALTER TABLE `trading`.`energy_schedule` ADD CONSTRAINT `fk_trading_energy_schedule_scheduling_coordinator_id` FOREIGN KEY (`scheduling_coordinator_id`) REFERENCES `trading`.`scheduling_coordinator` (`scheduling_coordinator_id`);

ALTER TABLE `trading`.`energy_schedule` DROP CONSTRAINT IF EXISTS `fk_trading_energy_schedule_trade_id`;
ALTER TABLE `trading`.`energy_schedule` ADD CONSTRAINT `fk_trading_energy_schedule_trade_id` FOREIGN KEY (`trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `trading`.`energy_schedule` DROP CONSTRAINT IF EXISTS `fk_trading_energy_schedule_trading_position_id`;
ALTER TABLE `trading`.`energy_schedule` ADD CONSTRAINT `fk_trading_energy_schedule_trading_position_id` FOREIGN KEY (`trading_position_id`) REFERENCES `trading`.`trading_position` (`trading_position_id`);

ALTER TABLE `trading`.`market_settlement` DROP CONSTRAINT IF EXISTS `fk_trading_market_settlement_contract_id`;
ALTER TABLE `trading`.`market_settlement` ADD CONSTRAINT `fk_trading_market_settlement_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `trading`.`contract` (`contract_id`);

ALTER TABLE `trading`.`market_settlement` DROP CONSTRAINT IF EXISTS `fk_trading_market_settlement_counterparty_id`;
ALTER TABLE `trading`.`market_settlement` ADD CONSTRAINT `fk_trading_market_settlement_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`market_settlement` DROP CONSTRAINT IF EXISTS `fk_trading_market_settlement_ftr_holding_id`;
ALTER TABLE `trading`.`market_settlement` ADD CONSTRAINT `fk_trading_market_settlement_ftr_holding_id` FOREIGN KEY (`ftr_holding_id`) REFERENCES `trading`.`ftr_holding` (`ftr_holding_id`);

ALTER TABLE `trading`.`market_settlement` DROP CONSTRAINT IF EXISTS `fk_trading_market_settlement_market_award_id`;
ALTER TABLE `trading`.`market_settlement` ADD CONSTRAINT `fk_trading_market_settlement_market_award_id` FOREIGN KEY (`market_award_id`) REFERENCES `trading`.`market_award` (`market_award_id`);

ALTER TABLE `trading`.`market_settlement` DROP CONSTRAINT IF EXISTS `fk_trading_market_settlement_market_bid_id`;
ALTER TABLE `trading`.`market_settlement` ADD CONSTRAINT `fk_trading_market_settlement_market_bid_id` FOREIGN KEY (`market_bid_id`) REFERENCES `trading`.`market_bid` (`market_bid_id`);

ALTER TABLE `trading`.`market_settlement` DROP CONSTRAINT IF EXISTS `fk_trading_market_settlement_market_participant_id`;
ALTER TABLE `trading`.`market_settlement` ADD CONSTRAINT `fk_trading_market_settlement_market_participant_id` FOREIGN KEY (`market_participant_id`) REFERENCES `trading`.`market_participant` (`market_participant_id`);

ALTER TABLE `trading`.`market_settlement` DROP CONSTRAINT IF EXISTS `fk_trading_market_settlement_market_trade_id`;
ALTER TABLE `trading`.`market_settlement` ADD CONSTRAINT `fk_trading_market_settlement_market_trade_id` FOREIGN KEY (`market_trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `trading`.`market_settlement` DROP CONSTRAINT IF EXISTS `fk_trading_market_settlement_ppa_id`;
ALTER TABLE `trading`.`market_settlement` ADD CONSTRAINT `fk_trading_market_settlement_ppa_id` FOREIGN KEY (`ppa_id`) REFERENCES `trading`.`ppa` (`ppa_id`);

ALTER TABLE `trading`.`market_settlement` DROP CONSTRAINT IF EXISTS `fk_trading_market_settlement_trade_id`;
ALTER TABLE `trading`.`market_settlement` ADD CONSTRAINT `fk_trading_market_settlement_trade_id` FOREIGN KEY (`trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `trading`.`market_settlement` DROP CONSTRAINT IF EXISTS `fk_trading_market_settlement_transaction_trade_id`;
ALTER TABLE `trading`.`market_settlement` ADD CONSTRAINT `fk_trading_market_settlement_transaction_trade_id` FOREIGN KEY (`transaction_trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `trading`.`credit_exposure` DROP CONSTRAINT IF EXISTS `fk_trading_credit_exposure_counterparty_id`;
ALTER TABLE `trading`.`credit_exposure` ADD CONSTRAINT `fk_trading_credit_exposure_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`credit_exposure` DROP CONSTRAINT IF EXISTS `fk_trading_credit_exposure_credit_counterparty_id`;
ALTER TABLE `trading`.`credit_exposure` ADD CONSTRAINT `fk_trading_credit_exposure_credit_counterparty_id` FOREIGN KEY (`credit_counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`credit_exposure` DROP CONSTRAINT IF EXISTS `fk_trading_credit_exposure_credit_for_counterparty`;
ALTER TABLE `trading`.`credit_exposure` ADD CONSTRAINT `fk_trading_credit_exposure_credit_for_counterparty` FOREIGN KEY (`credit_for_counterparty`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`credit_exposure` DROP CONSTRAINT IF EXISTS `fk_trading_credit_exposure_netting_agreement_id`;
ALTER TABLE `trading`.`credit_exposure` ADD CONSTRAINT `fk_trading_credit_exposure_netting_agreement_id` FOREIGN KEY (`netting_agreement_id`) REFERENCES `trading`.`netting_agreement` (`netting_agreement_id`);

ALTER TABLE `trading`.`credit_exposure` DROP CONSTRAINT IF EXISTS `fk_trading_credit_exposure_to_counterparty_id`;
ALTER TABLE `trading`.`credit_exposure` ADD CONSTRAINT `fk_trading_credit_exposure_to_counterparty_id` FOREIGN KEY (`to_counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`credit_exposure` DROP CONSTRAINT IF EXISTS `fk_trading_credit_exposure_trading_desk_id`;
ALTER TABLE `trading`.`credit_exposure` ADD CONSTRAINT `fk_trading_credit_exposure_trading_desk_id` FOREIGN KEY (`trading_desk_id`) REFERENCES `trading`.`trading_desk` (`trading_desk_id`);

ALTER TABLE `trading`.`ftr_holding` DROP CONSTRAINT IF EXISTS `fk_trading_ftr_holding_counterparty_id`;
ALTER TABLE `trading`.`ftr_holding` ADD CONSTRAINT `fk_trading_ftr_holding_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`ftr_holding` DROP CONSTRAINT IF EXISTS `fk_trading_ftr_holding_hedge_strategy_id`;
ALTER TABLE `trading`.`ftr_holding` ADD CONSTRAINT `fk_trading_ftr_holding_hedge_strategy_id` FOREIGN KEY (`hedge_strategy_id`) REFERENCES `trading`.`hedge_strategy` (`hedge_strategy_id`);

ALTER TABLE `trading`.`ftr_holding` DROP CONSTRAINT IF EXISTS `fk_trading_ftr_holding_portfolio_id`;
ALTER TABLE `trading`.`ftr_holding` ADD CONSTRAINT `fk_trading_ftr_holding_portfolio_id` FOREIGN KEY (`portfolio_id`) REFERENCES `trading`.`portfolio` (`portfolio_id`);

ALTER TABLE `trading`.`ftr_holding` DROP CONSTRAINT IF EXISTS `fk_trading_ftr_holding_sink_pnode_id`;
ALTER TABLE `trading`.`ftr_holding` ADD CONSTRAINT `fk_trading_ftr_holding_sink_pnode_id` FOREIGN KEY (`sink_pnode_id`) REFERENCES `trading`.`pnode` (`pnode_id`);

ALTER TABLE `trading`.`ftr_holding` DROP CONSTRAINT IF EXISTS `fk_trading_ftr_holding_source_pnode_id`;
ALTER TABLE `trading`.`ftr_holding` ADD CONSTRAINT `fk_trading_ftr_holding_source_pnode_id` FOREIGN KEY (`source_pnode_id`) REFERENCES `trading`.`pnode` (`pnode_id`);

ALTER TABLE `trading`.`rec_holding` DROP CONSTRAINT IF EXISTS `fk_trading_rec_holding_counterparty_id`;
ALTER TABLE `trading`.`rec_holding` ADD CONSTRAINT `fk_trading_rec_holding_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`rec_transaction` DROP CONSTRAINT IF EXISTS `fk_trading_rec_transaction_counterparty_id`;
ALTER TABLE `trading`.`rec_transaction` ADD CONSTRAINT `fk_trading_rec_transaction_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`rec_transaction` DROP CONSTRAINT IF EXISTS `fk_trading_rec_transaction_rec_holding_id`;
ALTER TABLE `trading`.`rec_transaction` ADD CONSTRAINT `fk_trading_rec_transaction_rec_holding_id` FOREIGN KEY (`rec_holding_id`) REFERENCES `trading`.`rec_holding` (`rec_holding_id`);

ALTER TABLE `trading`.`ancillary_service_award` DROP CONSTRAINT IF EXISTS `fk_trading_ancillary_service_award_contract_id`;
ALTER TABLE `trading`.`ancillary_service_award` ADD CONSTRAINT `fk_trading_ancillary_service_award_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `trading`.`contract` (`contract_id`);

ALTER TABLE `trading`.`ancillary_service_award` DROP CONSTRAINT IF EXISTS `fk_trading_ancillary_service_award_counterparty_id`;
ALTER TABLE `trading`.`ancillary_service_award` ADD CONSTRAINT `fk_trading_ancillary_service_award_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`ancillary_service_award` DROP CONSTRAINT IF EXISTS `fk_trading_ancillary_service_award_scheduling_coordinator_id`;
ALTER TABLE `trading`.`ancillary_service_award` ADD CONSTRAINT `fk_trading_ancillary_service_award_scheduling_coordinator_id` FOREIGN KEY (`scheduling_coordinator_id`) REFERENCES `trading`.`scheduling_coordinator` (`scheduling_coordinator_id`);

ALTER TABLE `trading`.`ancillary_service_award` DROP CONSTRAINT IF EXISTS `fk_trading_ancillary_service_award_settlement_statement_id`;
ALTER TABLE `trading`.`ancillary_service_award` ADD CONSTRAINT `fk_trading_ancillary_service_award_settlement_statement_id` FOREIGN KEY (`settlement_statement_id`) REFERENCES `trading`.`settlement_statement` (`settlement_statement_id`);

ALTER TABLE `trading`.`book` DROP CONSTRAINT IF EXISTS `fk_trading_book_legal_entity_id`;
ALTER TABLE `trading`.`book` ADD CONSTRAINT `fk_trading_book_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `trading`.`legal_entity` (`legal_entity_id`);

ALTER TABLE `trading`.`book` DROP CONSTRAINT IF EXISTS `fk_trading_book_market_participant_id`;
ALTER TABLE `trading`.`book` ADD CONSTRAINT `fk_trading_book_market_participant_id` FOREIGN KEY (`market_participant_id`) REFERENCES `trading`.`market_participant` (`market_participant_id`);

ALTER TABLE `trading`.`book` DROP CONSTRAINT IF EXISTS `fk_trading_book_trading_desk_id`;
ALTER TABLE `trading`.`book` ADD CONSTRAINT `fk_trading_book_trading_desk_id` FOREIGN KEY (`trading_desk_id`) REFERENCES `trading`.`trading_desk` (`trading_desk_id`);

ALTER TABLE `trading`.`ferc_eqr_filing` DROP CONSTRAINT IF EXISTS `fk_trading_ferc_eqr_filing_counterparty_id`;
ALTER TABLE `trading`.`ferc_eqr_filing` ADD CONSTRAINT `fk_trading_ferc_eqr_filing_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`ferc_eqr_filing` DROP CONSTRAINT IF EXISTS `fk_trading_ferc_eqr_filing_ferc_counterparty_id`;
ALTER TABLE `trading`.`ferc_eqr_filing` ADD CONSTRAINT `fk_trading_ferc_eqr_filing_ferc_counterparty_id` FOREIGN KEY (`ferc_counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`ferc_eqr_filing` DROP CONSTRAINT IF EXISTS `fk_trading_ferc_eqr_filing_ferc_trade_id`;
ALTER TABLE `trading`.`ferc_eqr_filing` ADD CONSTRAINT `fk_trading_ferc_eqr_filing_ferc_trade_id` FOREIGN KEY (`ferc_trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `trading`.`ferc_eqr_filing` DROP CONSTRAINT IF EXISTS `fk_trading_ferc_eqr_filing_original_filing_ferc_eqr_filing_id`;
ALTER TABLE `trading`.`ferc_eqr_filing` ADD CONSTRAINT `fk_trading_ferc_eqr_filing_original_filing_ferc_eqr_filing_id` FOREIGN KEY (`original_filing_ferc_eqr_filing_id`) REFERENCES `trading`.`ferc_eqr_filing` (`ferc_eqr_filing_id`);

ALTER TABLE `trading`.`ferc_eqr_filing` DROP CONSTRAINT IF EXISTS `fk_trading_ferc_eqr_filing_primary_counterparty_id`;
ALTER TABLE `trading`.`ferc_eqr_filing` ADD CONSTRAINT `fk_trading_ferc_eqr_filing_primary_counterparty_id` FOREIGN KEY (`primary_counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`ferc_eqr_filing` DROP CONSTRAINT IF EXISTS `fk_trading_ferc_eqr_filing_primary_trade_id`;
ALTER TABLE `trading`.`ferc_eqr_filing` ADD CONSTRAINT `fk_trading_ferc_eqr_filing_primary_trade_id` FOREIGN KEY (`primary_trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `trading`.`ferc_eqr_filing` DROP CONSTRAINT IF EXISTS `fk_trading_ferc_eqr_filing_trade_id`;
ALTER TABLE `trading`.`ferc_eqr_filing` ADD CONSTRAINT `fk_trading_ferc_eqr_filing_trade_id` FOREIGN KEY (`trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `trading`.`hedge_strategy` DROP CONSTRAINT IF EXISTS `fk_trading_hedge_strategy_book_id`;
ALTER TABLE `trading`.`hedge_strategy` ADD CONSTRAINT `fk_trading_hedge_strategy_book_id` FOREIGN KEY (`book_id`) REFERENCES `trading`.`book` (`book_id`);

ALTER TABLE `trading`.`capacity_obligation` DROP CONSTRAINT IF EXISTS `fk_trading_capacity_obligation_bilateral_counterparty_id`;
ALTER TABLE `trading`.`capacity_obligation` ADD CONSTRAINT `fk_trading_capacity_obligation_bilateral_counterparty_id` FOREIGN KEY (`bilateral_counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`capacity_obligation` DROP CONSTRAINT IF EXISTS `fk_trading_capacity_obligation_load_serving_entity_id`;
ALTER TABLE `trading`.`capacity_obligation` ADD CONSTRAINT `fk_trading_capacity_obligation_load_serving_entity_id` FOREIGN KEY (`load_serving_entity_id`) REFERENCES `trading`.`load_serving_entity` (`load_serving_entity_id`);

ALTER TABLE `trading`.`capacity_obligation` DROP CONSTRAINT IF EXISTS `fk_trading_capacity_obligation_market_bid_id`;
ALTER TABLE `trading`.`capacity_obligation` ADD CONSTRAINT `fk_trading_capacity_obligation_market_bid_id` FOREIGN KEY (`market_bid_id`) REFERENCES `trading`.`market_bid` (`market_bid_id`);

ALTER TABLE `trading`.`settlement_statement` DROP CONSTRAINT IF EXISTS `fk_trading_settlement_statement_contract_id`;
ALTER TABLE `trading`.`settlement_statement` ADD CONSTRAINT `fk_trading_settlement_statement_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `trading`.`contract` (`contract_id`);

ALTER TABLE `trading`.`settlement_statement` DROP CONSTRAINT IF EXISTS `fk_trading_settlement_statement_counterparty_id`;
ALTER TABLE `trading`.`settlement_statement` ADD CONSTRAINT `fk_trading_settlement_statement_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`settlement_statement` DROP CONSTRAINT IF EXISTS `fk_trading_settlement_statement_trade_id`;
ALTER TABLE `trading`.`settlement_statement` ADD CONSTRAINT `fk_trading_settlement_statement_trade_id` FOREIGN KEY (`trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `trading`.`settlement_statement` DROP CONSTRAINT IF EXISTS `fk_trading_settlement_statement_corrected_settlement_statement_id`;
ALTER TABLE `trading`.`settlement_statement` ADD CONSTRAINT `fk_trading_settlement_statement_corrected_settlement_statement_id` FOREIGN KEY (`corrected_settlement_statement_id`) REFERENCES `trading`.`settlement_statement` (`settlement_statement_id`);

ALTER TABLE `trading`.`contract` DROP CONSTRAINT IF EXISTS `fk_trading_contract_counterparty_id`;
ALTER TABLE `trading`.`contract` ADD CONSTRAINT `fk_trading_contract_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`contract` DROP CONSTRAINT IF EXISTS `fk_trading_contract_master_contract_id`;
ALTER TABLE `trading`.`contract` ADD CONSTRAINT `fk_trading_contract_master_contract_id` FOREIGN KEY (`master_contract_id`) REFERENCES `trading`.`contract` (`contract_id`);

ALTER TABLE `trading`.`load_serving_entity` DROP CONSTRAINT IF EXISTS `fk_trading_load_serving_entity_parent_load_serving_entity_id`;
ALTER TABLE `trading`.`load_serving_entity` ADD CONSTRAINT `fk_trading_load_serving_entity_parent_load_serving_entity_id` FOREIGN KEY (`parent_load_serving_entity_id`) REFERENCES `trading`.`load_serving_entity` (`load_serving_entity_id`);

ALTER TABLE `trading`.`netting_agreement` DROP CONSTRAINT IF EXISTS `fk_trading_netting_agreement_counterparty_id`;
ALTER TABLE `trading`.`netting_agreement` ADD CONSTRAINT `fk_trading_netting_agreement_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`netting_agreement` DROP CONSTRAINT IF EXISTS `fk_trading_netting_agreement_legal_entity_id`;
ALTER TABLE `trading`.`netting_agreement` ADD CONSTRAINT `fk_trading_netting_agreement_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `trading`.`legal_entity` (`legal_entity_id`);

ALTER TABLE `trading`.`netting_agreement` DROP CONSTRAINT IF EXISTS `fk_trading_netting_agreement_superseded_netting_agreement_id`;
ALTER TABLE `trading`.`netting_agreement` ADD CONSTRAINT `fk_trading_netting_agreement_superseded_netting_agreement_id` FOREIGN KEY (`superseded_netting_agreement_id`) REFERENCES `trading`.`netting_agreement` (`netting_agreement_id`);

ALTER TABLE `trading`.`trading_desk` DROP CONSTRAINT IF EXISTS `fk_trading_trading_desk_parent_trading_desk_id`;
ALTER TABLE `trading`.`trading_desk` ADD CONSTRAINT `fk_trading_trading_desk_parent_trading_desk_id` FOREIGN KEY (`parent_trading_desk_id`) REFERENCES `trading`.`trading_desk` (`trading_desk_id`);

ALTER TABLE `trading`.`market_participant` DROP CONSTRAINT IF EXISTS `fk_trading_market_participant_parent_market_participant_id`;
ALTER TABLE `trading`.`market_participant` ADD CONSTRAINT `fk_trading_market_participant_parent_market_participant_id` FOREIGN KEY (`parent_market_participant_id`) REFERENCES `trading`.`market_participant` (`market_participant_id`);

ALTER TABLE `trading`.`pnode` DROP CONSTRAINT IF EXISTS `fk_trading_pnode_aggregate_pnode_id`;
ALTER TABLE `trading`.`pnode` ADD CONSTRAINT `fk_trading_pnode_aggregate_pnode_id` FOREIGN KEY (`aggregate_pnode_id`) REFERENCES `trading`.`pnode` (`pnode_id`);

ALTER TABLE `trading`.`portfolio` DROP CONSTRAINT IF EXISTS `fk_trading_portfolio_parent_portfolio_id`;
ALTER TABLE `trading`.`portfolio` ADD CONSTRAINT `fk_trading_portfolio_parent_portfolio_id` FOREIGN KEY (`parent_portfolio_id`) REFERENCES `trading`.`portfolio` (`portfolio_id`);

ALTER TABLE `trading`.`market_run` DROP CONSTRAINT IF EXISTS `fk_trading_market_run_market_participant_id`;
ALTER TABLE `trading`.`market_run` ADD CONSTRAINT `fk_trading_market_run_market_participant_id` FOREIGN KEY (`market_participant_id`) REFERENCES `trading`.`market_participant` (`market_participant_id`);

ALTER TABLE `trading`.`market_run` DROP CONSTRAINT IF EXISTS `fk_trading_market_run_superseded_market_run_id`;
ALTER TABLE `trading`.`market_run` ADD CONSTRAINT `fk_trading_market_run_superseded_market_run_id` FOREIGN KEY (`superseded_market_run_id`) REFERENCES `trading`.`market_run` (`market_run_id`);

ALTER TABLE `trading`.`transmission_constraint` DROP CONSTRAINT IF EXISTS `fk_trading_transmission_constraint_parent_transmission_constraint_id`;
ALTER TABLE `trading`.`transmission_constraint` ADD CONSTRAINT `fk_trading_transmission_constraint_parent_transmission_constraint_id` FOREIGN KEY (`parent_transmission_constraint_id`) REFERENCES `trading`.`transmission_constraint` (`transmission_constraint_id`);

ALTER TABLE `trading`.`delivery_point` DROP CONSTRAINT IF EXISTS `fk_trading_delivery_point_aggregate_delivery_point_id`;
ALTER TABLE `trading`.`delivery_point` ADD CONSTRAINT `fk_trading_delivery_point_aggregate_delivery_point_id` FOREIGN KEY (`aggregate_delivery_point_id`) REFERENCES `trading`.`delivery_point` (`delivery_point_id`);

ALTER TABLE `trading`.`price_curve` DROP CONSTRAINT IF EXISTS `fk_trading_price_curve_base_price_curve_id`;
ALTER TABLE `trading`.`price_curve` ADD CONSTRAINT `fk_trading_price_curve_base_price_curve_id` FOREIGN KEY (`base_price_curve_id`) REFERENCES `trading`.`price_curve` (`price_curve_id`);

ALTER TABLE `trading`.`master_agreement` DROP CONSTRAINT IF EXISTS `fk_trading_master_agreement_counterparty_id`;
ALTER TABLE `trading`.`master_agreement` ADD CONSTRAINT `fk_trading_master_agreement_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `trading`.`master_agreement` DROP CONSTRAINT IF EXISTS `fk_trading_master_agreement_superseded_master_agreement_id`;
ALTER TABLE `trading`.`master_agreement` ADD CONSTRAINT `fk_trading_master_agreement_superseded_master_agreement_id` FOREIGN KEY (`superseded_master_agreement_id`) REFERENCES `trading`.`master_agreement` (`master_agreement_id`);

ALTER TABLE `trading`.`legal_entity` DROP CONSTRAINT IF EXISTS `fk_trading_legal_entity_parent_legal_entity_id`;
ALTER TABLE `trading`.`legal_entity` ADD CONSTRAINT `fk_trading_legal_entity_parent_legal_entity_id` FOREIGN KEY (`parent_legal_entity_id`) REFERENCES `trading`.`legal_entity` (`legal_entity_id`);

ALTER TABLE `trading`.`legal_entity` DROP CONSTRAINT IF EXISTS `fk_trading_legal_entity_ultimate_parent_id`;
ALTER TABLE `trading`.`legal_entity` ADD CONSTRAINT `fk_trading_legal_entity_ultimate_parent_id` FOREIGN KEY (`ultimate_parent_id`) REFERENCES `trading`.`legal_entity` (`legal_entity_id`);

