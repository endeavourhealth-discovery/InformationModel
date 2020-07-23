USE im_live_july2020;

-- **************************************** 5. Migrate COT_ to their CM/DM equivalents ****************************************
-- Encounter IRI migration
DROP TABLE IF EXISTS tmp_encounter_migration;
CREATE TEMPORARY TABLE tmp_encounter_migration (
	oldId VARCHAR(140) COLLATE utf8_bin NOT NULL,
    newId VARCHAR(140) COLLATE utf8_bin NOT NULL
) ENGINE = Memory;

-- Switch IRI's
INSERT INTO tmp_encounter_migration (oldId, newId)
VALUES 
('COT_AdministrativeEntry', 'CM_AdministrativeEntry'),
('COT_CancelHospEvent', 'CM_CancelHospEvent'),
('COT_ComputerEncounter', 'CM_ComputerEncounter'),
('COT_Consultation', 'CM_Consultation'),
('COT_DidNotAttendEncounter', 'CM_DidNotAttendEncounter'),
('COT_EmailConsultation', 'CM_EmailConsultation'),
('COT_EncounterUsingDevice', 'CM_EncounterUsingDevice'),
('COT_Encowincu', 'CM_Encowincu'),
('COT_EndHospEvent', 'CM_EndHospEvent'),
('COT_FilingDocEncounter', 'CM_FilingDocEncounter'),
('COT_GPSurgeryConsultation', 'CM_GPSurgeryConsultation'),
('COT_HomeVisit', 'CM_HomeVisit'),
('COT_HospOpdEncounter', 'DM_HospitalOpdEntry'),
('COT_HospitalAdmissionEncounter', 'DM_HospitalAdmitEntry'),
('COT_HospitalInpAdmitEncounter', 'CM_HospitalInpAdmitEncounter'),
('COT_HospitalInpDischEncounter', 'CM_HospitalInpDischEncounter'),
('COT_HospitalInpEncounter', 'DM_HospitalInpEntry'),
('COT_HospitalPreadmission', 'CM_HospitalPreadmission'),
('COT_MailToPatientEncounter', 'CM_MailToPatientEncounter'),
('COT_MaternityAdmission', 'CM_MaternityAdmission'),
('COT_NightVisit', 'CM_NightVisit'),
('COT_NoteEncounter', 'CM_NoteEncounter'),
('COT_OnPremiseEncounter', 'CM_OnPremiseEncounter'),
('COT_SurgeryPodEncounter', 'CM_SurgeryPodEncounter'),
('COT_TeamMeeting', 'CM_TeamMeeting'),
('COT_TelephoneConsultation', 'CM_TelephoneConsultation'),
('COT_TelephoneTriage', 'CM_TelephoneTriage'),
('COT_ThirdPartyConsultation', 'CM_ThirdPartyConsultation'),
('COT_ThirdPartyTelcon', 'CM_ThirdPartyTelcon'),
('COT_Transfer', 'CM_Transfer'),
('COT_TransferInpOp', 'CM_TransferInpOp'),
('COT_TransferOpInp', 'CM_TransferOpInp'),
('COT_TransferWlInpOp', 'CM_TransferWlInpOp'),
('COT_TransferWlOpInp', 'CM_TransferWlOpInp'),
('COT_TriageAssessmentEncounter', 'CM_TriageAssessmentEncounter'),
('COT_UpdateRecordEncounter', 'CM_UpdateRecordEncounter'),
('COT_VideoConsultation', 'CM_VideoConsultation'),
('COT_WlPreadmit', 'CM_WlPreadmit')
;

UPDATE concept c
JOIN tmp_encounter_migration m ON m.oldId = c.id
SET c.id = m.newId
;

-- **************************************** 6. Add in any missing CM/DM ****************************************
-- Ensure code scheme exists
INSERT IGNORE INTO concept
(document, id, name, description, code)
VALUES
(1, 'CM_DiscoveryCode', 'Discovery code', 'Discovery core code for value based concepts. Always the same as the IRI affix after the Discovery baseline IRI of http://www.DiscoveryDataService.org/InformationModel#', 'CM_DiscoveryCode');

SELECT @core_scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';

UPDATE concept SET scheme = @core_scm WHERE id = 'CM_DiscoveryCode';

-- New/missing encounter types
SELECT @core_scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';
SELECT @snomed_scm := dbid FROM concept WHERE id = 'SNOMED';
SELECT @ctv3_scm := dbid FROM concept WHERE id = 'CTV3';

SELECT * FROM im_next.concept WHERE iri = ':DM_PatientEvent';

