-- ****************************************************
-- ** REQUIRES
-- ****************************************************

-- Get scheme id
SELECT @scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';

-- Code scheme prefix entries
INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
-- GENERAL/GLOBAL --
(1, 'CM_Org_Kings', @scm, 'CM_Org_Kings', 'Kings College', 'Kings College Hospital, London'),
(1, 'CM_Sys_PIMS', @scm, 'CM_Sys_PIMS', 'PIMS', 'PIMS system'),
(1, 'KingsPIMS', @scm, 'KingsPIMS', 'Kings Local Codes', 'Kings PIMS local code scheme');

INSERT IGNORE INTO concept_property_data
(`dbid`, `group`, `property`, `value`)
SELECT c.dbid, 0 AS `group`, p.dbid AS `property`, 'KC_' AS `value`
FROM concept c
         JOIN concept p ON p.id = 'code_prefix'
WHERE c.id = 'KingsPIMS';

-- ******************** Gender ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Kings', 'CM_Sys_PIMS', null, null, 'gender', '/KINGS/PIMS/GNDR');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/KINGS/PIMS/GNDR', 'DM_gender');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/KINGS/PIMS/GNDR', 'F', 'KingsPIMS', 'FHIR_AG_female'),
('/KINGS/PIMS/GNDR', 'M', 'KingsPIMS', 'FHIR_AG_male'),
('/KINGS/PIMS/GNDR', 'U', 'KingsPIMS', 'FHIR_AG_unknown'),
('/KINGS/PIMS/GNDR', 'I', 'KingsPIMS', 'FHIR_AG_other');

