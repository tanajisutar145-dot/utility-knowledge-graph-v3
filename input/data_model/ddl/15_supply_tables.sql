-- Utility CMM-aligned Canonical Data Model (Silver) v1.0.0 | source: Databricks lakehouse-industry-data-models energy_utilities v1 ECM | generated 2026-10-13
-- 15 | Subject area: supply | 22 tables | CIM packages: IEC61968::InfERPSupport; IEC61968::Assets
-- Standards: IEC 61968-10; UNSPSC; ISO 8000 (master data)
-- Contents: tables (with PK + NOT NULL), then intra-subject-area foreign keys.
-- Unity Catalog PK/FK constraints are informational (NOT ENFORCED); NOT NULL is enforced.

USE CATALOG `utility_cmm_silver`;

-- MaterialMaster  <<CIM ErpItemMaster : close>>
CREATE TABLE IF NOT EXISTS `supply`.`material_master` (
  `material_master_id` BIGINT NOT NULL COMMENT 'Unique identifier for the material master record. Primary key for all utility supply chain materials including transformers, conductors, meters, poles, insulators, generation spare parts, and fuel commodities.',
  `abc_indicator` STRING COMMENT 'Classification of material value importance for inventory control. A=high value/critical, B=moderate value, C=low value/high volume. Drives cycle counting frequency and inventory management rigor. Valid values: A|B|C.',
  `base_unit_of_measure` STRING COMMENT 'Primary unit in which material quantities are managed and stored. Examples: EA (each) for transformers, FT (feet) for conductors, TON for coal, GAL for oil. Pattern: ^[A-Z]{2,3}$.',
  `batch_management_indicator` BOOLEAN COMMENT 'Flag indicating whether material is managed in batches with unique batch numbers. Enables lot traceability for quality control, recalls, and compliance (e.g., fuel batches, chemical lots).',
  `created_date` DATE COMMENT 'Date when the material master record was first created in the system. Used for master data governance and audit trails.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for material valuation prices. Typically company code currency (USD for US utilities). Pattern: ^[A-Z]{3}$.',
  `deletion_indicator` BOOLEAN COMMENT 'Flag marking material master record for deletion. Material cannot be used in new transactions but historical data is preserved for reporting and compliance.',
  `gross_weight` DECIMAL(15,3) COMMENT 'Total weight of the material including packaging, measured in the weight unit. Used for transportation planning, logistics cost calculation, and warehouse capacity planning.',
  `hazard_class` STRING COMMENT 'DOT hazard classification for transportation (e.g., Class 3 Flammable Liquids, Class 8 Corrosives). Required for shipping documentation and carrier selection.',
  `hazardous_material_indicator` BOOLEAN COMMENT 'Flag indicating whether material is classified as hazardous under OSHA, EPA, or DOT regulations. Triggers special handling, storage, and transportation requirements.',
  `industry_sector` STRING COMMENT 'Utility-specific industry sector classification indicating primary usage area. Enables sector-specific material analytics and procurement strategies. Valid values: utilities|generation|transmission|distribution.',
  `inspection_required_indicator` BOOLEAN COMMENT 'Flag indicating whether incoming goods must undergo quality inspection before being available for use. Triggers quality management workflows for critical materials.',
  `last_modified_by` STRING COMMENT 'User ID of the person who last modified the material master record. Used for accountability and audit trails.',
  `last_modified_date` DATE COMMENT 'Date when the material master record was last changed. Used for change tracking and master data governance.',
  `manufacturer_name` STRING COMMENT 'Name of the original equipment manufacturer or producer of the material. Used for quality tracking, warranty management, and approved vendor lists.',
  `manufacturer_part_number` STRING COMMENT 'Original equipment manufacturer (OEM) part number used for cross-referencing, warranty claims, and technical specifications. Critical for generation spare parts and equipment compatibility.',
  `material_description` STRING COMMENT 'Short textual description of the material for identification and selection purposes. Used in purchase orders, work orders, and inventory transactions.',
  `material_group` STRING COMMENT 'Grouping code for materials with similar characteristics used for procurement analysis, vendor selection, and reporting. Examples include transformer group, conductor group, meter group, fuel group. Pattern: ^[A-Z0-9]{4,10}$.',
  `material_number` STRING COMMENT 'Externally-known unique material identifier used across procurement, inventory, and work management systems. Serves as the business key for material identification in SAP MM and integration with asset management systems. Pattern: ^[A-Z0-9]{8,18}$.',
  `material_status` STRING COMMENT 'Current lifecycle status of the material master record. Controls whether material can be procured, issued, or used in new work orders. Phase-out and obsolete materials require substitution planning. Valid values: active|blocked|obsolete|phase_out|restricted.',
  `material_type` STRING COMMENT 'High-level classification of material controlling procurement, inventory management, and valuation behavior. Determines whether material is stocked, procured to order, or managed as a service. Reference-value candidates: raw_material|semi_finished|finished_product|trading_goods|spare_parts|services|non_stock|pipeline.',
  `maximum_stock_level` DECIMAL(13,3) COMMENT 'Upper inventory limit used in reorder point planning to prevent overstocking. Defines target stock level after replenishment.',
  `moving_average_price` DECIMAL(11,2) COMMENT 'Weighted average cost per base unit of measure, automatically recalculated with each goods receipt. Used when price control is set to moving average. Reflects actual procurement costs.',
  `mrp_type` STRING COMMENT 'Controls material planning behavior in MRP runs. Determines reorder point planning, forecast-based planning, or time-phased planning method. Pattern: ^[A-Z]{2}$.',
  `net_weight` DECIMAL(15,3) COMMENT 'Weight of the material excluding packaging, measured in the weight unit. Used for material specifications and engineering calculations.',
  `planned_delivery_time_days` INT COMMENT 'Expected number of calendar days from purchase order creation to goods receipt. Used for MRP scheduling and procurement lead time planning.',
  `plant_specific_status` STRING COMMENT 'Material status at individual plant or warehouse level, allowing different availability by location. Enables regional phase-out or location-specific restrictions.',
  `price_control_indicator` STRING COMMENT 'Determines material valuation method. S=standard price (fixed cost), V=moving average price (actual cost). Controls how material value is calculated in inventory. Valid values: S|V.',
  `price_unit` INT COMMENT 'Quantity for which the standard or moving average price is valid. Example: if price is $100 per 10 units, price unit is 10. Enables pricing per batch or bulk quantity.',
  `procurement_type` STRING COMMENT 'Indicates whether material is procured externally from vendors, produced in-house, or both. Controls procurement planning and sourcing strategy. Valid values: external|in_house|both.',
  `purchasing_group` STRING COMMENT 'Buyer or procurement team responsible for sourcing this material. Used for workload distribution, vendor negotiation responsibility, and procurement analytics. Pattern: ^[A-Z0-9]{3}$.',
  `reorder_point` DECIMAL(13,3) COMMENT 'Inventory level that triggers automatic procurement or production. Used in reorder point planning to maintain minimum stock levels for critical utility materials.',
  `safety_stock` DECIMAL(13,3) COMMENT 'Minimum inventory level maintained to protect against stockouts during lead time variability or demand spikes. Critical for emergency restoration materials.',
  `serial_number_profile` STRING COMMENT 'Configuration controlling serial number management for individual material units. Defines whether serial numbers are required, optional, or not used. Critical for high-value assets like transformers and meters.',
  `shelf_life_days` INT COMMENT 'Maximum number of days material can be stored before expiration or degradation. Used for expiration date calculation and inventory rotation (FIFO/FEFO).',
  `special_procurement_type` STRING COMMENT 'Special procurement rule such as subcontracting, consignment, pipeline withdrawal, or stock transfer. Defines non-standard procurement scenarios.',
  `standard_price` DECIMAL(11,2) COMMENT 'Fixed valuation price per base unit of measure used when price control is set to standard. Updated periodically through standard cost runs. Used for budgeting and variance analysis.',
  `storage_conditions` STRING COMMENT 'Special storage requirements such as temperature control, humidity control, ventilation, or segregation from incompatible materials. Critical for fuel, chemicals, and sensitive equipment.',
  `technical_specification_reference` STRING COMMENT 'Reference to detailed technical specifications, engineering drawings, or standards documents (IEEE, IEC, ANSI). Links material to engineering documentation for compliance and compatibility verification.',
  `valuation_class` STRING COMMENT 'Links material to General Ledger (GL) accounts for inventory valuation, cost of goods sold, and procurement postings. Determines financial account assignment for material movements. Pattern: ^[0-9]{4}$.',
  `volume` DECIMAL(15,3) COMMENT 'Physical volume occupied by the material, measured in the volume unit. Used for warehouse space planning and transportation optimization.',
  `volume_unit` STRING COMMENT 'Unit of measure for volume field. Common values: FT3 (cubic feet), M3 (cubic meters), GAL (gallons). Pattern: ^[A-Z]{2,3}$.',
  `weight_unit` STRING COMMENT 'Unit of measure for gross and net weight fields. Common values: LB (pounds), KG (kilograms), TON (tons). Pattern: ^[A-Z]{2,3}$.',
  `created_by` STRING COMMENT 'User ID of the person who created the material master record. Used for accountability and master data quality tracking.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_material_master` PRIMARY KEY (`material_master_id`)
)
USING DELTA
COMMENT 'Master record for all physical materials managed in the utility supply chain — transformers, conductors, meters, poles, insulators, generation spare parts, and fuel commodities. Captures material identification (number, description, type, group), physical attributes (base unit of measure, weight, dimensions), storage and handling requirements (hazardous classification, storage conditions), procurement parameters (procurement type, vendor-specific pricing via info records with net price, price unit, validity period), and financial valuation (valuation class, standard price, moving average price, price control indicator). SSOT for all utility material definitions and their valuation across the enterprise. | CMM: CIM ErpItemMaster (close), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MaterialMaster',
  'cmm.cim.class' = 'ErpItemMaster',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.material_master'
);

-- Vendor  <<CIM Organisation : close>>
CREATE TABLE IF NOT EXISTS `supply`.`vendor` (
  `vendor_id` BIGINT NOT NULL COMMENT 'Unique identifier for the vendor record. Primary key for the vendor master data product.',
  `counterparty_id` BIGINT COMMENT 'Foreign key linking to trading.counterparty. Business justification: Vendors supplying fuel or major equipment are registered as trading counterparties for enterprise credit risk management. Links vendor master to counterparty master for consolidated credit exposure re',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Vendors must comply with NERC CIP-013 supply chain cyber security, environmental standards, and safety obligations. Vendor qualification/onboarding validates obligation coverage. Real business process',
  `bank_account_number` STRING COMMENT 'Vendor\'s bank account number for electronic payment processing. Highly sensitive financial information used for ACH and wire transfers. Encrypted at rest and in transit.',
  `bank_name` STRING COMMENT 'Name of the financial institution where the vendor maintains their primary business account for payment receipt. Used for ACH and wire transfer payment processing.',
  `bank_routing_number` STRING COMMENT 'Nine-digit ABA routing number for the vendor\'s bank (USA) or equivalent bank identifier code. Used for ACH payment processing. Pattern: ^[0-9]{9}$.',
  `city` STRING COMMENT 'City of the vendor\'s primary business location.',
  `country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code of the vendor\'s primary business location (e.g., USA, CAN, MEX). Pattern: ^[A-Z]{3}$.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this vendor record was first created in the system. Audit trail for data lineage and compliance reporting.',
  `credit_rating` STRING COMMENT 'Credit rating or financial health score for the vendor from Dun & Bradstreet or other credit rating agency. Used for vendor financial risk assessment and payment term determination.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for vendor transactions. Defines the default currency for purchase orders, invoices, and payments with this vendor (e.g., USD, EUR, CAD, MXN). Pattern: ^[A-Z]{3}$.',
  `delivery_score` DECIMAL(5,2) COMMENT 'Delivery dimension score from vendor performance evaluation. Measures on-time delivery percentage, lead time accuracy, and responsiveness to expedite requests. Critical for emergency restoration supply chain.',
  `duns_number` STRING COMMENT 'Nine-digit Dun & Bradstreet DUNS number uniquely identifying the vendor organization. Used for credit checks, vendor risk assessment, and federal contractor registration (SAM.gov). Pattern: ^[0-9]{9}$.',
  `incoterms` STRING COMMENT 'Preferred Incoterms for shipments from this vendor. Defines the division of costs, risks, and responsibilities between buyer and seller in international trade. Common utility terms: FOB (Free on Board), CIF (Cost Insurance Freight), DDP (Delivered Duty Paid). Reference-value candidates: EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF.',
  `insurance_certificate_number` STRING COMMENT 'Certificate number for the vendor\'s general liability and professional liability insurance. Required for contractor and service provider qualification. Utility must be named as additional insured.',
  `insurance_expiration_date` DATE COMMENT 'Expiration date of the vendor\'s insurance certificate. Monitored to ensure continuous coverage for active vendors. Vendors with expired insurance may be blocked from new purchase orders.',
  `last_evaluation_date` DATE COMMENT 'Date of the most recent vendor performance evaluation. Vendors are typically evaluated annually or after major projects to assess quality, delivery, pricing, and service performance.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this vendor record was last updated. Tracks the most recent change to vendor master data for audit trail and change management.',
  `legal_name` STRING COMMENT 'Full legal name of the vendor organization as registered with government authorities. Used for contracts, tax reporting, and regulatory compliance.',
  `minority_owned_flag` BOOLEAN COMMENT 'Indicates whether the vendor is certified as a minority-owned business enterprise (MBE). Used for diversity spend reporting and compliance with utility commission diversity procurement mandates.',
  `nerc_cip_compliance_flag` BOOLEAN COMMENT 'Indicates whether the vendor has been assessed and approved for NERC CIP compliance. Required for vendors with access to bulk electric system (BES) cyber assets or critical infrastructure. Vendors must meet CIP-004 personnel risk assessment and CIP-013 supply chain risk management standards.',
  `onboarding_date` DATE COMMENT 'Date when the vendor was first approved and onboarded into the utility\'s vendor master. Marks the start of the vendor relationship and qualification lifecycle.',
  `overall_performance_score` DECIMAL(5,2) COMMENT 'Composite vendor performance score from the most recent evaluation, typically on a 0-100 scale. Weighted average of quality, delivery, price, and service dimension scores. Used for preferred vendor designation and sourcing decisions.',
  `payment_terms` STRING COMMENT 'Standard payment terms negotiated with the vendor. Defines the number of days for payment and any early payment discount terms (e.g., 2/10 Net 30 = 2% discount if paid within 10 days, otherwise net due in 30 days). Reference-value candidates: Net.',
  `postal_code` STRING COMMENT 'Postal code or ZIP code of the vendor\'s primary business location.',
  `preferred_vendor_flag` BOOLEAN COMMENT 'Indicates whether this vendor has preferred status for strategic sourcing. Preferred vendors receive priority consideration in RFQ and purchase order allocation based on performance, pricing, and strategic partnership criteria.',
  `price_competitiveness_score` DECIMAL(5,2) COMMENT 'Price dimension score from vendor performance evaluation. Compares vendor pricing to market benchmarks, competitive bids, and historical trends. Evaluates total cost of ownership including freight and payment terms.',
  `primary_contact_email` STRING COMMENT 'Email address of the primary business contact at the vendor. Used for purchase order transmission, invoice inquiries, and day-to-day procurement communication. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `primary_contact_name` STRING COMMENT 'Full name of the primary business contact at the vendor organization. Typically the account manager or sales representative responsible for the utility relationship.',
  `primary_contact_phone` STRING COMMENT 'Business phone number of the primary contact at the vendor. Used for urgent procurement inquiries, expediting, and emergency restoration supply chain coordination.',
  `quality_score` DECIMAL(5,2) COMMENT 'Quality dimension score from vendor performance evaluation. Measures defect rates, material conformance to specifications, warranty claims, and field failure rates for supplied equipment and materials.',
  `service_responsiveness_score` DECIMAL(5,2) COMMENT 'Service dimension score from vendor performance evaluation. Measures responsiveness to inquiries, technical support quality, emergency response capability, and account management effectiveness.',
  `small_business_flag` BOOLEAN COMMENT 'Indicates whether the vendor qualifies as a small business under SBA size standards. Used for small business utilization reporting and compliance with federal and state small business procurement goals.',
  `state_province` STRING COMMENT 'State or province code of the vendor\'s primary business location. Two-letter state code for USA (e.g., CA, TX, NY) or province code for Canada.',
  `street_address` STRING COMMENT 'Street address line of the vendor\'s primary business location or headquarters. Used for correspondence, site visits, and logistics coordination.',
  `swift_code` STRING COMMENT 'SWIFT/BIC code for international wire transfers to the vendor. Eight or eleven character code identifying the vendor\'s bank for cross-border payments. Pattern: ^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?$.',
  `tax_identifier` STRING COMMENT 'Federal tax identification number (EIN in USA, VAT number in EU) for the vendor. Used for tax reporting, 1099 processing, and regulatory compliance.',
  `trade_name` STRING COMMENT 'Doing-business-as (DBA) or trade name of the vendor if different from legal name. Common name used in day-to-day business operations.',
  `vendor_category` STRING COMMENT 'Detailed product/service category specialization of the vendor. Aligns with utility supply chain commodity codes and strategic sourcing categories for T&D construction materials, generation spare parts, and fuel supply contracts. Reference-value candidates: Transformer.',
  `vendor_number` STRING COMMENT 'Business identifier for the vendor, externally known vendor account number used in procurement documents and purchase orders. Typically assigned by SAP MM or procurement system. Pattern: ^[A-Z0-9]{6,10}$.',
  `vendor_status` STRING COMMENT 'Current lifecycle status of the vendor relationship. Active = approved for procurement, Inactive = no longer used but historical data retained, Blocked = temporarily prohibited from new orders, Pending Approval = under qualification review, Suspended = compliance or performance issue, Terminated = relationship ended. Valid values: Active|Inactive|Blocked|Pending Approval|Suspended|Terminated.',
  `vendor_type` STRING COMMENT 'Classification of vendor by business relationship type. OEM = Original Equipment Manufacturer (transformers, meters, turbines), Distributor = hardware and materials reseller, Contractor = construction and installation services, Fuel Supplier = gas/coal/uranium supply, Service Provider = maintenance and professional services, Consultant = advisory and engineering services. Valid values: OEM|Distributor|Contractor|Fuel Supplier|Service Provider|Consultant.',
  `woman_owned_flag` BOOLEAN COMMENT 'Indicates whether the vendor is certified as a woman-owned business enterprise (WBE). Used for diversity spend reporting and compliance with utility commission diversity procurement mandates.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_vendor` PRIMARY KEY (`vendor_id`)
)
USING DELTA
COMMENT 'Master record for all suppliers and vendors in the utility supply chain — transformer OEMs, conductor manufacturers, meter suppliers, fuel suppliers (gas, coal, uranium), pole and hardware distributors, and emergency restoration contractors. Captures vendor identity (number, legal name, tax ID), commercial terms (payment terms, currency, preferred incoterms), compliance attributes (minority/diversity status, NERC CIP compliance flag), banking and contact details. Includes periodic performance evaluation records: evaluation period, overall score, dimension scores (quality/defect rate, delivery/on-time %, price/competitiveness, service/emergency responsiveness), NERC CIP compliance score, and evaluator. Supports strategic sourcing decisions, preferred vendor designation, and vendor qualification management. | CMM: CIM Organisation (close), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'Vendor',
  'cmm.cim.class' = 'Organisation',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.vendor'
);

-- PurchaseOrder  <<CIM ErpPurchaseOrder : exact>>
CREATE TABLE IF NOT EXISTS `supply`.`purchase_order` (
  `purchase_order_id` BIGINT NOT NULL COMMENT 'Unique identifier for the purchase order record. Primary key for the purchase order entity.',
  `counterparty_id` BIGINT COMMENT 'Foreign key linking to trading.counterparty. Business justification: Large capital equipment or fuel purchase orders with entities that are also trading counterparties. Enables unified credit exposure tracking across procurement spend and trading positions for enterpri',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: POs create financial commitments posting to GL accounts for accrual accounting and financial statement preparation. Core ERP integration requirement. Existing gl_account column is code/string, creatin',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Emergency procurement orders trigger regulatory reporting obligations (mutual aid, FEMA reimbursement documentation). Real business process: post-storm regulatory compliance reporting and obligation t',
  `purchase_supplier_contract_id` BIGINT COMMENT 'Foreign key linking to supply.supplier_contract. Business justification: Purchase orders may be issued against long-term supplier contracts or framework agreements. N:1 relationship - many POs against one contract. Adding supplier_contract_id FK enables JOIN to retrieve co',
  `purchase_vendor_id` BIGINT COMMENT 'Unique identifier of the supplier or vendor from whom materials, equipment, or services are being procured. Links to vendor master data.',
  `supplier_contract_id` BIGINT COMMENT 'FK to supply.supplier_contract.supplier_contract_id — POs are often released against framework contracts or scheduling agreements. This FK enables contract utilization tracking and compliance with negotiated terms.',
  `to_supplier_contract_id` BIGINT COMMENT 'FK to supply.supplier_contract.supplier_contract_id — POs issued against framework contracts or scheduling agreements must reference the parent contract for contract consumption tracking and compliance.',
  `to_vendor_id` BIGINT COMMENT 'FK to supply.vendor.vendor_id — Every PO is issued to a specific vendor. This is a core transactional-to-master FK required for AP processing, vendor performance tracking, and procurement reporting.',
  `vendor_id` BIGINT COMMENT 'FK to supply.vendor.vendor_id — Every PO is issued to exactly one vendor. This is the most fundamental FK in procurement — without it, you cannot determine who supplies what. Day-1 critical for three-way match and vendor spend analy',
  `approval_date` DATE COMMENT 'Date when the purchase order received final approval and was released for transmission to the vendor.',
  `approval_status` STRING COMMENT 'Current approval workflow status for the purchase order. Tracks whether the PO requires approval and its current state in the approval chain. Valid values: not_required|pending|approved|rejected.',
  `approved_by` STRING COMMENT 'User ID or name of the person who provided final approval for the purchase order. Null if approval is not yet complete.',
  `cancellation_date` DATE COMMENT 'Date when the purchase order was cancelled before completion. Null if the PO was not cancelled.',
  `cancellation_reason` STRING COMMENT 'Explanation for why the purchase order was cancelled (e.g., vendor unable to deliver, project cancelled, duplicate order, pricing dispute). Null if the PO was not cancelled.',
  `capital_expenditure_flag` BOOLEAN COMMENT 'Flag indicating whether this purchase order represents capital expenditure (CAPEX) for long-term assets (transformers, generation equipment, T&D infrastructure) versus operational expenditure (OPEX) for consumables and services. Critical for financial reporting and regulatory asset base (RAB) tracking.',
  `closed_date` DATE COMMENT 'Date when the purchase order was administratively closed after all goods were received, invoices verified, and payments completed. Marks the end of the PO lifecycle.',
  `company_code` STRING COMMENT 'Financial accounting entity representing the legal company or subsidiary for which this purchase order is issued. Standard 4-character code in SAP. Pattern: ^[A-Z0-9]{4}$.',
  `contract_number` STRING COMMENT 'Reference to a master contract, framework agreement, or Power Purchase Agreement (PPA) under which this purchase order is issued. Used for fuel supply contracts, long-term service agreements, and renewable energy PPAs. Pattern: ^[0-9]{10}$.',
  `cost_center` STRING COMMENT 'Organizational cost center to which the purchase order costs will be charged. Used for internal cost allocation and departmental budgeting. Standard 10-character code in SAP. Pattern: ^[A-Z0-9]{10}$.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the purchase order record was first created in the system. Audit trail for record creation.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts on this purchase order (e.g., USD, EUR, CAD). Pattern: ^[A-Z]{3}$.',
  `delivery_date` DATE COMMENT 'Requested or committed date by which the vendor must deliver the goods or complete the services. Used for logistics planning and vendor performance tracking.',
  `emergency_order_flag` BOOLEAN COMMENT 'Flag indicating whether this is an emergency procurement order for outage restoration, critical equipment failure, or storm response. Emergency orders may bypass standard approval workflows and expedite delivery.',
  `goods_receipt_indicator` BOOLEAN COMMENT 'Flag indicating whether goods receipt posting is required for this purchase order. True for material purchases requiring physical receipt confirmation; false for services or direct invoicing scenarios.',
  `incoterms` STRING COMMENT 'International Commercial Terms defining the responsibilities, costs, and risks between buyer and seller for delivery of goods. Standard ICC Incoterms 2020 codes. Reference-value candidates: EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF.',
  `incoterms_location` STRING COMMENT 'Specific location or point referenced in the Incoterms clause (e.g., port name, warehouse address, delivery point).',
  `invoice_receipt_indicator` BOOLEAN COMMENT 'Flag indicating whether invoice verification is required for this purchase order. Controls whether the PO flows through the invoice verification process.',
  `material_category` STRING COMMENT 'High-level classification of the materials or services being procured (e.g., T&D Construction Materials, Generation Spare Parts, Fuel Supply, Professional Services, Emergency Restoration Materials). Reference-value candidates: td_construction|generation_spares|fuel_supply|meters_ami|transformers|conductors|poles_structures|professional_services|it_equipment|vehicles_fleet|safety_equipment|office_supplies|emergency_restoration.',
  `modified_by` STRING COMMENT 'User ID or name of the person who last modified the purchase order record.',
  `modified_timestamp` TIMESTAMP COMMENT 'Date and time when the purchase order record was last modified. Audit trail for record updates.',
  `notes` STRING COMMENT 'Free-text field for additional comments, special terms, or internal notes related to the purchase order. May include vendor communication history, special handling requirements, or procurement justification.',
  `payment_terms` STRING COMMENT 'Payment terms code defining the due date calculation and discount conditions for invoice payment. Standard 4-character code in SAP (e.g., Z001 for Net 30 days, Z002 for 2/10 Net 30). Pattern: ^[A-Z0-9]{4}$.',
  `plant` STRING COMMENT 'Physical location or facility where the procured materials or services will be delivered and consumed. May represent generation plants, substations, warehouses, or service centers. Standard 4-character code in SAP. Pattern: ^[A-Z0-9]{4}$.',
  `po_date` DATE COMMENT 'Date when the purchase order was created and issued to the vendor. Represents the principal business event timestamp for the procurement transaction.',
  `po_number` STRING COMMENT 'Externally-known unique purchase order document number assigned by the procurement system. Standard 10-digit format in SAP S/4HANA MM. Pattern: ^[0-9]{10}$.',
  `po_status` STRING COMMENT 'Current lifecycle status of the purchase order in the procure-to-pay workflow. Tracks progression from creation through goods receipt and invoice verification to closure. Reference-value candidates: draft|pending_approval|approved|in_process|partially_received|fully_received|closed|cancelled.',
  `po_type` STRING COMMENT 'Classification of the purchase order based on procurement scenario: standard (one-time material purchase), framework (blanket agreement), subcontracting (external processing), consignment (vendor-owned inventory), service (non-material procurement), stock_transport (inter-plant transfer). Valid values: standard|framework|subcontracting|consignment|service|stock_transport.',
  `project_number` STRING COMMENT 'Reference to the capital project, construction project, or work breakdown structure (WBS) element to which this purchase order is assigned. Used for project cost tracking and CAPEX management. Pattern: ^[A-Z0-9\\-]{1,24}$.',
  `purchasing_group` STRING COMMENT 'Buyer or procurement team responsible for managing this purchase order. Represents the functional group handling vendor relationships and negotiations. Standard 3-character code in SAP. Pattern: ^[A-Z0-9]{3}$.',
  `purchasing_organization` STRING COMMENT 'Organizational unit responsible for procurement activities. Represents the legal entity or business unit negotiating terms with vendors. Standard 4-character code in SAP. Pattern: ^[A-Z0-9]{4}$.',
  `requisition_number` STRING COMMENT 'Reference to the source purchase requisition document that initiated this purchase order. Links PO to the original material or service request. Pattern: ^[0-9]{10}$.',
  `shipping_instructions` STRING COMMENT 'Special instructions for the vendor regarding packaging, shipping method, delivery hours, site access requirements, or handling of hazardous materials. Critical for large equipment deliveries to generation plants or substations.',
  `storage_location` STRING COMMENT 'Specific warehouse or storage area within the plant where materials will be received and stored. Standard 4-character code in SAP. Pattern: ^[A-Z0-9]{4}$.',
  `total_gross_value` DECIMAL(18,2) COMMENT 'Total gross monetary value of the purchase order including taxes and all additional charges. Represents the final amount payable to the vendor.',
  `total_net_value` DECIMAL(18,2) COMMENT 'Total net monetary value of the purchase order before taxes and additional charges. Sum of all line item net values. Expressed in the currency specified by currency_code.',
  `total_tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount applicable to the purchase order. Includes sales tax, VAT, GST, or other applicable taxes based on jurisdiction.',
  `vendor_quote_number` STRING COMMENT 'Reference number of the vendor quotation or bid that was accepted and converted into this purchase order. Links PO to the source quotation for audit trail.',
  `created_by` STRING COMMENT 'User ID or name of the procurement specialist or system user who created the purchase order record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_purchase_order` PRIMARY KEY (`purchase_order_id`)
)
USING DELTA
COMMENT 'Purchase order header record for all utility procurement transactions — T&D construction materials, generation spare parts, fuel supply, and emergency restoration materials. Captures PO identification (number, type: standard, framework, subcontracting, consignment), commercial terms (vendor, purchasing organization, purchasing group, payment terms, incoterms, currency), logistics (plant, delivery date), financial summary (total net value), approval status, and source of supply reference. Core transactional entity linking requisitions to goods receipt and invoice verification in the procure-to-pay lifecycle. | CMM: CIM ErpPurchaseOrder (exact), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PurchaseOrder',
  'cmm.cim.class' = 'ErpPurchaseOrder',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.purchase_order'
);

