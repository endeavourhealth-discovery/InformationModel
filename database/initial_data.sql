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
  (id, type, full_name, context, description)
VALUES
  -- BASE TYPES
  (1, 1, 'Concept',           'Class.Concept',          'Base type for data model concepts (patient, observation, organisation, etc (aka "Record type")'),
  (2, 1, 'Relationship',      'Class.Relationship',     'A type of relationship between two concepts'),
  (3, 1, 'Numeric',           'Class.Numeric',          'A type of field that holds a number (integer or float)'),
  (4, 1, 'DateTime',          'Class.DateTime',         'A type of field that holds a date and time'),
  (5, 1, 'Code',              'Class.Code',             'A field that holds a simple code'),
  (6, 1, 'Text',              'Class.Text',             'contains a simple text value'),
  (7, 1, 'Boolean',           'Class.Boolean',          'Ony a 1 or a zero (Y or N)'),
  (8, 1, 'Codeable concept',  'Class.CodeableConcept',  'A field that holds a code that is a concept in the information model'),

  -- RELATIONSHIPS
  (100, 2, 'Is a',                     'Relationship.IsA',               'Points to target concepts that are parent types of the source concept.'),
  (101, 2, 'Has a',                    'Relationship.HasA',              'Points to a target concept that is an attribute of the source concept.'),
  (102, 2, 'Extends',                  'Relationship.Extends',           'The source extends the attributes of the target'),
  (103, 2, 'Has value type',           'Relationship.ValueType',         'The target defines/restricts allowable values of the source'),
  (104, 2, 'Related to',               'Relationship.RelatedTo',         'A generalized relationship between two concepts'),
  (105, 2, 'Qualified by',             'Relationship.QualifiedBy',       'The target qualifies the meaning of the source'),

-- ****************************************************************************
-- * The following data is "dynamic", i.e. NOT base IM data                   *
-- ****************************************************************************

  -- PRESET CONCEPTS
  (1000, 1, 'Code concept',                 'CodeConcept',                                          'A core code concept'),
  (1001, 1, 'Observable entity',            'Observable',                                           'A basic observable entity'),
  (1002, 1, 'Haemotological observable',    'Observable.Haemotological',                            'An observable relating to haemotology'),
  (1003, 1, 'Haemotology test',             'Observable.Haemotological.Test',                       'A heamotological test'),
  (1004, 1, 'Haemoglobin estimation',       'Observable.Haemotological.Test.HaemoglobinEstimation', 'Haemoglobin test'),

  (1005, 1, 'Record type',                  'RecordType',                                           'Base record type'),
  (1006, 1, 'Event type',                   'EventType',                                            'Base event record type'),
  (1007, 1, 'Observation',                  'Observation',                                          'Base observation record type'),
  (1008, 1, 'Numeric observation',          'Observation.Numeric',                                  'Numeric observation'),

  (1009, 1, 'Field type',                   'FieldType',                                            'Base field type'),
  (1010, 1, 'Code field',                   'CodeField',                                            'A field containing a code'),
  (1011, 1, 'Observation code',             'ObservationCode',                                      'A code field pertaining to an observation record type'),

  (1012, 1, 'Quantity',                     'Quantity',                                             'General Quantity concept'),
  (1013, 1, 'Value',                        'Quantity.Value',                                       'The value pertaining to a quantity'),
  (1014, 1, 'Comparator',                   'Quantity.Comparator',                                  'A comparator for a quantity e.g. > 15'),
  (1015, 1, 'Units',                        'Quantity.Units',                                       'The unit of measure for a quantity'),

  (1016, 1, 'Normal range',                 'NormalRange',                                          'A normal range for a given gender'),
  (1017, 1, 'Gender',                       'NormalRange.Gender',                                   'The gender for the normal range'),
  (1018, 1, 'Lower limit',                  'NormalRange.Lower',                                    'The lower limit for a quantity'),
  (1019, 1, 'Upper limit',                  'NormalRange.Upper',                                    'The upper limit for a quantity'),

  (1020, 1, 'Gender',                       'AdministrativeGender',                                 'Administrative gender'),
  (1021, 1, 'Male',                         'AdministrativeGender.Male',                            'A male gender'),
  (1022, 1, 'Female',                       'AdministrativeGender.Female',                          'A female gender')
