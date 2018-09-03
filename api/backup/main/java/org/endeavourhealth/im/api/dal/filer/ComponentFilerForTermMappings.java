package org.endeavourhealth.im.dal.filer;

import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.im.dal.ConnectionPool;
import org.endeavourhealth.im.api.models.TermMapping;
import org.endeavourhealth.im.api.models.TransactionComponent;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class ComponentFilerForTermMappings extends ComponentFiler {
    @Override
    public Long create(TransactionComponent transactionComponent) throws Exception {
        TermMapping termMapping = getTermMapping(transactionComponent);

        String sql = "INSERT INTO term_mapping (organisation, context, system, code, concept_id) VALUES (?, ?, ?, ?, ?)";

        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement statement = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, termMapping.getOrganisation());
            statement.setString(2, termMapping.getContext());
            statement.setString(3, termMapping.getSystem());
            statement.setString(4, termMapping.getCode());
            statement.setLong(5, termMapping.getConceptId());
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

    private TermMapping getTermMapping(TransactionComponent transactionComponent) throws IOException {
        return ObjectMapperPool.getInstance().readValue(transactionComponent.getData(), TermMapping.class);
    }
}

