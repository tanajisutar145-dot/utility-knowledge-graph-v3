-- Utility CMM-aligned Canonical Data Model (Silver) v1.0.0 | source: Databricks lakehouse-industry-data-models energy_utilities v1 ECM | generated 2026-10-13
-- 19 | Subject area: gis | 10 tables | CIM packages: IEC61968::Common (Location, PositionPoint, CoordinateSystem); IEC61970::Topology; IEC61970::Core
-- Standards: OGC GeoSPARQL 1.1; ISO 19125 Simple Features; ISO 19111/EPSG; Esri ArcGIS Utility Network; H3
-- Contents: tables (with PK + NOT NULL), then intra-subject-area foreign keys.
-- Unity Catalog PK/FK constraints are informational (NOT ENFORCED); NOT NULL is enforced.

USE CATALOG `utility_cmm_silver`;

-- CoordinateSystem  <<CIM CoordinateSystem : exact>>
CREATE TABLE IF NOT EXISTS `gis`.`coordinate_system` (
  `coordinate_system_id` BIGINT NOT NULL COMMENT 'Surrogate primary key of CoordinateSystem.',
  `name` STRING NOT NULL COMMENT 'CRS name (e.g. WGS 84, NAD83 / UTM zone 15N).',
  `description` STRING COMMENT 'CRS description.',
  `crs_urn` STRING NOT NULL COMMENT 'OGC CRS URN, e.g. urn:ogc:def:crs:EPSG::4326.',
  `epsg_code` INT COMMENT 'EPSG registry code (ISO 19111).',
  `crs_kind` STRING NOT NULL COMMENT 'Kind of CRS. Valid values: geographic|projected|geocentric|vertical|compound|engineering.',
  `horizontal_datum` STRING COMMENT 'Horizontal datum (e.g. WGS84, NAD83(2011)).',
  `vertical_datum` STRING COMMENT 'Vertical datum for z values (e.g. NAVD88, EGM2008).',
  `axis_order` STRING COMMENT 'Axis order of x/y positions. Valid values: lon_lat|lat_lon|easting_northing.',
  `linear_unit` STRING COMMENT 'Unit of measure of coordinates. Valid values: degree|metre|us_survey_foot|foot.',
  `is_default_flag` BOOLEAN NOT NULL COMMENT 'TRUE for the enterprise default CRS (EPSG:4326).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_gis_coordinate_system` PRIMARY KEY (`coordinate_system_id`)
)
USING DELTA
COMMENT 'Coordinate reference system (CRS) catalogue. Every geometry in the canonical model references a CRS by URN. CMM default is WGS84 geographic (urn:ogc:def:crs:EPSG::4326); projected CRS (e.g. State Plane, UTM) are registered here for GIS-native geometries. | CMM: CIM CoordinateSystem (exact), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'CoordinateSystem',
  'cmm.cim.class' = 'CoordinateSystem',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'reference_data',
  'cmm.source.object' = 'cmm-standard'
);

