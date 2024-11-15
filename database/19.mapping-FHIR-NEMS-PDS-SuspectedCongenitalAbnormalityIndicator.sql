-- Ensure core code scheme exists
INSERT IGNORE INTO concept (document, id, name, description)
VALUES (1, 'CM_DiscoveryCode', 'Discovery code', 'Discovery (core) coding scheme ');

-- Get scheme id
SELECT @scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
-- GENERAL/GLOBAL --
(1, 'CM_Org_NHS', @scm, 'CM_Org_NHS', 'NHS', 'NHS'),
(1, 'CM_Sys_NEMS', @scm, 'CM_Sys_NEMS', 'NEMS', 'National Event Management System'),
(1, 'DM_suspectedCongenitalAbnormality', @scm, 'DM_suspectedCongenitalAbnormality', 'Suspected congenital abnormality indicator', 'Suspected congenital abnormality indicator');

-- SUSPECTED CONGENITAL ABNORMALITY VALUE SET --  https://fhir.nhs.uk/STU3/CodeSystem/EMS-PDS-SuspectedCongenitalAbnormalityIndicator-1
-- Ensure FHIR_SCAI scheme exists --
INSERT IGNORE INTO concept (document, id, scheme, code, name, description)
VALUES (1, 'FHIR_SCAI', @scm, 'FHIR_SCAI', 'Suspected congenital abnormality Indicator', 'A CodeSystem to indicate whether a congenital abnormality is suspected.');

-- Get scheme id
SELECT @scm := dbid FROM concept WHERE id = 'FHIR_SCAI';

-- Code scheme prefix entries
INSERT IGNORE INTO concept_property_data
(`dbid`, `group`, `property`, `value`)
SELECT c.dbid, 0 AS `group`, p.dbid AS `property`, 'FHIR_SCAI_' AS `value`
FROM concept c
         JOIN concept p ON p.id = 'code_prefix'
WHERE c.id = 'FHIR_SCAI';

-- STILL BORN CONCEPTS --  https://fhir.nhs.uk/STU3/CodeSystem/EMS-PDS-SuspectedCongenitalAbnormalityIndicator-1
INSERT IGNORE INTO concept (document, id, scheme, code, name, description)
VALUES
    (1, 'FHIR_SCAI_N', @scm, 'N', 'No', 'No'),
    (1, 'FHIR_SCAI_U', @scm, 'U', 'Uncertain - further review required', 'Uncertain - further review required'),
    (1, 'FHIR_SCAI_Y', @scm, 'Y', 'Yes', 'Yes');

-- Context maps
INSERT INTO map_context_meta
(provider, `system`, `schema`, `table`, `column`, node)
VALUES
    ('CM_Org_NHS', 'CM_Sys_NEMS', 'FHIR', 'PDS', 'suspected_congenital_abnormality', '/NHS/NEMS/FHIR/PDS/SSPCTD_CNGNTL_ABNRMLTY');     -- Property only

-- Property
INSERT INTO map_node_meta
(node, concept)
VALUES
    ('/NHS/NEMS/FHIR/PDS/SSPCTD_CNGNTL_ABNRMLTY',    'DM_suspectedCongenitalAbnormality')   -- BARTS/CERNER code
;

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
    ('/NHS/NEMS/FHIR/PDS/SSPCTD_CNGNTL_ABNRMLTY', 'N', 'FHIR_SCAI', 'FHIR_SCAI_N'),
    ('/NHS/NEMS/FHIR/PDS/SSPCTD_CNGNTL_ABNRMLTY', 'U', 'FHIR_SCAI', 'FHIR_SCAI_U'),
    ('/NHS/NEMS/FHIR/PDS/SSPCTD_CNGNTL_ABNRMLTY', 'Y', 'FHIR_SCAI', 'FHIR_SCAI_Y');
