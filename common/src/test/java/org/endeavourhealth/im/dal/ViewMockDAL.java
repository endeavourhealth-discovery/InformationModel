package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.View;
import org.endeavourhealth.im.models.ViewItem;
import org.endeavourhealth.im.models.ViewItemAddStyle;

import java.util.List;

public class ViewMockDAL implements ViewDAL {
    public boolean getSubTypes_Called = false;
    public boolean getViewContents_Called = false;


    @Override
    public List<View> list() throws Exception {
        return null;
    }

    @Override
    public View get(Long viewId) throws Exception {
        return null;
    }

    @Override
    public View save(View view) throws Exception {
        return null;
    }

    @Override
    public void delete(Long viewId) throws Exception {

    }

    @Override
    public List<ViewItem> getViewContents(Long view, Long parent) throws Exception {
        getViewContents_Called = true;
        return null;
    }

    @Override
    public List<ViewItem> getSubTypes(Long parent) throws Exception {
        getSubTypes_Called = true;
        return null;
    }

    @Override
    public void addItem(Long viewId, ViewItemAddStyle addStyle, Long conceptId, List<Long> attributeIds, Long parentId) throws Exception {

    }

    @Override
    public void deleteViewItem(Long viewItemId) throws Exception {

    }
}
