-- Utility CMM-aligned Canonical Data Model (Silver) v1.0.0 | source: Databricks lakehouse-industry-data-models energy_utilities v1 ECM | generated 2026-10-13
-- 18 | Subject area: workforce | 31 tables | CIM packages: IEC61968::Common (Crew, Person); IEC61968::InfERPSupport (ErpPersonnel); IEC61968::InfWork
-- Standards: IEC 61968-6; IEC 61968-10; OSHA 29 CFR 1910.269; NERC CIP-004; DOT 49 CFR Part 40
-- Contents: tables (with PK + NOT NULL), then intra-subject-area foreign keys.
-- Unity Catalog PK/FK constraints are informational (NOT ENFORCED); NOT NULL is enforced.

USE CATALOG `utility_cmm_silver`;

-- Employee  <<CIM ErpPersonnel : close>>
CREATE TABLE IF NOT EXISTS `workforce`.`employee` (
  `employee_id` BIGINT NOT NULL COMMENT 'Unique identifier for the utility employee. Primary key for the employee master record. Serves as the authoritative personnel identity reference across asset maintenance, grid operations, outage management, and compliance domains.',
  `supervisor_employee_id` BIGINT COMMENT 'Employee identifier of the direct supervisor or manager. Establishes reporting hierarchy for organizational structure, approval workflows, and performance management. References another employee record in the employee master.',
  `workforce_position_id` BIGINT COMMENT 'FK to workforce.workforce_position.workforce_position_id — Every employee fills an authorized position. This is the fundamental structural relationship in workforce management — it drives pay grade, job classification, required certifications, and union statu',
  `active_flag` BOOLEAN COMMENT 'Indicates whether the employee record is currently active in the system. True for active employees available for work assignments, False for inactive or terminated employees. Used for filtering active workforce in crew scheduling and reporting.',
  `annual_salary` DECIMAL(12,2) COMMENT 'Annual base salary for salaried employees in USD. Null for hourly employees. Used for budgeting, labor cost allocation, and compensation planning. Business-confidential data.',
  `badge_number` STRING COMMENT 'Physical security badge or access card number assigned to the employee. Used for facility access control, time and attendance tracking, and physical security audit trails. Personally identifiable credential. Pattern: ^[A-Z0-9]{6,12}$.',
  `cdl_class` STRING COMMENT 'Class of Commercial Driver License held by the employee. Class A for combination vehicles, Class B for heavy straight vehicles, Class C for smaller vehicles with hazmat or passenger endorsements. None if no CDL. Determines vehicle assignment eligibility. Valid values: class_a|class_b|class_c|none.',
  `cdl_expiration_date` DATE COMMENT 'Expiration date of the employee\'s Commercial Driver License. Null if no CDL. Used to track license renewal requirements and ensure compliance with FMCSA regulations for utility fleet operations.',
  `cdl_license_flag` BOOLEAN COMMENT 'Indicates whether the employee holds a valid Commercial Driver License. True if CDL-certified, False otherwise. Required for employees operating utility trucks, bucket trucks, and heavy equipment. Used for crew assignment and fleet management.',
  `cost_center` STRING COMMENT 'Financial cost center to which the employee\'s labor costs are allocated. Links employee time and expenses to organizational units such as generation, transmission, distribution, or administrative departments. Used for labor cost tracking and work order costing. Pattern: ^[A-Z0-9]{4,10}$.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the employee record was first created in the system. Used for data lineage, audit trails, and record lifecycle tracking.',
  `crew_assignment` STRING COMMENT 'Identifier of the field crew or work team to which the employee is assigned. Examples include Line Crew 1, Substation Crew A, Meter Reading Team 3. Used for crew scheduling, work order dispatch, and team-based performance tracking.',
  `department` STRING COMMENT 'Organizational department or division to which the employee is assigned. Examples include Transmission Operations, Distribution Maintenance, Generation Plant, Customer Service, Engineering, or IT. Used for organizational hierarchy reporting and workforce planning.',
  `email_address` STRING COMMENT 'Primary corporate email address for the employee. Used for business communication, system access notifications, and work order assignments. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `emergency_contact_name` STRING COMMENT 'Full name of the employee\'s designated emergency contact person. Used for notification in case of workplace accidents, injuries, or critical incidents during field operations.',
  `emergency_contact_phone` STRING COMMENT 'Phone number of the employee\'s designated emergency contact person. Used for immediate notification in case of workplace accidents, injuries, or critical incidents. Pattern: ^\\+?[1-9]\\d{1,14}$.',
  `emergency_contact_relationship` STRING COMMENT 'Relationship of the emergency contact person to the employee. Used to understand the nature of the emergency contact relationship for notification protocols. Valid values: spouse|parent|sibling|child|friend|other.',
  `employee_number` STRING COMMENT 'Human-readable business identifier for the employee. Externally-known employee number used in payroll, timekeeping, and work order systems. May follow utility-specific numbering conventions. Pattern: ^[A-Z0-9]{6,12}$.',
  `employee_type` STRING COMMENT 'Classification of employment relationship. Distinguishes between full-time utility employees, part-time staff, external contractors, temporary workers, seasonal crews, and interns. Impacts benefits eligibility, labor cost allocation, and union coverage. Valid values: full_time|part_time|contractor|temporary|seasonal|intern.',
  `employment_status` STRING COMMENT 'Current employment lifecycle status of the employee. Determines eligibility for work assignments, system access, and payroll processing. Active employees are available for crew scheduling and work order assignments. Valid values: active|inactive|leave|suspended|terminated|retired.',
  `first_name` STRING COMMENT 'Legal first name of the employee as recorded in HR systems. Used for personnel identification, payroll processing, and regulatory reporting.',
  `hire_date` DATE COMMENT 'Date the employee was hired or began employment with the utility. Used for seniority calculations, benefits eligibility, service anniversary tracking, and union seniority rules.',
  `hourly_rate` DECIMAL(10,2) COMMENT 'Standard hourly pay rate for the employee in USD. Null for salaried employees. Used for time and attendance processing, work order labor costing, and payroll calculation. Business-confidential data.',
  `job_classification` STRING COMMENT 'Standardized job classification code defining the employee\'s role, skill level, and pay grade. Examples include lineman, cable splicer, plant operator, engineer, dispatcher, meter reader. Used for crew scheduling, labor cost allocation, and union agreement compliance.',
  `job_title` STRING COMMENT 'Descriptive job title for the employee. Human-readable position name such as Senior Lineman, Distribution Engineer, SCADA Operator, Meter Technician. Used for organizational reporting and personnel directories.',
  `last_name` STRING COMMENT 'Legal last name (surname) of the employee as recorded in HR systems. Used for personnel identification, payroll processing, and regulatory reporting.',
  `middle_name` STRING COMMENT 'Middle name or initial of the employee. Optional field used for complete legal name identification.',
  `mobile_number` STRING COMMENT 'Mobile phone number for the employee. Critical for field crew dispatch, outage response coordination, and emergency communications. Pattern: ^\\+?[1-9]\\d{1,14}$.',
  `nerc_cip_pra_date` DATE COMMENT 'Date the most recent NERC CIP Personnel Risk Assessment was completed or approved. Used to track compliance with NERC CIP-004 requirements for periodic background checks and security clearances.',
  `nerc_cip_pra_status` STRING COMMENT 'Status of NERC CIP (Critical Infrastructure Protection) Personnel Risk Assessment for employees with access to critical cyber assets or bulk electric system facilities. Required for compliance with NERC CIP-004 personnel security standards. Approved status is mandatory for access to protected systems. Valid values: not_required|pending|approved|denied|expired.',
  `nerc_cip_training_status` STRING COMMENT 'Status of NERC CIP cyber security training for employees with access to critical infrastructure. Current status indicates compliance with NERC CIP-004 training requirements. Expired status triggers retraining requirements. Valid values: current|expired|not_required|pending.',
  `on_call_status` STRING COMMENT 'Current on-call availability status for emergency response and outage restoration. Available for normal work, On-call for emergency dispatch, Unavailable due to leave or other assignment, Deployed to active incident. Used for storm response and outage management crew dispatch. Valid values: available|on_call|unavailable|deployed.',
  `osha_certification_status` STRING COMMENT 'Status of OSHA (Occupational Safety and Health Administration) safety certifications and training. Current status indicates compliance with OSHA safety training requirements for utility field work, confined space entry, electrical safety, and hazardous materials handling. Valid values: current|expired|not_required|pending.',
  `overtime_eligible_flag` BOOLEAN COMMENT 'Indicates whether the employee is eligible for overtime pay under FLSA regulations. True for non-exempt employees, False for exempt employees. Used for time and attendance processing and labor cost calculation.',
  `pay_grade` STRING COMMENT 'Compensation pay grade or salary band assigned to the employee. Determines base pay range, overtime eligibility, and benefits tier. Used for payroll processing and labor cost forecasting. Business-confidential data. Pattern: ^[A-Z0-9]{2,6}$.',
  `phone_number` STRING COMMENT 'Primary contact phone number for the employee. Used for crew dispatch, emergency contact, and field operations coordination. Pattern: ^\\+?[1-9]\\d{1,14}$.',
  `security_clearance_level` STRING COMMENT 'Physical and cyber security clearance level granted to the employee. Determines access to critical infrastructure facilities, control centers, substations, and cyber assets. Aligned with NERC CIP access control requirements. Valid values: none|basic|standard|elevated|critical.',
  `shift_assignment` STRING COMMENT 'Primary work shift assignment for the employee. Day shift (typically 7am-3pm), Evening shift (3pm-11pm), Night shift (11pm-7am), Rotating shifts, or On-call status. Used for crew scheduling, shift differential pay, and 24/7 operations coverage. Valid values: day|evening|night|rotating|on_call.',
  `skill_level` STRING COMMENT 'Proficiency level or skill grade of the employee within their job classification. Apprentice for trainees, Journeyman for certified skilled workers, Master for advanced practitioners. Used for crew composition, work assignment complexity, and pay grade determination. Valid values: apprentice|journeyman|master|specialist|expert.',
  `termination_date` DATE COMMENT 'Date the employee\'s employment ended. Null for active employees. Populated upon resignation, retirement, or termination. Used for workforce turnover analysis, benefits termination, and system access revocation.',
  `termination_reason` STRING COMMENT 'Reason for employment termination. Null for active employees. Used for turnover analysis, unemployment claims, and HR compliance reporting. Reference-value candidates: resignation|retirement|layoff|termination_for_cause|end_of_contract|disability|death.',
  `union_affiliation` STRING COMMENT 'Union or labor organization to which the employee belongs. Examples include IBEW (International Brotherhood of Electrical Workers), USW (United Steelworkers), or non-union designation. Determines applicable collective bargaining agreement, work rules, and grievance procedures.',
  `union_member_flag` BOOLEAN COMMENT 'Indicates whether the employee is a member of a labor union. True if union member, False if non-union. Used for labor relations reporting and contract compliance.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the employee record was last modified. Used for change tracking, data synchronization, and audit compliance.',
  `work_location` STRING COMMENT 'Primary work location or facility where the employee is based. Examples include power plant name, service center, district office, or headquarters building. Used for crew dispatch, asset assignment, and geographic workforce analysis.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_employee` PRIMARY KEY (`employee_id`)
)
USING DELTA
COMMENT 'SSOT master record for all utility personnel including field crews (linemen, cable splicers), plant operators, engineers, dispatchers, meter readers, and administrative staff. Captures employee identity, employment status, job classification, union affiliation, cost center, hire/termination dates, and NERC CIP personnel risk assessment status. Referenced by asset maintenance, grid operations, outage, and compliance domains as the authoritative personnel identity source. | CMM: CIM ErpPersonnel (close), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'Employee',
  'cmm.cim.class' = 'ErpPersonnel',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.employee'
);

-- WorkforcePosition  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `workforce`.`workforce_position` (
  `workforce_position_id` BIGINT NOT NULL COMMENT 'Unique identifier for the authorized organizational position within the utility workforce structure. Primary key.',
  `org_unit_id` BIGINT COMMENT 'FK to workforce.org_unit.org_unit_id — Positions are authorized within specific org units. This drives headcount planning, budgeting, and organizational structure. Without this link, you cannot aggregate authorized vs filled positions by d',
  `workforce_org_unit_id` BIGINT COMMENT 'Reference to the organizational unit (department, division, or cost center) to which this position is assigned for reporting and budget allocation purposes.',
  `approved_headcount_budget` DECIMAL(15,2) COMMENT 'Annual budgeted compensation amount approved for this position, including base salary, benefits, and overhead. Used for financial planning and cost allocation.',
  `background_check_level` STRING COMMENT 'Depth of pre-employment background screening required. NERC CIP level includes seven-year criminal history and identity verification for positions with BES Cyber System access. Valid values: standard|enhanced|nerc_cip|none.',
  `cost_center` STRING COMMENT 'Financial cost center code to which labor costs for this position are allocated. Used for departmental budgeting and financial reporting.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the position record was first created in the system. Used for audit trail and data lineage.',
  `drug_testing_required` BOOLEAN COMMENT 'Indicates whether the position requires pre-employment and random drug testing. Typically required for safety-sensitive positions (field crews, plant operators, drivers).',
  `effective_date` DATE COMMENT 'Date when the position was created or became active in the organizational structure. Used for historical workforce analysis and headcount tracking.',
  `employee_id` BIGINT COMMENT 'Reference to the employee responsible for the hiring decision and onboarding for this position. Typically the direct supervisor or department head.',
  `end_date` DATE COMMENT 'Date when the position was eliminated or frozen. Null for active positions. Used for organizational restructuring tracking and historical analysis.',
  `flsa_status` STRING COMMENT 'Classification under the Fair Labor Standards Act determining overtime eligibility. Exempt positions are salaried and not eligible for overtime; non-exempt positions are hourly and eligible for overtime pay. Valid values: exempt|non_exempt.',
  `full_time_equivalent` DECIMAL(5,2) COMMENT 'The FTE allocation for the position, representing the proportion of a full-time workload. 1.00 = full-time, 0.50 = half-time. Used for headcount budgeting and capacity planning.',
  `job_description` STRING COMMENT 'Detailed narrative description of the position responsibilities, duties, and expectations. Used for job postings, performance management, and role clarity.',
  `job_family` STRING COMMENT 'Broad occupational category grouping similar roles for workforce planning and career pathing (e.g., field operations includes linemen and meter readers; plant operations includes turbine operators and control room staff). Reference-value candidates: field_operations|plant_operations|engineering|grid_operations|customer_service|administrative|management|technical_support|safety_compliance|regulatory_affairs.',
  `job_title` STRING COMMENT 'Official job title for the position as it appears in organizational charts and job postings (e.g., Senior Lineman, Distribution Engineer, SCADA Operator).',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the position record was last updated. Used for change tracking and data quality monitoring.',
  `minimum_education_level` STRING COMMENT 'Minimum educational attainment required for the position. Trade certification applies to skilled trades (linemen, electricians); bachelor or higher typically required for engineering positions. Valid values: high_school|associate|bachelor|master|doctorate|trade_certification.',
  `minimum_experience_years` INT COMMENT 'Minimum number of years of relevant work experience required for the position. Used for candidate screening and qualification assessment.',
  `modified_by_user` STRING COMMENT 'User ID of the person who last modified the position record. Used for audit trail and accountability.',
  `nerc_cip_access_required` BOOLEAN COMMENT 'Indicates whether the position requires access to Bulk Electric System (BES) Cyber Systems or physical access to critical cyber assets, triggering NERC CIP personnel risk assessment requirements.',
  `osha_safety_sensitive` BOOLEAN COMMENT 'Indicates whether the position is classified as safety-sensitive under OSHA regulations, requiring enhanced safety training, drug testing, and incident reporting.',
  `pay_grade` STRING COMMENT 'Compensation band or salary grade assigned to the position, determining the salary range and benefits eligibility.',
  `physical_requirements` STRING COMMENT 'Description of physical demands and working conditions for the position (e.g., ability to climb utility poles, work at heights, lift 50 lbs, work outdoors in extreme weather). Required for OSHA compliance and ADA accommodation assessment.',
  `position_number` STRING COMMENT 'Business identifier for the position, used in organizational planning and budgeting. Externally visible position code.',
  `position_status` STRING COMMENT 'Current lifecycle state of the position. Active positions are filled or available for hiring; frozen positions are temporarily suspended from hiring; eliminated positions are being phased out. Valid values: active|vacant|frozen|eliminated|pending_approval|seasonal.',
  `position_type` STRING COMMENT 'Classification of the position based on employment duration and nature. Regular positions are permanent; seasonal positions are recurring but time-limited (e.g., summer peak demand crews). Valid values: regular|temporary|seasonal|contractor|intern.',
  `required_certifications` STRING COMMENT 'Comma-separated list of mandatory professional certifications, licenses, or credentials required for the position (e.g., Journeyman Lineman License, Professional Engineer PE, NERC System Operator Certification, CDL Class A, OSHA 30-Hour).',
  `requisition_justification` STRING COMMENT 'Business reason for opening the hiring requisition. Backfill replaces a departed employee; new headcount expands the workforce; regulatory requirement addresses compliance mandates (e.g., NERC CIP staffing). Valid values: backfill|new_headcount|seasonal|project_based|regulatory_requirement|growth.',
  `requisition_number` STRING COMMENT 'Unique identifier for the hiring requisition associated with this position, if currently open for recruitment. Null if position is filled or not actively recruiting.',
  `requisition_status` STRING COMMENT 'Current state of the hiring requisition workflow. Open requisitions are approved and actively recruiting; in-progress requisitions have active candidates; filled requisitions have accepted offers. Reference-value candidates: not_open|open|in_progress|offer_extended|filled|cancelled|on_hold.',
  `security_clearance_required` STRING COMMENT 'Level of security clearance required for the position, if any. Positions with access to critical infrastructure or sensitive grid operations data may require government security clearances. Valid values: none|basic|confidential|secret|top_secret.',
  `shift_pattern` STRING COMMENT 'Standard work shift schedule for the position. Rotating shifts are common for plant operators and grid dispatchers; on-call applies to emergency response crews. Valid values: day|night|rotating|on_call|flexible.',
  `sourcing_channel` STRING COMMENT 'Primary recruitment channel for filling this position. Internal sourcing promotes existing employees; apprenticeship programs develop skilled trades (linemen, electricians). Reference-value candidates: internal|external|referral|agency|campus|veteran|apprenticeship.',
  `target_hire_date` DATE COMMENT 'Planned start date for the new hire to fill this position. Used for workforce planning and onboarding preparation.',
  `travel_requirement_pct` DECIMAL(5,2) COMMENT 'Expected percentage of work time requiring travel away from the primary work location. Field positions may have 50-80% travel; office positions typically 0-10%.',
  `union_classification` STRING COMMENT 'Indicates whether the position is covered by a collective bargaining agreement. Union positions are subject to negotiated labor contracts; management positions are excluded from union representation. Valid values: union|non_union|management.',
  `union_local` STRING COMMENT 'Specific union local chapter representing this position, if applicable (e.g., IBEW Local 1245, UWUA Local 246). Null for non-union positions.',
  `work_location_code` BIGINT COMMENT 'Reference to the primary physical work location for the position (e.g., power plant, service center, district office, field territory).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_workforce_position` PRIMARY KEY (`workforce_position_id`)
)
USING DELTA
COMMENT 'Authorized organizational positions within the utility workforce structure and their hiring requisition lifecycle. Defines job titles, job families, pay grades, required certifications, union classification, FLSA status, and whether the role requires NERC CIP access authorization. Positions are the structural slots that employees fill; they exist independently of incumbents and drive headcount planning and budgeting. Hiring requisition records capture requisition number, hiring manager, org unit, justification (backfill, new headcount, seasonal), required certifications, target hire date, approved headcount budget, recruitment status, and sourcing channel. SSOT for organizational structure, position management, and talent acquisition workflow. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'WorkforcePosition',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.workforce_position'
);

-- OrgUnit  <<CIM Organisation : close>>
CREATE TABLE IF NOT EXISTS `workforce`.`org_unit` (
  `org_unit_id` BIGINT NOT NULL COMMENT 'Unique identifier for the organizational unit. Primary key.',
  `parent_org_unit_id` BIGINT COMMENT 'Identifier of the parent organizational unit in the hierarchy. Enables multi-level organizational structure (e.g., Division > Department > Work Group). Null for top-level units.',
  `budget_annual_amount` DECIMAL(18,2) COMMENT 'Annual operating budget allocated to the organizational unit in USD. Used for financial planning and variance analysis. Business-sensitive financial data.',
  `business_area` STRING COMMENT 'SAP business area for segment reporting and internal financial analysis. Represents a distinct business segment within the utility. Pattern: ^[A-Z0-9]{4}$.',
  `company_code` STRING COMMENT 'SAP company code representing the legal entity to which the organizational unit belongs. Used for financial consolidation and legal reporting. Pattern: ^[A-Z0-9]{4}$.',
  `contact_email` STRING COMMENT 'Primary contact email address for the organizational unit. Organizational contact data classified as confidential. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `contact_phone` STRING COMMENT 'Primary contact phone number for the organizational unit. Organizational contact data classified as confidential. Pattern: ^\\+?[1-9]\\d{1,14}$.',
  `contractor_workforce_flag` BOOLEAN COMMENT 'Indicates whether the organizational unit includes or manages contractor workforce in addition to direct employees.',
  `cost_center_code` STRING COMMENT 'Financial cost center code used for labor cost allocation to work orders and financial reporting. Links organizational unit to General Ledger (GL) structure. Pattern: ^[A-Z0-9]{4,15}$.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the organizational unit record was first created in the system. Used for audit trail and data lineage.',
  `effective_end_date` DATE COMMENT 'Date when the organizational unit was dissolved or became inactive. Null for currently active units. Used for temporal tracking of organizational changes.',
  `effective_start_date` DATE COMMENT 'Date when the organizational unit became effective and operational. Used for temporal tracking of organizational changes.',
  `emergency_response_flag` BOOLEAN COMMENT 'Indicates whether the organizational unit is designated for emergency response and storm restoration activities. Used for crew scheduling and dispatch during outage events.',
  `facility_location` STRING COMMENT 'Primary physical facility or location where the organizational unit is based (e.g., Main Office, Plant Site, Field Office, Operations Center).',
  `functional_area` STRING COMMENT 'Primary functional area or business domain that the organizational unit supports (e.g., generation, transmission, distribution, metering, customer service, engineering, maintenance). Reference-value candidates: generation|transmission|distribution|metering|customer_service|engineering|maintenance|operations|administration|safety|compliance|it|finance|hr.',
  `headcount_actual` INT COMMENT 'Current actual headcount assigned to the organizational unit. Updated based on active employee assignments.',
  `headcount_authorized` INT COMMENT 'Authorized or budgeted headcount for the organizational unit. Used for workforce planning and budget management.',
  `hierarchy_level` INT COMMENT 'Numeric level of the organizational unit within the hierarchy structure (e.g., 1=Division, 2=Department, 3=Work Group). Used for reporting rollups and organizational analysis.',
  `hierarchy_path` STRING COMMENT 'Full hierarchical path from root to current organizational unit (e.g., /CORP/OPERATIONS/TRANSMISSION/TRANS-OPS). Enables efficient hierarchy traversal and reporting.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the organizational unit record was last modified. Used for audit trail and change tracking.',
  `nerc_cip_boundary_flag` BOOLEAN COMMENT 'Indicates whether the organizational unit operates within the NERC CIP organizational boundary and is subject to CIP personnel risk assessment and access control requirements.',
  `org_unit_description` STRING COMMENT 'Detailed description of the organizational unit\'s purpose, responsibilities, and scope of work.',
  `profit_center_code` STRING COMMENT 'Profit center code for revenue and cost allocation in financial reporting. Used for business segment profitability analysis. Pattern: ^[A-Z0-9]{4,15}$.',
  `safety_jurisdiction` STRING COMMENT 'Primary OSHA safety jurisdiction governing the organizational unit (federal, state, local, or multi-jurisdiction). Determines applicable safety compliance requirements. Valid values: federal|state|local|multi_jurisdiction.',
  `service_territory` STRING COMMENT 'Geographic service territory or region that the organizational unit is responsible for (e.g., Northern Region, Metro District, Coastal Zone). Null for non-geographic units.',
  `union_affiliation` STRING COMMENT 'Union or collective bargaining unit affiliation for the organizational unit, if applicable (e.g., IBEW Local 1245, Utility Workers Union). Null for non-union units.',
  `unit_code` STRING COMMENT 'Business identifier code for the organizational unit used in operational systems and reporting (e.g., TRANS-OPS, DIST-FS, GEN-PLANT-01). Pattern: ^[A-Z0-9]{2,20}$.',
  `unit_name` STRING COMMENT 'Full business name of the organizational unit (e.g., Transmission Operations, Distribution Field Services, Generation Plant Crew, Metering Services).',
  `unit_status` STRING COMMENT 'Current lifecycle status of the organizational unit indicating operational state. Valid values: active|inactive|suspended|planned|dissolved.',
  `unit_type` STRING COMMENT 'Classification of the organizational unit type within the utility structure (e.g., division, department, work group, cost center, crew, team, plant, station). Reference-value candidates: division|department|work_group|cost_center|crew|team|plant|station.',
  `work_schedule_type` STRING COMMENT 'Standard work schedule type for the organizational unit (e.g., standard business hours, shift work, rotating shifts, on-call, flexible, 24x7 operations). Valid values: standard|shift|rotating|on_call|flexible|24x7.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_org_unit` PRIMARY KEY (`org_unit_id`)
)
USING DELTA
COMMENT 'Organizational hierarchy units representing departments, divisions, work groups, and cost centers within the utility (e.g., Transmission Operations, Distribution Field Services, Generation Plant Crew, Metering Services). Supports multi-level hierarchy for reporting, labor cost allocation to work orders, and NERC CIP organizational boundary management. | CMM: CIM Organisation (close), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'OrgUnit',
  'cmm.cim.class' = 'Organisation',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.org_unit'
);

-- Crew  <<CIM Crew : exact>>
CREATE TABLE IF NOT EXISTS `workforce`.`crew` (
  `crew_id` BIGINT NOT NULL COMMENT 'Unique identifier for the field crew. Primary key for crew master records.',
  `contractor_company_id` BIGINT COMMENT 'FK to supply.contractor_company',
  `crew_employee_id` BIGINT COMMENT 'FK to workforce.employee.employee_id — Each crew has a crew lead who is an employee. Required for crew dispatch, accountability, and labor cost allocation.',
  `crew_lead_employee_id` BIGINT COMMENT 'Reference to the employee serving as crew lead or foreman. Responsible for crew safety, work quality, and coordination with dispatch.',
  `crew_org_unit_id` BIGINT COMMENT 'Reference to the service center or operations base where the crew is permanently assigned. Determines jurisdiction, dispatch priority, and resource allocation.',
  `org_unit_id` BIGINT COMMENT 'FK to workforce.org_unit.org_unit_id — Crews belong to organizational units (e.g., Distribution Field Services, Transmission Operations). FK required for cost center allocation and management reporting.',
  `average_response_time_minutes` INT COMMENT 'Historical average time in minutes from dispatch to arrival at work site. Used for dispatch planning and System Average Interruption Duration Index (SAIDI) / System Average Interruption Frequency Index (SAIFI) performance analysis.',
  `certification_level` STRING COMMENT 'Highest certification or skill level represented in the crew. Determines work authorization scope (e.g., voltage class, confined space, energized work). Valid values: apprentice|journeyman|master|specialized.',
  `contractor_crew_flag` BOOLEAN COMMENT 'Indicates whether this is a contractor crew (true) or utility employee crew (false). Affects cost allocation, insurance requirements, and work authorization rules.',
  `cost_allocation_code` STRING COMMENT 'General Ledger (GL) or work management system code for allocating crew labor costs to work orders, capital projects, or Operations and Maintenance (O&M) accounts. Critical for regulatory cost recovery. Pattern: ^[A-Z0-9]{6,12}$.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the crew record was first created in the system. Used for audit trail and data lineage tracking.',
  `crew_code` STRING COMMENT 'Business identifier for the crew used in operational systems, work orders, and dispatch communications. Typically alphanumeric code assigned by service center or region. Pattern: ^[A-Z0-9]{4,12}$.',
  `crew_name` STRING COMMENT 'Human-readable name or designation of the crew, often including service center and crew number (e.g., \'Metro East Line Crew 3\', \'Substation Maintenance Team A\').',
  `crew_status` STRING COMMENT 'Current operational status of the crew. Active crews are available for dispatch; deployed crews are on assignment; standby crews are on-call; inactive crews are not available for work. Valid values: active|inactive|deployed|standby|training|suspended.',
  `crew_type` STRING COMMENT 'Classification of crew by primary function and skill set. Determines work order assignment eligibility, equipment requirements, and safety protocols. Reference-value candidates: line_crew|cable_crew|substation_crew|generation_maintenance_crew|vegetation_management_crew|meter_crew|emergency_response_crew|construction_crew|inspection_crew.',
  `deployment_personnel_count` INT COMMENT 'Number of crew members deployed on mutual aid assignment. May differ from standard crew size due to augmentation or splitting for deployment.',
  `dispatch_priority` INT COMMENT 'Numeric priority ranking for crew dispatch in Outage Management System (OMS) and Advanced Distribution Management System (ADMS). Lower numbers indicate higher priority (1=highest). Based on crew capability, location, and availability.',
  `effective_end_date` DATE COMMENT 'Date the crew was disbanded or deactivated. Null for active crews. Used for historical reporting and workforce planning analysis.',
  `effective_start_date` DATE COMMENT 'Date the crew was formed or became operational. Used for crew history tracking and performance trend analysis.',
  `equipment_assignment` STRING COMMENT 'List or description of specialized equipment assigned to the crew (e.g., bucket truck, digger derrick, cable splicer, hot stick kit). Determines work capability and safety compliance.',
  `gps_tracking_enabled` BOOLEAN COMMENT 'Indicates whether crew vehicle has active GPS tracking for real-time location monitoring in dispatch and fleet management systems.',
  `insurance_certificate_expiry_date` DATE COMMENT 'Expiration date of contractor liability insurance certificate. Crews cannot be dispatched if insurance is expired. Null for utility employee crews.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the crew record was last updated. Used for change tracking and data quality monitoring.',
  `last_safety_training_date` DATE COMMENT 'Date of most recent crew-level safety training session. Used to track compliance with annual refresher requirements and identify crews due for recertification.',
  `mutual_aid_eligible` BOOLEAN COMMENT 'Indicates whether the crew is eligible for deployment under EEI (Edison Electric Institute) or EATON mutual aid agreements during major storm events or grid emergencies at other utilities.',
  `nerc_cip_cleared` BOOLEAN COMMENT 'Indicates whether all crew members have completed NERC CIP personnel risk assessments and are authorized for work on critical cyber assets or bulk electric system facilities.',
  `notes` STRING COMMENT 'Free-text field for operational notes, special instructions, or crew-specific information (e.g., equipment limitations, training status, deployment restrictions).',
  `operational_readiness_status` STRING COMMENT 'Assessment of crew readiness for dispatch based on personnel availability, equipment status, certification currency, and safety compliance. Updated by crew lead and operations supervisor. Valid values: ready|not_ready|partial_readiness|under_review.',
  `osha_compliance_status` STRING COMMENT 'Current compliance status with OSHA safety training and certification requirements (1910.269 electric power generation, transmission, and distribution). Updated quarterly. Valid values: compliant|non_compliant|pending_review.',
  `primary_vehicle_code` BIGINT COMMENT 'Reference to the primary vehicle or truck assigned to the crew. Critical for dispatch routing, equipment tracking, and GPS-based crew location.',
  `reimbursable_cost_amount` DECIMAL(15,2) COMMENT 'Total reimbursable cost for mutual aid deployment including labor, equipment, travel, and lodging. Used for invoicing requesting utility and FEMA reimbursement claims.',
  `shift_schedule` STRING COMMENT 'Standard work shift assignment for the crew. Determines availability windows for dispatch and overtime calculation rules. Valid values: day_shift|night_shift|rotating_shift|on_call|storm_duty.',
  `size` INT COMMENT 'Number of personnel assigned to the crew. Varies by crew type and work complexity (typically 2-8 for line crews, 3-5 for substation crews).',
  `storm_duty_rotation` STRING COMMENT 'Assigned rotation group for storm duty and emergency response call-out. Determines crew availability during major events and ensures equitable distribution of overtime. Valid values: rotation_a|rotation_b|rotation_c|exempt|on_call.',
  `union_jurisdiction` STRING COMMENT 'Labor union local or jurisdiction governing crew members. Determines work rules, overtime provisions, and mutual aid deployment eligibility per collective bargaining agreement.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_crew` PRIMARY KEY (`crew_id`)
)
USING DELTA
COMMENT 'Field crew master records and deployment tracking for transmission and distribution construction, storm restoration, substation maintenance, and generation plant outage work. Captures crew type (line crew, cable crew, substation crew, generation maintenance crew, vegetation management crew), home base/service center location, crew size, crew lead employee reference, union jurisdiction, vehicle/equipment assignment, and operational readiness status. Includes mutual aid deployment records for crews mobilized under EEI/EATON mutual aid agreements during major storm events or grid emergencies — capturing requesting/providing utility, deployment dates, work location, restoration tasks performed, number of personnel, and reimbursable cost for FEMA reimbursement and post-storm after-action reporting. SSOT for crew identity, composition, and deployment lifecycle. Crews are the primary dispatch unit in OMS and ADMS and the cost collection unit for field labor. | CMM: CIM Crew (exact), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'Crew',
  'cmm.cim.class' = 'Crew',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.crew'
);

