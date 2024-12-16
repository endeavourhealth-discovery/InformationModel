-- Ensure core code scheme exists
INSERT IGNORE INTO concept (document, id, name, description)
VALUES (1, 'CM_DiscoveryCode', 'Discovery code', 'Discovery (core) coding scheme ');

-- Get scheme id
SELECT @scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';

-- Ensure NHS DD scheme exists --
INSERT IGNORE INTO concept (document, id, scheme, code, name, description)
VALUES
(1, 'CM_NHS_DD', @scm, 'CM_NHS_DD', 'NHS Data Dictionary', 'NHS Data Dictionary coding scheme'),
(1, 'CM_Org_EMIS', @scm, 'CM_Org_EMIS', 'EMIS', 'Egton Medical Information Systems'),
(1, 'CM_Sys_EMISWeb', @scm, 'CM_Sys_EMISWeb', 'EMIS Web', 'EMIS Web EPR'),
(1, 'CM_Org_TPP', @scm, 'CM_Org_TPP', 'TPP', 'The Phoenix Partnership'),
(1, 'CM_Sys_SystmOne', @scm, 'CM_Sys_SystmOne', 'SystmOne', 'SystmOne EPR');

-- Code scheme prefix entries
INSERT IGNORE INTO concept_property_data
(`dbid`, `group`, `property`, `value`)
SELECT c.dbid, 0 AS `group`, p.dbid AS `property`, '' AS `value`
FROM concept c
JOIN concept p ON p.id = 'code_prefix'
WHERE c.id IN ('CM_DiscoveryCode', 'CM_NHS_DD');

INSERT IGNORE INTO concept (document, id, scheme, code, name, description)
VALUES
(1, 'DM_AppointmentBookingDate', @scm, 'DM_AppointmentBookingDate', 'Appointment booking date', 'The date the appointment was booked'),
(1, 'DM_AppointmentMode', @scm, 'DM_AppointmentMode', 'Appointment mode', 'The appointment mode of contact'),
(1, 'NHS_ApptMd_Fc2Fc', @scm, 'NHS_ApptMd_Fc2Fc', 'Face to Face', 'Face to Face'),
(1, 'NHS_ApptMd_HmVst', @scm, 'NHS_ApptMd_HmVst', 'Home Visit', 'Home Visit'),
(1, 'NHS_ApptMd_Tlphn', @scm, 'NHS_ApptMd_Tlphn', 'Telephone', 'Telephone'),
(1, 'NHS_ApptMd_VdOnln', @scm, 'NHS_ApptMd_VdOnln', 'Video/Online', 'Video/Online'),
(1, 'NHS_ApptMd_Unknwn', @scm, 'NHS_ApptMd_Unknwn', 'Unknown', 'Unknown');

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES
('CM_Org_EMIS', 'CM_Sys_EMISWeb', null, 'appointment', 'mode', '/NHS/APPNTMNT/APPNTMNT_MD'),    -- Local
('CM_Org_TPP', 'CM_Sys_SystmOne', null, 'appointment', 'mode', '/NHS/APPNTMNT/APPNTMNT_MD');    -- Local

-- Node maps
INSERT INTO map_node_meta
(node, concept)
VALUES
('/NHS/APPNTMNT/APPNTMNT_MD',             'DM_AppointmentMode');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/NHS/APPNTMNT/APPNTMNT_MD', 'Face to Face (Surgery)', 'EMIS_LOCAL', 'NHS_ApptMd_Fc2Fc'),
('/NHS/APPNTMNT/APPNTMNT_MD', 'Face to Face (Home Visit)', 'EMIS_LOCAL', 'NHS_ApptMd_HmVst'),
('/NHS/APPNTMNT/APPNTMNT_MD', 'Telephone/Audio', 'EMIS_LOCAL', 'NHS_ApptMd_Tlphn'),
('/NHS/APPNTMNT/APPNTMNT_MD', 'Video with Audio', 'EMIS_LOCAL', 'NHS_ApptMd_VdOnln'),
('/NHS/APPNTMNT/APPNTMNT_MD', 'Written (Including Online)', 'EMIS_LOCAL', 'NHS_ApptMd_VdOnln'),
('/NHS/APPNTMNT/APPNTMNT_MD', 'Not an Appointment', 'EMIS_LOCAL', 'NHS_ApptMd_Unknwn'),
('/NHS/APPNTMNT/APPNTMNT_MD', 'Home Visit', 'TPP_LOCAL', 'NHS_ApptMd_HmVst'),
('/NHS/APPNTMNT/APPNTMNT_MD', 'Telephone Appointment', 'TPP_LOCAL', 'NHS_ApptMd_Tlphn');
