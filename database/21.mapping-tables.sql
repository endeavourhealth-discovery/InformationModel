DROP TABLE IF EXISTS map_context;
DROP TABLE IF EXISTS map_value_node_lookup;
DROP TABLE IF EXISTS map_value_node;
DROP TABLE IF EXISTS map_node;

-- PROPERTY
CREATE TABLE map_node (
    id          INT AUTO_INCREMENT,
    node        VARCHAR(200),
    concept     INT NOT NULL,
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
