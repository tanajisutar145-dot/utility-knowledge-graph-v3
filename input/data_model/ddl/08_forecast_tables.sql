-- Utility CMM-aligned Canonical Data Model (Silver) v1.0.0 | source: Databricks lakehouse-industry-data-models energy_utilities v1 ECM | generated 2026-10-13
-- 08 | Subject area: forecast | 25 tables | CIM packages: IEC61970::LoadModel; IEC61970::Core (schedules); IEC61968::Environmental
-- Standards: IEC 61968-5 (DERGroupForecast); NERC MOD-031; ISO 8601
-- Contents: tables (with PK + NOT NULL), then intra-subject-area foreign keys.
-- Unity Catalog PK/FK constraints are informational (NOT ENFORCED); NOT NULL is enforced.

USE CATALOG `utility_cmm_silver`;

-- LoadForecast  <<CIM ConformLoadSchedule : close>>
CREATE TABLE IF NOT EXISTS `forecast`.`load` (
  `load_id` BIGINT NOT NULL COMMENT 'Primary key for load',
  `baseline_forecast_load_id` BIGINT COMMENT 'Reference to the baseline or reference forecast run used for comparison or adjustment. Used in scenario analysis and variance tracking.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Load forecasts are always scoped to a control area for balancing authority operations, AGC dispatch, ACE calculation, and NERC CPS1/CPS2 compliance reporting. Control area is the fundamental operation',
  `forecast_run_id` BIGINT COMMENT 'Foreign key linking to forecast.run. Business justification: Load is the master forecast record; load_forecast_interval contains the interval-level detail. Linking load to run establishes the execution context for the forecast master. The run table captures exe',
  `load_forecast_model_id` BIGINT COMMENT 'Foreign key linking to forecast.model. Business justification: Load forecasts are produced by registered forecasting models. The model table is the authoritative source for model configuration, hyperparameters, and validation metrics. Adding forecast_model_id FK',
  `load_forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Load forecasts are spatially scoped to forecast zones. The zone table defines geographic boundaries, substation counts, and peak load characteristics. Adding forecast_zone_id FK allows retrieval of zo',
  `load_model_id` BIGINT COMMENT 'FK to forecast.model.model_id — Every load forecast run is produced by a registered forecast model. This FK enables model governance — tracing which model produced which forecast for accuracy comparison and champion/challenger evalu',
  `load_zone_id` BIGINT COMMENT 'FK to forecast.zone.zone_id — Load forecasts are scoped to a geographic forecast zone (system, zone, feeder). This FK enables zone-level aggregation and accuracy tracking.',
  `superseded_by_forecast_load_id` BIGINT COMMENT 'Reference to the forecast run that superseded this forecast. Null if this is the current active forecast. Enables forecast version lineage tracking.',
  `weather_input_id` BIGINT COMMENT 'FK to forecast.weather_input.weather_input_id — Load forecasts use weather forecast inputs as the primary exogenous variable. This FK enables traceability from forecast to weather scenario used.',
  `weather_station_id` BIGINT COMMENT 'Identifier of the primary weather station or weather data source used for this forecast run. Links to external weather data providers or internal SCADA weather sensors.',
  `approved_by` STRING COMMENT 'The name or identifier of the person or role who approved this forecast for operational use. Used for governance and accountability.',
  `approved_timestamp` TIMESTAMP COMMENT 'The timestamp when this forecast was formally approved for operational use in dispatch planning, procurement, or IRP.',
  `confidence_level` STRING COMMENT 'The probabilistic confidence level of the forecast: P10 (10th percentile, low case), P50 (median, base case), P90 (90th percentile, high case), P95, or deterministic (single-point forecast without probability distribution). Valid values: p10|p50|p90|p95|deterministic.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this forecast record was first created in the system. Audit trail for data lineage and governance.',
  `data_source` STRING COMMENT 'The primary source system or module from which this forecast was generated (e.g., EMS Load Forecasting Module, ADMS Forecasting Engine, OSIsoft PI Analytics, third-party forecasting service).',
  `day_type` STRING COMMENT 'Classification of the forecast period by day type: weekday, weekend, holiday, or special event. Used to apply appropriate load shape patterns. Valid values: weekday|weekend|holiday|special_event.',
  `demand_response_adjustment_mw` DECIMAL(12,3) COMMENT 'The forecasted reduction in load (MW) due to active Demand Response (DR) programs during the forecast period. Represents expected customer participation in load curtailment programs.',
  `der_penetration_percent` DECIMAL(5,2) COMMENT 'The assumed percentage of load served by behind-the-meter Distributed Energy Resources (DER) such as rooftop solar, battery storage, and microgrids. Impacts net load forecast.',
  `economic_scenario` STRING COMMENT 'The economic growth scenario applied in long-term forecasts: base case, high growth, low growth, recession, or recovery. Used primarily in IRP and multi-year forecasts. Valid values: base|high_growth|low_growth|recession|recovery.',
  `electric_vehicle_load_mw` DECIMAL(12,3) COMMENT 'The forecasted incremental load (MW) attributable to electric vehicle charging within the forecast period. Represents EV adoption impact on load growth.',
  `energy_efficiency_adjustment_mwh` DECIMAL(12,3) COMMENT 'The forecasted reduction in energy consumption (MWh) due to energy efficiency programs and measures implemented since the baseline forecast. Reflects cumulative EE program impacts.',
  `forecast_accuracy_mape` DECIMAL(5,2) COMMENT 'The Mean Absolute Percentage Error (MAPE) of this forecast compared to actual metered load, calculated post-facto. Measures forecast accuracy for model performance tracking.',
  `forecast_bias_percent` DECIMAL(5,2) COMMENT 'The systematic bias (over-forecast or under-forecast) of this forecast as a percentage, calculated post-facto by comparing to actual load. Positive values indicate over-forecast; negative indicate under-forecast.',
  `forecast_end_timestamp` TIMESTAMP COMMENT 'The ending timestamp of the forecast target period. Defines the last interval covered by this forecast run.',
  `forecast_start_timestamp` TIMESTAMP COMMENT 'The beginning timestamp of the forecast target period for which load demand is being predicted. Represents the first interval of the forecast horizon.',
  `forecast_status` STRING COMMENT 'Current lifecycle status of the forecast run indicating its approval state and operational readiness for use in dispatch and planning decisions. Valid values: draft|pending_review|approved|published|superseded|archived.',
  `forecast_type` STRING COMMENT 'Classification of the forecast by planning horizon: short-term (intra-day to 7 days), day-ahead (next 24-48 hours), week-ahead (7-14 days), seasonal (monthly/quarterly), long-term (annual/multi-year), or IRP scenario (Integrated Resource Plan modeling). Valid values: short_term|day_ahead|week_ahead|seasonal|long_term|irp_scenario.',
  `geographic_scope` STRING COMMENT 'The geographic or network level at which the load forecast is aggregated: system-wide (entire utility), zone (load zone or pricing zone), substation, feeder (distribution circuit), service territory, or balancing authority area. Valid values: system_wide|zone|substation|feeder|service_territory|balancing_authority.',
  `interval_resolution_minutes` INT COMMENT 'The time resolution of forecast intervals in minutes (e.g., 5, 15, 60). Defines the granularity at which forecasted MW demand values are provided.',
  `model_version` STRING COMMENT 'Version identifier of the forecasting model or algorithm used to generate this forecast run. Enables traceability and model performance comparison.',
  `modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this forecast record was last modified. Audit trail for data lineage and change tracking.',
  `notes` STRING COMMENT 'Free-text notes or comments about this forecast run, including special assumptions, model adjustments, or operational context that influenced the forecast.',
  `peak_demand_mw` DECIMAL(18,3) COMMENT 'The forecasted peak load demand in megawatts (MW) for the target period. Represents the maximum expected load across all intervals in this forecast run.',
  `peak_demand_timestamp` TIMESTAMP COMMENT 'The timestamp at which the peak demand is forecasted to occur within the target period.',
  `published_timestamp` TIMESTAMP COMMENT 'The timestamp when this forecast was published and made available to downstream systems (EMS, ADMS, trading systems) for operational decision-making.',
  `season` STRING COMMENT 'The meteorological or operational season applicable to the forecast period: winter, spring, summer, or fall. Influences load shape and magnitude. Valid values: winter|spring|summer|fall.',
  `temperature_sensitivity_mw_per_degree` DECIMAL(12,6) COMMENT 'The estimated change in load demand (MW) per degree change in temperature. Represents the temperature-load correlation coefficient used in weather-adjusted forecasting.',
  `total_energy_mwh` DECIMAL(18,3) COMMENT 'The total forecasted energy consumption in megawatt-hours (MWh) across the entire forecast period. Sum of all interval forecasts.',
  `weather_scenario` STRING COMMENT 'The weather condition scenario applied in the forecast: actual (observed weather), normal (historical average), extreme heat, extreme cold, high wind, low wind, or probabilistic percentiles (P10/P50/P90). Reference-value candidates: actual|normal|extreme_heat|extreme_cold|high_wind|low_wind|p10|p50|p90.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_load` PRIMARY KEY (`load_id`)
)
USING DELTA
COMMENT 'Core master entity representing a load forecast run and its interval-level forecast values for a specific horizon (short-term, day-ahead, seasonal, or long-term). Captures forecast type, target period, geographic scope (system-wide, zone, feeder), model version, weather scenario, and approval status at the header level. Stores forecasted MW demand at each time interval (hourly, 15-minute, or 5-minute resolution) with point forecast, confidence interval bounds (P10/P50/P90), and weather-adjusted values. Serves as the authoritative record for all load forecasting activity used in dispatch planning, procurement, and IRP. Sourced from EMS/ADMS load forecasting modules and integrated with OSIsoft PI historian data. Enables comparison against actual metered load from MDM for forecast accuracy tracking. | CMM: CIM ConformLoadSchedule (close), IEC61970::LoadModel.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'LoadForecast',
  'cmm.cim.class' = 'ConformLoadSchedule',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::LoadModel',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.load'
);

-- LoadForecastInterval  <<CIM RegularTimePoint : close>>
CREATE TABLE IF NOT EXISTS `forecast`.`load_forecast_interval` (
  `load_forecast_interval_id` BIGINT NOT NULL COMMENT 'Unique identifier for each granular interval-level load forecast record. Primary key for the load forecast interval entity.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Interval-level load forecasts must reference the control area for real-time economic dispatch, unit commitment, and interchange scheduling. EMS systems use control-area-scoped interval forecasts for A',
  `load_forecast_run_id` BIGINT COMMENT 'Reference to the parent load forecast run that generated this interval forecast. Links this interval to the specific forecast execution batch, model version, and run parameters.',
  `load_id` BIGINT COMMENT 'Foreign key linking to forecast.load. Business justification: Interval records belong to a specific load forecast run; linking to load enables aggregation and eliminates redundant to_load_forecast column.',
  `meter_point_id` BIGINT COMMENT 'Foreign key linking to metering.meter_point. Business justification: Load forecast intervals are built from aggregated historical consumption at service points. Forecasters trace meter points to calibrate zone-level models and assess accuracy. Real business process: fo',
  `validated_interval_reading_id` BIGINT COMMENT 'Foreign key linking to metering.validated_interval_reading. Business justification: Forecast accuracy measurement requires comparing forecasted load to actual validated consumption at the interval level. This link enables automated forecast error calculation and model performance rep',
  `actual_load_mw` DECIMAL(12,3) COMMENT 'Actual metered load demand in megawatts for this interval, populated after the interval has occurred. Sourced from MDM interval data for forecast accuracy validation and model retraining.',
  `baseline_load_mw` DECIMAL(12,3) COMMENT 'Baseline or normal load level for this interval based on historical patterns, excluding demand response events or abnormal conditions. Used for demand response program settlement and load impact analysis.',
  `cloud_cover_forecast_percent` DECIMAL(5,2) COMMENT 'Forecasted cloud cover as a percentage of sky coverage. Impacts solar radiation and cooling load, particularly relevant for solar generation correlation.',
  `confidence_level_percent` DECIMAL(5,2) COMMENT 'Statistical confidence level for the forecast interval bounds (typically 80% or 90%). Indicates the probability that actual load will fall within the P10-P90 range.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this load forecast interval record was first created in the system. Part of standard audit trail for data lineage and compliance.',
  `data_quality_flag` STRING COMMENT 'Quality indicator for this forecast interval. Valid indicates high-confidence forecast; suspect indicates potential data quality issues; estimated indicates interpolated or imputed values; missing indicates no forecast available. Valid values: valid|suspect|estimated|missing.',
  `day_type` STRING COMMENT 'Classification of the forecast day as weekday, weekend, or holiday. Critical for load pattern recognition as commercial and industrial loads vary significantly by day type. Valid values: weekday|weekend|holiday.',
  `demand_response_adjustment_mw` DECIMAL(12,3) COMMENT 'Expected load reduction from scheduled demand response programs or events during this interval. Used for net load forecasting and resource adequacy calculations.',
  `der_adjustment_mw` DECIMAL(12,3) COMMENT 'Adjustment to the forecast for behind-the-meter distributed energy resources including rooftop solar, battery storage, and customer-sited generation. Represents net load reduction from DER output.',
  `ev_load_forecast_mw` DECIMAL(12,3) COMMENT 'Forecasted load contribution from electric vehicle charging during this interval. Tracked separately due to rapid EV adoption growth and managed charging program impacts.',
  `forecast_error_mw` DECIMAL(12,3) COMMENT 'Calculated forecast error when actual metered load becomes available. Computed as (actual_load_mw - point_forecast_mw). Used for forecast accuracy tracking and model tuning.',
  `forecast_error_percent` DECIMAL(7,4) COMMENT 'Forecast error expressed as a percentage of actual load. Calculated as ((actual_load_mw - point_forecast_mw) / actual_load_mw) * 100. Enables normalized accuracy comparison across different load levels.',
  `forecast_generation_timestamp` TIMESTAMP COMMENT 'Date and time when this forecast interval was generated by the forecasting system. Used for forecast lead time analysis and model performance evaluation.',
  `forecast_horizon_hours` INT COMMENT 'Number of hours between forecast generation time and the forecasted interval. Used for lead-time-based accuracy analysis, as forecast accuracy typically degrades with longer horizons.',
  `forecast_status` STRING COMMENT 'Current status of this forecast interval record. Preliminary forecasts may be updated as weather forecasts improve; final forecasts are locked for operational use; revised forecasts incorporate corrections; superseded forecasts have been replaced by newer runs. Valid values: preliminary|final|revised|superseded.',
  `forecast_timestamp` TIMESTAMP COMMENT 'The specific date and time for which this load forecast applies. Represents the start of the forecast interval (hourly, 15-minute, or 5-minute resolution depending on forecast granularity).',
  `forecast_type` STRING COMMENT 'Classification of the forecast horizon. Short-term supports real-time operations, day-ahead supports market bidding, week-ahead supports unit commitment, seasonal supports resource planning, and long-term supports IRP and capacity expansion. Valid values: short_term|day_ahead|week_ahead|month_ahead|seasonal|long_term.',
  `humidity_forecast_percent` DECIMAL(5,2) COMMENT 'Forecasted relative humidity as a percentage. Impacts cooling load and heat index calculations for demand forecasting.',
  `interval_duration_minutes` INT COMMENT 'Duration of the forecast interval in minutes. Common values include 60 (hourly), 15 (quarter-hourly), or 5 (five-minute) to support different operational and market requirements.',
  `model_name` STRING COMMENT 'Name or identifier of the forecasting model or algorithm used to generate this interval forecast (e.g., ARIMA, neural network, ensemble model). Enables model performance comparison and audit trail.',
  `model_version` STRING COMMENT 'Version identifier of the forecasting model used. Tracks model evolution and enables reproducibility of forecast results.',
  `notes` STRING COMMENT 'Free-text notes or comments about this forecast interval. May include explanations for unusual forecasts, data quality issues, special events, or operational context.',
  `p10_forecast_mw` DECIMAL(12,3) COMMENT 'Lower bound of the 80% confidence interval (10th percentile). Represents a conservative low-load scenario used for minimum generation planning and reserve margin calculations.',
  `p90_forecast_mw` DECIMAL(12,3) COMMENT 'Upper bound of the 80% confidence interval (90th percentile). Represents a high-load scenario used for capacity adequacy assessment and peak demand planning.',
  `peak_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether this interval falls within a defined peak demand period. Used for peak demand planning, capacity market obligations, and critical peak pricing programs.',
  `point_forecast_mw` DECIMAL(12,3) COMMENT 'The primary forecasted load demand value in megawatts for this interval. Represents the expected (P50 or median) load level used for operational dispatch and resource scheduling.',
  `season` STRING COMMENT 'Meteorological or operational season classification. Used for seasonal load pattern analysis and rate period determination. Valid values: winter|spring|summer|fall.',
  `substation_code` STRING COMMENT 'Specific substation identifier when forecast is at substation-level granularity. Null for zone-level or system-level forecasts.',
  `temperature_forecast_f` DECIMAL(5,2) COMMENT 'Forecasted ambient temperature in degrees Fahrenheit for this interval. Key weather driver for load forecasting, particularly for heating and cooling demand.',
  `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this load forecast interval record was last modified. Tracks revisions to forecasts and actual load population for accuracy tracking.',
  `weather_adjusted_forecast_mw` DECIMAL(12,3) COMMENT 'Load forecast adjusted for actual or forecasted weather conditions including temperature, humidity, wind speed, and cloud cover. Used when weather deviates significantly from normal patterns.',
  `weather_station_code` STRING COMMENT 'Identifier of the primary weather station or weather forecast grid point used for this forecast. Enables traceability of weather data sources and regional weather correlation analysis.',
  `wind_speed_forecast_mph` DECIMAL(5,2) COMMENT 'Forecasted wind speed in miles per hour. Relevant for wind chill calculations and renewable generation correlation analysis.',
  `zone_code` STRING COMMENT 'Geographic or operational zone identifier for which this forecast applies. May represent an ISO/RTO pricing zone, utility service territory, substation service area, or system-wide aggregate.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_load_forecast_interval` PRIMARY KEY (`load_forecast_interval_id`)
)
USING DELTA
COMMENT 'Granular interval-level load forecast values associated with a parent load forecast run. Stores forecasted MW demand at each time interval (hourly, 15-minute, or 5-minute resolution) for a specific zone, substation, or system aggregate. Includes point forecast, confidence interval bounds (P10/P50/P90), and weather-adjusted values. Enables comparison against actual metered load from MDM for forecast accuracy tracking. | CMM: CIM RegularTimePoint (close), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'LoadForecastInterval',
  'cmm.cim.class' = 'RegularTimePoint',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.load_forecast_interval'
);

-- ForecastGeneration  <<CIM GenUnitOpSchedule : broad>>
CREATE TABLE IF NOT EXISTS `forecast`.`forecast_generation` (
  `forecast_generation_id` BIGINT NOT NULL COMMENT 'Unique identifier for the forecast_generation data product.',
  `forecast_model_id` BIGINT COMMENT 'Foreign key linking to forecast.model. Business justification: Generation forecasts are produced by registered forecasting models. The model table is the authoritative registry for model configuration and performance metrics. Adding forecast_model_id FK allows re',
  `forecast_run_id` BIGINT COMMENT 'Foreign key linking to forecast.run. Business justification: forecast_generation is the master record for generation output forecasts; generation_forecast_interval contains interval-level detail. Linking to run establishes the execution context. The run table c',
  `generating_unit_id` BIGINT COMMENT 'Reference to the generation asset, unit, or portfolio for which this forecast was produced. Links to the asset registry for the specific generating facility or aggregated portfolio.',
  `load_id` BIGINT COMMENT 'Unique identifier for the generation forecast run. Primary key for the forecast_generation product.',
  `actual_output_mw` DECIMAL(12,3) COMMENT 'The actual measured generation output in MW for this interval, populated after the fact from OSIsoft PI telemetry. Used for forecast accuracy assessment and model tuning.',
  `ambient_temperature_c` DECIMAL(5,2) COMMENT 'The forecasted ambient temperature in degrees Celsius for this interval. Affects thermal generation efficiency and renewable output (especially solar PV).',
  `available_capacity_mw` DECIMAL(12,3) COMMENT 'The generation capacity available for this forecast interval after accounting for scheduled maintenance, forced outages, and operational constraints. Represents the maximum achievable output for this period.',
  `capacity_factor_percent` DECIMAL(5,2) COMMENT 'The ratio of forecasted output to nameplate capacity expressed as a percentage. Indicates the expected utilization level of the generation asset for this interval.',
  `created_by_user` STRING COMMENT 'The user ID or system account that created this forecast record. Used for accountability and audit purposes.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this forecast record was first created in the system. Used for audit trail and data lineage tracking.',
  `dispatch_schedule_flag` BOOLEAN COMMENT 'Indicates whether this forecast was used to create a unit commitment or dispatch schedule for operational control.',
  `forced_outage_flag` BOOLEAN COMMENT 'Indicates whether the generation asset is experiencing a forced outage during this forecast period. True if a forced outage has occurred, reducing available capacity.',
  `forecast_confidence_score` DECIMAL(5,2) COMMENT 'A confidence score (0-100) indicating the models confidence in this forecast. Higher scores indicate greater certainty; lower scores indicate higher uncertainty due to weather volatility, data quality issues, or model limitations.',
  `forecast_effective_end` TIMESTAMP COMMENT 'The end of the time period covered by this forecast. Defines the end of the forecast horizon. Nullable for open-ended long-term forecasts.',
  `forecast_effective_start` TIMESTAMP COMMENT 'The beginning of the time period covered by this forecast. Defines the start of the forecast horizon.',
  `forecast_error_mw` DECIMAL(12,3) COMMENT 'The difference between forecasted and actual output in MW (actual minus forecast). Positive values indicate under-forecast; negative values indicate over-forecast. Used for model performance evaluation.',
  `forecast_error_percent` DECIMAL(5,2) COMMENT 'The forecast error expressed as a percentage of actual output. Used for normalized accuracy comparison across different asset sizes and technologies.',
  `forecast_model_version` STRING COMMENT 'The version number of the forecasting model used. Enables tracking of model changes and performance improvements over time.',
  `forecast_run_identifier` STRING COMMENT 'Externally-known business identifier for this forecast run, typically used in operational communications and system integrations (e.g., ABB Symphony Plus run ID or OpenLink Endur forecast case name).',
  `forecast_status` STRING COMMENT 'Current lifecycle state of the forecast. Draft forecasts are under development; approved forecasts are released for operational use; active forecasts are currently in effect; superseded forecasts have been replaced by newer runs. Valid values: draft|pending_approval|approved|active|superseded|cancelled.',
  `forecast_type` STRING COMMENT 'Classification of the forecast by its planning horizon. Intraday supports real-time dispatch; day-ahead supports unit commitment and market bidding; week-ahead and longer horizons support resource adequacy and IRP (Integrated Resource Plan) scenario modeling. Reference-value candidates: intraday|day_ahead|week_ahead|month_ahead|seasonal|annual|irp_scenario.',
  `forecasted_output_mw` DECIMAL(12,3) COMMENT 'The forecasted electrical generation output in megawatts (MW) for this interval. Represents the expected generation level for the asset or portfolio at this time.',
  `forecasted_output_mwh` DECIMAL(12,3) COMMENT 'The forecasted electrical energy output in megawatt-hours (MWh) for this interval. Calculated as MW output multiplied by interval duration.',
  `fuel_availability_status` STRING COMMENT 'The current fuel availability status for this forecast period. Constrained or limited fuel availability reduces forecasted output for fuel-dependent generation technologies. Valid values: normal|constrained|limited|unavailable|not_applicable.',
  `fuel_type` STRING COMMENT 'The primary fuel source for this generation asset. Used to apply fuel availability constraints and fuel cost assumptions in the forecast model. Reference-value candidates: natural_gas|coal|nuclear|hydro|wind|solar|biomass|diesel|fuel_oil|geothermal|not_applicable.',
  `interval_duration_minutes` INT COMMENT 'The time resolution of the forecast intervals in minutes (e.g., 5, 15, 60). Determines the granularity of forecasted MW output values.',
  `interval_timestamp` TIMESTAMP COMMENT 'The specific timestamp for this forecast interval. Each row may represent one interval within the forecast horizon, or the header may aggregate multiple intervals.',
  `market_bid_flag` BOOLEAN COMMENT 'Indicates whether this forecast was used as the basis for a market bid submission to an RTO (Regional Transmission Organization) or ISO (Independent System Operator) day-ahead or real-time market.',
  `nameplate_capacity_mw` DECIMAL(12,3) COMMENT 'The maximum rated generation capacity of the asset or portfolio in MW under ideal conditions. Used as the baseline for capacity factor calculations and constraint modeling.',
  `notes` STRING COMMENT 'Free-text notes or comments about this forecast run, including assumptions, special conditions, or operational context that influenced the forecast.',
  `p10_output_mw` DECIMAL(12,3) COMMENT 'The 10th percentile probabilistic forecast bound in MW. Represents a conservative lower bound with 90% probability that actual output will exceed this value. Used for risk assessment and reserve planning.',
  `p50_output_mw` DECIMAL(12,3) COMMENT 'The 50th percentile (median) probabilistic forecast in MW. Represents the most likely generation output with equal probability of actual output being above or below this value.',
  `p90_output_mw` DECIMAL(12,3) COMMENT 'The 90th percentile probabilistic forecast bound in MW. Represents an optimistic upper bound with 90% probability that actual output will be below this value. Used for capacity planning and market bidding.',
  `ramp_rate_mw_per_minute` DECIMAL(10,3) COMMENT 'The maximum rate at which the generation asset can increase or decrease output, expressed in MW per minute. Used for AGC (Automatic Generation Control) setpoint planning and dispatch scheduling.',
  `scheduled_maintenance_flag` BOOLEAN COMMENT 'Indicates whether the generation asset has scheduled maintenance during this forecast period. True if maintenance is scheduled, reducing available capacity.',
  `solar_irradiance_w_per_m2` DECIMAL(8,2) COMMENT 'The forecasted solar irradiance in watts per square meter for this interval. Primary input for solar generation forecasts.',
  `source_system` STRING COMMENT 'The name or identifier of the source system that generated this forecast (e.g., ABB Symphony Plus, OpenLink Endur, internal forecasting platform). Used for data lineage and integration troubleshooting.',
  `technology` STRING COMMENT 'The primary generation technology type for the forecasted asset or portfolio. Used to apply technology-specific forecast models (e.g., renewable intermittency for wind/solar, fuel availability for CCGT, hydrological models for hydro). Reference-value candidates: ccgt|simple_cycle_gas|coal|nuclear|hydro|wind|solar_pv|solar_thermal|biomass|geothermal|energy_storage|other.',
  `updated_by_user` STRING COMMENT 'The user ID or system account that last modified this forecast record. Used for accountability and audit purposes.',
  `updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this forecast record was last modified. Used for audit trail and change tracking.',
  `weather_scenario` STRING COMMENT 'Identifier for the weather scenario or weather forecast model used as input to this generation forecast. Critical for renewable generation forecasts that depend on wind speed, solar irradiance, and temperature.',
  `wind_speed_mps` DECIMAL(5,2) COMMENT 'The forecasted wind speed in meters per second for this interval. Primary input for wind generation forecasts.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_forecast_generation` PRIMARY KEY (`forecast_generation_id`)
)
USING DELTA
COMMENT 'Core master entity representing a generation output forecast run and its interval-level forecast values for a specific generation asset, portfolio, or system total. Captures forecast horizon (intraday, day-ahead, week-ahead), generation technology type (CCGT, wind, solar, hydro, nuclear), fuel availability assumptions, and scheduled maintenance constraints at the header level. Stores forecasted MW output per generation unit or portfolio at each time interval, including probabilistic bounds (P10/P50/P90), ramp rate constraints, and fuel-adjusted capacity. Used by dispatch schedulers and energy traders for unit commitment, market bidding, AGC setpoint planning, and real-time dispatch scheduling. Integrates with ABB Symphony Plus and OpenLink Endur. Compared against actual generation telemetry from OSIsoft PI for model accuracy assessment. | CMM: CIM GenUnitOpSchedule (broad), IEC61970::Generation::Production.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ForecastGeneration',
  'cmm.cim.class' = 'GenUnitOpSchedule',
  'cmm.cim.match' = 'broad',
  'cmm.cim.package' = 'IEC61970::Generation::Production',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.forecast_generation'
);

