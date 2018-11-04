DROP TABLE IF EXISTS read_v2;
CREATE TABLE read_v2 (
    code VARCHAR(6) COLLATE utf8_bin NOT NULL    COMMENT 'The READ code id',
    term VARCHAR(250) NOT NULL                   COMMENT 'The term',

    PRIMARY KEY read_v2_code_pk (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\read\\v2\\Unified\\Corev2.all'
INTO TABLE read_v2
FIELDS ENCLOSED BY '"' TERMINATED BY ','
LINES TERMINATED BY '\r\n'
(code, term);

DROP TABLE IF EXISTS read_v2_map;
CREATE TABLE read_v2_map (
    mapid VARCHAR(40) NOT NULL,
    code VARCHAR(6) COLLATE utf8_bin NOT NULL,
    termid VARCHAR(3) NOT NULL,
    sctid BIGINT NOT NULL,
    descid BIGINT,
    assured BOOLEAN NOT NULL,
    date INTEGER NOT NULL,
    status TINYINT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\read\\Mapping Tables\\Updated\\Clinically Assured\\rcsctmap2_uk_20181001000001.txt'
    INTO TABLE read_v2_map
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(mapid, code, termid, sctid, @dscid, assured, date, status)
SET descid = nullif(@dscid, '')
;

alter table read_v2_map
    add key active (termid, assured, status);
