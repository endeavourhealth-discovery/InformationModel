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
-- Concepts
SELECT @scm := dbid FROM concept WHERE id = 'THHSilverlink';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
(1, 'THH_TrtmntFnc92', @scm, 'THH_TrtmntFnc92', 'Eating Disorders', 'Eating Disorders'),
(1, 'THH_TrtmntFnc20', @scm, 'THH_TrtmntFnc20', 'Care of the Elderly', 'Care of the Elderly'),
(1, 'THH_TrtmntFnc91', @scm, 'THH_TrtmntFnc91', 'Community Midwives', 'Community Midwives'),
(1, 'THH_TrtmntFnc10', @scm, 'THH_TrtmntFnc10', 'Other', 'Other'); -- Confirmed by EMail - Mike 18-Jul-2022

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
('/THH/SLVRLNK/TRTMNT_FNCTN', 'FTDIAG', 'THHSilverlink', 'CM_TrtmntFnc960'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'OPME', 'THHSilverlink', 'CM_TrtmntFnc460'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'SALT', 'THHSilverlink', 'CM_TrtmntFnc652'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'CP', 'THHSilverlink', 'CM_TrtmntFnc656'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PAMA', 'THHSilverlink', 'CM_TrtmntFnc191'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PHYSIO', 'THHSilverlink', 'CM_TrtmntFnc650'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'ORTHOTICS', 'THHSilverlink', 'CM_TrtmntFnc658'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'RESP', 'THHSilverlink', 'CM_TrtmntFnc340'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GENMEDR', 'THHSilverlink', 'CM_TrtmntFnc340'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'NAD', 'THHSilverlink', 'CM_TrtmntFnc654'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'CARDIO', 'THHSilverlink', 'CM_TrtmntFnc320'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GENMEDC', 'THHSilverlink', 'CM_TrtmntFnc320'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GASTRO', 'THHSilverlink', 'CM_TrtmntFnc301'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GENMEDG', 'THHSilverlink', 'CM_TrtmntFnc301'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'CPAIN', 'THHSilverlink', 'CM_TrtmntFnc190'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'NEPH', 'THHSilverlink', 'CM_TrtmntFnc361'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'ENDOCR', 'THHSilverlink', 'CM_TrtmntFnc302'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'DIABM', 'THHSilverlink', 'CM_TrtmntFnc302'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'DIABN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'CPAINN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GYNAN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'SPDI', 'THHSilverlink', 'CM_TrtmntFnc960'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'RESPN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PODI', 'THHSilverlink', 'CM_TrtmntFnc960'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'TOSN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GESUN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'UROLN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GS', 'THHSilverlink', 'CM_TrtmntFnc100'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GSV', 'THHSilverlink', 'CM_TrtmntFnc100'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GSC', 'THHSilverlink', 'CM_TrtmntFnc100'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GSB', 'THHSilverlink', 'CM_TrtmntFnc100'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GSP', 'THHSilverlink', 'CM_TrtmntFnc171'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GENMEDD', 'THHSilverlink', 'CM_TrtmntFnc302'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'REHAB', 'THHSilverlink', 'CM_TrtmntFnc314'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PLTE', 'THHSilverlink', 'CM_TrtmntFnc960'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PALCA', 'THHSilverlink', 'CM_TrtmntFnc315'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'IVRA', 'THHSilverlink', 'CM_TrtmntFnc810'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'COAG', 'THHSilverlink', 'CM_TrtmntFnc303'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'OPHTN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'NEPHN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'ORTHOP', 'THHSilverlink', 'CM_TrtmntFnc960'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'OPTOM', 'THHSilverlink', 'CM_TrtmntFnc960'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'OBRA', 'THHSilverlink', 'CM_TrtmntFnc960'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'CHPOD', 'THHSilverlink', 'CM_TrtmntFnc960'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'DIETN', 'THHSilverlink', 'CM_TrtmntFnc960'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'BCN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PAEDRN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'REHABN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'INTERMC', 'THHSilverlink', 'CM_TrtmntFnc600'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'RESPITEC', 'THHSilverlink', 'CM_TrtmntFnc600'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'WPAED', 'THHSilverlink', 'CM_TrtmntFnc420'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'SNPAED', 'THHSilverlink', 'CM_TrtmntFnc420'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'RHEUMN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PAEDCP', 'THHSilverlink', 'CM_TrtmntFnc960'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'DERMN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GEMEN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PAEDN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GYNN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'HAEMN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'THORS', 'THHSilverlink', 'CM_TrtmntFnc170'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'FTOS', 'THHSilverlink', 'CM_TrtmntFnc110'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'ANAE', 'THHSilverlink', 'CM_TrtmntFnc190'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'AUME', 'THHSilverlink', 'CM_TrtmntFnc310'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'CGEN', 'THHSilverlink', 'CM_TrtmntFnc311'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'CLON', 'THHSilverlink', 'CM_TrtmntFnc800'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'COTE', 'THHSilverlink', 'CM_TrtmntFnc430'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'DEPA', 'THHSilverlink', 'CM_TrtmntFnc142'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'DERM', 'THHSilverlink', 'CM_TrtmntFnc330'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'DERP', 'THHSilverlink', 'CM_TrtmntFnc330'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'ENT', 'THHSilverlink', 'CM_TrtmntFnc120'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GEME', 'THHSilverlink', 'CM_TrtmntFnc300'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GENE', 'THHSilverlink', 'CM_TrtmntFnc311'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GUM', 'THHSilverlink', 'CM_TrtmntFnc360'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GYNA', 'THHSilverlink', 'CM_TrtmntFnc502'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'HAEM', 'THHSilverlink', 'CM_TrtmntFnc303'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'DERMALL', 'THHSilverlink', 'CM_TrtmntFnc330'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'NEURO', 'THHSilverlink', 'CM_TrtmntFnc400'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'OBST', 'THHSilverlink', 'CM_TrtmntFnc501'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'ONCOLOGY', 'THHSilverlink', 'CM_TrtmntFnc370'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'OPHT', 'THHSilverlink', 'CM_TrtmntFnc130'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'OPPA', 'THHSilverlink', 'CM_TrtmntFnc130'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'ORDO', 'THHSilverlink', 'CM_TrtmntFnc143'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'ORSU', 'THHSilverlink', 'CM_TrtmntFnc140'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PAED', 'THHSilverlink', 'CM_TrtmntFnc420'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PAME', 'THHSilverlink', 'CM_TrtmntFnc315'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PANE', 'THHSilverlink', 'CM_TrtmntFnc421'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PAUR', 'THHSilverlink', 'CM_TrtmntFnc101'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PTOS', 'THHSilverlink', 'CM_TrtmntFnc110'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'RADI', 'THHSilverlink', 'CM_TrtmntFnc800'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'RHEUM', 'THHSilverlink', 'CM_TrtmntFnc410'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'UROL', 'THHSilverlink', 'CM_TrtmntFnc101'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'HIPA', 'THHSilverlink', 'CM_TrtmntFnc824'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'KNDI', 'THHSilverlink', 'CM_TrtmntFnc960'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'TS', 'THHSilverlink', 'CM_TrtmntFnc300'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GEMENN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PLAS', 'THHSilverlink', 'CM_TrtmntFnc160'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'CARDN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GSCN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'NEURN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'OBSTM', 'THHSilverlink', 'CM_TrtmntFnc560'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'TOS', 'THHSilverlink', 'CM_TrtmntFnc110'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'STOS', 'THHSilverlink', 'CM_TrtmntFnc960'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'ACEM', 'THHSilverlink', 'CM_TrtmntFnc180'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'AND', 'THHSilverlink', 'CM_TrtmntFnc820'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'NEURH', 'THHSilverlink', 'CM_TrtmntFnc400'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PAEDH', 'THHSilverlink', 'CM_TrtmntFnc420'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'AUDMED', 'THHSilverlink', 'CM_TrtmntFnc310'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PAEDAUD', 'THHSilverlink', 'CM_TrtmntFnc254'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PAEDCF', 'THHSilverlink', 'CM_TrtmntFnc420'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PAEDDM', 'THHSilverlink', 'CM_TrtmntFnc420'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'DIABNP', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'AUDMEDP', 'THHSilverlink', 'CM_TrtmntFnc310'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'RADIOG', 'THHSilverlink', 'CM_TrtmntFnc960'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'DIAGIM', 'THHSilverlink', 'CM_TrtmntFnc960'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'TIA', 'THHSilverlink', 'CM_TrtmntFnc300'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GHEP', 'THHSilverlink', 'CM_TrtmntFnc301'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PONCN', 'THHSilverlink', 'CM_TrtmntFnc950'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'LLDIAG', 'THHSilverlink', 'CM_TrtmntFnc960'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'ENDOCRN', 'THHSilverlink', 'CM_TrtmntFnc302'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'ULDIAG', 'THHSilverlink', 'CM_TrtmntFnc960'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'IRCS', 'THHSilverlink', 'CM_TrtmntFnc340'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'PAEDRESP', 'THHSilverlink', 'CM_TrtmntFnc420'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'COMMW', 'THHSilverlink', 'CM_TrtmntFnc560'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'OCH', 'THHSilverlink', 'CM_TrtmntFnc901'),
-- CUSTOM/LOCAL TREATMENT FUNCTIONS
('/THH/SLVRLNK/TRTMNT_FNCTN', 'ESD', 'THHSilverlink', 'THH_TrtmntFnc92'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'COE', 'THHSilverlink', 'THH_TrtmntFnc20'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GOP', 'THHSilverlink', 'THH_TrtmntFnc10'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'GMP', 'THHSilverlink', 'THH_TrtmntFnc10'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'HHTH', 'THHSilverlink', 'THH_TrtmntFnc10'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'MVTH', 'THHSilverlink', 'THH_TrtmntFnc10'),
('/THH/SLVRLNK/TRTMNT_FNCTN', 'COMM', 'THHSilverlink', 'THH_TrtmntFnc91');

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


-- ******************** Encounter ********************

-- Concepts
SELECT @scm := dbid FROM concept WHERE id = 'THHSilverlink';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
(1, 'THH_Enc_DayCase', @scm, 'THH_Enc_DayCase', 'Day case', 'Day case'),
(1, 'THH_Enc_Inpatient', @scm, 'THH_Enc_Inpatient', 'Inpatient', 'Inpatient'),
(1, 'THH_Enc_Maternity', @scm, 'THH_Enc_Maternity', 'Maternity', 'Maternity'),
(1, 'THH_Enc_Newborn', @scm, 'THH_Enc_Newborn', 'Newborn', 'Newborn'),
(1, 'THH_Enc_RegRDayAdm', @scm, 'THH_Enc_RegRDayAdm', 'Regular day admission', 'Regular day admission'),
(1, 'THH_Enc_RegNghtAdm', @scm, 'THH_Enc_RegNghtAdm', 'Regular night admission', 'Regular night admission'),
(1, 'THH_Enc_DirectRef', @scm, 'THH_Enc_DirectRef', 'Direct referral', 'Direct referral'),
(1, 'THH_Enc_Emergency', @scm, 'THH_Enc_Emergency', 'Emergency department', 'Emergency department'),
(1, 'THH_Enc_Outpatient', @scm, 'THH_Enc_Outpatient', 'Outpatient', 'Outpatient'),
(1, 'THH_Enc_DCWL', @scm, 'THH_Enc_DCWL', 'Day case waiting list', 'Day case waiting list'),
(1, 'THH_Enc_PreReg', @scm, 'THH_Enc_PreReg', 'Preregistration', 'Preregistration'),
(1, 'THH_Enc_IPWL', @scm, 'THH_Enc_IPWL', 'Inpatient waiting list', 'Inpatient waiting list'),
(1, 'THH_Enc_PreAdmit', @scm, 'THH_Enc_PreAdmit', 'Outpatient registration', 'Outpatient registration'),
(1, 'THH_Enc_OPReferral', @scm, 'THH_Enc_OPReferral', 'Outpatient referral', 'Outpatient referral');

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_THH', 'CM_Sys_Silverlink', null, null, 'encounter_type', '/THH/SLVRLNK/ENCNTR_TYP');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/THH/SLVRLNK/ENCNTR_TYP', 'DM_admissionPatientClassification');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/THH/SLVRLNK/ENCNTR_TYP', 'DAYCASE', 'THHSilverlink', 'THH_Enc_DayCase'),
('/THH/SLVRLNK/ENCNTR_TYP', 'INPATIENT', 'THHSilverlink', 'THH_Enc_Inpatient'),
('/THH/SLVRLNK/ENCNTR_TYP', 'MATERNITY', 'THHSilverlink', 'THH_Enc_Maternity'),
('/THH/SLVRLNK/ENCNTR_TYP', 'NEWBORN', 'THHSilverlink', 'THH_Enc_Newborn'),
('/THH/SLVRLNK/ENCNTR_TYP', 'REGRDAYADM', 'THHSilverlink', 'THH_Enc_RegRDayAdm'),
('/THH/SLVRLNK/ENCNTR_TYP', 'REGNGHTADM', 'THHSilverlink', 'THH_Enc_RegNghtAdm'),
('/THH/SLVRLNK/ENCNTR_TYP', 'DIRECTREF', 'THHSilverlink', 'THH_Enc_DirectRef'),
('/THH/SLVRLNK/ENCNTR_TYP', 'EMERGENCY', 'THHSilverlink', 'THH_Enc_Emergency'),
('/THH/SLVRLNK/ENCNTR_TYP', 'OUTPATIENT', 'THHSilverlink', 'THH_Enc_Outpatient'),
('/THH/SLVRLNK/ENCNTR_TYP', 'DCWL', 'THHSilverlink', 'THH_Enc_DCWL'),
('/THH/SLVRLNK/ENCNTR_TYP', 'PREREG', 'THHSilverlink', 'THH_Enc_PreReg'),
('/THH/SLVRLNK/ENCNTR_TYP', 'IPWL', 'THHSilverlink', 'THH_Enc_IPWL'),
('/THH/SLVRLNK/ENCNTR_TYP', 'PREADMIT', 'THHSilverlink', 'THH_Enc_PreAdmit'),
('/THH/SLVRLNK/ENCNTR_TYP', 'OPREFERRAL', 'THHSilverlink', 'THH_Enc_OPReferral');