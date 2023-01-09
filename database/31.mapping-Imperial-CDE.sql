-- ****************************************************
-- ** REQUIRES
-- **   - FHIR/Language
-- **   - NHSDD/Religion
-- **   - NHSDD/Speciality
-- **   - NHSDD/Inpatient
-- **   - NHSDD/Ethnicity
-- ****************************************************

-- Ensure core code scheme exists
INSERT IGNORE INTO concept (document, id, name, description)
VALUES (1, 'CM_DiscoveryCode', 'Discovery code', 'Discovery (core) coding scheme ');

-- Get scheme id
SELECT @scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';

-- Code scheme prefix entries
INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
-- GENERAL/GLOBAL --
(1, 'CM_Org_Imperial', @scm, 'CM_Org_Imperial', 'Imperial College', 'Imperial College Hospital, London'),
(1, 'CM_Sys_Cerner', @scm, 'CM_Sys_Cerner', 'Cerner Millennium', 'Cerner Millennium system'),
(1, 'ImperialCerner', @scm, 'ImperialCerner', 'Imperial Local Codes', 'Imperial Cerner local code scheme');

INSERT IGNORE INTO concept_property_data
(`dbid`, `group`, `property`, `value`)
SELECT c.dbid, 0 AS `group`, p.dbid AS `property`, 'IC_' AS `value`
FROM concept c
         JOIN concept p ON p.id = 'code_prefix'
WHERE c.id = 'ImperialCerner';

-- ******************** Religion ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Imperial', 'CM_Sys_Cerner', 'CDE', null, 'religion', '/IMPRL/CRNR/CDE/RLGN');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/IMPRL/CRNR/CDE/RLGN', 'DM_religion');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/IMPRL/CRNR/CDE/RLGN', '9032344', 'ImperialCerner', 'CM_ReligionD1'),
('/IMPRL/CRNR/CDE/RLGN', '9032356', 'ImperialCerner', 'CM_ReligionK20'),
('/IMPRL/CRNR/CDE/RLGN', '9032384', 'ImperialCerner', 'CM_ReligionI1'),
('/IMPRL/CRNR/CDE/RLGN', '13695225', 'ImperialCerner', 'CM_ReligionA1'),
('/IMPRL/CRNR/CDE/RLGN', '9032340', 'ImperialCerner', 'CM_ReligionB1'),
('/IMPRL/CRNR/CDE/RLGN', '9032378', 'ImperialCerner', 'CM_ReligionC1'),
('/IMPRL/CRNR/CDE/RLGN', '13695243', 'ImperialCerner', 'CM_ReligionM1'),
('/IMPRL/CRNR/CDE/RLGN', '13695231', 'ImperialCerner', 'CM_ReligionE1'),
('/IMPRL/CRNR/CDE/RLGN', '9032358', 'ImperialCerner', 'CM_ReligionF1'),
('/IMPRL/CRNR/CDE/RLGN', '9032352', 'ImperialCerner', 'CM_ReligionG1'),
('/IMPRL/CRNR/CDE/RLGN', '13695240', 'ImperialCerner', 'CM_ReligionL2'),
('/IMPRL/CRNR/CDE/RLGN', '13695235', 'ImperialCerner', 'CM_ReligionH1'),
('/IMPRL/CRNR/CDE/RLGN', '13695245', 'ImperialCerner', 'CM_ReligionN1'),
('/IMPRL/CRNR/CDE/RLGN', '13695237', 'ImperialCerner', 'CM_ReligionJ1'),
('/IMPRL/CRNR/CDE/RLGN', '9032360', 'ImperialCerner', 'CM_ReligionC59'),
('/IMPRL/CRNR/CDE/RLGN', '9032370', 'ImperialCerner', 'CM_ReligionC41'),
('/IMPRL/CRNR/CDE/RLGN', '9032372', 'ImperialCerner', 'CM_ReligionC58');

