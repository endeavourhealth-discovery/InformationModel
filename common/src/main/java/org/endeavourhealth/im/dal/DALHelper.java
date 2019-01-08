package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static java.sql.Types.*;

public class DALHelper {
    public static List<String> getColumnList(ResultSet rs) {
        List<String> result = new ArrayList<>();

        try {
            ResultSetMetaData metaData = rs.getMetaData();
            result.add(""); // Dummy column as field indexes start at 1

            for (int i = 1; i <= metaData.getColumnCount(); i++) {
                result.add(metaData.getColumnLabel(i));
            }

            return result;
        } catch (SQLException e) {
            throw new DALException("Error fetching column list", e);
        }
    }

    public static Long getGeneratedKey(PreparedStatement stmt) {
        try (ResultSet rs = stmt.getGeneratedKeys()) {
            rs.next();
            return rs.getLong(1);
        } catch (SQLException e) {
            throw new DALException("Error fetching generated key", e);
        }
    }

    public static Concept getConceptFromStatement(PreparedStatement stmt) {
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next())
                return getConceptFromResultSet(rs, getColumnList(rs));
            else
                return null;
        } catch (SQLException e) {
            throw new DALException("Error fetching concept from statement", e);
        }
    }

    public static Concept getConceptFromResultSet(ResultSet rs, List<String> fields) {
        int idx;
        Concept concept = new Concept();
        try {
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
            if ((idx = fields.indexOf("code")) > 0) concept.setCode(rs.getString(idx));
            if ((idx = fields.indexOf("code_scheme")) > 0) concept.setScheme(new Reference(rs.getLong(idx), rs.getString("code_scheme_name")));
            return concept;
        } catch (SQLException e) {
            throw new DALException("Error fetching concept from result set", e);
        }
    }

    public static List<ConceptSummary> getConceptSummaryListFromStatement(PreparedStatement stmt) {
        try (ResultSet rs = stmt.executeQuery()) {
            List<ConceptSummary> result = new ArrayList<>();
            while (rs.next()) {
                result.add(getConceptSummaryFromResultSet(rs));
            }

            return result;
        } catch (SQLException e) {
            throw new DALException("Error fetching summary list from statement", e);

        }
    }

    public static  ConceptSummary getConceptSummaryFromResultSet(ResultSet rs) {
        try {
            ConceptSummary result = new ConceptSummary()
                .setId(rs.getLong("id"))
                .setName(rs.getString("full_name"))
                .setContext(rs.getString("context"))
                .setStatus(ConceptStatus.byValue(rs.getByte("status")))
                .setVersion(rs.getFloat("version"))
                .setSynonym(rs.getBoolean("synonym"))
                .setScheme(new Reference().setId(rs.getLong("code_scheme")).setName(rs.getString("code_scheme_name")));

            return result;
        } catch (SQLException e) {
            throw new DALException("Error fetching summary from result set", e);
        }
    }

    public static List<View> getViewListFromStatement(PreparedStatement stmt) {
        List<View> result = new ArrayList<>();
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                result.add(getViewFromResultSet(rs));
            }
        } catch (SQLException e) {
            throw new DALException("Error fetching view list from statement", e);
        }
        return result;
    }

    public static View getViewFromResultSet(ResultSet rs) {
        try {
            View view = new View()
                .setId(rs.getLong("id"))
                .setName(rs.getString("name"))
                .setDescription(rs.getString("description"));

            return view;
        } catch (SQLException e) {
            throw new DALException("Error fetching view from result set", e);
        }
    }

    public static List<ViewItem> getViewItemListFromStatement(PreparedStatement stmt) {
        List<ViewItem> result = new ArrayList<>();
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                result.add(getViewItemFromResultSet(rs));
            }
            return result;
        } catch (SQLException e) {
            throw new DALException("Error fetching view item list from statement", e);

        }
    }

    public static ViewItem getViewItemFromResultSet(ResultSet rs) {
        try {
            ViewItem viewItem = new ViewItem()
                .setId(rs.getLong("id"))
                .setConceptId(rs.getLong("concept"))
                .setConceptName(rs.getString("concept_name"))
                .setParentId(rs.getLong("parent"))
                // .setParentName(rs.getString("parent_name"))
                .setContextId(rs.getLong("context"))
                .setContextName(rs.getString("context_name"));
            return viewItem;
        } catch (SQLException e) {
            throw new DALException("Error fetching view item from result set", e);
        }
    }

    public static List<Attribute> getAttributeListFromStatement(PreparedStatement stmt) {
        List<Attribute> result = new ArrayList<>();
        try (ResultSet rs = stmt.executeQuery()) {
            while(rs.next()) {
                result.add(getAttributeFromResultSet(rs));
            }
            return result;
        } catch (SQLException e) {
            throw new DALException("Error fetching attribute list from statement", e);
        }
    }
    public static Attribute getAttributeFromResultSet(ResultSet rs) {
        try {
            Attribute result = new Attribute()
                .setId(rs.getLong("id"))
                .setVersion(rs.getFloat("version"))
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
        } catch (SQLException e) {
            throw new DALException("Error attribute from result set", e);
        }
    }

    public static List<SchemaMapping> getSchemaMappingListFromStatement(PreparedStatement stmt) {
        List<SchemaMapping> result = new ArrayList<>();
        try (ResultSet rs = stmt.executeQuery()) {
            while(rs.next()) {
                result.add(getSchemaMappingFromResultSet(rs));
            }
            return result;
        } catch (SQLException e) {
            throw new DALException("Error fetching schema mappings list from statement", e);
        }
    }

    public static SchemaMapping getSchemaMappingFromResultSet(ResultSet rs) {
        try {
            return new SchemaMapping()
                .setId(rs.getLong("id"))
                .setAttribute(
                    new Reference()
                        .setId(rs.getLong("attribute"))
                        .setName(rs.getString("full_name"))
                )
                .setTable(rs.getString("table"))
                .setField(rs.getString("field"));
        } catch (SQLException e) {
            throw new DALException("Error fetching schema mapping from result set", e);
        }
    }

    public static void setLong(PreparedStatement stmt, int i, Long value) {
        try {
            if (value == null)
                stmt.setNull(i, BIGINT);
            else
                stmt.setLong(i, value);
        } catch (SQLException e) {
            throw new DALException("Error setting LONG value", e);
        }
    }

    public static void setFloat(PreparedStatement stmt, int i, Float value) {
        try {
            if (value == null)
                stmt.setNull(i, FLOAT);
            else
                stmt.setFloat(i, value);
        } catch (SQLException e) {
            throw new DALException("Error setting FLOAT value", e);
        }
    }

    public static void setInt(PreparedStatement stmt, int i, Integer value) {
        try {
            if (value == null)
                stmt.setNull(i, INTEGER);
            else
                stmt.setInt(i, value);
        } catch (SQLException e) {
            throw new DALException("Error setting INT value", e);
        }
    }

    public static void setBool(PreparedStatement stmt, int i, Boolean value) {
        try {
            if (value == null)
                stmt.setNull(i, BOOLEAN);
            else
                stmt.setBoolean(i, value);
        } catch (SQLException e) {
            throw new DALException("Error setting BOOL value", e);
        }
    }

    public static void setByte(PreparedStatement stmt, int i, Byte value) {
        try {
            if (value == null)
                stmt.setNull(i, TINYINT);
            else
                stmt.setByte(i, value);
        } catch (SQLException e) {
            throw new DALException("Error setting BYTE value", e);
        }
    }

    public static void setString(PreparedStatement stmt, int i, String value) {
        try {
            if (value == null)
                stmt.setNull(i, VARCHAR);
            else
                stmt.setString(i, value);
        } catch (SQLException e) {
            throw new DALException("Error setting STRING value", e);
        }
    }

    public static void setTimestamp(PreparedStatement stmt, int i, Timestamp value) {
        try {
            if (value == null)
                stmt.setNull(i, TIMESTAMP);
            else
                stmt.setTimestamp(i, value);
        } catch (SQLException e) {
            throw new DALException("Error setting TIMESTAMP value", e);
        }
    }

    public static String inListParams(int size) {
        List<String> q = Collections.nCopies(size, "?");
        return String.join(",", q);
    }

    public static int setLongArray(PreparedStatement stmt, int i, List<Long> values) {
        try {
            for (Long value : values) {
                stmt.setLong(i++, value);
            }
            return i;
        } catch (SQLException e) {
            throw new DALException("Error setting LONG array", e);
        }
    }
}
