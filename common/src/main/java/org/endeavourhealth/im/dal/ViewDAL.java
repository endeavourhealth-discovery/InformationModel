package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.View;
import org.endeavourhealth.im.models.ViewItem;
import org.endeavourhealth.im.models.ViewItemAddStyle;

import java.util.List;

public interface ViewDAL {
    List<View> list() throws DALException;
    View get(Long viewId) throws DALException;
    View save(View view) throws DALException;
    void delete(Long viewId) throws DALException;

    List<ViewItem> getViewContents(Long view, Long parent) throws DALException;
    List<ViewItem> getSubTypes(Long parent) throws DALException;

    void addItem(Long viewId, ViewItemAddStyle addStyle, Long conceptId, List<Long> attributeIds, Long parentId) throws DALException;

    void deleteViewItem(Long viewItemId) throws DALException;
}