-- CrewAssignment  <<CIM CrewMember : close>>
CREATE TABLE IF NOT EXISTS `workforce`.`crew_assignment` (
  `crew_assignment_id` BIGINT NOT NULL COMMENT 'Unique identifier for the crew assignment record. Primary key for the crew assignment entity.',
  `crew_employee_id` BIGINT COMMENT 'FK to workforce.employee.employee_id — Each crew assignment record identifies which employee is assigned. Without this FK, crew composition is unknown and labor cost allocation to crew work is impossible.',
  `employee_id` BIGINT COMMENT 'FK to workforce.employee.employee_id — crew_assignment links an employee to a crew. Without FK to employee, you cannot determine crew composition for dispatch, safety compliance, or labor costing.',
  `primary_crew_employee_id` BIGINT COMMENT 'Unique identifier for the employee being assigned to the crew. Links to the employee master record in the workforce domain.',
  `primary_crew_id` BIGINT COMMENT 'Unique identifier for the crew to which the employee is assigned. Links to the crew master record.',
  `work_location_id` BIGINT COMMENT 'Identifier for the primary work location or service center where the crew is based and from which the employee operates during this assignment.',
  `approval_date` DATE COMMENT 'Date on which the crew assignment was approved by the authorized supervisor or workforce manager.',
  `assignment_approval_status` STRING COMMENT 'Approval workflow status for the crew assignment. Indicates whether the assignment has been approved by the appropriate supervisor or workforce manager. Valid values: pending|approved|rejected|cancelled.',
  `assignment_end_date` DATE COMMENT 'The date on which the employee\'s assignment to the crew ends or is scheduled to end. Null for open-ended standing assignments.',
  `assignment_end_timestamp` TIMESTAMP COMMENT 'Precise date and time when the crew assignment ends, used for shift-level and emergency response tracking where exact timing is critical.',
  `assignment_notes` STRING COMMENT 'Free-text notes or comments related to the crew assignment, capturing special instructions, restrictions, accommodation requirements, or other relevant information.',
  `assignment_number` STRING COMMENT 'Business-facing unique identifier for the crew assignment, used for tracking and reporting purposes. Format: CA-NNNNNNNN. Pattern: ^CA-[0-9]{8}$.',
  `assignment_priority` STRING COMMENT 'Priority level of the crew assignment indicating urgency and importance. Critical for emergency response, high for storm restoration, normal for routine operations, low for training or development assignments. Valid values: critical|high|normal|low.',
  `assignment_reason` STRING COMMENT 'Business reason or justification for the crew assignment, such as regular staffing, skill gap coverage, storm response, mutual aid request, training rotation, or backfill for absence.',
  `assignment_source_code` STRING COMMENT 'Unique identifier of this crew assignment record in the source system, used for data lineage and reconciliation.',
  `assignment_source_system` STRING COMMENT 'Name or code of the source system from which this crew assignment record originated, such as SAP HCM, workforce management system, or emergency response system.',
  `assignment_start_date` DATE COMMENT 'The date on which the employee\'s assignment to the crew becomes effective. Represents the beginning of the assignment period.',
  `assignment_start_timestamp` TIMESTAMP COMMENT 'Precise date and time when the crew assignment becomes effective, used for shift-level and emergency response tracking where exact timing is critical.',
  `assignment_status` STRING COMMENT 'Current lifecycle status of the crew assignment indicating whether the assignment is currently active, inactive, temporarily suspended, pending approval, or completed. Valid values: active|inactive|suspended|pending|completed.',
  `assignment_type` STRING COMMENT 'Classification of the crew assignment indicating whether it is a standing regular assignment, temporary assignment, emergency response, storm restoration, mutual aid support, or contractor augmentation. Valid values: standing|temporary|emergency|storm|mutual_aid|contractor.',
  `certification_required` STRING COMMENT 'Key certifications or qualifications required for the employee to hold this crew assignment, such as NERC CIP personnel risk assessment, CDL license, high voltage certification, or confined space entry qualification.',
  `cost_center_code` STRING COMMENT 'Financial cost center code to which labor costs for this crew assignment are allocated. Used for labor cost tracking and work order costing. Pattern: ^[0-9]{6,10}$.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this crew assignment record was first created in the source system or data warehouse.',
  `crew_role` STRING COMMENT 'Specific role or position the employee holds within the crew, such as crew lead, foreman, journeyman lineman, apprentice lineman, equipment operator, safety observer, or support technician. Reference-value candidates: crew_lead|foreman|journeyman_lineman|apprentice_lineman|equipment_operator|safety_observer|support_technician|meter_technician|substation_technician.',
  `effective_date` DATE COMMENT 'Date from which this crew assignment record is effective in the data warehouse, supporting slowly changing dimension (SCD) Type 2 historization.',
  `expiration_date` DATE COMMENT 'Date on which this crew assignment record expires or is superseded by a new version in the data warehouse, supporting slowly changing dimension (SCD) Type 2 historization. Null for current active records.',
  `is_current_record` BOOLEAN COMMENT 'Boolean flag indicating whether this is the current active version of the crew assignment record. True for the most recent version, false for historical versions.',
  `is_lead_role` BOOLEAN COMMENT 'Boolean flag indicating whether the employee holds a leadership or supervisory role within the crew (e.g., crew lead, foreman). True if the employee is responsible for crew direction and safety oversight.',
  `is_on_call` BOOLEAN COMMENT 'Boolean flag indicating whether the employee is assigned to on-call duty as part of this crew assignment, requiring availability for emergency response outside regular working hours.',
  `is_overtime_eligible` BOOLEAN COMMENT 'Boolean flag indicating whether the employee is eligible for overtime pay during this crew assignment based on labor agreements and regulatory requirements.',
  `is_primary_assignment` BOOLEAN COMMENT 'Boolean flag indicating whether this is the employee\'s primary crew assignment. True if this is the employee\'s home crew, false if this is a secondary or temporary assignment.',
  `labor_rate_code` STRING COMMENT 'Code identifying the labor rate or pay grade applicable to the employee for this crew assignment. Used for labor cost calculation and work order billing.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this crew assignment record was last updated or modified in the source system or data warehouse.',
  `shift_pattern` STRING COMMENT 'Work shift pattern or schedule applicable to this crew assignment, such as day shift, night shift, rotating shift, on-call, or 24/7 coverage pattern.',
  `union_local_code` STRING COMMENT 'Code identifying the union local or bargaining unit to which the employee belongs during this crew assignment. Relevant for union utilities with collective bargaining agreements.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_crew_assignment` PRIMARY KEY (`crew_assignment_id`)
)
USING DELTA
COMMENT 'Transactional records linking individual employees to crews for specific operational periods, capturing role within the crew (crew lead, journeyman lineman, apprentice, equipment operator), assignment start/end dates, and whether the assignment is a standing assignment or a temporary storm/emergency augmentation. Supports crew composition tracking and labor cost allocation. | CMM: CIM CrewMember (close), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CrewAssignment',
  'cmm.cim.class' = 'CrewMember',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.crew_assignment'
);

-- Certification  <<CIM Skill : close>>
CREATE TABLE IF NOT EXISTS `workforce`.`certification` (
  `certification_id` BIGINT NOT NULL COMMENT 'Unique identifier for the certification, qualification, or training program record. Primary key for the certification master catalog.',
  `applicable_job_classifications` STRING COMMENT 'Comma-separated list of job classification codes or titles for which this certification or training is mandatory or recommended (e.g., Lineman, Substation Operator, Generation Unit Operator, SCADA Operator, Meter Reader, Field Service Technician). Used for workforce compliance tracking and training assignment.',
  `applicable_nerc_cip_roles` STRING COMMENT 'Comma-separated list of NERC CIP access roles or cyber security positions for which this certification is required (e.g., CIP Senior Manager, CIP Authorized User, Physical Security Perimeter Access, Electronic Security Perimeter Access). Null if not applicable to NERC CIP roles.',
  `certification_category` STRING COMMENT 'High-level classification of the credential type. External certifications are issued by third-party bodies (NERC, OSHA, state licensing boards). Internal qualifications are assessed by utility subject matter experts. Training programs are mandatory or elective learning curricula. Valid values: external_certification|internal_qualification|safety_training|compliance_training|technical_training|leadership_training.',
  `certification_code` STRING COMMENT 'Unique business identifier code for the certification, qualification, or training program. Used for external reference and system integration (e.g., NERC-CIP-PRA, OSHA-30, CDL-A, LINEMAN-JOURNEYMAN). Pattern: ^[A-Z0-9_-]{3,20}$.',
  `certification_level` STRING COMMENT 'Hierarchical level or grade of the certification within a progression path (e.g., Apprentice, Journeyman, Master; Level 1, Level 2, Level 3; Basic, Intermediate, Advanced). Used for career development planning and pay grade determination. Null if not part of a leveled progression.',
  `certification_name` STRING COMMENT 'Full official name of the certification, qualification, or training program (e.g., NERC CIP Personnel Risk Assessment Clearance, OSHA 30-Hour Construction Safety, Commercial Driver License Class A, Journeyman Lineman Qualification).',
  `certification_status` STRING COMMENT 'Current lifecycle status of the certification or training program in the utility workforce management system. Active programs are available for assignment and tracking. Inactive programs are temporarily suspended. Retired programs are no longer offered but historical records are retained. Valid values: active|inactive|retired|under_review.',
  `certification_type` STRING COMMENT 'Detailed sub-classification of the certification within its category (e.g., NERC CIP Security Clearance, OSHA Safety Training, State Electrical License, CDL Endorsement, Operator Authorization, Safety Qualification, Technical Skill Assessment).',
  `continuing_education_hours_required` DECIMAL(6,2) COMMENT 'Number of continuing education hours or CEUs required per renewal cycle to maintain the certification. Null if continuing education is not required.',
  `continuing_education_required_flag` BOOLEAN COMMENT 'Indicates whether this certification requires continuing education units (CEUs) or professional development hours to maintain active status. True if ongoing learning is mandated by the issuing body or utility policy.',
  `cost_per_participant` DECIMAL(10,2) COMMENT 'Average cost in USD to train or certify one employee, including instructor fees, materials, facility costs, external exam fees, and travel expenses. Used for workforce training budget planning and labor cost allocation to capital projects and work orders.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this certification record was first created in the workforce management system. Used for audit trail and data lineage tracking.',
  `delivery_method` STRING COMMENT 'Primary method by which the training or qualification assessment is delivered. Classroom for instructor-led in-person sessions. Online for e-learning modules. Field practical for hands-on field exercises. Simulator for control room or equipment simulators. Blended for combination. On-the-job for supervised work-based learning. Valid values: classroom|online|field_practical|simulator|blended|on_the_job.',
  `effective_date` DATE COMMENT 'Date on which this certification or training program became active and available for assignment in the utility workforce management system. Used for historical tracking of certification requirements changes.',
  `expiration_date` DATE COMMENT 'Date on which this certification or training program was retired or became inactive. Null if currently active. Used for historical tracking and compliance audit trails.',
  `external_exam_fee` DECIMAL(10,2) COMMENT 'Fee charged by external issuing body for certification exam or assessment (e.g., NERC CIP PRA background check fee, state electrical license exam fee, CDL road test fee). Null if no external fee applies.',
  `instructor_qualification_required` STRING COMMENT 'Description of the qualifications or certifications required for instructors who deliver this training program (e.g., Certified OSHA Trainer, Master Electrician with 10+ years experience, NERC-approved instructor, Internal Subject Matter Expert with Instructor Certification). Null if not applicable.',
  `issuing_body` STRING COMMENT 'Name of the external organization or internal department that issues, assesses, or administers the certification or training program (e.g., NERC, OSHA, State Department of Motor Vehicles, State Electrical Licensing Board, Internal Training Department, Operations Department).',
  `issuing_body_type` STRING COMMENT 'Classification of the issuing body as external regulatory authority (NERC, FERC), external industry association, external government agency (OSHA, state DMV), or internal utility department. Valid values: external_regulatory|external_industry|external_government|internal_utility.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this certification record was last updated in the workforce management system. Used for audit trail and change tracking.',
  `last_review_date` DATE COMMENT 'Date on which the certification or training program content, requirements, and delivery methods were last reviewed and validated by subject matter experts or regulatory compliance team. Used for quality assurance and continuous improvement.',
  `mandatory_flag` BOOLEAN COMMENT 'Indicates whether this certification or training is mandatory for specific job classifications, NERC CIP access roles, or regulatory compliance. True if required by regulation, union agreement, or internal safety policy; False if elective or role-specific.',
  `minimum_passing_score` DECIMAL(5,2) COMMENT 'Minimum score or percentage required to pass the certification exam or assessment. Null if pass/fail is not score-based (e.g., competency-based assessments, background checks).',
  `nerc_cip_required_flag` BOOLEAN COMMENT 'Indicates whether this certification is required for personnel with NERC CIP access roles (e.g., NERC CIP Personnel Risk Assessment clearance, NERC CIP security awareness training). True if mandated by NERC CIP-004 personnel risk assessment and training standards.',
  `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review of the certification or training program content, requirements, and delivery methods. Used for training program governance and compliance assurance.',
  `notes` STRING COMMENT 'Free-text field for additional information about the certification or training program, including special requirements, exceptions, historical context, or implementation guidance for workforce administrators.',
  `osha_compliance_flag` BOOLEAN COMMENT 'Indicates whether this certification or training is required for OSHA workplace safety compliance (e.g., OSHA 10/30-hour training, lockout/tagout, confined space entry, fall protection, arc flash safety). True if mandated by OSHA regulations for utility field and plant operations.',
  `pass_fail_criteria` STRING COMMENT 'Description of the criteria used to determine successful completion of the certification or training program (e.g., minimum exam score of 80%, successful completion of field practical assessment, supervisor sign-off on competency checklist, background check clearance).',
  `prerequisite_certifications` STRING COMMENT 'Comma-separated list of certification codes that must be held before an employee can pursue this certification or training program (e.g., OSHA-10 required before OSHA-30, Apprentice Lineman required before Journeyman Lineman). Null if no prerequisites.',
  `program_owner` STRING COMMENT 'Name or title of the internal department, manager, or subject matter expert responsible for maintaining the certification or training program content, delivery, and compliance tracking (e.g., Training Manager, Safety Director, Operations Manager, HR Learning and Development).',
  `regulatory_authority` STRING COMMENT 'Name of the regulatory body or government agency that mandates this certification or training for utility workforce compliance (e.g., NERC, FERC, OSHA, State Public Utility Commission, State Department of Labor, EPA). Null if not mandated by external regulation.',
  `regulatory_citation` STRING COMMENT 'Specific regulation, standard, or code section that mandates this certification or training (e.g., NERC CIP-004-6 R3, OSHA 29 CFR 1910.147, State Electrical Code Section 123.45). Used for compliance audit trails and regulatory reporting.',
  `renewal_cycle_months` INT COMMENT 'Number of months between required renewals or recertifications. Used for workforce planning and compliance tracking. Null if the certification does not require periodic renewal.',
  `renewal_grace_period_days` INT COMMENT 'Number of days after expiration during which the certification holder may continue working while renewal is in progress, per utility policy or union agreement. Null if no grace period is allowed.',
  `training_duration_hours` DECIMAL(6,2) COMMENT 'Total number of instructional hours required to complete the training program or qualification assessment. Used for workforce scheduling and labor cost allocation. Null if not applicable (e.g., external certifications obtained outside utility training programs).',
  `training_materials_url` STRING COMMENT 'URL or file path to the training curriculum, course materials, study guides, or certification requirements documentation stored in the utility document management system or learning management system (LMS). Null if not available.',
  `training_vendor` STRING COMMENT 'Name of the external training vendor or provider contracted to deliver this training program, if applicable. Null if training is delivered internally by utility staff.',
  `union_agreement_reference` STRING COMMENT 'Reference to the collective bargaining agreement article or section that governs this certification or training requirement, including provisions for training time compensation, certification pay differentials, and apprenticeship progression. Null if not covered by union agreement.',
  `validity_period_days` INT COMMENT 'Number of days the certification or qualification remains valid from the date of issuance or completion before renewal is required. Null if the certification does not expire (e.g., some internal qualifications are valid indefinitely unless revoked).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_certification` PRIMARY KEY (`certification_id`)
)
USING DELTA
COMMENT 'Master catalog of all required certifications, licenses, qualifications, and training programs applicable to utility workforce roles, including safety training curricula and session delivery records. Covers externally-issued certifications (NERC CIP PRA clearance, OSHA 10/30, CDL, state electrical contractor license, first aid/CPR), internally-assessed qualifications (journeyman lineman, substation operator, generation unit operator, SCADA operator authorization), and mandatory safety and compliance training programs (lockout/tagout, confined space entry, arc flash safety, fall protection, hazmat, NERC CIP security awareness). Defines credential name, credential category (certification, qualification, training), issuing body or internal program owner, validity period, renewal cycle, delivery method options (classroom, online, field), pass/fail criteria, instructor requirements, and whether it is mandatory for specific job classifications or NERC CIP access roles. Training session delivery records capture session date, instructor, delivery method, attendees, completion status, and next required date. SSOT for all credential definitions and training program delivery in the utility workforce. | CMM: CIM Skill (close), IEC61968::InfCommon.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'Certification',
  'cmm.cim.class' = 'Skill',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfCommon',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'reference_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.certification'
);

-- EmployeeCertification  <<CIM ErpCompetency : close>>
CREATE TABLE IF NOT EXISTS `workforce`.`employee_certification` (
  `employee_certification_id` BIGINT NOT NULL COMMENT 'Unique identifier for the employee certification record. Primary key for the employee certification entity.',
  `certification_id` BIGINT COMMENT 'Foreign key linking to workforce.certification. Business justification: employee_certification should reference the master certification catalog to normalize certification details. Currently stores certification_name, certification_type, certification_category, issuing_au',
  `primary_employee_id` BIGINT COMMENT 'Identifier of the employee or contractor who holds this certification or qualification. Links to the employee master record in the workforce domain.',
  `tertiary_employee_id` BIGINT COMMENT 'FK to workforce.employee.employee_id — employee_certification is a transactional child of employee. FK required for credential expiration alerts, NERC CIP-004 audit evidence, and qualification-based crew dispatch.',
  `assessment_date` DATE COMMENT 'The date on which the employee was assessed or tested for the qualification or competency. Applicable primarily to internal qualifications and skills assessments.',
  `assessment_score` DECIMAL(5,2) COMMENT 'The numerical score or percentage achieved by the employee on the certification exam or competency assessment. Null if no scored assessment was required.',
  `attachment_reference` STRING COMMENT 'Reference identifier or file path to the scanned certificate, training completion document, or other supporting documentation stored in the document management system.',
  `certification_status` STRING COMMENT 'Current lifecycle status of the certification: active (valid and current), expired (past expiration date), suspended (temporarily invalid), revoked (permanently invalid), pending_renewal (renewal in process), in_progress (training/assessment underway). Valid values: active|expired|suspended|revoked|pending_renewal|in_progress.',
  `competency_level` STRING COMMENT 'The level of competency or proficiency achieved by the employee for this certification or qualification (e.g., apprentice, journeyman, master for trades; operator levels for plant/SCADA operators). Reference-value candidates: apprentice|journeyman|master|operator_level_1|operator_level_2|operator_level_3|certified|qualified.',
  `compliance_flag` BOOLEAN COMMENT 'Boolean indicator of whether this certification is currently in compliance with regulatory or internal requirements. True if active and not expired; False if expired, suspended, or revoked.',
  `cost_amount` DECIMAL(12,2) COMMENT 'The total cost incurred by the utility to obtain or renew this certification for the employee, including training fees, exam fees, travel, and materials. Used for workforce development cost tracking.',
  `cost_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the certification cost amount (e.g., USD, CAD, EUR). Pattern: ^[A-Z]{3}$.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this certification record was first created in the system. Used for audit trail and data lineage tracking.',
  `crew_dispatch_eligibility_flag` BOOLEAN COMMENT 'Boolean indicator of whether this certification qualifies the employee for field crew dispatch assignments. True if the certification enables dispatch eligibility (e.g., journeyman lineman, CDL, OSHA training current).',
  `dot_compliance_flag` BOOLEAN COMMENT 'Boolean indicator of whether this certification is required for DOT compliance (e.g., Commercial Drivers License CDL, DOT medical certification, hazardous materials endorsement). True if DOT-mandated.',
  `employee_certification_instance_of_catalog` BIGINT COMMENT 'FK to workforce.certification.certification_id — employee_certification references the certification catalog to identify which credential was earned. Required for renewal cycle management and compliance reporting by credential type.',
  `employee_certification_instance_of_type` BIGINT COMMENT 'FK to workforce.certification.certification_id — Each employee certification instance references a certification type from the catalog. This drives renewal requirements, validity periods, and mandatory-for-job-classification rules.',
  `equipment_authorization` STRING COMMENT 'Specific equipment, tools, or systems the employee is authorized to operate or maintain based on this certification (e.g., bucket truck, aerial lift, high-voltage switchgear, DMS/SCADA console).',
  `expiration_date` DATE COMMENT 'The date on which the certification or qualification expires and requires renewal. Null for certifications with no expiration (e.g., some apprenticeship completions).',
  `instructor_name` STRING COMMENT 'The name of the instructor or assessor who conducted the training or competency assessment. Used for internal quality assurance and audit trails.',
  `issue_date` DATE COMMENT 'The date on which the certification, qualification, or training completion was officially issued or awarded to the employee.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this certification record was last updated in the system. Used for audit trail and change tracking.',
  `last_verification_date` DATE COMMENT 'The date on which the certification was last verified with the issuing authority or through internal audit. Used for NERC CIP audit evidence and compliance validation.',
  `nerc_cip_flag` BOOLEAN COMMENT 'Boolean indicator of whether this certification is required for NERC CIP compliance, specifically for personnel with access to critical cyber assets or bulk electric system facilities. True if NERC CIP-004 Personnel Risk Assessment or related training.',
  `notes` STRING COMMENT 'Free-text field for additional comments, special conditions, restrictions, or context related to the certification (e.g., conditional approval, specific limitations, renewal in progress details).',
  `osha_compliance_flag` BOOLEAN COMMENT 'Boolean indicator of whether this certification is required for OSHA safety compliance (e.g., OSHA 10/30-hour training, confined space, lockout/tagout, fall protection). True if OSHA-mandated.',
  `passing_score_threshold` DECIMAL(5,2) COMMENT 'The minimum score or percentage required to pass the certification exam or competency assessment. Used to determine qualification status.',
  `qualification_area` STRING COMMENT 'The specific technical or operational area for which the employee is qualified (e.g., transmission line work, substation maintenance, generation unit operation, SCADA system operation, meter installation).',
  `regulatory_requirement_flag` BOOLEAN COMMENT 'Boolean indicator of whether this certification is mandated by external regulatory bodies (NERC, OSHA, DOT, EPA, state licensing boards). True if regulatory-required; False if internal or voluntary.',
  `renewal_reminder_days` INT COMMENT 'Number of days before expiration that renewal reminder notifications should be triggered. Used by compliance alert systems to notify employees and managers of upcoming expirations.',
  `renewal_status` STRING COMMENT 'Status of the certification renewal process: not_required (no expiration), upcoming (renewal due soon), overdue (past expiration), in_progress (renewal underway), completed (renewal finished). Valid values: not_required|upcoming|overdue|in_progress|completed.',
  `training_hours` DECIMAL(8,2) COMMENT 'Total number of training hours completed to achieve this certification or qualification. Used for OSHA compliance reporting and internal training tracking.',
  `training_provider` STRING COMMENT 'The name of the organization or vendor that delivered the training program (e.g., internal training department, external training vendor, community college, trade association).',
  `union_requirement_flag` BOOLEAN COMMENT 'Boolean indicator of whether this certification is required by collective bargaining agreements or union contracts. True if union-mandated.',
  `verification_method` STRING COMMENT 'The method used to verify the authenticity and validity of the certification: issuer_database (checked with issuing authority), physical_certificate (physical document reviewed), employee_attestation (employee self-certification), manager_verification (manager confirmed), third_party_audit (external auditor verified). Valid values: issuer_database|physical_certificate|employee_attestation|manager_verification|third_party_audit.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_employee_certification` PRIMARY KEY (`employee_certification_id`)
)
USING DELTA
COMMENT 'SSOT for all individual employee and contractor credential records — covering externally-issued certifications (NERC CIP PRA clearance, OSHA 10/30, CDL, state electrical contractor license, first aid/CPR), internally-assessed qualifications (journeyman lineman, substation operator, generation unit operator, SCADA operator authorization, apprenticeship completions), and training completion records. Captures credential source type (external_certification, internal_qualification, training_completion), issue date, expiration date, issuing authority or internal assessor, certificate number, competency level achieved, assessment date, renewal status, and compliance flag. Drives compliance alerts for expiring credentials, NERC CIP-004 audit evidence, OSHA training compliance, DOT certification tracking, and qualification-based crew dispatch eligibility. | CMM: CIM ErpCompetency (close), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'EmployeeCertification',
  'cmm.cim.class' = 'ErpCompetency',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.employee_certification'
);

