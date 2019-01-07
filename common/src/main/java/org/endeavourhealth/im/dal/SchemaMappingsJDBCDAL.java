package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.SchemaMapping;
import org.endeavourhealth.im.models.SearchResult;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import static org.endeavourhealth.im.dal.DALHelper.getConceptSummaryListFromStatement;
import static org.endeavourhealth.im.dal.DALHelper.getSchemaMappingListFromStatement;

public class SchemaMappingsJDBCDAL implements SchemaMappingsDAL {
    @Override
    public SearchResult getRecordTypes() throws DALException {
        Connection conn = ConnectionPool.InformationModel.pop();

        SearchResult result = new SearchResult().setPage(1);

        String sql = "SELECT c.id, c.context, c.full_name, c.status, c.version, false as synonym, c.code_scheme, cs.full_name AS code_scheme_name\n" +
            "FROM concept_tct t\n" +
            "JOIN concept c ON c.id = t.concept\n" +
            "LEFT JOIN concept cs ON cs.id = c.code_scheme\n"+
            "WHERE t.ancestor = 4\n" +
            "ORDER BY c.last_update DESC;";

        try(PreparedStatement stmt = conn.prepareStatement(sql)) {
            result.setResults(getConceptSummaryListFromStatement(stmt));
            result.setCount(result.getResults().size());

            return result;
        } catch (SQLException e) {
            throw new DALException("Error fetching record types", e);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public List<SchemaMapping> getSchemaMappings(Long conceptId) throws DALException {
        Connection conn = ConnectionPool.InformationModel.pop();
        String sql = "SELECT m.*, a.full_name " +
            "FROM concept_schema_map m " +
            "JOIN concept a ON a.id = m.attribute " +
            "WHERE m.concept = ?";
        try(PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, conceptId);
            return getSchemaMappingListFromStatement(stmt);
        } catch (SQLException e) {
            throw new DALException("Error fetching schema mappings", e);

        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }
}
