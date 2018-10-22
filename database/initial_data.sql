USE im2;

-- TODO: Need to review as many of these no longer relevant in new Information Model db schema. Commented out (until used) for clarity
-- ************************************** CORE IM DATA **************************************

-- BASE (PRIMITIVE) TYPES (super = 1)
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (1, 1, 'Concept', 'Concept', 'Abstract base concept to which all concept types belong'),
       (2, 1, 'Concept.Codeable concept', 'Codeable concept', 'Any concept that can be identified as part of a taxonomy or classification'),
       (3, 1, 'Concept.Folder', 'Folder', 'A concept that contains other concepts as a place holder in a view'),
       (4, 1, 'Concept.Record Type', 'Record', 'A structure that contains attributes'),
       (5, 1, 'Concept.Relationship', 'Relationship', 'A concept only used in the relationship links between one concept and another, '),
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

-- RELATIONSHIPS (super = 5)
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (100, 5, 'Relationship.is a', 'is a', 'source concept inherits the semantic meaning of the more generalised target - source is more specialised - (T2 is a Diabetes)'),
       (101, 5, 'Relationship.Related to', 'is related to', 'The source is related to the target in an unsepecified way'),
       -- (102, 5, 'Relationship.has a', 'has a', 'Source has an attribute type of the target'),        -- Attribute replaces
       (103, 5, 'Relationship.Qualifier', 'has qualifier', 'The source has a qualifier in relation to the concept it is related to'),
       -- (104, 5, 'Relationship.extends', 'extends', 'The source extends (inherits attributes of) the target'),       -- Superclass replaces
       (105, 5, 'Relationship.Delivers', 'Delivers', 'The source delivers the target (e.g. Organisation delivers Service)'),    -- TODO: "Provides"?
       (106, 5, 'Relationship.Uses', 'Uses', 'Org uses system'),    -- TODO: Dont like this!
       (107, 5, 'Relationship.Parent', 'has parent', 'Source concept has parent of target'),
       (108, 5, 'Relationship.Primary', 'is primary', ''), -- TODO: Should remodel, is a flag
       (109, 5, 'Relationship.Belongs', 'belongs to', 'Source belongs to target'),  -- TODO: Inverse & replace with "Has"??
       (110, 5, 'Relationship.EnteredBy', 'entered by', 'Source data entered by target');   -- TODO: Dont like

-- FOLDERS (super = 3)
-- TO BE REPLACED BY "VIEWS"????
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (500, 3, 'Folder.Information model', 'Information model', 'The Discovery information model is a knowledge base that describes all of the kn'),
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
INSERT INTO concept_relationship (source, relationship, target)
VALUES
       (504, 100, 500),    -- Care admin folder       -- is a --> IM folder
       (505, 100, 500),    -- Clin rec folder         -- is a --> IM folder
       (506, 100, 500),    -- Care proc. folder       -- is a --> IM folder
       (507, 100, 500),    -- Other ents folder       -- is a --> IM folder
       (510, 100, 500),    -- Rec. structs folder     -- is a --> IM folder
       (512, 100, 510),    -- Spec. rec. types folder -- is a --> IM folder
       (513, 100, 500),    -- Supp. structs folder    -- is a --> IM folder
       (514, 100, 513),    -- Types folder            -- is a --> Supp. structs folder
       (502, 100, 513),    -- Atts & rels folder      -- is a --> Supp. structs folder
       (515, 100, 502),    -- Relationships folder    -- is a --> Atts & rels folder
       (516, 100, 502);    -- Atts folder             -- is a --> Atts & rels folder

