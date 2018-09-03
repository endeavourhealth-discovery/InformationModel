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

public class ValueJDBCDAL implements ValueDAL {
    private static final Logger LOG = LoggerFactory.getLogger(ValueJDBCDAL.class);
    private static final int PAGE_SIZE = 15;

    @Override
    public ValueSummaryList getMRU() throws Exception {
        Connection conn = ConnectionPool.InformationModel.pop();
        String sql = "SELECT v.id, v.concept_id, v.name, c.context " +
            "FROM concept_value v " +
            "JOIN concept c ON c.id = v.concept_id " +
            "ORDER BY id DESC LIMIT ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, PAGE_SIZE);

            return new ValueSummaryList()
                .setPage(1)
                .setCount(PAGE_SIZE)
                .setConceptValues(getSummaryResultSet(stmt));
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public ValueSummary get(Long id) throws Exception {
        Connection conn = ConnectionPool.InformationModel.pop();
        ValueSummary result = null;
        String sql = "SELECT v.id, v.concept_id, v.name, c.context " +
            "FROM concept_value v " +
            "JOIN concept c ON c.id = v.concept_id " +
            "WHERE v.id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    result = getValueSummary(rs);

            }

            return result;
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    private List<ValueSummary> getSummaryResultSet(PreparedStatement stmt) throws SQLException {
        List<ValueSummary> result = new ArrayList<>();

        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                result.add(getValueSummary(rs));
            }
        }

        return result;
    }

    private ValueSummary getValueSummary(ResultSet rs) throws SQLException {
        return new ValueSummary()
            .setId(rs.getLong("id"))
            .setName(rs.getString("name"))
            .setConcept(new ConceptReference()
                .setId(rs.getLong("concept_id"))
                .setText(rs.getString("context"))
            );
    }
}
