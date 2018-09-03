package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.common.models.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ConceptSelectorJDBCDAL implements ConceptSelectorDAL {
    private static final Logger LOG = LoggerFactory.getLogger(ConceptSelectorJDBCDAL.class);
    private static final int PAGE_SIZE = 15;

    @Override
    public ConceptSummaryList search(String searchTerm, Boolean activeOnly, List<Integer> systems) throws SQLException {
        searchTerm = "%" + searchTerm + "%";

        String sql = "SELECT ct.code_id as id, CONCAT('(', s.name, ') ', ct.term) as full_name, x.full_name as context, ct.status, c.concept_id as version, (c.status + ct.status + abs(x.status -1)) as sort " +
            "FROM code_term ct " +
            "JOIN code c on c.system = ct.system AND c.code_id = ct.code_id " +
            "JOIN code_system s ON s.id = c.system " +
            "JOIN concept x on x.id = c.concept_id " +
            "WHERE term like ? ";

        if (activeOnly != null && activeOnly)
            sql += "AND x.status = 1 ";

        sql +=
            "ORDER BY sort, use_count DESC, LENGTH(ct.term) " +
            "LIMIT ?";

        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            int i = 1;
            stmt.setString(i++, searchTerm);
            stmt.setInt(i++, PAGE_SIZE);
            return new ConceptSummaryList()
                .setPage(1)
                .setCount(PAGE_SIZE)
                .setConcepts(getSummaryResultSet(stmt));
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public List<IdText> getCodeSystems() throws SQLException {
        String sql = "SELECT id, name FROM code_system";
        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            List<IdText> result = new ArrayList<>();
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    result.add(new IdText()
                        .setId(rs.getLong("id"))
                        .setText(rs.getString("name"))
                    );
                }
                return result;
            }
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    private List<ConceptSummary> getSummaryResultSet(PreparedStatement stmt) throws SQLException {
        List<ConceptSummary> result = new ArrayList<>();

        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                result.add(getConceptSummary(rs));
            }
        }

        return result;
    }

    private ConceptSummary getConceptSummary(ResultSet rs) throws SQLException {
        return new ConceptSummary()
            .setId(rs.getLong("id"))
            .setContext(rs.getString("context"))
            .setFullName(rs.getString("full_name"))
            .setStatus(ConceptStatus.byValue(rs.getByte("status")).getName())
            .setVersion(rs.getString("version"));
    }
}