-- ************************************** IM MODEL DATA **************************************
       /* ORIGINAL IM DATA
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (1000, 4, 'RecordType.Health record event', 'Health record event', 'The basic items in any event based health record entry'),
       (1001, 4, 'RecordType.Patient master demographics', 'Patient master demographics', 'Patient demographic information relating to their birth&#44; administrative gend'),
       (1002, 4, 'RecordType.Practitioner in role', 'Practitioner in role', 'Information describing any person who provides care or is part of the health car'),
       (1003, 4, 'RecordType.Device', 'Device', 'Information about a medical device used in care and classified according to type'),
       (1004, 4, 'RecordType.Organisation service or department', 'Organisation service or department', 'Information about organisations&#44; services&#44; or departments '),
       (1005, 4, 'RecordType.Location', 'Location', 'Information about an actual location (which may have an address separate to the '),
       (1006, 4, 'RecordType.Care episode', 'Care episode', 'A care episode is an association between a patient and a healthcare provider dur'),
       (1007, 4, 'RecordType.Care episode administration', 'Care episode administration', 'Information about the administration of patient reception and registration in th'),
       (1008, 4, 'RecordType.Encounter', 'Encounter', 'An encounter is an interaction between a patient and healthcare provider for the'),
       (1010, 4, 'RecordType.Referral request', 'Referral request', 'A referral request includes request for advice or invitation to participate in c'),
       (1011, 4, 'RecordType.Procedure or test request', 'Procedure or test request', 'A procedure request is a record of a request for a procedure to be planned&#44; '),
       (1012, 4, 'RecordType.Appointment schedule', 'Appointment schedule', 'An appointment schedule is an appointment grouping implying a session or a clini'),
       (1013, 4, 'RecordType.Appointment booking history', 'Appointment booking history', 'Information about the process of booking and unbooking of a planned appointment '),
       (1014, 4, 'RecordType.Appointment slot', 'Appointment slot', 'This is information about a particular appointment or slot as planned. This is a'),
       (1015, 4, 'RecordType.Appointment attendance', 'Appointment attendance', 'Historical Information about an actual attendance for a patient for an appointme'),
       (1016, 4, 'RecordType.Care plan', 'Care plan', 'Simple plans (such as review dates) or a relatively simple data subset of a comp'),
       (1018, 4, 'RecordType.Observation', 'Observation', 'A Generic observation is the root for most clinical entries about a patient&#44;'),
       (1019, 4, 'RecordType.Numeric observation', 'Numeric observation', 'Any observation with a numeric value e.g. path result or vital signs. A numeric '),
       (1020, 4, 'RecordType.Procedure', 'Procedure', 'Procedure provides more information  beyond a simple observation about an operat'),
       (1021, 4, 'RecordType.Immunisation', 'Immunisation', 'Immunisation extends a simple observation by providing more information about th'),
       (1022, 4, 'RecordType.Allergy and adverse reaction', 'Allergy and adverse reaction', 'Allergies provide more information about the allergy such as the substance and n'),
       (1023, 4, 'RecordType.Problem', 'Problem', 'Problem is a patient and record management construct designed to help manage car'),
       (1024, 4, 'RecordType.Medication statement', 'Medication statement', 'Medication entries are templates for describing and authorising a course of medi'),
       (1025, 4, 'RecordType.Medication order or issue', 'Medication order or issue', 'A medication order is the actual prescription for a medication item. It represen'),
       (1026, 4, 'RecordType.Flag or Alert', 'Flag or Alert', 'A flag is a warning or notification of some sort presented to the user - who may'),
       (1027, 4, 'RecordType.Consent', 'Consent', 'Patient may consent or dissent for a variety of service provision or sharing of '),
       (1028, 4, 'RecordType.Patient organisational demographics', 'Patient organisational demographics', 'Details about the patient in the context of a particlar organisation'),
       (1029, 4, 'RecordType.Name', 'Name', 'Information about the name'),
       (1030, 4, 'RecordType.Address', 'Address', 'Address details'),
       (1031, 4, 'RecordType.Contact', 'Contact', 'Information about contact numbers and email addresses'),
       (1032, 4, 'RecordType.Related person', 'Related person', 'Information about related persons to a patient'),
       (1033, 4, 'RecordType.Post code linked data', 'Post code linked data', 'LSOA MSOA IMDS and data related to a post code'),
       (1034, 4, 'RecordType.Person in role', 'Person in role', 'Information about a person in a role'),
       (1035, 4, 'RecordType.Identifier', 'Identifier', 'An identifier including the scheme and value'),
       (1036, 4, 'RecordType.Quantity time', 'Quantity time', 'An attribute group specialising in  units of time'),
       (1037, 4, 'RecordType.Quantity medication', 'Quantity medication', 'An attribute group specialising in medication quantities with a value and unit'),
       (1038, 4, 'RecordType.Quantity measure', 'Quantity measure', 'Numeric quantity with units that are measurements eg. Weights ot lengths'),
       (1039, 4, 'RecordType.Range numeric', 'Range numeric', 'structure that has a range type operator and upper and lower value'),
       (5000, 11, 'Date time attribute.Date and time entry recorded', 'Date and time entry recorded', 'The data and time the entry was made. This may not be the same as the date and t'),
       (5001, 4, 'RecordType.Recorded by', 'Recorded by', 'The person or device who recorded the entry. This may or may not be the same as '),
       (5002, 4, 'RecordType.Responsible practitioner', 'Responsible practitioner', 'The person responsible for the entry, usually a professional health worker'),
       (5003, 11, 'Date time attribute.Effective date and time', 'Effective date and time', 'e.g. a year or month). It may be a point in time or a period of time (e.g. an en'),
       (5004, 4, 'RecordType.Patient or service user', 'Patient or service user', 'The patient/client/service user  to whom the entry refers'),
       (5005, 4, 'RecordType.Owning organisation', 'Owning organisation', 'The organisation or service within an organisation responsible for the entry of '),
       (5006, 12, 'Text attribute.Pseudonymised patient id', 'Pseudonymised patient id', 'Hash with Salt key of identifiers of the patient'),
       (5007, 12, 'Text attribute.NHS number', 'NHS number', 'The NHS number allocated to the patient.'),
       (5009, 12, 'Text attribute.Title', 'Title', 'Title or prefix to name'),
       (5010, 12, 'Text attribute.First name(s)', 'First name(s)', 'Forenames or first names or given names'),
       (5011, 12, 'Text attribute.Middle names', 'Middle names', 'After the first and before the last'),
       (5012, 12, 'Text attribute.Last name', 'Last name', 'Last name or surname or family name'),
       (5013, 7, 'Codeable attribute.Gender (administrative)', 'Gender (administrative)', 'The gender that the person considers themselves to be allocated to for the purpo'),
       (5014, 11, 'Date time attribute.Date of birth', 'Date of birth', 'Date of birth of the patient, as far as is known'),
       (5015, 11, 'Date time attribute.Pseudonymised date of birth', 'Pseudonymised date of birth', 'Date of birth by year or month depending on age of patient and level of de-idnti'),
       (5016, 8, 'Whole number attribute.Age', 'Age', 'Age of patient as calculated between date of birth and the date of interest'),
       (5017, 13, 'Boolean attribute.Death indicator', 'Death indicator', 'If a patient has died an indicator that they are now dead'),
       (5018, 11, 'Date time attribute.Date of death', 'Date of death', 'If dead and if available, the date of death'),
       (5019, 4, 'RecordType.Patient identifier', 'Patient identifier', 'An identifier for the person. For example a hospital number, CHI number, NI num'),
       (5020, 7, 'Codeable attribute.Identifier scheme', 'Identifier scheme', 'Nature of the persons identifier e.g. hospital number, CHI number'),
       (5021, 12, 'Text attribute.Identifier value', 'Identifier value', 'Value of the persons identifier'),
       (5022, 12, 'Text attribute.Pseudonymised address', 'Pseudonymised address', 'Hash with Salt key of household'),
       (5023, 7, 'Codeable attribute.Address type', 'Address type', 'A location address'),
       (5024, 12, 'Text attribute.Address line 1', 'Address line 1', 'First line, normally house name or number'),
       (5025, 12, 'Text attribute.Address line 2', 'Address line 2', 'Second address line normally street'),
       (5026, 12, 'Text attribute.Locality', 'Locality', 'Third address line normally village or area'),
       (5027, 12, 'Text attribute.City', 'City', 'Fourth address line normally town'),
       (5028, 12, 'Text attribute.Address line 5', 'Address line 5', 'Fifth address line normally county'),
       (5029, 12, 'Text attribute.Post code', 'Post code', 'Post code of address'),
       (5030, 12, 'Text attribute.UPRN', 'UPRN', 'Unique property reference number (household)'),
       (5031, 12, 'Text attribute.Lower super output area', 'Lower super output area', 'Geographical area linked to postcode more specific than MSOA'),
       (5032, 12, 'Text attribute.Middle super output area', 'Middle super output area', 'Geopgraphical area linked to postcode less specific than LSOA'),
       (5033, 4, 'RecordType.Contact information', 'Contact information', 'potentially used in contacting the individual, each contact qualified by contac'),
       (5034, 7, 'Codeable attribute.Contact type', 'Contact type', 'whether email telephone number etc'),
       (5035, 12, 'Text attribute.Contact value', 'Contact value', 'Actual telephone number or email'),
       (5036, 7, 'Codeable attribute.Ethnicity', 'Ethnicity', 'Derived from the latest ethnic group observation'),
       (5037, 7, 'Codeable attribute.Language', 'Language', 'Links to the Languages that the patient speaks qualified by preferred spoken etc'),
       (5038, 7, 'Codeable attribute.Confidentiality type', 'Confidentiality type', 'When a record is marked as confidential what is the type of confidentiality '),
       (5039, 4, 'RecordType.Related persons', 'Related persons', 'Information about people related to the patient (family carers etc)'),
       (5040, 12, 'Text attribute.Previous last name', 'Previous last name', 'last name the patient was known by (this is not the audit trail of previous name'),
       (5041, 12, 'Text attribute.Index of multiple deprivation', 'Index of multiple deprivation', 'Statistical index of multiple deprivation'),
       (5042, 12, 'Text attribute.Active status', 'Active status', 'Whether active or not'),
       (5043, 4, 'RecordType.Service or organisation', 'Service or organisation', 'Points to the organisation or service that this attribute represents'),
       (5044, 7, 'Codeable attribute.Role type', 'Role type', 'The type of role the user operates as (e.g. doctor nurse)'),
       (5045, 7, 'Codeable attribute.Speciality', 'Speciality', 'The speciality this attribute refers to'),
       (5046, 11, 'Date time attribute.Contract start date', 'Contract start date', 'Date the contract started'),
       (5047, 11, 'Date time attribute.Contract end date', 'Contract end date', 'Date the contract ended (if no longer active)'),
       (5048, 4, 'RecordType.Related person information', 'Related person information', 'Link to a related person details when they are not in the Discovery database'),
       (5049, 7, 'Codeable attribute.Related person relationship', 'Related person relationship', 'The type of relationship e.g. Mother, Father, Genetic mother etc'),
       (5050, 4, 'RecordType.Related patient', 'Related patient', 'Link to a related patient who is actually in the Database'),
       (5051, 12, 'Text attribute.Device name', 'Device name', 'The actual name of the device'),
       (5052, 12, 'Text attribute.Human readable UDI', 'Human readable UDI', 'The human readable bar code of the device'),
       (5053, 12, 'Text attribute.Machine readable UDI', 'Machine readable UDI', 'machine readable bar code in hex'),
       (5054, 12, 'Text attribute.Serial number', 'Serial number', 'Serial number of the device'),
       (5055, 12, 'Text attribute.Manufacturer', 'Manufacturer', 'Information about a manufacturer of a device'),
       (5056, 7, 'Codeable attribute.Device type', 'Device type', 'What sort of device it is'),
       (5057, 12, 'Text attribute.Device version', 'Device version', 'Version of the device (if software)'),
       (5058, 4, 'RecordType.Organisational identifier', 'Organisational identifier', 'Main identifier of organisation used throughout the service e.g. ODS code'),
       (5059, 12, 'Text attribute.Organisation/ service name', 'Organisation/ service name', 'Text of organisation name'),
       (5060, 7, 'Codeable attribute.Organisaion/ service category', 'Organisaion/ service category', 'Type of organisation department or service'),
       (5062, 7, 'Codeable attribute.Location type', 'Location type', 'Type of location e.g. ward, branch surgery'),
       (5063, 7, 'Codeable attribute.Consent type', 'Consent type', 'Nature of the process the consent is for e.g. summary care record, type II obje'),
       (5064, 7, 'Codeable attribute.Consent or Dissent', 'Consent or Dissent', 'Consent or dissent qhich may be qualfied'),
       (5065, 11, 'Date time attribute.End date and time', 'End date and time', 'End date and time relevant to this type of entry'),
       (5066, 4, 'RecordType.Consent target', 'Consent target', 'id of a contract or agreement or some other target of the consent'),
       (5067, 7, 'Codeable attribute.Nature of care episode', 'Nature of care episode', 'Nature or type of care episode (e.g. GMS registration hospital episode)'),
       (5068, 4, 'RecordType.Initiating referral', 'Initiating referral', 'Link to the referral that initiated this entry'),
       (5069, 4, 'RecordType.Episode administration process linked', 'Episode administration process linked', 'Link to the list of administration processes associated with this episode (e.g.'),
       (5070, 4, 'RecordType.Linked entries', 'Linked entries', 'Links to the entries associated with this entry'),
       (5071, 7, 'Codeable attribute.Episode administration status', 'Episode administration status', 'The nature of the administration entry (e.g. notification of registration)'),
       (5072, 7, 'Codeable attribute.Episode admin status subtype', 'Episode admin status subtype', 'More specific substype of the admin status (e.g. death or embarkation against a '),
       (5073, 7, 'Codeable attribute.Patient episode administration type', 'Patient episode administration type', 'Categorisation of the patient in a care episode for contract purposes (e.g. reg'),
       (5074, 4, 'RecordType.Linked care episode', 'Linked care episode', 'Link to the care episode '),
       (5078, 7, 'Codeable attribute.Completion status', 'Completion status', 'Status of completion of an entry (e.g. completed or ongoing)'),
       (5079, 4, 'RecordType.Duration', 'Duration', 'Duration of an event with units and a value'),
       (5080, 4, 'RecordType.Travel time', 'Travel time', 'Time of travelling in relation to the event with units and a value'),
       (5081, 7, 'Codeable attribute.Reason for encounter', 'Reason for encounter', 'A reason for the event (e.g encounter) often as text'),
       (5082, 12, 'Text attribute.Reason text', 'Reason text', 'Textual free text reason for an event'),
       (5083, 4, 'RecordType.Linked appointment', 'Linked appointment', 'Link to the associated appointment'),
       (5084, 4, 'RecordType.Parent encounter', 'Parent encounter', 'Link to the parent encounter entry'),
       (5085, 4, 'RecordType.Child encounter', 'Child encounter', 'Link to a child encounter'),
       (5086, 4, 'RecordType.Additional practitioners', 'Additional practitioners', 'Link to additional practitioners associated with this event'),
       (5090, 4, 'RecordType.Destination location', 'Destination location', 'Location of the destination in a care transfer or referral'),
       (5092, 7, 'Codeable attribute.Priority', 'Priority', 'Priority of event e.g. referral'),
       (5093, 7, 'Codeable attribute.Referred by type', 'Referred by type', 'Nature of referral person e.g. self referral professional'),
       (5094, 4, 'RecordType.Source organisation', 'Source organisation', 'Link to the organisation that was the source of the referral or care transfer'),
       (5095, 7, 'Codeable attribute.Service type requested', 'Service type requested', 'The type of service being requested by the referral e.g. Advice'),
       (5096, 7, 'Codeable attribute.Speciality requested', 'Speciality requested', 'Speciality of the requested service'),
       (5097, 7, 'Codeable attribute.Referral reason ', 'Referral reason ', 'The clinical condition or problem for which the referral has been made'),
       (5098, 4, 'RecordType.Recipient service or clinic', 'Recipient service or clinic', 'Service or organisation that this referral is to (e.g. the clinic)'),
       (5099, 4, 'RecordType.Recipient location', 'Recipient location', 'Location or destination location of the referral'),
       (5100, 4, 'RecordType.Recipent practitioner', 'Recipent practitioner', 'The person to whom the referral is made'),
       (5101, 12, 'Text attribute.Referral UBRN', 'Referral UBRN', 'Referral number of reference'),
       (5102, 7, 'Codeable attribute.Referral mode', 'Referral mode', 'Way of making referral e.g. letter, verbal, ERS- online'),
       (5103, 7, 'Codeable attribute.Requested procedure', 'Requested procedure', 'The test that is being ordered'),
       (5104, 7, 'Codeable attribute.Reason for procedure request', 'Reason for procedure request', 'Codeable reason for the test request'),
       (5105, 12, 'Text attribute.Reason for request - text', 'Reason for request - text', 'Narrative about reason for request'),
       (5106, 12, 'Text attribute.Request identifier', 'Request identifier', 'order number'),
       (5107, 4, 'RecordType.Linked encounter', 'Linked encounter', 'The encounter this entry is linked to'),
       (5109, 7, 'Codeable attribute.Type of schedule', 'Type of schedule', 'Nature of the appointment schedule'),
       (5110, 12, 'Text attribute.Schedule description', 'Schedule description', 'Text description of schedule'),
       (5112, 11, 'Date time attribute.Start Date and Time', 'Start Date and Time', 'Start Date and time for a very specific period of time'),
       (5113, 4, 'RecordType.Linked appointment slots', 'Linked appointment slots', 'Appointments linked to this schedule'),
       (5114, 4, 'RecordType.Practitioners', 'Practitioners', 'List of practitioners linked to this entry'),
       (5115, 7, 'Codeable attribute.Appointment category', 'Appointment category', 'Type of appointment slot'),
       (5116, 7, 'Codeable attribute.Planned reason', 'Planned reason', 'A codeable planned reason for the appointment '),
       (5117, 12, 'Text attribute.Planned reason text', 'Planned reason text', 'Narrative about reason for appointment'),
       (5118, 12, 'Text attribute.Description', 'Description', 'Narrative description associated with this entry'),
       (5119, 4, 'RecordType.Planned duration', 'Planned duration', 'Planned period of time for this activity'),
       (5120, 11, 'Date time attribute.Start time', 'Start time', 'Start time for an activity (when date not normally displayed)'),
       (5121, 11, 'Date time attribute.End time', 'End time', 'Start time (when a date is not normally specified)'),
       (5122, 7, 'Codeable attribute.Slot booking status', 'Slot booking status', 'Status of the booking in relation to the slot'),
       (5123, 7, 'Codeable attribute.Attendance status', 'Attendance status', 'Status of whether the patient has arrived for the appointment, gone in or left '),
       (5124, 7, 'Codeable attribute.Booking urgency', 'Booking urgency', 'Reflection of whether the appointment was booked as urgent (whether it was an ur'),
       (5125, 4, 'RecordType.Linked schedule', 'Linked schedule', 'Link to the schedule the appointment slot is part of'),
       (5126, 4, 'RecordType.Booking history', 'Booking history', 'Links to the history of bookings or cancellations for this slot'),
       (5127, 7, 'Codeable attribute.Booking or cancellation', 'Booking or cancellation', 'Whether this is a booking transaction or cancellation transaction'),
       (5128, 4, 'RecordType.Patient expressed reason', 'Patient expressed reason', 'Reason for appointment as expressed by patient'),
       (5129, 4, 'RecordType.Linked appointment slot', 'Linked appointment slot', 'The appointment slot linked to this entry'),
       (5130, 7, 'Codeable attribute.Document status', 'Document status', 'Status of plan or document, draft, active, replaced etc'),
       (5131, 4, 'RecordType.Type of plan', 'Type of plan', 'Category of plan such as Asthma action plan - cancer management plan - Procedure'),
       (5132, 4, 'RecordType.Linked activities', 'Linked activities', 'links to the activities associated with the plan'),
       (5133, 4, 'RecordType.Linked episodes', 'Linked episodes', 'Care episodes linked to this plan'),
       (5134, 4, 'RecordType.Parent plan', 'Parent plan', 'The plan this plan is part of'),
       (5135, 4, 'RecordType.Associated practitioners', 'Associated practitioners', 'Pracitioners associated with the plan'),
       (5136, 4, 'RecordType.Associated teams', 'Associated teams', 'Teams associated with this plan'),
       (5137, 12, 'Text attribute.Team name', 'Team name', 'Name of the team'),
       (5138, 4, 'RecordType.Team members', 'Team members', 'Practioners who are members of teams'),
       (5139, 4, 'RecordType.Heading', 'Heading', 'The heading term used to structure a record, a document or a template for human'),
       (5142, 4, 'RecordType.Order', 'Order', 'Used to order this entry in respect of its parent'),
       (5143, 4, 'RecordType.Linked care plan', 'Linked care plan', 'The care plan to which this entry links'),
       (5144, 4, 'RecordType.Observation type', 'Observation type', 'Category f the observation, including whether this is a sub-type entry (describ'),
       (5145, 4, 'RecordType.Observation concept', 'Observation concept', 'Nature of the entry, nearly always a Snomed-CT concept. <p>This may be a simple'),
       (5146, 4, 'RecordType.Context', 'Context', 'Prompt or question or other preceding text that provides the context for the res'),
       (5147, 4, 'RecordType.Is problem', 'Is problem', 'Whether or not this entry forms all or part of the problem definition'),
       (5148, 4, 'RecordType.Problem episode', 'Problem episode', 'If this is a problem code, whether this observation indicates a review or onset'),
       (5149, 4, 'RecordType.Normality', 'Normality', 'Whether normal or not and nature of abormality (e.g. high or low)'),
       (5150, 4, 'RecordType.Linked problems', 'Linked problems', 'Links to parent or child problems or problems that have been evolved from'),
       (5151, 4, 'RecordType.Child observations', 'Child observations', 'Links to child observations'),
       (5152, 4, 'RecordType.Parent observation', 'Parent observation', 'Link to parent observation'),
       (5154, 4, 'RecordType.Flag', 'Flag', 'An alert or flag linked to this entry'),
       (5155, 4, 'RecordType.Operator', 'Operator', 'Nature of arithmetic operator such as greater than or less than '),
       (5156, 4, 'RecordType.Numeric value', 'Numeric value', 'Numeric value of concept'),
       (5157, 4, 'RecordType.Reference range', 'Reference range', 'The normal reference range for this observation not to be confused with referenc'),
       (5158, 4, 'RecordType.Linked ranges', 'Linked ranges', 'Other ranges associated with this observation provided for background informatio'),
       (5159, 4, 'RecordType.Units of measure', 'Units of measure', 'Code of units of measure (e.g. mm Hg  IU/L)'),
       (5160, 4, 'RecordType.Performed period', 'Performed period', 'Period of time the procedure or activity took (units and value)'),
       (5161, 4, 'RecordType.Outcome', 'Outcome', 'Coded outcome of the procedure or activity'),
       (5162, 4, 'RecordType.Outcome text', 'Outcome text', 'Textual description of outcome of procedure'),
       (5163, 4, 'RecordType.Complications', 'Complications', 'Complication observations linked to the procedure'),
       (5164, 4, 'RecordType.Follow ups', 'Follow ups', 'Link to care plan diary entries'),
       (5165, 4, 'RecordType.Devices used', 'Devices used', 'Links to devices use in the procedure'),
       (5166, 4, 'RecordType.Flag category', 'Flag category', 'Category of flag used to determine when the flag is normally displayed in an app'),
       (5167, 4, 'RecordType.Flag type', 'Flag type', 'Type of flag as a standard codable concept Do not stop taking this medication wi'),
       (5168, 4, 'RecordType.Flag text', 'Flag text', 'Textual description of flag, additional to the flag type or as an alternative t'),
       (5169, 4, 'RecordType.Substance', 'Substance', 'The actual substance to which the entry relates. <p> It might be a specific drug'),
       (5170, 4, 'RecordType.Manifestation', 'Manifestation', 'The nature of the reaction associated with the allergy or adverse reactoin such'),
       (5171, 4, 'RecordType.Manifestation description', 'Manifestation description', 'Textual descriptoin of the manifestation in addition to or instead of the manife'),
       (5172, 4, 'RecordType.Batch number', 'Batch number', 'Batch number of vaccine'),
       (5173, 4, 'RecordType.Expiry date', 'Expiry date', 'Expiry date of product'),
       (5174, 4, 'RecordType.Vaccine product', 'Vaccine product', 'The actual vaccine product'),
       (5175, 4, 'RecordType.Vaccine dose sequence', 'Vaccine dose sequence', 'Number of the vaccine in the course (1st 2nd 3rd etc)'),
       (5176, 4, 'RecordType.Vaccine doses required', 'Vaccine doses required', 'Number of doses required to achieve immunity'),
       (5177, 4, 'RecordType.Reaction', 'Reaction', 'Link to the observation record holding a reaction to the vaccine'),
       (5178, 4, 'RecordType.Problem type', 'Problem type', 'Concept: for the term that the healthcare worker assigns to this construct e.g.'),
       (5179, 4, 'RecordType.Significance', 'Significance', 'Whether significant minor or other significance concepts'),
       (5180, 4, 'RecordType.Expected duration', 'Expected duration', 'How long it is expected that the issue relating to this entry would be expected '),
       (5181, 4, 'RecordType.Parent problem', 'Parent problem', 'Link to the problem this is a part of'),
       (5182, 4, 'RecordType.Child problems', 'Child problems', 'Links to child problems'),
       (5183, 4, 'RecordType.Medication', 'Medication', 'The medication or appliance that this entry refers to'),
       (5184, 4, 'RecordType.Dosage structured', 'Dosage structured', 'The expression describing the dosage in computable terms'),
       (5185, 4, 'RecordType.Dosage text', 'Dosage text', 'Textual description of the dosage of the medication'),
       (5186, 4, 'RecordType.Quantity of medicine', 'Quantity of medicine', 'Quantity of medication related to a dosage or order'),
       (5187, 4, 'RecordType.Number of authorised repeats', 'Number of authorised repeats', 'number in the course that can be issued before the patient must be reviewed'),
       (5188, 4, 'RecordType.Review date', 'Review date', 'Date that this particular medication should be reviewed (as distinct from the re'),
       (5189, 4, 'RecordType.Order duration', 'Order duration', 'Expected duration of the presription or ordered item e.g. 28 days'),
       (5190, 4, 'RecordType.Additional patient instructions', 'Additional patient instructions', 'Additional instructions to the patient for taking medication or activity'),
       (5191, 4, 'RecordType.Pharmacy instruction', 'Pharmacy instruction', 'Additoinal instructions to the pharmacist beyond the dosage instructions'),
       (5192, 4, 'RecordType.Treatment management responsibility', 'Treatment management responsibility', 'The health domain type that manages the medication e.g. hospital, pharmacy, gen'),
       (5193, 4, 'RecordType.Originating health domain', 'Originating health domain', 'The health domain type that originated the medicatoin e.g. hospital, pharmacy, '),
       (5194, 4, 'RecordType.Reason for ending medication', 'Reason for ending medication', 'Reason for ending the medication'),
       (5195, 4, 'RecordType.Linked medication orders', 'Linked medication orders', 'Links to the medication issues or actual prescriptions for this medication'),
       (5196, 4, 'RecordType.Flags', 'Flags', 'Links to flags or alerts associated with this medication statement (not to be co'),
       (5197, 4, 'RecordType.Course type', 'Course type', 'Whether this is a one off, a repeat medication or repeat dispensing medication'),
       (5198, 4, 'RecordType.Planned date', 'Planned date', 'Planned date (e.g. date for recall)'),
       (5200, 4, 'RecordType.Units of time', 'Units of time', 'units relating to time'),
       (5201, 4, 'RecordType.Healthcare service type', 'Healthcare service type', 'The historical category of health care service such as general practice or acute services'),
       (5202, 4, 'RecordType.Interaction mode', 'Interaction mode', 'Nature of social interaction between participants such as face to face via the telephon etc'),
       (5203, 4, 'RecordType.Administrative action', 'Administrative action', 'A type of action in respect of processing a patient through the health system e.g. admission and discharge or transfers'),
       (5204, 4, 'RecordType.General purpose', 'General purpose', 'General purpose of encounter or event'),
       (5205, 4, 'RecordType.Location', 'Location', 'Points to a physical location'),
       (5206, 7, 'Codeable attribute.Disposition', 'Disposition', 'Nature of the disposition of the patient after the event or encounter'),
       (5207, 7, 'Codeable attribute.Site of care type', 'Site of care type', 'Description of site of care or location type eg hospital or daya centre'),
       (5208, 7, 'Codeable attribute.Patient status', 'Patient status', 'Status of patient in respect of the event or encounter'),
       (5209, 7, 'Codeable attribute.Address format type', 'Address format type', 'The format of the address e.g. PAF unstructured PDS'),
       (5210, 12, 'Text attribute.Address line 3', 'Address line 3', '3rd address line of an address'),
       (5211, 12, 'Text attribute.Address line 4', 'Address line 4', '4th address line of the address'),
       (5212, 8, 'Whole number attribute.Minimum occurrences', 'Minimum occurrences', 'the minimum number of occurrences of this attribute - 0 means optional'), */

