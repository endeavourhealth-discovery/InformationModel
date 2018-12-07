-- ********************* DM+D STRUCTURE DEFINITION *********************

-- ********** DM+D **********
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
(5320, 2, 'DM+D.VTM',  'Virtual therapeutic moiety', ''),
(5321, 1, 'DM+D.VPI',  'Virtual product ingredient', ''),
(5322, 1, 'DM+D.CDPI', 'Controlled drug prescribing information', ''),
(5323, 1, 'DM+D.DRI',  'Drug route information', ''),
(5324, 1, 'DM+D.ODRI', 'Ontology drug form & route info', ''),
(5325, 1, 'DM+D.DFI',  'Dose form information', ''),
(5326, 2, 'DM+D.VMP',  'Virtual medicinal product', ''),
(5327, 1, 'DM+D.APE',  'Actual product excipient', ''),
(5328, 1, 'DM+D.APrI', 'Appliance product information', ''),
(5329, 1, 'DM+D.LR',   'Licensed route', ''),
(5330, 2, 'DM+D.AMP',  'Actual medicinal product', ''),
(5331, 1, 'DM+D.VCPC', 'Virtual combination pack content', ''),
(5332, 1, 'DM+D.DTCI', 'Drug tariff category info', ''),
(5333, 2, 'DM+D.VMPP', 'Virtual medicinal product pack', ''),
(5334, 1, 'DM+D.PPI',  'Product prescribing info', ''),
(5335, 1, 'DM+D.APkI', 'Appliance pack info', ''),
(5336, 1, 'DM+D.RI',   'Reimbursement info', ''),
(5337, 1, 'DM+D.MPP',  'Medicinal product price', ''),
(5338, 1, 'DM+D.ACPC', 'Actual combination pack content', ''),
(5339, 2, 'DM+D.AMPP', 'Actual medicinal product pack', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
(5326, 5320, 0, 0, 1),   -- VMP  -- (0:1) --> VTM
(5326, 5321, 1, 0, 0),   -- VMP  -- (0:*) --> VPI
(5326, 5322, 2, 0, 1),   -- VMP  -- (0:1) --> CDPI
(5326, 5323, 3, 0, 0),   -- VMP  -- (0:*) --> DRI
(5326, 5324, 4, 0, 0),   -- VMP  -- (0:*) --> ODRI
(5326, 5325, 5, 0, 1),   -- VMP  -- (0:1) --> DFI

(5330, 5327, 0, 0, 0),   -- AMP  -- (0:*) --> APE
(5330, 5328, 1, 0, 1),   -- AMP  -- (0:1) --> APrI
(5330, 5329, 2, 0, 0),   -- AMP  -- (0:*) --> LR

(5333, 5331, 0, 0, 0),   -- VMPP -- (0:*) --> VCPC
(5333, 5332, 1, 0, 1),   -- VMPP -- (0:1) --> DTCI

(5339, 5334, 0, 0, 1),   -- AMPP -- (0:1) --> PPI
(5339, 5335, 1, 0, 1),   -- AMPP -- (0:1) --> APkI
(5339, 5336, 2, 0, 1),   -- AMPP -- (0:1) --> RI
(5339, 5337, 3, 0, 1),   -- AMPP -- (0:1) --> MPP
(5339, 5338, 4, 0, 0);   -- AMPP -- (0:*) --> ACPC

INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`, inheritance, value_concept, value_expression)
    VALUE
    (5330, 111, 3, 1, 1, 0, 5326, 0),
    (5333, 112, 2, 1, 1, 0, 5326, 0),
    (5339, 111, 5, 1, 1, 0, 5333, 0),
    (5339, 112, 6, 1, 1, 0, 5330, 0);

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