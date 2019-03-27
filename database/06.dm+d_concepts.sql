-- Reset auto-increment

SELECT @max := MAX(dbid) + 1
FROM concept;
SET @qry = concat('ALTER TABLE concept AUTO_INCREMENT = ', @max);
PREPARE stmt FROM @qry;
EXECUTE stmt;


-- ********************* DM+D NAMESPACE *********************
INSERT INTO document
    (data)
VALUES (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0'));

-- ********************* DM+D CONCEPTS *********************
INSERT INTO concept(data)
VALUES (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
                    'id', 'DMD_VTM',
                    'name', 'Virtual therapeutic moiety',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'CodeableConcept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
                    'id', 'DMD_VMP',
                    'name', 'Virtual medicinal product',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'CodeableConcept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
                    'id', 'DMD_has_moeity',
                    'name', 'Has moeity relationship',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'relationship'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
                    'id', 'DMD_VMPP',
                    'name', 'Virtual medicinal product pack',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'CodeableConcept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
                    'id', 'DMD_is_pack_of',
                    'name', 'Is pack of relationship',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'relationship'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
                    'id', 'DMD_AMP',
                    'name', 'Actual medicinal product',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'CodeableConcept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
                    'id', 'DMD_is_branded',
                    'name', 'An actual (branded) instance of a virtual (generic) product',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'relationship'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
                    'id', 'DMD_AMPP',
                    'name', 'Actual medicinal product pack',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'CodeableConcept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
                    'id', 'DMD_is_ingredient',
                    'name', 'Is ingredient relationship',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'relationship'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
                    'id', 'DMD_Ingredient',
                    'name', 'Ingredient',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'CodeableConcept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
                    'id', 'DM+D',
                    'name', 'DM+D code scheme',
                    'description', 'Dictionary of Medicines & Devices',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'CodeScheme'
                        )))

    ,
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
                    'id', 'DMD_UOM',
                    'name', 'Units of measure',
                    'description', 'DM+D specified units of measure',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'CodeableConcept'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
                    'id', 'DMD_numerator_value',
                    'name', 'DM+D numerator value',
                    'description', 'Numerator value for an ingredient',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'data_property'
                        ),
                    'has_value_type', JSON_OBJECT(
                        'id', 'Numeric'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
                    'id', 'DMD_numerator_units',
                    'name', 'DM+D numerator units',
                    'description', 'Numerator unit of measure for an ingredient',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'data_property'
                        ),
                    'has_value_type', JSON_OBJECT(
                        'id', 'DMD_UOM'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
                    'id', 'DMD_denominator_value',
                    'name', 'DM+D denominator value',
                    'description', 'Denominator value for an ingredient',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'data_property'
                        ),
                    'has_value_type', JSON_OBJECT(
                        'id', 'Numeric'
                        ))),
       (JSON_OBJECT('document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
                    'id', 'DMD_denominator_units',
                    'name', 'DM+D denominator units',
                    'description', 'Denominator unit of measure for an ingredient',
                    'is_subtype_of', JSON_OBJECT(
                        'id', 'data_property'
                        ),
                    'has_value_type', JSON_OBJECT(
                        'id', 'DMD_UOM'
                        )));



-- ********************* VIRTUAL THERAPEUTIC MOIETY *********************

-- Create concepts
INSERT INTO concept (data)
SELECT JSON_OBJECT(
           'document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
           'id', concat('DMD_', v.vtmid),
           'name', ifnull(v.abbrevnm, if(length(v.nm) > 60, concat(left(v.nm, 57), '...'), v.nm)),
           'description', v.nm,
           'code_scheme', 'DM+D',
           'code', v.vtmid,
           'is_subtype_of', JSON_OBJECT(
               'id', 'DMD_VTM'
               )
           )
FROM dmd_vtm v
WHERE v.invalid IS NULL;

-- ********************* VIRTUAL MEDICINAL PRODUCTS *********************
EXECUTE stmt;

