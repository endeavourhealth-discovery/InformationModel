-- Reset auto-increment

SELECT @max := MAX(dbid)+ 1 FROM concept;
SET @qry = concat('ALTER TABLE concept AUTO_INCREMENT = ', @max);
PREPARE stmt FROM @qry;
EXECUTE stmt;

DEALLOCATE PREPARE stmt;

INSERT INTO document
(data)
VALUES
(JSON_OBJECT('@document', 'http/DiscoveryDataService/InformationModel/dm/READ2/1.0.1'));

-- CONCEPTS
INSERT INTO concept (data)
SELECT JSON_OBJECT(
           '@document', 'http/DiscoveryDataService/InformationModel/dm/READ2/1.0.1',
           '@id', concat('R2-',code),
           '@name', if(length(term) > 60, concat(left(term, 57), '...'), term),
           '@description', term,
           '@code_scheme', 'READ2',
           '@code', code,
           '@is_subtype_of', JSON_OBJECT(
               '@id','@codeable_concept'
               )
           )
FROM read_v2;

-- ATTRIBUTES

CREATE TABLE read_v2_hierarchy
SELECT r.code AS code, @code:=REPLACE(r.code,'.','') AS code_trimmed, @parent:=RPAD(SUBSTRING(@code, 1, LENGTH(@code)-1), 5, '.') AS parent
FROM read_v2 r;

UPDATE concept c
    INNER JOIN (
        SELECT id, JSON_OBJECTAGG(prop, val) as rel
        FROM
            (SELECT concat('R2-', rel.code) as id, '@has_parent' as prop,
                    JSON_ARRAYAGG(
                        JSON_OBJECT(
                            '@id', concat('R2-', rel.parent)
                            )
                        ) as val
             FROM read_v2_hierarchy rel
             GROUP BY rel.code) t1
        GROUP BY id) t2
    ON t2.id = c.id
SET data=JSON_MERGE(c.data, t2.rel);
