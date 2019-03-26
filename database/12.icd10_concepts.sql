SELECT @max := MAX(dbid) + 1
FROM concept;
SET @qry = concat('ALTER TABLE concept AUTO_INCREMENT = ', @max);
PREPARE stmt FROM @qry;
EXECUTE stmt;

DEALLOCATE PREPARE stmt;

INSERT INTO document
    (data)
VALUES (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/ICD10/1.0.0'));



INSERT INTO concept(data)
VALUES (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/ICD10/1.0.0',
                    'id', 'ICD10',
                    'name', 'ICD10',
                    'description', 'The ICD10 code scheme',
                        'is_subtype_of', JSON_OBJECT(
                        'id', 'code_scheme'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/ICD10/1.0.0',
                    'id', 'I10_modifier4',
                    'name', 'IDC10 4th character modifier suffix',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'codeable_concept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/ICD10/1.0.0',
                    'id', 'I10_modifier5',
                    'name', 'IDC10 5th character modifier suffix',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'codeable_concept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/ICD10/1.0.0',
                    'id', 'I10_qualifiers',
                    'name', 'IDC10 dual classification (asterisk codes)',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'codeable_concept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/ICD10/1.0.0',
                    'id', 'I10_gender_mask',
                    'name', 'IDC10 gender mask',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'codeable_concept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/ICD10/1.0.0',
                    'id', 'I10_min_age',
                    'name', 'IDC10 minimum age',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'codeable_concept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/ICD10/1.0.0',
                    'id', 'I10_max_age',
                    'name', 'IDC10 maximum age',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'codeable_concept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/ICD10/1.0.0',
                    'id', 'I10_tree_description',
                    'name', 'IDC10 tree description',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'codeable_concept'
                        )));

-- CONCEPTS
INSERT INTO concept (data)
SELECT JSON_OBJECT(
           'document', 'http/DiscoveryDataService/InformationModel/dm/ICD10/1.0.0',
           'id', concat('I10_', code),
           'name', if(length(description) > 60, concat(left(description, 57), '...'), description),
           'description', description,
           'code_scheme', 'ICD10',
           'code', code,
           'is_subtype_of', JSON_OBJECT(
               'id', 'codeable_concept'
               ),
           'I10_modifier4', modifier_4,
           'I10_modifier5', modifier_5,
           'I10_gender_mask', gender_mask,
           'I10_min_age', min_age,
           'I10_max_age', max_age,
           'I10_tree_description', tree_description
           )
FROM icd10;


UPDATE concept c
    INNER JOIN
    (
        SELECT CONCAT('I10_', code) AS qid,
               JSON_OBJECT(
                   'I10_qualifiers',
                   CAST(CONCAT('[{"id": "I10_', REPLACE(qualifiers, '^', '"},{"id": "I10_'), '"}]') AS JSON)
                   )                AS qual
        FROM icd10
        WHERE qualifiers <> ''
    ) t1
    ON t1.qid = c.id
SET data = JSON_MERGE(c.data, t1.qual);
