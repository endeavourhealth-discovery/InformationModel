package org.endeavourhealth.im.api.dal;

import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.im.api.dal.filer.IMFilerDAL;
import org.endeavourhealth.im.api.dal.filer.IMFilerJDBCDAL;
import org.endeavourhealth.im.api.models.Transaction;
import org.endeavourhealth.im.api.models.TransactionAction;
import org.endeavourhealth.im.api.models.TransactionComponent;
import org.endeavourhealth.im.api.models.TransactionTable;
import org.endeavourhealth.im.common.models.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class AttributeModelJDBCDAL implements AttributeModelDAL {
    private static final Logger LOG = LoggerFactory.getLogger(AttributeModelJDBCDAL.class);
    private static final int PAGE_SIZE = 15;
    private final IMFilerDAL filer;

    public AttributeModelJDBCDAL() {
        this.filer = new IMFilerJDBCDAL();
    }

    public AttributeModelJDBCDAL(IMFilerDAL filer) {
        this.filer = filer;
    }

    @Override
    public List<AttributeModelSummary> getSummaries(Integer page) throws SQLException {
        List<AttributeModelSummary> result = new ArrayList<>();
        Connection conn = ConnectionPool.InformationModel.pop();

        int offset = (page -1) * PAGE_SIZE;
        String sql = "SELECT am.id, am.inherits_from, amic.context as inherits_context, c.context, c.status, c.version " +
                "FROM record_type am " +
                "JOIN concept c on c.id = am.id " +
                "LEFT OUTER JOIN concept amic ON amic.id = am.inherits_from " +
                "LIMIT ?, ?";

        try(PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, offset);
            stmt.setInt(2, PAGE_SIZE);
            ResultSet rs = stmt.executeQuery();

            while(rs.next()) {
                result.add(new AttributeModelSummary()
                        .setId(rs.getLong("id"))
                        .setInherits(new ConceptReference()
                                .setId(rs.getLong("inherits_from"))
                                .setContext(rs.getString("inherits_context"))
                        )
                        .setContext(rs.getString("context"))
                        .setStatus(ConceptStatus.byValue(rs.getByte("status")).getName())
                        .setVersion(rs.getString("version"))
                );
            }
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }

        return result;
    }

    @Override
    public AttributeModelSummary getSummaryByContext(String context) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();

        String sql = "SELECT am.id, am.inherits_from, amic.context as inherits_context, c.context, c.status, c.version " +
                "FROM record_type am " +
                "JOIN concept c on c.id = am.id " +
                "LEFT OUTER JOIN concept amic ON amic.id = am.inherits_from " +
                "WHERE c.context = ?";

        try(PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, context);
            ResultSet rs = stmt.executeQuery();

            if(rs.next()) {
                return new AttributeModelSummary()
                        .setId(rs.getLong("id"))
                        .setInherits(new ConceptReference()
                                .setId(rs.getLong("inherits_from"))
                                .setContext(rs.getString("inherits_context"))
                        )
                        .setContext(rs.getString("context"))
                        .setStatus(ConceptStatus.byValue(rs.getByte("status")).getName())
                        .setVersion(rs.getString("version"));
            }
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }

        return null;
    }

    @Override
    public Long createDraftAttributeModel(String context) throws Exception {
        AttributeModel attributeModel = new AttributeModel()
                .setContext(context);

        return this.filer.storeAndApply("Endeavour health", TransactionAction.CREATE, TransactionTable.ATTRIBUTE_MODEL, attributeModel);
    }

    @Override
    public List<ConceptSummary> getAttributes(Long conceptId) throws SQLException {
        List<ConceptSummary> result = new ArrayList<>();

        Connection conn = ConnectionPool.InformationModel.pop();

        String sql = "SELECT c.id, c.context, c.status, c.version " +
            "FROM record_type_attribute r " +
            "JOIN concept c ON c.id = r.data_type " +
            "WHERE r.record_type = ?";

        try(PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, conceptId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                result.add( new ConceptSummary()
                    .setId(rs.getLong("id"))
                    .setContext(rs.getString("context"))
                    .setStatus(rs.getString("status"))
                    .setVersion(rs.getString("version"))
                );
            }
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }

        return result;
    }
}
