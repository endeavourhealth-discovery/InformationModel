package org.endeavourhealth.im.api.logic;

import org.endeavourhealth.im.common.models.ConceptSummaryList;
import org.endeavourhealth.im.common.models.IdText;
import org.endeavourhealth.im.dal.ConceptSelectorDAL;
import org.endeavourhealth.im.dal.ConceptSelectorJDBCDAL;

import java.util.List;

public class ConceptSelectorLogic {
    private ConceptSelectorDAL dal;

    public ConceptSelectorLogic() {
        this.dal = new ConceptSelectorJDBCDAL();
    }
    protected ConceptSelectorLogic(ConceptSelectorDAL dal) {
        this.dal = dal;
    }


    public ConceptSummaryList search(String searchTerm, Boolean activeOnly, List<Integer> systems) throws Exception {
        return dal.search(searchTerm, activeOnly, systems);
    }

    public List<IdText> getSystems() throws Exception {
        return dal.getCodeSystems();
    }
}
