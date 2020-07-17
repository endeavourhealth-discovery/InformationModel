-- Meta tables for clarity/simplicity
DROP TABLE IF EXISTS map_context_meta;
CREATE TABLE map_context_meta (
    provider    VARCHAR(150),
    `system`    VARCHAR(150),
    `schema`    VARCHAR(40),
    `table`     VARCHAR(40),
    `column`    VARCHAR(40),
    node        VARCHAR(200)
) ENGINE = Memory
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS map_node_meta;
CREATE TABLE map_node_meta(
    node    VARCHAR(200),
    concept VARCHAR(150)
) ENGINE = Memory
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS map_node_value_meta;
CREATE TEMPORARY TABLE map_node_value_meta (
    node    VARCHAR(200),
    value   VARCHAR(250),
    scheme  VARCHAR(150),
    concept VARCHAR(150)
) ENGINE = Memory
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS map_function_value_meta;
CREATE TEMPORARY TABLE map_function_value_meta (
    node    VARCHAR(200),
    scheme  VARCHAR(150),
    function  VARCHAR(200)
) ENGINE = Memory
  DEFAULT CHARSET = utf8;


-- ******************** EMERGENCY ********************

-- Context maps
INSERT INTO map_context_meta
(provider, `system`, `schema`, `table`, `column`, node)
VALUES
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'department_type',          '/CDS/EMGCY/DPT_TYP'),                  -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'arrival_mode',             '/CDS/EMGCY/ARRVL_MD'),                 -- SNOMED
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'attendance_category',      '/CDS/EMGCY/ATTNDNC_CTGRY'),            -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'attendance_source',        '/CDS/EMGCY/ATTNDNC_SRC'),              -- SNOMED
-- ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'chief_complaint',          '/CDS/EMGCY/CHF_CMPLNT'),               -- SNOMED               -- TODO: Chief complaint A&E Property
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'treatment_function_code',  '/BRTS/CRNR/CDS/EMGCY/TRTMNT_FNCTN'),   -- BARTS/CERNER code
-- ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'discharge_status',         '/CDS/EMGCY/DSCHRG_STTS'),              -- SNOMED               -- TODO: Discharge status
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'discharge_destination',    '/CDS/EMGCY/DSCHRG_DSTNTN')            -- SNOMED
-- ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'discharge_follow_up',      '/CDS/EMGCY/DSCHRG_FLLW_UP'),           -- SNOMED         -- TODO: Discharge follow-up
-- ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'diagnosis',                '/CDS/EMGCY/DGNSS'),                    -- SNOMED               -- TODO: diagnosis
-- ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'investigation',            '/CDS/EMGCY/INVSTGTN'),                 -- SNOMED               -- TODO: investigation
-- ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'treatment',                '/CDS/EMGCY/TRTMNT'),                   -- SNOMED               -- TODO: treatment
-- ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'referred_to_services',     '/CDS/EMGCY/RFRRD_SRVCS'),              -- SNOMED               -- TODO: referred_to_services
-- ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'safe_guarding_concerns',   '/CDS/EMGCY/SFGRDNG_CNCRNS')            -- SNOMED               -- TODO: safe_guarding_concerns

/* convergent mapping examples

('CM_Org_Homerton', 'CM_Sys_Cerner', 'CDS', 'emergency', 'department_type',          '/CDS/EMGCY/DPT_TYP'),                  -- HOMERTON LOOKUP MAPS TO SAME CONTEXT AS BARTS (COMMON NHS DD CODES)
('CM_Org_Homerton', 'CM_Sys_Cerner', 'CDS', 'emergency', 'treatment_function_code',  '/HMTN/CRNR/CDS/EMGCY/TRTMNT_FNCTN'),   -- HOMERTON LOOKUP MAPS TO DIFFERENT CONTEXT (LOCAL/SPECIFIC CERNER CODES)

*/
;

-- Node maps
INSERT INTO map_node_meta
(node, concept)
VALUES
('/CDS/EMGCY/DPT_TYP',                   'DM_aAndEDepartmentType'),     -- NHS DD
('/CDS/EMGCY/ARRVL_MD',                  'DM_arrivalMode'),             -- SNOMED
('/CDS/EMGCY/ATTNDNC_CTGRY',             'DM_aeAttendanceCategory'),    -- NHS DD
('/CDS/EMGCY/ATTNDNC_SRC',               'DM_aeAttendanceSource'),      -- SNOMED
-- ('/CDS/EMGCY/CHF_CMPLNT',                ''),                           -- SNOMED               -- TODO: Chief complaint A&E Property - YES
('/BRTS/CRNR/CDS/EMGCY/TRTMNT_FNCTN',    'DM_treatmentFunctionAdmit'),  -- BARTS/CERNER code
-- ('/CDS/EMGCY/DSCHRG_STTS',               ''),                           -- SNOMED               -- TODO: Discharge status
('/CDS/EMGCY/DSCHRG_DSTNTN',             'DM_hasDischargeDestination') -- SNOMED
-- ('/CDS/EMGCY/DSCHRG_FLLW_UP',            ''),                           -- SNOMED               -- TODO: Discharge follow up property
-- ('/CDS/EMGCY/DGNSS',                     ''),                           -- SNOMED               -- TODO: diagnosis
-- ('/CDS/EMGCY/INVSTGTN',                  ''),                           -- SNOMED               -- TODO: investigation
-- ('/CDS/EMGCY/TRTMNT',                    ''),                           -- SNOMED               -- TODO: treatment
-- ('/CDS/EMGCY/RFRRD_SRVCS',               ''),                           -- SNOMED               -- TODO: referred_to_services
-- ('/CDS/EMGCY/SFGRDNG_CNCRNS',            '')                            -- SNOMED               -- TODO: safe_guarding_concerns
;

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/CDS/EMGCY/DPT_TYP', '01', 'CM_NHS_DD', 'CM_AEDepType1'),
('/CDS/EMGCY/DPT_TYP', '02', 'CM_NHS_DD', 'CM_AEDepType2'),
('/CDS/EMGCY/DPT_TYP', '03', 'CM_NHS_DD', 'CM_AEDepType3'),
('/CDS/EMGCY/DPT_TYP', '04', 'CM_NHS_DD', 'CM_AEDepType4'),

