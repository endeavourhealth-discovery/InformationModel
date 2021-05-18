-- ****************************************************
-- ** REQUIRES
-- **   - NHSDD/Religion
-- **   - FHIR/Language
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
INSERT IGNORE INTO concept_property_data
(`dbid`, `group`, `property`, `value`)
SELECT c.dbid, 0 AS `group`, p.dbid AS `property`, 'IC_' AS `value`
FROM concept c
         JOIN concept p ON p.id = 'code_prefix'
WHERE c.id = 'ImperialCerner';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
-- GENERAL/GLOBAL --
(1, 'CM_Org_Imperial', @scm, 'CM_Org_Imperial', 'Imperial College', 'Imperial College Hospital, London'),
(1, 'CM_Sys_Cerner', @scm, 'CM_Sys_Cerner', 'Cerner Millennium', 'Cerner Millennium system'),
(1, 'ImperialCerner', @scm, 'ImperialCerner', 'Imperial Local Codes', 'Imperial Cerner local code scheme'),
(1, 'DM_patientFIN', @scm, 'DM_patientFIN', 'Patient FIN', 'Patient FIN'),
(1, 'DM_gpPractitionerId', @scm, 'DM_gpPractitionerId', 'GP Practitioner Id', 'GP Practitioner Id');

-- ******************** Religion ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Imperial', 'CM_Sys_Cerner', null, null, 'religion', '/IMPRL/CRNR/RLGN');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/IMPRL/CRNR/RLGN', 'DM_religion');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/IMPRL/CRNR/RLGN', 'HINDU', 'ImperialCerner', 'CM_ReligionD1'),
('/IMPRL/CRNR/RLGN', 'OTHER', 'ImperialCerner', 'CM_ReligionK20'),
('/IMPRL/CRNR/RLGN', 'SIKH', 'ImperialCerner', 'CM_ReligionI1'),
('/IMPRL/CRNR/RLGN', 'A', 'ImperialCerner', 'CM_ReligionA1'),
('/IMPRL/CRNR/RLGN', 'BUDDHISM', 'ImperialCerner', 'CM_ReligionB1'),
('/IMPRL/CRNR/RLGN', 'CHRISTIAN', 'ImperialCerner', 'CM_ReligionC1'),
('/IMPRL/CRNR/RLGN', 'M', 'ImperialCerner', 'CM_ReligionM1'),
('/IMPRL/CRNR/RLGN', 'E', 'ImperialCerner', 'CM_ReligionE1'),
('/IMPRL/CRNR/RLGN', 'JUDAISM', 'ImperialCerner', 'CM_ReligionF1'),
('/IMPRL/CRNR/RLGN', 'G', 'ImperialCerner', 'CM_ReligionG1'),
('/IMPRL/CRNR/RLGN', 'L', 'ImperialCerner', 'CM_ReligionL2'),
('/IMPRL/CRNR/RLGN', 'H', 'ImperialCerner', 'CM_ReligionH1'),
('/IMPRL/CRNR/RLGN', 'N', 'ImperialCerner', 'CM_ReligionN1'),
('/IMPRL/CRNR/RLGN', 'J', 'ImperialCerner', 'CM_ReligionJ1');


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
(1, 'IC_Lang_51', @scm, 'IC_Lang_51', 'Sylheti', 'Sylheti');

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Imperial', 'CM_Sys_Cerner', null, null, 'language', '/IMPRL/CRNR/LNGG');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/IMPRL/CRNR/LNGG', 'DM_language');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/IMPRL/CRNR/LNGG', '1', 'ImperialCerner', 'FHIR_LANG_ak'),
('/IMPRL/CRNR/LNGG', '3', 'ImperialCerner', 'FHIR_LANG_am'),
('/IMPRL/CRNR/LNGG', '4', 'ImperialCerner', 'FHIR_LANG_ar'),
('/IMPRL/CRNR/LNGG', '5', 'ImperialCerner', 'FHIR_LANG_bn'),
('/IMPRL/CRNR/LNGG', '59', 'ImperialCerner', 'FHIR_LANG_cy'),
('/IMPRL/CRNR/LNGG', '20', 'ImperialCerner', 'FHIR_LANG_de'),
('/IMPRL/CRNR/LNGG', '21', 'ImperialCerner', 'FHIR_LANG_el'),
('/IMPRL/CRNR/LNGG', '12', 'ImperialCerner', 'FHIR_LANG_en'),
('/IMPRL/CRNR/LNGG', '48', 'ImperialCerner', 'FHIR_LANG_es'),
('/IMPRL/CRNR/LNGG', '14', 'ImperialCerner', 'FHIR_LANG_fa'),
('/IMPRL/CRNR/LNGG', '15', 'ImperialCerner', 'FHIR_LANG_fi'),
('/IMPRL/CRNR/LNGG', '17', 'ImperialCerner', 'FHIR_LANG_fr'),
('/IMPRL/CRNR/LNGG', '19', 'ImperialCerner', 'FHIR_LANG_gd'),
('/IMPRL/CRNR/LNGG', '22', 'ImperialCerner', 'FHIR_LANG_gu'),
('/IMPRL/CRNR/LNGG', '24', 'ImperialCerner', 'FHIR_LANG_ha'),
('/IMPRL/CRNR/LNGG', '25', 'ImperialCerner', 'FHIR_LANG_he'),
('/IMPRL/CRNR/LNGG', '26', 'ImperialCerner', 'FHIR_LANG_hi'),
('/IMPRL/CRNR/LNGG', '27', 'ImperialCerner', 'FHIR_LANG_ig'),
('/IMPRL/CRNR/LNGG', '28', 'ImperialCerner', 'FHIR_LANG_it'),
('/IMPRL/CRNR/LNGG', '29', 'ImperialCerner', 'FHIR_LANG_ja'),
('/IMPRL/CRNR/LNGG', '30', 'ImperialCerner', 'FHIR_LANG_ko'),
('/IMPRL/CRNR/LNGG', '31', 'ImperialCerner', 'FHIR_LANG_ku'),
('/IMPRL/CRNR/LNGG', '32', 'ImperialCerner', 'FHIR_LANG_ln'),
('/IMPRL/CRNR/LNGG', '35', 'ImperialCerner', 'FHIR_LANG_ml'),
('/IMPRL/CRNR/LNGG', '11', 'ImperialCerner', 'FHIR_LANG_nl'),
('/IMPRL/CRNR/LNGG', '16', 'ImperialCerner', 'FHIR_LANG_nl'),
('/IMPRL/CRNR/LNGG', '37', 'ImperialCerner', 'FHIR_LANG_no'),
('/IMPRL/CRNR/LNGG', '42', 'ImperialCerner', 'FHIR_LANG_pa'),
('/IMPRL/CRNR/LNGG', '40', 'ImperialCerner', 'FHIR_LANG_pl'),
('/IMPRL/CRNR/LNGG', '38', 'ImperialCerner', 'FHIR_LANG_ps'),
('/IMPRL/CRNR/LNGG', '41', 'ImperialCerner', 'FHIR_LANG_pt'),
('/IMPRL/CRNR/LNGG', '43', 'ImperialCerner', 'FHIR_LANG_ru'),
('/IMPRL/CRNR/LNGG', '45', 'ImperialCerner', 'FHIR_LANG_si'),
('/IMPRL/CRNR/LNGG', '6', 'ImperialCerner', 'FHIR_LANG_so'),
('/IMPRL/CRNR/LNGG', '46', 'ImperialCerner', 'FHIR_LANG_so'),
('/IMPRL/CRNR/LNGG', '2', 'ImperialCerner', 'FHIR_LANG_sq'),
('/IMPRL/CRNR/LNGG', '50', 'ImperialCerner', 'FHIR_LANG_sv'),
('/IMPRL/CRNR/LNGG', '49', 'ImperialCerner', 'FHIR_LANG_sw'),
('/IMPRL/CRNR/LNGG', '53', 'ImperialCerner', 'FHIR_LANG_ta'),
('/IMPRL/CRNR/LNGG', '54', 'ImperialCerner', 'FHIR_LANG_th'),
('/IMPRL/CRNR/LNGG', '55', 'ImperialCerner', 'FHIR_LANG_ti'),
('/IMPRL/CRNR/LNGG', '52', 'ImperialCerner', 'FHIR_LANG_tl'),
('/IMPRL/CRNR/LNGG', '56', 'ImperialCerner', 'FHIR_LANG_tr'),
('/IMPRL/CRNR/LNGG', '57', 'ImperialCerner', 'FHIR_LANG_ur'),
('/IMPRL/CRNR/LNGG', '9', 'ImperialCerner', 'FHIR_LANG_vi'),
('/IMPRL/CRNR/LNGG', '58', 'ImperialCerner', 'FHIR_LANG_vi'),
('/IMPRL/CRNR/LNGG', '60', 'ImperialCerner', 'FHIR_LANG_yo'),
('/IMPRL/CRNR/LNGG', '7', 'ImperialCerner', 'FHIR_LANG_q4'),
('/IMPRL/CRNR/LNGG', '34', 'ImperialCerner', 'FHIR_LANG_q5'),
-- Local
('/IMPRL/CRNR/LNGG', '8', 'ImperialCerner', 'IC_Lang_8'),
('/IMPRL/CRNR/LNGG', '10', 'ImperialCerner', 'IC_Lang_10'),
('/IMPRL/CRNR/LNGG', '13', 'ImperialCerner', 'IC_Lang_13'),
('/IMPRL/CRNR/LNGG', '18', 'ImperialCerner', 'IC_Lang_18'),
('/IMPRL/CRNR/LNGG', '23', 'ImperialCerner', 'IC_Lang_23'),
('/IMPRL/CRNR/LNGG', '33', 'ImperialCerner', 'IC_Lang_33'),
('/IMPRL/CRNR/LNGG', '36', 'ImperialCerner', 'IC_Lang_36'),
('/IMPRL/CRNR/LNGG', '200', 'ImperialCerner', 'IC_Lang_200'),
('/IMPRL/CRNR/LNGG', '39', 'ImperialCerner', 'IC_Lang_39'),
('/IMPRL/CRNR/LNGG', '51', 'ImperialCerner', 'IC_Lang_51');

