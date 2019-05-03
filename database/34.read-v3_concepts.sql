-- Create document
INSERT INTO document
(iri)
VALUES
('http://DiscoveryDataService/InformationModel/dm/CTV3/1.0.0');

SELECT @doc := LAST_INSERT_ID();

DROP TABLE IF EXISTS read_v3_tmp;
CREATE TABLE read_v3_tmp (
    id VARCHAR(50) NOT NULL,
    name VARCHAR(200) NOT NULL,
    `desc` VARCHAR(400),
    type INTEGER NOT NULL,
    code VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Build concept creation list
INSERT INTO read_v3_tmp
(id, name, `desc`, type)
VALUES
('CTV3', 'READ 3', 'The READ (CTV) 3 code scheme', get_dbid('CodeScheme'));

-- READ v3 Current subset
SET @codeable = get_dbid('CodeableConcept');
INSERT INTO read_v3_tmp
(id, name, `desc`, type, code)
SELECT
    CONCAT('R3_',c.code),
    COALESCE(term_62, term_31),
    COALESCE(term, term_62, term_31),
    @codeable,
    c.code
FROM read_v3_concept c
         JOIN read_v3_desc d ON d.code = c.code AND d.type = 'P'
         JOIN read_v3_terms t ON t.termId = d.termId AND t.status = 'C'
WHERE c.status = 'C';

-- Pre-allocate concept DBIds
INSERT INTO concept
(document, id)
SELECT @doc, id
FROM read_v3_tmp;

-- Populate concept properties
SET @prop = get_dbid('name');
INSERT INTO concept_property_data
(dbid, property, value)
SELECT c.dbid, @prop, s.name
FROM read_v3_tmp s
JOIN concept c ON c.id = s.id;

SET @prop = get_dbid('description');
INSERT INTO concept_property_data
(dbid, property, value)
SELECT c.dbid, @prop, s.desc
FROM read_v3_tmp s
JOIN concept c ON c.id = s.id
WHERE s.desc IS NOT NULL;

SET @prop = get_dbid('code');
INSERT INTO concept_property_data
(dbid, property, value)
SELECT c.dbid, @prop, s.code
FROM read_v3_tmp s
JOIN concept c ON c.id = s.id
WHERE s.code IS NOT NULL;

SET @prop = get_dbid('is_subtype_of');
INSERT INTO concept_property_object
(dbid, property, value)
SELECT c.dbid, @prop, s.type
FROM read_v3_tmp s
JOIN concept c ON c.id = s.id;

SET @prop = get_dbid('code_scheme');
SET @val = get_dbid('CTV3');
INSERT INTO concept_property_object
(dbid, property, value)
SELECT c.dbid, @prop, @val
FROM read_v3_tmp s
JOIN concept c ON c.id = s.id
WHERE s.code IS NOT NULL;

-- Populate hierarchy
SET @prop = get_dbid('is_descendant_of');
INSERT INTO concept_property_object
(dbid, `group`, property, value)
SELECT c.dbid, 0, @prop, v.dbid
FROM read_v3_hier r
JOIN concept c ON c.id = CONCAT('R3_', r.code)
JOIN concept v ON v.id = CONCAT('R3_', r.parent);


