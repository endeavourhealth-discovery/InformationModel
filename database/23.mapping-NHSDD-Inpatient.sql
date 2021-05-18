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
-- INPATIENT --
(1, 'DM_methodOfAdmssion', @scm, 'DM_methodOfAdmssion', 'has admission method', 'Points to the method of admission such as whether from waiting list, booked or from A&e or direct from GP'),
(1, 'CM_AdmMethWa', @scm, 'CM_AdmMethWa', 'Waiting list (admission method)', 'Method of actual admission was electively from the waiting list CDS type 11'),
(1, 'CM_AdmMetBooked', @scm, 'CM_AdmMetBooked', 'Booked admission (admssion method)', 'Elective booked admission CDS type 12'),
(1, 'CM_AdmMetPlanned', @scm, 'CM_AdmMetPlanned', 'Planned admission (admission method)', 'Planned admission - CDS type 13'),
(1, 'CM_AdmMetCasSame', @scm, 'CM_AdmMetCasSame', 'Emergency admission from same trust', 'Emergency admission from same trust - CDS type 21'),
(1, 'CM_AdmMetGpDirect', @scm, 'CM_AdmMetGpDirect', 'Emergency admission direct from GP', 'Emergency admission via GENERAL PRACTITIONER: after a request for immediate admission has been made direct to a Hospital Provider, i.e. not through a Bed bureau, by a GENERAL PRACTITIONER or deputy - CDS type 22'),
(1, 'CM_AdmMetBedBureau', @scm, 'CM_AdmMetBedBureau', 'Emergency admission via bed bureau', 'after a request for immediate admission has been made direct to a Hospital Provider from a bed bureau - CDS type 23'),
(1, 'CM_AdmMetConClin', @scm, 'CM_AdmMetConClin', 'Emergency admission from consultant clinic', 'Emergency admission from Consultant Clinic, of this or another Health Care Provider - CDS type 24'),
(1, 'CM_AdmMetMheCrisis', @scm, 'CM_AdmMetMheCrisis', 'Emergency admission via mental health crisis resolution team', 'Admission via Mental Health Crisis Resolution Team CDS type 25'),
(1, 'CM_AdmMetCasElsewhere', @scm, 'CM_AdmMetCasElsewhere', 'Emergency admission from A&E  from another provider', 'Emergency admission from Accident and Emergency Department of another provider where the PATIENT had not been admitted CDS type 2A'),
(1, 'CM_AdmMetHosTran', @scm, 'CM_AdmMetHosTran', 'Emergency admission - transfer of admitted patient from another hospital', 'Emergency admission - Transfer of an admitted PATIENT from another Hospital Provider in an emergency - CDS type 2B'),
(1, 'CM_AdmMetBBhok', @scm, 'CM_AdmMetBBhok', 'Emergency admission after baby born at home as intended', 'Emergency admission after Baby born at home as intended CDS type 2C'),
(1, 'CM_AdmMetEMore', @scm, 'CM_AdmMetEMore', 'Emergency admission via other or none specific means', 'Emergency admission - Other emergency admission CDS type 2D replacing  CDS type 28 also'),
(1, 'CM_AdmMetMatAP', @scm, 'CM_AdmMetMatAP', 'Maternity admission ante partum', 'Maternit admission antepartum CDS type 31'),
(1, 'CM_AdmMetMatPP', @scm, 'CM_AdmMetMatPP', 'Maternity admission post partum', 'Maternity admission post partum CDS type 32'),
(1, 'CM_AdmMetBirthHere', @scm, 'CM_AdmMetBirthHere', 'Birth of a baby in this Health Care Provider', 'Birth of a baby in this Health Care Provider CDS type 82'),
(1, 'CM_AdmMetBirthOut', @scm, 'CM_AdmMetBirthOut', 'Baby born outside the Health Care Provider except when born at home as intended', 'Baby born outside the Health Care Provider except when born at home as intended type 83'),
(1, 'CM_AdmNonETransfer', @scm, 'CM_AdmNonETransfer', 'Non emergency transfer from other provider', 'Transfer of any admitted PATIENT from other Hospital Provider other than in an emergency cds TYPE 81'),

