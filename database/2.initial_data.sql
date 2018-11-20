USE im2;

-- TODO: Need to review as many of these no longer relevant in new Information Model db schema. Commented out (until used) for clarity
-- ************************************** CORE IM DATA **************************************

-- BASE (PRIMITIVE) TYPES (super = 1)
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (1, null, 'Concept', 'Concept', 'Abstract base concept to which all concept types belong'),
       (2, 1, 'Concept.Codeable concept', 'Codeable concept', 'Any concept that can be identified as part of a taxonomy or classification'),
       (3, 1, 'Concept.Folder', 'Folder', 'A concept that contains other concepts as a place holder in a view'),
       (4, 1, 'Concept.Record Type', 'Record', 'A structure that contains attributes'),
       -- (5, 1, 'Concept.Relationship', 'Relationship', 'A concept only used in the relationship links between one concept and another, '),
       (6, 1, 'Concept.Attribute', 'Attribute', 'An attribute of a record type structure that holds a value');

-- BASE ATTRIBUTES (super = 6)
INSERT INTO concept (id, superclass, context, full_name, description)
    VALUES
       (7, 6, 'Attribute.Codeable concept', 'Codeable concept attribute', 'An attribute whose value is a code concept'),
       (8, 6, 'Attribute.Number', 'Number attribute', 'An attribute that holds a number (whole or decimal)'),
       (9, 6, 'Attribute.Whole number', 'Whole number attribute', 'An attribute that holds a whole number'),
       (10, 6, 'Attribute.Decimal number', 'Decimal number attribute', 'An attribute that holds a decimal number'),
       (11, 6, 'Attribute.Date time', 'Date time attribute', 'An attribute that holds a date and time'),
       (12, 6, 'Attribute.Text', 'Text attribute', 'An attribute that holds a free text value'),
       (13, 6, 'Attribute.Boolean', 'Boolean attribute', 'An attribute that contains a boolean value (Yes/No, True/False, Active/Inactive, etc.)');

INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (100, 6, 'Relationship.Is', 'is', 'source concept inherits the semantic meaning of the more generalised target - source is more specialised - (T2 is a Diabetes)'),
       (107, 6, 'Relationship.Parent', 'has parent', 'Source concept has parent of target');

-- RELATIONSHIPS (super = 5)
/*INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (100, 5, 'Relationship.Is', 'is', 'source concept inherits the semantic meaning of the more generalised target - source is more specialised - (T2 is a Diabetes)'),
       (101, 5, 'Relationship.Related to', 'is related to', 'The source is related to the target in an unsepecified way'),
       (102, 5, 'Relationship.Has', 'has', 'Source has an attribute type of the target'),        -- Attribute replaces
       (103, 5, 'Relationship.Qualifier', 'has qualifier', 'The source has a qualifier in relation to the concept it is related to'),
       -- (104, 5, 'Relationship.extends', 'extends', 'The source extends (inherits attributes of) the target'),       -- Superclass replaces
       (105, 5, 'Relationship.Delivers', 'Delivers', 'The source delivers the target (e.g. Organisation delivers Service)'),    -- TODO: "Provides"?
       (106, 5, 'Relationship.Uses', 'Uses', 'Org uses system'),    -- TODO: Dont like this!
       (107, 5, 'Relationship.Parent', 'has parent', 'Source concept has parent of target'),
       (108, 5, 'Relationship.Primary', 'is primary', ''), -- TODO: Should remodel, is a flag
       (109, 5, 'Relationship.Belongs', 'belongs to', 'Source belongs to target'),  -- TODO: Inverse & replace with "Has"??
       (110, 5, 'Relationship.EnteredBy', 'entered by', 'Source data entered by target'),   -- TODO: Dont like
       (111, 5, 'Relationship.IsBranded', 'is branded type of', ''),
       (112, 5, 'Relationship.PackOf', 'is pack of', '');
*/

-- FOLDERS (super = 3)
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       -- (500, 3, 'Folder.Information model', 'Information model', 'The Discovery information model is a knowledge base that describes all of the kn'),
       (502, 3, 'Folder.Attributes and Relationships', 'Attributes and Relationships', 'Groups the relationship types when navigating the information model'),
       (504, 3, 'Folder.Care administration entries', 'Care administration entries', 'Folder containing record types that hold information about care administration i'),
       (505, 3, 'Folder.Clinical record entries', 'Clinical record entries', 'Folder containing Record types that store patient clinical or personal character'),
       (506, 3, 'Folder.Care process entries', 'Care process entries', 'Structures describing care process events in relation to the patient&#44; such a'),
       (507, 3, 'Folder.Other entities', 'Health workers organisations and other entities', 'Structures that describe staff professionals organisations departments and servi'),
       (510, 3, 'Folder.Record structures', 'Record structures', 'The default view for viewing the information model'),
       (512, 3, 'Folder.Specialised record types', 'Specialised record types', 'Record types used by other entries'),
       (513, 3, 'Folder.Support structures', 'Information model support structures', 'Structures such as classes and relationships that support the model'),
       (514, 3, 'Folder.Type list', 'Type list', 'List of classes used in the model'),
       (515, 3, 'Folder.Relationships', 'Relationships', 'List of relationship types in the core model'),
       (516, 3, 'Folder.Attribute types', 'Attribute types', 'A list of attribute types used in the core model');

