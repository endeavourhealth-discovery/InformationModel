package org.endeavourhealth.im.api.logic;

import org.endeavourhealth.im.dal.ValueDAL;
import org.endeavourhealth.im.dal.ValueJDBCDAL;
import org.endeavourhealth.im.common.models.*;

public class ValueLogic {
    private ValueDAL dal;

    public ValueLogic() {
        this.dal = new ValueJDBCDAL();
    }
    protected ValueLogic(ValueDAL dal) {
        this.dal = dal;
    }

    public ValueSummaryList getMRU() throws Exception {
        return dal.getMRU();
    }

    public ValueSummary get(Long id) throws Exception {
        return dal.get(id);
    }
}
