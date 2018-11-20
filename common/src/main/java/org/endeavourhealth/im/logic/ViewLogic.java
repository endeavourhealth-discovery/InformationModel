package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.ViewDAL;
import org.endeavourhealth.im.dal.ViewJDBCDAL;
import org.endeavourhealth.im.models.*;

import java.util.ArrayList;
import java.util.List;

public class ViewLogic {
    private ViewDAL dal;
    public ViewLogic() {
        this.dal = new ViewJDBCDAL();
    }

    public List<View> list() throws Exception {
        return this.dal.list();
    }

    public View get(Long viewId) throws Exception {
        return this.dal.get(viewId);
    }

    public List<ViewItem> getViewContents(Long view, Long parent) throws Exception {
        if (view == 1L)
            return this.dal.getSubTypes(parent);
        else
            return this.dal.getViewContents(view, parent);
    }

    public void addItem(Long viewId, ViewItemAddStyle addStyle, Long conceptId, List<Long> attributeIds, Long parentId) throws Exception {
        this.dal.addItem(viewId, addStyle, conceptId, attributeIds, parentId);
    }

    public View save(View view) throws Exception {
        return this.dal.save(view);
    }

    public void delete(Long viewId) throws Exception {
        this.dal.delete(viewId);
    }

    public void deleteViewItem(Long viewItemId) throws Exception {
        this.dal.deleteViewItem(viewItemId);
    }
}