-- ******************** FIN Number ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Imperial', 'CM_Sys_Cerner', null, null, 'fin_number', '/IMPRL/CRNR/FN_NMBR');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/IMPRL/CRNR/FN_NMBR',   'DM_patientFIN');

-- ******************** Encounter ********************

-- Concepts
SELECT @scm := dbid FROM concept WHERE id = 'ImperialCerner';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
(1, 'IC_Enc_Inpatient', @scm, 'IC_Enc_Inpatient', 'Inpatient', 'Inpatient'),
(1, 'IC_Enc_Recurring', @scm, 'IC_Enc_Recurring', 'Regular day admission', 'Regular day admission'),
(1, 'IC_Enc_Emergency', @scm, 'IC_Enc_Emergency', 'Emergency department', 'Emergency department'),
(1, 'IC_Enc_WaitList', @scm, 'IC_Enc_WaitList', 'Outpatient referral', 'Outpatient referral'),
(1, 'IC_Enc_PreAdmit', @scm, 'IC_Enc_PreAdmit', 'Outpatient registration', 'Outpatient registration');

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Imperial', 'CM_Sys_Cerner', null, null, 'encounter_type', '/IMPRL/CRNR/ENCNTR_TYP');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/IMPRL/CRNR/ENCNTR_TYP', 'DM_admissionPatientClassification');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/IMPRL/CRNR/ENCNTR_TYP', 'INPATIENT', 'ImperialCerner', 'IC_Enc_Inpatient'),
('/IMPRL/CRNR/ENCNTR_TYP', 'RECURRING', 'ImperialCerner', 'IC_Enc_Recurring'),
('/IMPRL/CRNR/ENCNTR_TYP', 'EMERGENCY', 'ImperialCerner', 'IC_Enc_Emergency'),
('/IMPRL/CRNR/ENCNTR_TYP', 'WAITLIST', 'ImperialCerner', 'IC_Enc_WaitList'),
('/IMPRL/CRNR/ENCNTR_TYP', 'PREADMIT', 'ImperialCerner', 'IC_Enc_PreAdmit');

