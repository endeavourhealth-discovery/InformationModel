SELECT @scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
-- GENERAL/GLOBAL --
(1, 'CM_Org_BHRUT', @scm, 'CM_Org_BHRUT', 'BHRUT', 'Barking, Havering and Redbridge Univerity Trust'),
(1, 'CM_Sys_Medway', @scm, 'CM_Sys_Medway', 'Medway', 'Medway patient administration system')
;