('/CDS/EMGCY/ATTNDNC_CTGRY', '1', 'CM_NHS_DD', 'CM_AEAttCat1'),
('/CDS/EMGCY/ATTNDNC_CTGRY', '2', 'CM_NHS_DD', 'CM_AEAttCat2'),
('/CDS/EMGCY/ATTNDNC_CTGRY', '3', 'CM_NHS_DD', 'CM_AEAttCat3');

INSERT INTO map_function_value_meta
(node, scheme, function)
VALUES
('/BRTS/CRNR/CDS/EMGCY/TRTMNT_FNCTN', 'BartsCerner', 'Format(BC_%s)')
;

-- ******************** INPATIENT ********************

-- Context maps
INSERT INTO map_context_meta
(provider, `system`, `schema`, `table`, `column`, node)
VALUES
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'admission_method_code',         '/CDS/INPTNT/ADMSSN_MTHD'),            -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'admission_source_code',         '/CDS/INPTNT/ADMSSN_SRC'),             -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'patient_classification',        '/CDS/INPTNT/PTNT_CLSSFCTN'),          -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'discharge_destination_code',    '/CDS/INPTNT/DSCHRG_DSTNTN'),          -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'discharge_method',              '/CDS/INPTNT/DSCHRG_MTHD'),            -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'administrative_category_code',  '/CDS/INPTNT/ADMNSTRV_CTGRY'),         -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'treatment_function_code',       '/BRTS/CRNR/CDS/INPTNT/TRTMNT_FNCTN') -- BARTS LOCAL
-- ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'live_or_still_birth_indicator', '/CDS/INPTNT/LV_STLL_BRTH_INDCTR'),    -- NHS DD       -- TODO: Confirm correct with Leigh
-- ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'delivery_method',               '/CDS/INPTNT/DLVRY_MTHD'),             -- NHS DD       -- TODO: Confirm correct with Leigh
-- ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'gender',                        '/CDS/INPTNT/GNDR')                    -- NHS DD       -- TODO: Confirm correct with Leigh
;

