DROP TABLE IF EXISTS encounter_types;

CREATE TABLE encounter_types (
    id INTEGER NOT NULL,
    term VARCHAR(50) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\EncounterTypes.txt'
    INTO TABLE encounter_types
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

DROP TABLE IF EXISTS encounter_subtypes;
CREATE TABLE encounter_subtypes (
    id INTEGER NOT NULL,
    term VARCHAR(50) NOT NULL,
    targetId INTEGER NOT NULL,
    targetTerm VARCHAR(50) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\EncounterSubTypes.txt'
    INTO TABLE encounter_subtypes
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

DROP TABLE IF EXISTS encounter_maps;
CREATE TABLE encounter_maps (
    sourceTerm VARCHAR(150) COLLATE utf8_bin NOT NULL,
    count INTEGER NOT NULL,
    targetTerm VARCHAR(50) NOT NULL,
    supplier VARCHAR(10) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\EncounterMaps.txt'
    INTO TABLE encounter_maps
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

ALTER TABLE encounter_maps
ADD COLUMN targetId INTEGER NOT NULL DEFAULT 0;

UPDATE encounter_maps m
INNER JOIN encounter_types t ON t.term = m.targetTerm
SET targetId = t.id;

SELECT *
FROM encounter_maps m
WHERE NOT EXISTS (
    SELECT 1
    FROM encounter_types t
    WHERE t.term = m.targetTerm
)
