-- Validate meta data (these should return zero rows)
SELECT DISTINCT m.node, c.dbid, false
FROM map_node_meta m
         LEFT JOIN concept c ON c.id = m.concept
WHERE c.id IS NULL;

--

SELECT prv.dbid, sys.dbid, `schema`, `table`, `column`, n.id, false
FROM map_context_meta m
         JOIN map_node n ON n.node = m.node
         LEFT JOIN concept prv ON prv.id = m.provider
         LEFT JOIN concept sys ON sys.id = m.system
WHERE prv.id IS NULL
   OR sys.id IS NULL;

--

SELECT DISTINCT n.id, c.dbid, 'Regex()'
FROM map_node_regex_meta m
         JOIN map_node n ON n.node = m.node
         LEFT JOIN concept c ON c.id = m.scheme
WHERE c.id IS NULL;

--

SELECT DISTINCT n.id, c.dbid, 'Lookup()'
FROM map_node_value_meta m
         JOIN map_node n ON n.node = m.node
         LEFT JOIN concept c ON c.id = m.scheme
WHERE c.id IS NULL;

--

SELECT n.id, c.dbid, m.function
FROM map_function_value_meta m
         JOIN map_node n ON n.node = m.node
         LEFT JOIN concept c ON c.id = m.scheme
WHERE c.id IS NULL;

--

SELECT v.id, m.value, c.dbid, false
FROM map_node_value_meta m
         LEFT JOIN map_node n ON n.node = m.node
         LEFT JOIN map_value_node v ON v.node = n.id
         LEFT JOIN concept s ON s.dbid = v.code_scheme AND s.id = m.scheme
         LEFT JOIN concept c ON c.id = m.concept
WHERE n.node IS NULL
   OR v.node IS NULL
   OR s.id IS NULL
   OR c.id IS NULL;

--

SELECT v.id, m.value, m.regex, m.priority, c.dbid
FROM map_node_regex_meta m
         LEFT JOIN map_node n ON n.node = m.node
         LEFT JOIN map_value_node v ON v.node = n.id
         LEFT JOIN concept s ON s.dbid = v.code_scheme AND s.id = m.scheme
         LEFT JOIN concept c ON c.id = m.concept
WHERE n.node IS NULL
   OR v.node IS NULL
   OR s.id IS NULL
   OR c.id IS NULL;

--

SELECT l.value_node, l.value, COUNT(1)
FROM map_value_node_lookup l
GROUP BY l.value_node, l.value
HAVING COUNT(1) > 1;

/*
-- APPLY LOOKUP FIXES

INSERT IGNORE INTO map_value_node_lookup (value_node, value, concept, draft)
SELECT vn.id, m.value, c.dbid, false
FROM map_node_value_meta m
LEFT JOIN map_node n ON n.node = m.node
LEFT JOIN map_value_node vn ON vn.node = n.id
LEFT JOIN map_value_node_lookup l ON l.value_node = vn.id AND l.value = m.value
LEFT JOIN concept c ON c.id = m.concept
WHERE l.id IS NULL
 */