(1, 'DM_sourceOfAdmission', @scm, 'DM_sourceOfAdmission', 'has admission source', 'Points to the source of admission of the patient'),
(1, 'CM_SrcAdmUsual', @scm, 'CM_SrcAdmUsual', 'Usual place of residence', 'Usual place of residence unless listed below, for example, a private dwelling whether owner occupied or owned by Local Authority, housing association or other landlord. CDS type 19'),
(1, 'CM_SrcAdmTempR', @scm, 'CM_SrcAdmTempR', 'Temporary place of residence', 'Tempprary place of residence when usually resident elsewhere (e.g. hotels, residential Educational Establishments CDS type 29'),
(1, 'CM_SrcAdmPePoCo', @scm, 'CM_SrcAdmPePoCo', 'Penal establishment, Court, or Police Station / Police Custody Suite', 'Penal establishment, Court, or Police Station / Police Custody Suite CDS types 39,40,41,42'),
(1, 'CM_SrcAdmPe', @scm, 'CM_SrcAdmPe', 'Penal establishment', 'Penal establishment CDS type 40'),
(1, 'CM_SrcAdmCo', @scm, 'CM_SrcAdmCo', 'Court', 'A court such as a HM Court CDS type 41, 37'),
(1, 'CM_SrcAdmPo', @scm, 'CM_SrcAdmPo', 'Police Station / Police Custody Suite', 'Police Station / Police Custody Suite CDS type 42'),
(1, 'CM_SrcAdmPSyHosp', @scm, 'CM_SrcAdmPSyHosp', 'High security psychiatric accommodation in an NHS Hospital', 'NHS Hospital Provider - high security psychiatric accommodation in an NHS Hospital Provider (NHS Trust or NHS Foundation Trust) CDS type 49'),
(1, 'CM_SrcAdmA1', @scm, 'CM_SrcAdmA1', 'NHS Hospital  general ward / young disabled /A&E department', 'NHS other Hospital Provider - WARD for general PATIENTS or the younger physically disabled or A & E department cds ype 51'),
(1, 'CM_SrcAdmA2', @scm, 'CM_SrcAdmA2', 'NHS Hospital maternity/ neonatal ward', 'NHS other Hospital Provider - WARD for maternity PATIENTS or Neonates CDS type 52'),
(1, 'CM_SrcAdmA3', @scm, 'CM_SrcAdmA3', 'Another NHS hospital ward for mental health or learning difficulties', 'NHS other Hospital Provider - WARD for PATIENTS who are mentally ill or have Learning Disabilities CDS type 53'),
(1, 'CM_SrcAdmA4', @scm, 'CM_SrcAdmA4', 'NHS care home', 'NHS run Care Home CDS type 54'),
(1, 'CM_SrcAdmA5', @scm, 'CM_SrcAdmA5', 'Local Authority residential/care home', 'Local Authority residential accommodation i.e. where care is provided CDS type 65'),
(1, 'CM_SrcAdmA6', @scm, 'CM_SrcAdmA6', 'Local Authority foster care', 'Local Authority foster care CDS type 66'),
(1, 'CM_SrcAdmA7', @scm, 'CM_SrcAdmA7', 'Baby born in or on the way to hospital', 'Babies born in or on the way to hospital CDS type 79'),
(1, 'CM_SrcAdmA8', @scm, 'CM_SrcAdmA8', 'Non-NHS/none local authority care Home', 'Non-NHS (other than Local Authority) run Care Home CDS type 85'),
(1, 'CM_SrcAdmA9', @scm, 'CM_SrcAdmA9', 'None NHS hospital', 'Non NHS run hospital CDS type 87'),
(1, 'CM_SrcAsmA10', @scm, 'CM_SrcAsmA10', 'Non-NHS/non local authority hospice', 'Non-NHS (other than Local Authority) run Hospice CDS type 88'),