-- PoLineItem  <<CIM ErpPOLineItem : exact>>
CREATE TABLE IF NOT EXISTS `supply`.`po_line_item` (
  `po_line_item_id` BIGINT NOT NULL COMMENT 'Unique identifier for the purchase order line item. Primary key for the po_line_item product.',
  `material_master_id` BIGINT COMMENT 'FK to supply.material_master.material_master_id — Each PO line item references a material being procured. This FK enables material-level procurement analysis and inventory planning.',
  `po_material_master_id` BIGINT COMMENT 'Foreign key reference to the material master record. Identifies the specific material, equipment, or spare part being procured (e.g., transformer, conductor, meter, pole, generation spare part).',
  `po_purchase_order_id` BIGINT COMMENT 'Foreign key reference to the parent purchase order header. Links this line item to its containing purchase order document.',
  `purchase_order_id` BIGINT COMMENT 'FK to supply.purchase_order.purchase_order_id — Header-to-line relationship. Every PO line item belongs to exactly one PO header. Without this FK the line items are orphaned and unusable.',
  `purchase_requisition_id` BIGINT COMMENT 'Foreign key linking to supply.purchase_requisition. Business justification: PO line items are created from purchase requisitions. N:1 relationship - one PO line item typically fulfills one requisition line (though consolidation is possible). Adding purchase_requisition_id FK',
  `to_material_master_id` BIGINT COMMENT 'FK to supply.material_master.material_master_id — Every PO line item procures a specific material. This FK is required for inventory tracking, spend analysis, and three-way matching.',
  `to_purchase_order_id` BIGINT COMMENT 'FK to supply.purchase_order.purchase_order_id — Header-to-line relationship is the most fundamental FK in procurement. Every PO line item MUST reference its parent PO header. Without this, the PO structure is broken and unusable.',
  `account_assignment_category` STRING COMMENT 'Account assignment category code defining how costs are allocated. Values: K=Cost Center, A=Asset, P=Project/WBS Element, F=Order, N=Network, U=Unknown. Determines financial posting logic. Valid values: K|A|P|F|N|U.',
  `asset_number` STRING COMMENT 'Fixed asset number when account_assignment_category is A. Links procurement to specific capital assets such as transformers, turbines, or transmission lines.',
  `confirmation_control_key` STRING COMMENT 'Confirmation control key defining whether and how vendor confirmations are expected for this line item. Manages order acknowledgment and delivery confirmation workflows.',
  `cost_center` STRING COMMENT 'Cost center code for account assignment when account_assignment_category is K. Used for O&M expense allocation to organizational units.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this purchase order line item record was first created in the system. Audit trail for record origination.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the line item pricing (e.g., USD, EUR, CAD). Defines the monetary unit for all financial values on this line. Pattern: ^[A-Z]{3}$.',
  `deletion_indicator` BOOLEAN COMMENT 'Indicates whether this line item is marked for deletion. True if the line has been logically deleted but retained for audit purposes; False if active.',
  `delivery_date` DATE COMMENT 'Requested or scheduled delivery date for the material or service. Critical for T&D construction project planning, generation maintenance scheduling, and fuel supply coordination.',
  `gl_account` STRING COMMENT 'General ledger account number for financial posting. Defines the expense or asset account to which this procurement cost is charged.',
  `goods_receipt_based_invoice_verification` BOOLEAN COMMENT 'Indicates whether invoice verification is based on goods receipt. True if invoices can only be posted after goods receipt; False if invoice can precede receipt.',
  `goods_receipt_indicator` BOOLEAN COMMENT 'Indicates whether goods receipt is required for this line item. True if physical receipt must be posted; False for services or non-stock items.',
  `incoterms` STRING COMMENT 'Incoterms code defining delivery terms and transfer of risk (e.g., FOB, CIF, DDP). Specifies responsibilities for shipping, insurance, and customs.',
  `incoterms_location` STRING COMMENT 'Named location associated with the Incoterms (e.g., port of shipment, destination facility). Provides geographic context for delivery terms.',
  `invoice_receipt_indicator` BOOLEAN COMMENT 'Indicates whether invoice receipt is expected for this line item. True if vendor invoice verification is required; False if invoice is not applicable.',
  `item_category` STRING COMMENT 'Item category code defining the type of procurement item (e.g., standard, consignment, subcontracting, service, text). Controls procurement processing logic.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this purchase order line item record was last updated. Audit trail for record change tracking.',
  `line_item_status` STRING COMMENT 'Current lifecycle status of the purchase order line item. Tracks progression from open order through receipt to closure. Valid values: open|partially_received|fully_received|cancelled|closed.',
  `line_number` INT COMMENT 'Sequential line item number within the purchase order. Determines the ordering and position of this line item in the PO document.',
  `manufacturer_part_number` STRING COMMENT 'Original equipment manufacturer (OEM) part number for the material. Critical for spare parts procurement and equipment maintenance.',
  `material_group` STRING COMMENT 'Material group classification code for procurement categorization. Groups similar materials for reporting and analysis (e.g., transformers, conductors, meters, fuel).',
  `material_number` STRING COMMENT 'Business identifier for the material being procured. Human-readable material code used in procurement operations and inventory management.',
  `net_order_value` DECIMAL(18,2) COMMENT 'Total net value of the line item calculated as quantity_ordered multiplied by net_price adjusted for price_unit. Represents the total procurement cost for this line before taxes.',
  `net_price` DECIMAL(18,2) COMMENT 'Net price per unit of measure for the material or service. Base price before taxes, discounts, or surcharges.',
  `over_delivery_tolerance_percent` DECIMAL(5,2) COMMENT 'Percentage over-delivery tolerance allowed for this line item. Defines acceptable variance above ordered quantity before triggering exception handling.',
  `plant_code` STRING COMMENT 'Plant or facility code where the material will be delivered. Identifies the receiving location such as generation plant, warehouse, or service center.',
  `price_unit` INT COMMENT 'Price unit quantity that the net price relates to. For example, if price_unit is 100 and net_price is 50, the price is 50 per 100 units.',
  `purchase_requisition_line_number` INT COMMENT 'Line item number within the source purchase requisition. Provides granular traceability from PO line to originating requisition line.',
  `purchasing_group` STRING COMMENT 'Purchasing group code responsible for this line item. Identifies the procurement team or buyer managing this purchase.',
  `quantity_invoiced` DECIMAL(18,3) COMMENT 'Cumulative quantity invoiced by the vendor against this line item to date. Supports three-way match reconciliation between PO, goods receipt, and invoice.',
  `quantity_ordered` DECIMAL(18,3) COMMENT 'Quantity of material or service ordered on this line item. Represents the procurement volume for this specific material.',
  `quantity_received` DECIMAL(18,3) COMMENT 'Cumulative quantity of material received against this line item to date. Tracks fulfillment progress and outstanding delivery balance.',
  `requisitioner_name` STRING COMMENT 'Name of the person or department that requested this material or service. Identifies the internal business stakeholder driving the procurement need.',
  `short_text` STRING COMMENT 'Brief description of the material or service being procured on this line item. Provides human-readable context for the line item content.',
  `storage_location` STRING COMMENT 'Storage location code within the plant where the material will be stored upon receipt. Defines the specific warehouse or inventory location.',
  `tax_code` STRING COMMENT 'Tax code determining applicable sales tax, VAT, or other tax treatment for this line item. Drives tax calculation in invoice verification.',
  `under_delivery_tolerance_percent` DECIMAL(5,2) COMMENT 'Percentage under-delivery tolerance allowed for this line item. Defines acceptable variance below ordered quantity before requiring follow-up action.',
  `unit_of_measure` STRING COMMENT 'Unit of measure for the ordered quantity (e.g., EA for each, MT for metric ton, M for meter, KG for kilogram). Defines the measurement unit for procurement quantities.',
  `vendor_material_number` STRING COMMENT 'Vendor\'s own material number or part number for the procured item. Facilitates cross-reference between utility and supplier catalogs.',
  `wbs_element` STRING COMMENT 'WBS element code for project-based account assignment when account_assignment_category is P. Links procurement to capital projects such as T&D construction or generation upgrades.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_po_line_item` PRIMARY KEY (`po_line_item_id`)
)
USING DELTA
COMMENT 'Individual line item within a purchase order capturing material-level procurement detail. Captures line identification (PO line number), material specification (material number, short text, quantity ordered, unit of measure), pricing (net price, price unit), delivery requirements (delivery date, plant, storage location), account assignment (category, cost center or WBS element), receipt controls (goods receipt indicator, invoice receipt indicator), and line item status. Supports granular tracking of multi-material procurement events for T&D construction, generation maintenance, and fuel supply. | CMM: CIM ErpPOLineItem (exact), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PoLineItem',
  'cmm.cim.class' = 'ErpPOLineItem',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.po_line_item'
);

-- GoodsReceipt  <<CIM ErpReceiveDelivery : close>>
CREATE TABLE IF NOT EXISTS `supply`.`goods_receipt` (
  `goods_receipt_id` BIGINT NOT NULL COMMENT 'Unique identifier for the goods receipt transaction. Primary key for the goods receipt record.',
  `goods_material_master_id` BIGINT COMMENT 'Foreign key reference to the material master record. Identifies the specific material (transformer, conductor, meter, pole, spare part, fuel) involved in this goods movement.',
  `goods_purchase_order_id` BIGINT COMMENT 'Foreign key linking to supply.purchase_order. Business justification: Goods receipts are recorded against purchase orders. N:1 relationship - many goods receipts for one PO (partial deliveries, multiple shipments). Adding purchase_order_id FK enables JOIN to retrieve PO',
  `goods_warehouse_id` BIGINT COMMENT 'FK to supply.warehouse.warehouse_id — Goods movements occur at specific warehouse/storage locations. Required for inventory location tracking.',
  `material_master_id` BIGINT COMMENT 'FK to supply.material_master.material_master_id — Every inventory movement references a material. Required for inventory position calculation and material consumption tracking.',
  `po_line_item_id` BIGINT COMMENT 'Foreign key linking to supply.po_line_item. Business justification: Goods receipts are recorded at the PO line item level. N:1 relationship - many goods receipts for one PO line item (partial deliveries). Adding po_line_item_id FK enables JOIN to retrieve line-level d',
  `purchase_order_id` BIGINT COMMENT 'FK to supply.purchase_order.purchase_order_id — Goods receipts for POs reference the originating purchase order. Critical for three-way match (PO→GR→IV) and procurement lifecycle tracking.',
  `receiving_warehouse_id` BIGINT COMMENT 'Foreign key linking to supply.warehouse. Business justification: Goods are received into specific warehouses. N:1 relationship - many receipts into one warehouse. Adding receiving_warehouse_id FK enables JOIN to retrieve warehouse master data. Not removing receivin',
  `to_material_master_id` BIGINT COMMENT 'FK to supply.material_master.material_master_id — Every goods movement involves a specific material. Required for inventory posting and material document integrity.',
  `to_purchase_order_id` BIGINT COMMENT 'FK to supply.purchase_order.purchase_order_id — GR for PO (movement type 101) must reference the PO for three-way matching. This is the core link enabling invoice verification.',
  `vendor_id` BIGINT COMMENT 'Foreign key reference to the vendor (supplier) master record. Identifies the supplier for inbound receipts from external sources.',
  `warehouse_id` BIGINT COMMENT 'FK to supply.warehouse.warehouse_id — Inventory movements occur at a specific warehouse/storage location. Required for warehouse-level inventory accuracy and movement history.',
  `batch_number` STRING COMMENT 'The batch or lot number for batch-managed materials. Enables traceability for quality control, warranty tracking, and recall management. Critical for fuel deliveries and critical spare parts.',
  `bill_of_lading` STRING COMMENT 'The bill of lading number for shipments. Legal document issued by the carrier acknowledging receipt of cargo for shipment.',
  `cost_center` STRING COMMENT 'The cost center to which material consumption is charged for outbound issues. Used for internal cost allocation and departmental expense tracking. Pattern: ^[A-Z0-9]{10}$.',
  `created_by_user` STRING COMMENT 'The user ID of the person who created the goods receipt record in the system. Audit field for accountability and compliance. Pattern: ^[A-Z0-9]{1,12}$.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the valuation amount (e.g., USD, EUR, CAD). Pattern: ^[A-Z]{3}$.',
  `delivery_note_number` STRING COMMENT 'The external delivery note or packing slip number provided by the vendor. Used for matching physical deliveries to system records.',
  `document_date` DATE COMMENT 'The date printed on the external source document (e.g., delivery note date, packing slip date). May differ from posting date when documents are processed with a delay.',
  `entry_date` DATE COMMENT 'The date when the goods receipt record was created in the system by the user. Audit timestamp for data entry.',
  `gl_account` STRING COMMENT 'The general ledger account number to which the inventory value change is posted. Determines the financial accounting treatment of the goods movement. Pattern: ^[0-9]{10}$.',
  `header_text` STRING COMMENT 'Free-form text notes or comments entered at the document header level. Used for special instructions, explanations, or contextual information about the goods movement.',
  `inspection_lot_number` STRING COMMENT 'The quality inspection lot number created for this goods receipt. Links the material movement to quality inspection results and certificates. Pattern: ^[0-9]{12}$.',
  `item_text` STRING COMMENT 'Free-form text notes or comments specific to this line item. Used for material-specific details, condition notes, or special handling instructions.',
  `material_description` STRING COMMENT 'Short text description of the material for display and reporting purposes. Denormalized from material master for query performance.',
  `material_document_item` INT COMMENT 'Line item number within the material document. Allows multiple material movements to be grouped under a single document header.',
  `material_document_number` STRING COMMENT 'The externally-known SAP material document number that uniquely identifies this goods movement transaction in the ERP system. Used for traceability and audit purposes. Pattern: ^[0-9]{10}$.',
  `material_document_year` INT COMMENT 'Fiscal year in which the material document was posted. Part of the compound business key with material document number.',
  `material_number` STRING COMMENT 'The business material number (SKU) from the material master. Human-readable identifier for the material being received or issued. Pattern: ^[A-Z0-9]{1,18}$.',
  `movement_direction` STRING COMMENT 'High-level classification of the inventory movement direction: inbound (receipts into inventory), outbound (issues from inventory), or transfer (location-to-location movements). Valid values: inbound|outbound|transfer.',
  `movement_type` STRING COMMENT 'Three-digit SAP movement type code that classifies the nature of the inventory transaction (e.g., 101=GR from PO, 201=GR to cost center, 311=transfer posting, 551=scrapping). Determines accounting treatment and inventory impact. Pattern: ^[0-9]{3}$.',
  `plant_code` STRING COMMENT 'Four-character code identifying the plant (generation station, service center, warehouse, or operational facility) where the goods movement occurred. Pattern: ^[A-Z0-9]{4}$.',
  `posting_date` DATE COMMENT 'The date on which the goods movement was posted to inventory and financial accounting. This is the principal business event timestamp for the transaction and determines the fiscal period for accounting purposes.',
  `purchase_order_item` INT COMMENT 'The line item number on the purchase order. Null for non-PO movements.',
  `quality_inspection_status` STRING COMMENT 'The quality inspection status for the received material. Determines whether the material is available for unrestricted use or must remain in quality hold until inspection is complete. Valid values: not_required|pending|in_progress|passed|failed|conditional.',
  `quantity` DECIMAL(18,3) COMMENT 'The quantity of material moved in this transaction, expressed in the base unit of measure. Positive for receipts, negative for issues in some movement types.',
  `reason_code` STRING COMMENT 'The reason code explaining the purpose or cause of the goods movement (e.g., emergency restoration, planned maintenance, field return, obsolescence, damage). Used for root cause analysis and supply chain optimization. Pattern: ^[A-Z0-9]{2,4}$.',
  `receiving_plant_code` STRING COMMENT 'For transfer movements, the plant code of the destination location. Null for non-transfer movements. Pattern: ^[A-Z0-9]{4}$.',
  `receiving_storage_location` STRING COMMENT 'For transfer movements, the storage location code of the destination. Null for non-transfer movements. Pattern: ^[A-Z0-9]{4}$.',
  `reversal_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether this goods receipt is a reversal (cancellation) of a previous goods movement. True if this is a reversal transaction.',
  `reversed_document_number` STRING COMMENT 'The material document number of the original transaction that this reversal cancels. Null for non-reversal transactions. Pattern: ^[0-9]{10}$.',
  `serial_number` STRING COMMENT 'The unique serial number for serialized materials (e.g., meters, transformers, high-value equipment). Enables individual asset tracking and lifecycle management.',
  `special_stock_indicator` STRING COMMENT 'Single-character code indicating special stock categories (e.g., project stock, sales order stock, consignment stock). Determines special handling and valuation rules. Pattern: ^[A-Z]{1}$.',
  `stock_type` STRING COMMENT 'The inventory stock type classification: unrestricted (available for use), quality inspection (pending QC), blocked (unusable), restricted (limited use), or consignment (vendor-owned). Valid values: unrestricted|quality_inspection|blocked|restricted|consignment.',
  `storage_location` STRING COMMENT 'Four-character code identifying the specific storage location (warehouse, yard, bin, or storeroom) within the plant where the material is stored. Pattern: ^[A-Z0-9]{4}$.',
  `unit_of_measure` STRING COMMENT 'The unit in which the quantity is expressed (e.g., EA=each, FT=feet, LB=pounds, GAL=gallons, TON=tons). ISO unit code. Pattern: ^[A-Z]{2,3}$.',
  `unloading_point` STRING COMMENT 'The specific physical location or dock where the material was unloaded. Used for warehouse logistics and receiving dock management.',
  `valuation_amount` DECIMAL(18,2) COMMENT 'The total monetary value of the goods movement in the company currency. Calculated as quantity multiplied by the material valuation price at the time of posting.',
  `wbs_element` STRING COMMENT 'The WBS element (project phase or task) to which material is charged for capital projects. Used for tracking T&D construction material costs and CAPEX allocation. Pattern: ^[A-Z0-9\\-]{1,24}$.',
  `work_order_number` STRING COMMENT 'The maintenance or service work order number for material withdrawals supporting field maintenance activities. Links material consumption to asset maintenance events. Pattern: ^[0-9]{12}$.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_goods_receipt` PRIMARY KEY (`goods_receipt_id`)
)
USING DELTA
COMMENT 'Unified inventory movement document recording all material movements across the utility supply chain. Covers inbound receipts (purchase order deliveries, production receipts, field returns), outbound issues (cost center consumption, project issues, work order withdrawals, field crew material picks), and inter-location transfers (warehouse-to-warehouse, plant-to-plant, emergency rebalancing, mutual aid movements). Captures document identification (material document number, posting date), movement classification (movement type, direction), material and quantity details, location context (sending/receiving plant and storage location), cost allocation (cost center, WBS element, work order), transfer logistics (reason, transport mode, transit dates), batch tracking, and quality inspection status. Triggers real-time inventory updates and supports three-way match for invoice verification. Critical for T&D construction material tracking, generation maintenance consumption, fuel delivery confirmation, and emergency restoration logistics. | CMM: CIM ErpReceiveDelivery (close), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'GoodsReceipt',
  'cmm.cim.class' = 'ErpReceiveDelivery',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.goods_receipt'
);

