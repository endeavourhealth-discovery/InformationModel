DROP TABLE IF EXISTS map_organisation;
CREATE TABLE map_organisation (
    id      INT AUTO_INCREMENT,
    code    VARCHAR(100) NOT NULL,
    scheme  VARCHAR(250) NOT NULL,
    display VARCHAR(500),
    short   VARCHAR(25) NOT NULL,
    draft   BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY map_organisation_pk (id),
    INDEX map_organisation_code_scheme_idx (code, scheme)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS map_system;
CREATE TABLE map_system (
    id      INT AUTO_INCREMENT,
    code    VARCHAR(100) NOT NULL,
    scheme  VARCHAR(250) NOT NULL,
    display VARCHAR(500),
    short   VARCHAR(25) NOT NULL,
    draft   BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY map_system_pk (id),
    INDEX map_system_code_scheme_idx (code, scheme)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS map_schema;
CREATE TABLE map_schema (
    id      INT AUTO_INCREMENT,
    code    VARCHAR(100) NOT NULL,
    scheme  VARCHAR(250) NOT NULL,
    display VARCHAR(500),
    short   VARCHAR(25) NOT NULL,
    draft   BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY map_schema_pk (id),
    INDEX map_schema_code_scheme_idx (code, scheme)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS map_table;
CREATE TABLE map_table (
    id      INT AUTO_INCREMENT,
    name    VARCHAR(250) NOT NULL,
    short   VARCHAR(25) NOT NULL,
    draft   BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY map_table_pk (id),
    INDEX map_table_name_idx (name)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS map_context_lookup;
CREATE TABLE map_context_lookup (
    id              INT AUTO_INCREMENT,
    organisation    INT,
    `system`        INT,
    `schema`        INT,
    `table`         INT,
    `context`       INT NOT NULL,
    draft           BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY map_context_lookup_pk (id),
    UNIQUE INDEX map_context_lookup_uq (`system`, `schema`, `table`, `organisation`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS map_context;
CREATE TABLE map_context (
    id              INT AUTO_INCREMENT,
    `context`       VARCHAR(110) NOT NULL,
    draft           BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY map_context_pk (id),
    UNIQUE INDEX map_context_uq (`context`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS map_context_property;
CREATE TABLE map_context_property (
    id              INT AUTO_INCREMENT,
    context         INT NOT NULL,
    property        VARCHAR(200) NOT NULL,
    concept         INT NOT NULL,
    draft           BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY map_context_property_pk (id),
    UNIQUE INDEX map_context_property_uq (context, property)
)  ENGINE = InnoDB
   DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS map_context_property_value;
CREATE TABLE map_context_property_value (
    id                  INT AUTO_INCREMENT,
    context_property    INT NOT NULL,
    value               VARCHAR(50),
    term                VARCHAR(250),
    concept             INT NOT NULL,
    draft               BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY map_context_property_value_pk (id),
    INDEX map_context_property_value_value_idx (context_property, value),
    INDEX map_context_property_value_term_idx (context_property, term)
)  ENGINE = InnoDB
   DEFAULT CHARSET = utf8;
