DROP TABLE IF EXISTS concept_map_updater;

CREATE TABLE concept_map_updater (
    last_completed DATETIME NOT NULL,
    last_run DATETIME,
    rowcount INTEGER NOT NULL DEFAULT 1000,
    tables JSON
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

INSERT INTO concept_map_updater (last_completed, tables) VALUES (STR_TO_DATE('0001-01-01T00:00:00.000','%Y-%m-%dT%H:%i:%s.%f'), '["allergy_intolerance", "diagnostic_order", "encounter", "encounter_event", "medication_order", "medication_statement", "observation", "referral_request" ]');

DROP PROCEDURE IF EXISTS ApplyConceptMapChanges;

DELIMITER //

CREATE PROCEDURE ApplyConceptMapChanges()
BEGIN
    DECLARE i INT DEFAULT 0;

    -- Get run time
    SET @run_date = NOW();
    UPDATE concept_map_updater SET last_run = @run_date;

    -- Check concept_map index
    SET @x = (select count(*) from information_schema.statistics where table_name = 'concept_map' and index_name = 'concept_map_uq' and table_schema = database());
    SET @sql = if( @x > 0, 'select ''Index exists.''', 'ALTER TABLE `concept_map` ADD UNIQUE KEY `concept_map_uq` (`legacy`,`deleted`,`updated`);');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;

    -- Load config values
    SELECT  last_completed, rowcount, tables
    INTO @last_completed, @rowcount, @tables
    FROM concept_map_updater;

    -- Assume no changes
    SET @changes = 0;

    WHILE i < JSON_LENGTH(@tables) DO
        SET @tbl = JSON_UNQUOTE(JSON_EXTRACT(@tables, CONCAT('$[',i,']')));

        -- Update where core IS NULL and non-core is SNOMED or DISCOVERY
        SET @qry = CONCAT('UPDATE ', @tbl, ' x
        INNER JOIN (
            SELECT o.id
            FROM ', @tbl, ' o
            JOIN concept c ON c.dbid = o.non_core_concept_id
            JOIN concept s ON s.dbid = c.scheme
            WHERE o.core_concept_id IS NULL
            AND s.id IN (''CM_DiscoveryCode'', ''SNOMED'')
            LIMIT ', @rowcount, '
        ) t ON x.id = t.id
        SET x.core_concept_id = x.non_core_concept_id');

        PREPARE stmt FROM @qry;
        EXECUTE stmt;

        SET @changes = @changes + ROW_COUNT();

        -- Update where non-core --> core map has changed
        SET @qry = CONCAT('UPDATE ', @tbl, ' x
        INNER JOIN concept_map m ON m.legacy = x.non_core_concept_id AND m.deleted = 0
        INNER JOIN (
            SELECT o.id
            FROM concept_map m
            INNER JOIN ', @tbl, ' o ON o.non_core_concept_id = m.legacy AND o.core_concept_id <> m.core
            WHERE m.deleted = 0
            AND m.updated > "', @last_completed, '"
            LIMIT ', @rowcount, '
        ) t ON x.id = t.id
        SET x.core_concept_id = m.core');

        PREPARE stmt FROM @qry;
        EXECUTE stmt;

        SET @changes = @changes + ROW_COUNT();

        SET i = i + 1;
    END WHILE;

    -- If no changes were made on any tables, mark as complete
    IF (@changes = 0) THEN
        UPDATE concept_map_updater SET last_completed = @run_date;
    ELSE
        SELECT CONCAT('Updated ', @changes, ' rows');
    END IF;

END //

DELIMITER ;

/*
DROP EVENT IF EXISTS run_concept_map_updater;

CREATE EVENT run_concept_map_updater
	ON SCHEDULE EVERY 1 MINUTE
    ON COMPLETION PRESERVE
    DO CALL ApplyConceptMapChanges();

CALL ApplyConceptMapChanges();

SHOW VARIABLES WHERE VARIABLE_NAME = 'event_scheduler';

SET GLOBAL event_scheduler = ON;

SELECT * FROM concept_map_updater;
*/
