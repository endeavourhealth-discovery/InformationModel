-- Ensure core code scheme exists
INSERT IGNORE INTO concept (document, id, name, description)
VALUES (1, 'CM_DiscoveryCode', 'Discovery code', 'Discovery (core) coding scheme ');

-- Get scheme id
SELECT @scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';

-- Code scheme prefix entries

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
-- GENERAL/GLOBAL --
(1, 'CM_Org_Barts', @scm, 'CM_Org_Barts', 'Barts Hospital', 'Barts NHS Trust Hospital'),
(1, 'CM_Sys_Cerner', @scm, 'CM_Sys_Cerner', 'Cerner Millennium', 'Cerner Millennium system'),
(1, 'CM_PF4_Positive', @scm, 'CM_PF4_Positive', 'PF4 Positive', 'Platelet factor 4 assay positive'),
(1, 'CM_PF4_Negative', @scm, 'CM_PF4_Negative', 'PF4 Negative', 'Platelet factor 4 assay negative');


-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_Barts', 'CM_Sys_Cerner', null, null, 'vitt', '/BRTS/CRNR/VITT');

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/BRTS/CRNR/VITT', 'SN_103847006');   -- Platelet factor 4 assay (procedure)

-- Value maps
INSERT INTO map_node_regex_meta
(node, value, scheme, regex, concept)
VALUES
('/BRTS/CRNR/VITT', '316081992', 'BartsCerner', '^Positive(.*)', 'CM_PF4_Positive'),
('/BRTS/CRNR/VITT', '316081992', 'BartsCerner', '^Negative(.*)', 'CM_PF4_Negative'),
('/BRTS/CRNR/VITT', '316081942', 'BartsCerner', '^Positive$', 'CM_PF4_Positive'),
('/BRTS/CRNR/VITT', '316081942', 'BartsCerner', '^Negative$', 'CM_PF4_Negative');