-- GisLocation  <<CIM Location : exact>>
CREATE TABLE IF NOT EXISTS `gis`.`location` (
  `location_id` BIGINT NOT NULL COMMENT 'Surrogate primary key of GisLocation.',
  `name` STRING COMMENT 'Location name.',
  `description` STRING COMMENT 'Location description (e.g. pole number, vault, bay).',
  `location_type` STRING COMMENT 'Classification by utility\'s corporate standards (e.g. pole, pad, vault, substation_yard, premise, right_of_way, region).',
  `direction` STRING COMMENT 'Directions for reaching the location.',
  `geo_info_reference` STRING COMMENT 'Reference to the GIS system feature (e.g. Esri GlobalID, Smallworld id).',
  `status` STRING COMMENT 'Status of the location record. Valid values: proposed|active|inactive|removed.',
  `coordinate_system_id` BIGINT NOT NULL COMMENT 'CRS in which geometry and position points are expressed.',
  `main_address_id` BIGINT COMMENT 'Main postal address of the location (customer.address).',
  `geometry_type` STRING NOT NULL COMMENT 'OGC Simple Features geometry type. Valid values: Point|LineString|Polygon|MultiPoint|MultiLineString|MultiPolygon|GeometryCollection.',
  `geometry_wkt` STRING COMMENT 'Geometry as OGC Well-Known Text (geo:asWKT) in the referenced CRS.',
  `geometry_wkb` BINARY COMMENT 'Geometry as OGC Well-Known Binary (geo:asWKB). Physical option: Databricks GEOMETRY/GEOGRAPHY type where available.',
  `geometry_geojson` STRING COMMENT 'Geometry as RFC 7946 GeoJSON (always WGS84).',
  `latitude` DECIMAL(10,7) COMMENT 'WGS84 latitude of the representative point (centroid / point-on-surface).',
  `longitude` DECIMAL(10,7) COMMENT 'WGS84 longitude of the representative point.',
  `elevation_m` DECIMAL(10,3) COMMENT 'Elevation in metres above vertical datum.',
  `h3_cell_res9` BIGINT COMMENT 'H3 hexagonal cell index at resolution 9 (~0.1 km2) of the representative point, for spatial joins.',
  `h3_cell_res12` BIGINT COMMENT 'H3 hexagonal cell index at resolution 12 (~300 m2).',
  `bbox_min_x` DOUBLE COMMENT 'Bounding box minimum x (longitude/easting).',
  `bbox_min_y` DOUBLE COMMENT 'Bounding box minimum y (latitude/northing).',
  `bbox_max_x` DOUBLE COMMENT 'Bounding box maximum x.',
  `bbox_max_y` DOUBLE COMMENT 'Bounding box maximum y.',
  `length_m` DECIMAL(18,3) COMMENT 'Geodesic length in metres for linear geometries.',
  `area_sq_m` DECIMAL(18,3) COMMENT 'Geodesic area in square metres for polygonal geometries.',
  `positional_accuracy_m` DECIMAL(10,3) COMMENT 'Absolute positional accuracy in metres (ISO 19157).',
  `capture_method` STRING COMMENT 'How the geometry was captured. Valid values: gps|survey|digitized|geocoded|lidar|derived|as_built.',
  `capture_date` DATE COMMENT 'Date the geometry was captured / last surveyed.',
  `gis_source_system` STRING COMMENT 'GIS system of record (e.g. ESRI_UN, GE_SMALLWORLD, HEXAGON).',
  `is_approximate_flag` BOOLEAN COMMENT 'TRUE when the location is approximated (e.g. geocoded premise centroid).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_gis_location` PRIMARY KEY (`location_id`)
)
USING DELTA
COMMENT 'Canonical CIM Location: the place where a power system resource, asset, usage point, work, outage or organisation is, has been or will be. Holds the geometry (WKT/WKB/GeoJSON, OGC Simple Features), its CRS, a representative WGS84 point, H3 spatial index and the postal address. Ordered vertices are in gis.position_point. | CMM: CIM Location (exact), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'GisLocation',
  'cmm.cim.class' = 'Location',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'cmm-standard'
);

-- PositionPoint  <<CIM PositionPoint : exact>>
CREATE TABLE IF NOT EXISTS `gis`.`position_point` (
  `position_point_id` BIGINT NOT NULL COMMENT 'Surrogate primary key of PositionPoint.',
  `location_id` BIGINT NOT NULL COMMENT 'Owning location.',
  `sequence_number` INT NOT NULL COMMENT 'Zero-or-one based ordinal of the vertex within the group.',
  `group_number` INT COMMENT 'Part / ring number for multi-part geometries.',
  `x_position` DOUBLE NOT NULL COMMENT 'X axis position (longitude or easting).',
  `y_position` DOUBLE NOT NULL COMMENT 'Y axis position (latitude or northing).',
  `z_position` DOUBLE COMMENT 'Z axis position (elevation).',
  `m_value` DOUBLE COMMENT 'Linear-referencing measure value at the vertex (ISO 19148).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_gis_position_point` PRIMARY KEY (`position_point_id`)
)
USING DELTA
COMMENT 'CIM PositionPoint: ordered set of coordinates (vertices) of a Location\'s geometry, expressed in the Location\'s CoordinateSystem. groupNumber separates parts of multi-part geometries / polygon rings. | CMM: CIM PositionPoint (exact), IEC61968::Common.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'PositionPoint',
  'cmm.cim.class' = 'PositionPoint',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61968::Common',
  'cmm.cim.standard' = 'IEC 61968-11',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'cmm-standard'
);

