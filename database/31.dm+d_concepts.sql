-- Create document
INSERT INTO document
(iri)
VALUES
('http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0');

SELECT @doc := LAST_INSERT_ID();

-- Build concept creation list
DROP TABLE IF EXISTS dmd_tmp;

CREATE TABLE dmd_tmp (
    id VARCHAR(50) NOT NULL,
    name VARCHAR(200) NOT NULL,
    `desc` VARCHAR(400),
    type VARCHAR(50) NOT NULL,
    value VARCHAR(50),
    code VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO dmd_tmp
(id, name, `desc`, type, value)
VALUES
('DMD_VTM', 'Virtual therapeutic moiety', null, 'CodeableConcept', null),
('DMD_VMP', 'Virtual medicinal product', null, 'CodeableConcept', null),
('DMD_has_moiety', 'Has moiety relationship', null, 'relationship', null),
('DMD_VMPP', 'Virtual medicinal prduct pack', null, 'CodeableConcept', null),
('DMD_is_pack_of', 'Is pack of relationship', null, 'relationship', null),
('DMD_AMP', 'Actual medicinal product', null, 'CodeableConcept', null),
('DMD_is_branded', 'Is branded relationship', 'An actual (branded) instances of a virtual (generic) product', 'relationshp', null),
('DMD_AMPP', 'Actual medicinal product pack', null, 'CodeableConcept', null),
('DMD_is_ingredient', 'Is ingredient relationship', null, 'relationship', null),
('DMD_Ingredient', 'Ingredient', null, 'CodeableConcept', null),
('DM+D', 'DM+D code scheme', 'Dictionary of Medicines & Devices', 'CodeScheme', null),
('DMD_UOM', 'Units of measure', 'DM+D specified units of measure', 'CodeableConcept', null),
('DMD_numerator_value', 'DM+D numerator value', 'Numerator value for an ingredient', 'data_property', 'Numeric'),
('DMD_numerator_units', 'DM+D numerator units', 'Numerator unit of measure for an ingredient', 'data_property', 'DMD_UOM'),
('DMD_denominator_value', 'DM+D denominator value', 'Denominator value for an ingredient', 'data_property', 'Numeric'),
('DMD_denominator_units', 'DM+D denominator units', 'Denominator unit of measure for an ingredient', 'data_property', 'DMD_UOM');

-- VTM

INSERT INTO dmd_tmp
(id, name, `desc`, type, code)
SELECT
    concat('DMD_', v.vtmid) as id,
ifnull(v.abbrevnm, if(length(v.nm) > 60, concat(left(v.nm, 57), '...'), v.nm)) as name,
    v.nm as `desc`,
    'DMD_VTM' as type,
v.vtmid as code
FROM dmd_vtm v
WHERE v.invalid IS NULL;

-- VMP

INSERT INTO dmd_tmp
(id, name, `desc`, type, code)
SELECT
    concat('DMD_', v.vpid) as id,
ifnull(v.abbrevnm, if(length(v.nm) > 60, concat(left(v.nm, 57), '...'), v.nm)) as name,
    v.nm as `desc`,
    'DMD_VMP' as type,
v.vpid as code
FROM dmd_vmp v
WHERE v.invalid IS NULL;

-- VMPP

INSERT INTO dmd_tmp
(id, name, `desc`, type, code)
SELECT
    concat('DMD_', v.vppid) as id,
ifnull(v.abbrevnm, if(length(v.nm) > 60, concat(left(v.nm, 57), '...'), v.nm)) as name,
    v.nm as `desc`,
    'DMD_VMPP' as type,
v.vppid as code
FROM dmd_vmpp v
WHERE v.invalid IS NULL;


-- AMP

INSERT INTO dmd_tmp
(id, name, `desc`, type, code)
SELECT
    concat('DMD_', v.apid) as id,
ifnull(v.abbrevnm, if(length(v.nm) > 60, concat(left(v.nm, 57), '...'), v.nm)) as name,
    v.nm as `desc`,
    'DMD_AMP' as type,
v.apid as code
FROM dmd_amp v
WHERE v.invalid IS NULL;

-- AMPP

INSERT INTO dmd_tmp
(id, name, `desc`, type, code)
SELECT
    concat('DMD_', v.appid) as id,
ifnull(v.abbrevnm, if(length(v.nm) > 60, concat(left(v.nm, 57), '...'), v.nm)) as name,
    v.nm as `desc`,
    'DMD_AMPP' as type,
v.appid as code
FROM dmd_ampp v
WHERE v.invalid IS NULL;

-- VPI

INSERT INTO dmd_tmp
(id, name, `desc`, type, code)
SELECT
    concat('DMD_', v.isid) as id,
if(length(v.nm) > 60, concat(left(v.nm, 57), '...'), v.nm) as name,
    v.nm as `desc`,
    'DMD_Ingredient' as type,
v.isid as code
FROM dmd_ingredient v
WHERE v.invalid IS NULL;



-- UOM

INSERT INTO dmd_tmp
(id, name, `desc`, type, code)
SELECT
    concat('DMD_', v.cd) as id,
if(length(v.desc) > 60, concat(left(v.desc, 57), '...'), v.desc) as name,
    v.desc as `desc`,
    'DMD_UOM' as type,
v.cd as code
FROM dmd_lu_uom v;

-- Pre-allocate DM+D concept DBIds
INSERT INTO concept
(document, id)
SELECT @doc, id
FROM dmd_tmp;

-- Populate common properties
SET @prop = get_dbid('name');
INSERT INTO concept_property_data
(dbid, property, value)
SELECT c.dbid, @prop, s.name
FROM dmd_tmp s
JOIN concept c ON c.id = s.id;

SET @prop = get_dbid('description');
INSERT INTO concept_property_data
(dbid, property, value)
SELECT c.dbid, @prop, s.desc
FROM dmd_tmp s
JOIN concept c ON c.id = s.id
WHERE s.desc IS NOT NULL;

SET @prop = get_dbid('code');
INSERT INTO concept_property_data
(dbid, property, value)
SELECT c.dbid, @prop, s.code
FROM dmd_tmp s
JOIN concept c ON c.id = s.id
WHERE s.code IS NOT NULL;

SET @prop = get_dbid('is_subtype_of');
INSERT INTO concept_property_object
(dbid, property, value)
SELECT c.dbid, @prop, v.dbid
FROM dmd_tmp s
JOIN concept c ON c.id = s.id
JOIN concept v ON v.id = s.type;

SET @prop = get_dbid('has_value_type');
INSERT INTO concept_property_object
(dbid, property, value)
SELECT c.dbid, @prop, v.dbid
FROM dmd_tmp s
JOIN concept c ON c.id = s.id
JOIN concept v ON v.id = s.value
WHERE s.value IS NOT NULL;

SET @prop = get_dbid('code_scheme');
SET @val = get_dbid('DM+D');
INSERT INTO concept_property_object
(dbid, property, value)
SELECT c.dbid, @prop, @val
FROM dmd_tmp s
JOIN concept c ON c.id = s.id
WHERE s.code IS NOT NULL;

-- Type specific properties
INSERT INTO concept_property_object
(dbid, `group`, property, value)
SELECT c.dbid, 0, p.dbid, v.dbid
FROM dmd_vmp r
         JOIN concept c ON c.id = CONCAT('DMD_', r.vpid)
         JOIN concept p ON p.id = 'DMD_has_moiety'
         JOIN concept v ON v.id = CONCAT('DMD_', r.vtmid)
WHERE r.vtmid IS NOT NULL
  AND r.invalid IS NULL;

INSERT INTO concept_property_object
(dbid, `group`, property, value)
SELECT c.dbid, 0, p.dbid, v.dbid
FROM dmd_vmpp r
         JOIN concept c ON c.id = CONCAT('DMD_', r.vppid)
         JOIN concept p ON p.id = 'DMD_is_pack_of'
         JOIN concept v ON v.id = CONCAT('DMD_', r.vpid)
WHERE r.invalid IS NULL;

INSERT INTO concept_property_object
(dbid, `group`, property, value)
SELECT c.dbid, 0, p.dbid, v.dbid
FROM dmd_amp r
         JOIN concept c ON c.id = CONCAT('DMD_', r.apid)
         JOIN concept p ON p.id = 'DMD_is_branded'
         JOIN concept v ON v.id = CONCAT('DMD_', r.vpid)
WHERE r.invalid IS NULL;

INSERT INTO concept_property_object
(dbid, `group`, property, value)
SELECT c.dbid, 0, p.dbid, v.dbid
FROM dmd_ampp r
         JOIN concept c ON c.id = CONCAT('DMD_', r.appid)
         JOIN concept p ON p.id = 'DMD_is_branded'
         JOIN concept v ON v.id = CONCAT('DMD_', r.vppid)
WHERE r.invalid IS NULL;

INSERT INTO concept_property_object
(dbid, `group`, property, value)
SELECT c.dbid, 0, p.dbid, v.dbid
FROM dmd_ampp r
         JOIN concept c ON c.id = CONCAT('DMD_', r.appid)
         JOIN concept p ON p.id = 'DMD_is_pack_of'
         JOIN concept v ON v.id = CONCAT('DMD_', r.apid)
WHERE r.invalid IS NULL;

INSERT INTO concept_property_object
(dbid, `group`, property, value)
SELECT c.dbid, 0, p.dbid, v.dbid
FROM dmd_vmp_vpi r
         JOIN concept c ON c.id = CONCAT('DMD_', r.vpid)
         JOIN concept p ON p.id = 'DMD_numerator_units'
         JOIN concept v ON v.id = CONCAT('DMD_', r.strnt_nmrtr_uomcd)
WHERE strnt_nmrtr_uomcd IS NOT NULL;

INSERT INTO concept_property_data
(dbid, `group`, property, value)
SELECT c.dbid, 0, p.dbid, r.strnt_nmrtr_val
FROM dmd_vmp_vpi r
         JOIN concept c ON c.id = CONCAT('DMD_', r.vpid)
         JOIN concept p ON p.id = 'DMD_numerator_value'
WHERE strnt_nmrtr_val IS NOT NULL;

INSERT INTO concept_property_object
(dbid, `group`, property, value)
SELECT c.dbid, 0, p.dbid, v.dbid
FROM dmd_vmp_vpi r
         JOIN concept c ON c.id = CONCAT('DMD_', r.vpid)
         JOIN concept p ON p.id = 'DMD_denominator_units'
         JOIN concept v ON v.id = CONCAT('DMD_', r.strnt_dnmtr_uomcd)
WHERE strnt_dnmtr_uomcd IS NOT NULL;

INSERT INTO concept_property_data
(dbid, `group`, property, value)
SELECT c.dbid, 0, p.dbid, r.strnt_dnmtr_val
FROM dmd_vmp_vpi r
         JOIN concept c ON c.id = CONCAT('DMD_', r.vpid)
         JOIN concept p ON p.id = 'DMD_denominator_units'
WHERE strnt_dnmtr_val IS NOT NULL;

DROP TABLE IF EXISTS dmd_tmp;
