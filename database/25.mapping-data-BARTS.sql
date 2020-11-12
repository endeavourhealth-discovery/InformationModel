-- Meta tables for clarity/simplicity
DROP TABLE IF EXISTS map_context_meta;
CREATE TABLE map_context_meta (
    provider    VARCHAR(150),
    `system`    VARCHAR(150),
    `schema`    VARCHAR(40),
    `table`     VARCHAR(40),
    `column`    VARCHAR(40),
    node        VARCHAR(200)
) ENGINE = Memory
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS map_node_meta;
CREATE TABLE map_node_meta(
    node    VARCHAR(200),
    concept VARCHAR(150)
) ENGINE = Memory
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS map_node_value_meta;
CREATE TEMPORARY TABLE map_node_value_meta (
    node    VARCHAR(200),
    value   VARCHAR(250),
    scheme  VARCHAR(150),
    concept VARCHAR(150)
) ENGINE = Memory
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS map_function_value_meta;
CREATE TEMPORARY TABLE map_function_value_meta (
    node    VARCHAR(200),
    scheme  VARCHAR(150),
    function  VARCHAR(200)
) ENGINE = Memory
  DEFAULT CHARSET = utf8;


-- ******************** EMERGENCY ********************

-- Context maps
INSERT INTO map_context_meta
(provider, `system`, `schema`, `table`, `column`, node)
VALUES
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'department_type',          '/CDS/EMGCY/DPT_TYP'),                  -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'arrival_mode',             '/CDS/EMGCY/ARRVL_MD'),                 -- SNOMED
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'attendance_category',      '/CDS/EMGCY/ATTNDNC_CTGRY'),            -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'attendance_source',        '/CDS/EMGCY/ATTNDNC_SRC'),              -- SNOMED
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'treatment_function_code',  '/BRTS/CRNR/CDS/EMGCY/TRTMNT_FNCTN'),   -- BARTS/CERNER code
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'discharge_status',         '/CDS/EMGCY/DSCHRG_STTS'),              -- SNOMED
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'discharge_destination',    '/CDS/EMGCY/DSCHRG_DSTNTN'),            -- SNOMED
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'discharge_follow_up',      '/CDS/EMGCY/DSCHRG_FLLW_UP'),           -- SNOMED
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'emergency', 'referred_to_services',     '/CDS/EMGCY/RFRRD_SRVCS');              -- SNOMED

-- Node maps
INSERT INTO map_node_meta
(node, concept)
VALUES
('/BRTS/CRNR/CDS/EMGCY/TRTMNT_FNCTN',    'DM_treatmentFunctionAdmit')   -- BARTS/CERNER code
;

INSERT INTO map_function_value_meta
(node, scheme, function)
VALUES
('/BRTS/CRNR/CDS/EMGCY/TRTMNT_FNCTN', 'BartsCerner', 'Format(BC_%s)')
;

-- ******************** INPATIENT ********************

-- Context maps
INSERT INTO map_context_meta
(provider, `system`, `schema`, `table`, `column`, node)
VALUES
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'admission_method_code',         '/CDS/INPTNT/ADMSSN_MTHD'),            -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'admission_source_code',         '/CDS/INPTNT/ADMSSN_SRC'),             -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'patient_classification',        '/CDS/INPTNT/PTNT_CLSSFCTN'),          -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'discharge_destination_code',    '/CDS/INPTNT/DSCHRG_DSTNTN'),          -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'discharge_method',              '/CDS/INPTNT/DSCHRG_MTHD'),            -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'administrative_category_code',  '/CDS/INPTNT/ADMNSTRV_CTGRY'),         -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'treatment_function_code',       '/BRTS/CRNR/CDS/INPTNT/TRTMNT_FNCTN'), -- BARTS LOCAL
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'live_or_still_birth_indicator', '/CDS/INPTNT/LV_STLL_BRTH_INDCTR'),    -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'delivery_method',               '/CDS/INPTNT/DLVRY_MTHD'),             -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'inpatient', 'gender',                        '/CDS/INPTNT/GNDR')                    -- NHS DD
;

-- Node maps
INSERT INTO map_node_meta
(node, concept)
VALUES
('/BRTS/CRNR/CDS/INPTNT/TRTMNT_FNCTN',   'DM_treatmentFunctionAdmit')           -- BARTS LOCAL
;

INSERT INTO map_function_value_meta
(node, scheme, function)
VALUES
('/BRTS/CRNR/CDS/INPTNT/TRTMNT_FNCTN', 'BartsCerner', 'Format(BC_%s)')
;

-- ******************** OUTPATIENT ********************

-- Context maps
INSERT INTO map_context_meta
(provider, `system`, `schema`, `table`, `column`, node)
VALUES
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'outpatient', 'appt_attended_code',           '/CDS/OUTPTNT/APPT_ATTNDD'),           -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'outpatient', 'appt_outcome_code',            '/CDS/OUTPTNT/OUTCM'),                 -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'outpatient', 'administrative_category_code', '/CDS/OUTPTNT/ADMNSTRTV_CTGRY'),       -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'outpatient', 'referral_source',              '/CDS/OUTPTNT/RFRRL_SRC'),             -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'outpatient', 'treatment_function_code',      '/BRTS/CRNR/CDS/OUTPTNT/TRTMNT_FNCTN') -- BARTS/CERNER code
;

