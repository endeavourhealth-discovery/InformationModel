DROP TABLE IF EXISTS read_v3;
CREATE TABLE read_v3 (
    code    VARCHAR(7) NOT NULL COLLATE utf8_bin    COMMENT 'The READ code id',
    status  VARCHAR(2) NOT NULL                     COMMENT '(C)urrent/(R)edundant/(O)ptional/(E)xtinct',
    role    VARCHAR(2) NOT NULL                     COMMENT '(A)ttribute/(N)on-attribute',
    subject VARCHAR(7) NOT NULL COLLATE utf8_bin    COMMENT 'Subject type',

    PRIMARY KEY read_v3_code_pk (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\read\\v3\\Concept.v3'
INTO TABLE read_v3
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(code, status, role, subject);