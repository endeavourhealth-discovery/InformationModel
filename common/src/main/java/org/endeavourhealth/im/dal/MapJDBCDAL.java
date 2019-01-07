package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.Concept;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import static org.endeavourhealth.im.dal.DALHelper.getConceptFromStatement;

public class MapJDBCDAL implements MapDAL {

    @Override
    public Concept getByCodeAndScheme(String code, Long scheme) throws DALException {
        Connection conn = ConnectionPool.InformationModel.pop();
        String sql = "SELECT c.*, s.full_name as superclass_name " +
            "FROM concept c " +
            "JOIN concept s ON s.id = c.superclass " +
            "JOIN mapping_code mc ON c.id = mc.concept " +
            "WHERE mc.scheme = ? " +
            "AND mc.code_id = ? ";

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
