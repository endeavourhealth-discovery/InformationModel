package org.endeavourhealth.im.api.dal.filer;

import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.im.api.dal.ConnectionPool;
import org.endeavourhealth.im.common.models.Concept;
import org.endeavourhealth.im.api.models.TransactionComponent;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComponentFilerForConcepts extends ComponentFiler {
    @Override
    public Long create(TransactionComponent transactionComponent) throws Exception {
        Concept concept = getConcept(transactionComponent);

        return createConcept(concept);
    }

    protected Long createConcept(Concept concept) throws SQLException {
        // concept.setId(TableIdHelper.getNextId("concept"));

        List<String> fieldList = getPopulatedFieldList(concept);
        String paramList = getParamList(fieldList);

        String sql = "INSERT INTO concept (" + String.join(",", fieldList) + ") " +
                "VALUES (" + paramList + ")";

        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement statement = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            setParameters(statement, concept);
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
        Concept concept = getConcept(transactionComponent);
        List<String> fieldList = getPopulatedFieldList(concept);
        String sql = "UPDATE concept SET " +
                getUpdateList(fieldList) +
                " WHERE id = ?";
        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            int i = setParameters(statement, concept);

            statement.setLong(i, concept.getId());

            statement.executeUpdate();
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public void delete(TransactionComponent transactionComponent) {
    }

    private Concept getConcept(TransactionComponent transactionComponent) throws java.io.IOException {
        return ObjectMapperPool.getInstance().readValue(transactionComponent.getData(), Concept.class);
    }

    private List<String> getPopulatedFieldList(Concept concept) {
        List<String> fields = new ArrayList<>();

        if (concept.getId() != null) fields.add("id");
        if (concept.getUrl() != null) fields.add("url");
        if (concept.getFullName() != null) fields.add("full_name");
        if (concept.getContext() != null) fields.add("context");
        if (concept.getStatus() != null) fields.add("status");
        if (concept.getVersion() != null) fields.add("version");
        if (concept.getDescription() != null) fields.add("description");
        if (concept.getExpression() != null) fields.add("expression");
        if (concept.getCriteria() != null) fields.add("criteria");
        if (concept.getUseCount() != null) fields.add("use_count");

        return fields;
    }

    private Integer setParameters(PreparedStatement statement, Concept concept) throws SQLException {
        int i = 1;

        if (concept.getId() != null)
            statement.setLong(i++, concept.getId());

        if (concept.getUrl() != null)
            statement.setString(i++, concept.getUrl());

        if (concept.getFullName() != null)
            statement.setString(i++, concept.getFullName());

        if (concept.getContext() != null)
            statement.setString(i++, concept.getContext());

        if (concept.getStatus() != null)
            statement.setByte(i++, concept.getStatus().getValue());

        if (concept.getVersion() != null)
            statement.setString(i++, concept.getVersion());

        if (concept.getDescription() != null)
            statement.setString(i++, concept.getDescription());

        if (concept.getExpression() != null)
            statement.setString(i++, concept.getExpression());

        if (concept.getCriteria() != null)
            statement.setString(i++, concept.getCriteria());

        if (concept.getUseCount() != null)
            statement.setLong(i++, concept.getUseCount());

        return i;
    }

}
