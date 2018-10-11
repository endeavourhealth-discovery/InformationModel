USE im2;

-- TODO: Need to review as many of these no longer relevant in new Information Model db schema. Commented out (until used) for clarity
INSERT INTO concept
  (id,  superclass, context, full_name, description)
VALUES
-- ************************************** CORE IM DATA **************************************
-- BASE (PRIMITIVE) TYPES (super = 1)
  ( 1, 1, 'Concept',                    'Concept',          'Abstract base concept to which all concept types belong'),
  ( 2, 1, 'Concept.Codeable concept',   'Codeable concept', 'Any concept that can be identified as part of a taxonomy or classification'),
  ( 3, 1, 'Concept.Folder',             'Folder',           'A concept that contains other concepts as a place holder in a view'),
  ( 4, 1, 'Concept.Record Type',        'Record',           'A structure that contains attributes'),
  ( 5, 1, 'Concept.Relationship',       'Relationship',     'A concept only used in the relationship links between one concept and another, '),
  ( 6, 1, 'Concept.Attribute',          'Attribute',        'An attribute of a record type structure that holds a value'),

-- BASE ATTRIBUTES (super = 6)
  ( 7, 6, 'Attribute.Codeable concept', 'Codeable concept attribute', 'An attribute whose value is a code concept'),
  ( 8, 6, 'Attribute.Number',           'Number attribute',           'An attribute that holds a number (whole or decimal)'),
  ( 9, 6, 'Attribute.Whole number',     'Whole number attribute',     'An attribute that holds a whole number'),
  (10, 6, 'Attribute.Decimal number',   'Decimal number attribute',   'An attribute that holds a decimal number'),
  (11, 6, 'Attribute.Date time',        'Date time attribute',        'An attribute that holds a date and time'),
  (12, 6, 'Attribute.Text',             'Text attribute',             'An attribute that holds a free text value'),
  (13, 6, 'Attribute.Boolean',          'Boolean attribute',          'An attribute that contains a boolean value (Yes/No, True/False, Active/Inactive, etc.)'),

-- RELATIONSHIPS (super = 5)
  (100, 5, 'Relationship.is a',          'is a',             'source concept inherits the semantic meaning of the more generalised target - source is more specialised'),
  (101, 5, 'Relationship.Related to',    'is related to',    'The source is related to the target in an unsepecified way'),
  (102, 5, 'Relationship.has a',         'has a',            'Source has an attribute type of the target'),
  (103, 5, 'Relationship.has qualifier', 'has qualifier',    'The source has a qualifier in relation to the concept it is related to'),
  (104, 5, 'Relationship.extends',       'extends',          'The source extends (inherits attributes of) the target'),

-- FOLDERS (super = 3)
  (500, 3, 'Folder.Information model',             'Information model',                                'The Discovery information model is a knowledge base that describes all of the kn'),
  (502, 3, 'Folder.Attributes and Relationships',  'Attributes and Relationships',                     'Groups the relationship types when navigating the information model'),
  (504, 3, 'Folder.Care administration entries',   'Care administration entries',                      'Folder containing record types that hold information about care administration i'),
  (505, 3, 'Folder.Clinical record entries',       'Clinical record entries',                          'Folder containing Record types that store patient clinical or personal character'),
  (506, 3, 'Folder.Care process entries',          'Care process entries',                             'Structures describing care process events in relation to the patient&#44; such a'),
  (507, 3, 'Folder.Other entities',                'Health workers organisations and other entities',  'Structures that describe staff professionals organisations departments and servi'),
  (510, 3, 'Folder.Record structures',             'Record structures',                                'The default view for viewing the information model'),
  (512, 3, 'Folder.Specialised record types',      'Specialised record types',                         'Record types used by other entries'),
  (513, 3, 'Folder.Support structures',            'Information model support structures',             'Structures such as classes and relationships that support the model'),
  (514, 3, 'Folder.Type list',                     'Type list',                                        'List of classes used in the model'),
  (515, 3, 'Folder.Relationships',                 'Relationships',                                    'List of relationship types in the core model'),
  (516, 3, 'Folder.Attribute types',               'Attribute types',                                  'A list of attribute types used in the core model'),

