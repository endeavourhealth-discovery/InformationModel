-- Reset auto-increment

SELECT @max := MAX(dbid)+ 1 FROM concept;
SET @qry = concat('ALTER TABLE concept AUTO_INCREMENT = ', @max);
PREPARE stmt FROM @qry;
EXECUTE stmt;


-- ********************* DM+D NAMESPACE *********************
INSERT INTO document
(data)
VALUES
(JSON_OBJECT('@document', 'http/DiscoveryDataService/InformationModel/dm/DMD/1.0.1'));

-- ********************* VIRTUAL THERAPEUTIC MOIETY *********************

-- Create concepts
INSERT INTO concept (data)
SELECT JSON_OBJECT(
           '@document', 'http/DiscoveryDataService/InformationModel/dm/DMD/1.0.1',
           '@id', concat('DMD-',v.vtmid),
           '@name', ifnull(v.abbrevnm, if(length(v.nm) > 60, concat(left(v.nm, 57), '...'), v.nm)),
           '@description', v.nm,
           '@code_scheme', 'DM+D',
           '@code', v.vtmid,
           '@is_subtype_of', JSON_OBJECT(
               '@id','@vtm'
               )
           )
FROM dmd_vtm v
WHERE v.invalid IS NULL;

-- ********************* VIRTUAL MEDICINAL PRODUCTS *********************
EXECUTE stmt;

-- Create concepts
INSERT INTO concept (data)
SELECT JSON_OBJECT(
           '@document', 'http/DiscoveryDataService/InformationModel/dm/DMD/1.0.1',
           '@id', concat('DMD-',v.vpid),
           '@name', ifnull(v.abbrevnm, if(length(v.nm) > 60, concat(left(v.nm, 57), '...'), v.nm)),
           '@description', v.nm,
           '@code_scheme', 'DM+D',
           '@code', v.vpid,
           '@is_subtype_of', JSON_OBJECT(
               '@id','@vmp'
               )
           )
FROM dmd_vmp v
WHERE v.invalid IS NULL;

-- Set relationships
UPDATE concept c
    INNER JOIN (
        SELECT id, JSON_OBJECTAGG(prop, val) as rel
        FROM
            (SELECT concat('DMD-', rel.vpid) as id, '@has_moiety' as prop,
                    JSON_ARRAYAGG(
                        JSON_OBJECT(
                            '@id', concat('DMD-', rel.vtmid)
                            )
                        ) as val
             FROM dmd_vmp rel
            WHERE rel.vtmid IS NOT NULL
            AND rel.invalid IS NULL
             GROUP BY rel.vpid) t1
        GROUP BY id) t2
    ON t2.id = c.id
SET data=JSON_MERGE(c.data, t2.rel);

-- ********************* VIRTUAL MEDICINAL PRODUCT PACKS *********************
EXECUTE stmt;

-- Create concepts
INSERT INTO concept (data)
SELECT JSON_OBJECT(
           '@document', 'http/DiscoveryDataService/InformationModel/dm/DMD/1.0.1',
           '@id', concat('DMD-',v.vppid),
           '@name', ifnull(v.abbrevnm, if(length(v.nm) > 60, concat(left(v.nm, 57), '...'), v.nm)),
           '@description', v.nm,
           '@code_scheme', 'DM+D',
           '@code', v.vppid,
           '@is_subtype_of', JSON_OBJECT(
               '@id','@vmpp'
               )
           )
FROM dmd_vmpp v
WHERE v.invalid IS NULL;


-- Reset relationships
UPDATE concept c
    INNER JOIN (
        SELECT id, JSON_OBJECTAGG(prop, val) as rel
        FROM
            (SELECT concat('DMD-', rel.vppid) as id, '@is_pack_of' as prop,
                    JSON_ARRAYAGG(
                        JSON_OBJECT(
                            '@id', concat('DMD-', rel.vpid)
                            )
                        ) as val
             FROM dmd_vmpp rel
             WHERE rel.invalid IS NULL
             GROUP BY rel.vppid) t1
        GROUP BY id) t2
    ON t2.id = c.id
SET data=JSON_MERGE(c.data, t2.rel);