-- Node maps
INSERT INTO map_node_meta
(node, concept)
VALUES
('/CDS/INPTNT/ADMSSN_MTHD',              'DM_methodOfAdmssion'),                -- NHS DD
('/CDS/INPTNT/ADMSSN_SRC',               'DM_sourceOfAdmission'),               -- NHS DD
('/CDS/INPTNT/PTNT_CLSSFCTN',            'DM_admissionPatientClassification'),  -- NHS DD
('/CDS/INPTNT/DSCHRG_DSTNTN',            'DM_hasDischargeDestination'),         -- NHS DD
('/CDS/INPTNT/DSCHRG_MTHD',              'DM_hasDischargeMethod'),              -- NHS DD
('/CDS/INPTNT/ADMNSTRV_CTGRY',           'DM_adminCategoryonAdmission'),        -- NHS DD
('/BRTS/CRNR/CDS/INPTNT/TRTMNT_FNCTN',   'DM_treatmentFunctionAdmit')          -- BARTS LOCAL
-- ('/CDS/INPTNT/LV_STLL_BRTH_INDCTR',      ''),                                   -- NHS DD       -- TODO: Confirm correct with Leigh
-- ('/CDS/INPTNT/DLVRY_MTHD',               ''),                                   -- NHS DD       -- TODO: Confirm correct with Leigh
-- ('/CDS/INPTNT/GNDR',                     '')                                    -- NHS DD       -- TODO: Confirm correct with Leigh
;

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/CDS/INPTNT/ADMSSN_MTHD', '11', 'CM_NHS_DD', 'CM_AdmMethWa'),
('/CDS/INPTNT/ADMSSN_MTHD', '12', 'CM_NHS_DD', 'CM_AdmMetBooked'),
('/CDS/INPTNT/ADMSSN_MTHD', '13', 'CM_NHS_DD', 'CM_AdmMetPlanned'),
('/CDS/INPTNT/ADMSSN_MTHD', '21', 'CM_NHS_DD', 'CM_AdmMetCasSame'),
('/CDS/INPTNT/ADMSSN_MTHD', '22', 'CM_NHS_DD', 'CM_AdmMetGpDirect'),
('/CDS/INPTNT/ADMSSN_MTHD', '23', 'CM_NHS_DD', 'CM_AdmMetBedBureau'),
('/CDS/INPTNT/ADMSSN_MTHD', '24', 'CM_NHS_DD', 'CM_AdmMetConClin'),
('/CDS/INPTNT/ADMSSN_MTHD', '25', 'CM_NHS_DD', 'CM_AdmMetMheCrisis'),
('/CDS/INPTNT/ADMSSN_MTHD', '2A', 'CM_NHS_DD', 'CM_AdmMetCasElsewhere'),
('/CDS/INPTNT/ADMSSN_MTHD', '2B', 'CM_NHS_DD', 'CM_AdmMetHosTran'),
('/CDS/INPTNT/ADMSSN_MTHD', '2C', 'CM_NHS_DD', 'CM_AdmMetBBhok'),
('/CDS/INPTNT/ADMSSN_MTHD', '2D', 'CM_NHS_DD', 'CM_AdmMetEMore'),
('/CDS/INPTNT/ADMSSN_MTHD', '28', 'CM_NHS_DD', 'CM_AdmMetEMore'),
('/CDS/INPTNT/ADMSSN_MTHD', '31', 'CM_NHS_DD', 'CM_AdmMetMatAP'),
('/CDS/INPTNT/ADMSSN_MTHD', '32', 'CM_NHS_DD', 'CM_AdmMetMatPP'),
('/CDS/INPTNT/ADMSSN_MTHD', '82', 'CM_NHS_DD', 'CM_AdmMetBirthHere'),
('/CDS/INPTNT/ADMSSN_MTHD', '83', 'CM_NHS_DD', 'CM_AdmMetBirthOut'),
('/CDS/INPTNT/ADMSSN_MTHD', '81', 'CM_NHS_DD', 'CM_AdmNonETransfer'),

('/CDS/INPTNT/ADMSSN_SRC', '19', 'CM_NHS_DD', 'CM_SrcAdmUsual'),
('/CDS/INPTNT/ADMSSN_SRC', '29', 'CM_NHS_DD', 'CM_SrcAdmTempR'),
('/CDS/INPTNT/ADMSSN_SRC', '39', 'CM_NHS_DD', 'CM_SrcAdmPePoCo'),
('/CDS/INPTNT/ADMSSN_SRC', '40', 'CM_NHS_DD', 'CM_SrcAdmPe'),
('/CDS/INPTNT/ADMSSN_SRC', '41', 'CM_NHS_DD', 'CM_SrcAdmCo'),
('/CDS/INPTNT/ADMSSN_SRC', '42', 'CM_NHS_DD', 'CM_SrcAdmPo'),
('/CDS/INPTNT/ADMSSN_SRC', '49', 'CM_NHS_DD', 'CM_SrcAdmPSyHosp'),
('/CDS/INPTNT/ADMSSN_SRC', '51', 'CM_NHS_DD', 'CM_SrcAdmA1'),
('/CDS/INPTNT/ADMSSN_SRC', '52', 'CM_NHS_DD', 'CM_SrcAdmA2'),
('/CDS/INPTNT/ADMSSN_SRC', '53', 'CM_NHS_DD', 'CM_SrcAdmA3'),
('/CDS/INPTNT/ADMSSN_SRC', '54', 'CM_NHS_DD', 'CM_SrcAdmA4'),
('/CDS/INPTNT/ADMSSN_SRC', '65', 'CM_NHS_DD', 'CM_SrcAdmA5'),
('/CDS/INPTNT/ADMSSN_SRC', '66', 'CM_NHS_DD', 'CM_SrcAdmA6'),
('/CDS/INPTNT/ADMSSN_SRC', '79', 'CM_NHS_DD', 'CM_SrcAdmA7'),
('/CDS/INPTNT/ADMSSN_SRC', '85', 'CM_NHS_DD', 'CM_SrcAdmA8'),
('/CDS/INPTNT/ADMSSN_SRC', '87', 'CM_NHS_DD', 'CM_SrcAdmA9'),
('/CDS/INPTNT/ADMSSN_SRC', '88', 'CM_NHS_DD', 'CM_SrcAsmA10'),

('/CDS/INPTNT/PTNT_CLSSFCTN', '1', 'CM_NHS_DD', 'CM_AdmClassOrdinary'),
('/CDS/INPTNT/PTNT_CLSSFCTN', '2', 'CM_NHS_DD', 'CM_AdmClassDayCase'),
('/CDS/INPTNT/PTNT_CLSSFCTN', '3', 'CM_NHS_DD', 'CM_AdmClassRegularDay'),
('/CDS/INPTNT/PTNT_CLSSFCTN', '4', 'CM_NHS_DD', 'CM_AdmClassRegularNight'),
('/CDS/INPTNT/PTNT_CLSSFCTN', '5', 'CM_NHS_DD', 'CM_AdmClassMotherBabyDelivery'),

