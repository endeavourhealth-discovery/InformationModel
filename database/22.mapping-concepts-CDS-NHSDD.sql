INSERT IGNORE INTO concept
(document, id, name, description)
VALUES
(1, 'CM_DiscoveryCode', 'Discovery code', 'Discovery (core) coding scheme ');

SELECT @scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
-- GENERAL/GLOBAL --
(1, 'CM_Org_Barts', @scm, 'CM_Org_Barts', 'Barts Hospital', 'Barts NHS Trust Hospital'),
(1, 'CM_Sys_Cerner', @scm, 'CM_Sys_Cerner', 'Cerner Millennium', 'Cerner Millennium system'),
(1, 'CM_NHS_DD', @scm, 'CM_NHS_DD', 'NHS Data Dictionary', 'NHS Data Dictionary coding scheme'),
(1, 'CM_CDS', @scm, 'CM_CDS', 'CDS Local code', 'Local CDS code'),

-- EMERGENCY --
(1, 'DM_aAndEDepartmentType', @scm, 'DM_aAndEDepartmentType', 'A&E Department', 'Accident and Emergency department type'),
(1, 'CM_AEDepType1', @scm, 'CM_AEDepType1', 'Consultant led A&E department with full facilities (department type)', 'Emergency departments are a CONSULTANT led 24 hour service with full resuscitation facilities and designated accommodation for the reception of accident and emergency PATIENTS CDS type 1'),
(1, 'CM_AEDepType2', @scm, 'CM_AEDepType2', 'Mono speciality A&E (department type)', 'Consultant led mono specialty accident and emergency service (e.g. ophthalmology, dental) with designated accommodation for the reception of PATIENTS CDS 2'),
(1, 'CM_AEDepType3', @scm, 'CM_AEDepType3', 'Minor injuries unit either Doctor or Nurse led (department type)', 'Other type of A&E/minor injury ACTIVITY with designated accommodation for the reception of accident and emergency PATIENTS. CDS 3'),
(1, 'CM_AEDepType4', @scm, 'CM_AEDepType4', 'NHS Walk in centre (department type)', 'NHS walk in centres CDS 4'),
(1, 'CM_AEDepType5', @scm, 'CM_AEDepType5', 'Ambulatory Emergency Care Service', 'Ambulatory Emergency Care Service'),

(1, 'DM_arrivalMode', @scm, 'DM_arrivalMode', 'Arrival Mode', 'Mode of arrival'),

(1, 'DM_aeAttendanceCategory', @scm, 'DM_aeAttendanceCategory', 'has a&e category of attendance of', 'points to the category of attendance whether first, subsequent, planned or unplanned'),
(1, 'CM_AEAttCat1', @scm, 'CM_AEAttCat1', 'Unplanned First Emergency Care Attendance for a new clinical condition.', 'Unplanned First Emergency Care Attendance for a new clinical condition (or deterioration of a chronic condition). CDS 1'),
(1, 'CM_AEAttCat2', @scm, 'CM_AEAttCat2', 'Unplanned Follow-up Emergency Care Attendance for the same or a related condition at this department', 'Unplanned Follow-up Emergency Care Attendance for the same or a related clinical condition and within 7 days of the First Emergency Care Attendance at THIS Emergency Care Department CDS 2'),
(1, 'CM_AEAttCat3', @scm, 'CM_AEAttCat3', 'Unplanned Follow-up Emergency Care Attendance for the same or a related condition at another department', 'Unplanned Follow-up Emergency Care Attendance for the same or a related clinical condition and within 7 days of the First Emergency Care Attendance at ANOTHER Emergency Care Department CDS 3'),
(1, 'CM_AEAttCat4', @scm, 'CM_AEAttCat4', 'Planned Follow-up Emergency Care Attendance', 'Planned Follow-up Emergency Care Attendance within 7 days of the First Emergency Care Attendance at THIS Emergency Care Department CDS 4'),

