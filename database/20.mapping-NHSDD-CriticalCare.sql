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

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
-- CRITICAL CARE --
(1, 'DM_criticalCareType', @scm, 'DM_criticalCareType', 'Type of critical care', 'Type of critical care'),
(1, 'CM_CritCareType01', @scm, 'CM_CritCareType01', 'Neonatal critical care period', 'Neonatal critical care period'),
(1, 'CM_CritCareType02', @scm, 'CM_CritCareType02', 'Paediatric critical care period', 'Paediatric critical care period'),
(1, 'CM_CritCareType03', @scm, 'CM_CritCareType03', 'Adult critical care period', 'Adult critical care period'),

(1, 'DM_hasCriticalCareUnitFunction', @scm, 'DM_hasCriticalCareUnitFunction', 'has critical care unit function', 'Points to the overall function of the critical care unit'),
(1, 'CM_CcufAdult1', @scm, 'CM_CcufAdult1', 'Critical care general adult facility', 'Non-specific, general adult critical care PATIENTS  predominate CDS01'),
(1, 'CM_CcufAdult2', @scm, 'CM_CcufAdult2', 'Critical care surgical adult facility', 'Surgical adult PATIENTS (unspecified specialty) CDS 2'),
(1, 'CM_CcufAdult3', @scm, 'CM_CcufAdult3', 'Critical care medical adult facility', 'Medical adult PATIENTS (unspecified specialty) CDS 3'),
(1, 'CM_CcufAdult5', @scm, 'CM_CcufAdult5', 'Critical care neurosciences adult', 'Neurosciences adult PATIENTS predominate CDS 5'),
(1, 'CM_Ccufadult6', @scm, 'CM_Ccufadult6', 'Critical care cardiac surgical adult', 'Cardiac surgical adult PATIENTS predominate CDS 6'),
(1, 'CM_Ccufadult7', @scm, 'CM_Ccufadult7', 'Critical care thoracic surgical adult', 'Thoracic surgical adult PATIENTS predominate CDS 7'),
(1, 'CM_CcufAdult8', @scm, 'CM_CcufAdult8', 'Critical care burns and plastic surgery adult', 'Burns and plastic surgery adult PATIENTS predominate CDS 8'),
(1, 'CM_CcufAdult9', @scm, 'CM_CcufAdult9', 'Critical care spinal adult', 'Spinal adult PATIENTS predominate cds 9'),
(1, 'CM_CcufAdult10', @scm, 'CM_CcufAdult10', 'Critical care renal adult', 'Renal adult PATIENTS predominate CDS 10'),
(1, 'CM_CcufAdult11', @scm, 'CM_CcufAdult11', 'Critical care liver adult', 'Liver adult PATIENTS predominate CDS 11'),
(1, 'CM_Ccufadult12', @scm, 'CM_Ccufadult12', 'Critical care obstetric and gynaecology', 'Obstetric and gynaecology critical care PATIENTS predominate CDS 12'),
(1, 'CM_Ccufadult90', @scm, 'CM_Ccufadult90', 'Critical care non standard adult', 'Non standard LOCATION using a WARD area CDS 90'),
(1, 'CM_CcufChild4', @scm, 'CM_CcufChild4', 'Critical care paediatric intensive Care Unit', 'Paediatric Intensive Care Unit (Paediatric critical care PATIENTS predominate) CDS 4'),
(1, 'CM_CcufChild16', @scm, 'CM_CcufChild16', 'Critical care ward for children and young people', 'WARD for children and young people CDS 16'),
(1, 'CM_CcufChild17', @scm, 'CM_CcufChild17', 'Critical care high dependency unit fo children and young people', 'High Dependency Unit for children and young people cds 17'),
(1, 'CM_CcufChild18', @scm, 'CM_CcufChild18', 'Critical care renal unit for children and young people', 'Renal Unit for children and young people CDS 18'),
(1, 'CM_CcufChild19', @scm, 'CM_CcufChild19', 'Critical care burns Unit for children and young people', 'Burns Unit for children and young people CDS 19'),
(1, 'CM_CcufChild92', @scm, 'CM_CcufChild92', 'Critical care non standard for children and young people', 'Non standard LOCATION using the operating department for children and young people CDS 92'),
(1, 'CM_CcufNeonate13', @scm, 'CM_CcufNeonate13', 'Critical care neonatal intensive care unit', 'Neonatal Intensive Care Unit (Neonatal critical care PATIENTS predominate) CDS 13'),
(1, 'CM_CcufNeonate14', @scm, 'CM_CcufNeonate14', 'Critical care ward for neonatal transitional care', 'Facility for Babies on a Neonatal Transitional Care WARD CDS 14'),
(1, 'CM_CcufNeonate15', @scm, 'CM_CcufNeonate15', 'Critical care for babies on maternity ward', 'Facility for Babies on a Maternity WARD CDS 15'),
(1, 'CM_CcuOther91', @scm, 'CM_CcuOther91', 'Critical care non standard location', 'Non standard LOCATION using the operating department'),

