package org.endeavourhealth.im;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.im.dal.InformationModelDAL;
import org.endeavourhealth.im.dal.InformationModelJDBCDAL;
import org.endeavourhealth.im.models.Status;
import org.junit.Test;

import java.io.*;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

import static org.junit.Assert.*;

public class DocumentImport {
    private static InformationModelDAL db = new InformationModelJDBCDAL();

    public static void main(String argv[]) throws Exception {
        importFile("Core_IM.json");
        importFile("Medication.json");
        //importFile("Working example-3.json", "http/DiscoveryDataService/InformationModel/dm/HealthData/1.0.1", 33);
        //importFile("Expression.json", "http/DiscoveryDataService/InformationModel/dm/Snomed/1.0.1", 1);
    }

    private static void importFile(String filename) throws Exception {
        System.out.println("Processing " + filename);

        byte[] encoded = Files.readAllBytes(Paths.get(filename));
        String JSON = new String(encoded, Charset.defaultCharset()).trim();
        JsonNode root = ObjectMapperPool.getInstance().readTree(JSON);

        String document = root.get("document").asText();
        ArrayNode concepts = (ArrayNode) root.get("Concepts");

        // Validate ids
        validateConcepts(concepts);

        // Save document
        int docId = db.getOrCreateDocumentDBId(document);

        // Generate the concept IDs
        for(JsonNode concept: concepts) {
            String id = concept.get("id").textValue();
//            if (!"Concept".equals(id))      // Dont add root "Concept" concept
                db.insertConcept(docId, id);
        }

        // Add the properties
        for(JsonNode concept: concepts) {
//            if (!"Concept".equals(concept.get("id").textValue()))      // Dont add root "Concept" concept
                insertConceptProperties(concept);
        }

        System.out.println("Finished processing " + filename + "\n");
    }

    private static void insertConceptProperties(JsonNode concept) throws Exception {
        String id = concept.get("id").asText();
        System.out.println("\tAdding the " + id);

        int dbid = db.getConceptDbid(id);

        Iterator<Map.Entry<String, JsonNode>> fields = concept.fields();
        while(fields.hasNext()) {
            Map.Entry<String, JsonNode> property = fields.next();
            if (!"id".equals(property.getKey())) {
                JsonNode value = property.getValue();
                if (value.isValueNode()) {
                    System.out.println("\t\t" + property.getKey() + " = " + value.toString());
                    int propertyId = db.getConceptDbid(property.getKey());
                    db.insertConceptPropertyData(dbid, propertyId, value.textValue());
                } else if (value.isObject() && value.has("id")) {
                    System.out.println("\t\t" + property.getKey() + " = (Object)" + value.toString());
                    int valueId = db.getConceptDbid(value.get("id").asText());
                    int propertyId = db.getConceptDbid(property.getKey());
                    db.insertConceptPropertyValue(dbid, propertyId, valueId);
                } else if (value.isObject()) {
                    System.out.println("\t\t" + property.getKey() + " = (Anon)" + value.toString());
                } else
                    throw new IllegalArgumentException("\t\t" + property.getKey() + " is of an invalid type - " + value.toString());
            }
        }
    }

    private static void validateConcepts(ArrayNode concepts) throws Exception {
        Set<String> ids = new HashSet<>();

        // Get ids defined in documents
        for(JsonNode concept: concepts) {
            ids.add(concept.get("id").textValue());
        }

        // Validate
        for(JsonNode concept: concepts) {
            validateIds(ids, concept);
        }
    }

    private static void validateIds(Set<String> ids, JsonNode concept) throws Exception {
        Iterator<String> stringIterator = concept.fieldNames();
        while (stringIterator.hasNext()) {
            String field = stringIterator.next();
            JsonNode node = concept.get(field);

            if (node.has("id")) {
                String id = node.get("id").textValue();
                if (!ids.contains(id)) {
                    Integer dbid = db.getConceptDbid(id);
                    if (dbid == null)
                        throw new ClassNotFoundException("id not found [" + id + "]");
                    else
                        ids.add(id);
                }
            }

            if (node.isArray()) {
                for(JsonNode child: (ArrayNode)node) {
                    validateIds(ids, child);
                }
            } else if (node.isObject()) {
                validateIds(ids, node);
            }
        }
    }
}
