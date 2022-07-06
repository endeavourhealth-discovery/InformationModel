
-- ******************** Religion ********************
-- Concepts
SELECT @scm := dbid FROM concept WHERE id = 'LNWHSilverlink';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
(1, 'LNWH_SL_Rlgn_CHAP', @scm, 'LNWH_SL_Rlgn_CHAP', 'Chapel', 'Chapel'),
(1, 'LNWH_SL_Rlgn_EPIS', @scm, 'LNWH_SL_Rlgn_EPIS', 'Episcopal', 'Episcopal'),
(1, 'LNWH_SL_Rlgn_MAPU', @scm, 'LNWH_SL_Rlgn_MAPU', 'Mapuche', 'Mapuche'),
(1, 'LNWH_SL_Rlgn_MOON', @scm, 'LNWH_SL_Rlgn_MOON', 'Moonies', 'Moonies'),
(1, 'LNWH_SL_Rlgn_NAPC', @scm, 'LNWH_SL_Rlgn_NAPC', 'New Apostolic Church', 'New Apostolic Church'),
(1, 'LNWH_SL_Rlgn_NDEN', @scm, 'LNWH_SL_Rlgn_NDEN', 'Non Denominational', 'Non Denominational'),
(1, 'LNWH_SL_Rlgn_OCR', @scm, 'LNWH_SL_Rlgn_OCR', 'Order of the Cross', 'Order of the Cross'),
(1, 'LNWH_SL_Rlgn_PO', @scm, 'LNWH_SL_Rlgn_PO', 'Polish Orthodox', 'Polish Orthodox'),
(1, 'LNWH_SL_Rlgn_SHI', @scm, 'LNWH_SL_Rlgn_SHI', 'Shilo', 'Shilo'),
(1, 'LNWH_SL_Rlgn_WES', @scm, 'LNWH_SL_Rlgn_WES', 'Wesleyan', 'Wesleyan'),
(1, 'LNWH_SL_Rlgn_WI', @scm, 'LNWH_SL_Rlgn_WI', 'Welsh Independent', 'Welsh Independent'),
(1, 'LNWH_SL_Rlgn_WWI', @scm, 'LNWH_SL_Rlgn_WWI', 'White Witch', 'White Witch'),
(1, 'LNWH_SL_Rlgn_ZION', @scm, 'LNWH_SL_Rlgn_ZION', 'Zionist', 'Zionist');

-- Context
INSERT INTO map_context_meta (provider, `system`, `schema`, `table`, `column`, node)
VALUES ('CM_Org_LNWH', 'CM_Sys_Silverlink', null, null, 'religion', '/LNWH/SLVRLNK/RLGN');    -- Local

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/LNWH/SLVRLNK/RLGN', 'DM_religion');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/LNWH/SLVRLNK/RLGN', 'ISLM', 'LNWHSilverlink', 'CM_ReligionG1'),
('/LNWH/SLVRLNK/RLGN', 'CHAP', 'LNWHSilverlink', 'LNWH_SL_Rlgn_CHAP'),
('/LNWH/SLVRLNK/RLGN', 'EPIS', 'LNWHSilverlink', 'LNWH_SL_Rlgn_EPIS'),
('/LNWH/SLVRLNK/RLGN', 'MAPU', 'LNWHSilverlink', 'LNWH_SL_Rlgn_MAPU'),
('/LNWH/SLVRLNK/RLGN', 'MOON', 'LNWHSilverlink', 'LNWH_SL_Rlgn_MOON'),
('/LNWH/SLVRLNK/RLGN', 'NAPC', 'LNWHSilverlink', 'LNWH_SL_Rlgn_NAPC'),
('/LNWH/SLVRLNK/RLGN', 'NDEN', 'LNWHSilverlink', 'LNWH_SL_Rlgn_NDEN'),
('/LNWH/SLVRLNK/RLGN', 'O-CR', 'LNWHSilverlink', 'LNWH_SL_Rlgn_OCR'),
('/LNWH/SLVRLNK/RLGN', 'P/O', 'LNWHSilverlink', 'LNWH_SL_Rlgn_PO'),
('/LNWH/SLVRLNK/RLGN', 'SHI', 'LNWHSilverlink', 'LNWH_SL_Rlgn_SHI'),
('/LNWH/SLVRLNK/RLGN', 'WES', 'LNWHSilverlink', 'LNWH_SL_Rlgn_WES'),
('/LNWH/SLVRLNK/RLGN', 'WI', 'LNWHSilverlink', 'LNWH_SL_Rlgn_WI'),
('/LNWH/SLVRLNK/RLGN', 'W-WI', 'LNWHSilverlink', 'LNWH_SL_Rlgn_WWI'),
('/LNWH/SLVRLNK/RLGN', 'ZION', 'LNWHSilverlink', 'LNWH_SL_Rlgn_ZION');

-- Unitarian fix
UPDATE map_node n
    JOIN map_value_node v ON v.node = n.id
    JOIN map_value_node_lookup l ON l.value_node = v.id
    JOIN concept c ON c.id = 'CM_ReligionC78'
    SET l.concept = c.dbid
WHERE n.node = '/LNWH/SLVRLNK/RLGN'
  AND l.value = 'UN';
