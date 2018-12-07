-- Create concepts
SET GLOBAL innodb_buffer_pool_size=512 * 1024 * 1024;

SELECT @@innodb_buffer_pool_size/1024/1024;

CREATE TABLE snomed_refset_clinical_active_preferred_component
SELECT referencedComponentId
FROM snomed_refset r
WHERE r.acceptabilityId = 900000000000548007
  AND r.refsetId = 999001261000000100
  AND r.active = 1;

ALTER TABLE snomed_refset_clinical_active_preferred_component ADD UNIQUE INDEX snomed_refset_clinical_active_preferred_component_pk (referencedComponentId);

CREATE TABLE snomed_description_active_fully_specified
SELECT id, conceptId, term
FROM snomed_description USE INDEX (snomed_description_active_typeId_idx)
WHERE active = 1
  AND typeId = 900000000000003001;

ALTER TABLE snomed_description_active_fully_specified ADD UNIQUE INDEX snomed_description_active_fully_specified_pk (id);

INSERT INTO concept
(superclass, short_name, full_name, context, status, version, last_update, code_scheme, code)
SELECT 2, '', f.term, concat('SNOMED.',f.conceptId), 1 as status, 1.0, now(), 5301, f.conceptId
FROM snomed_refset_clinical_active_preferred_component r
         JOIN snomed_description_active_fully_specified f ON f.id = r.referencedComponentId;

-- Create relationships
INSERT INTO concept_attribute
(concept, attribute, value_concept, status)
SELECT s.id, 100, t.id, r.active
FROM snomed_relationship r
JOIN concept s ON s.code = r.sourceId AND s.code_scheme = 5301
JOIN concept t ON t.code = r.destinationId AND t.code_scheme = 5301;