-- Node maps
INSERT INTO map_node_meta
(node, concept)
VALUES
('/BRTS/CRNR/CDS/OUTPTNT/TRMNT_FNCTN',   'DM_treatmentFunctionAdmit')           -- BARTS/CERNER code
;

INSERT INTO map_function_value_meta
(node, scheme, function)
VALUES
('/BRTS/CRNR/CDS/OUTPTNT/TRTMNT_FNCTN', 'BartsCerner', 'Format(BC_%s)')
;

-- ******************** CRITICAL CARE ********************

-- Context maps
INSERT INTO map_context_meta
(provider, `system`, `schema`, `table`, `column`, node)
VALUES
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'critical_care_type_id',          '/CDS/CRTCL/CRTCL_CR_TYP'),    -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'care_unit_function',             '/CDS/CRTCL/CR_UNT_FNCTN'),    -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'admission_source_code',          '/CDS/CRTCL/ADMSSN_SRC'),      -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'admission_type_code',            '/CDS/CRTCL/ADMSSN_TYP'),      -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'admission_location',             '/CDS/CRTCL/ADMSSN_LCTN'),     -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'discharge_status_code',          '/CDS/CRTCL/DSCHRG_STTS'),     -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'discharge_destination',          '/CDS/CRTCL/DSCHRG_DSTNTN'),   -- NHS DD
('CM_Org_Barts', 'CM_Sys_Cerner', 'CDS', 'critical', 'discharge_location',             '/CDS/CRTCL/DSCHRG_LCTN')      -- NHS DD
;

/* **************************************************************************************************** */

-- Populate real tables from meta (IM v1)
SELECT DISTINCT m.node, c.dbid, false
FROM map_node_meta m
         LEFT JOIN concept c ON c.id = m.concept
WHERE c.id IS NULL;

INSERT INTO map_node
(node, concept, draft)
SELECT DISTINCT m.node, c.dbid, false
FROM map_node_meta m
         JOIN concept c ON c.id = m.concept;

--

SELECT prv.dbid, sys.dbid, `schema`, `table`, `column`, n.id, false
FROM map_context_meta m
         JOIN map_node n ON n.node = m.node
         LEFT JOIN concept prv ON prv.id = m.provider
         LEFT JOIN concept sys ON sys.id = m.system
WHERE prv.id IS NULL
   OR sys.id IS NULL;

INSERT INTO map_context
(provider, `system`, `schema`, `table`, `column`, node, draft)
SELECT prv.dbid, sys.dbid, `schema`, `table`, `column`, n.id, false
FROM map_context_meta m
         JOIN map_node n ON n.node = m.node
         JOIN concept prv ON prv.id = m.provider
         JOIN concept sys ON sys.id = m.system;

--

SELECT DISTINCT n.id, c.dbid, 'Lookup()'
FROM map_node_value_meta m
         JOIN map_node n ON n.node = m.node
         LEFT JOIN concept c ON c.id = m.scheme
WHERE c.id IS NULL;

INSERT INTO map_value_node
(node, code_scheme, function)
SELECT DISTINCT n.id, c.dbid, 'Lookup()'
FROM map_node_value_meta m
         JOIN map_node n ON n.node = m.node
         JOIN concept c ON c.id = m.scheme;

--

SELECT n.id, c.dbid, m.function
FROM map_function_value_meta m
         JOIN map_node n ON n.node = m.node
         LEFT JOIN concept c ON c.id = m.scheme
WHERE c.id IS NULL;

INSERT INTO map_value_node
(node, code_scheme, function)
SELECT n.id, c.dbid, m.function
FROM map_function_value_meta m
         JOIN map_node n ON n.node = m.node
         JOIN concept c ON c.id = m.scheme;

--

SELECT v.id, m.value, c.dbid, false
FROM map_node_value_meta m
         LEFT JOIN map_node n ON n.node = m.node
         LEFT JOIN map_value_node v ON v.node = n.id
         LEFT JOIN concept s ON s.dbid = v.code_scheme AND s.id = m.scheme
         LEFT JOIN concept c ON c.id = m.concept
WHERE n.node IS NULL
   OR v.node IS NULL
   OR s.id IS NULL
   OR c.id IS NULL;

INSERT INTO map_value_node_lookup
(value_node, value, concept, draft)
SELECT v.id, m.value, c.dbid, false
FROM map_node_value_meta m
         JOIN map_node n ON n.node = m.node
         JOIN map_value_node v ON v.node = n.id
         JOIN concept s ON s.dbid = v.code_scheme AND s.id = m.scheme
         JOIN concept c ON c.id = m.concept;

-- Clean up
DROP TABLE IF EXISTS map_context_meta;
DROP TABLE IF EXISTS map_node_meta;
DROP TABLE IF EXISTS map_node_value_meta;
DROP TABLE IF EXISTS map_function_value_meta;

