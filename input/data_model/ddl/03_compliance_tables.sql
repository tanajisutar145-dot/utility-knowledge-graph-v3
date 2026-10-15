-- Utility CMM-aligned Canonical Data Model (Silver) v1.0.0 | source: Databricks lakehouse-industry-data-models energy_utilities v1 ECM | generated 2026-10-13
-- 03 | Subject area: compliance | 36 tables | CIM packages: IEC61968::Common (Document/ActivityRecord extensions)
-- Standards: NERC Reliability Standards (CIP, PRC, TOP, BAL, EOP); FERC; EPA 40 CFR Part 75; SOX 404
-- Contents: tables (with PK + NOT NULL), then intra-subject-area foreign keys.
-- Unity Catalog PK/FK constraints are informational (NOT ENFORCED); NOT NULL is enforced.

USE CATALOG `utility_cmm_silver`;

-- ComplianceObligation  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`obligation` (
  `obligation_id` BIGINT NOT NULL COMMENT 'Unique identifier for the regulatory compliance obligation record.',
  `responsible_organization_unit_org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Regulatory obligations are assigned to organizational units for compliance accountability and resource planning. Replaces text field with FK to enable departmental obligation portfolio management and',
  `active_flag` BOOLEAN COMMENT 'Indicates whether this obligation is currently active and enforceable (True/False). Inactive obligations are retained for historical reference.',
  `applicability_scope` STRING COMMENT 'Business function or operational area to which the obligation applies (generation, transmission, distribution, trading, retail, wholesale, enterprise-wide, specific facility, specific asset class). Reference-value candidates: generation|transmission|distribution|trading|retail|wholesale|enterprise_wide|specific_facility|specific_asset_class.',
  `board_reporting_flag` BOOLEAN COMMENT 'Indicates whether compliance status for this obligation must be reported to the Board of Directors (True/False).',
  `compliance_frequency` STRING COMMENT 'Frequency at which compliance with the obligation must be demonstrated or reported (continuous, daily, weekly, monthly, quarterly, semi-annual, annual, biennial, triennial, event-driven, one-time). Reference-value candidates: continuous|daily|weekly|monthly|quarterly|semi_annual|annual|biennial|triennial|event_driven|one_time.',
  `compliance_notes` STRING COMMENT 'Free-text field for additional notes, context, or guidance related to compliance with this obligation.',
  `compliance_status` STRING COMMENT 'Current compliance status of the utility with respect to this obligation (compliant, non-compliant, in-progress, not-applicable, under-review, remediation-required). Valid values: compliant|non_compliant|in_progress|not_applicable|under_review|remediation_required.',
  `control_effectiveness_rating` STRING COMMENT 'Assessment of the effectiveness of internal controls in place to ensure compliance with this obligation (effective, needs-improvement, ineffective, not-assessed). Valid values: effective|needs_improvement|ineffective|not_assessed.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this obligation record was first created in the system.',
  `effective_date` DATE COMMENT 'Date on which the compliance obligation became or will become effective and enforceable.',
  `enforcement_action_flag` BOOLEAN COMMENT 'Indicates whether an enforcement action has been taken against the utility for non-compliance with this obligation (True/False).',
  `evidence_collection_method` STRING COMMENT 'Method by which compliance evidence is collected for this obligation (automated, manual, hybrid, third-party). Valid values: automated|manual|hybrid|third_party.',
  `evidence_retention_period_years` INT COMMENT 'Number of years that compliance evidence must be retained for this obligation.',
  `expiration_date` DATE COMMENT 'Date on which the compliance obligation expires or is superseded. Null if the obligation is ongoing.',
  `external_auditor_flag` BOOLEAN COMMENT 'Indicates whether this obligation is subject to external auditor review (True/False).',
  `governing_body` STRING COMMENT 'Regulatory authority or governing body that issued the compliance obligation (NERC, FERC, PUC, EPA, DOE, OSHA, IEC, IEEE, NAESB, SOX). Reference-value candidates: NERC|FERC|PUC|EPA|DOE|OSHA|IEC|IEEE|NAESB|SOX.',
  `imposed_by_agency` BIGINT COMMENT 'FK to compliance.regulatory_agency.regulatory_agency_id — Each obligation is imposed by a governing regulatory body. This is a fundamental master-reference FK.',
  `last_audit_date` DATE COMMENT 'Date of the most recent internal or external audit that assessed compliance with this obligation.',
  `last_audit_result` STRING COMMENT 'Outcome of the most recent audit for this obligation (pass, fail, conditional-pass, not-audited). Valid values: pass|fail|conditional_pass|not_audited.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this obligation record was last modified.',
  `mitigation_plan_required_flag` BOOLEAN COMMENT 'Indicates whether a formal mitigation plan is required for this obligation (True/False).',
  `mitigation_plan_status` STRING COMMENT 'Current status of the mitigation plan for this obligation (not-required, planned, in-progress, completed, approved, rejected). Valid values: not_required|planned|in_progress|completed|approved|rejected.',
  `next_audit_date` DATE COMMENT 'Scheduled date for the next internal or external audit of this obligation.',
  `next_compliance_due_date` DATE COMMENT 'Next scheduled date by which compliance evidence or reporting is due for this obligation.',
  `obligation_category` STRING COMMENT 'High-level category grouping for the obligation (e.g., NERC CIP for cybersecurity, TPL for transmission planning, FAC for facilities, environmental, financial, safety, operational). Reference-value candidates: CIP|TPL|FAC|MOD|PRC|VAR|TOP|IRO|BAL|EOP|NUC|COM|environmental|financial|safety|operational.',
  `obligation_code` STRING COMMENT 'Business-assigned unique code for the compliance obligation (e.g., NERC-CIP-007-6, FERC-717, PUC-RR-2023-01). Pattern: ^[A-Z0-9]{3,20}$.',
  `obligation_description` STRING COMMENT 'Detailed description of what the utility is required to do to comply with this obligation, including specific actions, controls, or reporting requirements.',
  `obligation_name` STRING COMMENT 'Full descriptive name of the regulatory compliance obligation.',
  `obligation_type` STRING COMMENT 'Classification of the compliance obligation by its nature (reliability standard, tariff requirement, service territory rule, emissions limit, safety mandate, internal control, certificate condition, reporting requirement, operational requirement, financial requirement). Reference-value candidates: reliability_standard|tariff_requirement|service_territory_rule|emissions_limit|safety_mandate|internal_control|certificate_condition|reporting_requirement|operational_requirement|financial_requirement.',
  `parent_obligation_code` STRING COMMENT 'Code of the parent obligation if this is a sub-requirement or part of a larger obligation. Null if this is a top-level obligation.',
  `penalty_amount_usd` DECIMAL(18,2) COMMENT 'Maximum or typical financial penalty amount in US dollars for non-compliance with this obligation.',
  `regulatory_citation` STRING COMMENT 'Full legal citation or reference to the regulation, standard, or rule (e.g., NERC CIP-007-6 R2, FERC Order 1000, 40 CFR Part 60).',
  `reporting_format` STRING COMMENT 'Format in which compliance reporting must be submitted (electronic, paper, web-portal, API, email). Valid values: electronic|paper|web_portal|api|email.',
  `reporting_system` STRING COMMENT 'Name of the external system or portal used for compliance reporting (e.g., NERC CMEP Portal, FERC eFiling, State PUC Portal).',
  `responsible_role` STRING COMMENT 'Job title or role responsible for managing compliance with this obligation (e.g., Compliance Manager, NERC CIP Coordinator, Environmental Manager).',
  `risk_rating` STRING COMMENT 'Internal risk rating assigned to this obligation based on impact and likelihood of non-compliance (critical, high, medium, low). Valid values: critical|high|medium|low.',
  `sub_requirement_count` INT COMMENT 'Number of sub-requirements or parts within this obligation (e.g., NERC CIP-007-6 has multiple R1, R2, R3 requirements).',
  `updated_by_user` STRING COMMENT 'Username or identifier of the person who last updated this obligation record.',
  `vrf` STRING COMMENT 'NERC Violation Risk Factor indicating the potential impact of non-compliance on bulk electric system reliability (lower, medium, high). Applicable to NERC reliability standards only. Valid values: lower|medium|high.',
  `vsl` STRING COMMENT 'NERC Violation Severity Level indicating the degree of non-compliance (lower, moderate, high, severe). Applicable to NERC reliability standards only. Valid values: lower|moderate|high|severe.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_obligation` PRIMARY KEY (`obligation_id`)
)
USING DELTA
COMMENT 'Master registry of all regulatory compliance obligations applicable to the utility, including NERC CIP standards, FERC tariff requirements, PUC service territory rules, EPA emissions limits, OSHA safety mandates, SOX internal controls, CPCN conditions, and NERC reliability standard sub-requirements. Each obligation record captures the governing body, regulatory citation, effective dates, applicability scope (generation, transmission, distribution, trading), compliance frequency, responsible organizational unit, violation risk factor (VRF), violation severity level (VSL) where applicable, and current compliance status. Serves as the SSOT for what the utility is required to do and by when, and drives audit preparation, evidence collection workflows, risk assessment prioritization, and regulatory filing schedules. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ComplianceObligation',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.obligation'
);

-- RegulatoryFiling  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`regulatory_filing` (
  `regulatory_filing_id` BIGINT NOT NULL COMMENT 'Unique identifier for the regulatory filing record. Primary key.',
  `cpcn_application_id` BIGINT COMMENT 'Foreign key linking to compliance.cpcn_application. Business justification: A regulatory filing can be part of a CPCN application proceeding. Many filings can relate to one CPCN application (1:N). The docket_number in regulatory_filing often references a CPCN docket. Adding c',
  `obligation_id` BIGINT COMMENT 'FK to compliance.obligation.obligation_id — Regulatory filings are submitted to fulfill specific compliance obligations. This link enables tracking which obligations have been satisfied by which filings.',
  `rate_case_id` BIGINT COMMENT 'Foreign key linking to compliance.rate_case. Business justification: A regulatory filing can be part of a rate case proceeding. Many filings can relate to one rate case (1:N). The docket_number in regulatory_filing often references a rate case docket. Adding rate_case_',
  `regulatory_obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Each regulatory filing fulfills a specific regulatory obligation (e.g., annual FERC Form 1, quarterly PUC financial reports). Many filings can fulfill one obligation (1:N). Adding obligation_id FK lin',
  `approval_date` DATE COMMENT 'The date on which the regulatory agency formally approved or accepted the filing, if applicable.',
  `commission_order_date` DATE COMMENT 'The date on which the regulatory commission issued its final order or decision on this filing.',
  `commission_order_number` STRING COMMENT 'The official order number issued by the regulatory commission in response to this filing (e.g., FERC Order No. 1000, PUC Order No. U-20788-A).',
  `cpcn_capital_cost_estimate` DECIMAL(18,2) COMMENT 'For CPCN applications, the estimated total capital expenditure (CAPEX) for the proposed project, expressed in USD.',
  `cpcn_environmental_review_status` STRING COMMENT 'For CPCN applications, the current status of required environmental impact assessments and regulatory reviews (e.g., NEPA, state environmental permits). Valid values: Not_Started|In_Progress|Completed|Approved|Conditional_Approval.',
  `cpcn_project_description` STRING COMMENT 'For CPCN applications, a detailed description of the proposed capital project, including scope, location, technology, and public benefit justification.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this regulatory filing record was first created in the system.',
  `docket_number` STRING COMMENT 'The official docket or case number assigned by the regulatory agency to track this proceeding or filing (e.g., FERC Docket No. ER21-1234, PUC Case No. U-20788).',
  `due_date` DATE COMMENT 'The regulatory deadline by which this filing must be submitted to remain in compliance.',
  `epa_emissions_report_type` STRING COMMENT 'For EPA emissions filings, the specific type of emissions reporting submission (e.g., annual inventory, continuous emissions monitoring system data, greenhouse gas reporting). Valid values: Annual_Emissions_Inventory|Quarterly_Emissions_Report|CEMS_Data_Submission|GHG_Reporting.',
  `filing_description` STRING COMMENT 'A detailed narrative description of the purpose, scope, and content of this regulatory filing, including key issues addressed and relief requested.',
  `filing_document_count` INT COMMENT 'The total number of supporting documents, exhibits, and attachments included in this regulatory filing submission.',
  `filing_number` STRING COMMENT 'The externally-known unique identifier assigned to this regulatory submission by the utility or regulatory body (e.g., docket number, case number, filing reference).',
  `filing_period_end_date` DATE COMMENT 'The ending date of the reporting or compliance period covered by this filing.',
  `filing_period_start_date` DATE COMMENT 'The beginning date of the reporting or compliance period covered by this filing (e.g., start of fiscal year for FERC Form 1, start of quarter for EQR).',
  `filing_status` STRING COMMENT 'Current lifecycle status of the regulatory filing, tracking its progression from preparation through final disposition. Reference-value candidates: Draft|Submitted|Under_Review|Accepted|Rejected|Withdrawn|Pending_Response.',
  `filing_submitted_to_agency` BIGINT COMMENT 'FK to compliance.regulatory_agency.regulatory_agency_id — Every regulatory filing is submitted to a specific regulatory agency. This is a fundamental FK for filtering and reporting filings by agency.',
  `filing_type` STRING COMMENT 'The category of regulatory filing, indicating the nature and purpose of the submission. Reference-value candidates: FERC_Form_1|FERC_EQR|FERC_Form_552|FERC_Market_Based_Rate|NERC_Audit_Submission|PUC_Rate_Case|PUC_Transmission_Rate_Case|CPCN_Application|IRP_Filing|EPA_Emissions_Report|RPS_Compliance_Filing|Self_Reported_Violation|FERC_Voluntary_Disclosure|EPA_Self_Disclosure|NERC_SPV|PUC_General_Rate_Case|FERC_Tariff_Filing|State_Environmental_Permit|OSHA_Incident_Report.',
  `intervenor_party_count` INT COMMENT 'For contested proceedings, the number of third-party intervenors (e.g., consumer advocates, industrial customers, competing utilities) who have formally intervened in the regulatory proceeding.',
  `irp_commission_approval_status` STRING COMMENT 'For IRP filings, the current approval status of the integrated resource plan by the regulatory commission. Valid values: Pending|Approved|Approved_with_Conditions|Rejected|Under_Review.',
  `irp_load_forecast_mwh` DECIMAL(18,2) COMMENT 'For IRP filings, the forecasted annual energy demand in megawatt-hours (MWh) at the end of the planning horizon.',
  `irp_planning_horizon_years` INT COMMENT 'For IRP filings, the number of years into the future covered by the resource planning analysis (typically 10-20 years).',
  `irp_preferred_resource_scenario` STRING COMMENT 'For IRP filings, a description of the utility\'s preferred portfolio of generation, transmission, and demand-side resources to meet future load requirements.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this regulatory filing record was last updated or modified.',
  `proposed_rate_change_percent` DECIMAL(5,2) COMMENT 'For rate case filings, the percentage increase or decrease in customer rates being proposed in this filing.',
  `public_hearing_date` DATE COMMENT 'The scheduled date of the public or evidentiary hearing for this filing, if applicable.',
  `public_hearing_scheduled_flag` BOOLEAN COMMENT 'Indicates whether a public hearing or evidentiary hearing has been scheduled by the regulatory agency for this filing (True/False).',
  `rate_case_test_year` STRING COMMENT 'For rate case filings, the historical or forecasted 12-month period used as the basis for determining revenue requirements and proposed rates.',
  `regulatory_agency` STRING COMMENT 'The governing body or regulatory authority to which this filing is submitted (e.g., FERC, NERC, EPA, State Public Utility Commission). Valid values: FERC|NERC|EPA|State_PUC|DOE|OSHA.',
  `rejection_date` DATE COMMENT 'The date on which the regulatory agency rejected the filing, if applicable.',
  `rejection_reason` STRING COMMENT 'The explanation provided by the regulatory agency for rejecting the filing, including deficiencies or non-compliance issues identified.',
  `responsible_preparer_email` STRING COMMENT 'The email address of the individual responsible for this filing, used for regulatory correspondence and internal coordination. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `responsible_preparer_name` STRING COMMENT 'The name of the individual or team responsible for preparing and submitting this regulatory filing.',
  `revenue_requirement_amount` DECIMAL(18,2) COMMENT 'For rate case filings, the total annual revenue requirement requested from ratepayers to recover costs and earn authorized return on equity (ROE). Expressed in USD.',
  `rps_compliance_year` INT COMMENT 'For RPS compliance filings, the calendar year for which renewable energy procurement and Renewable Energy Certificate (REC) retirement is being reported.',
  `rps_rec_retired_count` INT COMMENT 'For RPS compliance filings, the total number of Renewable Energy Certificates (RECs) retired to demonstrate compliance with state RPS mandates.',
  `rps_renewable_energy_mwh` DECIMAL(18,2) COMMENT 'For RPS compliance filings, the total megawatt-hours (MWh) of renewable energy procured or generated to meet RPS obligations.',
  `settlement_date` DATE COMMENT 'The date on which a settlement agreement was executed or approved by the regulatory agency, if applicable.',
  `settlement_status` STRING COMMENT 'For contested proceedings, indicates whether a settlement agreement has been reached among parties and its current approval status. Valid values: No_Settlement|Settlement_Proposed|Settlement_Approved|Settlement_Rejected.',
  `spv_discovery_date` DATE COMMENT 'For self-reported potential violations, the date on which the utility first discovered or became aware of the potential compliance violation.',
  `spv_mitigation_plan` STRING COMMENT 'For self-reported potential violations, a description of the corrective actions and mitigation measures implemented or planned to address the violation and prevent recurrence.',
  `spv_violation_description` STRING COMMENT 'For self-reported potential violations (SPVs) or voluntary disclosures, a detailed description of the compliance issue, standard violated, and circumstances of the violation.',
  `submission_date` DATE COMMENT 'The date on which the filing was officially submitted to the regulatory agency. This is the principal business event timestamp for the filing.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_regulatory_filing` PRIMARY KEY (`regulatory_filing_id`)
)
USING DELTA
COMMENT 'Transactional record of every formal submission made to a regulatory body, encompassing routine periodic filings, regulatory proceeding applications, market transaction reports, proactive self-disclosures, rate case proceedings, and long-term resource planning filings. Covers FERC Form 1, FERC EQR, FERC Form 552, FERC market-based rate tariff filings, NERC reliability standard audit submissions, PUC general and transmission rate case filings (including test year, revenue requirement, proposed rate changes, intervenor parties, procedural milestones, settlement status, and commission orders), CPCN applications for major capital projects (including project description, capital cost, environmental review, and certificate conditions), IRP filings (including planning horizon, load forecast, resource scenarios, and commission approval), EPA emissions reports, RPS compliance filings, self-reported potential violations (SPVs), FERC voluntary disclosures, and EPA self-disclosure submissions. Captures filing type, docket number, regulatory agency, submission date, filing period, filing status, responsible preparer, and filing-type-specific detail attributes. SSOT for all outbound regulatory submissions, regulatory proceeding lifecycle tracking, proactive disclosure management, rate case management, and resource planning filings. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'RegulatoryFiling',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.regulatory_filing'
);

-- ComplianceAudit  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`audit` (
  `audit_id` BIGINT NOT NULL COMMENT 'Unique identifier for the compliance audit record. Primary key for the audit entity.',
  `audit_program_id` BIGINT COMMENT 'Foreign key linking to compliance.program. Business justification: An audit is conducted within the scope of a compliance program (e.g., NERC CIP Compliance Program). Many audits can be conducted for one program (1:N). Adding program_id FK links the audit to its gove',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Compliance audits (NERC, SOX, environmental) are scoped to operational units. Cost center is the financial accountability structure for audit scope definition, finding assignment, and remediation cost',
  `obligation_id` BIGINT COMMENT 'FK to compliance.obligation.obligation_id — Audits examine compliance with specific obligations or sets of obligations. Linking audit to obligation enables obligation-level audit coverage tracking.',
  `program_id` BIGINT COMMENT 'FK to compliance.program.program_id — Audits are conducted against specific compliance programs (e.g., NERC CIP audit covers the CIP Compliance Program). Links audit scope to program structure.',
  `utility_audit_coordinator_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Audits require utility-side employee coordinator for scheduling, evidence collection, and finding remediation tracking. Replaces denormalized name/email/phone with FK for org structure visibility and',
  `actual_end_date` DATE COMMENT 'Actual date the audit concluded, recorded when field work is complete or final report is issued. May differ from scheduled end date due to scope changes or findings requiring additional investigation.',
  `actual_start_date` DATE COMMENT 'Actual date the audit commenced, recorded when audit activities begin. May differ from scheduled start date due to delays or rescheduling.',
  `audit_number` STRING COMMENT 'Externally-known unique business identifier for the audit, typically assigned by the auditing body or internal compliance system. Format varies by audit type (e.g., NERC-2024-001234, FERC-2024-5678, PUC-2024-9012). Pattern: ^[A-Z]{2,6}-[0-9]{4}-[0-9]{4,6}$.',
  `audit_scope` STRING COMMENT 'Detailed description of the audit scope including specific standards, facilities, systems, processes, or business units under examination. For NERC CIP audits, lists applicable CIP standards (e.g., CIP-002 through CIP-014). For FERC audits, describes market activities or transactions. For PUC audits, identifies service territories or customer classes.',
  `audit_status` STRING COMMENT 'Current lifecycle status of the audit. Scheduled indicates audit is planned but not started, In Progress indicates active audit activities, Field Work Complete indicates on-site work finished awaiting report, Draft Report indicates preliminary findings issued, Final Report Issued indicates official audit report delivered, Closed indicates all follow-up complete, Suspended indicates audit paused or cancelled. Reference-value candidates: Scheduled|In_Progress|Field_Work_Complete|Draft_Report|Final_Report_Issued|Closed|Suspended.',
  `audit_type` STRING COMMENT 'Classification of the audit based on regulatory framework and scope. NERC CIP covers Critical Infrastructure Protection reliability audits, FERC Market Behavior covers wholesale market conduct, PUC Service Quality covers retail service standards, SOX Internal Controls covers financial reporting controls, EPA Environmental covers emissions and environmental compliance, Internal Compliance covers self-assessments and internal audits. Valid values: NERC_CIP|FERC_Market_Behavior|PUC_Service_Quality|SOX_Internal_Controls|EPA_Environmental|Internal_Compliance.',
  `auditing_body` STRING COMMENT 'Name of the organization or regulatory entity conducting the audit. Examples include NERC Regional Entities (e.g., WECC, SERC, ReliabilityFirst), FERC Office of Enforcement, State Public Utility Commission, EPA Regional Office, Internal Audit Department, or external audit firm.',
  `auditing_body_type` STRING COMMENT 'Classification of the auditing organization. Federal Regulator includes FERC and EPA, Regional Entity includes NERC Regional Entities, State Regulator includes PUCs, Internal covers internal audit and compliance teams, External Firm covers third-party audit firms. Valid values: Federal_Regulator|Regional_Entity|State_Regulator|Internal|External_Firm.',
  `business_units_audited` STRING COMMENT 'List or description of specific business units, departments, or functional areas included in the audit scope. Examples include Generation Operations, Transmission Operations, Distribution Operations, Customer Service, IT/Cybersecurity, Finance, Environmental Compliance.',
  `closure_date` DATE COMMENT 'Date the audit was officially closed by the auditing body, indicating all findings resolved, corrective actions verified complete, and no further audit activities required.',
  `confidentiality_level` STRING COMMENT 'Classification of the audit records confidentiality and disclosure restrictions. Public indicates no restrictions, CEII (Critical Energy Infrastructure Information) indicates FERC-protected infrastructure data, Confidential indicates business-sensitive information, Privileged indicates attorney-client or work product privilege. Valid values: Public|CEII|Confidential|Privileged.',
  `corrective_action_plan_approved_date` DATE COMMENT 'Date the auditing body formally approved the utility Corrective Action Plan, authorizing implementation and establishing completion milestones.',
  `corrective_action_plan_due_date` DATE COMMENT 'Deadline date by which the utility must submit a detailed Corrective Action Plan addressing all audit findings and violations.',
  `corrective_action_plan_submitted_date` DATE COMMENT 'Actual date the utility submitted its Corrective Action Plan to the auditing body.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this audit record was first created in the compliance management system.',
  `critical_findings_count` INT COMMENT 'Number of critical or severe findings identified that pose significant risk to reliability, safety, or compliance and typically require immediate corrective action.',
  `disposition` STRING COMMENT 'Overall outcome or conclusion of the audit. Compliant indicates no violations found, Non Compliant Minor indicates low-risk violations with minimal impact, Non Compliant Moderate indicates medium-risk violations requiring corrective action, Non Compliant Severe indicates high-risk violations with potential penalties or enforcement actions, Pending Review indicates audit complete but final disposition not yet determined. Valid values: Compliant|Non_Compliant_Minor|Non_Compliant_Moderate|Non_Compliant_Severe|Pending_Review.',
  `draft_report_issued_date` DATE COMMENT 'Date the preliminary or draft audit report was issued to the utility for review and comment before final report publication.',
  `facilities_audited` STRING COMMENT 'List or description of specific utility facilities, sites, or locations included in the audit scope. May include generation plants, substations, control centers, service centers, or corporate offices.',
  `final_report_issued_date` DATE COMMENT 'Date the final official audit report was issued by the auditing body, incorporating utility responses and auditor conclusions.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this audit record was most recently updated in the compliance management system.',
  `lead_auditor_email` STRING COMMENT 'Primary email address of the lead auditor for official audit correspondence and evidence submission. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `lead_auditor_name` STRING COMMENT 'Full name of the lead auditor from the auditing body responsible for directing the audit, coordinating the audit team, and signing the final audit report.',
  `lead_auditor_phone` STRING COMMENT 'Primary contact phone number for the lead auditor.',
  `methodology` STRING COMMENT 'Primary methodology used to conduct the audit. On Site indicates auditors physically present at utility facilities, Remote indicates audit conducted via electronic document review and virtual meetings, Hybrid indicates combination of on-site and remote, Document Review indicates desk audit of submitted evidence, Spot Check indicates targeted sampling audit. Valid values: On_Site|Remote|Hybrid|Document_Review|Spot_Check.',
  `notes` STRING COMMENT 'Free-form text field for additional audit context, special circumstances, auditor observations, or internal comments not captured in structured fields.',
  `penalty_amount` DECIMAL(15,2) COMMENT 'Total monetary penalty assessed by the regulatory body for violations identified during the audit, expressed in US dollars. Zero if no penalty assessed.',
  `penalty_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the penalty amount. Typically USD for US-based utilities. Valid values: USD.',
  `period_end_date` DATE COMMENT 'Ending date of the time period under audit review. Represents the latest date for which records, transactions, and compliance evidence will be examined.',
  `period_start_date` DATE COMMENT 'Beginning date of the time period under audit review. Represents the earliest date for which records, transactions, and compliance evidence will be examined.',
  `priority` STRING COMMENT 'Priority level assigned to the audit based on risk assessment, regulatory mandate, or business criticality. Critical indicates highest priority requiring immediate attention, High indicates significant priority, Medium indicates standard priority, Low indicates routine or lower-risk audit. Valid values: Critical|High|Medium|Low.',
  `scheduled_end_date` DATE COMMENT 'Planned date for the audit to conclude, typically the expected date for completion of field work or final report issuance.',
  `scheduled_start_date` DATE COMMENT 'Planned date for the audit to commence, typically the date of initial kickoff meeting or first day of on-site field work.',
  `total_findings_count` INT COMMENT 'Total number of audit findings, observations, or violations identified during the audit across all severity levels.',
  `trigger` STRING COMMENT 'Event or circumstance that initiated the audit. Scheduled Routine indicates planned periodic audit per compliance calendar, Risk Based indicates audit triggered by risk assessment, Incident Driven indicates audit following a reliability event or outage, Complaint Driven indicates audit initiated by customer or stakeholder complaint, Follow Up indicates audit to verify prior corrective actions, Self Report indicates audit following utility self-reported violation. Valid values: Scheduled_Routine|Risk_Based|Incident_Driven|Complaint_Driven|Follow_Up|Self_Report.',
  `utility_response_due_date` DATE COMMENT 'Deadline date by which the utility must submit formal written response to draft audit findings, including mitigation plans and corrective actions.',
  `utility_response_submitted_date` DATE COMMENT 'Actual date the utility submitted its formal written response to audit findings.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_audit` PRIMARY KEY (`audit_id`)
)
USING DELTA
COMMENT 'Master record for each compliance audit conducted or received, covering NERC CIP reliability audits, FERC market behavior audits, PUC service quality audits, internal SOX control audits, and EPA environmental inspections. Captures audit type, auditing body, audit scope, audit period, lead auditor, utility audit coordinator, scheduled and actual dates, and overall audit disposition. Parent entity for all audit findings and evidence submissions. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ComplianceAudit',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.audit'
);

