package org.endeavourhealth.im;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.im.dal.InformationModelDAL;
import org.endeavourhealth.im.dal.InformationModelJDBCDAL;
import org.junit.Test;

import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;

import static org.junit.Assert.*;

public class DocumentImport {

    @Test
    public void importCore() throws Exception {
//        importFile("Core_IM.json", "http/DiscoveryDataService/InformationModel/dm/core/1.0.1", 17);
//        importFile("Working example-3.json", "http/DiscoveryDataService/InformationModel/dm/HealthData/1.0.1",13);
//        importFile("Expression.json", "http/DiscoveryDataService/InformationModel/dm/Snomed/1.0.1", 1);
    }

    private void importFile(String filename, String iri, int expectedItems) throws Exception {
        byte[] encoded = Files.readAllBytes(Paths.get(filename));
        String JSON = new String(encoded, Charset.defaultCharset()).trim();
        JsonNode root = ObjectMapperPool.getInstance().readTree(JSON);

        String document = root.get("@document").asText();
        assertEquals(iri, document);

        ArrayNode concepts = (ArrayNode) root.get("Concepts");
        assertEquals(expectedItems, concepts.size());

        // Save document
        InformationModelDAL db = new InformationModelJDBCDAL();
        db.saveDocument(JSON);

        // Save concepts
        for(JsonNode concept: concepts) {
            ((ObjectNode) concept).put("@document", document);
            db.saveConcept(concept.toString());
        }
    }
}
