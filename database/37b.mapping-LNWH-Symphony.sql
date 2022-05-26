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
(1, 'CM_Org_LNWH', @scm, 'CM_Org_LNWH', 'London North West Hospitals', 'London North West Hospitals'),
(1, 'CM_Sys_Symphony', @scm, 'CM_Sys_Symphony', 'Symphony', 'Symphony system'),
(1, 'LNWHSymphony', @scm, 'LNWHSymphony', 'LNWH Symphony Local Codes', 'London North West Hospitals Sliverlink local code scheme');

INSERT IGNORE INTO concept_property_data
(`dbid`, `group`, `property`, `value`)
SELECT c.dbid, 0 AS `group`, p.dbid AS `property`, 'LNWH_SY_' AS `value`
FROM concept c
         JOIN concept p ON p.id = 'code_prefix'
WHERE c.id = 'LNWHSymphony';

-- ******************** Gender ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Symphony', null, null, 'gender', '/LNWH/SYMPHNY/GNDR');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/LNWH/SYMPHNY/GNDR', 'DM_gender');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/LNWH/SYMPHNY/GNDR', '2', 'LNWHSymphony', 'FHIR_AG_female'),
('/LNWH/SYMPHNY/GNDR', '1', 'LNWHSymphony', 'FHIR_AG_male'),
('/LNWH/SYMPHNY/GNDR', '0', 'LNWHSymphony', 'FHIR_AG_unknown'),
('/LNWH/SYMPHNY/GNDR', '9', 'LNWHSymphony', 'FHIR_AG_other');

