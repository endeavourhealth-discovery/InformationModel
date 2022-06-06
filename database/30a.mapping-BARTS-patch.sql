SELECT @scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
-- GENERAL/GLOBAL --
(1, 'DM_ambulanceNumber', @scm, 'DM_ambulanceNumber', 'Ambulance number', 'Ambulance number');

-- Context maps
INSERT INTO map_context_meta
(provider, `system`, `schema`, `table`, `column`, node)
VALUES
    ('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'ambulance_number',         '/BRTS/CRNR/CDS/EMGCY/AMBLNC_NMBR');           -- Property only

-- Node maps
INSERT INTO map_node_meta
(node, concept)
VALUES
    ('/BRTS/CRNR/CDS/EMGCY/AMBLNC_NMBR',    'DM_ambulanceNumber')
;