-- ******************** Ethnicity ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Imperial', 'CM_Sys_Cerner', 'CDE', null, 'ethnicity', '/IMPRL/CRNR/CDE/ETHNC_CTGRY');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/IMPRL/CRNR/CDE/ETHNC_CTGRY', 'DM_religion');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
    ('/IMPRL/CRNR/CDE/ETHNC_CTGRY', '9031553', 'ImperialCerner', 'CM_EthnicityL'),
    ('/IMPRL/CRNR/CDE/ETHNC_CTGRY', '9031539', 'ImperialCerner', 'CM_EthnicityK'),
    ('/IMPRL/CRNR/CDE/ETHNC_CTGRY', '9031547', 'ImperialCerner', 'CM_EthnicityH'),
    ('/IMPRL/CRNR/CDE/ETHNC_CTGRY', '9031561', 'ImperialCerner', 'CM_EthnicityJ'),
    ('/IMPRL/CRNR/CDE/ETHNC_CTGRY', '9031555', 'ImperialCerner', 'CM_EthnicityP'),
    ('/IMPRL/CRNR/CDE/ETHNC_CTGRY', '9031535', 'ImperialCerner', 'CM_EthnicityN'),
    ('/IMPRL/CRNR/CDE/ETHNC_CTGRY', '9031541', 'ImperialCerner', 'CM_EthnicityM'),
    ('/IMPRL/CRNR/CDE/ETHNC_CTGRY', '9031557', 'ImperialCerner', 'CM_EthnicityG'),
    ('/IMPRL/CRNR/CDE/ETHNC_CTGRY', '9031563', 'ImperialCerner', 'CM_EthnicityF'),
    ('/IMPRL/CRNR/CDE/ETHNC_CTGRY', '9031565', 'ImperialCerner', 'CM_EthnicityE'),
    ('/IMPRL/CRNR/CDE/ETHNC_CTGRY', '9031567', 'ImperialCerner', 'CM_EthnicityD'),
    ('/IMPRL/CRNR/CDE/ETHNC_CTGRY', '9031551', 'ImperialCerner', 'CM_EthnicityZ'),
    ('/IMPRL/CRNR/CDE/ETHNC_CTGRY', '9031537', 'ImperialCerner', 'CM_EthnicityS'),
    ('/IMPRL/CRNR/CDE/ETHNC_CTGRY', '9031543', 'ImperialCerner', 'CM_EthnicityR'),
    ('/IMPRL/CRNR/CDE/ETHNC_CTGRY', '9031533', 'ImperialCerner', 'CM_Ethnicity99'),
    ('/IMPRL/CRNR/CDE/ETHNC_CTGRY', '9031559', 'ImperialCerner', 'CM_EthnicityC'),
    ('/IMPRL/CRNR/CDE/ETHNC_CTGRY', '9031545', 'ImperialCerner', 'CM_EthnicityA'),
    ('/IMPRL/CRNR/CDE/ETHNC_CTGRY', '9031549', 'ImperialCerner', 'CM_EthnicityB');