(1, 'DM_admissionPatientClassification', @scm, 'DM_admissionPatientClassification', 'has admission classification of patient', 'Points to the admissin classification of a patient e.g. elective day admission or non elective ordinay admission of maternity'),
(1, 'CM_AdmClassOrdinary', @scm, 'CM_AdmClassOrdinary', 'Ordinary non elective admission', 'A PATIENT not admitted electively, and any PATIENT admitted electively with the expectation that they will remain in hospital for at least one night, including a PATIENT admitted with this intention who leaves hospital for any reason without staying overnight. CDS 1'),
(1, 'CM_AdmClassDayCase', @scm, 'CM_AdmClassDayCase', 'Day case admission', 'A PATIENT admitted electively during the course of a day with the intention of receiving care who does not require the use of a Hospital Bed  overnight and who returns home as scheduled. If this original intention is not fulfilled and the PATIENT stays overnight, such a PATIENT should be counted as an ordinary admission CDS type 2'),
(1, 'CM_AdmClassRegularDay', @scm, 'CM_AdmClassRegularDay', 'Regular elective day admission', 'A PATIENT admitted electively during the day, as part of a planned series of regular admissions for an on-going regime of broadly similar treatment and who is discharged the same day. If the intention is not fulfilled and one of these admissions should involve a stay of at least 24 hours, such an admission should be classified as an ordinary admission.'),
(1, 'CM_AdmClassRegularNight', @scm, 'CM_AdmClassRegularNight', 'Regular elective night admission', 'A PATIENT admitted electively for the night, as part of a planned series of regular admissions for an on-going regime of broadly similar treatment and who is discharged in the morning. If the intention is not fulfilled and one of these admissions should involve a stay of at least 24 hours, such an admission should be classified as an ordinary admission.'),
(1, 'CM_AdmClassMotherBabyDelivery', @scm, 'CM_AdmClassMotherBabyDelivery', 'Mother and baby using delivery facilities only', 'Mother and baby using Delivery facilities only and not using a Hospital Bed in the Antenatal or Postnatal WARDS during the stay in hospital'),

-- DM_hasDischargeDestination - Source of admission above
-- CM_SrcAdmUsual - Source of admission above
-- CM_SrcAdmTempR - Source of admission above
(1, 'CM_DisDest30', @scm, 'CM_DisDest30', 'Repatriation from high security psychiatric NHS Hospital', 'Repatriation from high security psychiatric accommodation in an NHS Hospital Provider (NHS Trust or NHS Foundation Trust) CDS 30'),
-- CM_SrcAdmCo - Source of admission above
(1, 'CM_DisDest38', @scm, 'CM_DisDest38', 'Penal establishment or police station', 'Penal establishment or police station CDS 38'),
(1, 'CM_DisDest48', @scm, 'CM_DisDest48', 'High Security Psychiatric Hospital, Scotland', 'High Security Psychiatric Hospital, Scotland CDS 48'),
(1, 'CM_DisDest49', @scm, 'CM_DisDest49', 'High security psychiatric NHS hospital', 'NHS other Hospital Provider - high security psychiatric accommodation CDS 49'),
(1, 'CM_DisDest50', @scm, 'CM_DisDest50', 'Medium secure unit in NHS Hospital', 'NHS other Hospital Provider - medium secure unit CDS 50'),
(1, 'CM_DisDest51', @scm, 'CM_DisDest51', 'Another NHS Hospital ward for general patients or the younger physically disabled', 'NHS other Hospital Provider - WARD for general PATIENTS or the younger physically disabled CDS 51'),
-- CM_SrcAdmA2 - Source of admission above
-- CM_SrcAdmA3 - Source of admission above
-- CM_SrcAdmA4 - Source of admission above
-- CM_SrcAdmA5 - Source of admission above
-- CM_SrcAdmA6 - Source of admission above
(1, 'CM_DisDest79', @scm, 'CM_DisDest79', 'Not applicable - patient died or still birth', 'Not applicable - PATIENT died or still birth CDS 79'),
(1, 'CM_DisDest84', @scm, 'CM_DisDest84', 'Medium secure unit in non NHS hospital', 'Non-NHS run hospital - medium secure unit CDS 84'),
-- CM_SrcAdmA8 - Source of admission above
-- CM_SrcAdmA9 - Source of admission above
-- CM_SrcAdmA10 - Source of admission above

(1, 'DM_hasDischargeMethod', @scm, 'DM_hasDischargeMethod', 'has discharge method', 'Points to the method of discharge of the patient'),
(1, 'CM_DisMethod1', @scm, 'CM_DisMethod1', 'Discharged on clinical advice or with clinical consent', 'PATIENT discharged on clinical advice or with clinical consent CDS 1'),
(1, 'CM_DisMethod2', @scm, 'CM_DisMethod2', 'Discharged him/herself or was discharged by a relative or advocate', 'PATIENT discharged him/herself or was discharged by a relative or advocate CDS 2'),
(1, 'CM_DisMethod3', @scm, 'CM_DisMethod3', 'Discharged by mental health review tribunal Home Secretary or court', 'PATIENT discharged by mental health review tribunal, Home Secretary or Court CDS 3'),
(1, 'CM_DisMethod4', @scm, 'CM_DisMethod4', 'Not applicable - patient died', 'PATIENT died CDS 4'),
(1, 'CM_DisMethod5', @scm, 'CM_DisMethod5', 'StillBirth', 'Stillbirth CDS 5'),
(1, 'CM_DisMethod6', @scm, 'CM_DisMethod6', 'Discharged him/herself', 'PATIENT discharged him/herself CDS 6'),
(1, 'CM_DisMethod7', @scm, 'CM_DisMethod7', 'Discharged by a relative or advocate', 'PATIENT discharged by a relative or advocate CDS 7'),

