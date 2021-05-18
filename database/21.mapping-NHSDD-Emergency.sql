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
-- EMERGENCY --
(1, 'DM_aAndEDepartmentType', @scm, 'DM_aAndEDepartmentType', 'A&E Department', 'Accident and Emergency department type'),
(1, 'CM_AEDepType1', @scm, 'CM_AEDepType1', 'Consultant led A&E department with full facilities (department type)', 'Emergency departments are a CONSULTANT led 24 hour service with full resuscitation facilities and designated accommodation for the reception of accident and emergency PATIENTS CDS type 1'),
(1, 'CM_AEDepType2', @scm, 'CM_AEDepType2', 'Mono speciality A&E (department type)', 'Consultant led mono specialty accident and emergency service (e.g. ophthalmology, dental) with designated accommodation for the reception of PATIENTS CDS 2'),
(1, 'CM_AEDepType3', @scm, 'CM_AEDepType3', 'Minor injuries unit either Doctor or Nurse led (department type)', 'Other type of A&E/minor injury ACTIVITY with designated accommodation for the reception of accident and emergency PATIENTS. CDS 3'),
(1, 'CM_AEDepType4', @scm, 'CM_AEDepType4', 'NHS Walk in centre (department type)', 'NHS walk in centres CDS 4'),
(1, 'CM_AEDepType5', @scm, 'CM_AEDepType5', 'Ambulatory Emergency Care Service', 'Ambulatory Emergency Care Service'),

(1, 'DM_arrivalMode', @scm, 'DM_arrivalMode', 'Arrival Mode', 'Mode of arrival'),

(1, 'DM_aeAttendanceCategory', @scm, 'DM_aeAttendanceCategory', 'has a&e category of attendance of', 'points to the category of attendance whether first, subsequent, planned or unplanned'),
(1, 'CM_AEAttCat1', @scm, 'CM_AEAttCat1', 'Unplanned First Emergency Care Attendance for a new clinical condition.', 'Unplanned First Emergency Care Attendance for a new clinical condition (or deterioration of a chronic condition). CDS 1'),
(1, 'CM_AEAttCat2', @scm, 'CM_AEAttCat2', 'Unplanned Follow-up Emergency Care Attendance for the same or a related condition at this department', 'Unplanned Follow-up Emergency Care Attendance for the same or a related clinical condition and within 7 days of the First Emergency Care Attendance at THIS Emergency Care Department CDS 2'),
(1, 'CM_AEAttCat3', @scm, 'CM_AEAttCat3', 'Unplanned Follow-up Emergency Care Attendance for the same or a related condition at another department', 'Unplanned Follow-up Emergency Care Attendance for the same or a related clinical condition and within 7 days of the First Emergency Care Attendance at ANOTHER Emergency Care Department CDS 3'),
(1, 'CM_AEAttCat4', @scm, 'CM_AEAttCat4', 'Planned Follow-up Emergency Care Attendance', 'Planned Follow-up Emergency Care Attendance within 7 days of the First Emergency Care Attendance at THIS Emergency Care Department CDS 4'),

(1, 'DM_aeAttendanceSource', @scm, 'DM_aeAttendanceSource', 'A&E Attendance source', 'Source of attendance to A&D'),
(1, 'DM_treatmentFunctionAdmit', @scm, 'DM_treatmentFunctionAdmit', 'Treatment function', 'Treatment function code'),
(1, 'DM_hasDischargeDestination', @scm, 'DM_hasDischargeDestination', 'Discharge destination', 'Destination to which the patient was discharged'),
(1, 'DM_dischargeStatus', @scm, 'DM_dischargeStatus', 'Discharge status', 'The status of the patient discharge'),
(1, 'DM_dischargeFollowUp', @scm, 'DM_dischargeFollowUp', 'Discharge follow-up', 'The follow-up for the patient discharge'),
(1, 'DM_referredToServices', @scm, 'DM_referredToServices', 'Discharge referred to services', 'The services the patient was referred to on discharge');

-- Node maps
INSERT INTO map_node_meta
(node, concept)
VALUES
('/CDS/EMGCY/DPT_TYP',                   'DM_aAndEDepartmentType'),     -- NHS DD
('/CDS/EMGCY/ARRVL_MD',                  'DM_arrivalMode'),             -- SNOMED
('/CDS/EMGCY/ATTNDNC_CTGRY',             'DM_aeAttendanceCategory'),    -- NHS DD
('/CDS/EMGCY/ATTNDNC_SRC',               'DM_aeAttendanceSource'),      -- SNOMED
('/CDS/EMGCY/DSCHRG_STTS',               'DM_dischargeStatus'),         -- SNOMED
('/CDS/EMGCY/DSCHRG_DSTNTN',             'DM_hasDischargeDestination'), -- SNOMED
('/CDS/EMGCY/DSCHRG_FLLW_UP',            'DM_dischargeFollowUp'),       -- SNOMED
('/CDS/EMGCY/RFRRD_SRVCS',               'DM_referredToServices')       -- SNOMED
;

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/CDS/EMGCY/DPT_TYP', '01', 'CM_NHS_DD', 'CM_AEDepType1'),
('/CDS/EMGCY/DPT_TYP', '02', 'CM_NHS_DD', 'CM_AEDepType2'),
('/CDS/EMGCY/DPT_TYP', '03', 'CM_NHS_DD', 'CM_AEDepType3'),
('/CDS/EMGCY/DPT_TYP', '04', 'CM_NHS_DD', 'CM_AEDepType4'),
('/CDS/EMGCY/DPT_TYP', '05', 'CM_NHS_DD', 'CM_AEDepType5'),

('/CDS/EMGCY/ATTNDNC_CTGRY', '1', 'CM_NHS_DD', 'CM_AEAttCat1'),
('/CDS/EMGCY/ATTNDNC_CTGRY', '2', 'CM_NHS_DD', 'CM_AEAttCat2'),
('/CDS/EMGCY/ATTNDNC_CTGRY', '3', 'CM_NHS_DD', 'CM_AEAttCat3'),
('/CDS/EMGCY/ATTNDNC_CTGRY', '4', 'CM_NHS_DD', 'CM_AEAttCat4');
