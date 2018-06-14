package org.endeavourhealth.im.api.dal.filer;

import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.im.api.dal.ConnectionPool;
import org.endeavourhealth.im.api.dal.TableIdHelper;
import org.endeavourhealth.im.api.models.TransactionComponent;
import org.endeavourhealth.im.common.models.Attribute;
import org.endeavourhealth.im.common.models.Concept;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComponentFilerForAttributes extends ComponentFiler {
    @Override
    public Long create(TransactionComponent transactionComponent) throws Exception {
        Attribute attribute = getAttribute(transactionComponent);
        List<String> fieldList = getPopulatedFieldList(attribute);
        String paramList = getParamList(fieldList);

        String sql = "INSERT INTO concept_attribute (" + String.join(",", fieldList) + ") " +
                "VALUES (" + paramList + ")";

        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement statement = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            setParameters(statement, attribute);
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
        Attribute attribute = getAttribute(transactionComponent);
        List<String> fieldList = getPopulatedFieldList(attribute);
        String sql = "UPDATE concept_attribute SET " +
                getUpdateList(fieldList) +
                " WHERE id = ?";
        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            int i = setParameters(statement, attribute);

            statement.setLong(i++, attribute.getId());

            statement.executeUpdate();
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public void delete(TransactionComponent transactionComponent) {
    }

    private Attribute getAttribute(TransactionComponent transactionComponent) throws java.io.IOException {
        return ObjectMapperPool.getInstance().readValue(transactionComponent.getData(), Attribute.class);
    }

    private List<String> getPopulatedFieldList(Attribute attribute) {
        List<String> fields = new ArrayList<>();

        if (attribute.getId() != null) fields.add("id");
        if (attribute.getConceptId() != null) fields.add("concept_id");
        if (attribute.getAttributeId() != null) fields.add("attribute_id");
        if (attribute.getOrder() != null) fields.add("order");
        if (attribute.getMandatory() != null) fields.add("mandatory");
        if (attribute.getLimit() != null) fields.add("limit");

        return fields;
    }

    private Integer setParameters(PreparedStatement statement, Attribute attribute) throws SQLException {
        int i = 1;

        if (attribute.getId() != null) statement.setLong(i++, attribute.getId());
        if (attribute.getConceptId() != null) statement.setLong(i++, attribute.getConceptId());
        if (attribute.getAttributeId() != null) statement.setLong(i++, attribute.getAttributeId());
        if (attribute.getOrder() != null) statement.setInt(i++, attribute.getOrder());
        if (attribute.getMandatory() != null) statement.setBoolean(i++, attribute.getMandatory());
        if (attribute.getLimit() != null) statement.setInt(i++, attribute.getLimit());

        return i;
    }

}