-- ********** CODE SCHEMES **********
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5300, 1, 'Code Scheme', 'Coding scheme', 'A coding scheme'),
       (5301, 1, 'Code Scheme.SNOMED', 'SNOMED CT', 'The SNOMED CT coding scheme');
INSERT INTO concept_relationship (source, relationship, target)
VALUES
       (5031, 100, 5030); -- SNOMED                  -- is a --> Code scheme

-- ********** DM+D **********
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5302, 4, 'DM+D.VTM', 'Virtual therapeutic moiety', ''),
       (5303, 4, 'DM+D.VPI', 'Virtual product ingredient', ''),
       (5304, 4, 'DM+D.CDPI', 'Controlled drug prescribing information', ''),
       (5305, 4, 'DM+D.DRI', 'Drug route information', ''),
       (5306, 4, 'DM+D.ODRI', 'Ontology drug form & route info', ''),
       (5307, 4, 'DM+D.DFI', 'Dose form information', ''),
       (5308, 4, 'DM+D.VMP', 'Virtual medicinal product', ''),
       (5309, 4, 'DM+D.APE', 'Actual product excipient', ''),
       (5310, 4, 'DM+D.APrI', 'Appliance product information', ''),
       (5311, 4, 'DM+D.LR', 'Licensed route', ''),
       (5312, 4, 'DM+D.AMP', 'Actual medicinal product', ''),
       (5313, 4, 'DM+D.VCPC', 'Virtual combination pack content', ''),
       (5314, 4, 'DM+D.DTCI', 'Drug tariff category info', ''),
       (5315, 4, 'DM+D.VMPP', 'Virtual medicinal product pack', ''),
       (5316, 4, 'DM+D.PPI', 'Product prescribing info', ''),
       (5317, 4, 'DM+D.APkI', 'Appliance pack info', ''),
       (5318, 4, 'DM+D.RI', 'Reimbursement info', ''),
       (5319, 4, 'DM+D.MPP', 'Medicinal product price', ''),
       (5320, 4, 'DM+D.ACPC', 'Actual combination pack content', ''),
       (5321, 4, 'DM+D.AMPP', 'Actual medicinal product pack', ''),
       (105, 5, 'Relationship.IsBranded', 'is branded type of', ''),
       (106, 5, 'Relationship.PackOf', 'is pack of', '');
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
VALUES
       (5308, 5302, 0, 0, 1),   -- VMP -- (0:1) --> VTM
       (5308, 5303, 1, 0, 0),   -- VMP -- (0:*) --> VPI
       (5308, 5304, 2, 0, 1),   -- VMP -- (0:1) --> CDPI
       (5308, 5305, 3, 0, 0),   -- VMP -- (0:*) --> DRI
       (5308, 5306, 4, 0, 0),   -- VMP -- (0:*) --> ODRI
       (5308, 5307, 5, 0, 1),   -- VMP -- (0:1) --> DFI

       (5312, 5309, 0, 0, 0),   -- AMP -- (0:*) --> APE
       (5312, 5310, 1, 0, 1),   -- AMP -- (0:1) --> APrI
       (5312, 5311, 2, 0, 0),   -- AMP -- (0:*) --> LR

       (5315, 5313, 0, 0, 0),   -- VMPP -- (0:*) --> VCPC
       (5315, 5314, 1, 0, 1),   -- VMPP -- (0:1) --> DTCI

       (5321, 5316, 0, 0, 1),   -- AMPP -- (0:1) --> PPI
       (5321, 5317, 1, 0, 1),   -- AMPP -- (0:1) --> APkI
       (5321, 5318, 2, 0, 1),   -- AMPP -- (0:1) --> RI
       (5321, 5319, 3, 0, 1),   -- AMPP -- (0:1) --> MPP
       (5321, 5320, 4, 0, 0);   -- AMPP -- (0:*) --> ACPC