-- ************************************** IM MODEL DATA **************************************
  (5009, 12,    'Text attribute.Title',  'Title',  'Title or prefix to name'),
  (5010, 12,    'Text attribute.First name(s)',  'First name(s)',  'Forenames or first names or given names'),
  (5011, 12,    'Text attribute.Middle names',  'Middle names',  'After the first and before the last'),
  (5012, 12,    'Text attribute.Last name',  'Last name',  'Last name or surname or family name'),
  (1029, 4,     'RecordType.Name',  'Name',  'Information about the name'),

  (5019, 4,     'RecordType.Patient identifier',  'Patient identifier',  'An identifier for the person. For example a hospital number, CHI number, NI num'),

  (5023, 7,     'Codeable attribute.Address type',  'Address type',  'A location address'),
  (5024, 12,    'Text attribute.Address line 1',  'Address line 1',  'First line, normally house name or number'),
  (5025, 12,    'Text attribute.Address line 2',  'Address line 2',  'Second address line normally street'),
  (5026, 12,    'Text attribute.Locality',  'Locality',  'Third address line normally village or area'),
  (5027, 12,    'Text attribute.City',  'City',  'Fourth address line normally town'),
  (5028, 12,    'Text attribute.Address line 5',  'Address line 5',  'Fifth address line normally county'),
  (5029, 12,    'Text attribute.Post code',  'Post code',  'Post code of address'),
  (1030, 4,     'RecordType.Address',  'Address',  'Address details'),

  (5007, 12,    'Text attribute.NHS number',  'NHS number',  'The NHS number allocated to the patient.'),
  (5013, 7,     'Codeable attribute.Gender (administrative)',  'Gender (administrative)',  'The gender that the person considers themselves to be allocated to for the purpo'),
  (5014, 11,    'Date time attribute.Date of birth',  'Date of birth',  'Date of birth of the patient, as far as is known'),

  (1001, 4,     'RecordType.Patient master demographics',  'Patient master demographics',  'Patient demographic information relating to their birth&#44; administrative gend'),

  (5030, 1, 'Code Scheme', 'Coding scheme', 'A coding scheme'),
  (5031, 1, 'Code Scheme.SNOMED', 'SNOMED CT', 'The SNOMED CT coding scheme'),

  (5032, 1, 'DM+D.VTM', 'Virtual therapeutic moiety', ''),
  (5033, 1, 'DM+D.VPI', 'Virtual product ingredient', ''),
  (5034, 1, 'DM+D.CDPI', 'Controlled drug prescribing information', ''),
  (5035, 1, 'DM+D.DRI', 'Drug route information', ''),
  (5036, 1, 'DM+D.ODRI', 'Ontology drug form & route info',''),
  (5037, 1, 'DM+D.DFI', 'Dose form information', ''),
  (5038, 1, 'DM+D.VMP', 'Virtual medicinal product', ''),
  (5039, 1, 'DM+D.APE', 'Actual product excipient', ''),
  (5040, 1, 'DM+D.APrI', 'Appliance product information', ''),
  (5041, 1, 'DM+D.LR', 'Licensed route', ''),
  (5042, 1, 'DM+D.AMP', 'Actual medicinal product', ''),
  (5043, 1, 'DM+D.VCPC', 'Virtual combination pack content', ''),
  (5044, 1, 'DM+D.DTCI', 'Drug tariff category info', ''),
  (5045, 1, 'DM+D.VMPP', 'Virtual medicinal product pack', ''),
  (5046, 1, 'DM+D.PPI', 'Product prescribing info', ''),
  (5047, 1, 'DM+D.APkI', 'Appliance pack info', ''),
  (5048, 1, 'DM+D.RI', 'Reimbursement info', ''),
  (5049, 1, 'DM+D.MPP', 'Medicinal product price', ''),
  (5050, 1, 'DM+D.ACPC', 'Actual combination pack content', ''),
  (5051, 1, 'DM+D.AMPP', 'Actual medicinal product pack', ''),
  (105, 5, 'Relationship.IsBranded', 'is branded type of', ''),
  (106, 5, 'Relationship.PackOf', 'is pack of', ''),
  (107, 5, 'Relationship.ActiveIngredient', 'has active ingredient', '')
;