-- Create concepts
INSERT INTO concept (data)
SELECT JSON_OBJECT(
           'document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
           'id', concat('DMD_', v.vpid),
           'name', ifnull(v.abbrevnm, if(length(v.nm) > 60, concat(left(v.nm, 57), '...'), v.nm)),
           'description', v.nm,
           'code_scheme', 'DM+D',
           'code', v.vpid,
           'is_subtype_of', JSON_OBJECT(
               'id', 'DMD_VMP'
               )
           )
FROM dmd_vmp v
WHERE v.invalid IS NULL;

-- Set relationships
UPDATE concept c
    INNER JOIN (
        SELECT id, JSON_OBJECTAGG(prop, val) as rel
        FROM (SELECT concat('DMD_', rel.vpid) as id,
                     'DMD_has_moiety'         as prop,
                     JSON_ARRAYAGG(
                         JSON_OBJECT(
                             'id', concat('DMD_', rel.vtmid)
                             )
                         )                    as val
              FROM dmd_vmp rel
              WHERE rel.vtmid IS NOT NULL
                AND rel.invalid IS NULL
              GROUP BY rel.vpid) t1
        GROUP BY id) t2
    ON t2.id = c.id
SET data=JSON_MERGE(c.data, t2.rel);

-- ********************* VIRTUAL MEDICINAL PRODUCT PACKS *********************
EXECUTE stmt;

-- Create concepts
INSERT INTO concept (data)
SELECT JSON_OBJECT(
           'document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
           'id', concat('DMD_', v.vppid),
           'name', ifnull(v.abbrevnm, if(length(v.nm) > 60, concat(left(v.nm, 57), '...'), v.nm)),
           'description', v.nm,
           'code_scheme', 'DM+D',
           'code', v.vppid,
           'is_subtype_of', JSON_OBJECT(
               'id', 'DMD_VMPP'
               )
           )
FROM dmd_vmpp v
WHERE v.invalid IS NULL;


-- Reset relationships
UPDATE concept c
    INNER JOIN (
        SELECT id, JSON_OBJECTAGG(prop, val) as rel
        FROM (SELECT concat('DMD-', rel.vppid) as id,
                     'DMD_is_pack_of'          as prop,
                     JSON_ARRAYAGG(
                         JSON_OBJECT(
                             'id', concat('DMD_', rel.vpid)
                             )
                         )                     as val
              FROM dmd_vmpp rel
              WHERE rel.invalid IS NULL
              GROUP BY rel.vppid) t1
        GROUP BY id) t2
    ON t2.id = c.id
SET data=JSON_MERGE(c.data, t2.rel);

-- ********************* ACTUAL MEDICINAL PRODUCTS *********************
EXECUTE stmt;

-- Create concepts
INSERT INTO concept (data)
SELECT JSON_OBJECT(
           'document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
           'id', concat('DMD_', v.apid),
           'name', ifnull(v.abbrevnm, if(length(v.nm) > 60, concat(left(v.nm, 57), '...'), v.nm)),
           'description', v.nm,
           'code_scheme', 'DM+D',
           'code', v.apid,
           'is_subtype_of', JSON_OBJECT(
               'id', 'DMD_AMP'
               )
           )
FROM dmd_amp v
WHERE v.invalid IS NULL;

-- Reset relationships
UPDATE concept c
    INNER JOIN (
        SELECT id, JSON_OBJECTAGG(prop, val) as rel
        FROM (SELECT concat('DMD_', rel.apid) as id,
                     'DMD_is_branded'         as prop,
                     JSON_ARRAYAGG(
                         JSON_OBJECT(
                             'id', concat('DMD_', rel.vpid)
                             )
                         )                    as val
              FROM dmd_amp rel
              WHERE rel.invalid IS NULL
              GROUP BY rel.apid) t1
        GROUP BY id) t2
    ON t2.id = c.id
SET data=JSON_MERGE(c.data, t2.rel);

-- ********************* ACTUAL MEDICINAL PRODUCT PACKS *********************
EXECUTE stmt;

