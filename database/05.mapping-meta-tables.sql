-- Meta tables for clarity/simplicity
DROP TABLE IF EXISTS map_context_meta;
CREATE TABLE map_context_meta (
    provider    VARCHAR(150),
    `system`    VARCHAR(150),
    `schema`    VARCHAR(40),
    `table`     VARCHAR(40),
    `column`    VARCHAR(40),
    node        VARCHAR(200)
) ENGINE = Memory
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS map_node_meta;
CREATE TABLE map_node_meta(
    node    VARCHAR(200),
    concept VARCHAR(150)
) ENGINE = Memory
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS map_node_value_meta;
CREATE TEMPORARY TABLE map_node_value_meta (
    node    VARCHAR(200),
    value   VARCHAR(250),
    scheme  VARCHAR(150),
    concept VARCHAR(150)
) ENGINE = Memory
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS map_node_regex_meta;
CREATE TEMPORARY TABLE map_node_regex_meta (
    node        VARCHAR(200),
    value       VARCHAR(250),
    scheme      VARCHAR(150),
    regex       VARCHAR(250),
    priority    INT NOT NULL DEFAULT 0,
    concept     VARCHAR(150)
) ENGINE = Memory
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS map_function_value_meta;
CREATE TEMPORARY TABLE map_function_value_meta (
    node    VARCHAR(200),
    scheme  VARCHAR(150),
    `function`  VARCHAR(200)
) ENGINE = Memory
  DEFAULT CHARSET = utf8;
