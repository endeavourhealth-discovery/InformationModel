DROP TABLE IF EXISTS model;
CREATE TABLE model
(
    dbid    INT AUTO_INCREMENT  COMMENT 'Model unique DBID',
    iri     VARCHAR(255)        COMMENT 'Model IRI',
    version VARCHAR(10)         COMMENT 'Current model version number',

    PRIMARY KEY model_pk (dbid),
    UNIQUE INDEX model_iri_version (iri, version)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS document;
CREATE TABLE document
(
    dbid    INT AUTO_INCREMENT              COMMENT 'Unique document DBID',
    data    JSON NOT NULL                   COMMENT 'Document (header) JSON',

    -- Exposed (known) JSON properties
    id      CHAR(36)                        GENERATED ALWAYS AS (`data` ->> '$.documentId') STORED NOT NULL,

    PRIMARY KEY document_pk (dbid),
    UNIQUE INDEX document_id_uq (id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;


DROP TABLE IF EXISTS concept;
CREATE TABLE concept
(
    dbid        INT AUTO_INCREMENT,
    model       INT NOT NULL                COMMENT 'The model the concept belongs to',
    data        JSON NOT NULL               COMMENT 'Concept JSON blob',
    updated     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,                    -- Used for MRU

    -- Exposed (known) JSON properties
    id VARCHAR(140) COLLATE utf8_bin        GENERATED ALWAYS AS (`data` ->> '$.id') STORED NOT NULL,
    name VARCHAR(255)                       GENERATED ALWAYS AS (`data` ->> '$.name') STORED,
    scheme VARCHAR(140)                     GENERATED ALWAYS AS (`data` ->> '$.codeScheme') STORED,
    code VARCHAR(20) COLLATE utf8_bin       GENERATED ALWAYS AS (`data` ->> '$.code') STORED,
    status VARCHAR(140) COLLATE utf8_bin    GENERATED ALWAYS AS (`data` ->> '$.status') VIRTUAL,

    PRIMARY KEY concept_dbid_pk (dbid),
    UNIQUE KEY concept_id_uq (id),
    UNIQUE KEY concept_code_scheme (code, scheme),
    FULLTEXT concept_name_ftx (name)    -- TODO: Include description?
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS concept_synonym;
CREATE TABLE concept_synonym
(
    dbid    INT NOT NULL            COMMENT 'Concept DBID',
    synonym VARCHAR(255) NOT NULL   COMMENT 'Synonym text',

    INDEX concept_synonym_idx (dbid),
    FULLTEXT concept_synonym_ftx (synonym)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS concept_expression;
CREATE TABLE concept_expression
(
    dbid        INT AUTO_INCREMENT  COMMENT 'Concept expression DBID',
    name        VARCHAR(255)        COMMENT 'Concept expression name (optional)',
    operator    TINYINT NOT NULL    COMMENT 'Expression operator enum (AND,OR,NOT,ANDNOT,ORNOT)',

    PRIMARY KEY concept_expression_pk (dbid)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS concept_definition;
CREATE TABLE concept_definition
(
    dbid        INT NOT NULL        COMMENT 'Concept DBID (definitionOf)',
    status      INT NOT NULL        COMMENT 'Status concept DBID',
    type        INT NOT NULL        COMMENT 'Definition type concept DBID (subtype, equivalent, etc)',  -- TODO: Are these concepts or a predefined ENUM?
    expression  INT NOT NULL        COMMENT 'Concept expression DBID',

    INDEX concept_definition_idx (dbid),

    CONSTRAINT concept_definition_dbid_fk FOREIGN KEY (dbid) REFERENCES concept (dbid),
    CONSTRAINT concept_definition_status_fk FOREIGN KEY (status) REFERENCES concept (dbid),
    CONSTRAINT concept_definition_type_fk FOREIGN KEY (type) REFERENCES concept (dbid),
    CONSTRAINT concept_definition_expression_fk FOREIGN KEY (expression) REFERENCES concept_expression (dbid)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS attribute_expression;
CREATE TABLE attribute_expression (
    dbid        INT AUTO_INCREMENT  COMMENT 'Attribute expression DBID',
    operator    TINYINT NOT NULL    COMMENT 'Expression operator enum (AND,OR,NOT,ANDNOT,ORNOT)',
    property    INT NOT NULL        COMMENT 'Property concept DBID',
    value       INT NOT NULL        COMMENT 'Concept expression DBID',

    INDEX attribute_expression_idx (dbid),

    CONSTRAINT attribute_expression_property_fk FOREIGN KEY (property) REFERENCES concept (dbid),
    CONSTRAINT attribute_expression_value_fk FOREIGN KEY (value) REFERENCES concept_expression (dbid)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS role_group;
CREATE TABLE role_group
(
    dbid        INT AUTO_INCREMENT  COMMENT 'Role group DBID',
    attribute   INT NOT NULL        COMMENT 'Attribute expression DBID',

    INDEX role_group_idx (dbid),

    CONSTRAINT role_group_attribute_fk FOREIGN KEY (attribute) REFERENCES attribute_expression (dbid)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS concept_expression_definition;
CREATE TABLE concept_expression_definition
(
    dbid        INT NOT NULL        COMMENT 'Concept expression DBID',
    class       INT                 COMMENT 'Class concept DBID',
    attribute   INT                 COMMENT 'Attribute expression dbid',
    role_group  INT                 COMMENT 'Role group dbid',
    expression  INT                 COMMENT 'Concept expression DBID',

    CONSTRAINT concept_expression_definition_class_fk FOREIGN KEY (class) REFERENCES concept (dbid),
    CONSTRAINT concept_expression_definition_attribute_fk FOREIGN KEY (attribute) REFERENCES attribute_expression (dbid),
    CONSTRAINT concept_expression_definition_group_fk FOREIGN KEY (role_group) REFERENCES role_group (dbid),
    CONSTRAINT concept_expression_definition_expression_fk FOREIGN KEY (expression) REFERENCES concept_expression (dbid)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;


DROP TABLE IF EXISTS property_domain;
CREATE TABLE property_domain
(
    status      INT NOT NULL            COMMENT 'Status concept DBID',
    concept     INT NOT NULL            COMMENT 'Concept DBID',
    property    INT NOT NULL            COMMENT 'Property concept DBID',
    minimum     INT NOT NULL DEFAULT 0  COMMENT 'Minimum occurrence count',
    maximum     INT NOT NULL DEFAULT 0  COMMENT 'Maximum occurrence count',

    INDEX property_domain_concept (concept),
    INDEX property_domain_property (property),

    CONSTRAINT property_domain_status_fk FOREIGN KEY (status) REFERENCES concept (dbid),
    CONSTRAINT property_domain_concept_fk FOREIGN KEY (concept) REFERENCES concept (dbid),
    CONSTRAINT property_domain_property_fk FOREIGN KEY (property) REFERENCES concept(dbid)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS property_range;
CREATE TABLE property_range
(
    status      INT NOT NULL        COMMENT 'Status concept DBID',
    property    INT NOT NULL        COMMENT 'Property concept DBID',
    `range`     INT NOT NULL        COMMENT 'Range concept DBID',

    PRIMARY KEY concept_range_pk (property),

    CONSTRAINT property_range_status_fk FOREIGN KEY (status) REFERENCES concept (dbid),
    CONSTRAINT property_range_property_fk FOREIGN KEY (property) REFERENCES concept (dbid),
    CONSTRAINT property_range_range_fk FOREIGN KEY (`range`) REFERENCES concept (dbid)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS data_type;
CREATE TABLE data_type
(
    status      INT NOT NULL        COMMENT 'Status concept DBID',
    data_type   INT NOT NULL        COMMENT 'Data type concept DBID',
    restriction VARCHAR(255)        COMMENT 'Allowable values (regex)',

    INDEX data_type_idx (data_type),

    CONSTRAINT data_type_status_fk FOREIGN KEY (status) REFERENCES concept (dbid),
    CONSTRAINT data_type_data_type_fk FOREIGN KEY (data_type) REFERENCES concept (dbid)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

-- ------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS value_set;
CREATE TABLE value_set
(
    dbid        INT AUTO_INCREMENT      COMMENT 'Value set DBID',
    data        JSON NOT NULL           COMMENT 'Value set definition',

    -- Exposed (know) JSON properties
    id VARCHAR(140) COLLATE utf8_bin    GENERATED ALWAYS AS (`data` ->> '$.id') STORED NOT NULL,
    name VARCHAR(255)                   GENERATED ALWAYS AS (`data` ->> '$.name') VIRTUAL,

    PRIMARY KEY value_set_pk (dbid),
    UNIQUE INDEX value_set_id (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS cohort;
CREATE TABLE cohort
(
    dbid        INT AUTO_INCREMENT      COMMENT 'Cohort DBID',
    data        JSON NOT NULL           COMMENT 'Cohort definition JSON',

    -- Exposed (know) JSON properties
    id VARCHAR(140) COLLATE utf8_bin    GENERATED ALWAYS AS (`data` ->> '$.id') STORED NOT NULL,
    name VARCHAR(255)                   GENERATED ALWAYS AS (`data` ->> '$.name') VIRTUAL,

    PRIMARY KEY cohort_pk (dbid),
    UNIQUE INDEX cohort_id (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS data_set;
CREATE TABLE data_set
(
    dbid        INT AUTO_INCREMENT      COMMENT 'Data set DBID',
    data        JSON NOT NULL           COMMENT 'Data set definition JSON',

    -- Exposed (know) JSON properties
    id VARCHAR(140) COLLATE utf8_bin    GENERATED ALWAYS AS (`data` ->> '$.id') STORED NOT NULL,
    name VARCHAR(255)                   GENERATED ALWAYS AS (`data` ->> '$.name') VIRTUAL,

    PRIMARY KEY data_set_pk (dbid),
    UNIQUE INDEX data_set_id (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS state_definition;
CREATE TABLE state_definition
(
    dbid        INT AUTO_INCREMENT      COMMENT 'State definition DBID',
    data        JSON NOT NULL           COMMENT 'State defintion JSON',

    -- Exposed (know) JSON properties
    id VARCHAR(140) COLLATE utf8_bin    GENERATED ALWAYS AS (`data` ->> '$.id') STORED NOT NULL,
    name VARCHAR(255)                   GENERATED ALWAYS AS (`data` ->> '$.name') VIRTUAL,

    PRIMARY KEY state_definition_pk (dbid),
    UNIQUE INDEX state_definition_id (id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

-- --------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS concept_term_map;
CREATE TABLE concept_term_map
(
    term      VARCHAR(250) NOT NULL,
    type      INT          NOT NULL,
    target    INT          NOT NULL,
    draft     BOOLEAN      NOT NULL DEFAULT TRUE,
    published VARCHAR(10),
    updated   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY concept_term_map_pk (term, type),
    INDEX concept_term_map_draft (draft)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS concept_tct;
CREATE TABLE concept_tct (
                             source INT NOT NULL,
                             property INT NOT NULL,
                             target INT NOT NULL,
                             level INT NOT NULL,

                             PRIMARY KEY concept_pk (source, property, target),
                             KEY concept_tct_source_property_level_idx (source, property, level),
                             KEY concept_tct_source_property_idx (source, property),
                             KEY concept_tct_property_target_idx (property, target)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS map_context;
DROP TABLE IF EXISTS map_value_node_regex;
DROP TABLE IF EXISTS map_value_node_lookup;
DROP TABLE IF EXISTS map_value_node;
DROP TABLE IF EXISTS map_node;

-- PROPERTY
CREATE TABLE map_node (
                          id          INT AUTO_INCREMENT,
                          node        VARCHAR(200),
                          concept     INT NOT NULL,
                          target      INT,
                          draft       BOOLEAN NOT NULL DEFAULT TRUE,

                          PRIMARY KEY map_node_pk (id),
                          UNIQUE INDEX map_node_uq (node)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

-- CONTEXT
CREATE TABLE map_context (
                             id          INT AUTO_INCREMENT,
                             provider    INT,
                             `system`    INT,
                             `schema`    VARCHAR(50),
                             `table`     VARCHAR(100),
                             `column`    VARCHAR(250),
                             node        INT,
                             draft       BOOLEAN NOT NULL DEFAULT TRUE,

                             PRIMARY KEY map_context_pk (id),
                             UNIQUE INDEX map_context_uq ( provider, `system`, `schema`, `table`, `column`),

                             FOREIGN KEY map_context_node_fk (node) REFERENCES map_node(id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

-- PROPERTY VALUE TYPE
CREATE TABLE map_value_node (
                                id          INT AUTO_INCREMENT,
                                node        INT NOT NULL,
                                code_scheme INT,                                    -- NOTE: NULL == Term lookup
                                function    VARCHAR(200) NOT NULL DEFAULT 'Lookup()',

                                PRIMARY KEY map_value_node_pk (id),
                                UNIQUE INDEX map_value_node_uq (node, code_scheme),

                                FOREIGN KEY map_value_node_fk (node) REFERENCES map_node(id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

-- PROPERTY VALUE TYPE LOOKUP
CREATE TABLE map_value_node_lookup (
                                       id          INT AUTO_INCREMENT,
                                       value_node  INT NOT NULL,
                                       value       VARCHAR(250),
                                       concept     INT NOT NULL,
                                       draft       BOOLEAN NOT NULL DEFAULT TRUE,

                                       PRIMARY KEY map_value_node_lookup_pk (id),
                                       UNIQUE INDEX map_value_node_lookup_uq (value_node, value),

                                       FOREIGN KEY map_value_node_lookup_node_fk(value_node) REFERENCES map_value_node(id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

-- PROPERTY VALUE TYPE REGEX
CREATE TABLE map_value_node_regex (
                                       id          INT AUTO_INCREMENT,
                                       value_node  INT NOT NULL,
                                       value       VARCHAR(250),
                                       regex       VARCHAR(250),
                                       priority    INT NOT NULL DEFAULT 0,
                                       concept     INT NOT NULL,

                                       PRIMARY KEY map_value_node_lookup_pk (id),
                                       UNIQUE INDEX map_value_node_lookup_uq (value_node, value),

                                       FOREIGN KEY map_value_node_lookup_node_fk(value_node) REFERENCES map_value_node(id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

-- CONCEPT FOREIGN KEYS
ALTER TABLE map_node
    ADD FOREIGN KEY map_node_concept_fk (concept) REFERENCES concept(dbid);

ALTER TABLE map_context
    ADD FOREIGN KEY map_context_provider_fk (provider) REFERENCES concept(dbid),
    ADD FOREIGN KEY map_context_system_fk (`system`) REFERENCES concept(dbid);

ALTER TABLE map_value_node
    ADD FOREIGN KEY map_value_node_code_scheme_fk (code_scheme) REFERENCES concept(dbid);

ALTER TABLE map_value_node_lookup
    ADD FOREIGN KEY map_value_node_lookup_concept_fk (concept) REFERENCES concept(dbid);
