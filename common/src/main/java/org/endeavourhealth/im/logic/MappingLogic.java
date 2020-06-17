package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.IMMappingDAL;
import org.endeavourhealth.im.dal.IMMappingJDBCDAL;
import org.endeavourhealth.im.models.mapping.Context;
import org.endeavourhealth.im.models.mapping.Field;
import org.endeavourhealth.im.models.mapping.Identifier;
import org.endeavourhealth.im.models.mapping.Table;

public class MappingLogic implements AutoCloseable {
    public static String getShortIdentifier(Identifier identifier) {
        if (identifier.getShort() != null && !identifier.getShort().isEmpty())
            return identifier.getShort();

        String id = identifier.getDisplay();
        if (id == null || id.isEmpty())
            id = identifier.getValue();

        return getShortString(id);
    }

    public static String getShortString(String id) {
        // Handle concepts
        if (id.startsWith(":") && id.indexOf("_") < id.length())
            id = id.substring(id.indexOf("_"));

        // Strip vowels (only lower case, assume inicaps)
        return id.replaceAll("[aeiou\\-_]", "");
    }

    private IMMappingDAL dal;

    public MappingLogic() {
        dal = new IMMappingJDBCDAL();
    }

    protected MappingLogic(IMMappingDAL dal) {
        this.dal = dal;
    }

    public String getOrCreateOrganisationId(Identifier organisation) throws Exception{
        String orgId = dal.getOrganisationId(organisation);
        if (orgId == null)
            orgId = dal.createOrganisationId(organisation);

        return orgId;
    }

    public String getOrCreateSystemId(Identifier system) throws Exception{
        String sysId = dal.getSystemId(system);
        if (sysId == null)
            sysId = dal.createSystemId(system);

        return sysId;
    }

    public String getOrCreateSchemaId(Identifier schema) throws Exception{
        String scmId = dal.getSchemaId(schema);
        if (scmId == null)
            scmId = dal.createSchemaId(schema);

        return scmId;
    }

    public String getOrCreateTableId(Table table) throws Exception{
        String tblId = dal.getTableId(table);
        if (tblId == null)
            tblId = dal.createTableId(table);

        return tblId;
    }

    public String getContextId(Context context) throws Exception {
        String orgId = getOrCreateOrganisationId(context.getOrganisation());
        String sysId = getOrCreateSystemId(context.getSystem());
        String scmId = getOrCreateSchemaId(context.getSchema());
        String tblId = getOrCreateTableId(context.getTable());

        String result = dal.getContextId(orgId, sysId, scmId, tblId);
        if (result == null)
            result = dal.createContextId(orgId, sysId, scmId, tblId);

        return result;
    }

    public String getPropertyConceptIri(String contextId, String field) throws Exception {
        String propertyConceptIri = dal.getPropertyConceptIri(contextId, field);

        if (propertyConceptIri == null)
            propertyConceptIri = dal.createPropertyConceptIri(contextId, field);

        return propertyConceptIri;
    }

    public String getValueConceptIri(String contextId, Field field) throws Exception {
        String valueConceptIri = dal.getValueConceptIri(contextId, field);

        if (valueConceptIri == null)
            valueConceptIri = dal.createValueConceptIri(contextId, field);

        return valueConceptIri;
    }

    public Integer getConceptDbid(String conceptIri) throws Exception {
        return dal.getConceptId(conceptIri);
    }

    @Override
    public void close() throws Exception {
        dal.close();
    }
}