-- WarehouseStock  <<CIM ErpInventory : close>>
CREATE TABLE IF NOT EXISTS `supply`.`warehouse_stock` (
  `warehouse_stock_id` BIGINT NOT NULL COMMENT 'Unique identifier for the warehouse stock record. Primary key for the warehouse stock entity.',
  `material_master_id` BIGINT COMMENT 'FK to supply.material_master.material_master_id — Stock levels are tracked per material. This FK enables material-level inventory queries and reorder point monitoring.',
  `primary_warehouse_id` BIGINT COMMENT 'Foreign key linking to supply.warehouse. Business justification: Stock is physically stored in a warehouse/storage location. N:1 relationship - many stock records for one warehouse. Adding warehouse_id FK enables JOIN to retrieve warehouse master data (name, addres',
  `to_material_master_id` BIGINT COMMENT 'FK to supply.material_master.material_master_id — Stock levels are per-material. This FK is essential for inventory queries, reorder point checks, and MRP.',
  `to_warehouse_id` BIGINT COMMENT 'FK to supply.warehouse.warehouse_id — Stock levels are per-warehouse/storage-location. Required for location-specific inventory management.',
  `warehouse_material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: Warehouse stock records track inventory levels for specific materials. N:1 relationship - many stock records (across locations, time periods, stock types) reference one material master. Adding materia',
  `abc_indicator` STRING COMMENT 'ABC analysis classification for inventory management priority. A=High-value/critical items requiring tight control, B=Moderate-value items, C=Low-value items with relaxed control, X=Unclassified. Valid values: A|B|C|X.',
  `available_quantity` DECIMAL(18,3) COMMENT 'Net available quantity for new consumption, calculated as unrestricted quantity on hand minus reserved quantity. Represents true available-to-promise inventory.',
  `base_unit_of_measure` STRING COMMENT 'Standard unit of measure for the material quantity. EA=Each, FT=Feet, M=Meters, KG=Kilograms, LB=Pounds, GAL=Gallons, L=Liters, TON=Tons, MT=Metric Tons, ROLL=Roll, SPOOL=Spool, SET=Set, KIT=Kit. Reference-value candidates: EA|FT|M|KG|LB|GAL|L|TON|MT|ROLL|SPOOL|SET|KIT.',
  `batch_number` STRING COMMENT 'Batch or lot number for materials managed with batch-level traceability (e.g., chemicals, fuels, certain spare parts). Enables quality tracking and recall management. Pattern: ^[A-Z0-9]{1,10}$.',
  `blocked_quantity` DECIMAL(18,3) COMMENT 'Quantity that has been blocked from use due to quality issues, damage, or other restrictions. Cannot be issued until block is removed.',
  `consignment_vendor_code` STRING COMMENT 'Vendor identifier for consignment stock arrangements where the vendor owns inventory stored at utility locations until consumption. Populated only for consignment stock type. Pattern: ^[A-Z0-9]{10}$.',
  `critical_spare_part_indicator` BOOLEAN COMMENT 'Flag indicating whether this material is classified as a critical spare part for generation or T&D assets. True if stockout would cause significant operational impact or extended outage.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the stock value amount. Valid values: USD|CAD|EUR|GBP|MXN.',
  `emergency_restoration_stock_indicator` BOOLEAN COMMENT 'Flag indicating whether this material is designated for emergency storm restoration and outage response. True if material is pre-positioned for rapid deployment during major events.',
  `fiscal_year_period` STRING COMMENT 'Fiscal year and period for which this stock position is reported, in format YYYYPPP (e.g., 2024001 for period 001 of fiscal year 2024). Enables period-end inventory reporting. Pattern: ^[0-9]{4}[0-9]{3}$.',
  `in_quality_inspection_quantity` DECIMAL(18,3) COMMENT 'Quantity currently in quality inspection status awaiting QA approval before release to unrestricted stock. Typically applies to newly received materials.',
  `in_transit_quantity` DECIMAL(18,3) COMMENT 'Quantity currently in transit between storage locations or plants via stock transfer orders. Not yet available at destination location.',
  `last_goods_issue_date` DATE COMMENT 'Date of the most recent goods issue transaction that decreased stock at this location. Indicates last consumption or withdrawal activity.',
  `last_goods_receipt_date` DATE COMMENT 'Date of the most recent goods receipt transaction that increased stock at this location. Indicates last replenishment activity.',
  `last_physical_inventory_date` DATE COMMENT 'Date of the most recent physical inventory count or cycle count performed for this material at this location. Used for inventory accuracy tracking.',
  `material_group` STRING COMMENT 'Hierarchical classification code grouping similar materials for procurement and inventory planning. Examples: transformers, conductors, meters, poles, generation parts. Pattern: ^[A-Z0-9]{4,9}$.',
  `material_number` STRING COMMENT 'Unique material identifier from the materials master catalog. Identifies the specific utility material (transformer, conductor, meter, pole, generation spare part, etc.) being stocked. Pattern: ^[A-Z0-9]{8,18}$.',
  `material_type` STRING COMMENT 'Classification of material category. ROH=Raw Material, HALB=Semi-Finished, FERT=Finished Product, HAWA=Trading Goods, ERSA=Spare Parts, UNBW=Non-Valuated Material, NLAG=Non-Stock Material, DIEN=Services, VERP=Packaging, HIBE=Operating Supplies, IBAU=Maintenance Assembly. Reference-value candidates: ROH|HALB|FERT|HAWA|ERSA|UNBW|NLAG|DIEN|VERP|HIBE|IBAU.',
  `maximum_stock_level` DECIMAL(18,3) COMMENT 'Upper limit for inventory quantity to prevent overstocking and excess capital tied up in inventory. Used in reorder quantity calculations.',
  `mrp_type` STRING COMMENT 'Code defining the MRP procedure for this material. PD=MRP, VB=Manual Reorder Point, VM=Automatic Reorder Point, VV=Forecast-Based Planning, ND=No Planning, X0=No MRP. Valid values: PD|VB|VM|VV|ND|X0.',
  `obsolete_indicator` BOOLEAN COMMENT 'Flag indicating whether this material has been marked as obsolete and should be phased out of inventory. True if material is no longer procured or used.',
  `plant_code` STRING COMMENT 'Four-character code identifying the plant or facility where the material is stocked. Represents the organizational unit responsible for inventory management. Pattern: ^[A-Z0-9]{4}$.',
  `procurement_type` STRING COMMENT 'Defines how the material is procured. F=External Procurement (purchased), E=In-House Production (manufactured), X=Both. Valid values: F|E|X.',
  `quantity_on_hand` DECIMAL(18,3) COMMENT 'Current physical inventory quantity available at this plant and storage location for this material and stock type. Represents the actual count of units in stock.',
  `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this warehouse stock record was first created in the source system.',
  `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this warehouse stock record was last updated in the source system. Tracks data freshness and change activity.',
  `reorder_point_quantity` DECIMAL(18,3) COMMENT 'Minimum stock level that triggers automatic replenishment. When quantity on hand falls below this threshold, a purchase requisition or order is generated.',
  `reserved_quantity` DECIMAL(18,3) COMMENT 'Quantity of unrestricted stock that has been reserved for specific work orders, projects, or planned consumption but not yet issued. Reduces available-to-promise quantity.',
  `safety_stock_quantity` DECIMAL(18,3) COMMENT 'Buffer stock quantity maintained to protect against demand variability and supply chain disruptions. Critical for emergency restoration supply chain readiness.',
  `serial_number_profile` STRING COMMENT 'Code indicating the serial number management profile for serialized materials (e.g., meters, transformers, high-value equipment). Defines serialization requirements and tracking rules. Pattern: ^[A-Z0-9]{4}$.',
  `slow_moving_indicator` BOOLEAN COMMENT 'Flag indicating whether this material is classified as slow-moving based on consumption velocity analysis. True if no movement in defined period (e.g., 12 months).',
  `snapshot_date` DATE COMMENT 'Date for which this stock position snapshot was captured. Supports historical inventory analysis and period-end reporting.',
  `special_stock_indicator` STRING COMMENT 'Code for special stock categories. E=Sales Order Stock, K=Consignment at Customer, O=Project Stock, Q=Quality Inspection, V=Vendor Consignment, W=Consignment at Vendor, M=Pipeline/In-Transit. Reference-value candidates: E|K|O|Q|V|W|M.',
  `stock_coverage_days` INT COMMENT 'Calculated number of days the current stock quantity will last based on average daily consumption rate. Key metric for supply chain resilience assessment.',
  `stock_type` STRING COMMENT 'Classification of stock availability status. Unrestricted stock is available for use; quality inspection stock is pending QA approval; blocked stock is restricted from use; in-transit stock is moving between locations; consignment stock is vendor-owned; project stock is allocated to specific capital projects; subcontracting stock is at vendor location. Reference-value candidates: unrestricted|quality_inspection|blocked|in_transit|consignment|project_stock|subcontracting.',
  `stock_value_amount` DECIMAL(18,2) COMMENT 'Total monetary value of the stock on hand at this location, calculated using the material valuation price multiplied by quantity. Represents the financial investment in inventory.',
  `storage_location_code` STRING COMMENT 'Four-character code identifying the specific storage location within the plant (warehouse, substation storeroom, field depot, central warehouse, etc.). Pattern: ^[A-Z0-9]{4}$.',
  `valuation_class` STRING COMMENT 'Four-digit code that groups materials for accounting and financial reporting purposes. Links inventory to General Ledger (GL) accounts. Pattern: ^[0-9]{4}$.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_warehouse_stock` PRIMARY KEY (`warehouse_stock_id`)
)
USING DELTA
COMMENT 'Current and period-end inventory stock levels for utility materials across all warehouse locations, substations, and field storerooms. Captures stock position per material and location: plant, storage location, stock type (unrestricted, quality inspection, blocked, in-transit, consignment), quantity on hand, unit of measure, stock value, and last movement date. Includes replenishment parameters: reorder point, safety stock level, maximum stock level, and slow-moving indicator. Supports emergency restoration supply chain readiness assessment, T&D construction material availability planning, and generation spare parts stocking optimization. | CMM: CIM ErpInventory (close), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'WarehouseStock',
  'cmm.cim.class' = 'ErpInventory',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.warehouse_stock'
);

-- Warehouse  <<CIM WorkLocation : broad>>
CREATE TABLE IF NOT EXISTS `supply`.`warehouse` (
  `warehouse_id` BIGINT NOT NULL COMMENT 'Unique identifier for the warehouse facility. Primary key for the warehouse master record.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Warehouses operate as cost centers for overhead allocation - facility rent, utilities, labor costs tracked. Essential for inventory carrying cost calculation and rate base allocation in regulated util',
  `manager_employee_id` BIGINT COMMENT 'Employee identifier of the warehouse manager. Links to the HR system for contact information and organizational hierarchy.',
  `nerc_cip_asset_id` BIGINT COMMENT 'Foreign key linking to compliance.nerc_cip_asset. Business justification: Warehouses storing CIP-critical equipment are physical security perimeters (CIP-006). Real business process: CIP physical security compliance, access control, and critical infrastructure protection fo',
  `address_line_1` STRING COMMENT 'Primary street address of the warehouse facility including street number and name. Organizational contact data classified as confidential business information.',
  `address_line_2` STRING COMMENT 'Secondary address information such as building number, suite, or unit. Organizational contact data classified as confidential business information.',
  `city` STRING COMMENT 'City or municipality where the warehouse facility is located. Organizational contact data classified as confidential business information.',
  `climate_controlled_flag` BOOLEAN COMMENT 'Indicates whether the warehouse facility has climate control systems (HVAC) to maintain temperature and humidity within specified ranges. Critical for storing sensitive materials such as electronic meters, batteries, and certain generation spare parts.',
  `company_code` STRING COMMENT 'SAP company code representing the legal entity that owns or operates this warehouse facility. Used for financial accounting and asset ownership tracking. Pattern: ^[A-Z0-9]{4}$.',
  `construction_year` INT COMMENT 'Year in which the warehouse facility was originally constructed. Used for asset age analysis, depreciation calculations, and facility modernization planning.',
  `country_code` STRING COMMENT 'Three-letter ISO country code where the warehouse facility is located (e.g., \'USA\', \'CAN\', \'MEX\'). Pattern: ^[A-Z]{3}$.',
  `crane_available_flag` BOOLEAN COMMENT 'Indicates whether the warehouse facility has overhead crane or gantry crane equipment for handling heavy or oversized materials such as large transformers, turbine components, or pole sections.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this warehouse master record was first created in the system. Used for data lineage and audit trail purposes.',
  `cycle_count_frequency` STRING COMMENT 'Frequency at which physical inventory cycle counts are performed at this warehouse facility to verify inventory accuracy and reconcile discrepancies with the SAP MM system. Valid values: daily|weekly|monthly|quarterly|annual|continuous.',
  `decommission_date` DATE COMMENT 'Date when the warehouse facility was permanently closed and removed from active service. Null for active facilities. Used for asset retirement accounting and historical analysis.',
  `effective_date` DATE COMMENT 'Date when the warehouse facility became operational and available for inventory storage. Marks the beginning of the facility\'s active lifecycle.',
  `email_address` STRING COMMENT 'Primary email address for the warehouse facility for business correspondence and logistics coordination. Organizational contact data classified as confidential business information. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `emergency_restoration_designated_flag` BOOLEAN COMMENT 'Indicates whether the warehouse facility is designated as an emergency restoration staging area for storm response and outage restoration operations. These facilities maintain critical spare parts inventory (poles, transformers, conductors) and are staffed 24/7 during major events.',
  `fax_number` STRING COMMENT 'Fax number for the warehouse facility, if applicable. Organizational contact data classified as confidential business information.',
  `fire_suppression_system_type` STRING COMMENT 'Type of fire suppression system installed at the warehouse facility. Sprinkler systems are standard for most facilities, foam systems are used for flammable liquid storage, gas systems (e.g., FM-200) are used for electronics storage, and some field storerooms may have no automated system. Valid values: sprinkler|foam|gas|none.',
  `forklift_capacity_tons` DECIMAL(8,2) COMMENT 'Maximum lifting capacity of the largest forklift or material handling equipment available at the warehouse facility, measured in tons. Determines the maximum weight of individual items that can be handled (e.g., transformers, cable reels).',
  `hazmat_certified_flag` BOOLEAN COMMENT 'Indicates whether the warehouse facility is certified to store hazardous materials such as transformer oil, PCB-containing equipment, batteries, fuel, and chemical supplies. Certification requires compliance with EPA and OSHA regulations.',
  `insurance_policy_number` STRING COMMENT 'Insurance policy number covering the warehouse facility and its contents. Used for risk management and claims processing in the event of damage or loss.',
  `inventory_valuation_method` STRING COMMENT 'Accounting method used to value inventory stored at this warehouse facility. FIFO (First In First Out), LIFO (Last In First Out), weighted average, or standard cost methods are used for financial reporting and CAPEX/OPEX allocation. Valid values: FIFO|LIFO|weighted_average|standard_cost.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this warehouse master record was last updated in the system. Used for data lineage and audit trail purposes.',
  `last_physical_inventory_date` DATE COMMENT 'Date of the most recent complete physical inventory count performed at this warehouse facility. Used to track compliance with inventory audit requirements.',
  `last_renovation_year` INT COMMENT 'Year of the most recent major renovation or expansion of the warehouse facility. Used to track facility condition and plan future capital investments.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the warehouse facility in decimal degrees. Used for GIS mapping, emergency restoration logistics planning, and proximity analysis.',
  `lease_expiration_date` DATE COMMENT 'Expiration date of the lease agreement for leased warehouse facilities. Null for owned facilities. Used for lease renewal planning and OPEX forecasting.',
  `loading_dock_count` INT COMMENT 'Number of loading docks available at the warehouse facility for receiving and shipping materials. Impacts throughput capacity and logistics scheduling.',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the warehouse facility in decimal degrees. Used for GIS mapping, emergency restoration logistics planning, and proximity analysis.',
  `operating_hours` STRING COMMENT 'Standard operating hours for the warehouse facility (e.g., \'7:00 AM - 5:00 PM Monday-Friday\', \'24/7\', \'On-Call\'). Defines when the facility is staffed and available for receiving and issuing materials.',
  `operational_status` STRING COMMENT 'Current operational state of the warehouse facility. Active warehouses are fully operational, inactive warehouses are not currently in use, temporarily closed warehouses are undergoing maintenance or renovation, decommissioned warehouses are permanently closed, under construction warehouses are being built or expanded, and seasonal warehouses operate only during specific periods. Valid values: active|inactive|temporarily_closed|decommissioned|under_construction|seasonal.',
  `ownership_type` STRING COMMENT 'Indicates whether the warehouse facility is owned by the utility, leased from a third party, operated by a third-party logistics (3PL) provider, or managed by a vendor under a consignment or vendor-managed inventory (VMI) arrangement. Valid values: owned|leased|third_party_logistics|vendor_managed.',
  `phone_number` STRING COMMENT 'Primary contact phone number for the warehouse facility. Organizational contact data classified as confidential business information.',
  `plant_code` STRING COMMENT 'SAP plant code representing the organizational unit to which this warehouse is assigned. Links the warehouse to a specific generation facility, service center, or operational division within the utility\'s organizational structure. Pattern: ^[A-Z0-9]{4,8}$.',
  `postal_code` STRING COMMENT 'Postal or ZIP code for the warehouse facility address. Organizational contact data classified as confidential business information.',
  `rail_access_flag` BOOLEAN COMMENT 'Indicates whether the warehouse facility has direct rail siding access for receiving large shipments of bulk materials such as coal, transformers, or cable reels via rail freight.',
  `security_level` STRING COMMENT 'Classification of physical security measures implemented at the warehouse facility. Basic security includes perimeter fencing and locks, standard security adds alarm systems and access control, high security includes 24/7 monitoring and guards, and critical infrastructure security meets NERC CIP requirements for facilities storing grid-critical spare parts. Valid values: basic|standard|high|critical_infrastructure.',
  `state_province` STRING COMMENT 'Two-letter state or province code where the warehouse facility is located (e.g., \'CA\', \'TX\', \'ON\'). Pattern: ^[A-Z]{2}$.',
  `storage_capacity_cubic_ft` DECIMAL(12,2) COMMENT 'Total volumetric storage capacity of the warehouse facility measured in cubic feet. Accounts for vertical storage capability including racking and shelving systems.',
  `storage_capacity_sqft` DECIMAL(12,2) COMMENT 'Total storage capacity of the warehouse facility measured in square feet. Represents the usable floor space available for inventory storage, excluding office areas and loading docks.',
  `warehouse_name` STRING COMMENT 'Full business name of the warehouse facility (e.g., \'Central Distribution Center\', \'North Regional Storeroom\', \'Mobile Emergency Restoration Unit 3\').',
  `warehouse_number` STRING COMMENT 'Business identifier for the warehouse facility. Externally-known code used in procurement, inventory, and logistics operations. Corresponds to SAP storage location or plant code. Pattern: ^[A-Z0-9]{4,10}$.',
  `warehouse_type` STRING COMMENT 'Classification of the warehouse facility based on its role in the supply chain network. Central warehouses serve as primary distribution hubs, regional warehouses support geographic territories, field storerooms are located at operational sites, mobile units support emergency restoration, staging areas are temporary holding locations, and vendor-managed facilities are owned by suppliers. Valid values: central|regional|field_storeroom|mobile|staging_area|vendor_managed.',
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
  CONSTRAINT `pk_supply_warehouse` PRIMARY KEY (`warehouse_id`)
)
USING DELTA
COMMENT 'Master record for all utility warehouse facilities, field storerooms, and staging areas used to store T&D construction materials, generation spare parts, meters, and emergency restoration stock. Captures facility identification (warehouse number, name, type: central, regional, field storeroom, mobile), organizational assignment (plant), physical attributes (address, GPS coordinates, storage capacity), capability flags (climate control, hazmat storage certification), and responsible warehouse manager. Supports warehouse network planning and emergency restoration staging logistics. | CMM: CIM WorkLocation (broad), IEC61968::Work.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'Warehouse',
  'cmm.cim.class' = 'WorkLocation',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61968::Work',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.warehouse',
  'cmm.gis.location.role' = 'Location (is-a; geometry via Location.PositionPoints)'
);

-- SupplierContract  <<CIM Agreement : extension>>
CREATE TABLE IF NOT EXISTS `supply`.`supplier_contract` (
  `supplier_contract_id` BIGINT NOT NULL COMMENT 'Unique identifier for the supplier contract record. Primary key.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Contracts assign to responsible cost centers for budget ownership and commitment tracking. Contract spend rolls up to cost center actuals for variance analysis and budget forecasting.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Long-term fuel/service contracts embed regulatory compliance requirements (environmental permits, NERC standards, RPS eligibility). Contract approval workflow validates obligation coverage. Real busin',
  `supplier_vendor_id` BIGINT COMMENT 'Identifier of the supplier or vendor party to this contract. Links to the vendor master record in the procurement system.',
  `vendor_id` BIGINT COMMENT 'FK to supply.vendor.vendor_id — Every supply contract is with a specific vendor. Required for contract management and vendor relationship tracking.',
  `approval_date` DATE COMMENT 'Date when the contract was formally approved by authorized signatories and became legally binding.',
  `contract_description` STRING COMMENT 'Detailed narrative description of the contract scope, materials or services covered, and key business terms. For fuel supply contracts, includes fuel type and commodity specifications.',
  `contract_end_date` DATE COMMENT 'Scheduled expiration date of the contract. Nullable for open-ended or evergreen contracts with no fixed termination date.',
  `contract_number` STRING COMMENT 'Externally-known unique business identifier for the supplier contract. Used in procurement documents, purchase orders, and vendor communications.',
  `contract_owner` STRING COMMENT 'Name or identifier of the individual or role responsible for managing this contract, including renewals, amendments, and vendor relationship management.',
  `contract_start_date` DATE COMMENT 'Effective start date when the contract terms become binding and procurement activities can commence.',
  `contract_status` STRING COMMENT 'Current lifecycle state of the supplier contract. Draft contracts are being negotiated, pending approval awaiting authorization, active contracts are in force, suspended contracts are temporarily halted, expired contracts have passed their end date, terminated contracts were ended early, and closed contracts are completed and archived. Reference-value candidates: draft|pending_approval|active|suspended|expired|terminated|closed.',
  `contract_type` STRING COMMENT 'Classification of the supplier contract based on procurement structure and commitment model. Quantity contracts specify fixed quantities, value contracts specify total spend limits, scheduling agreements define delivery schedules, MSAs cover ongoing services, fuel supply contracts govern commodity procurement, and framework agreements establish terms for multiple call-offs. Valid values: quantity_contract|value_contract|scheduling_agreement|master_service_agreement|fuel_supply_contract|framework_agreement.',
  `contract_value_amount` DECIMAL(18,2) COMMENT 'Total monetary value or spending limit of the contract over its full term. For value contracts, this is the maximum spend; for quantity contracts, this is the estimated total value based on unit prices and quantities.',
  `contract_value_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for the contract value amount (e.g., USD, EUR, CAD). Pattern: ^[A-Z]{3}$.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this contract record was first created in the system.',
  `delivery_location` STRING COMMENT 'Primary delivery destination or point of receipt for materials or services under this contract. May reference a warehouse, plant, substation, or generation facility.',
  `delivery_mode` STRING COMMENT 'Transportation method for fuel or material delivery. For fuel supply contracts, includes pipeline (natural gas), rail (coal, uranium), truck, barge, or ship. For equipment contracts, includes truck, rail, or specialized transport. Valid values: pipeline|rail|truck|barge|ship|other.',
  `delivery_point` STRING COMMENT 'Specific physical location or interconnection point where fuel or materials are delivered. For natural gas, this may be a pipeline interconnect or city gate; for coal, a rail siding or stockpile area; for equipment, a warehouse or construction site.',
  `emergency_restoration_contract` BOOLEAN COMMENT 'Indicates whether this is a master service agreement or framework contract specifically for emergency storm restoration, outage response, or disaster recovery services. True for contracts with mutual assistance provisions or emergency response crews.',
  `environmental_compliance_requirements` STRING COMMENT 'Environmental regulations and standards that the supplier must meet, including EPA emissions standards, fuel quality requirements, hazardous material handling, and waste disposal protocols. Critical for fuel supply and generation equipment contracts.',
  `force_majeure_clause` STRING COMMENT 'Contractual provision defining events beyond the control of either party (natural disasters, war, pandemics, regulatory changes) that excuse performance obligations without penalty.',
  `fuel_specification` STRING COMMENT 'Technical specifications for fuel quality, including BTU content, sulfur content, ash content, moisture level, and other commodity-specific parameters. Critical for generation fuel procurement to ensure equipment compatibility and environmental compliance.',
  `fuel_type` STRING COMMENT 'Type of fuel commodity covered by this contract. Applicable to fuel supply contracts for generation facilities. Includes natural gas, coal, uranium, diesel, biomass, and other fuel sources. Valid values: natural_gas|coal|uranium|diesel|biomass|other.',
  `incoterms` STRING COMMENT 'International Commercial Terms defining the responsibilities of buyer and seller for delivery, insurance, and risk transfer. Examples: FOB (Free on Board), CIF (Cost Insurance Freight), DDP (Delivered Duty Paid).',
  `last_amendment_date` DATE COMMENT 'Date of the most recent contract amendment or modification. Null if no amendments have been made since original execution.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this contract record was last updated or modified.',
  `material_group` STRING COMMENT 'High-level categorization of materials or services covered by this contract. Examples include transformers, conductors, meters, poles, generation spare parts, or fuel commodities.',
  `maximum_order_quantity` DECIMAL(15,3) COMMENT 'Maximum quantity that can be ordered under this contract. Used to enforce contract limits and prevent over-commitment.',
  `minimum_order_quantity` DECIMAL(15,3) COMMENT 'Minimum quantity that must be ordered per release or over the contract term, as stipulated in the contract terms. Applicable to quantity contracts and scheduling agreements.',
  `nerc_cip_compliance_required` BOOLEAN COMMENT 'Indicates whether this contract involves materials, services, or access to systems that fall under NERC CIP cybersecurity and physical security standards. True for contracts involving SCADA systems, control centers, generation facilities, or critical cyber assets.',
  `payment_terms` STRING COMMENT 'Agreed payment terms and conditions, including net payment period, early payment discounts, and payment milestones. Examples: Net 30, 2/10 Net 30, or milestone-based payment schedules.',
  `price_escalation_clause` STRING COMMENT 'Description of the price adjustment mechanism tied to inflation indices, commodity price indices, or other economic factors. Common for multi-year contracts to account for cost changes over time.',
  `pricing_index` STRING COMMENT 'Reference index used for price adjustments in fuel supply contracts or commodity contracts. Examples: Henry Hub (natural gas), API2 (coal), spot uranium prices, or CPI (Consumer Price Index).',
  `purchasing_group` STRING COMMENT 'Buyer or procurement team responsible for day-to-day contract administration and purchase order release.',
  `purchasing_organization` STRING COMMENT 'Organizational unit responsible for negotiating and managing this contract. Typically aligned with business divisions such as Transmission and Distribution (T&D), Generation, or Corporate Procurement.',
  `renewal_notice_period_days` INT COMMENT 'Number of days prior to contract expiration that either party must provide notice of intent to renew or terminate. Null if no renewal option exists.',
  `renewal_option` BOOLEAN COMMENT 'Indicates whether the contract includes an option for automatic or negotiated renewal upon expiration. True if renewal provisions exist, false otherwise.',
  `service_level_agreement` STRING COMMENT 'Performance commitments and service standards defined in the contract, including response times, uptime guarantees, delivery lead times, and quality metrics. Common in master service agreements and emergency restoration contracts.',
  `source_system` STRING COMMENT 'Identifier of the operational system of record from which this contract data originated. Typically SAP S/4HANA MM for utility supply chain contracts.',
  `supplier_contract_vendor` BIGINT COMMENT 'FK to supply.vendor.vendor_id — Every supply contract is with a specific vendor. Fundamental FK for contract management and vendor relationship tracking.',
  `take_or_pay_obligation` BOOLEAN COMMENT 'Indicates whether the contract includes a take-or-pay provision requiring the buyer to pay for a minimum quantity regardless of actual consumption. Common in fuel supply contracts for natural gas, coal, and uranium.',
  `take_or_pay_quantity` DECIMAL(15,3) COMMENT 'Minimum quantity the buyer is obligated to purchase or pay for under a take-or-pay provision. Expressed in the contract unit of measure (e.g., MMBtu, short tons).',
  `termination_clause` STRING COMMENT 'Conditions and procedures under which either party may terminate the contract early, including notice periods, termination fees, and grounds for termination (breach, convenience, insolvency).',
  `unit_of_measure` STRING COMMENT 'Standard unit of measure for quantities specified in this contract. Examples include EA (each) for transformers, FT (feet) for conductors, MMBTU (million British thermal units) for natural gas, or TON (short tons) for coal.',
  `warranty_terms` STRING COMMENT 'Warranty coverage provided by the supplier, including warranty period, covered defects, repair or replacement obligations, and exclusions. Particularly important for transformers, generation equipment, and other capital assets.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_supplier_contract` PRIMARY KEY (`supplier_contract_id`)
)
USING DELTA
COMMENT 'Long-term supply agreements and framework contracts with utility vendors covering all contract types: quantity contracts, value contracts, scheduling agreements, master service agreements, and fuel supply contracts. Captures contract identification (number, type), parties and scope (vendor, material or service scope), term and value (start/end dates, total value, minimum order quantity), commercial terms (pricing conditions, escalation clauses, force majeure, delivery schedule lines), and compliance requirements (NERC CIP). For fuel supply contracts: fuel type (natural gas, coal, uranium), commodity specifications (BTU content, sulfur/ash content), delivery logistics (delivery point, pipeline/rail transport mode), financial terms (take-or-pay obligations, quantity in MMBtu or short tons, pricing index such as Henry Hub/API2/spot, price adjustment formula), and environmental compliance requirements. Supports transformer supply agreements, conductor blanket orders, emergency restoration MSAs, and generation fuel procurement. | CMM: CIM Agreement (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SupplierContract',
  'cmm.cim.class' = 'Agreement',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.supplier_contract'
);