-- SafetyIncident  <<CIM Incident : extension>>
CREATE TABLE IF NOT EXISTS `workforce`.`safety_incident` (
  `safety_incident_id` BIGINT NOT NULL COMMENT 'Unique identifier for the safety incident record. Primary key for the safety incident entity.',
  `power_plant_id` BIGINT COMMENT 'Identifier of the utility facility where the incident occurred (generation plant, substation, service center, warehouse). Links to asset facility master data.',
  `primary_safety_employee_id` BIGINT COMMENT 'Identifier of the primary employee involved in the safety incident. Links to workforce employee master data.',
  `quaternary_safety_modified_by_employee_id` BIGINT COMMENT 'Identifier of the employee who last modified the safety incident record. Used for audit trail and accountability.',
  `safety_employee_id` BIGINT COMMENT 'FK to workforce.employee.employee_id — Safety incidents involve specific employees. OSHA 300 log reporting requires employee identification. Note: may need a junction for multi-employee incidents, but the primary FK is essential.',
  `tertiary_safety_reported_by_employee_id` BIGINT COMMENT 'Identifier of the employee who reported the incident. May differ from the injured employee in cases of witness reporting or near-miss observations.',
  `work_order_id` BIGINT COMMENT 'Identifier of the work order being executed when the incident occurred. Links incident to maintenance or construction activity for root cause analysis.',
  `body_part_affected` STRING COMMENT 'Body part(s) injured in the incident (e.g., hand, back, eyes, head, multiple). Used for injury trend analysis and PPE effectiveness evaluation.',
  `chain_of_custody_number` STRING COMMENT 'Unique identifier for the drug/alcohol test specimen chain-of-custody documentation. Links to laboratory records and ensures specimen integrity per DOT requirements.',
  `corrective_actions` STRING COMMENT 'Documented corrective and preventive actions taken or planned to prevent recurrence of similar incidents (e.g., procedure revision, additional training, equipment modification, PPE upgrade).',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the safety incident record was first created in the system. Used for audit trail and data lineage tracking.',
  `days_away_from_work` INT COMMENT 'Number of calendar days the employee was unable to work as a result of the incident. Used to calculate DART (Days Away, Restricted, or Transferred) rate.',
  `days_on_restricted_duty` INT COMMENT 'Number of calendar days the employee was on restricted work activity or job transfer due to the incident. Used to calculate DART rate.',
  `dot_test_type` STRING COMMENT 'For drug/alcohol test incidents: type of DOT-mandated test per 49 CFR Part 40. Pre-employment (before hire), random (unannounced selection), post-accident (after qualifying incident), reasonable suspicion (supervisor-initiated), return-to-duty (after violation), follow-up (ongoing monitoring). Valid values: pre_employment|random|post_accident|reasonable_suspicion|return_to_duty|follow_up.',
  `environmental_conditions` STRING COMMENT 'Description of environmental factors at the time of the incident (e.g., weather, lighting, temperature, noise level, confined space). Used for root cause analysis.',
  `equipment_involved` STRING COMMENT 'Description or identifier of equipment, tools, or vehicles involved in the incident. Used to identify equipment-related hazards and maintenance needs.',
  `incident_category` STRING COMMENT 'Classification of the safety event type: injury (physical harm), near_miss (potential incident avoided), vehicle_accident (fleet collision), hazmat_exposure (hazardous material contact), drug_alcohol_test (DOT compliance testing), fitness_for_duty (medical clearance event). Valid values: injury|near_miss|vehicle_accident|hazmat_exposure|drug_alcohol_test|fitness_for_duty.',
  `incident_date` DATE COMMENT 'Calendar date when the safety incident occurred. Critical for OSHA 300 log chronological recording and regulatory reporting timelines.',
  `incident_description` STRING COMMENT 'Detailed narrative description of how the incident occurred, what the employee was doing, and the sequence of events leading to the incident.',
  `incident_number` STRING COMMENT 'Business identifier for the safety incident, typically formatted as SI-YYYYMMDD-sequence for external reference and reporting. Pattern: ^SI-[0-9]{8}$.',
  `incident_time` TIMESTAMP COMMENT 'Precise timestamp when the safety incident occurred, including time zone. Used for shift analysis, response time calculation, and detailed incident reconstruction.',
  `injury_type` STRING COMMENT 'Nature of the injury sustained (e.g., laceration, fracture, burn, electric shock, strain, contusion, amputation, respiratory condition). Free text or standardized code.',
  `investigation_completed_date` DATE COMMENT 'Date when the incident investigation was completed and findings were documented. Used to track investigation cycle time and regulatory compliance.',
  `investigation_status` STRING COMMENT 'Current status of the incident investigation workflow: not_started (incident logged, investigation pending), in_progress (active investigation), completed (findings documented), closed (corrective actions implemented and verified). Valid values: not_started|in_progress|completed|closed.',
  `location_description` STRING COMMENT 'Textual description of where the incident occurred (e.g., substation yard, transmission line mile marker, generation plant turbine hall, customer premise, public road).',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the safety incident record was last modified. Used for audit trail and change tracking.',
  `mro_name` STRING COMMENT 'Name of the Medical Review Officer who reviewed and verified the drug test result. Required for DOT compliance documentation.',
  `mro_review_status` STRING COMMENT 'Status of Medical Review Officer review for drug test results. MRO verifies positive results and evaluates legitimate medical explanations per DOT 49 CFR Part 40. Valid values: pending|reviewed|verified_negative|verified_positive.',
  `nerc_cip_reportable_flag` BOOLEAN COMMENT 'Indicates whether the incident involves personnel with NERC CIP-designated access and requires reporting under CIP-004 personnel risk assessment standards.',
  `osha_300_log_reference` STRING COMMENT 'Reference number or case number assigned to this incident on the OSHA 300 log for the establishment and calendar year.',
  `osha_recordable_flag` BOOLEAN COMMENT 'Indicates whether the incident meets OSHA criteria for recordability on the OSHA 300 log. True if recordable per 29 CFR 1904.4-1904.7.',
  `ppe_in_use` STRING COMMENT 'Description of personal protective equipment the employee was wearing at the time of the incident (e.g., hard hat, safety glasses, gloves, arc flash suit, fall protection). Used to assess PPE effectiveness.',
  `regulatory_notification_date` TIMESTAMP COMMENT 'Timestamp when regulatory notification was made to OSHA or other agencies. Used to verify compliance with notification deadlines.',
  `regulatory_notification_required_flag` BOOLEAN COMMENT 'Indicates whether the incident severity requires notification to OSHA, state agencies, or other regulatory bodies within mandated timeframes (e.g., fatality within 8 hours, hospitalization within 24 hours).',
  `reported_date` DATE COMMENT 'Date when the incident was formally reported to management or safety department. Used to track reporting timeliness and compliance with notification requirements.',
  `root_cause_analysis` STRING COMMENT 'Findings from the root cause investigation identifying underlying factors that contributed to the incident (e.g., inadequate training, equipment failure, procedural gap, environmental hazard).',
  `sap_name` STRING COMMENT 'Name of the Substance Abuse Professional assigned to the employee for evaluation and treatment. Confidential per DOT privacy requirements.',
  `sap_referral_flag` BOOLEAN COMMENT 'Indicates whether the employee was referred to a Substance Abuse Professional for evaluation and treatment following a positive test or refusal. Required per DOT 49 CFR Part 40.287.',
  `severity_classification` STRING COMMENT 'Severity level of the incident: fatality (death), lost_time (days away from work), restricted_duty (job transfer or restriction), medical_treatment (beyond first aid), first_aid (minor treatment), near_miss (no injury). Valid values: fatality|lost_time|restricted_duty|medical_treatment|first_aid|near_miss.',
  `test_result` STRING COMMENT 'Outcome of the drug or alcohol test: negative (no substances detected), positive (prohibited substance detected), refused (employee declined test), invalid (specimen issue), cancelled (procedural error). Confidential per DOT regulations. Valid values: negative|positive|refused|invalid|cancelled.',
  `testing_provider` STRING COMMENT 'Name of the DOT-certified laboratory or collection site that performed the drug/alcohol test. Required for chain-of-custody documentation.',
  `witness_count` INT COMMENT 'Number of witnesses to the incident. Used to assess investigation completeness and corroboration of incident details.',
  `workers_comp_claim_number` STRING COMMENT 'Workers compensation insurance claim number associated with the incident. Links safety incident to financial and medical case management systems.',
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
  CONSTRAINT `pk_workforce_safety_incident` PRIMARY KEY (`safety_incident_id`)
)
USING DELTA
COMMENT 'OSHA-recordable and non-recordable safety events, compliance incidents, and DOT/utility-mandated drug and alcohol test results for utility workforce. Captures event category (injury, near_miss, vehicle_accident, hazmat_exposure, drug_alcohol_test, fitness_for_duty), event date/time, location, employee(s) involved, severity classification, OSHA recordability flag, days away/restricted/transferred, root cause analysis, corrective actions, OSHA 300 log reference, and follow-up actions. For drug/alcohol test events: captures DOT 49 CFR Part 40 test type (pre-employment, random, post-accident, reasonable suspicion, return-to-duty), testing provider, result (negative/positive/refused), MRO review status, SAP referral, and chain-of-custody documentation. SSOT for all safety events and DOT compliance testing. Supports OSHA 300/300A annual reporting, TRIR/DART rate calculation, DOT 49 CFR Part 40 compliance, and safety performance trending. | CMM: CIM Incident (extension), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SafetyIncident',
  'cmm.cim.class' = 'Incident',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.safety_incident',
  'cmm.gis.location.role' = 'Incident.Location'
);

-- SafetyTraining  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `workforce`.`safety_training` (
  `safety_training_id` BIGINT NOT NULL COMMENT 'Unique identifier for the safety training session record. Primary key.',
  `primary_safety_employee_id` BIGINT COMMENT 'Identifier of the utility workforce employee who attended the training session. Links to workforce employee master data.',
  `training_program_id` BIGINT COMMENT 'Identifier of the safety training program or course catalog entry. Links to training program master data.',
  `work_order_id` BIGINT COMMENT 'Identifier of the work order to which training labor costs are allocated, if applicable. Links to asset management work order data.',
  `assessment_required_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the training program requires a formal assessment or examination for completion.',
  `assessment_score` DECIMAL(5,2) COMMENT 'Numerical score achieved by the employee on the training assessment or examination, if applicable. Typically expressed as a percentage.',
  `attendance_status` STRING COMMENT 'Status indicating whether the employee attended the full training session, was absent, attended partially, or was excused. Valid values: Attended|Absent|Partial|Excused.',
  `certification_expiration_date` DATE COMMENT 'Date on which the certification or credential expires and requires renewal or recertification.',
  `certification_issue_date` DATE COMMENT 'Date on which the certification or credential was issued to the employee.',
  `certification_issued_flag` BOOLEAN COMMENT 'Boolean flag indicating whether a formal certification or credential was issued to the employee upon successful completion of the training.',
  `certification_number` STRING COMMENT 'Unique certification or credential number issued to the employee upon successful completion of the training, if applicable.',
  `completion_status` STRING COMMENT 'Status indicating whether the employee successfully completed the training requirements. Valid values: Completed|Incomplete|In Progress|Failed|Waived.',
  `compliance_evidence_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this training record serves as formal compliance evidence for regulatory audits (OSHA, NERC CIP, state PUC).',
  `delivery_method` STRING COMMENT 'Method by which the training was delivered to the employee (classroom instruction, online e-learning, field demonstration, simulator-based, hybrid, or on-the-job training). Valid values: Classroom|Online|Field|Simulator|Hybrid|On-the-Job.',
  `instructor_name` STRING COMMENT 'Name of the instructor or trainer who delivered the safety training session.',
  `mandatory_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this training is mandatory for the employee based on their role, job function, or regulatory requirements.',
  `next_required_training_date` DATE COMMENT 'Date by which the employee must complete the next required training session or recertification to maintain compliance.',
  `pass_fail_status` STRING COMMENT 'Outcome of the training assessment indicating whether the employee passed, failed, was not assessed, or has a pending result. Valid values: Pass|Fail|Not Assessed|Pending.',
  `passing_score_threshold` DECIMAL(5,2) COMMENT 'Minimum score required to pass the training assessment and achieve certification, expressed as a percentage.',
  `recertification_interval_months` INT COMMENT 'Number of months between required recertification or refresher training sessions for this safety program.',
  `record_active_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this training record is currently active and valid, or has been superseded or voided.',
  `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this safety training record was first created in the system.',
  `record_source_system` STRING COMMENT 'Name of the source system from which this safety training record originated (e.g., SAP S/4HANA HCM, Learning Management System, Contractor Management System).',
  `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this safety training record was last updated or modified in the system.',
  `regulatory_requirement` STRING COMMENT 'Specific regulatory standard or requirement that mandates this training (e.g., OSHA 1910.147 Lockout/Tagout, NERC CIP-004-6 Personnel Risk Assessment, OSHA 1910.269 Electric Power Generation).',
  `training_category` STRING COMMENT 'High-level category of the safety training program for classification and reporting purposes. Reference-value candidates: OSHA.',
  `training_cost_amount` DECIMAL(15,2) COMMENT 'Total cost incurred for delivering this training session, including instructor fees, materials, facility rental, and employee time. Used for labor cost allocation to work orders and capital projects.',
  `training_cost_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the training cost amount. Typically USD for US-based energy utilities. Valid values: USD.',
  `training_date` DATE COMMENT 'Date on which the safety training session was delivered to the employee.',
  `training_duration_hours` DECIMAL(5,2) COMMENT 'Total duration of the training session in hours, used for compliance reporting and labor cost allocation.',
  `training_end_time` TIMESTAMP COMMENT 'Timestamp when the training session ended, used for attendance tracking and duration calculation.',
  `training_facility_code` BIGINT COMMENT 'Identifier of the facility or site where the training was conducted, if applicable. Links to facility master data.',
  `training_location` STRING COMMENT 'Physical or virtual location where the training was conducted (e.g., training center name, plant site, online platform).',
  `training_materials_provided` STRING COMMENT 'Description or list of training materials provided to the employee (e.g., manuals, handouts, online resources, safety equipment).',
  `training_notes` STRING COMMENT 'Free-text notes or comments about the training session, including special circumstances, accommodations, or observations by the instructor.',
  `training_start_time` TIMESTAMP COMMENT 'Timestamp when the training session started, used for attendance tracking and duration calculation.',
  `training_type` STRING COMMENT 'Type of training session indicating whether it is initial certification, recertification, refresher, or remedial training. Valid values: Initial Certification|Recertification|Refresher|Remedial|Advanced|Specialized.',
  `training_vendor_name` STRING COMMENT 'Name of the external training vendor or provider, if the training was delivered by a third-party organization rather than internal staff.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_safety_training` PRIMARY KEY (`safety_training_id`)
)
USING DELTA
COMMENT 'Records of safety training sessions delivered to utility workforce personnel, including OSHA-mandated training (lockout/tagout, confined space entry, arc flash, fall protection, hazmat), NERC CIP security awareness training, and utility-specific operational safety programs. Captures training program name, delivery date, instructor, delivery method (classroom, online, field), employees trained, pass/fail status, and next required date. Supports OSHA compliance and NERC CIP-004 security awareness evidence. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'SafetyTraining',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.safety_training'
);

-- UnionAgreement  <<CIM Agreement : extension>>
CREATE TABLE IF NOT EXISTS `workforce`.`union_agreement` (
  `union_agreement_id` BIGINT NOT NULL COMMENT 'Unique identifier for the collective bargaining agreement record. Primary key.',
  `primary_successor_agreement_union_agreement_id` BIGINT COMMENT 'Reference to the collective bargaining agreement that supersedes this agreement upon expiration.',
  `agreement_name` STRING COMMENT 'Descriptive name of the collective bargaining agreement, typically including union name and bargaining unit.',
  `agreement_number` STRING COMMENT 'Externally-known unique identifier for the collective bargaining agreement, typically formatted as CBA-XXXXXX. Pattern: ^CBA-[0-9]{6}$.',
  `agreement_status` STRING COMMENT 'Current lifecycle status of the collective bargaining agreement. Reference-value candidates: draft|negotiation|ratified|active|expired|terminated|superseded.',
  `agreement_type` STRING COMMENT 'Classification of the collective bargaining agreement document type. Valid values: master|supplemental|memorandum_of_understanding|side_letter|extension.',
  `arbitration_cost_sharing` STRING COMMENT 'Method for allocating arbitration costs between the utility and union. Valid values: employer_pays|union_pays|split_equally|loser_pays.',
  `arbitration_provision_flag` BOOLEAN COMMENT 'Indicates whether the agreement includes binding arbitration as the final step in the grievance procedure.',
  `arbitrator_selection_method` STRING COMMENT 'Process defined in the agreement for selecting a neutral arbitrator (e.g., FMCS panel, AAA list, permanent umpire).',
  `bargaining_unit_description` STRING COMMENT 'Detailed description of the scope and composition of the bargaining unit, including covered job classifications and exclusions.',
  `bargaining_unit_name` STRING COMMENT 'Name of the employee group covered by this agreement (e.g., Field Operations Unit, Generation Plant Operators Unit).',
  `base_wage_increase_percent` DECIMAL(5,2) COMMENT 'Negotiated percentage increase in base wages effective under this agreement term.',
  `call_out_minimum_hours` DECIMAL(4,2) COMMENT 'Minimum number of hours guaranteed for pay when an employee is called out for emergency or unscheduled work.',
  `call_out_rate_multiplier` DECIMAL(4,2) COMMENT 'Premium pay multiplier applied to call-out hours (e.g., 2.0 for double-time call-out pay).',
  `cola_formula` STRING COMMENT 'Mathematical formula or methodology for calculating cost of living adjustments, including index references (e.g., CPI-U).',
  `cola_provision_flag` BOOLEAN COMMENT 'Indicates whether the agreement includes a cost of living adjustment provision tied to inflation indices.',
  `covered_employee_count` INT COMMENT 'Total number of employees covered under this collective bargaining agreement at the time of execution.',
  `covered_job_classifications` STRING COMMENT 'Comma-separated list or detailed description of all job classifications and titles covered by this agreement (e.g., Lineman, Substation Electrician, Meter Reader, Plant Operator).',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this collective bargaining agreement record was first created in the system.',
  `document_storage_location` STRING COMMENT 'File path, URL, or document management system reference to the full executed agreement document.',
  `dues_checkoff_flag` BOOLEAN COMMENT 'Indicates whether the employer is authorized to deduct union dues from employee paychecks and remit to the union.',
  `effective_date` DATE COMMENT 'Date when the collective bargaining agreement becomes binding and enforceable.',
  `excluded_job_classifications` STRING COMMENT 'Job classifications explicitly excluded from coverage under this agreement (e.g., supervisory, managerial, confidential positions).',
  `execution_date` DATE COMMENT 'Date when authorized representatives of both the utility and union signed the agreement.',
  `expiration_date` DATE COMMENT 'Date when the collective bargaining agreement term ends. Nullable for evergreen agreements.',
  `geographic_scope` STRING COMMENT 'Geographic coverage area of the agreement (e.g., service territory, state, region, facility locations).',
  `grievance_filing_deadline_days` INT COMMENT 'Number of calendar days from the alleged violation within which a grievance must be filed to be considered timely.',
  `grievance_procedure_steps` STRING COMMENT 'Detailed description of the multi-step grievance resolution process defined in the agreement (e.g., Step 1: Supervisor, Step 2: Department Manager, Step 3: HR Director, Step 4: Arbitration).',
  `health_insurance_contribution_percent` DECIMAL(5,2) COMMENT 'Percentage of health insurance premium costs paid by the employer under this agreement.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this collective bargaining agreement record was last updated in the system.',
  `management_rights_clause` STRING COMMENT 'Text of the management rights provision reserving certain operational decisions to the employer.',
  `no_strike_clause_flag` BOOLEAN COMMENT 'Indicates whether the agreement includes a no-strike/no-lockout provision during the contract term.',
  `overtime_rate_multiplier` DECIMAL(4,2) COMMENT 'Multiplier applied to base wage for overtime hours (e.g., 1.5 for time-and-a-half, 2.0 for double-time).',
  `overtime_threshold_hours` DECIMAL(5,2) COMMENT 'Number of hours worked in a period (daily or weekly) after which overtime rates apply.',
  `pension_plan_reference` STRING COMMENT 'Name or identifier of the pension or retirement plan covering employees under this agreement.',
  `probationary_period_days` INT COMMENT 'Number of calendar days a new employee must work before gaining full bargaining unit rights and protections.',
  `ratification_date` DATE COMMENT 'Date when the union membership voted to approve and ratify the collective bargaining agreement.',
  `safety_committee_provision_flag` BOOLEAN COMMENT 'Indicates whether the agreement establishes a joint labor-management safety committee.',
  `seniority_system_description` STRING COMMENT 'Detailed description of how seniority is calculated, applied, and used for bidding, layoffs, recalls, and other employment decisions.',
  `shift_differential_rate` DECIMAL(6,2) COMMENT 'Additional hourly pay rate or percentage premium for non-standard shifts (evening, night, weekend).',
  `storm_duty_obligation_flag` BOOLEAN COMMENT 'Indicates whether the agreement includes mandatory storm duty and emergency response obligations for covered employees.',
  `storm_duty_provisions` STRING COMMENT 'Detailed description of storm duty requirements, including response time, duration, compensation, and meal/lodging provisions.',
  `union_international_affiliation` STRING COMMENT 'International or national parent organization of the union (e.g., AFL-CIO, Change to Win Federation).',
  `union_local_number` STRING COMMENT 'Local chapter or lodge number of the union (e.g., IBEW Local 1245, UWUA Local 246).',
  `union_name` STRING COMMENT 'Full legal name of the labor union or labor organization party to this agreement (e.g., International Brotherhood of Electrical Workers, Utility Workers Union of America).',
  `union_security_clause` STRING COMMENT 'Type of union security arrangement defined in the agreement governing union membership and dues requirements. Valid values: open_shop|agency_shop|union_shop|closed_shop|maintenance_of_membership.',
  `vacation_accrual_formula` STRING COMMENT 'Formula or schedule defining how vacation time accrues based on years of service.',
  `wage_scale_structure` STRING COMMENT 'Description of the wage scale framework defined in the agreement, including pay grades, steps, and progression rules.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_union_agreement` PRIMARY KEY (`union_agreement_id`)
)
USING DELTA
COMMENT 'Master records of collective bargaining agreements (CBAs) between the utility and labor unions (IBEW, UWUA, and others) covering field crews, plant operators, and other bargaining unit employees, plus the full grievance lifecycle under each CBA. CBA records capture union name, local number, agreement effective/expiration dates, covered job classifications, wage scales, overtime rules, call-out provisions, storm duty obligations, grievance procedure definitions, and arbitration terms. Grievance records capture grievance number, filing date, grievant employee, union local, alleged CBA violation, grievance step (Step 1 through arbitration), management response, resolution outcome, settlement terms, and arbitration award details. SSOT for all CBA terms and grievance lifecycle tracking. Drives payroll rules, scheduling constraints, labor cost modeling, and labor relations compliance. | CMM: CIM Agreement (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'UnionAgreement',
  'cmm.cim.class' = 'Agreement',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.union_agreement'
);

-- WorkSchedule  <<CIM WorkTimeSchedule : close>>
CREATE TABLE IF NOT EXISTS `workforce`.`work_schedule` (
  `work_schedule_id` BIGINT NOT NULL COMMENT 'Unique identifier for the work schedule template. Primary key.',
  `union_agreement_id` BIGINT COMMENT 'FK to workforce.union_agreement.union_agreement_id — Work schedules for bargaining unit employees must comply with CBA shift provisions, overtime rules, and call-out requirements. This link enables schedule validation against union agreement terms.',
  `applicable_departments` STRING COMMENT 'Comma-separated list of departments or business units that use this schedule (e.g., \'Generation Operations, Transmission Control\', \'Distribution Field Services\', \'Customer Service\'). Used for organizational reporting.',
  `applicable_job_roles` STRING COMMENT 'Comma-separated list of job roles or classifications that typically use this schedule (e.g., \'Generation Plant Operator, Control Room Operator\', \'Lineman, Field Technician\', \'Administrative Staff\'). Used for workforce planning.',
  `applicable_union_agreement` STRING COMMENT 'Name or identifier of the collective bargaining agreement (CBA) or union contract that governs this schedule (e.g., \'IBEW Local 1245 CBA 2023\', \'Non-Union\'). Null if not union-covered.',
  `break_duration_minutes` INT COMMENT 'Total duration of paid and unpaid breaks during the shift in minutes (e.g., 30 for lunch, 60 for lunch plus rest breaks). Used for net work hour calculations.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this work schedule template record was first created in the system. Used for audit trail and data lineage.',
  `crew_size_minimum` INT COMMENT 'Minimum number of employees required per shift under this schedule to maintain safe operations and regulatory compliance (e.g., 2 for line crew, 1 for control room operator). Null if not applicable.',
  `crew_size_optimal` INT COMMENT 'Optimal number of employees per shift under this schedule for efficient operations and workload distribution. Used for workforce planning and scheduling optimization.',
  `effective_end_date` DATE COMMENT 'Date when this work schedule template ceased or will cease to be effective. Null for currently active schedules with no planned end date.',
  `effective_start_date` DATE COMMENT 'Date when this work schedule template became or will become effective for workforce assignments. Used for schedule versioning and historical tracking.',
  `fatigue_risk_level` STRING COMMENT 'Assessment of fatigue risk associated with this schedule pattern: low (standard day shifts), moderate (rotating or extended shifts), high (frequent night shifts or compressed schedules). Used for safety and compliance monitoring. Valid values: low|moderate|high.',
  `holiday_work_flag` BOOLEAN COMMENT 'Indicates whether employees on this schedule are expected to work on company-recognized holidays (True) or have holidays off (False). Affects holiday premium pay.',
  `hours_per_shift` DECIMAL(5,2) COMMENT 'Standard number of hours in a single shift under this schedule (e.g., 8.00, 10.00, 12.00). Used for time tracking and labor cost allocation.',
  `last_modified_by` STRING COMMENT 'User ID or name of the workforce administrator who last modified this schedule template. Used for audit trail and change tracking.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this work schedule template record was last updated. Used for audit trail and change tracking.',
  `nerc_cip_personnel_flag` BOOLEAN COMMENT 'Indicates whether employees on this schedule are subject to NERC CIP personnel risk assessment and training requirements (True) due to access to critical cyber assets, or not subject (False).',
  `notes` STRING COMMENT 'Free-text field for additional information about the schedule template, including special instructions, exceptions, or historical context. Used for operational guidance and documentation.',
  `off_days_per_cycle` INT COMMENT 'Number of scheduled off days within one complete rotation cycle. Used for work-life balance analysis and crew availability planning.',
  `on_call_duration_hours` DECIMAL(5,2) COMMENT 'Duration of each on-call period in hours (e.g., 24.00 for 24-hour on-call, 168.00 for week-long on-call). Null if on-call rotation is not applicable.',
  `on_call_frequency_days` INT COMMENT 'Number of days between on-call assignments in the rotation (e.g., 7 for weekly on-call, 14 for bi-weekly). Null if on-call rotation is not applicable.',
  `on_call_rotation_flag` BOOLEAN COMMENT 'Indicates whether this schedule includes on-call rotation periods (True) for emergency response, or does not include on-call duty (False).',
  `overtime_calculation_basis` STRING COMMENT 'Time period over which overtime hours are calculated: daily (hours beyond threshold per day), weekly (hours beyond threshold per week), biweekly, or pay_period. Valid values: daily|weekly|biweekly|pay_period.',
  `overtime_eligibility_flag` BOOLEAN COMMENT 'Indicates whether employees on this schedule are eligible for overtime pay under FLSA and union agreements (True) or are exempt (False).',
  `overtime_threshold_hours` DECIMAL(5,2) COMMENT 'Number of hours worked in a period (daily or weekly) after which overtime rates apply (e.g., 8.00 for daily OT, 40.00 for weekly OT). Null if not applicable.',
  `paid_break_minutes` INT COMMENT 'Duration of paid breaks during the shift in minutes. Subset of total break duration. Used for payroll and labor cost calculations.',
  `rotation_cycle_days` INT COMMENT 'Number of days in the complete rotation cycle before the pattern repeats (e.g., 28 for a 4-week rotation, 7 for weekly rotation). Null for fixed schedules.',
  `safety_sensitive_flag` BOOLEAN COMMENT 'Indicates whether this schedule is designated for safety-sensitive positions (True) requiring enhanced OSHA compliance, fatigue management, and drug/alcohol testing, or not safety-sensitive (False).',
  `schedule_code` STRING COMMENT 'Short alphanumeric code uniquely identifying the schedule template in workforce systems (e.g., \'GEN-12HR-ROT\', \'ADMIN-STD\', \'EMERG-OC\').',
  `schedule_name` STRING COMMENT 'Business name of the work schedule template (e.g., \'12-Hour Rotating Shift - Generation\', \'Standard M-F Admin\', \'On-Call Emergency Response\').',
  `schedule_type` STRING COMMENT 'Classification of the schedule pattern: fixed (same shift daily), rotating (shifts change on cycle), on_call (standby/emergency), flexible (variable hours), or compressed (longer shifts, fewer days). Valid values: fixed|rotating|on_call|flexible|compressed.',
  `shift_differential_eligible_flag` BOOLEAN COMMENT 'Indicates whether employees on this schedule are eligible for shift differential pay (True) for evening, night, or weekend shifts, or not eligible (False).',
  `shift_differential_rate_pct` DECIMAL(5,2) COMMENT 'Percentage premium applied to base pay for shift differential (e.g., 10.00 for 10% night shift premium, 15.00 for 15% weekend premium). Null if not applicable.',
  `shift_end_time` TIMESTAMP COMMENT 'Standard end time for the shift in HH:mm format (24-hour clock, e.g., \'15:00\', \'23:00\', \'07:00\'). Represents the conclusion of the work period.',
  `shift_pattern` STRING COMMENT 'Standard shift pattern designation: day (morning/daytime), evening (afternoon/evening), night (overnight), swing (alternating day/night), split (two separate periods), continental (rotating 12-hour), dupont (4-crew rotation), panama (2-2-3 pattern). Reference-value candidates: day|evening|night|swing|split|continental|dupont|panama.',
  `shift_start_time` TIMESTAMP COMMENT 'Standard start time for the shift in HH:mm format (24-hour clock, e.g., \'07:00\', \'15:00\', \'23:00\'). Represents the beginning of the work period.',
  `shifts_per_day` INT COMMENT 'Number of distinct shifts in a 24-hour period under this schedule (e.g., 1 for standard day shift, 3 for 8-hour rotating coverage, 2 for 12-hour rotating).',
  `unpaid_break_minutes` INT COMMENT 'Duration of unpaid breaks (typically meal periods) during the shift in minutes. Subset of total break duration. Deducted from compensable hours.',
  `weekend_work_flag` BOOLEAN COMMENT 'Indicates whether this schedule includes regular weekend work (True) or is Monday-Friday only (False). Used for shift differential and premium pay calculations.',
  `work_days_per_cycle` INT COMMENT 'Number of actual work days within one complete rotation cycle. Used to calculate average work hours and staffing levels.',
  `work_location_type` STRING COMMENT 'Primary work location type for employees on this schedule: field (outdoor utility infrastructure), plant (generation facility), control_room (SCADA/EMS/DMS operations center), office (administrative), remote (home-based), hybrid (combination). Valid values: field|plant|control_room|office|remote|hybrid.',
  `work_schedule_status` STRING COMMENT 'Current lifecycle status of the work schedule template: active (in use), inactive (temporarily suspended), draft (under development), deprecated (phased out but retained for historical reference). Valid values: active|inactive|draft|deprecated.',
  `created_by` STRING COMMENT 'User ID or name of the workforce administrator who created this schedule template. Used for audit trail and accountability.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_work_schedule` PRIMARY KEY (`work_schedule_id`)
)
USING DELTA
COMMENT 'Master schedule templates defining shift patterns for utility workforce roles — including rotating 12-hour shifts for generation plant operators, 8-hour day/evening/night shifts for distribution control room dispatchers, on-call rotation schedules for emergency response crews, and standard M-F schedules for administrative staff. Captures schedule name, shift type, hours per shift, rotation cycle, applicable union agreement, and overtime eligibility rules. | CMM: CIM WorkTimeSchedule (close), IEC61968::Work.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'WorkSchedule',
  'cmm.cim.class' = 'WorkTimeSchedule',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Work',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.work_schedule'
);

