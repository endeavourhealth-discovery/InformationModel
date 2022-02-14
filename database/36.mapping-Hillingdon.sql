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
(1, 'CM_Org_THH', @scm, 'CM_Org_THH', 'The Hillingdon Hospitals', 'The Hillingdon Hospitals, London'),
(1, 'CM_Sys_Silverlink', @scm, 'CM_Sys_Silverlink', 'Silverlink', 'Silverlink system'),
(1, 'THHSilverlink', @scm, 'THHSilverlink', 'The Hillingdon Hospitals Local Codes', 'The Hillingdon Hospitals Sliverlink local code scheme');

INSERT IGNORE INTO concept_property_data
(`dbid`, `group`, `property`, `value`)
SELECT c.dbid, 0 AS `group`, p.dbid AS `property`, 'THH_' AS `value`
FROM concept c
         JOIN concept p ON p.id = 'code_prefix'
WHERE c.id = 'THHSilverlink';

-- ******************** Religion ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_THH', 'CM_Sys_Silverlink', null, null, 'religion', '/THH/SLVRLNK/RLGN');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/THH/SLVRLNK/RLGN', 'DM_religion');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/THH/SLVRLNK/RLGN', 'MORM', 'THHSilverlink', 'CM_ReligionC51'),
('/THH/SLVRLNK/RLGN', 'MUS', 'THHSilverlink', 'CM_ReligionG1'),
('/THH/SLVRLNK/RLGN', 'N/C', 'THHSilverlink', 'CM_ReligionC54'),
('/THH/SLVRLNK/RLGN', 'NK', 'THHSilverlink', 'CM_ReligionN1'),
('/THH/SLVRLNK/RLGN', 'NONE', 'THHSilverlink', 'CM_ReligionM1'),
('/THH/SLVRLNK/RLGN', 'OF', 'THHSilverlink', 'CM_ReligionC34'),
('/THH/SLVRLNK/RLGN', 'ORTH', 'THHSilverlink', 'CM_ReligionC57'),
('/THH/SLVRLNK/RLGN', 'OTH', 'THHSilverlink', 'CM_ReligionN1'),
('/THH/SLVRLNK/RLGN', 'PB', 'THHSilverlink', 'CM_ReligionC61'),
('/THH/SLVRLNK/RLGN', 'PEN', 'THHSilverlink', 'CM_ReligionC58'),
('/THH/SLVRLNK/RLGN', 'PRES', 'THHSilverlink', 'CM_ReligionC59'),
('/THH/SLVRLNK/RLGN', 'PROT', 'THHSilverlink', 'CM_ReligionC60'),
('/THH/SLVRLNK/RLGN', 'QUAK', 'THHSilverlink', 'CM_ReligionC62'),
('/THH/SLVRLNK/RLGN', 'R/C', 'THHSilverlink', 'CM_ReligionC67'),
('/THH/SLVRLNK/RLGN', 'RAST', 'THHSilverlink', 'CM_ReligionC63'),
('/THH/SLVRLNK/RLGN', 'SALV', 'THHSilverlink', 'CM_ReligionC70'),
('/THH/SLVRLNK/RLGN', 'SIKH', 'THHSilverlink', 'CM_ReligionI1'),
('/THH/SLVRLNK/RLGN', 'SP', 'THHSilverlink', 'CM_ReligionK27'),
('/THH/SLVRLNK/RLGN', 'UN', 'THHSilverlink', 'CM_ReligionC78'),
('/THH/SLVRLNK/RLGN', 'URC', 'THHSilverlink', 'CM_ReligionC79');

-- ******************** Ethnicity ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_THH', 'CM_Sys_Silverlink', null, null, 'ethnicity', '/CDS/PTNT/ETHNC_CTGRY');

-- ******************** Admission Method ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_THH', 'CM_Sys_Silverlink', null, null, 'admission_method_code', '/CDS/INPTNT/ADMSSN_MTHD');

-- ******************** Admission Source ********************

-- Concepts
SELECT @scm := dbid FROM concept WHERE id = 'THHSilverlink';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
(1, 'THH_AdmssnSrc98', @scm, 'THH_AdmssnSrc98', 'Not applicable', 'Not applicable'),
(1, 'THH_AdmssnSrc99', @scm, 'THH_AdmssnSrc99', 'Not known', 'Not known');

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_THH', 'CM_Sys_Silverlink', null, null, 'admission_source_code', '/THH/SLVRLNK/ADMSSN_SRC');

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/THH/SLVRLNK/ADMSSN_SRC', 'DM_sourceOfAdmission');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/THH/SLVRLNK/ADMSSN_SRC', '19', 'THHSilverlink', 'CM_SrcAdmUsual'),
('/THH/SLVRLNK/ADMSSN_SRC', '29', 'THHSilverlink', 'CM_SrcAdmTempR'),
('/THH/SLVRLNK/ADMSSN_SRC', '39', 'THHSilverlink', 'CM_SrcAdmPePoCo'),
('/THH/SLVRLNK/ADMSSN_SRC', '49', 'THHSilverlink', 'CM_SrcAdmPSyHosp'),
('/THH/SLVRLNK/ADMSSN_SRC', '51', 'THHSilverlink', 'CM_SrcAdmA1'),
('/THH/SLVRLNK/ADMSSN_SRC', '52', 'THHSilverlink', 'CM_SrcAdmA2'),
('/THH/SLVRLNK/ADMSSN_SRC', '53', 'THHSilverlink', 'CM_SrcAdmA3'),
('/THH/SLVRLNK/ADMSSN_SRC', '54', 'THHSilverlink', 'CM_SrcAdmA4'),
('/THH/SLVRLNK/ADMSSN_SRC', '65', 'THHSilverlink', 'CM_SrcAdmA5'),
('/THH/SLVRLNK/ADMSSN_SRC', '66', 'THHSilverlink', 'CM_SrcAdmA6'),
('/THH/SLVRLNK/ADMSSN_SRC', '79', 'THHSilverlink', 'CM_SrcAdmA7'),
('/THH/SLVRLNK/ADMSSN_SRC', '85', 'THHSilverlink', 'CM_SrcAdmA8'),
('/THH/SLVRLNK/ADMSSN_SRC', '87', 'THHSilverlink', 'CM_SrcAdmA9'),
('/THH/SLVRLNK/ADMSSN_SRC', '88', 'THHSilverlink', 'CM_SrcAsmA10'),
('/THH/SLVRLNK/ADMSSN_SRC', '98', 'THHSilverlink', 'THH_AdmssnSrc98'),
('/THH/SLVRLNK/ADMSSN_SRC', '99', 'THHSilverlink', 'THH_AdmssnSrc99');