-- ******************** Treatment Function ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Imperial', 'CM_Sys_Cerner', 'CDE', null, 'treatment_function_code', '/IMPRL/CRNR/CDE/TRTMNT_FNCTN');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', 'DM_treatmentFunctionAdmit');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031593', 'ImperialCerner', 'CM_TrtmntFnc100'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031595', 'ImperialCerner', 'CM_TrtmntFnc101'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031637', 'ImperialCerner', 'CM_TrtmntFnc102'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031758', 'ImperialCerner', 'CM_TrtmntFnc103'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031633', 'ImperialCerner', 'CM_TrtmntFnc104'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031732', 'ImperialCerner', 'CM_TrtmntFnc105'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031627', 'ImperialCerner', 'CM_TrtmntFnc106'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031639', 'ImperialCerner', 'CM_TrtmntFnc107'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '13835857', 'ImperialCerner', 'CM_TrtmntFnc108'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031720', 'ImperialCerner', 'CM_TrtmntFnc110'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031591', 'ImperialCerner', 'CM_TrtmntFnc120'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031575', 'ImperialCerner', 'CM_TrtmntFnc130'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031615', 'ImperialCerner', 'CM_TrtmntFnc140'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031617', 'ImperialCerner', 'CM_TrtmntFnc141'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031597', 'ImperialCerner', 'CM_TrtmntFnc142'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031708', 'ImperialCerner', 'CM_TrtmntFnc143'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031585', 'ImperialCerner', 'CM_TrtmntFnc144'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031710', 'ImperialCerner', 'CM_TrtmntFnc150'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031599', 'ImperialCerner', 'CM_TrtmntFnc160'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031629', 'ImperialCerner', 'CM_TrtmntFnc161'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031571', 'ImperialCerner', 'CM_TrtmntFnc170'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031603', 'ImperialCerner', 'CM_TrtmntFnc171'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031631', 'ImperialCerner', 'CM_TrtmntFnc172'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031635', 'ImperialCerner', 'CM_TrtmntFnc173'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031728', 'ImperialCerner', 'CM_TrtmntFnc174'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031706', 'ImperialCerner', 'CM_TrtmntFnc180'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031806', 'ImperialCerner', 'CM_TrtmntFnc190'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031605', 'ImperialCerner', 'CM_TrtmntFnc191'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031583', 'ImperialCerner', 'CM_TrtmntFnc192'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031808', 'ImperialCerner', 'CM_TrtmntFnc211'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031810', 'ImperialCerner', 'CM_TrtmntFnc212'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031812', 'ImperialCerner', 'CM_TrtmntFnc213'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031814', 'ImperialCerner', 'CM_TrtmntFnc214'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031816', 'ImperialCerner', 'CM_TrtmntFnc215'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031818', 'ImperialCerner', 'CM_TrtmntFnc216'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031820', 'ImperialCerner', 'CM_TrtmntFnc217'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031766', 'ImperialCerner', 'CM_TrtmntFnc218'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031796', 'ImperialCerner', 'CM_TrtmntFnc219'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031736', 'ImperialCerner', 'CM_TrtmntFnc220'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031794', 'ImperialCerner', 'CM_TrtmntFnc221'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031792', 'ImperialCerner', 'CM_TrtmntFnc222'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '13835845', 'ImperialCerner', 'CM_TrtmntFnc223'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031798', 'ImperialCerner', 'CM_TrtmntFnc241'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031786', 'ImperialCerner', 'CM_TrtmntFnc242'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031800', 'ImperialCerner', 'CM_TrtmntFnc251'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031790', 'ImperialCerner', 'CM_TrtmntFnc252'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031784', 'ImperialCerner', 'CM_TrtmntFnc253'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031774', 'ImperialCerner', 'CM_TrtmntFnc254'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031788', 'ImperialCerner', 'CM_TrtmntFnc255'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031776', 'ImperialCerner', 'CM_TrtmntFnc256'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031764', 'ImperialCerner', 'CM_TrtmntFnc257'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031738', 'ImperialCerner', 'CM_TrtmntFnc258'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031770', 'ImperialCerner', 'CM_TrtmntFnc259'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031742', 'ImperialCerner', 'CM_TrtmntFnc260'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031768', 'ImperialCerner', 'CM_TrtmntFnc261'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031772', 'ImperialCerner', 'CM_TrtmntFnc262'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '12124528', 'ImperialCerner', 'CM_TrtmntFnc263'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031868', 'ImperialCerner', 'CM_TrtmntFnc264'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031762', 'ImperialCerner', 'CM_TrtmntFnc280'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031704', 'ImperialCerner', 'CM_TrtmntFnc290'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031740', 'ImperialCerner', 'CM_TrtmntFnc291'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031607', 'ImperialCerner', 'CM_TrtmntFnc300'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031601', 'ImperialCerner', 'CM_TrtmntFnc301'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031712', 'ImperialCerner', 'CM_TrtmntFnc302'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031756', 'ImperialCerner', 'CM_TrtmntFnc303'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031832', 'ImperialCerner', 'CM_TrtmntFnc304'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031609', 'ImperialCerner', 'CM_TrtmntFnc305'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031780', 'ImperialCerner', 'CM_TrtmntFnc306'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031577', 'ImperialCerner', 'CM_TrtmntFnc307'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031726', 'ImperialCerner', 'CM_TrtmntFnc308'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031645', 'ImperialCerner', 'CM_TrtmntFnc309'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031655', 'ImperialCerner', 'CM_TrtmntFnc310'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031611', 'ImperialCerner', 'CM_TrtmntFnc311'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031716', 'ImperialCerner', 'CM_TrtmntFnc313'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031569', 'ImperialCerner', 'CM_TrtmntFnc314'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031657', 'ImperialCerner', 'CM_TrtmntFnc315'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031641', 'ImperialCerner', 'CM_TrtmntFnc316'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031734', 'ImperialCerner', 'CM_TrtmntFnc317'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031659', 'ImperialCerner', 'CM_TrtmntFnc318'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031647', 'ImperialCerner', 'CM_TrtmntFnc319'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031651', 'ImperialCerner', 'CM_TrtmntFnc320'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031581', 'ImperialCerner', 'CM_TrtmntFnc321'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031625', 'ImperialCerner', 'CM_TrtmntFnc322'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031778', 'ImperialCerner', 'CM_TrtmntFnc323'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031714', 'ImperialCerner', 'CM_TrtmntFnc324'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '12124539', 'ImperialCerner', 'CM_TrtmntFnc325'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031880', 'ImperialCerner', 'CM_TrtmntFnc327'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '12124541', 'ImperialCerner', 'CM_TrtmntFnc328'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '12124543', 'ImperialCerner', 'CM_TrtmntFnc329'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031613', 'ImperialCerner', 'CM_TrtmntFnc330'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '13835796', 'ImperialCerner', 'CM_TrtmntFnc331'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031718', 'ImperialCerner', 'CM_TrtmntFnc340'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031730', 'ImperialCerner', 'CM_TrtmntFnc341'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '12124535', 'ImperialCerner', 'CM_TrtmntFnc342'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '12124514', 'ImperialCerner', 'CM_TrtmntFnc343'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '13835791', 'ImperialCerner', 'CM_TrtmntFnc344'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '13835817', 'ImperialCerner', 'CM_TrtmntFnc346'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031619', 'ImperialCerner', 'CM_TrtmntFnc350'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031643', 'ImperialCerner', 'CM_TrtmntFnc352'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031621', 'ImperialCerner', 'CM_TrtmntFnc360'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031722', 'ImperialCerner', 'CM_TrtmntFnc361'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031623', 'ImperialCerner', 'CM_TrtmntFnc370'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031826', 'ImperialCerner', 'CM_TrtmntFnc371'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031573', 'ImperialCerner', 'CM_TrtmntFnc400'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031744', 'ImperialCerner', 'CM_TrtmntFnc410'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031589', 'ImperialCerner', 'CM_TrtmntFnc420'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031649', 'ImperialCerner', 'CM_TrtmntFnc421'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031587', 'ImperialCerner', 'CM_TrtmntFnc422'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031579', 'ImperialCerner', 'CM_TrtmntFnc424'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031760', 'ImperialCerner', 'CM_TrtmntFnc430'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031746', 'ImperialCerner', 'CM_TrtmntFnc450'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031748', 'ImperialCerner', 'CM_TrtmntFnc460'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031681', 'ImperialCerner', 'CM_TrtmntFnc501'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031673', 'ImperialCerner', 'CM_TrtmntFnc502'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031671', 'ImperialCerner', 'CM_TrtmntFnc503'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031677', 'ImperialCerner', 'CM_TrtmntFnc560'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031653', 'ImperialCerner', 'CM_TrtmntFnc650'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031665', 'ImperialCerner', 'CM_TrtmntFnc651'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031802', 'ImperialCerner', 'CM_TrtmntFnc652'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031663', 'ImperialCerner', 'CM_TrtmntFnc653'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031661', 'ImperialCerner', 'CM_TrtmntFnc654'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031667', 'ImperialCerner', 'CM_TrtmntFnc655'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031699', 'ImperialCerner', 'CM_TrtmntFnc656'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '12124537', 'ImperialCerner', 'CM_TrtmntFnc657'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '12124526', 'ImperialCerner', 'CM_TrtmntFnc658'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '12124518', 'ImperialCerner', 'CM_TrtmntFnc659'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '12124516', 'ImperialCerner', 'CM_TrtmntFnc660'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '12124522', 'ImperialCerner', 'CM_TrtmntFnc661'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '12124524', 'ImperialCerner', 'CM_TrtmntFnc662'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '13835849', 'ImperialCerner', 'CM_TrtmntFnc663'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031689', 'ImperialCerner', 'CM_TrtmntFnc700'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031691', 'ImperialCerner', 'CM_TrtmntFnc710'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031750', 'ImperialCerner', 'CM_TrtmntFnc711'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031752', 'ImperialCerner', 'CM_TrtmntFnc712'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031693', 'ImperialCerner', 'CM_TrtmntFnc713'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031695', 'ImperialCerner', 'CM_TrtmntFnc715'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031683', 'ImperialCerner', 'CM_TrtmntFnc720'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031685', 'ImperialCerner', 'CM_TrtmntFnc721'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031701', 'ImperialCerner', 'CM_TrtmntFnc722'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031687', 'ImperialCerner', 'CM_TrtmntFnc723'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031697', 'ImperialCerner', 'CM_TrtmntFnc724'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '13835834', 'ImperialCerner', 'CM_TrtmntFnc725'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '13835828', 'ImperialCerner', 'CM_TrtmntFnc726'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '13835806', 'ImperialCerner', 'CM_TrtmntFnc727'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031754', 'ImperialCerner', 'CM_TrtmntFnc800'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031724', 'ImperialCerner', 'CM_TrtmntFnc811'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031830', 'ImperialCerner', 'CM_TrtmntFnc812'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031782', 'ImperialCerner', 'CM_TrtmntFnc822'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '12124520', 'ImperialCerner', 'CM_TrtmntFnc834'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '9031828', 'ImperialCerner', 'CM_TrtmntFnc840'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '13835811', 'ImperialCerner', 'CM_TrtmntFnc920'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '375171001', 'ImperialCerner', 'CM_TrtmntFnc654'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '375170775', 'ImperialCerner', 'CM_TrtmntFnc654'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '11955726', 'ImperialCerner', 'CM_TrtmntFnc147'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '11953903', 'ImperialCerner', 'CM_TrtmntFnc820'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '11953911', 'ImperialCerner', 'CM_TrtmntFnc823'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '11953913', 'ImperialCerner', 'CM_TrtmntFnc824'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '11953917', 'ImperialCerner', 'CM_TrtmntFnc831'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '11953925', 'ImperialCerner', 'CM_TrtmntFnc900'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '11953927', 'ImperialCerner', 'CM_TrtmntFnc901'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '11953935', 'ImperialCerner', 'CM_TrtmntFnc903'),
    ('/IMPRL/CRNR/CDE/TRTMNT_FNCTN', '11953940', 'ImperialCerner', 'CM_TrtmntFnc950');

