INSERT IGNORE INTO concept
(document, id, name, description)
VALUES
(1, 'CM_DiscoveryCode', 'Discovery code', 'Discovery (core) coding scheme ');

SELECT @scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
-- GENERAL/GLOBAL --
(1, 'CM_Org_BHRUT', @scm, 'CM_Org_BHRUT', 'BHRUT', 'Barking, Havering and Redbridge Univerity Trust'),
(1, 'CM_Sys_Medway', @scm, 'CM_Sys_Medway', 'Medway', 'Medway patient administration system'),
-- MORBIDITY --
(1, 'DM_CauseOfDeath', @scm, 'DM_CauseOfDeath', 'Cause of death - I(a)', 'Disease or condition leading directly to death - MCCD I(a)'),
(1, 'DM_CauseOfDeath1b', @scm, 'DM_CauseOfDeath1b', 'Cause of death - I(b)', 'Other disease or condition, if any, leading to I(a) - MCCD I(b)'),
(1, 'DM_CauseOfDeath1c', @scm, 'DM_CauseOfDeath1c', 'Cause of death - I(c)', 'Other disease or condition, if any, leading to I(b) - MCCD I(c)'),
(1, 'DM_CauseOfDeath2', @scm, 'DM_CauseOfDeath2', 'Contributing to death - II', 'Other significant condition contributing to death but not related to the disease or condition causing it - MCCD II'),
(1, 'DM_InfectionStatus', @scm, 'DM_InfectionStatus', 'Infection status', 'Infection status (in cases of repatriation request for example)')
;

-- Context maps
INSERT INTO map_context_meta
(provider, `system`, `schema`, `table`, `column`, node)
VALUES
-- ******************** Morbidity ********************
('CM_Org_BHRUT', 'CM_Sys_Medway', 'MedwayBI', 'PMI', 'CAUSEOFDEATH',                    '/BHRUT/MDWY/MDWYBI/PMI/CS_DTH'),
('CM_Org_BHRUT', 'CM_Sys_Medway', 'MedwayBI', 'PMI', 'CAUSEOFDEATH 1B',                 '/BHRUT/MDWY/MDWYBI/PMI/CS_DTH_1B'),
('CM_Org_BHRUT', 'CM_Sys_Medway', 'MedwayBI', 'PMI', 'CAUSEOFDEATH 1c',                 '/BHRUT/MDWY/MDWYBI/PMI/CS_DTH_1C'),
('CM_Org_BHRUT', 'CM_Sys_Medway', 'MedwayBI', 'PMI', 'CAUSEOFDEATH 2',                  '/BHRUT/MDWY/MDWYBI/PMI/CS_DTH_2'),
('CM_Org_BHRUT', 'CM_Sys_Medway', 'MedwayBI', 'PMI', 'INFECTION_STATUS',                '/BHRUT/MDWY/MDWYBI/PMI/INFCTN_STTS'),
-- ******************** Spells ********************
('CM_Org_BHRUT', 'CM_Sys_Medway', 'MedwayBI', 'Spells', 'patient_class',                '/CDS/INPTNT/PTNT_CLSSFCTN'),       -- NHS DD
('CM_Org_BHRUT', 'CM_Sys_Medway', 'MedwayBI', 'Spells', 'admission_source_code',        '/CDS/INPTNT/ADMSSN_SRC'),          -- NHS DD
('CM_Org_BHRUT', 'CM_Sys_Medway', 'MedwayBI', 'Spells', 'admission_method_code',        '/CDS/INPTNT/ADMSSN_MTHD'),         -- NHS DD
('CM_Org_BHRUT', 'CM_Sys_Medway', 'MedwayBI', 'Spells', 'discharge_method_code',        '/CDS/INPTNT/DSCHRG_MTHD'),         -- NHS DD
('CM_Org_BHRUT', 'CM_Sys_Medway', 'MedwayBI', 'Spells', 'discharge_destination_code',   '/CDS/INPTNT/DSCHRG_DSTNTN'),       -- NHS DD
-- ******************** Episodes ********************
('CM_Org_BHRUT', 'CM_Sys_Medway', 'CSV', 'Episodes', 'administrative_category_code',    '/CDS/INPTNT/ADMNSTRV_CTGRY'),      -- NHS DD
-- ******************** Outpatients ********************
('CM_Org_BHRUT', 'CM_Sys_Medway', 'CSV', 'Outpatients', 'admin_category_code',          '/CDS/INPTNT/ADMNSTRV_CTGRY'),      -- NHS DD
('CM_Org_BHRUT', 'CM_Sys_Medway', 'CSV', 'Outpatients', 'appointment_status_code',      '/CDS/INPTNT/APPNTMNT_STTS_CD')     -- NHS DD
;

-- Node maps
INSERT INTO map_node_meta
(node, concept)
VALUES
('/BHRUT/MDWY/MDWYBI/PMI/CS_DTH',               'DM_CauseOfDeath'),
('/BHRUT/MDWY/MDWYBI/PMI/CS_DTH_1B',            'DM_CauseOfDeath1b'),
('/BHRUT/MDWY/MDWYBI/PMI/CS_DTH_1C',            'DM_CauseOfDeath1c'),
('/BHRUT/MDWY/MDWYBI/PMI/CS_DTH_2',             'DM_CauseOfDeath2'),
('/BHRUT/MDWY/MDWYBI/PMI/INFCTN_STTS',          'DM_InfectionStatus')
;
