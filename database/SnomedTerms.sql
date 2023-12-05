DROP TABLE IF EXISTS snomed_terms;

CREATE TABLE snomed_terms (
                              code VARCHAR(40) PRIMARY KEY COLLATE utf8_bin,
                              term VARCHAR(255)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\snomed_terms.tsvs'
INTO TABLE snomed_terms
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

show global variables like 'local_infile';

set global local_infile=true;

SHOW VARIABLES LIKE "secure_file_priv";
