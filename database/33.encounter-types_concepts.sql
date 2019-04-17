-- Allocate ids for new concepts
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
