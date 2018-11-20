package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.View;
import org.endeavourhealth.im.models.ViewItem;
import org.endeavourhealth.im.models.ViewItemAddStyle;

import java.util.List;

public interface ViewDAL {
    List<View> list() throws Exception;
    View get(Long viewId) throws Exception;
    View save(View view) throws Exception;
    void delete(Long viewId) throws Exception;

    List<ViewItem> getViewContents(Long view, Long parent) throws Exception;
    List<ViewItem> getSubTypes(Long parent) throws Exception;

    void addItem(Long viewId, ViewItemAddStyle addStyle, Long conceptId, List<Long> attributeIds, Long parentId) throws Exception;

}
