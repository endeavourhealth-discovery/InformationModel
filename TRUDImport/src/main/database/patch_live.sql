-- Patch new concepts
INSERT IGNORE INTO concept
(document, id, draft, name, description, scheme, code, use_count)
SELECT document, id, draft, name, description, scheme, code, use_count
FROM im_patch.concept_new;

-- Delete deprecated CPO data
DELETE cpo
FROM concept_property_object cpo
JOIN im_patch.cpo_delete d ON d.dbid = cpo.dbid
AND d.group = cpo.group
AND d.property = cpo.property
AND d.value = cpo.value;

-- Add new CPO data
INSERT INTO concept_property_object
(dbid, `group`, property, value)
SELECT c.dbid, n.group, p.dbid, v.dbid
FROM im_patch.cpo_new n
JOIN concept c ON c.id = n.concept
JOIN concept p ON p.id = n.property
JOIN concept v ON v.id = n.value;

-- Get "Is A" relationship id
SELECT @isa := dbid FROM concept WHERE id = 'SN_116680003';

-- Create new TCT table
DROP TABLE IF EXISTS concept_tct_new;
CREATE TABLE `concept_tct_new` (
    `source` int NOT NULL,
    `property` int NOT NULL,
    `level` int NOT NULL,
    `target` int NOT NULL,
    PRIMARY KEY (`source`,`property`,`target`),
    KEY `concept_tct_source_property_idx` (`source`,`property`),
    KEY `concept_tct_property_level_idx` (`property`,`level`),
    KEY `concept_tct_property_target_idx` (`property`,`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Add non-"Is a" entries
INSERT INTO concept_tct_new
(source, property, level, target)
SELECT source, property, level, target
FROM concept_tct
WHERE property <> @isa;

-- Add new "Is A" entries
INSERT INTO concept_tct_new
(source, property, level, target)
SELECT c.dbid, @isa, n.level, p.dbid
FROM im_patch.concept_tct_meta n
JOIN concept c ON c.id = n.source
JOIN concept p ON p.id = n.target;

-- Switch
DROP TABLE IF EXISTS concept_tct_old;
ALTER TABLE concept_tct RENAME concept_tct_old;
ALTER TABLE concept_tct_new RENAME concept_tct;
