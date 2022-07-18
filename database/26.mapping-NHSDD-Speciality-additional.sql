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

-- TREATMENT FUNCTION --  https://datadictionary.nhs.uk/attributes/treatment_function_code.html
INSERT IGNORE INTO concept (document, id, scheme, code, name, description)
VALUES
(1, 'CM_TrtmntFnc147', @scm, 'CM_TrtmntFnc147', 'Periodontics', 'Periodontics'),
(1, 'CM_TrtmntFnc820', @scm, 'CM_TrtmntFnc820', 'General Pathology', 'General Pathology'),
(1, 'CM_TrtmntFnc821', @scm, 'CM_TrtmntFnc821', 'Blood Transfusion', 'Blood Transfusion'),
(1, 'CM_TrtmntFnc823', @scm, 'CM_TrtmntFnc823', 'Haematology', 'Haematology'),
(1, 'CM_TrtmntFnc824', @scm, 'CM_TrtmntFnc824', 'Histopathology', 'Histopathology'),
(1, 'CM_TrtmntFnc830', @scm, 'CM_TrtmntFnc830', 'Immunopathology', 'Immunopathology'),
(1, 'CM_TrtmntFnc831', @scm, 'CM_TrtmntFnc831', 'Medical Microbiology and Virology', 'Medical Microbiology and Virology'),
(1, 'CM_TrtmntFnc833', @scm, 'CM_TrtmntFnc833', 'Medical Microbiology', 'Medical Microbiology'),
(1, 'CM_TrtmntFnc900', @scm, 'CM_TrtmntFnc900', 'Community Medicine', 'Community Medicine'),
(1, 'CM_TrtmntFnc901', @scm, 'CM_TrtmntFnc901', 'Occupational Medicine', 'Occupational Medicine'),
(1, 'CM_TrtmntFnc902', @scm, 'CM_TrtmntFnc902', 'Community Health Services Dental', 'Community Health Services Dental'),
(1, 'CM_TrtmntFnc903', @scm, 'CM_TrtmntFnc903', 'Public Health Medicine', 'Public Health Medicine'),
(1, 'CM_TrtmntFnc950', @scm, 'CM_TrtmntFnc950', 'Nursing', 'Nursing'),
(1, 'CM_TrtmntFnc960', @scm, 'CM_TrtmntFnc960', 'Allied Health Professional', 'Allied Health Professional'),
(1, 'CM_TrtmntFnc990', @scm, 'CM_TrtmntFnc990', 'Joint Consultant Clinics', 'Joint Consultant Clinics'),
-- Added 17 Jul 2022
(1, 'CM_TrtmntFnc600', @scm, 'CM_TrtmntFnc600', 'General Medical Practice', 'General Medical Practice'),
(1, 'CM_TrtmntFnc810', @scm, 'CM_TrtmntFnc810', 'Radiology', 'Radiology');

