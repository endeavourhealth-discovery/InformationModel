package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.*;

import java.sql.*;
import java.util.List;

import static java.sql.Types.BIGINT;
import static org.endeavourhealth.im.dal.DALHelper.*;

public class ViewJDBCDAL implements ViewDAL {
    @Override
    public List<View> list() throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        String sql = "SELECT *\n" +
            "FROM view\n";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            return getViewListFromStatement(stmt);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public View get(Long viewId) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        String sql = "SELECT *\n" +
            "FROM view\n" +
            "WHERE id=?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, viewId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return getViewFromResultSet(rs);
                } else {
                    return null;
                }
            }
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public View save(View view) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        String sql = view.getId() == null
            ? "INSERT INTO `view` (name, description) VALUES (?, ?)"
            : "UPDATE `view` SET name = ?, description = ? WHERE id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, view.getName());
            stmt.setString(2, view.getDescription());
            if (view.getId() != null)
                stmt.setLong(3, view.getId());

            stmt.executeUpdate();

            if (view.getId() == null)
                view.setId(getGeneratedKey(stmt));

            return view;
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public void delete(Long viewId) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        conn.setAutoCommit(false);

        try {
            try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM view_item WHERE view = ?")) {
                stmt.setLong(1, viewId);
                stmt.executeUpdate();
            }
            try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM `view` WHERE id = ?")) {
                stmt.setLong(1, viewId);
                stmt.executeUpdate();
            }
            conn.commit();
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public List<ViewItem> getViewContents(Long view, Long parent) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        String sql = "SELECT v.*, c.full_name AS concept_name, p.full_name AS parent_name, x.full_name AS context_name\n" +
            "FROM view_item v\n" +
            "JOIN concept c ON c.id = v.concept\n" +
            "LEFT OUTER JOIN concept p ON p.id = v.parent\n" +
            "LEFT OUTER JOIN concept x ON x.id = v.context\n" +
            "WHERE v.view = ?\n";
        if (parent == null)
            sql += "AND v.parent IS NULL\n";
        else
            sql += "AND v.parent = ?\n";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, view);
            if (parent != null)
                stmt.setLong(2, parent);

            return getViewItemListFromStatement(stmt);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public List<ViewItem> getSubTypes(Long parent) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        String sql = "SELECT c.id as id, c.id as concept, c.full_name AS concept_name, c.superclass as parent, p.full_name AS parent_name, null as context, null AS context_name\n" +
            "FROM concept c\n" +
            "LEFT JOIN concept p ON p.id = c.superclass\n";
        if (parent == null)
            sql += "WHERE c.superclass IS NULL\n";
        else {
            sql += "WHERE c.superclass = ?\n";
            if (parent == 2L)
                sql += "LIMIT 200"; // Restrict for Codeable concepts so we dont try to load ~900,000 concepts!
        }

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (parent != null)
                stmt.setLong(1, parent);

            return getViewItemListFromStatement(stmt);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public void addItem(Long viewId, ViewItemAddStyle addStyle, Long conceptId, List<Long> attributeIds, Long parentId) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();

        try {
            conn.setAutoCommit(false);
            if (addStyle == ViewItemAddStyle.CONCEPT_ONLY) {
                this.saveViewItem(conn, viewId, conceptId, null, parentId);
            } else {
                if (addStyle == ViewItemAddStyle.BOTH) {
                    this.saveViewItem(conn, viewId, conceptId, null, parentId);
                }

                for (Long attId : attributeIds) {
                    this.saveViewItem(conn, viewId, attId, conceptId, conceptId);
                }
            }
            conn.commit();
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public void deleteViewItem(Long viewItemId) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        String sql = "DELETE FROM view_item WHERE id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, viewItemId);
            stmt.executeUpdate();
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    private Long saveViewItem(Connection conn, Long viewId, Long conceptId, Long contextId, Long parentId) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO view_item (view, concept, context, parent) VALUES (?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, viewId);
            stmt.setLong(2, conceptId);
            if (contextId == null) stmt.setNull(3, BIGINT); else stmt.setLong(3, contextId);
            if (parentId == null) stmt.setNull(4, BIGINT); else stmt.setLong(4, parentId);
            stmt.executeUpdate();
            return getGeneratedKey(stmt);
        }
    }
}
