package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.common.models.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.StreamSupport;

import static java.sql.Types.*;

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
    public List<ConceptSummary> getMRU(Boolean includeDeprecated) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();

        String sql = "SELECT c.id, c.context, c.full_name, c.status, c.version, false as synonym " +
            "FROM concept c ";

        if (includeDeprecated == null || !includeDeprecated)
            sql += "WHERE c.status <> 2 ";

        sql += "ORDER BY last_update DESC " +
            "LIMIT ? ";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, PAGE_SIZE);
            return getConceptSummaryListFromStatment(stmt);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public List<ConceptSummary> search(String term, Boolean includeDeprecated, Long superclass) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();

        // Select the SYNONYM as the full name and the PREFERRED as description
        String sql = "SELECT * FROM (\n" +
            "SELECT id, full_name, context, status, version, false as synonym\n" +
            "FROM concept\n" +
            "WHERE full_name LIKE ?\n";

        if (!includeDeprecated)
            sql += "AND status <> 2 ";
        if (superclass != null)
            sql += "AND superclass = ? ";

        sql += "UNION\n" +
            "SELECT s.concept as id, s.term as full_name, c.context, s.status, c.version, true as synonym \n" +
            "FROM concept_synonym s\n" +
            "JOIN concept c on c.id = s.concept\n" +
            "WHERE s.term LIKE ?\n";

        if (!includeDeprecated)
            sql += "AND s.status <> 2 ";
        if (superclass != null)
            sql += "AND c.superclass = ? ";

        sql += ") x\n" +
            "ORDER BY (x.status=2), LENGTH(full_name) " +
            "LIMIT ? ";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            int i = 1;
            stmt.setString(i++, "%" + term + "%");
            if (superclass != null)
                stmt.setLong(i++, superclass);
            stmt.setString(i++, "%" + term + "%");
            if (superclass != null)
                stmt.setLong(i++, superclass);
            stmt.setInt(i++, PAGE_SIZE);

            return getConceptSummaryListFromStatment(stmt);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    private List<ConceptSummary> getConceptSummaryListFromStatment(PreparedStatement stmt) throws SQLException {
        try (ResultSet rs = stmt.executeQuery()) {
            List<ConceptSummary> result = new ArrayList<>();
            while (rs.next()) {
                result.add(getConceptSummaryFromResultSet(rs));
            }

            return result;
        }
    }

    private ConceptSummary getConceptSummaryFromResultSet(ResultSet rs) throws SQLException {
        ConceptSummary result = new ConceptSummary()
            .setId(rs.getLong("id"))
            .setName(rs.getString("full_name"))
            .setContext(rs.getString("context"))
            .setStatus(ConceptStatus.byValue(rs.getByte("status")))
            .setVersion(rs.getFloat("version"))
            .setSynonym(rs.getBoolean("synonym"));

        return result;
    }

    @Override
    public List<RelatedConcept> getRelated(Long id, Boolean includeDeprecated) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();

        String sql = "SELECT cr.id, cr.source, s.full_name as source_name, " +
            "cr.target, t.full_name as target_name, " +
            "cr.relationship, r.full_name as relationship_name, " +
            "cr.`order`, cr.mandatory, cr.`limit` " +
            "FROM concept_relationship cr " +
            "JOIN concept s ON s.id = cr.source " +
            "JOIN concept t ON t.id = cr.target " +
            "JOIN concept r ON r.id = cr.relationship " +
            "WHERE cr.source = ? OR cr.target = ? ";

        if (!includeDeprecated)
            sql += "AND cr.status <> 2 " +
                "AND t.status <> 2 ";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.setLong(2, id);
            return getRelatedListFromStatement(stmt);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public List<Attribute> getAttributes(Long id, Long attributeConceptId, Boolean includeDeprecated) throws Exception {
        Connection conn = ConnectionPool.InformationModel.pop();

        String sql = "SELECT ca.*, cav.id as avid, cav.fixed_value, cav.fixed_concept, " +
            "c.full_name as concept_name, " +
            "a.full_name as attribute_name, " +
            "t.id as type, " +
            "t.full_name as type_name, " +
            "f.full_name as fixed_name " +
            "FROM concept_attribute ca " +
            "JOIN concept c ON c.id = ca.concept " +
            "JOIN concept a ON a.id = ca.attribute " +
            "JOIN concept t ON t.id = a.superclass " +
            "LEFT OUTER JOIN concept_attribute_value cav ON cav.concept = ? AND cav.concept_attribute = ca.id " +
            "LEFT OUTER JOIN concept f ON f.id = cav.fixed_concept " +
            "WHERE ca.concept = ? ";

        if (!includeDeprecated)
            sql += "AND ca.status <> 2 " +
                "AND a.status <> 2 ";

        sql += "ORDER BY ca.`order` ";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.setLong(2, attributeConceptId);
            return getAttributeListFromStatement(stmt);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public void saveConceptBundle(Bundle bundle) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        conn.setAutoCommit(false);
        try {

            saveConcept(conn, bundle.getConcept());
            editAttributes(conn, bundle.getConcept().getId(), bundle.getEdits().getEditedAttributes());
            deleteAttributes(conn, bundle.getEdits().getDeletedAttributes());
            editRelationships(conn, bundle.getConcept().getId(), bundle.getEdits().getEditedRelated());
            deleteRelationships(conn, bundle.getEdits().getDeletedRelated());

            conn.commit();
        } catch (Exception e) {
            conn.rollback();
            throw e;
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
    public Long saveConcept(Concept concept) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        try {
            saveConcept(conn, concept);
            return concept.getId();
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    private void saveConcept(Connection conn, Concept concept) throws SQLException {
        String sql;
        if (concept.getId() == null) {
            concept.setId(TableIdHelper.getNextId("Concept"));
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
            stmt.setDate(i++, new Date(concept.getLastUpdate().getTime()));
            stmt.setLong(i++, concept.getId());

            stmt.executeUpdate();

            if (concept.getId() == null)
                concept.setId(getGeneratedKey(stmt));
        }
    }

    private void editAttributes(Connection conn, Long conceptId, List<Attribute> attributes) throws SQLException {
        try (PreparedStatement insert = conn.prepareStatement("INSERT INTO concept_attribute (minimum, maximum, concept, attribute) VALUES (?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
             PreparedStatement update = conn.prepareStatement("UPDATE concept_attribute SET minimum = ?, maximum = ? WHERE concept = ? AND attribute = ?")) {

            for (Attribute attribute : attributes) {
                if (attribute.getConcept().getId() == null) // Its a new attribute added to this concept
                    attribute.setConcept(new Reference().setId(conceptId));

                if (attribute.getAttribute().getId() == null)   // The attribute itself is new
                    createDraftConcept(conn, attribute.getAttribute());

                PreparedStatement stmt = (attribute.getId() == null) ? insert : update;
                int i = 1;
                stmt.setInt(i++, attribute.getMinimum());
                stmt.setInt(i++, attribute.getMaximum());
                stmt.setLong(i++, attribute.getConcept().getId());
                stmt.setLong(i++, attribute.getAttribute().getId());
                stmt.executeUpdate();
                if (stmt == insert)
                    attribute.setId(getGeneratedKey(stmt));

                setFixedAttributeValue(conn, conceptId, attribute);
            }
        }
    }

    private void setFixedAttributeValue(Connection conn, Long conceptId, Attribute attribute) throws SQLException {
        try (PreparedStatement insert = conn.prepareStatement("INSERT INTO concept_attribute_value (fixed_concept, fixed_value, concept, concept_attribute) VALUES (?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
             PreparedStatement update = conn.prepareStatement("UPDATE concept_attribute_value SET fixed_concept = ?, fixed_value = ? WHERE concept = ? AND concept_attribute = ?")) {

            PreparedStatement stmt = attribute.getValue().getId() == null ? insert : update;

            int i = 1;
            if (attribute.getValue().getFixedConcept().getId() == null) stmt.setNull(i++, BIGINT); else stmt.setLong(i++, attribute.getValue().getFixedConcept().getId());
            if (attribute.getValue().getFixedValue() == null) stmt.setNull(i++, VARCHAR); else stmt.setString(i++, attribute.getValue().getFixedValue());
            stmt.setLong(i++, conceptId); // Concept the value belongs to (not necessarily the attribute which could be from a parent)
            stmt.setLong(i++, attribute.getId());

            stmt.executeUpdate();
            if (stmt == insert)
                attribute.getValue().setId(getGeneratedKey(stmt));
        }
    }

    private Long getGeneratedKey(PreparedStatement stmt) throws SQLException {
        ResultSet rs = stmt.getGeneratedKeys();
        rs.next();
        Long result = rs.getLong(1);
        rs.close();
        return result;
    }

    private void createDraftConcept(Connection conn, Reference reference) throws SQLException {
        Concept concept = new Concept()
            .setSuperclass(new Reference().setId(1L))
            .setStatus(ConceptStatus.DRAFT)
            .setVersion(0.1F)
            .setFullName(reference.getName())
            .setContext(reference.getName())
            .setUseCount(0L);

        saveConcept(conn, concept);
        reference.setId(concept.getId());
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

    private Concept getConceptFromStatement(PreparedStatement stmt) throws SQLException {
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next())
                return getConceptFromResultSet(rs, getColumnList(rs));
            else
                return null;
        }
    }

    private Concept getConceptFromResultSet(ResultSet rs, List<String> fields) throws SQLException {
        int idx;
        Concept concept = new Concept();
        if ((idx = fields.indexOf("id")) > 0) concept.setId(rs.getLong(idx));
        if ((idx = fields.indexOf("superclass")) > 0) concept.setSuperclass(new Reference(rs.getLong(idx), rs.getString("superclass_name")));
        if ((idx = fields.indexOf("url")) > 0) concept.setUrl(rs.getString(idx));
        if ((idx = fields.indexOf("full_name")) > 0) concept.setFullName(rs.getString(idx));
        if ((idx = fields.indexOf("short_name")) > 0) concept.setShortName(rs.getString(idx));
        if ((idx = fields.indexOf("context")) > 0) concept.setContext(rs.getString(idx));
        if ((idx = fields.indexOf("status")) > 0) concept.setStatus(ConceptStatus.byValue(rs.getByte(idx)));
        if ((idx = fields.indexOf("version")) > 0) concept.setVersion(rs.getFloat(idx));
        if ((idx = fields.indexOf("description")) > 0) concept.setDescription(rs.getString(idx));
        if ((idx = fields.indexOf("use_count")) > 0) concept.setUseCount(rs.getLong(idx));
        if ((idx = fields.indexOf("last_update")) > 0) concept.setLastUpdate(rs.getDate(idx));

        return concept;
    }

    private List<String> getColumnList(ResultSet rs) throws SQLException {
        List<String> result = new ArrayList<>();

        ResultSetMetaData metaData = rs.getMetaData();
        result.add(""); // Dummy column as field indexes start at 1

        for (int i = 1; i <= metaData.getColumnCount(); i++) {
            result.add(metaData.getColumnLabel(i));
        }

        return result;
    }

    private List<RelatedConcept> getRelatedListFromStatement(PreparedStatement stmt) throws SQLException {
        List<RelatedConcept> result = new ArrayList<>();
        try (ResultSet rs = stmt.executeQuery()) {
            while(rs.next()) {
                result.add(getRelatedConceptFromResultSet(rs));
            }
        }
        return result;
    }

    private RelatedConcept getRelatedConceptFromResultSet(ResultSet rs) throws SQLException {
        return new RelatedConcept()
            .setId(rs.getLong("id"))
            .setSource(
                new Reference()
                    .setId(rs.getLong("source"))
                    .setName(rs.getString("source_name"))
            )
            .setTarget(
                new Reference()
                    .setId(rs.getLong("target"))
                    .setName(rs.getString("target_name"))
            )
            .setRelationship(
                new Reference()
                    .setId(rs.getLong("relationship"))
                    .setName(rs.getString("relationship_name"))
            )
            .setOrder(rs.getInt("order"))
            .setMandatory(rs.getBoolean("mandatory"))
            .setLimit(rs.getInt("limit"));
    }

    private List<Attribute> getAttributeListFromStatement(PreparedStatement stmt) throws SQLException {
        List<Attribute> result = new ArrayList<>();
        try (ResultSet rs = stmt.executeQuery()) {
            while(rs.next()) {
                result.add(getAttributeFromResultSet(rs));
            }
        }
        return result;
    }

    private Attribute getAttributeFromResultSet(ResultSet rs) throws SQLException {
        Attribute result = new Attribute()
            .setId(rs.getLong("id"))
            .setConcept(
                new Reference()
                .setId(rs.getLong("concept"))
                .setName(rs.getString("concept_name"))
            )
            .setAttribute(
                new Reference()
                .setId(rs.getLong("attribute"))
                .setName(rs.getString("attribute_name"))
            )
            .setType(
                new Reference()
                .setId(rs.getLong("type"))
                .setName(rs.getString("type_name"))
            )
            .setMinimum(rs.getInt("minimum"))
            .setMaximum(rs.getInt("maximum"));

        Long avid = rs.getLong("avid");
        if (rs.wasNull()) avid = null;

        AttributeValue value = new AttributeValue()
            .setId(avid)
            .setFixedValue(rs.getString("fixed_value"));

        Reference fixedConcept = new Reference()
            .setId(rs.getLong("fixed_concept"))
            .setName(rs.getString("fixed_name"));

        if (!rs.wasNull()) {
            value.setFixedConcept(fixedConcept);
        }

        result.setValue(value);

        return result;
    }
}
