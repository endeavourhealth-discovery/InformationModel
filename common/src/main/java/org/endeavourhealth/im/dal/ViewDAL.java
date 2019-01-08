package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.View;
import org.endeavourhealth.im.models.ViewItem;
import org.endeavourhealth.im.models.ViewItemAddStyle;

import java.util.List;

public interface ViewDAL {
    List<View> list();
    View get(Long viewId);
    View save(View view);
    void delete(Long viewId);

    List<ViewItem> getViewContents(Long view, Long parent);
    List<ViewItem> getSubTypes(Long parent);

    void addItem(Long viewId, ViewItemAddStyle addStyle, Long conceptId, List<Long> attributeIds, Long parentId);

    void deleteViewItem(Long viewItemId);
}
