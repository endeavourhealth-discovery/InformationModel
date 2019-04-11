-- Reset auto-increment

SELECT @max := IFNULL(MAX(dbid), 0) + 1 FROM concept;
SET @qry = concat('ALTER TABLE concept AUTO_INCREMENT = ', @max);
PREPARE stmt FROM @qry;

-- Create DOCUMENT
INSERT INTO document
(data)
VALUES
(JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/Snomed/1.0.0'));

INSERT INTO concept(data)
VALUES (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/Snomed/1.0.0',
                    'id', 'SNOMED',
                    'name', 'SNOMED',
                    'description', 'The SNOMED code scheme',
                        'is_subtype_of', JSON_OBJECT(
                        'id', 'CodeScheme'
                        )));

-- INSERT CORE CONCEPTS
EXECUTE stmt;

INSERT INTO concept (data)
SELECT JSON_OBJECT(
               'document', 'http://DiscoveryDataService/InformationModel/dm/Snomed/1.0.0',
               'id', concat('SN_',d.conceptId),
               'name', IF(LENGTH(d.term) > 60, CONCAT(LEFT(d.term, 57), '...'), d.term),
               'description', d.term,
               'code_scheme', 'SNOMED',
               'code', d.conceptId,
               'is_subtype_of', JSON_OBJECT(
                       'id','CodeableConcept'
                   )
           )
FROM snomed_description d
         JOIN snomed_concept c ON c.id = d.conceptId AND c.active = 1
WHERE d.typeId = 900000000000003001
  AND d.active = 1
  AND d.moduleId = 900000000000207008;

-- INSERT NON-CORE CONCEPTS
EXECUTE stmt;

INSERT INTO concept (data)
SELECT JSON_OBJECT(
           'document', 'http://DiscoveryDataService/InformationModel/dm/Snomed/1.0.0',
           'id', concat('SN_',f.conceptId),
           'name', IF(LENGTH(f.term) > 60, CONCAT(LEFT(f.term, 57), '...'), f.term),
           'description', f.term,
           'code_scheme', 'SNOMED',
           'code', f.conceptId,
           'is_subtype_of', JSON_OBJECT(
               'id','CodeableConcept'
               )
           )
FROM snomed_refset_clinical_active_preferred_component r
JOIN snomed_description_active_fully_specified f ON f.id = r.referencedComponentId
WHERE f.moduleId <> 900000000000207008;


UPDATE concept c
    INNER JOIN (
        SELECT id, JSON_OBJECTAGG(prop, val) as rel
        FROM
            (SELECT concat('SN_', sourceId) as id, concat('SN_', rel.typeId) as prop,
                    JSON_ARRAYAGG(
                        JSON_OBJECT(
                            'id', concat('SN_', rel.destinationId)
                            )
                        ) as val
             FROM snomed_relationship rel
             GROUP BY rel.sourceId, rel.typeId) t1
        GROUP BY id) t2
    ON t2.id = c.id
SET data=JSON_MERGE(c.data, t2.rel);

DEALLOCATE PREPARE stmt;
