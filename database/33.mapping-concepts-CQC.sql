INSERT IGNORE INTO concept
(document, id, name, description)
VALUES
(1, 'CM_DiscoveryCode', 'Discovery code', 'Discovery (core) coding scheme ');

SELECT @scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
-- GENERAL/GLOBAL --
(1, 'CM_Org_CQC', @scm, 'CM_Org_CQC', 'CQC', 'Care Quality Commission'),
(1, 'CM_Sys_CQC', @scm, 'CM_Sys_CQC', 'CQC', 'Care Quality Commission data sets')
;
