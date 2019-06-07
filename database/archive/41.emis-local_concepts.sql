INSERT INTO document (iri) VALUES ('http://DiscoveryDataService/InformationModel/dm/EMIS_LOCAL/1.0.0');
SELECT @doc:=LAST_INSERT_ID();

INSERT INTO concept (document, id)
VALUES (@doc, 'EMIS_LOCAL');

SELECT @id:=LAST_INSERT_ID();

INSERT INTO concept_property_data
(dbid, property, value)
VALUES
(@id, get_dbid('name'), 'EMIS_LOCAL'),
(@id, get_dbid('description'), 'The EMIS Local code scheme');

INSERT INTO concept_property_object
(dbid, property, value)
VALUES
(@id, get_dbid('is_subtype_of'), get_dbid('CodeScheme'));

INSERT INTO concept (document, id)
SELECT distinct @doc, concat('EMLOC_',local_code)
FROM emis_local_codes;

INSERT INTO concept_property_data
(dbid, property, value)
SELECT get_dbid(concat('EMLOC_',local_code)), get_dbid('name'), if(length(local_term) > 60, concat(left(local_term, 57), '...'), local_term) FROM emis_local_codes GROUP BY local_code
UNION SELECT get_dbid(concat('EMLOC_',local_code)), get_dbid('description'), local_term FROM emis_local_codes GROUP BY local_code
UNION SELECT get_dbid(concat('EMLOC_',local_code)), get_dbid('code'), local_code FROM emis_local_codes GROUP BY local_code;

INSERT INTO concept_property_object
(dbid, property, value)
SELECT get_dbid(concat('EMLOC_',local_code)), get_dbid('code_scheme'), get_dbid('EMIS_LOCAL') FROM emis_local_codes GROUP BY local_code
UNION SELECT get_dbid(concat('EMLOC_',local_code)), get_dbid('is_subtype_of'), get_dbid('CodeableConcept') FROM emis_local_codes GROUP BY local_code;