(1, 'DM_aeAttendanceSource', @scm, 'DM_aeAttendanceSource', 'A&E Attendance source', 'Source of attendance to A&D'),
(1, 'DM_treatmentFunctionAdmit', @scm, 'DM_treatmentFunctionAdmit', 'Treatment function', 'Treatment function code'),
(1, 'DM_hasDischargeDestination', @scm, 'DM_hasDischargeDestination', 'Discharge destination', 'Destination to which the patient was discharged'),
(1, 'DM_dischargeStatus', @scm, 'DM_dischargeStatus', 'Discharge status', 'The status of the patient discharge'),
(1, 'DM_dischargeFollowUp', @scm, 'DM_dischargeFollowUp', 'Discharge follow-up', 'The follow-up for the patient discharge'),
(1, 'DM_referredToServices', @scm, 'DM_referredToServices', 'Discharge referred to services', 'The services the patient was referred to on discharge'),


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
(1, 'CM_Gender9', @scm, 'CM_Gender9', 'Not Specified', 'Not Specified'),

-- OUTPATIENT --
(1, 'DM_attendanceStatus', @scm, 'DM_attendanceStatus', 'has attendance status', 'points to whether the patient attended or not'),
(1, 'CM_AttNotAtt5', @scm, 'CM_AttNotAtt5', 'Attended on time or before the professional was ready to see the patient', 'Attended on time or, if late, before the relevant CARE PROFESSIONAL was ready to see the PATIENT CDS 5'),
(1, 'CM_AttNotAtt6', @scm, 'CM_AttNotAtt6', 'Arrived late, after the professional was ready to see the patient, but was seen', 'Arrived late, after the relevant CARE PROFESSIONAL was ready to see the PATIENT, but was seen CDS 6'),
(1, 'CM_AttNotAtt7', @scm, 'CM_AttNotAtt7', 'Arrived late and could not be seen', 'PATIENT arrived late and could not be seen CDS 7'),
(1, 'CM_AttNotAtt2', @scm, 'CM_AttNotAtt2', 'Cancelled by, or on behalf of, the patient', 'APPOINTMENT cancelled by, or on behalf of, the PATIENT CDS 2'),
(1, 'CM_AttnotAtt3', @scm, 'CM_AttnotAtt3', 'Did not attend  with no advance warning', 'Did not attend - no advance warning given CDS 3'),
(1, 'CM_AttnotAtt4', @scm, 'CM_AttnotAtt4', 'Cancelled or postponed by the Health Care Provider', 'APPOINTMENT cancelled or postponed by the Health Care Provider CDS 4'),
(1, 'CM_AttNotAtt00', @scm, 'CM_AttNotAtt00', 'Not applicable - appointment occurs in the future', 'Not applicable - APPOINTMENT occurs in the future CDS 0'),

(1, 'DM_hasAttendanceOutcome', @scm, 'DM_hasAttendanceOutcome', 'has attendance outcome', 'points to the outcome of the attendance'),
(1, 'CM_AttOpd1', @scm, 'CM_AttOpd1', 'Discharged from care - last attendance', 'Discharged from CONSULTANT''s care (last attendance) CDS 1'),
(1, 'CM_AttOpd2', @scm, 'CM_AttOpd2', 'Another appointment given', 'Another APPOINTMENT given CDS 2'),
(1, 'CM_AttOpd3', @scm, 'CM_AttOpd3', 'Appointment to be made at a later date', 'APPOINTMENT to be made at a later date CDS 3'),

-- DM_adminCategoryonAdmission - Inpatient above
-- CM_AdminCat01 - Inpatient above
-- CM_AdminCat02 - Inpatient above
-- CM_AdminCat03 - Inpatient above
-- CM_AdminCat04 - Inpatient above

