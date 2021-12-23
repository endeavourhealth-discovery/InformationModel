-- ******************** Admission Source Patch ********************

-- Value maps
INSERT INTO map_node_value_meta
(node, value, scheme, concept)
VALUES
    ('/CDS/INPTNT/ADMSSN_SRC', '39a', 'CM_NHS_DD', 'CM_SrcAdmPePoCo'),      -- Temporary false map
    ('/CDS/INPTNT/ADMSSN_SRC', '19', 'ImperialCerner', 'CM_SrcAdmUsual'),
    ('/CDS/INPTNT/ADMSSN_SRC', '29', 'ImperialCerner', 'CM_SrcAdmTempR'),
    ('/CDS/INPTNT/ADMSSN_SRC', '39', 'ImperialCerner', 'CM_SrcAdmPePoCo'),
    ('/CDS/INPTNT/ADMSSN_SRC', '39a', 'ImperialCerner', 'CM_SrcAdmPePoCo'), -- Custom local
    ('/CDS/INPTNT/ADMSSN_SRC', '40', 'ImperialCerner', 'CM_SrcAdmPe'),
    ('/CDS/INPTNT/ADMSSN_SRC', '41', 'ImperialCerner', 'CM_SrcAdmCo'),
    ('/CDS/INPTNT/ADMSSN_SRC', '42', 'ImperialCerner', 'CM_SrcAdmPo'),
    ('/CDS/INPTNT/ADMSSN_SRC', '49', 'ImperialCerner', 'CM_SrcAdmPSyHosp'),
    ('/CDS/INPTNT/ADMSSN_SRC', '51', 'ImperialCerner', 'CM_SrcAdmA1'),
    ('/CDS/INPTNT/ADMSSN_SRC', '52', 'ImperialCerner', 'CM_SrcAdmA2'),
    ('/CDS/INPTNT/ADMSSN_SRC', '53', 'ImperialCerner', 'CM_SrcAdmA3'),
    ('/CDS/INPTNT/ADMSSN_SRC', '54', 'ImperialCerner', 'CM_SrcAdmA4'),
    ('/CDS/INPTNT/ADMSSN_SRC', '65', 'ImperialCerner', 'CM_SrcAdmA5'),
    ('/CDS/INPTNT/ADMSSN_SRC', '66', 'ImperialCerner', 'CM_SrcAdmA6'),
    ('/CDS/INPTNT/ADMSSN_SRC', '79', 'ImperialCerner', 'CM_SrcAdmA7'),
    ('/CDS/INPTNT/ADMSSN_SRC', '85', 'ImperialCerner', 'CM_SrcAdmA8'),
    ('/CDS/INPTNT/ADMSSN_SRC', '87', 'ImperialCerner', 'CM_SrcAdmA9'),
    ('/CDS/INPTNT/ADMSSN_SRC', '88', 'ImperialCerner', 'CM_SrcAsmA10');
