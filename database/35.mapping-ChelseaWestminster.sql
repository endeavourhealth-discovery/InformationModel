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
(1, 'CM_Org_CWH', @scm, 'CM_Org_CWH', 'Chelsea & Westminster', 'Chelsea and Westminster Hospital, London'),
(1, 'CM_Sys_Cerner', @scm, 'CM_Sys_Cerner', 'Cerner Millennium', 'Cerner Millennium system'),
(1, 'CWHCerner', @scm, 'CWHCerner', 'Chelsea & Westminster Local Codes', 'Chelsea & Westminster Cerner local code scheme'),
(1, 'DM_patientFIN', @scm, 'DM_patientFIN', 'Patient FIN', 'Patient FIN'),
(1, 'CM_GPPractitionerId', @scm, 'CM_GPPractitionerId', 'GP Practitioner Id', 'GP Practitioner Id');

INSERT IGNORE INTO concept_property_data
(`dbid`, `group`, `property`, `value`)
SELECT c.dbid, 0 AS `group`, p.dbid AS `property`, 'CWH_' AS `value`
FROM concept c
         JOIN concept p ON p.id = 'code_prefix'
WHERE c.id = 'CWHCerner';
-- ******************** Religion ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_CWH', 'CM_Sys_Cerner', null, null, 'religion', '/CWH/CRNR/RLGN');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/CWH/CRNR/RLGN', 'DM_religion');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/CWH/CRNR/RLGN', 'HINDU', 'CWHCerner', 'CM_ReligionD1'),
('/CWH/CRNR/RLGN', 'OTHER', 'CWHCerner', 'CM_ReligionK20'),
('/CWH/CRNR/RLGN', 'SIKH', 'CWHCerner', 'CM_ReligionI1'),
('/CWH/CRNR/RLGN', 'A', 'CWHCerner', 'CM_ReligionA1'),
('/CWH/CRNR/RLGN', 'BUDDHISM', 'CWHCerner', 'CM_ReligionB1'),
('/CWH/CRNR/RLGN', 'CHRISTIAN', 'CWHCerner', 'CM_ReligionC1'),
('/CWH/CRNR/RLGN', 'M', 'CWHCerner', 'CM_ReligionM1'),
('/CWH/CRNR/RLGN', 'E', 'CWHCerner', 'CM_ReligionE1'),
('/CWH/CRNR/RLGN', 'JUDAISM', 'CWHCerner', 'CM_ReligionF1'),
('/CWH/CRNR/RLGN', 'G', 'CWHCerner', 'CM_ReligionG1'),
('/CWH/CRNR/RLGN', 'L', 'CWHCerner', 'CM_ReligionL2'),
('/CWH/CRNR/RLGN', 'H', 'CWHCerner', 'CM_ReligionH1'),
('/CWH/CRNR/RLGN', 'N', 'CWHCerner', 'CM_ReligionN1'),
('/CWH/CRNR/RLGN', 'J', 'CWHCerner', 'CM_ReligionJ1'),
('/CWH/CRNR/RLGN', 'GREEKORTH', 'CWHCerner', 'CM_ReligionC41'),
('/CWH/CRNR/RLGN', 'RCATHOLIC', 'CWHCerner', 'CM_ReligionC67');


-- ******************** Language ********************

-- Concepts
SELECT @scm := dbid FROM concept WHERE id = 'CWHCerner';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
(1, 'CWH_Lang_8', @scm, 'CWH_Lang_8', 'Cantonese', 'Cantonese'),
(1, 'CWH_Lang_10', @scm, 'CWH_Lang_10', 'Creole', 'Creole'),
(1, 'CWH_Lang_13', @scm, 'CWH_Lang_13', 'Ethiopian', 'Ethiopian'),
(1, 'CWH_Lang_18', @scm, 'CWH_Lang_18', 'French Creole', 'French Creole'),
(1, 'CWH_Lang_23', @scm, 'CWH_Lang_23', 'Hakka', 'Hakka'),
(1, 'CWH_Lang_33', @scm, 'CWH_Lang_33', 'Luganda', 'Luganda'),
(1, 'CWH_Lang_36', @scm, 'CWH_Lang_36', 'Mandarin', 'Mandarin'),
(1, 'CWH_Lang_200', @scm, 'CWH_Lang_200', 'Other', 'Other'),
(1, 'CWH_Lang_39', @scm, 'CWH_Lang_39', 'Patois', 'Patois'),
(1, 'CWH_Lang_44', @scm, 'CWH_Lang_44', 'Serbo-Croat', 'Serbo-Croat'),
(1, 'CWH_Lang_51', @scm, 'CWH_Lang_51', 'Sylheti', 'Sylheti');

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_CWH', 'CM_Sys_Cerner', null, null, 'language', '/CWH/CRNR/LNGG');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/CWH/CRNR/LNGG', 'DM_language');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/CWH/CRNR/LNGG', '1', 'CWHCerner', 'FHIR_LANG_ak'),
('/CWH/CRNR/LNGG', '3', 'CWHCerner', 'FHIR_LANG_am'),
('/CWH/CRNR/LNGG', '4', 'CWHCerner', 'FHIR_LANG_ar'),
('/CWH/CRNR/LNGG', '5', 'CWHCerner', 'FHIR_LANG_bn'),
('/CWH/CRNR/LNGG', '59', 'CWHCerner', 'FHIR_LANG_cy'),
('/CWH/CRNR/LNGG', '20', 'CWHCerner', 'FHIR_LANG_de'),
('/CWH/CRNR/LNGG', '21', 'CWHCerner', 'FHIR_LANG_el'),
('/CWH/CRNR/LNGG', '12', 'CWHCerner', 'FHIR_LANG_en'),
('/CWH/CRNR/LNGG', '48', 'CWHCerner', 'FHIR_LANG_es'),
('/CWH/CRNR/LNGG', '14', 'CWHCerner', 'FHIR_LANG_fa'),
('/CWH/CRNR/LNGG', '15', 'CWHCerner', 'FHIR_LANG_fi'),
('/CWH/CRNR/LNGG', '17', 'CWHCerner', 'FHIR_LANG_fr'),
('/CWH/CRNR/LNGG', '19', 'CWHCerner', 'FHIR_LANG_gd'),
('/CWH/CRNR/LNGG', '22', 'CWHCerner', 'FHIR_LANG_gu'),
('/CWH/CRNR/LNGG', '24', 'CWHCerner', 'FHIR_LANG_ha'),
('/CWH/CRNR/LNGG', '25', 'CWHCerner', 'FHIR_LANG_he'),
('/CWH/CRNR/LNGG', '26', 'CWHCerner', 'FHIR_LANG_hi'),
('/CWH/CRNR/LNGG', '27', 'CWHCerner', 'FHIR_LANG_ig'),
('/CWH/CRNR/LNGG', '28', 'CWHCerner', 'FHIR_LANG_it'),
('/CWH/CRNR/LNGG', '29', 'CWHCerner', 'FHIR_LANG_ja'),
('/CWH/CRNR/LNGG', '30', 'CWHCerner', 'FHIR_LANG_ko'),
('/CWH/CRNR/LNGG', '31', 'CWHCerner', 'FHIR_LANG_ku'),
('/CWH/CRNR/LNGG', '32', 'CWHCerner', 'FHIR_LANG_ln'),
('/CWH/CRNR/LNGG', '35', 'CWHCerner', 'FHIR_LANG_ml'),
('/CWH/CRNR/LNGG', '11', 'CWHCerner', 'FHIR_LANG_nl'),
('/CWH/CRNR/LNGG', '16', 'CWHCerner', 'FHIR_LANG_nl'),
('/CWH/CRNR/LNGG', '37', 'CWHCerner', 'FHIR_LANG_no'),
('/CWH/CRNR/LNGG', '42', 'CWHCerner', 'FHIR_LANG_pa'),
('/CWH/CRNR/LNGG', '40', 'CWHCerner', 'FHIR_LANG_pl'),
('/CWH/CRNR/LNGG', '38', 'CWHCerner', 'FHIR_LANG_ps'),
('/CWH/CRNR/LNGG', '41', 'CWHCerner', 'FHIR_LANG_pt'),
('/CWH/CRNR/LNGG', '43', 'CWHCerner', 'FHIR_LANG_ru'),
('/CWH/CRNR/LNGG', '45', 'CWHCerner', 'FHIR_LANG_si'),
('/CWH/CRNR/LNGG', '6', 'CWHCerner', 'FHIR_LANG_so'),
('/CWH/CRNR/LNGG', '46', 'CWHCerner', 'FHIR_LANG_so'),
('/CWH/CRNR/LNGG', '2', 'CWHCerner', 'FHIR_LANG_sq'),
('/CWH/CRNR/LNGG', '50', 'CWHCerner', 'FHIR_LANG_sv'),
('/CWH/CRNR/LNGG', '49', 'CWHCerner', 'FHIR_LANG_sw'),
('/CWH/CRNR/LNGG', '53', 'CWHCerner', 'FHIR_LANG_ta'),
('/CWH/CRNR/LNGG', '54', 'CWHCerner', 'FHIR_LANG_th'),
('/CWH/CRNR/LNGG', '55', 'CWHCerner', 'FHIR_LANG_ti'),
('/CWH/CRNR/LNGG', '52', 'CWHCerner', 'FHIR_LANG_tl'),
('/CWH/CRNR/LNGG', '56', 'CWHCerner', 'FHIR_LANG_tr'),
('/CWH/CRNR/LNGG', '57', 'CWHCerner', 'FHIR_LANG_ur'),
('/CWH/CRNR/LNGG', '9', 'CWHCerner', 'FHIR_LANG_vi'),
('/CWH/CRNR/LNGG', '58', 'CWHCerner', 'FHIR_LANG_vi'),
('/CWH/CRNR/LNGG', '60', 'CWHCerner', 'FHIR_LANG_yo'),
('/CWH/CRNR/LNGG', '7', 'CWHCerner', 'FHIR_LANG_q4'),
('/CWH/CRNR/LNGG', '34', 'CWHCerner', 'FHIR_LANG_q5'),
-- Local
('/CWH/CRNR/LNGG', '8', 'CWHCerner', 'CWH_Lang_8'),
('/CWH/CRNR/LNGG', '10', 'CWHCerner', 'CWH_Lang_10'),
('/CWH/CRNR/LNGG', '13', 'CWHCerner', 'CWH_Lang_13'),
('/CWH/CRNR/LNGG', '18', 'CWHCerner', 'CWH_Lang_18'),
('/CWH/CRNR/LNGG', '23', 'CWHCerner', 'CWH_Lang_23'),
('/CWH/CRNR/LNGG', '33', 'CWHCerner', 'CWH_Lang_33'),
('/CWH/CRNR/LNGG', '36', 'CWHCerner', 'CWH_Lang_36'),
('/CWH/CRNR/LNGG', '200', 'CWHCerner', 'CWH_Lang_200'),
('/CWH/CRNR/LNGG', '39', 'CWHCerner', 'CWH_Lang_39'),
('/CWH/CRNR/LNGG', '44', 'CWHCerner', 'CWH_Lang_44'),
('/CWH/CRNR/LNGG', '51', 'CWHCerner', 'CWH_Lang_51');

