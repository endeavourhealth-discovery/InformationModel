package org.endeavourhealth.im.api.dal;

import org.endeavourhealth.im.api.dal.filer.IMFilerDAL;
import org.endeavourhealth.im.api.dal.filer.IMFilerJDBCDAL;
import org.endeavourhealth.im.api.models.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TermJDBCDAL implements TermDAL {
    private final IMFilerDAL filer;

    public TermJDBCDAL() {
        this.filer = new IMFilerJDBCDAL();
    }

    public TermJDBCDAL(IMFilerDAL filer) {
        this.filer = filer;
    }

    @Override
    public Long getConceptId(String organisation, String context, String system, String code) throws Exception {
        String sql = "SELECT concept_id FROM term_mapping WHERE organisation = ? AND context = ? AND system = ? AND code = ?";
        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, organisation);
            stmt.setString(2, context);
            stmt.setString(3, system);
            stmt.setString(4, code);
            ResultSet rs = stmt.executeQuery();
            if (rs.next())
                return rs.getLong(1);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }

        return null;
    }

    @Override
    public void createTermMap(String organisation, String context, String system, String code, Long termId) throws Exception {
        TermMapping termMapping = new TermMapping()
                .setOrganisation(organisation)
                .setContext(context)
                .setSystem(system)
                .setCode(code)
                .setConceptId(termId);

        this.filer.storeAndApply("Endeavour Health", TransactionAction.CREATE, TransactionTable.TERM_MAPPING, termMapping);
    }

    @Override
    public String getSnomedTerm(String code) throws SQLException {
        String sql = "SELECT display FROM trm_concept WHERE code = ?";

        Connection conn = ConnectionPool.Snomed.pop();

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, code);
            ResultSet rs = stmt.executeQuery();
            if (rs.next())
                return rs.getString(1);
        } finally {
            ConnectionPool.Snomed.push(conn);
        }

        return null;
    }

    @Override
    public String getICD10Term(String code) {
        return null;
    }

    @Override
    public String getOpcsTerm(String code) {
        return null;
    }

    @Override
    public List<TermMapping> getMappings(Long conceptId) throws Exception {
        List<TermMapping> result = new ArrayList<>();

        String sql = "SELECT organisation, context, system, code FROM term_mapping WHERE concept_id = ?";
        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, conceptId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                result.add(new TermMapping()
                .setOrganisation(rs.getString("organisation"))
                    .setContext(rs.getString("context"))
                    .setSystem(rs.getString("system"))
                    .setCode(rs.getString("code"))
                    .setConceptId(conceptId)
                );
            }
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }

        return result;
    }
}
