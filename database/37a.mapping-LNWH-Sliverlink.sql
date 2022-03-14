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
(1, 'CM_Sys_Silverlink', @scm, 'CM_Sys_Silverlink', 'Silverlink', 'Silverlink system'),
(1, 'LNWHSilverlink', @scm, 'LNWHSilverlink', 'LNWH Silverlink Local Codes', 'London North West Hospitals Sliverlink local code scheme');

INSERT IGNORE INTO concept_property_data
(`dbid`, `group`, `property`, `value`)
SELECT c.dbid, 0 AS `group`, p.dbid AS `property`, 'LNWH_SL_' AS `value`
FROM concept c
         JOIN concept p ON p.id = 'code_prefix'
WHERE c.id = 'LNWHSilverlink';

-- ******************** Gender ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Silverlink', null, null, 'gender', '/LNWH/SLVRLNK/GNDR');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/LNWH/SLVRLNK/GNDR', 'DM_gender');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/LNWH/SLVRLNK/GNDR', 'F', 'LNWHSilverlink', 'FHIR_AG_female'),
('/LNWH/SLVRLNK/GNDR', 'M', 'LNWHSilverlink', 'FHIR_AG_male'),
('/LNWH/SLVRLNK/GNDR', 'U', 'LNWHSilverlink', 'FHIR_AG_unknown'),
('/LNWH/SLVRLNK/GNDR', 'I', 'LNWHSilverlink', 'FHIR_AG_other');

