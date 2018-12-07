DROP DATABASE IF EXISTS im2;
CREATE DATABASE im2;
USE im2;

-- ********** CORE CONCEPT TABLES **********

DROP TABLE IF EXISTS concept;
CREATE TABLE concept(
  id BIGINT AUTO_INCREMENT                      COMMENT 'Main concept id, common across all tables',
  superclass BIGINT                             COMMENT 'The superclass concept that this concept inherits from',
  url VARCHAR(250)                              COMMENT 'URL for where documentation for this concept is published',
  full_name VARCHAR(500)                        COMMENT 'Full, clear, unambiguous name for the concept',
  short_name VARCHAR(125)                       COMMENT 'Short name for use when context is known',
  context VARCHAR(250) NOT NULL                 COMMENT 'Unique, computable (immutable) name for the concept',
  status TINYINT NOT NULL DEFAULT 0             COMMENT 'Concept status - 0=Draft, 1=Active, 2=Deprecated, 3=Temporary',
  version FLOAT NOT NULL DEFAULT 0.1            COMMENT 'Concept version',
  description VARCHAR(4096)                     COMMENT 'Full textual description of the concept',
  use_count BIGINT NOT NULL DEFAULT 0           COMMENT 'Counter for number of occurrences of use (could be used for ordering?)',
  last_update DATETIME NOT NULL DEFAULT now()   COMMENT 'The date/time the concept was added/edited',
  code VARCHAR(20) COLLATE utf8_bin             COMMENT 'Original ontology code **CASE SENSITIVE!**',
  code_scheme BIGINT                            COMMENT 'Original ontology code scheme',

  PRIMARY KEY concept_id_pk (id),
  KEY concept_last_update_idx (last_update),
  FULLTEXT INDEX concept_full_name_context_idx  (full_name, context),
  CONSTRAINT concept_superclass_fk              FOREIGN KEY (superclass) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*DROP TABLE IF EXISTS concept_relationship;
CREATE TABLE concept_relationship (             -- Extends concept table for relationships
  id BIGINT AUTO_INCREMENT                      COMMENT 'The relationship ID',
  source BIGINT NOT NULL                        COMMENT 'The source concept',
  relationship BIGINT NOT NULL                  COMMENT 'The relationship source -> (rel) -> target',
  target BIGINT NOT NULL                        COMMENT 'The target concept',
  `order` INTEGER DEFAULT 0                     COMMENT 'Display order',
  mandatory BOOLEAN DEFAULT 1                   COMMENT 'Is this relationship optional (0:??) or mandatory (1:??)',
  `limit` INTEGER DEFAULT 1                     COMMENT 'Is this relationship limited (??:n) or unlimited (??:*)',
  status TINYINT NOT NULL DEFAULT 0             COMMENT 'Relationship status - 0=Draft, 1=Active, 2=Deprecated, 3=Temporary',

  PRIMARY KEY concept_relationship_id_pk (id),
  KEY concept_relationship_source_idx (source),
  KEY concept_relationship_target_idx (target),

  CONSTRAINT concept_relationship_source_fk       FOREIGN KEY (source) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT concept_relationship_relationship_fk FOREIGN KEY (relationship) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT concept_relationship_target_fk       FOREIGN KEY (target) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
*/
DROP TABLE IF EXISTS concept_attribute;
CREATE TABLE concept_attribute (                -- Links attribute to concepts
  id BIGINT NOT NULL AUTO_INCREMENT             COMMENT 'Concept Attribute ID',
  concept BIGINT NOT NULL                       COMMENT 'The concept the attribute is part of',
  attribute BIGINT NOT NULL                     COMMENT 'The attribute/relationship',
  `order` INTEGER NOT NULL DEFAULT 0            COMMENT 'Display order',
  mandatory BOOLEAN DEFAULT 0                   COMMENT 'Is this attribute optional (0:??) or mandatory (1:??)',
  `limit` INTEGER DEFAULT 1                     COMMENT 'Is this attribute limited (??:n) or unlimited (??:*)',
  inheritance TINYINT DEFAULT 1                 COMMENT 'Inheritance type (0 - unchanged ("Is a"), 1 - Extends, 2 - Constrains) ',  -- TODO: Can be calculated?
  value_concept BIGINT                          COMMENT 'The allowed values for the attribute (based on the expression)/relationship target',
  value_expression TINYINT                      COMMENT 'The expression for the attribute value (0 - Of type(=), 1 - Child (<), 2 - Type or child (<<))',
  fixed_concept BIGINT                          COMMENT 'The fixed value concept (in the case of a constraint attribute)',
  fixed_value TEXT                              COMMENT 'The fixed value when not a concept (in the case of a constraint attribute)',
  status TINYINT NOT NULL DEFAULT 0             COMMENT 'Concept status - 0=Draft, 1=Active, 2=Deprecated, 3=Temporary',

  PRIMARY KEY concept_attribute_id_pk (id),
  KEY concept_attribute_concept_idx (concept),

  CONSTRAINT concept_attribute_concept_fk       FOREIGN KEY (concept) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT concept_attribute_attribute_fk     FOREIGN KEY (attribute) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT concept_attribute_value_concept_fk FOREIGN KEY (value_concept) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT concept_attribute_fixed_concept_fk FOREIGN KEY (fixed_concept) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS concept_synonym;
CREATE TABLE concept_synonym (
  id BIGINT NOT NULL AUTO_INCREMENT             COMMENT 'Concept synonym id',
  concept BIGINT NOT NULL                       COMMENT 'The concept this is a synonym for',
  term VARCHAR(255)                             COMMENT 'The term (synonym) itself',
  -- preferred BOOLEAN NOT NULL                    COMMENT 'If this term is the preferred term (i.e. concept full_name)',
  status TINYINT NOT NULL DEFAULT 0             COMMENT 'Synonym status - 0=Draft, 1=Active, 2=Deprecated, 3=Temporary',

  PRIMARY KEY concept_synonym_id_pk (id),
  KEY concept_synonym_concept_idx (concept),
  FULLTEXT INDEX concept_synonym_term_idx (term),
  CONSTRAINT concept_synonym_concept_fk         FOREIGN KEY (concept) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS concept_tct;
CREATE TABLE concept_tct (
    concept BIGINT NOT NULL                     COMMENT 'The base concept of interest',
    ancestor BIGINT NOT NULL                    COMMENT 'The parent, grandparent, etc',
    level INTEGER NOT NULL                      COMMENT 'The inheritance depth (Top down)',

    KEY concept_tct_concept_idx (concept),
    CONSTRAINT concept_tct_concept_fk           FOREIGN KEY (concept) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT concept_tct_ancestor_fk          FOREIGN KEY (ancestor) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DELIMITER //

DROP PROCEDURE IF EXISTS proc_build_tct//

CREATE PROCEDURE proc_build_tct()
    BEGIN
        DECLARE lvl INT;
        DECLARE inserted INT;
        SELECT @lvl := 0;

        DELETE FROM concept_tct;

        INSERT INTO concept_tct
            (concept, ancestor, level)
        SELECT id, superclass, 0
        FROM concept
        WHERE id > 1;

        SELECT @inserted := ROW_COUNT();

        WHILE @inserted > 0 DO
            SELECT @lvl := @lvl + 1;
            SELECT 'Processing level ' + @lvl;

            INSERT INTO concept_tct
                (concept, ancestor, level)
            SELECT t.concept, a.superclass, @lvl
            FROM concept_tct t
                     JOIN concept a ON a.id = t.ancestor
            WHERE t.ancestor > 1
              AND t.level = @lvl - 1;

            SELECT @inserted := ROW_COUNT();
        END WHILE;
    END; //

DELIMITER ;

-- ********** SCHEMA MAP TABLE **********

DROP TABLE IF EXISTS concept_schema_map;
CREATE TABLE concept_schema_map (
    id BIGINT AUTO_INCREMENT            COMMENT 'The schema mapping id',
    concept BIGINT NOT NULL             COMMENT 'The concept (usually RecordType subtype), e.g. Event',
    attribute BIGINT NOT NULL           COMMENT 'The attribute of the concept, e.g. Event.EffectiveDate',
    `table` VARCHAR(100) NOT NULL       COMMENT 'The table it maps to, e.g. observation',
    field VARCHAR(100) NOT NULL         COMMENT 'The field it maps to, e.g. effective_date',

    PRIMARY KEY concept_schema_map_pk (id),

    KEY concept_schema_map_concept (concept),

    CONSTRAINT concept_schema_map_concept_fk FOREIGN KEY (concept) REFERENCES concept(id),
    CONSTRAINT concept_schema_map_attribute_fk FOREIGN KEY (attribute) REFERENCES concept(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ********** VIEWS TABLE **********

DROP TABLE IF EXISTS `view`;
CREATE TABLE `view` (
    id BIGINT NOT NULL AUTO_INCREMENT           COMMENT 'View id',
    name VARCHAR(50) NOT NULL                   COMMENT 'View name',
    description VARCHAR(1000)                   COMMENT 'View description',

    PRIMARY KEY view_id_pk (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS view_item;
CREATE TABLE view_item (
    id BIGINT NOT NULL AUTO_INCREMENT           COMMENT 'Row id',
    `view` BIGINT NOT NULL                      COMMENT 'The view',
    concept BIGINT NOT NULL                     COMMENT 'Concept',
    parent BIGINT                               COMMENT 'Parent',
    context BIGINT                              COMMENT 'Context (optional)',


    PRIMARY KEY view_item_id_pk (id),

    KEY view_item_view_parent_idx (`view`, parent),

    CONSTRAINT view_item_view_fk     FOREIGN KEY (`view`) REFERENCES view(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT view_item_concept_fk  FOREIGN KEY (concept) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT view_item_parent_fk   FOREIGN KEY (parent)  REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT view_item_context_fk  FOREIGN KEY (context) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ********** TERM/MAPPING TABLES **********

DROP TABLE IF EXISTS code_scheme;
CREATE TABLE code_scheme (
  id INTEGER AUTO_INCREMENT                     COMMENT 'Code scheme concept identifier',
  identifier VARCHAR(125) NOT NULL              COMMENT 'Code scheme identifier',

  PRIMARY KEY code_scheme_id_pk (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS publisher_map;
CREATE TABLE publisher_map (
  id BIGINT AUTO_INCREMENT                      COMMENT 'Publisher map id',
  system VARCHAR(50)                            COMMENT 'The name of the source system of the data',
  provider VARCHAR(50)                          COMMENT 'The body providing the data from the system',
  `table` VARCHAR(50)                           COMMENT 'The table the data is coming from',
  fields VARCHAR(250)                           COMMENT 'The list of fields the data is coming from',
  `values` VARCHAR(250) COLLATE utf8_bin        COMMENT 'The list of data itself',
  concept BIGINT NOT NULL                       COMMENT 'The concept it maps to',

  PRIMARY KEY publisher_map_id_pk (id),
  KEY publisher_map_concept_idx (concept),

  CONSTRAINT publisher_map_concept_fk           FOREIGN KEY (concept) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ********** WORKFLOW MANAGER TASK TABLES **********

DROP TABLE IF EXISTS task_type;
CREATE TABLE task_type (
  id TINYINT NOT NULL PRIMARY KEY               COMMENT 'Unique task type identifier',
  name VARCHAR(50)                              COMMENT 'Name for the type of task'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS task;
CREATE TABLE task (
  id INT AUTO_INCREMENT PRIMARY KEY             COMMENT 'Unique task identifier',
  type TINYINT NOT NULL                         COMMENT 'The type of this task - 0=Attribute model, 1=Value model, 2=Unmapped message',
  title VARCHAR(250) NOT NULL                   COMMENT 'Title/subject for the task',
  description VARCHAR(4096)                     COMMENT 'Full textual description of the task',
  identifier BIGINT                             COMMENT 'Reference to the item this task relates to',
  created DATETIME NOT NULL                     COMMENT 'Date/time the task was created',

  KEY task_type_idx (type),
  CONSTRAINT task_type_fk FOREIGN KEY (type) REFERENCES task_type(id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
