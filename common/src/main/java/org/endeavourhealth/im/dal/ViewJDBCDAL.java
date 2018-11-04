package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.Concept;
import org.endeavourhealth.im.models.ConceptSummary;
import org.endeavourhealth.im.models.View;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static org.endeavourhealth.im.dal.DALHelper.*;

public class ViewJDBCDAL implements ViewDAL {
    @Override
    public List<View> list(Long parent) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        String sql = "SELECT c.id, c.full_name, c.description, c.last_update " +
            "FROM concept c " +
            "LEFT JOIN concept_relationship cr ON cr.source = c.id AND cr.relationship = 100 " + // 100 == Is a
            "WHERE c.superclass = 3 ";         // Views

        if (parent == null)
            sql += "AND cr.target IS NULL ";
        else
            sql += "AND cr.target = ? ";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            int i = 1;
            if (parent != null)
                stmt.setLong(i++, parent);

            return getViewListFromStatement(stmt);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public View get(Long id) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        String sql = "SELECT id, full_name, description, last_update FROM concept WHERE id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);

            ResultSet rs = stmt.executeQuery();

            if (rs.next())
                return getViewFromResultSet(rs);
            else
                return null;
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public View save(View view) throws Exception {
//        Connection conn = ConnectionPool.InformationModel.pop();
//        String sql = (view.isNew())
//            ? "INSERT INTO concept_view (name, description, last_update) VALUES (?, ?, ?)"
//            : "UPDATE concept_view SET name = ?, description = ?, last_update = ? WHERE id = ?";
//
//        view.setLastUpdated(new Date());
//
//        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
//            int i = 1;
//            stmt.setString(i++, view.getName());
//            stmt.setString(i++, view.getDescription());
//            stmt.setDate(i++, new java.sql.Date(view.getLastUpdated().getTime()));
//            if (!view.isNew())
//                stmt.setLong(i++, view.getId());
//
//            stmt.executeUpdate();
//
//            if (view.isNew())
//                view.setId(getGeneratedKey(stmt));
//
//        } finally {
//            ConnectionPool.InformationModel.push(conn);
//        }
//
        return view;
    }

    @Override
    public List<ConceptSummary> getConcepts(Long id) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        String sql = "SELECT c.id, c.full_name, c.context, c.status, c.version, false as synonym " +
            "FROM concept c " +
            "JOIN concept_relationship cr on cr.source = c.id and cr.relationship = 109 " + // Belongs to
            "WHERE cr.target = ? ";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);

            return getConceptSummaryListFromStatement(stmt);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }
}
