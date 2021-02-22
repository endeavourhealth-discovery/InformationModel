INSERT IGNORE INTO concept
(document, id, name, description)
VALUES
(1, 'CM_DiscoveryCode', 'Discovery code', 'Discovery (core) coding scheme ');

SELECT @scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
-- GENERAL/GLOBAL --
(1, 'CM_Org_Imperial', @scm, 'CM_Org_Imperial', 'Imperial College', 'Imperial College Hospital, London'),
(1, 'CM_Sys_Cerner', @scm, 'CM_Sys_Cerner', 'Cerner Millennium', 'Cerner Millennium system'),
(1, 'ImperialCerner', @scm, 'ImperialCerner', 'Imperial Local Codes', 'Imperial Cerner local code scheme'),
(1, 'CM_GPPractitionerId', @scm, 'CM_GPPractitionerId', 'GP Practitioner Id', 'GP Practitioner Id')
;

-- Code scheme prefix entries
INSERT IGNORE INTO concept_property_data
(`dbid`, `group`, `property`, `value`)
SELECT c.dbid, 0 AS `group`, p.dbid AS `property`, 'IC_' AS `value`
FROM concept c
JOIN concept p ON p.id = 'code_prefix'
WHERE c.id = 'ImperialCerner';
