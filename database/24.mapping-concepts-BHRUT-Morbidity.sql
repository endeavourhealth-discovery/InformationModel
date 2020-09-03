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
