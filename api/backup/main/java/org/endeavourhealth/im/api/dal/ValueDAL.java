package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.common.models.ValueSummary;
import org.endeavourhealth.im.common.models.ValueSummaryList;

public interface ValueDAL {
    ValueSummaryList getMRU() throws Exception;

    ValueSummary get(Long id) throws Exception;
}