-- ******************** Religion ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Kings', 'CM_Sys_PIMS', null, null, 'religion', '/KINGS/PIMS/RLGN');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/KINGS/PIMS/RLGN', 'DM_religion');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
    ('/KINGS/PIMS/RLGN', 'A1',  'KingsPIMS', 'CM_ReligionA1'),
    ('/KINGS/PIMS/RLGN', 'B1',  'KingsPIMS', 'CM_ReligionB1'),
    ('/KINGS/PIMS/RLGN', 'C1',  'KingsPIMS', 'CM_ReligionC1'),
    ('/KINGS/PIMS/RLGN', 'C12', 'KingsPIMS', 'CM_ReligionC12'),
    ('/KINGS/PIMS/RLGN', 'C16', 'KingsPIMS', 'CM_ReligionC16'),
    ('/KINGS/PIMS/RLGN', 'C19', 'KingsPIMS', 'CM_ReligionC19'),
    ('/KINGS/PIMS/RLGN', 'C21', 'KingsPIMS', 'CM_ReligionC21'),
    ('/KINGS/PIMS/RLGN', 'C22', 'KingsPIMS', 'CM_ReligionC22'),
    ('/KINGS/PIMS/RLGN', 'C23', 'KingsPIMS', 'CM_ReligionC23'),
    ('/KINGS/PIMS/RLGN', 'C24', 'KingsPIMS', 'CM_ReligionC24'),
    ('/KINGS/PIMS/RLGN', 'C25', 'KingsPIMS', 'CM_ReligionC25'),
    ('/KINGS/PIMS/RLGN', 'C26', 'KingsPIMS', 'CM_ReligionC26'),
    ('/KINGS/PIMS/RLGN', 'C34', 'KingsPIMS', 'CM_ReligionC34'),
    ('/KINGS/PIMS/RLGN', 'C4',  'KingsPIMS', 'CM_ReligionC4'),
    ('/KINGS/PIMS/RLGN', 'C41', 'KingsPIMS', 'CM_ReligionC41'),
    ('/KINGS/PIMS/RLGN', 'C44', 'KingsPIMS', 'CM_ReligionC44'),
    ('/KINGS/PIMS/RLGN', 'C46', 'KingsPIMS', 'CM_ReligionC46'),
    ('/KINGS/PIMS/RLGN', 'C49', 'KingsPIMS', 'CM_ReligionC49'),
    ('/KINGS/PIMS/RLGN', 'C51', 'KingsPIMS', 'CM_ReligionC51'),
    ('/KINGS/PIMS/RLGN', 'C54', 'KingsPIMS', 'CM_ReligionC54'),
    ('/KINGS/PIMS/RLGN', 'C58', 'KingsPIMS', 'CM_ReligionC58'),
    ('/KINGS/PIMS/RLGN', 'C59', 'KingsPIMS', 'CM_ReligionC59'),
    ('/KINGS/PIMS/RLGN', 'C6',  'KingsPIMS', 'CM_ReligionC6'),
    ('/KINGS/PIMS/RLGN', 'C61', 'KingsPIMS', 'CM_ReligionC61'),
    ('/KINGS/PIMS/RLGN', 'C62', 'KingsPIMS', 'CM_ReligionC62'),
    ('/KINGS/PIMS/RLGN', 'C63', 'KingsPIMS', 'CM_ReligionC63'),
    ('/KINGS/PIMS/RLGN', 'C67', 'KingsPIMS', 'CM_ReligionC67'),
    ('/KINGS/PIMS/RLGN', 'C70', 'KingsPIMS', 'CM_ReligionC70'),
    ('/KINGS/PIMS/RLGN', 'C73', 'KingsPIMS', 'CM_ReligionC73'),
    ('/KINGS/PIMS/RLGN', 'C78', 'KingsPIMS', 'CM_ReligionC78'),
    ('/KINGS/PIMS/RLGN', 'C79', 'KingsPIMS', 'CM_ReligionC79'),
    ('/KINGS/PIMS/RLGN', 'C8',  'KingsPIMS', 'CM_ReligionC8'),
    ('/KINGS/PIMS/RLGN', 'D1',  'KingsPIMS', 'CM_ReligionD1'),
    ('/KINGS/PIMS/RLGN', 'F1',  'KingsPIMS', 'CM_ReligionF1'),
    ('/KINGS/PIMS/RLGN', 'F5',  'KingsPIMS', 'CM_ReligionF5'),
    ('/KINGS/PIMS/RLGN', 'F7',  'KingsPIMS', 'CM_ReligionF7'),
    ('/KINGS/PIMS/RLGN', 'F8',  'KingsPIMS', 'CM_ReligionF8'),
    ('/KINGS/PIMS/RLGN', 'G1',  'KingsPIMS', 'CM_ReligionG1'),
    ('/KINGS/PIMS/RLGN', 'H1',  'KingsPIMS', 'CM_ReligionH1'),
    ('/KINGS/PIMS/RLGN', 'I1',  'KingsPIMS', 'CM_ReligionI1'),
    ('/KINGS/PIMS/RLGN', 'K27', 'KingsPIMS', 'CM_ReligionK27'),
    ('/KINGS/PIMS/RLGN', 'L1',  'KingsPIMS', 'CM_ReligionL1'),
    ('/KINGS/PIMS/RLGN', 'L2',  'KingsPIMS', 'CM_ReligionL2'),
    ('/KINGS/PIMS/RLGN', 'M1',  'KingsPIMS', 'CM_ReligionM1'),
    ('/KINGS/PIMS/RLGN', 'N1',  'KingsPIMS', 'CM_ReligionN1');


-- ******************** Patient Class ********************

-- CONFLICT WITH ENCOUNTER CLASS/PATIENT CLASSIFICATION????

-- Concepts
/*SELECT @scm := dbid FROM concept WHERE id = 'KingsPIMS';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
    (1, 'KC_Enc_Inpatient', @scm,  'KC_Enc_Inpatient',  'Inpatient', 'Inpatient'),
    (1, 'KC_Enc_Emergency', @scm,  'KC_Enc_Emergency',  'Emergency department', 'Emergency department'),
    (1, 'KC_Enc_Outpatient', @scm, 'KC_Enc_Outpatient', 'Outpatient', 'Outpatient');

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Kings', 'CM_Sys_PIMS', null, null, 'patient_class', '/KINGS/PIMS/PTNT_CLSS');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/KINGS/PIMS/PTNT_CLSS', 'DM_admissionPatientClassification');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
    ('/KINGS/PIMS/PTNT_CLSS', 'I', 'KingsPIMS', 'KC_Enc_Inpatient'),
    ('/KINGS/PIMS/PTNT_CLSS', 'E', 'KingsPIMS', 'KC_Enc_Emergency'),
    ('/KINGS/PIMS/PTNT_CLSS', 'O', 'KingsPIMS', 'KC_Enc_Outpatient');*/

