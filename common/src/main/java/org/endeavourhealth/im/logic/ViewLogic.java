package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.ViewDAL;
import org.endeavourhealth.im.dal.ViewJDBCDAL;
import org.endeavourhealth.im.models.ConceptSummary;
import org.endeavourhealth.im.models.View;

import java.util.List;

public class ViewLogic {
    private ViewDAL dal;
    public ViewLogic() {
        this.dal = new ViewJDBCDAL();
    }

    public List<View> list(Long parent) throws Exception {
        return this.dal.list(parent);
    }

    public View get(Long id) throws Exception {
        return this.dal.get(id);
    }

    public View save(View view) throws Exception {
        return this.dal.save(view);
    }

    public List<ConceptSummary> getConcepts(Long id) throws Exception {
        return this.dal.getConcepts(id);
    }
}
