package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.mapping.*;

public interface IMMappingDAL {
    MapNode getNode(String provider, String system, String schema, String table, String column, String target) throws Exception;

    ConceptIdentifiers getNodePropertyConcept(String node) throws Exception;


    MapValueNode getValueNode(String node, String codeScheme) throws Exception;
    MapValueNode createValueNode(String node, String codeScheme) throws Exception;

    ConceptIdentifiers getValueNodeConcept(MapValueNode valueNode, MapValueRequest value) throws Exception;
    ConceptIdentifiers createValueNodeConcept(MapValueNode valueNode, String provider, String system, String schema, String table, String column, MapValueRequest value) throws Exception;

    ConceptIdentifiers getConceptIdentifiers(String iri) throws Exception;
    ConceptIdentifiers createLegacyPropertyValueConcept(String provider, String system, String schema, String table, String column, MapValueRequest value) throws Exception;

    ConceptIdentifiers createFormattedValueNodeConcept(String provider, String system, String schema, String table, String column, MapValueRequest value, String iri) throws Exception;





    /*
    Integer getOrganisationDbid(Identifier organisation) throws Exception;
    Integer getOrganisationDbidByAlias(String organisationAlias) throws Exception;
    int createOrganisation(Identifier organisation) throws Exception;

    Integer getSystemDbid(Identifier system) throws Exception;
    Integer getSystemDbidByAlias(String systemAlias) throws Exception;
    int createSystem(Identifier system) throws Exception;

    Integer getSchemaDbid(String schema) throws Exception;
    int createSchema(String schema) throws Exception;

    Integer getContextDbid(int organisationDbid, int systemDbid, int schemaDbid) throws Exception;
    int createContext(int organisationDbid, int systemDbid, int schemaDbid) throws Exception;


    Integer getTableDbid(String table) throws Exception;
    int createTable(String table) throws Exception;

    ConceptIdentifiers getPropertyConceptIdentifiers(String contextId, String field) throws Exception;
    ConceptIdentifiers createPropertyConcept(String contextId, String field) throws Exception;

    ConceptIdentifiers getValueConceptIdentifiers(String contextId, Field field) throws Exception;
    ConceptIdentifiers createValueConcept(String contextId, Field field) throws Exception;

    Integer getConceptId(String conceptIri) throws Exception;
    */
}
