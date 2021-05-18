package sample;

import java.sql.*;
import java.util.List;
import java.util.Properties;
import java.util.StringJoiner;

public class MapImporter {
    private Connection conn;

    String provider;
    String system;
    String schema;
    String table;
    String column;
    String codeScheme;

    StringJoiner sql = new StringJoiner("\n");


    public void execute(MapData mapData) throws Exception {
        System.out.println("Connecting to DB...");
        connectToDb();

        System.out.println("Loading map...");
        parseContext(mapData);

        Integer providerDbid = getConceptDbidById(provider);
        if (providerDbid == null) throw new IllegalStateException("Missing provider concept [" + provider + "]");

        Integer systemDbid = getConceptDbidById(system);
        if (systemDbid == null) throw new IllegalStateException("Missing system concept [" + system + "]");

        Integer codeSchemeDbid = getConceptDbidById(codeScheme);
        if (codeSchemeDbid == null) throw new IllegalStateException("Missing code scheme concept [" + codeScheme + "]");

        String nodeId;
        if (mapData.targetIsNode()) {
            nodeId = mapData.getTarget();
        } else {
            Integer propertyDbid = getConceptDbidById(mapData.getTarget());
            if (propertyDbid == null) throw new IllegalStateException("Missing property concept [" + mapData.getTarget() + "]");
            nodeId = createNode(propertyDbid);
        }

        Integer nodeDbid = getNodeDbidById(nodeId);
        if (nodeDbid == null) throw new IllegalStateException("Missing mapping node [" + mapData.getTarget() + "]");

        getOrCreateContext(providerDbid, systemDbid, nodeDbid);

        int valueFunctionDbid = getOrCreateValueFunctionDbid(nodeDbid, codeSchemeDbid);
        insertValues(valueFunctionDbid, codeSchemeDbid, mapData.getValues());
        System.out.println(sql.toString());
    }

    private void connectToDb() throws ClassNotFoundException, SQLException {
        String driver = System.getenv("JDBC_DRIVER");
        if (driver != null && !driver.isEmpty())
            Class.forName(driver);

        Properties properties = new Properties();
        properties.setProperty("user", System.getenv("JDBC_USERNAME"));
        properties.setProperty("password", System.getenv("JDBC_PASSWORD"));

        conn = DriverManager.getConnection(System.getenv("JDBC_URL"), properties);
    }

    private void parseContext(MapData mapData) {
        String[] parts = mapData.getContext().split("/");
        if (parts.length < 4 || parts.length > 6)
            throw new IllegalStateException("Context must contain 3-5 parts");

        int i = 1;
        provider = parts[i++];
        system = parts[i++];
        schema = (parts.length > 5) ? parts[i++] : "";
        table = (parts.length > 4) ? parts[i++] : "";
        column = parts[i++];

        codeScheme = mapData.getCodeScheme();

        System.out.println("Context:");
        System.out.println("\tProvider [" + provider + "]");
        System.out.println("\tSystem   [" + system + "]");
        System.out.println("\tSchema   [" + schema + "]");
        System.out.println("\tTable    [" + table + "]");
        System.out.println("\tColumn   [" + column + "]");
        System.out.println("\tScheme   [" + codeScheme + "]");
    }

