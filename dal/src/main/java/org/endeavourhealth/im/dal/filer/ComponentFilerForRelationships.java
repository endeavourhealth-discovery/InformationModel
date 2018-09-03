package org.endeavourhealth.im.dal.filer;

import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.im.dal.ConnectionPool;
import org.endeavourhealth.im.common.models.TransactionComponent;
import org.endeavourhealth.im.common.models.DbEntity;
import org.endeavourhealth.im.common.models.RelatedConcept;

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
        RelatedConcept relatedConcept = getRelatedConcept(transactionComponent);
        List<String> fieldList = getPopulatedFieldList(relatedConcept);
        String sql = "UPDATE concept_relationship SET " +
            getUpdateList(fieldList) +
            " WHERE id = ?";
        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            int i = setParameters(statement, relatedConcept);

            statement.setLong(i, relatedConcept.getId());

            statement.executeUpdate();
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }    }

    @Override
    public void delete(TransactionComponent transactionComponent) throws Exception {
        DbEntity dbEntity = getDbEntity(transactionComponent);
        String sql = "DELETE FROM concept_relationship WHERE id = ?";
        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setLong(1, dbEntity.getId());
            statement.executeUpdate();
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    private RelatedConcept getRelatedConcept(TransactionComponent transactionComponent) throws java.io.IOException {
        return ObjectMapperPool.getInstance().readValue(transactionComponent.getData(), RelatedConcept.class);
    }

    private List<String> getPopulatedFieldList(RelatedConcept relatedConcept) {
        List<String> fields = new ArrayList<>();

        if (relatedConcept.getSourceId() != null) fields.add("source");
        if (relatedConcept.getRelationship() != null) fields.add("relationship");
        if (relatedConcept.getTargetId() != null) fields.add("target");
        if (relatedConcept.getOrder() != null) fields.add("`order`");
        if (relatedConcept.getMandatory() != null) fields.add("mandatory");
        if (relatedConcept.getLimit() != null) fields.add("`limit`");
        if (relatedConcept.getWeighting() != null) fields.add("weighting");

        return fields;
    }

    private Integer setParameters(PreparedStatement statement, RelatedConcept relatedConcept) throws SQLException {
        int i = 1;

        if (relatedConcept.getSourceId() != null) statement.setLong(i++, relatedConcept.getSourceId());
        if (relatedConcept.getRelationship() != null) statement.setLong(i++, relatedConcept.getRelationship().getId());
        if (relatedConcept.getTargetId() != null) statement.setLong(i++, relatedConcept.getTargetId());
        if (relatedConcept.getOrder() != null) statement.setInt(i++, relatedConcept.getOrder());
        if (relatedConcept.getMandatory() != null) statement.setBoolean(i++, relatedConcept.getMandatory());
        if (relatedConcept.getLimit() != null) statement.setInt(i++, relatedConcept.getLimit());
        if (relatedConcept.getWeighting() != null) statement.setInt(i++, relatedConcept.getWeighting());

        return i;
    }
}
