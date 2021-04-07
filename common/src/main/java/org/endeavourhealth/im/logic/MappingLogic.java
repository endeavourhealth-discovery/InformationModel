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

        if(isNullOrEmpty(nodeData.getTarget())
            || isNullOrEmpty(target)
            || nodeData.getTarget().equals(target)){
            mapResponse.setConcept(dal.getNodePropertyConcept(nodeData.getNode()));
        }
        return mapResponse;

    }

    private MapResponse getMapColumnValueRequest(MapRequest request) throws Exception {
        boolean wasCreated = false;
        MapColumnValueRequest valueRequest = request.getMapColumnValueRequest();

        MapNode nodeData = getColumnNode(
            valueRequest.getProvider(),
            valueRequest.getSystem(),
            valueRequest.getSchema(),
            valueRequest.getTable(),
            valueRequest.getColumn(),
            valueRequest.getTarget()
        ).getNode();

        MapValueNode valueNode = dal.getValueNode(nodeData.getNode(), valueRequest.getValue().getScheme());
        if (valueNode == null) {
            valueNode = dal.createValueNode(nodeData.getNode(), valueRequest.getValue().getScheme());
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
                wasCreated = true;
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
                    valueRequest.getValue(),
                    valueRequest.getColumn(),
                    (valueRequest.getValue().getCode()==null || valueRequest.getValue().getCode().isEmpty())
                        ? valueRequest.getValue().getTerm() : valueRequest.getValue().getCode()
                );
                wasCreated = true;
            }
        }

        return new MapResponse()
            .setNode(nodeData)
            .setValueNode(valueNode)
            .setRequest(request)
            .setConcept(ids)
            .setWasCreated(wasCreated);
    }

    private boolean isNullOrEmpty(String value) {
        return (value == null || value.isEmpty());
    }

}
