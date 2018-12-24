USE im2;

-- TODO: Need to review as many of these no longer relevant in new Information Model db schema. Commented out (until used) for clarity
-- ************************************** CORE IM CONCEPTS **************************************

-- BASE (PRIMITIVE) TYPES (super = 1)
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (1, null, 'Concept', 'Concept', 'Abstract base concept to which all concept types belong'),
       (2, 1, 'Concept.CodedTerm', 'Coded term', 'Any concept that can be identified as part of a taxonomy or classification'),
       (3, 1, 'Concept.Folder', 'Folder', 'A concept that contains other concepts as a place holder in a view'),
       (4, 1, 'Concept.Record Type', 'Record', 'A clinical entry such as an observation or medication'),
       -- (5, 1, 'Concept.Relationship', 'Relationship', 'A concept only used in the relationship links between one concept and another, '),
       (6, 1, 'Concept.Attribute', 'Attribute', 'An attribute of a record type structure that holds a value'),
       (7, 1, 'Concept.Entity', 'Entity', 'An entity (such as a Person, Organisation, etc)');

-- BASE Types (super = 1)
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (11, 1, 'Number', 'Number data type', 'A number (whole or decimal)'),
       (12, 1, 'Whole number', 'Whole number data type', 'A whole number'),
       (13, 1, 'Decimal number', 'Decimal number data type', 'A decimal number'),
       (14, 1, 'Date time', 'Date time data type', 'A date and time'),
       (15, 1, 'Text', 'Text data type', 'A free text value'),
       (16, 1, 'Boolean', 'Boolean data type', 'A boolean value (Yes/No, True/False, Active/Inactive, etc.)');

-- BASE ATTRIBUTES (super = 6)
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (30, 1, 'Attribute.Codeable concept', 'Codeable concept attribute', 'An attribute whose value is a code concept'),
       (31, 1, 'Attribute.Number', 'Number attribute', 'An attribute that holds a number (whole or decimal)'),
       (32, 1, 'Attribute.Whole number', 'Whole number attribute', 'An attribute that holds a whole number'),
       (33, 1, 'Attribute.Decimal number', 'Decimal number attribute', 'An attribute that holds a decimal number'),
       (34, 1, 'Attribute.Date time', 'Date time attribute', 'An attribute that holds a date and time'),
       (35, 1, 'Attribute.Text', 'Text attribute', 'An attribute that holds a free text value'),
       (36, 1, 'Attribute.Boolean', 'Boolean attribute', 'An attribute that contains a boolean value (Yes/No, True/False, Active/Inactive, etc.)');


INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (100, 6, 'Relationship.Is', 'is', 'source concept inherits the semantic meaning of the more generalised target - source is more specialised - (T2 is a Diabetes)'),
       (107, 6, 'Relationship.Parent', 'has parent', 'Source concept has parent of target'),
       (110, 6, 'Relationship.Moiety', 'has moiety', ''),
       (111, 6, 'Relationship.IsBranded', 'is branded type of', ''),
       (112, 6, 'Relationship.PackOf', 'is pack of', ''),
       (113, 6, 'Relationship.Has ingredient', 'has ingredient', '');

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

-- ********** CODE SCHEMES **********
INSERT INTO concept (id, superclass, context, full_name, description, url)
VALUES
    (5300, 1,    'Code Scheme',             'Coding scheme', 'A coding scheme', null),
    (5301, 5300, 'Code Scheme.SNOMED',      'SNOMED CT',     'The SNOMED CT coding scheme', 'http://www.snomed.org'),
    (5302, 5300, 'Code Scheme.READ2',       'READ V2',       'Version 2 READ coding scheme', 'https://digital.nhs.uk/read'),
    (5303, 5300, 'Code Scheme.CTV3',        'CTV3',          'Version 3 READ coding scheme', 'https://digital.nhs.uk/ctv3'),
    (5304, 5300, 'Code Scheme.OPCS',        'OPCS',          'OPCS coding scheme', 'https://digital.nhs.uk/opcs'),
    (5305, 5300, 'Code Scheme.ICD10',       'ICD10',         'ICD10 coding scheme', 'https://icd.who.int'),
    (5306, 5300, 'Code Scheme.DM+D',        'DM+D',          'DM+D', 'https://digital.nhs.uk/dmd'),
    (5307, 5300, 'Code Scheme.Discovery',   'Discovery',     'Discovery', 'http://im.discoverydataservice.org'),
    (5308, 5300, 'Code Scheme.FHIR',        'FHIR',          'FHIR value set codes', 'http://hl7.org/fhir');

