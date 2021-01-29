package org.endeavourhealth.informationmodel;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.*;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Importer {
    private static final Logger LOG = LoggerFactory.getLogger(Importer.class);
    private static final int LOGSTEP = 100000;

    private static final String CLINICAL = "999001261000000100";
    private static final String PHARMACY = "999000691000001104";
    private static final String FULLSPEC = "900000000000003001";
    private static final String IS_A = "116680003";
    private static final String ACTIVE = "1";

    public static final String[] concepts = {
        ".*\\\\SnomedCT_InternationalRF2_PRODUCTION_.*\\\\Snapshot\\\\Terminology\\\\sct2_Concept_Snapshot_INT_.*\\.txt",
        ".*\\\\SnomedCT_UKClinicalRF2_PRODUCTION_.*\\\\Snapshot\\\\Terminology\\\\sct2_Concept_Snapshot_.*\\.txt",
        ".*\\\\SnomedCT_UKDrugRF2_PRODUCTION_.*\\\\Snapshot\\\\Terminology\\\\sct2_Concept_Snapshot_.*\\.txt",
    };

    public static final String[] refsets = {
        ".*\\\\SnomedCT_InternationalRF2_PRODUCTION_.*\\\\Snapshot\\\\Refset\\\\Language\\\\der2_cRefset_LanguageSnapshot-en_INT_.*\\.txt",
        ".*\\\\SnomedCT_UKClinicalRF2_PRODUCTION_.*\\\\Snapshot\\\\Refset\\\\Language\\\\der2_cRefset_LanguageSnapshot-en_.*\\.txt",
        ".*\\\\SnomedCT_UKDrugRF2_PRODUCTION_.*\\\\Snapshot\\\\Refset\\\\Language\\\\der2_cRefset_LanguageSnapshot-en_.*\\.txt",
    };

    public static final String[] descriptions = {

        ".*\\\\SnomedCT_InternationalRF2_PRODUCTION_.*\\\\Snapshot\\\\Terminology\\\\sct2_Description_Snapshot-en_INT_.*\\.txt",
        ".*\\\\SnomedCT_UKClinicalRF2_PRODUCTION_.*\\\\Snapshot\\\\Terminology\\\\sct2_Description_Snapshot-en_.*\\.txt",
        ".*\\\\SnomedCT_UKDrugRF2_PRODUCTION_.*\\\\Snapshot\\\\Terminology\\\\sct2_Description_Snapshot-en_.*\\.txt",
    };

    public static final String[] relationships = {
        ".*\\\\SnomedCT_InternationalRF2_PRODUCTION_.*\\\\Snapshot\\\\Terminology\\\\sct2_Relationship_Snapshot_INT_.*\\.txt",
        ".*\\\\SnomedCT_UKClinicalRF2_PRODUCTION_.*\\\\Snapshot\\\\Terminology\\\\sct2_Relationship_Snapshot_.*\\.txt",
        ".*\\\\SnomedCT_UKDrugRF2_PRODUCTION_.*\\\\Snapshot\\\\Terminology\\\\sct2_Relationship_Snapshot_.*\\.txt",
    };

    private Connection conn;
    private Map<String, SnomedConcept> snomed = new HashMap<>(1000000);
    private Set<String> refsetActive = new HashSet<>(1000000);

    public Importer(String connectionString) throws SQLException {
        LOG.info("Connecting to database...");
        conn = DriverManager.getConnection(connectionString);    // NOSONAR
        LOG.info("...connected");
    }

    public void execute(String folder) throws IOException, SQLException {
        // Initial checks
        validateFiles(folder);

        // TRUD file import
        importRefsets(folder);
        importDescriptions(folder);
        importConcepts(folder);
        importRelationships(folder);

        // Apply to database
        buildPatchData();
    }

    // ---------------------- PRIVATES ---------------------- //

    private void validateFiles(String inputFolder) throws IOException {
        String[] files = Stream.of(concepts, descriptions, refsets, relationships)
            .flatMap(Stream::of)
            .toArray(String[]::new);

        for (String file : files) {
            findFileForId(inputFolder, file);
        }

        LOG.info("Input directory contents appear valid");
    }

    private Path findFileForId(String inputFolder, String regex) throws IOException {
        List<Path> paths = Files.find(Paths.get(inputFolder), 16,
            (file, attr) -> file.toString()
                .matches(regex))
            .collect(Collectors.toList());

        if (paths.size() == 0) {
            LOG.error("Could not find {}} in {}", regex, inputFolder);
            throw new IOException("No RF2 files in input directory");
        } else if (paths.size() > 1) {
            LOG.error("Too many matches for {} in {}", regex, inputFolder);
            throw new IOException("Invalid contents of input directory");
        } else {
            LOG.info("Found: {}", paths.get(0).toString());
        }

        return paths.get(0);
    }

    private void importRefsets(String inputFolder) throws IOException {
        LOG.info("Importing refsets...");
        for(String regex: refsets) {
            Path path = findFileForId(inputFolder, regex);
            try (BufferedReader reader = new BufferedReader(new FileReader(path.toFile()))) {
                String line = reader.readLine();    // Skip header
                line = reader.readLine();
                int i = 1;
                while (line != null && !line.isEmpty()) {
                    String[] fields = line.split("\t");

                    if (ACTIVE.equals(fields[2]) && (CLINICAL.equals(fields[4]) || PHARMACY.equals(fields[4]))) {
                        refsetActive.add(fields[5]);
                    }

                    line = reader.readLine();
                    i++;
                    if (i % LOGSTEP == 0)
                        LOG.debug("Processed {} rows...", i);
                }
            }
        }
        LOG.info("Found {} active components", refsetActive.size());
    }

    private void importDescriptions(String inputFolder) throws IOException {
        LOG.info("Importing descriptions...");
        for(String regex: descriptions) {
            Path path = findFileForId(inputFolder, regex);
            try (BufferedReader reader = new BufferedReader(new FileReader(path.toFile()))) {
                String line = reader.readLine();    // Skip header
                line = reader.readLine();
                int i = 1;
                while (line != null && !line.isEmpty()) {
                    String[] fields = line.split("\t");

                    if (ACTIVE.equals(fields[2]) && refsetActive.contains(fields[0]) && FULLSPEC.equals(fields[6])) {
                        snomed.put(fields[4], new SnomedConcept()
                            .setConceptId(fields[4])
                            .setTerm(fields[7])
                        );
                    }

                    line = reader.readLine();
                    i++;
                    if (i % LOGSTEP == 0)
                        LOG.debug("Processed {} rows...", i);
                }
            }
        }
        LOG.info("Imported {} descriptions", snomed.size());
    }

    private void importConcepts(String inputFolder) throws IOException {
        LOG.info("Importing concepts...");
        for(String regex: concepts) {
            Path path = findFileForId(inputFolder, regex);
            try (BufferedReader reader = new BufferedReader(new FileReader(path.toFile()))) {
                String line = reader.readLine();    // Skip header
                line = reader.readLine();
                int i = 1;
                while (line != null && !line.isEmpty()) {
                    String[] fields = line.split("\t");

                    SnomedConcept c = snomed.get(fields[0]);
                    if (c != null)
                        c.setActive(Boolean.parseBoolean(fields[2]));

                    line = reader.readLine();
                    i++;
                    if (i % LOGSTEP == 0)
                        LOG.debug("Processed {} rows...", i);
                }
            }
        }
        LOG.info("Concepts processed");
    }

    private void importRelationships(String inputFolder) throws IOException {
        LOG.info("Importing relationships...");
        for(String regex: relationships) {
            Path path = findFileForId(inputFolder, regex);
            try (BufferedReader reader = new BufferedReader(new FileReader(path.toFile()))) {
                String line = reader.readLine();    // Skip header
                line = reader.readLine();
                int i = 1;
                while (line != null && !line.isEmpty()) {
                    String[] fields = line.split("\t");

                    if (ACTIVE.equals(fields[2]) && IS_A.equals(fields[7])) {
                        SnomedConcept c = snomed.get(fields[4]);
                        if (c != null)
                            c.addParent(new SnomedParent(fields[5], Integer.parseInt(fields[6])));
                    }

                    line = reader.readLine();
                    i++;
                    if (i % LOGSTEP == 0)
                        LOG.debug("Processed {} rows...", i);
                }
            }
        }
        LOG.info("Relationships processed");
    }

    private void buildPatchData() throws SQLException {
        Integer snomedCodeScheme = null;
        Integer snomedDocument = null;
        Integer isA = null;

        // CPO patch delete table
        conn.prepareStatement("CREATE TABLE cpo_delete SELECT * FROM concept_property_object WHERE 1 = 0 LIMIT 1").executeUpdate();

        // Useful DBIDs
        try (PreparedStatement stmt = conn.prepareStatement("SELECT dbid, document, scheme FROM concept WHERE id = 'SN_116680003'");
        ResultSet rs = stmt.executeQuery()) {
            if (!rs.next())
                throw new IllegalStateException("Could not find snomed code scheme concept!!");

            isA = rs.getInt("dbid");
            snomedCodeScheme = rs.getInt("scheme");
            snomedDocument = rs.getInt("document");
        }

        // Identify deprecated relationships
        LOG.info("Processing existing relationships");
        try (PreparedStatement stmt = conn.prepareStatement("SELECT c.dbid AS childDbid, c.code AS childCode, cpo.group, v.dbid AS parentDbid, v.code AS parentCode\n" +
            "FROM concept_property_object cpo\n" +
            "JOIN concept c ON c.dbid = cpo.dbid\n" +
            "JOIN concept v ON v.dbid = cpo.value\n" +
            "WHERE c.scheme = " + snomedCodeScheme + "\n" +
            "AND v.scheme = " + snomedCodeScheme + "\n" +
            "AND cpo.property = " + isA + "\n" +
            "ORDER BY c.dbid");
             ResultSet rs = stmt.executeQuery()) {
            int i = 0;
            while (rs.next()) {
                String childCode = rs.getString("childCode");
                String parentCode = rs.getString("parentCode");
                Integer group = rs.getInt("group");
                SnomedConcept c = snomed.get(childCode);
                if (c != null && c.getParents().stream().noneMatch(p -> p.getConceptId().equals(parentCode) && group.equals(p.getGroup()))) {
                    c.setDbid(rs.getInt("childDbid"));
                    c.addDeletedParent(new SnomedParent(parentCode, group).setDbid(rs.getInt("parentDbid")));
                    i++;
                    if (i % LOGSTEP == 0)
                        LOG.debug("Processed {} rows...", i);
                }
            }
            LOG.info("Removing {} deprecated relationships", i);
        }

        // Remove deprecated relationships
        LOG.info("Removing relationships");
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO cpo_delete(property, dbid, value, `group`) VALUES (?, ?, ?, ?)")) {
            int i = 0;
            stmt.setInt(1, isA);
            for (SnomedConcept c: snomed.values()) {
                if (c.getDbid() != null && !c.getDeletedParents().isEmpty()) {
                    stmt.setInt(2, c.getDbid());
                    for (SnomedParent p: c.getDeletedParents()) {
                        stmt.setInt(3, p.getDbid());
                        stmt.setInt(4, p.getGroup());
                        i += stmt.executeUpdate();
                        if (i % (LOGSTEP/100) == 0)
                            LOG.debug("Removing {} relationships...", i);
                    }
                }
            }
            LOG.info("Removed {} deprecated relationships", i);
        }

        // Remove existing snomed codes
        LOG.info("Identifying new concepts");
        try (PreparedStatement stmt = conn.prepareStatement("SELECT c.dbid, c.code, c.name FROM concept c WHERE c.scheme = " + snomedCodeScheme);
        ResultSet rs = stmt.executeQuery()) {
            int i = 0;
            while (rs.next()) {
                snomed.remove(rs.getString("code"));
                i++;
                if (i % LOGSTEP == 0)
                    LOG.debug("Processed {} rows...", i);
            }
        }

        // Patch in new codes
        LOG.info("Inserting {} new concepts", snomed.size());
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept (id, document, name, description, code, scheme) VALUES (?, ?, ?, ?, ?, ?)")) {
            int i = 0;
            for (SnomedConcept c : snomed.values()) {
                stmt.setString(1, "SN_" + c.getConceptId());
                stmt.setInt(2, snomedDocument);
                stmt.setString(3, c.getTerm());
                stmt.setString(4, c.getTerm());
                stmt.setString(5, c.getConceptId());
                stmt.setInt(6, snomedCodeScheme);
                stmt.executeUpdate();
                i++;
                if (i % (LOGSTEP/100) == 0)
                    LOG.debug("Adding {} concepts...", i);
            }
            LOG.info("Added {} concepts", i);
        }

        LOG.info("Inserting new relationships");

        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept_property_object (dbid, property, value, `group`)\n" +
            "SELECT c.dbid, p.dbid, v.dbid, ?\n" +
            "FROM concept c\n" +
            "JOIN concept v ON v.id = ?\n" +
            "JOIN concept p ON p.id = ?\n" +
            "LEFT JOIN concept_property_object cpo ON cpo.dbid = c.dbid AND cpo.property = p.dbid AND cpo.value = v.dbid AND cpo.group = ?\n" +
            "WHERE c.id = ?\n" +
            "AND cpo.dbid IS NULL")) {
            int i = 0;
            for (SnomedConcept c : snomed.values()) {
                for (SnomedParent p : c.getParents()) {
                    stmt.setInt(1, p.getGroup());
                    stmt.setString(2, "SN_" + p.getConceptId());
                    stmt.setString(3, "SN_" + IS_A);
                    stmt.setInt(4, p.getGroup());
                    stmt.setString(5, "SN_" + c.getConceptId());
                    i = i + stmt.executeUpdate();
                    if (i % (LOGSTEP/100) == 0)
                        LOG.debug("Adding {} relationships...", i);
                }
            }
            LOG.info("Added {} relationships", i);
        }

        LOG.info("Database patched");
    }
}
