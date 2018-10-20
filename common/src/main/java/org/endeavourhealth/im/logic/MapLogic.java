package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.MapDAL;
import org.endeavourhealth.im.dal.MapJDBCDAL;
import org.endeavourhealth.im.models.Concept;

public class MapLogic {
    private MapDAL dal;

    public MapLogic() {
        dal = new MapJDBCDAL();
    }

    public Concept get(String code, Long scheme) throws Exception {
        return dal.getByCodeAndScheme(code, scheme);
    }
}