(1, 'DM_referralSource', @scm, 'DM_referralSource', 'Referral source', 'Source of the referral'),
(1, 'CM_OutRefSrc01', @scm, 'CM_OutRefSrc01', 'CONSULTANT initiated following an emergency admission', 'CONSULTANT initiated following an emergency admission'),
(1, 'CM_OutRefSrc02', @scm, 'CM_OutRefSrc02', 'CONSULTANT initiated following a Domiciliary Consultation', 'CONSULTANT initiated following a Domiciliary Consultation'),
(1, 'CM_OutRefSrc10', @scm, 'CM_OutRefSrc10', 'CONSULTANT initiated following an Accident and Emergency Attendance', 'CONSULTANT initiated following an Accident and Emergency Attendance (including Minor Injuries Units and Walk In Centres)'),
(1, 'CM_OutRefSrc11', @scm, 'CM_OutRefSrc11', 'CONSULTANT initiated: Other', 'CONSULTANT initiated: Other (not listed)'),
(1, 'CM_OutRefSrc03', @scm, 'CM_OutRefSrc03', 'CONSULTANT not initiated following a referral from a GENERAL MEDICAL PRACTITIONER', 'CONSULTANT not initiated following a referral from a GENERAL MEDICAL PRACTITIONER'),
(1, 'CM_OutRefSrc92', @scm, 'CM_OutRefSrc92', 'CONSULTANT not initiated following a referral from a GENERAL DENTAL PRACTITIONER', 'CONSULTANT not initiated following a referral from a GENERAL DENTAL PRACTITIONER'),
(1, 'CM_OutRefSrc12', @scm, 'CM_OutRefSrc12', 'CONSULTANT not initiated following a referral from a GPwER or DES', 'CONSULTANT not initiated following a referral from a General Practitioner with an Extended Role (GPwER) or Dentist with Enhanced Skills (DES)'),
(1, 'CM_OutRefSrc04', @scm, 'CM_OutRefSrc04', 'CONSULTANT not initiated following a referral from an A&E Department', 'CONSULTANT not initiated following a referral from an Accident and Emergency Department (including Minor Injuries Units and Walk In Centres)'),
(1, 'CM_OutRefSrc05', @scm, 'CM_OutRefSrc05', 'CONSULTANT not initiated following a referral from a CONSULTANT, other than in an A&E Department', 'CONSULTANT not initiated following a referral from a CONSULTANT, other than in an Accident and Emergency Department'),
(1, 'CM_OutRefSrc06', @scm, 'CM_OutRefSrc06', 'CONSULTANT not initiated following a self-referral', 'CONSULTANT not initiated following a self-referral'),
(1, 'CM_OutRefSrc07', @scm, 'CM_OutRefSrc07', 'CONSULTANT not initiated following a referral from a Prosthetist', 'CONSULTANT not initiated following a referral from a Prosthetist'),
(1, 'CM_OutRefSrc13', @scm, 'CM_OutRefSrc13', 'CONSULTANT not initiated following a referral from a Specialist NURSE', 'CONSULTANT not initiated following a referral from a Specialist NURSE (Secondary Care)'),
(1, 'CM_OutRefSrc14', @scm, 'CM_OutRefSrc14', 'CONSULTANT not initiated following a referral from an Allied Health Professional', 'CONSULTANT not initiated following a referral from an Allied Health Professional'),
(1, 'CM_OutRefSrc15', @scm, 'CM_OutRefSrc15', 'CONSULTANT not initiated following a referral from an OPTOMETRIST', 'CONSULTANT not initiated following a referral from an OPTOMETRIST'),
(1, 'CM_OutRefSrc16', @scm, 'CM_OutRefSrc16', 'CONSULTANT not initiated following a referral from an Orthoptist', 'CONSULTANT not initiated following a referral from an Orthoptist'),
(1, 'CM_OutRefSrc17', @scm, 'CM_OutRefSrc17', 'CONSULTANT not initiated following a referral from a National Screening Programme', 'CONSULTANT not initiated following a referral from a National Screening Programme'),
(1, 'CM_OutRefSrc93', @scm, 'CM_OutRefSrc93', 'CONSULTANT not initiated following a referral from a Community Dental Service', 'CONSULTANT not initiated following a referral from a Community Dental Service'),
(1, 'CM_OutRefSrc97', @scm, 'CM_OutRefSrc97', 'CONSULTANT not initiated following a referral: Other', 'CONSULTANT not initiated following a referral: Other (not listed)'),


-- DM_treatmentFunctionAdmit - Emergency above

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

-- Code scheme prefix entries
INSERT IGNORE INTO concept_property_data
(`dbid`, `group`, `property`, `value`)
SELECT c.dbid, 0 AS `group`, p.dbid AS `property`, '' AS `value`
FROM concept c
JOIN concept p ON p.id = 'code_prefix'
WHERE c.id IN ('CM_DiscoveryCode', 'CM_NHS_DD', 'CM_CDS');
