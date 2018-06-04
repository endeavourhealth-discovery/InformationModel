USE im;

INSERT INTO transaction_action
  (id, action)
VALUES
  (0, 'Create'),
  (1, 'Update'),
  (2, 'Delete');

INSERT INTO transaction_table
  (id, `table`)
VALUES
  (0, 'Concept'),
  (1, 'Message'),
  (2, 'Task'),
  (3, 'Record Type'),
  (4, 'Term Mapping'),
  (5, 'Relationship');

INSERT INTO task_type
  (id, name)
VALUES
  (0, 'Attribute Model'),
  (1, 'Value Model'),
  (2, 'Unmapped message'),
  (3, 'Unmapped terms');


-- TODO: Need to review as many of these no longer relevant in new Information Model db schema. Commented out (until used) for clarity
INSERT INTO concept
  (id, url, full_name, context, status, version, description, expression, criteria)
VALUES
  -- BASE TYPES
--  (1, '', 'Class',             'Concept.Class',          0, '1.0', 'Absctract class to which all concept types belong', null, null),
  (2, '', 'Record type',       'Class.RecordType',       0, '1.0', 'Class which has a record structure', null, null),
--  (3, '', 'Event type',        'Class.EventType',        0, '1.0', 'A broad category of event entry in a record that is attributed with a date/ time', null, null),
--  (4, '', 'Attribute group',   'Class.AttributeGroup',   0, '1.0', 'A grouping construct for attributes holding one or more attribute value pairs', null, null),
  (5, '', 'Numeric',           'Class.Numeric',          0, '1.0', 'A type of field that holds a number (integer or float)', null, null),
--  (6, '', 'DateTime',          'Class.DateTime',         0, '1.0', 'A type of field that holds a date and time', null, null),
--  (7, '', 'Code',              'Class.Code',             0, '1.0', 'A field that holds a simple code', null, null),
  (8, '', 'Text',              'Class.Text',             0, '1.0', 'contains a simple text value', null, null),
--  (9, '', 'Boolean',           'Class.Boolean',          0, '1.0', 'Ony a 1 or a zero (Y or N)', null, null),
  (10, '', 'Codeable concept',  'Class.CodeableConcept',  0, '1.0', 'A field that holds a code that is a concept in the information model', null, null),
--  (11, '', 'Folder',            'Class.Folder',           0, '1.0', 'A concept that contains other concepts as a place holder in a view', null, null),
  (12, '', 'Relationship',      'Class.Relationship',     0, '1.0', 'A concept only used in the relationship links between one concept and another, ', null, null),
--  (13, '', 'Field',             'Class.Field',            0, '1.0', 'An attribute that operates as a field in the model i.e. has values of a certain ', null, null),
--  (14, '', 'Field library',     'Class.FieldLibrary',     0, '1.0', 'A field used as a lobrary item when modelling fields', null, null),
  (15, '', 'Attribute',         'Class.Attribute',        0, '1.0', 'Type of concept that is used in an expression as the attribute name (e.g. latera', null, null),
--  (16, '', 'View',              'Class.View',             0, '1.0', 'Type of concept that is a view on a relationship type (for example the full IM n', null, null),
--  (17, '', 'Expression',        'Class.Expression',       0, '1.0', 'A concept in a record that is defined by one or more concept attributes pairings', null, null),
--  (18, '', 'Term',              'Class.Term',             0, '1.0', 'A term or phrase which then links to one or more codeable concepts', null, null),
--  (19, '', 'Linked record',     'Class.LinkedRecord',     0, '1.0', 'Indicates that the attribute is a link to a record type or event type', null, null),
--  (20, '', 'Linked field',      'Class.LinkedField',      0, '1.0', 'Indicates that the attribute is a link to a field within another record type', null, null),

  -- RELATIONSHIPS
  (100, '', 'Is a',                     'Relationship.IsA',               0, '1.0', 'Points to target concepts that are parent types of the source concept. Equivalent t', null, null),
--   (101, '', 'Inherits fields',          'Attribute.InheritsFields',       0, '1.0', 'Means that the concept C inherits the names of all fields from concept P and may', null, null),
--   (102, '', 'Has field',                'Relationship.HasField',          0, '1.0', 'Fields of a concept that is a record type', null, null),
--   (103, '', 'Has value type',           'Attribute.HasValueType',         0, '1.0', 'Fields have values of a certain class e.g. date, text,  numeric codeable concep', null, null),
--   (104, '', 'Has preferred value set',  'Attribute.HasPreferredValueSet', 0, '1.0', 'Points to one or more value sets that a field should contain', null, null),
--   (105, '', 'Has linked record type',   'Attribute.HasLinkedRecordType',  0, '1.0', 'When  field links to a different record type (e.g. an address) the record type c', null, null),
--   (106, '', 'Has linked field',         'Attribute.HasLinkedField',       0, '1.0', 'When a field links directly to a field in another record type the field it links', null, null),
--   (107, '', 'Is list',                  'Attribute.IsList',               0, '1.0', 'This field is a list field with a maximum count', null, null),
  (108, '', 'Has child',                'Relationship.HasChild',          0, '1.0', 'This concept has children in a view', null, null),

  -- FOLDERS - TODO: Not sure if still needed at all
