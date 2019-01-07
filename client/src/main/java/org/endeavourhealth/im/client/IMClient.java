package org.endeavourhealth.im.client;


import org.endeavourhealth.im.dal.DALException;
import org.endeavourhealth.im.dal.MapJDBCDAL;
import org.endeavourhealth.im.logic.ConceptLogic;
import org.endeavourhealth.im.models.Concept;


public class IMClient {
    public static Concept getConcept(Long scheme, String code) throws DALException {
        return new MapJDBCDAL().getByCodeAndScheme(code, scheme);
    }

    public static Long getConceptId(Long scheme, String code) throws DALException {
        return getConcept(scheme, code).getId();
    }

    public static Long getConceptId(String context) throws DALException {
        return getOrCreateConcept(context, false);
    }

    public static Long getOrCreateConceptId(String context) throws DALException {
        return getOrCreateConcept(context, true);
    }

    private static Long getOrCreateConcept(String context, Boolean createMissing) throws DALException {
        return new ConceptLogic().get(context, createMissing).getId();
    }
}