-- ******************** Religion ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Silverlink', null, null, 'religion', '/LNWH/SLVRLNK/RLGN');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/LNWH/SLVRLNK/RLGN', 'DM_religion');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/LNWH/SLVRLNK/RLGN', 'BAHA', 'LNWHSilverlink', 'CM_ReligionA1'),
('/LNWH/SLVRLNK/RLGN', 'BUD', 'LNWHSilverlink', 'CM_ReligionB1'),
('/LNWH/SLVRLNK/RLGN', 'CHRI', 'LNWHSilverlink', 'CM_ReligionC1'),
('/LNWH/SLVRLNK/RLGN', 'ANG', 'LNWHSilverlink', 'CM_ReligionC4'),
('/LNWH/SLVRLNK/RLGN', 'AC', 'LNWHSilverlink', 'CM_ReligionC6'),
('/LNWH/SLVRLNK/RLGN', 'BAP', 'LNWHSilverlink', 'CM_ReligionC8'),
('/LNWH/SLVRLNK/RLGN', 'CH', 'LNWHSilverlink', 'CM_ReligionC16'),
('/LNWH/SLVRLNK/RLGN', 'CHSC', 'LNWHSilverlink', 'CM_ReligionC19'),
('/LNWH/SLVRLNK/RLGN', 'C/W', 'LNWHSilverlink', 'CM_ReligionC21'),
('/LNWH/SLVRLNK/RLGN', 'C/E', 'LNWHSilverlink', 'CM_ReligionC22'),
('/LNWH/SLVRLNK/RLGN', 'C/I', 'LNWHSilverlink', 'CM_ReligionC24'),
('/LNWH/SLVRLNK/RLGN', 'C/S', 'LNWHSilverlink', 'CM_ReligionC25'),
('/LNWH/SLVRLNK/RLGN', 'CONG', 'LNWHSilverlink', 'CM_ReligionC26'),
('/LNWH/SLVRLNK/RLGN', 'COPO', 'LNWHSilverlink', 'CM_ReligionC27'),
('/LNWH/SLVRLNK/RLGN', 'EVAN', 'LNWHSilverlink', 'CM_ReligionC32'),
('/LNWH/SLVRLNK/RLGN', 'ORTH', 'LNWHSilverlink', 'CM_ReligionC41'),
('/LNWH/SLVRLNK/RLGN', 'JWIT', 'LNWHSilverlink', 'CM_ReligionC44'),
('/LNWH/SLVRLNK/RLGN', 'LUTH', 'LNWHSilverlink', 'CM_ReligionC46'),
('/LNWH/SLVRLNK/RLGN', 'METH', 'LNWHSilverlink', 'CM_ReligionC49'),
('/LNWH/SLVRLNK/RLGN', 'MOR', 'LNWHSilverlink', 'CM_ReligionC50'),
('/LNWH/SLVRLNK/RLGN', 'MORM', 'LNWHSilverlink', 'CM_ReligionC51'),
('/LNWH/SLVRLNK/RLGN', 'NT', 'LNWHSilverlink', 'CM_ReligionC53'),
('/LNWH/SLVRLNK/RLGN', 'N/C', 'LNWHSilverlink', 'CM_ReligionC54'),
('/LNWH/SLVRLNK/RLGN', 'PRES', 'LNWHSilverlink', 'CM_ReligionC59'),
('/LNWH/SLVRLNK/RLGN', 'PROT', 'LNWHSilverlink', 'CM_ReligionC60'),
('/LNWH/SLVRLNK/RLGN', 'PB', 'LNWHSilverlink', 'CM_ReligionC61'),
('/LNWH/SLVRLNK/RLGN', 'QUAK', 'LNWHSilverlink', 'CM_ReligionC62'),
('/LNWH/SLVRLNK/RLGN', 'RAST', 'LNWHSilverlink', 'CM_ReligionC63'),
('/LNWH/SLVRLNK/RLGN', 'R/C', 'LNWHSilverlink', 'CM_ReligionC67'),
('/LNWH/SLVRLNK/RLGN', 'R/O', 'LNWHSilverlink', 'CM_ReligionC68'),
('/LNWH/SLVRLNK/RLGN', 'RUS', 'LNWHSilverlink', 'CM_ReligionC69'),
('/LNWH/SLVRLNK/RLGN', 'SALV', 'LNWHSilverlink', 'CM_ReligionC70'),
('/LNWH/SLVRLNK/RLGN', 'S/O', 'LNWHSilverlink', 'CM_ReligionC72'),
('/LNWH/SLVRLNK/RLGN', 'SDA', 'LNWHSilverlink', 'CM_ReligionC73'),
('/LNWH/SLVRLNK/RLGN', 'UN', 'LNWHSilverlink', 'CM_ReligionC78'),
('/LNWH/SLVRLNK/RLGN', 'URC', 'LNWHSilverlink', 'CM_ReligionC79'),
('/LNWH/SLVRLNK/RLGN', 'HIN', 'LNWHSilverlink', 'CM_ReligionD1'),
('/LNWH/SLVRLNK/RLGN', 'JAIN', 'LNWHSilverlink', 'CM_ReligionE1'),
('/LNWH/SLVRLNK/RLGN', 'JEW', 'LNWHSilverlink', 'CM_ReligionF1'),
('/LNWH/SLVRLNK/RLGN', 'MUS', 'LNWHSilverlink', 'CM_ReligionG1'),
('/LNWH/SLVRLNK/RLGN', 'PAGA', 'LNWHSilverlink', 'CM_ReligionH1'),
('/LNWH/SLVRLNK/RLGN', 'DRUI', 'LNWHSilverlink', 'CM_ReligionH4'),
('/LNWH/SLVRLNK/RLGN', 'WIC', 'LNWHSilverlink', 'CM_ReligionH9'),
('/LNWH/SLVRLNK/RLGN', 'SIKH', 'LNWHSilverlink', 'CM_ReligionI1'),
('/LNWH/SLVRLNK/RLGN', 'ZORO', 'LNWHSilverlink', 'CM_ReligionJ1'),
('/LNWH/SLVRLNK/RLGN', 'AGN', 'LNWHSilverlink', 'CM_ReligionK1'),
('/LNWH/SLVRLNK/RLGN', 'HMST', 'LNWHSilverlink', 'CM_ReligionK11'),
('/LNWH/SLVRLNK/RLGN', 'OTH', 'LNWHSilverlink', 'CM_ReligionK20'),
('/LNWH/SLVRLNK/RLGN', 'SPIR', 'LNWHSilverlink', 'CM_ReligionK27'),
('/LNWH/SLVRLNK/RLGN', 'UN', 'LNWHSilverlink', 'CM_ReligionK30'),
('/LNWH/SLVRLNK/RLGN', 'ATH', 'LNWHSilverlink', 'CM_ReligionL1'),
('/LNWH/SLVRLNK/RLGN', 'UNK', 'LNWHSilverlink', 'CM_ReligionN1');

-- ******************** Ethnicity ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Silverlink', null, null, 'ethnicity', '/CDS/PTNT/ETHNC_CTGRY');

-- ******************** Admission Method ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Silverlink', null, null, 'admission_method_code', '/CDS/INPTNT/ADMSSN_MTHD');

-- ******************** Admission Source ********************
-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Silverlink', null, null, 'admission_source_code', '/CDS/INPTNT/ADMSSN_SRC');

-- ******************** Discharge Method ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Silverlink', null, null, 'discharge_method', '/CDS/INPTNT/DSCHRG_MTHD');

-- ******************** Discharge Destination ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Silverlink', null, null, 'discharge_destination_code', '/CDS/INPTNT/DSCHRG_DSTNTN');

