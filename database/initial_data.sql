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
  (1, '', 'Concept',           'Class.Concept',          0, '1.0', 'Base type for data model concepts (patient, observation, organisation, etc (aka "Record type")', null, null),
  (2, '', 'Numeric',           'Class.Numeric',          0, '1.0', 'A type of field that holds a number (integer or float)', null, null),
  (3, '', 'DateTime',          'Class.DateTime',         0, '1.0', 'A type of field that holds a date and time', null, null),
  (4, '', 'Code',              'Class.Code',             0, '1.0', 'A field that holds a simple code', null, null),
  (5, '', 'Text',              'Class.Text',             0, '1.0', 'contains a simple text value', null, null),
  (6, '', 'Boolean',           'Class.Boolean',          0, '1.0', 'Ony a 1 or a zero (Y or N)', null, null),
  (7, '', 'Codeable concept',  'Class.CodeableConcept',  0, '1.0', 'A field that holds a code that is a concept in the information model', null, null),
  (8, '', 'Relationship',      'Class.Relationship',     0, '1.0', 'A type of relationship between two concepts', null, null),

  -- RELATIONSHIPS
  (100, '', 'Is a',                     'Relationship.IsA',               0, '1.0', 'Points to target concepts that are parent types of the source concept. Equivalent t', null, null),
  (101, '', 'Has a',                    'Relationship.HasA',              0, '1.0', 'Points to a target concept that is an attribute of the source concept.', null, null),
  (102, '', 'Is type of',               'Relationship.IsTypeOf',          0, '1.0', 'The target concept is the date of the source concept', null, null),
  (103, '', 'Has value type',           'Relationship.ValueType',         0, '1.0', 'Relationship to a lower-limit concept', null, null),

-- ****************************************************************************
-- * The following data is "dynamic", i.e. NOT base IM data                   *
-- ****************************************************************************

  -- PRESET CONCEPTS
  -- An *ACTUAL* property
  (1000, '', 'Property',                                  'Property',                        0, '1.0', 'An actual property record type', null, null),
  (1001, '', 'UPRN - Unique property reference number',   'Property.UPRN',                   0, '1.0', 'A number assigned by the ordance survey to each unique property in the UK', null, null),
  (1002, '', 'Property distance approximation qualifier', 'Property.MatchQualifier',         0, '1.0', 'A description of the relationship between a property and the matched property', null, null),
  (1003, '', 'Parent property to matched property',       'Property.MatchQualifier.Parent',  0, '1.0', 'The property is a parent property to the matched property (i.e. probably contains the matched propery)', null, null),
  (1004, '', 'Child property to matched property',        'Property.MatchQualifier.Child',   0, '1.0', 'The property is a child of the matched property meaning that it is probably contained within the matched property such as a room number or flat', null, null),
  (1005, '', 'Sibling property to matched property',      'Property.MatchQualifier.Sibling', 0, '1.0', 'The property is close to the matched property such as next door or a flat in the same building as the matched flat', null, null),
  (1006, '', 'Property identifier',                       'Property.Identifier',             0, '1.0', 'Types of identifiers of properties', null, null),
  (1007, '', 'Property related characteristic',           'Property.Characteristic',         0, '1.0', 'Characteristics relating to properties', null, null),
  (1008, '', 'Property purpose',                          'Property.Purpose',                0, '1.0', 'The purpose of a property such as a residence or prison or care home', null, null),
  (1009, '', 'Care home',                                 'Property.Purpose.CareHome',       0, '1.0', 'A property that is used as a care home', null, null),

  -- Coding
  (1010, '', 'Coding system',                             'CodingSystem',                    0, '1.0', 'A system for coding terms for subsequent use in a computable manner', null, null),
  (1011, '', 'SNOMED CT',                                 'CodingSystem.Snomed',             0, '1.0', 'The SNOMED CT coding system', null, null),
  (1012, '', 'Snomed code',                               'CodingSystem.Snomed.Code',        0, '1.0', 'Snomed CT clinical code id', null, null),
  (1013, '', 'Snomed term',                               'CodingSystem.Snomed.Term',        0, '1.0', 'Snomed CT clinical code id', null, null),

  -- Haemoglobin
  (1014, '', 'Observation',                               'Observation',                     0, '1.0', 'Observation', null, null),
  (1015, '', 'Test',                                      'Test',                            0, '1.0', 'Test', null, null),
  (1016, '', 'Result',                                    'Result',                          0, '1.0', 'Result', null, null),

  (1017, '', 'Haemoglobin test',                          'HaemoglobinTest',                 0, '1.0', 'Haemoglobin test', null, null),
  (1018, '', 'Haemoglobin estimation',                    'HaemoglobinEstimation',           0, '1.0', 'Haemoglobin estimation', null, null),

  (1019, '', 'Quantity',                                  'Quantity',                        0, '1.0', 'Quantity', null, null),
  (1020, '', 'Value',                                     'Quantity.Value',                  0, '1.0', 'Quantity value', null, null),
  (1021, '', 'Comparator',                                'Quantity.Comparator',             0, '1.0', 'Quantity comparator', null, null),
  (1022, '', 'Units',                                     'Quantity.Units',                  0, '1.0', 'Quantity units', null, null),

  (1023, '', 'Unit',                                      'Unit',                            0, '1.0', 'Unit of measure', null, null),
  (1024, '', 'g/l',                                       'Unit.g/l',                        0, '1.0', 'Grams per litre', null, null),
  (1025, '', 'g/dl',                                      'Unit.g/dl',                       0, '1.0', 'Grams per decilitre', null, null),

  (1026, '', 'Numeric result',                            'Result.Numeric',                  0, '1.0', 'Numeric test result', null, null),

  (1027, '', 'Normal range',                              'NormalRange',                     0, '1.0', 'Normal range for a given gender', null, null),
  (1028, '', 'Gender',                                    'NormalRange.Gender',              0, '1.0', 'The gender for the normal range', null, null),
  (1029, '', 'Lower',                                     'NormalRange.Lower',               0, '1.0', 'The lower limit this gender', null, null),
  (1030, '', 'Upper',                                     'NormalRange.Upper',               0, '1.0', 'The upper limit this gender', null, null),

  (1031, '', 'Administrative gender',                     'Gender',                          0, '1.0', 'Administrative gender', null, null),
  (1032, '', 'Male',                                      'Gender.Male',                     0, '1.0', 'Male', null, null),
  (1033, '', 'Female',                                    'Gender.Female',                   0, '1.0', 'Female', null, null)

