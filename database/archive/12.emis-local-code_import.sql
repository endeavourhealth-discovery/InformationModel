DROP TABLE IF EXISTS emis_local_codes;
CREATE TABLE emis_local_codes (
    local_code   VARCHAR(20) NOT NULL COLLATE utf8_bin,
    local_term   VARCHAR(400),
    code_type    VARCHAR(50),

    PRIMARY KEY emis_local_codes_pk (local_code, local_term),
    INDEX emis_local_codes_code_idx (local_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\emis_local_codes.csv'
    INTO TABLE emis_local_codes
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;