-- ******************** Treatment Function ********************
-- ************ MISSING SPECIALITIES ****************
-- Concepts
SELECT @scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
(1, 'CM_TrtmntFnc821', @scm, 'CM_TrtmntFnc821', 'Blood Transfusion', 'Blood Transfusion'),
(1, 'CM_TrtmntFnc833', @scm, 'CM_TrtmntFnc833', 'Medical Microbiology', 'Medical Microbiology');

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Silverlink', null, null, 'treatment_function_code', '/LNWH/SLVRLNK/TRTMNT_FNCTN');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'DM_treatmentFunctionAdmit');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/LNWH/SLVRLNK/TRTMNT_FNCTN', '180', 'LNWHSilverlink', 'CM_TrtmntFnc180'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'A/E', 'LNWHSilverlink', 'CM_TrtmntFnc180'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'A/THERAPY', 'LNWHSilverlink', 'CM_TrtmntFnc660'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'ACUMED', 'LNWHSilverlink', 'CM_TrtmntFnc326'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'ADULTCF', 'LNWHSilverlink', 'CM_TrtmntFnc343'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'ADULTOT', 'LNWHSilverlink', 'CM_TrtmntFnc651'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'ADULTPT', 'LNWHSilverlink', 'CM_TrtmntFnc650'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'ADULTSLT', 'LNWHSilverlink', 'CM_TrtmntFnc652'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'ALLERGY', 'LNWHSilverlink', 'CM_TrtmntFnc317'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'ANAES', 'LNWHSilverlink', 'CM_TrtmntFnc190'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'ASM', 'LNWHSilverlink', 'CM_TrtmntFnc200'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'AUDIO', 'LNWHSilverlink', 'CM_TrtmntFnc310'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'BCS', 'LNWHSilverlink', 'CM_TrtmntFnc301'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'BCSP', 'LNWHSilverlink', 'CM_TrtmntFnc301'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'BLOODTRAN', 'LNWHSilverlink', 'CM_TrtmntFnc821'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'BONDIS', 'LNWHSilverlink', 'CM_TrtmntFnc110'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'BREAST', 'LNWHSilverlink', 'CM_TrtmntFnc103'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'BSS', 'LNWHSilverlink', 'CM_TrtmntFnc301'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'C/APSYCH', 'LNWHSilverlink', 'CM_TrtmntFnc711'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'C/SERVICES', 'LNWHSilverlink', 'CM_TrtmntFnc658'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'CARD/REHAB', 'LNWHSilverlink', 'CM_TrtmntFnc327'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'CARDIO', 'LNWHSilverlink', 'CM_TrtmntFnc320'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'CARDSURG', 'LNWHSilverlink', 'CM_TrtmntFnc170'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'CCN', 'LNWHSilverlink', 'CM_TrtmntFnc290'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'CHEMPATH', 'LNWHSilverlink', 'CM_TrtmntFnc822'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'CHIROPODY', 'LNWHSilverlink', 'CM_TrtmntFnc653'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'CLINGEN', 'LNWHSilverlink', 'CM_TrtmntFnc311'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'CLINHAEM', 'LNWHSilverlink', 'CM_TrtmntFnc303'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'CLINIMMU', 'LNWHSilverlink', 'CM_TrtmntFnc316'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'CLINONCO', 'LNWHSilverlink', 'CM_TrtmntFnc800'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'CLINPHAR', 'LNWHSilverlink', 'CM_TrtmntFnc305'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'CLINPHYS', 'LNWHSilverlink', 'CM_TrtmntFnc304'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'CLINPSYC', 'LNWHSilverlink', 'CM_TrtmntFnc656'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'COL', 'LNWHSilverlink', 'CM_TrtmntFnc502'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'COM', 'LNWHSilverlink', 'CM_TrtmntFnc560'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'COMMED', 'LNWHSilverlink', 'CM_TrtmntFnc300'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'COMMEND', 'LNWHSilverlink', 'CM_TrtmntFnc900'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'COMSERV', 'LNWHSilverlink', 'CM_TrtmntFnc900'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'DENMED', 'LNWHSilverlink', 'CM_TrtmntFnc450'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'DENORTH', 'LNWHSilverlink', 'CM_TrtmntFnc143'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'DENTAL', 'LNWHSilverlink', 'CM_TrtmntFnc140'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'DERM', 'LNWHSilverlink', 'CM_TrtmntFnc330'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'DIAB', 'LNWHSilverlink', 'CM_TrtmntFnc307'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'DIAB/ES', 'LNWHSilverlink', 'CM_TrtmntFnc920'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'DIAGNOSI', 'LNWHSilverlink', 'CM_TrtmntFnc812'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'DIET', 'LNWHSilverlink', 'CM_TrtmntFnc654'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'DIETETICS', 'LNWHSilverlink', 'CM_TrtmntFnc654'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'DRAMA', 'LNWHSilverlink', 'CM_TrtmntFnc659'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EDUCATE', 'LNWHSilverlink', 'CM_TrtmntFnc290'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT01', 'LNWHSilverlink', 'CM_TrtmntFnc180'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT02', 'LNWHSilverlink', 'CM_TrtmntFnc190'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT03', 'LNWHSilverlink', 'CM_TrtmntFnc310'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT04', 'LNWHSilverlink', 'CM_TrtmntFnc320'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT05', 'LNWHSilverlink', 'CM_TrtmntFnc330'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT06', 'LNWHSilverlink', 'CM_TrtmntFnc302'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT07', 'LNWHSilverlink', 'CM_TrtmntFnc120'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT08', 'LNWHSilverlink', 'CM_TrtmntFnc301'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT09', 'LNWHSilverlink', 'CM_TrtmntFnc300'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT10', 'LNWHSilverlink', 'CM_TrtmntFnc100'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT11', 'LNWHSilverlink', 'CM_TrtmntFnc360'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT12', 'LNWHSilverlink', 'CM_TrtmntFnc430'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT13', 'LNWHSilverlink', 'CM_TrtmntFnc502'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT15', 'LNWHSilverlink', 'CM_TrtmntFnc361'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT16', 'LNWHSilverlink', 'CM_TrtmntFnc400'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT18', 'LNWHSilverlink', 'CM_TrtmntFnc901'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT20', 'LNWHSilverlink', 'CM_TrtmntFnc140'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT22', 'LNWHSilverlink', 'CM_TrtmntFnc110'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT23', 'LNWHSilverlink', 'CM_TrtmntFnc259'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT24', 'LNWHSilverlink', 'CM_TrtmntFnc410'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT25', 'LNWHSilverlink', 'CM_TrtmntFnc800'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT26', 'LNWHSilverlink', 'CM_TrtmntFnc410'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT27', 'LNWHSilverlink', 'CM_TrtmntFnc340'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT28', 'LNWHSilverlink', 'CM_TrtmntFnc101'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT29', 'LNWHSilverlink', 'CM_TrtmntFnc350'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT30', 'LNWHSilverlink', 'CM_TrtmntFnc315'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT31', 'LNWHSilverlink', 'CM_TrtmntFnc321'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT34', 'LNWHSilverlink', 'CM_TrtmntFnc257'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT36', 'LNWHSilverlink', 'CM_TrtmntFnc822'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT37', 'LNWHSilverlink', 'CM_TrtmntFnc307'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT38', 'LNWHSilverlink', 'CM_TrtmntFnc722'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT40', 'LNWHSilverlink', 'CM_TrtmntFnc501'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT41', 'LNWHSilverlink', 'CM_TrtmntFnc653'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT43', 'LNWHSilverlink', 'CM_TrtmntFnc100'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT44', 'LNWHSilverlink', 'CM_TrtmntFnc653'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT47', 'LNWHSilverlink', 'CM_TrtmntFnc303'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT49', 'LNWHSilverlink', 'CM_TrtmntFnc191'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT50', 'LNWHSilverlink', 'CM_TrtmntFnc503'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT51', 'LNWHSilverlink', 'CM_TrtmntFnc370'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT52', 'LNWHSilverlink', 'CM_TrtmntFnc370'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT53', 'LNWHSilverlink', 'CM_TrtmntFnc324'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT66', 'LNWHSilverlink', 'CM_TrtmntFnc192'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT86', 'LNWHSilverlink', 'CM_TrtmntFnc103'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT88', 'LNWHSilverlink', 'CM_TrtmntFnc950'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT89', 'LNWHSilverlink', 'CM_TrtmntFnc950'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT90', 'LNWHSilverlink', 'CM_TrtmntFnc657'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT92', 'LNWHSilverlink', 'CM_TrtmntFnc502'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT94', 'LNWHSilverlink', 'CM_TrtmntFnc650'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT95', 'LNWHSilverlink', 'CM_TrtmntFnc320'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EHT97', 'LNWHSilverlink', 'CM_TrtmntFnc654'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EIMOS', 'LNWHSilverlink', 'CM_TrtmntFnc140'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'ENDO', 'LNWHSilverlink', 'CM_TrtmntFnc302'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'ENT', 'LNWHSilverlink', 'CM_TrtmntFnc120'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'EYES', 'LNWHSilverlink', 'CM_TrtmntFnc130'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'FORENS/P', 'LNWHSilverlink', 'CM_TrtmntFnc712'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'G/COLOPR', 'LNWHSilverlink', 'CM_TrtmntFnc301'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'GASTRO', 'LNWHSilverlink', 'CM_TrtmntFnc301'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'GENMD-HASU', 'LNWHSilverlink', 'CM_TrtmntFnc328'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'GENMD-SU', 'LNWHSilverlink', 'CM_TrtmntFnc328'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'GENMED', 'LNWHSilverlink', 'CM_TrtmntFnc300'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'GENPATH', 'LNWHSilverlink', 'CM_TrtmntFnc820'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'GENPRAC', 'LNWHSilverlink', 'CM_TrtmntFnc300'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'GENSURG', 'LNWHSilverlink', 'CM_TrtmntFnc100'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'GERIMED', 'LNWHSilverlink', 'CM_TrtmntFnc430'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'GERIM-OPAL', 'LNWHSilverlink', 'CM_TrtmntFnc430'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'GPPHYSIO', 'LNWHSilverlink', 'CM_TrtmntFnc650'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'GUM', 'LNWHSilverlink', 'CM_TrtmntFnc360'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'GYNAE', 'LNWHSilverlink', 'CM_TrtmntFnc502'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'HAEM', 'LNWHSilverlink', 'CM_TrtmntFnc303'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'HEALTHYB', 'LNWHSilverlink', 'CM_TrtmntFnc424'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'HISTOPAT', 'LNWHSilverlink', 'CM_TrtmntFnc824'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'IMC', 'LNWHSilverlink', 'CM_TrtmntFnc318'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'IMMUN', 'LNWHSilverlink', 'CM_TrtmntFnc316'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'IMMUPATH', 'LNWHSilverlink', 'CM_TrtmntFnc316'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'IMOS', 'LNWHSilverlink', 'CM_TrtmntFnc140'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'INF/MED', 'LNWHSilverlink', 'CM_TrtmntFnc301'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'INF/SURG', 'LNWHSilverlink', 'CM_TrtmntFnc104'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'INFDIS', 'LNWHSilverlink', 'CM_TrtmntFnc350'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'IRADIO', 'LNWHSilverlink', 'CM_TrtmntFnc811'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'ITUMED', 'LNWHSilverlink', 'CM_TrtmntFnc192'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'M/THERAPY', 'LNWHSilverlink', 'CM_TrtmntFnc661'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'MEDONC', 'LNWHSilverlink', 'CM_TrtmntFnc370'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'MEDOPHTH', 'LNWHSilverlink', 'CM_TrtmntFnc460'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'MEDVIRO', 'LNWHSilverlink', 'CM_TrtmntFnc834'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'MENTHAND', 'LNWHSilverlink', 'CM_TrtmntFnc700'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'MENTILL', 'LNWHSilverlink', 'CM_TrtmntFnc710'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'MIC', 'LNWHSilverlink', 'CM_TrtmntFnc833'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'MIDWIFE', 'LNWHSilverlink', 'CM_TrtmntFnc560'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'NELENT', 'LNWHSilverlink', 'CM_TrtmntFnc120'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'NEONAT', 'LNWHSilverlink', 'CM_TrtmntFnc422'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'NEPHRO', 'LNWHSilverlink', 'CM_TrtmntFnc361'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'NEURO', 'LNWHSilverlink', 'CM_TrtmntFnc400'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'NEUROSUR', 'LNWHSilverlink', 'CM_TrtmntFnc150'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'NPY', 'LNWHSilverlink', 'CM_TrtmntFnc401'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'NUCLEAR', 'LNWHSilverlink', 'CM_TrtmntFnc371'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'OBS', 'LNWHSilverlink', 'CM_TrtmntFnc501'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'OBS PN', 'LNWHSilverlink', 'CM_TrtmntFnc501'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'OBSAN', 'LNWHSilverlink', 'CM_TrtmntFnc501'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'OBSCS', 'LNWHSilverlink', 'CM_TrtmntFnc501'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'OCCU/MED', 'LNWHSilverlink', 'CM_TrtmntFnc901'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'OMFS', 'LNWHSilverlink', 'CM_TrtmntFnc145'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'OPTO', 'LNWHSilverlink', 'CM_TrtmntFnc662'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'ORTHOTIC', 'LNWHSilverlink', 'CM_TrtmntFnc658'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAED', 'LNWHSilverlink', 'CM_TrtmntFnc420'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAED/COMM', 'LNWHSilverlink', 'CM_TrtmntFnc290'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDCARD', 'LNWHSilverlink', 'CM_TrtmntFnc321'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDCF', 'LNWHSilverlink', 'CM_TrtmntFnc264'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDCLINIA', 'LNWHSilverlink', 'CM_TrtmntFnc255'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDDENT', 'LNWHSilverlink', 'CM_TrtmntFnc142'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDDERM', 'LNWHSilverlink', 'CM_TrtmntFnc257'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDDM', 'LNWHSilverlink', 'CM_TrtmntFnc263'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDENDO', 'LNWHSilverlink', 'CM_TrtmntFnc252'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDGASTRO', 'LNWHSilverlink', 'CM_TrtmntFnc213'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDINFD', 'LNWHSilverlink', 'CM_TrtmntFnc256'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDMEDONC', 'LNWHSilverlink', 'CM_TrtmntFnc260'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDNEPHRO', 'LNWHSilverlink', 'CM_TrtmntFnc259'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDNEUR', 'LNWHSilverlink', 'CM_TrtmntFnc421'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDNEUROD', 'LNWHSilverlink', 'CM_TrtmntFnc291'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDOT', 'LNWHSilverlink', 'CM_TrtmntFnc651'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDPT', 'LNWHSilverlink', 'CM_TrtmntFnc650'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDRESM', 'LNWHSilverlink', 'CM_TrtmntFnc258'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDRHEUM', 'LNWHSilverlink', 'CM_TrtmntFnc262'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDS', 'LNWHSilverlink', 'CM_TrtmntFnc420'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDSLT', 'LNWHSilverlink', 'CM_TrtmntFnc652'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAEDSURG', 'LNWHSilverlink', 'CM_TrtmntFnc171'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PAINMAN', 'LNWHSilverlink', 'CM_TrtmntFnc191'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PALL/MED', 'LNWHSilverlink', 'CM_TrtmntFnc315'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PHTSIO', 'LNWHSilverlink', 'CM_TrtmntFnc650'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PHYSIORR', 'LNWHSilverlink', 'CM_TrtmntFnc650'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PLASURG', 'LNWHSilverlink', 'CM_TrtmntFnc160'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PODIATRY', 'LNWHSilverlink', 'CM_TrtmntFnc653'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'POSTCOVID', 'LNWHSilverlink', 'CM_TrtmntFnc348'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PPR', 'LNWHSilverlink', 'CM_TrtmntFnc342'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PROS', 'LNWHSilverlink', 'CM_TrtmntFnc657'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PSYCHO', 'LNWHSilverlink', 'CM_TrtmntFnc713'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PSYCHO/T', 'LNWHSilverlink', 'CM_TrtmntFnc713'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'PSYGERI', 'LNWHSilverlink', 'CM_TrtmntFnc715'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'RADIO', 'LNWHSilverlink', 'CM_TrtmntFnc812'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'REHAB', 'LNWHSilverlink', 'CM_TrtmntFnc314'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'RESDENT', 'LNWHSilverlink', 'CM_TrtmntFnc141'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'RESPHYS', 'LNWHSilverlink', 'CM_TrtmntFnc341'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'RHEUM', 'LNWHSilverlink', 'CM_TrtmntFnc410'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'RHEUM/RE', 'LNWHSilverlink', 'CM_TrtmntFnc410'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'RHEUMRES', 'LNWHSilverlink', 'CM_TrtmntFnc410'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'RHEUMRR', 'LNWHSilverlink', 'CM_TrtmntFnc410'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'S/COLOPR', 'LNWHSilverlink', 'CM_TrtmntFnc104'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'SP/CARE', 'LNWHSilverlink', 'CM_TrtmntFnc422'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'SPEECH', 'LNWHSilverlink', 'CM_TrtmntFnc652'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'SPORT/EM', 'LNWHSilverlink', 'CM_TrtmntFnc325'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'STOMA', 'LNWHSilverlink', 'CM_TrtmntFnc104'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'STROKE/MED', 'LNWHSilverlink', 'CM_TrtmntFnc328'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'THORMED', 'LNWHSilverlink', 'CM_TrtmntFnc340'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'TIA', 'LNWHSilverlink', 'CM_TrtmntFnc329'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'TR/ORTHO', 'LNWHSilverlink', 'CM_TrtmntFnc110'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'TRANSURG', 'LNWHSilverlink', 'CM_TrtmntFnc102'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'TROP/MED', 'LNWHSilverlink', 'CM_TrtmntFnc352'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'UROLOGY', 'LNWHSilverlink', 'CM_TrtmntFnc101'),
('/LNWH/SLVRLNK/TRTMNT_FNCTN', 'VASSURG', 'LNWHSilverlink', 'CM_TrtmntFnc107');

