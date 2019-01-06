package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.SchemaMappingsDAL;
import org.endeavourhealth.im.dal.SchemaMappingsJDBCDAL;
import org.endeavourhealth.im.models.Attribute;
import org.endeavourhealth.im.models.SchemaMapping;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SchemaMappingsLogic {
    private SchemaMappingsDAL dal;
    private ConceptLogic conceptLogic;

    public SchemaMappingsLogic() {
        this.dal = new SchemaMappingsJDBCDAL();
        this.conceptLogic = new ConceptLogic();
    }
    protected SchemaMappingsLogic(SchemaMappingsDAL dal, ConceptLogic conceptLogic) {
        this.dal = dal;
        this.conceptLogic = conceptLogic;
    }

    public List<SchemaMapping> getSchemaMappings(Long conceptId) throws Exception {
        List<Attribute> attributes = conceptLogic.getAttributes(conceptId, false);
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