-- ******************** Language ********************

-- Concepts
SELECT @scm := dbid FROM concept WHERE id = 'ImperialCerner';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
(1, 'IC_Lang_8', @scm, 'IC_Lang_8', 'Cantonese', 'Cantonese'),
(1, 'IC_Lang_10', @scm, 'IC_Lang_10', 'Creole', 'Creole'),
(1, 'IC_Lang_13', @scm, 'IC_Lang_13', 'Ethiopian', 'Ethiopian'),
(1, 'IC_Lang_18', @scm, 'IC_Lang_18', 'French Creole', 'French Creole'),
(1, 'IC_Lang_23', @scm, 'IC_Lang_23', 'Hakka', 'Hakka'),
(1, 'IC_Lang_33', @scm, 'IC_Lang_33', 'Luganda', 'Luganda'),
(1, 'IC_Lang_36', @scm, 'IC_Lang_36', 'Mandarin', 'Mandarin'),
(1, 'IC_Lang_200', @scm, 'IC_Lang_200', 'Other', 'Other'),
(1, 'IC_Lang_39', @scm, 'IC_Lang_39', 'Patois', 'Patois'),
(1, 'IC_Lang_44', @scm, 'IC_Lang_44', 'Serbo-Croat', 'Serbo-Croat'),
(1, 'IC_Lang_51', @scm, 'IC_Lang_51', 'Sylheti', 'Sylheti');

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Imperial', 'CM_Sys_Cerner', 'CDE', null, 'language', '/IMPRL/CRNR/CDE/LNGG');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/IMPRL/CRNR/CDE/LNGG', 'DM_language');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/IMPRL/CRNR/CDE/LNGG', '9031950', 'ImperialCerner', 'FHIR_LANG_ak'),
('/IMPRL/CRNR/CDE/LNGG', '9031952', 'ImperialCerner', 'FHIR_LANG_am'),
('/IMPRL/CRNR/CDE/LNGG', '9031954', 'ImperialCerner', 'FHIR_LANG_ar'),
('/IMPRL/CRNR/CDE/LNGG', '5', 'ImperialCerner', 'FHIR_LANG_bn'),
('/IMPRL/CRNR/CDE/LNGG', '59', 'ImperialCerner', 'FHIR_LANG_cy'),
('/IMPRL/CRNR/CDE/LNGG', '20', 'ImperialCerner', 'FHIR_LANG_de'),
('/IMPRL/CRNR/CDE/LNGG', '21', 'ImperialCerner', 'FHIR_LANG_el'),
('/IMPRL/CRNR/CDE/LNGG', '12', 'ImperialCerner', 'FHIR_LANG_en'),
('/IMPRL/CRNR/CDE/LNGG', '48', 'ImperialCerner', 'FHIR_LANG_es'),
('/IMPRL/CRNR/CDE/LNGG', '14', 'ImperialCerner', 'FHIR_LANG_fa'),
('/IMPRL/CRNR/CDE/LNGG', '15', 'ImperialCerner', 'FHIR_LANG_fi'),
('/IMPRL/CRNR/CDE/LNGG', '17', 'ImperialCerner', 'FHIR_LANG_fr'),
('/IMPRL/CRNR/CDE/LNGG', '19', 'ImperialCerner', 'FHIR_LANG_gd'),
('/IMPRL/CRNR/CDE/LNGG', '22', 'ImperialCerner', 'FHIR_LANG_gu'),
('/IMPRL/CRNR/CDE/LNGG', '24', 'ImperialCerner', 'FHIR_LANG_ha'),
('/IMPRL/CRNR/CDE/LNGG', '25', 'ImperialCerner', 'FHIR_LANG_he'),
('/IMPRL/CRNR/CDE/LNGG', '26', 'ImperialCerner', 'FHIR_LANG_hi'),
('/IMPRL/CRNR/CDE/LNGG', '27', 'ImperialCerner', 'FHIR_LANG_ig'),
('/IMPRL/CRNR/CDE/LNGG', '28', 'ImperialCerner', 'FHIR_LANG_it'),
('/IMPRL/CRNR/CDE/LNGG', '29', 'ImperialCerner', 'FHIR_LANG_ja'),
('/IMPRL/CRNR/CDE/LNGG', '30', 'ImperialCerner', 'FHIR_LANG_ko'),
('/IMPRL/CRNR/CDE/LNGG', '31', 'ImperialCerner', 'FHIR_LANG_ku'),
('/IMPRL/CRNR/CDE/LNGG', '32', 'ImperialCerner', 'FHIR_LANG_ln'),
('/IMPRL/CRNR/CDE/LNGG', '35', 'ImperialCerner', 'FHIR_LANG_ml'),
('/IMPRL/CRNR/CDE/LNGG', '11', 'ImperialCerner', 'FHIR_LANG_nl'),
('/IMPRL/CRNR/CDE/LNGG', '16', 'ImperialCerner', 'FHIR_LANG_nl'),
('/IMPRL/CRNR/CDE/LNGG', '37', 'ImperialCerner', 'FHIR_LANG_no'),
('/IMPRL/CRNR/CDE/LNGG', '42', 'ImperialCerner', 'FHIR_LANG_pa'),
('/IMPRL/CRNR/CDE/LNGG', '40', 'ImperialCerner', 'FHIR_LANG_pl'),
('/IMPRL/CRNR/CDE/LNGG', '38', 'ImperialCerner', 'FHIR_LANG_ps'),
('/IMPRL/CRNR/CDE/LNGG', '41', 'ImperialCerner', 'FHIR_LANG_pt'),
('/IMPRL/CRNR/CDE/LNGG', '43', 'ImperialCerner', 'FHIR_LANG_ru'),
('/IMPRL/CRNR/CDE/LNGG', '45', 'ImperialCerner', 'FHIR_LANG_si'),
('/IMPRL/CRNR/CDE/LNGG', '6', 'ImperialCerner', 'FHIR_LANG_so'),
('/IMPRL/CRNR/CDE/LNGG', '46', 'ImperialCerner', 'FHIR_LANG_so'),
('/IMPRL/CRNR/CDE/LNGG', '2', 'ImperialCerner', 'FHIR_LANG_sq'),
('/IMPRL/CRNR/CDE/LNGG', '50', 'ImperialCerner', 'FHIR_LANG_sv'),
('/IMPRL/CRNR/CDE/LNGG', '49', 'ImperialCerner', 'FHIR_LANG_sw'),
('/IMPRL/CRNR/CDE/LNGG', '53', 'ImperialCerner', 'FHIR_LANG_ta'),
('/IMPRL/CRNR/CDE/LNGG', '54', 'ImperialCerner', 'FHIR_LANG_th'),
('/IMPRL/CRNR/CDE/LNGG', '55', 'ImperialCerner', 'FHIR_LANG_ti'),
('/IMPRL/CRNR/CDE/LNGG', '52', 'ImperialCerner', 'FHIR_LANG_tl'),
('/IMPRL/CRNR/CDE/LNGG', '56', 'ImperialCerner', 'FHIR_LANG_tr'),
('/IMPRL/CRNR/CDE/LNGG', '57', 'ImperialCerner', 'FHIR_LANG_ur'),
('/IMPRL/CRNR/CDE/LNGG', '9', 'ImperialCerner', 'FHIR_LANG_vi'),
('/IMPRL/CRNR/CDE/LNGG', '58', 'ImperialCerner', 'FHIR_LANG_vi'),
('/IMPRL/CRNR/CDE/LNGG', '60', 'ImperialCerner', 'FHIR_LANG_yo'),
('/IMPRL/CRNR/CDE/LNGG', '7', 'ImperialCerner', 'FHIR_LANG_q4'),
('/IMPRL/CRNR/CDE/LNGG', '34', 'ImperialCerner', 'FHIR_LANG_q5'),
-- Local
('/IMPRL/CRNR/CDE/LNGG', '8', 'ImperialCerner', 'IC_Lang_8'),
('/IMPRL/CRNR/CDE/LNGG', '10', 'ImperialCerner', 'IC_Lang_10'),
('/IMPRL/CRNR/CDE/LNGG', '13', 'ImperialCerner', 'IC_Lang_13'),
('/IMPRL/CRNR/CDE/LNGG', '18', 'ImperialCerner', 'IC_Lang_18'),
('/IMPRL/CRNR/CDE/LNGG', '23', 'ImperialCerner', 'IC_Lang_23'),
('/IMPRL/CRNR/CDE/LNGG', '33', 'ImperialCerner', 'IC_Lang_33'),
('/IMPRL/CRNR/CDE/LNGG', '36', 'ImperialCerner', 'IC_Lang_36'),
('/IMPRL/CRNR/CDE/LNGG', '200', 'ImperialCerner', 'IC_Lang_200'),
('/IMPRL/CRNR/CDE/LNGG', '39', 'ImperialCerner', 'IC_Lang_39'),
('/IMPRL/CRNR/CDE/LNGG', '51', 'ImperialCerner', 'IC_Lang_51');

