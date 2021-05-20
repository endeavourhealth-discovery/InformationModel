-- Populate real tables from meta (IM v1)
SELECT DISTINCT m.node, c.dbid, false
FROM map_node_meta m
         LEFT JOIN concept c ON c.id = m.concept
WHERE c.id IS NULL;

INSERT IGNORE INTO map_node
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

--

SELECT DISTINCT n.id, c.dbid, 'Lookup()'
FROM map_node_value_meta m
         JOIN map_node n ON n.node = m.node
         LEFT JOIN concept c ON c.id = m.scheme
WHERE c.id IS NULL;

INSERT IGNORE INTO map_value_node
(node, code_scheme, function)
SELECT DISTINCT n.id, c.dbid, 'Lookup()'
FROM map_node_value_meta m
         JOIN map_node n ON n.node = m.node
         JOIN concept c ON c.id = m.scheme;

--

SELECT n.id, c.dbid, m.function
FROM map_function_value_meta m
         JOIN map_node n ON n.node = m.node
         LEFT JOIN concept c ON c.id = m.scheme
WHERE c.id IS NULL;

INSERT INTO map_value_node
(node, code_scheme, function)
SELECT n.id, c.dbid, m.function
FROM map_function_value_meta m
         JOIN map_node n ON n.node = m.node
         JOIN concept c ON c.id = m.scheme;

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

INSERT IGNORE INTO map_value_node_lookup
(value_node, value, concept, draft)
SELECT v.id, m.value, c.dbid, false
FROM map_node_value_meta m
         JOIN map_node n ON n.node = m.node
         JOIN map_value_node v ON v.node = n.id
         JOIN concept s ON s.dbid = v.code_scheme AND s.id = m.scheme
         JOIN concept c ON c.id = m.concept;

-- Clean up
DROP TABLE IF EXISTS map_context_meta;
DROP TABLE IF EXISTS map_node_meta;
DROP TABLE IF EXISTS map_node_value_meta;
DROP TABLE IF EXISTS map_function_value_meta;

