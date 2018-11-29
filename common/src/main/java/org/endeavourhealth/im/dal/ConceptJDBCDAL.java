package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import static java.sql.Types.*;
import static org.endeavourhealth.im.dal.DALHelper.*;

public class ConceptJDBCDAL implements ConceptDAL {
    private static final Logger LOG = LoggerFactory.getLogger(ConceptJDBCDAL.class);
    private static final Integer PAGE_SIZE = 15;

    @Override
    public Concept get(Long id) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        String sql = "SELECT c.*, s.full_name as superclass_name " +
            "FROM concept c " +
            "JOIN concept s ON s.id = c.superclass " +
            "WHERE c.id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return getConceptFromStatement(stmt);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public Concept getConceptByContext(String context) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();

        String sql = "SELECT c.*, s.full_name as superclass_name " +
            "FROM concept c " +
            "JOIN concept s ON s.id = c.superclass " +
            "WHERE c.context = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, context);
            return getConceptFromStatement(stmt);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public SearchResult getMRU(Boolean includeDeprecated) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();

        SearchResult result = new SearchResult().setPage(1);

        String sql = "SELECT c.id, c.context, c.full_name, c.status, c.version, false as synonym " +
            "FROM concept c ";

        if (includeDeprecated == null || !includeDeprecated)
            sql += "WHERE c.status <> 2 ";