UPDATE concept
SET code_scheme=5307
WHERE code_scheme IS NULL;

ALTER TABLE concept
    MODIFY code_scheme BIGINT NOT NULL DEFAULT 5307,
    ADD UNIQUE KEY concept_code_code_scheme_idx (code, code_scheme),
    ADD CONSTRAINT concept_code_scheme_fk FOREIGN KEY (code_scheme) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ************************************** VIEWS **************************************
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

INSERT INTO task_type (id, name)
VALUES (0, 'Attribute model'),
       (1, 'Value model'),
       (2, 'Message mappings'),
       (3, 'Term mappings');

-- ********** DM+D **********
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
(5320, 2, 'DM+D.VTM',  'Virtual therapeutic moiety', ''),
(5321, 1, 'DM+D.VPI',  'Virtual product ingredient', ''),
(5322, 1, 'DM+D.CDPI', 'Controlled drug prescribing information', ''),
(5323, 1, 'DM+D.DRI',  'Drug route information', ''),
(5324, 1, 'DM+D.ODRI', 'Ontology drug form & route info', ''),
(5325, 1, 'DM+D.DFI',  'Dose form information', ''),
(5326, 2, 'DM+D.VMP',  'Virtual medicinal product', ''),
(5327, 1, 'DM+D.APE',  'Actual product excipient', ''),
(5328, 1, 'DM+D.APrI', 'Appliance product information', ''),
(5329, 1, 'DM+D.LR',   'Licensed route', ''),
(5330, 2, 'DM+D.AMP',  'Actual medicinal product', ''),
(5331, 1, 'DM+D.VCPC', 'Virtual combination pack content', ''),
(5332, 1, 'DM+D.DTCI', 'Drug tariff category info', ''),
(5333, 2, 'DM+D.VMPP', 'Virtual medicinal product pack', ''),
(5334, 1, 'DM+D.PPI',  'Product prescribing info', ''),
(5335, 1, 'DM+D.APkI', 'Appliance pack info', ''),
(5336, 1, 'DM+D.RI',   'Reimbursement info', ''),
(5337, 1, 'DM+D.MPP',  'Medicinal product price', ''),
(5338, 1, 'DM+D.ACPC', 'Actual combination pack content', ''),
(5339, 2, 'DM+D.AMPP', 'Actual medicinal product pack', '');

INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
(5326, 5320, 0, 0, 1),   -- VMP  -- (0:1) --> VTM
(5326, 5321, 1, 0, 0),   -- VMP  -- (0:*) --> VPI
(5326, 5322, 2, 0, 1),   -- VMP  -- (0:1) --> CDPI
(5326, 5323, 3, 0, 0),   -- VMP  -- (0:*) --> DRI
(5326, 5324, 4, 0, 0),   -- VMP  -- (0:*) --> ODRI
(5326, 5325, 5, 0, 1),   -- VMP  -- (0:1) --> DFI

(5330, 5327, 0, 0, 0),   -- AMP  -- (0:*) --> APE
(5330, 5328, 1, 0, 1),   -- AMP  -- (0:1) --> APrI
(5330, 5329, 2, 0, 0),   -- AMP  -- (0:*) --> LR

(5333, 5331, 0, 0, 0),   -- VMPP -- (0:*) --> VCPC
(5333, 5332, 1, 0, 1),   -- VMPP -- (0:1) --> DTCI

(5339, 5334, 0, 0, 1),   -- AMPP -- (0:1) --> PPI
(5339, 5335, 1, 0, 1),   -- AMPP -- (0:1) --> APkI
(5339, 5336, 2, 0, 1),   -- AMPP -- (0:1) --> RI
(5339, 5337, 3, 0, 1),   -- AMPP -- (0:1) --> MPP
(5339, 5338, 4, 0, 0);   -- AMPP -- (0:*) --> ACPC

-- ********************* DM+D STRUCTURE DEFINITION *********************

INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`, inheritance, value_concept, value_expression)
    VALUE
    (5330, 111, 3, 1, 1, 0, 5326, 0),
    (5333, 112, 2, 1, 1, 0, 5326, 0),
    (5339, 111, 5, 1, 1, 0, 5333, 0),
    (5339, 112, 6, 1, 1, 0, 5330, 0);
