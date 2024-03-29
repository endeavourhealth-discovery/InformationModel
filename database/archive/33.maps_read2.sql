DROP TABLE IF EXISTS read_v2_map_tmp;
CREATE TABLE read_v2_map_tmp (
    readCode VARCHAR(6) COLLATE utf8_bin NOT NULL,
    conceptId BIGINT NOT NULL,
    INDEX read_v2_map_tmp_idx (readCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO read_v2_map_tmp
(readCode, conceptId)
SELECT DISTINCT m.readCode, m.conceptId
FROM read_v2_map m
JOIN concept c ON c.id = CONCAT('SN_', m.conceptId)
WHERE m.assured = 1
  AND m.status = 1
  AND m.termCode = '00';

-- Populate summary
DROP TABLE IF EXISTS read_v2_map_summary;
CREATE TABLE read_v2_map_summary (
    readCode VARCHAR(6) COLLATE utf8_bin NOT NULL,
    multi BOOLEAN DEFAULT FALSE,
    altConceptId BIGINT DEFAULT NULL,
    PRIMARY KEY read_v2_map_summary_pk (readCode),
    INDEX read_v2_map_summary_multi_idx (multi)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO read_v2_map_summary
(readCode, multi, altConceptId)
SELECT t.readCode, COUNT(t.readCode) > 1 as multi, IF(c.dbid is null, null, a.conceptId) as conceptId
FROM read_v2_map_tmp t
LEFT JOIN read_v2_alt_map a ON a.readCode = t.readCode AND a.termCode = '00' AND a.conceptId IS NOT NULL AND a.useAlt = 'Y'
LEFT JOIN concept c ON c.id = CONCAT('SN_', a.conceptId)
GROUP BY t.readCode;

-- Add 1:1 maps
SET @prop = get_dbid('is_equivalent_to');

INSERT INTO concept_property_object_new
(dbid, property, value)
SELECT c.dbid, @prop, v.dbid
FROM read_v2_map_summary s
JOIN read_v2_map_tmp t ON t.readCode = s.readCode
JOIN concept c ON c.id = CONCAT('R2_', s.readCode)
JOIN concept v ON v.id = CONCAT('SN_', t.conceptId)
WHERE s.multi = FALSE;

-- Add 1:n maps with alternative overrides
INSERT INTO concept_property_object_new
(dbid, property, value)
SELECT c.dbid, @prop, v.dbid
FROM read_v2_map_summary s
JOIN concept c ON c.id = CONCAT('R2_', s.readCode)
JOIN concept v ON v.id = CONCAT('SN_', s.altConceptId)
WHERE s.multi = TRUE
AND s.altConceptID IS NOT NULL;

-- Add 1:n maps with no alternative override

-- Create proxy document
INSERT INTO document
(iri)
VALUES
('http://DiscoveryDataService/InformationModel/dm/R2-proxy/1.0.1');

SELECT @doc := 1;

-- Create proxy concepts
INSERT INTO concept
(document, id)
SELECT @doc, CONCAT('MISSING_DS_R2_', s.readCode)
FROM read_v2_map_summary s
WHERE s.multi = TRUE
  AND s.altConceptId IS NULL;

-- Copy name & description to proxy concepts
INSERT INTO concept_property_data
(dbid, `group`, property, value)
SELECT DISTINCT c.dbid, d.group, d.property, d.value
FROM read_v2_map_summary s
JOIN concept c ON c.id = CONCAT('DS_R2_', s.readCode)
JOIN concept o ON o.id = CONCAT('R2_', s.readCode)
JOIN concept_property_data d ON d.dbid = o.dbid
WHERE s.multi = TRUE
  AND s.altConceptId IS NULL
  AND d.property IN (SELECT dbid FROM concept WHERE id IN ('name', 'description'));

-- Set proxy subtypes
SET @prop = get_dbid('is_subtype_of');
SET @val = get_dbid('CodeableConcept');
INSERT INTO concept_property_object
(dbid, property, value)
SELECT DISTINCT c.dbid, @prop, @val
FROM read_v2_map_summary s
JOIN concept c ON c.id = CONCAT('DS_R2_', s.readCode)
WHERE s.multi = TRUE
  AND s.altConceptId IS NULL;

-- Set "related" relationship between Proxy and multi SNOMED
SET @prop = get_dbid('is_subtype_of');
INSERT INTO concept_property_object
(dbid, `group`, property, value)
SELECT DISTINCT c.dbid, 1, @prop, v.dbid
FROM read_v2_map_summary s
JOIN read_v2_map_tmp m ON m.readCode = s.readCode
JOIN concept c ON c.id = CONCAT('DS_R2_', s.readCode)
JOIN concept v ON v.id = CONCAT('SN_', m.conceptId)
WHERE s.multi = TRUE
  AND s.altConceptId IS NULL;

-- Set "equivalent" relationship between Read2 and proxy
SET @prop = get_dbid('is_equivalent_to');
INSERT INTO concept_property_object
(dbid, `group`, property, value)
SELECT DISTINCT c.dbid, 1, @prop, v.dbid
FROM read_v2_map_summary s
JOIN read_v2_map_tmp m ON m.readCode = s.readCode
JOIN concept c ON c.id = CONCAT('R2_', s.readCode)
JOIN concept v ON v.id = CONCAT('DS_R2_', s.readCode)
WHERE s.multi = TRUE
  AND s.altConceptId IS NULL;


/* PATCH SCRATCH
CREATE TABLE im_patch.r2fix
SELECT r.dbid as readDbid, r.id as readCode, r.name as readTerm, so.dbid AS oldSnomedDbid, so.id as oldSnomedIid, so.name as oldSnomedTerm, sn.dbid AS newSnomedDbid, sn.id as newSnomedId, sn.name as newSnomedTerm
FROM concept_property_object_new n
JOIN concept_property_object o ON o.dbid = n.dbid AND o.property = 50
JOIN concept r ON r.dbid = n.dbid
JOIN concept so ON so.dbid = o.value
JOIN concept sn ON sn.dbid = n.value
WHERE n.value != o.value;

UPDATE concept_property_object cpo
JOIN im_patch.r2fix f ON cpo.dbid = f.readDbid AND property = 50
JOIN concept r ON r.dbid = f.readDbid
SET cpo.value = f.newSnomedDbid
WHERE cpo.value = f.oldSnomedDbid;

UPDATE concept_map m
JOIN im_patch.r2fix f ON m.legacy = f.readDbid
SET m.core = f.newSnomedDbid
WHERE m.core = f.oldSnomedDbid;


 */
