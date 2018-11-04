INSERT INTO im2.mapping_code
    (scheme, code_id, concept)
SELECT 5302 as scheme, code, concept FROM
(
    SELECT r.code, c.concept_id as concept, max(r.date)
    FROM read_v2_map r
           JOIN im.code c on c.system = 1 and c.code_id = r.sctid
    WHERE r.termid = '00'
    AND r.assured = 1
    AND r.status = 1
    GROUP BY r.code
) AS x;
