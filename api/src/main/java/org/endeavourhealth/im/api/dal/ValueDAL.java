package org.endeavourhealth.im.api.dal;

import org.endeavourhealth.im.common.models.ValueSummaryList;

public interface ValueDAL {
    ValueSummaryList getMRU() throws Exception;
}
