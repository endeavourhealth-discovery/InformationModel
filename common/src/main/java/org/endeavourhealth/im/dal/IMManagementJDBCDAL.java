package org.endeavourhealth.im.dal;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.im.models.Document;
import org.endeavourhealth.im.models.Version;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.*;

public class IMManagementJDBCDAL {
    private static Logger LOG = LoggerFactory.getLogger(IMManagementJDBCDAL.class);
    private static String status = "Running";
    private HashMap<String, Integer> idMap = new HashMap<>();

    public String getStatus() {
        return status;
    }

    public List<Document> getDocuments() throws SQLException {
        List<Document> result = new ArrayList<>();

        String sql = "SELECT d.dbid, d.path, d.version, COUNT(c.dbid) AS drafts\n" +
            "FROM document d\n" +
            "LEFT JOIN concept c ON c.document = d.dbid AND c.draft = TRUE\n" +
            "GROUP BY d.dbid";

        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement statement = conn.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                result.add(
                    new Document()
                        .setDbid(resultSet.getInt("dbid"))
                        .setPath(resultSet.getString("path"))
                        .setVersion(Version.fromString(resultSet.getString("version")))
                        .setDrafts(resultSet.getInt("drafts"))
                );
            }
        } finally {
            ConnectionPool.getInstance().push(conn);
        }

        return result;
    }

    public String importDocument(String documentJson) throws Exception {
        if (!"Running".equals(status)) {
            LOG.warn("Import already in progress, aborting");
            return status;
        }

        status = "Importing ";

        Connection conn = ConnectionPool.getInstance().pop();
        // conn.setAutoCommit(false);

        try {
            LOG.debug("Deserialising document...");
            JsonNode root = ObjectMapperPool.getInstance().readTree(documentJson);

            LOG.debug("Extracting document meta data...");
            String docIri = root.get("document").asText();
            String docPath = docIri.substring(0, docIri.lastIndexOf("/"));
            String docVer = docIri.substring(docIri.lastIndexOf("/") + 1);

            status += docIri;

            LOG.debug("Ensuring document exists...");
            int docDbid = getOrCreateDocumentDBId(conn, docPath);

            importConcepts(root, conn, docDbid);
            importTermMaps(root, conn);

            status = "Updating document version";
            LOG.debug("Updating document...");
            // Set new document version
            updateDocumentVersion(conn, docDbid, docVer);

//            conn.commit();
        } catch (Exception e) {
            LOG.error(e.getMessage());
//            conn.rollback();
            throw e;
        } finally {
            status = "Running";
            ConnectionPool.getInstance().push(conn);
        }
        LOG.debug("Document import complete");
        return "Import complete";
    }
    private void importTermMaps(JsonNode root, Connection conn) throws SQLException {
        if (root.has("TermMaps")) {
            LOG.debug("Importing term maps");
            ArrayNode maps = (ArrayNode) root.get("TermMaps");

            String sql = "REPLACE INTO concept_term_map (term, type, target)\n" +
                "SELECT ?, typ.dbid, tgt.dbid\n" +
                "FROM concept typ\n" +
                "JOIN concept tgt\n ON tgt.id = ?\n" +
                "WHERE typ.id = ?\n";

            Iterator<JsonNode> iterator = maps.iterator();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                int i = 0;
                int s = maps.size();
                while (iterator.hasNext()) {
                    JsonNode map = iterator.next();
                    stmt.setString(1, map.get("term").asText());
                    stmt.setString(3, map.get("target").asText());
                    stmt.setString(2, map.get("type").asText());
                    stmt.execute();

                    if (i % 1000 == 0) {
                        status = "Updating term maps " + i + "/" + s;
                        LOG.debug(status);
                    }
                    i++;
                }
            }
        }
    }
    private void importConcepts(JsonNode root, Connection conn, int docDbid) throws Exception {
        if (root.has("Concepts")) {
            ArrayNode concepts = (ArrayNode) root.get("Concepts");

            LOG.debug("Checking " + concepts.size() + " concepts...");
            // Allocate concept ids first as necessary
            getOrCreateConceptDbids(conn, docDbid, concepts);
            updateConceptDefinitions(conn, concepts);
        }
    }
    private int getOrCreateDocumentDBId(Connection conn, String docPath) throws SQLException {
        Integer dbid = getDocumentDbid(conn, docPath);

        if (dbid != null)
            return dbid;

        try (PreparedStatement statement = conn.prepareStatement("INSERT INTO document (path, version) VALUES (?, '0.0.1')", Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, docPath);
            statement.execute();

            return DALHelper.getGeneratedKey(statement);
        }
    }
    private void getOrCreateConceptDbids(Connection conn, int docDbid, ArrayNode concepts) throws SQLException {
        // Prepare statements in advance for performance
        String conceptSql = "INSERT INTO concept (document, id, name, description, code, scheme)\n" +
            "SELECT d.*, c.dbid as scheme\n" +
            "FROM (SELECT ? as document, ? as id, ? as name, ? as description, ? as code) AS d\n" +
            "LEFT OUTER JOIN concept c ON c.id = ?";

        try (PreparedStatement getDbid = conn.prepareStatement("SELECT dbid FROM concept WHERE id = ?");
             PreparedStatement addConcept = conn.prepareStatement(conceptSql, Statement.RETURN_GENERATED_KEYS)) {
            idMap.clear();
            Iterator<JsonNode> elements = concepts.elements();
            // Iterate elements of concepts array
            int s = concepts.size();
            int i = 0;
            while (elements.hasNext()) {
                JsonNode concept = elements.next();
                String conceptId = concept.get("id").asText();
                if (!idMap.containsKey(conceptId)) {
                    // Not in the map, look in db
                    getDbid.setString(1, conceptId);
                    try (ResultSet rs = getDbid.executeQuery()) {
                        if (rs.next()) {
                            idMap.put(conceptId, rs.getInt("dbid"));
                        } else {
                            addConcept.setInt(1, docDbid);
                            addConcept.setString(2, conceptId);

                            DALHelper.setString(addConcept, 3, getJsonAsText(concept, "name"));
                            DALHelper.setString(addConcept, 4, getJsonAsText(concept, "description"));
                            DALHelper.setString(addConcept, 5, getJsonAsText(concept, "code"));
                            DALHelper.setString(addConcept, 6, getJsonAsText(concept, "scheme"));

                            addConcept.execute();
                            idMap.put(conceptId, DALHelper.getGeneratedKey(addConcept));
                        }
                    }
                }

                if (i % 1000 == 0) {
                    status = "Checking concept " + i + "/" + s;
                    LOG.debug(status);
                }
                i++;
            }
        }
    }
    private void updateConceptDefinitions(Connection conn, ArrayNode concepts) throws Exception {
        LOG.debug("Defining concepts...");
        Set<String> skipFields = new HashSet<>(Arrays.asList("id", "name", "description", "code", "scheme"));

        Iterator<JsonNode> iterator = concepts.iterator();
        int s = concepts.size();
        int i = 0;

        // Prepare statements in advance for performance
        try (PreparedStatement delData = conn.prepareStatement("DELETE FROM concept_property_data WHERE dbid = ?");
             PreparedStatement delObj = conn.prepareStatement("DELETE FROM concept_property_object WHERE dbid = ?");
             PreparedStatement insData = conn.prepareStatement("INSERT INTO concept_property_data (dbid, `group`, property, value) VALUES (?, ?, ?, ?)");
             PreparedStatement insObj = conn.prepareStatement("INSERT INTO concept_property_object (dbid, `group`, property, value) VALUES (?, ?, ?, ?)")
        ) {
            while (iterator.hasNext()) {
                JsonNode concept = iterator.next();

                String conceptId = concept.get("id").asText();
                int conceptDbid = idMap.get(conceptId);

                delData.setInt(1, conceptDbid);
                delData.execute();
                delObj.setInt(1, conceptDbid);
                delObj.execute();

                Iterator<Map.Entry<String, JsonNode>> fields = concept.fields();
                while (fields.hasNext()) {
                    Map.Entry<String, JsonNode> property = fields.next();
                    String propertyId = property.getKey();
                    if (!skipFields.contains(propertyId)) {
                        JsonNode value = property.getValue();
                        insertConceptProperty(conn, insData, insObj, conceptDbid, propertyId, value);
                    }
                }

                if (i % 1000 == 0) {
                    status = "Defining concept " + i + "/" + s;
                    LOG.debug(status);
                }
                i++;
            }
        }
    }
    private void updateDocumentVersion(Connection conn, int docDbid, String docVer) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement("UPDATE document SET version = ? WHERE dbid = ?")) {
            stmt.setString(1, docVer);
            stmt.setInt(2, docDbid);
            stmt.execute();
        }
    }
    private void insertConceptProperty(Connection conn, PreparedStatement insData, PreparedStatement insObj, int conceptDbid, String propertyId, JsonNode value) throws SQLException {
        Integer propertyDbid = getConceptDbid(conn, propertyId);
        if (propertyDbid == null)
            throw new IllegalArgumentException("\t\t[" + propertyId + "] does not exist!");

        if (value.isValueNode()) {
            insertConceptPropertyData(insData, conceptDbid, 0, propertyDbid, value.asText());
        } else if (value.isObject() && value.has("id")) {
            String valueId = value.get("id").asText();
            Integer valueDbid = getConceptDbid(conn, valueId);
            if (valueDbid == null)
                throw new IllegalArgumentException("\t\t Property [" + propertyId + "] Value [" + valueId + "] does not exist!");

            insertConceptPropertyObject(insObj, conceptDbid, 0, propertyDbid, valueDbid);
        } else if (value.isArray()) {
            ArrayNode arr = (ArrayNode)value;
            for (int i=0; i<arr.size(); i++) {
                JsonNode item = arr.get(i);
                insertConceptProperty(conn, insData, insObj, conceptDbid, propertyId, item);
            }
        } else if (value.isObject()) {
            System.out.println("\t\t" + " = (Anon)" + value.toString());
        } else
            throw new IllegalArgumentException("\t\t[" + propertyId + "] is of an invalid type - [" + value.toString() +"]");
    }
    private void insertConceptPropertyData(PreparedStatement stmt, int dbid, int group, int property, String value) throws SQLException {
        stmt.setInt(1, dbid);
        stmt.setInt(2, group);
        stmt.setInt(3, property);
        stmt.setString(4, value);
        stmt.execute();
    }
    private void insertConceptPropertyObject(PreparedStatement stmt, int dbid, int group, int property, int value) throws SQLException {
        stmt.setInt(1, dbid);
        stmt.setInt(2, group);
        stmt.setInt(3, property);
        stmt.setInt(4, value);
        stmt.execute();
    }

    public String getDocumentDrafts(String documentPath) throws SQLException, JsonProcessingException {
        Connection conn = ConnectionPool.getInstance().pop();

        try {
            Integer dbid = getDocumentDbid(conn, documentPath);

            if (dbid == null)
                throw new IllegalArgumentException("Document [" + documentPath + "] not known");

            ObjectMapper om = new ObjectMapper();
            ObjectNode root = om.createObjectNode();
            root.put("Document", documentPath);


            if (dbid == 0) {
                addTermMaps(conn, root);
            } else {
                addDraftConcepts(conn, dbid, root);
            }

            return om.writeValueAsString(root);
        } finally {
            ConnectionPool.getInstance().push(conn);
        }

    }
    private Integer getDocumentDbid(Connection conn, String documentPath) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement("SELECT dbid FROM document WHERE path = ?")) {
            stmt.setString(1, documentPath);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getInt("dbid");
                else
                    return null;
            }
        }
    }
    private void addTermMaps(Connection conn, ObjectNode root) throws SQLException {
        ArrayNode terms = root.putArray("TermMaps");
        String sql = "SELECT m.term, typ.id as type, tgt.id as target\n" +
            "FROM concept_term_map m\n" +
            "JOIN concept typ ON typ.dbid = m.type\n" +
            "JOIN concept tgt ON tgt.dbid = m.target\n" +
            "WHERE m.draft = TRUE";

        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                ObjectNode term = terms.addObject();
                term.put("term", rs.getString("term"));
                term.put("type", rs.getString("type"));
                term.put("target", rs.getString("target"));
            }
        }
    }
    private void addDraftConcepts(Connection conn, Integer dbid, ObjectNode root) throws SQLException {
        ArrayNode concepts = root.putArray("Concepts");
/*
        String sql = "SELECT c.id, n.value as name, cd.value as code, sid.id as code_scheme, d.value as description\n" +
            "FROM concept c\n" +
            "LEFT JOIN concept_property_data n ON n.dbid = c.dbid AND n.property = get_dbid('name')\n" +
            "LEFT JOIN concept_property_data cd ON cd.dbid = c.dbid AND cd.property = get_dbid('code')\n" +
            "LEFT JOIN concept_property_object s ON s.dbid = c.dbid AND s.property = get_dbid('code_scheme')\n" +
            "LEFT JOIN concept sid ON sid.dbid = s.value\n" +
            "LEFT JOIN concept_property_data d ON d.dbid = c.dbid AND d.property = get_dbid('description')\n" +
            "WHERE c.draft = TRUE\n" +
            "AND c.document = ?";
*/

        String sql = "SELECT c.id, c.name, c.description, c.code, s.id as code_scheme\n" +
            "FROM concept c\n" +
            "LEFT JOIN concept s ON s.dbid = c.scheme\n" +
            "WHERE c.draft = TRUE\n" +
            "AND c.document = ?\n";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, dbid);
            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    ObjectNode concept = concepts.addObject();
                    concept.put("id", rs.getString("id"));
                    if (rs.getString("name") != null) concept.put("name", rs.getString("name"));
                    if (rs.getString("description") != null) concept.put("description", rs.getString("description"));
                    if (rs.getString("code") != null) concept.put("code", rs.getString("code"));
                    if (rs.getString("code_scheme") != null) {
                        ObjectNode scheme = concept.putObject("code_scheme");
                        scheme.put("id", rs.getString("code_scheme"));
                    }
                }
            }
        }
    }

    private String getJsonAsText(JsonNode node, String fieldName) {
        JsonNode field = node.get(fieldName);
        return (field == null) ? null : field.asText();
    }

    // ********** TO DO - REMOVE **********
    private Integer getConceptDbid(Connection conn, String id) throws SQLException {
        Integer conceptDbid = idMap.get(id);

        if (conceptDbid != null)
            return conceptDbid;

        try (PreparedStatement statement = conn.prepareStatement("SELECT dbid FROM concept WHERE id = ?")) {
            statement.setString(1, id);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    conceptDbid = rs.getInt("dbid");
                    idMap.put(id, conceptDbid);
                    return conceptDbid;
                } else {
                    return null;
                }
            }
        }

    }
}