-- GenerationForecastInterval  <<CIM RegularTimePoint : close>>
CREATE TABLE IF NOT EXISTS `forecast`.`generation_forecast_interval` (
  `generation_forecast_interval_id` BIGINT NOT NULL COMMENT 'Unique identifier for the generation forecast interval record. Primary key for this entity.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Generation forecasts are dispatched within control area boundaries for ACE calculation, net interchange scheduling, and frequency regulation. Control area operators use generation forecasts to plan re',
  `forecast_generation_id` BIGINT COMMENT 'Foreign key linking to forecast.forecast_generation. Business justification: Generation forecast intervals are child records of a generation forecast master; FK provides proper hierarchy.',
  `generating_unit_id` BIGINT COMMENT 'Reference to the specific generation unit or asset for which this interval forecast applies. May represent a single turbine, generator, solar array, or aggregated portfolio depending on forecast granularity.',
  `generation_forecast_run_id` BIGINT COMMENT 'Reference to the parent generation forecast run that produced this interval forecast. Links this interval to the overall forecast execution context including model version, execution timestamp, and forecast horizon.',
  `actual_mw_output` DECIMAL(12,3) COMMENT 'The actual measured generation output in megawatts for this interval, populated from SCADA telemetry or OSIsoft PI historian. Used for forecast accuracy validation and model tuning.',
  `agc_eligible_flag` BOOLEAN COMMENT 'Boolean indicator of whether this generation unit is eligible and available for Automatic Generation Control during this interval. AGC-eligible units can respond to real-time frequency regulation signals.',
  `available_capacity_mw` DECIMAL(12,3) COMMENT 'The maximum generation capacity available for this unit during the interval, accounting for planned outages, derates, and operational constraints. Represents the upper bound for feasible generation output.',
  `capacity_factor_percent` DECIMAL(5,2) COMMENT 'The forecasted capacity factor for this interval, calculated as forecast MW output divided by nameplate capacity, expressed as a percentage. Indicates the expected utilization level of the generation asset.',
  `cloud_cover_percent` DECIMAL(5,2) COMMENT 'The forecasted cloud cover as a percentage of sky coverage. Impacts solar generation forecasts and contributes to renewable intermittency modeling.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this forecast interval record was first created in the system. Supports audit trail and data lineage tracking.',
  `curtailment_risk_flag` BOOLEAN COMMENT 'Boolean indicator of whether this interval forecast is at risk of curtailment due to transmission constraints, negative pricing, or oversupply conditions. Primarily applies to renewable generation.',
  `data_quality_flag` STRING COMMENT 'Indicates the quality and reliability of the forecast data for this interval. Valid indicates high-quality forecast, estimated indicates interpolated values, missing indicates no forecast available, suspect indicates potential data issues, override indicates manual adjustment. Valid values: valid|estimated|missing|suspect|override.',
  `dispatch_priority_rank` INT COMMENT 'The relative dispatch priority ranking for this generation unit during this interval. Lower numbers indicate higher priority. Based on economic merit order, must-run status, and operational constraints.',
  `forecast_confidence_score` DECIMAL(5,2) COMMENT 'A numerical confidence score representing the forecast model\'s certainty in the predicted output, typically expressed as a percentage (0-100). Higher scores indicate greater confidence based on historical accuracy, weather data quality, and model convergence.',
  `forecast_error_mw` DECIMAL(12,3) COMMENT 'The calculated forecast error in megawatts, populated after actual generation data is available. Represents the difference between forecasted and actual output. Used for model accuracy assessment and continuous improvement.',
  `forecast_error_percent` DECIMAL(5,2) COMMENT 'The calculated forecast error expressed as a percentage of actual output. Provides a normalized accuracy metric that enables comparison across different generation units and capacity levels.',
  `forecast_horizon_hours` INT COMMENT 'The number of hours ahead from the forecast run timestamp to this interval. Represents the lead time of the forecast. Forecast accuracy typically degrades with longer horizons.',
  `forecast_model_version` STRING COMMENT 'The version identifier of the forecasting model or algorithm used to generate this interval forecast. Enables model performance tracking, A/B testing, and forecast accuracy attribution.',
  `forecast_mw_output` DECIMAL(12,3) COMMENT 'The forecasted generation output in megawatts for this interval. Represents the expected power production from the generation unit during the interval. Primary value used for unit commitment, dispatch scheduling, and AGC setpoint planning.',
  `forecast_mwh_energy` DECIMAL(12,3) COMMENT 'The forecasted energy production in megawatt-hours for this interval. Calculated as forecast MW output multiplied by interval duration. Used for energy market bidding, settlement, and resource adequacy planning.',
  `forecast_type` STRING COMMENT 'The classification of the forecast based on its time horizon and operational purpose. Day-ahead forecasts support market bidding, hour-ahead supports dispatch scheduling, real-time supports AGC, and seasonal supports IRP planning. Valid values: day_ahead|hour_ahead|real_time|week_ahead|seasonal.',
  `fuel_consumption_rate` DECIMAL(12,3) COMMENT 'The forecasted fuel consumption rate for this interval, expressed in fuel-specific units (e.g., MMBtu/hour for gas, tons/hour for coal). Used for fuel procurement planning, cost estimation, and emissions calculation.',
  `fuel_type` STRING COMMENT 'The primary fuel or energy source used by the generation unit for this forecast interval. Determines dispatch priority, emissions profile, and operational characteristics. Reference-value candidates: coal|natural_gas|nuclear|hydro|wind|solar|biomass|geothermal.',
  `gen_interval_to_gen_forecast` BIGINT COMMENT 'FK to forecast.forecast_generation_forecast.forecast_generation_forecast_id — Every generation forecast interval MUST reference its parent generation forecast. Core header-to-line FK required for dispatch scheduling and unit commitment.',
  `heat_rate_btu_per_kwh` DECIMAL(10,2) COMMENT 'The forecasted heat rate for this interval, representing the amount of fuel energy input (in BTU) required to produce one kilowatt-hour of electrical output. Lower values indicate higher thermal efficiency.',
  `interval_duration_minutes` INT COMMENT 'The duration of the forecast interval in minutes. Common values include 5, 15, 30, or 60 minutes depending on forecast granularity and market requirements. Supports validation of interval alignment and aggregation logic.',
  `interval_end_timestamp` TIMESTAMP COMMENT 'The ending timestamp of the forecast interval. Defines the end of the time window for which the forecasted generation output applies. Used to calculate interval duration and align with market settlement periods.',
  `interval_start_timestamp` TIMESTAMP COMMENT 'The beginning timestamp of the forecast interval. Defines the start of the time window for which the forecasted generation output applies. Typically aligned to standard market intervals (5-min, 15-min, 1-hour).',
  `last_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this forecast interval record was most recently modified. Tracks forecast revisions and actual data backfill operations.',
  `must_run_flag` BOOLEAN COMMENT 'Boolean indicator of whether this generation unit is designated as must-run for this interval due to reliability, contractual, or regulatory requirements. Must-run units are dispatched regardless of economic merit.',
  `nameplate_capacity_mw` DECIMAL(12,3) COMMENT 'The rated maximum continuous output capacity of the generation unit as specified by the manufacturer. Used as a reference baseline for capacity factor calculations and performance assessment.',
  `p10_mw_output` DECIMAL(12,3) COMMENT 'The 10th percentile probabilistic forecast output in megawatts. Represents a conservative lower bound with 90% probability that actual output will exceed this value. Used for risk assessment and reserve planning.',
  `p50_mw_output` DECIMAL(12,3) COMMENT 'The 50th percentile probabilistic forecast output in megawatts. Represents the median expected output with equal probability of actual output being above or below. Typically used as the base case forecast for operational planning.',
  `p90_mw_output` DECIMAL(12,3) COMMENT 'The 90th percentile probabilistic forecast output in megawatts. Represents an optimistic upper bound with 90% probability that actual output will be below this value. Used for upside scenario planning and capacity credit assessment.',
  `precipitation_probability_percent` DECIMAL(5,2) COMMENT 'The forecasted probability of precipitation during this interval, expressed as a percentage. Affects hydro generation forecasts and renewable output variability assessment.',
  `ramp_constraint_flag` BOOLEAN COMMENT 'Boolean indicator of whether this interval forecast is subject to ramp rate constraints. True indicates that physical or operational limits on ramp speed apply and must be respected in dispatch optimization.',
  `ramp_rate_mw_per_minute` DECIMAL(10,3) COMMENT 'The forecasted rate of change in generation output in megawatts per minute. Represents the expected ramp-up or ramp-down speed, critical for AGC response, frequency regulation, and dispatch feasibility assessment.',
  `solar_irradiance_w_per_m2` DECIMAL(8,2) COMMENT 'The forecasted solar irradiance in watts per square meter at the solar generation site. Primary driver of photovoltaic and concentrated solar power output forecasts.',
  `source_system` STRING COMMENT 'The name or identifier of the source system that generated this forecast interval record. Examples include proprietary forecasting platforms, vendor solutions, or internal modeling systems.',
  `variance_explanation_code` STRING COMMENT 'A categorical code explaining the primary reason for significant forecast variance when actual output deviates materially from forecast. Supports root cause analysis and model improvement initiatives. Valid values: weather_deviation|forced_outage|curtailment|fuel_constraint|transmission_limit|model_error.',
  `weather_temperature_celsius` DECIMAL(5,2) COMMENT 'The forecasted ambient temperature in degrees Celsius at the generation site for this interval. Critical input for thermal unit efficiency modeling and renewable output prediction.',
  `wind_speed_mps` DECIMAL(6,2) COMMENT 'The forecasted wind speed in meters per second at hub height for wind generation units. Primary driver of wind turbine output forecasts and intermittency prediction.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_generation_forecast_interval` PRIMARY KEY (`generation_forecast_interval_id`)
)
USING DELTA
COMMENT 'Interval-level generation output forecast values for a parent generation forecast run. Stores forecasted MW output per generation unit or portfolio at each time interval, including probabilistic bounds (P10/P50/P90), ramp rate constraints, and fuel-adjusted capacity. Supports unit commitment optimization, AGC setpoint planning, and real-time dispatch scheduling. Compared against actual generation telemetry from OSIsoft PI for model accuracy assessment. | CMM: CIM RegularTimePoint (close), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'GenerationForecastInterval',
  'cmm.cim.class' = 'RegularTimePoint',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.generation_forecast_interval'
);

-- ForecastRenewable  <<CIM RegularIntervalSchedule : close>>
CREATE TABLE IF NOT EXISTS `forecast`.`forecast_renewable` (
  `forecast_renewable_id` BIGINT NOT NULL COMMENT 'Unique identifier for the forecast_renewable data product.',
  `forecast_forecast_run_id` BIGINT COMMENT 'Unique identifier for the renewable energy forecast record. Primary key for the forecast_renewable product.',
  `forecast_model_id` BIGINT COMMENT 'Foreign key linking to forecast.model. Business justification: Renewable forecasts are produced by registered forecasting models. The model table is the authoritative registry for model configuration, hyperparameters, and validation metrics. Adding forecast_model',
  `forecast_run_id` BIGINT COMMENT 'Foreign key linking to forecast.run. Business justification: forecast_renewable is the master record for renewable generation forecasts; renewable_forecast_interval contains interval-level detail. Linking to run establishes the execution context. The run table',
  `ppa_id` BIGINT COMMENT 'Reference to the Power Purchase Agreement (PPA) contract governing the commercial terms for this renewable asset. Used for revenue forecasting and RPS compliance tracking.',
  `registry_id` BIGINT COMMENT 'Reference to the renewable generation asset (wind farm, solar PV plant, run-of-river hydro facility) for which this forecast applies.',
  `zone_id` BIGINT COMMENT 'Reference to the aggregate balancing zone, pricing node (PNode), or geographic region for which this forecast applies. Used for portfolio-level or zonal forecasts.',
  `actual_mw` DECIMAL(12,3) COMMENT 'The actual measured power output in megawatts (MW) for the forecast period, populated after the fact. Used for forecast accuracy evaluation and model tuning. Null until actual data is available.',
  `aggregation_level` STRING COMMENT 'The level of geographic or organizational aggregation for this forecast. Asset-level forecasts support individual plant operations; portfolio and zone-level forecasts support market participation and grid operations. Valid values: asset|portfolio|zone|balancing_authority|iso_rto.',
  `available_capacity_mw` DECIMAL(12,3) COMMENT 'The available generation capacity in megawatts (MW) after accounting for planned and unplanned outages, derates, and maintenance. Represents the maximum achievable output during the forecast period.',
  `capacity_factor_forecast` DECIMAL(5,4) COMMENT 'The forecasted capacity factor (ratio of actual output to nameplate capacity) for the renewable asset during the forecast period. Expressed as a decimal (e.g., 0.3500 = 35%).',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this forecast record was first created in the system. Used for audit trails and data lineage tracking.',
  `curtailment_mw` DECIMAL(12,3) COMMENT 'Forecasted curtailment in megawatts (MW) due to grid constraints, negative pricing, or dispatch instructions. Represents the reduction from potential output.',
  `curtailment_probability` DECIMAL(5,4) COMMENT 'The probability (0.0000 to 1.0000) that curtailment will occur during the forecast period. Used for risk assessment and revenue forecasting.',
  `data_source_system` STRING COMMENT 'The name of the source system or forecasting platform that generated this forecast record. Examples: proprietary forecasting engine, third-party weather service, Energy Management System (EMS), Distributed Energy Resource Management System (DERMS).',
  `forecast_confidence_score` DECIMAL(5,4) COMMENT 'A confidence score (0.0000 to 1.0000) representing the forecasting models certainty in the prediction. Higher scores indicate more stable weather patterns and higher forecast reliability.',
  `forecast_error_mw` DECIMAL(12,3) COMMENT 'The difference between forecasted and actual power output in megawatts (MW). Calculated as (actual_mw - forecasted_mw_p50). Used for model performance tracking and continuous improvement.',
  `forecast_error_percentage` DECIMAL(7,4) COMMENT 'The forecast error expressed as a percentage of nameplate capacity. Calculated as (forecast_error_mw / nameplate_capacity_mw) * 100. Key performance indicator for forecast quality.',
  `forecast_horizon_end` TIMESTAMP COMMENT 'The ending timestamp of the forecast period. Defines the end of the interval-level forecast data.',
  `forecast_horizon_start` TIMESTAMP COMMENT 'The beginning timestamp of the forecast period. Defines the start of the interval-level forecast data.',
  `forecast_notes` STRING COMMENT 'Free-text field for additional context, assumptions, or special conditions affecting this forecast. Examples: extreme weather events, planned maintenance, model adjustments, data quality issues.',
  `forecast_status` STRING COMMENT 'The lifecycle status of the forecast record. Published forecasts are used for operational decisions; superseded forecasts have been replaced by newer runs; archived forecasts are retained for historical analysis. Valid values: draft|published|superseded|archived.',
  `forecast_type` STRING COMMENT 'Classification of the forecast by time horizon and operational purpose. Day-ahead supports market bidding, hour-ahead supports dispatch, intraday supports real-time balancing, seasonal supports Integrated Resource Plan (IRP) and capacity planning. Valid values: day_ahead|hour_ahead|week_ahead|intraday|real_time|seasonal.',
  `forecast_use_case` STRING COMMENT 'The primary operational or planning use case for this forecast. Determines the required accuracy, granularity, and update frequency. RPS = Renewable Portfolio Standard, VPP = Virtual Power Plant. Valid values: dispatch|market_bidding|rps_compliance|grid_balancing|capacity_planning|vpp_optimization.',
  `forecasted_mw_p10` DECIMAL(12,3) COMMENT 'The 10th percentile forecasted power output in megawatts (MW). Represents a conservative lower bound with 90% probability of exceedance. Used for risk management and reserve planning.',
  `forecasted_mw_p50` DECIMAL(12,3) COMMENT 'The median (50th percentile) forecasted power output in megawatts (MW) for the renewable asset. Represents the most likely generation level.',
  `forecasted_mw_p90` DECIMAL(12,3) COMMENT 'The 90th percentile forecasted power output in megawatts (MW). Represents an optimistic upper bound with 10% probability of exceedance. Used for upside scenario planning.',
  `forecasted_rec_quantity` DECIMAL(12,3) COMMENT 'The forecasted quantity of Renewable Energy Certificates (RECs) that will be generated from the forecasted MWh output. Typically 1 REC per MWh of eligible generation.',
  `interconnection_point` STRING COMMENT 'The Point of Interconnection (POI) or substation where the renewable asset connects to the transmission or distribution grid. Used for grid constraint analysis and curtailment forecasting.',
  `interval_duration_minutes` INT COMMENT 'The granularity of the forecast intervals in minutes. Common values are 5, 15, 30, or 60 minutes depending on operational requirements and market settlement intervals.',
  `irradiance_w_per_m2` DECIMAL(8,2) COMMENT 'Forecasted solar irradiance in watts per square meter (W/m²) for solar PV assets. Null for non-solar technologies. Key meteorological input for solar generation forecasting.',
  `nameplate_capacity_mw` DECIMAL(12,3) COMMENT 'The maximum rated power output capacity of the renewable asset in megawatts (MW) under standard test conditions. Used for capacity factor calculations and normalization.',
  `ramp_event_probability` DECIMAL(5,4) COMMENT 'The probability (0.0000 to 1.0000) that a significant ramp event (rapid increase or decrease in output) will occur during the forecast period. Used for reserve planning.',
  `ramp_rate_mw_per_min` DECIMAL(10,3) COMMENT 'Forecasted rate of change in power output in megawatts per minute (MW/min). Critical for grid balancing and reserve requirements during rapid weather changes.',
  `rec_eligible_flag` BOOLEAN COMMENT 'Indicates whether the forecasted generation is eligible for Renewable Energy Certificate (REC) creation under applicable Renewable Portfolio Standard (RPS) programs. True if eligible, False otherwise.',
  `technology` STRING COMMENT 'The type of variable renewable energy (VRE) technology for which the forecast is generated. Determines the meteorological inputs and intermittency characteristics. Valid values: solar_pv|wind_onshore|wind_offshore|hydro_run_of_river|hybrid.',
  `temperature_celsius` DECIMAL(5,2) COMMENT 'Forecasted ambient temperature in degrees Celsius at the asset location. Affects solar panel efficiency and wind turbine performance.',
  `transmission_constraint_flag` BOOLEAN COMMENT 'Indicates whether transmission constraints are expected to limit the renewable assets output during the forecast period. True if constraints are forecasted, False otherwise.',
  `updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this forecast record was last modified. Used for audit trails and change tracking.',
  `weather_model_source` STRING COMMENT 'The numerical weather prediction (NWP) model used as input for the renewable forecast. Examples: GFS (Global Forecast System), ECMWF (European Centre for Medium-Range Weather Forecasts), NAM (North American Mesoscale), HRRR (High-Resolution Rapid Refresh), WRF (Weather Research and Forecasting). Reference-value candidates: gfs|ecmwf|nam|hrrr|wrf|ensemble|proprietary.',
  `wind_speed_m_per_s` DECIMAL(6,2) COMMENT 'Forecasted wind speed in meters per second (m/s) at hub height for wind assets. Null for non-wind technologies. Key meteorological input for wind generation forecasting.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_forecast_renewable` PRIMARY KEY (`forecast_renewable_id`)
)
USING DELTA
COMMENT 'Master record and interval-level forecast values for variable renewable energy (VRE) covering utility-scale wind, solar PV, and run-of-river hydro resources. Captures intermittency prediction parameters, irradiance and wind speed inputs, curtailment risk, and ramp event probability at the header level. Stores forecasted MW output per renewable asset or aggregate zone at each time interval, including irradiance (W/m²), wind speed (m/s), capacity factor, curtailment MW, and probabilistic confidence bands (P10/P50/P90). Supports RPS compliance planning, VPP dispatch optimization, real-time renewable integration management, and grid balancing decisions. | CMM: CIM RegularIntervalSchedule (close), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ForecastRenewable',
  'cmm.cim.class' = 'RegularIntervalSchedule',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.forecast_renewable'
);

-- RenewableForecastInterval  <<CIM RegularTimePoint : close>>
CREATE TABLE IF NOT EXISTS `forecast`.`renewable_forecast_interval` (
  `renewable_forecast_interval_id` BIGINT NOT NULL COMMENT 'Unique identifier for the renewable forecast interval record. Primary key for this entity.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Renewable generation forecasts feed into control area AGC signals, regulation reserve requirements, and ramp management. High renewable penetration requires control-area-level forecast integration for',
  `forecast_renewable_id` BIGINT COMMENT 'Foreign key linking to forecast.forecast_renewable. Business justification: Renewable forecast intervals are child records of a renewable forecast master; FK creates correct parent-child relationship.',
  `registry_id` BIGINT COMMENT 'Foreign key reference to the specific renewable generation asset (solar farm, wind farm, or aggregated zone) for which this interval forecast applies.',
  `renewable_forecast_run_id` BIGINT COMMENT 'Foreign key reference to the parent renewable forecast run that generated this interval forecast. Links this interval to the overall forecast execution context.',
  `aggregation_level` STRING COMMENT 'The geographic or organizational level at which this forecast is aggregated. Asset-level forecasts are for individual facilities, zone-level aggregates multiple assets, portfolio covers all renewable assets, balancing authority represents the entire control area. Valid values: asset|zone|portfolio|balancing_authority.',
  `confidence_level_p10_mw` DECIMAL(12,3) COMMENT 'The 10th percentile probabilistic forecast value in megawatts. Represents a conservative lower bound with 90% probability that actual generation will exceed this value. Used for risk management and reserve planning.',
  `confidence_level_p50_mw` DECIMAL(12,3) COMMENT 'The 50th percentile (median) probabilistic forecast value in megawatts. Represents the most likely generation outcome with equal probability of over or under-performance.',
  `confidence_level_p90_mw` DECIMAL(12,3) COMMENT 'The 90th percentile probabilistic forecast value in megawatts. Represents an optimistic upper bound with 90% probability that actual generation will be below this value. Used for upside scenario planning.',
  `data_source_system` STRING COMMENT 'The name or identifier of the operational system that generated this forecast record (e.g., OSIsoft PI, proprietary forecasting platform, SCADA system). Enables data lineage tracking and system integration management.',
  `forecast_bias_mw` DECIMAL(12,3) COMMENT 'The systematic bias adjustment applied to the raw model output based on historical forecast error analysis. Positive values indicate upward adjustment, negative values indicate downward adjustment.',
  `forecast_created_timestamp` TIMESTAMP COMMENT 'The date and time when this forecast interval record was generated and persisted to the system. Used for audit trails and to calculate forecast lead time.',
  `forecast_horizon_hours` INT COMMENT 'The number of hours ahead from the forecast run time that this interval represents. Used to analyze forecast accuracy degradation over time and distinguish short-term from long-term forecasts.',
  `forecast_interval_end_timestamp` TIMESTAMP COMMENT 'The end date and time of the forecast interval. Represents the conclusion of the time window for which the generation forecast applies.',
  `forecast_interval_start_timestamp` TIMESTAMP COMMENT 'The start date and time of the forecast interval. Represents the beginning of the time window for which the generation forecast applies. Critical for time-series alignment in grid operations.',
  `forecast_model_version` STRING COMMENT 'The version identifier of the forecasting model or algorithm used to generate this interval prediction. Enables traceability and model performance analysis.',
  `forecast_quality_flag` STRING COMMENT 'Data quality indicator for this forecast interval. Valid indicates normal forecast, suspect indicates potential issues, estimated indicates fallback methodology used, missing_input indicates incomplete weather data, model_failure indicates computational error. Valid values: valid|suspect|estimated|missing_input|model_failure.',
  `forecast_type` STRING COMMENT 'The classification of the forecast based on its time horizon and operational purpose. Day-ahead forecasts support market bidding, hour-ahead supports dispatch, real-time supports balancing operations. Valid values: day_ahead|hour_ahead|real_time|week_ahead|month_ahead.',
  `forecast_uncertainty_mw` DECIMAL(12,3) COMMENT 'The standard deviation or uncertainty range of the forecast in megawatts. Quantifies the expected variability around the point forecast. Higher values indicate greater forecast uncertainty.',
  `forecast_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this forecast interval record was last modified or refreshed. Null if the record has never been updated after initial creation.',
  `forecasted_capacity_factor` DECIMAL(5,4) COMMENT 'The predicted ratio of actual generation to nameplate capacity for this interval, expressed as a decimal between 0 and 1. Indicates expected asset utilization relative to maximum rated output.',
  `forecasted_cloud_cover_percent` DECIMAL(5,2) COMMENT 'The predicted cloud cover as a percentage (0-100) for solar generation assets. Impacts solar irradiance and generation output. Null for non-solar assets.',
  `forecasted_curtailment_mw` DECIMAL(12,3) COMMENT 'The predicted amount of renewable generation that will be curtailed (not dispatched) in megawatts due to grid constraints, negative pricing, or operational limits. Zero indicates no expected curtailment.',
  `forecasted_generation_mw` DECIMAL(12,3) COMMENT 'The predicted electrical generation output in megawatts for this interval. This is the primary forecast value used by grid operators for dispatch and balancing decisions.',
  `forecasted_irradiance_w_per_m2` DECIMAL(8,2) COMMENT 'The predicted solar irradiance in watts per square meter for solar generation assets. Key meteorological input for solar generation forecasting. Null for non-solar assets.',
  `forecasted_temperature_celsius` DECIMAL(5,2) COMMENT 'The predicted ambient temperature in degrees Celsius at the asset location. Affects solar panel efficiency and wind turbine performance characteristics.',
  `forecasted_wind_direction_degrees` DECIMAL(5,2) COMMENT 'The predicted wind direction in degrees (0-360) at hub height for wind generation assets. Used for advanced wind farm modeling and wake effect analysis. Null for non-wind assets.',
  `forecasted_wind_speed_m_per_s` DECIMAL(6,2) COMMENT 'The predicted wind speed in meters per second at hub height for wind generation assets. Critical meteorological input for wind generation forecasting. Null for non-wind assets.',
  `grid_constraint_flag` BOOLEAN COMMENT 'Boolean indicator of whether transmission or distribution grid constraints are expected to limit renewable generation dispatch during this interval. True indicates constraints are forecasted, False indicates no constraints expected.',
  `interval_duration_minutes` INT COMMENT 'The duration of the forecast interval in minutes. Common values include 5, 15, 30, or 60 minutes depending on operational requirements and forecast granularity.',
  `locational_marginal_price_usd_per_mwh` DECIMAL(10,2) COMMENT 'The forecasted locational marginal price at the renewable asset point of interconnection in USD per MWh. Reflects local grid congestion and transmission constraints. Used for economic dispatch optimization.',
  `market_clearing_price_usd_per_mwh` DECIMAL(10,2) COMMENT 'The forecasted or actual wholesale electricity market price in USD per MWh for this interval. Used to calculate expected revenue and inform economic curtailment decisions. May be null for non-market forecasts.',
  `net_generation_mw` DECIMAL(12,3) COMMENT 'The predicted net generation output after accounting for curtailment. Calculated as forecasted_generation_mw minus forecasted_curtailment_mw. Represents the actual expected dispatch to the grid.',
  `persistence_forecast_mw` DECIMAL(12,3) COMMENT 'A simple baseline forecast assuming current generation continues unchanged. Used as a benchmark to evaluate the skill and value-add of advanced forecasting models.',
  `ramp_rate_mw_per_minute` DECIMAL(10,3) COMMENT 'The predicted rate of change in generation output in megawatts per minute from the previous interval. Critical for grid stability analysis and reserve requirement calculations. Positive values indicate increasing generation, negative values indicate decreasing generation.',
  `renewable_interval_to_renewable_forecast` BIGINT COMMENT 'FK to forecast.renewable_forecast.renewable_forecast_id — Every renewable forecast interval MUST reference its parent renewable forecast. Required for real-time renewable integration and grid balancing.',
  `renewable_technology_type` STRING COMMENT 'The type of renewable generation technology for which this forecast applies. Different technologies require different forecasting methodologies and meteorological inputs. Valid values: solar_pv|wind_onshore|wind_offshore|hydro_run_of_river|biomass|geothermal.',
  `weather_data_source` STRING COMMENT 'The name or identifier of the meteorological data provider used as input for this forecast (e.g., NOAA, ECMWF, proprietary weather service). Critical for forecast quality assessment and vendor management.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_renewable_forecast_interval` PRIMARY KEY (`renewable_forecast_interval_id`)
)
USING DELTA
COMMENT 'Interval-level renewable generation forecast values for a parent renewable forecast run. Stores forecasted MW output per renewable asset or aggregate zone at each time interval, including irradiance (W/m²), wind speed (m/s), capacity factor, curtailment MW, and probabilistic confidence bands. Enables real-time renewable integration management and grid balancing decisions by grid operators. | CMM: CIM RegularTimePoint (close), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'RenewableForecastInterval',
  'cmm.cim.class' = 'RegularTimePoint',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.renewable_forecast_interval'
);