-- ******************** Discharge Method ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_THH', 'CM_Sys_Silverlink', null, null, 'discharge_method', '/CDS/INPTNT/DSCHRG_MTHD');

-- ******************** Discharge Destination ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_THH', 'CM_Sys_Silverlink', null, null, 'discharge_destination_code', '/CDS/INPTNT/DSCHRG_DSTNTN');

-- ******************** Treatment Function ********************
-- ************ TODO: TREATMENT FUNCTION CODES VS SPECIALITIES ****************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_THH', 'CM_Sys_Silverlink', null, null, 'treatment_function_code', '/THH/SLVRLNK/TRTMNT_FNCTN');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/THH/SLVRLNK/TRTMNT_FNCTN', 'DM_treatmentFunctionAdmit');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/THH/SLVRLNK/TRTMNT_FNCTN', 'ANCPAED', 'THHSilverlink', 'CM_TrtmntFnc420'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'FTDIAG', 'THHSilverlink', 'CM_TrtmntFnc960');    -- TODO: 960 is speciality NOT treatment function code

-- ******************** Language ********************

-- Concepts
    SELECT @scm := dbid FROM concept WHERE id = 'THHSilverlink';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
(1, 'THH_Lang_DAJ', @scm, 'THH_Lang_DAJ', 'Dajanely', 'Dajanely'),
(1, 'THH_Lang_DEAF', @scm, 'THH_Lang_DEAF', 'Sign/Deaf', 'Sign language/Deaf patient');

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_THH', 'CM_Sys_Silverlink', null, null, 'language', '/THH/SLVRLNK/LNGG');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/THH/SLVRLNK/LNGG', 'DM_language');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/THH/SLVRLNK/LNGG', 'CS', 'THHSilverlink', 'FHIR_LANG_cs'),
('/THH/SLVRLNK/LNGG', 'DUT', 'THHSilverlink', 'FHIR_LANG_nl'),
('/THH/SLVRLNK/LNGG', 'FARS', 'THHSilverlink', 'FHIR_LANG_fa'),
('/THH/SLVRLNK/LNGG', 'GUJ', 'THHSilverlink', 'FHIR_LANG_gu'),
('/THH/SLVRLNK/LNGG', 'HIN', 'THHSilverlink', 'FHIR_LANG_hi'),
('/THH/SLVRLNK/LNGG', 'ITAL', 'THHSilverlink', 'FHIR_LANG_it'),
('/THH/SLVRLNK/LNGG', 'LIT', 'THHSilverlink', 'FHIR_LANG_lt'),
('/THH/SLVRLNK/LNGG', 'MAN', 'THHSilverlink', 'FHIR_LANG_zh'),
('/THH/SLVRLNK/LNGG', 'NEP', 'THHSilverlink', 'FHIR_LANG_ne'),
('/THH/SLVRLNK/LNGG', 'POL', 'THHSilverlink', 'FHIR_LANG_pl'),
('/THH/SLVRLNK/LNGG', 'POR', 'THHSilverlink', 'FHIR_LANG_pt'),
('/THH/SLVRLNK/LNGG', 'PUN', 'THHSilverlink', 'FHIR_LANG_pa'),
('/THH/SLVRLNK/LNGG', 'SIN', 'THHSilverlink', 'FHIR_LANG_si'),
('/THH/SLVRLNK/LNGG', 'SOM', 'THHSilverlink', 'FHIR_LANG_so'),
('/THH/SLVRLNK/LNGG', 'TAM', 'THHSilverlink', 'FHIR_LANG_ta'),
('/THH/SLVRLNK/LNGG', 'TEL', 'THHSilverlink', 'FHIR_LANG_te'),
('/THH/SLVRLNK/LNGG', 'URDU', 'THHSilverlink', 'FHIR_LANG_ur'),
('/THH/SLVRLNK/LNGG', 'DAJ', 'THHSilverlink', 'THH_Lang_DAJ'),
('/THH/SLVRLNK/LNGG', 'DEAF', 'THHSilverlink', 'THH_Lang_DEAF');