;

INSERT INTO concept_relationship
  (id, source, relationship, target, `order`, mandatory, `limit`, weighting)
VALUES
  (1,  1001, 100, 1006, 0, 0, 0, 0),  -- UPRN                     --> Is a --> Property identifier
  (2,  1006, 100, 1007, 0, 0, 0, 0),  -- Property identifier      --> Is a --> Property related characteristic
  (3,  1002, 100, 1007, 0, 0, 0, 0),  -- Property match qualifier --> Is a --> Property related characteristic
  (4,  1003, 100, 1002, 0, 0, 0, 0),  -- Parent property          --> Is a --> Property approximation qualifier
  (5,  1004, 100, 1002, 0, 0, 0, 0),  -- Child property           --> Is a --> Property approximation qualifier
  (6,  1005, 100, 1002, 0, 0, 0, 0),  -- Sibling property         --> Is a --> Property approximation qualifier
  (7,  1008, 100, 1007, 0, 0, 0, 0),  -- Property purpose         --> Is a --> Property related characteristic
  (8,  1009, 100, 1008, 0, 0, 0, 0),  -- Care home                --> Is a --> Property purpose

  (9,  1011, 100, 1010, 0, 0, 0, 0),  -- CodingSystem.Snomed --> Is a  --> CodingSystem
  (10, 1011, 101, 1012, 0, 1, 1, 0),  -- CodingSystem.Snomed --> Has a --> SNOMED code
  (11, 1011, 101, 1013, 1, 1, 1, 0),  -- CodingSystem.Snomed --> Has a --> SNOMED term

  (12, 1015, 102, 1014, 0, 0, 0, 0),  -- Test --> Is type of --> Observation
  (13, 1015, 101, 1016, 0, 1, 1, 0),  -- Test --> Has a      --> Result

  (14, 1018, 102, 1017, 0, 0, 0, 0),  -- Haem est --> Is type of --> Haem test
  (15, 1018, 100,    7, 0, 0, 0, 0),  -- Haem est --> Is a       --> Codeable concept

  (16, 1026, 102, 1016, 0, 0, 0, 0),  -- Numeric result --> Is type of --> Result
  (17, 1026, 101, 1019, 0, 1, 1, 0),  -- Numeric result --> Has a      --> Quantity

  (18, 1019, 101, 1020, 0, 1, 1, 0),  -- Quantity       --> Has a           --> Qty Value
  (19, 1020, 103,    2, 0, 0, 0, 0),  -- Qty Value      --> Has value type  --> Numeric
  (20, 1019, 101, 1021, 1, 0, 1, 0),  -- Quantity       --> Has a           --> Qty Comparator
  (21, 1021, 103,    5, 0, 0, 0, 0),  -- Qty Comparator --> Has value type  --> Text
  (22, 1019, 101, 1022, 2, 1, 1, 0),  -- Quantity       --> Has a           --> Qty Units
  (23, 1022, 103, 1023, 0, 0, 0, 0),  -- Qty Units      --> Has value type  --> Unit

  (24, 1024, 100, 1023, 0, 0, 0, 0),  -- g/l    --> Is a --> Unit
  (25, 1025, 100, 1023, 0, 0, 0, 0),  -- g/dl   --> Is a --> Unit

  (26, 1026, 101, 1027, 0, 0, 0, 0),  -- Numeric result   --> Has a           --> Normal range
  (27, 1027, 101, 1028, 0, 1, 1, 0),  -- Normal range     --> Has a           --> Nrml rng Gender
  (28, 1028, 103, 1031, 0, 0, 0, 0),  -- Nrml rng Gender  --> Has value type  --> Admin gender

  (29, 1027, 101, 1029, 1, 1, 1, 0),  -- Normal range     --> Has a --> Nrml rng Lower
  (30, 1029, 100, 1019, 0, 0, 0, 0),  -- Nrml rng Lower   --> Is a  --> Quantity

  (31, 1027, 101, 1030, 2, 1, 1, 0),  -- Normal range     --> Has a --> Nrml rng Upper
  (32, 1030, 100, 1019, 0, 0, 0, 0),  -- Nrml rng Upper   --> Is a  --> Quantity

  (33, 1032, 100, 1031, 0, 0, 0, 0),  -- Male    --> Is a --> Admin gender
  (34, 1033, 100, 1031, 0, 0, 0, 0)   -- Female  --> Is a --> Admin gender
