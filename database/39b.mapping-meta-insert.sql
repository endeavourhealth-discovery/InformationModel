-- Populate real tables from meta (IM v1)

INSERT IGNORE INTO map_node
(node, concept, draft)
SELECT DISTINCT m.node, c.dbid, false
FROM map_node_meta m
         JOIN concept c ON c.id = m.concept;

--

INSERT IGNORE INTO map_context
(provider, `system`, `schema`, `table`, `column`, node, draft)
SELECT prv.dbid, sys.dbid, `schema`, `table`, `column`, n.id, false
FROM map_context_meta m
         JOIN map_node n ON n.node = m.node
         JOIN concept prv ON prv.id = m.provider
         JOIN concept sys ON sys.id = m.system;

--

INSERT IGNORE INTO map_value_node
(node, code_scheme, `function`)
SELECT DISTINCT n.id, c.dbid, 'Regex()'
FROM map_node_regex_meta m
         JOIN map_node n ON n.node = m.node
         JOIN concept c ON c.id = m.scheme;

--

INSERT IGNORE INTO map_value_node
(node, code_scheme, `function`)
SELECT DISTINCT n.id, c.dbid, 'Lookup()'
FROM map_node_value_meta m
         JOIN map_node n ON n.node = m.node
         JOIN concept c ON c.id = m.scheme;

--

REPLACE INTO map_value_node
(node, code_scheme, `function`)
SELECT n.id, c.dbid, m.function
FROM map_function_value_meta m
         JOIN map_node n ON n.node = m.node
         JOIN concept c ON c.id = m.scheme;

--


REPLACE INTO map_value_node_lookup
(value_node, value, concept, draft)
SELECT v.id, m.value, c.dbid, false
FROM map_node_value_meta m
         JOIN map_node n ON n.node = m.node
         JOIN map_value_node v ON v.node = n.id
         JOIN concept s ON s.dbid = v.code_scheme AND s.id = m.scheme
         JOIN concept c ON c.id = m.concept;

--

REPLACE INTO map_value_node_regex
(value_node, value, regex, priority, concept)
SELECT v.id, m.value, m.regex, m.priority, c.dbid
FROM map_node_regex_meta m
         JOIN map_node n ON n.node = m.node
         JOIN map_value_node v ON v.node = n.id
         JOIN concept s ON s.dbid = v.code_scheme AND s.id = m.scheme
         JOIN concept c ON c.id = m.concept;

--

REPLACE INTO concept_property_object
(dbid, property, value)
SELECT DISTINCT l.dbid, p.dbid, c.dbid
FROM map_legacy_core_meta m
         JOIN concept l ON l.id = m.legacy
         JOIN concept p ON p.id = 'is_equivalent_to'
         JOIN concept c ON c.id = m.core;


REPLACE INTO concept_map
(legacy, core)
SELECT DISTINCT l.dbid, c.dbid
FROM map_legacy_core_meta m
         JOIN concept l ON l.id = m.legacy
         JOIN concept c ON c.id = m.core;
