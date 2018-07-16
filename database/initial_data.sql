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
  (101, '', 'Has child',                'Relationship.HasChild',          0, '1.0', 'Points to a target concept that is a child of the source concept.', null, null),
  (102, '', 'Has date',                 'Relationship.HasDate',           0, '1.0', 'The target concept is the date of the source concept', null, null),
  (103, '', 'From',                     'Relationship.From',              0, '1.0', 'Relationship to a lower-limit concept', null, null),
  (104, '', 'To',                       'Relationship.To',                0, '1.0', 'Relationship to a upper-limit concept', null, null),
  (105, '', 'Has result',               'Relationship.HasResult',         0, '1.0', 'Points to a target that is a result of the source', null, null),
  (106, '', 'Has quantity',             'Relationship.HasQuantity',       0, '1.0', 'Points to a target concept that represents the quantity of the source', null, null),
  (107, '', 'Has value range',          'Relationship.HasRange',          0, '1.0', 'Points to a target that defines the range of the source', null, null),
  (108, '', 'Has units',                'Relationship.HasUnits',          0, '1.0', 'Points to a target concept that are the units of the source', null, null),
  (109, '', 'Has normal range',         'Relationship.HasNormalRange',    0, '1.0', 'Points to a target that denotes the normal range(s) for the source', null, null),
  (110, '', 'Has gender',               'Relationship.HasGender',         0, '1.0', 'Points to a target that defines the gender of the source', null, null),


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

  (1010, '', 'Coding system',                             'CodingSystem',                    0, '1.0', 'A system for coding terms for subsequent use in a computable manner', null, null),
  (1011, '', 'SNOMED CT',                                 'CodingSystem.Snomed',             0, '1.0', 'The SNOMED CT coding system', null, null),
  (1012, '', 'Snomed code',                               'CodingSystem.Snomed.Code',        0, '1.0', 'Snomed CT clinical code id', null, null),
  (1013, '', 'Snomed term',                               'CodingSystem.Snomed.Term',        0, '1.0', 'Snomed CT clinical code id', null, null),

  -- (Lab) Test concept
  (1014, '', 'Test',          'Test',                                     0, '1.0', 'A (laboratory) test', null, null),
  (1015, '', 'Date',          'Test.Date',                                0, '1.0', 'The date a test occurred', null, null),
  (1016, '', 'Date range',    'Test.Date.Range',                          0, '1.0', 'The range of dates for a test', null, null),
  (1017, '', 'From',          'Test.Date.Range.From',                     0, '1.0', 'The lower limit of test date range', null, null),
  (1018, '', 'To',            'Test.Date.Range.To',                       0, '1.0', 'The upper limit of test date range', null, null),
  (1019, '', 'Result',        'Result',                                   0, '1.0', 'A result (of a test)', null, null),
  (1020, '', 'Quantity',      'Result.Quantity',                          0, '1.0', 'The quantity of a result', null, null),
  (1021, '', 'Range',         'Result.Quantity.Range',                    0, '1.0', 'The actual range of values of a quantity', null, null),
  (1022, '', 'From',          'Result.Quantity.Range.From',               0, '1.0', 'The lowest value of a quantity', null, null),
  (1023, '', 'To',            'Result.Quantity.Range.To',                 0, '1.0', 'The highest value of a quantity', null, null),
  (1024, '', 'Units',         'Result.Quantity.Unit',                     0, '1.0', 'The unit of measure for a quantity', null, null),
  (1025, '', 'Normal range',  'Result.Quantity.NormalRange',              0, '1.0', 'The "normal" range for a quantity', null, null),
  (1026, '', 'Gender',        'Result.Quantity.NormalRange.Gender',       0, '1.0', 'The gender for the normal range', null, null),
  (1027, '', 'Range',         'Result.Quantity.NormalRange.Range',        0, '1.0', 'The range for the normal range', null, null),
  (1028, '', 'From',          'Result.Quantity.NormalRange.Range.From',   0, '1.0', 'The normal range lower limit', null, null),
  (1029, '', 'To',            'Result.Quantity.NormalRange.Range.To',     0, '1.0', 'The normal range upper limit', null, null),

  (1030, '', 'Observation',                               'Observation',                     0, '1.0', 'Clinical observation', null, null),
  (1031, '', 'Lab result',                                'Observation.Lab',                 0, '1.0', 'Observation containing a lab result', null, null),
  (1032, '', 'Haemoglobin estimation',                    'HaemoglobinEstimation',           0, '1.0', 'Haemoglobin estimation', null, null),
  (1033, '', 'Haemoglobin estimation (g/l)',              'HaemoglobinEstimation.G/L',       0, '1.0', 'Haemoglobin estimation (UOM = g/l)', null, null),
  (1034, '', 'Haemoglobin estimation (g/dl)',             'HaemoglobinEstimation.G/DL',      0, '1.0', 'Haemoglobin estimation (UOM = g/dl)', null, null),

  (1035, '', 'Gender',                                    'Gender',                          0, '1.0', 'Gender concept', null, null),
  (1036, '', 'Male',      'Gender.Male',    0, '1.0', 'Male', null, null),
  (1037, '', 'Female',    'Gender.Female',  0, '1.0', 'Female', null, null),

  (1039, '', 'g/l',                         'HaemoglobinEstimation.G/L.Units', 0, '1.0', 'Haemoglobin estimation (g/l) quantity units', null, null),
  (1040, '', '10-300',                      'HaemoglobinEstimation.G/L.Range', 0, '1.0', 'Haemoglobin estimation (g/l) quantity range', null, null),
  (1041, '', 'Normal range (female)',       'HaemoglobinEstimation.G/L.Normal(female)', 0, '1.0', 'Haemoglobin estimation (g/l) quantity normal range for females', null, null),
  (1042, '', '115-140',                     'HaemoglobinEstimation.G/L.Normal(female).Range', 0, '1.0', 'Haemoglobin estimation (g/l) quantity normal range values for females', null, null),

  (1043, '', 'Normal range (male)',         'HaemoglobinEstimation.G/L.Normal(male)', 0, '1.0', 'Haemoglobin estimation (g/l) quantity normal range for males', null, null),
  (1044, '', '120-140',                     'HaemoglobinEstimation.G/L.Normal(male).Range', 0, '1.0', 'Haemoglobin estimation (g/l) quantity normal range values for males', null, null),

  (1045, '', 'g/dl',                        'HaemoglobinEstimation.G/DL.Units', 0, '1.0', 'Haemoglobin estimation (g/dl) quantity units', null, null),
  (1046, '', '1-30',                        'HaemoglobinEstimation.G/DL.Range', 0, '1.0', 'Haemoglobin estimation (g/dl) quantity range', null, null),
  (1047, '', 'Normal range (female)',       'HaemoglobinEstimation.G/DL.Normal(female)', 0, '1.0', 'Haemoglobin estimation (g/dl) quantity normal range for females', null, null),
  (1048, '', '11.5-14',                     'HaemoglobinEstimation.G/DL.Normal(female).Range', 0, '1.0', 'Haemoglobin estimation (g/dl) quantity normal range values for females', null, null),

  (1049, '', 'Normal range (male)',         'HaemoglobinEstimation.G/DL.Normal(male)', 0, '1.0', 'Haemoglobin estimation (g/dl) quantity normal range for males', null, null),
  (1050, '', '12-14',                       'HaemoglobinEstimation.G/DL.Normal(male).Range', 0, '1.0', 'Haemoglobin estimation (g/dl) quantity normal range values for males', null, null)
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

  (9,  1011, 100, 1010, 0, 0, 0, 0),  -- CodingSystem.Snomed --> Is a --> CodingSystem

  (10, 1014, 102, 1015, 0, 1, 1, 0),  -- Test             --> Has date        --> Test.Date
  (11, 1015, 107, 1016, 0, 1, 1, 0),  -- Test.Date        --> Has value range --> Test.Date.Range
  (12, 1016, 103, 1017, 0, 1, 1, 0),  -- Test.Date.Range  --> From            --> Test.Date.Range.From
  (13, 1016, 104, 1018, 1, 1, 1, 0),  -- Test.Date.Range  --> To              --> Test.Date.Range.To
  (14, 1014, 105, 1019, 1, 0, 1, 0),  -- Test             --> Has result      --> Result

  (15, 1019, 106, 1020, 0, 1, 1, 0),  -- Result --> Has quantity --> Result.Quantity

  (16, 1020, 107, 1021, 0, 1, 1, 0),  -- Result.Quantity --> Has value range  --> Result.Quantity.Range
  (17, 1020, 108, 1024, 1, 1, 1, 0),  -- Result.Quantity --> Has units        --> Result.Quantity.Units
  (18, 1020, 109, 1025, 2, 1, 1, 0),  -- Result.Quantity --> Has normal range --> Result.Quantity.NormalRange

  (19, 1021, 103, 1022, 0, 1, 1, 0),  -- Result.Quantity.Range --> From --> Result.Quantity.Range.From
  (20, 1021, 104, 1023, 1, 1, 1, 0),  -- Result.Quantity.Range --> To   --> Result.Quantity.Range.To

  (21, 1025, 110, 1026, 0, 1, 1, 0),  -- Result.Quantity.NormalRange        --> Has gender      --> Result.Quantity.NormalRange.Gender
  (22, 1025, 107, 1027, 1, 1, 1, 0),  -- Result.Quantity.NormalRange        --> Has value range --> Result.Quantity.NormalRange.Range
  (23, 1027, 103, 1028, 0, 1, 1, 0),  -- Result.Quantity.NormalRange.Range  --> From            --> Result.Quantity.NormalRange.Range.From
  (24, 1027, 104, 1029, 1, 1, 1, 0),  -- Result.Quantity.NormalRange.Range  --> To              --> Result.Quantity.NormalRange.Range.To

  (25, 100, 100, 8, 0, 0, 0, 0),      -- Is a             --> Is a --> Relationship
  (26, 101, 100, 8, 0, 0, 0, 0),      -- Has child        --> Is a --> Relationship
  (27, 102, 100, 8, 0, 0, 0, 0),      -- Has date         --> Is a --> Relationship
  (28, 103, 100, 8, 0, 0, 0, 0),      -- From             --> Is a --> Relationship
  (29, 104, 100, 8, 0, 0, 0, 0),      -- To               --> Is a --> Relationship
  (30, 105, 100, 8, 0, 0, 0, 0),      -- Has result       --> Is a --> Relationship
  (31, 106, 100, 8, 0, 0, 0, 0),      -- Has quantity     --> Is a --> Relationship
  (32, 107, 100, 8, 0, 0, 0, 0),      -- Has value range  --> Is a --> Relationship
  (33, 108, 100, 8, 0, 0, 0, 0),      -- Has units        --> Is a --> Relationship
  (34, 109, 100, 8, 0, 0, 0, 0),      -- Has normal range --> Is a --> Relationship
  (35, 110, 100, 8, 0, 0, 0, 0),      -- Has gender       --> Is a --> Relationship

  (36, 1036, 100, 1035, 0, 0, 0, 0),  -- Male   --> Is a --> Gender
  (37, 1037, 100, 1035, 0, 0, 0, 0),  -- Female --> Is a --> Gender

  (38, 1032, 106, 1033, 0, 1, 1, 0),  -- Haem Est --> Has quantity --> Haem Est (g/l)
  (39, 1033, 108, 1039, 0, 1, 1, 0),  -- Haem Est (g/l) --> Has units         --> G/L
  (40, 1033, 107, 1040, 1, 1, 1, 0),  -- Haem Est (g/l) --> Has value range   --> Haem Est (g/l) range
  (41, 1033, 109, 1041, 2, 1, 1, 0),  -- Haem Est (g/l) --> Has normal range  --> Haem Est (g/l) normal (female)
  (42, 1033, 109, 1043, 3, 1, 1, 0),  -- Haem Est (g/l) --> Has normal range  --> Haem Est (g/l) normal (male)
  (43, 1041, 110, 1037, 0, 1, 1, 0),  -- Haem Est (g/l) normal (female) --> Has gender      --> Female
  (44, 1041, 107, 1042, 1, 1, 1, 0),  -- Haem Est (g/l) normal (female) --> Has value range --> 115-140
  (45, 1043, 110, 1036, 0, 1, 1, 0),  -- Haem Est (g/l) normal (male)   --> Has gender      --> Male
  (46, 1043, 107, 1044, 1, 1, 1, 0),  -- Haem Est (g/l) normal (male)   --> Has value range --> 120-140

  (47, 1032, 106, 1034, 0, 1, 1, 0),  -- Haem Est --> Has quantity --> Haem Est (g/dl)
  (48, 1034, 108, 1045, 0, 1, 1, 0),  -- Haem Est (g/dl) --> Has units         --> G/DL
  (49, 1034, 107, 1046, 1, 1, 1, 0),  -- Haem Est (g/dl) --> Has value range   --> Haem Est (g/dl) range
  (50, 1034, 109, 1047, 2, 1, 1, 0),  -- Haem Est (g/dl) --> Has normal range  --> Haem Est (g/dl) normal (female)
  (51, 1034, 109, 1049, 3, 1, 1, 0),  -- Haem Est (g/dl) --> Has normal range  --> Haem Est (g/dl) normal (male)
  (52, 1047, 110, 1037, 0, 1, 1, 0),  -- Haem Est (g/dl) normal (female) --> Has gender      --> Female
  (53, 1047, 107, 1048, 1, 1, 1, 0),  -- Haem Est (g/dl) normal (female) --> Has value range --> 11.5-14
  (54, 1049, 110, 1036, 0, 1, 1, 0),  -- Haem Est (g/dl) normal (male)   --> Has gender      --> Male
  (55, 1049, 107, 1050, 1, 1, 1, 0),  -- Haem Est (g/dl) normal (male)   --> Has value range --> 12-14
  (56, 1032, 100, 1019, 0, 0, 0, 0)   -- Haem Est --> Is a --> Result