(1, 'DM_adminCategoryonAdmission', @scm, 'DM_adminCategoryonAdmission', 'administrative category (NHS DD)', 'points to the patient administrative category at time of admission'),
(1, 'CM_AdminCat01', @scm, 'CM_AdminCat01', 'NHS PATIENT/ Overseas Visitor charged under NHS', 'NHS PATIENT, including Overseas Visitors charged under the National Health Service (Overseas Visitors Hospital Charging Regulations) CDS 01'),
(1, 'CM_AdminCat02', @scm, 'CM_AdminCat02', 'Private PATIENTusing accommodation/service authorised under the NHS', 'Private PATIENT, one who uses accommodation or SERVICES authorised under the National Health Service Act 2006 cds 02'),
(1, 'CM_AdminCat03', @scm, 'CM_AdminCat03', 'Amenity PATIENT,use of NHS single room / small ward', 'Amenity PATIENT, one who pays for the use of a single room or small ward in accordance with the National Health Service Act 2006 cds 03'),
(1, 'CM_AdminCat04', @scm, 'CM_AdminCat04', 'Category II PATIENT', 'Category II PATIENT, one for whom work is undertaken by hospital medical or dental staff within category II as defined in paragraph 37 of the Terms and Conditions of Service of Hospital Medical and Dental Staff 04'),

-- (1, 'DM_treatmentFunctionAdmit', 'Treatment function', 'Treatment function code'), -- Patched in EMERGENCY above
(1, 'DM_liveOrStillBirthIndicator', @scm, 'DM_liveOrStillBirthIndicator', 'Live or still birth indicator', 'An indication of whether the birth was a live or stillbirth'),
(1, 'CM_LiveStillBirthInd1', @scm, 'CM_LiveStillBirthInd1', 'Live', 'Live birth'),
(1, 'CM_LiveStillBirthInd2', @scm, 'CM_LiveStillBirthInd2', 'Stillbirth ante-partum', 'Stillbirth ante-partum'),
(1, 'CM_LiveStillBirthInd3', @scm, 'CM_LiveStillBirthInd3', 'Stillbirth intra-partum', 'Stillbirth intra-partum'),
(1, 'CM_LiveStillBirthInd4', @scm, 'CM_LiveStillBirthInd4', 'Stillbirth indeterminate', 'Stillbirth indeterminate'),
(1, 'CM_LiveStillBirthInd5', @scm, 'CM_LiveStillBirthInd5', 'Baby born but died later', 'Baby born but died later'),

(1, 'DM_deliveryMethod', @scm, 'DM_deliveryMethod', 'Delivery method', 'The method by which a baby is delivered, which is a REGISTRABLE BIRTH.'),
(1, 'CM_DlvryMthd0', @scm, 'CM_DlvryMthd0', 'Spontaneous vertex', 'Spontaneous vertex'),
(1, 'CM_DlvryMthd1', @scm, 'CM_DlvryMthd1', 'Spontaneous other cephalic', 'Spontaneous other cephalic'),
(1, 'CM_DlvryMthd2', @scm, 'CM_DlvryMthd2', 'Low forceps, not breech', 'Low forceps, not breech'),
(1, 'CM_DlvryMthd3', @scm, 'CM_DlvryMthd3', 'Other forceps, not breech', 'Other forceps, not breech'),
(1, 'CM_DlvryMthd4', @scm, 'CM_DlvryMthd4', 'Ventouse, vacuum extraction', 'Ventouse, vacuum extraction'),
(1, 'CM_DlvryMthd5', @scm, 'CM_DlvryMthd5', 'Breech', 'Breech'),
(1, 'CM_DlvryMthd6', @scm, 'CM_DlvryMthd6', 'Breech extraction', 'Breech extraction'),
(1, 'CM_DlvryMthd7', @scm, 'CM_DlvryMthd7', 'Elective caesarean section', 'Elective caesarean section'),
(1, 'CM_DlvryMthd8', @scm, 'CM_DlvryMthd8', 'Emergency caesarean section', 'Emergency caesarean section'),
(1, 'CM_DlvryMthd9', @scm, 'CM_DlvryMthd9', 'Other (not listed)', 'Other (not listed)'),

