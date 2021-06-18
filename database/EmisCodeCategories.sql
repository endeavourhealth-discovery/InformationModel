DROP TABLE IF EXISTS emis_code_category;
CREATE TABLE emis_code_category (
    code_id     BIGINT PRIMARY KEY,
    term        VARCHAR(500),
    read_code   VARCHAR(25) COLLATE utf8_bin,
    snomed_code BIGINT,
    snomed_desc BIGINT,
    nat_code    VARCHAR(25),
    nat_ctgry   VARCHAR(50),
    nat_desc    VARCHAR(250),
    category    VARCHAR(50),
    proc_id     INT,
    parent_code BIGINT,

    INDEX emis_code_category_cat_idx (category)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\EMISCodes.csv'
    INTO TABLE emis_code_category
    FIELDS OPTIONALLY ENCLOSED BY '"' TERMINATED BY ','
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (code_id, term, read_code, snomed_code, snomed_desc, nat_code, nat_ctgry, nat_desc, category, proc_id, @parent_code)
    SET parent_code = nullif(@parent_code, '');
