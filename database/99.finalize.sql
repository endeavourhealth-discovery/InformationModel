-- ************************************** IM MODEL DATA **************************************

UPDATE concept
SET code_scheme=5307
WHERE code_scheme IS NULL;

ALTER TABLE concept
MODIFY code_scheme BIGINT NOT NULL DEFAULT 5307,
ADD UNIQUE KEY concept_code_code_scheme_idx (code, code_scheme),
ADD CONSTRAINT concept_code_scheme_fk FOREIGN KEY (code_scheme) REFERENCES concept(id) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ********** PCR v2 Schema/Relational model **********
/*
-- Base concepts
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5349, 1,    'Entity', 'Entity', ''),
       (5350, 5349, 'Service', 'Service', ''),
       (5351, 1,    'System', 'System', ''),
       (5352, 5349, 'Department', 'Department', ''),
       (5353, 5349, 'Person', 'Person', ''),
       (5354, 5349, 'OrgSvcDept', 'Organisation, service or department',''),
       (5355, 5353, 'PersonInRole', 'Person in role', ''),
       (5356, 5349, 'Device', 'Device', ''),
       (5357, 7,    'EditMode', 'Edit mode', '');

-- Transaction
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5360, 4,  'Transaction', 'Transaction', ''),
       (5361, 11, 'EntryDateTime', 'Date and time of entry', ''),
       (5362, 7,  'OwningOrganisation', 'Owning organisation', ''),
       (5363, 7,  'EnteredByPerson', 'Entered by person', ''),
       (5364, 7,  'EnteredByDevice', 'Entered by device', ''),
       (5365, 7,  'TransactionMode', 'Transaction mode', ''),
       (5366, 7,  'EntryType', 'Entry type', ''),
       (5367, 7,  'EntryAttribute', 'Entry attribute', ''),
       (5368, 12, 'ReplacedEntry', 'Replaced entry', '');


INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`, inheritance, value_concept, value_expression)
VALUES
       (5360, 5361, 0, 1, 1, 0, null, null),
       (5360, 5362, 1, 1, 1, 2, 5354, 0),
       (5360, 5363, 2, 0, 1, 2, 5355, 0),
       (5360, 5364, 3, 0, 1, 2, 5356, 0),
       (5360, 5365, 4, 1, 1, 2, 5357, 1),
       (5360, 5366, 5, 1, 1, 2, 4,    1),
       (5360, 5367, 6, 0, 1, 2, 6,    1),
       (5360, 5368, 7, 0, 1, 0, null, null);

-- NHS Verification
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5370, 1, 'Status.NHSNoVerification', 'Verification status', ''),
       (5371, 7, 'Status.NHSNoVerification.Unverified', 'Unverified', ''),
       (5372, 7, 'Status.NHSNoVerification.Verified', 'Verified', '');

INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`, inheritance, value_concept, value_expression)
VALUE
      (5371, 100, 0, 1, 1, 0, 5370, 0), -- Unverified   -- is a --> Verification status
      (5372, 100, 0, 1, 1, 0, 5370, 0); -- Verified     -- is a --> Verification status

# INSERT INTO concept_relationship (source, relationship, target)
# VALUES
#        (5371, 100, 5370),   -- Unverified   -- is a --> NHS No verification status
#        (5372, 100, 5370);   -- Verified     -- is a --> NHS No verification status


-- Administrative gender TODO: Replace with SNOMED
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5375, 1, 'AdministrativeGender', 'Administrative gender', ''),
       (5376, 7, 'AdministrativeGender.Male', 'Male', ''),
       (5377, 7, 'AdministrativeGender.Female', 'Female', ''),
       (5378, 7, 'AdministrativeGender.Other', 'Other', ''),
       (5379, 7, 'AdministrativeGender.Unknown', 'Unknown', '');

INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`, inheritance, value_concept, value_expression)
VALUE
      (5376, 100, 0, 1, 1, 0, 5375, 0), -- Male     -- is a --> Gender
      (5377, 100, 0, 1, 1, 0, 5375, 0), -- Female   -- is a --> Gender
      (5378, 100, 0, 1, 1, 0, 5375, 0), -- Other    -- is a --> Gender
      (5379, 100, 0, 1, 1, 0, 5375, 0); -- Unknown  -- is a --> Gender

# INSERT INTO concept_relationship (source, relationship, target)
# VALUES
#        (5376, 100, 5375),   -- Male     -- is a --> Gender
#        (5377, 100, 5375),   -- Female   -- is a --> Gender
#        (5378, 100, 5375),   -- Other    -- is a --> Gender
#        (5379, 100, 5375);   -- Unknown  -- is a --> Gender

-- Unit of measure
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5380, 1, 'UOM', 'Unit of measure', ''),
       (5381, 7, 'UOM.g/dl', 'g/dl', 'Grams per deciliter'),
       (5382, 7, 'UOM.g/l', 'g/l', 'Grams per liter');

INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`, inheritance, value_concept, value_expression)
VALUE
      (5381, 100, 0, 1, 1, 0, 5380, 0), -- g/dl     -- is a --> UOM
      (5382, 100, 0, 1, 1, 0, 5380, 0); -- g/l      -- is a --> UOM

# INSERT INTO concept_relationship (source, relationship, target)
# VALUES
#        (5381, 100, 5380),   -- g/dl     -- is a --> UOM
#        (5382, 100, 5380);   -- g/l      -- is a --> UOM

-- Date precision
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5385, 1, 'DatePrecision', 'Date precision', ''),
       (5386, 7, 'DatePrecision.Full', 'Full date & time', 'dd-MMM-YYYY hh:mm:ss'),
       (5387, 7, 'DatePrecision.DateOnly', 'Date only', 'dd-MMM-YYYY'),
       (5388, 7, 'DatePrecision.YearMonth', 'Year and month only', 'MMM-YYYY'),
       (5389, 7, 'DatePrecision.YearOnly', 'Year only', 'YYYY');

INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`, inheritance, value_concept, value_expression)
VALUE
      (5386, 100, 0, 1, 1, 0, 5385, 0), -- Date/time   -- is a --> Date precision
      (5387, 100, 0, 1, 1, 0, 5385, 0), -- Date only   -- is a --> Date precision
      (5388, 100, 0, 1, 1, 0, 5385, 0), -- Year/month  -- is a --> Date precision
      (5389, 100, 0, 1, 1, 0, 5385, 0); -- Year only   -- is a --> Date precision

# INSERT INTO concept_relationship (source, relationship, target)
# VALUES
#        (5386, 100, 5385),   -- Date/time    -- is a --> Date precision
#        (5387, 100, 5385),   -- Date only    -- is a --> Date precision
#        (5388, 100, 5385),   -- Year/month   -- is a --> Date precision
#        (5389, 100, 5385);   -- Year only    -- is a --> Date precision

-- Address
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5400, 12, 'Address.Line1', 'First line of address', 'Usually house name/number'),
       (5401, 12, 'Address.Line2', 'Second line of address', 'Street'),
       (5402, 12, 'Address.Line3', 'Third line of address', 'Village/area'),
       (5403, 12, 'Address.Line4', 'Fourth line of address', 'Town/city'),
       (5404, 12, 'Address.PostCode', 'Post code', ''),
       (5405, 7,  'Address.UPRN', 'UPRN', ''),
       (5406, 7,  'Address.Approximation', 'UPRN approximation', 'Approximation qualifier for UPRN'),
       (5407, 7,  'Address.Type', 'Address type', 'Address type concept (e.g. prison'),
       (5408, 4,  'Address', 'Address', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5408, 5400, 0, 0, 1),   -- Address -- (0:1) --> Line 1
       (5408, 5401, 1, 0, 1),   -- Address -- (0:1) --> Line 2
       (5408, 5402, 2, 0, 1),   -- Address -- (0:1) --> Line 3
       (5408, 5403, 3, 0, 1),   -- Address -- (0:1) --> Line 4
       (5408, 5404, 4, 0, 1),   -- Address -- (0:1) --> Postcode
       (5408, 5405, 5, 0, 1),   -- Address -- (0:1) --> UPRN
       (5408, 5406, 6, 0, 1),   -- Address -- (0:1) --> UPRN Approx Qual
       (5408, 5407, 7, 0, 1);   -- Address -- (0:1) --> Type

-- Organisation
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5410, 12, 'Organisation.ODS', 'ODS Code', ''),
       (5411, 12, 'Organisation.Name', 'Name', ''),
       (5412, 13, 'Organisation.Active', 'Is active', ''),
       (5413, 7,  'Organisation.Type', 'Organisation type', ''),
       (5414, 5349,  'Organisation', 'Organisation', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5414, 5410, 0, 1, 1),   -- Org -- (1:1) --> ODS Code
       (5414, 5411, 1, 1, 1),   -- Org -- (1:1) --> Name
       (5414, 5412, 2, 1, 1),   -- Org -- (1:1) --> Active flag
       (5414, 5413, 3, 1, 1);   -- Org -- (1:1) --> Type
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`, inheritance, value_concept, value_expression)
VALUES
       (5414, 105, 4, 1, 0, 0, 5350, 0),  -- Org -- Delivers (1:*) --> Service
       (5414, 106, 5, 1, 0, 0, 5351, 0),  -- Org -- Uses (1:*) --> System
       (5414, 107, 6, 0, 0, 0, 5414, 0),  -- Org -- Has parent (0:1) --> Parent org
       (5414, 102, 5420, 3, 0, 0),  -- Org -- Has (0:*) --> Location (qualifier = Main/None)

       INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
    VALUES
    (5414, 105, 5350, 0, 1, 0),  -- Org -- Delivers (1:*) --> Service
       (5414, 106, 5351, 1, 1, 0),  -- Org -- Uses (1:*) --> System
       (5414, 107, 5414, 2, 0, 1),  -- Org -- Has parent (0:1) --> Parent org
       (5414, 102, 5420, 3, 0, 0),  -- Org -- Has (0:*) --> Location (qualifier = Main/None)
       (5414, 102, 5486, 4, 0, 0),  -- Org -- Has (0:*) --> Prompt
       (5414, 102, 5434, 5, 0, 0),  -- Org -- Has (0:*) --> Practitioner
       (5414, 102, 5458, 6, 0, 0);  -- Org -- Has (0:*) --> Patient

-- Location
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5415, 12, 'Location.Name', 'Name', ''),
       (5416, 7,  'Location.Type', 'Location type', ''),
       (5417, 11, 'Location.Start', 'Start date', ''),
       (5418, 11, 'Location.End', 'End date', ''),
       (5419, 13, 'Location.Active', 'Is active', ''),
       (5420, 4,  'Location', 'Location', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5420, 5415, 0, 1, 1),   -- Location -- (1:1) --> Name
       (5420, 5416, 1, 1, 1),   -- Location -- (1:1) --> Type
       (5420, 5417, 2, 1, 1),   -- Location -- (1:1) --> Start date
       (5420, 5418, 3, 0, 1),   -- Location -- (0:1) --> End date
       (5420, 5419, 4, 1, 1);   -- Location -- (1:1) --> Active flag

-- Location contact
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5421, 7,  'Location.Contact.Type', 'Contact type', ''),
       (5422, 12, 'Location.Contact.Details', 'Contact details', ''),
       (5423, 4,  'Location.Contact', 'Location contact', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5423, 5421, 0, 1, 1),   -- Location contact -- (1:1) --> Type
       (5423, 5422, 1, 1, 1);   -- Location contact -- (1:1) --> Details

-- Practitioner
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5425, 12, 'Practitioner.Title', 'Title', ''),
       (5426, 12, 'Practitioner.FirstName', 'First name', ''),
       (5427, 12, 'Practitioner.MiddleNames', 'Middle names(s)', ''),
       (5428, 12, 'Practitioner.LastName', 'Last name', ''),
       (5429, 7,  'Practitioner.Gender', 'Gender', ''),
       (5430, 11, 'Practitioner.BirthDate', 'Date of birth', ''),
       (5431, 13, 'Practitioner.Active', 'Is active', ''),
       (5432, 7,  'Practitioner.Role', 'Role', ''),
       (5433, 7,  'Practitioner.Speciality', 'Speciality', ''),
       (5434, 4,  'Practitioner', 'Practitioner', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5434, 5425, 0, 0, 1),   -- Practitioner -- (0:1) --> Title
       (5434, 5426, 1, 0, 1),   -- Practitioner -- (0:1) --> First name
       (5434, 5427, 2, 0, 1),   -- Practitioner -- (0:1) --> Middle name(s)
       (5434, 5428, 3, 1, 1),   -- Practitioner -- (1:1) --> Last name
       (5434, 5429, 4, 0, 1),   -- Practitioner -- (0:1) --> Gender
       (5434, 5430, 5, 0, 1),   -- Practitioner -- (0:1) --> Date of birth
       (5434, 5431, 6, 1, 1),   -- Practitioner -- (1:1) --> Active flag
       (5434, 5432, 7, 0, 1),   -- Practitioner -- (0:1) --> Role
       (5434, 5433, 8, 0, 1);   -- Practitioner -- (0:1) --> Speciality

-- Practitioner contact
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5435, 7,  'Practitioner.Contact.Type', 'Contact type', ''),
       (5436, 12, 'Practitioner.Contact.Details', 'Contact details', ''),
       (5437, 4,  'Practitioner.Contact', 'Practitioner contact', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5437, 5435, 0, 1, 1),   -- Practitioner contact -- (1:1) --> Type
       (5437, 5436, 1, 1, 1);   -- Practitioner contact -- (1:1) --> Details

-- Practitioner identifier
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5438, 7,  'Practitioner.Id.Type', 'ID Type' ,''),
       (5439, 12, 'Practitioner.Id.Value', 'ID Value', ''),
       (5440, 4,  'Practitioner.Id', 'Practitioner ID', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5440, 5438, 0, 1, 1),   -- Practitioner ID -- (1:1) --> ID type
       (5440, 5439, 1, 1, 1);   -- Practitioner ID -- (1:1) --> ID value

-- Patient
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5445, 12, 'Patient.NHSNumber', 'NHS number', ''),
       (5446, 7,  'Patient.NHSStatus', 'NHS number verification status', ''),
       (5447, 11, 'Patient.BirthDate', 'Date of birth', ''),
       (5448, 11, 'Patient.DeathDate', 'Date of death', ''),
       (5449, 7,  'Patient.Gender', 'Gender', ''),
       (5450, 12, 'Patient.Title', 'Title', ''),
       (5451, 12, 'Patient.FirstName', 'First name', ''),
       (5452, 12, 'Patient.MiddleNames', 'Middle name(s)', ''),
       (5453, 12, 'Patient.LastName', 'Last name', ''),
       (5454, 12, 'Patient.PreviousLastName', 'Previous last name', ''),
       (5455, 13, 'Patient.IsSpineSensitive', 'Is spine sensitive', ''),
       (5456, 11, 'Patient.DateAdded', 'Date added', ''),
       (5457, 11, 'Patient.DateEntered', 'Date entered', ''),
       (5458, 4,  'Patient', 'Patient', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`, value_expression, value_concept)
VALUES
       (5458, 5445, 0,  1, 1, 0, 12),   -- Patient -- (1:1) --> NHS Number (text) TODO: Text or Text attribute?
       (5458, 5446, 1,  1, 1, 1, 5370), -- Patient -- (1:1) --> NHS Number status (child of NHS Verification status)
       (5458, 5447, 2,  0, 1, 0, 11),   -- Patient -- (0:1) --> Birth date (date)
       (5458, 5448, 3,  0, 1, 0, 11),   -- Patient -- (0:1) --> Death date (date)
       (5458, 5449, 4,  0, 1, 1, 5375), -- Patient -- (0:1) --> Gender (child of Administrative gender)
       (5458, 5450, 4,  0, 1, 0, 12),   -- Patient -- (0:1) --> Title (text)
       (5458, 5451, 5,  0, 1, 0, 12),   -- Patient -- (0:1) --> First name (text)
       (5458, 5452, 6,  0, 1, 0, 12),   -- Patient -- (0:1) --> Middle name(s) (text)
       (5458, 5453, 7,  1, 1, 0, 12),   -- Patient -- (1:1) --> Last name (text)
       (5458, 5454, 8,  0, 0, 0, 12),   -- Patient -- (0:*) --> Previous last name(s) (text)
       (5458, 5455, 9,  1, 1, 0, 13),   -- Patient -- (1:1) --> Is spine sensitive (boolean)
       (5458, 5456, 10, 1, 1, 0, 11),   -- Patient -- (1:1) --> Date added (date)
       (5458, 5457, 11, 1, 1, 0, 11);   -- Patient -- (1:1) --> Date entered (date)

-- Patient address
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5460, 7,  'Patient.Address.Type', 'Type', ''),
       (5461, 11, 'Patient.Address.StartDate', 'Start date', ''),
       (5462, 11, 'Patient.Address.EndDate', 'End date', ''),
       (5463, 4,  'Patient.Address', 'Patient address', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5463, 5460, 0, 1, 1),    -- Patient address -- (1:1) --> Address type
       (5463, 5461, 1, 1, 1),    -- Patient address -- (1:1) --> Start date
       (5463, 5462, 2, 0, 1);    -- Patient address -- (0:1) --> End date

-- Patient contact
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5465, 7,  'Patient.Contact.Type', 'Type', 'Type of contact (home phone, mobile, email)'),
       (5466, 12, 'Patient.Contact.Value', 'Value', 'Actual number, email address, etc.'),
       (5467, 4,  'Patient.Contact', 'Patient contact', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5467, 5465, 0, 1, 1),    -- Patient contact -- (1:1) --> Type
       (5467, 5466, 1, 1, 1);    -- Patient contact -- (1:1) --> Value

-- Patient identifier
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5470, 7,  'Patient.Id.Type', 'Type', 'Hospital number, patient number, MRN, etc'),
       (5471, 12, 'Patient.Id.Value', 'Value', 'The actual identifier value'),
       (5472, 4,  'Patient.Id', 'Patient Id', 'Patient identifier (other than NHS number)');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5472, 5470, 0, 1, 1),    -- Patient Id -- (1:1) --> Type
       (5472, 5471, 1, 1, 1);    -- Patient Id -- (1:1) --> Value

-- Additional attributes
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
    -- Attribute -> Target is relationship (item type/id)
       (5475, 7,  'Attribute.Type', 'Type', 'The name/field/label for the attribute'),
       (5476, 8,  'Attribute.Value', 'Value', 'The numeric value for the attribute'),
       (5477, 11, 'Attribute.Date', 'Date', 'The date value for the attribute'),
       (5478, 12, 'Attribute.Text', 'Text', 'The text value for the attribute'),
       (5479, 7,  'Attribute.Concept', 'Concept', 'The concept value for the attribute'),
       (5480, 13, 'Attribute.IsConsent', 'Consent', 'Whether consent or dissent'),
       (5481, 4,  'Attribute', 'Attribute', 'Additional table/field attribute');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5481, 5475, 0, 0, 1),   -- Attribute (0:1) --> name/field/label concept
       (5481, 5476, 1, 0, 1),   -- Attribute (0:1) --> Numeric value
       (5481, 5477, 2, 0, 1),   -- Attribute (0:1) --> Date value
       (5481, 5478, 3, 0, 1),   -- Attribute (0:1) --> Text value
       (5481, 5479, 4, 0, 1),   -- Attribute (0:1) --> Concept value
       (5481, 5480, 5, 1, 1);   -- Attribute (1:1) --> Consent

-- TODO: Additional relationship?!?!?

-- Data entry prompt
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5485, 12, 'Prompt.Text', 'Text', ''),
       (5486, 4,  'Prompt', 'Prompt', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5486, 5485, 0, 1, 1);   -- Prompt (1:1) --> Text

-- Appointment schedule
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5495, 12, 'AppointmentSchedule.Description', 'Description', ''),
       (5496, 7,  'AppointmentSchedule.Type', 'Type', ''),
       (5497, 7,  'AppointmentSchedule.Speciality', 'Speciality', ''),
       (5498, 11, 'AppointmentSchedule.Start', 'Start', ''),
       (5499, 11, 'AppointmentSchedule.End', 'End', ''),
       (5500, 4,  'AppointmentSchedule', 'Appointment schedule', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5500, 5495, 0, 0, 1),   -- Appointment schedule (0:1) --> Description
       (5500, 5496, 1, 0, 1),   -- Appointment schedule (0:1) --> Type
       (5500, 5497, 2, 0, 1),   -- Appointment schedule (0:1) --> Speciality
       (5500, 5498, 3, 0, 1),   -- Appointment schedule (0:1) --> Start
       (5500, 5499, 4, 0, 1);   -- Appointment schedule (0:1) --> End

-- Appointment slot
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5505, 11, 'AppointmentSlot.Start', 'Start', ''),
       (5506, 11, 'AppointmentSlot.End', 'End', ''),
       (5507, 8,  'AppointmentSlot.Duration', 'Planned duration', ''),
       (5508, 7,  'AppointmentSlot.Type', 'Type', ''),
       (5509, 7,  'AppointmentSlot.Interaction', 'Interaction', ''),
       (5510, 4,  'AppointmentSlot', 'Appointment slot', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5510, 5505, 0, 0, 1),   -- Appointment slot (0:1) --> Start
       (5510, 5506, 1, 0, 1),   -- Appointment slot (0:1) --> End
       (5510, 5507, 2, 0, 1),   -- Appointment slot (0:1) --> Duration
       (5510, 5508, 3, 0, 1),   -- Appointment slot (0:1) --> Type
       (5510, 5509, 4, 0, 1);   -- Appointment slot (0:1) --> Interaction

-- Appointment booking
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5515, 11, 'Booking.Time', 'Booking tme', ''),
       (5516, 7,  'Booking.State', 'State', 'The state of the slot (booked, reserved, free, etc.)'),
       (5517, 12, 'Booking.Reason', 'Reason', 'Patients reason for booking the appointment'),
       (5518, 4,  'Booking', 'Booking', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5518, 5515, 0, 1, 1),   -- Booking (1:1) --> Time
       (5518, 5516, 1, 1, 1),   -- Booking (1:1) --> State
       (5518, 5517, 2, 0, 1);   -- Booking (0:1) --> Reason

-- Appointment attendance
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5520, 11, 'Attendance.Start', 'Start time', ''),
       (5521, 11, 'Attendance.End', 'End time', ''),
       (5522, 7,  'Attendance.Status', 'Status', 'Status concept (finished, DNA, etc)'),
       (5523, 4,  'Attendance', 'Attendance', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5523, 5520, 0, 1, 1),   -- Attendance (1:1) --> Start
       (5523, 5521, 1, 0, 1),   -- Attendance (0:1) --> End
       (5523, 5522, 2, 0, 1);   -- Attendance (0:1) --> Status

-- Appointment attendance event
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5525, 11, 'Attendance.Event.Time', 'Event time', ''),
       (5526, 7,  'Attendance.Event.Status', 'Status', 'Status concept (arrived, sent in, etc'),
       (5527, 4,  'Attendance.Event', 'Attendance event', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5527, 5525, 0, 1, 1),   -- Event (1:1) --> Time
       (5527, 5526, 1, 1, 1);   -- Event (1:1) --> Status

-- Registration status
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5530, 11, 'RegistrationStatus.EffectiveDate', 'Effective date', 'Clinically significant date/time'),
       (5531, 8,  'RegistrationStatus.EffectiveDatePrecision', 'Effective date precision', 'Qualifies the effective date for display'),
       (5532, 11, 'RegistrationStatus.InsertDate', 'Insertion date', 'Date actually inserted'),
       (5533, 11, 'RegistrationStatus.EnteredDate', 'Entered date', ''),
       (5534, 11, 'RegistrationStatus.EndDate', 'End date', ''),
       (5535, 7,  'RegistrationStatus.Type', 'Registration type', 'Registration type concept'),
       (5536, 7,  'RegistrationStatus.Status', 'Registration status', 'Registration status concept (registered, deducted, etc.)'),
       (5537, 7,  'RegistrationStatus.SubStatus', 'Registration sub status', 'Secondary status information (e.g. deducttion type - enlistment'),
       (5538, 13, 'RegistrationStatus.IsCurrent', 'Current status', ''),
       (5539, 4,  'RegistrationStatus', 'Registration status', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5539, 5530, 0, 1, 1),   -- Status (1:1) --> Effective date
       (5539, 5531, 1, 1, 1),   -- Status (1:1) --> Effective date precision
       (5539, 5532, 2, 1, 1),   -- Status (1:1) --> Insert date
       (5539, 5533, 3, 1, 1),   -- Status (1:1) --> Entered date
       (5539, 5534, 4, 0, 1),   -- Status (0:1) --> End date
       (5539, 5535, 5, 0, 1),   -- Status (0:1) --> Type
       (5539, 5536, 6, 1, 1),   -- Status (1:1) --> Status
       (5539, 5537, 7, 0, 1),   -- Status (0:1) --> Sub status
       (5539, 5538, 8, 1, 1);   -- Status (1:1) --> Is current

-- Care episode
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5540, 11, 'CareEpisode.EffectiveDate', 'Effective date', ''),
       (5541, 8,  'CareEpisode.EffectiveDatePrecision', 'Effective date precision', ''),
       (5542, 11, 'CareEpisode.InsertDate', 'Insert date', ''),
       (5543, 11, 'CareEpisode.EnteredDate', 'Entered date', ''),
       (5544, 11, 'CareEpisode.EndDate', 'End date', ''),
       (5545, 4,  'CareEpisode', 'Care episode', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5545, 5540, 0, 1, 1),   -- Episode (1:1) --> Effective date
       (5545, 5541, 1, 1, 1),   -- Episode (1:1) --> Effective date precision
       (5545, 5542, 2, 1, 1),   -- Episode (1:1) --> Insert date
       (5545, 5543, 3, 1, 1),   -- Episode (1:1) --> Entered date
       (5545, 5544, 4, 0, 1);   -- Episode (0:1) --> End date

-- Care episode status
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5550, 11, 'CareEpisode.Status.Start', 'Start time', ''),
       (5551, 11, 'CareEpisode.Status.End', 'End time', ''),
       (5552, 7,  'CareEpisode.Status.Status', 'Status', ''),
       (5553, 4,  'CareEpisode.Status', 'Care episode status', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5553, 5550, 0, 1, 1),   -- Episode status (1:1) --> Start
       (5553, 5551, 1, 0, 1),   -- Episode status (0:1) --> End
       (5553, 5552, 2, 1, 1);   -- Episode status (1:1) --> Status

-- GP Consultation
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5555, 11, 'Consultation.EffectiveDate', 'Effective date', ''),
       (5556, 8,  'Consultation.EffectiveDatePrecision', 'Effective date precision', ''),
       (5557, 11, 'Consultation.InsertDate', 'Insert date', ''),
       (5558, 11, 'Consultation.EnteredDate', 'Entered date', ''),
       (5559, 13, 'Consultation.IsConfidential', 'Is confidential', ''),
       (5560, 8,  'Consultation.Duration', 'Duration', 'Duration of consultation in minutes'),
       (5561, 8,  'Consultation.TravelTime', 'Travel time', 'Healthcare worker travel time in minutes'),
       (5562, 7,  'Consultation.Reason', 'Reason', 'Consultation reason concept'),
       (5563, 7,  'Consultation.Purpose', 'Purpose', 'Consultation purpose concept (diabetic review, etc)'),
       (5564, 13, 'Consultation.IsConsent', 'Consent', ''),
       (5565, 4,  'Consultation', 'Consultation', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5565, 5555, 0, 1, 1),   -- Consultation (1:1) --> Effective date
       (5565, 5556, 1, 1, 1),   -- Consultation (1:1) --> Effective date precision
       (5565, 5557, 2, 1, 1),   -- Consultation (1:1) --> Insert date
       (5565, 5558, 3, 1, 1),   -- Consultation (1:1) --> Entered date
       (5565, 5559, 4, 1, 1),   -- Consultation (1:1) --> Confidential
       (5565, 5560, 5, 0, 1),   -- Consultation (0:1) --> Duration
       (5565, 5561, 6, 0, 1),   -- Consultation (0:1) --> Travel time
       (5565, 5562, 7, 0, 1),   -- Consultation (0:1) --> Reason
       (5565, 5563, 8, 0, 1),   -- Consultation (0:1) --> Purpose
       (5565, 5564, 9, 1, 1);   -- Consultation (1:1) --> Consent

-- Hospital encounter
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5570, 11, 'Encounter.StartDate', 'Start date', ''),
       (5571, 11, 'Encounter.EndDate', 'End date', ''),
       (5572, 11, 'Encounter.InsertDate', 'Insert date', ''),
       (5573, 11, 'Encounter.EnteredDate', 'Entered date', ''),
       (5574, 7,  'Encounter.Status', 'Status', 'Encounter status concept (temporary, active, discharged, etc)'),
       (5575, 7,  'Encounter.Speciality', 'Speciality', ''),
       (5576, 7,  'Encounter.AdminCategory', 'Administrative category', ''),
       (5577, 7,  'Encounter.Reason', 'Reason', ''),
       (5578, 7,  'Encounter.Type', 'Type', 'Encounter type (inpatient, outpatient, etc)'),
       (5579, 13, 'Encounter.IsConsent', 'Consent flag', ''),
       (5580, 4,  'Encounter', 'Hospital encounter', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5580, 5570, 0, 1, 1),   -- Encounter (1:1) Start date
       (5580, 5571, 1, 0, 1),   -- Encounter (0:1) End date
       (5580, 5572, 2, 1, 1),   -- Encounter (1:1) Insert date
       (5580, 5573, 3, 1, 1),   -- Encounter (1:1) Entered date
       (5580, 5574, 4, 1, 1),   -- Encounter (1:1) Status
       (5580, 5575, 5, 0, 1),   -- Encounter (0:1) Speciality
       (5580, 5576, 6, 0, 1),   -- Encounter (0:1) Admin category
       (5580, 5577, 7, 0, 1),   -- Encounter (0:1) Reason
       (5580, 5578, 8, 0, 1),   -- Encounter (0:1) Type
       (5580, 5579, 9, 1, 1);   -- Encounter (1:1) Consent

-- A&E attendance
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5585, 11, 'A&E.ArrivalDate', 'Arrival date', ''),
       (5586, 11, 'A&E.EffectiveDate', 'Effective date', ''),
       (5587, 11, 'A&E.TriageStart', 'Triage start', ''),
       (5588, 11, 'A&E.TriageEnd', 'Triage end', ''),
       (5589, 11, 'A&E.EndDate', 'End date', ''),
       (5590, 11, 'A&E.InsertDate', 'Insert date', ''),
       (5591, 11, 'A&E.EnteredDate', 'Entered date', ''),
       (5592, 7,  'A&E.Status', 'Status', 'Attendance status (active, final, pending, etc)'),
       (5593, 13, 'A&E.IsConfidential', 'Is confidential', ''),
       (5594, 7,  'A&E.Reason', 'Reason', ''),
       (5595, 12, 'A&E.description', 'Description', ''),
       (5596, 12, 'A&E.AmbulanceNumber', 'Ambulance number', ''),
       (5597, 13, 'A&E.IsConsent', 'Consent', ''),
       (5598, 4,  'A&E', 'A&E Attendance', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5598, 5585, 0,  1, 1),   -- A&E (1:1) --> Arrival
       (5598, 5586, 1,  1, 1),   -- A&E (1:1) --> Effective date
       (5598, 5587, 2,  0, 1),   -- A&E (0:1) --> Triage start
       (5598, 5588, 3,  0, 1),   -- A&E (0:1) --> Triage end
       (5598, 5589, 4,  0, 1),   -- A&E (0:1) --> End date
       (5598, 5590, 5,  1, 1),   -- A&E (1:1) --> Insert date
       (5598, 5591, 6,  1, 1),   -- A&E (1:1) --> Entered date
       (5598, 5592, 7,  1, 1),   -- A&E (1:1) --> Status
       (5598, 5593, 8,  1, 1),   -- A&E (1:1) --> Confidential
       (5598, 5594, 9,  0, 1),   -- A&E (0:1) --> Reason
       (5598, 5595, 10, 0, 1),   -- A&E (0:1) --> Description
       (5598, 5596, 11, 0, 1),   -- A&E (0:1) --> Ambulance
       (5598, 5597, 12, 1, 1);   -- A&E (1:1) --> Consent

-- Outpatient attendance
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5600, 11, 'Outpatient.EffectiveDate', 'EffectiveDate', ''),
       (5601, 8,  'Outpatient.EffectiveDatePrecision', 'Effective date precision', ''),
       (5602, 11, 'Outpatient.EndDate', 'End date', ''),
       (5603, 11, 'Outpatient.InsertDate', 'Insert date', ''),
       (5604, 11, 'Outpatient.EnteredDate', 'Entered date', ''),
       (5605, 7,  'Outpatient.Status', 'Status', ''),
       (5606, 13, 'Outpatient.IsConfidential', 'Is confidential', ''),
       (5607, 8,  'Outpatient.Duration', 'Duration', 'Expected duration in minutes'),
       (5608, 7,  'Outpatient.Reason', 'Reason', ''),
       (5609, 12, 'Outpatient.Description', 'Reason description', ''),
       (5610, 7,  'Outpatient.Purpose', 'Purpose', ''),
       (5611, 7,  'Outpatient.Outcome', 'Outcome', ''),
       (5612, 13, 'Outpatient.IsConsent', 'Is consent', ''),
       (5613, 4,  'Outpatient', 'Outpatient attendance', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5613, 5600, 0,  1, 1),   -- Outpatient (1:1) --> Effective date
       (5613, 5601, 1,  1, 1),   -- Outpatient (1:1) --> Effective date precision
       (5613, 5602, 2,  0, 1),   -- Outpatient (0:1) --> End date
       (5613, 5603, 3,  1, 1),   -- Outpatient (1:1) --> Insert date
       (5613, 5604, 4,  1, 1),   -- Outpatient (1:1) --> Entered date
       (5613, 5605, 5,  1, 1),   -- Outpatient (1:1) --> Status
       (5613, 5606, 6,  1, 1),   -- Outpatient (1:1) --> Confidential
       (5613, 5607, 7,  0, 1),   -- Outpatient (0:1) --> Duration
       (5613, 5608, 8,  0, 1),   -- Outpatient (0:1) --> Reason
       (5613, 5609, 9,  0, 1),   -- Outpatient (0:1) --> Reason description
       (5613, 5610, 10, 0, 1),   -- Outpatient (0:1) --> Purpose
       (5613, 5611, 11, 0, 1),   -- Outpatient (0:1) --> Outcome
       (5613, 5612, 12, 1, 1);   -- Outpatient (1:1) --> Consent

-- Hospital admission
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5615, 11, 'Admission.EffectiveDate', 'Effective date', ''),
       (5616, 8,  'Admission.EffectiveDatePrecision', 'Effective date precision', ''),
       (5617, 11, 'Admission.EndDate', 'End date', ''),
       (5618, 11, 'Admission.InsertDate', 'Insert date', ''),
       (5619, 11, 'Admission.EnteredDate', 'Entered date', ''),
       (5620, 7,  'Admission.Status', 'Status', 'Admission status (active, final, pending, etc)'),
       (5621, 13, 'Admission.IsConfidential', 'Is confidential', ''),
       (5622, 7,  'Admission.Reason', 'Reason', ''),
       (5623, 12, 'Admission.Description', 'Reason description', ''),
       (5624, 7,  'Admission.Purpose', 'Purpose', ''),
       (5625, 13, 'Admission.IsConsent', 'Is consent', ''),
       (5626, 4,  'Admission', 'Hospital admission', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5626, 5615, 0,  1, 1),  -- Admission (1:1) --> Effective date
       (5626, 5616, 1,  1, 1),  -- Admission (1:1) --> Effective date precision
       (5626, 5617, 2,  0, 1),  -- Admission (0:1) --> End date
       (5626, 5618, 3,  1, 1),  -- Admission (1:1) --> Insert date
       (5626, 5619, 4,  1, 1),  -- Admission (1:1) --> Entered date
       (5626, 5620, 5,  1, 1),  -- Admission (1:1) --> Status
       (5626, 5621, 6,  1, 1),  -- Admission (1:1) --> Confidential
       (5626, 5622, 7,  0, 1),  -- Admission (0:1) --> Reason
       (5626, 5623, 8,  0, 1),  -- Admission (0:1) --> Description
       (5626, 5624, 9,  0, 1),  -- Admission (0:1) --> Purpose
       (5626, 5625, 10, 1, 1);  -- Admission (1:1) --> Consent

-- Hospital ward transfer
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5630, 11, 'WardTransfer.EffectiveDate', 'Effective date', ''),
       (5631, 8,  'WardTransfer.EffectiveDatePrecision', 'Effective date precision', ''),
       (5632, 11, 'WardTransfer.EndDate', 'End date', ''),
       (5633, 11, 'WardTransfer.InsertDate', 'Insert date', ''),
       (5634, 11, 'WardTransfer.EnteredDate', 'Entered date', ''),
       (5635, 7,  'WardTransfer.Status', 'Status', ''),
       (5636, 13, 'WardTransfer.IsConfidential', 'Is confidential', ''),
       (5637, 7,  'WardTransfer.Reason', 'Reason', ''),
       (5638, 12, 'WardTransfer.Description', 'Reason description', ''),
       (5639, 7,  'WardTransfer.Purpose', 'Purpose', ''),
       (5640, 13, 'WardTransfer.IsConsent', 'Is consent', ''),
       (5641, 4,  'WardTransfer', 'Hospital ward transfer', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5641, 5630, 0,  1, 1),  -- Ward transfer (1:1) --> Effective date
       (5641, 5631, 1,  1, 1),  -- Ward transfer (1:1) --> Effective date precision
       (5641, 5632, 2,  0, 1),  -- Ward transfer (0:1) --> End date
       (5641, 5633, 3,  1, 1),  -- Ward transfer (1:1) --> Insert date
       (5641, 5634, 4,  1, 1),  -- Ward transfer (1:1) --> Entered date
       (5641, 5635, 5,  1, 1),  -- Ward transfer (1:1) --> Status
       (5641, 5636, 6,  1, 1),  -- Ward transfer (1:1) --> Confidential
       (5641, 5637, 7,  0, 1),  -- Ward transfer (0:1) --> Reason
       (5641, 5638, 8,  0, 1),  -- Ward transfer (0:1) --> Reason description
       (5641, 5639, 9,  0, 1),  -- Ward transfer (0:1) --> Purpose
       (5641, 5640, 10, 1, 1);  -- Ward transfer (1:1) --> Consent

-- Hospital discharge
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5645, 11, 'Discharge.EffectiveDate', 'Effective date', ''),
       (5646, 8,  'Discharge.EffectiveDatePrecision', 'Effective date precision', ''),
       (5647, 11, 'Discharge.EndDate', 'End date', ''),
       (5648, 11, 'Discharge.InsertDate', 'Insert date', ''),
       (5649, 11, 'Discharge.EnteredDate', 'Entered date', ''),
       (5650, 7,  'Discharge.Status', 'Status', ''),
       (5651, 13, 'Discharge.IsConfidential', 'Is confidential', ''),
       (5652, 7,  'Discharge.Reason', 'Reason', ''),
       (5653, 12, 'Discharge.Description', 'Reason description', ''),
       (5654, 13, 'Discharge.IsConsent', 'Is consent', ''),
       (5655, 4,  'Discharge', 'Hospital discharge', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5655, 5645, 0, 1, 1),   -- Discharge (1:1) --> Effective date
       (5655, 5646, 1, 1, 1),   -- Discharge (1:1) --> Effective date precision
       (5655, 5647, 2, 0, 1),   -- Discharge (0:1) --> End date
       (5655, 5648, 3, 1, 1),   -- Discharge (1:1) --> Insert date
       (5655, 5649, 4, 1, 1),   -- Discharge (1:1) --> Entered date
       (5655, 5650, 5, 1, 1),   -- Discharge (1:1) --> Status
       (5655, 5651, 6, 1, 1),   -- Discharge (1:1) --> Confidential
       (5655, 5652, 7, 0, 1),   -- Discharge (0:1) --> Reason
       (5655, 5653, 8, 0, 1),   -- Discharge (0:1) --> Reason description
       (5655, 5654, 9, 1, 1);   -- Discharge (1:1) --> Consent

-- Event relationship is standard "Related to" relationship

-- Observation
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5660, 7,  'Observation.Concept', 'Concept', ''),
       (5661, 11, 'Observation.EffectiveDate', 'Effective date', ''),
       (5662, 8,  'Observation.EffectiveDatePrecision', 'Precision', ''),
       (5663, 11, 'Observation.InsertDate', 'Insert date', ''),
       (5664, 11, 'Observation.EnteredDate', 'Entered date', ''),
       (5665, 7,  'Observation.CareActivityHeading', 'Care activity heading', ''),
       (5666, 7,  'Observation.Status', 'Status', ''),
       (5667, 13, 'Observation.IsConfidential', 'Is confidential', ''),
       (5668, 12, 'Observation.OriginalCode', 'Original code', ''),
       (5669, 12, 'Observation.OriginalConcept', 'Original concept', ''),
       (5670, 7,  'Observation.Episodicity', 'Episodicity', ''),
       (5671, 12, 'Observation.Comments', 'Comments', ''),
       (5672, 7,  'Observation.Significance', 'Significance', ''),
       (5673, 13, 'Observation.IsConsent', 'Is consent', ''),
       (5674, 4,  'Observation', 'Observation', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`, value_expression, value_concept)
VALUES
       (5674, 5660, 0,  1, 1, 0, 7),    -- Observation (1:1) --> Concept (Codeable concept)
       (5674, 5661, 1,  1, 1, 0, 11),   -- Observation (1:1) --> Effective date (date)
       (5674, 5662, 2,  1, 1, 1, 5385), -- Observation (1:1) --> Effective date precision (Child of date precision)
       (5674, 5663, 3,  1, 1, 0, 11),   -- Observation (1:1) --> Insert date (date)
       (5674, 5664, 4,  1, 1, 0, 11),   -- Observation (1:1) --> Entered date (date)
       (5674, 5665, 5,  1, 1, 0, 7),    -- Observation (1:1) --> Care activity heading    TODO: Care activity heading
       (5674, 5666, 6,  1, 1, 0, 7),    -- Observation (1:1) --> Status                   TODO: Observation status type
       (5674, 5667, 7,  1, 1, 0, 13),   -- Observation (1:1) --> Confidential (boolean)
       (5674, 5668, 8,  0, 1, 0, 12),   -- Observation (0:1) --> Original code (text)
       (5674, 5669, 9,  0, 1, 0, 12),   -- Observation (0:1) --> Original concept (text)
       (5674, 5670, 10, 0, 1, 0, 7),    -- Observation (0:1) --> Episodicity              TODO: Episodicity
       (5674, 5671, 11, 0, 1, 0, 12),   -- Observation (0:1) --> Comments (text)
       (5674, 5672, 12, 0, 1, 0, 7),    -- Observation (0:1) --> Significance             TODO: Significance
       (5674, 5673, 13, 1, 1, 0, 13);   -- Observation (1:1) --> Consent (boolean)

-- Flag
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5675, 7,  'Flag.Type', 'Type', ''),
       (5676, 11, 'Flag.EffectiveDate', 'Effective date', ''),
       (5677, 8,  'Flag.EffectiveDatePrecision', 'Effective date precision', ''),
       (5678, 11, 'Flag.EndDate', 'End date', ''),
       (5679, 11, 'Flag.InsertDate', 'Insert date', ''),
       (5680, 11, 'Flag.EnteredDate', 'Entered date', ''),
       (5681, 7,  'Flag.CareActivityHeading', 'Care activity heading', ''),
       (5682, 7,  'Flag.Status', 'Status', ''),
       (5683, 13, 'Flag.IsConfidential', 'Is confidential', ''),
       (5684, 12, 'Flag.Description', 'Description', ''),
       (5685, 13, 'Flag.IsConsent', 'Is consent', ''),
       (5686, 4,  'Flag', 'Flag', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5686, 5675, 0,  1, 1),  -- Flag (1:1) --> Type
       (5686, 5676, 1,  1, 1),  -- Flag (1:1) --> Effective date
       (5686, 5677, 2,  1, 1),  -- Flag (1:1) --> Effective date precision
       (5686, 5678, 3,  0, 1),  -- Flag (0:1) --> End date
       (5686, 5679, 4,  1, 1),  -- Flag (1:1) --> Insert date
       (5686, 5680, 5,  1, 1),  -- Flag (1:1) --> Entered date
       (5686, 5681, 6,  1, 1),  -- Flag (1:1) --> Care activity heading
       (5686, 5682, 7,  1, 1),  -- Flag (1:1) --> Status
       (5686, 5683, 8,  1, 1),  -- Flag (1:1) --> Confidential
       (5686, 5684, 9,  0, 1),  -- Flag (0:1) --> Description
       (5686, 5685, 10, 1, 1);  -- Flag (1:1) --> Consent

-- Problem
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5690, 7,  'Problem.Type', 'Type', 'Problem type concept (problem, issue, health admin, etc)'),
       (5691, 7,  'Problem.Significance', 'Significance', 'Problem significance (minor, major, etc)'),  -- TODO: How does this differ from OBS:Significance?
       (5692, 8,  'Problem.Duration', 'Expected duration', 'Expected duration of the problem in days'),
       (5693, 11, 'Problem.LastReviewDate', 'Last review date', ''),
       (5694, 4,  'Problem', 'Problem', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5694, 5690, 0, 0, 1),   -- Problem (0:1) --> Type
       (5694, 5691, 1, 0, 1),   -- Problem (0:1) --> Significance
       (5694, 5692, 2, 0, 1),   -- Problem (0:1) --> Duration
       (5694, 5693, 3, 0, 1);   -- Problem (0:1) --> Last review date

-- Procedure request
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5700, 7,  'ProcedureRequest.Concept', 'Concept', ''),
       (5701, 11, 'ProcedureRequest.EffectiveDate', 'Effective date', ''),
       (5702, 8,  'ProcedureRequest.EffectiveDatePrecision', 'Effective date precision', ''),
       (5703, 11, 'ProcedureRequest.InsertDate', 'Insert date', ''),
       (5704, 11, 'ProcedureRequest.EnteredDate', 'Entered date', ''),
       (5705, 7,  'ProcedureRequest.CareActivityHeading', 'Care activity heading', ''),
       (5706, 7,  'ProcedureRequest.Status', 'Status', ''),
       (5707, 13, 'ProcedureRequest.IsConfidential', 'Is confidential', ''),
       (5708, 7,  'ProcedureRequest.Priority', 'Priority', ''),
       (5709, 12, 'ProcedureRequest.Identifier', 'Request identifier', ''),
       (5710, 13, 'ProcedureRequest.IsConsent', 'Is consent', ''),
       (5711, 4,  'ProcedureRequest', 'Procedure request', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5711, 5700, 0,  1, 1),  -- Procedure request (1:1) --> Concept
       (5711, 5701, 1,  1, 1),  -- Procedure request (1:1) --> Effective date
       (5711, 5702, 2,  1, 1),  -- Procedure request (1:1) --> Effective date precision
       (5711, 5703, 3,  1, 1),  -- Procedure request (1:1) --> Insert date
       (5711, 5704, 4,  1, 1),  -- Procedure request (1:1) --> Effective date
       (5711, 5705, 5,  1, 1),  -- Procedure request (1:1) --> Care activity heading
       (5711, 5706, 6,  1, 1),  -- Procedure request (1:1) --> Status
       (5711, 5707, 7,  1, 1),  -- Procedure request (1:1) --> Confidential
       (5711, 5708, 8,  0, 1),  -- Procedure request (0:1) --> Priority
       (5711, 5709, 9,  0, 1),  -- Procedure request (0:1) --> Identifier
       (5711, 5710, 10, 1, 1);  -- Procedure request (1:1) --> Consent

-- Procedure TODO: Does it have link to procedure request?
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5715, 7,  'Procedure.Concept', 'Concept', ''),
       (5716, 11, 'Procedure.EffectiveDate', 'Effective date', ''),
       (5717, 8,  'Procedure.EffectiveDatePrecision', 'Effective date precision', ''),
       (5718, 11, 'Procedure.EndDate', 'End date', ''),
       (5719, 11, 'Procedure.InsertDate', 'Insert date', ''),
       (5720, 11, 'Procedure.EnteredDate', 'Entered date', ''),
       (5721, 7,  'Procedure.CareActivityHeading', 'Care activity heading', ''),
       (5722, 7,  'Procedure.Status', 'Status', ''),
       (5723, 13, 'Procedure.IsConfidential', 'Is confidential', ''),
       (5724, 7,  'Procedure.Outcome', 'Outcome', ''),
       (5725, 13, 'Procedure.IsConsent', 'Is consent', ''),
       (5726, 4,  'Procedure', 'Procedure', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5726, 5715, 0,  1, 1),  -- Procedure (1:1) --> Concept
       (5726, 5716, 1,  1, 1),  -- Procedure (1:1) --> Effective date
       (5726, 5717, 2,  1, 1),  -- Procedure (1:1) --> Effective date precision
       (5726, 5718, 3,  0, 1),  -- Procedure (0:1) --> End date
       (5726, 5719, 4,  1, 1),  -- Procedure (1:1) --> Insert date
       (5726, 5720, 5,  1, 1),  -- Procedure (1:1) --> Entered date
       (5726, 5721, 6,  1, 1),  -- Procedure (1:1) --> Care activity heading
       (5726, 5722, 7,  1, 1),  -- Procedure (1:1) --> Status
       (5726, 5723, 8,  1, 1),  -- Procedure (1:1) --> Confidential
       (5726, 5724, 9,  0, 1),  -- Procedure (0:1) --> Outcome
       (5726, 5725, 10, 1, 1);  -- Procedure (1:1) --> Consent

-- Device
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5730, 7,  'Device.Type', 'Type', 'Nature of the device (cardiac pacemaker, etc)'),
       (5731, 12, 'Device.SerialNo', 'Serial number', ''),
       (5732, 12, 'Device.Name', 'Name', ''),
       (5733, 12, 'Device.Manufacturer', 'Manufacturer', ''),
       (5734, 12, 'Device.HumanId', 'Human readable identifier', ''),
       (5735, 12, 'Device.MachineId', 'Machine readable identifier', ''),   -- TODO: Should this be a barcode format for formatting the human readable?
       (5736, 12, 'Device.Version', 'Version', ''),
       (5737, 4,  'Device', 'Device', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5737, 5730, 0, 1, 1),   -- Device (1:1) --> Type
       (5737, 5731, 1, 0, 1),   -- Device (0:1) --> Serial
       (5737, 5732, 2, 0, 1),   -- Device (0:1) --> Name
       (5737, 5733, 3, 0, 1),   -- Device (0:1) --> Manufacturer
       (5737, 5734, 4, 0, 1),   -- Device (0:1) --> Human ID
       (5737, 5735, 5, 0, 1),   -- Device (0:1) --> Machine ID
       (5737, 5736, 6, 0, 1);   -- Device (0:1) --> Version

-- Observation value
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5740, 7,    'Observation.Value.Operator', 'Operator', 'Operator concept (=, <=, !=, etc)'),
       (5741, 8,    'Observation.Value.Numeric', 'Numeric value', ''),
       (5742, 7,    'Observation.Value.Units', 'Units', ''),
       (5743, 11,   'Observation.Value.Date', 'Date value', ''),
       (5744, 12,   'Observation.Value.Text', 'Text value', ''),
       (5745, 7,    'Observation.Value.Concept', 'Concept value', ''),
       (5746, 5674, 'Observation.Value', 'Observation value', '');     -- TODO: Extends observation
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`, value_expression, value_concept)
VALUES
       (5746, 5740, 0, 1, 1, 0, 7),     -- Observation value (1:1) --> Operator     TODO: Operator concept type
       (5746, 5741, 1, 0, 1, 0, 8),     -- Observation value (0:1) --> Numeric (number)
       (5746, 5742, 2, 0, 1, 1, 5380),  -- Observation value (0:1) --> Units (child of UOM)  TODO: Should this att be on new "Measure" (subclass of Numeric) instead of Obs?
       (5746, 5743, 3, 0, 1, 0, 11),    -- Observation value (0:1) --> Date (date)
       (5746, 5744, 4, 0, 1, 0, 12),    -- Observation value (0:1) --> Text (text)
       (5746, 5745, 5, 0, 1, 0, 7);     -- Observation value (0:1) --> Concept (concept)
-- (5746, rrng, 6, 0, 1);   -- Observation value (0:1) --> Reference range  TODO: There isn't one in the IM?!?!?

-- Immunisation
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5750, 7,  'Immunisation.Concept', 'Concept', ''),
       (5751, 11, 'Immunisation.EffectiveDate', 'Effective date', ''),
       (5752, 8,  'Immunisation.EffectiveDatePrecision', 'Effective date precision', ''),
       (5753, 11, 'Immunisation.InsertDate', 'Insert date', ''),
       (5754, 11, 'Immunisation.EnteredDate', 'Entered date', ''),
       (5755, 7,  'Immunisation.CareActivityHeading', 'Care activity heading', ''),
       (5756, 7,  'Immunisation.Status', 'Status', ''),
       (5757, 13, 'Immunisation.IsConfidential', 'Is confidential', ''),
       (5758, 12, 'Immunisation.Dose', 'Dose', ''),
       (5759, 7,  'Immunisation.BodyLocation', 'Body location', ''),
       (5760, 7,  'Immunisation.Method', 'Method', ''),
       (5761, 12, 'Immunisation.BatchNo', 'Batch number', ''),
       (5762, 11, 'Immunisation.ExpiryDate', 'Expiry date', ''),
       (5763, 12, 'Immunisation.Manufacturer', 'Manufacturer', ''),
       (5764, 8,  'Immunisation.DoseNumber', 'Dose number', ''),
       (5765, 8,  'Immunisation.DosesRequired', 'Doses required', ''),
       (5766, 13, 'Immunisation.IsConsent', 'Is consent', ''),
       (5767, 4,  'Immunisation', 'Immunisation', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5767, 5750, 0,  1, 1),  -- Immunisation (1:1) --> Concept
       (5767, 5751, 1,  1, 1),  -- Immunisation (1:1) --> Effective date
       (5767, 5752, 2,  1, 1),  -- Immunisation (1:1) --> Effective date precision
       (5767, 5753, 3,  1, 1),  -- Immunisation (1:1) --> Insert date
       (5767, 5754, 4,  1, 1),  -- Immunisation (1:1) --> Entered date
       (5767, 5755, 5,  1, 1),  -- Immunisation (1:1) --> Care activity heading
       (5767, 5756, 6,  1, 1),  -- Immunisation (1:1) --> Status
       (5757, 5757, 7,  1, 1),  -- Immunisation (1:1) --> Confidential
       (5767, 5758, 8,  0, 1),  -- Immunisation (0:1) --> Dose
       (5767, 5759, 9,  0, 1),  -- Immunisation (0:1) --> Body location
       (5767, 5760, 10, 0, 1),  -- Immunisation (0:1) --> Method
       (5767, 5761, 11, 0, 1),  -- Immunisation (0:1) --> Batch
       (5767, 5762, 12, 0, 1),  -- Immunisation (0:1) --> Expiry
       (5767, 5763, 13, 0, 1),  -- Immunisation (0:1) --> Manufacturer
       (5767, 5764, 14, 0, 1),  -- Immunisation (0:1) --> Dose number
       (5767, 5765, 15, 0, 1),  -- Immunisation (0:1) --> Dose count
       (5767, 5766, 16, 1, 1);  -- Immunisation (1:1) --> Consent

-- Allergy
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5770, 7,  'Allergy.Concept', 'Concept', ''),
       (5771, 11, 'Allergy.EffectiveDate', 'Effective date', ''),
       (5772, 8,  'Allergy.EffectiveDatePrecision', 'Effective date precision', ''),
       (5773, 11, 'Allergy.InsertDate', 'Insert date', ''),
       (5774, 11, 'Allergy.EnteredDate', 'Entered date', ''),
       (5775, 7,  'Allergy.CareActivityHeading', 'Care activity heading', ''),
       (5776, 7,  'Allergy.Status', 'Status', ''),
       (5777, 13, 'Allergy.IsConfidential', 'Is confidential', ''),
       (5778, 7,  'Allergy.Substance', 'Substance', ''),
       (5779, 7,  'Allergy.Manifestation', 'Manifestation', ''),
       (5780, 12, 'Allergy.Description', 'Manifestation description', ''),
       (5781, 13, 'Allergy.IsConsent', 'Is consent', ''),
       (5782, 4,  'Allergy', 'Allergy', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5782, 5770, 0,  1, 1),  -- Allergy (1:1) --> Concept
       (5782, 5771, 1,  1, 1),  -- Allergy (1:1) --> Effective date
       (5782, 5772, 2,  1, 1),  -- Allergy (1:1) --> Effective date precision
       (5782, 5773, 3,  1, 1),  -- Allergy (1:1) --> Insert date
       (5782, 5774, 4,  1, 1),  -- Allergy (1:1) --> Entered date
       (5782, 5775, 5,  1, 1),  -- Allergy (1:1) --> Care activity heading
       (5782, 5776, 6,  1, 1),  -- Allergy (1:1) --> Status
       (5782, 5777, 7,  1, 1),  -- Allergy (1:1) --> Confidential
       (5782, 5778, 8,  0, 1),  -- Allergy (0:1) --> Substance
       (5782, 5779, 9,  0, 1),  -- Allergy (0:1) --> Manifestation
       (5782, 5780, 10, 0, 1),  -- Allergy (0:1) --> Description
       (5782, 5781, 11, 1, 1);  -- Allergy (1:1) --> Consent

-- Referral
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5785, 7,  'Referral.Concept', 'Concept', ''),
       (5786, 11, 'Referral.EffectiveDate', 'Effective date', ''),
       (5787, 8,  'Referral.EffectiveDatePrecision', 'Effective date precision', ''),
       (5788, 11, 'Referral.InsertDate', 'Insert date', ''),
       (5789, 11, 'Referral.EnteredDate', 'Entered date', ''),
       (5790, 7,  'Referral.CareActivityHeading', 'Care activity heading', ''),
       (5791, 7,  'Referral.Status', 'Status', ''),
       (5792, 13, 'Referral.IsConfidential', 'Is confidential', ''),
       (5793, 12, 'Referral.UBRN', 'UBRN', ''),
       (5794, 7,  'Referral.Priority', 'Priority', ''),
       (5795, 7,  'Referral.Mode', 'Mode', ''),
       (5796, 7,  'Referral.Source', 'Source', ''),
       (5797, 7,  'Referral.Service', 'Service requested', ''),
       (5798, 12, 'Referral.Reason', 'Reason', ''),
       (5799, 13, 'Referral.IsConsent', 'Is consent', ''),
       (5800, 4,  'Referral', 'Referral', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5800, 5785, 0, 1, 1),   -- Referral (1:1) --> Concept
       (5800, 5786, 1, 1, 1),   -- Referral (1:1) --> Effective date
       (5800, 5787, 2, 1, 1),   -- Referral (1:1) --> Effective date precision
       (5800, 5788, 3, 1, 1),   -- Referral (1:1) --> Insert date
       (5800, 5789, 4, 1, 1),   -- Referral (1:1) --> Entered date
       (5800, 5790, 5, 1, 1),   -- Referral (1:1) --> Care activity heading
       (5800, 5791, 6, 1, 1),   -- Referral (1:1) --> Status
       (5800, 5792, 7, 1, 1),   -- Referral (1:1) --> Confidential
       (5800, 5793, 8, 0, 1),   -- Referral (0:1) --> UBRN
       (5800, 5794, 9, 0, 1),   -- Referral (0:1) --> Priority
       (5800, 5795, 10, 0, 1),  -- Referral (0:1) --> Mode
       (5800, 5796, 11, 0, 1),  -- Referral (0:1) --> Source
       (5800, 5797, 12, 0, 1),  -- Referral (0:1) --> Service
       (5800, 5798, 13, 0, 1),  -- Referral (0:1) --> Reason
       (5800, 5799, 14, 1, 1);  -- Referral (1:1) --> Consent

-- Medication amount
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5805, 8,  'MedicationAmount.Dose', 'Dose', ''),
       (5806, 10, 'MedicationAmount.Quantity', 'Quantity', ''),
       (5807, 12, 'MedicationAmount.Units', 'Units', ''),
       (5808, 4,  'MedicationAmount', 'Medication amount', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5808, 5805, 0, 0, 1),   -- Medication amount (0:1) --> Dose
       (5808, 5806, 1, 0, 1),   -- Medication amount (0:1) --> Quantity
       (5808, 5807, 2, 0, 1);   -- Medication amount (0:1) --> Units

-- Medication statement
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5810, 7,  'MedicationStatement.Drug', 'Drug', ''),
       (5811, 11, 'MedicationStatement.EffectiveDate', 'Effective date', ''),
       (5812, 8,  'MedicationStatement.EffectiveDatePrecision', 'Effective date precision', ''),
       (5813, 11, 'MedicationStatement.InsertDate', 'Insert date', ''),
       (5814, 11, 'MedicationStatement.EnteredDate', 'Entered date', ''),
       (5815, 7,  'MedicationStatement.CareActivityHeading', 'Care activity heading', ''),
       (5816, 7,  'MedicationStatement.Status', 'Status', ''),
       (5817, 13, 'MedicationStatement.IsConfidential', 'Is confidential', ''),
       (5818, 7,  'MedicationStatement.Type', 'Type', ''),
       (5819, 8,  'MedicationStatement.IssuesAuthorised', 'Issues authorised', ''),
       (5820, 11, 'MedicationStatement.ReviewDate', 'Review date', ''),
       (5821, 8,  'MedicationStatement.CourseLength', 'Course length', 'Number of days each issue is expected to last'),
       (5822, 12, 'MedicationStatement.PatientInstructions', 'Patient instructions', ''),
       (5823, 12, 'MedicationStatement.PharmacyInstructions', 'Pharmacy instructions', ''),
       (5824, 13, 'MedicationStatement.IsActive', 'Is active', ''),
       (5825, 11, 'MedicationStatement.EndDate', 'End date', ''),
       (5826, 7,  'MedicationStatement.EndReason', 'End reason', ''),
       (5827, 12, 'MedicationStatement.EndDescription', 'End description', ''),
       (5828, 8,  'MedicationStatement.Issues', 'Issues', 'Number of issues received'),
       (5829, 13, 'MedicationStatement.IsConsent', 'Is consent', ''),
       (5830, 4,  'MedicationStatement', 'Medication statement', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5830, 5810, 0,  1, 1),   -- Medication statement (1:1) --> Drug
       (5830, 5811, 1,  1, 1),   -- Medication statement (1:1) --> Effective date
       (5830, 5812, 2,  1, 1),   -- Medication statement (1:1) --> Effective date precision
       (5830, 5813, 3,  1, 1),   -- Medication statement (1:1) --> Insert date
       (5830, 5814, 4,  1, 1),   -- Medication statement (1:1) --> Entered date
       (5830, 5815, 5,  1, 1),   -- Medication statement (1:1) --> Care activity heading
       (5830, 5816, 6,  1, 1),   -- Medication statement (1:1) --> Status
       (5830, 5817, 7,  1, 1),   -- Medication statement (1:1) --> Confidential
       (5830, 5818, 8,  1, 1),   -- Medication statement (1:1) --> Type
       (5830, 5819, 9,  0, 1),   -- Medication statement (0:1) --> Issues authorised
       (5830, 5820, 10, 0, 1),   -- Medication statement (0:1) --> Review date
       (5830, 5821, 11, 0, 1),   -- Medication statement (0:1) --> Course length
       (5830, 5822, 12, 0, 1),   -- Medication statement (0:1) --> Patient instructions
       (5830, 5823, 13, 0, 1),   -- Medication statement (0:1) --> Pharmacy instructions
       (5830, 5824, 14, 1, 1),   -- Medication statement (1:1) --> Active
       (5830, 5825, 15, 0, 1),   -- Medication statement (0:1) --> End date
       (5830, 5826, 16, 0, 1),   -- Medication statement (0:1) --> End reason
       (5830, 5827, 17, 0, 1),   -- Medication statement (0:1) --> End description
       (5830, 5828, 18, 0, 1),   -- Medication statement (0:1) --> Issues
       (5830, 5829, 19, 1, 1);   -- Medication statement (1:1) --> Consent

-- Medication order
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5835, 11, 'MedicationOrder.EffectiveDate', 'Effective date', ''),
       (5836, 8,  'MedicationOrder.EffectiveDatePrecision', 'Effective date precision', ''),
       (5837, 11, 'MedicationOrder.InsertDate', 'Insert date', ''),
       (5838, 11, 'MedicationOrder.EnteredDate', 'Entered date', ''),
       (5839, 7,  'MedicationOrder.CareActivityHeading', 'Care activity heading', ''),
       (5840, 7,  'MedicationOrder.Status', 'Status', ''),
       (5841, 13, 'MedicationOrder.IsConfidential', 'Is confidential',''),
       (5842, 7,  'MedicationOrder.Type', 'Type', ''),
       (5843, 12, 'MedicationOrder.PatientInstructions', 'Patient instructions', ''),
       (5844, 12, 'MedicationOrder.PharmacyInstructions', 'Pharmacy instructions', ''),
       (5845, 10, 'MedicationOrder.EstimatedCost', 'Estimated cost', ''),
       (5846, 13, 'MedicationOrder.IsActive', 'Is active', ''),
       (5847, 8,  'MedicationOrder.Duration', 'Duration', 'Duration in days'),
       (5848, 13, 'MedicationOrder.IsConsent', 'Is consent', ''),
       (5849, 4,  'MedicationOrder', 'Medication order', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5849, 5835, 0,  1, 1),   -- Medication order (1:1) --> Effective date
       (5849, 5836, 1,  1, 1),   -- Medication order (1:1) --> Effective date precision
       (5849, 5837, 2,  1, 1),   -- Medication order (1:1) --> Insert date
       (5849, 5838, 3,  1, 1),   -- Medication order (1:1) --> Entered date
       (5849, 5839, 4,  1, 1),   -- Medication order (1:1) --> Care activity heading
       (5849, 5840, 5,  1, 1),   -- Medication order (1:1) --> Status
       (5849, 5841, 6,  1, 1),   -- Medication order (1:1) --> Confidential
       (5849, 5842, 7,  1, 1),   -- Medication order (1:1) --> Type
       (5849, 5843, 8,  0, 1),   -- Medication order (0:1) --> Patient instructions
       (5849, 5844, 9,  0, 1),   -- Medication order (0:1) --> Pharmacy instructions
       (5849, 5845, 10, 0, 1),   -- Medication order (0:1) --> Estimated cost
       (5849, 5846, 11, 1, 1),   -- Medication order (1:1) --> Active
       (5849, 5847, 12, 0, 1),   -- Medication order (0:1) --> Duration
       (5849, 5848, 13, 1, 1);   -- Medication order (1:1) --> Consent

-- Related person
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5850, 12, 'RelatedPerson.Title', 'Title', ''),
       (5851, 12, 'RelatedPerson.FirstName', 'First name', ''),
       (5852, 12, 'RelatedPerson.MiddleNames', 'Middle name(s)', ''),
       (5853, 12, 'RelatedPerson.LastName', 'Last name', ''),
       (5854, 11, 'RelatedPerson.BirthDate', 'Date of birth', ''),
       (5855, 13, 'RelatedPerson.IsActive', 'Is active', ''),
       (5856, 7,  'RelatedPerson.Type', 'Type', ''),        -- TODO: Address type!?!
       (5857, 11, 'RelatedPerson.StartDate', 'Start date', ''),
       (5858, 11, 'RelatedPerson.EndDate', 'End date', ''),
       (5859, 7,  'RelatedPerson.RelationshipType', 'Relationship type', ''),
       (5860, 4,  'RelatedPerson', 'Related person', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5860, 5850, 0, 0, 1),   -- Related person (0:1) --> Title
       (5860, 5851, 1, 0, 1),   -- Related person (0:1) --> First name
       (5860, 5852, 2, 0, 1),   -- Related person (0:1) --> Middle name(s)
       (5860, 5853, 3, 0, 1),   -- Related person (0:1) --> Last name
       (5860, 5854, 4, 0, 1),   -- Related person (0:1) --> DoB
       (5860, 5855, 5, 0, 1),   -- Related person (0:1) --> Active
       (5860, 5856, 6, 0, 1),   -- Related person (0:1) --> Type
       (5860, 5857, 7, 0, 1),   -- Related person (0:1) --> Start date
       (5860, 5858, 8, 0, 1),   -- Related person (0:1) --> End date
       (5860, 5859, 0, 0, 0);   -- Related person (0:*) --> Relationship type

-- Related person contact
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5865, 7,  'RelatedPerson.Contact.Type', 'Contact type', ''),
       (5866, 12, 'RelatedPerson.Contact.Details', 'Contact details', ''),
       (5867, 4,  'RelatedPerson.Contact', 'Related person contact', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5867, 5865, 0, 1, 1),   -- Related person contact (1:1) --> Contact type
       (5867, 5866, 1, 1, 1);   -- Related person contact (1:1) --> Contact details

-- Care plan
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5870, 7,  'CarePlan.Concept', 'Concept', ''),
       (5871, 11, 'CarePlan.EffectiveDate', 'Effective date', ''),
       (5872, 8,  'CarePlan.EffectiveDatePrecision', 'Effective date precision', ''),
       (5873, 11, 'CarePlan.InsertDate', 'Insert date', ''),
       (5874, 11, 'CarePlan.EnteredDate', 'Entered date', ''),
       (5875, 7,  'CarePlan.CareActivityHeading', 'Care activity heading', ''),
       (5876, 7,  'CarePlan.Status', 'Status', ''),
       (5877, 13, 'CarePlan.IsConfidential', 'Is confidential',''),
       (5878, 12, 'CarePlan.Description', 'Description', ''),
       (5879, 8,  'CarePlan.Frequency', 'Performance frequency', ''),
       (5880, 12, 'CarePlan.FrequencyUnits', 'Performance frequency units', ''),
       (5881, 7,  'CarePlan.LocationType', 'Location type', ''),
    -- Care plan -> Follow up event is relationship TODO: What is an "event" - define between record type and obs/ref/etc?
       (5882, 13, 'CarePlan.IsConsent', 'Is consent', ''),
       (5883, 4,  'CarePlan', 'Care plan', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5883, 5870, 0,  1, 1),  -- Care plan (1:1) --> Concept
       (5883, 5871, 1,  1, 1),  -- Care plan (1:1) --> Effective date
       (5883, 5872, 2,  1, 1),  -- Care plan (1:1) --> Effective date precision
       (5883, 5873, 3,  1, 1),  -- Care plan (1:1) --> Insert date
       (5883, 5874, 4,  1, 1),  -- Care plan (1:1) --> Entered date
       (5883, 5875, 5,  1, 1),  -- Care plan (1:1) --> Care activity heading
       (5883, 5876, 6,  1, 1),  -- Care plan (1:1) --> Status
       (5883, 5877, 7,  1, 1),  -- Care plan (1:1) --> Confidential
       (5883, 5878, 8,  0, 1),  -- Care plan (0:1) --> Description
       (5883, 5879, 9,  0, 1),  -- Care plan (0:1) --> Performance frequency
       (5883, 5880, 10, 0, 1),  -- Care plan (0:1) --> Performance frequency units
       (5883, 5881, 11, 0, 1),  -- Care plan (0:1) --> Location type
       (5883, 5882, 12, 1, 1);  -- Care plan (1:1) --> Consent

-- Care plan activity
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5885, 7,  'CarePlan.Activity.Concept', 'Concept', ''),
       (5886, 11, 'CarePlan.Activity.EffectiveDate', 'Effective date', ''),
       (5887, 8,  'CarePlan.Activity.EffectiveDatePrecision', 'Effective date precision', ''),
       (5888, 11, 'CarePlan.Activity.InsertDate', 'Insert date', ''),
       (5889, 11, 'CarePlan.Activity.EnteredDate', 'Entered date', ''),
       (5890, 7,  'CarePlan.Activity.CareActivityHeading', 'Care activity heading', ''),
       (5891, 7,  'CarePlan.Activity.Status', 'Status', ''),
       (5892, 13, 'CarePlan.Activity.IsConfidential', 'Is confidential',''),
       (5893, 7,  'CarePlan.Activity.Goal', 'Goal', ''),
       (5894, 7,  'CarePlan.Activity.Outcome', 'Outcome', ''),
       (5895, 11, 'CarePlan.Activity.OutcomeDate', 'Outcome date', ''),
       (5896, 13, 'CarePlan.Activity.IsConsent', 'Is consent', ''),
       (5897, 4,  'CarePlan.Activity', 'Care plan activity', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5897, 5885, 0,  1, 1),  -- Care plan activity (1:1) --> Concept
       (5897, 5886, 1,  1, 1),  -- Care plan activity (1:1) --> Effective date
       (5897, 5887, 2,  1, 1),  -- Care plan activity (1:1) --> Effective date precision
       (5897, 5888, 3,  1, 1),  -- Care plan activity (1:1) --> Insert date
       (5897, 5889, 4,  1, 1),  -- Care plan activity (1:1) --> Entered date
       (5897, 5890, 5,  1, 1),  -- Care plan activity (1:1) --> Care activity heading
       (5897, 5891, 6,  1, 1),  -- Care plan activity (1:1) --> Status
       (5897, 5892, 7,  1, 1),  -- Care plan activity (1:1) --> Confidential
       (5897, 5893, 8,  0, 1),  -- Care plan activity (0:1) --> Goal
       (5897, 5894, 9,  0, 1),  -- Care plan activity (0:1) --> Outcome
       (5897, 5895, 10, 0, 1),  -- Care plan activity (0:1) --> Outcome date
       (5897, 5896, 11, 1, 1);  -- Care plan activity (1:1) --> Consent

-- Care plan activity target
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5900, 7,  'CarePlan.Activity.Target.Concept', 'Concept', ''),
       (5901, 11, 'CarePlan.Activity.Target.EffectiveDate', 'Effective date', ''),
       (5902, 8,  'CarePlan.Activity.Target.EffectiveDatePrecision', 'Effective date precision', ''),
       (5903, 11, 'CarePlan.Activity.Target.EndDate', 'End date', ''),
       (5904, 11, 'CarePlan.Activity.Target.InsertDate', 'Insert date', ''),
       (5905, 11, 'CarePlan.Activity.Target.EnteredDate', 'Entered date', ''),
       (5906, 7,  'CarePlan.Activity.Target.CareActivityHeading', 'Care activity heading', ''),
       (5907, 7,  'CarePlan.Activity.Target.Status', 'Status', ''),
       (5908, 13, 'CarePlan.Activity.Target.IsConfidential', 'Is confidential',''),
       (5909, 7,  'CarePlan.Activity.Target.Target', 'Target', ''),
       (5910, 11, 'CarePlan.Activity.Target.TargetDate', 'Target date', ''),
       (5911, 7,  'CarePlan.Activity.Target.Outcome', 'Outcome', ''),
       (5912, 11, 'CarePlan.Activity.Target.OutcomeDate', 'Outcome date', ''),
       (5913, 13, 'CarePlan.Activity.Target.IsConsent', 'Is consent', ''),
       (5914, 4,  'CarePlan.Activity.Target', 'Care plan activity target', '');
INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`)
VALUES
       (5914, 5900, 0,  1, 1),  -- Care plan activity target (1:1) --> Concept
       (5914, 5901, 1,  1, 1),  -- Care plan activity target (1:1) --> Effective date
       (5914, 5902, 2,  1, 1),  -- Care plan activity target (1:1) --> Effective date precision
       (5914, 5903, 3,  1, 1),  -- Care plan activity target (1:1) --> Insert date
       (5914, 5904, 4,  1, 1),  -- Care plan activity target (1:1) --> Entered date
       (5914, 5905, 5,  1, 1),  -- Care plan activity target (1:1) --> Care activity heading
       (5914, 5906, 6,  1, 1),  -- Care plan activity target (1:1) --> Status
       (5914, 5907, 7,  1, 1),  -- Care plan activity target (1:1) --> Confidential
       (5914, 5908, 8,  1, 1),  -- Care plan activity target (1:1) --> Target
       (5914, 5909, 9,  0, 1),  -- Care plan activity target (0:1) --> Target date
       (5914, 5910, 10, 0, 1),  -- Care plan activity target (0:1) --> Outcome
       (5914, 5911, 11, 0, 1),  -- Care plan activity target (0:1) --> Outcome date
       (5914, 5912, 12, 1, 1);  -- Care plan activity target (1:1) --> Consent

-- ************************************** RELATIONSHIPS **************************************



INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5420, 102, 5408, 0, 1, 1),  -- Loc -- Has a (1:1) --> Address
       (5420, 107, 5420, 1, 0, 1),  -- Loc -- Has parent (0:1) --> Location
       (5420, 102, 5423, 2, 0, 0),  -- Loc -- Has (0:*) --> Location contact
       (5420, 102, 5500, 3, 0, 0);  -- Loc -- Has (0:*) --> Appointment schedule

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5434, 102, 5437, 0, 0, 0),  -- Practitioner -- Has (0:*) --> Practitioner contact
       (5434, 102, 5440, 1, 0, 0);  -- Practitioner -- Has (0:*) --> Practitioner identifier

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5458, 102, 5434, 1,  0, 1), -- Patient -- Has (0:1) --> Practitioner (qualifier = Main/Entered by)
       (5458, 102, 5463, 2,  0, 0), -- Patient -- Has (0:*) --> Patient address (qualifier = home/previous)
       (5458, 102, 5467, 3,  0, 0), -- Patient -- Has (0:*) --> Patient contact
       (5458, 102, 5472, 4,  0, 0), -- Patient -- Has (0:*) --> Patient Identifier
       (5458, 102, 5565, 5,  0, 0), -- Patient -- Has (0:*) --> GP consultation
       (5458, 102, 5545, 6,  0, 0), -- Patient -- Has (0:*) --> Care episode
       (5458, 102, 5518, 7,  0, 0), -- Patient -- Has (0:*) --> Booking
       (5458, 102, 5523, 8,  0, 0), -- Patient -- Has (0:*) --> Attendance
       (5458, 102, 5539, 9,  1, 0), -- Patient -- Has (1:*) --> Registration status
       (5458, 102, 5580, 10, 0, 0), -- Patient -- Has (0:*) --> Hospital encounter
    -- (5458, 102, 5598, 11, 0, 0), -- Patient -- Has (0:*) --> A&E Attendance  TODO: Inferred via hospital encounter?
       (5458, 102, 5613, 12, 0, 0), -- Patient -- Has (0:*) --> Outpatient attendance
    -- (5458, 102, 5626, 13, 0, 0), -- Patient -- Has (0:*) --> Hospital admission TODO: Inferred from episode -> encounter?
    -- (5458, 102, 5641, 14, 0, 0), -- Patient -- Has (0:*) --> Ward transfer TODO: Implied by encounter ?
    -- (5458, 102, 5655, 15, 0, 0), -- Patient -- Has (0:*) --> Discharge   TODO: Inferred from encounter?
       (5458, 102, 5674, 16, 0, 0), -- Patient -- Has (0:*) --> Observation
       (5458, 102, 5686, 17, 0, 0), -- Patient -- Has (0:*) --> Flag
    -- (5458, 102, 5694, 18, 0, 0), -- Patient -- Has (0:*) --> Problem TODO: Inferred from observation?
       (5458, 102, 5711, 19, 0, 0), -- Patient -- Has (0:*) --> Procedure request
       (5458, 102, 5726, 20, 0, 0), -- Patient -- Has (0:*) --> Procedure TODO: If this is only ever from request then can be inferred by request?
       (5458, 102, 5767, 21, 0, 0), -- Patient -- Has (0:*) --> Immunisation
       (5458, 102, 5782, 22, 0, 0), -- Patient -- Has (0:*) --> Allergy
       (5458, 102, 5800, 23, 0, 0), -- Patient -- Has (0:*) --> Referral
       (5458, 102, 5830, 24, 0, 0), -- Patient -- Has (0:*) --> Medication
    -- (5458, 102, 5849, 25, 0, 0), -- Patient -- Has (0:*) --> Medication order TODO: inferred from medication statement?
       (5458, 102, 5860, 26, 0, 0), -- Patient -- Has (0:*) --> Related person
       (5458, 102, 5883, 27, 0, 0); -- Patient -- Has (0:*) --> Care plan

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5463, 102, 5408, 0, 0, 1);  -- Patient address -- Has (0:1) --> Address

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5481, 101, 4, 0, 1, 1);  -- Attribute -- Related to (1:1) --> Record type

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5500, 102, 5434, 0, 0, 0),  -- Appointment schedule -- Has (0:*) --> Practitioner     TODO: "Main" flag?
       (5500, 102, 5510, 1, 0, 0);  -- Appointment schedule -- Has (0:*) --> Appointment slot

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5510, 102, 5518, 0, 0, 0),  -- Appointment slot -- Has (0:*) --> Booking
       (5510, 102, 5523, 1, 0, 1),  -- Appointment slot -- Has (0:1) --> Attendance
       (5510, 102, 5527, 2, 0, 0),  -- Appointment slot -- Has (0:*) --> Attendance event TODO: Should this be on attendance not slot?
       (5510, 102, 5613, 3, 0, 1);  -- Appointment slot -- Has (0:1) --> Outpatient

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5539, 111, 5434, 1, 0, 0);  -- Registration status -- Has a (1:*) --> Practitioner (qualifier - Effective/Entered)

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5545, 102, 5434, 0, 0, 0),  -- Care episode -- Has a (1:*) --> Practitioner (qualifier - Effective/Entered)
       (5545, 102, 5553, 1, 0, 0),  -- Care episode -- Has a (0:*) --> Care episode status
       (5545, 102, 5580, 2, 0, 0);  -- Care episode -- Has (0:*) --> Hospital encounter
-- (5545, 102, 5626, 3, 0, 0),  -- Care episode -- Has (0:*) --> Hospital admission TODO: Inferred from encounter?
-- (5545, 102, 5641, 4, 0, 0),  -- Care episode -- Has (0:*) --> Ward transfer TODO: Implied by encounter?
-- (5545, 102, 5655, 5, 0, 0);  -- Care episode -- Has (0:*) --> Discharge   TODO: Inferred from encounter?

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5565, 102, 5434, 1, 0, 0),  -- GP consultation -- Has a (1:*) --> Practitioner (qualifier - Effective/Entered)
       (5565, 102, 5414, 2, 0, 1),  -- GP consultation -- Has a (0:1) --> Organisation (qualifier - Owning)
       (5565, 102, 5420, 3, 0, 1),  -- GP consultation -- Has a (0:1) --> Location
       (5565, 102, 5510, 4, 0, 1),  -- GP consultation -- Has a (0:1) --> Appointment slot
       (5565, 102, 5800, 5, 0, 1);  -- GP consultation -- Has a (0:1) --> Referral

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5580, 102, 5414, 0, 0, 1),  -- Hospital encounter -- Has (0:1) --> Organisation (qualifier = owning)
       (5580, 102, 5420, 1, 0, 1),  -- Hospital encounter -- Has (0:1) --> Location
       (5580, 102, 5800, 2, 0, 1),  -- Hospital encounter -- Has (0:1) --> Referral request     TODO: Is this the other way around?
       (5580, 102, 5434, 3, 0, 0),  -- Hospital encounter -- Has (0:*) --> Practitioner
       (5580, 102, 5598, 4, 0, 0),  -- Hospital encounter -- Has (0:*) --> A&E Attendance
       (5580, 102, 5613, 5, 0, 0),  -- Hospital encounter -- Has (0:*) --> Outpatient attendance
       (5580, 102, 5626, 6, 0, 0),  -- Hospital Encounter -- Has (0:*) --> Hospital admission
       (5580, 102, 5641, 7, 0, 0),  -- Hospital Encounter -- Has (0:*) --> Ward transfer
       (5580, 102, 5655, 8, 0, 0);  -- Hospital Encounter -- Has (0:*) --> Discharge

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5598, 102, 5434, 0, 0, 0),  -- A&E Attendance -- Has (0:*) --> Practitioner (qual = Effective/Triage/Entered)
    -- (5598, 102, 5414, 1, 0, 1),  -- A&E Attendance -- Has (0:1) --> Organisation (qual = owning) TODO: Inferred from loc?
       (5598, 102, 5420, 2, 0, 1);  -- A&E Attendance -- Has (0:1) --> Location

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5613, 102, 5434, 0, 0, 0),  -- Outpatient -- Has (0:*) --> Practitioner (qualifier = effective/entered/usual)
    -- (5613, 102, 5414, 1, 0, 1),  -- Outpatient -- Has (0:1) --> Organisation (qualifier = owning) TODO: Inferred by location?
       (5613, 102, 5420, 2, 0, 1);  -- Outpatient -- Has (0:1) --> Location

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5626, 102, 5434, 0, 0, 0),  -- Admission -- Has (0:*) --> Practitioner (qualifier = effective/entered)
    -- (5626, 102, 5414, 1, 0, 1),  -- Admission -- Has (0:1) --> Organisation (qualifier = owning) TODO: Inferred by location?
       (5626, 102, 5420, 2, 0, 1);  -- Admission -- Has (0:1) --> Location

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5641, 102, 5434, 0, 0, 0),  -- Ward transfer -- Has (0:*) --> Practitioner (qualifier = effective/entered)
    -- (5641, 102, 5414, 1, 0, 1),  -- Ward transfer -- Has (0:1) --> Organisation (qualifier = owning) TODO: Inferred by location?
       (5641, 102, 5420, 2, 0, 1);  -- Ward transfer -- Has (0:1) --> Location

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5655, 102, 5434, 0, 0, 0),  -- Discharge -- Has (0:*) --> Practitioner (qualifier = effective/entered)
    -- (5655, 102, 5414, 1, 0, 1),  -- Discharge -- Has (0:1) --> Organisation (qualifier = owning) TODO: Inferred by location?
       (5655, 102, 5420, 2, 0, 1);  -- Discharge -- Has (0:1) --> Location

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5674, 102, 5434, 0, 0, 0),  -- Observation -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5674, 102, 5414, 1, 0, 1),  -- Observation -- Has (0:1) --> Organisation (qualifier = owning)
       (5674, 102, 5486, 2, 0, 1);  -- Observation -- Has (0:1) --> Prompt

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5686, 102, 5434, 0, 0, 0),  -- Flag -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5686, 102, 5414, 1, 0, 1);  -- Flag -- Has (0:1) --> Organisation (qualifier = owning)


INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5694, 102, 5434, 0, 0, 0),  -- Problem -- Has (0:*) --> Practitioner (qualifier = last review)
       (5694, 102, 5674, 1, 1, 1);  -- Problem -- Has (1:1) --> Observation (qualifier = owning)    TODO: Should this be reversed?

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5711, 102, 5434, 0, 0, 0),  -- Procedure request -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5711, 102, 5414, 1, 0, 1);  -- Procedure request -- Has (0:1) --> Organisation (qualifier = owning/recipient)

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5726, 102, 5434, 0, 0, 0),  -- Procedure -- Has (0:*) --> Practitioner (qualifier = effective/entered/usual)
       (5726, 102, 5414, 1, 0, 1),  -- Procedure -- Has (0:1) --> Organisation (qualifier = owning)
       (5726, 102, 5486, 2, 0, 1),  -- Procedure -- Has (0:1) --> Prompt
       (5726, 102, 5737, 3, 0, 0);  -- Procedure -- Has (0:*) --> Device

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5737, 102, 5414, 0, 0, 1);  -- Device -- Has (0:1) --> Organisation TODO: Probably should be other way around?

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5767, 102, 5434, 0, 0, 0),  -- Immunisation -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5767, 102, 5414, 1, 0, 1);  -- Immunisation -- Has (0:1) --> Organisation (qualifier = owning)

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5782, 102, 5434, 0, 0, 0),  -- Allergy -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5782, 102, 5414, 1, 0, 1);  -- Allergy -- Has (0:1) --> Organisation (qualifier = owning)

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5800, 102, 5434, 0, 0, 0),  -- Referral -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5800, 102, 5414, 1, 0, 0),  -- Referral -- Has (0:*) --> Organisation (qualifier = owning/sender/recipient)
       (5800, 102, 5613, 2, 0, 1);  -- Referral -- Has (0:1) --> Outpatient

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5830, 102, 5434, 0, 0, 0),  -- Medication statement -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5830, 102, 5414, 1, 0, 1),  -- Medication statement -- Has (0:1) --> Organisation (qualifier = owning)
       (5830, 102, 5808, 2, 0, 1),  -- Medication statement -- Has (0:1) --> Medication amount
       (5830, 102, 5849, 3, 0, 0);  -- Medication statement -- Has (0:*) --> Medication order

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5849, 102, 5434, 0, 0, 0),  -- Medication order -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5849, 102, 5414, 1, 0, 1);  -- Medication order -- Has (0:1) --> Organisation (qualifier = owning)
-- (5849, 102, 5808, 2, 0, 1);  -- Medication order -- Has (0:1) --> Medication amount TODO: inferred from statement?

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5860, 102, 5463, 0, 0, 0),  -- Related person -- Has (0:1) --> Address
       (5860, 102, 5867, 1, 0, 0);  -- Related person -- Has (0:*) --> Contact (method)

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5883, 102, 5434, 0, 0, 0),  -- Care plan -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5883, 102, 5414, 1, 0, 1),  -- Care plan -- Has (0:1) --> Organisation (qualifier = owning)
       (5883, 102, 5897, 2, 0, 0);  -- Care plan -- Has (0:*) --> Care plan activity

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5897, 102, 5434, 0, 0, 0),  -- Care plan activity -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5897, 102, 5414, 1, 0, 1),  -- Care plan activity -- Has (0:1) --> Organisation (qualifier = owning)
       (5897, 102, 5914, 2, 0, 0);  -- Care plan activity -- Has (0:*) --> Care plan activity target

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5914, 102, 5434, 0, 0, 0),  -- Care plan activity target -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5914, 102, 5414, 1, 0, 1);  -- Care plan activity target -- Has (0:1) --> Organisation (qualifier = owning)

-- ********** EXAMPLE SPECIALIZED CONCEPT **********
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5920, 5746, 'Observation.Haemoglobin', 'Haemoglobin observation', ''),
       (5921, 2, 'CodeableConcept.Haemoglobin', 'Haemoglobin codeable concept', ''),        -- TODO: Should be snomed imported code concept
       (5922, 5920, 'Observation.Haemoglobin.g/dl', 'Haemoglobin observation (g/dl)', ''),
       (5923, 5920, 'Observation.Haemoglobin.g/l', 'Haemoglobin observation (g/l)', '');


INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`, inheritance, value_concept, value_expression, fixed_concept, fixed_value)
SELECT 5920, attribute, `order`, mandatory, `limit`, 2, value_concept, value_expression, 5921, null
FROM concept_attribute
WHERE concept = 5674    -- Observation
  AND attribute = 5660;   -- Observation Concept

INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`, inheritance, value_concept, value_expression, fixed_concept, fixed_value)
SELECT 5922, attribute, `order`, mandatory, `limit`, 2, value_concept, value_expression, 5381 , null
FROM concept_attribute
WHERE concept = 5746    -- Numeric Observation
  AND attribute = 5742;   -- Unit of measure

INSERT INTO concept_attribute (concept, attribute, `order`, mandatory, `limit`, inheritance, value_concept, value_expression, fixed_concept, fixed_value)
SELECT 5923, attribute, `order`, mandatory, `limit`, 2, value_concept, value_expression, 5382 , null
FROM concept_attribute
WHERE concept = 5746    -- Numeric Observation
  AND attribute = 5742;   -- Unit of measure

INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES (5922, 101, 5923, 0, 1, 1);

UPDATE concept
SET status = 1;

-- ************************************** IM MODEL DATA **************************************
*/
DELETE
FROM table_id;
INSERT INTO table_id (name, id)
SELECT 'Concept', MAX(id) + 1
FROM concept;

-- Build the transitive closure table for concept inheritance hierarchy
CALL proc_build_tct();
