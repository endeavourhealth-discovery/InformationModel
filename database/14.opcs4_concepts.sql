SELECT @max := MAX(dbid)+ 1 FROM concept;
SET @qry = concat('ALTER TABLE concept AUTO_INCREMENT = ', @max);
PREPARE stmt FROM @qry;
EXECUTE stmt;

DEALLOCATE PREPARE stmt;

INSERT INTO document
(data)
VALUES
(JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/OPCS4/1.0.0'));

INSERT INTO concept(data)
VALUES (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/OPCS4/1.0.0',
                    'id', 'OPCS4',
                    'name', 'OPCS4',
                    'description', 'The OPCS4 code scheme',
                        'is_subtype_of', JSON_OBJECT(
                        'id', 'code_scheme'
                        )));

-- CONCEPTS
INSERT INTO concept (data)
SELECT JSON_OBJECT(
           'document', 'http://DiscoveryDataService/InformationModel/dm/OPCS4/1.0.0',
           'id', concat('O4_',code),
           'name', if(length(description) > 60, concat(left(description, 57), '...'), description),
           'description', description,
           'code_scheme', 'OPCS4',
           'code', code,
           'is_subtype_of', JSON_OBJECT(
               'id','codeable_concept'
               )
           )
FROM opcs4;