-- ******************** Treatment Function ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Imperial', 'CM_Sys_Cerner', null, null, 'treatment_function_code', '/IMPRL/CRNR/TRTMNT_FNCTN');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/IMPRL/CRNR/TRTMNT_FNCTN', 'DM_treatmentFunctionAdmit');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/IMPRL/CRNR/TRTMNT_FNCTN', '100', 'ImperialCerner', 'CM_TrtmntFnc100'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '101', 'ImperialCerner', 'CM_TrtmntFnc101'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '102', 'ImperialCerner', 'CM_TrtmntFnc102'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '103', 'ImperialCerner', 'CM_TrtmntFnc103'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '104', 'ImperialCerner', 'CM_TrtmntFnc104'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '105', 'ImperialCerner', 'CM_TrtmntFnc105'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '106', 'ImperialCerner', 'CM_TrtmntFnc106'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '107', 'ImperialCerner', 'CM_TrtmntFnc107'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '108', 'ImperialCerner', 'CM_TrtmntFnc108'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '110', 'ImperialCerner', 'CM_TrtmntFnc110'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '120', 'ImperialCerner', 'CM_TrtmntFnc120'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '130', 'ImperialCerner', 'CM_TrtmntFnc130'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '140', 'ImperialCerner', 'CM_TrtmntFnc140'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '141', 'ImperialCerner', 'CM_TrtmntFnc141'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '142', 'ImperialCerner', 'CM_TrtmntFnc142'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '143', 'ImperialCerner', 'CM_TrtmntFnc143'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '144', 'ImperialCerner', 'CM_TrtmntFnc144'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '150', 'ImperialCerner', 'CM_TrtmntFnc150'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '160', 'ImperialCerner', 'CM_TrtmntFnc160'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '161', 'ImperialCerner', 'CM_TrtmntFnc161'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '170', 'ImperialCerner', 'CM_TrtmntFnc170'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '171', 'ImperialCerner', 'CM_TrtmntFnc171'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '172', 'ImperialCerner', 'CM_TrtmntFnc172'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '173', 'ImperialCerner', 'CM_TrtmntFnc173'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '174', 'ImperialCerner', 'CM_TrtmntFnc174'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '180', 'ImperialCerner', 'CM_TrtmntFnc180'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '190', 'ImperialCerner', 'CM_TrtmntFnc190'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '191', 'ImperialCerner', 'CM_TrtmntFnc191'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '192', 'ImperialCerner', 'CM_TrtmntFnc192'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '211', 'ImperialCerner', 'CM_TrtmntFnc211'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '212', 'ImperialCerner', 'CM_TrtmntFnc212'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '213', 'ImperialCerner', 'CM_TrtmntFnc213'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '214', 'ImperialCerner', 'CM_TrtmntFnc214'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '215', 'ImperialCerner', 'CM_TrtmntFnc215'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '216', 'ImperialCerner', 'CM_TrtmntFnc216'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '217', 'ImperialCerner', 'CM_TrtmntFnc217'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '218', 'ImperialCerner', 'CM_TrtmntFnc218'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '219', 'ImperialCerner', 'CM_TrtmntFnc219'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '220', 'ImperialCerner', 'CM_TrtmntFnc220'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '221', 'ImperialCerner', 'CM_TrtmntFnc221'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '222', 'ImperialCerner', 'CM_TrtmntFnc222'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '223', 'ImperialCerner', 'CM_TrtmntFnc223'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '241', 'ImperialCerner', 'CM_TrtmntFnc241'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '242', 'ImperialCerner', 'CM_TrtmntFnc242'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '251', 'ImperialCerner', 'CM_TrtmntFnc251'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '252', 'ImperialCerner', 'CM_TrtmntFnc252'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '253', 'ImperialCerner', 'CM_TrtmntFnc253'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '254', 'ImperialCerner', 'CM_TrtmntFnc254'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '255', 'ImperialCerner', 'CM_TrtmntFnc255'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '256', 'ImperialCerner', 'CM_TrtmntFnc256'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '257', 'ImperialCerner', 'CM_TrtmntFnc257'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '258', 'ImperialCerner', 'CM_TrtmntFnc258'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '259', 'ImperialCerner', 'CM_TrtmntFnc259'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '260', 'ImperialCerner', 'CM_TrtmntFnc260'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '261', 'ImperialCerner', 'CM_TrtmntFnc261'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '262', 'ImperialCerner', 'CM_TrtmntFnc262'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '263', 'ImperialCerner', 'CM_TrtmntFnc263'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '264', 'ImperialCerner', 'CM_TrtmntFnc264'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '280', 'ImperialCerner', 'CM_TrtmntFnc280'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '290', 'ImperialCerner', 'CM_TrtmntFnc290'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '291', 'ImperialCerner', 'CM_TrtmntFnc291'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '300', 'ImperialCerner', 'CM_TrtmntFnc300'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '301', 'ImperialCerner', 'CM_TrtmntFnc301'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '302', 'ImperialCerner', 'CM_TrtmntFnc302'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '303', 'ImperialCerner', 'CM_TrtmntFnc303'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '304', 'ImperialCerner', 'CM_TrtmntFnc304'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '305', 'ImperialCerner', 'CM_TrtmntFnc305'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '306', 'ImperialCerner', 'CM_TrtmntFnc306'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '307', 'ImperialCerner', 'CM_TrtmntFnc307'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '308', 'ImperialCerner', 'CM_TrtmntFnc308'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '309', 'ImperialCerner', 'CM_TrtmntFnc309'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '310', 'ImperialCerner', 'CM_TrtmntFnc310'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '311', 'ImperialCerner', 'CM_TrtmntFnc311'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '313', 'ImperialCerner', 'CM_TrtmntFnc313'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '314', 'ImperialCerner', 'CM_TrtmntFnc314'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '315', 'ImperialCerner', 'CM_TrtmntFnc315'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '316', 'ImperialCerner', 'CM_TrtmntFnc316'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '317', 'ImperialCerner', 'CM_TrtmntFnc317'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '318', 'ImperialCerner', 'CM_TrtmntFnc318'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '319', 'ImperialCerner', 'CM_TrtmntFnc319'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '320', 'ImperialCerner', 'CM_TrtmntFnc320'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '321', 'ImperialCerner', 'CM_TrtmntFnc321'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '322', 'ImperialCerner', 'CM_TrtmntFnc322'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '323', 'ImperialCerner', 'CM_TrtmntFnc323'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '324', 'ImperialCerner', 'CM_TrtmntFnc324'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '325', 'ImperialCerner', 'CM_TrtmntFnc325'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '327', 'ImperialCerner', 'CM_TrtmntFnc327'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '328', 'ImperialCerner', 'CM_TrtmntFnc328'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '329', 'ImperialCerner', 'CM_TrtmntFnc329'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '330', 'ImperialCerner', 'CM_TrtmntFnc330'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '331', 'ImperialCerner', 'CM_TrtmntFnc331'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '340', 'ImperialCerner', 'CM_TrtmntFnc340'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '341', 'ImperialCerner', 'CM_TrtmntFnc341'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '342', 'ImperialCerner', 'CM_TrtmntFnc342'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '343', 'ImperialCerner', 'CM_TrtmntFnc343'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '344', 'ImperialCerner', 'CM_TrtmntFnc344'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '346', 'ImperialCerner', 'CM_TrtmntFnc346'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '350', 'ImperialCerner', 'CM_TrtmntFnc350'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '352', 'ImperialCerner', 'CM_TrtmntFnc352'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '360', 'ImperialCerner', 'CM_TrtmntFnc360'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '361', 'ImperialCerner', 'CM_TrtmntFnc361'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '370', 'ImperialCerner', 'CM_TrtmntFnc370'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '371', 'ImperialCerner', 'CM_TrtmntFnc371'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '400', 'ImperialCerner', 'CM_TrtmntFnc400'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '410', 'ImperialCerner', 'CM_TrtmntFnc410'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '420', 'ImperialCerner', 'CM_TrtmntFnc420'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '421', 'ImperialCerner', 'CM_TrtmntFnc421'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '422', 'ImperialCerner', 'CM_TrtmntFnc422'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '424', 'ImperialCerner', 'CM_TrtmntFnc424'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '430', 'ImperialCerner', 'CM_TrtmntFnc430'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '450', 'ImperialCerner', 'CM_TrtmntFnc450'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '460', 'ImperialCerner', 'CM_TrtmntFnc460'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '501', 'ImperialCerner', 'CM_TrtmntFnc501'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '502', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '503', 'ImperialCerner', 'CM_TrtmntFnc503'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '560', 'ImperialCerner', 'CM_TrtmntFnc560'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '650', 'ImperialCerner', 'CM_TrtmntFnc650'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '651', 'ImperialCerner', 'CM_TrtmntFnc651'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '652', 'ImperialCerner', 'CM_TrtmntFnc652'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '653', 'ImperialCerner', 'CM_TrtmntFnc653'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '654', 'ImperialCerner', 'CM_TrtmntFnc654'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '655', 'ImperialCerner', 'CM_TrtmntFnc655'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '656', 'ImperialCerner', 'CM_TrtmntFnc656'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '657', 'ImperialCerner', 'CM_TrtmntFnc657'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '658', 'ImperialCerner', 'CM_TrtmntFnc658'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '659', 'ImperialCerner', 'CM_TrtmntFnc659'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '660', 'ImperialCerner', 'CM_TrtmntFnc660'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '661', 'ImperialCerner', 'CM_TrtmntFnc661'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '662', 'ImperialCerner', 'CM_TrtmntFnc662'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '663', 'ImperialCerner', 'CM_TrtmntFnc663'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '700', 'ImperialCerner', 'CM_TrtmntFnc700'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '710', 'ImperialCerner', 'CM_TrtmntFnc710'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '711', 'ImperialCerner', 'CM_TrtmntFnc711'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '712', 'ImperialCerner', 'CM_TrtmntFnc712'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '713', 'ImperialCerner', 'CM_TrtmntFnc713'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '715', 'ImperialCerner', 'CM_TrtmntFnc715'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '720', 'ImperialCerner', 'CM_TrtmntFnc720'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '721', 'ImperialCerner', 'CM_TrtmntFnc721'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '722', 'ImperialCerner', 'CM_TrtmntFnc722'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '723', 'ImperialCerner', 'CM_TrtmntFnc723'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '724', 'ImperialCerner', 'CM_TrtmntFnc724'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '725', 'ImperialCerner', 'CM_TrtmntFnc725'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '726', 'ImperialCerner', 'CM_TrtmntFnc726'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '727', 'ImperialCerner', 'CM_TrtmntFnc727'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '800', 'ImperialCerner', 'CM_TrtmntFnc800'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '811', 'ImperialCerner', 'CM_TrtmntFnc811'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '812', 'ImperialCerner', 'CM_TrtmntFnc812'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '822', 'ImperialCerner', 'CM_TrtmntFnc822'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '834', 'ImperialCerner', 'CM_TrtmntFnc834'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '840', 'ImperialCerner', 'CM_TrtmntFnc840'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '920', 'ImperialCerner', 'CM_TrtmntFnc920'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '10001', 'ImperialCerner', 'CM_TrtmntFnc100'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '10002', 'ImperialCerner', 'CM_TrtmntFnc100'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '10099', 'ImperialCerner', 'CM_TrtmntFnc100'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '10101', 'ImperialCerner', 'CM_TrtmntFnc101'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '10102', 'ImperialCerner', 'CM_TrtmntFnc101'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '10130', 'ImperialCerner', 'CM_TrtmntFnc101'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '10199', 'ImperialCerner', 'CM_TrtmntFnc101'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '10240', 'ImperialCerner', 'CM_TrtmntFnc102'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '10246', 'ImperialCerner', 'CM_TrtmntFnc102'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '10299', 'ImperialCerner', 'CM_TrtmntFnc102'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '10399', 'ImperialCerner', 'CM_TrtmntFnc103'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '10499', 'ImperialCerner', 'CM_TrtmntFnc104'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '10539', 'ImperialCerner', 'CM_TrtmntFnc105'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '10599', 'ImperialCerner', 'CM_TrtmntFnc105'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '10699', 'ImperialCerner', 'CM_TrtmntFnc106'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '10701', 'ImperialCerner', 'CM_TrtmntFnc107'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '10799', 'ImperialCerner', 'CM_TrtmntFnc107'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '11001', 'ImperialCerner', 'CM_TrtmntFnc110'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '11002', 'ImperialCerner', 'CM_TrtmntFnc110'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '11003', 'ImperialCerner', 'CM_TrtmntFnc110'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '11004', 'ImperialCerner', 'CM_TrtmntFnc110'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '11005', 'ImperialCerner', 'CM_TrtmntFnc110'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '11099', 'ImperialCerner', 'CM_TrtmntFnc110'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '12033', 'ImperialCerner', 'CM_TrtmntFnc120'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '12099', 'ImperialCerner', 'CM_TrtmntFnc120'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '13014', 'ImperialCerner', 'CM_TrtmntFnc130'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '13020', 'ImperialCerner', 'CM_TrtmntFnc130'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '13044', 'ImperialCerner', 'CM_TrtmntFnc130'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '13099', 'ImperialCerner', 'CM_TrtmntFnc130'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '14099', 'ImperialCerner', 'CM_TrtmntFnc140'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '14499', 'ImperialCerner', 'CM_TrtmntFnc144'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '15099', 'ImperialCerner', 'CM_TrtmntFnc150'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '16001', 'ImperialCerner', 'CM_TrtmntFnc160'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '16002', 'ImperialCerner', 'CM_TrtmntFnc160'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '16099', 'ImperialCerner', 'CM_TrtmntFnc160'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '16199', 'ImperialCerner', 'CM_TrtmntFnc161'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '17111', 'ImperialCerner', 'CM_TrtmntFnc171'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '17299', 'ImperialCerner', 'CM_TrtmntFnc172'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '17399', 'ImperialCerner', 'CM_TrtmntFnc173'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '19029', 'ImperialCerner', 'CM_TrtmntFnc190'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '19199', 'ImperialCerner', 'CM_TrtmntFnc191'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '21499', 'ImperialCerner', 'CM_TrtmntFnc214'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '25399', 'ImperialCerner', 'CM_TrtmntFnc253'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '25501', 'ImperialCerner', 'CM_TrtmntFnc255'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '25801', 'ImperialCerner', 'CM_TrtmntFnc258'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '25945', 'ImperialCerner', 'CM_TrtmntFnc259'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30001', 'ImperialCerner', 'CM_TrtmntFnc300'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30002', 'ImperialCerner', 'CM_TrtmntFnc300'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30043', 'ImperialCerner', 'CM_TrtmntFnc300'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30099', 'ImperialCerner', 'CM_TrtmntFnc300'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30101', 'ImperialCerner', 'CM_TrtmntFnc301'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30102', 'ImperialCerner', 'CM_TrtmntFnc301'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30103', 'ImperialCerner', 'CM_TrtmntFnc301'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30199', 'ImperialCerner', 'CM_TrtmntFnc301'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30201', 'ImperialCerner', 'CM_TrtmntFnc302'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30299', 'ImperialCerner', 'CM_TrtmntFnc302'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30301', 'ImperialCerner', 'CM_TrtmntFnc303'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30303', 'ImperialCerner', 'CM_TrtmntFnc303'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30304', 'ImperialCerner', 'CM_TrtmntFnc303'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30307', 'ImperialCerner', 'CM_TrtmntFnc303'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30335', 'ImperialCerner', 'CM_TrtmntFnc303'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30337', 'ImperialCerner', 'CM_TrtmntFnc303'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30341', 'ImperialCerner', 'CM_TrtmntFnc303'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30399', 'ImperialCerner', 'CM_TrtmntFnc303'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30627', 'ImperialCerner', 'CM_TrtmntFnc306'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30699', 'ImperialCerner', 'CM_TrtmntFnc306'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30717', 'ImperialCerner', 'CM_TrtmntFnc307'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30799', 'ImperialCerner', 'CM_TrtmntFnc307'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30801', 'ImperialCerner', 'CM_TrtmntFnc308'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30802', 'ImperialCerner', 'CM_TrtmntFnc308'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30803', 'ImperialCerner', 'CM_TrtmntFnc308'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30804', 'ImperialCerner', 'CM_TrtmntFnc308'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30805', 'ImperialCerner', 'CM_TrtmntFnc308'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30806', 'ImperialCerner', 'CM_TrtmntFnc308'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30807', 'ImperialCerner', 'CM_TrtmntFnc308'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30808', 'ImperialCerner', 'CM_TrtmntFnc308'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30809', 'ImperialCerner', 'CM_TrtmntFnc308'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30810', 'ImperialCerner', 'CM_TrtmntFnc308'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30811', 'ImperialCerner', 'CM_TrtmntFnc308'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30899', 'ImperialCerner', 'CM_TrtmntFnc308'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '30999', 'ImperialCerner', 'CM_TrtmntFnc309'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '31099', 'ImperialCerner', 'CM_TrtmntFnc310'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '31101', 'ImperialCerner', 'CM_TrtmntFnc311'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '31399', 'ImperialCerner', 'CM_TrtmntFnc313'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '31699', 'ImperialCerner', 'CM_TrtmntFnc316'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '31799', 'ImperialCerner', 'CM_TrtmntFnc317'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '31899', 'ImperialCerner', 'CM_TrtmntFnc318'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '31999', 'ImperialCerner', 'CM_TrtmntFnc319'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '32002', 'ImperialCerner', 'CM_TrtmntFnc320'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '32005', 'ImperialCerner', 'CM_TrtmntFnc320'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '32006', 'ImperialCerner', 'CM_TrtmntFnc320'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '32099', 'ImperialCerner', 'CM_TrtmntFnc320'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '32299', 'ImperialCerner', 'CM_TrtmntFnc322'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '32399', 'ImperialCerner', 'CM_TrtmntFnc323'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '32499', 'ImperialCerner', 'CM_TrtmntFnc324'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '33001', 'ImperialCerner', 'CM_TrtmntFnc330'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '33099', 'ImperialCerner', 'CM_TrtmntFnc330'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '34001', 'ImperialCerner', 'CM_TrtmntFnc340'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '34021', 'ImperialCerner', 'CM_TrtmntFnc340'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '34023', 'ImperialCerner', 'CM_TrtmntFnc340'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '34099', 'ImperialCerner', 'CM_TrtmntFnc340'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '34199', 'ImperialCerner', 'CM_TrtmntFnc341'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '35008', 'ImperialCerner', 'CM_TrtmntFnc350'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '35099', 'ImperialCerner', 'CM_TrtmntFnc350'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '36001', 'ImperialCerner', 'CM_TrtmntFnc360'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '36002', 'ImperialCerner', 'CM_TrtmntFnc360'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '36003', 'ImperialCerner', 'CM_TrtmntFnc360'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '36004', 'ImperialCerner', 'CM_TrtmntFnc360'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '36099', 'ImperialCerner', 'CM_TrtmntFnc360'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '36102', 'ImperialCerner', 'CM_TrtmntFnc361'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '36103', 'ImperialCerner', 'CM_TrtmntFnc361'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '36104', 'ImperialCerner', 'CM_TrtmntFnc361'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '36120', 'ImperialCerner', 'CM_TrtmntFnc361'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '36199', 'ImperialCerner', 'CM_TrtmntFnc361'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '37001', 'ImperialCerner', 'CM_TrtmntFnc370'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '37002', 'ImperialCerner', 'CM_TrtmntFnc370'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '37003', 'ImperialCerner', 'CM_TrtmntFnc370'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '37004', 'ImperialCerner', 'CM_TrtmntFnc370'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '37005', 'ImperialCerner', 'CM_TrtmntFnc370'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '37006', 'ImperialCerner', 'CM_TrtmntFnc370'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '37007', 'ImperialCerner', 'CM_TrtmntFnc370'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '37008', 'ImperialCerner', 'CM_TrtmntFnc370'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '37009', 'ImperialCerner', 'CM_TrtmntFnc370'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '37010', 'ImperialCerner', 'CM_TrtmntFnc370'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '37011', 'ImperialCerner', 'CM_TrtmntFnc370'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '37012', 'ImperialCerner', 'CM_TrtmntFnc370'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '37015', 'ImperialCerner', 'CM_TrtmntFnc370'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '37099', 'ImperialCerner', 'CM_TrtmntFnc370'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '40001', 'ImperialCerner', 'CM_TrtmntFnc400'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '40002', 'ImperialCerner', 'CM_TrtmntFnc400'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '40003', 'ImperialCerner', 'CM_TrtmntFnc400'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '40018', 'ImperialCerner', 'CM_TrtmntFnc400'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '40099', 'ImperialCerner', 'CM_TrtmntFnc400'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '41028', 'ImperialCerner', 'CM_TrtmntFnc410'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '41099', 'ImperialCerner', 'CM_TrtmntFnc410'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '42001', 'ImperialCerner', 'CM_TrtmntFnc420'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '42002', 'ImperialCerner', 'CM_TrtmntFnc420'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '42003', 'ImperialCerner', 'CM_TrtmntFnc420'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '42004', 'ImperialCerner', 'CM_TrtmntFnc420'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '42005', 'ImperialCerner', 'CM_TrtmntFnc420'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '42007', 'ImperialCerner', 'CM_TrtmntFnc420'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '42008', 'ImperialCerner', 'CM_TrtmntFnc420'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '42099', 'ImperialCerner', 'CM_TrtmntFnc420'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '42201', 'ImperialCerner', 'CM_TrtmntFnc422'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '42202', 'ImperialCerner', 'CM_TrtmntFnc422'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '42209', 'ImperialCerner', 'CM_TrtmntFnc422'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '42210', 'ImperialCerner', 'CM_TrtmntFnc422'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '42221', 'ImperialCerner', 'CM_TrtmntFnc422'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '42299', 'ImperialCerner', 'CM_TrtmntFnc422'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '42499', 'ImperialCerner', 'CM_TrtmntFnc424'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '43005', 'ImperialCerner', 'CM_TrtmntFnc430'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '43010', 'ImperialCerner', 'CM_TrtmntFnc430'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '43011', 'ImperialCerner', 'CM_TrtmntFnc430'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '43099', 'ImperialCerner', 'CM_TrtmntFnc430'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50101', 'ImperialCerner', 'CM_TrtmntFnc501'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50102', 'ImperialCerner', 'CM_TrtmntFnc501'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50103', 'ImperialCerner', 'CM_TrtmntFnc501'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50104', 'ImperialCerner', 'CM_TrtmntFnc501'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50105', 'ImperialCerner', 'CM_TrtmntFnc501'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50112', 'ImperialCerner', 'CM_TrtmntFnc501'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50113', 'ImperialCerner', 'CM_TrtmntFnc501'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50201', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50202', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50203', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50204', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50205', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50206', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50207', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50208', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50209', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50210', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50211', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50212', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50232', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50236', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50238', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50242', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50247', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50288', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50292', 'ImperialCerner', 'CM_TrtmntFnc502'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50301', 'ImperialCerner', 'CM_TrtmntFnc503'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '50302', 'ImperialCerner', 'CM_TrtmntFnc503'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '56099', 'ImperialCerner', 'CM_TrtmntFnc560'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '65001', 'ImperialCerner', 'CM_TrtmntFnc650'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '65002', 'ImperialCerner', 'CM_TrtmntFnc650'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '65003', 'ImperialCerner', 'CM_TrtmntFnc650'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '65004', 'ImperialCerner', 'CM_TrtmntFnc650'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '65099', 'ImperialCerner', 'CM_TrtmntFnc650'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '65101', 'ImperialCerner', 'CM_TrtmntFnc651'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '65102', 'ImperialCerner', 'CM_TrtmntFnc651'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '65199', 'ImperialCerner', 'CM_TrtmntFnc651'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '65299', 'ImperialCerner', 'CM_TrtmntFnc652'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '65399', 'ImperialCerner', 'CM_TrtmntFnc653'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '65401', 'ImperialCerner', 'CM_TrtmntFnc654'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '65402', 'ImperialCerner', 'CM_TrtmntFnc654'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '65403', 'ImperialCerner', 'CM_TrtmntFnc654'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '65499', 'ImperialCerner', 'CM_TrtmntFnc654'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '65599', 'ImperialCerner', 'CM_TrtmntFnc655'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '65699', 'ImperialCerner', 'CM_TrtmntFnc656'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '80001', 'ImperialCerner', 'CM_TrtmntFnc800'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '80002', 'ImperialCerner', 'CM_TrtmntFnc800'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '80003', 'ImperialCerner', 'CM_TrtmntFnc800'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '80004', 'ImperialCerner', 'CM_TrtmntFnc800'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '80005', 'ImperialCerner', 'CM_TrtmntFnc800'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '80019', 'ImperialCerner', 'CM_TrtmntFnc800'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '80022', 'ImperialCerner', 'CM_TrtmntFnc800'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '80024', 'ImperialCerner', 'CM_TrtmntFnc800'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '80099', 'ImperialCerner', 'CM_TrtmntFnc800'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '81199', 'ImperialCerner', 'CM_TrtmntFnc811'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '147L', 'ImperialCerner', 'CM_TrtmntFnc147'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '820L', 'ImperialCerner', 'CM_TrtmntFnc820'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '823L', 'ImperialCerner', 'CM_TrtmntFnc823'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '824L', 'ImperialCerner', 'CM_TrtmntFnc824'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '831L', 'ImperialCerner', 'CM_TrtmntFnc831'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '900L', 'ImperialCerner', 'CM_TrtmntFnc900'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '901L', 'ImperialCerner', 'CM_TrtmntFnc901'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '903L', 'ImperialCerner', 'CM_TrtmntFnc903'),
('/IMPRL/CRNR/TRTMNT_FNCTN', '950L', 'ImperialCerner', 'CM_TrtmntFnc950');
/*
Psychology
ECG
ECG Virtual Clinic
Immunopathology
Oral & Maxillo Facial surgery
 */

