SELECT @max := MAX(dbid)+ 1 FROM concept;
SET @qry = concat('ALTER TABLE concept AUTO_INCREMENT = ', @max);
PREPARE stmt FROM @qry;

EXECUTE stmt;


DROP TABLE IF EXISTS read_v2_map;
CREATE TABLE read_v2_map (
    id VARCHAR(40) NOT NULL,
    readCode VARCHAR(6) COLLATE utf8_bin NOT NULL,
    termCode VARCHAR(2) NOT NULL,
    conceptId BIGINT NOT NULL,
    descriptionId BIGINT,
    assured BOOLEAN NOT NULL,
    effectiveDate VARCHAR(10) NOT NULL,
    status BOOLEAN NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\nhs_datamigration\\Mapping Tables\\Updated\\Clinically Assured\\rcsctmap2_uk_20181031000001.txt'
    INTO TABLE read_v2_map
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (id, readCode, termCode, conceptId, @descriptionId, assured, effectiveDate, status)
SET descriptionId = nullif(@descriptionId, '');

DROP TABLE IF EXISTS read_v2_alt_map;
CREATE TABLE read_v2_alt_map (
    readCode VARCHAR(6) COLLATE utf8_bin NOT NULL,
    termCode VARCHAR(2) NOT NULL,
    conceptId BIGINT,
    descriptionId BIGINT,
    useAlt VARCHAR(1),
    PRIMARY KEY read_v2_alt_map_pk (readCode, termCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\SNOMED\\codesWithValues_AlternateMaps_READ2_20180401000001.txt'
    INTO TABLE read_v2_alt_map
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (readCode, termCode, @conceptId, @descriptionId, @use)
    SET conceptId = nullif(@conceptId, ''),
        descriptionId = nullif(@descriptionId, ''),
        useAlt = nullif(@use, '');

-- Add 1:1 maps
UPDATE concept c
    INNER JOIN (
        SELECT r.readCode, r.conceptId
        FROM read_v2_map r
                 INNER JOIN (
            SELECT m.readCode, COUNT(DISTINCT c.id)
            FROM read_v2_map m
                     JOIN concept c ON c.id = CONCAT("SN_", m.conceptId)
            WHERE m.assured = 1
              AND m.status = 1
              AND termCode = '00'
            GROUP BY readCode
            HAVING COUNT(DISTINCT c.id) = 1
        ) t ON r.readCode = t.readCode
        WHERE r.assured = 1
          AND r.status = 1
          AND r.termCode = '00'
    ) t2 ON c.id = CONCAT('R2_', t2.readCode)
SET data = JSON_MERGE(data, JSON_OBJECT('is_equivalent_to', JSON_OBJECT('id', CONCAT('SN_', t2.conceptId))));

-- Add 1:n maps with alternative overrides
UPDATE concept c
    INNER JOIN (
        SELECT DISTINCT a.readCode, a.conceptId
        FROM read_v2_map r
                 JOIN read_v2_alt_map a ON a.readCode = r.readCode
                 INNER JOIN (
            SELECT m.readCode, COUNT(DISTINCT c.id)
            FROM read_v2_map m
                     JOIN concept c ON c.id = CONCAT("SN_", m.conceptId)
            WHERE m.assured = 1
              AND m.status = 1
              AND termCode = '00'
            GROUP BY readCode
            HAVING COUNT(DISTINCT c.id) > 1
        ) t ON r.readCode = t.readCode
        WHERE r.assured = 1
          AND r.status = 1
          AND r.termCode = '00'
          AND a.termCode = '00'
          AND a.conceptId IS NOT NULL
          AND a.useAlt = 'Y'
    ) t2 ON c.id = CONCAT('R2_', t2.readCode)
SET data = JSON_MERGE(data, JSON_OBJECT('is_equivalent_to', JSON_OBJECT('id', CONCAT('SN_', t2.conceptId))));

-- Create multi-map table
DROP TABLE IF EXISTS read_v2_multi_map;
CREATE TABLE read_v2_multi_map
SELECT DISTINCT r.readCode, r.conceptId
FROM read_v2_map r
JOIN concept c ON c.id = CONCAT('SN_', r.conceptId)
INNER JOIN (
    SELECT m.readCode, COUNT(DISTINCT c.id)
    FROM read_v2_map m
    JOIN concept c ON c.id = CONCAT("SN_", m.conceptId)
    WHERE m.assured = 1
      AND m.status = 1
      AND termCode = '00'
      AND NOT EXISTS (
            SELECT 1
            FROM read_v2_alt_map a
            WHERE a.readCode = m.readCode
              AND a.termCode = '00'
              AND a.conceptId IS NOT NULL
              AND a.useAlt = 'Y'
        )
    GROUP BY readCode
    HAVING COUNT(DISTINCT c.id) > 1
) t ON r.readCode = t.readCode
WHERE r.assured = 1
  AND r.status = 1
  AND r.termCode = '00';

-- Create Core codes (based on READ2 concepts/terms) with relation to multi-map snomed
EXECUTE stmt;

INSERT INTO concept
(data)
SELECT DISTINCT JSON_OBJECT(
               'document', 'http://DiscoveryDataService/InformationModel/dm/Discovery/1.0.0',
               'id', CONCAT('DS_R2_', m.readCode),
               'name', c.name,
               'description', c.description,
               'is_subtype_of', JSON_OBJECT(
                       'id', 'CodeableConcept'
                   ),
               'is_related_to', JSON_ARRAYAGG(JSON_OBJECT('id', CONCAT('SN_', m.conceptId)))
           ) AS data
FROM read_v2_multi_map m
JOIN concept c ON c.id = CONCAT('R2_', m.readCode)
GROUP BY m.readCode;

EXECUTE stmt;

-- Map read codes to new multi-mapped core concepts
UPDATE concept c
INNER JOIN (
        SELECT DISTINCT CONCAT('R2_', m.readCode) as readConcept, CONCAT('DS_R2_', m.readCode) as coreConcept
        FROM read_v2_multi_map m
    ) t ON t.readConcept = c.id
SET data = JSON_MERGE(data, JSON_OBJECT('is_equivalent_to', JSON_OBJECT('id', t.coreConcept)));

EXECUTE stmt;
DEALLOCATE PREPARE stmt;
