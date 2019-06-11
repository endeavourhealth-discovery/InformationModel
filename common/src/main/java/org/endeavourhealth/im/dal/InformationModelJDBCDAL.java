package org.endeavourhealth.im.dal;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.im.models.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;


public class InformationModelJDBCDAL implements InformationModelDAL {
    private static Logger LOG = LoggerFactory.getLogger(InformationModelJDBCDAL.class);
    private static String status = "Running";
    private HashMap<String, Integer> idMap = new HashMap<>();

    @Override
    public String getStatus() {
        return status;
    }

    @Override
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

            Iterator<JsonNode> iterator = maps.iterator();
            try (PreparedStatement stmt = conn.prepareStatement("REPLACE INTO concept_term_map (term, type, target) VALUES (?, ?, ?)")) {
                int i = 0;
                int s = maps.size();
                while (iterator.hasNext()) {
                    JsonNode map = iterator.next();
                    stmt.setString(1, map.get("term").asText());
                    stmt.setInt(2, getConceptDbid(map.get("type").asText()));
                    stmt.setInt(3, getConceptDbid(map.get("target").asText()));
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
        try (PreparedStatement stmt = conn.prepareStatement("SELECT dbid FROM document WHERE path = ?")) {
            stmt.setString(1, docPath);
            ResultSet rs = stmt.executeQuery();
            if (rs.next())
                return rs.getInt("dbid");
        }

        try (PreparedStatement statement = conn.prepareStatement("INSERT INTO document (path, version) VALUES (?, '0.0.1')", Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, docPath);
            statement.execute();

            return DALHelper.getGeneratedKey(statement);
        }
    }
    private void getOrCreateConceptDbids(Connection conn, int docDbid, ArrayNode concepts) throws SQLException {
        // Prepare statements in advance for performance
        try (PreparedStatement getDbid = conn.prepareStatement("SELECT dbid FROM concept WHERE id = ?");
             PreparedStatement addId = conn.prepareStatement("INSERT INTO concept (document, id) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS)) {
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
                    ResultSet rs = getDbid.executeQuery();
                    if (rs.next()) {
                        idMap.put(conceptId, rs.getInt("dbid"));
                    } else {
                        addId.setInt(1, docDbid);
                        addId.setString(2, conceptId);
                        addId.execute();
                        idMap.put(conceptId, DALHelper.getGeneratedKey(addId));
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
                    if (!"id".equals(propertyId)) {
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

    @Override
    public int insertConcept(int docId, String id) throws SQLException {
        Connection conn = ConnectionPool.getInstance().pop();
        try {
            return insertConcept(conn, docId, id);
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }
    private int insertConcept(Connection conn, int docDbid, String conceptId) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept (document, id) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, docDbid);
            stmt.setString(2, conceptId);
            stmt.execute();

            int dbid = DALHelper.getGeneratedKey(stmt);
            idMap.put(conceptId, dbid);

            return dbid;
        }
    }

    @Override
    public void insertConceptPropertyData(int dbid, int property, String value) throws SQLException {
        insertConceptPropertyData(dbid, 0, property, value);
    }

    @Override
    public void insertConceptPropertyData(int dbid, int group, int property, String value) throws SQLException {
        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept_property_data (dbid, `group`, property, value) VALUES (?, ?, ?, ?)")) {
            insertConceptPropertyData(stmt, dbid, group, property, value);
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }
    private void insertConceptPropertyData(PreparedStatement stmt, int dbid, int group, int property, String value) throws SQLException {
        stmt.setInt(1, dbid);
        stmt.setInt(2, group);
        stmt.setInt(3, property);
        stmt.setString(4, value);
        stmt.execute();
    }

    @Override
    public void insertConceptPropertyValue(int dbid, int property, int value) throws SQLException {
        insertConceptPropertyValue(dbid, 0, property, value);
    }

    @Override
    public void insertConceptPropertyValue(int dbid, int group, int property, int value) throws SQLException {
        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept_property_object (dbid, `group`, property, value) VALUES (?, ?, ?, ?)")) {
            insertConceptPropertyObject(stmt, dbid, group, property, value);
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }
    private void insertConceptPropertyObject(PreparedStatement stmt, int dbid, int group, int property, int value) throws SQLException {
        stmt.setInt(1, dbid);
        stmt.setInt(2, group);
        stmt.setInt(3, property);
        stmt.setInt(4, value);
        stmt.execute();
    }

    @Override
    public void insertConcept(String conceptJson, Status status) throws SQLException, IOException {
        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept (data, status) VALUES (?, ?)")) {
            stmt.setString(1, conceptJson);
            stmt.setByte(2, status.getValue());
            stmt.execute();
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }

    @Override
    public void updateConcept(String id, String conceptJson, Status status) throws SQLException, IOException {
        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement stmt = conn.prepareStatement("UPDATE concept SET data = ?, status = ? WHERE id = ?")) {
            stmt.setString(1, conceptJson);
            stmt.setByte(2, status.getValue());
            stmt.setString(3, id);
            stmt.execute();
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }

    @Override
    public SearchResult mru() throws Exception {
        SearchResult result = new SearchResult();

        String sql = "SELECT c.id, p.id as property, d.value\n" +
            "FROM concept c\n" +
            "JOIN concept_property_data d ON d.dbid = c.dbid\n" +
            "JOIN concept p ON p.dbid = d.property AND p.id IN ('name', 'code')\n" +
            "INNER JOIN (\n" +
            "\tSELECT i.dbid\n" +
            "    FROM concept_property_info i\n" +
            "    JOIN concept updt ON updt.dbid = i.property AND updt.id = 'last_updated'\n" +
            "    ORDER BY i.value DESC\n" +
            "    LIMIT 1000\n" +
            ") t ON c.dbid = t.dbid\n" +
            "UNION\n" +
            "SELECT c.id, p.id, v.id\n" +
            "FROM concept c\n" +
            "JOIN concept_property_object d ON d.dbid = c.dbid\n" +
            "JOIN concept p ON p.dbid = d.property AND p.id = 'code_scheme'\n" +
            "JOIN concept v ON v.dbid = d.value\n" +
            "INNER JOIN (\n" +
            "\tSELECT i.dbid\n" +
            "    FROM concept_property_info i\n" +
            "    JOIN concept updt ON updt.dbid = i.property AND updt.id = 'last_updated'\n" +
            "    ORDER BY i.value DESC\n" +
            "    LIMIT 1000\n" +
            ") t ON c.dbid = t.dbid\n" +
            "UNION\n" +
            "SELECT c.id, p.id, d.value\n" +
            "FROM concept c\n" +
            "JOIN concept_property_info d ON d.dbid = c.dbid\n" +
            "JOIN concept p ON p.dbid = d.property AND p.id IN ('status', 'last_updated')\n" +
            "INNER JOIN (\n" +
            "\tSELECT i.dbid\n" +
            "    FROM concept_property_info i\n" +
            "    JOIN concept updt ON updt.dbid = i.property AND updt.id = 'last_updated'\n" +
            "    ORDER BY i.value DESC\n" +
            "    LIMIT 20\n" +
            ") t ON c.dbid = t.dbid\n" +
            "ORDER BY 1, 2;";

        Connection conn = ConnectionPool.getInstance().pop();
        try {
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                ResultSet rs = statement.executeQuery();

                SimpleDateFormat df = new SimpleDateFormat("dd-MMM-yyyy HH:mm:ss");
                String id = "";
                Concept c = null;
                while(rs.next()) {
                    if (!rs.getString("id").equals(id)) {
                        id = rs.getString("id");
                        c = new Concept().setId(id);
                        result.getResults().add(c);
                    }
                    String v = rs.getString("value");
                    switch(rs.getString("property")) {
                        case "name": c.setName(v); break;
                        case "code": c.setCode(v); break;
                        case "code_scheme": c.setScheme(v); break;
                        case "status": c.setStatus((short)0); break;       // TODO: Correct status flag
                        case "last_update": c.setUpdated(df.parse(v));
                    }
                }
            }
        }finally {
            ConnectionPool.getInstance().push(conn);
        }
        return result;
    }

    @Override
    public SearchResult search(String text, Integer size, Integer page, String relationship, String target) throws Exception {
        page = (page == null) ? 1 : page;       // Default page to 1
        size = (size == null) ? 15 : size;      // Default page size to 15
        int offset = (page - 1) * size;         // Calculate offset from page & size

        SearchResult result = new SearchResult()
            .setPage(page);

        Integer relId = (relationship == null) ? null : getConceptDbid(relationship);
        Integer tgtId = (target == null) ? null : getConceptDbid(target);
        boolean relFilter = (relId != null) && (tgtId != null);

        String sql = "SELECT SQL_CALC_FOUND_ROWS *\n" +
            "FROM (\n" +
            "SELECT c.dbid, c.id, c.name, c.scheme, c.code, c.status, c.updated, LENGTH(c.name) as len\n" +
            "FROM concept c\n" +
            "WHERE MATCH (name) AGAINST (? IN BOOLEAN MODE)\n" +
            "UNION\n" +
            "SELECT c.dbid, c.id, c.name, c.scheme, c.code, c.status, c.updated, LENGTH(c.code) as len\n" +
            "FROM concept c\n" +
            "WHERE code LIKE ?\n" +
            ") AS u\n";

        if (relFilter)
            sql += "JOIN concept_tct t ON t.source = u.dbid\n"
                +"AND t.relationship = ? AND t.target = ?\n";

        sql += "ORDER BY len\n" +
            "LIMIT ?";

        if (page != null)
            sql += ",?";

        Connection conn = ConnectionPool.getInstance().pop();
        try {
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                int i = 1;
                statement.setString(i++, text);
                statement.setString(i++, text + '%');

                if (relFilter) {
                    statement.setInt(i++, relId);
                    statement.setInt(i++, tgtId);
                }

                if (page != null)
                    statement.setInt(i++, offset);

                statement.setInt(i++, size);


                getConceptsFromResultSet(result.getResults(), statement);
            }

            try (PreparedStatement statement = conn.prepareStatement("SELECT FOUND_ROWS();")) {
                ResultSet rs = statement.executeQuery();
                rs.next();
                result.setCount(rs.getInt(1));
            }

        } finally {
            ConnectionPool.getInstance().push(conn);
        }

        return result;
    }

    @Override
    public String getConceptJSON(int dbid) throws SQLException {
        String sql = "SELECT data FROM concept WHERE dbid = ?";

        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, dbid);
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
    public String getConceptJSON(String id) throws SQLException {
        String sql = "SELECT 'document' AS property, 0 AS `group`, d.iri AS value, 1 AS type\n" +
            "FROM concept c\n" +
            "JOIN document d ON d.dbid = c.document\n" +
            "WHERE c.id = ?\n" +
            "UNION\n" +
            "SELECT p.id AS property, d.group, d.value, 1 as type\n" +
            "FROM concept c\n" +
            "JOIN concept_property_data d ON d.dbid = c.dbid\n" +
            "JOIN concept p ON p.dbid = d.property\n" +
            "WHERE c.id = ?\n" +
            "UNION\n" +
            "SELECT p.id AS property, d.group, d.value, 2 as type\n" +
            "FROM concept c\n" +
            "JOIN concept_property_info d ON d.dbid = c.dbid\n" +
            "JOIN concept p ON p.dbid = d.property\n" +
            "WHERE c.id = ?\n" +
            "UNION\n" +
            "SELECT p.id AS property, d.group, v.id as value, 3 as type\n" +
            "FROM concept c\n" +
            "JOIN concept_property_object d ON d.dbid = c.dbid\n" +
            "JOIN concept p ON p.dbid = d.property\n" +
            "JOIN concept v ON v.dbid = d.value\n" +
            "WHERE c.id = ?";

        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, id);
            statement.setString(2, id);
            statement.setString(3, id);
            statement.setString(4, id);
            ResultSet resultSet = statement.executeQuery();

            ObjectNode root = JsonNodeFactory.instance.objectNode();
            ObjectNode meta = JsonNodeFactory.instance.objectNode();
            root.put("id", id);
            // root.set("meta", meta);
            int group = 0;
            while (resultSet.next()) {
                int grp = resultSet.getInt("group");
                int typ = resultSet.getInt("type");

                ObjectNode tgt = (grp == 0) ? root : root;

                switch(typ) {
                    case 1: // Value
                        tgt.put(resultSet.getString("property"), resultSet.getString("value"));
                        break;
                    case 2: // Meta
                        meta.put(resultSet.getString("property"), resultSet.getString("value"));
                        break;
                    case 3: // Object
                        ObjectNode obj = JsonNodeFactory.instance.objectNode();
                        obj.put("id", resultSet.getString("value"));
                        tgt.set(resultSet.getString("property"), obj);
                        break;
                }
            }

            return root.toString();

        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }

    @Override
    public String getConceptName(String id) throws SQLException {
        String sql = "SELECT d.value AS name\n" +
            "FROM concept c\n" +
            "JOIN concept_property_data d ON d.dbid = c.dbid\n" +
            "JOIN concept p ON p.dbid = d.property AND p.id = 'name'\n" +
            "WHERE c.id = ?\n";

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
    public List<Document> getDocuments() throws SQLException {
        List<Document> result = new ArrayList<>();

        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement statement = conn.prepareStatement("SELECT dbid, path, version, draft FROM document")) {
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                result.add(
                    new Document()
                    .setDbid(resultSet.getInt("dbid"))
                    .setPath(resultSet.getString("path"))
                    .setVersion(Version.fromString(resultSet.getString("version")))
                    .setDraft(resultSet.getBoolean("draft"))
                );
            }
        } finally {
            ConnectionPool.getInstance().push(conn);
        }

        return result;
    }

