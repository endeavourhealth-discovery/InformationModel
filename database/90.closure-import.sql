USE `im_live`;

DROP TABLE IF EXISTS concept_tct_meta;
CREATE TABLE concept_tct_meta (
                               source VARCHAR(150) NOT NULL,
                               target VARCHAR(150) NOT NULL,
                               level INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\closure_v1.csv'
    INTO TABLE concept_tct_meta
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    (source, target, level)
;
/*

SELECT @isa := dbid FROM concept WHERE id = 'SN_116680003';

TRUNCATE TABLE concept_tct;
INSERT INTO concept_tct
(source, property, target, level)
SELECT s.dbid, @isa, t.dbid, m.level
FROM concept_tct_meta m
JOIN concept s ON s.id = m.source
JOIN concept t ON t.id = m.target;


DROP TABLE IF EXISTS concept_tct_meta;
*/