-- ******************** FIN Number ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_CWH', 'CM_Sys_Cerner', null, null, 'fin_number', '/CWH/CRNR/FN_NMBR');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/CWH/CRNR/FN_NMBR',   'DM_patientFIN');

-- ******************** Encounter ********************

-- Concepts
SELECT @scm := dbid FROM concept WHERE id = 'CWHCerner';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
(1, 'CWH_Enc_DayCase', @scm, 'CWH_Enc_DayCase', 'Day case', 'Day case'),
(1, 'CWH_Enc_Inpatient', @scm, 'CWH_Enc_Inpatient', 'Inpatient', 'Inpatient'),
(1, 'CWH_Enc_Maternity', @scm, 'CWH_Enc_Maternity', 'Maternity', 'Maternity'),
(1, 'CWH_Enc_Newborn', @scm, 'CWH_Enc_Newborn', 'Newborn', 'Newborn'),
(1, 'CWH_Enc_RegRDayAdm', @scm, 'CWH_Enc_RegRDayAdm', 'Regular day admission', 'Regular day admission'),
(1, 'CWH_Enc_RegNghtAdm', @scm, 'CWH_Enc_RegNghtAdm', 'Regular night admission', 'Regular night admission'),
(1, 'CWH_Enc_DirectRef', @scm, 'CWH_Enc_DirectRef', 'Direct referral', 'Direct referral'),
(1, 'CWH_Enc_Emergency', @scm, 'CWH_Enc_Emergency', 'Emergency department', 'Emergency department'),
(1, 'CWH_Enc_Outpatient', @scm, 'CWH_Enc_Outpatient', 'Outpatient', 'Outpatient'),
(1, 'CWH_Enc_DCWL', @scm, 'CWH_Enc_DCWL', 'Day case waiting list', 'Day case waiting list'),
(1, 'CWH_Enc_PreReg', @scm, 'CWH_Enc_PreReg', 'Preregistration', 'Preregistration'),
(1, 'CWH_Enc_IPWL', @scm, 'CWH_Enc_IPWL', 'Inpatient waiting list', 'Inpatient waiting list'),
(1, 'CWH_Enc_PreAdmit', @scm, 'CWH_Enc_PreAdmit', 'Outpatient registration', 'Outpatient registration'),
(1, 'CWH_Enc_OPReferral', @scm, 'CWH_Enc_OPReferral', 'Outpatient referral', 'Outpatient referral');

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_CWH', 'CM_Sys_Cerner', null, null, 'encounter_type', '/CWH/CRNR/ENCNTR_TYP');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/CWH/CRNR/ENCNTR_TYP', 'DM_admissionPatientClassification');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/CWH/CRNR/ENCNTR_TYP', 'DAYCASE', 'CWHCerner', 'CWH_Enc_DayCase'),
('/CWH/CRNR/ENCNTR_TYP', 'INPATIENT', 'CWHCerner', 'CWH_Enc_Inpatient'),
('/CWH/CRNR/ENCNTR_TYP', 'MATERNITY', 'CWHCerner', 'CWH_Enc_Maternity'),
('/CWH/CRNR/ENCNTR_TYP', 'NEWBORN', 'CWHCerner', 'CWH_Enc_Newborn'),
('/CWH/CRNR/ENCNTR_TYP', 'REGRDAYADM', 'CWHCerner', 'CWH_Enc_RegRDayAdm'),
('/CWH/CRNR/ENCNTR_TYP', 'REGNGHTADM', 'CWHCerner', 'CWH_Enc_RegNghtAdm'),
('/CWH/CRNR/ENCNTR_TYP', 'DIRECTREF', 'CWHCerner', 'CWH_Enc_DirectRef'),
('/CWH/CRNR/ENCNTR_TYP', 'EMERGENCY', 'CWHCerner', 'CWH_Enc_Emergency'),
('/CWH/CRNR/ENCNTR_TYP', 'OUTPATIENT', 'CWHCerner', 'CWH_Enc_Outpatient'),
('/CWH/CRNR/ENCNTR_TYP', 'DCWL', 'CWHCerner', 'CWH_Enc_DCWL'),
('/CWH/CRNR/ENCNTR_TYP', 'PREREG', 'CWHCerner', 'CWH_Enc_PreReg'),
('/CWH/CRNR/ENCNTR_TYP', 'IPWL', 'CWHCerner', 'CWH_Enc_IPWL'),
('/CWH/CRNR/ENCNTR_TYP', 'PREADMIT', 'CWHCerner', 'CWH_Enc_PreAdmit'),
('/CWH/CRNR/ENCNTR_TYP', 'OPREFERRAL', 'CWHCerner', 'CWH_Enc_OPReferral');

