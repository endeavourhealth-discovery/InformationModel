-- ********************* READ V2 CODES *********************

DROP TABLE IF EXISTS read_v2_desc;
CREATE TABLE read_v2_desc (
    code CHAR(5) COLLATE utf8_bin NOT NULL    COMMENT 'The READ code id',
    termid CHAR(5) COLLATE utf8_bin NOT NULL  COMMENT 'The term code',
    termtype CHAR(1) NOT NULL,
    children INT NOT NULL,
    multiple INT NOT NULL,
    qualifier INT NOT NULL,
    status CHAR(1) NOT NULL,
    type INT NOT NULL,
    level INT NOT NULL DEFAULT 0,

    PRIMARY KEY read_v2_code_pk (code, termid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'H:\\\ImportData\\READ\\DESC.csv'
INTO TABLE read_v2_desc
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- ********************* READ V2 TERMS *********************

DROP TABLE IF EXISTS read_v2_term;
CREATE TABLE read_v2_term (
    termid CHAR(5) COLLATE utf8_bin NOT NULL  COMMENT 'The term code',
    termstatus CHAR(1) NOT NULL,
    term30 VARCHAR(30),
    term60 VARCHAR(60),
    status CHAR(1) NOT NULL,
    type INT NOT NULL,
    level INT NOT NULL DEFAULT 0,

    PRIMARY KEY read_v2_term_pk (termid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'H:\\\ImportData\\READ\\Term.csv'
    INTO TABLE read_v2_term
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

-- ********************* READ V2 -> SNOMED MAP *********************

DROP TABLE IF EXISTS read_v2_map;
CREATE TABLE read_v2_map (
                             id VARCHAR(40) NOT NULL,
                             readCode VARCHAR(6) COLLATE utf8_bin NOT NULL,
                             termCode VARCHAR(2) NOT NULL,
                             conceptId BIGINT NOT NULL,
                             descriptionId BIGINT,
                             assured BOOLEAN NOT NULL,
                             effectiveDate VARCHAR(10) NOT NULL,
                             status BOOLEAN NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET GLOBAL local_infile=ON;

-- LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\nhs_datamigration\\Mapping Tables\\Updated\\Clinically Assured\\rcsctmap2_uk_20181031000001.txt'
LOAD DATA INFILE 'Z:\\ImportData\\TRUD\\MAPS\\2020-04-01\\Mapping Tables\\Updated\\Clinically Assured\\rcsctmap2_uk_20200401000001.txt'
    INTO TABLE read_v2_map
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (id, readCode, termCode, conceptId, @descriptionId, assured, effectiveDate, status)
    SET descriptionId = nullif(@descriptionId, '');

ALTER TABLE read_v2_map ADD INDEX read_v2_map_assured_idx (assured, status, termCode);

DROP TABLE IF EXISTS read_v2_alt_map;
CREATE TABLE read_v2_alt_map (
                                 readCode VARCHAR(6) COLLATE utf8_bin NOT NULL,
                                 termCode VARCHAR(2) NOT NULL,
                                 conceptId BIGINT,
                                 descriptionId BIGINT,
                                 useAlt VARCHAR(1),
                                 PRIMARY KEY read_v2_alt_map_pk (readCode, termCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET GLOBAL local_infile=ON;

-- LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\SNOMED\\codesWithValues_AlternateMaps_READ2_20180401000001.txt'
LOAD DATA INFILE 'Z:\\ImportData\\TRUD\\MAPS\\2020-04-01\\Mapping Tables\\Updated\\Clinically Assured\\codesWithValues_AlternateMaps_READ2_20200401000001.txt'
    INTO TABLE read_v2_alt_map
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (readCode, termCode, @conceptId, @descriptionId, @use)
    SET conceptId = nullif(@conceptId, ''),
        descriptionId = nullif(@descriptionId, ''),
        useAlt = nullif(@use, '');