-- AuditFinding  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`audit_finding` (
  `audit_finding_id` BIGINT NOT NULL COMMENT 'Unique identifier for the audit finding record. Primary key for the audit finding entity.',
  `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Billing accuracy audits, meter-to-cash process audits, and revenue assurance findings reference specific customer accounts. Required for audit evidence trails and corrective billing adjustments per re',
  `audit_obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: An audit finding represents a violation of a specific regulatory obligation. Many findings can relate to one obligation (1:N). Adding obligation_id FK links the finding to the specific obligation viol',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Audit findings are assigned to responsible organizational units for remediation. Cost center provides financial accountability for remediation expenses, enables budget impact analysis, and supports ma',
  `obligation_id` BIGINT COMMENT 'FK to compliance.obligation.obligation_id — Each finding references the specific obligation or standard that was violated. Essential for obligation-level compliance posture reporting and for mapping findings back to the obligation registry.',
  `premise_id` BIGINT COMMENT 'Foreign key linking to customer.premise. Business justification: Service quality audits (voltage compliance, outage duration, safety inspections) and interconnection compliance findings reference specific premises. Essential for tracking site-specific violations an',
  `primary_audit_id` BIGINT COMMENT 'Reference to the parent audit engagement or assessment that originated this finding. Null if the finding was discovered through internal monitoring, self-assessment, or employee report rather than a formal audit.',
  `responsible_party_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Audit findings require employee accountability for remediation execution. Replaces text field with FK to enable finding workload tracking, escalation management, and performance assessment for complia',
  `actual_penalty_amount` DECIMAL(15,2) COMMENT 'The final financial penalty amount in USD imposed by the regulatory body for this finding. Null until penalty is assessed and finalized. Confidential for financial reporting.',
  `affected_assets` STRING COMMENT 'List or description of the specific assets, systems, facilities, or infrastructure components affected by or involved in the finding. Examples: BES Cyber Systems, substations, generation units, customer meters, financial systems. Supports asset-level compliance tracking.',
  `affected_customers_count` INT COMMENT 'The number of customers impacted by the finding, if applicable. Relevant for service quality findings, billing errors, or outage-related compliance issues. Null if finding does not directly impact customers.',
  `auditor_name` STRING COMMENT 'Name of the external auditor, regulatory inspector, or internal audit team member who identified the finding. Null if finding was discovered through self-monitoring or employee report. Confidential for internal use.',
  `business_unit` STRING COMMENT 'The business unit, department, or operational division responsible for the process or control that failed, and accountable for remediation. Examples: Transmission Operations, Distribution Engineering, Customer Service, Finance, IT Security.',
  `closed_by` STRING COMMENT 'Name or identifier of the individual who formally closed the finding after verification. Typically a compliance officer or audit manager. Confidential for internal use.',
  `closed_date` DATE COMMENT 'The date on which the finding was formally closed after successful remediation and verification. Null until finding is closed.',
  `closure_notes` STRING COMMENT 'Final notes or comments documenting the closure of the finding, including verification results, lessons learned, and any residual risks or follow-up actions. Used for knowledge management and continuous improvement.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this finding record was first created in the compliance management system. Audit trail field for record lifecycle tracking.',
  `discovery_date` DATE COMMENT 'The date on which the compliance deficiency, exception, gap, or near-miss was first identified or observed. This is the principal business event timestamp for the finding.',
  `discovery_method` STRING COMMENT 'The channel or mechanism through which the finding was identified. Distinguishes between externally-originated findings (NERC audits, FERC inspections) and internally-discovered exceptions (self-assessments, control testing, proactive monitoring). Reference-value candidates: external_audit|internal_audit|self_monitoring|control_testing|employee_report|operational_review|regulatory_inspection|third_party_assessment.',
  `escalation_status` STRING COMMENT 'Indicates whether and to whom the finding has been escalated. Tracks escalation to senior management, Board of Directors, or external regulators. Self-reported status indicates proactive disclosure to regulatory body per NERC self-reporting requirements. Valid values: not_escalated|escalated_to_management|escalated_to_board|escalated_to_regulator|self_reported.',
  `evidence_location` STRING COMMENT 'File path, document repository location, or system reference where supporting evidence and documentation for this finding is stored. Used for audit trail and regulatory response preparation. Confidential for internal use.',
  `finding_description` STRING COMMENT 'Detailed narrative description of the compliance deficiency, exception, gap, or near-miss. Includes what was observed, what requirement was not met, and the specific circumstances of the finding. Used for audit documentation and regulatory correspondence.',
  `finding_reference_number` STRING COMMENT 'Business-facing unique reference number or tracking code assigned to this finding for external reporting and correspondence. Format varies by regulatory body (e.g., NERC PV-2024-001234, FERC-AUDIT-2024-XYZ-F01).',
  `finding_status` STRING COMMENT 'Current lifecycle status of the finding in the remediation workflow. Tracks progression from discovery through closure. Valid values: open|under_review|remediation_in_progress|pending_verification|closed|escalated.',
  `finding_type` STRING COMMENT 'Classification of the finding based on its nature and confirmation status. Potential violations (PVs) are unconfirmed pending investigation; confirmed violations have been substantiated; control deficiencies relate to SOX or internal controls; near-misses are proactive identifications before harm occurred. Reference-value candidates: potential_violation|confirmed_violation|control_deficiency|process_gap|documentation_deficiency|near_miss|repeat_finding.',
  `impact_assessment` STRING COMMENT 'Narrative assessment of the actual or potential impact of the finding on grid reliability, customer service, financial reporting, environmental compliance, or other business objectives. Used for risk prioritization and Board reporting.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this finding record was last updated or modified. Audit trail field for change tracking and data lineage.',
  `penalty_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for penalty amounts. Defaulted to USD for US-based energy utilities. Valid values: USD.',
  `potential_penalty_amount` DECIMAL(15,2) COMMENT 'Estimated or assessed financial penalty amount in USD that may be imposed by the regulatory body for this finding. Based on NERC penalty guidelines, FERC enforcement precedent, or PUC fine schedules. Confidential for internal risk assessment.',
  `previous_finding_reference` STRING COMMENT 'Reference number or identifier of the previous finding that this finding repeats or relates to. Null if not a repeat finding.',
  `remediation_completion_date` DATE COMMENT 'The actual date on which all corrective actions were completed and the finding was remediated. Null until remediation is complete.',
  `remediation_due_date` DATE COMMENT 'The target or mandated date by which the finding must be fully remediated and closed. May be set by regulatory body (for audit findings) or by internal compliance team (for self-identified findings).',
  `remediation_plan` STRING COMMENT 'Detailed description of the corrective action plan to address the finding, including specific steps, milestones, resources, and controls to be implemented. Required for NERC Mitigation Plans and FERC enforcement responses.',
  `remediation_status` STRING COMMENT 'Current status of the remediation effort. Tracks progress of corrective actions from planning through verification and closure. Valid values: not_started|in_progress|completed|verified|overdue.',
  `repeat_finding_flag` BOOLEAN COMMENT 'Boolean indicator of whether this finding is a repeat or recurrence of a previously identified and closed finding for the same or similar deficiency. Repeat findings carry higher regulatory scrutiny and potential penalties.',
  `risk_severity` STRING COMMENT 'Internal enterprise risk assessment of the finding based on likelihood and impact to business operations, financial performance, or regulatory standing. Distinct from regulatory severity classification; used for internal prioritization and resource allocation. Valid values: critical|high|medium|low.',
  `root_cause_analysis` STRING COMMENT 'Detailed root cause analysis narrative explaining why the finding occurred, including contributing factors, systemic issues, and causal chain. Required for NERC self-reports and FERC enforcement responses.',
  `root_cause_category` STRING COMMENT 'High-level categorization of the underlying root cause of the finding. Used for trend analysis and systemic issue identification across the compliance program. Reference-value candidates: process_failure|human_error|system_failure|inadequate_training|resource_constraint|design_flaw|communication_breakdown|third_party_failure|policy_gap|other.',
  `self_report_date` DATE COMMENT 'The date on which the finding was self-reported to the regulatory body. Null if not yet reported or if self-report is not required.',
  `self_report_reference_number` STRING COMMENT 'The reference number or tracking identifier assigned by the regulatory body upon receipt of the self-report. Used for correspondence and enforcement tracking.',
  `self_report_required_flag` BOOLEAN COMMENT 'Boolean indicator of whether this finding meets the criteria for mandatory self-reporting to the regulatory body (e.g., NERC self-report for potential CIP violations, FERC notification for market rule violations). True if self-report is required or recommended.',
  `severity_classification` STRING COMMENT 'Regulatory or internal severity rating of the finding based on potential impact to grid reliability, customer service, financial reporting integrity, or environmental compliance. Aligns with NERC Violation Severity Levels (VSL) for CIP findings and internal risk rating frameworks for other findings. Valid values: critical|high|moderate|low|minimal.',
  `verification_date` DATE COMMENT 'The date on which the remediation was independently verified and validated as effective by internal audit, compliance team, or external auditor. Required before finding can be closed.',
  `verified_by` STRING COMMENT 'Name or identifier of the individual or team that performed the verification and validation of remediation effectiveness. Confidential for internal use.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_audit_finding` PRIMARY KEY (`audit_finding_id`)
)
USING DELTA
COMMENT 'Individual compliance deficiency, exception, gap, or near-miss record identified through formal audit, internal monitoring, control testing, self-assessment, or operational review. Covers NERC CIP potential violations (PVs), FERC market rule violations, PUC service quality deficiencies, SOX control deficiencies, internally discovered compliance exceptions, and proactive near-miss identifications. Captures finding reference number, associated audit (if audit-originated), violated standard or rule citation, severity classification, discovery method (external audit, internal audit, self-monitoring, employee report, control testing), finding description, root cause category, risk severity, business unit responsible, remediation due date, and escalation status (including whether self-reporting is warranted). Serves as the single register for all compliance deficiencies regardless of discovery channel — from formal audit findings to internally identified exceptions. Drives the enforcement and corrective action workflow, and feeds the self-report filing process when internal findings warrant proactive disclosure. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AuditFinding',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.audit_finding'
);

-- EnforcementAction  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`enforcement_action` (
  `enforcement_action_id` BIGINT NOT NULL COMMENT 'Unique identifier for the regulatory enforcement action record. Primary key.',
  `audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: An enforcement action may be triggered by an audit that discovered violations. Many enforcement actions can result from one audit (1:N). Adding audit_id FK links the enforcement action to the triggeri',
  `corrective_action_plan_id` BIGINT COMMENT 'Identifier of the corrective action plan or mitigation plan submitted to the regulator to address the violation and prevent recurrence.',
  `enforcement_audit_finding_id` BIGINT COMMENT 'FK to compliance.audit_finding.audit_finding_id — Enforcement actions often originate from audit findings that escalate. The enforcement_action should reference the originating finding when applicable.',
  `from_audit_finding_id` BIGINT COMMENT 'FK to compliance.audit_finding.audit_finding_id — Enforcement actions arise from audit findings or self-reported violations. Links the enforcement lifecycle to the originating deficiency. Critical for penalty tracking and Board reporting.',
  `responsible_business_unit_org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Enforcement actions are assigned to organizational units for accountability and remediation resource allocation. Replaces text field with FK to enable departmental enforcement action tracking and comp',
  `self_report_id` BIGINT COMMENT 'Foreign key linking to compliance.self_report. Business justification: An enforcement action may be initiated based on a self-reported potential violation. Many enforcement actions can result from one self-report (1:N). Adding self_report_id FK links the enforcement acti',
  `action_issue_date` DATE COMMENT 'Date on which the regulatory agency formally issued or filed the enforcement action notice or order.',
  `action_number` STRING COMMENT 'Externally-known docket, case, or reference number assigned by the regulatory agency (e.g., NERC NAV number, FERC docket number, PUC case number, EPA NOV number, OSHA citation number).',
  `action_resolution_date` DATE COMMENT 'Date on which the enforcement action was formally resolved, closed, or finalized (e.g., settlement execution date, final order date, dismissal date).',
  `action_status` STRING COMMENT 'Current lifecycle status of the enforcement action (e.g., pending, contested, settled, final, closed, appealed, dismissed). Reference-value candidates: pending|contested|settled|final|closed|appealed|dismissed.',
  `action_type` STRING COMMENT 'Classification of the enforcement action instrument issued by the regulator (e.g., NERC Notice of Alleged Violation (NAV), FERC Order to Show Cause, PUC complaint proceeding, EPA Notice of Violation (NOV), OSHA citation). Reference-value candidates: notice_of_alleged_violation|notice_of_violation|order_to_show_cause|complaint_proceeding|administrative_penalty|civil_penalty|citation|warning_letter|consent_order.',
  `alleged_violation_description` STRING COMMENT 'Detailed narrative description of the alleged violation or non-compliance that triggered the enforcement action, including specific regulatory standard or requirement violated.',
  `appeal_decision_date` DATE COMMENT 'Date on which the appellate body issued its decision on the appeal of the enforcement action.',
  `appeal_filed_flag` BOOLEAN COMMENT 'Boolean indicator of whether the utility filed a formal appeal of the enforcement action decision (True = appeal filed, False = no appeal).',
  `audit_trail_reference` STRING COMMENT 'Reference identifier to the audit trail, evidence collection, or compliance documentation supporting the enforcement action response and defense.',
  `board_notification_flag` BOOLEAN COMMENT 'Boolean indicator of whether the enforcement action was reported to the Board of Directors due to materiality or significance (True = notified, False = not notified).',
  `contested_flag` BOOLEAN COMMENT 'Boolean indicator of whether the utility is contesting or has contested the enforcement action through formal proceedings or appeal (True = contested, False = not contested).',
  `cooperation_credit_flag` BOOLEAN COMMENT 'Boolean indicator of whether the utility received penalty mitigation credit for cooperating with the regulatory investigation (True = credit received, False = no credit).',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this enforcement action record was first created in the system.',
  `enforcement_by_agency` BIGINT COMMENT 'FK to compliance.regulatory_agency.regulatory_agency_id — Enforcement actions are issued by specific regulatory agencies. This FK is essential for agency-level enforcement tracking and reporting.',
  `external_disclosure_flag` BOOLEAN COMMENT 'Boolean indicator of whether the enforcement action was disclosed in external financial reporting or regulatory filings (e.g., SEC Form 10-K, 10-Q) due to materiality (True = disclosed, False = not disclosed).',
  `final_penalty_assessed` DECIMAL(18,2) COMMENT 'Final monetary penalty amount assessed after any settlement negotiations, mitigation, or adjudication, expressed in USD.',
  `financial_exposure_classification` STRING COMMENT 'Internal classification of the financial materiality and exposure risk of the enforcement action based on penalty amount and potential impact (e.g., low, medium, high, critical). Valid values: low|medium|high|critical.',
  `issuing_agency` STRING COMMENT 'Name of the regulatory body or agency that initiated the enforcement action (e.g., NERC, FERC, State PUC, EPA, OSHA).',
  `issuing_agency_code` STRING COMMENT 'Standardized code or abbreviation for the issuing regulatory agency (e.g., NERC, FERC, EPA, OSHA, state PUC abbreviation).',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this enforcement action record was last updated or modified.',
  `mitigation_factors_applied` STRING COMMENT 'Description of mitigating factors considered by the regulator in determining the final penalty, such as compliance history, self-reporting credit, cooperation with investigation, remedial actions taken, or financial condition.',
  `payment_date` DATE COMMENT 'Actual date on which the penalty payment was remitted to the regulatory agency.',
  `payment_due_date` DATE COMMENT 'Date by which the assessed penalty payment must be remitted to the regulatory agency.',
  `payment_status` STRING COMMENT 'Current status of the penalty payment obligation (e.g., not due, pending, paid, overdue, waived, deferred). Valid values: not_due|pending|paid|overdue|waived|deferred.',
  `penalty_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for penalty amounts. Defaults to USD for US utility operations. Valid values: USD.',
  `proposed_penalty_amount` DECIMAL(18,2) COMMENT 'Initial monetary penalty amount proposed by the regulatory agency in the enforcement action notice, expressed in USD.',
  `public_disclosure_url` STRING COMMENT 'URL link to the public disclosure or posting of the enforcement action on the regulatory agencys website (e.g., NERC public enforcement actions, FERC eLibrary).',
  `record_source_system` STRING COMMENT 'Name or code of the source system from which this enforcement action record originated (e.g., Compliance Management System, Legal Case Management System).',
  `regulatory_correspondence_reference` STRING COMMENT 'Reference identifier or file path to official correspondence, letters, or filings exchanged with the regulatory agency regarding this enforcement action.',
  `responsible_facility_code` STRING COMMENT 'Code or identifier of the specific facility, plant, substation, or asset where the alleged violation occurred.',
  `self_report_credit_flag` BOOLEAN COMMENT 'Boolean indicator of whether the utility received penalty mitigation credit for self-reporting the violation to the regulator (True = credit received, False = no credit).',
  `settlement_flag` BOOLEAN COMMENT 'Boolean indicator of whether the enforcement action was resolved through a settlement agreement between the utility and the regulatory agency (True = settled, False = not settled).',
  `settlement_terms` STRING COMMENT 'Summary of key terms and conditions agreed upon in the settlement, including penalty reduction, compliance commitments, and remedial actions.',
  `violated_standard_code` STRING COMMENT 'Code or identifier of the specific regulatory standard, rule, or requirement that was allegedly violated (e.g., NERC CIP-007-6, FERC Order 888, EPA 40 CFR Part 60, OSHA 29 CFR 1910).',
  `violation_end_date` DATE COMMENT 'End date of the period during which the alleged violation occurred or non-compliance was remediated.',
  `violation_severity_level` STRING COMMENT 'Severity classification of the alleged violation as determined by the regulator (e.g., NERC Violation Severity Level: minimal, lower, moderate, high, severe). Valid values: minimal|lower|moderate|high|severe.',
  `violation_start_date` DATE COMMENT 'Start date of the period during which the alleged violation occurred or non-compliance existed.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_enforcement_action` PRIMARY KEY (`enforcement_action_id`)
)
USING DELTA
COMMENT 'Record of formal enforcement actions, associated monetary penalties, and sanctions initiated by regulators against the utility, including NERC Notice of Alleged Violation (NAV) with civil monetary penalties (CMPs), FERC Order to Show Cause with civil penalties, PUC complaint proceedings with fines, EPA Notice of Violation (NOV) with administrative penalties, and OSHA citations. Captures action type, issuing agency, docket or case number, alleged violation description, proposed penalty amount, final penalty assessed, payment due date, payment status, penalty mitigation factors applied (compliance history, self-reporting credit, cooperation), contested flag, settlement terms, action resolution date, and financial exposure classification. Serves as SSOT for all regulatory enforcement posture, penalty assessment and tracking, financial exposure reporting to the Board and external auditors, and penalty payment reconciliation. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'EnforcementAction',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.enforcement_action'
);

-- CorrectiveActionPlan  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`corrective_action_plan` (
  `corrective_action_plan_id` BIGINT NOT NULL COMMENT 'Unique identifier for the corrective action plan. Primary key.',
  `audit_finding_id` BIGINT COMMENT 'FK to compliance.audit_finding.audit_finding_id — Corrective action plans are created in response to audit findings. The CAP must reference the specific finding it remediates. This is the core remediation workflow link.',
  `capex_project_id` BIGINT COMMENT 'Foreign key linking to finance.capex_project. Business justification: Some CAPs require capital investment (equipment replacement, system upgrades, facility modifications). Linking to capex_project enables tracking capital remediation costs, ensures proper capitalizatio',
  `corrective_audit_finding_id` BIGINT COMMENT 'Reference to the audit finding, enforcement action, or self-identified compliance gap that triggered this corrective action plan.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: CAPs require budget allocation for remediation work (labor, materials, contractors). Cost center link enables expense tracking, budget vs. actual variance analysis, and ensures remediation costs are p',
  `responsible_department_org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: CAPs are assigned to organizational units for resource allocation and budget tracking. Replaces text field with FK to enable departmental compliance workload analysis and cost center allocation.',
  `responsible_owner_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: CAPs require accountable employee ownership for remediation execution. Replaces text field with FK to enable escalation paths, workload balancing, and performance tracking for compliance remediation r',
  `violation_id` BIGINT COMMENT 'Reference to the specific violation record if this CAP addresses a confirmed violation of regulatory standards.',
  `actual_completion_date` DATE COMMENT 'The actual date on which all corrective actions were completed and verified.',
  `actual_cost` DECIMAL(15,2) COMMENT 'Actual total cost in USD incurred to implement the corrective action plan, tracked for financial reporting and cost recovery analysis.',
  `actual_start_date` DATE COMMENT 'The actual date on which implementation of the corrective action plan commenced.',
  `approval_date` DATE COMMENT 'The date on which the regulatory body formally approved the corrective action plan.',
  `board_reporting_flag` BOOLEAN COMMENT 'Indicates whether this corrective action plan is included in Board-level compliance posture reporting due to its materiality or risk level.',
  `cap_number` STRING COMMENT 'Business identifier for the corrective action plan, typically formatted as CAP-YYYY-NNNN or similar convention used in regulatory correspondence.',
  `cap_status` STRING COMMENT 'Current lifecycle status of the corrective action plan indicating its stage in the remediation workflow. Reference-value candidates: Draft|Submitted|Under.',
  `cap_title` STRING COMMENT 'Short descriptive title of the corrective action plan summarizing the remediation focus.',
  `closure_date` DATE COMMENT 'The date on which the corrective action plan was formally closed after verification of completion and acceptance by the regulatory body.',
  `completion_percentage` DECIMAL(5,2) COMMENT 'Percentage of corrective action plan milestones and tasks completed, used for progress tracking and Board reporting.',
  `corrective_measures` STRING COMMENT 'Comprehensive description of the corrective actions, process changes, system enhancements, training programs, or policy updates committed to remediate the finding.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this corrective action plan record was first created in the system.',
  `estimated_cost` DECIMAL(15,2) COMMENT 'Estimated total cost in USD to implement the corrective action plan, including labor, materials, consulting, and system enhancements.',
  `evidence_of_completion` STRING COMMENT 'Description or reference to documentation, test results, audit reports, training records, or other evidence demonstrating successful completion of corrective actions.',
  `implementation_status` STRING COMMENT 'Current implementation progress status indicating whether the corrective action plan is on schedule, at risk, or delayed. Reference-value candidates: Not.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this corrective action plan record was last modified, used for audit trail and change tracking.',
  `milestone_schedule` STRING COMMENT 'Structured schedule of key milestones, deliverables, and interim checkpoints with target dates for tracking progress of the corrective action plan.',
  `notes` STRING COMMENT 'Additional notes, comments, or context regarding the corrective action plan, including challenges, dependencies, or lessons learned.',
  `planned_completion_date` DATE COMMENT 'The target date by which all corrective actions are committed to be completed, as communicated to the regulatory body.',
  `planned_start_date` DATE COMMENT 'The date on which implementation of the corrective action plan is scheduled to begin.',
  `preventive_measures` STRING COMMENT 'Description of preventive measures implemented to ensure the compliance gap does not recur, including process controls, monitoring mechanisms, and governance enhancements.',
  `recurrence_flag` BOOLEAN COMMENT 'Indicates whether this corrective action plan addresses a recurring compliance issue that has been identified in previous audits or findings.',
  `regulatory_body` STRING COMMENT 'The regulatory authority to whom this corrective action plan is submitted or reported (NERC, FERC, PUC, EPA, etc.). Reference-value candidates: NERC|FERC|PUC|EPA|DOE|OSHA|State.',
  `regulatory_correspondence_reference` STRING COMMENT 'Reference number or identifier for regulatory correspondence, letters, or notices related to this corrective action plan.',
  `regulatory_standard` STRING COMMENT 'The specific regulatory standard, rule, or requirement that was violated or at risk (e.g., NERC CIP-007-6, FERC Order 2222, EPA Clean Air Act Section 111).',
  `root_cause_analysis` STRING COMMENT 'Detailed narrative describing the root cause analysis performed to identify the underlying factors that led to the compliance gap or violation.',
  `self_reported_flag` BOOLEAN COMMENT 'Indicates whether the compliance gap was self-identified and self-reported by the utility (True) or discovered through external audit or enforcement action (False).',
  `severity_level` STRING COMMENT 'Severity classification of the underlying finding or violation that this CAP addresses, reflecting risk to grid reliability, safety, or compliance posture. Valid values: Critical|High|Medium|Low.',
  `submission_date` DATE COMMENT 'The date on which the corrective action plan was formally submitted to the regulatory body for review and approval.',
  `updated_by` STRING COMMENT 'The user ID or name of the individual who last updated this corrective action plan record.',
  `verification_date` DATE COMMENT 'The date on which completion of the corrective action plan was independently verified.',
  `verification_method` STRING COMMENT 'The method used to verify completion of corrective actions (e.g., internal audit, third-party assessment, regulatory inspection, system testing).',
  `verified_by` STRING COMMENT 'Name or title of the individual or team that performed the verification of corrective action plan completion.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_corrective_action_plan` PRIMARY KEY (`corrective_action_plan_id`)
)
USING DELTA
COMMENT 'Formal corrective action plan (CAP) developed in response to an audit finding, enforcement action, or self-identified compliance gap. Captures the associated finding or violation, root cause analysis narrative, corrective measures committed, milestone schedule, responsible owner, implementation status, and evidence of completion. Used to demonstrate remediation to NERC, FERC, PUC, and EPA. Tracks open CAPs for Board compliance posture reporting. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CorrectiveActionPlan',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.corrective_action_plan'
);

-- EvidenceRecord  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`evidence_record` (
  `evidence_record_id` BIGINT NOT NULL COMMENT 'Unique identifier for the compliance evidence record. Primary key.',
  `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Billing accuracy compliance evidence (rate application, tariff compliance, credit/collections practices) references specific customer accounts. Required for PUC audits and customer complaint investiga',
  `corrective_action_plan_id` BIGINT COMMENT 'Foreign key linking to compliance.corrective_action_plan. Business justification: Evidence records are collected to support corrective action plan closure and demonstrate remediation. Many evidence records can support one CAP (1:N). Adding corrective_action_plan_id FK links evidenc',
  `evidence_audit_finding_id` BIGINT COMMENT 'Reference to the audit finding or corrective action plan (CAP) item that this evidence addresses. Nullable if evidence is collected proactively rather than in response to a finding.',
  `evidence_obligation_id` BIGINT COMMENT 'FK to compliance.obligation.obligation_id — Evidence records are collected to demonstrate compliance with specific obligations. The FK to obligation is essential for mapping evidence to what it proves.',
  `evidence_regulatory_obligation_id` BIGINT COMMENT 'Reference to the specific regulatory obligation or requirement that this evidence supports.',
  `premise_id` BIGINT COMMENT 'Foreign key linking to customer.premise. Business justification: Service quality compliance evidence (meter test records, voltage monitoring data, interconnection inspections) references specific premises. Essential for demonstrating compliance with service standar',
  `primary_audit_finding_id` BIGINT COMMENT 'FK to compliance.audit_finding.audit_finding_id — Evidence records are also collected in response to specific audit findings. This FK supports audit defense by linking evidence to the finding it addresses.',
  `primary_evidence_custodian_employee_id` BIGINT COMMENT 'Reference to the employee or organizational role responsible for maintaining custody and integrity of the evidence artifact.',
  `primary_obligation_id` BIGINT COMMENT 'FK to compliance.obligation.obligation_id — Evidence artifacts are collected to demonstrate compliance with specific obligations. This link is essential for audit preparation and compliance posture reporting.',
  `quaternary_evidence_last_modified_by_employee_id` BIGINT COMMENT 'Reference to the employee who last updated or modified this evidence record in the compliance management system.',
  `tertiary_evidence_created_by_employee_id` BIGINT COMMENT 'Reference to the employee who created this evidence record in the compliance management system.',
  `access_restriction_notes` STRING COMMENT 'Free-text notes describing any special access restrictions, handling instructions, or security considerations for the evidence artifact.',
  `cap_closure_date` DATE COMMENT 'The date on which the corrective action plan (CAP) item or audit finding was formally closed based on this evidence. Nullable if CAP is not yet closed.',
  `cap_closure_flag` BOOLEAN COMMENT 'Boolean indicator of whether this evidence artifact was accepted as sufficient to close a corrective action plan (CAP) item or audit finding.',
  `chain_of_custody_status` STRING COMMENT 'Current status of the chain-of-custody for the evidence artifact. Indicates whether the evidence has maintained integrity and proper handling throughout its lifecycle. Valid values: intact|transferred|compromised|under_review.',
  `collection_date` DATE COMMENT 'The date on which the evidence artifact was collected, captured, or generated by the source system or custodian.',
  `compliance_standard_reference` STRING COMMENT 'Specific citation or reference to the compliance standard, regulation section, or control requirement that this evidence supports (e.g., NERC CIP-005-6 R1, SOX 404, EPA 40 CFR Part 75).',
  `confidentiality_classification` STRING COMMENT 'Data classification level of the evidence artifact indicating handling and access control requirements. Valid values: public|internal|confidential|restricted.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this evidence record was first created in the compliance management system.',
  `custodian_department` STRING COMMENT 'The organizational department or business unit of the custodian responsible for the evidence artifact.',
  `custodian_name` STRING COMMENT 'The full name of the custodian responsible for the evidence artifact. Maintained for audit trail and chain-of-custody purposes.',
  `digital_hash` STRING COMMENT 'Cryptographic hash (e.g., SHA-256) of the digital evidence artifact to ensure integrity verification and detect tampering. Critical for audit defense and regulatory examination.',
  `evidence_description` STRING COMMENT 'Detailed narrative description of the evidence artifact, including what it demonstrates, the context in which it was collected, and its relevance to the compliance obligation or audit finding.',
  `evidence_period_end_date` DATE COMMENT 'The ending date of the time period that this evidence artifact covers or represents. Nullable for ongoing or open-ended evidence.',
  `evidence_period_start_date` DATE COMMENT 'The beginning date of the time period that this evidence artifact covers or represents. For example, the start date of a log file or the effective date of a training certificate.',
  `evidence_status` STRING COMMENT 'Current lifecycle status of the evidence artifact in the compliance management process. Tracks progression from collection through validation to archival. Valid values: collected|under_review|validated|rejected|archived.',
  `evidence_title` STRING COMMENT 'Descriptive title or name of the evidence artifact for quick identification and cataloging.',
  `evidence_type` STRING COMMENT 'Classification of the evidence artifact by its nature and purpose. Examples include NERC CIP access control logs, protection system maintenance records, operator training certificates, FERC market transaction records, EPA stack test results, and SOX control test documentation. Valid values: access_control_log|maintenance_record|training_certificate|transaction_log|stack_test_result|control_test_documentation.',
  `file_format` STRING COMMENT 'The file format or media type of the evidence artifact (e.g., PDF, XLSX, CSV, DOCX, TXT, XML, JSON). Reference-value candidates: PDF|XLSX|CSV|DOCX|TXT|XML|JSON|PNG|JPEG|MP4|ZIP|MSG|EML.',
  `file_size_bytes` BIGINT COMMENT 'The size of the evidence artifact file in bytes. Used for storage management and integrity verification.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this evidence record was last updated or modified in the compliance management system.',
  `legal_hold_case_reference` STRING COMMENT 'Reference to the legal case, investigation, or matter for which the evidence artifact is being preserved under legal hold. Nullable if no legal hold is active.',
  `legal_hold_flag` BOOLEAN COMMENT 'Boolean indicator of whether the evidence artifact is subject to a legal hold or litigation preservation order, preventing destruction regardless of retention policy.',
  `regulatory_framework` STRING COMMENT 'The primary regulatory framework or governing body under which this evidence is collected and maintained (e.g., NERC CIP, FERC, EPA, SOX, PUC, OSHA). Valid values: NERC_CIP|FERC|EPA|SOX|PUC|OSHA.',
  `rejection_reason` STRING COMMENT 'Explanation of why the evidence artifact was rejected or deemed insufficient. Nullable if evidence status is not rejected.',
  `retention_expiration_date` DATE COMMENT 'The calculated date on which the evidence artifact becomes eligible for destruction or archival per retention policy.',
  `retention_period_years` INT COMMENT 'The number of years that the evidence artifact must be retained per regulatory or internal policy requirements before eligible for destruction.',
  `source_system` STRING COMMENT 'The operational system or application from which the evidence artifact was extracted or generated (e.g., SAP IS-U, OSIsoft PI, GE PowerOn ADMS, Oracle MDM).',
  `source_system_record_reference` STRING COMMENT 'The unique identifier or primary key of the evidence artifact in the source system from which it was extracted.',
  `storage_location_reference` STRING COMMENT 'Reference to the physical or digital storage location where the evidence artifact is maintained. May be a file path, document management system identifier, or physical archive location code.',
  `submission_date` DATE COMMENT 'The date on which the evidence artifact was formally submitted to auditors, regulators, or compliance management for review. Nullable if not yet submitted.',
  `submission_reference_number` STRING COMMENT 'The tracking or reference number assigned by the receiving organization or regulatory body upon submission of the evidence artifact.',
  `submitted_to_organization` STRING COMMENT 'The name of the external organization or regulatory body to which the evidence artifact was submitted (e.g., NERC, FERC, EPA, State PUC, external auditor firm).',
  `validation_date` DATE COMMENT 'The date on which the evidence artifact was reviewed and validated by compliance personnel or auditors as meeting the required standard.',
  `validation_notes` STRING COMMENT 'Free-text notes or comments recorded by the validator regarding the quality, completeness, or relevance of the evidence artifact.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_evidence_record` PRIMARY KEY (`evidence_record_id`)
)
USING DELTA
COMMENT 'Repository of compliance evidence artifacts collected to demonstrate adherence to regulatory obligations and to address audit findings, including NERC CIP access control logs, protection system maintenance records, operator training certificates, FERC market transaction records, EPA stack test results, SOX control test documentation, and corrective action completion evidence. Captures evidence type, associated obligation or audit finding, collection date, evidence period covered, storage location reference, digital hash for integrity verification, custodian, and chain-of-custody status. Supports audit defense, regulatory examination, and CAP closure verification. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'EvidenceRecord',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.evidence_record'
);

