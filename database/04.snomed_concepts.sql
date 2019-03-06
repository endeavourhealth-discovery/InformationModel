-- Reset auto-increment

SELECT @max := MAX(dbid)+ 1 FROM concept;
SET @qry = concat('ALTER TABLE concept AUTO_INCREMENT = ', @max);
PREPARE stmt FROM @qry;
EXECUTE stmt;

DEALLOCATE PREPARE stmt;

-- Create concepts
SET GLOBAL innodb_buffer_pool_size=512 * 1024 * 1024;

CREATE TABLE snomed_refset_clinical_active_preferred_component
SELECT referencedComponentId
FROM snomed_refset r
WHERE r.acceptabilityId = 900000000000548007
  AND r.refsetId = 999001261000000100
  AND r.active = 1;

ALTER TABLE snomed_refset_clinical_active_preferred_component ADD UNIQUE INDEX snomed_refset_clinical_active_preferred_component_pk (referencedComponentId);

CREATE TABLE snomed_description_active_fully_specified
SELECT d.id, d.conceptId, d.term
FROM snomed_description d
         JOIN snomed_concept c on c.id = d.conceptId
WHERE d.active = 1
  AND d.typeId = 900000000000003001
  AND c.active = 1;

ALTER TABLE snomed_description_active_fully_specified ADD UNIQUE INDEX snomed_description_active_fully_specified_pk (id);

INSERT INTO concept (data)
SELECT JSON_OBJECT(
           '@document', 'http/DiscoveryDataService/InformationModel/dm/Snomed/1.0.1',
           '@id', concat('SN-',f.conceptId),
           '@name', IF(LENGTH(f.term) > 60, CONCAT(LEFT(f.term, 57), '...'), f.term),
           '@description', f.term,
           '@code_scheme', 'SNOMED',
           '@code', f.conceptId,
           '@is_subtype_of', JSON_OBJECT(
               '@id','@codeable_concept'
               )
           )
FROM snomed_refset_clinical_active_preferred_component r
         JOIN snomed_description_active_fully_specified f ON f.id = r.referencedComponentId;

UPDATE concept c
    INNER JOIN (
        SELECT id, JSON_OBJECTAGG(prop, val) as rel
        FROM
            (SELECT concat('SN-', sourceId) as id, concat('SN-', rel.typeId) as prop,
                    JSON_ARRAYAGG(
                        JSON_OBJECT(
                            '@id', concat('SN-', rel.destinationId)
                            )
                        ) as val
             FROM snomed_relationship rel
             GROUP BY rel.sourceId, rel.typeId) t1
        GROUP BY id) t2
    ON t2.id = c.id
SET data=JSON_MERGE(c.data, t2.rel);
