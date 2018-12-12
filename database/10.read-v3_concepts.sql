/*
SELECT c.code, ifnull(t.term_62, t.term_31) as term, ifnull(y.term_62, y.term_31) as caegory
FROM read_v3_concept c
JOIN read_v3_desc d ON d.code = c.code AND d.type = 'P'
JOIN read_v3_terms t ON t.termId = d.termId AND t.status = 'C'
JOIN read_v3_desc yd ON yd.code = c.categoryId AND yd.type = 'P'
JOIN read_v3_terms y ON y.termId = yd.termId AND y.status = 'C'
WHERE c.status = 'C';
 */

INSERT INTO concept
(superclass, short_name, full_name, description, context, status, version, last_update, code_scheme, code)
SELECT
    2, term_31, ifnull(term_62, term_31), term, concat('CTV3.',c.code), 1, 1.0, now(), 5303, c.code
FROM read_v3_concept c
         JOIN read_v3_desc d ON d.code = c.code AND d.type = 'P'
         JOIN read_v3_terms t ON t.termId = d.termId AND t.status = 'C'
WHERE c.status = 'C';


INSERT INTO concept_attribute
(concept, attribute, value_concept, status)
SELECT c.id AS concept, 100 AS attribute, p.id AS value_concept, 1 AS status
FROM read_v3_hier r
         JOIN concept c ON c.code = r.code AND c.code_scheme = 5303
         JOIN concept p ON p.code = r.parent AND p.code_scheme = 5303;