-- PeakDemand  <<CIM RegularIntervalSchedule : extension>>
CREATE TABLE IF NOT EXISTS `forecast`.`peak_demand` (
  `peak_demand_id` BIGINT NOT NULL COMMENT 'Primary key for peak_demand',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Peak demand forecasts drive control area capacity planning, reserve margin calculations, and resource adequacy assessments. Balancing authorities use peak forecasts for transmission planning and gener',
  `forecast_model_id` BIGINT COMMENT 'Foreign key linking to forecast.model. Business justification: Peak demand forecasts are produced by registered forecasting models. The model table is the authoritative registry for model metadata, versioning, and accuracy metrics. Adding forecast_model_id FK all',
  `peak_forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Peak demand forecasts are spatially scoped to forecast zones. The zone table defines geographic boundaries and aggregation levels. Adding forecast_zone_id FK allows retrieval of zone_code, zone_name,',
  `peak_zone_id` BIGINT COMMENT 'FK to forecast.zone.zone_id — Peak demand forecasts are scoped to system or zone level. FK enables zone-level capacity planning.',
  `planning_assumption_id` BIGINT COMMENT 'FK to forecast.planning_assumption.planning_assumption_id — Peak demand forecasts use planning assumptions (load growth rates, EV adoption, DR credits). FK enables assumption traceability.',
  `approved_by` STRING COMMENT 'User ID or name of the person who approved this peak demand forecast for use in resource adequacy and capacity planning.',
  `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when this peak demand forecast was approved by planning or management for use in resource adequacy and capacity planning.',
  `btm_solar_reduction_mw` DECIMAL(12,3) COMMENT 'Forecasted behind-the-meter (BTM) solar generation reduction credit in megawatts (MW) that will reduce the net peak demand seen by the grid.',
  `capex_trigger_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this forecast triggers capital expenditure (CAPEX) investment decisions for transmission and distribution (T&D) infrastructure (True if triggers investment, False otherwise).',
  `confidence_level_percent` DECIMAL(5,2) COMMENT 'Statistical confidence level of the forecast expressed as a percentage (e.g., 90.0 for 90% confidence interval). Indicates forecast reliability.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this peak demand forecast record was first created in the system.',
  `dr_reduction_mw` DECIMAL(12,3) COMMENT 'Forecasted demand response (DR) program reduction credit in megawatts (MW) that will reduce the gross peak demand. Used for resource adequacy calculations.',
  `energy_efficiency_reduction_mw` DECIMAL(12,3) COMMENT 'Forecasted energy efficiency program reduction credit in megawatts (MW) that will reduce the gross peak demand due to efficiency measures.',
  `forecast_error_mw` DECIMAL(12,3) COMMENT 'Expected forecast error or uncertainty range in megawatts (MW). Represents the plus/minus range around the forecasted peak demand.',
  `forecast_horizon` STRING COMMENT 'Time horizon classification for the forecast (short-term operational, seasonal, annual, multi-year, or long-term capacity planning). Valid values: short_term|seasonal|annual|multi_year|long_term.',
  `forecast_name` STRING COMMENT 'Business-friendly name or label for this peak demand forecast (e.g., \'Summer 2024 System Peak\', \'Winter 2025 Coincident Peak\').',
  `forecast_notes` STRING COMMENT 'Free-text notes, assumptions, or commentary related to this peak demand forecast. May include special conditions, data quality issues, or planning considerations.',
  `forecast_scenario` STRING COMMENT 'Planning scenario or case assumption underlying this forecast (base case, high growth, low growth, extreme weather, conservation, electrification). Valid values: base_case|high_growth|low_growth|extreme_weather|conservation|electrification.',
  `forecast_season` STRING COMMENT 'Seasonal period for which the peak demand is forecasted (summer, winter, spring, fall, or annual). Valid values: summer|winter|spring|fall|annual.',
  `forecast_status` STRING COMMENT 'Current lifecycle status of the peak demand forecast (draft, submitted to RTO/ISO, approved by planning, revised, or archived). Valid values: draft|submitted|approved|revised|archived.',
  `forecast_type` STRING COMMENT 'Classification of the peak demand forecast by scope and aggregation level (system-wide, coincident across zones, non-coincident, zonal, substation-level, or feeder-level). Valid values: system_peak|coincident_peak|non_coincident_peak|zonal_peak|substation_peak|feeder_peak.',
  `forecast_year` INT COMMENT 'Calendar year for which the peak demand is forecasted.',
  `forecasted_temperature` DECIMAL(6,2) COMMENT 'Forecasted temperature (in degrees Fahrenheit or Celsius) at the time of peak demand. Used for weather-correlated load forecasting.',
  `irp_filing_date` DATE COMMENT 'Date on which the IRP containing this forecast was filed with the state Public Utility Commission.',
  `irp_filing_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this forecast is included in an Integrated Resource Plan (IRP) filing to the state Public Utility Commission (True if included, False otherwise).',
  `modified_by` STRING COMMENT 'User ID or name of the person or system that last modified this peak demand forecast record.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this peak demand forecast record was last modified or updated.',
  `mw` DECIMAL(12,3) COMMENT 'Forecasted system peak demand in megawatts (MW). This is the principal quantitative value representing the maximum expected load.',
  `net_peak_demand_mw` DECIMAL(12,3) COMMENT 'Net forecasted peak demand in megawatts (MW) after applying all reduction credits (demand response, BTM solar, energy efficiency). This is the load the utility must serve.',
  `normal_temperature` DECIMAL(6,2) COMMENT 'Normal or baseline temperature assumption (in degrees Fahrenheit or Celsius) used as the reference point for temperature sensitivity calculations.',
  `peak_date` DATE COMMENT 'Forecasted date on which the peak demand is expected to occur.',
  `peak_hour_end` INT COMMENT 'Ending hour (0-23) of the forecasted peak demand window. Used for operational dispatch planning.',
  `peak_hour_start` INT COMMENT 'Starting hour (0-23) of the forecasted peak demand window. Used for operational dispatch planning.',
  `required_capacity_mw` DECIMAL(12,3) COMMENT 'Total required generation capacity in megawatts (MW) calculated as net peak demand plus reserve margin. Used for resource adequacy and capacity procurement planning.',
  `reserve_margin_percent` DECIMAL(6,3) COMMENT 'Planning reserve margin percentage applied to the net peak demand to determine required generation capacity. Expressed as a percentage (e.g., 15.0 for 15%).',
  `rto_iso_submission_date` DATE COMMENT 'Date on which this forecast was submitted to the RTO/ISO for capacity planning and reliability assessments.',
  `rto_iso_submission_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this forecast has been submitted to the RTO/ISO for capacity planning and reliability assessments (True if submitted, False otherwise).',
  `temperature_sensitivity_mw_per_degree` DECIMAL(10,4) COMMENT 'Temperature sensitivity coefficient representing the change in peak demand (MW) per degree Fahrenheit or Celsius change from normal. Used for weather-adjusted forecasting.',
  `temperature_unit` STRING COMMENT 'Unit of measure for temperature sensitivity (Fahrenheit or Celsius). Valid values: fahrenheit|celsius.',
  `weather_station_code` STRING COMMENT 'Identifier of the weather station or meteorological data source used for temperature and weather correlation in this forecast.',
  `created_by` STRING COMMENT 'User ID or name of the person or system that created this peak demand forecast record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_peak_demand` PRIMARY KEY (`peak_demand_id`)
)
USING DELTA
COMMENT 'Master entity capturing seasonal and annual peak demand forecasts used for resource adequacy planning, transmission planning, and IRP. Records forecasted system peak MW, coincident peak date/time window, temperature sensitivity assumptions, demand response reduction credits, and reserve margin calculations. Submitted to RTO/ISO for capacity planning and NERC reliability assessments. Supports CAPEX investment decisions for T&D infrastructure. | CMM: CIM RegularIntervalSchedule (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PeakDemand',
  'cmm.cim.class' = 'RegularIntervalSchedule',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.peak_demand'
);

-- WeatherInput  <<CIM EnvironmentalAnalog : close>>
CREATE TABLE IF NOT EXISTS `forecast`.`weather_input` (
  `weather_input_id` BIGINT NOT NULL COMMENT 'Primary key for weather_input',
  `forecast_zone_id` BIGINT COMMENT 'Identifier for the geographic zone or service territory to which this weather forecast applies. Links to the zone definition used in load and generation forecasting models.',
  `atmospheric_pressure_hpa` DECIMAL(7,2) COMMENT 'Forecasted atmospheric pressure at sea level in hectopascals (hPa). Used in advanced weather correlation models and can influence wind patterns and storm tracking.',
  `cloud_cover_percent` DECIMAL(5,2) COMMENT 'Forecasted total cloud cover as a percentage (0-100). Primary driver of solar irradiance reduction and solar generation output forecasting.',
  `data_quality_flag` STRING COMMENT 'Quality assurance flag indicating the reliability of this forecast record. Values include valid (passed all checks), suspect (anomaly detected), missing (data gap), interpolated (filled from adjacent data), estimated (model-derived). Valid values: valid|suspect|missing|interpolated|estimated.',
  `dew_point_c` DECIMAL(5,2) COMMENT 'Forecasted dew point temperature in degrees Celsius. Used to calculate humidity and assess cooling load and comfort index impacts on energy demand.',
  `ensemble_member_number` STRING COMMENT 'Identifier for the ensemble member or scenario within an ensemble forecast system (e.g., ECMWF EPS member 1, 2, 3). Null for deterministic forecasts. Enables probabilistic forecasting and uncertainty quantification.',
  `forecast_confidence_score` DECIMAL(5,2) COMMENT 'Numerical confidence or quality score assigned to this forecast record by the NWP provider or internal validation process. Higher scores indicate greater reliability. Used to weight ensemble forecasts.',
  `forecast_issue_timestamp` TIMESTAMP COMMENT 'The date and time when the NWP model run was issued or published by the provider. This is the model initialization time, critical for tracking forecast vintage and lead time.',
  `forecast_lead_time_hours` INT COMMENT 'The number of hours between the forecast issue time and the valid time. Indicates forecast horizon and is a key driver of forecast accuracy degradation.',
  `forecast_type` STRING COMMENT 'Classification of the forecast methodology: deterministic (single outcome), ensemble (multiple scenarios), probabilistic (distribution-based), or nowcast (very short-term, 0-6 hours). Valid values: deterministic|ensemble|probabilistic|nowcast.',
  `forecast_update_cycle` STRING COMMENT 'The NWP model run cycle identifier (e.g., 00Z, 06Z, 12Z, 18Z for GFS). Indicates which daily model run produced this forecast, critical for tracking model version and update frequency.',
  `forecast_valid_timestamp` TIMESTAMP COMMENT 'The date and time for which this forecast is valid. Represents the target hour or interval that the weather variables predict. Used to align weather inputs with load and generation forecast horizons.',
  `ingestion_timestamp` TIMESTAMP COMMENT 'The date and time when this weather forecast record was ingested into the lakehouse from the external NWP provider or data feed. Used for data lineage and latency tracking.',
  `is_historical_reforecast` BOOLEAN COMMENT 'Boolean flag indicating whether this record is a historical reforecast (hindcast) used for model training and validation, rather than a real-time operational forecast.',
  `notes` STRING COMMENT 'Free-text field for additional context, anomalies, or special conditions associated with this forecast record (e.g., model outage, data correction, extreme weather event).',
  `nwp_model_source` STRING COMMENT 'The numerical weather prediction model provider or system that generated this forecast data (e.g., GFS, ECMWF, NAM, HRRR, WRF). Critical for model performance tracking and ensemble forecasting. Valid values: GFS|ECMWF|NAM|HRRR|WRF|CUSTOM.',
  `precipitation_mm` DECIMAL(6,2) COMMENT 'Forecasted precipitation accumulation in millimeters for the forecast interval. Impacts hydro generation availability, solar output, and load patterns during storm events.',
  `precipitation_probability_percent` DECIMAL(5,2) COMMENT 'Forecasted probability of precipitation occurrence as a percentage (0-100). Used in probabilistic forecasting and risk assessment for renewable generation and load variability.',
  `relative_humidity_percent` DECIMAL(5,2) COMMENT 'Forecasted relative humidity as a percentage (0-100). Influences cooling load, HVAC efficiency, and customer comfort-driven energy consumption.',
  `snow_depth_cm` DECIMAL(6,2) COMMENT 'Forecasted snow depth on the ground in centimeters. Relevant for winter peak load forecasting, transmission line loading, and hydro reservoir inflow modeling.',
  `solar_irradiance_w_per_m2` DECIMAL(7,2) COMMENT 'Forecasted global horizontal irradiance (GHI) in watts per square meter. Direct input to solar photovoltaic generation forecasting models and renewable energy integration planning.',
  `source_file_name` STRING COMMENT 'The name of the source file or data feed from which this forecast record was extracted (e.g., GRIB2 file name, API endpoint). Supports data lineage and troubleshooting.',
  `spatial_resolution_km` DECIMAL(6,2) COMMENT 'The spatial grid resolution of the NWP model in kilometers (e.g., GFS 13km, ECMWF 9km). Indicates the granularity of the forecast and impacts accuracy for localized weather phenomena.',
  `temperature_c` DECIMAL(5,2) COMMENT 'Forecasted air temperature in degrees Celsius at the zone or station level. Primary driver of heating and cooling load in energy demand forecasting.',
  `temporal_resolution_minutes` INT COMMENT 'The time interval between consecutive forecast data points in minutes (e.g., 60 for hourly, 15 for sub-hourly). Defines the granularity of the forecast time series.',
  `visibility_km` DECIMAL(6,2) COMMENT 'Forecasted horizontal visibility in kilometers. May be used in operational safety assessments and can correlate with fog-related load patterns.',
  `weather_station_code` BIGINT COMMENT 'Identifier for the weather station or observation point from which this forecast data is sourced or interpolated.',
  `wind_direction_degrees` DECIMAL(5,2) COMMENT 'Forecasted wind direction in degrees (0-360, where 0/360 is North, 90 is East, 180 is South, 270 is West). Used in wind farm output modeling and turbine-level generation forecasting.',
  `wind_gust_speed_mps` DECIMAL(6,2) COMMENT 'Forecasted maximum wind gust speed in meters per second. Important for wind turbine curtailment decisions and grid stability planning during high-wind events.',
  `wind_speed_mps` DECIMAL(6,2) COMMENT 'Forecasted wind speed in meters per second at the zone or station level. Critical input for wind generation forecasting and renewable intermittency prediction.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_weather_input` PRIMARY KEY (`weather_input_id`)
)
USING DELTA
COMMENT 'Weather forecast data ingested from NWP providers (GFS, ECMWF, NAM) as primary inputs to load, generation, and renewable forecasting models. Stores temperature, humidity, wind speed/direction, cloud cover, precipitation, solar irradiance, and dew point at zone or weather station level. Tracks NWP model source, forecast issue time, and validity period. Critical driver for all forecast accuracy and the primary exogenous variable in energy demand and renewable output prediction. | CMM: CIM EnvironmentalAnalog (close), IEC61968::Environmental.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'WeatherInput',
  'cmm.cim.class' = 'EnvironmentalAnalog',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61968::Environmental',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.weather_input'
);

-- ForecastModel  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `forecast`.`model` (
  `model_id` BIGINT NOT NULL COMMENT 'Primary key for model',
  `accuracy_metric_mae` DECIMAL(12,4) COMMENT 'Mean Absolute Error (MAE) of the model on validation data. Measures average forecast error magnitude.',
  `accuracy_metric_mape` DECIMAL(8,4) COMMENT 'Mean Absolute Percentage Error (MAPE) of the model on validation data. Primary accuracy metric for forecast quality assessment.',
  `accuracy_metric_rmse` DECIMAL(12,4) COMMENT 'Root Mean Squared Error (RMSE) of the model on validation data. Measures forecast deviation in absolute units (MW, MWh, etc.).',
  `approval_date` DATE COMMENT 'Date when the model was formally approved for production use by the model governance committee or designated authority.',
  `calibration_date` DATE COMMENT 'Date when the model was last calibrated or re-trained with updated historical data. Critical for model performance tracking and refresh scheduling.',
  `champion_challenger_flag` BOOLEAN COMMENT 'Indicates whether this model is part of a champion/challenger evaluation workflow. True if the model is being compared against an incumbent champion model.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the model record was first created in the registry. Used for audit trail and model lifecycle tracking.',
  `deployment_environment` STRING COMMENT 'Environment where the model is currently deployed: development, staging, production, or sandbox. Used for change management and release control. Valid values: development|staging|production|sandbox.',
  `documentation_url` STRING COMMENT 'URL or file path to detailed model documentation including methodology, assumptions, validation results, and usage guidelines.',
  `execution_frequency` STRING COMMENT 'Scheduled frequency at which the model generates forecasts: real-time, hourly, daily, weekly, monthly, or on-demand. Valid values: real_time|hourly|daily|weekly|monthly|on_demand.',
  `forecast_category` STRING COMMENT 'Primary category of forecast output produced by this model: load forecasting, generation forecasting, renewable intermittency, demand response, price forecasting, or capacity planning. Valid values: load|generation|renewable|demand_response|price|capacity.',
  `forecast_horizon` STRING COMMENT 'Temporal scope of the forecast: real-time (minutes), short-term (hours to days), day-ahead, medium-term (weeks to months), seasonal, or long-term (years) for IRP planning. Valid values: short_term|medium_term|long_term|real_time|day_ahead|seasonal.',
  `framework` STRING COMMENT 'Software framework or library used to implement the model (e.g., TensorFlow, PyTorch, scikit-learn, R forecast package, proprietary EMS module).',
  `geographic_scope` STRING COMMENT 'Geographic coverage of the forecast model (e.g., service territory, balancing authority area, RTO region, specific substation, or renewable site).',
  `hyperparameters` STRING COMMENT 'JSON or text representation of model hyperparameters (e.g., learning rate, number of layers, regularization coefficients, ensemble weights). Used for model reproducibility and tuning.',
  `input_feature_set` STRING COMMENT 'Comma-separated list or description of input features used by the model (e.g., temperature, humidity, day-of-week, historical load, wind speed, solar irradiance).',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the model record was last updated. Tracks configuration changes, recalibration, or metadata updates.',
  `model_code` STRING COMMENT 'Business identifier code for the forecast model used in operational references and reporting. Unique across all registered models. Pattern: ^[A-Z0-9_-]{4,20}$.',
  `model_description` STRING COMMENT 'Detailed textual description of the model purpose, methodology, use cases, and key assumptions. Provides business context for model selection and interpretation.',
  `model_name` STRING COMMENT 'Human-readable name of the forecast model describing its purpose and scope (e.g., \'Summer Peak Load LSTM\', \'Wind Generation Ensemble\').',
  `model_status` STRING COMMENT 'Current lifecycle status of the model: development (under construction), testing (validation phase), champion (production model), challenger (competing alternative), retired, or deprecated. Valid values: development|testing|champion|challenger|retired|deprecated.',
  `model_type` STRING COMMENT 'Classification of the forecasting algorithm or methodology used (statistical regression, neural network, ensemble, persistence, ARIMA, LSTM, random forest). Reference-value candidates: statistical_regression|neural_network|ensemble|persistence|arima|lstm|random_forest.',
  `output_granularity` STRING COMMENT 'Temporal resolution of the forecast output: 5-minute, 15-minute, hourly, daily, monthly, or annual intervals. Valid values: 5_minute|15_minute|hourly|daily|monthly|annual.',
  `owner_email` STRING COMMENT 'Email address of the model owner for operational communication and governance escalation. Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$.',
  `owner_name` STRING COMMENT 'Full name of the individual responsible for the model. Primary point of contact for model questions and governance.',
  `owning_team` STRING COMMENT 'Name of the business unit or team responsible for developing, maintaining, and governing this forecast model (e.g., Load Forecasting, Renewable Analytics, Grid Operations).',
  `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether this model is used for regulatory reporting or compliance purposes (e.g., NERC resource adequacy, FERC market reporting, IRP filings). True if regulatory-critical.',
  `retirement_date` DATE COMMENT 'Date when the model was retired from active use. Null for active models.',
  `training_end_date` DATE COMMENT 'End date of the historical data period used to train the model. Defines the conclusion of the training window.',
  `training_start_date` DATE COMMENT 'Start date of the historical data period used to train the model. Defines the beginning of the training window.',
  `validation_period_end_date` DATE COMMENT 'End date of the out-of-sample validation period used to assess model accuracy.',
  `validation_period_start_date` DATE COMMENT 'Start date of the out-of-sample validation period used to assess model accuracy. Distinct from training period.',
  `version` STRING COMMENT 'Version identifier for the model configuration following semantic versioning (e.g., v1.2.0). Incremented when model structure, hyperparameters, or training data change. Pattern: ^v?[0-9]+\\.[0-9]+(\\.[0-9]+)?$.',
  `weather_data_source` STRING COMMENT 'Name of the weather data provider or service used as input to the model (e.g., NOAA, Weather Underground, proprietary SCADA sensors).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_model` PRIMARY KEY (`model_id`)
)
USING DELTA
COMMENT 'Master entity representing a registered forecasting model configuration used to produce load, generation, or renewable forecasts. Captures model type (statistical regression, neural network, ensemble, persistence), model version, training data period, input feature set, hyperparameters, calibration date, and owning team. Provides model governance and lineage for all forecast runs. Supports model comparison and champion/challenger evaluation workflows. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ForecastModel',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.model'
);

-- ForecastAccuracy  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `forecast`.`accuracy` (
  `accuracy_id` BIGINT NOT NULL COMMENT 'Primary key for accuracy',
  `accuracy_forecast_model_id` BIGINT COMMENT 'Foreign key linking to forecast.model. Business justification: Forecast accuracy records measure the performance of registered forecasting models. The model table is the authoritative registry for model configuration, hyperparameters, and baseline accuracy metric',
  `accuracy_model_id` BIGINT COMMENT 'FK to forecast.model.model_id — Accuracy records measure performance of a specific forecast model. FK enables model performance governance and champion/challenger comparison.',
  `forecast_run_id` BIGINT COMMENT 'Reference to the specific forecast run being evaluated for accuracy. Links to the forecast execution that produced the predictions being measured.',
  `meter_point_id` BIGINT COMMENT 'Foreign key linking to metering.meter_point. Business justification: Forecast accuracy records track performance at specific service points or aggregations. Forecasters identify which meter points drive forecast errors to refine models. Real business process: granular',
  `zone_id` BIGINT COMMENT 'Reference to the specific transmission or distribution zone for which accuracy is measured. Null for system-level measurements.',
  `absolute_error_mw` DECIMAL(18,4) COMMENT 'The absolute difference between forecasted and actual values, calculated as |forecasted_value_mw - actual_value_mw|. Used in Mean Absolute Error (MAE) calculations.',
  `actual_value_mw` DECIMAL(18,4) COMMENT 'The actual observed value for the interval, measured in megawatts. This is the realized load, generation, or other metric that occurred and is used as ground truth for accuracy calculation.',
  `benchmark_comparison` STRING COMMENT 'Comparison of the forecast accuracy against a benchmark model or target threshold. Indicates whether the forecast performed better, worse, or equivalent to the benchmark. Valid values: better|worse|equivalent.',
  `bias_mw` DECIMAL(18,4) COMMENT 'The signed difference between forecasted and actual values, calculated as forecasted_value_mw - actual_value_mw. Positive bias indicates over-forecasting, negative bias indicates under-forecasting.',
  `confidence_interval_lower` DECIMAL(10,4) COMMENT 'The lower bound of the confidence interval for the accuracy metric. Provides statistical confidence range for the measured accuracy.',
  `confidence_interval_upper` DECIMAL(10,4) COMMENT 'The upper bound of the confidence interval for the accuracy metric. Provides statistical confidence range for the measured accuracy.',
  `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this accuracy record was first created in the system. Used for data lineage and audit trail purposes.',
  `data_quality_flag` STRING COMMENT 'Indicator of the quality of the actual data used for accuracy calculation. Flags whether the actual values were validated, suspect, estimated through VEE (Validation Estimation and Editing), or missing. Valid values: valid|suspect|estimated|missing.',
  `day_type` STRING COMMENT 'Classification of the day as weekday, weekend, or holiday. Used to segment accuracy analysis by day-of-week patterns that affect load profiles. Valid values: weekday|weekend|holiday.',
  `for_run` BIGINT COMMENT 'FK to forecast.run.run_id — Accuracy records are computed for a specific forecast run. FK enables traceability from accuracy metrics to the exact run and input data.',
  `forecast_horizon_hours` INT COMMENT 'The time horizon of the forecast being evaluated, measured in hours from the forecast issuance time. Common values include 1-hour ahead, 24-hour ahead, 168-hour ahead (weekly), etc.',
  `forecast_type` STRING COMMENT 'The category of forecast being evaluated. Indicates whether this accuracy measurement applies to load forecasting, generation forecasting, renewable intermittency prediction, demand response, price forecasting, or reserve requirements. Valid values: load|generation|renewable|demand_response|price|reserve.',
  `forecasted_value_mw` DECIMAL(18,4) COMMENT 'The predicted value from the forecast model, measured in megawatts. This is the value that was forecasted for the interval and is being compared against actuals.',
  `granularity_level` STRING COMMENT 'The geographic or organizational level at which the forecast accuracy is measured. System-level represents total utility territory, zone represents transmission zones, substation and feeder represent distribution levels. Valid values: system|zone|substation|feeder|customer_segment|asset.',
  `improvement_opportunity_flag` BOOLEAN COMMENT 'Boolean indicator flagging forecast intervals or conditions where significant accuracy improvement opportunities exist. Used to prioritize model tuning and enhancement efforts.',
  `interval_end_timestamp` TIMESTAMP COMMENT 'The ending timestamp of the forecast interval being evaluated. Represents the end of the period for which the forecast was made and is now being measured against actuals.',
  `interval_start_timestamp` TIMESTAMP COMMENT 'The beginning timestamp of the forecast interval being evaluated. Represents the start of the period for which the forecast was made and is now being measured against actuals.',
  `mae_mw` DECIMAL(18,4) COMMENT 'The Mean Absolute Error for the forecast interval or aggregation period, measured in megawatts. Represents the average magnitude of forecast errors in absolute terms.',
  `mape` DECIMAL(10,4) COMMENT 'The Mean Absolute Percentage Error for the forecast interval or aggregation period. Represents the average magnitude of forecast errors as a percentage of actual values. Industry standard accuracy metric for forecast performance.',
  `measurement_timestamp` TIMESTAMP COMMENT 'The date and time when the forecast accuracy measurement was calculated and recorded. Represents when actuals were compared against forecasted values.',
  `model_version` STRING COMMENT 'The version identifier of the forecasting model that produced the forecast being evaluated. Enables tracking of model performance across versions and model updates.',
  `notes` STRING COMMENT 'Free-text field for capturing contextual information about the accuracy measurement, including explanations for anomalies, data quality issues, or special conditions affecting the forecast.',
  `peak_error_mw` DECIMAL(18,4) COMMENT 'The maximum absolute error observed during the forecast period. Critical for evaluating forecast performance during peak demand or generation periods.',
  `peak_error_timestamp` TIMESTAMP COMMENT 'The timestamp when the peak error occurred. Identifies the specific interval with the largest forecast deviation.',
  `percentage_error` DECIMAL(10,4) COMMENT 'The error expressed as a percentage of the actual value, calculated as ((forecasted_value_mw - actual_value_mw) / actual_value_mw) * 100. Used in Mean Absolute Percentage Error (MAPE) calculations.',
  `regulatory_threshold_met` BOOLEAN COMMENT 'Boolean flag indicating whether the forecast accuracy met regulatory or contractual accuracy thresholds. Used for compliance reporting to FERC, NERC, or RTO/ISO requirements.',
  `rmse_mw` DECIMAL(18,4) COMMENT 'The Root Mean Squared Error for the forecast interval or aggregation period, measured in megawatts. Penalizes larger errors more heavily than MAE and is sensitive to outliers.',
  `sample_size` INT COMMENT 'The number of individual forecast intervals included in the accuracy calculation. Relevant when accuracy metrics are aggregated across multiple intervals or data points.',
  `season` STRING COMMENT 'The meteorological season during which the forecast interval occurred. Used to track accuracy performance by seasonal patterns and weather regimes. Valid values: winter|spring|summer|fall.',
  `squared_error` DECIMAL(24,8) COMMENT 'The square of the difference between forecasted and actual values, calculated as (forecasted_value_mw - actual_value_mw)^2. Used in Root Mean Squared Error (RMSE) calculations.',
  `time_of_day_category` STRING COMMENT 'Classification of the forecast interval by time-of-day load pattern. Used to evaluate accuracy during different daily load shapes and operational conditions. Valid values: overnight|morning_ramp|midday|evening_peak|night.',
  `updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this accuracy record was last modified. Used for tracking changes to accuracy measurements as actuals are revised or data quality improves.',
  `weather_regime` STRING COMMENT 'The weather condition classification during the forecast interval. Used to evaluate forecast accuracy under different weather scenarios that impact load and renewable generation. Valid values: normal|extreme_heat|extreme_cold|high_wind|low_wind|storm.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_accuracy` PRIMARY KEY (`accuracy_id`)
)
USING DELTA
COMMENT 'Transactional entity capturing post-hoc forecast accuracy measurements comparing forecasted values against actuals for a completed forecast run. Stores MAPE (Mean Absolute Percentage Error), MAE (Mean Absolute Error), RMSE, bias, and peak error metrics at system, zone, and interval levels. Tracks accuracy by forecast horizon, season, and weather regime. Used for model performance governance, regulatory reporting, and continuous improvement of forecasting processes. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ForecastAccuracy',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.accuracy'
);