-- RegulatoryCorrespondence  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`regulatory_correspondence` (
  `regulatory_correspondence_id` BIGINT NOT NULL COMMENT 'Unique identifier for each regulatory correspondence record. Primary key for the regulatory correspondence entity.',
  `audit_id` BIGINT COMMENT 'Foreign key reference to a related regulatory audit or inspection record if the correspondence is part of an audit process.',
  `cpcn_application_id` BIGINT COMMENT 'Foreign key linking to compliance.cpcn_application. Business justification: Regulatory correspondence can be part of a CPCN application proceeding (e.g., commission orders, public comments, environmental review correspondence). Many correspondence records can relate to one CP',
  `enforcement_action_id` BIGINT COMMENT 'Foreign key linking to compliance.enforcement_action. Business justification: Regulatory correspondence can relate to an enforcement action (e.g., notice of violation, penalty assessment letter). Many correspondence records can relate to one enforcement action (1:N). Adding enf',
  `primary_related_filing_regulatory_filing_id` BIGINT COMMENT 'Foreign key reference to a related regulatory filing or submission if the correspondence is associated with a formal filing.',
  `rate_case_id` BIGINT COMMENT 'Foreign key linking to compliance.rate_case. Business justification: Regulatory correspondence can be part of a rate case proceeding (e.g., data requests, testimony, commission orders). Many correspondence records can relate to one rate case (1:N). The docket_number an',
  `regulatory_filing_id` BIGINT COMMENT 'FK to compliance.regulatory_filing.regulatory_filing_id — Regulatory correspondence often references specific filings or proceedings (docket numbers). Links communication tracking to the filing lifecycle.',
  `responding_party_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Regulatory responses are prepared by specific employees with subject matter expertise. Replaces denormalized fields with FK for regulatory workload tracking, expertise mapping, and succession planning',
  `agency_contact_email` STRING COMMENT 'Email address of the regulatory agency contact person for follow-up and correspondence tracking. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `agency_contact_name` STRING COMMENT 'Name of the regulatory agency representative or contact person who sent or is the recipient of the correspondence.',
  `agency_contact_phone` STRING COMMENT 'Phone number of the regulatory agency contact person.',
  `attachment_count` INT COMMENT 'Number of attachments or supporting documents included with the correspondence.',
  `board_notification_date` DATE COMMENT 'Date the Board of Directors or executive leadership was notified of the correspondence. Format: yyyy-MM-dd.',
  `board_notification_flag` BOOLEAN COMMENT 'Indicates whether the correspondence is significant enough to require notification to the Board of Directors or executive leadership.',
  `closure_date` DATE COMMENT 'Date the correspondence matter was closed or resolved, indicating no further action is required. Format: yyyy-MM-dd.',
  `closure_notes` STRING COMMENT 'Notes documenting the resolution or closure of the correspondence matter, including any final actions taken or outcomes achieved.',
  `compliance_obligation_reference` STRING COMMENT 'Reference to the specific compliance obligation, regulatory requirement, or standard that the correspondence addresses. Examples include NERC CIP standards, FERC reporting requirements, or EPA emissions limits.',
  `confidentiality_flag` BOOLEAN COMMENT 'Indicates whether the correspondence contains confidential, proprietary, or commercially sensitive information that requires special handling or redaction before public disclosure.',
  `correspondence_category` STRING COMMENT 'Categorical classification of the correspondence type. Examples include information request, data request, interrogatory, compliance schedule letter, audit notice, enforcement action, reporting acknowledgment, or general inquiry. Reference-value candidates: information_request|data_request|interrogatory|compliance_schedule|audit_notice|enforcement_action|reporting_acknowledgment|general_inquiry|notice_of_violation|settlement_agreement.',
  `correspondence_number` STRING COMMENT 'Business identifier or reference number assigned to the correspondence by the utility or regulatory body. Used for tracking and citation in regulatory proceedings.',
  `correspondence_summary` STRING COMMENT 'Executive summary or abstract of the correspondence content for quick reference and reporting to senior management or the Board.',
  `correspondence_type` STRING COMMENT 'Indicates whether the correspondence is inbound (received from regulator) or outbound (sent to regulator). Valid values: inbound|outbound.',
  `correspondence_with_agency` BIGINT COMMENT 'FK to compliance.regulatory_agency.regulatory_agency_id — All regulatory correspondence is exchanged with a specific agency. Essential FK for correspondence management.',
  `created_by_user` STRING COMMENT 'Username or identifier of the system user who created the regulatory correspondence record.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the regulatory correspondence record was first created in the system. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `date_received` DATE COMMENT 'Date the correspondence was received by the utility (for inbound) or acknowledged by the regulator (for outbound). Format: yyyy-MM-dd.',
  `date_sent` DATE COMMENT 'Date the correspondence was sent (for outbound) or postmarked (for inbound). Format: yyyy-MM-dd.',
  `docket_number` STRING COMMENT 'Official docket number or proceeding reference assigned by the regulatory body. Used to link correspondence to specific regulatory cases, rate cases, or compliance proceedings.',
  `document_storage_location` STRING COMMENT 'File path, URL, or document management system reference where the physical or electronic correspondence document is stored.',
  `follow_up_due_date` DATE COMMENT 'Date by which follow-up action or supplemental response is due. Format: yyyy-MM-dd.',
  `follow_up_required_flag` BOOLEAN COMMENT 'Indicates whether additional follow-up action or supplemental response is required after the initial response.',
  `last_modified_by_user` STRING COMMENT 'Username or identifier of the system user who last modified the regulatory correspondence record.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the regulatory correspondence record was last updated or modified. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `legal_review_completed_date` DATE COMMENT 'Date legal review of the correspondence or response was completed. Format: yyyy-MM-dd.',
  `legal_review_required_flag` BOOLEAN COMMENT 'Indicates whether the correspondence requires review by internal or external legal counsel before response.',
  `penalty_amount` DECIMAL(18,2) COMMENT 'Monetary penalty amount assessed or proposed in the correspondence if related to an enforcement action. Expressed in USD.',
  `priority_level` STRING COMMENT 'Priority level assigned to the correspondence based on urgency, regulatory impact, and potential enforcement risk. Critical priority indicates immediate action required. Valid values: critical|high|medium|low.',
  `proceeding_name` STRING COMMENT 'Name or title of the regulatory proceeding, case, or investigation to which this correspondence relates.',
  `regulatory_agency` STRING COMMENT 'The regulatory body or agency involved in the correspondence. Includes NERC (North American Electric Reliability Corporation), FERC (Federal Energy Regulatory Commission), PUC (Public Utility Commission), EPA (Environmental Protection Agency), DOE (Department of Energy), and OSHA (Occupational Safety and Health Administration). Valid values: NERC|FERC|PUC|EPA|DOE|OSHA.',
  `responding_department` STRING COMMENT 'Name of the internal department or business unit responsible for preparing the response. Examples include Legal, Regulatory Affairs, Compliance, Environmental, Operations, or Finance.',
  `response_acknowledgment_date` DATE COMMENT 'Date the regulatory agency acknowledged receipt of the utility\'s response. Format: yyyy-MM-dd.',
  `response_due_date` DATE COMMENT 'Date by which a response is required or expected. Critical for tracking compliance with regulatory deadlines and avoiding enforcement actions. Format: yyyy-MM-dd.',
  `response_status` STRING COMMENT 'Current status of the response to the correspondence. Tracks whether a response is pending, in progress, completed, overdue, or not required. Valid values: pending|in_progress|completed|overdue|not_required.',
  `response_submitted_date` DATE COMMENT 'Date the utility\'s response was submitted to the regulatory agency. Format: yyyy-MM-dd.',
  `subject_matter` STRING COMMENT 'Brief description of the subject matter or topic of the correspondence. Includes topics such as NERC CIP (Critical Infrastructure Protection) audits, FERC data requests, PUC rate case interrogatories, EPA emissions reporting, or DOE energy data submissions.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_regulatory_correspondence` PRIMARY KEY (`regulatory_correspondence_id`)
)
USING DELTA
COMMENT 'Log of all formal written communications exchanged with regulatory bodies, including NERC information requests, FERC data requests, PUC interrogatories, EPA compliance schedule letters, and DOE reporting acknowledgments. Captures correspondence type (inbound/outbound), regulatory agency, docket or proceeding reference, subject matter, date sent or received, responding party, response due date, and response status. Ensures no regulatory communication falls through the cracks. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'RegulatoryCorrespondence',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.regulatory_correspondence'
);

-- NercCipAsset  <<CIM Asset : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`nerc_cip_asset` (
  `nerc_cip_asset_id` BIGINT NOT NULL COMMENT 'Unique identifier for the NERC CIP asset record. Primary key for the asset registry subject to NERC CIP standards.',
  `baseline_configuration_id` BIGINT COMMENT 'Reference to the CIP-010 baseline configuration record for this asset. Required for configuration change management and monitoring.',
  `bes_facility_id` BIGINT COMMENT 'Reference to the BES facility (substation, control center, generation plant) where this asset is located or to which it is logically associated.',
  `control_center_id` BIGINT COMMENT 'Reference to the control center (EMS, SCADA control room, DMS) responsible for operating or monitoring this asset.',
  `cyber_security_incident_response_plan_id` BIGINT COMMENT 'Reference to the CIP-008 Cyber Security Incident Response Plan that covers this asset.',
  `electronic_security_perimeter_id` BIGINT COMMENT 'Reference to the Electronic Security Perimeter (ESP) that logically contains this cyber asset. Required for CIP-005 compliance.',
  `nerc_obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Each NERC CIP asset is subject to specific CIP obligations (e.g., CIP-002 BES Cyber System Categorization, CIP-005 Electronic Security Perimeter). Many assets can be subject to one obligation (1:N). A',
  `obligation_id` BIGINT COMMENT 'FK to compliance.obligation.obligation_id — NERC CIP assets are subject to specific CIP standard obligations. Linking assets to obligations enables per-asset compliance tracking required by CIP-002.',
  `physical_security_perimeter_id` BIGINT COMMENT 'Reference to the Physical Security Perimeter (PSP) that physically contains this asset. Required for CIP-006 compliance.',
  `primary_nerc_registry_id` BIGINT COMMENT 'Reference to the physical or logical asset in the enterprise asset registry. Links this CIP-classified asset to the broader asset management system.',
  `recovery_plan_id` BIGINT COMMENT 'Reference to the CIP-009 Recovery Plan (disaster recovery, business continuity) that includes this asset.',
  `responsible_senior_manager_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: NERC CIP-003 requires senior manager accountability for BES Cyber Systems. Replaces text field with FK to enable delegation chain verification, CIP accountability reporting, and audit evidence collect',
  `asset_function` STRING COMMENT 'Operational function or role of the asset within the BES (e.g., real-time monitoring, automatic generation control, protective relaying, energy management).',
  `asset_identifier` STRING COMMENT 'Externally-known unique identifier or tag for the asset (e.g., serial number, asset tag, equipment ID). Used for audit and compliance tracking.',
  `asset_location` STRING COMMENT 'Physical or logical location of the asset (e.g., Substation 42, Control Center Building A, Data Center Rack 12). Organizational location data classified as confidential.',
  `asset_owner_organization` STRING COMMENT 'Business unit, division, or legal entity that owns this CIP asset. Used for accountability and audit trail.',
  `asset_type` STRING COMMENT 'Type or category of the asset (e.g., SCADA Server, EMS Workstation, Relay, RTU, Firewall, Router, Database Server).',
  `audit_trail_retention_days` INT COMMENT 'Number of days audit logs and event records for this asset must be retained per CIP-007. Typically 90 calendar days minimum.',
  `bes_cyber_system_categorization` STRING COMMENT 'Classification of the asset within the NERC CIP framework: BES Cyber System, BES Cyber Asset, Electronic Access Point (EAP), Physical Access Control System, Protected Cyber Asset, or Non-BES Cyber System. Valid values: BES Cyber System|BES Cyber Asset|Electronic Access Point|Physical Access Control System|Protected Cyber Asset|Non-BES Cyber System.',
  `cip_impact_rating` STRING COMMENT 'Impact classification per NERC CIP-002: High, Medium, or Low. Determines the rigor of CIP standards applicable to this asset. Valid values: High|Medium|Low.',
  `cip_status` STRING COMMENT 'Current lifecycle status of the asset within the CIP compliance program: In Scope (subject to CIP standards), Out of Scope, Pending Assessment, Decommissioned, or Retired. Valid values: In Scope|Out of Scope|Pending Assessment|Decommissioned|Retired.',
  `cip_version` STRING COMMENT 'Version of the NERC CIP standard applicable to this asset (e.g., CIP-002-5.1a, CIP-005-6, CIP-007-6). Tracks which version of the standard governs compliance obligations.',
  `configuration_change_management_required` BOOLEAN COMMENT 'Indicates whether this asset is subject to CIP-010 Configuration Change Management and Configuration Monitoring requirements.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this CIP asset record was first created in the registry. Used for audit trail and compliance documentation.',
  `decommission_date` DATE COMMENT 'Date the asset was decommissioned or removed from CIP scope. Used to track when CIP obligations cease.',
  `dial_up_connectivity` BOOLEAN COMMENT 'Indicates whether the asset has dial-up or modem connectivity, which requires specific CIP-005 access controls.',
  `external_connectivity` BOOLEAN COMMENT 'Indicates whether the asset has connectivity to networks outside the ESP, requiring additional CIP-005 controls.',
  `firmware_version` STRING COMMENT 'Current firmware or software version installed on the asset. Critical for CIP-007 patch management and vulnerability tracking.',
  `in_service_date` DATE COMMENT 'Date the asset was placed into operational service. Used to determine when CIP compliance obligations begin.',
  `ip_address` STRING COMMENT 'IP address assigned to the cyber asset. Required for Electronic Access Point (EAP) and ESP boundary documentation under CIP-005.',
  `last_cip_assessment_date` DATE COMMENT 'Date of the most recent CIP impact assessment or classification review for this asset, as required under CIP-002.',
  `last_patch_date` DATE COMMENT 'Date of the most recent security patch or software update applied to this asset. Required for CIP-007 patch management compliance.',
  `last_vulnerability_assessment_date` DATE COMMENT 'Date of the most recent vulnerability assessment performed on this asset, as required under CIP-007 and CIP-010.',
  `mac_address` STRING COMMENT 'MAC address of the network interface. Used for device identification and access control under CIP-005 and CIP-007.',
  `manufacturer` STRING COMMENT 'Manufacturer or vendor of the asset hardware or software (e.g., GE, Siemens, ABB, Cisco, OSIsoft).',
  `model_number` STRING COMMENT 'Model or part number of the asset. Used for vulnerability assessment and patch management under CIP-007.',
  `network_zone` STRING COMMENT 'Logical network zone or segment where the asset resides (e.g., Control Network, Corporate Network, DMZ). Used for ESP boundary definition.',
  `next_cip_assessment_due_date` DATE COMMENT 'Date by which the next CIP impact assessment or classification review must be completed. CIP-002 requires reassessment within 15 calendar months of the previous assessment.',
  `notes` STRING COMMENT 'Additional notes, comments, or context regarding the CIP classification, assessment, or compliance status of this asset.',
  `removable_media_controls_required` BOOLEAN COMMENT 'Indicates whether this asset requires CIP-011 removable media controls (USB drives, CDs, external hard drives).',
  `routable_protocol_enabled` BOOLEAN COMMENT 'Indicates whether the asset uses routable protocols (TCP/IP) that require Electronic Access Point (EAP) controls under CIP-005.',
  `transient_cyber_asset` BOOLEAN COMMENT 'Indicates whether this is a transient cyber asset (e.g., laptop, tablet, removable media) used for diagnostic testing, maintenance, or troubleshooting, subject to CIP-010 transient device controls.',
  `updated_by` STRING COMMENT 'User ID or name of the person who last updated this CIP asset record. Required for audit trail and accountability.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this CIP asset record was last modified. Required for audit trail and change tracking under CIP-010.',
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
  CONSTRAINT `pk_compliance_nerc_cip_asset` PRIMARY KEY (`nerc_cip_asset_id`)
)
USING DELTA
COMMENT 'Registry of utility assets subject to NERC CIP (Critical Infrastructure Protection) standards, including bulk electric system (BES) cyber systems, electronic access points (EAPs), electronic security perimeters (ESPs), physical security perimeters (PSPs), control centers, and high/medium/low impact BES cyber systems. Captures CIP impact classification per CIP-002, associated BES facility, cyber system categorization, responsible senior manager, applicable CIP standard versions, last assessment date, and next reassessment due date. SSOT for CIP asset inventory required under CIP-002 and drives CIP obligation applicability mapping. | CMM: CIM Asset (extension), IEC61968::Assets.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'NercCipAsset',
  'cmm.cim.class' = 'Asset',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Assets',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.nerc_cip_asset',
  'cmm.gis.location.role' = 'Asset.Location'
);

-- EmissionsReport  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`emissions_report` (
  `emissions_report_id` BIGINT NOT NULL COMMENT 'Unique identifier for the emissions compliance report. Primary key for the emissions report entity.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Emissions monitoring and reporting costs (CEMS equipment, lab analysis, reporting labor) are allocated to plant/facility cost centers. Link enables tracking compliance costs by operating unit and supp',
  `emissions_obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Each emissions report fulfills a specific regulatory obligation (e.g., EPA Title V reporting, state emissions reporting). Many reports can fulfill one obligation (1:N). Adding obligation_id FK links t',
  `environmental_permit_id` BIGINT COMMENT 'FK to compliance.environmental_permit.environmental_permit_id — Emissions reports are submitted under specific environmental permits (e.g., Title V permits). This link enables permit-level compliance tracking.',
  `generation_forecast_interval_id` BIGINT COMMENT 'Foreign key linking to forecast.generation_forecast_interval. Business justification: Emissions reports reference generation forecasts for allowance planning and compliance margin calculation. Forward-looking emissions compliance requires forecasted generation dispatch to ensure suffic',
  `obligation_id` BIGINT COMMENT 'FK to compliance.obligation.obligation_id — Emissions reports are submitted to fulfill EPA emissions reporting obligations. Links environmental reporting to the obligation registry.',
  `original_report_emissions_report_id` BIGINT COMMENT 'Reference to the original emissions report ID if this is an amended report. Null for original submissions.',
  `power_plant_id` BIGINT COMMENT 'Identifier of the generation facility (plant unit) that produced the emissions being reported.',
  `preparer_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: EPA emissions reports require certified preparer per 40 CFR Part 75. Replaces denormalized fields with FK to enable preparer certification tracking, workload management, and audit trail for regulatory',
  `allowances_held` INT COMMENT 'The number of emission allowances held by the facility for the pollutant type at the end of the reporting period, applicable to cap-and-trade programs.',
  `allowances_used` INT COMMENT 'The number of emission allowances used (surrendered) to cover emissions during the reporting period, applicable to cap-and-trade programs.',
  `amendment_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether this report is an amendment to a previously submitted report (True) or an original submission (False).',
  `amendment_reason` STRING COMMENT 'Explanation of the reason for amending the original emissions report, if applicable.',
  `applicable_emission_limit` DECIMAL(18,3) COMMENT 'The regulatory emission limit applicable to this facility and pollutant type for the reporting period, expressed in the same unit as measured emissions.',
  `authorized_representative_name` STRING COMMENT 'The name of the designated authorized representative who certifies the accuracy of the emissions report on behalf of the facility.',
  `cems_certification_status` STRING COMMENT 'The certification status of the CEMS equipment used for emissions monitoring, if applicable. Valid values: Certified|Provisional|Decertified|Not Applicable.',
  `certification_date` DATE COMMENT 'The date when the authorized representative certified the emissions report as accurate and complete.',
  `comments` STRING COMMENT 'Additional comments, notes, or explanatory information related to the emissions report.',
  `compliance_margin` DECIMAL(18,3) COMMENT 'The difference between the applicable emission limit and the measured emission quantity. Positive values indicate compliance; negative values indicate exceedance.',
  `compliance_status` STRING COMMENT 'The overall compliance status of the facility for this emissions report: Compliant (within limits), Non-Compliant (exceeded limits), Pending Review, or Conditional (compliant with conditions). Valid values: Compliant|Non-Compliant|Pending Review|Conditional.',
  `corrective_action_plan` STRING COMMENT 'Description of the corrective action plan implemented or planned to address non-compliance, if applicable.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this emissions report record was first created in the system.',
  `data_quality_indicator` STRING COMMENT 'Indicator of the quality and completeness of the emissions data: Verified (QA/QC complete), Estimated (based on calculations), Provisional (preliminary data), or Incomplete (missing data elements). Valid values: Verified|Estimated|Provisional|Incomplete.',
  `emission_rate` DECIMAL(18,6) COMMENT 'The calculated emission rate for the pollutant, typically expressed as pounds per MMBtu or tons per MWh, depending on the regulatory program.',
  `emission_unit_of_measure` STRING COMMENT 'The unit of measure for the reported emission quantity (typically tons, but may include pounds or kilograms for certain pollutants). Valid values: tons|pounds|kilograms.',
  `exceedance_reason` STRING COMMENT 'Explanation or reason code for any emission limit exceedance, if applicable. Null if no exceedance occurred.',
  `gross_generation_mwh` DECIMAL(18,3) COMMENT 'The total gross electrical generation from the plant unit during the reporting period, measured in megawatt-hours (MWh).',
  `heat_input_mmbtu` DECIMAL(18,3) COMMENT 'The total heat input to the generation unit during the reporting period, measured in million British thermal units (MMBtu).',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this emissions report record was last modified in the system.',
  `measured_emission_quantity` DECIMAL(18,3) COMMENT 'The measured quantity of emissions for the specified pollutant during the reporting period, expressed in tons.',
  `monitoring_methodology` STRING COMMENT 'The methodology used to measure emissions: CEMS (Continuous Emissions Monitoring System), PEMS (Predictive Emissions Monitoring System), Alternative monitoring, Fuel Sampling, or Mass Balance calculation. Valid values: CEMS|PEMS|Alternative|Fuel Sampling|Mass Balance.',
  `operating_hours` DECIMAL(10,2) COMMENT 'The total number of operating hours for the plant unit during the reporting period.',
  `orispl_code` STRING COMMENT 'The unique EPA-assigned ORISPL code identifying the power plant facility for regulatory reporting purposes.',
  `plant_unit_identifier` STRING COMMENT 'The specific unit identifier within the generation facility that produced the emissions (e.g., boiler number, turbine identifier).',
  `pollutant_type` STRING COMMENT 'The type of pollutant being reported: SO2 (Sulfur Dioxide), NOx (Nitrogen Oxides), CO2 (Carbon Dioxide), Mercury, PM2.5 (Particulate Matter 2.5 micrometers), or PM10 (Particulate Matter 10 micrometers). Valid values: SO2|NOx|CO2|Mercury|PM2.5|PM10.',
  `qa_qc_completion_date` DATE COMMENT 'The date when quality assurance and quality control procedures were completed for the emissions data.',
  `report_submission_date` DATE COMMENT 'The date when the emissions report was submitted to the regulatory agency (EPA or state environmental agency).',
  `reporting_period_end_date` DATE COMMENT 'The end date of the emissions reporting period covered by this report.',
  `reporting_period_start_date` DATE COMMENT 'The start date of the emissions reporting period covered by this report.',
  `submission_status` STRING COMMENT 'The current status of the emissions report submission to the regulatory agency. Valid values: Draft|Submitted|Accepted|Rejected|Under Review|Amended.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_emissions_report` PRIMARY KEY (`emissions_report_id`)
)
USING DELTA
COMMENT 'Periodic emissions compliance report submitted to the EPA and state environmental agencies, covering SO2, NOx, CO2, mercury, and particulate matter emissions from generation facilities. Captures reporting period, facility (plant unit), pollutant type, measured emission quantity (tons), applicable emission limit, compliance margin, monitoring methodology (CEMS or alternative), and submission status. Supports EPA Clean Air Act Title IV Acid Rain Program, CSAPR, and state RPS compliance. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'EmissionsReport',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.emissions_report'
);

-- EnvironmentalPermit  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`environmental_permit` (
  `environmental_permit_id` BIGINT NOT NULL COMMENT 'Primary key for environmental_permit',
  `capex_project_id` BIGINT COMMENT 'Foreign key linking to finance.capex_project. Business justification: Environmental permits authorize capital projects (generation facilities, transmission lines, substations). Permit conditions often drive project costs (emissions controls, environmental mitigation). L',
  `employee_id` BIGINT COMMENT 'Identifier of the environmental compliance officer responsible for managing this permit and ensuring ongoing compliance with permit conditions.',
  `environmental_obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Each environmental permit fulfills a specific regulatory obligation (e.g., EPA Title V air permit, NPDES water discharge permit). Many permits can fulfill one obligation (1:N). Adding obligation_id FK',
  `obligation_id` BIGINT COMMENT 'FK to compliance.obligation.obligation_id — Environmental permits create compliance obligations (permit conditions become obligations). Links permit portfolio to the obligation registry.',
  `power_plant_id` BIGINT COMMENT 'Identifier of the generation, transmission, or distribution facility covered by this environmental permit. Links permit to the physical asset location where environmental compliance is enforced.',
  `appeal_status` STRING COMMENT 'Status of any administrative or judicial appeal of permit conditions. Appeals can delay permit effectiveness or result in modified conditions. Valid values: no_appeal|appeal_pending|appeal_resolved|appeal_upheld.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this permit record was first created in the compliance management system. Used for audit trail and data lineage tracking.',
  `data_source_system` STRING COMMENT 'Name of the source system from which this permit record was ingested (e.g., SAP EHS, environmental compliance database, regulatory agency portal). Used for data lineage and reconciliation.',
  `effective_date` DATE COMMENT 'The date the environmental permit becomes legally binding and enforceable. May differ from issuance date if permit includes a delayed effective date provision.',
  `enforcement_action_flag` BOOLEAN COMMENT 'Indicates whether this permit is currently subject to an active enforcement action, consent decree, or compliance order from the regulatory agency.',
  `expiration_date` DATE COMMENT 'The date the environmental permit expires and must be renewed. Operating beyond expiration without renewal constitutes a violation subject to enforcement action and penalties.',
  `facility_epa_code` STRING COMMENT 'The unique EPA facility identification number assigned to the permitted facility. Used for all federal environmental reporting including emissions inventories and discharge monitoring reports.',
  `facility_name` STRING COMMENT 'Name of the utility facility covered by this environmental permit. Typically a power generation plant, substation, or operations center subject to environmental regulation.',
  `issuance_date` DATE COMMENT 'The date the environmental permit was officially issued by the regulatory agency. Marks the beginning of the permit term and the effective date for permit conditions.',
  `issuing_agency` STRING COMMENT 'Name of the federal, state, or local regulatory agency that issued the environmental permit. Typically EPA for federal permits or state environmental protection agency for state-delegated programs.',
  `issuing_agency_jurisdiction` STRING COMMENT 'The governmental jurisdiction level of the issuing agency. Determines the regulatory authority hierarchy and appeal process for permit conditions. Valid values: federal|state|local.',
  `last_inspection_date` DATE COMMENT 'Date of the most recent regulatory agency inspection of the permitted facility for compliance with permit conditions. Inspections may be routine or triggered by complaints or violations.',
  `last_inspection_result` STRING COMMENT 'Outcome of the most recent regulatory inspection. Major violations may result in enforcement actions, penalties, or permit modifications. Valid values: compliant|minor_violation|major_violation|not_applicable.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this permit record was last modified. Tracks changes to permit status, conditions, or administrative data for compliance audit purposes.',
  `monitoring_frequency` STRING COMMENT 'Required frequency for monitoring and reporting emissions or discharges under this permit. Determines compliance testing schedule and data submission deadlines to regulatory agencies. Valid values: continuous|daily|weekly|monthly|quarterly|annual.',
  `notes` STRING COMMENT 'Free-text field for additional notes, special circumstances, or historical context related to this permit. Used for internal compliance management and knowledge transfer.',
  `permit_conditions_summary` STRING COMMENT 'High-level summary of key permit conditions, operational restrictions, and compliance obligations. Detailed conditions are maintained in permit documentation repository.',
  `permit_document_url` STRING COMMENT 'URL or file path to the official permit document in the document management system. Provides access to full permit text, conditions, and attachments.',
  `permit_fee_amount` DECIMAL(18,2) COMMENT 'Annual or one-time fee paid to the regulatory agency for permit issuance, renewal, or maintenance. Fee structure varies by permit type and jurisdiction.',
  `permit_fee_currency` STRING COMMENT 'Currency code for permit fees. Typically USD for US-based utility operations. Valid values: USD.',
  `permit_number` STRING COMMENT 'The official permit number issued by the regulatory agency. This is the externally-known unique identifier used in all regulatory correspondence and compliance reporting.',
  `permit_status` STRING COMMENT 'Current lifecycle status of the environmental permit. Active permits authorize operations; expired or suspended permits require immediate remediation to avoid enforcement action. Valid values: active|expired|pending_renewal|suspended|revoked|under_review.',
  `permit_type` STRING COMMENT 'Classification of the environmental permit based on the regulatory program and environmental media regulated. Determines applicable compliance requirements and reporting obligations. Valid values: title_v_air|npdes_water_discharge|rcra_hazardous_waste|state_air_quality|state_water_quality|stormwater.',
  `permitted_discharge_limit_gallons_per_day` DECIMAL(18,4) COMMENT 'Maximum allowable daily water discharge volume in gallons per day under NPDES or state water discharge permit. Applies to cooling water, process water, and stormwater discharges.',
  `permitted_emission_limit_tons_per_year` DECIMAL(18,4) COMMENT 'Maximum allowable annual emissions in tons per year for regulated air pollutants under this permit. Exceeding this limit constitutes a permit violation and triggers enforcement action.',
  `public_comment_period_end_date` DATE COMMENT 'Date the public comment period closed for this permit. After this date, the permit becomes final unless appealed.',
  `public_notice_flag` BOOLEAN COMMENT 'Indicates whether this permit was subject to public notice and comment period as required for major permits under EPA regulations. Public participation is required for Title V and major NPDES permits.',
  `regulated_pollutants` STRING COMMENT 'Comma-separated list of specific pollutants regulated under this permit (e.g., SO2, NOx, PM2.5, mercury, lead, benzene). Each pollutant may have individual emission or discharge limits and monitoring requirements.',
  `renewal_application_date` DATE COMMENT 'The date the permit renewal application was submitted to the regulatory agency. Must typically be submitted 6-18 months before expiration depending on permit type and jurisdiction.',
  `renewal_status` STRING COMMENT 'Current status of the permit renewal process. Tracks whether renewal application has been submitted and the agencys decision status. Critical for avoiding permit lapses. Valid values: not_required|renewal_pending|renewal_submitted|renewal_approved|renewal_denied.',
  `reporting_frequency` STRING COMMENT 'Required frequency for submitting compliance reports to the regulatory agency. Missed reporting deadlines can result in notices of violation and penalties. Valid values: monthly|quarterly|semi_annual|annual.',
  `responsible_party_email` STRING COMMENT 'Email address of the responsible official for regulatory correspondence and compliance notifications related to this permit. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `responsible_party_name` STRING COMMENT 'Name of the individual or role designated as the responsible official for this permit as reported to the regulatory agency. This person certifies compliance reports and permit applications.',
  `responsible_party_phone` STRING COMMENT 'Phone number of the responsible official for urgent regulatory communications and compliance inquiries.',
  `responsible_party_title` STRING COMMENT 'Job title of the responsible official for this permit. Typically a senior operations or environmental manager with authority to certify compliance.',
  `special_conditions_flag` BOOLEAN COMMENT 'Indicates whether this permit includes special or non-standard conditions beyond typical permit requirements. Special conditions often require enhanced monitoring or operational controls.',
  `violation_count` INT COMMENT 'Total number of documented violations of this permit since issuance. High violation counts may trigger enhanced oversight or permit revocation proceedings.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_environmental_permit` PRIMARY KEY (`environmental_permit_id`)
)
USING DELTA
COMMENT 'Master record for all environmental operating permits held by the utility, including EPA Title V air permits, NPDES water discharge permits, RCRA hazardous waste permits, and state-issued environmental authorizations. Captures permit number, issuing agency, permitted facility, permit type, issuance date, expiration date, renewal status, permitted emission or discharge limits, and permit conditions. SSOT for environmental permit portfolio management. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'EnvironmentalPermit',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.environmental_permit'
);

