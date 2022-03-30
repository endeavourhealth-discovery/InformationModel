DROP TABLE IF EXISTS concept_map_updater;

CREATE TABLE concept_map_updater (
    last_completed DATETIME NOT NULL,
    last_run DATETIME,
    rowcount INTEGER NOT NULL DEFAULT 1000,
    tables JSON
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

INSERT INTO concept_map_updater (last_completed, tables) VALUES ('00/00/0000 00:00:00', '["allergy_intolerance", "diagnostic_order", "encounter", "encounter_event", "medication_order", "medication_statement", "observation", "referral_request" ]');

DROP PROCEDURE IF EXISTS ApplyConceptMapChanges;

DELIMITER //

CREATE PROCEDURE ApplyConceptMapChanges()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE changes BOOL DEFAULT false;

    -- Get run time
    SELECT @run_date := NOW();
    UPDATE concept_map_updater SET last_run = @run_date;

    -- Load config values
    SELECT  @last_completed := last_completed,
            @rowcount := rowcount,
            @tables := tables
    FROM concept_map_updater;

    -- Check if there's anything to do
    SELECT @changes := COUNT(1) FROM concept_map WHERE updated > @last_completed LIMIT 1;

    IF (@changes = 0) THEN
        SELECT 'Nothing to do';
    ELSE
        WHILE i < JSON_LENGTH(@tables) DO
            SELECT @tbl := JSON_UNQUOTE(JSON_EXTRACT(@tables, CONCAT('$[',i,']')));

            SET @qry = CONCAT('UPDATE ', @tbl, ' x
                JOIN concept_map m ON m.legacy = x.non_core_concept_id
                SET x.core_concept_id = m.core
                WHERE id IN (
                    SELECT id FROM (
                        SELECT o.id
                        FROM concept_map m
                        JOIN ', @tbl , ' o ON o.non_core_concept_id = m.legacy AND o.core_concept_id <> m.core
                        WHERE m.updated > "', @last_completed, '"
                        LIMIT ', @rowcount, '
                    ) tmp
                );');

            PREPARE stmt FROM @qry;
            EXECUTE stmt;

            SELECT @changes := ROW_COUNT();

            IF (@changes > 0) THEN
                SELECT CONCAT('Rows changed on ', @tbl);
                SELECT @changes := true;
            END IF;

            SELECT i + 1 INTO i;
        END WHILE;

        -- If no changes were made on any tables, mark as complete
        IF (@changes = false) THEN
            UPDATE concept_map_updater SET last_completed = @run_date;
        END IF;
    END IF;
END //

DELIMITER ;

/*
DROP EVENT IF EXISTS run_concept_map_updater;

CREATE EVENT run_concept_map_updater
	ON SCHEDULE EVERY 5 SECOND
    ON COMPLETION PRESERVE
    DO CALL ApplyConceptMapChanges();

*/