INSERT INTO concept_relationship (source, relationship, target, mandatory, `limit`)
VALUES
    -- DM+D data model relationships
       (5312, 105, 5308, 1, 1),     -- AMP  -- (1:1) Branded --> VMP
       (5315, 106, 5308, 1, 1),     -- VMPP -- (1:1) Pack of --> VMP
       (5321, 105, 5315, 1, 1),     -- AMPP -- (1:1) Branded --> VMPP
       (5321, 106, 5312, 1, 1);     -- AMPP -- (1:1) Pack of --> AMP

-- ********** PCR v2 Schema/Relational model **********

-- Base concepts
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5350, 1, 'Service', 'Service', ''),
       (5351, 1, 'System', 'System', '');

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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
       (5414, 4,  'Organisation', 'Organisation', '');
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
VALUES
       (5414, 5410, 0, 1, 1),   -- Org -- (1:1) --> ODS Code
       (5414, 5411, 1, 1, 1),   -- Org -- (1:1) --> Name
       (5414, 5412, 2, 1, 1),   -- Org -- (1:1) --> Active flag
       (5414, 5413, 3, 1, 1);   -- Org -- (1:1) --> Type
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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
VALUES
       (5420, 5415, 0, 1, 1),   -- Location -- (1:1) --> Name
       (5420, 5416, 1, 1, 1),   -- Location -- (1:1) --> Type
       (5420, 5417, 2, 1, 1),   -- Location -- (1:1) --> Start date
       (5420, 5418, 3, 0, 1),   -- Location -- (0:1) --> End date
       (5420, 5419, 4, 1, 1);   -- Location -- (1:1) --> Active flag
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5420, 102, 5408, 0, 1, 1),  -- Loc -- Has a (1:1) --> Address
       (5420, 107, 5420, 1, 0, 1),  -- Loc -- Has parent (0:1) --> Location
       (5420, 102, 5423, 2, 0, 0),  -- Loc -- Has (0:*) --> Location contact
       (5420, 102, 5500, 3, 0, 0);  -- Loc -- Has (0:*) --> Appointment schedule