-- ShiftAssignment  <<CIM Assignment : close>>
CREATE TABLE IF NOT EXISTS `workforce`.`shift_assignment` (
  `shift_assignment_id` BIGINT NOT NULL COMMENT 'Unique identifier for the shift assignment record. Primary key for the shift assignment entity.',
  `alt5_shift_last_modified_by_user_employee_id` BIGINT COMMENT 'Identifier of the system user who last modified this shift assignment record. Audit field for accountability and change tracking.',
  `cost_center_id` BIGINT COMMENT 'The cost center to which labor costs for this shift assignment are allocated. Used for financial reporting and departmental budgeting.',
  `crew_id` BIGINT COMMENT 'Identifier of the crew or team to which the employee is assigned for this shift. Used for coordinated field work, outage response, and maintenance activities. Nullable for individual assignments.',
  `primary_shift_swap_original_employee_id` BIGINT COMMENT 'Identifier of the original employee who was initially scheduled for this shift before a swap occurred. Nullable if no swap. Used for shift trade tracking and union compliance.',
  `primary_work_schedule_id` BIGINT COMMENT 'FK to workforce.work_schedule.work_schedule_id — Shift assignments are instances of work schedule templates. This link enables schedule adherence tracking and overtime calculation based on the applicable schedule pattern.',
  `quaternary_shift_scheduled_by_user_employee_id` BIGINT COMMENT 'Identifier of the system user or scheduler who created this shift assignment. Used for audit trail and accountability.',
  `quinary_shift_cancelled_by_user_employee_id` BIGINT COMMENT 'Identifier of the system user who cancelled this shift assignment. Nullable for non-cancelled assignments. Used for audit trail.',
  `shift_employee_id` BIGINT COMMENT 'FK to workforce.employee.employee_id — Each shift assignment is for a specific employee. Without this FK, daily staffing rosters cannot be generated and control room minimum staffing compliance cannot be verified.',
  `shift_template_id` BIGINT COMMENT 'Identifier of the work schedule template that defines the standard shift pattern (e.g., 8-hour day shift, 12-hour night shift, rotating shift). References the shift template master.',
  `shift_work_schedule_id` BIGINT COMMENT 'Foreign key linking to workforce.work_schedule. Business justification: shift_assignment currently has shift_template_id (BIGINT) which should reference work_schedule (the master schedule template table). The work_schedule table defines shift patterns, rotation cycles, ho',
  `tertiary_shift_supervisor_employee_id` BIGINT COMMENT 'Identifier of the supervisor or shift lead responsible for overseeing this employee during the assigned shift. References the employee master record.',
  `work_order_id` BIGINT COMMENT 'Identifier of the work order or maintenance task that this shift assignment supports. Nullable for general operational shifts. Enables labor cost allocation to specific asset maintenance activities.',
  `actual_clock_in_timestamp` TIMESTAMP COMMENT 'The actual date and time when the employee clocked in or reported for duty at the start of the shift. Used for time and attendance tracking and variance analysis against scheduled start time.',
  `actual_clock_out_timestamp` TIMESTAMP COMMENT 'The actual date and time when the employee clocked out or completed duty at the end of the shift. Used for time and attendance tracking and variance analysis against scheduled end time.',
  `actual_hours_worked` DECIMAL(5,2) COMMENT 'The actual number of hours the employee worked during this shift, calculated from clock-in and clock-out timestamps. Used for payroll processing and labor cost allocation.',
  `assignment_date` DATE COMMENT 'The calendar date for which this shift assignment is scheduled. Represents the business day of the shift, not necessarily the clock start time (night shifts may start on prior calendar day).',
  `assignment_status` STRING COMMENT 'Current lifecycle status of the shift assignment. Tracks progression from initial scheduling through completion or cancellation. Valid values: scheduled|confirmed|in_progress|completed|cancelled|no_show.',
  `assignment_type` STRING COMMENT 'Classification of the shift assignment indicating whether it is a regular scheduled shift, overtime, emergency callout, standby duty, or a shift swap/coverage arrangement. Critical for labor cost allocation and union agreement compliance. Reference-value candidates: regular|overtime|emergency_callout|standby|on_call|shift_swap|coverage.',
  `break_duration_minutes` INT COMMENT 'The total duration of unpaid break time during the shift, in minutes. Used to calculate net working hours and ensure compliance with labor regulations.',
  `callout_timestamp` TIMESTAMP COMMENT 'The date and time when the employee was called out for emergency duty. Nullable for non-emergency assignments. Used to calculate response time and premium pay eligibility.',
  `cancellation_reason` STRING COMMENT 'Free-text explanation of why the shift assignment was cancelled, if applicable. Nullable for non-cancelled assignments. Used for workforce planning analysis.',
  `cancelled_timestamp` TIMESTAMP COMMENT 'The date and time when this shift assignment was cancelled. Nullable for non-cancelled assignments. Used for audit trail and schedule change tracking.',
  `confirmed_by_employee_timestamp` TIMESTAMP COMMENT 'The date and time when the employee acknowledged and confirmed acceptance of this shift assignment. Nullable if confirmation is not required or not yet received.',
  `created_timestamp` TIMESTAMP COMMENT 'The date and time when this shift assignment record was first created in the system. Audit field for data lineage and compliance reporting.',
  `is_emergency_callout` BOOLEAN COMMENT 'Indicates whether this shift assignment was triggered by an emergency callout (e.g., storm response, unplanned outage, critical equipment failure). Emergency callouts typically carry premium pay rates.',
  `is_overtime_eligible` BOOLEAN COMMENT 'Indicates whether this shift assignment qualifies for overtime compensation based on hours worked, employee classification, and union agreement rules.',
  `labor_cost_amount` DECIMAL(12,2) COMMENT 'The total labor cost for this shift assignment, including base pay, overtime premium, and any shift differentials. Used for work order costing and financial analysis.',
  `labor_cost_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the labor cost amount (e.g., USD, CAD, EUR). Pattern: ^[A-Z]{3}$.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this shift assignment record was last updated. Audit field for change tracking and data quality monitoring.',
  `nerc_cip_required` BOOLEAN COMMENT 'Indicates whether this shift assignment requires NERC CIP personnel risk assessment and background check compliance due to access to critical cyber assets or bulk electric system facilities.',
  `notes` STRING COMMENT 'Free-text notes or comments about this shift assignment, such as special instructions, equipment requirements, or schedule deviations. Used for operational communication.',
  `response_timestamp` TIMESTAMP COMMENT 'The date and time when the employee responded to the emergency callout and reported for duty. Used to measure callout response time compliance.',
  `safety_certification_verified` BOOLEAN COMMENT 'Indicates whether the employee\'s required safety certifications (e.g., OSHA training, arc flash, confined space, high voltage) have been verified as current and valid for this shift assignment.',
  `scheduled_timestamp` TIMESTAMP COMMENT 'The date and time when this shift assignment was created in the scheduling system. Audit field for tracking when the assignment was made.',
  `shift_duration_hours` DECIMAL(5,2) COMMENT 'The total scheduled duration of the shift in hours, including any built-in break periods. Supports labor cost allocation and OSHA compliance for maximum shift length.',
  `shift_end_timestamp` TIMESTAMP COMMENT 'The actual date and time when the employee\'s shift is scheduled to end, including time zone. Used to calculate shift duration and ensure minimum staffing coverage.',
  `shift_role_code` STRING COMMENT 'Code representing the functional role the employee performs during this shift (e.g., LINEMAN, OPERATOR, DISPATCHER, ENGINEER, METER_READER, SUPERVISOR). Used for skill-based scheduling and NERC CIP personnel risk assessment compliance. Pattern: ^[A-Z0-9_]{2,20}$.',
  `shift_role_description` STRING COMMENT 'Human-readable description of the shift role, providing context for the functional responsibilities during this assignment.',
  `shift_start_timestamp` TIMESTAMP COMMENT 'The actual date and time when the employee\'s shift is scheduled to begin, including time zone. Used for precise crew scheduling and control room staffing compliance.',
  `shift_swap_approval_timestamp` TIMESTAMP COMMENT 'The date and time when the shift swap was approved by the supervisor or scheduling system. Nullable if no swap occurred.',
  `union_code` STRING COMMENT 'Code representing the labor union to which the employee belongs, if applicable. Used to ensure shift assignment complies with union collective bargaining agreement rules (e.g., seniority, overtime rotation, shift bidding). Pattern: ^[A-Z0-9]{2,10}$.',
  `work_location_code` BIGINT COMMENT 'Identifier of the physical work location where the employee is assigned for this shift (e.g., power plant, substation, service center, control room, field territory). References the location master.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_shift_assignment` PRIMARY KEY (`shift_assignment_id`)
)
USING DELTA
COMMENT 'Transactional records of individual employee shift assignments against work schedule templates, capturing assigned shift date, shift start/end times, assigned location (plant, substation, service center, control room), shift role, and any schedule deviations (swap, coverage, emergency callout). Supports daily crew scheduling, control room staffing compliance, and generation plant minimum staffing requirements. | CMM: CIM Assignment (close), IEC61968::InfWork.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ShiftAssignment',
  'cmm.cim.class' = 'Assignment',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfWork',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-6',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.shift_assignment'
);

-- TimeEntry  <<CIM ErpTimeEntry : exact>>
CREATE TABLE IF NOT EXISTS `workforce`.`time_entry` (
  `time_entry_id` BIGINT NOT NULL COMMENT 'Unique identifier for the time entry record. Primary key for the time entry data product.',
  `contractor_worker_id` BIGINT COMMENT 'FK to workforce.contractor_worker.contractor_worker_id — Time entries also capture contractor hours. Required for contractor labor cost allocation and invoice reconciliation.',
  `cost_center_id` BIGINT COMMENT 'The organizational cost center to which this labor time is charged. Used for overhead and indirect labor cost allocation.',
  `crew_id` BIGINT COMMENT 'Identifier for the field crew or work team to which the employee was assigned during this time entry. Used for crew-based scheduling and dispatch.',
  `employee_id` BIGINT COMMENT 'FK to workforce.employee.employee_id — Time entries must reference the employee who worked the hours. Core FK for payroll, labor cost allocation, and overtime compliance.',
  `event_id` BIGINT COMMENT 'Identifier for the grid outage or storm restoration event to which this labor time is allocated. Used for outage cost tracking and SAIDI/SAIFI reporting.',
  `payroll_period_id` BIGINT COMMENT 'Identifier for the payroll period to which this time entry belongs. Links to payroll processing cycle.',
  `payroll_run_id` BIGINT COMMENT 'Identifier for the specific payroll run that processed this time entry. Used for payroll reconciliation and audit.',
  `primary_time_employee_id` BIGINT COMMENT 'Unique identifier for the employee or contractor worker who recorded this time entry. Links to workforce employee registry.',
  `project_id` BIGINT COMMENT 'Identifier for the capital construction project or program to which this labor time is allocated. Used for capital project cost tracking.',
  `tertiary_time_modified_by_user_employee_id` BIGINT COMMENT 'User identifier of the person who last modified this time entry record. Used for audit trail and accountability.',
  `time_employee_id` BIGINT COMMENT 'FK to workforce.employee.employee_id — Every time entry belongs to an employee. This is the fundamental payroll and cost allocation relationship. Without it, labor costs cannot be allocated and paychecks cannot be generated.',
  `work_order_id` BIGINT COMMENT 'Identifier for the asset maintenance or construction work order to which this labor time is allocated. Used for CAPEX/OPEX cost allocation.',
  `activity_description` STRING COMMENT 'Detailed narrative description of the work activity performed during this time entry. Provides context for labor allocation.',
  `activity_type_code` STRING COMMENT 'Classification code for the type of work activity performed (e.g., installation, repair, inspection, patrol, engineering, administrative).',
  `approval_status` STRING COMMENT 'Current approval workflow status of the time entry. Tracks progression from draft through supervisor approval to payroll posting. Valid values: draft|submitted|approved|rejected|posted.',
  `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the time entry was approved by the supervisor. Used for audit trail and compliance reporting.',
  `capitalization_indicator` BOOLEAN COMMENT 'Flag indicating whether this labor cost is capitalized (CAPEX) or expensed (OPEX). True for capital projects, false for O&M work.',
  `comments` STRING COMMENT 'Free-text comments or notes entered by the employee or supervisor regarding this time entry. Provides additional context for time allocation.',
  `contractor_flag` BOOLEAN COMMENT 'Indicates whether this time entry is for a contractor worker rather than a direct employee. Used for contractor labor cost tracking.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this time entry record was first created in the system. Used for audit trail and data lineage.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for labor cost amount (e.g., USD, CAD, EUR). Pattern: ^[A-Z]{3}$.',
  `dot_regulated_flag` BOOLEAN COMMENT 'Indicates whether this time entry is subject to DOT hours-of-service regulations for commercial driver license (CDL) positions. Used for compliance tracking.',
  `expense_type` STRING COMMENT 'Classification of the expense type for financial reporting. Distinguishes between capital expenditure, operational expenditure, overhead, and indirect costs. Valid values: capex|opex|overhead|indirect.',
  `fmla_qualifying_flag` BOOLEAN COMMENT 'Indicates whether this leave time entry qualifies under FMLA regulations. Used for FMLA leave tracking and compliance reporting.',
  `hours_worked` DECIMAL(8,2) COMMENT 'Total number of hours worked or leave hours taken for this time entry. Supports fractional hours (e.g., 7.5 hours).',
  `job_classification_code` STRING COMMENT 'Code identifying the job classification or craft for this time entry (e.g., lineman, electrician, engineer, dispatcher). Used for labor rate determination.',
  `labor_cost_amount` DECIMAL(15,2) COMMENT 'Total labor cost for this time entry, calculated as hours worked multiplied by labor rate. Includes burden and overhead allocation.',
  `labor_rate` DECIMAL(12,2) COMMENT 'The hourly labor rate applied to this time entry, including any overtime or premium multipliers. Used for labor cost calculation.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this time entry record was last updated. Used for audit trail and change tracking.',
  `leave_balance_impact` DECIMAL(8,2) COMMENT 'The number of leave hours deducted from or accrued to the employee\'s leave balance as a result of this time entry. Negative for leave taken, positive for accrual.',
  `location_code` STRING COMMENT 'Code identifying the work location or facility where the work was performed. Used for geographic labor cost analysis.',
  `nerc_cip_work_flag` BOOLEAN COMMENT 'Indicates whether this time entry involves work on NERC CIP-designated critical cyber assets or bulk electric system facilities. Used for personnel risk assessment compliance.',
  `osha_recordable_flag` BOOLEAN COMMENT 'Indicates whether this time entry is associated with an OSHA recordable injury or illness event. Used for safety compliance reporting.',
  `overtime_eligible_flag` BOOLEAN COMMENT 'Indicates whether the employee is eligible for overtime pay under FLSA or union contract rules. True for non-exempt employees, false for exempt.',
  `pay_type_code` STRING COMMENT 'Classification of the pay type for this time entry. Determines wage rate multiplier and leave balance impact. Supports union overtime compliance and DOT hours-of-service tracking. Reference-value candidates: regular|overtime|double_time|on_call|storm_duty|holiday|sick_leave|vacation|fmla|bereavement|jury_duty|training|travel.',
  `shift_code` STRING COMMENT 'Code identifying the work shift during which this time was worked (e.g., day shift, night shift, rotating shift). Used for shift differential pay calculation.',
  `source_system_code` STRING COMMENT 'Code identifying the source system from which this time entry was captured (e.g., SAP Time Management, mobile time entry app, badge reader).',
  `time_entry_number` STRING COMMENT 'Human-readable business identifier for the time entry record, typically generated by the time and attendance system.',
  `time_for_employee` BIGINT COMMENT 'FK to workforce.employee.employee_id — Time entries record hours worked by an employee. This FK is essential for payroll processing, labor cost allocation, and overtime compliance verification.',
  `travel_time_flag` BOOLEAN COMMENT 'Indicates whether this time entry represents travel time rather than direct work time. Used for travel time pay policy compliance.',
  `union_code` STRING COMMENT 'Code identifying the labor union to which the employee belongs. Used for union contract compliance and overtime rule enforcement.',
  `wbs_element` STRING COMMENT 'The specific WBS element within a project hierarchy to which this labor time is allocated. Enables detailed project cost tracking.',
  `work_date` DATE COMMENT 'The calendar date on which the work was performed. Principal business event timestamp for labor time tracking.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_time_entry` PRIMARY KEY (`time_entry_id`)
)
USING DELTA
COMMENT 'SSOT for employee and contractor time, attendance, and labor cost allocation records. Captures actual hours worked per day including regular, overtime, double-time, on-call, storm duty, leave, and travel time. Records work date, employee or contractor worker, cost object (work order, cost center, project, WBS element), activity type, pay type, labor rate, total cost, capitalization vs O&M expense classification, approval status, and payroll period. Supports labor cost allocation to asset maintenance work orders, capital construction projects, outage restoration events, demand response program delivery, and overhead cost centers. Feeds SAP S/4HANA plant maintenance and project accounting for CAPEX/OPEX reporting. Also supports FMLA leave tracking, leave balance management, DOT hours-of-service compliance for CDL positions, and union overtime compliance verification. | CMM: CIM ErpTimeEntry (exact), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'TimeEntry',
  'cmm.cim.class' = 'ErpTimeEntry',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.time_entry'
);

-- LeaveRequest  <<CIM Request : extension>>
CREATE TABLE IF NOT EXISTS `workforce`.`leave_request` (
  `leave_request_id` BIGINT NOT NULL COMMENT 'Unique identifier for the leave request record. Primary key.',
  `leave_employee_id` BIGINT COMMENT 'FK to workforce.employee.employee_id — Leave requests are per-employee. FK required for leave balance management, FMLA tracking, and staffing gap analysis.',
  `primary_leave_employee_id` BIGINT COMMENT 'Identifier of the employee submitting the leave request. Links to the employee master record in the workforce domain.',
  `tertiary_leave_coverage_employee_id` BIGINT COMMENT 'Identifier of the employee assigned to cover the absent employee duties during the leave period. Links to employee master record.',
  `work_schedule_id` BIGINT COMMENT 'Identifier of the shift schedule affected by this leave request. Used to flag coverage gaps for shift-based operational roles.',
  `approval_comments` STRING COMMENT 'Free-text comments entered by the approving supervisor explaining the approval decision, conditions, or denial reason.',
  `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the leave request was approved or denied by the supervisor.',
  `approved_duration_hours` DECIMAL(8,2) COMMENT 'Total number of work hours approved for absence, calculated from approved start and end dates. Used to decrement leave balance.',
  `approved_end_date` DATE COMMENT 'The last calendar date of absence as approved by the supervisor. May differ from requested end date if partial approval granted.',
  `approved_start_date` DATE COMMENT 'The first calendar date of absence as approved by the supervisor. May differ from requested start date if partial approval granted.',
  `coverage_plan_required` BOOLEAN COMMENT 'Flag indicating whether a formal coverage plan must be documented before this leave can be approved, typically for critical roles or extended absences.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when the leave request record was first created in the system, typically when the employee began drafting the request.',
  `critical_role_flag` BOOLEAN COMMENT 'Indicates whether the employee requesting leave holds a critical operational role (control room operator, plant operator, dispatcher, NERC CIP personnel) requiring special staffing considerations and coverage planning.',
  `denial_reason_code` STRING COMMENT 'Standardized code indicating why the leave request was denied: insufficient_staffing (minimum crew requirements not met), insufficient_balance (employee lacks accrued leave), business_need (critical operational period), policy_violation (does not meet policy requirements), documentation_missing (required medical certification not provided), other (see comments). Valid values: insufficient_staffing|insufficient_balance|business_need|policy_violation|documentation_missing|other.',
  `fmla_case_number` STRING COMMENT 'Unique case identifier assigned to track FMLA-protected leave for compliance reporting. Populated only when is_fmla_eligible is true.',
  `impacts_minimum_staffing` BOOLEAN COMMENT 'Flag indicating whether approving this leave would cause staffing levels to fall below the minimum required for safe operations in critical roles such as control room operators, plant operators, or NERC CIP-designated positions.',
  `intermittent_leave_flag` BOOLEAN COMMENT 'Indicates whether this is intermittent leave (true) taken in separate blocks of time rather than one continuous period (false). Common for FMLA medical treatment schedules.',
  `is_fmla_eligible` BOOLEAN COMMENT 'Flag indicating whether this leave qualifies for FMLA protection (true) or not (false). FMLA provides job-protected unpaid leave for qualifying medical and family reasons.',
  `is_paid_leave` BOOLEAN COMMENT 'Flag indicating whether this leave is paid (true) or unpaid (false). Determines payroll processing and leave balance consumption.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the leave request record was last updated, capturing any changes to dates, status, or approval information.',
  `leave_balance_consumed_hours` DECIMAL(8,2) COMMENT 'Number of hours deducted from the employee leave balance accrual for this approved absence. May differ from approved duration if unpaid leave or partial pay applies.',
  `leave_subtype` STRING COMMENT 'Detailed classification within the leave type, such as FMLA continuous vs intermittent, sick personal vs sick family care, or military active duty vs reserve training.',
  `leave_type` STRING COMMENT 'Category of leave being requested: vacation (paid time off), sick (illness or medical appointments), FMLA (Family and Medical Leave Act protected leave), military (active duty or reserve training), bereavement (death of family member), personal (union-negotiated personal days). Valid values: vacation|sick|fmla|military|bereavement|personal.',
  `medical_certification_received_date` DATE COMMENT 'Date when required medical certification documentation was received by HR, if applicable.',
  `medical_certification_required` BOOLEAN COMMENT 'Flag indicating whether medical certification documentation is required to support this leave request, typically for FMLA or extended sick leave.',
  `osha_recordable_flag` BOOLEAN COMMENT 'Indicates whether this leave is related to an OSHA recordable workplace injury or illness requiring compliance reporting.',
  `payroll_integration_status` STRING COMMENT 'Status of integration with payroll system to process leave pay or unpaid time: pending (awaiting transmission), sent (transmitted to payroll), confirmed (acknowledged by payroll), error (integration failure requiring manual intervention). Valid values: pending|sent|confirmed|error.',
  `reason_description` STRING COMMENT 'Free-text explanation provided by the employee describing the reason for the leave request. May contain sensitive medical or personal information.',
  `request_number` STRING COMMENT 'Human-readable business identifier for the leave request, typically system-generated in format LR-YYYYNNNN. Pattern: ^LR-[0-9]{8}$.',
  `request_status` STRING COMMENT 'Current lifecycle state of the leave request: draft (employee is composing), submitted (sent to supervisor), pending_approval (awaiting manager decision), approved (authorized for absence), denied (rejected by supervisor), cancelled (system-cancelled due to business rule), withdrawn (employee retracted before approval). Reference-value candidates: draft|submitted|pending_approval|approved|denied|cancelled|withdrawn.',
  `requested_duration_hours` DECIMAL(8,2) COMMENT 'Total number of work hours the employee is requesting to be absent, calculated from requested start and end dates based on employee work schedule.',
  `requested_end_date` DATE COMMENT 'The last calendar date the employee intends to be absent, as originally requested. Inclusive end date.',
  `requested_start_date` DATE COMMENT 'The first calendar date the employee intends to be absent, as originally requested.',
  `return_to_work_certification_flag` BOOLEAN COMMENT 'Indicates whether a return-to-work medical clearance is required before the employee can resume duties, typically for extended medical leave or OSHA recordable injuries.',
  `return_to_work_date` DATE COMMENT 'Actual date the employee returned to work following the leave period. Used for attendance tracking and leave reconciliation.',
  `source_system` STRING COMMENT 'Name of the operational system from which this leave request record originated, typically SAP S/4HANA HCM or a self-service portal.',
  `source_system_code` STRING COMMENT 'Unique identifier of this leave request in the source operational system, used for data lineage and reconciliation.',
  `submitted_timestamp` TIMESTAMP COMMENT 'Date and time when the employee submitted the leave request for supervisor approval.',
  `union_code` STRING COMMENT 'Code identifying the labor union to which the employee belongs, if applicable. Union membership may affect leave entitlements, approval rules, and personal day allocations per collective bargaining agreement.',
  `work_order_impact_flag` BOOLEAN COMMENT 'Indicates whether this leave affects scheduled work orders or maintenance activities assigned to the employee, requiring crew reassignment.',
  `workers_comp_claim_number` STRING COMMENT 'Workers compensation insurance claim number if this leave is related to a workplace injury or occupational illness.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_leave_request` PRIMARY KEY (`leave_request_id`)
)
USING DELTA
COMMENT 'Employee leave requests and approved absences including vacation, sick leave, FMLA, military leave, bereavement, and union-negotiated personal days. Captures leave type, requested start/end dates, approved dates, approving supervisor, leave balance consumed, FMLA eligibility flag, and impact on minimum staffing levels. Integrates with shift scheduling to flag coverage gaps for critical operational roles (control room operators, plant operators). | CMM: CIM Request (extension), IEC61968::InfWork.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'LeaveRequest',
  'cmm.cim.class' = 'Request',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::InfWork',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-6',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.leave_request'
);

-- ContractorWorker  <<CIM Person : close>>
CREATE TABLE IF NOT EXISTS `workforce`.`contractor_worker` (
  `contractor_worker_id` BIGINT NOT NULL COMMENT 'Unique identifier for the contractor worker record. Primary key for the contractor_worker product.',
  `contractor_company_id` BIGINT COMMENT 'Reference to the contractor company that employs or dispatches this worker. Links to the contractor company master record.',
  `contractor_crew_id` BIGINT COMMENT 'Foreign key linking to workforce.crew. Business justification: Contractor workers assigned to utility crews for storm response and mutual aid. Linking enables mixed crew composition tracking, labor cost allocation, and contractor safety oversight.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Contractor labor costs must be allocated to cost centers for financial tracking, budget management, and rate case support. New FK needed as no existing cost_center reference exists.',
  `nerc_cip_access_id` BIGINT COMMENT 'FK to workforce.nerc_cip_access.nerc_cip_access_id — Contractors working at CIP facilities require NERC CIP access authorization. FK needed for CIP-004 compliance — contractors are subject to same PRA and access control requirements.',
  `primary_crew_id` BIGINT COMMENT 'FK to workforce.crew.crew_id — Contractor workers are often assigned to crews for storm restoration and capital construction. This link enables mixed crew composition tracking (utility employees + contractors) which is critical for',
  `supervisor_employee_id` BIGINT COMMENT 'Employee ID of the utility employee who supervises or coordinates the work of this contractor worker. Links to the employee master record.',
  `arc_flash_training_date` DATE COMMENT 'Date on which the contractor worker completed arc flash hazard awareness and PPE training required for work on energized electrical equipment.',
  `background_check_completion_date` DATE COMMENT 'Date on which the background check was completed for this contractor worker. Null if not required or not yet completed.',
  `background_check_status` STRING COMMENT 'Status of criminal and employment background check for the contractor worker (cleared, pending, failed, not_required, expired). Valid values: cleared|pending|failed|not_required|expired.',
  `cdl_expiration_date` DATE COMMENT 'Expiration date of the contractor worker\'s Commercial Driver License. Null if CDL not held.',
  `cdl_license_number` STRING COMMENT 'Commercial Driver License number for contractor workers authorized to operate utility vehicles and heavy equipment. Null if CDL not required for role.',
  `confined_space_certification_date` DATE COMMENT 'Date on which the contractor worker completed confined space entry training and certification required for work in vaults, manholes, and other permit-required confined spaces.',
  `contract_reference_number` STRING COMMENT 'Reference number of the master service agreement or purchase order under which this contractor worker is engaged by the utility.',
  `cpr_first_aid_certification_date` DATE COMMENT 'Date on which the contractor worker completed CPR and first aid certification. Required for field crew members working in remote locations.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this contractor worker record was first created in the system.',
  `daily_rate_usd` DECIMAL(12,2) COMMENT 'Daily billing rate in US Dollars for the contractor worker if compensated on a per-diem basis. Null if hourly rate applies.',
  `drug_test_date` DATE COMMENT 'Date on which the most recent drug and alcohol test was administered to the contractor worker.',
  `drug_test_status` STRING COMMENT 'Status of pre-employment or random drug and alcohol screening for the contractor worker (passed, failed, pending, not_required, expired). Valid values: passed|failed|pending|not_required|expired.',
  `emergency_contact_name` STRING COMMENT 'Full name of the emergency contact person for the contractor worker in case of workplace injury or incident.',
  `emergency_contact_phone` STRING COMMENT 'Phone number of the emergency contact person for the contractor worker.',
  `emergency_contact_relationship` STRING COMMENT 'Relationship of the emergency contact person to the contractor worker (e.g., spouse, parent, sibling, friend).',
  `engagement_end_date` DATE COMMENT 'Planned or actual date on which the contractor worker engagement with the utility ends or ended. Null for open-ended engagements.',
  `engagement_start_date` DATE COMMENT 'Date on which the contractor worker began active engagement with the utility under the current contract.',
  `hourly_rate_usd` DECIMAL(10,2) COMMENT 'Hourly billing rate in US Dollars for the contractor worker if compensated on an hourly basis. Null if daily rate applies.',
  `national_id_number` STRING COMMENT 'Government-issued national identification number (e.g., Social Security Number in USA) used for background check and tax reporting purposes.',
  `nerc_cip_pra_completion_date` DATE COMMENT 'Date on which the NERC CIP Personnel Risk Assessment was completed for this contractor worker. Null if not required or not yet completed.',
  `nerc_cip_pra_status` STRING COMMENT 'Status of NERC CIP-004 Personnel Risk Assessment for contractor workers requiring unescorted physical or electronic access to BES Cyber Systems or Physical Security Perimeters (completed, pending, not_required, expired, failed). Valid values: completed|pending|not_required|expired|failed.',
  `ppe_certification_status` STRING COMMENT 'Status of required Personal Protective Equipment certification for the contractor worker, including arc flash PPE, fall protection, and respiratory protection (current, expired, pending, not_required). Valid values: current|expired|pending|not_required.',
  `safety_orientation_date` DATE COMMENT 'Date on which the contractor worker completed mandatory utility safety orientation training covering site-specific hazards, emergency procedures, and OSHA compliance requirements.',
  `site_access_status` STRING COMMENT 'Current authorization status for the contractor worker to access utility facilities and work sites (authorized, pending, suspended, revoked, expired). Valid values: authorized|pending|suspended|revoked|expired.',
  `source_system` STRING COMMENT 'Name of the operational system of record from which this contractor worker record originated (e.g., SAP S/4HANA HCM, Ventyx Asset Suite Work Management, contractor management portal).',
  `termination_reason` STRING COMMENT 'Reason for termination or suspension of the contractor worker engagement (e.g., contract completion, safety violation, performance issue, voluntary departure). Null if status is active.',
  `trade_classification` STRING COMMENT 'Primary skilled trade or craft classification of the contractor worker (e.g., lineman, electrician, welder, heavy equipment operator, relay technician, turbine technician, instrumentation technician). Reference-value candidates: lineman|electrician|welder|heavy_equipment_operator|relay_technician|turbine_technician|instrumentation_technician|substation_technician|meter_technician|civil_engineer|structural_engineer|environmental_specialist|safety_coordinator. Valid values: lineman|electrician|welder|heavy_equipment_operator|relay_technician|turbine_technician.',
  `union_affiliation` STRING COMMENT 'Labor union or trade association to which the contractor worker belongs (e.g., IBEW Local 1245, Operating Engineers Local 3). Null if non-union.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this contractor worker record was last modified in the system.',
  `work_location_code` STRING COMMENT 'Primary utility facility or service territory code where the contractor worker is assigned (e.g., generating station, substation, district office, or regional operations center).',
  `worker_badge_number` STRING COMMENT 'Utility-issued badge or access card number assigned to the contractor worker for physical and logical access control to utility facilities and systems.',
  `worker_email` STRING COMMENT 'Primary email address for the contractor worker used for safety notifications, training assignments, and site access communications. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `worker_first_name` STRING COMMENT 'First (given) name of the contractor worker as recorded in identity verification documents.',
  `worker_last_name` STRING COMMENT 'Last (family) name of the contractor worker as recorded in identity verification documents.',
  `worker_middle_name` STRING COMMENT 'Middle name or initial of the contractor worker, if provided.',
  `worker_phone` STRING COMMENT 'Primary contact phone number for the contractor worker for emergency contact and crew dispatch coordination.',
  `worker_status` STRING COMMENT 'Current lifecycle status of the contractor worker engagement with the utility (active, inactive, suspended, terminated). Valid values: active|inactive|suspended|terminated.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_contractor_worker` PRIMARY KEY (`contractor_worker_id`)
)
USING DELTA
COMMENT 'Master records for contractor and contingent workforce personnel engaged by the utility for capital construction projects, storm restoration mutual aid, specialized maintenance (e.g., turbine overhauls, relay testing), and supplemental operations staffing. Captures contractor company name, worker identity, trade classification, contract reference, daily rate or hourly rate, site access authorization status, NERC CIP PRA status for CIP-applicable contractors, background check completion, safety orientation date, required PPE certifications, and active engagement period. Distinct from employees — contractor workers are not on utility payroll but are subject to the same safety, access, and certification requirements on utility property. | CMM: CIM Person (close), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ContractorWorker',
  'cmm.cim.class' = 'Person',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.contractor_worker'
);