-- ******************** Religion ********************
-- Concepts
SELECT @scm := dbid FROM concept WHERE id = 'LNWHSymphony';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
(1, 'LNWH_SY_Rlgn_Pen', @scm, 'LNWH_SY_Rlgn_Pen', 'Pentecostal', 'Pentecostal'),                 -- New 26/05/2022 - DDSEUS-101
(1, 'LNWH_SY_Rlgn_CofG', @scm, 'LNWH_SY_Rlgn_CofG', 'Church of God', 'Church of God'),          -- New 26/05/2022 - DDSEUS-101
(1, 'LNWH_SY_Rlgn_CofC', @scm, 'LNWH_SY_Rlgn_CofC', 'Church of Christ', 'Church of Christ'),    -- New 26/05/2022 - DDSEUS-101
(1, 'LNWH_SY_Rlgn_OF', @scm, 'LNWH_SY_Rlgn_OF', 'Other Free Church', 'Other Free Church');      -- New 26/05/2022 - DDSEUS-101

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Symphony', null, null, 'religion', '/LNWH/SYMPHNY/RLGN');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/LNWH/SYMPHNY/RLGN', 'DM_religion');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/LNWH/SYMPHNY/RLGN', 'BAHA', 'LNWHSymphony', 'CM_ReligionA1'),
('/LNWH/SYMPHNY/RLGN', 'BUD', 'LNWHSymphony', 'CM_ReligionB1'),
('/LNWH/SYMPHNY/RLGN', 'CHRI', 'LNWHSymphony', 'CM_ReligionC1'),
('/LNWH/SYMPHNY/RLGN', 'ANG', 'LNWHSymphony', 'CM_ReligionC4'),
('/LNWH/SYMPHNY/RLGN', 'AC', 'LNWHSymphony', 'CM_ReligionC6'),
('/LNWH/SYMPHNY/RLGN', 'BAP', 'LNWHSymphony', 'CM_ReligionC8'),
('/LNWH/SYMPHNY/RLGN', 'CH', 'LNWHSymphony', 'CM_ReligionC16'),
('/LNWH/SYMPHNY/RLGN', 'CHSC', 'LNWHSymphony', 'CM_ReligionC19'),
('/LNWH/SYMPHNY/RLGN', 'C/W', 'LNWHSymphony', 'CM_ReligionC21'),
('/LNWH/SYMPHNY/RLGN', 'C/E', 'LNWHSymphony', 'CM_ReligionC22'),
('/LNWH/SYMPHNY/RLGN', 'C/I', 'LNWHSymphony', 'CM_ReligionC24'),
('/LNWH/SYMPHNY/RLGN', 'C/S', 'LNWHSymphony', 'CM_ReligionC25'),
('/LNWH/SYMPHNY/RLGN', 'CONG', 'LNWHSymphony', 'CM_ReligionC26'),
('/LNWH/SYMPHNY/RLGN', 'COPO', 'LNWHSymphony', 'CM_ReligionC27'),
('/LNWH/SYMPHNY/RLGN', 'EVAN', 'LNWHSymphony', 'CM_ReligionC32'),
('/LNWH/SYMPHNY/RLGN', 'ORTH', 'LNWHSymphony', 'CM_ReligionC41'),
('/LNWH/SYMPHNY/RLGN', 'JWIT', 'LNWHSymphony', 'CM_ReligionC44'),
('/LNWH/SYMPHNY/RLGN', 'LUTH', 'LNWHSymphony', 'CM_ReligionC46'),
('/LNWH/SYMPHNY/RLGN', 'METH', 'LNWHSymphony', 'CM_ReligionC49'),
('/LNWH/SYMPHNY/RLGN', 'MOR', 'LNWHSymphony', 'CM_ReligionC50'),
('/LNWH/SYMPHNY/RLGN', 'MORM', 'LNWHSymphony', 'CM_ReligionC51'),
('/LNWH/SYMPHNY/RLGN', 'NT', 'LNWHSymphony', 'CM_ReligionC53'),
('/LNWH/SYMPHNY/RLGN', 'N/C', 'LNWHSymphony', 'CM_ReligionC54'),
('/LNWH/SYMPHNY/RLGN', 'PRES', 'LNWHSymphony', 'CM_ReligionC59'),
('/LNWH/SYMPHNY/RLGN', 'PROT', 'LNWHSymphony', 'CM_ReligionC60'),
('/LNWH/SYMPHNY/RLGN', 'PB', 'LNWHSymphony', 'CM_ReligionC61'),
('/LNWH/SYMPHNY/RLGN', 'QUAK', 'LNWHSymphony', 'CM_ReligionC62'),
('/LNWH/SYMPHNY/RLGN', 'RAST', 'LNWHSymphony', 'CM_ReligionC63'),
('/LNWH/SYMPHNY/RLGN', 'R/C', 'LNWHSymphony', 'CM_ReligionC67'),
('/LNWH/SYMPHNY/RLGN', 'R/O', 'LNWHSymphony', 'CM_ReligionC68'),
('/LNWH/SYMPHNY/RLGN', 'RUS', 'LNWHSymphony', 'CM_ReligionC69'),
('/LNWH/SYMPHNY/RLGN', 'SALV', 'LNWHSymphony', 'CM_ReligionC70'),
('/LNWH/SYMPHNY/RLGN', 'S/O', 'LNWHSymphony', 'CM_ReligionC72'),
('/LNWH/SYMPHNY/RLGN', 'SDA', 'LNWHSymphony', 'CM_ReligionC73'),
('/LNWH/SYMPHNY/RLGN', 'UN', 'LNWHSymphony', 'CM_ReligionC78'),
('/LNWH/SYMPHNY/RLGN', 'URC', 'LNWHSymphony', 'CM_ReligionC79'),
('/LNWH/SYMPHNY/RLGN', 'HIN', 'LNWHSymphony', 'CM_ReligionD1'),
('/LNWH/SYMPHNY/RLGN', 'JAIN', 'LNWHSymphony', 'CM_ReligionE1'),
('/LNWH/SYMPHNY/RLGN', 'JEW', 'LNWHSymphony', 'CM_ReligionF1'),
('/LNWH/SYMPHNY/RLGN', 'MUS', 'LNWHSymphony', 'CM_ReligionG1'),
('/LNWH/SYMPHNY/RLGN', 'PAGA', 'LNWHSymphony', 'CM_ReligionH1'),
('/LNWH/SYMPHNY/RLGN', 'DRUI', 'LNWHSymphony', 'CM_ReligionH4'),
('/LNWH/SYMPHNY/RLGN', 'WIC', 'LNWHSymphony', 'CM_ReligionH9'),
('/LNWH/SYMPHNY/RLGN', 'SIKH', 'LNWHSymphony', 'CM_ReligionI1'),
('/LNWH/SYMPHNY/RLGN', 'ZORO', 'LNWHSymphony', 'CM_ReligionJ1'),
('/LNWH/SYMPHNY/RLGN', 'AGN', 'LNWHSymphony', 'CM_ReligionK1'),
('/LNWH/SYMPHNY/RLGN', 'HMST', 'LNWHSymphony', 'CM_ReligionK11'),
('/LNWH/SYMPHNY/RLGN', 'OTH', 'LNWHSymphony', 'CM_ReligionK20'),
('/LNWH/SYMPHNY/RLGN', 'SPIR', 'LNWHSymphony', 'CM_ReligionK27'),
('/LNWH/SYMPHNY/RLGN', 'UN', 'LNWHSymphony', 'CM_ReligionK30'),
('/LNWH/SYMPHNY/RLGN', 'ATH', 'LNWHSymphony', 'CM_ReligionL1'),
('/LNWH/SYMPHNY/RLGN', 'UNK', 'LNWHSymphony', 'CM_ReligionN1'),
-- Added 26 May 2022 @ request of Michael Taylor - DDSEUS-101 --
('/LNWH/SLVRLNK/RLGN', 'NK', 'LNWHSilverlink', 'CM_ReligionN1'),
('/LNWH/SLVRLNK/RLGN', 'PEN', 'LNWHSilverlink', 'LNWH_SY_Rlgn_Pen'),
('/LNWH/SLVRLNK/RLGN', 'NONE', 'LNWHSilverlink', 'CM_ReligionL1'),
('/LNWH/SLVRLNK/RLGN', 'C/G', 'LNWHSilverlink', 'LNWH_SY_Rlgn_CofG'),
('/LNWH/SLVRLNK/RLGN', 'COFC', 'LNWHSilverlink', 'LNWH_SY_Rlgn_CofC'),
('/LNWH/SLVRLNK/RLGN', 'OF', 'LNWHSilverlink', 'LNWH_SY_Rlgn_OF');

