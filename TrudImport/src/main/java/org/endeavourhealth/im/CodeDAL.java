package org.endeavourhealth.im;

import org.endeavourhealth.im.dal.TableIdHelper;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CodeDAL {
    private static final ConnectionCache connectionCache = new ConnectionCache("database");

    public void importFileDirect(String file, String table) throws IOException, SQLException {
        File f = new File(file);
        System.out.println("Populating table [" + table + "] from file [" + f.getName() + "]");
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String fields = reader.readLine();
            fields = fields.replace("\t", ",");
            String sql = "LOAD DATA INFILE '" + file.replace("\\", "\\\\") +
                "' INTO TABLE " + table +
                " FIELDS TERMINATED BY '\t' " +
                " LINES TERMINATED BY '\n' " +
                " IGNORE 1 LINES " +
                " (" + fields + ")";

            Connection conn = connectionCache.pop();
            try (PreparedStatement stmt = conn.prepareStatement(sql)){
                stmt.execute();
            } finally {
                connectionCache.push(conn);
            }
        }
        System.out.println("Import done.");
    }

    private Long getSnomedCount() throws SQLException {
        Connection conn = connectionCache.pop();
        String sql = "SELECT COUNT(distinct id) AS cnt FROM sct2_concept";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getLong("cnt");
            }
        } finally {
            connectionCache.push(conn);
        }
        return null;
    }

    public void populateMap() throws SQLException {
        Long snomedCount = getSnomedCount();
        Long nextId = TableIdHelper.getNextId("CodeableConcept", snomedCount);
        Connection conn = connectionCache.pop();
        String sql =
            "INSERT INTO code\n" +
                "(system, code_id, status, concept_id)\n" +
                "select 1 as system, code_id, status, @conceptId := @conceptId + 1 as concept_id\n" +
                "from (\n" +
                "select c1.id as code_id, if(c1.active = 1, 1, 2) as status\n" +
                "from sct2_concept c1\n" +
                "left join sct2_concept c2 on (c2.id = c1.id and c1.effectiveTime < c2.effectiveTime)\n" +
                "where c2.id is null) as XX\n" +
                "cross join\n" +
                "(SELECT @conceptId := ?) var";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, nextId - 1);
            stmt.execute();
        } finally {
            connectionCache.push(conn);
        }
    }

    public void populateTerms() throws SQLException {
        executeSQL(
            "insert into code_term\n" +
                "(system, code_id, term, status, preferred)\n" +
                "select 1 as system, d1.conceptId as code_id, d1.term, if (d1.active = 1, 1, 2) as status, if (d1.active = 1 and d1.typeId = 900000000000003001, 1, 0) as preferred\n" +
                "from sct2_description d1\n" +
                "left join sct2_description d2 on (d2.id = d1.id and d1.effectiveTime < d2.effectiveTime)\n" +
                "where d2.id is null\n"
        );
    }


    public void createIMConcepts() throws SQLException {
        executeSQL("INSERT INTO concept \n" +
            "(id, context, status)\n" +
            "SELECT cm.concept_id as id, concat('Snomed.', cm.code_id) as context, cm.status\n" +
            "FROM code cm\n" +
            "WHERE cm.system = 1");
    }

    public void setConceptNames() throws SQLException {
        executeSQL("update concept u\n" +
            "inner join code c on c.concept_id = u.id and c.system = 1\n" +
            "inner join code_term t on t.code_id = c.code_id and t.system = 1 and t.preferred = 1\n" +
            "set u.full_name = t.term");
    }

    public void createIMConceptRelationships() throws SQLException {
        executeSQL("insert into concept_relationship " +
            "(source, relationship, target, status) " +
            "select s.concept_id as source, 100 as relationship, t.concept_id as target, if(r1.active = 1, 1, 2) as status " +
            "from sct2_relationship r1 " +
            "join code s on s.code_id = r1.sourceId and s.system = 1 " +
            "join code t on t.code_id = r1.destinationId and t.system = 1 " +
            "left join sct2_relationship r2 ON (r2.id = r1.id and r2.typeId = r2.typeId and r1.effectiveTime < r2.effectiveTime) " +
            "where r1.typeId = 116680003 " +
            "and r2.effectiveTime is null");
    }

    private void executeSQL(String sql) throws SQLException {
        Connection conn = connectionCache.pop();

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.execute();
        } finally {
            connectionCache.push(conn);
        }
    }
}