--  (500, '', 'Information model',                                'Folder.InformationModel',                            0, '1.0', 'The Discovery information model is a knowledge base that describes all of the kn', null, null),
--  (501, '', 'Attributes and relationships',                     'Folder.AttributesAndRelationships',                  0, '1.0', 'Groups the relationship types when navigating the information model', null, null),
--  (502, '', 'Care administration entries',                      'Folder.CareAdministrationEntries',                   0, '1.0', 'Folder containing record types that hold information about care administration i', null, null),
--  (503, '', 'Clinical record entries',                          'Folder.ClinicalRecordEntries',                       0, '1.0', 'Folder containing Record types that store patient clinical or personal character', null, null),
--  (504, '', 'Care process entries',                             'Folder.CareProcessEntries',                          0, '1.0', 'Structures describing care process events in relation to the patient&#44; such a', null, null),
--  (505, '', 'Health workers organisations and other entities',  'Folder.HealthWorkersOrganisationsAndOtherEntities',  0, '1.0', 'Structures that describe staff professionals organisations departments and servi', null, null),
--  (506, '', 'Record structures',                                'Folder.RecordStructures',                            0, '1.0', 'The default view for viewing the information model', null, null),
--  (507, '', 'Specialised record types',                         'Folder.SpecialisedRecordTypes',                      0, '1.0', 'Record types used by other entries', null, null),
--  (508, '', 'Information model support structures',             'Folder.InformationModelSupportStructures',           0, '1.0', 'Structures such as classes and relationships that support the model', null, null),
--  (509, '', 'Class list',                                       'Folder.ClassList',                                   0, '1.0', 'List of classes used in the model', null, null),
--  (510, '', 'Relationships',                                    'Folder.Relationships',                               0, '1.0', 'List of relationship types in the core model', null, null),
--  (511, '', 'Attribute types',                                  'Folder.AttributeTypes',                              0, '1.0', 'A list of attribute types used in the core model', null, null),

-- ****************************************************************************
-- * The following data is "dynamic", i.e. NOT base IM data                   *
-- ****************************************************************************

  -- PRESET CONCEPTS
  -- An *ACTUAL* property
  (1000, '', 'Property',                                  'Property',                 0, '1.0', 'An actual property record type', null, null),
  (1001, '', 'UPRN - Unique property reference number',   'Property.UPRN',            0, '1.0', 'A number assigned by the ordance survey to each unique property in the UK', null, null),
  (1002, '', 'Property distance approximation qualifier', 'Property.MatchQualifier',  0, '1.0', 'A description of the relationship between a property and the matched property', null, null),
  (1003, '', 'Parent property to matched property',       'Property.Parent',          0, '1.0', 'The property is a parent property to the matched property (i.e. probably contains the matched propery)', null, null),
  (1004, '', 'Child property to matched property',        'Property.Child',           0, '1.0', 'The property is a child of the matched property meaning that it is probably contained within the matched property such as a room number or flat', null, null),
  (1005, '', 'Sibling property to matched property',      'Property.Sibling',         0, '1.0', 'The property is close to the matched property such as next door or a flat in the same building as the matched flat', null, null),
  (1006, '', 'Property identifier',                       'Property.Identifier',      0, '1.0', 'Types of identifiers of properties', null, null),
  (1007, '', 'Property related characteristic',           'Property.Characteristic',  0, '1.0', 'Characteristics relating to properties', null, null),
  (1008, '', 'Property purpose',                          'Property.Purpose',         0, '1.0', 'The purpose of a property such as a residence or prison or care home', null, null),
  (1009, '', 'Care home',                                 'Property.CareHome',        0, '1.0', 'A property that is used as a care home', null, null),
  -- ??? WHATS THE USE/PURPOSE IN THIS - IS IT == 15/Attribute? ???
  (1010, '', 'Data model concept',                        'DM',                       0, '1.0', 'The ontology covering all data within the common information model', null, null);
;

INSERT INTO concept_relationship
  (source, relationship, target, `order`, mandatory, unlimited, weighting)
VALUES
  (1001, 100, 1006, 0, 0, 0, 0),  -- UPRN --> Is a --> Property identifier
  (1006, 100, 1007, 0, 0, 0, 0),  -- Property identifier --> Is a --> Property related characteristic
  (1002, 100, 1007, 0, 0, 0, 0),  -- Property match qualifier --> Is a --> Property related characteristic
  (1003, 100, 1002, 0, 0, 0, 0),  -- Parent property --> Is a --> Property approximation qualifier
  (1004, 100, 1002, 0, 0, 0, 0),  -- Child property --> Is a --> Property approximation qualifier
  (1005, 100, 1002, 0, 0, 0, 0),  -- Sibling property --> Is a --> Property approximation qualifier
  (1008, 100, 1007, 0, 0, 0, 0),  -- Property purpose --> Is a --> Property related characteristic
  (1009, 100, 1008, 0, 0, 0, 0),  -- Care home --> Is a --> Property purpose
  -- ??? WHATS THE USE/PURPOSE IN THIS - IS IT == 15/Attribute? ???
  (1007, 100, 1010, 0, 0, 0, 0)   -- Property related characteristic --> Is a --> Data model concept
;

INSERT INTO record_type
  (id, inherits_from)
VALUES
  (1000, null);

INSERT INTO record_type_attribute
  (record_type, data_type, value, mandatory, unlimited)
VALUES
  (1000, 1001,  5, 1, 1),
  (1000, 1002, 10, 0, 0),
  (1000, 1008, 10, 0, 0);

INSERT INTO table_id (table_name, id)
  SELECT 'concept', MAX(id) + 1 as id
  FROM concept;