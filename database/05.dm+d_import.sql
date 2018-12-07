-- ********************* VTM *********************

DROP TABLE IF EXISTS dmd_vtm;
CREATE TABLE dmd_vtm (
    vtmid     VARCHAR(20)  NOT NULL,
    invalid   BOOLEAN,
    nm        VARCHAR(255) NOT NULL,
    abbrevnm  VARCHAR(60),
    vtmidprev BIGINT,
    vtmiddt   DATE,

    PRIMARY KEY dmd_vtm_vtmid_pk (vtmid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_vtm.csv'
    INTO TABLE dmd_vtm
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(vtmid, @invalid, nm, abbrevnm, @vtmidprev, @vtmiddt)
SET invalid = nullif(@invalid, ''),
    vtmidprev = nullif(@vtmidprev, ''),
    vtmiddt = STR_TO_DATE(nullif(@vtmiddt, ''), '%Y-%m-%d');

-- ********************* VMP *********************

DROP TABLE IF EXISTS dmd_vmp;
CREATE TABLE dmd_vmp (
    vpid      VARCHAR(20)  NOT NULL,
    vpiddt    DATE,
    vpiprev   BIGINT,
    vtmid     VARCHAR(20),
    invalid   BOOLEAN,
    nm        VARCHAR(255) NOT NULL,
    abbrevnm  VARCHAR(60),
    basiscd   INTEGER      NOT NULL,
    nmdt      DATE,
    nmprev    VARCHAR(255),
    basis_prevcd INTEGER,
    nmchangecd   INTEGER,
    combprodcd   INTEGER,
    pres_statcd  INTEGER    NOT NULL,
    sug_f        BOOLEAN,
    glu_f        BOOLEAN,
    pres_f       BOOLEAN,
    cfc_f        BOOLEAN,
    non_availcd  INTEGER,
    non_availdt  DATE,
    df_indcd     SMALLINT,
    udfs         FLOAT(10,3),
    udfs_uomcd   BIGINT,
    unit_dose_uomcd  BIGINT,

    PRIMARY KEY dmd_vmp_vpid_pk (vpid)
) ENGINE=InnoDb DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_vmp_vmptype.csv'
INTO TABLE dmd_vmp
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(vpid, @vpiddt, @vpiprev, @vtmid, @invalid, nm, @abbrevnm, basiscd, @nmdt, nmprev, @basis_prevcd, @nmchangecd, @combprodcd,
pres_statcd, @sug_f, @glu_f, @pres_f, @cfc_f, @non_availcd, @non_availdt, @df_indcd, @udfs, @udfs_uomcd, @unit_dose_uomcd)
SET vpiddt = STR_TO_DATE(nullif(@vpiddt, ''), '%Y-%m-%d'),
    vpiprev = nullif(@vpiprev, ''),
    vtmid = nullif(@vtmid, ''),
    invalid = nullif(@invalid, ''),
    abbrevnm = nullif(@abbrevnm, ''),
    nmdt = STR_TO_DATE(nullif(@nmdt, ''), '%Y-%m-%d'),
    basis_prevcd = nullif(@basis_prevcd, ''),
    nmchangecd = nullif(@nmchangecd, ''),
    combprodcd = nullif(@combprodcd, ''),
    sug_f = nullif(@sug_f, ''),
    glu_f = nullif(@glu_f, ''),
    pres_f = nullif(@pres_f, ''),
    cfc_f = nullif(@cfc_f, ''),
    non_availcd = nullif(@non_availcd, ''),
    non_availdt = STR_TO_DATE(nullif(@non_availdt, ''), '%Y-%m-%d'),
    df_indcd = nullif(@df_indcd, ''),
    udfs = nullif(@udfs, ''),
    udfs_uomcd = nullif(@udfs_uomcd, ''),
    unit_dose_uomcd = nullif(@unit_dose_uomcd, '');

DROP TABLE IF EXISTS dmd_vmp_vpi;
CREATE TABLE dmd_vmp_vpi (
    vpid VARCHAR(20) NOT NULL,
    isid VARCHAR(20) NOT NULL,
    basis_strntcd SMALLINT,
    bs_subid BIGINT,
    strnt_nmrtr_val FLOAT(10,3),
    strnt_nmrtr_uomcd BIGINT,
    strnt_dnmtr_val FLOAT(10,3),
    strnt_dnmtr_uomcd BIGINT,

    KEY dmd_vmp_vpi_vpid_idx (vpid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_vmp_vpitype.csv'
INTO TABLE dmd_vmp_vpi
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(vpid, isid, @basis_strntcd, @bs_subid, @strnt_nmrtr_val, @strnt_nmrtr_uomcd, @strnt_dnmtr_val, @strnt_dnmtr_uomcd)
SET basis_strntcd = nullif(@basis_strntcd, ''),
    bs_subid = nullif(@bs_subid, ''),
    strnt_nmrtr_val = nullif(@strnt_nmrtr_val, ''),
    strnt_nmrtr_uomcd = nullif(@strnt_nmrtr_uomcd, ''),
    strnt_dnmtr_val = nullif(@strnt_dnmtr_val, ''),
    strnt_dnmtr_uomcd = nullif(@strnt_dnmtr_uomcd, '');

DROP TABLE IF EXISTS dmd_vmp_ont_drug_form;
CREATE TABLE dmd_vmp_ont_drug_form (
    vpid VARCHAR(20) NOT NULL,
    formcd SMALLINT NOT NULL,

    KEY dmd_vmp_ont_drug_form_vpid_idx (vpid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_vmp_ontdrugformtype.csv'
INTO TABLE dmd_vmp_ont_drug_form
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_vmp_drug_form;
CREATE TABLE dmd_vmp_drug_form (
    vpid VARCHAR(20) NOT NULL,
    formcd BIGINT NOT NULL,

    PRIMARY KEY dmd_vmp_drug_form_vpid_pk (vpid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_vmp_drugformtype.csv'
INTO TABLE dmd_vmp_drug_form
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_vmp_drug_route;
CREATE TABLE dmd_vmp_drug_route (
    vpid VARCHAR(20) NOT NULL,
    routecd BIGINT NOT NULL,

    KEY dmd_vmp_drug_route_vpid_idx (vpid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_vmp_drugroutetype.csv'
INTO TABLE dmd_vmp_drug_route
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_vmp_control_info;
CREATE TABLE dmd_vmp_control_info (
    vpid VARCHAR(20) NOT NULL,
    catcd SMALLINT NOT NULL,
    catdt DATE,
    cat_prevcd SMALLINT,

    PRIMARY KEY dmd_vmp_control_info_vpid_pk (vpid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_vmp_controlinfotype.csv'
INTO TABLE dmd_vmp_control_info
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(vpid, catcd, @catdt, @cat_prevcd)
SET
    catdt=str_to_date(nullif(@catdt, ''), '%Y-%m-%d'),
    cat_prevcd=nullif(@cat_prevcd, '');

-- ********************* AMP *********************

DROP TABLE IF EXISTS dmd_amp;
CREATE TABLE dmd_amp (
    apid VARCHAR(20) NOT NULL,
    invalid BOOLEAN,
    vpid VARCHAR(20) NOT NULL,
    nm VARCHAR(255) NOT NULL,
    abbrevnm VARCHAR(60),
    `desc` VARCHAR(700) NOT NULL,
    nmdt DATE,
    nm_prev VARCHAR(255),
    suppcd BIGINT NOT NULL,
    lic_authcd SMALLINT NOT NULL,
    lic_auth_prevcd SMALLINT,
    lic_authchangecd SMALLINT,
    lic_authchangedt DATE,
    combprodcd SMALLINT,
    flavourcd SMALLINT,
    ema BOOLEAN,
    parallel_import BOOLEAN,
    avail_restrictcd SMALLINT NOT NULL,

    PRIMARY KEY dmd_amp_apid_pk (apid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_amp_amptype.csv'
INTO TABLE dmd_amp
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(apid, @invalid, vpid, nm, @abbrevnm, `desc`, @nmdt, @nm_prev,  suppcd, lic_authcd, @lic_auth_prevcd,
 @lic_authchangecd, @lic_authchangedt, @combprodcd, @flavourcd, @ema, @parallel_import, avail_restrictcd)
SET invalid=nullif(@invalid, ''),
    abbrevnm=nullif(@abbrevnm, ''),
    nmdt=str_to_date(nullif(@nmdt, ''), '%Y-%m-%d'),
    nm_prev=nullif(@nm_prev, ''),
    lic_auth_prevcd=nullif(@lic_auth_prevcd, ''),
    lic_authchangecd=nullif(@lic_authchangecd, ''),
    lic_authchangedt=str_to_date(nullif(@lic_authchangedt, ''), '%Y-%m-%d'),
    combprodcd=nullif(@combprodcd, ''),
    flavourcd=nullif(@flavourcd, ''),
    ema=nullif(@ema, ''),
    parallel_import=nullif(@parallel_import, '');

DROP TABLE IF EXISTS dmd_amp_api;
CREATE TABLE dmd_amp_api (
    apid VARCHAR(20) NOT NULL,
    isid BIGINT NOT NULL,
    strnth FLOAT(10,3),
    uomcd BIGINT,

    KEY dmd_amp_api_apid_idx (apid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_amp_apitype.csv'
INTO TABLE dmd_amp_api
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(apid, isid, @strnth, @uomcd)
SET strnth=nullif(@strnth, ''),
    uomcd=nullif(@uomcd, '');

DROP TABLE IF EXISTS dmd_amp_lic_route;
CREATE TABLE dmd_amp_lic_route (
    apid VARCHAR(20) NOT NULL,
    routecd BIGINT NOT NULL,

    KEY dmd_amp_lic_route_apid_idx (apid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_amp_licroutetype.csv'
INTO TABLE dmd_amp_lic_route
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_amp_app_prod_info;
CREATE TABLE dmd_amp_app_prod_info (
    apid VARCHAR(20) NOT NULL,
    sz_weight VARCHAR(100),
    colourcd SMALLINT,
    prod_order_no VARCHAR(20),

    PRIMARY KEY dmd_app_prod_info_apid (apid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_amp_appprodinfotype.csv'
INTO TABLE dmd_amp_app_prod_info
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(apid, @sz_weight, @colourcd, @prod_order_no)
SET sz_weight=nullif(@sz_weight, ''),
    colourcd=nullif(@colourcd, ''),
    prod_order_no=nullif(@prod_order_no, '');

-- ********************* VMPP *********************

DROP TABLE IF EXISTS dmd_vmpp;
CREATE TABLE dmd_vmpp (
    vppid VARCHAR(20) NOT NULL,
    invalid BOOLEAN,
    nm VARCHAR(420) NOT NULL,
    abbrevnm VARCHAR(60),
    vpid VARCHAR(20) NOT NULL,
    qtyval FLOAT(10,2),
    qty_uomcd BIGINT,
    combpackcd SMALLINT,

    PRIMARY KEY dmd_vmpp_vppid_pk (vppid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_vmpp_vmpptype.csv'
INTO TABLE dmd_vmpp
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(vppid, @invalid, nm, @abbrevnm, vpid, @qtyval, @qty_uomcd, @combpackcd)
SET invalid=nullif(@invalid,''),
    abbrevnm=nullif(@abbrevnm, ''),
    qtyval=nullif(@qtyval, ''),
    qty_uomcd=nullif(@qty_uomcd, ''),
    combpackcd=nullif(@combpackcd, '');

DROP TABLE IF EXISTS dmd_vmpp_drug_tarrif;
CREATE TABLE dmd_vmpp_drug_tarrif (
    vppid VARCHAR(20) NOT NULL,
    pay_catcd SMALLINT NOT NULL,
    price INTEGER,
    dt DATE,
    prevprice INTEGER,

    PRIMARY KEY dmd_vmpp_drug_tarrif_vppid_pk (vppid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_vmpp_dtinfotype.csv'
INTO TABLE dmd_vmpp_drug_tarrif
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(vppid, pay_catcd, @price, @dt, @prevprice)
SET price=nullif(@price, ''),
    dt=str_to_date(nullif(@dt, ''), '%Y-%m-%d'),
    prevprice=nullif(@prevprice, '');

DROP TABLE IF EXISTS dmd_vmpp_comb_content;
CREATE TABLE dmd_vmpp_comb_content(
    prntvppid VARCHAR(20) NOT NULL,
    chldvppid VARCHAR(20) NOT NULL,

    KEY dmd_vmpp_comb_content_prntvppid_idx (prntvppid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_vmpp_contenttype.csv'
INTO TABLE dmd_vmpp_comb_content
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

-- ********************* AMPP *********************

DROP TABLE IF EXISTS dmd_ampp;
CREATE TABLE dmd_ampp (
    appid VARCHAR(20) NOT NULL,
    invalid BOOLEAN,
    nm VARCHAR(774) NOT NULL,
    abbrevnm VARCHAR(60),
    vppid VARCHAR(20) NOT NULL,
    apid VARCHAR(20) NOT NULL,
    combpackcd SMALLINT,
    legal_catcd SMALLINT NOT NULL,
    subp VARCHAR(30),
    disccd SMALLINT,
    discdt DATE,

    PRIMARY KEY dmd_ampp_appid_pk (appid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_ampp_ampptype.csv'
INTO TABLE dmd_ampp
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(appid, @invalid, nm, @abbrevnm, vppid, apid, @combpackcd, legal_catcd, @subp, @disccd, @discdt)
SET invalid=nullif(@invalid, ''),
    abbrevnm=nullif(@abbrevnm, ''),
    combpackcd=nullif(@combpackcd, ''),
    subp=nullif(@subp, ''),
    disccd=nullif(@disccd, ''),
    discdt=nullif(@discdt, '')
;

DROP TABLE IF EXISTS dmd_ampp_pack_info;
CREATE TABLE dmd_ampp_pack_info (
    appid VARCHAR(20) NOT NULL,
    reimb_statcd SMALLINT NOT NULL,
    reimb_statdt DATE,
    reimb_statprevcd SMALLINT,
    pack_order_no VARCHAR(20),

    PRIMARY KEY dmd_ampp_pack_info_appid_pk (appid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_ampp_packinfotype.csv'
INTO TABLE dmd_ampp_pack_info
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(appid, reimb_statcd, @reimb_statdt, @reimb_statprevcd, @pack_order_no)
SET reimb_statdt=str_to_date(nullif(@reimb_statdt, ''), '%Y-%m-%d'),
    reimb_statprevcd=nullif(@reimb_statprevcd, ''),
    pack_order_no=nullif(@pack_order_no, '');

DROP TABLE IF EXISTS dmd_ampp_presc_info;
CREATE TABLE dmd_ampp_presc_info (
    appid VARCHAR(20) NOT NULL,
    sched_2 BOOLEAN,
    acbs BOOLEAN,
    padm BOOLEAN,
    fp10_mda BOOLEAN,
    sched_1 BOOLEAN,
    hosp BOOLEAN,
    nurse_f BOOLEAN,
    enurse_f BOOLEAN,
    dent_f BOOLEAN,

    PRIMARY KEY dmd_ampp_prescrib_info_appid_pk (appid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_ampp_prescinfotype.csv'
INTO TABLE dmd_ampp_presc_info
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(appid, @sched_2, @acbs, @padm, @fp10_mda, @sched_1, @hosp, @nurse_f, @enurse_f, @dent_f)
SET sched_2=nullif(@sched_2, ''),
    acbs=nullif(@acbs, ''),
    padm=nullif(@padm, ''),
    fp10_mda=nullif(@fp10_mda, ''),
    sched_1=nullif(@sched_1, ''),
    hosp=nullif(@hosp, ''),
    nurse_f=nullif(@nurse_f, ''),
    enurse_f=nullif(@enurse_f, ''),
    dent_f=nullif(@dent_f, '');

DROP TABLE IF EXISTS dmd_ampp_price_info;
CREATE TABLE dmd_ampp_price_info (
    appid VARCHAR(20) NOT NULL,
    price INTEGER,
    pricedt DATE,
    priceprev INTEGER,
    price_basiscd SMALLINT NOT NULL,

    PRIMARY KEY dmd_ampp_price_info_appid_pk (appid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_ampp_priceinfotype.csv'
INTO TABLE dmd_ampp_price_info
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(appid, @price, @pricedt, @priceprev, @price_basiscd)
SET price=nullif(@price, ''),
    pricedt=str_to_date(nullif(@pricedt, ''), '%Y-%m-%d'),
    priceprev=nullif(@priceprev, ''),
    price_basiscd=nullif(@price_basiscd, '');

DROP TABLE IF EXISTS dmd_ampp_reimb_info;
CREATE TABLE dmd_ampp_reimb_info (
    appid VARCHAR(20) NOT NULL,
    px_chrgs SMALLINT,
    disp_fees SMALLINT,
    bb BOOLEAN,
    ltd_stab BOOLEAN,
    cal_pack BOOLEAN,
    spec_contcd SMALLINT,
    dnd SMALLINT,
    fp34d BOOLEAN,

    PRIMARY KEY dmd_ampp_reimb_info_appid_pk (appid)
) ENGINE=InnoDb DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_ampp_reimbinfotype.csv'
INTO TABLE dmd_ampp_reimb_info
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(appid, @px_chrgs, @disp_fees, @bb, @ltd_stab, @cal_pack, @spec_contcd, @dnd, @fp34d)
SET px_chrgs=nullif(@px_chrgs, ''),
    disp_fees=nullif(@disp_fees, ''),
    bb=nullif(@bb, ''),
    ltd_stab=nullif(@ltd_stab, ''),
    cal_pack=nullif(@cal_pack, ''),
    spec_contcd=nullif(@spec_contcd, ''),
    dnd=nullif(@dnd, ''),
    fp34d=nullif(@fp34d, '');

DROP TABLE IF EXISTS dmd_ampp_comb_content;
CREATE TABLE dmd_ampp_comb_content (
    prntappid VARCHAR(20) NOT NULL,
    chldappid VARCHAR(20) NOT NULL,

    KEY dmd_ampp_comb_content_prntappid_key (prntappid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_ampp_contenttype.csv'
INTO TABLE dmd_ampp_comb_content
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

-- ********************* INGREDIENT *********************

DROP TABLE IF EXISTS dmd_ingredient;
CREATE TABLE dmd_ingredient (
    isid VARCHAR(20) NOT NULL,
    isiddt DATE,
    isidprev BIGINT,
    invalid BOOLEAN,
    nm VARCHAR(255) NOT NULL,

    PRIMARY KEY dmd_ingredient_isid_pk (isid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_ingredient.csv'
INTO TABLE dmd_ingredient
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(isid, @isiddt, @isidprev, @invalid, nm)
SET isiddt=str_to_date(nullif(@isiddt, ''), '%Y-%m-%d'),
    isidprev=nullif(@isidprev, ''),
    invalid=nullif(@invalid, '');

-- ********************* LOOKUPS *********************

DROP TABLE IF EXISTS dmd_lu_combpack;
CREATE TABLE dmd_lu_combpack (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_combpack_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_combpackindinfotype.csv'
INTO TABLE dmd_lu_combpack
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_combprod;
CREATE TABLE dmd_lu_combprod (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_combprod_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_combprodindinfotype.csv'
INTO TABLE dmd_lu_combprod
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_basisofname;
CREATE TABLE dmd_lu_basisofname (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_basisofname_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_basisofnameinfotype.csv'
INTO TABLE dmd_lu_basisofname
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_namechangereason;
CREATE TABLE dmd_lu_namechangereason (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_namechangereason_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_namechangereasoninfotype.csv'
INTO TABLE dmd_lu_namechangereason
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_virprodpresstat;
CREATE TABLE dmd_lu_virprodpresstat (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_virprodpresstat_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_virprodpresstatinfotype.csv'
INTO TABLE dmd_lu_virprodpresstat
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_controldrugcat;
CREATE TABLE dmd_lu_controldrugcat (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_controldrugcat_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_controldrugcatinfotype.csv'
INTO TABLE dmd_lu_controldrugcat
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_licauth;
CREATE TABLE dmd_lu_licauth (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_licauth_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_licauthindinfotype.csv'
INTO TABLE dmd_lu_licauth
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_uom;
CREATE TABLE dmd_lu_uom (
    cd BIGINT NOT NULL,
    cddt DATE,
    cdprev BIGINT,
    `desc` VARCHAR(150) NOT NULL,

    KEY dmd_lu_uom_cd_idx (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_uomhistoryinfotype.csv'
INTO TABLE dmd_lu_uom
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(cd, @cddt, @cdprev, `desc`)
SET cddt=str_to_date(nullif(@cddt, ''),'%Y-%m-%d'),
    cdprev=nullif(@cdprev, '');

DROP TABLE IF EXISTS dmd_lu_form;
CREATE TABLE dmd_lu_form (
    cd BIGINT NOT NULL,
    cddt DATE,
    cdprev BIGINT,
    `desc` VARCHAR(60) NOT NULL,

    KEY dmd_lu_form_cd_idx (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_formhistoryinfotype.csv'
INTO TABLE dmd_lu_form
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(cd, @cddt, @cdprev, `desc`)
SET cddt=str_to_date(nullif(@cddt, ''),'%Y-%m-%d'),
    cdprev=nullif(@cdprev, '');

DROP TABLE IF EXISTS dmd_lu_ontformroute;
CREATE TABLE dmd_lu_ontformroute (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_ontformroute_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_ontformrouteinfotype.csv'
INTO TABLE dmd_lu_ontformroute
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_route;
CREATE TABLE dmd_lu_route (
    cd BIGINT NOT NULL,
    cddt DATE,
    cdprev BIGINT,
    `desc` VARCHAR(60) NOT NULL,

    KEY dmd_lu_route_cd_idx (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_routehistoryinfotype.csv'
INTO TABLE dmd_lu_route
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(cd, @cddt, @cdprev, `desc`)
SET cddt=str_to_date(nullif(@cddt, ''),'%Y-%m-%d'),
    cdprev=nullif(@cdprev, '');

DROP TABLE IF EXISTS dmd_lu_paycategory;
CREATE TABLE dmd_lu_paycategory (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_paycategory_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_dtpaycatinfotype.csv'
INTO TABLE dmd_lu_paycategory
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_supplier;
CREATE TABLE dmd_lu_supplier (
    cd BIGINT NOT NULL,
    cddt DATE,
    cdprev BIGINT,
    invalid BOOLEAN,
    `desc` VARCHAR(80) NOT NULL,

    KEY dmd_lu_supplier_cd_idx (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_suppliersupplierinfotype.csv'
INTO TABLE dmd_lu_supplier
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(cd, @cddt, @cdprev, @invalid, `desc`)
SET cddt=str_to_date(nullif(@cddt, ''),'%Y-%m-%d'),
    cdprev=nullif(@cdprev, ''),
    invalid=nullif(@invalid, '');

DROP TABLE IF EXISTS dmd_lu_flavour;
CREATE TABLE dmd_lu_flavour (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_flavour_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_flavourinfotype.csv'
INTO TABLE dmd_lu_flavour
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_colour;
CREATE TABLE dmd_lu_colour (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_colour_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_colourinfotype.csv'
INTO TABLE dmd_lu_colour
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_basisofstrength;
CREATE TABLE dmd_lu_basisofstrength (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(150) NOT NULL,

    PRIMARY KEY dmd_lu_basisofstrength_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_basisofstrengthinfotype.csv'
INTO TABLE dmd_lu_basisofstrength
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_reimbstat;
CREATE TABLE dmd_lu_reimbstat (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_reimbstat_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_reimbstatinfotype.csv'
INTO TABLE dmd_lu_reimbstat
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_speccont;
CREATE TABLE dmd_lu_speccont (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_speccont_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_speccontinfotype.csv'
INTO TABLE dmd_lu_speccont
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_dnd;
CREATE TABLE dmd_lu_dnd (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_dnd_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_dndinfotype.csv'
INTO TABLE dmd_lu_dnd
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_vpnoavail;
CREATE TABLE dmd_lu_vpnoavail (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_vpnoavail_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_virprodnoavailinfotype.csv'
INTO TABLE dmd_lu_vpnoavail
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_discind;
CREATE TABLE dmd_lu_discind (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_discind_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_discindinfotype.csv'
INTO TABLE dmd_lu_discind
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_dfind;
CREATE TABLE dmd_lu_dfind (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(20) NOT NULL,

    PRIMARY KEY dmd_lu_dfind_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_dfindinfotype.csv'
INTO TABLE dmd_lu_dfind
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_pricebasis;
CREATE TABLE dmd_lu_pricebasis (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_pricebasis_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_pricebasisinfotype.csv'
INTO TABLE dmd_lu_pricebasis
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_legalcat;
CREATE TABLE dmd_lu_legalcat (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_legalcat_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_legalcatinfotype.csv'
INTO TABLE dmd_lu_legalcat
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_availrestrict;
CREATE TABLE dmd_lu_availrestrict (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_availrestrict_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_availrestrictinfotype.csv'
INTO TABLE dmd_lu_availrestrict
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS dmd_lu_licauthchangereason;
CREATE TABLE dmd_lu_licauthchangereason (
    cd SMALLINT NOT NULL,
    `desc` VARCHAR(60) NOT NULL,

    PRIMARY KEY dmd_lu_licauthchangereason_cd_pk (cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_lookup_licauthchgrsninfotype.csv'
INTO TABLE dmd_lu_licauthchangereason
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n';

-- ********************* GTIN *********************

DROP TABLE IF EXISTS dmd_gtin;
CREATE TABLE dmd_gtin (
    amppid VARCHAR(20) NOT NULL,
    gtin VARCHAR(20) NOT NULL,
    startdt DATE NOT NULL,
    enddt DATE,

    KEY dmd_gtin_amppid_idx (amppid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'C:\\dmddataloader\\csv\\f_gtin.csv'
INTO TABLE dmd_gtin
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'
(amppid, gtin, @startdt, @enddt)
SET startdt=str_to_date(@startdt, '%Y-%m-%d'),
    enddt=str_to_date(nullif(@enddt, ''), '%Y-%m-%d');
