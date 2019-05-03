-- Create document
INSERT INTO document
(iri)
VALUES
('http://DiscoveryDataService/InformationModel/dm/BartsCerner/1.0.0');

SELECT @doc := LAST_INSERT_ID();

-- Code Scheme
INSERT INTO concept
(document, id)
VALUES
(@doc, 'BartsCerner');

SELECT @id := LAST_INSERT_ID();

-- CODE SCHEME
INSERT INTO concept_property_data
(dbid, property, value)
VALUES
(@id, get_dbid('name'), 'BartsCerner'),
(@id, get_dbid('description'), 'The BartsCerner code scheme');

INSERT INTO concept_property_object
(dbid, property, value)
VALUES
(@id, get_dbid('is_subtype_of'), get_dbid('CodeScheme'));

-- Barts/Cerner CONCEPTS
INSERT INTO concept
(document, id)
SELECT @doc, concat('BC_',code)
FROM barts_cerner;

INSERT INTO concept_property_data
(dbid, property, value)
SELECT get_dbid(concat('BC_',code)), get_dbid('name'), if(length(term) > 60, concat(left(term, 57), '...'), term) FROM barts_cerner
UNION SELECT get_dbid(concat('BC_',code)), get_dbid('description'), term FROM barts_cerner
UNION SELECT get_dbid(concat('BC_',code)), get_dbid('code'), code FROM barts_cerner;

INSERT INTO concept_property_object
(dbid, property, value)
SELECT get_dbid(concat('BC_',code)), get_dbid('code_scheme'), get_dbid('BartsCerner') FROM barts_cerner
UNION SELECT get_dbid(concat('BC_',code)), get_dbid('is_subtype_of'), get_dbid('CodeableConcept') FROM barts_cerner;