-- ******************** Encounter ********************

-- Concepts
SELECT @scm := dbid FROM concept WHERE id = 'ImperialCerner';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
(1, 'IC_Enc_DayCase', @scm, 'IC_Enc_DayCase', 'Day case', 'Day case'),
(1, 'IC_Enc_Inpatient', @scm, 'IC_Enc_Inpatient', 'Inpatient', 'Inpatient'),
(1, 'IC_Enc_Newborn', @scm, 'IC_Enc_Newborn', 'Newborn', 'Newborn'),
(1, 'IC_Enc_Maternity', @scm, 'IC_Enc_Maternity', 'Maternity', 'Maternity'),
(1, 'IC_Enc_RegRDayAdm', @scm, 'IC_Enc_RegRDayAdm', 'Regular day admission', 'Regular day admission'),
(1, 'IC_Enc_Emergency', @scm, 'IC_Enc_Emergency', 'Emergency department', 'Emergency department'),
(1, 'IC_Enc_IPWL', @scm, 'IC_Enc_IPWL', 'Inpatient waiting list', 'Inpatient waiting list'),
(1, 'IC_Enc_DCWL', @scm, 'IC_Enc_DCWL', 'Day case waiting list', 'Day case waiting list'),
(1, 'IC_Enc_OPReferral', @scm, 'IC_Enc_OPReferral', 'Outpatient referral', 'Outpatient referral'),
(1, 'IC_Enc_PreReg', @scm, 'IC_Enc_PreReg', 'Preregistration', 'Preregistration'),
(1, 'IC_Enc_RegNghtAdm', @scm, 'IC_Enc_RegNghtAdm', 'Regular night admission', 'Regular night admission'),
(1, 'IC_Enc_DirectRef', @scm, 'IC_Enc_DirectRef', 'Direct referral', 'Direct referral'),
(1, 'IC_Enc_PreAdmit', @scm, 'IC_Enc_PreAdmit', 'Outpatient registration', 'Outpatient registration'),
(1, 'IC_Enc_Outpatient', @scm, 'IC_Enc_Outpatient', 'Outpatient', 'Outpatient');

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Imperial', 'CM_Sys_Cerner', 'CDE', null, 'encounter_type', '/IMPRL/CRNR/CDE/ENCNTR_TYP');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/IMPRL/CRNR/CDE/ENCNTR_TYP', 'DM_admissionPatientClassification');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/IMPRL/CRNR/CDE/ENCNTR_TYP', '9033713', 'ImperialCerner', 'IC_Enc_DayCase'),
('/IMPRL/CRNR/CDE/ENCNTR_TYP', '9033709', 'ImperialCerner', 'IC_Enc_Inpatient'),
('/IMPRL/CRNR/CDE/ENCNTR_TYP', '9033715', 'ImperialCerner', 'IC_Enc_Newborn'),
('/IMPRL/CRNR/CDE/ENCNTR_TYP', '9033711', 'ImperialCerner', 'IC_Enc_Maternity'),
('/IMPRL/CRNR/CDE/ENCNTR_TYP', '9033719', 'ImperialCerner', 'IC_Enc_RegRDayAdm'),
('/IMPRL/CRNR/CDE/ENCNTR_TYP', '9033727', 'ImperialCerner', 'IC_Enc_Emergency'),
('/IMPRL/CRNR/CDE/ENCNTR_TYP', '9033735', 'ImperialCerner', 'IC_Enc_IPWL'),
('/IMPRL/CRNR/CDE/ENCNTR_TYP', '9033737', 'ImperialCerner', 'IC_Enc_DCWL'),
('/IMPRL/CRNR/CDE/ENCNTR_TYP', '9033741', 'ImperialCerner', 'IC_Enc_OPReferral'),
('/IMPRL/CRNR/CDE/ENCNTR_TYP', '9033731', 'ImperialCerner', 'IC_Enc_PreReg'),
('/IMPRL/CRNR/CDE/ENCNTR_TYP', '9033721', 'ImperialCerner', 'IC_Enc_RegNghtAdm'),
('/IMPRL/CRNR/CDE/ENCNTR_TYP', '9033725', 'ImperialCerner', 'IC_Enc_DirectRef'),
('/IMPRL/CRNR/CDE/ENCNTR_TYP', '9033733', 'ImperialCerner', 'IC_Enc_PreAdmit'),
('/IMPRL/CRNR/CDE/ENCNTR_TYP', '9033739', 'ImperialCerner', 'IC_Enc_Outpatient');