-- LaborCostAllocation  <<CIM LaborItem : close>>
CREATE TABLE IF NOT EXISTS `workforce`.`labor_cost_allocation` (
  `labor_cost_allocation_id` BIGINT NOT NULL COMMENT 'Unique identifier for the labor cost allocation record. Primary key.',
  `capital_project_id` BIGINT COMMENT 'Identifier of the capital construction project to which labor cost is allocated. Null if allocated to a different cost object type.',
  `contractor_worker_id` BIGINT COMMENT 'Identifier of the contractor whose labor cost is being allocated. Null if the allocation is for an employee. References the contractor master.',
  `cost_center_id` BIGINT COMMENT 'Code of the overhead cost center to which labor cost is allocated. Null if allocated to a specific work order, project, or event.',
  `crew_id` BIGINT COMMENT 'Identifier of the field crew or work team to which the employee or contractor was assigned during this allocation period.',
  `employee_id` BIGINT COMMENT 'Identifier of the employee whose labor cost is being allocated. References the workforce employee master.',
  `event_id` BIGINT COMMENT 'Identifier of the outage restoration event to which labor cost is allocated. Null if allocated to a different cost object type.',
  `work_order_id` BIGINT COMMENT 'Identifier of the work order to which labor cost is allocated. Null if allocated to a different cost object type.',
  `activity_type` STRING COMMENT 'Type of work activity performed during the allocated labor hours. Used for labor productivity analysis and cost benchmarking. Reference-value candidates: maintenance|construction|inspection|emergency_restoration|meter_reading|vegetation_management|engineering|administrative|training|safety_compliance.',
  `allocation_date` DATE COMMENT 'The date on which the labor cost allocation is recorded. Represents the business event date for the allocation.',
  `allocation_status` STRING COMMENT 'Current status of the labor cost allocation record in the workflow. Approved allocations are posted to SAP S/4HANA financial accounting. Valid values: draft|approved|posted|reversed|disputed.',
  `approval_date` DATE COMMENT 'Date on which the labor cost allocation was approved by the supervisor or project manager. Null if not yet approved.',
  `approved_by` STRING COMMENT 'User ID or name of the supervisor or manager who approved this labor cost allocation. Null if not yet approved.',
  `base_wage_rate` DECIMAL(12,2) COMMENT 'The base hourly wage rate for the employee or contractor, excluding benefits and burden. Expressed in USD per hour.',
  `burden_rate` DECIMAL(12,2) COMMENT 'The hourly burden rate applied to this allocation, covering benefits, payroll taxes, insurance, and overhead. Expressed in USD per hour.',
  `business_unit` STRING COMMENT 'Business unit or operating division responsible for this labor cost allocation (e.g., Transmission, Distribution, Generation).',
  `cost_element` STRING COMMENT 'SAP Controlling cost element code representing the type of labor cost (e.g., direct labor, indirect labor, contractor labor).',
  `cost_object_type` STRING COMMENT 'Type of cost object to which labor is allocated. Determines which cost object reference field is populated. Valid values: work_order|capital_project|outage_event|cost_center|demand_response_program|overhead.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this labor cost allocation record was first created in the system.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the labor cost. Typically USD for US-based utilities. Pattern: ^[A-Z]{3}$.',
  `double_time_hours` DECIMAL(10,2) COMMENT 'Number of double-time hours worked for this allocation, typically at 2x regular rate per union agreements or emergency restoration work.',
  `expense_classification` STRING COMMENT 'Classification of the labor cost as Capital Expenditure (CAPEX) or Operational Expenditure (OPEX) for financial reporting and regulatory accounting. Valid values: capex|opex.',
  `ferc_account_code` STRING COMMENT 'FERC Uniform System of Accounts code to which this labor cost is posted for regulatory financial reporting.',
  `gl_account_code` STRING COMMENT 'General ledger account code in SAP S/4HANA to which this labor cost is posted.',
  `hours_worked` DECIMAL(10,2) COMMENT 'Total number of hours worked by the employee or contractor for this allocation. Includes regular, overtime, and double-time hours.',
  `job_classification` STRING COMMENT 'Job classification or title of the employee or contractor performing the work (e.g., Journeyman Lineman, Substation Technician, Plant Operator, Engineer).',
  `labor_rate` DECIMAL(12,2) COMMENT 'The blended hourly labor rate applied to this allocation, including base wage, benefits, and burden. Expressed in USD per hour.',
  `last_modified_by` STRING COMMENT 'User ID or name of the person who last modified this labor cost allocation record.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this labor cost allocation record was last modified.',
  `notes` STRING COMMENT 'Free-text notes or comments about this labor cost allocation, including special circumstances, exceptions, or clarifications.',
  `overtime_hours` DECIMAL(10,2) COMMENT 'Number of overtime hours worked for this allocation, typically at 1.5x regular rate per union agreements or labor law.',
  `posting_date` DATE COMMENT 'Date on which the labor cost allocation was posted to SAP S/4HANA general ledger. Null if not yet posted.',
  `regular_hours` DECIMAL(10,2) COMMENT 'Number of regular hours worked (non-overtime) for this allocation.',
  `reversal_date` DATE COMMENT 'Date on which this labor cost allocation was reversed. Null if not reversed.',
  `reversal_indicator` BOOLEAN COMMENT 'Flag indicating whether this labor cost allocation has been reversed due to error correction or reallocation. True if reversed, False otherwise.',
  `reversal_reason` STRING COMMENT 'Free-text explanation of why this labor cost allocation was reversed. Null if not reversed.',
  `sap_document_number` STRING COMMENT 'SAP S/4HANA financial document number generated when this labor cost allocation was posted to the general ledger. Null if not yet posted.',
  `shift_type` STRING COMMENT 'Type of work shift during which the labor was performed. Affects labor rate multipliers and union agreement compliance. Valid values: day|night|swing|on_call|emergency.',
  `time_entry_source` STRING COMMENT 'Source system or method by which the labor hours were originally captured (e.g., mobile field app, web timesheet, biometric time clock). Valid values: mobile_app|web_portal|time_clock|supervisor_entry|payroll_import.',
  `total_labor_cost` DECIMAL(15,2) COMMENT 'Total labor cost for this allocation, calculated as hours_worked multiplied by labor_rate. Expressed in USD.',
  `union_code` STRING COMMENT 'Code identifying the labor union to which the employee belongs. Null for non-union employees and contractors. Used for union agreement compliance and labor cost reporting.',
  `work_date` DATE COMMENT 'The date on which the labor was actually performed. May differ from allocation_date if allocation is recorded retrospectively.',
  `work_location_code` STRING COMMENT 'Code identifying the geographic location or facility where the work was performed. Used for regional cost analysis and labor mobility tracking.',
  `created_by` STRING COMMENT 'User ID or name of the person who created this labor cost allocation record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_labor_cost_allocation` PRIMARY KEY (`labor_cost_allocation_id`)
)
USING DELTA
COMMENT 'Transactional records allocating employee and contractor labor costs to specific cost objects — work orders (asset maintenance, capital construction), outage restoration events, demand response program delivery, and overhead cost centers. Captures employee/contractor, hours, labor rate, total cost, cost object type, cost object reference, allocation date, and capitalization vs. O&M expense classification. Feeds SAP S/4HANA plant maintenance and project accounting for CAPEX/OPEX reporting. | CMM: CIM LaborItem (close), IEC61968::InfWork.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'LaborCostAllocation',
  'cmm.cim.class' = 'LaborItem',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfWork',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-6',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.labor_cost_allocation'
);

-- NercCipAccess  <<CIM Agreement : extension>>
CREATE TABLE IF NOT EXISTS `workforce`.`nerc_cip_access` (
  `nerc_cip_access_id` BIGINT NOT NULL COMMENT 'Unique identifier for the NERC CIP access authorization record. Primary key for the access authorization entity.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: NERC CIP access authorizations are control-area-specific (CCA boundaries). Linking enables CIP-002 BES Cyber System access audits and personnel risk assessments by operational jurisdiction.',
  `logical_access_account_id` BIGINT COMMENT 'User account identifier or login credential for logical access to Critical Cyber Assets. Applicable for logical access authorizations.',
  `nerc_cip_asset_id` BIGINT COMMENT 'Identifier for the CIP-designated facility to which access is granted, such as control centers, generation plants, or transmission substations.',
  `nerc_employee_id` BIGINT COMMENT 'FK to workforce.employee.employee_id — NERC CIP access records must link to the specific employee or contractor granted access. This is mandatory audit evidence for NERC CIP-004 and CIP-006 compliance. Without this FK, access authorization',
  `primary_nerc_employee_id` BIGINT COMMENT 'Unique identifier for the employee or contractor being granted access. Links to the workforce employee master record.',
  `tertiary_nerc_modified_by_user_employee_id` BIGINT COMMENT 'Identifier of the user who last modified this access authorization record, required for accountability and audit trail.',
  `access_authorization_number` STRING COMMENT 'Business identifier for the access authorization record, typically used in audit documentation and compliance reporting.',
  `access_badge_number` STRING COMMENT 'Physical access badge or credential number issued for entry to CIP facilities. Applicable for physical access authorizations.',
  `access_level` STRING COMMENT 'Level or privilege tier of access granted within the CIP facility or system, defining the scope of permitted actions. Valid values: read_only|read_write|administrative|operator|engineer.',
  `access_review_status` STRING COMMENT 'Status of the periodic access review process. Current indicates review is up to date; overdue indicates review deadline has passed; scheduled indicates review is planned; in_progress indicates review is underway. Valid values: current|overdue|scheduled|in_progress.',
  `access_type` STRING COMMENT 'Type of access granted: physical access to CIP facilities, logical access to Critical Cyber Assets (CCAs), or both. Valid values: physical|logical|both.',
  `audit_notes` STRING COMMENT 'Free-text field for capturing additional audit-relevant information, exceptions, special conditions, or compliance notes related to this access authorization.',
  `authorization_date` DATE COMMENT 'Date on which the access authorization was granted and became effective.',
  `authorization_expiration_date` DATE COMMENT 'Date on which the access authorization expires and must be renewed or revoked. Nullable for indefinite authorizations subject to periodic review.',
  `authorization_status` STRING COMMENT 'Current lifecycle status of the access authorization. Active indicates valid access; revoked indicates access has been terminated; suspended indicates temporary hold; expired indicates authorization period has ended; pending indicates awaiting approval. Valid values: active|revoked|suspended|expired|pending.',
  `authorized_by_name` STRING COMMENT 'Full name of the manager or security officer who approved the access authorization, captured for audit documentation.',
  `background_check_completion_date` DATE COMMENT 'Date on which the background check or identity verification was completed as part of the Personnel Risk Assessment process.',
  `background_check_status` STRING COMMENT 'Status of the background check or identity verification process. Cleared indicates successful completion; pending indicates in progress; failed indicates disqualifying findings; waived indicates exemption granted. Valid values: cleared|pending|failed|waived.',
  `business_justification` STRING COMMENT 'Business reason and justification for granting CIP access, documenting the operational need and role requirements.',
  `cca_system_name` STRING COMMENT 'Name of the Critical Cyber Asset system or application to which logical access is granted, such as SCADA, EMS, or DMS systems.',
  `contractor_agreement_number` STRING COMMENT 'Reference number of the master service agreement or contract under which the contractor is engaged. Applicable for contractor access authorizations.',
  `contractor_company_name` STRING COMMENT 'Name of the contracting company if the individual is a contractor rather than a direct employee. Nullable for direct employees.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this access authorization record was first created in the system, used for audit trail and data lineage.',
  `escort_required_flag` BOOLEAN COMMENT 'Indicates whether the individual requires an escort when accessing CIP facilities. True if escort is required; false if unescorted access is permitted.',
  `last_access_review_date` DATE COMMENT 'Date of the most recent periodic review of this access authorization, required at least annually per NERC CIP-004-6 R4.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this access authorization record was last updated, used for audit trail and change tracking.',
  `nerc_cip_version` STRING COMMENT 'Version of the NERC CIP standards under which this access authorization was granted, important for tracking compliance requirements across standard revisions.',
  `next_access_review_date` DATE COMMENT 'Scheduled date for the next periodic review of this access authorization to verify continued business need and appropriateness.',
  `pra_completion_date` DATE COMMENT 'Date on which the Personnel Risk Assessment was completed for this individual, a prerequisite for CIP access authorization.',
  `pra_reference_number` STRING COMMENT 'Reference identifier linking to the Personnel Risk Assessment record, used for audit verification and compliance tracking.',
  `revocation_date` DATE COMMENT 'Date on which the access authorization was revoked, typically upon termination, transfer, or no longer requiring access. Nullable if authorization has not been revoked.',
  `revocation_reason` STRING COMMENT 'Reason for revoking the access authorization, required for audit trail and compliance documentation. Valid values: termination|transfer|role_change|security_violation|no_longer_required|other.',
  `seven_year_retention_flag` BOOLEAN COMMENT 'Indicates whether this access authorization record must be retained for seven years per NERC CIP compliance requirements. True for records requiring extended retention; false otherwise.',
  `training_completion_date` DATE COMMENT 'Date on which the individual completed required NERC CIP security awareness and role-based training, a prerequisite for access authorization.',
  `training_reference_number` STRING COMMENT 'Reference identifier linking to the CIP training completion record for audit verification.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_nerc_cip_access` PRIMARY KEY (`nerc_cip_access_id`)
)
USING DELTA
COMMENT 'NERC CIP-004 and CIP-006 access authorization records for employees and contractors with logical or physical access to Critical Cyber Assets (CCAs) and Critical Infrastructure Protection (CIP) facilities including control rooms, generation plants, and transmission substations. Captures access type (physical/logical), CIP facility or system, authorization date, revocation date, PRA completion reference, and seven-year retention flag. Mandatory evidence for NERC CIP compliance audits. | CMM: CIM Agreement (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'NercCipAccess',
  'cmm.cim.class' = 'Agreement',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.nerc_cip_access'
);

-- Grievance  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `workforce`.`grievance` (
  `grievance_id` BIGINT NOT NULL COMMENT 'Unique identifier for the union grievance record. Primary key.',
  `grievance_employee_id` BIGINT COMMENT 'Identifier of the union steward or business agent representing the grievant in the grievance procedure.',
  `grievance_grievant_employee_id` BIGINT COMMENT 'Identifier of the bargaining unit employee who filed the grievance or on whose behalf the grievance was filed.',
  `grievance_labor_relations_specialist_employee_id` BIGINT COMMENT 'Identifier of the company labor relations specialist or human resources representative managing the grievance on behalf of management.',
  `grievance_management_respondent_employee_id` BIGINT COMMENT 'Identifier of the management representative or supervisor whose action or decision is being grieved.',
  `union_agreement_id` BIGINT COMMENT 'Foreign key linking to workforce.union_agreement. Business justification: Grievances allege violations of collective bargaining agreements (CBAs). Adding union_agreement_id FK links each grievance to the specific CBA being contested. Currently stores alleged_cba_violation a',
  `arbitration_cost_amount` DECIMAL(15,2) COMMENT 'Total cost of arbitration including arbitrator fees, hearing room rental, and administrative expenses, in USD.',
  `arbitration_decision_date` DATE COMMENT 'Date the arbitrator issued the binding arbitration award or decision.',
  `arbitration_filed_date` DATE COMMENT 'Date the union filed for binding arbitration after exhausting internal grievance procedure steps.',
  `arbitration_hearing_date` DATE COMMENT 'Date of the formal arbitration hearing where both parties present evidence and arguments.',
  `arbitration_outcome` STRING COMMENT 'Final outcome of the arbitration: sustained (grievance upheld), denied (management decision upheld), or partially sustained (split decision). Valid values: sustained|denied|partially_sustained.',
  `arbitrator_name` STRING COMMENT 'Name of the neutral arbitrator selected to hear and decide the grievance if it proceeds to arbitration.',
  `back_pay_amount` DECIMAL(15,2) COMMENT 'Monetary amount of back pay awarded to the grievant as part of the grievance resolution or arbitration award, in USD.',
  `cost_center` STRING COMMENT 'Cost center to which any financial settlement, back pay, or arbitration costs are allocated for accounting purposes. Pattern: ^[0-9]{10}$.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this grievance record was first created in the system.',
  `filing_date` DATE COMMENT 'Date the grievance was formally filed with management, triggering the grievance procedure timeline per the collective bargaining agreement.',
  `grievance_number` STRING COMMENT 'Business identifier for the grievance, typically formatted as GRV-YYYY-NNNNN for external reference and tracking. Pattern: ^GRV-[0-9]{4}-[0-9]{5}$.',
  `grievance_status` STRING COMMENT 'Current status of the grievance in the resolution lifecycle, tracking progression through the grievance procedure steps defined in the CBA. Reference-value candidates: filed|step_1_pending|step_2_pending|step_3_pending|arbitration_pending|resolved|withdrawn|denied.',
  `grievance_type` STRING COMMENT 'Classification of the grievance: individual (single employee), group (multiple employees), policy (interpretation of CBA language), or continuing (ongoing violation). Valid values: individual|group|policy|continuing.',
  `incident_date` DATE COMMENT 'Date the alleged CBA violation or incident that gave rise to the grievance occurred.',
  `incident_location` STRING COMMENT 'Work location, facility, or service center where the alleged violation occurred.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this grievance record was last updated or modified.',
  `management_response` STRING COMMENT 'Written response from management to the grievance, including rationale for the decision and interpretation of CBA provisions.',
  `management_response_date` DATE COMMENT 'Date management provided its written response to the grievance at the current step.',
  `modified_by_user` STRING COMMENT 'User ID or system account that last modified this grievance record, for audit trail purposes.',
  `notes` STRING COMMENT 'Additional notes, comments, or context regarding the grievance, its handling, or resolution.',
  `precedent_setting_flag` BOOLEAN COMMENT 'Indicates whether this grievance or arbitration decision establishes a precedent for future CBA interpretation (True/False).',
  `remedy_requested` STRING COMMENT 'Specific remedy or relief requested by the grievant or union (e.g., reinstatement, back pay, removal of discipline from record).',
  `resolution_date` DATE COMMENT 'Date the grievance was formally resolved, closed, or withdrawn.',
  `resolution_outcome` STRING COMMENT 'Final resolution outcome of the grievance: granted (remedy provided), denied (grievance rejected), settled (mutual agreement), or withdrawn (grievant withdrew). Valid values: granted|denied|settled|withdrawn.',
  `settlement_terms` STRING COMMENT 'Detailed terms of the settlement agreement if the grievance was resolved through mutual agreement between the parties.',
  `step` STRING COMMENT 'Current step in the multi-step grievance procedure as defined in the collective bargaining agreement (typically Step 1 through arbitration). Valid values: step_1|step_2|step_3|arbitration.',
  `step_1_hearing_date` DATE COMMENT 'Date of the Step 1 grievance hearing between the grievant, union representative, and first-level management.',
  `step_2_hearing_date` DATE COMMENT 'Date of the Step 2 grievance hearing with higher-level management if Step 1 did not resolve the grievance.',
  `step_3_hearing_date` DATE COMMENT 'Date of the Step 3 grievance hearing with senior management or labor relations department if Step 2 did not resolve the grievance.',
  `subject` STRING COMMENT 'Primary subject matter category of the grievance for classification and trend analysis. Reference-value candidates: discipline|discharge|work_assignment|overtime|seniority|safety|wages|benefits|working_conditions|other.',
  `time_limit_compliance_flag` BOOLEAN COMMENT 'Indicates whether the grievance was filed and processed within the time limits specified in the CBA (True/False). Non-compliance may render grievance invalid.',
  `union_local` STRING COMMENT 'Union local chapter or bargaining unit that represents the grievant (e.g., IBEW Local 1245, UWUA Local 223).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_grievance` PRIMARY KEY (`grievance_id`)
)
USING DELTA
COMMENT 'Union grievance records filed by bargaining unit employees or union representatives alleging violations of the collective bargaining agreement. Captures grievance number, filing date, grievant employee, union local, alleged CBA violation, step in grievance procedure (Step 1 through arbitration), management response, resolution outcome, and settlement terms. Supports labor relations management and CBA compliance tracking. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'Grievance',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.grievance'
);

-- JobRequisition  <<CIM Request : extension>>
CREATE TABLE IF NOT EXISTS `workforce`.`job_requisition` (
  `job_requisition_id` BIGINT NOT NULL COMMENT 'Unique identifier for the job requisition record. Primary key for the job requisition entity.',
  `job_org_unit_id` BIGINT COMMENT 'Reference to the organizational unit (department, division, service center) where the position will be located. Links to organizational hierarchy for reporting and budget allocation.',
  `org_unit_id` BIGINT COMMENT 'FK to workforce.org_unit.org_unit_id — Requisitions are raised within specific org units. This drives departmental hiring budget tracking and approval workflows.',
  `primary_job_employee_id` BIGINT COMMENT 'Reference to the employee who initiated the requisition and will manage the new hire. Responsible for interview participation and final selection decision.',
  `workforce_position_id` BIGINT COMMENT 'FK to workforce.workforce_position.workforce_position_id — Job requisitions are opened to fill specific authorized positions. This link enables headcount tracking (authorized vs filled vs in-recruitment) and ensures requisitions align with approved position s',
  `approved_headcount_budget` DECIMAL(12,2) COMMENT 'Total annual budget allocated for this position including salary, benefits, and overhead. Used for financial planning and budget variance tracking.',
  `background_check_level` STRING COMMENT 'Depth of pre-employment background screening required. NERC CIP PRA is most comprehensive, including criminal history, employment verification, and credit check for positions with CIP access. Valid values: basic|standard|comprehensive|nerc_cip_pra.',
  `cdl_class` STRING COMMENT 'Required CDL class if CDL is mandatory. Class A for heavy combination vehicles, Class B for heavy straight vehicles, Class C for vehicles carrying hazardous materials or 16+ passengers. Valid values: A|B|C.',
  `cdl_required` BOOLEAN COMMENT 'Indicates whether a valid Commercial Driver License is required for the position. Common for field crew, meter reader, and equipment operator roles.',
  `cost_center` STRING COMMENT 'Financial cost center code to which the position salary and benefits will be charged. Used for budget tracking and labor cost allocation. Pattern: ^[0-9]{4,10}$.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the requisition record was first created in the system. Used for audit trail and process analytics.',
  `drug_testing_required` BOOLEAN COMMENT 'Indicates whether pre-employment and ongoing drug testing is required. Mandatory for safety-sensitive positions and CDL holders under DOT regulations.',
  `employment_type` STRING COMMENT 'Classification of the employment relationship. Determines benefits eligibility, labor agreements, and workforce reporting categories. Valid values: full_time|part_time|temporary|seasonal|contractor|intern.',
  `flsa_status` STRING COMMENT 'Classification under the Fair Labor Standards Act determining overtime eligibility. Non-exempt employees are entitled to overtime pay; exempt employees are not. Valid values: exempt|non_exempt.',
  `full_time_equivalent` DECIMAL(5,2) COMMENT 'Numeric representation of the position workload as a fraction of full-time hours. 1.0 for full-time, 0.5 for half-time. Used for headcount budgeting and capacity planning.',
  `job_description` STRING COMMENT 'Detailed narrative description of the position responsibilities, duties, and expectations. Used for job postings and candidate communication.',
  `job_family` STRING COMMENT 'Broad occupational category grouping similar roles. Used for workforce planning, compensation benchmarking, and career pathing. Reference-value candidates: operations|engineering|technical|administrative|management|field_services|customer_service|finance|it|safety.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the requisition record. Used for audit trail and change tracking.',
  `minimum_education_level` STRING COMMENT 'Minimum educational qualification required for the position. Used for candidate screening and compliance with professional licensing requirements. Valid values: high_school|associate|bachelor|master|doctorate|trade_certification.',
  `minimum_experience_years` INT COMMENT 'Minimum number of years of relevant work experience required for the position. Used for candidate screening and compensation determination.',
  `modified_by_user` STRING COMMENT 'User ID or name of the person who last modified the requisition record. Used for audit trail and accountability.',
  `nerc_cip_access_required` BOOLEAN COMMENT 'Indicates whether the position requires access to NERC CIP-designated critical cyber assets or physical security perimeters. Triggers Personnel Risk Assessment (PRA) and background check requirements.',
  `number_of_openings` INT COMMENT 'Count of positions to be filled under this requisition. Typically 1 for individual hires, may be higher for seasonal or crew hiring campaigns.',
  `osha_safety_sensitive` BOOLEAN COMMENT 'Indicates whether the position is classified as safety-sensitive under OSHA regulations, requiring enhanced safety training, drug testing, and incident reporting.',
  `pay_grade` STRING COMMENT 'Compensation level assigned to the position within the utility pay structure. Determines salary range and progression path. Often tied to union agreements. Pattern: ^[A-Z0-9]{2,6}$.',
  `physical_requirements` STRING COMMENT 'Description of physical demands of the position (e.g., ability to lift 50 lbs, climb poles, work at heights, operate in confined spaces). Required for ADA compliance and safety planning.',
  `position_title` STRING COMMENT 'Job title for the open position being recruited. Examples include Lineman, Substation Operator, Meter Reader, Distribution Engineer, SCADA Technician.',
  `required_certifications` STRING COMMENT 'Comma-separated list of mandatory certifications for the position (e.g., CDL Class A, NERC CIP training, OSHA 10-hour, First Aid/CPR, Journeyman Lineman). Used for candidate screening.',
  `requisition_approved_date` DATE COMMENT 'Date when the requisition received final approval and was authorized to proceed with recruitment. Null if still pending or rejected.',
  `requisition_closed_date` DATE COMMENT 'Date when the requisition was closed (filled, cancelled, or withdrawn). Used to calculate time-to-fill metrics.',
  `requisition_justification` STRING COMMENT 'Business reason for the hiring request. Supports headcount planning and budget approval processes. Distinguishes between replacement hires and net new positions. Reference-value candidates: backfill_retirement|backfill_resignation|backfill_termination|new_headcount_growth|new_headcount_project|seasonal_demand|regulatory_requirement|workload_increase.',
  `requisition_number` STRING COMMENT 'Business identifier for the job requisition, typically formatted as REQ-NNNNNN. Used for external communication and tracking in recruitment systems. Pattern: ^REQ-[0-9]{6,10}$.',
  `requisition_status` STRING COMMENT 'Current lifecycle status of the job requisition in the hiring workflow. Tracks progression from draft through approval to fulfillment or cancellation. Reference-value candidates: draft|submitted|approved|rejected|open|in_progress|filled|cancelled|on_hold.',
  `requisition_submitted_date` DATE COMMENT 'Date when the hiring manager submitted the requisition for approval. Marks the start of the approval workflow.',
  `requisition_type` STRING COMMENT 'Classification of the hiring need. Distinguishes between new headcount, backfill for departed employee, seasonal staffing, temporary assignments, and contractor positions. Reference-value candidates: new_position|backfill|replacement|seasonal|temporary|contractor|intern.',
  `salary_range_maximum` DECIMAL(12,2) COMMENT 'Maximum annual salary for the position in USD. Defines the upper bound of the compensation band for the pay grade.',
  `salary_range_minimum` DECIMAL(12,2) COMMENT 'Minimum annual salary for the position in USD. Defines the lower bound of the compensation band for the pay grade.',
  `security_clearance_required` BOOLEAN COMMENT 'Indicates whether the position requires government or utility security clearance. Common for positions with access to critical infrastructure or sensitive operational data.',
  `shift_pattern` STRING COMMENT 'Standard work schedule pattern for the position. Critical for operations and field services roles requiring 24/7 coverage. Valid values: day|night|rotating|on_call|flexible.',
  `sourcing_channel` STRING COMMENT 'Primary recruitment channel for candidate sourcing. Used to track recruitment effectiveness and cost-per-hire by channel. Reference-value candidates: internal_posting|external_posting|employee_referral|recruitment_agency|campus_recruiting|job_board|social_media|direct_sourcing.',
  `target_hire_date` DATE COMMENT 'Desired start date for the new hire. Used for recruitment timeline planning and workforce capacity forecasting.',
  `travel_requirement_pct` INT COMMENT 'Expected percentage of work time requiring travel away from primary work location. Ranges from 0 (no travel) to 100 (constant travel). Important for field engineering and mutual aid roles.',
  `union_classification` STRING COMMENT 'Indicates whether the position is covered by a collective bargaining agreement. Critical for labor relations, scheduling rules, and compensation administration. Valid values: union|non_union|management.',
  `union_local` STRING COMMENT 'Specific union local chapter governing the position (e.g., IBEW Local 1245, UWUA Local 246). Null for non-union positions. Determines applicable labor agreement terms.',
  `work_location_code` BIGINT COMMENT 'Reference to the primary work location (service center, plant, substation, office) where the employee will be based. Critical for field crew and operations roles.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_job_requisition` PRIMARY KEY (`job_requisition_id`)
)
USING DELTA
COMMENT 'Workforce hiring requisitions initiated by utility managers to fill open positions — covering both permanent hires and temporary/seasonal staffing needs. Captures requisition number, position, org unit, hiring manager, justification (backfill, new headcount, seasonal), required certifications, target hire date, approved headcount budget, recruitment status, and sourcing channel. Drives talent acquisition workflow and headcount tracking against authorized positions. | CMM: CIM Request (extension), IEC61968::InfWork.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'JobRequisition',
  'cmm.cim.class' = 'Request',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::InfWork',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-6',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.job_requisition'
);