-- LocationAssignment  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `gis`.`location_assignment` (
  `location_assignment_id` BIGINT NOT NULL COMMENT 'Surrogate primary key of LocationAssignment.',
  `location_id` BIGINT NOT NULL COMMENT 'Assigned location.',
  `entity_schema` STRING NOT NULL COMMENT 'Canonical schema of the located entity.',
  `entity_table` STRING NOT NULL COMMENT 'Canonical table of the located entity.',
  `entity_id` BIGINT NOT NULL COMMENT 'Primary key value of the located entity.',
  `entity_mrid` STRING COMMENT 'mRID of the located entity.',
  `entity_cim_class` STRING COMMENT 'CIM class of the located entity.',
  `cim_association_role` STRING COMMENT 'CIM association implemented (e.g. PowerSystemResource.Location).',
  `location_role` STRING NOT NULL COMMENT 'Role of the location for the entity. Valid values: primary|service|mailing|work|installed|planned|historical|fault.',
  `is_primary_flag` BOOLEAN NOT NULL COMMENT 'TRUE when this is the entity\'s primary location.',
  `effective_start_ts` TIMESTAMP NOT NULL COMMENT 'Start of validity of the assignment.',
  `effective_end_ts` TIMESTAMP COMMENT 'End of validity (NULL = current).',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_gis_location_assignment` PRIMARY KEY (`location_assignment_id`)
)
USING DELTA
COMMENT 'Polymorphic, time-variant association between any canonical entity and a CIM Location (implements PowerSystemResource.Location, Asset.Location, UsagePoint.UsagePointLocation, BaseWork.WorkLocation, Incident.Location). Supports relocations and multiple location roles. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'LocationAssignment',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'cmm-standard'
);

-- GeographicalRegion  <<CIM GeographicalRegion : exact>>
CREATE TABLE IF NOT EXISTS `gis`.`geographical_region` (
  `geographical_region_id` BIGINT NOT NULL COMMENT 'Surrogate primary key of GeographicalRegion.',
  `name` STRING NOT NULL COMMENT 'Region name.',
  `description` STRING COMMENT 'Region description.',
  `region_code` STRING COMMENT 'Business code of the region.',
  `region_kind` STRING NOT NULL COMMENT 'Kind of region. Valid values: geographical_region|sub_geographical_region|service_territory|franchise_area|load_area|sub_load_area|control_area|forecast_zone|outage_area|storm_zone|right_of_way|county|state.',
  `parent_geographical_region_id` BIGINT COMMENT 'Parent region (SubGeographicalRegion.Region).',
  `location_id` BIGINT COMMENT 'Polygon geometry of the region.',
  `source_entity_table` STRING COMMENT 'Canonical table that owns the business record of this region (e.g. distribution.service_territory).',
  `source_entity_id` BIGINT COMMENT 'Primary key of the owning business record.',
  `area_sq_km` DECIMAL(18,3) COMMENT 'Area in square kilometres.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_gis_geographical_region` PRIMARY KEY (`geographical_region_id`)
)
USING DELTA
COMMENT 'CIM GeographicalRegion / SubGeographicalRegion hierarchy and other polygonal areas (service territory, franchise area, load area, control area, forecast zone, outage area, storm zone). Geometry via gis.location. | CMM: CIM GeographicalRegion (exact), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'GeographicalRegion',
  'cmm.cim.class' = 'GeographicalRegion',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'cmm-standard'
);