INSERT INTO concept
(document, id, name, description, scheme, code)
VALUES
(1, 'CM_DiscoveryCode', 'Discovery code', 'Discovery core code for value based concepts. Always the same as the IRI affix after the Discovery baseline IRI of http://www.DiscoveryDataService.org/InformationModel#', null, null),
(1, 'DM_PatientEvent', 'Patient health event', 'An health event relating to the patient.', null, null),
(1, 'DM_EncounterEntry', 'Encounter', 'A record entry about an encounter, which is an interaction between a patient (or on behalf of the patient) and a health professional or health provider.', null, null),
(1, 'DM_HospitalDischEntry', 'Hospital discharge (entry)', 'An entry describing the event of a hospital discharge. Has specialised encounter properties', null, null),
(1, 'CM_NeonatalCriticalCareEncounter', 'Neonatal critical care encounter', 'A critical care period for a neonate', null, null),
(1, 'DM_AandEEncounterEntry', 'Accident and emergency encounter', 'An entry recording an encounter in the A&E unit. Specialised properties', null, null),
(1, 'CM_HospitalDayCaseDischarge', 'Day case discharge', 'Discharge at the end of a daya case encounter', null, null),
(1, 'CM_MaternityDischarge', 'Maternity discharge', 'Dsicharge after a maternity attendance whether inpatient or outpatient or day case', null, null),
(1, 'CM_AdultCriticalCareEncounter', 'Adult critical care encounter', 'criticl care period for an adult', null, null),
(1, 'CM_TextMessageEncounter', 'Text message consultation', 'Text message whatsapp or equivalent form of communication from the patient, noted as a form of consultation. Does not include SMS text message reminders to the patient', null, null),
(1, 'CM_HospitalEncounter', 'Hospital encounter', 'A sort of encounter or encounter process that takes place in hospital', null, null),
(1, 'CM_CancelledEncounter', 'Cancellation of encounter', 'An event which cancels a previous encounter', null, null),
(1, 'CM_HospitalDayCase', 'Hospital day case encounter', 'Day case encounter', null, null),
(1, 'CM_TransferWl', 'Transfer on waiting list	', '', null, null),
(1, 'CM_AandEAttendanceEnd', 'Accident and emergency encounter discharge', 'End of the A&E attendance including transfer', null, null),
(1, 'CM_OutpatientDischarge', 'Outpatient discharge', 'End of an outpatient attendance', null, null),
(1, 'DM_CriticalCareEntry', 'Critical care encounter', 'An entry recording information about a criticial care encounter', null, null),
(1, 'CM_ClinicEncounter', 'Clinic or health centre consultation', 'A consultation that occurs in primary care premises such as a nurse or GP run clinic', null, null),
(1, 'CM_PaediatricCriticalCareEncounter', 'Paediatric critical care encounter', 'A critical care period for a child', null, null),
(1, 'CM_TransferCareClassification', 'Transfer care classification', 'Transfers a care classification', null, null),
(1, 'SN_16361000000102', 'Assessment (record artifact)', 'Assessment (record artifact)', @snomed_scm, '16361000000102'),
(1, 'SN_717621000000103', 'Assessment (record artifact)', 'Assessment (record artifact)', @snomed_scm, '717621000000103')
;

-- **************************************** 7(a). Replace IMv1 CM/DM/LE relationships to match IMv2 ****************************************
SELECT @is_a := dbid, id, name FROM concept c WHERE id = 'SN_116680003';

DELETE cpo
FROM concept_property_object cpo
JOIN concept c ON c.dbid = cpo.dbid
JOIN im_next.encounter_concepts ec ON ec.iri = c.id
WHERE cpo.property = @is_a
;

DELETE cpo
FROM concept_property_object cpo
JOIN concept c ON c.dbid = cpo.value
JOIN im_next.encounter_concepts ec ON ec.iri = c.id
WHERE cpo.property = @is_a
;

INSERT INTO concept_property_object
(dbid, property, value)
SELECT c.dbid, @is_a, v.dbid
FROM im_next.encounter_cpo cpo
LEFT JOIN concept c ON c.id = cpo.parentIri
LEFT JOIN concept v ON v.id = cpo.childIri
;

-- **************************************** 8. Replace IMv1 LE to CM/DM maps to match IMv2 ****************************************
SELECT @equiv := dbid, id, name FROM concept c WHERE id = 'is_equivalent_to';

DELETE cpo
FROM concept_property_object cpo
JOIN concept c ON c.dbid = cpo.dbid
JOIN im_next.encounter_concepts ec ON ec.iri = c.id
WHERE cpo.property = @equiv
;

DELETE cpo
FROM concept_property_object cpo
JOIN concept c ON c.dbid = cpo.value
JOIN im_next.encounter_concepts ec ON ec.iri = c.id
WHERE cpo.property = @equiv
;

INSERT INTO concept_property_object
(dbid, property, value)
SELECT c.dbid, @equiv, v.dbid
FROM im_next.encounter_maps map
LEFT JOIN concept c ON c.id = map.legacyIri
LEFT JOIN concept v ON v.id = map.coreIri
;