;

-- ********** CONCEPT RULES **********
INSERT INTO concept_rule
  (concept_id, target_id, run_order, resource_type, ruleset)
VALUES
  (1,    1014, 0, 'Observation', '[]'),                                                                                             -- ROOT -> Obs
  (1014, 1016, 0, 'Observation', '[{"property": "category.coding.code", "comparator": "=", "value": "laboratory"}]'),               -- Obs -> Lab
  (1016, 1018, 0, 'Observation', '[{"property": "code.coding.code", "comparator": "in", "value": "1003671000000109, 443911005"}]')  -- Lab -> Haem Est. NOTE: Could skip this level and add rule to below
--  (1032, 1033, 0, 'Observation', '[{"property": "valueQuantity.unit", "comparator": "=", "value": "g/l"}]'),                        -- Haem Est. -> Haem Est. g/l
--  (1032, 1034, 1, 'Observation', '[{"property": "valueQuantity.unit", "comparator": "=", "value": "g/dl"}]'),                       -- Haem Est. -> Haem Est. g/dl

--  (1,       7, 0, 'CodeableConcept', '[]'),                                                                                         -- ROOT -> Codeable Concept
--  (7,    1032, 0, 'CodeableConcept', '[{"property": "coding.system", "comparator": "=", "value": "SnomedCT"},
--                                       {"property": "coding.code", "comparator": "in", "value": "1003671000000109"}]'),             -- Snomed 1003671000000109 -> Haem Est.
--  (7,    1032, 1, 'CodeableConcept', '[{"property": "coding.system", "comparator": "=", "value": "OPCS"},
--                                       {"property": "coding.code", "comparator": "=", "value": "12345"}]')                          -- OPCS 12345 -> Haem Est.
;