-- ConnectivityNode  <<CIM ConnectivityNode : exact>>
CREATE TABLE IF NOT EXISTS `gis`.`connectivity_node` (
  `connectivity_node_id` BIGINT NOT NULL COMMENT 'Surrogate primary key of ConnectivityNode.',
  `name` STRING COMMENT 'Node name.',
  `description` STRING COMMENT 'Node description.',
  `container_entity_table` STRING COMMENT 'Canonical table of the ConnectivityNodeContainer (substation, feeder, line, plant).',
  `container_entity_id` BIGINT COMMENT 'Primary key of the container.',
  `container_cim_class` STRING COMMENT 'CIM class of the container (Substation, Feeder, Line, Plant, VoltageLevel, Bay).',
  `topological_node_id` BIGINT COMMENT 'Bus-branch topological node (grid.ems_node) this node collapses into.',
  `nominal_voltage_kv` DECIMAL(10,3) COMMENT 'Nominal voltage at the node in kV.',
  `location_id` BIGINT COMMENT 'Location of the node.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_gis_connectivity_node` PRIMARY KEY (`connectivity_node_id`)
)
USING DELTA
COMMENT 'CIM ConnectivityNode: point where terminals of conducting equipment are connected with zero impedance. Basis of the as-built electrical connectivity model derived from the GIS (Utility Network) and EMS/ADMS. | CMM: CIM ConnectivityNode (exact), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'ConnectivityNode',
  'cmm.cim.class' = 'ConnectivityNode',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'cmm-standard'
);

-- Terminal  <<CIM Terminal : exact>>
CREATE TABLE IF NOT EXISTS `gis`.`terminal` (
  `terminal_id` BIGINT NOT NULL COMMENT 'Surrogate primary key of Terminal.',
  `name` STRING COMMENT 'Terminal name.',
  `sequence_number` INT NOT NULL COMMENT 'Orientation/sequence of the terminal on the equipment (1, 2, ...).',
  `phases` STRING COMMENT 'Phases at the terminal (CIM PhaseCode). Valid values: ABC|ABCN|AB|AC|BC|ABN|ACN|BCN|A|B|C|AN|BN|CN|N|s1|s2|s12|s1N|s2N|s12N.',
  `connected_flag` BOOLEAN COMMENT 'Connection status of the terminal (ACDCTerminal.connected).',
  `connectivity_node_id` BIGINT COMMENT 'Connectivity node the terminal connects to.',
  `conducting_equipment_table` STRING NOT NULL COMMENT 'Canonical table of the conducting equipment.',
  `conducting_equipment_id` BIGINT NOT NULL COMMENT 'Primary key of the conducting equipment.',
  `conducting_equipment_mrid` STRING COMMENT 'mRID of the conducting equipment.',
  `conducting_equipment_cim_class` STRING COMMENT 'CIM class of the conducting equipment.',
  `esri_terminal_id` INT COMMENT 'Esri Utility Network terminal id within the terminal configuration.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_gis_terminal` PRIMARY KEY (`terminal_id`)
)
USING DELTA
COMMENT 'CIM Terminal: AC electrical connection point of a piece of conducting equipment to a ConnectivityNode, with phases. Equipment is referenced polymorphically by canonical table, id and mRID. | CMM: CIM Terminal (exact), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'Terminal',
  'cmm.cim.class' = 'Terminal',
  'cmm.cim.match' = 'exact',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'cmm-standard'
);

