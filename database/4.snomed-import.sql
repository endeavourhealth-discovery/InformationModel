-- IMPORT CONCEPTS
INSERT INTO im2.concept
    (id, superclass, full_name, context, status)
SELECT id, 2 AS superclass, full_name, context, status
FROM im.concept
WHERE id > 1000000;

-- IMPORT SYNONYMS
INSERT INTO im2.concept_synonym
    (concept, term, status)
SELECT c.concept_id as concept, t.term, t.status
FROM im.code c
         JOIN im.code_term t ON t.code_id = c.code_id and t.system = c.system AND t.preferred = 0;

-- IMPORT RELATIONSHIPS
INSERT INTO im2.concept_relationship
    (source, relationship, target, status)
SELECT source, relationship, target, status
FROM im.concept_relationship
WHERE source > 1000000;

-- CODE MAPPING
INSERT INTO im2.mapping_code
    (scheme, code_id, concept)
SELECT 5301 as scheme, code_id, concept_id as concept
FROM im.code;

UPDATE table_id 
SET id = (SELECT MAX(id)+1 FROM concept)
WHERE name = 'Concept';
