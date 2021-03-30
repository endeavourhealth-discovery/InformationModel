package org.endeavourhealth.im.logic;

import org.apache.commons.lang3.StringUtils;
import org.endeavourhealth.im.dal.IMMappingDAL;
import org.endeavourhealth.im.dal.IMMappingJDBCDAL;
import org.endeavourhealth.im.models.mapping.*;

public class MappingLogic {
    public static String getShortString(String id) {
        // Handle concepts and standard prefixes
        if (id.startsWith("CM_Sys_")) id = id.substring(7);
        else if (id.startsWith("CM_Org_")) id = id.substring(7);
        else if (id.startsWith("CM_")) id = id.substring(3);

        // Strip vowels and spaces (excluding first), return first 3
        id = (id.substring(0, 1) +
            id.substring(1).replaceAll("[aeiou\\-_ ]", ""));
        return StringUtils.left(id, 3);
    }

    private IMMappingDAL dal;

    public MappingLogic() {
        dal = new IMMappingJDBCDAL();
    }

    protected MappingLogic(IMMappingDAL dal) {
        this.dal = dal;
    }

    public MapResponse getMapping(MapRequest request) throws Exception {
        if (request.getMapColumnRequest() != null)
            return getMapColumnRequest(request);
        else if (request.getMapColumnValueRequest() != null)
            return getMapColumnValueRequest(request);
        else
            throw new IllegalStateException("Unknown mapping request");
    }

    private MapResponse getMapColumnRequest(MapRequest request) throws Exception {
        MapColumnRequest columnRequest = request.getMapColumnRequest();
        MapResponse mapResponse = getColumnNode(
                columnRequest.getProvider(),
                columnRequest.getSystem(),
                columnRequest.getSchema(),
                columnRequest.getTable(),
                columnRequest.getColumn(),
                columnRequest.getTarget());

        if(mapResponse == null)
            return null;

        return mapResponse.setRequest(request);
    }

    private MapResponse getColumnNode(String provider, String system, String schema, String table, String column, String target) throws Exception {
        MapNode nodeData = dal.getNode(
            provider,
            system,
            schema,
            table,
            column,
                target
        );

        if (nodeData == null)
            return null;

        MapResponse mapResponse = new MapResponse().setNode(nodeData);

        if(nodeData.getTarget()==null || nodeData.getTarget().equals(target)){
            mapResponse.setConcept(dal.getNodePropertyConcept(nodeData.getNode()));
        }
        return mapResponse;

    }

    private MapResponse getMapColumnValueRequest(MapRequest request) throws Exception {
        MapColumnValueRequest valueRequest = request.getMapColumnValueRequest();

        MapResponse nodeData = getColumnNode(
            valueRequest.getProvider(),
            valueRequest.getSystem(),
            valueRequest.getSchema(),
            valueRequest.getTable(),
            valueRequest.getColumn(),
                valueRequest.getTarget()
        );

        MapValueNode valueNode = dal.getValueNode(nodeData.getNode().getNode(), valueRequest.getValue().getScheme());
        if (valueNode == null) {
            valueNode = dal.createValueNode(nodeData.getNode().getNode(), valueRequest.getValue().getScheme());
        }

        ConceptIdentifiers ids;
        if (valueNode.getFunction().startsWith("Format(")) {
            String format = valueNode.getFunction().substring(7, valueNode.getFunction().length() - 1);
            String iri = String.format(format, valueRequest.getValue().getCode());
            ids = dal.getConceptIdentifiers(iri);
            if (ids == null) {

                ids = dal.createFormattedValueNodeConcept(
                    valueRequest.getProvider(),
                    valueRequest.getSystem(),
                    valueRequest.getSchema(),
                    valueRequest.getTable(),
                    valueRequest.getColumn(),
                    valueRequest.getValue(),
                    iri
                );
                nodeData.setWasCreated(true);
            }
        } else {
            // valueNode.getFunction().equals("Lookup()")
            ids = dal.getValueNodeConcept(valueNode, valueRequest.getValue());
            if (ids == null) {
                ids = dal.createValueNodeConcept(
                    valueNode,
                    valueRequest.getProvider(),
                    valueRequest.getSystem(),
                    valueRequest.getSchema(),
                    valueRequest.getTable(),
                    valueRequest.getColumn(),
                    valueRequest.getValue()
                );
                nodeData.setWasCreated(true);
            }
        }

        return new MapResponse()
            .setNode(nodeData.getNode())
            .setValueNode(valueNode)
            .setRequest(request)
            .setConcept(ids);
    }



