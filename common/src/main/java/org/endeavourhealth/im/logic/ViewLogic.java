package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.ViewDAL;
import org.endeavourhealth.im.dal.ViewJDBCDAL;
import org.endeavourhealth.im.models.*;

import java.util.List;

public class ViewLogic {
    private ViewDAL dal;
    public ViewLogic() {
        this.dal = new ViewJDBCDAL();
    }

    public ViewLogic(ViewDAL dal) {
        this.dal = dal;
    }

    public List<ViewItem> getViewContents(Long view, Long parent) throws Exception {
        if (view == 1L)
            return this.dal.getSubTypes(parent);
        else
            return this.dal.getViewContents(view, parent);
    }
}