-- ******************** Language ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Silverlink', null, null, 'language', '/LNWH/SLVRLNK/LNGG');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/LNWH/SLVRLNK/LNGG', 'DM_language');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/LNWH/SLVRLNK/LNGG', 'ARA', 'LNWHSilverlink', 'FHIR_LANG_ar'),
('/LNWH/SLVRLNK/LNGG', 'BENG', 'LNWHSilverlink', 'FHIR_LANG_bn'),
('/LNWH/SLVRLNK/LNGG', 'GER', 'LNWHSilverlink', 'FHIR_LANG_de'),
('/LNWH/SLVRLNK/LNGG', 'GRE', 'LNWHSilverlink', 'FHIR_LANG_el'),
('/LNWH/SLVRLNK/LNGG', 'ENG', 'LNWHSilverlink', 'FHIR_LANG_en'),
('/LNWH/SLVRLNK/LNGG', 'SPA', 'LNWHSilverlink', 'FHIR_LANG_es'),
('/LNWH/SLVRLNK/LNGG', 'FRE', 'LNWHSilverlink', 'FHIR_LANG_fr'),
('/LNWH/SLVRLNK/LNGG', 'GUJ', 'LNWHSilverlink', 'FHIR_LANG_gu'),
('/LNWH/SLVRLNK/LNGG', 'HEB', 'LNWHSilverlink', 'FHIR_LANG_he'),
('/LNWH/SLVRLNK/LNGG', 'HIN', 'LNWHSilverlink', 'FHIR_LANG_hi'),
('/LNWH/SLVRLNK/LNGG', 'ITI', 'LNWHSilverlink', 'FHIR_LANG_it'),
('/LNWH/SLVRLNK/LNGG', 'JAP', 'LNWHSilverlink', 'FHIR_LANG_ja'),
('/LNWH/SLVRLNK/LNGG', 'KOR', 'LNWHSilverlink', 'FHIR_LANG_ko'),
('/LNWH/SLVRLNK/LNGG', 'DUT', 'LNWHSilverlink', 'FHIR_LANG_nl'),
('/LNWH/SLVRLNK/LNGG', 'PUN', 'LNWHSilverlink', 'FHIR_LANG_pa'),
('/LNWH/SLVRLNK/LNGG', 'POL', 'LNWHSilverlink', 'FHIR_LANG_pl'),
('/LNWH/SLVRLNK/LNGG', 'PASH', 'LNWHSilverlink', 'FHIR_LANG_ps'),
('/LNWH/SLVRLNK/LNGG', 'POR', 'LNWHSilverlink', 'FHIR_LANG_pt'),
('/LNWH/SLVRLNK/LNGG', 'RUSS', 'LNWHSilverlink', 'FHIR_LANG_ru'),
('/LNWH/SLVRLNK/LNGG', 'SING', 'LNWHSilverlink', 'FHIR_LANG_si'),
('/LNWH/SLVRLNK/LNGG', 'SOM', 'LNWHSilverlink', 'FHIR_LANG_so'),
('/LNWH/SLVRLNK/LNGG', 'ALB', 'LNWHSilverlink', 'FHIR_LANG_sq'),
('/LNWH/SLVRLNK/LNGG', 'SWAH', 'LNWHSilverlink', 'FHIR_LANG_sw'),
('/LNWH/SLVRLNK/LNGG', 'TAM', 'LNWHSilverlink', 'FHIR_LANG_ta'),
('/LNWH/SLVRLNK/LNGG', 'TURK', 'LNWHSilverlink', 'FHIR_LANG_tr'),
('/LNWH/SLVRLNK/LNGG', 'URD', 'LNWHSilverlink', 'FHIR_LANG_ur'),
('/LNWH/SLVRLNK/LNGG', 'VIE', 'LNWHSilverlink', 'FHIR_LANG_vi'),
('/LNWH/SLVRLNK/LNGG', 'DBSL', 'LNWHSilverlink', 'FHIR_LANG_q4');

