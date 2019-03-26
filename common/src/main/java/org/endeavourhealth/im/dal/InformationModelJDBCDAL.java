package org.endeavourhealth.im.dal;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import gnu.trove.map.hash.TObjectIntHashMap;
import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.im.models.Concept;
import org.endeavourhealth.im.models.Status;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import java.util.concurrent.ThreadLocalRandom;
import java.util.zip.DataFormatException;
import java.util.zip.Deflater;
import java.util.zip.Inflater;

public class InformationModelJDBCDAL implements InformationModelDAL {
    private static TObjectIntHashMap<String> idMap;
    private static byte[][] concepts;

    @Override
    public int insertDocument(String documentJson) throws SQLException, IOException {
        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO document (data) VALUES (?)", Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, documentJson);
            stmt.execute();
            return DALHelper.getGeneratedKey(stmt);
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }

    @Override
    public void updateDocument(int dbid, String documentJson) throws SQLException, IOException {
        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement stmt = conn.prepareStatement("UPDATE document SET data = ? WHERE dbid = ?")) {
            stmt.setString(1, documentJson);
            stmt.setInt(2, dbid);
            stmt.execute();
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
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
    public List<Concept> mru() throws Exception {
        List<Concept> result = new ArrayList<>();

        String sql = "SELECT dbid, id, name, scheme, code, status, updated " +
            "FROM concept " +
            "ORDER BY updated DESC " +
            "LIMIT 20";

        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            getConceptsFromResultSet(result, statement);
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
        return result;
    }

    @Override
    public List<Concept> search(String text, String relationship, String target) throws Exception {
        List<Concept> result = new ArrayList<>();

        Integer relId = (relationship == null) ? null : getConceptDbid(relationship);
        Integer tgtId = (target == null) ? null : getConceptDbid(target);
        boolean relFilter = (relId != null) && (tgtId != null);


        String sql = "SELECT c.dbid, c.id, c.name, c.scheme, c.code, c.status, c.updated " +
            "FROM concept c\n";

        if (relFilter)
            sql += "JOIN concept_tct t ON t.source = c.dbid\n";

        sql += "WHERE MATCH (id, name) AGAINST (? IN NATURAL LANGUAGE MODE)\n";

        if (relFilter)
            sql += "AND t.relationship = ? AND t.target = ?\n";

        sql += "ORDER BY LENGTH(name)\n" +
            "LIMIT 20";

        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, text);

            if (relFilter) {
                statement.setInt(2, relId);
                statement.setInt(3, tgtId);
            }

            getConceptsFromResultSet(result, statement);
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
        return result;
    }

