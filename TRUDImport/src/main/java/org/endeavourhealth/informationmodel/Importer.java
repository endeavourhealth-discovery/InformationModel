package org.endeavourhealth.informationmodel;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
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
    private static final String GB_ENGLISH = "900000000000508004";
    private static final String FULLSPEC = "900000000000003001";
    private static final String IS_A = "116680003";
    private static final String ACTIVE = "1";

    public static final String[] concepts = {
        ".*\\\\SnomedCT_InternationalRF2_PRODUCTION_.*\\\\Snapshot\\\\Terminology\\\\sct2_Concept_Snapshot_INT_.*\\.txt",
        ".*\\\\SnomedCT_UKClinicalRF2_PRODUCTION_.*\\\\Snapshot\\\\Terminology\\\\sct2_Concept_.*Snapshot_.*\\.txt",
        ".*\\\\SnomedCT_UKDrugRF2_PRODUCTION_.*\\\\Snapshot\\\\Terminology\\\\sct2_Concept_.*Snapshot_.*\\.txt",
    };

    public static final String[] refsets = {
        ".*\\\\SnomedCT_InternationalRF2_PRODUCTION_.*\\\\Snapshot\\\\Refset\\\\Language\\\\der2_cRefset_LanguageSnapshot-en_INT_.*\\.txt",
        ".*\\\\SnomedCT_UKClinicalRF2_PRODUCTION_.*\\\\Snapshot\\\\Refset\\\\Language\\\\der2_cRefset_Language.*Snapshot-en_.*\\.txt",
        ".*\\\\SnomedCT_UKDrugRF2_PRODUCTION_.*\\\\Snapshot\\\\Refset\\\\Language\\\\der2_cRefset_Language.*Snapshot-en_.*\\.txt",
    };

    public static final String[] descriptions = {

        ".*\\\\SnomedCT_InternationalRF2_PRODUCTION_.*\\\\Snapshot\\\\Terminology\\\\sct2_Description_Snapshot-en_INT_.*\\.txt",
        ".*\\\\SnomedCT_UKClinicalRF2_PRODUCTION_.*\\\\Snapshot\\\\Terminology\\\\sct2_Description_.*Snapshot-en_.*\\.txt",
        ".*\\\\SnomedCT_UKDrugRF2_PRODUCTION_.*\\\\Snapshot\\\\Terminology\\\\sct2_Description_.*Snapshot-en_.*\\.txt",
    };

    public static final String[] relationships = {
        ".*\\\\SnomedCT_InternationalRF2_PRODUCTION_.*\\\\Snapshot\\\\Terminology\\\\sct2_Relationship_Snapshot_INT_.*\\.txt",
        ".*\\\\SnomedCT_UKClinicalRF2_PRODUCTION_.*\\\\Snapshot\\\\Terminology\\\\sct2_Relationship_.*Snapshot_.*\\.txt",
        ".*\\\\SnomedCT_UKDrugRF2_PRODUCTION_.*\\\\Snapshot\\\\Terminology\\\\sct2_Relationship_.*Snapshot_.*\\.txt",
    };

    private Connection conn;
    private Map<String, SnomedConcept> snomed = new HashMap<>(1000000);
    private Set<String> refsetActive = new HashSet<>(1000000);
    private Long start;
    private Integer snomedCodeScheme = null;
    private Integer snomedDocument = null;
    private Integer isA = null;
    private static final HashMap<String, List<String>> parentMap = new HashMap<>(1000000);
    private static final HashMap<String, List<Closure>> closureMap = new HashMap<>(1000000);

    public Importer(String connectionString) throws SQLException {
        LOG.info("Connecting to database...");
        conn = DriverManager.getConnection(connectionString);    // NOSONAR
        LOG.info("...connected");
    }

    public void execute(String folder) throws IOException, SQLException {
        start = System.currentTimeMillis();

        // Initial checks
        validateFiles(folder);


        // TRUD file import
        importRefsets(folder);
        importDescriptions(folder);
        importConcepts(folder);
        importRelationships(folder);

        // Get useful data
        getDbids();

        // Process data
        processRelationships(snomedCodeScheme, isA);
        generateDelCPOTable(isA);
        saveNewRelationships();
        generateNewCPOTable();

        identifyNewConcepts(snomedCodeScheme);
        saveNewConcepts(snomedCodeScheme, snomedDocument);
        generateNewConceptTable();

        generateTCTTable(folder);
        importTCTTable(folder);
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
        for (String regex : refsets) {
            Path path = findFileForId(inputFolder, regex);
            LOG.info("Importing refsets from " + path.getFileName());
            try (BufferedReader reader = new BufferedReader(new FileReader(path.toFile()))) {
                String line = reader.readLine();    // Skip header
                line = reader.readLine();
                int i = 1;
                while (line != null && !line.isEmpty()) {
                    String[] fields = line.split("\t");

                    if (ACTIVE.equals(fields[2]) && (CLINICAL.equals(fields[4]) || PHARMACY.equals(fields[4]) || GB_ENGLISH.equals(fields[4]))) {
                        refsetActive.add(fields[5]);
                    }

                    line = reader.readLine();
                    i++;
                    if (i % LOGSTEP == 0)
                        LOG.debug("Processed {} rows...", i);
                }
            }
        }
        LOG.info("{} active components loaded", refsetActive.size());
    }

    private void importDescriptions(String inputFolder) throws IOException {
        for (String regex : descriptions) {
            Path path = findFileForId(inputFolder, regex);
            LOG.info("Importing descriptions from " + path.getFileName());
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
        LOG.info("{} descriptions loaded", snomed.size());
    }

    private void importConcepts(String inputFolder) throws IOException {
        for (String regex : concepts) {
            Path path = findFileForId(inputFolder, regex);
            LOG.info("Importing concepts from " + path.getFileName());
            try (BufferedReader reader = new BufferedReader(new FileReader(path.toFile()))) {
                String line = reader.readLine();    // Skip header
                line = reader.readLine();
                int i = 1;
                while (line != null && !line.isEmpty()) {
                    String[] fields = line.split("\t");

                    SnomedConcept c = snomed.get(fields[0]);
                    if (c != null) {
                        c.setActive(Boolean.parseBoolean(fields[2]));
                    }

                    line = reader.readLine();
                    i++;
                    if (i % LOGSTEP == 0)
                        LOG.debug("Processed {} rows...", i);
                }
            }
        }
        LOG.info("Concepts loaded");
    }

    private void importRelationships(String inputFolder) throws IOException {
        for (String regex : relationships) {
            Path path = findFileForId(inputFolder, regex);
            LOG.info("Importing relationships from " + path.getFileName());
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
        LOG.info("Relationships loaded");
    }

    private void getDbids() throws SQLException {
        // Useful DBIDs
        try (PreparedStatement stmt = conn.prepareStatement("SELECT dbid, document, scheme FROM concept WHERE id = 'SN_116680003'");
             ResultSet rs = stmt.executeQuery()) {
            if (!rs.next())
                throw new IllegalStateException("Could not find snomed code scheme concept!!");

            isA = rs.getInt("dbid");
            snomedCodeScheme = rs.getInt("scheme");
            snomedDocument = rs.getInt("document");
        }
    }

    private void generateNewCPOTable() throws SQLException {
        LOG.info("Generating new cpo table");
        // Generate new cpo table
        try (PreparedStatement stmt = conn.prepareStatement("CREATE TABLE cpo_new " +
            "SELECT c.id AS concept, p.id AS property, v.id AS value, cpo.group " +
            "FROM concept_property_object cpo " +
            "JOIN concept c ON c.dbid = cpo.dbid " +
            "JOIN concept p ON p.dbid = cpo.property " +
            "JOIN concept v ON v.dbid = cpo.value " +
            "WHERE cpo.updated >= ?")) {
            stmt.setTimestamp(1, new Timestamp(start));
            stmt.executeUpdate();
        }

        LOG.info("Indexing cpo table");
        try (PreparedStatement stmt = conn.prepareStatement("ALTER TABLE cpo_new ADD INDEX cpo_new_property_idx (property)")) {
            stmt.executeUpdate();
        }

    }

    private void generateNewConceptTable() throws SQLException {
        LOG.info("Generating new concept table");
        // Generate new concept table
        try (PreparedStatement stmt = conn.prepareStatement("CREATE TABLE concept_new SELECT * FROM concept WHERE updated >= ?")) {
            stmt.setTimestamp(1, new Timestamp(start));
            stmt.executeUpdate();
        }
    }

    private void saveNewRelationships() throws SQLException {
        LOG.info("Adding new relationships");

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
                    if (i % (LOGSTEP / 100) == 0)
                        LOG.debug("Added {} relationships...", i);
                }
            }
            LOG.info("Added {} relationships", i);
        }
    }

    private void saveNewConcepts(Integer snomedCodeScheme, Integer snomedDocument) throws SQLException {
        // Patch in new codes
        LOG.info("Adding {} new concepts", snomed.size());
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
                if (i % (LOGSTEP / 100) == 0)
                    LOG.debug("Added {} concepts...", i);
            }
            LOG.info("Added {} concepts", i);
        }
    }

    private void identifyNewConcepts(Integer snomedCodeScheme) throws SQLException {
        // Remove existing snomed codes (leaving only new ones)
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
    }

    private void generateDelCPOTable(Integer isA) throws SQLException {
        // CPO patch delete table
        conn.prepareStatement("CREATE TABLE cpo_delete SELECT * FROM concept_property_object WHERE 1 = 0 LIMIT 1").executeUpdate();

        conn.prepareStatement("ALTER TABLE cpo_delete ADD INDEX cpo_delete_idx (dbid, property, `value`, `group`)").executeUpdate();

        // Remove deprecated relationships
        LOG.info("Saving deprecated relationships (cpo_delete)");
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO cpo_delete(property, dbid, value, `group`) VALUES (?, ?, ?, ?)")) {
            int i = 0;
            stmt.setInt(1, isA);
            for (SnomedConcept c : snomed.values()) {
                if (c.getDbid() != null && !c.getDeletedParents().isEmpty()) {
                    stmt.setInt(2, c.getDbid());
                    for (SnomedParent p : c.getDeletedParents()) {
                        stmt.setInt(3, p.getDbid());
                        stmt.setInt(4, p.getGroup());
                        i += stmt.executeUpdate();
                        if (i % (LOGSTEP / 100) == 0)
                            LOG.debug("Saved {} deprecated relationships...", i);
                    }
                }
            }
            LOG.info("Saved {} deprecated relationships", i);
        }
    }

    private void processRelationships(Integer snomedCodeScheme, Integer isA) throws SQLException {
        // Identify deprecated relationships
        LOG.info("Identifying deprecated relationships");
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
                if (c != null) {
                    // Get matching parents
                    List<SnomedParent> parents = c.getParents().stream().filter(p -> p.getConceptId().equals(parentCode) && group.equals(p.getGroup())).collect(Collectors.toList());

                    if (parents.isEmpty()) {
                        // Deleted
                        c.setDbid(rs.getInt("childDbid"));
                        c.addDeletedParent(new SnomedParent(parentCode, group).setDbid(rs.getInt("parentDbid")));
                        i++;
                        if (i % LOGSTEP == 0)
                            LOG.debug("Processed {} relationships...", i);
                    } else {
                        // Existing
                        c.getParents().removeAll(parents);
                    }
                }
            }
            LOG.info("Identified {} deprecated relationships", i);
        }
    }

    private void generateTCTTable(String folder) throws SQLException, IOException {
        loadCPOData();
        buildClosure();
        writeClosureData(folder);
    }

    private void loadCPOData() throws SQLException {
        System.out.println("Loading relationships...");

        String sql = "SELECT DISTINCT c.id AS concept, v.id AS value\n" +
            "FROM concept s\n" +
            "JOIN concept_property_object cpo ON cpo.property = s.dbid\n" +
            "JOIN concept c ON c.dbid = cpo.dbid\n" +
            "JOIN concept v ON v.dbid = cpo.value\n" +
            "LEFT JOIN cpo_delete d ON d.dbid = cpo.dbid AND d.property = cpo.property AND d.value = cpo.value AND d.group = cpo.group\n" +
            "WHERE s.id = 'SN_116680003'\n" +
            "ORDER BY concept";

        String previousConceptId = null;

        try (PreparedStatement stmt = conn.prepareStatement(sql);) {
            try (ResultSet rs = stmt.executeQuery()) {
                List<String> parents = null;
                while (rs.next()) {
                    String conceptId = rs.getString(1);
                    if (!conceptId.equals(previousConceptId)) {
                        parents = new ArrayList<>();
                        parentMap.put(conceptId, parents);
                    }

                    parents.add(rs.getString(2));

                    previousConceptId = conceptId;
                }
            }
        }

        System.out.println("Relationships loaded for " + parentMap.size() + " concepts");
    }

    private void buildClosure() {
        System.out.println("Generating closures");
        int c = 0;
        for (Map.Entry<String, List<String>> row : parentMap.entrySet()) {
            c++;
            if (c % 1000 == 0)
                System.out.print("\rGenerating concept closure " + c + "/" + parentMap.entrySet().size());
            generateClosure(row.getKey());
        }
        System.out.println();
    }

    private List<Closure> generateClosure(String id) {
        // Get the parents
        List<String> parents = parentMap.get(id);
        List<Closure> closures = new ArrayList<>();
        closureMap.put(id, closures);

        // Add self
        closures.add(new Closure().setParent(id).setLevel(-1));

        if (parents != null) {
            for (String parent : parents) {
                // Check do we have its closure?
                List<Closure> parentClosures = closureMap.get(parent);
                if (parentClosures == null) {
                    // No, generate it
                    parentClosures = generateClosure(parent);
                }

                // Add parents closure to this closure
                for (Closure parentClosure : parentClosures) {
                    // Check for existing already

                    if (closures.stream().noneMatch(c -> c.getParent().equals(parentClosure.getParent()))) {
                        closures.add(new Closure()
                            .setParent(parentClosure.getParent())
                            .setLevel(parentClosure.getLevel() + 1)
                        );
                    }
                }
            }
        }

        return closures;
    }

    private void writeClosureData(String outpath) throws IOException {
        System.out.println("Saving closures...");
        int c = 0;
        int t = 0;

        String outFile = outpath + "/closure_v1.csv";

        try (FileWriter fw = new FileWriter(outFile)) {
            for (Map.Entry<String, List<Closure>> entry : closureMap.entrySet()) {
                c++;
                if (c % 1000 == 0)
                    System.out.print("\rSaving concept closure " + c + "/" + closureMap.size());

                for (Closure closure : entry.getValue()) {
                    fw.write(entry.getKey() + "\t" + closure.getParent() + "\t" + closure.getLevel() + "\r\n");
                    t++;
                }
            }
        }
        System.out.println();
        System.out.println("Done (written " + t + " rows)");
    }

    private void importTCTTable(String outpath) throws SQLException {
        LOG.info("Importing closure");
        try (PreparedStatement stmt = conn.prepareStatement("DROP TABLE IF EXISTS concept_tct_meta;")) {
            stmt.executeUpdate();
        };

        try (PreparedStatement stmt = conn.prepareStatement("CREATE TABLE concept_tct_meta (\n" +
            "                               source VARCHAR(150) NOT NULL,\n" +
            "                               target VARCHAR(150) NOT NULL,\n" +
            "                               level INT NOT NULL\n" +
            ") ENGINE=InnoDB DEFAULT CHARSET=utf8;")) {
            stmt.executeUpdate();
        };

        try (PreparedStatement buildClosure = conn.prepareStatement("LOAD DATA LOCAL INFILE ?\n" +
            "    INTO TABLE concept_tct_meta\n" +
            "    FIELDS TERMINATED BY '\\t'\n" +
            "    LINES TERMINATED BY '\\r\\n'\n" +
            "    (source, target, level)\n" +
            ";")) {
            buildClosure.setString(1, outpath + "/closure_v1.csv");
            buildClosure.executeUpdate();
        }
    }
}
