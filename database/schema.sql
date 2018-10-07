DROP DATABASE IF EXISTS im2;
CREATE DATABASE im2;
USE im2;

DROP TABLE IF EXISTS table_id;
CREATE TABLE table_id (
  name    VARCHAR(25) PRIMARY KEY           COMMENT 'Name of the id counter',
  id      BIGINT NOT NULL                   COMMENT 'The next id available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ********** CORE CONCEPT TABLES **********

DROP TABLE IF EXISTS concept;
CREATE TABLE concept(
  id BIGINT AUTO_INCREMENT                      COMMENT 'Main concept id, common across all tables',
  superclass BIGINT                             COMMENT 'The superclass concept that this concept inherits from',
  url VARCHAR(250)                              COMMENT 'URL for where documentation for this concept is published',
  full_name VARCHAR(255)                        COMMENT 'Full, clear, unambiguous name for the concept',
  short_name VARCHAR(125)                       COMMENT 'Short name for use when context is known',
  context VARCHAR(250) NOT NULL                 COMMENT 'Unique, computable (immutable) name for the concept',
  status TINYINT NOT NULL DEFAULT 0             COMMENT 'Concept status - 0=Draft, 1=Active, 2=Deprecated, 3=Temporary',
  version FLOAT NOT NULL DEFAULT 0.1            COMMENT 'Concept version',
  description VARCHAR(4096)                     COMMENT 'Full textual description of the concept',
  use_count BIGINT NOT NULL DEFAULT 0           COMMENT 'Counter for number of occurrences of use (could be used for ordering?)',
  last_update DATETIME NOT NULL DEFAULT now()   COMMENT 'The date/time the concept was added/edited',

  PRIMARY KEY concept_id_pk (id),

  CONSTRAINT concept_superclass_fk              FOREIGN KEY (superclass) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS concept_relationship;
CREATE TABLE concept_relationship (             -- Extends concept table for relationships
  id BIGINT AUTO_INCREMENT                      COMMENT 'The relationship ID',
  source BIGINT NOT NULL                        COMMENT 'The source concept',
  relationship BIGINT NOT NULL                  COMMENT 'The relationship source -> (rel) -> target',
  target BIGINT NOT NULL                        COMMENT 'The target concept',
  `order` INTEGER DEFAULT 0                     COMMENT 'Display order',
  mandatory BOOLEAN DEFAULT 0                   COMMENT 'Is this relationship optional (0:??) or mandatory (1:??)',
  `limit` INTEGER DEFAULT 0                     COMMENT 'Is this relationship limited (??:n) or unlimited (??:0)',
  status TINYINT NOT NULL DEFAULT 0             COMMENT 'Relationship status - 0=Draft, 1=Active, 2=Deprecated, 3=Temporary',

  PRIMARY KEY concept_relationship_id_pk (id),
  KEY concept_relationship_source_idx (source),
  KEY concept_relationship_target_idx (target),

  CONSTRAINT concept_relationship_source_fk       FOREIGN KEY (source) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT concept_relationship_relationship_fk FOREIGN KEY (relationship) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT concept_relationship_target_fk       FOREIGN KEY (target) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS concept_attribute;
CREATE TABLE concept_attribute (                -- Links attribute to concepts
  id BIGINT NOT NULL AUTO_INCREMENT             COMMENT 'Concept Attribute ID',
  concept BIGINT NOT NULL                       COMMENT 'The concept the attribute is part of',
  attribute BIGINT NOT NULL                     COMMENT 'The attribute',
  `order` INTEGER NOT NULL DEFAULT 0            COMMENT 'Display order',
  minimum INTEGER DEFAULT 0                     COMMENT 'Minimum value where type is an Integer',
  maximum INTEGER DEFAULT 1                     COMMENT 'Maximum value where type is an Integer',
  status TINYINT NOT NULL DEFAULT 0             COMMENT 'Concept status - 0=Draft, 1=Active, 2=Deprecated, 3=Temporary',

  PRIMARY KEY concept_attribute_id_pk (id),
  KEY concept_attribute_concept_idx (concept),

  CONSTRAINT concept_attribute_concept_fk       FOREIGN KEY (concept) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT concept_attribute_attribute_fk     FOREIGN KEY (attribute) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS concept_attribute_value;
CREATE TABLE concept_attribute_value (
    id BIGINT NOT NULL AUTO_INCREMENT           COMMENT 'Concept attribute value ID',
    concept BIGINT NOT NULL                     COMMENT 'The concept this attribute value relates to',
    concept_attribute BIGINT NOT NULL           COMMENT 'The concept attribute ID.  NOTE: This may be an attribute belonging to an inherited concept!',
    fixed_concept BIGINT                        COMMENT 'Fixed (constant) value where the type is a concept (AdministrativeGender.Male)',
    fixed_value VARCHAR(45)                     COMMENT 'Fixed (constant) value where the type is not a concept',

    PRIMARY KEY concept_attribute_value_id_pk (id),
    KEY concept_attribute_concept_idx (concept),

    CONSTRAINT concept_attribute_value_concept_fk           FOREIGN KEY (concept) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT concept_attribute_value_concept_attribute_fk FOREIGN KEY (concept_attribute) REFERENCES concept_attribute(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT concept_attribute_value_fixed_concept_fk     FOREIGN KEY (fixed_concept) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION
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

  CONSTRAINT concept_synonym_concept_fk         FOREIGN KEY (concept) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ********** TERM/MAPPING TABLES **********

DROP TABLE IF EXISTS code_scheme;
CREATE TABLE code_scheme (
  id INTEGER AUTO_INCREMENT                     COMMENT 'Code scheme concept identifier',
  identifier VARCHAR(125) NOT NULL              COMMENT 'Code scheme identifier',

  PRIMARY KEY code_scheme_id_pk (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS mapping_code;
CREATE TABLE mapping_code (
  id BIGINT AUTO_INCREMENT                      COMMENT 'Mapping code identifier',
  scheme INTEGER NOT NULL                       COMMENT 'Code scheme id',
  code_id VARCHAR(20) NOT NULL                  COMMENT 'Code id',
  concept BIGINT                                COMMENT 'Code concept identifier',

  PRIMARY KEY mapping_code_id_pk (id),
  KEY mapping_code_id_idx (concept),
  KEY mapping_code_scheme_code_id_idx (scheme, code_id),

  CONSTRAINT mapping_code_concept_fk            FOREIGN KEY (concept) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT mapping_code_scheme_fk             FOREIGN KEY (scheme) REFERENCES code_scheme(id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS publisher_map;
CREATE TABLE publisher_map (
  id BIGINT AUTO_INCREMENT                      COMMENT 'Publisher map id',
  system VARCHAR(50)                            COMMENT 'The name of the source system of the data',
  provider VARCHAR(50)                          COMMENT 'The body providing the data from the system',
  `table` VARCHAR(50)                           COMMENT 'The table the data is coming from',
  fields VARCHAR(250)                           COMMENT 'The list of fields the data is coming from',
  `values` VARCHAR(250)                         COMMENT 'The list of data itself',
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

# -- ********** TEMP SNOMED TABLES **********
# DROP TABLE IF EXISTS sct2_concept;
# CREATE TABLE sct2_concept (
#   id BIGINT NOT NULL,
#   effectiveTime INT NOT NULL,
#   active BOOLEAN NOT NULL,
#   moduleId BIGINT NOT NULL,
#   definitionStatusId BIGINT NOT NULL,
#   KEY id_effectiveTime (id, effectiveTime)
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#
# DROP TABLE IF EXISTS sct2_description;
# CREATE TABLE sct2_description (
#   id BIGINT NOT NULL,
#   effectiveTime INT NOT NULL,
#   active BOOLEAN NOT NULL,
#   moduleId BIGINT NOT NULL,
#   conceptId BIGINT NOT NULL,
#   languageCode VARCHAR(4) NOT NULL,
#   typeId BIGINT NOT NULL,
#   term varchar(1000) DEFAULT NULL,
#   caseSignificanceId BIGINT NOT NULL,
#   KEY id_effectiveTime (id, effectiveTime)
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#
# DROP TABLE IF EXISTS sct2_relationship;
# CREATE TABLE sct2_relationship (
#   id BIGINT NOT NULL,
#   effectiveTime INT NOT NULL,
#   active BOOLEAN NOT NULL,
#   moduleId BIGINT NOT NULL,
#   sourceId BIGINT NOT NULL,
#   destinationId BIGINT NOT NULL,
#   relationshipGroup BIGINT NOT NULL,
#   typeId BIGINT NOT NULL,
#   characteristicTypeId BIGINT NOT NULL,
#   modifierId BIGINT NOT NULL,
#   KEY id_active_idx (id, active),
#   KEY typeId_sourceId_destinationId_idx (typeId, sourceId, destinationId),
#   KEY id_typeId (id, typeId)
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ********** INBOUND MESSAGE TABLES **********
#
# DROP TABLE IF EXISTS message;
# CREATE TABLE message (
#   id BIGINT AUTO_INCREMENT PRIMARY KEY          COMMENT 'Unique message identifier',
#   organisation_uuid VARCHAR(36) NOT NULL        COMMENT 'UUID of the message source organisation',
#   system_concept_id BIGINT NOT NULL             COMMENT 'Reference to the message source system (concept.id)',
#   version VARCHAR(10) NOT NULL                  COMMENT 'The version of the message source system',
#   type_concept_id BIGINT NOT NULL               COMMENT 'Reference to the source message type (concept.id)',
#
#   CONSTRAINT message_system_concept_id_fk FOREIGN KEY (system_concept_id) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
#   CONSTRAINT message_type_concept_id_fk FOREIGN KEY (type_concept_id) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#
# DROP TABLE IF EXISTS message_resource;
# CREATE TABLE message_resource (
#   id BIGINT AUTO_INCREMENT PRIMARY KEY          COMMENT 'Unique message resource identifier',
#   message_id BIGINT NOT NULL                    COMMENT 'Reference to the message that this is a resource of',
#   resource_concept_id BIGINT NOT NULL           COMMENT 'Reference to the resource type (concept.id)',
#   KEY message_resource_message_idx (message_id),
#
#   CONSTRAINT message_resource_message_fk FOREIGN KEY (message_id) REFERENCES message (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
#   CONSTRAINT message_resource_resource_concept_id_fk FOREIGN KEY (resource_concept_id) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#
# DROP TABLE IF EXISTS message_resource_field;
# CREATE TABLE message_resource_field (
#   id BIGINT AUTO_INCREMENT PRIMARY KEY          COMMENT 'Unique message resource field identifier',
#   message_resource_id BIGINT                    COMMENT 'Reference to the message resource of which this is a field',
#   field_name VARCHAR(50) NOT NULL               COMMENT 'Name of the field',
#   value VARCHAR(4096)                           COMMENT 'Example field value',
#   scheme_concept_id BIGINT                      COMMENT 'Reference to the code scheme (concept.id) for the value where appropriate',
#
#   KEY message_resource_field_message_resource_idx (message_resource_id),
#   CONSTRAINT message_resource_field_message_resource_fk FOREIGN KEY (message_resource_id) REFERENCES message_resource (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
#   CONSTRAINT message_resource_field_scheme_concept_id_fk FOREIGN KEY (scheme_concept_id) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#
# DROP TABLE IF EXISTS message_mapping;
# CREATE TABLE message_mapping (
#   source_field BIGINT NOT NULL                  COMMENT 'Reference to the message resource field (source)',
#   target_record_type_attribute BIGINT NOT NULL  COMMENT 'Reference to the record type attribute (target)',
#   description VARCHAR(500)                      COMMENT 'Full textual description of the mapping',
#
#   PRIMARY KEY (source_field, target_record_type_attribute),
#   KEY message_mapping_source_field_idx (source_field),
#   CONSTRAINT message_mapping_source_field_fk FOREIGN KEY (source_field) REFERENCES message_resource_field(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
#   CONSTRAINT message_mapping_target_record_type_attribute_fk FOREIGN KEY (target_record_type_attribute) REFERENCES record_type_attribute(id) ON DELETE NO ACTION ON UPDATE NO ACTION
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#

-- ********** TRANSACTION TABLES **********

# DROP TABLE IF EXISTS transaction_action;
# CREATE TABLE transaction_action (
#   id TINYINT NOT NULL PRIMARY KEY               COMMENT 'Transaction action unique identifier',
#   action VARCHAR(25) NOT NULL                   COMMENT 'Name of the action'
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#
# DROP TABLE IF EXISTS transaction_table;
# CREATE TABLE transaction_table (
#   id TINYINT NOT NULL PRIMARY KEY               COMMENT 'Transaction table identifier',
#   `table` VARCHAR(25) NOT NULL                  COMMENT 'Name of the transaction table'
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#
# DROP TABLE IF EXISTS transaction;
# CREATE TABLE transaction (
#   id BIGINT AUTO_INCREMENT PRIMARY KEY          COMMENT 'Unique transaction identifier',
#   date_time DATETIME NOT NULL DEFAULT NOW()     COMMENT 'Date/time the transaction was created',
#   owner VARCHAR(250) NOT NULL                   COMMENT 'Owner of the transaction',
#   action TINYINT NOT NULL                       COMMENT 'The transaction action - 0=Create, 1=Update, 2=Delete',
#
#   CONSTRAINT transaction_action_fk FOREIGN KEY (action) REFERENCES transaction_action(id) ON DELETE NO ACTION ON UPDATE NO ACTION -- Move to component table!?
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#
# DROP TABLE IF EXISTS transaction_component;
# CREATE TABLE transaction_component (
#   id BIGINT AUTO_INCREMENT PRIMARY KEY          COMMENT 'Unique transaction component identifier',
#   transaction_id BIGINT NOT NULL                COMMENT 'The transaction that this is a component of',
#   `order` INTEGER NOT NULL                      COMMENT 'The order of this component in relation to the others within the same transaction',
#   table_id TINYINT NOT NULL                     COMMENT 'The table this transaction component effects',
#   data LONGTEXT                                 COMMENT 'The data for the transaction component',
#
#   KEY transaction_component_transaction_id (transaction_id),
#   CONSTRAINT transaction_component_transaction_id_fk FOREIGN KEY (transaction_id) REFERENCES transaction(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
#   CONSTRAINT transaction_component_table_id_fk FOREIGN KEY (table_id) REFERENCES transaction_table(id) ON DELETE NO ACTION ON UPDATE NO ACTION
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