    @Override
    public String getConceptJSON(String id) throws SQLException {
        String sql = "SELECT data FROM concept WHERE id = ?";

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
    public String getConceptName(String id) throws SQLException {
        String sql = "SELECT name FROM concept WHERE id = ?\n";

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
    public Integer getConceptDbid(String id) throws Exception {
        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement statement = conn.prepareStatement("SELECT dbid FROM concept WHERE id = ?")) {
            statement.setString(1, id);
            ResultSet rs = statement.executeQuery();
            if (rs.next())
                return rs.getInt("dbid");
            else
                return null;

        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }

    @Override
    public boolean generateRuntimeFiles() throws Exception {
        Date start = new Date();
        List<String> ids = new ArrayList<>(); // Arrays.asList("null"));
        int conceptCount = 0;

        Connection conn = ConnectionPool.getInstance().pop();
        try {
            // Get concept count
            try (PreparedStatement statement = conn.prepareStatement("SELECT MAX(dbid) FROM concept")) {
                ResultSet rs = statement.executeQuery();
                if (rs.next())
                    conceptCount = rs.getInt(1);
                System.out.println("Exporting " + conceptCount + " concepts");
            }

            System.out.println("Generating file");
            try (PreparedStatement statement = conn.prepareStatement("SELECT dbid, id, data FROM concept ORDER BY dbid")) {
                try (DataOutputStream w = new DataOutputStream(new FileOutputStream("c:\\temp\\IM-dat.bin"))) {

                    w.writeInt(conceptCount);

                    ResultSet rs = statement.executeQuery();
                    int i = 1;
                    while (rs.next()) {
                        String data = rs.getString("data");
                        byte[] output = compactData(data);

                        int size = output.length;
                        int dbid = rs.getInt("dbid");
                        if (dbid != i)
                            throw new IndexOutOfBoundsException("Gap in dbids! [" + i + "-" + (dbid -1) + "]");
                        else
                            i++;

                        if(dbid % 100 == 0) {
                            System.out.print("\rExported " + dbid + "/" + conceptCount + " - " + data.length() + "->" + size);
                        }

                        ids.add(rs.getString("id"));
                        w.writeInt(size);
                        w.write(output, 0, size);
                    }
                    w.flush();
                }
            }
        } finally {
            ConnectionPool.getInstance().push(conn);
        }

        Date mid = new Date();

        System.out.println("Time " + (mid.getTime() - start.getTime())/1000 + "s");

        try (FileWriter writer = new FileWriter("c:\\temp\\IM-ids.bin")) {
            for (String str : ids) {
                writer.write(str);
                writer.write('\n');
            }
            writer.flush();
        }

        Date end = new Date();

        System.out.println("Time " + (end.getTime() - start.getTime())/1000 + "s");

        return true;
    }

    @Override
    public void loadRuntimeFiles() throws Exception {
        Runtime runtime=Runtime.getRuntime();

        System.out.println("Loading ids...");
        System.out.println("Memory use: " + (runtime.totalMemory() - runtime.freeMemory())/(1024*1024));

        // Load id => dbid map
        idMap = new TObjectIntHashMap<>();
        try (BufferedReader reader = new BufferedReader(new FileReader("c:\\temp\\IM-ids.bin"))) {
            int i = 0;
            String id;
            while((id = reader.readLine()) != null) {
                if (idMap.containsKey(id))
                    System.err.println("Id clash!!");
                else
                    idMap.put(id, i++);
            }
        }

        System.out.println("Memory use: " + (runtime.totalMemory() - runtime.freeMemory())/(1024*1024));
        System.out.println("Loading concepts...");

        try (DataInputStream in = new DataInputStream(new FileInputStream("c:\\temp\\IM-dat.bin"))) {
            int count = in.readInt();
            concepts = new byte[count][];
            concepts[0] = null;
            int i = 0;
            while (i < count) {
                int size = in.readInt();
                concepts[i] = new byte[size];
                in.read(concepts[i], 0, size);

                if(i % 100 == 0) {
                    System.out.print("\rLoaded " + i + " of " + count + " - Mem:" + (runtime.totalMemory() - runtime.freeMemory())/(1024*1024));
                }
                i++;
            }
        }
        System.out.println();
        System.out.println("Memory use: " + (runtime.totalMemory() - runtime.freeMemory())/(1024*1024));
        System.out.println("Done...");

        System.out.println("Verifying data...");
        int i = ThreadLocalRandom.current().nextInt(0, concepts.length);
        System.out.println("DBID: " + (i+1));
        byte[] conceptData = concepts[i];

        conceptData = decompress(conceptData);
        System.out.println(new String(conceptData));
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

    private byte[] compactData(String data) throws IOException {
        JsonNode root = ObjectMapperPool.getInstance().readTree(data);
        ((ObjectNode)root).remove("id");
        ((ObjectNode)root).remove("description");

        data = root.toString();

        return compress(data.getBytes());
    }
    public static byte[] compress(byte[] data) throws IOException {
        Deflater deflater = new Deflater(Deflater.BEST_COMPRESSION);
        deflater.setInput(data);
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream(data.length);
        deflater.finish();
        byte[] buffer = new byte[1024];
        while (!deflater.finished()) {
            int count = deflater.deflate(buffer); // returns the generated code... index
            outputStream.write(buffer, 0, count);
        }
        outputStream.close();
        byte[] output = outputStream.toByteArray();
        return output;
    }
    public static byte[] decompress(byte[] data) throws IOException, DataFormatException {
        Inflater inflater = new Inflater();
        inflater.setInput(data);
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream(data.length);
        byte[] buffer = new byte[1024];
        while (!inflater.finished()) {
            int count = inflater.inflate(buffer);
            outputStream.write(buffer, 0, count);
        }
        outputStream.close();
        byte[] output = outputStream.toByteArray();
        return output;
    }
}