-- FuelSupplyContract  <<CIM Agreement : extension>>
CREATE TABLE IF NOT EXISTS `supply`.`fuel_supply_contract` (
  `fuel_supply_contract_id` BIGINT NOT NULL COMMENT 'Unique identifier for the fuel supply contract. Primary key.',
  `compliance_environmental_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.environmental_permit. Business justification: Fuel delivery/storage requires environmental permits (air quality, water discharge, hazmat storage). Real business process: permit compliance verification during contract execution and environmental r',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Fuel contracts track to generation plant cost centers for fuel expense allocation. Critical for power generation cost accounting and rate case cost-of-service calculations.',
  `counterparty_id` BIGINT COMMENT 'Foreign key linking to trading.counterparty. Business justification: Fuel suppliers are trading counterparties for credit risk management and FERC EQR reporting. Links long-term fuel contracts to counterparty master for credit exposure monitoring, collateral management',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Fuel contracts must satisfy environmental compliance (emissions limits, sulfur content) and nuclear regulatory requirements. Contract execution requires regulatory approval validation. Real business p',
  `power_plant_id` BIGINT COMMENT 'Identifier of the generation plant or facility that will consume the fuel under this contract. Nullable if contract covers multiple plants or centralized procurement.',
  `vendor_id` BIGINT COMMENT 'Identifier of the fuel supplier or vendor party to this contract.',
  `ash_content_max_pct` DECIMAL(5,3) COMMENT 'Maximum allowable ash content as a percentage of fuel weight, relevant for coal quality specifications and boiler performance.',
  `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether the contract automatically renews for an additional term unless either party provides termination notice.',
  `base_price` DECIMAL(18,4) COMMENT 'Base or reference price per unit of fuel at contract inception, expressed in the currency specified in price_currency.',
  `btu_content_specification` DECIMAL(10,2) COMMENT 'Specified heat content or energy value of the fuel in BTU per unit (e.g., BTU per cubic foot for gas, BTU per pound for coal), used for quality assurance and pricing adjustments.',
  `contract_manager_name` STRING COMMENT 'Name of the utility employee or role responsible for managing and administering this fuel supply contract.',
  `contract_number` STRING COMMENT 'Externally-known business identifier for the fuel supply contract, used in procurement documents and supplier communications. Pattern: ^[A-Z0-9]{8,20}$.',
  `contract_status` STRING COMMENT 'Current lifecycle status of the fuel supply contract indicating whether it is in draft, active execution, suspended, expired, terminated, or renewed. Valid values: draft|active|suspended|expired|terminated|renewed.',
  `contract_type` STRING COMMENT 'Type of fuel covered by this supply contract, distinguishing between natural gas, coal, nuclear fuel (uranium), biomass, fuel oil, and diesel. Valid values: natural_gas|coal|uranium|biomass|fuel_oil|diesel.',
  `contract_value_total` DECIMAL(18,2) COMMENT 'Estimated total monetary value of the fuel supply contract over its full term, calculated as contracted quantity multiplied by base price. Expressed in price_currency.',
  `contracted_quantity` DECIMAL(18,3) COMMENT 'Total quantity of fuel contracted for delivery over the contract term, expressed in the unit of measure specified in quantity_uom.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this fuel supply contract record was first created in the system.',
  `credit_support_required` BOOLEAN COMMENT 'Indicates whether the contract requires credit support such as letters of credit, parent guarantees, or collateral to secure payment obligations.',
  `delivery_flexibility` STRING COMMENT 'Type of delivery commitment indicating whether deliveries are firm (guaranteed), interruptible (subject to curtailment), swing (variable within a range), baseload (constant), or peaking (on-demand). Valid values: firm|interruptible|swing|baseload|peaking.',
  `delivery_point` STRING COMMENT 'Physical location or interconnect where fuel is delivered, such as a generation plant gate, pipeline interconnection point, rail siding, or port terminal.',
  `delivery_schedule` STRING COMMENT 'Textual description or reference to the delivery schedule specifying timing, frequency, and quantity of fuel deliveries (e.g., daily nominations, monthly shipments, seasonal delivery windows).',
  `effective_end_date` DATE COMMENT 'Date when the fuel supply contract expires or terminates. Nullable for evergreen or indefinite contracts.',
  `effective_start_date` DATE COMMENT 'Date when the fuel supply contract becomes legally binding and fuel deliveries may commence.',
  `environmental_compliance_notes` STRING COMMENT 'Free-text notes documenting environmental compliance requirements, emissions limits, renewable energy certificate (REC) provisions, or sustainability commitments associated with the fuel supply.',
  `force_majeure_clause` BOOLEAN COMMENT 'Indicates whether the contract includes a force majeure clause allowing suspension or termination of obligations due to extraordinary events beyond the parties\' control.',
  `last_modified_by` STRING COMMENT 'Username or identifier of the user who last modified this fuel supply contract record.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this fuel supply contract record was last updated or modified.',
  `minimum_take_quantity` DECIMAL(18,3) COMMENT 'Minimum quantity of fuel the utility must take (or pay for) under a take-or-pay clause, expressed in quantity_uom. Nullable if no take-or-pay obligation exists.',
  `moisture_content_max_pct` DECIMAL(5,3) COMMENT 'Maximum allowable moisture content as a percentage of fuel weight, affecting fuel heating value and handling characteristics, primarily for coal and biomass.',
  `payment_terms` STRING COMMENT 'Description of payment terms including payment due date relative to delivery, early payment discounts, late payment penalties, and payment method.',
  `price_adjustment_formula` STRING COMMENT 'Formula or methodology for adjusting fuel price over time, including escalation clauses, index multipliers, and adjustment frequency.',
  `price_adjustment_frequency` STRING COMMENT 'Frequency at which fuel price is adjusted or reset according to the pricing index or formula. Valid values: monthly|quarterly|semi_annual|annual|spot.',
  `price_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for fuel pricing (e.g., USD, EUR, GBP). Pattern: ^[A-Z]{3}$.',
  `pricing_index` STRING COMMENT 'Market pricing index or benchmark used to determine fuel price, such as Henry Hub (natural gas), API2 (coal), spot uranium price, or Brent crude (oil).',
  `purchasing_organization` STRING COMMENT 'Organizational unit within the utility responsible for procuring fuel under this contract, such as a regional procurement office or centralized supply chain division.',
  `quantity_uom` STRING COMMENT 'Unit of measure for contracted fuel quantity, such as MMBtu (Million British Thermal Units) for gas, short tons or metric tons for coal, kilograms for uranium, barrels or gallons for oil, or cubic meters for gas. Reference-value candidates: MMBtu|short_ton|metric_ton|kg_uranium|barrel|gallon|cubic_meter.',
  `regulatory_approval_date` DATE COMMENT 'Date when regulatory approval for the fuel supply contract was granted. Nullable if no approval is required or approval is pending.',
  `regulatory_approval_required` BOOLEAN COMMENT 'Indicates whether the fuel supply contract requires approval or filing with regulatory authorities such as FERC or state Public Utility Commission (PUC) for cost recovery.',
  `renewal_term_months` INT COMMENT 'Duration in months of each automatic renewal term, if auto-renewal is enabled. Nullable if contract does not auto-renew.',
  `sulfur_content_max_pct` DECIMAL(5,3) COMMENT 'Maximum allowable sulfur content as a percentage of fuel weight or volume, critical for environmental compliance and emissions control. Applicable primarily to coal and fuel oil.',
  `supplier_name` STRING COMMENT 'Legal name of the fuel supplier or vendor providing fuel under this contract.',
  `take_or_pay_obligation` BOOLEAN COMMENT 'Indicates whether the contract includes a take-or-pay clause requiring the utility to pay for a minimum quantity of fuel regardless of actual consumption.',
  `termination_notice_days` INT COMMENT 'Number of days advance notice required for contract termination by either party, as specified in the contract terms.',
  `transport_mode` STRING COMMENT 'Primary mode of transportation for fuel delivery, such as pipeline (natural gas), rail (coal, uranium), truck, barge, ship, or conveyor. Valid values: pipeline|rail|truck|barge|ship|conveyor.',
  `uranium_enrichment_pct` DECIMAL(5,3) COMMENT 'Percentage of fissile U-235 isotope in uranium fuel, applicable only to nuclear fuel contracts. Typical values range from 3% to 5% for commercial reactor fuel.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_fuel_supply_contract` PRIMARY KEY (`fuel_supply_contract_id`)
)
USING DELTA
COMMENT 'Specialized contract master for utility fuel procurement covering natural gas, coal, and nuclear fuel (uranium) supply agreements. Captures fuel type, BTU content specifications, delivery point (plant or interconnect), pipeline or rail transport mode, take-or-pay obligations, fuel quantity in MMBtu or short tons, pricing index (Henry Hub, API2, spot), price adjustment formula, delivery schedule, fuel quality specifications, and environmental compliance requirements (sulfur content, ash content). Distinct from general supplier contracts due to commodity-specific regulatory and operational attributes. | CMM: CIM Agreement (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'FuelSupplyContract',
  'cmm.cim.class' = 'Agreement',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.fuel_supply_contract'
);

-- PurchaseRequisition  <<CIM ErpRequisition : exact>>
CREATE TABLE IF NOT EXISTS `supply`.`purchase_requisition` (
  `purchase_requisition_id` BIGINT NOT NULL COMMENT 'Unique identifier for the purchase requisition record. Primary key.',
  `approver_employee_id` BIGINT COMMENT 'Employee identifier of the current or final approver in the workflow, null if still pending first approval.',
  `corrective_action_plan_id` BIGINT COMMENT 'Foreign key linking to compliance.corrective_action_plan. Business justification: CAPs from audit findings often require procurement of equipment/services to remediate violations. Real business process: CAP implementation, budget tracking, and remediation project management for com',
  `damage_assessment_id` BIGINT COMMENT 'Foreign key linking to outage.damage_assessment. Business justification: Damage assessments drive emergency material requisitions when stock is insufficient. Links requisition to the field assessment that identified the need, enabling tracking of assessment-to-procurement',
  `material_master_id` BIGINT COMMENT 'FK to supply.material_master.material_master_id — Purchase requisitions request specific materials. This FK enables MRP-driven procurement and material demand tracking.',
  `preferred_vendor_id` BIGINT COMMENT 'Foreign key linking to supply.vendor. Business justification: Requisitions may specify preferred vendor based on past performance or contracts. N:1 relationship - many requisitions may prefer one vendor. Adding preferred_vendor_id FK enables JOIN to retrieve ven',
  `primary_purchase_requisitioner_employee_id` BIGINT COMMENT 'Employee identifier of the person who created the requisition, used for audit trail and communication regarding requisition details.',
  `purchase_material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: Purchase requisitions request specific materials. N:1 relationship - many requisitions for one material. Adding material_master_id FK enables JOIN to retrieve authoritative material data. Removing mat',
  `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supply.purchase_order. Business justification: Requisitions are converted into purchase orders during the procurement process. N:1 relationship - multiple requisition lines may be consolidated into one PO. Adding purchase_order_id FK tracks the co',
  `triggering_work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: Purchase requisitions are often triggered by work orders needing materials. Links requisition to originating work order for cost allocation, capex/opex classification validation, and tracking material',
  `account_assignment_category` STRING COMMENT 'Classification of how costs will be assigned: to a cost center for overhead, work order for maintenance, project/WBS for capital, asset for direct capitalization, sales order for customer-specific, or network for PM network activities. Valid values: cost_center|work_order|project|asset|sales_order|network.',
  `approval_date` DATE COMMENT 'Date when the requisition received final approval and became eligible for conversion to purchase order, null if still pending or rejected.',
  `approval_level` INT COMMENT 'Current approval step in the workflow sequence (1 for supervisor, 2 for manager, 3 for director, etc.), indicates progress through approval hierarchy.',
  `approval_workflow_code` STRING COMMENT 'Unique identifier for the approval workflow instance in the workflow engine, tracks multi-level approval routing based on value thresholds and organizational hierarchy. Pattern: ^[A-Z0-9]{1,20}$.',
  `capital_expenditure_flag` BOOLEAN COMMENT 'Boolean indicator that this requisition is for capital asset acquisition or construction and will be capitalized on the balance sheet rather than expensed, drives financial reporting and regulatory asset base (RAB) tracking.',
  `contract_number` STRING COMMENT 'Reference to an existing purchasing contract or outline agreement against which this requisition should be fulfilled, enables contract compliance and pricing. Pattern: ^[0-9]{10}$.',
  `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the purchase requisition record was first created in the database, used for audit trail and data lineage.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the estimated value (USD for US Dollar, CAD for Canadian Dollar, EUR for Euro, etc.). Pattern: ^[A-Z]{3}$.',
  `delivery_address_code` STRING COMMENT 'Address number for the specific delivery location if different from the plant default, used for direct job-site delivery in construction or field maintenance scenarios. Pattern: ^[A-Z0-9]{1,10}$.',
  `emergency_procurement_flag` BOOLEAN COMMENT 'Boolean indicator that this requisition is for emergency restoration or critical outage response, triggers expedited approval workflow and bypass of standard lead times.',
  `estimated_total_value` DECIMAL(17,2) COMMENT 'Total estimated value of the requisition line (quantity × estimated unit price), used for approval workflow routing and budget consumption.',
  `estimated_unit_price` DECIMAL(15,2) COMMENT 'Estimated or budgeted price per unit of measure in the requisition currency, used for budget checking and approval thresholds. May be sourced from material master, contract, or manual entry.',
  `fixed_vendor_flag` BOOLEAN COMMENT 'Boolean indicator that the preferred vendor is mandatory (sole source, OEM requirement, or contract obligation) and cannot be changed during purchase order creation.',
  `gl_account_code` STRING COMMENT 'General ledger account number for expense or asset account assignment, determines whether the requisition is capitalized (CAPEX) or expensed (OPEX). Pattern: ^[0-9]{6,10}$.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent update to the requisition record, tracks changes through the approval and conversion lifecycle.',
  `long_text_note` STRING COMMENT 'Extended free-text field for detailed specifications, technical requirements, delivery instructions, or special handling notes that do not fit in standard fields.',
  `material_group` STRING COMMENT 'Hierarchical classification code grouping similar materials for procurement analytics and sourcing strategy (e.g., transformers, conductors, meters, generation spare parts, fuel). Pattern: ^[A-Z0-9]{1,9}$.',
  `material_number` STRING COMMENT 'SAP material master number identifying the specific material being requested (transformer, conductor, meter, pole, spare part, fuel). Null for service requisitions or free-text material descriptions. Pattern: ^[A-Z0-9]{1,18}$.',
  `mrp_controller` STRING COMMENT 'Three-character code identifying the MRP controller or planner responsible for material availability planning, relevant for requisitions generated by MRP run. Pattern: ^[A-Z0-9]{3}$.',
  `mrp_type` STRING COMMENT 'Classification of how the requisition was triggered: manual user creation, automatic MRP generation, reorder point breach, forecast-based planning, or project material requirement. Valid values: manual|mrp_generated|reorder_point|forecast_based|project_based.',
  `priority` STRING COMMENT 'Business priority classification indicating urgency: routine for planned procurement, urgent for expedited needs, emergency restoration for storm/outage response, critical outage for immediate grid reliability needs. Valid values: routine|urgent|emergency_restoration|critical_outage.',
  `purchase_requisition_material` BIGINT COMMENT 'FK to supply.material_master.material_master_id — Purchase requisitions request specific materials. FK needed to trace demand from requisition through to PO and receipt.',
  `purchasing_group` STRING COMMENT 'Three-character code for the buyer or procurement team responsible for processing this requisition into a purchase order, enables workload distribution and accountability. Pattern: ^[A-Z0-9]{3}$.',
  `purchasing_organization` STRING COMMENT 'Four-character code identifying the organizational unit responsible for procurement execution, may be centralized corporate procurement or regional purchasing group. Pattern: ^[A-Z0-9]{4}$.',
  `quantity` DECIMAL(15,3) COMMENT 'Requested quantity of the material or service in the base unit of measure. For services, may represent hours, days, or service units.',
  `rejection_reason` STRING COMMENT 'Free-text explanation provided by approver if the requisition was rejected, guides requisitioner on necessary corrections or justification.',
  `requesting_cost_center` STRING COMMENT 'Ten-digit cost center code for the organizational unit requesting the material or service, used for budget tracking and financial account assignment. Pattern: ^[0-9]{10}$.',
  `requesting_plant_code` STRING COMMENT 'Four-character alphanumeric code identifying the utility plant, generation station, substation, or service center that originated the requisition. Pattern: ^[A-Z0-9]{4}$.',
  `required_delivery_date` DATE COMMENT 'Date by which the requested material or service must be delivered to meet operational needs, drives procurement urgency and scheduling.',
  `requisition_date` DATE COMMENT 'Date when the purchase requisition was created in the system, representing the business event timestamp for the procurement request initiation.',
  `requisition_number` STRING COMMENT 'Externally visible business identifier for the purchase requisition, typically a 10-digit sequential number assigned by SAP MM upon creation. Pattern: ^[0-9]{10}$.',
  `requisition_status` STRING COMMENT 'Current lifecycle state of the requisition in the procurement workflow, from initial draft through approval, conversion to purchase order, and final closure or cancellation. Reference-value candidates: draft|pending_approval|approved|rejected|partially_ordered|fully_ordered|closed|cancelled.',
  `requisition_type` STRING COMMENT 'Classification of the requisition based on procurement scenario: standard purchase, subcontracting with component provision, stock transfer between plants, consignment, or service procurement. Valid values: standard|subcontracting|stock_transfer|consignment|service.',
  `source_of_supply` STRING COMMENT 'Recommended or assigned source for procurement: existing contract, outline agreement (blanket PO), purchasing info record, manual vendor selection, or MRP-generated recommendation. Valid values: contract|outline_agreement|info_record|manual|mrp_recommendation.',
  `storage_location` STRING COMMENT 'Four-character code identifying the warehouse, yard, or storeroom where the material should be delivered upon receipt, used for inventory management and logistics planning. Pattern: ^[A-Z0-9]{4}$.',
  `unit_of_measure` STRING COMMENT 'ISO unit code for the quantity (EA for each, FT for feet, MT for metric ton, KG for kilogram, HR for hour, etc.). Pattern: ^[A-Z]{2,3}$.',
  `wbs_element` STRING COMMENT 'Project-based account assignment for capital projects such as transmission line construction, substation upgrades, or generation plant expansions. Null for expense requisitions. Pattern: ^[A-Z0-9\\-]{1,24}$.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_purchase_requisition` PRIMARY KEY (`purchase_requisition_id`)
)
USING DELTA
COMMENT 'Internal procurement request document generated by utility departments (T&D construction, generation maintenance, metering, grid operations) or automatically by material requirements planning to initiate the purchasing process. Captures requisition identification (number, type), material or service requested with quantity and required delivery date, organizational context (requesting plant, cost center or WBS element, account assignment), priority classification (routine, urgent, emergency restoration), approval workflow status, estimated cost, and source of supply recommendation. Converts downstream to purchase orders upon approval. | CMM: CIM ErpRequisition (exact), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PurchaseRequisition',
  'cmm.cim.class' = 'ErpRequisition',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.purchase_requisition'
);

-- GoodsIssue  <<CIM ErpIssueInventory : exact>>
CREATE TABLE IF NOT EXISTS `supply`.`goods_issue` (
  `goods_issue_id` BIGINT NOT NULL COMMENT 'Unique identifier for the goods issue document. Primary key for this entity.',
  `capital_project_id` BIGINT COMMENT 'Foreign key reference to the capital project for which the material was issued, supporting CAPEX tracking and regulatory asset base reporting.',
  `goods_receipt_id` BIGINT COMMENT 'Foreign key linking to supply.goods_receipt. Business justification: Goods issues may reference the original goods receipt for returns, reversals, or special stock movements. N:1 relationship - many issues may reference one receipt (e.g., partial returns). Adding goods',
  `material_master_id` BIGINT COMMENT 'Foreign key reference to the material master record for the item being issued (e.g., transformer, conductor, meter, pole, generation spare part).',
  `outage_crew_dispatch_id` BIGINT COMMENT 'Foreign key linking to outage.crew_dispatch. Business justification: Field crews consume materials (fuses, connectors, wire) during outage restoration work. Links material usage to specific crew dispatches for job costing, inventory replenishment triggers, and tracking',
  `primary_goods_employee_id` BIGINT COMMENT 'The user ID or employee identifier of the warehouse clerk or field technician who executed the goods issue transaction.',
  `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supply.purchase_order. Business justification: Goods issues may reference the originating PO for returns, special stock movements, or consignment scenarios. N:1 relationship - many issues may reference one PO. Adding purchase_order_id FK enables t',
  `training_record_id` BIGINT COMMENT 'Foreign key linking to compliance.training_record. Business justification: Issuing CIP-critical equipment requires personnel with CIP training (CIP-004). Real business process: access control verification, training compliance validation, and personnel authorization for handl',
  `vendor_id` BIGINT COMMENT 'Foreign key reference to the vendor or supplier from whom the material was originally procured.',
  `warehouse_id` BIGINT COMMENT 'Foreign key linking to supply.warehouse. Business justification: Goods are issued from specific warehouses. N:1 relationship - many issues from one warehouse. Adding warehouse_id FK enables JOIN to retrieve warehouse master data. Not removing plant_code and storage',
  `work_order_id` BIGINT COMMENT 'Foreign key reference to the maintenance work order or field service order for which the material was issued.',
  `asset_number` STRING COMMENT 'The fixed asset number if the material was issued for installation or capitalization to a specific utility asset (transformer, substation, generation unit).',
  `batch_number` STRING COMMENT 'Batch or lot number for batch-managed materials, enabling traceability for quality control and warranty purposes.',
  `cost_center_code` STRING COMMENT 'The cost center to which the material consumption cost is posted for operational expense tracking. Pattern: ^[A-Z0-9]{10}$.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this goods issue record was first created in the system.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the valuation amount (e.g., USD, CAD, EUR). Pattern: ^[A-Z]{3}$.',
  `delivery_note_number` STRING COMMENT 'The delivery note or packing slip number associated with the physical movement of material from warehouse to field location.',
  `document_date` DATE COMMENT 'The date printed on the physical goods issue document or the date the transaction was initiated in the field.',
  `functional_location` STRING COMMENT 'The technical functional location in the asset hierarchy where the material was installed or consumed (e.g., substation bay, generation unit, distribution feeder).',
  `general_ledger_account` STRING COMMENT 'The GL account to which the material consumption value is posted in financial accounting. Pattern: ^[0-9]{6,10}$.',
  `header_text` STRING COMMENT 'Free-form text field for additional notes or comments about the goods issue transaction at the document header level.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this goods issue record was last updated or modified.',
  `material_description` STRING COMMENT 'Short text description of the material being issued for human readability and reporting purposes.',
  `material_document_number` STRING COMMENT 'The externally-known SAP material document number assigned to this goods issue transaction. Unique business identifier used for tracking and audit purposes. Pattern: ^[0-9]{10}$.',
  `material_document_year` INT COMMENT 'Fiscal year in which the material document was posted. Part of the compound business key in SAP MM.',
  `material_number` STRING COMMENT 'The business material number or SKU from the spare parts catalog identifying the specific item issued.',
  `movement_reason_code` STRING COMMENT 'Detailed reason code providing additional context for the goods issue movement type, used for regulatory reporting and internal analytics.',
  `movement_type` STRING COMMENT 'Three-digit SAP movement type code that classifies the type of goods issue (e.g., 201 for consumption to cost center, 261 for consumption to work order, 281 for consumption to project WBS element, 551 for scrapping without vendor credit). Pattern: ^[0-9]{3}$.',
  `plant_code` STRING COMMENT 'The SAP plant code representing the utility operational facility (generation plant, service center, district office) from which the material was issued. Pattern: ^[A-Z0-9]{4}$.',
  `posting_date` DATE COMMENT 'The date on which the goods issue was posted to inventory and financial accounting. This is the principal business event timestamp for the transaction.',
  `quantity_issued` DECIMAL(15,3) COMMENT 'The quantity of material withdrawn from warehouse stock in this goods issue transaction.',
  `reason_code` STRING COMMENT 'The business reason or purpose for the goods issue, enabling analysis of material consumption patterns by activity type. Valid values: emergency_restoration|planned_maintenance|corrective_maintenance|capital_construction|routine_operations|scrapping.',
  `reference_document_number` STRING COMMENT 'External reference document number such as a field service ticket, outage restoration order, or emergency response authorization.',
  `reservation_number` STRING COMMENT 'The material reservation number if the goods issue was made against a pre-existing reservation for planned maintenance or construction activities.',
  `reversal_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether this goods issue document has been reversed or cancelled.',
  `reversed_document_number` STRING COMMENT 'The material document number of the original goods issue that this document reverses, if applicable.',
  `special_stock_indicator` STRING COMMENT 'Indicator for special stock types such as consignment inventory, project-specific stock, or returnable packaging. Valid values: consignment|project_stock|sales_order_stock|returnable_packaging|standard_stock.',
  `stock_type` STRING COMMENT 'The stock type from which the material was issued, indicating quality status and usability. Valid values: unrestricted|quality_inspection|blocked|restricted_use.',
  `storage_location_code` STRING COMMENT 'The specific warehouse or storage location within the plant from which the material was withdrawn. Pattern: ^[A-Z0-9]{4}$.',
  `unit_of_measure` STRING COMMENT 'The unit of measure for the quantity issued (e.g., EA for each, FT for feet, M for meters, KG for kilograms, L for liters). Pattern: ^[A-Z]{2,3}$.',
  `valuation_amount` DECIMAL(15,2) COMMENT 'The total monetary value of the material issued, calculated based on the material valuation price and quantity issued.',
  `wbs_element_code` STRING COMMENT 'The project WBS element for capital construction projects (T&D construction, generation expansion) to which the material cost is capitalized.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_goods_issue` PRIMARY KEY (`goods_issue_id`)
)
USING DELTA
COMMENT 'Goods issue document recording withdrawal of materials from warehouse stock for utility field operations, T&D construction projects, generation maintenance work orders, and emergency restoration activities. Captures material document number, posting date, movement type, material, quantity issued, storage location, plant, cost center or WBS element, and work order reference. Reduces warehouse stock and posts material consumption costs. | CMM: CIM ErpIssueInventory (exact), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'GoodsIssue',
  'cmm.cim.class' = 'ErpIssueInventory',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.goods_issue'
);

