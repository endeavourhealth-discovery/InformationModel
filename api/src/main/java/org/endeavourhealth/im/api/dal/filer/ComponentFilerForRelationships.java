package org.endeavourhealth.im.api.dal.filer;

import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.im.api.dal.ConnectionPool;
import org.endeavourhealth.im.api.models.TransactionComponent;
import org.endeavourhealth.im.common.models.RelatedConcept;
import org.endeavourhealth.im.common.models.Relationship;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComponentFilerForRelationships extends ComponentFiler {
    @Override
    public Long create(TransactionComponent transactionComponent) throws Exception {
        RelatedConcept relatedConcept = getRelatedConcept(transactionComponent);
        List<String> fieldList = getPopulatedFieldList(relatedConcept);
        String paramList = getParamList(fieldList);

        String sql = "INSERT INTO concept_relationship (" + String.join(",", fieldList) + ") " +
                "VALUES (" + paramList + ")";


        Connection conn = ConnectionPool.InformationModel.pop();

        try (PreparedStatement statement = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            setParameters(statement, relatedConcept);
            statement.executeUpdate();
            ResultSet rs = statement.getGeneratedKeys();
            rs.next();
            return rs.getLong(1);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }

    }

    @Override
    public void update(TransactionComponent transactionComponent) throws Exception {
    }

    @Override
    public void delete(TransactionComponent transactionComponent) throws Exception {
    }

    private RelatedConcept getRelatedConcept(TransactionComponent transactionComponent) throws java.io.IOException {
        return ObjectMapperPool.getInstance().readValue(transactionComponent.getData(), RelatedConcept.class);
    }

    private List<String> getPopulatedFieldList(RelatedConcept relatedConcept) {
        List<String> fields = new ArrayList<>();

        if (relatedConcept.getSource() != null) fields.add("source");
        if (relatedConcept.getRelationship() != null) fields.add("relationship");
        if (relatedConcept.getTarget() != null) fields.add("target");
        if (relatedConcept.getOrder() != null) fields.add("order");
        if (relatedConcept.getMandatory() != null) fields.add("mandatory");
        if (relatedConcept.getLimit() != null) fields.add("unlimited");
        if (relatedConcept.getWeighting() != null) fields.add("weighting");

        return fields;
    }

    private Integer setParameters(PreparedStatement statement, RelatedConcept relatedConcept) throws SQLException {
        int i = 1;

        if (relatedConcept.getSource() != null) statement.setLong(i++, relatedConcept.getSource().getId());
        if (relatedConcept.getRelationship() != null) statement.setLong(i++, relatedConcept.getRelationship().getId());
        if (relatedConcept.getTarget() != null) statement.setLong(i++, relatedConcept.getTarget().getId());
        if (relatedConcept.getOrder() != null) statement.setInt(i++, relatedConcept.getOrder());
        if (relatedConcept.getMandatory() != null) statement.setBoolean(i++, relatedConcept.getMandatory());
        if (relatedConcept.getLimit() != null) statement.setInt(i++, relatedConcept.getLimit());
        if (relatedConcept.getWeighting() != null) statement.setInt(i++, relatedConcept.getWeighting());

        return i;
    }
}