-- IrpScenario  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `forecast`.`irp_scenario` (
  `irp_scenario_id` BIGINT NOT NULL COMMENT 'Unique identifier for the IRP scenario. Primary key for the irp_scenario product.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: IRP scenarios model future control area configurations, load growth, generation mix, and transmission expansion. Utilities plan generation and transmission investments within control area operational',
  `irp_filing_id` BIGINT COMMENT 'Reference to the parent IRP filing submission to the state Public Utility Commission (PUC). Links this scenario to the regulatory filing docket.',
  `owning_org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: IRP scenarios are developed and owned by specific planning departments/organizational units for territorial and functional accountability. Required for regulatory filings (PUC dockets) to identify res',
  `parent_scenario_irp_scenario_id` BIGINT COMMENT 'Reference to the parent scenario if this is a sensitivity or variant scenario. Links sensitivity scenarios back to their base case for comparison. Null for base case scenarios.',
  `planning_assumption_id` BIGINT COMMENT 'FK to forecast.load_growth_assumption.load_growth_assumption_id — IRP scenarios are built on specific planning assumptions (load growth, fuel price). Must link for scenario reproducibility.',
  `approved_by` STRING COMMENT 'Name or identifier of the executive or committee that approved this scenario for inclusion in the IRP filing. Provides accountability and governance trail.',
  `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when this scenario was formally approved for inclusion in the IRP filing. Marks transition from draft to official status.',
  `battery_storage_capacity_mw` DECIMAL(10,2) COMMENT 'Total planned battery energy storage system (BESS) capacity additions over the planning horizon for this scenario, measured in megawatts (MW). Critical for renewable integration and grid flexibility.',
  `capacity_market_assumption` STRING COMMENT 'Assumed market structure for capacity procurement. None means vertically integrated utility; energy_only means no separate capacity payments; capacity_market means RTO/ISO capacity auction; hybrid means mixed approach. Valid values: none|energy_only|capacity_market|hybrid.',
  `carbon_policy_assumption` STRING COMMENT 'Carbon emissions policy framework assumed in this scenario. None means no carbon constraint; state_target follows state renewable portfolio standard (RPS) or clean energy goals; federal_mandate assumes national policy; carbon_tax models explicit carbon pricing; cap_and_trade models emissions trading system. Valid values: none|state_target|federal_mandate|carbon_tax|cap_and_trade.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this scenario record was first created in the system. Audit trail for scenario development lifecycle.',
  `demand_response_credit_mw` DECIMAL(10,2) COMMENT 'Assumed demand response (DR) program capacity credit in megawatts (MW) that can be counted toward resource adequacy. Represents load reduction capability from DR programs during peak periods.',
  `discount_rate_pct` DECIMAL(5,2) COMMENT 'Weighted average cost of capital (WACC) or discount rate used for net present value (NPV) calculations in this scenario, expressed as a percentage. Reflects utility cost of capital for investment analysis.',
  `distributed_energy_resource_penetration_pct` DECIMAL(5,2) COMMENT 'Assumed penetration of distributed energy resources (rooftop solar, battery storage, microgrids) as a percentage of total capacity by end of planning horizon. Impacts load forecast and grid planning.',
  `economic_growth_assumption` STRING COMMENT 'Assumed economic growth trajectory for the service territory. Low assumes slow GDP growth; reference uses consensus forecasts; high assumes robust expansion; recession models economic downturn impacts on load. Valid values: low|reference|high|recession.',
  `electrification_assumption` STRING COMMENT 'Assumed rate of transportation and building electrification (electric vehicles, heat pumps) over the planning horizon. Low assumes slow adoption; reference uses market forecasts; high assumes policy-driven acceleration. Valid values: low|reference|high.',
  `energy_efficiency_savings_gwh` DECIMAL(12,2) COMMENT 'Cumulative annual energy savings from energy efficiency programs by the end of the planning horizon, measured in gigawatt-hours (GWh). Reduces forecasted energy requirements.',
  `filed_timestamp` TIMESTAMP COMMENT 'Timestamp when the IRP containing this scenario was filed with the state Public Utility Commission (PUC). Establishes regulatory record date.',
  `fossil_capacity_retirement_mw` DECIMAL(10,2) COMMENT 'Total planned fossil fuel generation capacity retirements (coal, natural gas, oil) over the planning horizon for this scenario, measured in megawatts (MW). Reflects decarbonization strategy and asset lifecycle management.',
  `irp_uses_peak_demand` BIGINT COMMENT 'FK to forecast.peak_demand_forecast.peak_demand_forecast_id — IRP scenarios reference peak demand forecasts for capacity planning. Critical for resource adequacy analysis.',
  `load_growth_assumption_pct` DECIMAL(5,2) COMMENT 'Average annual load growth rate assumption for this scenario expressed as a percentage (e.g., 1.50 for 1.5% annual growth). Key driver for capacity planning and resource adequacy analysis.',
  `modeling_software` STRING COMMENT 'Name and version of the capacity expansion or production cost modeling software used to develop this scenario (e.g., PLEXOS, Aurora, PROMOD, Encompass). Important for model transparency and reproducibility.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this scenario record was last modified. Tracks iterative refinement during IRP development process.',
  `natural_gas_price_trajectory` STRING COMMENT 'Assumed natural gas price path over the planning horizon. Low assumes sustained low prices; reference uses EIA or market consensus; high assumes supply constraints or carbon pricing; volatile models price uncertainty. Valid values: low|reference|high|volatile.',
  `peak_demand_growth_assumption_pct` DECIMAL(5,2) COMMENT 'Average annual peak demand (MW) growth rate assumption for this scenario expressed as a percentage. May differ from energy growth due to load shape changes, electrification, or demand response programs.',
  `planning_horizon_end_year` INT COMMENT 'Final year of the planning horizon covered by this scenario (typically 10-20 years from start). Four-digit year (e.g., 2043).',
  `planning_horizon_start_year` INT COMMENT 'First year of the planning horizon covered by this scenario (typically current year or next year). Four-digit year (e.g., 2024).',
  `puc_docket_number` STRING COMMENT 'State PUC docket or case number assigned to the IRP filing containing this scenario. Links scenario to regulatory proceeding for tracking and reference.',
  `reliability_metric_lole` DECIMAL(8,4) COMMENT 'Loss of Load Expectation (LOLE) reliability metric for this scenario, typically measured in days per year. Industry standard is 0.1 days/year (one day in ten years). Demonstrates resource adequacy.',
  `renewable_capacity_addition_mw` DECIMAL(10,2) COMMENT 'Total planned renewable generation capacity additions (solar, wind, hydro, biomass) over the planning horizon for this scenario, measured in megawatts (MW). Key metric for tracking renewable energy integration.',
  `renewable_target_pct` DECIMAL(5,2) COMMENT 'Target renewable energy percentage of total generation by the end of the planning horizon. Reflects state RPS requirements or utility commitments (e.g., 50.00 for 50% renewable by 2030).',
  `reserve_margin_target_pct` DECIMAL(5,2) COMMENT 'Planning reserve margin target for resource adequacy expressed as a percentage above forecasted peak demand (e.g., 15.00 for 15% reserve margin). Ensures sufficient capacity to meet reliability standards.',
  `retirement_schedule_assumption` STRING COMMENT 'Assumed retirement schedule for existing generation assets. Baseline follows planned retirements; accelerated models early coal/gas plant closures; delayed extends asset life; policy_driven reflects regulatory mandates. Valid values: baseline|accelerated|delayed|policy_driven.',
  `scenario_code` STRING COMMENT 'Business identifier code for the scenario (e.g., BASE_2024, HIGH_GROWTH_2024, LOW_CARBON_2024). Used in regulatory filings and internal planning documents. Pattern: ^[A-Z0-9_-]{2,20}$.',
  `scenario_description` STRING COMMENT 'Detailed narrative description of the scenario including key assumptions, strategic rationale, and how it differs from other scenarios in the IRP. Used in regulatory filings and stakeholder presentations.',
  `scenario_name` STRING COMMENT 'Descriptive name of the IRP scenario (e.g., Base Case, High Load Growth, Accelerated Decarbonization, Low Gas Price). Human-readable label for reports and presentations.',
  `scenario_notes` STRING COMMENT 'Additional notes, caveats, or technical details about the scenario that do not fit in other structured fields. Used for model documentation and knowledge transfer.',
  `scenario_status` STRING COMMENT 'Current lifecycle status of the scenario. Draft indicates work in progress; under_review means internal stakeholder review; approved means executive sign-off; filed means submitted to PUC; archived means superseded by newer IRP. Valid values: draft|under_review|approved|filed|archived.',
  `scenario_type` STRING COMMENT 'Classification of the scenario within the IRP framework. Base represents the most likely case; sensitivity tests single variable changes; alternative explores different strategic paths; stress_test examines extreme conditions; bookend defines planning boundaries. Valid values: base|sensitivity|alternative|stress_test|bookend.',
  `sensitivity_variable` STRING COMMENT 'For sensitivity scenarios, identifies the specific variable being tested (e.g., natural gas price, load growth, carbon price, technology cost). Null for base case scenarios.',
  `stakeholder_feedback_summary` STRING COMMENT 'Summary of stakeholder comments and feedback received on this scenario during public comment periods or technical conferences. Documents stakeholder engagement process required by many state PUCs.',
  `technology_cost_assumption` STRING COMMENT 'Assumed capital cost trajectory for new generation technologies (solar, wind, battery storage, gas turbines). Low assumes rapid cost declines; reference uses industry consensus; high assumes slower learning curves. Valid values: low|reference|high.',
  `total_co2_emissions_million_tons` DECIMAL(12,2) COMMENT 'Cumulative CO2 emissions over the planning horizon for this scenario, measured in million metric tons. Key environmental metric for comparing scenarios and demonstrating compliance with carbon reduction goals.',
  `total_resource_cost_npv_million` DECIMAL(15,2) COMMENT 'Net present value of total resource costs (capital, fixed O&M, variable O&M, fuel) over the planning horizon for this scenario, in millions of dollars. Key metric for comparing scenario economics.',
  `transmission_expansion_assumption` STRING COMMENT 'Assumed level of transmission system expansion over the planning horizon. None means no new transmission; limited means targeted upgrades; moderate means regional expansion; aggressive means major interstate projects. Valid values: none|limited|moderate|aggressive.',
  `weather_normalization_method` STRING COMMENT 'Method used to normalize weather impacts in load forecasting. Historical_average uses 10-30 year average; climate_adjusted incorporates climate change projections; extreme_weather models increased frequency of heat waves and cold snaps. Valid values: historical_average|climate_adjusted|extreme_weather.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_irp_scenario` PRIMARY KEY (`irp_scenario_id`)
)
USING DELTA
COMMENT 'Master record for an Integrated Resource Plan scenario and its year-by-year planning data used in long-term capacity planning and resource adequacy analysis. Captures scenario parameters (load growth, fuel price trajectory, carbon policy, renewable targets, DR credits, retirement schedule) at the header level. Stores annual planning data for each year within the scenario including forecasted peak demand (MW), annual energy requirement (GWh), planned capacity additions/retirements (MW by resource type), reserve margin (%), renewable percentage, and CO2 emissions projection. Multiple scenarios per IRP filing (base, high growth, low carbon). Enables year-by-year resource adequacy gap analysis and investment planning. Submitted to state PUC as part of regulatory IRP process. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'IrpScenario',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.irp_scenario'
);

-- IrpScenarioYear  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `forecast`.`irp_scenario_year` (
  `irp_scenario_year_id` BIGINT NOT NULL COMMENT 'Unique identifier for each annual planning data record within an IRP scenario. Primary key for the irp_scenario_year entity.',
  `meter_point_id` BIGINT COMMENT 'Foreign key linking to metering.meter_point. Business justification: IRP scenario projections are grounded in historical consumption patterns at service points. Planners trace meter points to validate load growth assumptions and customer class trends. Real business pro',
  `primary_irp_scenario_id` BIGINT COMMENT 'Reference to the parent IRP scenario that this annual planning record belongs to. Links to the irp_scenario master entity.',
  `approval_status` STRING COMMENT 'Current approval status of this planning year data within the IRP scenario workflow. Tracks progression through planning review and approval process. Valid values: draft|under_review|approved|rejected|archived.',
  `approved_by` STRING COMMENT 'Username or identifier of the planning authority who approved this planning year data. Null if not yet approved.',
  `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this planning year data was approved. Null if not yet approved. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `average_lcoe_usd_per_mwh` DECIMAL(10,2) COMMENT 'Weighted average levelized cost of energy in US dollars per megawatt-hour across the generation portfolio for this planning year. Represents all-in cost of generation.',
  `capacity_factor_percent` DECIMAL(5,2) COMMENT 'Weighted average capacity factor as a percentage across the generation portfolio for this planning year. Represents actual generation relative to maximum potential generation.',
  `co2_emissions_projection_tons` DECIMAL(15,2) COMMENT 'Projected annual carbon dioxide emissions in metric tons for this planning year. Critical for environmental compliance, carbon pricing analysis, and sustainability reporting.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this planning year record was first created in the system. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `demand_response_capacity_mw` DECIMAL(12,3) COMMENT 'Total demand response capacity in megawatts (MW) planned for this year. Represents load reduction capability from DR programs and customer participation.',
  `der_capacity_mw` DECIMAL(12,3) COMMENT 'Total distributed energy resource capacity in megawatts (MW) planned for this year. Includes behind-the-meter solar, microgrids, and customer-sited generation.',
  `distribution_investment_usd` DECIMAL(18,2) COMMENT 'Planned distribution infrastructure investment in US dollars for this planning year. Includes distribution system upgrades, smart grid, and DER integration investments.',
  `emissions_intensity_kg_per_mwh` DECIMAL(10,3) COMMENT 'Projected carbon emissions intensity in kilograms of CO2 per megawatt-hour of generation. Measures carbon efficiency of the generation portfolio.',
  `energy_storage_capacity_mw` DECIMAL(12,3) COMMENT 'Total energy storage capacity in megawatts (MW) planned for this year. Includes battery storage, pumped hydro, and other storage technologies.',
  `forecasted_annual_energy_gwh` DECIMAL(15,3) COMMENT 'Projected total annual energy requirement in gigawatt-hours (GWh) for this planning year. Represents total electricity consumption across all customer classes.',
  `forecasted_peak_demand_mw` DECIMAL(12,3) COMMENT 'Projected system peak demand in megawatts (MW) for this planning year. Critical metric for resource adequacy planning and capacity expansion decisions.',
  `fossil_capacity_mw` DECIMAL(12,3) COMMENT 'Total fossil fuel generation capacity in megawatts (MW) planned for this year. Includes coal, natural gas, and oil-fired generation.',
  `fuel_cost_projection_usd` DECIMAL(18,2) COMMENT 'Projected total fuel costs in US dollars for fossil fuel and nuclear generation in this planning year. Based on forward fuel price curves and generation dispatch forecasts.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this planning year record was last updated. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
  `loss_of_load_probability` DECIMAL(8,6) COMMENT 'Calculated probability of loss of load events for this planning year. Reliability metric indicating likelihood of supply shortfall. Target typically <0.1 (one day in ten years).',
  `modified_by` STRING COMMENT 'Username or identifier of the user who last modified this planning year record. Supports audit trail and change tracking.',
  `net_capacity_change_mw` DECIMAL(12,3) COMMENT 'Net change in generation capacity (additions minus retirements) in megawatts (MW) for this planning year. Positive values indicate capacity growth, negative indicate reduction.',
  `nuclear_capacity_mw` DECIMAL(12,3) COMMENT 'Total nuclear generation capacity in megawatts (MW) planned for this year. Represents baseload nuclear power generation assets.',
  `planned_capacity_additions_mw` DECIMAL(12,3) COMMENT 'Total planned generation capacity additions in megawatts (MW) for this planning year across all resource types. Includes new builds, expansions, and acquisitions.',
  `planned_retirements_mw` DECIMAL(12,3) COMMENT 'Total planned generation capacity retirements in megawatts (MW) for this planning year. Includes decommissioning, mothballing, and asset sales.',
  `planning_reserve_margin_percent` DECIMAL(5,2) COMMENT 'Target planning reserve margin percentage for this year as defined by regional transmission organization or internal planning criteria. Differs from actual reserve margin.',
  `planning_year` INT COMMENT 'The calendar year for which this planning data applies within the IRP scenario horizon. Typically ranges from current year to 20-30 years forward.',
  `renewable_capacity_mw` DECIMAL(12,3) COMMENT 'Total renewable generation capacity in megawatts (MW) planned for this year. Includes solar, wind, hydro, biomass, and other renewable sources.',
  `renewable_percentage` DECIMAL(5,2) COMMENT 'Percentage of total generation capacity from renewable sources for this planning year. Used to track compliance with state RPS mandates and corporate sustainability goals.',
  `reserve_margin_percent` DECIMAL(5,2) COMMENT 'Planned reserve margin as a percentage of peak demand for this planning year. Represents excess capacity above peak demand to ensure reliability. Typically 15-20% per NERC standards.',
  `scenario_notes` STRING COMMENT 'Free-text notes documenting key assumptions, constraints, or special considerations for this planning year within the scenario. Captures planner commentary and decision rationale.',
  `total_capital_expenditure_usd` DECIMAL(18,2) COMMENT 'Total planned capital expenditure in US dollars for generation capacity additions, upgrades, and infrastructure investments in this planning year.',
  `total_operational_expenditure_usd` DECIMAL(18,2) COMMENT 'Total planned operational expenditure in US dollars for generation operations, maintenance, and fuel costs in this planning year.',
  `transmission_investment_usd` DECIMAL(18,2) COMMENT 'Planned transmission infrastructure investment in US dollars for this planning year. Includes new lines, substations, and grid upgrades to support generation additions.',
  `year_sequence` INT COMMENT 'Sequential ordering of this year within the IRP scenario planning horizon (1 for first year, 2 for second year, etc.). Enables chronological analysis.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_irp_scenario_year` PRIMARY KEY (`irp_scenario_year_id`)
)
USING DELTA
COMMENT 'Transactional entity capturing annual planning data for each year within an IRP scenario. Stores year-specific forecasted peak demand (MW), annual energy requirement (GWh), planned capacity additions (MW by resource type), planned retirements (MW), reserve margin (%), renewable percentage, and CO2 emissions projection. Enables year-by-year resource adequacy gap analysis and investment planning across the IRP planning horizon. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'IrpScenarioYear',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.irp_scenario_year'
);

-- CapacityRequirement  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `forecast`.`capacity_requirement` (
  `capacity_requirement_id` BIGINT NOT NULL COMMENT 'Unique identifier for the capacity requirement record. Primary key for the capacity requirement entity.',
  `capacity_irp_scenario_id` BIGINT COMMENT 'Reference to the IRP scenario or planning case that generated this capacity requirement. Links capacity planning to long-term resource strategy.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Capacity requirements are calculated per control area for resource adequacy, planning reserve margin compliance, and NERC reliability standards. Control area operators use capacity requirements to ens',
  `planning_period_id` BIGINT COMMENT 'Reference to the planning period for which this capacity requirement applies (e.g., annual IRP cycle, multi-year planning horizon).',
  `primary_irp_scenario_id` BIGINT COMMENT 'FK to forecast.irp_scenario.irp_scenario_id — Capacity requirements are derived from IRP scenarios. FK enables traceability from capacity obligations back to planning assumptions.',
  `rto_iso_zone_id` BIGINT COMMENT 'Reference to the RTO or ISO zone for which this capacity requirement is defined (e.g., PJM, MISO, CAISO, ERCOT, NYISO, ISO-NE).',
  `approval_date` DATE COMMENT 'Date when this capacity requirement was formally approved by the regulatory authority (PUC, FERC) or RTO/ISO governing body.',
  `approved_by` STRING COMMENT 'Name of the regulatory authority, commission, or governing body that approved this capacity requirement (e.g., \'FERC\', \'California PUC\', \'PJM Board\').',
  `capacity_auction_clearing_price_per_mw_day` DECIMAL(18,2) COMMENT 'Market clearing price from the most recent capacity auction in dollars per megawatt-day ($/MW-day). Used for capacity procurement cost forecasting and budget planning.',
  `capacity_deficiency_mw` DECIMAL(18,3) COMMENT 'Calculated capacity deficiency in megawatts (MW), representing the shortfall between the capacity requirement and available capacity. Positive values indicate a need for additional procurement.',
  `capacity_export_limit_mw` DECIMAL(18,3) COMMENT 'Maximum capacity in megawatts (MW) that can be exported to external zones or regions, representing surplus capacity available for sale in external markets.',
  `capacity_import_limit_mw` DECIMAL(18,3) COMMENT 'Maximum capacity in megawatts (MW) that can be imported from external zones or regions to meet the local capacity requirement, based on transmission interface limits.',
  `capacity_surplus_mw` DECIMAL(18,3) COMMENT 'Calculated capacity surplus in megawatts (MW), representing the excess capacity above the requirement. Positive values indicate over-procurement or reserve margin cushion.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this capacity requirement record was first created in the system.',
  `deficiency_penalty_rate_per_mw_day` DECIMAL(18,2) COMMENT 'Penalty rate assessed for capacity deficiency in dollars per megawatt-day ($/MW-day). Applied when a load-serving entity fails to meet its capacity obligation.',
  `demand_response_capacity_requirement_mw` DECIMAL(18,3) COMMENT 'Capacity requirement allocated to demand response programs in megawatts (MW), representing load reduction capability that can be dispatched during peak periods.',
  `effective_date` DATE COMMENT 'Date when this capacity requirement becomes effective and binding for planning and procurement activities.',
  `energy_storage_capacity_requirement_mw` DECIMAL(18,3) COMMENT 'Capacity requirement allocated to energy storage resources (battery, pumped hydro, compressed air) in megawatts (MW). Supports grid flexibility and renewable integration.',
  `expected_unserved_energy_mwh` DECIMAL(18,3) COMMENT 'Expected unserved energy limit in megawatt-hours (MWh), representing the maximum acceptable amount of load that may not be served due to capacity shortfalls. NERC reliability metric.',
  `expiration_date` DATE COMMENT 'Date when this capacity requirement expires or is superseded by a subsequent requirement. Null for open-ended requirements.',
  `filing_reference_number` STRING COMMENT 'Regulatory filing reference number or docket number associated with the approval of this capacity requirement (e.g., FERC docket number, PUC case number).',
  `flexible_capacity_requirement_mw` DECIMAL(18,3) COMMENT 'Capacity requirement in megawatts (MW) for flexible ramping resources capable of responding to rapid load changes and renewable intermittency. Supports grid flexibility needs.',
  `forecast_confidence_level_percent` DECIMAL(5,2) COMMENT 'Statistical confidence level for the peak demand forecast expressed as a percentage (e.g., 90.0% confidence interval). Indicates the reliability of the forecast used to set the capacity requirement.',
  `installed_capacity_requirement_mw` DECIMAL(18,3) COMMENT 'Total installed capacity requirement in megawatts (MW) calculated as peak demand plus planning reserve margin. This is the target capacity that must be procured or available.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this capacity requirement record was last modified or updated.',
  `local_capacity_requirement_mw` DECIMAL(18,3) COMMENT 'Capacity requirement in megawatts (MW) that must be met by resources located within a specific local reliability area or load pocket, due to transmission constraints.',
  `loss_of_load_probability_target` DECIMAL(10,8) COMMENT 'Target loss of load probability expressed as a decimal (e.g., 0.1 represents one day in ten years). NERC reliability standard threshold for acceptable risk of load shedding.',
  `net_qualifying_capacity_mw` DECIMAL(18,3) COMMENT 'Net qualifying capacity in megawatts (MW) representing the effective capacity contribution of resources after applying derating factors for availability, intermittency, and transmission constraints.',
  `notes` STRING COMMENT 'Free-text notes providing additional context, assumptions, or special considerations for this capacity requirement (e.g., policy drivers, market conditions, planning assumptions).',
  `peak_demand_forecast_mw` DECIMAL(18,3) COMMENT 'Forecasted peak demand in megawatts (MW) for the planning period, representing the maximum expected load that must be served.',
  `planning_reserve_margin_percent` DECIMAL(5,2) COMMENT 'Planning reserve margin expressed as a percentage above peak demand, representing the target capacity cushion to ensure reliability (e.g., 15.0% means capacity must be 115% of peak demand).',
  `renewable_capacity_requirement_mw` DECIMAL(18,3) COMMENT 'Capacity requirement allocated to renewable energy resources (wind, solar, hydro, biomass) in megawatts (MW). Driven by Renewable Portfolio Standard (RPS) mandates and clean energy targets.',
  `requirement_name` STRING COMMENT 'Business name or label for this capacity requirement (e.g., \'2025 Summer Peak Capacity Requirement\', \'PJM RPM 2024/2025\').',
  `requirement_status` STRING COMMENT 'Current lifecycle status of the capacity requirement: draft (under development), proposed (submitted for approval), approved (authorized by regulator), active (in effect), superseded (replaced by newer requirement), or archived (historical record). Valid values: draft|proposed|approved|active|superseded|archived.',
  `requirement_type` STRING COMMENT 'Classification of the capacity requirement type: installed capacity (ICAP), planning reserve margin (PRM), net qualifying capacity (NQC), resource adequacy (RA), or reliability must-run (RMR). Valid values: installed_capacity|planning_reserve_margin|net_qualifying_capacity|resource_adequacy|reliability_must_run.',
  `thermal_capacity_requirement_mw` DECIMAL(18,3) COMMENT 'Capacity requirement allocated to thermal generation resources (coal, natural gas, nuclear) in megawatts (MW). Used for resource mix planning and diversification analysis.',
  `transmission_constraint_adjustment_mw` DECIMAL(18,3) COMMENT 'Capacity adjustment in megawatts (MW) to account for transmission system constraints that limit the deliverability of generation capacity to load centers.',
  `unforced_capacity_requirement_mw` DECIMAL(18,3) COMMENT 'Unforced capacity requirement in megawatts (MW), representing capacity adjusted for expected forced outage rates. Used in PJM and other markets to account for resource reliability.',
  `weather_normalization_applied_flag` BOOLEAN COMMENT 'Boolean flag indicating whether weather normalization adjustments were applied to the peak demand forecast (True) or not (False). Weather normalization removes extreme weather variability.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_capacity_requirement` PRIMARY KEY (`capacity_requirement_id`)
)
USING DELTA
COMMENT 'Master entity defining resource adequacy capacity requirements and reliability targets for a planning period. Captures installed capacity reserve margin targets, planning reserve margin (PRM), net qualifying capacity (NQC) by resource type, and RTO/ISO-mandated capacity obligations (e.g., PJM RPM, MISO PRA). Stores NERC reliability standard thresholds including loss-of-load probability (LOLP) targets and expected unserved energy (EUE) limits. Drives capacity procurement triggers, deficiency penalties, and IRP resource selection. Updated annually per RTO/ISO capacity auction results. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CapacityRequirement',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.capacity_requirement'
);

