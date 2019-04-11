--
-- CORE CONCEPTS SHOULD BE IMPORTED FROM JSON FIRST!!!
--

-- Reset auto-increment
SELECT @max := MAX(dbid)+ 1 FROM concept;
SET @qry = concat('ALTER TABLE concept AUTO_INCREMENT = ', @max);
PREPARE stmt FROM @qry;
EXECUTE stmt;

DEALLOCATE PREPARE stmt;


-- Create concepts
INSERT INTO document
(data)
VALUES
(JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/Discovery/1.0.0'));

/*INSERT INTO concept(data)
VALUES (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/Discovery/1.0.0',
                    'id', 'Discovery',
                    'name', 'Discovery',
                    'description', 'The Discovery code scheme',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'CodeScheme'
                        )));

INSERT INTO concept (data)
SELECT JSON_OBJECT(
           'document', 'http://DiscoveryDataService/InformationModel/dm/Discovery/1.0.0',
           'id', concat('DS_',f.conceptId),
           'name', IF(LENGTH(f.term) > 60, CONCAT(LEFT(f.term, 57), '...'), f.term),
           'description', f.term,
           -- 'code_scheme', 'Discovery',
           -- 'code', f.conceptId,
           'is_subtype_of', JSON_OBJECT(
               'id','CodeableConcept'
               )
           )
FROM snomed_refset_clinical_active_preferred_component r
         JOIN snomed_description_active_fully_specified f ON f.id = r.referencedComponentId;

UPDATE concept c
    INNER JOIN (
        SELECT id, JSON_OBJECTAGG(prop, val) as rel
        FROM
            (SELECT concat('DS_', sourceId) as id, concat('DS_', rel.typeId) as prop,
                    JSON_ARRAYAGG(
                        JSON_OBJECT(
                            'id', concat('DS_', rel.destinationId)
                            )
                        ) as val
             FROM snomed_relationship rel
             GROUP BY rel.sourceId, rel.typeId) t1
        GROUP BY id) t2
    ON t2.id = c.id
SET data=JSON_MERGE(c.data, t2.rel);
*/