/*
  (1000, 4,  'RecordType.Health record event',  'Health record event',  'The basic items in any event based health record entry'),
  (1002, 4,  'RecordType.Practitioner in role',  'Practitioner in role',  'Information describing any person who provides care or is part of the health car'),
  (1003, 4,  'RecordType.Device',  'Device',  'Information about a medical device used in care and classified according to type'),
  (1004, 4,  'RecordType.Organisation service or department',  'Organisation service or department',  'Information about organisations&#44; services&#44; or departments '),
  (1005, 4,  'RecordType.Location',  'Location',  'Information about an actual location (which may have an address separate to the '),
  (1006, 4,  'RecordType.Care episode',  'Care episode',  'A care episode is an association between a patient and a healthcare provider dur'),
  (1007, 4,  'RecordType.Care episode administration',  'Care episode administration',  'Information about the administration of patient reception and registration in th'),
  (1008, 4,  'RecordType.Encounter',  'Encounter',  'An encounter is an interaction between a patient and healthcare provider for the'),
  (1010, 4,  'RecordType.Referral request',  'Referral request',  'A referral request includes request for advice or invitation to participate in c'),
  (1011, 4,  'RecordType.Procedure or test request',  'Procedure or test request',  'A procedure request is a record of a request for a procedure to be planned&#44; '),
  (1012, 4,  'RecordType.Appointment schedule',  'Appointment schedule',  'An appointment schedule is an appointment grouping implying a session or a clini'),
  (1013, 4,  'RecordType.Appointment booking history',  'Appointment booking history',  'Information about the process of booking and unbooking of a planned appointment '),
  (1014, 4,  'RecordType.Appointment slot',  'Appointment slot',  'This is information about a particular appointment or slot as planned. This is a'),
  (1015, 4,  'RecordType.Appointment attendance',  'Appointment attendance',  'Historical Information about an actual attendance for a patient for an appointme'),
  (1016, 4,  'RecordType.Care plan',  'Care plan',  'Simple plans (such as review dates) or a relatively simple data subset of a comp'),
  (1018, 4,  'RecordType.Observation',  'Observation',  'A Generic observation is the root for most clinical entries about a patient&#44;'),
  (1019, 4,  'RecordType.Numeric observation',  'Numeric observation',  'Any observation with a numeric value e.g. path result or vital signs. A numeric '),
  (1020, 4,  'RecordType.Procedure',  'Procedure',  'Procedure provides more information  beyond a simple observation about an operat'),
  (1021, 4,  'RecordType.Immunisation',  'Immunisation',  'Immunisation extends a simple observation by providing more information about th'),
  (1022, 4,  'RecordType.Allergy and adverse reaction',  'Allergy and adverse reaction',  'Allergies provide more information about the allergy such as the substance and n'),
  (1023, 4,  'RecordType.Problem',  'Problem',  'Problem is a patient and record management construct designed to help manage car'),
  (1024, 4,  'RecordType.Medication statement',  'Medication statement',  'Medication entries are templates for describing and authorising a course of medi'),
  (1025, 4,  'RecordType.Medication order or issue',  'Medication order or issue',  'A medication order is the actual prescription for a medication item. It represen'),
  (1026, 4,  'RecordType.Flag or Alert',  'Flag or Alert',  'A flag is a warning or notification of some sort presented to the user - who may'),
  (1027, 4,  'RecordType.Consent',  'Consent',  'Patient may consent or dissent for a variety of service provision or sharing of '),
  (1028, 4,  'RecordType.Patient organisational demographics',  'Patient organisational demographics',  'Details about the patient in the context of a particlar organisation'),
  (1031, 4,  'RecordType.Contact',  'Contact',  'Information about contact numbers and email addresses'),
  (1032, 4,  'RecordType.Related person',  'Related person',  'Information about related persons to a patient'),
  (1033, 4,  'RecordType.Post code linked data',  'Post code linked data',  'LSOA MSOA IMDS and data related to a post code'),
  (1034, 4,  'RecordType.Person in role',  'Person in role',  'Information about a person in a role'),
  (1035, 4,  'RecordType.Identifier',  'Identifier',  'An identifier including the scheme and value'),
  (1036, 4,  'RecordType.Quantity time',  'Quantity time',  'An attribute group specialising in  units of time'),
  (1037, 4,  'RecordType.Quantity medication',  'Quantity medication',  'An attribute group specialising in medication quantities with a value and unit'),
  (1038, 4,  'RecordType.Quantity measure',  'Quantity measure',  'Numeric quantity with units that are measurements eg. Weights ot lengths'),
  (1039, 4,  'RecordType.Range numeric',  'Range numeric',  'structure that has a range type operator and upper and lower value'),
  (5000, 11, 'Date time attribute.Date and time entry recorded',  'Date and time entry recorded',  'The data and time the entry was made. This may not be the same as the date and t'),
  (5001, 4,  'RecordType.Recorded by',  'Recorded by',  'The person or device who recorded the entry. This may or may not be the same as '),
  (5002, 4,  'RecordType.Responsible practitioner',  'Responsible practitioner',  'The person responsible for the entry, usually a professional health worker'),
  (5003, 11, 'Date time attribute.Effective date and time',  'Effective date and time',  'e.g. a year or month). It may be a point in time or a period of time (e.g. an en'),
  (5004, 4,  'RecordType.Patient or service user',  'Patient or service user',  'The patient/client/service user  to whom the entry refers'),
  (5005, 4,  'RecordType.Owning organisation',  'Owning organisation',  'The organisation or service within an organisation responsible for the entry of '),
  (5006, 12, 'Text attribute.Pseudonymised patient id',  'Pseudonymised patient id',  'Hash with Salt key of identifiers of the patient'),
  (5015, 11, 'Date time attribute.Pseudonymised date of birth',  'Pseudonymised date of birth',  'Date of birth by year or month depending on age of patient and level of de-idnti'),
  (5016, 8,  'Whole number attribute.Age',  'Age',  'Age of patient as calculated between date of birth and the date of interest'),
  (5017, 13, 'Boolean attribute.Death indicator',  'Death indicator',  'If a patient has died an indicator that they are now dead'),
  (5018, 11, 'Date time attribute.Date of death',  'Date of death',  'If dead and if available, the date of death'),
  (5020, 7,  'Codeable attribute.Identifier scheme',  'Identifier scheme',  'Nature of the persons identifier e.g. hospital number, CHI number'),
  (5021, 12, 'Text attribute.Identifier value',  'Identifier value',  'Value of the persons identifier'),
  (5022, 12, 'Text attribute.Pseudonymised address',  'Pseudonymised address',  'Hash with Salt key of household'),
  (5030, 12, 'Text attribute.UPRN',  'UPRN',  'Unique property reference number (household)'),
  (5031, 12, 'Text attribute.Lower super output area',  'Lower super output area',  'Geographical area linked to postcode more specific than MSOA'),
  (5032, 12, 'Text attribute.Middle super output area',  'Middle super output area',  'Geopgraphical area linked to postcode less specific than LSOA'),
  (5033, 4,  'RecordType.Contact information',  'Contact information',  'potentially used in contacting the individual, each contact qualified by contac'),
  (5034, 7,  'Codeable attribute.Contact type',  'Contact type',  'whether email telephone number etc'),
  (5035, 12, 'Text attribute.Contact value',  'Contact value',  'Actual telephone number or email'),
  (5036, 7,  'Codeable attribute.Ethnicity',  'Ethnicity',  'Derived from the latest ethnic group observation'),
  (5037, 7,  'Codeable attribute.Language',  'Language',  'Links to the Languages that the patient speaks qualified by preferred spoken etc'),
  (5038, 7,  'Codeable attribute.Confidentiality type',  'Confidentiality type',  'When a record is marked as confidential what is the type of confidentiality '),
  (5039, 4,  'RecordType.Related persons',  'Related persons',  'Information about people related to the patient (family carers etc)'),
  (5040, 12, 'Text attribute.Previous last name',  'Previous last name',  'last name the patient was known by (this is not the audit trail of previous name'),
  (5041, 12, 'Text attribute.Index of multiple deprivation',  'Index of multiple deprivation',  'Statistical index of multiple deprivation'),
  (5042, 12, 'Text attribute.Active status',  'Active status',  'Whether active or not'),
  (5043, 4,  'RecordType.Service or organisation',  'Service or organisation',  'Points to the organisation or service that this attribute represents'),
  (5044, 7,  'Codeable attribute.Role type',  'Role type',  'The type of role the user operates as (e.g. doctor nurse)'),
  (5045, 7,  'Codeable attribute.Speciality',  'Speciality',  'The speciality this attribute refers to'),
  (5046, 11, 'Date time attribute.Contract start date',  'Contract start date',  'Date the contract started'),
  (5047, 11, 'Date time attribute.Contract end date',  'Contract end date',  'Date the contract ended (if no longer active)'),
  (5048, 4,  'RecordType.Related person information',  'Related person information',  'Link to a related person details when they are not in the Discovery database'),
  (5049, 7,  'Codeable attribute.Related person relationship',  'Related person relationship',  'The type of relationship e.g. Mother, Father, Genetic mother etc'),
  (5050, 4,  'RecordType.Related patient',  'Related patient',  'Link to a related patient who is actually in the Database'),
  (5051, 12, 'Text attribute.Device name',  'Device name',  'The actual name of the device'),
  (5052, 12, 'Text attribute.Human readable UDI',  'Human readable UDI',  'The human readable bar code of the device'),
  (5053, 12, 'Text attribute.Machine readable UDI',  'Machine readable UDI',  'machine readable bar code in hex'),
  (5054, 12, 'Text attribute.Serial number',  'Serial number',  'Serial number of the device'),
  (5055, 12, 'Text attribute.Manufacturer',  'Manufacturer',  'Information about a manufacturer of a device'),
  (5056, 7,  'Codeable attribute.Device type',  'Device type',  'What sort of device it is'),
  (5057, 12, 'Text attribute.Device version',  'Device version',  'Version of the device (if software)'),
  (5058, 4,  'RecordType.Organisational identifier',  'Organisational identifier',  'Main identifier of organisation used throughout the service e.g. ODS code'),
  (5059, 12, 'Text attribute.Organisation/ service name',  'Organisation/ service name',  'Text of organisation name'),
  (5060, 7,  'Codeable attribute.Organisaion/ service category',  'Organisaion/ service category',  'Type of organisation department or service'),
  (5062, 7,  'Codeable attribute.Location type',  'Location type',  'Type of location e.g. ward, branch surgery'),
  (5063, 7,  'Codeable attribute.Consent type',  'Consent type',  'Nature of the process the consent is for e.g. summary care record, type II obje'),
  (5064, 7,  'Codeable attribute.Consent or Dissent',  'Consent or Dissent',  'Consent or dissent qhich may be qualfied'),
  (5065, 11, 'Date time attribute.End date and time',  'End date and time',  'End date and time relevant to this type of entry'),
  (5066, 4,  'RecordType.Consent target',  'Consent target',  'id of a contract or agreement or some other target of the consent'),
  (5067, 7,  'Codeable attribute.Nature of care episode',  'Nature of care episode',  'Nature or type of care episode (e.g. GMS registration hospital episode)'),
  (5068, 4,  'RecordType.Initiating referral',  'Initiating referral',  'Link to the referral that initiated this entry'),
  (5069, 4,  'RecordType.Episode administration process linked',  'Episode administration process linked',  'Link to the list of administration processes associated with this episode (e.g.'),
  (5070, 4,  'RecordType.Linked entries',  'Linked entries',  'Links to the entries associated with this entry'),
  (5071, 7,  'Codeable attribute.Episode administration status',  'Episode administration status',  'The nature of the administration entry (e.g. notification of registration)'),
  (5072, 7,  'Codeable attribute.Episode admin status subtype',  'Episode admin status subtype',  'More specific substype of the admin status (e.g. death or embarkation against a '),
  (5073, 7,  'Codeable attribute.Patient episode administration type',  'Patient episode administration type',  'Categorisation of the patient in a care episode for contract purposes (e.g. reg'),
  (5074, 4,  'RecordType.Linked care episode',  'Linked care episode',  'Link to the care episode '),
  (5078, 7,  'Codeable attribute.Completion status',  'Completion status',  'Status of completion of an entry (e.g. completed or ongoing)'),
  (5079, 4,  'RecordType.Duration',  'Duration',  'Duration of an event with units and a value'),
  (5080, 4,  'RecordType.Travel time',  'Travel time',  'Time of travelling in relation to the event with units and a value'),
  (5081, 7,  'Codeable attribute.Reason for encounter',  'Reason for encounter',  'A reason for the event (e.g encounter) often as text'),
  (5082, 12, 'Text attribute.Reason text',  'Reason text',  'Textual free text reason for an event'),
  (5083, 4,  'RecordType.Linked appointment',  'Linked appointment',  'Link to the associated appointment'),
  (5084, 4,  'RecordType.Parent encounter',  'Parent encounter',  'Link to the parent encounter entry'),
  (5085, 4,  'RecordType.Child encounter',  'Child encounter',  'Link to a child encounter'),
  (5086, 4,  'RecordType.Additional practitioners',  'Additional practitioners',  'Link to additional practitioners associated with this event'),
  (5090, 4,  'RecordType.Destination location',  'Destination location',  'Location of the destination in a care transfer or referral'),
  (5092, 7,  'Codeable attribute.Priority',  'Priority',  'Priority of event e.g. referral'),
  (5093, 7,  'Codeable attribute.Referred by type',  'Referred by type',  'Nature of referral person e.g. self referral professional'),
  (5094, 4,  'RecordType.Source organisation',  'Source organisation',  'Link to the organisation that was the source of the referral or care transfer'),
  (5095, 7,  'Codeable attribute.Service type requested',  'Service type requested',  'The type of service being requested by the referral e.g. Advice'),
  (5096, 7,  'Codeable attribute.Speciality requested',  'Speciality requested',  'Speciality of the requested service'),
  (5097, 7,  'Codeable attribute.Referral reason ',  'Referral reason ',  'The clinical condition or problem for which the referral has been made'),
  (5098, 4,  'RecordType.Recipient service or clinic',  'Recipient service or clinic',  'Service or organisation that this referral is to (e.g. the clinic)'),
  (5099, 4,  'RecordType.Recipient location',  'Recipient location',  'Location or destination location of the referral'),
  (5100, 4,  'RecordType.Recipent practitioner',  'Recipent practitioner',  'The person to whom the referral is made'),
  (5101, 12, 'Text attribute.Referral UBRN',  'Referral UBRN',  'Referral number of reference'),
  (5102, 7,  'Codeable attribute.Referral mode',  'Referral mode',  'Way of making referral e.g. letter, verbal, ERS- online'),
  (5103, 7,  'Codeable attribute.Requested procedure',  'Requested procedure',  'The test that is being ordered'),
  (5104, 7,  'Codeable attribute.Reason for procedure request',  'Reason for procedure request',  'Codeable reason for the test request'),
  (5105, 12, 'Text attribute.Reason for request - text',  'Reason for request - text',  'Narrative about reason for request'),
  (5106, 12, 'Text attribute.Request identifier',  'Request identifier',  'order number'),
  (5107, 4,  'RecordType.Linked encounter',  'Linked encounter',  'The encounter this entry is linked to'),
  (5109, 7,  'Codeable attribute.Type of schedule',  'Type of schedule',  'Nature of the appointment schedule'),
  (5110, 12, 'Text attribute.Schedule description',  'Schedule description',  'Text description of schedule'),
  (5112, 11, 'Date time attribute.Start Date and Time',  'Start Date and Time',  'Start Date and time for a very specific period of time'),
  (5113, 4,  'RecordType.Linked appointment slots',  'Linked appointment slots',  'Appointments linked to this schedule'),
  (5114, 4,  'RecordType.Practitioners',  'Practitioners',  'List of practitioners linked to this entry'),
  (5115, 7,  'Codeable attribute.Appointment category',  'Appointment category',  'Type of appointment slot'),
  (5116, 7,  'Codeable attribute.Planned reason',  'Planned reason',  'A codeable planned reason for the appointment '),
  (5117, 12, 'Text attribute.Planned reason text',  'Planned reason text',  'Narrative about reason for appointment'),
  (5118, 12, 'Text attribute.Description',  'Description',  'Narrative description associated with this entry'),
  (5119, 4,  'RecordType.Planned duration',  'Planned duration',  'Planned period of time for this activity'),
  (5120, 11, 'Date time attribute.Start time',  'Start time',  'Start time for an activity (when date not normally displayed)'),
  (5121, 11, 'Date time attribute.End time',  'End time',  'Start time (when a date is not normally specified)'),
  (5122, 7,  'Codeable attribute.Slot booking status',  'Slot booking status',  'Status of the booking in relation to the slot'),
  (5123, 7,  'Codeable attribute.Attendance status',  'Attendance status',  'Status of whether the patient has arrived for the appointment, gone in or left '),
  (5124, 7,  'Codeable attribute.Booking urgency',  'Booking urgency',  'Reflection of whether the appointment was booked as urgent (whether it was an ur'),
  (5125, 4,  'RecordType.Linked schedule',  'Linked schedule',  'Link to the schedule the appointment slot is part of'),
  (5126, 4,  'RecordType.Booking history',  'Booking history',  'Links to the history of bookings or cancellations for this slot'),
  (5127, 7,  'Codeable attribute.Booking or cancellation',  'Booking or cancellation',  'Whether this is a booking transaction or cancellation transaction'),
  (5128, 4,  'RecordType.Patient expressed reason',  'Patient expressed reason',  'Reason for appointment as expressed by patient'),
  (5129, 4,  'RecordType.Linked appointment slot',  'Linked appointment slot',  'The appointment slot linked to this entry'),
  (5130, 7,  'Codeable attribute.Document status',  'Document status',  'Status of plan or document, draft, active, replaced etc'),
  (5131, 4,  'RecordType.Type of plan',  'Type of plan',  'Category of plan such as Asthma action plan - cancer management plan - Procedure'),
  (5132, 4,  'RecordType.Linked activities',  'Linked activities',  'links to the activities associated with the plan'),
  (5133, 4,  'RecordType.Linked episodes',  'Linked episodes',  'Care episodes linked to this plan'),
  (5134, 4,  'RecordType.Parent plan',  'Parent plan',  'The plan this plan is part of'),
  (5135, 4,  'RecordType.Associated practitioners',  'Associated practitioners',  'Pracitioners associated with the plan'),
  (5136, 4,  'RecordType.Associated teams',  'Associated teams',  'Teams associated with this plan'),
  (5137, 12, 'Text attribute.Team name',  'Team name',  'Name of the team'),
  (5138, 4,  'RecordType.Team members',  'Team members',  'Practioners who are members of teams'),
  (5139, 4,  'RecordType.Heading',  'Heading',  'The heading term used to structure a record, a document or a template for human'),
  (5142, 4,  'RecordType.Order',  'Order',  'Used to order this entry in respect of its parent'),
  (5143, 4,  'RecordType.Linked care plan',  'Linked care plan',  'The care plan to which this entry links'),
  (5144, 4,  'RecordType.Observation type',  'Observation type',  'Category f the observation, including whether this is a sub-type entry (describ'),
  (5145, 4,  'RecordType.Observation concept',  'Observation concept',  'Nature of the entry, nearly always a Snomed-CT concept. <p>This may be a simple'),
  (5146, 4,  'RecordType.Context',  'Context',  'Prompt or question or other preceding text that provides the context for the res'),
  (5147, 4,  'RecordType.Is problem',  'Is problem',  'Whether or not this entry forms all or part of the problem definition'),
  (5148, 4,  'RecordType.Problem episode',  'Problem episode',  'If this is a problem code, whether this observation indicates a review or onset'),
  (5149, 4,  'RecordType.Normality',  'Normality',  'Whether normal or not and nature of abormality (e.g. high or low)'),
  (5150, 4,  'RecordType.Linked problems',  'Linked problems',  'Links to parent or child problems or problems that have been evolved from'),
  (5151, 4,  'RecordType.Child observations',  'Child observations',  'Links to child observations'),
  (5152, 4,  'RecordType.Parent observation',  'Parent observation',  'Link to parent observation'),
  (5154, 4,  'RecordType.Flag',  'Flag',  'An alert or flag linked to this entry'),
  (5155, 4,  'RecordType.Operator',  'Operator',  'Nature of arithmetic operator such as greater than or less than '),
  (5156, 4,  'RecordType.Numeric value',  'Numeric value',  'Numeric value of concept'),
  (5157, 4,  'RecordType.Reference range',  'Reference range',  'The normal reference range for this observation not to be confused with referenc'),
  (5158, 4,  'RecordType.Linked ranges',  'Linked ranges',  'Other ranges associated with this observation provided for background informatio'),
  (5159, 4,  'RecordType.Units of measure',  'Units of measure',  'Code of units of measure (e.g. mm Hg  IU/L)'),
  (5160, 4,  'RecordType.Performed period',  'Performed period',  'Period of time the procedure or activity took (units and value)'),
  (5161, 4,  'RecordType.Outcome',  'Outcome',  'Coded outcome of the procedure or activity'),
  (5162, 4,  'RecordType.Outcome text',  'Outcome text',  'Textual description of outcome of procedure'),
  (5163, 4,  'RecordType.Complications',  'Complications',  'Complication observations linked to the procedure'),
  (5164, 4,  'RecordType.Follow ups',  'Follow ups',  'Link to care plan diary entries'),
  (5165, 4,  'RecordType.Devices used',  'Devices used',  'Links to devices use in the procedure'),
  (5166, 4,  'RecordType.Flag category',  'Flag category',  'Category of flag used to determine when the flag is normally displayed in an app'),
  (5167, 4,  'RecordType.Flag type',  'Flag type',  'Type of flag as a standard codable concept Do not stop taking this medication wi'),
  (5168, 4,  'RecordType.Flag text',  'Flag text',  'Textual description of flag, additional to the flag type or as an alternative t'),
  (5169, 4,  'RecordType.Substance',  'Substance',  'The actual substance to which the entry relates. <p> It might be a specific drug'),
  (5170, 4,  'RecordType.Manifestation',  'Manifestation',  'The nature of the reaction associated with the allergy or adverse reactoin such'),
  (5171, 4,  'RecordType.Manifestation description',  'Manifestation description',  'Textual descriptoin of the manifestation in addition to or instead of the manife'),
  (5172, 4,  'RecordType.Batch number',  'Batch number',  'Batch number of vaccine'),
  (5173, 4,  'RecordType.Expiry date',  'Expiry date',  'Expiry date of product'),
  (5174, 4,  'RecordType.Vaccine product',  'Vaccine product',  'The actual vaccine product'),
  (5175, 4,  'RecordType.Vaccine dose sequence',  'Vaccine dose sequence',  'Number of the vaccine in the course (1st 2nd 3rd etc)'),
  (5176, 4,  'RecordType.Vaccine doses required',  'Vaccine doses required',  'Number of doses required to achieve immunity'),
  (5177, 4,  'RecordType.Reaction',  'Reaction',  'Link to the observation record holding a reaction to the vaccine'),
  (5178, 4,  'RecordType.Problem type',  'Problem type',  'Concept: for the term that the healthcare worker assigns to this construct e.g.'),
  (5179, 4,  'RecordType.Significance',  'Significance',  'Whether significant minor or other significance concepts'),
  (5180, 4,  'RecordType.Expected duration',  'Expected duration',  'How long it is expected that the issue relating to this entry would be expected '),
  (5181, 4,  'RecordType.Parent problem',  'Parent problem',  'Link to the problem this is a part of'),
  (5182, 4,  'RecordType.Child problems',  'Child problems',  'Links to child problems'),
  (5183, 4,  'RecordType.Medication',  'Medication',  'The medication or appliance that this entry refers to'),
  (5184, 4,  'RecordType.Dosage structured',  'Dosage structured',  'The expression describing the dosage in computable terms'),
  (5185, 4,  'RecordType.Dosage text',  'Dosage text',  'Textual description of the dosage of the medication'),
  (5186, 4,  'RecordType.Quantity of medicine',  'Quantity of medicine',  'Quantity of medication related to a dosage or order'),
  (5187, 4,  'RecordType.Number of authorised repeats',  'Number of authorised repeats',  'number in the course that can be issued before the patient must be reviewed'),
  (5188, 4,  'RecordType.Review date',  'Review date',  'Date that this particular medication should be reviewed (as distinct from the re'),
  (5189, 4,  'RecordType.Order duration',  'Order duration',  'Expected duration of the presription or ordered item e.g. 28 days'),
  (5190, 4,  'RecordType.Additional patient instructions',  'Additional patient instructions',  'Additional instructions to the patient for taking medication or activity'),
  (5191, 4,  'RecordType.Pharmacy instruction',  'Pharmacy instruction',  'Additoinal instructions to the pharmacist beyond the dosage instructions'),
  (5192, 4,  'RecordType.Treatment management responsibility',  'Treatment management responsibility',  'The health domain type that manages the medication e.g. hospital, pharmacy, gen'),
  (5193, 4,  'RecordType.Originating health domain',  'Originating health domain',  'The health domain type that originated the medicatoin e.g. hospital, pharmacy, '),
  (5194, 4,  'RecordType.Reason for ending medication',  'Reason for ending medication',  'Reason for ending the medication'),
  (5195, 4,  'RecordType.Linked medication orders',  'Linked medication orders',  'Links to the medication issues or actual prescriptions for this medication'),
  (5196, 4,  'RecordType.Flags',  'Flags',  'Links to flags or alerts associated with this medication statement (not to be co'),
  (5197, 4,  'RecordType.Course type',  'Course type',  'Whether this is a one off, a repeat medication or repeat dispensing medication'),
  (5198, 4,  'RecordType.Planned date',  'Planned date',  'Planned date (e.g. date for recall)'),
  (5200, 4,  'RecordType.Units of time',  'Units of time',  'units relating to time'),
  (5201, 4,  'RecordType.Healthcare service type',  'Healthcare service type',  'The historical category of health care service such as general practice or acute services'),
  (5202, 4,  'RecordType.Interaction mode',  'Interaction mode',  'Nature of social interaction between participants such as face to face via the telephon etc'),
  (5203, 4,  'RecordType.Administrative action',  'Administrative action',  'A type of action in respect of processing a patient through the health system e.g. admission and discharge or transfers'),
  (5204, 4,  'RecordType.General purpose',  'General purpose',  'General purpose of encounter or event'),
  (5205, 4,  'RecordType.Location',  'Location',  'Points to a physical location'),
  (5206, 7,  'Codeable attribute.Disposition',  'Disposition',  'Nature of the disposition of the patient after the event or encounter'),
  (5207, 7,  'Codeable attribute.Site of care type',  'Site of care type',  'Description of site of care or location type eg hospital or daya centre'),
  (5208, 7,  'Codeable attribute.Patient status',  'Patient status',  'Status of patient in respect of the event or encounter'),
  (5209, 7,  'Codeable attribute.Address format type',  'Address format type',  'The format of the address e.g. PAF unstructured PDS'),
  (5210, 12, 'Text attribute.Address line 3',  'Address line 3',  '3rd address line of an address'),
  (5211, 12, 'Text attribute.Address line 4',  'Address line 4',  '4th address line of the address'),
  (5212, 8,  'Whole number attribute.Minimum occurrences',  'Minimum occurrences',  'the minimum number of occurrences of this attribute - 0 means optional');
*/

