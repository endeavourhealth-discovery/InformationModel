-- Create document
INSERT INTO document
(iri)
VALUES
('http://DiscoveryDataService/InformationModel/dm/ICD10/1.0.0');

SELECT @doc := LAST_INSERT_ID();

DROP TABLE IF EXISTS icd10_tmp;

CREATE TABLE icd10_tmp (
    id VARCHAR(50) COLLATE utf8_bin NOT NULL,
    name VARCHAR(200) NOT NULL,
    `desc` VARCHAR(400),
    type VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO icd10_tmp
(id, name, `desc`, type)
VALUES
('ICD10', 'ICD10', 'The ICD10 code scheme', 'CodeScheme'),
('I10_modifier4', 'IDC10 4th character modifier suffix', null, 'CodeableConcept'),
('I10_modifier5', 'IDC10 5th character modifier suffix', null, 'CodeableConcept'),
('I10_qualifiers', 'IDC10 dual classification (asterisk codes)', null, 'CodeableConcept'),
('I10_gender_mask', 'IDC10 gender mask', null, 'CodeableConcept'),
('I10_min_age', 'IDC10 minimum age', null, 'CodeableConcept'),
('I10_max_age', 'IDC10 maximum age', null, 'CodeableConcept'),
('I10_tree_description', 'IDC10 tree description', null, 'CodeableConcept')
;

-- Pre-allocate concept DBIds
INSERT INTO concept
(document, id)
SELECT @doc, id
FROM icd10_tmp;

INSERT INTO concept_property_data
(dbid, property, value)
SELECT get_dbid(id), get_dbid('name'), name FROM icd10_tmp
UNION SELECT get_dbid(id), get_dbid('description'), `desc` FROM icd10_tmp WHERE `desc` IS NOT NULL;

INSERT INTO concept_property_object
(dbid, property, value)
SELECT get_dbid(id), get_dbid('is_subtype_of'), get_dbid(type) FROM icd10_tmp;

-- CONCEPTS
-- Pre-allocate concept DBIds
INSERT INTO concept
(document, id)
SELECT @doc, concat('I10_', code)
FROM icd10;

INSERT INTO concept_property_data
(dbid, property, value)
SELECT get_dbid(concat('I10_', code)), get_dbid('name'), if(length(description) > 60, concat(left(description, 57), '...'), description) FROM icd10
UNION SELECT get_dbid(concat('I10_', code)), get_dbid('description'), description FROM icd10
UNION SELECT get_dbid(concat('I10_', code)), get_dbid('code'), code FROM icd10
UNION SELECT get_dbid(concat('I10_', code)), get_dbid('I10_modifier4'), modifier_4 FROM icd10 WHERE modifier_4 IS NOT NULL
UNION SELECT get_dbid(concat('I10_', code)), get_dbid('I10_modifier5'), modifier_5 FROM icd10 WHERE modifier_5 IS NOT NULL
UNION SELECT get_dbid(concat('I10_', code)), get_dbid('I10_gender_mask'), gender_mask FROM icd10 WHERE gender_mask IS NOT NULL
UNION SELECT get_dbid(concat('I10_', code)), get_dbid('I10_min_age'), min_age FROM icd10 WHERE min_age IS NOT NULL
UNION SELECT get_dbid(concat('I10_', code)), get_dbid('I10_max_age'), max_age FROM icd10 WHERE max_age IS NOT NULL
UNION SELECT get_dbid(concat('I10_', code)), get_dbid('I10_tree_description'), tree_description FROM icd10 WHERE tree_description IS NOT NULL
;

INSERT INTO concept_property_object
(dbid, property, value)
SELECT get_dbid(concat('I10_', code)), get_dbid('is_subtype_of'), get_dbid('CodeableConcept') FROM icd10
UNION SELECT get_dbid(concat('I10_', code)), get_dbid('code_scheme'), get_dbid('ICD10') FROM icd10;

-- Qualifiers - NO PIVOT FUNCTIONS IN MYSQL!!!

DROP PROCEDURE IF EXISTS populate_icd10_qualifiers;

DELIMITER //
CREATE PROCEDURE populate_icd10_qualifiers()
BEGIN
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE icode VARCHAR(10);
    DECLARE qlist VARCHAR(400) DEFAULT '';
    DECLARE qual VARCHAR(10) DEFAULT '';


    DECLARE qual_cursor CURSOR FOR
        SELECT code, qualifiers
        FROM icd10
        WHERE qualifiers <> '';

    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET finished = 1;

    OPEN qual_cursor;

    get_qual: LOOP
        FETCH qual_cursor INTO icode, qlist;
        IF finished = 1 THEN LEAVE get_qual; END IF;

        split: LOOP
            IF LENGTH(qlist) = 0 THEN LEAVE split; END IF;
            SET qual = SUBSTRING_INDEX(qlist, '^', 1);
            SET qlist = SUBSTRING(qlist, LENGTH(qual) + 2);

            INSERT INTO concept_property_object
            (dbid, `group`, property, value)
            VALUES
            (get_dbid(CONCAT('I10_', icode)), 1, get_dbid('I10_qualifiers'), get_dbid(CONCAT('I10_', qual)));

        END LOOP split;

    END LOOP get_qual;
    CLOSE qual_cursor;
END; //

DELIMITER ;

CALL populate_icd10_qualifiers();

DROP PROCEDURE IF EXISTS populate_icd10_qualifiers;