-- ******************** Admission Source ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Imperial', 'CM_Sys_Cerner', null, null, 'admission_source_code', '/CDS/INPTNT/ADMSSN_SRC');

-- ******************** Admission Method ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Imperial', 'CM_Sys_Cerner', null, null, 'admission_method_code', '/CDS/INPTNT/ADMSSN_MTHD');

-- ******************** Discharge Method ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Imperial', 'CM_Sys_Cerner', null, null, 'discharge_method', '/IMPRL/CRNR/DSCHRG_MTHD');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/IMPRL/CRNR/DSCHRG_MTHD', 'DM_hasDischargeMethod');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/IMPRL/CRNR/DSCHRG_MTHD', '1', 'ImperialCerner', 'CM_DisMethod1'),
('/IMPRL/CRNR/DSCHRG_MTHD', '2', 'ImperialCerner', 'CM_DisMethod2'),
('/IMPRL/CRNR/DSCHRG_MTHD', '3', 'ImperialCerner', 'CM_DisMethod3'),
('/IMPRL/CRNR/DSCHRG_MTHD', '4', 'ImperialCerner', 'CM_DisMethod4'),
('/IMPRL/CRNR/DSCHRG_MTHD', '5', 'ImperialCerner', 'CM_DisMethod5'),
('/IMPRL/CRNR/DSCHRG_MTHD', '6', 'ImperialCerner', 'CM_DisMethod4'),
('/IMPRL/CRNR/DSCHRG_MTHD', '7', 'ImperialCerner', 'CM_DisMethod1'),
('/IMPRL/CRNR/DSCHRG_MTHD', '10', 'ImperialCerner', 'CM_DisMethod4'),
('/IMPRL/CRNR/DSCHRG_MTHD', '11', 'ImperialCerner', 'CM_DisMethod6'),
('/IMPRL/CRNR/DSCHRG_MTHD', '12', 'ImperialCerner', 'CM_DisMethod6'),
('/IMPRL/CRNR/DSCHRG_MTHD', '13', 'ImperialCerner', 'CM_DisMethod6'),
('/IMPRL/CRNR/DSCHRG_MTHD', '14', 'ImperialCerner', 'CM_DisMethod4'),
('/IMPRL/CRNR/DSCHRG_MTHD', 'Treatment Complete', 'ImperialCerner', 'CM_DisMethod1');