-- Location contact
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5421, 7,  'Location.Contact.Type', 'Contact type', ''),
       (5422, 12, 'Location.Contact.Details', 'Contact details', ''),
       (5423, 4,  'Location.Contact', 'Location contact', '');
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5434, 102, 5437, 0, 0, 0),  -- Practitioner -- Has (0:*) --> Practitioner contact
       (5434, 102, 5440, 1, 0, 0);  -- Practitioner -- Has (0:*) --> Practitioner identifier

-- Practitioner contact
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5435, 7,  'Practitioner.Contact.Type', 'Contact type', ''),
       (5436, 12, 'Practitioner.Contact.Details', 'Contact details', ''),
       (5437, 4,  'Practitioner.Contact', 'Practitioner contact', '');
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
VALUES
       (5437, 5435, 0, 1, 1),   -- Practitioner contact -- (1:1) --> Type
       (5437, 5436, 1, 1, 1);   -- Practitioner contact -- (1:1) --> Details


-- Practitioner identifier
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5438, 7,  'Practitioner.Id.Type', 'ID Type' ,''),
       (5439, 12, 'Practitioner.Id.Value', 'ID Value', ''),
       (5440, 4,  'Practitioner.Id', 'Practitioner ID', '');
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
VALUES
       (5458, 5445, 0,  1, 1),  -- Patient -- (1:1) --> NHS Number
       (5458, 5446, 1,  1, 1),  -- Patient -- (1:1) --> NHS Number status
       (5458, 5447, 2,  0, 1),  -- Patient -- (0:1) --> Birth date
       (5458, 5448, 3,  0, 1),  -- Patient -- (0:1) --> Death date
       (5458, 5449, 4,  0, 1),  -- Patient -- (0:1) --> Gender
       (5458, 5450, 4,  0, 1),  -- Patient -- (0:1) --> Title
       (5458, 5451, 5,  0, 1),  -- Patient -- (0:1) --> First name
       (5458, 5452, 6,  0, 1),  -- Patient -- (0:1) --> Middle name(s)
       (5458, 5453, 7,  1, 1),  -- Patient -- (1:1) --> Last name
       (5458, 5454, 8,  0, 0),  -- Patient -- (0:*) --> Previous last name(s)
       (5458, 5455, 9,  1, 1),  -- Patient -- (1:1) --> Is spine sensitive
       (5458, 5456, 10, 1, 1),  -- Patient -- (1:1) --> Date added
       (5458, 5457, 11, 1, 1);  -- Patient -- (1:1) --> Date entered
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
       (5458, 102, 5538, 9,  1, 0), -- Patient -- Has (1:*) --> Registration status
       (5458, 102, 5580, 10, 0, 0), -- Patient -- Has (0:*) --> Hospital encounter
       -- (5458, 102, 5598, 11, 0, 0), -- Patient -- Has (0:*) --> A&E Attendance  TODO: Inferred via hospital encounter?
       (5458, 102, 5613, 12, 0, 0), -- Patient -- Has (0:*) --> Outpatient attendance
       -- (5458, 102, 5625, 13, 0, 0), -- Patient -- Has (0:*) --> Hospital admission TODO: Inferred from episode -> encounter?
       -- (5458, 102, 5641, 14, 0, 0), -- Patient -- Has (0:*) --> Ward transfer TODO: Implied by encounter ?
       -- (5458, 102, 5655, 15, 0, 0), -- Patient -- Has (0:*) --> Discharge   TODO: Inferred from encounter?
       (5458, 102, 5655, 16, 0, 0), -- Patient -- Has (0:*) --> Observation
       (5458, 102, 5686, 17, 0, 0), -- Patient -- Has (0:*) --> Flag
       -- (5458, 102, 5694, 18, 0, 0), -- Patient -- Has (0:*) --> Problem TODO: Inferred from observation?
       (5458, 102, 5711, 19, 0, 0), -- Patient -- Has (0:*) --> Procedure request
       (5458, 102, 5726, 20, 0, 0), -- Patient -- Has (0:*) --> Procedure TODO: If this is only ever from request then can be inferred by request?
       (5458, 102, 5766, 21, 0, 0), -- Patient -- Has (0:*) --> Immunisation
       (5458, 102, 5782, 22, 0, 0), -- Patient -- Has (0:*) --> Allergy
       (5458, 102, 5800, 23, 0, 0), -- Patient -- Has (0:*) --> Referral
       (5458, 102, 5830, 24, 0, 0), -- Patient -- Has (0:*) --> Medication
       -- (5458, 102, 5849, 25, 0, 0), -- Patient -- Has (0:*) --> Medication order TODO: inferred from medication statement?
       (5458, 102, 5860, 26, 0, 0), -- Patient -- Has (0:*) --> Related person
       (5458, 102, 5883, 27, 0, 0); -- Patient -- Has (0:*) --> Care plan

-- Patient address
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5460, 7,  'Patient.Address.Type', 'Type', ''),
       (5461, 11, 'Patient.Address.StartDate', 'Start date', ''),
       (5462, 11, 'Patient.Address.EndDate', 'End date', ''),
       (5463, 4,  'Patient.Address', 'Patient address', '');
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
VALUES
       (5463, 5460, 0, 1, 1),    -- Patient address -- (1:1) --> Address type
       (5463, 5461, 1, 1, 1),    -- Patient address -- (1:1) --> Start date
       (5463, 5462, 2, 0, 1);    -- Patient address -- (0:1) --> End date
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5463, 102, 5408, 0, 0, 1);  -- Patient address -- Has (0:1) --> Address

