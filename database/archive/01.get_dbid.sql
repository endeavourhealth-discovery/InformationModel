DROP FUNCTION IF EXISTS get_dbid;

DELIMITER //

CREATE FUNCTION get_dbid (concept_id VARCHAR(255))
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE result INT;

    SELECT dbid
    INTO result
    FROM im_live.concept
    WHERE id = concept_id
    LIMIT 1;

    RETURN result;
END//

DELIMITER ;
