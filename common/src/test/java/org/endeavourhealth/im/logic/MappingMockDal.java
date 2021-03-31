package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.IMMappingDAL;
import org.endeavourhealth.im.models.mapping.ConceptIdentifiers;
import org.endeavourhealth.im.models.mapping.MapNode;
import org.endeavourhealth.im.models.mapping.MapValueNode;
import org.endeavourhealth.im.models.mapping.MapValueRequest;

public class MappingMockDal implements IMMappingDAL {

    private MapNode getNodeResult;
    private ConceptIdentifiers getNodePropertyConceptResult;
    private MapValueNode getValueNodeResult;
    private MapValueNode createValueNodeResult;
    private ConceptIdentifiers getValueNodeConceptResult;
    private ConceptIdentifiers createValueNodeConceptResult;
    private ConceptIdentifiers getConceptIdentifiersResult;
    private ConceptIdentifiers createLegacyPropertyValueConceptResult;
    private ConceptIdentifiers createFormattedValueNodeConceptResult;

    public MapNode getGetNodeResult() {
        return getNodeResult;
    }

    public MappingMockDal setGetNodeResult(MapNode getNodeResult) {
        this.getNodeResult = getNodeResult;
        return this;
    }

    public ConceptIdentifiers getGetNodePropertyConceptResult() {
        return getNodePropertyConceptResult;
    }

    public MappingMockDal setGetNodePropertyConceptResult(ConceptIdentifiers getNodePropertyConceptResult) {
        this.getNodePropertyConceptResult = getNodePropertyConceptResult;
        return this;
    }

    public MapValueNode getGetValueNodeResult() {
        return getValueNodeResult;
    }

    public MappingMockDal setGetValueNodeResult(MapValueNode getValueNodeResult) {
        this.getValueNodeResult = getValueNodeResult;
        return this;
    }

    public MapValueNode getCreateValueNodeResult() {
        return createValueNodeResult;
    }

    public MappingMockDal setCreateValueNodeResult(MapValueNode createValueNodeResult) {
        this.createValueNodeResult = createValueNodeResult;
        return this;
    }

    public ConceptIdentifiers getGetValueNodeConceptResult() {
        return getValueNodeConceptResult;
    }

    public MappingMockDal setGetValueNodeConceptResult(ConceptIdentifiers getValueNodeConceptResult) {
        this.getValueNodeConceptResult = getValueNodeConceptResult;
        return this;
    }

    public ConceptIdentifiers getCreateValueNodeConceptResult() {
        return createValueNodeConceptResult;
    }

    public MappingMockDal setCreateValueNodeConceptResult(ConceptIdentifiers createValueNodeConceptResult) {
        this.createValueNodeConceptResult = createValueNodeConceptResult;
        return this;
    }

    public ConceptIdentifiers getGetConceptIdentifiersResult() {
        return getConceptIdentifiersResult;
    }

    public MappingMockDal setGetConceptIdentifiersResult(ConceptIdentifiers getConceptIdentifiersResult) {
        this.getConceptIdentifiersResult = getConceptIdentifiersResult;
        return this;
    }

    public ConceptIdentifiers getCreateLegacyPropertyValueConceptResult() {
        return createLegacyPropertyValueConceptResult;
    }

    public MappingMockDal setCreateLegacyPropertyValueConceptResult(ConceptIdentifiers createLegacyPropertyValueConceptResult) {
        this.createLegacyPropertyValueConceptResult = createLegacyPropertyValueConceptResult;
        return this;
    }

    public ConceptIdentifiers getCreateFormattedValueNodeConceptResult() {
        return createFormattedValueNodeConceptResult;
    }

    public MappingMockDal setCreateFormattedValueNodeConceptResult(ConceptIdentifiers createFormattedValueNodeConceptResult) {
        this.createFormattedValueNodeConceptResult = createFormattedValueNodeConceptResult;
        return this;
    }

    @Override
    public MapNode getNode(String provider, String system, String schema, String table, String column, String target) throws Exception {
        return getNodeResult;
    }

    @Override
    public ConceptIdentifiers getNodePropertyConcept(String node) throws Exception {
        return getNodePropertyConceptResult;
    }

    @Override
    public MapValueNode getValueNode(String node, String codeScheme) throws Exception {
        return getValueNodeResult;
    }

    @Override
    public MapValueNode createValueNode(String node, String codeScheme) throws Exception {
        return createValueNodeResult;
    }

    @Override
    public ConceptIdentifiers getValueNodeConcept(MapValueNode valueNode, MapValueRequest value) throws Exception {
        return getValueNodeConceptResult;
    }

    @Override
    public ConceptIdentifiers createValueNodeConcept(MapValueNode valueNode, String provider, String system, String schema, String table, String column, MapValueRequest valueRequest, String propertyName, String value) throws Exception {
        return createValueNodeConceptResult;
    }

    @Override
    public ConceptIdentifiers getConceptIdentifiers(String iri) throws Exception {
        return getConceptIdentifiersResult;
    }

    @Override
    public ConceptIdentifiers createLegacyPropertyValueConcept(String provider, String system, String schema, String table, String column, MapValueRequest valueRequest, String propertyName, String value) throws Exception {
        return createLegacyPropertyValueConceptResult;
    }

    @Override
    public ConceptIdentifiers createFormattedValueNodeConcept(String provider, String system, String schema, String table, String column, MapValueRequest value, String iri) throws Exception {
        return createFormattedValueNodeConceptResult;
    }
}
