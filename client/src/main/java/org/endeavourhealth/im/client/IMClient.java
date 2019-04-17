package org.endeavourhealth.im.client;

import org.endeavourhealth.im.dal.InformationModelDAL;
import org.endeavourhealth.im.dal.InformationModelJDBCDAL;

public class IMClient {
    private static InformationModelDAL db = new InformationModelJDBCDAL();

    public static Integer getConceptIdForSchemeCode(String scheme, String code) throws Exception {
        return db.getConceptIdForSchemeCode(scheme, code);
    }

    public static Integer getMappedCoreConceptIdForSchemeCode(String scheme, String code) throws Exception {
        return db.getMappedCoreConceptIdForSchemeCode(scheme, code);
    }

    public static Integer getMappedConceptIdForTypeTerm(String type, String term) throws Exception {
        return db.getMappedConceptIdForTypeTerm(type, term);
    }
}
