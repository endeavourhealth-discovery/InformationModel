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

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\nhs_datamigration\\Mapping Tables\\Updated\\Clinically Assured\\rcsctmap2_uk_20181031000001.txt'
    INTO TABLE read_v2_map
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (id, readCode, termCode, conceptId, @descriptionId, assured, effectiveDate, status)
SET descriptionId = nullif(@descriptionId, '');

DROP TABLE IF EXISTS read_v2_alt_map;
CREATE TABLE read_v2_alt_map (
    readCode VARCHAR(6) COLLATE utf8_bin NOT NULL,
    termCode VARCHAR(2) NOT NULL,
    conceptId BIGINT,
    descriptionId BIGINT,
    useAlt VARCHAR(1),
    PRIMARY KEY read_v2_alt_map_pk (readCode, termCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\SNOMED\\codesWithValues_AlternateMaps_READ2_20180401000001.txt'
    INTO TABLE read_v2_alt_map
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (readCode, termCode, @conceptId, @descriptionId, @use)
    SET conceptId = nullif(@conceptId, ''),
        descriptionId = nullif(@descriptionId, ''),
        useAlt = nullif(@use, '');
