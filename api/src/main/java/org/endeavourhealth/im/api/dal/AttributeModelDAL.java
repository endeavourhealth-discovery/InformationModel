package org.endeavourhealth.im.api.dal;

import org.endeavourhealth.im.common.models.AttributeModelSummary;

import java.sql.SQLException;
import java.util.List;

public interface AttributeModelDAL {
    List<AttributeModelSummary> getSummaries(Integer page) throws SQLException;
    AttributeModelSummary getSummaryByContext(String context) throws SQLException;
    Long createDraftAttributeModel(String context) throws Exception;
}