(1, 'DM_gender', @scm, 'DM_gender', 'Person gender', 'The classification is phenotypical rather than genotypical, i.e. it does not provide codes for medical or scientific purposes.'),
(1, 'CM_Gender0', @scm, 'CM_Gender0', 'Not Known', 'Not Known'),
(1, 'CM_Gender1', @scm, 'CM_Gender1', 'Male', 'Male'),
(1, 'CM_Gender2', @scm, 'CM_Gender2', 'Female', 'Female'),
(1, 'CM_Gender9', @scm, 'CM_Gender9', 'Not Specified', 'Not Specified')
;

-- Node maps
INSERT INTO map_node_meta
(node, concept)
VALUES
('/CDS/INPTNT/ADMSSN_MTHD',              'DM_methodOfAdmssion'),                -- NHS DD
('/CDS/INPTNT/ADMSSN_SRC',               'DM_sourceOfAdmission'),               -- NHS DD
('/CDS/INPTNT/PTNT_CLSSFCTN',            'DM_admissionPatientClassification'),  -- NHS DD
('/CDS/INPTNT/DSCHRG_DSTNTN',            'DM_hasDischargeDestination'),         -- NHS DD
('/CDS/INPTNT/DSCHRG_MTHD',              'DM_hasDischargeMethod'),              -- NHS DD
('/CDS/INPTNT/ADMNSTRV_CTGRY',           'DM_adminCategoryonAdmission'),        -- NHS DD
('/CDS/INPTNT/DLVRY_MTHD',               'DM_deliveryMethod'),                  -- NHS DD
('/CDS/INPTNT/GNDR',                     'DM_gender')                           -- NHS DD
;

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
('/CDS/INPTNT/ADMSSN_MTHD', '11', 'CM_NHS_DD', 'CM_AdmMethWa'),
('/CDS/INPTNT/ADMSSN_MTHD', '12', 'CM_NHS_DD', 'CM_AdmMetBooked'),
('/CDS/INPTNT/ADMSSN_MTHD', '13', 'CM_NHS_DD', 'CM_AdmMetPlanned'),
('/CDS/INPTNT/ADMSSN_MTHD', '21', 'CM_NHS_DD', 'CM_AdmMetCasSame'),
('/CDS/INPTNT/ADMSSN_MTHD', '22', 'CM_NHS_DD', 'CM_AdmMetGpDirect'),
('/CDS/INPTNT/ADMSSN_MTHD', '23', 'CM_NHS_DD', 'CM_AdmMetBedBureau'),
('/CDS/INPTNT/ADMSSN_MTHD', '24', 'CM_NHS_DD', 'CM_AdmMetConClin'),
('/CDS/INPTNT/ADMSSN_MTHD', '25', 'CM_NHS_DD', 'CM_AdmMetMheCrisis'),
('/CDS/INPTNT/ADMSSN_MTHD', '2A', 'CM_NHS_DD', 'CM_AdmMetCasElsewhere'),
('/CDS/INPTNT/ADMSSN_MTHD', '2B', 'CM_NHS_DD', 'CM_AdmMetHosTran'),
('/CDS/INPTNT/ADMSSN_MTHD', '2C', 'CM_NHS_DD', 'CM_AdmMetBBhok'),
('/CDS/INPTNT/ADMSSN_MTHD', '2D', 'CM_NHS_DD', 'CM_AdmMetEMore'),
('/CDS/INPTNT/ADMSSN_MTHD', '28', 'CM_NHS_DD', 'CM_AdmMetEMore'),
('/CDS/INPTNT/ADMSSN_MTHD', '31', 'CM_NHS_DD', 'CM_AdmMetMatAP'),
('/CDS/INPTNT/ADMSSN_MTHD', '32', 'CM_NHS_DD', 'CM_AdmMetMatPP'),
('/CDS/INPTNT/ADMSSN_MTHD', '82', 'CM_NHS_DD', 'CM_AdmMetBirthHere'),
('/CDS/INPTNT/ADMSSN_MTHD', '83', 'CM_NHS_DD', 'CM_AdmMetBirthOut'),
('/CDS/INPTNT/ADMSSN_MTHD', '81', 'CM_NHS_DD', 'CM_AdmNonETransfer'),