-- Patient contact
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5465, 7,  'Patient.Contact.Type', 'Type', 'Type of contact (home phone, mobile, email)'),
       (5466, 12, 'Patient.Contact.Value', 'Value', 'Actual number, email address, etc.'),
       (5467, 4,  'Patient.Contact', 'Patient contact', '');
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
VALUES
       (5467, 5465, 0, 1, 1),    -- Patient contact -- (1:1) --> Type
       (5467, 5466, 1, 1, 1);    -- Patient contact -- (1:1) --> Value

-- Patient identifier
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5470, 7,  'Patient.Id.Type', 'Type', 'Hospital number, patient number, MRN, etc'),
       (5471, 12, 'Patient.Id.Value', 'Value', 'The actual identifier value'),
       (5472, 4,  'Patient.Id', 'Patient Id', 'Patient identifier (other than NHS number)');
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
VALUES
       (5481, 5475, 0, 0, 1),   -- Attribute (0:1) --> name/field/label concept
       (5481, 5476, 1, 0, 1),   -- Attribute (0:1) --> Numeric value
       (5481, 5477, 2, 0, 1),   -- Attribute (0:1) --> Date value
       (5481, 5478, 3, 0, 1),   -- Attribute (0:1) --> Text value
       (5481, 5479, 4, 0, 1),   -- Attribute (0:1) --> Concept value
       (5481, 5480, 5, 1, 1);   -- Attribute (1:1) --> Consent
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5418, 101, 4, 0, 1, 1);  -- Attribute -- Related to (1:1) --> Record type

-- TODO: Additional relationship?!?!?

-- Data entry prompt
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5485, 12, 'Prompt.Text', 'Text', ''),
       (5486, 4,  'Prompt', 'Prompt', '');
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
VALUES
       (5500, 5495, 0, 0, 1),   -- Appointment schedule (0:1) --> Description
       (5500, 5496, 1, 0, 1),   -- Appointment schedule (0:1) --> Type
       (5500, 5497, 2, 0, 1),   -- Appointment schedule (0:1) --> Speciality
       (5500, 5498, 3, 0, 1),   -- Appointment schedule (0:1) --> Start
       (5500, 5499, 4, 0, 1);   -- Appointment schedule (0:1) --> End
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5500, 102, 5434, 0, 0, 0),  -- Appointment schedule -- Has (0:*) --> Practitioner     TODO: "Main" flag?
       (5500, 102, 5510, 1, 0, 0);  -- Appointment schedule -- Has (0:*) --> Appointment slot
-- Appointment slot
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5505, 11, 'AppointmentSlot.Start', 'Start', ''),
       (5506, 11, 'AppointmentSlot.End', 'End', ''),
       (5507, 8,  'AppointmentSlot.Duration', 'Planned duration', ''),
       (5508, 7,  'AppointmentSlot.Type', 'Type', ''),
       (5509, 7,  'AppointmentSlot.Interaction', 'Interaction', ''),
       (5510, 4,  'AppointmentSlot', 'Appointment slot', '');
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
VALUES
       (5510, 5505, 0, 0, 1),   -- Appointment slot (0:1) --> Start
       (5510, 5506, 1, 0, 1),   -- Appointment slot (0:1) --> End
       (5510, 5507, 2, 0, 1),   -- Appointment slot (0:1) --> Duration
       (5510, 5508, 3, 0, 1),   -- Appointment slot (0:1) --> Type
       (5510, 5509, 4, 0, 1);   -- Appointment slot (0:1) --> Interaction
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5510, 102, 5518, 0, 0, 0),  -- Appointment slot -- Has (0:*) --> Booking
       (5510, 102, 5523, 1, 0, 1),  -- Appointment slot -- Has (0:1) --> Attendance
       (5510, 102, 5527, 2, 0, 0),  -- Appointment slot -- Has (0:*) --> Attendance event TODO: Should this be on attendance not slot?
       (5510, 102, 5613, 3, 0, 1);  -- Appointment slot -- Has (0:1) --> Outpatient

-- Appointment booking
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5515, 11, 'Booking.Time', 'Booking tme', ''),
       (5516, 7,  'Booking.State', 'State', 'The state of the slot (booked, reserved, free, etc.)'),
       (5517, 12, 'Booking.Reason', 'Reason', 'Patients reason for booking the appointment'),
       (5518, 4,  'Booking', 'Booking', '');
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5539, 111, 5434, 1, 0, 0);  -- Registration status -- Has a (1:*) --> Practitioner (qualifier - Effective/Entered)


-- Care episode
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5540, 11, 'CareEpisode.EffectiveDate', 'Effective date', ''),
       (5541, 8,  'CareEpisode.EffectiveDatePrecision', 'Effective date precision', ''),
       (5542, 11, 'CareEpisode.InsertDate', 'Insert date', ''),
       (5543, 11, 'CareEpisode.EnteredDate', 'Entered date', ''),
       (5544, 11, 'CareEpisode.EndDate', 'End date', ''),
       (5545, 4,  'CareEpisode', 'Care episode', '');
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
VALUES
       (5545, 5540, 0, 1, 1),   -- Episode (1:1) --> Effective date
       (5545, 5541, 1, 1, 1),   -- Episode (1:1) --> Effective date precision
       (5545, 5542, 2, 1, 1),   -- Episode (1:1) --> Insert date
       (5545, 5543, 3, 1, 1),   -- Episode (1:1) --> Entered date
       (5545, 5544, 4, 0, 1);   -- Episode (0:1) --> End date
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5545, 102, 5434, 0, 0, 0),  -- Care episode -- Has a (1:*) --> Practitioner (qualifier - Effective/Entered)
       (5545, 102, 5553, 1, 0, 0),  -- Care episode -- Has a (0:*) --> Care episode status
       (5545, 102, 5580, 2, 0, 0);  -- Care episode -- Has (0:*) --> Hospital encounter
       -- (5545, 102, 5625, 3, 0, 0),  -- Care episode -- Has (0:*) --> Hospital admission TODO: Inferred from encounter?
       -- (5545, 102, 5641, 4, 0, 0),  -- Care episode -- Has (0:*) --> Ward transfer TODO: Implied by encounter?
       -- (5545, 102, 5655, 5, 0, 0);  -- Care episode -- Has (0:*) --> Discharge   TODO: Inferred from encounter?

