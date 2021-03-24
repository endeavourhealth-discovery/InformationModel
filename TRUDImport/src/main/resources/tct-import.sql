USE im_live_2021;

DROP TABLE IF EXISTS tct_new;

CREATE TABLE `tct_new` (
    `child` varchar(150) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
    `parent` varchar(150) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
    `level` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\closure_v1.csv'
    INTO TABLE tct_new
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    (child, parent, level)
;
