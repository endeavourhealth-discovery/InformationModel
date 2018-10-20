-- ********************* VIRTUAL THERAPEUTIC MOIETY *********************
DROP TABLE IF EXISTS dmd_vtm_concept_map;
CREATE TABLE dmd_vtm_concept_map (
    vtmId BIGINT NOT NULL,
    conceptId BIGINT,
    new BOOLEAN,

    PRIMARY KEY dmd_vtm_concept_map_vtmId (vtmId)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Existing (SNOMED) dmd/vtm entries
INSERT INTO dmd_vtm_concept_map
    (vtmid, conceptId, new)
SELECT vtmid, concept_id, false
FROM dmd_vtm v
         LEFT OUTER JOIN im.code c ON c.system = 1 AND c.code_id = v.vtmid;

-- Count and allocate new entries
SET @noconcept = (SELECT Count(*)
                  FROM dmd_vtm_concept_map
                  WHERE conceptId is null);

SET @conceptId = (SELECT id FROM table_id WHERE name='Concept');

UPDATE table_id SET id = @conceptId + @noconcept WHERE name = 'Concept';

-- Map and mark as new
UPDATE dmd_vtm_concept_map AS m
INNER JOIN (
           SELECT vtmid, (@conceptId := @conceptId + 1) as conceptId
           FROM dmd_vtm_concept_map
           WHERE conceptId is null) AS x ON m.vtmId = x.vtmId
SET m.conceptId = x.conceptId, new = true;

-- Create concepts
INSERT INTO concept
    (id, superclass, short_name, full_name, context, status, version, last_update)
SELECT
       m.conceptId, 2, v.abbrevnm, v.nm, concat('DM+D.',m.vtmId), ifnull(v.invalid, 0) + 1, 1.0, now()
FROM dmd_vtm_concept_map m
         JOIN dmd_vtm v on v.vtmid = m.vtmId
WHERE m.new = true;

-- ********************* VIRTUAL MEDICINAL PRODUCTS *********************
DROP TABLE IF EXISTS dmd_vmp_concept_map;
CREATE TABLE dmd_vmp_concept_map (
    vmpId BIGINT NOT NULL,
    conceptId BIGINT,
    new BOOLEAN,

    PRIMARY KEY dmd_vmp_concept_map_vmpId (vmpId)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Existing (SNOMED) dmd/vmp entries
INSERT INTO dmd_vmp_concept_map
    (vmpid, conceptId, new)
SELECT vpid, concept_id, false
FROM dmd_vmp v
LEFT OUTER JOIN im.code c ON c.system = 1 AND c.code_id = v.vpid;

-- Count and allocate new entries
SET @noconcept = (SELECT Count(*)
FROM dmd_vmp_concept_map
WHERE conceptId is null);

SET @conceptId = (SELECT id FROM table_id WHERE name='Concept');

UPDATE table_id SET id = @conceptId + @noconcept WHERE name = 'Concept';

-- Map and mark as new
UPDATE dmd_vmp_concept_map AS m
INNER JOIN (
    SELECT vmpid, (@conceptId := @conceptId + 1) as conceptId
    FROM dmd_vmp_concept_map
    WHERE conceptId is null) AS x ON m.vmpId = x.vmpId
SET m.conceptId = x.conceptId, new = true;

-- Create concepts
INSERT INTO concept
    (id, superclass, short_name, full_name, context, status, version, last_update)
SELECT
       m.conceptId, 2, v.abbrevnm, v.nm, concat('DM+D.',m.vmpId), ifnull(v.invalid, 0) + 1, 1.0, now()
FROM dmd_vmp_concept_map m
         JOIN dmd_vmp v on v.vpid = m.vmpId
WHERE m.new = true;

-- Reset relationships
INSERT INTO concept_relationship
    (source, relationship, target)
SELECT s.conceptId AS source, 107 AS relationship, t.conceptId AS target
FROM dmd_vmp v
         JOIN dmd_vmp_concept_map s ON s.vmpId = v.vpid
         JOIN dmd_vtm_concept_map t ON t.vtmId = v.vtmid
WHERE v.vtmid IS NOT NULL;

/*REPLACE INTO concept_relationship
    (source, relationship, target)
SELECT
    conceptId, 100, 5038
FROM
     dmd_vmp_concept_map;*/

-- ********************* VIRTUAL MEDICINAL PRODUCT PACKS *********************
DROP TABLE IF EXISTS dmd_vmpp_concept_map;
CREATE TABLE dmd_vmpp_concept_map (
    vmppId BIGINT NOT NULL,
    conceptId BIGINT,
    new BOOLEAN,

    PRIMARY KEY dmd_vmpp_concept_map_vmppId (vmppId)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO dmd_vmpp_concept_map
    (vmppId, conceptId, new)
SELECT
    vppId, null, false
FROM dmd_vmpp;

-- Count and allocate new entries
SET @noconcept = (SELECT Count(*)
                  FROM dmd_vmpp_concept_map
                  WHERE conceptId is null);

SET @conceptId = (SELECT id FROM table_id WHERE name='Concept');

UPDATE table_id SET id = @conceptId + @noconcept WHERE name = 'Concept';

-- Map and mark as new
UPDATE dmd_vmpp_concept_map AS m
INNER JOIN (
           SELECT vmppid, (@conceptId := @conceptId + 1) as conceptId
           FROM dmd_vmpp_concept_map
           WHERE conceptId is null) AS x ON m.vmppId = x.vmppId
SET m.conceptId = x.conceptId, new = true;

-- Create concepts
INSERT INTO concept
    (id, superclass, short_name, full_name, context, status, version, last_update)
SELECT
       m.conceptId, 2, v.abbrevnm, v.nm, concat('DM+D.',m.vmppId), ifnull(v.invalid, 0) + 1, 1.0, now()
FROM dmd_vmpp_concept_map m
         JOIN dmd_vmpp v on v.vppid = m.vmppId
WHERE m.new = true;

-- Reset relationships
INSERT INTO concept_relationship
    (source, relationship, target)
SELECT s.conceptId, 106, t.conceptId
FROM dmd_vmpp a
         JOIN dmd_vmpp_concept_map s ON s.vmppId = a.vppid
         JOIN dmd_vmp_concept_map t ON t.vmpId = a.vpid;
/*REPLACE INTO concept_relationship
    (source, relationship, target)
SELECT
       conceptId, 100, 5045
FROM
     dmd_vmpp_concept_map;*/

-- ********************* ACTUAL MEDICINAL PRODUCTS *********************
DROP TABLE IF EXISTS dmd_amp_concept_map;
CREATE TABLE dmd_amp_concept_map (
    ampId BIGINT NOT NULL,
    conceptId BIGINT,
    new BOOLEAN,

    PRIMARY KEY dmd_amp_concept_map_ampId (ampId)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Existing (SNOMED) dmd/amp entries
INSERT INTO dmd_amp_concept_map
    (ampid, conceptId, new)
SELECT apid, concept_id, false
FROM dmd_amp v
         LEFT OUTER JOIN im.code c ON c.system = 1 AND c.code_id = v.apid;

-- Count and allocate new entries
SET @noconcept = (SELECT Count(*)
                  FROM dmd_amp_concept_map
                  WHERE conceptId is null);

SET @conceptId = (SELECT id FROM table_id WHERE name='Concept');

UPDATE table_id SET id = @conceptId + @noconcept WHERE name = 'Concept';

-- Map and mark as new
UPDATE dmd_amp_concept_map AS m
INNER JOIN (
           SELECT ampid, (@conceptId := @conceptId + 1) as conceptId
           FROM dmd_amp_concept_map
           WHERE conceptId is null) AS x ON m.ampId = x.ampId
SET m.conceptId = x.conceptId, new = true;

-- Create concepts
INSERT INTO concept
    (id, superclass, short_name, full_name, description, context, status, version, last_update)
SELECT
       m.conceptId, 2, v.abbrevnm, v.nm, v.`desc`, concat('DM+D.',m.ampId), ifnull(v.invalid, 0) + 1, 1.0, now()
FROM dmd_amp_concept_map m
         JOIN dmd_amp v on v.apid = m.ampId
WHERE m.new = true;

-- Reset relationships
INSERT INTO concept_relationship
    (source, relationship, target)
SELECT s.conceptId, 105, t.conceptId
FROM dmd_amp a
         JOIN dmd_amp_concept_map s ON s.ampId = a.apid
         JOIN dmd_vmp_concept_map t ON t.vmpId = a.vpid;

/*REPLACE INTO concept_relationship
    (source, relationship, target)
SELECT
       conceptId, 100, 5038
FROM
     dmd_vmp_concept_map;
*/
-- ********************* ACTUAL MEDICINAL PRODUCT PACKS *********************
DROP TABLE IF EXISTS dmd_ampp_concept_map;
CREATE TABLE dmd_ampp_concept_map (
    amppId BIGINT NOT NULL,
    conceptId BIGINT,
    new BOOLEAN,

    PRIMARY KEY dmd_ampp_concept_map_amppId (amppId)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO dmd_ampp_concept_map
    (amppId, conceptId, new)
SELECT
       appId, null, false
FROM dmd_ampp;

-- Count and allocate new entries
SET @noconcept = (SELECT Count(*)
                  FROM dmd_ampp_concept_map
                  WHERE conceptId is null);

SET @conceptId = (SELECT id FROM table_id WHERE name='Concept');

UPDATE table_id SET id = @conceptId + @noconcept WHERE name = 'Concept';

-- Map and mark as new
UPDATE dmd_ampp_concept_map AS m
INNER JOIN (
           SELECT amppid, (@conceptId := @conceptId + 1) as conceptId
           FROM dmd_ampp_concept_map
           WHERE conceptId is null) AS x ON m.amppId = x.amppId
SET m.conceptId = x.conceptId, new = true;

-- Create concepts
INSERT INTO concept
    (id, superclass, short_name, full_name, context, status, version, last_update)
SELECT
       m.conceptId, 2, v.abbrevnm, v.nm, concat('DM+D.',m.amppId), ifnull(v.invalid, 0) + 1, 1.0, now()
FROM dmd_ampp_concept_map m
         JOIN dmd_ampp v on v.appid = m.amppId
WHERE m.new = true;

-- Reset relationships
INSERT INTO concept_relationship
    (source, relationship, target)
SELECT s.conceptId, 105, t.conceptId
FROM dmd_ampp a
         JOIN dmd_ampp_concept_map s ON s.amppId = a.appid
         JOIN dmd_vmpp_concept_map t ON t.vmppId = a.vppid;

INSERT INTO concept_relationship
    (source, relationship, target)
SELECT s.conceptId, 106, t.conceptId
FROM dmd_ampp a
         JOIN dmd_ampp_concept_map s ON s.amppId = a.appid
         JOIN dmd_amp_concept_map t ON t.ampId = a.apid;

/*REPLACE INTO concept_relationship
    (source, relationship, target)
SELECT
       conceptId, 100, 5045
FROM
     dmd_vmpp_concept_map;
*/

-- ********************* VIRTUAL PRODUCT INGREDIENT *********************
INSERT INTO concept_relationship
    (source, relationship, target)
SELECT p.conceptId as source, 108 as relationship, i.concept_id as target
FROM dmd_vmp_vpi m
         JOIN dmd_vmp_concept_map p ON p.vmpId = m.vpid
         JOIN im.code i ON i.code_id = m.isid AND i.system = 1;

-- ********************* GENERAL SNOMED <--> CONCEPT MAP *********************
REPLACE INTO mapping_code
    (scheme, code_id, concept)
SELECT (5031, vtmId, conceptId)
FROM dmd_vtm_concept_map;

REPLACE INTO mapping_code
    (scheme, code_id, concept)
SELECT (5031, vmpId, conceptId)
FROM dmd_vmp_concept_map;

REPLACE INTO mapping_code
    (scheme, code_id, concept)
SELECT (5031, vmppId, conceptId)
FROM dmd_vmpp_concept_map;

REPLACE INTO mapping_code
    (scheme, code_id, concept)
SELECT (5031, ampId, conceptId)
FROM dmd_amp_concept_map;

REPLACE INTO mapping_code
    (scheme, code_id, concept)
SELECT (5031, amppId, conceptId)
FROM dmd_ampp_concept_map;