-- ******************** Treatment Function ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_CWH', 'CM_Sys_Cerner', null, null, 'treatment_function_code', '/CWH/CRNR/TRTMNT_FNCTN');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/CWH/CRNR/TRTMNT_FNCTN', 'DM_treatmentFunctionAdmit');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/CWH/CRNR/TRTMNT_FNCTN', '100', 'CWHCerner', 'CM_TrtmntFnc100'),
('/CWH/CRNR/TRTMNT_FNCTN', '101', 'CWHCerner', 'CM_TrtmntFnc101'),
('/CWH/CRNR/TRTMNT_FNCTN', '102', 'CWHCerner', 'CM_TrtmntFnc102'),
('/CWH/CRNR/TRTMNT_FNCTN', '103', 'CWHCerner', 'CM_TrtmntFnc103'),
('/CWH/CRNR/TRTMNT_FNCTN', '104', 'CWHCerner', 'CM_TrtmntFnc104'),
('/CWH/CRNR/TRTMNT_FNCTN', '105', 'CWHCerner', 'CM_TrtmntFnc105'),
('/CWH/CRNR/TRTMNT_FNCTN', '106', 'CWHCerner', 'CM_TrtmntFnc106'),
('/CWH/CRNR/TRTMNT_FNCTN', '107', 'CWHCerner', 'CM_TrtmntFnc107'),
('/CWH/CRNR/TRTMNT_FNCTN', '108', 'CWHCerner', 'CM_TrtmntFnc108'),
('/CWH/CRNR/TRTMNT_FNCTN', '110', 'CWHCerner', 'CM_TrtmntFnc110'),
('/CWH/CRNR/TRTMNT_FNCTN', '120', 'CWHCerner', 'CM_TrtmntFnc120'),
('/CWH/CRNR/TRTMNT_FNCTN', '130', 'CWHCerner', 'CM_TrtmntFnc130'),
('/CWH/CRNR/TRTMNT_FNCTN', '140', 'CWHCerner', 'CM_TrtmntFnc140'),
('/CWH/CRNR/TRTMNT_FNCTN', '141', 'CWHCerner', 'CM_TrtmntFnc141'),
('/CWH/CRNR/TRTMNT_FNCTN', '142', 'CWHCerner', 'CM_TrtmntFnc142'),
('/CWH/CRNR/TRTMNT_FNCTN', '143', 'CWHCerner', 'CM_TrtmntFnc143'),
('/CWH/CRNR/TRTMNT_FNCTN', '144', 'CWHCerner', 'CM_TrtmntFnc144'),
('/CWH/CRNR/TRTMNT_FNCTN', '150', 'CWHCerner', 'CM_TrtmntFnc150'),
('/CWH/CRNR/TRTMNT_FNCTN', '160', 'CWHCerner', 'CM_TrtmntFnc160'),
('/CWH/CRNR/TRTMNT_FNCTN', '161', 'CWHCerner', 'CM_TrtmntFnc161'),
('/CWH/CRNR/TRTMNT_FNCTN', '170', 'CWHCerner', 'CM_TrtmntFnc170'),
('/CWH/CRNR/TRTMNT_FNCTN', '171', 'CWHCerner', 'CM_TrtmntFnc171'),
('/CWH/CRNR/TRTMNT_FNCTN', '172', 'CWHCerner', 'CM_TrtmntFnc172'),
('/CWH/CRNR/TRTMNT_FNCTN', '173', 'CWHCerner', 'CM_TrtmntFnc173'),
('/CWH/CRNR/TRTMNT_FNCTN', '174', 'CWHCerner', 'CM_TrtmntFnc174'),
('/CWH/CRNR/TRTMNT_FNCTN', '180', 'CWHCerner', 'CM_TrtmntFnc180'),
('/CWH/CRNR/TRTMNT_FNCTN', '190', 'CWHCerner', 'CM_TrtmntFnc190'),
('/CWH/CRNR/TRTMNT_FNCTN', '191', 'CWHCerner', 'CM_TrtmntFnc191'),
('/CWH/CRNR/TRTMNT_FNCTN', '192', 'CWHCerner', 'CM_TrtmntFnc192'),
('/CWH/CRNR/TRTMNT_FNCTN', '211', 'CWHCerner', 'CM_TrtmntFnc211'),
('/CWH/CRNR/TRTMNT_FNCTN', '212', 'CWHCerner', 'CM_TrtmntFnc212'),
('/CWH/CRNR/TRTMNT_FNCTN', '213', 'CWHCerner', 'CM_TrtmntFnc213'),
('/CWH/CRNR/TRTMNT_FNCTN', '214', 'CWHCerner', 'CM_TrtmntFnc214'),
('/CWH/CRNR/TRTMNT_FNCTN', '215', 'CWHCerner', 'CM_TrtmntFnc215'),
('/CWH/CRNR/TRTMNT_FNCTN', '216', 'CWHCerner', 'CM_TrtmntFnc216'),
('/CWH/CRNR/TRTMNT_FNCTN', '217', 'CWHCerner', 'CM_TrtmntFnc217'),
('/CWH/CRNR/TRTMNT_FNCTN', '218', 'CWHCerner', 'CM_TrtmntFnc218'),
('/CWH/CRNR/TRTMNT_FNCTN', '219', 'CWHCerner', 'CM_TrtmntFnc219'),
('/CWH/CRNR/TRTMNT_FNCTN', '220', 'CWHCerner', 'CM_TrtmntFnc220'),
('/CWH/CRNR/TRTMNT_FNCTN', '221', 'CWHCerner', 'CM_TrtmntFnc221'),
('/CWH/CRNR/TRTMNT_FNCTN', '222', 'CWHCerner', 'CM_TrtmntFnc222'),
('/CWH/CRNR/TRTMNT_FNCTN', '223', 'CWHCerner', 'CM_TrtmntFnc223'),
('/CWH/CRNR/TRTMNT_FNCTN', '241', 'CWHCerner', 'CM_TrtmntFnc241'),
('/CWH/CRNR/TRTMNT_FNCTN', '242', 'CWHCerner', 'CM_TrtmntFnc242'),
('/CWH/CRNR/TRTMNT_FNCTN', '251', 'CWHCerner', 'CM_TrtmntFnc251'),
('/CWH/CRNR/TRTMNT_FNCTN', '252', 'CWHCerner', 'CM_TrtmntFnc252'),
('/CWH/CRNR/TRTMNT_FNCTN', '253', 'CWHCerner', 'CM_TrtmntFnc253'),
('/CWH/CRNR/TRTMNT_FNCTN', '254', 'CWHCerner', 'CM_TrtmntFnc254'),
('/CWH/CRNR/TRTMNT_FNCTN', '255', 'CWHCerner', 'CM_TrtmntFnc255'),
('/CWH/CRNR/TRTMNT_FNCTN', '256', 'CWHCerner', 'CM_TrtmntFnc256'),
('/CWH/CRNR/TRTMNT_FNCTN', '257', 'CWHCerner', 'CM_TrtmntFnc257'),
('/CWH/CRNR/TRTMNT_FNCTN', '258', 'CWHCerner', 'CM_TrtmntFnc258'),
('/CWH/CRNR/TRTMNT_FNCTN', '259', 'CWHCerner', 'CM_TrtmntFnc259'),
('/CWH/CRNR/TRTMNT_FNCTN', '260', 'CWHCerner', 'CM_TrtmntFnc260'),
('/CWH/CRNR/TRTMNT_FNCTN', '261', 'CWHCerner', 'CM_TrtmntFnc261'),
('/CWH/CRNR/TRTMNT_FNCTN', '262', 'CWHCerner', 'CM_TrtmntFnc262'),
('/CWH/CRNR/TRTMNT_FNCTN', '263', 'CWHCerner', 'CM_TrtmntFnc263'),
('/CWH/CRNR/TRTMNT_FNCTN', '264', 'CWHCerner', 'CM_TrtmntFnc264'),
('/CWH/CRNR/TRTMNT_FNCTN', '280', 'CWHCerner', 'CM_TrtmntFnc280'),
('/CWH/CRNR/TRTMNT_FNCTN', '290', 'CWHCerner', 'CM_TrtmntFnc290'),
('/CWH/CRNR/TRTMNT_FNCTN', '291', 'CWHCerner', 'CM_TrtmntFnc291'),
('/CWH/CRNR/TRTMNT_FNCTN', '300', 'CWHCerner', 'CM_TrtmntFnc300'),
('/CWH/CRNR/TRTMNT_FNCTN', '301', 'CWHCerner', 'CM_TrtmntFnc301'),
('/CWH/CRNR/TRTMNT_FNCTN', '302', 'CWHCerner', 'CM_TrtmntFnc302'),
('/CWH/CRNR/TRTMNT_FNCTN', '303', 'CWHCerner', 'CM_TrtmntFnc303'),
('/CWH/CRNR/TRTMNT_FNCTN', '304', 'CWHCerner', 'CM_TrtmntFnc304'),
('/CWH/CRNR/TRTMNT_FNCTN', '305', 'CWHCerner', 'CM_TrtmntFnc305'),
('/CWH/CRNR/TRTMNT_FNCTN', '306', 'CWHCerner', 'CM_TrtmntFnc306'),
('/CWH/CRNR/TRTMNT_FNCTN', '307', 'CWHCerner', 'CM_TrtmntFnc307'),
('/CWH/CRNR/TRTMNT_FNCTN', '308', 'CWHCerner', 'CM_TrtmntFnc308'),
('/CWH/CRNR/TRTMNT_FNCTN', '309', 'CWHCerner', 'CM_TrtmntFnc309'),
('/CWH/CRNR/TRTMNT_FNCTN', '310', 'CWHCerner', 'CM_TrtmntFnc310'),
('/CWH/CRNR/TRTMNT_FNCTN', '311', 'CWHCerner', 'CM_TrtmntFnc311'),
('/CWH/CRNR/TRTMNT_FNCTN', '313', 'CWHCerner', 'CM_TrtmntFnc313'),
('/CWH/CRNR/TRTMNT_FNCTN', '314', 'CWHCerner', 'CM_TrtmntFnc314'),
('/CWH/CRNR/TRTMNT_FNCTN', '315', 'CWHCerner', 'CM_TrtmntFnc315'),
('/CWH/CRNR/TRTMNT_FNCTN', '316', 'CWHCerner', 'CM_TrtmntFnc316'),
('/CWH/CRNR/TRTMNT_FNCTN', '317', 'CWHCerner', 'CM_TrtmntFnc317'),
('/CWH/CRNR/TRTMNT_FNCTN', '318', 'CWHCerner', 'CM_TrtmntFnc318'),
('/CWH/CRNR/TRTMNT_FNCTN', '319', 'CWHCerner', 'CM_TrtmntFnc319'),
('/CWH/CRNR/TRTMNT_FNCTN', '320', 'CWHCerner', 'CM_TrtmntFnc320'),
('/CWH/CRNR/TRTMNT_FNCTN', '321', 'CWHCerner', 'CM_TrtmntFnc321'),
('/CWH/CRNR/TRTMNT_FNCTN', '322', 'CWHCerner', 'CM_TrtmntFnc322'),
('/CWH/CRNR/TRTMNT_FNCTN', '323', 'CWHCerner', 'CM_TrtmntFnc323'),
('/CWH/CRNR/TRTMNT_FNCTN', '324', 'CWHCerner', 'CM_TrtmntFnc324'),
('/CWH/CRNR/TRTMNT_FNCTN', '325', 'CWHCerner', 'CM_TrtmntFnc325'),
('/CWH/CRNR/TRTMNT_FNCTN', '327', 'CWHCerner', 'CM_TrtmntFnc327'),
('/CWH/CRNR/TRTMNT_FNCTN', '328', 'CWHCerner', 'CM_TrtmntFnc328'),
('/CWH/CRNR/TRTMNT_FNCTN', '329', 'CWHCerner', 'CM_TrtmntFnc329'),
('/CWH/CRNR/TRTMNT_FNCTN', '330', 'CWHCerner', 'CM_TrtmntFnc330'),
('/CWH/CRNR/TRTMNT_FNCTN', '331', 'CWHCerner', 'CM_TrtmntFnc331'),
('/CWH/CRNR/TRTMNT_FNCTN', '340', 'CWHCerner', 'CM_TrtmntFnc340'),
('/CWH/CRNR/TRTMNT_FNCTN', '341', 'CWHCerner', 'CM_TrtmntFnc341'),
('/CWH/CRNR/TRTMNT_FNCTN', '342', 'CWHCerner', 'CM_TrtmntFnc342'),
('/CWH/CRNR/TRTMNT_FNCTN', '343', 'CWHCerner', 'CM_TrtmntFnc343'),
('/CWH/CRNR/TRTMNT_FNCTN', '344', 'CWHCerner', 'CM_TrtmntFnc344'),
('/CWH/CRNR/TRTMNT_FNCTN', '346', 'CWHCerner', 'CM_TrtmntFnc346'),
('/CWH/CRNR/TRTMNT_FNCTN', '350', 'CWHCerner', 'CM_TrtmntFnc350'),
('/CWH/CRNR/TRTMNT_FNCTN', '352', 'CWHCerner', 'CM_TrtmntFnc352'),
('/CWH/CRNR/TRTMNT_FNCTN', '360', 'CWHCerner', 'CM_TrtmntFnc360'),
('/CWH/CRNR/TRTMNT_FNCTN', '361', 'CWHCerner', 'CM_TrtmntFnc361'),
('/CWH/CRNR/TRTMNT_FNCTN', '370', 'CWHCerner', 'CM_TrtmntFnc370'),
('/CWH/CRNR/TRTMNT_FNCTN', '371', 'CWHCerner', 'CM_TrtmntFnc371'),
('/CWH/CRNR/TRTMNT_FNCTN', '400', 'CWHCerner', 'CM_TrtmntFnc400'),
('/CWH/CRNR/TRTMNT_FNCTN', '410', 'CWHCerner', 'CM_TrtmntFnc410'),
('/CWH/CRNR/TRTMNT_FNCTN', '420', 'CWHCerner', 'CM_TrtmntFnc420'),
('/CWH/CRNR/TRTMNT_FNCTN', '421', 'CWHCerner', 'CM_TrtmntFnc421'),
('/CWH/CRNR/TRTMNT_FNCTN', '422', 'CWHCerner', 'CM_TrtmntFnc422'),
('/CWH/CRNR/TRTMNT_FNCTN', '424', 'CWHCerner', 'CM_TrtmntFnc424'),
('/CWH/CRNR/TRTMNT_FNCTN', '430', 'CWHCerner', 'CM_TrtmntFnc430'),
('/CWH/CRNR/TRTMNT_FNCTN', '450', 'CWHCerner', 'CM_TrtmntFnc450'),
('/CWH/CRNR/TRTMNT_FNCTN', '460', 'CWHCerner', 'CM_TrtmntFnc460'),
('/CWH/CRNR/TRTMNT_FNCTN', '501', 'CWHCerner', 'CM_TrtmntFnc501'),
('/CWH/CRNR/TRTMNT_FNCTN', '502', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '503', 'CWHCerner', 'CM_TrtmntFnc503'),
('/CWH/CRNR/TRTMNT_FNCTN', '560', 'CWHCerner', 'CM_TrtmntFnc560'),
('/CWH/CRNR/TRTMNT_FNCTN', '650', 'CWHCerner', 'CM_TrtmntFnc650'),
('/CWH/CRNR/TRTMNT_FNCTN', '651', 'CWHCerner', 'CM_TrtmntFnc651'),
('/CWH/CRNR/TRTMNT_FNCTN', '652', 'CWHCerner', 'CM_TrtmntFnc652'),
('/CWH/CRNR/TRTMNT_FNCTN', '653', 'CWHCerner', 'CM_TrtmntFnc653'),
('/CWH/CRNR/TRTMNT_FNCTN', '654', 'CWHCerner', 'CM_TrtmntFnc654'),
('/CWH/CRNR/TRTMNT_FNCTN', '655', 'CWHCerner', 'CM_TrtmntFnc655'),
('/CWH/CRNR/TRTMNT_FNCTN', '656', 'CWHCerner', 'CM_TrtmntFnc656'),
('/CWH/CRNR/TRTMNT_FNCTN', '657', 'CWHCerner', 'CM_TrtmntFnc657'),
('/CWH/CRNR/TRTMNT_FNCTN', '658', 'CWHCerner', 'CM_TrtmntFnc658'),
('/CWH/CRNR/TRTMNT_FNCTN', '659', 'CWHCerner', 'CM_TrtmntFnc659'),
('/CWH/CRNR/TRTMNT_FNCTN', '660', 'CWHCerner', 'CM_TrtmntFnc660'),
('/CWH/CRNR/TRTMNT_FNCTN', '661', 'CWHCerner', 'CM_TrtmntFnc661'),
('/CWH/CRNR/TRTMNT_FNCTN', '662', 'CWHCerner', 'CM_TrtmntFnc662'),
('/CWH/CRNR/TRTMNT_FNCTN', '663', 'CWHCerner', 'CM_TrtmntFnc663'),
('/CWH/CRNR/TRTMNT_FNCTN', '700', 'CWHCerner', 'CM_TrtmntFnc700'),
('/CWH/CRNR/TRTMNT_FNCTN', '710', 'CWHCerner', 'CM_TrtmntFnc710'),
('/CWH/CRNR/TRTMNT_FNCTN', '711', 'CWHCerner', 'CM_TrtmntFnc711'),
('/CWH/CRNR/TRTMNT_FNCTN', '712', 'CWHCerner', 'CM_TrtmntFnc712'),
('/CWH/CRNR/TRTMNT_FNCTN', '713', 'CWHCerner', 'CM_TrtmntFnc713'),
('/CWH/CRNR/TRTMNT_FNCTN', '715', 'CWHCerner', 'CM_TrtmntFnc715'),
('/CWH/CRNR/TRTMNT_FNCTN', '720', 'CWHCerner', 'CM_TrtmntFnc720'),
('/CWH/CRNR/TRTMNT_FNCTN', '721', 'CWHCerner', 'CM_TrtmntFnc721'),
('/CWH/CRNR/TRTMNT_FNCTN', '722', 'CWHCerner', 'CM_TrtmntFnc722'),
('/CWH/CRNR/TRTMNT_FNCTN', '723', 'CWHCerner', 'CM_TrtmntFnc723'),
('/CWH/CRNR/TRTMNT_FNCTN', '724', 'CWHCerner', 'CM_TrtmntFnc724'),
('/CWH/CRNR/TRTMNT_FNCTN', '725', 'CWHCerner', 'CM_TrtmntFnc725'),
('/CWH/CRNR/TRTMNT_FNCTN', '726', 'CWHCerner', 'CM_TrtmntFnc726'),
('/CWH/CRNR/TRTMNT_FNCTN', '727', 'CWHCerner', 'CM_TrtmntFnc727'),
('/CWH/CRNR/TRTMNT_FNCTN', '800', 'CWHCerner', 'CM_TrtmntFnc800'),
('/CWH/CRNR/TRTMNT_FNCTN', '811', 'CWHCerner', 'CM_TrtmntFnc811'),
('/CWH/CRNR/TRTMNT_FNCTN', '812', 'CWHCerner', 'CM_TrtmntFnc812'),
('/CWH/CRNR/TRTMNT_FNCTN', '822', 'CWHCerner', 'CM_TrtmntFnc822'),
('/CWH/CRNR/TRTMNT_FNCTN', '834', 'CWHCerner', 'CM_TrtmntFnc834'),
('/CWH/CRNR/TRTMNT_FNCTN', '840', 'CWHCerner', 'CM_TrtmntFnc840'),
('/CWH/CRNR/TRTMNT_FNCTN', '920', 'CWHCerner', 'CM_TrtmntFnc920'),
('/CWH/CRNR/TRTMNT_FNCTN', '10001', 'CWHCerner', 'CM_TrtmntFnc100'),
('/CWH/CRNR/TRTMNT_FNCTN', '10002', 'CWHCerner', 'CM_TrtmntFnc100'),
('/CWH/CRNR/TRTMNT_FNCTN', '10099', 'CWHCerner', 'CM_TrtmntFnc100'),
('/CWH/CRNR/TRTMNT_FNCTN', '10101', 'CWHCerner', 'CM_TrtmntFnc101'),
('/CWH/CRNR/TRTMNT_FNCTN', '10102', 'CWHCerner', 'CM_TrtmntFnc101'),
('/CWH/CRNR/TRTMNT_FNCTN', '10130', 'CWHCerner', 'CM_TrtmntFnc101'),
('/CWH/CRNR/TRTMNT_FNCTN', '10199', 'CWHCerner', 'CM_TrtmntFnc101'),
('/CWH/CRNR/TRTMNT_FNCTN', '10240', 'CWHCerner', 'CM_TrtmntFnc102'),
('/CWH/CRNR/TRTMNT_FNCTN', '10246', 'CWHCerner', 'CM_TrtmntFnc102'),
('/CWH/CRNR/TRTMNT_FNCTN', '10299', 'CWHCerner', 'CM_TrtmntFnc102'),
('/CWH/CRNR/TRTMNT_FNCTN', '10399', 'CWHCerner', 'CM_TrtmntFnc103'),
('/CWH/CRNR/TRTMNT_FNCTN', '10499', 'CWHCerner', 'CM_TrtmntFnc104'),
('/CWH/CRNR/TRTMNT_FNCTN', '10539', 'CWHCerner', 'CM_TrtmntFnc105'),
('/CWH/CRNR/TRTMNT_FNCTN', '10599', 'CWHCerner', 'CM_TrtmntFnc105'),
('/CWH/CRNR/TRTMNT_FNCTN', '10699', 'CWHCerner', 'CM_TrtmntFnc106'),
('/CWH/CRNR/TRTMNT_FNCTN', '10701', 'CWHCerner', 'CM_TrtmntFnc107'),
('/CWH/CRNR/TRTMNT_FNCTN', '10799', 'CWHCerner', 'CM_TrtmntFnc107'),
('/CWH/CRNR/TRTMNT_FNCTN', '11001', 'CWHCerner', 'CM_TrtmntFnc110'),
('/CWH/CRNR/TRTMNT_FNCTN', '11002', 'CWHCerner', 'CM_TrtmntFnc110'),
('/CWH/CRNR/TRTMNT_FNCTN', '11003', 'CWHCerner', 'CM_TrtmntFnc110'),
('/CWH/CRNR/TRTMNT_FNCTN', '11004', 'CWHCerner', 'CM_TrtmntFnc110'),
('/CWH/CRNR/TRTMNT_FNCTN', '11005', 'CWHCerner', 'CM_TrtmntFnc110'),
('/CWH/CRNR/TRTMNT_FNCTN', '11099', 'CWHCerner', 'CM_TrtmntFnc110'),
('/CWH/CRNR/TRTMNT_FNCTN', '12033', 'CWHCerner', 'CM_TrtmntFnc120'),
('/CWH/CRNR/TRTMNT_FNCTN', '12099', 'CWHCerner', 'CM_TrtmntFnc120'),
('/CWH/CRNR/TRTMNT_FNCTN', '13014', 'CWHCerner', 'CM_TrtmntFnc130'),
('/CWH/CRNR/TRTMNT_FNCTN', '13020', 'CWHCerner', 'CM_TrtmntFnc130'),
('/CWH/CRNR/TRTMNT_FNCTN', '13044', 'CWHCerner', 'CM_TrtmntFnc130'),
('/CWH/CRNR/TRTMNT_FNCTN', '13099', 'CWHCerner', 'CM_TrtmntFnc130'),
('/CWH/CRNR/TRTMNT_FNCTN', '14099', 'CWHCerner', 'CM_TrtmntFnc140'),
('/CWH/CRNR/TRTMNT_FNCTN', '14499', 'CWHCerner', 'CM_TrtmntFnc144'),
('/CWH/CRNR/TRTMNT_FNCTN', '15099', 'CWHCerner', 'CM_TrtmntFnc150'),
('/CWH/CRNR/TRTMNT_FNCTN', '16001', 'CWHCerner', 'CM_TrtmntFnc160'),
('/CWH/CRNR/TRTMNT_FNCTN', '16002', 'CWHCerner', 'CM_TrtmntFnc160'),
('/CWH/CRNR/TRTMNT_FNCTN', '16099', 'CWHCerner', 'CM_TrtmntFnc160'),
('/CWH/CRNR/TRTMNT_FNCTN', '16199', 'CWHCerner', 'CM_TrtmntFnc161'),
('/CWH/CRNR/TRTMNT_FNCTN', '17111', 'CWHCerner', 'CM_TrtmntFnc171'),
('/CWH/CRNR/TRTMNT_FNCTN', '17299', 'CWHCerner', 'CM_TrtmntFnc172'),
('/CWH/CRNR/TRTMNT_FNCTN', '17399', 'CWHCerner', 'CM_TrtmntFnc173'),
('/CWH/CRNR/TRTMNT_FNCTN', '19029', 'CWHCerner', 'CM_TrtmntFnc190'),
('/CWH/CRNR/TRTMNT_FNCTN', '19199', 'CWHCerner', 'CM_TrtmntFnc191'),
('/CWH/CRNR/TRTMNT_FNCTN', '21499', 'CWHCerner', 'CM_TrtmntFnc214'),
('/CWH/CRNR/TRTMNT_FNCTN', '25399', 'CWHCerner', 'CM_TrtmntFnc253'),
('/CWH/CRNR/TRTMNT_FNCTN', '25501', 'CWHCerner', 'CM_TrtmntFnc255'),
('/CWH/CRNR/TRTMNT_FNCTN', '25801', 'CWHCerner', 'CM_TrtmntFnc258'),
('/CWH/CRNR/TRTMNT_FNCTN', '25945', 'CWHCerner', 'CM_TrtmntFnc259'),
('/CWH/CRNR/TRTMNT_FNCTN', '30001', 'CWHCerner', 'CM_TrtmntFnc300'),
('/CWH/CRNR/TRTMNT_FNCTN', '30002', 'CWHCerner', 'CM_TrtmntFnc300'),
('/CWH/CRNR/TRTMNT_FNCTN', '30043', 'CWHCerner', 'CM_TrtmntFnc300'),
('/CWH/CRNR/TRTMNT_FNCTN', '30099', 'CWHCerner', 'CM_TrtmntFnc300'),
('/CWH/CRNR/TRTMNT_FNCTN', '30101', 'CWHCerner', 'CM_TrtmntFnc301'),
('/CWH/CRNR/TRTMNT_FNCTN', '30102', 'CWHCerner', 'CM_TrtmntFnc301'),
('/CWH/CRNR/TRTMNT_FNCTN', '30103', 'CWHCerner', 'CM_TrtmntFnc301'),
('/CWH/CRNR/TRTMNT_FNCTN', '30199', 'CWHCerner', 'CM_TrtmntFnc301'),
('/CWH/CRNR/TRTMNT_FNCTN', '30201', 'CWHCerner', 'CM_TrtmntFnc302'),
('/CWH/CRNR/TRTMNT_FNCTN', '30299', 'CWHCerner', 'CM_TrtmntFnc302'),
('/CWH/CRNR/TRTMNT_FNCTN', '30301', 'CWHCerner', 'CM_TrtmntFnc303'),
('/CWH/CRNR/TRTMNT_FNCTN', '30303', 'CWHCerner', 'CM_TrtmntFnc303'),
('/CWH/CRNR/TRTMNT_FNCTN', '30304', 'CWHCerner', 'CM_TrtmntFnc303'),
('/CWH/CRNR/TRTMNT_FNCTN', '30307', 'CWHCerner', 'CM_TrtmntFnc303'),
('/CWH/CRNR/TRTMNT_FNCTN', '30335', 'CWHCerner', 'CM_TrtmntFnc303'),
('/CWH/CRNR/TRTMNT_FNCTN', '30337', 'CWHCerner', 'CM_TrtmntFnc303'),
('/CWH/CRNR/TRTMNT_FNCTN', '30341', 'CWHCerner', 'CM_TrtmntFnc303'),
('/CWH/CRNR/TRTMNT_FNCTN', '30399', 'CWHCerner', 'CM_TrtmntFnc303'),
('/CWH/CRNR/TRTMNT_FNCTN', '30627', 'CWHCerner', 'CM_TrtmntFnc306'),
('/CWH/CRNR/TRTMNT_FNCTN', '30699', 'CWHCerner', 'CM_TrtmntFnc306'),
('/CWH/CRNR/TRTMNT_FNCTN', '30717', 'CWHCerner', 'CM_TrtmntFnc307'),
('/CWH/CRNR/TRTMNT_FNCTN', '30799', 'CWHCerner', 'CM_TrtmntFnc307'),
('/CWH/CRNR/TRTMNT_FNCTN', '30801', 'CWHCerner', 'CM_TrtmntFnc308'),
('/CWH/CRNR/TRTMNT_FNCTN', '30802', 'CWHCerner', 'CM_TrtmntFnc308'),
('/CWH/CRNR/TRTMNT_FNCTN', '30803', 'CWHCerner', 'CM_TrtmntFnc308'),
('/CWH/CRNR/TRTMNT_FNCTN', '30804', 'CWHCerner', 'CM_TrtmntFnc308'),
('/CWH/CRNR/TRTMNT_FNCTN', '30805', 'CWHCerner', 'CM_TrtmntFnc308'),
('/CWH/CRNR/TRTMNT_FNCTN', '30806', 'CWHCerner', 'CM_TrtmntFnc308'),
('/CWH/CRNR/TRTMNT_FNCTN', '30807', 'CWHCerner', 'CM_TrtmntFnc308'),
('/CWH/CRNR/TRTMNT_FNCTN', '30808', 'CWHCerner', 'CM_TrtmntFnc308'),
('/CWH/CRNR/TRTMNT_FNCTN', '30809', 'CWHCerner', 'CM_TrtmntFnc308'),
('/CWH/CRNR/TRTMNT_FNCTN', '30810', 'CWHCerner', 'CM_TrtmntFnc308'),
('/CWH/CRNR/TRTMNT_FNCTN', '30811', 'CWHCerner', 'CM_TrtmntFnc308'),
('/CWH/CRNR/TRTMNT_FNCTN', '30899', 'CWHCerner', 'CM_TrtmntFnc308'),
('/CWH/CRNR/TRTMNT_FNCTN', '30999', 'CWHCerner', 'CM_TrtmntFnc309'),
('/CWH/CRNR/TRTMNT_FNCTN', '31099', 'CWHCerner', 'CM_TrtmntFnc310'),
('/CWH/CRNR/TRTMNT_FNCTN', '31101', 'CWHCerner', 'CM_TrtmntFnc311'),
('/CWH/CRNR/TRTMNT_FNCTN', '31399', 'CWHCerner', 'CM_TrtmntFnc313'),
('/CWH/CRNR/TRTMNT_FNCTN', '31699', 'CWHCerner', 'CM_TrtmntFnc316'),
('/CWH/CRNR/TRTMNT_FNCTN', '31799', 'CWHCerner', 'CM_TrtmntFnc317'),
('/CWH/CRNR/TRTMNT_FNCTN', '31899', 'CWHCerner', 'CM_TrtmntFnc318'),
('/CWH/CRNR/TRTMNT_FNCTN', '31999', 'CWHCerner', 'CM_TrtmntFnc319'),
('/CWH/CRNR/TRTMNT_FNCTN', '32002', 'CWHCerner', 'CM_TrtmntFnc320'),
('/CWH/CRNR/TRTMNT_FNCTN', '32005', 'CWHCerner', 'CM_TrtmntFnc320'),
('/CWH/CRNR/TRTMNT_FNCTN', '32006', 'CWHCerner', 'CM_TrtmntFnc320'),
('/CWH/CRNR/TRTMNT_FNCTN', '32099', 'CWHCerner', 'CM_TrtmntFnc320'),
('/CWH/CRNR/TRTMNT_FNCTN', '32299', 'CWHCerner', 'CM_TrtmntFnc322'),
('/CWH/CRNR/TRTMNT_FNCTN', '32399', 'CWHCerner', 'CM_TrtmntFnc323'),
('/CWH/CRNR/TRTMNT_FNCTN', '32499', 'CWHCerner', 'CM_TrtmntFnc324'),
('/CWH/CRNR/TRTMNT_FNCTN', '33001', 'CWHCerner', 'CM_TrtmntFnc330'),
('/CWH/CRNR/TRTMNT_FNCTN', '33099', 'CWHCerner', 'CM_TrtmntFnc330'),
('/CWH/CRNR/TRTMNT_FNCTN', '34001', 'CWHCerner', 'CM_TrtmntFnc340'),
('/CWH/CRNR/TRTMNT_FNCTN', '34021', 'CWHCerner', 'CM_TrtmntFnc340'),
('/CWH/CRNR/TRTMNT_FNCTN', '34023', 'CWHCerner', 'CM_TrtmntFnc340'),
('/CWH/CRNR/TRTMNT_FNCTN', '34099', 'CWHCerner', 'CM_TrtmntFnc340'),
('/CWH/CRNR/TRTMNT_FNCTN', '34199', 'CWHCerner', 'CM_TrtmntFnc341'),
('/CWH/CRNR/TRTMNT_FNCTN', '35008', 'CWHCerner', 'CM_TrtmntFnc350'),
('/CWH/CRNR/TRTMNT_FNCTN', '35099', 'CWHCerner', 'CM_TrtmntFnc350'),
('/CWH/CRNR/TRTMNT_FNCTN', '36001', 'CWHCerner', 'CM_TrtmntFnc360'),
('/CWH/CRNR/TRTMNT_FNCTN', '36002', 'CWHCerner', 'CM_TrtmntFnc360'),
('/CWH/CRNR/TRTMNT_FNCTN', '36003', 'CWHCerner', 'CM_TrtmntFnc360'),
('/CWH/CRNR/TRTMNT_FNCTN', '36004', 'CWHCerner', 'CM_TrtmntFnc360'),
('/CWH/CRNR/TRTMNT_FNCTN', '36099', 'CWHCerner', 'CM_TrtmntFnc360'),
('/CWH/CRNR/TRTMNT_FNCTN', '36102', 'CWHCerner', 'CM_TrtmntFnc361'),
('/CWH/CRNR/TRTMNT_FNCTN', '36103', 'CWHCerner', 'CM_TrtmntFnc361'),
('/CWH/CRNR/TRTMNT_FNCTN', '36104', 'CWHCerner', 'CM_TrtmntFnc361'),
('/CWH/CRNR/TRTMNT_FNCTN', '36120', 'CWHCerner', 'CM_TrtmntFnc361'),
('/CWH/CRNR/TRTMNT_FNCTN', '36199', 'CWHCerner', 'CM_TrtmntFnc361'),
('/CWH/CRNR/TRTMNT_FNCTN', '37001', 'CWHCerner', 'CM_TrtmntFnc370'),
('/CWH/CRNR/TRTMNT_FNCTN', '37002', 'CWHCerner', 'CM_TrtmntFnc370'),
('/CWH/CRNR/TRTMNT_FNCTN', '37003', 'CWHCerner', 'CM_TrtmntFnc370'),
('/CWH/CRNR/TRTMNT_FNCTN', '37004', 'CWHCerner', 'CM_TrtmntFnc370'),
('/CWH/CRNR/TRTMNT_FNCTN', '37005', 'CWHCerner', 'CM_TrtmntFnc370'),
('/CWH/CRNR/TRTMNT_FNCTN', '37006', 'CWHCerner', 'CM_TrtmntFnc370'),
('/CWH/CRNR/TRTMNT_FNCTN', '37007', 'CWHCerner', 'CM_TrtmntFnc370'),
('/CWH/CRNR/TRTMNT_FNCTN', '37008', 'CWHCerner', 'CM_TrtmntFnc370'),
('/CWH/CRNR/TRTMNT_FNCTN', '37009', 'CWHCerner', 'CM_TrtmntFnc370'),
('/CWH/CRNR/TRTMNT_FNCTN', '37010', 'CWHCerner', 'CM_TrtmntFnc370'),
('/CWH/CRNR/TRTMNT_FNCTN', '37011', 'CWHCerner', 'CM_TrtmntFnc370'),
('/CWH/CRNR/TRTMNT_FNCTN', '37012', 'CWHCerner', 'CM_TrtmntFnc370'),
('/CWH/CRNR/TRTMNT_FNCTN', '37015', 'CWHCerner', 'CM_TrtmntFnc370'),
('/CWH/CRNR/TRTMNT_FNCTN', '37099', 'CWHCerner', 'CM_TrtmntFnc370'),
('/CWH/CRNR/TRTMNT_FNCTN', '40001', 'CWHCerner', 'CM_TrtmntFnc400'),
('/CWH/CRNR/TRTMNT_FNCTN', '40002', 'CWHCerner', 'CM_TrtmntFnc400'),
('/CWH/CRNR/TRTMNT_FNCTN', '40003', 'CWHCerner', 'CM_TrtmntFnc400'),
('/CWH/CRNR/TRTMNT_FNCTN', '40018', 'CWHCerner', 'CM_TrtmntFnc400'),
('/CWH/CRNR/TRTMNT_FNCTN', '40099', 'CWHCerner', 'CM_TrtmntFnc400'),
('/CWH/CRNR/TRTMNT_FNCTN', '41028', 'CWHCerner', 'CM_TrtmntFnc410'),
('/CWH/CRNR/TRTMNT_FNCTN', '41099', 'CWHCerner', 'CM_TrtmntFnc410'),
('/CWH/CRNR/TRTMNT_FNCTN', '42001', 'CWHCerner', 'CM_TrtmntFnc420'),
('/CWH/CRNR/TRTMNT_FNCTN', '42002', 'CWHCerner', 'CM_TrtmntFnc420'),
('/CWH/CRNR/TRTMNT_FNCTN', '42003', 'CWHCerner', 'CM_TrtmntFnc420'),
('/CWH/CRNR/TRTMNT_FNCTN', '42004', 'CWHCerner', 'CM_TrtmntFnc420'),
('/CWH/CRNR/TRTMNT_FNCTN', '42005', 'CWHCerner', 'CM_TrtmntFnc420'),
('/CWH/CRNR/TRTMNT_FNCTN', '42007', 'CWHCerner', 'CM_TrtmntFnc420'),
('/CWH/CRNR/TRTMNT_FNCTN', '42008', 'CWHCerner', 'CM_TrtmntFnc420'),
('/CWH/CRNR/TRTMNT_FNCTN', '42099', 'CWHCerner', 'CM_TrtmntFnc420'),
('/CWH/CRNR/TRTMNT_FNCTN', '42201', 'CWHCerner', 'CM_TrtmntFnc422'),
('/CWH/CRNR/TRTMNT_FNCTN', '42202', 'CWHCerner', 'CM_TrtmntFnc422'),
('/CWH/CRNR/TRTMNT_FNCTN', '42209', 'CWHCerner', 'CM_TrtmntFnc422'),
('/CWH/CRNR/TRTMNT_FNCTN', '42210', 'CWHCerner', 'CM_TrtmntFnc422'),
('/CWH/CRNR/TRTMNT_FNCTN', '42221', 'CWHCerner', 'CM_TrtmntFnc422'),
('/CWH/CRNR/TRTMNT_FNCTN', '42299', 'CWHCerner', 'CM_TrtmntFnc422'),
('/CWH/CRNR/TRTMNT_FNCTN', '42499', 'CWHCerner', 'CM_TrtmntFnc424'),
('/CWH/CRNR/TRTMNT_FNCTN', '43005', 'CWHCerner', 'CM_TrtmntFnc430'),
('/CWH/CRNR/TRTMNT_FNCTN', '43010', 'CWHCerner', 'CM_TrtmntFnc430'),
('/CWH/CRNR/TRTMNT_FNCTN', '43011', 'CWHCerner', 'CM_TrtmntFnc430'),
('/CWH/CRNR/TRTMNT_FNCTN', '43099', 'CWHCerner', 'CM_TrtmntFnc430'),
('/CWH/CRNR/TRTMNT_FNCTN', '50101', 'CWHCerner', 'CM_TrtmntFnc501'),
('/CWH/CRNR/TRTMNT_FNCTN', '50102', 'CWHCerner', 'CM_TrtmntFnc501'),
('/CWH/CRNR/TRTMNT_FNCTN', '50103', 'CWHCerner', 'CM_TrtmntFnc501'),
('/CWH/CRNR/TRTMNT_FNCTN', '50104', 'CWHCerner', 'CM_TrtmntFnc501'),
('/CWH/CRNR/TRTMNT_FNCTN', '50105', 'CWHCerner', 'CM_TrtmntFnc501'),
('/CWH/CRNR/TRTMNT_FNCTN', '50112', 'CWHCerner', 'CM_TrtmntFnc501'),
('/CWH/CRNR/TRTMNT_FNCTN', '50113', 'CWHCerner', 'CM_TrtmntFnc501'),
('/CWH/CRNR/TRTMNT_FNCTN', '50201', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '50202', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '50203', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '50204', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '50205', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '50206', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '50207', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '50208', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '50209', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '50210', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '50211', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '50212', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '50232', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '50236', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '50238', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '50242', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '50247', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '50288', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '50292', 'CWHCerner', 'CM_TrtmntFnc502'),
('/CWH/CRNR/TRTMNT_FNCTN', '50301', 'CWHCerner', 'CM_TrtmntFnc503'),
('/CWH/CRNR/TRTMNT_FNCTN', '50302', 'CWHCerner', 'CM_TrtmntFnc503'),
('/CWH/CRNR/TRTMNT_FNCTN', '56099', 'CWHCerner', 'CM_TrtmntFnc560'),
('/CWH/CRNR/TRTMNT_FNCTN', '65001', 'CWHCerner', 'CM_TrtmntFnc650'),
('/CWH/CRNR/TRTMNT_FNCTN', '65002', 'CWHCerner', 'CM_TrtmntFnc650'),
('/CWH/CRNR/TRTMNT_FNCTN', '65003', 'CWHCerner', 'CM_TrtmntFnc650'),
('/CWH/CRNR/TRTMNT_FNCTN', '65004', 'CWHCerner', 'CM_TrtmntFnc650'),
('/CWH/CRNR/TRTMNT_FNCTN', '65099', 'CWHCerner', 'CM_TrtmntFnc650'),
('/CWH/CRNR/TRTMNT_FNCTN', '65101', 'CWHCerner', 'CM_TrtmntFnc651'),
('/CWH/CRNR/TRTMNT_FNCTN', '65102', 'CWHCerner', 'CM_TrtmntFnc651'),
('/CWH/CRNR/TRTMNT_FNCTN', '65199', 'CWHCerner', 'CM_TrtmntFnc651'),
('/CWH/CRNR/TRTMNT_FNCTN', '65299', 'CWHCerner', 'CM_TrtmntFnc652'),
('/CWH/CRNR/TRTMNT_FNCTN', '65399', 'CWHCerner', 'CM_TrtmntFnc653'),
('/CWH/CRNR/TRTMNT_FNCTN', '65401', 'CWHCerner', 'CM_TrtmntFnc654'),
('/CWH/CRNR/TRTMNT_FNCTN', '65402', 'CWHCerner', 'CM_TrtmntFnc654'),
('/CWH/CRNR/TRTMNT_FNCTN', '65403', 'CWHCerner', 'CM_TrtmntFnc654'),
('/CWH/CRNR/TRTMNT_FNCTN', '65499', 'CWHCerner', 'CM_TrtmntFnc654'),
('/CWH/CRNR/TRTMNT_FNCTN', '65599', 'CWHCerner', 'CM_TrtmntFnc655'),
('/CWH/CRNR/TRTMNT_FNCTN', '65699', 'CWHCerner', 'CM_TrtmntFnc656'),
('/CWH/CRNR/TRTMNT_FNCTN', '80001', 'CWHCerner', 'CM_TrtmntFnc800'),
('/CWH/CRNR/TRTMNT_FNCTN', '80002', 'CWHCerner', 'CM_TrtmntFnc800'),
('/CWH/CRNR/TRTMNT_FNCTN', '80003', 'CWHCerner', 'CM_TrtmntFnc800'),
('/CWH/CRNR/TRTMNT_FNCTN', '80004', 'CWHCerner', 'CM_TrtmntFnc800'),
('/CWH/CRNR/TRTMNT_FNCTN', '80005', 'CWHCerner', 'CM_TrtmntFnc800'),
('/CWH/CRNR/TRTMNT_FNCTN', '80019', 'CWHCerner', 'CM_TrtmntFnc800'),
('/CWH/CRNR/TRTMNT_FNCTN', '80022', 'CWHCerner', 'CM_TrtmntFnc800'),
('/CWH/CRNR/TRTMNT_FNCTN', '80024', 'CWHCerner', 'CM_TrtmntFnc800'),
('/CWH/CRNR/TRTMNT_FNCTN', '80099', 'CWHCerner', 'CM_TrtmntFnc800'),
('/CWH/CRNR/TRTMNT_FNCTN', '81199', 'CWHCerner', 'CM_TrtmntFnc811'),
       -- Missing from NHS-DD