-- ComplianceRecCertificate  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`compliance_rec_certificate` (
  `compliance_rec_certificate_id` BIGINT NOT NULL COMMENT 'Unique identifier for the REC certificate record. Primary key for the compliance REC certificate entity.',
  `attestation_document_id` BIGINT COMMENT 'Identifier of the attestation or verification document supporting this REC issuance. Used for audit trail and compliance verification purposes.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: REC certificates fulfill renewable portfolio standard (RPS) obligations. Many RECs can fulfill one obligation (1:N). Adding obligation_id FK links the REC to the RPS obligation it satisfies. The rps_j',
  `ppa_contract_id` BIGINT COMMENT 'Identifier of the Power Purchase Agreement (PPA) or REC purchase contract under which this REC was acquired. Links to contract management system for terms and conditions.',
  `primary_compliance_power_plant_id` BIGINT COMMENT 'Identifier of the renewable energy generation facility that produced the energy for which this REC was issued. Links to the generation asset registry.',
  `certificate_status` STRING COMMENT 'Current lifecycle status of the REC certificate. Active certificates are available for trading or retirement; retired certificates have been used for compliance; transferred certificates have changed ownership; cancelled certificates are voided. Valid values: active|retired|expired|transferred|cancelled|pending.',
  `compliance_credit_mwh` DECIMAL(18,3) COMMENT 'Effective compliance credit value after applying any multipliers. Calculated as energy_quantity_mwh × rec_multiplier. This is the value counted toward RPS obligation fulfillment.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this REC certificate record was first created in the internal compliance tracking system. Used for audit trail and data lineage purposes.',
  `current_owner_name` STRING COMMENT 'Name of the current legal owner of this REC certificate. Ownership may transfer multiple times before retirement. Confidential business information.',
  `data_source_system` STRING COMMENT 'Name of the source system or registry from which this REC data was ingested (e.g., WREGIS API, M-RETS feed, manual entry). Used for data lineage and reconciliation.',
  `eligibility_flags` STRING COMMENT 'Comma-separated list of special eligibility attributes or certifications for this REC (e.g., in-state, new facility, low-impact hydro, community solar). Used to match RECs to specific compliance requirements.',
  `emissions_avoided_co2_tons` DECIMAL(15,3) COMMENT 'Estimated tons of CO2 emissions avoided by the renewable generation represented by this REC, calculated using regional grid emission factors. Used for environmental impact reporting.',
  `energy_quantity_mwh` DECIMAL(18,3) COMMENT 'Quantity of renewable energy represented by this REC certificate, measured in megawatt-hours. Typically one REC equals one MWh of renewable generation, though some programs use different ratios.',
  `expiration_date` DATE COMMENT 'Date after which this REC can no longer be used for compliance purposes in the applicable jurisdiction. Many RPS programs impose vintage limits (e.g., RECs must be used within 3 years of generation).',
  `facility_location_country` STRING COMMENT 'Country where the generating facility is located. Most U.S. state RPS programs only accept RECs from facilities in the U.S. or specific Canadian provinces. Valid values: USA|CAN|MEX.',
  `facility_location_state` STRING COMMENT 'U.S. state or Canadian province where the generating facility is located. Geographic location affects RPS eligibility in many jurisdictions.',
  `generation_end_date` DATE COMMENT 'End date of the generation period for which this REC was issued. Defines the end of the time window during which the renewable energy was produced.',
  `generation_start_date` DATE COMMENT 'Start date of the generation period for which this REC was issued. Defines the beginning of the time window during which the renewable energy was produced.',
  `generation_technology_type` STRING COMMENT 'Type of renewable energy technology used to generate the electricity represented by this REC. Critical for RPS compliance as many states have technology-specific requirements or multipliers. Reference-value candidates: solar|wind|hydro|biomass|geothermal|landfill.',
  `generation_vintage_month` INT COMMENT 'Calendar month (1-12) in which the renewable energy was generated. Provides granular vintage tracking for compliance and trading purposes.',
  `generation_vintage_year` INT COMMENT 'Calendar year in which the renewable energy was generated. Vintage year determines eligibility for compliance periods under state RPS programs.',
  `issuance_date` DATE COMMENT 'Date on which this REC certificate was issued by the registry. Issuance typically occurs after generation data is verified and submitted to the registry.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this REC certificate record was last updated in the internal compliance tracking system. Tracks data currency and change history.',
  `last_transfer_date` DATE COMMENT 'Date of the most recent ownership transfer of this REC. Null if the REC has never been transferred from the original owner.',
  `notes` STRING COMMENT 'Free-text notes or comments regarding this REC certificate, including special handling instructions, compliance considerations, or audit findings. Used for operational coordination and compliance documentation.',
  `original_owner_name` STRING COMMENT 'Name of the original owner to whom this REC was first issued, typically the generator or the entity with contractual rights to the RECs from the generation facility.',
  `purchase_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the purchase price. Typically USD for U.S. REC markets. Valid values: USD|CAD.',
  `purchase_price_per_rec` DECIMAL(12,2) COMMENT 'Price paid per REC certificate in the most recent transaction, typically in USD. Confidential commercial information used for cost tracking and portfolio valuation.',
  `rec_multiplier` DECIMAL(5,2) COMMENT 'Multiplier applied to the energy quantity for compliance credit calculation. Some state RPS programs provide enhanced credit (e.g., 1.5x or 2.0x) for certain technologies, in-state generation, or other policy objectives.',
  `rec_serial_number` STRING COMMENT 'Unique serial number assigned by the registry to this REC certificate. This is the externally-known business identifier used for tracking, trading, and retirement of the certificate across registries and market participants.',
  `registry_name` STRING COMMENT 'Name of the registry system where this REC is registered and tracked. Registries provide independent verification and tracking of renewable energy generation and certificate lifecycle. Reference-value candidates: WREGIS|NEPOOL.',
  `retirement_date` DATE COMMENT 'Date on which this REC was retired for compliance or voluntary purposes. Retired RECs cannot be traded or reused. Null if the REC has not been retired.',
  `retirement_reason` STRING COMMENT 'Reason for retiring this REC certificate. RPS compliance retirements are used to meet state renewable portfolio standards; voluntary retirements support corporate sustainability goals or green marketing claims. Valid values: RPS compliance|voluntary|contractual obligation|marketing claim|other.',
  `rps_compliance_year` INT COMMENT 'Compliance year for which this REC was retired to meet RPS obligations. Null if not retired for RPS compliance. Critical for demonstrating compliance to state PUCs.',
  `rps_tier` STRING COMMENT 'RPS tier or category classification for this REC under the applicable state program. Many states have tiered structures with different technology eligibility and compliance requirements for each tier. Valid values: Tier 1|Tier 2|Solar|Main Tier|Alternative Compliance|Other.',
  `transfer_count` INT COMMENT 'Number of times this REC has been transferred between owners since issuance. Provides insight into market activity and trading liquidity.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_compliance_rec_certificate` PRIMARY KEY (`compliance_rec_certificate_id`)
)
USING DELTA
COMMENT 'Renewable Energy Certificate (REC) record tracking the generation, registration, transfer, retirement, and compliance use of RECs for Renewable Portfolio Standard (RPS) compliance. Captures REC serial number, generating facility, generation technology type, vintage period, MWh quantity, registry (WREGIS, NEPOOL GIS, PJM GATS, M-RETS), current owner, transfer history, retirement date, and associated RPS compliance obligation. SSOT for RPS certificate inventory, retirement tracking, and RPS compliance demonstration to state PUCs. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ComplianceRecCertificate',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.compliance_rec_certificate'
);

-- RateCase  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`rate_case` (
  `rate_case_id` BIGINT NOT NULL COMMENT 'Unique identifier for the rate case proceeding. Primary key for the rate case entity.',
  `lead_attorney_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Rate cases require employee lead attorney accountability for case strategy and testimony. Replaces text field with FK to enable legal workload tracking, case portfolio management, and expertise alloca',
  `load_id` BIGINT COMMENT 'Foreign key linking to forecast.load. Business justification: Rate cases use load forecasts for test year to justify revenue requirements and rate base. Load forecast drives capacity cost allocation, energy sales projections, and rate design - foundational to ra',
  `peak_demand_id` BIGINT COMMENT 'Foreign key linking to forecast.peak_demand. Business justification: Rate cases cite peak demand forecasts for capacity cost allocation and demand charge rate structure design. Peak demand determines generation and transmission capacity costs recovered through rates.',
  `administrative_law_judge` STRING COMMENT 'Name of the administrative law judge or hearing officer assigned to preside over the evidentiary hearing and issue a proposed decision. Null if not applicable in this jurisdiction.',
  `approved_rate_increase_percent` DECIMAL(5,2) COMMENT 'Overall percentage increase in customer rates approved by the commission in the final order. Expressed as a percentage. Null until final order is issued.',
  `case_description` STRING COMMENT 'Narrative description of the rate case purpose, scope, and key issues. Includes summary of major cost drivers, policy issues, and contested matters.',
  `case_status` STRING COMMENT 'Current procedural status of the rate case in its regulatory lifecycle. Tracks progression from initial filing through final commission order and any post-order proceedings. Reference-value candidates: draft|filed|pending|hearing_scheduled|hearing_complete|settlement_negotiation|commission_deliberation|final_order_issued|rehearing_requested|closed.',
  `case_type` STRING COMMENT 'Classification of the rate case proceeding by its regulatory purpose and scope. General rate cases address overall revenue requirements; transmission rate cases address FERC OATT rates; distribution rate cases address local delivery rates; fuel adjustment clauses address fuel cost recovery; decoupling mechanisms address revenue decoupling from sales volume; formula rates address automatic rate adjustment mechanisms. Valid values: general_rate_case|transmission_rate_case|distribution_rate_case|fuel_adjustment_clause|decoupling_mechanism|formula_rate.',
  `commission_staff_analyst` STRING COMMENT 'Name of the primary commission staff analyst assigned to review and analyze the rate case filing.',
  `effective_date` DATE COMMENT 'Date the new rates approved in the final order become effective for customer billing. May differ from final order date due to suspension periods, phase-in schedules, or tariff filing requirements.',
  `evidentiary_hearing_end_date` DATE COMMENT 'Date the evidentiary hearing concluded. Null if case settled before hearing or hearing not yet completed.',
  `evidentiary_hearing_start_date` DATE COMMENT 'Date the evidentiary hearing commenced, where witnesses present testimony and are subject to cross-examination. Null if case settled before hearing or hearing not yet scheduled.',
  `filed_with_agency` BIGINT COMMENT 'FK to compliance.regulatory_agency.regulatory_agency_id — Rate cases are filed with specific PUCs or FERC. Essential FK for jurisdictional tracking.',
  `filing_date` DATE COMMENT 'Date the utility formally filed the rate case application with the regulatory commission. This date triggers statutory review timelines and procedural schedules.',
  `filing_jurisdiction` STRING COMMENT 'Regulatory jurisdiction where the rate case is filed. Use state abbreviation for state PUC filings (e.g., CA, TX, NY) or FERC for Federal Energy Regulatory Commission filings. Pattern: ^[A-Z]{2,4}$.',
  `final_order_date` DATE COMMENT 'Date the commission issued its final order deciding the rate case. This date establishes the effective date for new rates (subject to any suspension or phase-in provisions).',
  `initial_brief_due_date` DATE COMMENT 'Deadline for parties to file initial post-hearing briefs summarizing their positions and legal arguments. Null if case settled or procedural schedule not yet established.',
  `intervenor_count` INT COMMENT 'Number of parties granted intervenor status in the rate case proceeding, including consumer advocates, industrial customer groups, environmental organizations, and other stakeholders.',
  `notes` STRING COMMENT 'Free-form text field for additional notes, observations, or context regarding the rate case proceeding that do not fit structured fields.',
  `prehearing_conference_date` DATE COMMENT 'Date of the prehearing conference where procedural schedule, discovery protocols, and hearing logistics are established. Null if not yet scheduled or if case settled before hearing.',
  `proposed_decision_date` DATE COMMENT 'Date the administrative law judge or hearing officer issued a proposed decision recommending findings and conclusions to the commission. Null if not applicable in this jurisdiction or if case settled.',
  `proposed_rate_increase_percent` DECIMAL(5,2) COMMENT 'Overall percentage increase in customer rates proposed by the utility in the initial filing, calculated as the change in revenue requirement divided by current revenues. Expressed as a percentage. Negative values indicate a rate decrease.',
  `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this rate case record was first created in the system.',
  `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this rate case record was last modified in the system.',
  `regulatory_affairs_manager` STRING COMMENT 'Name of the regulatory affairs manager responsible for coordinating the utility\'s rate case strategy, filings, and stakeholder engagement.',
  `rehearing_decision_date` DATE COMMENT 'Date the commission issued its decision on the rehearing petition. Null if no rehearing was requested or decision not yet issued.',
  `rehearing_request_date` DATE COMMENT 'Date the petition for rehearing was filed. Null if no rehearing was requested.',
  `rehearing_requested_flag` BOOLEAN COMMENT 'Indicates whether any party filed a petition for rehearing or reconsideration of the final commission order (True) or not (False).',
  `reply_brief_due_date` DATE COMMENT 'Deadline for parties to file reply briefs responding to initial briefs. Null if case settled or procedural schedule not yet established.',
  `settlement_date` DATE COMMENT 'Date the settlement agreement was executed by the parties. Null if the case was not settled.',
  `settlement_flag` BOOLEAN COMMENT 'Indicates whether the rate case was resolved through a settlement agreement among the utility, commission staff, and intervenor parties (True) or proceeded to a fully litigated commission decision (False).',
  `suspension_period_days` INT COMMENT 'Number of days the commission suspended the proposed rate effective date to allow time for review and hearing. Statutory suspension periods vary by jurisdiction (e.g., 5 months for FERC, varies by state PUC).',
  `test_year_end_date` DATE COMMENT 'Ending date of the test year period used to establish the revenue requirement and cost of service.',
  `test_year_start_date` DATE COMMENT 'Beginning date of the test year period used to establish the revenue requirement and cost of service. Test year may be historical, future, or a hybrid period depending on jurisdiction.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_rate_case` PRIMARY KEY (`rate_case_id`)
)
USING DELTA
COMMENT 'Master record for each PUC or FERC rate case proceeding initiated by or involving the utility, including general rate cases, transmission rate cases (FERC OATT), distribution rate cases, fuel adjustment clause proceedings, and decoupling mechanism filings. Captures docket number, filing jurisdiction, case type, test year, filed revenue requirement, proposed rate changes, intervenor parties, procedural schedule milestones (pre-hearing conference, evidentiary hearings, briefs, proposed decision), settlement status, and final commission order. Tracks the full proceeding lifecycle from initial filing through final order and any rehearing requests. SSOT for rate case lifecycle management. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'RateCase',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.rate_case'
);

-- SoxControl  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`sox_control` (
  `sox_control_id` BIGINT NOT NULL COMMENT 'Primary key for sox_control',
  `process_owner_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: SOX controls require employee process ownership for accountability per COSO framework. Replaces text field with FK to enable segregation of duties analysis, control testing assignment, and audit trail',
  `program_id` BIGINT COMMENT 'FK to compliance.program.program_id — SOX controls operate under the SOX Compliance Program. Links control inventory to program structure.',
  `sox_program_id` BIGINT COMMENT 'Foreign key linking to compliance.program. Business justification: SOX controls are managed within a compliance program (e.g., SOX ICFR Compliance Program). Many controls can be part of one program (1:N). Adding program_id FK links the SOX control to its governing pr',
  `affected_account` STRING COMMENT 'The primary general ledger account or account range that this control impacts (e.g., \'4000-Revenue\', \'1500-Regulatory Assets\', \'6100-Fuel Costs\', \'1800-Property Plant and Equipment\'). May reference multiple accounts separated by semicolons.',
  `control_documentation_reference` STRING COMMENT 'Reference to the detailed control documentation, such as a document management system identifier, SharePoint location, or process narrative document number where the full control description, procedures, and evidence requirements are maintained.',
  `control_frequency` STRING COMMENT 'How often the control is performed or executed (e.g., daily reconciliation, monthly review, quarterly certification, annually for rate case filings, or event-driven for specific transactions). Valid values: daily|weekly|monthly|quarterly|annually|event_driven.',
  `control_nature` STRING COMMENT 'Classification indicating whether the control is performed manually by personnel, fully automated by IT systems, or a manual control that depends on IT-generated reports or data (IT-dependent manual control). Valid values: manual|automated|it_dependent_manual.',
  `control_number` STRING COMMENT 'Business identifier for the SOX control, typically following a hierarchical numbering scheme (e.g., FIN-01, REV-02, CAPEX-03). Used in audit documentation and external auditor workpapers.',
  `control_objective` STRING COMMENT 'Detailed statement of the control\'s purpose and what risk it is designed to mitigate (e.g., \'To ensure that revenue is recognized in accordance with GAAP and regulatory accounting principles\', \'To ensure that capital expenditures are properly authorized and capitalized\').',
  `control_owner_name` STRING COMMENT 'Name of the individual or role responsible for executing or overseeing the control activity (may differ from process owner; e.g., \'Senior Accountant - Revenue\', \'Regulatory Compliance Manager\').',
  `control_status` STRING COMMENT 'Current lifecycle status of the control: active (in operation), inactive (temporarily suspended), retired (no longer applicable), or under remediation (deficiency identified and being corrected). Valid values: active|inactive|retired|under_remediation.',
  `control_title` STRING COMMENT 'Short descriptive title of the SOX control (e.g., \'Revenue Recognition Review\', \'Capital Expenditure Authorization\', \'Regulatory Asset Reconciliation\').',
  `control_type` STRING COMMENT 'Classification of the control based on its timing and purpose: preventive (stops errors before they occur), detective (identifies errors after they occur), or corrective (remediates identified errors). Valid values: preventive|detective|corrective.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this control record was first created in the system. Used for audit trail and data lineage purposes.',
  `deficiency_classification` STRING COMMENT 'Classification of any identified control deficiency: none (no deficiency), control deficiency (minor issue unlikely to result in misstatement), significant deficiency (important enough to merit attention by those charged with governance), or material weakness (reasonable possibility of material misstatement not being prevented or detected). Valid values: none|control_deficiency|significant_deficiency|material_weakness.',
  `deficiency_description` STRING COMMENT 'Detailed description of any identified control deficiency, including the nature of the issue, root cause, and potential impact on financial reporting. Null if no deficiency exists.',
  `design_effectiveness_rating` STRING COMMENT 'Assessment of whether the control, as designed, is capable of preventing or detecting material misstatements if it operates as prescribed. Evaluated during control documentation and walkthroughs. Valid values: effective|ineffective|not_evaluated.',
  `effective_date` DATE COMMENT 'The date on which this control became effective and operational. Used to track control lifecycle and determine when testing should commence.',
  `entity_level_control_flag` BOOLEAN COMMENT 'Indicates whether this is an entity-level control (True) that operates across the entire organization (e.g., code of conduct, whistleblower hotline, board oversight) or a process-level control (False) specific to a particular business process.',
  `external_auditor_reliance_flag` BOOLEAN COMMENT 'Indicates whether the external auditor plans to rely on this control (True) as part of their financial statement audit, or will perform substantive testing instead (False). Reliance typically requires more rigorous internal testing.',
  `external_auditor_test_date` DATE COMMENT 'The date on which the external auditor last tested this control as part of their integrated audit. Null if the auditor has not tested this control or does not plan to rely on it.',
  `external_auditor_test_result` STRING COMMENT 'The external auditor\'s assessment of the control\'s operating effectiveness based on their independent testing. Not tested indicates the auditor did not evaluate this control. Valid values: effective|ineffective|not_tested.',
  `financial_statement_assertion` STRING COMMENT 'The primary financial statement assertion that this control addresses: existence (transactions occurred), completeness (all transactions recorded), accuracy (amounts correct), valuation (assets/liabilities properly valued), rights and obligations (entity has legal rights), or presentation and disclosure (proper classification and disclosure). Valid values: existence|completeness|accuracy|valuation|rights_obligations|presentation_disclosure.',
  `it_application` STRING COMMENT 'The primary IT system or application that supports this control (e.g., \'SAP S/4HANA\', \'Oracle CC&B\', \'SAP IS-U\'). Relevant for automated controls and IT-dependent manual controls. Null for purely manual controls.',
  `it_general_control_dependency` STRING COMMENT 'Description of any IT General Controls (ITGCs) that this control depends on, such as access controls, change management, or data backup procedures. Critical for assessing the reliability of automated and IT-dependent manual controls.',
  `key_control_flag` BOOLEAN COMMENT 'Indicates whether this is a key control (True) or a supporting/secondary control (False). Key controls are those that directly address significant risks to financial reporting and are subject to more rigorous testing.',
  `last_modified_by` STRING COMMENT 'The name or user ID of the individual who last modified this control record. Used for accountability and change tracking.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this control record was last updated. Used to track changes to control design, ownership, or testing results.',
  `last_test_date` DATE COMMENT 'The most recent date on which this control was tested for operating effectiveness. Used to track testing currency and plan future test cycles.',
  `last_test_methodology` STRING COMMENT 'The testing approach used in the most recent test: inquiry (asking control performers), observation (watching control execution), inspection (examining evidence), re-performance (independently executing the control), or a combination of methods. Valid values: inquiry|observation|inspection|reperformance|combination.',
  `last_test_period` STRING COMMENT 'The fiscal period or date range covered by the most recent test (e.g., \'Q1 2024\', \'January 2024\', \'FY2023\'). Indicates the scope of the testing performed.',
  `last_test_result` STRING COMMENT 'The outcome of the most recent control test: effective (control operated as designed with no exceptions), ineffective (control failed or had exceptions), or not applicable (control was not in operation during test period). Valid values: effective|ineffective|not_applicable.',
  `last_test_sample_size` INT COMMENT 'The number of items or instances tested during the most recent control test. Sample size is determined based on control frequency, risk rating, and testing standards.',
  `last_tester_name` STRING COMMENT 'Name of the individual who performed the most recent control test. Used for accountability and to ensure independence (tester should not be the control performer).',
  `operating_effectiveness_rating` STRING COMMENT 'Assessment of whether the control is operating as designed and is being performed consistently throughout the period. Determined through testing activities (inquiry, observation, inspection, re-performance). Valid values: effective|ineffective|not_tested.',
  `regulatory_relevance` STRING COMMENT 'Description of how this control supports regulatory compliance beyond SOX, such as FERC reporting requirements, PUC rate case filings, NERC CIP standards, or EPA emissions reporting. Null if the control is purely SOX-driven.',
  `remediation_plan` STRING COMMENT 'Description of the corrective action plan to address an identified deficiency, including specific steps, responsible parties, and timeline. Null if no deficiency exists or remediation is complete.',
  `remediation_target_date` DATE COMMENT 'The target date by which the remediation plan is expected to be completed and the control deficiency resolved. Null if no active remediation is in progress.',
  `retirement_date` DATE COMMENT 'The date on which this control was retired or deactivated, typically due to process changes, system implementations, or risk reassessment. Null for active controls.',
  `risk_rating` STRING COMMENT 'Assessment of the inherent risk level associated with the process or account that this control mitigates. High-risk controls typically receive more frequent testing and external auditor attention. Valid values: high|medium|low.',
  `scoping_rationale` STRING COMMENT 'Explanation of why this control was included in the SOX control inventory, including the materiality assessment, risk evaluation, and linkage to significant accounts or disclosures. Used to support scoping decisions with external auditors.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_sox_control` PRIMARY KEY (`sox_control_id`)
)
USING DELTA
COMMENT 'Master record for each Sarbanes-Oxley (SOX) internal control over financial reporting (ICFR) applicable to the utility, including controls over revenue recognition, regulatory asset accounting, fuel cost recovery, and capital expenditure authorization, along with the complete testing history for each control. Captures control ID, control objective, control type (preventive/detective), control frequency, process owner, IT or manual classification, associated financial statement assertion, and design effectiveness rating. For each test execution: test period, testing methodology (inquiry, observation, inspection, re-performance), sample size, test results (effective/ineffective), deficiency classification (control deficiency, significant deficiency, material weakness), tester identity, and external auditor reliance flag. SSOT for SOX control inventory, test execution records, and testing results supporting management\'s annual SOX 404 assessment and external auditor reliance. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SoxControl',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.sox_control'
);

-- SoxControlTest  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`sox_control_test` (
  `sox_control_test_id` BIGINT NOT NULL COMMENT 'Unique identifier for the SOX control test execution record. Primary key for the sox_control_test product.',
  `audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: SOX control tests can be part of an audit (e.g., annual SOX audit, quarterly ICFR review). Many tests can be part of one audit (1:N). Adding audit_id FK links the control test to the audit engagement.',
  `remediation_plan_id` BIGINT COMMENT 'Reference to the formal remediation plan developed to address the identified deficiency. Links to the remediation tracking system for monitoring corrective action completion.',
  `sox_control_id` BIGINT COMMENT 'Reference to the specific SOX control being tested. Links to the control registry that defines the control objective, control activities, and control owner.',
  `account_code` STRING COMMENT 'The general ledger account code(s) to which this control applies. For utilities, typically includes accounts such as plant in service (101), accumulated depreciation (108), accounts receivable (142), revenue accounts (400-series), and operating expense accounts (500-900 series) per FERC Uniform System of Accounts. Pattern: ^[0-9]{4,10}$.',
  `active_flag` BOOLEAN COMMENT 'Indicates whether this control test record is active and current. False indicates the record has been superseded, voided, or is no longer relevant for current period reporting. Used for filtering current-period test results.',
  `business_process` STRING COMMENT 'The business process or cycle to which this control belongs (e.g., Revenue and Receivables, Procurement to Pay, Payroll, Fixed Assets, Financial Close and Reporting, Treasury, Regulatory Reporting). Used for organizing controls by process area and assigning process owners.',
  `control_automation_level` STRING COMMENT 'The degree of automation in the control execution. Fully automated controls are system-enforced with no manual intervention; semi-automated controls combine system and manual steps; manual controls are entirely human-performed. Automation level affects sample size and testing methodology. Valid values: fully_automated|semi_automated|manual.',
  `control_frequency` STRING COMMENT 'The designed operating frequency of the control being tested. Determines the expected population size and testing approach. Daily and weekly controls typically require larger sample sizes than quarterly or annual controls. Valid values: daily|weekly|monthly|quarterly|annually|event_driven.',
  `control_type` STRING COMMENT 'The nature of the control being tested. Preventive controls stop errors before they occur; detective controls identify errors after they occur; corrective controls remediate identified errors. Classification affects testing approach and reliance strategy. Valid values: preventive|detective|corrective.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this control test record was first created in the system. Audit trail field for record lifecycle tracking.',
  `deficiency_classification` STRING COMMENT 'The severity classification of any identified control deficiency. Control deficiency is a shortcoming that does not rise to significant deficiency. Significant deficiency is important enough to merit attention by those charged with governance. Material weakness is a deficiency such that there is a reasonable possibility of material misstatement. Classification follows PCAOB definitions. Valid values: none|control_deficiency|significant_deficiency|material_weakness.',
  `deficiency_description` STRING COMMENT 'Detailed narrative description of the control deficiency identified during testing, including the nature of the exception, the root cause, and the potential impact on financial reporting. Required when test_result is ineffective.',
  `entity_level_control_flag` BOOLEAN COMMENT 'Indicates whether this is an entity-level control (e.g., tone at the top, code of conduct, risk assessment process, board oversight) as opposed to a transaction-level or process-level control. Entity-level controls have a pervasive effect on internal control over financial reporting.',
  `exceptions_identified_count` INT COMMENT 'The number of sample items that did not meet the control criteria or where the control did not operate as designed. Zero exceptions indicates effective control operation for the sample tested.',
  `external_auditor_firm_name` STRING COMMENT 'The name of the external audit firm (e.g., Deloitte, PwC, EY, KPMG, or other registered public accounting firm) that reviewed or relied upon this test. Required for publicly traded utilities subject to SOX 404(b) external auditor attestation.',
  `external_auditor_reliance_flag` BOOLEAN COMMENT 'Indicates whether the external auditor (Big 4 or other registered public accounting firm) intends to rely on this management test as part of their integrated audit of internal controls over financial reporting. True means the auditor will not re-perform the test; false means the auditor will perform their own independent test.',
  `external_auditor_review_date` DATE COMMENT 'The date on which the external auditor reviewed this management test for purposes of determining reliance. Populated only when external_auditor_reliance_flag is true.',
  `financial_statement_assertion` STRING COMMENT 'The primary financial statement assertion addressed by the control being tested. Existence confirms assets/liabilities exist; completeness confirms all transactions are recorded; accuracy confirms amounts are correct; valuation confirms proper measurement; rights_and_obligations confirms ownership; presentation_and_disclosure confirms proper classification and disclosure. Multiple assertions may apply; this field captures the primary assertion. Reference-value candidates: existence|completeness|accuracy|valuation|rights_and_obligations|presentation_and_disclosure|cutoff|classification. Valid values: existence|completeness|accuracy|valuation|rights_and_obligations|presentation_and_disclosure.',
  `fiscal_quarter` STRING COMMENT 'The fiscal quarter for which this control test was performed. Q1, Q2, Q3, or Q4. Used for quarterly SOX assessment and interim financial reporting. Valid values: Q1|Q2|Q3|Q4.',
  `fiscal_year` INT COMMENT 'The fiscal year for which this control test was performed, typically matching the test period end date fiscal year. Used for annual SOX 404 assessment aggregation and multi-year trend analysis.',
  `information_technology_general_control_flag` BOOLEAN COMMENT 'Indicates whether this is an IT general control (e.g., access controls, change management, backup and recovery, IT operations) that supports the operating effectiveness of automated application controls. ITGC deficiencies can cascade to application control failures.',
  `key_control_flag` BOOLEAN COMMENT 'Indicates whether this is a key control that management and external auditors rely upon to prevent or detect material misstatements. Key controls require annual testing; non-key controls may be tested on a rotational basis.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this control test record was most recently modified. Audit trail field for change tracking and data quality monitoring.',
  `remediation_required_flag` BOOLEAN COMMENT 'Indicates whether management action is required to remediate the identified deficiency. True for significant deficiencies and material weaknesses; may be true for control deficiencies depending on risk assessment.',
  `review_date` DATE COMMENT 'The date on which the test results were reviewed and approved by the reviewer. Must be on or after the test execution date.',
  `reviewer_name` STRING COMMENT 'The name of the individual who reviewed and approved the test results and conclusion. Typically a senior internal auditor, SOX manager, or Chief Audit Executive. Required for quality assurance and segregation of duties.',
  `risk_rating` STRING COMMENT 'The inherent risk rating of the control based on the magnitude and likelihood of potential misstatement if the control fails. Critical and high-risk controls require more rigorous testing (larger samples, more frequent testing) than medium or low-risk controls. Valid values: critical|high|medium|low.',
  `sample_selection_method` STRING COMMENT 'The approach used to select the sample from the population. Random uses statistical sampling; systematic selects every nth item; haphazard is non-statistical but unbiased; judgmental targets high-risk items; all_items tests the entire population. Valid values: random|systematic|haphazard|judgmental|all_items.',
  `sample_size` INT COMMENT 'The number of items or transactions selected for testing. For automated controls, may be 1 (test of configuration). For manual controls, typically 25+ items per PCAOB guidance for key controls.',
  `test_evidence_location` STRING COMMENT 'The file path, document management system reference, or physical location where the test workpapers and supporting evidence are stored. Required for audit trail and external auditor review. Typically a network path or document management system URL.',
  `test_execution_date` DATE COMMENT 'The date on which the control test was actually performed by the tester. This is the principal business event timestamp for the test execution.',
  `test_methodology` STRING COMMENT 'The audit testing technique applied to evaluate control effectiveness. Inquiry involves asking questions; observation involves watching the control in action; inspection involves examining documents; reperformance involves independently executing the control; analytical procedure involves data analysis; walkthrough involves tracing a transaction through the process. Valid values: inquiry|observation|inspection|reperformance|analytical_procedure|walkthrough.',
  `test_notes` STRING COMMENT 'Additional narrative notes, observations, or context about the test execution, results, or follow-up actions. May include tester commentary on control design improvements, process changes during the test period, or coordination with external auditors.',
  `test_number` STRING COMMENT 'Business identifier for the control test execution, typically formatted as control-code-year-sequence (e.g., FIN-2024-001). Used for audit trail and external auditor reference. Pattern: ^[A-Z0-9]{2,4}-[0-9]{4}-[0-9]{3}$.',
  `test_period_end_date` DATE COMMENT 'The ending date of the period for which the control effectiveness is being tested. For quarterly assessments, typically the last day of the fiscal quarter.',
  `test_period_start_date` DATE COMMENT 'The beginning date of the period for which the control effectiveness is being tested. For quarterly assessments, typically the first day of the fiscal quarter.',
  `test_result` STRING COMMENT 'The overall conclusion on control effectiveness based on the test evidence. Effective means the control operated as designed with no or immaterial exceptions. Ineffective means the control did not operate as designed or had material exceptions. This is the principal outcome of the test execution. Valid values: effective|ineffective|not_tested|not_applicable.',
  `tester_name` STRING COMMENT 'The name of the individual who performed the control test. Typically an internal audit team member, SOX compliance analyst, or process owner. Required for audit trail and accountability.',
  `tester_role` STRING COMMENT 'The organizational role or function of the individual who performed the test. Distinguishes between management testing (internal audit, SOX compliance, process owner) and external auditor testing. Valid values: internal_audit|sox_compliance|process_owner|external_auditor|consultant.',
  `updated_by_user` STRING COMMENT 'The user ID or name of the individual who last modified this control test record. Required for audit trail and accountability in SOX compliance documentation.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_sox_control_test` PRIMARY KEY (`sox_control_test_id`)
)
USING DELTA
COMMENT 'Transactional record of each SOX control test execution performed during quarterly and annual ICFR assessments, capturing the tested control, test period, testing methodology (inquiry, observation, inspection, re-performance), sample size, test results (effective/ineffective), deficiency classification (control deficiency, significant deficiency, material weakness), and external auditor reliance flag. Supports management\'s annual SOX 404 assessment and external auditor testing. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SoxControlTest',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.sox_control_test'
);

