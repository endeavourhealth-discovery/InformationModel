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
  (id,  full_name, context, description)
VALUES
  -- BASE TYPES
  (1,	'Type',	'Type.Type',	'Absctract class to which all concept types belong'),
  (2,	'Record Type',	'Type.Record Type',	'A structure that contains fields or other records'),
  (3,	'Field type',	'Type.Field type',	'An attribute of a record type structure that holds a value'),
  (4,	'Code concept',	'Type.Code concept',	'Any concept that can be identified as part of a taxonomy or classiication'),
  (5,	'Code Field',	'Field type.Code Field',	'A Field whose value is a code concept'),
  (8,	'Numeric field',	'Field type.Numeric field',	'A type of field that holds a number (integer or float)'),
  (9,	'Date time field',	'Field type.Date time field',	'A type of field that holds a date and time'),
  (10,	'Text field',	'Field type.Text field',	'A field that holds a free text value'),
  (11,	'Boolean field',	'Field type.Boolean field',	'A field that contains a boolean value'),
  (14,	'Folder type',	'Type.Folder type',	'A concept that contains other concepts as a place holder in a view'),
  (15,	'Relationship',	'Type.Relationship',	'A concept only used in the relationship links between one concept and another, '),

  -- RELATIONSHIPS
  (100,	'is a',	'Relationship.is a',	'source concept inherits the semantic meaning of the more generalised target - source is more specialised'),
  (101,	'Related to',	'Relationship.Related to',	'The source is related to the target in an unsepecified way'),
  (102,	'has a',	'Relationship.has a',	'Source has an attribute type of the target'),
  (103,	'has qualifier',	'Relationship.has qualifier',	'The source has a qualifier in relation to the concept it is related to'),

  -- FOLDERS
  (500,	'Information model',	'Folder.Information model',	'The Discovery information model is a knowledge base that describes all of the kn'),
  (502,	'Attributes and Relationships',	'Folder.Attributes and Relationships',	'Groups the relationship types when navigating the information model'),
  (504,	'Care administration entries',	'Folder.Care administration entries',	'Folder containing record types that hold information about care administration i'),
  (505,	'Clinical record entries',	'Folder.Clinical record entries',	'Folder containing Record types that store patient clinical or personal character'),
  (506,	'Care process entries',	'Folder.Care process entries',	'Structures describing care process events in relation to the patient&#44; such a'),
  (507,	'Health workers organisations and other entities',	'Folder.Health workers organisations and other entities',	'Structures that describe staff professionals organisations departments and servi'),
  (510,	'Record structures',	'Folder.Record structures',	'The default view for viewing the information model'),
  (512,	'Specialised record types',	'Folder.Specialised record types',	'Record types used by other entries'),
  (513,	'Information model support structures',	'Folder.Information model support structures',	'Structures such as classes and relationships that support the model'),
  (514,	'Type list',	'Folder.Type list',	'List of classes used in the model'),
  (515,	'Relationships',	'Folder.Relationships',	'List of relationship types in the core model'),
  (516,	'Attribute types',	'Folder.Attribute types',	'A list of attribute types used in the core model'),

  -- RECORD & FIELD TYPES
  (1000,	'Health record event',	'RecordType.Health record event',	'The basic items in any event based health record entry'),
  (1001,	'Patient master demographics',	'RecordType.Patient master demographics',	'Patient demographic information relating to their birth&#44; administrative gend'),
  (1002,	'Practitioner in role',	'RecordType.Practitioner in role',	'Information describing any person who provides care or is part of the health car'),
  (1003,	'Device',	'RecordType.Device',	'Information about a medical device used in care and classified according to type'),
  (1004,	'Organisation service or department',	'RecordType.Organisation service or department',	'Information about organisations&#44; services&#44; or departments '),
  (1005,	'Location',	'RecordType.Location',	'Information about an actual location (which may have an address separate to the '),
  (1006,	'Care episode',	'RecordType.Care episode',	'A care episode is an association between a patient and a healthcare provider dur'),
  (1007,	'Care episode administration',	'RecordType.Care episode administration',	'Information about the administration of patient reception and registration in th'),
  (1008,	'Encounter',	'RecordType.Encounter',	'An encounter is an interaction between a patient and healthcare provider for the'),
  (1010,	'Referral request',	'RecordType.Referral request',	'A referral request includes request for advice or invitation to participate in c'),
  (1011,	'Procedure or test request',	'RecordType.Procedure or test request',	'A procedure request is a record of a request for a procedure to be planned&#44; '),
  (1012,	'Appointment schedule',	'RecordType.Appointment schedule',	'An appointment schedule is an appointment grouping implying a session or a clini'),
  (1013,	'Appointment booking history',	'RecordType.Appointment booking history',	'Information about the process of booking and unbooking of a planned appointment '),
  (1014,	'Appointment slot',	'RecordType.Appointment slot',	'This is information about a particular appointment or slot as planned. This is a'),
  (1015,	'Appointment attendance',	'RecordType.Appointment attendance',	'Historical Information about an actual attendance for a patient for an appointme'),
  (1016,	'Care plan',	'RecordType.Care plan',	'Simple plans (such as review dates) or a relatively simple data subset of a comp'),
  (1018,	'Observation',	'RecordType.Observation',	'A Generic observation is the root for most clinical entries about a patient&#44;'),
  (1019,	'Numeric observation',	'RecordType.Numeric observation',	'Any observation with a numeric value e.g. path result or vital signs. A numeric '),
  (1020,	'Procedure',	'RecordType.Procedure',	'Procedure provides more information  beyond a simple observation about an operat'),
  (1021,	'Immunisation',	'RecordType.Immunisation',	'Immunisation extends a simple observation by providing more information about th'),
  (1022,	'Allergy and adverse reaction',	'RecordType.Allergy and adverse reaction',	'Allergies provide more information about the allergy such as the substance and n'),
  (1023,	'Problem',	'RecordType.Problem',	'Problem is a patient and record management construct designed to help manage car'),
  (1024,	'Medication statement',	'RecordType.Medication statement',	'Medication entries are templates for describing and authorising a course of medi'),
  (1025,	'Medication order or issue',	'RecordType.Medication order or issue',	'A medication order is the actual prescription for a medication item. It represen'),
  (1026,	'Flag or Alert',	'RecordType.Flag or Alert',	'A flag is a warning or notification of some sort presented to the user - who may'),
  (1027,	'Consent',	'RecordType.Consent',	'Patient may consent or dissent for a variety of service provision or sharing of '),
  (1028,	'Patient organisational demographics',	'RecordType.Patient organisational demographics',	'Details about the patient in the context of a particlar organisation'),
  (1029,	'Person name',	'RecordType.Person name',	'Name of a person'),
  (1030,	'Address',	'RecordType.Address',	'Address details'),
  (1031,	'Contact',	'RecordType.Contact',	'Information about contact numbers and email addresses'),
  (1032,	'Related person',	'RecordType.Related person',	'Information about related persons to a patient'),
  (1033,	'Post code linked data',	'RecordType.Post code linked data',	'LSOA MSOA IMDS and data related to a post code'),
  (1034,	'Person in role',	'RecordType.Person in role',	'Information about a person in a role'),
  (1035,	'Identifier',	'RecordType.Identifier',	'An identifier including the scheme and value'),
  (1036,	'Quantity time',	'RecordType.Quantity time',	'An attribute group specialising in  units of time'),
  (1037,	'Quantity medication',	'RecordType.Quantity medication',	'An attribute group specialising in medication quantities with a value and unit'),
  (1038,	'Quantity measure',	'RecordType.Quantity measure',	'Numeric quantity with units that are measurements eg. Weights ot lengths'),
  (1039,	'Range numeric',	'RecordType.Range numeric',	'structure that has a range type operator and upper and lower value'),
  (5000,	'Date and time entry recorded',	'Date time field.Date and time entry recorded',	'The data and time the entry was made. This may not be the same as the date and t'),
  (5001,	'Recorded by',	'Record Type.Recorded by',	'The person or device who recorded the entry. This may or may not be the same as '),
  (5002,	'Responsible practitioner',	'Record Type.Responsible practitioner',	'The person responsible for the entry, usually a professional health worker'),
  (5003,	'Effective date and time',	'Date time field.Effective date and time',	'e.g. a year or month). It may be a point in time or a period of time (e.g. an en'),
  (5004,	'Patient or service user',	'Record Type.Patient or service user',	'The patient/client/service user  to whom the entry refers'),
  (5005,	'Owning organisation',	'Record Type.Owning organisation',	'The organisation or service within an organisation responsible for the entry of '),
  (5006,	'Pseudonymised patient id',	'Text field.Pseudonymised patient id',	'Hash with Salt key of identifiers of the patient'),
  (5007,	'NHS number',	'Text field.NHS number',	'The NHS number allocated to the patient.'),
  (5008,	'Name',	'Record Type.Name',	'Information about the name'),
  (5009,	'Title',	'Text field.Title',	'Title or prefix to name'),
  (5010,	'First name(s)',	'Text field.First name(s)',	'Forenames or first names or given names'),
  (5011,	'Middle names',	'Text field.Middle names',	'After the first and before the last'),
  (5012,	'Last name',	'Text field.Last name',	'Last name or surname or family name'),
  (5013,	'Gender (administrative)',	'Code Field.Gender (administrative)',	'The gender that the person considers themselves to be allocated to for the purpo'),
  (5014,	'Date of birth',	'Date time field.Date of birth',	'Date of birth of the patient, as far as is known'),
  (5015,	'Pseudonymised date of birth',	'Date time field.Pseudonymised date of birth',	'Date of birth by year or month depending on age of patient and level of de-idnti'),
  (5016,	'Age',	'Numeric field.Age',	'Age of patient as calculated between date of birth and the date of interest'),
  (5017,	'Death indicator',	'Boolean field.Death indicator',	'If a patient has died an indicator that they are now dead'),
  (5018,	'Date of death',	'Date time field.Date of death',	'If dead and if available, the date of death'),
  (5019,	'Patient identifiers',	'Record Type.Patient identifiers',	'An identifier for the person. For example a hospital number, CHI number, NI num'),
  (5020,	'Identifier scheme',	'Code Field.Identifier scheme',	'Nature of the persons identifier e.g. hospital number, CHI number'),
  (5021,	'Identifier value',	'Text field.Identifier value',	'Value of the persons identifier'),
  (5022,	'Pseudonymised address',	'Text field.Pseudonymised address',	'Hash with Salt key of household'),
  (5023,	'Address type',	'Code Field.Address type',	'A location address'),
  (5024,	'Address line 1',	'Text field.Address line 1',	'First line, normally house name or number'),
  (5025,	'Address line 2',	'Text field.Address line 2',	'Second address line normally street'),
  (5026,	'Locality',	'Text field.Locality',	'Third address line normally village or area'),
  (5027,	'City',	'Text field.City',	'Fourth address line normally town'),
  (5028,	'Address line 5',	'Text field.Address line 5',	'Fifth address line normally county'),
  (5029,	'Post code',	'Text field.Post code',	'Post code of address'),
  (5030,	'UPRN',	'Text field.UPRN',	'Unique property reference number (household)'),
  (5031,	'Lower super output area',	'Text field.Lower super output area',	'Geographical area linked to postcode more specific than MSOA'),
  (5032,	'Middle super output area',	'Text field.Middle super output area',	'Geopgraphical area linked to postcode less specific than LSOA'),
  (5033,	'Contact information',	'Record Type.Contact information',	'potentially used in contacting the individual, each contact qualified by contac'),
  (5034,	'Contact type',	'Code Field.Contact type',	'whether email telephone number etc'),
  (5035,	'Contact value',	'Text field.Contact value',	'Actual telephone number or email'),
  (5036,	'Ethnicity',	'Code Field.Ethnicity',	'Derived from the latest ethnic group observation'),
  (5037,	'Language',	'Code Field.Language',	'Links to the Languages that the patient speaks qualified by preferred spoken etc'),
  (5038,	'Confidentiality type',	'Code Field.Confidentiality type',	'When a record is marked as confidential what is the type of confidentiality '),
  (5039,	'Related persons',	'Record Type.Related persons',	'Information about people related to the patient (family carers etc)'),
  (5040,	'Previous last name',	'Text field.Previous last name',	'last name the patient was known by (this is not the audit trail of previous name'),
  (5041,	'Index of multiple deprivation',	'Text field.Index of multiple deprivation',	'Statistical index of multiple deprivation'),
  (5042,	'Active status',	'Text field.Active status',	'Whether active or not'),
  (5043,	'Service or organisation',	'Record Type.Service or organisation',	'Points to the organisation or service that this field represents'),
  (5044,	'Role type',	'Code Field.Role type',	'The type of role the user operates as (e.g. doctor nurse)'),
  (5045,	'Speciality',	'Code Field.Speciality',	'The speciality this field refers to'),
  (5046,	'Contract start date',	'Date time field.Contract start date',	'Date the contract started'),
  (5047,	'Contract end date',	'Date time field.Contract end date',	'Date the contract ended (if no longer active)'),
  (5048,	'Related person information',	'Record Type.Related person information',	'Link to a related person details when they are not in the Discovery database'),
  (5049,	'Related person relationship',	'Code Field.Related person relationship',	'The type of relationship e.g. Mother, Father, Genetic mother etc'),
  (5050,	'Related patient',	'Record Type.Related patient',	'Link to a related patient who is actually in the Database'),
  (5051,	'Device name',	'Text field.Device name',	'The actual name of the device'),
  (5052,	'Human readable UDI',	'Text field.Human readable UDI',	'The human readable bar code of the device'),
  (5053,	'Machine readable UDI',	'Text field.Machine readable UDI',	'machine readable bar code in hex'),
  (5054,	'Serial number',	'Text field.Serial number',	'Serial number of the device'),
  (5055,	'Manufacturer',	'Text field.Manufacturer',	'Information about a manufacturer of a device'),
  (5056,	'Device type',	'Code Field.Device type',	'What sort of device it is'),
  (5057,	'Device version',	'Text field.Device version',	'Version of the device (if software)'),
  (5058,	'Organisational identifier',	'Record Type.Organisational identifier',	'Main identifier of organisation used throughout the service e.g. ODS code'),
  (5059,	'Organisation/ service name',	'Text field.Organisation/ service name',	'Text of organisation name'),
  (5060,	'Organisaion/ service category',	'Code Field.Organisaion/ service category',	'Type of organisation department or service'),
  (5062,	'Location type',	'Code Field.Location type',	'Type of location e.g. ward, branch surgery'),
  (5063,	'Consent type',	'Code Field.Consent type',	'Nature of the process the consent is for e.g. summary care record, type II obje'),
  (5064,	'Consent or Dissent',	'Code Field.Consent or Dissent',	'Consent or dissent qhich may be qualfied'),
  (5065,	'End date and time',	'Date time field.End date and time',	'End date and time relevant to this type of entry'),
  (5066,	'Consent target',	'Record Type.Consent target',	'id of a contract or agreement or some other target of the consent'),
  (5067,	'Nature of care episode',	'Code Field.Nature of care episode',	'Nature or type of care episode (e.g. GMS registration hospital episode)'),
  (5068,	'Initiating referral',	'Record Type.Initiating referral',	'Link to the referral that initiated this entry'),
  (5069,	'Episode administration process linked',	'Record Type.Episode administration process linked',	'Link to the list of administration processes associated with this episode (e.g.'),
  (5070,	'Linked entries',	'Record Type.Linked entries',	'Links to the entries associated with this entry'),
  (5071,	'Episode administration status',	'Code Field.Episode administration status',	'The nature of the administration entry (e.g. notification of registration)'),
  (5072,	'Episode admin status subtype',	'Code Field.Episode admin status subtype',	'More specific substype of the admin status (e.g. death or embarkation against a '),
  (5073,	'Patient episode administration type',	'Code Field.Patient episode administration type',	'Categorisation of the patient in a care episode for contract purposes (e.g. reg'),
  (5074,	'Linked care episode',	'Record Type.Linked care episode',	'Link to the care episode '),
  (5078,	'Completion status',	'Code Field.Completion status',	'Status of completion of an entry (e.g. completed or ongoing)'),
  (5079,	'Duration',	'Record Type.Duration',	'Duration of an event with units and a value'),
  (5080,	'Travel time',	'Record Type.Travel time',	'Time of travelling in relation to the event with units and a value'),
  (5081,	'Reason for encounter',	'Code Field.Reason for encounter',	'A reason for the event (e.g encounter) often as text'),
  (5082,	'Reason text',	'Text field.Reason text',	'Textual free text reason for an event'),
  (5083,	'Linked appointment',	'Record Type.Linked appointment',	'Link to the associated appointment'),
  (5084,	'Parent encounter',	'Record Type.Parent encounter',	'Link to the parent encounter entry'),
  (5085,	'Child encounter',	'Record Type.Child encounter',	'Link to a child encounter'),
  (5086,	'Additional practitioners',	'Record Type.Additional practitioners',	'Link to additional practitioners associated with this event'),
  (5090,	'Destination location',	'Record Type.Destination location',	'Location of the destination in a care transfer or referral'),
  (5092,	'Priority',	'Code Field.Priority',	'Priority of event e.g. referral'),
  (5093,	'Referred by type',	'Code Field.Referred by type',	'Nature of referral person e.g. self referral professional'),
  (5094,	'Source organisation',	'Record Type.Source organisation',	'Link to the organisation that was the source of the referral or care transfer'),
  (5095,	'Service type requested',	'Code Field.Service type requested',	'The type of service being requested by the referral e.g. Advice'),
  (5096,	'Speciality requested',	'Code Field.Speciality requested',	'Speciality of the requested service'),
  (5097,	'Referral reason ',	'Code Field.Referral reason ',	'The clinical condition or problem for which the referral has been made'),
  (5098,	'Recipient service or clinic',	'Record Type.Recipient service or clinic',	'Service or organisation that this referral is to (e.g. the clinic)'),
  (5099,	'Recipient location',	'Record Type.Recipient location',	'Location or destination location of the referral'),
  (5100,	'Recipent practitioner',	'Record Type.Recipent practitioner',	'The person to whom the referral is made'),
  (5101,	'Referral UBRN',	'Text field.Referral UBRN',	'Referral number of reference'),
  (5102,	'Referral mode',	'Code Field.Referral mode',	'Way of making referral e.g. letter, verbal, ERS- online'),
  (5103,	'Requested procedure',	'Code Field.Requested procedure',	'The test that is being ordered'),
  (5104,	'Reason for procedure request',	'Code Field.Reason for procedure request',	'Codeable reason for the test request'),
  (5105,	'Reason for request - text',	'Text field.Reason for request - text',	'Narrative about reason for request'),
  (5106,	'Request identifier',	'Text field.Request identifier',	'order number'),
  (5107,	'Linked encounter',	'Record Type.Linked encounter',	'The encounter this entry is linked to'),
  (5109,	'Type of schedule',	'Code Field.Type of schedule',	'Nature of the appointment schedule'),
  (5110,	'Schedule description',	'Text field.Schedule description',	'Text description of schedule'),
  (5112,	'Start Date and Time',	'Date time field.Start Date and Time',	'Start Date and time for a very specific period of time'),
  (5113,	'Linked appointment slots',	'Record Type.Linked appointment slots',	'Appointments linked to this schedule'),
  (5114,	'Practitioners',	'Record Type.Practitioners',	'List of practitioners linked to this entry'),
  (5115,	'Appointment category',	'Code Field.Appointment category',	'Type of appointment slot'),
  (5116,	'Planned reason',	'Code Field.Planned reason',	'A codeable planned reason for the appointment '),
  (5117,	'Planned reason text',	'Text field.Planned reason text',	'Narrative about reason for appointment'),
  (5118,	'Description',	'Text field.Description',	'Narrative description associated with this entry'),
  (5119,	'Planned duration',	'Record Type.Planned duration',	'Planned period of time for this activity'),
  (5120,	'Start time',	'Date time field.Start time',	'Start time for an activity (when date not normally displayed)'),
  (5121,	'End time',	'Date time field.End time',	'Start time (when a date is not normally specified)'),
  (5122,	'Slot booking status',	'Code Field.Slot booking status',	'Status of the booking in relation to the slot'),
  (5123,	'Attendance status',	'Code Field.Attendance status',	'Status of whether the patient has arrived for the appointment, gone in or left '),
  (5124,	'Booking urgency',	'Code Field.Booking urgency',	'Reflection of whether the appointment was booked as urgent (whether it was an ur'),
  (5125,	'Linked schedule',	'Record Type.Linked schedule',	'Link to the schedule the appointment slot is part of'),
  (5126,	'Booking history',	'Record Type.Booking history',	'Links to the history of bookings or cancellations for this slot'),
  (5127,	'Booking or cancellation',	'Code Field.Booking or cancellation',	'Whether this is a booking transaction or cancellation transaction'),
  (5128,	'Patient expressed reason',	'Record Type.Patient expressed reason',	'Reason for appointment as expressed by patient'),
  (5129,	'Linked appointment slot',	'Record Type.Linked appointment slot',	'The appointment slot linked to this entry'),
  (5130,	'Document status',	'Code Field.Document status',	'Status of plan or document, draft, active, replaced etc'),
  (5131,	'Type of plan',	'Record Type.Type of plan',	'Category of plan such as Asthma action plan - cancer management plan - Procedure'),
  (5132,	'Linked activities',	'Record Type.Linked activities',	'links to the activities associated with the plan'),
  (5133,	'Linked episodes',	'Record Type.Linked episodes',	'Care episodes linked to this plan'),
  (5134,	'Parent plan',	'Record Type.Parent plan',	'The plan this plan is part of'),
  (5135,	'Associated practitioners',	'Record Type.Associated practitioners',	'Pracitioners associated with the plan'),
  (5136,	'Associated teams',	'Record Type.Associated teams',	'Teams associated with this plan'),
  (5137,	'Team name',	'Text field.Team name',	'Name of the team'),
  (5138,	'Team members',	'Record Type.Team members',	'Practioners who are members of teams'),
  (5139,	'Heading',	'Record Type.Heading',	'The heading term used to structure a record, a document or a template for human'),
  (5142,	'Order',	'Record Type.Order',	'Used to order this entry in respect of its parent'),
  (5143,	'Linked care plan',	'Record Type.Linked care plan',	'The care plan to which this entry links'),
  (5144,	'Observation type',	'Record Type.Observation type',	'Category f the observation, including whether this is a sub-type entry (describ'),
  (5145,	'Observation concept',	'Record Type.Observation concept',	'Nature of the entry, nearly always a Snomed-CT concept. <p>This may be a simple'),
  (5146,	'Context',	'Record Type.Context',	'Prompt or question or other preceding text that provides the context for the res'),
  (5147,	'Is problem',	'Record Type.Is problem',	'Whether or not this entry forms all or part of the problem definition'),
  (5148,	'Problem episode',	'Record Type.Problem episode',	'If this is a problem code, whether this observation indicates a review or onset'),
  (5149,	'Normality',	'Record Type.Normality',	'Whether normal or not and nature of abormality (e.g. high or low)'),
  (5150,	'Linked problems',	'Record Type.Linked problems',	'Links to parent or child problems or problems that have been evolved from'),
  (5151,	'Child observations',	'Record Type.Child observations',	'Links to child observations'),
  (5152,	'Parent observation',	'Record Type.Parent observation',	'Link to parent observation'),
  (5154,	'Flag',	'Record Type.Flag',	'An alert or flag linked to this entry'),
  (5155,	'Operator',	'Record Type.Operator',	'Nature of arithmetic operator such as greater than or less than '),
  (5156,	'Numeric value',	'Record Type.Numeric value',	'Numeric value of concept'),
  (5157,	'Reference range',	'Record Type.Reference range',	'The normal reference range for this observation not to be confused with referenc'),
  (5158,	'Linked ranges',	'Record Type.Linked ranges',	'Other ranges associated with this observation provided for background informatio'),
  (5159,	'Units of measure',	'Record Type.Units of measure',	'Code of units of measure (e.g. mm Hg  IU/L)'),
  (5160,	'Performed period',	'Record Type.Performed period',	'Period of time the procedure or activity took (units and value)'),
  (5161,	'Outcome',	'Record Type.Outcome',	'Coded outcome of the procedure or activity'),
  (5162,	'Outcome text',	'Record Type.Outcome text',	'Textual description of outcome of procedure'),
  (5163,	'Complications',	'Record Type.Complications',	'Complication observations linked to the procedure'),
  (5164,	'Follow ups',	'Record Type.Follow ups',	'Link to care plan diary entries'),
  (5165,	'Devices used',	'Record Type.Devices used',	'Links to devices use in the procedure'),
  (5166,	'Flag category',	'Record Type.Flag category',	'Category of flag used to determine when the flag is normally displayed in an app'),
  (5167,	'Flag type',	'Record Type.Flag type',	'Type of flag as a standard codable concept Do not stop taking this medication wi'),
  (5168,	'Flag text',	'Record Type.Flag text',	'Textual description of flag, additional to the flag type or as an alternative t'),
  (5169,	'Substance',	'Record Type.Substance',	'The actual substance to which the entry relates. <p> It might be a specific drug'),
  (5170,	'Manifestation',	'Record Type.Manifestation',	'The nature of the reaction associated with the allergy or adverse reactoin such'),
  (5171,	'Manifestation description',	'Record Type.Manifestation description',	'Textual descriptoin of the manifestation in addition to or instead of the manife'),
  (5172,	'Batch number',	'Record Type.Batch number',	'Batch number of vaccine'),
  (5173,	'Expiry date',	'Record Type.Expiry date',	'Expiry date of product'),
  (5174,	'Vaccine product',	'Record Type.Vaccine product',	'The actual vaccine product'),
  (5175,	'Vaccine dose sequence',	'Record Type.Vaccine dose sequence',	'Number of the vaccine in the course (1st 2nd 3rd etc)'),
  (5176,	'Vaccine doses required',	'Record Type.Vaccine doses required',	'Number of doses required to achieve immunity'),
  (5177,	'Reaction',	'Record Type.Reaction',	'Link to the observation record holding a reaction to the vaccine'),
  (5178,	'Problem type',	'Record Type.Problem type',	'Concept: for the term that the healthcare worker assigns to this construct e.g.'),
  (5179,	'Significance',	'Record Type.Significance',	'Whether significant minor or other significance concepts'),
  (5180,	'Expected duration',	'Record Type.Expected duration',	'How long it is expected that the issue relating to this entry would be expected '),
  (5181,	'Parent problem',	'Record Type.Parent problem',	'Link to the problem this is a part of'),
  (5182,	'Child problems',	'Record Type.Child problems',	'Links to child problems'),
  (5183,	'Medication',	'Record Type.Medication',	'The medication or appliance that this entry refers to'),
  (5184,	'Dosage structured',	'Record Type.Dosage structured',	'The expression describing the dosage in computable terms'),
  (5185,	'Dosage text',	'Record Type.Dosage text',	'Textual description of the dosage of the medication'),
  (5186,	'Quantity of medicine',	'Record Type.Quantity of medicine',	'Quantity of medication related to a dosage or order'),
  (5187,	'Number of authorised repeats',	'Record Type.Number of authorised repeats',	'number in the course that can be issued before the patient must be reviewed'),
  (5188,	'Review date',	'Record Type.Review date',	'Date that this particular medication should be reviewed (as distinct from the re'),
  (5189,	'Order duration',	'Record Type.Order duration',	'Expected duration of the presription or ordered item e.g. 28 days'),
  (5190,	'Additional patient instructions',	'Record Type.Additional patient instructions',	'Additional instructions to the patient for taking medication or activity'),
  (5191,	'Pharmacy instruction',	'Record Type.Pharmacy instruction',	'Additoinal instructions to the pharmacist beyond the dosage instructions'),
  (5192,	'Treatment management responsibility',	'Record Type.Treatment management responsibility',	'The health domain type that manages the medication e.g. hospital, pharmacy, gen'),
  (5193,	'Originating health domain',	'Record Type.Originating health domain',	'The health domain type that originated the medicatoin e.g. hospital, pharmacy, '),
  (5194,	'Reason for ending medication',	'Record Type.Reason for ending medication',	'Reason for ending the medication'),
  (5195,	'Linked medication orders',	'Record Type.Linked medication orders',	'Links to the medication issues or actual prescriptions for this medication'),
  (5196,	'Flags',	'Record Type.Flags',	'Links to flags or alerts associated with this medication statement (not to be co'),
  (5197,	'Course type',	'Record Type.Course type',	'Whether this is a one off, a repeat medication or repeat dispensing medication'),
  (5198,	'Planned date',	'Record Type.Planned date',	'Planned date (e.g. date for recall)'),
  (5200,	'Units of time',	'Record Type.Units of time',	'units relating to time'),
  (5201,	'Healthcare service type',	'Record Type.Healthcare service type',	'The historical category of health care service such as general practice or acute services'),
  (5202,	'Interaction mode',	'Record Type.Interaction mode',	'Nature of social interaction between participants such as face to face via the telephon etc'),
  (5203,	'Administrative action',	'Record Type.Administrative action',	'A type of action in respect of processing a patient through the health system e.g. admission and discharge or transfers'),
  (5204,	'General purpose',	'Record Type.General purpose',	'General purpose of encounter or event'),
  (5205,	'Location',	'Record Type.Location',	'Points to a physical location'),
  (5206,	'Disposition',	'Code Field.Disposition',	'Nature of the disposition of the patient after the event or encounter'),
  (5207,	'Site of care type',	'Code Field.Site of care type',	'Description of site of care or location type eg hospital or daya centre'),
  (5208,	'Patient status',	'Code Field.Patient status',	'Status of patient in respect of the event or encounter'),
  (5209,	'Address format type',	'Code Field.Address format type',	'The format of the address e.g. PAF unstructured PDS'),
  (5210,	'Address line 3',	'Text field.Address line 3',	'3rd address line of an address'),
  (5211,	'Address line 4',	'Text field.Address line 4',	'4th address line of the address'),
  (5212,	'Minimum occurrences',	'Numeric field.Minimum occurrences',	'the minimum number of occurrences of this attribute - 0 means optional')