('/CWH/CRNR/TRTMNT_FNCTN', '147L', 'CWHCerner', 'CM_TrtmntFnc147'),
('/CWH/CRNR/TRTMNT_FNCTN', '820L', 'CWHCerner', 'CM_TrtmntFnc820'),
('/CWH/CRNR/TRTMNT_FNCTN', '823L', 'CWHCerner', 'CM_TrtmntFnc823'),
('/CWH/CRNR/TRTMNT_FNCTN', '824L', 'CWHCerner', 'CM_TrtmntFnc824'),
('/CWH/CRNR/TRTMNT_FNCTN', '831L', 'CWHCerner', 'CM_TrtmntFnc831'),
('/CWH/CRNR/TRTMNT_FNCTN', '900L', 'CWHCerner', 'CM_TrtmntFnc900'),
('/CWH/CRNR/TRTMNT_FNCTN', '901L', 'CWHCerner', 'CM_TrtmntFnc901'),
('/CWH/CRNR/TRTMNT_FNCTN', '903L', 'CWHCerner', 'CM_TrtmntFnc903'),
('/CWH/CRNR/TRTMNT_FNCTN', '950L', 'CWHCerner', 'CM_TrtmntFnc950'),

-- New codes from 18-June-2021
('/CWH/CRNR/TRTMNT_FNCTN', '145', 'CWHCerner', 'CM_TrtmntFnc145'),
('/CWH/CRNR/TRTMNT_FNCTN', '830', 'CWHCerner', 'CM_TrtmntFnc830')
;