-- ComplianceProgram  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`program` (
  `program_id` BIGINT NOT NULL COMMENT 'Primary key for program',
  `owner_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Compliance programs require employee ownership for governance accountability. Replaces text field with FK to enable program portfolio management, succession planning, and workload balancing across com',
  `owner_org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Compliance programs are assigned to organizational units for budget allocation and resource planning. Replaces text field with FK to enable departmental compliance program portfolio analysis.',
  `active_flag` BOOLEAN COMMENT 'Indicates whether this compliance program record is currently active in the system (True/False). Used for soft deletes and historical tracking.',
  `assessment_required_flag` BOOLEAN COMMENT 'Indicates whether a formal assessment or examination is required to demonstrate training competency (True/False).',
  `associated_policies_count` INT COMMENT 'The number of formal policies that are part of this compliance program.',
  `associated_procedures_count` INT COMMENT 'The number of formal procedures that implement this compliance program.',
  `audit_frequency` STRING COMMENT 'The frequency at which this compliance program is subject to internal or external audit. Valid values: annual|biennial|triennial|quarterly|as_needed|continuous.',
  `board_reporting_flag` BOOLEAN COMMENT 'Indicates whether this compliance program status and metrics are reported to the Board of Directors (True/False).',
  `board_reporting_frequency` STRING COMMENT 'The frequency at which compliance program status is reported to the Board of Directors. Valid values: monthly|quarterly|semi_annual|annual|as_needed.',
  `budget_usd` DECIMAL(15,2) COMMENT 'The annual budget allocated to this compliance program in United States Dollars, including personnel, training, technology, and external audit costs.',
  `certification_issued_flag` BOOLEAN COMMENT 'Indicates whether a formal certification is issued upon successful completion of training (True/False).',
  `certification_validity_period_months` INT COMMENT 'The number of months for which a training certification remains valid before recertification is required. Null if certification does not expire.',
  `charter_date` DATE COMMENT 'The date on which the compliance program was formally chartered and approved by executive leadership or the Board.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this compliance program record was first created in the system.',
  `document_repository_location` STRING COMMENT 'The system or location where compliance program documentation, policies, procedures, and evidence are stored (e.g., SharePoint site, document management system path).',
  `effective_date` DATE COMMENT 'The date on which the compliance program became operationally effective and binding on the organization.',
  `effectiveness_rating` STRING COMMENT 'Qualitative assessment of the compliance programs effectiveness in achieving its objectives and managing compliance risk. Valid values: highly_effective|effective|needs_improvement|ineffective|not_rated.',
  `evidence_retention_period_years` INT COMMENT 'The number of years that compliance evidence and training records must be retained to satisfy regulatory and audit requirements.',
  `expiration_date` DATE COMMENT 'The date on which the compliance program is scheduled to expire or be reviewed for renewal. Null for perpetual programs.',
  `external_auditor_flag` BOOLEAN COMMENT 'Indicates whether this compliance program is subject to external auditor review (True/False).',
  `governing_regulatory_framework` STRING COMMENT 'The primary regulatory framework or standard that mandates this compliance program (e.g., NERC CIP-001 through CIP-014, FERC Order 2000, EPA Clean Air Act, SOX Section 404, OSHA 29 CFR 1910).',
  `issuing_regulatory_body` STRING COMMENT 'The governing body or regulatory agency that issued the compliance mandate (e.g., NERC, FERC, EPA, SEC, OSHA, State PUC).',
  `last_audit_date` DATE COMMENT 'The date of the most recent internal or external audit of this compliance program.',
  `last_audit_result` STRING COMMENT 'The outcome of the most recent audit of this compliance program. Valid values: compliant|non_compliant|compliant_with_findings|not_audited.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this compliance program record was most recently modified.',
  `minimum_passing_score_pct` DECIMAL(5,2) COMMENT 'The minimum assessment score required to pass training and achieve compliance (e.g., 80.00 for NERC CIP training assessments).',
  `next_audit_date` DATE COMMENT 'The scheduled date for the next internal or external audit of this compliance program.',
  `notes` STRING COMMENT 'Free-form notes capturing additional context, special considerations, or historical information about the compliance program.',
  `owner_title` STRING COMMENT 'Job title of the program owner (e.g., Chief Compliance Officer, VP Regulatory Affairs, Director Environmental Compliance).',
  `program_code` STRING COMMENT 'Unique business identifier code for the compliance program (e.g., NERC-CIP, FERC-SOC, EPA-EMIS, SOX-FIN, OSHA-SAF). Pattern: ^[A-Z0-9_-]{3,20}$.',
  `program_description` STRING COMMENT 'Comprehensive narrative description of the compliance program objectives, scope, key activities, and deliverables.',
  `program_name` STRING COMMENT 'Full official name of the compliance program (e.g., NERC CIP Compliance Program, FERC Standards of Conduct Program, Environmental Compliance Program, SOX Compliance Program, OSHA Safety Compliance Program).',
  `program_status` STRING COMMENT 'Current lifecycle status of the compliance program. Valid values: active|inactive|under_development|suspended|retired.',
  `program_type` STRING COMMENT 'Classification of the compliance program by its origin and binding nature. Valid values: regulatory|statutory|voluntary|contractual|internal_policy.',
  `risk_rating` STRING COMMENT 'The assessed risk level associated with non-compliance under this program, considering both likelihood and impact. Valid values: critical|high|medium|low.',
  `scope_of_applicability` STRING COMMENT 'Detailed description of the organizational scope to which this compliance program applies (e.g., all generation facilities, all transmission assets rated above 100kV, all employees with access to BES Cyber Systems, all financial reporting personnel).',
  `training_completion_threshold_pct` DECIMAL(5,2) COMMENT 'The minimum percentage of assigned personnel who must complete training for the program to be considered compliant (e.g., 100.00 for NERC CIP, 95.00 for internal programs).',
  `training_frequency` STRING COMMENT 'The required frequency at which training must be completed or refreshed for this compliance program. Valid values: annual|biennial|quarterly|one_time|as_needed|continuous.',
  `training_required_flag` BOOLEAN COMMENT 'Indicates whether formal training is mandated for personnel under this compliance program (True/False).',
  `updated_by_user` STRING COMMENT 'The user ID or name of the person who last updated this compliance program record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_program` PRIMARY KEY (`program_id`)
)
USING DELTA
COMMENT 'Master record for each formal compliance program maintained by the utility, including the NERC CIP Compliance Program, FERC Standards of Conduct Program, Environmental Compliance Program, SOX Compliance Program, and OSHA Safety Compliance Program. Captures program name, governing regulatory framework, program owner, program charter date, scope of applicability, associated policies and procedures, and program effectiveness metrics. Includes the full training management lifecycle: training course catalog, training delivery methods, training assignments, and for each personnel training completion: assigned personnel role, training course, delivery method, assigned date, completion date, assessment score, pass/fail status, and certification expiry date. Provides the organizational structure for compliance management and serves as SSOT for compliance program inventory and all compliance training evidence required under NERC CIP-004, FERC Standards of Conduct, OSHA, and other regulatory training mandates. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ComplianceProgram',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.program'
);

-- TrainingRecord  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`training_record` (
  `training_record_id` BIGINT NOT NULL COMMENT 'Primary key for training_record',
  `employee_id` BIGINT COMMENT 'Unique identifier of the utility employee or contractor assigned to complete this training.',
  `obligation_id` BIGINT COMMENT 'Unique identifier of the regulatory obligation that mandates this training requirement.',
  `primary_program_id` BIGINT COMMENT 'FK to compliance.program.program_id — Training records are associated with specific compliance programs (NERC CIP, SOX, OSHA). This FK enables program-level training compliance tracking.',
  `training_course_id` BIGINT COMMENT 'Unique identifier of the compliance training course assigned.',
  `training_program_id` BIGINT COMMENT 'Foreign key linking to compliance.program. Business justification: Training records are delivered as part of a compliance program (e.g., NERC CIP training program, SOX training program). Many training records can be part of one program (1:N). Adding program_id FK lin',
  `active_flag` BOOLEAN COMMENT 'Indicates whether this training record is currently active (True) or has been archived/superseded (False).',
  `actual_time_spent_hours` DECIMAL(5,2) COMMENT 'Actual time spent by the employee completing the training, tracked by the learning management system.',
  `assessment_passed_flag` BOOLEAN COMMENT 'Indicates whether the employee passed the training assessment (True) or failed (False).',
  `assessment_score` DECIMAL(5,2) COMMENT 'Numeric score achieved by the employee on the training assessment or examination, typically expressed as a percentage (0.00 to 100.00).',
  `assigned_by_user` STRING COMMENT 'Username or identifier of the compliance officer or manager who assigned the training.',
  `assigned_date` DATE COMMENT 'Date on which the training was assigned to the employee.',
  `attempt_number` INT COMMENT 'Number of attempts the employee has made to complete the training assessment.',
  `audit_evidence_reference` STRING COMMENT 'Reference identifier linking this training record to supporting audit evidence documentation (e.g., certificate file path, LMS transcript ID).',
  `business_unit` STRING COMMENT 'Business unit or department to which the employee belongs (e.g., Generation Operations, Transmission, Distribution, IT).',
  `certification_expiry_date` DATE COMMENT 'Date on which the training certification expires and recertification or refresher training is required.',
  `certification_issue_date` DATE COMMENT 'Date on which the training completion certificate was issued.',
  `certification_number` STRING COMMENT 'Unique certificate number issued upon successful completion of the training, used for audit evidence.',
  `completion_date` DATE COMMENT 'Date on which the employee successfully completed the training course.',
  `completion_status` STRING COMMENT 'Current status of the training assignment indicating progress and completion state. Valid values: Not Started|In Progress|Completed|Failed|Overdue|Waived.',
  `compliance_year` INT COMMENT 'Calendar year for which this training record satisfies compliance obligations.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this training record was first created in the system.',
  `due_date` DATE COMMENT 'Date by which the training must be completed to maintain compliance.',
  `facility_code` STRING COMMENT 'Code identifying the utility facility or location where the employee is assigned (e.g., power plant, substation, control center).',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this training record was last modified.',
  `nerc_cip_role_flag` BOOLEAN COMMENT 'Indicates whether the employee holds a NERC CIP-designated role requiring enhanced cybersecurity training (True) or not (False).',
  `passing_score_threshold` DECIMAL(5,2) COMMENT 'Minimum score required to pass the training assessment and achieve compliance, typically expressed as a percentage.',
  `personnel_role` STRING COMMENT 'Job role or position of the employee at the time of training assignment (e.g., Control Room Operator, Substation Technician, Cybersecurity Analyst).',
  `recertification_frequency_months` INT COMMENT 'Number of months between required recertification or refresher training cycles (e.g., 12 for annual, 36 for triennial).',
  `recertification_required_flag` BOOLEAN COMMENT 'Indicates whether periodic recertification is required for this training (True) or if it is a one-time requirement (False).',
  `record_source_system` STRING COMMENT 'Name of the source system from which this training record originated (e.g., SAP SuccessFactors, Cornerstone LMS, internal compliance tracking system).',
  `training_assignment_number` STRING COMMENT 'Business identifier for the training assignment, used for tracking and audit purposes. Pattern: ^TRN-[0-9]{10}$.',
  `training_category` STRING COMMENT 'High-level category of the compliance training program. Valid values: NERC CIP|FERC Standards of Conduct|OSHA Safety|Environmental Compliance|SOX Ethics|Cybersecurity.',
  `training_course_code` STRING COMMENT 'Standardized code identifying the training course (e.g., CIP004-001 for NERC CIP-004 security awareness training). Pattern: ^[A-Z]{3,6}-[0-9]{3,4}$.',
  `training_course_name` STRING COMMENT 'Full name of the compliance training course (e.g., NERC CIP Security Awareness Training, FERC Standards of Conduct Training).',
  `training_delivery_method` STRING COMMENT 'Method by which the training content is delivered to the personnel. Valid values: Instructor-Led|E-Learning|Webinar|On-the-Job|Blended|Self-Study.',
  `training_duration_hours` DECIMAL(5,2) COMMENT 'Total duration of the training course in hours.',
  `training_notes` STRING COMMENT 'Free-text notes capturing additional context, special circumstances, or observations related to the training assignment and completion.',
  `training_type` STRING COMMENT 'Type of training assignment indicating whether it is initial onboarding, periodic refresher, recertification, or remedial training. Valid values: Initial|Refresher|Recertification|Remedial|Ad-Hoc.',
  `updated_by_user` STRING COMMENT 'Username or identifier of the user who last updated this training record.',
  `waiver_approval_date` DATE COMMENT 'Date on which the training waiver was approved.',
  `waiver_approved_by` STRING COMMENT 'Username or identifier of the compliance officer or manager who approved the training waiver.',
  `waiver_granted_flag` BOOLEAN COMMENT 'Indicates whether a waiver was granted exempting the employee from completing this training (True) or not (False).',
  `waiver_reason` STRING COMMENT 'Business justification for granting a training waiver, if applicable.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_training_record` PRIMARY KEY (`training_record_id`)
)
USING DELTA
COMMENT 'Transactional record of compliance training assignments and completions for utility personnel, covering NERC CIP security awareness training, FERC Standards of Conduct training, OSHA safety training, environmental compliance training, and SOX ethics and anti-fraud training. Captures training course, assigned personnel role, training delivery method, assigned date, completion date, assessment score, and certification expiry. Supports NERC CIP-004 personnel training evidence requirements. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'TrainingRecord',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.training_record'
);

-- SelfReport  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`self_report` (
  `self_report_id` BIGINT NOT NULL COMMENT 'Unique identifier for the self-reported potential violation or compliance exception. Primary key.',
  `audit_finding_id` BIGINT COMMENT 'Foreign key linking to compliance.audit_finding. Business justification: A self-report may be triggered by an internal audit finding that discovered a compliance gap. Many self-reports can relate to one finding (1:N). Adding audit_finding_id FK links the self-report to the',
  `exception_id` BIGINT COMMENT 'Foreign key linking to compliance.exception. Business justification: A self-report may be triggered by a compliance exception discovered through internal monitoring. Many self-reports can relate to one exception (1:N). Adding exception_id FK links the self-report to th',
  `obligation_id` BIGINT COMMENT 'Reference to the specific compliance obligation, regulatory standard, or requirement that was allegedly violated or not met.',
  `responsible_manager_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Self-reports require manager accountability for violation discovery and mitigation. Replaces text field with FK to enable self-reporting workload tracking, escalation management, and compliance cultur',
  `active_flag` BOOLEAN COMMENT 'Indicates whether this self-report record is currently active and valid in the system.',
  `actual_penalty_assessed` DECIMAL(15,2) COMMENT 'Final penalty amount assessed by the regulatory authority for this self-reported violation, in US dollars.',
  `affected_business_unit` STRING COMMENT 'Name or code of the business unit, division, or department responsible for the area where the violation occurred.',
  `affected_facility_code` STRING COMMENT 'Code or identifier of the utility facility, plant, substation, or operational unit where the violation occurred.',
  `board_notification_date` DATE COMMENT 'Date when the Board of Directors was notified of this self-reported violation and potential financial exposure.',
  `closure_date` DATE COMMENT 'Date when the self-report case was formally closed by the regulatory authority with no further action required.',
  `comments` STRING COMMENT 'Additional notes, context, or supplementary information relevant to this self-report record.',
  `compliance_officer_name` STRING COMMENT 'Name of the compliance officer who prepared or reviewed the self-report submission.',
  `cooperation_credit_applied_flag` BOOLEAN COMMENT 'Indicates whether additional credit was granted for exceptional cooperation during the regulatory review process.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this self-report record was first created in the system.',
  `credit_applied_flag` BOOLEAN COMMENT 'Indicates whether the regulatory authority granted credit or penalty reduction for proactive self-reporting.',
  `discovery_date` DATE COMMENT 'Date when the utility first discovered or became aware of the potential violation or compliance exception.',
  `estimated_penalty_amount` DECIMAL(15,2) COMMENT 'Internal estimate of potential financial penalty exposure associated with this self-reported violation, in US dollars.',
  `evidence_collection_method` STRING COMMENT 'Description of how supporting evidence and documentation for this self-report was collected and preserved.',
  `evidence_repository_location` STRING COMMENT 'System path, document management location, or repository reference where supporting evidence is stored.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this self-report record was last updated or modified.',
  `lessons_learned` STRING COMMENT 'Documented insights, best practices, and organizational learning captured from this self-report experience for continuous improvement.',
  `mitigation_actions_taken` STRING COMMENT 'Description of corrective actions, remediation steps, and mitigation measures already implemented to address the violation.',
  `mitigation_completion_date` DATE COMMENT 'Date when all mitigation actions were completed and the violation was fully remediated.',
  `modified_by_user` STRING COMMENT 'User ID or name of the person who last modified this self-report record.',
  `penalty_reduction_percentage` DECIMAL(5,2) COMMENT 'Percentage reduction in penalty granted due to self-reporting, cooperation, and mitigation factors.',
  `preventive_actions_planned` STRING COMMENT 'Description of additional preventive measures, process improvements, or controls being implemented to prevent recurrence.',
  `public_disclosure_date` DATE COMMENT 'Date when the self-report or resulting enforcement action was publicly disclosed or posted to regulatory websites.',
  `public_disclosure_required_flag` BOOLEAN COMMENT 'Indicates whether this self-report must be publicly disclosed per regulatory requirements or materiality thresholds.',
  `regional_entity_code` STRING COMMENT 'Code identifying the NERC Regional Entity with jurisdiction over this self-report, if applicable to bulk electric system reliability standards. Reference-value candidates: WECC|NPCC|MRO|SERC|RF|TRE|SPP|FRCC.',
  `regulatory_correspondence_reference` STRING COMMENT 'Reference number or identifier for related regulatory correspondence, letters, or official communications regarding this self-report.',
  `regulatory_recipient` STRING COMMENT 'Primary regulatory body or authority to which the self-report was submitted. Valid values: NERC|FERC|EPA|State PUC|Regional Entity|Other.',
  `regulatory_response_date` DATE COMMENT 'Date when the regulatory authority provided formal response, acknowledgment, or determination regarding the self-report.',
  `report_number` STRING COMMENT 'Externally-known unique reference number assigned to this self-report submission, typically following format SPV-YYYY-NNNNNN for tracking and regulatory correspondence. Pattern: ^SPV-[0-9]{4}-[0-9]{6}$.',
  `report_status` STRING COMMENT 'Current lifecycle status of the self-report in the regulatory review and resolution process. Valid values: Draft|Submitted|Under Review|Accepted|Closed|Withdrawn.',
  `report_type` STRING COMMENT 'Classification of the self-report based on the regulatory framework and submission process used. Valid values: NERC Self-Report|FERC Voluntary Disclosure|EPA Self-Disclosure|PUC Proactive Notice|Other.',
  `root_cause_analysis` STRING COMMENT 'Documented analysis identifying the underlying root cause(s) that led to the violation or compliance exception.',
  `root_cause_category` STRING COMMENT 'High-level categorization of the root cause for trending and analysis purposes. Valid values: Human Error|Process Deficiency|Technology Failure|Training Gap|Resource Constraint|External Factor.',
  `settlement_reached_flag` BOOLEAN COMMENT 'Indicates whether the self-report resulted in a settlement agreement with the regulatory authority.',
  `settlement_terms` STRING COMMENT 'Summary of key terms and conditions agreed upon in the settlement, if applicable.',
  `submission_date` DATE COMMENT 'Date when the self-report was formally submitted to the regulatory authority.',
  `violated_standard_code` STRING COMMENT 'Specific regulatory standard, rule, or requirement code that was allegedly violated (e.g., CIP-007-6 R2, 40 CFR Part 60).',
  `violation_description` STRING COMMENT 'Detailed narrative description of the alleged violation, non-compliance condition, or compliance exception being self-reported.',
  `violation_end_date` DATE COMMENT 'Date when the violation or non-compliance condition was remediated or ceased, if applicable.',
  `violation_risk_factor` STRING COMMENT 'Risk classification of the violated requirement indicating potential impact to bulk electric system reliability. Valid values: Lower|Medium|High.',
  `violation_severity_level` STRING COMMENT 'Assessment of the severity of the alleged violation based on regulatory severity level definitions, particularly for NERC standards. Valid values: Minimal|Lower|Moderate|High|Severe.',
  `violation_start_date` DATE COMMENT 'Date when the alleged violation or non-compliance condition first began or occurred.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_self_report` PRIMARY KEY (`self_report_id`)
)
USING DELTA
COMMENT 'Record of self-reported potential violations (SPVs) or compliance exceptions that the utility proactively discloses to regulators before being identified through audit, including NERC self-reports, FERC voluntary disclosures, and EPA self-disclosure submissions. Captures the self-report reference number, associated obligation or standard, disclosure date, regulatory recipient, violation description, root cause, and mitigation actions taken. Proactive self-reporting typically results in reduced penalties. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SelfReport',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.self_report'
);

-- CpcnApplication  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`cpcn_application` (
  `cpcn_application_id` BIGINT NOT NULL COMMENT 'Unique identifier for the CPCN application record. Primary key.',
  `capex_project_id` BIGINT COMMENT 'Foreign key linking to finance.capex_project. Business justification: CPCN applications authorize specific capital projects. Regulatory approval gates project execution; finance tracks actual spend against approved budget. Essential for reconciling regulatory commitment',
  `project_manager_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: CPCN applications require employee project manager accountability for construction project execution. Replaces text field with FK to enable resource allocation, project portfolio management, and regul',
  `acceptance_date` DATE COMMENT 'Date on which the PUC formally accepted the application as complete and sufficient for review.',
  `active_flag` BOOLEAN COMMENT 'Indicates whether the CPCN application record is currently active in the system or has been archived.',
  `appeal_filed_flag` BOOLEAN COMMENT 'Indicates whether an appeal of the PUC decision has been filed with a state court or appellate body.',
  `application_number` STRING COMMENT 'Externally-known application number assigned by the utility or regulatory body for tracking and reference purposes.',
  `application_status` STRING COMMENT 'Current lifecycle status of the CPCN application within the regulatory approval process. Reference-value candidates: draft|filed|under_review|hearing_scheduled|approved|denied|withdrawn|suspended.',
  `application_type` STRING COMMENT 'Type of capital project for which the CPCN is being sought, categorizing the nature of the infrastructure investment. Valid values: generation_facility|transmission_line|substation|distribution_infrastructure|combined_project|other.',
  `board_approval_required_flag` BOOLEAN COMMENT 'Indicates whether Board of Directors approval was required prior to filing the CPCN application due to capital expenditure thresholds.',
  `board_notification_date` DATE COMMENT 'Date on which the utility Board of Directors was notified of the CPCN application filing or decision.',
  `certificate_conditions` STRING COMMENT 'Specific conditions, restrictions, or requirements imposed by the PUC as part of the certificate approval, including construction milestones, reporting obligations, and operational constraints.',
  `certificate_expiration_date` DATE COMMENT 'Date by which construction must commence or be completed as specified in the certificate conditions, after which the certificate may expire.',
  `certificate_issue_date` DATE COMMENT 'Date on which the CPCN certificate was formally issued to the utility following approval.',
  `certificate_type` STRING COMMENT 'Specific type of certificate being applied for, indicating whether the project involves new construction, expansion, upgrade, replacement, abandonment, or transfer of existing facilities. Valid values: new_construction|expansion|upgrade|replacement|abandonment|transfer.',
  `commission_order_date` DATE COMMENT 'Date on which the PUC issued its final order approving, denying, or conditionally approving the CPCN application.',
  `contested_flag` BOOLEAN COMMENT 'Indicates whether the application is contested by intervenors or other parties, requiring evidentiary hearings and formal proceedings.',
  `cpcn_filed_with_agency` BIGINT COMMENT 'FK to compliance.regulatory_agency.regulatory_agency_id — CPCN applications are filed with specific state PUCs. Essential FK for application tracking.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the CPCN application record was first created in the system.',
  `docket_number` STRING COMMENT 'Official docket number assigned by the state PUC to track the regulatory proceeding for this CPCN application.',
  `document_repository_url` STRING COMMENT 'URL or file path to the document repository containing all application materials, testimony, exhibits, and correspondence related to the CPCN proceeding.',
  `environmental_permit_required_flag` BOOLEAN COMMENT 'Indicates whether environmental permits from EPA or state environmental agencies are required for the project.',
  `environmental_review_status` STRING COMMENT 'Current status of the environmental impact assessment and regulatory review process required for the project. Valid values: not_started|in_progress|completed|approved|conditional_approval|denied.',
  `estimated_annual_opex` DECIMAL(18,2) COMMENT 'Projected annual operational expenditure in USD for operating and maintaining the facility once in service.',
  `external_counsel_engaged_flag` BOOLEAN COMMENT 'Indicates whether external legal counsel was retained to support the CPCN application and regulatory proceedings.',
  `filing_date` DATE COMMENT 'Date on which the CPCN application was officially filed with the state PUC.',
  `intervenor_count` INT COMMENT 'Number of parties granted intervenor status in the regulatory proceeding, including consumer advocates, environmental groups, and competing utilities.',
  `jurisdiction_state` STRING COMMENT 'State in which the PUC has jurisdiction over the CPCN application, using standard two-letter state abbreviation.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the CPCN application record was most recently modified.',
  `nepa_review_required_flag` BOOLEAN COMMENT 'Indicates whether a NEPA environmental impact statement or assessment is required for federal approval or funding.',
  `notes` STRING COMMENT 'Free-form notes and comments regarding the CPCN application, including internal observations, strategic considerations, and procedural updates.',
  `planned_construction_start_date` DATE COMMENT 'Anticipated date for commencement of construction activities as stated in the application.',
  `planned_in_service_date` DATE COMMENT 'Target date for the facility to be placed into commercial operation and begin serving customers.',
  `project_description` STRING COMMENT 'Detailed narrative description of the proposed capital project, including scope, objectives, technical specifications, and business justification.',
  `project_justification` STRING COMMENT 'Business and regulatory justification for the project, including need analysis, reliability improvements, capacity requirements, and public benefit rationale.',
  `project_name` STRING COMMENT 'Business name or title of the capital project for which the CPCN is being sought.',
  `public_comment_count` INT COMMENT 'Total number of public comments received during the comment period for the application.',
  `public_hearing_date` DATE COMMENT 'Scheduled date for the public hearing where stakeholders, intervenors, and the public may present testimony and evidence regarding the application.',
  `puc_commission_name` STRING COMMENT 'Official name of the state public utility commission or regulatory body with authority over the application.',
  `rate_impact_estimate` DECIMAL(10,4) COMMENT 'Estimated impact on customer rates expressed as a percentage or dollar amount per customer class resulting from the capital investment.',
  `regulatory_contact_email` STRING COMMENT 'Email address of the regulatory affairs contact for correspondence regarding the CPCN application. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `regulatory_contact_name` STRING COMMENT 'Name of the regulatory affairs representative responsible for managing the CPCN filing and PUC interactions.',
  `regulatory_contact_phone` STRING COMMENT 'Phone number of the regulatory affairs contact for inquiries regarding the CPCN application.',
  `responsible_business_unit` STRING COMMENT 'Name of the utility business unit or division responsible for the project and CPCN application.',
  `settlement_reached_flag` BOOLEAN COMMENT 'Indicates whether a settlement agreement was reached among the parties prior to a final commission decision.',
  `updated_by_user` STRING COMMENT 'User ID or name of the individual who last updated the CPCN application record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_cpcn_application` PRIMARY KEY (`cpcn_application_id`)
)
USING DELTA
COMMENT 'Master record for Certificate of Public Convenience and Necessity (CPCN) applications filed with state PUCs for major capital projects including new generation facilities, transmission line construction, substation upgrades, and large distribution infrastructure investments. Captures project description, estimated capital cost, applied-for certificate type, filing date, PUC docket number, environmental review status, public hearing schedule, commission order date, and certificate conditions. SSOT for major capital authorization proceedings. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CpcnApplication',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.cpcn_application'
);

-- IrpFiling  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`irp_filing` (
  `irp_filing_id` BIGINT NOT NULL COMMENT 'Unique identifier for the IRP filing record. Primary key.',
  `fuel_price_assumption_id` BIGINT COMMENT 'Foreign key linking to forecast.fuel_price_assumption. Business justification: IRP filings must document fuel price assumptions used in resource planning economic analysis. Regulatory transparency requirement - fuel costs drive LCOE calculations and portfolio optimization in pre',
  `lead_planner_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: IRP filings require employee lead planner accountability for integrated resource planning process. Replaces denormalized fields with FK to enable planning capacity management and succession planning.',
  `load_id` BIGINT COMMENT 'Foreign key linking to forecast.load. Business justification: IRP filings must cite the official load forecast used for planning horizon. Regulatory requirement for PUC approval - load forecast is foundational input to resource adequacy demonstration and capacit',
  `peak_demand_id` BIGINT COMMENT 'Foreign key linking to forecast.peak_demand. Business justification: IRP filings cite peak demand forecasts for capacity adequacy demonstrations and reserve margin calculations. Required for PUC approval of resource plans - peak demand drives capacity requirement deter',
  `planning_assumption_id` BIGINT COMMENT 'Foreign key linking to forecast.planning_assumption. Business justification: IRP filings reference load growth and other planning assumptions as foundational inputs to resource plan justification. PUC requires documentation of all key assumptions used in modeling for stakehold',
  `primary_capex_project_id` BIGINT COMMENT 'Foreign key linking to finance.capex_project. Business justification: Integrated Resource Plans identify future capital needs and preferred portfolios. While one IRP may reference multiple projects, linking to the primary/flagship project enables tracking plan-to-execut',
  `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: irp_filing is a specialized type of regulatory filing (IRP submissions to state PUCs). This represents a specialization relationship where irp_filing extends regulatory_filing with IRP-specific attrib',
  `action_plan_required_flag` BOOLEAN COMMENT 'Indicates whether the commission required the utility to submit an action plan or compliance filing following the IRP decision.',
  `active_flag` BOOLEAN COMMENT 'Indicates whether this IRP filing record is currently active and represents the most recent filing for the jurisdiction.',
  `baseline_carbon_emissions_tons` DECIMAL(18,2) COMMENT 'The baseline annual carbon emissions in metric tons used as the reference point for reduction targets.',
  `board_approval_date` DATE COMMENT 'The date the utility Board of Directors approved the IRP prior to regulatory filing.',
  `capital_investment_schedule` STRING COMMENT 'Year-by-year breakdown of planned capital investments for resource additions and infrastructure upgrades.',
  `carbon_reduction_target_percent` DECIMAL(5,2) COMMENT 'The target percentage reduction in carbon emissions by the end of the planning horizon relative to a baseline year.',
  `commission_approval_date` DATE COMMENT 'The date the regulatory commission issued its final order approving, rejecting, or modifying the IRP.',
  `commission_decision_summary` STRING COMMENT 'Summary of the regulatory commissions decision including any modifications, conditions, or directives imposed on the preferred portfolio.',
  `commission_order_number` STRING COMMENT 'The official order number issued by the regulatory commission for the IRP decision.',
  `confidential_filing_flag` BOOLEAN COMMENT 'Indicates whether portions of the IRP filing contain confidential or commercially sensitive information subject to protective order.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this IRP filing record was first created in the system.',
  `demand_response_target_mw` DECIMAL(15,2) COMMENT 'The target demand response capacity in megawatts to be achieved during the planning horizon.',
  `distribution_investment_usd` DECIMAL(18,2) COMMENT 'Estimated capital investment in US dollars for distribution system upgrades and expansions during the planning horizon.',
  `energy_efficiency_target_gwh` DECIMAL(15,2) COMMENT 'The target cumulative annual energy savings in gigawatt-hours from energy efficiency programs by the end of the planning horizon.',
  `executive_sponsor_name` STRING COMMENT 'Name of the executive sponsor or officer who authorized the IRP filing on behalf of the utility.',
  `filing_date` DATE COMMENT 'The date the IRP was officially submitted to the regulatory commission.',
  `filing_jurisdiction` STRING COMMENT 'The state or regulatory jurisdiction where the IRP is filed (e.g., state PUC code or name).',
  `filing_notes` STRING COMMENT 'Additional notes, comments, or context regarding the IRP filing, review process, or implementation status.',
  `filing_number` STRING COMMENT 'The official filing number or docket number assigned by the regulatory commission for this IRP submission.',
  `filing_status` STRING COMMENT 'Current status of the IRP filing in the regulatory review process. Valid values: draft|submitted|under_review|approved|rejected|withdrawn.',
  `generation_capacity_additions_mw` DECIMAL(15,2) COMMENT 'Total new generation capacity in megawatts to be added during the planning horizon.',
  `generation_retirements_mw` DECIMAL(15,2) COMMENT 'Total generation capacity in megawatts planned for retirement during the planning horizon.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this IRP filing record was last modified in the system.',
  `modeling_tools_used` STRING COMMENT 'List of analytical tools and software platforms used for IRP modeling and scenario analysis (e.g., PLEXOS, Aurora, PROMOD).',
  `next_filing_due_date` DATE COMMENT 'The date by which the next IRP filing is required to be submitted to the regulatory commission (typically 2-4 years from current filing).',
  `planning_horizon_end_year` INT COMMENT 'The final year of the planning horizon covered by this IRP (typically 10-20 years from start).',
  `planning_horizon_start_year` INT COMMENT 'The first year of the planning horizon covered by this IRP (typically the year following filing).',
  `planning_horizon_years` INT COMMENT 'Total number of years covered by the IRP planning horizon.',
  `preferred_portfolio_description` STRING COMMENT 'Detailed description of the preferred resource portfolio including resource types, capacities, and timing.',
  `preferred_portfolio_name` STRING COMMENT 'The name or identifier of the preferred resource portfolio selected by the utility.',
  `public_disclosure_url` STRING COMMENT 'Web URL where the public version of the IRP filing and supporting documents are published for stakeholder access.',
  `renewable_capacity_target_mw` DECIMAL(15,2) COMMENT 'The target renewable energy capacity in megawatts to be added during the planning horizon.',
  `renewable_energy_target_percent` DECIMAL(5,2) COMMENT 'The target percentage of total energy to be supplied by renewable resources by the end of the planning horizon.',
  `scenarios_evaluated_count` INT COMMENT 'The number of distinct resource portfolio scenarios evaluated in the IRP analysis.',
  `stakeholder_engagement_summary` STRING COMMENT 'Summary of stakeholder engagement activities conducted during IRP development including public meetings, advisory group sessions, and comment periods.',
  `total_capital_investment_usd` DECIMAL(18,2) COMMENT 'The total estimated capital investment in US dollars required to implement the preferred resource portfolio over the planning horizon.',
  `transmission_investment_usd` DECIMAL(18,2) COMMENT 'Estimated capital investment in US dollars for transmission system upgrades and expansions during the planning horizon.',
  `updated_by_user` STRING COMMENT 'User ID or name of the person who last updated this IRP filing record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_irp_filing` PRIMARY KEY (`irp_filing_id`)
)
USING DELTA
COMMENT 'Record of Integrated Resource Plan (IRP) filings submitted to state PUCs, capturing the planning horizon, load forecast assumptions, resource portfolio scenarios evaluated, preferred resource plan, renewable energy targets, demand response commitments, capital investment schedule, and commission approval status. IRPs are typically filed every 2-4 years and serve as the utility\'s long-term capacity and resource adequacy roadmap subject to regulatory review. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'IrpFiling',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.irp_filing'
);

