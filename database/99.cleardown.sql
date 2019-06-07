-- DO NOT CLEAR DOCUMENTS TABLE (RESET VERSION TO ZERO INSTEAD)!
-- DELETE FROM document;
UPDATE document SET version = '0.0.0';

-- DO NOT CLEAR CONCEPTS TABLE!
-- DELETE FROM concept;

TRUNCATE TABLE concept_property_data;
TRUNCATE TABLE concept_property_info;
TRUNCATE TABLE concept_property_object;
TRUNCATE TABLE concept_tct;
TRUNCATE TABLE concept_term_map;
