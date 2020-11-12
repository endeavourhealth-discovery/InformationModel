-- Meta tables for clarity/simplicity
DROP TABLE IF EXISTS map_context_meta;
CREATE TABLE map_context_meta (
    provider    VARCHAR(150),
    `system`    VARCHAR(150),
    `schema`    VARCHAR(40),
    `table`     VARCHAR(40),
    `column`    VARCHAR(40),
    node        VARCHAR(200)
) ENGINE = Memory
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS map_node_meta;
CREATE TABLE map_node_meta(
    node    VARCHAR(200),
    concept VARCHAR(150)
) ENGINE = Memory
  DEFAULT CHARSET = utf8;

-- ******************** EMERGENCY ********************

-- Context maps
INSERT INTO map_context_meta
(provider, `system`, `schema`, `table`, `column`, node)
VALUES
('CM_Org_Imperial', 'CM_Sys_Cerner', 'HL7v2', 'A01', 'treatment_function_code',   '/IMPRL/CRNR/HL7V2/*/TRTMNT_FNCTN'),    -- NHS DD & Local
('CM_Org_Imperial', 'CM_Sys_Cerner', 'HL7v2', 'A02', 'treatment_function_code',   '/IMPRL/CRNR/HL7V2/*/TRTMNT_FNCTN'),    -- NHS DD & Local
('CM_Org_Imperial', 'CM_Sys_Cerner', 'HL7v2', 'A03', 'treatment_function_code',   '/IMPRL/CRNR/HL7V2/*/TRTMNT_FNCTN'),    -- NHS DD & Local
('CM_Org_Imperial', 'CM_Sys_Cerner', 'HL7v2', 'A08', 'treatment_function_code',   '/IMPRL/CRNR/HL7V2/*/TRTMNT_FNCTN'),    -- NHS DD & Local
('CM_Org_Imperial', 'CM_Sys_Cerner', 'HL7v2', 'A11', 'treatment_function_code',   '/IMPRL/CRNR/HL7V2/*/TRTMNT_FNCTN'),    -- NHS DD & Local
('CM_Org_Imperial', 'CM_Sys_Cerner', 'HL7v2', 'A12', 'treatment_function_code',   '/IMPRL/CRNR/HL7V2/*/TRTMNT_FNCTN'),    -- NHS DD & Local
('CM_Org_Imperial', 'CM_Sys_Cerner', 'HL7v2', 'A13', 'treatment_function_code',   '/IMPRL/CRNR/HL7V2/*/TRTMNT_FNCTN')     -- NHS DD & Local
;

-- Node maps
INSERT INTO map_node_meta
(node, concept)
VALUES
('/IMPRL/CRNR/HL7V2/*/TRTMNT_FNCTN',    'DM_treatmentFunctionAdmit')  -- NHS DD & Local
;

/* **************************************************************************************************** */

-- Populate real tables from meta (IM v1)
SELECT DISTINCT m.node, c.dbid, false
FROM map_node_meta m
LEFT JOIN concept c ON c.id = m.concept
WHERE c.id IS NULL;

INSERT INTO map_node
(node, concept, draft)
SELECT DISTINCT m.node, c.dbid, false
FROM map_node_meta m
JOIN concept c ON c.id = m.concept;

--

SELECT prv.dbid, sys.dbid, `schema`, `table`, `column`, n.id, false
FROM map_context_meta m
JOIN map_node n ON n.node = m.node
LEFT JOIN concept prv ON prv.id = m.provider
LEFT JOIN concept sys ON sys.id = m.system
WHERE prv.id IS NULL
OR sys.id IS NULL;

INSERT INTO map_context
(provider, `system`, `schema`, `table`, `column`, node, draft)
SELECT prv.dbid, sys.dbid, `schema`, `table`, `column`, n.id, false
FROM map_context_meta m
JOIN map_node n ON n.node = m.node
JOIN concept prv ON prv.id = m.provider
JOIN concept sys ON sys.id = m.system;

-- Clean up
DROP TABLE IF EXISTS map_context_meta;
DROP TABLE IF EXISTS map_node_meta;