('/CDS/INPTNT/DSCHRG_DSTNTN', '19', 'CM_NHS_DD', 'CM_SrcAdmUsual'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '29', 'CM_NHS_DD', 'CM_SrcAdmTempR'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '30', 'CM_NHS_DD', 'CM_DisDest30'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '37', 'CM_NHS_DD', 'CM_SrcAdmCo'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '38', 'CM_NHS_DD', 'CM_DisDest38'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '48', 'CM_NHS_DD', 'CM_DisDest48'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '49', 'CM_NHS_DD', 'CM_DisDest49'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '50', 'CM_NHS_DD', 'CM_DisDest50'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '51', 'CM_NHS_DD', 'CM_DisDest51'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '52', 'CM_NHS_DD', 'CM_SrcAdmA2'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '53', 'CM_NHS_DD', 'CM_SrcAdmA3'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '54', 'CM_NHS_DD', 'CM_SrcAdmA4'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '65', 'CM_NHS_DD', 'CM_SrcAdmA5'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '66', 'CM_NHS_DD', 'CM_SrcAdmA6'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '79', 'CM_NHS_DD', 'CM_DisDest79'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '84', 'CM_NHS_DD', 'CM_DisDest84'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '85', 'CM_NHS_DD', 'CM_SrcAdmA8'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '87', 'CM_NHS_DD', 'CM_SrcAdmA9'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '88', 'CM_NHS_DD', 'CM_SrcAsmA10'),

('/CDS/INPTNT/DSCHRG_MTHD', '1', 'CM_NHS_DD', 'CM_DisMethod1'),
('/CDS/INPTNT/DSCHRG_MTHD', '2', 'CM_NHS_DD', 'CM_DisMethod2'),
('/CDS/INPTNT/DSCHRG_MTHD', '3', 'CM_NHS_DD', 'CM_DisMethod3'),
('/CDS/INPTNT/DSCHRG_MTHD', '4', 'CM_NHS_DD', 'CM_DisMethod4'),
('/CDS/INPTNT/DSCHRG_MTHD', '5', 'CM_NHS_DD', 'CM_DisMethod5'),
('/CDS/INPTNT/DSCHRG_MTHD', '6', 'CM_NHS_DD', 'CM_DisMethod6'),
('/CDS/INPTNT/DSCHRG_MTHD', '7', 'CM_NHS_DD', 'CM_DisMethod7'),

('/CDS/INPTNT/ADMNSTRV_CTGRY', '01', 'CM_NHS_DD', 'CM_AdminCat01'),
('/CDS/INPTNT/ADMNSTRV_CTGRY', '02', 'CM_NHS_DD', 'CM_AdminCat02'),
('/CDS/INPTNT/ADMNSTRV_CTGRY', '03', 'CM_NHS_DD', 'CM_AdminCat03'),
('/CDS/INPTNT/ADMNSTRV_CTGRY', '04', 'CM_NHS_DD', 'CM_AdminCat04');

INSERT INTO map_function_value_meta
(node, scheme, function)
VALUES
('/BRTS/CRNR/CDS/INPTNT/TRTMNT_FNCTN', 'BartsCerner', 'Format(BC_%s)')
;

/*
('/CDS/INPTNT/LV_STLL_BRTH_INDCTR', '1', 'CM_NHS_DD', ''),  -- TODO: Confirm correct with Leigh
('/CDS/INPTNT/LV_STLL_BRTH_INDCTR', '2', 'CM_NHS_DD', ''),
('/CDS/INPTNT/LV_STLL_BRTH_INDCTR', '3', 'CM_NHS_DD', ''),
('/CDS/INPTNT/LV_STLL_BRTH_INDCTR', '4', 'CM_NHS_DD', ''),
('/CDS/INPTNT/LV_STLL_BRTH_INDCTR', '5', 'CM_NHS_DD', ''),

('/CDS/INPTNT/DLVRY_MTHD', '0', 'CM_NHS_DD', ''),  -- TODO: Confirm correct with Leigh
('/CDS/INPTNT/DLVRY_MTHD', '1', 'CM_NHS_DD', ''),
('/CDS/INPTNT/DLVRY_MTHD', '2', 'CM_NHS_DD', ''),
('/CDS/INPTNT/DLVRY_MTHD', '3', 'CM_NHS_DD', ''),
('/CDS/INPTNT/DLVRY_MTHD', '4', 'CM_NHS_DD', ''),
('/CDS/INPTNT/DLVRY_MTHD', '5', 'CM_NHS_DD', ''),
('/CDS/INPTNT/DLVRY_MTHD', '6', 'CM_NHS_DD', ''),
('/CDS/INPTNT/DLVRY_MTHD', '7', 'CM_NHS_DD', ''),
('/CDS/INPTNT/DLVRY_MTHD', '8', 'CM_NHS_DD', ''),
('/CDS/INPTNT/DLVRY_MTHD', '9', 'CM_NHS_DD', ''),

('/CDS/INPTNT/GNDR', '0', 'CM_NHS_DD', ''),  -- TODO: Confirm correct with Leigh
('/CDS/INPTNT/GNDR', '1', 'CM_NHS_DD', ''),
('/CDS/INPTNT/GNDR', '2', 'CM_NHS_DD', ''),
('/CDS/INPTNT/GNDR', '9', 'CM_NHS_DD', '')
 */