-- ******************** Admission Type (Method) ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Kings', 'CM_Sys_PIMS', null, null, 'admission_method_code', '/KINGS/PIMS/ADMSSN_MTHD');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/KINGS/PIMS/ADMSSN_MTHD', 'DM_methodOfAdmssion');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
    ('/KINGS/PIMS/ADMSSN_MTHD', '11', 'KingsPIMS', 'CM_AdmMethWa'),
    ('/KINGS/PIMS/ADMSSN_MTHD', '12', 'KingsPIMS', 'CM_AdmMetBooked'),
    ('/KINGS/PIMS/ADMSSN_MTHD', '13', 'KingsPIMS', 'CM_AdmMetPlanned'),
    ('/KINGS/PIMS/ADMSSN_MTHD', '21', 'KingsPIMS', 'CM_AdmMetCasSame'),
    ('/KINGS/PIMS/ADMSSN_MTHD', '22', 'KingsPIMS', 'CM_AdmMetGpDirect'),
    ('/KINGS/PIMS/ADMSSN_MTHD', '23', 'KingsPIMS', 'CM_AdmMetBedBureau'),
    ('/KINGS/PIMS/ADMSSN_MTHD', '24', 'KingsPIMS', 'CM_AdmMetConClin'),
    ('/KINGS/PIMS/ADMSSN_MTHD', '25', 'KingsPIMS', 'CM_AdmMetMheCrisis'),
    ('/KINGS/PIMS/ADMSSN_MTHD', '28', 'KingsPIMS', 'CM_AdmMetEMore'),           -- 2D replaces 28 in "Method of admission" - Hardik to confirm
    ('/KINGS/PIMS/ADMSSN_MTHD', '2A', 'KingsPIMS', 'CM_AdmMetCasElsewhere'),
    ('/KINGS/PIMS/ADMSSN_MTHD', '2B', 'KingsPIMS', 'CM_AdmMetHosTran'),
    ('/KINGS/PIMS/ADMSSN_MTHD', '2C', 'KingsPIMS', 'CM_AdmMetBBhok'),
    ('/KINGS/PIMS/ADMSSN_MTHD', '2D', 'KingsPIMS', 'CM_AdmMetEMore'),
    ('/KINGS/PIMS/ADMSSN_MTHD', '31', 'KingsPIMS', 'CM_AdmMetMatAP'),
    ('/KINGS/PIMS/ADMSSN_MTHD', '32', 'KingsPIMS', 'CM_AdmMetMatPP'),
    ('/KINGS/PIMS/ADMSSN_MTHD', '81', 'KingsPIMS', 'CM_AdmNonETransfer'),
    ('/KINGS/PIMS/ADMSSN_MTHD', '82', 'KingsPIMS', 'CM_AdmMetBirthHere'),
    ('/KINGS/PIMS/ADMSSN_MTHD', '83', 'KingsPIMS', 'CM_AdmMetBirthOut');

-- ******************** Ethnicity ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Kings', 'CM_Sys_PIMS', null, null, 'ethnicity', '/KINGS/PIMS/ETHNC_CTGRY');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/KINGS/PIMS/ETHNC_CTGRY', 'DM_ethnicity');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
    ('/KINGS/PIMS/ETHNC_CTGRY', 'A', 'KingsPIMS', 'CM_EthnicityA'),
    ('/KINGS/PIMS/ETHNC_CTGRY', 'B', 'KingsPIMS', 'CM_EthnicityB'),
    ('/KINGS/PIMS/ETHNC_CTGRY', 'C', 'KingsPIMS', 'CM_EthnicityC'),
    ('/KINGS/PIMS/ETHNC_CTGRY', 'D', 'KingsPIMS', 'CM_EthnicityD'),
    ('/KINGS/PIMS/ETHNC_CTGRY', 'E', 'KingsPIMS', 'CM_EthnicityE'),
    ('/KINGS/PIMS/ETHNC_CTGRY', 'F', 'KingsPIMS', 'CM_EthnicityF'),
    ('/KINGS/PIMS/ETHNC_CTGRY', 'G', 'KingsPIMS', 'CM_EthnicityG'),
    ('/KINGS/PIMS/ETHNC_CTGRY', 'H', 'KingsPIMS', 'CM_EthnicityH'),
    ('/KINGS/PIMS/ETHNC_CTGRY', 'J', 'KingsPIMS', 'CM_EthnicityJ'),
    ('/KINGS/PIMS/ETHNC_CTGRY', 'K', 'KingsPIMS', 'CM_EthnicityK'),
    ('/KINGS/PIMS/ETHNC_CTGRY', 'L', 'KingsPIMS', 'CM_EthnicityL'),
    ('/KINGS/PIMS/ETHNC_CTGRY', 'M', 'KingsPIMS', 'CM_EthnicityM'),
    ('/KINGS/PIMS/ETHNC_CTGRY', 'N', 'KingsPIMS', 'CM_EthnicityN'),
    ('/KINGS/PIMS/ETHNC_CTGRY', 'P', 'KingsPIMS', 'CM_EthnicityP'),
    ('/KINGS/PIMS/ETHNC_CTGRY', 'R', 'KingsPIMS', 'CM_EthnicityR'),
    ('/KINGS/PIMS/ETHNC_CTGRY', 'S', 'KingsPIMS', 'CM_EthnicityS'),
    ('/KINGS/PIMS/ETHNC_CTGRY', 'Z', 'KingsPIMS', 'CM_EthnicityZ'),
    ('/KINGS/PIMS/ETHNC_CTGRY', '99', 'KingsPIMS', 'CM_Ethnicity99');