    private Integer getNodeDbidById(String nodeId) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement("SELECT id FROM map_node WHERE node = ?")) {
            stmt.setString(1, nodeId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getInt("id");
                else
                    return null;
            }
        }
    }

    private String createNode(int propertyDbid) throws SQLException {
        String nodeId = "/" + getShortString(provider);
        nodeId += "/" + getShortString(system);
        if (!schema.isEmpty()) nodeId += "/" + getShortString(schema);
        if (!table.isEmpty()) nodeId += "/" + getShortString(table);
        nodeId += "/" + getShortString(column);

        try (PreparedStatement stmt = conn.prepareStatement("INSERT IGNORE INTO map_node (node, concept, draft) VALUES (?, ?, 0)")) {
            stmt.setString(1, nodeId);
            stmt.setInt(2, propertyDbid);
            stmt.executeUpdate();
        }

        return nodeId;
    }

    private int getOrCreateContext(int providerDbid, int systemDbid, int nodeDbid) throws SQLException {
        Integer contextDbid = getContext(providerDbid, systemDbid, nodeDbid);

        if (contextDbid != null)
            return contextDbid;
        else
            return createContext(providerDbid, systemDbid, nodeDbid);
    }

    private Integer getContext(int providerDbid, int systemDbid, int nodeDbid) throws SQLException {
        StringJoiner sql = new StringJoiner("\n");
        sql.add("SELECT id, node FROM map_context");
        sql.add("WHERE provider = ?");
        sql.add("AND system = ?");
        if (!schema.isEmpty()) sql.add("AND `schema` = ?"); else sql.add("AND `schema` IS NULL");
        if (!table.isEmpty()) sql.add("AND `table` = ?"); else sql.add("AND `table` IS NULL");
        sql.add("AND `column` = ?");
        try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            int i = 1;
            stmt.setInt(i++, providerDbid);
            stmt.setInt(i++, systemDbid);
            if (!schema.isEmpty()) stmt.setString(i++, schema);
            if (!table.isEmpty()) stmt.setString(i++, table);
            stmt.setString(i++, column);
            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next())
                    return null;

                if (rs.getInt("node") != nodeDbid)
                    throw new IllegalStateException("Context exists but with different node!!");

                return rs.getInt("id");
            }
        }
    }

    private int createContext(int providerDbid, int systemDbid, int nodeDbid) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO map_context (provider, system, `schema`, `table`, `column`, node, draft) VALUES (?, ?, ?, ?, ?, ?, 0)", Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, providerDbid);
            stmt.setInt(2, systemDbid);
            stmt.setString(3, schema);
            stmt.setString(4, table);
            stmt.setString(5, column);
            stmt.setInt(6, nodeDbid);
            stmt.executeUpdate();
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    private int getOrCreateValueFunctionDbid(int nodeDbid, int codeSchemeDbid) throws SQLException {
        Integer valFuncDbid = getValueFunctionDbid(nodeDbid, codeSchemeDbid);
        if (valFuncDbid != null)
            return valFuncDbid;
        else
            return createValueFunctionDbid(nodeDbid, codeSchemeDbid);
    }

    private Integer getValueFunctionDbid(int nodeDbid, int codeSchemeDbid) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement("SELECT id FROM map_value_node WHERE node = ? AND code_scheme = ?")) {
            stmt.setInt(1, nodeDbid);
            stmt.setInt(2, codeSchemeDbid);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getInt("id");
                else
                    return null;
            }
        }
    }

    private int createValueFunctionDbid(int nodeDbid, int codeSchemeDbid) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO map_value_node (node, code_scheme, function) VALUES (?, ?, 'Lookup()')", Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, nodeDbid);
            stmt.setInt(2, codeSchemeDbid);
            stmt.executeUpdate();
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    private void insertValues(int valueFunctionDbid, int codeSchemeDbid, List<Value> values) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement("INSERT IGNORE INTO map_value_node_lookup (value_node, value, concept, draft) VALUES (?, ?, ?, 0)")) {
            stmt.setInt(1, valueFunctionDbid);

            for (Value v : values) {
                String conceptId = "LPV_" + valueFunctionDbid + "_" + v.getCode();


                int conceptDbid = getOrCreateConcept(conceptId, v.getTerm(), codeSchemeDbid);

                stmt.setString(2, v.getCode());
                stmt.setInt(3, conceptDbid);
                stmt.executeUpdate();
            }
        }
    }

    private int getOrCreateConcept(String conceptId, String term, int codeSchemeDbid) throws SQLException {
        Integer conceptDbid = getConceptDbidById(conceptId);
        if (conceptDbid != null)
            return conceptDbid;
        else
            return createConcept(conceptId, term, codeSchemeDbid);
    }

    private int createConcept(String conceptId, String term, int codeSchemeDbid) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept (document, id, name, description, scheme, code, draft) VALUES (1, ?, ?, ?, ?, ?, 0)", Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, conceptId);
            stmt.setString(2, term);
            stmt.setString(3, term);
            stmt.setInt(4, codeSchemeDbid);
            stmt.setString(5, conceptId);
            stmt.executeUpdate();
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    public String getShortString(String id) {
        // Handle concepts and standard prefixes
        if (id.startsWith("CM_Sys_")) id = id.substring(7);
        else if (id.startsWith("CM_Org_")) id = id.substring(7);
        else if (id.startsWith("CM_")) id = id.substring(3);

        // Strip vowels and spaces (excluding first), return first 3
        id = (id.substring(0, 1) +
            id.substring(1).replaceAll("[aeiou\\- ]", ""));
        return id.toUpperCase();
    }

    public Integer getConceptDbidById(String id) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement("SELECT dbid FROM concept WHERE id = ?")) {
            stmt.setString(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getInt("dbid");
                else
                    return null;
            }
        }
    }
}
