INSERT IGNORE INTO concept
(document, id, name, description)
VALUES
(1, 'CM_DiscoveryCode', 'Discovery code', 'Discovery (core) coding scheme ');

SELECT @scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
-- GENERAL/GLOBAL --
(1, 'CM_Org_Barts', @scm, 'CM_Org_Barts', 'Barts Hospital', 'Barts NHS Trust Hospital'),
(1, 'CM_Sys_Cerner', @scm, 'CM_Sys_Cerner', 'Cerner Millennium', 'Cerner Millennium system');

-- ******************** EMERGENCY ********************

-- Context maps
INSERT INTO map_context_meta
(provider, `system`, `schema`, `table`, `column`, node)
VALUES
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'department_type',          '/CDS/EMGCY/DPT_TYP'),                  -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'arrival_mode',             '/CDS/EMGCY/ARRVL_MD'),                 -- SNOMED
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'attendance_category',      '/CDS/EMGCY/ATTNDNC_CTGRY'),            -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'attendance_source',        '/CDS/EMGCY/ATTNDNC_SRC'),              -- SNOMED
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'treatment_function_code',  '/BRTS/CRNR/CDS/TRTMNT_FNCTN'),   -- BARTS/CERNER code
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'discharge_status',         '/CDS/EMGCY/DSCHRG_STTS'),              -- SNOMED
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'discharge_destination',    '/CDS/EMGCY/DSCHRG_DSTNTN'),            -- SNOMED
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'discharge_follow_up',      '/CDS/EMGCY/DSCHRG_FLLW_UP'),           -- SNOMED
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'referred_to_services',     '/CDS/EMGCY/RFRRD_SRVCS');              -- SNOMED

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
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'treatment_function_code',       '/BRTS/CRNR/CDS/TRTMNT_FNCTN'), -- BARTS LOCAL
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'live_or_still_birth_indicator', '/CDS/INPTNT/LV_STLL_BRTH_INDCTR'),    -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'delivery_method',               '/CDS/INPTNT/DLVRY_MTHD'),             -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'gender',                        '/CDS/INPTNT/GNDR')                    -- NHS DD
;

-- ******************** OUTPATIENT ********************

-- Context maps
INSERT INTO map_context_meta
(provider, `system`, `schema`, `table`, `column`, node)
VALUES
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'outpatient', 'appt_attended_code',           '/CDS/OUTPTNT/APPT_ATTNDD'),           -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'outpatient', 'appt_outcome_code',            '/CDS/OUTPTNT/OUTCM'),                 -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'outpatient', 'administrative_category_code', '/CDS/OUTPTNT/ADMNSTRTV_CTGRY'),       -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'outpatient', 'referral_source',              '/CDS/OUTPTNT/RFRRL_SRC'),             -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'outpatient', 'treatment_function_code',      '/BRTS/CRNR/CDS/TRTMNT_FNCTN') -- BARTS/CERNER code
;

-- ******************** CRITICAL CARE ********************

-- Context maps
INSERT INTO map_context_meta
(provider, `system`, `schema`, `table`, `column`, node)
VALUES
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'critical_care_type_id',          '/CDS/CRTCL/CRTCL_CR_TYP'),    -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'care_unit_function',             '/CDS/CRTCL/CR_UNT_FNCTN'),    -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'admission_source_code',          '/CDS/CRTCL/ADMSSN_SRC'),      -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'admission_type_code',            '/CDS/CRTCL/ADMSSN_TYP'),      -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'admission_location',             '/CDS/CRTCL/ADMSSN_LCTN'),     -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'discharge_status_code',          '/CDS/CRTCL/DSCHRG_STTS'),     -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'discharge_destination',          '/CDS/CRTCL/DSCHRG_DSTNTN'),   -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'discharge_location',             '/CDS/CRTCL/DSCHRG_LCTN')      -- NHS DD
;

-- ******************** TREATMENT FUNCTION CODES ********************

