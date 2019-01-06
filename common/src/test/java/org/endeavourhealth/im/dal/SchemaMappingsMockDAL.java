package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.SchemaMapping;
import org.endeavourhealth.im.models.SearchResult;

import java.util.List;

public class SchemaMappingsMockDAL implements SchemaMappingsDAL {
    public boolean getSchemaMappings_Called = false;
    public List<SchemaMapping> getSchemaMappings_Result = null;

    @Override
    public SearchResult getRecordTypes() throws Exception {
        return null;
    }

    @Override
    public List<SchemaMapping> getSchemaMappings(Long conceptId) throws Exception {
        getSchemaMappings_Called = true;
        return getSchemaMappings_Result;
    }
}
