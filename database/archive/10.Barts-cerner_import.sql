-- ********************* Barts/cerner maps *********************

DROP TABLE IF EXISTS barts_cerner;
CREATE TABLE barts_cerner
(
    count               INT NOT NULL,
    code                INT NOT NULL,
    term                VARCHAR(150),
    algorithm           VARCHAR(5),
    snomed_expression   VARCHAR(50),
    snomed_term         VARCHAR(250),
    author              VARCHAR(50),

    PRIMARY KEY barts_cerner_pk (code)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\Barts_Cerner_Procedures_Map.csv'
    INTO TABLE barts_cerner
    FIELDS ENCLOSED BY '"' TERMINATED BY ','
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (count, code, term, algorithm, @snomed_expression, @snomed_term, @author)
    SET snomed_expression = nullif(@snomed_expression, ''),
        snomed_term = nullif(@snomed_term, ''),
        author = nullif(@author, '');


UPDATE barts_cerner
SET snomed_expression = REPLACE(snomed_expression, '|:', ':')
WHERE snomed_expression LIKE '%|:%';

UPDATE barts_cerner
SET snomed_expression = REPLACE(snomed_expression, ':,', ':')
WHERE snomed_expression LIKE '%:,%';