-- MutualAidDeployment  <<CIM Assignment : extension>>
CREATE TABLE IF NOT EXISTS `workforce`.`mutual_aid_deployment` (
  `mutual_aid_deployment_id` BIGINT NOT NULL COMMENT 'Unique identifier for the mutual aid deployment record. Primary key.',
  `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Mutual aid deployments track cost centers for reimbursement tracking, cost recovery, and financial reporting. Replacing denormalized cost_allocation_code with proper FK to cost_center.',
  `crew_id` BIGINT COMMENT 'FK to workforce.crew.crew_id — Mutual aid deployments send specific crews to requesting utilities. This link enables tracking which crews are deployed, their availability status, and restoration cost allocation.',
  `deployment_coordinator_employee_id` BIGINT COMMENT 'Identifier of the employee coordinating the mutual aid deployment from the providing utility.',
  `event_id` BIGINT COMMENT 'Foreign key linking to outage.outage_event. Business justification: Mutual aid deployments are triggered by specific major outage events (storms, disasters). Utilities track which outage event necessitated external crew deployment for cost recovery, NERC/FEMA reportin',
  `mutual_aid_agreement_id` BIGINT COMMENT 'Identifier of the mutual aid agreement or compact under which the deployment was authorized (e.g., EEI Mutual Assistance Agreement, regional compact).',
  `receiving_control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Mutual aid deployments to receiving utility\'s control area. Linking enables load restoration coordination, ACE impact analysis, and reimbursement cost allocation by operational jurisdiction.',
  `requesting_utility_id` BIGINT COMMENT 'Identifier of the utility company requesting mutual aid assistance during the emergency event.',
  `contractor_company_name` STRING COMMENT 'Name of the contractor company if the providing entity is a contractor.',
  `contractor_flag` BOOLEAN COMMENT 'Indicates whether the providing entity is a contractor (True) or another utility (False).',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the mutual aid deployment record was first created in the system.',
  `customers_restored_count` INT COMMENT 'Total number of customer accounts restored to service by the deployed crew.',
  `deployment_county` STRING COMMENT 'County or region where the mutual aid deployment occurred.',
  `deployment_duration_days` INT COMMENT 'Total number of days the crew was deployed under mutual aid.',
  `deployment_end_date` DATE COMMENT 'Date when the mutual aid deployment ended and crews were released to return home.',
  `deployment_notes` STRING COMMENT 'Additional notes, comments, or special instructions related to the mutual aid deployment.',
  `deployment_number` STRING COMMENT 'Business identifier for the mutual aid deployment, used for external tracking and reference in mutual aid coordination systems.',
  `deployment_personnel_count` INT COMMENT 'Total number of personnel deployed under this mutual aid agreement.',
  `deployment_start_date` DATE COMMENT 'Date when the mutual aid deployment began and crews arrived at the requesting utility\'s service territory.',
  `deployment_state` STRING COMMENT 'State or province where the mutual aid deployment occurred.',
  `deployment_status` STRING COMMENT 'Current lifecycle status of the mutual aid deployment (requested, approved, mobilizing, deployed, demobilizing, completed, cancelled). Reference-value candidates: requested|approved|mobilizing|deployed|demobilizing|completed|cancelled.',
  `deployment_vehicle_count` INT COMMENT 'Total number of vehicles and equipment units deployed with the crew.',
  `deployment_work_location` STRING COMMENT 'Geographic location or service territory where the deployed crew performed restoration work.',
  `equipment_cost_amount` DECIMAL(15,2) COMMENT 'Total equipment and vehicle cost for the deployment, including rental, fuel, and maintenance.',
  `event_type` STRING COMMENT 'Type of emergency event that triggered the mutual aid request (hurricane, tornado, ice storm, wildfire, flood, earthquake, grid emergency, other). Reference-value candidates: hurricane|tornado|ice_storm|wildfire|flood|earthquake|grid_emergency|other.',
  `fema_disaster_number` STRING COMMENT 'FEMA disaster declaration number associated with the event, used for federal reimbursement tracking.',
  `labor_cost_amount` DECIMAL(15,2) COMMENT 'Total labor cost for deployed personnel, including wages, benefits, and overtime.',
  `labor_hours_total` DECIMAL(12,2) COMMENT 'Total labor hours worked by all deployed personnel during the mutual aid deployment.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the mutual aid deployment record was last updated.',
  `lodging_cost_amount` DECIMAL(15,2) COMMENT 'Total lodging and accommodation cost for deployed personnel.',
  `material_cost_amount` DECIMAL(15,2) COMMENT 'Total material and supply cost used during the deployment.',
  `meal_cost_amount` DECIMAL(15,2) COMMENT 'Total meal and per diem cost for deployed personnel.',
  `overtime_hours` DECIMAL(12,2) COMMENT 'Total overtime labor hours worked during the deployment.',
  `providing_utility_code` BIGINT COMMENT 'Identifier of the utility company or contractor providing mutual aid resources and personnel.',
  `providing_utility_name` STRING COMMENT 'Name of the utility company or contractor providing mutual aid resources.',
  `regular_hours` DECIMAL(12,2) COMMENT 'Total regular labor hours worked during the deployment.',
  `reimbursable_cost_amount` DECIMAL(15,2) COMMENT 'Total reimbursable cost amount for the mutual aid deployment, including labor, equipment, materials, and expenses.',
  `reimbursement_date` DATE COMMENT 'Date when the mutual aid reimbursement payment was received.',
  `reimbursement_invoice_number` STRING COMMENT 'Invoice number submitted to the requesting utility for mutual aid cost reimbursement.',
  `reimbursement_status` STRING COMMENT 'Status of the reimbursement claim for mutual aid costs (pending, submitted, approved, paid, disputed). Valid values: pending|submitted|approved|paid|disputed.',
  `requesting_utility_contact_name` STRING COMMENT 'Name of the primary contact person at the requesting utility for this deployment.',
  `requesting_utility_contact_phone` STRING COMMENT 'Phone number of the primary contact person at the requesting utility.',
  `requesting_utility_name` STRING COMMENT 'Name of the utility company requesting mutual aid assistance.',
  `restoration_tasks_performed` STRING COMMENT 'Description of the restoration tasks and work activities performed by the deployed crew during the mutual aid deployment.',
  `travel_cost_amount` DECIMAL(15,2) COMMENT 'Total travel cost including mobilization and demobilization expenses.',
  `work_order_count` INT COMMENT 'Total number of work orders completed by the deployed crew during the mutual aid deployment.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_mutual_aid_deployment` PRIMARY KEY (`mutual_aid_deployment_id`)
)
USING DELTA
COMMENT 'Records of utility workforce and contractor crews deployed under mutual aid agreements during major storm events, natural disasters, or grid emergencies. Captures requesting utility, providing utility or contractor, crew type, number of personnel, deployment start/end dates, work location, restoration tasks performed, and reimbursable cost. Supports EATON/EEI mutual aid cost recovery, FEMA reimbursement documentation, and post-storm after-action reporting. | CMM: CIM Assignment (extension), IEC61968::InfWork.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MutualAidDeployment',
  'cmm.cim.class' = 'Assignment',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::InfWork',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-6',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.mutual_aid_deployment'
);

-- DrugAlcoholTest  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `workforce`.`drug_alcohol_test` (
  `drug_alcohol_test_id` BIGINT NOT NULL COMMENT 'Unique identifier for the drug and alcohol test record. Primary key for the drug_alcohol_test product.',
  `primary_drug_employee_id` BIGINT COMMENT 'Identifier of the employee who underwent the drug and alcohol test. Links to the employee master record in the workforce domain.',
  `safety_incident_id` BIGINT COMMENT 'Identifier of the workplace accident or incident that triggered a post-accident drug and alcohol test. Links to incident or safety event records for OSHA investigation requirements.',
  `alcohol_concentration` DECIMAL(5,3) COMMENT 'Measured blood alcohol concentration (BAC) level from breath or blood test, expressed as a decimal (e.g., 0.040 for 0.04%). DOT prohibits safety-sensitive work at 0.04% or higher.',
  `alcohol_test_result` STRING COMMENT 'Specific result of the alcohol screening component. Separate from drug result when both are tested. Valid values: negative|positive|refused|invalid|cancelled|not tested.',
  `cdl_driver_test` BOOLEAN COMMENT 'Indicates whether this test was administered to an employee holding a Commercial Driver License under FMCSA regulations.',
  `chain_of_custody_maintained` BOOLEAN COMMENT 'Indicates whether proper chain of custody procedures were followed from specimen collection through laboratory analysis. Required for test validity and legal defensibility.',
  `collection_site_address` STRING COMMENT 'Physical address of the collection site where the test specimen was obtained. Organizational contact data classified as confidential.',
  `collection_site_name` STRING COMMENT 'Name of the facility or location where the specimen was collected (e.g., clinic name, mobile collection unit, on-site medical facility).',
  `collector_name` STRING COMMENT 'Name of the certified specimen collector who performed the collection. Required for chain of custody documentation.',
  `confirmation_test_date` DATE COMMENT 'Date the confirmation test was performed following an initial positive screening result.',
  `confirmation_test_required` BOOLEAN COMMENT 'Indicates whether a confirmation test is required following an initial positive screening result. DOT requires confirmation testing using gas chromatography/mass spectrometry (GC/MS) or equivalent.',
  `confirmation_test_result` STRING COMMENT 'Result of the confirmation test. Confirmed positive verifies the initial positive screening; negative overturns the initial positive; cancelled indicates the confirmation test could not be completed. Valid values: confirmed positive|negative|cancelled.',
  `cost_center` STRING COMMENT 'Cost center code to which the drug and alcohol testing costs are allocated. Used for financial tracking and departmental budgeting.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this drug and alcohol test record was first created in the system. Audit trail for record creation.',
  `disciplinary_action_taken` STRING COMMENT 'Description of disciplinary action taken as a result of the test (e.g., suspension, termination, written warning, mandatory treatment). May reference collective bargaining agreement provisions.',
  `dot_regulated_test` BOOLEAN COMMENT 'Indicates whether this test is subject to DOT 49 CFR Part 40 regulations. True for safety-sensitive positions including CDL drivers, pipeline operators, and certain generation plant operators.',
  `drug_test_result` STRING COMMENT 'Specific result of the drug screening component. Separate from alcohol result when both are tested. Reference-value candidates: negative|positive|refused|adulterated|substituted|invalid|cancelled|not.',
  `employee_notification_date` DATE COMMENT 'Date the employee was notified of the test result. Required for due process and to initiate any appeal or follow-up action timelines.',
  `follow_up_action_required` BOOLEAN COMMENT 'Indicates whether follow-up action is required based on the test result. True for positive results requiring substance abuse professional evaluation, return-to-duty testing, or disciplinary action.',
  `follow_up_action_type` STRING COMMENT 'Type of follow-up action required. May include referral to substance abuse professional (SAP), return-to-duty testing, follow-up testing plan, disciplinary action, or termination. Comma-separated list if multiple actions apply.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this drug and alcohol test record was last updated. Audit trail for record changes.',
  `legitimate_medical_explanation` BOOLEAN COMMENT 'Indicates whether the MRO determined there was a legitimate medical explanation for a positive test result (e.g., valid prescription for detected substance). If true, the MRO may verify the result as negative.',
  `modified_by_user` STRING COMMENT 'User ID or name of the person who last modified this drug and alcohol test record. Audit trail for accountability.',
  `mro_name` STRING COMMENT 'Name of the licensed physician serving as Medical Review Officer who reviewed and verified the test result. Required for DOT-mandated testing.',
  `mro_review_date` DATE COMMENT 'Date the Medical Review Officer completed review and verification of the test result.',
  `mro_review_required` BOOLEAN COMMENT 'Indicates whether Medical Review Officer review is required. DOT requires MRO review of all positive, adulterated, substituted, and invalid drug test results.',
  `mro_verified_result` STRING COMMENT 'Final result verified by the Medical Review Officer after reviewing laboratory results and interviewing the employee. This is the official reportable result. Valid values: negative|positive|test cancelled|refusal to test.',
  `notes` STRING COMMENT 'Additional notes or comments regarding the drug and alcohol test, including special circumstances, procedural issues, or follow-up actions. Free-text field for case documentation.',
  `post_accident_incident_date` DATE COMMENT 'Date of the workplace accident or incident that triggered the post-accident test. DOT requires testing within specified timeframes after qualifying accidents.',
  `reasonable_suspicion_basis` STRING COMMENT 'Description of the observed behavior or circumstances that provided reasonable suspicion for ordering a drug or alcohol test. Must be documented by a trained supervisor.',
  `refusal_reason` STRING COMMENT 'Reason for test refusal if result is \'refused\'. May include failure to appear, failure to provide adequate specimen, adulterating or substituting specimen, failure to cooperate with collection process, or leaving collection site before process is complete.',
  `result_reported_to_employer_date` DATE COMMENT 'Date the verified test result was officially reported to the employer by the MRO or testing provider. DOT requires timely reporting of verified results.',
  `return_to_duty_clearance_date` DATE COMMENT 'Date the employee received clearance to return to safety-sensitive duties following completion of SAP-recommended treatment and passing a return-to-duty test.',
  `safety_sensitive_position` BOOLEAN COMMENT 'Indicates whether the employee holds a safety-sensitive position requiring drug and alcohol testing under DOT or utility company policy. Includes transmission/distribution field crews, generation plant operators, and CDL drivers.',
  `sap_name` STRING COMMENT 'Name of the Substance Abuse Professional (licensed physician, social worker, psychologist, or certified counselor) who evaluated the employee and recommended treatment.',
  `sap_referral_date` DATE COMMENT 'Date the employee was referred to a Substance Abuse Professional following a positive test result. DOT requires SAP evaluation before return-to-duty.',
  `specimen_code` STRING COMMENT 'Unique identifier assigned to the specimen for chain of custody tracking. Typically a barcode or serial number on the collection container.',
  `specimen_type` STRING COMMENT 'Type of biological specimen collected for testing. Urine is standard for drug tests; breath is standard for alcohol tests; blood, saliva, and hair may be used in specific circumstances. Valid values: urine|breath|blood|saliva|hair.',
  `split_specimen_requested` BOOLEAN COMMENT 'Indicates whether the employee requested analysis of the split specimen following a positive result. DOT requires split specimen testing option for all positive drug tests.',
  `split_specimen_result` STRING COMMENT 'Result of the split specimen analysis if requested by the employee. Used to verify or refute the original positive result. Valid values: confirmed positive|negative|test cancelled|not requested.',
  `substances_detected` STRING COMMENT 'List of specific controlled substances or drug metabolites detected in a positive drug test (e.g., marijuana metabolites, cocaine metabolites, opiates, amphetamines, PCP). Comma-separated list.',
  `test_category` STRING COMMENT 'Category of substance tested: drug only, alcohol only, or combined drug and alcohol test. Valid values: drug|alcohol|drug and alcohol.',
  `test_cost_amount` DECIMAL(10,2) COMMENT 'Total cost of the drug and alcohol test including collection, laboratory analysis, MRO review, and administrative fees. Used for cost tracking and vendor invoice reconciliation.',
  `test_date` DATE COMMENT 'Date the drug and alcohol test was administered. Principal business event date for the test record.',
  `test_number` STRING COMMENT 'Externally-known unique test number or specimen identifier assigned by the testing provider or internal tracking system. Used for chain of custody and audit trail.',
  `test_result` STRING COMMENT 'Overall result of the drug and alcohol test. Negative indicates no prohibited substances detected; positive indicates presence of prohibited substances above cutoff levels; refused indicates employee refusal to test; adulterated/substituted indicate specimen tampering; invalid indicates specimen cannot be tested; cancelled indicates test was administratively cancelled. Reference-value candidates: negative|positive|refused|adulterated|substituted|invalid|cancelled.',
  `test_status` STRING COMMENT 'Current status of the drug and alcohol test in its lifecycle workflow. Tracks progression from scheduling through final result verification. Reference-value candidates: scheduled|specimen.',
  `test_timestamp` TIMESTAMP COMMENT 'Precise date and time the specimen was collected or the test was administered. Used for chain of custody and compliance reporting.',
  `test_type` STRING COMMENT 'Type of drug and alcohol test administered. Pre-employment tests are conducted before hire; random tests are unannounced selections from the covered employee pool; post-accident tests follow qualifying incidents; reasonable suspicion tests are based on observed behavior; return-to-duty tests are required before an employee returns after a positive test; follow-up tests are unannounced tests after return-to-duty. Valid values: pre-employment|random|post-accident|reasonable suspicion|return-to-duty|follow-up.',
  `testing_provider_certification_number` STRING COMMENT 'Certification or accreditation number of the testing laboratory (e.g., SAMHSA certification number for drug testing labs). Required for DOT compliance.',
  `testing_provider_name` STRING COMMENT 'Name of the laboratory or testing provider that analyzed the specimen and reported results. Must be a DOT-certified laboratory for DOT-mandated tests.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_drug_alcohol_test` PRIMARY KEY (`drug_alcohol_test_id`)
)
USING DELTA
COMMENT 'DOT and utility-mandated drug and alcohol testing records for safety-sensitive utility positions including CDL drivers, generation plant operators, and transmission/distribution field crews. Captures test type (pre-employment, random, post-accident, reasonable suspicion, return-to-duty), test date, employee, testing provider, result (negative/positive/refused), and follow-up action required. Supports DOT 49 CFR Part 40 compliance and OSHA post-accident investigation requirements. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'DrugAlcoholTest',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.drug_alcohol_test'
);

-- EmployeeQualification  <<CIM ErpCompetency : close>>
CREATE TABLE IF NOT EXISTS `workforce`.`employee_qualification` (
  `employee_qualification_id` BIGINT NOT NULL COMMENT 'Unique identifier for the employee qualification record. Primary key for the employee qualification entity.',
  `primary_employee_id` BIGINT COMMENT 'Reference to the employee who holds this qualification. Links to the employee master record in the workforce domain.',
  `apprenticeship_completion_flag` BOOLEAN COMMENT 'Indicates whether this qualification represents the successful completion of a formal trade apprenticeship program. True for journeyman-level qualifications achieved through multi-year apprenticeship programs.',
  `apprenticeship_hours_completed` INT COMMENT 'Total on-the-job training hours completed as part of the apprenticeship program leading to this qualification. Typically 8,000+ hours for journeyman lineman programs.',
  `apprenticeship_program_name` STRING COMMENT 'Name of the registered apprenticeship program completed, if applicable. Examples include IBEW/NECA Joint Apprenticeship Training Committee (JATC) programs or utility-sponsored apprenticeships.',
  `approval_authority` STRING COMMENT 'Title or role of the individual or committee with authority to approve and award this qualification. Examples include Director of Operations, Chief Engineer, or Safety and Training Committee.',
  `approval_date` DATE COMMENT 'Date on which the qualification award was formally approved by the designated authority. May differ from assessment date if management review or committee approval is required.',
  `assessment_date` DATE COMMENT 'Date on which the employee successfully completed the qualification assessment and was awarded the qualification. Serves as the baseline for expiration tracking and renewal scheduling.',
  `assessment_method` STRING COMMENT 'Method used to evaluate the employee\'s competency for this qualification. May include written examinations, practical demonstrations, field evaluations under supervision, simulator assessments, or oral board reviews. Reference-value candidates: written_exam|practical_demonstration|field_evaluation|simulation|oral_board|portfolio_review|combination.',
  `assessment_score` DECIMAL(5,2) COMMENT 'Numeric score achieved by the employee on the qualification assessment, typically expressed as a percentage or points out of maximum. Used for performance tracking and identifying candidates for advanced qualifications.',
  `assessor_name` STRING COMMENT 'Full name of the individual who conducted the qualification assessment. Captured for audit trail and quality assurance purposes.',
  `competency_level` STRING COMMENT 'Proficiency level achieved by the employee for this qualification, ranging from entry-level to master craftsman. Used for crew assignment, work complexity authorization, and career progression tracking. Valid values: entry|intermediate|advanced|expert|master.',
  `continuing_education_required_hours` DECIMAL(5,2) COMMENT 'Number of continuing education or refresher training hours required per renewal cycle to maintain this qualification. Used for training planning and compliance tracking.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this qualification record was first created in the data platform. Part of standard audit trail for data governance and lineage tracking.',
  `effective_date` DATE COMMENT 'Date from which the qualification becomes valid and the employee is authorized to perform associated work activities. May differ from assessment date if approval or administrative processing is required.',
  `equipment_type_authorization` STRING COMMENT 'Specific equipment types or asset classes the employee is qualified to operate, maintain, or repair. Examples include circuit breakers, transformers, turbines, generators, protective relays, or Advanced Metering Infrastructure (AMI) systems.',
  `expiration_date` DATE COMMENT 'Date on which the qualification expires and renewal or reassessment is required. Nullable for qualifications that do not have a defined expiration period. Critical for compliance tracking and crew readiness reporting.',
  `issuing_organization` STRING COMMENT 'Name of the internal department, training center, or organizational unit that awarded this qualification. Examples include Transmission Operations Training Center, Distribution Services Academy, or Generation Training Department.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this qualification record. Used for change tracking, incremental processing, and data quality monitoring.',
  `last_renewal_date` DATE COMMENT 'Date of the most recent renewal or reassessment for this qualification. Used to calculate next renewal due date and track compliance history.',
  `modified_by_user` STRING COMMENT 'User identifier or system account that last modified this qualification record. Supports audit trail requirements and data stewardship accountability.',
  `nerc_cip_relevant_flag` BOOLEAN COMMENT 'Indicates whether this qualification authorizes access to Bulk Electric System (BES) Cyber Systems or other NERC CIP-regulated assets. True triggers additional personnel risk assessment and training requirements per NERC CIP-004.',
  `next_renewal_due_date` DATE COMMENT 'Date by which the employee must complete renewal requirements to maintain active qualification status. Drives workforce planning alerts and training scheduling.',
  `notes` STRING COMMENT 'Free-text field for additional context, special conditions, limitations, or comments related to the qualification. May include assessor observations, accommodation details, or cross-references to related certifications.',
  `osha_safety_sensitive_flag` BOOLEAN COMMENT 'Indicates whether this qualification involves safety-sensitive work activities subject to enhanced OSHA oversight, such as energized electrical work, confined space entry, or high-voltage operations. Triggers additional safety training and medical surveillance requirements.',
  `passing_score_threshold` DECIMAL(5,2) COMMENT 'Minimum score required to successfully achieve the qualification. Captured at time of assessment to preserve historical standards for audit and trend analysis.',
  `prerequisite_qualifications` STRING COMMENT 'Comma-separated list of qualification types or certification codes that were required before the employee could pursue this qualification. Used for career path validation and succession planning.',
  `qualification_name` STRING COMMENT 'Full descriptive name of the qualification as it appears in workforce records and competency documentation.',
  `qualification_number` STRING COMMENT 'Business identifier for the qualification record, used for external reference and tracking in workforce management systems.',
  `qualification_status` STRING COMMENT 'Current lifecycle status of the qualification. Active indicates the employee is currently qualified; expired indicates renewal is required; suspended indicates temporary hold pending review; revoked indicates permanent removal. Valid values: active|expired|suspended|pending_renewal|revoked|in_progress.',
  `qualification_type` STRING COMMENT 'Category of internal qualification awarded to the employee. Represents utility-specific competency assessments distinct from external certifications. Examples include journeyman lineman qualification, substation operator qualification, generation unit operator qualification, and Supervisory Control and Data Acquisition (SCADA) operator authorization. Reference-value candidates: journeyman_lineman|substation_operator|generation_unit_operator|scada_operator|distribution_operator|transmission_operator|relay_technician|metering_technician|apprentice_lineman|control_room_operator|field_service_technician|protection_engineer.',
  `renewal_frequency_months` INT COMMENT 'Number of months between required renewals or reassessments for this qualification. Common values include 12, 24, or 36 months. Null for qualifications that do not require renewal.',
  `renewal_required_flag` BOOLEAN COMMENT 'Indicates whether this qualification requires periodic renewal or reassessment. True for qualifications with defined expiration dates; false for lifetime qualifications such as journeyman status.',
  `revocation_date` DATE COMMENT 'Date on which the qualification was revoked or permanently withdrawn. Populated only for qualifications with status of revoked. Used for compliance investigations and workforce incident analysis.',
  `revocation_reason` STRING COMMENT 'Explanation for why the qualification was revoked, such as safety violation, failed reassessment, disciplinary action, or medical disqualification. Critical for audit trail and regulatory reporting.',
  `source_record_reference` STRING COMMENT 'Unique identifier of this qualification record in the source operational system. Enables traceability back to the system of record for audit and troubleshooting.',
  `source_system` STRING COMMENT 'Name of the operational system from which this qualification record originated. Examples include SAP HCM, Learning Management System (LMS), or legacy training database. Used for data lineage and reconciliation.',
  `training_program_code` STRING COMMENT 'Code identifying the formal training program or apprenticeship that prepared the employee for this qualification. Links to training curriculum and course completion records.',
  `union_classification` STRING COMMENT 'Union job classification or trade designation associated with this qualification, as defined in the collective bargaining agreement. Examples include IBEW Journeyman Lineman, IBEW Substation Electrician, or Operating Engineers classifications.',
  `voltage_class_authorization` STRING COMMENT 'Voltage levels the employee is qualified to work on, expressed in kilovolts (kV). Examples include distribution (up to 35 kV), sub-transmission (35-115 kV), transmission (115-765 kV). Critical for lineman and substation operator qualifications.',
  `work_authorization_scope` STRING COMMENT 'Description of the specific work activities, equipment types, voltage classes, or operational systems the employee is authorized to work on based on this qualification. Critical for safety compliance and work assignment validation.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_employee_qualification` PRIMARY KEY (`employee_qualification_id`)
)
USING DELTA
COMMENT 'Records of employee technical qualifications, trade apprenticeship completions, and utility-specific competency assessments beyond formal certifications — including journeyman lineman qualification, substation operator qualification, generation unit operator qualification, and SCADA operator authorization. Captures qualification type, assessment date, assessor, competency level achieved, and expiration if applicable. Distinct from certifications (which are externally issued); qualifications are internally assessed and awarded. | CMM: CIM ErpCompetency (close), IEC61968::InfERPSupport.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'EmployeeQualification',
  'cmm.cim.class' = 'ErpCompetency',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfERPSupport',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-10',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.employee_qualification'
);

-- WorkforceCrewDispatch  <<CIM FieldDispatchHistory : close>>
CREATE TABLE IF NOT EXISTS `workforce`.`workforce_crew_dispatch` (
  `workforce_crew_dispatch_id` BIGINT NOT NULL COMMENT 'Primary key for workforce_crew_dispatch',
  `crew_dispatch_id` BIGINT COMMENT 'Unique surrogate identifier for each crew dispatch record. Primary key for the association.',
  `crew_id` BIGINT COMMENT 'Foreign key linking to the crew master record. Supports queries like \'show all outages this crew responded to\' and enables crew performance analysis including average response time and restoration effectiveness.',
  `event_id` BIGINT COMMENT 'Foreign key linking to the outage event record for which this crew was dispatched. Supports queries like \'show all crews assigned to this outage\' and enables aggregation of crew resources per event for major storm analysis.',
  `actual_response_time_min` INT COMMENT 'Calculated field: actual response time in minutes from dispatch to arrival (arrival_timestamp - dispatch_timestamp). Used for crew performance benchmarking, OMS dispatch optimization, and regulatory reporting of emergency response effectiveness.',
  `actual_work_duration_min` INT COMMENT 'Calculated field: actual work duration in minutes from work start to completion (work_completed_timestamp - work_start_timestamp). Used for labor cost allocation, crew productivity analysis, and validation of OMS restoration time estimates.',
  `arrival_timestamp` TIMESTAMP COMMENT 'Timestamp when the crew arrived at the outage site, typically recorded via mobile device GPS check-in or crew foreman confirmation. Used to calculate actual response time (arrival - dispatch) for OMS performance metrics and IEEE 1366 reporting.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the crew dispatch record was first created in the OMS or data platform. Supports audit trail and data lineage tracking.',
  `crew_type` STRING COMMENT 'Classification of crew type dispatched to this outage. Captured at dispatch time to support analysis of crew type effectiveness by outage cause and to validate that appropriate crew skills were assigned. Values align with workforce.crew.crew_type enumeration.',
  `dispatch_priority` INT COMMENT 'Numeric priority ranking assigned to this dispatch at time of assignment. Lower numbers indicate higher priority. Determined by outage severity, customer count, critical infrastructure impact, and restoration sequence optimization. Used by OMS to manage crew reassignment during major storm events when new high-priority outages emerge.',
  `dispatch_source` STRING COMMENT 'Source or actor that initiated this crew dispatch. Supports analysis of automated vs. manual dispatch effectiveness and audit trail for crew assignment decisions during major events.',
  `dispatch_status` STRING COMMENT 'Current lifecycle status of the crew dispatch assignment. Transitions tracked in OMS for real-time crew location awareness and restoration progress monitoring. Values: DISPATCHED (crew notified), EN_ROUTE (crew traveling), ON_SITE (crew arrived), WORKING (active restoration), COMPLETED (work finished), CANCELLED (dispatch cancelled before arrival), REASSIGNED (crew redirected to higher priority event).',
  `dispatch_timestamp` TIMESTAMP COMMENT 'Timestamp when the crew was officially dispatched to the outage event by the OMS dispatcher or automated dispatch system. Start of the dispatch lifecycle and baseline for response time calculation.',
  `estimated_travel_time_min` INT COMMENT 'Estimated travel time in minutes from crew location to outage site at time of dispatch. Calculated by OMS using GPS location and routing algorithms. Used to set initial ETR communicated to customers and to optimize crew assignment decisions.',
  `field_crew_notes` STRING COMMENT 'Free-text notes entered by crew foreman or field supervisor documenting site conditions, work performed, materials used, safety incidents, or reasons for delays. Critical for post-storm after-action review, cause validation, and continuous improvement of OMS predictive models.',
  `reassignment_reason` STRING COMMENT 'Free-text explanation if crew was reassigned or dispatch was cancelled before completion. Documents operational decisions during dynamic storm restoration when priorities shift rapidly.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the crew dispatch record. Supports change data capture and real-time OMS dashboard refresh.',
  `vehicle_identifier` STRING COMMENT 'Identifier of the vehicle used by the crew for this dispatch. Captured for GPS tracking integration, equipment utilization analysis, and mutual aid reimbursement documentation. May reference workforce vehicle master or be free-text for contractor/mutual aid vehicles.',
  `work_completed_timestamp` TIMESTAMP COMMENT 'Timestamp when the crew completed their assigned restoration work and cleared the site. Used to calculate crew work duration, support ETR accuracy analysis, and close the dispatch record in OMS.',
  `work_start_timestamp` TIMESTAMP COMMENT 'Timestamp when the crew began active restoration work on the outage. May differ from arrival time due to site assessment, safety briefing, or waiting for switching orders. Used for labor cost allocation and work duration analysis.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_workforce_crew_dispatch` PRIMARY KEY (`workforce_crew_dispatch_id`)
)
USING DELTA
COMMENT 'This association product represents the operational dispatch event linking field crews to outage restoration work. Each record captures a single dispatch assignment of one crew to one outage event, including dispatch timing, arrival, work execution windows, crew status transitions, priority, and field notes. This is the authoritative SSOT for crew deployment history, response time tracking, restoration labor allocation, and post-storm after-action analysis. Crew dispatches are created by OMS dispatchers, updated by field supervisors via mobile devices, and consumed by workforce analytics, FEMA reimbursement reporting, and reliability performance measurement systems.. Existence Justification: Crew dispatch to outage events is a canonical M:N operational relationship in utility outage management. A single major outage event (e.g., transmission line failure, storm damage) routinely requires multiple crews dispatched sequentially or simultaneously for damage assessment, isolation, repair, and restoration. Conversely, a single crew responds to multiple distinct outage events during a shift, storm period, or mutual aid deployment. Each dispatch is an operational business event actively managed by OMS dispatchers with rich lifecycle data including dispatch timing, arrival, work execution windows, status transitions, priority, and field notes. | CMM: CIM FieldDispatchHistory (close), IEC61968::Operations.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'WorkforceCrewDispatch',
  'cmm.cim.class' = 'FieldDispatchHistory',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Operations',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-3',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.workforce_crew_dispatch'
);

