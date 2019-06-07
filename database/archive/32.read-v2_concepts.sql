-- Create document
INSERT INTO document
(iri)
VALUES
('http://DiscoveryDataService/InformationModel/dm/READ2/1.0.0');

SELECT @doc := LAST_INSERT_ID();

DROP TABLE IF EXISTS read_v2_tmp;
CREATE TABLE read_v2_tmp (
    id VARCHAR(50) COLLATE utf8_bin NOT NULL,
    name VARCHAR(200) NOT NULL,
    `desc` VARCHAR(400),
    type INT NOT NULL,
    code VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Build concept creation list
INSERT INTO read_v2_tmp
(id, name, `desc`, type)
VALUES
('READ2', 'READ 2', 'The READ2 code scheme', get_dbid('CodeScheme'));

SET @codeable = get_dbid('CodeableConcept');
INSERT INTO read_v2_tmp
(id, name, `desc`, type, code)
SELECT
    concat('R2_',code) as id,
    if(length(term) > 60, concat(left(term, 57), '...'), term) as name,
    term as `desc`,
    @codeable as type,
    code
FROM read_v2;

-- Pre-allocate concept DBIds
INSERT INTO concept
(document, id)
SELECT @doc, id
FROM read_v2_tmp;

-- Populate concept properties
SET @prop = get_dbid('name');
INSERT INTO concept_property_data
(dbid, property, value)
SELECT c.dbid, @prop, s.name
FROM read_v2_tmp s
JOIN concept c ON c.id = s.id;

SET @prop = get_dbid('description');
INSERT INTO concept_property_data
(dbid, property, value)
SELECT c.dbid, @prop, s.desc
FROM read_v2_tmp s
JOIN concept c ON c.id = s.id
WHERE s.desc IS NOT NULL;

SET @prop = get_dbid('code');
INSERT INTO concept_property_data
(dbid, property, value)
SELECT c.dbid, @prop, s.code
FROM read_v2_tmp s
JOIN concept c ON c.id = s.id
WHERE s.code IS NOT NULL;

SET @prop = get_dbid('is_subtype_of');
INSERT INTO concept_property_object
(dbid, property, value)
SELECT c.dbid, @prop, s.type
FROM read_v2_tmp s
JOIN concept c ON c.id = s.id;

SET @prop = get_dbid('code_scheme');
SET @val = get_dbid('READ2');
INSERT INTO concept_property_object
(dbid, property, value)
SELECT c.dbid, @prop, @val
FROM read_v2_tmp s
JOIN concept c ON c.id = s.id
WHERE s.code IS NOT NULL;


-- ATTRIBUTES
DROP TABLE IF EXISTS read_v2_hierarchy;
CREATE TABLE read_v2_hierarchy
SELECT r.code AS code, @code:=REPLACE(r.code,'.','') AS code_trimmed, @parent:=RPAD(SUBSTRING(@code, 1, LENGTH(@code)-1), 5, '.') AS parent
FROM read_v2 r;

SET @prop = get_dbid('is_descendant_of');
INSERT INTO concept_property_object
(dbid, `group`, property, value)
SELECT c.dbid, 0, @prop, v.dbid
FROM read_v2_hierarchy r
JOIN concept c ON c.id = CONCAT('R2_', r.code)
JOIN concept v ON v.id = CONCAT('R2_', r.parent);

