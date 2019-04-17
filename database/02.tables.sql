DROP TABLE IF EXISTS document;
CREATE TABLE document (
    dbid INT AUTO_INCREMENT         COMMENT 'Unique DBID generated by hashing the iri',
    data JSON NOT NULL              COMMENT 'Original JSON document content',
    iri VARCHAR(255)                GENERATED ALWAYS AS (`data` ->> '$.document') VIRTUAL NOT NULL,

    PRIMARY KEY document_dbid_pk (dbid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS concept;
CREATE TABLE concept (
    dbid INT AUTO_INCREMENT,
    data JSON NOT NULL,
    status TINYINT NOT NULL DEFAULT 0 COMMENT 'Status - 0 = Draft, 1 = Incomplete, 2 = Active, 3 = Deprecated',
    updated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    id VARCHAR(50) COLLATE utf8_bin   GENERATED ALWAYS AS (`data` ->> '$.id') STORED NOT NULL,
    document VARCHAR(250)             GENERATED ALWAYS AS (`data` ->> '$.document') VIRTUAL NOT NULL,
    name VARCHAR(255)                 GENERATED ALWAYS AS (`data` ->> '$.name') STORED NOT NULL,
    -- short_name VARCHAR(60)            GENERATED ALWAYS AS (`data` ->> '$.short_name') VIRTUAL,
    description VARCHAR(400)          GENERATED ALWAYS AS (`data` ->> '$.description') VIRTUAL,
    scheme VARCHAR(50)                GENERATED ALWAYS AS (`data` ->> '$.code_scheme') STORED,
    code VARCHAR(20) COLLATE utf8_bin GENERATED ALWAYS AS (`data` ->> '$.code') STORED,

    PRIMARY KEY concept_dbid_pk (dbid),
    UNIQUE KEY concept_id_uq (id),
    UNIQUE KEY concept_code_scheme (code, scheme),
    INDEX concept_updated_idx (updated),
    FULLTEXT concept_name_ftx (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS concept_tct;
CREATE TABLE concept_tct (
    dbid INT AUTO_INCREMENT,
    source INT NOT NULL,
    target INT NOT NULL,
    relationship INT NOT NULL,
    level INT NOT NULL,

    PRIMARY KEY concept_tct_dbid_pk (dbid),
    KEY concept_tct_source_relationship_idx (source, relationship),
    KEY concept_tct_target_relationship_idx (target, relationship)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS concept_term_map;
CREATE TABLE concept_term_map (
    dbid INT AUTO_INCREMENT,
    type INT NOT NULL,
    term VARCHAR(250) COLLATE utf8_bin NOT NULL,
    target INT NOT NULL,

    PRIMARY KEY concept_term_map_pk (dbid),
    UNIQUE KEY concept_term_map_type_term_idx (type, term)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DELIMITER //

DROP PROCEDURE IF EXISTS proc_build_tct//

-- EXAMPLE - Subtype hierarchy...
-- CALL proc_build_tct(887292, '$."is_subtype_of"."id"');

CREATE PROCEDURE proc_build_tct(rel_dbid INT, expression VARCHAR(100))
BEGIN
    SELECT @lvl := 0;

    SELECT @rel_id := id
    FROM concept
    WHERE dbid = rel_dbid;

    DELETE FROM concept_tct
        WHERE relationship = rel_dbid;

    INSERT INTO concept_tct
    (source, relationship, target, level)
    SELECT s.dbid, rel_dbid, t.dbid, @lvl
    FROM concept s
    JOIN concept t ON t.id = JSON_UNQUOTE(JSON_EXTRACT(s.data, expression));

    SELECT @inserted := ROW_COUNT();

    WHILE @inserted > 0 DO
        SELECT @lvl := @lvl + 1;
        SELECT 'Processing level ' + @lvl;

        INSERT INTO concept_tct
        (source, relationship, target, level)
        SELECT s.source, rel_dbid, t.target, @lvl AS level
        FROM concept_tct s
        JOIN concept_tct t on t.source = s.target
        WHERE s.relationship = rel_dbid
        AND   t.relationship = rel_dbid
        AND   t.level = 0
        AND   s.level = @lvl - 1;

        SELECT @inserted := ROW_COUNT();
    END WHILE;
END; //

DELIMITER ;


PREPARE stmt FROM 'ALTER TABLE concept AUTO_INCREMENT = 1';
EXECUTE stmt;

DEALLOCATE PREPARE stmt;
