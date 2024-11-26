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
(1, 'DM_stillbornIndicator', @scm, 'DM_stillbornIndicator', 'Still born indicator', 'Still born indicator');

-- STILL BORN VALUE SET --  https://fhir.nhs.uk/STU3/CodeSystem/EMS-PDS-StillBornIndicator-1
-- Ensure FHIR_SBI scheme exists --
INSERT IGNORE INTO concept (document, id, scheme, code, name, description)
VALUES (1, 'FHIR_SBI', @scm, 'FHIR_SBI', 'Still Born Indicator', 'A CodeSystem to identify whether the baby was still born.');

-- Get scheme id
SELECT @scm := dbid FROM concept WHERE id = 'FHIR_SBI';

-- Code scheme prefix entries
INSERT IGNORE INTO concept_property_data
(`dbid`, `group`, `property`, `value`)
SELECT c.dbid, 0 AS `group`, p.dbid AS `property`, 'FHIR_SBI_' AS `value`
FROM concept c
         JOIN concept p ON p.id = 'code_prefix'
WHERE c.id = 'FHIR_SBI';

-- STILL BORN CONCEPTS --  https://fhir.nhs.uk/STU3/CodeSystem/EMS-PDS-StillBornIndicator-1
INSERT IGNORE INTO concept (document, id, scheme, code, name, description)
VALUES
    (1, 'FHIR_SBI_1', @scm, '1', 'Live', 'Live'),
    (1, 'FHIR_SBI_2', @scm, '2', 'Still birth, ante-partum', 'Still birth, ante-partum'),
    (1, 'FHIR_SBI_3', @scm, '3', 'Still birth, intra-partum', 'Still birth, intra-partum'),
    (1, 'FHIR_SBI_4', @scm, '4', 'Still birth, indeterminate', 'Still birth, indeterminate');


-- Context maps
INSERT INTO map_context_meta
(provider, `system`, `schema`, `table`, `column`, node)
VALUES
    ('CM_Org_NHS', 'CM_Sys_NEMS', 'FHIR', 'PDS', 'stillborn_indicator', '/NHS/NEMS/FHIR/PDS/STLLBRN_INDCTR');     -- Property only

-- Property
INSERT INTO map_node_meta
(node, concept)
VALUES
    ('/NHS/NEMS/FHIR/PDS/STLLBRN_INDCTR',    'DM_stillbornIndicator')   -- BARTS/CERNER code
;

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
    ('/NHS/NEMS/FHIR/PDS/STLLBRN_INDCTR', '1', 'FHIR_SBI', 'FHIR_SBI_1'),
    ('/NHS/NEMS/FHIR/PDS/STLLBRN_INDCTR', '2', 'FHIR_SBI', 'FHIR_SBI_2'),
    ('/NHS/NEMS/FHIR/PDS/STLLBRN_INDCTR', '3', 'FHIR_SBI', 'FHIR_SBI_3'),
    ('/NHS/NEMS/FHIR/PDS/STLLBRN_INDCTR', '4', 'FHIR_SBI', 'FHIR_SBI_4');


-- Legacy Core Maps
INSERT INTO map_legacy_core_meta
(legacy, core)
VALUES
    ('FHIR_SBI_1', 'SN_281050002'),         -- Live Birth
    ('FHIR_SBI_2', 'SN_713202001'),         -- Antepartum
    ('FHIR_SBI_3', 'SN_921611000000101'),   -- Intrapartum
    ('FHIR_SBI_4', 'SN_408796008');         -- Indeterminate