;

-- ******************** OUTPATIENT ********************

-- Context maps
INSERT INTO map_context_meta
(provider, `system`, `schema`, `table`, `column`, node)
VALUES
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'outpatient', 'appt_attended_code',           '/CDS/OUTPTNT/APPT_ATTNDD'),           -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'outpatient', 'appt_outcome_code',            '/CDS/OUTPTNT/OUTCM'),                 -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'outpatient', 'administrative_category_code', '/CDS/OUTPTNT/ADMNSTRTV_CTGRY'),       -- NHS DD
-- ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'outpatient', 'referral_source',              '/CDS/OUTPTNT/RFRRL_SRC'),             -- NHS DD               -- TODO: outpatient referral source
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'outpatient', 'treatment_function_code',      '/BRTS/CRNR/CDS/OUTPTNT/TRMNT_FNCTN')  -- BARTS/CERNER code
;

-- Node maps
INSERT INTO map_node_meta
(node, concept)
VALUES
('/CDS/OUTPTNT/APPT_ATTNDD',             'DM_attendanceStatus'),                -- NHS DD
('/CDS/OUTPTNT/OUTCM',                   'DM_hasAttendanceOutcome'),            -- NHS DD
('/CDS/OUTPTNT/ADMNSTRTV_CTGRY',         'DM_adminCategoryonAdmission'),        -- NHS DD
-- ('/CDS/OUTPTNT/RFRRL_SRC',               ''),                                   -- NHS DD               -- TODO: outpatient referral source
('/BRTS/CRNR/CDS/OUTPTNT/TRMNT_FNCTN',   'DM_treatmentFunctionAdmit')           -- BARTS/CERNER code
;

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/CDS/OUTPTNT/APPT_ATTNDD', '5', 'CM_NHS_DD', 'CM_AttNotAtt5'),
('/CDS/OUTPTNT/APPT_ATTNDD', '6', 'CM_NHS_DD', 'CM_AttNotAtt6'),
('/CDS/OUTPTNT/APPT_ATTNDD', '7', 'CM_NHS_DD', 'CM_AttNotAtt7'),
('/CDS/OUTPTNT/APPT_ATTNDD', '2', 'CM_NHS_DD', 'CM_AttNotAtt2'),
('/CDS/OUTPTNT/APPT_ATTNDD', '3', 'CM_NHS_DD', 'CM_AttnotAtt3'),   -- TODO: Captial N?
('/CDS/OUTPTNT/APPT_ATTNDD', '4', 'CM_NHS_DD', 'CM_AttnotAtt4'),   -- TODO: Capital N?
('/CDS/OUTPTNT/APPT_ATTNDD', '0', 'CM_NHS_DD', 'CM_AttNotAtt00'),  -- TODO: Single 0?

('/CDS/OUTPTNT/OUTCM', '1', 'CM_NHS_DD', 'CM_AttOpd1'),
('/CDS/OUTPTNT/OUTCM', '2', 'CM_NHS_DD', 'CM_AttOpd2'),
('/CDS/OUTPTNT/OUTCM', '3', 'CM_NHS_DD', 'CM_AttOpd3'),

('/CDS/OUTPTNT/ADMNSTRTV_CTGRY', '01', 'CM_NHS_DD', 'CM_AdminCat01'),
('/CDS/OUTPTNT/ADMNSTRTV_CTGRY', '02', 'CM_NHS_DD', 'CM_AdminCat02'),
('/CDS/OUTPTNT/ADMNSTRTV_CTGRY', '03', 'CM_NHS_DD', 'CM_AdminCat03'),
('/CDS/OUTPTNT/ADMNSTRTV_CTGRY', '04', 'CM_NHS_DD', 'CM_AdminCat04')

