-- Create document
INSERT INTO document
(iri)
VALUES
('http://DiscoveryDataService/InformationModel/dm/OPCS4/1.0.0');

SELECT @doc := LAST_INSERT_ID();

-- Code Scheme
INSERT INTO concept
(document, id)
VALUES
(@doc, 'OPCS4');

SELECT @id := LAST_INSERT_ID();

INSERT INTO concept_property_data
(dbid, property, value)
VALUES
(@id, get_dbid('name'), 'OPCS4'),
(@id, get_dbid('description'), 'The OPCS4 code scheme');

INSERT INTO concept_property_object
(dbid, property, value)
VALUES
(@id, get_dbid('is_subtype_of'), get_dbid('CodeScheme'));

-- CONCEPTS
INSERT INTO concept
(document, id)
SELECT @doc, concat('O4_',code)
FROM opcs4;

INSERT INTO concept_property_data
(dbid, property, value)
SELECT get_dbid(concat('O4_',code)), get_dbid('name'), if(length(description) > 60, concat(left(description, 57), '...'), description) FROM opcs4
UNION SELECT get_dbid(concat('O4_',code)), get_dbid('description'), description FROM opcs4
UNION SELECT get_dbid(concat('O4_',code)), get_dbid('code'), code FROM opcs4
;

INSERT INTO concept_property_object
(dbid, property, value)
SELECT get_dbid(concat('O4_',code)), get_dbid('code_scheme'), get_dbid('OPCS4') FROM opcs4
UNION SELECT get_dbid(concat('O4_',code)), get_dbid('is_subtype_of'), get_dbid('CodeableConcept') FROM opcs4;