-- ******************** Ethnicity ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Symphony', null, null, 'ethnicity', '/CDS/PTNT/ETHNC_CTGRY');

-- ******************** Admission Method ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Symphony', null, null, 'admission_method_code', '/CDS/INPTNT/ADMSSN_MTHD');

-- ******************** Admission Source ********************
-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Symphony', null, null, 'admission_source_code', '/CDS/INPTNT/ADMSSN_SRC');

-- ******************** Discharge Method ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Symphony', null, null, 'discharge_method', '/CDS/INPTNT/DSCHRG_MTHD');

-- ******************** Discharge Destination ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Symphony', null, null, 'discharge_destination_code', '/CDS/INPTNT/DSCHRG_DSTNTN');

-- ******************** Treatment Function ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Symphony', null, null, 'treatment_function_code', '/LNWH/SYMPHNY/TRTMNT_FNCTN');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/LNWH/SYMPHNY/TRTMNT_FNCTN', 'DM_treatmentFunctionAdmit');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '100', 'LNWHSymphony', 'CM_TrtmntFnc100'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '101', 'LNWHSymphony', 'CM_TrtmntFnc101'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '110', 'LNWHSymphony', 'CM_TrtmntFnc110'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '120', 'LNWHSymphony', 'CM_TrtmntFnc120'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '130', 'LNWHSymphony', 'CM_TrtmntFnc130'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '180', 'LNWHSymphony', 'CM_TrtmntFnc180'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '190', 'LNWHSymphony', 'CM_TrtmntFnc190'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '191', 'LNWHSymphony', 'CM_TrtmntFnc191'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '192', 'LNWHSymphony', 'CM_TrtmntFnc192'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '300', 'LNWHSymphony', 'CM_TrtmntFnc300'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '301', 'LNWHSymphony', 'CM_TrtmntFnc301'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '303', 'LNWHSymphony', 'CM_TrtmntFnc303'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '320', 'LNWHSymphony', 'CM_TrtmntFnc320'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '330', 'LNWHSymphony', 'CM_TrtmntFnc330'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '340', 'LNWHSymphony', 'CM_TrtmntFnc340'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '360', 'LNWHSymphony', 'CM_TrtmntFnc360'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '361', 'LNWHSymphony', 'CM_TrtmntFnc361'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '400', 'LNWHSymphony', 'CM_TrtmntFnc400'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '410', 'LNWHSymphony', 'CM_TrtmntFnc410'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '420', 'LNWHSymphony', 'CM_TrtmntFnc420'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '430', 'LNWHSymphony', 'CM_TrtmntFnc430'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '502', 'LNWHSymphony', 'CM_TrtmntFnc502'),
('/LNWH/SYMPHNY/TRTMNT_FNCTN', '710', 'LNWHSymphony', 'CM_TrtmntFnc710');

