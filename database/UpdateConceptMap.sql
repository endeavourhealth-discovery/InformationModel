/*
ALTER TABLE concept_map DROP PRIMARY KEY;
ALTER TABLE concept_map ADD id INT AUTO_INCREMENT PRIMARY KEY;
ALTER TABLE concept_map ADD deleted BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE concept_map ADD UNIQUE INDEX concept_map_uq (legacy, deleted, updated);
ALTER TABLE concept_map MODIFY COLUMN `updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS update_concept_map;
CREATE PROCEDURE update_concept_map()
BEGIN
    -- Build latest map table
    DROP TABLE IF EXISTS tmp_concept_map;
    CREATE TEMPORARY TABLE tmp_concept_map (
        legacy INT NOT NULL,
        core INT NOT NULL,

        PRIMARY KEY tmp_concept_map_pk (legacy)
    );

    INSERT INTO tmp_concept_map
    (legacy, core)
    SELECT cpo.dbid, cpo.value
    FROM concept_property_object cpo
             JOIN concept c ON c.dbid = cpo.property
    WHERE c.id = 'is_equivalent_to';

    -- Delete (mark) old maps
    UPDATE concept_map m
        LEFT JOIN tmp_concept_map t ON t.legacy = m.legacy AND t.core = m.core
    SET deleted = true
    WHERE t.legacy IS NULL;

    -- Add new maps
    INSERT INTO concept_map
    (legacy, core)
    SELECT t.legacy, t.core
    FROM tmp_concept_map t
             LEFT JOIN concept_map m ON m.legacy = t.legacy AND m.core = t.core
    WHERE m.legacy IS NULL;

    DROP TABLE IF EXISTS tmp_concept_map;
END$$
DELIMITER ;

-- CALL update_concept_map();
