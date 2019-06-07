-- Create document
INSERT INTO document
(iri)
VALUES
('http://DiscoveryDataService/InformationModel/dm/Discovery/1.0.0');

SELECT @doc := LAST_INSERT_ID();

-- Allocate ids for new concepts
INSERT INTO concept
(document, id)
SELECT @doc, CONCAT('DCE_', REPLACE(term, ' ', '_')) as id
FROM encounter_types;

-- Add concept properties
INSERT INTO concept_property_data
(dbid, property, value)
SELECT get_dbid(CONCAT('DCE_', REPLACE(term, ' ', '_'))), get_dbid('name'), term
FROM encounter_types;

INSERT INTO concept_property_object
(dbid, property, value)
SELECT get_dbid(CONCAT('DCE_', REPLACE(term, ' ', '_'))), get_dbid('is_subtype_of'), get_dbid('CodeableConcept')
FROM encounter_types;

-- Hierarchy
INSERT INTO concept_property_object
(dbid, property, value)
SELECT get_dbid(CONCAT('DCE_', REPLACE(s.term, ' ', '_'))), get_dbid('is_descendant_of'), get_dbid(CONCAT('DCE_', REPLACE(t.term, ' ', '_')))
FROM encounter_subtypes s
JOIN encounter_types t ON t.id = s.targetId;

-- Local encounter concepts
-- Allocate IDs
INSERT INTO concept
(document, id)
SELECT @doc, CONCAT('LENC_', REPLACE(sourceTerm, ' ', '_'))
FROM encounter_maps;

INSERT INTO concept_property_data
(dbid, property, value)
SELECT get_dbid(CONCAT('LENC_', REPLACE(sourceTerm, ' ', '_'))), get_dbid('name'), sourceTerm
FROM encounter_maps;

INSERT INTO concept_property_object
(dbid, property, value)
SELECT get_dbid(CONCAT('LENC_', REPLACE(sourceTerm, ' ', '_'))), get_dbid('is_subtype_of'), get_dbid('CodeableConcept')
FROM encounter_maps;

INSERT INTO concept_property_object
(dbid, property, value)
SELECT get_dbid(CONCAT('LENC_', REPLACE(m.sourceTerm, ' ', '_'))), get_dbid('is_equivalent_to'), get_dbid(CONCAT('DCE_', REPLACE(t.term, ' ', '_')))
FROM encounter_maps m
JOIN encounter_types t ON t.id = m.targetId;

INSERT INTO concept_term_map
(term, type, target)
SELECT sourceTerm, get_dbid('DCE_Type_of_encounter'), get_dbid(CONCAT('LENC_', REPLACE(m.sourceTerm, ' ', '_')))
FROM encounter_maps m;

SELECT @max := MAX(dbid) FROM concept;
SELECT @cnt := COUNT(1) FROM encounter_types;
SELECT @new := @max + @cnt;

SET @qry = concat('ALTER TABLE concept AUTO_INCREMENT = ', @new);
PREPARE stmt FROM @qry;
EXECUTE stmt;

-- Assign ids to rows
ALTER TABLE encounter_types
ADD COLUMN dbid INTEGER;

UPDATE encounter_types
SET dbid = id + @max;

-- Create concepts
INSERT INTO concept
(dbid, data)
SELECT dbid,
       JSON_OBJECT(
           'document', 'http://DiscoveryDataService/InformationModel/dm/Discovery/1.0.0',
        'id', CONCAT('DS_', dbid),
           'name', term,
           'description', term
           ) as data
FROM encounter_types;

-- Get ROOT ("Type of encounter") concept Id
SELECT @encounterType := dbid
FROM encounter_types
WHERE term = 'Type of encounter';

-- Set the ID to something more meaningful!
UPDATE concept
SET data = JSON_MERGE_PATCH(data, JSON_OBJECT('id', 'EncounterType'))
WHERE dbid = @encounterType;

-- Set subtypes/relationships
UPDATE concept c
INNER JOIN (
        SELECT s.dbid,
               JSON_OBJECT('is_a', JSON_OBJECT('id', c.id)) as is_a
        FROM encounter_subtypes e
                 JOIN encounter_types s ON s.id = e.id
                 JOIN encounter_types t ON t.id = e.targetId
                 JOIN concept c ON c.dbid = t.dbid
    ) t ON t.dbid = c.dbid
SET data = JSON_MERGE(data, t.is_a);

-- Populate maps
INSERT INTO concept_term_map
(type, term, target)
SELECT DISTINCT @encounterType, m.sourceTerm, dbid
FROM encounter_maps m
JOIN encounter_types t ON t.id = m.targetId;