UPDATE concept
SET status = 1;

INSERT INTO concept_attribute
    (concept, attribute, `order`, minimum, maximum)
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
    (1001, 5014, 5, 0, 1); -- Demographics -> Birth date (0:1)

INSERT INTO concept_relationship
  (source, relationship, target)
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
  (516, 100, 502),    -- Atts folder             -- is a --> Atts & rels folder

  (5007, 100, 5019),  -- NHS Number              -- is a --> Patient identifier

  (5031, 100, 5030);  -- SNOMED                  -- is a --> Code scheme

INSERT INTO concept_relationship
    (source, relationship, target, mandatory, `limit`)
VALUES
    (5038, 102, 5032, 0, 1),
    (5038, 102, 5033, 0, 0),
    (5038, 102, 5034, 0, 1),
    (5038, 102, 5035, 0, 0),
    (5038, 102, 5036, 0, 0),
    (5038, 102, 5037, 0, 1),

    (5042, 102, 5039, 0, 0),
    (5042, 102, 5040, 0, 1),
    (5042, 102, 5041, 0, 0),
    (5042, 100, 5038, 1, 0),

    (5045, 102, 5043, 0, 0),
    (5045, 102, 5044, 0, 1),
    (5045, 102, 5038, 1, 0),

    (5051, 102, 5046, 0, 1),
    (5051, 102, 5047, 0, 1),
    (5051, 102, 5048, 0, 1),
    (5051, 102, 5049, 0, 1),
    (5051, 102, 5050, 0, 0),
    (5051, 100, 5045, 1, 0),
    (5051, 102, 5042, 1, 0);

DELETE FROM table_id;
INSERT INTO table_id (name, id) SELECT 'BaseConcept', MAX(id)+1 FROM concept WHERE id < 100;
INSERT INTO table_id (name, id) SELECT 'Relationship', MAX(id)+1 FROM concept WHERE id < 500;
INSERT INTO table_id (name, id) SELECT 'Folder', MAX(id)+1 FROM concept WHERE id < 1000;
INSERT INTO table_id (name, id) SELECT 'RecordType', MAX(id)+1 FROM concept WHERE id < 1000000;
INSERT INTO table_id (name, id) SELECT 'Concept', MAX(id)+1 FROM concept;

INSERT INTO code_scheme
  (id, identifier)
VALUES
  (5031, 'SNOMED-CT');

INSERT INTO task_type
    (id, name)
VALUES
   (0, 'Attribute model'),
   (1, 'Value model'),
   (2, 'Message mappings'),
   (3, 'Term mappings');