-- Create concepts
INSERT INTO concept (data)
SELECT JSON_OBJECT(
           'document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
           'id', concat('DMD_', v.appid),
           'name', ifnull(v.abbrevnm, if(length(v.nm) > 60, concat(left(v.nm, 57), '...'), v.nm)),
           'description', v.nm,
           'code_scheme', 'DM+D',
           'code', v.appid,
           'is_subtype_of', JSON_OBJECT(
               'id', 'DMD_AMPP'
               )
           )
FROM dmd_ampp v
WHERE v.invalid IS NULL;

-- Reset relationships
UPDATE concept c
    INNER JOIN (
        SELECT id, JSON_OBJECTAGG(prop, val) as rel
        FROM (SELECT concat('DMD_', rel.appid) as id,
                     'DMD_is_branded'          as prop,
                     JSON_ARRAYAGG(
                         JSON_OBJECT(
                             'id', concat('DMD_', rel.vppid)
                             )
                         )                     as val
              FROM dmd_ampp rel
              WHERE rel.invalid IS NULL
              GROUP BY rel.appid) t1
        GROUP BY id) t2
    ON t2.id = c.id
SET data=JSON_MERGE(c.data, t2.rel);


UPDATE concept c
    INNER JOIN (
        SELECT id, JSON_OBJECTAGG(prop, val) as rel
        FROM (SELECT concat('DMD_', rel.appid) as id,
                     'DMD_is_pack_of'          as prop,
                     JSON_ARRAYAGG(
                         JSON_OBJECT(
                             'id', concat('DMD_', rel.apid)
                             )
                         )                     as val
              FROM dmd_ampp rel
              WHERE rel.invalid IS NULL
              GROUP BY rel.appid) t1
        GROUP BY id) t2
    ON t2.id = c.id
SET data=JSON_MERGE(c.data, t2.rel);


-- ********************* VIRTUAL PRODUCT INGREDIENT *********************
EXECUTE stmt;

-- Create concepts
INSERT INTO concept (data)
SELECT JSON_OBJECT(
           'document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
           'id', concat('DMD_', v.isid),
           'name', if(length(v.nm) > 60, concat(left(v.nm, 57), '...'), v.nm),
           'description', v.nm,
           'code_scheme', 'DM+D',
           'code', v.isid,
           'is_subtype_of', JSON_OBJECT(
               'id', 'DMD_Ingredient'
               )
           )
FROM dmd_ingredient v
WHERE v.invalid IS NULL;

UPDATE concept c
    INNER JOIN (
        SELECT id, JSON_OBJECTAGG(prop, val)  as rel
        FROM (SELECT concat('DMD_', rel.vpid) as id,
                     'DMD_has_ingredient'     as prop,
                     JSON_ARRAYAGG(
                         JSON_OBJECT(
                             'id', concat('DMD_', rel.isid),
                             'DMD_numerator_value', rel.strnt_nmrtr_val,
                             'DMD_numerator_units', JSON_OBJECT('id', CONCAT('DMD_', rel.strnt_nmrtr_uomcd)),
                             'DMD_denominator_value', rel.strnt_dnmtr_val,
                             'DMD_denominator_units', JSON_OBJECT('id', CONCAT('DMD_', rel.strnt_dnmtr_uomcd))
                             )
                         )                    as val
              FROM dmd_vmp_vpi rel
              GROUP BY rel.vpid) t1
        GROUP BY id) t2
    ON t2.id = c.id
SET data=JSON_MERGE(c.data, t2.rel);

-- ********************* UNITS OF MEASURE *********************
EXECUTE stmt;

INSERT INTO concept (data)
SELECT JSON_OBJECT(
           'document', 'http://DiscoveryDataService/InformationModel/dm/DMD/1.0.0',
           'id', concat('DMD_', v.cd),
           'name', if(length(v.desc) > 60, concat(left(v.desc, 57), '...'), v.desc),
           'description', v.desc,
           'code_scheme', 'DM+D',
           'code', v.cd,
           'is_subtype_of', JSON_OBJECT(
               'id', 'DMD_UOM'
               )
           )
FROM dmd_lu_uom v;


DEALLOCATE PREPARE stmt;