-- ******************** Admission Source ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_CWH', 'CM_Sys_Cerner', null, null, 'admission_source_code', '/CWH/CRNR/ADMSSN_SRC');

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/CWH/CRNR/ADMSSN_SRC', 'DM_sourceOfAdmission');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
    ('/CWH/CRNR/ADMSSN_SRC', '19', 'CWHCerner', 'CM_SrcAdmUsual'),
    ('/CWH/CRNR/ADMSSN_SRC', '29', 'CWHCerner', 'CM_SrcAdmTempR'),
    ('/CWH/CRNR/ADMSSN_SRC', '39', 'CWHCerner', 'CM_SrcAdmPePoCo'),
    ('/CWH/CRNR/ADMSSN_SRC', '39a', 'CWHCerner', 'CM_SrcAdmPePoCo'), -- Custom local
    ('/CWH/CRNR/ADMSSN_SRC', '40', 'CWHCerner', 'CM_SrcAdmPe'),
    ('/CWH/CRNR/ADMSSN_SRC', '41', 'CWHCerner', 'CM_SrcAdmCo'),
    ('/CWH/CRNR/ADMSSN_SRC', '42', 'CWHCerner', 'CM_SrcAdmPo'),
    ('/CWH/CRNR/ADMSSN_SRC', '49', 'CWHCerner', 'CM_SrcAdmPSyHosp'),
    ('/CWH/CRNR/ADMSSN_SRC', '51', 'CWHCerner', 'CM_SrcAdmA1'),
    ('/CWH/CRNR/ADMSSN_SRC', '52', 'CWHCerner', 'CM_SrcAdmA2'),
    ('/CWH/CRNR/ADMSSN_SRC', '53', 'CWHCerner', 'CM_SrcAdmA3'),
    ('/CWH/CRNR/ADMSSN_SRC', '54', 'CWHCerner', 'CM_SrcAdmA4'),
    ('/CWH/CRNR/ADMSSN_SRC', '65', 'CWHCerner', 'CM_SrcAdmA5'),
    ('/CWH/CRNR/ADMSSN_SRC', '66', 'CWHCerner', 'CM_SrcAdmA6'),
    ('/CWH/CRNR/ADMSSN_SRC', '79', 'CWHCerner', 'CM_SrcAdmA7'),
    ('/CWH/CRNR/ADMSSN_SRC', '85', 'CWHCerner', 'CM_SrcAdmA8'),
    ('/CWH/CRNR/ADMSSN_SRC', '87', 'CWHCerner', 'CM_SrcAdmA9'),
    ('/CWH/CRNR/ADMSSN_SRC', '88', 'CWHCerner', 'CM_SrcAsmA10');

-- ******************** Admission Method ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_CWH', 'CM_Sys_Cerner', null, null, 'admission_method_code', '/CDS/INPTNT/ADMSSN_MTHD');

-- ******************** Discharge Method ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_CWH', 'CM_Sys_Cerner', null, null, 'discharge_method', '/CDS/INPTNT/DSCHRG_MTHD');

-- ******************** Discharge Destination ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_CWH', 'CM_Sys_Cerner', null, null, 'discharge_destination_code', '/CDS/INPTNT/DSCHRG_DSTNTN');

-- ******************** Ethnicity ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_CWH', 'CM_Sys_Cerner', null, null, 'ethnicity', '/CDS/PTNT/ETHNC_CTGRY');
