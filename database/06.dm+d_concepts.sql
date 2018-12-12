-- ********************* VIRTUAL THERAPEUTIC MOIETY *********************

-- Create concepts
INSERT INTO concept
(superclass, short_name, full_name, context, status, version, last_update, code_scheme, code)
SELECT
    5320, v.abbrevnm, v.nm, concat('DM+D.',v.vtmid), 1, 1.0, now(), 5306, vtmid
FROM dmd_vtm v
WHERE v.invalid IS NULL;

-- ********************* VIRTUAL MEDICINAL PRODUCTS *********************
-- Create concepts
INSERT INTO concept
    (superclass, short_name, full_name, context, status, version, last_update, code_scheme, code)
SELECT
    5326, v.abbrevnm, v.nm, concat('DM+D.',v.vpid), 1, 1.0, now(), 5306, vpid
FROM dmd_vmp v
WHERE v.invalid IS NULL;

-- Set relationships
INSERT INTO im2.concept_attribute
    (concept, attribute, value_concept)
SELECT s.id AS source, 110, t.id AS target
FROM dmd_vmp v
         JOIN concept s ON s.code = v.vpid AND s.code_scheme = 5306
         JOIN concept t ON t.code = v.vtmid AND t.code_scheme = 5306
WHERE v.vtmid IS NOT NULL
AND v.invalid IS NULL;

-- ********************* VIRTUAL MEDICINAL PRODUCT PACKS *********************
-- Create concepts
INSERT INTO concept
(superclass, short_name, full_name, context, status, version, last_update, code_scheme, code)
SELECT
     5333, v.abbrevnm, v.nm, concat('DM+D.',v.vppid), 1, 1.0, now(), 5306, vppid
FROM  dmd_vmpp v
WHERE v.invalid IS NULL;

-- Reset relationships
INSERT INTO im2.concept_attribute
    (concept, attribute, value_concept)
SELECT s.id, 112, t.id
FROM dmd_vmpp a
         JOIN concept s ON s.code = a.vppid AND s.code_scheme = 5306
         JOIN concept t ON t.code = a.vpid AND t.code_scheme = 5306
WHERE a.invalid IS NULL;

-- ********************* ACTUAL MEDICINAL PRODUCTS *********************
-- Create concepts
INSERT INTO concept
    (superclass, short_name, full_name, description, context, status, version, last_update, code_scheme, code)
SELECT
       5330, v.abbrevnm, v.nm, v.`desc`, concat('DM+D.',v.apid), 1, 1.0, now(), 5306, apid
FROM  dmd_amp v
WHERE v.invalid IS NULL;

-- Reset relationships
INSERT INTO im2.concept_attribute
    (concept, attribute, value_concept)
SELECT s.id, 111, t.id
FROM dmd_amp a
         JOIN concept s ON s.code = a.apid AND s.code_scheme = 5306
         JOIN concept t ON t.code = a.vpid AND t.code_scheme = 5306
WHERE a.invalid IS NULL;

-- ********************* ACTUAL MEDICINAL PRODUCT PACKS *********************
-- Create concepts
INSERT INTO concept
    (superclass, short_name, full_name, context, status, version, last_update, code_scheme, code)
SELECT
       5339, v.abbrevnm, v.nm, concat('DM+D.',v.appid), 1, 1.0, now(), 5306, appid
FROM dmd_ampp v
WHERE v.invalid IS NULL;

-- Reset relationships
INSERT INTO im2.concept_attribute
    (concept, attribute, value_concept)
SELECT s.id, 111, t.id
FROM dmd_ampp a
         JOIN concept s ON s.code = a.appid AND s.code_scheme = 5306
         JOIN concept t ON t.code = a.vppid AND t.code_scheme = 5306
WHERE a.invalid IS NULL;

INSERT INTO im2.concept_attribute
    (concept, attribute, value_concept)
SELECT s.id, 112, t.id
FROM dmd_ampp a
         JOIN concept s ON s.code = a.appid AND s.code_scheme = 5306
         JOIN concept t ON t.code = a.apid AND t.code_scheme = 5306
WHERE a.invalid IS NULL;

-- ********************* VIRTUAL PRODUCT INGREDIENT *********************
INSERT INTO im2.concept_attribute
    (concept, attribute, value_concept)
SELECT p.id as source, 113 as relationship, i.id as target
FROM dmd_vmp_vpi m
         JOIN concept p ON p.code = m.vpid AND p.code_scheme = 5306
         JOIN concept i ON i.code = m.isid AND i.code_scheme = 5306;