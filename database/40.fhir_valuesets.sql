SELECT @max := MAX(dbid)+ 1 FROM concept;
SET @qry = concat('ALTER TABLE concept AUTO_INCREMENT = ', @max);
PREPARE stmt FROM @qry;
EXECUTE stmt;

DROP TABLE IF EXISTS fhir_scheme;
CREATE TABLE fhir_scheme (
    id VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS fhir_scheme_value;
CREATE TABLE fhir_scheme_value
(
    scheme VARCHAR(50)  NOT NULL,
    code   VARCHAR(20) COLLATE utf8_bin,
    term   VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Define the schemes

INSERT INTO fhir_scheme
(id, name)
VALUES
    ('FHIR_AG', 'FHIR Administrative Gender'),
    ('FHIR_EC', 'FHIR Ethnic Category'),
    ('FHIR_RT', 'FHIR Registration Type'),
    ('FHIR_RS', 'FHIR Registration Status'),
    ('FHIR_AS', 'FHIR Appointment Status'),
    ('FHIR_MSAT', 'FHIR Medication statement authorisation type'),
    ('FHIR_PRS', 'FHIR Procedure request status'),
    ('FHIR_RFP', 'FHIR Referral priority'),
    ('FHIR_RFT', 'FHIR Referral type')
;

-- Create the scheme values

INSERT INTO fhir_scheme_value
(scheme, code, term)
VALUES
    ('FHIR_AG', 'male', 'Male'),
    ('FHIR_AG', 'female', 'Female'),
    ('FHIR_AG', 'other', 'Other'),
    ('FHIR_AG', 'unknown', 'Unknown'),

    ('FHIR_EC', 'A', 'British'),
    ('FHIR_EC', 'B', 'Irish'),
    ('FHIR_EC', 'C', 'Any other White background'),
    ('FHIR_EC', 'D', 'White and Black Caribbean'),
    ('FHIR_EC', 'E', 'White and Black African'),
    ('FHIR_EC', 'F', 'White and Asian'),
    ('FHIR_EC', 'G', 'Any other mixed background'),
    ('FHIR_EC', 'H', 'Indian'),
    ('FHIR_EC', 'J', 'Pakistani'),
    ('FHIR_EC', 'K', 'Bangladeshi'),
    ('FHIR_EC', 'L', 'Any other Asian background'),
    ('FHIR_EC', 'M', 'Caribbean'),
    ('FHIR_EC', 'N', 'African'),
    ('FHIR_EC', 'P', 'Any other Black baground'),
    ('FHIR_EC', 'R', 'Chinese'),
    ('FHIR_EC', 'S', 'Any other ethnic group'),
    ('FHIR_EC', 'Z', 'Not stated'),

    ('FHIR_RT', 'E', 'Emergency'),
    ('FHIR_RT', 'IN', 'Immediately Necessary'),
    ('FHIR_RT', 'R', 'Regular/GMS'),
    ('FHIR_RT', 'T', 'Temporary'),
    ('FHIR_RT', 'P', 'Private'),
    ('FHIR_RT', 'O', 'Other'),
    ('FHIR_RT', 'D', 'Dummy/Synthetic'),
    ('FHIR_RT', 'C', 'Community'),
    ('FHIR_RT', 'W', 'Walk-In'),
    ('FHIR_RT', 'MS', 'Minor Surgery'),
    ('FHIR_RT', 'CHS', 'Child Health Services'),
    ('FHIR_RT', 'N', 'Contraceptive Services'),
    ('FHIR_RT', 'Y', 'Yellow Fever'),
    ('FHIR_RT', 'M', 'Maternity Services'),
    ('FHIR_RT', 'PR', 'Pre-Registration'),
    ('FHIR_RT', 'SH', 'Sexual Health'),
    ('FHIR_RT', 'V', 'Vasectomy'),
    ('FHIR_RT', 'OH', 'Out of Hours'),

    ('FHIR_RS', 'PR1', 'Patient has presented'),
    ('FHIR_RS', 'PR2', 'Medical card received'),
    ('FHIR_RS', 'PR3', 'Application Form FP1 submitted'),
    ('FHIR_RS', 'R1', 'Registered'),
    ('FHIR_RS', 'R2', 'Medical record sent by FHSA'),
    ('FHIR_RS', 'R3', 'Record Received'),
    ('FHIR_RS', 'R4', 'Left practice. Still registered'),
    ('FHIR_RS', 'R5', 'Correctly registered'),
    ('FHIR_RS', 'R6', 'Short stay'),
    ('FHIR_RS', 'R7', 'Long stay'),
    ('FHIR_RS', 'R8', 'Services'),
    ('FHIR_RS', 'R9', 'Service dependant'),
    ('FHIR_RS', 'D1', 'Death'),
    ('FHIR_RS', 'D2', 'Dead (Practice notification)'),
    ('FHIR_RS', 'D3', 'Record Requested by FHSA'),
    ('FHIR_RS', 'D4', 'Removal to New HA/HB'),
    ('FHIR_RS', 'D5', 'Internal transfer'),
    ('FHIR_RS', 'D6', 'Mental hospital'),
    ('FHIR_RS', 'D7', 'Embarkation'),
    ('FHIR_RS', 'D8', 'New HA/HB - same GP'),
    ('FHIR_RS', 'D9', 'Adopted child'),
    ('FHIR_RS', 'R10', 'Removal from Residential Institute'),
    ('FHIR_RS', 'D10', 'Deduction at GPs request'),
    ('FHIR_RS', 'D11', 'Registration cancelled'),
    ('FHIR_RS', 'D12', 'Deduction at patients request'),
    ('FHIR_RS', 'D13', 'Other reason'),
    ('FHIR_RS', 'D14', 'Returned undelivered'),
    ('FHIR_RS', 'D15', 'Internal transfer - address change'),
    ('FHIR_RS', 'D16', 'Internal transfer within partnership'),
    ('FHIR_RS', 'D17', 'Correspondence states \'gone away\''),
    ('FHIR_RS', 'D18', 'Practice advise outside of area'),
    ('FHIR_RS', 'D19', 'Practice advise patient no longer resident'),
    ('FHIR_RS', 'D20', 'Practice advise removal via screening system'),
    ('FHIR_RS', 'D21', 'Practice advise removal via vaccination data'),
    ('FHIR_RS', 'D22', 'Records sent back to FHSA'),
    ('FHIR_RS', 'D23', 'Records received by FHSA'),
    ('FHIR_RS', 'D24', 'Registration expored'),

    ('FHIR_AS', 'proposed', 'Proposed'),
    ('FHIR_AS', 'pending', 'Pending'),
    ('FHIR_AS', 'booked', 'Booked'),
    ('FHIR_AS', 'arrived', 'Arrived'),
    ('FHIR_AS', 'fulfilled', 'Fulfilled'),
    ('FHIR_AS', 'cancelled', 'Cancelled'),
    ('FHIR_AS', 'noshow', 'No Show'),

    ('FHIR_MSAT', 'acute', 'Acute'),
    ('FHIR_MSAT', 'repeat', 'Repeat'),
    ('FHIR_MSAT', 'repeatDispensing', 'Repeat dispensing'),
    ('FHIR_MSAT', 'automatic', 'Automatic'),

    ('FHIR_PRS', 'proposed', 'Proposed'),
    ('FHIR_PRS', 'draft', 'Draft'),
    ('FHIR_PRS', 'requested', 'Requested'),
    ('FHIR_PRS', 'received', 'Received'),
    ('FHIR_PRS', 'accepted', 'Accepted'),
    ('FHIR_PRS', 'in-progress', 'In Progress'),
    ('FHIR_PRS', 'completed', 'Completed'),
    ('FHIR_PRS', 'suspended', 'Suspended'),
    ('FHIR_PRS', 'rejected', 'Rejected'),
    ('FHIR_PRS', 'aborted', 'Aborted'),


    ('FHIR_RFP', '0', 'Routine'),
    ('FHIR_RFP', '1', 'Urgent'),
    ('FHIR_RFP', '2', 'Two week wait'),
    ('FHIR_RFP', '3', 'Soon'),

    ('FHIR_RFT', 'A', 'Assessment'),
    ('FHIR_RFT', 'C', 'Community care'),
    ('FHIR_RFT', 'D', 'Day care'),
    ('FHIR_RFT', 'E', 'Assessment & Education'),
    ('FHIR_RFT', 'I', 'Investigation'),
    ('FHIR_RFT', 'M', 'Management advice'),
    ('FHIR_RFT', 'N', 'Admission'),
    ('FHIR_RFT', 'O', 'Outpatient'),
    ('FHIR_RFT', 'P', 'Performance of a procedure/operation'),
    ('FHIR_RFT', 'R', 'Patient assurance'),
    ('FHIR_RFT', 'S', 'Self referral'),
    ('FHIR_RFT', 'T', 'Treatment'),
    ('FHIR_RFT', 'U', 'Unknown');

-- Create the document

INSERT INTO document
(data)
VALUES (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/FHIR/1.0.0'));

-- Create the code schemes
INSERT INTO concept
(data)
SELECT JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/FHIR/1.0.0',
                   'id', id,
                   'name', name,
                   'description', name,
                   'is_subtype_of', JSON_OBJECT(
                           'id', 'CodeScheme'
                       ))
FROM fhir_scheme;

-- Create the core concept equivalents

EXECUTE stmt;

INSERT INTO concept
(data)
SELECT JSON_OBJECT(
    'document', 'http://DiscoveryDataService/InformationModel/dm/core/1.0.1',
    'id', concat('DS_', scheme, '_', code),
    'name', term,
    'description', term,
    'is_subtype_of', JSON_OBJECT(
        'id', 'CodeableConcept'
    )
)
FROM fhir_scheme_value;

EXECUTE stmt;

-- Create the (mapped) fhir entries
INSERT INTO concept
(data)
    SELECT JSON_OBJECT(
        'document', 'http://DiscoveryDataService/InformationModel/dm/FHIR/1.0.1',
        'id', concat(scheme, '_', code),
        'name', term,
        'description', term,
        'code_scheme', scheme,
        'code', code,
        'is_subtype_of', JSON_OBJECT(
                'id', 'CodeableConcept'
            ),
        'is_equivalent_to', JSON_OBJECT(
                'id', concat('DS_', scheme, '_', code)
            )
    )
    FROM fhir_scheme_value;


EXECUTE stmt;

DEALLOCATE PREPARE stmt;