-- ******************** Language ********************
-- Concepts
SELECT @scm := dbid FROM concept WHERE id = 'LNWHSymphony';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
(1, 'LNWH_SY_Lng_OTH', @scm, 'LNWH_SY_Lng_OTH', 'Other', 'Other'),         -- New 12/05/2022 - ADTS-149
(1, 'LNWH_SY_Lng_UNK', @scm, 'LNWH_SY_Lng_UNK', 'Unknown', 'Unknown'),     -- New 12/05/2022 - ADTS-149
(1, 'LNWH_SY_Lng_ROMA', @scm, 'LNWH_SY_Lng_ROMA', 'Roma', 'Roma'),         -- New 12/05/2022 - ADTS-149
(1, 'LNWH_SY_Lng_DEA', @scm, 'LNWH_SY_Lng_DEA', 'Dea', 'Dea'),             -- New 12/05/2022 - ADTS-149
(1, 'LNWH_SY_Lng_DARI', @scm, 'LNWH_SY_Lng_DARI', 'Dari', 'Dari');         -- New 12/05/2022 - ADTS-149

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Symphony', null, null, 'language', '/LNWH/SYMPHNY/LNGG');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/LNWH/SYMPHNY/LNGG', 'DM_language');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/LNWH/SYMPHNY/LNGG', 'ARA', 'LNWHSymphony', 'FHIR_LANG_ar'),
('/LNWH/SYMPHNY/LNGG', 'BENG', 'LNWHSymphony', 'FHIR_LANG_bn'),
('/LNWH/SYMPHNY/LNGG', 'GER', 'LNWHSymphony', 'FHIR_LANG_de'),
('/LNWH/SYMPHNY/LNGG', 'GRE', 'LNWHSymphony', 'FHIR_LANG_el'),
('/LNWH/SYMPHNY/LNGG', 'ENG', 'LNWHSymphony', 'FHIR_LANG_en'),
('/LNWH/SYMPHNY/LNGG', 'SPA', 'LNWHSymphony', 'FHIR_LANG_es'),
('/LNWH/SYMPHNY/LNGG', 'FRE', 'LNWHSymphony', 'FHIR_LANG_fr'),
('/LNWH/SYMPHNY/LNGG', 'GUJ', 'LNWHSymphony', 'FHIR_LANG_gu'),
('/LNWH/SYMPHNY/LNGG', 'HEB', 'LNWHSymphony', 'FHIR_LANG_he'),
('/LNWH/SYMPHNY/LNGG', 'HIN', 'LNWHSymphony', 'FHIR_LANG_hi'),
('/LNWH/SYMPHNY/LNGG', 'ITI', 'LNWHSymphony', 'FHIR_LANG_it'),
('/LNWH/SYMPHNY/LNGG', 'JAP', 'LNWHSymphony', 'FHIR_LANG_ja'),
('/LNWH/SYMPHNY/LNGG', 'KOR', 'LNWHSymphony', 'FHIR_LANG_ko'),
('/LNWH/SYMPHNY/LNGG', 'DUT', 'LNWHSymphony', 'FHIR_LANG_nl'),
('/LNWH/SYMPHNY/LNGG', 'PUN', 'LNWHSymphony', 'FHIR_LANG_pa'),
('/LNWH/SYMPHNY/LNGG', 'POL', 'LNWHSymphony', 'FHIR_LANG_pl'),
('/LNWH/SYMPHNY/LNGG', 'PASH', 'LNWHSymphony', 'FHIR_LANG_ps'),
('/LNWH/SYMPHNY/LNGG', 'POR', 'LNWHSymphony', 'FHIR_LANG_pt'),
('/LNWH/SYMPHNY/LNGG', 'RUSS', 'LNWHSymphony', 'FHIR_LANG_ru'),
('/LNWH/SYMPHNY/LNGG', 'SING', 'LNWHSymphony', 'FHIR_LANG_si'),
('/LNWH/SYMPHNY/LNGG', 'SOM', 'LNWHSymphony', 'FHIR_LANG_so'),
('/LNWH/SYMPHNY/LNGG', 'ALB', 'LNWHSymphony', 'FHIR_LANG_sq'),
('/LNWH/SYMPHNY/LNGG', 'SWAH', 'LNWHSymphony', 'FHIR_LANG_sw'),
('/LNWH/SYMPHNY/LNGG', 'TAM', 'LNWHSymphony', 'FHIR_LANG_ta'),
('/LNWH/SYMPHNY/LNGG', 'TURK', 'LNWHSymphony', 'FHIR_LANG_tr'),
('/LNWH/SYMPHNY/LNGG', 'URD', 'LNWHSymphony', 'FHIR_LANG_ur'),
('/LNWH/SYMPHNY/LNGG', 'VIE', 'LNWHSymphony', 'FHIR_LANG_vi'),
('/LNWH/SYMPHNY/LNGG', 'DBSL', 'LNWHSymphony', 'FHIR_LANG_q4'),
('/LNWH/SYMPHNY/LNGG', 'NEPA', 'LNWHSymphony', 'FHIR_LANG_ne'),       -- New 12/05/2022 - ADTS-149
('/LNWH/SYMPHNY/LNGG', 'FARS', 'LNWHSymphony', 'FHIR_LANG_fa'),       -- New 12/05/2022 - ADTS-149