-- StockTransfer  <<CIM ErpIssueInventory : broad>>
CREATE TABLE IF NOT EXISTS `supply`.`stock_transfer` (
  `stock_transfer_id` BIGINT NOT NULL COMMENT 'Unique identifier for the stock transfer record. Primary key for inter-plant and inter-storage-location material movements within the utility supply chain network.',
  `approver_employee_id` BIGINT COMMENT 'Reference to the employee who approved the stock transfer. Captures authorization for material movements and inventory rebalancing decisions.',
  `capital_project_id` BIGINT COMMENT 'Reference to the capital project or work order for which materials are being staged. Links transfer to T&D construction projects or major maintenance initiatives.',
  `mutual_aid_request_id` BIGINT COMMENT 'Foreign key linking to outage.mutual_aid_request. Business justification: Mutual aid involves physical transfer of materials (poles, wire, transformers) between utilities. The mutual_aid_flag indicates this but doesn\'t link to the specific request. Required for tracking mat',
  `primary_stock_warehouse_id` BIGINT COMMENT 'Reference to the specific storage location within the sending plant from which materials are being moved. Represents warehouse zones, bins, or staging areas.',
  `receiving_plant_id` BIGINT COMMENT 'Reference to the destination plant or facility to which materials are being transferred. Represents regional storerooms, substations, or field staging areas receiving the materials.',
  `receiving_storage_location_warehouse_id` BIGINT COMMENT 'Reference to the specific storage location within the receiving plant where materials will be stored. Represents destination warehouse zones, bins, or staging areas.',
  `requester_employee_id` BIGINT COMMENT 'Reference to the employee who initiated the stock transfer request. Links to workforce management for accountability and approval workflows.',
  `sending_plant_id` BIGINT COMMENT 'Reference to the source plant or facility from which materials are being transferred. Represents central warehouses, regional storerooms, or substations in the utility service territory.',
  `stock_material_master_id` BIGINT COMMENT 'Reference to the utility material being transferred. Links to the spare parts catalog for transformers, conductors, meters, poles, generation spare parts, or other T&D construction materials.',
  `to_material_master_id` BIGINT COMMENT 'FK to supply.material_master.material_master_id — Every stock transfer moves a specific material between locations. Required for inventory tracking.',
  `work_order_id` BIGINT COMMENT 'Reference to the maintenance work order requiring these materials. Links transfer to specific asset maintenance or repair activities.',
  `actual_arrival_date` DATE COMMENT 'Actual date when materials arrived at the receiving location. Used for supply chain performance metrics and transit time analysis.',
  `actual_departure_date` DATE COMMENT 'Actual date when materials departed the sending location. Captured for transit time analysis and supply chain performance measurement.',
  `cancellation_reason` STRING COMMENT 'Explanation for why the stock transfer was cancelled. Captures business justification for cancelled material movements.',
  `cancelled_timestamp` TIMESTAMP COMMENT 'Date and time when the stock transfer was cancelled. Nullable field populated only for cancelled transfers.',
  `carrier_name` STRING COMMENT 'Name of the transportation carrier or logistics provider handling the material movement. May be external vendor or internal utility fleet.',
  `completed_timestamp` TIMESTAMP COMMENT 'Date and time when the stock transfer was fully completed with goods receipt posted at the receiving location. Marks the end of the transfer lifecycle.',
  `cost_center` STRING COMMENT 'Cost center to which the transfer costs are allocated. Used for financial tracking of logistics and material handling expenses. Pattern: ^CC-[0-9]{6}$.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the stock transfer record was first created in the system. Audit trail for transfer order initiation.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for transfer costs and material values. Typically USD for US utilities. Pattern: ^[A-Z]{3}$.',
  `emergency_restoration_flag` BOOLEAN COMMENT 'Indicates whether this transfer is part of an emergency restoration effort following outages or storm events. True for emergency materials movements supporting grid restoration.',
  `estimated_arrival_date` DATE COMMENT 'Planned date when materials are expected to arrive at the receiving location. Critical for project staging coordination and emergency restoration resource planning.',
  `estimated_departure_date` DATE COMMENT 'Planned date when materials are scheduled to leave the sending location. Used for logistics planning and emergency restoration timeline management.',
  `goods_issue_document_number` STRING COMMENT 'SAP material document number for the goods issue posting at the sending location. Records the inventory reduction at the source. Pattern: ^GI-[0-9]{10}$.',
  `goods_receipt_document_number` STRING COMMENT 'SAP material document number for the goods receipt posting at the receiving location. Records the inventory increase at the destination. Pattern: ^GR-[0-9]{10}$.',
  `hazmat_flag` BOOLEAN COMMENT 'Indicates whether the transferred material is classified as hazardous requiring special transportation and handling procedures. True for materials subject to DOT hazmat regulations.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the stock transfer record was last updated. Tracks changes to transfer status, dates, or other attributes throughout the transfer lifecycle.',
  `material_description` STRING COMMENT 'Textual description of the material being transferred. Provides human-readable identification of transformers, conductors, meters, poles, or other utility materials.',
  `material_number` STRING COMMENT 'Business identifier for the material being transferred. SAP material master number for the utility asset or spare part. Pattern: ^MAT-[A-Z0-9]{8}$.',
  `material_value_amount` DECIMAL(15,2) COMMENT 'Total inventory value of the materials being transferred based on standard cost or moving average price. Used for inventory accounting and asset tracking.',
  `mutual_aid_flag` BOOLEAN COMMENT 'Indicates whether this transfer is part of a mutual aid agreement with another utility. True for materials shared across utility service territories during major events.',
  `priority_level` STRING COMMENT 'Urgency classification for the stock transfer. Critical priority for emergency restoration materials, high for project-critical items, normal for routine replenishment. Valid values: critical|high|normal|low.',
  `receiving_plant_code` STRING COMMENT 'Business identifier for the destination plant. SAP plant code for the receiving warehouse or facility. Pattern: ^PLT-[0-9]{4}$.',
  `receiving_storage_location_code` STRING COMMENT 'Business identifier for the destination storage location. SAP storage location code within the receiving plant. Pattern: ^SL-[A-Z0-9]{6}$.',
  `sending_plant_code` STRING COMMENT 'Business identifier for the source plant. SAP plant code for the originating warehouse or facility. Pattern: ^PLT-[0-9]{4}$.',
  `sending_storage_location_code` STRING COMMENT 'Business identifier for the source storage location. SAP storage location code within the sending plant. Pattern: ^SL-[A-Z0-9]{6}$.',
  `shipment_tracking_number` STRING COMMENT 'External tracking number provided by the carrier for shipment visibility. Enables real-time tracking of materials in transit for emergency restoration logistics.',
  `special_handling_instructions` STRING COMMENT 'Free-text instructions for special handling requirements during transport. Includes hazardous material warnings, temperature controls, fragile item handling, or security requirements for high-value utility equipment.',
  `transfer_cost_amount` DECIMAL(15,2) COMMENT 'Total cost associated with the stock transfer including transportation, handling, and logistics expenses. Measured in the utilitys reporting currency.',
  `transfer_order_number` STRING COMMENT 'Business identifier for the stock transfer order. Externally-known unique number assigned by SAP MM for tracking material movements between plants and storage locations. Pattern: ^TO-[0-9]{10}$.',
  `transfer_quantity` DECIMAL(18,3) COMMENT 'Quantity of material being transferred between locations. Measured in the materials base unit of measure. Critical for inventory rebalancing and emergency restoration supply chain planning.',
  `transfer_reason_code` STRING COMMENT 'Business reason for the stock transfer. Distinguishes between emergency restoration needs, routine replenishment, T&D construction project staging, mutual aid support, and inventory optimization movements. Reference-value candidates: emergency_restoration|inventory_rebalancing|project_staging|routine_replenishment|mutual_aid|seasonal_adjustment|obsolescence_transfer.',
  `transfer_status` STRING COMMENT 'Current lifecycle status of the stock transfer. Tracks the transfer workflow from creation through delivery or cancellation. Critical for emergency restoration supply chain visibility and mutual aid material tracking. Valid values: created|in_transit|delivered|cancelled|on_hold|partially_delivered.',
  `transfer_type` STRING COMMENT 'Classification of the stock transfer based on source and destination type. Distinguishes between routine replenishment, emergency restoration rebalancing, mutual aid movements, and T&D construction project staging. Reference-value candidates: plant_to_plant|storage_location_to_storage_location|warehouse_to_substation|warehouse_to_field|emergency_restoration|mutual_aid|project_staging.',
  `transit_duration_days` INT COMMENT 'Number of days materials spent in transit between sending and receiving locations. Calculated from actual departure and arrival dates for logistics performance analysis.',
  `transport_mode` STRING COMMENT 'Method of transportation used for the material transfer. Identifies logistics mode for tracking transit times and costs across the utility service territory. Valid values: truck|rail|air|courier|internal_forklift|utility_fleet.',
  `unit_of_measure` STRING COMMENT 'Unit of measure for the transfer quantity. Standard UOM for utility materials such as each, feet, meters, kilograms, pounds, gallons, liters, tons, rolls, spools, or sets. Reference-value candidates: EA|FT|M|KG|LB|GAL|L|TON|ROLL|SPOOL|SET.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_stock_transfer` PRIMARY KEY (`stock_transfer_id`)
)
USING DELTA
COMMENT 'Inter-plant and inter-storage-location material transfer records for utility materials moved between central warehouses, regional storerooms, substations, and field staging areas. Captures transfer order number, sending and receiving plant and storage location, material, transfer quantity, unit of measure, transfer reason (emergency restoration rebalancing, project staging, routine replenishment), transport mode, estimated and actual transit dates, and transfer status. Supports emergency restoration supply chain logistics, mutual aid material movements, and T&D construction material staging across the utility service territory. | CMM: CIM ErpIssueInventory (broad), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'StockTransfer',
  'cmm.cim.class' = 'ErpIssueInventory',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.stock_transfer'
);

-- InvoiceVerification  <<CIM ErpPayable : broad>>
CREATE TABLE IF NOT EXISTS `supply`.`invoice_verification` (
  `invoice_verification_id` BIGINT NOT NULL COMMENT 'Unique identifier for the invoice verification record. Primary key for the invoice verification entity.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Invoices allocate to cost centers for budget tracking and variance analysis. Invoice posting updates cost center actuals for management reporting and budget control.',
  `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Invoice verification posts to GL accounts for AP accrual and expense recognition. Three-way match completion triggers GL posting for financial statement accuracy.',
  `goods_receipt_id` BIGINT COMMENT 'Reference to the goods receipt document confirming physical delivery of materials or services. Required for three-way match validation.',
  `invoice_purchase_order_id` BIGINT COMMENT 'Reference to the purchase order against which this invoice is being verified. Core component of three-way matching.',
  `invoice_vendor_id` BIGINT COMMENT 'Identifier of the vendor who submitted the invoice. Links to vendor master data for payment processing and supplier performance tracking.',
  `primary_purchase_order_id` BIGINT COMMENT 'FK to supply.purchase_order.purchase_order_id — Three-way match requires invoice-to-PO reference. This is the core link for logistics invoice verification.',
  `primary_vendor_id` BIGINT COMMENT 'FK to supply.vendor.vendor_id — Every invoice comes from a vendor. Required for AP processing and vendor payment tracking.',
  `baseline_date` DATE COMMENT 'Reference date used as the starting point for calculating payment due date based on payment terms. Typically the invoice date or posting date.',
  `blocking_reason_code` STRING COMMENT 'Code indicating why the invoice is blocked from payment. Common reasons include price variance, quantity variance, quality hold, or missing documentation. Reference-value candidates: price_variance|quantity_variance|quality_hold|missing_gr|missing_po|duplicate_invoice|vendor_hold|manual_block|tax_issue|approval_pending.',
  `blocking_reason_description` STRING COMMENT 'Detailed explanation of why the invoice is blocked from payment. Provides context for accounts payable and procurement teams to resolve issues.',
  `clearing_date` DATE COMMENT 'Date when the invoice was fully paid and cleared from open accounts payable. Null for unpaid invoices.',
  `clearing_document_number` STRING COMMENT 'Reference to the payment document that cleared this invoice. Links invoice verification to payment run for audit trail.',
  `clearing_status` STRING COMMENT 'Status indicating whether the invoice has been paid and cleared in accounts payable. Tracks payment lifecycle from open to fully cleared. Valid values: open|partially_cleared|fully_cleared|cancelled.',
  `company_code` STRING COMMENT 'Legal entity code within the utility organization that is responsible for this invoice. Supports multi-entity financial consolidation.',
  `created_timestamp` TIMESTAMP COMMENT 'System timestamp recording when the invoice verification record was first created in the ERP system. Audit trail for data lineage.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code indicating the currency in which the invoice is denominated (e.g., USD, EUR, GBP). Pattern: ^[A-Z]{3}$.',
  `discount_amount` DECIMAL(18,2) COMMENT 'Cash discount amount available if payment is made within the early payment discount period specified in payment terms.',
  `discount_due_date` DATE COMMENT 'Last date by which payment must be made to qualify for the early payment discount. Supports cash management optimization.',
  `document_date` DATE COMMENT 'Date the invoice verification document was created in the system. May differ from posting date due to workflow approvals.',
  `fiscal_period` INT COMMENT 'Fiscal period (month) within the fiscal year when the invoice was posted. Supports monthly financial close and accrual accounting.',
  `fiscal_year` INT COMMENT 'Fiscal year in which the invoice was posted. Used for period-based financial reporting and year-end closing processes.',
  `gross_invoice_amount` DECIMAL(18,2) COMMENT 'Total invoice amount including all taxes, fees, and charges before any deductions. Represents the full vendor claim.',
  `invoice_date` DATE COMMENT 'Date the vendor issued the invoice. Used to calculate payment due dates and aging analysis for accounts payable.',
  `invoice_document_number` STRING COMMENT 'Internal system-generated document number uniquely identifying this invoice verification transaction within the ERP system.',
  `invoice_receipt_date` DATE COMMENT 'Date when the vendor invoice was physically or electronically received by the utility. Used for processing time metrics and aging analysis.',
  `invoice_type` STRING COMMENT 'Classification of the invoice document type indicating whether it is a standard invoice, credit memo, debit memo, or other special invoice form. Valid values: standard|credit_memo|debit_memo|prepayment|down_payment|final_invoice.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp recording the most recent update to the invoice verification record. Tracks changes for audit and compliance purposes.',
  `match_result` STRING COMMENT 'Outcome of the three-way matching process comparing invoice, purchase order, and goods receipt. Indicates type of discrepancy if any. Valid values: full_match|price_variance|quantity_variance|three_way_mismatch|two_way_match|no_match.',
  `material_document_number` STRING COMMENT 'Reference to the material document recording the physical goods movement. Links invoice to inventory transactions for reconciliation.',
  `net_invoice_amount` DECIMAL(18,2) COMMENT 'Invoice amount excluding taxes. Base amount used for payment calculation and variance analysis against purchase order.',
  `payment_block_indicator` BOOLEAN COMMENT 'Flag indicating whether the invoice is currently blocked from payment processing. True when variances exceed tolerance or manual holds are applied.',
  `payment_due_date` DATE COMMENT 'Calculated date by which payment must be made to the vendor to comply with payment terms and avoid late payment penalties.',
  `payment_method_code` STRING COMMENT 'Code indicating the method by which payment will be made to the vendor. Determines payment processing workflow and bank account selection. Valid values: check|ach|wire_transfer|eft|credit_card|procurement_card.',
  `payment_terms_code` STRING COMMENT 'Code representing the agreed payment terms with the vendor (e.g., Net 30, Net 60, 2/10 Net 30). Determines payment due date calculation.',
  `plant_code` STRING COMMENT 'Code identifying the utility plant, generation facility, or warehouse location where the materials or services were received.',
  `posting_date` DATE COMMENT 'Date the invoice verification document was posted to the financial ledger. Determines the accounting period for financial reporting.',
  `price_variance_amount` DECIMAL(18,2) COMMENT 'Calculated difference between the invoiced unit price and the purchase order unit price. Positive values indicate overcharges.',
  `purchasing_group` STRING COMMENT 'Team or individual buyer responsible for managing the vendor relationship and purchase order. Used for workload distribution and performance tracking.',
  `purchasing_organization` STRING COMMENT 'Organizational unit responsible for procurement activities related to this invoice. Supports decentralized procurement structures.',
  `quantity_variance` DECIMAL(15,3) COMMENT 'Difference between the invoiced quantity and the goods receipt quantity. Used to detect overbilling or short deliveries.',
  `reference_document_number` STRING COMMENT 'Additional reference number for cross-referencing related documents such as contracts, delivery notes, or service entry sheets.',
  `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount included in the invoice covering sales tax, VAT, GST, or other applicable taxes based on jurisdiction.',
  `tax_code` STRING COMMENT 'Code representing the tax jurisdiction and rate applied to this invoice. Determines tax calculation and reporting requirements.',
  `tax_jurisdiction_code` STRING COMMENT 'Code identifying the geographic tax authority with jurisdiction over this transaction. Required for multi-state utility operations and tax compliance.',
  `tolerance_check_result` STRING COMMENT 'Result of tolerance limit validation comparing invoice variances against configured acceptable thresholds for price and quantity differences. Valid values: within_tolerance|exceeds_tolerance|manual_review_required.',
  `vendor_invoice_number` STRING COMMENT 'External invoice number assigned by the vendor. Used for reconciliation and vendor communication regarding payment disputes.',
  `verification_status` STRING COMMENT 'Current status of the invoice verification process indicating whether the invoice has passed three-way matching and is ready for payment. Reference-value candidates: pending|matched|variance_detected|blocked|approved|rejected|posted.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_invoice_verification` PRIMARY KEY (`invoice_verification_id`)
)
USING DELTA
COMMENT 'Logistics invoice verification record supporting three-way matching of vendor invoices against purchase orders and goods receipts. Captures invoice identification (document number, vendor invoice number), parties (vendor), dates (invoice date, posting date), financial details (gross amount, tax amount, currency), payment terms (payment terms, due date), match results (tolerance check result, blocking reason: price variance, quantity variance, quality hold), and clearing status. Core accounts payable control for utility material and fuel procurement ensuring payment accuracy and preventing overpayment. | CMM: CIM ErpPayable (broad), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'InvoiceVerification',
  'cmm.cim.class' = 'ErpPayable',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.invoice_verification'
);

-- SparePartsCatalog  <<CIM ErpItemMaster : broad>>
CREATE TABLE IF NOT EXISTS `supply`.`spare_parts_catalog` (
  `spare_parts_catalog_id` BIGINT NOT NULL COMMENT 'Unique identifier for the spare parts catalog entry. Primary key for the catalog record.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Spare parts inventory assigned to owning cost centers for inventory carrying cost allocation. Enables cost center-level inventory valuation and obsolescence expense tracking.',
  `nerc_cip_asset_id` BIGINT COMMENT 'Foreign key linking to compliance.nerc_cip_asset. Business justification: Critical spare parts for CIP assets must be inventoried and secured per CIP-010 configuration management. Real business process: CIP asset management, supply chain security, and cyber asset inventory',
  `preferred_vendor_id` BIGINT COMMENT 'Foreign key linking to supply.vendor. Business justification: Spare parts have preferred suppliers for procurement. N:1 relationship - each spare part has one preferred vendor (though multiple vendors may be capable of supplying it). Adding preferred_vendor_id F',
  `primary_material_master_id` BIGINT COMMENT 'FK to supply.material_master.material_master_id — Spare parts catalog entries reference material master records. Required for maintenance-driven procurement integration.',
  `spare_material_master_id` BIGINT COMMENT 'Foreign key linking to supply.material_master. Business justification: Spare parts catalog is a specialized classification/view of materials in material_master. N:1 relationship - each spare parts catalog entry references one material. Adding material_master_id FK links',
  `tertiary_material_master_id` BIGINT COMMENT 'FK to supply.material_master.material_master_id — Spare parts catalog entries reference material master records. Required for maintenance-driven procurement and criticality-based stocking decisions.',
  `warehouse_id` BIGINT COMMENT 'Foreign key linking to supply.warehouse. Business justification: Spare parts are stocked at specific warehouses. N:1 relationship - spare parts catalog entry references preferred storage location. Adding warehouse_id FK enables JOIN to retrieve warehouse details. N',
  `abc_indicator` STRING COMMENT 'ABC analysis classification based on annual consumption value. A=high value items (tight control), B=moderate value, C=low value (simple control). Drives inventory management rigor. Valid values: A|B|C.',
  `annual_usage_quantity` INT COMMENT 'Total quantity consumed in the previous 12 months. Key input for inventory optimization, ABC analysis, and demand forecasting.',
  `batch_managed` BOOLEAN COMMENT 'Flag indicating whether the spare part requires batch/lot number tracking for quality control and traceability. Common for time-sensitive or quality-critical components.',
  `created_date` DATE COMMENT 'Date when this spare parts catalog record was first created in the system. Part of audit trail for master data governance.',
  `criticality_code` STRING COMMENT 'ABC criticality classification indicating business impact of part unavailability. A=Critical (high consequence of failure, long lead time), B=Important (moderate impact), C=Standard (low impact, readily available). Drives stocking strategy and inventory investment. Valid values: A|B|C.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for unit cost (e.g., USD, EUR, GBP). Pattern: ^[A-Z]{3}$.',
  `equipment_class` STRING COMMENT 'High-level classification of the equipment type this spare part supports. Aligns with utility asset hierarchy and maintenance planning structure. Valid values: generation|transmission|distribution|ami|substation|protection.',
  `equipment_subclass` STRING COMMENT 'Detailed equipment subclass providing granular categorization within the equipment class (e.g., turbine, transformer, circuit breaker, relay, meter).',
  `hazmat_class` STRING COMMENT 'DOT hazardous material classification code if applicable (e.g., Class 3 Flammable Liquids, Class 8 Corrosives). Required for transportation and storage compliance.',
  `hazmat_indicator` BOOLEAN COMMENT 'Flag indicating whether the spare part is classified as hazardous material requiring special handling, storage, and transportation per EPA and OSHA regulations.',
  `inspection_required` BOOLEAN COMMENT 'Flag indicating whether incoming goods inspection is mandatory upon receipt. Ensures quality compliance for critical spare parts.',
  `interchangeability_group` STRING COMMENT 'Code identifying parts that are functionally interchangeable or can substitute for each other. Enables inventory optimization and emergency sourcing flexibility.',
  `last_issue_date` DATE COMMENT 'Date when this spare part was last issued from inventory for maintenance or construction work. Indicates usage frequency and demand patterns.',
  `last_purchase_date` DATE COMMENT 'Date of the most recent purchase order for this spare part. Used to identify slow-moving or obsolete inventory.',
  `last_updated_date` DATE COMMENT 'Date when this catalog record was last modified. Supports change tracking and master data quality monitoring.',
  `lead_time_weeks` INT COMMENT 'Standard procurement lead time in weeks from purchase order placement to delivery. Critical input for minimum stock level calculations and emergency procurement planning.',
  `lifecycle_status` STRING COMMENT 'Current lifecycle status of the spare part. Active=currently supported, Obsolete=no longer manufactured, Phase-out=end-of-life announced, Discontinued=no longer available, Superseded=replaced by newer part number. Valid values: active|obsolete|phase_out|discontinued|superseded.',
  `manufacturer_name` STRING COMMENT 'Name of the original equipment manufacturer (OEM) who produces this spare part. Critical for warranty claims and technical support.',
  `material_group` STRING COMMENT 'SAP material group code for procurement and reporting categorization (e.g., electrical equipment, mechanical components, instrumentation).',
  `material_number` STRING COMMENT 'SAP material master number serving as the primary business identifier for the spare part in the ERP system. Links to SAP MM module material master record. Pattern: ^[A-Z0-9]{8,18}$.',
  `material_type` STRING COMMENT 'SAP material type classification (e.g., ERSA for spare parts, HAWA for trading goods). Controls procurement and inventory management processes in SAP MM.',
  `maximum_stock_level` INT COMMENT 'Maximum inventory quantity ceiling to prevent overstock and excessive capital tie-up. Used in SAP MM reorder quantity calculations.',
  `minimum_stock_level` INT COMMENT 'Minimum inventory quantity that must be maintained to avoid stockouts. Triggers automatic reorder point in SAP MM when stock falls below this threshold.',
  `nerc_cip_critical` BOOLEAN COMMENT 'Flag indicating whether this spare part supports NERC CIP-designated critical cyber assets or bulk electric system (BES) cyber systems. Drives supply chain security and procurement compliance requirements.',
  `notes` STRING COMMENT 'Free-text field for additional information, special handling instructions, cross-reference notes, or procurement guidance not captured in structured fields.',
  `obsolescence_date` DATE COMMENT 'Date when the part was declared obsolete or discontinued by the manufacturer. Triggers last-time-buy analysis and asset replacement planning.',
  `oem_part_number` STRING COMMENT 'Manufacturer\'s original part number as specified by the OEM. Critical for procurement and warranty claims. May differ from utility\'s internal material number.',
  `part_description` STRING COMMENT 'Detailed technical description of the spare part including specifications, dimensions, and functional characteristics. Used for identification and procurement.',
  `plant_code` STRING COMMENT 'SAP plant code representing the generation station, service center, or operational facility associated with this spare part inventory.',
  `purchasing_group` STRING COMMENT 'SAP purchasing group responsible for procurement of this material. Identifies the buyer or procurement team assigned to this commodity.',
  `recommended_stock_level` INT COMMENT 'Optimal inventory quantity balancing availability risk against carrying cost. Based on failure rates, lead time, and criticality analysis.',
  `reorder_point` INT COMMENT 'Inventory level that triggers automatic purchase requisition in SAP MM. Calculated based on lead time demand and safety stock requirements.',
  `serial_number_profile` STRING COMMENT 'Indicates whether serial number tracking is required for this spare part. Mandatory=each unit must have unique serial number, Optional=serial tracking available but not required, None=no serial tracking. Valid values: none|optional|mandatory.',
  `shelf_life_months` INT COMMENT 'Maximum storage duration in months before the part degrades or expires. Critical for inventory rotation and obsolescence management of time-sensitive components (e.g., lubricants, seals, batteries).',
  `stocking_strategy` STRING COMMENT 'Inventory management strategy for this part. Stocked=maintained in utility warehouse, Non-stocked=procured on demand, Consignment=supplier-owned inventory on-site, Vendor-managed=supplier manages replenishment, Insurance-spare=critical long-lead item held for catastrophic failure. Valid values: stocked|non_stocked|consignment|vendor_managed|insurance_spare.',
  `storage_location_code` STRING COMMENT 'SAP storage location code identifying the warehouse or storeroom where the part is stocked. Links to SAP MM plant and storage location master data.',
  `superseding_part_number` STRING COMMENT 'Material number or OEM part number of the replacement part that supersedes this obsolete part. Enables inventory transition planning.',
  `technical_specification_reference` STRING COMMENT 'Reference to detailed technical specification document, drawing number, or engineering standard governing this spare part (e.g., IEEE standard, manufacturer spec sheet).',
  `unit_cost` DECIMAL(18,2) COMMENT 'Standard unit cost of the spare part in base currency. Used for inventory valuation, budgeting, and Capital Expenditure (CAPEX) / Operational Expenditure (OPEX) planning. Confidential business data.',
  `unit_of_measure` STRING COMMENT 'Base unit of measure for inventory tracking and procurement (EA=Each, PC=Piece, SET=Set, KG=Kilogram, M=Meter, L=Liter, FT=Foot). Reference-value candidates: EA|PC|SET|KG|M|L|FT.',
  `warranty_months` INT COMMENT 'Standard manufacturer warranty period in months from date of purchase. Used for warranty claim tracking and supplier performance evaluation.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_spare_parts_catalog` PRIMARY KEY (`spare_parts_catalog_id`)
)
USING DELTA
COMMENT 'Utility spare parts catalog defining critical and insurance spare parts for generation units (turbines, boilers, generators), T&D equipment (transformers, circuit breakers, protection relays), and AMI infrastructure. Captures catalog identification (item number, material master reference, OEM part number), classification (equipment class, criticality A/B/C, interchangeability group), stocking parameters (lead time weeks, minimum and recommended stock levels), lifecycle status (obsolescence status), and sourcing strategy (stocked, non-stocked, consignment, vendor-managed). Supports maintenance-driven procurement and critical spare availability for regulatory compliance. | CMM: CIM ErpItemMaster (broad), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SparePartsCatalog',
  'cmm.cim.class' = 'ErpItemMaster',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.spare_parts_catalog'
);

