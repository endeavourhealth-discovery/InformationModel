-- Filter the entries we're interested in
DROP TABLE IF EXISTS snomed_description_filtered;
CREATE TABLE snomed_description_filtered
SELECT d.conceptId, d.term
FROM snomed_description d
JOIN snomed_concept c ON c.id = d.conceptId AND c.active = 1
WHERE d.moduleId = 900000000000207008
AND d.typeId = 900000000000003001
AND d.active = 1;

INSERT INTO snomed_description_filtered
SELECT d.conceptId, d.term
FROM snomed_refset_clinical_active_preferred_component r
JOIN snomed_description_active_fully_specified d ON d.id = r.referencedComponentId
WHERE d.moduleId <> 900000000000207008;

DROP TABLE IF EXISTS snomed_relationship_active;
CREATE TABLE snomed_relationship_active
SELECT *
FROM snomed_relationship
WHERE active = 1;

-- Create document
INSERT INTO document
(iri)
VALUES
('http://DiscoveryDataService/InformationModel/dm/Snomed/1.0.0');

SELECT @doc := LAST_INSERT_ID();

-- Create code scheme
INSERT INTO concept
(document, id)
VALUES
(@doc, 'SNOMED');

SELECT @scheme := LAST_INSERT_ID();

INSERT INTO concept_property_data
(dbid, property, value)
VALUES
(@scheme, get_dbid('name'), 'SNOMED'),
(@scheme, get_dbid('description'), 'SNOMED coding scheme');

INSERT INTO concept_property_object
(dbid, property, value)
VALUES
(@scheme, get_dbid('is_subtype_of'), get_dbid('CodeScheme'));

-- Pre-allocate concept ID's
INSERT INTO concept
(document, id)
SELECT @doc, concat('SN_',d.conceptId)
FROM snomed_description_filtered d;

-- Core concept properties
SET @property = get_dbid('name');
INSERT INTO concept_property_data
(dbid, property, value)
SELECT i.dbid as dbid , @property, IF(LENGTH(d.term) > 60, CONCAT(LEFT(d.term, 57), '...'), d.term) as value
FROM snomed_description_filtered d
JOIN concept i ON i.id = concat('SN_',d.conceptId);

SET @property = get_dbid('description');
INSERT INTO concept_property_data
(dbid, property, value)
SELECT i.dbid as dbid , @property, d.term as value
FROM snomed_description_filtered d
JOIN concept i ON i.id = concat('SN_',d.conceptId);

SET @property = get_dbid('code');
INSERT INTO concept_property_data
(dbid, property, value)
SELECT i.dbid as dbid , @property, d.conceptId as value
FROM snomed_description_filtered d
JOIN concept i ON i.id = concat('SN_',d.conceptId);

SET @property = get_dbid('code_scheme');
SET @value = get_dbid('SNOMED');
INSERT INTO concept_property_object
(dbid, property, value)
SELECT i.dbid as dbid , @property, @value
FROM snomed_description_filtered d
JOIN concept i ON i.id = concat('SN_',d.conceptId);

SET @property = get_dbid('is_subtype_of');
SET @value = get_dbid('CodeableConcept');
INSERT INTO concept_property_object
(dbid, property, value)
SELECT i.dbid as dbid , @property, @value
FROM snomed_description_filtered d
JOIN concept i ON i.id = concat('SN_',d.conceptId);

-- Relationships
INSERT INTO concept_property_object
(dbid, property, value)
SELECT c.dbid as dbid, p.dbid as property, v.dbid as value
FROM snomed_relationship_active r
JOIN concept c ON c.id = CONCAT('SN_', r.sourceId)
JOIN concept v ON v.id = CONCAT('SN_', r.destinationId)
JOIN concept p ON p.id = CONCAT('SN_', r.typeId);
