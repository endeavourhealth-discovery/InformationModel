-- ********************* CONCEPT *********************

DROP TABLE IF EXISTS opcs4;
CREATE TABLE opcs4
(
    code             VARCHAR(10) NOT NULL,
    description      VARCHAR(150),

    PRIMARY KEY opcs4_pk (code)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\opcs4\\OPCS48 CodesAndTitles Nov 2016 V1.0.txt'
    INTO TABLE opcs4
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n';