-- CREATE EXPRESSION SUMMARY TABLE
DROP TABLE IF EXISTS barts_cerner_tmp;
CREATE TABLE barts_cerner_tmp (
    code INTEGER NOT NULL,
    none BOOLEAN NOT NULL DEFAULT FALSE,
    qualified BOOLEAN NOT NULL DEFAULT FALSE,
    combined BOOLEAN NOT NULL DEFAULT FALSE,
    map BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

INSERT INTO barts_cerner_tmp
(code, none, qualified, combined, map)
SELECT code,
    @none:=ISNULL(snomed_expression) AS none,
    @qual:=IFNULL(INSTR(snomed_expression, ':'), FALSE) > 0 AS qualified,
    @comb:=IFNULL(INSTR(snomed_expression, '+'), FALSE) > 0 AS combined,
    !(@none OR @qual OR @comb) AS map
FROM barts_cerner;

-- ADD DIRECT (1:1) MAPS
INSERT INTO concept_property_object
(dbid, property, value)
SELECT get_dbid(concat('BC_',b.code)), get_dbid('is_equivalent_to'), c.dbid
FROM barts_cerner_tmp t
JOIN barts_cerner b ON b.code = t.code
JOIN concept c ON c.id = CONCAT('SN_', b.snomed_expression)
WHERE t.map = TRUE;

-- CREATE CORE EXPRESSION CONCEPTS
DROP TABLE IF EXISTS barts_cerner_exp;
CREATE TABLE barts_cerner_exp
SELECT MIN(t.code) as code, snomed_expression
FROM barts_cerner_tmp t
JOIN barts_cerner b ON b.code = t.code
WHERE qualified OR combined
GROUP BY snomed_expression;

INSERT INTO concept
(document, id)
SELECT @doc, CONCAT('DS_BC_', code)
FROM barts_cerner_exp;

INSERT INTO concept_property_data
(dbid, property, value)
SELECT get_dbid(CONCAT('DS_BC_', code)), get_dbid('Expression'), snomed_expression
FROM barts_cerner_exp;

-- MAP CORE EXPRESSION CONCEPTS
SET @prop = get_dbid('Expression');
INSERT INTO concept_property_object
(dbid, property, value)
SELECT get_dbid(CONCAT('BC_', b.code)), get_dbid('is_equivalent_to'), c.dbid
FROM barts_cerner_tmp t
JOIN barts_cerner b ON b.code = t.code
JOIN concept_property_data c ON c.property = @prop AND c.value = b.snomed_expression
WHERE t.qualified OR t.combined;

-- Expand expressions - NO PIVOT FUNCTIONS IN MYSQL!!!
DROP PROCEDURE IF EXISTS expand_bc_expressions;

DELIMITER //
CREATE PROCEDURE expand_bc_expressions()
BEGIN
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE code BIGINT;
    DECLARE expr VARCHAR(50);
    DECLARE snomed VARCHAR(30);

    DECLARE comb_cursor CURSOR FOR
        SELECT b.code, b.snomed_expression
        FROM barts_cerner_tmp t
        JOIN barts_cerner b ON b.code = t.code
        WHERE t.combined;

    DECLARE qual_cursor CURSOR FOR
        SELECT e.code, e.snomed_expression
        FROM barts_cerner_tmp t
        JOIN barts_cerner_exp e ON e.code = t.code
        WHERE t.qualified;

    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET finished = 1;

    OPEN comb_cursor;

    -- Process COMBINED expressions (e.g. "62881002+447365002")
    combined: LOOP
        FETCH comb_cursor INTO code, expr;
        IF finished = 1 THEN LEAVE combined; END IF;

        split_comb: LOOP
            IF LENGTH(expr) = 0 THEN LEAVE split_comb; END IF;
            SET snomed = SUBSTRING_INDEX(expr, '+', 1);
            SET expr = SUBSTRING(expr, LENGTH(snomed) + 2);

            -- SELECT 'Comb:', get_dbid(CONCAT('DS_BC_', code)), get_dbid('is_related_to'), get_dbid(CONCAT('SN_', snomed));

            INSERT INTO concept_property_object
            (dbid, property, value)
            VALUES
            (get_dbid(CONCAT('DS_BC_', code)), get_dbid('is_related_to'), get_dbid(CONCAT('SN_', snomed)));
        END LOOP split_comb;
    END LOOP combined;

    CLOSE comb_cursor;

    -- Process QUALIFIED expressions (e.g. "173422009:405813007=75573002:272741003=51440002")
    SET finished = 0;
    OPEN qual_cursor;
    qualified: LOOP
        FETCH qual_cursor INTO code, expr;
        IF finished = 1 THEN LEAVE qualified; END IF;

        -- Snomed concept
        SET snomed = SUBSTRING_INDEX(expr, ':', 1);
        SET expr = SUBSTRING(expr, LENGTH(snomed) + 2);

        -- SELECT 'Qual:', get_dbid(CONCAT('DS_BC_', code)), get_dbid('is_related_to'), get_dbid(CONCAT('SN_', snomed));

        INSERT INTO concept_property_object
        (dbid, property, value)
        VALUES
        (get_dbid(CONCAT('DS_BC_', code)), get_dbid('is_related_to'), get_dbid(CONCAT('SN_', snomed)));

        split_qual: LOOP
            -- Qualifiers
            IF LENGTH(expr) = 0 THEN LEAVE split_qual; END IF;
            SET snomed = SUBSTRING_INDEX(expr, ':', 1);
            SET expr = SUBSTRING(expr, LENGTH(snomed) + 2);

            -- SELECT '  Qual:', get_dbid(CONCAT('DS_BC_', code)), get_dbid(CONCAT('SN_', SUBSTRING_INDEX(snomed, '=', 1))), get_dbid(CONCAT('SN_', SUBSTRING_INDEX(snomed, '=', -1)));

            INSERT INTO concept_property_object
            (dbid, property, value)
            VALUES
            (get_dbid(CONCAT('DS_BC_', code)), get_dbid(CONCAT('SN_', SUBSTRING_INDEX(snomed, '=', 1))), get_dbid(CONCAT('SN_', SUBSTRING_INDEX(snomed, '=', -1))));
        END LOOP split_qual;
    END LOOP qualified;
    CLOSE qual_cursor;
END; //

DELIMITER ;

CALL expand_bc_expressions();
