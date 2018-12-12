-- ********************* CONCEPT *********************

DROP TABLE IF EXISTS snomed_concept;
CREATE TABLE snomed_concept (
    id BIGINT NOT NULL             COMMENT '',
    effectiveTime VARCHAR(8) NOT NULL   COMMENT '',
    active BOOLEAN NOT NULL             COMMENT '',
    moduleId BIGINT NOT NULL            COMMENT '',
    definitionStatusId BIGINT NOT NULL  COMMENT '',

    PRIMARY KEY snomed_concept_pk (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\uk_sct2cl_25.0.0_20180427000001\\SnomedCT_InternationalRF2_PRODUCTION_20180131T120000Z\\Snapshot\\Terminology\\sct2_Concept_Snapshot_INT_20180131.txt'
    INTO TABLE snomed_concept
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\uk_sct2cl_25.0.0_20180427000001\\SnomedCT_UKClinicalRF2_Production_20180427T000001Z\\Snapshot\\Terminology\\sct2_Concept_Snapshot_GB1000000_20180401.txt'
    INTO TABLE snomed_concept
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

-- ********************* DESCRIPTION *********************

DROP TABLE IF EXISTS snomed_description;
CREATE TABLE snomed_description (
    id BIGINT NOT NULL                  COMMENT '',
    effectiveTime VARCHAR(8) NOT NULL   COMMENT '',
    active BOOLEAN NOT NULL             COMMENT '',
    moduleId BIGINT NOT NULL            COMMENT '',
    conceptId BIGINT NOT NULL           COMMENT '',
    languageCode VARCHAR(2)             COMMENT '',
    typeId BIGINT NOT NULL              COMMENT '',
    term VARCHAR(400) NOT NULL          COMMENT '',
    caseSignificanceId BIGINT NOT NULL  COMMENT '',

    PRIMARY KEY snomed_description_pk (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\uk_sct2cl_25.0.0_20180427000001\\SnomedCT_InternationalRF2_PRODUCTION_20180131T120000Z\\Snapshot\\Terminology\\sct2_Description_Snapshot-en_INT_20180131.txt'
    INTO TABLE snomed_description
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\uk_sct2cl_25.0.0_20180427000001\\SnomedCT_UKClinicalRF2_Production_20180427T000001Z\\Snapshot\\Terminology\\sct2_Description_Snapshot-en-GB_GB1000000_20180401.txt'
    INTO TABLE snomed_description
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

ALTER TABLE snomed_description ADD INDEX snomed_description_active_typeId_idx (active, typeId);

-- ********************* RELATIONSHIP *********************

DROP TABLE IF EXISTS snomed_relationship;
CREATE TABLE snomed_relationship (
    id BIGINT NOT NULL                      COMMENT '',
    effectiveTime VARCHAR(8) NOT NULL       COMMENT '',
    active BOOLEAN NOT NULL                 COMMENT '',
    moduleId BIGINT NOT NULL                COMMENT '',
    sourceId VARCHAR(20) NOT NULL           COMMENT '',
    destinationId VARCHAR(20) NOT NULL      COMMENT '',
    relationshipGroup BIGINT NOT NULL       COMMENT '',
    typeId BIGINT NOT NULL                  COMMENT '',
    characteristicTypeId BIGINT NOT NULL    COMMENT '',
    modifierId BIGINT NOT NULL              COMMENT '',

    PRIMARY KEY snomed_relationship_pk (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\uk_sct2cl_25.0.0_20180427000001\\SnomedCT_InternationalRF2_PRODUCTION_20180131T120000Z\\Snapshot\\Terminology\\sct2_Relationship_Snapshot_INT_20180131.txt'
    INTO TABLE snomed_relationship
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\uk_sct2cl_25.0.0_20180427000001\\SnomedCT_UKClinicalRF2_Production_20180427T000001Z\\Snapshot\\Terminology\\sct2_Relationship_Snapshot_GB1000000_20180401.txt'
    INTO TABLE snomed_relationship
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

-- ********************* REFSET *********************

DROP TABLE IF EXISTS snomed_refset;
CREATE TABLE snomed_refset (
    id VARCHAR(40) NOT NULL                     COMMENT '',
    effectiveTime VARCHAR(8) NOT NULL           COMMENT '',
    active BOOLEAN NOT NULL                     COMMENT '',
    moduleId BIGINT NOT NULL                    COMMENT '',
    refsetId BIGINT NOT NULL                    COMMENT '',
    referencedComponentId BIGINT NOT NULL       COMMENT '',
    acceptabilityId BIGINT NOT NULL             COMMENT '',
    PRIMARY KEY snomed_refset_pk (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\uk_sct2cl_25.0.0_20180427000001\\SnomedCT_InternationalRF2_PRODUCTION_20180131T120000Z\\Snapshot\\Refset\\Language\\der2_cRefset_LanguageSnapshot-en_INT_20180131.txt'
    INTO TABLE snomed_refset
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\uk_sct2cl_25.0.0_20180427000001\\SnomedCT_UKClinicalRF2_Production_20180427T000001Z\\Snapshot\\Refset\\Language\\der2_cRefset_LanguageSnapshot-en-GB_GB1000000_20180401.txt'
    INTO TABLE snomed_refset
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

ALTER TABLE snomed_refset ADD INDEX snomed_refset_acceptabilityId_refsetId_active_idx (acceptabilityId, refsetId, active);