INSERT INTO `view` (id, name, description)
VALUES
       (1, 'Information model (auto)', 'General IM view'),
       (2, 'Restricted', 'Custom/limited IM view');

INSERT INTO view_item (`view`, concept, parent)
VALUES
       (2, 504, null),  --      Care admin
       (2, 505, null),  --      Clin Rec
       (2, 506, null),  --      Care proc
       (2, 507, null),  --      Other ents
       (2, 510, null),  --      Rec Structs
       (2, 512, 510),  --          Spec. rec.
       (2, 513, null),  --      Supp Structs
       (2, 514, 513),  --          Types
       (2, 502, 513),  --          Atts & Rels
       (2, 515, 502),  --              Relationships
       (2, 516, 502);  --              Attributes

/*
-- TO BE REPLACED BY "VIEWS"????
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`, inheritance, value_concept, value_expression, fixed_concept)
VALUE
      (3,   107, 0, 0, 1, 1, 3, 2, null),   -- Folder                  -- parent (0:1) --> Folder
      (504, 107, 0, 0, 1, 2, 3, 2, 500),    -- Care admin folder       -- parent (0:1) --> Folder = IM folder
      (505, 107, 0, 0, 1, 2, 3, 2, 500),    -- Clin rec folder         -- parent (0:1) --> Folder = IM folder
      (506, 107, 0, 0, 1, 2, 3, 2, 500),    -- Care proc. folder       -- parent (0:1) --> Folder = IM folder
      (507, 107, 0, 0, 1, 2, 3, 2, 500),    -- Other ents folder       -- parent (0:1) --> Folder = IM folder
      (510, 107, 0, 0, 1, 2, 3, 2, 500),    -- Rec. structs folder     -- parent (0:1) --> Folder = IM folder
      (512, 107, 0, 0, 1, 2, 3, 2, 510),    -- Spec. rec. types folder -- parent (0:1) --> Folder = Rec. structs folder
      (513, 107, 0, 0, 1, 2, 3, 2, 500),    -- Supp. structs folder    -- parent (0:1) --> Folder = IM folder
      (514, 107, 0, 0, 1, 2, 3, 2, 513),    -- Types folder            -- parent (0:1) --> Folder = Supp. structs folder
      (502, 107, 0, 0, 1, 2, 3, 2, 513),    -- Atts & rels folder      -- parent (0:1) --> Folder = Supp. structs folder
      (515, 107, 0, 0, 1, 2, 3, 2, 502),    -- Relationships folder    -- parent (0:1) --> Folder = Atts & rels folder
      (516, 107, 0, 0, 1, 2, 3, 2, 502);    -- Atts folder             -- parent (0:1) --> Folder = Atts & rels folder*/

/*INSERT INTO concept_relationship (source, relationship, target)
VALUES
       (504, 100, 500),    -- Care admin folder       -- is a --> IM folder
       (505, 100, 500),    -- Clin rec folder         -- is a --> IM folder
       (506, 100, 500),    -- Care proc. folder       -- is a --> IM folder
       (507, 100, 500),    -- Other ents folder       -- is a --> IM folder
       (510, 100, 500),    -- Rec. structs folder     -- is a --> IM folder
       (512, 100, 510),    -- Spec. rec. types folder -- is a --> Rec. structs folder
       (513, 100, 500),    -- Supp. structs folder    -- is a --> IM folder
       (514, 100, 513),    -- Types folder            -- is a --> Supp. structs folder
       (502, 100, 513),    -- Atts & rels folder      -- is a --> Supp. structs folder
       (515, 100, 502),    -- Relationships folder    -- is a --> Atts & rels folder
       (516, 100, 502);    -- Atts folder             -- is a --> Atts & rels folder
*/
INSERT INTO task_type (id, name)
VALUES (0, 'Attribute model'),
       (1, 'Value model'),
       (2, 'Message mappings'),
       (3, 'Term mappings');