/*
('/CDS/OUTPTNT/RFRRL_SRC', '01', 'CM_NHS_DD', 'CM_OutRefSrc01'),    -- TODO: outpatient referral source
('/CDS/OUTPTNT/RFRRL_SRC', '02', 'CM_NHS_DD', 'CM_OutRefSrc02'),
('/CDS/OUTPTNT/RFRRL_SRC', '10', 'CM_NHS_DD', 'CM_OutRefSrc10'),
('/CDS/OUTPTNT/RFRRL_SRC', '11', 'CM_NHS_DD', 'CM_OutRefSrc11'),
('/CDS/OUTPTNT/RFRRL_SRC', '03', 'CM_NHS_DD', 'CM_OutRefSrc03'),
('/CDS/OUTPTNT/RFRRL_SRC', '92', 'CM_NHS_DD', 'CM_OutRefSrc92'),
('/CDS/OUTPTNT/RFRRL_SRC', '12', 'CM_NHS_DD', 'CM_OutRefSrc12'),
('/CDS/OUTPTNT/RFRRL_SRC', '04', 'CM_NHS_DD', 'CM_OutRefSrc04'),
('/CDS/OUTPTNT/RFRRL_SRC', '05', 'CM_NHS_DD', 'CM_OutRefSrc05'),
('/CDS/OUTPTNT/RFRRL_SRC', '06', 'CM_NHS_DD', 'CM_OutRefSrc06'),
('/CDS/OUTPTNT/RFRRL_SRC', '07', 'CM_NHS_DD', 'CM_OutRefSrc07'),
('/CDS/OUTPTNT/RFRRL_SRC', '13', 'CM_NHS_DD', 'CM_OutRefSrc13'),
('/CDS/OUTPTNT/RFRRL_SRC', '14', 'CM_NHS_DD', 'CM_OutRefSrc14'),
('/CDS/OUTPTNT/RFRRL_SRC', '15', 'CM_NHS_DD', 'CM_OutRefSrc15'),
('/CDS/OUTPTNT/RFRRL_SRC', '16', 'CM_NHS_DD', 'CM_OutRefSrc16'),
('/CDS/OUTPTNT/RFRRL_SRC', '17', 'CM_NHS_DD', 'CM_OutRefSrc17'),
('/CDS/OUTPTNT/RFRRL_SRC', '93', 'CM_NHS_DD', 'CM_OutRefSrc93'),
('/CDS/OUTPTNT/RFRRL_SRC', '97', 'CM_NHS_DD', 'CM_OutRefSrc97')
*/
;

INSERT INTO map_function_value_meta
(node, scheme, function)
VALUES
('/BRTS/CRNR/CDS/OUTPTNT/TRTMNT_FNCTN', 'BartsCerner', 'Format(BC_%s)')
;

-- ******************** CRITICAL CARE ********************

-- Context maps
INSERT INTO map_context_meta
(provider, `system`, `schema`, `table`, `column`, node)
VALUES
-- ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'critical_care_type_id',          '/CDS/CRTCL/CRTCL_CR_TYP'),    -- NHS DD       -- TODO: critical care type
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'care_unit_function',             '/CDS/CRTCL/CR_UNT_FNCTN'),    -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'admission_source_code',          '/CDS/CRTCL/ADMSSN_SRC')      -- NHS DD
-- ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'admission_type_code',            '/CDS/CRTCL/ADMSSN_TYP'),      -- NHS DD       -- TODO: admission type
-- ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'admission_location',             '/CDS/CRTCL/ADMSSN_LCTN'),     -- NHS DD       -- TODO: admission location
-- ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'discharge_status_code',          '/CDS/CRTCL/DSCHRG_STTS'),     -- NHS DD       -- TODO: discharge status
-- ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'discharge_destination',          '/CDS/CRTCL/DSCHRG_DSTNTN'),   -- NHS DD       -- TODO: discharge destination
-- ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'discharge_location',             '/CDS/CRTCL/DSCHRG_LCTN'),     -- NHS DD       -- TODO: discharge location
-- ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'care_activity',                  '/CDS/CRTCL/CR_ACTVTY')        -- NHS DD       -- TODO: care activity
;

-- Node maps
INSERT INTO map_node_meta
(node, concept)
VALUES
-- ('/CDS/CRTCL/CRTCL_CR_TYP',              ''),                               -- NHS DD       -- TODO: critical care type
('/CDS/CRTCL/CR_UNT_FNCTN',              'DM_hasCriticalCareUnitFunction'), -- NHS DD
('/CDS/CRTCL/ADMSSN_SRC',                'DM_sourceOfAdmission')           -- NHS DD
-- ('/CDS/CRTCL/ADMSSN_TYP',                ''),                               -- NHS DD       -- TODO: admission type
-- ('/CDS/CRTCL/ADMSSN_LCTN',               ''),                               -- NHS DD       -- TODO: admission location
-- ('/CDS/CRTCL/DSCHRG_STTS',               ''),                               -- NHS DD       -- TODO: discharge status
-- ('/CDS/CRTCL/DSCHRG_DSTNTN',             ''),                               -- NHS DD       -- TODO: discharge destination
-- ('/CDS/CRTCL/DSCHRG_LCTN',               ''),                               -- NHS DD       -- TODO: discharge location
-- ('/CDS/CRTCL/CR_ACTVTY',                 '')                                -- NHS DD       -- TODO: care activity
;

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
/*
('/CDS/CRTCL/CRTCL_CR_TYP', '01', 'CM_NHS_DD', 'CM_NeonatalCriticalCareEncounter'),
('/CDS/CRTCL/CRTCL_CR_TYP', '02', 'CM_NHS_DD', 'CM_PaediatricCriticalCareEncounter'),
('/CDS/CRTCL/CRTCL_CR_TYP', '03', 'CM_NHS_DD', 'CM_AdultCriticalCareEncounter'),
*/