-- DM_sourceOfAdmission - Outpatient above
(1, 'CM_CriticalCareSource1', @scm, 'CM_CriticalCareSource1', 'Admitted from same NHS hospital site', 'Same NHS Hospital Site CDS1'),
(1, 'CM_CriticalCareSource2', @scm, 'CM_CriticalCareSource2', 'Admitted from other NHS Hospital site', 'Other NHS Hospital Site (same or different NHS Trust) CDS2'),
(1, 'CM_CriticalCareSource3', @scm, 'CM_CriticalCareSource3', 'Admitted from independent hospital provider in the UK', 'Independent Hospital Provider in the UK CDS 3'),
(1, 'CM_CriticalCareSource4', @scm, 'CM_CriticalCareSource4', 'Admitted from non hospital source in uk including home', 'Non-hospital source within the UK (e.g. home) CDS 4'),
(1, 'CM_CriticalCareSource5', @scm, 'CM_CriticalCareSource5', 'Admitted from non UK source', 'Non UK source such as repatriation, military personnel or foreign national CDS 5'),

(1, 'DM_criticalCareAdmType', @scm, 'DM_criticalCareAdmType', 'Critical care admission type', 'An indication of whether a CRITICAL CARE PERIOD was initiated as a result of a non-emergency treatment plan'),
(1, 'CM_CritCareAdmType01', @scm, 'CM_CritCareAdmType01', 'Unplanned local admission', 'Unplanned local admission. All emergency or urgent PATIENTS referred to the unit only as a result of an unexpected acute illness occurring within the local area (hospitals within the Trust together with neighbouring community units and services).'),
(1, 'CM_CritCareAdmType02', @scm, 'CM_CritCareAdmType02', 'Unplanned transfer in', 'Unplanned transfer in. All emergency or urgent PATIENTS referred to the unit as a result of an unexpected acute illness occurring outside the local area (including private and overseas Health Care Providers).'),
(1, 'CM_CritCareAdmType03', @scm, 'CM_CritCareAdmType03', 'Planned transfer in (tertiary referral)', 'Planned transfer in (tertiary referral). A pre-arranged admission to the unit after treatment or initial stabilisation at another Health Care Provider (including private and overseas Health Care Providers) but requiring specialist or higher-level care that cannot be provided at the source hospital or unit.'),
(1, 'CM_CritCareAdmType04', @scm, 'CM_CritCareAdmType04', 'Planned local surgical admission', 'Planned local surgical admission. A pre-arranged surgical admission from the local area to the to the unit, acceptance by the unit must have occurred prior to the start of the surgical procedure and the procedure will usually have been of an elective or scheduled nature.'),
(1, 'CM_CritCareAdmType05', @scm, 'CM_CritCareAdmType05', 'Planned local medical admission from the local area', 'Planned local medical admission from the local area. Booked medical admission, for example, planned investigation or high risk medical treatment.'),
(1, 'CM_CritCareAdmType06', @scm, 'CM_CritCareAdmType06', 'Repatriation', 'Repatriation. The PATIENT is normally resident in your local area and is being admitted or readmitted to your unit from another hospital (including overseas Health Care Providers). This situation will normally arise when a PATIENT is returning from tertiary or specialist care.'),