    /*
    private int getMapContext(Identifier organisation, Identifier system, String schema) throws Exception {
        int orgDbid = getOrCreateOrganisationDbid(organisation);
        int sysDbid = getOrCreateSystemDbid(system);
        int scmDbid = getOrCreateSchemaDbid(schema);

        Integer contextDbid = dal.getContextDbid(orgDbid, sysDbid, scmDbid);

        if (contextDbid == null)
            contextDbid = dal.createContext(orgDbid, sysDbid, scmDbid);

        return contextDbid;
    }

    private int getMapContext(String contextPath) throws Exception {
        String[] parts = contextPath.split("/");

        if (parts.length < 3)
            throw new IllegalStateException("Context must include organisation, system & schema (org/sys/scm) as a minimum");

        Integer orgDbid = dal.getOrganisationDbidByAlias(parts[0]);
        if (orgDbid == null)
            throw new IllegalStateException("Unknown organisation alias [" + parts[0] + "]");

        Integer sysDbid = dal.getSystemDbidByAlias(parts[1]);
        if (sysDbid == null)
            throw new IllegalStateException("Unknown system alias [" + parts[1] + "]");

        Integer scmDbid = dal.getSchemaDbid(parts[2]);
        if (scmDbid == null)
            throw new IllegalStateException("Unknown schema [" + parts[2] + "]");

        Integer contextDbid = dal.getContextDbid(orgDbid, sysDbid, scmDbid);

        if (contextDbid == null)
            contextDbid = dal.createContext(orgDbid, sysDbid, scmDbid);

        return contextDbid;
    }

    public int getOrCreateOrganisationDbid(Identifier organisation) throws Exception{
        Integer orgDbid = dal.getOrganisationDbid(organisation);
        if (orgDbid == null)
            orgDbid = dal.createOrganisation(organisation);

        return orgDbid;
    }

    public int getOrCreateSystemDbid(Identifier system) throws Exception{
        Integer sysDbid = dal.getSystemDbid(system);
        if (sysDbid == null)
            sysDbid = dal.createSystem(system);

        return sysDbid;
    }

    public int getOrCreateSchemaDbid(String schema) throws Exception{
        Integer scmDbid = dal.getSchemaDbid(schema);
        if (scmDbid == null)
            scmDbid = dal.createSchema(schema);

        return scmDbid;
    }


    public String getOrCreateTableId(Table table) throws Exception{
        String tblId = dal.getTableShort(table);
        if (tblId == null)
            tblId = dal.createTableShort(table);

        return tblId;
    }

    public ConceptIdentifiers getPropertyConceptIri(String contextId, String field) throws Exception {
        ConceptIdentifiers propertyConceptIri = dal.getPropertyConceptIdentifiers(contextId, field);

        if (propertyConceptIri == null)
            propertyConceptIri = dal.createPropertyConcept(contextId, field);

        return propertyConceptIri;
    }

    public ConceptIdentifiers getValueConceptIri(String contextId, Field field) throws Exception {
        ConceptIdentifiers valueConceptIri = dal.getValueConceptIdentifiers(contextId, field);

        if (valueConceptIri == null)
            valueConceptIri = dal.createValueConcept(contextId, field);

        return valueConceptIri;
    }

    public Integer getConceptDbid(String conceptIri) throws Exception {
        return dal.getConceptId(conceptIri);
    }
*/

}
