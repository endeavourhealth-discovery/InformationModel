package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import static java.sql.Types.*;

public class DALHelper {
    public static List<String> getColumnList(ResultSet rs) throws SQLException {
        List<String> result = new ArrayList<>();

        ResultSetMetaData metaData = rs.getMetaData();
        result.add(""); // Dummy column as field indexes start at 1

        for (int i = 1; i <= metaData.getColumnCount(); i++) {
            result.add(metaData.getColumnLabel(i));
        }

        return result;
    }

    public static Long getGeneratedKey(PreparedStatement stmt) throws SQLException {
        ResultSet rs = stmt.getGeneratedKeys();
        rs.next();
        Long result = rs.getLong(1);
        rs.close();
        return result;
    }

    public static Concept getConceptFromStatement(PreparedStatement stmt) throws SQLException {
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next())
                return getConceptFromResultSet(rs, getColumnList(rs));
            else
                return null;
        }
    }

    public static Concept getConceptFromResultSet(ResultSet rs, List<String> fields) throws SQLException {
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

    public static List<ConceptSummary> getConceptSummaryListFromStatement(PreparedStatement stmt) throws SQLException {
        try (ResultSet rs = stmt.executeQuery()) {
            List<ConceptSummary> result = new ArrayList<>();
            while (rs.next()) {
                result.add(getConceptSummaryFromResultSet(rs));
            }

            return result;
        }
    }

    public static  ConceptSummary getConceptSummaryFromResultSet(ResultSet rs) throws SQLException {
        ConceptSummary result = new ConceptSummary()
            .setId(rs.getLong("id"))
            .setName(rs.getString("full_name"))
            .setContext(rs.getString("context"))
            .setStatus(ConceptStatus.byValue(rs.getByte("status")))
            .setVersion(rs.getFloat("version"))
            .setSynonym(rs.getBoolean("synonym"));

        return result;
    }

    public static List<View> getViewListFromStatement(PreparedStatement stmt) throws SQLException {
        List<View> result = new ArrayList<>();
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                result.add(getViewFromResultSet(rs));
            }
        }
        return result;
    }

    public static View getViewFromResultSet(ResultSet rs) throws SQLException {
        View view = new View()
            .setId(rs.getLong("id"))
            .setName(rs.getString("name"))
            .setDescription(rs.getString("description"));

        return view;
    }

    public static List<ViewItem> getViewItemListFromStatement(PreparedStatement stmt) throws SQLException {
        List<ViewItem> result = new ArrayList<>();
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                result.add(getViewItemFromResultSet(rs));
            }
        }
        return result;
    }

    public static ViewItem getViewItemFromResultSet(ResultSet rs) throws SQLException {
        ViewItem viewItem = new ViewItem()
            .setId(rs.getLong("id"))
            .setConceptId(rs.getLong("concept"))
            .setConceptName(rs.getString("concept_name"))
            .setParentId(rs.getLong("parent"))
            // .setParentName(rs.getString("parent_name"))
            .setContextId(rs.getLong("context"))
            .setContextName(rs.getString("context_name"));
        return viewItem;
    }

    public static List<RelatedConcept> getRelatedListFromStatement(PreparedStatement stmt) throws SQLException {
        List<RelatedConcept> result = new ArrayList<>();
        try (ResultSet rs = stmt.executeQuery()) {
            while(rs.next()) {
                result.add(getRelatedConceptFromResultSet(rs));
            }
        }
        return result;
    }

    public static RelatedConcept getRelatedConceptFromResultSet(ResultSet rs) throws SQLException {
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


    public static List<Attribute> getAttributeListFromStatement(PreparedStatement stmt) throws SQLException {
        List<Attribute> result = new ArrayList<>();
        try (ResultSet rs = stmt.executeQuery()) {
            while(rs.next()) {
                result.add(getAttributeFromResultSet(rs));
            }
        }
        return result;
    }
    public static Attribute getAttributeFromResultSet(ResultSet rs) throws SQLException {
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
            .setOrder(rs.getInt("order"))
            .setMandatory(rs.getBoolean("mandatory"))
            .setLimit(rs.getInt("limit"))
            .setInheritance(rs.getByte("inheritance"))
            .setStatus(ConceptStatus.byValue(rs.getByte("status")));

        Long vcid = rs.getLong("value_concept");
        if (!rs.wasNull())
            result.setValueConcept(new Reference().setId(vcid).setName(rs.getString("value_type_name")));

        Byte vexp = rs.getByte("value_expression");
        if (!rs.wasNull())
            result.setValueExpression(ValueExpression.byValue(vexp));

        Long fcid = rs.getLong("fixed_concept");
        if (!rs.wasNull())
            result.setFixedConcept(new Reference().setId(fcid).setName(rs.getString("fixed_value_name")));

        result.setFixedValue(rs.getString("fixed_value"));

        return result;
    }

    public static void setLong(PreparedStatement stmt, int i, Long value) throws SQLException {
        if (value == null)
            stmt.setNull(i, BIGINT);
        else
            stmt.setLong(i, value);
    }

    public static void setInt(PreparedStatement stmt, int i, Integer value) throws SQLException {
        if (value == null)
            stmt.setNull(i, INTEGER);
        else
            stmt.setInt(i, value);
    }

    public static void setBool(PreparedStatement stmt, int i, Boolean value) throws SQLException {
        if (value == null)
            stmt.setNull(i, BOOLEAN);
        else
            stmt.setBoolean(i, value);
    }

    public static void setByte(PreparedStatement stmt, int i, Byte value) throws SQLException {
        if (value == null)
            stmt.setNull(i, TINYINT);
        else
            stmt.setByte(i, value);
    }

    public static void setString(PreparedStatement stmt, int i, String value) throws SQLException {
        if (value == null)
            stmt.setNull(i, VARCHAR);
        else
            stmt.setString(i, value);
    }

}
