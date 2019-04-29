SELECT @max := MAX(dbid)+ 1 FROM concept;
SET @bcstrt := @max;
SET @qry = concat('ALTER TABLE concept AUTO_INCREMENT = ', @max);
PREPARE stmt FROM @qry;

EXECUTE stmt;

-- DOCUMENT
INSERT INTO document
(data)
VALUES
(JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/BartsCerner/1.0.0'));

-- CODE SCHEME
INSERT INTO concept(data)
VALUES (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/BartsCerner/1.0.0',
                    'id', 'BartsCerner',
                    'name', 'BartsCerner',
                    'description', 'The BartsCerner code scheme',
                    'is_subtype_of', JSON_OBJECT(
                            'id', 'CodeScheme'
                        )));

-- Barts/Cerner CONCEPTS
INSERT INTO concept (data)
SELECT JSON_OBJECT(
               'document', 'http://DiscoveryDataService/InformationModel/dm/BartsCerner/1.0.0',
               'id', concat('BC_',code),
               'name', if(length(term) > 60, concat(left(term, 57), '...'), term),
               'description', term,
               'code_scheme', 'BartsCerner',
               'code', code,
               'is_subtype_of', JSON_OBJECT(
                       'id','CodeableConcept'
                   )
           )
FROM barts_cerner;

EXECUTE stmt;

SELECT @max := MAX(dbid) FROM concept;

-- ADD DIRECT (1:1) MAPS
UPDATE concept b
    INNER JOIN (
        SELECT CONCAT('BC_', bc.code) AS id, JSON_OBJECT('is_equivalent_to', JSON_OBJECT('id', c.id)) AS equiv
        FROM barts_cerner bc
                 JOIN concept c ON c.id = CONCAT('SN_', bc.snomed_expression)
    ) t
    ON b.id = t.id
SET data = JSON_MERGE(b.data, t.equiv);

-- CREATE CORE EXPRESSION CONCEPTS
INSERT INTO concept(data)
SELECT JSON_MERGE(
               JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/Discovery/1.0.0',
                           'id', CONCAT('DS_', @max := @max + 1),
                           'name', name,
                           'description', description,
                           'is_subtype_of', JSON_OBJECT(
                                   'id', 'CodeableConcept'
                               ),
                           'SN_116680003', JSON_OBJECT(
                                   'id', is_a
                               ),
                           'snomed_expression', snomed_expression),
               atts)
           as data
FROM (
         SELECT DISTINCT
             IF(LENGTH(snomed_term) > 60, CONCAT(LEFT(snomed_term, 57), '...'), snomed_term) AS name,
             snomed_term AS description,
             CONCAT('SN_', LEFT(snomed_expression, INSTR(snomed_expression, ':')-1)) AS is_a,
             CAST(CONCAT('{"SN_',REPLACE(REPLACE(SUBSTR(snomed_expression, INSTR(snomed_expression, ':')+1), ':', '"}, "SN_'), '=', '": { "id" : "SN_'),'"} }') AS JSON) AS atts,
             snomed_expression
         FROM barts_cerner b
         WHERE snomed_expression LIKE '%:%'
         -- AND NOT EXISTS (SELECT 1 FROM concept e WHERE e.expression = b.snomed_expression)
     ) t;

EXECUTE stmt;

-- CREATE CORE COMBINED CONCEPTS
INSERT INTO concept(data)
SELECT JSON_MERGE(
               JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/Discovery/1.0.0',
                           'id', CONCAT('DS_', @max := @max + 1),
                           'name', name,
                           'description', description,
                           'is_subtype_of', JSON_OBJECT(
                                   'id', 'CodeableConcept'
                               ),
                           'snomed_expression', snomed_expression),
               is_a)
           as data
FROM (
         SELECT DISTINCT
             IF(LENGTH(snomed_term) > 60, CONCAT(LEFT(snomed_term, 57), '...'), snomed_term) AS name,
             snomed_term AS description,
             CAST(CONCAT('{"SN_116680003" : [ { "id" : "SN_', REPLACE(snomed_expression, '+', '" }, { "id" : "SN_'), '"} ] }') AS JSON) AS is_a,
             snomed_expression
         FROM barts_cerner b
         WHERE snomed_expression LIKE '%+%'
         -- AND NOT EXISTS (SELECT 1 FROM concept e WHERE e.expression = b.snomed_expression)
     ) t;

EXECUTE stmt;

SELECT @bcend := MAX(dbid) FROM concept;

-- Map to new expression based concepts above
UPDATE concept b
    INNER JOIN (
        SELECT CONCAT('BC_', bc.code) AS id, JSON_OBJECT('is_equivalent_to', JSON_OBJECT('id', c.id)) AS equiv
        FROM barts_cerner bc
                 JOIN concept c ON bc.snomed_expression = c.data ->> '$.snomed_expression'
            AND c.dbid > @bcstrt
            AND c.dbid <= @bcend
    ) t
    ON b.id = t.id
SET data = JSON_MERGE(b.data, t.equiv);

EXECUTE stmt;

DEALLOCATE PREPARE stmt;
