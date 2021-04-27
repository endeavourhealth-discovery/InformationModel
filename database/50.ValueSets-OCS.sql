DROP TABLE IF EXISTS value_set_member;
DROP TABLE IF EXISTS value_set;

CREATE TABLE value_set (
                           dbid INT AUTO_INCREMENT,
                           id VARCHAR(50) NOT NULL,
                           name VARCHAR(150) NOT NULL,

                           PRIMARY KEY value_set_pk (dbid),
                           UNIQUE INDEX value_set_uq (id)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE value_set_member (
                                  dbid INT AUTO_INCREMENT,
                                  value_set INT NOT NULL,
                                  concept INT NOT NULL,

                                  PRIMARY KEY value_set_member_pk (dbid),
                                  UNIQUE INDEX value_set_member_value_set_uq (value_set, concept),

                                  FOREIGN KEY value_set_member_value_set_idx (value_set) REFERENCES concept (dbid)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

INSERT IGNORE INTO value_set (id, name) VALUES ('im:VSET_OCS', 'Oxford Covid Study value set');

SELECT @vset := dbid FROM value_set WHERE id = 'im:VSET_OCS';

-- Add SNOMED (and descendents)
SELECT @snomed := dbid FROM concept WHERE id = 'SNOMED';
SELECT @isa := dbid FROM concept WHERE id = 'SN_116680003';

INSERT IGNORE INTO value_set_member
(value_set, concept)
SELECT @vset, t.dbid
FROM concept c
         JOIN concept_tct tct ON tct.target = c.dbid AND tct.property = @isa
         JOIN concept t ON t.dbid = tct.source
WHERE c.scheme = @snomed
  AND c.code IN (
                 '404684003',
                 '272379006',
                 '363787002',
                 '71388002',
                 '243796009',
                 '123038009',
                 '48176007',
                 '254291000',
                 '373873005'
    );

-- Add ICD10
SELECT @icd10 := dbid FROM concept WHERE id = 'ICD10';

INSERT IGNORE INTO value_set_member
(value_set, concept)
SELECT @vset, c.dbid
FROM concept c
WHERE c.scheme = @icd10;

-- Add OPCS4
SELECT @opcs4 := dbid FROM concept WHERE id = 'OPCS4';

INSERT IGNORE INTO value_set_member
(value_set, concept)
SELECT @vset, c.dbid
FROM concept c
WHERE c.scheme = @opcs4;


-- Test - Included SNOMED
SELECT c.dbid
FROM concept c
         JOIN value_set_member m ON m.concept = c.dbid
         JOIN value_set v ON v.dbid = m.value_set
WHERE v.id = 'im:VSET_OCS'
  AND c.scheme = @snomed
  AND c.code = '123980006';

-- Test - Excluded SNOMED
SELECT c.dbid
FROM concept c
         JOIN value_set_member m ON m.concept = c.dbid
         JOIN value_set v ON v.dbid = m.value_set
WHERE v.id = 'im:VSET_OCS'
  AND c.scheme = @snomed
  AND c.code = '123037004';

-- Test - INCLUDED ICD10
SELECT c.dbid
FROM concept c
         JOIN value_set_member m ON m.concept = c.dbid
         JOIN value_set v ON v.dbid = m.value_set
WHERE v.id = 'im:VSET_OCS'
  AND c.scheme = @icd10
  AND c.code = 'A01.1';

-- Test - INCLUDED OPCS4
SELECT c.dbid
FROM concept c
         JOIN value_set_member m ON m.concept = c.dbid
         JOIN value_set v ON v.dbid = m.value_set
WHERE v.id = 'im:VSET_OCS'
  AND c.scheme = @opcs4
  AND c.code = 'A01.1';
