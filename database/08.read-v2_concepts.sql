-- CONCEPTS

INSERT INTO concept
(superclass, full_name, context, status, version, last_update, code_scheme, code)
SELECT
    2, term, concat('READV2.',code), 1, 1.0, now(), 5302, code
FROM read_v2;

-- ATTRIBUTES

CREATE TABLE read_v2_hierarchy
SELECT r.code AS code, @code:=REPLACE(r.code,'.','') AS code_trimmed, @parent:=RPAD(SUBSTRING(@code, 1, LENGTH(@code)-1), 5, '.') AS parent
from read_v2 r;

INSERT INTO concept_attribute
(concept, attribute, value_concept, status)
SELECT c.id AS concept, 100 AS attribute, p.id AS value_concept, 1 AS status
FROM read_v2_hierarchy r
         JOIN concept c ON c.code = r.code AND c.code_scheme = 5302
         JOIN concept p ON p.code = r.parent AND p.code_scheme = 5302;