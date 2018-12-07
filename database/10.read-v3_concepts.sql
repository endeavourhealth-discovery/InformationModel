INSERT INTO concept
(superclass, short_name, full_name, description, context, status, version, last_update, code_scheme, code)
SELECT
    2, term_31, ifnull(term_62, term_31), term, concat('CTV3.',code), 1, 1.0, now(), 5303, code
FROM read_v3_terms;