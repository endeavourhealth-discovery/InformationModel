-- Reset auto-increment

SELECT @max := MAX(dbid)+ 1 FROM concept;
SET @qry = concat('ALTER TABLE concept AUTO_INCREMENT = ', @max);
PREPARE stmt FROM @qry;
EXECUTE stmt;

DEALLOCATE PREPARE stmt;

INSERT INTO document
(data)
VALUES
(JSON_OBJECT('@document', 'http/DiscoveryDataService/InformationModel/dm/CTV3/1.0.1'));

CREATE TABLE read_v3_current
SELECT
    c.code, ifnull(term_62, term_31) as name, term as description
FROM read_v3_concept c
         JOIN read_v3_desc d ON d.code = c.code AND d.type = 'P'
         JOIN read_v3_terms t ON t.termId = d.termId AND t.status = 'C'
WHERE c.status = 'C';

INSERT INTO concept (data)
SELECT JSON_OBJECT(
           '@document', 'http/DiscoveryDataService/InformationModel/dm/CTV3/1.0.1',
           '@id', concat('R3-',code),
           '@name', if(length(name) > 60, concat(left(name, 57), '...'), name),
           '@description', ifnull(description, name),
           '@code_scheme', 'CTV3',
           '@code', code,
           '@is_subtype_of', JSON_OBJECT(
               '@id','@codeable_concept'
               )
           )
FROM read_v3_current;

UPDATE concept c
    INNER JOIN (
        SELECT id, JSON_OBJECTAGG(prop, val) as rel
        FROM
            (SELECT concat('R3-', rel.code) as id, '@has_parent' as prop,
                    JSON_ARRAYAGG(
                        JSON_OBJECT(
                            '@id', concat('R3-', rel.parent)
                            )
                        ) as val
             FROM read_v3_hier rel
             GROUP BY rel.code) t1
        GROUP BY id) t2
    ON t2.id = c.id
SET data=JSON_MERGE(c.data, t2.rel);

