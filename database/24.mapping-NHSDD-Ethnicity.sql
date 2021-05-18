-- Ensure core code scheme exists
INSERT IGNORE INTO concept (document, id, name, description)
VALUES (1, 'CM_DiscoveryCode', 'Discovery code', 'Discovery (core) coding scheme ');

-- Get scheme id
SELECT @scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';

-- Ensure NHS DD scheme exists --
INSERT IGNORE INTO concept (document, id, scheme, code, name, description)
VALUES (1, 'CM_NHS_DD', @scm, 'CM_NHS_DD', 'NHS Data Dictionary', 'NHS Data Dictionary coding scheme');

-- Code scheme prefix entries
INSERT IGNORE INTO concept_property_data
(`dbid`, `group`, `property`, `value`)
SELECT c.dbid, 0 AS `group`, p.dbid AS `property`, '' AS `value`
FROM concept c
JOIN concept p ON p.id = 'code_prefix'
WHERE c.id IN ('CM_DiscoveryCode', 'CM_NHS_DD');

-- ETHNICITY CONCEPTS --  https://datadictionary.nhs.uk/data_elements/ethnic_category.html?hl=ethnicity
INSERT IGNORE INTO concept (document, id, scheme, code, name, description)
VALUES
(1, 'DM_ethnicity', @scm, 'DM_ethnicity', 'Ethnicity', 'Ethnicity'),
(1, 'CM_EthnicityA', @scm, 'CM_EthnicityA', 'White - British', 'White - British'),
(1, 'CM_EthnicityB', @scm, 'CM_EthnicityB', 'White - Irish', 'White - Irish'),
(1, 'CM_EthnicityC', @scm, 'CM_EthnicityC', 'White - Any other White background', 'White - Any other White background'),
(1, 'CM_EthnicityD', @scm, 'CM_EthnicityD', 'Mixed - White and Black Caribbean', 'Mixed - White and Black Caribbean'),
(1, 'CM_EthnicityE', @scm, 'CM_EthnicityE', 'Mixed - White and Black African', 'Mixed - White and Black African'),
(1, 'CM_EthnicityF', @scm, 'CM_EthnicityF', 'Mixed - White and Asian', 'Mixed - White and Asian'),
(1, 'CM_EthnicityG', @scm, 'CM_EthnicityG', 'Mixed - Any other mixed background', 'Mixed - Any other mixed background'),
(1, 'CM_EthnicityH', @scm, 'CM_EthnicityH', 'Asian or Asian British - Indian', 'Asian or Asian British - Indian'),
(1, 'CM_EthnicityJ', @scm, 'CM_EthnicityJ', 'Asian or Asian British - Pakistani', 'Asian or Asian British - Pakistani'),
(1, 'CM_EthnicityK', @scm, 'CM_EthnicityK', 'Asian or Asian British - Bangladeshi', 'Asian or Asian British - Bangladeshi'),
(1, 'CM_EthnicityL', @scm, 'CM_EthnicityL', 'Asian or Asian British - Any other Asian background', 'Asian or Asian British - Any other Asian background'),
(1, 'CM_EthnicityM', @scm, 'CM_EthnicityM', 'Black or Black British - Caribbean', 'Black or Black British - Caribbean'),
(1, 'CM_EthnicityN', @scm, 'CM_EthnicityN', 'Black or Black British - African', 'Black or Black British - African'),
(1, 'CM_EthnicityP', @scm, 'CM_EthnicityP', 'Black or Black British - Any other Black background', 'Black or Black British - Any other Black background'),
(1, 'CM_EthnicityR', @scm, 'CM_EthnicityR', 'Other Ethnic Groups - Chinese', 'Other Ethnic Groups - Chinese'),
(1, 'CM_EthnicityS', @scm, 'CM_EthnicityS', 'Other Ethnic Groups - Any other ethnic group', 'Other Ethnic Groups - Any other ethnic group'),
(1, 'CM_EthnicityZ', @scm, 'CM_EthnicityZ', 'Not stated', 'Not stated'),
(1, 'CM_Ethnicity99', @scm, 'CM_Ethnicity99', 'Not known', 'Not known');

-- Node maps
INSERT INTO map_node_meta
(node, concept)
VALUES
('/CDS/PTNT/ETHNC_CTGRY',               'DM_ethnicity')
;

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/CDS/PTNT/ETHNC_CTGRY', 'A', 'CM_NHS_DD', 'CM_EthnicityA'),
('/CDS/PTNT/ETHNC_CTGRY', 'B', 'CM_NHS_DD', 'CM_EthnicityB'),
('/CDS/PTNT/ETHNC_CTGRY', 'C', 'CM_NHS_DD', 'CM_EthnicityC'),
('/CDS/PTNT/ETHNC_CTGRY', 'D', 'CM_NHS_DD', 'CM_EthnicityD'),
('/CDS/PTNT/ETHNC_CTGRY', 'E', 'CM_NHS_DD', 'CM_EthnicityE'),
('/CDS/PTNT/ETHNC_CTGRY', 'F', 'CM_NHS_DD', 'CM_EthnicityF'),
('/CDS/PTNT/ETHNC_CTGRY', 'G', 'CM_NHS_DD', 'CM_EthnicityG'),
('/CDS/PTNT/ETHNC_CTGRY', 'H', 'CM_NHS_DD', 'CM_EthnicityH'),
('/CDS/PTNT/ETHNC_CTGRY', 'J', 'CM_NHS_DD', 'CM_EthnicityJ'),
('/CDS/PTNT/ETHNC_CTGRY', 'K', 'CM_NHS_DD', 'CM_EthnicityK'),
('/CDS/PTNT/ETHNC_CTGRY', 'L', 'CM_NHS_DD', 'CM_EthnicityL'),
('/CDS/PTNT/ETHNC_CTGRY', 'M', 'CM_NHS_DD', 'CM_EthnicityM'),
('/CDS/PTNT/ETHNC_CTGRY', 'N', 'CM_NHS_DD', 'CM_EthnicityN'),
('/CDS/PTNT/ETHNC_CTGRY', 'P', 'CM_NHS_DD', 'CM_EthnicityP'),
('/CDS/PTNT/ETHNC_CTGRY', 'R', 'CM_NHS_DD', 'CM_EthnicityR'),
('/CDS/PTNT/ETHNC_CTGRY', 'S', 'CM_NHS_DD', 'CM_EthnicityS'),
('/CDS/PTNT/ETHNC_CTGRY', 'Z', 'CM_NHS_DD', 'CM_EthnicityZ'),
('/CDS/PTNT/ETHNC_CTGRY', '99', 'CM_NHS_DD', 'CM_Ethnicity99')
;