('/CDS/CRTCL/CR_UNT_FNCTN', '01', 'CM_NHS_DD', 'CM_CcufAdult1'),
('/CDS/CRTCL/CR_UNT_FNCTN', '02', 'CM_NHS_DD', 'CM_CcufAdult2'),
('/CDS/CRTCL/CR_UNT_FNCTN', '03', 'CM_NHS_DD', 'CM_CcufAdult3'),
('/CDS/CRTCL/CR_UNT_FNCTN', '05', 'CM_NHS_DD', 'CM_CcufAdult5'),
('/CDS/CRTCL/CR_UNT_FNCTN', '06', 'CM_NHS_DD', 'CM_Ccufadult6'),                    -- TODO: Capital "A"?
('/CDS/CRTCL/CR_UNT_FNCTN', '07', 'CM_NHS_DD', 'CM_Ccufadult7'),                    -- TODO: Capital "A"?
('/CDS/CRTCL/CR_UNT_FNCTN', '08', 'CM_NHS_DD', 'CM_CcufAdult8'),
('/CDS/CRTCL/CR_UNT_FNCTN', '09', 'CM_NHS_DD', 'CM_CcufAdult9'),
('/CDS/CRTCL/CR_UNT_FNCTN', '10', 'CM_NHS_DD', 'CM_CcufAdult10'),
('/CDS/CRTCL/CR_UNT_FNCTN', '11', 'CM_NHS_DD', 'CM_CcufAdult11'),
('/CDS/CRTCL/CR_UNT_FNCTN', '12', 'CM_NHS_DD', 'CM_Ccufadult12'),                    -- TODO: Capital "A"?
('/CDS/CRTCL/CR_UNT_FNCTN', '90', 'CM_NHS_DD', 'CM_Ccufadult90'),                    -- TODO: Capital "A"?
('/CDS/CRTCL/CR_UNT_FNCTN', '04', 'CM_NHS_DD', 'CM_CcufChild4'),
('/CDS/CRTCL/CR_UNT_FNCTN', '16', 'CM_NHS_DD', 'CM_CcufChild16'),
('/CDS/CRTCL/CR_UNT_FNCTN', '17', 'CM_NHS_DD', 'CM_CcufChild17'),
('/CDS/CRTCL/CR_UNT_FNCTN', '18', 'CM_NHS_DD', 'CM_CcufChild18'),
('/CDS/CRTCL/CR_UNT_FNCTN', '19', 'CM_NHS_DD', 'CM_CcufChild19'),
('/CDS/CRTCL/CR_UNT_FNCTN', '92', 'CM_NHS_DD', 'CM_CcufChild92'),
('/CDS/CRTCL/CR_UNT_FNCTN', '13', 'CM_NHS_DD', 'CM_CcufNeonate13'),
('/CDS/CRTCL/CR_UNT_FNCTN', '14', 'CM_NHS_DD', 'CM_CcufNeonate14'),
('/CDS/CRTCL/CR_UNT_FNCTN', '15', 'CM_NHS_DD', 'CM_CcufNeonate15'),
('/CDS/CRTCL/CR_UNT_FNCTN', '91', 'CM_NHS_DD', 'CM_CcuOther91'),

('/CDS/CRTCL/ADMSSN_SRC', '01', 'CM_NHS_DD', 'CM_CriticalCareSource1'),
('/CDS/CRTCL/ADMSSN_SRC', '02', 'CM_NHS_DD', 'CM_CriticalCareSource2'),
('/CDS/CRTCL/ADMSSN_SRC', '03', 'CM_NHS_DD', 'CM_CriticalCareSource3'),
('/CDS/CRTCL/ADMSSN_SRC', '04', 'CM_NHS_DD', 'CM_CriticalCareSource4'),
('/CDS/CRTCL/ADMSSN_SRC', '05', 'CM_NHS_DD', 'CM_CriticalCareSource5')

