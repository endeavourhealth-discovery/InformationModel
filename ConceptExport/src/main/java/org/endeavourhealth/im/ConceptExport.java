package org.endeavourhealth.im;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;

public class ConceptExport {
    private static final Logger LOG = LoggerFactory.getLogger(ConceptExport.class);


    public static void main(String[] argv) throws Exception {
        if (argv.length != 1) {
            LOG.error("Usage: ConceptExport <folder>");
            System.exit(-1);
        }

        String conceptDir = argv[0];
        if (!conceptDir.endsWith("/"))
            conceptDir += "/";

        LOG.info("Exporting new concepts from IM1");
        LOG.debug("Working directory [{}]", conceptDir);

        cleanupGit(conceptDir);

        int deltaRows = 0;

        deltaRows += new NewConceptExporter().execute("concepts.txt", "concepts.zip", conceptDir + "IMv1/");
        deltaRows += new EmisMapExporter().execute("emis_codes.txt", "emis_codes.zip", conceptDir + "EMIS/");
        deltaRows += new EmisDrugExporter().execute("EMISDrugs.txt", "EMISDrugs.zip", conceptDir + "EMIS/");
        deltaRows += new TPPConceptExporter().execute("tpp_ctv3_lookup_2.csv", "tpp_ctv3_lookup_2.zip", conceptDir + "TPP_Vision_Maps/");
        deltaRows += new TPPMapExporter().execute("tpp_ctv3_to_snomed.csv", "tpp_ctv3_to_snomed.zip", conceptDir + "TPP_Vision_Maps/");

        if (deltaRows > 0) {
            LOG.info("Total {} new rows", deltaRows);
            pushChangesToGit(conceptDir);
        }
        LOG.info("Finished");
    }

    private static void cleanupGit(String conceptDir) throws IOException, InterruptedException {
        LOG.info("Cleaning up local GIT repository...");
        // Rollback any local/pending in case of failed previous run
        git("fetch", conceptDir);
        git("reset --hard origin/main", conceptDir);
    }

    private static void pushChangesToGit(String conceptDir) throws IOException, InterruptedException {
        LOG.info("Pushing to GIT");

        // Stage changed files
        git("add .", conceptDir);

        // Commit local
        git("commit -m \"ConceptExport\"", conceptDir);

        // Push remote
        git("push -u origin main", conceptDir);
    }

    private static String git(String command, String conceptDir) throws IOException, InterruptedException {
        String gitCmd = "git " + command;
        LOG.debug("Command [{}]", gitCmd);

        Runtime rt = Runtime.getRuntime();
        Process proc = rt.exec(gitCmd, null, new File(conceptDir));
        proc.waitFor();

        String output = getStreamAsString(proc.getInputStream());
        if (!output.isEmpty())
            LOG.debug(output);

        String error = getStreamAsString(proc.getErrorStream());
        if (!error.isEmpty())
            LOG.error(error);

        if (proc.exitValue() != 0) {
            LOG.error("Git command failed - {}", proc.exitValue());
            System.exit(-1);
        }

        return output;
    }

    private static String getStreamAsString(InputStream is) throws IOException {
        byte[] b=new byte[is.available()];
        is.read(b,0,b.length);
        return new String(b);
    }
}