('/CDS/INPTNT/ADMSSN_SRC', '19', 'CM_NHS_DD', 'CM_SrcAdmUsual'),
('/CDS/INPTNT/ADMSSN_SRC', '29', 'CM_NHS_DD', 'CM_SrcAdmTempR'),
('/CDS/INPTNT/ADMSSN_SRC', '39', 'CM_NHS_DD', 'CM_SrcAdmPePoCo'),
('/CDS/INPTNT/ADMSSN_SRC', '40', 'CM_NHS_DD', 'CM_SrcAdmPe'),
('/CDS/INPTNT/ADMSSN_SRC', '41', 'CM_NHS_DD', 'CM_SrcAdmCo'),
('/CDS/INPTNT/ADMSSN_SRC', '42', 'CM_NHS_DD', 'CM_SrcAdmPo'),
('/CDS/INPTNT/ADMSSN_SRC', '49', 'CM_NHS_DD', 'CM_SrcAdmPSyHosp'),
('/CDS/INPTNT/ADMSSN_SRC', '51', 'CM_NHS_DD', 'CM_SrcAdmA1'),
('/CDS/INPTNT/ADMSSN_SRC', '52', 'CM_NHS_DD', 'CM_SrcAdmA2'),
('/CDS/INPTNT/ADMSSN_SRC', '53', 'CM_NHS_DD', 'CM_SrcAdmA3'),
('/CDS/INPTNT/ADMSSN_SRC', '54', 'CM_NHS_DD', 'CM_SrcAdmA4'),
('/CDS/INPTNT/ADMSSN_SRC', '65', 'CM_NHS_DD', 'CM_SrcAdmA5'),
('/CDS/INPTNT/ADMSSN_SRC', '66', 'CM_NHS_DD', 'CM_SrcAdmA6'),
('/CDS/INPTNT/ADMSSN_SRC', '79', 'CM_NHS_DD', 'CM_SrcAdmA7'),
('/CDS/INPTNT/ADMSSN_SRC', '85', 'CM_NHS_DD', 'CM_SrcAdmA8'),
('/CDS/INPTNT/ADMSSN_SRC', '87', 'CM_NHS_DD', 'CM_SrcAdmA9'),
('/CDS/INPTNT/ADMSSN_SRC', '88', 'CM_NHS_DD', 'CM_SrcAsmA10'),

('/CDS/INPTNT/PTNT_CLSSFCTN', '1', 'CM_NHS_DD', 'CM_AdmClassOrdinary'),
('/CDS/INPTNT/PTNT_CLSSFCTN', '2', 'CM_NHS_DD', 'CM_AdmClassDayCase'),
('/CDS/INPTNT/PTNT_CLSSFCTN', '3', 'CM_NHS_DD', 'CM_AdmClassRegularDay'),
('/CDS/INPTNT/PTNT_CLSSFCTN', '4', 'CM_NHS_DD', 'CM_AdmClassRegularNight'),
('/CDS/INPTNT/PTNT_CLSSFCTN', '5', 'CM_NHS_DD', 'CM_AdmClassMotherBabyDelivery'),

('/CDS/INPTNT/DSCHRG_DSTNTN', '19', 'CM_NHS_DD', 'CM_SrcAdmUsual'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '29', 'CM_NHS_DD', 'CM_SrcAdmTempR'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '30', 'CM_NHS_DD', 'CM_DisDest30'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '37', 'CM_NHS_DD', 'CM_SrcAdmCo'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '38', 'CM_NHS_DD', 'CM_DisDest38'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '48', 'CM_NHS_DD', 'CM_DisDest48'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '49', 'CM_NHS_DD', 'CM_DisDest49'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '50', 'CM_NHS_DD', 'CM_DisDest50'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '51', 'CM_NHS_DD', 'CM_DisDest51'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '52', 'CM_NHS_DD', 'CM_SrcAdmA2'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '53', 'CM_NHS_DD', 'CM_SrcAdmA3'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '54', 'CM_NHS_DD', 'CM_SrcAdmA4'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '65', 'CM_NHS_DD', 'CM_SrcAdmA5'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '66', 'CM_NHS_DD', 'CM_SrcAdmA6'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '79', 'CM_NHS_DD', 'CM_DisDest79'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '84', 'CM_NHS_DD', 'CM_DisDest84'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '85', 'CM_NHS_DD', 'CM_SrcAdmA8'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '87', 'CM_NHS_DD', 'CM_SrcAdmA9'),
('/CDS/INPTNT/DSCHRG_DSTNTN', '88', 'CM_NHS_DD', 'CM_SrcAsmA10'),