/*
('/CDS/CRTCL/ADMSSN_TYP', '01', 'CM_NHS_DD', ''),                                   -- TODO: Admission type
('/CDS/CRTCL/ADMSSN_TYP', '02', 'CM_NHS_DD', ''),
('/CDS/CRTCL/ADMSSN_TYP', '03', 'CM_NHS_DD', ''),
('/CDS/CRTCL/ADMSSN_TYP', '04', 'CM_NHS_DD', ''),
('/CDS/CRTCL/ADMSSN_TYP', '05', 'CM_NHS_DD', ''),
('/CDS/CRTCL/ADMSSN_TYP', '06', 'CM_NHS_DD', ''),

('/CDS/CRTCL/ADMSSN_LCTN', '01', 'CM_NHS_DD', ''),                                   -- TODO: Admission location
('/CDS/CRTCL/ADMSSN_LCTN', '02', 'CM_NHS_DD', ''),
('/CDS/CRTCL/ADMSSN_LCTN', '03', 'CM_NHS_DD', ''),
('/CDS/CRTCL/ADMSSN_LCTN', '04', 'CM_NHS_DD', ''),
('/CDS/CRTCL/ADMSSN_LCTN', '05', 'CM_NHS_DD', ''),
('/CDS/CRTCL/ADMSSN_LCTN', '06', 'CM_NHS_DD', ''),
('/CDS/CRTCL/ADMSSN_LCTN', '07', 'CM_NHS_DD', ''),
('/CDS/CRTCL/ADMSSN_LCTN', '08', 'CM_NHS_DD', ''),
('/CDS/CRTCL/ADMSSN_LCTN', '09', 'CM_NHS_DD', ''),
('/CDS/CRTCL/ADMSSN_LCTN', '10', 'CM_NHS_DD', ''),
('/CDS/CRTCL/ADMSSN_LCTN', '11', 'CM_NHS_DD', ''),
('/CDS/CRTCL/ADMSSN_LCTN', '12', 'CM_NHS_DD', ''),

('/CDS/CRTCL/DSCHRG_STTS', '01', 'CM_NHS_DD', ''),                                   -- TODO: Discharge status
('/CDS/CRTCL/DSCHRG_STTS', '02', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_STTS', '03', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_STTS', '04', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_STTS', '05', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_STTS', '06', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_STTS', '07', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_STTS', '08', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_STTS', '09', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_STTS', '10', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_STTS', '11', 'CM_NHS_DD', ''),

('/CDS/CRTCL/DSCHRG_DSTNTN', '01', 'CM_NHS_DD', ''),                                 -- TODO: Discharge destination
('/CDS/CRTCL/DSCHRG_DSTNTN', '02', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_DSTNTN', '03', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_DSTNTN', '04', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_DSTNTN', '05', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_DSTNTN', '06', 'CM_NHS_DD', ''),

('/CDS/CRTCL/DSCHRG_LCTN', '01', 'CM_NHS_DD', ''),                                   -- TODO: Discharge location
('/CDS/CRTCL/DSCHRG_LCTN', '02', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_LCTN', '03', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_LCTN', '04', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_LCTN', '05', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_LCTN', '06', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_LCTN', '07', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_LCTN', '08', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_LCTN', '09', 'CM_NHS_DD', ''),
('/CDS/CRTCL/DSCHRG_LCTN', '10', 'CM_NHS_DD', '')
 */
;

-- ******************** MORBIDITY ********************




/* **************************************************************************************************** */

-- Populate real tables from meta (IM v1)
SELECT DISTINCT m.node, c.dbid, false
FROM map_node_meta m
LEFT JOIN concept c ON c.id = m.concept
WHERE c.id IS NULL;

INSERT INTO map_node
(node, concept, draft)
SELECT DISTINCT m.node, c.dbid, false
FROM map_node_meta m
JOIN concept c ON c.id = m.concept;

--

SELECT prv.dbid, sys.dbid, `schema`, `table`, `column`, n.id, false
FROM map_context_meta m
JOIN map_node n ON n.node = m.node
LEFT JOIN concept prv ON prv.id = m.provider
LEFT JOIN concept sys ON sys.id = m.system
WHERE prv.id IS NULL
OR sys.id IS NULL;

INSERT INTO map_context
(provider, `system`, `schema`, `table`, `column`, node, draft)
SELECT prv.dbid, sys.dbid, `schema`, `table`, `column`, n.id, false
FROM map_context_meta m
JOIN map_node n ON n.node = m.node
JOIN concept prv ON prv.id = m.provider
JOIN concept sys ON sys.id = m.system;

--

SELECT DISTINCT n.id, c.dbid, 'Lookup()'
FROM map_node_value_meta m
JOIN map_node n ON n.node = m.node
LEFT JOIN concept c ON c.id = m.scheme
WHERE c.id IS NULL;

INSERT INTO map_value_node
(node, code_scheme, function)
SELECT DISTINCT n.id, c.dbid, 'Lookup()'
FROM map_node_value_meta m
JOIN map_node n ON n.node = m.node
JOIN concept c ON c.id = m.scheme;

--

SELECT n.id, c.dbid, m.function
FROM map_function_value_meta m
JOIN map_node n ON n.node = m.node
LEFT JOIN concept c ON c.id = m.scheme
WHERE c.id IS NULL;

INSERT INTO map_value_node
(node, code_scheme, function)
SELECT n.id, c.dbid, m.function
FROM map_function_value_meta m
JOIN map_node n ON n.node = m.node
JOIN concept c ON c.id = m.scheme;

--

SELECT v.id, m.value, c.dbid, false
FROM map_node_value_meta m
LEFT JOIN map_node n ON n.node = m.node
LEFT JOIN map_value_node v ON v.node = n.id
LEFT JOIN concept s ON s.dbid = v.code_scheme AND s.id = m.scheme
LEFT JOIN concept c ON c.id = m.concept
WHERE n.node IS NULL
OR v.node IS NULL
OR s.id IS NULL
OR c.id IS NULL;

INSERT INTO map_value_node_lookup
(value_node, value, concept, draft)
SELECT v.id, m.value, c.dbid, false
FROM map_node_value_meta m
JOIN map_node n ON n.node = m.node
JOIN map_value_node v ON v.node = n.id
JOIN concept s ON s.dbid = v.code_scheme AND s.id = m.scheme
JOIN concept c ON c.id = m.concept;

-- Clean up
DROP TABLE IF EXISTS map_context_meta;
DROP TABLE IF EXISTS map_node_value_meta;

