package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.mapping.Field;
import org.endeavourhealth.im.models.mapping.Identifier;
import org.endeavourhealth.im.models.mapping.Table;

public interface IMMappingDAL extends AutoCloseable {
    String getOrganisationId(Identifier organisation) throws Exception;
    String createOrganisationId(Identifier organisation) throws Exception;
    String getSystemId(Identifier system) throws Exception;
    String createSystemId(Identifier system) throws Exception;
    String getSchemaId(Identifier schema) throws Exception;
    String createSchemaId(Identifier schema) throws Exception;
    String getTableId(Table table) throws Exception;
    String createTableId(Table table) throws Exception;

    String getContextId(String orgId, String sysId, String scmId, String tblId) throws Exception;
    String createContextId(String orgId, String sysId, String scmId, String tblId) throws Exception;

    String getPropertyConceptIri(String contextId, String field) throws Exception;
    String createPropertyConceptIri(String contextId, String field) throws Exception;

    String getValueConceptIri(String contextId, Field field) throws Exception;
    String createValueConceptIri(String contextId, Field field) throws Exception;

    Integer getConceptId(String conceptIri) throws Exception;
    Integer getContextDbid(String contextId) throws Exception;
}
