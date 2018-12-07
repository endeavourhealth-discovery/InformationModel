INSERT INTO concept
(superclass, full_name, context, status, version, last_update, code_scheme, code)
SELECT
    2, term, concat('READV2.',code), 1, 1.0, now(), 5302, code
FROM read_v2;