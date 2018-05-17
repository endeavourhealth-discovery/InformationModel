package org.endeavourhealth.im.api.logic;

import org.endeavourhealth.im.api.dal.AttributeModelDAL;
import org.endeavourhealth.im.api.dal.AttributeModelJDBCDAL;
import org.endeavourhealth.im.common.models.*;

import java.util.List;

public class AttributeModelLogic {
    private AttributeModelDAL dal;

    public AttributeModelLogic() {
        this.dal = new AttributeModelJDBCDAL();
    }
    protected AttributeModelLogic(AttributeModelDAL dal) {
        this.dal = dal;
    }

    public List<AttributeModelSummary> getSummaries(Integer page) throws Exception {
        return this.dal.getSummaries(page);
    }

    public boolean validateAndCreateDraftWithTask(ConceptReference ref) throws Exception {
        return validateAndCreateDraft(ref, true);
    }

    private boolean validateAndCreateDraft(ConceptReference ref, boolean createTaskIfInvalid) throws Exception {
        if (ref == null || ref.getId() != null || ref.getContext() == null || ref.getContext().isEmpty())
            return true;

        AttributeModelSummary am = dal.getSummaryByContext(ref.getContext());
        if (am != null) {
            ref.setId(am.getId());
            return true;
        } else {
            Long id = dal.createDraftAttributeModel(ref.getContext());
            if (createTaskIfInvalid)
                new TaskLogic().createTask("(AUTO) - " + ref.getContext(), TaskType.ATTRIBUTE_MODEL, id);
            ref.setId(id);
            return false;
        }
    }
}
