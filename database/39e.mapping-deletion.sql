-- DELETE CONTEXT
-- ***********************************************************
-- *                                                         *
-- *   NOTE: BE VERY CAREFUL TO HAVE THE CORRECT CONTEXT!!   *
-- *         RUN WITH SELECT BEFORE UNCOMMENTING DELETE!!!   *
-- *                                                         *
-- ***********************************************************

DELETE c
FROM map_context c
JOIN concept p ON p.dbid = c.provider AND p.id = 'CM_Org_THH'
JOIN concept s ON s.dbid = c.system AND s.id = 'CM_Sys_Silverlink';
-- WHERE c.schema = ''
-- AND c.table = ''
-- AND c.column = ''
;

-- DELETE ORPHAN REGEX

DELETE r
FROM map_node n
LEFT JOIN map_context c ON c.node = n.id
JOIN map_value_node v ON v.node = n.id AND v.function = 'Regex()'
JOIN map_value_node_regex r ON r.value_node = v.id
WHERE c.node IS NULL;

-- DELETE ORPHAN LOOKUP

DELETE l
FROM map_node n
LEFT JOIN map_context c ON c.node = n.id
JOIN map_value_node v ON v.node = n.id AND v.function = 'Lookup()'
JOIN map_value_node_lookup l ON l.value_node = v.id
WHERE c.node IS NULL;

-- DELETE ORPHAN VALUE NODE

DELETE v
FROM map_node n
LEFT JOIN map_context c ON c.node = n.id
JOIN map_value_node v ON v.node = n.id
WHERE c.node IS NULL;

-- DELETE ORPHAN NODE

DELETE n
FROM map_node n
LEFT JOIN map_context c ON c.node = n.id
WHERE c.node IS NULL;

