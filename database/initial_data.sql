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
  (id, type, url, full_name, context, status, version, description, expression, criteria)
VALUES
  -- BASE TYPES
  (1, 1, '', 'Concept',           'Class.Concept',          0, '1.0', 'Base type for data model concepts (patient, observation, organisation, etc (aka "Record type")', null, null),
  (2, 1, '', 'Numeric',           'Class.Numeric',          0, '1.0', 'A type of field that holds a number (integer or float)', null, null),
  (3, 1, '', 'DateTime',          'Class.DateTime',         0, '1.0', 'A type of field that holds a date and time', null, null),
  (4, 1, '', 'Code',              'Class.Code',             0, '1.0', 'A field that holds a simple code', null, null),
  (5, 1, '', 'Text',              'Class.Text',             0, '1.0', 'contains a simple text value', null, null),
  (6, 1, '', 'Boolean',           'Class.Boolean',          0, '1.0', 'Ony a 1 or a zero (Y or N)', null, null),
  (7, 1, '', 'Codeable concept',  'Class.CodeableConcept',  0, '1.0', 'A field that holds a code that is a concept in the information model', null, null),
  (8, 1, '', 'Relationship',      'Class.Relationship',     0, '1.0', 'A type of relationship between two concepts', null, null),

  -- RELATIONSHIPS
  (100, 8, '', 'Is a',                     'Relationship.IsA',               0, '1.0', 'Points to target concepts that are parent types of the source concept. Equivalent t', null, null),

-- ****************************************************************************
-- * The following data is "dynamic", i.e. NOT base IM data                   *
-- ****************************************************************************

  -- PRESET CONCEPTS
  -- An *ACTUAL* property
  (1000, 1, '', 'Property',                                  'Property',                        0, '1.0', 'An actual property record type', null, null),
  (1001, 2, '', 'UPRN - Unique property reference number',   'Property.UPRN',                   0, '1.0', 'A number assigned by the ordance survey to each unique property in the UK', null, null),
  (1002, 7, '', 'Property distance approximation qualifier', 'Property.MatchQualifier',         0, '1.0', 'A description of the relationship between a property and the matched property', null, null),
  (1003, 1, '', 'Parent property to matched property',       'Property.MatchQualifier.Parent',  0, '1.0', 'The property is a parent property to the matched property (i.e. probably contains the matched propery)', null, null),
  (1004, 1, '', 'Child property to matched property',        'Property.MatchQualifier.Child',   0, '1.0', 'The property is a child of the matched property meaning that it is probably contained within the matched property such as a room number or flat', null, null),
  (1005, 1, '', 'Sibling property to matched property',      'Property.MatchQualifier.Sibling', 0, '1.0', 'The property is close to the matched property such as next door or a flat in the same building as the matched flat', null, null),
  (1006, 1, '', 'Property identifier',                       'Property.Identifier',             0, '1.0', 'Types of identifiers of properties', null, null),
  (1007, 1, '', 'Property related characteristic',           'Property.Characteristic',         0, '1.0', 'Characteristics relating to properties', null, null),
  (1008, 7, '', 'Property purpose',                          'Property.Purpose',                0, '1.0', 'The purpose of a property such as a residence or prison or care home', null, null),
  (1009, 1, '', 'Care home',                                 'Property.Purpose.CareHome',       0, '1.0', 'A property that is used as a care home', null, null)
;

INSERT INTO concept_relationship
  (source, relationship, target, `order`, mandatory, `limit`, weighting)
VALUES
  (1001, 100, 1006, 0, 0, 0, 0),  -- UPRN --> Is a --> Property identifier
  (1006, 100, 1007, 0, 0, 0, 0),  -- Property identifier --> Is a --> Property related characteristic
  (1002, 100, 1007, 0, 0, 0, 0),  -- Property match qualifier --> Is a --> Property related characteristic
  (1003, 100, 1002, 0, 0, 0, 0),  -- Parent property --> Is a --> Property approximation qualifier
  (1004, 100, 1002, 0, 0, 0, 0),  -- Child property --> Is a --> Property approximation qualifier
  (1005, 100, 1002, 0, 0, 0, 0),  -- Sibling property --> Is a --> Property approximation qualifier
  (1008, 100, 1007, 0, 0, 0, 0),  -- Property purpose --> Is a --> Property related characteristic
  (1009, 100, 1008, 0, 0, 0, 0)   -- Care home --> Is a --> Property purpose
;

INSERT INTO concept_attribute
  (concept_id, attribute_id, `order`, mandatory, `limit`)
VALUES
  (1000, 1001, 0, 0, 1),          -- Property has UPRN (0:1)
  (1000, 1008, 1, 1, 1)           -- Property has purpose (1:1)
;
#
# INSERT INTO record_type
#   (id, inherits_from)
# VALUES
#   (1000, null);
#
# INSERT INTO record_type_attribute
#   (record_type, data_type, value, mandatory, unlimited)
# VALUES
#   (1000, 1001,  5, 1, 1),
#   (1000, 1002, 10, 0, 0),
#   (1000, 1008, 10, 0, 0);
#
# INSERT INTO table_id (table_name, id)
#   SELECT 'concept', MAX(id) + 1 as id
#   FROM concept;