-- EnergyPrice  <<CIM RegularIntervalSchedule : extension>>
CREATE TABLE IF NOT EXISTS `forecast`.`energy_price` (
  `energy_price_id` BIGINT NOT NULL COMMENT 'Primary key for energy_price',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: LMP forecasts are control-area-specific for market operations, interchange pricing, and economic dispatch optimization. Control area boundaries define pricing zones and congestion management regions i',
  `employee_id` BIGINT COMMENT 'Reference to the user or analyst who approved this forecast for publication and operational use. Supports accountability and governance.',
  `energy_forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Energy price forecasts are spatially scoped to pricing nodes, which are located within forecast zones. The zone table defines geographic boundaries and RTO/ISO zone mappings. Adding forecast_zone_id F',
  `energy_zone_id` BIGINT COMMENT 'FK to forecast.zone.zone_id — Energy price forecasts are scoped to pricing nodes within forecast zones. FK enables zone-level price aggregation.',
  `forecast_model_id` BIGINT COMMENT 'Foreign key linking to forecast.model. Business justification: Energy price forecasts are produced by registered forecasting models. The model table is the authoritative registry for model configuration and performance metrics. Adding forecast_model_id FK allows',
  `forecast_run_id` BIGINT COMMENT 'Foreign key linking to forecast.run. Business justification: energy_price is the master record for energy price forecasts; energy_price_forecast_interval contains interval-level detail. Linking to run establishes the execution context. The run table captures ru',
  `forecast_scenario_id` BIGINT COMMENT 'Reference to the forecast scenario under which this price forecast was generated (e.g., base case, high load, low fuel cost).',
  `irp_scenario_id` BIGINT COMMENT 'Foreign key linking to forecast.irp_scenario. Business justification: Energy price forecasts are used in IRP economic analysis and LCOE calculations. The irp_scenario table defines planning scenarios with load growth, carbon policy, and renewable targets. Adding irp_sce',
  `pricing_node_id` BIGINT COMMENT 'Reference to the specific pricing node (PNode) or location where this energy price forecast applies. Critical for Locational Marginal Price (LMP) forecasting.',
  `superseded_by_forecast_energy_price_id` BIGINT COMMENT 'Reference to the newer forecast that supersedes this one. Nullable if this is the current active forecast. Supports forecast version lineage.',
  `ancillary_services_price_usd_per_mwh` DECIMAL(18,6) COMMENT 'Forecasted price for ancillary services (regulation, spinning reserves, non-spinning reserves) in US dollars per megawatt-hour. Supports grid stability and frequency control cost modeling.',
  `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when this forecast was approved by an authorized user. Distinct lifecycle event from creation and modification.',
  `capacity_price_usd_per_mw_day` DECIMAL(18,6) COMMENT 'Forecasted capacity price in US dollars per megawatt-day. Represents the cost of ensuring resource adequacy and grid reliability through capacity markets.',
  `carbon_price_usd_per_ton` DECIMAL(18,6) COMMENT 'Forecasted carbon price or carbon tax in US dollars per ton of CO2 equivalent. Used for environmental compliance cost modeling and Renewable Portfolio Standard (RPS) analysis.',
  `coal_price_usd_per_ton` DECIMAL(18,6) COMMENT 'Forecasted coal price in US dollars per ton. Used for modeling generation costs for coal-fired power plants.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this forecast record was first created in the system. Audit trail for data lineage and compliance.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary values in this forecast (e.g., USD, CAD, EUR). Supports multi-currency operations for international utilities. Pattern: ^[A-Z]{3}$.',
  `forecast_confidence_level_percent` DECIMAL(5,2) COMMENT 'Statistical confidence level of the forecast expressed as a percentage (e.g., 80%, 90%, 95%). Indicates the probability that actual prices will fall within the forecasted range.',
  `forecast_effective_end_date` DATE COMMENT 'The last date for which this forecast is applicable. Defines the end of the forecast validity period. Nullable for open-ended forecasts.',
  `forecast_effective_start_date` DATE COMMENT 'The first date for which this forecast is applicable. Defines the beginning of the forecast validity period.',
  `forecast_identifier` STRING COMMENT 'Business-readable identifier or code for this forecast run, used for tracking and referencing in reports and analysis.',
  `forecast_interval_end_timestamp` TIMESTAMP COMMENT 'The precise end timestamp of the interval for which this price forecast applies. Defines the interval boundary for time-series price data.',
  `forecast_interval_start_timestamp` TIMESTAMP COMMENT 'The precise start timestamp of the interval for which this price forecast applies. Used for interval-level LMP forecasting at hourly or sub-hourly resolution.',
  `forecast_methodology` STRING COMMENT 'The methodology used to generate this forecast: fundamental (supply-demand modeling), statistical (time-series analysis), machine learning (AI/ML models), hybrid (combination), or expert judgment (analyst-driven). Valid values: fundamental|statistical|machine_learning|hybrid|expert_judgment.',
  `forecast_notes` STRING COMMENT 'Free-text notes or commentary from analysts regarding assumptions, limitations, or special considerations for this forecast. Supports transparency and decision-making context.',
  `forecast_source_system` STRING COMMENT 'Name or identifier of the source system that generated this forecast (e.g., OpenLink Endur, proprietary forecasting tool, third-party vendor). Supports data lineage and audit.',
  `forecast_status` STRING COMMENT 'Current lifecycle status of the forecast: draft (under development), approved (validated by analysts), published (released for operational use), superseded (replaced by newer forecast), or archived (historical record). Valid values: draft|approved|published|superseded|archived.',
  `forecast_type` STRING COMMENT 'Classification of the forecast horizon: short-term (hours to days), mid-term (weeks to months), long-term (years), day-ahead market (DAM), real-time market (RTM), or seasonal planning. Valid values: short_term|mid_term|long_term|day_ahead|real_time|seasonal.',
  `hedging_strategy_flag` BOOLEAN COMMENT 'Indicates whether this forecast is used for developing hedging strategies and risk management in energy trading. True if used for hedging, False otherwise.',
  `interval_duration_minutes` INT COMMENT 'The duration of the forecast interval in minutes (e.g., 5, 15, 60). Supports configurable resolution for different market and planning needs.',
  `iso_rto_code` STRING COMMENT 'Code identifying the ISO or RTO market region for this forecast (e.g., CAISO, PJM, ERCOT, MISO, NYISO, ISO-NE, SPP). Critical for market-specific price modeling.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this forecast record was last updated or modified. Supports change tracking and audit requirements.',
  `lcoe_calculation_flag` BOOLEAN COMMENT 'Indicates whether this forecast is used for LCOE calculations and generation asset economic analysis. True if used for LCOE, False otherwise.',
  `lmp_congestion_component_usd_per_mwh` DECIMAL(18,6) COMMENT 'Forecasted congestion component of the LMP in US dollars per megawatt-hour. Reflects transmission constraints and grid congestion costs at this pricing node.',
  `lmp_energy_component_usd_per_mwh` DECIMAL(18,6) COMMENT 'Forecasted energy component of the Locational Marginal Price in US dollars per megawatt-hour. Represents the marginal cost of serving the next increment of load at this location.',
  `lmp_loss_component_usd_per_mwh` DECIMAL(18,6) COMMENT 'Forecasted loss component of the LMP in US dollars per megawatt-hour. Accounts for electrical losses in transmission from generation to load.',
  `lmp_total_usd_per_mwh` DECIMAL(18,6) COMMENT 'Total forecasted Locational Marginal Price in US dollars per megawatt-hour. Sum of energy, congestion, and loss components. Primary price metric for market operations and economic dispatch.',
  `load_forecast_mw` DECIMAL(18,3) COMMENT 'Forecasted system load in megawatts for the interval or period. Key input assumption for price forecasting and economic dispatch modeling.',
  `market_type` STRING COMMENT 'The type of energy market this forecast applies to: day-ahead market (DAM), real-time market (RTM), bilateral contract, or forward market. Valid values: day_ahead|real_time|bilateral|forward.',
  `natural_gas_price_usd_per_mmbtu` DECIMAL(18,6) COMMENT 'Forecasted forward natural gas price in US dollars per million British thermal units. Critical input for generation cost modeling and LCOE calculations for gas-fired plants.',
  `ppa_valuation_flag` BOOLEAN COMMENT 'Indicates whether this forecast is specifically used for PPA economic valuation and contract negotiation. True if used for PPA analysis, False otherwise.',
  `published_timestamp` TIMESTAMP COMMENT 'Timestamp when this forecast was published and made available for operational decision-making, trading strategy, and planning activities.',
  `renewable_energy_credit_price_usd` DECIMAL(18,6) COMMENT 'Forecasted price for Renewable Energy Certificates in US dollars per certificate. Used for RPS compliance cost modeling and renewable energy valuation.',
  `renewable_generation_forecast_mw` DECIMAL(18,3) COMMENT 'Forecasted renewable generation (wind, solar, hydro) in megawatts. Accounts for renewable intermittency and its impact on market prices.',
  `transmission_constraint_flag` BOOLEAN COMMENT 'Indicates whether transmission constraints are expected to be binding during this forecast interval. True if constraints are active, False otherwise. Impacts congestion component of LMP.',
  `weather_scenario` STRING COMMENT 'The weather scenario assumption underlying this price forecast: normal (historical average), hot, cold, extreme heat, extreme cold, or mild. Weather is a key driver of load and renewable generation. Valid values: normal|hot|cold|extreme_heat|extreme_cold|mild.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_energy_price` PRIMARY KEY (`energy_price_id`)
)
USING DELTA
COMMENT 'Master record and interval-level values for forward energy price forecasts used in IRP economic analysis, PPA valuation, and trading strategy. Stores forecasted LMP by pricing node at the header level with fuel price trajectories, carbon price assumptions, and capacity price forecasts. Includes interval-level LMP ($/MWh) by PNode with energy, congestion, and loss components, forward natural gas price ($/MMBtu), and capacity price ($/MW-day) at configurable resolution. Supports LCOE calculations, economic dispatch optimization, hedging strategy development, bilateral contract valuation, and market participation decisions. | CMM: CIM RegularIntervalSchedule (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'EnergyPrice',
  'cmm.cim.class' = 'RegularIntervalSchedule',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.energy_price'
);

-- EnergyPriceForecastInterval  <<CIM RegularTimePoint : close>>
CREATE TABLE IF NOT EXISTS `forecast`.`energy_price_forecast_interval` (
  `energy_price_forecast_interval_id` BIGINT NOT NULL COMMENT 'Unique identifier for the energy price forecast interval record. Primary key for this table.',
  `energy_price_id` BIGINT COMMENT 'Reference to the parent energy price forecast run that generated this interval-level forecast. Links this interval to the overall forecast execution context.',
  `ancillary_services_price_forecast` DECIMAL(18,4) COMMENT 'Forecasted price for ancillary services in $/MWh. Includes regulation, spinning reserves, non-spinning reserves, and other grid reliability services.',
  `capacity_price_forecast` DECIMAL(18,4) COMMENT 'Forecasted capacity price in dollars per megawatt-day ($/MW-day). Represents the cost of ensuring sufficient generation capacity is available to meet peak demand.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this forecast interval record was first created in the system. Used for audit trails and data lineage tracking.',
  `data_source` STRING COMMENT 'Source system or vendor that provided input data for this forecast interval. May reference ISO/RTO market data feeds, weather services, or internal systems.',
  `forecast_accuracy_mape` DECIMAL(5,2) COMMENT 'Historical mean absolute percentage error for this model and interval type. Provides a measure of expected forecast accuracy based on past performance.',
  `forecast_confidence_level` DECIMAL(5,2) COMMENT 'Statistical confidence level of the price forecast expressed as a percentage (0-100). Indicates the probability that actual prices will fall within the forecasted range.',
  `forecast_lower_bound` DECIMAL(18,4) COMMENT 'Lower bound of the forecasted LMP price range in $/MWh. Represents the low end of the confidence interval for this forecast.',
  `forecast_upper_bound` DECIMAL(18,4) COMMENT 'Upper bound of the forecasted LMP price range in $/MWh. Represents the high end of the confidence interval for this forecast.',
  `interval_duration_minutes` INT COMMENT 'Duration of the forecast interval in minutes. Common values include 5, 15, 30, or 60 minutes depending on market resolution.',
  `interval_end_timestamp` TIMESTAMP COMMENT 'The ending timestamp of the forecast interval. Represents the end of the time period for which this price forecast applies.',
  `interval_sequence_number` INT COMMENT 'Sequential ordering of this interval within the parent forecast run. Used to maintain chronological order of forecast intervals.',
  `interval_start_timestamp` TIMESTAMP COMMENT 'The beginning timestamp of the forecast interval. Represents the start of the time period for which this price forecast applies.',
  `lmp_congestion_component_forecast` DECIMAL(18,4) COMMENT 'Forecasted congestion component of LMP in $/MWh. Represents the cost premium due to transmission constraints limiting power flow to this location.',
  `lmp_energy_component_forecast` DECIMAL(18,4) COMMENT 'Forecasted energy component of LMP in $/MWh. Represents the marginal cost of generating one additional MWh of electricity, excluding transmission congestion and losses.',
  `lmp_loss_component_forecast` DECIMAL(18,4) COMMENT 'Forecasted loss component of LMP in $/MWh. Represents the marginal cost of electrical losses in transmitting power to this location.',
  `lmp_total_forecast` DECIMAL(18,4) COMMENT 'Forecasted total Locational Marginal Price in dollars per megawatt-hour ($/MWh). Represents the complete cost of energy at this location and time, including energy, congestion, and loss components.',
  `load_forecast_mw` DECIMAL(18,4) COMMENT 'Forecasted electrical load demand in megawatts for this interval and location. Load is a primary driver of energy prices.',
  `market_type` STRING COMMENT 'The type of energy market for which this price forecast applies. Day-ahead market (DAM) forecasts next-day prices, real-time market (RTM) forecasts immediate dispatch prices, hour-ahead provides short-term forecasts, and forward represents longer-term contract prices. Valid values: day_ahead|real_time|hour_ahead|forward.',
  `market_zone` STRING COMMENT 'The market zone or load zone in which this PNode is located. Used for aggregating prices across geographic regions.',
  `model_type` STRING COMMENT 'Type of forecasting model used. Statistical models use time-series analysis, machine learning models use AI/ML algorithms, fundamental models use supply-demand economics, and hybrid models combine approaches. Valid values: statistical|machine_learning|fundamental|hybrid.',
  `model_version` STRING COMMENT 'Version identifier of the forecasting model used to generate this interval forecast. Enables tracking of model changes and performance over time.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this forecast interval record was last modified. Supports change tracking and audit requirements.',
  `natural_gas_price_forecast` DECIMAL(18,4) COMMENT 'Forecasted natural gas price in dollars per million British thermal units ($/MMBtu). Natural gas prices are a key driver of electricity prices due to gas-fired generation.',
  `notes` STRING COMMENT 'Free-text notes providing additional context about this forecast interval, such as unusual market conditions, data quality issues, or special assumptions.',
  `outage_impact_flag` BOOLEAN COMMENT 'Boolean flag indicating whether planned or forced generation or transmission outages are expected to impact prices during this interval.',
  `pnode_code` STRING COMMENT 'Identifier for the pricing node (PNode) at which this energy price forecast applies. PNodes represent specific locations in the transmission grid where prices are calculated.',
  `pnode_name` STRING COMMENT 'Human-readable name of the pricing node. Provides business-friendly identification of the location.',
  `price_interval_to_price_forecast` BIGINT COMMENT 'FK to forecast.energy_price_forecast.energy_price_forecast_id — Every price forecast interval MUST reference its parent energy price forecast. Required for economic dispatch optimization and hedging.',
  `published_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this forecast interval has been published for use in trading, hedging, or operational decisions.',
  `published_timestamp` TIMESTAMP COMMENT 'Timestamp when this forecast interval was published and made available to business users. Critical for audit trails and understanding forecast timing.',
  `renewable_energy_credit_price_forecast` DECIMAL(18,4) COMMENT 'Forecasted price for Renewable Energy Credits in dollars per megawatt-hour ($/MWh). RECs represent the environmental attributes of renewable generation and are traded separately from energy.',
  `renewable_generation_forecast_mw` DECIMAL(18,4) COMMENT 'Forecasted renewable energy generation in megawatts for this interval. Includes wind, solar, and other renewable sources that impact price through supply availability.',
  `temperature_forecast_fahrenheit` DECIMAL(5,2) COMMENT 'Forecasted ambient temperature in degrees Fahrenheit for this interval. Temperature is a key driver of electricity demand and therefore prices.',
  `transmission_constraint_status` STRING COMMENT 'Status of transmission constraints affecting this PNode during the forecast interval. Constraints drive congestion pricing. Valid values: unconstrained|constrained|severely_constrained.',
  `weather_scenario` STRING COMMENT 'Weather scenario classification used in this forecast. Different weather scenarios drive different load and price patterns. Valid values: normal|hot|cold|extreme_heat|extreme_cold.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_energy_price_forecast_interval` PRIMARY KEY (`energy_price_forecast_interval_id`)
)
USING DELTA
COMMENT 'Interval-level energy price forecast values for a parent energy price forecast run. Stores forecasted LMP ($/MWh) by PNode and time interval, including energy, congestion, and loss components. Also captures forward natural gas price ($/MMBtu) and capacity price ($/MW-day) at interval or monthly resolution. Enables granular economic dispatch optimization, hedging strategy development, and bilateral contract valuation. | CMM: CIM RegularTimePoint (close), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'EnergyPriceForecastInterval',
  'cmm.cim.class' = 'RegularTimePoint',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.energy_price_forecast_interval'
);

