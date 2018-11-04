package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.ConceptSummary;
import org.endeavourhealth.im.models.View;

import java.util.List;

public interface ViewDAL {
    List<View> list(Long parent) throws Exception;

    View get(Long id) throws Exception;
    View save(View view) throws Exception;

    List<ConceptSummary> getConcepts(Long id) throws Exception;
}