-- VendorEvaluation  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `supply`.`vendor_evaluation` (
  `vendor_evaluation_id` BIGINT NOT NULL COMMENT 'Unique identifier for the vendor evaluation record. Primary key.',
  `compliance_sox_control_id` BIGINT COMMENT 'Foreign key linking to compliance.sox_control. Business justification: Vendor payment processes are SOX-relevant; vendor evaluation is a key control for procurement integrity. Real business process: SOX 404 control testing, vendor management controls, and financial state',
  `primary_vendor_employee_id` BIGINT COMMENT 'Identifier of the employee or procurement specialist who conducted the vendor evaluation.',
  `vendor_id` BIGINT COMMENT 'Identifier of the vendor being evaluated. Links to the vendor master data in SAP S/4HANA MM.',
  `approval_date` DATE COMMENT 'Date when the vendor evaluation was formally approved by management.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the vendor evaluation record was first created in SAP S/4HANA MM.',
  `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the total purchase value (e.g., USD, CAD, EUR). Pattern: ^[A-Z]{3}$.',
  `defect_rate_pct` DECIMAL(5,2) COMMENT 'Percentage of delivered materials that were found to be defective during the evaluation period.',
  `delivery_score` DECIMAL(5,2) COMMENT 'Vendor performance score for delivery dimension, assessing on-time delivery percentage and lead time adherence. Scale 0-100.',
  `emergency_support_score` DECIMAL(5,2) COMMENT 'Sub-score assessing the vendor\'s capability to provide emergency materials and support for outage restoration and critical supply needs. Scale 0-100.',
  `environmental_compliance_score` DECIMAL(5,2) COMMENT 'Score assessing the vendor\'s compliance with EPA environmental standards and utility sustainability requirements. Scale 0-100.',
  `evaluation_comments` STRING COMMENT 'Free-text comments and observations from the evaluator regarding vendor performance, strengths, weaknesses, and improvement recommendations.',
  `evaluation_date` DATE COMMENT 'Date when the vendor evaluation was completed and recorded in the system.',
  `evaluation_number` STRING COMMENT 'Business identifier for the vendor evaluation record, typically generated by SAP transaction ME61.',
  `evaluation_period_end_date` DATE COMMENT 'End date of the evaluation period during which vendor performance was assessed.',
  `evaluation_period_start_date` DATE COMMENT 'Start date of the evaluation period during which vendor performance was assessed.',
  `evaluation_status` STRING COMMENT 'Current lifecycle status of the vendor evaluation record indicating workflow state. Valid values: draft|submitted|approved|rejected|archived.',
  `evaluator_name` STRING COMMENT 'Full name of the employee or procurement specialist who conducted the vendor evaluation.',
  `invoice_accuracy_pct` DECIMAL(5,2) COMMENT 'Percentage of vendor invoices that matched purchase orders and goods receipts without discrepancies during the evaluation period.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the vendor evaluation record was last updated in SAP S/4HANA MM.',
  `lead_time_adherence_pct` DECIMAL(5,2) COMMENT 'Percentage of purchase orders where the vendor met the agreed lead time commitments during the evaluation period.',
  `material_category` STRING COMMENT 'Primary material or service category for which the vendor was evaluated (e.g., transformers, conductors, meters, poles, generation spare parts, fuel supply).',
  `nerc_cip_compliance_score` DECIMAL(5,2) COMMENT 'Score assessing the vendor\'s compliance with NERC CIP standards for supply chain security and cyber security requirements applicable to utility critical infrastructure. Scale 0-100.',
  `next_evaluation_due_date` DATE COMMENT 'Scheduled date for the next periodic vendor evaluation based on the utility\'s vendor management policy.',
  `on_time_delivery_pct` DECIMAL(5,2) COMMENT 'Percentage of purchase orders delivered on or before the requested delivery date during the evaluation period.',
  `overall_score` DECIMAL(5,2) COMMENT 'Composite overall performance score for the vendor, typically calculated as a weighted average of quality, delivery, price, and service scores. Scale 0-100.',
  `preferred_vendor_flag` BOOLEAN COMMENT 'Indicates whether the vendor has been designated as a preferred supplier based on evaluation results and strategic sourcing decisions.',
  `price_competitiveness_score` DECIMAL(5,2) COMMENT 'Sub-score assessing how competitive the vendor\'s pricing is compared to market benchmarks and other suppliers. Scale 0-100.',
  `price_score` DECIMAL(5,2) COMMENT 'Vendor performance score for price dimension, assessing price competitiveness and invoice accuracy. Scale 0-100.',
  `purchasing_group` STRING COMMENT 'SAP purchasing group code responsible for managing the vendor and conducting the evaluation.',
  `purchasing_organization` STRING COMMENT 'SAP purchasing organization code responsible for the vendor relationship and evaluation process.',
  `quality_score` DECIMAL(5,2) COMMENT 'Vendor performance score for quality dimension, assessing defect rate, rejection rate, and material quality compliance. Scale 0-100.',
  `rejection_rate_pct` DECIMAL(5,2) COMMENT 'Percentage of delivered materials that were rejected and returned to the vendor during the evaluation period.',
  `responsiveness_score` DECIMAL(5,2) COMMENT 'Sub-score assessing the vendor\'s responsiveness to inquiries, change requests, and issue resolution. Scale 0-100.',
  `safety_compliance_score` DECIMAL(5,2) COMMENT 'Score assessing the vendor\'s adherence to OSHA and utility-specific safety standards for materials and services provided. Scale 0-100.',
  `service_score` DECIMAL(5,2) COMMENT 'Vendor performance score for service dimension, assessing responsiveness, communication, and emergency support capability. Scale 0-100.',
  `total_purchase_orders_evaluated` INT COMMENT 'Total number of purchase orders from the vendor that were included in the evaluation period analysis.',
  `total_purchase_value` DECIMAL(18,2) COMMENT 'Total monetary value of purchases from the vendor during the evaluation period, in the utility\'s reporting currency.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_vendor_evaluation` PRIMARY KEY (`vendor_evaluation_id`)
)
USING DELTA
COMMENT 'Periodic vendor performance evaluation records for utility suppliers assessed across quality, delivery, price, and service dimensions. Captures evaluation period, vendor, overall score, quality score (defect rate, rejection rate), delivery score (on-time delivery %, lead time adherence), price score (price competitiveness, invoice accuracy), service score (responsiveness, emergency support capability), NERC CIP compliance score, and evaluator. Sourced from SAP S/4HANA MM vendor evaluation (ME61). Supports strategic sourcing decisions and preferred vendor designation. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'VendorEvaluation',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.vendor_evaluation'
);

-- RequestForQuotation  <<CIM ErpQuote : close>>
CREATE TABLE IF NOT EXISTS `supply`.`request_for_quotation` (
  `request_for_quotation_id` BIGINT NOT NULL COMMENT 'Primary key for request_for_quotation',
  `buyer_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: RFQ process requires tracking the purchasing employee responsible for vendor solicitation, evaluation, and award decisions. Buyer_name is denormalized text; FK enables workload balancing, procurement',
  `purchase_requisition_id` BIGINT COMMENT 'Foreign key linking to supply.purchase_requisition. Business justification: RFQs are often generated from purchase requisitions to obtain competitive quotes. N:1 relationship - one RFQ typically originates from one requisition (though multiple RFQs could be issued for complex',
  `request_awarded_vendor_id` BIGINT COMMENT 'Identifier of the vendor selected to receive the purchase order based on quotation evaluation.',
  `request_vendor_id` BIGINT COMMENT 'FK to supply.vendor.vendor_id — RFQs are issued to specific vendors for competitive bidding. Required for sourcing event tracking.',
  `vendor_id` BIGINT COMMENT 'FK to supply.vendor.vendor_id — RFQs are sent to vendors and quotation responses come from vendors. Required for competitive bidding tracking and award decisions.',
  `asset_number` STRING COMMENT 'Fixed asset number if the procurement is for asset acquisition or major equipment that will be capitalized.',
  `award_decision_date` DATE COMMENT 'Date when the vendor selection decision was made and the RFQ was awarded to the winning vendor(s).',
  `awarded_quotation_amount` DECIMAL(18,2) COMMENT 'Total value of the winning quotation that was accepted and will be converted to a purchase order.',
  `budget_estimate` DECIMAL(18,2) COMMENT 'Internal budget estimate or target price for the procurement. Confidential and not shared with vendors.',
  `collective_number` STRING COMMENT 'Reference number linking multiple related RFQs together for consolidated procurement or framework agreement establishment.',
  `compliance_requirement_flag` BOOLEAN COMMENT 'Indicates whether this RFQ is subject to special regulatory compliance requirements (e.g., NERC CIP for critical cyber assets, FERC procurement rules, state PUC competitive bidding mandates).',
  `cost_center` STRING COMMENT 'Cost center to which the procurement expense will be charged upon purchase order creation.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the RFQ record was first created in the system.',
  `currency_code` STRING COMMENT 'Three-letter ISO currency code for pricing (e.g., USD, EUR, CAD). Vendors must quote in this currency unless otherwise specified.',
  `emergency_procurement_flag` BOOLEAN COMMENT 'Indicates whether this is an emergency RFQ for storm restoration, outage response, or critical equipment failure requiring expedited procurement processes.',
  `gl_account` STRING COMMENT 'General ledger account code for financial posting of the procurement expense.',
  `incoterms` STRING COMMENT 'International commercial terms defining the responsibilities of buyers and sellers for delivery, insurance, and risk transfer (e.g., FOB, CIF, DDP).',
  `incoterms_location` STRING COMMENT 'Specific location or point referenced in the Incoterms (e.g., port, plant, warehouse address).',
  `last_modified_by` STRING COMMENT 'User ID or name of the person who last modified the RFQ record.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the RFQ record was last updated or modified.',
  `material_description` STRING COMMENT 'Detailed description of the materials, equipment, or services being requested. May include technical specifications for transformers, conductors, meters, poles, generation spare parts, or fuel supply requirements.',
  `material_group` STRING COMMENT 'Classification code grouping similar materials or services (e.g., transformers, conductors, meters, poles, generation spare parts, fuel, professional services).',
  `payment_terms` STRING COMMENT 'Standard payment terms requested in the RFQ (e.g., Net 30, Net 60, 2/10 Net 30). Vendors may propose alternative terms in their quotations.',
  `plant_code` STRING COMMENT 'Code identifying the generation plant, substation, service center, or warehouse location where the materials or services will be delivered or utilized.',
  `purchasing_group` STRING COMMENT 'Buyer or procurement team responsible for managing this RFQ and vendor selection process.',
  `purchasing_organization` STRING COMMENT 'Organizational unit responsible for procurement activities. Represents the utility division or business unit issuing the RFQ.',
  `quantity_requested` DECIMAL(18,3) COMMENT 'Quantity of materials or units of service requested in the RFQ. For fuel supply, may represent volume in tons, cubic meters, or other units.',
  `quotation_deadline_extension_count` INT COMMENT 'Number of times the submission deadline has been extended to accommodate vendor requests or procurement process delays.',
  `rejection_reason` STRING COMMENT 'Explanation for why the RFQ was cancelled or closed without awarding to any vendor.',
  `required_delivery_date` DATE COMMENT 'Target date by which the utility requires delivery of the materials, equipment, or completion of services specified in the RFQ.',
  `requisitioner_name` STRING COMMENT 'Name of the employee or department that originated the procurement request and will be the end user of the materials or services.',
  `rfq_date` DATE COMMENT 'Date when the RFQ was officially issued to vendors for competitive bidding.',
  `rfq_number` STRING COMMENT 'Business document number assigned to the RFQ for external reference and tracking in procurement processes.',
  `rfq_status` STRING COMMENT 'Current lifecycle status of the RFQ: draft (being prepared), issued (sent to vendors), open (accepting quotations), closed (submission deadline passed), awarded (vendor selected), or cancelled. Valid values: draft|issued|open|closed|awarded|cancelled.',
  `rfq_type` STRING COMMENT 'Classification of the RFQ based on procurement category: standard materials, framework agreements, emergency restoration supplies, capital project equipment, fuel supply contracts, or professional services. Valid values: standard|framework|emergency|capital_project|fuel_supply|services.',
  `storage_location` STRING COMMENT 'Specific warehouse or storage location within the plant where materials will be received and stored.',
  `submission_deadline` TIMESTAMP COMMENT 'Date and time by which vendors must submit their quotations. No late submissions are accepted after this timestamp.',
  `tax_code` STRING COMMENT 'Tax code indicating applicable sales tax, VAT, or other tax treatment for the procurement.',
  `technical_specification_document` STRING COMMENT 'Reference to attached technical specifications, drawings, or engineering requirements documents that vendors must comply with.',
  `unit_of_measure` STRING COMMENT 'Unit of measure for the requested quantity (e.g., EA for each, MT for metric tons, M for meters, KG for kilograms, MWh for megawatt-hours).',
  `valuation_type` STRING COMMENT 'Method used to evaluate and compare vendor quotations: lowest price, best value (price and quality), technical compliance, or weighted scoring model. Valid values: lowest_price|best_value|technical_compliance|weighted_score.',
  `vendor_count_invited` INT COMMENT 'Total number of vendors invited to submit quotations for this RFQ.',
  `vendor_count_responded` INT COMMENT 'Number of vendors who submitted quotations by the deadline.',
  `wbs_element` STRING COMMENT 'Project WBS element for capital projects or major construction initiatives. Used for project-based procurement tracking.',
  `created_by` STRING COMMENT 'User ID or name of the person who created the RFQ record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_request_for_quotation` PRIMARY KEY (`request_for_quotation_id`)
)
USING DELTA
COMMENT 'Request for quotation and vendor response records for competitive bidding on utility materials, equipment, and services. Captures RFQ header: RFQ number, date, submission deadline, material or service description, quantity, required delivery date, and status. Captures vendor quotation responses: vendor, quoted price, price unit, currency, delivery lead time, validity period, payment terms, incoterms, technical compliance notes, and quotation ranking. Supports strategic sourcing for high-value utility equipment (power transformers, circuit breakers, generation spare parts) and fuel supply tenders. Enables price comparison, award decisions, and competitive procurement documentation across the utility portfolio. | CMM: CIM ErpQuote (close), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'RequestForQuotation',
  'cmm.cim.class' = 'ErpQuote',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.request_for_quotation'
);

-- VendorQuotation  <<CIM ErpQuoteLineItem : close>>
CREATE TABLE IF NOT EXISTS `supply`.`vendor_quotation` (
  `vendor_quotation_id` BIGINT NOT NULL COMMENT 'Unique identifier for the vendor quotation record. Primary key.',
  `primary_vendor_material_master_id` BIGINT COMMENT 'Reference to the material or service being quoted. Links quotation to the utility material master for transformers, conductors, meters, poles, or generation spare parts.',
  `rate_case_id` BIGINT COMMENT 'Foreign key linking to compliance.rate_case. Business justification: Vendor quotes for capital projects feed rate case filings (cost justification for rate increases). Real business process: rate case preparation, cost substantiation, and regulatory filing support for',
  `request_for_quotation_id` BIGINT COMMENT 'Reference to the utility RFQ that this quotation responds to. Links quotation to the originating procurement request.',
  `vendor_id` BIGINT COMMENT 'Reference to the vendor submitting this quotation. Identifies the supplier providing pricing and delivery terms.',
  `vendor_material_master_id` BIGINT COMMENT 'FK to supply.material_master',
  `award_recommendation_indicator` BOOLEAN COMMENT 'Flag indicating whether this quotation is recommended for purchase order award. True if recommended, False otherwise. Drives procurement decision workflow.',
  `created_by_user` STRING COMMENT 'User ID of the person who created the quotation record in the system. Used for audit trail and accountability.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the quotation record was first created in the utility procurement system. Audit trail for record lifecycle.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the quoted price (e.g., USD, EUR, CAD). Required for multi-currency procurement and financial reporting. Pattern: ^[A-Z]{3}$.',
  `delivery_lead_time_days` INT COMMENT 'Number of days from purchase order placement to delivery at utility site. Critical factor for emergency restoration supply chain and project planning.',
  `evaluation_completed_timestamp` TIMESTAMP COMMENT 'Date and time when the quotation evaluation was completed and final ranking assigned. Marks completion of the review process.',
  `evaluation_score` DECIMAL(5,2) COMMENT 'Composite score assigned during quotation evaluation based on price, delivery, quality, and other weighted criteria. Used for objective vendor selection.',
  `incoterms` STRING COMMENT 'International Commercial Terms defining the division of costs and risks between buyer and seller (e.g., FOB, CIF, DDP). Critical for logistics cost allocation and risk management. Reference-value candidates: EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF.',
  `incoterms_location` STRING COMMENT 'Named place or port specified in the Incoterms (e.g., Houston Port, Vendor Warehouse). Defines the geographic point where risk and cost transfer occurs.',
  `last_modified_by_user` STRING COMMENT 'User ID of the person who last modified the quotation record. Used for audit trail and change tracking.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the quotation record was last modified. Tracks most recent update for audit and version control.',
  `notes` STRING COMMENT 'Free-form notes and comments related to the quotation including special conditions, clarifications, or internal evaluation remarks. Supports decision documentation.',
  `payment_terms_code` STRING COMMENT 'Code representing the payment terms offered by the vendor (e.g., Net 30, Net 60, 2/10 Net 30). Impacts cash flow and total cost of ownership.',
  `payment_terms_description` STRING COMMENT 'Detailed description of payment terms including discount conditions, due dates, and special arrangements. Provides clarity for financial evaluation.',
  `plant_code` STRING COMMENT 'Code of the utility plant or facility where the material will be delivered or service performed. Used for logistics planning and inventory allocation.',
  `price_unit` INT COMMENT 'Quantity denominator for the unit price (e.g., price per 1, per 10, per 100 units). Used to normalize pricing for comparison.',
  `promised_delivery_date` DATE COMMENT 'Specific date by which the vendor commits to deliver the material or complete the service. Used for schedule alignment and vendor performance tracking.',
  `purchasing_group` STRING COMMENT 'Code of the purchasing group (buyer team) responsible for this quotation. Used for workload distribution and buyer performance tracking.',
  `purchasing_organization` STRING COMMENT 'Code of the utility purchasing organization responsible for this quotation evaluation and award decision. Used for organizational reporting and authorization.',
  `quotation_number` STRING COMMENT 'Business identifier for the vendor quotation assigned by the vendor or utility procurement system. Externally-known unique reference for this quotation response.',
  `quotation_ranking` INT COMMENT 'Numerical rank assigned to this quotation relative to other vendor responses for the same RFQ line. Lower number indicates better ranking. Used for award decision support.',
  `quotation_received_timestamp` TIMESTAMP COMMENT 'Date and time when the utility procurement system received and registered the quotation. May differ from submission timestamp due to processing delays.',
  `quotation_status` STRING COMMENT 'Current lifecycle status of the vendor quotation. Tracks progression from submission through evaluation to final disposition. Reference-value candidates: draft|submitted|under_review|accepted|rejected|withdrawn|expired.',
  `quotation_submission_timestamp` TIMESTAMP COMMENT 'Date and time when the vendor submitted the quotation to the utility. Used to verify timely submission against RFQ deadline and for audit trail.',
  `quotation_valid_from_date` DATE COMMENT 'Start date of the quotation validity period. Defines when the quoted price and terms become effective.',
  `quotation_valid_to_date` DATE COMMENT 'End date of the quotation validity period. After this date, vendor is not bound by quoted price and terms. Critical for timely procurement decisions.',
  `quoted_quantity` DECIMAL(18,3) COMMENT 'Quantity of material or service that the vendor is quoting. Must align with RFQ requested quantity or specify alternate quantity.',
  `quoted_unit_price` DECIMAL(18,4) COMMENT 'Price per unit quoted by the vendor. Core pricing element used for cost comparison and award decision.',
  `rejection_reason_code` STRING COMMENT 'Code indicating the reason for quotation rejection if status is rejected (e.g., price too high, non-compliant, late submission). Used for vendor feedback and analytics.',
  `rejection_reason_text` STRING COMMENT 'Detailed explanation of why the quotation was rejected. Provides transparency to vendor and supports continuous improvement.',
  `storage_location` STRING COMMENT 'Code of the warehouse or storage location within the plant where material will be received. Used for inventory management and receiving logistics.',
  `technical_compliance_indicator` BOOLEAN COMMENT 'Flag indicating whether the quoted material or service meets all technical specifications and standards defined in the RFQ. True if compliant, False if deviations exist.',
  `technical_compliance_notes` STRING COMMENT 'Detailed notes on technical compliance status including any deviations from RFQ specifications, alternate proposals, or special conditions. Used for engineering review and approval.',
  `total_quoted_value` DECIMAL(18,2) COMMENT 'Total value of the quotation line calculated as quoted quantity multiplied by unit price. Used for total cost comparison across vendors.',
  `unit_of_measure` STRING COMMENT 'Unit of measure for the quoted quantity (e.g., EA for each, KG for kilogram, M for meter, KWH for kilowatt-hour). Must match material master UOM or specify conversion.',
  `vendor_contact_email` STRING COMMENT 'Email address of the vendor contact for this quotation. Primary channel for quotation-related communication. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `vendor_contact_name` STRING COMMENT 'Name of the vendor representative who submitted or is responsible for this quotation. Used for communication and clarification.',
  `vendor_contact_phone` STRING COMMENT 'Phone number of the vendor contact for this quotation. Used for urgent clarifications and negotiations.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_vendor_quotation` PRIMARY KEY (`vendor_quotation_id`)
)
USING DELTA
COMMENT 'Vendor quotation responses to utility RFQs capturing competitive pricing and delivery terms for materials and services. Captures quotation number, RFQ reference, vendor, material, quoted price, price unit, currency, delivery lead time, validity period, payment terms, incoterms, technical compliance notes, and quotation ranking. Supports price comparison and award decisions for utility procurement of transformers, conductors, meters, poles, and fuel supply contracts. | CMM: CIM ErpQuoteLineItem (close), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'VendorQuotation',
  'cmm.cim.class' = 'ErpQuoteLineItem',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.vendor_quotation'
);