-- ForecastZone  <<CIM LoadArea : close>>
CREATE TABLE IF NOT EXISTS `forecast`.`zone` (
  `zone_id` BIGINT NOT NULL COMMENT 'Primary key for zone',
  `parent_zone_id` BIGINT COMMENT 'Reference to the parent zone in a hierarchical zone structure. Enables roll-up aggregation from distribution feeder zones to load zones to transmission zones to RTO/ISO market zones.',
  `area_square_km` DECIMAL(12,2) COMMENT 'Total geographic area of the forecast zone in square kilometers. Used for density calculations, load intensity analysis, and spatial planning.',
  `centroid_latitude` DECIMAL(10,7) COMMENT 'Latitude coordinate of the zone\'s geographic centroid in decimal degrees. Used for distance calculations, weather station proximity analysis, and map display.',
  `centroid_longitude` DECIMAL(10,7) COMMENT 'Longitude coordinate of the zone\'s geographic centroid in decimal degrees. Used for distance calculations, weather station proximity analysis, and map display.',
  `climate_zone` STRING COMMENT 'Climate classification for this zone based on Köppen climate classification or regional climate zones. Used for weather normalization and temperature sensitivity modeling. Examples: \'Humid Subtropical\', \'Mediterranean\', \'Continental\'.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this zone record was first created in the system. Used for audit trail and data lineage.',
  `customer_count` INT COMMENT 'Total number of customer accounts or service points within this forecast zone. Used for per-capita load analysis and customer density metrics.',
  `der_penetration_percent` DECIMAL(5,2) COMMENT 'Percentage of total load served by Distributed Energy Resources (behind-the-meter solar, battery storage, microgrids) within this zone. Used for DER impact forecasting and grid planning.',
  `effective_date` DATE COMMENT 'Date when this zone definition became effective for operational use. Used for temporal zone boundary changes and historical forecast reconciliation.',
  `expiration_date` DATE COMMENT 'Date when this zone definition expires or was retired. Null for currently active zones. Used for zone lifecycle management and historical analysis.',
  `feeder_count` INT COMMENT 'Number of distribution feeders that comprise or are contained within this forecast zone. Relevant for distribution feeder zones and load zones.',
  `forecast_accuracy_mape` DECIMAL(5,2) COMMENT 'Historical forecast accuracy for this zone measured as Mean Absolute Percentage Error. Lower values indicate better forecast performance. Used for zone-level accuracy tracking and model tuning.',
  `forecast_model_version` STRING COMMENT 'Version identifier of the forecast model or algorithm currently applied to this zone. Used for model performance tracking and version control in forecast accuracy analysis.',
  `geographic_boundary_wkt` STRING COMMENT 'Well-Known Text representation of the zone\'s geographic boundary polygon or multipolygon. Used for spatial queries, GIS integration, and zone overlap analysis. Conforms to OGC Simple Features specification.',
  `installed_generation_capacity_mw` DECIMAL(12,3) COMMENT 'Total installed generation capacity within this zone in megawatts. Includes conventional and renewable generation. Used for generation adequacy and renewable penetration analysis.',
  `modified_by` STRING COMMENT 'User or system identifier that last modified this zone record. Used for audit trail and change tracking.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this zone record was last modified. Used for audit trail and change tracking.',
  `notes` STRING COMMENT 'Free-text notes providing additional context about the zone definition, boundary changes, special characteristics, or operational considerations.',
  `peak_load_mw` DECIMAL(12,3) COMMENT 'Historical or design peak load for this zone in megawatts. Used as a reference point for forecast accuracy tracking and capacity adequacy assessment.',
  `primary_weather_station_code` STRING COMMENT 'Identifier of the primary weather station used for weather data correlation and temperature-sensitive load forecasting for this zone. Typically a NOAA station identifier or internal weather station code.',
  `renewable_capacity_mw` DECIMAL(12,3) COMMENT 'Total installed renewable generation capacity within this zone in megawatts. Includes solar, wind, hydro, and other renewable sources. Used for Renewable Portfolio Standard (RPS) tracking and intermittency forecasting.',
  `rto_iso_name` STRING COMMENT 'Name of the RTO or ISO that governs this zone. Examples: \'PJM\', \'CAISO\', \'ERCOT\', \'MISO\', \'ISO-NE\', \'NYISO\', \'SPP\'. Used for regulatory reporting and market data integration.',
  `rto_iso_zone_code` STRING COMMENT 'External zone code used by the Regional Transmission Organization or Independent System Operator for market operations, pricing, and settlement. Maps internal zones to RTO/ISO market zones for Day-Ahead Market (DAM) and Real-Time Market (RTM) alignment.',
  `substation_count` INT COMMENT 'Number of substations located within or serving this forecast zone. Used for infrastructure density analysis and capacity planning.',
  `time_zone` STRING COMMENT 'IANA time zone identifier for this zone. Used for timestamp normalization and daylight saving time adjustments in forecast calculations. Examples: \'America/New_York\', \'America/Chicago\', \'America/Los_Angeles\'.',
  `voltage_level_kv` STRING COMMENT 'Primary voltage level(s) associated with this zone. For transmission zones, this is the transmission voltage (e.g., \'345\', \'500\'). For distribution zones, this is the distribution voltage (e.g., \'12.47\', \'34.5\'). Multiple levels may be comma-separated.',
  `zone_code` STRING COMMENT 'Business identifier code for the forecast zone, used across operational systems and market reporting. Typically aligns with RTO/ISO zone naming conventions or internal geographic identifiers. Pattern: ^[A-Z0-9_-]{2,20}$.',
  `zone_name` STRING COMMENT 'Human-readable name of the forecast zone, used for reporting and display purposes. Examples: \'Metro East Load Zone\', \'Coastal Weather Zone\', \'Northern Transmission Zone\'.',
  `zone_status` STRING COMMENT 'Current lifecycle status of the forecast zone. Active zones are in operational use, inactive zones are temporarily suspended, retired zones are no longer used, and planned zones are defined for future use. Valid values: active|inactive|retired|planned.',
  `zone_type` STRING COMMENT 'Classification of the forecast zone by its primary purpose. Load zones aggregate customer demand, weather zones group meteorological data, transmission zones define grid topology, distribution feeder zones represent circuit-level aggregation, market zones align with RTO/ISO pricing nodes, and planning zones support long-term capacity planning. Valid values: load_zone|weather_zone|transmission_zone|distribution_feeder_zone|market_zone|planning_zone.',
  `created_by` STRING COMMENT 'User or system identifier that created this zone record. Used for audit trail and data lineage.',
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
  CONSTRAINT `pk_forecast_zone` PRIMARY KEY (`zone_id`)
)
USING DELTA
COMMENT 'Reference master defining geographic forecast zones used to spatially aggregate all forecast products. Captures zone name, type (load zone, weather zone, transmission zone, distribution feeder zone), geographic boundary, associated substations, and RTO/ISO zone mapping. Provides the spatial hierarchy for load, generation, renewable, and price forecasts. Enables zone-level accuracy tracking, planning aggregation, and alignment with RTO/ISO market zones. Integrates with Esri ArcGIS Utility Network geographic boundaries. | CMM: CIM LoadArea (close), IEC61970::LoadModel.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ForecastZone',
  'cmm.cim.class' = 'LoadArea',
  'cmm.cim.match' = 'close',
  'cmm.cim.package' = 'IEC61970::LoadModel',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'reference_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.zone',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- PlanningAssumption  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `forecast`.`planning_assumption` (
  `planning_assumption_id` BIGINT NOT NULL COMMENT 'Primary key for planning_assumption',
  `created_by_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Load growth and planning assumptions require analyst ownership for regulatory audit trails and IRP filings. Utilities must demonstrate who created and approved each assumption for PUC review. Critical',
  `superseded_by_assumption_planning_assumption_id` BIGINT COMMENT 'Reference to the planning assumption record that supersedes this assumption. Used for version control and historical tracking of assumption changes over time.',
  `approval_date` DATE COMMENT 'Date when the planning assumption was formally approved for use in Integrated Resource Plan (IRP), transmission planning, or capacity planning models. Critical for regulatory compliance and audit trail.',
  `approved_by` STRING COMMENT 'Name or identifier of the individual or committee that approved the planning assumption. Provides accountability and governance traceability for assumptions used in regulatory filings.',
  `assumption_category` STRING COMMENT 'Classification of the planning assumption type. Segments assumptions into load growth (customer class growth rates, Electric Vehicle (EV) adoption curves, electrification scenarios), fuel price (natural gas, coal, uranium, renewable fuel costs), carbon price trajectories, technology cost curves, economic indices, or policy scenarios. Valid values: load_growth|fuel_price|carbon_price|technology_cost|economic_indicator|policy_scenario.',
  `assumption_code` STRING COMMENT 'Business identifier code for the planning assumption used in Integrated Resource Plan (IRP) and capacity planning models. Externally referenced in regulatory filings and planning documentation. Pattern: ^[A-Z0-9_-]{4,20}$.',
  `assumption_description` STRING COMMENT 'Detailed textual description of the planning assumption including methodology, data sources, key drivers, and any caveats or limitations. Provides context for assumption interpretation and use in planning models.',
  `assumption_name` STRING COMMENT 'Descriptive name of the planning assumption for business user identification and reporting purposes.',
  `assumption_source` STRING COMMENT 'Source of the planning assumption. Examples include Energy Information Administration (EIA) Annual Energy Outlook (AEO), internal forecast, third-party consultant, industry benchmark, regulatory guidance, or historical trend analysis. Provides traceability for assumption provenance.',
  `assumption_status` STRING COMMENT 'Current lifecycle status of the planning assumption. Tracks approval workflow and version control for assumptions used in regulatory filings and resource planning models. Valid values: draft|under_review|approved|superseded|retired.',
  `assumption_subcategory` STRING COMMENT 'Detailed subcategory within the assumption category. Examples include residential load growth, commercial load growth, natural gas price, coal price, uranium price, renewable fuel cost, carbon tax, renewable technology cost, fossil technology cost, Gross Domestic Product (GDP) growth, employment rate, or renewable portfolio standard.',
  `assumption_value` DECIMAL(18,6) COMMENT 'Numeric value of the planning assumption. Interpretation depends on assumption_category and unit_of_measure. Examples include annual growth rate percentage, fuel price per Million British Thermal Unit (MMBtu), carbon price per ton Carbon Dioxide (CO2), or technology cost per Megawatt (MW).',
  `confidence_level` STRING COMMENT 'Qualitative assessment of confidence in the planning assumption based on data quality, source reliability, and historical accuracy. Used for risk assessment and scenario weighting in resource planning models. Valid values: high|medium|low.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the planning assumption record was first created in the system. Supports audit trail and data lineage tracking.',
  `customer_class` STRING COMMENT 'Customer class to which the load growth assumption applies. Used for customer class-specific growth rate assumptions in load forecasting and capacity planning models. Valid values: residential|commercial|industrial|agricultural|public_sector|all_classes.',
  `effective_end_date` DATE COMMENT 'Date after which the planning assumption is no longer effective and should not be used in planning models. Nullable for assumptions with indefinite validity. Supports temporal validity and version control.',
  `effective_start_date` DATE COMMENT 'Date from which the planning assumption becomes effective and should be used in planning models. Supports temporal validity and version control for assumptions.',
  `escalation_rate_percent` DECIMAL(5,2) COMMENT 'Annual escalation rate percentage applied to the assumption value over the planning horizon. Used for fuel price escalation, technology cost deflation, or inflation adjustments in long-term planning models.',
  `fuel_type` STRING COMMENT 'Fuel type for fuel price assumptions. Applicable when assumption_category is fuel_price. Used in generation cost models and resource selection optimization. Reference-value candidates: natural_gas|coal|uranium|solar|wind|hydro|biomass|oil|other.',
  `geographic_scope` STRING COMMENT 'Geographic scope to which the planning assumption applies. Examples include service territory, Regional Transmission Organization (RTO) region, Independent System Operator (ISO) zone, state, or national. Enables geographic segmentation of assumptions for transmission and capacity planning.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the planning assumption record was last modified. Supports audit trail and change tracking for regulatory compliance and data governance.',
  `notes` STRING COMMENT 'Additional notes, comments, or context regarding the planning assumption. Used for documenting special considerations, stakeholder feedback, or planning team insights.',
  `planning_horizon_year` INT COMMENT 'Target year for which this assumption applies within the long-term planning horizon. Typically ranges from current year plus one to current year plus twenty for Integrated Resource Plan (IRP) and transmission planning models.',
  `planning_period` STRING COMMENT 'Planning period designation within the planning horizon. Examples include near-term (years 1-5), mid-term (years 6-10), long-term (years 11-20), or specific multi-year blocks used in resource selection optimization.',
  `planning_scenario` STRING COMMENT 'Scenario identifier for multi-scenario sensitivity analysis. Examples include base case, high growth, low growth, high fuel price, low fuel price, aggressive decarbonization, or delayed policy implementation. Enables scenario-based resource adequacy and grid reliability planning.',
  `policy_driver` STRING COMMENT 'Policy or regulatory driver influencing the planning assumption. Examples include Renewable Portfolio Standard (RPS), carbon cap, Clean Power Plan, state energy policy, or federal tax incentive. Used for policy scenario modeling and regulatory compliance planning.',
  `regulatory_filing_reference` STRING COMMENT 'Reference to the regulatory filing or docket number where this assumption was submitted or approved. Examples include Public Utility Commission (PUC) docket numbers, Federal Energy Regulatory Commission (FERC) filing references, or Integrated Resource Plan (IRP) case numbers. Critical for regulatory compliance and audit trail.',
  `sensitivity_high_value` DECIMAL(18,6) COMMENT 'Upper bound value for sensitivity analysis. Represents the high-case scenario value used in multi-scenario planning and risk assessment.',
  `sensitivity_low_value` DECIMAL(18,6) COMMENT 'Lower bound value for sensitivity analysis. Represents the low-case scenario value used in multi-scenario planning and risk assessment.',
  `source_document_reference` STRING COMMENT 'Reference to the source document or publication from which the assumption was derived. Examples include EIA AEO 2023 Reference Case, Internal Load Forecast Report 2024-Q1, or Third-Party Market Analysis Report. Enables audit trail and assumption validation.',
  `technology_type` STRING COMMENT 'Generation or storage technology type for technology cost assumptions. Examples include Combined Cycle Gas Turbine (CCGT), solar photovoltaic, onshore wind, offshore wind, battery storage, pumped hydro, or nuclear. Applicable when assumption_category is technology_cost.',
  `unit_of_measure` STRING COMMENT 'Unit of measure for the assumption value. Examples include percent for growth rates, dollars per Million British Thermal Unit ($/MMBtu) for natural gas, dollars per ton ($/ton) for coal, dollars per pound Uranium-238 ($/lb U3O8) for uranium, dollars per Megawatt-Hour ($/MWh) for renewable fuel cost equivalent, dollars per ton Carbon Dioxide ($/ton CO2) for carbon price, or dollars per Kilowatt ($/kW) for technology cost.',
  `version_number` INT COMMENT 'Version number of the planning assumption. Incremented when assumption values or parameters are updated. Supports version control and change tracking for assumptions used in regulatory filings and planning models.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_planning_assumption` PRIMARY KEY (`planning_assumption_id`)
)
USING DELTA
COMMENT 'Master record for long-term planning assumptions used as inputs to IRP, transmission planning, and capacity planning models. Consolidates load growth assumptions (customer class growth rates, EV adoption curves, electrification scenarios, economic indices), fuel price assumptions (natural gas $/MMBtu, coal $/ton, uranium $/lb U3O8, renewable fuel cost $/MWh equivalent by planning period and scenario), and other scenario parameters including carbon price trajectories and technology cost curves. Tracks assumption source (EIA AEO, internal forecast, third-party), approval date, regulatory filing reference, sensitivity ranges, and approval status. Enables multi-scenario sensitivity analysis across the planning horizon and feeds generation cost models and resource selection optimization. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PlanningAssumption',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.planning_assumption'
);

-- FuelPriceAssumption  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `forecast`.`fuel_price_assumption` (
  `fuel_price_assumption_id` BIGINT NOT NULL COMMENT 'Unique identifier for the fuel price assumption record. Primary key for the fuel price assumption entity.',
  `baseline_assumption_id` BIGINT COMMENT 'Identifier of the baseline fuel price assumption against which this assumption is compared in sensitivity or scenario analysis. Supports variance analysis and risk quantification.',
  `created_by_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Fuel price assumptions are critical inputs to IRP and rate cases requiring analyst ownership for regulatory scrutiny. Utilities must document who developed fuel price forecasts for PUC cross-examinati',
  `superseded_by_assumption_fuel_price_assumption_id` BIGINT COMMENT 'Identifier of the fuel price assumption record that supersedes this one. Maintains version history and assumption lineage for audit and regulatory purposes.',
  `approval_status` STRING COMMENT 'Approval status indicating whether this fuel price assumption has been formally approved for use in generation dispatch modeling, IRP filings, and resource selection optimization. Valid values: pending|approved|rejected.',
  `approved_by` STRING COMMENT 'Name or identifier of the individual or committee that approved this fuel price assumption for use in planning and economic analysis.',
  `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this fuel price assumption was formally approved. Supports audit trail and version control for planning assumptions.',
  `assumption_code` STRING COMMENT 'Short alphanumeric code uniquely identifying this fuel price assumption within planning systems and Integrated Resource Plan (IRP) filings.',
  `assumption_name` STRING COMMENT 'Business-friendly name or label for this fuel price assumption set, used for identification in reports and planning documents.',
  `assumption_source` STRING COMMENT 'Source of the fuel price assumption data. Identifies whether the assumption is derived from EIA Annual Energy Outlook (AEO), internal forecasting models, third-party consultants, market forward curves, historical averages, or regulatory guidance. Valid values: eia_aeo|internal_forecast|third_party_consultant|market_forward_curve|historical_average|regulatory_guidance.',
  `assumption_source_detail` STRING COMMENT 'Additional detail about the assumption source, such as specific EIA AEO edition, consultant name, or market data provider. Supports audit trail and assumption validation.',
  `assumption_status` STRING COMMENT 'Current lifecycle status of the fuel price assumption. Tracks progression from draft through approval and eventual supersession by updated assumptions. Valid values: draft|under_review|approved|superseded|archived.',
  `carbon_intensity_kg_co2_per_mmbtu` DECIMAL(10,4) COMMENT 'Carbon dioxide emissions intensity of the fuel in kilograms CO2 per MMBtu. Used in emissions modeling, carbon cost calculations, and environmental compliance analysis.',
  `carbon_price_per_ton_co2` DECIMAL(12,4) COMMENT 'Assumed carbon price in US dollars per ton of CO2 emissions. Used to calculate carbon cost adder for generation dispatch and LCOE modeling under carbon pricing scenarios.',
  `coal_price_per_ton` DECIMAL(12,4) COMMENT 'Assumed price of coal in US dollars per short ton. Supports coal-fired generation cost modeling and LCOE calculations for existing and planned coal assets.',
  `confidence_level_percent` DECIMAL(5,2) COMMENT 'Statistical confidence level associated with the fuel price assumption, expressed as a percentage. Indicates the degree of certainty in the forecast based on historical volatility and market analysis.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this fuel price assumption record was first created in the system. Supports audit trail and data lineage tracking.',
  `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all fuel price values in this assumption record. Supports multi-currency planning for utilities operating across jurisdictions. Valid values: USD|CAD|EUR|GBP|MXN.',
  `delivery_point` STRING COMMENT 'Specific delivery point or pricing node for the fuel assumption (e.g., pipeline interconnection, coal rail terminal, uranium enrichment facility). Used for transportation cost modeling and delivered fuel price calculation.',
  `diesel_price_per_gallon` DECIMAL(12,4) COMMENT 'Assumed price of diesel fuel in US dollars per gallon. Used for backup generation, emergency peaking units, and distributed generation cost modeling.',
  `effective_date` DATE COMMENT 'Date from which this fuel price assumption becomes effective for use in generation dispatch modeling, procurement decisions, and infrastructure investment analysis.',
  `escalation_rate_percent` DECIMAL(5,2) COMMENT 'Annual escalation rate applied to the fuel price assumption over the planning horizon, expressed as a percentage. Used to project future fuel costs in multi-year IRP and LCOE analysis.',
  `expiration_date` DATE COMMENT 'Date after which this fuel price assumption is no longer valid for planning purposes. Supports assumption lifecycle management and prevents use of outdated data.',
  `fuel_oil_price_per_gallon` DECIMAL(12,4) COMMENT 'Assumed price of fuel oil in US dollars per gallon. Supports cost modeling for oil-fired peaking units and backup generation assets.',
  `fuel_type` STRING COMMENT 'Type of fuel for which the price assumption applies. Supports generation dispatch cost modeling and Levelized Cost of Energy (LCOE) calculations. Valid values: natural_gas|coal|uranium|biomass|diesel|fuel_oil.',
  `geographic_scope` STRING COMMENT 'Geographic region or market area to which this fuel price assumption applies (e.g., Henry Hub for natural gas, Powder River Basin for coal, regional ISO/RTO market). Supports location-specific cost modeling.',
  `heat_content_mmbtu_per_unit` DECIMAL(10,4) COMMENT 'Average heat content of the fuel in MMBtu per physical unit (e.g., MMBtu per ton of coal, MMBtu per gallon of diesel). Used to convert physical fuel quantities to energy equivalents for dispatch modeling.',
  `irp_filing_reference` STRING COMMENT 'Reference identifier linking this fuel price assumption to a specific IRP filing or docket number. Supports regulatory compliance and assumption traceability in rate cases.',
  `model_version` STRING COMMENT 'Version identifier of the forecasting model or methodology used to generate this fuel price assumption. Supports model governance and reproducibility.',
  `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this fuel price assumption record was last modified. Tracks changes and updates to assumption data over time.',
  `natural_gas_price_per_mmbtu` DECIMAL(12,4) COMMENT 'Assumed price of natural gas in US dollars per MMBtu. Used in generation dispatch cost modeling, combined cycle gas turbine (CCGT) economics, and peaking unit cost analysis.',
  `notes` STRING COMMENT 'Free-text field for additional context, assumptions, caveats, or special considerations related to this fuel price assumption. Supports documentation and knowledge transfer.',
  `planning_period_end_date` DATE COMMENT 'End date of the planning period for which this fuel price assumption is applicable. Defines the temporal boundary for economic analysis and dispatch modeling.',
  `planning_period_start_date` DATE COMMENT 'Start date of the planning period for which this fuel price assumption is applicable. Supports long-term capacity planning and resource adequacy analysis.',
  `renewable_fuel_cost_per_mwh` DECIMAL(12,4) COMMENT 'Assumed fuel cost equivalent for renewable generation in US dollars per MWh. Typically zero for wind and solar; may reflect biomass or biogas fuel costs for renewable thermal generation.',
  `scenario_name` STRING COMMENT 'Name of the planning scenario to which this fuel price assumption belongs (e.g., Base Case, High Gas Price, Low Gas Price, Renewable Acceleration). Used in IRP scenario modeling and sensitivity analysis.',
  `sensitivity_high_price` DECIMAL(12,4) COMMENT 'Upper bound fuel price for sensitivity analysis and risk assessment. Represents optimistic or high-price scenario for stress testing generation economics and resource selection.',
  `sensitivity_low_price` DECIMAL(12,4) COMMENT 'Lower bound fuel price for sensitivity analysis and risk assessment. Represents pessimistic or low-price scenario for stress testing generation economics and resource selection.',
  `transportation_cost_per_unit` DECIMAL(12,4) COMMENT 'Assumed transportation cost per unit of fuel (e.g., dollars per MMBtu for gas pipeline, dollars per ton for coal rail). Added to base fuel price to calculate delivered cost at generation facility.',
  `uranium_price_per_lb_u3o8` DECIMAL(12,4) COMMENT 'Assumed price of uranium in US dollars per pound of U3O8. Used in nuclear generation cost modeling and fuel cycle economic analysis.',
  `volatility_index` DECIMAL(8,4) COMMENT 'Measure of historical price volatility for the fuel type, used in risk assessment and stochastic modeling. Higher values indicate greater price uncertainty and risk exposure.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_fuel_price_assumption` PRIMARY KEY (`fuel_price_assumption_id`)
)
USING DELTA
COMMENT 'Master entity capturing fuel price assumptions used in generation dispatch cost modeling, IRP economic analysis, and LCOE calculations. Stores natural gas price ($/MMBtu), coal price ($/ton), uranium price ($/lb U3O8), and renewable fuel cost ($/MWh equivalent) by planning period and scenario. Tracks assumption source (EIA AEO, internal forecast, third-party), approval status, and sensitivity range. Feeds generation cost models and resource selection optimization. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'FuelPriceAssumption',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.fuel_price_assumption'
);

-- ForecastRun  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `forecast`.`forecast_run` (
  `forecast_run_id` BIGINT NOT NULL COMMENT 'Unique identifier for the forecast model run execution record. Primary key for the run entity.',
  `baseline_run_id` BIGINT COMMENT 'Reference to a previous forecast run used as the baseline for comparison or delta analysis, supporting forecast accuracy assessment and model improvement.',
  `forecast_model_id` BIGINT COMMENT 'Reference to the specific forecast model configuration used for this run, linking to the model registry.',
  `primary_forecast_employee_id` BIGINT COMMENT 'Identifier of the user or system account that initiated the forecast run for manual or event-triggered executions, supporting audit and accountability requirements.',
  `superseded_by_run_forecast_run_id` BIGINT COMMENT 'Reference to a subsequent forecast run that supersedes this run, establishing forecast version lineage and supporting operational decision-making with the most current forecast.',
  `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when the forecast run output was approved for publication, establishing the approval audit trail.',
  `compute_cluster_code` STRING COMMENT 'Identifier of the computational cluster or resource pool used to execute the forecast run, supporting performance analysis and resource allocation optimization.',
  `configuration_parameters` STRING COMMENT 'JSON or structured text representation of the model configuration parameters and hyperparameters used for this forecast run, enabling full reproducibility and parameter sensitivity analysis.',
  `convergence_iterations` INT COMMENT 'Number of computational iterations required for the forecast model to reach convergence or the maximum iteration limit, used for performance tuning and model diagnostics.',
  `convergence_status` STRING COMMENT 'Indicator of whether the forecast model achieved mathematical convergence within acceptable tolerance thresholds, critical for assessing forecast reliability and model stability. Valid values: converged|not_converged|partial_convergence|timeout.',
  `convergence_tolerance` DECIMAL(10,6) COMMENT 'The mathematical tolerance threshold used to determine model convergence, typically expressed as a percentage or absolute error metric.',
  `cpu_hours_consumed` DECIMAL(12,2) COMMENT 'Total computational resource consumption measured in CPU hours for this forecast run, used for cost allocation and capacity planning.',
  `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the forecast run record was first created in the system, supporting audit trail and data lineage requirements.',
  `duration_seconds` DECIMAL(12,2) COMMENT 'Total elapsed time in seconds for the forecast run execution, calculated from start to end timestamp for performance monitoring and capacity planning.',
  `end_timestamp` TIMESTAMP COMMENT 'Timestamp when the forecast model run execution completed or terminated, used to calculate run duration and performance metrics.',
  `error_message` STRING COMMENT 'Detailed error message or exception information captured if the forecast run failed or encountered critical issues, supporting troubleshooting and root cause analysis.',
  `execution_environment` STRING COMMENT 'The computational environment where the forecast run was executed, distinguishing between production forecasts and test or validation runs. Valid values: production|staging|development|test|validation.',
  `forecast_end_timestamp` TIMESTAMP COMMENT 'The ending timestamp of the forecast period that this run produces predictions for, defining the last interval of the forecast output.',
  `forecast_horizon_hours` INT COMMENT 'The time span in hours that this forecast run covers from the forecast start time, defining the look-ahead period for operational planning and dispatch decisions.',
  `forecast_start_timestamp` TIMESTAMP COMMENT 'The beginning timestamp of the forecast period that this run produces predictions for, defining the first interval of the forecast output.',
  `forecast_type` STRING COMMENT 'Classification of the forecast domain this run produces, distinguishing between load forecasting, generation forecasting, renewable intermittency prediction, price forecasting, and demand response forecasting. Valid values: load|generation|renewable|price|demand_response.',
  `geographic_scope` STRING COMMENT 'The geographic or electrical network level at which this forecast run operates, defining the spatial granularity of forecast outputs. Valid values: system|zone|substation|feeder|service_territory.',
  `input_data_snapshot_code` STRING COMMENT 'Reference identifier to the specific snapshot of input data used for this forecast run, enabling full traceability and reproducibility of forecast results by linking to historical, weather, and operational data versions. Pattern: ^[A-Z0-9_-]{10,50}$.',
  `interval_resolution_minutes` INT COMMENT 'The temporal granularity of forecast intervals produced by this run, typically 5, 15, 30, or 60 minutes for operational forecasting aligned with market and dispatch intervals.',
  `memory_peak_gb` DECIMAL(10,2) COMMENT 'Peak memory utilization in gigabytes during forecast run execution, used for resource sizing and performance optimization.',
  `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the forecast run record was last modified, tracking updates to status, validation results, or metadata throughout the run lifecycle.',
  `notes` STRING COMMENT 'Free-text notes or comments about the forecast run, capturing operational context, special conditions, or analyst observations relevant to forecast interpretation.',
  `output_record_count` BIGINT COMMENT 'Total number of forecast interval records produced by this run, used for completeness verification and data quality monitoring.',
  `output_validation_status` STRING COMMENT 'Result of automated validation checks applied to forecast output data, including range checks, consistency checks, and business rule validation to ensure forecast quality before publication. Valid values: passed|failed|warning|not_validated.',
  `published_flag` BOOLEAN COMMENT 'Indicator of whether this forecast run output has been published for operational use by dispatch, trading, and planning systems.',
  `published_timestamp` TIMESTAMP COMMENT 'Timestamp when the forecast run output was published and made available to downstream operational systems and users.',
  `run_number` STRING COMMENT 'Business-friendly identifier for the forecast run, typically formatted as a human-readable code for operational reference and audit trails. Pattern: ^[A-Z0-9]{8,20}$.',
  `run_status` STRING COMMENT 'Current lifecycle status of the forecast run execution, tracking progression from initiation through completion or failure states. Valid values: pending|running|completed|failed|cancelled|partial.',
  `run_to_model` BIGINT COMMENT 'FK to forecast.forecast_model.forecast_model_id — Every forecast run execution must reference the model version used. Core lineage FK for auditability.',
  `run_type` STRING COMMENT 'Classification of the forecast run execution trigger mechanism, distinguishing between automated scheduled runs, manual operator-initiated runs, event-driven runs, historical backfills, reforecasts, and validation runs. Valid values: scheduled|manual|event_triggered|backfill|reforecast|validation.',
  `start_timestamp` TIMESTAMP COMMENT 'Timestamp when the forecast model run execution began, marking the initiation of the computational process.',
  `triggered_by_event` STRING COMMENT 'Description or identifier of the specific event that triggered this forecast run for event-driven executions, such as significant weather changes, grid events, or market conditions.',
  `validation_error_count` INT COMMENT 'Total number of validation errors detected in the forecast output, used to assess data quality and determine if manual review or rerun is required.',
  `validation_warning_count` INT COMMENT 'Total number of validation warnings detected in the forecast output, indicating potential quality issues that do not prevent publication but require attention.',
  `warning_message` STRING COMMENT 'Warning messages or alerts generated during forecast run execution that do not prevent completion but indicate potential quality or performance issues.',
  `weather_data_source` STRING COMMENT 'Identification of the weather data provider or service used as input for this forecast run, such as NOAA, Weather Underground, or proprietary weather services.',
  `weather_scenario` STRING COMMENT 'Classification of the weather conditions or scenario used in the forecast model run, supporting sensitivity analysis and scenario planning for weather-dependent load and renewable generation forecasting. Reference-value candidates: actual|normal|hot|cold|extreme_heat|extreme_cold|high_wind|low_wind.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_forecast_run` PRIMARY KEY (`forecast_run_id`)
)
USING DELTA
COMMENT 'Transactional entity capturing the execution record of a forecast model run, including run timestamp, triggering event (scheduled, manual, event-triggered), input data snapshot reference, model version used, run duration, convergence status, and output validation flags. Provides operational lineage and auditability for all forecast outputs. Enables traceability from forecast interval values back to the specific model run and input data used, supporting regulatory and operational audit requirements. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ForecastRun',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.forecast_run'
);

