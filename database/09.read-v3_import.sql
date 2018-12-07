DROP TABLE IF EXISTS read_v3_terms;
CREATE TABLE read_v3_terms (
    code    VARCHAR(7) NOT NULL COLLATE utf8_bin    COMMENT 'The CTV3 code',
    status  VARCHAR(2) NOT NULL                     COMMENT '(C)urrent/(R)edundant/(O)ptional/(E)xtinct',
    term_31 VARCHAR(31) NOT NULL                    COMMENT 'Term restricted to 31 characters',
    term_62 VARCHAR(62)                             COMMENT 'Term restricted to 62 characters',
    term VARCHAR(1024)                              COMMENT 'Full term text',
    PRIMARY KEY read_v3_terms_code_pk (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


LOAD DATA LOCAL INFILE 'C:\\read\\v3\\Terms.v3'
    INTO TABLE read_v3_terms
    FIELDS TERMINATED BY '|'
    LINES TERMINATED BY '\r\n'
    (code, status, term_31, @term_62, @term)
SET term_62 = nullif(@term_62, ''),
    term = nullif(@term, '');
