-- Utility CMM-aligned Canonical Data Model (Silver) v1.0.0 | source: Databricks lakehouse-industry-data-models energy_utilities v1 ECM | generated 2026-10-13
-- 30 | Cross-subject-area foreign keys (1630), including CIM Location links to gis.location.
-- Run after ALL subject-area table files.

USE CATALOG `utility_cmm_silver`;

-- ========= asset --> compliance (13) =========
ALTER TABLE `asset`.`work_order` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_compliance_obligation_id`;
ALTER TABLE `asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_compliance_obligation_id` FOREIGN KEY (`compliance_obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `asset`.`maintenance_plan` DROP CONSTRAINT IF EXISTS `fk_asset_maintenance_plan_compliance_obligation_id`;
ALTER TABLE `asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_compliance_obligation_id` FOREIGN KEY (`compliance_obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `asset`.`failure_event` DROP CONSTRAINT IF EXISTS `fk_asset_failure_event_self_report_id`;
ALTER TABLE `asset`.`failure_event` ADD CONSTRAINT `fk_asset_failure_event_self_report_id` FOREIGN KEY (`self_report_id`) REFERENCES `compliance`.`self_report` (`self_report_id`);

ALTER TABLE `asset`.`capital_project` DROP CONSTRAINT IF EXISTS `fk_asset_capital_project_cpcn_application_id`;
ALTER TABLE `asset`.`capital_project` ADD CONSTRAINT `fk_asset_capital_project_cpcn_application_id` FOREIGN KEY (`cpcn_application_id`) REFERENCES `compliance`.`cpcn_application` (`cpcn_application_id`);

ALTER TABLE `asset`.`capital_project` DROP CONSTRAINT IF EXISTS `fk_asset_capital_project_rate_case_id`;
ALTER TABLE `asset`.`capital_project` ADD CONSTRAINT `fk_asset_capital_project_rate_case_id` FOREIGN KEY (`rate_case_id`) REFERENCES `compliance`.`rate_case` (`rate_case_id`);

ALTER TABLE `asset`.`inspection` DROP CONSTRAINT IF EXISTS `fk_asset_inspection_compliance_obligation_id`;
ALTER TABLE `asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_compliance_obligation_id` FOREIGN KEY (`compliance_obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `asset`.`retirement` DROP CONSTRAINT IF EXISTS `fk_asset_retirement_environmental_permit_id`;
ALTER TABLE `asset`.`retirement` ADD CONSTRAINT `fk_asset_retirement_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `compliance`.`environmental_permit` (`environmental_permit_id`);

ALTER TABLE `asset`.`asset_risk_assessment` DROP CONSTRAINT IF EXISTS `fk_asset_asset_risk_assessment_compliance_obligation_id`;
ALTER TABLE `asset`.`asset_risk_assessment` ADD CONSTRAINT `fk_asset_asset_risk_assessment_compliance_obligation_id` FOREIGN KEY (`compliance_obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `asset`.`asset_program_enrollment` DROP CONSTRAINT IF EXISTS `fk_asset_asset_program_enrollment_program_id`;
ALTER TABLE `asset`.`asset_program_enrollment` ADD CONSTRAINT `fk_asset_asset_program_enrollment_program_id` FOREIGN KEY (`program_id`) REFERENCES `compliance`.`program` (`program_id`);

ALTER TABLE `asset`.`asset_compliance` DROP CONSTRAINT IF EXISTS `fk_asset_asset_compliance_compliance_obligation_id`;
ALTER TABLE `asset`.`asset_compliance` ADD CONSTRAINT `fk_asset_asset_compliance_compliance_obligation_id` FOREIGN KEY (`compliance_obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `asset`.`asset_compliance` DROP CONSTRAINT IF EXISTS `fk_asset_asset_compliance_obligation_id`;
ALTER TABLE `asset`.`asset_compliance` ADD CONSTRAINT `fk_asset_asset_compliance_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `asset`.`asset_compliance` DROP CONSTRAINT IF EXISTS `fk_asset_asset_compliance_remediation_plan_id`;
ALTER TABLE `asset`.`asset_compliance` ADD CONSTRAINT `fk_asset_asset_compliance_remediation_plan_id` FOREIGN KEY (`remediation_plan_id`) REFERENCES `compliance`.`corrective_action_plan` (`corrective_action_plan_id`);

ALTER TABLE `asset`.`project_permit` DROP CONSTRAINT IF EXISTS `fk_asset_project_permit_compliance_environmental_permit_id`;
ALTER TABLE `asset`.`project_permit` ADD CONSTRAINT `fk_asset_project_permit_compliance_environmental_permit_id` FOREIGN KEY (`compliance_environmental_permit_id`) REFERENCES `compliance`.`environmental_permit` (`environmental_permit_id`);

-- ========= asset --> demand (3) =========
ALTER TABLE `asset`.`failure_event` DROP CONSTRAINT IF EXISTS `fk_asset_failure_event_dr_event_id`;
ALTER TABLE `asset`.`failure_event` ADD CONSTRAINT `fk_asset_failure_event_dr_event_id` FOREIGN KEY (`dr_event_id`) REFERENCES `demand`.`dr_event` (`dr_event_id`);

ALTER TABLE `asset`.`spare_parts_inventory` DROP CONSTRAINT IF EXISTS `fk_asset_spare_parts_inventory_direct_load_control_device_id`;
ALTER TABLE `asset`.`spare_parts_inventory` ADD CONSTRAINT `fk_asset_spare_parts_inventory_direct_load_control_device_id` FOREIGN KEY (`direct_load_control_device_id`) REFERENCES `demand`.`direct_load_control_device` (`direct_load_control_device_id`);

ALTER TABLE `asset`.`asset_program_enrollment` DROP CONSTRAINT IF EXISTS `fk_asset_asset_program_enrollment_dr_program_id`;
ALTER TABLE `asset`.`asset_program_enrollment` ADD CONSTRAINT `fk_asset_asset_program_enrollment_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

-- ========= asset --> distribution (11) =========
ALTER TABLE `asset`.`work_order` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_feeder_id`;
ALTER TABLE `asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `asset`.`maintenance_plan` DROP CONSTRAINT IF EXISTS `fk_asset_maintenance_plan_distribution_transformer_id`;
ALTER TABLE `asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_distribution_transformer_id` FOREIGN KEY (`distribution_transformer_id`) REFERENCES `distribution`.`transformer` (`transformer_id`);

ALTER TABLE `asset`.`maintenance_plan` DROP CONSTRAINT IF EXISTS `fk_asset_maintenance_plan_feeder_id`;
ALTER TABLE `asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `asset`.`failure_event` DROP CONSTRAINT IF EXISTS `fk_asset_failure_event_distribution_transformer_id`;
ALTER TABLE `asset`.`failure_event` ADD CONSTRAINT `fk_asset_failure_event_distribution_transformer_id` FOREIGN KEY (`distribution_transformer_id`) REFERENCES `distribution`.`transformer` (`transformer_id`);

ALTER TABLE `asset`.`failure_event` DROP CONSTRAINT IF EXISTS `fk_asset_failure_event_feeder_id`;
ALTER TABLE `asset`.`failure_event` ADD CONSTRAINT `fk_asset_failure_event_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `asset`.`capital_project` DROP CONSTRAINT IF EXISTS `fk_asset_capital_project_distribution_substation_id`;
ALTER TABLE `asset`.`capital_project` ADD CONSTRAINT `fk_asset_capital_project_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `asset`.`capital_project` DROP CONSTRAINT IF EXISTS `fk_asset_capital_project_feeder_id`;
ALTER TABLE `asset`.`capital_project` ADD CONSTRAINT `fk_asset_capital_project_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `asset`.`inspection` DROP CONSTRAINT IF EXISTS `fk_asset_inspection_distribution_transformer_id`;
ALTER TABLE `asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_distribution_transformer_id` FOREIGN KEY (`distribution_transformer_id`) REFERENCES `distribution`.`transformer` (`transformer_id`);

ALTER TABLE `asset`.`inspection` DROP CONSTRAINT IF EXISTS `fk_asset_inspection_feeder_id`;
ALTER TABLE `asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `asset`.`retirement` DROP CONSTRAINT IF EXISTS `fk_asset_retirement_distribution_transformer_id`;
ALTER TABLE `asset`.`retirement` ADD CONSTRAINT `fk_asset_retirement_distribution_transformer_id` FOREIGN KEY (`distribution_transformer_id`) REFERENCES `distribution`.`transformer` (`transformer_id`);

ALTER TABLE `asset`.`retirement` DROP CONSTRAINT IF EXISTS `fk_asset_retirement_feeder_id`;
ALTER TABLE `asset`.`retirement` ADD CONSTRAINT `fk_asset_retirement_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

-- ========= asset --> finance (5) =========
ALTER TABLE `asset`.`work_order` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_cost_center_id`;
ALTER TABLE `asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `asset`.`work_order` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_gl_account_id`;
ALTER TABLE `asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `asset`.`maintenance_plan` DROP CONSTRAINT IF EXISTS `fk_asset_maintenance_plan_cost_center_id`;
ALTER TABLE `asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `asset`.`capital_project` DROP CONSTRAINT IF EXISTS `fk_asset_capital_project_cost_center_id`;
ALTER TABLE `asset`.`capital_project` ADD CONSTRAINT `fk_asset_capital_project_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `asset`.`capital_project` DROP CONSTRAINT IF EXISTS `fk_asset_capital_project_profit_center_id`;
ALTER TABLE `asset`.`capital_project` ADD CONSTRAINT `fk_asset_capital_project_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

-- ========= asset --> forecast (3) =========
ALTER TABLE `asset`.`capital_project` DROP CONSTRAINT IF EXISTS `fk_asset_capital_project_irp_scenario_id`;
ALTER TABLE `asset`.`capital_project` ADD CONSTRAINT `fk_asset_capital_project_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

ALTER TABLE `asset`.`retirement` DROP CONSTRAINT IF EXISTS `fk_asset_retirement_irp_scenario_id`;
ALTER TABLE `asset`.`retirement` ADD CONSTRAINT `fk_asset_retirement_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

ALTER TABLE `asset`.`asset_risk_assessment` DROP CONSTRAINT IF EXISTS `fk_asset_asset_risk_assessment_irp_scenario_id`;
ALTER TABLE `asset`.`asset_risk_assessment` ADD CONSTRAINT `fk_asset_asset_risk_assessment_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

-- ========= asset --> gis (4) =========
ALTER TABLE `asset`.`registry` DROP CONSTRAINT IF EXISTS `fk_asset_registry_gis_location_id`;
ALTER TABLE `asset`.`registry` ADD CONSTRAINT `fk_asset_registry_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `asset`.`work_order` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_gis_location_id`;
ALTER TABLE `asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `asset`.`failure_event` DROP CONSTRAINT IF EXISTS `fk_asset_failure_event_gis_location_id`;
ALTER TABLE `asset`.`failure_event` ADD CONSTRAINT `fk_asset_failure_event_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `asset`.`inspection` DROP CONSTRAINT IF EXISTS `fk_asset_inspection_gis_location_id`;
ALTER TABLE `asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

-- ========= asset --> interconnection (4) =========
ALTER TABLE `asset`.`work_order` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_interconnection_application_id`;
ALTER TABLE `asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `asset`.`impact_assessment` DROP CONSTRAINT IF EXISTS `fk_asset_impact_assessment_cluster_study_group_id`;
ALTER TABLE `asset`.`impact_assessment` ADD CONSTRAINT `fk_asset_impact_assessment_cluster_study_group_id` FOREIGN KEY (`cluster_study_group_id`) REFERENCES `interconnection`.`cluster_study_group` (`cluster_study_group_id`);

ALTER TABLE `asset`.`impact_assessment` DROP CONSTRAINT IF EXISTS `fk_asset_impact_assessment_interconnection_application_id`;
ALTER TABLE `asset`.`impact_assessment` ADD CONSTRAINT `fk_asset_impact_assessment_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `asset`.`der_connection` DROP CONSTRAINT IF EXISTS `fk_asset_der_connection_der_system_id`;
ALTER TABLE `asset`.`der_connection` ADD CONSTRAINT `fk_asset_der_connection_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

-- ========= asset --> metering (1) =========
ALTER TABLE `asset`.`ppa_allocation` DROP CONSTRAINT IF EXISTS `fk_asset_ppa_allocation_settlement_meter_id`;
ALTER TABLE `asset`.`ppa_allocation` ADD CONSTRAINT `fk_asset_ppa_allocation_settlement_meter_id` FOREIGN KEY (`settlement_meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

-- ========= asset --> outage (1) =========
ALTER TABLE `asset`.`failure_event` DROP CONSTRAINT IF EXISTS `fk_asset_failure_event_event_id`;
ALTER TABLE `asset`.`failure_event` ADD CONSTRAINT `fk_asset_failure_event_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

-- ========= asset --> renewable (7) =========
ALTER TABLE `asset`.`work_order` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_der_registry_id`;
ALTER TABLE `asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `asset`.`maintenance_plan` DROP CONSTRAINT IF EXISTS `fk_asset_maintenance_plan_der_registry_id`;
ALTER TABLE `asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `asset`.`failure_event` DROP CONSTRAINT IF EXISTS `fk_asset_failure_event_der_registry_id`;
ALTER TABLE `asset`.`failure_event` ADD CONSTRAINT `fk_asset_failure_event_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `asset`.`inspection` DROP CONSTRAINT IF EXISTS `fk_asset_inspection_der_registry_id`;
ALTER TABLE `asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `asset`.`warranty` DROP CONSTRAINT IF EXISTS `fk_asset_warranty_der_registry_id`;
ALTER TABLE `asset`.`warranty` ADD CONSTRAINT `fk_asset_warranty_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `asset`.`asset_risk_assessment` DROP CONSTRAINT IF EXISTS `fk_asset_asset_risk_assessment_der_registry_id`;
ALTER TABLE `asset`.`asset_risk_assessment` ADD CONSTRAINT `fk_asset_asset_risk_assessment_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `asset`.`ppa_allocation` DROP CONSTRAINT IF EXISTS `fk_asset_ppa_allocation_renewable_ppa_contract_id`;
ALTER TABLE `asset`.`ppa_allocation` ADD CONSTRAINT `fk_asset_ppa_allocation_renewable_ppa_contract_id` FOREIGN KEY (`renewable_ppa_contract_id`) REFERENCES `renewable`.`ppa_contract` (`ppa_contract_id`);

-- ========= asset --> supply (10) =========
ALTER TABLE `asset`.`registry` DROP CONSTRAINT IF EXISTS `fk_asset_registry_manufacturer_vendor_id`;
ALTER TABLE `asset`.`registry` ADD CONSTRAINT `fk_asset_registry_manufacturer_vendor_id` FOREIGN KEY (`manufacturer_vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `asset`.`class` DROP CONSTRAINT IF EXISTS `fk_asset_class_standard_material_master_id`;
ALTER TABLE `asset`.`class` ADD CONSTRAINT `fk_asset_class_standard_material_master_id` FOREIGN KEY (`standard_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `asset`.`work_order` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_material_purchase_order_id`;
ALTER TABLE `asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_material_purchase_order_id` FOREIGN KEY (`material_purchase_order_id`) REFERENCES `supply`.`purchase_order` (`purchase_order_id`);

ALTER TABLE `asset`.`maintenance_plan` DROP CONSTRAINT IF EXISTS `fk_asset_maintenance_plan_service_supplier_contract_id`;
ALTER TABLE `asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_service_supplier_contract_id` FOREIGN KEY (`service_supplier_contract_id`) REFERENCES `supply`.`supplier_contract` (`supplier_contract_id`);

ALTER TABLE `asset`.`maintenance_plan` DROP CONSTRAINT IF EXISTS `fk_asset_maintenance_plan_standard_material_master_id`;
ALTER TABLE `asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_standard_material_master_id` FOREIGN KEY (`standard_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `asset`.`failure_event` DROP CONSTRAINT IF EXISTS `fk_asset_failure_event_failed_component_material_master_id`;
ALTER TABLE `asset`.`failure_event` ADD CONSTRAINT `fk_asset_failure_event_failed_component_material_master_id` FOREIGN KEY (`failed_component_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `asset`.`capital_project` DROP CONSTRAINT IF EXISTS `fk_asset_capital_project_master_supplier_contract_id`;
ALTER TABLE `asset`.`capital_project` ADD CONSTRAINT `fk_asset_capital_project_master_supplier_contract_id` FOREIGN KEY (`master_supplier_contract_id`) REFERENCES `supply`.`supplier_contract` (`supplier_contract_id`);

ALTER TABLE `asset`.`capital_project` DROP CONSTRAINT IF EXISTS `fk_asset_capital_project_primary_equipment_material_master_id`;
ALTER TABLE `asset`.`capital_project` ADD CONSTRAINT `fk_asset_capital_project_primary_equipment_material_master_id` FOREIGN KEY (`primary_equipment_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `asset`.`retirement` DROP CONSTRAINT IF EXISTS `fk_asset_retirement_disposal_vendor_id`;
ALTER TABLE `asset`.`retirement` ADD CONSTRAINT `fk_asset_retirement_disposal_vendor_id` FOREIGN KEY (`disposal_vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `asset`.`warranty` DROP CONSTRAINT IF EXISTS `fk_asset_warranty_provider_vendor_id`;
ALTER TABLE `asset`.`warranty` ADD CONSTRAINT `fk_asset_warranty_provider_vendor_id` FOREIGN KEY (`provider_vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

-- ========= asset --> transmission (8) =========
ALTER TABLE `asset`.`work_order` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_transmission_line_id`;
ALTER TABLE `asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_transmission_line_id` FOREIGN KEY (`transmission_line_id`) REFERENCES `transmission`.`line` (`line_id`);

ALTER TABLE `asset`.`work_order` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_transmission_substation_id`;
ALTER TABLE `asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_transmission_substation_id` FOREIGN KEY (`transmission_substation_id`) REFERENCES `transmission`.`transmission_substation` (`transmission_substation_id`);

ALTER TABLE `asset`.`maintenance_plan` DROP CONSTRAINT IF EXISTS `fk_asset_maintenance_plan_transmission_line_id`;
ALTER TABLE `asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_transmission_line_id` FOREIGN KEY (`transmission_line_id`) REFERENCES `transmission`.`line` (`line_id`);

ALTER TABLE `asset`.`maintenance_plan` DROP CONSTRAINT IF EXISTS `fk_asset_maintenance_plan_transmission_substation_id`;
ALTER TABLE `asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_transmission_substation_id` FOREIGN KEY (`transmission_substation_id`) REFERENCES `transmission`.`transmission_substation` (`transmission_substation_id`);

ALTER TABLE `asset`.`failure_event` DROP CONSTRAINT IF EXISTS `fk_asset_failure_event_transmission_line_id`;
ALTER TABLE `asset`.`failure_event` ADD CONSTRAINT `fk_asset_failure_event_transmission_line_id` FOREIGN KEY (`transmission_line_id`) REFERENCES `transmission`.`line` (`line_id`);

ALTER TABLE `asset`.`failure_event` DROP CONSTRAINT IF EXISTS `fk_asset_failure_event_transmission_substation_id`;
ALTER TABLE `asset`.`failure_event` ADD CONSTRAINT `fk_asset_failure_event_transmission_substation_id` FOREIGN KEY (`transmission_substation_id`) REFERENCES `transmission`.`transmission_substation` (`transmission_substation_id`);

ALTER TABLE `asset`.`inspection` DROP CONSTRAINT IF EXISTS `fk_asset_inspection_transmission_line_id`;
ALTER TABLE `asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_transmission_line_id` FOREIGN KEY (`transmission_line_id`) REFERENCES `transmission`.`line` (`line_id`);

ALTER TABLE `asset`.`inspection` DROP CONSTRAINT IF EXISTS `fk_asset_inspection_transmission_substation_id`;
ALTER TABLE `asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_transmission_substation_id` FOREIGN KEY (`transmission_substation_id`) REFERENCES `transmission`.`transmission_substation` (`transmission_substation_id`);

-- ========= asset --> workforce (21) =========
ALTER TABLE `asset`.`hierarchy` DROP CONSTRAINT IF EXISTS `fk_asset_hierarchy_hierarchy_employee_id`;
ALTER TABLE `asset`.`hierarchy` ADD CONSTRAINT `fk_asset_hierarchy_hierarchy_employee_id` FOREIGN KEY (`hierarchy_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `asset`.`hierarchy` DROP CONSTRAINT IF EXISTS `fk_asset_hierarchy_hierarchy_last_modified_by_user_employee_id`;
ALTER TABLE `asset`.`hierarchy` ADD CONSTRAINT `fk_asset_hierarchy_hierarchy_last_modified_by_user_employee_id` FOREIGN KEY (`hierarchy_last_modified_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `asset`.`work_order` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_assigned_crew_id`;
ALTER TABLE `asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_assigned_crew_id` FOREIGN KEY (`assigned_crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `asset`.`work_order` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_contractor_worker_id`;
ALTER TABLE `asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_contractor_worker_id` FOREIGN KEY (`contractor_worker_id`) REFERENCES `workforce`.`contractor_worker` (`contractor_worker_id`);

ALTER TABLE `asset`.`work_order` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_employee_id`;
ALTER TABLE `asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `asset`.`maintenance_plan` DROP CONSTRAINT IF EXISTS `fk_asset_maintenance_plan_primary_maintenance_employee_id`;
ALTER TABLE `asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_primary_maintenance_employee_id` FOREIGN KEY (`primary_maintenance_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `asset`.`maintenance_plan` DROP CONSTRAINT IF EXISTS `fk_asset_maintenance_plan_responsible_crew_id`;
ALTER TABLE `asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_responsible_crew_id` FOREIGN KEY (`responsible_crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `asset`.`capital_project` DROP CONSTRAINT IF EXISTS `fk_asset_capital_project_project_manager_employee_id`;
ALTER TABLE `asset`.`capital_project` ADD CONSTRAINT `fk_asset_capital_project_project_manager_employee_id` FOREIGN KEY (`project_manager_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `asset`.`depreciation_schedule` DROP CONSTRAINT IF EXISTS `fk_asset_depreciation_schedule_employee_id`;
ALTER TABLE `asset`.`depreciation_schedule` ADD CONSTRAINT `fk_asset_depreciation_schedule_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `asset`.`depreciation_schedule` DROP CONSTRAINT IF EXISTS `fk_asset_depreciation_schedule_last_modified_by_user_employee_id`;
ALTER TABLE `asset`.`depreciation_schedule` ADD CONSTRAINT `fk_asset_depreciation_schedule_last_modified_by_user_employee_id` FOREIGN KEY (`last_modified_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `asset`.`spare_parts_inventory` DROP CONSTRAINT IF EXISTS `fk_asset_spare_parts_inventory_primary_spare_employee_id`;
ALTER TABLE `asset`.`spare_parts_inventory` ADD CONSTRAINT `fk_asset_spare_parts_inventory_primary_spare_employee_id` FOREIGN KEY (`primary_spare_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `asset`.`inspection` DROP CONSTRAINT IF EXISTS `fk_asset_inspection_inspection_approved_by_user_employee_id`;
ALTER TABLE `asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_inspection_approved_by_user_employee_id` FOREIGN KEY (`inspection_approved_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `asset`.`inspection` DROP CONSTRAINT IF EXISTS `fk_asset_inspection_inspection_employee_id`;
ALTER TABLE `asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_inspection_employee_id` FOREIGN KEY (`inspection_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `asset`.`valuation` DROP CONSTRAINT IF EXISTS `fk_asset_valuation_employee_id`;
ALTER TABLE `asset`.`valuation` ADD CONSTRAINT `fk_asset_valuation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `asset`.`retirement` DROP CONSTRAINT IF EXISTS `fk_asset_retirement_retirement_approved_by_user_employee_id`;
ALTER TABLE `asset`.`retirement` ADD CONSTRAINT `fk_asset_retirement_retirement_approved_by_user_employee_id` FOREIGN KEY (`retirement_approved_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `asset`.`retirement` DROP CONSTRAINT IF EXISTS `fk_asset_retirement_retirement_employee_id`;
ALTER TABLE `asset`.`retirement` ADD CONSTRAINT `fk_asset_retirement_retirement_employee_id` FOREIGN KEY (`retirement_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `asset`.`warranty` DROP CONSTRAINT IF EXISTS `fk_asset_warranty_warranty_employee_id`;
ALTER TABLE `asset`.`warranty` ADD CONSTRAINT `fk_asset_warranty_warranty_employee_id` FOREIGN KEY (`warranty_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `asset`.`warranty` DROP CONSTRAINT IF EXISTS `fk_asset_warranty_warranty_last_modified_by_user_employee_id`;
ALTER TABLE `asset`.`warranty` ADD CONSTRAINT `fk_asset_warranty_warranty_last_modified_by_user_employee_id` FOREIGN KEY (`warranty_last_modified_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `asset`.`asset_risk_assessment` DROP CONSTRAINT IF EXISTS `fk_asset_asset_risk_assessment_assessor_employee_id`;
ALTER TABLE `asset`.`asset_risk_assessment` ADD CONSTRAINT `fk_asset_asset_risk_assessment_assessor_employee_id` FOREIGN KEY (`assessor_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `asset`.`work_order_material_issue` DROP CONSTRAINT IF EXISTS `fk_asset_work_order_material_issue_issued_by_employee_id`;
ALTER TABLE `asset`.`work_order_material_issue` ADD CONSTRAINT `fk_asset_work_order_material_issue_issued_by_employee_id` FOREIGN KEY (`issued_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `asset`.`impact_assessment` DROP CONSTRAINT IF EXISTS `fk_asset_impact_assessment_analyzed_by_employee_id`;
ALTER TABLE `asset`.`impact_assessment` ADD CONSTRAINT `fk_asset_impact_assessment_analyzed_by_employee_id` FOREIGN KEY (`analyzed_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

-- ========= billing --> asset (4) =========
ALTER TABLE `billing`.`billing_service_agreement` DROP CONSTRAINT IF EXISTS `fk_billing_billing_service_agreement_service_connection_asset_registry_id`;
ALTER TABLE `billing`.`billing_service_agreement` ADD CONSTRAINT `fk_billing_billing_service_agreement_service_connection_asset_registry_id` FOREIGN KEY (`service_connection_asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `billing`.`adjustment` DROP CONSTRAINT IF EXISTS `fk_billing_adjustment_work_order_id`;
ALTER TABLE `billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `billing`.`nem_credit` DROP CONSTRAINT IF EXISTS `fk_billing_nem_credit_generation_asset_registry_id`;
ALTER TABLE `billing`.`nem_credit` ADD CONSTRAINT `fk_billing_nem_credit_generation_asset_registry_id` FOREIGN KEY (`generation_asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `billing`.`refund` DROP CONSTRAINT IF EXISTS `fk_billing_refund_work_order_id`;
ALTER TABLE `billing`.`refund` ADD CONSTRAINT `fk_billing_refund_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

-- ========= billing --> compliance (11) =========
ALTER TABLE `billing`.`rate_schedule` DROP CONSTRAINT IF EXISTS `fk_billing_rate_schedule_rate_case_id`;
ALTER TABLE `billing`.`rate_schedule` ADD CONSTRAINT `fk_billing_rate_schedule_rate_case_id` FOREIGN KEY (`rate_case_id`) REFERENCES `compliance`.`rate_case` (`rate_case_id`);

ALTER TABLE `billing`.`rate_component` DROP CONSTRAINT IF EXISTS `fk_billing_rate_component_regulatory_filing_id`;
ALTER TABLE `billing`.`rate_component` ADD CONSTRAINT `fk_billing_rate_component_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `billing`.`billing_service_agreement` DROP CONSTRAINT IF EXISTS `fk_billing_billing_service_agreement_regulatory_filing_id`;
ALTER TABLE `billing`.`billing_service_agreement` ADD CONSTRAINT `fk_billing_billing_service_agreement_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `billing`.`invoice_line` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_line_sox_control_test_id`;
ALTER TABLE `billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_sox_control_test_id` FOREIGN KEY (`sox_control_test_id`) REFERENCES `compliance`.`sox_control_test` (`sox_control_test_id`);

ALTER TABLE `billing`.`adjustment` DROP CONSTRAINT IF EXISTS `fk_billing_adjustment_audit_finding_id`;
ALTER TABLE `billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_audit_finding_id` FOREIGN KEY (`audit_finding_id`) REFERENCES `compliance`.`audit_finding` (`audit_finding_id`);

ALTER TABLE `billing`.`revenue_recognition` DROP CONSTRAINT IF EXISTS `fk_billing_revenue_recognition_audit_id`;
ALTER TABLE `billing`.`revenue_recognition` ADD CONSTRAINT `fk_billing_revenue_recognition_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `billing`.`revenue_recognition` DROP CONSTRAINT IF EXISTS `fk_billing_revenue_recognition_sox_control_id`;
ALTER TABLE `billing`.`revenue_recognition` ADD CONSTRAINT `fk_billing_revenue_recognition_sox_control_id` FOREIGN KEY (`sox_control_id`) REFERENCES `compliance`.`sox_control` (`sox_control_id`);

ALTER TABLE `billing`.`nem_credit` DROP CONSTRAINT IF EXISTS `fk_billing_nem_credit_compliance_rec_certificate_id`;
ALTER TABLE `billing`.`nem_credit` ADD CONSTRAINT `fk_billing_nem_credit_compliance_rec_certificate_id` FOREIGN KEY (`compliance_rec_certificate_id`) REFERENCES `compliance`.`compliance_rec_certificate` (`compliance_rec_certificate_id`);

ALTER TABLE `billing`.`nem_credit` DROP CONSTRAINT IF EXISTS `fk_billing_nem_credit_regulatory_filing_id`;
ALTER TABLE `billing`.`nem_credit` ADD CONSTRAINT `fk_billing_nem_credit_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `billing`.`assistance_program` DROP CONSTRAINT IF EXISTS `fk_billing_assistance_program_regulatory_filing_id`;
ALTER TABLE `billing`.`assistance_program` ADD CONSTRAINT `fk_billing_assistance_program_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `billing`.`billing_program_enrollment` DROP CONSTRAINT IF EXISTS `fk_billing_billing_program_enrollment_compliance_program_id`;
ALTER TABLE `billing`.`billing_program_enrollment` ADD CONSTRAINT `fk_billing_billing_program_enrollment_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `compliance`.`program` (`program_id`);

-- ========= billing --> customer (25) =========
ALTER TABLE `billing`.`billing_service_agreement` DROP CONSTRAINT IF EXISTS `fk_billing_billing_service_agreement_account_id`;
ALTER TABLE `billing`.`billing_service_agreement` ADD CONSTRAINT `fk_billing_billing_service_agreement_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `billing`.`billing_service_agreement` DROP CONSTRAINT IF EXISTS `fk_billing_billing_service_agreement_premise_id`;
ALTER TABLE `billing`.`billing_service_agreement` ADD CONSTRAINT `fk_billing_billing_service_agreement_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `billing`.`invoice` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_account_id`;
ALTER TABLE `billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `billing`.`invoice` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_premise_id`;
ALTER TABLE `billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `billing`.`payment` DROP CONSTRAINT IF EXISTS `fk_billing_payment_account_id`;
ALTER TABLE `billing`.`payment` ADD CONSTRAINT `fk_billing_payment_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `billing`.`payment_arrangement` DROP CONSTRAINT IF EXISTS `fk_billing_payment_arrangement_account_id`;
ALTER TABLE `billing`.`payment_arrangement` ADD CONSTRAINT `fk_billing_payment_arrangement_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `billing`.`adjustment` DROP CONSTRAINT IF EXISTS `fk_billing_adjustment_account_id`;
ALTER TABLE `billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `billing`.`deposit` DROP CONSTRAINT IF EXISTS `fk_billing_deposit_account_id`;
ALTER TABLE `billing`.`deposit` ADD CONSTRAINT `fk_billing_deposit_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `billing`.`dunning_notice` DROP CONSTRAINT IF EXISTS `fk_billing_dunning_notice_account_id`;
ALTER TABLE `billing`.`dunning_notice` ADD CONSTRAINT `fk_billing_dunning_notice_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `billing`.`dunning_notice` DROP CONSTRAINT IF EXISTS `fk_billing_dunning_notice_premise_id`;
ALTER TABLE `billing`.`dunning_notice` ADD CONSTRAINT `fk_billing_dunning_notice_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `billing`.`collections` DROP CONSTRAINT IF EXISTS `fk_billing_collections_account_id`;
ALTER TABLE `billing`.`collections` ADD CONSTRAINT `fk_billing_collections_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `billing`.`write_off` DROP CONSTRAINT IF EXISTS `fk_billing_write_off_account_id`;
ALTER TABLE `billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `billing`.`budget_plan` DROP CONSTRAINT IF EXISTS `fk_billing_budget_plan_account_id`;
ALTER TABLE `billing`.`budget_plan` ADD CONSTRAINT `fk_billing_budget_plan_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `billing`.`revenue_recognition` DROP CONSTRAINT IF EXISTS `fk_billing_revenue_recognition_billing_account_id`;
ALTER TABLE `billing`.`revenue_recognition` ADD CONSTRAINT `fk_billing_revenue_recognition_billing_account_id` FOREIGN KEY (`billing_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `billing`.`bill_dispute` DROP CONSTRAINT IF EXISTS `fk_billing_bill_dispute_account_id`;
ALTER TABLE `billing`.`bill_dispute` ADD CONSTRAINT `fk_billing_bill_dispute_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `billing`.`nem_credit` DROP CONSTRAINT IF EXISTS `fk_billing_nem_credit_account_id`;
ALTER TABLE `billing`.`nem_credit` ADD CONSTRAINT `fk_billing_nem_credit_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `billing`.`nem_credit` DROP CONSTRAINT IF EXISTS `fk_billing_nem_credit_premise_id`;
ALTER TABLE `billing`.`nem_credit` ADD CONSTRAINT `fk_billing_nem_credit_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `billing`.`billing_program_enrollment` DROP CONSTRAINT IF EXISTS `fk_billing_billing_program_enrollment_account_id`;
ALTER TABLE `billing`.`billing_program_enrollment` ADD CONSTRAINT `fk_billing_billing_program_enrollment_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `billing`.`billing_program_enrollment` DROP CONSTRAINT IF EXISTS `fk_billing_billing_program_enrollment_premise_id`;
ALTER TABLE `billing`.`billing_program_enrollment` ADD CONSTRAINT `fk_billing_billing_program_enrollment_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `billing`.`ar_ledger` DROP CONSTRAINT IF EXISTS `fk_billing_ar_ledger_account_id`;
ALTER TABLE `billing`.`ar_ledger` ADD CONSTRAINT `fk_billing_ar_ledger_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `billing`.`refund` DROP CONSTRAINT IF EXISTS `fk_billing_refund_account_id`;
ALTER TABLE `billing`.`refund` ADD CONSTRAINT `fk_billing_refund_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `billing`.`credit_memo` DROP CONSTRAINT IF EXISTS `fk_billing_credit_memo_account_id`;
ALTER TABLE `billing`.`credit_memo` ADD CONSTRAINT `fk_billing_credit_memo_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `billing`.`credit_memo` DROP CONSTRAINT IF EXISTS `fk_billing_credit_memo_profile_id`;
ALTER TABLE `billing`.`credit_memo` ADD CONSTRAINT `fk_billing_credit_memo_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `customer`.`profile` (`profile_id`);

ALTER TABLE `billing`.`disconnect_order` DROP CONSTRAINT IF EXISTS `fk_billing_disconnect_order_account_id`;
ALTER TABLE `billing`.`disconnect_order` ADD CONSTRAINT `fk_billing_disconnect_order_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `billing`.`dunning_run` DROP CONSTRAINT IF EXISTS `fk_billing_dunning_run_account_id`;
ALTER TABLE `billing`.`dunning_run` ADD CONSTRAINT `fk_billing_dunning_run_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

-- ========= billing --> demand (6) =========
ALTER TABLE `billing`.`rate_component` DROP CONSTRAINT IF EXISTS `fk_billing_rate_component_dr_program_id`;
ALTER TABLE `billing`.`rate_component` ADD CONSTRAINT `fk_billing_rate_component_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `billing`.`invoice_line` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_line_dr_incentive_payment_id`;
ALTER TABLE `billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_dr_incentive_payment_id` FOREIGN KEY (`dr_incentive_payment_id`) REFERENCES `demand`.`dr_incentive_payment` (`dr_incentive_payment_id`);

ALTER TABLE `billing`.`determinant` DROP CONSTRAINT IF EXISTS `fk_billing_determinant_dr_event_id`;
ALTER TABLE `billing`.`determinant` ADD CONSTRAINT `fk_billing_determinant_dr_event_id` FOREIGN KEY (`dr_event_id`) REFERENCES `demand`.`dr_event` (`dr_event_id`);

ALTER TABLE `billing`.`adjustment` DROP CONSTRAINT IF EXISTS `fk_billing_adjustment_dr_incentive_payment_id`;
ALTER TABLE `billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_dr_incentive_payment_id` FOREIGN KEY (`dr_incentive_payment_id`) REFERENCES `demand`.`dr_incentive_payment` (`dr_incentive_payment_id`);

ALTER TABLE `billing`.`nem_credit` DROP CONSTRAINT IF EXISTS `fk_billing_nem_credit_dr_program_id`;
ALTER TABLE `billing`.`nem_credit` ADD CONSTRAINT `fk_billing_nem_credit_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `billing`.`billing_program_enrollment` DROP CONSTRAINT IF EXISTS `fk_billing_billing_program_enrollment_demand_dr_enrollment_id`;
ALTER TABLE `billing`.`billing_program_enrollment` ADD CONSTRAINT `fk_billing_billing_program_enrollment_demand_dr_enrollment_id` FOREIGN KEY (`demand_dr_enrollment_id`) REFERENCES `demand`.`demand_dr_enrollment` (`demand_dr_enrollment_id`);

-- ========= billing --> distribution (4) =========
ALTER TABLE `billing`.`rate_schedule` DROP CONSTRAINT IF EXISTS `fk_billing_rate_schedule_service_territory_id`;
ALTER TABLE `billing`.`rate_schedule` ADD CONSTRAINT `fk_billing_rate_schedule_service_territory_id` FOREIGN KEY (`service_territory_id`) REFERENCES `distribution`.`service_territory` (`service_territory_id`);

ALTER TABLE `billing`.`invoice` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_service_territory_id`;
ALTER TABLE `billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_service_territory_id` FOREIGN KEY (`service_territory_id`) REFERENCES `distribution`.`service_territory` (`service_territory_id`);

ALTER TABLE `billing`.`determinant` DROP CONSTRAINT IF EXISTS `fk_billing_determinant_feeder_id`;
ALTER TABLE `billing`.`determinant` ADD CONSTRAINT `fk_billing_determinant_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `billing`.`nem_credit` DROP CONSTRAINT IF EXISTS `fk_billing_nem_credit_der_interconnection_point_id`;
ALTER TABLE `billing`.`nem_credit` ADD CONSTRAINT `fk_billing_nem_credit_der_interconnection_point_id` FOREIGN KEY (`der_interconnection_point_id`) REFERENCES `distribution`.`der_interconnection_point` (`der_interconnection_point_id`);

-- ========= billing --> finance (11) =========
ALTER TABLE `billing`.`invoice` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_gl_account_id`;
ALTER TABLE `billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `billing`.`invoice_line` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_line_cost_center_id`;
ALTER TABLE `billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `billing`.`invoice_line` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_line_profit_center_id`;
ALTER TABLE `billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `billing`.`adjustment` DROP CONSTRAINT IF EXISTS `fk_billing_adjustment_cost_center_id`;
ALTER TABLE `billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `billing`.`adjustment` DROP CONSTRAINT IF EXISTS `fk_billing_adjustment_gl_account_id`;
ALTER TABLE `billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `billing`.`deposit` DROP CONSTRAINT IF EXISTS `fk_billing_deposit_gl_account_id`;
ALTER TABLE `billing`.`deposit` ADD CONSTRAINT `fk_billing_deposit_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `billing`.`write_off` DROP CONSTRAINT IF EXISTS `fk_billing_write_off_cost_center_id`;
ALTER TABLE `billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `billing`.`write_off` DROP CONSTRAINT IF EXISTS `fk_billing_write_off_gl_account_id`;
ALTER TABLE `billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `billing`.`revenue_recognition` DROP CONSTRAINT IF EXISTS `fk_billing_revenue_recognition_journal_entry_id`;
ALTER TABLE `billing`.`revenue_recognition` ADD CONSTRAINT `fk_billing_revenue_recognition_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `finance`.`journal_entry` (`journal_entry_id`);

ALTER TABLE `billing`.`ar_ledger` DROP CONSTRAINT IF EXISTS `fk_billing_ar_ledger_ar_gl_account_id`;
ALTER TABLE `billing`.`ar_ledger` ADD CONSTRAINT `fk_billing_ar_ledger_ar_gl_account_id` FOREIGN KEY (`ar_gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `billing`.`refund` DROP CONSTRAINT IF EXISTS `fk_billing_refund_gl_account_id`;
ALTER TABLE `billing`.`refund` ADD CONSTRAINT `fk_billing_refund_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

-- ========= billing --> forecast (7) =========
ALTER TABLE `billing`.`rate_schedule` DROP CONSTRAINT IF EXISTS `fk_billing_rate_schedule_irp_scenario_id`;
ALTER TABLE `billing`.`rate_schedule` ADD CONSTRAINT `fk_billing_rate_schedule_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

ALTER TABLE `billing`.`rate_schedule` DROP CONSTRAINT IF EXISTS `fk_billing_rate_schedule_peak_demand_id`;
ALTER TABLE `billing`.`rate_schedule` ADD CONSTRAINT `fk_billing_rate_schedule_peak_demand_id` FOREIGN KEY (`peak_demand_id`) REFERENCES `forecast`.`peak_demand` (`peak_demand_id`);

ALTER TABLE `billing`.`rate_component` DROP CONSTRAINT IF EXISTS `fk_billing_rate_component_capacity_requirement_id`;
ALTER TABLE `billing`.`rate_component` ADD CONSTRAINT `fk_billing_rate_component_capacity_requirement_id` FOREIGN KEY (`capacity_requirement_id`) REFERENCES `forecast`.`capacity_requirement` (`capacity_requirement_id`);

ALTER TABLE `billing`.`rate_component` DROP CONSTRAINT IF EXISTS `fk_billing_rate_component_energy_price_id`;
ALTER TABLE `billing`.`rate_component` ADD CONSTRAINT `fk_billing_rate_component_energy_price_id` FOREIGN KEY (`energy_price_id`) REFERENCES `forecast`.`energy_price` (`energy_price_id`);

ALTER TABLE `billing`.`rate_component` DROP CONSTRAINT IF EXISTS `fk_billing_rate_component_fuel_price_assumption_id`;
ALTER TABLE `billing`.`rate_component` ADD CONSTRAINT `fk_billing_rate_component_fuel_price_assumption_id` FOREIGN KEY (`fuel_price_assumption_id`) REFERENCES `forecast`.`fuel_price_assumption` (`fuel_price_assumption_id`);

ALTER TABLE `billing`.`budget_plan` DROP CONSTRAINT IF EXISTS `fk_billing_budget_plan_load_id`;
ALTER TABLE `billing`.`budget_plan` ADD CONSTRAINT `fk_billing_budget_plan_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `billing`.`assistance_program` DROP CONSTRAINT IF EXISTS `fk_billing_assistance_program_irp_scenario_id`;
ALTER TABLE `billing`.`assistance_program` ADD CONSTRAINT `fk_billing_assistance_program_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

-- ========= billing --> generation (1) =========
ALTER TABLE `billing`.`adjustment` DROP CONSTRAINT IF EXISTS `fk_billing_adjustment_outage_event_id`;
ALTER TABLE `billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_outage_event_id` FOREIGN KEY (`outage_event_id`) REFERENCES `generation`.`outage_event` (`outage_event_id`);

-- ========= billing --> grid (2) =========
ALTER TABLE `billing`.`adjustment` DROP CONSTRAINT IF EXISTS `fk_billing_adjustment_grid_reliability_event_id`;
ALTER TABLE `billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_grid_reliability_event_id` FOREIGN KEY (`grid_reliability_event_id`) REFERENCES `grid`.`grid_reliability_event` (`grid_reliability_event_id`);

ALTER TABLE `billing`.`bill_dispute` DROP CONSTRAINT IF EXISTS `fk_billing_bill_dispute_grid_reliability_event_id`;
ALTER TABLE `billing`.`bill_dispute` ADD CONSTRAINT `fk_billing_bill_dispute_grid_reliability_event_id` FOREIGN KEY (`grid_reliability_event_id`) REFERENCES `grid`.`grid_reliability_event` (`grid_reliability_event_id`);

-- ========= billing --> interconnection (5) =========
ALTER TABLE `billing`.`payment_arrangement` DROP CONSTRAINT IF EXISTS `fk_billing_payment_arrangement_interconnection_application_id`;
ALTER TABLE `billing`.`payment_arrangement` ADD CONSTRAINT `fk_billing_payment_arrangement_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `billing`.`determinant` DROP CONSTRAINT IF EXISTS `fk_billing_determinant_der_system_id`;
ALTER TABLE `billing`.`determinant` ADD CONSTRAINT `fk_billing_determinant_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `billing`.`adjustment` DROP CONSTRAINT IF EXISTS `fk_billing_adjustment_interconnection_application_id`;
ALTER TABLE `billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `billing`.`assistance_program` DROP CONSTRAINT IF EXISTS `fk_billing_assistance_program_interconnection_application_id`;
ALTER TABLE `billing`.`assistance_program` ADD CONSTRAINT `fk_billing_assistance_program_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `billing`.`billing_program_enrollment` DROP CONSTRAINT IF EXISTS `fk_billing_billing_program_enrollment_sgip_enrollment_id`;
ALTER TABLE `billing`.`billing_program_enrollment` ADD CONSTRAINT `fk_billing_billing_program_enrollment_sgip_enrollment_id` FOREIGN KEY (`sgip_enrollment_id`) REFERENCES `interconnection`.`sgip_enrollment` (`sgip_enrollment_id`);

-- ========= billing --> metering (9) =========
ALTER TABLE `billing`.`billing_service_agreement` DROP CONSTRAINT IF EXISTS `fk_billing_billing_service_agreement_meter_point_id`;
ALTER TABLE `billing`.`billing_service_agreement` ADD CONSTRAINT `fk_billing_billing_service_agreement_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `billing`.`invoice` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_meter_point_id`;
ALTER TABLE `billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `billing`.`determinant` DROP CONSTRAINT IF EXISTS `fk_billing_determinant_meter_id`;
ALTER TABLE `billing`.`determinant` ADD CONSTRAINT `fk_billing_determinant_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `billing`.`determinant` DROP CONSTRAINT IF EXISTS `fk_billing_determinant_meter_point_id`;
ALTER TABLE `billing`.`determinant` ADD CONSTRAINT `fk_billing_determinant_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `billing`.`adjustment` DROP CONSTRAINT IF EXISTS `fk_billing_adjustment_meter_point_id`;
ALTER TABLE `billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `billing`.`bill_dispute` DROP CONSTRAINT IF EXISTS `fk_billing_bill_dispute_meter_point_id`;
ALTER TABLE `billing`.`bill_dispute` ADD CONSTRAINT `fk_billing_bill_dispute_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `billing`.`nem_credit` DROP CONSTRAINT IF EXISTS `fk_billing_nem_credit_net_energy_metering_id`;
ALTER TABLE `billing`.`nem_credit` ADD CONSTRAINT `fk_billing_nem_credit_net_energy_metering_id` FOREIGN KEY (`net_energy_metering_id`) REFERENCES `metering`.`net_energy_metering` (`net_energy_metering_id`);

ALTER TABLE `billing`.`disconnect_order` DROP CONSTRAINT IF EXISTS `fk_billing_disconnect_order_meter_id`;
ALTER TABLE `billing`.`disconnect_order` ADD CONSTRAINT `fk_billing_disconnect_order_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `billing`.`disconnect_order` DROP CONSTRAINT IF EXISTS `fk_billing_disconnect_order_service_point_id`;
ALTER TABLE `billing`.`disconnect_order` ADD CONSTRAINT `fk_billing_disconnect_order_service_point_id` FOREIGN KEY (`service_point_id`) REFERENCES `metering`.`service_point` (`service_point_id`);

-- ========= billing --> renewable (12) =========
ALTER TABLE `billing`.`rate_schedule` DROP CONSTRAINT IF EXISTS `fk_billing_rate_schedule_renewable_incentive_program_id`;
ALTER TABLE `billing`.`rate_schedule` ADD CONSTRAINT `fk_billing_rate_schedule_renewable_incentive_program_id` FOREIGN KEY (`renewable_incentive_program_id`) REFERENCES `renewable`.`incentive_program` (`incentive_program_id`);

ALTER TABLE `billing`.`billing_service_agreement` DROP CONSTRAINT IF EXISTS `fk_billing_billing_service_agreement_der_registry_id`;
ALTER TABLE `billing`.`billing_service_agreement` ADD CONSTRAINT `fk_billing_billing_service_agreement_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `billing`.`billing_service_agreement` DROP CONSTRAINT IF EXISTS `fk_billing_billing_service_agreement_nem_account_id`;
ALTER TABLE `billing`.`billing_service_agreement` ADD CONSTRAINT `fk_billing_billing_service_agreement_nem_account_id` FOREIGN KEY (`nem_account_id`) REFERENCES `renewable`.`nem_account` (`nem_account_id`);

ALTER TABLE `billing`.`invoice` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_nem_account_id`;
ALTER TABLE `billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_nem_account_id` FOREIGN KEY (`nem_account_id`) REFERENCES `renewable`.`nem_account` (`nem_account_id`);

ALTER TABLE `billing`.`determinant` DROP CONSTRAINT IF EXISTS `fk_billing_determinant_der_registry_id`;
ALTER TABLE `billing`.`determinant` ADD CONSTRAINT `fk_billing_determinant_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `billing`.`revenue_recognition` DROP CONSTRAINT IF EXISTS `fk_billing_revenue_recognition_renewable_ppa_settlement_id`;
ALTER TABLE `billing`.`revenue_recognition` ADD CONSTRAINT `fk_billing_revenue_recognition_renewable_ppa_settlement_id` FOREIGN KEY (`renewable_ppa_settlement_id`) REFERENCES `renewable`.`ppa_settlement` (`ppa_settlement_id`);

ALTER TABLE `billing`.`nem_credit` DROP CONSTRAINT IF EXISTS `fk_billing_nem_credit_der_registry_id`;
ALTER TABLE `billing`.`nem_credit` ADD CONSTRAINT `fk_billing_nem_credit_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `billing`.`nem_credit` DROP CONSTRAINT IF EXISTS `fk_billing_nem_credit_renewable_ppa_contract_id`;
ALTER TABLE `billing`.`nem_credit` ADD CONSTRAINT `fk_billing_nem_credit_renewable_ppa_contract_id` FOREIGN KEY (`renewable_ppa_contract_id`) REFERENCES `renewable`.`ppa_contract` (`ppa_contract_id`);

ALTER TABLE `billing`.`assistance_program` DROP CONSTRAINT IF EXISTS `fk_billing_assistance_program_renewable_incentive_program_id`;
ALTER TABLE `billing`.`assistance_program` ADD CONSTRAINT `fk_billing_assistance_program_renewable_incentive_program_id` FOREIGN KEY (`renewable_incentive_program_id`) REFERENCES `renewable`.`incentive_program` (`incentive_program_id`);

ALTER TABLE `billing`.`billing_program_enrollment` DROP CONSTRAINT IF EXISTS `fk_billing_billing_program_enrollment_green_tariff_subscription_id`;
ALTER TABLE `billing`.`billing_program_enrollment` ADD CONSTRAINT `fk_billing_billing_program_enrollment_green_tariff_subscription_id` FOREIGN KEY (`green_tariff_subscription_id`) REFERENCES `renewable`.`green_tariff_subscription` (`green_tariff_subscription_id`);

ALTER TABLE `billing`.`billing_program_enrollment` DROP CONSTRAINT IF EXISTS `fk_billing_billing_program_enrollment_renewable_incentive_program_id`;
ALTER TABLE `billing`.`billing_program_enrollment` ADD CONSTRAINT `fk_billing_billing_program_enrollment_renewable_incentive_program_id` FOREIGN KEY (`renewable_incentive_program_id`) REFERENCES `renewable`.`incentive_program` (`incentive_program_id`);

ALTER TABLE `billing`.`service_agreement_incentive_enrollment` DROP CONSTRAINT IF EXISTS `fk_billing_service_agreement_incentive_enrollment_renewable_incentive_program_id`;
ALTER TABLE `billing`.`service_agreement_incentive_enrollment` ADD CONSTRAINT `fk_billing_service_agreement_incentive_enrollment_renewable_incentive_program_id` FOREIGN KEY (`renewable_incentive_program_id`) REFERENCES `renewable`.`incentive_program` (`incentive_program_id`);

-- ========= billing --> trading (10) =========
ALTER TABLE `billing`.`rate_schedule` DROP CONSTRAINT IF EXISTS `fk_billing_rate_schedule_lmp_price_id`;
ALTER TABLE `billing`.`rate_schedule` ADD CONSTRAINT `fk_billing_rate_schedule_lmp_price_id` FOREIGN KEY (`lmp_price_id`) REFERENCES `trading`.`lmp_price` (`lmp_price_id`);

ALTER TABLE `billing`.`invoice` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_trade_id`;
ALTER TABLE `billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_trade_id` FOREIGN KEY (`trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `billing`.`invoice_line` DROP CONSTRAINT IF EXISTS `fk_billing_invoice_line_trade_id`;
ALTER TABLE `billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_trade_id` FOREIGN KEY (`trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `billing`.`determinant` DROP CONSTRAINT IF EXISTS `fk_billing_determinant_lmp_price_id`;
ALTER TABLE `billing`.`determinant` ADD CONSTRAINT `fk_billing_determinant_lmp_price_id` FOREIGN KEY (`lmp_price_id`) REFERENCES `trading`.`lmp_price` (`lmp_price_id`);

ALTER TABLE `billing`.`adjustment` DROP CONSTRAINT IF EXISTS `fk_billing_adjustment_market_settlement_id`;
ALTER TABLE `billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_market_settlement_id` FOREIGN KEY (`market_settlement_id`) REFERENCES `trading`.`market_settlement` (`market_settlement_id`);

ALTER TABLE `billing`.`adjustment` DROP CONSTRAINT IF EXISTS `fk_billing_adjustment_trade_id`;
ALTER TABLE `billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_trade_id` FOREIGN KEY (`trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `billing`.`revenue_recognition` DROP CONSTRAINT IF EXISTS `fk_billing_revenue_recognition_ppa_id`;
ALTER TABLE `billing`.`revenue_recognition` ADD CONSTRAINT `fk_billing_revenue_recognition_ppa_id` FOREIGN KEY (`ppa_id`) REFERENCES `trading`.`ppa` (`ppa_id`);

ALTER TABLE `billing`.`revenue_recognition` DROP CONSTRAINT IF EXISTS `fk_billing_revenue_recognition_trade_id`;
ALTER TABLE `billing`.`revenue_recognition` ADD CONSTRAINT `fk_billing_revenue_recognition_trade_id` FOREIGN KEY (`trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `billing`.`nem_credit` DROP CONSTRAINT IF EXISTS `fk_billing_nem_credit_lmp_price_id`;
ALTER TABLE `billing`.`nem_credit` ADD CONSTRAINT `fk_billing_nem_credit_lmp_price_id` FOREIGN KEY (`lmp_price_id`) REFERENCES `trading`.`lmp_price` (`lmp_price_id`);

ALTER TABLE `billing`.`nem_credit` DROP CONSTRAINT IF EXISTS `fk_billing_nem_credit_rec_holding_id`;
ALTER TABLE `billing`.`nem_credit` ADD CONSTRAINT `fk_billing_nem_credit_rec_holding_id` FOREIGN KEY (`rec_holding_id`) REFERENCES `trading`.`rec_holding` (`rec_holding_id`);

-- ========= billing --> workforce (17) =========
ALTER TABLE `billing`.`payment_arrangement` DROP CONSTRAINT IF EXISTS `fk_billing_payment_arrangement_employee_id`;
ALTER TABLE `billing`.`payment_arrangement` ADD CONSTRAINT `fk_billing_payment_arrangement_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `billing`.`adjustment` DROP CONSTRAINT IF EXISTS `fk_billing_adjustment_adjustment_created_by_user_employee_id`;
ALTER TABLE `billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_adjustment_created_by_user_employee_id` FOREIGN KEY (`adjustment_created_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `billing`.`adjustment` DROP CONSTRAINT IF EXISTS `fk_billing_adjustment_adjustment_employee_id`;
ALTER TABLE `billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_adjustment_employee_id` FOREIGN KEY (`adjustment_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `billing`.`deposit` DROP CONSTRAINT IF EXISTS `fk_billing_deposit_employee_id`;
ALTER TABLE `billing`.`deposit` ADD CONSTRAINT `fk_billing_deposit_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `billing`.`collections` DROP CONSTRAINT IF EXISTS `fk_billing_collections_employee_id`;
ALTER TABLE `billing`.`collections` ADD CONSTRAINT `fk_billing_collections_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `billing`.`write_off` DROP CONSTRAINT IF EXISTS `fk_billing_write_off_approved_by_employee_id`;
ALTER TABLE `billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_approved_by_employee_id` FOREIGN KEY (`approved_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `billing`.`cycle` DROP CONSTRAINT IF EXISTS `fk_billing_cycle_cycle_approved_by_employee_id`;
ALTER TABLE `billing`.`cycle` ADD CONSTRAINT `fk_billing_cycle_cycle_approved_by_employee_id` FOREIGN KEY (`cycle_approved_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `billing`.`cycle` DROP CONSTRAINT IF EXISTS `fk_billing_cycle_cycle_employee_id`;
ALTER TABLE `billing`.`cycle` ADD CONSTRAINT `fk_billing_cycle_cycle_employee_id` FOREIGN KEY (`cycle_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `billing`.`billing_run` DROP CONSTRAINT IF EXISTS `fk_billing_billing_run_employee_id`;
ALTER TABLE `billing`.`billing_run` ADD CONSTRAINT `fk_billing_billing_run_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `billing`.`bill_dispute` DROP CONSTRAINT IF EXISTS `fk_billing_bill_dispute_employee_id`;
ALTER TABLE `billing`.`bill_dispute` ADD CONSTRAINT `fk_billing_bill_dispute_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `billing`.`billing_program_enrollment` DROP CONSTRAINT IF EXISTS `fk_billing_billing_program_enrollment_billing_employee_id`;
ALTER TABLE `billing`.`billing_program_enrollment` ADD CONSTRAINT `fk_billing_billing_program_enrollment_billing_employee_id` FOREIGN KEY (`billing_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `billing`.`billing_program_enrollment` DROP CONSTRAINT IF EXISTS `fk_billing_billing_program_enrollment_billing_last_modified_by_user_employee_id`;
ALTER TABLE `billing`.`billing_program_enrollment` ADD CONSTRAINT `fk_billing_billing_program_enrollment_billing_last_modified_by_user_employee_id` FOREIGN KEY (`billing_last_modified_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `billing`.`ar_ledger` DROP CONSTRAINT IF EXISTS `fk_billing_ar_ledger_primary_ar_employee_id`;
ALTER TABLE `billing`.`ar_ledger` ADD CONSTRAINT `fk_billing_ar_ledger_primary_ar_employee_id` FOREIGN KEY (`primary_ar_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `billing`.`refund` DROP CONSTRAINT IF EXISTS `fk_billing_refund_refund_employee_id`;
ALTER TABLE `billing`.`refund` ADD CONSTRAINT `fk_billing_refund_refund_employee_id` FOREIGN KEY (`refund_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `billing`.`refund` DROP CONSTRAINT IF EXISTS `fk_billing_refund_refund_modified_by_user_employee_id`;
ALTER TABLE `billing`.`refund` ADD CONSTRAINT `fk_billing_refund_refund_modified_by_user_employee_id` FOREIGN KEY (`refund_modified_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `billing`.`disconnect_order` DROP CONSTRAINT IF EXISTS `fk_billing_disconnect_order_employee_id`;
ALTER TABLE `billing`.`disconnect_order` ADD CONSTRAINT `fk_billing_disconnect_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `billing`.`dunning_run` DROP CONSTRAINT IF EXISTS `fk_billing_dunning_run_employee_id`;
ALTER TABLE `billing`.`dunning_run` ADD CONSTRAINT `fk_billing_dunning_run_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

-- ========= compliance --> asset (2) =========
ALTER TABLE `compliance`.`nerc_cip_asset` DROP CONSTRAINT IF EXISTS `fk_compliance_nerc_cip_asset_primary_nerc_registry_id`;
ALTER TABLE `compliance`.`nerc_cip_asset` ADD CONSTRAINT `fk_compliance_nerc_cip_asset_primary_nerc_registry_id` FOREIGN KEY (`primary_nerc_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `compliance`.`violation` DROP CONSTRAINT IF EXISTS `fk_compliance_violation_registry_id`;
ALTER TABLE `compliance`.`violation` ADD CONSTRAINT `fk_compliance_violation_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

-- ========= compliance --> customer (4) =========
ALTER TABLE `compliance`.`audit_finding` DROP CONSTRAINT IF EXISTS `fk_compliance_audit_finding_account_id`;
ALTER TABLE `compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `compliance`.`audit_finding` DROP CONSTRAINT IF EXISTS `fk_compliance_audit_finding_premise_id`;
ALTER TABLE `compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `compliance`.`evidence_record` DROP CONSTRAINT IF EXISTS `fk_compliance_evidence_record_account_id`;
ALTER TABLE `compliance`.`evidence_record` ADD CONSTRAINT `fk_compliance_evidence_record_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `compliance`.`evidence_record` DROP CONSTRAINT IF EXISTS `fk_compliance_evidence_record_premise_id`;
ALTER TABLE `compliance`.`evidence_record` ADD CONSTRAINT `fk_compliance_evidence_record_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

-- ========= compliance --> finance (8) =========
ALTER TABLE `compliance`.`audit` DROP CONSTRAINT IF EXISTS `fk_compliance_audit_cost_center_id`;
ALTER TABLE `compliance`.`audit` ADD CONSTRAINT `fk_compliance_audit_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `compliance`.`audit_finding` DROP CONSTRAINT IF EXISTS `fk_compliance_audit_finding_cost_center_id`;
ALTER TABLE `compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `compliance`.`corrective_action_plan` DROP CONSTRAINT IF EXISTS `fk_compliance_corrective_action_plan_capex_project_id`;
ALTER TABLE `compliance`.`corrective_action_plan` ADD CONSTRAINT `fk_compliance_corrective_action_plan_capex_project_id` FOREIGN KEY (`capex_project_id`) REFERENCES `finance`.`capex_project` (`capex_project_id`);

ALTER TABLE `compliance`.`corrective_action_plan` DROP CONSTRAINT IF EXISTS `fk_compliance_corrective_action_plan_cost_center_id`;
ALTER TABLE `compliance`.`corrective_action_plan` ADD CONSTRAINT `fk_compliance_corrective_action_plan_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `compliance`.`emissions_report` DROP CONSTRAINT IF EXISTS `fk_compliance_emissions_report_cost_center_id`;
ALTER TABLE `compliance`.`emissions_report` ADD CONSTRAINT `fk_compliance_emissions_report_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `compliance`.`environmental_permit` DROP CONSTRAINT IF EXISTS `fk_compliance_environmental_permit_capex_project_id`;
ALTER TABLE `compliance`.`environmental_permit` ADD CONSTRAINT `fk_compliance_environmental_permit_capex_project_id` FOREIGN KEY (`capex_project_id`) REFERENCES `finance`.`capex_project` (`capex_project_id`);

ALTER TABLE `compliance`.`cpcn_application` DROP CONSTRAINT IF EXISTS `fk_compliance_cpcn_application_capex_project_id`;
ALTER TABLE `compliance`.`cpcn_application` ADD CONSTRAINT `fk_compliance_cpcn_application_capex_project_id` FOREIGN KEY (`capex_project_id`) REFERENCES `finance`.`capex_project` (`capex_project_id`);

ALTER TABLE `compliance`.`irp_filing` DROP CONSTRAINT IF EXISTS `fk_compliance_irp_filing_primary_capex_project_id`;
ALTER TABLE `compliance`.`irp_filing` ADD CONSTRAINT `fk_compliance_irp_filing_primary_capex_project_id` FOREIGN KEY (`primary_capex_project_id`) REFERENCES `finance`.`capex_project` (`capex_project_id`);

-- ========= compliance --> forecast (7) =========
ALTER TABLE `compliance`.`emissions_report` DROP CONSTRAINT IF EXISTS `fk_compliance_emissions_report_generation_forecast_interval_id`;
ALTER TABLE `compliance`.`emissions_report` ADD CONSTRAINT `fk_compliance_emissions_report_generation_forecast_interval_id` FOREIGN KEY (`generation_forecast_interval_id`) REFERENCES `forecast`.`generation_forecast_interval` (`generation_forecast_interval_id`);

ALTER TABLE `compliance`.`rate_case` DROP CONSTRAINT IF EXISTS `fk_compliance_rate_case_load_id`;
ALTER TABLE `compliance`.`rate_case` ADD CONSTRAINT `fk_compliance_rate_case_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `compliance`.`rate_case` DROP CONSTRAINT IF EXISTS `fk_compliance_rate_case_peak_demand_id`;
ALTER TABLE `compliance`.`rate_case` ADD CONSTRAINT `fk_compliance_rate_case_peak_demand_id` FOREIGN KEY (`peak_demand_id`) REFERENCES `forecast`.`peak_demand` (`peak_demand_id`);

ALTER TABLE `compliance`.`irp_filing` DROP CONSTRAINT IF EXISTS `fk_compliance_irp_filing_fuel_price_assumption_id`;
ALTER TABLE `compliance`.`irp_filing` ADD CONSTRAINT `fk_compliance_irp_filing_fuel_price_assumption_id` FOREIGN KEY (`fuel_price_assumption_id`) REFERENCES `forecast`.`fuel_price_assumption` (`fuel_price_assumption_id`);

ALTER TABLE `compliance`.`irp_filing` DROP CONSTRAINT IF EXISTS `fk_compliance_irp_filing_load_id`;
ALTER TABLE `compliance`.`irp_filing` ADD CONSTRAINT `fk_compliance_irp_filing_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `compliance`.`irp_filing` DROP CONSTRAINT IF EXISTS `fk_compliance_irp_filing_peak_demand_id`;
ALTER TABLE `compliance`.`irp_filing` ADD CONSTRAINT `fk_compliance_irp_filing_peak_demand_id` FOREIGN KEY (`peak_demand_id`) REFERENCES `forecast`.`peak_demand` (`peak_demand_id`);

ALTER TABLE `compliance`.`irp_filing` DROP CONSTRAINT IF EXISTS `fk_compliance_irp_filing_planning_assumption_id`;
ALTER TABLE `compliance`.`irp_filing` ADD CONSTRAINT `fk_compliance_irp_filing_planning_assumption_id` FOREIGN KEY (`planning_assumption_id`) REFERENCES `forecast`.`planning_assumption` (`planning_assumption_id`);

-- ========= compliance --> generation (3) =========
ALTER TABLE `compliance`.`emissions_report` DROP CONSTRAINT IF EXISTS `fk_compliance_emissions_report_power_plant_id`;
ALTER TABLE `compliance`.`emissions_report` ADD CONSTRAINT `fk_compliance_emissions_report_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `compliance`.`environmental_permit` DROP CONSTRAINT IF EXISTS `fk_compliance_environmental_permit_power_plant_id`;
ALTER TABLE `compliance`.`environmental_permit` ADD CONSTRAINT `fk_compliance_environmental_permit_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `compliance`.`compliance_rec_certificate` DROP CONSTRAINT IF EXISTS `fk_compliance_compliance_rec_certificate_primary_compliance_power_plant_id`;
ALTER TABLE `compliance`.`compliance_rec_certificate` ADD CONSTRAINT `fk_compliance_compliance_rec_certificate_primary_compliance_power_plant_id` FOREIGN KEY (`primary_compliance_power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

-- ========= compliance --> gis (3) =========
ALTER TABLE `compliance`.`nerc_cip_asset` DROP CONSTRAINT IF EXISTS `fk_compliance_nerc_cip_asset_gis_location_id`;
ALTER TABLE `compliance`.`nerc_cip_asset` ADD CONSTRAINT `fk_compliance_nerc_cip_asset_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `compliance`.`bes_facility` DROP CONSTRAINT IF EXISTS `fk_compliance_bes_facility_gis_location_id`;
ALTER TABLE `compliance`.`bes_facility` ADD CONSTRAINT `fk_compliance_bes_facility_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `compliance`.`physical_security_perimeter` DROP CONSTRAINT IF EXISTS `fk_compliance_physical_security_perimeter_gis_location_id`;
ALTER TABLE `compliance`.`physical_security_perimeter` ADD CONSTRAINT `fk_compliance_physical_security_perimeter_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

-- ========= compliance --> grid (1) =========
ALTER TABLE `compliance`.`nerc_cip_asset` DROP CONSTRAINT IF EXISTS `fk_compliance_nerc_cip_asset_control_center_id`;
ALTER TABLE `compliance`.`nerc_cip_asset` ADD CONSTRAINT `fk_compliance_nerc_cip_asset_control_center_id` FOREIGN KEY (`control_center_id`) REFERENCES `grid`.`control_center` (`control_center_id`);

-- ========= compliance --> renewable (1) =========
ALTER TABLE `compliance`.`compliance_rec_certificate` DROP CONSTRAINT IF EXISTS `fk_compliance_compliance_rec_certificate_ppa_contract_id`;
ALTER TABLE `compliance`.`compliance_rec_certificate` ADD CONSTRAINT `fk_compliance_compliance_rec_certificate_ppa_contract_id` FOREIGN KEY (`ppa_contract_id`) REFERENCES `renewable`.`ppa_contract` (`ppa_contract_id`);

-- ========= compliance --> workforce (29) =========
ALTER TABLE `compliance`.`obligation` DROP CONSTRAINT IF EXISTS `fk_compliance_obligation_responsible_organization_unit_org_unit_id`;
ALTER TABLE `compliance`.`obligation` ADD CONSTRAINT `fk_compliance_obligation_responsible_organization_unit_org_unit_id` FOREIGN KEY (`responsible_organization_unit_org_unit_id`) REFERENCES `workforce`.`org_unit` (`org_unit_id`);

ALTER TABLE `compliance`.`audit` DROP CONSTRAINT IF EXISTS `fk_compliance_audit_utility_audit_coordinator_employee_id`;
ALTER TABLE `compliance`.`audit` ADD CONSTRAINT `fk_compliance_audit_utility_audit_coordinator_employee_id` FOREIGN KEY (`utility_audit_coordinator_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`audit_finding` DROP CONSTRAINT IF EXISTS `fk_compliance_audit_finding_responsible_party_employee_id`;
ALTER TABLE `compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_responsible_party_employee_id` FOREIGN KEY (`responsible_party_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`enforcement_action` DROP CONSTRAINT IF EXISTS `fk_compliance_enforcement_action_responsible_business_unit_org_unit_id`;
ALTER TABLE `compliance`.`enforcement_action` ADD CONSTRAINT `fk_compliance_enforcement_action_responsible_business_unit_org_unit_id` FOREIGN KEY (`responsible_business_unit_org_unit_id`) REFERENCES `workforce`.`org_unit` (`org_unit_id`);

ALTER TABLE `compliance`.`corrective_action_plan` DROP CONSTRAINT IF EXISTS `fk_compliance_corrective_action_plan_responsible_department_org_unit_id`;
ALTER TABLE `compliance`.`corrective_action_plan` ADD CONSTRAINT `fk_compliance_corrective_action_plan_responsible_department_org_unit_id` FOREIGN KEY (`responsible_department_org_unit_id`) REFERENCES `workforce`.`org_unit` (`org_unit_id`);

ALTER TABLE `compliance`.`corrective_action_plan` DROP CONSTRAINT IF EXISTS `fk_compliance_corrective_action_plan_responsible_owner_employee_id`;
ALTER TABLE `compliance`.`corrective_action_plan` ADD CONSTRAINT `fk_compliance_corrective_action_plan_responsible_owner_employee_id` FOREIGN KEY (`responsible_owner_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`evidence_record` DROP CONSTRAINT IF EXISTS `fk_compliance_evidence_record_primary_evidence_custodian_employee_id`;
ALTER TABLE `compliance`.`evidence_record` ADD CONSTRAINT `fk_compliance_evidence_record_primary_evidence_custodian_employee_id` FOREIGN KEY (`primary_evidence_custodian_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`evidence_record` DROP CONSTRAINT IF EXISTS `fk_compliance_evidence_record_quaternary_evidence_last_modified_by_employee_id`;
ALTER TABLE `compliance`.`evidence_record` ADD CONSTRAINT `fk_compliance_evidence_record_quaternary_evidence_last_modified_by_employee_id` FOREIGN KEY (`quaternary_evidence_last_modified_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`evidence_record` DROP CONSTRAINT IF EXISTS `fk_compliance_evidence_record_tertiary_evidence_created_by_employee_id`;
ALTER TABLE `compliance`.`evidence_record` ADD CONSTRAINT `fk_compliance_evidence_record_tertiary_evidence_created_by_employee_id` FOREIGN KEY (`tertiary_evidence_created_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`regulatory_correspondence` DROP CONSTRAINT IF EXISTS `fk_compliance_regulatory_correspondence_responding_party_employee_id`;
ALTER TABLE `compliance`.`regulatory_correspondence` ADD CONSTRAINT `fk_compliance_regulatory_correspondence_responding_party_employee_id` FOREIGN KEY (`responding_party_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`nerc_cip_asset` DROP CONSTRAINT IF EXISTS `fk_compliance_nerc_cip_asset_responsible_senior_manager_employee_id`;
ALTER TABLE `compliance`.`nerc_cip_asset` ADD CONSTRAINT `fk_compliance_nerc_cip_asset_responsible_senior_manager_employee_id` FOREIGN KEY (`responsible_senior_manager_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`emissions_report` DROP CONSTRAINT IF EXISTS `fk_compliance_emissions_report_preparer_employee_id`;
ALTER TABLE `compliance`.`emissions_report` ADD CONSTRAINT `fk_compliance_emissions_report_preparer_employee_id` FOREIGN KEY (`preparer_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`environmental_permit` DROP CONSTRAINT IF EXISTS `fk_compliance_environmental_permit_employee_id`;
ALTER TABLE `compliance`.`environmental_permit` ADD CONSTRAINT `fk_compliance_environmental_permit_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`rate_case` DROP CONSTRAINT IF EXISTS `fk_compliance_rate_case_lead_attorney_employee_id`;
ALTER TABLE `compliance`.`rate_case` ADD CONSTRAINT `fk_compliance_rate_case_lead_attorney_employee_id` FOREIGN KEY (`lead_attorney_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`sox_control` DROP CONSTRAINT IF EXISTS `fk_compliance_sox_control_process_owner_employee_id`;
ALTER TABLE `compliance`.`sox_control` ADD CONSTRAINT `fk_compliance_sox_control_process_owner_employee_id` FOREIGN KEY (`process_owner_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`program` DROP CONSTRAINT IF EXISTS `fk_compliance_program_owner_employee_id`;
ALTER TABLE `compliance`.`program` ADD CONSTRAINT `fk_compliance_program_owner_employee_id` FOREIGN KEY (`owner_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`program` DROP CONSTRAINT IF EXISTS `fk_compliance_program_owner_org_unit_id`;
ALTER TABLE `compliance`.`program` ADD CONSTRAINT `fk_compliance_program_owner_org_unit_id` FOREIGN KEY (`owner_org_unit_id`) REFERENCES `workforce`.`org_unit` (`org_unit_id`);

ALTER TABLE `compliance`.`training_record` DROP CONSTRAINT IF EXISTS `fk_compliance_training_record_employee_id`;
ALTER TABLE `compliance`.`training_record` ADD CONSTRAINT `fk_compliance_training_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`self_report` DROP CONSTRAINT IF EXISTS `fk_compliance_self_report_responsible_manager_employee_id`;
ALTER TABLE `compliance`.`self_report` ADD CONSTRAINT `fk_compliance_self_report_responsible_manager_employee_id` FOREIGN KEY (`responsible_manager_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`cpcn_application` DROP CONSTRAINT IF EXISTS `fk_compliance_cpcn_application_project_manager_employee_id`;
ALTER TABLE `compliance`.`cpcn_application` ADD CONSTRAINT `fk_compliance_cpcn_application_project_manager_employee_id` FOREIGN KEY (`project_manager_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`irp_filing` DROP CONSTRAINT IF EXISTS `fk_compliance_irp_filing_lead_planner_employee_id`;
ALTER TABLE `compliance`.`irp_filing` ADD CONSTRAINT `fk_compliance_irp_filing_lead_planner_employee_id` FOREIGN KEY (`lead_planner_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`penalty_assessment` DROP CONSTRAINT IF EXISTS `fk_compliance_penalty_assessment_responsible_business_unit_org_unit_id`;
ALTER TABLE `compliance`.`penalty_assessment` ADD CONSTRAINT `fk_compliance_penalty_assessment_responsible_business_unit_org_unit_id` FOREIGN KEY (`responsible_business_unit_org_unit_id`) REFERENCES `workforce`.`org_unit` (`org_unit_id`);

ALTER TABLE `compliance`.`exception` DROP CONSTRAINT IF EXISTS `fk_compliance_exception_responsible_owner_employee_id`;
ALTER TABLE `compliance`.`exception` ADD CONSTRAINT `fk_compliance_exception_responsible_owner_employee_id` FOREIGN KEY (`responsible_owner_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`ferc_market_report` DROP CONSTRAINT IF EXISTS `fk_compliance_ferc_market_report_preparer_employee_id`;
ALTER TABLE `compliance`.`ferc_market_report` ADD CONSTRAINT `fk_compliance_ferc_market_report_preparer_employee_id` FOREIGN KEY (`preparer_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`compliance_risk_assessment` DROP CONSTRAINT IF EXISTS `fk_compliance_compliance_risk_assessment_assessor_employee_id`;
ALTER TABLE `compliance`.`compliance_risk_assessment` ADD CONSTRAINT `fk_compliance_compliance_risk_assessment_assessor_employee_id` FOREIGN KEY (`assessor_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`audit_scope` DROP CONSTRAINT IF EXISTS `fk_compliance_audit_scope_org_unit_id`;
ALTER TABLE `compliance`.`audit_scope` ADD CONSTRAINT `fk_compliance_audit_scope_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `workforce`.`org_unit` (`org_unit_id`);

ALTER TABLE `compliance`.`audit_scope` DROP CONSTRAINT IF EXISTS `fk_compliance_audit_scope_unit_coordinator_employee_id`;
ALTER TABLE `compliance`.`audit_scope` ADD CONSTRAINT `fk_compliance_audit_scope_unit_coordinator_employee_id` FOREIGN KEY (`unit_coordinator_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `compliance`.`violation` DROP CONSTRAINT IF EXISTS `fk_compliance_violation_location_id`;
ALTER TABLE `compliance`.`violation` ADD CONSTRAINT `fk_compliance_violation_location_id` FOREIGN KEY (`location_id`) REFERENCES `workforce`.`work_location` (`work_location_id`);

ALTER TABLE `compliance`.`cyber_security_incident_response_plan` DROP CONSTRAINT IF EXISTS `fk_compliance_cyber_security_incident_response_plan_employee_id`;
ALTER TABLE `compliance`.`cyber_security_incident_response_plan` ADD CONSTRAINT `fk_compliance_cyber_security_incident_response_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

-- ========= customer --> asset (8) =========
ALTER TABLE `customer`.`account` DROP CONSTRAINT IF EXISTS `fk_customer_account_primary_service_asset_registry_id`;
ALTER TABLE `customer`.`account` ADD CONSTRAINT `fk_customer_account_primary_service_asset_registry_id` FOREIGN KEY (`primary_service_asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `customer`.`customer_service_agreement` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_agreement_service_delivery_asset_registry_id`;
ALTER TABLE `customer`.`customer_service_agreement` ADD CONSTRAINT `fk_customer_customer_service_agreement_service_delivery_asset_registry_id` FOREIGN KEY (`service_delivery_asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `customer`.`customer_service_request` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_request_registry_id`;
ALTER TABLE `customer`.`customer_service_request` ADD CONSTRAINT `fk_customer_customer_service_request_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `customer`.`customer_service_request` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_request_work_order_id`;
ALTER TABLE `customer`.`customer_service_request` ADD CONSTRAINT `fk_customer_customer_service_request_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `customer`.`complaint` DROP CONSTRAINT IF EXISTS `fk_customer_complaint_registry_id`;
ALTER TABLE `customer`.`complaint` ADD CONSTRAINT `fk_customer_complaint_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `customer`.`customer_enrollment` DROP CONSTRAINT IF EXISTS `fk_customer_customer_enrollment_interconnection_asset_registry_id`;
ALTER TABLE `customer`.`customer_enrollment` ADD CONSTRAINT `fk_customer_customer_enrollment_interconnection_asset_registry_id` FOREIGN KEY (`interconnection_asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `customer`.`premise_asset_connection` DROP CONSTRAINT IF EXISTS `fk_customer_premise_asset_connection_registry_id`;
ALTER TABLE `customer`.`premise_asset_connection` ADD CONSTRAINT `fk_customer_premise_asset_connection_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `customer`.`field_order` DROP CONSTRAINT IF EXISTS `fk_customer_field_order_registry_id`;
ALTER TABLE `customer`.`field_order` ADD CONSTRAINT `fk_customer_field_order_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

-- ========= customer --> billing (1) =========
ALTER TABLE `customer`.`customer_enrollment` DROP CONSTRAINT IF EXISTS `fk_customer_customer_enrollment_financial_assistance_program_id`;
ALTER TABLE `customer`.`customer_enrollment` ADD CONSTRAINT `fk_customer_customer_enrollment_financial_assistance_program_id` FOREIGN KEY (`financial_assistance_program_id`) REFERENCES `billing`.`assistance_program` (`assistance_program_id`);

-- ========= customer --> demand (5) =========
ALTER TABLE `customer`.`customer_enrollment` DROP CONSTRAINT IF EXISTS `fk_customer_customer_enrollment_dr_program_id`;
ALTER TABLE `customer`.`customer_enrollment` ADD CONSTRAINT `fk_customer_customer_enrollment_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `customer`.`third_party_authorization` DROP CONSTRAINT IF EXISTS `fk_customer_third_party_authorization_dr_program_id`;
ALTER TABLE `customer`.`third_party_authorization` ADD CONSTRAINT `fk_customer_third_party_authorization_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `customer`.`third_party_authorization` DROP CONSTRAINT IF EXISTS `fk_customer_third_party_authorization_ferc_aggregator_id`;
ALTER TABLE `customer`.`third_party_authorization` ADD CONSTRAINT `fk_customer_third_party_authorization_ferc_aggregator_id` FOREIGN KEY (`ferc_aggregator_id`) REFERENCES `demand`.`aggregator` (`aggregator_id`);

ALTER TABLE `customer`.`customer_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_customer_customer_dr_enrollment_dr_enrollment_id`;
ALTER TABLE `customer`.`customer_dr_enrollment` ADD CONSTRAINT `fk_customer_customer_dr_enrollment_dr_enrollment_id` FOREIGN KEY (`dr_enrollment_id`) REFERENCES `demand`.`demand_dr_enrollment` (`demand_dr_enrollment_id`);

ALTER TABLE `customer`.`customer_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_customer_customer_dr_enrollment_dr_program_id`;
ALTER TABLE `customer`.`customer_dr_enrollment` ADD CONSTRAINT `fk_customer_customer_dr_enrollment_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

-- ========= customer --> distribution (7) =========
ALTER TABLE `customer`.`premise` DROP CONSTRAINT IF EXISTS `fk_customer_premise_distribution_feeder_id`;
ALTER TABLE `customer`.`premise` ADD CONSTRAINT `fk_customer_premise_distribution_feeder_id` FOREIGN KEY (`distribution_feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `customer`.`premise` DROP CONSTRAINT IF EXISTS `fk_customer_premise_distribution_substation_id`;
ALTER TABLE `customer`.`premise` ADD CONSTRAINT `fk_customer_premise_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `customer`.`premise` DROP CONSTRAINT IF EXISTS `fk_customer_premise_distribution_transformer_id`;
ALTER TABLE `customer`.`premise` ADD CONSTRAINT `fk_customer_premise_distribution_transformer_id` FOREIGN KEY (`distribution_transformer_id`) REFERENCES `distribution`.`transformer` (`transformer_id`);

ALTER TABLE `customer`.`customer_service_agreement` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_agreement_der_interconnection_point_id`;
ALTER TABLE `customer`.`customer_service_agreement` ADD CONSTRAINT `fk_customer_customer_service_agreement_der_interconnection_point_id` FOREIGN KEY (`der_interconnection_point_id`) REFERENCES `distribution`.`der_interconnection_point` (`der_interconnection_point_id`);

ALTER TABLE `customer`.`customer_service_request` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_request_distribution_transformer_id`;
ALTER TABLE `customer`.`customer_service_request` ADD CONSTRAINT `fk_customer_customer_service_request_distribution_transformer_id` FOREIGN KEY (`distribution_transformer_id`) REFERENCES `distribution`.`transformer` (`transformer_id`);

ALTER TABLE `customer`.`customer_service_request` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_request_feeder_id`;
ALTER TABLE `customer`.`customer_service_request` ADD CONSTRAINT `fk_customer_customer_service_request_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `customer`.`complaint` DROP CONSTRAINT IF EXISTS `fk_customer_complaint_feeder_id`;
ALTER TABLE `customer`.`complaint` ADD CONSTRAINT `fk_customer_complaint_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

-- ========= customer --> finance (5) =========
ALTER TABLE `customer`.`account` DROP CONSTRAINT IF EXISTS `fk_customer_account_cost_center_id`;
ALTER TABLE `customer`.`account` ADD CONSTRAINT `fk_customer_account_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `customer`.`premise` DROP CONSTRAINT IF EXISTS `fk_customer_premise_cost_center_id`;
ALTER TABLE `customer`.`premise` ADD CONSTRAINT `fk_customer_premise_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `customer`.`customer_service_request` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_request_cost_center_id`;
ALTER TABLE `customer`.`customer_service_request` ADD CONSTRAINT `fk_customer_customer_service_request_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `customer`.`customer_service_request` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_request_internal_order_id`;
ALTER TABLE `customer`.`customer_service_request` ADD CONSTRAINT `fk_customer_customer_service_request_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `finance`.`internal_order` (`internal_order_id`);

ALTER TABLE `customer`.`complaint` DROP CONSTRAINT IF EXISTS `fk_customer_complaint_cost_center_id`;
ALTER TABLE `customer`.`complaint` ADD CONSTRAINT `fk_customer_complaint_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

-- ========= customer --> forecast (2) =========
ALTER TABLE `customer`.`premise` DROP CONSTRAINT IF EXISTS `fk_customer_premise_forecast_zone_id`;
ALTER TABLE `customer`.`premise` ADD CONSTRAINT `fk_customer_premise_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `customer`.`segment` DROP CONSTRAINT IF EXISTS `fk_customer_segment_planning_assumption_id`;
ALTER TABLE `customer`.`segment` ADD CONSTRAINT `fk_customer_segment_planning_assumption_id` FOREIGN KEY (`planning_assumption_id`) REFERENCES `forecast`.`planning_assumption` (`planning_assumption_id`);

-- ========= customer --> gis (2) =========
ALTER TABLE `customer`.`premise` DROP CONSTRAINT IF EXISTS `fk_customer_premise_gis_location_id`;
ALTER TABLE `customer`.`premise` ADD CONSTRAINT `fk_customer_premise_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `customer`.`address` DROP CONSTRAINT IF EXISTS `fk_customer_address_gis_location_id`;
ALTER TABLE `customer`.`address` ADD CONSTRAINT `fk_customer_address_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

-- ========= customer --> grid (5) =========
ALTER TABLE `customer`.`account` DROP CONSTRAINT IF EXISTS `fk_customer_account_control_area_id`;
ALTER TABLE `customer`.`account` ADD CONSTRAINT `fk_customer_account_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `customer`.`premise` DROP CONSTRAINT IF EXISTS `fk_customer_premise_control_area_id`;
ALTER TABLE `customer`.`premise` ADD CONSTRAINT `fk_customer_premise_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `customer`.`customer_service_request` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_request_ems_alarm_id`;
ALTER TABLE `customer`.`customer_service_request` ADD CONSTRAINT `fk_customer_customer_service_request_ems_alarm_id` FOREIGN KEY (`ems_alarm_id`) REFERENCES `grid`.`ems_alarm` (`ems_alarm_id`);

ALTER TABLE `customer`.`complaint` DROP CONSTRAINT IF EXISTS `fk_customer_complaint_ems_alarm_id`;
ALTER TABLE `customer`.`complaint` ADD CONSTRAINT `fk_customer_complaint_ems_alarm_id` FOREIGN KEY (`ems_alarm_id`) REFERENCES `grid`.`ems_alarm` (`ems_alarm_id`);

ALTER TABLE `customer`.`complaint` DROP CONSTRAINT IF EXISTS `fk_customer_complaint_grid_reliability_event_id`;
ALTER TABLE `customer`.`complaint` ADD CONSTRAINT `fk_customer_complaint_grid_reliability_event_id` FOREIGN KEY (`grid_reliability_event_id`) REFERENCES `grid`.`grid_reliability_event` (`grid_reliability_event_id`);

-- ========= customer --> interconnection (3) =========
ALTER TABLE `customer`.`customer_service_request` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_request_interconnection_application_id`;
ALTER TABLE `customer`.`customer_service_request` ADD CONSTRAINT `fk_customer_customer_service_request_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `customer`.`complaint` DROP CONSTRAINT IF EXISTS `fk_customer_complaint_interconnection_application_id`;
ALTER TABLE `customer`.`complaint` ADD CONSTRAINT `fk_customer_complaint_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `customer`.`customer_enrollment` DROP CONSTRAINT IF EXISTS `fk_customer_customer_enrollment_interconnection_application_id`;
ALTER TABLE `customer`.`customer_enrollment` ADD CONSTRAINT `fk_customer_customer_enrollment_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

-- ========= customer --> metering (9) =========
ALTER TABLE `customer`.`premise` DROP CONSTRAINT IF EXISTS `fk_customer_premise_meter_reading_route_id`;
ALTER TABLE `customer`.`premise` ADD CONSTRAINT `fk_customer_premise_meter_reading_route_id` FOREIGN KEY (`meter_reading_route_id`) REFERENCES `metering`.`meter_reading_route` (`meter_reading_route_id`);

ALTER TABLE `customer`.`customer_service_request` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_request_meter_id`;
ALTER TABLE `customer`.`customer_service_request` ADD CONSTRAINT `fk_customer_customer_service_request_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `customer`.`complaint` DROP CONSTRAINT IF EXISTS `fk_customer_complaint_meter_id`;
ALTER TABLE `customer`.`complaint` ADD CONSTRAINT `fk_customer_complaint_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `customer`.`customer_enrollment` DROP CONSTRAINT IF EXISTS `fk_customer_customer_enrollment_meter_id`;
ALTER TABLE `customer`.`customer_enrollment` ADD CONSTRAINT `fk_customer_customer_enrollment_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `customer`.`move_order` DROP CONSTRAINT IF EXISTS `fk_customer_move_order_meter_id`;
ALTER TABLE `customer`.`move_order` ADD CONSTRAINT `fk_customer_move_order_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `customer`.`move_order` DROP CONSTRAINT IF EXISTS `fk_customer_move_order_meter_point_id`;
ALTER TABLE `customer`.`move_order` ADD CONSTRAINT `fk_customer_move_order_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `customer`.`premise_asset_connection` DROP CONSTRAINT IF EXISTS `fk_customer_premise_asset_connection_metering_point_id`;
ALTER TABLE `customer`.`premise_asset_connection` ADD CONSTRAINT `fk_customer_premise_asset_connection_metering_point_id` FOREIGN KEY (`metering_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `customer`.`case` DROP CONSTRAINT IF EXISTS `fk_customer_case_meter_id`;
ALTER TABLE `customer`.`case` ADD CONSTRAINT `fk_customer_case_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `customer`.`field_order` DROP CONSTRAINT IF EXISTS `fk_customer_field_order_meter_id`;
ALTER TABLE `customer`.`field_order` ADD CONSTRAINT `fk_customer_field_order_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

-- ========= customer --> outage (2) =========
ALTER TABLE `customer`.`interaction` DROP CONSTRAINT IF EXISTS `fk_customer_interaction_event_id`;
ALTER TABLE `customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `customer`.`complaint` DROP CONSTRAINT IF EXISTS `fk_customer_complaint_event_id`;
ALTER TABLE `customer`.`complaint` ADD CONSTRAINT `fk_customer_complaint_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

-- ========= customer --> renewable (8) =========
ALTER TABLE `customer`.`customer_service_agreement` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_agreement_ppa_contract_id`;
ALTER TABLE `customer`.`customer_service_agreement` ADD CONSTRAINT `fk_customer_customer_service_agreement_ppa_contract_id` FOREIGN KEY (`ppa_contract_id`) REFERENCES `renewable`.`ppa_contract` (`ppa_contract_id`);

ALTER TABLE `customer`.`customer_service_request` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_request_der_registry_id`;
ALTER TABLE `customer`.`customer_service_request` ADD CONSTRAINT `fk_customer_customer_service_request_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `customer`.`complaint` DROP CONSTRAINT IF EXISTS `fk_customer_complaint_der_registry_id`;
ALTER TABLE `customer`.`complaint` ADD CONSTRAINT `fk_customer_complaint_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `customer`.`customer_enrollment` DROP CONSTRAINT IF EXISTS `fk_customer_customer_enrollment_der_registry_id`;
ALTER TABLE `customer`.`customer_enrollment` ADD CONSTRAINT `fk_customer_customer_enrollment_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `customer`.`customer_enrollment` DROP CONSTRAINT IF EXISTS `fk_customer_customer_enrollment_incentive_program_id`;
ALTER TABLE `customer`.`customer_enrollment` ADD CONSTRAINT `fk_customer_customer_enrollment_incentive_program_id` FOREIGN KEY (`incentive_program_id`) REFERENCES `renewable`.`incentive_program` (`incentive_program_id`);

ALTER TABLE `customer`.`customer_enrollment` DROP CONSTRAINT IF EXISTS `fk_customer_customer_enrollment_vpp_configuration_id`;
ALTER TABLE `customer`.`customer_enrollment` ADD CONSTRAINT `fk_customer_customer_enrollment_vpp_configuration_id` FOREIGN KEY (`vpp_configuration_id`) REFERENCES `renewable`.`vpp_configuration` (`vpp_configuration_id`);

ALTER TABLE `customer`.`third_party_authorization` DROP CONSTRAINT IF EXISTS `fk_customer_third_party_authorization_ppa_contract_id`;
ALTER TABLE `customer`.`third_party_authorization` ADD CONSTRAINT `fk_customer_third_party_authorization_ppa_contract_id` FOREIGN KEY (`ppa_contract_id`) REFERENCES `renewable`.`ppa_contract` (`ppa_contract_id`);

ALTER TABLE `customer`.`incentive_enrollment` DROP CONSTRAINT IF EXISTS `fk_customer_incentive_enrollment_renewable_incentive_program_id`;
ALTER TABLE `customer`.`incentive_enrollment` ADD CONSTRAINT `fk_customer_incentive_enrollment_renewable_incentive_program_id` FOREIGN KEY (`renewable_incentive_program_id`) REFERENCES `renewable`.`incentive_program` (`incentive_program_id`);

-- ========= customer --> supply (5) =========
ALTER TABLE `customer`.`premise` DROP CONSTRAINT IF EXISTS `fk_customer_premise_primary_warehouse_id`;
ALTER TABLE `customer`.`premise` ADD CONSTRAINT `fk_customer_premise_primary_warehouse_id` FOREIGN KEY (`primary_warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `customer`.`customer_service_agreement` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_agreement_vendor_id`;
ALTER TABLE `customer`.`customer_service_agreement` ADD CONSTRAINT `fk_customer_customer_service_agreement_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `customer`.`customer_service_request` DROP CONSTRAINT IF EXISTS `fk_customer_customer_service_request_warehouse_id`;
ALTER TABLE `customer`.`customer_service_request` ADD CONSTRAINT `fk_customer_customer_service_request_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `customer`.`customer_enrollment` DROP CONSTRAINT IF EXISTS `fk_customer_customer_enrollment_material_master_id`;
ALTER TABLE `customer`.`customer_enrollment` ADD CONSTRAINT `fk_customer_customer_enrollment_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `customer`.`premise_service_contract` DROP CONSTRAINT IF EXISTS `fk_customer_premise_service_contract_vendor_id`;
ALTER TABLE `customer`.`premise_service_contract` ADD CONSTRAINT `fk_customer_premise_service_contract_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

-- ========= customer --> workforce (7) =========
ALTER TABLE `customer`.`interaction` DROP CONSTRAINT IF EXISTS `fk_customer_interaction_employee_id`;
ALTER TABLE `customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `customer`.`complaint` DROP CONSTRAINT IF EXISTS `fk_customer_complaint_employee_id`;
ALTER TABLE `customer`.`complaint` ADD CONSTRAINT `fk_customer_complaint_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `customer`.`third_party_authorization` DROP CONSTRAINT IF EXISTS `fk_customer_third_party_authorization_employee_id`;
ALTER TABLE `customer`.`third_party_authorization` ADD CONSTRAINT `fk_customer_third_party_authorization_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `customer`.`case` DROP CONSTRAINT IF EXISTS `fk_customer_case_employee_id`;
ALTER TABLE `customer`.`case` ADD CONSTRAINT `fk_customer_case_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `customer`.`field_order` DROP CONSTRAINT IF EXISTS `fk_customer_field_order_assigned_crew_id`;
ALTER TABLE `customer`.`field_order` ADD CONSTRAINT `fk_customer_field_order_assigned_crew_id` FOREIGN KEY (`assigned_crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `customer`.`field_order` DROP CONSTRAINT IF EXISTS `fk_customer_field_order_employee_id`;
ALTER TABLE `customer`.`field_order` ADD CONSTRAINT `fk_customer_field_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `customer`.`field_order` DROP CONSTRAINT IF EXISTS `fk_customer_field_order_last_modified_by_user_employee_id`;
ALTER TABLE `customer`.`field_order` ADD CONSTRAINT `fk_customer_field_order_last_modified_by_user_employee_id` FOREIGN KEY (`last_modified_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

-- ========= demand --> asset (2) =========
ALTER TABLE `demand`.`direct_load_control_device` DROP CONSTRAINT IF EXISTS `fk_demand_direct_load_control_device_registry_id`;
ALTER TABLE `demand`.`direct_load_control_device` ADD CONSTRAINT `fk_demand_direct_load_control_device_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `demand`.`vpp_dispatch` DROP CONSTRAINT IF EXISTS `fk_demand_vpp_dispatch_registry_id`;
ALTER TABLE `demand`.`vpp_dispatch` ADD CONSTRAINT `fk_demand_vpp_dispatch_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

-- ========= demand --> compliance (14) =========
ALTER TABLE `demand`.`dr_program` DROP CONSTRAINT IF EXISTS `fk_demand_dr_program_obligation_id`;
ALTER TABLE `demand`.`dr_program` ADD CONSTRAINT `fk_demand_dr_program_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_audit_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_obligation_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `demand`.`curtailment_measurement` DROP CONSTRAINT IF EXISTS `fk_demand_curtailment_measurement_audit_id`;
ALTER TABLE `demand`.`curtailment_measurement` ADD CONSTRAINT `fk_demand_curtailment_measurement_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `demand`.`dr_incentive_payment` DROP CONSTRAINT IF EXISTS `fk_demand_dr_incentive_payment_audit_id`;
ALTER TABLE `demand`.`dr_incentive_payment` ADD CONSTRAINT `fk_demand_dr_incentive_payment_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `demand`.`aggregator` DROP CONSTRAINT IF EXISTS `fk_demand_aggregator_audit_id`;
ALTER TABLE `demand`.`aggregator` ADD CONSTRAINT `fk_demand_aggregator_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `demand`.`aggregator` DROP CONSTRAINT IF EXISTS `fk_demand_aggregator_obligation_id`;
ALTER TABLE `demand`.`aggregator` ADD CONSTRAINT `fk_demand_aggregator_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `demand`.`interruptible_tariff_agreement` DROP CONSTRAINT IF EXISTS `fk_demand_interruptible_tariff_agreement_obligation_id`;
ALTER TABLE `demand`.`interruptible_tariff_agreement` ADD CONSTRAINT `fk_demand_interruptible_tariff_agreement_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `demand`.`direct_load_control_device` DROP CONSTRAINT IF EXISTS `fk_demand_direct_load_control_device_nerc_cip_asset_id`;
ALTER TABLE `demand`.`direct_load_control_device` ADD CONSTRAINT `fk_demand_direct_load_control_device_nerc_cip_asset_id` FOREIGN KEY (`nerc_cip_asset_id`) REFERENCES `compliance`.`nerc_cip_asset` (`nerc_cip_asset_id`);

ALTER TABLE `demand`.`vpp_dispatch` DROP CONSTRAINT IF EXISTS `fk_demand_vpp_dispatch_audit_id`;
ALTER TABLE `demand`.`vpp_dispatch` ADD CONSTRAINT `fk_demand_vpp_dispatch_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `demand`.`dr_capacity_registration` DROP CONSTRAINT IF EXISTS `fk_demand_dr_capacity_registration_obligation_id`;
ALTER TABLE `demand`.`dr_capacity_registration` ADD CONSTRAINT `fk_demand_dr_capacity_registration_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `demand`.`dr_compliance_report` DROP CONSTRAINT IF EXISTS `fk_demand_dr_compliance_report_audit_id`;
ALTER TABLE `demand`.`dr_compliance_report` ADD CONSTRAINT `fk_demand_dr_compliance_report_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `demand`.`dr_compliance_report` DROP CONSTRAINT IF EXISTS `fk_demand_dr_compliance_report_obligation_id`;
ALTER TABLE `demand`.`dr_compliance_report` ADD CONSTRAINT `fk_demand_dr_compliance_report_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `demand`.`dr_compliance_report` DROP CONSTRAINT IF EXISTS `fk_demand_dr_compliance_report_regulatory_filing_id`;
ALTER TABLE `demand`.`dr_compliance_report` ADD CONSTRAINT `fk_demand_dr_compliance_report_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

-- ========= demand --> customer (15) =========
ALTER TABLE `demand`.`demand_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_demand_demand_dr_enrollment_account_id`;
ALTER TABLE `demand`.`demand_dr_enrollment` ADD CONSTRAINT `fk_demand_demand_dr_enrollment_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `demand`.`demand_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_demand_demand_dr_enrollment_customer_service_agreement_id`;
ALTER TABLE `demand`.`demand_dr_enrollment` ADD CONSTRAINT `fk_demand_demand_dr_enrollment_customer_service_agreement_id` FOREIGN KEY (`customer_service_agreement_id`) REFERENCES `customer`.`customer_service_agreement` (`customer_service_agreement_id`);

ALTER TABLE `demand`.`dr_event_participant` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_participant_account_id`;
ALTER TABLE `demand`.`dr_event_participant` ADD CONSTRAINT `fk_demand_dr_event_participant_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `demand`.`dr_event_participant` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_participant_premise_id`;
ALTER TABLE `demand`.`dr_event_participant` ADD CONSTRAINT `fk_demand_dr_event_participant_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `demand`.`load_baseline` DROP CONSTRAINT IF EXISTS `fk_demand_load_baseline_premise_id`;
ALTER TABLE `demand`.`load_baseline` ADD CONSTRAINT `fk_demand_load_baseline_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `demand`.`load_baseline` DROP CONSTRAINT IF EXISTS `fk_demand_load_baseline_profile_id`;
ALTER TABLE `demand`.`load_baseline` ADD CONSTRAINT `fk_demand_load_baseline_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `customer`.`profile` (`profile_id`);

ALTER TABLE `demand`.`dr_incentive_payment` DROP CONSTRAINT IF EXISTS `fk_demand_dr_incentive_payment_account_id`;
ALTER TABLE `demand`.`dr_incentive_payment` ADD CONSTRAINT `fk_demand_dr_incentive_payment_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `demand`.`dr_incentive_payment` DROP CONSTRAINT IF EXISTS `fk_demand_dr_incentive_payment_profile_id`;
ALTER TABLE `demand`.`dr_incentive_payment` ADD CONSTRAINT `fk_demand_dr_incentive_payment_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `customer`.`profile` (`profile_id`);

ALTER TABLE `demand`.`interruptible_tariff_agreement` DROP CONSTRAINT IF EXISTS `fk_demand_interruptible_tariff_agreement_account_id`;
ALTER TABLE `demand`.`interruptible_tariff_agreement` ADD CONSTRAINT `fk_demand_interruptible_tariff_agreement_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `demand`.`interruptible_tariff_agreement` DROP CONSTRAINT IF EXISTS `fk_demand_interruptible_tariff_agreement_premise_id`;
ALTER TABLE `demand`.`interruptible_tariff_agreement` ADD CONSTRAINT `fk_demand_interruptible_tariff_agreement_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `demand`.`direct_load_control_device` DROP CONSTRAINT IF EXISTS `fk_demand_direct_load_control_device_account_id`;
ALTER TABLE `demand`.`direct_load_control_device` ADD CONSTRAINT `fk_demand_direct_load_control_device_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `demand`.`direct_load_control_device` DROP CONSTRAINT IF EXISTS `fk_demand_direct_load_control_device_premise_id`;
ALTER TABLE `demand`.`direct_load_control_device` ADD CONSTRAINT `fk_demand_direct_load_control_device_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `demand`.`dr_capacity_registration` DROP CONSTRAINT IF EXISTS `fk_demand_dr_capacity_registration_account_id`;
ALTER TABLE `demand`.`dr_capacity_registration` ADD CONSTRAINT `fk_demand_dr_capacity_registration_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `demand`.`dr_capacity_registration` DROP CONSTRAINT IF EXISTS `fk_demand_dr_capacity_registration_premise_id`;
ALTER TABLE `demand`.`dr_capacity_registration` ADD CONSTRAINT `fk_demand_dr_capacity_registration_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `demand`.`aggregation` DROP CONSTRAINT IF EXISTS `fk_demand_aggregation_settlement_account_id`;
ALTER TABLE `demand`.`aggregation` ADD CONSTRAINT `fk_demand_aggregation_settlement_account_id` FOREIGN KEY (`settlement_account_id`) REFERENCES `customer`.`account` (`account_id`);

-- ========= demand --> distribution (7) =========
ALTER TABLE `demand`.`dr_program` DROP CONSTRAINT IF EXISTS `fk_demand_dr_program_service_territory_id`;
ALTER TABLE `demand`.`dr_program` ADD CONSTRAINT `fk_demand_dr_program_service_territory_id` FOREIGN KEY (`service_territory_id`) REFERENCES `distribution`.`service_territory` (`service_territory_id`);

ALTER TABLE `demand`.`demand_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_demand_demand_dr_enrollment_der_interconnection_point_id`;
ALTER TABLE `demand`.`demand_dr_enrollment` ADD CONSTRAINT `fk_demand_demand_dr_enrollment_der_interconnection_point_id` FOREIGN KEY (`der_interconnection_point_id`) REFERENCES `distribution`.`der_interconnection_point` (`der_interconnection_point_id`);

ALTER TABLE `demand`.`demand_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_demand_demand_dr_enrollment_distribution_transformer_id`;
ALTER TABLE `demand`.`demand_dr_enrollment` ADD CONSTRAINT `fk_demand_demand_dr_enrollment_distribution_transformer_id` FOREIGN KEY (`distribution_transformer_id`) REFERENCES `distribution`.`transformer` (`transformer_id`);

ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_distribution_substation_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_feeder_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `demand`.`direct_load_control_device` DROP CONSTRAINT IF EXISTS `fk_demand_direct_load_control_device_distribution_transformer_id`;
ALTER TABLE `demand`.`direct_load_control_device` ADD CONSTRAINT `fk_demand_direct_load_control_device_distribution_transformer_id` FOREIGN KEY (`distribution_transformer_id`) REFERENCES `distribution`.`transformer` (`transformer_id`);

ALTER TABLE `demand`.`vpp_dispatch` DROP CONSTRAINT IF EXISTS `fk_demand_vpp_dispatch_der_interconnection_point_id`;
ALTER TABLE `demand`.`vpp_dispatch` ADD CONSTRAINT `fk_demand_vpp_dispatch_der_interconnection_point_id` FOREIGN KEY (`der_interconnection_point_id`) REFERENCES `distribution`.`der_interconnection_point` (`der_interconnection_point_id`);

-- ========= demand --> finance (11) =========
ALTER TABLE `demand`.`dr_program` DROP CONSTRAINT IF EXISTS `fk_demand_dr_program_cost_center_id`;
ALTER TABLE `demand`.`dr_program` ADD CONSTRAINT `fk_demand_dr_program_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `demand`.`dr_program` DROP CONSTRAINT IF EXISTS `fk_demand_dr_program_profit_center_id`;
ALTER TABLE `demand`.`dr_program` ADD CONSTRAINT `fk_demand_dr_program_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_cost_center_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `demand`.`curtailment_measurement` DROP CONSTRAINT IF EXISTS `fk_demand_curtailment_measurement_gl_account_id`;
ALTER TABLE `demand`.`curtailment_measurement` ADD CONSTRAINT `fk_demand_curtailment_measurement_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `demand`.`dr_incentive_payment` DROP CONSTRAINT IF EXISTS `fk_demand_dr_incentive_payment_cost_center_id`;
ALTER TABLE `demand`.`dr_incentive_payment` ADD CONSTRAINT `fk_demand_dr_incentive_payment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `demand`.`dr_incentive_payment` DROP CONSTRAINT IF EXISTS `fk_demand_dr_incentive_payment_gl_account_id`;
ALTER TABLE `demand`.`dr_incentive_payment` ADD CONSTRAINT `fk_demand_dr_incentive_payment_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `demand`.`aggregator` DROP CONSTRAINT IF EXISTS `fk_demand_aggregator_cost_center_id`;
ALTER TABLE `demand`.`aggregator` ADD CONSTRAINT `fk_demand_aggregator_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `demand`.`interruptible_tariff_agreement` DROP CONSTRAINT IF EXISTS `fk_demand_interruptible_tariff_agreement_gl_account_id`;
ALTER TABLE `demand`.`interruptible_tariff_agreement` ADD CONSTRAINT `fk_demand_interruptible_tariff_agreement_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `demand`.`vpp_dispatch` DROP CONSTRAINT IF EXISTS `fk_demand_vpp_dispatch_cost_center_id`;
ALTER TABLE `demand`.`vpp_dispatch` ADD CONSTRAINT `fk_demand_vpp_dispatch_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `demand`.`dr_capacity_registration` DROP CONSTRAINT IF EXISTS `fk_demand_dr_capacity_registration_cost_center_id`;
ALTER TABLE `demand`.`dr_capacity_registration` ADD CONSTRAINT `fk_demand_dr_capacity_registration_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `demand`.`dr_compliance_report` DROP CONSTRAINT IF EXISTS `fk_demand_dr_compliance_report_cost_center_id`;
ALTER TABLE `demand`.`dr_compliance_report` ADD CONSTRAINT `fk_demand_dr_compliance_report_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

-- ========= demand --> forecast (19) =========
ALTER TABLE `demand`.`dr_program` DROP CONSTRAINT IF EXISTS `fk_demand_dr_program_forecast_zone_id`;
ALTER TABLE `demand`.`dr_program` ADD CONSTRAINT `fk_demand_dr_program_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `demand`.`demand_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_demand_demand_dr_enrollment_forecast_zone_id`;
ALTER TABLE `demand`.`demand_dr_enrollment` ADD CONSTRAINT `fk_demand_demand_dr_enrollment_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_load_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_zone_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `demand`.`dr_event_participant` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_participant_load_id`;
ALTER TABLE `demand`.`dr_event_participant` ADD CONSTRAINT `fk_demand_dr_event_participant_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `demand`.`load_baseline` DROP CONSTRAINT IF EXISTS `fk_demand_load_baseline_load_id`;
ALTER TABLE `demand`.`load_baseline` ADD CONSTRAINT `fk_demand_load_baseline_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `demand`.`curtailment_measurement` DROP CONSTRAINT IF EXISTS `fk_demand_curtailment_measurement_load_id`;
ALTER TABLE `demand`.`curtailment_measurement` ADD CONSTRAINT `fk_demand_curtailment_measurement_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `demand`.`dr_incentive_payment` DROP CONSTRAINT IF EXISTS `fk_demand_dr_incentive_payment_energy_price_id`;
ALTER TABLE `demand`.`dr_incentive_payment` ADD CONSTRAINT `fk_demand_dr_incentive_payment_energy_price_id` FOREIGN KEY (`energy_price_id`) REFERENCES `forecast`.`energy_price` (`energy_price_id`);

ALTER TABLE `demand`.`aggregator` DROP CONSTRAINT IF EXISTS `fk_demand_aggregator_forecast_zone_id`;
ALTER TABLE `demand`.`aggregator` ADD CONSTRAINT `fk_demand_aggregator_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `demand`.`interruptible_tariff_agreement` DROP CONSTRAINT IF EXISTS `fk_demand_interruptible_tariff_agreement_peak_demand_id`;
ALTER TABLE `demand`.`interruptible_tariff_agreement` ADD CONSTRAINT `fk_demand_interruptible_tariff_agreement_peak_demand_id` FOREIGN KEY (`peak_demand_id`) REFERENCES `forecast`.`peak_demand` (`peak_demand_id`);

ALTER TABLE `demand`.`direct_load_control_device` DROP CONSTRAINT IF EXISTS `fk_demand_direct_load_control_device_forecast_zone_id`;
ALTER TABLE `demand`.`direct_load_control_device` ADD CONSTRAINT `fk_demand_direct_load_control_device_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `demand`.`vpp_dispatch` DROP CONSTRAINT IF EXISTS `fk_demand_vpp_dispatch_energy_price_id`;
ALTER TABLE `demand`.`vpp_dispatch` ADD CONSTRAINT `fk_demand_vpp_dispatch_energy_price_id` FOREIGN KEY (`energy_price_id`) REFERENCES `forecast`.`energy_price` (`energy_price_id`);

ALTER TABLE `demand`.`vpp_dispatch` DROP CONSTRAINT IF EXISTS `fk_demand_vpp_dispatch_forecast_generation_id`;
ALTER TABLE `demand`.`vpp_dispatch` ADD CONSTRAINT `fk_demand_vpp_dispatch_forecast_generation_id` FOREIGN KEY (`forecast_generation_id`) REFERENCES `forecast`.`forecast_generation` (`forecast_generation_id`);

ALTER TABLE `demand`.`vpp_dispatch` DROP CONSTRAINT IF EXISTS `fk_demand_vpp_dispatch_load_id`;
ALTER TABLE `demand`.`vpp_dispatch` ADD CONSTRAINT `fk_demand_vpp_dispatch_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `demand`.`dr_capacity_registration` DROP CONSTRAINT IF EXISTS `fk_demand_dr_capacity_registration_capacity_requirement_id`;
ALTER TABLE `demand`.`dr_capacity_registration` ADD CONSTRAINT `fk_demand_dr_capacity_registration_capacity_requirement_id` FOREIGN KEY (`capacity_requirement_id`) REFERENCES `forecast`.`capacity_requirement` (`capacity_requirement_id`);

ALTER TABLE `demand`.`dr_capacity_registration` DROP CONSTRAINT IF EXISTS `fk_demand_dr_capacity_registration_forecast_zone_id`;
ALTER TABLE `demand`.`dr_capacity_registration` ADD CONSTRAINT `fk_demand_dr_capacity_registration_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `demand`.`dr_compliance_report` DROP CONSTRAINT IF EXISTS `fk_demand_dr_compliance_report_capacity_requirement_id`;
ALTER TABLE `demand`.`dr_compliance_report` ADD CONSTRAINT `fk_demand_dr_compliance_report_capacity_requirement_id` FOREIGN KEY (`capacity_requirement_id`) REFERENCES `forecast`.`capacity_requirement` (`capacity_requirement_id`);

ALTER TABLE `demand`.`dr_compliance_report` DROP CONSTRAINT IF EXISTS `fk_demand_dr_compliance_report_irp_scenario_id`;
ALTER TABLE `demand`.`dr_compliance_report` ADD CONSTRAINT `fk_demand_dr_compliance_report_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

ALTER TABLE `demand`.`irp_dr_program_assumption` DROP CONSTRAINT IF EXISTS `fk_demand_irp_dr_program_assumption_irp_scenario_id`;
ALTER TABLE `demand`.`irp_dr_program_assumption` ADD CONSTRAINT `fk_demand_irp_dr_program_assumption_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

-- ========= demand --> generation (1) =========
ALTER TABLE `demand`.`vpp_dispatch` DROP CONSTRAINT IF EXISTS `fk_demand_vpp_dispatch_dispatch_schedule_id`;
ALTER TABLE `demand`.`vpp_dispatch` ADD CONSTRAINT `fk_demand_vpp_dispatch_dispatch_schedule_id` FOREIGN KEY (`dispatch_schedule_id`) REFERENCES `generation`.`dispatch_schedule` (`dispatch_schedule_id`);

-- ========= demand --> gis (1) =========
ALTER TABLE `demand`.`direct_load_control_device` DROP CONSTRAINT IF EXISTS `fk_demand_direct_load_control_device_gis_location_id`;
ALTER TABLE `demand`.`direct_load_control_device` ADD CONSTRAINT `fk_demand_direct_load_control_device_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

-- ========= demand --> grid (4) =========
ALTER TABLE `demand`.`dr_program` DROP CONSTRAINT IF EXISTS `fk_demand_dr_program_control_area_id`;
ALTER TABLE `demand`.`dr_program` ADD CONSTRAINT `fk_demand_dr_program_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_control_area_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `demand`.`load_baseline` DROP CONSTRAINT IF EXISTS `fk_demand_load_baseline_control_area_id`;
ALTER TABLE `demand`.`load_baseline` ADD CONSTRAINT `fk_demand_load_baseline_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `demand`.`vpp_dispatch` DROP CONSTRAINT IF EXISTS `fk_demand_vpp_dispatch_control_area_id`;
ALTER TABLE `demand`.`vpp_dispatch` ADD CONSTRAINT `fk_demand_vpp_dispatch_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

-- ========= demand --> interconnection (18) =========
ALTER TABLE `demand`.`dr_program` DROP CONSTRAINT IF EXISTS `fk_demand_dr_program_interconnection_application_id`;
ALTER TABLE `demand`.`dr_program` ADD CONSTRAINT `fk_demand_dr_program_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `demand`.`demand_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_demand_demand_dr_enrollment_der_system_id`;
ALTER TABLE `demand`.`demand_dr_enrollment` ADD CONSTRAINT `fk_demand_demand_dr_enrollment_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `demand`.`demand_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_demand_demand_dr_enrollment_interconnection_application_id`;
ALTER TABLE `demand`.`demand_dr_enrollment` ADD CONSTRAINT `fk_demand_demand_dr_enrollment_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_der_system_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `demand`.`dr_event_participant` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_participant_der_system_id`;
ALTER TABLE `demand`.`dr_event_participant` ADD CONSTRAINT `fk_demand_dr_event_participant_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `demand`.`dr_event_participant` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_participant_interconnection_application_id`;
ALTER TABLE `demand`.`dr_event_participant` ADD CONSTRAINT `fk_demand_dr_event_participant_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `demand`.`load_baseline` DROP CONSTRAINT IF EXISTS `fk_demand_load_baseline_der_system_id`;
ALTER TABLE `demand`.`load_baseline` ADD CONSTRAINT `fk_demand_load_baseline_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `demand`.`curtailment_measurement` DROP CONSTRAINT IF EXISTS `fk_demand_curtailment_measurement_der_system_id`;
ALTER TABLE `demand`.`curtailment_measurement` ADD CONSTRAINT `fk_demand_curtailment_measurement_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `demand`.`dr_incentive_payment` DROP CONSTRAINT IF EXISTS `fk_demand_dr_incentive_payment_interconnection_application_id`;
ALTER TABLE `demand`.`dr_incentive_payment` ADD CONSTRAINT `fk_demand_dr_incentive_payment_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `demand`.`aggregator` DROP CONSTRAINT IF EXISTS `fk_demand_aggregator_der_installer_id`;
ALTER TABLE `demand`.`aggregator` ADD CONSTRAINT `fk_demand_aggregator_der_installer_id` FOREIGN KEY (`der_installer_id`) REFERENCES `interconnection`.`der_installer` (`der_installer_id`);

ALTER TABLE `demand`.`interruptible_tariff_agreement` DROP CONSTRAINT IF EXISTS `fk_demand_interruptible_tariff_agreement_interconnection_application_id`;
ALTER TABLE `demand`.`interruptible_tariff_agreement` ADD CONSTRAINT `fk_demand_interruptible_tariff_agreement_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `demand`.`direct_load_control_device` DROP CONSTRAINT IF EXISTS `fk_demand_direct_load_control_device_der_system_id`;
ALTER TABLE `demand`.`direct_load_control_device` ADD CONSTRAINT `fk_demand_direct_load_control_device_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `demand`.`vpp_dispatch` DROP CONSTRAINT IF EXISTS `fk_demand_vpp_dispatch_der_system_id`;
ALTER TABLE `demand`.`vpp_dispatch` ADD CONSTRAINT `fk_demand_vpp_dispatch_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `demand`.`dr_capacity_registration` DROP CONSTRAINT IF EXISTS `fk_demand_dr_capacity_registration_der_system_id`;
ALTER TABLE `demand`.`dr_capacity_registration` ADD CONSTRAINT `fk_demand_dr_capacity_registration_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `demand`.`dr_capacity_registration` DROP CONSTRAINT IF EXISTS `fk_demand_dr_capacity_registration_interconnection_application_id`;
ALTER TABLE `demand`.`dr_capacity_registration` ADD CONSTRAINT `fk_demand_dr_capacity_registration_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `demand`.`dr_compliance_report` DROP CONSTRAINT IF EXISTS `fk_demand_dr_compliance_report_interconnection_application_id`;
ALTER TABLE `demand`.`dr_compliance_report` ADD CONSTRAINT `fk_demand_dr_compliance_report_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `demand`.`aggregation` DROP CONSTRAINT IF EXISTS `fk_demand_aggregation_der_system_id`;
ALTER TABLE `demand`.`aggregation` ADD CONSTRAINT `fk_demand_aggregation_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `demand`.`demand_enrollment` DROP CONSTRAINT IF EXISTS `fk_demand_demand_enrollment_der_system_id`;
ALTER TABLE `demand`.`demand_enrollment` ADD CONSTRAINT `fk_demand_demand_enrollment_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

-- ========= demand --> metering (5) =========
ALTER TABLE `demand`.`demand_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_demand_demand_dr_enrollment_meter_id`;
ALTER TABLE `demand`.`demand_dr_enrollment` ADD CONSTRAINT `fk_demand_demand_dr_enrollment_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `demand`.`demand_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_demand_demand_dr_enrollment_meter_point_id`;
ALTER TABLE `demand`.`demand_dr_enrollment` ADD CONSTRAINT `fk_demand_demand_dr_enrollment_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `demand`.`load_baseline` DROP CONSTRAINT IF EXISTS `fk_demand_load_baseline_meter_id`;
ALTER TABLE `demand`.`load_baseline` ADD CONSTRAINT `fk_demand_load_baseline_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `demand`.`curtailment_measurement` DROP CONSTRAINT IF EXISTS `fk_demand_curtailment_measurement_meter_id`;
ALTER TABLE `demand`.`curtailment_measurement` ADD CONSTRAINT `fk_demand_curtailment_measurement_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `demand`.`direct_load_control_device` DROP CONSTRAINT IF EXISTS `fk_demand_direct_load_control_device_meter_id`;
ALTER TABLE `demand`.`direct_load_control_device` ADD CONSTRAINT `fk_demand_direct_load_control_device_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

-- ========= demand --> outage (6) =========
ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_iso_rto_event_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_iso_rto_event_id` FOREIGN KEY (`iso_rto_event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_triggering_outage_event_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_triggering_outage_event_id` FOREIGN KEY (`triggering_outage_event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `demand`.`dr_event_participant` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_participant_caused_interruption_id`;
ALTER TABLE `demand`.`dr_event_participant` ADD CONSTRAINT `fk_demand_dr_event_participant_caused_interruption_id` FOREIGN KEY (`caused_interruption_id`) REFERENCES `outage`.`interruption` (`interruption_id`);

ALTER TABLE `demand`.`interruptible_tariff_agreement` DROP CONSTRAINT IF EXISTS `fk_demand_interruptible_tariff_agreement_planned_outage_window_id`;
ALTER TABLE `demand`.`interruptible_tariff_agreement` ADD CONSTRAINT `fk_demand_interruptible_tariff_agreement_planned_outage_window_id` FOREIGN KEY (`planned_outage_window_id`) REFERENCES `outage`.`planned_outage_window` (`planned_outage_window_id`);

ALTER TABLE `demand`.`direct_load_control_device` DROP CONSTRAINT IF EXISTS `fk_demand_direct_load_control_device_last_caused_interruption_id`;
ALTER TABLE `demand`.`direct_load_control_device` ADD CONSTRAINT `fk_demand_direct_load_control_device_last_caused_interruption_id` FOREIGN KEY (`last_caused_interruption_id`) REFERENCES `outage`.`interruption` (`interruption_id`);

ALTER TABLE `demand`.`storm_aggregator_deployment` DROP CONSTRAINT IF EXISTS `fk_demand_storm_aggregator_deployment_storm_event_id`;
ALTER TABLE `demand`.`storm_aggregator_deployment` ADD CONSTRAINT `fk_demand_storm_aggregator_deployment_storm_event_id` FOREIGN KEY (`storm_event_id`) REFERENCES `outage`.`storm_event` (`storm_event_id`);

-- ========= demand --> renewable (1) =========
ALTER TABLE `demand`.`vpp_dispatch` DROP CONSTRAINT IF EXISTS `fk_demand_vpp_dispatch_vpp_configuration_id`;
ALTER TABLE `demand`.`vpp_dispatch` ADD CONSTRAINT `fk_demand_vpp_dispatch_vpp_configuration_id` FOREIGN KEY (`vpp_configuration_id`) REFERENCES `renewable`.`vpp_configuration` (`vpp_configuration_id`);

-- ========= demand --> supply (7) =========
ALTER TABLE `demand`.`dr_program` DROP CONSTRAINT IF EXISTS `fk_demand_dr_program_equipment_vendor_id`;
ALTER TABLE `demand`.`dr_program` ADD CONSTRAINT `fk_demand_dr_program_equipment_vendor_id` FOREIGN KEY (`equipment_vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `demand`.`demand_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_demand_demand_dr_enrollment_material_master_id`;
ALTER TABLE `demand`.`demand_dr_enrollment` ADD CONSTRAINT `fk_demand_demand_dr_enrollment_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_supporting_vendor_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_supporting_vendor_id` FOREIGN KEY (`supporting_vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `demand`.`aggregator` DROP CONSTRAINT IF EXISTS `fk_demand_aggregator_vendor_id`;
ALTER TABLE `demand`.`aggregator` ADD CONSTRAINT `fk_demand_aggregator_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `demand`.`direct_load_control_device` DROP CONSTRAINT IF EXISTS `fk_demand_direct_load_control_device_material_master_id`;
ALTER TABLE `demand`.`direct_load_control_device` ADD CONSTRAINT `fk_demand_direct_load_control_device_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `demand`.`direct_load_control_device` DROP CONSTRAINT IF EXISTS `fk_demand_direct_load_control_device_storage_warehouse_id`;
ALTER TABLE `demand`.`direct_load_control_device` ADD CONSTRAINT `fk_demand_direct_load_control_device_storage_warehouse_id` FOREIGN KEY (`storage_warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `demand`.`direct_load_control_device` DROP CONSTRAINT IF EXISTS `fk_demand_direct_load_control_device_vendor_id`;
ALTER TABLE `demand`.`direct_load_control_device` ADD CONSTRAINT `fk_demand_direct_load_control_device_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

-- ========= demand --> trading (1) =========
ALTER TABLE `demand`.`curtailment_measurement` DROP CONSTRAINT IF EXISTS `fk_demand_curtailment_measurement_lmp_price_id`;
ALTER TABLE `demand`.`curtailment_measurement` ADD CONSTRAINT `fk_demand_curtailment_measurement_lmp_price_id` FOREIGN KEY (`lmp_price_id`) REFERENCES `trading`.`lmp_price` (`lmp_price_id`);

-- ========= demand --> transmission (5) =========
ALTER TABLE `demand`.`dr_program` DROP CONSTRAINT IF EXISTS `fk_demand_dr_program_transmission_planning_study_id`;
ALTER TABLE `demand`.`dr_program` ADD CONSTRAINT `fk_demand_dr_program_transmission_planning_study_id` FOREIGN KEY (`transmission_planning_study_id`) REFERENCES `transmission`.`planning_study` (`planning_study_id`);

ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_congestion_event_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_congestion_event_id` FOREIGN KEY (`congestion_event_id`) REFERENCES `transmission`.`congestion_event` (`congestion_event_id`);

ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_transmission_outage_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_transmission_outage_id` FOREIGN KEY (`transmission_outage_id`) REFERENCES `transmission`.`transmission_outage` (`transmission_outage_id`);

ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_transmission_path_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_transmission_path_id` FOREIGN KEY (`transmission_path_id`) REFERENCES `transmission`.`path` (`path_id`);

ALTER TABLE `demand`.`vpp_dispatch` DROP CONSTRAINT IF EXISTS `fk_demand_vpp_dispatch_transmission_substation_id`;
ALTER TABLE `demand`.`vpp_dispatch` ADD CONSTRAINT `fk_demand_vpp_dispatch_transmission_substation_id` FOREIGN KEY (`transmission_substation_id`) REFERENCES `transmission`.`transmission_substation` (`transmission_substation_id`);

-- ========= demand --> workforce (9) =========
ALTER TABLE `demand`.`dr_program` DROP CONSTRAINT IF EXISTS `fk_demand_dr_program_program_manager_employee_id`;
ALTER TABLE `demand`.`dr_program` ADD CONSTRAINT `fk_demand_dr_program_program_manager_employee_id` FOREIGN KEY (`program_manager_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `demand`.`dr_event` DROP CONSTRAINT IF EXISTS `fk_demand_dr_event_dispatch_operator_employee_id`;
ALTER TABLE `demand`.`dr_event` ADD CONSTRAINT `fk_demand_dr_event_dispatch_operator_employee_id` FOREIGN KEY (`dispatch_operator_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `demand`.`curtailment_measurement` DROP CONSTRAINT IF EXISTS `fk_demand_curtailment_measurement_employee_id`;
ALTER TABLE `demand`.`curtailment_measurement` ADD CONSTRAINT `fk_demand_curtailment_measurement_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `demand`.`aggregator` DROP CONSTRAINT IF EXISTS `fk_demand_aggregator_primary_contact_employee_id`;
ALTER TABLE `demand`.`aggregator` ADD CONSTRAINT `fk_demand_aggregator_primary_contact_employee_id` FOREIGN KEY (`primary_contact_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `demand`.`interruptible_tariff_agreement` DROP CONSTRAINT IF EXISTS `fk_demand_interruptible_tariff_agreement_account_manager_employee_id`;
ALTER TABLE `demand`.`interruptible_tariff_agreement` ADD CONSTRAINT `fk_demand_interruptible_tariff_agreement_account_manager_employee_id` FOREIGN KEY (`account_manager_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `demand`.`direct_load_control_device` DROP CONSTRAINT IF EXISTS `fk_demand_direct_load_control_device_employee_id`;
ALTER TABLE `demand`.`direct_load_control_device` ADD CONSTRAINT `fk_demand_direct_load_control_device_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `demand`.`vpp_dispatch` DROP CONSTRAINT IF EXISTS `fk_demand_vpp_dispatch_dispatch_operator_employee_id`;
ALTER TABLE `demand`.`vpp_dispatch` ADD CONSTRAINT `fk_demand_vpp_dispatch_dispatch_operator_employee_id` FOREIGN KEY (`dispatch_operator_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `demand`.`dr_capacity_registration` DROP CONSTRAINT IF EXISTS `fk_demand_dr_capacity_registration_approved_by_employee_id`;
ALTER TABLE `demand`.`dr_capacity_registration` ADD CONSTRAINT `fk_demand_dr_capacity_registration_approved_by_employee_id` FOREIGN KEY (`approved_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `demand`.`dr_compliance_report` DROP CONSTRAINT IF EXISTS `fk_demand_dr_compliance_report_submitted_by_employee_id`;
ALTER TABLE `demand`.`dr_compliance_report` ADD CONSTRAINT `fk_demand_dr_compliance_report_submitted_by_employee_id` FOREIGN KEY (`submitted_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

-- ========= distribution --> asset (1) =========
ALTER TABLE `distribution`.`distribution_switching_order` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_order_work_order_id`;
ALTER TABLE `distribution`.`distribution_switching_order` ADD CONSTRAINT `fk_distribution_distribution_switching_order_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

-- ========= distribution --> compliance (12) =========
ALTER TABLE `distribution`.`feeder` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_compliance_program_id`;
ALTER TABLE `distribution`.`feeder` ADD CONSTRAINT `fk_distribution_feeder_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `compliance`.`program` (`program_id`);

ALTER TABLE `distribution`.`feeder` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_obligation_id`;
ALTER TABLE `distribution`.`feeder` ADD CONSTRAINT `fk_distribution_feeder_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `distribution`.`distribution_substation` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_substation_nerc_cip_asset_id`;
ALTER TABLE `distribution`.`distribution_substation` ADD CONSTRAINT `fk_distribution_distribution_substation_nerc_cip_asset_id` FOREIGN KEY (`nerc_cip_asset_id`) REFERENCES `compliance`.`nerc_cip_asset` (`nerc_cip_asset_id`);

ALTER TABLE `distribution`.`transformer` DROP CONSTRAINT IF EXISTS `fk_distribution_transformer_environmental_permit_id`;
ALTER TABLE `distribution`.`transformer` ADD CONSTRAINT `fk_distribution_transformer_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `compliance`.`environmental_permit` (`environmental_permit_id`);

ALTER TABLE `distribution`.`sectionalizing_device` DROP CONSTRAINT IF EXISTS `fk_distribution_sectionalizing_device_nerc_cip_asset_id`;
ALTER TABLE `distribution`.`sectionalizing_device` ADD CONSTRAINT `fk_distribution_sectionalizing_device_nerc_cip_asset_id` FOREIGN KEY (`nerc_cip_asset_id`) REFERENCES `compliance`.`nerc_cip_asset` (`nerc_cip_asset_id`);

ALTER TABLE `distribution`.`network_segment` DROP CONSTRAINT IF EXISTS `fk_distribution_network_segment_obligation_id`;
ALTER TABLE `distribution`.`network_segment` ADD CONSTRAINT `fk_distribution_network_segment_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `distribution`.`distribution_switching_order` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_order_audit_id`;
ALTER TABLE `distribution`.`distribution_switching_order` ADD CONSTRAINT `fk_distribution_distribution_switching_order_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `distribution`.`capacitor_bank` DROP CONSTRAINT IF EXISTS `fk_distribution_capacitor_bank_nerc_cip_asset_id`;
ALTER TABLE `distribution`.`capacitor_bank` ADD CONSTRAINT `fk_distribution_capacitor_bank_nerc_cip_asset_id` FOREIGN KEY (`nerc_cip_asset_id`) REFERENCES `compliance`.`nerc_cip_asset` (`nerc_cip_asset_id`);

ALTER TABLE `distribution`.`distribution_reliability_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_reliability_event_regulatory_filing_id`;
ALTER TABLE `distribution`.`distribution_reliability_event` ADD CONSTRAINT `fk_distribution_distribution_reliability_event_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `distribution`.`der_interconnection_point` DROP CONSTRAINT IF EXISTS `fk_distribution_der_interconnection_point_environmental_permit_id`;
ALTER TABLE `distribution`.`der_interconnection_point` ADD CONSTRAINT `fk_distribution_der_interconnection_point_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `compliance`.`environmental_permit` (`environmental_permit_id`);

ALTER TABLE `distribution`.`service_territory` DROP CONSTRAINT IF EXISTS `fk_distribution_service_territory_rate_case_id`;
ALTER TABLE `distribution`.`service_territory` ADD CONSTRAINT `fk_distribution_service_territory_rate_case_id` FOREIGN KEY (`rate_case_id`) REFERENCES `compliance`.`rate_case` (`rate_case_id`);

ALTER TABLE `distribution`.`substation_audit_coverage` DROP CONSTRAINT IF EXISTS `fk_distribution_substation_audit_coverage_audit_id`;
ALTER TABLE `distribution`.`substation_audit_coverage` ADD CONSTRAINT `fk_distribution_substation_audit_coverage_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

-- ========= distribution --> customer (4) =========
ALTER TABLE `distribution`.`service_drop` DROP CONSTRAINT IF EXISTS `fk_distribution_service_drop_customer_service_agreement_id`;
ALTER TABLE `distribution`.`service_drop` ADD CONSTRAINT `fk_distribution_service_drop_customer_service_agreement_id` FOREIGN KEY (`customer_service_agreement_id`) REFERENCES `customer`.`customer_service_agreement` (`customer_service_agreement_id`);

ALTER TABLE `distribution`.`service_drop` DROP CONSTRAINT IF EXISTS `fk_distribution_service_drop_premise_id`;
ALTER TABLE `distribution`.`service_drop` ADD CONSTRAINT `fk_distribution_service_drop_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `distribution`.`distribution_switching_order` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_order_notification_account_id`;
ALTER TABLE `distribution`.`distribution_switching_order` ADD CONSTRAINT `fk_distribution_distribution_switching_order_notification_account_id` FOREIGN KEY (`notification_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `distribution`.`service_territory` DROP CONSTRAINT IF EXISTS `fk_distribution_service_territory_service_level_agreement_id`;
ALTER TABLE `distribution`.`service_territory` ADD CONSTRAINT `fk_distribution_service_territory_service_level_agreement_id` FOREIGN KEY (`service_level_agreement_id`) REFERENCES `customer`.`service_level_agreement` (`service_level_agreement_id`);

-- ========= distribution --> finance (12) =========
ALTER TABLE `distribution`.`feeder` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_cost_center_id`;
ALTER TABLE `distribution`.`feeder` ADD CONSTRAINT `fk_distribution_feeder_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `distribution`.`distribution_substation` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_substation_cost_center_id`;
ALTER TABLE `distribution`.`distribution_substation` ADD CONSTRAINT `fk_distribution_distribution_substation_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `distribution`.`transformer` DROP CONSTRAINT IF EXISTS `fk_distribution_transformer_fixed_asset_id`;
ALTER TABLE `distribution`.`transformer` ADD CONSTRAINT `fk_distribution_transformer_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `finance`.`fixed_asset` (`fixed_asset_id`);

ALTER TABLE `distribution`.`sectionalizing_device` DROP CONSTRAINT IF EXISTS `fk_distribution_sectionalizing_device_fixed_asset_id`;
ALTER TABLE `distribution`.`sectionalizing_device` ADD CONSTRAINT `fk_distribution_sectionalizing_device_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `finance`.`fixed_asset` (`fixed_asset_id`);

ALTER TABLE `distribution`.`network_segment` DROP CONSTRAINT IF EXISTS `fk_distribution_network_segment_cost_center_id`;
ALTER TABLE `distribution`.`network_segment` ADD CONSTRAINT `fk_distribution_network_segment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `distribution`.`load_zone` DROP CONSTRAINT IF EXISTS `fk_distribution_load_zone_profit_center_id`;
ALTER TABLE `distribution`.`load_zone` ADD CONSTRAINT `fk_distribution_load_zone_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `distribution`.`distribution_switching_order` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_order_cost_center_id`;
ALTER TABLE `distribution`.`distribution_switching_order` ADD CONSTRAINT `fk_distribution_distribution_switching_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `distribution`.`distribution_switching_order` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_order_internal_order_id`;
ALTER TABLE `distribution`.`distribution_switching_order` ADD CONSTRAINT `fk_distribution_distribution_switching_order_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `finance`.`internal_order` (`internal_order_id`);

ALTER TABLE `distribution`.`capacitor_bank` DROP CONSTRAINT IF EXISTS `fk_distribution_capacitor_bank_fixed_asset_id`;
ALTER TABLE `distribution`.`capacitor_bank` ADD CONSTRAINT `fk_distribution_capacitor_bank_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `finance`.`fixed_asset` (`fixed_asset_id`);

ALTER TABLE `distribution`.`volt_var_device` DROP CONSTRAINT IF EXISTS `fk_distribution_volt_var_device_fixed_asset_id`;
ALTER TABLE `distribution`.`volt_var_device` ADD CONSTRAINT `fk_distribution_volt_var_device_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `finance`.`fixed_asset` (`fixed_asset_id`);

ALTER TABLE `distribution`.`der_interconnection_point` DROP CONSTRAINT IF EXISTS `fk_distribution_der_interconnection_point_cost_center_id`;
ALTER TABLE `distribution`.`der_interconnection_point` ADD CONSTRAINT `fk_distribution_der_interconnection_point_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `distribution`.`service_territory` DROP CONSTRAINT IF EXISTS `fk_distribution_service_territory_profit_center_id`;
ALTER TABLE `distribution`.`service_territory` ADD CONSTRAINT `fk_distribution_service_territory_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

-- ========= distribution --> forecast (10) =========
ALTER TABLE `distribution`.`feeder` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_forecast_zone_id`;
ALTER TABLE `distribution`.`feeder` ADD CONSTRAINT `fk_distribution_feeder_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `distribution`.`feeder` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_gis_network_model_id`;
ALTER TABLE `distribution`.`feeder` ADD CONSTRAINT `fk_distribution_feeder_gis_network_model_id` FOREIGN KEY (`gis_network_model_id`) REFERENCES `forecast`.`model` (`model_id`);

ALTER TABLE `distribution`.`distribution_substation` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_substation_forecast_zone_id`;
ALTER TABLE `distribution`.`distribution_substation` ADD CONSTRAINT `fk_distribution_distribution_substation_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `distribution`.`sectionalizing_device` DROP CONSTRAINT IF EXISTS `fk_distribution_sectionalizing_device_flisr_zone_id`;
ALTER TABLE `distribution`.`sectionalizing_device` ADD CONSTRAINT `fk_distribution_sectionalizing_device_flisr_zone_id` FOREIGN KEY (`flisr_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `distribution`.`load_zone` DROP CONSTRAINT IF EXISTS `fk_distribution_load_zone_forecast_zone_id`;
ALTER TABLE `distribution`.`load_zone` ADD CONSTRAINT `fk_distribution_load_zone_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `distribution`.`capacitor_bank` DROP CONSTRAINT IF EXISTS `fk_distribution_capacitor_bank_flisr_zone_id`;
ALTER TABLE `distribution`.`capacitor_bank` ADD CONSTRAINT `fk_distribution_capacitor_bank_flisr_zone_id` FOREIGN KEY (`flisr_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `distribution`.`feeder_load_reading` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_load_reading_load_id`;
ALTER TABLE `distribution`.`feeder_load_reading` ADD CONSTRAINT `fk_distribution_feeder_load_reading_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `distribution`.`der_interconnection_point` DROP CONSTRAINT IF EXISTS `fk_distribution_der_interconnection_point_forecast_renewable_id`;
ALTER TABLE `distribution`.`der_interconnection_point` ADD CONSTRAINT `fk_distribution_der_interconnection_point_forecast_renewable_id` FOREIGN KEY (`forecast_renewable_id`) REFERENCES `forecast`.`forecast_renewable` (`forecast_renewable_id`);

ALTER TABLE `distribution`.`service_territory` DROP CONSTRAINT IF EXISTS `fk_distribution_service_territory_forecast_zone_id`;
ALTER TABLE `distribution`.`service_territory` ADD CONSTRAINT `fk_distribution_service_territory_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `distribution`.`substation_scenario_plan` DROP CONSTRAINT IF EXISTS `fk_distribution_substation_scenario_plan_irp_scenario_id`;
ALTER TABLE `distribution`.`substation_scenario_plan` ADD CONSTRAINT `fk_distribution_substation_scenario_plan_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

-- ========= distribution --> gis (12) =========
ALTER TABLE `distribution`.`feeder` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_gis_location_id`;
ALTER TABLE `distribution`.`feeder` ADD CONSTRAINT `fk_distribution_feeder_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `distribution`.`distribution_substation` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_substation_gis_location_id`;
ALTER TABLE `distribution`.`distribution_substation` ADD CONSTRAINT `fk_distribution_distribution_substation_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `distribution`.`transformer` DROP CONSTRAINT IF EXISTS `fk_distribution_transformer_gis_location_id`;
ALTER TABLE `distribution`.`transformer` ADD CONSTRAINT `fk_distribution_transformer_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `distribution`.`sectionalizing_device` DROP CONSTRAINT IF EXISTS `fk_distribution_sectionalizing_device_gis_location_id`;
ALTER TABLE `distribution`.`sectionalizing_device` ADD CONSTRAINT `fk_distribution_sectionalizing_device_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `distribution`.`service_drop` DROP CONSTRAINT IF EXISTS `fk_distribution_service_drop_gis_location_id`;
ALTER TABLE `distribution`.`service_drop` ADD CONSTRAINT `fk_distribution_service_drop_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `distribution`.`network_segment` DROP CONSTRAINT IF EXISTS `fk_distribution_network_segment_gis_location_id`;
ALTER TABLE `distribution`.`network_segment` ADD CONSTRAINT `fk_distribution_network_segment_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `distribution`.`load_zone` DROP CONSTRAINT IF EXISTS `fk_distribution_load_zone_gis_location_id`;
ALTER TABLE `distribution`.`load_zone` ADD CONSTRAINT `fk_distribution_load_zone_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `distribution`.`capacitor_bank` DROP CONSTRAINT IF EXISTS `fk_distribution_capacitor_bank_gis_location_id`;
ALTER TABLE `distribution`.`capacitor_bank` ADD CONSTRAINT `fk_distribution_capacitor_bank_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `distribution`.`volt_var_device` DROP CONSTRAINT IF EXISTS `fk_distribution_volt_var_device_gis_location_id`;
ALTER TABLE `distribution`.`volt_var_device` ADD CONSTRAINT `fk_distribution_volt_var_device_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `distribution`.`distribution_reliability_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_reliability_event_gis_location_id`;
ALTER TABLE `distribution`.`distribution_reliability_event` ADD CONSTRAINT `fk_distribution_distribution_reliability_event_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `distribution`.`der_interconnection_point` DROP CONSTRAINT IF EXISTS `fk_distribution_der_interconnection_point_gis_location_id`;
ALTER TABLE `distribution`.`der_interconnection_point` ADD CONSTRAINT `fk_distribution_der_interconnection_point_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `distribution`.`service_territory` DROP CONSTRAINT IF EXISTS `fk_distribution_service_territory_gis_location_id`;
ALTER TABLE `distribution`.`service_territory` ADD CONSTRAINT `fk_distribution_service_territory_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

-- ========= distribution --> grid (10) =========
ALTER TABLE `distribution`.`feeder` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_scada_point_id`;
ALTER TABLE `distribution`.`feeder` ADD CONSTRAINT `fk_distribution_feeder_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `distribution`.`distribution_substation` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_substation_control_area_id`;
ALTER TABLE `distribution`.`distribution_substation` ADD CONSTRAINT `fk_distribution_distribution_substation_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `distribution`.`distribution_switching_step` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_step_scada_point_id`;
ALTER TABLE `distribution`.`distribution_switching_step` ADD CONSTRAINT `fk_distribution_distribution_switching_step_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `distribution`.`distribution_flisr_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_flisr_event_ems_alarm_id`;
ALTER TABLE `distribution`.`distribution_flisr_event` ADD CONSTRAINT `fk_distribution_distribution_flisr_event_ems_alarm_id` FOREIGN KEY (`ems_alarm_id`) REFERENCES `grid`.`ems_alarm` (`ems_alarm_id`);

ALTER TABLE `distribution`.`capacitor_bank` DROP CONSTRAINT IF EXISTS `fk_distribution_capacitor_bank_scada_point_id`;
ALTER TABLE `distribution`.`capacitor_bank` ADD CONSTRAINT `fk_distribution_capacitor_bank_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `distribution`.`distribution_reliability_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_reliability_event_ems_alarm_id`;
ALTER TABLE `distribution`.`distribution_reliability_event` ADD CONSTRAINT `fk_distribution_distribution_reliability_event_ems_alarm_id` FOREIGN KEY (`ems_alarm_id`) REFERENCES `grid`.`ems_alarm` (`ems_alarm_id`);

ALTER TABLE `distribution`.`distribution_reliability_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_reliability_event_grid_reliability_event_id`;
ALTER TABLE `distribution`.`distribution_reliability_event` ADD CONSTRAINT `fk_distribution_distribution_reliability_event_grid_reliability_event_id` FOREIGN KEY (`grid_reliability_event_id`) REFERENCES `grid`.`grid_reliability_event` (`grid_reliability_event_id`);

ALTER TABLE `distribution`.`distribution_reliability_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_reliability_event_scada_alarm_id`;
ALTER TABLE `distribution`.`distribution_reliability_event` ADD CONSTRAINT `fk_distribution_distribution_reliability_event_scada_alarm_id` FOREIGN KEY (`scada_alarm_id`) REFERENCES `grid`.`ems_alarm` (`ems_alarm_id`);

ALTER TABLE `distribution`.`feeder_load_reading` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_load_reading_state_estimation_run_id`;
ALTER TABLE `distribution`.`feeder_load_reading` ADD CONSTRAINT `fk_distribution_feeder_load_reading_state_estimation_run_id` FOREIGN KEY (`state_estimation_run_id`) REFERENCES `grid`.`state_estimation_run` (`state_estimation_run_id`);

ALTER TABLE `distribution`.`der_interconnection_point` DROP CONSTRAINT IF EXISTS `fk_distribution_der_interconnection_point_scada_point_id`;
ALTER TABLE `distribution`.`der_interconnection_point` ADD CONSTRAINT `fk_distribution_der_interconnection_point_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

-- ========= distribution --> metering (4) =========
ALTER TABLE `distribution`.`service_drop` DROP CONSTRAINT IF EXISTS `fk_distribution_service_drop_meter_point_id`;
ALTER TABLE `distribution`.`service_drop` ADD CONSTRAINT `fk_distribution_service_drop_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `distribution`.`feeder_load_reading` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_load_reading_measurement_point_id`;
ALTER TABLE `distribution`.`feeder_load_reading` ADD CONSTRAINT `fk_distribution_feeder_load_reading_measurement_point_id` FOREIGN KEY (`measurement_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `distribution`.`der_interconnection_point` DROP CONSTRAINT IF EXISTS `fk_distribution_der_interconnection_point_meter_id`;
ALTER TABLE `distribution`.`der_interconnection_point` ADD CONSTRAINT `fk_distribution_der_interconnection_point_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `distribution`.`der_interconnection_point` DROP CONSTRAINT IF EXISTS `fk_distribution_der_interconnection_point_service_point_id`;
ALTER TABLE `distribution`.`der_interconnection_point` ADD CONSTRAINT `fk_distribution_der_interconnection_point_service_point_id` FOREIGN KEY (`service_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

-- ========= distribution --> outage (9) =========
ALTER TABLE `distribution`.`distribution_switching_order` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_order_event_id`;
ALTER TABLE `distribution`.`distribution_switching_order` ADD CONSTRAINT `fk_distribution_distribution_switching_order_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `distribution`.`distribution_switching_order` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_order_safety_clearance_id`;
ALTER TABLE `distribution`.`distribution_switching_order` ADD CONSTRAINT `fk_distribution_distribution_switching_order_safety_clearance_id` FOREIGN KEY (`safety_clearance_id`) REFERENCES `outage`.`safety_clearance` (`safety_clearance_id`);

ALTER TABLE `distribution`.`distribution_switching_step` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_step_safety_clearance_id`;
ALTER TABLE `distribution`.`distribution_switching_step` ADD CONSTRAINT `fk_distribution_distribution_switching_step_safety_clearance_id` FOREIGN KEY (`safety_clearance_id`) REFERENCES `outage`.`safety_clearance` (`safety_clearance_id`);

ALTER TABLE `distribution`.`distribution_flisr_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_flisr_event_event_id`;
ALTER TABLE `distribution`.`distribution_flisr_event` ADD CONSTRAINT `fk_distribution_distribution_flisr_event_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `distribution`.`distribution_flisr_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_flisr_event_storm_event_id`;
ALTER TABLE `distribution`.`distribution_flisr_event` ADD CONSTRAINT `fk_distribution_distribution_flisr_event_storm_event_id` FOREIGN KEY (`storm_event_id`) REFERENCES `outage`.`storm_event` (`storm_event_id`);

ALTER TABLE `distribution`.`distribution_reliability_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_reliability_event_oms_event_id`;
ALTER TABLE `distribution`.`distribution_reliability_event` ADD CONSTRAINT `fk_distribution_distribution_reliability_event_oms_event_id` FOREIGN KEY (`oms_event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `distribution`.`distribution_reliability_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_reliability_event_storm_event_id`;
ALTER TABLE `distribution`.`distribution_reliability_event` ADD CONSTRAINT `fk_distribution_distribution_reliability_event_storm_event_id` FOREIGN KEY (`storm_event_id`) REFERENCES `outage`.`storm_event` (`storm_event_id`);

ALTER TABLE `distribution`.`feeder_load_reading` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_load_reading_event_id`;
ALTER TABLE `distribution`.`feeder_load_reading` ADD CONSTRAINT `fk_distribution_feeder_load_reading_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `distribution`.`service_territory` DROP CONSTRAINT IF EXISTS `fk_distribution_service_territory_emergency_response_plan_id`;
ALTER TABLE `distribution`.`service_territory` ADD CONSTRAINT `fk_distribution_service_territory_emergency_response_plan_id` FOREIGN KEY (`emergency_response_plan_id`) REFERENCES `outage`.`emergency_response_plan` (`emergency_response_plan_id`);

-- ========= distribution --> supply (11) =========
ALTER TABLE `distribution`.`transformer` DROP CONSTRAINT IF EXISTS `fk_distribution_transformer_material_master_id`;
ALTER TABLE `distribution`.`transformer` ADD CONSTRAINT `fk_distribution_transformer_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `distribution`.`sectionalizing_device` DROP CONSTRAINT IF EXISTS `fk_distribution_sectionalizing_device_material_master_id`;
ALTER TABLE `distribution`.`sectionalizing_device` ADD CONSTRAINT `fk_distribution_sectionalizing_device_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `distribution`.`service_drop` DROP CONSTRAINT IF EXISTS `fk_distribution_service_drop_conductor_material_master_id`;
ALTER TABLE `distribution`.`service_drop` ADD CONSTRAINT `fk_distribution_service_drop_conductor_material_master_id` FOREIGN KEY (`conductor_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `distribution`.`network_segment` DROP CONSTRAINT IF EXISTS `fk_distribution_network_segment_conductor_material_master_id`;
ALTER TABLE `distribution`.`network_segment` ADD CONSTRAINT `fk_distribution_network_segment_conductor_material_master_id` FOREIGN KEY (`conductor_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `distribution`.`distribution_switching_order` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_order_emergency_stock_event_id`;
ALTER TABLE `distribution`.`distribution_switching_order` ADD CONSTRAINT `fk_distribution_distribution_switching_order_emergency_stock_event_id` FOREIGN KEY (`emergency_stock_event_id`) REFERENCES `supply`.`emergency_stock_event` (`emergency_stock_event_id`);

ALTER TABLE `distribution`.`distribution_switching_order` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_order_staging_warehouse_id`;
ALTER TABLE `distribution`.`distribution_switching_order` ADD CONSTRAINT `fk_distribution_distribution_switching_order_staging_warehouse_id` FOREIGN KEY (`staging_warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `distribution`.`capacitor_bank` DROP CONSTRAINT IF EXISTS `fk_distribution_capacitor_bank_material_master_id`;
ALTER TABLE `distribution`.`capacitor_bank` ADD CONSTRAINT `fk_distribution_capacitor_bank_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `distribution`.`volt_var_device` DROP CONSTRAINT IF EXISTS `fk_distribution_volt_var_device_material_master_id`;
ALTER TABLE `distribution`.`volt_var_device` ADD CONSTRAINT `fk_distribution_volt_var_device_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `distribution`.`distribution_reliability_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_reliability_event_emergency_stock_event_id`;
ALTER TABLE `distribution`.`distribution_reliability_event` ADD CONSTRAINT `fk_distribution_distribution_reliability_event_emergency_stock_event_id` FOREIGN KEY (`emergency_stock_event_id`) REFERENCES `supply`.`emergency_stock_event` (`emergency_stock_event_id`);

ALTER TABLE `distribution`.`der_interconnection_point` DROP CONSTRAINT IF EXISTS `fk_distribution_der_interconnection_point_inverter_material_master_id`;
ALTER TABLE `distribution`.`der_interconnection_point` ADD CONSTRAINT `fk_distribution_der_interconnection_point_inverter_material_master_id` FOREIGN KEY (`inverter_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `distribution`.`switching_order_material_requisition` DROP CONSTRAINT IF EXISTS `fk_distribution_switching_order_material_requisition_material_master_id`;
ALTER TABLE `distribution`.`switching_order_material_requisition` ADD CONSTRAINT `fk_distribution_switching_order_material_requisition_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

-- ========= distribution --> trading (1) =========
ALTER TABLE `distribution`.`der_interconnection_point` DROP CONSTRAINT IF EXISTS `fk_distribution_der_interconnection_point_ppa_id`;
ALTER TABLE `distribution`.`der_interconnection_point` ADD CONSTRAINT `fk_distribution_der_interconnection_point_ppa_id` FOREIGN KEY (`ppa_id`) REFERENCES `trading`.`ppa` (`ppa_id`);

-- ========= distribution --> transmission (1) =========
ALTER TABLE `distribution`.`distribution_substation` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_substation_transmission_substation_id`;
ALTER TABLE `distribution`.`distribution_substation` ADD CONSTRAINT `fk_distribution_distribution_substation_transmission_substation_id` FOREIGN KEY (`transmission_substation_id`) REFERENCES `transmission`.`transmission_substation` (`transmission_substation_id`);

-- ========= distribution --> workforce (25) =========
ALTER TABLE `distribution`.`feeder` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_owner_employee_id`;
ALTER TABLE `distribution`.`feeder` ADD CONSTRAINT `fk_distribution_feeder_owner_employee_id` FOREIGN KEY (`owner_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `distribution`.`distribution_substation` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_substation_manager_employee_id`;
ALTER TABLE `distribution`.`distribution_substation` ADD CONSTRAINT `fk_distribution_distribution_substation_manager_employee_id` FOREIGN KEY (`manager_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `distribution`.`transformer` DROP CONSTRAINT IF EXISTS `fk_distribution_transformer_inspector_employee_id`;
ALTER TABLE `distribution`.`transformer` ADD CONSTRAINT `fk_distribution_transformer_inspector_employee_id` FOREIGN KEY (`inspector_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `distribution`.`sectionalizing_device` DROP CONSTRAINT IF EXISTS `fk_distribution_sectionalizing_device_maintainer_employee_id`;
ALTER TABLE `distribution`.`sectionalizing_device` ADD CONSTRAINT `fk_distribution_sectionalizing_device_maintainer_employee_id` FOREIGN KEY (`maintainer_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `distribution`.`service_drop` DROP CONSTRAINT IF EXISTS `fk_distribution_service_drop_installer_employee_id`;
ALTER TABLE `distribution`.`service_drop` ADD CONSTRAINT `fk_distribution_service_drop_installer_employee_id` FOREIGN KEY (`installer_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `distribution`.`network_segment` DROP CONSTRAINT IF EXISTS `fk_distribution_network_segment_maintenance_crew_id`;
ALTER TABLE `distribution`.`network_segment` ADD CONSTRAINT `fk_distribution_network_segment_maintenance_crew_id` FOREIGN KEY (`maintenance_crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `distribution`.`load_zone` DROP CONSTRAINT IF EXISTS `fk_distribution_load_zone_planning_engineer_employee_id`;
ALTER TABLE `distribution`.`load_zone` ADD CONSTRAINT `fk_distribution_load_zone_planning_engineer_employee_id` FOREIGN KEY (`planning_engineer_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `distribution`.`distribution_switching_order` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_order_crew_id`;
ALTER TABLE `distribution`.`distribution_switching_order` ADD CONSTRAINT `fk_distribution_distribution_switching_order_crew_id` FOREIGN KEY (`crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `distribution`.`distribution_switching_order` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_order_primary_distribution_employee_id`;
ALTER TABLE `distribution`.`distribution_switching_order` ADD CONSTRAINT `fk_distribution_distribution_switching_order_primary_distribution_employee_id` FOREIGN KEY (`primary_distribution_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `distribution`.`distribution_switching_order` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_order_quaternary_distribution_created_by_user_employee_id`;
ALTER TABLE `distribution`.`distribution_switching_order` ADD CONSTRAINT `fk_distribution_distribution_switching_order_quaternary_distribution_created_by_user_employee_id` FOREIGN KEY (`quaternary_distribution_created_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `distribution`.`distribution_switching_order` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_order_quinary_distribution_last_modified_by_user_employee_id`;
ALTER TABLE `distribution`.`distribution_switching_order` ADD CONSTRAINT `fk_distribution_distribution_switching_order_quinary_distribution_last_modified_by_user_employee_id` FOREIGN KEY (`quinary_distribution_last_modified_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `distribution`.`distribution_switching_order` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_order_tertiary_distribution_cancelled_by_user_employee_id`;
ALTER TABLE `distribution`.`distribution_switching_order` ADD CONSTRAINT `fk_distribution_distribution_switching_order_tertiary_distribution_cancelled_by_user_employee_id` FOREIGN KEY (`tertiary_distribution_cancelled_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `distribution`.`distribution_switching_step` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_switching_step_employee_id`;
ALTER TABLE `distribution`.`distribution_switching_step` ADD CONSTRAINT `fk_distribution_distribution_switching_step_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `distribution`.`distribution_flisr_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_flisr_event_employee_id`;
ALTER TABLE `distribution`.`distribution_flisr_event` ADD CONSTRAINT `fk_distribution_distribution_flisr_event_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `distribution`.`volt_var_action` DROP CONSTRAINT IF EXISTS `fk_distribution_volt_var_action_employee_id`;
ALTER TABLE `distribution`.`volt_var_action` ADD CONSTRAINT `fk_distribution_volt_var_action_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `distribution`.`capacitor_bank` DROP CONSTRAINT IF EXISTS `fk_distribution_capacitor_bank_technician_employee_id`;
ALTER TABLE `distribution`.`capacitor_bank` ADD CONSTRAINT `fk_distribution_capacitor_bank_technician_employee_id` FOREIGN KEY (`technician_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `distribution`.`volt_var_device` DROP CONSTRAINT IF EXISTS `fk_distribution_volt_var_device_control_engineer_employee_id`;
ALTER TABLE `distribution`.`volt_var_device` ADD CONSTRAINT `fk_distribution_volt_var_device_control_engineer_employee_id` FOREIGN KEY (`control_engineer_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `distribution`.`distribution_reliability_event` DROP CONSTRAINT IF EXISTS `fk_distribution_distribution_reliability_event_responding_crew_id`;
ALTER TABLE `distribution`.`distribution_reliability_event` ADD CONSTRAINT `fk_distribution_distribution_reliability_event_responding_crew_id` FOREIGN KEY (`responding_crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `distribution`.`der_interconnection_point` DROP CONSTRAINT IF EXISTS `fk_distribution_der_interconnection_point_interconnection_engineer_employee_id`;
ALTER TABLE `distribution`.`der_interconnection_point` ADD CONSTRAINT `fk_distribution_der_interconnection_point_interconnection_engineer_employee_id` FOREIGN KEY (`interconnection_engineer_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `distribution`.`service_territory` DROP CONSTRAINT IF EXISTS `fk_distribution_service_territory_operating_org_unit_id`;
ALTER TABLE `distribution`.`service_territory` ADD CONSTRAINT `fk_distribution_service_territory_operating_org_unit_id` FOREIGN KEY (`operating_org_unit_id`) REFERENCES `workforce`.`org_unit` (`org_unit_id`);

ALTER TABLE `distribution`.`switching_order_material_requisition` DROP CONSTRAINT IF EXISTS `fk_distribution_switching_order_material_requisition_issued_by_employee_id`;
ALTER TABLE `distribution`.`switching_order_material_requisition` ADD CONSTRAINT `fk_distribution_switching_order_material_requisition_issued_by_employee_id` FOREIGN KEY (`issued_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `distribution`.`switching_order_material_requisition` DROP CONSTRAINT IF EXISTS `fk_distribution_switching_order_material_requisition_received_by_employee_id`;
ALTER TABLE `distribution`.`switching_order_material_requisition` ADD CONSTRAINT `fk_distribution_switching_order_material_requisition_received_by_employee_id` FOREIGN KEY (`received_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `distribution`.`feeder_crew_assignment` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_crew_assignment_crew_id`;
ALTER TABLE `distribution`.`feeder_crew_assignment` ADD CONSTRAINT `fk_distribution_feeder_crew_assignment_crew_id` FOREIGN KEY (`crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `distribution`.`feeder_crew_assignment` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_crew_assignment_employee_id`;
ALTER TABLE `distribution`.`feeder_crew_assignment` ADD CONSTRAINT `fk_distribution_feeder_crew_assignment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `distribution`.`feeder_crew_assignment` DROP CONSTRAINT IF EXISTS `fk_distribution_feeder_crew_assignment_last_modified_by_user_employee_id`;
ALTER TABLE `distribution`.`feeder_crew_assignment` ADD CONSTRAINT `fk_distribution_feeder_crew_assignment_last_modified_by_user_employee_id` FOREIGN KEY (`last_modified_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

-- ========= finance --> asset (5) =========
ALTER TABLE `finance`.`fixed_asset` DROP CONSTRAINT IF EXISTS `fk_finance_fixed_asset_capital_project_id`;
ALTER TABLE `finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_capital_project_id` FOREIGN KEY (`capital_project_id`) REFERENCES `asset`.`capital_project` (`capital_project_id`);

ALTER TABLE `finance`.`fixed_asset` DROP CONSTRAINT IF EXISTS `fk_finance_fixed_asset_class_id`;
ALTER TABLE `finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_class_id` FOREIGN KEY (`class_id`) REFERENCES `asset`.`class` (`class_id`);

ALTER TABLE `finance`.`asset_depreciation` DROP CONSTRAINT IF EXISTS `fk_finance_asset_depreciation_class_id`;
ALTER TABLE `finance`.`asset_depreciation` ADD CONSTRAINT `fk_finance_asset_depreciation_class_id` FOREIGN KEY (`class_id`) REFERENCES `asset`.`class` (`class_id`);

ALTER TABLE `finance`.`asset_depreciation` DROP CONSTRAINT IF EXISTS `fk_finance_asset_depreciation_registry_id`;
ALTER TABLE `finance`.`asset_depreciation` ADD CONSTRAINT `fk_finance_asset_depreciation_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `finance`.`capex_expenditure` DROP CONSTRAINT IF EXISTS `fk_finance_capex_expenditure_capital_project_id`;
ALTER TABLE `finance`.`capex_expenditure` ADD CONSTRAINT `fk_finance_capex_expenditure_capital_project_id` FOREIGN KEY (`capital_project_id`) REFERENCES `asset`.`capital_project` (`capital_project_id`);

-- ========= finance --> billing (1) =========
ALTER TABLE `finance`.`receivable` DROP CONSTRAINT IF EXISTS `fk_finance_receivable_invoice_id`;
ALTER TABLE `finance`.`receivable` ADD CONSTRAINT `fk_finance_receivable_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

-- ========= finance --> compliance (2) =========
ALTER TABLE `finance`.`tax_provision` DROP CONSTRAINT IF EXISTS `fk_finance_tax_provision_sox_control_id`;
ALTER TABLE `finance`.`tax_provision` ADD CONSTRAINT `fk_finance_tax_provision_sox_control_id` FOREIGN KEY (`sox_control_id`) REFERENCES `compliance`.`sox_control` (`sox_control_id`);

ALTER TABLE `finance`.`bank_reconciliation` DROP CONSTRAINT IF EXISTS `fk_finance_bank_reconciliation_sox_control_id`;
ALTER TABLE `finance`.`bank_reconciliation` ADD CONSTRAINT `fk_finance_bank_reconciliation_sox_control_id` FOREIGN KEY (`sox_control_id`) REFERENCES `compliance`.`sox_control` (`sox_control_id`);

-- ========= finance --> customer (2) =========
ALTER TABLE `finance`.`ap_invoice` DROP CONSTRAINT IF EXISTS `fk_finance_ap_invoice_bank_account_id`;
ALTER TABLE `finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_bank_account_id` FOREIGN KEY (`bank_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `finance`.`receivable` DROP CONSTRAINT IF EXISTS `fk_finance_receivable_account_id`;
ALTER TABLE `finance`.`receivable` ADD CONSTRAINT `fk_finance_receivable_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

-- ========= finance --> forecast (4) =========
ALTER TABLE `finance`.`capex_expenditure` DROP CONSTRAINT IF EXISTS `fk_finance_capex_expenditure_irp_scenario_id`;
ALTER TABLE `finance`.`capex_expenditure` ADD CONSTRAINT `fk_finance_capex_expenditure_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

ALTER TABLE `finance`.`opex_budget` DROP CONSTRAINT IF EXISTS `fk_finance_opex_budget_load_id`;
ALTER TABLE `finance`.`opex_budget` ADD CONSTRAINT `fk_finance_opex_budget_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `finance`.`rate_case_filing` DROP CONSTRAINT IF EXISTS `fk_finance_rate_case_filing_irp_scenario_id`;
ALTER TABLE `finance`.`rate_case_filing` ADD CONSTRAINT `fk_finance_rate_case_filing_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

ALTER TABLE `finance`.`rab_valuation` DROP CONSTRAINT IF EXISTS `fk_finance_rab_valuation_irp_scenario_id`;
ALTER TABLE `finance`.`rab_valuation` ADD CONSTRAINT `fk_finance_rab_valuation_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

-- ========= finance --> generation (12) =========
ALTER TABLE `finance`.`journal_entry` DROP CONSTRAINT IF EXISTS `fk_finance_journal_entry_generating_unit_id`;
ALTER TABLE `finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `finance`.`journal_entry` DROP CONSTRAINT IF EXISTS `fk_finance_journal_entry_power_plant_id`;
ALTER TABLE `finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `finance`.`fixed_asset` DROP CONSTRAINT IF EXISTS `fk_finance_fixed_asset_power_plant_id`;
ALTER TABLE `finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `finance`.`asset_depreciation` DROP CONSTRAINT IF EXISTS `fk_finance_asset_depreciation_generating_unit_id`;
ALTER TABLE `finance`.`asset_depreciation` ADD CONSTRAINT `fk_finance_asset_depreciation_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `finance`.`asset_depreciation` DROP CONSTRAINT IF EXISTS `fk_finance_asset_depreciation_power_plant_id`;
ALTER TABLE `finance`.`asset_depreciation` ADD CONSTRAINT `fk_finance_asset_depreciation_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `finance`.`capex_expenditure` DROP CONSTRAINT IF EXISTS `fk_finance_capex_expenditure_generating_unit_id`;
ALTER TABLE `finance`.`capex_expenditure` ADD CONSTRAINT `fk_finance_capex_expenditure_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `finance`.`capex_expenditure` DROP CONSTRAINT IF EXISTS `fk_finance_capex_expenditure_power_plant_id`;
ALTER TABLE `finance`.`capex_expenditure` ADD CONSTRAINT `fk_finance_capex_expenditure_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `finance`.`opex_budget` DROP CONSTRAINT IF EXISTS `fk_finance_opex_budget_generating_unit_id`;
ALTER TABLE `finance`.`opex_budget` ADD CONSTRAINT `fk_finance_opex_budget_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `finance`.`opex_budget` DROP CONSTRAINT IF EXISTS `fk_finance_opex_budget_power_plant_id`;
ALTER TABLE `finance`.`opex_budget` ADD CONSTRAINT `fk_finance_opex_budget_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `finance`.`regulatory_asset` DROP CONSTRAINT IF EXISTS `fk_finance_regulatory_asset_power_plant_id`;
ALTER TABLE `finance`.`regulatory_asset` ADD CONSTRAINT `fk_finance_regulatory_asset_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `finance`.`rate_case_filing` DROP CONSTRAINT IF EXISTS `fk_finance_rate_case_filing_power_plant_id`;
ALTER TABLE `finance`.`rate_case_filing` ADD CONSTRAINT `fk_finance_rate_case_filing_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `finance`.`rab_valuation` DROP CONSTRAINT IF EXISTS `fk_finance_rab_valuation_power_plant_id`;
ALTER TABLE `finance`.`rab_valuation` ADD CONSTRAINT `fk_finance_rab_valuation_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

-- ========= finance --> gis (1) =========
ALTER TABLE `finance`.`fixed_asset` DROP CONSTRAINT IF EXISTS `fk_finance_fixed_asset_gis_location_id`;
ALTER TABLE `finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

-- ========= finance --> grid (4) =========
ALTER TABLE `finance`.`fixed_asset` DROP CONSTRAINT IF EXISTS `fk_finance_fixed_asset_control_area_id`;
ALTER TABLE `finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `finance`.`capex_project` DROP CONSTRAINT IF EXISTS `fk_finance_capex_project_control_area_id`;
ALTER TABLE `finance`.`capex_project` ADD CONSTRAINT `fk_finance_capex_project_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `finance`.`capex_expenditure` DROP CONSTRAINT IF EXISTS `fk_finance_capex_expenditure_control_area_id`;
ALTER TABLE `finance`.`capex_expenditure` ADD CONSTRAINT `fk_finance_capex_expenditure_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `finance`.`regulatory_asset` DROP CONSTRAINT IF EXISTS `fk_finance_regulatory_asset_control_area_id`;
ALTER TABLE `finance`.`regulatory_asset` ADD CONSTRAINT `fk_finance_regulatory_asset_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

-- ========= finance --> supply (5) =========
ALTER TABLE `finance`.`ap_invoice` DROP CONSTRAINT IF EXISTS `fk_finance_ap_invoice_vendor_id`;
ALTER TABLE `finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `finance`.`ap_payment` DROP CONSTRAINT IF EXISTS `fk_finance_ap_payment_vendor_id`;
ALTER TABLE `finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `finance`.`capex_expenditure` DROP CONSTRAINT IF EXISTS `fk_finance_capex_expenditure_vendor_id`;
ALTER TABLE `finance`.`capex_expenditure` ADD CONSTRAINT `fk_finance_capex_expenditure_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `finance`.`vendor_bank_account` DROP CONSTRAINT IF EXISTS `fk_finance_vendor_bank_account_vendor_id`;
ALTER TABLE `finance`.`vendor_bank_account` ADD CONSTRAINT `fk_finance_vendor_bank_account_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `finance`.`payment_run` DROP CONSTRAINT IF EXISTS `fk_finance_payment_run_vendor_id`;
ALTER TABLE `finance`.`payment_run` ADD CONSTRAINT `fk_finance_payment_run_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

-- ========= finance --> workforce (19) =========
ALTER TABLE `finance`.`cost_center` DROP CONSTRAINT IF EXISTS `fk_finance_cost_center_primary_cost_employee_id`;
ALTER TABLE `finance`.`cost_center` ADD CONSTRAINT `fk_finance_cost_center_primary_cost_employee_id` FOREIGN KEY (`primary_cost_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `finance`.`profit_center` DROP CONSTRAINT IF EXISTS `fk_finance_profit_center_employee_id`;
ALTER TABLE `finance`.`profit_center` ADD CONSTRAINT `fk_finance_profit_center_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `finance`.`journal_entry` DROP CONSTRAINT IF EXISTS `fk_finance_journal_entry_approver_user_employee_id`;
ALTER TABLE `finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_approver_user_employee_id` FOREIGN KEY (`approver_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `finance`.`journal_entry` DROP CONSTRAINT IF EXISTS `fk_finance_journal_entry_primary_journal_employee_id`;
ALTER TABLE `finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_primary_journal_employee_id` FOREIGN KEY (`primary_journal_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `finance`.`capex_expenditure` DROP CONSTRAINT IF EXISTS `fk_finance_capex_expenditure_employee_id`;
ALTER TABLE `finance`.`capex_expenditure` ADD CONSTRAINT `fk_finance_capex_expenditure_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `finance`.`opex_budget` DROP CONSTRAINT IF EXISTS `fk_finance_opex_budget_employee_id`;
ALTER TABLE `finance`.`opex_budget` ADD CONSTRAINT `fk_finance_opex_budget_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `finance`.`opex_budget` DROP CONSTRAINT IF EXISTS `fk_finance_opex_budget_owner_employee_id`;
ALTER TABLE `finance`.`opex_budget` ADD CONSTRAINT `fk_finance_opex_budget_owner_employee_id` FOREIGN KEY (`owner_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `finance`.`opex_budget` DROP CONSTRAINT IF EXISTS `fk_finance_opex_budget_primary_opex_employee_id`;
ALTER TABLE `finance`.`opex_budget` ADD CONSTRAINT `fk_finance_opex_budget_primary_opex_employee_id` FOREIGN KEY (`primary_opex_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `finance`.`intercompany_transaction` DROP CONSTRAINT IF EXISTS `fk_finance_intercompany_transaction_employee_id`;
ALTER TABLE `finance`.`intercompany_transaction` ADD CONSTRAINT `fk_finance_intercompany_transaction_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `finance`.`tax_provision` DROP CONSTRAINT IF EXISTS `fk_finance_tax_provision_employee_id`;
ALTER TABLE `finance`.`tax_provision` ADD CONSTRAINT `fk_finance_tax_provision_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `finance`.`tax_provision` DROP CONSTRAINT IF EXISTS `fk_finance_tax_provision_primary_tax_employee_id`;
ALTER TABLE `finance`.`tax_provision` ADD CONSTRAINT `fk_finance_tax_provision_primary_tax_employee_id` FOREIGN KEY (`primary_tax_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `finance`.`tax_provision` DROP CONSTRAINT IF EXISTS `fk_finance_tax_provision_reviewer_employee_id`;
ALTER TABLE `finance`.`tax_provision` ADD CONSTRAINT `fk_finance_tax_provision_reviewer_employee_id` FOREIGN KEY (`reviewer_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `finance`.`treasury_position` DROP CONSTRAINT IF EXISTS `fk_finance_treasury_position_primary_treasury_employee_id`;
ALTER TABLE `finance`.`treasury_position` ADD CONSTRAINT `fk_finance_treasury_position_primary_treasury_employee_id` FOREIGN KEY (`primary_treasury_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `finance`.`treasury_position` DROP CONSTRAINT IF EXISTS `fk_finance_treasury_position_reviewer_user_employee_id`;
ALTER TABLE `finance`.`treasury_position` ADD CONSTRAINT `fk_finance_treasury_position_reviewer_user_employee_id` FOREIGN KEY (`reviewer_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `finance`.`bank_reconciliation` DROP CONSTRAINT IF EXISTS `fk_finance_bank_reconciliation_approver_user_employee_id`;
ALTER TABLE `finance`.`bank_reconciliation` ADD CONSTRAINT `fk_finance_bank_reconciliation_approver_user_employee_id` FOREIGN KEY (`approver_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `finance`.`bank_reconciliation` DROP CONSTRAINT IF EXISTS `fk_finance_bank_reconciliation_primary_bank_employee_id`;
ALTER TABLE `finance`.`bank_reconciliation` ADD CONSTRAINT `fk_finance_bank_reconciliation_primary_bank_employee_id` FOREIGN KEY (`primary_bank_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `finance`.`bank_reconciliation` DROP CONSTRAINT IF EXISTS `fk_finance_bank_reconciliation_reviewer_user_employee_id`;
ALTER TABLE `finance`.`bank_reconciliation` ADD CONSTRAINT `fk_finance_bank_reconciliation_reviewer_user_employee_id` FOREIGN KEY (`reviewer_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `finance`.`project_cost_allocation` DROP CONSTRAINT IF EXISTS `fk_finance_project_cost_allocation_approved_by_employee_id`;
ALTER TABLE `finance`.`project_cost_allocation` ADD CONSTRAINT `fk_finance_project_cost_allocation_approved_by_employee_id` FOREIGN KEY (`approved_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `finance`.`wbs_element` DROP CONSTRAINT IF EXISTS `fk_finance_wbs_element_org_unit_id`;
ALTER TABLE `finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `workforce`.`org_unit` (`org_unit_id`);

-- ========= forecast --> asset (2) =========
ALTER TABLE `forecast`.`forecast_renewable` DROP CONSTRAINT IF EXISTS `fk_forecast_forecast_renewable_registry_id`;
ALTER TABLE `forecast`.`forecast_renewable` ADD CONSTRAINT `fk_forecast_forecast_renewable_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `forecast`.`renewable_forecast_interval` DROP CONSTRAINT IF EXISTS `fk_forecast_renewable_forecast_interval_registry_id`;
ALTER TABLE `forecast`.`renewable_forecast_interval` ADD CONSTRAINT `fk_forecast_renewable_forecast_interval_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

-- ========= forecast --> compliance (1) =========
ALTER TABLE `forecast`.`irp_scenario` DROP CONSTRAINT IF EXISTS `fk_forecast_irp_scenario_irp_filing_id`;
ALTER TABLE `forecast`.`irp_scenario` ADD CONSTRAINT `fk_forecast_irp_scenario_irp_filing_id` FOREIGN KEY (`irp_filing_id`) REFERENCES `compliance`.`irp_filing` (`irp_filing_id`);

-- ========= forecast --> distribution (1) =========
ALTER TABLE `forecast`.`load` DROP CONSTRAINT IF EXISTS `fk_forecast_load_load_zone_id`;
ALTER TABLE `forecast`.`load` ADD CONSTRAINT `fk_forecast_load_load_zone_id` FOREIGN KEY (`load_zone_id`) REFERENCES `distribution`.`load_zone` (`load_zone_id`);

-- ========= forecast --> generation (2) =========
ALTER TABLE `forecast`.`forecast_generation` DROP CONSTRAINT IF EXISTS `fk_forecast_forecast_generation_generating_unit_id`;
ALTER TABLE `forecast`.`forecast_generation` ADD CONSTRAINT `fk_forecast_forecast_generation_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `forecast`.`generation_forecast_interval` DROP CONSTRAINT IF EXISTS `fk_forecast_generation_forecast_interval_generating_unit_id`;
ALTER TABLE `forecast`.`generation_forecast_interval` ADD CONSTRAINT `fk_forecast_generation_forecast_interval_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

-- ========= forecast --> gis (3) =========
ALTER TABLE `forecast`.`zone` DROP CONSTRAINT IF EXISTS `fk_forecast_zone_gis_location_id`;
ALTER TABLE `forecast`.`zone` ADD CONSTRAINT `fk_forecast_zone_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `forecast`.`pricing_node` DROP CONSTRAINT IF EXISTS `fk_forecast_pricing_node_gis_location_id`;
ALTER TABLE `forecast`.`pricing_node` ADD CONSTRAINT `fk_forecast_pricing_node_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `forecast`.`weather_station` DROP CONSTRAINT IF EXISTS `fk_forecast_weather_station_gis_location_id`;
ALTER TABLE `forecast`.`weather_station` ADD CONSTRAINT `fk_forecast_weather_station_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

-- ========= forecast --> grid (9) =========
ALTER TABLE `forecast`.`load` DROP CONSTRAINT IF EXISTS `fk_forecast_load_control_area_id`;
ALTER TABLE `forecast`.`load` ADD CONSTRAINT `fk_forecast_load_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `forecast`.`load_forecast_interval` DROP CONSTRAINT IF EXISTS `fk_forecast_load_forecast_interval_control_area_id`;
ALTER TABLE `forecast`.`load_forecast_interval` ADD CONSTRAINT `fk_forecast_load_forecast_interval_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `forecast`.`generation_forecast_interval` DROP CONSTRAINT IF EXISTS `fk_forecast_generation_forecast_interval_control_area_id`;
ALTER TABLE `forecast`.`generation_forecast_interval` ADD CONSTRAINT `fk_forecast_generation_forecast_interval_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `forecast`.`renewable_forecast_interval` DROP CONSTRAINT IF EXISTS `fk_forecast_renewable_forecast_interval_control_area_id`;
ALTER TABLE `forecast`.`renewable_forecast_interval` ADD CONSTRAINT `fk_forecast_renewable_forecast_interval_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `forecast`.`peak_demand` DROP CONSTRAINT IF EXISTS `fk_forecast_peak_demand_control_area_id`;
ALTER TABLE `forecast`.`peak_demand` ADD CONSTRAINT `fk_forecast_peak_demand_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `forecast`.`irp_scenario` DROP CONSTRAINT IF EXISTS `fk_forecast_irp_scenario_control_area_id`;
ALTER TABLE `forecast`.`irp_scenario` ADD CONSTRAINT `fk_forecast_irp_scenario_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `forecast`.`capacity_requirement` DROP CONSTRAINT IF EXISTS `fk_forecast_capacity_requirement_control_area_id`;
ALTER TABLE `forecast`.`capacity_requirement` ADD CONSTRAINT `fk_forecast_capacity_requirement_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `forecast`.`energy_price` DROP CONSTRAINT IF EXISTS `fk_forecast_energy_price_control_area_id`;
ALTER TABLE `forecast`.`energy_price` ADD CONSTRAINT `fk_forecast_energy_price_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `forecast`.`resource_adequacy_assessment` DROP CONSTRAINT IF EXISTS `fk_forecast_resource_adequacy_assessment_control_area_id`;
ALTER TABLE `forecast`.`resource_adequacy_assessment` ADD CONSTRAINT `fk_forecast_resource_adequacy_assessment_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

-- ========= forecast --> metering (4) =========
ALTER TABLE `forecast`.`load_forecast_interval` DROP CONSTRAINT IF EXISTS `fk_forecast_load_forecast_interval_meter_point_id`;
ALTER TABLE `forecast`.`load_forecast_interval` ADD CONSTRAINT `fk_forecast_load_forecast_interval_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `forecast`.`load_forecast_interval` DROP CONSTRAINT IF EXISTS `fk_forecast_load_forecast_interval_validated_interval_reading_id`;
ALTER TABLE `forecast`.`load_forecast_interval` ADD CONSTRAINT `fk_forecast_load_forecast_interval_validated_interval_reading_id` FOREIGN KEY (`validated_interval_reading_id`) REFERENCES `metering`.`validated_interval_reading` (`validated_interval_reading_id`);

ALTER TABLE `forecast`.`accuracy` DROP CONSTRAINT IF EXISTS `fk_forecast_accuracy_meter_point_id`;
ALTER TABLE `forecast`.`accuracy` ADD CONSTRAINT `fk_forecast_accuracy_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `forecast`.`irp_scenario_year` DROP CONSTRAINT IF EXISTS `fk_forecast_irp_scenario_year_meter_point_id`;
ALTER TABLE `forecast`.`irp_scenario_year` ADD CONSTRAINT `fk_forecast_irp_scenario_year_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

-- ========= forecast --> trading (1) =========
ALTER TABLE `forecast`.`forecast_renewable` DROP CONSTRAINT IF EXISTS `fk_forecast_forecast_renewable_ppa_id`;
ALTER TABLE `forecast`.`forecast_renewable` ADD CONSTRAINT `fk_forecast_forecast_renewable_ppa_id` FOREIGN KEY (`ppa_id`) REFERENCES `trading`.`ppa` (`ppa_id`);

-- ========= forecast --> workforce (8) =========
ALTER TABLE `forecast`.`irp_scenario` DROP CONSTRAINT IF EXISTS `fk_forecast_irp_scenario_owning_org_unit_id`;
ALTER TABLE `forecast`.`irp_scenario` ADD CONSTRAINT `fk_forecast_irp_scenario_owning_org_unit_id` FOREIGN KEY (`owning_org_unit_id`) REFERENCES `workforce`.`org_unit` (`org_unit_id`);

ALTER TABLE `forecast`.`energy_price` DROP CONSTRAINT IF EXISTS `fk_forecast_energy_price_employee_id`;
ALTER TABLE `forecast`.`energy_price` ADD CONSTRAINT `fk_forecast_energy_price_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `forecast`.`planning_assumption` DROP CONSTRAINT IF EXISTS `fk_forecast_planning_assumption_created_by_employee_id`;
ALTER TABLE `forecast`.`planning_assumption` ADD CONSTRAINT `fk_forecast_planning_assumption_created_by_employee_id` FOREIGN KEY (`created_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `forecast`.`fuel_price_assumption` DROP CONSTRAINT IF EXISTS `fk_forecast_fuel_price_assumption_created_by_employee_id`;
ALTER TABLE `forecast`.`fuel_price_assumption` ADD CONSTRAINT `fk_forecast_fuel_price_assumption_created_by_employee_id` FOREIGN KEY (`created_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `forecast`.`forecast_run` DROP CONSTRAINT IF EXISTS `fk_forecast_forecast_run_primary_forecast_employee_id`;
ALTER TABLE `forecast`.`forecast_run` ADD CONSTRAINT `fk_forecast_forecast_run_primary_forecast_employee_id` FOREIGN KEY (`primary_forecast_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `forecast`.`revision` DROP CONSTRAINT IF EXISTS `fk_forecast_revision_revision_approved_by_user_employee_id`;
ALTER TABLE `forecast`.`revision` ADD CONSTRAINT `fk_forecast_revision_revision_approved_by_user_employee_id` FOREIGN KEY (`revision_approved_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `forecast`.`revision` DROP CONSTRAINT IF EXISTS `fk_forecast_revision_revision_employee_id`;
ALTER TABLE `forecast`.`revision` ADD CONSTRAINT `fk_forecast_revision_revision_employee_id` FOREIGN KEY (`revision_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `forecast`.`resource_adequacy_assessment` DROP CONSTRAINT IF EXISTS `fk_forecast_resource_adequacy_assessment_responsible_org_unit_id`;
ALTER TABLE `forecast`.`resource_adequacy_assessment` ADD CONSTRAINT `fk_forecast_resource_adequacy_assessment_responsible_org_unit_id` FOREIGN KEY (`responsible_org_unit_id`) REFERENCES `workforce`.`org_unit` (`org_unit_id`);

-- ========= generation --> asset (6) =========
ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_maintenance_plan_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_maintenance_plan_id` FOREIGN KEY (`maintenance_plan_id`) REFERENCES `asset`.`maintenance_plan` (`maintenance_plan_id`);

ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_registry_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `generation`.`power_plant` DROP CONSTRAINT IF EXISTS `fk_generation_power_plant_registry_id`;
ALTER TABLE `generation`.`power_plant` ADD CONSTRAINT `fk_generation_power_plant_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `generation`.`heat_rate_test` DROP CONSTRAINT IF EXISTS `fk_generation_heat_rate_test_work_order_id`;
ALTER TABLE `generation`.`heat_rate_test` ADD CONSTRAINT `fk_generation_heat_rate_test_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_work_order_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `generation`.`capacity_plan` DROP CONSTRAINT IF EXISTS `fk_generation_capacity_plan_capital_project_id`;
ALTER TABLE `generation`.`capacity_plan` ADD CONSTRAINT `fk_generation_capacity_plan_capital_project_id` FOREIGN KEY (`capital_project_id`) REFERENCES `asset`.`capital_project` (`capital_project_id`);

-- ========= generation --> compliance (16) =========
ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_obligation_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_unit_environmental_permit_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_unit_environmental_permit_id` FOREIGN KEY (`unit_environmental_permit_id`) REFERENCES `compliance`.`environmental_permit` (`environmental_permit_id`);

ALTER TABLE `generation`.`unit_commitment` DROP CONSTRAINT IF EXISTS `fk_generation_unit_commitment_commitment_obligation_id`;
ALTER TABLE `generation`.`unit_commitment` ADD CONSTRAINT `fk_generation_unit_commitment_commitment_obligation_id` FOREIGN KEY (`commitment_obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `generation`.`unit_commitment` DROP CONSTRAINT IF EXISTS `fk_generation_unit_commitment_environmental_permit_id`;
ALTER TABLE `generation`.`unit_commitment` ADD CONSTRAINT `fk_generation_unit_commitment_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `compliance`.`environmental_permit` (`environmental_permit_id`);

ALTER TABLE `generation`.`dispatch_schedule` DROP CONSTRAINT IF EXISTS `fk_generation_dispatch_schedule_obligation_id`;
ALTER TABLE `generation`.`dispatch_schedule` ADD CONSTRAINT `fk_generation_dispatch_schedule_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `generation`.`heat_rate_test` DROP CONSTRAINT IF EXISTS `fk_generation_heat_rate_test_obligation_id`;
ALTER TABLE `generation`.`heat_rate_test` ADD CONSTRAINT `fk_generation_heat_rate_test_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `generation`.`emissions_reading` DROP CONSTRAINT IF EXISTS `fk_generation_emissions_reading_obligation_id`;
ALTER TABLE `generation`.`emissions_reading` ADD CONSTRAINT `fk_generation_emissions_reading_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_corrective_action_plan_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_corrective_action_plan_id` FOREIGN KEY (`corrective_action_plan_id`) REFERENCES `compliance`.`corrective_action_plan` (`corrective_action_plan_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_regulatory_filing_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `generation`.`startup_event` DROP CONSTRAINT IF EXISTS `fk_generation_startup_event_environmental_permit_id`;
ALTER TABLE `generation`.`startup_event` ADD CONSTRAINT `fk_generation_startup_event_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `compliance`.`environmental_permit` (`environmental_permit_id`);

ALTER TABLE `generation`.`capacity_plan` DROP CONSTRAINT IF EXISTS `fk_generation_capacity_plan_irp_filing_id`;
ALTER TABLE `generation`.`capacity_plan` ADD CONSTRAINT `fk_generation_capacity_plan_irp_filing_id` FOREIGN KEY (`irp_filing_id`) REFERENCES `compliance`.`irp_filing` (`irp_filing_id`);

ALTER TABLE `generation`.`ancillary_service_offer` DROP CONSTRAINT IF EXISTS `fk_generation_ancillary_service_offer_obligation_id`;
ALTER TABLE `generation`.`ancillary_service_offer` ADD CONSTRAINT `fk_generation_ancillary_service_offer_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `generation`.`capacity_market_offer` DROP CONSTRAINT IF EXISTS `fk_generation_capacity_market_offer_obligation_id`;
ALTER TABLE `generation`.`capacity_market_offer` ADD CONSTRAINT `fk_generation_capacity_market_offer_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `generation`.`gads_report` DROP CONSTRAINT IF EXISTS `fk_generation_gads_report_obligation_id`;
ALTER TABLE `generation`.`gads_report` ADD CONSTRAINT `fk_generation_gads_report_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `generation`.`fuel_contract` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_contract_regulatory_filing_id`;
ALTER TABLE `generation`.`fuel_contract` ADD CONSTRAINT `fk_generation_fuel_contract_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `generation`.`facility_audit_scope` DROP CONSTRAINT IF EXISTS `fk_generation_facility_audit_scope_audit_id`;
ALTER TABLE `generation`.`facility_audit_scope` ADD CONSTRAINT `fk_generation_facility_audit_scope_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

-- ========= generation --> demand (4) =========
ALTER TABLE `generation`.`unit_commitment` DROP CONSTRAINT IF EXISTS `fk_generation_unit_commitment_dr_event_id`;
ALTER TABLE `generation`.`unit_commitment` ADD CONSTRAINT `fk_generation_unit_commitment_dr_event_id` FOREIGN KEY (`dr_event_id`) REFERENCES `demand`.`dr_event` (`dr_event_id`);

ALTER TABLE `generation`.`dispatch_schedule` DROP CONSTRAINT IF EXISTS `fk_generation_dispatch_schedule_dr_event_id`;
ALTER TABLE `generation`.`dispatch_schedule` ADD CONSTRAINT `fk_generation_dispatch_schedule_dr_event_id` FOREIGN KEY (`dr_event_id`) REFERENCES `demand`.`dr_event` (`dr_event_id`);

ALTER TABLE `generation`.`capacity_plan` DROP CONSTRAINT IF EXISTS `fk_generation_capacity_plan_dr_program_id`;
ALTER TABLE `generation`.`capacity_plan` ADD CONSTRAINT `fk_generation_capacity_plan_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `generation`.`capacity_market_offer` DROP CONSTRAINT IF EXISTS `fk_generation_capacity_market_offer_dr_capacity_registration_id`;
ALTER TABLE `generation`.`capacity_market_offer` ADD CONSTRAINT `fk_generation_capacity_market_offer_dr_capacity_registration_id` FOREIGN KEY (`dr_capacity_registration_id`) REFERENCES `demand`.`dr_capacity_registration` (`dr_capacity_registration_id`);

-- ========= generation --> finance (12) =========
ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_cost_center_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_profit_center_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `generation`.`power_plant` DROP CONSTRAINT IF EXISTS `fk_generation_power_plant_cost_center_id`;
ALTER TABLE `generation`.`power_plant` ADD CONSTRAINT `fk_generation_power_plant_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `generation`.`power_plant` DROP CONSTRAINT IF EXISTS `fk_generation_power_plant_profit_center_id`;
ALTER TABLE `generation`.`power_plant` ADD CONSTRAINT `fk_generation_power_plant_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `generation`.`unit_commitment` DROP CONSTRAINT IF EXISTS `fk_generation_unit_commitment_internal_order_id`;
ALTER TABLE `generation`.`unit_commitment` ADD CONSTRAINT `fk_generation_unit_commitment_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `finance`.`internal_order` (`internal_order_id`);

ALTER TABLE `generation`.`fuel_inventory` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_inventory_cost_center_id`;
ALTER TABLE `generation`.`fuel_inventory` ADD CONSTRAINT `fk_generation_fuel_inventory_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `generation`.`fuel_inventory` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_inventory_gl_account_id`;
ALTER TABLE `generation`.`fuel_inventory` ADD CONSTRAINT `fk_generation_fuel_inventory_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `generation`.`emissions_reading` DROP CONSTRAINT IF EXISTS `fk_generation_emissions_reading_cost_center_id`;
ALTER TABLE `generation`.`emissions_reading` ADD CONSTRAINT `fk_generation_emissions_reading_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_capex_project_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_capex_project_id` FOREIGN KEY (`capex_project_id`) REFERENCES `finance`.`capex_project` (`capex_project_id`);

ALTER TABLE `generation`.`capacity_plan` DROP CONSTRAINT IF EXISTS `fk_generation_capacity_plan_capex_project_id`;
ALTER TABLE `generation`.`capacity_plan` ADD CONSTRAINT `fk_generation_capacity_plan_capex_project_id` FOREIGN KEY (`capex_project_id`) REFERENCES `finance`.`capex_project` (`capex_project_id`);

ALTER TABLE `generation`.`fuel_contract` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_contract_ap_invoice_id`;
ALTER TABLE `generation`.`fuel_contract` ADD CONSTRAINT `fk_generation_fuel_contract_ap_invoice_id` FOREIGN KEY (`ap_invoice_id`) REFERENCES `finance`.`ap_invoice` (`ap_invoice_id`);

ALTER TABLE `generation`.`fuel_contract` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_contract_cost_center_id`;
ALTER TABLE `generation`.`fuel_contract` ADD CONSTRAINT `fk_generation_fuel_contract_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

-- ========= generation --> forecast (6) =========
ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_forecast_zone_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `generation`.`power_plant` DROP CONSTRAINT IF EXISTS `fk_generation_power_plant_forecast_zone_id`;
ALTER TABLE `generation`.`power_plant` ADD CONSTRAINT `fk_generation_power_plant_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `generation`.`unit_commitment` DROP CONSTRAINT IF EXISTS `fk_generation_unit_commitment_load_id`;
ALTER TABLE `generation`.`unit_commitment` ADD CONSTRAINT `fk_generation_unit_commitment_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `generation`.`dispatch_schedule` DROP CONSTRAINT IF EXISTS `fk_generation_dispatch_schedule_load_id`;
ALTER TABLE `generation`.`dispatch_schedule` ADD CONSTRAINT `fk_generation_dispatch_schedule_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `generation`.`capacity_plan` DROP CONSTRAINT IF EXISTS `fk_generation_capacity_plan_peak_demand_id`;
ALTER TABLE `generation`.`capacity_plan` ADD CONSTRAINT `fk_generation_capacity_plan_peak_demand_id` FOREIGN KEY (`peak_demand_id`) REFERENCES `forecast`.`peak_demand` (`peak_demand_id`);

ALTER TABLE `generation`.`fuel_contract` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_contract_fuel_price_assumption_id`;
ALTER TABLE `generation`.`fuel_contract` ADD CONSTRAINT `fk_generation_fuel_contract_fuel_price_assumption_id` FOREIGN KEY (`fuel_price_assumption_id`) REFERENCES `forecast`.`fuel_price_assumption` (`fuel_price_assumption_id`);

-- ========= generation --> gis (2) =========
ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_gis_location_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `generation`.`power_plant` DROP CONSTRAINT IF EXISTS `fk_generation_power_plant_gis_location_id`;
ALTER TABLE `generation`.`power_plant` ADD CONSTRAINT `fk_generation_power_plant_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

-- ========= generation --> grid (41) =========
ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_contingency_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_contingency_id` FOREIGN KEY (`contingency_id`) REFERENCES `grid`.`contingency` (`contingency_id`);

ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_ems_alarm_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_ems_alarm_id` FOREIGN KEY (`ems_alarm_id`) REFERENCES `grid`.`ems_alarm` (`ems_alarm_id`);

ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_ems_node_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_ems_node_id` FOREIGN KEY (`ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_operating_limit_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_operating_limit_id` FOREIGN KEY (`operating_limit_id`) REFERENCES `grid`.`operating_limit` (`operating_limit_id`);

ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_pmu_device_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_pmu_device_id` FOREIGN KEY (`pmu_device_id`) REFERENCES `grid`.`pmu_device` (`pmu_device_id`);

ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_scada_point_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `generation`.`power_plant` DROP CONSTRAINT IF EXISTS `fk_generation_power_plant_contingency_id`;
ALTER TABLE `generation`.`power_plant` ADD CONSTRAINT `fk_generation_power_plant_contingency_id` FOREIGN KEY (`contingency_id`) REFERENCES `grid`.`contingency` (`contingency_id`);

ALTER TABLE `generation`.`power_plant` DROP CONSTRAINT IF EXISTS `fk_generation_power_plant_control_area_id`;
ALTER TABLE `generation`.`power_plant` ADD CONSTRAINT `fk_generation_power_plant_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `generation`.`power_plant` DROP CONSTRAINT IF EXISTS `fk_generation_power_plant_ems_node_id`;
ALTER TABLE `generation`.`power_plant` ADD CONSTRAINT `fk_generation_power_plant_ems_node_id` FOREIGN KEY (`ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `generation`.`power_plant` DROP CONSTRAINT IF EXISTS `fk_generation_power_plant_grid_topology_snapshot_id`;
ALTER TABLE `generation`.`power_plant` ADD CONSTRAINT `fk_generation_power_plant_grid_topology_snapshot_id` FOREIGN KEY (`grid_topology_snapshot_id`) REFERENCES `grid`.`topology_snapshot` (`topology_snapshot_id`);

ALTER TABLE `generation`.`power_plant` DROP CONSTRAINT IF EXISTS `fk_generation_power_plant_operating_limit_id`;
ALTER TABLE `generation`.`power_plant` ADD CONSTRAINT `fk_generation_power_plant_operating_limit_id` FOREIGN KEY (`operating_limit_id`) REFERENCES `grid`.`operating_limit` (`operating_limit_id`);

ALTER TABLE `generation`.`power_plant` DROP CONSTRAINT IF EXISTS `fk_generation_power_plant_pmu_device_id`;
ALTER TABLE `generation`.`power_plant` ADD CONSTRAINT `fk_generation_power_plant_pmu_device_id` FOREIGN KEY (`pmu_device_id`) REFERENCES `grid`.`pmu_device` (`pmu_device_id`);

ALTER TABLE `generation`.`unit_commitment` DROP CONSTRAINT IF EXISTS `fk_generation_unit_commitment_contingency_analysis_run_id`;
ALTER TABLE `generation`.`unit_commitment` ADD CONSTRAINT `fk_generation_unit_commitment_contingency_analysis_run_id` FOREIGN KEY (`contingency_analysis_run_id`) REFERENCES `grid`.`contingency_analysis_run` (`contingency_analysis_run_id`);

ALTER TABLE `generation`.`unit_commitment` DROP CONSTRAINT IF EXISTS `fk_generation_unit_commitment_control_area_id`;
ALTER TABLE `generation`.`unit_commitment` ADD CONSTRAINT `fk_generation_unit_commitment_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `generation`.`unit_commitment` DROP CONSTRAINT IF EXISTS `fk_generation_unit_commitment_interchange_schedule_id`;
ALTER TABLE `generation`.`unit_commitment` ADD CONSTRAINT `fk_generation_unit_commitment_interchange_schedule_id` FOREIGN KEY (`interchange_schedule_id`) REFERENCES `grid`.`interchange_schedule` (`interchange_schedule_id`);

ALTER TABLE `generation`.`unit_commitment` DROP CONSTRAINT IF EXISTS `fk_generation_unit_commitment_operator_log_id`;
ALTER TABLE `generation`.`unit_commitment` ADD CONSTRAINT `fk_generation_unit_commitment_operator_log_id` FOREIGN KEY (`operator_log_id`) REFERENCES `grid`.`operator_log` (`operator_log_id`);

ALTER TABLE `generation`.`dispatch_schedule` DROP CONSTRAINT IF EXISTS `fk_generation_dispatch_schedule_contingency_analysis_run_id`;
ALTER TABLE `generation`.`dispatch_schedule` ADD CONSTRAINT `fk_generation_dispatch_schedule_contingency_analysis_run_id` FOREIGN KEY (`contingency_analysis_run_id`) REFERENCES `grid`.`contingency_analysis_run` (`contingency_analysis_run_id`);

ALTER TABLE `generation`.`dispatch_schedule` DROP CONSTRAINT IF EXISTS `fk_generation_dispatch_schedule_control_area_id`;
ALTER TABLE `generation`.`dispatch_schedule` ADD CONSTRAINT `fk_generation_dispatch_schedule_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `generation`.`dispatch_schedule` DROP CONSTRAINT IF EXISTS `fk_generation_dispatch_schedule_operator_log_id`;
ALTER TABLE `generation`.`dispatch_schedule` ADD CONSTRAINT `fk_generation_dispatch_schedule_operator_log_id` FOREIGN KEY (`operator_log_id`) REFERENCES `grid`.`operator_log` (`operator_log_id`);

ALTER TABLE `generation`.`dispatch_schedule` DROP CONSTRAINT IF EXISTS `fk_generation_dispatch_schedule_state_estimation_run_id`;
ALTER TABLE `generation`.`dispatch_schedule` ADD CONSTRAINT `fk_generation_dispatch_schedule_state_estimation_run_id` FOREIGN KEY (`state_estimation_run_id`) REFERENCES `grid`.`state_estimation_run` (`state_estimation_run_id`);

ALTER TABLE `generation`.`output_telemetry` DROP CONSTRAINT IF EXISTS `fk_generation_output_telemetry_control_area_id`;
ALTER TABLE `generation`.`output_telemetry` ADD CONSTRAINT `fk_generation_output_telemetry_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `generation`.`output_telemetry` DROP CONSTRAINT IF EXISTS `fk_generation_output_telemetry_state_estimation_run_id`;
ALTER TABLE `generation`.`output_telemetry` ADD CONSTRAINT `fk_generation_output_telemetry_state_estimation_run_id` FOREIGN KEY (`state_estimation_run_id`) REFERENCES `grid`.`state_estimation_run` (`state_estimation_run_id`);

ALTER TABLE `generation`.`emissions_reading` DROP CONSTRAINT IF EXISTS `fk_generation_emissions_reading_control_area_id`;
ALTER TABLE `generation`.`emissions_reading` ADD CONSTRAINT `fk_generation_emissions_reading_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_contingency_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_contingency_id` FOREIGN KEY (`contingency_id`) REFERENCES `grid`.`contingency` (`contingency_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_contingency_violation_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_contingency_violation_id` FOREIGN KEY (`contingency_violation_id`) REFERENCES `grid`.`contingency_violation` (`contingency_violation_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_control_area_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_ems_alarm_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_ems_alarm_id` FOREIGN KEY (`ems_alarm_id`) REFERENCES `grid`.`ems_alarm` (`ems_alarm_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_grid_reliability_event_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_grid_reliability_event_id` FOREIGN KEY (`grid_reliability_event_id`) REFERENCES `grid`.`grid_reliability_event` (`grid_reliability_event_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_grid_switching_order_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_grid_switching_order_id` FOREIGN KEY (`grid_switching_order_id`) REFERENCES `grid`.`grid_switching_order` (`grid_switching_order_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_operator_log_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_operator_log_id` FOREIGN KEY (`operator_log_id`) REFERENCES `grid`.`operator_log` (`operator_log_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_protection_event_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_protection_event_id` FOREIGN KEY (`protection_event_id`) REFERENCES `grid`.`protection_event` (`protection_event_id`);

ALTER TABLE `generation`.`startup_event` DROP CONSTRAINT IF EXISTS `fk_generation_startup_event_control_area_id`;
ALTER TABLE `generation`.`startup_event` ADD CONSTRAINT `fk_generation_startup_event_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `generation`.`startup_event` DROP CONSTRAINT IF EXISTS `fk_generation_startup_event_ems_alarm_id`;
ALTER TABLE `generation`.`startup_event` ADD CONSTRAINT `fk_generation_startup_event_ems_alarm_id` FOREIGN KEY (`ems_alarm_id`) REFERENCES `grid`.`ems_alarm` (`ems_alarm_id`);

ALTER TABLE `generation`.`startup_event` DROP CONSTRAINT IF EXISTS `fk_generation_startup_event_frequency_event_id`;
ALTER TABLE `generation`.`startup_event` ADD CONSTRAINT `fk_generation_startup_event_frequency_event_id` FOREIGN KEY (`frequency_event_id`) REFERENCES `grid`.`frequency_event` (`frequency_event_id`);

ALTER TABLE `generation`.`startup_event` DROP CONSTRAINT IF EXISTS `fk_generation_startup_event_grid_reliability_event_id`;
ALTER TABLE `generation`.`startup_event` ADD CONSTRAINT `fk_generation_startup_event_grid_reliability_event_id` FOREIGN KEY (`grid_reliability_event_id`) REFERENCES `grid`.`grid_reliability_event` (`grid_reliability_event_id`);

ALTER TABLE `generation`.`startup_event` DROP CONSTRAINT IF EXISTS `fk_generation_startup_event_grid_switching_order_id`;
ALTER TABLE `generation`.`startup_event` ADD CONSTRAINT `fk_generation_startup_event_grid_switching_order_id` FOREIGN KEY (`grid_switching_order_id`) REFERENCES `grid`.`grid_switching_order` (`grid_switching_order_id`);

ALTER TABLE `generation`.`startup_event` DROP CONSTRAINT IF EXISTS `fk_generation_startup_event_operator_log_id`;
ALTER TABLE `generation`.`startup_event` ADD CONSTRAINT `fk_generation_startup_event_operator_log_id` FOREIGN KEY (`operator_log_id`) REFERENCES `grid`.`operator_log` (`operator_log_id`);

ALTER TABLE `generation`.`capacity_plan` DROP CONSTRAINT IF EXISTS `fk_generation_capacity_plan_control_area_id`;
ALTER TABLE `generation`.`capacity_plan` ADD CONSTRAINT `fk_generation_capacity_plan_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `generation`.`ancillary_service_offer` DROP CONSTRAINT IF EXISTS `fk_generation_ancillary_service_offer_control_area_id`;
ALTER TABLE `generation`.`ancillary_service_offer` ADD CONSTRAINT `fk_generation_ancillary_service_offer_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `generation`.`capacity_market_offer` DROP CONSTRAINT IF EXISTS `fk_generation_capacity_market_offer_control_area_id`;
ALTER TABLE `generation`.`capacity_market_offer` ADD CONSTRAINT `fk_generation_capacity_market_offer_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `generation`.`gads_report` DROP CONSTRAINT IF EXISTS `fk_generation_gads_report_control_area_id`;
ALTER TABLE `generation`.`gads_report` ADD CONSTRAINT `fk_generation_gads_report_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

-- ========= generation --> outage (3) =========
ALTER TABLE `generation`.`unit_commitment` DROP CONSTRAINT IF EXISTS `fk_generation_unit_commitment_event_id`;
ALTER TABLE `generation`.`unit_commitment` ADD CONSTRAINT `fk_generation_unit_commitment_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `generation`.`dispatch_schedule` DROP CONSTRAINT IF EXISTS `fk_generation_dispatch_schedule_event_id`;
ALTER TABLE `generation`.`dispatch_schedule` ADD CONSTRAINT `fk_generation_dispatch_schedule_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `generation`.`startup_event` DROP CONSTRAINT IF EXISTS `fk_generation_startup_event_event_id`;
ALTER TABLE `generation`.`startup_event` ADD CONSTRAINT `fk_generation_startup_event_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

-- ========= generation --> renewable (3) =========
ALTER TABLE `generation`.`power_plant` DROP CONSTRAINT IF EXISTS `fk_generation_power_plant_renewable_ppa_contract_id`;
ALTER TABLE `generation`.`power_plant` ADD CONSTRAINT `fk_generation_power_plant_renewable_ppa_contract_id` FOREIGN KEY (`renewable_ppa_contract_id`) REFERENCES `renewable`.`ppa_contract` (`ppa_contract_id`);

ALTER TABLE `generation`.`capacity_plan` DROP CONSTRAINT IF EXISTS `fk_generation_capacity_plan_renewable_interconnection_queue_id`;
ALTER TABLE `generation`.`capacity_plan` ADD CONSTRAINT `fk_generation_capacity_plan_renewable_interconnection_queue_id` FOREIGN KEY (`renewable_interconnection_queue_id`) REFERENCES `renewable`.`interconnection_queue` (`interconnection_queue_id`);

ALTER TABLE `generation`.`capacity_plan` DROP CONSTRAINT IF EXISTS `fk_generation_capacity_plan_rps_obligation_id`;
ALTER TABLE `generation`.`capacity_plan` ADD CONSTRAINT `fk_generation_capacity_plan_rps_obligation_id` FOREIGN KEY (`rps_obligation_id`) REFERENCES `renewable`.`rps_obligation` (`rps_obligation_id`);

-- ========= generation --> supply (13) =========
ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_critical_spare_part_material_master_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_critical_spare_part_material_master_id` FOREIGN KEY (`critical_spare_part_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_spare_parts_catalog_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_spare_parts_catalog_id` FOREIGN KEY (`spare_parts_catalog_id`) REFERENCES `supply`.`spare_parts_catalog` (`spare_parts_catalog_id`);

ALTER TABLE `generation`.`power_plant` DROP CONSTRAINT IF EXISTS `fk_generation_power_plant_primary_warehouse_id`;
ALTER TABLE `generation`.`power_plant` ADD CONSTRAINT `fk_generation_power_plant_primary_warehouse_id` FOREIGN KEY (`primary_warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `generation`.`fuel_inventory` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_inventory_goods_receipt_id`;
ALTER TABLE `generation`.`fuel_inventory` ADD CONSTRAINT `fk_generation_fuel_inventory_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `supply`.`goods_receipt` (`goods_receipt_id`);

ALTER TABLE `generation`.`fuel_inventory` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_inventory_material_master_id`;
ALTER TABLE `generation`.`fuel_inventory` ADD CONSTRAINT `fk_generation_fuel_inventory_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `generation`.`fuel_inventory` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_inventory_warehouse_id`;
ALTER TABLE `generation`.`fuel_inventory` ADD CONSTRAINT `fk_generation_fuel_inventory_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_emergency_purchase_order_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_emergency_purchase_order_id` FOREIGN KEY (`emergency_purchase_order_id`) REFERENCES `supply`.`purchase_order` (`purchase_order_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_emergency_stock_event_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_emergency_stock_event_id` FOREIGN KEY (`emergency_stock_event_id`) REFERENCES `supply`.`emergency_stock_event` (`emergency_stock_event_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_goods_issue_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_goods_issue_id` FOREIGN KEY (`goods_issue_id`) REFERENCES `supply`.`goods_issue` (`goods_issue_id`);

ALTER TABLE `generation`.`startup_event` DROP CONSTRAINT IF EXISTS `fk_generation_startup_event_startup_consumables_material_master_id`;
ALTER TABLE `generation`.`startup_event` ADD CONSTRAINT `fk_generation_startup_event_startup_consumables_material_master_id` FOREIGN KEY (`startup_consumables_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `generation`.`fuel_contract` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_contract_primary_fuel_vendor_id`;
ALTER TABLE `generation`.`fuel_contract` ADD CONSTRAINT `fk_generation_fuel_contract_primary_fuel_vendor_id` FOREIGN KEY (`primary_fuel_vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `generation`.`fuel_contract` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_contract_purchase_order_id`;
ALTER TABLE `generation`.`fuel_contract` ADD CONSTRAINT `fk_generation_fuel_contract_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `supply`.`purchase_order` (`purchase_order_id`);

ALTER TABLE `generation`.`plant_vendor_agreement` DROP CONSTRAINT IF EXISTS `fk_generation_plant_vendor_agreement_vendor_id`;
ALTER TABLE `generation`.`plant_vendor_agreement` ADD CONSTRAINT `fk_generation_plant_vendor_agreement_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

-- ========= generation --> trading (11) =========
ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_book_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_book_id` FOREIGN KEY (`book_id`) REFERENCES `trading`.`book` (`book_id`);

ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_hedge_strategy_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_hedge_strategy_id` FOREIGN KEY (`hedge_strategy_id`) REFERENCES `trading`.`hedge_strategy` (`hedge_strategy_id`);

ALTER TABLE `generation`.`power_plant` DROP CONSTRAINT IF EXISTS `fk_generation_power_plant_book_id`;
ALTER TABLE `generation`.`power_plant` ADD CONSTRAINT `fk_generation_power_plant_book_id` FOREIGN KEY (`book_id`) REFERENCES `trading`.`book` (`book_id`);

ALTER TABLE `generation`.`unit_commitment` DROP CONSTRAINT IF EXISTS `fk_generation_unit_commitment_trade_id`;
ALTER TABLE `generation`.`unit_commitment` ADD CONSTRAINT `fk_generation_unit_commitment_trade_id` FOREIGN KEY (`trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `generation`.`dispatch_schedule` DROP CONSTRAINT IF EXISTS `fk_generation_dispatch_schedule_energy_schedule_id`;
ALTER TABLE `generation`.`dispatch_schedule` ADD CONSTRAINT `fk_generation_dispatch_schedule_energy_schedule_id` FOREIGN KEY (`energy_schedule_id`) REFERENCES `trading`.`energy_schedule` (`energy_schedule_id`);

ALTER TABLE `generation`.`output_telemetry` DROP CONSTRAINT IF EXISTS `fk_generation_output_telemetry_market_settlement_id`;
ALTER TABLE `generation`.`output_telemetry` ADD CONSTRAINT `fk_generation_output_telemetry_market_settlement_id` FOREIGN KEY (`market_settlement_id`) REFERENCES `trading`.`market_settlement` (`market_settlement_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_energy_schedule_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_energy_schedule_id` FOREIGN KEY (`energy_schedule_id`) REFERENCES `trading`.`energy_schedule` (`energy_schedule_id`);

ALTER TABLE `generation`.`capacity_plan` DROP CONSTRAINT IF EXISTS `fk_generation_capacity_plan_capacity_obligation_id`;
ALTER TABLE `generation`.`capacity_plan` ADD CONSTRAINT `fk_generation_capacity_plan_capacity_obligation_id` FOREIGN KEY (`capacity_obligation_id`) REFERENCES `trading`.`capacity_obligation` (`capacity_obligation_id`);

ALTER TABLE `generation`.`ancillary_service_offer` DROP CONSTRAINT IF EXISTS `fk_generation_ancillary_service_offer_ancillary_service_award_id`;
ALTER TABLE `generation`.`ancillary_service_offer` ADD CONSTRAINT `fk_generation_ancillary_service_offer_ancillary_service_award_id` FOREIGN KEY (`ancillary_service_award_id`) REFERENCES `trading`.`ancillary_service_award` (`ancillary_service_award_id`);

ALTER TABLE `generation`.`capacity_market_offer` DROP CONSTRAINT IF EXISTS `fk_generation_capacity_market_offer_capacity_obligation_id`;
ALTER TABLE `generation`.`capacity_market_offer` ADD CONSTRAINT `fk_generation_capacity_market_offer_capacity_obligation_id` FOREIGN KEY (`capacity_obligation_id`) REFERENCES `trading`.`capacity_obligation` (`capacity_obligation_id`);

ALTER TABLE `generation`.`fuel_contract` DROP CONSTRAINT IF EXISTS `fk_generation_fuel_contract_hedge_strategy_id`;
ALTER TABLE `generation`.`fuel_contract` ADD CONSTRAINT `fk_generation_fuel_contract_hedge_strategy_id` FOREIGN KEY (`hedge_strategy_id`) REFERENCES `trading`.`hedge_strategy` (`hedge_strategy_id`);

-- ========= generation --> transmission (6) =========
ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_transmission_substation_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_transmission_substation_id` FOREIGN KEY (`transmission_substation_id`) REFERENCES `transmission`.`transmission_substation` (`transmission_substation_id`);

ALTER TABLE `generation`.`power_plant` DROP CONSTRAINT IF EXISTS `fk_generation_power_plant_poi_transmission_substation_id`;
ALTER TABLE `generation`.`power_plant` ADD CONSTRAINT `fk_generation_power_plant_poi_transmission_substation_id` FOREIGN KEY (`poi_transmission_substation_id`) REFERENCES `transmission`.`transmission_substation` (`transmission_substation_id`);

ALTER TABLE `generation`.`unit_commitment` DROP CONSTRAINT IF EXISTS `fk_generation_unit_commitment_transmission_path_id`;
ALTER TABLE `generation`.`unit_commitment` ADD CONSTRAINT `fk_generation_unit_commitment_transmission_path_id` FOREIGN KEY (`transmission_path_id`) REFERENCES `transmission`.`path` (`path_id`);

ALTER TABLE `generation`.`dispatch_schedule` DROP CONSTRAINT IF EXISTS `fk_generation_dispatch_schedule_congestion_event_id`;
ALTER TABLE `generation`.`dispatch_schedule` ADD CONSTRAINT `fk_generation_dispatch_schedule_congestion_event_id` FOREIGN KEY (`congestion_event_id`) REFERENCES `transmission`.`congestion_event` (`congestion_event_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_transmission_outage_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_transmission_outage_id` FOREIGN KEY (`transmission_outage_id`) REFERENCES `transmission`.`transmission_outage` (`transmission_outage_id`);

ALTER TABLE `generation`.`capacity_plan` DROP CONSTRAINT IF EXISTS `fk_generation_capacity_plan_transmission_planning_study_id`;
ALTER TABLE `generation`.`capacity_plan` ADD CONSTRAINT `fk_generation_capacity_plan_transmission_planning_study_id` FOREIGN KEY (`transmission_planning_study_id`) REFERENCES `transmission`.`planning_study` (`planning_study_id`);

-- ========= generation --> workforce (11) =========
ALTER TABLE `generation`.`generating_unit` DROP CONSTRAINT IF EXISTS `fk_generation_generating_unit_unit_operator_employee_id`;
ALTER TABLE `generation`.`generating_unit` ADD CONSTRAINT `fk_generation_generating_unit_unit_operator_employee_id` FOREIGN KEY (`unit_operator_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `generation`.`power_plant` DROP CONSTRAINT IF EXISTS `fk_generation_power_plant_plant_manager_employee_id`;
ALTER TABLE `generation`.`power_plant` ADD CONSTRAINT `fk_generation_power_plant_plant_manager_employee_id` FOREIGN KEY (`plant_manager_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_primary_outage_employee_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_primary_outage_employee_id` FOREIGN KEY (`primary_outage_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `generation`.`outage_event` DROP CONSTRAINT IF EXISTS `fk_generation_outage_event_responsible_crew_id`;
ALTER TABLE `generation`.`outage_event` ADD CONSTRAINT `fk_generation_outage_event_responsible_crew_id` FOREIGN KEY (`responsible_crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `generation`.`startup_event` DROP CONSTRAINT IF EXISTS `fk_generation_startup_event_employee_id`;
ALTER TABLE `generation`.`startup_event` ADD CONSTRAINT `fk_generation_startup_event_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `generation`.`ancillary_service_offer` DROP CONSTRAINT IF EXISTS `fk_generation_ancillary_service_offer_employee_id`;
ALTER TABLE `generation`.`ancillary_service_offer` ADD CONSTRAINT `fk_generation_ancillary_service_offer_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `generation`.`unit_crew_assignment` DROP CONSTRAINT IF EXISTS `fk_generation_unit_crew_assignment_assignment_id`;
ALTER TABLE `generation`.`unit_crew_assignment` ADD CONSTRAINT `fk_generation_unit_crew_assignment_assignment_id` FOREIGN KEY (`assignment_id`) REFERENCES `workforce`.`crew_assignment` (`crew_assignment_id`);

ALTER TABLE `generation`.`unit_crew_assignment` DROP CONSTRAINT IF EXISTS `fk_generation_unit_crew_assignment_crew_id`;
ALTER TABLE `generation`.`unit_crew_assignment` ADD CONSTRAINT `fk_generation_unit_crew_assignment_crew_id` FOREIGN KEY (`crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `generation`.`unit_certification_requirement` DROP CONSTRAINT IF EXISTS `fk_generation_unit_certification_requirement_certification_id`;
ALTER TABLE `generation`.`unit_certification_requirement` ADD CONSTRAINT `fk_generation_unit_certification_requirement_certification_id` FOREIGN KEY (`certification_id`) REFERENCES `workforce`.`certification` (`certification_id`);

ALTER TABLE `generation`.`plant_crew_assignment` DROP CONSTRAINT IF EXISTS `fk_generation_plant_crew_assignment_assigned_by_employee_id`;
ALTER TABLE `generation`.`plant_crew_assignment` ADD CONSTRAINT `fk_generation_plant_crew_assignment_assigned_by_employee_id` FOREIGN KEY (`assigned_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `generation`.`plant_crew_assignment` DROP CONSTRAINT IF EXISTS `fk_generation_plant_crew_assignment_crew_id`;
ALTER TABLE `generation`.`plant_crew_assignment` ADD CONSTRAINT `fk_generation_plant_crew_assignment_crew_id` FOREIGN KEY (`crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

-- ========= gis --> customer (1) =========
ALTER TABLE `gis`.`location` DROP CONSTRAINT IF EXISTS `fk_gis_location_main_address_id`;
ALTER TABLE `gis`.`location` ADD CONSTRAINT `fk_gis_location_main_address_id` FOREIGN KEY (`main_address_id`) REFERENCES `customer`.`address` (`address_id`);

-- ========= gis --> grid (1) =========
ALTER TABLE `gis`.`connectivity_node` DROP CONSTRAINT IF EXISTS `fk_gis_connectivity_node_topological_node_id`;
ALTER TABLE `gis`.`connectivity_node` ADD CONSTRAINT `fk_gis_connectivity_node_topological_node_id` FOREIGN KEY (`topological_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

-- ========= grid --> asset (11) =========
ALTER TABLE `grid`.`ems_node` DROP CONSTRAINT IF EXISTS `fk_grid_ems_node_registry_id`;
ALTER TABLE `grid`.`ems_node` ADD CONSTRAINT `fk_grid_ems_node_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `grid`.`scada_point` DROP CONSTRAINT IF EXISTS `fk_grid_scada_point_registry_id`;
ALTER TABLE `grid`.`scada_point` ADD CONSTRAINT `fk_grid_scada_point_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `grid`.`grid_scada_measurement` DROP CONSTRAINT IF EXISTS `fk_grid_grid_scada_measurement_registry_id`;
ALTER TABLE `grid`.`grid_scada_measurement` ADD CONSTRAINT `fk_grid_grid_scada_measurement_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `grid`.`grid_switching_order` DROP CONSTRAINT IF EXISTS `fk_grid_grid_switching_order_registry_id`;
ALTER TABLE `grid`.`grid_switching_order` ADD CONSTRAINT `fk_grid_grid_switching_order_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `grid`.`grid_switching_step` DROP CONSTRAINT IF EXISTS `fk_grid_grid_switching_step_registry_id`;
ALTER TABLE `grid`.`grid_switching_step` ADD CONSTRAINT `fk_grid_grid_switching_step_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `grid`.`pmu_device` DROP CONSTRAINT IF EXISTS `fk_grid_pmu_device_registry_id`;
ALTER TABLE `grid`.`pmu_device` ADD CONSTRAINT `fk_grid_pmu_device_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `grid`.`operator_log` DROP CONSTRAINT IF EXISTS `fk_grid_operator_log_registry_id`;
ALTER TABLE `grid`.`operator_log` ADD CONSTRAINT `fk_grid_operator_log_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `grid`.`ems_alarm` DROP CONSTRAINT IF EXISTS `fk_grid_ems_alarm_registry_id`;
ALTER TABLE `grid`.`ems_alarm` ADD CONSTRAINT `fk_grid_ems_alarm_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `grid`.`real_time_rating` DROP CONSTRAINT IF EXISTS `fk_grid_real_time_rating_registry_id`;
ALTER TABLE `grid`.`real_time_rating` ADD CONSTRAINT `fk_grid_real_time_rating_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `grid`.`protection_event` DROP CONSTRAINT IF EXISTS `fk_grid_protection_event_registry_id`;
ALTER TABLE `grid`.`protection_event` ADD CONSTRAINT `fk_grid_protection_event_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `grid`.`contingency_element` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_element_registry_id`;
ALTER TABLE `grid`.`contingency_element` ADD CONSTRAINT `fk_grid_contingency_element_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

-- ========= grid --> compliance (16) =========
ALTER TABLE `grid`.`control_area` DROP CONSTRAINT IF EXISTS `fk_grid_control_area_program_id`;
ALTER TABLE `grid`.`control_area` ADD CONSTRAINT `fk_grid_control_area_program_id` FOREIGN KEY (`program_id`) REFERENCES `compliance`.`program` (`program_id`);

ALTER TABLE `grid`.`scada_point` DROP CONSTRAINT IF EXISTS `fk_grid_scada_point_nerc_cip_asset_id`;
ALTER TABLE `grid`.`scada_point` ADD CONSTRAINT `fk_grid_scada_point_nerc_cip_asset_id` FOREIGN KEY (`nerc_cip_asset_id`) REFERENCES `compliance`.`nerc_cip_asset` (`nerc_cip_asset_id`);

ALTER TABLE `grid`.`contingency` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_obligation_id`;
ALTER TABLE `grid`.`contingency` ADD CONSTRAINT `fk_grid_contingency_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `grid`.`contingency_analysis_run` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_analysis_run_obligation_id`;
ALTER TABLE `grid`.`contingency_analysis_run` ADD CONSTRAINT `fk_grid_contingency_analysis_run_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `grid`.`agc_signal` DROP CONSTRAINT IF EXISTS `fk_grid_agc_signal_obligation_id`;
ALTER TABLE `grid`.`agc_signal` ADD CONSTRAINT `fk_grid_agc_signal_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `grid`.`ace_record` DROP CONSTRAINT IF EXISTS `fk_grid_ace_record_obligation_id`;
ALTER TABLE `grid`.`ace_record` ADD CONSTRAINT `fk_grid_ace_record_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `grid`.`interchange_schedule` DROP CONSTRAINT IF EXISTS `fk_grid_interchange_schedule_regulatory_filing_id`;
ALTER TABLE `grid`.`interchange_schedule` ADD CONSTRAINT `fk_grid_interchange_schedule_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `grid`.`grid_switching_order` DROP CONSTRAINT IF EXISTS `fk_grid_grid_switching_order_environmental_permit_id`;
ALTER TABLE `grid`.`grid_switching_order` ADD CONSTRAINT `fk_grid_grid_switching_order_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `compliance`.`environmental_permit` (`environmental_permit_id`);

ALTER TABLE `grid`.`frequency_event` DROP CONSTRAINT IF EXISTS `fk_grid_frequency_event_corrective_action_plan_id`;
ALTER TABLE `grid`.`frequency_event` ADD CONSTRAINT `fk_grid_frequency_event_corrective_action_plan_id` FOREIGN KEY (`corrective_action_plan_id`) REFERENCES `compliance`.`corrective_action_plan` (`corrective_action_plan_id`);

ALTER TABLE `grid`.`pmu_device` DROP CONSTRAINT IF EXISTS `fk_grid_pmu_device_nerc_cip_asset_id`;
ALTER TABLE `grid`.`pmu_device` ADD CONSTRAINT `fk_grid_pmu_device_nerc_cip_asset_id` FOREIGN KEY (`nerc_cip_asset_id`) REFERENCES `compliance`.`nerc_cip_asset` (`nerc_cip_asset_id`);

ALTER TABLE `grid`.`operator_log` DROP CONSTRAINT IF EXISTS `fk_grid_operator_log_audit_id`;
ALTER TABLE `grid`.`operator_log` ADD CONSTRAINT `fk_grid_operator_log_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `grid`.`ems_alarm` DROP CONSTRAINT IF EXISTS `fk_grid_ems_alarm_audit_finding_id`;
ALTER TABLE `grid`.`ems_alarm` ADD CONSTRAINT `fk_grid_ems_alarm_audit_finding_id` FOREIGN KEY (`audit_finding_id`) REFERENCES `compliance`.`audit_finding` (`audit_finding_id`);

ALTER TABLE `grid`.`grid_reliability_event` DROP CONSTRAINT IF EXISTS `fk_grid_grid_reliability_event_audit_id`;
ALTER TABLE `grid`.`grid_reliability_event` ADD CONSTRAINT `fk_grid_grid_reliability_event_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `grid`.`protection_event` DROP CONSTRAINT IF EXISTS `fk_grid_protection_event_audit_finding_id`;
ALTER TABLE `grid`.`protection_event` ADD CONSTRAINT `fk_grid_protection_event_audit_finding_id` FOREIGN KEY (`audit_finding_id`) REFERENCES `compliance`.`audit_finding` (`audit_finding_id`);

ALTER TABLE `grid`.`control_area_obligation` DROP CONSTRAINT IF EXISTS `fk_grid_control_area_obligation_mitigation_plan_id`;
ALTER TABLE `grid`.`control_area_obligation` ADD CONSTRAINT `fk_grid_control_area_obligation_mitigation_plan_id` FOREIGN KEY (`mitigation_plan_id`) REFERENCES `compliance`.`corrective_action_plan` (`corrective_action_plan_id`);

ALTER TABLE `grid`.`control_area_obligation` DROP CONSTRAINT IF EXISTS `fk_grid_control_area_obligation_obligation_id`;
ALTER TABLE `grid`.`control_area_obligation` ADD CONSTRAINT `fk_grid_control_area_obligation_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

-- ========= grid --> distribution (10) =========
ALTER TABLE `grid`.`grid_scada_measurement` DROP CONSTRAINT IF EXISTS `fk_grid_grid_scada_measurement_distribution_substation_id`;
ALTER TABLE `grid`.`grid_scada_measurement` ADD CONSTRAINT `fk_grid_grid_scada_measurement_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `grid`.`contingency_violation` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_violation_distribution_substation_id`;
ALTER TABLE `grid`.`contingency_violation` ADD CONSTRAINT `fk_grid_contingency_violation_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `grid`.`grid_switching_order` DROP CONSTRAINT IF EXISTS `fk_grid_grid_switching_order_affected_feeder_id`;
ALTER TABLE `grid`.`grid_switching_order` ADD CONSTRAINT `fk_grid_grid_switching_order_affected_feeder_id` FOREIGN KEY (`affected_feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `grid`.`grid_switching_order` DROP CONSTRAINT IF EXISTS `fk_grid_grid_switching_order_distribution_substation_id`;
ALTER TABLE `grid`.`grid_switching_order` ADD CONSTRAINT `fk_grid_grid_switching_order_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `grid`.`grid_switching_step` DROP CONSTRAINT IF EXISTS `fk_grid_grid_switching_step_distribution_substation_id`;
ALTER TABLE `grid`.`grid_switching_step` ADD CONSTRAINT `fk_grid_grid_switching_step_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `grid`.`voltage_control_action` DROP CONSTRAINT IF EXISTS `fk_grid_voltage_control_action_feeder_id`;
ALTER TABLE `grid`.`voltage_control_action` ADD CONSTRAINT `fk_grid_voltage_control_action_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `grid`.`pmu_device` DROP CONSTRAINT IF EXISTS `fk_grid_pmu_device_distribution_substation_id`;
ALTER TABLE `grid`.`pmu_device` ADD CONSTRAINT `fk_grid_pmu_device_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `grid`.`ems_alarm` DROP CONSTRAINT IF EXISTS `fk_grid_ems_alarm_distribution_substation_id`;
ALTER TABLE `grid`.`ems_alarm` ADD CONSTRAINT `fk_grid_ems_alarm_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `grid`.`real_time_rating` DROP CONSTRAINT IF EXISTS `fk_grid_real_time_rating_distribution_substation_id`;
ALTER TABLE `grid`.`real_time_rating` ADD CONSTRAINT `fk_grid_real_time_rating_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `grid`.`protection_event` DROP CONSTRAINT IF EXISTS `fk_grid_protection_event_distribution_substation_id`;
ALTER TABLE `grid`.`protection_event` ADD CONSTRAINT `fk_grid_protection_event_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

-- ========= grid --> finance (6) =========
ALTER TABLE `grid`.`control_area` DROP CONSTRAINT IF EXISTS `fk_grid_control_area_cost_center_id`;
ALTER TABLE `grid`.`control_area` ADD CONSTRAINT `fk_grid_control_area_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `grid`.`control_area` DROP CONSTRAINT IF EXISTS `fk_grid_control_area_profit_center_id`;
ALTER TABLE `grid`.`control_area` ADD CONSTRAINT `fk_grid_control_area_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `grid`.`contingency_analysis_run` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_analysis_run_cost_center_id`;
ALTER TABLE `grid`.`contingency_analysis_run` ADD CONSTRAINT `fk_grid_contingency_analysis_run_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `grid`.`generation_dispatch` DROP CONSTRAINT IF EXISTS `fk_grid_generation_dispatch_internal_order_id`;
ALTER TABLE `grid`.`generation_dispatch` ADD CONSTRAINT `fk_grid_generation_dispatch_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `finance`.`internal_order` (`internal_order_id`);

ALTER TABLE `grid`.`grid_switching_order` DROP CONSTRAINT IF EXISTS `fk_grid_grid_switching_order_capex_project_id`;
ALTER TABLE `grid`.`grid_switching_order` ADD CONSTRAINT `fk_grid_grid_switching_order_capex_project_id` FOREIGN KEY (`capex_project_id`) REFERENCES `finance`.`capex_project` (`capex_project_id`);

ALTER TABLE `grid`.`grid_switching_order` DROP CONSTRAINT IF EXISTS `fk_grid_grid_switching_order_internal_order_id`;
ALTER TABLE `grid`.`grid_switching_order` ADD CONSTRAINT `fk_grid_grid_switching_order_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `finance`.`internal_order` (`internal_order_id`);

-- ========= grid --> forecast (4) =========
ALTER TABLE `grid`.`ems_node` DROP CONSTRAINT IF EXISTS `fk_grid_ems_node_voltage_zone_id`;
ALTER TABLE `grid`.`ems_node` ADD CONSTRAINT `fk_grid_ems_node_voltage_zone_id` FOREIGN KEY (`voltage_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `grid`.`load_forecast` DROP CONSTRAINT IF EXISTS `fk_grid_load_forecast_forecast_model_id`;
ALTER TABLE `grid`.`load_forecast` ADD CONSTRAINT `fk_grid_load_forecast_forecast_model_id` FOREIGN KEY (`forecast_model_id`) REFERENCES `forecast`.`model` (`model_id`);

ALTER TABLE `grid`.`load_forecast` DROP CONSTRAINT IF EXISTS `fk_grid_load_forecast_forecast_run_id`;
ALTER TABLE `grid`.`load_forecast` ADD CONSTRAINT `fk_grid_load_forecast_forecast_run_id` FOREIGN KEY (`forecast_run_id`) REFERENCES `forecast`.`forecast_run` (`forecast_run_id`);

ALTER TABLE `grid`.`load_forecast` DROP CONSTRAINT IF EXISTS `fk_grid_load_forecast_forecast_zone_id`;
ALTER TABLE `grid`.`load_forecast` ADD CONSTRAINT `fk_grid_load_forecast_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

-- ========= grid --> generation (3) =========
ALTER TABLE `grid`.`agc_signal` DROP CONSTRAINT IF EXISTS `fk_grid_agc_signal_generating_unit_id`;
ALTER TABLE `grid`.`agc_signal` ADD CONSTRAINT `fk_grid_agc_signal_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `grid`.`generation_dispatch` DROP CONSTRAINT IF EXISTS `fk_grid_generation_dispatch_generating_unit_id`;
ALTER TABLE `grid`.`generation_dispatch` ADD CONSTRAINT `fk_grid_generation_dispatch_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `grid`.`dispatch_instruction` DROP CONSTRAINT IF EXISTS `fk_grid_dispatch_instruction_generating_unit_id`;
ALTER TABLE `grid`.`dispatch_instruction` ADD CONSTRAINT `fk_grid_dispatch_instruction_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

-- ========= grid --> gis (6) =========
ALTER TABLE `grid`.`control_area` DROP CONSTRAINT IF EXISTS `fk_grid_control_area_gis_location_id`;
ALTER TABLE `grid`.`control_area` ADD CONSTRAINT `fk_grid_control_area_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `grid`.`ems_node` DROP CONSTRAINT IF EXISTS `fk_grid_ems_node_gis_location_id`;
ALTER TABLE `grid`.`ems_node` ADD CONSTRAINT `fk_grid_ems_node_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `grid`.`scada_point` DROP CONSTRAINT IF EXISTS `fk_grid_scada_point_gis_location_id`;
ALTER TABLE `grid`.`scada_point` ADD CONSTRAINT `fk_grid_scada_point_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `grid`.`pmu_measurement` DROP CONSTRAINT IF EXISTS `fk_grid_pmu_measurement_gis_location_id`;
ALTER TABLE `grid`.`pmu_measurement` ADD CONSTRAINT `fk_grid_pmu_measurement_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `grid`.`pmu_device` DROP CONSTRAINT IF EXISTS `fk_grid_pmu_device_gis_location_id`;
ALTER TABLE `grid`.`pmu_device` ADD CONSTRAINT `fk_grid_pmu_device_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `grid`.`control_center` DROP CONSTRAINT IF EXISTS `fk_grid_control_center_gis_location_id`;
ALTER TABLE `grid`.`control_center` ADD CONSTRAINT `fk_grid_control_center_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

-- ========= grid --> outage (6) =========
ALTER TABLE `grid`.`frequency_event` DROP CONSTRAINT IF EXISTS `fk_grid_frequency_event_event_id`;
ALTER TABLE `grid`.`frequency_event` ADD CONSTRAINT `fk_grid_frequency_event_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `grid`.`pmu_measurement` DROP CONSTRAINT IF EXISTS `fk_grid_pmu_measurement_wams_event_id`;
ALTER TABLE `grid`.`pmu_measurement` ADD CONSTRAINT `fk_grid_pmu_measurement_wams_event_id` FOREIGN KEY (`wams_event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `grid`.`operator_log` DROP CONSTRAINT IF EXISTS `fk_grid_operator_log_event_id`;
ALTER TABLE `grid`.`operator_log` ADD CONSTRAINT `fk_grid_operator_log_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `grid`.`ems_alarm` DROP CONSTRAINT IF EXISTS `fk_grid_ems_alarm_event_id`;
ALTER TABLE `grid`.`ems_alarm` ADD CONSTRAINT `fk_grid_ems_alarm_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `grid`.`grid_reliability_event` DROP CONSTRAINT IF EXISTS `fk_grid_grid_reliability_event_event_id`;
ALTER TABLE `grid`.`grid_reliability_event` ADD CONSTRAINT `fk_grid_grid_reliability_event_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `grid`.`protection_event` DROP CONSTRAINT IF EXISTS `fk_grid_protection_event_event_id`;
ALTER TABLE `grid`.`protection_event` ADD CONSTRAINT `fk_grid_protection_event_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

-- ========= grid --> supply (9) =========
ALTER TABLE `grid`.`contingency_analysis_run` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_analysis_run_emergency_stock_event_id`;
ALTER TABLE `grid`.`contingency_analysis_run` ADD CONSTRAINT `fk_grid_contingency_analysis_run_emergency_stock_event_id` FOREIGN KEY (`emergency_stock_event_id`) REFERENCES `supply`.`emergency_stock_event` (`emergency_stock_event_id`);

ALTER TABLE `grid`.`contingency_violation` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_violation_emergency_stock_event_id`;
ALTER TABLE `grid`.`contingency_violation` ADD CONSTRAINT `fk_grid_contingency_violation_emergency_stock_event_id` FOREIGN KEY (`emergency_stock_event_id`) REFERENCES `supply`.`emergency_stock_event` (`emergency_stock_event_id`);

ALTER TABLE `grid`.`generation_dispatch` DROP CONSTRAINT IF EXISTS `fk_grid_generation_dispatch_fuel_supply_contract_id`;
ALTER TABLE `grid`.`generation_dispatch` ADD CONSTRAINT `fk_grid_generation_dispatch_fuel_supply_contract_id` FOREIGN KEY (`fuel_supply_contract_id`) REFERENCES `supply`.`fuel_supply_contract` (`fuel_supply_contract_id`);

ALTER TABLE `grid`.`grid_switching_order` DROP CONSTRAINT IF EXISTS `fk_grid_grid_switching_order_staging_warehouse_id`;
ALTER TABLE `grid`.`grid_switching_order` ADD CONSTRAINT `fk_grid_grid_switching_order_staging_warehouse_id` FOREIGN KEY (`staging_warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `grid`.`grid_switching_step` DROP CONSTRAINT IF EXISTS `fk_grid_grid_switching_step_spare_parts_catalog_id`;
ALTER TABLE `grid`.`grid_switching_step` ADD CONSTRAINT `fk_grid_grid_switching_step_spare_parts_catalog_id` FOREIGN KEY (`spare_parts_catalog_id`) REFERENCES `supply`.`spare_parts_catalog` (`spare_parts_catalog_id`);

ALTER TABLE `grid`.`frequency_event` DROP CONSTRAINT IF EXISTS `fk_grid_frequency_event_emergency_stock_event_id`;
ALTER TABLE `grid`.`frequency_event` ADD CONSTRAINT `fk_grid_frequency_event_emergency_stock_event_id` FOREIGN KEY (`emergency_stock_event_id`) REFERENCES `supply`.`emergency_stock_event` (`emergency_stock_event_id`);

ALTER TABLE `grid`.`ems_alarm` DROP CONSTRAINT IF EXISTS `fk_grid_ems_alarm_emergency_stock_event_id`;
ALTER TABLE `grid`.`ems_alarm` ADD CONSTRAINT `fk_grid_ems_alarm_emergency_stock_event_id` FOREIGN KEY (`emergency_stock_event_id`) REFERENCES `supply`.`emergency_stock_event` (`emergency_stock_event_id`);

ALTER TABLE `grid`.`grid_reliability_event` DROP CONSTRAINT IF EXISTS `fk_grid_grid_reliability_event_emergency_stock_event_id`;
ALTER TABLE `grid`.`grid_reliability_event` ADD CONSTRAINT `fk_grid_grid_reliability_event_emergency_stock_event_id` FOREIGN KEY (`emergency_stock_event_id`) REFERENCES `supply`.`emergency_stock_event` (`emergency_stock_event_id`);

ALTER TABLE `grid`.`protection_event` DROP CONSTRAINT IF EXISTS `fk_grid_protection_event_emergency_stock_event_id`;
ALTER TABLE `grid`.`protection_event` ADD CONSTRAINT `fk_grid_protection_event_emergency_stock_event_id` FOREIGN KEY (`emergency_stock_event_id`) REFERENCES `supply`.`emergency_stock_event` (`emergency_stock_event_id`);

-- ========= grid --> trading (8) =========
ALTER TABLE `grid`.`grid_scada_measurement` DROP CONSTRAINT IF EXISTS `fk_grid_grid_scada_measurement_lmp_price_id`;
ALTER TABLE `grid`.`grid_scada_measurement` ADD CONSTRAINT `fk_grid_grid_scada_measurement_lmp_price_id` FOREIGN KEY (`lmp_price_id`) REFERENCES `trading`.`lmp_price` (`lmp_price_id`);

ALTER TABLE `grid`.`agc_signal` DROP CONSTRAINT IF EXISTS `fk_grid_agc_signal_trade_id`;
ALTER TABLE `grid`.`agc_signal` ADD CONSTRAINT `fk_grid_agc_signal_trade_id` FOREIGN KEY (`trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `grid`.`interchange_schedule` DROP CONSTRAINT IF EXISTS `fk_grid_interchange_schedule_counterparty_id`;
ALTER TABLE `grid`.`interchange_schedule` ADD CONSTRAINT `fk_grid_interchange_schedule_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `grid`.`interchange_schedule` DROP CONSTRAINT IF EXISTS `fk_grid_interchange_schedule_energy_schedule_id`;
ALTER TABLE `grid`.`interchange_schedule` ADD CONSTRAINT `fk_grid_interchange_schedule_energy_schedule_id` FOREIGN KEY (`energy_schedule_id`) REFERENCES `trading`.`energy_schedule` (`energy_schedule_id`);

ALTER TABLE `grid`.`interchange_schedule` DROP CONSTRAINT IF EXISTS `fk_grid_interchange_schedule_trade_id`;
ALTER TABLE `grid`.`interchange_schedule` ADD CONSTRAINT `fk_grid_interchange_schedule_trade_id` FOREIGN KEY (`trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `grid`.`generation_dispatch` DROP CONSTRAINT IF EXISTS `fk_grid_generation_dispatch_ppa_id`;
ALTER TABLE `grid`.`generation_dispatch` ADD CONSTRAINT `fk_grid_generation_dispatch_ppa_id` FOREIGN KEY (`ppa_id`) REFERENCES `trading`.`ppa` (`ppa_id`);

ALTER TABLE `grid`.`generation_dispatch` DROP CONSTRAINT IF EXISTS `fk_grid_generation_dispatch_trade_id`;
ALTER TABLE `grid`.`generation_dispatch` ADD CONSTRAINT `fk_grid_generation_dispatch_trade_id` FOREIGN KEY (`trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `grid`.`dispatch_instruction` DROP CONSTRAINT IF EXISTS `fk_grid_dispatch_instruction_market_participant_id`;
ALTER TABLE `grid`.`dispatch_instruction` ADD CONSTRAINT `fk_grid_dispatch_instruction_market_participant_id` FOREIGN KEY (`market_participant_id`) REFERENCES `trading`.`market_participant` (`market_participant_id`);

-- ========= grid --> transmission (4) =========
ALTER TABLE `grid`.`interchange_schedule` DROP CONSTRAINT IF EXISTS `fk_grid_interchange_schedule_transmission_path_id`;
ALTER TABLE `grid`.`interchange_schedule` ADD CONSTRAINT `fk_grid_interchange_schedule_transmission_path_id` FOREIGN KEY (`transmission_path_id`) REFERENCES `transmission`.`path` (`path_id`);

ALTER TABLE `grid`.`protection_event` DROP CONSTRAINT IF EXISTS `fk_grid_protection_event_protection_device_id`;
ALTER TABLE `grid`.`protection_event` ADD CONSTRAINT `fk_grid_protection_event_protection_device_id` FOREIGN KEY (`protection_device_id`) REFERENCES `transmission`.`protection_device` (`protection_device_id`);

ALTER TABLE `grid`.`contingency_monitored_element` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_monitored_element_transmission_line_id`;
ALTER TABLE `grid`.`contingency_monitored_element` ADD CONSTRAINT `fk_grid_contingency_monitored_element_transmission_line_id` FOREIGN KEY (`transmission_line_id`) REFERENCES `transmission`.`line` (`line_id`);

ALTER TABLE `grid`.`dispatch_instruction` DROP CONSTRAINT IF EXISTS `fk_grid_dispatch_instruction_transmission_path_id`;
ALTER TABLE `grid`.`dispatch_instruction` ADD CONSTRAINT `fk_grid_dispatch_instruction_transmission_path_id` FOREIGN KEY (`transmission_path_id`) REFERENCES `transmission`.`path` (`path_id`);

-- ========= grid --> workforce (23) =========
ALTER TABLE `grid`.`control_area` DROP CONSTRAINT IF EXISTS `fk_grid_control_area_contact_employee_id`;
ALTER TABLE `grid`.`control_area` ADD CONSTRAINT `fk_grid_control_area_contact_employee_id` FOREIGN KEY (`contact_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `grid`.`contingency` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_created_by_employee_id`;
ALTER TABLE `grid`.`contingency` ADD CONSTRAINT `fk_grid_contingency_created_by_employee_id` FOREIGN KEY (`created_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `grid`.`contingency_analysis_run` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_analysis_run_employee_id`;
ALTER TABLE `grid`.`contingency_analysis_run` ADD CONSTRAINT `fk_grid_contingency_analysis_run_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `grid`.`contingency_violation` DROP CONSTRAINT IF EXISTS `fk_grid_contingency_violation_employee_id`;
ALTER TABLE `grid`.`contingency_violation` ADD CONSTRAINT `fk_grid_contingency_violation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `grid`.`interchange_schedule` DROP CONSTRAINT IF EXISTS `fk_grid_interchange_schedule_approved_by_employee_id`;
ALTER TABLE `grid`.`interchange_schedule` ADD CONSTRAINT `fk_grid_interchange_schedule_approved_by_employee_id` FOREIGN KEY (`approved_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `grid`.`generation_dispatch` DROP CONSTRAINT IF EXISTS `fk_grid_generation_dispatch_employee_id`;
ALTER TABLE `grid`.`generation_dispatch` ADD CONSTRAINT `fk_grid_generation_dispatch_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `grid`.`grid_switching_order` DROP CONSTRAINT IF EXISTS `fk_grid_grid_switching_order_executing_crew_id`;
ALTER TABLE `grid`.`grid_switching_order` ADD CONSTRAINT `fk_grid_grid_switching_order_executing_crew_id` FOREIGN KEY (`executing_crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `grid`.`grid_switching_order` DROP CONSTRAINT IF EXISTS `fk_grid_grid_switching_order_primary_grid_employee_id`;
ALTER TABLE `grid`.`grid_switching_order` ADD CONSTRAINT `fk_grid_grid_switching_order_primary_grid_employee_id` FOREIGN KEY (`primary_grid_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `grid`.`grid_switching_order` DROP CONSTRAINT IF EXISTS `fk_grid_grid_switching_order_safety_incident_id`;
ALTER TABLE `grid`.`grid_switching_order` ADD CONSTRAINT `fk_grid_grid_switching_order_safety_incident_id` FOREIGN KEY (`safety_incident_id`) REFERENCES `workforce`.`safety_incident` (`safety_incident_id`);

ALTER TABLE `grid`.`grid_switching_step` DROP CONSTRAINT IF EXISTS `fk_grid_grid_switching_step_primary_grid_employee_id`;
ALTER TABLE `grid`.`grid_switching_step` ADD CONSTRAINT `fk_grid_grid_switching_step_primary_grid_employee_id` FOREIGN KEY (`primary_grid_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `grid`.`voltage_control_action` DROP CONSTRAINT IF EXISTS `fk_grid_voltage_control_action_employee_id`;
ALTER TABLE `grid`.`voltage_control_action` ADD CONSTRAINT `fk_grid_voltage_control_action_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `grid`.`operator_log` DROP CONSTRAINT IF EXISTS `fk_grid_operator_log_employee_id`;
ALTER TABLE `grid`.`operator_log` ADD CONSTRAINT `fk_grid_operator_log_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `grid`.`operator_log` DROP CONSTRAINT IF EXISTS `fk_grid_operator_log_shift_assignment_id`;
ALTER TABLE `grid`.`operator_log` ADD CONSTRAINT `fk_grid_operator_log_shift_assignment_id` FOREIGN KEY (`shift_assignment_id`) REFERENCES `workforce`.`shift_assignment` (`shift_assignment_id`);

ALTER TABLE `grid`.`ems_alarm` DROP CONSTRAINT IF EXISTS `fk_grid_ems_alarm_employee_id`;
ALTER TABLE `grid`.`ems_alarm` ADD CONSTRAINT `fk_grid_ems_alarm_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `grid`.`grid_reliability_event` DROP CONSTRAINT IF EXISTS `fk_grid_grid_reliability_event_operator_employee_id`;
ALTER TABLE `grid`.`grid_reliability_event` ADD CONSTRAINT `fk_grid_grid_reliability_event_operator_employee_id` FOREIGN KEY (`operator_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `grid`.`grid_reliability_event` DROP CONSTRAINT IF EXISTS `fk_grid_grid_reliability_event_safety_incident_id`;
ALTER TABLE `grid`.`grid_reliability_event` ADD CONSTRAINT `fk_grid_grid_reliability_event_safety_incident_id` FOREIGN KEY (`safety_incident_id`) REFERENCES `workforce`.`safety_incident` (`safety_incident_id`);

ALTER TABLE `grid`.`real_time_rating` DROP CONSTRAINT IF EXISTS `fk_grid_real_time_rating_employee_id`;
ALTER TABLE `grid`.`real_time_rating` ADD CONSTRAINT `fk_grid_real_time_rating_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `grid`.`topology_snapshot` DROP CONSTRAINT IF EXISTS `fk_grid_topology_snapshot_employee_id`;
ALTER TABLE `grid`.`topology_snapshot` ADD CONSTRAINT `fk_grid_topology_snapshot_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `grid`.`protection_event` DROP CONSTRAINT IF EXISTS `fk_grid_protection_event_employee_id`;
ALTER TABLE `grid`.`protection_event` ADD CONSTRAINT `fk_grid_protection_event_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `grid`.`protection_event` DROP CONSTRAINT IF EXISTS `fk_grid_protection_event_safety_incident_id`;
ALTER TABLE `grid`.`protection_event` ADD CONSTRAINT `fk_grid_protection_event_safety_incident_id` FOREIGN KEY (`safety_incident_id`) REFERENCES `workforce`.`safety_incident` (`safety_incident_id`);

ALTER TABLE `grid`.`dispatch_instruction` DROP CONSTRAINT IF EXISTS `fk_grid_dispatch_instruction_approved_by_user_employee_id`;
ALTER TABLE `grid`.`dispatch_instruction` ADD CONSTRAINT `fk_grid_dispatch_instruction_approved_by_user_employee_id` FOREIGN KEY (`approved_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `grid`.`dispatch_instruction` DROP CONSTRAINT IF EXISTS `fk_grid_dispatch_instruction_employee_id`;
ALTER TABLE `grid`.`dispatch_instruction` ADD CONSTRAINT `fk_grid_dispatch_instruction_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `grid`.`dispatch_instruction` DROP CONSTRAINT IF EXISTS `fk_grid_dispatch_instruction_last_modified_by_user_employee_id`;
ALTER TABLE `grid`.`dispatch_instruction` ADD CONSTRAINT `fk_grid_dispatch_instruction_last_modified_by_user_employee_id` FOREIGN KEY (`last_modified_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

-- ========= interconnection --> asset (3) =========
ALTER TABLE `interconnection`.`network_upgrade` DROP CONSTRAINT IF EXISTS `fk_interconnection_network_upgrade_capital_project_id`;
ALTER TABLE `interconnection`.`network_upgrade` ADD CONSTRAINT `fk_interconnection_network_upgrade_capital_project_id` FOREIGN KEY (`capital_project_id`) REFERENCES `asset`.`capital_project` (`capital_project_id`);

ALTER TABLE `interconnection`.`network_upgrade` DROP CONSTRAINT IF EXISTS `fk_interconnection_network_upgrade_registry_id`;
ALTER TABLE `interconnection`.`network_upgrade` ADD CONSTRAINT `fk_interconnection_network_upgrade_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `interconnection`.`network_upgrade` DROP CONSTRAINT IF EXISTS `fk_interconnection_network_upgrade_work_order_id`;
ALTER TABLE `interconnection`.`network_upgrade` ADD CONSTRAINT `fk_interconnection_network_upgrade_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

-- ========= interconnection --> billing (4) =========
ALTER TABLE `interconnection`.`application` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_billing_service_agreement_id`;
ALTER TABLE `interconnection`.`application` ADD CONSTRAINT `fk_interconnection_application_billing_service_agreement_id` FOREIGN KEY (`billing_service_agreement_id`) REFERENCES `billing`.`billing_service_agreement` (`billing_service_agreement_id`);

ALTER TABLE `interconnection`.`application` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_rate_schedule_id`;
ALTER TABLE `interconnection`.`application` ADD CONSTRAINT `fk_interconnection_application_rate_schedule_id` FOREIGN KEY (`rate_schedule_id`) REFERENCES `billing`.`rate_schedule` (`rate_schedule_id`);

ALTER TABLE `interconnection`.`cost_responsibility` DROP CONSTRAINT IF EXISTS `fk_interconnection_cost_responsibility_payment_id`;
ALTER TABLE `interconnection`.`cost_responsibility` ADD CONSTRAINT `fk_interconnection_cost_responsibility_payment_id` FOREIGN KEY (`payment_id`) REFERENCES `billing`.`payment` (`payment_id`);

ALTER TABLE `interconnection`.`fee` DROP CONSTRAINT IF EXISTS `fk_interconnection_fee_invoice_id`;
ALTER TABLE `interconnection`.`fee` ADD CONSTRAINT `fk_interconnection_fee_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

-- ========= interconnection --> compliance (9) =========
ALTER TABLE `interconnection`.`application` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_compliance_environmental_permit_id`;
ALTER TABLE `interconnection`.`application` ADD CONSTRAINT `fk_interconnection_application_compliance_environmental_permit_id` FOREIGN KEY (`compliance_environmental_permit_id`) REFERENCES `compliance`.`environmental_permit` (`environmental_permit_id`);

ALTER TABLE `interconnection`.`application` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_obligation_id`;
ALTER TABLE `interconnection`.`application` ADD CONSTRAINT `fk_interconnection_application_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `interconnection`.`der_system` DROP CONSTRAINT IF EXISTS `fk_interconnection_der_system_nerc_cip_asset_id`;
ALTER TABLE `interconnection`.`der_system` ADD CONSTRAINT `fk_interconnection_der_system_nerc_cip_asset_id` FOREIGN KEY (`nerc_cip_asset_id`) REFERENCES `compliance`.`nerc_cip_asset` (`nerc_cip_asset_id`);

ALTER TABLE `interconnection`.`technical_review` DROP CONSTRAINT IF EXISTS `fk_interconnection_technical_review_obligation_id`;
ALTER TABLE `interconnection`.`technical_review` ADD CONSTRAINT `fk_interconnection_technical_review_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `interconnection`.`interconnection_agreement` DROP CONSTRAINT IF EXISTS `fk_interconnection_interconnection_agreement_obligation_id`;
ALTER TABLE `interconnection`.`interconnection_agreement` ADD CONSTRAINT `fk_interconnection_interconnection_agreement_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `interconnection`.`nem_agreement` DROP CONSTRAINT IF EXISTS `fk_interconnection_nem_agreement_obligation_id`;
ALTER TABLE `interconnection`.`nem_agreement` ADD CONSTRAINT `fk_interconnection_nem_agreement_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `interconnection`.`inspection_milestone` DROP CONSTRAINT IF EXISTS `fk_interconnection_inspection_milestone_audit_finding_id`;
ALTER TABLE `interconnection`.`inspection_milestone` ADD CONSTRAINT `fk_interconnection_inspection_milestone_audit_finding_id` FOREIGN KEY (`audit_finding_id`) REFERENCES `compliance`.`audit_finding` (`audit_finding_id`);

ALTER TABLE `interconnection`.`sgip_enrollment` DROP CONSTRAINT IF EXISTS `fk_interconnection_sgip_enrollment_regulatory_filing_id`;
ALTER TABLE `interconnection`.`sgip_enrollment` ADD CONSTRAINT `fk_interconnection_sgip_enrollment_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `interconnection`.`application_document` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_document_evidence_record_id`;
ALTER TABLE `interconnection`.`application_document` ADD CONSTRAINT `fk_interconnection_application_document_evidence_record_id` FOREIGN KEY (`evidence_record_id`) REFERENCES `compliance`.`evidence_record` (`evidence_record_id`);

-- ========= interconnection --> customer (10) =========
ALTER TABLE `interconnection`.`application` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_profile_id`;
ALTER TABLE `interconnection`.`application` ADD CONSTRAINT `fk_interconnection_application_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `customer`.`profile` (`profile_id`);

ALTER TABLE `interconnection`.`application` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_service_address_id`;
ALTER TABLE `interconnection`.`application` ADD CONSTRAINT `fk_interconnection_application_service_address_id` FOREIGN KEY (`service_address_id`) REFERENCES `customer`.`address` (`address_id`);

ALTER TABLE `interconnection`.`interconnection_agreement` DROP CONSTRAINT IF EXISTS `fk_interconnection_interconnection_agreement_premise_id`;
ALTER TABLE `interconnection`.`interconnection_agreement` ADD CONSTRAINT `fk_interconnection_interconnection_agreement_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `interconnection`.`interconnection_agreement` DROP CONSTRAINT IF EXISTS `fk_interconnection_interconnection_agreement_profile_id`;
ALTER TABLE `interconnection`.`interconnection_agreement` ADD CONSTRAINT `fk_interconnection_interconnection_agreement_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `customer`.`profile` (`profile_id`);

ALTER TABLE `interconnection`.`nem_agreement` DROP CONSTRAINT IF EXISTS `fk_interconnection_nem_agreement_account_id`;
ALTER TABLE `interconnection`.`nem_agreement` ADD CONSTRAINT `fk_interconnection_nem_agreement_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `interconnection`.`nem_agreement` DROP CONSTRAINT IF EXISTS `fk_interconnection_nem_agreement_customer_service_agreement_id`;
ALTER TABLE `interconnection`.`nem_agreement` ADD CONSTRAINT `fk_interconnection_nem_agreement_customer_service_agreement_id` FOREIGN KEY (`customer_service_agreement_id`) REFERENCES `customer`.`customer_service_agreement` (`customer_service_agreement_id`);

ALTER TABLE `interconnection`.`nem_agreement` DROP CONSTRAINT IF EXISTS `fk_interconnection_nem_agreement_profile_id`;
ALTER TABLE `interconnection`.`nem_agreement` ADD CONSTRAINT `fk_interconnection_nem_agreement_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `customer`.`profile` (`profile_id`);

ALTER TABLE `interconnection`.`inspection_milestone` DROP CONSTRAINT IF EXISTS `fk_interconnection_inspection_milestone_premise_id`;
ALTER TABLE `interconnection`.`inspection_milestone` ADD CONSTRAINT `fk_interconnection_inspection_milestone_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `interconnection`.`sgip_enrollment` DROP CONSTRAINT IF EXISTS `fk_interconnection_sgip_enrollment_customer_service_agreement_id`;
ALTER TABLE `interconnection`.`sgip_enrollment` ADD CONSTRAINT `fk_interconnection_sgip_enrollment_customer_service_agreement_id` FOREIGN KEY (`customer_service_agreement_id`) REFERENCES `customer`.`customer_service_agreement` (`customer_service_agreement_id`);

ALTER TABLE `interconnection`.`sgip_enrollment` DROP CONSTRAINT IF EXISTS `fk_interconnection_sgip_enrollment_profile_id`;
ALTER TABLE `interconnection`.`sgip_enrollment` ADD CONSTRAINT `fk_interconnection_sgip_enrollment_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `customer`.`profile` (`profile_id`);

-- ========= interconnection --> distribution (10) =========
ALTER TABLE `interconnection`.`application` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_distribution_substation_id`;
ALTER TABLE `interconnection`.`application` ADD CONSTRAINT `fk_interconnection_application_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `interconnection`.`poi_specification` DROP CONSTRAINT IF EXISTS `fk_interconnection_poi_specification_feeder_id`;
ALTER TABLE `interconnection`.`poi_specification` ADD CONSTRAINT `fk_interconnection_poi_specification_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `interconnection`.`poi_specification` DROP CONSTRAINT IF EXISTS `fk_interconnection_poi_specification_transformer_id`;
ALTER TABLE `interconnection`.`poi_specification` ADD CONSTRAINT `fk_interconnection_poi_specification_transformer_id` FOREIGN KEY (`transformer_id`) REFERENCES `distribution`.`transformer` (`transformer_id`);

ALTER TABLE `interconnection`.`technical_review` DROP CONSTRAINT IF EXISTS `fk_interconnection_technical_review_distribution_substation_id`;
ALTER TABLE `interconnection`.`technical_review` ADD CONSTRAINT `fk_interconnection_technical_review_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `interconnection`.`technical_review` DROP CONSTRAINT IF EXISTS `fk_interconnection_technical_review_feeder_id`;
ALTER TABLE `interconnection`.`technical_review` ADD CONSTRAINT `fk_interconnection_technical_review_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `interconnection`.`network_upgrade` DROP CONSTRAINT IF EXISTS `fk_interconnection_network_upgrade_feeder_id`;
ALTER TABLE `interconnection`.`network_upgrade` ADD CONSTRAINT `fk_interconnection_network_upgrade_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `interconnection`.`network_upgrade` DROP CONSTRAINT IF EXISTS `fk_interconnection_network_upgrade_network_segment_id`;
ALTER TABLE `interconnection`.`network_upgrade` ADD CONSTRAINT `fk_interconnection_network_upgrade_network_segment_id` FOREIGN KEY (`network_segment_id`) REFERENCES `distribution`.`network_segment` (`network_segment_id`);

ALTER TABLE `interconnection`.`hosting_capacity` DROP CONSTRAINT IF EXISTS `fk_interconnection_hosting_capacity_distribution_substation_id`;
ALTER TABLE `interconnection`.`hosting_capacity` ADD CONSTRAINT `fk_interconnection_hosting_capacity_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `interconnection`.`cluster_study_group` DROP CONSTRAINT IF EXISTS `fk_interconnection_cluster_study_group_distribution_substation_id`;
ALTER TABLE `interconnection`.`cluster_study_group` ADD CONSTRAINT `fk_interconnection_cluster_study_group_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `interconnection`.`cluster_study_group` DROP CONSTRAINT IF EXISTS `fk_interconnection_cluster_study_group_feeder_id`;
ALTER TABLE `interconnection`.`cluster_study_group` ADD CONSTRAINT `fk_interconnection_cluster_study_group_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

-- ========= interconnection --> finance (8) =========
ALTER TABLE `interconnection`.`application` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_cost_center_id`;
ALTER TABLE `interconnection`.`application` ADD CONSTRAINT `fk_interconnection_application_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `interconnection`.`application` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_profit_center_id`;
ALTER TABLE `interconnection`.`application` ADD CONSTRAINT `fk_interconnection_application_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `interconnection`.`impact_study` DROP CONSTRAINT IF EXISTS `fk_interconnection_impact_study_cost_center_id`;
ALTER TABLE `interconnection`.`impact_study` ADD CONSTRAINT `fk_interconnection_impact_study_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `interconnection`.`network_upgrade` DROP CONSTRAINT IF EXISTS `fk_interconnection_network_upgrade_cost_center_id`;
ALTER TABLE `interconnection`.`network_upgrade` ADD CONSTRAINT `fk_interconnection_network_upgrade_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `interconnection`.`sgip_enrollment` DROP CONSTRAINT IF EXISTS `fk_interconnection_sgip_enrollment_gl_account_id`;
ALTER TABLE `interconnection`.`sgip_enrollment` ADD CONSTRAINT `fk_interconnection_sgip_enrollment_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `interconnection`.`cost_responsibility` DROP CONSTRAINT IF EXISTS `fk_interconnection_cost_responsibility_ap_invoice_id`;
ALTER TABLE `interconnection`.`cost_responsibility` ADD CONSTRAINT `fk_interconnection_cost_responsibility_ap_invoice_id` FOREIGN KEY (`ap_invoice_id`) REFERENCES `finance`.`ap_invoice` (`ap_invoice_id`);

ALTER TABLE `interconnection`.`fee` DROP CONSTRAINT IF EXISTS `fk_interconnection_fee_gl_account_id`;
ALTER TABLE `interconnection`.`fee` ADD CONSTRAINT `fk_interconnection_fee_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `interconnection`.`fee` DROP CONSTRAINT IF EXISTS `fk_interconnection_fee_receivable_id`;
ALTER TABLE `interconnection`.`fee` ADD CONSTRAINT `fk_interconnection_fee_receivable_id` FOREIGN KEY (`receivable_id`) REFERENCES `finance`.`receivable` (`receivable_id`);

-- ========= interconnection --> forecast (10) =========
ALTER TABLE `interconnection`.`application` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_forecast_zone_id`;
ALTER TABLE `interconnection`.`application` ADD CONSTRAINT `fk_interconnection_application_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `interconnection`.`der_system` DROP CONSTRAINT IF EXISTS `fk_interconnection_der_system_forecast_zone_id`;
ALTER TABLE `interconnection`.`der_system` ADD CONSTRAINT `fk_interconnection_der_system_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `interconnection`.`poi_specification` DROP CONSTRAINT IF EXISTS `fk_interconnection_poi_specification_forecast_zone_id`;
ALTER TABLE `interconnection`.`poi_specification` ADD CONSTRAINT `fk_interconnection_poi_specification_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `interconnection`.`technical_review` DROP CONSTRAINT IF EXISTS `fk_interconnection_technical_review_load_id`;
ALTER TABLE `interconnection`.`technical_review` ADD CONSTRAINT `fk_interconnection_technical_review_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `interconnection`.`impact_study` DROP CONSTRAINT IF EXISTS `fk_interconnection_impact_study_irp_scenario_id`;
ALTER TABLE `interconnection`.`impact_study` ADD CONSTRAINT `fk_interconnection_impact_study_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

ALTER TABLE `interconnection`.`impact_study` DROP CONSTRAINT IF EXISTS `fk_interconnection_impact_study_load_id`;
ALTER TABLE `interconnection`.`impact_study` ADD CONSTRAINT `fk_interconnection_impact_study_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `interconnection`.`network_upgrade` DROP CONSTRAINT IF EXISTS `fk_interconnection_network_upgrade_capacity_requirement_id`;
ALTER TABLE `interconnection`.`network_upgrade` ADD CONSTRAINT `fk_interconnection_network_upgrade_capacity_requirement_id` FOREIGN KEY (`capacity_requirement_id`) REFERENCES `forecast`.`capacity_requirement` (`capacity_requirement_id`);

ALTER TABLE `interconnection`.`hosting_capacity` DROP CONSTRAINT IF EXISTS `fk_interconnection_hosting_capacity_forecast_zone_id`;
ALTER TABLE `interconnection`.`hosting_capacity` ADD CONSTRAINT `fk_interconnection_hosting_capacity_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `interconnection`.`hosting_capacity` DROP CONSTRAINT IF EXISTS `fk_interconnection_hosting_capacity_load_id`;
ALTER TABLE `interconnection`.`hosting_capacity` ADD CONSTRAINT `fk_interconnection_hosting_capacity_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `interconnection`.`cluster_study_group` DROP CONSTRAINT IF EXISTS `fk_interconnection_cluster_study_group_irp_scenario_id`;
ALTER TABLE `interconnection`.`cluster_study_group` ADD CONSTRAINT `fk_interconnection_cluster_study_group_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

-- ========= interconnection --> gis (3) =========
ALTER TABLE `interconnection`.`der_system` DROP CONSTRAINT IF EXISTS `fk_interconnection_der_system_gis_location_id`;
ALTER TABLE `interconnection`.`der_system` ADD CONSTRAINT `fk_interconnection_der_system_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `interconnection`.`poi_specification` DROP CONSTRAINT IF EXISTS `fk_interconnection_poi_specification_gis_location_id`;
ALTER TABLE `interconnection`.`poi_specification` ADD CONSTRAINT `fk_interconnection_poi_specification_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `interconnection`.`inspection_milestone` DROP CONSTRAINT IF EXISTS `fk_interconnection_inspection_milestone_gis_location_id`;
ALTER TABLE `interconnection`.`inspection_milestone` ADD CONSTRAINT `fk_interconnection_inspection_milestone_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

-- ========= interconnection --> grid (8) =========
ALTER TABLE `interconnection`.`application` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_control_area_id`;
ALTER TABLE `interconnection`.`application` ADD CONSTRAINT `fk_interconnection_application_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `interconnection`.`der_system` DROP CONSTRAINT IF EXISTS `fk_interconnection_der_system_control_area_id`;
ALTER TABLE `interconnection`.`der_system` ADD CONSTRAINT `fk_interconnection_der_system_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `interconnection`.`poi_specification` DROP CONSTRAINT IF EXISTS `fk_interconnection_poi_specification_ems_node_id`;
ALTER TABLE `interconnection`.`poi_specification` ADD CONSTRAINT `fk_interconnection_poi_specification_ems_node_id` FOREIGN KEY (`ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `interconnection`.`technical_review` DROP CONSTRAINT IF EXISTS `fk_interconnection_technical_review_control_area_id`;
ALTER TABLE `interconnection`.`technical_review` ADD CONSTRAINT `fk_interconnection_technical_review_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `interconnection`.`impact_study` DROP CONSTRAINT IF EXISTS `fk_interconnection_impact_study_contingency_id`;
ALTER TABLE `interconnection`.`impact_study` ADD CONSTRAINT `fk_interconnection_impact_study_contingency_id` FOREIGN KEY (`contingency_id`) REFERENCES `grid`.`contingency` (`contingency_id`);

ALTER TABLE `interconnection`.`network_upgrade` DROP CONSTRAINT IF EXISTS `fk_interconnection_network_upgrade_contingency_id`;
ALTER TABLE `interconnection`.`network_upgrade` ADD CONSTRAINT `fk_interconnection_network_upgrade_contingency_id` FOREIGN KEY (`contingency_id`) REFERENCES `grid`.`contingency` (`contingency_id`);

ALTER TABLE `interconnection`.`hosting_capacity` DROP CONSTRAINT IF EXISTS `fk_interconnection_hosting_capacity_ems_node_id`;
ALTER TABLE `interconnection`.`hosting_capacity` ADD CONSTRAINT `fk_interconnection_hosting_capacity_ems_node_id` FOREIGN KEY (`ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `interconnection`.`cluster_study_group` DROP CONSTRAINT IF EXISTS `fk_interconnection_cluster_study_group_control_area_id`;
ALTER TABLE `interconnection`.`cluster_study_group` ADD CONSTRAINT `fk_interconnection_cluster_study_group_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

-- ========= interconnection --> metering (6) =========
ALTER TABLE `interconnection`.`application` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_meter_point_id`;
ALTER TABLE `interconnection`.`application` ADD CONSTRAINT `fk_interconnection_application_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `interconnection`.`der_system` DROP CONSTRAINT IF EXISTS `fk_interconnection_der_system_meter_id`;
ALTER TABLE `interconnection`.`der_system` ADD CONSTRAINT `fk_interconnection_der_system_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `interconnection`.`poi_specification` DROP CONSTRAINT IF EXISTS `fk_interconnection_poi_specification_meter_point_id`;
ALTER TABLE `interconnection`.`poi_specification` ADD CONSTRAINT `fk_interconnection_poi_specification_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `interconnection`.`interconnection_agreement` DROP CONSTRAINT IF EXISTS `fk_interconnection_interconnection_agreement_meter_point_id`;
ALTER TABLE `interconnection`.`interconnection_agreement` ADD CONSTRAINT `fk_interconnection_interconnection_agreement_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `interconnection`.`nem_agreement` DROP CONSTRAINT IF EXISTS `fk_interconnection_nem_agreement_meter_id`;
ALTER TABLE `interconnection`.`nem_agreement` ADD CONSTRAINT `fk_interconnection_nem_agreement_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `interconnection`.`sgip_enrollment` DROP CONSTRAINT IF EXISTS `fk_interconnection_sgip_enrollment_meter_point_id`;
ALTER TABLE `interconnection`.`sgip_enrollment` ADD CONSTRAINT `fk_interconnection_sgip_enrollment_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

-- ========= interconnection --> renewable (3) =========
ALTER TABLE `interconnection`.`der_system` DROP CONSTRAINT IF EXISTS `fk_interconnection_der_system_der_registry_id`;
ALTER TABLE `interconnection`.`der_system` ADD CONSTRAINT `fk_interconnection_der_system_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `interconnection`.`nem_agreement` DROP CONSTRAINT IF EXISTS `fk_interconnection_nem_agreement_nem_account_id`;
ALTER TABLE `interconnection`.`nem_agreement` ADD CONSTRAINT `fk_interconnection_nem_agreement_nem_account_id` FOREIGN KEY (`nem_account_id`) REFERENCES `renewable`.`nem_account` (`nem_account_id`);

ALTER TABLE `interconnection`.`sgip_enrollment` DROP CONSTRAINT IF EXISTS `fk_interconnection_sgip_enrollment_incentive_application_id`;
ALTER TABLE `interconnection`.`sgip_enrollment` ADD CONSTRAINT `fk_interconnection_sgip_enrollment_incentive_application_id` FOREIGN KEY (`incentive_application_id`) REFERENCES `renewable`.`incentive_application` (`incentive_application_id`);

-- ========= interconnection --> supply (2) =========
ALTER TABLE `interconnection`.`network_upgrade` DROP CONSTRAINT IF EXISTS `fk_interconnection_network_upgrade_material_master_id`;
ALTER TABLE `interconnection`.`network_upgrade` ADD CONSTRAINT `fk_interconnection_network_upgrade_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `interconnection`.`network_upgrade` DROP CONSTRAINT IF EXISTS `fk_interconnection_network_upgrade_purchase_order_id`;
ALTER TABLE `interconnection`.`network_upgrade` ADD CONSTRAINT `fk_interconnection_network_upgrade_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `supply`.`purchase_order` (`purchase_order_id`);

-- ========= interconnection --> workforce (18) =========
ALTER TABLE `interconnection`.`application` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_employee_id`;
ALTER TABLE `interconnection`.`application` ADD CONSTRAINT `fk_interconnection_application_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `interconnection`.`der_system` DROP CONSTRAINT IF EXISTS `fk_interconnection_der_system_commissioning_engineer_employee_id`;
ALTER TABLE `interconnection`.`der_system` ADD CONSTRAINT `fk_interconnection_der_system_commissioning_engineer_employee_id` FOREIGN KEY (`commissioning_engineer_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `interconnection`.`poi_specification` DROP CONSTRAINT IF EXISTS `fk_interconnection_poi_specification_primary_poi_employee_id`;
ALTER TABLE `interconnection`.`poi_specification` ADD CONSTRAINT `fk_interconnection_poi_specification_primary_poi_employee_id` FOREIGN KEY (`primary_poi_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `interconnection`.`technical_review` DROP CONSTRAINT IF EXISTS `fk_interconnection_technical_review_primary_technical_employee_id`;
ALTER TABLE `interconnection`.`technical_review` ADD CONSTRAINT `fk_interconnection_technical_review_primary_technical_employee_id` FOREIGN KEY (`primary_technical_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `interconnection`.`network_upgrade` DROP CONSTRAINT IF EXISTS `fk_interconnection_network_upgrade_project_manager_employee_id`;
ALTER TABLE `interconnection`.`network_upgrade` ADD CONSTRAINT `fk_interconnection_network_upgrade_project_manager_employee_id` FOREIGN KEY (`project_manager_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `interconnection`.`interconnection_agreement` DROP CONSTRAINT IF EXISTS `fk_interconnection_interconnection_agreement_administrator_employee_id`;
ALTER TABLE `interconnection`.`interconnection_agreement` ADD CONSTRAINT `fk_interconnection_interconnection_agreement_administrator_employee_id` FOREIGN KEY (`administrator_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `interconnection`.`nem_agreement` DROP CONSTRAINT IF EXISTS `fk_interconnection_nem_agreement_employee_id`;
ALTER TABLE `interconnection`.`nem_agreement` ADD CONSTRAINT `fk_interconnection_nem_agreement_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `interconnection`.`application_status_history` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_status_history_primary_application_employee_id`;
ALTER TABLE `interconnection`.`application_status_history` ADD CONSTRAINT `fk_interconnection_application_status_history_primary_application_employee_id` FOREIGN KEY (`primary_application_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `interconnection`.`queue_position` DROP CONSTRAINT IF EXISTS `fk_interconnection_queue_position_queue_manager_employee_id`;
ALTER TABLE `interconnection`.`queue_position` ADD CONSTRAINT `fk_interconnection_queue_position_queue_manager_employee_id` FOREIGN KEY (`queue_manager_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `interconnection`.`hosting_capacity` DROP CONSTRAINT IF EXISTS `fk_interconnection_hosting_capacity_assessment_analyst_employee_id`;
ALTER TABLE `interconnection`.`hosting_capacity` ADD CONSTRAINT `fk_interconnection_hosting_capacity_assessment_analyst_employee_id` FOREIGN KEY (`assessment_analyst_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `interconnection`.`inspection_milestone` DROP CONSTRAINT IF EXISTS `fk_interconnection_inspection_milestone_created_by_user_employee_id`;
ALTER TABLE `interconnection`.`inspection_milestone` ADD CONSTRAINT `fk_interconnection_inspection_milestone_created_by_user_employee_id` FOREIGN KEY (`created_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `interconnection`.`inspection_milestone` DROP CONSTRAINT IF EXISTS `fk_interconnection_inspection_milestone_employee_id`;
ALTER TABLE `interconnection`.`inspection_milestone` ADD CONSTRAINT `fk_interconnection_inspection_milestone_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `interconnection`.`inspection_milestone` DROP CONSTRAINT IF EXISTS `fk_interconnection_inspection_milestone_last_modified_by_user_employee_id`;
ALTER TABLE `interconnection`.`inspection_milestone` ADD CONSTRAINT `fk_interconnection_inspection_milestone_last_modified_by_user_employee_id` FOREIGN KEY (`last_modified_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `interconnection`.`cost_responsibility` DROP CONSTRAINT IF EXISTS `fk_interconnection_cost_responsibility_cost_estimator_employee_id`;
ALTER TABLE `interconnection`.`cost_responsibility` ADD CONSTRAINT `fk_interconnection_cost_responsibility_cost_estimator_employee_id` FOREIGN KEY (`cost_estimator_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `interconnection`.`application_document` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_document_primary_application_employee_id`;
ALTER TABLE `interconnection`.`application_document` ADD CONSTRAINT `fk_interconnection_application_document_primary_application_employee_id` FOREIGN KEY (`primary_application_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `interconnection`.`application_document` DROP CONSTRAINT IF EXISTS `fk_interconnection_application_document_tertiary_application_modified_by_user_employee_id`;
ALTER TABLE `interconnection`.`application_document` ADD CONSTRAINT `fk_interconnection_application_document_tertiary_application_modified_by_user_employee_id` FOREIGN KEY (`tertiary_application_modified_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `interconnection`.`cluster_study_group` DROP CONSTRAINT IF EXISTS `fk_interconnection_cluster_study_group_employee_id`;
ALTER TABLE `interconnection`.`cluster_study_group` ADD CONSTRAINT `fk_interconnection_cluster_study_group_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `interconnection`.`cluster_study_group` DROP CONSTRAINT IF EXISTS `fk_interconnection_cluster_study_group_study_manager_employee_id`;
ALTER TABLE `interconnection`.`cluster_study_group` ADD CONSTRAINT `fk_interconnection_cluster_study_group_study_manager_employee_id` FOREIGN KEY (`study_manager_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

-- ========= metering --> asset (8) =========
ALTER TABLE `metering`.`meter_point` DROP CONSTRAINT IF EXISTS `fk_metering_meter_point_service_point_asset_registry_id`;
ALTER TABLE `metering`.`meter_point` ADD CONSTRAINT `fk_metering_meter_point_service_point_asset_registry_id` FOREIGN KEY (`service_point_asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `metering`.`meter_installation` DROP CONSTRAINT IF EXISTS `fk_metering_meter_installation_meter_work_order_id`;
ALTER TABLE `metering`.`meter_installation` ADD CONSTRAINT `fk_metering_meter_installation_meter_work_order_id` FOREIGN KEY (`meter_work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `metering`.`meter_installation` DROP CONSTRAINT IF EXISTS `fk_metering_meter_installation_primary_meter_removal_work_order_id`;
ALTER TABLE `metering`.`meter_installation` ADD CONSTRAINT `fk_metering_meter_installation_primary_meter_removal_work_order_id` FOREIGN KEY (`primary_meter_removal_work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `metering`.`ami_head_end` DROP CONSTRAINT IF EXISTS `fk_metering_ami_head_end_registry_id`;
ALTER TABLE `metering`.`ami_head_end` ADD CONSTRAINT `fk_metering_ami_head_end_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `metering`.`remote_service_order` DROP CONSTRAINT IF EXISTS `fk_metering_remote_service_order_capital_project_id`;
ALTER TABLE `metering`.`remote_service_order` ADD CONSTRAINT `fk_metering_remote_service_order_capital_project_id` FOREIGN KEY (`capital_project_id`) REFERENCES `asset`.`capital_project` (`capital_project_id`);

ALTER TABLE `metering`.`remote_service_order` DROP CONSTRAINT IF EXISTS `fk_metering_remote_service_order_work_order_id`;
ALTER TABLE `metering`.`remote_service_order` ADD CONSTRAINT `fk_metering_remote_service_order_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `metering`.`meter_test` DROP CONSTRAINT IF EXISTS `fk_metering_meter_test_inspection_id`;
ALTER TABLE `metering`.`meter_test` ADD CONSTRAINT `fk_metering_meter_test_inspection_id` FOREIGN KEY (`inspection_id`) REFERENCES `asset`.`inspection` (`inspection_id`);

ALTER TABLE `metering`.`meter_test` DROP CONSTRAINT IF EXISTS `fk_metering_meter_test_work_order_id`;
ALTER TABLE `metering`.`meter_test` ADD CONSTRAINT `fk_metering_meter_test_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

-- ========= metering --> billing (12) =========
ALTER TABLE `metering`.`interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_interval_reading_cycle_id`;
ALTER TABLE `metering`.`interval_reading` ADD CONSTRAINT `fk_metering_interval_reading_cycle_id` FOREIGN KEY (`cycle_id`) REFERENCES `billing`.`cycle` (`cycle_id`);

ALTER TABLE `metering`.`validated_interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_validated_interval_reading_cycle_id`;
ALTER TABLE `metering`.`validated_interval_reading` ADD CONSTRAINT `fk_metering_validated_interval_reading_cycle_id` FOREIGN KEY (`cycle_id`) REFERENCES `billing`.`cycle` (`cycle_id`);

ALTER TABLE `metering`.`validated_interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_validated_interval_reading_rate_schedule_id`;
ALTER TABLE `metering`.`validated_interval_reading` ADD CONSTRAINT `fk_metering_validated_interval_reading_rate_schedule_id` FOREIGN KEY (`rate_schedule_id`) REFERENCES `billing`.`rate_schedule` (`rate_schedule_id`);

ALTER TABLE `metering`.`meter_read` DROP CONSTRAINT IF EXISTS `fk_metering_meter_read_billing_run_id`;
ALTER TABLE `metering`.`meter_read` ADD CONSTRAINT `fk_metering_meter_read_billing_run_id` FOREIGN KEY (`billing_run_id`) REFERENCES `billing`.`billing_run` (`billing_run_id`);

ALTER TABLE `metering`.`meter_read` DROP CONSTRAINT IF EXISTS `fk_metering_meter_read_cycle_id`;
ALTER TABLE `metering`.`meter_read` ADD CONSTRAINT `fk_metering_meter_read_cycle_id` FOREIGN KEY (`cycle_id`) REFERENCES `billing`.`cycle` (`cycle_id`);

ALTER TABLE `metering`.`meter_read` DROP CONSTRAINT IF EXISTS `fk_metering_meter_read_rate_schedule_id`;
ALTER TABLE `metering`.`meter_read` ADD CONSTRAINT `fk_metering_meter_read_rate_schedule_id` FOREIGN KEY (`rate_schedule_id`) REFERENCES `billing`.`rate_schedule` (`rate_schedule_id`);

ALTER TABLE `metering`.`vee_exception` DROP CONSTRAINT IF EXISTS `fk_metering_vee_exception_rate_schedule_id`;
ALTER TABLE `metering`.`vee_exception` ADD CONSTRAINT `fk_metering_vee_exception_rate_schedule_id` FOREIGN KEY (`rate_schedule_id`) REFERENCES `billing`.`rate_schedule` (`rate_schedule_id`);

ALTER TABLE `metering`.`remote_service_order` DROP CONSTRAINT IF EXISTS `fk_metering_remote_service_order_cycle_id`;
ALTER TABLE `metering`.`remote_service_order` ADD CONSTRAINT `fk_metering_remote_service_order_cycle_id` FOREIGN KEY (`cycle_id`) REFERENCES `billing`.`cycle` (`cycle_id`);

ALTER TABLE `metering`.`meter_test` DROP CONSTRAINT IF EXISTS `fk_metering_meter_test_adjustment_id`;
ALTER TABLE `metering`.`meter_test` ADD CONSTRAINT `fk_metering_meter_test_adjustment_id` FOREIGN KEY (`adjustment_id`) REFERENCES `billing`.`adjustment` (`adjustment_id`);

ALTER TABLE `metering`.`mdm_usage_transaction` DROP CONSTRAINT IF EXISTS `fk_metering_mdm_usage_transaction_invoice_id`;
ALTER TABLE `metering`.`mdm_usage_transaction` ADD CONSTRAINT `fk_metering_mdm_usage_transaction_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

ALTER TABLE `metering`.`service_point` DROP CONSTRAINT IF EXISTS `fk_metering_service_point_billing_cycle_id`;
ALTER TABLE `metering`.`service_point` ADD CONSTRAINT `fk_metering_service_point_billing_cycle_id` FOREIGN KEY (`billing_cycle_id`) REFERENCES `billing`.`cycle` (`cycle_id`);

ALTER TABLE `metering`.`service_point` DROP CONSTRAINT IF EXISTS `fk_metering_service_point_rate_schedule_id`;
ALTER TABLE `metering`.`service_point` ADD CONSTRAINT `fk_metering_service_point_rate_schedule_id` FOREIGN KEY (`rate_schedule_id`) REFERENCES `billing`.`rate_schedule` (`rate_schedule_id`);

-- ========= metering --> compliance (12) =========
ALTER TABLE `metering`.`meter` DROP CONSTRAINT IF EXISTS `fk_metering_meter_obligation_id`;
ALTER TABLE `metering`.`meter` ADD CONSTRAINT `fk_metering_meter_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `metering`.`meter_point` DROP CONSTRAINT IF EXISTS `fk_metering_meter_point_obligation_id`;
ALTER TABLE `metering`.`meter_point` ADD CONSTRAINT `fk_metering_meter_point_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `metering`.`meter_installation` DROP CONSTRAINT IF EXISTS `fk_metering_meter_installation_audit_id`;
ALTER TABLE `metering`.`meter_installation` ADD CONSTRAINT `fk_metering_meter_installation_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `metering`.`validated_interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_validated_interval_reading_audit_id`;
ALTER TABLE `metering`.`validated_interval_reading` ADD CONSTRAINT `fk_metering_validated_interval_reading_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `metering`.`vee_rule` DROP CONSTRAINT IF EXISTS `fk_metering_vee_rule_obligation_id`;
ALTER TABLE `metering`.`vee_rule` ADD CONSTRAINT `fk_metering_vee_rule_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `metering`.`vee_exception` DROP CONSTRAINT IF EXISTS `fk_metering_vee_exception_audit_finding_id`;
ALTER TABLE `metering`.`vee_exception` ADD CONSTRAINT `fk_metering_vee_exception_audit_finding_id` FOREIGN KEY (`audit_finding_id`) REFERENCES `compliance`.`audit_finding` (`audit_finding_id`);

ALTER TABLE `metering`.`ami_head_end` DROP CONSTRAINT IF EXISTS `fk_metering_ami_head_end_nerc_cip_asset_id`;
ALTER TABLE `metering`.`ami_head_end` ADD CONSTRAINT `fk_metering_ami_head_end_nerc_cip_asset_id` FOREIGN KEY (`nerc_cip_asset_id`) REFERENCES `compliance`.`nerc_cip_asset` (`nerc_cip_asset_id`);

ALTER TABLE `metering`.`ami_event` DROP CONSTRAINT IF EXISTS `fk_metering_ami_event_self_report_id`;
ALTER TABLE `metering`.`ami_event` ADD CONSTRAINT `fk_metering_ami_event_self_report_id` FOREIGN KEY (`self_report_id`) REFERENCES `compliance`.`self_report` (`self_report_id`);

ALTER TABLE `metering`.`net_energy_metering` DROP CONSTRAINT IF EXISTS `fk_metering_net_energy_metering_compliance_rec_certificate_id`;
ALTER TABLE `metering`.`net_energy_metering` ADD CONSTRAINT `fk_metering_net_energy_metering_compliance_rec_certificate_id` FOREIGN KEY (`compliance_rec_certificate_id`) REFERENCES `compliance`.`compliance_rec_certificate` (`compliance_rec_certificate_id`);

ALTER TABLE `metering`.`net_energy_metering` DROP CONSTRAINT IF EXISTS `fk_metering_net_energy_metering_regulatory_filing_id`;
ALTER TABLE `metering`.`net_energy_metering` ADD CONSTRAINT `fk_metering_net_energy_metering_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `metering`.`meter_test` DROP CONSTRAINT IF EXISTS `fk_metering_meter_test_audit_id`;
ALTER TABLE `metering`.`meter_test` ADD CONSTRAINT `fk_metering_meter_test_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `metering`.`meter_test` DROP CONSTRAINT IF EXISTS `fk_metering_meter_test_environmental_permit_id`;
ALTER TABLE `metering`.`meter_test` ADD CONSTRAINT `fk_metering_meter_test_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `compliance`.`environmental_permit` (`environmental_permit_id`);

-- ========= metering --> customer (16) =========
ALTER TABLE `metering`.`meter_point` DROP CONSTRAINT IF EXISTS `fk_metering_meter_point_premise_id`;
ALTER TABLE `metering`.`meter_point` ADD CONSTRAINT `fk_metering_meter_point_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `metering`.`meter_installation` DROP CONSTRAINT IF EXISTS `fk_metering_meter_installation_customer_service_agreement_id`;
ALTER TABLE `metering`.`meter_installation` ADD CONSTRAINT `fk_metering_meter_installation_customer_service_agreement_id` FOREIGN KEY (`customer_service_agreement_id`) REFERENCES `customer`.`customer_service_agreement` (`customer_service_agreement_id`);

ALTER TABLE `metering`.`meter_installation` DROP CONSTRAINT IF EXISTS `fk_metering_meter_installation_premise_id`;
ALTER TABLE `metering`.`meter_installation` ADD CONSTRAINT `fk_metering_meter_installation_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `metering`.`meter_read` DROP CONSTRAINT IF EXISTS `fk_metering_meter_read_account_id`;
ALTER TABLE `metering`.`meter_read` ADD CONSTRAINT `fk_metering_meter_read_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `metering`.`meter_read` DROP CONSTRAINT IF EXISTS `fk_metering_meter_read_premise_id`;
ALTER TABLE `metering`.`meter_read` ADD CONSTRAINT `fk_metering_meter_read_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `metering`.`vee_exception` DROP CONSTRAINT IF EXISTS `fk_metering_vee_exception_account_id`;
ALTER TABLE `metering`.`vee_exception` ADD CONSTRAINT `fk_metering_vee_exception_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `metering`.`ami_event` DROP CONSTRAINT IF EXISTS `fk_metering_ami_event_customer_account_id`;
ALTER TABLE `metering`.`ami_event` ADD CONSTRAINT `fk_metering_ami_event_customer_account_id` FOREIGN KEY (`customer_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `metering`.`ami_event` DROP CONSTRAINT IF EXISTS `fk_metering_ami_event_premise_id`;
ALTER TABLE `metering`.`ami_event` ADD CONSTRAINT `fk_metering_ami_event_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `metering`.`net_energy_metering` DROP CONSTRAINT IF EXISTS `fk_metering_net_energy_metering_account_id`;
ALTER TABLE `metering`.`net_energy_metering` ADD CONSTRAINT `fk_metering_net_energy_metering_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `metering`.`net_energy_metering` DROP CONSTRAINT IF EXISTS `fk_metering_net_energy_metering_customer_enrollment_id`;
ALTER TABLE `metering`.`net_energy_metering` ADD CONSTRAINT `fk_metering_net_energy_metering_customer_enrollment_id` FOREIGN KEY (`customer_enrollment_id`) REFERENCES `customer`.`customer_enrollment` (`customer_enrollment_id`);

ALTER TABLE `metering`.`net_energy_metering` DROP CONSTRAINT IF EXISTS `fk_metering_net_energy_metering_premise_id`;
ALTER TABLE `metering`.`net_energy_metering` ADD CONSTRAINT `fk_metering_net_energy_metering_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `metering`.`remote_service_order` DROP CONSTRAINT IF EXISTS `fk_metering_remote_service_order_account_id`;
ALTER TABLE `metering`.`remote_service_order` ADD CONSTRAINT `fk_metering_remote_service_order_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `metering`.`remote_service_order` DROP CONSTRAINT IF EXISTS `fk_metering_remote_service_order_customer_service_request_id`;
ALTER TABLE `metering`.`remote_service_order` ADD CONSTRAINT `fk_metering_remote_service_order_customer_service_request_id` FOREIGN KEY (`customer_service_request_id`) REFERENCES `customer`.`customer_service_request` (`customer_service_request_id`);

ALTER TABLE `metering`.`meter_test` DROP CONSTRAINT IF EXISTS `fk_metering_meter_test_account_id`;
ALTER TABLE `metering`.`meter_test` ADD CONSTRAINT `fk_metering_meter_test_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `metering`.`meter_test` DROP CONSTRAINT IF EXISTS `fk_metering_meter_test_customer_service_request_id`;
ALTER TABLE `metering`.`meter_test` ADD CONSTRAINT `fk_metering_meter_test_customer_service_request_id` FOREIGN KEY (`customer_service_request_id`) REFERENCES `customer`.`customer_service_request` (`customer_service_request_id`);

ALTER TABLE `metering`.`mdm_usage_transaction` DROP CONSTRAINT IF EXISTS `fk_metering_mdm_usage_transaction_account_id`;
ALTER TABLE `metering`.`mdm_usage_transaction` ADD CONSTRAINT `fk_metering_mdm_usage_transaction_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

-- ========= metering --> demand (5) =========
ALTER TABLE `metering`.`validated_interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_validated_interval_reading_dr_event_id`;
ALTER TABLE `metering`.`validated_interval_reading` ADD CONSTRAINT `fk_metering_validated_interval_reading_dr_event_id` FOREIGN KEY (`dr_event_id`) REFERENCES `demand`.`dr_event` (`dr_event_id`);

ALTER TABLE `metering`.`remote_service_order` DROP CONSTRAINT IF EXISTS `fk_metering_remote_service_order_dr_event_id`;
ALTER TABLE `metering`.`remote_service_order` ADD CONSTRAINT `fk_metering_remote_service_order_dr_event_id` FOREIGN KEY (`dr_event_id`) REFERENCES `demand`.`dr_event` (`dr_event_id`);

ALTER TABLE `metering`.`metering_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_metering_metering_dr_enrollment_aggregator_id`;
ALTER TABLE `metering`.`metering_dr_enrollment` ADD CONSTRAINT `fk_metering_metering_dr_enrollment_aggregator_id` FOREIGN KEY (`aggregator_id`) REFERENCES `demand`.`aggregator` (`aggregator_id`);

ALTER TABLE `metering`.`metering_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_metering_metering_dr_enrollment_dr_enrollment_id`;
ALTER TABLE `metering`.`metering_dr_enrollment` ADD CONSTRAINT `fk_metering_metering_dr_enrollment_dr_enrollment_id` FOREIGN KEY (`dr_enrollment_id`) REFERENCES `demand`.`demand_dr_enrollment` (`demand_dr_enrollment_id`);

ALTER TABLE `metering`.`metering_dr_enrollment` DROP CONSTRAINT IF EXISTS `fk_metering_metering_dr_enrollment_dr_program_id`;
ALTER TABLE `metering`.`metering_dr_enrollment` ADD CONSTRAINT `fk_metering_metering_dr_enrollment_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

-- ========= metering --> distribution (6) =========
ALTER TABLE `metering`.`meter_point` DROP CONSTRAINT IF EXISTS `fk_metering_meter_point_distribution_feeder_id`;
ALTER TABLE `metering`.`meter_point` ADD CONSTRAINT `fk_metering_meter_point_distribution_feeder_id` FOREIGN KEY (`distribution_feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `metering`.`meter_point` DROP CONSTRAINT IF EXISTS `fk_metering_meter_point_distribution_transformer_id`;
ALTER TABLE `metering`.`meter_point` ADD CONSTRAINT `fk_metering_meter_point_distribution_transformer_id` FOREIGN KEY (`distribution_transformer_id`) REFERENCES `distribution`.`transformer` (`transformer_id`);

ALTER TABLE `metering`.`ami_event` DROP CONSTRAINT IF EXISTS `fk_metering_ami_event_feeder_id`;
ALTER TABLE `metering`.`ami_event` ADD CONSTRAINT `fk_metering_ami_event_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `metering`.`ami_event` DROP CONSTRAINT IF EXISTS `fk_metering_ami_event_transformer_id`;
ALTER TABLE `metering`.`ami_event` ADD CONSTRAINT `fk_metering_ami_event_transformer_id` FOREIGN KEY (`transformer_id`) REFERENCES `distribution`.`transformer` (`transformer_id`);

ALTER TABLE `metering`.`net_energy_metering` DROP CONSTRAINT IF EXISTS `fk_metering_net_energy_metering_der_interconnection_point_id`;
ALTER TABLE `metering`.`net_energy_metering` ADD CONSTRAINT `fk_metering_net_energy_metering_der_interconnection_point_id` FOREIGN KEY (`der_interconnection_point_id`) REFERENCES `distribution`.`der_interconnection_point` (`der_interconnection_point_id`);

ALTER TABLE `metering`.`meter_route` DROP CONSTRAINT IF EXISTS `fk_metering_meter_route_service_territory_id`;
ALTER TABLE `metering`.`meter_route` ADD CONSTRAINT `fk_metering_meter_route_service_territory_id` FOREIGN KEY (`service_territory_id`) REFERENCES `distribution`.`service_territory` (`service_territory_id`);

-- ========= metering --> finance (10) =========
ALTER TABLE `metering`.`meter` DROP CONSTRAINT IF EXISTS `fk_metering_meter_fixed_asset_id`;
ALTER TABLE `metering`.`meter` ADD CONSTRAINT `fk_metering_meter_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `finance`.`fixed_asset` (`fixed_asset_id`);

ALTER TABLE `metering`.`meter_point` DROP CONSTRAINT IF EXISTS `fk_metering_meter_point_cost_center_id`;
ALTER TABLE `metering`.`meter_point` ADD CONSTRAINT `fk_metering_meter_point_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `metering`.`meter_installation` DROP CONSTRAINT IF EXISTS `fk_metering_meter_installation_cost_center_id`;
ALTER TABLE `metering`.`meter_installation` ADD CONSTRAINT `fk_metering_meter_installation_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `metering`.`meter_installation` DROP CONSTRAINT IF EXISTS `fk_metering_meter_installation_installation_capex_project_id`;
ALTER TABLE `metering`.`meter_installation` ADD CONSTRAINT `fk_metering_meter_installation_installation_capex_project_id` FOREIGN KEY (`installation_capex_project_id`) REFERENCES `finance`.`capex_project` (`capex_project_id`);

ALTER TABLE `metering`.`validated_interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_validated_interval_reading_vee_cost_center_id`;
ALTER TABLE `metering`.`validated_interval_reading` ADD CONSTRAINT `fk_metering_validated_interval_reading_vee_cost_center_id` FOREIGN KEY (`vee_cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `metering`.`ami_head_end` DROP CONSTRAINT IF EXISTS `fk_metering_ami_head_end_capex_project_id`;
ALTER TABLE `metering`.`ami_head_end` ADD CONSTRAINT `fk_metering_ami_head_end_capex_project_id` FOREIGN KEY (`capex_project_id`) REFERENCES `finance`.`capex_project` (`capex_project_id`);

ALTER TABLE `metering`.`ami_head_end` DROP CONSTRAINT IF EXISTS `fk_metering_ami_head_end_cost_center_id`;
ALTER TABLE `metering`.`ami_head_end` ADD CONSTRAINT `fk_metering_ami_head_end_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `metering`.`ami_head_end` DROP CONSTRAINT IF EXISTS `fk_metering_ami_head_end_fixed_asset_id`;
ALTER TABLE `metering`.`ami_head_end` ADD CONSTRAINT `fk_metering_ami_head_end_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `finance`.`fixed_asset` (`fixed_asset_id`);

ALTER TABLE `metering`.`remote_service_order` DROP CONSTRAINT IF EXISTS `fk_metering_remote_service_order_cost_center_id`;
ALTER TABLE `metering`.`remote_service_order` ADD CONSTRAINT `fk_metering_remote_service_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `metering`.`meter_test` DROP CONSTRAINT IF EXISTS `fk_metering_meter_test_cost_center_id`;
ALTER TABLE `metering`.`meter_test` ADD CONSTRAINT `fk_metering_meter_test_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

-- ========= metering --> gis (3) =========
ALTER TABLE `metering`.`meter` DROP CONSTRAINT IF EXISTS `fk_metering_meter_gis_location_id`;
ALTER TABLE `metering`.`meter` ADD CONSTRAINT `fk_metering_meter_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `metering`.`meter_point` DROP CONSTRAINT IF EXISTS `fk_metering_meter_point_gis_location_id`;
ALTER TABLE `metering`.`meter_point` ADD CONSTRAINT `fk_metering_meter_point_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `metering`.`service_point` DROP CONSTRAINT IF EXISTS `fk_metering_service_point_gis_location_id`;
ALTER TABLE `metering`.`service_point` ADD CONSTRAINT `fk_metering_service_point_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

-- ========= metering --> grid (6) =========
ALTER TABLE `metering`.`meter_point` DROP CONSTRAINT IF EXISTS `fk_metering_meter_point_control_area_id`;
ALTER TABLE `metering`.`meter_point` ADD CONSTRAINT `fk_metering_meter_point_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `metering`.`interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_interval_reading_control_area_id`;
ALTER TABLE `metering`.`interval_reading` ADD CONSTRAINT `fk_metering_interval_reading_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `metering`.`validated_interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_validated_interval_reading_control_area_id`;
ALTER TABLE `metering`.`validated_interval_reading` ADD CONSTRAINT `fk_metering_validated_interval_reading_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `metering`.`meter_read` DROP CONSTRAINT IF EXISTS `fk_metering_meter_read_control_area_id`;
ALTER TABLE `metering`.`meter_read` ADD CONSTRAINT `fk_metering_meter_read_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `metering`.`ami_event` DROP CONSTRAINT IF EXISTS `fk_metering_ami_event_scada_point_id`;
ALTER TABLE `metering`.`ami_event` ADD CONSTRAINT `fk_metering_ami_event_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `metering`.`remote_service_order` DROP CONSTRAINT IF EXISTS `fk_metering_remote_service_order_scada_point_id`;
ALTER TABLE `metering`.`remote_service_order` ADD CONSTRAINT `fk_metering_remote_service_order_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

-- ========= metering --> interconnection (2) =========
ALTER TABLE `metering`.`ami_event` DROP CONSTRAINT IF EXISTS `fk_metering_ami_event_der_system_id`;
ALTER TABLE `metering`.`ami_event` ADD CONSTRAINT `fk_metering_ami_event_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `metering`.`net_energy_metering` DROP CONSTRAINT IF EXISTS `fk_metering_net_energy_metering_der_system_id`;
ALTER TABLE `metering`.`net_energy_metering` ADD CONSTRAINT `fk_metering_net_energy_metering_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

-- ========= metering --> outage (2) =========
ALTER TABLE `metering`.`validated_interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_validated_interval_reading_event_id`;
ALTER TABLE `metering`.`validated_interval_reading` ADD CONSTRAINT `fk_metering_validated_interval_reading_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `metering`.`vee_exception` DROP CONSTRAINT IF EXISTS `fk_metering_vee_exception_event_id`;
ALTER TABLE `metering`.`vee_exception` ADD CONSTRAINT `fk_metering_vee_exception_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

-- ========= metering --> renewable (8) =========
ALTER TABLE `metering`.`meter_point` DROP CONSTRAINT IF EXISTS `fk_metering_meter_point_der_registry_id`;
ALTER TABLE `metering`.`meter_point` ADD CONSTRAINT `fk_metering_meter_point_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `metering`.`meter_installation` DROP CONSTRAINT IF EXISTS `fk_metering_meter_installation_der_registry_id`;
ALTER TABLE `metering`.`meter_installation` ADD CONSTRAINT `fk_metering_meter_installation_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `metering`.`interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_interval_reading_der_registry_id`;
ALTER TABLE `metering`.`interval_reading` ADD CONSTRAINT `fk_metering_interval_reading_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `metering`.`validated_interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_validated_interval_reading_der_registry_id`;
ALTER TABLE `metering`.`validated_interval_reading` ADD CONSTRAINT `fk_metering_validated_interval_reading_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `metering`.`meter_read` DROP CONSTRAINT IF EXISTS `fk_metering_meter_read_der_registry_id`;
ALTER TABLE `metering`.`meter_read` ADD CONSTRAINT `fk_metering_meter_read_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `metering`.`remote_service_order` DROP CONSTRAINT IF EXISTS `fk_metering_remote_service_order_der_registry_id`;
ALTER TABLE `metering`.`remote_service_order` ADD CONSTRAINT `fk_metering_remote_service_order_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `metering`.`meter_test` DROP CONSTRAINT IF EXISTS `fk_metering_meter_test_der_registry_id`;
ALTER TABLE `metering`.`meter_test` ADD CONSTRAINT `fk_metering_meter_test_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

ALTER TABLE `metering`.`mdm_usage_transaction` DROP CONSTRAINT IF EXISTS `fk_metering_mdm_usage_transaction_der_registry_id`;
ALTER TABLE `metering`.`mdm_usage_transaction` ADD CONSTRAINT `fk_metering_mdm_usage_transaction_der_registry_id` FOREIGN KEY (`der_registry_id`) REFERENCES `renewable`.`der_registry` (`der_registry_id`);

-- ========= metering --> trading (5) =========
ALTER TABLE `metering`.`meter_point` DROP CONSTRAINT IF EXISTS `fk_metering_meter_point_lmp_price_id`;
ALTER TABLE `metering`.`meter_point` ADD CONSTRAINT `fk_metering_meter_point_lmp_price_id` FOREIGN KEY (`lmp_price_id`) REFERENCES `trading`.`lmp_price` (`lmp_price_id`);

ALTER TABLE `metering`.`meter_installation` DROP CONSTRAINT IF EXISTS `fk_metering_meter_installation_trade_id`;
ALTER TABLE `metering`.`meter_installation` ADD CONSTRAINT `fk_metering_meter_installation_trade_id` FOREIGN KEY (`trade_id`) REFERENCES `trading`.`trade` (`trade_id`);

ALTER TABLE `metering`.`interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_interval_reading_lmp_price_id`;
ALTER TABLE `metering`.`interval_reading` ADD CONSTRAINT `fk_metering_interval_reading_lmp_price_id` FOREIGN KEY (`lmp_price_id`) REFERENCES `trading`.`lmp_price` (`lmp_price_id`);

ALTER TABLE `metering`.`validated_interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_validated_interval_reading_lmp_price_id`;
ALTER TABLE `metering`.`validated_interval_reading` ADD CONSTRAINT `fk_metering_validated_interval_reading_lmp_price_id` FOREIGN KEY (`lmp_price_id`) REFERENCES `trading`.`lmp_price` (`lmp_price_id`);

ALTER TABLE `metering`.`net_energy_metering` DROP CONSTRAINT IF EXISTS `fk_metering_net_energy_metering_ppa_id`;
ALTER TABLE `metering`.`net_energy_metering` ADD CONSTRAINT `fk_metering_net_energy_metering_ppa_id` FOREIGN KEY (`ppa_id`) REFERENCES `trading`.`ppa` (`ppa_id`);

-- ========= metering --> transmission (1) =========
ALTER TABLE `metering`.`ami_event` DROP CONSTRAINT IF EXISTS `fk_metering_ami_event_transmission_outage_id`;
ALTER TABLE `metering`.`ami_event` ADD CONSTRAINT `fk_metering_ami_event_transmission_outage_id` FOREIGN KEY (`transmission_outage_id`) REFERENCES `transmission`.`transmission_outage` (`transmission_outage_id`);

-- ========= metering --> workforce (9) =========
ALTER TABLE `metering`.`meter_installation` DROP CONSTRAINT IF EXISTS `fk_metering_meter_installation_primary_meter_employee_id`;
ALTER TABLE `metering`.`meter_installation` ADD CONSTRAINT `fk_metering_meter_installation_primary_meter_employee_id` FOREIGN KEY (`primary_meter_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `metering`.`validated_interval_reading` DROP CONSTRAINT IF EXISTS `fk_metering_validated_interval_reading_primary_validated_employee_id`;
ALTER TABLE `metering`.`validated_interval_reading` ADD CONSTRAINT `fk_metering_validated_interval_reading_primary_validated_employee_id` FOREIGN KEY (`primary_validated_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `metering`.`meter_read` DROP CONSTRAINT IF EXISTS `fk_metering_meter_read_reader_employee_id`;
ALTER TABLE `metering`.`meter_read` ADD CONSTRAINT `fk_metering_meter_read_reader_employee_id` FOREIGN KEY (`reader_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `metering`.`vee_exception` DROP CONSTRAINT IF EXISTS `fk_metering_vee_exception_employee_id`;
ALTER TABLE `metering`.`vee_exception` ADD CONSTRAINT `fk_metering_vee_exception_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `metering`.`ami_event` DROP CONSTRAINT IF EXISTS `fk_metering_ami_event_employee_id`;
ALTER TABLE `metering`.`ami_event` ADD CONSTRAINT `fk_metering_ami_event_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `metering`.`remote_service_order` DROP CONSTRAINT IF EXISTS `fk_metering_remote_service_order_employee_id`;
ALTER TABLE `metering`.`remote_service_order` ADD CONSTRAINT `fk_metering_remote_service_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `metering`.`meter_test` DROP CONSTRAINT IF EXISTS `fk_metering_meter_test_employee_id`;
ALTER TABLE `metering`.`meter_test` ADD CONSTRAINT `fk_metering_meter_test_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `metering`.`meter_reading_route` DROP CONSTRAINT IF EXISTS `fk_metering_meter_reading_route_employee_id`;
ALTER TABLE `metering`.`meter_reading_route` ADD CONSTRAINT `fk_metering_meter_reading_route_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `metering`.`register` DROP CONSTRAINT IF EXISTS `fk_metering_register_location_id`;
ALTER TABLE `metering`.`register` ADD CONSTRAINT `fk_metering_register_location_id` FOREIGN KEY (`location_id`) REFERENCES `workforce`.`work_location` (`work_location_id`);

-- ========= outage --> asset (9) =========
ALTER TABLE `outage`.`event` DROP CONSTRAINT IF EXISTS `fk_outage_event_work_order_id`;
ALTER TABLE `outage`.`event` ADD CONSTRAINT `fk_outage_event_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `outage`.`outage_switching_step` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_step_device_asset_registry_id`;
ALTER TABLE `outage`.`outage_switching_step` ADD CONSTRAINT `fk_outage_outage_switching_step_device_asset_registry_id` FOREIGN KEY (`device_asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `outage`.`outage_switching_step` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_step_work_order_id`;
ALTER TABLE `outage`.`outage_switching_step` ADD CONSTRAINT `fk_outage_outage_switching_step_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `outage`.`event_status_history` DROP CONSTRAINT IF EXISTS `fk_outage_event_status_history_work_order_id`;
ALTER TABLE `outage`.`event_status_history` ADD CONSTRAINT `fk_outage_event_status_history_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `outage`.`etr_revision` DROP CONSTRAINT IF EXISTS `fk_outage_etr_revision_work_order_id`;
ALTER TABLE `outage`.`etr_revision` ADD CONSTRAINT `fk_outage_etr_revision_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `outage`.`outage_flisr_event` DROP CONSTRAINT IF EXISTS `fk_outage_outage_flisr_event_tie_switch_asset_registry_id`;
ALTER TABLE `outage`.`outage_flisr_event` ADD CONSTRAINT `fk_outage_outage_flisr_event_tie_switch_asset_registry_id` FOREIGN KEY (`tie_switch_asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `outage`.`safety_clearance` DROP CONSTRAINT IF EXISTS `fk_outage_safety_clearance_registry_id`;
ALTER TABLE `outage`.`safety_clearance` ADD CONSTRAINT `fk_outage_safety_clearance_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `outage`.`safety_clearance` DROP CONSTRAINT IF EXISTS `fk_outage_safety_clearance_work_order_id`;
ALTER TABLE `outage`.`safety_clearance` ADD CONSTRAINT `fk_outage_safety_clearance_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `outage`.`damage_assessment` DROP CONSTRAINT IF EXISTS `fk_outage_damage_assessment_registry_id`;
ALTER TABLE `outage`.`damage_assessment` ADD CONSTRAINT `fk_outage_damage_assessment_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

-- ========= outage --> billing (3) =========
ALTER TABLE `outage`.`interruption` DROP CONSTRAINT IF EXISTS `fk_outage_interruption_billing_service_agreement_id`;
ALTER TABLE `outage`.`interruption` ADD CONSTRAINT `fk_outage_interruption_billing_service_agreement_id` FOREIGN KEY (`billing_service_agreement_id`) REFERENCES `billing`.`billing_service_agreement` (`billing_service_agreement_id`);

ALTER TABLE `outage`.`affected_customer` DROP CONSTRAINT IF EXISTS `fk_outage_affected_customer_billing_service_agreement_id`;
ALTER TABLE `outage`.`affected_customer` ADD CONSTRAINT `fk_outage_affected_customer_billing_service_agreement_id` FOREIGN KEY (`billing_service_agreement_id`) REFERENCES `billing`.`billing_service_agreement` (`billing_service_agreement_id`);

ALTER TABLE `outage`.`affected_customer` DROP CONSTRAINT IF EXISTS `fk_outage_affected_customer_invoice_id`;
ALTER TABLE `outage`.`affected_customer` ADD CONSTRAINT `fk_outage_affected_customer_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `billing`.`invoice` (`invoice_id`);

-- ========= outage --> compliance (14) =========
ALTER TABLE `outage`.`event` DROP CONSTRAINT IF EXISTS `fk_outage_event_obligation_id`;
ALTER TABLE `outage`.`event` ADD CONSTRAINT `fk_outage_event_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `outage`.`outage_switching_order` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_order_obligation_id`;
ALTER TABLE `outage`.`outage_switching_order` ADD CONSTRAINT `fk_outage_outage_switching_order_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `outage`.`outage_crew_dispatch` DROP CONSTRAINT IF EXISTS `fk_outage_outage_crew_dispatch_training_record_id`;
ALTER TABLE `outage`.`outage_crew_dispatch` ADD CONSTRAINT `fk_outage_outage_crew_dispatch_training_record_id` FOREIGN KEY (`training_record_id`) REFERENCES `compliance`.`training_record` (`training_record_id`);

ALTER TABLE `outage`.`cause` DROP CONSTRAINT IF EXISTS `fk_outage_cause_obligation_id`;
ALTER TABLE `outage`.`cause` ADD CONSTRAINT `fk_outage_cause_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `outage`.`affected_customer` DROP CONSTRAINT IF EXISTS `fk_outage_affected_customer_compliance_exception_id`;
ALTER TABLE `outage`.`affected_customer` ADD CONSTRAINT `fk_outage_affected_customer_compliance_exception_id` FOREIGN KEY (`compliance_exception_id`) REFERENCES `compliance`.`exception` (`exception_id`);

ALTER TABLE `outage`.`storm_event` DROP CONSTRAINT IF EXISTS `fk_outage_storm_event_obligation_id`;
ALTER TABLE `outage`.`storm_event` ADD CONSTRAINT `fk_outage_storm_event_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `outage`.`mutual_aid_request` DROP CONSTRAINT IF EXISTS `fk_outage_mutual_aid_request_regulatory_correspondence_id`;
ALTER TABLE `outage`.`mutual_aid_request` ADD CONSTRAINT `fk_outage_mutual_aid_request_regulatory_correspondence_id` FOREIGN KEY (`regulatory_correspondence_id`) REFERENCES `compliance`.`regulatory_correspondence` (`regulatory_correspondence_id`);

ALTER TABLE `outage`.`reliability_index_period` DROP CONSTRAINT IF EXISTS `fk_outage_reliability_index_period_obligation_id`;
ALTER TABLE `outage`.`reliability_index_period` ADD CONSTRAINT `fk_outage_reliability_index_period_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `outage`.`etr_revision` DROP CONSTRAINT IF EXISTS `fk_outage_etr_revision_regulatory_correspondence_id`;
ALTER TABLE `outage`.`etr_revision` ADD CONSTRAINT `fk_outage_etr_revision_regulatory_correspondence_id` FOREIGN KEY (`regulatory_correspondence_id`) REFERENCES `compliance`.`regulatory_correspondence` (`regulatory_correspondence_id`);

ALTER TABLE `outage`.`segment_impact` DROP CONSTRAINT IF EXISTS `fk_outage_segment_impact_nerc_cip_asset_id`;
ALTER TABLE `outage`.`segment_impact` ADD CONSTRAINT `fk_outage_segment_impact_nerc_cip_asset_id` FOREIGN KEY (`nerc_cip_asset_id`) REFERENCES `compliance`.`nerc_cip_asset` (`nerc_cip_asset_id`);

ALTER TABLE `outage`.`outage_flisr_event` DROP CONSTRAINT IF EXISTS `fk_outage_outage_flisr_event_audit_id`;
ALTER TABLE `outage`.`outage_flisr_event` ADD CONSTRAINT `fk_outage_outage_flisr_event_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `outage`.`safety_clearance` DROP CONSTRAINT IF EXISTS `fk_outage_safety_clearance_compliance_sox_control_id`;
ALTER TABLE `outage`.`safety_clearance` ADD CONSTRAINT `fk_outage_safety_clearance_compliance_sox_control_id` FOREIGN KEY (`compliance_sox_control_id`) REFERENCES `compliance`.`sox_control` (`sox_control_id`);

ALTER TABLE `outage`.`puc_outage_report` DROP CONSTRAINT IF EXISTS `fk_outage_puc_outage_report_regulatory_filing_id`;
ALTER TABLE `outage`.`puc_outage_report` ADD CONSTRAINT `fk_outage_puc_outage_report_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `outage`.`damage_assessment` DROP CONSTRAINT IF EXISTS `fk_outage_damage_assessment_compliance_environmental_permit_id`;
ALTER TABLE `outage`.`damage_assessment` ADD CONSTRAINT `fk_outage_damage_assessment_compliance_environmental_permit_id` FOREIGN KEY (`compliance_environmental_permit_id`) REFERENCES `compliance`.`environmental_permit` (`environmental_permit_id`);

-- ========= outage --> customer (7) =========
ALTER TABLE `outage`.`interruption` DROP CONSTRAINT IF EXISTS `fk_outage_interruption_account_id`;
ALTER TABLE `outage`.`interruption` ADD CONSTRAINT `fk_outage_interruption_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `outage`.`planned_outage_window` DROP CONSTRAINT IF EXISTS `fk_outage_planned_outage_window_premise_id`;
ALTER TABLE `outage`.`planned_outage_window` ADD CONSTRAINT `fk_outage_planned_outage_window_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `outage`.`affected_customer` DROP CONSTRAINT IF EXISTS `fk_outage_affected_customer_customer_account_id`;
ALTER TABLE `outage`.`affected_customer` ADD CONSTRAINT `fk_outage_affected_customer_customer_account_id` FOREIGN KEY (`customer_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `outage`.`customer_notification` DROP CONSTRAINT IF EXISTS `fk_outage_customer_notification_account_id`;
ALTER TABLE `outage`.`customer_notification` ADD CONSTRAINT `fk_outage_customer_notification_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `outage`.`customer_notification` DROP CONSTRAINT IF EXISTS `fk_outage_customer_notification_customer_preference_id`;
ALTER TABLE `outage`.`customer_notification` ADD CONSTRAINT `fk_outage_customer_notification_customer_preference_id` FOREIGN KEY (`customer_preference_id`) REFERENCES `customer`.`notification_preference` (`notification_preference_id`);

ALTER TABLE `outage`.`call` DROP CONSTRAINT IF EXISTS `fk_outage_call_account_id`;
ALTER TABLE `outage`.`call` ADD CONSTRAINT `fk_outage_call_account_id` FOREIGN KEY (`account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `outage`.`call` DROP CONSTRAINT IF EXISTS `fk_outage_call_premise_id`;
ALTER TABLE `outage`.`call` ADD CONSTRAINT `fk_outage_call_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

-- ========= outage --> distribution (39) =========
ALTER TABLE `outage`.`event` DROP CONSTRAINT IF EXISTS `fk_outage_event_distribution_substation_id`;
ALTER TABLE `outage`.`event` ADD CONSTRAINT `fk_outage_event_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `outage`.`event` DROP CONSTRAINT IF EXISTS `fk_outage_event_feeder_id`;
ALTER TABLE `outage`.`event` ADD CONSTRAINT `fk_outage_event_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `outage`.`event` DROP CONSTRAINT IF EXISTS `fk_outage_event_isolation_device_id`;
ALTER TABLE `outage`.`event` ADD CONSTRAINT `fk_outage_event_isolation_device_id` FOREIGN KEY (`isolation_device_id`) REFERENCES `distribution`.`sectionalizing_device` (`sectionalizing_device_id`);

ALTER TABLE `outage`.`event` DROP CONSTRAINT IF EXISTS `fk_outage_event_service_territory_id`;
ALTER TABLE `outage`.`event` ADD CONSTRAINT `fk_outage_event_service_territory_id` FOREIGN KEY (`service_territory_id`) REFERENCES `distribution`.`service_territory` (`service_territory_id`);

ALTER TABLE `outage`.`interruption` DROP CONSTRAINT IF EXISTS `fk_outage_interruption_distribution_substation_id`;
ALTER TABLE `outage`.`interruption` ADD CONSTRAINT `fk_outage_interruption_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `outage`.`interruption` DROP CONSTRAINT IF EXISTS `fk_outage_interruption_feeder_id`;
ALTER TABLE `outage`.`interruption` ADD CONSTRAINT `fk_outage_interruption_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `outage`.`outage_switching_order` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_order_affected_feeder_id`;
ALTER TABLE `outage`.`outage_switching_order` ADD CONSTRAINT `fk_outage_outage_switching_order_affected_feeder_id` FOREIGN KEY (`affected_feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `outage`.`outage_switching_order` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_order_distribution_substation_id`;
ALTER TABLE `outage`.`outage_switching_order` ADD CONSTRAINT `fk_outage_outage_switching_order_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `outage`.`outage_switching_step` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_step_device_id`;
ALTER TABLE `outage`.`outage_switching_step` ADD CONSTRAINT `fk_outage_outage_switching_step_device_id` FOREIGN KEY (`device_id`) REFERENCES `distribution`.`sectionalizing_device` (`sectionalizing_device_id`);

ALTER TABLE `outage`.`outage_switching_step` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_step_distribution_substation_id`;
ALTER TABLE `outage`.`outage_switching_step` ADD CONSTRAINT `fk_outage_outage_switching_step_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `outage`.`outage_switching_step` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_step_feeder_id`;
ALTER TABLE `outage`.`outage_switching_step` ADD CONSTRAINT `fk_outage_outage_switching_step_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `outage`.`restoration_action` DROP CONSTRAINT IF EXISTS `fk_outage_restoration_action_distribution_substation_id`;
ALTER TABLE `outage`.`restoration_action` ADD CONSTRAINT `fk_outage_restoration_action_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `outage`.`restoration_action` DROP CONSTRAINT IF EXISTS `fk_outage_restoration_action_feeder_id`;
ALTER TABLE `outage`.`restoration_action` ADD CONSTRAINT `fk_outage_restoration_action_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `outage`.`restoration_action` DROP CONSTRAINT IF EXISTS `fk_outage_restoration_action_primary_restoration_network_segment_id`;
ALTER TABLE `outage`.`restoration_action` ADD CONSTRAINT `fk_outage_restoration_action_primary_restoration_network_segment_id` FOREIGN KEY (`primary_restoration_network_segment_id`) REFERENCES `distribution`.`network_segment` (`network_segment_id`);

ALTER TABLE `outage`.`restoration_action` DROP CONSTRAINT IF EXISTS `fk_outage_restoration_action_sectionalizing_device_id`;
ALTER TABLE `outage`.`restoration_action` ADD CONSTRAINT `fk_outage_restoration_action_sectionalizing_device_id` FOREIGN KEY (`sectionalizing_device_id`) REFERENCES `distribution`.`sectionalizing_device` (`sectionalizing_device_id`);

ALTER TABLE `outage`.`planned_outage_window` DROP CONSTRAINT IF EXISTS `fk_outage_planned_outage_window_distribution_substation_id`;
ALTER TABLE `outage`.`planned_outage_window` ADD CONSTRAINT `fk_outage_planned_outage_window_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `outage`.`planned_outage_window` DROP CONSTRAINT IF EXISTS `fk_outage_planned_outage_window_feeder_id`;
ALTER TABLE `outage`.`planned_outage_window` ADD CONSTRAINT `fk_outage_planned_outage_window_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `outage`.`affected_customer` DROP CONSTRAINT IF EXISTS `fk_outage_affected_customer_distribution_substation_id`;
ALTER TABLE `outage`.`affected_customer` ADD CONSTRAINT `fk_outage_affected_customer_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `outage`.`affected_customer` DROP CONSTRAINT IF EXISTS `fk_outage_affected_customer_feeder_id`;
ALTER TABLE `outage`.`affected_customer` ADD CONSTRAINT `fk_outage_affected_customer_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `outage`.`storm_event` DROP CONSTRAINT IF EXISTS `fk_outage_storm_event_service_territory_id`;
ALTER TABLE `outage`.`storm_event` ADD CONSTRAINT `fk_outage_storm_event_service_territory_id` FOREIGN KEY (`service_territory_id`) REFERENCES `distribution`.`service_territory` (`service_territory_id`);

ALTER TABLE `outage`.`prediction` DROP CONSTRAINT IF EXISTS `fk_outage_prediction_circuit_feeder_id`;
ALTER TABLE `outage`.`prediction` ADD CONSTRAINT `fk_outage_prediction_circuit_feeder_id` FOREIGN KEY (`circuit_feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `outage`.`prediction` DROP CONSTRAINT IF EXISTS `fk_outage_prediction_distribution_substation_id`;
ALTER TABLE `outage`.`prediction` ADD CONSTRAINT `fk_outage_prediction_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `outage`.`prediction` DROP CONSTRAINT IF EXISTS `fk_outage_prediction_feeder_id`;
ALTER TABLE `outage`.`prediction` ADD CONSTRAINT `fk_outage_prediction_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `outage`.`prediction` DROP CONSTRAINT IF EXISTS `fk_outage_prediction_service_territory_id`;
ALTER TABLE `outage`.`prediction` ADD CONSTRAINT `fk_outage_prediction_service_territory_id` FOREIGN KEY (`service_territory_id`) REFERENCES `distribution`.`service_territory` (`service_territory_id`);

ALTER TABLE `outage`.`etr_revision` DROP CONSTRAINT IF EXISTS `fk_outage_etr_revision_affected_feeder_id`;
ALTER TABLE `outage`.`etr_revision` ADD CONSTRAINT `fk_outage_etr_revision_affected_feeder_id` FOREIGN KEY (`affected_feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `outage`.`call` DROP CONSTRAINT IF EXISTS `fk_outage_call_distribution_substation_id`;
ALTER TABLE `outage`.`call` ADD CONSTRAINT `fk_outage_call_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `outage`.`call` DROP CONSTRAINT IF EXISTS `fk_outage_call_feeder_id`;
ALTER TABLE `outage`.`call` ADD CONSTRAINT `fk_outage_call_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `outage`.`segment_impact` DROP CONSTRAINT IF EXISTS `fk_outage_segment_impact_distribution_substation_id`;
ALTER TABLE `outage`.`segment_impact` ADD CONSTRAINT `fk_outage_segment_impact_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `outage`.`segment_impact` DROP CONSTRAINT IF EXISTS `fk_outage_segment_impact_feeder_id`;
ALTER TABLE `outage`.`segment_impact` ADD CONSTRAINT `fk_outage_segment_impact_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `outage`.`segment_impact` DROP CONSTRAINT IF EXISTS `fk_outage_segment_impact_network_segment_id`;
ALTER TABLE `outage`.`segment_impact` ADD CONSTRAINT `fk_outage_segment_impact_network_segment_id` FOREIGN KEY (`network_segment_id`) REFERENCES `distribution`.`network_segment` (`network_segment_id`);

ALTER TABLE `outage`.`segment_impact` DROP CONSTRAINT IF EXISTS `fk_outage_segment_impact_sectionalizing_device_id`;
ALTER TABLE `outage`.`segment_impact` ADD CONSTRAINT `fk_outage_segment_impact_sectionalizing_device_id` FOREIGN KEY (`sectionalizing_device_id`) REFERENCES `distribution`.`sectionalizing_device` (`sectionalizing_device_id`);

ALTER TABLE `outage`.`outage_flisr_event` DROP CONSTRAINT IF EXISTS `fk_outage_outage_flisr_event_distribution_substation_id`;
ALTER TABLE `outage`.`outage_flisr_event` ADD CONSTRAINT `fk_outage_outage_flisr_event_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `outage`.`outage_flisr_event` DROP CONSTRAINT IF EXISTS `fk_outage_outage_flisr_event_network_segment_id`;
ALTER TABLE `outage`.`outage_flisr_event` ADD CONSTRAINT `fk_outage_outage_flisr_event_network_segment_id` FOREIGN KEY (`network_segment_id`) REFERENCES `distribution`.`network_segment` (`network_segment_id`);

ALTER TABLE `outage`.`outage_flisr_event` DROP CONSTRAINT IF EXISTS `fk_outage_outage_flisr_event_primary_outage_feeder_id`;
ALTER TABLE `outage`.`outage_flisr_event` ADD CONSTRAINT `fk_outage_outage_flisr_event_primary_outage_feeder_id` FOREIGN KEY (`primary_outage_feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `outage`.`outage_flisr_event` DROP CONSTRAINT IF EXISTS `fk_outage_outage_flisr_event_sectionalizing_device_id`;
ALTER TABLE `outage`.`outage_flisr_event` ADD CONSTRAINT `fk_outage_outage_flisr_event_sectionalizing_device_id` FOREIGN KEY (`sectionalizing_device_id`) REFERENCES `distribution`.`sectionalizing_device` (`sectionalizing_device_id`);

ALTER TABLE `outage`.`safety_clearance` DROP CONSTRAINT IF EXISTS `fk_outage_safety_clearance_distribution_substation_id`;
ALTER TABLE `outage`.`safety_clearance` ADD CONSTRAINT `fk_outage_safety_clearance_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `outage`.`safety_clearance` DROP CONSTRAINT IF EXISTS `fk_outage_safety_clearance_feeder_id`;
ALTER TABLE `outage`.`safety_clearance` ADD CONSTRAINT `fk_outage_safety_clearance_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `outage`.`damage_assessment` DROP CONSTRAINT IF EXISTS `fk_outage_damage_assessment_distribution_substation_id`;
ALTER TABLE `outage`.`damage_assessment` ADD CONSTRAINT `fk_outage_damage_assessment_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `outage`.`damage_assessment` DROP CONSTRAINT IF EXISTS `fk_outage_damage_assessment_feeder_id`;
ALTER TABLE `outage`.`damage_assessment` ADD CONSTRAINT `fk_outage_damage_assessment_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

-- ========= outage --> finance (7) =========
ALTER TABLE `outage`.`event` DROP CONSTRAINT IF EXISTS `fk_outage_event_cost_center_id`;
ALTER TABLE `outage`.`event` ADD CONSTRAINT `fk_outage_event_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `outage`.`event` DROP CONSTRAINT IF EXISTS `fk_outage_event_internal_order_id`;
ALTER TABLE `outage`.`event` ADD CONSTRAINT `fk_outage_event_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `finance`.`internal_order` (`internal_order_id`);

ALTER TABLE `outage`.`outage_crew_dispatch` DROP CONSTRAINT IF EXISTS `fk_outage_outage_crew_dispatch_cost_center_id`;
ALTER TABLE `outage`.`outage_crew_dispatch` ADD CONSTRAINT `fk_outage_outage_crew_dispatch_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `outage`.`restoration_action` DROP CONSTRAINT IF EXISTS `fk_outage_restoration_action_cost_center_id`;
ALTER TABLE `outage`.`restoration_action` ADD CONSTRAINT `fk_outage_restoration_action_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `outage`.`storm_event` DROP CONSTRAINT IF EXISTS `fk_outage_storm_event_cost_center_id`;
ALTER TABLE `outage`.`storm_event` ADD CONSTRAINT `fk_outage_storm_event_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `outage`.`mutual_aid_request` DROP CONSTRAINT IF EXISTS `fk_outage_mutual_aid_request_cost_center_id`;
ALTER TABLE `outage`.`mutual_aid_request` ADD CONSTRAINT `fk_outage_mutual_aid_request_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `outage`.`damage_assessment` DROP CONSTRAINT IF EXISTS `fk_outage_damage_assessment_cost_center_id`;
ALTER TABLE `outage`.`damage_assessment` ADD CONSTRAINT `fk_outage_damage_assessment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

-- ========= outage --> forecast (6) =========
ALTER TABLE `outage`.`event` DROP CONSTRAINT IF EXISTS `fk_outage_event_forecast_zone_id`;
ALTER TABLE `outage`.`event` ADD CONSTRAINT `fk_outage_event_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `outage`.`outage_crew_dispatch` DROP CONSTRAINT IF EXISTS `fk_outage_outage_crew_dispatch_forecast_zone_id`;
ALTER TABLE `outage`.`outage_crew_dispatch` ADD CONSTRAINT `fk_outage_outage_crew_dispatch_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `outage`.`storm_event` DROP CONSTRAINT IF EXISTS `fk_outage_storm_event_forecast_zone_id`;
ALTER TABLE `outage`.`storm_event` ADD CONSTRAINT `fk_outage_storm_event_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `outage`.`prediction` DROP CONSTRAINT IF EXISTS `fk_outage_prediction_load_id`;
ALTER TABLE `outage`.`prediction` ADD CONSTRAINT `fk_outage_prediction_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `outage`.`prediction` DROP CONSTRAINT IF EXISTS `fk_outage_prediction_predictive_model_id`;
ALTER TABLE `outage`.`prediction` ADD CONSTRAINT `fk_outage_prediction_predictive_model_id` FOREIGN KEY (`predictive_model_id`) REFERENCES `forecast`.`model` (`model_id`);

ALTER TABLE `outage`.`prediction` DROP CONSTRAINT IF EXISTS `fk_outage_prediction_weather_input_id`;
ALTER TABLE `outage`.`prediction` ADD CONSTRAINT `fk_outage_prediction_weather_input_id` FOREIGN KEY (`weather_input_id`) REFERENCES `forecast`.`weather_input` (`weather_input_id`);

-- ========= outage --> gis (8) =========
ALTER TABLE `outage`.`event` DROP CONSTRAINT IF EXISTS `fk_outage_event_gis_location_id`;
ALTER TABLE `outage`.`event` ADD CONSTRAINT `fk_outage_event_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `outage`.`interruption` DROP CONSTRAINT IF EXISTS `fk_outage_interruption_gis_location_id`;
ALTER TABLE `outage`.`interruption` ADD CONSTRAINT `fk_outage_interruption_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `outage`.`outage_crew_dispatch` DROP CONSTRAINT IF EXISTS `fk_outage_outage_crew_dispatch_gis_location_id`;
ALTER TABLE `outage`.`outage_crew_dispatch` ADD CONSTRAINT `fk_outage_outage_crew_dispatch_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `outage`.`storm_event` DROP CONSTRAINT IF EXISTS `fk_outage_storm_event_gis_location_id`;
ALTER TABLE `outage`.`storm_event` ADD CONSTRAINT `fk_outage_storm_event_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `outage`.`prediction` DROP CONSTRAINT IF EXISTS `fk_outage_prediction_gis_location_id`;
ALTER TABLE `outage`.`prediction` ADD CONSTRAINT `fk_outage_prediction_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `outage`.`call` DROP CONSTRAINT IF EXISTS `fk_outage_call_gis_location_id`;
ALTER TABLE `outage`.`call` ADD CONSTRAINT `fk_outage_call_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `outage`.`segment_impact` DROP CONSTRAINT IF EXISTS `fk_outage_segment_impact_gis_location_id`;
ALTER TABLE `outage`.`segment_impact` ADD CONSTRAINT `fk_outage_segment_impact_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `outage`.`damage_assessment` DROP CONSTRAINT IF EXISTS `fk_outage_damage_assessment_gis_location_id`;
ALTER TABLE `outage`.`damage_assessment` ADD CONSTRAINT `fk_outage_damage_assessment_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

-- ========= outage --> grid (12) =========
ALTER TABLE `outage`.`event` DROP CONSTRAINT IF EXISTS `fk_outage_event_contingency_id`;
ALTER TABLE `outage`.`event` ADD CONSTRAINT `fk_outage_event_contingency_id` FOREIGN KEY (`contingency_id`) REFERENCES `grid`.`contingency` (`contingency_id`);

ALTER TABLE `outage`.`event` DROP CONSTRAINT IF EXISTS `fk_outage_event_control_area_id`;
ALTER TABLE `outage`.`event` ADD CONSTRAINT `fk_outage_event_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `outage`.`event` DROP CONSTRAINT IF EXISTS `fk_outage_event_grid_switching_order_id`;
ALTER TABLE `outage`.`event` ADD CONSTRAINT `fk_outage_event_grid_switching_order_id` FOREIGN KEY (`grid_switching_order_id`) REFERENCES `grid`.`grid_switching_order` (`grid_switching_order_id`);

ALTER TABLE `outage`.`outage_switching_order` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_order_control_area_id`;
ALTER TABLE `outage`.`outage_switching_order` ADD CONSTRAINT `fk_outage_outage_switching_order_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `outage`.`outage_switching_order` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_order_grid_switching_order_id`;
ALTER TABLE `outage`.`outage_switching_order` ADD CONSTRAINT `fk_outage_outage_switching_order_grid_switching_order_id` FOREIGN KEY (`grid_switching_order_id`) REFERENCES `grid`.`grid_switching_order` (`grid_switching_order_id`);

ALTER TABLE `outage`.`outage_switching_step` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_step_scada_point_id`;
ALTER TABLE `outage`.`outage_switching_step` ADD CONSTRAINT `fk_outage_outage_switching_step_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `outage`.`outage_crew_dispatch` DROP CONSTRAINT IF EXISTS `fk_outage_outage_crew_dispatch_control_area_id`;
ALTER TABLE `outage`.`outage_crew_dispatch` ADD CONSTRAINT `fk_outage_outage_crew_dispatch_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `outage`.`outage_crew_dispatch` DROP CONSTRAINT IF EXISTS `fk_outage_outage_crew_dispatch_grid_switching_order_id`;
ALTER TABLE `outage`.`outage_crew_dispatch` ADD CONSTRAINT `fk_outage_outage_crew_dispatch_grid_switching_order_id` FOREIGN KEY (`grid_switching_order_id`) REFERENCES `grid`.`grid_switching_order` (`grid_switching_order_id`);

ALTER TABLE `outage`.`restoration_action` DROP CONSTRAINT IF EXISTS `fk_outage_restoration_action_control_area_id`;
ALTER TABLE `outage`.`restoration_action` ADD CONSTRAINT `fk_outage_restoration_action_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `outage`.`restoration_action` DROP CONSTRAINT IF EXISTS `fk_outage_restoration_action_scada_point_id`;
ALTER TABLE `outage`.`restoration_action` ADD CONSTRAINT `fk_outage_restoration_action_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `outage`.`prediction` DROP CONSTRAINT IF EXISTS `fk_outage_prediction_scada_alarm_id`;
ALTER TABLE `outage`.`prediction` ADD CONSTRAINT `fk_outage_prediction_scada_alarm_id` FOREIGN KEY (`scada_alarm_id`) REFERENCES `grid`.`ems_alarm` (`ems_alarm_id`);

ALTER TABLE `outage`.`safety_clearance` DROP CONSTRAINT IF EXISTS `fk_outage_safety_clearance_grid_switching_order_id`;
ALTER TABLE `outage`.`safety_clearance` ADD CONSTRAINT `fk_outage_safety_clearance_grid_switching_order_id` FOREIGN KEY (`grid_switching_order_id`) REFERENCES `grid`.`grid_switching_order` (`grid_switching_order_id`);

-- ========= outage --> interconnection (7) =========
ALTER TABLE `outage`.`event` DROP CONSTRAINT IF EXISTS `fk_outage_event_der_system_id`;
ALTER TABLE `outage`.`event` ADD CONSTRAINT `fk_outage_event_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `outage`.`outage_switching_order` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_order_der_system_id`;
ALTER TABLE `outage`.`outage_switching_order` ADD CONSTRAINT `fk_outage_outage_switching_order_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `outage`.`restoration_action` DROP CONSTRAINT IF EXISTS `fk_outage_restoration_action_der_system_id`;
ALTER TABLE `outage`.`restoration_action` ADD CONSTRAINT `fk_outage_restoration_action_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `outage`.`planned_outage_window` DROP CONSTRAINT IF EXISTS `fk_outage_planned_outage_window_interconnection_application_id`;
ALTER TABLE `outage`.`planned_outage_window` ADD CONSTRAINT `fk_outage_planned_outage_window_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `outage`.`affected_customer` DROP CONSTRAINT IF EXISTS `fk_outage_affected_customer_der_system_id`;
ALTER TABLE `outage`.`affected_customer` ADD CONSTRAINT `fk_outage_affected_customer_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `outage`.`segment_impact` DROP CONSTRAINT IF EXISTS `fk_outage_segment_impact_der_system_id`;
ALTER TABLE `outage`.`segment_impact` ADD CONSTRAINT `fk_outage_segment_impact_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `outage`.`storm_der_impact` DROP CONSTRAINT IF EXISTS `fk_outage_storm_der_impact_der_system_id`;
ALTER TABLE `outage`.`storm_der_impact` ADD CONSTRAINT `fk_outage_storm_der_impact_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

-- ========= outage --> metering (6) =========
ALTER TABLE `outage`.`interruption` DROP CONSTRAINT IF EXISTS `fk_outage_interruption_ami_meter_id`;
ALTER TABLE `outage`.`interruption` ADD CONSTRAINT `fk_outage_interruption_ami_meter_id` FOREIGN KEY (`ami_meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `outage`.`interruption` DROP CONSTRAINT IF EXISTS `fk_outage_interruption_service_point_id`;
ALTER TABLE `outage`.`interruption` ADD CONSTRAINT `fk_outage_interruption_service_point_id` FOREIGN KEY (`service_point_id`) REFERENCES `metering`.`service_point` (`service_point_id`);

ALTER TABLE `outage`.`affected_customer` DROP CONSTRAINT IF EXISTS `fk_outage_affected_customer_meter_id`;
ALTER TABLE `outage`.`affected_customer` ADD CONSTRAINT `fk_outage_affected_customer_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `outage`.`affected_customer` DROP CONSTRAINT IF EXISTS `fk_outage_affected_customer_service_point_id`;
ALTER TABLE `outage`.`affected_customer` ADD CONSTRAINT `fk_outage_affected_customer_service_point_id` FOREIGN KEY (`service_point_id`) REFERENCES `metering`.`service_point` (`service_point_id`);

ALTER TABLE `outage`.`customer_notification` DROP CONSTRAINT IF EXISTS `fk_outage_customer_notification_service_point_id`;
ALTER TABLE `outage`.`customer_notification` ADD CONSTRAINT `fk_outage_customer_notification_service_point_id` FOREIGN KEY (`service_point_id`) REFERENCES `metering`.`service_point` (`service_point_id`);

ALTER TABLE `outage`.`call` DROP CONSTRAINT IF EXISTS `fk_outage_call_meter_id`;
ALTER TABLE `outage`.`call` ADD CONSTRAINT `fk_outage_call_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

-- ========= outage --> supply (1) =========
ALTER TABLE `outage`.`damage_assessment` DROP CONSTRAINT IF EXISTS `fk_outage_damage_assessment_material_master_id`;
ALTER TABLE `outage`.`damage_assessment` ADD CONSTRAINT `fk_outage_damage_assessment_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

-- ========= outage --> transmission (1) =========
ALTER TABLE `outage`.`outage_switching_step` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_step_protection_device_id`;
ALTER TABLE `outage`.`outage_switching_step` ADD CONSTRAINT `fk_outage_outage_switching_step_protection_device_id` FOREIGN KEY (`protection_device_id`) REFERENCES `transmission`.`protection_device` (`protection_device_id`);

-- ========= outage --> workforce (18) =========
ALTER TABLE `outage`.`outage_switching_order` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_order_approver_employee_id`;
ALTER TABLE `outage`.`outage_switching_order` ADD CONSTRAINT `fk_outage_outage_switching_order_approver_employee_id` FOREIGN KEY (`approver_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `outage`.`outage_switching_order` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_order_crew_id`;
ALTER TABLE `outage`.`outage_switching_order` ADD CONSTRAINT `fk_outage_outage_switching_order_crew_id` FOREIGN KEY (`crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `outage`.`outage_switching_order` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_order_primary_outage_employee_id`;
ALTER TABLE `outage`.`outage_switching_order` ADD CONSTRAINT `fk_outage_outage_switching_order_primary_outage_employee_id` FOREIGN KEY (`primary_outage_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `outage`.`outage_switching_step` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_step_crew_id`;
ALTER TABLE `outage`.`outage_switching_step` ADD CONSTRAINT `fk_outage_outage_switching_step_crew_id` FOREIGN KEY (`crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `outage`.`outage_switching_step` DROP CONSTRAINT IF EXISTS `fk_outage_outage_switching_step_primary_outage_employee_id`;
ALTER TABLE `outage`.`outage_switching_step` ADD CONSTRAINT `fk_outage_outage_switching_step_primary_outage_employee_id` FOREIGN KEY (`primary_outage_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `outage`.`outage_crew_dispatch` DROP CONSTRAINT IF EXISTS `fk_outage_outage_crew_dispatch_crew_id`;
ALTER TABLE `outage`.`outage_crew_dispatch` ADD CONSTRAINT `fk_outage_outage_crew_dispatch_crew_id` FOREIGN KEY (`crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `outage`.`restoration_action` DROP CONSTRAINT IF EXISTS `fk_outage_restoration_action_crew_id`;
ALTER TABLE `outage`.`restoration_action` ADD CONSTRAINT `fk_outage_restoration_action_crew_id` FOREIGN KEY (`crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `outage`.`event_status_history` DROP CONSTRAINT IF EXISTS `fk_outage_event_status_history_crew_id`;
ALTER TABLE `outage`.`event_status_history` ADD CONSTRAINT `fk_outage_event_status_history_crew_id` FOREIGN KEY (`crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `outage`.`event_status_history` DROP CONSTRAINT IF EXISTS `fk_outage_event_status_history_employee_id`;
ALTER TABLE `outage`.`event_status_history` ADD CONSTRAINT `fk_outage_event_status_history_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `outage`.`prediction` DROP CONSTRAINT IF EXISTS `fk_outage_prediction_employee_id`;
ALTER TABLE `outage`.`prediction` ADD CONSTRAINT `fk_outage_prediction_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `outage`.`etr_revision` DROP CONSTRAINT IF EXISTS `fk_outage_etr_revision_employee_id`;
ALTER TABLE `outage`.`etr_revision` ADD CONSTRAINT `fk_outage_etr_revision_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `outage`.`call` DROP CONSTRAINT IF EXISTS `fk_outage_call_employee_id`;
ALTER TABLE `outage`.`call` ADD CONSTRAINT `fk_outage_call_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `outage`.`safety_clearance` DROP CONSTRAINT IF EXISTS `fk_outage_safety_clearance_approver_employee_id`;
ALTER TABLE `outage`.`safety_clearance` ADD CONSTRAINT `fk_outage_safety_clearance_approver_employee_id` FOREIGN KEY (`approver_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `outage`.`safety_clearance` DROP CONSTRAINT IF EXISTS `fk_outage_safety_clearance_primary_safety_employee_id`;
ALTER TABLE `outage`.`safety_clearance` ADD CONSTRAINT `fk_outage_safety_clearance_primary_safety_employee_id` FOREIGN KEY (`primary_safety_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `outage`.`safety_clearance` DROP CONSTRAINT IF EXISTS `fk_outage_safety_clearance_tertiary_safety_release_authorized_by_employee_id`;
ALTER TABLE `outage`.`safety_clearance` ADD CONSTRAINT `fk_outage_safety_clearance_tertiary_safety_release_authorized_by_employee_id` FOREIGN KEY (`tertiary_safety_release_authorized_by_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `outage`.`damage_assessment` DROP CONSTRAINT IF EXISTS `fk_outage_damage_assessment_crew_id`;
ALTER TABLE `outage`.`damage_assessment` ADD CONSTRAINT `fk_outage_damage_assessment_crew_id` FOREIGN KEY (`crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `outage`.`damage_assessment` DROP CONSTRAINT IF EXISTS `fk_outage_damage_assessment_primary_damage_assessor_employee_id`;
ALTER TABLE `outage`.`damage_assessment` ADD CONSTRAINT `fk_outage_damage_assessment_primary_damage_assessor_employee_id` FOREIGN KEY (`primary_damage_assessor_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `outage`.`storm_der_impact` DROP CONSTRAINT IF EXISTS `fk_outage_storm_der_impact_employee_id`;
ALTER TABLE `outage`.`storm_der_impact` ADD CONSTRAINT `fk_outage_storm_der_impact_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

-- ========= renewable --> asset (14) =========
ALTER TABLE `renewable`.`renewable_rec_certificate` DROP CONSTRAINT IF EXISTS `fk_renewable_renewable_rec_certificate_registry_id`;
ALTER TABLE `renewable`.`renewable_rec_certificate` ADD CONSTRAINT `fk_renewable_renewable_rec_certificate_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `renewable`.`ppa_settlement` DROP CONSTRAINT IF EXISTS `fk_renewable_ppa_settlement_registry_id`;
ALTER TABLE `renewable`.`ppa_settlement` ADD CONSTRAINT `fk_renewable_ppa_settlement_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `renewable`.`curtailment_event` DROP CONSTRAINT IF EXISTS `fk_renewable_curtailment_event_registry_id`;
ALTER TABLE `renewable`.`curtailment_event` ADD CONSTRAINT `fk_renewable_curtailment_event_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `renewable`.`nem_account` DROP CONSTRAINT IF EXISTS `fk_renewable_nem_account_interconnection_asset_registry_id`;
ALTER TABLE `renewable`.`nem_account` ADD CONSTRAINT `fk_renewable_nem_account_interconnection_asset_registry_id` FOREIGN KEY (`interconnection_asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `renewable`.`interconnection_queue` DROP CONSTRAINT IF EXISTS `fk_renewable_interconnection_queue_network_upgrade_asset_registry_id`;
ALTER TABLE `renewable`.`interconnection_queue` ADD CONSTRAINT `fk_renewable_interconnection_queue_network_upgrade_asset_registry_id` FOREIGN KEY (`network_upgrade_asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `renewable`.`battery_storage_asset` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_storage_asset_asset_risk_assessment_id`;
ALTER TABLE `renewable`.`battery_storage_asset` ADD CONSTRAINT `fk_renewable_battery_storage_asset_asset_risk_assessment_id` FOREIGN KEY (`asset_risk_assessment_id`) REFERENCES `asset`.`asset_risk_assessment` (`asset_risk_assessment_id`);

ALTER TABLE `renewable`.`battery_storage_asset` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_storage_asset_depreciation_schedule_id`;
ALTER TABLE `renewable`.`battery_storage_asset` ADD CONSTRAINT `fk_renewable_battery_storage_asset_depreciation_schedule_id` FOREIGN KEY (`depreciation_schedule_id`) REFERENCES `asset`.`depreciation_schedule` (`depreciation_schedule_id`);

ALTER TABLE `renewable`.`battery_storage_asset` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_storage_asset_failure_event_id`;
ALTER TABLE `renewable`.`battery_storage_asset` ADD CONSTRAINT `fk_renewable_battery_storage_asset_failure_event_id` FOREIGN KEY (`failure_event_id`) REFERENCES `asset`.`failure_event` (`failure_event_id`);

ALTER TABLE `renewable`.`battery_storage_asset` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_storage_asset_inspection_id`;
ALTER TABLE `renewable`.`battery_storage_asset` ADD CONSTRAINT `fk_renewable_battery_storage_asset_inspection_id` FOREIGN KEY (`inspection_id`) REFERENCES `asset`.`inspection` (`inspection_id`);

ALTER TABLE `renewable`.`battery_storage_asset` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_storage_asset_maintenance_plan_id`;
ALTER TABLE `renewable`.`battery_storage_asset` ADD CONSTRAINT `fk_renewable_battery_storage_asset_maintenance_plan_id` FOREIGN KEY (`maintenance_plan_id`) REFERENCES `asset`.`maintenance_plan` (`maintenance_plan_id`);

ALTER TABLE `renewable`.`battery_storage_asset` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_storage_asset_registry_id`;
ALTER TABLE `renewable`.`battery_storage_asset` ADD CONSTRAINT `fk_renewable_battery_storage_asset_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `renewable`.`battery_storage_asset` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_storage_asset_warranty_id`;
ALTER TABLE `renewable`.`battery_storage_asset` ADD CONSTRAINT `fk_renewable_battery_storage_asset_warranty_id` FOREIGN KEY (`warranty_id`) REFERENCES `asset`.`warranty` (`warranty_id`);

ALTER TABLE `renewable`.`battery_storage_asset` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_storage_asset_work_order_id`;
ALTER TABLE `renewable`.`battery_storage_asset` ADD CONSTRAINT `fk_renewable_battery_storage_asset_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `renewable`.`der_service_assignment` DROP CONSTRAINT IF EXISTS `fk_renewable_der_service_assignment_work_order_id`;
ALTER TABLE `renewable`.`der_service_assignment` ADD CONSTRAINT `fk_renewable_der_service_assignment_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

-- ========= renewable --> compliance (14) =========
ALTER TABLE `renewable`.`renewable_rec_certificate` DROP CONSTRAINT IF EXISTS `fk_renewable_renewable_rec_certificate_attestation_document_id`;
ALTER TABLE `renewable`.`renewable_rec_certificate` ADD CONSTRAINT `fk_renewable_renewable_rec_certificate_attestation_document_id` FOREIGN KEY (`attestation_document_id`) REFERENCES `compliance`.`attestation_document` (`attestation_document_id`);

ALTER TABLE `renewable`.`renewable_rec_certificate` DROP CONSTRAINT IF EXISTS `fk_renewable_renewable_rec_certificate_obligation_id`;
ALTER TABLE `renewable`.`renewable_rec_certificate` ADD CONSTRAINT `fk_renewable_renewable_rec_certificate_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `renewable`.`rps_obligation` DROP CONSTRAINT IF EXISTS `fk_renewable_rps_obligation_obligation_id`;
ALTER TABLE `renewable`.`rps_obligation` ADD CONSTRAINT `fk_renewable_rps_obligation_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `renewable`.`ppa_contract` DROP CONSTRAINT IF EXISTS `fk_renewable_ppa_contract_regulatory_filing_id`;
ALTER TABLE `renewable`.`ppa_contract` ADD CONSTRAINT `fk_renewable_ppa_contract_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `renewable`.`curtailment_event` DROP CONSTRAINT IF EXISTS `fk_renewable_curtailment_event_obligation_id`;
ALTER TABLE `renewable`.`curtailment_event` ADD CONSTRAINT `fk_renewable_curtailment_event_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `renewable`.`interconnection_queue` DROP CONSTRAINT IF EXISTS `fk_renewable_interconnection_queue_cpcn_application_id`;
ALTER TABLE `renewable`.`interconnection_queue` ADD CONSTRAINT `fk_renewable_interconnection_queue_cpcn_application_id` FOREIGN KEY (`cpcn_application_id`) REFERENCES `compliance`.`cpcn_application` (`cpcn_application_id`);

ALTER TABLE `renewable`.`vpp_configuration` DROP CONSTRAINT IF EXISTS `fk_renewable_vpp_configuration_derms_program_id`;
ALTER TABLE `renewable`.`vpp_configuration` ADD CONSTRAINT `fk_renewable_vpp_configuration_derms_program_id` FOREIGN KEY (`derms_program_id`) REFERENCES `compliance`.`program` (`program_id`);

ALTER TABLE `renewable`.`vpp_configuration` DROP CONSTRAINT IF EXISTS `fk_renewable_vpp_configuration_obligation_id`;
ALTER TABLE `renewable`.`vpp_configuration` ADD CONSTRAINT `fk_renewable_vpp_configuration_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `renewable`.`battery_storage_asset` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_storage_asset_environmental_permit_id`;
ALTER TABLE `renewable`.`battery_storage_asset` ADD CONSTRAINT `fk_renewable_battery_storage_asset_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `compliance`.`environmental_permit` (`environmental_permit_id`);

ALTER TABLE `renewable`.`battery_storage_asset` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_storage_asset_nerc_cip_asset_id`;
ALTER TABLE `renewable`.`battery_storage_asset` ADD CONSTRAINT `fk_renewable_battery_storage_asset_nerc_cip_asset_id` FOREIGN KEY (`nerc_cip_asset_id`) REFERENCES `compliance`.`nerc_cip_asset` (`nerc_cip_asset_id`);

ALTER TABLE `renewable`.`der_enrollment` DROP CONSTRAINT IF EXISTS `fk_renewable_der_enrollment_obligation_id`;
ALTER TABLE `renewable`.`der_enrollment` ADD CONSTRAINT `fk_renewable_der_enrollment_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `renewable`.`incentive_program` DROP CONSTRAINT IF EXISTS `fk_renewable_incentive_program_regulatory_filing_id`;
ALTER TABLE `renewable`.`incentive_program` ADD CONSTRAINT `fk_renewable_incentive_program_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `renewable`.`incentive_application` DROP CONSTRAINT IF EXISTS `fk_renewable_incentive_application_regulatory_filing_id`;
ALTER TABLE `renewable`.`incentive_application` ADD CONSTRAINT `fk_renewable_incentive_application_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `renewable`.`green_tariff_subscription` DROP CONSTRAINT IF EXISTS `fk_renewable_green_tariff_subscription_obligation_id`;
ALTER TABLE `renewable`.`green_tariff_subscription` ADD CONSTRAINT `fk_renewable_green_tariff_subscription_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

-- ========= renewable --> customer (7) =========
ALTER TABLE `renewable`.`nem_account` DROP CONSTRAINT IF EXISTS `fk_renewable_nem_account_customer_account_id`;
ALTER TABLE `renewable`.`nem_account` ADD CONSTRAINT `fk_renewable_nem_account_customer_account_id` FOREIGN KEY (`customer_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `renewable`.`nem_account` DROP CONSTRAINT IF EXISTS `fk_renewable_nem_account_premise_id`;
ALTER TABLE `renewable`.`nem_account` ADD CONSTRAINT `fk_renewable_nem_account_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `renewable`.`interconnection_queue` DROP CONSTRAINT IF EXISTS `fk_renewable_interconnection_queue_applicant_account_id`;
ALTER TABLE `renewable`.`interconnection_queue` ADD CONSTRAINT `fk_renewable_interconnection_queue_applicant_account_id` FOREIGN KEY (`applicant_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `renewable`.`der_enrollment` DROP CONSTRAINT IF EXISTS `fk_renewable_der_enrollment_customer_account_id`;
ALTER TABLE `renewable`.`der_enrollment` ADD CONSTRAINT `fk_renewable_der_enrollment_customer_account_id` FOREIGN KEY (`customer_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `renewable`.`incentive_application` DROP CONSTRAINT IF EXISTS `fk_renewable_incentive_application_applicant_account_id`;
ALTER TABLE `renewable`.`incentive_application` ADD CONSTRAINT `fk_renewable_incentive_application_applicant_account_id` FOREIGN KEY (`applicant_account_id`) REFERENCES `customer`.`account` (`account_id`);

ALTER TABLE `renewable`.`incentive_application` DROP CONSTRAINT IF EXISTS `fk_renewable_incentive_application_premise_id`;
ALTER TABLE `renewable`.`incentive_application` ADD CONSTRAINT `fk_renewable_incentive_application_premise_id` FOREIGN KEY (`premise_id`) REFERENCES `customer`.`premise` (`premise_id`);

ALTER TABLE `renewable`.`green_tariff_subscription` DROP CONSTRAINT IF EXISTS `fk_renewable_green_tariff_subscription_customer_account_id`;
ALTER TABLE `renewable`.`green_tariff_subscription` ADD CONSTRAINT `fk_renewable_green_tariff_subscription_customer_account_id` FOREIGN KEY (`customer_account_id`) REFERENCES `customer`.`account` (`account_id`);

-- ========= renewable --> demand (4) =========
ALTER TABLE `renewable`.`vpp_configuration` DROP CONSTRAINT IF EXISTS `fk_renewable_vpp_configuration_aggregator_id`;
ALTER TABLE `renewable`.`vpp_configuration` ADD CONSTRAINT `fk_renewable_vpp_configuration_aggregator_id` FOREIGN KEY (`aggregator_id`) REFERENCES `demand`.`aggregator` (`aggregator_id`);

ALTER TABLE `renewable`.`battery_storage_asset` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_storage_asset_dr_program_id`;
ALTER TABLE `renewable`.`battery_storage_asset` ADD CONSTRAINT `fk_renewable_battery_storage_asset_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `renewable`.`der_enrollment` DROP CONSTRAINT IF EXISTS `fk_renewable_der_enrollment_dr_program_id`;
ALTER TABLE `renewable`.`der_enrollment` ADD CONSTRAINT `fk_renewable_der_enrollment_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `renewable`.`der_program_enrollment` DROP CONSTRAINT IF EXISTS `fk_renewable_der_program_enrollment_dr_program_id`;
ALTER TABLE `renewable`.`der_program_enrollment` ADD CONSTRAINT `fk_renewable_der_program_enrollment_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

-- ========= renewable --> distribution (7) =========
ALTER TABLE `renewable`.`der_registry` DROP CONSTRAINT IF EXISTS `fk_renewable_der_registry_distribution_substation_id`;
ALTER TABLE `renewable`.`der_registry` ADD CONSTRAINT `fk_renewable_der_registry_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `renewable`.`der_registry` DROP CONSTRAINT IF EXISTS `fk_renewable_der_registry_feeder_id`;
ALTER TABLE `renewable`.`der_registry` ADD CONSTRAINT `fk_renewable_der_registry_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `renewable`.`curtailment_event` DROP CONSTRAINT IF EXISTS `fk_renewable_curtailment_event_distribution_substation_id`;
ALTER TABLE `renewable`.`curtailment_event` ADD CONSTRAINT `fk_renewable_curtailment_event_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `renewable`.`curtailment_event` DROP CONSTRAINT IF EXISTS `fk_renewable_curtailment_event_feeder_id`;
ALTER TABLE `renewable`.`curtailment_event` ADD CONSTRAINT `fk_renewable_curtailment_event_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `renewable`.`interconnection_queue` DROP CONSTRAINT IF EXISTS `fk_renewable_interconnection_queue_distribution_substation_id`;
ALTER TABLE `renewable`.`interconnection_queue` ADD CONSTRAINT `fk_renewable_interconnection_queue_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `renewable`.`vpp_configuration` DROP CONSTRAINT IF EXISTS `fk_renewable_vpp_configuration_distribution_substation_id`;
ALTER TABLE `renewable`.`vpp_configuration` ADD CONSTRAINT `fk_renewable_vpp_configuration_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `renewable`.`vpp_configuration` DROP CONSTRAINT IF EXISTS `fk_renewable_vpp_configuration_feeder_id`;
ALTER TABLE `renewable`.`vpp_configuration` ADD CONSTRAINT `fk_renewable_vpp_configuration_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

-- ========= renewable --> finance (11) =========
ALTER TABLE `renewable`.`der_registry` DROP CONSTRAINT IF EXISTS `fk_renewable_der_registry_fixed_asset_id`;
ALTER TABLE `renewable`.`der_registry` ADD CONSTRAINT `fk_renewable_der_registry_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `finance`.`fixed_asset` (`fixed_asset_id`);

ALTER TABLE `renewable`.`renewable_rec_certificate` DROP CONSTRAINT IF EXISTS `fk_renewable_renewable_rec_certificate_journal_entry_id`;
ALTER TABLE `renewable`.`renewable_rec_certificate` ADD CONSTRAINT `fk_renewable_renewable_rec_certificate_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `finance`.`journal_entry` (`journal_entry_id`);

ALTER TABLE `renewable`.`rps_obligation` DROP CONSTRAINT IF EXISTS `fk_renewable_rps_obligation_regulatory_asset_id`;
ALTER TABLE `renewable`.`rps_obligation` ADD CONSTRAINT `fk_renewable_rps_obligation_regulatory_asset_id` FOREIGN KEY (`regulatory_asset_id`) REFERENCES `finance`.`regulatory_asset` (`regulatory_asset_id`);

ALTER TABLE `renewable`.`ppa_contract` DROP CONSTRAINT IF EXISTS `fk_renewable_ppa_contract_capex_project_id`;
ALTER TABLE `renewable`.`ppa_contract` ADD CONSTRAINT `fk_renewable_ppa_contract_capex_project_id` FOREIGN KEY (`capex_project_id`) REFERENCES `finance`.`capex_project` (`capex_project_id`);

ALTER TABLE `renewable`.`ppa_settlement` DROP CONSTRAINT IF EXISTS `fk_renewable_ppa_settlement_journal_entry_id`;
ALTER TABLE `renewable`.`ppa_settlement` ADD CONSTRAINT `fk_renewable_ppa_settlement_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `finance`.`journal_entry` (`journal_entry_id`);

ALTER TABLE `renewable`.`curtailment_event` DROP CONSTRAINT IF EXISTS `fk_renewable_curtailment_event_cost_center_id`;
ALTER TABLE `renewable`.`curtailment_event` ADD CONSTRAINT `fk_renewable_curtailment_event_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `renewable`.`interconnection_queue` DROP CONSTRAINT IF EXISTS `fk_renewable_interconnection_queue_capex_project_id`;
ALTER TABLE `renewable`.`interconnection_queue` ADD CONSTRAINT `fk_renewable_interconnection_queue_capex_project_id` FOREIGN KEY (`capex_project_id`) REFERENCES `finance`.`capex_project` (`capex_project_id`);

ALTER TABLE `renewable`.`vpp_configuration` DROP CONSTRAINT IF EXISTS `fk_renewable_vpp_configuration_profit_center_id`;
ALTER TABLE `renewable`.`vpp_configuration` ADD CONSTRAINT `fk_renewable_vpp_configuration_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `renewable`.`battery_storage_asset` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_storage_asset_fixed_asset_id`;
ALTER TABLE `renewable`.`battery_storage_asset` ADD CONSTRAINT `fk_renewable_battery_storage_asset_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `finance`.`fixed_asset` (`fixed_asset_id`);

ALTER TABLE `renewable`.`incentive_application` DROP CONSTRAINT IF EXISTS `fk_renewable_incentive_application_capex_expenditure_id`;
ALTER TABLE `renewable`.`incentive_application` ADD CONSTRAINT `fk_renewable_incentive_application_capex_expenditure_id` FOREIGN KEY (`capex_expenditure_id`) REFERENCES `finance`.`capex_expenditure` (`capex_expenditure_id`);

ALTER TABLE `renewable`.`green_tariff_subscription` DROP CONSTRAINT IF EXISTS `fk_renewable_green_tariff_subscription_receivable_id`;
ALTER TABLE `renewable`.`green_tariff_subscription` ADD CONSTRAINT `fk_renewable_green_tariff_subscription_receivable_id` FOREIGN KEY (`receivable_id`) REFERENCES `finance`.`receivable` (`receivable_id`);

-- ========= renewable --> forecast (9) =========
ALTER TABLE `renewable`.`der_registry` DROP CONSTRAINT IF EXISTS `fk_renewable_der_registry_forecast_zone_id`;
ALTER TABLE `renewable`.`der_registry` ADD CONSTRAINT `fk_renewable_der_registry_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `renewable`.`renewable_rec_certificate` DROP CONSTRAINT IF EXISTS `fk_renewable_renewable_rec_certificate_irp_scenario_id`;
ALTER TABLE `renewable`.`renewable_rec_certificate` ADD CONSTRAINT `fk_renewable_renewable_rec_certificate_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

ALTER TABLE `renewable`.`rps_obligation` DROP CONSTRAINT IF EXISTS `fk_renewable_rps_obligation_irp_scenario_id`;
ALTER TABLE `renewable`.`rps_obligation` ADD CONSTRAINT `fk_renewable_rps_obligation_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

ALTER TABLE `renewable`.`ppa_contract` DROP CONSTRAINT IF EXISTS `fk_renewable_ppa_contract_energy_price_id`;
ALTER TABLE `renewable`.`ppa_contract` ADD CONSTRAINT `fk_renewable_ppa_contract_energy_price_id` FOREIGN KEY (`energy_price_id`) REFERENCES `forecast`.`energy_price` (`energy_price_id`);

ALTER TABLE `renewable`.`ppa_settlement` DROP CONSTRAINT IF EXISTS `fk_renewable_ppa_settlement_energy_price_id`;
ALTER TABLE `renewable`.`ppa_settlement` ADD CONSTRAINT `fk_renewable_ppa_settlement_energy_price_id` FOREIGN KEY (`energy_price_id`) REFERENCES `forecast`.`energy_price` (`energy_price_id`);

ALTER TABLE `renewable`.`curtailment_event` DROP CONSTRAINT IF EXISTS `fk_renewable_curtailment_event_forecast_renewable_id`;
ALTER TABLE `renewable`.`curtailment_event` ADD CONSTRAINT `fk_renewable_curtailment_event_forecast_renewable_id` FOREIGN KEY (`forecast_renewable_id`) REFERENCES `forecast`.`forecast_renewable` (`forecast_renewable_id`);

ALTER TABLE `renewable`.`interconnection_queue` DROP CONSTRAINT IF EXISTS `fk_renewable_interconnection_queue_irp_scenario_id`;
ALTER TABLE `renewable`.`interconnection_queue` ADD CONSTRAINT `fk_renewable_interconnection_queue_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

ALTER TABLE `renewable`.`battery_storage_asset` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_storage_asset_forecast_zone_id`;
ALTER TABLE `renewable`.`battery_storage_asset` ADD CONSTRAINT `fk_renewable_battery_storage_asset_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `renewable`.`generation_meter_read` DROP CONSTRAINT IF EXISTS `fk_renewable_generation_meter_read_validation_forecast_run_id`;
ALTER TABLE `renewable`.`generation_meter_read` ADD CONSTRAINT `fk_renewable_generation_meter_read_validation_forecast_run_id` FOREIGN KEY (`validation_forecast_run_id`) REFERENCES `forecast`.`forecast_run` (`forecast_run_id`);

-- ========= renewable --> generation (7) =========
ALTER TABLE `renewable`.`renewable_rec_certificate` DROP CONSTRAINT IF EXISTS `fk_renewable_renewable_rec_certificate_power_plant_id`;
ALTER TABLE `renewable`.`renewable_rec_certificate` ADD CONSTRAINT `fk_renewable_renewable_rec_certificate_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `renewable`.`ppa_settlement` DROP CONSTRAINT IF EXISTS `fk_renewable_ppa_settlement_power_plant_id`;
ALTER TABLE `renewable`.`ppa_settlement` ADD CONSTRAINT `fk_renewable_ppa_settlement_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `renewable`.`curtailment_event` DROP CONSTRAINT IF EXISTS `fk_renewable_curtailment_event_power_plant_id`;
ALTER TABLE `renewable`.`curtailment_event` ADD CONSTRAINT `fk_renewable_curtailment_event_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `renewable`.`generation_meter_read` DROP CONSTRAINT IF EXISTS `fk_renewable_generation_meter_read_generating_unit_id`;
ALTER TABLE `renewable`.`generation_meter_read` ADD CONSTRAINT `fk_renewable_generation_meter_read_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `renewable`.`generation_meter_read` DROP CONSTRAINT IF EXISTS `fk_renewable_generation_meter_read_power_plant_id`;
ALTER TABLE `renewable`.`generation_meter_read` ADD CONSTRAINT `fk_renewable_generation_meter_read_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `renewable`.`green_tariff_subscription` DROP CONSTRAINT IF EXISTS `fk_renewable_green_tariff_subscription_power_plant_id`;
ALTER TABLE `renewable`.`green_tariff_subscription` ADD CONSTRAINT `fk_renewable_green_tariff_subscription_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `renewable`.`green_tariff_subscription` DROP CONSTRAINT IF EXISTS `fk_renewable_green_tariff_subscription_renewable_facility_power_plant_id`;
ALTER TABLE `renewable`.`green_tariff_subscription` ADD CONSTRAINT `fk_renewable_green_tariff_subscription_renewable_facility_power_plant_id` FOREIGN KEY (`renewable_facility_power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

-- ========= renewable --> gis (2) =========
ALTER TABLE `renewable`.`der_registry` DROP CONSTRAINT IF EXISTS `fk_renewable_der_registry_gis_location_id`;
ALTER TABLE `renewable`.`der_registry` ADD CONSTRAINT `fk_renewable_der_registry_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `renewable`.`battery_storage_asset` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_storage_asset_gis_location_id`;
ALTER TABLE `renewable`.`battery_storage_asset` ADD CONSTRAINT `fk_renewable_battery_storage_asset_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

-- ========= renewable --> grid (9) =========
ALTER TABLE `renewable`.`der_registry` DROP CONSTRAINT IF EXISTS `fk_renewable_der_registry_control_area_id`;
ALTER TABLE `renewable`.`der_registry` ADD CONSTRAINT `fk_renewable_der_registry_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `renewable`.`der_registry` DROP CONSTRAINT IF EXISTS `fk_renewable_der_registry_ems_node_id`;
ALTER TABLE `renewable`.`der_registry` ADD CONSTRAINT `fk_renewable_der_registry_ems_node_id` FOREIGN KEY (`ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `renewable`.`curtailment_event` DROP CONSTRAINT IF EXISTS `fk_renewable_curtailment_event_contingency_id`;
ALTER TABLE `renewable`.`curtailment_event` ADD CONSTRAINT `fk_renewable_curtailment_event_contingency_id` FOREIGN KEY (`contingency_id`) REFERENCES `grid`.`contingency` (`contingency_id`);

ALTER TABLE `renewable`.`curtailment_event` DROP CONSTRAINT IF EXISTS `fk_renewable_curtailment_event_control_area_id`;
ALTER TABLE `renewable`.`curtailment_event` ADD CONSTRAINT `fk_renewable_curtailment_event_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `renewable`.`curtailment_event` DROP CONSTRAINT IF EXISTS `fk_renewable_curtailment_event_dispatch_instruction_id`;
ALTER TABLE `renewable`.`curtailment_event` ADD CONSTRAINT `fk_renewable_curtailment_event_dispatch_instruction_id` FOREIGN KEY (`dispatch_instruction_id`) REFERENCES `grid`.`dispatch_instruction` (`dispatch_instruction_id`);

ALTER TABLE `renewable`.`curtailment_event` DROP CONSTRAINT IF EXISTS `fk_renewable_curtailment_event_scada_point_id`;
ALTER TABLE `renewable`.`curtailment_event` ADD CONSTRAINT `fk_renewable_curtailment_event_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

ALTER TABLE `renewable`.`vpp_configuration` DROP CONSTRAINT IF EXISTS `fk_renewable_vpp_configuration_control_area_id`;
ALTER TABLE `renewable`.`vpp_configuration` ADD CONSTRAINT `fk_renewable_vpp_configuration_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `renewable`.`battery_storage_asset` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_storage_asset_control_area_id`;
ALTER TABLE `renewable`.`battery_storage_asset` ADD CONSTRAINT `fk_renewable_battery_storage_asset_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `renewable`.`battery_storage_asset` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_storage_asset_ems_node_id`;
ALTER TABLE `renewable`.`battery_storage_asset` ADD CONSTRAINT `fk_renewable_battery_storage_asset_ems_node_id` FOREIGN KEY (`ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

-- ========= renewable --> interconnection (2) =========
ALTER TABLE `renewable`.`battery_storage_asset` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_storage_asset_interconnection_application_id`;
ALTER TABLE `renewable`.`battery_storage_asset` ADD CONSTRAINT `fk_renewable_battery_storage_asset_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

ALTER TABLE `renewable`.`incentive_application` DROP CONSTRAINT IF EXISTS `fk_renewable_incentive_application_interconnection_application_id`;
ALTER TABLE `renewable`.`incentive_application` ADD CONSTRAINT `fk_renewable_incentive_application_interconnection_application_id` FOREIGN KEY (`interconnection_application_id`) REFERENCES `interconnection`.`application` (`application_id`);

-- ========= renewable --> metering (9) =========
ALTER TABLE `renewable`.`renewable_rec_certificate` DROP CONSTRAINT IF EXISTS `fk_renewable_renewable_rec_certificate_meter_id`;
ALTER TABLE `renewable`.`renewable_rec_certificate` ADD CONSTRAINT `fk_renewable_renewable_rec_certificate_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `renewable`.`ppa_settlement` DROP CONSTRAINT IF EXISTS `fk_renewable_ppa_settlement_meter_id`;
ALTER TABLE `renewable`.`ppa_settlement` ADD CONSTRAINT `fk_renewable_ppa_settlement_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `renewable`.`curtailment_event` DROP CONSTRAINT IF EXISTS `fk_renewable_curtailment_event_meter_id`;
ALTER TABLE `renewable`.`curtailment_event` ADD CONSTRAINT `fk_renewable_curtailment_event_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `renewable`.`nem_account` DROP CONSTRAINT IF EXISTS `fk_renewable_nem_account_meter_id`;
ALTER TABLE `renewable`.`nem_account` ADD CONSTRAINT `fk_renewable_nem_account_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `renewable`.`vpp_configuration` DROP CONSTRAINT IF EXISTS `fk_renewable_vpp_configuration_settlement_meter_id`;
ALTER TABLE `renewable`.`vpp_configuration` ADD CONSTRAINT `fk_renewable_vpp_configuration_settlement_meter_id` FOREIGN KEY (`settlement_meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `renewable`.`generation_meter_read` DROP CONSTRAINT IF EXISTS `fk_renewable_generation_meter_read_meter_id`;
ALTER TABLE `renewable`.`generation_meter_read` ADD CONSTRAINT `fk_renewable_generation_meter_read_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `renewable`.`der_enrollment` DROP CONSTRAINT IF EXISTS `fk_renewable_der_enrollment_meter_point_id`;
ALTER TABLE `renewable`.`der_enrollment` ADD CONSTRAINT `fk_renewable_der_enrollment_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

ALTER TABLE `renewable`.`der_enrollment` DROP CONSTRAINT IF EXISTS `fk_renewable_der_enrollment_settlement_meter_id`;
ALTER TABLE `renewable`.`der_enrollment` ADD CONSTRAINT `fk_renewable_der_enrollment_settlement_meter_id` FOREIGN KEY (`settlement_meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

ALTER TABLE `renewable`.`incentive_application` DROP CONSTRAINT IF EXISTS `fk_renewable_incentive_application_meter_point_id`;
ALTER TABLE `renewable`.`incentive_application` ADD CONSTRAINT `fk_renewable_incentive_application_meter_point_id` FOREIGN KEY (`meter_point_id`) REFERENCES `metering`.`meter_point` (`meter_point_id`);

-- ========= renewable --> outage (4) =========
ALTER TABLE `renewable`.`ppa_settlement` DROP CONSTRAINT IF EXISTS `fk_renewable_ppa_settlement_force_majeure_outage_event_id`;
ALTER TABLE `renewable`.`ppa_settlement` ADD CONSTRAINT `fk_renewable_ppa_settlement_force_majeure_outage_event_id` FOREIGN KEY (`force_majeure_outage_event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `renewable`.`curtailment_event` DROP CONSTRAINT IF EXISTS `fk_renewable_curtailment_event_event_id`;
ALTER TABLE `renewable`.`curtailment_event` ADD CONSTRAINT `fk_renewable_curtailment_event_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `renewable`.`vpp_configuration` DROP CONSTRAINT IF EXISTS `fk_renewable_vpp_configuration_supporting_outage_event_id`;
ALTER TABLE `renewable`.`vpp_configuration` ADD CONSTRAINT `fk_renewable_vpp_configuration_supporting_outage_event_id` FOREIGN KEY (`supporting_outage_event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `renewable`.`generation_meter_read` DROP CONSTRAINT IF EXISTS `fk_renewable_generation_meter_read_event_id`;
ALTER TABLE `renewable`.`generation_meter_read` ADD CONSTRAINT `fk_renewable_generation_meter_read_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

-- ========= renewable --> supply (7) =========
ALTER TABLE `renewable`.`der_registry` DROP CONSTRAINT IF EXISTS `fk_renewable_der_registry_material_master_id`;
ALTER TABLE `renewable`.`der_registry` ADD CONSTRAINT `fk_renewable_der_registry_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `renewable`.`ppa_settlement` DROP CONSTRAINT IF EXISTS `fk_renewable_ppa_settlement_vendor_id`;
ALTER TABLE `renewable`.`ppa_settlement` ADD CONSTRAINT `fk_renewable_ppa_settlement_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `renewable`.`interconnection_queue` DROP CONSTRAINT IF EXISTS `fk_renewable_interconnection_queue_network_upgrade_material_master_id`;
ALTER TABLE `renewable`.`interconnection_queue` ADD CONSTRAINT `fk_renewable_interconnection_queue_network_upgrade_material_master_id` FOREIGN KEY (`network_upgrade_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `renewable`.`battery_storage_asset` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_storage_asset_material_master_id`;
ALTER TABLE `renewable`.`battery_storage_asset` ADD CONSTRAINT `fk_renewable_battery_storage_asset_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `renewable`.`incentive_application` DROP CONSTRAINT IF EXISTS `fk_renewable_incentive_application_equipment_material_master_id`;
ALTER TABLE `renewable`.`incentive_application` ADD CONSTRAINT `fk_renewable_incentive_application_equipment_material_master_id` FOREIGN KEY (`equipment_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `renewable`.`battery_vendor_service_agreement` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_vendor_service_agreement_vendor_id`;
ALTER TABLE `renewable`.`battery_vendor_service_agreement` ADD CONSTRAINT `fk_renewable_battery_vendor_service_agreement_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `renewable`.`ppa_vendor_participation` DROP CONSTRAINT IF EXISTS `fk_renewable_ppa_vendor_participation_vendor_id`;
ALTER TABLE `renewable`.`ppa_vendor_participation` ADD CONSTRAINT `fk_renewable_ppa_vendor_participation_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

-- ========= renewable --> trading (2) =========
ALTER TABLE `renewable`.`ppa_contract` DROP CONSTRAINT IF EXISTS `fk_renewable_ppa_contract_counterparty_id`;
ALTER TABLE `renewable`.`ppa_contract` ADD CONSTRAINT `fk_renewable_ppa_contract_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `renewable`.`ppa_settlement` DROP CONSTRAINT IF EXISTS `fk_renewable_ppa_settlement_counterparty_id`;
ALTER TABLE `renewable`.`ppa_settlement` ADD CONSTRAINT `fk_renewable_ppa_settlement_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

-- ========= renewable --> transmission (4) =========
ALTER TABLE `renewable`.`curtailment_event` DROP CONSTRAINT IF EXISTS `fk_renewable_curtailment_event_causing_congestion_event_id`;
ALTER TABLE `renewable`.`curtailment_event` ADD CONSTRAINT `fk_renewable_curtailment_event_causing_congestion_event_id` FOREIGN KEY (`causing_congestion_event_id`) REFERENCES `transmission`.`congestion_event` (`congestion_event_id`);

ALTER TABLE `renewable`.`curtailment_event` DROP CONSTRAINT IF EXISTS `fk_renewable_curtailment_event_causing_transmission_outage_id`;
ALTER TABLE `renewable`.`curtailment_event` ADD CONSTRAINT `fk_renewable_curtailment_event_causing_transmission_outage_id` FOREIGN KEY (`causing_transmission_outage_id`) REFERENCES `transmission`.`transmission_outage` (`transmission_outage_id`);

ALTER TABLE `renewable`.`curtailment_event` DROP CONSTRAINT IF EXISTS `fk_renewable_curtailment_event_transmission_constraint_id`;
ALTER TABLE `renewable`.`curtailment_event` ADD CONSTRAINT `fk_renewable_curtailment_event_transmission_constraint_id` FOREIGN KEY (`transmission_constraint_id`) REFERENCES `transmission`.`constraint` (`constraint_id`);

ALTER TABLE `renewable`.`interconnection_queue` DROP CONSTRAINT IF EXISTS `fk_renewable_interconnection_queue_transmission_service_request_id`;
ALTER TABLE `renewable`.`interconnection_queue` ADD CONSTRAINT `fk_renewable_interconnection_queue_transmission_service_request_id` FOREIGN KEY (`transmission_service_request_id`) REFERENCES `transmission`.`transmission_service_request` (`transmission_service_request_id`);

-- ========= renewable --> workforce (10) =========
ALTER TABLE `renewable`.`der_registry` DROP CONSTRAINT IF EXISTS `fk_renewable_der_registry_commissioning_technician_employee_id`;
ALTER TABLE `renewable`.`der_registry` ADD CONSTRAINT `fk_renewable_der_registry_commissioning_technician_employee_id` FOREIGN KEY (`commissioning_technician_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `renewable`.`ppa_contract` DROP CONSTRAINT IF EXISTS `fk_renewable_ppa_contract_contract_manager_employee_id`;
ALTER TABLE `renewable`.`ppa_contract` ADD CONSTRAINT `fk_renewable_ppa_contract_contract_manager_employee_id` FOREIGN KEY (`contract_manager_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `renewable`.`ppa_settlement` DROP CONSTRAINT IF EXISTS `fk_renewable_ppa_settlement_settlement_analyst_employee_id`;
ALTER TABLE `renewable`.`ppa_settlement` ADD CONSTRAINT `fk_renewable_ppa_settlement_settlement_analyst_employee_id` FOREIGN KEY (`settlement_analyst_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `renewable`.`curtailment_event` DROP CONSTRAINT IF EXISTS `fk_renewable_curtailment_event_operator_employee_id`;
ALTER TABLE `renewable`.`curtailment_event` ADD CONSTRAINT `fk_renewable_curtailment_event_operator_employee_id` FOREIGN KEY (`operator_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `renewable`.`interconnection_queue` DROP CONSTRAINT IF EXISTS `fk_renewable_interconnection_queue_reviewing_engineer_employee_id`;
ALTER TABLE `renewable`.`interconnection_queue` ADD CONSTRAINT `fk_renewable_interconnection_queue_reviewing_engineer_employee_id` FOREIGN KEY (`reviewing_engineer_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `renewable`.`vpp_configuration` DROP CONSTRAINT IF EXISTS `fk_renewable_vpp_configuration_program_manager_employee_id`;
ALTER TABLE `renewable`.`vpp_configuration` ADD CONSTRAINT `fk_renewable_vpp_configuration_program_manager_employee_id` FOREIGN KEY (`program_manager_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `renewable`.`battery_storage_asset` DROP CONSTRAINT IF EXISTS `fk_renewable_battery_storage_asset_maintenance_technician_employee_id`;
ALTER TABLE `renewable`.`battery_storage_asset` ADD CONSTRAINT `fk_renewable_battery_storage_asset_maintenance_technician_employee_id` FOREIGN KEY (`maintenance_technician_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `renewable`.`incentive_application` DROP CONSTRAINT IF EXISTS `fk_renewable_incentive_application_employee_id`;
ALTER TABLE `renewable`.`incentive_application` ADD CONSTRAINT `fk_renewable_incentive_application_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `renewable`.`green_tariff_subscription` DROP CONSTRAINT IF EXISTS `fk_renewable_green_tariff_subscription_enrollment_processor_employee_id`;
ALTER TABLE `renewable`.`green_tariff_subscription` ADD CONSTRAINT `fk_renewable_green_tariff_subscription_enrollment_processor_employee_id` FOREIGN KEY (`enrollment_processor_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `renewable`.`der_service_assignment` DROP CONSTRAINT IF EXISTS `fk_renewable_der_service_assignment_crew_id`;
ALTER TABLE `renewable`.`der_service_assignment` ADD CONSTRAINT `fk_renewable_der_service_assignment_crew_id` FOREIGN KEY (`crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

-- ========= supply --> asset (5) =========
ALTER TABLE `supply`.`purchase_requisition` DROP CONSTRAINT IF EXISTS `fk_supply_purchase_requisition_triggering_work_order_id`;
ALTER TABLE `supply`.`purchase_requisition` ADD CONSTRAINT `fk_supply_purchase_requisition_triggering_work_order_id` FOREIGN KEY (`triggering_work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `supply`.`goods_issue` DROP CONSTRAINT IF EXISTS `fk_supply_goods_issue_capital_project_id`;
ALTER TABLE `supply`.`goods_issue` ADD CONSTRAINT `fk_supply_goods_issue_capital_project_id` FOREIGN KEY (`capital_project_id`) REFERENCES `asset`.`capital_project` (`capital_project_id`);

ALTER TABLE `supply`.`goods_issue` DROP CONSTRAINT IF EXISTS `fk_supply_goods_issue_work_order_id`;
ALTER TABLE `supply`.`goods_issue` ADD CONSTRAINT `fk_supply_goods_issue_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `supply`.`stock_transfer` DROP CONSTRAINT IF EXISTS `fk_supply_stock_transfer_capital_project_id`;
ALTER TABLE `supply`.`stock_transfer` ADD CONSTRAINT `fk_supply_stock_transfer_capital_project_id` FOREIGN KEY (`capital_project_id`) REFERENCES `asset`.`capital_project` (`capital_project_id`);

ALTER TABLE `supply`.`stock_transfer` DROP CONSTRAINT IF EXISTS `fk_supply_stock_transfer_work_order_id`;
ALTER TABLE `supply`.`stock_transfer` ADD CONSTRAINT `fk_supply_stock_transfer_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

-- ========= supply --> compliance (12) =========
ALTER TABLE `supply`.`vendor` DROP CONSTRAINT IF EXISTS `fk_supply_vendor_obligation_id`;
ALTER TABLE `supply`.`vendor` ADD CONSTRAINT `fk_supply_vendor_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `supply`.`purchase_order` DROP CONSTRAINT IF EXISTS `fk_supply_purchase_order_obligation_id`;
ALTER TABLE `supply`.`purchase_order` ADD CONSTRAINT `fk_supply_purchase_order_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `supply`.`warehouse` DROP CONSTRAINT IF EXISTS `fk_supply_warehouse_nerc_cip_asset_id`;
ALTER TABLE `supply`.`warehouse` ADD CONSTRAINT `fk_supply_warehouse_nerc_cip_asset_id` FOREIGN KEY (`nerc_cip_asset_id`) REFERENCES `compliance`.`nerc_cip_asset` (`nerc_cip_asset_id`);

ALTER TABLE `supply`.`supplier_contract` DROP CONSTRAINT IF EXISTS `fk_supply_supplier_contract_obligation_id`;
ALTER TABLE `supply`.`supplier_contract` ADD CONSTRAINT `fk_supply_supplier_contract_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `supply`.`fuel_supply_contract` DROP CONSTRAINT IF EXISTS `fk_supply_fuel_supply_contract_compliance_environmental_permit_id`;
ALTER TABLE `supply`.`fuel_supply_contract` ADD CONSTRAINT `fk_supply_fuel_supply_contract_compliance_environmental_permit_id` FOREIGN KEY (`compliance_environmental_permit_id`) REFERENCES `compliance`.`environmental_permit` (`environmental_permit_id`);

ALTER TABLE `supply`.`fuel_supply_contract` DROP CONSTRAINT IF EXISTS `fk_supply_fuel_supply_contract_obligation_id`;
ALTER TABLE `supply`.`fuel_supply_contract` ADD CONSTRAINT `fk_supply_fuel_supply_contract_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `supply`.`purchase_requisition` DROP CONSTRAINT IF EXISTS `fk_supply_purchase_requisition_corrective_action_plan_id`;
ALTER TABLE `supply`.`purchase_requisition` ADD CONSTRAINT `fk_supply_purchase_requisition_corrective_action_plan_id` FOREIGN KEY (`corrective_action_plan_id`) REFERENCES `compliance`.`corrective_action_plan` (`corrective_action_plan_id`);

ALTER TABLE `supply`.`goods_issue` DROP CONSTRAINT IF EXISTS `fk_supply_goods_issue_training_record_id`;
ALTER TABLE `supply`.`goods_issue` ADD CONSTRAINT `fk_supply_goods_issue_training_record_id` FOREIGN KEY (`training_record_id`) REFERENCES `compliance`.`training_record` (`training_record_id`);

ALTER TABLE `supply`.`spare_parts_catalog` DROP CONSTRAINT IF EXISTS `fk_supply_spare_parts_catalog_nerc_cip_asset_id`;
ALTER TABLE `supply`.`spare_parts_catalog` ADD CONSTRAINT `fk_supply_spare_parts_catalog_nerc_cip_asset_id` FOREIGN KEY (`nerc_cip_asset_id`) REFERENCES `compliance`.`nerc_cip_asset` (`nerc_cip_asset_id`);

ALTER TABLE `supply`.`vendor_evaluation` DROP CONSTRAINT IF EXISTS `fk_supply_vendor_evaluation_compliance_sox_control_id`;
ALTER TABLE `supply`.`vendor_evaluation` ADD CONSTRAINT `fk_supply_vendor_evaluation_compliance_sox_control_id` FOREIGN KEY (`compliance_sox_control_id`) REFERENCES `compliance`.`sox_control` (`sox_control_id`);

ALTER TABLE `supply`.`vendor_quotation` DROP CONSTRAINT IF EXISTS `fk_supply_vendor_quotation_rate_case_id`;
ALTER TABLE `supply`.`vendor_quotation` ADD CONSTRAINT `fk_supply_vendor_quotation_rate_case_id` FOREIGN KEY (`rate_case_id`) REFERENCES `compliance`.`rate_case` (`rate_case_id`);

ALTER TABLE `supply`.`emergency_stock_event` DROP CONSTRAINT IF EXISTS `fk_supply_emergency_stock_event_self_report_id`;
ALTER TABLE `supply`.`emergency_stock_event` ADD CONSTRAINT `fk_supply_emergency_stock_event_self_report_id` FOREIGN KEY (`self_report_id`) REFERENCES `compliance`.`self_report` (`self_report_id`);

-- ========= supply --> finance (7) =========
ALTER TABLE `supply`.`purchase_order` DROP CONSTRAINT IF EXISTS `fk_supply_purchase_order_gl_account_id`;
ALTER TABLE `supply`.`purchase_order` ADD CONSTRAINT `fk_supply_purchase_order_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `supply`.`warehouse` DROP CONSTRAINT IF EXISTS `fk_supply_warehouse_cost_center_id`;
ALTER TABLE `supply`.`warehouse` ADD CONSTRAINT `fk_supply_warehouse_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `supply`.`supplier_contract` DROP CONSTRAINT IF EXISTS `fk_supply_supplier_contract_cost_center_id`;
ALTER TABLE `supply`.`supplier_contract` ADD CONSTRAINT `fk_supply_supplier_contract_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `supply`.`fuel_supply_contract` DROP CONSTRAINT IF EXISTS `fk_supply_fuel_supply_contract_cost_center_id`;
ALTER TABLE `supply`.`fuel_supply_contract` ADD CONSTRAINT `fk_supply_fuel_supply_contract_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `supply`.`invoice_verification` DROP CONSTRAINT IF EXISTS `fk_supply_invoice_verification_cost_center_id`;
ALTER TABLE `supply`.`invoice_verification` ADD CONSTRAINT `fk_supply_invoice_verification_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `supply`.`invoice_verification` DROP CONSTRAINT IF EXISTS `fk_supply_invoice_verification_gl_account_id`;
ALTER TABLE `supply`.`invoice_verification` ADD CONSTRAINT `fk_supply_invoice_verification_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `supply`.`spare_parts_catalog` DROP CONSTRAINT IF EXISTS `fk_supply_spare_parts_catalog_cost_center_id`;
ALTER TABLE `supply`.`spare_parts_catalog` ADD CONSTRAINT `fk_supply_spare_parts_catalog_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

-- ========= supply --> generation (3) =========
ALTER TABLE `supply`.`fuel_supply_contract` DROP CONSTRAINT IF EXISTS `fk_supply_fuel_supply_contract_power_plant_id`;
ALTER TABLE `supply`.`fuel_supply_contract` ADD CONSTRAINT `fk_supply_fuel_supply_contract_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `supply`.`stock_transfer` DROP CONSTRAINT IF EXISTS `fk_supply_stock_transfer_receiving_plant_id`;
ALTER TABLE `supply`.`stock_transfer` ADD CONSTRAINT `fk_supply_stock_transfer_receiving_plant_id` FOREIGN KEY (`receiving_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

ALTER TABLE `supply`.`stock_transfer` DROP CONSTRAINT IF EXISTS `fk_supply_stock_transfer_sending_plant_id`;
ALTER TABLE `supply`.`stock_transfer` ADD CONSTRAINT `fk_supply_stock_transfer_sending_plant_id` FOREIGN KEY (`sending_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

-- ========= supply --> gis (1) =========
ALTER TABLE `supply`.`warehouse` DROP CONSTRAINT IF EXISTS `fk_supply_warehouse_gis_location_id`;
ALTER TABLE `supply`.`warehouse` ADD CONSTRAINT `fk_supply_warehouse_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

-- ========= supply --> outage (4) =========
ALTER TABLE `supply`.`purchase_requisition` DROP CONSTRAINT IF EXISTS `fk_supply_purchase_requisition_damage_assessment_id`;
ALTER TABLE `supply`.`purchase_requisition` ADD CONSTRAINT `fk_supply_purchase_requisition_damage_assessment_id` FOREIGN KEY (`damage_assessment_id`) REFERENCES `outage`.`damage_assessment` (`damage_assessment_id`);

ALTER TABLE `supply`.`goods_issue` DROP CONSTRAINT IF EXISTS `fk_supply_goods_issue_outage_crew_dispatch_id`;
ALTER TABLE `supply`.`goods_issue` ADD CONSTRAINT `fk_supply_goods_issue_outage_crew_dispatch_id` FOREIGN KEY (`outage_crew_dispatch_id`) REFERENCES `outage`.`outage_crew_dispatch` (`outage_crew_dispatch_id`);

ALTER TABLE `supply`.`stock_transfer` DROP CONSTRAINT IF EXISTS `fk_supply_stock_transfer_mutual_aid_request_id`;
ALTER TABLE `supply`.`stock_transfer` ADD CONSTRAINT `fk_supply_stock_transfer_mutual_aid_request_id` FOREIGN KEY (`mutual_aid_request_id`) REFERENCES `outage`.`mutual_aid_request` (`mutual_aid_request_id`);

ALTER TABLE `supply`.`emergency_stock_event` DROP CONSTRAINT IF EXISTS `fk_supply_emergency_stock_event_storm_event_id`;
ALTER TABLE `supply`.`emergency_stock_event` ADD CONSTRAINT `fk_supply_emergency_stock_event_storm_event_id` FOREIGN KEY (`storm_event_id`) REFERENCES `outage`.`storm_event` (`storm_event_id`);

-- ========= supply --> trading (3) =========
ALTER TABLE `supply`.`vendor` DROP CONSTRAINT IF EXISTS `fk_supply_vendor_counterparty_id`;
ALTER TABLE `supply`.`vendor` ADD CONSTRAINT `fk_supply_vendor_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `supply`.`purchase_order` DROP CONSTRAINT IF EXISTS `fk_supply_purchase_order_counterparty_id`;
ALTER TABLE `supply`.`purchase_order` ADD CONSTRAINT `fk_supply_purchase_order_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `supply`.`fuel_supply_contract` DROP CONSTRAINT IF EXISTS `fk_supply_fuel_supply_contract_counterparty_id`;
ALTER TABLE `supply`.`fuel_supply_contract` ADD CONSTRAINT `fk_supply_fuel_supply_contract_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

-- ========= supply --> workforce (9) =========
ALTER TABLE `supply`.`warehouse` DROP CONSTRAINT IF EXISTS `fk_supply_warehouse_manager_employee_id`;
ALTER TABLE `supply`.`warehouse` ADD CONSTRAINT `fk_supply_warehouse_manager_employee_id` FOREIGN KEY (`manager_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `supply`.`purchase_requisition` DROP CONSTRAINT IF EXISTS `fk_supply_purchase_requisition_approver_employee_id`;
ALTER TABLE `supply`.`purchase_requisition` ADD CONSTRAINT `fk_supply_purchase_requisition_approver_employee_id` FOREIGN KEY (`approver_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `supply`.`purchase_requisition` DROP CONSTRAINT IF EXISTS `fk_supply_purchase_requisition_primary_purchase_requisitioner_employee_id`;
ALTER TABLE `supply`.`purchase_requisition` ADD CONSTRAINT `fk_supply_purchase_requisition_primary_purchase_requisitioner_employee_id` FOREIGN KEY (`primary_purchase_requisitioner_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `supply`.`goods_issue` DROP CONSTRAINT IF EXISTS `fk_supply_goods_issue_primary_goods_employee_id`;
ALTER TABLE `supply`.`goods_issue` ADD CONSTRAINT `fk_supply_goods_issue_primary_goods_employee_id` FOREIGN KEY (`primary_goods_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `supply`.`stock_transfer` DROP CONSTRAINT IF EXISTS `fk_supply_stock_transfer_approver_employee_id`;
ALTER TABLE `supply`.`stock_transfer` ADD CONSTRAINT `fk_supply_stock_transfer_approver_employee_id` FOREIGN KEY (`approver_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `supply`.`stock_transfer` DROP CONSTRAINT IF EXISTS `fk_supply_stock_transfer_requester_employee_id`;
ALTER TABLE `supply`.`stock_transfer` ADD CONSTRAINT `fk_supply_stock_transfer_requester_employee_id` FOREIGN KEY (`requester_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `supply`.`vendor_evaluation` DROP CONSTRAINT IF EXISTS `fk_supply_vendor_evaluation_primary_vendor_employee_id`;
ALTER TABLE `supply`.`vendor_evaluation` ADD CONSTRAINT `fk_supply_vendor_evaluation_primary_vendor_employee_id` FOREIGN KEY (`primary_vendor_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `supply`.`request_for_quotation` DROP CONSTRAINT IF EXISTS `fk_supply_request_for_quotation_buyer_employee_id`;
ALTER TABLE `supply`.`request_for_quotation` ADD CONSTRAINT `fk_supply_request_for_quotation_buyer_employee_id` FOREIGN KEY (`buyer_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `supply`.`inventory_count` DROP CONSTRAINT IF EXISTS `fk_supply_inventory_count_employee_id`;
ALTER TABLE `supply`.`inventory_count` ADD CONSTRAINT `fk_supply_inventory_count_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

-- ========= trading --> asset (2) =========
ALTER TABLE `trading`.`trade` DROP CONSTRAINT IF EXISTS `fk_trading_trade_registry_id`;
ALTER TABLE `trading`.`trade` ADD CONSTRAINT `fk_trading_trade_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `trading`.`ppa` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_generation_asset_registry_id`;
ALTER TABLE `trading`.`ppa` ADD CONSTRAINT `fk_trading_ppa_generation_asset_registry_id` FOREIGN KEY (`generation_asset_registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

-- ========= trading --> compliance (16) =========
ALTER TABLE `trading`.`trade` DROP CONSTRAINT IF EXISTS `fk_trading_trade_audit_finding_id`;
ALTER TABLE `trading`.`trade` ADD CONSTRAINT `fk_trading_trade_audit_finding_id` FOREIGN KEY (`audit_finding_id`) REFERENCES `compliance`.`audit_finding` (`audit_finding_id`);

ALTER TABLE `trading`.`trade` DROP CONSTRAINT IF EXISTS `fk_trading_trade_obligation_id`;
ALTER TABLE `trading`.`trade` ADD CONSTRAINT `fk_trading_trade_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `trading`.`trade` DROP CONSTRAINT IF EXISTS `fk_trading_trade_regulatory_filing_id`;
ALTER TABLE `trading`.`trade` ADD CONSTRAINT `fk_trading_trade_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `trading`.`ppa` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_obligation_id`;
ALTER TABLE `trading`.`ppa` ADD CONSTRAINT `fk_trading_ppa_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `trading`.`market_bid` DROP CONSTRAINT IF EXISTS `fk_trading_market_bid_obligation_id`;
ALTER TABLE `trading`.`market_bid` ADD CONSTRAINT `fk_trading_market_bid_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `trading`.`scheduling_coordinator` DROP CONSTRAINT IF EXISTS `fk_trading_scheduling_coordinator_compliance_environmental_permit_id`;
ALTER TABLE `trading`.`scheduling_coordinator` ADD CONSTRAINT `fk_trading_scheduling_coordinator_compliance_environmental_permit_id` FOREIGN KEY (`compliance_environmental_permit_id`) REFERENCES `compliance`.`environmental_permit` (`environmental_permit_id`);

ALTER TABLE `trading`.`market_settlement` DROP CONSTRAINT IF EXISTS `fk_trading_market_settlement_regulatory_filing_id`;
ALTER TABLE `trading`.`market_settlement` ADD CONSTRAINT `fk_trading_market_settlement_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `trading`.`credit_exposure` DROP CONSTRAINT IF EXISTS `fk_trading_credit_exposure_audit_id`;
ALTER TABLE `trading`.`credit_exposure` ADD CONSTRAINT `fk_trading_credit_exposure_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `trading`.`ftr_holding` DROP CONSTRAINT IF EXISTS `fk_trading_ftr_holding_regulatory_filing_id`;
ALTER TABLE `trading`.`ftr_holding` ADD CONSTRAINT `fk_trading_ftr_holding_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `trading`.`rec_holding` DROP CONSTRAINT IF EXISTS `fk_trading_rec_holding_compliance_rec_certificate_id`;
ALTER TABLE `trading`.`rec_holding` ADD CONSTRAINT `fk_trading_rec_holding_compliance_rec_certificate_id` FOREIGN KEY (`compliance_rec_certificate_id`) REFERENCES `compliance`.`compliance_rec_certificate` (`compliance_rec_certificate_id`);

ALTER TABLE `trading`.`rec_transaction` DROP CONSTRAINT IF EXISTS `fk_trading_rec_transaction_compliance_rec_certificate_id`;
ALTER TABLE `trading`.`rec_transaction` ADD CONSTRAINT `fk_trading_rec_transaction_compliance_rec_certificate_id` FOREIGN KEY (`compliance_rec_certificate_id`) REFERENCES `compliance`.`compliance_rec_certificate` (`compliance_rec_certificate_id`);

ALTER TABLE `trading`.`ancillary_service_award` DROP CONSTRAINT IF EXISTS `fk_trading_ancillary_service_award_regulatory_filing_id`;
ALTER TABLE `trading`.`ancillary_service_award` ADD CONSTRAINT `fk_trading_ancillary_service_award_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `trading`.`book` DROP CONSTRAINT IF EXISTS `fk_trading_book_compliance_sox_control_id`;
ALTER TABLE `trading`.`book` ADD CONSTRAINT `fk_trading_book_compliance_sox_control_id` FOREIGN KEY (`compliance_sox_control_id`) REFERENCES `compliance`.`sox_control` (`sox_control_id`);

ALTER TABLE `trading`.`ferc_eqr_filing` DROP CONSTRAINT IF EXISTS `fk_trading_ferc_eqr_filing_regulatory_filing_id`;
ALTER TABLE `trading`.`ferc_eqr_filing` ADD CONSTRAINT `fk_trading_ferc_eqr_filing_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `trading`.`hedge_strategy` DROP CONSTRAINT IF EXISTS `fk_trading_hedge_strategy_compliance_sox_control_id`;
ALTER TABLE `trading`.`hedge_strategy` ADD CONSTRAINT `fk_trading_hedge_strategy_compliance_sox_control_id` FOREIGN KEY (`compliance_sox_control_id`) REFERENCES `compliance`.`sox_control` (`sox_control_id`);

ALTER TABLE `trading`.`capacity_obligation` DROP CONSTRAINT IF EXISTS `fk_trading_capacity_obligation_regulatory_filing_id`;
ALTER TABLE `trading`.`capacity_obligation` ADD CONSTRAINT `fk_trading_capacity_obligation_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

-- ========= trading --> customer (1) =========
ALTER TABLE `trading`.`rec_transaction` DROP CONSTRAINT IF EXISTS `fk_trading_rec_transaction_primary_rec_counterparty_account_id`;
ALTER TABLE `trading`.`rec_transaction` ADD CONSTRAINT `fk_trading_rec_transaction_primary_rec_counterparty_account_id` FOREIGN KEY (`primary_rec_counterparty_account_id`) REFERENCES `customer`.`account` (`account_id`);

-- ========= trading --> demand (7) =========
ALTER TABLE `trading`.`trading_position` DROP CONSTRAINT IF EXISTS `fk_trading_trading_position_dr_program_id`;
ALTER TABLE `trading`.`trading_position` ADD CONSTRAINT `fk_trading_trading_position_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

ALTER TABLE `trading`.`market_bid` DROP CONSTRAINT IF EXISTS `fk_trading_market_bid_dr_event_id`;
ALTER TABLE `trading`.`market_bid` ADD CONSTRAINT `fk_trading_market_bid_dr_event_id` FOREIGN KEY (`dr_event_id`) REFERENCES `demand`.`dr_event` (`dr_event_id`);

ALTER TABLE `trading`.`market_award` DROP CONSTRAINT IF EXISTS `fk_trading_market_award_dr_event_id`;
ALTER TABLE `trading`.`market_award` ADD CONSTRAINT `fk_trading_market_award_dr_event_id` FOREIGN KEY (`dr_event_id`) REFERENCES `demand`.`dr_event` (`dr_event_id`);

ALTER TABLE `trading`.`energy_schedule` DROP CONSTRAINT IF EXISTS `fk_trading_energy_schedule_dr_event_id`;
ALTER TABLE `trading`.`energy_schedule` ADD CONSTRAINT `fk_trading_energy_schedule_dr_event_id` FOREIGN KEY (`dr_event_id`) REFERENCES `demand`.`dr_event` (`dr_event_id`);

ALTER TABLE `trading`.`market_settlement` DROP CONSTRAINT IF EXISTS `fk_trading_market_settlement_dr_event_id`;
ALTER TABLE `trading`.`market_settlement` ADD CONSTRAINT `fk_trading_market_settlement_dr_event_id` FOREIGN KEY (`dr_event_id`) REFERENCES `demand`.`dr_event` (`dr_event_id`);

ALTER TABLE `trading`.`capacity_obligation` DROP CONSTRAINT IF EXISTS `fk_trading_capacity_obligation_demand_dr_enrollment_id`;
ALTER TABLE `trading`.`capacity_obligation` ADD CONSTRAINT `fk_trading_capacity_obligation_demand_dr_enrollment_id` FOREIGN KEY (`demand_dr_enrollment_id`) REFERENCES `demand`.`demand_dr_enrollment` (`demand_dr_enrollment_id`);

ALTER TABLE `trading`.`capacity_obligation` DROP CONSTRAINT IF EXISTS `fk_trading_capacity_obligation_dr_program_id`;
ALTER TABLE `trading`.`capacity_obligation` ADD CONSTRAINT `fk_trading_capacity_obligation_dr_program_id` FOREIGN KEY (`dr_program_id`) REFERENCES `demand`.`dr_program` (`dr_program_id`);

-- ========= trading --> distribution (4) =========
ALTER TABLE `trading`.`ppa_delivery` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_delivery_distribution_substation_id`;
ALTER TABLE `trading`.`ppa_delivery` ADD CONSTRAINT `fk_trading_ppa_delivery_distribution_substation_id` FOREIGN KEY (`distribution_substation_id`) REFERENCES `distribution`.`distribution_substation` (`distribution_substation_id`);

ALTER TABLE `trading`.`ppa_delivery` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_delivery_feeder_id`;
ALTER TABLE `trading`.`ppa_delivery` ADD CONSTRAINT `fk_trading_ppa_delivery_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `trading`.`market_award` DROP CONSTRAINT IF EXISTS `fk_trading_market_award_feeder_id`;
ALTER TABLE `trading`.`market_award` ADD CONSTRAINT `fk_trading_market_award_feeder_id` FOREIGN KEY (`feeder_id`) REFERENCES `distribution`.`feeder` (`feeder_id`);

ALTER TABLE `trading`.`rec_transaction` DROP CONSTRAINT IF EXISTS `fk_trading_rec_transaction_der_interconnection_point_id`;
ALTER TABLE `trading`.`rec_transaction` ADD CONSTRAINT `fk_trading_rec_transaction_der_interconnection_point_id` FOREIGN KEY (`der_interconnection_point_id`) REFERENCES `distribution`.`der_interconnection_point` (`der_interconnection_point_id`);

-- ========= trading --> finance (16) =========
ALTER TABLE `trading`.`trade` DROP CONSTRAINT IF EXISTS `fk_trading_trade_cost_center_id`;
ALTER TABLE `trading`.`trade` ADD CONSTRAINT `fk_trading_trade_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `trading`.`trade` DROP CONSTRAINT IF EXISTS `fk_trading_trade_profit_center_id`;
ALTER TABLE `trading`.`trade` ADD CONSTRAINT `fk_trading_trade_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `trading`.`trade_leg` DROP CONSTRAINT IF EXISTS `fk_trading_trade_leg_cost_center_id`;
ALTER TABLE `trading`.`trade_leg` ADD CONSTRAINT `fk_trading_trade_leg_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `trading`.`trading_position` DROP CONSTRAINT IF EXISTS `fk_trading_trading_position_cost_center_id`;
ALTER TABLE `trading`.`trading_position` ADD CONSTRAINT `fk_trading_trading_position_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `trading`.`trading_position` DROP CONSTRAINT IF EXISTS `fk_trading_trading_position_profit_center_id`;
ALTER TABLE `trading`.`trading_position` ADD CONSTRAINT `fk_trading_trading_position_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `trading`.`market_settlement` DROP CONSTRAINT IF EXISTS `fk_trading_market_settlement_cost_center_id`;
ALTER TABLE `trading`.`market_settlement` ADD CONSTRAINT `fk_trading_market_settlement_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `trading`.`market_settlement` DROP CONSTRAINT IF EXISTS `fk_trading_market_settlement_gl_account_id`;
ALTER TABLE `trading`.`market_settlement` ADD CONSTRAINT `fk_trading_market_settlement_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `trading`.`market_settlement` DROP CONSTRAINT IF EXISTS `fk_trading_market_settlement_profit_center_id`;
ALTER TABLE `trading`.`market_settlement` ADD CONSTRAINT `fk_trading_market_settlement_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `trading`.`rec_transaction` DROP CONSTRAINT IF EXISTS `fk_trading_rec_transaction_cost_center_id`;
ALTER TABLE `trading`.`rec_transaction` ADD CONSTRAINT `fk_trading_rec_transaction_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `trading`.`rec_transaction` DROP CONSTRAINT IF EXISTS `fk_trading_rec_transaction_gl_account_id`;
ALTER TABLE `trading`.`rec_transaction` ADD CONSTRAINT `fk_trading_rec_transaction_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `trading`.`book` DROP CONSTRAINT IF EXISTS `fk_trading_book_cost_center_id`;
ALTER TABLE `trading`.`book` ADD CONSTRAINT `fk_trading_book_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `trading`.`ferc_eqr_filing` DROP CONSTRAINT IF EXISTS `fk_trading_ferc_eqr_filing_gl_account_id`;
ALTER TABLE `trading`.`ferc_eqr_filing` ADD CONSTRAINT `fk_trading_ferc_eqr_filing_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `finance`.`gl_account` (`gl_account_id`);

ALTER TABLE `trading`.`hedge_strategy` DROP CONSTRAINT IF EXISTS `fk_trading_hedge_strategy_capex_project_id`;
ALTER TABLE `trading`.`hedge_strategy` ADD CONSTRAINT `fk_trading_hedge_strategy_capex_project_id` FOREIGN KEY (`capex_project_id`) REFERENCES `finance`.`capex_project` (`capex_project_id`);

ALTER TABLE `trading`.`capacity_obligation` DROP CONSTRAINT IF EXISTS `fk_trading_capacity_obligation_cost_center_id`;
ALTER TABLE `trading`.`capacity_obligation` ADD CONSTRAINT `fk_trading_capacity_obligation_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `trading`.`capacity_obligation` DROP CONSTRAINT IF EXISTS `fk_trading_capacity_obligation_profit_center_id`;
ALTER TABLE `trading`.`capacity_obligation` ADD CONSTRAINT `fk_trading_capacity_obligation_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `trading`.`legal_entity` DROP CONSTRAINT IF EXISTS `fk_trading_legal_entity_legal_entity_id`;
ALTER TABLE `trading`.`legal_entity` ADD CONSTRAINT `fk_trading_legal_entity_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `finance`.`legal_entity` (`legal_entity_id`);

-- ========= trading --> forecast (13) =========
ALTER TABLE `trading`.`trade` DROP CONSTRAINT IF EXISTS `fk_trading_trade_energy_price_id`;
ALTER TABLE `trading`.`trade` ADD CONSTRAINT `fk_trading_trade_energy_price_id` FOREIGN KEY (`energy_price_id`) REFERENCES `forecast`.`energy_price` (`energy_price_id`);

ALTER TABLE `trading`.`trading_position` DROP CONSTRAINT IF EXISTS `fk_trading_trading_position_energy_price_id`;
ALTER TABLE `trading`.`trading_position` ADD CONSTRAINT `fk_trading_trading_position_energy_price_id` FOREIGN KEY (`energy_price_id`) REFERENCES `forecast`.`energy_price` (`energy_price_id`);

ALTER TABLE `trading`.`ppa_delivery` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_delivery_forecast_renewable_id`;
ALTER TABLE `trading`.`ppa_delivery` ADD CONSTRAINT `fk_trading_ppa_delivery_forecast_renewable_id` FOREIGN KEY (`forecast_renewable_id`) REFERENCES `forecast`.`forecast_renewable` (`forecast_renewable_id`);

ALTER TABLE `trading`.`market_bid` DROP CONSTRAINT IF EXISTS `fk_trading_market_bid_forecast_generation_id`;
ALTER TABLE `trading`.`market_bid` ADD CONSTRAINT `fk_trading_market_bid_forecast_generation_id` FOREIGN KEY (`forecast_generation_id`) REFERENCES `forecast`.`forecast_generation` (`forecast_generation_id`);

ALTER TABLE `trading`.`market_bid` DROP CONSTRAINT IF EXISTS `fk_trading_market_bid_load_id`;
ALTER TABLE `trading`.`market_bid` ADD CONSTRAINT `fk_trading_market_bid_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `trading`.`energy_schedule` DROP CONSTRAINT IF EXISTS `fk_trading_energy_schedule_forecast_generation_id`;
ALTER TABLE `trading`.`energy_schedule` ADD CONSTRAINT `fk_trading_energy_schedule_forecast_generation_id` FOREIGN KEY (`forecast_generation_id`) REFERENCES `forecast`.`forecast_generation` (`forecast_generation_id`);

ALTER TABLE `trading`.`energy_schedule` DROP CONSTRAINT IF EXISTS `fk_trading_energy_schedule_load_id`;
ALTER TABLE `trading`.`energy_schedule` ADD CONSTRAINT `fk_trading_energy_schedule_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `trading`.`market_settlement` DROP CONSTRAINT IF EXISTS `fk_trading_market_settlement_energy_price_id`;
ALTER TABLE `trading`.`market_settlement` ADD CONSTRAINT `fk_trading_market_settlement_energy_price_id` FOREIGN KEY (`energy_price_id`) REFERENCES `forecast`.`energy_price` (`energy_price_id`);

ALTER TABLE `trading`.`ftr_holding` DROP CONSTRAINT IF EXISTS `fk_trading_ftr_holding_energy_price_id`;
ALTER TABLE `trading`.`ftr_holding` ADD CONSTRAINT `fk_trading_ftr_holding_energy_price_id` FOREIGN KEY (`energy_price_id`) REFERENCES `forecast`.`energy_price` (`energy_price_id`);

ALTER TABLE `trading`.`ferc_eqr_filing` DROP CONSTRAINT IF EXISTS `fk_trading_ferc_eqr_filing_irp_scenario_id`;
ALTER TABLE `trading`.`ferc_eqr_filing` ADD CONSTRAINT `fk_trading_ferc_eqr_filing_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

ALTER TABLE `trading`.`hedge_strategy` DROP CONSTRAINT IF EXISTS `fk_trading_hedge_strategy_energy_price_id`;
ALTER TABLE `trading`.`hedge_strategy` ADD CONSTRAINT `fk_trading_hedge_strategy_energy_price_id` FOREIGN KEY (`energy_price_id`) REFERENCES `forecast`.`energy_price` (`energy_price_id`);

ALTER TABLE `trading`.`capacity_obligation` DROP CONSTRAINT IF EXISTS `fk_trading_capacity_obligation_capacity_requirement_id`;
ALTER TABLE `trading`.`capacity_obligation` ADD CONSTRAINT `fk_trading_capacity_obligation_capacity_requirement_id` FOREIGN KEY (`capacity_requirement_id`) REFERENCES `forecast`.`capacity_requirement` (`capacity_requirement_id`);

ALTER TABLE `trading`.`capacity_obligation` DROP CONSTRAINT IF EXISTS `fk_trading_capacity_obligation_peak_demand_id`;
ALTER TABLE `trading`.`capacity_obligation` ADD CONSTRAINT `fk_trading_capacity_obligation_peak_demand_id` FOREIGN KEY (`peak_demand_id`) REFERENCES `forecast`.`peak_demand` (`peak_demand_id`);

-- ========= trading --> generation (2) =========
ALTER TABLE `trading`.`ppa` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_generating_unit_id`;
ALTER TABLE `trading`.`ppa` ADD CONSTRAINT `fk_trading_ppa_generating_unit_id` FOREIGN KEY (`generating_unit_id`) REFERENCES `generation`.`generating_unit` (`generating_unit_id`);

ALTER TABLE `trading`.`ppa_delivery` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_delivery_output_telemetry_id`;
ALTER TABLE `trading`.`ppa_delivery` ADD CONSTRAINT `fk_trading_ppa_delivery_output_telemetry_id` FOREIGN KEY (`output_telemetry_id`) REFERENCES `generation`.`output_telemetry` (`output_telemetry_id`);

-- ========= trading --> gis (2) =========
ALTER TABLE `trading`.`pnode` DROP CONSTRAINT IF EXISTS `fk_trading_pnode_gis_location_id`;
ALTER TABLE `trading`.`pnode` ADD CONSTRAINT `fk_trading_pnode_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `trading`.`delivery_point` DROP CONSTRAINT IF EXISTS `fk_trading_delivery_point_gis_location_id`;
ALTER TABLE `trading`.`delivery_point` ADD CONSTRAINT `fk_trading_delivery_point_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

-- ========= trading --> interconnection (6) =========
ALTER TABLE `trading`.`ppa_delivery` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_delivery_der_system_id`;
ALTER TABLE `trading`.`ppa_delivery` ADD CONSTRAINT `fk_trading_ppa_delivery_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `trading`.`market_bid` DROP CONSTRAINT IF EXISTS `fk_trading_market_bid_der_system_id`;
ALTER TABLE `trading`.`market_bid` ADD CONSTRAINT `fk_trading_market_bid_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `trading`.`market_award` DROP CONSTRAINT IF EXISTS `fk_trading_market_award_der_system_id`;
ALTER TABLE `trading`.`market_award` ADD CONSTRAINT `fk_trading_market_award_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `trading`.`rec_transaction` DROP CONSTRAINT IF EXISTS `fk_trading_rec_transaction_der_system_id`;
ALTER TABLE `trading`.`rec_transaction` ADD CONSTRAINT `fk_trading_rec_transaction_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `trading`.`ancillary_service_award` DROP CONSTRAINT IF EXISTS `fk_trading_ancillary_service_award_der_system_id`;
ALTER TABLE `trading`.`ancillary_service_award` ADD CONSTRAINT `fk_trading_ancillary_service_award_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

ALTER TABLE `trading`.`capacity_obligation` DROP CONSTRAINT IF EXISTS `fk_trading_capacity_obligation_der_system_id`;
ALTER TABLE `trading`.`capacity_obligation` ADD CONSTRAINT `fk_trading_capacity_obligation_der_system_id` FOREIGN KEY (`der_system_id`) REFERENCES `interconnection`.`der_system` (`der_system_id`);

-- ========= trading --> metering (1) =========
ALTER TABLE `trading`.`delivery_point` DROP CONSTRAINT IF EXISTS `fk_trading_delivery_point_meter_id`;
ALTER TABLE `trading`.`delivery_point` ADD CONSTRAINT `fk_trading_delivery_point_meter_id` FOREIGN KEY (`meter_id`) REFERENCES `metering`.`meter` (`meter_id`);

-- ========= trading --> outage (3) =========
ALTER TABLE `trading`.`ppa_delivery` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_delivery_event_id`;
ALTER TABLE `trading`.`ppa_delivery` ADD CONSTRAINT `fk_trading_ppa_delivery_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `trading`.`energy_schedule` DROP CONSTRAINT IF EXISTS `fk_trading_energy_schedule_event_id`;
ALTER TABLE `trading`.`energy_schedule` ADD CONSTRAINT `fk_trading_energy_schedule_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `trading`.`energy_schedule` DROP CONSTRAINT IF EXISTS `fk_trading_energy_schedule_planned_outage_window_id`;
ALTER TABLE `trading`.`energy_schedule` ADD CONSTRAINT `fk_trading_energy_schedule_planned_outage_window_id` FOREIGN KEY (`planned_outage_window_id`) REFERENCES `outage`.`planned_outage_window` (`planned_outage_window_id`);

-- ========= trading --> renewable (7) =========
ALTER TABLE `trading`.`ppa_delivery` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_delivery_ppa_contract_id`;
ALTER TABLE `trading`.`ppa_delivery` ADD CONSTRAINT `fk_trading_ppa_delivery_ppa_contract_id` FOREIGN KEY (`ppa_contract_id`) REFERENCES `renewable`.`ppa_contract` (`ppa_contract_id`);

ALTER TABLE `trading`.`market_bid` DROP CONSTRAINT IF EXISTS `fk_trading_market_bid_battery_storage_asset_id`;
ALTER TABLE `trading`.`market_bid` ADD CONSTRAINT `fk_trading_market_bid_battery_storage_asset_id` FOREIGN KEY (`battery_storage_asset_id`) REFERENCES `renewable`.`battery_storage_asset` (`battery_storage_asset_id`);

ALTER TABLE `trading`.`market_award` DROP CONSTRAINT IF EXISTS `fk_trading_market_award_battery_storage_asset_id`;
ALTER TABLE `trading`.`market_award` ADD CONSTRAINT `fk_trading_market_award_battery_storage_asset_id` FOREIGN KEY (`battery_storage_asset_id`) REFERENCES `renewable`.`battery_storage_asset` (`battery_storage_asset_id`);

ALTER TABLE `trading`.`rec_holding` DROP CONSTRAINT IF EXISTS `fk_trading_rec_holding_ppa_contract_id`;
ALTER TABLE `trading`.`rec_holding` ADD CONSTRAINT `fk_trading_rec_holding_ppa_contract_id` FOREIGN KEY (`ppa_contract_id`) REFERENCES `renewable`.`ppa_contract` (`ppa_contract_id`);

ALTER TABLE `trading`.`rec_holding` DROP CONSTRAINT IF EXISTS `fk_trading_rec_holding_renewable_rec_certificate_id`;
ALTER TABLE `trading`.`rec_holding` ADD CONSTRAINT `fk_trading_rec_holding_renewable_rec_certificate_id` FOREIGN KEY (`renewable_rec_certificate_id`) REFERENCES `renewable`.`renewable_rec_certificate` (`renewable_rec_certificate_id`);

ALTER TABLE `trading`.`rec_transaction` DROP CONSTRAINT IF EXISTS `fk_trading_rec_transaction_renewable_rec_certificate_id`;
ALTER TABLE `trading`.`rec_transaction` ADD CONSTRAINT `fk_trading_rec_transaction_renewable_rec_certificate_id` FOREIGN KEY (`renewable_rec_certificate_id`) REFERENCES `renewable`.`renewable_rec_certificate` (`renewable_rec_certificate_id`);

ALTER TABLE `trading`.`capacity_obligation` DROP CONSTRAINT IF EXISTS `fk_trading_capacity_obligation_battery_storage_asset_id`;
ALTER TABLE `trading`.`capacity_obligation` ADD CONSTRAINT `fk_trading_capacity_obligation_battery_storage_asset_id` FOREIGN KEY (`battery_storage_asset_id`) REFERENCES `renewable`.`battery_storage_asset` (`battery_storage_asset_id`);

-- ========= trading --> supply (4) =========
ALTER TABLE `trading`.`trade` DROP CONSTRAINT IF EXISTS `fk_trading_trade_vendor_id`;
ALTER TABLE `trading`.`trade` ADD CONSTRAINT `fk_trading_trade_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `trading`.`ppa` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_vendor_id`;
ALTER TABLE `trading`.`ppa` ADD CONSTRAINT `fk_trading_ppa_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `trading`.`ppa_delivery` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_delivery_vendor_id`;
ALTER TABLE `trading`.`ppa_delivery` ADD CONSTRAINT `fk_trading_ppa_delivery_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `trading`.`market_settlement` DROP CONSTRAINT IF EXISTS `fk_trading_market_settlement_vendor_id`;
ALTER TABLE `trading`.`market_settlement` ADD CONSTRAINT `fk_trading_market_settlement_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

-- ========= trading --> transmission (2) =========
ALTER TABLE `trading`.`energy_schedule` DROP CONSTRAINT IF EXISTS `fk_trading_energy_schedule_transmission_path_id`;
ALTER TABLE `trading`.`energy_schedule` ADD CONSTRAINT `fk_trading_energy_schedule_transmission_path_id` FOREIGN KEY (`transmission_path_id`) REFERENCES `transmission`.`path` (`path_id`);

ALTER TABLE `trading`.`energy_schedule` DROP CONSTRAINT IF EXISTS `fk_trading_energy_schedule_transmission_service_agreement_id`;
ALTER TABLE `trading`.`energy_schedule` ADD CONSTRAINT `fk_trading_energy_schedule_transmission_service_agreement_id` FOREIGN KEY (`transmission_service_agreement_id`) REFERENCES `transmission`.`transmission_service_agreement` (`transmission_service_agreement_id`);

-- ========= trading --> workforce (15) =========
ALTER TABLE `trading`.`trade` DROP CONSTRAINT IF EXISTS `fk_trading_trade_employee_id`;
ALTER TABLE `trading`.`trade` ADD CONSTRAINT `fk_trading_trade_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `trading`.`trading_position` DROP CONSTRAINT IF EXISTS `fk_trading_trading_position_employee_id`;
ALTER TABLE `trading`.`trading_position` ADD CONSTRAINT `fk_trading_trading_position_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `trading`.`ppa` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_ppa_created_by_user_employee_id`;
ALTER TABLE `trading`.`ppa` ADD CONSTRAINT `fk_trading_ppa_ppa_created_by_user_employee_id` FOREIGN KEY (`ppa_created_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `trading`.`ppa` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_ppa_employee_id`;
ALTER TABLE `trading`.`ppa` ADD CONSTRAINT `fk_trading_ppa_ppa_employee_id` FOREIGN KEY (`ppa_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `trading`.`ppa` DROP CONSTRAINT IF EXISTS `fk_trading_ppa_ppa_updated_by_user_employee_id`;
ALTER TABLE `trading`.`ppa` ADD CONSTRAINT `fk_trading_ppa_ppa_updated_by_user_employee_id` FOREIGN KEY (`ppa_updated_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `trading`.`market_bid` DROP CONSTRAINT IF EXISTS `fk_trading_market_bid_employee_id`;
ALTER TABLE `trading`.`market_bid` ADD CONSTRAINT `fk_trading_market_bid_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `trading`.`credit_exposure` DROP CONSTRAINT IF EXISTS `fk_trading_credit_exposure_employee_id`;
ALTER TABLE `trading`.`credit_exposure` ADD CONSTRAINT `fk_trading_credit_exposure_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `trading`.`book` DROP CONSTRAINT IF EXISTS `fk_trading_book_approver_employee_id`;
ALTER TABLE `trading`.`book` ADD CONSTRAINT `fk_trading_book_approver_employee_id` FOREIGN KEY (`approver_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `trading`.`book` DROP CONSTRAINT IF EXISTS `fk_trading_book_book_employee_id`;
ALTER TABLE `trading`.`book` ADD CONSTRAINT `fk_trading_book_book_employee_id` FOREIGN KEY (`book_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `trading`.`book` DROP CONSTRAINT IF EXISTS `fk_trading_book_book_last_modified_by_user_employee_id`;
ALTER TABLE `trading`.`book` ADD CONSTRAINT `fk_trading_book_book_last_modified_by_user_employee_id` FOREIGN KEY (`book_last_modified_by_user_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `trading`.`ferc_eqr_filing` DROP CONSTRAINT IF EXISTS `fk_trading_ferc_eqr_filing_preparer_employee_id`;
ALTER TABLE `trading`.`ferc_eqr_filing` ADD CONSTRAINT `fk_trading_ferc_eqr_filing_preparer_employee_id` FOREIGN KEY (`preparer_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `trading`.`hedge_strategy` DROP CONSTRAINT IF EXISTS `fk_trading_hedge_strategy_employee_id`;
ALTER TABLE `trading`.`hedge_strategy` ADD CONSTRAINT `fk_trading_hedge_strategy_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `trading`.`capacity_obligation` DROP CONSTRAINT IF EXISTS `fk_trading_capacity_obligation_employee_id`;
ALTER TABLE `trading`.`capacity_obligation` ADD CONSTRAINT `fk_trading_capacity_obligation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `trading`.`portfolio` DROP CONSTRAINT IF EXISTS `fk_trading_portfolio_employee_id`;
ALTER TABLE `trading`.`portfolio` ADD CONSTRAINT `fk_trading_portfolio_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `trading`.`portfolio` DROP CONSTRAINT IF EXISTS `fk_trading_portfolio_manager_employee_id`;
ALTER TABLE `trading`.`portfolio` ADD CONSTRAINT `fk_trading_portfolio_manager_employee_id` FOREIGN KEY (`manager_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

-- ========= transmission --> asset (6) =========
ALTER TABLE `transmission`.`line` DROP CONSTRAINT IF EXISTS `fk_transmission_line_registry_id`;
ALTER TABLE `transmission`.`line` ADD CONSTRAINT `fk_transmission_line_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `transmission`.`transmission_substation` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_substation_registry_id`;
ALTER TABLE `transmission`.`transmission_substation` ADD CONSTRAINT `fk_transmission_transmission_substation_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `transmission`.`power_transformer` DROP CONSTRAINT IF EXISTS `fk_transmission_power_transformer_registry_id`;
ALTER TABLE `transmission`.`power_transformer` ADD CONSTRAINT `fk_transmission_power_transformer_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `transmission`.`transmission_outage` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_outage_registry_id`;
ALTER TABLE `transmission`.`transmission_outage` ADD CONSTRAINT `fk_transmission_transmission_outage_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `transmission`.`protection_device` DROP CONSTRAINT IF EXISTS `fk_transmission_protection_device_registry_id`;
ALTER TABLE `transmission`.`protection_device` ADD CONSTRAINT `fk_transmission_protection_device_registry_id` FOREIGN KEY (`registry_id`) REFERENCES `asset`.`registry` (`registry_id`);

ALTER TABLE `transmission`.`planning_study` DROP CONSTRAINT IF EXISTS `fk_transmission_planning_study_capital_project_id`;
ALTER TABLE `transmission`.`planning_study` ADD CONSTRAINT `fk_transmission_planning_study_capital_project_id` FOREIGN KEY (`capital_project_id`) REFERENCES `asset`.`capital_project` (`capital_project_id`);

-- ========= transmission --> billing (1) =========
ALTER TABLE `transmission`.`transmission_service_agreement` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_service_agreement_billing_service_agreement_id`;
ALTER TABLE `transmission`.`transmission_service_agreement` ADD CONSTRAINT `fk_transmission_transmission_service_agreement_billing_service_agreement_id` FOREIGN KEY (`billing_service_agreement_id`) REFERENCES `billing`.`billing_service_agreement` (`billing_service_agreement_id`);

-- ========= transmission --> compliance (13) =========
ALTER TABLE `transmission`.`line` DROP CONSTRAINT IF EXISTS `fk_transmission_line_nerc_cip_asset_id`;
ALTER TABLE `transmission`.`line` ADD CONSTRAINT `fk_transmission_line_nerc_cip_asset_id` FOREIGN KEY (`nerc_cip_asset_id`) REFERENCES `compliance`.`nerc_cip_asset` (`nerc_cip_asset_id`);

ALTER TABLE `transmission`.`transmission_substation` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_substation_nerc_cip_asset_id`;
ALTER TABLE `transmission`.`transmission_substation` ADD CONSTRAINT `fk_transmission_transmission_substation_nerc_cip_asset_id` FOREIGN KEY (`nerc_cip_asset_id`) REFERENCES `compliance`.`nerc_cip_asset` (`nerc_cip_asset_id`);

ALTER TABLE `transmission`.`power_transformer` DROP CONSTRAINT IF EXISTS `fk_transmission_power_transformer_nerc_cip_asset_id`;
ALTER TABLE `transmission`.`power_transformer` ADD CONSTRAINT `fk_transmission_power_transformer_nerc_cip_asset_id` FOREIGN KEY (`nerc_cip_asset_id`) REFERENCES `compliance`.`nerc_cip_asset` (`nerc_cip_asset_id`);

ALTER TABLE `transmission`.`path` DROP CONSTRAINT IF EXISTS `fk_transmission_path_obligation_id`;
ALTER TABLE `transmission`.`path` ADD CONSTRAINT `fk_transmission_path_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `compliance`.`obligation` (`obligation_id`);

ALTER TABLE `transmission`.`atc_calculation` DROP CONSTRAINT IF EXISTS `fk_transmission_atc_calculation_audit_id`;
ALTER TABLE `transmission`.`atc_calculation` ADD CONSTRAINT `fk_transmission_atc_calculation_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `compliance`.`audit` (`audit_id`);

ALTER TABLE `transmission`.`transmission_service_agreement` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_service_agreement_regulatory_filing_id`;
ALTER TABLE `transmission`.`transmission_service_agreement` ADD CONSTRAINT `fk_transmission_transmission_service_agreement_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

ALTER TABLE `transmission`.`ftr_position` DROP CONSTRAINT IF EXISTS `fk_transmission_ftr_position_ferc_market_report_id`;
ALTER TABLE `transmission`.`ftr_position` ADD CONSTRAINT `fk_transmission_ftr_position_ferc_market_report_id` FOREIGN KEY (`ferc_market_report_id`) REFERENCES `compliance`.`ferc_market_report` (`ferc_market_report_id`);

ALTER TABLE `transmission`.`congestion_event` DROP CONSTRAINT IF EXISTS `fk_transmission_congestion_event_ferc_market_report_id`;
ALTER TABLE `transmission`.`congestion_event` ADD CONSTRAINT `fk_transmission_congestion_event_ferc_market_report_id` FOREIGN KEY (`ferc_market_report_id`) REFERENCES `compliance`.`ferc_market_report` (`ferc_market_report_id`);

ALTER TABLE `transmission`.`transmission_outage` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_outage_regulatory_correspondence_id`;
ALTER TABLE `transmission`.`transmission_outage` ADD CONSTRAINT `fk_transmission_transmission_outage_regulatory_correspondence_id` FOREIGN KEY (`regulatory_correspondence_id`) REFERENCES `compliance`.`regulatory_correspondence` (`regulatory_correspondence_id`);

ALTER TABLE `transmission`.`transmission_outage` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_outage_self_report_id`;
ALTER TABLE `transmission`.`transmission_outage` ADD CONSTRAINT `fk_transmission_transmission_outage_self_report_id` FOREIGN KEY (`self_report_id`) REFERENCES `compliance`.`self_report` (`self_report_id`);

ALTER TABLE `transmission`.`protection_device` DROP CONSTRAINT IF EXISTS `fk_transmission_protection_device_nerc_cip_asset_id`;
ALTER TABLE `transmission`.`protection_device` ADD CONSTRAINT `fk_transmission_protection_device_nerc_cip_asset_id` FOREIGN KEY (`nerc_cip_asset_id`) REFERENCES `compliance`.`nerc_cip_asset` (`nerc_cip_asset_id`);

ALTER TABLE `transmission`.`planning_study` DROP CONSTRAINT IF EXISTS `fk_transmission_planning_study_irp_filing_id`;
ALTER TABLE `transmission`.`planning_study` ADD CONSTRAINT `fk_transmission_planning_study_irp_filing_id` FOREIGN KEY (`irp_filing_id`) REFERENCES `compliance`.`irp_filing` (`irp_filing_id`);

ALTER TABLE `transmission`.`planning_study` DROP CONSTRAINT IF EXISTS `fk_transmission_planning_study_regulatory_filing_id`;
ALTER TABLE `transmission`.`planning_study` ADD CONSTRAINT `fk_transmission_planning_study_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `compliance`.`regulatory_filing` (`regulatory_filing_id`);

-- ========= transmission --> finance (14) =========
ALTER TABLE `transmission`.`line` DROP CONSTRAINT IF EXISTS `fk_transmission_line_cost_center_id`;
ALTER TABLE `transmission`.`line` ADD CONSTRAINT `fk_transmission_line_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `transmission`.`line` DROP CONSTRAINT IF EXISTS `fk_transmission_line_fixed_asset_id`;
ALTER TABLE `transmission`.`line` ADD CONSTRAINT `fk_transmission_line_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `finance`.`fixed_asset` (`fixed_asset_id`);

ALTER TABLE `transmission`.`transmission_substation` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_substation_cost_center_id`;
ALTER TABLE `transmission`.`transmission_substation` ADD CONSTRAINT `fk_transmission_transmission_substation_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `transmission`.`power_transformer` DROP CONSTRAINT IF EXISTS `fk_transmission_power_transformer_fixed_asset_id`;
ALTER TABLE `transmission`.`power_transformer` ADD CONSTRAINT `fk_transmission_power_transformer_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `finance`.`fixed_asset` (`fixed_asset_id`);

ALTER TABLE `transmission`.`atc_calculation` DROP CONSTRAINT IF EXISTS `fk_transmission_atc_calculation_profit_center_id`;
ALTER TABLE `transmission`.`atc_calculation` ADD CONSTRAINT `fk_transmission_atc_calculation_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `transmission`.`transmission_service_agreement` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_service_agreement_receivable_id`;
ALTER TABLE `transmission`.`transmission_service_agreement` ADD CONSTRAINT `fk_transmission_transmission_service_agreement_receivable_id` FOREIGN KEY (`receivable_id`) REFERENCES `finance`.`receivable` (`receivable_id`);

ALTER TABLE `transmission`.`ftr_position` DROP CONSTRAINT IF EXISTS `fk_transmission_ftr_position_profit_center_id`;
ALTER TABLE `transmission`.`ftr_position` ADD CONSTRAINT `fk_transmission_ftr_position_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `transmission`.`congestion_event` DROP CONSTRAINT IF EXISTS `fk_transmission_congestion_event_profit_center_id`;
ALTER TABLE `transmission`.`congestion_event` ADD CONSTRAINT `fk_transmission_congestion_event_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `finance`.`profit_center` (`profit_center_id`);

ALTER TABLE `transmission`.`transmission_outage` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_outage_cost_center_id`;
ALTER TABLE `transmission`.`transmission_outage` ADD CONSTRAINT `fk_transmission_transmission_outage_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `transmission`.`transmission_outage` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_outage_internal_order_id`;
ALTER TABLE `transmission`.`transmission_outage` ADD CONSTRAINT `fk_transmission_transmission_outage_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `finance`.`internal_order` (`internal_order_id`);

ALTER TABLE `transmission`.`protection_device` DROP CONSTRAINT IF EXISTS `fk_transmission_protection_device_fixed_asset_id`;
ALTER TABLE `transmission`.`protection_device` ADD CONSTRAINT `fk_transmission_protection_device_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `finance`.`fixed_asset` (`fixed_asset_id`);

ALTER TABLE `transmission`.`transmission_customer` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_customer_cost_center_id`;
ALTER TABLE `transmission`.`transmission_customer` ADD CONSTRAINT `fk_transmission_transmission_customer_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `transmission`.`planning_study` DROP CONSTRAINT IF EXISTS `fk_transmission_planning_study_capex_project_id`;
ALTER TABLE `transmission`.`planning_study` ADD CONSTRAINT `fk_transmission_planning_study_capex_project_id` FOREIGN KEY (`capex_project_id`) REFERENCES `finance`.`capex_project` (`capex_project_id`);

ALTER TABLE `transmission`.`right_of_way_corridor` DROP CONSTRAINT IF EXISTS `fk_transmission_right_of_way_corridor_legal_entity_id`;
ALTER TABLE `transmission`.`right_of_way_corridor` ADD CONSTRAINT `fk_transmission_right_of_way_corridor_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `finance`.`legal_entity` (`legal_entity_id`);

-- ========= transmission --> forecast (6) =========
ALTER TABLE `transmission`.`path` DROP CONSTRAINT IF EXISTS `fk_transmission_path_load_id`;
ALTER TABLE `transmission`.`path` ADD CONSTRAINT `fk_transmission_path_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `transmission`.`atc_calculation` DROP CONSTRAINT IF EXISTS `fk_transmission_atc_calculation_load_id`;
ALTER TABLE `transmission`.`atc_calculation` ADD CONSTRAINT `fk_transmission_atc_calculation_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `transmission`.`transmission_service_request` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_service_request_load_id`;
ALTER TABLE `transmission`.`transmission_service_request` ADD CONSTRAINT `fk_transmission_transmission_service_request_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `transmission`.`ftr_position` DROP CONSTRAINT IF EXISTS `fk_transmission_ftr_position_energy_price_id`;
ALTER TABLE `transmission`.`ftr_position` ADD CONSTRAINT `fk_transmission_ftr_position_energy_price_id` FOREIGN KEY (`energy_price_id`) REFERENCES `forecast`.`energy_price` (`energy_price_id`);

ALTER TABLE `transmission`.`congestion_event` DROP CONSTRAINT IF EXISTS `fk_transmission_congestion_event_energy_price_id`;
ALTER TABLE `transmission`.`congestion_event` ADD CONSTRAINT `fk_transmission_congestion_event_energy_price_id` FOREIGN KEY (`energy_price_id`) REFERENCES `forecast`.`energy_price` (`energy_price_id`);

ALTER TABLE `transmission`.`planning_study` DROP CONSTRAINT IF EXISTS `fk_transmission_planning_study_irp_scenario_id`;
ALTER TABLE `transmission`.`planning_study` ADD CONSTRAINT `fk_transmission_planning_study_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

-- ========= transmission --> gis (7) =========
ALTER TABLE `transmission`.`line` DROP CONSTRAINT IF EXISTS `fk_transmission_line_gis_location_id`;
ALTER TABLE `transmission`.`line` ADD CONSTRAINT `fk_transmission_line_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `transmission`.`transmission_substation` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_substation_gis_location_id`;
ALTER TABLE `transmission`.`transmission_substation` ADD CONSTRAINT `fk_transmission_transmission_substation_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `transmission`.`power_transformer` DROP CONSTRAINT IF EXISTS `fk_transmission_power_transformer_gis_location_id`;
ALTER TABLE `transmission`.`power_transformer` ADD CONSTRAINT `fk_transmission_power_transformer_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `transmission`.`protection_device` DROP CONSTRAINT IF EXISTS `fk_transmission_protection_device_gis_location_id`;
ALTER TABLE `transmission`.`protection_device` ADD CONSTRAINT `fk_transmission_protection_device_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `transmission`.`flowgate` DROP CONSTRAINT IF EXISTS `fk_transmission_flowgate_gis_location_id`;
ALTER TABLE `transmission`.`flowgate` ADD CONSTRAINT `fk_transmission_flowgate_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `transmission`.`pnode` DROP CONSTRAINT IF EXISTS `fk_transmission_pnode_gis_location_id`;
ALTER TABLE `transmission`.`pnode` ADD CONSTRAINT `fk_transmission_pnode_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `transmission`.`right_of_way_corridor` DROP CONSTRAINT IF EXISTS `fk_transmission_right_of_way_corridor_gis_location_id`;
ALTER TABLE `transmission`.`right_of_way_corridor` ADD CONSTRAINT `fk_transmission_right_of_way_corridor_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

-- ========= transmission --> grid (7) =========
ALTER TABLE `transmission`.`transmission_substation` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_substation_ems_node_id`;
ALTER TABLE `transmission`.`transmission_substation` ADD CONSTRAINT `fk_transmission_transmission_substation_ems_node_id` FOREIGN KEY (`ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `transmission`.`atc_calculation` DROP CONSTRAINT IF EXISTS `fk_transmission_atc_calculation_state_estimation_run_id`;
ALTER TABLE `transmission`.`atc_calculation` ADD CONSTRAINT `fk_transmission_atc_calculation_state_estimation_run_id` FOREIGN KEY (`state_estimation_run_id`) REFERENCES `grid`.`state_estimation_run` (`state_estimation_run_id`);

ALTER TABLE `transmission`.`transmission_service_request` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_service_request_primary_transmission_ems_node_id`;
ALTER TABLE `transmission`.`transmission_service_request` ADD CONSTRAINT `fk_transmission_transmission_service_request_primary_transmission_ems_node_id` FOREIGN KEY (`primary_transmission_ems_node_id`) REFERENCES `grid`.`ems_node` (`ems_node_id`);

ALTER TABLE `transmission`.`congestion_event` DROP CONSTRAINT IF EXISTS `fk_transmission_congestion_event_contingency_element_id`;
ALTER TABLE `transmission`.`congestion_event` ADD CONSTRAINT `fk_transmission_congestion_event_contingency_element_id` FOREIGN KEY (`contingency_element_id`) REFERENCES `grid`.`contingency_element` (`contingency_element_id`);

ALTER TABLE `transmission`.`transmission_outage` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_outage_ems_alarm_id`;
ALTER TABLE `transmission`.`transmission_outage` ADD CONSTRAINT `fk_transmission_transmission_outage_ems_alarm_id` FOREIGN KEY (`ems_alarm_id`) REFERENCES `grid`.`ems_alarm` (`ems_alarm_id`);

ALTER TABLE `transmission`.`transmission_switching_order` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_switching_order_pre_switching_state_estimation_run_id`;
ALTER TABLE `transmission`.`transmission_switching_order` ADD CONSTRAINT `fk_transmission_transmission_switching_order_pre_switching_state_estimation_run_id` FOREIGN KEY (`pre_switching_state_estimation_run_id`) REFERENCES `grid`.`state_estimation_run` (`state_estimation_run_id`);

ALTER TABLE `transmission`.`protection_device` DROP CONSTRAINT IF EXISTS `fk_transmission_protection_device_scada_point_id`;
ALTER TABLE `transmission`.`protection_device` ADD CONSTRAINT `fk_transmission_protection_device_scada_point_id` FOREIGN KEY (`scada_point_id`) REFERENCES `grid`.`scada_point` (`scada_point_id`);

-- ========= transmission --> outage (6) =========
ALTER TABLE `transmission`.`atc_calculation` DROP CONSTRAINT IF EXISTS `fk_transmission_atc_calculation_triggering_outage_event_id`;
ALTER TABLE `transmission`.`atc_calculation` ADD CONSTRAINT `fk_transmission_atc_calculation_triggering_outage_event_id` FOREIGN KEY (`triggering_outage_event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `transmission`.`congestion_event` DROP CONSTRAINT IF EXISTS `fk_transmission_congestion_event_causal_outage_event_id`;
ALTER TABLE `transmission`.`congestion_event` ADD CONSTRAINT `fk_transmission_congestion_event_causal_outage_event_id` FOREIGN KEY (`causal_outage_event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `transmission`.`congestion_event` DROP CONSTRAINT IF EXISTS `fk_transmission_congestion_event_ems_event_id`;
ALTER TABLE `transmission`.`congestion_event` ADD CONSTRAINT `fk_transmission_congestion_event_ems_event_id` FOREIGN KEY (`ems_event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `transmission`.`transmission_outage` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_outage_event_id`;
ALTER TABLE `transmission`.`transmission_outage` ADD CONSTRAINT `fk_transmission_transmission_outage_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `transmission`.`transmission_outage` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_outage_storm_event_id`;
ALTER TABLE `transmission`.`transmission_outage` ADD CONSTRAINT `fk_transmission_transmission_outage_storm_event_id` FOREIGN KEY (`storm_event_id`) REFERENCES `outage`.`storm_event` (`storm_event_id`);

ALTER TABLE `transmission`.`transmission_switching_order` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_switching_order_outage_switching_order_id`;
ALTER TABLE `transmission`.`transmission_switching_order` ADD CONSTRAINT `fk_transmission_transmission_switching_order_outage_switching_order_id` FOREIGN KEY (`outage_switching_order_id`) REFERENCES `outage`.`outage_switching_order` (`outage_switching_order_id`);

-- ========= transmission --> renewable (2) =========
ALTER TABLE `transmission`.`ftr_position` DROP CONSTRAINT IF EXISTS `fk_transmission_ftr_position_hedged_ppa_contract_id`;
ALTER TABLE `transmission`.`ftr_position` ADD CONSTRAINT `fk_transmission_ftr_position_hedged_ppa_contract_id` FOREIGN KEY (`hedged_ppa_contract_id`) REFERENCES `renewable`.`ppa_contract` (`ppa_contract_id`);

ALTER TABLE `transmission`.`planning_study` DROP CONSTRAINT IF EXISTS `fk_transmission_planning_study_evaluated_interconnection_queue_id`;
ALTER TABLE `transmission`.`planning_study` ADD CONSTRAINT `fk_transmission_planning_study_evaluated_interconnection_queue_id` FOREIGN KEY (`evaluated_interconnection_queue_id`) REFERENCES `renewable`.`interconnection_queue` (`interconnection_queue_id`);

-- ========= transmission --> supply (9) =========
ALTER TABLE `transmission`.`line` DROP CONSTRAINT IF EXISTS `fk_transmission_line_conductor_material_master_id`;
ALTER TABLE `transmission`.`line` ADD CONSTRAINT `fk_transmission_line_conductor_material_master_id` FOREIGN KEY (`conductor_material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `transmission`.`power_transformer` DROP CONSTRAINT IF EXISTS `fk_transmission_power_transformer_material_master_id`;
ALTER TABLE `transmission`.`power_transformer` ADD CONSTRAINT `fk_transmission_power_transformer_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `transmission`.`transmission_service_agreement` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_service_agreement_generator_fuel_supply_contract_id`;
ALTER TABLE `transmission`.`transmission_service_agreement` ADD CONSTRAINT `fk_transmission_transmission_service_agreement_generator_fuel_supply_contract_id` FOREIGN KEY (`generator_fuel_supply_contract_id`) REFERENCES `supply`.`fuel_supply_contract` (`fuel_supply_contract_id`);

ALTER TABLE `transmission`.`transmission_outage` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_outage_restoration_warehouse_id`;
ALTER TABLE `transmission`.`transmission_outage` ADD CONSTRAINT `fk_transmission_transmission_outage_restoration_warehouse_id` FOREIGN KEY (`restoration_warehouse_id`) REFERENCES `supply`.`warehouse` (`warehouse_id`);

ALTER TABLE `transmission`.`transmission_switching_order` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_switching_order_goods_issue_id`;
ALTER TABLE `transmission`.`transmission_switching_order` ADD CONSTRAINT `fk_transmission_transmission_switching_order_goods_issue_id` FOREIGN KEY (`goods_issue_id`) REFERENCES `supply`.`goods_issue` (`goods_issue_id`);

ALTER TABLE `transmission`.`protection_device` DROP CONSTRAINT IF EXISTS `fk_transmission_protection_device_material_master_id`;
ALTER TABLE `transmission`.`protection_device` ADD CONSTRAINT `fk_transmission_protection_device_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `supply`.`material_master` (`material_master_id`);

ALTER TABLE `transmission`.`planning_study` DROP CONSTRAINT IF EXISTS `fk_transmission_planning_study_equipment_supplier_contract_id`;
ALTER TABLE `transmission`.`planning_study` ADD CONSTRAINT `fk_transmission_planning_study_equipment_supplier_contract_id` FOREIGN KEY (`equipment_supplier_contract_id`) REFERENCES `supply`.`supplier_contract` (`supplier_contract_id`);

ALTER TABLE `transmission`.`transformer_vendor_service` DROP CONSTRAINT IF EXISTS `fk_transmission_transformer_vendor_service_vendor_id`;
ALTER TABLE `transmission`.`transformer_vendor_service` ADD CONSTRAINT `fk_transmission_transformer_vendor_service_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

ALTER TABLE `transmission`.`substation_maintenance_contract` DROP CONSTRAINT IF EXISTS `fk_transmission_substation_maintenance_contract_vendor_id`;
ALTER TABLE `transmission`.`substation_maintenance_contract` ADD CONSTRAINT `fk_transmission_substation_maintenance_contract_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `supply`.`vendor` (`vendor_id`);

-- ========= transmission --> trading (8) =========
ALTER TABLE `transmission`.`atc_calculation` DROP CONSTRAINT IF EXISTS `fk_transmission_atc_calculation_trading_position_id`;
ALTER TABLE `transmission`.`atc_calculation` ADD CONSTRAINT `fk_transmission_atc_calculation_trading_position_id` FOREIGN KEY (`trading_position_id`) REFERENCES `trading`.`trading_position` (`trading_position_id`);

ALTER TABLE `transmission`.`transmission_service_request` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_service_request_requestor_counterparty_id`;
ALTER TABLE `transmission`.`transmission_service_request` ADD CONSTRAINT `fk_transmission_transmission_service_request_requestor_counterparty_id` FOREIGN KEY (`requestor_counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `transmission`.`ftr_position` DROP CONSTRAINT IF EXISTS `fk_transmission_ftr_position_ftr_holding_id`;
ALTER TABLE `transmission`.`ftr_position` ADD CONSTRAINT `fk_transmission_ftr_position_ftr_holding_id` FOREIGN KEY (`ftr_holding_id`) REFERENCES `trading`.`ftr_holding` (`ftr_holding_id`);

ALTER TABLE `transmission`.`congestion_event` DROP CONSTRAINT IF EXISTS `fk_transmission_congestion_event_ftr_holding_id`;
ALTER TABLE `transmission`.`congestion_event` ADD CONSTRAINT `fk_transmission_congestion_event_ftr_holding_id` FOREIGN KEY (`ftr_holding_id`) REFERENCES `trading`.`ftr_holding` (`ftr_holding_id`);

ALTER TABLE `transmission`.`transmission_customer` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_customer_counterparty_id`;
ALTER TABLE `transmission`.`transmission_customer` ADD CONSTRAINT `fk_transmission_transmission_customer_counterparty_id` FOREIGN KEY (`counterparty_id`) REFERENCES `trading`.`counterparty` (`counterparty_id`);

ALTER TABLE `transmission`.`planning_study` DROP CONSTRAINT IF EXISTS `fk_transmission_planning_study_hedge_strategy_id`;
ALTER TABLE `transmission`.`planning_study` ADD CONSTRAINT `fk_transmission_planning_study_hedge_strategy_id` FOREIGN KEY (`hedge_strategy_id`) REFERENCES `trading`.`hedge_strategy` (`hedge_strategy_id`);

ALTER TABLE `transmission`.`constraint` DROP CONSTRAINT IF EXISTS `fk_transmission_constraint_market_participant_id`;
ALTER TABLE `transmission`.`constraint` ADD CONSTRAINT `fk_transmission_constraint_market_participant_id` FOREIGN KEY (`market_participant_id`) REFERENCES `trading`.`market_participant` (`market_participant_id`);

ALTER TABLE `transmission`.`pnode` DROP CONSTRAINT IF EXISTS `fk_transmission_pnode_pnode_id`;
ALTER TABLE `transmission`.`pnode` ADD CONSTRAINT `fk_transmission_pnode_pnode_id` FOREIGN KEY (`pnode_id`) REFERENCES `trading`.`pnode` (`pnode_id`);

-- ========= transmission --> workforce (10) =========
ALTER TABLE `transmission`.`line` DROP CONSTRAINT IF EXISTS `fk_transmission_line_rating_approving_engineer_employee_id`;
ALTER TABLE `transmission`.`line` ADD CONSTRAINT `fk_transmission_line_rating_approving_engineer_employee_id` FOREIGN KEY (`rating_approving_engineer_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `transmission`.`power_transformer` DROP CONSTRAINT IF EXISTS `fk_transmission_power_transformer_responsible_engineer_employee_id`;
ALTER TABLE `transmission`.`power_transformer` ADD CONSTRAINT `fk_transmission_power_transformer_responsible_engineer_employee_id` FOREIGN KEY (`responsible_engineer_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `transmission`.`atc_calculation` DROP CONSTRAINT IF EXISTS `fk_transmission_atc_calculation_primary_atc_employee_id`;
ALTER TABLE `transmission`.`atc_calculation` ADD CONSTRAINT `fk_transmission_atc_calculation_primary_atc_employee_id` FOREIGN KEY (`primary_atc_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `transmission`.`transmission_outage` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_outage_crew_id`;
ALTER TABLE `transmission`.`transmission_outage` ADD CONSTRAINT `fk_transmission_transmission_outage_crew_id` FOREIGN KEY (`crew_id`) REFERENCES `workforce`.`crew` (`crew_id`);

ALTER TABLE `transmission`.`transmission_switching_order` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_switching_order_employee_id`;
ALTER TABLE `transmission`.`transmission_switching_order` ADD CONSTRAINT `fk_transmission_transmission_switching_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `transmission`.`transmission_switching_order` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_switching_order_primary_transmission_employee_id`;
ALTER TABLE `transmission`.`transmission_switching_order` ADD CONSTRAINT `fk_transmission_transmission_switching_order_primary_transmission_employee_id` FOREIGN KEY (`primary_transmission_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `transmission`.`transmission_switching_order` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_switching_order_tertiary_transmission_verified_by_operator_employee_id`;
ALTER TABLE `transmission`.`transmission_switching_order` ADD CONSTRAINT `fk_transmission_transmission_switching_order_tertiary_transmission_verified_by_operator_employee_id` FOREIGN KEY (`tertiary_transmission_verified_by_operator_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `transmission`.`protection_device` DROP CONSTRAINT IF EXISTS `fk_transmission_protection_device_test_technician_employee_id`;
ALTER TABLE `transmission`.`protection_device` ADD CONSTRAINT `fk_transmission_protection_device_test_technician_employee_id` FOREIGN KEY (`test_technician_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `transmission`.`transmission_customer` DROP CONSTRAINT IF EXISTS `fk_transmission_transmission_customer_account_manager_employee_id`;
ALTER TABLE `transmission`.`transmission_customer` ADD CONSTRAINT `fk_transmission_transmission_customer_account_manager_employee_id` FOREIGN KEY (`account_manager_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

ALTER TABLE `transmission`.`planning_study` DROP CONSTRAINT IF EXISTS `fk_transmission_planning_study_lead_engineer_employee_id`;
ALTER TABLE `transmission`.`planning_study` ADD CONSTRAINT `fk_transmission_planning_study_lead_engineer_employee_id` FOREIGN KEY (`lead_engineer_employee_id`) REFERENCES `workforce`.`employee` (`employee_id`);

-- ========= workforce --> asset (7) =========
ALTER TABLE `workforce`.`safety_incident` DROP CONSTRAINT IF EXISTS `fk_workforce_safety_incident_work_order_id`;
ALTER TABLE `workforce`.`safety_incident` ADD CONSTRAINT `fk_workforce_safety_incident_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `workforce`.`safety_training` DROP CONSTRAINT IF EXISTS `fk_workforce_safety_training_work_order_id`;
ALTER TABLE `workforce`.`safety_training` ADD CONSTRAINT `fk_workforce_safety_training_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `workforce`.`shift_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_shift_assignment_work_order_id`;
ALTER TABLE `workforce`.`shift_assignment` ADD CONSTRAINT `fk_workforce_shift_assignment_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `workforce`.`time_entry` DROP CONSTRAINT IF EXISTS `fk_workforce_time_entry_project_id`;
ALTER TABLE `workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_project_id` FOREIGN KEY (`project_id`) REFERENCES `asset`.`capital_project` (`capital_project_id`);

ALTER TABLE `workforce`.`time_entry` DROP CONSTRAINT IF EXISTS `fk_workforce_time_entry_work_order_id`;
ALTER TABLE `workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

ALTER TABLE `workforce`.`labor_cost_allocation` DROP CONSTRAINT IF EXISTS `fk_workforce_labor_cost_allocation_capital_project_id`;
ALTER TABLE `workforce`.`labor_cost_allocation` ADD CONSTRAINT `fk_workforce_labor_cost_allocation_capital_project_id` FOREIGN KEY (`capital_project_id`) REFERENCES `asset`.`capital_project` (`capital_project_id`);

ALTER TABLE `workforce`.`labor_cost_allocation` DROP CONSTRAINT IF EXISTS `fk_workforce_labor_cost_allocation_work_order_id`;
ALTER TABLE `workforce`.`labor_cost_allocation` ADD CONSTRAINT `fk_workforce_labor_cost_allocation_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `asset`.`work_order` (`work_order_id`);

-- ========= workforce --> compliance (2) =========
ALTER TABLE `workforce`.`safety_training` DROP CONSTRAINT IF EXISTS `fk_workforce_safety_training_training_program_id`;
ALTER TABLE `workforce`.`safety_training` ADD CONSTRAINT `fk_workforce_safety_training_training_program_id` FOREIGN KEY (`training_program_id`) REFERENCES `compliance`.`program` (`program_id`);

ALTER TABLE `workforce`.`nerc_cip_access` DROP CONSTRAINT IF EXISTS `fk_workforce_nerc_cip_access_nerc_cip_asset_id`;
ALTER TABLE `workforce`.`nerc_cip_access` ADD CONSTRAINT `fk_workforce_nerc_cip_access_nerc_cip_asset_id` FOREIGN KEY (`nerc_cip_asset_id`) REFERENCES `compliance`.`nerc_cip_asset` (`nerc_cip_asset_id`);

-- ========= workforce --> customer (1) =========
ALTER TABLE `workforce`.`nerc_cip_access` DROP CONSTRAINT IF EXISTS `fk_workforce_nerc_cip_access_logical_access_account_id`;
ALTER TABLE `workforce`.`nerc_cip_access` ADD CONSTRAINT `fk_workforce_nerc_cip_access_logical_access_account_id` FOREIGN KEY (`logical_access_account_id`) REFERENCES `customer`.`account` (`account_id`);

-- ========= workforce --> finance (6) =========
ALTER TABLE `workforce`.`shift_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_shift_assignment_cost_center_id`;
ALTER TABLE `workforce`.`shift_assignment` ADD CONSTRAINT `fk_workforce_shift_assignment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `workforce`.`time_entry` DROP CONSTRAINT IF EXISTS `fk_workforce_time_entry_cost_center_id`;
ALTER TABLE `workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `workforce`.`contractor_worker` DROP CONSTRAINT IF EXISTS `fk_workforce_contractor_worker_cost_center_id`;
ALTER TABLE `workforce`.`contractor_worker` ADD CONSTRAINT `fk_workforce_contractor_worker_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `workforce`.`labor_cost_allocation` DROP CONSTRAINT IF EXISTS `fk_workforce_labor_cost_allocation_cost_center_id`;
ALTER TABLE `workforce`.`labor_cost_allocation` ADD CONSTRAINT `fk_workforce_labor_cost_allocation_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `workforce`.`mutual_aid_deployment` DROP CONSTRAINT IF EXISTS `fk_workforce_mutual_aid_deployment_cost_center_id`;
ALTER TABLE `workforce`.`mutual_aid_deployment` ADD CONSTRAINT `fk_workforce_mutual_aid_deployment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `finance`.`cost_center` (`cost_center_id`);

ALTER TABLE `workforce`.`project_assignment` DROP CONSTRAINT IF EXISTS `fk_workforce_project_assignment_capex_project_id`;
ALTER TABLE `workforce`.`project_assignment` ADD CONSTRAINT `fk_workforce_project_assignment_capex_project_id` FOREIGN KEY (`capex_project_id`) REFERENCES `finance`.`capex_project` (`capex_project_id`);

-- ========= workforce --> forecast (1) =========
ALTER TABLE `workforce`.`scenario_participation` DROP CONSTRAINT IF EXISTS `fk_workforce_scenario_participation_irp_scenario_id`;
ALTER TABLE `workforce`.`scenario_participation` ADD CONSTRAINT `fk_workforce_scenario_participation_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

-- ========= workforce --> generation (1) =========
ALTER TABLE `workforce`.`safety_incident` DROP CONSTRAINT IF EXISTS `fk_workforce_safety_incident_power_plant_id`;
ALTER TABLE `workforce`.`safety_incident` ADD CONSTRAINT `fk_workforce_safety_incident_power_plant_id` FOREIGN KEY (`power_plant_id`) REFERENCES `generation`.`power_plant` (`power_plant_id`);

-- ========= workforce --> gis (2) =========
ALTER TABLE `workforce`.`safety_incident` DROP CONSTRAINT IF EXISTS `fk_workforce_safety_incident_gis_location_id`;
ALTER TABLE `workforce`.`safety_incident` ADD CONSTRAINT `fk_workforce_safety_incident_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `workforce`.`work_location` DROP CONSTRAINT IF EXISTS `fk_workforce_work_location_gis_location_id`;
ALTER TABLE `workforce`.`work_location` ADD CONSTRAINT `fk_workforce_work_location_gis_location_id` FOREIGN KEY (`gis_location_id`) REFERENCES `gis`.`location` (`location_id`);

-- ========= workforce --> grid (2) =========
ALTER TABLE `workforce`.`nerc_cip_access` DROP CONSTRAINT IF EXISTS `fk_workforce_nerc_cip_access_control_area_id`;
ALTER TABLE `workforce`.`nerc_cip_access` ADD CONSTRAINT `fk_workforce_nerc_cip_access_control_area_id` FOREIGN KEY (`control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

ALTER TABLE `workforce`.`mutual_aid_deployment` DROP CONSTRAINT IF EXISTS `fk_workforce_mutual_aid_deployment_receiving_control_area_id`;
ALTER TABLE `workforce`.`mutual_aid_deployment` ADD CONSTRAINT `fk_workforce_mutual_aid_deployment_receiving_control_area_id` FOREIGN KEY (`receiving_control_area_id`) REFERENCES `grid`.`control_area` (`control_area_id`);

-- ========= workforce --> outage (5) =========
ALTER TABLE `workforce`.`time_entry` DROP CONSTRAINT IF EXISTS `fk_workforce_time_entry_event_id`;
ALTER TABLE `workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `workforce`.`labor_cost_allocation` DROP CONSTRAINT IF EXISTS `fk_workforce_labor_cost_allocation_event_id`;
ALTER TABLE `workforce`.`labor_cost_allocation` ADD CONSTRAINT `fk_workforce_labor_cost_allocation_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `workforce`.`mutual_aid_deployment` DROP CONSTRAINT IF EXISTS `fk_workforce_mutual_aid_deployment_event_id`;
ALTER TABLE `workforce`.`mutual_aid_deployment` ADD CONSTRAINT `fk_workforce_mutual_aid_deployment_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

ALTER TABLE `workforce`.`workforce_crew_dispatch` DROP CONSTRAINT IF EXISTS `fk_workforce_workforce_crew_dispatch_crew_dispatch_id`;
ALTER TABLE `workforce`.`workforce_crew_dispatch` ADD CONSTRAINT `fk_workforce_workforce_crew_dispatch_crew_dispatch_id` FOREIGN KEY (`crew_dispatch_id`) REFERENCES `outage`.`outage_crew_dispatch` (`outage_crew_dispatch_id`);

ALTER TABLE `workforce`.`workforce_crew_dispatch` DROP CONSTRAINT IF EXISTS `fk_workforce_workforce_crew_dispatch_event_id`;
ALTER TABLE `workforce`.`workforce_crew_dispatch` ADD CONSTRAINT `fk_workforce_workforce_crew_dispatch_event_id` FOREIGN KEY (`event_id`) REFERENCES `outage`.`event` (`event_id`);

-- ========= workforce --> supply (2) =========
ALTER TABLE `workforce`.`crew` DROP CONSTRAINT IF EXISTS `fk_workforce_crew_contractor_company_id`;
ALTER TABLE `workforce`.`crew` ADD CONSTRAINT `fk_workforce_crew_contractor_company_id` FOREIGN KEY (`contractor_company_id`) REFERENCES `supply`.`contractor_company` (`contractor_company_id`);

ALTER TABLE `workforce`.`contractor_worker` DROP CONSTRAINT IF EXISTS `fk_workforce_contractor_worker_contractor_company_id`;
ALTER TABLE `workforce`.`contractor_worker` ADD CONSTRAINT `fk_workforce_contractor_worker_contractor_company_id` FOREIGN KEY (`contractor_company_id`) REFERENCES `supply`.`contractor_company` (`contractor_company_id`);

