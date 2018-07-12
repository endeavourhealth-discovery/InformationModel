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
  (101, 8, '', 'Has child',                'Relationship.HasChild',          0, '1.0', 'Points to a target concept that is a child of the source concept.', null, null),

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
  (1009, 1, '', 'Care home',                                 'Property.Purpose.CareHome',       0, '1.0', 'A property that is used as a care home', null, null),

  (1010, 1, '', 'Coding system',                             'CodingSystem',                    0, '1.0', 'A system for coding terms for subsequent use in a computable manner', null, null),
  (1011, 1, '', 'SNOMED CT',                                 'CodingSystem.Snomed',             0, '1.0', 'The SNOMED CT coding system', null, null),
  (1012, 4, '', 'Snomed code',                               'CodingSystem.Snomed.Code',        0, '1.0', 'Snomed CT clinical code id', null, null),
  (1013, 5, '', 'Snomed term',                               'CodingSystem.Snomed.Term',        0, '1.0', 'Snomed CT clinical code id', null, null),

  (1014, 1, '', 'Observation',                               'Observation',                     0, '1.0', 'Clinical observation', null, null),
  (1015, 1, '', 'Lab result',                                'Observation.Lab',                 0, '1.0', 'Observation containing a lab result', null, null),
  (1016, 1, '', 'Haemoglobin estimation',                    'HaemoglobinEstimation',           0, '1.0', 'Haemoglobin estimation', null, null),
  (1017, 1, '', 'Haemoglobin estimation (g/l)',              'HaemoglobinEstimation.G/L',       0, '1.0', 'Haemoglobin estimation (UOM = g/l)', null, null),
  (1018, 1, '', 'Haemoglobin estimation (g/dl)',             'HaemoglobinEstimation.G/DL',      0, '1.0', 'Haemoglobin estimation (UOM = g/dl)', null, null)
;

INSERT INTO concept_relationship
  (id, source, relationship, target, `order`, mandatory, `limit`, weighting)
VALUES
  (1, 1001, 100, 1006, 0, 0, 0, 0),  -- UPRN --> Is a --> Property identifier
  (2, 1006, 100, 1007, 0, 0, 0, 0),  -- Property identifier --> Is a --> Property related characteristic
  (3, 1002, 100, 1007, 0, 0, 0, 0),  -- Property match qualifier --> Is a --> Property related characteristic
  (4, 1003, 100, 1002, 0, 0, 0, 0),  -- Parent property --> Is a --> Property approximation qualifier
  (5, 1004, 100, 1002, 0, 0, 0, 0),  -- Child property --> Is a --> Property approximation qualifier
  (6, 1005, 100, 1002, 0, 0, 0, 0),  -- Sibling property --> Is a --> Property approximation qualifier
  (7, 1008, 100, 1007, 0, 0, 0, 0),  -- Property purpose --> Is a --> Property related characteristic
  (8, 1009, 100, 1008, 0, 0, 0, 0),  -- Care home --> Is a --> Property purpose
  (9, 1011, 100, 1010, 0, 0, 0, 0)   -- CodingSystem.Snomed --> Is a --> CodingSystem
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
  (concept_id, target_id, run_order, ruleset)
VALUES
  (1,    1014, 0, '[{"property": "resourceType", "comparator": "=", "value": "Observation"}]'),                      -- ROOT -> Obs
  (1014, 1015, 0, '[{"property": "category.coding.code", "comparator": "=", "value": "laboratory"}]'),               -- Obs -> Lab
  (1015, 1016, 0, '[{"property": "code.coding.code", "comparator": "in", "value": "1003671000000109, 443911005"}]'), -- Lab -> Haem Est. NOTE: Could skip this level and add rule to below
  (1016, 1017, 0, '[{"property": "valueQuantity.unit", "comparator": "=", "value": "g/l"}]'),                        -- Haem Est. -> Haem Est. g/l
  (1016, 1018, 1, '[{"property": "valueQuantity.unit", "comparator": "=", "value": "g/dl"}]')                        -- Haem Est. -> Haem Est. g/dl
;