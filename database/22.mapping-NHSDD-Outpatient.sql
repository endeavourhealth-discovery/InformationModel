-- Ensure core code scheme exists
INSERT IGNORE INTO concept (document, id, name, description)
VALUES (1, 'CM_DiscoveryCode', 'Discovery code', 'Discovery (core) coding scheme ');

-- Get scheme id
SELECT @scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';

-- Ensure NHS DD scheme exists --
INSERT IGNORE INTO concept (document, id, scheme, code, name, description)
VALUES (1, 'CM_NHS_DD', @scm, 'CM_NHS_DD', 'NHS Data Dictionary', 'NHS Data Dictionary coding scheme');

-- Code scheme prefix entries
INSERT IGNORE INTO concept_property_data
(`dbid`, `group`, `property`, `value`)
SELECT c.dbid, 0 AS `group`, p.dbid AS `property`, '' AS `value`
FROM concept c
         JOIN concept p ON p.id = 'code_prefix'
WHERE c.id IN ('CM_DiscoveryCode', 'CM_NHS_DD');

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
-- OUTPATIENT --
(1, 'DM_attendanceStatus', @scm, 'DM_attendanceStatus', 'has attendance status', 'points to whether the patient attended or not'),
(1, 'CM_AttNotAtt5', @scm, 'CM_AttNotAtt5', 'Attended on time or before the professional was ready to see the patient', 'Attended on time or, if late, before the relevant CARE PROFESSIONAL was ready to see the PATIENT CDS 5'),
(1, 'CM_AttNotAtt6', @scm, 'CM_AttNotAtt6', 'Arrived late, after the professional was ready to see the patient, but was seen', 'Arrived late, after the relevant CARE PROFESSIONAL was ready to see the PATIENT, but was seen CDS 6'),
(1, 'CM_AttNotAtt7', @scm, 'CM_AttNotAtt7', 'Arrived late and could not be seen', 'PATIENT arrived late and could not be seen CDS 7'),
(1, 'CM_AttNotAtt2', @scm, 'CM_AttNotAtt2', 'Cancelled by, or on behalf of, the patient', 'APPOINTMENT cancelled by, or on behalf of, the PATIENT CDS 2'),
(1, 'CM_AttnotAtt3', @scm, 'CM_AttnotAtt3', 'Did not attend  with no advance warning', 'Did not attend - no advance warning given CDS 3'),
(1, 'CM_AttnotAtt4', @scm, 'CM_AttnotAtt4', 'Cancelled or postponed by the Health Care Provider', 'APPOINTMENT cancelled or postponed by the Health Care Provider CDS 4'),
(1, 'CM_AttNotAtt00', @scm, 'CM_AttNotAtt00', 'Not applicable - appointment occurs in the future', 'Not applicable - APPOINTMENT occurs in the future CDS 0'),

(1, 'DM_hasAttendanceOutcome', @scm, 'DM_hasAttendanceOutcome', 'has attendance outcome', 'points to the outcome of the attendance'),
(1, 'CM_AttOpd1', @scm, 'CM_AttOpd1', 'Discharged from care - last attendance', 'Discharged from CONSULTANT''s care (last attendance) CDS 1'),
(1, 'CM_AttOpd2', @scm, 'CM_AttOpd2', 'Another appointment given', 'Another APPOINTMENT given CDS 2'),
(1, 'CM_AttOpd3', @scm, 'CM_AttOpd3', 'Appointment to be made at a later date', 'APPOINTMENT to be made at a later date CDS 3'),

-- DM_adminCategoryonAdmission - Inpatient above
-- CM_AdminCat01 - Inpatient above
-- CM_AdminCat02 - Inpatient above
-- CM_AdminCat03 - Inpatient above
-- CM_AdminCat04 - Inpatient above