(1, 'DM_criticalCareSourceLocation', @scm, 'DM_criticalCareSourceLocation', 'The type of LOCATION the PATIENT was in prior to the start of the CRITICAL CARE PERIOD.', 'The type of LOCATION the PATIENT was in prior to the start of the CRITICAL CARE PERIOD.'),
(1, 'CM_CritCareSrcLctn01', @scm, 'CM_CritCareSrcLctn01', 'Theatre and Recovery', 'Theatre and Recovery (following surgical and/or anaesthetic procedure)'),
(1, 'CM_CritCareSrcLctn02', @scm, 'CM_CritCareSrcLctn02', 'Recovery only', 'Recovery only (when used to provide temporary critical care facility)'),
(1, 'CM_CritCareSrcLctn03', @scm, 'CM_CritCareSrcLctn03', 'Other WARD', 'Other WARD (not critical care)'),
(1, 'CM_CritCareSrcLctn04', @scm, 'CM_CritCareSrcLctn04', 'Imaging Department', 'Imaging Department'),
(1, 'CM_CritCareSrcLctn05', @scm, 'CM_CritCareSrcLctn05', 'Accident and emergency', 'Accident and emergency'),
(1, 'CM_CritCareSrcLctn06', @scm, 'CM_CritCareSrcLctn06', 'Other intermediate care or specialist treatment areas including endoscopy units and catheter suites', 'Other intermediate care or specialist treatment areas including endoscopy units and catheter suites'),
(1, 'CM_CritCareSrcLctn07', @scm, 'CM_CritCareSrcLctn07', 'Obstetrics area', 'Obstetrics area'),
(1, 'CM_CritCareSrcLctn08', @scm, 'CM_CritCareSrcLctn08', 'Clinic', 'Clinic'),
(1, 'CM_CritCareSrcLctn09', @scm, 'CM_CritCareSrcLctn09', 'Home or other residence', 'Home or other residence (including nursing home, H.M. Prison or other residential care)'),
(1, 'CM_CritCareSrcLctn10', @scm, 'CM_CritCareSrcLctn10', 'Adult level three critical care bed', 'Adult level three critical care bed (ICU bed)'),
(1, 'CM_CritCareSrcLctn11', @scm, 'CM_CritCareSrcLctn11', 'Adult level two critical care bed', 'Adult level two critical care bed (HDU bed)'),
(1, 'CM_CritCareSrcLctn12', @scm, 'CM_CritCareSrcLctn12', 'Paediatric critical care area', 'Paediatric critical care area (neonatal and paediatric care)'),

(1, 'DM_criticalCareDischargeStatus', @scm, 'DM_criticalCareDischargeStatus', 'The discharge status of a PATIENT who is discharged from a Ward Stay (CRITICAL CARE)', 'The discharge status of a PATIENT who is discharged from a Ward Stay where they were receiving care as part of a CRITICAL CARE PERIOD and the discharge ends the CRITICAL CARE PERIOD.'),
(1, 'CM_CritCareDschgStts01', @scm, 'CM_CritCareDschgStts01', 'Fully ready for discharge', 'Fully ready for discharge'),
(1, 'CM_CritCareDschgStts02', @scm, 'CM_CritCareDschgStts02', 'Discharge for Palliative Care', 'Discharge for Palliative Care'),
(1, 'CM_CritCareDschgStts03', @scm, 'CM_CritCareDschgStts03', 'Early discharge due to shortage of critical care beds', 'Early discharge due to shortage of critical care beds'),
(1, 'CM_CritCareDschgStts04', @scm, 'CM_CritCareDschgStts04', 'Delayed discharge due to shortage of other WARD beds', 'Delayed discharge due to shortage of other WARD beds'),
(1, 'CM_CritCareDschgStts05', @scm, 'CM_CritCareDschgStts05', 'Current level of care continuing in another LOCATION', 'Current level of care continuing in another LOCATION'),
(1, 'CM_CritCareDschgStts06', @scm, 'CM_CritCareDschgStts06', 'More specialised care in another LOCATION', 'More specialised care in another LOCATION'),
(1, 'CM_CritCareDschgStts07', @scm, 'CM_CritCareDschgStts07', 'Self discharge against medical advice', 'Self discharge against medical advice'),
(1, 'CM_CritCareDschgStts08', @scm, 'CM_CritCareDschgStts08', 'PATIENT died (no organs donated)', 'PATIENT died (no organs donated)'),
(1, 'CM_CritCareDschgStts09', @scm, 'CM_CritCareDschgStts09', 'PATIENT died (heart beating solid organ donor)', 'PATIENT died (heart beating solid organ donor)'),
(1, 'CM_CritCareDschgStts10', @scm, 'CM_CritCareDschgStts10', 'PATIENT died (cadaveric TISSUE donor)', 'PATIENT died (cadaveric TISSUE donor)'),
(1, 'CM_CritCareDschgStts11', @scm, 'CM_CritCareDschgStts11', 'PATIENT died (non heart beating solid organ donor)', 'PATIENT died (non heart beating solid organ donor)'),

