package org.endeavourhealth.im.api.dal.filer;

import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.im.api.dal.ConnectionPool;
import org.endeavourhealth.im.api.models.TransactionComponent;
import org.endeavourhealth.im.common.models.AttributeModel;
import org.endeavourhealth.im.common.models.Concept;

import java.sql.*;

public class ComponentFilerForAttributeModels extends ComponentFiler {
    private ComponentFilerForConcepts conceptFiler = new ComponentFilerForConcepts();

    @Override
    public Long create(TransactionComponent transactionComponent) throws Exception {
        AttributeModel attributeModel = ObjectMapperPool.getInstance().readValue(transactionComponent.getData(), AttributeModel.class);

        Concept amConcept = new Concept().setContext(attributeModel.getContext());
        Long amConceptId = conceptFiler.createConcept(amConcept);

        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement statement = conn.prepareStatement("INSERT INTO record_type (id) VALUES (?)")) {
            statement.setLong(1, amConceptId);
            statement.executeUpdate();
            return amConceptId;
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public void update(TransactionComponent transactionComponent) throws Exception {
    }

    @Override
    public void delete(TransactionComponent transactionComponent) {
    }
}
