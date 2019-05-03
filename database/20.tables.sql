DROP TABLE IF EXISTS document;
CREATE TABLE document (
    dbid INT AUTO_INCREMENT         COMMENT 'Unique document DBID',
    iri VARCHAR(255)                COMMENT 'Document iri', -- GENERATED ALWAYS AS (`data` ->> '$.document') VIRTUAL NOT NULL,

    PRIMARY KEY document_dbid_pk (dbid),
    UNIQUE INDEX document_iri_uq (iri)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS concept;
CREATE TABLE concept (
    dbid INT AUTO_INCREMENT                     COMMENT 'Unique concept int DB identifier',
    document INT NOT NULL                       COMMENT 'Document this concept originated from',
    id VARCHAR(150) NOT NULL COLLATE utf8_bin   COMMENT 'Unique human-readable concept id',

    PRIMARY KEY concept_pk (dbid),
    UNIQUE KEY concept_id_uq (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS concept_property_object;
CREATE TABLE concept_property_object (
    dbid INT NOT NULL                       COMMENT 'Concept DBID',
    `group` INT NOT NULL DEFAULT 0          COMMENT 'Property group id',
    property INT NOT NULL                   COMMENT 'Property concept dbid',
    value INT NOT NULL                      COMMENT 'Property value concept dbid',

    INDEX concept_property_object_idx (dbid),
    INDEX concept_property_object_property_value (property, value)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS concept_property_data;
CREATE TABLE concept_property_data (
    dbid INT NOT NULL                       COMMENT 'Concept DBID',
    `group` INT NOT NULL DEFAULT 0          COMMENT 'Property group id',
    property INT NOT NULL                   COMMENT 'Property concept dbid',
    value VARCHAR(400) NOT NULL             COMMENT 'Property value data',

    INDEX concept_property_data_idx (dbid),
    INDEX concept_property_data_property_value (property, value)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS concept_property_info;
CREATE TABLE concept_property_info (
    dbid INT NOT NULL                       COMMENT 'Concept DBID',
    `group` INT NOT NULL DEFAULT 0          COMMENT 'Property group id',
    property INT NOT NULL                   COMMENT 'Property concept dbid',
    value VARCHAR(200) NOT NULL             COMMENT 'Property value data',

    INDEX concept_property_info_idx (dbid),
    INDEX concept_property_info_property_value (property, value)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS concept_tct;
CREATE TABLE concept_tct (
    dbid INT AUTO_INCREMENT,
    parent INT NOT NULL,
    property INT NOT NULL,
    level INT NOT NULL,
    child INT NOT NULL,

    PRIMARY KEY concept_tct_pk (dbid),
    KEY concept_tct_parent_property_idx (parent, property),
    KEY concept_tct_property_child_idx (property, child)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS concept_term_map;
CREATE TABLE concept_term_map (
    term VARCHAR(250) COLLATE utf8_bin NOT NULL,
    type INT NOT NULL,
    target INT NOT NULL,
    PRIMARY KEY concept_term_map_pk (term, type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DELIMITER //

DROP PROCEDURE IF EXISTS proc_build_tct//

-- EXAMPLE - Subtype hierarchy...
-- CALL proc_build_tct("is_subtype_of");

CREATE PROCEDURE proc_build_tct(property VARCHAR(150))
BEGIN
    SELECT @lvl := 0;

    SELECT @property_id := id
    FROM concept
    WHERE id = property;

    DELETE FROM concept_tct
    WHERE property = @property_id;

    INSERT INTO concept_tct
    (parent, property, level, child)
    SELECT p.dbid, property, @lvl, p.value
    FROM concept_property_object p
    WHERE p.property = @property_id;

    SELECT @inserted := ROW_COUNT();

    WHILE @inserted > 0 DO
        SELECT @lvl := @lvl + 1;
        SELECT 'Processing level ' + @lvl;

        INSERT INTO concept_tct
        (parent, property, level, child)
        SELECT s.parent, @property_id, @lvl AS level, t.child
        FROM concept_tct s
        JOIN concept_tct t on t.parent = s.child
        WHERE s.property = @property_id
        AND   t.property = @property_id
        AND   t.level = 0
        AND   s.level = @lvl - 1;

        SELECT @inserted := ROW_COUNT();
    END WHILE;
END; //

DROP FUNCTION IF EXISTS get_dbid//

CREATE FUNCTION get_dbid(concept_id VARCHAR(150)) RETURNS INTEGER
BEGIN
    DECLARE concept_dbid INTEGER DEFAULT NULL;
    SELECT dbid INTO concept_dbid
    FROM concept
    WHERE id = concept_id;

    IF (ISNULL(concept_dbid)) THEN
        SET @message = CONCAT('Concept not known [', concept_id, ']');
        SIGNAL SQLSTATE '42000' SET MESSAGE_TEXT = @message;
    ELSE
        RETURN concept_dbid;
    END IF;
END; //

DELIMITER ;

-- RESET concept TABLE AUTO NUMBER
PREPARE stmt FROM 'ALTER TABLE concept AUTO_INCREMENT = 1';
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
