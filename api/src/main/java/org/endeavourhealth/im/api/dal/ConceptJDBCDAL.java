package org.endeavourhealth.im.api.dal;

import org.endeavourhealth.im.api.dal.filer.IMFilerDAL;
import org.endeavourhealth.im.api.dal.filer.IMFilerJDBCDAL;
import org.endeavourhealth.im.api.models.TransactionAction;
import org.endeavourhealth.im.api.models.TransactionTable;
import org.endeavourhealth.im.common.models.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ConceptJDBCDAL implements ConceptDAL {
    private static final Logger LOG = LoggerFactory.getLogger(ConceptJDBCDAL.class);
    private static final int PAGE_SIZE = 15;
    private final IMFilerDAL filer;

    public ConceptJDBCDAL() {
        this.filer = new IMFilerJDBCDAL();
    }

    public ConceptJDBCDAL(IMFilerDAL filer) {
        this.filer = filer;
    }

    @Override
    public List<ConceptSummary> getSummaries(Integer page) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();

        int offset = (page - 1) * PAGE_SIZE;

        try (PreparedStatement stmt = conn.prepareStatement("SELECT id, context, status, version FROM concept LIMIT ?, ?")) {
            stmt.setInt(1, offset);
            stmt.setInt(2, PAGE_SIZE);
            return getSummaryResultSet(stmt, false);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public Concept get(Long id) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();

        try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM concept WHERE id = ?")) {
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return getConceptFromResultSet(rs);
            }
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }

        return null;
    }

    @Override
    public Long save(Concept concept) throws Exception {
        return this.filer.storeAndApply(
                "Endeavour Health",
                concept.getId() == null ? TransactionAction.CREATE : TransactionAction.UPDATE,
                TransactionTable.CONCEPT,
                concept);
    }

    @Override
    public Long save(Relationship relationship) throws Exception {
        return this.filer.storeAndApply(
            "Endeavour Health",
            relationship.getId() == null ? TransactionAction.CREATE : TransactionAction.UPDATE,
            TransactionTable.RELATIONSHIP,
            relationship);
    }

    @Override
    public List<ConceptSummary> search(String criteria) throws Exception {
        criteria = "%" + criteria + "%";

        String sql = "SELECT id, context, status, version " +
            "FROM concept " +
            "WHERE context like ? OR full_name like ? " +
            "LIMIT 50";

        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, criteria);
            statement.setString(2, criteria);
            return getSummaryResultSet(statement, false);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public List<RelatedConcept> getRelatedTargets(Long id) throws SQLException {
        String sql = "SELECT c.id, c.context, rc.full_name as relationship " +
            "FROM concept c " +
            "JOIN concept_relationship r ON r.target = c.id " +
            "JOIN concept rc ON rc.id = r.relationship " +
            "WHERE r.source = ?";

        Connection conn = ConnectionPool.InformationModel.pop();

        List<RelatedConcept> result = new ArrayList<>();
        try(PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();

            while(rs.next()) {
                RelatedConcept summary = new RelatedConcept()
                    .setId(rs.getLong("id"))
                    .setContext(rs.getString("context"))
                    .setRelationship(rs.getString("relationship"));

                result.add(summary);
            }


        } finally {
            ConnectionPool.InformationModel.push(conn);
        }

        return result;
    }

    @Override
    public List<RelatedConcept> getRelatedSources(Long id) throws SQLException {
        String sql = "SELECT c.id, c.context, rc.full_name as relationship " +
            "FROM concept c " +
            "JOIN concept_relationship r ON r.source = c.id " +
            "JOIN concept rc ON rc.id = r.relationship " +
            "WHERE r.target = ?";

        Connection conn = ConnectionPool.InformationModel.pop();

        List<RelatedConcept> result = new ArrayList<>();
        try(PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();

            while(rs.next()) {
                RelatedConcept summary = new RelatedConcept()
                    .setId(rs.getLong("id"))
                    .setContext(rs.getString("context"))
                    .setRelationship(rs.getString("relationship"));

                result.add(summary);
            }


        } finally {
            ConnectionPool.InformationModel.push(conn);
        }

        return result;
    }

    @Override
    public List<ConceptSummary> getAttributes(Long id) throws SQLException {
        String sql = "SELECT c.id, c.context, c.status, c.version " +
            "FROM concept c " +
            "JOIN concept_attribute a ON a.attribute_id = c.id " +
            "WHERE a.concept_id = ?";

        Connection conn = ConnectionPool.InformationModel.pop();

        try(PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return getSummaryResultSet(stmt, false);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public List<ConceptSummary> getAttributeOf(Long id) throws SQLException {
        String sql = "SELECT c.id, c.context, c.status, c.version " +
            "FROM concept c " +
            "JOIN concept_attribute a ON a.concept_id = c.id " +
            "WHERE a.attribute_id = ?";

        Connection conn = ConnectionPool.InformationModel.pop();

        try(PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return getSummaryResultSet(stmt, false);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    private List<ConceptSummary> getSummaryResultSet(PreparedStatement stmt, Boolean includeRelationship) throws SQLException {
        List<ConceptSummary> result = new ArrayList<>();

        ResultSet rs = stmt.executeQuery();

        while(rs.next()) {
            ConceptSummary summary = new ConceptSummary()
                .setId(rs.getLong("id"))
                .setContext(rs.getString("context"))
                .setStatus(ConceptStatus.byValue(rs.getByte("status")).getName())
                .setVersion(rs.getString("version"));

            if (includeRelationship)
                summary.setRelationship(ConceptRelationship.forValue(rs.getInt("relationship")));

            result.add(summary);
        }

        return result;
    }

    @Override
    public Concept getConceptByContext(String context) throws SQLException {
        Concept concept = null;
        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement statement = conn.prepareStatement("SELECT * FROM concept WHERE context = ?")) {
            statement.setString(1, context);
            ResultSet res = statement.executeQuery();
            if (res.next()) {
                concept = getConceptFromResultSet(res);
            }
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }

        return concept;
    }

    @Override
    public Long createDraftConcept(String context) throws Exception {
        Concept concept = new Concept()
                .setContext(context);

        return this.filer.storeAndApply("Endeavour Health", TransactionAction.CREATE, TransactionTable.CONCEPT, concept);
    }

    private Concept getConceptFromResultSet(ResultSet rs) throws SQLException {
        return new Concept()
                .setId(rs.getLong("id"))
                .setContext(rs.getString("context"))
                .setDescription(rs.getString("description"))
                .setFullName(rs.getString("full_name"))
                .setCriteria(rs.getString("criteria"))
                .setExpression(rs.getString("Expression"))
                .setUrl(rs.getString("url"))
                .setVersion(rs.getString("version"))
                .setStatus(ConceptStatus.byValue(rs.getByte("status")));
    }
}
