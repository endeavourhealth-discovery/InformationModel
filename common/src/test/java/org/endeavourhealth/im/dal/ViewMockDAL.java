package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.View;
import org.endeavourhealth.im.models.ViewItem;
import org.endeavourhealth.im.models.ViewItemAddStyle;

import java.util.List;

public class ViewMockDAL implements ViewDAL {
    public boolean getSubTypes_Called = false;
    public boolean getViewContents_Called = false;


    @Override
    public List<View> list() throws DALException {
        return null;
    }

    @Override
    public View get(Long viewId) throws DALException {
        return null;
    }

    @Override
    public View save(View view) throws DALException {
        return null;
    }

    @Override
    public void delete(Long viewId) throws DALException {

    }

    @Override
    public List<ViewItem> getViewContents(Long view, Long parent) throws DALException {
        getViewContents_Called = true;
        return null;
    }

    @Override
    public List<ViewItem> getSubTypes(Long parent) throws DALException {
        getSubTypes_Called = true;
        return null;
    }

    @Override
    public void addItem(Long viewId, ViewItemAddStyle addStyle, Long conceptId, List<Long> attributeIds, Long parentId) throws DALException {

    }

    @Override
    public void deleteViewItem(Long viewItemId) throws DALException {

    }
}
