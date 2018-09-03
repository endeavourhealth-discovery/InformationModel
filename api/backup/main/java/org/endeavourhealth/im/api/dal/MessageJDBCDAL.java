package org.endeavourhealth.im.dal;

//import org.endeavourhealth.im.common.models.Message;
//import org.endeavourhealth.im.common.models.MessageResource;
//import org.endeavourhealth.im.common.models.MessageResourceField;
//
//import java.sql.*;

public class MessageJDBCDAL implements MessageDAL {
/*
    @Override
    public Long getMessageId(Long systemId, Long messageTypeId, String version) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement stmt = conn.prepareStatement("SELECT id FROM message WHERE system_concept_id = ? AND type_concept_id = ? AND version = ?")) {
            stmt.setLong(1, systemId);
            stmt.setLong(2, messageTypeId);
            stmt.setString(3, version);
            ResultSet rs = stmt.executeQuery();

            if (rs.next())
                return rs.getLong(1);

            return null;
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public Long getResourceId(Long messageId, Long resourceTypeId) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement stmt = conn.prepareStatement("SELECT id FROM message_resource WHERE message_id = ? AND resource_concept_id = ?")) {
            stmt.setLong(1, messageId);
            stmt.setLong(2, resourceTypeId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next())
                return rs.getLong(1);

            return null;
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public Long getFieldId(Long resourceId, String name) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement stmt = conn.prepareStatement("SELECT id FROM message_resource_field WHERE message_resource_id = ? AND field_name = ?")) {
            stmt.setLong(1, resourceId);
            stmt.setString(2, name);
            ResultSet rs = stmt.executeQuery();

            if (rs.next())
                return rs.getLong(1);

            return null;
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public void saveMessage(Message message) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO message (organisation_uuid, system_concept_id, version, type_concept_id) VALUES (?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, message.getSourceOrganisation());
            stmt.setLong(2, message.getSourceSystem().getId());
            stmt.setString(3, message.getVersion());
            stmt.setLong(4, message.getMessageType().getId());
            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            rs.next();
            message.setId(rs.getLong(1));
            rs.close();
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public void saveMessageResource(Long messageId, MessageResource resource) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO message_resource (message_id, resource_concept_id) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, messageId);
            stmt.setLong(2, resource.getResourceType().getId());
            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            rs.next();
            resource.setId(rs.getLong(1));
            rs.close();

        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    @Override
    public void saveMessageResourceField(Long resourceId, MessageResourceField field) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();

        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO message_resource_field (message_resource_id, field_name, value, scheme_concept_id) VALUES (?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, resourceId);
            stmt.setString(2, field.getName());
            stmt.setString(3, field.getValue());
            if (field.getScheme() == null || field.getScheme().getId() == null)
                stmt.setNull(4, Types.BIGINT);
            else
                stmt.setLong(4, field.getScheme().getId());
            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            rs.next();
            field.setId(rs.getLong(1));
            rs.close();
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }
    */
}
