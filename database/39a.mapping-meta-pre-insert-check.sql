-- Concept existence check
SELECT DISTINCT m.provider, p.dbid, m.system, s.dbid
FROM map_context_meta m
         LEFT JOIN concept p ON p.id = m.provider
         LEFT JOIN concept s ON s.id = m.system
WHERE p.dbid IS NULL
   OR s.dbid IS NULL;

SELECT DISTINCT m.concept, c.dbid
FROM map_node_meta m
         LEFT JOIN concept c ON c.id = m.concept
WHERE c.dbid IS NULL;

SELECT DISTINCT m.scheme, s.dbid, m.concept, c.dbid
FROM map_node_value_meta m
         LEFT JOIN concept s ON s.id = m.scheme
         LEFT JOIN concept c ON c.id = m.concept
WHERE s.dbid IS NULL
   OR c.dbid IS NULL;

SELECT DISTINCT m.scheme, s.dbid, m.concept, c.dbid
FROM map_node_regex_meta m
         LEFT JOIN concept s ON s.id = m.scheme
         LEFT JOIN concept c ON c.id = m.concept
WHERE s.dbid IS NULL
   OR c.dbid IS NULL;