-- Node maps
INSERT INTO map_node_meta
(node, concept)
VALUES
('/BRTS/CRNR/CDS/TRTMNT_FNCTN',    'DM_treatmentFunctionAdmit')   -- BARTS/CERNER code
;

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768934', 'BartsCerner', 'CM_TrtmntFnc100'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768935', 'BartsCerner', 'CM_TrtmntFnc101'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521783', 'BartsCerner', 'CM_TrtmntFnc101'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '117710513', 'BartsCerner', 'CM_TrtmntFnc101'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768973', 'BartsCerner', 'CM_TrtmntFnc102'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521701', 'BartsCerner', 'CM_TrtmntFnc102'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521786', 'BartsCerner', 'CM_TrtmntFnc102'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768923', 'BartsCerner', 'CM_TrtmntFnc103'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768970', 'BartsCerner', 'CM_TrtmntFnc104'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768979', 'BartsCerner', 'CM_TrtmntFnc105'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521714', 'BartsCerner', 'CM_TrtmntFnc105'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768965', 'BartsCerner', 'CM_TrtmntFnc106'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768974', 'BartsCerner', 'CM_TrtmntFnc107'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '163299897', 'BartsCerner', 'CM_TrtmntFnc108'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768936', 'BartsCerner', 'CM_TrtmntFnc110'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '117708316', 'BartsCerner', 'CM_TrtmntFnc110'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '117709260', 'BartsCerner', 'CM_TrtmntFnc110'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '117709832', 'BartsCerner', 'CM_TrtmntFnc110'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768933', 'BartsCerner', 'CM_TrtmntFnc120'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521760', 'BartsCerner', 'CM_TrtmntFnc120'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '313020', 'BartsCerner', 'CM_TrtmntFnc130'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6174973', 'BartsCerner', 'CM_TrtmntFnc130'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6175005', 'BartsCerner', 'CM_TrtmntFnc130'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521726', 'BartsCerner', 'CM_TrtmntFnc130'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768937', 'BartsCerner', 'CM_TrtmntFnc140'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768938', 'BartsCerner', 'CM_TrtmntFnc141'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768939', 'BartsCerner', 'CM_TrtmntFnc142'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768940', 'BartsCerner', 'CM_TrtmntFnc143'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768929', 'BartsCerner', 'CM_TrtmntFnc144'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768941', 'BartsCerner', 'CM_TrtmntFnc150'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768942', 'BartsCerner', 'CM_TrtmntFnc160'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768967', 'BartsCerner', 'CM_TrtmntFnc161'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '313003', 'BartsCerner', 'CM_TrtmntFnc170'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768944', 'BartsCerner', 'CM_TrtmntFnc171'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6175001', 'BartsCerner', 'CM_TrtmntFnc171'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768968', 'BartsCerner', 'CM_TrtmntFnc172'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768972', 'BartsCerner', 'CM_TrtmntFnc173'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768969', 'BartsCerner', 'CM_TrtmntFnc174'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768930', 'BartsCerner', 'CM_TrtmntFnc180'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '4467020', 'BartsCerner', 'CM_TrtmntFnc190'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521741', 'BartsCerner', 'CM_TrtmntFnc190'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768945', 'BartsCerner', 'CM_TrtmntFnc191'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768928', 'BartsCerner', 'CM_TrtmntFnc192'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '4467021', 'BartsCerner', 'CM_TrtmntFnc211'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '117707696', 'BartsCerner', 'CM_TrtmntFnc211'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '4467022', 'BartsCerner', 'CM_TrtmntFnc212'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '4467023', 'BartsCerner', 'CM_TrtmntFnc213'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '4467024', 'BartsCerner', 'CM_TrtmntFnc214'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '4467025', 'BartsCerner', 'CM_TrtmntFnc215'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '4467026', 'BartsCerner', 'CM_TrtmntFnc216'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '4467027', 'BartsCerner', 'CM_TrtmntFnc217'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928166', 'BartsCerner', 'CM_TrtmntFnc218'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928169', 'BartsCerner', 'CM_TrtmntFnc219'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928144', 'BartsCerner', 'CM_TrtmntFnc220'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928165', 'BartsCerner', 'CM_TrtmntFnc221'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928164', 'BartsCerner', 'CM_TrtmntFnc222'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '163299957', 'BartsCerner', 'CM_TrtmntFnc223'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928170', 'BartsCerner', 'CM_TrtmntFnc241'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928147', 'BartsCerner', 'CM_TrtmntFnc242'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928174', 'BartsCerner', 'CM_TrtmntFnc251'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928180', 'BartsCerner', 'CM_TrtmntFnc252'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928146', 'BartsCerner', 'CM_TrtmntFnc253'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928176', 'BartsCerner', 'CM_TrtmntFnc254'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928148', 'BartsCerner', 'CM_TrtmntFnc255'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928177', 'BartsCerner', 'CM_TrtmntFnc256'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928161', 'BartsCerner', 'CM_TrtmntFnc257'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928149', 'BartsCerner', 'CM_TrtmntFnc258'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928156', 'BartsCerner', 'CM_TrtmntFnc259'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521698', 'BartsCerner', 'CM_TrtmntFnc259'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928153', 'BartsCerner', 'CM_TrtmntFnc260'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928155', 'BartsCerner', 'CM_TrtmntFnc261'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928160', 'BartsCerner', 'CM_TrtmntFnc262'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '71843418', 'BartsCerner', 'CM_TrtmntFnc263'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6174997', 'BartsCerner', 'CM_TrtmntFnc264'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928159', 'BartsCerner', 'CM_TrtmntFnc280'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3840186', 'BartsCerner', 'CM_TrtmntFnc290'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928152', 'BartsCerner', 'CM_TrtmntFnc291'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768946', 'BartsCerner', 'CM_TrtmntFnc300'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521691', 'BartsCerner', 'CM_TrtmntFnc300'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768943', 'BartsCerner', 'CM_TrtmntFnc301'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '117704757', 'BartsCerner', 'CM_TrtmntFnc301'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '326409423', 'BartsCerner', 'CM_TrtmntFnc301'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768947', 'BartsCerner', 'CM_TrtmntFnc302'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768922', 'BartsCerner', 'CM_TrtmntFnc303'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6174980', 'BartsCerner', 'CM_TrtmntFnc303'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521692', 'BartsCerner', 'CM_TrtmntFnc303'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521728', 'BartsCerner', 'CM_TrtmntFnc303'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '23718840', 'BartsCerner', 'CM_TrtmntFnc303'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6182528', 'BartsCerner', 'CM_TrtmntFnc304'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768949', 'BartsCerner', 'CM_TrtmntFnc305'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928158', 'BartsCerner', 'CM_TrtmntFnc306'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521737', 'BartsCerner', 'CM_TrtmntFnc306'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768924', 'BartsCerner', 'CM_TrtmntFnc307'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6175000', 'BartsCerner', 'CM_TrtmntFnc307'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '35472688', 'BartsCerner', 'CM_TrtmntFnc307'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768966', 'BartsCerner', 'CM_TrtmntFnc308'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768978', 'BartsCerner', 'CM_TrtmntFnc309'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768950', 'BartsCerner', 'CM_TrtmntFnc310'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768951', 'BartsCerner', 'CM_TrtmntFnc311'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768952', 'BartsCerner', 'CM_TrtmntFnc313'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '313027', 'BartsCerner', 'CM_TrtmntFnc314'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768953', 'BartsCerner', 'CM_TrtmntFnc315'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768976', 'BartsCerner', 'CM_TrtmntFnc316'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768981', 'BartsCerner', 'CM_TrtmntFnc317'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768963', 'BartsCerner', 'CM_TrtmntFnc318'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '66871717', 'BartsCerner', 'CM_TrtmntFnc318'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768980', 'BartsCerner', 'CM_TrtmntFnc319'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768910', 'BartsCerner', 'CM_TrtmntFnc320'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '117702682', 'BartsCerner', 'CM_TrtmntFnc320'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '215885962', 'BartsCerner', 'CM_TrtmntFnc320'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '215886742', 'BartsCerner', 'CM_TrtmntFnc320'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '215887515', 'BartsCerner', 'CM_TrtmntFnc320'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '215888652', 'BartsCerner', 'CM_TrtmntFnc320'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768927', 'BartsCerner', 'CM_TrtmntFnc321'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768962', 'BartsCerner', 'CM_TrtmntFnc322'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928179', 'BartsCerner', 'CM_TrtmntFnc323'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768948', 'BartsCerner', 'CM_TrtmntFnc324'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '71843422', 'BartsCerner', 'CM_TrtmntFnc325'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521752', 'BartsCerner', 'CM_TrtmntFnc327'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '71843258', 'BartsCerner', 'CM_TrtmntFnc328'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '71843259', 'BartsCerner', 'CM_TrtmntFnc329'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768954', 'BartsCerner', 'CM_TrtmntFnc330'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '117704147', 'BartsCerner', 'CM_TrtmntFnc330'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '163300530', 'BartsCerner', 'CM_TrtmntFnc331'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768955', 'BartsCerner', 'CM_TrtmntFnc340'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6175006', 'BartsCerner', 'CM_TrtmntFnc340'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6233025', 'BartsCerner', 'CM_TrtmntFnc340'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768971', 'BartsCerner', 'CM_TrtmntFnc341'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '71843420', 'BartsCerner', 'CM_TrtmntFnc342'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '71843247', 'BartsCerner', 'CM_TrtmntFnc343'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '163300661', 'BartsCerner', 'CM_TrtmntFnc344'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '163300859', 'BartsCerner', 'CM_TrtmntFnc345'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '163302228', 'BartsCerner', 'CM_TrtmntFnc346'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768956', 'BartsCerner', 'CM_TrtmntFnc350'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6174971', 'BartsCerner', 'CM_TrtmntFnc350'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768977', 'BartsCerner', 'CM_TrtmntFnc352'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768957', 'BartsCerner', 'CM_TrtmntFnc360'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768958', 'BartsCerner', 'CM_TrtmntFnc361'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6174998', 'BartsCerner', 'CM_TrtmntFnc361'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6174999', 'BartsCerner', 'CM_TrtmntFnc361'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6175011', 'BartsCerner', 'CM_TrtmntFnc361'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6232618', 'BartsCerner', 'CM_TrtmntFnc361'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '183705329', 'BartsCerner', 'CM_TrtmntFnc361'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768959', 'BartsCerner', 'CM_TrtmntFnc370'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6175007', 'BartsCerner', 'CM_TrtmntFnc370'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6183642', 'BartsCerner', 'CM_TrtmntFnc371'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '313019', 'BartsCerner', 'CM_TrtmntFnc400'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6175010', 'BartsCerner', 'CM_TrtmntFnc400'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6181751', 'BartsCerner', 'CM_TrtmntFnc401'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768911', 'BartsCerner', 'CM_TrtmntFnc410'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521759', 'BartsCerner', 'CM_TrtmntFnc410'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768932', 'BartsCerner', 'CM_TrtmntFnc420'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768912', 'BartsCerner', 'CM_TrtmntFnc421'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768931', 'BartsCerner', 'CM_TrtmntFnc422'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6175004', 'BartsCerner', 'CM_TrtmntFnc422'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6175008', 'BartsCerner', 'CM_TrtmntFnc422'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6175009', 'BartsCerner', 'CM_TrtmntFnc422'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '179427781', 'BartsCerner', 'CM_TrtmntFnc422'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768925', 'BartsCerner', 'CM_TrtmntFnc424'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928157', 'BartsCerner', 'CM_TrtmntFnc430'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6174978', 'BartsCerner', 'CM_TrtmntFnc430'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768913', 'BartsCerner', 'CM_TrtmntFnc450'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '117702019', 'BartsCerner', 'CM_TrtmntFnc450'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768914', 'BartsCerner', 'CM_TrtmntFnc460'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768961', 'BartsCerner', 'CM_TrtmntFnc501'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3916375', 'BartsCerner', 'CM_TrtmntFnc501'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928183', 'BartsCerner', 'CM_TrtmntFnc501'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768915', 'BartsCerner', 'CM_TrtmntFnc502'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6175003', 'BartsCerner', 'CM_TrtmntFnc502'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521693', 'BartsCerner', 'CM_TrtmntFnc502'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521694', 'BartsCerner', 'CM_TrtmntFnc502'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521734', 'BartsCerner', 'CM_TrtmntFnc502'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521761', 'BartsCerner', 'CM_TrtmntFnc502'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521784', 'BartsCerner', 'CM_TrtmntFnc502'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '117703272', 'BartsCerner', 'CM_TrtmntFnc502'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768926', 'BartsCerner', 'CM_TrtmntFnc503'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6521690', 'BartsCerner', 'CM_TrtmntFnc503'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768916', 'BartsCerner', 'CM_TrtmntFnc560'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '313022', 'BartsCerner', 'CM_TrtmntFnc650'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '117706364', 'BartsCerner', 'CM_TrtmntFnc650'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '117706911', 'BartsCerner', 'CM_TrtmntFnc650'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '333406451', 'BartsCerner', 'CM_TrtmntFnc650'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928168', 'BartsCerner', 'CM_TrtmntFnc651'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '333406704', 'BartsCerner', 'CM_TrtmntFnc651'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928178', 'BartsCerner', 'CM_TrtmntFnc652'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '333407095', 'BartsCerner', 'CM_TrtmntFnc652'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928175', 'BartsCerner', 'CM_TrtmntFnc653'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928151', 'BartsCerner', 'CM_TrtmntFnc654'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '333406866', 'BartsCerner', 'CM_TrtmntFnc654'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '403948617', 'BartsCerner', 'CM_TrtmntFnc654'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928171', 'BartsCerner', 'CM_TrtmntFnc655'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '313000', 'BartsCerner', 'CM_TrtmntFnc656'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '313023', 'BartsCerner', 'CM_TrtmntFnc657'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928172', 'BartsCerner', 'CM_TrtmntFnc658'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '71843507', 'BartsCerner', 'CM_TrtmntFnc659'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '71843249', 'BartsCerner', 'CM_TrtmntFnc660'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '71843257', 'BartsCerner', 'CM_TrtmntFnc661'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '71843414', 'BartsCerner', 'CM_TrtmntFnc662'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '163306560', 'BartsCerner', 'CM_TrtmntFnc663'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768960', 'BartsCerner', 'CM_TrtmntFnc700'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768975', 'BartsCerner', 'CM_TrtmntFnc710'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768917', 'BartsCerner', 'CM_TrtmntFnc711'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768918', 'BartsCerner', 'CM_TrtmntFnc712'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768919', 'BartsCerner', 'CM_TrtmntFnc713'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768920', 'BartsCerner', 'CM_TrtmntFnc715'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '313001', 'BartsCerner', 'CM_TrtmntFnc720'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '313002', 'BartsCerner', 'CM_TrtmntFnc721'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '313007', 'BartsCerner', 'CM_TrtmntFnc722'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '313005', 'BartsCerner', 'CM_TrtmntFnc723'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '313008', 'BartsCerner', 'CM_TrtmntFnc724'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '163306756', 'BartsCerner', 'CM_TrtmntFnc725'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '163306927', 'BartsCerner', 'CM_TrtmntFnc726'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '163307027', 'BartsCerner', 'CM_TrtmntFnc727'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768921', 'BartsCerner', 'CM_TrtmntFnc800'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6174976', 'BartsCerner', 'CM_TrtmntFnc800'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6174982', 'BartsCerner', 'CM_TrtmntFnc800'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6174995', 'BartsCerner', 'CM_TrtmntFnc800'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6175002', 'BartsCerner', 'CM_TrtmntFnc800'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3768964', 'BartsCerner', 'CM_TrtmntFnc811'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6179756', 'BartsCerner', 'CM_TrtmntFnc812'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '3928145', 'BartsCerner', 'CM_TrtmntFnc822'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '71843251', 'BartsCerner', 'CM_TrtmntFnc834'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '6183485', 'BartsCerner', 'CM_TrtmntFnc840'),
('/BRTS/CRNR/CDS/TRTMNT_FNCTN', '163307287', 'BartsCerner', 'CM_TrtmntFnc920');