-- EmergencyStockEvent  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `supply`.`emergency_stock_event` (
  `emergency_stock_event_id` BIGINT NOT NULL COMMENT 'Unique identifier for the emergency stock event record. Primary key.',
  `emergency_purchase_order_id` BIGINT COMMENT 'Foreign key linking to supply.purchase_order. Business justification: Emergency stock events trigger emergency purchase orders for rapid material procurement during outages or storms. N:1 relationship - one emergency event may result in one primary PO (though multiple P',
  `material_master_id` BIGINT COMMENT 'FK to supply.material_master.material_master_id — Emergency stock events request specific materials. Required for emergency procurement tracking and post-event analysis.',
  `primary_vendor_id` BIGINT COMMENT 'Identifier of the primary vendor supplying emergency materials if sourced through emergency purchase order or spot buy.',
  `primary_warehouse_id` BIGINT COMMENT 'Identifier of the primary warehouse or storage location from which emergency stock was deployed.',
  `self_report_id` BIGINT COMMENT 'Foreign key linking to compliance.self_report. Business justification: Major outages triggering emergency stock deployment may require self-reporting to NERC/regional entities if standards were violated. Real business process: post-incident regulatory reporting and compl',
  `storm_event_id` BIGINT COMMENT 'Foreign key linking to outage.storm_event. Business justification: Major storms trigger emergency material procurement and mutual aid material transfers. Links emergency supply chain activation to named storm events for cost tracking, mutual aid accounting, regulator',
  `affected_customers_count` INT COMMENT 'Number of customers impacted by the outage or emergency event that triggered stock deployment.',
  `affected_service_territory` STRING COMMENT 'Geographic service territory or region impacted by the emergency event requiring material deployment.',
  `approval_required_flag` BOOLEAN COMMENT 'Indicates whether executive or special approval was required for this emergency procurement due to spend thresholds or policy requirements.',
  `approval_timestamp` TIMESTAMP COMMENT 'Timestamp when the emergency procurement was approved, used for audit trail and compliance documentation.',
  `approved_by` STRING COMMENT 'Name or identifier of the executive or manager who approved the emergency procurement.',
  `cost_center` STRING COMMENT 'Cost center to which emergency procurement costs are charged for financial accounting and reporting.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the emergency stock event record was first created in the system.',
  `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all financial amounts in this emergency stock event. Pattern: ^[A-Z]{3}$.',
  `declared_emergency_date` DATE COMMENT 'Date when the emergency was officially declared and emergency procurement procedures were activated.',
  `declared_emergency_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the emergency was declared, critical for SAIDI/SAIFI restoration performance tracking and regulatory reporting.',
  `deployment_plant_code` STRING COMMENT 'SAP plant code where materials were deployed or received for emergency restoration activities.',
  `emergency_po_number` STRING COMMENT 'Purchase order number created for emergency procurement if sourcing method is emergency PO.',
  `event_number` STRING COMMENT 'Business identifier for the emergency stock event, externally known reference number used in communications and reporting.',
  `event_status` STRING COMMENT 'Current lifecycle status of the emergency stock event from declaration through closure and post-event review. Valid values: declared|active|materials_deployed|restoration_complete|closed|under_review.',
  `event_type` STRING COMMENT 'Classification of the emergency event that triggered material procurement or stock deployment. Valid values: storm_restoration|forced_outage|grid_emergency|mutual_aid|equipment_failure|natural_disaster.',
  `fema_declaration_number` STRING COMMENT 'Federal disaster declaration number if this event qualifies for FEMA reimbursement, used for documentation and claims.',
  `fema_reimbursement_eligible_flag` BOOLEAN COMMENT 'Indicates whether this emergency event and associated costs are eligible for FEMA reimbursement under federal disaster declarations.',
  `gl_account` STRING COMMENT 'General Ledger account code to which emergency procurement costs are posted.',
  `lead_time_achieved_hours` DECIMAL(10,2) COMMENT 'Actual lead time in hours from emergency declaration to material availability on site, critical for supply chain resilience assessment.',
  `lessons_learned_summary` STRING COMMENT 'Summary of key lessons learned from the emergency event and material deployment, used for continuous improvement of supply chain resilience.',
  `materials_requested` STRING COMMENT 'Comma-separated list or structured description of materials requested for emergency deployment, including material numbers and descriptions.',
  `modified_by` STRING COMMENT 'User ID or name of the person who last modified the emergency stock event record.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the emergency stock event record was last modified in the system.',
  `mutual_aid_partner` STRING COMMENT 'Name of the utility or organization providing mutual aid support and materials if sourcing method is mutual aid.',
  `notes` STRING COMMENT 'Free-text notes capturing additional context, special circumstances, or operational details about the emergency stock event.',
  `post_event_review_date` DATE COMMENT 'Date when the post-event review was conducted or completed.',
  `post_event_review_status` STRING COMMENT 'Status of the post-event review process to assess emergency response effectiveness and identify supply chain resilience improvements. Valid values: not_started|in_progress|completed|findings_documented|action_items_assigned.',
  `regulatory_reporting_required_flag` BOOLEAN COMMENT 'Indicates whether this emergency event requires formal reporting to state Public Utility Commission (PUC) or other regulatory bodies.',
  `restoration_completion_date` DATE COMMENT 'Date when restoration activities were completed and normal operations resumed.',
  `restoration_completion_timestamp` TIMESTAMP COMMENT 'Precise timestamp when restoration was completed, used for calculating restoration duration and performance metrics.',
  `saidi_impact_minutes` DECIMAL(12,2) COMMENT 'Total customer-minutes of interruption attributed to this emergency event, used for reliability performance tracking.',
  `saifi_impact_count` DECIMAL(10,4) COMMENT 'Average number of interruptions per customer attributed to this emergency event, used for reliability performance tracking.',
  `sourcing_method` STRING COMMENT 'Method used to source and procure materials for the emergency event, indicating procurement execution strategy. Valid values: emergency_po|mutual_aid|spot_buy|existing_stock|vendor_consignment|expedited_contract.',
  `target_lead_time_hours` DECIMAL(10,2) COMMENT 'Target or planned lead time in hours for emergency material deployment, used for performance comparison.',
  `total_emergency_spend` DECIMAL(18,2) COMMENT 'Total financial expenditure for emergency material procurement and deployment, including all costs associated with this event.',
  `total_quantity_requested` DECIMAL(15,3) COMMENT 'Aggregate quantity of materials requested across all line items for this emergency event.',
  `triggering_incident_reference` STRING COMMENT 'Reference identifier to the originating incident, outage event, or work order that triggered the emergency stock deployment.',
  `wbs_element` STRING COMMENT 'Work Breakdown Structure element for capital project tracking if emergency materials are capitalized.',
  `created_by` STRING COMMENT 'User ID or name of the person who created the emergency stock event record in the system.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_emergency_stock_event` PRIMARY KEY (`emergency_stock_event_id`)
)
USING DELTA
COMMENT 'Records of emergency material procurement and stock deployment events triggered by major outages, storm restoration, mutual aid activations, or unplanned generation equipment failures. Captures event identification (event ID, triggering incident reference), classification (event type: storm restoration, forced outage, grid emergency, mutual aid), timeline (declared emergency date, restoration completion date), material requirements (materials requested with quantities), sourcing execution (sourcing method: emergency PO, mutual aid, spot buy, existing stock deployment), financial summary (total emergency spend, lead time achieved), and post-event review status. Supports SAIDI/SAIFI restoration performance tracking, FEMA reimbursement documentation, and regulatory reporting on emergency supply chain resilience. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'EmergencyStockEvent',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.emergency_stock_event'
);

-- InventoryCount  <<CIM ErpInventoryCount : exact>>
CREATE TABLE IF NOT EXISTS `supply`.`inventory_count` (
  `inventory_count_id` BIGINT NOT NULL COMMENT 'Unique identifier for the physical inventory count record. Primary key for the inventory count entity.',
  `employee_id` BIGINT COMMENT 'The employee ID or user ID of the person who performed the physical count. Used for accountability and audit trail.',
  `inventory_material_master_id` BIGINT COMMENT 'Foreign key reference to the material master record being counted. Links to the material being inventoried.',
  `inventory_warehouse_id` BIGINT COMMENT 'Foreign key linking to supply.warehouse. Business justification: Inventory counts are performed at specific warehouses. N:1 relationship - many counts at one warehouse (periodic counts, cycle counts, spot counts). Adding warehouse_id FK enables JOIN to retrieve war',
  `material_master_id` BIGINT COMMENT 'FK to supply.material_master.material_master_id — Physical inventory counts are performed per material. FK needed for count accuracy reconciliation.',
  `to_material_master_id` BIGINT COMMENT 'FK to supply.material_master.material_master_id — Physical counts are per-material per-location. Required for inventory accuracy reconciliation.',
  `to_warehouse_id` BIGINT COMMENT 'FK to supply.warehouse.warehouse_id — Physical counts occur at specific warehouse/storage locations. Required for count scheduling and reconciliation.',
  `warehouse_id` BIGINT COMMENT 'FK to supply.warehouse.warehouse_id — Counts are performed at specific warehouse locations. Required for location-level inventory accuracy KPIs.',
  `approval_date` DATE COMMENT 'The date on which the count was approved for posting. Null if approval not required or not yet approved.',
  `approval_required_indicator` BOOLEAN COMMENT 'Flag indicating whether supervisor or management approval is required before posting the count differences, typically for high-value variances or regulatory compliance.',
  `approved_by` STRING COMMENT 'The user ID or employee ID of the supervisor or manager who approved the count posting. Null if approval not required or not yet approved.',
  `batch_number` STRING COMMENT 'The batch or lot number for batch-managed materials such as chemicals, fuel additives, or time-sensitive spare parts. Null for non-batch materials.',
  `book_quantity` DECIMAL(15,3) COMMENT 'The system book quantity (expected quantity) in inventory records at the time of count. Used to calculate variance.',
  `cost_center` STRING COMMENT 'The cost center responsible for the inventory location or the cost center to which inventory variances will be posted. Used for financial accountability. Pattern: ^[A-Z0-9]{10}$.',
  `count_date` DATE COMMENT 'The date on which the physical inventory count was performed. Critical for regulatory compliance and inventory accuracy tracking.',
  `count_notes` STRING COMMENT 'Free-text notes or comments entered by the counter regarding count conditions, issues encountered, or explanations for variances.',
  `count_status` STRING COMMENT 'Current workflow status of the inventory count: not_yet_counted (document created but count pending), counted (initial count completed), recounted (variance recount performed), posted (differences posted to inventory), cancelled (count voided). Valid values: not_yet_counted|counted|recounted|posted|cancelled.',
  `count_type` STRING COMMENT 'The type of inventory count performed: periodic (scheduled full count), cycle (rotating partial count), spot (ad-hoc verification), annual (year-end regulatory count), or emergency (post-storm restoration verification). Valid values: periodic|cycle|spot|annual|emergency.',
  `counted_quantity` DECIMAL(15,3) COMMENT 'The actual physical quantity counted during the inventory count. Compared against book quantity to identify discrepancies.',
  `counter_name` STRING COMMENT 'The name of the employee who performed the physical count. Denormalized for reporting convenience.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when the inventory count document was created in the system. Critical for audit trail and regulatory compliance.',
  `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code for valuation amounts (e.g., USD, EUR, CAD). Pattern: ^[A-Z]{3}$.',
  `deletion_indicator` BOOLEAN COMMENT 'Flag indicating whether this inventory count record has been marked for deletion or cancellation. Soft delete for audit trail preservation.',
  `difference_quantity` DECIMAL(15,3) COMMENT 'The variance between counted quantity and book quantity (counted minus book). Positive indicates surplus, negative indicates shortage.',
  `difference_value` DECIMAL(15,2) COMMENT 'The financial value of the inventory variance (difference quantity multiplied by material price). Critical for Sarbanes-Oxley inventory controls and insurance valuation.',
  `fiscal_year` STRING COMMENT 'The fiscal year in which the inventory count was performed. Part of the document key in SAP. Pattern: ^[0-9]{4}$.',
  `freeze_book_inventory_indicator` BOOLEAN COMMENT 'Flag indicating whether the book inventory was frozen at the time of count creation to prevent movements during the count process. Best practice for accurate variance calculation.',
  `gl_account` STRING COMMENT 'The general ledger account to which inventory value and variances are posted. Critical for financial reporting and Sarbanes-Oxley compliance. Pattern: ^[0-9]{10}$.',
  `inventory_document_number` STRING COMMENT 'The unique business identifier for the physical inventory document in SAP S/4HANA MM. Used for tracking and audit purposes. Pattern: ^[0-9]{10}$.',
  `material_description` STRING COMMENT 'Short text description of the material being counted. Denormalized from material master for user readability in count reports.',
  `material_number` STRING COMMENT 'The SAP material number (business identifier) for the item being counted. Denormalized from material master for reporting convenience. Pattern: ^[A-Z0-9]{18}$.',
  `modified_by` STRING COMMENT 'The user ID of the person who last modified the inventory count record. Part of audit trail for change tracking.',
  `modified_timestamp` TIMESTAMP COMMENT 'The date and time when the inventory count record was last modified. Tracks all changes for audit and compliance purposes.',
  `plant_code` STRING COMMENT 'The SAP plant code identifying the utility facility or warehouse where the inventory count was performed. Represents generation plants, T&D warehouses, or service centers. Pattern: ^[A-Z0-9]{4}$.',
  `posting_date` DATE COMMENT 'The date on which the inventory count differences were posted to the financial and material ledgers. Null if count not yet posted.',
  `posting_period` INT COMMENT 'The fiscal period (1-12) in which the inventory differences were posted. Used for period-end closing and financial reporting.',
  `recount_indicator` BOOLEAN COMMENT 'Flag indicating whether this count is a recount (true) or initial count (false). Recounts are triggered when variance exceeds tolerance thresholds.',
  `recount_reason_code` STRING COMMENT 'The reason code explaining why a recount was performed: variance_threshold (difference exceeded tolerance), audit_requirement (external audit request), quality_issue (suspected quality problem), system_error (suspected system issue), manual_request (supervisor override), regulatory (compliance requirement). Valid values: variance_threshold|audit_requirement|quality_issue|system_error|manual_request|regulatory.',
  `serial_number` STRING COMMENT 'The serial number for serialized assets such as meters, transformers, or high-value generation equipment. Null for non-serialized materials.',
  `special_stock_indicator` STRING COMMENT 'Indicator for special stock types such as consignment stock, project stock, or customer stock. Blank for standard warehouse stock.',
  `stock_type` STRING COMMENT 'The stock type or status of the inventory being counted: unrestricted (available for use), quality_inspection (pending QA), blocked (unusable), restricted (limited use), returns (vendor returns pending). Valid values: unrestricted|quality_inspection|blocked|restricted|returns.',
  `storage_location` STRING COMMENT 'The specific storage location or storeroom within the plant where the material is physically stored and counted. Enables granular inventory tracking. Pattern: ^[A-Z0-9]{4}$.',
  `unit_of_measure` STRING COMMENT 'The unit of measure for the counted quantity (e.g., EA for each, FT for feet, GAL for gallons, TON for tons). ISO standard UOM codes. Pattern: ^[A-Z]{2,3}$.',
  `valuation_amount` DECIMAL(15,2) COMMENT 'The total inventory value of the counted material at the time of count, calculated using standard or moving average price. Used for financial reporting.',
  `variance_tolerance_percent` DECIMAL(5,2) COMMENT 'The acceptable variance tolerance percentage for this material. Variances exceeding this threshold trigger recount or investigation workflows.',
  `wbs_element` STRING COMMENT 'The WBS element for project-related inventory (e.g., capital construction projects, generation plant upgrades). Null for non-project inventory.',
  `zero_count_indicator` BOOLEAN COMMENT 'Flag indicating whether the counted quantity was zero (material not found during physical count). Important for identifying potential shrinkage or theft.',
  `created_by` STRING COMMENT 'The user ID of the person who created the inventory count document in the system. Part of audit trail for Sarbanes-Oxley compliance.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_inventory_count` PRIMARY KEY (`inventory_count_id`)
)
USING DELTA
COMMENT 'Physical inventory count records for utility warehouses and storerooms capturing periodic and cycle count results. Captures count identification (inventory document number, count date), location (plant, storage location), material details (material, book quantity, counted quantity, difference quantity, difference value), count workflow (status: not yet counted, counted, recounted, posted; counter ID, recount reason). Supports regulatory asset verification, insurance valuation, Sarbanes-Oxley inventory controls, and inventory accuracy KPIs for utility supply chain management. | CMM: CIM ErpInventoryCount (exact), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'InventoryCount',
  'cmm.cim.class' = 'ErpInventoryCount',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.inventory_count'
);

-- SupplyAgreement  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `supply`.`supply_agreement` (
  `supply_agreement_id` BIGINT NOT NULL COMMENT 'Primary key for supply_agreement',
  `material_master_id` BIGINT COMMENT 'Foreign key linking to the material being supplied under this agreement',
  `vendor_id` BIGINT COMMENT 'Foreign key linking to the vendor who supplies this material under this agreement',
  `agreement_number` BIGINT COMMENT 'Primary key uniquely identifying each vendor-material supply agreement record',
  `agreement_status` STRING COMMENT 'Current lifecycle status of this supply agreement. ACTIVE=approved for procurement, INACTIVE=not currently used, PENDING=under evaluation, EXPIRED=contract ended, SUSPENDED=temporarily blocked.',
  `contract_reference` STRING COMMENT 'Reference number or identifier of the master supply contract or blanket purchase agreement governing this vendor-material relationship, if applicable.',
  `created_date` TIMESTAMP COMMENT 'Timestamp when this supply agreement record was created in the system. Audit trail for supply relationship establishment.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the unit_price in this agreement. May differ from vendor default currency for specific materials or contracts.',
  `delivery_rating` DECIMAL(5,2) COMMENT 'On-time delivery performance score for this specific vendor-material combination. Scale 0-100. Reflects vendor reliability for this particular material, which may differ from their overall performance.',
  `effective_date` DATE COMMENT 'Date from which this supply agreement becomes valid and can be used for procurement. Supports time-based pricing and contract management.',
  `expiration_date` DATE COMMENT 'Date on which this supply agreement expires and should no longer be used for new purchase orders. Null if no expiration. Supports contract lifecycle management.',
  `last_purchase_date` DATE COMMENT 'Date of the most recent purchase order issued to this vendor for this material. Used to track active vs dormant supply relationships.',
  `last_purchase_price` DECIMAL(15,4) COMMENT 'Actual unit price paid on the most recent purchase order for this vendor-material combination. Used for price variance analysis and trend tracking.',
  `last_updated_date` TIMESTAMP COMMENT 'Timestamp of the most recent update to this supply agreement record. Tracks changes to pricing, terms, or ratings.',
  `lead_time_days` INT COMMENT 'Expected delivery lead time in calendar days from purchase order to goods receipt for this specific vendor-material combination. Varies by vendor capability and material complexity.',
  `maximum_order_quantity` DECIMAL(13,3) COMMENT 'Maximum quantity that can be ordered in a single purchase order from this vendor for this material, due to vendor capacity or logistics constraints. Expressed in materials base unit of measure.',
  `minimum_order_quantity` DECIMAL(13,3) COMMENT 'Minimum quantity that must be ordered from this vendor for this material, expressed in the materials base unit of measure. Vendor-specific commercial term.',
  `preferred_vendor_flag` BOOLEAN COMMENT 'Indicates whether this vendor is the preferred source for this specific material based on price, quality, delivery performance, or strategic relationship. Used in automated sourcing decisions.',
  `quality_rating` DECIMAL(5,2) COMMENT 'Quality performance score for this specific vendor-material combination, based on defect rates, inspection results, and warranty claims. Scale 0-100. Tracked separately from overall vendor rating.',
  `unit_price` DECIMAL(15,4) COMMENT 'Negotiated price per base unit of measure for this vendor-material combination. This price is specific to the vendor-material relationship and varies by vendor for the same material.',
  `vendor_material_number` STRING COMMENT 'The vendors own part number or catalog number for this material. Used for cross-referencing in purchase orders and vendor communications. Specific to each vendor-material pair.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_supply_agreement` PRIMARY KEY (`supply_agreement_id`)
)
USING DELTA
COMMENT 'This association product represents the Supply Agreement between vendor and material_master. It captures the commercial and operational terms under which a specific vendor supplies a specific material to the utility. Each record links one vendor to one material_master with pricing, lead time, quality ratings, and procurement terms that exist only in the context of this vendor-material relationship. This is the operational SSOT for approved vendor lists (AVL), competitive sourcing decisions, and procurement execution.. Existence Justification: In utility supply chain operations, vendors supply multiple materials (transformers, conductors, meters, poles, fuel) and each material can be sourced from multiple approved vendors at different prices, lead times, and quality levels. Procurement teams actively manage vendor-material relationships through approved vendor lists (AVL), competitive bidding (RFQ), and sourcing strategies. This is a core operational M:N relationship central to supply chain management and emergency restoration planning. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SupplyAgreement',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.supply_agreement'
);

-- ContractLineItem  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `supply`.`contract_line_item` (
  `contract_line_item_id` BIGINT NOT NULL COMMENT 'Unique identifier for this contract line item record. Primary key.',
  `material_master_id` BIGINT COMMENT 'Foreign key linking to the material master record covered by this contract line item',
  `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to the supplier contract under which this material is procured',
  `contracted_quantity` DECIMAL(15,3) COMMENT 'Total quantity of this material committed under this contract. For quantity contracts, this is the total quantity to be delivered over the contract term.',
  `contracted_unit_price` DECIMAL(15,4) COMMENT 'Negotiated price per unit of measure for this material under this contract. Used for purchase order price validation and invoice verification.',
  `delivery_lead_time_days` INT COMMENT 'Expected number of calendar days from purchase order release to goods receipt for this material under this contract. May differ from the material master planned delivery time based on supplier-specific logistics.',
  `delivery_terms` STRING COMMENT 'Specific delivery conditions and requirements for this material under this contract, including delivery location, packaging requirements, and delivery schedule constraints.',
  `effective_end_date` DATE COMMENT 'Date when this contract line item expires and can no longer be used for procurement. May differ from the overall contract end date if materials are phased out or have different validity periods.',
  `effective_start_date` DATE COMMENT 'Date when this contract line item becomes effective and can be used for procurement. May differ from the overall contract start date if materials are phased in.',
  `line_item_status` STRING COMMENT 'Current lifecycle state of this contract line item. ACTIVE items can be used for procurement, INACTIVE items are temporarily disabled, SUSPENDED items are on hold pending resolution, EXPIRED items have passed their end date, CANCELLED items have been terminated early.',
  `maximum_order_quantity` DECIMAL(15,3) COMMENT 'Maximum quantity that can be ordered per release or over the contract term for this material. Used to enforce contract quantity limits.',
  `minimum_order_quantity` DECIMAL(15,3) COMMENT 'Minimum quantity that must be ordered per release for this material under this contract. Enforces supplier minimum order requirements.',
  `price_escalation_percentage` DECIMAL(5,2) COMMENT 'Annual or periodic price increase percentage applied to this material under this contract. Used to calculate adjusted prices over the contract term based on escalation clauses.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_contract_line_item` PRIMARY KEY (`contract_line_item_id`)
)
USING DELTA
COMMENT 'This association product represents the contractual agreement between a specific material and a supplier contract. It captures the commercial terms, pricing, quantities, and delivery conditions that apply to the procurement of a specific material under a framework contract. Each record links one material to one supplier contract with attributes that exist only in the context of this specific material-contract relationship. Contract line items are referenced on purchase orders and used for price validation during invoice verification.. Existence Justification: In utility procurement operations, supplier contracts are framework agreements that cover multiple materials, and each material can be sourced from multiple suppliers under different contracts. Contract line items are actively managed operational entities that procurement teams create, update, and reference on purchase orders. Each line item captures material-specific commercial terms (price, quantities, lead times, delivery conditions) that exist only in the context of a specific material-contract pairing. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ContractLineItem',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.contract_line_item'
);

-- ContractorCompany  <<CIM Organisation : close>>
CREATE TABLE IF NOT EXISTS `supply`.`contractor_company` (
  `contractor_company_id` BIGINT NOT NULL COMMENT 'Primary key for contractor_company',
  `parent_company_id` BIGINT COMMENT 'Identifier of the parent organization if the contractor is a subsidiary.',
  `parent_contractor_company_id` BIGINT COMMENT 'Self-referencing FK on contractor_company (parent_contractor_company_id)',
  `address_line1` STRING COMMENT 'First line of the contractor\'s primary address.',
  `address_line2` STRING COMMENT 'Second line of the contractor\'s primary address (optional).',
  `annual_revenue` DECIMAL(18,2) COMMENT 'Reported annual revenue of the contractor company in USD.',
  `bank_account_number` STRING COMMENT 'Primary bank account number used for payments to the contractor.',
  `bank_routing_number` STRING COMMENT 'Routing number (or equivalent) for the contractor\'s bank.',
  `bond_amount` DECIMAL(15,2) COMMENT 'Monetary value of the performance bond issued for the contractor.',
  `bond_company` STRING COMMENT 'Name of the surety company providing a performance bond for the contractor.',
  `certifications` STRING COMMENT 'Comma-separated list of professional certifications held by the contractor (e.g., ISO 9001, ISO 14001).',
  `city` STRING COMMENT 'City of the contractor\'s primary address.',
  `compliance_status` STRING COMMENT 'Current compliance status of the contractor with industry regulations.',
  `contractor_type` STRING COMMENT 'Category describing the primary business focus of the contractor.',
  `country_code` STRING COMMENT 'Three-letter ISO country code of the contractor\'s primary address.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the contractor record was first created in the system.',
  `credit_rating` STRING COMMENT 'Credit rating assigned to the contractor by a rating agency.',
  `effective_from` DATE COMMENT 'Date when the contractor relationship becomes effective.',
  `effective_until` DATE COMMENT 'Date when the contractor relationship ends or is scheduled to end (null if open-ended).',
  `email` STRING COMMENT 'General email address for the contractor company.',
  `esg_score` DECIMAL(5,2) COMMENT 'Overall ESG rating for the contractor company.',
  `headquarters_location` STRING COMMENT 'City and country of the contractor\'s corporate headquarters.',
  `industry_classification_code` STRING COMMENT 'North American Industry Classification System code for the contractor\'s primary industry.',
  `insurance_expiry_date` DATE COMMENT 'Date when the contractor\'s liability insurance coverage expires.',
  `insurance_policy_number` STRING COMMENT 'Reference number of the contractor\'s liability insurance policy.',
  `is_tax_exempt` BOOLEAN COMMENT 'Indicates whether the contractor is exempt from certain taxes.',
  `legal_name` STRING COMMENT 'Full legal name of the contractor as registered with governmental authorities.',
  `name` STRING COMMENT 'Common name used to refer to the contractor company.',
  `number_of_employees` INT COMMENT 'Total headcount employed by the contractor.',
  `operating_regions` STRING COMMENT 'Geographic regions where the contractor provides services, stored as a comma-separated list of ISO country codes.',
  `payment_terms` STRING COMMENT 'Typical payment terms negotiated with the contractor.',
  `phone` STRING COMMENT 'General telephone number for the contractor company.',
  `postal_code` STRING COMMENT 'Postal or ZIP code of the contractor\'s primary address.',
  `primary_contact_email` STRING COMMENT 'Email address of the primary contact person.',
  `primary_contact_name` STRING COMMENT 'Name of the primary business contact for the contractor.',
  `primary_contact_phone` STRING COMMENT 'Phone number of the primary contact person.',
  `rating` DECIMAL(3,2) COMMENT 'Aggregated rating (e.g., 0-5) based on performance, safety, and compliance.',
  `risk_level` STRING COMMENT 'Risk classification for the contractor based on financial and operational factors.',
  `safety_score` DECIMAL(5,2) COMMENT 'Numeric score representing the contractor\'s safety performance (e.g., based on incident rates).',
  `state_province` STRING COMMENT 'State or province of the contractor\'s primary address.',
  `status` STRING COMMENT 'Current lifecycle status of the contractor company.',
  `sustainability_certifications` STRING COMMENT 'Comma-separated list of sustainability or environmental certifications held by the contractor.',
  `tax_identifier` STRING COMMENT 'Government-issued tax identifier for the contractor company.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the contractor record.',
  `website` STRING COMMENT 'Public website URL of the contractor company.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_supply_contractor_company` PRIMARY KEY (`contractor_company_id`)
)
USING DELTA
COMMENT 'Master reference table for contractor_company. Referenced by contractor_company_id. | CMM: CIM Organisation (close), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ContractorCompany',
  'cmm.cim.class' = 'Organisation',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.supply.contractor_company'
);