-- ForecastRevision  <<CIM ActivityRecord : extension>>
CREATE TABLE IF NOT EXISTS `forecast`.`revision` (
  `revision_id` BIGINT NOT NULL COMMENT 'Primary key for revision',
  `forecast_run_id` BIGINT COMMENT 'Reference to the parent forecast that was revised. Links to the original forecast entity (load, generation, or other forecast type).',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Forecast revisions are spatially scoped to forecast zones. The zone table defines geographic boundaries and aggregation levels. Adding forecast_zone_id FK allows retrieval of zone_code, zone_name, and',
  `revision_approved_by_user_employee_id` BIGINT COMMENT 'Employee identifier or username of the supervisor who approved the forecast revision, if approval was required. Null if no approval was needed.',
  `revision_employee_id` BIGINT COMMENT 'Employee identifier or username of the analyst or operator who authorized and executed the forecast revision. Required for accountability and audit compliance.',
  `superseded_by_revision_id` BIGINT COMMENT 'Reference to a subsequent revision that supersedes this revision. Null if this is the current active revision. Enables complete version history tracking.',
  `affected_interval_end` TIMESTAMP COMMENT 'End timestamp of the forecast interval affected by this revision. Defines the end of the time window impacted by the forecast change.',
  `affected_interval_start` TIMESTAMP COMMENT 'Start timestamp of the forecast interval affected by this revision. Defines the beginning of the time window impacted by the forecast change.',
  `approval_required_flag` BOOLEAN COMMENT 'Indicates whether the revision required supervisory approval before being applied. True if approval was required, false if analyst had authority to revise independently.',
  `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the forecast revision was approved by a supervisor, if approval was required. Null if no approval was needed.',
  `authorizing_analyst_name` STRING COMMENT 'Full name of the analyst or operator who authorized the forecast revision. Supports human-readable audit trails and operational accountability.',
  `confidence_level_percent` DECIMAL(5,2) COMMENT 'Statistical confidence level of the revised forecast value, expressed as a percentage (e.g., 95.00 for 95% confidence). Indicates forecast reliability.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this revision record was first created in the system. Audit field for data lineage and compliance.',
  `data_source` STRING COMMENT 'Source system or data feed that triggered or provided input for the forecast revision (e.g., SCADA, weather service, market operator, EMS).',
  `demand_response_event_flag` BOOLEAN COMMENT 'Indicates whether the revision was triggered by activation or curtailment of a demand response program. True if DR-related, false otherwise.',
  `dispatch_adjustment_required_flag` BOOLEAN COMMENT 'Indicates whether the forecast revision requires immediate adjustment to generation dispatch schedules. True if dispatch change needed, false otherwise.',
  `forecast_horizon_hours` INT COMMENT 'Number of hours ahead from the revision timestamp to the affected forecast interval. Indicates whether this is a short-term operational forecast revision or longer-term planning revision.',
  `forecast_type` STRING COMMENT 'Type of forecast being revised: load forecast, generation forecast, renewable intermittency forecast, demand response forecast, price forecast, or interchange forecast. Valid values: load|generation|renewable|demand_response|price|interchange.',
  `geographic_scope` STRING COMMENT 'Geographic or operational scope of the forecast being revised: balancing authority area, control area, load zone, substation, or system-wide. Valid values: balancing_authority|control_area|zone|substation|system_wide.',
  `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this revision record was last modified. Audit field for tracking changes to revision metadata or status.',
  `market_impact_flag` BOOLEAN COMMENT 'Indicates whether the forecast revision has material impact on energy market operations, trading positions, or dispatch decisions. True if market-impacting, false otherwise.',
  `model_version` STRING COMMENT 'Version identifier of the forecasting model or algorithm that generated the revised forecast value, if applicable. Supports model performance tracking and audit.',
  `notes` STRING COMMENT 'Additional free-text notes or comments about the forecast revision. Provides supplementary context for operational review and post-event analysis.',
  `of_run` BIGINT COMMENT 'FK to forecast.run_log.run_log_id — Revisions modify outputs of a specific forecast run. Must trace back to the original run for audit trail.',
  `original_value_mw` DECIMAL(18,4) COMMENT 'Original forecasted value in megawatts before the revision was applied. Preserved for audit trail and variance analysis.',
  `reason_code` STRING COMMENT 'Standardized code indicating the reason for the forecast revision: weather update, generation unit trip, unit return to service, demand response program activation, market price signal change, actual load deviation from forecast, forecast model update, or manual operator override. Reference-value candidates: weather_update|unit_trip|unit_return|demand_response_activation|market_signal|load_deviation|forecast_model_update|operator_override.',
  `reason_description` STRING COMMENT 'Detailed free-text explanation of the reason for the forecast revision. Provides context beyond the standardized reason code for post-event root cause analysis.',
  `regulatory_reportable_flag` BOOLEAN COMMENT 'Indicates whether the forecast revision must be reported to regulatory authorities (NERC, FERC, or state PUC). True if reportable, false otherwise.',
  `revised_value_mw` DECIMAL(18,4) COMMENT 'Updated forecasted value in megawatts after the revision. Represents the new forecast value that supersedes the original.',
  `revision_method` STRING COMMENT 'Method by which the revision was generated: automated (system-generated based on rules or model updates), manual (analyst-initiated), or hybrid (system-suggested with analyst approval). Valid values: automated|manual|hybrid.',
  `revision_status` STRING COMMENT 'Current status of the forecast revision in its lifecycle: pending approval, approved, applied to operational forecast, superseded by later revision, or rejected. Valid values: pending|approved|applied|superseded|rejected.',
  `revision_timestamp` TIMESTAMP COMMENT 'Date and time when the forecast revision was made. Critical for intra-day forecast evolution tracking and real-time operations audit.',
  `sequence_number` INT COMMENT 'Sequential number indicating the order of revisions for a given forecast. First revision is 1, second is 2, etc. Enables tracking of revision history chronology.',
  `unit_outage_flag` BOOLEAN COMMENT 'Indicates whether the revision was triggered by a generation unit outage (forced or scheduled). True if outage-related, false otherwise.',
  `variance_mw` DECIMAL(18,4) COMMENT 'Difference between revised and original values in megawatts (revised minus original). Positive indicates upward revision, negative indicates downward revision.',
  `variance_percent` DECIMAL(8,4) COMMENT 'Percentage change from original to revised value. Calculated as (variance / original_value) * 100. Enables relative impact assessment.',
  `weather_event_flag` BOOLEAN COMMENT 'Indicates whether the revision was triggered by a significant weather event or weather forecast update. True if weather-related, false otherwise.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_revision` PRIMARY KEY (`revision_id`)
)
USING DELTA
COMMENT 'Transactional audit record capturing each revision to a published forecast value, including original value, revised value, revision timestamp, reason code (weather update, unit trip, demand response activation, market signal), and authorizing analyst. Maintains complete version history of forecast updates throughout the operating day or planning cycle. Required for NERC/FERC regulatory compliance, post-event root cause analysis, and real-time operations audit. Supports intra-day forecast evolution tracking critical for dispatch and trading decisions. | CMM: CIM ActivityRecord (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ForecastRevision',
  'cmm.cim.class' = 'ActivityRecord',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.revision'
);

-- ResourceAdequacyAssessment  <<CIM Document : extension>>
CREATE TABLE IF NOT EXISTS `forecast`.`resource_adequacy_assessment` (
  `resource_adequacy_assessment_id` BIGINT NOT NULL COMMENT 'Unique identifier for the resource adequacy assessment record. Primary key for this entity.',
  `capacity_requirement_id` BIGINT COMMENT 'FK to forecast.capacity_requirement.capacity_requirement_id — Resource adequacy assessments evaluate whether capacity meets requirements. This is the core RA compliance relationship.',
  `control_area_id` BIGINT COMMENT 'Foreign key linking to grid.control_area. Business justification: Resource adequacy assessments are performed at control area level for NERC compliance, reserve margin verification, and loss-of-load-expectation calculations. Balancing authorities must demonstrate ad',
  `forecast_zone_id` BIGINT COMMENT 'Foreign key linking to forecast.zone. Business justification: Resource adequacy assessments evaluate capacity sufficiency for a geographic area. The zone table defines forecast zones with peak load, installed capacity, and renewable penetration. Adding forecast_',
  `irp_scenario_id` BIGINT COMMENT 'FK to forecast.irp_scenario.irp_scenario_id — Resource adequacy assessments may be performed for specific IRP scenarios. FK enables scenario-specific adequacy evaluation.',
  `resource_capacity_requirement_id` BIGINT COMMENT 'FK to forecast.capacity_requirement.capacity_requirement_id — Resource adequacy assessments evaluate compliance against capacity requirements. FK is required for NERC reliability compliance tracking.',
  `resource_ra_against_capacity_req` BIGINT COMMENT 'FK to forecast.capacity_requirement.capacity_requirement_id — Resource adequacy assessments evaluate compliance against capacity requirement targets. FK enables compliance status determination.',
  `responsible_org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Resource adequacy assessments are owned by specific organizational units (resource adequacy department, planning department) for NERC and PUC compliance. Required for regulatory accountability, depart',
  `superseded_by_assessment_resource_adequacy_assessment_id` BIGINT COMMENT 'Identifier of the newer resource adequacy assessment that supersedes this assessment. Used to maintain assessment version history and lineage. Null if this is the current active assessment.',
  `approved_by` STRING COMMENT 'Name or identifier of the individual or role who approved this resource adequacy assessment for internal use or regulatory submission. Typically a senior executive or planning director.',
  `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this resource adequacy assessment was formally approved by the designated authority for internal use or regulatory submission.',
  `assessment_completion_timestamp` TIMESTAMP COMMENT 'Date and time when the resource adequacy assessment was completed and finalized for internal approval or regulatory submission.',
  `assessment_identifier` STRING COMMENT 'Externally-known business identifier or reference number for this resource adequacy assessment, used in regulatory filings and communications with NERC, RTO, and state PUC.',
  `assessment_methodology` STRING COMMENT 'Methodology used to conduct the resource adequacy assessment: deterministic (fixed reserve margin approach), probabilistic (LOLE/EUE Monte Carlo simulation), hybrid (combination of both methods). Determines calculation approach and reliability metrics. Valid values: deterministic|probabilistic|hybrid.',
  `assessment_period_end_date` DATE COMMENT 'End date of the planning period covered by this resource adequacy assessment. Defines the conclusion of the forecast horizon for capacity evaluation.',
  `assessment_period_start_date` DATE COMMENT 'Start date of the planning period covered by this resource adequacy assessment. Defines the beginning of the forecast horizon for capacity evaluation.',
  `assessment_status` STRING COMMENT 'Current lifecycle status of the resource adequacy assessment: draft (in preparation), under_review (internal or regulatory review), approved (finalized internally), filed (submitted to regulatory bodies), superseded (replaced by newer assessment). Valid values: draft|under_review|approved|filed|superseded.',
  `assessment_type` STRING COMMENT 'Type or category of resource adequacy assessment: seasonal (summer/winter peak), annual (full year), long-term (multi-year IRP), or special (event-driven or ad-hoc). Valid values: seasonal|annual|long_term|special.',
  `assessment_uses_peak_demand` BIGINT COMMENT 'FK to forecast.peak_demand_forecast.peak_demand_forecast_id — RA assessments use peak demand forecasts as the demand-side input to reserve margin calculations.',
  `available_generation_capacity_mw` DECIMAL(12,3) COMMENT 'Total available generation capacity in megawatts (MW) from all owned and contracted generation resources, accounting for planned outages, derates, and seasonal availability.',
  `capacity_market_purchases_mw` DECIMAL(12,3) COMMENT 'Generation capacity in megawatts (MW) procured through capacity markets, bilateral contracts, or power purchase agreements (PPA) to meet resource adequacy requirements. Supplements owned generation.',
  `capacity_surplus_deficit_mw` DECIMAL(12,3) COMMENT 'Net capacity surplus (positive value) or deficit (negative value) in megawatts (MW), calculated as the difference between available capacity and the capacity required to meet peak demand plus required reserves. Indicates whether additional capacity procurement or retirement is needed.',
  `compliance_status` STRING COMMENT 'Compliance status of the resource adequacy assessment against NERC, RTO, and state PUC reserve margin and reliability standards: compliant (meets all requirements), non_compliant (fails to meet one or more requirements), conditional (meets requirements under specific assumptions), pending_review (awaiting regulatory determination). Valid values: compliant|non_compliant|conditional|pending_review.',
  `created_by_user` STRING COMMENT 'Username or identifier of the system user who created this resource adequacy assessment record. Audit trail for accountability and compliance.',
  `created_timestamp` TIMESTAMP COMMENT 'Date and time when this resource adequacy assessment record was first created in the system. Audit trail for data lineage and compliance.',
  `demand_response_capacity_mw` DECIMAL(12,3) COMMENT 'Total demand response capacity in megawatts (MW) available for peak load reduction, including interruptible load programs, direct load control, and voluntary curtailment programs.',
  `der_penetration_percent` DECIMAL(5,2) COMMENT 'Percentage of peak demand served by Distributed Energy Resources (DER) including rooftop solar, battery storage, and behind-the-meter generation. Impacts net load forecast and capacity credit calculations.',
  `economic_scenario` STRING COMMENT 'Economic growth scenario assumed in the load forecast for this resource adequacy assessment: base (expected growth), high_growth (accelerated economic expansion), low_growth (slower expansion), recession (economic contraction). Impacts demand forecast and capacity requirements. Valid values: base|high_growth|low_growth|recession.',
  `electric_vehicle_load_mw` DECIMAL(12,3) COMMENT 'Incremental peak demand in megawatts (MW) from electric vehicle (EV) charging load forecasted for the assessment period. Increases total capacity requirement.',
  `energy_efficiency_adjustment_mw` DECIMAL(12,3) COMMENT 'Peak demand reduction in megawatts (MW) attributed to energy efficiency programs and measures implemented during the assessment period. Reduces net capacity requirement.',
  `expected_unserved_energy_mwh_per_year` DECIMAL(12,3) COMMENT 'Expected Unserved Energy (EUE) metric expressed in megawatt-hours per year (MWh/year), representing the expected amount of energy demand that cannot be served due to generation capacity shortfalls. Complements LOLE by quantifying the magnitude of potential shortfalls.',
  `filed_with_nerc_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this resource adequacy assessment has been filed with NERC as part of mandatory reliability reporting requirements. True if filed, False if not filed.',
  `filed_with_puc_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this resource adequacy assessment has been filed with the state Public Utility Commission (PUC) as part of integrated resource planning or rate case proceedings. True if filed, False if not filed.',
  `forced_outage_rate_percent` DECIMAL(5,2) COMMENT 'Average forced outage rate percentage assumed for the generation fleet in this assessment, representing the probability that a generating unit is unavailable due to unplanned outages. Used in probabilistic reliability calculations.',
  `forecasted_peak_demand_mw` DECIMAL(12,3) COMMENT 'Forecasted peak demand in megawatts (MW) for the assessment period, representing the highest expected load the utility must serve. Critical input for capacity adequacy calculations.',
  `last_modified_by_user` STRING COMMENT 'Username or identifier of the system user who last modified this resource adequacy assessment record. Audit trail for accountability and compliance.',
  `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this resource adequacy assessment record was last updated or modified. Audit trail for data lineage and compliance.',
  `loss_of_load_expectation_days_per_year` DECIMAL(8,4) COMMENT 'Loss of Load Expectation (LOLE) metric expressed in days per year, representing the expected number of days per year when available generation capacity is insufficient to meet demand. Industry standard reliability target is typically 0.1 days/year (one day in ten years).',
  `model_version` STRING COMMENT 'Version identifier of the resource adequacy model, simulation tool, or analytical framework used to perform this assessment. Enables traceability and reproducibility.',
  `nerc_filing_date` DATE COMMENT 'Date when this resource adequacy assessment was officially filed with NERC for compliance and reliability reporting purposes. Null if not yet filed.',
  `notes` STRING COMMENT 'Free-text notes, comments, or explanatory information about this resource adequacy assessment, including assumptions, limitations, special conditions, or regulatory feedback. Supports documentation and audit trail.',
  `peak_demand_timestamp` TIMESTAMP COMMENT 'Forecasted date and time when the peak demand is expected to occur during the assessment period. Used for operational planning and dispatch scheduling.',
  `planned_capacity_additions_mw` DECIMAL(12,3) COMMENT 'Total planned generation capacity additions in megawatts (MW) expected to come online during the assessment period, including new builds, repowering projects, and capacity purchases. Increases available capacity.',
  `planned_capacity_retirements_mw` DECIMAL(12,3) COMMENT 'Total planned generation capacity retirements in megawatts (MW) expected during the assessment period, including plant closures, decommissioning, and end-of-life retirements. Reduces available capacity.',
  `planning_reserve_margin_percent` DECIMAL(5,2) COMMENT 'Planning reserve margin expressed as a percentage, representing the amount of generation capacity above forecasted peak demand required to ensure reliability. Calculated as ((Available Capacity - Peak Demand) / Peak Demand) * 100. Regulatory requirement varies by RTO and state PUC.',
  `puc_filing_date` DATE COMMENT 'Date when this resource adequacy assessment was officially filed with the state Public Utility Commission (PUC) as part of regulatory proceedings. Null if not yet filed.',
  `renewable_penetration_percent` DECIMAL(5,2) COMMENT 'Percentage of total generation capacity from renewable energy sources (wind, solar, hydro, biomass) in the resource mix for this assessment period. Impacts capacity factor assumptions and intermittency risk.',
  `required_reserve_margin_percent` DECIMAL(5,2) COMMENT 'Minimum planning reserve margin percentage mandated by NERC, RTO, or state PUC for this assessment period. Benchmark against which actual reserve margin is evaluated for compliance.',
  `rto_iso_region` STRING COMMENT 'Regional Transmission Organization (RTO) or Independent System Operator (ISO) region for which this resource adequacy assessment applies (e.g., PJM, MISO, CAISO, ERCOT, SPP, NYISO, ISO-NE). Determines applicable reliability standards and reserve margin requirements.',
  `weather_scenario` STRING COMMENT 'Weather scenario or climate condition assumed in the resource adequacy assessment: normal (typical weather patterns), extreme_heat (high cooling demand), extreme_cold (high heating demand), drought (reduced hydro availability), high_wind (increased wind generation), low_wind (reduced wind generation). Critical for stress-testing capacity adequacy. Valid values: normal|extreme_heat|extreme_cold|drought|high_wind|low_wind.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_resource_adequacy_assessment` PRIMARY KEY (`resource_adequacy_assessment_id`)
)
USING DELTA
COMMENT 'Master entity capturing periodic resource adequacy assessments evaluating whether the utility has sufficient generation and demand response capacity to meet forecasted peak demand with required reserve margins. Stores assessment period, planning reserve margin (%), loss-of-load expectation (LOLE in days/year), expected unserved energy (EUE in MWh/year), capacity surplus/deficit (MW), and compliance status against NERC and RTO standards. Filed with NERC and state PUC. | CMM: CIM Document (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ResourceAdequacyAssessment',
  'cmm.cim.class' = 'Document',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.resource_adequacy_assessment'
);

-- ScenarioFuelPrice  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `forecast`.`scenario_fuel_price` (
  `scenario_fuel_price_id` BIGINT NOT NULL COMMENT 'Unique identifier for this scenario-specific fuel price assignment. Primary key.',
  `fuel_price_assumption_id` BIGINT COMMENT 'Foreign key linking to the fuel price assumption record being applied to this scenario',
  `irp_scenario_id` BIGINT COMMENT 'Foreign key linking to the IRP scenario to which this fuel price assumption is applied',
  `assigned_by` STRING COMMENT 'Name or identifier of the planner or analyst who assigned this fuel price assumption to the scenario. Supports audit trail and accountability for scenario configuration.',
  `assigned_timestamp` TIMESTAMP COMMENT 'Date and time when this fuel price assumption was assigned to the scenario. Supports audit trail and version control for scenario configuration.',
  `assignment_notes` STRING COMMENT 'Free-text notes explaining the rationale for this specific fuel price assignment or any scenario-specific adjustments made. Captures planning judgment and scenario design decisions.',
  `assignment_status` STRING COMMENT 'Lifecycle status of this fuel price assignment within the scenario. Tracks whether this assignment is currently active in scenario modeling or has been superseded by updated assumptions.',
  `escalation_rate_override_percent` DECIMAL(5,2) COMMENT 'Scenario-specific override for the annual escalation rate, expressed as a percentage. Enables testing different fuel price escalation trajectories across scenarios while preserving the base assumption.',
  `scenario_effective_end_date` DATE COMMENT 'End date when this fuel price assumption ceases to be effective within the context of this specific scenario. Supports scenario-specific temporal application of fuel price libraries.',
  `scenario_effective_start_date` DATE COMMENT 'Start date when this fuel price assumption becomes effective within the context of this specific scenario. Allows different scenarios to apply the same base assumption over different time periods.',
  `scenario_price_override` DECIMAL(12,4) COMMENT 'Scenario-specific override price that replaces the base fuel price assumption for this particular scenario. Allows planners to test scenario-specific fuel price variations without modifying the master assumption record.',
  `sensitivity_case_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this fuel price assignment represents a sensitivity case (high/low price variant) rather than the base case for the scenario. Supports sensitivity analysis and risk assessment.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_scenario_fuel_price` PRIMARY KEY (`scenario_fuel_price_id`)
)
USING DELTA
COMMENT 'This association product represents the assignment of fuel price assumptions to IRP scenarios with scenario-specific overrides and effective periods. It captures the operational practice of applying reusable fuel price assumption libraries across multiple planning scenarios while allowing scenario-specific adjustments. Each record links one fuel_price_assumption to one irp_scenario with effective dates, price overrides, escalation adjustments, and sensitivity flags that exist only in the context of this scenario-specific application.. Existence Justification: In utility IRP planning, fuel price assumptions are maintained as a reusable library that planners actively assign to multiple scenarios with scenario-specific overrides, effective periods, and sensitivity variants. A single fuel price assumption (e.g., \'EIA AEO 2024 Reference Case Natural Gas\') is applied across multiple scenarios (Base, High Growth, Low Carbon), and each scenario uses multiple fuel price assumptions (natural gas, coal, uranium) with scenario-specific adjustments. The business explicitly manages these assignments as operational records, tracking which assumptions are active in which scenarios, with what overrides, and over what time periods. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ScenarioFuelPrice',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.scenario_fuel_price'
);

-- PlanningPeriod  <<CIM TimeSchedule : extension>>
CREATE TABLE IF NOT EXISTS `forecast`.`planning_period` (
  `planning_period_id` BIGINT NOT NULL COMMENT 'Primary key for planning_period',
  `previous_planning_period_id` BIGINT COMMENT 'Self-referencing FK on planning_period (previous_planning_period_id)',
  `created_timestamp` TIMESTAMP COMMENT 'Date-time when the planning period record was first created in the system.',
  `description` STRING COMMENT 'Free-form text describing the purpose, assumptions, or special notes for the period.',
  `end_date` DATE COMMENT 'Last calendar date of the planning period.',
  `forecast_horizon_days` INT COMMENT 'Number of days ahead for which forecasts are generated within this period.',
  `horizon_days` INT COMMENT 'Total number of days covered by the planning period.',
  `is_default` BOOLEAN COMMENT 'Indicates whether this period is the default selection for new forecasts.',
  `last_modified_by` STRING COMMENT 'Identifier of the user or process that performed the latest update.',
  `name` STRING COMMENT 'Human-readable name of the planning period (e.g., "2024 Summer Peak").',
  `notes` STRING COMMENT 'Additional remarks or operational notes attached to the planning period.',
  `period_type` STRING COMMENT 'Category of the planning period indicating its planning horizon or scenario purpose.',
  `planning_cycle_code` STRING COMMENT 'Short code representing the planning cycle (e.g., "FY24", "Q2-2024").',
  `planning_horizon_type` STRING COMMENT 'Indicates whether the horizon follows calendar, fiscal, or operational definitions.',
  `planning_horizon_years` INT COMMENT 'Number of years spanned by the planning period (useful for long-term scenarios).',
  `planning_month` INT COMMENT 'Month number (1-12) of the planning period.',
  `planning_quarter` STRING COMMENT 'Quarter of the year for the planning period.',
  `planning_year` INT COMMENT 'Fiscal or calendar year to which the planning period belongs.',
  `start_date` DATE COMMENT 'First calendar date of the planning period.',
  `status` STRING COMMENT 'Current lifecycle status of the planning period.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date-time of the most recent modification to the planning period record.',
  `version` INT COMMENT 'Incremental version number for optimistic concurrency control.',
  `created_by` STRING COMMENT 'Identifier of the user or process that created the record.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_forecast_planning_period` PRIMARY KEY (`planning_period_id`)
)
USING DELTA
COMMENT 'Master reference table for planning_period. Referenced by planning_period_id. | CMM: CIM TimeSchedule (extension), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PlanningPeriod',
  'cmm.cim.class' = 'TimeSchedule',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.planning_period'
);

