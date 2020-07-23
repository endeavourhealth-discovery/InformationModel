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
('CM_Org_BHRUT', 'CM_Sys_Medway', 'MedwayBI', 'PMI', 'CAUSEOFDEATH',            '/BHRUT/MDWY/MDWYBI/PMI/CS_DTH'),
('CM_Org_BHRUT', 'CM_Sys_Medway', 'MedwayBI', 'PMI', 'CAUSEOFDEATH 1B',         '/BHRUT/MDWY/MDWYBI/PMI/CS_DTH_1B'),
('CM_Org_BHRUT', 'CM_Sys_Medway', 'MedwayBI', 'PMI', 'CAUSEOFDEATH 1c',         '/BHRUT/MDWY/MDWYBI/PMI/CS_DTH_1C'),
('CM_Org_BHRUT', 'CM_Sys_Medway', 'MedwayBI', 'PMI', 'CAUSEOFDEATH 2',          '/BHRUT/MDWY/MDWYBI/PMI/CS_DTH_2'),
('CM_Org_BHRUT', 'CM_Sys_Medway', 'MedwayBI', 'PMI', 'INFECTION_STATUS',        '/BHRUT/MDWY/MDWYBI/PMI/INFCTN_STTS')
;

-- Node maps
INSERT INTO map_node_meta
(node, concept)
VALUES
('/BHRUT/MDWY/MDWYBI/PMI/CS_DTH',               ''),
('/BHRUT/MDWY/MDWYBI/PMI/CS_DTH_1B',            ''),
('/BHRUT/MDWY/MDWYBI/PMI/CS_DTH_1C',            ''),
('/BHRUT/MDWY/MDWYBI/PMI/CS_DTH_2',             ''),
('/BHRUT/MDWY/MDWYBI/PMI/INFCTN_STTS',          '')
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