-- Local
('/LNWH/SYMPHNY/LNGG', 'OTH', 'LNWHSymphony', 'LNWH_SY_Lng_OTH'),     -- New 12/05/2022 - ADTS-149
('/LNWH/SYMPHNY/LNGG', 'UNK', 'LNWHSymphony', 'LNWH_SY_Lng_UNK'),     -- New 12/05/2022 - ADTS-149
('/LNWH/SYMPHNY/LNGG', 'ROMA', 'LNWHSymphony', 'LNWH_SY_Lng_ROMA'),   -- New 12/05/2022 - ADTS-149
('/LNWH/SYMPHNY/LNGG', 'DEA', 'LNWHSymphony', 'LNWH_SY_Lng_DEA'),     -- New 12/05/2022 - ADTS-149
('/LNWH/SYMPHNY/LNGG', 'DARI', 'LNWHSymphony', 'LNWH_SY_Lng_DARI');   -- New 12/05/2022 - ADTS-149

-- ******************** Encounter ********************

-- Concepts
SELECT @scm := dbid FROM concept WHERE id = 'LNWHSymphony';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
(1, 'LNWH_SY_Enc_DayCase', @scm, 'LNWH_SY_Enc_DayCase', 'Day case', 'Day case'),
(1, 'LNWH_SY_Enc_Inpatient', @scm, 'LNWH_SY_Enc_Inpatient', 'Inpatient', 'Inpatient'),
(1, 'LNWH_SY_Enc_Maternity', @scm, 'LNWH_SY_Enc_Maternity', 'Maternity', 'Maternity'),
(1, 'LNWH_SY_Enc_Newborn', @scm, 'LNWH_SY_Enc_Newborn', 'Newborn', 'Newborn'),
(1, 'LNWH_SY_Enc_RegRDayAdm', @scm, 'LNWH_SY_Enc_RegRDayAdm', 'Regular day admission', 'Regular day admission'),
(1, 'LNWH_SY_Enc_RegNghtAdm', @scm, 'LNWH_SY_Enc_RegNghtAdm', 'Regular night admission', 'Regular night admission'),
(1, 'LNWH_SY_Enc_DirectRef', @scm, 'LNWH_SY_Enc_DirectRef', 'Direct referral', 'Direct referral'),
(1, 'LNWH_SY_Enc_Emergency', @scm, 'LNWH_SY_Enc_Emergency', 'Emergency department', 'Emergency department'),
(1, 'LNWH_SY_Enc_Outpatient', @scm, 'LNWH_SY_Enc_Outpatient', 'Outpatient', 'Outpatient'),
(1, 'LNWH_SY_Enc_DCWL', @scm, 'LNWH_SY_Enc_DCWL', 'Day case waiting list', 'Day case waiting list'),
(1, 'LNWH_SY_Enc_PreReg', @scm, 'LNWH_SY_Enc_PreReg', 'Preregistration', 'Preregistration'),
(1, 'LNWH_SY_Enc_IPWL', @scm, 'LNWH_SY_Enc_IPWL', 'Inpatient waiting list', 'Inpatient waiting list'),
(1, 'LNWH_SY_Enc_PreAdmit', @scm, 'LNWH_SY_Enc_PreAdmit', 'Outpatient registration', 'Outpatient registration'),
(1, 'LNWH_SY_Enc_OPReferral', @scm, 'LNWH_SY_Enc_OPReferral', 'Outpatient referral', 'Outpatient referral');

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Symphony', null, null, 'encounter_type', '/LNWH/SYMPHNY/ENCNTR_TYP');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/LNWH/SYMPHNY/ENCNTR_TYP', 'DM_admissionPatientClassification');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/LNWH/SYMPHNY/ENCNTR_TYP', 'DAYCASE', 'LNWHSymphony', 'LNWH_SY_Enc_DayCase'),
('/LNWH/SYMPHNY/ENCNTR_TYP', 'INPATIENT', 'LNWHSymphony', 'LNWH_SY_Enc_Inpatient'),
('/LNWH/SYMPHNY/ENCNTR_TYP', 'MATERNITY', 'LNWHSymphony', 'LNWH_SY_Enc_Maternity'),
('/LNWH/SYMPHNY/ENCNTR_TYP', 'NEWBORN', 'LNWHSymphony', 'LNWH_SY_Enc_Newborn'),
('/LNWH/SYMPHNY/ENCNTR_TYP', 'REGRDAYADM', 'LNWHSymphony', 'LNWH_SY_Enc_RegRDayAdm'),
('/LNWH/SYMPHNY/ENCNTR_TYP', 'REGNGHTADM', 'LNWHSymphony', 'LNWH_SY_Enc_RegNghtAdm'),
('/LNWH/SYMPHNY/ENCNTR_TYP', 'DIRECTREF', 'LNWHSymphony', 'LNWH_SY_Enc_DirectRef'),
('/LNWH/SYMPHNY/ENCNTR_TYP', 'EMERGENCY', 'LNWHSymphony', 'LNWH_SY_Enc_Emergency'),
('/LNWH/SYMPHNY/ENCNTR_TYP', 'OUTPATIENT', 'LNWHSymphony', 'LNWH_SY_Enc_Outpatient'),
('/LNWH/SYMPHNY/ENCNTR_TYP', 'DCWL', 'LNWHSymphony', 'LNWH_SY_Enc_DCWL'),
('/LNWH/SYMPHNY/ENCNTR_TYP', 'PREREG', 'LNWHSymphony', 'LNWH_SY_Enc_PreReg'),
('/LNWH/SYMPHNY/ENCNTR_TYP', 'IPWL', 'LNWHSymphony', 'LNWH_SY_Enc_IPWL'),
('/LNWH/SYMPHNY/ENCNTR_TYP', 'PREADMIT', 'LNWHSymphony', 'LNWH_SY_Enc_PreAdmit'),
('/LNWH/SYMPHNY/ENCNTR_TYP', 'OPREFERRAL', 'LNWHSymphony', 'LNWH_SY_Enc_OPReferral');