-- Care episode status
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5550, 11, 'CareEpisode.Status.Start', 'Start time', ''),
       (5551, 11, 'CareEpisode.Status.End', 'End time', ''),
       (5552, 7,  'CareEpisode.Status.Status', 'Status', ''),
       (5553, 4,  'CareEpisode.Status', 'Care episode status', '');
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5565, 102, 5434, 1, 0, 0),  -- GP consultation -- Has a (1:*) --> Practitioner (qualifier - Effective/Entered)
       (5565, 102, 5414, 2, 0, 1),  -- GP consultation -- Has a (0:1) --> Organisation (qualifier - Owning)
       (5565, 102, 5420, 3, 0, 1),  -- GP consultation -- Has a (0:1) --> Location
       (5565, 102, 5510, 4, 0, 1),  -- GP consultation -- Has a (0:1) --> Appointment slot
       (5565, 102, 5800, 5, 0, 1);  -- GP consultation -- Has a (0:1) --> Referral

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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5580, 102, 5414, 0, 0, 1),  -- Hospital encounter -- Has (0:1) --> Organisation (qualifier = owning)
       (5580, 102, 5420, 1, 0, 1),  -- Hospital encounter -- Has (0:1) --> Location
       (5580, 102, 5800, 2, 0, 1),  -- Hospital encounter -- Has (0:1) --> Referral request     TODO: Is this the other way around?
       (5580, 102, 5434, 3, 0, 0),  -- Hospital encounter -- Has (0:*) --> Practitioner
       (5580, 102, 5598, 4, 0, 0),  -- Hospital encounter -- Has (0:*) --> A&E Attendance
       (5580, 102, 5613, 5, 0, 0),  -- Hospital encounter -- Has (0:*) --> Outpatient attendance
       (5580, 102, 5625, 6, 0, 0),  -- Hospital Encounter -- Has (0:*) --> Hospital admission
       (5580, 102, 5641, 7, 0, 0),  -- Hospital Encounter -- Has (0:*) --> Ward transfer
       (5580, 102, 5655, 8, 0, 0);  -- Hospital Encounter -- Has (0:*) --> Discharge

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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5598, 102, 5434, 0, 0, 0),  -- A&E Attendance -- Has (0:*) --> Practitioner (qual = Effective/Triage/Entered)
       -- (5598, 102, 5414, 1, 0, 1),  -- A&E Attendance -- Has (0:1) --> Organisation (qual = owning) TODO: Inferred from loc?
       (5598, 102, 5420, 2, 0, 1);  -- A&E Attendance -- Has (0:1) --> Location

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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5613, 102, 5434, 0, 0, 0),  -- Outpatient -- Has (0:*) --> Practitioner (qualifier = effective/entered/usual)
       -- (5613, 102, 5414, 1, 0, 1),  -- Outpatient -- Has (0:1) --> Organisation (qualifier = owning) TODO: Inferred by location?
       (5613, 102, 5420, 2, 0, 1);  -- Outpatient -- Has (0:1) --> Location

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
       (5623, 7,  'Admission.Purpose', 'Purpose', ''),
       (5624, 13, 'Admission.IsConsent', 'Is consent', ''),
       (5625, 4,  'Admission', 'Hospital admission', '');
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
VALUES
       (5625, 5615, 0, 1, 1),   -- Admission (1:1) --> Effective date
       (5625, 5616, 1, 1, 1),   -- Admission (1:1) --> Effective date precision
       (5625, 5617, 2, 0, 1),   -- Admission (0:1) --> End date
       (5625, 5618, 3, 1, 1),   -- Admission (1:1) --> Insert date
       (5625, 5619, 4, 1, 1),   -- Admission (1:1) --> Entered date
       (5625, 5620, 5, 1, 1),   -- Admission (1:1) --> Status
       (5625, 5621, 6, 1, 1),   -- Admission (1:1) --> Confidential
       (5625, 5622, 7, 0, 1),   -- Admission (0:1) --> Reason
       (5625, 5623, 8, 0, 1),   -- Admission (0:1) --> Description
       (5625, 5624, 9, 1, 1);   -- Admission (1:1) --> Consent
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5625, 102, 5434, 0, 0, 0),  -- Admission -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       -- (5625, 102, 5414, 1, 0, 1),  -- Admission -- Has (0:1) --> Organisation (qualifier = owning) TODO: Inferred by location?
       (5625, 102, 5420, 2, 0, 1);  -- Admission -- Has (0:1) --> Location

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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5641, 102, 5434, 0, 0, 0),  -- Ward transfer -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       -- (5641, 102, 5414, 1, 0, 1),  -- Ward transfer -- Has (0:1) --> Organisation (qualifier = owning) TODO: Inferred by location?
       (5641, 102, 5420, 2, 0, 1);  -- Ward transfer -- Has (0:1) --> Location

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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5655, 102, 5434, 0, 0, 0),  -- Discharge -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       -- (5655, 102, 5414, 1, 0, 1),  -- Discharge -- Has (0:1) --> Organisation (qualifier = owning) TODO: Inferred by location?
       (5655, 102, 5420, 2, 0, 1);  -- Discharge -- Has (0:1) --> Location

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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
VALUES
       (5674, 5660, 0,  1, 1),  -- Observation (1:1) --> Concept
       (5674, 5661, 1,  1, 1),  -- Observation (1:1) --> Effective date
       (5674, 5662, 2,  1, 1),  -- Observation (1:1) --> Effective date precision
       (5674, 5663, 3,  1, 1),  -- Observation (1:1) --> Insert date
       (5674, 5664, 4,  1, 1),  -- Observation (1:1) --> Entered date
       (5674, 5665, 5,  1, 1),  -- Observation (1:1) --> Care activity heading
       (5674, 5666, 6,  1, 1),  -- Observation (1:1) --> Status
       (5674, 5667, 7,  1, 1),  -- Observation (1:1) --> Confidential
       (5674, 5668, 8,  0, 1),  -- Observation (0:1) --> Original code
       (5674, 5669, 9,  0, 1),  -- Observation (0:1) --> Original concept
       (5674, 5670, 10, 0, 1),  -- Observation (0:1) --> Episodicity
       (5674, 5671, 11, 0, 1),  -- Observation (0:1) --> Comments
       (5674, 5672, 12, 0, 1),  -- Observation (0:1) --> Significance
       (5674, 5673, 13, 1, 1);  -- Observation (1:1) --> Consent
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5674, 102, 5434, 0, 0, 0),  -- Observation -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5674, 102, 5414, 1, 0, 1),  -- Observation -- Has (0:1) --> Organisation (qualifier = owning)
       (5674, 102, 5486, 2, 0, 1);  -- Observation -- Has (0:1) --> Prompt

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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5686, 102, 5434, 0, 0, 0),  -- Flag -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5686, 102, 5414, 1, 0, 1);  -- Flag -- Has (0:1) --> Organisation (qualifier = owning)

-- Problem
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5690, 7,  'Problem.Type', 'Type', 'Problem type concept (problem, issue, health admin, etc)'),
       (5691, 7,  'Problem.Significance', 'Significance', 'Problem significance (minor, major, etc)'),  -- TODO: How does this differ from OBS:Significance?
       (5692, 8,  'Problem.Duration', 'Expected duration', 'Expected duration of the problem in days'),
       (5693, 11, 'Problem.LastReviewDate', 'Last review date', ''),
       (5694, 4,  'Problem', 'Problem', '');
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
VALUES
       (5694, 5690, 0, 0, 1),   -- Problem (0:1) --> Type
       (5694, 5691, 1, 0, 1),   -- Problem (0:1) --> Significance
       (5694, 5692, 2, 0, 1),   -- Problem (0:1) --> Duration
       (5694, 5693, 3, 0, 1);   -- Problem (0:1) --> Last review date
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5694, 102, 5434, 0, 0, 0),  -- Problem -- Has (0:*) --> Practitioner (qualifier = last review)
       (5694, 102, 5674, 1, 1, 1);  -- Problem -- Has (1:1) --> Observation (qualifier = owning)    TODO: Should this be reversed?

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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5711, 102, 5434, 0, 0, 0),  -- Procedure request -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5711, 102, 5414, 1, 0, 1);  -- Procedure request -- Has (0:1) --> Organisation (qualifier = owning/recipient)

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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5726, 102, 5434, 0, 0, 0),  -- Procedure -- Has (0:*) --> Practitioner (qualifier = effective/entered/usual)
       (5726, 102, 5414, 1, 0, 1),  -- Procedure -- Has (0:1) --> Organisation (qualifier = owning)
       (5726, 102, 5486, 2, 0, 1),  -- Procedure -- Has (0:1) --> Prompt
       (5726, 102, 5737, 3, 0, 0);  -- Procedure -- Has (0:*) --> Device

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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
VALUES
       (5737, 5730, 0, 1, 1),   -- Device (1:1) --> Type
       (5737, 5731, 1, 0, 1),   -- Device (0:1) --> Serial
       (5737, 5732, 2, 0, 1),   -- Device (0:1) --> Name
       (5737, 5733, 3, 0, 1),   -- Device (0:1) --> Manufacturer
       (5737, 5734, 4, 0, 1),   -- Device (0:1) --> Human ID
       (5737, 5735, 5, 0, 1),   -- Device (0:1) --> Machine ID
       (5737, 5736, 6, 0, 1);   -- Device (0:1) --> Version
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5737, 102, 5414, 0, 0, 1);  -- Device -- Has (0:1) --> Organisation TODO: Probably should be other way around?

-- Observation value
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5740, 7,  'Observation.Value.Operator', 'Operator', 'Operator concept (=, <=, !=, etc)'),
       (5741, 8,  'Observation.Value.Numeric', 'Numeric value', ''),
       (5742, 12, 'Observation.Value.Units', 'Units', ''),
       (5743, 11, 'Observation.Value.Date', 'Date value', ''),
       (5744, 12, 'Observation.Value.Text', 'Text value', ''),
       (5745, 7,  'Observation.Value.Concept', 'Concept value', ''),
       (5746, 5674,  'Observation.Value', 'Observation value', '');     -- TODO: Extends observation
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
VALUES
       (5746, 5740, 0, 1, 1),   -- Observation value (1:1) --> Operator
       (5746, 5741, 1, 0, 1),   -- Observation value (0:1) --> Numeric
       (5746, 5742, 2, 0, 1),   -- Observation value (0:1) --> Units    -- TODO: Should this att be on new "Measure" (subclass of Numeric) instead of Obs?
       (5746, 5743, 3, 0, 1),   -- Observation value (0:1) --> Date
       (5746, 5744, 4, 0, 1),   -- Observation value (0:1) --> Text
       (5746, 5745, 5, 0, 1);   -- Observation value (0:1) --> Concept
       -- (5746, rrng, 6, 0, 1);   -- Observation value (0:1) --> Reference range  TODO: There isn't one in the IM?!?!?

