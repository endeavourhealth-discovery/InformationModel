-- ******************** Admission Source Patch ********************

-- Property
INSERT INTO map_node_meta (node, concept)
VALUES ('/IMPRL/CRNR/ADMSSN_SRC', 'DM_sourceOfAdmission');

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
    ('/CDS/INPTNT/ADMSSN_SRC', '39a', 'CM_NHS_DD', 'CM_SrcAdmPePoCo'),      -- Temporary false map
    ('/IMPRL/CRNR/ADMSSN_SRC', '19', 'ImperialCerner', 'CM_SrcAdmUsual'),
    ('/IMPRL/CRNR/ADMSSN_SRC', '29', 'ImperialCerner', 'CM_SrcAdmTempR'),
    ('/IMPRL/CRNR/ADMSSN_SRC', '39', 'ImperialCerner', 'CM_SrcAdmPePoCo'),
    ('/IMPRL/CRNR/ADMSSN_SRC', '39a', 'ImperialCerner', 'CM_SrcAdmPePoCo'), -- Custom local
    ('/IMPRL/CRNR/ADMSSN_SRC', '40', 'ImperialCerner', 'CM_SrcAdmPe'),
    ('/IMPRL/CRNR/ADMSSN_SRC', '41', 'ImperialCerner', 'CM_SrcAdmCo'),
    ('/IMPRL/CRNR/ADMSSN_SRC', '42', 'ImperialCerner', 'CM_SrcAdmPo'),
    ('/IMPRL/CRNR/ADMSSN_SRC', '49', 'ImperialCerner', 'CM_SrcAdmPSyHosp'),
    ('/IMPRL/CRNR/ADMSSN_SRC', '51', 'ImperialCerner', 'CM_SrcAdmA1'),
    ('/IMPRL/CRNR/ADMSSN_SRC', '52', 'ImperialCerner', 'CM_SrcAdmA2'),
    ('/IMPRL/CRNR/ADMSSN_SRC', '53', 'ImperialCerner', 'CM_SrcAdmA3'),
    ('/IMPRL/CRNR/ADMSSN_SRC', '54', 'ImperialCerner', 'CM_SrcAdmA4'),
    ('/IMPRL/CRNR/ADMSSN_SRC', '65', 'ImperialCerner', 'CM_SrcAdmA5'),
    ('/IMPRL/CRNR/ADMSSN_SRC', '66', 'ImperialCerner', 'CM_SrcAdmA6'),
    ('/IMPRL/CRNR/ADMSSN_SRC', '79', 'ImperialCerner', 'CM_SrcAdmA7'),
    ('/IMPRL/CRNR/ADMSSN_SRC', '85', 'ImperialCerner', 'CM_SrcAdmA8'),
    ('/IMPRL/CRNR/ADMSSN_SRC', '87', 'ImperialCerner', 'CM_SrcAdmA9'),
    ('/IMPRL/CRNR/ADMSSN_SRC', '88', 'ImperialCerner', 'CM_SrcAsmA10');