-- NetworkFeature  <<CIM PowerSystemResource : extension>>
CREATE TABLE IF NOT EXISTS `gis`.`network_feature` (
  `network_feature_id` BIGINT NOT NULL COMMENT 'Surrogate primary key of NetworkFeature.',
  `esri_global_id` STRING NOT NULL COMMENT 'Esri GlobalID (GUID) of the feature.',
  `esri_object_id` BIGINT COMMENT 'Esri ObjectID.',
  `network_domain` STRING NOT NULL COMMENT 'Utility Network domain network. Valid values: electric_distribution|electric_transmission|structure|telecom.',
  `feature_class` STRING NOT NULL COMMENT 'Utility Network feature class. Valid values: ElectricDevice|ElectricJunction|ElectricLine|ElectricAssembly|ElectricSubnetLine|StructureJunction|StructureLine|StructureBoundary|ServiceTerritory.',
  `asset_group` STRING COMMENT 'Utility Network asset group (e.g. Medium Voltage Transformer).',
  `asset_type` STRING COMMENT 'Utility Network asset type (e.g. Overhead Single Phase).',
  `tier_name` STRING COMMENT 'Network tier (e.g. Subtransmission, Medium Voltage Radial, Low Voltage).',
  `subnetwork_name` STRING COMMENT 'Subnetwork (feeder / circuit) name.',
  `is_subnetwork_controller_flag` BOOLEAN COMMENT 'TRUE when the feature is a subnetwork controller (feeder head / circuit breaker).',
  `terminal_configuration` STRING COMMENT 'Utility Network terminal configuration name.',
  `lifecycle_status` STRING COMMENT 'GIS lifecycle status. Valid values: proposed|in_design|under_construction|in_service|abandoned|removed.',
  `normal_status` STRING COMMENT 'Normal (shelf) switching status for switchable devices. Valid values: open|closed|not_applicable.',
  `phases_normal` STRING COMMENT 'Normal energised phases (CIM PhaseCode).',
  `nominal_voltage_kv` DECIMAL(10,3) COMMENT 'Nominal voltage in kV.',
  `gis_feature_code` STRING COMMENT 'GIS feature code used in source domains.',
  `gis_layer_name` STRING COMMENT 'GIS layer name.',
  `location_id` BIGINT NOT NULL COMMENT 'Geometry of the feature.',
  `canonical_entity_table` STRING COMMENT 'Canonical table that holds the business record of the feature.',
  `canonical_entity_id` BIGINT COMMENT 'Primary key of the business record.',
  `canonical_entity_mrid` STRING COMMENT 'mRID of the business record.',
  `cim_class` STRING COMMENT 'CIM class of the feature (e.g. PowerTransformer, ACLineSegment, Breaker, Pole).',
  `last_edited_ts` TIMESTAMP COMMENT 'Last GIS edit timestamp.',
  `last_edited_by` STRING COMMENT 'Last GIS editor.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_gis_network_feature` PRIMARY KEY (`network_feature_id`)
)
USING DELTA
COMMENT 'Esri ArcGIS Utility Network feature registry aligned to CIM: each GIS network feature (device, junction, line, assembly, structure, subnet line) mapped to its canonical entity, CIM class and Location. Carries UN asset group/type, tier, subnetwork and lifecycle. | CMM: CIM PowerSystemResource (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'NetworkFeature',
  'cmm.cim.class' = 'PowerSystemResource',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'master_data',
  'cmm.source.object' = 'cmm-standard'
);

-- NetworkAssociation  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `gis`.`network_association` (
  `network_association_id` BIGINT NOT NULL COMMENT 'Surrogate primary key of NetworkAssociation.',
  `association_type` STRING NOT NULL COMMENT 'Association type. Valid values: connectivity|containment|structural_attachment.',
  `from_network_feature_id` BIGINT NOT NULL COMMENT 'From feature (container / structure / first connected feature).',
  `to_network_feature_id` BIGINT NOT NULL COMMENT 'To feature (content / attachment / second connected feature).',
  `from_terminal_id` BIGINT COMMENT 'From terminal for connectivity associations.',
  `to_terminal_id` BIGINT COMMENT 'To terminal for connectivity associations.',
  `is_content_visible_flag` BOOLEAN COMMENT 'Whether content is visible on map (UN containment).',
  `cim_equivalent` STRING COMMENT 'CIM construct implemented by the association. Valid values: Terminal-ConnectivityNode|Equipment.EquipmentContainer|Asset.AssetContainer.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_gis_network_association` PRIMARY KEY (`network_association_id`)
)
USING DELTA
COMMENT 'Esri Utility Network associations (connectivity, containment, structural attachment) aligned to CIM: connectivity = Terminal/ConnectivityNode, containment = Equipment.EquipmentContainer / Asset.AssetContainer, structural attachment = Asset.AssetContainer (Structure). | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'NetworkAssociation',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'association_data',
  'cmm.source.object' = 'cmm-standard'
);