-- ******************** Admission Source ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Kings', 'CM_Sys_PIMS', null, null, 'admission_source_code', '/KINGS/PIMS/ADMSSN_SRC');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/KINGS/PIMS/ADMSSN_SRC', 'DM_sourceOfAdmission');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
    ('/KINGS/PIMS/ADMSSN_SRC', '19', 'KingsPIMS', 'CM_SrcAdmUsual'),
    ('/KINGS/PIMS/ADMSSN_SRC', '29', 'KingsPIMS', 'CM_SrcAdmTempR'),
    ('/KINGS/PIMS/ADMSSN_SRC', '39', 'KingsPIMS', 'CM_SrcAdmPePoCo'),
    ('/KINGS/PIMS/ADMSSN_SRC', '49', 'KingsPIMS', 'CM_SrcAdmPSyHosp'),
    ('/KINGS/PIMS/ADMSSN_SRC', '51', 'KingsPIMS', 'CM_SrcAdmA1'),
    ('/KINGS/PIMS/ADMSSN_SRC', '52', 'KingsPIMS', 'CM_SrcAdmA2'),
    ('/KINGS/PIMS/ADMSSN_SRC', '53', 'KingsPIMS', 'CM_SrcAdmA3'),
    ('/KINGS/PIMS/ADMSSN_SRC', '54', 'KingsPIMS', 'CM_SrcAdmA4'),
    ('/KINGS/PIMS/ADMSSN_SRC', '65', 'KingsPIMS', 'CM_SrcAdmA5'),
    ('/KINGS/PIMS/ADMSSN_SRC', '66', 'KingsPIMS', 'CM_SrcAdmA6'),
    ('/KINGS/PIMS/ADMSSN_SRC', '79', 'KingsPIMS', 'CM_SrcAdmA7'),
    ('/KINGS/PIMS/ADMSSN_SRC', '85', 'KingsPIMS', 'CM_SrcAdmA8'),
    -- ('/KINGS/PIMS/ADMSSN_SRC', '86', 'KingsPIMS', 'CM_SrcAdmA8'),    -- NO 86 National Code - Should be 85 (above)?
    ('/KINGS/PIMS/ADMSSN_SRC', '85', 'KingsPIMS', 'CM_SrcAdmA9'),
    ('/KINGS/PIMS/ADMSSN_SRC', '88', 'KingsPIMS', 'CM_SrcAsmA10');


-- ******************** Encounter Class ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Kings', 'CM_Sys_PIMS', null, null, 'patient_class', '/KINGS/PIMS/ENCNTR_TYP');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/KINGS/PIMS/ENCNTR_TYP', 'DM_admissionPatientClassification');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
    ('/KINGS/PIMS/ENCNTR_TYP', '1', 'KingsPIMS', 'CM_AdmClassOrdinary'),
    ('/KINGS/PIMS/ENCNTR_TYP', '2', 'KingsPIMS', 'CM_AdmClassDayCase'),
    ('/KINGS/PIMS/ENCNTR_TYP', '3', 'KingsPIMS', 'CM_AdmClassRegularDay'),
    ('/KINGS/PIMS/ENCNTR_TYP', '4', 'KingsPIMS', 'CM_AdmClassRegularNight'),
    ('/KINGS/PIMS/ENCNTR_TYP', '5/99', 'KingsPIMS', 'CM_AdmClassMotherBabyDelivery/?????????????????'); -- Whats this?

