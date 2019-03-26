SELECT @max := ifnull(MAX(dbid), 0)+ 1 FROM concept;
SET @qry = concat('ALTER TABLE concept AUTO_INCREMENT = ', @max);
PREPARE stmt FROM @qry;
EXECUTE stmt;

DEALLOCATE PREPARE stmt;
-- Initial core concepts

INSERT INTO concept(data)
VALUES (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/Discovery/1.0.0',
                    'id', 'concept',
                    'name', 'Core concept',
                    'description', 'Base type, everything inherits from this, even itself!',
                        'is_subtype_of', JSON_OBJECT(
                        'id', 'concept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/Discovery/1.0.0',
                    'id', 'document',
                    'name', 'Document concept',
                    'description', 'A document can be thought of as a Namespace/grouping of concepts',
                        'is_subtype_of', JSON_OBJECT(
                        'id', 'concept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/Discovery/1.0.0',
                    'id', 'id',
                    'name', 'Name',
                    'description', 'Name of a concept',
                        'is_subtype_of', JSON_OBJECT(
                        'id', 'concept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/Discovery/1.0.0',
                    'id', 'description',
                    'name', 'Concept description',
                    'description', 'A detailed description of a concept/its use',
                        'is_subtype_of', JSON_OBJECT(
                        'id', 'concept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/Discovery/1.0.0',
                    'id', 'code_scheme',
                    'name', 'Code scheme',
                    'description', 'A code scheme/ontology (such as READ2, SNOMED, etc)',
                        'is_subtype_of', JSON_OBJECT(
                        'id', 'concept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/Discovery/1.0.0',
                    'id', 'code',
                    'name', 'Code',
                    'description', 'A code unique within an ontology)',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'concept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/Discovery/1.0.0',
                    'id', 'codeable_concept',
                    'name', 'Codeable concept',
                    'description', 'A code which can be assigned for clinical purposes',
                        'is_subtype_of', JSON_OBJECT(
                        'id', 'concept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/Discovery/1.0.0',
                    'id', 'relationship',
                    'name', 'Relationship',
                    'description', 'A relationship type property',
                        'is_subtype_of', JSON_OBJECT(
                        'id', 'concept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/Discovery/1.0.0',
                    'id', 'is_subtype_of',
                    'name', 'Subtype of',
                    'description', 'The concept is a sub type of another concept',
                        'is_subtype_of', JSON_OBJECT(
                        'id', 'relationship'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/Discovery/1.0.0',
                    'id', 'has_parent',
                    'name', 'Has parent',
                    'description', 'The concept has another concept as its parent, primarily used for representing hierarchies',
                        'is_subtype_of', JSON_OBJECT(
                        'id', 'relationship'
                        )));
