package org.endeavourhealth.im;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Optional;
import java.util.stream.Stream;

public class Importer {
    private CodeDAL dal = new CodeDAL();

    public void execute(String path) throws Exception {
        setup();

        importFile(path, ".*sct2_Concept_Full_INT_\\d{8}.txt", "sct2_concept");
        importFile(path, ".*sct2_Concept_Full_GB1000000_\\d{8}.txt", "sct2_concept");

        importFile(path, ".*sct2_Description_Full-en_INT_\\d{8}.txt", "sct2_description");
        importFile(path, ".*sct2_Description_Full-en-GB_GB1000000_\\d{8}.txt", "sct2_description");

        importFile(path, ".*sct2_Relationship_Full_INT_\\d{8}.txt", "sct2_relationship");
        importFile(path, ".*sct2_Relationship_Full_GB1000000_\\d{8}.txt", "sct2_relationship");

        updateIM();

    }

    public void setup() {

    }

    public void importFile(String path, String name, String table) throws Exception {
        String file = findMatchingFile(path, name);
        dal.importFileDirect(file, table);
    }

    public void updateIM() throws Exception {
        System.out.print("Populating code map...");
        dal.populateMap();
        System.out.println("done.");

        System.out.print("Populating terms (this make take some time)...");
         dal.populateTerms();
        System.out.println("done.");

        System.out.print("Creating IM concepts...");
         dal.createIMConcepts();
        System.out.println("done.");

        System.out.print("Setting concept (full) name...");
         dal.setConceptNames();
        System.out.println("done.");

        System.out.print("Creating IM concept relationships...");
        dal.createIMConceptRelationships();
        System.out.println("done.");

    }

    private String findMatchingFile(String path, String pattern) throws IOException {
        Path start = Paths.get(path);
        try (Stream<Path> stream = Files.walk(start, Integer.MAX_VALUE)) {
            Optional<String> res = stream
                .map(String::valueOf)
                .filter(p -> p.matches(pattern))
                .sorted()
                .findFirst();

            return res.isPresent() ? res.get() : null;
        }
    }
}
