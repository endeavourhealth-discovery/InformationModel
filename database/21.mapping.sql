DROP TABLE IF EXISTS map_context;
DROP TABLE IF EXISTS map_value_node_lookup;
DROP TABLE IF EXISTS map_value_node;
DROP TABLE IF EXISTS map_node;

CREATE TABLE map_node (
    id          INT AUTO_INCREMENT,
    node        VARCHAR(200),
    concept     INT NOT NULL,
    draft       BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY map_node_pk (id),
    UNIQUE INDEX map_node_uq (node)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

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

-- IM v1 Concept foreign keys

ALTER TABLE map_node
ADD FOREIGN KEY map_node_concept_fk (concept) REFERENCES concept(dbid);

ALTER TABLE map_context
ADD FOREIGN KEY map_context_provider_fk (provider) REFERENCES concept(dbid),
ADD FOREIGN KEY map_context_system_fk (`system`) REFERENCES concept(dbid);

ALTER TABLE map_value_node
ADD FOREIGN KEY map_value_node_code_scheme_fk (code_scheme) REFERENCES concept(dbid);

ALTER TABLE map_value_node_lookup
ADD FOREIGN KEY map_value_node_lookup_concept_fk (concept) REFERENCES concept(dbid);

-- IM v2 Foreign keys
/*
ALTER TABLE map_node
ADD FOREIGN KEY map_node_concept_fk (concept) REFERENCES concept(id);

ALTER TABLE map_context
ADD FOREIGN KEY map_context_provider_fk (provider) REFERENCES concept(id),
ADD FOREIGN KEY map_context_system_fk (`system`) REFERENCES concept(id);

ALTER TABLE map_node_value
ADD FOREIGN KEY map_node_value_concept_fk (concept) REFERENCES concept(id);
*/


/*
DROP TABLE IF EXISTS map_context_value;
DROP TABLE IF EXISTS map_context_table;
DROP TABLE IF EXISTS map_context;
DROP TABLE IF EXISTS map_table;
DROP TABLE IF EXISTS map_schema;
DROP TABLE IF EXISTS map_system;
DROP TABLE IF EXISTS map_organisation;

CREATE TABLE map_organisation (
    id      INT AUTO_INCREMENT,
    code    VARCHAR(100) NOT NULL,
    scheme  VARCHAR(250) NOT NULL,
    display VARCHAR(500),
    alias   VARCHAR(25) NOT NULL,
    draft   BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY map_organisation_pk (id),
    UNIQUE INDEX map_organisation_alias_uq (alias),
    INDEX map_organisation_code_scheme_idx (code, scheme)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

CREATE TABLE map_system (
    id      INT AUTO_INCREMENT,
    code    VARCHAR(100) NOT NULL,
    scheme  VARCHAR(250) NOT NULL,
    display VARCHAR(500),
    alias   VARCHAR(25) NOT NULL,
    draft   BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY map_system_pk (id),
    UNIQUE INDEX map_system_alias_uq (alias),
    INDEX map_system_code_scheme_idx (code, scheme)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

CREATE TABLE map_schema (
    id      INT AUTO_INCREMENT,
    name    VARCHAR(250) NOT NULL,
    draft   BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY map_schema_pk (id),
    INDEX map_schema_code_scheme_idx (name)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

CREATE TABLE map_table (
    id      INT AUTO_INCREMENT,
    name    VARCHAR(250) NOT NULL,
    draft   BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY map_table_pk (id),
    INDEX map_table_name_idx (name)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

CREATE TABLE map_context (
    id              INT AUTO_INCREMENT,
    organisation    INT,
    `system`        INT,
    `schema`        INT,
    draft           BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY map_context_pk (id),
    UNIQUE INDEX map_context_uq (`organisation`, `system`, `schema`),

    FOREIGN KEY map_context_org_fk (organisation) REFERENCES map_organisation(id),
    FOREIGN KEY map_context_sys_fk (`system`) REFERENCES map_system(id),
    FOREIGN KEY map_context_scm_fk (`schema`) REFERENCES map_schema(id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

CREATE TABLE map_context_table (
    id              INT AUTO_INCREMENT,
    context         INT NOT NULL,
    `table`           VARCHAR(250) NOT NULL,
    concept         INT NOT NULL,
    draft           BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY map_context_table_pk (id),
    UNIQUE INDEX map_context_table_uq (context, `table`),

    FOREIGN KEY map_context_table_context_fx (context) REFERENCES map_context(id),
    FOREIGN KEY map_context_table_concept_fk (concept) REFERENCES concept(dbid)
)  ENGINE = InnoDB
   DEFAULT CHARSET = utf8;


CREATE TABLE map_context_value (
    id              INT AUTO_INCREMENT,
    table_context   INT NOT NULL,
    value           VARCHAR(50),
    term            VARCHAR(250),
    concept         INT NOT NULL,
    draft           BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY map_context_value_pk (id),
    UNIQUE INDEX map_context_value_value_idx (table_context, value),
    UNIQUE INDEX map_context_value_term_idx (table_context, term),

    FOREIGN KEY map_context_value_context_fk (table_context) REFERENCES map_context_table(id),
    FOREIGN KEY map_context_value_concept_fk (concept) REFERENCES concept(dbid)
)  ENGINE = InnoDB
   DEFAULT CHARSET = utf8;

 */
