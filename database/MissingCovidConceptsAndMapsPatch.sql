SELECT @is_a := dbid, id, name FROM concept c WHERE id = 'SN_116680003';
SELECT @equiv := dbid, id, name FROM concept c WHERE id = 'is_equivalent_to';


-- SNOMED COVID CONCEPTS
DROP TABLE IF EXISTS snomed_covid;
CREATE TABLE snomed_covid (
                              snomed VARCHAR(40),
                              term VARCHAR(200),
                              parent VARCHAR(40)
) ENGINE = Memory;

INSERT INTO snomed_covid
(snomed, term)
VALUES
('1240581000000104','Severe acute respiratory syndrome coronavirus 2 ribonucleic acid detected (finding)'),
('1240591000000102','Severe acute respiratory syndrome coronavirus 2 ribonucleic acid not detected (finding)'),
('1321691000000102','SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) detection result unknown'),
('1321681000000104','SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) detection result equivocal');

INSERT IGNORE INTO concept
(document, id, name, description, scheme, code)
SELECT 3, CONCAT('SN_', snomed), term, term, 71, snomed
FROM snomed_covid;

DROP TABLE IF EXISTS snomed_covid;

-- EMIS COVID CONCEPTS
DROP TABLE IF EXISTS emis_local_covid;
CREATE TEMPORARY TABLE emis_local_covid (
                                            emis VARCHAR(40) COLLATE utf8_bin,
                                            term VARCHAR(200),
                                            snomed VARCHAR(40) COLLATE utf8_bin
) ENGINE = Memory;

INSERT INTO emis_local_covid
(emis, term, snomed)
VALUES
('^ESCT1299075','Wuhan 2019-nCoV (novel coronavirus) detected','1240581000000104'),
('^ESCT1299076','2019 novel coronavirus detected','1240581000000104'),
('^ESCT1299078','Wuhan 2019-nCoV (novel coronavirus) not detected','1240591000000102'),
('^ESCT1299079','2019 novel coronavirus not detected','1240591000000102'),
('^ESCT1301230','SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) detected','1240581000000104'),
('^ESCT1301231','SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) not detected','1240591000000102'),
('^ESCT1303285','SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) detection result equivocal','1321681000000104'),
('^ESCT1303286','2019-nCoV (novel coronavirus) detection result equivocal','1321681000000104'),
('^ESCT1303287','SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) detection result unknown','1321691000000102'),
('^ESCT1303288','2019-nCoV (novel coronavirus) detection result unknown','1321691000000102'),
('^ESCT1303928','SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) detection result positive','1240581000000104'),
('^ESCT1303929','SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) detection result negative','1240591000000102'),
('^ESCT1305235','SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) RNA (ribonucleic acid) detection result positive','1240581000000104'),
('^ESCT1305236','SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) RNA (ribonucleic acid) detection result negative','1240591000000102'),
('^ESCT1305239','SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) RNA (ribonucleic acid) detection result equivocal','1321681000000104'),
('^ESCT1305240','SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) RNA (ribonucleic acid) detection result unknown','1321691000000102')
;

INSERT IGNORE INTO concept
(document, id, name, description, scheme, code)
SELECT 13, CONCAT('EMLOC_', emis), term, term, 1335379, emis
FROM emis_local_covid;

INSERT IGNORE INTO concept_property_object
(dbid, property, value)
SELECT e.dbid, @equiv, s.dbid
FROM emis_local_covid l
         LEFT JOIN concept e ON e.id = CONCAT('EMLOC_', l.emis)
         LEFT JOIN concept s ON s.id = CONCAT('SN_', l.snomed)
WHERE NOT EXISTS (
        SELECT 1 FROM concept_property_object o
        WHERE o.dbid = e.dbid
          AND o.property = @equiv
          AND o.value = s.dbid
    );

DROP TABLE IF EXISTS emis_local_covid;

-- TPP COVID CONCEPTS
DROP TABLE IF EXISTS tpp_local_covid;
CREATE TEMPORARY TABLE tpp_local_covid (
                                           tpp VARCHAR(40) COLLATE utf8_bin,
                                           term VARCHAR(200),
                                           snomed VARCHAR(40) COLLATE utf8_bin
) ENGINE = Memory;

INSERT INTO tpp_local_covid
(tpp, term, snomed)
VALUES
('Y23f7','SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) detection result positive','1240581000000104'),
('Y23f4','SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) detection result negative','1240591000000102'),
('Y23f5','SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) RNA (ribonucleic acid) detection result equivocal','1321681000000104'),
('Y23f6','SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) RNA (ribonucleic acid) detection result unknown','1321691000000102');

INSERT IGNORE INTO concept
(document, id, name, description, scheme, code)
SELECT 15, CONCAT('TPPLOC_', tpp), term, term, 1440863, tpp
FROM tpp_local_covid;

INSERT IGNORE INTO concept_property_object
(dbid, property, value)
SELECT e.dbid, @equiv, s.dbid
FROM tpp_local_covid l
         LEFT JOIN concept e ON e.id = CONCAT('TPPLOC_', l.tpp)
         LEFT JOIN concept s ON s.id = CONCAT('SN_', l.snomed)
WHERE NOT EXISTS (
        SELECT 1 FROM concept_property_object o
        WHERE o.dbid = e.dbid
          AND o.property = @equiv
          AND o.value = s.dbid
    );

DROP TABLE IF EXISTS tpp_local_covid;


-- VISION COVID CONCEPTS
DROP TABLE IF EXISTS vis_local_covid;
CREATE TEMPORARY TABLE vis_local_covid (
                                           vis VARCHAR(40) COLLATE utf8_bin,
                                           term VARCHAR(200),
                                           snomed VARCHAR(40) COLLATE utf8_bin
) ENGINE = Memory;

INSERT INTO vis_local_covid
(vis, term, snomed)
VALUES
('4J3R4','SARS-CoV-2 RNA detect reslt unknown','1321691000000102');

INSERT IGNORE INTO concept
(document, id, name, description, scheme, code)
SELECT 16, CONCAT('VISLOC_', vis), term, term, 1476881, vis
FROM vis_local_covid;

INSERT IGNORE INTO concept_property_object
(dbid, property, value)
SELECT e.dbid, @equiv, s.dbid
FROM vis_local_covid l
         LEFT JOIN concept e ON e.id = CONCAT('VISLOC_', l.vis)
         LEFT JOIN concept s ON s.id = CONCAT('SN_', l.snomed)
WHERE NOT EXISTS (
        SELECT 1 FROM concept_property_object o
        WHERE o.dbid = e.dbid
          AND o.property = @equiv
          AND o.value = s.dbid
    );

DROP TABLE IF EXISTS vis_local_covid;