;

INSERT INTO concept_relationship
  (source, relationship, target)
VALUES
  (1,	100,	1),	-- Type	--> is a	--> Type
  (2,	100,	1),	-- Record Type	--> is a	--> Type
  (3,	100,	1),	-- Field type	--> is a	--> Type
  (4,	100,	1),	-- Code concept	--> is a	--> Type
  (5,	100,	3),	-- Code Field	--> is a	--> Field type
  (8,	100,	3),	-- Numeric field	--> is a	--> Field type
  (9,	100,	3),	-- Date time field	--> is a	--> Field type
  (10,	100,	3),	-- Text field	--> is a	--> Field type
  (11,	100,	3),	-- Boolean field	--> is a	--> Field type
  (14,	100,	1),	-- Folder type	--> is a	--> Type
  (15,	100,	1),	-- Relationship	--> is a	--> Type
  (100,	100,	15),	-- is a	--> is a	--> Relationship
  (101,	100,	15),	-- Related to	--> is a	--> Relationship
  (102,	100,	15),	-- has a	--> is a	--> Relationship
  (103,	100,	15),	-- has qualifier	--> is a	--> Relationship
  (500,	100,	14),	-- Information model	--> is a	--> Folder type
  (502,	100,	14),	-- Attributes and Relationships	--> is a	--> Folder type
  (504,	100,	14),	-- Care administration entries	--> is a	--> Folder type
  (505,	100,	14),	-- Clinical record entries	--> is a	--> Folder type
  (506,	100,	14),	-- Care process entries	--> is a	--> Folder type
  (507,	100,	14),	-- Health workers organisations and other entities	--> is a	--> Folder type
  (510,	100,	14),	-- Record structures	--> is a	--> Folder type
  (512,	100,	14),	-- Specialised record types	--> is a	--> Folder type
  (513,	100,	14),	-- Information model support structures	--> is a	--> Folder type
  (514,	100,	14),	-- Type list	--> is a	--> Folder type
  (515,	100,	14),	-- Relationships	--> is a	--> Folder type
  (516,	100,	14),	-- Attribute types	--> is a	--> Folder type
  (1000,	100,	2),	-- Health record event	--> is a	--> Record Type
  (1001,	100,	2),	-- Patient master demographics	--> is a	--> Record Type
  (1002,	100,	2),	-- Practitioner in role	--> is a	--> Record Type
  (1003,	100,	2),	-- Device	--> is a	--> Record Type
  (1004,	100,	2),	-- Organisation service or department	--> is a	--> Record Type
  (1005,	100,	2),	-- Location	--> is a	--> Record Type
  (1006,	100,	2),	-- Care episode	--> is a	--> Record Type
  (1007,	100,	2),	-- Care episode administration	--> is a	--> Record Type
  (1008,	100,	2),	-- Encounter	--> is a	--> Record Type
  (1010,	100,	2),	-- Referral request	--> is a	--> Record Type
  (1011,	100,	2),	-- Procedure or test request	--> is a	--> Record Type
  (1012,	100,	2),	-- Appointment schedule	--> is a	--> Record Type
  (1013,	100,	2),	-- Appointment booking history	--> is a	--> Record Type
  (1014,	100,	2),	-- Appointment slot	--> is a	--> Record Type
  (1015,	100,	2),	-- Appointment attendance	--> is a	--> Record Type
  (1016,	100,	2),	-- Care plan	--> is a	--> Record Type
  (1018,	100,	2),	-- Observation	--> is a	--> Record Type
  (1019,	100,	2),	-- Numeric observation	--> is a	--> Record Type
  (1020,	100,	2),	-- Procedure	--> is a	--> Record Type
  (1021,	100,	2),	-- Immunisation	--> is a	--> Record Type
  (1022,	100,	2),	-- Allergy and adverse reaction	--> is a	--> Record Type
  (1023,	100,	2),	-- Problem	--> is a	--> Record Type
  (1024,	100,	2),	-- Medication statement	--> is a	--> Record Type
  (1025,	100,	2),	-- Medication order or issue	--> is a	--> Record Type
  (1026,	100,	2),	-- Flag or Alert	--> is a	--> Record Type
  (1027,	100,	2),	-- Consent	--> is a	--> Record Type
  (1028,	100,	2),	-- Patient organisational demographics	--> is a	--> Record Type
  (1029,	100,	2),	-- Person name	--> is a	--> Record Type
  (1030,	100,	2),	-- Address	--> is a	--> Record Type
  (1031,	100,	2),	-- Contact	--> is a	--> Record Type
  (1032,	100,	2),	-- Related person	--> is a	--> Record Type
  (1033,	100,	2),	-- Post code linked data	--> is a	--> Record Type
  (1034,	100,	2),	-- Person in role	--> is a	--> Record Type
  (1035,	100,	2),	-- Identifier	--> is a	--> Record Type
  (1036,	100,	2),	-- Quantity time	--> is a	--> Record Type
  (1037,	100,	2),	-- Quantity medication	--> is a	--> Record Type
  (1038,	100,	2),	-- Quantity measure	--> is a	--> Record Type
  (1039,	100,	2),	-- Range numeric	--> is a	--> Record Type
  (5000,	100,	9),	-- Date and time entry recorded	--> is a	--> Date time field
  (5001,	100,	2),	-- Recorded by	--> is a	--> Record Type
  (5002,	100,	2),	-- Responsible practitioner	--> is a	--> Record Type
  (5003,	100,	9),	-- Effective date and time	--> is a	--> Date time field
  (5004,	100,	2),	-- Patient or service user	--> is a	--> Record Type
  (5005,	100,	2),	-- Owning organisation	--> is a	--> Record Type
  (5006,	100,	10),	-- Pseudonymised patient id	--> is a	--> Text field
  (5007,	100,	10),	-- NHS number	--> is a	--> Text field
  (5008,	100,	2),	-- Name	--> is a	--> Record Type
  (5009,	100,	10),	-- Title	--> is a	--> Text field
  (5010,	100,	10),	-- First name(s)	--> is a	--> Text field
  (5011,	100,	10),	-- Middle names	--> is a	--> Text field
  (5012,	100,	10),	-- Last name	--> is a	--> Text field
  (5013,	100,	5),	-- Gender (administrative)	--> is a	--> Code Field
  (5014,	100,	9),	-- Date of birth	--> is a	--> Date time field
  (5015,	100,	9),	-- Pseudonymised date of birth	--> is a	--> Date time field
  (5016,	100,	8),	-- Age	--> is a	--> Numeric field
  (5017,	100,	11),	-- Death indicator	--> is a	--> Boolean field
  (5018,	100,	9),	-- Date of death	--> is a	--> Date time field
  (5019,	100,	2),	-- Patient identifiers	--> is a	--> Record Type
  (5020,	100,	5),	-- Identifier scheme	--> is a	--> Code Field
  (5021,	100,	10),	-- Identifier value	--> is a	--> Text field
  (5022,	100,	10),	-- Pseudonymised address	--> is a	--> Text field
  (5023,	100,	5),	-- Address type	--> is a	--> Code Field
  (5024,	100,	10),	-- Address line 1	--> is a	--> Text field
  (5025,	100,	10),	-- Address line 2	--> is a	--> Text field
  (5026,	100,	10),	-- Locality	--> is a	--> Text field
  (5027,	100,	10),	-- City	--> is a	--> Text field
  (5028,	100,	10),	-- Address line 5	--> is a	--> Text field
  (5029,	100,	10),	-- Post code	--> is a	--> Text field
  (5030,	100,	10),	-- UPRN	--> is a	--> Text field
  (5031,	100,	10),	-- Lower super output area	--> is a	--> Text field
  (5032,	100,	10),	-- Middle super output area	--> is a	--> Text field
  (5033,	100,	2),	-- Contact information	--> is a	--> Record Type
  (5034,	100,	5),	-- Contact type	--> is a	--> Code Field
  (5035,	100,	10),	-- Contact value	--> is a	--> Text field
  (5036,	100,	5),	-- Ethnicity	--> is a	--> Code Field
  (5037,	100,	5),	-- Language	--> is a	--> Code Field
  (5038,	100,	5),	-- Confidentiality type	--> is a	--> Code Field
  (5039,	100,	2),	-- Related persons	--> is a	--> Record Type
  (5040,	100,	10),	-- Previous last name	--> is a	--> Text field
  (5041,	100,	10),	-- Index of multiple deprivation	--> is a	--> Text field
  (5042,	100,	10),	-- Active status	--> is a	--> Text field
  (5043,	100,	2),	-- Service or organisation	--> is a	--> Record Type
  (5044,	100,	5),	-- Role type	--> is a	--> Code Field
  (5045,	100,	5),	-- Speciality	--> is a	--> Code Field
  (5046,	100,	9),	-- Contract start date	--> is a	--> Date time field
  (5047,	100,	9),	-- Contract end date	--> is a	--> Date time field
  (5048,	100,	2),	-- Related person information	--> is a	--> Record Type
  (5049,	100,	5),	-- Related person relationship	--> is a	--> Code Field
  (5050,	100,	2),	-- Related patient	--> is a	--> Record Type
  (5051,	100,	10),	-- Device name	--> is a	--> Text field
  (5052,	100,	10),	-- Human readable UDI	--> is a	--> Text field
  (5053,	100,	10),	-- Machine readable UDI	--> is a	--> Text field
  (5054,	100,	10),	-- Serial number	--> is a	--> Text field
  (5055,	100,	10),	-- Manufacturer	--> is a	--> Text field
  (5056,	100,	5),	-- Device type	--> is a	--> Code Field
  (5057,	100,	10),	-- Device version	--> is a	--> Text field
  (5058,	100,	2),	-- Organisational identifier	--> is a	--> Record Type
  (5059,	100,	10),	-- Organisation/ service name	--> is a	--> Text field
  (5060,	100,	5),	-- Organisaion/ service category	--> is a	--> Code Field
  (5062,	100,	5),	-- Location type	--> is a	--> Code Field
  (5063,	100,	5),	-- Consent type	--> is a	--> Code Field
  (5064,	100,	5),	-- Consent or Dissent	--> is a	--> Code Field
  (5065,	100,	9),	-- End date and time	--> is a	--> Date time field
  (5066,	100,	2),	-- Consent target	--> is a	--> Record Type
  (5067,	100,	5),	-- Nature of care episode	--> is a	--> Code Field
  (5068,	100,	2),	-- Initiating referral	--> is a	--> Record Type
  (5069,	100,	2),	-- Episode administration process linked	--> is a	--> Record Type
  (5070,	100,	2),	-- Linked entries	--> is a	--> Record Type
  (5071,	100,	5),	-- Episode administration status	--> is a	--> Code Field
  (5072,	100,	5),	-- Episode admin status subtype	--> is a	--> Code Field
  (5073,	100,	5),	-- Patient episode administration type	--> is a	--> Code Field
  (5074,	100,	2),	-- Linked care episode	--> is a	--> Record Type
  (5078,	100,	5),	-- Completion status	--> is a	--> Code Field
  (5079,	100,	2),	-- Duration	--> is a	--> Record Type
  (5080,	100,	2),	-- Travel time	--> is a	--> Record Type
  (5081,	100,	5),	-- Reason for encounter	--> is a	--> Code Field
  (5082,	100,	10),	-- Reason text	--> is a	--> Text field
  (5083,	100,	2),	-- Linked appointment	--> is a	--> Record Type
  (5084,	100,	2),	-- Parent encounter	--> is a	--> Record Type
  (5085,	100,	2),	-- Child encounter	--> is a	--> Record Type
  (5086,	100,	2),	-- Additional practitioners	--> is a	--> Record Type
  (5090,	100,	2),	-- Destination location	--> is a	--> Record Type
  (5092,	100,	5),	-- Priority	--> is a	--> Code Field
  (5093,	100,	5),	-- Referred by type	--> is a	--> Code Field
  (5094,	100,	2),	-- Source organisation	--> is a	--> Record Type
  (5095,	100,	5),	-- Service type requested	--> is a	--> Code Field
  (5096,	100,	5),	-- Speciality requested	--> is a	--> Code Field
  (5097,	100,	5),	-- Referral reason 	--> is a	--> Code Field
  (5098,	100,	2),	-- Recipient service or clinic	--> is a	--> Record Type
  (5099,	100,	2),	-- Recipient location	--> is a	--> Record Type
  (5100,	100,	2),	-- Recipent practitioner	--> is a	--> Record Type
  (5101,	100,	10),	-- Referral UBRN	--> is a	--> Text field
  (5102,	100,	5),	-- Referral mode	--> is a	--> Code Field
  (5103,	100,	5),	-- Requested procedure	--> is a	--> Code Field
  (5104,	100,	5),	-- Reason for procedure request	--> is a	--> Code Field
  (5105,	100,	10),	-- Reason for request - text	--> is a	--> Text field
  (5106,	100,	10),	-- Request identifier	--> is a	--> Text field
  (5107,	100,	2),	-- Linked encounter	--> is a	--> Record Type
  (5109,	100,	5),	-- Type of schedule	--> is a	--> Code Field
  (5110,	100,	10),	-- Schedule description	--> is a	--> Text field
  (5112,	100,	9),	-- Start Date and Time	--> is a	--> Date time field
  (5113,	100,	2),	-- Linked appointment slots	--> is a	--> Record Type
  (5114,	100,	2),	-- Practitioners	--> is a	--> Record Type
  (5115,	100,	5),	-- Appointment category	--> is a	--> Code Field
  (5116,	100,	5),	-- Planned reason	--> is a	--> Code Field
  (5117,	100,	10),	-- Planned reason text	--> is a	--> Text field
  (5118,	100,	10),	-- Description	--> is a	--> Text field
  (5119,	100,	2),	-- Planned duration	--> is a	--> Record Type
  (5120,	100,	9),	-- Start time	--> is a	--> Date time field
  (5121,	100,	9),	-- End time	--> is a	--> Date time field
  (5122,	100,	5),	-- Slot booking status	--> is a	--> Code Field
  (5123,	100,	5),	-- Attendance status	--> is a	--> Code Field
  (5124,	100,	5),	-- Booking urgency	--> is a	--> Code Field
  (5125,	100,	2),	-- Linked schedule	--> is a	--> Record Type
  (5126,	100,	2),	-- Booking history	--> is a	--> Record Type
  (5127,	100,	5),	-- Booking or cancellation	--> is a	--> Code Field
  (5128,	100,	2),	-- Patient expressed reason	--> is a	--> Record Type
  (5129,	100,	2),	-- Linked appointment slot	--> is a	--> Record Type
  (5130,	100,	5),	-- Document status	--> is a	--> Code Field
  (5131,	100,	2),	-- Type of plan	--> is a	--> Record Type
  (5132,	100,	2),	-- Linked activities	--> is a	--> Record Type
  (5133,	100,	2),	-- Linked episodes	--> is a	--> Record Type
  (5134,	100,	2),	-- Parent plan	--> is a	--> Record Type
  (5135,	100,	2),	-- Associated practitioners	--> is a	--> Record Type
  (5136,	100,	2),	-- Associated teams	--> is a	--> Record Type
  (5137,	100,	10),	-- Team name	--> is a	--> Text field
  (5138,	100,	2),	-- Team members	--> is a	--> Record Type
  (5139,	100,	2),	-- Heading	--> is a	--> Record Type
  (5142,	100,	2),	-- Order	--> is a	--> Record Type
  (5143,	100,	2),	-- Linked care plan	--> is a	--> Record Type
  (5144,	100,	2),	-- Observation type	--> is a	--> Record Type
  (5145,	100,	2),	-- Observation concept	--> is a	--> Record Type
  (5146,	100,	2),	-- Context	--> is a	--> Record Type
  (5147,	100,	2),	-- Is problem	--> is a	--> Record Type
  (5148,	100,	2),	-- Problem episode	--> is a	--> Record Type
  (5149,	100,	2),	-- Normality	--> is a	--> Record Type
  (5150,	100,	2),	-- Linked problems	--> is a	--> Record Type
  (5151,	100,	2),	-- Child observations	--> is a	--> Record Type
  (5152,	100,	2),	-- Parent observation	--> is a	--> Record Type
  (5154,	100,	2),	-- Flag	--> is a	--> Record Type
  (5155,	100,	2),	-- Operator	--> is a	--> Record Type
  (5156,	100,	2),	-- Numeric value	--> is a	--> Record Type
  (5157,	100,	2),	-- Reference range	--> is a	--> Record Type
  (5158,	100,	2),	-- Linked ranges	--> is a	--> Record Type
  (5159,	100,	2),	-- Units of measure	--> is a	--> Record Type
  (5160,	100,	2),	-- Performed period	--> is a	--> Record Type
  (5161,	100,	2),	-- Outcome	--> is a	--> Record Type
  (5162,	100,	2),	-- Outcome text	--> is a	--> Record Type
  (5163,	100,	2),	-- Complications	--> is a	--> Record Type
  (5164,	100,	2),	-- Follow ups	--> is a	--> Record Type
  (5165,	100,	2),	-- Devices used	--> is a	--> Record Type
  (5166,	100,	2),	-- Flag category	--> is a	--> Record Type
  (5167,	100,	2),	-- Flag type	--> is a	--> Record Type
  (5168,	100,	2),	-- Flag text	--> is a	--> Record Type
  (5169,	100,	2),	-- Substance	--> is a	--> Record Type
  (5170,	100,	2),	-- Manifestation	--> is a	--> Record Type
  (5171,	100,	2),	-- Manifestation description	--> is a	--> Record Type
  (5172,	100,	2),	-- Batch number	--> is a	--> Record Type
  (5173,	100,	2),	-- Expiry date	--> is a	--> Record Type
  (5174,	100,	2),	-- Vaccine product	--> is a	--> Record Type
  (5175,	100,	2),	-- Vaccine dose sequence	--> is a	--> Record Type
  (5176,	100,	2),	-- Vaccine doses required	--> is a	--> Record Type
  (5177,	100,	2),	-- Reaction	--> is a	--> Record Type
  (5178,	100,	2),	-- Problem type	--> is a	--> Record Type
  (5179,	100,	2),	-- Significance	--> is a	--> Record Type
  (5180,	100,	2),	-- Expected duration	--> is a	--> Record Type
  (5181,	100,	2),	-- Parent problem	--> is a	--> Record Type
  (5182,	100,	2),	-- Child problems	--> is a	--> Record Type
  (5183,	100,	2),	-- Medication	--> is a	--> Record Type
  (5184,	100,	2),	-- Dosage structured	--> is a	--> Record Type
  (5185,	100,	2),	-- Dosage text	--> is a	--> Record Type
  (5186,	100,	2),	-- Quantity of medicine	--> is a	--> Record Type
  (5187,	100,	2),	-- Number of authorised repeats	--> is a	--> Record Type
  (5188,	100,	2),	-- Review date	--> is a	--> Record Type
  (5189,	100,	2),	-- Order duration	--> is a	--> Record Type
  (5190,	100,	2),	-- Additional patient instructions	--> is a	--> Record Type
  (5191,	100,	2),	-- Pharmacy instruction	--> is a	--> Record Type
  (5192,	100,	2),	-- Treatment management responsibility	--> is a	--> Record Type
  (5193,	100,	2),	-- Originating health domain	--> is a	--> Record Type
  (5194,	100,	2),	-- Reason for ending medication	--> is a	--> Record Type
  (5195,	100,	2),	-- Linked medication orders	--> is a	--> Record Type
  (5196,	100,	2),	-- Flags	--> is a	--> Record Type
  (5197,	100,	2),	-- Course type	--> is a	--> Record Type
  (5198,	100,	2),	-- Planned date	--> is a	--> Record Type
  (5200,	100,	2),	-- Units of time	--> is a	--> Record Type
  (5201,	100,	2),	-- Healthcare service type	--> is a	--> Record Type
  (5202,	100,	2),	-- Interaction mode	--> is a	--> Record Type
  (5203,	100,	2),	-- Administrative action	--> is a	--> Record Type
  (5204,	100,	2),	-- General purpose	--> is a	--> Record Type
  (5205,	100,	2),	-- Location	--> is a	--> Record Type
  (5206,	100,	5),	-- Disposition	--> is a	--> Code Field
  (5207,	100,	5),	-- Site of care type	--> is a	--> Code Field
  (5208,	100,	5),	-- Patient status	--> is a	--> Code Field
  (5209,	100,	5),	-- Address format type	--> is a	--> Code Field
  (5210,	100,	10),	-- Address line 3	--> is a	--> Text field
  (5211,	100,	10),	-- Address line 4	--> is a	--> Text field
  (5212,	100,	8)	-- Minimum occurrences	--> is a	--> Numeric field
;

INSERT INTO table_id (name, id) SELECT 'BaseConcept', MAX(id) FROM concept WHERE id < 100;
INSERT INTO table_id (name, id) SELECT 'Relationship', MAX(id) FROM concept WHERE id < 500;
INSERT INTO table_id (name, id) SELECT 'Folder', MAX(id) FROM concept WHERE id < 1000;
INSERT INTO table_id (name, id) SELECT 'RecordType', MAX(id) FROM concept WHERE id < 1000000;
INSERT INTO table_id (name, id) VALUES ('CodeableConcept', 1000000);

INSERT INTO code_system
  (id, name)
VALUES
  (1, 'SNOMED-CT');