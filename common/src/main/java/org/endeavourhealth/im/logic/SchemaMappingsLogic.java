package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.SchemaMappingsDAL;
import org.endeavourhealth.im.dal.SchemaMappingsJDBCDAL;
import org.endeavourhealth.im.models.Attribute;
import org.endeavourhealth.im.models.SchemaMapping;
import org.endeavourhealth.im.models.SearchResult;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SchemaMappingsLogic {
    private SchemaMappingsDAL dal;

    public SchemaMappingsLogic() {
        this.dal = new SchemaMappingsJDBCDAL();
    }
    protected SchemaMappingsLogic(SchemaMappingsDAL dal) {
        this.dal = dal;
    }

    public SearchResult getRecordTypes() throws Exception {
        return this.dal.getRecordTypes();
    }

    public List<SchemaMapping> getSchemaMappings(Long conceptId) throws Exception {
        List<Attribute> attributes = new ConceptLogic().getAttributes(conceptId, false);
        Map<Long, SchemaMapping> mappings = new HashMap<>();
        this.dal.getSchemaMappings(conceptId).forEach((m) -> mappings.put(m.getAttribute().getId(), m));
        List<SchemaMapping> result = new ArrayList<>();

        for(Attribute att: attributes) {
            SchemaMapping m = mappings.get(att.getAttribute().getId());
            if (m == null)
                m = new SchemaMapping()
                    .setAttribute(att.getAttribute());

            result.add(m);
        }

        return result;
    }
}
