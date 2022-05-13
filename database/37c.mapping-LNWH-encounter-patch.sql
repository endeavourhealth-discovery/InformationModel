-- ******************** HILLINGDON ********************

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

-- ******************** LNWH Silverlink ********************

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

-- ******************** LNWH Symphony ********************

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
