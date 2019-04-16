SELECT @max := MAX(dbid)+ 1 FROM concept;
SET @qry = concat('ALTER TABLE concept AUTO_INCREMENT = ', @max);
PREPARE stmt FROM @qry;

EXECUTE stmt;


DROP TABLE IF EXISTS read_v3_map;
CREATE TABLE read_v3_map (
    id VARCHAR(40) NOT NULL,
    ctv3Concept VARCHAR(6) COLLATE utf8_bin NOT NULL,
    ctv3Term VARCHAR(6) COLLATE utf8_bin NOT NULL,
    ctv3Type VARCHAR(1),
    conceptId BIGINT,
    descriptionId BIGINT,
    status BOOLEAN NOT NULL,
    effectiveDate VARCHAR(10) NOT NULL,
    assured BOOLEAN NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\nhs_datamigration\\Mapping Tables\\Updated\\Clinically Assured\\ctv3sctmap2_uk_20181031000001.txt'
    INTO TABLE read_v3_map
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (id, ctv3Concept, ctv3Term, @ctv3Type, @conceptId, @descriptionId, status, effectiveDate, assured)
SET ctv3Type = nullif(@ctv3Type, ''),
    conceptId = nullif(@conceptId, '_DRUG'),
    descriptionId = nullif(@descriptionId, '');

-- Create active preferred, assured summary map
DROP TABLE IF EXISTS read_v3_map_summary;
CREATE TABLE read_v3_map_summary
SELECT DISTINCT m.ctv3Concept, m.conceptId
FROM read_v3_map m
JOIN concept c ON c.id = CONCAT("SN_", m.conceptId)
WHERE m.status = 1
  AND m.assured = 1
  AND (m.ctv3Type = 'P' OR m.ctv3Type IS NULL)
;

DROP TABLE IF EXISTS read_v3_alt_map;
CREATE TABLE read_v3_alt_map (
    ctv3Concept VARCHAR(6) COLLATE utf8_bin NOT NULL,
    ctv3Term VARCHAR(6) COLLATE utf8_bin NOT NULL,
    conceptId BIGINT,
    descriptionId BIGINT,
    useAlt VARCHAR(1),
    PRIMARY KEY read_v3_alt_map_pk (ctv3Concept, ctv3Term)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\SNOMED\\codesWithValues_AlternateMaps_CTV3_20180401000001.txt'
    INTO TABLE read_v3_alt_map
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (ctv3Concept, ctv3Term, @conceptId, @descriptionId, @use)
    SET conceptId = nullif(@conceptId, ''),
        descriptionId = nullif(@descriptionId, ''),
        useAlt = nullif(@use, '');

-- Add 1:1 maps
UPDATE concept c
INNER JOIN (
	SELECT ctv3Concept, conceptId
	FROM read_v3_map_summary m
	JOIN concept c ON c.id = CONCAT("SN_", m.conceptId)
	GROUP BY ctv3Concept
	HAVING COUNT(DISTINCT c.id) = 1
) t ON c.id = CONCAT('R3_', t.ctv3Concept)
SET data = JSON_MERGE(data, JSON_OBJECT('is_equivalent_to', JSON_OBJECT('id', CONCAT('SN_', t.conceptId))));

-- Add 1:n maps with alternative overrides
UPDATE concept c
    INNER JOIN (
		SELECT s.ctv3Concept, s.conceptId
		FROM read_v3_map_summary s
		JOIN read_v3_alt_map a ON a.ctv3Concept = s.ctv3Concept AND a.conceptId = s.conceptId
		INNER JOIN (
			SELECT ctv3Concept
			FROM read_v3_map_summary m
			JOIN concept c ON c.id = CONCAT("SN_", m.conceptId)
			GROUP BY ctv3Concept
			HAVING COUNT(DISTINCT c.id) > 1
		) t ON t.ctv3Concept = s.ctv3Concept
		WHERE a.conceptId IS NOT NULL
		AND a.useAlt = 'Y'
    ) t2 ON c.id = CONCAT('R3_', t2.ctv3Concept)
SET data = JSON_MERGE(data, JSON_OBJECT('is_equivalent_to', JSON_OBJECT('id', CONCAT('SN_', t2.conceptId))));

-- Create multi-map table
DROP TABLE IF EXISTS read_v3_multi_map;
CREATE TABLE read_v3_multi_map
SELECT DISTINCT r.ctv3Concept, r.conceptId
FROM read_v3_map_summary r
INNER JOIN (
    SELECT m.ctv3Concept, COUNT(DISTINCT m.conceptId)
    FROM read_v3_map_summary m
    WHERE NOT EXISTS (
            SELECT 1
            FROM read_v3_alt_map a
            WHERE a.ctv3Concept = m.ctv3Concept
              AND a.conceptId IS NOT NULL
              AND a.useAlt = 'Y'
        )
    GROUP BY ctv3Concept
    HAVING COUNT(DISTINCT m.conceptId) > 1
) t ON r.ctv3Concept = t.ctv3Concept;


-- Create Core codes (based on READ3 concepts/terms) with relation to multi-map snomed
EXECUTE stmt;

INSERT INTO concept
(data)
SELECT DISTINCT JSON_OBJECT(
                        'document', 'http://DiscoveryDataService/InformationModel/dm/Discovery/1.0.0',
                        'id', CONCAT('DS_R3_', m.ctv3Concept),
                        'name', c.name,
                        'description', c.description,
                        'is_subtype_of', JSON_OBJECT(
                                'id', 'CodeableConcept'
                            ),
                        'is_related_to', JSON_ARRAYAGG(JSON_OBJECT('id', CONCAT('SN_', m.conceptId)))
                    ) AS data
FROM read_v3_multi_map m
JOIN concept c ON c.id = CONCAT('R3_', m.ctv3Concept)
GROUP BY m.ctv3Concept;

EXECUTE stmt;

-- Map read codes to new multi-mapped core concepts
UPDATE concept c
INNER JOIN (
        SELECT DISTINCT CONCAT('R3_', m.ctv3Concept) as ctv3Concept, CONCAT('DS_R3_', m.ctv3Concept) as coreConcept
        FROM read_v3_multi_map m
    ) t ON t.ctv3Concept = c.id
SET data = JSON_MERGE(data, JSON_OBJECT('is_equivalent_to', JSON_OBJECT('id', t.coreConcept)));

EXECUTE stmt;
DEALLOCATE PREPARE stmt;