-- PenaltyAssessment  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`penalty_assessment` (
  `penalty_assessment_id` BIGINT NOT NULL COMMENT 'Unique identifier for the penalty assessment record. Primary key.',
  `corrective_action_plan_id` BIGINT COMMENT 'Reference to the corrective action plan developed to address the violation and prevent recurrence.',
  `enforcement_action_id` BIGINT COMMENT 'Reference to the parent enforcement action that resulted in this penalty assessment.',
  `responsible_business_unit_org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Penalty assessments are allocated to organizational units for cost recovery and performance tracking. Replaces text field with FK to enable departmental penalty cost allocation and compliance performa',
  `assessment_date` DATE COMMENT 'The date the penalty was formally assessed by the regulatory body.',
  `board_notification_date` DATE COMMENT 'The date the Board of Directors was notified of this penalty assessment.',
  `board_notification_flag` BOOLEAN COMMENT 'Indicates whether this penalty assessment was reported to the Board of Directors due to materiality or strategic significance.',
  `compliance_history_factor` STRING COMMENT 'Whether the utility\'s compliance history was considered an aggravating, neutral, or mitigating factor in penalty calculation. Valid values: aggravating|neutral|mitigating.',
  `contest_filing_date` DATE COMMENT 'The date the utility filed a formal contest or appeal of the penalty.',
  `contest_outcome` STRING COMMENT 'The result of the penalty contest or appeal process. Valid values: upheld|reduced|dismissed|remanded|settled.',
  `contest_resolution_date` DATE COMMENT 'The date the contest or appeal was resolved by the regulatory body or court.',
  `contested_flag` BOOLEAN COMMENT 'Indicates whether the utility formally contested or appealed the penalty assessment.',
  `cooperation_credit_flag` BOOLEAN COMMENT 'Indicates whether the utility received a penalty reduction for cooperating with the investigation.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this penalty assessment record was first created in the system.',
  `final_penalty_assessed` DECIMAL(18,2) COMMENT 'The final penalty amount assessed after mitigation factors, settlement negotiations, or appeal decisions.',
  `financial_exposure_classification` STRING COMMENT 'Internal classification of the penalty\'s financial materiality for enterprise risk management and board reporting. Valid values: material|significant|moderate|minor.',
  `issuing_agency` STRING COMMENT 'The regulatory body that assessed the penalty. Valid values: NERC|FERC|EPA|PUC|OSHA|DOE.',
  `issuing_agency_region` STRING COMMENT 'The regional office or jurisdiction of the issuing agency, if applicable (e.g., NERC Regional Entity, EPA Region, State PUC).',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this penalty assessment record was last updated.',
  `mitigation_factors_applied` STRING COMMENT 'Comma-separated list or narrative description of mitigation factors that reduced the penalty (e.g., self-report credit, cooperation credit, compliance history, internal compliance program).',
  `modified_by_user` STRING COMMENT 'The user ID or name of the person who last modified this penalty assessment record.',
  `notes` STRING COMMENT 'Free-text field for additional context, internal analysis, or special circumstances related to the penalty assessment.',
  `payment_date` DATE COMMENT 'The actual date the penalty was paid by the utility.',
  `payment_due_date` DATE COMMENT 'The date by which the penalty payment must be submitted to the regulatory body.',
  `payment_method` STRING COMMENT 'The payment instrument used to remit the penalty to the regulatory body. Valid values: wire_transfer|check|ach|electronic_funds_transfer.',
  `payment_reference_number` STRING COMMENT 'The transaction or confirmation number for the penalty payment.',
  `penalty_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the penalty amount. Typically USD for US utilities. Valid values: USD|CAD|MXN.',
  `penalty_number` STRING COMMENT 'Business identifier for the penalty assessment, typically assigned by the regulatory body or internal compliance system.',
  `penalty_reduction_amount` DECIMAL(18,2) COMMENT 'The total amount by which the proposed penalty was reduced due to mitigation factors, calculated as proposed minus final.',
  `penalty_reduction_percent` DECIMAL(5,2) COMMENT 'The percentage reduction from proposed to final penalty amount.',
  `penalty_status` STRING COMMENT 'Current lifecycle status of the penalty assessment. Reference-value candidates: proposed|final|paid|contested|settled|appealed|waived.',
  `penalty_type` STRING COMMENT 'Classification of the penalty instrument assessed by the regulatory body. Valid values: civil_monetary_penalty|administrative_penalty|fine|sanction|forfeiture|citation.',
  `proposed_penalty_amount` DECIMAL(18,2) COMMENT 'The initial penalty amount proposed by the regulatory body before any mitigation, settlement, or appeal.',
  `public_disclosure_flag` BOOLEAN COMMENT 'Indicates whether the penalty assessment requires public disclosure under securities regulations or regulatory transparency requirements.',
  `public_disclosure_url` STRING COMMENT 'URL to the public disclosure document or regulatory posting of the penalty assessment.',
  `regulatory_correspondence_reference` STRING COMMENT 'Reference number or identifier for related regulatory correspondence regarding this penalty assessment.',
  `responsible_facility_code` STRING COMMENT 'The facility, plant, or asset identifier where the violation occurred, if applicable.',
  `self_report_credit_flag` BOOLEAN COMMENT 'Indicates whether the utility received a penalty reduction for self-reporting the violation.',
  `settlement_date` DATE COMMENT 'The date the settlement agreement was executed.',
  `settlement_flag` BOOLEAN COMMENT 'Indicates whether the penalty was resolved through a settlement agreement between the utility and regulatory body.',
  `settlement_terms` STRING COMMENT 'Summary of the key terms and conditions of the settlement agreement, including any non-monetary commitments.',
  `violated_standard_code` STRING COMMENT 'The specific regulatory standard, rule, or requirement that was violated (e.g., NERC CIP-007-6, 40 CFR Part 60, PUC Rule 25.95).',
  `violation_severity_level` STRING COMMENT 'The severity classification of the violation as determined by the regulatory body, used to calculate penalty amounts. Valid values: severe|high|moderate|minimal|lower.',
  `vrf` STRING COMMENT 'The risk factor assigned to the violated standard requirement, indicating the potential impact on bulk electric system reliability. Valid values: high|medium|lower.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_penalty_assessment` PRIMARY KEY (`penalty_assessment_id`)
)
USING DELTA
COMMENT 'Record of monetary penalties and sanctions assessed against the utility by regulatory bodies, including NERC civil monetary penalties (CMPs), FERC civil penalties, EPA administrative penalties, PUC fines, and OSHA citations with penalty amounts. Captures the associated enforcement action, penalty amount proposed, penalty amount final, payment due date, payment status, penalty mitigation factors applied, and whether the penalty was contested. SSOT for regulatory financial exposure tracking. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PenaltyAssessment',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.penalty_assessment'
);

-- ComplianceException  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`exception` (
  `exception_id` BIGINT NOT NULL COMMENT 'Primary key for exception',
  `corrective_action_plan_id` BIGINT COMMENT 'Foreign key reference to the formal corrective action plan (CAP) created to address this exception, if one was required.',
  `exception_obligation_id` BIGINT COMMENT 'Foreign key reference to the specific compliance obligation or regulatory standard associated with this exception.',
  `obligation_id` BIGINT COMMENT 'FK to compliance.obligation.obligation_id — Compliance exceptions are identified against specific obligations. This FK enables obligation-level exception tracking and feeds the self-report workflow.',
  `previous_exception_id` BIGINT COMMENT 'Foreign key reference to the prior exception record if this is a recurrence, enabling trend analysis and repeat-issue tracking.',
  `responsible_owner_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Compliance exceptions require employee ownership for remediation accountability. Replaces text field with FK to enable exception workload tracking, escalation paths, and performance management for com',
  `active_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether this exception record is currently active and open, or has been archived or closed.',
  `board_notification_date` DATE COMMENT 'Date on which the Board of Directors or executive leadership was notified of the exception, if applicable.',
  `board_reporting_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether this exception is material enough to require reporting to the Board of Directors or executive leadership.',
  `closure_date` DATE COMMENT 'Date on which the exception was formally closed after successful remediation and verification.',
  `closure_notes` STRING COMMENT 'Additional notes or comments documenting the closure rationale, lessons learned, or any residual considerations.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp indicating when this exception record was first created in the system.',
  `discovery_date` DATE COMMENT 'Date on which the compliance exception was identified or discovered through monitoring, audit, or operational review.',
  `discovery_method` STRING COMMENT 'Method or process by which the exception was discovered: internal audit, self-monitoring, control testing, employee report, management review, external audit, system alert, or operational review. Reference-value candidates: internal_audit|self_monitoring|control_testing|employee_report|management_review|external_audit|system_alert|operational_review.',
  `escalation_date` DATE COMMENT 'Date on which the exception was escalated to a higher authority or self-report process, if applicable.',
  `escalation_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether the exception has been escalated to senior management, legal, or regulatory self-report workflow due to severity or potential violation risk.',
  `estimated_financial_exposure` DECIMAL(18,2) COMMENT 'Estimated potential financial exposure or penalty amount in USD if the exception were to escalate to a formal violation or enforcement action.',
  `evidence_reference` STRING COMMENT 'Reference identifier or storage location for supporting evidence, documentation, or audit trail materials related to the exception discovery and remediation.',
  `exception_category` STRING COMMENT 'High-level regulatory or operational domain to which the exception pertains: reliability (NERC), cybersecurity (CIP), environmental (EPA), financial (SOX), safety (OSHA), operational, or reporting (FERC/PUC). Reference-value candidates: reliability|cybersecurity|environmental|financial|safety|operational|reporting.',
  `exception_description` STRING COMMENT 'Detailed narrative description of the compliance exception, including what was observed, the gap or deviation identified, and the context of the finding.',
  `exception_number` STRING COMMENT 'Business-facing unique identifier or tracking number assigned to the exception for reference in communications and reports.',
  `exception_status` STRING COMMENT 'Current lifecycle status of the exception: open, under investigation, remediation in progress, pending verification, closed, or escalated to enforcement action. Valid values: open|under_investigation|remediation_in_progress|pending_verification|closed|escalated.',
  `exception_type` STRING COMMENT 'Classification of the exception by nature: control gap, process deviation, documentation deficiency, system configuration error, training gap, near miss, policy violation, or procedural non-compliance. Reference-value candidates: control_gap|process_deviation|documentation_deficiency|system_configuration_error|training_gap|near_miss|policy_violation|procedural_non_compliance.',
  `facility_code` STRING COMMENT 'Code or identifier of the facility, plant, substation, or operational site where the exception was identified, if applicable.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp indicating when this exception record was last updated or modified.',
  `recurrence_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether this exception is a recurrence of a previously identified and closed exception.',
  `regulatory_correspondence_reference` STRING COMMENT 'Reference identifier linking this exception to any related regulatory correspondence, inquiries, or communications with regulatory bodies.',
  `regulatory_standard_code` STRING COMMENT 'Code or citation of the regulatory standard, requirement, or control that the exception relates to (e.g., CIP-007-6, FERC Order 1000, EPA 40 CFR Part 60).',
  `remediation_action_taken` STRING COMMENT 'Description of the corrective or remediation actions taken or planned to address and close the exception.',
  `remediation_completion_date` DATE COMMENT 'Actual date on which the remediation action was completed and verified.',
  `remediation_due_date` DATE COMMENT 'Target or required date by which the remediation action must be completed to close the exception.',
  `responsible_business_unit` STRING COMMENT 'Name or code of the business unit, department, or division responsible for addressing and remediating the exception.',
  `responsible_role` STRING COMMENT 'Job title or functional role of the responsible owner (e.g., Compliance Manager, Operations Supervisor, IT Security Lead).',
  `risk_severity` STRING COMMENT 'Assessment of the potential risk or impact severity of the exception if left unaddressed: critical, high, medium, low, or minimal. Valid values: critical|high|medium|low|minimal.',
  `root_cause_analysis` STRING COMMENT 'Summary of the root cause analysis performed to determine the underlying reason for the exception occurrence.',
  `self_report_required_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether the exception meets the criteria for mandatory self-reporting to a regulatory body (e.g., NERC, FERC, PUC).',
  `self_report_submission_date` DATE COMMENT 'Date on which the exception was formally self-reported to the applicable regulatory authority, if required.',
  `updated_by_user` STRING COMMENT 'User identifier or name of the individual who last modified this exception record, supporting audit trail and accountability.',
  `verification_date` DATE COMMENT 'Date on which the remediation was verified as complete and effective.',
  `verification_method` STRING COMMENT 'Method or process used to verify that the remediation action effectively closed the exception (e.g., re-test, document review, management attestation).',
  `verified_by` STRING COMMENT 'Name or identifier of the individual or team that performed the verification of remediation completion.',
  `vrf` STRING COMMENT 'NERC Violation Risk Factor classification indicating the potential reliability impact if the exception were to become a violation: high, medium, or lower. Valid values: high|medium|lower.',
  `vsl` STRING COMMENT 'NERC Violation Severity Level classification indicating the degree of non-compliance if the exception were to become a violation: severe, high, moderate, or lower. Valid values: severe|high|moderate|lower.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_exception` PRIMARY KEY (`exception_id`)
)
USING DELTA
COMMENT 'Record of identified compliance exceptions, gaps, or near-misses discovered through internal monitoring, control testing, or operational review before they become formal violations or enforcement actions. Captures exception type, associated obligation or standard, discovery date, discovery method (internal audit, self-monitoring, employee report), risk severity, business unit responsible, and remediation action taken. Supports a proactive compliance culture and feeds the self-report workflow when escalation is warranted. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ComplianceException',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.exception'
);

-- FercMarketReport  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`ferc_market_report` (
  `ferc_market_report_id` BIGINT NOT NULL COMMENT 'Unique identifier for the FERC market report submission record.',
  `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Each FERC market report fulfills a specific FERC reporting obligation (e.g., EQR quarterly transaction reporting, market behavior reporting). Many reports can fulfill one obligation (1:N). Adding obli',
  `original_report_ferc_market_report_id` BIGINT COMMENT 'Reference to the original FERC market report record that this submission amends or replaces, if this is an amendment filing.',
  `preparer_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: FERC market reports require employee preparer accountability for data accuracy. Replaces denormalized fields with FK to enable preparer workload tracking, authorization verification, and audit trail f',
  `acceptance_date` DATE COMMENT 'Date on which FERC formally accepted the market report submission as complete and compliant with filing requirements.',
  `affiliate_transaction_flag` BOOLEAN COMMENT 'Indicates whether the reported transaction involved an affiliated entity, requiring additional disclosure under FERC affiliate transaction rules.',
  `amendment_flag` BOOLEAN COMMENT 'Indicates whether this report is an amendment to a previously submitted FERC market report, correcting or updating prior information.',
  `authorized_representative_name` STRING COMMENT 'Name of the authorized company representative who certified and submitted the FERC market report on behalf of the utility.',
  `average_price_per_mwh` DECIMAL(12,4) COMMENT 'Weighted average price per megawatt-hour for the reported transactions, calculated as total transaction value divided by total volume.',
  `certification_date` DATE COMMENT 'Date on which the authorized representative certified the accuracy and completeness of the FERC market report data.',
  `confirmation_number` STRING COMMENT 'Unique confirmation number issued by the FERC eFiling system upon successful submission of the market report, serving as proof of filing.',
  `contract_term_end_date` DATE COMMENT 'Expiration or termination date of the underlying contract or agreement governing the reported transactions.',
  `contract_term_start_date` DATE COMMENT 'Effective start date of the underlying contract or agreement governing the reported transactions.',
  `contract_type` STRING COMMENT 'Classification of the contractual arrangement for the energy transaction. SPOT = short-term spot market; TERM = long-term contract; UNIT_CONTINGENT = contingent on specific generation unit; REQUIREMENTS = full requirements service; BLOCK = fixed block of energy; SHAPED = load-following or shaped delivery. Valid values: SPOT|TERM|UNIT_CONTINGENT|REQUIREMENTS|BLOCK|SHAPED.',
  `counterparty_category` STRING COMMENT 'Classification of the counterparty by business type. UTILITY = investor-owned utility; IPP = independent power producer; MARKETER = power marketer; AFFILIATE = affiliated entity; MUNICIPAL = municipal utility; COOPERATIVE = electric cooperative; ISO_RTO = independent system operator or regional transmission organization. Reference-value candidates: UTILITY|IPP|MARKETER|AFFILIATE|MUNICIPAL|COOPERATIVE|ISO_RTO.',
  `counterparty_name` STRING COMMENT 'Legal name of the counterparty entity involved in the reported wholesale energy transaction.',
  `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this FERC market report record was first created in the compliance management system.',
  `data_quality_indicator` STRING COMMENT 'Classification of the data quality and validation status of the reported market transaction data. VERIFIED = fully validated; ESTIMATED = contains estimated values; PRELIMINARY = subject to revision; CORRECTED = amended data. Valid values: VERIFIED|ESTIMATED|PRELIMINARY|CORRECTED.',
  `delivery_point` STRING COMMENT 'Physical or virtual location where energy was delivered under the reported transaction, may reference a substation, hub, or trading point.',
  `iso_rto_name` STRING COMMENT 'Name of the ISO or RTO that operated the organized market in which the transaction occurred, if applicable (e.g., PJM, CAISO, ERCOT, MISO, ISO-NE, NYISO, SPP).',
  `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this FERC market report record was most recently updated or modified.',
  `lmp_reference_node` STRING COMMENT 'Pricing node identifier where the Locational Marginal Price (LMP) was determined for this transaction, used in organized wholesale electricity markets.',
  `market_type` STRING COMMENT 'Classification of the energy market in which the reported transactions occurred. DAM = Day-Ahead Market; RTM = Real-Time Market; BILATERAL = bilateral contract outside organized markets; FORWARD = forward contract; CAPACITY = capacity market; ANCILLARY = ancillary services market. Valid values: DAM|RTM|BILATERAL|FORWARD|CAPACITY|ANCILLARY.',
  `mbr_authorization_code` STRING COMMENT 'FERC docket number or authorization code for the market-based rate authority under which the seller is authorized to make wholesale power sales.',
  `modified_by_user` STRING COMMENT 'User ID or name of the system user who last modified this FERC market report record, supporting audit trail and accountability.',
  `notes` STRING COMMENT 'Free-text field for additional explanatory notes, clarifications, or context regarding the FERC market report submission.',
  `receipt_point` STRING COMMENT 'Physical or virtual location where energy was received under the reported transaction, may reference a generation facility, hub, or trading point.',
  `rejection_reason` STRING COMMENT 'Explanation provided by FERC for rejecting the market report submission, if applicable, detailing deficiencies or non-compliance issues.',
  `report_number` STRING COMMENT 'External business identifier assigned to this FERC market report submission, used for tracking and correspondence with FERC.',
  `report_type` STRING COMMENT 'Type of FERC market report submission. EQR = Electric Quarterly Report for wholesale power transactions; FORM_552 = natural gas transaction reporting; MBR_TARIFF = market-based rate tariff filing; OATT_FILING = Open Access Transmission Tariff filing. Valid values: EQR|FORM_552|MBR_TARIFF|OATT_FILING|OTHER.',
  `reporting_period_end_date` DATE COMMENT 'Last date of the reporting period covered by this FERC market report, typically the end of a calendar quarter for EQR filings.',
  `reporting_period_start_date` DATE COMMENT 'First date of the reporting period covered by this FERC market report, typically the start of a calendar quarter for EQR filings.',
  `submission_date` TIMESTAMP COMMENT 'Date and time when this FERC market report was officially submitted to FERC via the eFiling system.',
  `submission_due_date` DATE COMMENT 'Regulatory deadline by which this FERC market report must be submitted to avoid late filing penalties, typically 30 days after quarter end for EQR.',
  `submission_status` STRING COMMENT 'Current lifecycle status of the FERC market report submission in the regulatory filing workflow. Valid values: DRAFT|SUBMITTED|ACCEPTED|REJECTED|AMENDED|WITHDRAWN.',
  `tariff_reference` STRING COMMENT 'Reference to the FERC-approved tariff or rate schedule under which the transaction was executed, if applicable.',
  `transaction_count` INT COMMENT 'Number of individual energy transactions aggregated and summarized in this FERC market report record.',
  `transaction_value_usd` DECIMAL(18,2) COMMENT 'Total monetary value of the reported energy transaction in United States dollars, including all charges and adjustments.',
  `transaction_volume_mwh` DECIMAL(18,3) COMMENT 'Total energy volume transacted in the reported period, measured in megawatt-hours (MWh). Represents the quantity of electric energy bought or sold.',
  `transmission_service_type` STRING COMMENT 'Classification of transmission service used to deliver the energy. FIRM = firm transmission; NON_FIRM = non-firm transmission; NETWORK = network integration transmission service; POINT_TO_POINT = point-to-point transmission service; NONE = no separate transmission service (e.g., within ISO/RTO). Valid values: FIRM|NON_FIRM|NETWORK|POINT_TO_POINT|NONE.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_ferc_market_report` PRIMARY KEY (`ferc_market_report_id`)
)
USING DELTA
COMMENT 'Transactional record of FERC-mandated market behavior and transaction reporting submissions, including Electric Quarterly Reports (EQR), FERC Form 552 (natural gas transactions), and market-based rate tariff filings. Captures reporting period, market type (DAM, RTM, bilateral), counterparty category, transaction volume (MWh), transaction value, LMP reference node, and submission confirmation number. Supports FERC market transparency and market-based rate authorization compliance. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'FercMarketReport',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.ferc_market_report'
);

-- ComplianceRiskAssessment  <<CIM RiskScore : broad>>
CREATE TABLE IF NOT EXISTS `compliance`.`compliance_risk_assessment` (
  `compliance_risk_assessment_id` BIGINT NOT NULL COMMENT 'Unique identifier for the compliance risk assessment record. Primary key.',
  `assessor_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Risk assessments require employee assessor accountability for risk evaluation quality. Replaces text field with FK to enable assessor workload tracking, assessment quality analysis, and risk assessmen',
  `audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: A compliance risk assessment may be conducted following an audit to evaluate residual risk and control effectiveness. Many risk assessments can be triggered by one audit (1:N). Adding audit_id FK link',
  `corrective_action_plan_id` BIGINT COMMENT 'Reference to the formal corrective action plan addressing the identified compliance risk, if one has been initiated.',
  `obligation_id` BIGINT COMMENT 'Reference to the specific regulatory obligation or compliance program area being assessed for risk.',
  `program_id` BIGINT COMMENT 'Reference to the compliance program under which this risk assessment is conducted.',
  `previous_compliance_risk_assessment_id` BIGINT COMMENT 'Self-referencing FK on compliance_risk_assessment (previous_compliance_risk_assessment_id)',
  `assessment_date` DATE COMMENT 'Date when the risk assessment was performed or completed. Used to track assessment currency and inform audit planning cycles.',
  `assessment_methodology` STRING COMMENT 'Methodology or framework used to conduct the risk assessment, ensuring consistency and repeatability across assessment cycles. Valid values: qualitative|quantitative|semi-quantitative|scenario-based|control-testing.',
  `assessment_notes` STRING COMMENT 'Additional commentary, context, or qualitative observations from the risk assessment that inform risk understanding and mitigation planning.',
  `assessment_number` STRING COMMENT 'Business identifier for the risk assessment, used for tracking and reference in audit documentation and Board reporting.',
  `assessment_period_end_date` DATE COMMENT 'End date of the period covered by this risk assessment, defining the temporal scope of risk evaluation.',
  `assessment_period_start_date` DATE COMMENT 'Start date of the period covered by this risk assessment, defining the temporal scope of risk evaluation.',
  `assessment_status` STRING COMMENT 'Current lifecycle status of the risk assessment record. Valid values: draft|in-review|approved|published|superseded.',
  `assessment_type` STRING COMMENT 'Classification of the risk assessment based on the trigger or schedule that initiated it. Valid values: initial|periodic|event-driven|post-incident|pre-audit|annual.',
  `assessor_department` STRING COMMENT 'Organizational department or business unit of the assessor, used for cross-functional risk assessment coordination.',
  `assessor_role` STRING COMMENT 'Job title or role of the assessor, indicating their qualifications and authority to perform the risk assessment.',
  `board_reporting_date` DATE COMMENT 'Date when this risk assessment was presented to the Board or Board committee, used for governance tracking.',
  `board_reporting_flag` BOOLEAN COMMENT 'Indicates whether this risk assessment is included in Board-level compliance risk reporting and heat maps, typically for high or critical residual risks.',
  `control_effectiveness_rating` STRING COMMENT 'Assessment of how effectively existing controls mitigate the identified compliance risk, based on testing and monitoring evidence. Valid values: ineffective|partially-effective|effective|highly-effective|not-applicable.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this risk assessment record was first created in the system, used for audit trail and data lineage.',
  `estimated_financial_exposure` DECIMAL(18,2) COMMENT 'Estimated potential financial impact if the compliance risk materializes, including penalties, fines, remediation costs, and business disruption.',
  `exposure_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the estimated financial exposure amount. Valid values: USD.',
  `external_auditor_review_flag` BOOLEAN COMMENT 'Indicates whether this risk assessment has been reviewed or relied upon by external auditors as part of their compliance audit procedures.',
  `inherent_risk_rating` STRING COMMENT 'Qualitative classification of inherent risk level before controls, used for risk heat map visualization and Board reporting. Valid values: very-low|low|medium|high|very-high|critical.',
  `inherent_risk_score` INT COMMENT 'Calculated risk score before considering the effect of controls, typically the product of likelihood and impact scores. Represents the raw exposure.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this risk assessment record was last updated, used for audit trail and change tracking.',
  `mitigation_plan_required_flag` BOOLEAN COMMENT 'Indicates whether a formal mitigation plan is required based on the residual risk level exceeding acceptable thresholds.',
  `mitigation_plan_status` STRING COMMENT 'Current status of any required risk mitigation plan, used to track remediation progress and escalate overdue actions. Valid values: not-required|planned|in-progress|completed|overdue.',
  `next_assessment_due_date` DATE COMMENT 'Scheduled date for the next periodic risk assessment, based on assessment frequency requirements and risk level.',
  `regulatory_framework` STRING COMMENT 'Primary regulatory framework or standard under which the compliance obligation is assessed for risk. Reference-value candidates: NERC.',
  `residual_risk_rating` STRING COMMENT 'Qualitative classification of residual risk level after controls, used for risk acceptance decisions and audit planning prioritization. Valid values: very-low|low|medium|high|very-high|critical.',
  `residual_risk_score` INT COMMENT 'Calculated risk score after considering the mitigating effect of controls. Represents the net exposure and drives prioritization of compliance resources.',
  `responsible_business_unit` STRING COMMENT 'Business unit or division accountable for managing the identified compliance risk and implementing mitigation actions.',
  `responsible_owner_name` STRING COMMENT 'Name of the individual designated as the risk owner, accountable for monitoring and managing the compliance risk.',
  `review_date` DATE COMMENT 'Date when the risk assessment was reviewed and approved by the designated reviewer or compliance officer.',
  `reviewer_name` STRING COMMENT 'Name of the individual who reviewed and approved the risk assessment, providing oversight and quality assurance.',
  `risk_appetite_threshold` STRING COMMENT 'Indicator of whether the residual risk level is within the organizations defined risk appetite for this compliance area. Valid values: within-appetite|approaching-threshold|exceeds-appetite.',
  `risk_factors_considered` STRING COMMENT 'Summary of key risk factors and variables considered in the assessment, such as historical violations, control gaps, regulatory changes, or operational complexity.',
  `risk_impact_rating` STRING COMMENT 'Qualitative assessment of the severity of consequences if a compliance violation occurs, considering financial, operational, and reputational impacts. Valid values: very-low|low|medium|high|very-high.',
  `risk_impact_score` INT COMMENT 'Numeric score representing the severity of impact if compliance risk materializes, typically on a 1-5 scale, used for quantitative risk ranking.',
  `risk_likelihood_rating` STRING COMMENT 'Qualitative assessment of the probability that a compliance violation or gap will occur within the assessment period. Valid values: very-low|low|medium|high|very-high.',
  `risk_likelihood_score` INT COMMENT 'Numeric score representing the likelihood of compliance risk occurrence, typically on a 1-5 scale, used for quantitative risk ranking.',
  `risk_response_strategy` STRING COMMENT 'Recommended or approved strategy for managing the identified compliance risk, aligned with enterprise risk management framework. Valid values: accept|mitigate|transfer|avoid.',
  `risk_trend_direction` STRING COMMENT 'Directional indicator of how the risk profile is changing over time compared to prior assessments, used for Board-level risk trend reporting. Valid values: increasing|stable|decreasing|new.',
  `updated_by_user` STRING COMMENT 'User ID or name of the individual who last modified this risk assessment record, providing accountability for changes.',
  `vrf` STRING COMMENT 'NERC Violation Risk Factor classification indicating the potential impact of a violation on bulk electric system reliability, used for NERC CIP risk assessments. Valid values: lower|medium|high.',
  `vsl` STRING COMMENT 'NERC Violation Severity Level classification indicating the degree of non-compliance with a reliability standard requirement, used for penalty assessment estimation. Valid values: lower|moderate|high|severe.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_compliance_risk_assessment` PRIMARY KEY (`compliance_risk_assessment_id`)
)
USING DELTA
COMMENT 'Periodic compliance risk assessment record capturing risk scoring of each regulatory obligation or compliance program area. Records risk likelihood, impact severity, residual risk after controls, risk trend direction, assessment methodology, assessor, and assessment date. Used to prioritize compliance monitoring resources, inform audit planning, and support Board-level risk heat maps. Covers NERC CIP risk assessments, environmental compliance risk reviews, and enterprise compliance risk rankings required by most utility compliance frameworks. | CMM: CIM RiskScore (broad), IEC61968::Assets.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ComplianceRiskAssessment',
  'cmm.cim.class' = 'RiskScore',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61968::Assets',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.compliance_risk_assessment'
);