        sql += "ORDER BY last_update DESC " +
            "LIMIT ? ";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, PAGE_SIZE);
            result.setResults(getConceptSummaryListFromStatement(stmt));
            result.setCount(result.getResults().size());

            return result;
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public SearchResult search(String term, Integer page, Boolean includeDeprecated, Long relatedConcept, ValueExpression expression) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        if (page == null)
            page = 1;
        SearchResult result = new SearchResult().setPage(page);

        String sql = "SELECT SQL_CALC_FOUND_ROWS * FROM (\n";
        sql += "SELECT c.id, c.full_name, c.context, c.status, c.version, false as synonym\n" ;
        sql += "FROM concept c\n";
        if (expression == ValueExpression.CHILD_OF) sql += "JOIN concept_relationship r ON c.id = r.source AND r.relationship = 100 AND r.target = ?\n";
        sql += "WHERE MATCH (c.full_name,c.context) AGAINST (? IN BOOLEAN MODE)\n";
        if (expression == ValueExpression.OF_TYPE) sql += "AND c.superclass = ?\n";
        if (!includeDeprecated) sql += "AND c.status <> 2\n";

        sql += "UNION DISTINCT\n";

        sql += "SELECT c.id, c.full_name, c.context, s.status, c.version, false as synonym \n";
        sql += "FROM concept_synonym s\n";
        sql += "JOIN concept c on c.id = s.concept\n";
        if (expression == ValueExpression.CHILD_OF) sql += "JOIN concept_relationship r ON c.id = r.source AND r.relationship = 100 AND r.target = ?\n";
        sql += "WHERE MATCH  (s.term) AGAINST (? IN BOOLEAN MODE)\n";
        if (expression == ValueExpression.OF_TYPE) sql += "AND c.superclass = ?\n";
        if (!includeDeprecated) sql += "AND s.status <> 2 ";

        sql += ") x\n" +
            "ORDER BY (x.status=2), LENGTH(full_name), full_name\n" +
            "LIMIT ?,?\n";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            int i = 1;

            if (expression == ValueExpression.CHILD_OF) stmt.setLong(i++, relatedConcept);
            stmt.setString(i++, "+" + term + "*");
            if (expression == ValueExpression.OF_TYPE) stmt.setLong(i++, relatedConcept);

            if (expression == ValueExpression.CHILD_OF) stmt.setLong(i++, relatedConcept);
            stmt.setString(i++, "+" + term + "*");
            if (expression == ValueExpression.OF_TYPE) stmt.setLong(i++, relatedConcept);

            stmt.setInt(i++, (page-1) * PAGE_SIZE);
            stmt.setInt(i++, PAGE_SIZE);

            result.setResults(getConceptSummaryListFromStatement(stmt));
            result.setCount(getFoundRows(conn));

            return result;
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    private Integer getFoundRows(Connection conn) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement("SELECT FOUND_ROWS()")) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next())
                return rs.getInt(1);
            else
                return 0;
        }
    }

    @Override
    public List<Attribute> getAttributes(Long id, Boolean includeDeprecated) throws Exception {
        Connection conn = ConnectionPool.InformationModel.pop();

/*        String sql = "SELECT ca.*, " +
            "c.full_name as concept_name, " +
            "a.full_name as attribute_name, " +
            "vc.full_name as value_type_name, " +
            "fc.full_name as fixed_value_name " +
            "FROM concept_attribute ca " +
            "JOIN concept c ON c.id = ca.concept " +
            "JOIN concept a ON a.id = ca.attribute " +
            "LEFT OUTER JOIN concept vc ON vc.id = ca.value_concept " +
            "LEFT OUTER JOIN concept fc ON fc.id = ca.fixed_concept " +
            "WHERE ca.concept = ? ";

        if (!includeDeprecated)
            sql += "AND ca.status <> 2 " +
                "AND a.status <> 2 ";

        sql += "ORDER BY ca.`order` ";*/

        String sql = "(select ca.*, -1 as level,\n" +
            "            c.full_name as concept_name,\n" +
            "            a.full_name as attribute_name,\n" +
            "            vc.full_name as value_type_name,\n" +
            "            fc.full_name as fixed_value_name\n" +
            "from concept_attribute ca\n" +
            "            JOIN concept c ON c.id = ca.concept\n" +
            "            JOIN concept a ON a.id = ca.attribute\n" +
            "            LEFT OUTER JOIN concept vc ON vc.id = ca.value_concept\n" +
            "            LEFT OUTER JOIN concept fc ON fc.id = ca.fixed_concept \n" +
            "\n" +
            "where ca.concept = ?)\n" +
            "union\n" +
            "(\n" +
            "select ca.*, level,\n" +
            "            c.full_name as concept_name,\n" +
            "            a.full_name as attribute_name,\n" +
            "            vc.full_name as value_type_name,\n" +
            "            fc.full_name as fixed_value_name\n" +
            "\n" +
            "from concept_tct t\n" +
            "join concept_attribute ca on ca.concept = t.ancestor\n" +
            "            JOIN concept c ON c.id = ca.concept\n" +
            "            JOIN concept a ON a.id = ca.attribute\n" +
            "            LEFT OUTER JOIN concept vc ON vc.id = ca.value_concept\n" +
            "            LEFT OUTER JOIN concept fc ON fc.id = ca.fixed_concept \n" +
            "where t.concept = ?)\n" +
            "order by level;\n";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.setLong(2, id);
            return getAttributeListFromStatement(stmt);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public List<Synonym> getSynonyms(Long id) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        List<Synonym> result = new ArrayList<>();

        String sql = "SELECT * FROM concept_synonym WHERE concept = ? ORDER BY ABS(status - 1), term ";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                result.add(new Synonym()
                    .setId(rs.getLong("id"))
                    .setConcept(rs.getLong("concept"))
                    .setTerm(rs.getString("term"))
                    // .setPreferred(rs.getBoolean("preferred"))
                    .setStatus(ConceptStatus.byValue(rs.getByte("status")))
                );
            }

        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
        return result;
    }

    @Override
    public void saveAttribute(Long conceptId, Attribute attribute) throws SQLException {
        String sql = attribute.getId() == null
            ? "INSERT INTO concept_attribute " +
            "(concept, attribute, `order`, mandatory, `limit`, inheritance, value_concept, value_expression, fixed_concept, fixed_value, status) " +
            "VALUES (?, ?, ? ,?, ?, ? ,? ,? ,? ,? , ?)"
            : "UPDATE concept_attribute SET " +
            "concept = ?, attribute = ?, `order` = ?, mandatory = ?, `limit` = ?, inheritance = ?, value_concept = ?, value_expression = ?, fixed_concept = ?, fixed_value = ?, status = ? " +
            "WHERE id = ?";

        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            int i = 1;
            setLong(stmt, i++, conceptId);
            setLong(stmt, i++, attribute.getAttribute().getId());
            setInt(stmt, i++, attribute.getOrder() == null ? 0 : attribute.getOrder());
            setBool(stmt, i++, attribute.getMandatory() == null ? false : attribute.getMandatory());
            setInt(stmt, i++, attribute.getLimit() == null ? 1 : attribute.getLimit());
            setByte(stmt, i++, attribute.getInheritance() == null ? 1 : attribute.getInheritance());
            setLong(stmt, i++, attribute.getValueConcept().getId());
            setByte(stmt, i++, attribute.getValueExpression().getValue());
            setLong(stmt, i++, (attribute.getFixedConcept() == null) ? null : attribute.getFixedConcept().getId());
            setString(stmt, i++, attribute.getFixedValue());
            setByte(stmt, i++, attribute.getStatus() == null ? 0 : attribute.getStatus().getValue());
            if (attribute.getId() != null)
                setLong(stmt, i++, attribute.getId());

            stmt.executeUpdate();
            if (attribute.getId() == null)
                attribute.setId(getGeneratedKey(stmt));
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public void deleteAttribute(Long id) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM concept_attribute WHERE id = ?")) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public void deleteConcept(Long id) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        conn.setAutoCommit(false);
        try {
            try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM concept_tct WHERE concept = ?")) {
                stmt.setLong(1, id);
                stmt.executeUpdate();
            }
            try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM concept_attribute WHERE concept = ?")) {
                stmt.setLong(1, id);
                stmt.executeUpdate();
            }
            try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM concept WHERE id = ?")) {
                stmt.setLong(1, id);
                stmt.executeUpdate();
            }
            conn.commit();
        }finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public void populateTct(Long id, Long superclass) throws Exception {
        Connection conn = ConnectionPool.InformationModel.pop();
        conn.setAutoCommit(false);
        try {
            try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept_tct (concept, ancestor, level) SELECT ?, ancestor, level+1 FROM concept_tct WHERE concept = ?")) {
                stmt.setLong(1, id);
                stmt.setLong(2, superclass);
                stmt.executeUpdate();
            }
            try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept_tct (concept, ancestor, level) VALUES (?, ?, 0)")) {
                stmt.setLong(1, id);
                stmt.setLong(2, superclass);
                stmt.executeUpdate();
            }
            conn.commit();
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public Long saveConcept(Concept concept) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        try {
            String sql;
            Long id = concept.getId();
            if (id == null) {
                id = TableIdHelper.getNextId("Concept");
                sql = "INSERT INTO concept (superclass, url, full_name, short_name, context, status, version, description, use_count, last_update, id) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            } else {
                sql = "UPDATE concept SET superclass = ?, url = ?, full_name = ?, short_name = ?, context = ?, status = ?, version = ?, " +
                    "description = ?, use_count = ?, last_update = ? WHERE id = ?";
            }
            concept.setLastUpdate(new java.util.Date());


            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                int i = 1;
                stmt.setLong(i++, concept.getSuperclass().getId());
                if (concept.getUrl() == null) stmt.setNull(i++, VARCHAR); else stmt.setString(i++, concept.getUrl());
                if (concept.getFullName() == null) stmt.setNull(i++, VARCHAR); else stmt.setString(i++, concept.getFullName());
                if (concept.getShortName() == null) stmt.setNull(i++, VARCHAR); else stmt.setString(i++, concept.getShortName());
                if (concept.getContext() == null) stmt.setNull(i++, VARCHAR); else stmt.setString(i++, concept.getContext());
                if (concept.getStatus() == null) stmt.setNull(i++, TINYINT); else stmt.setByte(i++, concept.getStatus().getValue());
                if (concept.getVersion() == null) stmt.setNull(i++, FLOAT); else stmt.setFloat(i++, concept.getVersion());
                if (concept.getDescription() == null) stmt.setNull(i++, VARCHAR); else stmt.setString(i++, concept.getDescription());
                if (concept.getUseCount() == null) stmt.setNull(i++, BIGINT); else stmt.setLong(i++, concept.getUseCount());
                stmt.setTimestamp(i++, new Timestamp(concept.getLastUpdate().getTime()));
                stmt.setLong(i++, id);

                stmt.executeUpdate();

                if (id == null)
                    return getGeneratedKey(stmt);
                else
                    return id;
            }
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }


    private void editAttributes(Connection conn, Long conceptId, List<Attribute> attributes) throws SQLException {
        try (PreparedStatement insert = conn.prepareStatement("INSERT INTO concept_attribute (mandatory, `limit`, concept, attribute) VALUES (?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
             PreparedStatement update = conn.prepareStatement("UPDATE concept_attribute SET mandatory = ?, `limit` = ? WHERE concept = ? AND attribute = ?")) {

            for (Attribute attribute : attributes) {
                if (attribute.getConcept().getId() == null) // Its a new attribute added to this concept
                    attribute.setConcept(new Reference().setId(conceptId));

                PreparedStatement stmt = (attribute.getId() == null) ? insert : update;
                int i = 1;
                stmt.setBoolean(i++, attribute.getMandatory());
                stmt.setInt(i++, attribute.getLimit());
                stmt.setLong(i++, attribute.getConcept().getId());
                stmt.setLong(i++, attribute.getAttribute().getId());

                // TODO: Order, inheritance, status, etc

                stmt.executeUpdate();
                if (stmt == insert)
                    attribute.setId(getGeneratedKey(stmt));

                setFixedAttributeValue(conn, conceptId, attribute);
            }
        }
    }

    private void setFixedAttributeValue(Connection conn, Long conceptId, Attribute attribute) throws SQLException {
//        try (PreparedStatement insert = conn.prepareStatement("INSERT INTO concept_attribute_value (fixed_concept, fixed_value, concept, concept_attribute) VALUES (?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
//             PreparedStatement update = conn.prepareStatement("UPDATE concept_attribute_value SET fixed_concept = ?, fixed_value = ? WHERE concept = ? AND concept_attribute = ?")) {
//
//            PreparedStatement stmt = attribute.getValue().getId() == null ? insert : update;
//
//            int i = 1;
//            if (attribute.getValue().getFixedConcept().getId() == null) stmt.setNull(i++, BIGINT); else stmt.setLong(i++, attribute.getValue().getFixedConcept().getId());
//            if (attribute.getValue().getFixedValue() == null) stmt.setNull(i++, VARCHAR); else stmt.setString(i++, attribute.getValue().getFixedValue());
//            stmt.setLong(i++, conceptId); // Concept the value belongs to (not necessarily the attribute which could be from a parent)
//            stmt.setLong(i++, attribute.getId());
//
//            stmt.executeUpdate();
//            if (stmt == insert)
//                attribute.getValue().setId(getGeneratedKey(stmt));
//        }
    }

    private void deleteAttributes(Connection conn, List<Attribute> attributes) throws SQLException {
        try (PreparedStatement delAtt = conn.prepareStatement("DELETE FROM concept_attribute WHERE id = ?");
             PreparedStatement delVal = conn.prepareStatement("DELETE FROM concept_attribute_value WHERE concept_attribute = ?")) {

            for (Attribute attribute : attributes) {
                delAtt.setLong(1, attribute.getId());
                delAtt.executeUpdate();
                delVal.setLong(1, attribute.getId());
                delVal.executeUpdate();
            }
        }
    }
    private void editRelationships(Connection conn, Long conceptId, List<RelatedConcept> related) throws SQLException {
        try (PreparedStatement insert = conn.prepareStatement("INSERT INTO concept_relationship (source, relationship, target, `order`, mandatory, `limit`) VALUES (?, ?, ?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
             PreparedStatement update = conn.prepareStatement("UPDATE concept_relationship SET source = ?, relationship = ?, target = ?, `order` = ?, mandatory = ?, `limit` = ? WHERE id = ?")) {

            for (RelatedConcept rel : related) {
                if (rel.getSource().getId() == null)
                    rel.setSource(new Reference().setId(conceptId));

                if (rel.getTarget().getId() == null)
                    rel.setTarget(new Reference().setId(conceptId));

                PreparedStatement stmt = (rel.getId() == null) ? insert : update;
                int i = 1;
                stmt.setLong(i++, rel.getSource().getId());
                stmt.setLong(i++, rel.getRelationship().getId());
                stmt.setLong(i++, rel.getTarget().getId());
                stmt.setInt(i++, rel.getOrder());
                stmt.setBoolean(i++, rel.getMandatory());
                stmt.setInt(i++, rel.getLimit());

                if (stmt == update)
                    stmt.setLong(i++, rel.getId());

                stmt.executeUpdate();
                if (stmt == insert)
                    rel.setId(getGeneratedKey(stmt));
            }
        }
    }
    private void deleteRelationships(Connection conn, List<RelatedConcept> related) throws SQLException {
        try (PreparedStatement delRel = conn.prepareStatement("DELETE FROM concept_relationship WHERE id = ?")) {

            for (RelatedConcept rel : related) {
                delRel.setLong(1, rel.getId());
                delRel.executeUpdate();
            }
        }
    }
}
