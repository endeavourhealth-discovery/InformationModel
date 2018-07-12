package org.endeavourhealth.im.api.dal;

import com.fasterxml.jackson.core.type.TypeReference;
import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.im.api.dal.filer.IMFilerDAL;
import org.endeavourhealth.im.api.dal.filer.IMFilerJDBCDAL;
import org.endeavourhealth.im.api.models.ConceptRule;
import org.endeavourhealth.im.api.models.ConceptRuleSet;
import org.endeavourhealth.im.api.models.TransactionAction;
import org.endeavourhealth.im.api.models.TransactionTable;
import org.endeavourhealth.im.common.models.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ConceptJDBCDAL implements ConceptDAL {
    private static final Logger LOG = LoggerFactory.getLogger(ConceptJDBCDAL.class);
    private static final String OWNER = "Endeavour-Health";
    private static final int PAGE_SIZE = 15;
    private final IMFilerDAL filer;

    public ConceptJDBCDAL() {
        this.filer = new IMFilerJDBCDAL();
    }

    public ConceptJDBCDAL(IMFilerDAL filer) {
        this.filer = filer;
    }


    @Override
    public ConceptSummaryList getMRU() throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        String sql = "SELECT id, context, full_name, status, version FROM concept ORDER BY id DESC LIMIT ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, PAGE_SIZE);

            return new ConceptSummaryList()
            .setPage(1)
            .setCount(PAGE_SIZE)
            .setConcepts(getSummaryResultSet(stmt));
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public ConceptSummaryList search(String searchTerm) throws SQLException {
        searchTerm = "%" + searchTerm + "%";

        String sql = "SELECT id, context, full_name, status, version " +
            "FROM concept " +
            "WHERE context like ? OR full_name like ? " +
            "LIMIT ?";

        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, searchTerm);
            stmt.setString(2, searchTerm);
            stmt.setInt(3, PAGE_SIZE);
            return new ConceptSummaryList()
                .setPage(1)
                .setCount(PAGE_SIZE)
                .setConcepts(getSummaryResultSet(stmt));
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public Concept get(Long id) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();

        String sql = "SELECT c.*, t.id as typeId, t.full_name as typeName " +
            "FROM concept c " +
            "JOIN concept t ON t.id = c.type " +
            "WHERE c.id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
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
    public Concept getConceptByContext(String context) throws SQLException {
        Concept concept = null;
        Connection conn = ConnectionPool.InformationModel.pop();

        String sql = "SELECT c.*, t.id as typeId, t.full_name as typeName " +
            "FROM concept c " +
            "JOIN concept t ON t.id = c.type " +
            "WHERE c.context = ?";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
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
    public List<Attribute> getAttributes(Long id) throws SQLException {
        List<Attribute> result = new ArrayList<>();

        String sql = "SELECT a.id, a.attribute_id, c.context, c.full_name, c.status, c.version, a.order, a.mandatory, a.`limit` " +
            "FROM concept c " +
            "JOIN concept_attribute a ON a.attribute_id = c.id " +
            "WHERE a.concept_id = ?";

        Connection conn = ConnectionPool.InformationModel.pop();

        try(PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            while(rs.next()) {
                result.add(
                    new Attribute()
                        .setId(rs.getLong("id"))
                        .setConceptId(id)
                        .setAttributeId(rs.getLong("attribute_id"))
                        .setOrder(rs.getInt("order"))
                        .setMandatory(rs.getBoolean("mandatory"))
                        .setLimit(rs.getInt("limit"))
                        .setAttribute(getConceptSummary(rs))
                );
            }
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }

        return result;
    }


    @Override
    public List<RelatedConcept> getRelatedTargets(Long sourceId) throws SQLException {
        String sql = "SELECT r.id, c.id as targetId, c.context, c.full_name, c.version, c.status, " +
            "rc.id as relationshipId, rc.full_name as relationshipName, r.order, r.mandatory, r.limit, r.weighting " +
            "FROM concept c " +
            "JOIN concept_relationship r ON r.target = c.id " +
            "JOIN concept rc ON rc.id = r.relationship " +
            "WHERE r.source = ?";

        Connection conn = ConnectionPool.InformationModel.pop();

        List<RelatedConcept> result = new ArrayList<>();
        try(PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, sourceId);
            ResultSet rs = stmt.executeQuery();

            while(rs.next()) {
                RelatedConcept related = new RelatedConcept()
                    .setId(rs.getLong("id"))
                    .setSourceId(sourceId)
                    .setTargetId(rs.getLong("targetId"))
                    .setTarget(
                        new ConceptSummary()
                        .setId(rs.getLong("targetId"))
                        .setContext(rs.getString("context"))
                        .setFullName(rs.getString("full_name"))
                        .setStatus(rs.getString("status"))
                        .setVersion(rs.getString("version"))
                    )
                    .setRelationship(
                        new ConceptReference()
                        .setId(rs.getLong("relationshipId"))
                        .setText(rs.getString("relationshipName"))
                    )
                    .setOrder(rs.getInt("order"))
                    .setMandatory(rs.getBoolean("mandatory"))
                    .setLimit(rs.getInt("limit"))
                    .setWeighting(rs.getInt("weighting"));

                result.add(related);
            }


        } finally {
            ConnectionPool.InformationModel.push(conn);
        }

        return result;
    }

    @Override
    public List<RelatedConcept> getRelatedSources(Long targetId) throws SQLException {
        String sql = "SELECT r.id, c.id as sourceId, c.context, c.full_name, c.version, c.status, " +
            "rc.id as relationshipId, rc.full_name as relationshipName, r.order, r.mandatory, r.limit, r.weighting " +
            "FROM concept c " +
            "JOIN concept_relationship r ON r.source = c.id " +
            "JOIN concept rc ON rc.id = r.relationship " +
            "WHERE r.target = ?";

        Connection conn = ConnectionPool.InformationModel.pop();

        List<RelatedConcept> result = new ArrayList<>();
        try(PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, targetId);
            ResultSet rs = stmt.executeQuery();

            while(rs.next()) {
                RelatedConcept related = new RelatedConcept()
                    .setId(rs.getLong("id"))
                    .setTargetId(targetId)
                    .setSourceId(rs.getLong("sourceId"))
                    .setSource(
                        new ConceptSummary()
                            .setId(rs.getLong("sourceId"))
                            .setContext(rs.getString("context"))
                            .setFullName(rs.getString("full_name"))
                            .setStatus(rs.getString("status"))
                            .setVersion(rs.getString("version"))
                    )
                    .setRelationship(
                        new ConceptReference()
                        .setId(rs.getLong("relationshipId"))
                        .setText(rs.getString("relationshipName"))
                    )
                    .setOrder(rs.getInt("order"))
                    .setMandatory(rs.getBoolean("mandatory"))
                    .setLimit(rs.getInt("limit"))
                    .setWeighting(rs.getInt("weighting"));

                result.add(related);
            }


        } finally {
            ConnectionPool.InformationModel.push(conn);
        }

        return result;
    }

    @Override
    public List<ConceptReference> getRelationships() throws SQLException {
        String sql = "SELECT c.id, c.full_name " +
            "FROM concept c " +
            "WHERE c.type = 8"; // 8 == Relationship

        Connection conn = ConnectionPool.InformationModel.pop();

        List<ConceptReference> result = new ArrayList<>();

        try(PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while(rs.next()) {
                result.add(
                    new ConceptReference()
                    .setId(rs.getLong("id"))
                    .setText(rs.getString("full_name"))
                );
            }

            return result;
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public Long save(Concept concept) throws Exception {
        // Resolve references first, if required
        checkAndResolve(concept.getType());

        Long id = this.filer.storeAndApply(
            OWNER,
            concept.getId() == null ? TransactionAction.CREATE : TransactionAction.UPDATE,
            TransactionTable.CONCEPT,
            concept);

        concept.setId(id);
        return id;
    }

    @Override
    public Long save(Attribute att) throws Exception {
        Long id = this.filer.storeAndApply(
            OWNER,
            att.getId() == null ? TransactionAction.CREATE : TransactionAction.UPDATE,
            TransactionTable.ATTRIBUTE,
            att);

        att.setId(id);

        return id;
    }

    @Override
    public Long save(RelatedConcept relatedConcept) throws Exception {
        checkAndResolve(relatedConcept.getRelationship());
        Long id = this.filer.storeAndApply(
            OWNER,
            relatedConcept.getId() == null ? TransactionAction.CREATE : TransactionAction.UPDATE,
            TransactionTable.RELATIONSHIP,
            relatedConcept);

        relatedConcept.setId(id);

        return id;
    }

    @Override
    public void deleteAttribute(Long attributeId) throws Exception {
        this.filer.storeAndApply(
            OWNER,
            TransactionAction.DELETE,
            TransactionTable.ATTRIBUTE,
            new DbEntity().setId(attributeId)
        );
    }

    @Override
    public void deleteRelationship(Long relId) throws Exception{
        this.filer.storeAndApply(
            OWNER,
            TransactionAction.DELETE,
            TransactionTable.RELATIONSHIP,
            new DbEntity().setId(relId)
        );
    }

    @Override
    public List<ConceptRuleSet> getConceptRuleSets(Long conceptId) throws SQLException, IOException {
        String sql = "SELECT * FROM concept_rule WHERE concept_id = ? ORDER BY run_order";

        Connection conn = ConnectionPool.InformationModel.pop();

        List<ConceptRuleSet> result = new ArrayList<>();

        try(PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, conceptId);
            ResultSet rs = stmt.executeQuery();
            while(rs.next()) {
                List<ConceptRule> rules = ObjectMapperPool.getInstance().readValue(rs.getString("ruleset"), new TypeReference<List<ConceptRule>>(){});
                result.add(
                    new ConceptRuleSet()
                    .setId(rs.getLong("id"))
                    .setConceptId(conceptId)
                    .setTargetId(rs.getLong("target_id"))
                    .setRules(rules)
                );
            }

            return result;
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    private List<ConceptSummary> getSummaryResultSet(PreparedStatement stmt) throws SQLException {
        List<ConceptSummary> result = new ArrayList<>();

        ResultSet rs = stmt.executeQuery();
        while(rs.next()) {
            result.add(getConceptSummary(rs));
        }

        return result;
    }

    private ConceptSummary getConceptSummary(ResultSet rs) throws SQLException {
        return new ConceptSummary()
            .setId(rs.getLong("id"))
            .setContext(rs.getString("context"))
            .setFullName(rs.getString("full_name"))
            .setStatus(ConceptStatus.byValue(rs.getByte("status")).getName())
            .setVersion(rs.getString("version"));
    }

    private Concept getConceptFromResultSet(ResultSet rs) throws SQLException {
        return new Concept()
            .setId(rs.getLong("id"))
            .setType(
                new ConceptReference()
                .setId(rs.getLong("typeId"))
                .setText(rs.getString("typeName"))
            )
            .setContext(rs.getString("context"))
            .setDescription(rs.getString("description"))
            .setFullName(rs.getString("full_name"))
            .setCriteria(rs.getString("criteria"))
            .setExpression(rs.getString("Expression"))
            .setUrl(rs.getString("url"))
            .setVersion(rs.getString("version"))
            .setStatus(ConceptStatus.byValue(rs.getByte("status")))
            .setAutoTemplate(rs.getBoolean("auto_template"))
            .setTemplate(rs.getString("template"));
    }

    private void checkAndResolve(ConceptReference ref) throws SQLException {
        if (ref == null || ref.getId() != null)
            return;

        Concept concept = getConceptByContext(ref.getText());
        ref.setId(concept.getId());
    }

    /*














    @Override
    public List<ConceptSummary> getSummaries(Integer page) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();

        int offset = (page - 1) * PAGE_SIZE;

        try (PreparedStatement stmt = conn.prepareStatement("SELECT id, context, full_name, status, version FROM concept LIMIT ?, ?")) {
            stmt.setInt(1, offset);
            stmt.setInt(2, PAGE_SIZE);
            return getSummaryResultSet(stmt);
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
                OWNER,
                concept.getId() == null ? TransactionAction.CREATE : TransactionAction.UPDATE,
                TransactionTable.CONCEPT,
                concept);
    }


    @Override
    public List<ConceptSummary> search(String criteria) throws Exception {
        criteria = "%" + criteria + "%";

        String sql = "SELECT id, context, full_name, status, version " +
            "FROM concept " +
            "WHERE context like ? OR full_name like ? " +
            "LIMIT 50";

        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, criteria);
            statement.setString(2, criteria);
            return getSummaryResultSet(statement);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }



    @Override
    public List<ConceptSummary> getAttributeOf(Long id) throws SQLException {
        String sql = "SELECT c.id, c.context, c.full_name, c.status, c.version " +
            "FROM concept c " +
            "JOIN concept_attribute a ON a.concept_id = c.id " +
            "WHERE a.attribute_id = ?";

        Connection conn = ConnectionPool.InformationModel.pop();

        try(PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return getSummaryResultSet(stmt);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }


    @Override
    public Long saveAttribute(Long conceptId, Long attributeId) throws Exception {
        Attribute att = new Attribute()
            .setConceptId(conceptId)
            .setAttributeId(attributeId);

        return this.filer.storeAndApply(
            OWNER,
            TransactionAction.CREATE,
            TransactionTable.ATTRIBUTE_MODEL,
            att);
    }

    @Override
    public Long saveRelationship(Long sourceId, Long targetId, Long relationshipId) throws Exception {
        Relationship rel = new Relationship()
            .setSource(sourceId)
            .setTarget(targetId)
            .setRelationship(relationshipId);

        return this.filer.storeAndApply(
            OWNER,
            TransactionAction.CREATE,
            TransactionTable.RELATIONSHIP,
            rel);
    }




    @Override
    public Long createDraftConcept(String context) throws Exception {
        Concept concept = new Concept()
                .setContext(context);

        return this.filer.storeAndApply(OWNER, TransactionAction.CREATE, TransactionTable.CONCEPT, concept);
    }

*/
}