-- AuditScope  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`audit_scope` (
  `audit_scope_id` BIGINT NOT NULL COMMENT 'Unique identifier for this audit scope assignment record. Primary key.',
  `audit_id` BIGINT COMMENT 'Foreign key to compliance.audit identifying the audit that includes this organizational unit',
  `org_unit_id` BIGINT COMMENT 'Foreign key to workforce.org_unit identifying the organizational unit in scope for this audit',
  `unit_coordinator_employee_id` BIGINT COMMENT 'Employee identifier of the person from this organizational unit responsible for coordinating audit activities and evidence submission for their unit',
  `audit_hours` DECIMAL(10,2) COMMENT 'Total audit effort hours spent by auditors examining this organizational unit during this audit',
  `end_date` DATE COMMENT 'Date when audit activities concluded for this specific organizational unit',
  `findings_count` INT COMMENT 'Number of audit findings or violations identified specifically for this organizational unit within this audit',
  `scope_description` STRING COMMENT 'Detailed description of what aspects of this organizational unit are included in the audit scope (e.g., NERC CIP controls for transmission operations, SOX financial controls for accounting department)',
  `scope_status` STRING COMMENT 'Current status of audit activities for this organizational unit within the overall audit lifecycle',
  `start_date` DATE COMMENT 'Date when audit activities commenced for this specific organizational unit',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_audit_scope` PRIMARY KEY (`audit_scope_id`)
)
USING DELTA
COMMENT 'This association product represents the scoping relationship between organizational units and compliance audits. It captures which organizational units are included in each audit\'s scope, along with audit-specific metrics for that unit including findings count, audit effort hours, and the specific scope description for that unit. Each record links one org_unit to one audit with attributes that exist only in the context of this scoping relationship.. Existence Justification: In energy utility compliance operations, audits routinely scope multiple organizational units (e.g., a NERC CIP audit may cover Generation, Transmission, and Distribution units), and each organizational unit undergoes multiple audits annually from different regulatory bodies (NERC, FERC, PUC, EPA, SOX). The scoping relationship is actively managed by audit coordinators who track findings, audit hours, and scope descriptions specific to each org_unit-audit combination. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AuditScope',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.audit_scope'
);

-- ComplianceViolation  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`violation` (
  `violation_id` BIGINT NOT NULL COMMENT 'Primary key for violation',
  `location_id` BIGINT COMMENT 'Identifier of the physical location (plant, substation, facility) where the violation occurred.',
  `party_id` BIGINT COMMENT 'Identifier of the party (person or organization) responsible for or associated with the violation.',
  `registry_id` BIGINT COMMENT 'Identifier of the asset (equipment, line, generator) implicated in the violation.',
  `related_violation_id` BIGINT COMMENT 'Self-referencing FK on violation (related_violation_id)',
  `appeal_deadline` DATE COMMENT 'Final date by which an appeal must be filed.',
  `audit_trail` STRING COMMENT 'Free-text log of audit notes, investigations, and evidentiary references.',
  `compliance_status` STRING COMMENT 'Current compliance posture related to the violation.',
  `corrective_action_plan` STRING COMMENT 'Description of the corrective actions required to remediate the violation.',
  `description` STRING COMMENT 'Narrative description of the violation, including facts and observations.',
  `effective_date` DATE COMMENT 'Date on which the penalty becomes enforceable.',
  `event_timestamp` TIMESTAMP COMMENT 'Date and time when the violation event occurred.',
  `is_appealed` BOOLEAN COMMENT 'Indicates whether the penalty or finding has been appealed.',
  `is_reported` BOOLEAN COMMENT 'Indicates whether the violation has been formally reported to the regulator.',
  `penalty_amount` DECIMAL(15,2) COMMENT 'Monetary fine or penalty assessed for the violation (gross amount).',
  `penalty_currency` STRING COMMENT 'ISO 4217 currency code for the penalty amount.',
  `penalty_type` STRING COMMENT 'Classification of the monetary penalty (e.g., fine, fee, restitution).',
  `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the violation record was first created in the system.',
  `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the violation record.',
  `regulation_code` STRING COMMENT 'Code of the specific regulation or standard that was violated (e.g., NERC-CIP-002).',
  `regulatory_body` STRING COMMENT 'Name of the governing agency that issued the violation (e.g., NERC, FERC, EPA).',
  `report_submission_date` DATE COMMENT 'Date the violation report was submitted to the regulatory body.',
  `resolution_date` DATE COMMENT 'Date when the violation was resolved or closed.',
  `severity` STRING COMMENT 'Severity rating assigned to the violation reflecting potential impact.',
  `source_system` STRING COMMENT 'Name of the source application or system that originated the violation record.',
  `status` STRING COMMENT 'Current lifecycle state of the violation.',
  `violation_number` STRING COMMENT 'External reference number assigned to the violation by the regulatory body or internal tracking system.',
  `violation_type` STRING COMMENT 'Category of the violation based on regulatory domain.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_violation` PRIMARY KEY (`violation_id`)
)
USING DELTA
COMMENT 'Master reference table for violation. Referenced by violation_id. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ComplianceViolation',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.violation'
);

-- BesFacility  <<CIM PowerSystemResource : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`bes_facility` (
  `bes_facility_id` BIGINT NOT NULL COMMENT 'Primary key for bes_facility',
  `parent_bes_facility_id` BIGINT COMMENT 'Self-referencing FK on bes_facility (parent_bes_facility_id)',
  `capacity_mw` DECIMAL(10,2) COMMENT 'Maximum electrical generation or transmission capacity of the facility in megawatts.',
  `city` STRING COMMENT 'City where the facility is located.',
  `commissioning_date` DATE COMMENT 'Date the facility entered service.',
  `compliance_status` STRING COMMENT 'Current compliance standing of the facility with applicable regulations.',
  `country_code` STRING COMMENT 'ISO-3166-1 alpha-3 country code for the facility location. Reference-value candidates: USA|CAN|MEX|GBR|FRA|DEU|CHN|IND|BRA|AUS.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the facility record was first created in the system.',
  `data_source_system` STRING COMMENT 'Name of the source operational system that supplied the facility record.',
  `description` STRING COMMENT 'Free-form text describing the facility\'s purpose, characteristics, or notes.',
  `emission_factor_tco2_per_mwh` DECIMAL(12,4) COMMENT 'Average carbon dioxide emissions per megawatt-hour produced at the facility.',
  `facility_code` STRING COMMENT 'Unique alphanumeric code assigned to the facility by the enterprise.',
  `facility_name` STRING COMMENT 'Human-readable name of the facility.',
  `facility_type` STRING COMMENT 'Category of the facility indicating its role in the electric system.',
  `fuel_type` STRING COMMENT 'Primary energy source used by the facility (e.g., coal, gas, solar, wind, hydro, nuclear, biomass, geothermal, other). Reference-value candidates: coal|gas|nuclear|solar|wind|hydro|biomass|geothermal|other.',
  `grid_connection_point` STRING COMMENT 'Identifier of the point where the facility connects to the transmission grid.',
  `inspection_status` STRING COMMENT 'Result of the most recent inspection.',
  `is_critical_infrastructure` BOOLEAN COMMENT 'True if the facility is designated as critical infrastructure under NERC CIP.',
  `last_inspection_date` DATE COMMENT 'Date of the most recent regulatory or safety inspection.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude of the facility in decimal degrees.',
  `location_address` STRING COMMENT 'Physical street address of the facility.',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude of the facility in decimal degrees.',
  `maintenance_contact_email` STRING COMMENT 'Email address of the primary maintenance contact for the facility.',
  `maintenance_contact_phone` STRING COMMENT 'Phone number of the primary maintenance contact for the facility.',
  `operating_company` STRING COMMENT 'Company responsible for day-to-day operation of the facility.',
  `owner_organization` STRING COMMENT 'Legal entity that owns the facility.',
  `permit_expiration_date` DATE COMMENT 'Date the regulatory permit expires.',
  `regulatory_permit_number` STRING COMMENT 'Identifier of the primary environmental or safety permit governing the facility.',
  `retirement_date` DATE COMMENT 'Date the facility was permanently taken out of service, if applicable.',
  `state_province` STRING COMMENT 'State or province of the facility location.',
  `status` STRING COMMENT 'Current operational status of the facility.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the facility record.',
  `voltage_level_kv` DECIMAL(6,2) COMMENT 'Nominal voltage level at which the facility operates.',
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
  CONSTRAINT `pk_compliance_bes_facility` PRIMARY KEY (`bes_facility_id`)
)
USING DELTA
COMMENT 'Master reference table for bes_facility. Referenced by bes_facility_id. | CMM: CIM PowerSystemResource (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'BesFacility',
  'cmm.cim.class' = 'PowerSystemResource',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.bes_facility',
  'cmm.gis.location.role' = 'PowerSystemResource.Location'
);

-- ElectronicSecurityPerimeter  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`electronic_security_perimeter` (
  `electronic_security_perimeter_id` BIGINT NOT NULL COMMENT 'Primary key for electronic_security_perimeter',
  `parent_electronic_security_perimeter_id` BIGINT COMMENT 'Self-referencing FK on electronic_security_perimeter (parent_electronic_security_perimeter_id)',
  `audit_status` STRING COMMENT 'Result of the latest audit for the perimeter.',
  `compliance_framework` STRING COMMENT 'Regulatory framework(s) governing this perimeter.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the perimeter record was first created in the system.',
  `description` STRING COMMENT 'Free-form description of the perimeter\'s purpose, boundaries, and key characteristics.',
  `effective_end_date` DATE COMMENT 'Date when the perimeter was retired or its controls were de-commissioned (null if still active).',
  `effective_start_date` DATE COMMENT 'Date when the perimeter became operational and subject to compliance controls.',
  `intrusion_detection_capability` STRING COMMENT 'Level of intrusion detection technology deployed in the perimeter.',
  `is_physical` BOOLEAN COMMENT 'Indicates whether the perimeter is a physical boundary (true) or a logical/virtual boundary (false).',
  `last_audit_date` DATE COMMENT 'Date of the most recent compliance audit performed on the perimeter.',
  `max_allowed_voltage_kv` DECIMAL(10,2) COMMENT 'Maximum voltage level permitted within the perimeter, used for safety and compliance calculations.',
  `network_segment` STRING COMMENT 'Logical network segment identifier associated with the perimeter.',
  `notes` STRING COMMENT 'Additional remarks, exceptions, or operational notes related to the perimeter.',
  `perimeter_code` STRING COMMENT 'Business-assigned code used to reference the perimeter in regulatory filings and internal systems.',
  `perimeter_name` STRING COMMENT 'Human-readable name of the security perimeter.',
  `perimeter_type` STRING COMMENT 'Category of the perimeter based on its physical or logical scope.',
  `protection_level` STRING COMMENT 'Overall protection level assigned to the perimeter based on risk assessment.',
  `security_classification` STRING COMMENT 'Classification indicating the sensitivity level of the perimeter\'s data and controls.',
  `status` STRING COMMENT 'Current lifecycle status of the perimeter.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the perimeter record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_electronic_security_perimeter` PRIMARY KEY (`electronic_security_perimeter_id`)
)
USING DELTA
COMMENT 'Master reference table for electronic_security_perimeter. Referenced by electronic_security_perimeter_id. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ElectronicSecurityPerimeter',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.electronic_security_perimeter'
);

-- PhysicalSecurityPerimeter  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`physical_security_perimeter` (
  `physical_security_perimeter_id` BIGINT NOT NULL COMMENT 'Primary key for physical_security_perimeter',
  `parent_physical_security_perimeter_id` BIGINT COMMENT 'Self-referencing FK on physical_security_perimeter (parent_physical_security_perimeter_id)',
  `access_point_count` INT COMMENT 'Number of controlled entry/exit points on the perimeter.',
  `alarm_enabled` BOOLEAN COMMENT 'Indicates whether an intrusion alarm is installed and active.',
  `authorized_personnel_count` INT COMMENT 'Count of personnel authorized to access the perimeter.',
  `breach_count` INT COMMENT 'Total number of security breaches recorded for this perimeter.',
  `breach_last_timestamp` TIMESTAMP COMMENT 'Date-time of the most recent breach incident.',
  `camera_coverage` BOOLEAN COMMENT 'True if video surveillance cameras cover the perimeter.',
  `city` STRING COMMENT 'City where the perimeter is situated.',
  `compliance_standard` STRING COMMENT 'Regulatory or industry standard governing this perimeter.',
  `compliance_status` STRING COMMENT 'Current compliance posture of the perimeter.',
  `contact_email` STRING COMMENT 'Email address for the perimeter owner or point of contact.',
  `contact_phone` STRING COMMENT 'Phone number for the perimeter owner or point of contact.',
  `country_code` STRING COMMENT 'Three-letter ISO country code where the perimeter is located.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the perimeter record was first created in the system.',
  `effective_end_date` DATE COMMENT 'Date when the perimeter is scheduled to be retired or decommissioned (nullable).',
  `effective_start_date` DATE COMMENT 'Date when the perimeter became operational or effective.',
  `external_reference_code` STRING COMMENT 'Identifier used in external systems to reference this perimeter.',
  `inspection_status` STRING COMMENT 'Result of the latest inspection.',
  `is_monitored` BOOLEAN COMMENT 'Indicates whether the perimeter is actively monitored by a security operations center.',
  `last_inspection_timestamp` TIMESTAMP COMMENT 'Date-time of the most recent security inspection.',
  `latitude` DECIMAL(10,7) COMMENT 'Latitude coordinate of the perimeter centre point in decimal degrees.',
  `location_description` STRING COMMENT 'Free-form description of the geographic location (e.g., "North Substation, Zone A").',
  `longitude` DECIMAL(10,7) COMMENT 'Longitude coordinate of the perimeter centre point in decimal degrees.',
  `maintenance_frequency_days` INT COMMENT 'Number of days between routine maintenance events.',
  `maintenance_schedule_description` STRING COMMENT 'Narrative of the planned maintenance activities and cadence.',
  `monitoring_system_name` STRING COMMENT 'Name of the monitoring platform (e.g., SCADA, SIEM).',
  `monitoring_system_version` STRING COMMENT 'Version of the monitoring platform software.',
  `name` STRING COMMENT 'Human-readable name of the security perimeter (e.g., "North Substation Fence").',
  `notes` STRING COMMENT 'Free-form comments or observations about the perimeter.',
  `owner_department` STRING COMMENT 'Internal department responsible for the perimeter.',
  `perimeter_area_sq_m` DECIMAL(12,2) COMMENT 'Enclosed area covered by the perimeter in square meters.',
  `perimeter_code` STRING COMMENT 'External code used in operational systems to reference the perimeter.',
  `perimeter_length_m` DECIMAL(10,2) COMMENT 'Total linear length of the perimeter measured in meters.',
  `perimeter_type` STRING COMMENT 'Category of the physical barrier (fence, wall, electronic, natural).',
  `region` STRING COMMENT 'State or province name for the perimeter location.',
  `risk_rating` STRING COMMENT 'Risk rating based on security assessments.',
  `security_level` STRING COMMENT 'Risk-based security classification assigned to the perimeter.',
  `source_system` STRING COMMENT 'Name of the source system that supplied the record.',
  `status` STRING COMMENT 'Current operational status of the perimeter.',
  `updated_by` STRING COMMENT 'User or system identifier that performed the latest update.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the perimeter record.',
  `created_by` STRING COMMENT 'User or system identifier that created the record.',
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
  CONSTRAINT `pk_compliance_physical_security_perimeter` PRIMARY KEY (`physical_security_perimeter_id`)
)
USING DELTA
COMMENT 'Master reference table for physical_security_perimeter. Referenced by physical_security_perimeter_id. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PhysicalSecurityPerimeter',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.physical_security_perimeter',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- CyberSecurityIncidentResponsePlan  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`cyber_security_incident_response_plan` (
  `cyber_security_incident_response_plan_id` BIGINT NOT NULL COMMENT 'Primary key for cyber_security_incident_response_plan',
  `employee_id` BIGINT COMMENT 'Identifier of the primary owner responsible for the plan.',
  `superseded_cyber_security_incident_response_plan_id` BIGINT COMMENT 'Self-referencing FK on cyber_security_incident_response_plan (superseded_cyber_security_incident_response_plan_id)',
  `approval_date` DATE COMMENT 'Date when the plan was approved.',
  `approval_status` STRING COMMENT 'Current approval status of the plan.',
  `attached_document_ids` STRING COMMENT 'Comma-separated list of identifiers for documents attached to the plan.',
  `communication_channels` STRING COMMENT 'Preferred channels for incident communication.',
  `compliance_status` STRING COMMENT 'Current compliance status of the plan with applicable regulations.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the plan record was created in the system.',
  `effective_from` DATE COMMENT 'Date when the plan becomes effective.',
  `effective_until` DATE COMMENT 'Date when the plan expires or is superseded, if applicable.',
  `escalation_procedure` STRING COMMENT 'Procedural steps for escalating incidents to higher authority levels.',
  `incident_type` STRING COMMENT 'Types of cyber security incidents addressed by the plan.',
  `last_review_date` DATE COMMENT 'Date of the most recent review of the plan.',
  `next_review_date` DATE COMMENT 'Scheduled date for the next plan review.',
  `plan_code` STRING COMMENT 'External reference code for the plan used in regulatory filings.',
  `plan_name` STRING COMMENT 'Descriptive name of the incident response plan.',
  `plan_status` STRING COMMENT 'Current lifecycle status of the plan.',
  `plan_type` STRING COMMENT 'Category of the incident response plan based on regulatory or internal classification.',
  `plan_version` STRING COMMENT 'Version identifier of the plan.',
  `regulatory_reference` STRING COMMENT 'Reference to applicable regulations (e.g., NERC CIP, FERC) governing the plan.',
  `response_time_target_minutes` INT COMMENT 'Target maximum time in minutes to initiate response after incident detection.',
  `responsible_team` STRING COMMENT 'Team accountable for maintaining the plan.',
  `risk_rating` STRING COMMENT 'Overall risk rating associated with the plan\'s effectiveness.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the plan record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_cyber_security_incident_response_plan` PRIMARY KEY (`cyber_security_incident_response_plan_id`)
)
USING DELTA
COMMENT 'Master reference table for cyber_security_incident_response_plan. Referenced by cyber_security_incident_response_plan_id. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CyberSecurityIncidentResponsePlan',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.cyber_security_incident_response_plan'
);

-- RecoveryPlan  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`recovery_plan` (
  `recovery_plan_id` BIGINT NOT NULL COMMENT 'Primary key for recovery_plan',
  `responsible_party_id` BIGINT COMMENT 'Identifier of the internal party responsible for the plan.',
  `superseded_recovery_plan_id` BIGINT COMMENT 'Self-referencing FK on recovery_plan (superseded_recovery_plan_id)',
  `approval_date` DATE COMMENT 'Date when the recovery plan was approved.',
  `approved_by` STRING COMMENT 'Name or identifier of the person who approved the recovery plan.',
  `audit_status` STRING COMMENT 'Result of the latest audit of the recovery plan.',
  `backup_location` STRING COMMENT 'Physical or logical location where backups are stored.',
  `backup_method` STRING COMMENT 'Method used for backing up data for recovery.',
  `communication_plan` STRING COMMENT 'Outline of communication procedures during a recovery event.',
  `compliance_status` STRING COMMENT 'Current compliance status of the recovery plan with regulatory requirements.',
  `contingency_actions` STRING COMMENT 'Defined actions to be taken if primary recovery steps fail.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the recovery plan record was first created in the system.',
  `criticality` STRING COMMENT 'Business criticality of the systems covered by the plan.',
  `effective_end_date` DATE COMMENT 'Date when the recovery plan expires or is superseded; null if open-ended.',
  `effective_start_date` DATE COMMENT 'Date when the recovery plan becomes effective.',
  `is_active` BOOLEAN COMMENT 'Indicates whether the recovery plan is currently active.',
  `last_tested_date` DATE COMMENT 'Date when the recovery plan was last exercised or tested.',
  `next_test_due_date` DATE COMMENT 'Planned date for the next recovery plan test.',
  `plan_code` STRING COMMENT 'External reference code for the recovery plan used in regulatory filings.',
  `plan_description` STRING COMMENT 'Detailed description of the recovery plan objectives and scope.',
  `plan_name` STRING COMMENT 'Human readable name of the recovery plan.',
  `plan_type` STRING COMMENT 'Category of the recovery plan.',
  `recovery_point_objective_hours` DECIMAL(10,2) COMMENT 'Maximum tolerable data loss period, expressed in hours.',
  `recovery_time_objective_hours` DECIMAL(10,2) COMMENT 'Target maximum time to restore services after disruption, expressed in hours.',
  `risk_level` STRING COMMENT 'Risk classification associated with the plan\'s failure.',
  `status` STRING COMMENT 'Current lifecycle status of the plan.',
  `test_frequency_days` INT COMMENT 'Number of days between scheduled recovery plan tests.',
  `test_results_summary` STRING COMMENT 'Brief summary of outcomes and findings from the most recent test.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the recovery plan record.',
  `version_number` INT COMMENT 'Incremental version number of the recovery plan.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_recovery_plan` PRIMARY KEY (`recovery_plan_id`)
)
USING DELTA
COMMENT 'Master reference table for recovery_plan. Referenced by recovery_plan_id. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'RecoveryPlan',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.recovery_plan'
);

-- BaselineConfiguration  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`baseline_configuration` (
  `baseline_configuration_id` BIGINT NOT NULL COMMENT 'Primary key for baseline_configuration',
  `superseded_baseline_configuration_id` BIGINT COMMENT 'Self-referencing FK on baseline_configuration (superseded_baseline_configuration_id)',
  `approval_status` STRING COMMENT 'Current approval state of the configuration.',
  `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when the configuration was approved.',
  `archive_flag` BOOLEAN COMMENT 'Indicates whether the configuration has been archived.',
  `baseline_value` DECIMAL(18,4) COMMENT 'Primary quantitative value defined by the configuration (e.g., threshold limit, capacity).',
  `compliance_area` STRING COMMENT 'Regulatory domain the baseline configuration supports (e.g., NERC CIP, FERC, EPA, SOX, CPCN).',
  `config_code` STRING COMMENT 'Business identifier code for the baseline configuration, used in regulatory filings and internal references.',
  `config_name` STRING COMMENT 'Human-readable name describing the configuration baseline.',
  `config_type` STRING COMMENT 'Category of the configuration (e.g., security, environment, operational, financial).',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the baseline configuration record was first created.',
  `description` STRING COMMENT 'Detailed description of the configuration purpose and scope.',
  `effective_from` DATE COMMENT 'Date when the configuration becomes effective for compliance reporting.',
  `effective_until` DATE COMMENT 'Date when the configuration ceases to be effective; null for open-ended configurations.',
  `is_mandatory` BOOLEAN COMMENT 'Indicates whether compliance with this baseline is mandatory.',
  `jurisdiction` STRING COMMENT 'Three-letter ISO country code indicating the jurisdiction of the regulation.',
  `last_review_date` DATE COMMENT 'Date when the configuration was last reviewed for compliance relevance.',
  `notes` STRING COMMENT 'Free-form notes or comments about the configuration.',
  `regulatory_body` STRING COMMENT 'Governing authority responsible for the compliance area.',
  `retention_period_days` INT COMMENT 'Number of days the configuration record must be retained for audit purposes.',
  `review_cycle` STRING COMMENT 'Frequency at which the configuration must be reviewed.',
  `source_system` STRING COMMENT 'Originating system that supplied the baseline configuration data.',
  `status` STRING COMMENT 'Current lifecycle status of the configuration.',
  `threshold_unit` STRING COMMENT 'Unit of measure for the threshold value.',
  `threshold_value` DECIMAL(18,4) COMMENT 'Numeric threshold that must not be exceeded according to the baseline.',
  `unit_of_measure` STRING COMMENT 'Unit associated with the baseline value.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the baseline configuration.',
  `version_number` STRING COMMENT 'Version identifier for the configuration (e.g., v1.0, v2.1).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_baseline_configuration` PRIMARY KEY (`baseline_configuration_id`)
)
USING DELTA
COMMENT 'Master reference table for baseline_configuration. Referenced by baseline_configuration_id. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'BaselineConfiguration',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.baseline_configuration'
);

-- AttestationDocument  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`attestation_document` (
  `attestation_document_id` BIGINT NOT NULL COMMENT 'Primary key for attestation_document',
  `superseded_attestation_document_id` BIGINT COMMENT 'Self-referencing FK on attestation_document (superseded_attestation_document_id)',
  `attachment_path` STRING COMMENT 'File system or object-store path where the attestation PDF/scan is stored.',
  `audit_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the attestation record was first created in the data lake.',
  `audit_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the attestation record.',
  `checksum` STRING COMMENT 'SHA-256 checksum of the document file for integrity verification.',
  `compliance_area` STRING COMMENT 'Regulatory domain or program to which the attestation applies.',
  `description` STRING COMMENT 'Free-form description summarizing the purpose and scope of the attestation.',
  `document_number` STRING COMMENT 'External reference number or code assigned to the attestation document by the issuing authority.',
  `document_type` STRING COMMENT 'Category of the attestation document indicating the regulatory framework it addresses.',
  `effective_date` DATE COMMENT 'Date on which the attestation becomes effective.',
  `expiration_date` DATE COMMENT 'Date on which the attestation expires or is no longer valid (nullable for open-ended attestations).',
  `file_size_bytes` BIGINT COMMENT 'Size of the stored document file in bytes.',
  `is_confidential` BOOLEAN COMMENT 'Indicates whether the document contains confidential information requiring restricted handling.',
  `issued_by` STRING COMMENT 'Name of the organization or department that issued the attestation.',
  `issued_date` DATE COMMENT 'Date the attestation document was formally issued.',
  `related_regulation` STRING COMMENT 'Identifier of the specific regulation, standard, or rule referenced by the attestation.',
  `signed_by` STRING COMMENT 'Name of the individual who signed the attestation.',
  `signed_date` DATE COMMENT 'Date the attestation was signed by the authorized signatory.',
  `status` STRING COMMENT 'Current lifecycle state of the attestation document.',
  `title` STRING COMMENT 'Human-readable title of the attestation document.',
  `version_number` STRING COMMENT 'Version identifier of the document, incremented on each revision.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_attestation_document` PRIMARY KEY (`attestation_document_id`)
)
USING DELTA
COMMENT 'Master reference table for attestation_document. Referenced by attestation_document_id. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'AttestationDocument',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.attestation_document'
);

-- TrainingCourse  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `compliance`.`training_course` (
  `training_course_id` BIGINT NOT NULL COMMENT 'Primary key for training_course',
  `compliance_document_id` BIGINT COMMENT 'Identifier of the compliance document associated with the course.',
  `prerequisite_training_course_id` BIGINT COMMENT 'Self-referencing FK on training_course (prerequisite_training_course_id)',
  `category` STRING COMMENT 'Business classification grouping for the course (e.g., safety, technical, regulatory).',
  `compliance_approval_status` STRING COMMENT 'Regulatory compliance approval state for the course content.',
  `course_code` STRING COMMENT 'External business identifier or catalog code for the course.',
  `course_name` STRING COMMENT 'Descriptive title of the training course.',
  `credit_units` DECIMAL(4,2) COMMENT 'Accredited credit units awarded upon successful completion.',
  `currency_code` STRING COMMENT 'Three-letter ISO currency code for the course price.',
  `delivery_method` STRING COMMENT 'Mode in which the training is delivered.',
  `description` STRING COMMENT 'Detailed narrative describing the content and objectives of the course.',
  `duration_hours` DECIMAL(5,2) COMMENT 'Total instructional time of the course expressed in hours.',
  `effective_from` DATE COMMENT 'Date when the course becomes available for enrollment.',
  `effective_until` DATE COMMENT 'Date after which the course is no longer offered (nullable for open-ended).',
  `instructor_email` STRING COMMENT 'Contact email for the instructor.',
  `instructor_name` STRING COMMENT 'Full name of the primary instructor delivering the course.',
  `last_review_date` DATE COMMENT 'Date when the course content was last reviewed for relevance and compliance.',
  `location_facility_code` STRING COMMENT 'Identifier of the facility where the training is conducted.',
  `prerequisite_course_code` STRING COMMENT 'Code of a required preceding course, if any.',
  `price_amount` DECIMAL(10,2) COMMENT 'Monetary cost to enroll in the course.',
  `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the course record was first created in the system.',
  `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the course record.',
  `status` STRING COMMENT 'Current lifecycle status of the training course.',
  `target_audience` STRING COMMENT 'Primary audience segment for which the course is designed.',
  `version_number` STRING COMMENT 'Version identifier for the course curriculum.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_training_course` PRIMARY KEY (`training_course_id`)
)
USING DELTA
COMMENT 'Master reference table for training_course. Referenced by training_course_id. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'TrainingCourse',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.training_course'
);

-- ComplianceParty  <<CIM OrganisationRole : close>>
CREATE TABLE IF NOT EXISTS `compliance`.`party` (
  `party_id` BIGINT NOT NULL COMMENT 'Primary key for party',
  `parent_party_id` BIGINT COMMENT 'Self-referencing FK on party (parent_party_id)',
  `audit_status` STRING COMMENT 'Result of the most recent audit.',
  `city` STRING COMMENT 'City component of the primary address.',
  `classification` STRING COMMENT 'Business classification used for segmentation and reporting.',
  `compliance_status` STRING COMMENT 'Current compliance standing of the party with applicable regulations.',
  `contact_preference` STRING COMMENT 'Preferred channel for outreach.',
  `country_code` STRING COMMENT 'Three-letter ISO country code for the primary address.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the party record was first created.',
  `effective_from` DATE COMMENT 'Date when the party became effective for business purposes.',
  `effective_until` DATE COMMENT 'Date when the party\'s relationship ends or is scheduled to end; null if open-ended.',
  `external_reference_id` STRING COMMENT 'Identifier used in external source systems to reference the same party.',
  `industry_code` STRING COMMENT 'North American Industry Classification System code describing the party\'s primary industry.',
  `is_subject_to_regulation` BOOLEAN COMMENT 'Indicates whether the party is subject to NERC, FERC, EPA, or other utility-specific regulations.',
  `language_preference` STRING COMMENT 'Preferred language for communications.',
  `last_audit_date` DATE COMMENT 'Date of the most recent compliance audit performed on the party.',
  `legal_name` STRING COMMENT 'Official registered legal name of the party.',
  `notes` STRING COMMENT 'Free-form notes or remarks about the party.',
  `party_name` STRING COMMENT 'Full legal name of the party (person or organization).',
  `party_type` STRING COMMENT 'Category describing the nature of the party.',
  `postal_code` STRING COMMENT 'Postal or ZIP code of the primary address.',
  `primary_address_line1` STRING COMMENT 'First line of the party\'s primary mailing address.',
  `primary_address_line2` STRING COMMENT 'Second line of the party\'s primary mailing address (optional).',
  `primary_email` STRING COMMENT 'Main email address used for electronic communication with the party.',
  `primary_phone` STRING COMMENT 'Main telephone number for voice contact.',
  `registration_number` STRING COMMENT 'Official registration number assigned by the jurisdiction of incorporation.',
  `risk_rating` DECIMAL(5,2) COMMENT 'Numerical risk score (0-100) reflecting overall regulatory and operational risk.',
  `state_province` STRING COMMENT 'State or province component of the primary address.',
  `status` STRING COMMENT 'Current lifecycle status of the party.',
  `tax_id_number` STRING COMMENT 'Government-issued tax identifier (e.g., EIN for organizations).',
  `time_zone` STRING COMMENT 'IANA time zone identifier for the party\'s primary location.',
  `trade_name` STRING COMMENT 'Commonly used business name or DBA of the party.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the party record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_party` PRIMARY KEY (`party_id`)
)
USING DELTA
COMMENT 'Master reference table for party. Referenced by party_id. | CMM: CIM OrganisationRole (close), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ComplianceParty',
  'cmm.cim.class' = 'OrganisationRole',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.party'
);

-- ComplianceDocument  <<CIM Document : close>>
CREATE TABLE IF NOT EXISTS `compliance`.`compliance_document` (
  `compliance_document_id` BIGINT NOT NULL COMMENT 'Primary key for compliance_document',
  `superseded_compliance_document_id` BIGINT COMMENT 'Self-referencing FK on compliance_document (superseded_compliance_document_id)',
  `author_name` STRING COMMENT 'Name of the individual or team that authored the document.',
  `checksum_sha256` STRING COMMENT 'Cryptographic hash used to verify file integrity.',
  `classification` STRING COMMENT 'Data classification level governing access and handling.',
  `compliance_area` STRING COMMENT 'Functional compliance domain the document addresses.',
  `confidentiality_level` STRING COMMENT 'Internal classification indicating sensitivity of the document content.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the document record was first entered into the system.',
  `description` STRING COMMENT 'Brief narrative describing the purpose and scope of the document.',
  `document_number` STRING COMMENT 'External reference number assigned to the document by the regulatory filing system.',
  `document_type` STRING COMMENT 'Category of the compliance document indicating its regulatory purpose.',
  `effective_date` DATE COMMENT 'Date on which the document becomes legally effective.',
  `expiration_date` DATE COMMENT 'Date on which the document ceases to be effective; null if open-ended.',
  `file_format` STRING COMMENT 'Digital format of the stored document.',
  `file_size_bytes` BIGINT COMMENT 'Size of the document file in bytes.',
  `filing_deadline` DATE COMMENT 'Latest date by which the document must be filed with the regulator.',
  `filing_status` STRING COMMENT 'Current status of the regulatory filing process.',
  `is_archived` BOOLEAN COMMENT 'Indicates whether the document has been moved to archival storage.',
  `issue_date` DATE COMMENT 'Date the document was originally issued by the authority.',
  `owner_department` STRING COMMENT 'Organizational unit responsible for maintaining the document.',
  `regulatory_body` STRING COMMENT 'Governing agency that issued or requires the document.',
  `retention_period_days` INT COMMENT 'Number of days the document must be retained before disposal.',
  `revision_date` DATE COMMENT 'Date of the most recent amendment or version update.',
  `status` STRING COMMENT 'Current lifecycle state of the document.',
  `storage_path` STRING COMMENT 'File system or object store location where the document file resides.',
  `title` STRING COMMENT 'Human-readable title of the compliance document.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the document record.',
  `version_number` INT COMMENT 'Incremental version identifier for the document.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_compliance_compliance_document` PRIMARY KEY (`compliance_document_id`)
)
USING DELTA
COMMENT 'Master reference table for compliance_document. Referenced by compliance_document_id. | CMM: CIM Document (close), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ComplianceDocument',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.compliance.compliance_document'
);

