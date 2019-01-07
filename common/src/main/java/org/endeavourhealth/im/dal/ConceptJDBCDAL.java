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
    public Concept get(Long id) throws DALException {
        Connection conn = ConnectionPool.InformationModel.pop();
        String sql = "SELECT c.*, s.full_name as superclass_name, cs.full_name as code_scheme_name " +
            "FROM concept c " +
            "JOIN concept s ON s.id = c.superclass " +
            "LEFT JOIN concept cs ON cs.id = c.code_scheme " +
            "WHERE c.id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return getConceptFromStatement(stmt);
        } catch (SQLException e) {
            throw new DALException("Error fetching concept", e);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public Concept getConceptByContext(String context) throws DALException {
        Connection conn = ConnectionPool.InformationModel.pop();

        String sql = "SELECT c.*, s.full_name as superclass_name, cs.full_name as code_scheme_name " +
            "FROM concept c " +
            "JOIN concept s ON s.id = c.superclass " +
            "LEFT JOIN concept cs ON cs.id = c.code_scheme " +
            "WHERE c.context = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, context);
            return getConceptFromStatement(stmt);
        } catch (SQLException e) {
            throw new DALException("Error fetching concept by context", e);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public SearchResult getMRU(Boolean includeDeprecated) throws DALException {
        Connection conn = ConnectionPool.InformationModel.pop();

        SearchResult result = new SearchResult().setPage(1);

        String sql = "SELECT c.id, c.context, c.full_name, c.status, c.version, false as synonym, c.code_scheme, s.full_name AS code_scheme_name " +
            "FROM concept c " +
            "LEFT JOIN concept s ON s.id = c.code_scheme ";

        if (includeDeprecated == null || !includeDeprecated)
            sql += "WHERE c.status <> 2 ";

        sql += "ORDER BY c.last_update DESC " +
            "LIMIT ? ";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, PAGE_SIZE);
            result.setResults(getConceptSummaryListFromStatement(stmt));
            result.setCount(result.getResults().size());

            return result;
        } catch (SQLException e) {
            throw new DALException("Error fetching MRU", e);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public SearchResult search(String term, Integer page, Boolean includeDeprecated, List<Long> schemes, Long relatedConcept, ValueExpression expression) throws DALException {
        Connection conn = ConnectionPool.InformationModel.pop();
        if (page == null)
            page = 1;
        SearchResult result = new SearchResult().setPage(page);

        String sql = "SELECT SQL_CALC_FOUND_ROWS * FROM (\n";
        sql += "SELECT c.id, c.full_name, c.context, c.status, c.version, false as synonym, c.code_scheme, cs.full_name as code_scheme_name\n" ;
        sql += "FROM concept c\n";
        sql += "LEFT JOIN concept cs ON cs.id = c.code_scheme\n";
        if (expression == ValueExpression.CHILD_OF) sql += "JOIN concept_relationship r ON c.id = r.source AND r.relationship = 100 AND r.target = ?\n";
        sql += "WHERE MATCH (c.full_name,c.context) AGAINST (? IN BOOLEAN MODE)\n";
        if (expression == ValueExpression.OF_TYPE) sql += "AND c.superclass = ?\n";
        if (!includeDeprecated) sql += "AND c.status <> 2\n";
        if (schemes != null && schemes.size() > 0) sql += "AND c.code_scheme IN (" + inListParams(schemes.size()) + ")\n";

        sql += "UNION DISTINCT\n";

        sql += "SELECT c.id, c.full_name, c.context, s.status, c.version, false as synonym, c.code_scheme, cs.full_name as code_scheme_name \n";
        sql += "FROM concept_synonym s\n";
        sql += "JOIN concept c on c.id = s.concept\n";
        sql += "LEFT JOIN concept cs ON cs.id = c.code_scheme\n";
        if (expression == ValueExpression.CHILD_OF) sql += "JOIN concept_relationship r ON c.id = r.source AND r.relationship = 100 AND r.target = ?\n";
        sql += "WHERE MATCH  (s.term) AGAINST (? IN BOOLEAN MODE)\n";
        if (expression == ValueExpression.OF_TYPE) sql += "AND c.superclass = ?\n";
        if (!includeDeprecated) sql += "AND s.status <> 2 ";
        if (schemes != null && schemes.size() > 0) sql += "AND c.code_scheme IN (" + inListParams(schemes.size()) + ")\n";

        sql += ") x\n" +
            "ORDER BY (x.status=2), LENGTH(full_name), full_name\n" +
            "LIMIT ?,?\n";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            int i = 1;

            if (expression == ValueExpression.CHILD_OF) stmt.setLong(i++, relatedConcept);
            stmt.setString(i++, "+" + term + "*");
            if (expression == ValueExpression.OF_TYPE) stmt.setLong(i++, relatedConcept);
            if (schemes != null && schemes.size() > 0)
                i = setLongArray(stmt, i, schemes);

            if (expression == ValueExpression.CHILD_OF) stmt.setLong(i++, relatedConcept);
            stmt.setString(i++, "+" + term + "*");
            if (expression == ValueExpression.OF_TYPE) stmt.setLong(i++, relatedConcept);
            if (schemes != null && schemes.size() > 0)
                i = setLongArray(stmt, i, schemes);

            stmt.setInt(i++, (page-1) * PAGE_SIZE);
            stmt.setInt(i++, PAGE_SIZE);

            result.setResults(getConceptSummaryListFromStatement(stmt));
            result.setCount(getFoundRows(conn));

            return result;
        } catch (SQLException e) {
            throw new DALException("Error performing search", e);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    private Integer getFoundRows(Connection conn) throws DALException {
        try (PreparedStatement stmt = conn.prepareStatement("SELECT FOUND_ROWS()")) {
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
                else
                    return 0;
            }
        } catch (SQLException e) {
            throw new DALException("Error fetching found rows", e);
        }
    }

    @Override
    public List<Attribute> getAttributes(Long id, Boolean includeDeprecated) throws DALException {
        Connection conn = ConnectionPool.InformationModel.pop();

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
        } catch (SQLException e) {
            throw new DALException("Error fetching attributes", e);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public List<Synonym> getSynonyms(Long id) throws DALException {
        Connection conn = ConnectionPool.InformationModel.pop();
        List<Synonym> result = new ArrayList<>();

        String sql = "SELECT * FROM concept_synonym WHERE concept = ? ORDER BY ABS(status - 1), term ";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    result.add(new Synonym()
                        .setId(rs.getLong("id"))
                        .setConcept(rs.getLong("concept"))
                        .setTerm(rs.getString("term"))
                        // .setPreferred(rs.getBoolean("preferred"))
                        .setStatus(ConceptStatus.byValue(rs.getByte("status")))
                    );
                }
            }
        } catch (SQLException e) {
            throw new DALException("Error fetching synonyms", e);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
        return result;
    }

    @Override
    public void saveAttribute(Long conceptId, Attribute attribute) throws DALException {
        String sql;

        Connection conn = ConnectionPool.InformationModel.pop();
        try {
            conn.setAutoCommit(false);

            if (attribute.getId() == null) {
                sql = "INSERT INTO concept_attribute " +
                    "(concept, version, attribute, `order`, mandatory, `limit`, inheritance, value_concept, value_expression, fixed_concept, fixed_value, status) " +
                    "VALUES (?, ?, ?, ? ,?, ?, ? ,? ,? ,? ,? , ?)";
            } else {
                archiveAttribute(conn, attribute.getId());
                attribute.incVersion();
                sql = "UPDATE concept_attribute SET " +
                    "concept = ?, version = ?, attribute = ?, `order` = ?, mandatory = ?, `limit` = ?, inheritance = ?, value_concept = ?, value_expression = ?, fixed_concept = ?, fixed_value = ?, status = ? " +
                    "WHERE id = ?";
            }

            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                int i = 1;

                setLong(stmt, i++, conceptId);
                setFloat(stmt, i++, attribute.getVersion());
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

                conn.commit();
            }
        } catch (SQLException e) {
            throw new DALException("Error saving attribute", e);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    private void archiveAttribute(Connection conn, Long attributeId) throws DALException {
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept_attribute_archive SELECT * FROM concept_attribute WHERE id = ?")) {
            stmt.setLong(1, attributeId);
            stmt.execute();
        } catch (SQLException e) {
            throw new DALException("Error archiving attribute", e);
        }
    }

    @Override
    public void deleteAttribute(Long id) throws DALException {
        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM concept_attribute WHERE id = ?")) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new DALException("Error deleting attribute", e);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public void deleteConcept(Long id) throws DALException {
        Connection conn = ConnectionPool.InformationModel.pop();
        try {
            conn.setAutoCommit(false);
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
        } catch (SQLException e) {
            throw new DALException("Error deleting concept", e);
        }finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public void populateTct(Long id, Long superclass) throws DALException {
        Connection conn = ConnectionPool.InformationModel.pop();
        try {
            conn.setAutoCommit(false);
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
        } catch (SQLException e) {
            throw new DALException("Error populating tct", e);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public List<ConceptSummary> getSubtypes(Long id, Boolean all) throws DALException {
        Connection conn = ConnectionPool.InformationModel.pop();
        String sql = "SELECT c.id, c.full_name, c.context, c.status, c.version, false as synonym, c.code_scheme, cs.full_name as code_scheme_name\n" +
            "FROM concept c\n" +
            "LEFT JOIN concept cs ON cs.id = c.code_scheme\n" +
            "WHERE c.superclass = ?\n";

        if (all)
            sql += "UNION\n" +
            "SELECT c.id, c.full_name, c.context, c.status, c.version, false as synonym, c.code_scheme, cs.full_name as code_scheme_name\n" +
            "FROM concept_tct t\n" +
            "JOIN concept c on c.id = t.concept\n" +
            "LEFT JOIN concept cs ON cs.id = c.code_scheme\n" +
            "WHERE t.ancestor = ?;\n";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            if (all)
                stmt.setLong(2, id);

            return getConceptSummaryListFromStatement(stmt);
        } catch (SQLException e) {
            throw new DALException("Error fetching subtypes", e);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public Long saveConcept(Concept concept) throws DALException {
        Connection conn = ConnectionPool.InformationModel.pop();
        try {
            conn.setAutoCommit(false);
            String sql;
            Long id = concept.getId();
            if (id == null) {
                sql = "INSERT INTO concept (superclass, url, full_name, short_name, context, status, version, description, use_count, last_update) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            } else {
                archiveConcept(conn, concept.getId());
                concept.incVersion();
                sql = "UPDATE concept SET superclass = ?, url = ?, full_name = ?, short_name = ?, context = ?, status = ?, version = ?, " +
                    "description = ?, use_count = ?, last_update = ? WHERE id = ?";
            }
            concept.setLastUpdate(new java.util.Date());


            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
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
                if (id != null)
                    stmt.setLong(i++, id);

                stmt.executeUpdate();

                if (id == null)
                    id = getGeneratedKey(stmt);

                conn.commit();

                return id;
            }
        } catch (SQLException e) {
            throw new DALException("Error saving concept", e);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    private void archiveConcept(Connection conn, Long conceptId) throws DALException {
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept_archive SELECT * FROM concept WHERE id = ?")) {
            stmt.setLong(1, conceptId);
            stmt.execute();
        } catch (SQLException e) {
            throw new DALException("Error archiving concept", e);
        }
    }
}