    @Override
    public String validateIds(List<String> ids) throws Exception {
        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement statement = conn.prepareStatement("SELECT 1 FROM concept WHERE id = ?")) {

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

    @Override
    public Integer getConceptDbid(String id) throws SQLException {
        Connection conn = ConnectionPool.getInstance().pop();
        try {
            return getConceptDbid(conn, id);
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }
    private Integer getConceptDbid(Connection conn, String id) throws SQLException {
        Integer conceptDbid = idMap.get(id);

        if (conceptDbid != null)
            return conceptDbid;

        try (PreparedStatement statement = conn.prepareStatement("SELECT dbid FROM concept WHERE id = ?")) {
            statement.setString(1, id);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                conceptDbid = rs.getInt("dbid");
                idMap.put(id, conceptDbid);
                return conceptDbid;
            } else {
                return null;
            }
        }

    }

    @Override
    public Integer getConceptIdForSchemeCode(String scheme, String code, Boolean autoCreate) throws SQLException {
        Integer conceptId = null;
        Connection conn = ConnectionPool.getInstance().pop();

        String sql = "SELECT o.dbid\n" +
            "FROM concept_property_object o\n" +
            "JOIN concept s ON s.dbid = o.property AND s.id = 'code_scheme'\n" +
            "JOIN concept v ON v.dbid = o.value AND v.id = ?\n" +
            "JOIN concept_property_data d ON d.dbid = o.dbid AND d.value = ?\n" +
            "JOIN concept c ON c.dbid = d.property AND c.id = 'code'";

        conn.setAutoCommit(false);
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, scheme);
            statement.setString(2, code);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next())
                conceptId = resultSet.getInt(1);
            else if (autoCreate)
                conceptId = createDraftCodeableConcept(conn, scheme, code);

