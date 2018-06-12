DROP DATABASE IF EXISTS im;
CREATE DATABASE im;
USE im;

DROP TABLE IF EXISTS table_id;
CREATE TABLE table_id (
  table_name VARCHAR(25) PRIMARY KEY            COMMENT 'Name of the table for this id counter',
  id BIGINT NOT NULL                            COMMENT 'The next id available on that table'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ********** CORE INFORMATION MODEL TABLE **********

DROP TABLE IF EXISTS concept;
CREATE TABLE concept(
  id BIGINT PRIMARY KEY                         COMMENT 'Main concept id, common across all tables',
  type BIGINT NOT NULL                          COMMENT 'The data type of this concept',
  url VARCHAR(250)                              COMMENT 'URL for where documentation for this concept is published',
  full_name VARCHAR(4096)                       COMMENT 'Full, clear, unambiguous name for the concept',
  context VARCHAR(250) NOT NULL                 COMMENT 'Unique, computable (immutable) name for the concept',
  status TINYINT NOT NULL DEFAULT 0             COMMENT 'Concept status - 0=Draft, 1=Active, 2=Deprecated, 3=Temporary',
  version VARCHAR(10) NOT NULL DEFAULT '0.1'    COMMENT 'Concept version',
  description VARCHAR(4096)                     COMMENT 'Full textual description of the concept',
  expression VARCHAR(1024)                      COMMENT 'Definition of this concept, based on other concepts, using ECL',
  criteria VARCHAR(1024)                        COMMENT 'Definition of this concept, using a criteria in D/IMQL',
  use_count BIGINT NOT NULL DEFAULT 0           COMMENT 'Counter for number of occurrences of use (could be used for ordering?)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS concept_attribute;
CREATE TABLE concept_attribute (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  concept_id BIGINT NOT NULL                    COMMENT 'The concept that has the attribute',
  attribute_id BIGINT NOT NULL                  COMMENT 'The attribute',
  `order` INTEGER DEFAULT 0                     COMMENT 'Attribute display order',
  mandatory BOOLEAN DEFAULT 0                   COMMENT 'Is this relationship optional (0:??) or mandatory (1:??)',
  `limit` INTEGER DEFAULT 0                     COMMENT 'Is this relationship limited (??:n) or unlimited (??:0)',

  CONSTRAINT concept_attribute_concept_id_fk    FOREIGN KEY (concept_id) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT concept_attribute_attribute_id_fk  FOREIGN KEY (attribute_id) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS concept_relationship;
CREATE TABLE concept_relationship (
  id BIGINT AUTO_INCREMENT PRIMARY KEY          COMMENT '',
  source BIGINT NOT NULL                        COMMENT '',
  relationship BIGINT NOT NULL                  COMMENT '',
  target BIGINT NOT NULL                        COMMENT '',
  `order` INTEGER DEFAULT 0                     COMMENT '',
  mandatory BOOLEAN DEFAULT 0                   COMMENT 'Is this relationship optional (0:??) or mandatory (1:??)',
  `limit` INTEGER DEFAULT 0                     COMMENT 'Is this relationship limited (??:n) or unlimited (??:0)',
  weighting INTEGER DEFAULT 0                   COMMENT '',

  KEY concept_relationship_source_idx (source),
  KEY concept_relationship_target_idx (target),

  CONSTRAINT concept_relationship_source_fk       FOREIGN KEY (source) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT concept_relationship_relationship_fk FOREIGN KEY (relationship) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT concept_relationship_target_fk       FOREIGN KEY (target) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#
# DROP TABLE IF EXISTS record_type;
# CREATE TABLE record_type (
#   id BIGINT NOT NULL PRIMARY KEY                COMMENT 'Record type id - synonymous with concept.id',
#   inherits_from BIGINT                          COMMENT 'Reference to the class (concept.id) that this record type inherits from',
#
#   CONSTRAINT record_type_id_fk FOREIGN KEY (id) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
#   CONSTRAINT record_type_inherits_from_fk FOREIGN KEY (inherits_from) REFERENCES record_type(id) ON DELETE NO ACTION ON UPDATE NO ACTION
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#
# DROP TABLE IF EXISTS record_type_attribute;
# CREATE TABLE record_type_attribute (
#   id BIGINT AUTO_INCREMENT PRIMARY KEY          COMMENT 'Record type attribute unique identifier',
#   record_type BIGINT NOT NULL                   COMMENT 'Reference to the record type that this is an attribute of',
#   data_type BIGINT NOT NULL                     COMMENT 'Reference to the data type (concept.id) of this attribute',
#   value BIGINT NOT NULL                         COMMENT 'If data_type is "Record Type", then the id of the actual record type',
#   mandatory BOOLEAN NOT NULL                    COMMENT 'Is this attribute optional (0:??) or mandatory (1:??)',
#   unlimited BOOLEAN NOT NULL                    COMMENT 'Is this attribute limited (??:1) or unlimited (??:*)',
#
#   CONSTRAINT record_type_attribute_record_type_fk FOREIGN KEY (record_type) REFERENCES record_type(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
#   CONSTRAINT record_type_attribute_data_type_fk FOREIGN KEY (data_type) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
#   CONSTRAINT record_type_attribute_value_fk FOREIGN KEY (value) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#
# -- ********** TRANSACTION TABLES **********
#
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
#
# -- ********** WORKFLOW MANAGER TASK TABLES **********
#
# DROP TABLE IF EXISTS task_type;
# CREATE TABLE task_type (
#   id TINYINT NOT NULL PRIMARY KEY               COMMENT 'Unique task type identifier',
#   name VARCHAR(50)                              COMMENT 'Name for the type of task'
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#
# DROP TABLE IF EXISTS task;
# CREATE TABLE task (
#   id INT AUTO_INCREMENT PRIMARY KEY             COMMENT 'Unique task identifier',
#   type TINYINT NOT NULL                         COMMENT 'The type of this task - 0=Attribute model, 1=Value model, 2=Unmapped message',
#   title VARCHAR(250) NOT NULL                   COMMENT 'Title/subject for the task',
#   description VARCHAR(4096)                     COMMENT 'Full textual description of the task',
#   identifier BIGINT                             COMMENT 'Reference to the item this task relates to',
#   created DATETIME NOT NULL                     COMMENT 'Date/time the task was created',
#
#   KEY task_type_idx (type),
#   CONSTRAINT task_type_fk FOREIGN KEY (type) REFERENCES task_type(id) ON DELETE NO ACTION ON UPDATE NO ACTION
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#
# -- ********** INBOUND MESSAGE TABLES **********
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
# DROP TABLE IF EXISTS term_mapping;
# CREATE TABLE term_mapping (
#   id BIGINT AUTO_INCREMENT PRIMARY KEY,
#   organisation VARCHAR(36) NOT NULL,
#   context VARCHAR(50) NOT NULL,
#   system VARCHAR(15) NOT NULL,
#   code VARCHAR(25) NOT NULL,
#   concept_id BIGINT NOT NULL,
#
#   UNIQUE KEY term_mapping_organisation_context_system_code_idx (organisation, context, system, code),
#   CONSTRAINT term_mapping_term_id_fk FOREIGN KEY (concept_id) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;