(1, 'DM_criticalCareDischargeDest', @scm, 'DM_criticalCareDischargeDest', 'The primary Organisation type that the PATIENT has been discharged to at the end of the CRITICAL CARE PERIOD.', 'The primary Organisation type that the PATIENT has been discharged to at the end of the CRITICAL CARE PERIOD.'),
(1, 'CM_CritCareDschgDest01', @scm, 'CM_CritCareDschgDest01', 'Same NHS Hospital Site', 'Same NHS Hospital Site'),
(1, 'CM_CritCareDschgDest02', @scm, 'CM_CritCareDschgDest02', 'Other NHS Hospital Site', 'Other NHS Hospital Site (can be same Trust or a different NHS Trust)'),
(1, 'CM_CritCareDschgDest03', @scm, 'CM_CritCareDschgDest03', 'Independent Hospital Provider in the UK', 'Independent Hospital Provider in the UK'),
(1, 'CM_CritCareDschgDest04', @scm, 'CM_CritCareDschgDest04', 'Non-hospital destination within the UK', 'Non-hospital destination within the UK (e.g. home as coded in LOCATION)'),
(1, 'CM_CritCareDschgDest05', @scm, 'CM_CritCareDschgDest05', 'Non United Kingdom destination', 'Non United Kingdom destination (e.g. repatriation)'),
(1, 'CM_CritCareDschgDest06', @scm, 'CM_CritCareDschgDest06', 'No DISCHARGE DESTINATION, PATIENT died in unit', 'No DISCHARGE DESTINATION, PATIENT died in unit'),

(1, 'DM_criticalCareDischargeLocation', @scm, 'DM_criticalCareDischargeLocation', 'The principal LOCATION that the PATIENT is discharged to at the end of the CRITICAL CARE PERIOD.', 'The principal LOCATION that the PATIENT is discharged to at the end of the CRITICAL CARE PERIOD.'),
(1, 'CM_CritCareDschgLctn01', @scm, 'CM_CritCareDschgLctn01', 'WARD', 'WARD'),
(1, 'CM_CritCareDschgLctn02', @scm, 'CM_CritCareDschgLctn02', 'Recovery only', 'Recovery only (when used to provide temporary critical care facility)'),
(1, 'CM_CritCareDschgLctn03', @scm, 'CM_CritCareDschgLctn03', 'Other intermediate care or specialised treatment area but excluding temporary visits en route', 'Other intermediate care or specialised treatment area but excluding temporary visits en route, e.g. imaging, Endoscopy, catheter suites and operating departments.'),
(1, 'CM_CritCareDschgLctn04', @scm, 'CM_CritCareDschgLctn04', 'Adult level three critical care bed', 'Adult level three critical care bed (e.g. in a flexibly configured unit)'),
(1, 'CM_CritCareDschgLctn05', @scm, 'CM_CritCareDschgLctn05', 'Adult level two critical care bed', 'Adult level two critical care bed (e.g. in a flexibly configured unit)'),
(1, 'CM_CritCareDschgLctn06', @scm, 'CM_CritCareDschgLctn06', 'No discharge location, PATIENT died in unit', 'No discharge location, PATIENT died in unit'),
(1, 'CM_CritCareDschgLctn07', @scm, 'CM_CritCareDschgLctn07', 'Obstetrics area', 'Obstetrics area'),
(1, 'CM_CritCareDschgLctn08', @scm, 'CM_CritCareDschgLctn08', 'Paediatric critical care area', 'Paediatric critical care area (neonatal and paediatric care)'),
(1, 'CM_CritCareDschgLctn09', @scm, 'CM_CritCareDschgLctn09', 'Home or other residence', 'Home or other residence (e.g. nursing home, H.M. Prison, residential care)'),
(1, 'CM_CritCareDschgLctn10', @scm, 'CM_CritCareDschgLctn10', 'Other non-hospital LOCATION', 'Other non-hospital LOCATION')
;

