package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.Concept;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import static org.endeavourhealth.im.dal.DALHelper.getConceptFromStatement;

public class MapJDBCDAL implements MapDAL {

    @Override
    public Concept getByCodeAndScheme(String code, Long scheme) {
        Connection conn = ConnectionPool.InformationModel.pop();
        String sql = "SELECT c.*, s.full_name as superclass_name, cs.full_name as code_scheme_name " +
            "FROM concept c " +
            "JOIN concept s ON s.id = c.superclass " +
            "JOIN concept cs ON cs.id = c.code_scheme " +
            "WHERE c.code_scheme = ? " +
            "AND c.code = ? ";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, scheme);
            stmt.setString(2, code);
            return getConceptFromStatement(stmt);
        } catch (SQLException e) {
            throw new DALException("Error fetching map by code and scheme", e);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }
}