-- ******************** Discharge Disposition ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Kings', 'CM_Sys_PIMS', null, null, 'discharge_method', '/KINGS/PIMS/DSCHRG_MTHD');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/KINGS/PIMS/DSCHRG_MTHD', 'DM_hasDischargeMethod');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
    ('/KINGS/PIMS/DSCHRG_MTHD', '1', 'KingsPIMS', 'CM_DisMethod1'),
    ('/KINGS/PIMS/DSCHRG_MTHD', '2', 'KingsPIMS', 'CM_DisMethod2'),
    ('/KINGS/PIMS/DSCHRG_MTHD', '3', 'KingsPIMS', 'CM_DisMethod3'),
    ('/KINGS/PIMS/DSCHRG_MTHD', '4', 'KingsPIMS', 'CM_DisMethod4'),
    ('/KINGS/PIMS/DSCHRG_MTHD', '5', 'KingsPIMS', 'CM_DisMethod5'),
    ('/KINGS/PIMS/DSCHRG_MTHD', '99', 'KingsPIMS', '??????????????????');   -- No national 99?


-- ******************** Discharge Destination ********************

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Kings', 'CM_Sys_PIMS', null, null, 'discharge_destination_code', '/KINGS/PIMS/DSCHRG_DSTNTN');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/KINGS/PIMS/DSCHRG_DSTNTN', 'DM_hasDischargeDestination');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
    ('/KINGS/PIMS/DSCHRG_DSTNTN', '19', 'KingsPIMS', 'CM_SrcAdmUsual'),
    ('/KINGS/PIMS/DSCHRG_DSTNTN', '29', 'KingsPIMS', 'CM_SrcAdmTempR'),
    ('/KINGS/PIMS/DSCHRG_DSTNTN', '30', 'KingsPIMS', 'CM_DisDest30'),
    ('/KINGS/PIMS/DSCHRG_DSTNTN', '37', 'KingsPIMS', 'CM_SrcAdmCo'),
    ('/KINGS/PIMS/DSCHRG_DSTNTN', '38', 'KingsPIMS', 'CM_DisDest38'),
    ('/KINGS/PIMS/DSCHRG_DSTNTN', '48', 'KingsPIMS', 'CM_DisDest48'),
    ('/KINGS/PIMS/DSCHRG_DSTNTN', '49', 'KingsPIMS', 'CM_DisDest49'),
    ('/KINGS/PIMS/DSCHRG_DSTNTN', '50', 'KingsPIMS', 'CM_DisDest50'),
    ('/KINGS/PIMS/DSCHRG_DSTNTN', '51', 'KingsPIMS', 'CM_DisDest51'),
    ('/KINGS/PIMS/DSCHRG_DSTNTN', '52', 'KingsPIMS', 'CM_SrcAdmA2'),
    ('/KINGS/PIMS/DSCHRG_DSTNTN', '53', 'KingsPIMS', 'CM_SrcAdmA3'),
    ('/KINGS/PIMS/DSCHRG_DSTNTN', '54', 'KingsPIMS', 'CM_SrcAdmA4'),
    ('/KINGS/PIMS/DSCHRG_DSTNTN', '65', 'KingsPIMS', 'CM_SrcAdmA5'),
    ('/KINGS/PIMS/DSCHRG_DSTNTN', '66', 'KingsPIMS', 'CM_SrcAdmA6'),
    ('/KINGS/PIMS/DSCHRG_DSTNTN', '79', 'KingsPIMS', 'CM_DisDest79'),
    ('/KINGS/PIMS/DSCHRG_DSTNTN', '84', 'KingsPIMS', 'CM_DisDest84'),
    ('/KINGS/PIMS/DSCHRG_DSTNTN', '85', 'KingsPIMS', 'CM_SrcAdmA8'),
    ('/KINGS/PIMS/DSCHRG_DSTNTN', '87', 'KingsPIMS', 'CM_SrcAdmA9'),
    ('/KINGS/PIMS/DSCHRG_DSTNTN', '88', 'KingsPIMS', 'CM_SrcAsmA10');
