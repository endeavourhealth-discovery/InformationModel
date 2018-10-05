DROP TABLE IF EXISTS dmd_existing_vpid;
CREATE TABLE dmd_existing_vpid (
    vpid BIGINT NOT NULL,

    PRIMARY KEY dmd_existing_vpid_vpid_pk (vpid)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO dmd_existing_vpid
SELECT vpid
FROM dmd_vmp v
JOIN mapping_code c on c.scheme=5031 and c.code_id = v.vpid;