-- ******************** Discharge Destination ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Imperial', 'CM_Sys_Cerner', null, null, 'discharge_destination_code', '/IMPRL/CRNR/DSCHRG_DSTNTN');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/IMPRL/CRNR/DSCHRG_DSTNTN', 'DM_hasDischargeDestination');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/IMPRL/CRNR/DSCHRG_DSTNTN', '1', 'ImperialCerner', 'CM_SrcAdmUsual'),
-- ('/IMPRL/CRNR/DSCHRG_DSTNTN', '1', 'ImperialCerner', 'CM_DisDest79'),
-- ('/IMPRL/CRNR/DSCHRG_DSTNTN', '1', 'ImperialCerner', 'CM_SrcAdmA2'),
-- ('/IMPRL/CRNR/DSCHRG_DSTNTN', '1', 'ImperialCerner', 'CM_DisDest51'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '7', 'ImperialCerner', 'CM_DisDest51'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '19', 'ImperialCerner', 'CM_SrcAdmUsual'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '29', 'ImperialCerner', 'CM_SrcAdmTempR'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '30', 'ImperialCerner', 'CM_DisDest30'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '37', 'ImperialCerner', 'CM_SrcAdmCo'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '38', 'ImperialCerner', 'CM_DisDest38'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '38', 'ImperialCerner', 'CM_DisDest38'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '48', 'ImperialCerner', 'CM_DisDest48'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '49', 'ImperialCerner', 'CM_DisDest49'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '50', 'ImperialCerner', 'CM_DisDest50'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '51', 'ImperialCerner', 'CM_DisDest51'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '51', 'ImperialCerner', 'CM_DisDest51'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '51', 'ImperialCerner', 'CM_DisDest51'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '52', 'ImperialCerner', 'CM_SrcAdmA2'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '53', 'ImperialCerner', 'CM_SrcAdmA3'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '54', 'ImperialCerner', 'CM_SrcAdmA4'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '65', 'ImperialCerner', 'CM_SrcAdmA5'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '65', 'ImperialCerner', 'CM_SrcAdmA5'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '66', 'ImperialCerner', 'CM_SrcAdmA6'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '79', 'ImperialCerner', 'CM_DisDest79'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '84', 'ImperialCerner', 'CM_DisDest84'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '85', 'ImperialCerner', 'CM_SrcAdmA8'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '87', 'ImperialCerner', 'CM_SrcAdmA9'),
('/IMPRL/CRNR/DSCHRG_DSTNTN', '88', 'ImperialCerner', 'CM_SrcAsmA10');

-- ******************** Ethnicity ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Imperial', 'CM_Sys_Cerner', null, null, 'ethnicity', '/CDS/PTNT/ETHNC_CTGRY');
