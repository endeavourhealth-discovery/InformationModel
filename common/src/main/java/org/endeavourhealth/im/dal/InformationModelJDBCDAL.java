package org.endeavourhealth.im.dal;

import com.fasterxml.jackson.databind.JsonNode;
import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.im.models.Concept;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class InformationModelJDBCDAL implements InformationModelDAL {
    @Override
    public void saveDocument(String documentJson) throws SQLException, IOException {
        JsonNode root = ObjectMapperPool.getInstance().readTree(documentJson);
        String dbid = root.get("@document").asText();

        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement stmt = conn.prepareStatement("REPLACE INTO document (dbid, data) VALUES (hashId(?), ?)")) {
            stmt.setString(1, dbid);
            stmt.setString(2, documentJson);
            stmt.execute();
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }

    @Override
    public void saveConcept(String conceptJson) throws SQLException, IOException {
        JsonNode root = ObjectMapperPool.getInstance().readTree(conceptJson);
        String dbid = root.get("@id").asText();

        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement stmt = conn.prepareStatement("REPLACE INTO concept (dbid, data) VALUES (hashId(?), ?)")) {
            stmt.setString(1, dbid);
            stmt.setString(2, conceptJson);
            stmt.execute();
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }

    @Override
    public List<Concept> mru() throws Exception {
        return search("");
    }

    @Override
    public List<Concept> search(String text) throws Exception {
        List<Concept> result = new ArrayList<>();

        String sql = "SELECT id, name, description, scheme, code FROM concept\n";

        if (text != null && !text.isEmpty())
            sql += " WHERE id LIKE ?\n" +
                "ORDER BY LENGTH(id)";

        sql += "LIMIT 20";

        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            if (text != null && !text.isEmpty())
                statement.setString(1, '%' + text + '%');
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                result.add(
                    new Concept()
                    .setId(resultSet.getString("id"))
                    .setName(resultSet.getString("name"))
                    .setDescription(resultSet.getString("description"))
                    .setScheme(resultSet.getString("scheme"))
                    .setCode(resultSet.getString("code"))
                );
            }
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
        return result;
    }

    @Override
    public String get(String id) throws SQLException {
        String sql = "SELECT data FROM concept WHERE dbid = hashId(?)\n";

        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, id);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next())
                return resultSet.getString("data");
            else
                return null;
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }

    @Override
    public String getName(String id) throws SQLException {
        String sql = "SELECT name FROM concept WHERE dbid = hashId(?)\n";

        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, id);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next())
                return resultSet.getString("name");
            else
                return null;
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }

    @Override
    public List<String> getDocuments() throws SQLException {
        List<String> result = new ArrayList<>();

        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement statement = conn.prepareStatement("SELECT iri FROM document")) {
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                result.add(resultSet.getString("iri"));
            }
        } finally {
            ConnectionPool.getInstance().push(conn);
        }

        return result;
    }

    @Override
    public String validateIds(List<String> ids) throws Exception {
        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement statement = conn.prepareStatement("SELECT 1 FROM concept WHERE dbid = hashId(?)")) {

            for (String id : ids) {
                statement.setString(1, id);
                ResultSet rs = statement.executeQuery();
                if (!rs.next())
                    return id;
            }

        } finally {
            ConnectionPool.getInstance().push(conn);
        }

        return null;
    }
}
