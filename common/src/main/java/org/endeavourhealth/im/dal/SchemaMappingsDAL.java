package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.SchemaMapping;
import org.endeavourhealth.im.models.SearchResult;

import java.util.List;

public interface SchemaMappingsDAL {
    SearchResult getRecordTypes() throws Exception;

    List<SchemaMapping> getSchemaMappings(Long conceptId) throws Exception;
}