-- LinearReference  <<CIM IdentifiedObject : extension>>
CREATE TABLE IF NOT EXISTS `gis`.`linear_reference` (
  `linear_reference_id` BIGINT NOT NULL COMMENT 'Surrogate primary key of LinearReference.',
  `route_location_id` BIGINT NOT NULL COMMENT 'Linear route geometry (gis.location of the line / corridor).',
  `route_entity_table` STRING COMMENT 'Canonical table of the route entity (e.g. transmission.line).',
  `route_entity_id` BIGINT COMMENT 'Primary key of the route entity.',
  `referenced_entity_table` STRING NOT NULL COMMENT 'Canonical table of the located event / feature.',
  `referenced_entity_id` BIGINT NOT NULL COMMENT 'Primary key of the located event / feature.',
  `from_measure` DOUBLE NOT NULL COMMENT 'Start measure along the route.',
  `to_measure` DOUBLE COMMENT 'End measure along the route (NULL for point events).',
  `measure_unit` STRING NOT NULL COMMENT 'Unit of the measures. Valid values: m|km|ft|mi.',
  `lateral_offset_m` DECIMAL(10,3) COMMENT 'Lateral offset from the route centreline in metres.',
  `mrid` STRING NOT NULL COMMENT 'CIM IdentifiedObject.mRID - globally unique, persistent master resource identifier (UUID, RFC 4122). Deterministic UUIDv5 over (src_system_code, src_record_key) when the source does not supply one.',
  `cmm_src_system_code` STRING NOT NULL COMMENT 'Code of the system of record that supplied this row (e.g. SAP_ISU, ORACLE_CCB, VENTYX_EAM, ESRI_UN, OSI_PI). CIM Name.NameType.NameTypeAuthority equivalent.',
  `cmm_src_record_key` STRING NOT NULL COMMENT 'Natural/business key of the record in the source system (lineage key, CIM Name.name for NameType = source key).',
  `cmm_row_hash` STRING COMMENT 'SHA-256 hash of all business columns; used for change detection in MERGE (SCD1 with Change Data Feed history).',
  `cmm_is_deleted` BOOLEAN NOT NULL COMMENT 'Soft-delete indicator propagated from source deletes (TRUE = logically deleted).',
  `cmm_dq_status` STRING COMMENT 'Data quality outcome of silver validation for this row. Valid values are `PASS|WARN|FAIL`. Valid values: PASS|WARN|FAIL.',
  `cmm_batch_id` STRING COMMENT 'Pipeline run / batch identifier that last wrote this row (lineage).',
  `cmm_insert_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was first inserted into the silver layer.',
  `cmm_update_ts` TIMESTAMP NOT NULL COMMENT 'UTC timestamp when the row was last updated in the silver layer.',
  CONSTRAINT `pk_gis_linear_reference` PRIMARY KEY (`linear_reference_id`)
)
USING DELTA
COMMENT 'Linear referencing (ISO 19148) of point or segment events along a linear route (transmission line, feeder backbone, right-of-way), e.g. towers, fault locations, vegetation spans, inspection findings. | CMM: CIM IdentifiedObject (extension), IEC61970::Core.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.columnMapping.mode' = 'name',
  'cmm.layer' = 'silver',
  'cmm.model.version' = '1.0.0',
  'cmm.entity' = 'LinearReference',
  'cmm.cim.class' = 'IdentifiedObject',
  'cmm.cim.match' = 'extension',
  'cmm.cim.package' = 'IEC61970::Core',
  'cmm.cim.standard' = 'IEC 61970-301',
  'cmm.data.classification' = 'transactional_data',
  'cmm.source.object' = 'cmm-standard'
);

-- ========= FOREIGN KEYS within gis (13) =========
ALTER TABLE `gis`.`location` DROP CONSTRAINT IF EXISTS `fk_gis_location_coordinate_system_id`;
ALTER TABLE `gis`.`location` ADD CONSTRAINT `fk_gis_location_coordinate_system_id` FOREIGN KEY (`coordinate_system_id`) REFERENCES `gis`.`coordinate_system` (`coordinate_system_id`);

ALTER TABLE `gis`.`position_point` DROP CONSTRAINT IF EXISTS `fk_gis_position_point_location_id`;
ALTER TABLE `gis`.`position_point` ADD CONSTRAINT `fk_gis_position_point_location_id` FOREIGN KEY (`location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `gis`.`location_assignment` DROP CONSTRAINT IF EXISTS `fk_gis_location_assignment_location_id`;
ALTER TABLE `gis`.`location_assignment` ADD CONSTRAINT `fk_gis_location_assignment_location_id` FOREIGN KEY (`location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `gis`.`geographical_region` DROP CONSTRAINT IF EXISTS `fk_gis_geographical_region_parent_geographical_region_id`;
ALTER TABLE `gis`.`geographical_region` ADD CONSTRAINT `fk_gis_geographical_region_parent_geographical_region_id` FOREIGN KEY (`parent_geographical_region_id`) REFERENCES `gis`.`geographical_region` (`geographical_region_id`);

ALTER TABLE `gis`.`geographical_region` DROP CONSTRAINT IF EXISTS `fk_gis_geographical_region_location_id`;
ALTER TABLE `gis`.`geographical_region` ADD CONSTRAINT `fk_gis_geographical_region_location_id` FOREIGN KEY (`location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `gis`.`connectivity_node` DROP CONSTRAINT IF EXISTS `fk_gis_connectivity_node_location_id`;
ALTER TABLE `gis`.`connectivity_node` ADD CONSTRAINT `fk_gis_connectivity_node_location_id` FOREIGN KEY (`location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `gis`.`terminal` DROP CONSTRAINT IF EXISTS `fk_gis_terminal_connectivity_node_id`;
ALTER TABLE `gis`.`terminal` ADD CONSTRAINT `fk_gis_terminal_connectivity_node_id` FOREIGN KEY (`connectivity_node_id`) REFERENCES `gis`.`connectivity_node` (`connectivity_node_id`);

ALTER TABLE `gis`.`network_feature` DROP CONSTRAINT IF EXISTS `fk_gis_network_feature_location_id`;
ALTER TABLE `gis`.`network_feature` ADD CONSTRAINT `fk_gis_network_feature_location_id` FOREIGN KEY (`location_id`) REFERENCES `gis`.`location` (`location_id`);

ALTER TABLE `gis`.`network_association` DROP CONSTRAINT IF EXISTS `fk_gis_network_association_from_network_feature_id`;
ALTER TABLE `gis`.`network_association` ADD CONSTRAINT `fk_gis_network_association_from_network_feature_id` FOREIGN KEY (`from_network_feature_id`) REFERENCES `gis`.`network_feature` (`network_feature_id`);

ALTER TABLE `gis`.`network_association` DROP CONSTRAINT IF EXISTS `fk_gis_network_association_to_network_feature_id`;
ALTER TABLE `gis`.`network_association` ADD CONSTRAINT `fk_gis_network_association_to_network_feature_id` FOREIGN KEY (`to_network_feature_id`) REFERENCES `gis`.`network_feature` (`network_feature_id`);

ALTER TABLE `gis`.`network_association` DROP CONSTRAINT IF EXISTS `fk_gis_network_association_from_terminal_id`;
ALTER TABLE `gis`.`network_association` ADD CONSTRAINT `fk_gis_network_association_from_terminal_id` FOREIGN KEY (`from_terminal_id`) REFERENCES `gis`.`terminal` (`terminal_id`);

ALTER TABLE `gis`.`network_association` DROP CONSTRAINT IF EXISTS `fk_gis_network_association_to_terminal_id`;
ALTER TABLE `gis`.`network_association` ADD CONSTRAINT `fk_gis_network_association_to_terminal_id` FOREIGN KEY (`to_terminal_id`) REFERENCES `gis`.`terminal` (`terminal_id`);

ALTER TABLE `gis`.`linear_reference` DROP CONSTRAINT IF EXISTS `fk_gis_linear_reference_route_location_id`;
ALTER TABLE `gis`.`linear_reference` ADD CONSTRAINT `fk_gis_linear_reference_route_location_id` FOREIGN KEY (`route_location_id`) REFERENCES `gis`.`location` (`location_id`);