-- ProjectAssignment  <<CIM Assignment : close>>
CREATE TABLE IF NOT EXISTS `workforce`.`project_assignment` (
  `project_assignment_id` BIGINT NOT NULL COMMENT 'Unique identifier for this project assignment record. Primary key.',
  `approved_by_employee_id` BIGINT COMMENT 'Employee identifier of the manager or resource planner who approved this project assignment. Foreign key to workforce.employee.employee_id. Used for audit trail and accountability.',
  `capex_project_id` BIGINT COMMENT 'Foreign key linking to the capital expenditure project to which the employee is assigned',
  `employee_id` BIGINT COMMENT 'Foreign key linking to the utility employee assigned to the capital project',
  `actual_hours` DECIMAL(10,2) COMMENT 'Cumulative actual hours the employee has worked on this capital project to date. Updated from timesheet system. Used for labor cost capitalization and variance analysis.',
  `allocation_percentage` DECIMAL(5,2) COMMENT 'Percentage of the employee\'s working time allocated to this capital project. Used for resource planning and labor cost allocation. Sum of allocation_percentage across all active assignments for an employee should not exceed 100%. Example: 30.00 means 30% of employee time.',
  `approval_date` DATE COMMENT 'Date when the project assignment was approved by the responsible manager. Used for audit trail and assignment lifecycle tracking.',
  `approval_status` STRING COMMENT 'Workflow status of the project assignment. Pending: awaiting manager approval. Approved: authorized but not yet started. Active: employee currently working on project. Completed: assignment finished. Cancelled: assignment revoked before completion.',
  `assignment_end_date` DATE COMMENT 'Date when the employee\'s assignment to this capital project ended or is planned to end. Null for ongoing assignments. Used for resource planning and labor cost cutoff.',
  `assignment_notes` STRING COMMENT 'Free-text notes about this project assignment, such as special skills required, shift preferences, or assignment constraints. Used for resource coordination.',
  `assignment_start_date` DATE COMMENT 'Date when the employee began working on this capital project. Used to determine labor cost capitalization period and resource utilization reporting.',
  `estimated_hours` DECIMAL(10,2) COMMENT 'Estimated total hours the employee will work on this capital project over the assignment duration. Used for resource planning and budget forecasting.',
  `labor_rate` DECIMAL(10,2) COMMENT 'Hourly or daily labor rate applied to this employee\'s work on this specific capital project, in USD. May differ from standard employee rate based on project type, funding source, or union agreement. Used for capital cost accumulation and FERC labor cost reporting.',
  `role_on_project` STRING COMMENT 'The specific role or function the employee performs on this capital project. Examples: Project Manager, Lead Engineer, Field Engineer, Technician, Supervisor. Determines responsibility level and labor rate category for cost capitalization.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_project_assignment` PRIMARY KEY (`project_assignment_id`)
)
USING DELTA
COMMENT 'This association product represents the Assignment between employee and capex_project. It captures the allocation of utility personnel to capital expenditure projects with role, time allocation, labor rates, and assignment lifecycle dates. Each record links one employee to one capex_project with attributes that exist only in the context of this specific project assignment. Supports capital cost tracking, labor capitalization, FERC reporting of labor costs by project, and resource planning across the capital portfolio.. Existence Justification: In utility capital project operations, employees are routinely assigned to multiple capital projects simultaneously with different roles and time allocations (e.g., a senior engineer at 30% on substation upgrade, 40% on transmission line replacement, 30% on distribution automation). Conversely, capital projects require cross-functional teams with multiple employees across disciplines (project managers, engineers, technicians, planners, safety officers). The business actively manages these assignments with specific roles, allocation percentages, labor rates, and approval workflows for capital cost tracking and FERC reporting. | CMM: CIM Assignment (close), IEC61968::InfWork.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ProjectAssignment',
  'cmm.cim.class' = 'Assignment',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::InfWork',
  'cmm.cim.standard' = 'IEC 61968-11 / IEC 61968-6',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.project_assignment'
);

-- ScenarioParticipation  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `workforce`.`scenario_participation` (
  `scenario_participation_id` BIGINT NOT NULL COMMENT 'Unique identifier for this employee-scenario participation record. Primary key for the scenario_participation association product.',
  `employee_id` BIGINT COMMENT 'Foreign key linking to the employee who participated in the IRP scenario development, review, or approval process',
  `irp_scenario_id` BIGINT COMMENT 'Foreign key linking to the IRP scenario in which the employee participated',
  `approval_date` DATE COMMENT 'Date the employee granted formal approval for this scenario (for approvers only). Null for contributors/reviewers or if approval is pending. Critical for establishing approval timeline for regulatory filing documentation.',
  `approval_level` STRING COMMENT 'The approval authority level of the employee for this scenario. Contributor indicates working-level participation without approval authority. Reviewer indicates peer review responsibility. Manager/Director/VP/Executive indicate formal approval authority at different organizational levels. Used to establish approval chain for regulatory filings.',
  `approval_status` STRING COMMENT 'Current approval status for employees with approval authority. Pending indicates approval decision not yet made. Approved indicates formal approval granted. Rejected indicates approval withheld. Conditional indicates approval with conditions or caveats. Not Required for contributor-level participants without approval authority.',
  `comments` STRING COMMENT 'Free-text comments or notes about this employee\'s participation, including specific contributions, concerns raised, conditions of approval, or areas of responsibility. Used for internal documentation and preparation for regulatory cross-examination.',
  `contribution_type` STRING COMMENT 'The type of work or analysis the employee contributed to this scenario. Examples include Load Forecasting (demand projections), Resource Modeling (capacity expansion modeling), Economic Analysis (cost-benefit analysis), Technical Review (engineering validation). Used to document the scope of each employee\'s contribution for cross-examination preparation.',
  `hours_contributed` DECIMAL(8,2) COMMENT 'Total hours the employee contributed to this IRP scenario development. Used for project cost tracking, resource allocation analysis, and documenting level of effort for regulatory proceedings. Null if hours are not tracked for this participation type.',
  `participation_end_date` DATE COMMENT 'The date the employee completed their participation in this IRP scenario development. Null if participation is ongoing. Used to track duration of involvement and establish completion of review/approval responsibilities. Important for regulatory documentation showing when approvals were granted.',
  `participation_start_date` DATE COMMENT 'The date the employee began participating in this IRP scenario development. Used to track timeline of scenario development activities and establish when each contributor became involved. Important for regulatory documentation of scenario development process.',
  `role` STRING COMMENT 'The specific role the employee performed in this IRP scenario development. Examples include Lead Analyst (primary scenario developer), Technical Reviewer (peer review of assumptions), Manager Approver (approval authority), Stakeholder Liaison (coordination with external parties). Critical for regulatory documentation showing who was responsible for each aspect of scenario development.',
  `testimony_witness_flag` BOOLEAN COMMENT 'Indicates whether this employee is designated as a potential witness for testimony in PUC proceedings regarding this scenario. True if the employee may be called to testify about scenario assumptions, methodology, or results. Used for witness preparation and regulatory strategy.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_scenario_participation` PRIMARY KEY (`scenario_participation_id`)
)
USING DELTA
COMMENT 'This association product represents the participation relationship between employees and IRP scenarios. It captures the role-based contribution of utility personnel (analysts, engineers, economists, managers) in developing, reviewing, and approving Integrated Resource Plan scenarios. Each record links one employee to one IRP scenario with attributes that document their specific role, contribution type, approval authority, and participation timeline. This data is critical for regulatory documentation, cross-examination preparation in PUC proceedings, and tracking accountability for scenario assumptions and modeling decisions.. Existence Justification: IRP scenario development is a collaborative multi-disciplinary process where multiple employees (analysts, engineers, economists, managers) contribute to each scenario in different roles, and each employee typically works on multiple scenarios within an IRP filing (base case, high growth, low carbon, etc.). The utility must track who participated in each scenario, their specific role and contribution type, approval authority level, and participation timeline for regulatory documentation and cross-examination preparation in PUC proceedings. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ScenarioParticipation',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.scenario_participation'
);

-- WorkLocation  <<CIM WorkLocation : exact>>
CREATE TABLE IF NOT EXISTS `workforce`.`work_location` (
  `work_location_id` BIGINT NOT NULL COMMENT 'Primary key for work_location',
  `parent_work_location_id` BIGINT COMMENT 'Self-referencing FK on work_location (parent_work_location_id)',
  `address_line1` STRING COMMENT 'Primary street address of the work location.',
  `address_line2` STRING COMMENT 'Secondary address information (suite, building, etc.).',
  `area_sqft` DECIMAL(12,2) COMMENT 'Total usable floor area of the location in square feet.',
  `capacity_mw` DECIMAL(8,2) COMMENT 'Maximum electrical generation or transformation capacity at the location, expressed in megawatts.',
  `city` STRING COMMENT 'City where the work location is situated.',
  `cost_center_code` STRING COMMENT 'Internal cost-center identifier used for budgeting and expense allocation.',
  `country` STRING COMMENT 'Three-letter ISO country code of the location.',
  `created_timestamp` TIMESTAMP COMMENT 'Date-time when the work location record was first created in the master data system.',
  `description` STRING COMMENT 'Free-form text describing notable characteristics of the location.',
  `effective_end_date` DATE COMMENT 'Date when the location was decommissioned or ceased to be used (null if still active).',
  `effective_start_date` DATE COMMENT 'Date when the location became operational or was officially recognized.',
  `external_system_reference` STRING COMMENT 'Identifier of the source system record from which this master record was derived.',
  `is_primary` BOOLEAN COMMENT 'Indicates whether this location is the primary site for its associated asset or crew.',
  `is_unionized` BOOLEAN COMMENT 'True if the workforce assigned to this location is covered by a labor union agreement.',
  `last_safety_audit_date` DATE COMMENT 'Date of the most recent safety audit performed at the location.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude in decimal degrees.',
  `location_code` STRING COMMENT 'External code or tag used by operational systems to reference the location.',
  `location_type` STRING COMMENT 'Category of the location indicating its function within the utility network.',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude in decimal degrees.',
  `manager_contact_phone` STRING COMMENT 'Primary contact phone number for the location manager.',
  `manager_name` STRING COMMENT 'Full name of the manager responsible for the work location.',
  `name` STRING COMMENT 'Human-readable name of the work location (e.g., "North Substation").',
  `nerc_cip_compliance` BOOLEAN COMMENT 'Indicates whether the location meets NERC Critical Infrastructure Protection requirements.',
  `osha_compliance` BOOLEAN COMMENT 'True if the location complies with OSHA safety regulations.',
  `postal_code` STRING COMMENT 'Postal/ZIP code for the work location.',
  `region` STRING COMMENT 'Broad region (e.g., Northeast, Southwest) used for reporting.',
  `safety_certification_status` STRING COMMENT 'Current status of safety certifications required for work at this location.',
  `state` STRING COMMENT 'State or province of the work location.',
  `status` STRING COMMENT 'Current operational status of the location.',
  `time_zone` STRING COMMENT 'IANA time-zone identifier for the location (e.g., "America/New_York").',
  `updated_timestamp` TIMESTAMP COMMENT 'Date-time of the most recent modification to the work location record.',
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
  CONSTRAINT `pk_workforce_work_location` PRIMARY KEY (`work_location_id`)
)
USING DELTA
COMMENT 'Master reference table for work_location. Referenced by work_location_id. | CMM: CIM WorkLocation (exact), IEC61968::Work.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'WorkLocation',
  'cmm.cim.class' = 'WorkLocation',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Work',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.work_location',
  'cmm.gis.location.role' = 'Location (is-a; geometry via Location.PositionPoints)'
);

-- UtilityCompany  <<CIM Organisation : close>>
CREATE TABLE IF NOT EXISTS `workforce`.`utility_company` (
  `utility_company_id` BIGINT NOT NULL COMMENT 'Primary key for utility_company',
  `parent_company_id` BIGINT COMMENT 'Identifier of the parent utility company, if this entity is a subsidiary.',
  `parent_utility_company_id` BIGINT COMMENT 'Self-referencing FK on utility_company (parent_utility_company_id)',
  `address_line1` STRING COMMENT 'First line of the utility company\'s primary address.',
  `address_line2` STRING COMMENT 'Second line of the utility company\'s primary address, if applicable.',
  `annual_revenue` DECIMAL(15,2) COMMENT 'Total revenue reported for the most recent fiscal year, in US dollars.',
  `city` STRING COMMENT 'City of the utility company\'s primary location.',
  `classification_or_type` STRING COMMENT 'Regulatory classification indicating the company\'s regulatory environment.',
  `company_type` STRING COMMENT 'Ownership and organizational type of the utility.',
  `country` STRING COMMENT 'Three-letter country code of the utility\'s primary location.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the utility company record was first created.',
  `dba_name` STRING COMMENT 'Alternate trade name under which the utility operates.',
  `effective_date` DATE COMMENT 'Date when the utility company became operational or was officially recognized.',
  `email_address` STRING COMMENT 'General contact email address for the utility.',
  `labor_cost_center_code` STRING COMMENT 'Internal code used to allocate labor costs to this utility.',
  `legal_name` STRING COMMENT 'Full legal name as registered with governmental authorities.',
  `lifecycle_status` STRING COMMENT 'Lifecycle stage of the utility company within its corporate existence.',
  `naics_code` STRING COMMENT 'Industry classification code for the utility company.',
  `name` STRING COMMENT 'Legal operating name of the utility company.',
  `nerc_cip_certified` BOOLEAN COMMENT 'Indicates whether the utility is certified under NERC CIP security standards.',
  `number_of_employees` INT COMMENT 'Total count of full-time equivalent employees.',
  `osha_compliance` BOOLEAN COMMENT 'Indicates compliance with OSHA safety regulations.',
  `phone_number` STRING COMMENT 'Main telephone number for the utility company.',
  `postal_code` STRING COMMENT 'ZIP or postal code for the primary address.',
  `primary_contact_email` STRING COMMENT 'Email address of the primary contact.',
  `primary_contact_name` STRING COMMENT 'Name of the primary business contact for the utility.',
  `primary_contact_phone` STRING COMMENT 'Phone number of the primary contact.',
  `registration_number` STRING COMMENT 'Identifier assigned by the state business registration authority.',
  `regulatory_compliance_status` STRING COMMENT 'Current compliance standing with applicable utility regulations.',
  `service_area_codes` STRING COMMENT 'Comma-separated list of internal codes representing service zones.',
  `service_area_description` STRING COMMENT 'Narrative description of the geographic service territory.',
  `state` STRING COMMENT 'Two-letter state or province code for the primary address.',
  `status` STRING COMMENT 'Current operational status of the utility company.',
  `tax_identifier` STRING COMMENT 'Federal tax identification number for the utility company.',
  `termination_date` DATE COMMENT 'Date when the utility company ceased operations or was dissolved, if applicable.',
  `unionized` BOOLEAN COMMENT 'True if the utility\'s workforce is represented by labor unions.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the utility company record.',
  `website_url` STRING COMMENT 'Public website URL of the utility company.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_utility_company` PRIMARY KEY (`utility_company_id`)
)
USING DELTA
COMMENT 'Master reference table for utility_company. Referenced by requesting_utility_id. | CMM: CIM Organisation (close), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'UtilityCompany',
  'cmm.cim.class' = 'Organisation',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.utility_company'
);

-- MutualAidAgreement  <<CIM Agreement : extension>>
CREATE TABLE IF NOT EXISTS `workforce`.`mutual_aid_agreement` (
  `mutual_aid_agreement_id` BIGINT NOT NULL COMMENT 'Primary key for mutual_aid_agreement',
  `utility_company_id` BIGINT COMMENT 'Identifier of the primary utility or organization participating in the agreement.',
  `superseded_mutual_aid_agreement_id` BIGINT COMMENT 'Self-referencing FK on mutual_aid_agreement (superseded_mutual_aid_agreement_id)',
  `activation_procedure` STRING COMMENT 'Steps and criteria required to activate the mutual aid support.',
  `agreement_name` STRING COMMENT 'Descriptive name of the mutual aid agreement.',
  `agreement_number` STRING COMMENT 'External reference number assigned to the agreement by the utility or regulatory body.',
  `agreement_type` STRING COMMENT 'Category of the agreement indicating the nature of the mutual aid relationship.',
  `compensation_amount` DECIMAL(15,2) COMMENT 'Monetary compensation payable for resources provided under the agreement.',
  `coverage_area` STRING COMMENT 'Description of the service territory or grid area covered by the mutual aid.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the agreement record was first created in the system.',
  `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for compensation amounts.',
  `description` STRING COMMENT 'Free-form textual description of the agreement purpose and scope.',
  `effective_from` DATE COMMENT 'Date on which the agreement becomes binding.',
  `effective_until` DATE COMMENT 'Date on which the agreement expires or is scheduled to terminate; null for open-ended agreements.',
  `insurance_provider` STRING COMMENT 'Name of the insurance carrier providing coverage for the agreement.',
  `insurance_required` BOOLEAN COMMENT 'Indicates whether insurance coverage is mandatory for resources exchanged.',
  `is_active` BOOLEAN COMMENT 'Indicates whether the agreement is currently active and enforceable.',
  `jurisdiction` STRING COMMENT 'Geographic or regulatory jurisdiction governing the agreement.',
  `last_review_date` DATE COMMENT 'Date when the agreement was last reviewed for relevance or compliance.',
  `nerc_cip_compliance` BOOLEAN COMMENT 'Indicates whether the agreement satisfies NERC Critical Infrastructure Protection requirements.',
  `notes` STRING COMMENT 'Additional remarks, exceptions, or operational comments.',
  `notice_period_days` INT COMMENT 'Number of days notice required to invoke or terminate the agreement.',
  `osha_compliance` BOOLEAN COMMENT 'Indicates compliance with Occupational Safety and Health Administration regulations.',
  `renewal_option` STRING COMMENT 'Whether the agreement renews automatically, requires manual renewal, or does not renew.',
  `resource_shared` STRING COMMENT 'Type of resources (e.g., personnel, equipment, crew) that may be exchanged under the agreement.',
  `safety_requirements` STRING COMMENT 'Specific safety standards (e.g., OSHA) that must be met by participating parties.',
  `status` STRING COMMENT 'Current lifecycle state of the agreement.',
  `termination_clause` STRING COMMENT 'Conditions under which the agreement may be terminated by either party.',
  `union_agreement_flag` BOOLEAN COMMENT 'True if the agreement is subject to union labor agreements.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the agreement record.',
  `version_number` INT COMMENT 'Sequential version identifier for the agreement document.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_mutual_aid_agreement` PRIMARY KEY (`mutual_aid_agreement_id`)
)
USING DELTA
COMMENT 'Master reference table for mutual_aid_agreement. Referenced by mutual_aid_agreement_id. | CMM: CIM Agreement (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'MutualAidAgreement',
  'cmm.cim.class' = 'Agreement',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.mutual_aid_agreement'
);

-- ShiftTemplate  <<CIM TimeSchedule : extension>>
CREATE TABLE IF NOT EXISTS `workforce`.`shift_template` (
  `shift_template_id` BIGINT NOT NULL COMMENT 'Primary key for shift_template',
  `base_shift_template_id` BIGINT COMMENT 'Self-referencing FK on shift_template (base_shift_template_id)',
  `applicable_location_code` STRING COMMENT 'Identifier of the geographic or plant location where the template can be used.',
  `applicable_role` STRING COMMENT 'Workforce role(s) for which the shift template is intended.',
  `break_duration_minutes` INT COMMENT 'Total allocated break time within the shift in minutes.',
  `break_policy` STRING COMMENT 'Policy governing how break time is compensated.',
  `code` STRING COMMENT 'External code used to reference the shift template in scheduling systems.',
  `compliance_requirements` STRING COMMENT 'Regulatory or safety constraints (e.g., NERC CIP, OSHA) that apply to this shift pattern.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the shift template record was first created in the system.',
  `description` STRING COMMENT 'Detailed description of the shift template, including purpose and usage notes.',
  `effective_end_date` DATE COMMENT 'Date when the shift template expires; null if open-ended.',
  `effective_start_date` DATE COMMENT 'Date when the shift template becomes valid for scheduling.',
  `holiday_flag` BOOLEAN COMMENT 'True if the template is intended for holiday scheduling.',
  `is_default_template` BOOLEAN COMMENT 'True if this template is the default for its role/location combination.',
  `max_consecutive_shifts` INT COMMENT 'Maximum number of back-to-back shifts an employee may work using this template.',
  `max_employees` INT COMMENT 'Maximum number of employees that can be scheduled on a single shift instance.',
  `min_employees` INT COMMENT 'Minimum staffing requirement for the shift.',
  `min_rest_hours` DECIMAL(4,2) COMMENT 'Minimum required rest period between consecutive shifts, expressed in hours.',
  `name` STRING COMMENT 'Human-readable name of the shift template.',
  `notes` STRING COMMENT 'Free-form notes or special instructions for the shift template.',
  `overtime_allowed` BOOLEAN COMMENT 'Indicates whether overtime may be scheduled under this template.',
  `pay_rate_multiplier` DECIMAL(4,2) COMMENT 'Multiplier applied to the base hourly rate for shifts using this template.',
  `required_certifications` STRING COMMENT 'Comma-separated list of certifications employees must hold to be assigned this shift.',
  `schedule_granularity` STRING COMMENT 'Level of time precision used when assigning this shift (e.g., hourly).',
  `shift_duration_minutes` INT COMMENT 'Total scheduled duration of the shift in minutes, excluding breaks.',
  `shift_pattern_code` STRING COMMENT 'Code referencing a detailed time-segment pattern (e.g., start/end times for each segment).',
  `shift_type` STRING COMMENT 'Category of shift pattern (e.g., regular, flex, on-call, holiday, split).',
  `status` STRING COMMENT 'Current lifecycle state of the shift template.',
  `time_zone` STRING COMMENT 'IANA time-zone identifier for the shift template (e.g., America/New_York).',
  `total_work_hours` DECIMAL(5,2) COMMENT 'Net work hours after subtracting break time, expressed in decimal hours.',
  `union_rule` STRING COMMENT 'Indicates whether the shift template is governed by a union agreement.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the shift template record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_shift_template` PRIMARY KEY (`shift_template_id`)
)
USING DELTA
COMMENT 'Master reference table for shift_template. Referenced by shift_template_id. | CMM: CIM TimeSchedule (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ShiftTemplate',
  'cmm.cim.class' = 'TimeSchedule',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.shift_template'
);

-- PayrollPeriod  <<CIM TimeSchedule : extension>>
CREATE TABLE IF NOT EXISTS `workforce`.`payroll_period` (
  `payroll_period_id` BIGINT NOT NULL COMMENT 'Primary key for payroll_period',
  `previous_payroll_period_id` BIGINT COMMENT 'Self-referencing FK on payroll_period (previous_payroll_period_id)',
  `cost_center_code` STRING COMMENT 'Internal code identifying the cost center associated with the payroll period.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the payroll period record was first created in the system.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code used for monetary amounts in the period.',
  `department_code` STRING COMMENT 'Code of the department to which the payroll period costs are allocated.',
  `description` STRING COMMENT 'Free-form text describing the payroll period.',
  `exchange_rate` DECIMAL(12,6) COMMENT 'Conversion rate from the period\'s currency to the company\'s base reporting currency.',
  `fiscal_quarter` INT COMMENT 'Quarter (1-4) of the fiscal year for the payroll period.',
  `fiscal_year` INT COMMENT 'Four-digit fiscal year to which the payroll period belongs.',
  `is_bonus_period` BOOLEAN COMMENT 'Flag indicating whether the period includes bonus compensation.',
  `is_overtime_applicable` BOOLEAN COMMENT 'True if overtime earnings are calculated for this period.',
  `is_taxable` BOOLEAN COMMENT 'True if the payroll period includes taxable compensation.',
  `is_unionized` BOOLEAN COMMENT 'True if the employees in this period are covered by a union agreement.',
  `lock_date` DATE COMMENT 'Date after which the payroll period is locked for changes.',
  `notes` STRING COMMENT 'Additional free-form remarks or comments about the payroll period.',
  `pay_frequency` STRING COMMENT 'Frequency at which employees are paid for this period.',
  `payroll_cycle_code` STRING COMMENT 'Internal code representing the payroll cycle to which this period belongs.',
  `payroll_group_code` STRING COMMENT 'Identifier for the payroll group (e.g., hourly, salaried) applicable to the period.',
  `payroll_run_date` DATE COMMENT 'Date on which the payroll for the period was processed.',
  `period_end_date` DATE COMMENT 'Last calendar date of the payroll period.',
  `period_name` STRING COMMENT 'Human-readable name or label for the payroll period (e.g., "2023-07 Biweekly 1").',
  `period_number` INT COMMENT 'Sequential number of the period within the fiscal year.',
  `period_start_date` DATE COMMENT 'First calendar date of the payroll period.',
  `period_type` STRING COMMENT 'Classification of the period based on its length or schedule.',
  `status` STRING COMMENT 'Current lifecycle status of the payroll period.',
  `total_benefits` DECIMAL(15,2) COMMENT 'Total cost of employee benefits (e.g., health, retirement) for the period.',
  `total_employee_count` INT COMMENT 'Number of distinct employees included in the payroll period.',
  `total_gross_pay` DECIMAL(15,2) COMMENT 'Sum of gross earnings (pre-deductions) for the period.',
  `total_hours_worked` DECIMAL(10,2) COMMENT 'Aggregate number of hours worked by all employees in the period.',
  `total_net_pay` DECIMAL(15,2) COMMENT 'Sum of net earnings (post-deductions) paid to employees for the period.',
  `total_tax_withheld` DECIMAL(15,2) COMMENT 'Aggregate amount of tax withheld from employee pay in the period.',
  `updated_by` STRING COMMENT 'User identifier of the person who last updated the payroll period record.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the payroll period record.',
  `created_by` STRING COMMENT 'User identifier of the person who created the payroll period record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_payroll_period` PRIMARY KEY (`payroll_period_id`)
)
USING DELTA
COMMENT 'Master reference table for payroll_period. Referenced by payroll_period_id. | CMM: CIM TimeSchedule (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PayrollPeriod',
  'cmm.cim.class' = 'TimeSchedule',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.payroll_period'
);

-- PayrollRun  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `workforce`.`payroll_run` (
  `payroll_run_id` BIGINT NOT NULL COMMENT 'Primary key for payroll_run',
  `audit_user_employee_id` BIGINT COMMENT 'Identifier of the system user who performed the most recent audit action on the record.',
  `employee_id` BIGINT COMMENT 'Identifier of the employee who approved the payroll run.',
  `last_run_id` BIGINT COMMENT 'Reference to the immediately preceding payroll run, if any.',
  `org_unit_id` BIGINT COMMENT 'Identifier of the internal department responsible for executing the payroll run.',
  `reversal_payroll_run_id` BIGINT COMMENT 'Self-referencing FK on payroll_run (reversal_payroll_run_id)',
  `approval_status` STRING COMMENT 'Approval workflow status of the payroll run.',
  `batch_number` STRING COMMENT 'Identifier used by external systems or batch processing frameworks to group related payroll runs.',
  `benefit_contributions_amount` DECIMAL(15,2) COMMENT 'Aggregate employer contributions to employee benefit plans for the run.',
  `comments` STRING COMMENT 'Free-form notes or remarks entered by payroll staff.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the payroll run record was first created in the system.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 code representing the currency of the payroll amounts.',
  `effective_date` DATE COMMENT 'Date on which retroactive adjustments become effective for reporting and tax purposes.',
  `employee_count` INT COMMENT 'Count of distinct employees included in this payroll run.',
  `error_code` STRING COMMENT 'Standardized error code returned when the payroll run fails.',
  `error_message` STRING COMMENT 'Descriptive message associated with the error code.',
  `is_manual` BOOLEAN COMMENT 'Flag indicating whether the payroll run was executed manually (true) or automatically (false).',
  `is_retroactive` BOOLEAN COMMENT 'Indicates whether the run includes retroactive adjustments (true) or not (false).',
  `payroll_cycle` STRING COMMENT 'Frequency with which payroll is processed for the organization.',
  `payroll_version` STRING COMMENT 'Version identifier of the payroll processing logic or software used.',
  `pension_contributions_amount` DECIMAL(15,2) COMMENT 'Total employer pension contributions for the payroll period.',
  `period_end_date` DATE COMMENT 'Last day of the pay period covered by this run.',
  `period_start_date` DATE COMMENT 'First day of the pay period covered by this run.',
  `processing_time_seconds` INT COMMENT 'Total elapsed time, in seconds, to compute and finalize the payroll run.',
  `run_date` DATE COMMENT 'Date on which the payroll processing was executed.',
  `run_number` STRING COMMENT 'Human-readable business identifier for the payroll run, often used in reports and communications.',
  `run_type` STRING COMMENT 'Category of payroll processing (e.g., regular payroll, supplemental, bonus, termination, or adjustment).',
  `source_system` STRING COMMENT 'Originating HR/Payroll system that supplied the data for this run.',
  `status` STRING COMMENT 'Current lifecycle status of the payroll run.',
  `tax_period` STRING COMMENT 'Quarterly tax reporting period for the payroll run.',
  `tax_withheld_amount` DECIMAL(15,2) COMMENT 'Total federal, state, and local taxes withheld from employee pay.',
  `tax_year` INT COMMENT 'Fiscal year to which the payroll taxes apply.',
  `total_deductions_amount` DECIMAL(15,2) COMMENT 'Aggregate amount of all payroll deductions (taxes, benefits, garnishments) for the run.',
  `total_gross_amount` DECIMAL(15,2) COMMENT 'Sum of all gross earnings before deductions for the payroll run.',
  `total_hours_worked` DECIMAL(10,2) COMMENT 'Cumulative regular hours worked by all employees for the period.',
  `total_net_amount` DECIMAL(15,2) COMMENT 'Net amount payable to employees after all deductions.',
  `total_overtime_hours` DECIMAL(10,2) COMMENT 'Cumulative overtime hours worked by all employees for the period.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the payroll run record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_workforce_payroll_run` PRIMARY KEY (`payroll_run_id`)
)
USING DELTA
COMMENT 'Master reference table for payroll_run. Referenced by payroll_run_id. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PayrollRun',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.workforce.payroll_run'
);

