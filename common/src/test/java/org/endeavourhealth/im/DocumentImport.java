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
    public static final byte NULL = (byte)0;
    public static final byte NUMERIC = (byte)1;
    public static final byte FLOAT = (byte)2;
    public static final byte TEXT = (byte)3;
    public static final byte REFERENCE = (byte)4;
    public static final byte SUBTYPE = (byte)5;
    public static final byte ARRAY = (byte) 6;

    List<String> ids = new ArrayList<>(Arrays.asList("null"));
    List<String> dictionary = new ArrayList<>();
    int compressionBytes = 0;

    private InformationModelDAL db = new InformationModelJDBCDAL();

    @Test
    public void importCore() throws Exception {
        try (DataOutputStream w = new DataOutputStream(new FileOutputStream("IM-dat.bin"))) {
            importFile("Core_IM.json", "http://DiscoveryDataService/InformationModel/dm/core/1.0.1", 40, w);
            importFile("Medication.json", "http://DiscoveryDataService/InformationModel/dm/HealthData/Medication/1.0.1", 11, w);
            //importFile("Working example-3.json", "http/DiscoveryDataService/InformationModel/dm/HealthData/1.0.1", 33, w);
            //importFile("Expression.json", "http/DiscoveryDataService/InformationModel/dm/Snomed/1.0.1", 1, w);
            w.flush();
        }
/*
        System.out.println("Compressed size " + compressionBytes);

        try (FileWriter writer = new FileWriter("IM-ids.bin")) {
            for (String str : ids) {
                writer.write(str);
                writer.write('\n');
            }
        }

        try (FileWriter writer = new FileWriter("IM-dic.bin")) {
            for (String str : dictionary) {
                writer.write(str);
                writer.write('\n');
            }
        }

        ids.clear();
        dictionary.clear();

        try (BufferedReader reader = new BufferedReader(new FileReader("IM-ids.bin"))) {
            String id;
            while((id = reader.readLine()) != null) {
                ids.add(id);
            }
            System.out.println("Loaded " + ids.size() + " ids");
        }

        try (BufferedReader reader = new BufferedReader(new FileReader("IM-dic.bin"))) {
            String word;
            while((word = reader.readLine()) != null) {
                dictionary.add(word);
            }
            System.out.println("Loaded " + dictionary.size() + " words");
        }

        try (DataInputStream dis = new DataInputStream(new FileInputStream("IM-dat.bin"))) {
            while(dis.available() > 0) {
                int id = dis.readInt();
                System.out.println(ids.get(id));
                readFields(dis, 1);
            }
        }*/
    }