('/CDS/INPTNT/DSCHRG_MTHD', '1', 'CM_NHS_DD', 'CM_DisMethod1'),
('/CDS/INPTNT/DSCHRG_MTHD', '2', 'CM_NHS_DD', 'CM_DisMethod2'),
('/CDS/INPTNT/DSCHRG_MTHD', '3', 'CM_NHS_DD', 'CM_DisMethod3'),
('/CDS/INPTNT/DSCHRG_MTHD', '4', 'CM_NHS_DD', 'CM_DisMethod4'),
('/CDS/INPTNT/DSCHRG_MTHD', '5', 'CM_NHS_DD', 'CM_DisMethod5'),
('/CDS/INPTNT/DSCHRG_MTHD', '6', 'CM_NHS_DD', 'CM_DisMethod6'),
('/CDS/INPTNT/DSCHRG_MTHD', '7', 'CM_NHS_DD', 'CM_DisMethod7'),

('/CDS/INPTNT/ADMNSTRV_CTGRY', '01', 'CM_NHS_DD', 'CM_AdminCat01'),
('/CDS/INPTNT/ADMNSTRV_CTGRY', '02', 'CM_NHS_DD', 'CM_AdminCat02'),
('/CDS/INPTNT/ADMNSTRV_CTGRY', '03', 'CM_NHS_DD', 'CM_AdminCat03'),
('/CDS/INPTNT/ADMNSTRV_CTGRY', '04', 'CM_NHS_DD', 'CM_AdminCat04'),

('/CDS/INPTNT/LV_STLL_BRTH_INDCTR', '1', 'CM_NHS_DD', 'CM_LiveStillBirthInd1'),
('/CDS/INPTNT/LV_STLL_BRTH_INDCTR', '2', 'CM_NHS_DD', 'CM_LiveStillBirthInd2'),
('/CDS/INPTNT/LV_STLL_BRTH_INDCTR', '3', 'CM_NHS_DD', 'CM_LiveStillBirthInd3'),
('/CDS/INPTNT/LV_STLL_BRTH_INDCTR', '4', 'CM_NHS_DD', 'CM_LiveStillBirthInd4'),
('/CDS/INPTNT/LV_STLL_BRTH_INDCTR', '5', 'CM_NHS_DD', 'CM_LiveStillBirthInd5'),

('/CDS/INPTNT/DLVRY_MTHD', '0', 'CM_NHS_DD', 'CM_DlvryMthd0'),
('/CDS/INPTNT/DLVRY_MTHD', '1', 'CM_NHS_DD', 'CM_DlvryMthd1'),
('/CDS/INPTNT/DLVRY_MTHD', '2', 'CM_NHS_DD', 'CM_DlvryMthd2'),
('/CDS/INPTNT/DLVRY_MTHD', '3', 'CM_NHS_DD', 'CM_DlvryMthd3'),
('/CDS/INPTNT/DLVRY_MTHD', '4', 'CM_NHS_DD', 'CM_DlvryMthd4'),
('/CDS/INPTNT/DLVRY_MTHD', '5', 'CM_NHS_DD', 'CM_DlvryMthd5'),
('/CDS/INPTNT/DLVRY_MTHD', '6', 'CM_NHS_DD', 'CM_DlvryMthd6'),
('/CDS/INPTNT/DLVRY_MTHD', '7', 'CM_NHS_DD', 'CM_DlvryMthd7'),
('/CDS/INPTNT/DLVRY_MTHD', '8', 'CM_NHS_DD', 'CM_DlvryMthd8'),
('/CDS/INPTNT/DLVRY_MTHD', '9', 'CM_NHS_DD', 'CM_DlvryMthd9'),

('/CDS/INPTNT/GNDR', '0', 'CM_NHS_DD', 'CM_Gender0'),
('/CDS/INPTNT/GNDR', '1', 'CM_NHS_DD', 'CM_Gender1'),
('/CDS/INPTNT/GNDR', '2', 'CM_NHS_DD', 'CM_Gender2'),
('/CDS/INPTNT/GNDR', '9', 'CM_NHS_DD', 'CM_Gender9')
;