-- ========= FOREIGN KEYS within compliance (87) =========
ALTER TABLE `compliance`.`regulatory_filing` DROP CONSTRAINT IF EXISTS `fk_compliance_regulatory_filing_cpcn_application_id`;
ALTER TABLE `compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_cpcn_application_id` FOREIGN KEY (`cpcn_application_id`) REFERENCES `compliance`.`cpcn_application` (`cpcn_application_id`);

ALTER TABLE `compliance`.`regulatory_filing` DROP CONSTRAINT IF EXISTS `fk_compliance_regulatory_filing_obligation_id`;
ALTER TABLE `compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`regulatory_filing` DROP CONSTRAINT IF EXISTS `fk_compliance_regulatory_filing_rate_case_id`;
ALTER TABLE `compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_rate_case_id` FOREIGN KEY (`rate_case_id`) REFERENCES `compliance`.`rate_case` (`rate_case_id`);

ALTER TABLE `compliance`.`regulatory_filing` DROP CONSTRAINT IF EXISTS `fk_compliance_regulatory_filing_regulatory_obligation_id`;
ALTER TABLE `compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_regulatory_obligation_id` FOREIGN KEY (`regulatory_obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`audit` DROP CONSTRAINT IF EXISTS `fk_compliance_audit_audit_program_id`;
ALTER TABLE `compliance`.`audit` ADD CONSTRAINT `fk_compliance_audit_audit_program_id` FOREIGN KEY (`audit_program_id`) REFERENCES `compliance`.`program` (`program_id`);

ALTER TABLE `compliance`.`audit` DROP CONSTRAINT IF EXISTS `fk_compliance_audit_obligation_id`;
ALTER TABLE `compliance`.`audit` ADD CONSTRAINT `fk_compliance_audit_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`audit` DROP CONSTRAINT IF EXISTS `fk_compliance_audit_program_id`;
ALTER TABLE `compliance`.`audit` ADD CONSTRAINT `fk_compliance_audit_program_id` FOREIGN KEY (`program_id`) REFERENCES `compliance`.`program` (`program_id`);

ALTER TABLE `compliance`.`audit_finding` DROP CONSTRAINT IF EXISTS `fk_compliance_audit_finding_audit_obligation_id`;
ALTER TABLE `compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_audit_obligation_id` FOREIGN KEY (`audit_obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`audit_finding` DROP CONSTRAINT IF EXISTS `fk_compliance_audit_finding_obligation_id`;
ALTER TABLE `compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`audit_finding` DROP CONSTRAINT IF EXISTS `fk_compliance_audit_finding_primary_audit_id`;
ALTER TABLE `compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_primary_audit_id` FOREIGN KEY (`primary_audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `compliance`.`enforcement_action` DROP CONSTRAINT IF EXISTS `fk_compliance_enforcement_action_audit_id`;
ALTER TABLE `compliance`.`enforcement_action` ADD CONSTRAINT `fk_compliance_enforcement_action_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `compliance`.`enforcement_action` DROP CONSTRAINT IF EXISTS `fk_compliance_enforcement_action_corrective_action_plan_id`;
ALTER TABLE `compliance`.`enforcement_action` ADD CONSTRAINT `fk_compliance_enforcement_action_corrective_action_plan_id` FOREIGN KEY (`corrective_action_plan_id`) REFERENCES `compliance`.`corrective_action_plan` (`corrective_action_plan_id`);

ALTER TABLE `compliance`.`enforcement_action` DROP CONSTRAINT IF EXISTS `fk_compliance_enforcement_action_enforcement_audit_finding_id`;
ALTER TABLE `compliance`.`enforcement_action` ADD CONSTRAINT `fk_compliance_enforcement_action_enforcement_audit_finding_id` FOREIGN KEY (`enforcement_audit_finding_id`) REFERENCES `compliance`.`audit_finding` (`audit_finding_id`);

ALTER TABLE `compliance`.`enforcement_action` DROP CONSTRAINT IF EXISTS `fk_compliance_enforcement_action_from_audit_finding_id`;
ALTER TABLE `compliance`.`enforcement_action` ADD CONSTRAINT `fk_compliance_enforcement_action_from_audit_finding_id` FOREIGN KEY (`from_audit_finding_id`) REFERENCES `compliance`.`audit_finding` (`audit_finding_id`);

ALTER TABLE `compliance`.`enforcement_action` DROP CONSTRAINT IF EXISTS `fk_compliance_enforcement_action_self_report_id`;
ALTER TABLE `compliance`.`enforcement_action` ADD CONSTRAINT `fk_compliance_enforcement_action_self_report_id` FOREIGN KEY (`self_report_id`) REFERENCES `compliance`.`self_report` (`self_report_id`);

ALTER TABLE `compliance`.`corrective_action_plan` DROP CONSTRAINT IF EXISTS `fk_compliance_corrective_action_plan_audit_finding_id`;
ALTER TABLE `compliance`.`corrective_action_plan` ADD CONSTRAINT `fk_compliance_corrective_action_plan_audit_finding_id` FOREIGN KEY (`audit_finding_id`) REFERENCES `compliance`.`audit_finding` (`audit_finding_id`);

ALTER TABLE `compliance`.`corrective_action_plan` DROP CONSTRAINT IF EXISTS `fk_compliance_corrective_action_plan_corrective_audit_finding_id`;
ALTER TABLE `compliance`.`corrective_action_plan` ADD CONSTRAINT `fk_compliance_corrective_action_plan_corrective_audit_finding_id` FOREIGN KEY (`corrective_audit_finding_id`) REFERENCES `compliance`.`audit_finding` (`audit_finding_id`);

ALTER TABLE `compliance`.`corrective_action_plan` DROP CONSTRAINT IF EXISTS `fk_compliance_corrective_action_plan_violation_id`;
ALTER TABLE `compliance`.`corrective_action_plan` ADD CONSTRAINT `fk_compliance_corrective_action_plan_violation_id` FOREIGN KEY (`violation_id`) REFERENCES `compliance`.`violation` (`violation_id`);

ALTER TABLE `compliance`.`evidence_record` DROP CONSTRAINT IF EXISTS `fk_compliance_evidence_record_corrective_action_plan_id`;
ALTER TABLE `compliance`.`evidence_record` ADD CONSTRAINT `fk_compliance_evidence_record_corrective_action_plan_id` FOREIGN KEY (`corrective_action_plan_id`) REFERENCES `compliance`.`corrective_action_plan` (`corrective_action_plan_id`);

ALTER TABLE `compliance`.`evidence_record` DROP CONSTRAINT IF EXISTS `fk_compliance_evidence_record_evidence_audit_finding_id`;
ALTER TABLE `compliance`.`evidence_record` ADD CONSTRAINT `fk_compliance_evidence_record_evidence_audit_finding_id` FOREIGN KEY (`evidence_audit_finding_id`) REFERENCES `compliance`.`audit_finding` (`audit_finding_id`);

ALTER TABLE `compliance`.`evidence_record` DROP CONSTRAINT IF EXISTS `fk_compliance_evidence_record_evidence_obligation_id`;
ALTER TABLE `compliance`.`evidence_record` ADD CONSTRAINT `fk_compliance_evidence_record_evidence_obligation_id` FOREIGN KEY (`evidence_obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`evidence_record` DROP CONSTRAINT IF EXISTS `fk_compliance_evidence_record_evidence_regulatory_obligation_id`;
ALTER TABLE `compliance`.`evidence_record` ADD CONSTRAINT `fk_compliance_evidence_record_evidence_regulatory_obligation_id` FOREIGN KEY (`evidence_regulatory_obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`evidence_record` DROP CONSTRAINT IF EXISTS `fk_compliance_evidence_record_primary_audit_finding_id`;
ALTER TABLE `compliance`.`evidence_record` ADD CONSTRAINT `fk_compliance_evidence_record_primary_audit_finding_id` FOREIGN KEY (`primary_audit_finding_id`) REFERENCES `compliance`.`audit_finding` (`audit_finding_id`);

ALTER TABLE `compliance`.`evidence_record` DROP CONSTRAINT IF EXISTS `fk_compliance_evidence_record_primary_obligation_id`;
ALTER TABLE `compliance`.`evidence_record` ADD CONSTRAINT `fk_compliance_evidence_record_primary_obligation_id` FOREIGN KEY (`primary_obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`regulatory_correspondence` DROP CONSTRAINT IF EXISTS `fk_compliance_regulatory_correspondence_audit_id`;
ALTER TABLE `compliance`.`regulatory_correspondence` ADD CONSTRAINT `fk_compliance_regulatory_correspondence_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `compliance`.`regulatory_correspondence` DROP CONSTRAINT IF EXISTS `fk_compliance_regulatory_correspondence_cpcn_application_id`;
ALTER TABLE `compliance`.`regulatory_correspondence` ADD CONSTRAINT `fk_compliance_regulatory_correspondence_cpcn_application_id` FOREIGN KEY (`cpcn_application_id`) REFERENCES `compliance`.`cpcn_application` (`cpcn_application_id`);

ALTER TABLE `compliance`.`regulatory_correspondence` DROP CONSTRAINT IF EXISTS `fk_compliance_regulatory_correspondence_enforcement_action_id`;
ALTER TABLE `compliance`.`regulatory_correspondence` ADD CONSTRAINT `fk_compliance_regulatory_correspondence_enforcement_action_id` FOREIGN KEY (`enforcement_action_id`) REFERENCES `compliance`.`enforcement_action` (`enforcement_action_id`);

ALTER TABLE `compliance`.`regulatory_correspondence` DROP CONSTRAINT IF EXISTS `fk_compliance_regulatory_correspondence_primary_related_filing_regulatory_filing_id`;
ALTER TABLE `compliance`.`regulatory_correspondence` ADD CONSTRAINT `fk_compliance_regulatory_correspondence_primary_related_filing_regulatory_filing_id` FOREIGN KEY (`primary_related_filing_regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `compliance`.`regulatory_correspondence` DROP CONSTRAINT IF EXISTS `fk_compliance_regulatory_correspondence_rate_case_id`;
ALTER TABLE `compliance`.`regulatory_correspondence` ADD CONSTRAINT `fk_compliance_regulatory_correspondence_rate_case_id` FOREIGN KEY (`rate_case_id`) REFERENCES `compliance`.`rate_case` (`rate_case_id`);

ALTER TABLE `compliance`.`regulatory_correspondence` DROP CONSTRAINT IF EXISTS `fk_compliance_regulatory_correspondence_regulatory_filing_id`;
ALTER TABLE `compliance`.`regulatory_correspondence` ADD CONSTRAINT `fk_compliance_regulatory_correspondence_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `compliance`.`nerc_cip_asset` DROP CONSTRAINT IF EXISTS `fk_compliance_nerc_cip_asset_baseline_configuration_id`;
ALTER TABLE `compliance`.`nerc_cip_asset` ADD CONSTRAINT `fk_compliance_nerc_cip_asset_baseline_configuration_id` FOREIGN KEY (`baseline_configuration_id`) REFERENCES `compliance`.`baseline_configuration` (`baseline_configuration_id`);

ALTER TABLE `compliance`.`nerc_cip_asset` DROP CONSTRAINT IF EXISTS `fk_compliance_nerc_cip_asset_bes_facility_id`;
ALTER TABLE `compliance`.`nerc_cip_asset` ADD CONSTRAINT `fk_compliance_nerc_cip_asset_bes_facility_id` FOREIGN KEY (`bes_facility_id`) REFERENCES `compliance`.`bes_facility` (`bes_facility_id`);

ALTER TABLE `compliance`.`nerc_cip_asset` DROP CONSTRAINT IF EXISTS `fk_compliance_nerc_cip_asset_cyber_security_incident_response_plan_id`;
ALTER TABLE `compliance`.`nerc_cip_asset` ADD CONSTRAINT `fk_compliance_nerc_cip_asset_cyber_security_incident_response_plan_id` FOREIGN KEY (`cyber_security_incident_response_plan_id`) REFERENCES `compliance`.`cyber_security_incident_response_plan` (`cyber_security_incident_response_plan_id`);

ALTER TABLE `compliance`.`nerc_cip_asset` DROP CONSTRAINT IF EXISTS `fk_compliance_nerc_cip_asset_electronic_security_perimeter_id`;
ALTER TABLE `compliance`.`nerc_cip_asset` ADD CONSTRAINT `fk_compliance_nerc_cip_asset_electronic_security_perimeter_id` FOREIGN KEY (`electronic_security_perimeter_id`) REFERENCES `compliance`.`electronic_security_perimeter` (`electronic_security_perimeter_id`);

ALTER TABLE `compliance`.`nerc_cip_asset` DROP CONSTRAINT IF EXISTS `fk_compliance_nerc_cip_asset_nerc_obligation_id`;
ALTER TABLE `compliance`.`nerc_cip_asset` ADD CONSTRAINT `fk_compliance_nerc_cip_asset_nerc_obligation_id` FOREIGN KEY (`nerc_obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`nerc_cip_asset` DROP CONSTRAINT IF EXISTS `fk_compliance_nerc_cip_asset_obligation_id`;
ALTER TABLE `compliance`.`nerc_cip_asset` ADD CONSTRAINT `fk_compliance_nerc_cip_asset_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`nerc_cip_asset` DROP CONSTRAINT IF EXISTS `fk_compliance_nerc_cip_asset_physical_security_perimeter_id`;
ALTER TABLE `compliance`.`nerc_cip_asset` ADD CONSTRAINT `fk_compliance_nerc_cip_asset_physical_security_perimeter_id` FOREIGN KEY (`physical_security_perimeter_id`) REFERENCES `compliance`.`physical_security_perimeter` (`physical_security_perimeter_id`);

ALTER TABLE `compliance`.`nerc_cip_asset` DROP CONSTRAINT IF EXISTS `fk_compliance_nerc_cip_asset_recovery_plan_id`;
ALTER TABLE `compliance`.`nerc_cip_asset` ADD CONSTRAINT `fk_compliance_nerc_cip_asset_recovery_plan_id` FOREIGN KEY (`recovery_plan_id`) REFERENCES `compliance`.`recovery_plan` (`recovery_plan_id`);

ALTER TABLE `compliance`.`emissions_report` DROP CONSTRAINT IF EXISTS `fk_compliance_emissions_report_emissions_obligation_id`;
ALTER TABLE `compliance`.`emissions_report` ADD CONSTRAINT `fk_compliance_emissions_report_emissions_obligation_id` FOREIGN KEY (`emissions_obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`emissions_report` DROP CONSTRAINT IF EXISTS `fk_compliance_emissions_report_environmental_permit_id`;
ALTER TABLE `compliance`.`emissions_report` ADD CONSTRAINT `fk_compliance_emissions_report_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `compliance`.`environmental_permit` (`environmental_permit_id`);

ALTER TABLE `compliance`.`emissions_report` DROP CONSTRAINT IF EXISTS `fk_compliance_emissions_report_obligation_id`;
ALTER TABLE `compliance`.`emissions_report` ADD CONSTRAINT `fk_compliance_emissions_report_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`emissions_report` DROP CONSTRAINT IF EXISTS `fk_compliance_emissions_report_original_report_emissions_report_id`;
ALTER TABLE `compliance`.`emissions_report` ADD CONSTRAINT `fk_compliance_emissions_report_original_report_emissions_report_id` FOREIGN KEY (`original_report_emissions_report_id`) REFERENCES `compliance`.`emissions_report` (`emissions_report_id`);

ALTER TABLE `compliance`.`environmental_permit` DROP CONSTRAINT IF EXISTS `fk_compliance_environmental_permit_environmental_obligation_id`;
ALTER TABLE `compliance`.`environmental_permit` ADD CONSTRAINT `fk_compliance_environmental_permit_environmental_obligation_id` FOREIGN KEY (`environmental_obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`environmental_permit` DROP CONSTRAINT IF EXISTS `fk_compliance_environmental_permit_obligation_id`;
ALTER TABLE `compliance`.`environmental_permit` ADD CONSTRAINT `fk_compliance_environmental_permit_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`compliance_rec_certificate` DROP CONSTRAINT IF EXISTS `fk_compliance_compliance_rec_certificate_attestation_document_id`;
ALTER TABLE `compliance`.`compliance_rec_certificate` ADD CONSTRAINT `fk_compliance_compliance_rec_certificate_attestation_document_id` FOREIGN KEY (`attestation_document_id`) REFERENCES `compliance`.`attestation_document` (`attestation_document_id`);

ALTER TABLE `compliance`.`compliance_rec_certificate` DROP CONSTRAINT IF EXISTS `fk_compliance_compliance_rec_certificate_obligation_id`;
ALTER TABLE `compliance`.`compliance_rec_certificate` ADD CONSTRAINT `fk_compliance_compliance_rec_certificate_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`sox_control` DROP CONSTRAINT IF EXISTS `fk_compliance_sox_control_program_id`;
ALTER TABLE `compliance`.`sox_control` ADD CONSTRAINT `fk_compliance_sox_control_program_id` FOREIGN KEY (`program_id`) REFERENCES `compliance`.`program` (`program_id`);

ALTER TABLE `compliance`.`sox_control` DROP CONSTRAINT IF EXISTS `fk_compliance_sox_control_sox_program_id`;
ALTER TABLE `compliance`.`sox_control` ADD CONSTRAINT `fk_compliance_sox_control_sox_program_id` FOREIGN KEY (`sox_program_id`) REFERENCES `compliance`.`program` (`program_id`);

ALTER TABLE `compliance`.`sox_control_test` DROP CONSTRAINT IF EXISTS `fk_compliance_sox_control_test_audit_id`;
ALTER TABLE `compliance`.`sox_control_test` ADD CONSTRAINT `fk_compliance_sox_control_test_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `compliance`.`sox_control_test` DROP CONSTRAINT IF EXISTS `fk_compliance_sox_control_test_remediation_plan_id`;
ALTER TABLE `compliance`.`sox_control_test` ADD CONSTRAINT `fk_compliance_sox_control_test_remediation_plan_id` FOREIGN KEY (`remediation_plan_id`) REFERENCES `compliance`.`corrective_action_plan` (`corrective_action_plan_id`);

ALTER TABLE `compliance`.`sox_control_test` DROP CONSTRAINT IF EXISTS `fk_compliance_sox_control_test_sox_control_id`;
ALTER TABLE `compliance`.`sox_control_test` ADD CONSTRAINT `fk_compliance_sox_control_test_sox_control_id` FOREIGN KEY (`sox_control_id`) REFERENCES `compliance`.`sox_control` (`sox_control_id`);

ALTER TABLE `compliance`.`training_record` DROP CONSTRAINT IF EXISTS `fk_compliance_training_record_obligation_id`;
ALTER TABLE `compliance`.`training_record` ADD CONSTRAINT `fk_compliance_training_record_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`training_record` DROP CONSTRAINT IF EXISTS `fk_compliance_training_record_primary_program_id`;
ALTER TABLE `compliance`.`training_record` ADD CONSTRAINT `fk_compliance_training_record_primary_program_id` FOREIGN KEY (`primary_program_id`) REFERENCES `compliance`.`program` (`program_id`);

ALTER TABLE `compliance`.`training_record` DROP CONSTRAINT IF EXISTS `fk_compliance_training_record_training_course_id`;
ALTER TABLE `compliance`.`training_record` ADD CONSTRAINT `fk_compliance_training_record_training_course_id` FOREIGN KEY (`training_course_id`) REFERENCES `compliance`.`training_course` (`training_course_id`);

ALTER TABLE `compliance`.`training_record` DROP CONSTRAINT IF EXISTS `fk_compliance_training_record_training_program_id`;
ALTER TABLE `compliance`.`training_record` ADD CONSTRAINT `fk_compliance_training_record_training_program_id` FOREIGN KEY (`training_program_id`) REFERENCES `compliance`.`program` (`program_id`);

ALTER TABLE `compliance`.`self_report` DROP CONSTRAINT IF EXISTS `fk_compliance_self_report_audit_finding_id`;
ALTER TABLE `compliance`.`self_report` ADD CONSTRAINT `fk_compliance_self_report_audit_finding_id` FOREIGN KEY (`audit_finding_id`) REFERENCES `compliance`.`audit_finding` (`audit_finding_id`);

ALTER TABLE `compliance`.`self_report` DROP CONSTRAINT IF EXISTS `fk_compliance_self_report_exception_id`;
ALTER TABLE `compliance`.`self_report` ADD CONSTRAINT `fk_compliance_self_report_exception_id` FOREIGN KEY (`exception_id`) REFERENCES `compliance`.`exception` (`exception_id`);

ALTER TABLE `compliance`.`self_report` DROP CONSTRAINT IF EXISTS `fk_compliance_self_report_obligation_id`;
ALTER TABLE `compliance`.`self_report` ADD CONSTRAINT `fk_compliance_self_report_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`irp_filing` DROP CONSTRAINT IF EXISTS `fk_compliance_irp_filing_regulatory_filing_id`;
ALTER TABLE `compliance`.`irp_filing` ADD CONSTRAINT `fk_compliance_irp_filing_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `compliance`.`penalty_assessment` DROP CONSTRAINT IF EXISTS `fk_compliance_penalty_assessment_corrective_action_plan_id`;
ALTER TABLE `compliance`.`penalty_assessment` ADD CONSTRAINT `fk_compliance_penalty_assessment_corrective_action_plan_id` FOREIGN KEY (`corrective_action_plan_id`) REFERENCES `compliance`.`corrective_action_plan` (`corrective_action_plan_id`);

ALTER TABLE `compliance`.`penalty_assessment` DROP CONSTRAINT IF EXISTS `fk_compliance_penalty_assessment_enforcement_action_id`;
ALTER TABLE `compliance`.`penalty_assessment` ADD CONSTRAINT `fk_compliance_penalty_assessment_enforcement_action_id` FOREIGN KEY (`enforcement_action_id`) REFERENCES `compliance`.`enforcement_action` (`enforcement_action_id`);

ALTER TABLE `compliance`.`exception` DROP CONSTRAINT IF EXISTS `fk_compliance_exception_corrective_action_plan_id`;
ALTER TABLE `compliance`.`exception` ADD CONSTRAINT `fk_compliance_exception_corrective_action_plan_id` FOREIGN KEY (`corrective_action_plan_id`) REFERENCES `compliance`.`corrective_action_plan` (`corrective_action_plan_id`);

ALTER TABLE `compliance`.`exception` DROP CONSTRAINT IF EXISTS `fk_compliance_exception_exception_obligation_id`;
ALTER TABLE `compliance`.`exception` ADD CONSTRAINT `fk_compliance_exception_exception_obligation_id` FOREIGN KEY (`exception_obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`exception` DROP CONSTRAINT IF EXISTS `fk_compliance_exception_obligation_id`;
ALTER TABLE `compliance`.`exception` ADD CONSTRAINT `fk_compliance_exception_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`exception` DROP CONSTRAINT IF EXISTS `fk_compliance_exception_previous_exception_id`;
ALTER TABLE `compliance`.`exception` ADD CONSTRAINT `fk_compliance_exception_previous_exception_id` FOREIGN KEY (`previous_exception_id`) REFERENCES `compliance`.`exception` (`exception_id`);

ALTER TABLE `compliance`.`ferc_market_report` DROP CONSTRAINT IF EXISTS `fk_compliance_ferc_market_report_obligation_id`;
ALTER TABLE `compliance`.`ferc_market_report` ADD CONSTRAINT `fk_compliance_ferc_market_report_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`ferc_market_report` DROP CONSTRAINT IF EXISTS `fk_compliance_ferc_market_report_original_report_ferc_market_report_id`;
ALTER TABLE `compliance`.`ferc_market_report` ADD CONSTRAINT `fk_compliance_ferc_market_report_original_report_ferc_market_report_id` FOREIGN KEY (`original_report_ferc_market_report_id`) REFERENCES `compliance`.`ferc_market_report` (`ferc_market_report_id`);

ALTER TABLE `compliance`.`compliance_risk_assessment` DROP CONSTRAINT IF EXISTS `fk_compliance_compliance_risk_assessment_audit_id`;
ALTER TABLE `compliance`.`compliance_risk_assessment` ADD CONSTRAINT `fk_compliance_compliance_risk_assessment_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `compliance`.`compliance_risk_assessment` DROP CONSTRAINT IF EXISTS `fk_compliance_compliance_risk_assessment_corrective_action_plan_id`;
ALTER TABLE `compliance`.`compliance_risk_assessment` ADD CONSTRAINT `fk_compliance_compliance_risk_assessment_corrective_action_plan_id` FOREIGN KEY (`corrective_action_plan_id`) REFERENCES `compliance`.`corrective_action_plan` (`corrective_action_plan_id`);

ALTER TABLE `compliance`.`compliance_risk_assessment` DROP CONSTRAINT IF EXISTS `fk_compliance_compliance_risk_assessment_obligation_id`;
ALTER TABLE `compliance`.`compliance_risk_assessment` ADD CONSTRAINT `fk_compliance_compliance_risk_assessment_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `compliance`.`compliance_risk_assessment` DROP CONSTRAINT IF EXISTS `fk_compliance_compliance_risk_assessment_program_id`;
ALTER TABLE `compliance`.`compliance_risk_assessment` ADD CONSTRAINT `fk_compliance_compliance_risk_assessment_program_id` FOREIGN KEY (`program_id`) REFERENCES `compliance`.`program` (`program_id`);

ALTER TABLE `compliance`.`compliance_risk_assessment` DROP CONSTRAINT IF EXISTS `fk_compliance_compliance_risk_assessment_previous_compliance_risk_assessment_id`;
ALTER TABLE `compliance`.`compliance_risk_assessment` ADD CONSTRAINT `fk_compliance_compliance_risk_assessment_previous_compliance_risk_assessment_id` FOREIGN KEY (`previous_compliance_risk_assessment_id`) REFERENCES `compliance`.`compliance_risk_assessment` (`compliance_risk_assessment_id`);

ALTER TABLE `compliance`.`audit_scope` DROP CONSTRAINT IF EXISTS `fk_compliance_audit_scope_audit_id`;
ALTER TABLE `compliance`.`audit_scope` ADD CONSTRAINT `fk_compliance_audit_scope_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `compliance`.`violation` DROP CONSTRAINT IF EXISTS `fk_compliance_violation_party_id`;
ALTER TABLE `compliance`.`violation` ADD CONSTRAINT `fk_compliance_violation_party_id` FOREIGN KEY (`party_id`) REFERENCES `compliance`.`party` (`party_id`);

ALTER TABLE `compliance`.`violation` DROP CONSTRAINT IF EXISTS `fk_compliance_violation_related_violation_id`;
ALTER TABLE `compliance`.`violation` ADD CONSTRAINT `fk_compliance_violation_related_violation_id` FOREIGN KEY (`related_violation_id`) REFERENCES `compliance`.`violation` (`violation_id`);

ALTER TABLE `compliance`.`bes_facility` DROP CONSTRAINT IF EXISTS `fk_compliance_bes_facility_parent_bes_facility_id`;
ALTER TABLE `compliance`.`bes_facility` ADD CONSTRAINT `fk_compliance_bes_facility_parent_bes_facility_id` FOREIGN KEY (`parent_bes_facility_id`) REFERENCES `compliance`.`bes_facility` (`bes_facility_id`);

ALTER TABLE `compliance`.`electronic_security_perimeter` DROP CONSTRAINT IF EXISTS `fk_compliance_electronic_security_perimeter_parent_electronic_security_perimeter_id`;
ALTER TABLE `compliance`.`electronic_security_perimeter` ADD CONSTRAINT `fk_compliance_electronic_security_perimeter_parent_electronic_security_perimeter_id` FOREIGN KEY (`parent_electronic_security_perimeter_id`) REFERENCES `compliance`.`electronic_security_perimeter` (`electronic_security_perimeter_id`);

ALTER TABLE `compliance`.`physical_security_perimeter` DROP CONSTRAINT IF EXISTS `fk_compliance_physical_security_perimeter_parent_physical_security_perimeter_id`;
ALTER TABLE `compliance`.`physical_security_perimeter` ADD CONSTRAINT `fk_compliance_physical_security_perimeter_parent_physical_security_perimeter_id` FOREIGN KEY (`parent_physical_security_perimeter_id`) REFERENCES `compliance`.`physical_security_perimeter` (`physical_security_perimeter_id`);

ALTER TABLE `compliance`.`cyber_security_incident_response_plan` DROP CONSTRAINT IF EXISTS `fk_compliance_cyber_security_incident_response_plan_superseded_cyber_security_incident_response_plan_id`;
ALTER TABLE `compliance`.`cyber_security_incident_response_plan` ADD CONSTRAINT `fk_compliance_cyber_security_incident_response_plan_superseded_cyber_security_incident_response_plan_id` FOREIGN KEY (`superseded_cyber_security_incident_response_plan_id`) REFERENCES `compliance`.`cyber_security_incident_response_plan` (`cyber_security_incident_response_plan_id`);

ALTER TABLE `compliance`.`recovery_plan` DROP CONSTRAINT IF EXISTS `fk_compliance_recovery_plan_responsible_party_id`;
ALTER TABLE `compliance`.`recovery_plan` ADD CONSTRAINT `fk_compliance_recovery_plan_responsible_party_id` FOREIGN KEY (`responsible_party_id`) REFERENCES `compliance`.`party` (`party_id`);

ALTER TABLE `compliance`.`recovery_plan` DROP CONSTRAINT IF EXISTS `fk_compliance_recovery_plan_superseded_recovery_plan_id`;
ALTER TABLE `compliance`.`recovery_plan` ADD CONSTRAINT `fk_compliance_recovery_plan_superseded_recovery_plan_id` FOREIGN KEY (`superseded_recovery_plan_id`) REFERENCES `compliance`.`recovery_plan` (`recovery_plan_id`);

ALTER TABLE `compliance`.`baseline_configuration` DROP CONSTRAINT IF EXISTS `fk_compliance_baseline_configuration_superseded_baseline_configuration_id`;
ALTER TABLE `compliance`.`baseline_configuration` ADD CONSTRAINT `fk_compliance_baseline_configuration_superseded_baseline_configuration_id` FOREIGN KEY (`superseded_baseline_configuration_id`) REFERENCES `compliance`.`baseline_configuration` (`baseline_configuration_id`);

ALTER TABLE `compliance`.`attestation_document` DROP CONSTRAINT IF EXISTS `fk_compliance_attestation_document_superseded_attestation_document_id`;
ALTER TABLE `compliance`.`attestation_document` ADD CONSTRAINT `fk_compliance_attestation_document_superseded_attestation_document_id` FOREIGN KEY (`superseded_attestation_document_id`) REFERENCES `compliance`.`attestation_document` (`attestation_document_id`);

ALTER TABLE `compliance`.`training_course` DROP CONSTRAINT IF EXISTS `fk_compliance_training_course_compliance_document_id`;
ALTER TABLE `compliance`.`training_course` ADD CONSTRAINT `fk_compliance_training_course_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `compliance`.`compliance_document` (`compliance_document_id`);

ALTER TABLE `compliance`.`training_course` DROP CONSTRAINT IF EXISTS `fk_compliance_training_course_prerequisite_training_course_id`;
ALTER TABLE `compliance`.`training_course` ADD CONSTRAINT `fk_compliance_training_course_prerequisite_training_course_id` FOREIGN KEY (`prerequisite_training_course_id`) REFERENCES `compliance`.`training_course` (`training_course_id`);

ALTER TABLE `compliance`.`party` DROP CONSTRAINT IF EXISTS `fk_compliance_party_parent_party_id`;
ALTER TABLE `compliance`.`party` ADD CONSTRAINT `fk_compliance_party_parent_party_id` FOREIGN KEY (`parent_party_id`) REFERENCES `compliance`.`party` (`party_id`);

ALTER TABLE `compliance`.`compliance_document` DROP CONSTRAINT IF EXISTS `fk_compliance_compliance_document_superseded_compliance_document_id`;
ALTER TABLE `compliance`.`compliance_document` ADD CONSTRAINT `fk_compliance_compliance_document_superseded_compliance_document_id` FOREIGN KEY (`superseded_compliance_document_id`) REFERENCES `compliance`.`compliance_document` (`compliance_document_id`);