-- Immunisation
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5750, 7,  'Immunisation.Concept', 'Concept', ''),
       (5751, 11, 'Immunisation.EffectiveDate', 'Effective date', ''),
       (5752, 8,  'Immunisation.EffectiveDatePrecision', 'Effective date precision', ''),
       (5753, 11, 'Immunisation.InsertDate', 'Insert date', ''),
       (5753, 11, 'Immunisation.EnteredDate', 'Entered date', ''),
       (5754, 7,  'Immunisation.CareActivityHeading', 'Care activity heading', ''),
       (5755, 7,  'Immunisation.Status', 'Status', ''),
       (5756, 13, 'Immunisation.IsConfidential', 'Is confidential', ''),
       (5757, 12, 'Immunisation.Dose', 'Dose', ''),
       (5758, 7,  'Immunisation.BodyLocation', 'Body location', ''),
       (5759, 7,  'Immunisation.Method', 'Method', ''),
       (5760, 12, 'Immunisation.BatchNo', 'Batch number', ''),
       (5761, 11, 'Immunisation.ExpiryDate', 'Expiry date', ''),
       (5762, 12, 'Immunisation.Manufacturer', 'Manufacturer', ''),
       (5763, 8,  'Immunisation.DoseNumber', 'Dose number', ''),
       (5764, 8,  'Immunisation.DosesRequired', 'Doses required', ''),
       (5765, 13, 'Immunisation.IsConsent', 'Is consent', ''),
       (5766, 4,  'Immunisation', 'Immunisation', '');
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
VALUES
       (5766, 5750, 0,  1, 1),  -- Immunisation (1:1) --> Concept
       (5766, 5751, 1,  1, 1),  -- Immunisation (1:1) --> Effective date
       (5766, 5752, 2,  1, 1),  -- Immunisation (1:1) --> Effective date precision
       (5766, 5753, 3,  1, 1),  -- Immunisation (1:1) --> Insert date
       (5766, 5754, 4,  1, 1),  -- Immunisation (1:1) --> Entered date
       (5766, 5755, 5,  1, 1),  -- Immunisation (1:1) --> Care activity heading
       (5766, 5756, 6,  1, 1),  -- Immunisation (1:1) --> Status
       (5766, 5757, 7,  0, 1),  -- Immunisation (0:1) --> Dose
       (5766, 5758, 8,  0, 1),  -- Immunisation (0:1) --> Body location
       (5766, 5759, 9,  0, 1),  -- Immunisation (0:1) --> Method
       (5766, 5760, 10, 0, 1),  -- Immunisation (0:1) --> Batch
       (5766, 5761, 11, 0, 1),  -- Immunisation (0:1) --> Expiry
       (5766, 5762, 12, 0, 1),  -- Immunisation (0:1) --> Manufacturer
       (5766, 5763, 13, 0, 1),  -- Immunisation (0:1) --> Dose number
       (5766, 5764, 14, 0, 1),  -- Immunisation (0:1) --> Dose count
       (5766, 5765, 15, 1, 1);  -- Immunisation (1:1) --> Consent
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5766, 102, 5434, 0, 0, 0),  -- Immunisation -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5766, 102, 5414, 1, 0, 1);  -- Immunisation -- Has (0:1) --> Organisation (qualifier = owning)

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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5782, 102, 5434, 0, 0, 0),  -- Allergy -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5782, 102, 5414, 1, 0, 1);  -- Allergy -- Has (0:1) --> Organisation (qualifier = owning)

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
       (5972, 13, 'Referral.IsConfidential', 'Is confidential', ''),
       (5793, 12, 'Referral.UBRN', 'UBRN', ''),
       (5794, 7,  'Referral.Priority', 'Priority', ''),
       (5795, 7,  'Referral.Mode', 'Mode', ''),
       (5796, 7,  'Referral.Source', 'Source', ''),
       (5797, 7,  'Referral.Service', 'Service requested', ''),
       (5798, 12, 'Referral.Reason', 'Reason', ''),
       (5799, 13, 'Referral.IsConsent', 'Is consent', ''),
       (5800, 4,  'Referral', 'Referral', '');
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5800, 102, 5434, 0, 0, 0),  -- Referral -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5800, 102, 5414, 1, 0, 0),  -- Referral -- Has (0:*) --> Organisation (qualifier = owning/sender/recipient)
       (5800, 102, 5613, 2, 0, 1);  -- Referral -- Has (0:1) --> Outpatient

-- Medication amount
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5805, 8,  'MedicationAmount.Dose', 'Dose', ''),
       (5806, 10, 'MedicationAmount.Quantity', 'Quantity', ''),
       (5807, 12, 'MedicationAmount.Units', 'Units', ''),
       (5808, 4,  'MedicationAmount', 'Medication amount', '');
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5830, 102, 5434, 0, 0, 0),  -- Medication statement -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5830, 102, 5414, 1, 0, 1),  -- Medication statement -- Has (0:1) --> Organisation (qualifier = owning)
       (5830, 102, 5808, 2, 0, 1),  -- Medication statement -- Has (0:1) --> Medication amount
       (5830, 102, 5849, 3, 0, 0);  -- Medication statement -- Has (0:*) --> Medication order

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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5849, 102, 5434, 0, 0, 0),  -- Medication order -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5849, 102, 5414, 1, 0, 1);  -- Medication order -- Has (0:1) --> Organisation (qualifier = owning)
       -- (5849, 102, 5808, 2, 0, 1);  -- Medication order -- Has (0:1) --> Medication amount TODO: inferred from statement?

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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5860, 102, 5463, 0, 0, 0),  -- Related person -- Has (0:1) --> Address
       (5860, 102, 5867, 1, 0, 0);  -- Related person -- Has (0:*) --> Contact (method)

-- Related person contact
INSERT INTO concept (id, superclass, context, full_name, description)
VALUES
       (5865, 7,  'RelatedPerson.Contact.Type', 'Contact type', ''),
       (5866, 12, 'RelatedPerson.Contact.Details', 'Contact details', ''),
       (5867, 4,  'RelatedPerson.Contact', 'Related person contact', '');
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5883, 102, 5434, 0, 0, 0),  -- Care plan -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5883, 102, 5414, 1, 0, 1),  -- Care plan -- Has (0:1) --> Organisation (qualifier = owning)
       (5883, 102, 5897, 2, 0, 0);  -- Care plan -- Has (0:*) --> Care plan activity

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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5897, 102, 5434, 0, 0, 0),  -- Care plan activity -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5897, 102, 5414, 1, 0, 1),  -- Care plan activity -- Has (0:1) --> Organisation (qualifier = owning)
       (5897, 102, 5914, 2, 0, 0);  -- Care plan activity -- Has (0:*) --> Care plan activity target

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
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
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
INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`)
VALUES
       (5914, 102, 5434, 0, 0, 0),  -- Care plan activity target -- Has (0:*) --> Practitioner (qualifier = effective/entered)
       (5914, 102, 5414, 1, 0, 1);  -- Care plan activity target -- Has (0:1) --> Organisation (qualifier = owning)

UPDATE concept
SET status = 1;

/*
INSERT INTO concept_attribute (concept, attribute, `order`, minimum, maximum)
VALUES
       (1029, 5009, 1, 0, 1), -- Name -> Title (0:1)
       (1029, 5010, 2, 1, 1), -- Name -> First name (1:1)
       (1029, 5011, 3, 0, 4), -- Name -> Middle names (0:4)
       (1029, 5012, 4, 1, 1), -- Name -> Last name (1:1)

       (1030, 5023, 1, 1, 1), -- Address -> Type (1:1)
       (1030, 5024, 1, 1, 1), -- Address -> Line 1 (1:1)
       (1030, 5025, 1, 0, 1), -- Address -> Line 2 (0:1)
       (1030, 5026, 1, 0, 1), -- Address -> Locality (0:1)
       (1030, 5027, 1, 0, 1), -- Address -> City (0:1)
       (1030, 5028, 1, 0, 1), -- Address -> Line 5 (0:1)
       (1030, 5029, 1, 1, 1), -- Address -> Post Code (1:1)

       (1001, 1029, 1, 0, 1), -- Demographics -> Person name (1:1)
       (1001, 1030, 2, 0, 4), -- Demographics -> Address (0:4)
       (1001, 5007, 3, 1, 1), -- Demographics -> NHS Number (1:1)
       (1001, 5013, 4, 0, 1), -- Demographics -> Gender (0:1)
       (1001, 5014, 5, 0, 1); -- Demographics -> Birth date (0:1)*/

DELETE
FROM table_id;
INSERT INTO table_id (name, id)
SELECT 'BaseConcept', MAX(id) + 1
FROM concept
WHERE id < 100;
INSERT INTO table_id (name, id)
SELECT 'Relationship', MAX(id) + 1
FROM concept
WHERE id < 500;
INSERT INTO table_id (name, id)
SELECT 'Folder', MAX(id) + 1
FROM concept
WHERE id < 1000;
INSERT INTO table_id (name, id)
SELECT 'RecordType', MAX(id) + 1
FROM concept
WHERE id < 1000000;
INSERT INTO table_id (name, id)
SELECT 'Concept', MAX(id) + 1
FROM concept;

INSERT INTO code_scheme (id, identifier)
VALUES (5031, 'SNOMED-CT');

INSERT INTO task_type (id, name)
VALUES (0, 'Attribute model'),
       (1, 'Value model'),
       (2, 'Message mappings'),
       (3, 'Term mappings');