-- Node maps
INSERT INTO map_node_meta
(node, concept)
VALUES
('/CDS/CRTCL/CRTCL_CR_TYP',              'DM_criticalCareType'),                -- NHS DD
('/CDS/CRTCL/CR_UNT_FNCTN',              'DM_hasCriticalCareUnitFunction'),     -- NHS DD
('/CDS/CRTCL/ADMSSN_SRC',                'DM_sourceOfAdmission'),               -- NHS DD
('/CDS/CRTCL/ADMSSN_TYP',                'DM_criticalCareAdmType'),             -- NHS DD
('/CDS/CRTCL/ADMSSN_LCTN',               'DM_criticalCareSourceLocation'),      -- NHS DD
('/CDS/CRTCL/DSCHRG_STTS',               'DM_criticalCareDischargeStatus'),     -- NHS DD
('/CDS/CRTCL/DSCHRG_DSTNTN',             'DM_criticalCareDischargeDest'),       -- NHS DD
('/CDS/CRTCL/DSCHRG_LCTN',               'DM_criticalCareDischargeLocation')    -- NHS DD
;

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/CDS/CRTCL/CRTCL_CR_TYP', '01', 'CM_CDS', 'CM_CritCareType01'),
('/CDS/CRTCL/CRTCL_CR_TYP', '02', 'CM_CDS', 'CM_CritCareType02'),
('/CDS/CRTCL/CRTCL_CR_TYP', '03', 'CM_CDS', 'CM_CritCareType03'),

('/CDS/CRTCL/CR_UNT_FNCTN', '01', 'CM_NHS_DD', 'CM_CcufAdult1'),
('/CDS/CRTCL/CR_UNT_FNCTN', '02', 'CM_NHS_DD', 'CM_CcufAdult2'),
('/CDS/CRTCL/CR_UNT_FNCTN', '03', 'CM_NHS_DD', 'CM_CcufAdult3'),
('/CDS/CRTCL/CR_UNT_FNCTN', '05', 'CM_NHS_DD', 'CM_CcufAdult5'),
('/CDS/CRTCL/CR_UNT_FNCTN', '06', 'CM_NHS_DD', 'CM_Ccufadult6'),                    -- TODO: Capital "A"?
('/CDS/CRTCL/CR_UNT_FNCTN', '07', 'CM_NHS_DD', 'CM_Ccufadult7'),                    -- TODO: Capital "A"?
('/CDS/CRTCL/CR_UNT_FNCTN', '08', 'CM_NHS_DD', 'CM_CcufAdult8'),
('/CDS/CRTCL/CR_UNT_FNCTN', '09', 'CM_NHS_DD', 'CM_CcufAdult9'),
('/CDS/CRTCL/CR_UNT_FNCTN', '10', 'CM_NHS_DD', 'CM_CcufAdult10'),
('/CDS/CRTCL/CR_UNT_FNCTN', '11', 'CM_NHS_DD', 'CM_CcufAdult11'),
('/CDS/CRTCL/CR_UNT_FNCTN', '12', 'CM_NHS_DD', 'CM_Ccufadult12'),                    -- TODO: Capital "A"?
('/CDS/CRTCL/CR_UNT_FNCTN', '90', 'CM_NHS_DD', 'CM_Ccufadult90'),                    -- TODO: Capital "A"?
('/CDS/CRTCL/CR_UNT_FNCTN', '04', 'CM_NHS_DD', 'CM_CcufChild4'),
('/CDS/CRTCL/CR_UNT_FNCTN', '16', 'CM_NHS_DD', 'CM_CcufChild16'),
('/CDS/CRTCL/CR_UNT_FNCTN', '17', 'CM_NHS_DD', 'CM_CcufChild17'),
('/CDS/CRTCL/CR_UNT_FNCTN', '18', 'CM_NHS_DD', 'CM_CcufChild18'),
('/CDS/CRTCL/CR_UNT_FNCTN', '19', 'CM_NHS_DD', 'CM_CcufChild19'),
('/CDS/CRTCL/CR_UNT_FNCTN', '92', 'CM_NHS_DD', 'CM_CcufChild92'),
('/CDS/CRTCL/CR_UNT_FNCTN', '13', 'CM_NHS_DD', 'CM_CcufNeonate13'),
('/CDS/CRTCL/CR_UNT_FNCTN', '14', 'CM_NHS_DD', 'CM_CcufNeonate14'),
('/CDS/CRTCL/CR_UNT_FNCTN', '15', 'CM_NHS_DD', 'CM_CcufNeonate15'),
('/CDS/CRTCL/CR_UNT_FNCTN', '91', 'CM_NHS_DD', 'CM_CcuOther91'),