/*

    private void readFields(DataInputStream dis, int indent) throws IOException {
        byte fields = dis.readByte();
        for (byte i = 0; i < fields; i++) {
            int id = dis.readInt();
            System.out.print(StringUtils.repeat("\t", indent));
            System.out.print(ids.get(id) + ":");
            readField(dis, indent);
        }
    }

    private void readField(DataInputStream dis, int indent) throws IOException {
        byte t = dis.readByte();
        if (t==NULL)
            System.out.println("null");
        else if (t==NUMERIC)
            System.out.println(dis.readInt());
        else if (t==FLOAT)
            System.out.println(dis.readDouble());
        else if (t==TEXT)
            readSentence(dis, indent + 1, dis.readByte());
        else if (t==REFERENCE)
            System.out.println("{ \"id\" : \"" + ids.get(dis.readInt()) + "\" }");
        else if (t==SUBTYPE)
            readObjectProperty(dis, indent+1);
        else if (t==ARRAY)
            readArrayProperty(dis, indent, dis.readByte());
    }

    private void readArrayProperty(DataInputStream dis, int indent, int count) throws IOException {
        System.out.println("(" + count + ") [");
        for (int i=0; i<count; i++) {
            readField(dis, indent);
        }
        System.out.print(StringUtils.repeat("\t", indent));
        System.out.println("]");
    }

    private void readSentence(DataInputStream dis, int indent, int count) throws IOException {
        System.out.print("\"");
        for(int i=0; i < count; i++) {
            int id = dis.readInt();
            System.out.print(dictionary.get(id) + " ");
        }
        System.out.println("\"");
    }

    private void readObjectProperty(DataInputStream dis, int indent) throws IOException {
        System.out.print(StringUtils.repeat("\t", indent));
        System.out.println("{");
        readFields(dis, indent+1);
        System.out.print(StringUtils.repeat("\t", indent));
        System.out.println("}");
    }
*/

    private void importFile(String filename, String iri, int expectedItems, DataOutputStream w) throws Exception {
        byte[] encoded = Files.readAllBytes(Paths.get(filename));
        String JSON = new String(encoded, Charset.defaultCharset()).trim();
        JsonNode root = ObjectMapperPool.getInstance().readTree(JSON);

        String document = root.get("document").asText();
        assertEquals(iri, document);

        ArrayNode concepts = (ArrayNode) root.get("Concepts");
        assertEquals(expectedItems, concepts.size());

        // Validate ids
        validateConcepts(concepts);

        // Save document
        db.insertDocument(JSON);

        // Save concepts
        for(JsonNode concept: concepts) {
            if (!"Concept".equals(concept.get("id").textValue())) {
                ((ObjectNode) concept).put("document", document);
                db.insertConcept(concept.toString(), Status.ACTIVE);
            }
        }

        // Export concepts to data file

//        for (JsonNode concept : concepts) {
//            w.writeInt(idIndex(concept.get("id").textValue()));    // Int id
//            writeProperties(w, concept, new String[] {"id", "description"});
//        }
    }

    private void validateConcepts(ArrayNode concepts) throws Exception {
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

    private void validateIds(Set<String> ids, JsonNode concept) throws Exception {
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

//
//    private void writeProperties(DataOutputStream w, JsonNode node, String[] ignore) throws IOException {
//        List<String> skip = Arrays.asList(ignore);
//
//        List<Map.Entry<String, JsonNode>> fields = new ArrayList<>();
//        node.fields().forEachRemaining((f) -> { if (!skip.contains(f.getKey())) fields.add(f);});
//
//        w.writeByte(fields.size());
//
//        for(Map.Entry<String, JsonNode> field: fields) {
//            w.writeInt(idIndex(field.getKey()));
//            writeProperty(w, field.getValue());
//        }
//
//    }
//
//    private void writeProperty(DataOutputStream w, JsonNode node) throws IOException {
//        if (node.isNull()) {
//            w.writeByte(NULL);
//        } else if (node.isIntegralNumber()) {
//            w.writeByte(NUMERIC);
//            w.writeInt(node.asInt());
//        } else if (node.isFloatingPointNumber()) {
//            w.writeByte(FLOAT);
//            w.writeDouble(node.asDouble());
//        } else if (node.isTextual()) {
//            w.writeByte(TEXT);
//            writeSentence(w, node.textValue());
//        } else if (node.has("id")) {
//            w.writeByte(REFERENCE);
//            w.writeInt(idIndex(node.get("id").textValue()));
//        } else if (node.isArray()) {
//            w.writeByte(ARRAY);
//            writeArray(w, (ArrayNode)node);
//        } else {
//            w.writeByte(SUBTYPE);
//            writeProperties(w, node, new String[0]);
//        }
//    }
//
//    private void writeArray(DataOutputStream w, ArrayNode nodes) throws IOException {
//        w.writeByte(nodes.size());
//        for(JsonNode n : nodes) {
//            writeProperty(w, n);
//        }
//    }
//
//    private void writeSentence(DataOutputStream w, String sentence) throws IOException {
//        String[] words = sentence.split(" ");
//        w.writeByte(words.length);
//
//        for(String word: words) {
//            w.writeInt(wordIndex(word));
//        }
//    }
//
//    private int idIndex(String id) {
//        id = id.trim().toLowerCase();
//        int idx = ids.indexOf(id);
//        if (idx < 0) {
//            idx = ids.size();
//            ids.add(id);
//        }
//
//        return idx;
//    }
//
//    private int wordIndex(String word) {
//        int idx = dictionary.indexOf(word.trim());
//        if (idx < 0) {
//            idx = dictionary.size();
//            dictionary.add(word.trim());
//        }
//
//        return idx;
//    }
}