-- ========= FOREIGN KEYS within workforce (88) =========
ALTER TABLE `workforce`.`employee` DROP CONSTRAINT IF EXISTS `fk_workforce_employee_supervisor_employee_id`;
ALTER TABLE `workforce`.`employee` ADD CONSTRAINT `fk_workforce_employee_supervisor_employee_id` FOREIGN KEY (`supervisor_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`employee` DROP CONSTRAINT IF EXISTS `fk_workforce_employee_workforce_position_id`;
ALTER TABLE `workforce`.`employee` ADD CONSTRAINT `fk_workforce_employee_workforce_position_id` FOREIGN KEY (`workforce_position_id`) REFERENCES `workforce`.`workforce_position` (`workforce_position_id`);

ALTER TABLE `workforce`.`workforce_position` DROP CONSTRAINT IF EXISTS `fk_workforce_workforce_position_org_unit_id`;
ALTER TABLE `workforce`.`workforce_position` ADD CONSTRAINT `fk_workforce_workforce_position_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `workforce`.`org_unit` (`org_unit_id`);

ALTER TABLE `workforce`.`workforce_position` DROP CONSTRAINT IF EXISTS `fk_workforce_workforce_position_workforce_org_unit_id`;
ALTER TABLE `workforce`.`workforce_position` ADD CONSTRAINT `fk_workforce_workforce_position_workforce_org_unit_id` FOREIGN KEY (`workforce_org_unit_id`) REFERENCES `workforce`.`org_unit` (`org_unit_id`);

ALTER TABLE `workforce`.`org_unit` DROP CONSTRAINT IF EXISTS `fk_workforce_org_unit_parent_org_unit_id`;
ALTER TABLE `workforce`.`org_unit` ADD CONSTRAINT `fk_workforce_org_unit_parent_org_unit_id` FOREIGN KEY (`parent_org_unit_id`) REFERENCES `workforce`.`org_unit` (`org_unit_id`);

ALTER TABLE `workforce`.`crew` DROP CONSTRAINT IF EXISTS `fk_workforce_crew_crew_employee_id`;
ALTER TABLE `workforce`.`crew` ADD CONSTRAINT `fk_workforce_crew_crew_employee_id` FOREIGN KEY (`crew_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`crew` DROP CONSTRAINT IF EXISTS `fk_workforce_crew_crew_lead_employee_id`;
ALTER TABLE `workforce`.`crew` ADD CONSTRAINT `fk_workforce_crew_crew_lead_employee_id` FOREIGN KEY (`crew_lead_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`crew` DROP CONSTRAINT IF EXISTS `fk_workforce_crew_crew_org_unit_id`;
ALTER TABLE `workforce`.`crew` ADD CONSTRAINT `fk_workforce_crew_crew_org_unit_id` FOREIGN KEY (`crew_org_unit_id`) REFERENCES `workforce`.`org_unit` (`org_unit_id`);

ALTER TABLE `workforce`.`crew` DROP CONSTRAINT IF EXISTS `fk_workforce_crew_org_unit_id`;
ALTER TABLE `workforce`.`crew` ADD CONSTRAINT `fk_workforce_crew_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `workforce`.`org_unit` (`org_unit_id`);

ALTER TABLE `workforce`.`crew_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_crew_assignment_crew_employee_id`;
ALTER TABLE `workforce`.`crew_assignment` ADD CONSTRAINT `fk_workforce_crew_assignment_crew_employee_id` FOREIGN KEY (`crew_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`crew_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_crew_assignment_employee_id`;
ALTER TABLE `workforce`.`crew_assignment` ADD CONSTRAINT `fk_workforce_crew_assignment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`crew_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_crew_assignment_primary_crew_employee_id`;
ALTER TABLE `workforce`.`crew_assignment` ADD CONSTRAINT `fk_workforce_crew_assignment_primary_crew_employee_id` FOREIGN KEY (`primary_crew_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`crew_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_crew_assignment_primary_crew_id`;
ALTER TABLE `workforce`.`crew_assignment` ADD CONSTRAINT `fk_workforce_crew_assignment_primary_crew_id` FOREIGN KEY (`primary_crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `workforce`.`crew_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_crew_assignment_work_location_id`;
ALTER TABLE `workforce`.`crew_assignment` ADD CONSTRAINT `fk_workforce_crew_assignment_work_location_id` FOREIGN KEY (`work_location_id`) REFERENCES `workforce`.`work_location` (`work_location_id`);

ALTER TABLE `workforce`.`employee_certification` DROP CONSTRAINT IF EXISTS `fk_workforce_employee_certification_certification_id`;
ALTER TABLE `workforce`.`employee_certification` ADD CONSTRAINT `fk_workforce_employee_certification_certification_id` FOREIGN KEY (`certification_id`) REFERENCES `workforce`.`certification` (`certification_id`);

ALTER TABLE `workforce`.`employee_certification` DROP CONSTRAINT IF EXISTS `fk_workforce_employee_certification_primary_employee_id`;
ALTER TABLE `workforce`.`employee_certification` ADD CONSTRAINT `fk_workforce_employee_certification_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`employee_certification` DROP CONSTRAINT IF EXISTS `fk_workforce_employee_certification_tertiary_employee_id`;
ALTER TABLE `workforce`.`employee_certification` ADD CONSTRAINT `fk_workforce_employee_certification_tertiary_employee_id` FOREIGN KEY (`tertiary_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`safety_incident` DROP CONSTRAINT IF EXISTS `fk_workforce_safety_incident_primary_safety_employee_id`;
ALTER TABLE `workforce`.`safety_incident` ADD CONSTRAINT `fk_workforce_safety_incident_primary_safety_employee_id` FOREIGN KEY (`primary_safety_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`safety_incident` DROP CONSTRAINT IF EXISTS `fk_workforce_safety_incident_quaternary_safety_modified_by_employee_id`;
ALTER TABLE `workforce`.`safety_incident` ADD CONSTRAINT `fk_workforce_safety_incident_quaternary_safety_modified_by_employee_id` FOREIGN KEY (`quaternary_safety_modified_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`safety_incident` DROP CONSTRAINT IF EXISTS `fk_workforce_safety_incident_safety_employee_id`;
ALTER TABLE `workforce`.`safety_incident` ADD CONSTRAINT `fk_workforce_safety_incident_safety_employee_id` FOREIGN KEY (`safety_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`safety_incident` DROP CONSTRAINT IF EXISTS `fk_workforce_safety_incident_tertiary_safety_reported_by_employee_id`;
ALTER TABLE `workforce`.`safety_incident` ADD CONSTRAINT `fk_workforce_safety_incident_tertiary_safety_reported_by_employee_id` FOREIGN KEY (`tertiary_safety_reported_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`safety_training` DROP CONSTRAINT IF EXISTS `fk_workforce_safety_training_primary_safety_employee_id`;
ALTER TABLE `workforce`.`safety_training` ADD CONSTRAINT `fk_workforce_safety_training_primary_safety_employee_id` FOREIGN KEY (`primary_safety_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`union_agreement` DROP CONSTRAINT IF EXISTS `fk_workforce_union_agreement_primary_successor_agreement_union_agreement_id`;
ALTER TABLE `workforce`.`union_agreement` ADD CONSTRAINT `fk_workforce_union_agreement_primary_successor_agreement_union_agreement_id` FOREIGN KEY (`primary_successor_agreement_union_agreement_id`) REFERENCES `workforce`.`union_agreement` (`union_agreement_id`);

ALTER TABLE `workforce`.`work_schedule` DROP CONSTRAINT IF EXISTS `fk_workforce_work_schedule_union_agreement_id`;
ALTER TABLE `workforce`.`work_schedule` ADD CONSTRAINT `fk_workforce_work_schedule_union_agreement_id` FOREIGN KEY (`union_agreement_id`) REFERENCES `workforce`.`union_agreement` (`union_agreement_id`);

ALTER TABLE `workforce`.`shift_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_shift_assignment_alt5_shift_last_modified_by_user_employee_id`;
ALTER TABLE `workforce`.`shift_assignment` ADD CONSTRAINT `fk_workforce_shift_assignment_alt5_shift_last_modified_by_user_employee_id` FOREIGN KEY (`alt5_shift_last_modified_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`shift_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_shift_assignment_crew_id`;
ALTER TABLE `workforce`.`shift_assignment` ADD CONSTRAINT `fk_workforce_shift_assignment_crew_id` FOREIGN KEY (`crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `workforce`.`shift_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_shift_assignment_primary_shift_swap_original_employee_id`;
ALTER TABLE `workforce`.`shift_assignment` ADD CONSTRAINT `fk_workforce_shift_assignment_primary_shift_swap_original_employee_id` FOREIGN KEY (`primary_shift_swap_original_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`shift_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_shift_assignment_primary_work_schedule_id`;
ALTER TABLE `workforce`.`shift_assignment` ADD CONSTRAINT `fk_workforce_shift_assignment_primary_work_schedule_id` FOREIGN KEY (`primary_work_schedule_id`) REFERENCES `workforce`.`work_schedule` (`work_schedule_id`);

ALTER TABLE `workforce`.`shift_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_shift_assignment_quaternary_shift_scheduled_by_user_employee_id`;
ALTER TABLE `workforce`.`shift_assignment` ADD CONSTRAINT `fk_workforce_shift_assignment_quaternary_shift_scheduled_by_user_employee_id` FOREIGN KEY (`quaternary_shift_scheduled_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`shift_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_shift_assignment_quinary_shift_cancelled_by_user_employee_id`;
ALTER TABLE `workforce`.`shift_assignment` ADD CONSTRAINT `fk_workforce_shift_assignment_quinary_shift_cancelled_by_user_employee_id` FOREIGN KEY (`quinary_shift_cancelled_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`shift_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_shift_assignment_shift_employee_id`;
ALTER TABLE `workforce`.`shift_assignment` ADD CONSTRAINT `fk_workforce_shift_assignment_shift_employee_id` FOREIGN KEY (`shift_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`shift_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_shift_assignment_shift_template_id`;
ALTER TABLE `workforce`.`shift_assignment` ADD CONSTRAINT `fk_workforce_shift_assignment_shift_template_id` FOREIGN KEY (`shift_template_id`) REFERENCES `workforce`.`shift_template` (`shift_template_id`);

ALTER TABLE `workforce`.`shift_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_shift_assignment_shift_work_schedule_id`;
ALTER TABLE `workforce`.`shift_assignment` ADD CONSTRAINT `fk_workforce_shift_assignment_shift_work_schedule_id` FOREIGN KEY (`shift_work_schedule_id`) REFERENCES `workforce`.`work_schedule` (`work_schedule_id`);

ALTER TABLE `workforce`.`shift_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_shift_assignment_tertiary_shift_supervisor_employee_id`;
ALTER TABLE `workforce`.`shift_assignment` ADD CONSTRAINT `fk_workforce_shift_assignment_tertiary_shift_supervisor_employee_id` FOREIGN KEY (`tertiary_shift_supervisor_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`time_entry` DROP CONSTRAINT IF EXISTS `fk_workforce_time_entry_contractor_worker_id`;
ALTER TABLE `workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_contractor_worker_id` FOREIGN KEY (`contractor_worker_id`) REFERENCES `workforce`.`contractor_worker` (`contractor_worker_id`);

ALTER TABLE `workforce`.`time_entry` DROP CONSTRAINT IF EXISTS `fk_workforce_time_entry_crew_id`;
ALTER TABLE `workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_crew_id` FOREIGN KEY (`crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `workforce`.`time_entry` DROP CONSTRAINT IF EXISTS `fk_workforce_time_entry_employee_id`;
ALTER TABLE `workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`time_entry` DROP CONSTRAINT IF EXISTS `fk_workforce_time_entry_payroll_period_id`;
ALTER TABLE `workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_payroll_period_id` FOREIGN KEY (`payroll_period_id`) REFERENCES `workforce`.`payroll_period` (`payroll_period_id`);

ALTER TABLE `workforce`.`time_entry` DROP CONSTRAINT IF EXISTS `fk_workforce_time_entry_payroll_run_id`;
ALTER TABLE `workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_payroll_run_id` FOREIGN KEY (`payroll_run_id`) REFERENCES `workforce`.`payroll_run` (`payroll_run_id`);

ALTER TABLE `workforce`.`time_entry` DROP CONSTRAINT IF EXISTS `fk_workforce_time_entry_primary_time_employee_id`;
ALTER TABLE `workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_primary_time_employee_id` FOREIGN KEY (`primary_time_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`time_entry` DROP CONSTRAINT IF EXISTS `fk_workforce_time_entry_tertiary_time_modified_by_user_employee_id`;
ALTER TABLE `workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_tertiary_time_modified_by_user_employee_id` FOREIGN KEY (`tertiary_time_modified_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`time_entry` DROP CONSTRAINT IF EXISTS `fk_workforce_time_entry_time_employee_id`;
ALTER TABLE `workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_time_employee_id` FOREIGN KEY (`time_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`leave_request` DROP CONSTRAINT IF EXISTS `fk_workforce_leave_request_leave_employee_id`;
ALTER TABLE `workforce`.`leave_request` ADD CONSTRAINT `fk_workforce_leave_request_leave_employee_id` FOREIGN KEY (`leave_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`leave_request` DROP CONSTRAINT IF EXISTS `fk_workforce_leave_request_primary_leave_employee_id`;
ALTER TABLE `workforce`.`leave_request` ADD CONSTRAINT `fk_workforce_leave_request_primary_leave_employee_id` FOREIGN KEY (`primary_leave_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`leave_request` DROP CONSTRAINT IF EXISTS `fk_workforce_leave_request_tertiary_leave_coverage_employee_id`;
ALTER TABLE `workforce`.`leave_request` ADD CONSTRAINT `fk_workforce_leave_request_tertiary_leave_coverage_employee_id` FOREIGN KEY (`tertiary_leave_coverage_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`leave_request` DROP CONSTRAINT IF EXISTS `fk_workforce_leave_request_work_schedule_id`;
ALTER TABLE `workforce`.`leave_request` ADD CONSTRAINT `fk_workforce_leave_request_work_schedule_id` FOREIGN KEY (`work_schedule_id`) REFERENCES `workforce`.`work_schedule` (`work_schedule_id`);

ALTER TABLE `workforce`.`contractor_worker` DROP CONSTRAINT IF EXISTS `fk_workforce_contractor_worker_contractor_crew_id`;
ALTER TABLE `workforce`.`contractor_worker` ADD CONSTRAINT `fk_workforce_contractor_worker_contractor_crew_id` FOREIGN KEY (`contractor_crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `workforce`.`contractor_worker` DROP CONSTRAINT IF EXISTS `fk_workforce_contractor_worker_nerc_cip_access_id`;
ALTER TABLE `workforce`.`contractor_worker` ADD CONSTRAINT `fk_workforce_contractor_worker_nerc_cip_access_id` FOREIGN KEY (`nerc_cip_access_id`) REFERENCES `workforce`.`nerc_cip_access` (`nerc_cip_access_id`);

ALTER TABLE `workforce`.`contractor_worker` DROP CONSTRAINT IF EXISTS `fk_workforce_contractor_worker_primary_crew_id`;
ALTER TABLE `workforce`.`contractor_worker` ADD CONSTRAINT `fk_workforce_contractor_worker_primary_crew_id` FOREIGN KEY (`primary_crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `workforce`.`contractor_worker` DROP CONSTRAINT IF EXISTS `fk_workforce_contractor_worker_supervisor_employee_id`;
ALTER TABLE `workforce`.`contractor_worker` ADD CONSTRAINT `fk_workforce_contractor_worker_supervisor_employee_id` FOREIGN KEY (`supervisor_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`labor_cost_allocation` DROP CONSTRAINT IF EXISTS `fk_workforce_labor_cost_allocation_contractor_worker_id`;
ALTER TABLE `workforce`.`labor_cost_allocation` ADD CONSTRAINT `fk_workforce_labor_cost_allocation_contractor_worker_id` FOREIGN KEY (`contractor_worker_id`) REFERENCES `workforce`.`contractor_worker` (`contractor_worker_id`);

ALTER TABLE `workforce`.`labor_cost_allocation` DROP CONSTRAINT IF EXISTS `fk_workforce_labor_cost_allocation_crew_id`;
ALTER TABLE `workforce`.`labor_cost_allocation` ADD CONSTRAINT `fk_workforce_labor_cost_allocation_crew_id` FOREIGN KEY (`crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `workforce`.`labor_cost_allocation` DROP CONSTRAINT IF EXISTS `fk_workforce_labor_cost_allocation_employee_id`;
ALTER TABLE `workforce`.`labor_cost_allocation` ADD CONSTRAINT `fk_workforce_labor_cost_allocation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`nerc_cip_access` DROP CONSTRAINT IF EXISTS `fk_workforce_nerc_cip_access_nerc_employee_id`;
ALTER TABLE `workforce`.`nerc_cip_access` ADD CONSTRAINT `fk_workforce_nerc_cip_access_nerc_employee_id` FOREIGN KEY (`nerc_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`nerc_cip_access` DROP CONSTRAINT IF EXISTS `fk_workforce_nerc_cip_access_primary_nerc_employee_id`;
ALTER TABLE `workforce`.`nerc_cip_access` ADD CONSTRAINT `fk_workforce_nerc_cip_access_primary_nerc_employee_id` FOREIGN KEY (`primary_nerc_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`nerc_cip_access` DROP CONSTRAINT IF EXISTS `fk_workforce_nerc_cip_access_tertiary_nerc_modified_by_user_employee_id`;
ALTER TABLE `workforce`.`nerc_cip_access` ADD CONSTRAINT `fk_workforce_nerc_cip_access_tertiary_nerc_modified_by_user_employee_id` FOREIGN KEY (`tertiary_nerc_modified_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`grievance` DROP CONSTRAINT IF EXISTS `fk_workforce_grievance_grievance_employee_id`;
ALTER TABLE `workforce`.`grievance` ADD CONSTRAINT `fk_workforce_grievance_grievance_employee_id` FOREIGN KEY (`grievance_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`grievance` DROP CONSTRAINT IF EXISTS `fk_workforce_grievance_grievance_grievant_employee_id`;
ALTER TABLE `workforce`.`grievance` ADD CONSTRAINT `fk_workforce_grievance_grievance_grievant_employee_id` FOREIGN KEY (`grievance_grievant_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`grievance` DROP CONSTRAINT IF EXISTS `fk_workforce_grievance_grievance_labor_relations_specialist_employee_id`;
ALTER TABLE `workforce`.`grievance` ADD CONSTRAINT `fk_workforce_grievance_grievance_labor_relations_specialist_employee_id` FOREIGN KEY (`grievance_labor_relations_specialist_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`grievance` DROP CONSTRAINT IF EXISTS `fk_workforce_grievance_grievance_management_respondent_employee_id`;
ALTER TABLE `workforce`.`grievance` ADD CONSTRAINT `fk_workforce_grievance_grievance_management_respondent_employee_id` FOREIGN KEY (`grievance_management_respondent_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`grievance` DROP CONSTRAINT IF EXISTS `fk_workforce_grievance_union_agreement_id`;
ALTER TABLE `workforce`.`grievance` ADD CONSTRAINT `fk_workforce_grievance_union_agreement_id` FOREIGN KEY (`union_agreement_id`) REFERENCES `workforce`.`union_agreement` (`union_agreement_id`);

ALTER TABLE `workforce`.`job_requisition` DROP CONSTRAINT IF EXISTS `fk_workforce_job_requisition_job_org_unit_id`;
ALTER TABLE `workforce`.`job_requisition` ADD CONSTRAINT `fk_workforce_job_requisition_job_org_unit_id` FOREIGN KEY (`job_org_unit_id`) REFERENCES `workforce`.`org_unit` (`org_unit_id`);

ALTER TABLE `workforce`.`job_requisition` DROP CONSTRAINT IF EXISTS `fk_workforce_job_requisition_org_unit_id`;
ALTER TABLE `workforce`.`job_requisition` ADD CONSTRAINT `fk_workforce_job_requisition_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `workforce`.`org_unit` (`org_unit_id`);

ALTER TABLE `workforce`.`job_requisition` DROP CONSTRAINT IF EXISTS `fk_workforce_job_requisition_primary_job_employee_id`;
ALTER TABLE `workforce`.`job_requisition` ADD CONSTRAINT `fk_workforce_job_requisition_primary_job_employee_id` FOREIGN KEY (`primary_job_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`job_requisition` DROP CONSTRAINT IF EXISTS `fk_workforce_job_requisition_workforce_position_id`;
ALTER TABLE `workforce`.`job_requisition` ADD CONSTRAINT `fk_workforce_job_requisition_workforce_position_id` FOREIGN KEY (`workforce_position_id`) REFERENCES `workforce`.`workforce_position` (`workforce_position_id`);

ALTER TABLE `workforce`.`mutual_aid_deployment` DROP CONSTRAINT IF EXISTS `fk_workforce_mutual_aid_deployment_crew_id`;
ALTER TABLE `workforce`.`mutual_aid_deployment` ADD CONSTRAINT `fk_workforce_mutual_aid_deployment_crew_id` FOREIGN KEY (`crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `workforce`.`mutual_aid_deployment` DROP CONSTRAINT IF EXISTS `fk_workforce_mutual_aid_deployment_deployment_coordinator_employee_id`;
ALTER TABLE `workforce`.`mutual_aid_deployment` ADD CONSTRAINT `fk_workforce_mutual_aid_deployment_deployment_coordinator_employee_id` FOREIGN KEY (`deployment_coordinator_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`mutual_aid_deployment` DROP CONSTRAINT IF EXISTS `fk_workforce_mutual_aid_deployment_mutual_aid_agreement_id`;
ALTER TABLE `workforce`.`mutual_aid_deployment` ADD CONSTRAINT `fk_workforce_mutual_aid_deployment_mutual_aid_agreement_id` FOREIGN KEY (`mutual_aid_agreement_id`) REFERENCES `workforce`.`mutual_aid_agreement` (`mutual_aid_agreement_id`);

ALTER TABLE `workforce`.`mutual_aid_deployment` DROP CONSTRAINT IF EXISTS `fk_workforce_mutual_aid_deployment_requesting_utility_id`;
ALTER TABLE `workforce`.`mutual_aid_deployment` ADD CONSTRAINT `fk_workforce_mutual_aid_deployment_requesting_utility_id` FOREIGN KEY (`requesting_utility_id`) REFERENCES `workforce`.`utility_company` (`utility_company_id`);

ALTER TABLE `workforce`.`drug_alcohol_test` DROP CONSTRAINT IF EXISTS `fk_workforce_drug_alcohol_test_primary_drug_employee_id`;
ALTER TABLE `workforce`.`drug_alcohol_test` ADD CONSTRAINT `fk_workforce_drug_alcohol_test_primary_drug_employee_id` FOREIGN KEY (`primary_drug_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`drug_alcohol_test` DROP CONSTRAINT IF EXISTS `fk_workforce_drug_alcohol_test_safety_incident_id`;
ALTER TABLE `workforce`.`drug_alcohol_test` ADD CONSTRAINT `fk_workforce_drug_alcohol_test_safety_incident_id` FOREIGN KEY (`safety_incident_id`) REFERENCES `workforce`.`safety_incident` (`safety_incident_id`);

ALTER TABLE `workforce`.`employee_qualification` DROP CONSTRAINT IF EXISTS `fk_workforce_employee_qualification_primary_employee_id`;
ALTER TABLE `workforce`.`employee_qualification` ADD CONSTRAINT `fk_workforce_employee_qualification_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`workforce_crew_dispatch` DROP CONSTRAINT IF EXISTS `fk_workforce_workforce_crew_dispatch_crew_id`;
ALTER TABLE `workforce`.`workforce_crew_dispatch` ADD CONSTRAINT `fk_workforce_workforce_crew_dispatch_crew_id` FOREIGN KEY (`crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `workforce`.`project_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_project_assignment_approved_by_employee_id`;
ALTER TABLE `workforce`.`project_assignment` ADD CONSTRAINT `fk_workforce_project_assignment_approved_by_employee_id` FOREIGN KEY (`approved_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`project_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_project_assignment_employee_id`;
ALTER TABLE `workforce`.`project_assignment` ADD CONSTRAINT `fk_workforce_project_assignment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`scenario_participation` DROP CONSTRAINT IF EXISTS `fk_workforce_scenario_participation_employee_id`;
ALTER TABLE `workforce`.`scenario_participation` ADD CONSTRAINT `fk_workforce_scenario_participation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`work_location` DROP CONSTRAINT IF EXISTS `fk_workforce_work_location_parent_work_location_id`;
ALTER TABLE `workforce`.`work_location` ADD CONSTRAINT `fk_workforce_work_location_parent_work_location_id` FOREIGN KEY (`parent_work_location_id`) REFERENCES `workforce`.`work_location` (`work_location_id`);

ALTER TABLE `workforce`.`utility_company` DROP CONSTRAINT IF EXISTS `fk_workforce_utility_company_parent_company_id`;
ALTER TABLE `workforce`.`utility_company` ADD CONSTRAINT `fk_workforce_utility_company_parent_company_id` FOREIGN KEY (`parent_company_id`) REFERENCES `workforce`.`utility_company` (`utility_company_id`);

ALTER TABLE `workforce`.`utility_company` DROP CONSTRAINT IF EXISTS `fk_workforce_utility_company_parent_utility_company_id`;
ALTER TABLE `workforce`.`utility_company` ADD CONSTRAINT `fk_workforce_utility_company_parent_utility_company_id` FOREIGN KEY (`parent_utility_company_id`) REFERENCES `workforce`.`utility_company` (`utility_company_id`);

ALTER TABLE `workforce`.`mutual_aid_agreement` DROP CONSTRAINT IF EXISTS `fk_workforce_mutual_aid_agreement_utility_company_id`;
ALTER TABLE `workforce`.`mutual_aid_agreement` ADD CONSTRAINT `fk_workforce_mutual_aid_agreement_utility_company_id` FOREIGN KEY (`utility_company_id`) REFERENCES `workforce`.`utility_company` (`utility_company_id`);

ALTER TABLE `workforce`.`mutual_aid_agreement` DROP CONSTRAINT IF EXISTS `fk_workforce_mutual_aid_agreement_superseded_mutual_aid_agreement_id`;
ALTER TABLE `workforce`.`mutual_aid_agreement` ADD CONSTRAINT `fk_workforce_mutual_aid_agreement_superseded_mutual_aid_agreement_id` FOREIGN KEY (`superseded_mutual_aid_agreement_id`) REFERENCES `workforce`.`mutual_aid_agreement` (`mutual_aid_agreement_id`);

ALTER TABLE `workforce`.`shift_template` DROP CONSTRAINT IF EXISTS `fk_workforce_shift_template_base_shift_template_id`;
ALTER TABLE `workforce`.`shift_template` ADD CONSTRAINT `fk_workforce_shift_template_base_shift_template_id` FOREIGN KEY (`base_shift_template_id`) REFERENCES `workforce`.`shift_template` (`shift_template_id`);

ALTER TABLE `workforce`.`payroll_period` DROP CONSTRAINT IF EXISTS `fk_workforce_payroll_period_previous_payroll_period_id`;
ALTER TABLE `workforce`.`payroll_period` ADD CONSTRAINT `fk_workforce_payroll_period_previous_payroll_period_id` FOREIGN KEY (`previous_payroll_period_id`) REFERENCES `workforce`.`payroll_period` (`payroll_period_id`);

ALTER TABLE `workforce`.`payroll_run` DROP CONSTRAINT IF EXISTS `fk_workforce_payroll_run_audit_user_employee_id`;
ALTER TABLE `workforce`.`payroll_run` ADD CONSTRAINT `fk_workforce_payroll_run_audit_user_employee_id` FOREIGN KEY (`audit_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`payroll_run` DROP CONSTRAINT IF EXISTS `fk_workforce_payroll_run_employee_id`;
ALTER TABLE `workforce`.`payroll_run` ADD CONSTRAINT `fk_workforce_payroll_run_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `workforce`.`payroll_run` DROP CONSTRAINT IF EXISTS `fk_workforce_payroll_run_last_run_id`;
ALTER TABLE `workforce`.`payroll_run` ADD CONSTRAINT `fk_workforce_payroll_run_last_run_id` FOREIGN KEY (`last_run_id`) REFERENCES `workforce`.`payroll_run` (`payroll_run_id`);

ALTER TABLE `workforce`.`payroll_run` DROP CONSTRAINT IF EXISTS `fk_workforce_payroll_run_org_unit_id`;
ALTER TABLE `workforce`.`payroll_run` ADD CONSTRAINT `fk_workforce_payroll_run_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `workforce`.`org_unit` (`org_unit_id`);

ALTER TABLE `workforce`.`payroll_run` DROP CONSTRAINT IF EXISTS `fk_workforce_payroll_run_reversal_payroll_run_id`;
ALTER TABLE `workforce`.`payroll_run` ADD CONSTRAINT `fk_workforce_payroll_run_reversal_payroll_run_id` FOREIGN KEY (`reversal_payroll_run_id`) REFERENCES `workforce`.`payroll_run` (`payroll_run_id`);