('/CDS/CRTCL/ADMSSN_SRC', '01', 'CM_NHS_DD', 'CM_CriticalCareSource1'),
('/CDS/CRTCL/ADMSSN_SRC', '02', 'CM_NHS_DD', 'CM_CriticalCareSource2'),
('/CDS/CRTCL/ADMSSN_SRC', '03', 'CM_NHS_DD', 'CM_CriticalCareSource3'),
('/CDS/CRTCL/ADMSSN_SRC', '04', 'CM_NHS_DD', 'CM_CriticalCareSource4'),
('/CDS/CRTCL/ADMSSN_SRC', '05', 'CM_NHS_DD', 'CM_CriticalCareSource5'),


('/CDS/CRTCL/ADMSSN_TYP', '01', 'CM_NHS_DD', 'CM_CritCareAdmType01'),
('/CDS/CRTCL/ADMSSN_TYP', '02', 'CM_NHS_DD', 'CM_CritCareAdmType02'),
('/CDS/CRTCL/ADMSSN_TYP', '03', 'CM_NHS_DD', 'CM_CritCareAdmType03'),
('/CDS/CRTCL/ADMSSN_TYP', '04', 'CM_NHS_DD', 'CM_CritCareAdmType04'),
('/CDS/CRTCL/ADMSSN_TYP', '05', 'CM_NHS_DD', 'CM_CritCareAdmType05'),
('/CDS/CRTCL/ADMSSN_TYP', '06', 'CM_NHS_DD', 'CM_CritCareAdmType06'),

('/CDS/CRTCL/ADMSSN_LCTN', '01', 'CM_NHS_DD', 'CM_CritCareSrcLctn01'),
('/CDS/CRTCL/ADMSSN_LCTN', '02', 'CM_NHS_DD', 'CM_CritCareSrcLctn02'),
('/CDS/CRTCL/ADMSSN_LCTN', '03', 'CM_NHS_DD', 'CM_CritCareSrcLctn03'),
('/CDS/CRTCL/ADMSSN_LCTN', '04', 'CM_NHS_DD', 'CM_CritCareSrcLctn04'),
('/CDS/CRTCL/ADMSSN_LCTN', '05', 'CM_NHS_DD', 'CM_CritCareSrcLctn05'),
('/CDS/CRTCL/ADMSSN_LCTN', '06', 'CM_NHS_DD', 'CM_CritCareSrcLctn06'),
('/CDS/CRTCL/ADMSSN_LCTN', '07', 'CM_NHS_DD', 'CM_CritCareSrcLctn07'),
('/CDS/CRTCL/ADMSSN_LCTN', '08', 'CM_NHS_DD', 'CM_CritCareSrcLctn08'),
('/CDS/CRTCL/ADMSSN_LCTN', '09', 'CM_NHS_DD', 'CM_CritCareSrcLctn09'),
('/CDS/CRTCL/ADMSSN_LCTN', '10', 'CM_NHS_DD', 'CM_CritCareSrcLctn10'),
('/CDS/CRTCL/ADMSSN_LCTN', '11', 'CM_NHS_DD', 'CM_CritCareSrcLctn11'),
('/CDS/CRTCL/ADMSSN_LCTN', '12', 'CM_NHS_DD', 'CM_CritCareSrcLctn12'),