(1, 'DM_referralSource', @scm, 'DM_referralSource', 'Referral source', 'Source of the referral'),
(1, 'CM_OutRefSrc01', @scm, 'CM_OutRefSrc01', 'CONSULTANT initiated following an emergency admission', 'CONSULTANT initiated following an emergency admission'),
(1, 'CM_OutRefSrc02', @scm, 'CM_OutRefSrc02', 'CONSULTANT initiated following a Domiciliary Consultation', 'CONSULTANT initiated following a Domiciliary Consultation'),
(1, 'CM_OutRefSrc10', @scm, 'CM_OutRefSrc10', 'CONSULTANT initiated following an Accident and Emergency Attendance', 'CONSULTANT initiated following an Accident and Emergency Attendance (including Minor Injuries Units and Walk In Centres)'),
(1, 'CM_OutRefSrc11', @scm, 'CM_OutRefSrc11', 'CONSULTANT initiated: Other', 'CONSULTANT initiated: Other (not listed)'),
(1, 'CM_OutRefSrc03', @scm, 'CM_OutRefSrc03', 'CONSULTANT not initiated following a referral from a GENERAL MEDICAL PRACTITIONER', 'CONSULTANT not initiated following a referral from a GENERAL MEDICAL PRACTITIONER'),
(1, 'CM_OutRefSrc92', @scm, 'CM_OutRefSrc92', 'CONSULTANT not initiated following a referral from a GENERAL DENTAL PRACTITIONER', 'CONSULTANT not initiated following a referral from a GENERAL DENTAL PRACTITIONER'),
(1, 'CM_OutRefSrc12', @scm, 'CM_OutRefSrc12', 'CONSULTANT not initiated following a referral from a GPwER or DES', 'CONSULTANT not initiated following a referral from a General Practitioner with an Extended Role (GPwER) or Dentist with Enhanced Skills (DES)'),
(1, 'CM_OutRefSrc04', @scm, 'CM_OutRefSrc04', 'CONSULTANT not initiated following a referral from an A&E Department', 'CONSULTANT not initiated following a referral from an Accident and Emergency Department (including Minor Injuries Units and Walk In Centres)'),
(1, 'CM_OutRefSrc05', @scm, 'CM_OutRefSrc05', 'CONSULTANT not initiated following a referral from a CONSULTANT, other than in an A&E Department', 'CONSULTANT not initiated following a referral from a CONSULTANT, other than in an Accident and Emergency Department'),
(1, 'CM_OutRefSrc06', @scm, 'CM_OutRefSrc06', 'CONSULTANT not initiated following a self-referral', 'CONSULTANT not initiated following a self-referral'),
(1, 'CM_OutRefSrc07', @scm, 'CM_OutRefSrc07', 'CONSULTANT not initiated following a referral from a Prosthetist', 'CONSULTANT not initiated following a referral from a Prosthetist'),
(1, 'CM_OutRefSrc13', @scm, 'CM_OutRefSrc13', 'CONSULTANT not initiated following a referral from a Specialist NURSE', 'CONSULTANT not initiated following a referral from a Specialist NURSE (Secondary Care)'),
(1, 'CM_OutRefSrc14', @scm, 'CM_OutRefSrc14', 'CONSULTANT not initiated following a referral from an Allied Health Professional', 'CONSULTANT not initiated following a referral from an Allied Health Professional'),
(1, 'CM_OutRefSrc15', @scm, 'CM_OutRefSrc15', 'CONSULTANT not initiated following a referral from an OPTOMETRIST', 'CONSULTANT not initiated following a referral from an OPTOMETRIST'),
(1, 'CM_OutRefSrc16', @scm, 'CM_OutRefSrc16', 'CONSULTANT not initiated following a referral from an Orthoptist', 'CONSULTANT not initiated following a referral from an Orthoptist'),
(1, 'CM_OutRefSrc17', @scm, 'CM_OutRefSrc17', 'CONSULTANT not initiated following a referral from a National Screening Programme', 'CONSULTANT not initiated following a referral from a National Screening Programme'),
(1, 'CM_OutRefSrc93', @scm, 'CM_OutRefSrc93', 'CONSULTANT not initiated following a referral from a Community Dental Service', 'CONSULTANT not initiated following a referral from a Community Dental Service'),
(1, 'CM_OutRefSrc97', @scm, 'CM_OutRefSrc97', 'CONSULTANT not initiated following a referral: Other', 'CONSULTANT not initiated following a referral: Other (not listed)')
;

-- Node maps
INSERT INTO map_node_meta
(node, concept)
VALUES
('/CDS/OUTPTNT/APPT_ATTNDD',             'DM_attendanceStatus'),                -- NHS DD
('/CDS/OUTPTNT/OUTCM',                   'DM_hasAttendanceOutcome'),            -- NHS DD
('/CDS/OUTPTNT/ADMNSTRTV_CTGRY',         'DM_adminCategoryonAdmission'),        -- NHS DD
('/CDS/OUTPTNT/RFRRL_SRC',               'DM_referralSource')         -- NHS DD
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
('/CDS/OUTPTNT/ADMNSTRTV_CTGRY', '04', 'CM_NHS_DD', 'CM_AdminCat04'),

('/CDS/OUTPTNT/RFRRL_SRC', '01', 'CM_NHS_DD', 'CM_OutRefSrc01'),
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
;