            conn.commit();
            return conceptId;
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }

    @Override
    public Integer getMappedCoreConceptIdForSchemeCode(String scheme, String code) throws SQLException {
        // SNOMED codes ARE core so dont have/need maps
        if ("SNOMED".equals(scheme))
            return this.getConceptIdForSchemeCode(scheme, code, false);


        String sql =
            "SELECT t.value\n" +
                "FROM concept_property_object o\n" +
                "JOIN concept s ON s.dbid = o.property AND s.id = 'code_scheme'\n" +
                "JOIN concept v ON v.dbid = o.value AND v.id = ?\n" +
                "JOIN concept_property_data d ON d.dbid = o.dbid AND d.value = ?\n" +
                "JOIN concept c ON c.dbid = d.property AND c.id = 'code'\n" +
                "JOIN concept_property_object t ON t.dbid = o.dbid\n" +
                "JOIN concept p ON p.dbid = t.property AND p.id = 'is_equivalent_to'";

        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, scheme);
            statement.setString(2, code);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next())
                return resultSet.getInt(1);
            else
                return null;
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }

    @Override
    public Integer getConceptIdForTypeTerm(String type, String term, Boolean autoCreate) throws SQLException {
        Integer conceptId = null;
        Integer typeId = getConceptDbid(type);
        if (typeId == null)
            return null;

        Connection conn = ConnectionPool.getInstance().pop();
        conn.setAutoCommit(false);
        try (PreparedStatement statement = conn.prepareStatement("SELECT target FROM concept_term_map WHERE type = ? AND term = ?")) {
            statement.setInt(1, typeId);
            statement.setString(2, term);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next())
                conceptId = resultSet.getInt("target");
            else if (autoCreate)
                conceptId = createTypeTermConcept(conn, type, term);

            conn.commit();
            return conceptId;
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }

    @Override
    public Integer getMappedCoreConceptIdForTypeTerm(String type, String term) throws SQLException {
        Integer typeId = getConceptDbid(type);
        if (typeId == null)
            return null;

        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement statement = conn.prepareStatement("SELECT target FROM concept_term_map WHERE type = ? AND term = ?")) {
            statement.setInt(1, typeId);
            statement.setString(2, term);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next())
                return resultSet.getInt("target");
            else
                return null;
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }

    @Override
    public String getCodeForConceptId(Integer dbid) throws SQLException {
        Connection conn = ConnectionPool.getInstance().pop();

        String sql = "SELECT d.value\n" +
            "FROM concept_property_data d\n" +
            "JOIN concept p ON p.dbid = d.property AND p.id = 'code'\n" +
            "WHERE d.dbid = ?";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, dbid);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next())
                return resultSet.getString(1);
            else
                return null;
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }
    private void getConceptsFromResultSet(List<Concept> result, PreparedStatement statement) throws SQLException {
        ResultSet resultSet = statement.executeQuery();

        while (resultSet.next()) {
            result.add(
                new Concept()
                    .setDbid(resultSet.getInt("dbid"))
                    .setId(resultSet.getString("id"))
                    .setName(resultSet.getString("name"))
                    .setScheme(resultSet.getString("scheme"))
                    .setCode(resultSet.getString("code"))
                    .setStatus(resultSet.getShort("status"))
                    .setUpdated(new Date(resultSet.getTimestamp("updated").getTime()))
            );
        }
    }
    private int createDraftCodeableConcept(Connection conn, String scheme, String code) throws SQLException {
        int schemeDbid;
        int docDbid;
        String prefix;
        int conceptId;

        String sql = "SELECT c.dbid, c.document, d.value\n" +
            "FROM concept c\n" +
            "JOIN concept_property_data d ON d.dbid = c.dbid\n" +
            "WHERE c.id = ?\n" +
            "AND d.property = get_dbid('code_prefix')";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, scheme);
            ResultSet rs = stmt.executeQuery();
            if (!rs.next())
                throw new IllegalArgumentException("Unknown code scheme [" + scheme + "]");

            schemeDbid = rs.getInt("dbid");
            docDbid = rs.getInt("document");
            prefix = rs.getString("value");
        }

        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept (document, id, draft) VALUES (?, ?, TRUE)", Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, docDbid);
            stmt.setString(2, prefix + code);
            stmt.execute();
            conceptId = DALHelper.getGeneratedKey(stmt);
        }

        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept_property_object (dbid, property, value) VALUES (?, get_dbid('code_scheme'), ?)")) {
            stmt.setInt(1, conceptId);
            stmt.setInt(2, schemeDbid);
            stmt.execute();
        }

        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept_property_data (dbid, property, value) VALUES (?, get_dbid('code'), ?)")) {
            stmt.setInt(1, conceptId);
            stmt.setString(2, code);
            stmt.execute();
        }

        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept_property_data (dbid, property, value) VALUES (?, get_dbid('name'), ?)")) {
            stmt.setInt(1, conceptId);
            stmt.setString(2, "Draft/Unknown code [" + scheme + "]/[" + code + "]");
            stmt.execute();
        }

        try (PreparedStatement stmt = conn.prepareStatement("UPDATE document SET draft = TRUE WHERE dbid = ?")) {
            stmt.setInt(1, docDbid);
            stmt.execute();
        }
        return conceptId;
    }
    private int createTypeTermConcept(Connection conn, String type, String term) throws SQLException {
        int typDbid;
        int docDbid;
        int mapDbid;

        // Get term type ids
        try (PreparedStatement stmt = conn.prepareStatement("SELECT dbid, document FROM concept WHERE id = ?")) {
            stmt.setString(1, type);
            ResultSet rs = stmt.executeQuery();
            if (!rs.next())
                throw new IllegalArgumentException("Unknown term type [" + type + "]");
            typDbid = rs.getInt("dbid");
            docDbid = rs.getInt("document");
        }

        // Create the draft concept
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept (document, id, draft) SELECT ?, CONCAT(?, '_', MAX(dbid) + 1), TRUE FROM concept", Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, docDbid);
            stmt.setString(2, type);
            stmt.execute();
            mapDbid = DALHelper.getGeneratedKey(stmt);
        }

        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept_term_map (term, type, target, draft) VALUES (?, ?, ?, TRUE)")) {
            stmt.setString(1, term);
            stmt.setInt(2, typDbid);
            stmt.setInt(3, mapDbid);
            stmt.execute();
        }

        return mapDbid;
    }
}