('/CDS/CRTCL/DSCHRG_STTS', '01', 'CM_NHS_DD', 'CM_CritCareDschgStts01'),
('/CDS/CRTCL/DSCHRG_STTS', '02', 'CM_NHS_DD', 'CM_CritCareDschgStts02'),
('/CDS/CRTCL/DSCHRG_STTS', '03', 'CM_NHS_DD', 'CM_CritCareDschgStts03'),
('/CDS/CRTCL/DSCHRG_STTS', '04', 'CM_NHS_DD', 'CM_CritCareDschgStts04'),
('/CDS/CRTCL/DSCHRG_STTS', '05', 'CM_NHS_DD', 'CM_CritCareDschgStts05'),
('/CDS/CRTCL/DSCHRG_STTS', '06', 'CM_NHS_DD', 'CM_CritCareDschgStts06'),
('/CDS/CRTCL/DSCHRG_STTS', '07', 'CM_NHS_DD', 'CM_CritCareDschgStts07'),
('/CDS/CRTCL/DSCHRG_STTS', '08', 'CM_NHS_DD', 'CM_CritCareDschgStts08'),
('/CDS/CRTCL/DSCHRG_STTS', '09', 'CM_NHS_DD', 'CM_CritCareDschgStts09'),
('/CDS/CRTCL/DSCHRG_STTS', '10', 'CM_NHS_DD', 'CM_CritCareDschgStts10'),
('/CDS/CRTCL/DSCHRG_STTS', '11', 'CM_NHS_DD', 'CM_CritCareDschgStts11'),

('/CDS/CRTCL/DSCHRG_DSTNTN', '01', 'CM_NHS_DD', 'CM_CritCareDschgDest01'),
('/CDS/CRTCL/DSCHRG_DSTNTN', '02', 'CM_NHS_DD', 'CM_CritCareDschgDest02'),
('/CDS/CRTCL/DSCHRG_DSTNTN', '03', 'CM_NHS_DD', 'CM_CritCareDschgDest03'),
('/CDS/CRTCL/DSCHRG_DSTNTN', '04', 'CM_NHS_DD', 'CM_CritCareDschgDest04'),
('/CDS/CRTCL/DSCHRG_DSTNTN', '05', 'CM_NHS_DD', 'CM_CritCareDschgDest05'),
('/CDS/CRTCL/DSCHRG_DSTNTN', '06', 'CM_NHS_DD', 'CM_CritCareDschgDest06'),

('/CDS/CRTCL/DSCHRG_LCTN', '01', 'CM_NHS_DD', 'CM_CritCareDschgLctn01'),
('/CDS/CRTCL/DSCHRG_LCTN', '02', 'CM_NHS_DD', 'CM_CritCareDschgLctn02'),
('/CDS/CRTCL/DSCHRG_LCTN', '03', 'CM_NHS_DD', 'CM_CritCareDschgLctn03'),
('/CDS/CRTCL/DSCHRG_LCTN', '04', 'CM_NHS_DD', 'CM_CritCareDschgLctn04'),
('/CDS/CRTCL/DSCHRG_LCTN', '05', 'CM_NHS_DD', 'CM_CritCareDschgLctn05'),
('/CDS/CRTCL/DSCHRG_LCTN', '06', 'CM_NHS_DD', 'CM_CritCareDschgLctn06'),
('/CDS/CRTCL/DSCHRG_LCTN', '07', 'CM_NHS_DD', 'CM_CritCareDschgLctn07'),
('/CDS/CRTCL/DSCHRG_LCTN', '08', 'CM_NHS_DD', 'CM_CritCareDschgLctn08'),
('/CDS/CRTCL/DSCHRG_LCTN', '09', 'CM_NHS_DD', 'CM_CritCareDschgLctn09'),
('/CDS/CRTCL/DSCHRG_LCTN', '10', 'CM_NHS_DD', 'CM_CritCareDschgLctn10')
;