-- PricingNode  <<CIM Pnode : exact>>
CREATE TABLE IF NOT EXISTS `forecast`.`pricing_node` (
  `pricing_node_id` BIGINT NOT NULL COMMENT 'Primary key for pricing_node',
  `parent_pricing_node_id` BIGINT COMMENT 'Self-referencing FK on pricing_node (parent_pricing_node_id)',
  `capacity_mw` DECIMAL(10,2) COMMENT 'Maximum generation or consumption capacity represented by the node in megawatts.',
  `code` STRING COMMENT 'Business-assigned unique code that identifies the pricing node across systems.',
  `created_timestamp` TIMESTAMP COMMENT 'Date-time when the pricing node record was first created in the system.',
  `description` STRING COMMENT 'Free-form text describing the purpose, scope, or special characteristics of the node.',
  `discount_rate` DECIMAL(5,2) COMMENT 'Discount applied to the base price, expressed as a percentage.',
  `effective_from` DATE COMMENT 'Date when the pricing node becomes effective for pricing calculations.',
  `effective_until` DATE COMMENT 'Date when the pricing node ceases to be effective; null if open-ended.',
  `is_default` BOOLEAN COMMENT 'Flag indicating whether this node is the default pricing node for its hierarchy level.',
  `market` STRING COMMENT 'Market segment to which the pricing node belongs.',
  `name` STRING COMMENT 'Human-readable name of the pricing node used in reports and dashboards.',
  `node_type` STRING COMMENT 'Classification of the node within the pricing hierarchy.',
  `price_amount` DECIMAL(12,4) COMMENT 'Base price associated with the node expressed in the specified currency.',
  `price_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for the price amount.',
  `price_source` STRING COMMENT 'Origin of the price data (e.g., market feed, contractual agreement, internal model).',
  `price_unit` STRING COMMENT 'Unit of measure for the price (e.g., USD per megawatt-hour).',
  `pricing_method` STRING COMMENT 'Method used to calculate the price at this node.',
  `region_code` STRING COMMENT 'Logical region identifier for the node; used for regional reporting.',
  `settlement_period` STRING COMMENT 'Frequency at which the pricing node settles transactions.',
  `status` STRING COMMENT 'Current lifecycle state of the pricing node.',
  `tax_included` BOOLEAN COMMENT 'Indicates whether taxes are already included in the price amount.',
  `tax_rate` DECIMAL(5,2) COMMENT 'Tax rate applied to the price when tax_included is false, expressed as a percentage.',
  `updated_timestamp` TIMESTAMP COMMENT 'Date-time of the most recent modification to the pricing node record.',
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
  CONSTRAINT `pk_forecast_pricing_node` PRIMARY KEY (`pricing_node_id`)
)
USING DELTA
COMMENT 'Master reference table for pricing_node. Referenced by pricing_node_id. | CMM: CIM Pnode (exact), IEC62325::ReferenceData.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PricingNode',
  'cmm.cim.class' = 'Pnode',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC62325::ReferenceData',
  'cmm.cim.standard' = 'IEC 62325-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.pricing_node',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- WeatherStation  <<CIM WeatherStation : exact>>
CREATE TABLE IF NOT EXISTS `forecast`.`weather_station` (
  `weather_station_id` BIGINT NOT NULL COMMENT 'Primary key for weather_station',
  `reference_weather_station_id` BIGINT COMMENT 'Self-referencing FK on weather_station (reference_weather_station_id)',
  `accuracy_rating` STRING COMMENT 'Qualitative rating of the station\'s measurement accuracy.',
  `connectivity_type` STRING COMMENT 'Network technology used to transmit data to the central system.',
  `data_quality_score` DECIMAL(5,2) COMMENT 'Numeric score (0-100) representing overall data quality for the station.',
  `data_source_system` STRING COMMENT 'Name of the upstream system that provides raw sensor data.',
  `data_update_frequency_minutes` INT COMMENT 'Interval in minutes between successive data pushes from the station.',
  `decommission_date` DATE COMMENT 'Date the station was permanently retired or removed from service.',
  `description` STRING COMMENT 'Free-form notes describing location specifics, installation remarks, or operational considerations.',
  `elevation_m` DOUBLE COMMENT 'Station elevation in meters above mean sea level.',
  `installation_date` DATE COMMENT 'Date the weather station was installed and became operational.',
  `last_calibration_date` DATE COMMENT 'Date the station\'s sensors were last calibrated.',
  `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude of the station in decimal degrees (WGS84).',
  `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude of the station in decimal degrees (WGS84).',
  `maintenance_contact_email` STRING COMMENT 'Email address for the maintenance contact.',
  `maintenance_contact_name` STRING COMMENT 'Name of the person or team responsible for station upkeep.',
  `maintenance_contact_phone` STRING COMMENT 'Phone number for the maintenance contact.',
  `manufacturer` STRING COMMENT 'Company that manufactured the weather station hardware.',
  `measurement_capabilities` STRING COMMENT 'Comma-separated list of measurement types the station can capture.',
  `measurement_units` STRING COMMENT 'Standard units used for the station\'s measurements (e.g., °C, m/s, %).',
  `model` STRING COMMENT 'Model designation of the weather station equipment.',
  `next_calibration_due` DATE COMMENT 'Scheduled date for the next calibration activity.',
  `owner_organization` STRING COMMENT 'Business unit or subsidiary that owns the weather station.',
  `power_source` STRING COMMENT 'Primary energy source powering the station equipment.',
  `regulatory_compliance_status` STRING COMMENT 'Current status of the station\'s compliance with NERC, FERC, or other applicable regulations.',
  `serial_number` STRING COMMENT 'Unique serial number assigned by the manufacturer.',
  `station_code` STRING COMMENT 'External business code or identifier assigned by the utility or regulatory body.',
  `station_name` STRING COMMENT 'Human-readable name of the weather station used in reports and dashboards.',
  `station_type` STRING COMMENT 'Classification of the station based on deployment and data collection method.',
  `status` STRING COMMENT 'Current operational state of the station within its lifecycle.',
  `timezone` STRING COMMENT 'IANA time zone identifier for the station location (e.g., America/New_York).',
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
  CONSTRAINT `pk_forecast_weather_station` PRIMARY KEY (`weather_station_id`)
)
USING DELTA
COMMENT 'Master reference table for weather_station. Referenced by weather_station_id. | CMM: CIM WeatherStation (exact), IEC61968::Environmental.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'WeatherStation',
  'cmm.cim.class' = 'WeatherStation',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Environmental',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'energy_utilities_ecm.forecast.weather_station',
  'cmm.gis.location.role' = 'IdentifiedObject -> Location (CMM extension association)'
);

-- ========= FOREIGN KEYS within forecast (67) =========
ALTER TABLE `forecast`.`load` DROP CONSTRAINT IF EXISTS `fk_forecast_load_baseline_forecast_load_id`;
ALTER TABLE `forecast`.`load` ADD CONSTRAINT `fk_forecast_load_baseline_forecast_load_id` FOREIGN KEY (`baseline_forecast_load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `forecast`.`load` DROP CONSTRAINT IF EXISTS `fk_forecast_load_forecast_run_id`;
ALTER TABLE `forecast`.`load` ADD CONSTRAINT `fk_forecast_load_forecast_run_id` FOREIGN KEY (`forecast_run_id`) REFERENCES `forecast`.`forecast_run` (`forecast_run_id`);

ALTER TABLE `forecast`.`load` DROP CONSTRAINT IF EXISTS `fk_forecast_load_load_forecast_model_id`;
ALTER TABLE `forecast`.`load` ADD CONSTRAINT `fk_forecast_load_load_forecast_model_id` FOREIGN KEY (`load_forecast_model_id`) REFERENCES `forecast`.`model` (`model_id`);

ALTER TABLE `forecast`.`load` DROP CONSTRAINT IF EXISTS `fk_forecast_load_load_forecast_zone_id`;
ALTER TABLE `forecast`.`load` ADD CONSTRAINT `fk_forecast_load_load_forecast_zone_id` FOREIGN KEY (`load_forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `forecast`.`load` DROP CONSTRAINT IF EXISTS `fk_forecast_load_load_model_id`;
ALTER TABLE `forecast`.`load` ADD CONSTRAINT `fk_forecast_load_load_model_id` FOREIGN KEY (`load_model_id`) REFERENCES `forecast`.`model` (`model_id`);

ALTER TABLE `forecast`.`load` DROP CONSTRAINT IF EXISTS `fk_forecast_load_superseded_by_forecast_load_id`;
ALTER TABLE `forecast`.`load` ADD CONSTRAINT `fk_forecast_load_superseded_by_forecast_load_id` FOREIGN KEY (`superseded_by_forecast_load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `forecast`.`load` DROP CONSTRAINT IF EXISTS `fk_forecast_load_weather_input_id`;
ALTER TABLE `forecast`.`load` ADD CONSTRAINT `fk_forecast_load_weather_input_id` FOREIGN KEY (`weather_input_id`) REFERENCES `forecast`.`weather_input` (`weather_input_id`);

ALTER TABLE `forecast`.`load` DROP CONSTRAINT IF EXISTS `fk_forecast_load_weather_station_id`;
ALTER TABLE `forecast`.`load` ADD CONSTRAINT `fk_forecast_load_weather_station_id` FOREIGN KEY (`weather_station_id`) REFERENCES `forecast`.`weather_station` (`weather_station_id`);

ALTER TABLE `forecast`.`load_forecast_interval` DROP CONSTRAINT IF EXISTS `fk_forecast_load_forecast_interval_load_forecast_run_id`;
ALTER TABLE `forecast`.`load_forecast_interval` ADD CONSTRAINT `fk_forecast_load_forecast_interval_load_forecast_run_id` FOREIGN KEY (`load_forecast_run_id`) REFERENCES `forecast`.`forecast_run` (`forecast_run_id`);

ALTER TABLE `forecast`.`load_forecast_interval` DROP CONSTRAINT IF EXISTS `fk_forecast_load_forecast_interval_load_id`;
ALTER TABLE `forecast`.`load_forecast_interval` ADD CONSTRAINT `fk_forecast_load_forecast_interval_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `forecast`.`forecast_generation` DROP CONSTRAINT IF EXISTS `fk_forecast_forecast_generation_forecast_model_id`;
ALTER TABLE `forecast`.`forecast_generation` ADD CONSTRAINT `fk_forecast_forecast_generation_forecast_model_id` FOREIGN KEY (`forecast_model_id`) REFERENCES `forecast`.`model` (`model_id`);

ALTER TABLE `forecast`.`forecast_generation` DROP CONSTRAINT IF EXISTS `fk_forecast_forecast_generation_forecast_run_id`;
ALTER TABLE `forecast`.`forecast_generation` ADD CONSTRAINT `fk_forecast_forecast_generation_forecast_run_id` FOREIGN KEY (`forecast_run_id`) REFERENCES `forecast`.`forecast_run` (`forecast_run_id`);

ALTER TABLE `forecast`.`forecast_generation` DROP CONSTRAINT IF EXISTS `fk_forecast_forecast_generation_load_id`;
ALTER TABLE `forecast`.`forecast_generation` ADD CONSTRAINT `fk_forecast_forecast_generation_load_id` FOREIGN KEY (`load_id`) REFERENCES `forecast`.`load` (`load_id`);

ALTER TABLE `forecast`.`generation_forecast_interval` DROP CONSTRAINT IF EXISTS `fk_forecast_generation_forecast_interval_forecast_generation_id`;
ALTER TABLE `forecast`.`generation_forecast_interval` ADD CONSTRAINT `fk_forecast_generation_forecast_interval_forecast_generation_id` FOREIGN KEY (`forecast_generation_id`) REFERENCES `forecast`.`forecast_generation` (`forecast_generation_id`);

ALTER TABLE `forecast`.`generation_forecast_interval` DROP CONSTRAINT IF EXISTS `fk_forecast_generation_forecast_interval_generation_forecast_run_id`;
ALTER TABLE `forecast`.`generation_forecast_interval` ADD CONSTRAINT `fk_forecast_generation_forecast_interval_generation_forecast_run_id` FOREIGN KEY (`generation_forecast_run_id`) REFERENCES `forecast`.`forecast_run` (`forecast_run_id`);

ALTER TABLE `forecast`.`forecast_renewable` DROP CONSTRAINT IF EXISTS `fk_forecast_forecast_renewable_forecast_forecast_run_id`;
ALTER TABLE `forecast`.`forecast_renewable` ADD CONSTRAINT `fk_forecast_forecast_renewable_forecast_forecast_run_id` FOREIGN KEY (`forecast_forecast_run_id`) REFERENCES `forecast`.`forecast_run` (`forecast_run_id`);

ALTER TABLE `forecast`.`forecast_renewable` DROP CONSTRAINT IF EXISTS `fk_forecast_forecast_renewable_forecast_model_id`;
ALTER TABLE `forecast`.`forecast_renewable` ADD CONSTRAINT `fk_forecast_forecast_renewable_forecast_model_id` FOREIGN KEY (`forecast_model_id`) REFERENCES `forecast`.`model` (`model_id`);

ALTER TABLE `forecast`.`forecast_renewable` DROP CONSTRAINT IF EXISTS `fk_forecast_forecast_renewable_forecast_run_id`;
ALTER TABLE `forecast`.`forecast_renewable` ADD CONSTRAINT `fk_forecast_forecast_renewable_forecast_run_id` FOREIGN KEY (`forecast_run_id`) REFERENCES `forecast`.`forecast_run` (`forecast_run_id`);

ALTER TABLE `forecast`.`forecast_renewable` DROP CONSTRAINT IF EXISTS `fk_forecast_forecast_renewable_zone_id`;
ALTER TABLE `forecast`.`forecast_renewable` ADD CONSTRAINT `fk_forecast_forecast_renewable_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `forecast`.`renewable_forecast_interval` DROP CONSTRAINT IF EXISTS `fk_forecast_renewable_forecast_interval_forecast_renewable_id`;
ALTER TABLE `forecast`.`renewable_forecast_interval` ADD CONSTRAINT `fk_forecast_renewable_forecast_interval_forecast_renewable_id` FOREIGN KEY (`forecast_renewable_id`) REFERENCES `forecast`.`forecast_renewable` (`forecast_renewable_id`);

ALTER TABLE `forecast`.`renewable_forecast_interval` DROP CONSTRAINT IF EXISTS `fk_forecast_renewable_forecast_interval_renewable_forecast_run_id`;
ALTER TABLE `forecast`.`renewable_forecast_interval` ADD CONSTRAINT `fk_forecast_renewable_forecast_interval_renewable_forecast_run_id` FOREIGN KEY (`renewable_forecast_run_id`) REFERENCES `forecast`.`forecast_run` (`forecast_run_id`);

ALTER TABLE `forecast`.`peak_demand` DROP CONSTRAINT IF EXISTS `fk_forecast_peak_demand_forecast_model_id`;
ALTER TABLE `forecast`.`peak_demand` ADD CONSTRAINT `fk_forecast_peak_demand_forecast_model_id` FOREIGN KEY (`forecast_model_id`) REFERENCES `forecast`.`model` (`model_id`);

ALTER TABLE `forecast`.`peak_demand` DROP CONSTRAINT IF EXISTS `fk_forecast_peak_demand_peak_forecast_zone_id`;
ALTER TABLE `forecast`.`peak_demand` ADD CONSTRAINT `fk_forecast_peak_demand_peak_forecast_zone_id` FOREIGN KEY (`peak_forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `forecast`.`peak_demand` DROP CONSTRAINT IF EXISTS `fk_forecast_peak_demand_peak_zone_id`;
ALTER TABLE `forecast`.`peak_demand` ADD CONSTRAINT `fk_forecast_peak_demand_peak_zone_id` FOREIGN KEY (`peak_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `forecast`.`peak_demand` DROP CONSTRAINT IF EXISTS `fk_forecast_peak_demand_planning_assumption_id`;
ALTER TABLE `forecast`.`peak_demand` ADD CONSTRAINT `fk_forecast_peak_demand_planning_assumption_id` FOREIGN KEY (`planning_assumption_id`) REFERENCES `forecast`.`planning_assumption` (`planning_assumption_id`);

ALTER TABLE `forecast`.`weather_input` DROP CONSTRAINT IF EXISTS `fk_forecast_weather_input_forecast_zone_id`;
ALTER TABLE `forecast`.`weather_input` ADD CONSTRAINT `fk_forecast_weather_input_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `forecast`.`accuracy` DROP CONSTRAINT IF EXISTS `fk_forecast_accuracy_accuracy_forecast_model_id`;
ALTER TABLE `forecast`.`accuracy` ADD CONSTRAINT `fk_forecast_accuracy_accuracy_forecast_model_id` FOREIGN KEY (`accuracy_forecast_model_id`) REFERENCES `forecast`.`model` (`model_id`);

ALTER TABLE `forecast`.`accuracy` DROP CONSTRAINT IF EXISTS `fk_forecast_accuracy_accuracy_model_id`;
ALTER TABLE `forecast`.`accuracy` ADD CONSTRAINT `fk_forecast_accuracy_accuracy_model_id` FOREIGN KEY (`accuracy_model_id`) REFERENCES `forecast`.`model` (`model_id`);

ALTER TABLE `forecast`.`accuracy` DROP CONSTRAINT IF EXISTS `fk_forecast_accuracy_forecast_run_id`;
ALTER TABLE `forecast`.`accuracy` ADD CONSTRAINT `fk_forecast_accuracy_forecast_run_id` FOREIGN KEY (`forecast_run_id`) REFERENCES `forecast`.`forecast_run` (`forecast_run_id`);

ALTER TABLE `forecast`.`accuracy` DROP CONSTRAINT IF EXISTS `fk_forecast_accuracy_zone_id`;
ALTER TABLE `forecast`.`accuracy` ADD CONSTRAINT `fk_forecast_accuracy_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `forecast`.`irp_scenario` DROP CONSTRAINT IF EXISTS `fk_forecast_irp_scenario_parent_scenario_irp_scenario_id`;
ALTER TABLE `forecast`.`irp_scenario` ADD CONSTRAINT `fk_forecast_irp_scenario_parent_scenario_irp_scenario_id` FOREIGN KEY (`parent_scenario_irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

ALTER TABLE `forecast`.`irp_scenario` DROP CONSTRAINT IF EXISTS `fk_forecast_irp_scenario_planning_assumption_id`;
ALTER TABLE `forecast`.`irp_scenario` ADD CONSTRAINT `fk_forecast_irp_scenario_planning_assumption_id` FOREIGN KEY (`planning_assumption_id`) REFERENCES `forecast`.`planning_assumption` (`planning_assumption_id`);

ALTER TABLE `forecast`.`irp_scenario_year` DROP CONSTRAINT IF EXISTS `fk_forecast_irp_scenario_year_primary_irp_scenario_id`;
ALTER TABLE `forecast`.`irp_scenario_year` ADD CONSTRAINT `fk_forecast_irp_scenario_year_primary_irp_scenario_id` FOREIGN KEY (`primary_irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

ALTER TABLE `forecast`.`capacity_requirement` DROP CONSTRAINT IF EXISTS `fk_forecast_capacity_requirement_capacity_irp_scenario_id`;
ALTER TABLE `forecast`.`capacity_requirement` ADD CONSTRAINT `fk_forecast_capacity_requirement_capacity_irp_scenario_id` FOREIGN KEY (`capacity_irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

ALTER TABLE `forecast`.`capacity_requirement` DROP CONSTRAINT IF EXISTS `fk_forecast_capacity_requirement_planning_period_id`;
ALTER TABLE `forecast`.`capacity_requirement` ADD CONSTRAINT `fk_forecast_capacity_requirement_planning_period_id` FOREIGN KEY (`planning_period_id`) REFERENCES `forecast`.`planning_period` (`planning_period_id`);

ALTER TABLE `forecast`.`capacity_requirement` DROP CONSTRAINT IF EXISTS `fk_forecast_capacity_requirement_primary_irp_scenario_id`;
ALTER TABLE `forecast`.`capacity_requirement` ADD CONSTRAINT `fk_forecast_capacity_requirement_primary_irp_scenario_id` FOREIGN KEY (`primary_irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

ALTER TABLE `forecast`.`capacity_requirement` DROP CONSTRAINT IF EXISTS `fk_forecast_capacity_requirement_rto_iso_zone_id`;
ALTER TABLE `forecast`.`capacity_requirement` ADD CONSTRAINT `fk_forecast_capacity_requirement_rto_iso_zone_id` FOREIGN KEY (`rto_iso_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `forecast`.`energy_price` DROP CONSTRAINT IF EXISTS `fk_forecast_energy_price_energy_forecast_zone_id`;
ALTER TABLE `forecast`.`energy_price` ADD CONSTRAINT `fk_forecast_energy_price_energy_forecast_zone_id` FOREIGN KEY (`energy_forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `forecast`.`energy_price` DROP CONSTRAINT IF EXISTS `fk_forecast_energy_price_energy_zone_id`;
ALTER TABLE `forecast`.`energy_price` ADD CONSTRAINT `fk_forecast_energy_price_energy_zone_id` FOREIGN KEY (`energy_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `forecast`.`energy_price` DROP CONSTRAINT IF EXISTS `fk_forecast_energy_price_forecast_model_id`;
ALTER TABLE `forecast`.`energy_price` ADD CONSTRAINT `fk_forecast_energy_price_forecast_model_id` FOREIGN KEY (`forecast_model_id`) REFERENCES `forecast`.`model` (`model_id`);

ALTER TABLE `forecast`.`energy_price` DROP CONSTRAINT IF EXISTS `fk_forecast_energy_price_forecast_run_id`;
ALTER TABLE `forecast`.`energy_price` ADD CONSTRAINT `fk_forecast_energy_price_forecast_run_id` FOREIGN KEY (`forecast_run_id`) REFERENCES `forecast`.`forecast_run` (`forecast_run_id`);

ALTER TABLE `forecast`.`energy_price` DROP CONSTRAINT IF EXISTS `fk_forecast_energy_price_forecast_scenario_id`;
ALTER TABLE `forecast`.`energy_price` ADD CONSTRAINT `fk_forecast_energy_price_forecast_scenario_id` FOREIGN KEY (`forecast_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

ALTER TABLE `forecast`.`energy_price` DROP CONSTRAINT IF EXISTS `fk_forecast_energy_price_irp_scenario_id`;
ALTER TABLE `forecast`.`energy_price` ADD CONSTRAINT `fk_forecast_energy_price_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

ALTER TABLE `forecast`.`energy_price` DROP CONSTRAINT IF EXISTS `fk_forecast_energy_price_pricing_node_id`;
ALTER TABLE `forecast`.`energy_price` ADD CONSTRAINT `fk_forecast_energy_price_pricing_node_id` FOREIGN KEY (`pricing_node_id`) REFERENCES `forecast`.`pricing_node` (`pricing_node_id`);

ALTER TABLE `forecast`.`energy_price` DROP CONSTRAINT IF EXISTS `fk_forecast_energy_price_superseded_by_forecast_energy_price_id`;
ALTER TABLE `forecast`.`energy_price` ADD CONSTRAINT `fk_forecast_energy_price_superseded_by_forecast_energy_price_id` FOREIGN KEY (`superseded_by_forecast_energy_price_id`) REFERENCES `forecast`.`energy_price` (`energy_price_id`);

ALTER TABLE `forecast`.`energy_price_forecast_interval` DROP CONSTRAINT IF EXISTS `fk_forecast_energy_price_forecast_interval_energy_price_id`;
ALTER TABLE `forecast`.`energy_price_forecast_interval` ADD CONSTRAINT `fk_forecast_energy_price_forecast_interval_energy_price_id` FOREIGN KEY (`energy_price_id`) REFERENCES `forecast`.`energy_price` (`energy_price_id`);

ALTER TABLE `forecast`.`zone` DROP CONSTRAINT IF EXISTS `fk_forecast_zone_parent_zone_id`;
ALTER TABLE `forecast`.`zone` ADD CONSTRAINT `fk_forecast_zone_parent_zone_id` FOREIGN KEY (`parent_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `forecast`.`planning_assumption` DROP CONSTRAINT IF EXISTS `fk_forecast_planning_assumption_superseded_by_assumption_planning_assumption_id`;
ALTER TABLE `forecast`.`planning_assumption` ADD CONSTRAINT `fk_forecast_planning_assumption_superseded_by_assumption_planning_assumption_id` FOREIGN KEY (`superseded_by_assumption_planning_assumption_id`) REFERENCES `forecast`.`planning_assumption` (`planning_assumption_id`);

ALTER TABLE `forecast`.`fuel_price_assumption` DROP CONSTRAINT IF EXISTS `fk_forecast_fuel_price_assumption_baseline_assumption_id`;
ALTER TABLE `forecast`.`fuel_price_assumption` ADD CONSTRAINT `fk_forecast_fuel_price_assumption_baseline_assumption_id` FOREIGN KEY (`baseline_assumption_id`) REFERENCES `forecast`.`planning_assumption` (`planning_assumption_id`);

ALTER TABLE `forecast`.`fuel_price_assumption` DROP CONSTRAINT IF EXISTS `fk_forecast_fuel_price_assumption_superseded_by_assumption_fuel_price_assumption_id`;
ALTER TABLE `forecast`.`fuel_price_assumption` ADD CONSTRAINT `fk_forecast_fuel_price_assumption_superseded_by_assumption_fuel_price_assumption_id` FOREIGN KEY (`superseded_by_assumption_fuel_price_assumption_id`) REFERENCES `forecast`.`fuel_price_assumption` (`fuel_price_assumption_id`);

ALTER TABLE `forecast`.`forecast_run` DROP CONSTRAINT IF EXISTS `fk_forecast_forecast_run_baseline_run_id`;
ALTER TABLE `forecast`.`forecast_run` ADD CONSTRAINT `fk_forecast_forecast_run_baseline_run_id` FOREIGN KEY (`baseline_run_id`) REFERENCES `forecast`.`forecast_run` (`forecast_run_id`);

ALTER TABLE `forecast`.`forecast_run` DROP CONSTRAINT IF EXISTS `fk_forecast_forecast_run_forecast_model_id`;
ALTER TABLE `forecast`.`forecast_run` ADD CONSTRAINT `fk_forecast_forecast_run_forecast_model_id` FOREIGN KEY (`forecast_model_id`) REFERENCES `forecast`.`model` (`model_id`);

ALTER TABLE `forecast`.`forecast_run` DROP CONSTRAINT IF EXISTS `fk_forecast_forecast_run_superseded_by_run_forecast_run_id`;
ALTER TABLE `forecast`.`forecast_run` ADD CONSTRAINT `fk_forecast_forecast_run_superseded_by_run_forecast_run_id` FOREIGN KEY (`superseded_by_run_forecast_run_id`) REFERENCES `forecast`.`forecast_run` (`forecast_run_id`);

ALTER TABLE `forecast`.`revision` DROP CONSTRAINT IF EXISTS `fk_forecast_revision_forecast_run_id`;
ALTER TABLE `forecast`.`revision` ADD CONSTRAINT `fk_forecast_revision_forecast_run_id` FOREIGN KEY (`forecast_run_id`) REFERENCES `forecast`.`forecast_run` (`forecast_run_id`);

ALTER TABLE `forecast`.`revision` DROP CONSTRAINT IF EXISTS `fk_forecast_revision_forecast_zone_id`;
ALTER TABLE `forecast`.`revision` ADD CONSTRAINT `fk_forecast_revision_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `forecast`.`revision` DROP CONSTRAINT IF EXISTS `fk_forecast_revision_superseded_by_revision_id`;
ALTER TABLE `forecast`.`revision` ADD CONSTRAINT `fk_forecast_revision_superseded_by_revision_id` FOREIGN KEY (`superseded_by_revision_id`) REFERENCES `forecast`.`revision` (`revision_id`);

ALTER TABLE `forecast`.`resource_adequacy_assessment` DROP CONSTRAINT IF EXISTS `fk_forecast_resource_adequacy_assessment_capacity_requirement_id`;
ALTER TABLE `forecast`.`resource_adequacy_assessment` ADD CONSTRAINT `fk_forecast_resource_adequacy_assessment_capacity_requirement_id` FOREIGN KEY (`capacity_requirement_id`) REFERENCES `forecast`.`capacity_requirement` (`capacity_requirement_id`);

ALTER TABLE `forecast`.`resource_adequacy_assessment` DROP CONSTRAINT IF EXISTS `fk_forecast_resource_adequacy_assessment_forecast_zone_id`;
ALTER TABLE `forecast`.`resource_adequacy_assessment` ADD CONSTRAINT `fk_forecast_resource_adequacy_assessment_forecast_zone_id` FOREIGN KEY (`forecast_zone_id`) REFERENCES `forecast`.`zone` (`zone_id`);

ALTER TABLE `forecast`.`resource_adequacy_assessment` DROP CONSTRAINT IF EXISTS `fk_forecast_resource_adequacy_assessment_irp_scenario_id`;
ALTER TABLE `forecast`.`resource_adequacy_assessment` ADD CONSTRAINT `fk_forecast_resource_adequacy_assessment_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

ALTER TABLE `forecast`.`resource_adequacy_assessment` DROP CONSTRAINT IF EXISTS `fk_forecast_resource_adequacy_assessment_resource_capacity_requirement_id`;
ALTER TABLE `forecast`.`resource_adequacy_assessment` ADD CONSTRAINT `fk_forecast_resource_adequacy_assessment_resource_capacity_requirement_id` FOREIGN KEY (`resource_capacity_requirement_id`) REFERENCES `forecast`.`capacity_requirement` (`capacity_requirement_id`);

ALTER TABLE `forecast`.`resource_adequacy_assessment` DROP CONSTRAINT IF EXISTS `fk_forecast_resource_adequacy_assessment_resource_ra_against_capacity_req`;
ALTER TABLE `forecast`.`resource_adequacy_assessment` ADD CONSTRAINT `fk_forecast_resource_adequacy_assessment_resource_ra_against_capacity_req` FOREIGN KEY (`resource_ra_against_capacity_req`) REFERENCES `forecast`.`capacity_requirement` (`capacity_requirement_id`);

ALTER TABLE `forecast`.`resource_adequacy_assessment` DROP CONSTRAINT IF EXISTS `fk_forecast_resource_adequacy_assessment_superseded_by_assessment_resource_adequacy_assessment_id`;
ALTER TABLE `forecast`.`resource_adequacy_assessment` ADD CONSTRAINT `fk_forecast_resource_adequacy_assessment_superseded_by_assessment_resource_adequacy_assessment_id` FOREIGN KEY (`superseded_by_assessment_resource_adequacy_assessment_id`) REFERENCES `forecast`.`resource_adequacy_assessment` (`resource_adequacy_assessment_id`);

ALTER TABLE `forecast`.`scenario_fuel_price` DROP CONSTRAINT IF EXISTS `fk_forecast_scenario_fuel_price_fuel_price_assumption_id`;
ALTER TABLE `forecast`.`scenario_fuel_price` ADD CONSTRAINT `fk_forecast_scenario_fuel_price_fuel_price_assumption_id` FOREIGN KEY (`fuel_price_assumption_id`) REFERENCES `forecast`.`fuel_price_assumption` (`fuel_price_assumption_id`);

ALTER TABLE `forecast`.`scenario_fuel_price` DROP CONSTRAINT IF EXISTS `fk_forecast_scenario_fuel_price_irp_scenario_id`;
ALTER TABLE `forecast`.`scenario_fuel_price` ADD CONSTRAINT `fk_forecast_scenario_fuel_price_irp_scenario_id` FOREIGN KEY (`irp_scenario_id`) REFERENCES `forecast`.`irp_scenario` (`irp_scenario_id`);

ALTER TABLE `forecast`.`planning_period` DROP CONSTRAINT IF EXISTS `fk_forecast_planning_period_previous_planning_period_id`;
ALTER TABLE `forecast`.`planning_period` ADD CONSTRAINT `fk_forecast_planning_period_previous_planning_period_id` FOREIGN KEY (`previous_planning_period_id`) REFERENCES `forecast`.`planning_period` (`planning_period_id`);

ALTER TABLE `forecast`.`pricing_node` DROP CONSTRAINT IF EXISTS `fk_forecast_pricing_node_parent_pricing_node_id`;
ALTER TABLE `forecast`.`pricing_node` ADD CONSTRAINT `fk_forecast_pricing_node_parent_pricing_node_id` FOREIGN KEY (`parent_pricing_node_id`) REFERENCES `forecast`.`pricing_node` (`pricing_node_id`);

ALTER TABLE `forecast`.`weather_station` DROP CONSTRAINT IF EXISTS `fk_forecast_weather_station_reference_weather_station_id`;
ALTER TABLE `forecast`.`weather_station` ADD CONSTRAINT `fk_forecast_weather_station_reference_weather_station_id` FOREIGN KEY (`reference_weather_station_id`) REFERENCES `forecast`.`weather_station` (`weather_station_id`);