-- ********************* ACTUAL MEDICINAL PRODUCTS *********************
EXECUTE stmt;

-- Create concepts
INSERT INTO concept (data)
SELECT JSON_OBJECT(
           '@document', 'http/DiscoveryDataService/InformationModel/dm/DMD/1.0.1',
           '@id', concat('DMD-',v.apid),
           '@name', ifnull(v.abbrevnm, if(length(v.nm) > 60, concat(left(v.nm, 57), '...'), v.nm)),
           '@description', v.nm,
           '@code_scheme', 'DM+D',
           '@code', v.apid,
           '@is_subtype_of', JSON_OBJECT(
               '@id','@amp'
               )
           )
FROM dmd_amp v
WHERE v.invalid IS NULL;

-- Reset relationships
UPDATE concept c
    INNER JOIN (
        SELECT id, JSON_OBJECTAGG(prop, val) as rel
        FROM
            (SELECT concat('DMD-', rel.apid) as id, '@is_branded' as prop,
                    JSON_ARRAYAGG(
                        JSON_OBJECT(
                            '@id', concat('DMD-', rel.vpid)
                            )
                        ) as val
             FROM dmd_amp rel
             WHERE rel.invalid IS NULL
             GROUP BY rel.apid) t1
        GROUP BY id) t2
    ON t2.id = c.id
SET data=JSON_MERGE(c.data, t2.rel);

-- ********************* ACTUAL MEDICINAL PRODUCT PACKS *********************
EXECUTE stmt;

-- Create concepts
INSERT INTO concept (data)
SELECT JSON_OBJECT(
           '@document', 'http/DiscoveryDataService/InformationModel/dm/DMD/1.0.1',
           '@id', concat('DMD-',v.appid),
           '@name', ifnull(v.abbrevnm, if(length(v.nm) > 60, concat(left(v.nm, 57), '...'), v.nm)),
           '@description', v.nm,
           '@code_scheme', 'DM+D',
           '@code', v.appid,
           '@is_subtype_of', JSON_OBJECT(
               '@id','@ampp'
               )
           )
FROM dmd_ampp v
WHERE v.invalid IS NULL;

-- Reset relationships
UPDATE concept c
    INNER JOIN (
        SELECT id, JSON_OBJECTAGG(prop, val) as rel
        FROM
            (SELECT concat('DMD-', rel.appid) as id, '@is_branded' as prop,
                    JSON_ARRAYAGG(
                        JSON_OBJECT(
                            '@id', concat('DMD-', rel.vppid)
                            )
                        ) as val
             FROM dmd_ampp rel
             WHERE rel.invalid IS NULL
             GROUP BY rel.appid) t1
        GROUP BY id) t2
    ON t2.id = c.id
SET data=JSON_MERGE(c.data, t2.rel);


UPDATE concept c
    INNER JOIN (
        SELECT id, JSON_OBJECTAGG(prop, val) as rel
        FROM
            (SELECT concat('DMD-', rel.appid) as id, '@is_pack_of' as prop,
                    JSON_ARRAYAGG(
                        JSON_OBJECT(
                            '@id', concat('DMD-', rel.apid)
                            )
                        ) as val
             FROM dmd_ampp rel
             WHERE rel.invalid IS NULL
             GROUP BY rel.appid) t1
        GROUP BY id) t2
    ON t2.id = c.id
SET data=JSON_MERGE(c.data, t2.rel);


-- ********************* VIRTUAL PRODUCT INGREDIENT *********************
UPDATE concept c
    INNER JOIN (
        SELECT id, JSON_OBJECTAGG(prop, val) as rel
        FROM
            (SELECT concat('DMD-', rel.vpid) as id, '@has_ingredient' as prop,
                    JSON_ARRAYAGG(
                        JSON_OBJECT(
                            '@id', concat('DMD-', rel.isid)
                            )
                        ) as val
             FROM dmd_vmp_vpi rel
             GROUP BY rel.vpid) t1
        GROUP BY id) t2
    ON t2.id = c.id
SET data=JSON_MERGE(c.data, t2.rel);


DEALLOCATE PREPARE stmt;