-- ******************** Encounter ********************

-- Concepts
SELECT @scm := dbid FROM concept WHERE id = 'LNWHSilverlink';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
(1, 'LNWH_SL_Enc_DayCase', @scm, 'LNWH_SL_Enc_DayCase', 'Day case', 'Day case'),
(1, 'LNWH_SL_Enc_Inpatient', @scm, 'LNWH_SL_Enc_Inpatient', 'Inpatient', 'Inpatient'),
(1, 'LNWH_SL_Enc_Maternity', @scm, 'LNWH_SL_Enc_Maternity', 'Maternity', 'Maternity'),
(1, 'LNWH_SL_Enc_Newborn', @scm, 'LNWH_SL_Enc_Newborn', 'Newborn', 'Newborn'),
(1, 'LNWH_SL_Enc_RegRDayAdm', @scm, 'LNWH_SL_Enc_RegRDayAdm', 'Regular day admission', 'Regular day admission'),
(1, 'LNWH_SL_Enc_RegNghtAdm', @scm, 'LNWH_SL_Enc_RegNghtAdm', 'Regular night admission', 'Regular night admission'),
(1, 'LNWH_SL_Enc_DirectRef', @scm, 'LNWH_SL_Enc_DirectRef', 'Direct referral', 'Direct referral'),
(1, 'LNWH_SL_Enc_Emergency', @scm, 'LNWH_SL_Enc_Emergency', 'Emergency department', 'Emergency department'),
(1, 'LNWH_SL_Enc_Outpatient', @scm, 'LNWH_SL_Enc_Outpatient', 'Outpatient', 'Outpatient'),
(1, 'LNWH_SL_Enc_DCWL', @scm, 'LNWH_SL_Enc_DCWL', 'Day case waiting list', 'Day case waiting list'),
(1, 'LNWH_SL_Enc_PreReg', @scm, 'LNWH_SL_Enc_PreReg', 'Preregistration', 'Preregistration'),
(1, 'LNWH_SL_Enc_IPWL', @scm, 'LNWH_SL_Enc_IPWL', 'Inpatient waiting list', 'Inpatient waiting list'),
(1, 'LNWH_SL_Enc_PreAdmit', @scm, 'LNWH_SL_Enc_PreAdmit', 'Outpatient registration', 'Outpatient registration'),
(1, 'LNWH_SL_Enc_OPReferral', @scm, 'LNWH_SL_Enc_OPReferral', 'Outpatient referral', 'Outpatient referral');

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Silverlink', null, null, 'encounter_type', '/LNWH/SLVRLNK/ENCNTR_TYP');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/LNWH/SLVRLNK/ENCNTR_TYP', 'DM_admissionPatientClassification');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/LNWH/SLVRLNK/ENCNTR_TYP', 'DAYCASE', 'LNWHSilverlink', 'LNWH_SL_Enc_DayCase'),
('/LNWH/SLVRLNK/ENCNTR_TYP', 'INPATIENT', 'LNWHSilverlink', 'LNWH_SL_Enc_Inpatient'),
('/LNWH/SLVRLNK/ENCNTR_TYP', 'MATERNITY', 'LNWHSilverlink', 'LNWH_SL_Enc_Maternity'),
('/LNWH/SLVRLNK/ENCNTR_TYP', 'NEWBORN', 'LNWHSilverlink', 'LNWH_SL_Enc_Newborn'),
('/LNWH/SLVRLNK/ENCNTR_TYP', 'REGRDAYADM', 'LNWHSilverlink', 'LNWH_SL_Enc_RegRDayAdm'),
('/LNWH/SLVRLNK/ENCNTR_TYP', 'REGNGHTADM', 'LNWHSilverlink', 'LNWH_SL_Enc_RegNghtAdm'),
('/LNWH/SLVRLNK/ENCNTR_TYP', 'DIRECTREF', 'LNWHSilverlink', 'LNWH_SL_Enc_DirectRef'),
('/LNWH/SLVRLNK/ENCNTR_TYP', 'EMERGENCY', 'LNWHSilverlink', 'LNWH_SL_Enc_Emergency'),
('/LNWH/SLVRLNK/ENCNTR_TYP', 'OUTPATIENT', 'LNWHSilverlink', 'LNWH_SL_Enc_Outpatient'),
('/LNWH/SLVRLNK/ENCNTR_TYP', 'DCWL', 'LNWHSilverlink', 'LNWH_SL_Enc_DCWL'),
('/LNWH/SLVRLNK/ENCNTR_TYP', 'PREREG', 'LNWHSilverlink', 'LNWH_SL_Enc_PreReg'),
('/LNWH/SLVRLNK/ENCNTR_TYP', 'IPWL', 'LNWHSilverlink', 'LNWH_SL_Enc_IPWL'),
('/LNWH/SLVRLNK/ENCNTR_TYP', 'PREADMIT', 'LNWHSilverlink', 'LNWH_SL_Enc_PreAdmit'),
('/LNWH/SLVRLNK/ENCNTR_TYP', 'OPREFERRAL', 'LNWHSilverlink', 'LNWH_SL_Enc_OPReferral');
