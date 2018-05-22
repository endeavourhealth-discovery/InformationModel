package org.endeavourhealth.im.api.dal.filer;

import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.im.api.dal.ConnectionPool;
import org.endeavourhealth.im.api.models.TransactionComponent;
import org.endeavourhealth.im.common.models.Relationship;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComponentFilerForRelationships extends ComponentFiler {
    @Override
    public Long create(TransactionComponent transactionComponent) throws Exception {
        Relationship relationship = getRelationship(transactionComponent);
        List<String> fieldList = getPopulatedFieldList(relationship);
        String paramList = getParamList(fieldList);

        String sql = "INSERT INTO concept_relationship (" + String.join(",", fieldList) + ") " +
                "VALUES (" + paramList + ")";


        Connection conn = ConnectionPool.InformationModel.pop();

        try (PreparedStatement statement = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            setParameters(statement, relationship);
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

    private Relationship getRelationship(TransactionComponent transactionComponent) throws java.io.IOException {
        return ObjectMapperPool.getInstance().readValue(transactionComponent.getData(), Relationship.class);
    }

    private List<String> getPopulatedFieldList(Relationship relationship) {
        List<String> fields = new ArrayList<>();

        if (relationship.getSource() != null) fields.add("source");
        if (relationship.getRelationship() != null) fields.add("relationship");
        if (relationship.getTarget() != null) fields.add("target");
        if (relationship.getOrder() != null) fields.add("order");
        if (relationship.getMandatory() != null) fields.add("mandatory");
        if (relationship.getUnlimited() != null) fields.add("unlimited");
        if (relationship.getWeighting() != null) fields.add("weighting");

        return fields;
    }

    private Integer setParameters(PreparedStatement statement, Relationship relationship) throws SQLException {
        int i = 1;

        if (relationship.getSource() != null) statement.setLong(i++, relationship.getSource());
        if (relationship.getRelationship() != null) statement.setLong(i++, relationship.getRelationship().getId());
        if (relationship.getTarget() != null) statement.setLong(i++, relationship.getTarget());
        if (relationship.getOrder() != null) statement.setInt(i++, relationship.getOrder());
        if (relationship.getMandatory() != null) statement.setBoolean(i++, relationship.getMandatory());
        if (relationship.getUnlimited() != null) statement.setBoolean(i++, relationship.getUnlimited());
        if (relationship.getWeighting() != null) statement.setInt(i++, relationship.getWeighting());

        return i;
    }
}