-- ========= FOREIGN KEYS within supply (80) =========
ALTER TABLE `supply`.`purchase_order` DROP CONSTRAINT IF EXISTS `fk_supply_purchase_order_purchase_supplier_contract_id`;
ALTER TABLE `supply`.`purchase_order` ADD CONSTRAINT `fk_supply_purchase_order_purchase_supplier_contract_id` FOREIGN KEY (`purchase_supplier_contract_id`) REFERENCES `supply`.`supplier_contract` (`supplier_contract_id`);

ALTER TABLE `supply`.`purchase_order` DROP CONSTRAINT IF EXISTS `fk_supply_purchase_order_purchase_vendor_id`;
ALTER TABLE `supply`.`purchase_order` ADD CONSTRAINT `fk_supply_purchase_order_purchase_vendor_id` FOREIGN KEY (`purchase_vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `supply`.`purchase_order` DROP CONSTRAINT IF EXISTS `fk_supply_purchase_order_supplier_contract_id`;
ALTER TABLE `supply`.`purchase_order` ADD CONSTRAINT `fk_supply_purchase_order_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `supply`.`supplier_contract` (`supplier_contract_id`);

ALTER TABLE `supply`.`purchase_order` DROP CONSTRAINT IF EXISTS `fk_supply_purchase_order_to_supplier_contract_id`;
ALTER TABLE `supply`.`purchase_order` ADD CONSTRAINT `fk_supply_purchase_order_to_supplier_contract_id` FOREIGN KEY (`to_supplier_contract_id`) REFERENCES `supply`.`supplier_contract` (`supplier_contract_id`);

ALTER TABLE `supply`.`purchase_order` DROP CONSTRAINT IF EXISTS `fk_supply_purchase_order_to_vendor_id`;
ALTER TABLE `supply`.`purchase_order` ADD CONSTRAINT `fk_supply_purchase_order_to_vendor_id` FOREIGN KEY (`to_vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `supply`.`purchase_order` DROP CONSTRAINT IF EXISTS `fk_supply_purchase_order_vendor_id`;
ALTER TABLE `supply`.`purchase_order` ADD CONSTRAINT `fk_supply_purchase_order_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `supply`.`po_line_item` DROP CONSTRAINT IF EXISTS `fk_supply_po_line_item_material_master_id`;
ALTER TABLE `supply`.`po_line_item` ADD CONSTRAINT `fk_supply_po_line_item_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`po_line_item` DROP CONSTRAINT IF EXISTS `fk_supply_po_line_item_po_material_master_id`;
ALTER TABLE `supply`.`po_line_item` ADD CONSTRAINT `fk_supply_po_line_item_po_material_master_id` FOREIGN KEY (`po_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`po_line_item` DROP CONSTRAINT IF EXISTS `fk_supply_po_line_item_po_purchase_order_id`;
ALTER TABLE `supply`.`po_line_item` ADD CONSTRAINT `fk_supply_po_line_item_po_purchase_order_id` FOREIGN KEY (`po_purchase_order_id`) REFERENCES `supply`.`purchase_order` (`purchase_order_id`);

ALTER TABLE `supply`.`po_line_item` DROP CONSTRAINT IF EXISTS `fk_supply_po_line_item_purchase_order_id`;
ALTER TABLE `supply`.`po_line_item` ADD CONSTRAINT `fk_supply_po_line_item_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `supply`.`purchase_order` (`purchase_order_id`);

ALTER TABLE `supply`.`po_line_item` DROP CONSTRAINT IF EXISTS `fk_supply_po_line_item_purchase_requisition_id`;
ALTER TABLE `supply`.`po_line_item` ADD CONSTRAINT `fk_supply_po_line_item_purchase_requisition_id` FOREIGN KEY (`purchase_requisition_id`) REFERENCES `supply`.`purchase_requisition` (`purchase_requisition_id`);

ALTER TABLE `supply`.`po_line_item` DROP CONSTRAINT IF EXISTS `fk_supply_po_line_item_to_material_master_id`;
ALTER TABLE `supply`.`po_line_item` ADD CONSTRAINT `fk_supply_po_line_item_to_material_master_id` FOREIGN KEY (`to_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`po_line_item` DROP CONSTRAINT IF EXISTS `fk_supply_po_line_item_to_purchase_order_id`;
ALTER TABLE `supply`.`po_line_item` ADD CONSTRAINT `fk_supply_po_line_item_to_purchase_order_id` FOREIGN KEY (`to_purchase_order_id`) REFERENCES `supply`.`purchase_order` (`purchase_order_id`);

ALTER TABLE `supply`.`goods_receipt` DROP CONSTRAINT IF EXISTS `fk_supply_goods_receipt_goods_material_master_id`;
ALTER TABLE `supply`.`goods_receipt` ADD CONSTRAINT `fk_supply_goods_receipt_goods_material_master_id` FOREIGN KEY (`goods_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`goods_receipt` DROP CONSTRAINT IF EXISTS `fk_supply_goods_receipt_goods_purchase_order_id`;
ALTER TABLE `supply`.`goods_receipt` ADD CONSTRAINT `fk_supply_goods_receipt_goods_purchase_order_id` FOREIGN KEY (`goods_purchase_order_id`) REFERENCES `supply`.`purchase_order` (`purchase_order_id`);

ALTER TABLE `supply`.`goods_receipt` DROP CONSTRAINT IF EXISTS `fk_supply_goods_receipt_goods_warehouse_id`;
ALTER TABLE `supply`.`goods_receipt` ADD CONSTRAINT `fk_supply_goods_receipt_goods_warehouse_id` FOREIGN KEY (`goods_warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `supply`.`goods_receipt` DROP CONSTRAINT IF EXISTS `fk_supply_goods_receipt_material_master_id`;
ALTER TABLE `supply`.`goods_receipt` ADD CONSTRAINT `fk_supply_goods_receipt_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`goods_receipt` DROP CONSTRAINT IF EXISTS `fk_supply_goods_receipt_po_line_item_id`;
ALTER TABLE `supply`.`goods_receipt` ADD CONSTRAINT `fk_supply_goods_receipt_po_line_item_id` FOREIGN KEY (`po_line_item_id`) REFERENCES `supply`.`po_line_item` (`po_line_item_id`);

ALTER TABLE `supply`.`goods_receipt` DROP CONSTRAINT IF EXISTS `fk_supply_goods_receipt_purchase_order_id`;
ALTER TABLE `supply`.`goods_receipt` ADD CONSTRAINT `fk_supply_goods_receipt_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `supply`.`purchase_order` (`purchase_order_id`);

ALTER TABLE `supply`.`goods_receipt` DROP CONSTRAINT IF EXISTS `fk_supply_goods_receipt_receiving_warehouse_id`;
ALTER TABLE `supply`.`goods_receipt` ADD CONSTRAINT `fk_supply_goods_receipt_receiving_warehouse_id` FOREIGN KEY (`receiving_warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `supply`.`goods_receipt` DROP CONSTRAINT IF EXISTS `fk_supply_goods_receipt_to_material_master_id`;
ALTER TABLE `supply`.`goods_receipt` ADD CONSTRAINT `fk_supply_goods_receipt_to_material_master_id` FOREIGN KEY (`to_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`goods_receipt` DROP CONSTRAINT IF EXISTS `fk_supply_goods_receipt_to_purchase_order_id`;
ALTER TABLE `supply`.`goods_receipt` ADD CONSTRAINT `fk_supply_goods_receipt_to_purchase_order_id` FOREIGN KEY (`to_purchase_order_id`) REFERENCES `supply`.`purchase_order` (`purchase_order_id`);

ALTER TABLE `supply`.`goods_receipt` DROP CONSTRAINT IF EXISTS `fk_supply_goods_receipt_vendor_id`;
ALTER TABLE `supply`.`goods_receipt` ADD CONSTRAINT `fk_supply_goods_receipt_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `supply`.`goods_receipt` DROP CONSTRAINT IF EXISTS `fk_supply_goods_receipt_warehouse_id`;
ALTER TABLE `supply`.`goods_receipt` ADD CONSTRAINT `fk_supply_goods_receipt_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `supply`.`warehouse_stock` DROP CONSTRAINT IF EXISTS `fk_supply_warehouse_stock_material_master_id`;
ALTER TABLE `supply`.`warehouse_stock` ADD CONSTRAINT `fk_supply_warehouse_stock_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`warehouse_stock` DROP CONSTRAINT IF EXISTS `fk_supply_warehouse_stock_primary_warehouse_id`;
ALTER TABLE `supply`.`warehouse_stock` ADD CONSTRAINT `fk_supply_warehouse_stock_primary_warehouse_id` FOREIGN KEY (`primary_warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `supply`.`warehouse_stock` DROP CONSTRAINT IF EXISTS `fk_supply_warehouse_stock_to_material_master_id`;
ALTER TABLE `supply`.`warehouse_stock` ADD CONSTRAINT `fk_supply_warehouse_stock_to_material_master_id` FOREIGN KEY (`to_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`warehouse_stock` DROP CONSTRAINT IF EXISTS `fk_supply_warehouse_stock_to_warehouse_id`;
ALTER TABLE `supply`.`warehouse_stock` ADD CONSTRAINT `fk_supply_warehouse_stock_to_warehouse_id` FOREIGN KEY (`to_warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `supply`.`warehouse_stock` DROP CONSTRAINT IF EXISTS `fk_supply_warehouse_stock_warehouse_material_master_id`;
ALTER TABLE `supply`.`warehouse_stock` ADD CONSTRAINT `fk_supply_warehouse_stock_warehouse_material_master_id` FOREIGN KEY (`warehouse_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`supplier_contract` DROP CONSTRAINT IF EXISTS `fk_supply_supplier_contract_supplier_vendor_id`;
ALTER TABLE `supply`.`supplier_contract` ADD CONSTRAINT `fk_supply_supplier_contract_supplier_vendor_id` FOREIGN KEY (`supplier_vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `supply`.`supplier_contract` DROP CONSTRAINT IF EXISTS `fk_supply_supplier_contract_vendor_id`;
ALTER TABLE `supply`.`supplier_contract` ADD CONSTRAINT `fk_supply_supplier_contract_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `supply`.`fuel_supply_contract` DROP CONSTRAINT IF EXISTS `fk_supply_fuel_supply_contract_vendor_id`;
ALTER TABLE `supply`.`fuel_supply_contract` ADD CONSTRAINT `fk_supply_fuel_supply_contract_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `supply`.`purchase_requisition` DROP CONSTRAINT IF EXISTS `fk_supply_purchase_requisition_material_master_id`;
ALTER TABLE `supply`.`purchase_requisition` ADD CONSTRAINT `fk_supply_purchase_requisition_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`purchase_requisition` DROP CONSTRAINT IF EXISTS `fk_supply_purchase_requisition_preferred_vendor_id`;
ALTER TABLE `supply`.`purchase_requisition` ADD CONSTRAINT `fk_supply_purchase_requisition_preferred_vendor_id` FOREIGN KEY (`preferred_vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `supply`.`purchase_requisition` DROP CONSTRAINT IF EXISTS `fk_supply_purchase_requisition_purchase_material_master_id`;
ALTER TABLE `supply`.`purchase_requisition` ADD CONSTRAINT `fk_supply_purchase_requisition_purchase_material_master_id` FOREIGN KEY (`purchase_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`purchase_requisition` DROP CONSTRAINT IF EXISTS `fk_supply_purchase_requisition_purchase_order_id`;
ALTER TABLE `supply`.`purchase_requisition` ADD CONSTRAINT `fk_supply_purchase_requisition_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `supply`.`purchase_order` (`purchase_order_id`);

ALTER TABLE `supply`.`goods_issue` DROP CONSTRAINT IF EXISTS `fk_supply_goods_issue_goods_receipt_id`;
ALTER TABLE `supply`.`goods_issue` ADD CONSTRAINT `fk_supply_goods_issue_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `supply`.`goods_receipt` (`goods_receipt_id`);

ALTER TABLE `supply`.`goods_issue` DROP CONSTRAINT IF EXISTS `fk_supply_goods_issue_material_master_id`;
ALTER TABLE `supply`.`goods_issue` ADD CONSTRAINT `fk_supply_goods_issue_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`goods_issue` DROP CONSTRAINT IF EXISTS `fk_supply_goods_issue_purchase_order_id`;
ALTER TABLE `supply`.`goods_issue` ADD CONSTRAINT `fk_supply_goods_issue_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `supply`.`purchase_order` (`purchase_order_id`);

ALTER TABLE `supply`.`goods_issue` DROP CONSTRAINT IF EXISTS `fk_supply_goods_issue_vendor_id`;
ALTER TABLE `supply`.`goods_issue` ADD CONSTRAINT `fk_supply_goods_issue_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `supply`.`goods_issue` DROP CONSTRAINT IF EXISTS `fk_supply_goods_issue_warehouse_id`;
ALTER TABLE `supply`.`goods_issue` ADD CONSTRAINT `fk_supply_goods_issue_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `supply`.`stock_transfer` DROP CONSTRAINT IF EXISTS `fk_supply_stock_transfer_primary_stock_warehouse_id`;
ALTER TABLE `supply`.`stock_transfer` ADD CONSTRAINT `fk_supply_stock_transfer_primary_stock_warehouse_id` FOREIGN KEY (`primary_stock_warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `supply`.`stock_transfer` DROP CONSTRAINT IF EXISTS `fk_supply_stock_transfer_receiving_storage_location_warehouse_id`;
ALTER TABLE `supply`.`stock_transfer` ADD CONSTRAINT `fk_supply_stock_transfer_receiving_storage_location_warehouse_id` FOREIGN KEY (`receiving_storage_location_warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `supply`.`stock_transfer` DROP CONSTRAINT IF EXISTS `fk_supply_stock_transfer_stock_material_master_id`;
ALTER TABLE `supply`.`stock_transfer` ADD CONSTRAINT `fk_supply_stock_transfer_stock_material_master_id` FOREIGN KEY (`stock_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`stock_transfer` DROP CONSTRAINT IF EXISTS `fk_supply_stock_transfer_to_material_master_id`;
ALTER TABLE `supply`.`stock_transfer` ADD CONSTRAINT `fk_supply_stock_transfer_to_material_master_id` FOREIGN KEY (`to_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`invoice_verification` DROP CONSTRAINT IF EXISTS `fk_supply_invoice_verification_goods_receipt_id`;
ALTER TABLE `supply`.`invoice_verification` ADD CONSTRAINT `fk_supply_invoice_verification_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `supply`.`goods_receipt` (`goods_receipt_id`);

ALTER TABLE `supply`.`invoice_verification` DROP CONSTRAINT IF EXISTS `fk_supply_invoice_verification_invoice_purchase_order_id`;
ALTER TABLE `supply`.`invoice_verification` ADD CONSTRAINT `fk_supply_invoice_verification_invoice_purchase_order_id` FOREIGN KEY (`invoice_purchase_order_id`) REFERENCES `supply`.`purchase_order` (`purchase_order_id`);

ALTER TABLE `supply`.`invoice_verification` DROP CONSTRAINT IF EXISTS `fk_supply_invoice_verification_invoice_vendor_id`;
ALTER TABLE `supply`.`invoice_verification` ADD CONSTRAINT `fk_supply_invoice_verification_invoice_vendor_id` FOREIGN KEY (`invoice_vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `supply`.`invoice_verification` DROP CONSTRAINT IF EXISTS `fk_supply_invoice_verification_primary_purchase_order_id`;
ALTER TABLE `supply`.`invoice_verification` ADD CONSTRAINT `fk_supply_invoice_verification_primary_purchase_order_id` FOREIGN KEY (`primary_purchase_order_id`) REFERENCES `supply`.`purchase_order` (`purchase_order_id`);

ALTER TABLE `supply`.`invoice_verification` DROP CONSTRAINT IF EXISTS `fk_supply_invoice_verification_primary_vendor_id`;
ALTER TABLE `supply`.`invoice_verification` ADD CONSTRAINT `fk_supply_invoice_verification_primary_vendor_id` FOREIGN KEY (`primary_vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `supply`.`spare_parts_catalog` DROP CONSTRAINT IF EXISTS `fk_supply_spare_parts_catalog_preferred_vendor_id`;
ALTER TABLE `supply`.`spare_parts_catalog` ADD CONSTRAINT `fk_supply_spare_parts_catalog_preferred_vendor_id` FOREIGN KEY (`preferred_vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `supply`.`spare_parts_catalog` DROP CONSTRAINT IF EXISTS `fk_supply_spare_parts_catalog_primary_material_master_id`;
ALTER TABLE `supply`.`spare_parts_catalog` ADD CONSTRAINT `fk_supply_spare_parts_catalog_primary_material_master_id` FOREIGN KEY (`primary_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`spare_parts_catalog` DROP CONSTRAINT IF EXISTS `fk_supply_spare_parts_catalog_spare_material_master_id`;
ALTER TABLE `supply`.`spare_parts_catalog` ADD CONSTRAINT `fk_supply_spare_parts_catalog_spare_material_master_id` FOREIGN KEY (`spare_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`spare_parts_catalog` DROP CONSTRAINT IF EXISTS `fk_supply_spare_parts_catalog_tertiary_material_master_id`;
ALTER TABLE `supply`.`spare_parts_catalog` ADD CONSTRAINT `fk_supply_spare_parts_catalog_tertiary_material_master_id` FOREIGN KEY (`tertiary_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`spare_parts_catalog` DROP CONSTRAINT IF EXISTS `fk_supply_spare_parts_catalog_warehouse_id`;
ALTER TABLE `supply`.`spare_parts_catalog` ADD CONSTRAINT `fk_supply_spare_parts_catalog_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `supply`.`vendor_evaluation` DROP CONSTRAINT IF EXISTS `fk_supply_vendor_evaluation_vendor_id`;
ALTER TABLE `supply`.`vendor_evaluation` ADD CONSTRAINT `fk_supply_vendor_evaluation_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `supply`.`request_for_quotation` DROP CONSTRAINT IF EXISTS `fk_supply_request_for_quotation_purchase_requisition_id`;
ALTER TABLE `supply`.`request_for_quotation` ADD CONSTRAINT `fk_supply_request_for_quotation_purchase_requisition_id` FOREIGN KEY (`purchase_requisition_id`) REFERENCES `supply`.`purchase_requisition` (`purchase_requisition_id`);

ALTER TABLE `supply`.`request_for_quotation` DROP CONSTRAINT IF EXISTS `fk_supply_request_for_quotation_request_awarded_vendor_id`;
ALTER TABLE `supply`.`request_for_quotation` ADD CONSTRAINT `fk_supply_request_for_quotation_request_awarded_vendor_id` FOREIGN KEY (`request_awarded_vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `supply`.`request_for_quotation` DROP CONSTRAINT IF EXISTS `fk_supply_request_for_quotation_request_vendor_id`;
ALTER TABLE `supply`.`request_for_quotation` ADD CONSTRAINT `fk_supply_request_for_quotation_request_vendor_id` FOREIGN KEY (`request_vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `supply`.`request_for_quotation` DROP CONSTRAINT IF EXISTS `fk_supply_request_for_quotation_vendor_id`;
ALTER TABLE `supply`.`request_for_quotation` ADD CONSTRAINT `fk_supply_request_for_quotation_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `supply`.`vendor_quotation` DROP CONSTRAINT IF EXISTS `fk_supply_vendor_quotation_primary_vendor_material_master_id`;
ALTER TABLE `supply`.`vendor_quotation` ADD CONSTRAINT `fk_supply_vendor_quotation_primary_vendor_material_master_id` FOREIGN KEY (`primary_vendor_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`vendor_quotation` DROP CONSTRAINT IF EXISTS `fk_supply_vendor_quotation_request_for_quotation_id`;
ALTER TABLE `supply`.`vendor_quotation` ADD CONSTRAINT `fk_supply_vendor_quotation_request_for_quotation_id` FOREIGN KEY (`request_for_quotation_id`) REFERENCES `supply`.`request_for_quotation` (`request_for_quotation_id`);

ALTER TABLE `supply`.`vendor_quotation` DROP CONSTRAINT IF EXISTS `fk_supply_vendor_quotation_vendor_id`;
ALTER TABLE `supply`.`vendor_quotation` ADD CONSTRAINT `fk_supply_vendor_quotation_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `supply`.`vendor_quotation` DROP CONSTRAINT IF EXISTS `fk_supply_vendor_quotation_vendor_material_master_id`;
ALTER TABLE `supply`.`vendor_quotation` ADD CONSTRAINT `fk_supply_vendor_quotation_vendor_material_master_id` FOREIGN KEY (`vendor_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`emergency_stock_event` DROP CONSTRAINT IF EXISTS `fk_supply_emergency_stock_event_emergency_purchase_order_id`;
ALTER TABLE `supply`.`emergency_stock_event` ADD CONSTRAINT `fk_supply_emergency_stock_event_emergency_purchase_order_id` FOREIGN KEY (`emergency_purchase_order_id`) REFERENCES `supply`.`purchase_order` (`purchase_order_id`);

ALTER TABLE `supply`.`emergency_stock_event` DROP CONSTRAINT IF EXISTS `fk_supply_emergency_stock_event_material_master_id`;
ALTER TABLE `supply`.`emergency_stock_event` ADD CONSTRAINT `fk_supply_emergency_stock_event_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`emergency_stock_event` DROP CONSTRAINT IF EXISTS `fk_supply_emergency_stock_event_primary_vendor_id`;
ALTER TABLE `supply`.`emergency_stock_event` ADD CONSTRAINT `fk_supply_emergency_stock_event_primary_vendor_id` FOREIGN KEY (`primary_vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `supply`.`emergency_stock_event` DROP CONSTRAINT IF EXISTS `fk_supply_emergency_stock_event_primary_warehouse_id`;
ALTER TABLE `supply`.`emergency_stock_event` ADD CONSTRAINT `fk_supply_emergency_stock_event_primary_warehouse_id` FOREIGN KEY (`primary_warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `supply`.`inventory_count` DROP CONSTRAINT IF EXISTS `fk_supply_inventory_count_inventory_material_master_id`;
ALTER TABLE `supply`.`inventory_count` ADD CONSTRAINT `fk_supply_inventory_count_inventory_material_master_id` FOREIGN KEY (`inventory_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`inventory_count` DROP CONSTRAINT IF EXISTS `fk_supply_inventory_count_inventory_warehouse_id`;
ALTER TABLE `supply`.`inventory_count` ADD CONSTRAINT `fk_supply_inventory_count_inventory_warehouse_id` FOREIGN KEY (`inventory_warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `supply`.`inventory_count` DROP CONSTRAINT IF EXISTS `fk_supply_inventory_count_material_master_id`;
ALTER TABLE `supply`.`inventory_count` ADD CONSTRAINT `fk_supply_inventory_count_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`inventory_count` DROP CONSTRAINT IF EXISTS `fk_supply_inventory_count_to_material_master_id`;
ALTER TABLE `supply`.`inventory_count` ADD CONSTRAINT `fk_supply_inventory_count_to_material_master_id` FOREIGN KEY (`to_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`inventory_count` DROP CONSTRAINT IF EXISTS `fk_supply_inventory_count_to_warehouse_id`;
ALTER TABLE `supply`.`inventory_count` ADD CONSTRAINT `fk_supply_inventory_count_to_warehouse_id` FOREIGN KEY (`to_warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `supply`.`inventory_count` DROP CONSTRAINT IF EXISTS `fk_supply_inventory_count_warehouse_id`;
ALTER TABLE `supply`.`inventory_count` ADD CONSTRAINT `fk_supply_inventory_count_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `supply`.`supply_agreement` DROP CONSTRAINT IF EXISTS `fk_supply_supply_agreement_material_master_id`;
ALTER TABLE `supply`.`supply_agreement` ADD CONSTRAINT `fk_supply_supply_agreement_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`supply_agreement` DROP CONSTRAINT IF EXISTS `fk_supply_supply_agreement_vendor_id`;
ALTER TABLE `supply`.`supply_agreement` ADD CONSTRAINT `fk_supply_supply_agreement_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `supply`.`contract_line_item` DROP CONSTRAINT IF EXISTS `fk_supply_contract_line_item_material_master_id`;
ALTER TABLE `supply`.`contract_line_item` ADD CONSTRAINT `fk_supply_contract_line_item_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `supply`.`contract_line_item` DROP CONSTRAINT IF EXISTS `fk_supply_contract_line_item_supplier_contract_id`;
ALTER TABLE `supply`.`contract_line_item` ADD CONSTRAINT `fk_supply_contract_line_item_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `supply`.`supplier_contract` (`supplier_contract_id`);

ALTER TABLE `supply`.`contractor_company` DROP CONSTRAINT IF EXISTS `fk_supply_contractor_company_parent_company_id`;
ALTER TABLE `supply`.`contractor_company` ADD CONSTRAINT `fk_supply_contractor_company_parent_company_id` FOREIGN KEY (`parent_company_id`) REFERENCES `supply`.`contractor_company` (`contractor_company_id`);

ALTER TABLE `supply`.`contractor_company` DROP CONSTRAINT IF EXISTS `fk_supply_contractor_company_parent_contractor_company_id`;
ALTER TABLE `supply`.`contractor_company` ADD CONSTRAINT `fk_supply_contractor_company_parent_contractor_company_id` FOREIGN KEY (`parent_contractor_company_id`) REFERENCES `supply`.`contractor_company` (`contractor_company_id`);