;

INSERT INTO concept_relationship
  (id, source, relationship, target, `order`, mandatory, `limit`)
VALUES
  ( 1, 1000, 100,    1, 0, 0, 0),     -- Code concept --> Is a --> Concept
  ( 2, 1001, 100, 1000, 0, 0, 0),     -- Obs. entity  --> Is a --> Code concept
  ( 3, 1002, 100, 1001, 0, 0, 0),     -- Haem. obs.   --> Is a --> Obs. entity
  ( 4, 1003, 100, 1002, 0, 0, 0),     -- Haem. test   --> Is a --> Haem. obs.
  ( 5, 1004, 100, 1003, 0, 0, 0),     -- Haem. test   --> Is a --> Haem. est.

  ( 6, 1005, 100,    1, 0, 0, 0),     -- Record type  --> Is a    --> Concept
  ( 7, 1006, 100, 1005, 0, 0, 0),     -- Event type   --> Is a    --> Record type
  ( 8, 1007, 102, 1006, 0, 0, 0),     -- Observation  --> Extends --> Event type
  ( 9, 1008, 102, 1007, 0, 0, 0),     -- Numeric obs. --> Extends --> Observation

  (10, 1009, 100,    1, 0, 0, 0),     -- Field type   --> Is a --> Concept
  (11, 1010, 100, 1009, 0, 0, 0),     -- Code field   --> Is a --> Field type
  (12, 1011, 100, 1010, 0, 0, 0),     -- Obs. code    --> Is a --> Code field

  (13, 1008, 101, 1012, 0, 1, 1),     -- Numeric obs. --> Has a --> Quantity
  (14, 1012, 101, 1013, 0, 1, 1),     -- Quantity     --> Has a --> Value
  (15, 1012, 101, 1014, 1, 1, 1),     -- Quantity     --> Has a --> Comparator
  (16, 1012, 101, 1015, 2, 1, 1),     -- Quantity     --> Has a --> Unit

  (17, 1016, 101, 1017, 0, 1, 1),     -- Normal rng   --> Has a --> Gender
  (18, 1016, 101, 1018, 0, 0, 1),     -- Normal rng   --> Has a --> Lower limit
  (19, 1016, 101, 1019, 0, 0, 1),     -- Normal rng   --> Has a --> Upper limit

  (20, 1017, 103, 1020, 0, 0, 0),     -- Normal rng gender --> Has value type --> Admin gender

  (21, 1018, 100, 1012, 0, 0, 0),     -- Normal rng lower  --> Is a --> Quantity
  (22, 1019, 100, 1012, 0, 0, 0),     -- Normal rng upper  --> Is a --> Quantity

  (23, 1021, 100, 1020, 0, 0, 0),     -- Male   --> Is a --> Gender
  (24, 1022, 100, 1020, 0, 0, 0)      -- Female --> Is a --> Gender
;

-- ********** CONCEPT RULES **********
/*
INSERT INTO concept_rule
  (concept_id, target_id, run_order, resource_type, ruleset)
VALUES
  (1,    1014, 0, 'Observation', '[]'),                                                                                             -- ROOT -> Obs
  (1014, 1016, 0, 'Observation', '[{"property": "category.coding.code", "comparator": "=", "value": "laboratory"}]'),               -- Obs -> Lab
  (1016, 1018, 0, 'Observation', '[{"property": "code.coding.code", "comparator": "in", "value": "1003671000000109, 443911005"}]')  -- Lab -> Haem Est. NOTE: Could skip this level and add rule to below
;
*/