;

INSERT INTO concept_attribute
  (id, concept_id, attribute_id, `order`, mandatory, `limit`)
VALUES
  (1, 1000, 1001, 0, 0, 1),          -- Property has UPRN (0:1)
  (2, 1000, 1008, 1, 1, 1),          -- Property has purpose (1:1)
  (3, 1011, 1012, 1, 1, 1),          -- Snomed concept has a code (1:1)
  (4, 1011, 1013, 2, 1, 1)           -- Snomed concept has a term (1:1)
;

INSERT INTO concept_value
  (id, concept_id, name)
VALUES
  (1, 1011, 'Asthma'),                      -- Snomed Asthma concept
  (2, 1011, 'Respiratory disorder')         -- Snomed Respiratory disorder concept
;

INSERT INTO concept_attribute_value
  (id, concept_value_id, attribute_id, numeric_value, text_value)
VALUES
  (1, 1, 3, 195967001, null),
  (2, 1, 4, null, 'Hyperreactive airway disease'),
  (3, 2, 3, 50043002, null),
  (4, 2, 4, null, 'Disorder of respiratory system')
;

-- ********** CONCEPT RULES **********
INSERT INTO concept_rule
  (concept_id, target_id, run_order, resource_type, ruleset)
VALUES
  (1,    1030, 0, 'Observation', '[]'),                                                                                             -- ROOT -> Obs
  (1030, 1031, 0, 'Observation', '[{"property": "category.coding.code", "comparator": "=", "value": "laboratory"}]'),               -- Obs -> Lab
  (1031, 1032, 0, 'Observation', '[{"property": "code.coding.code", "comparator": "in", "value": "1003671000000109, 443911005"}]'), -- Lab -> Haem Est. NOTE: Could skip this level and add rule to below
  (1032, 1033, 0, 'Observation', '[{"property": "valueQuantity.unit", "comparator": "=", "value": "g/l"}]'),                        -- Haem Est. -> Haem Est. g/l
  (1032, 1034, 1, 'Observation', '[{"property": "valueQuantity.unit", "comparator": "=", "value": "g/dl"}]'),                       -- Haem Est. -> Haem Est. g/dl

  (1,       7, 0, 'CodeableConcept', '[]'),                                                                                         -- ROOT -> Codeable Concept
  (7,    1032, 0, 'CodeableConcept', '[{"property": "coding.system", "comparator": "=", "value": "SnomedCT"},
                                       {"property": "coding.code", "comparator": "in", "value": "1003671000000109"}]'),             -- Snomed 1003671000000109 -> Haem Est.
  (7,    1032, 1, 'CodeableConcept', '[{"property": "coding.system", "comparator": "=", "value": "OPCS"},
                                       {"property": "coding.code", "comparator": "=", "value": "12345"}]')                          -- OPCS 12345 -> Haem Est.
;