package org.endeavourhealth.informationmodel;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.sql.SQLException;

public class TRUDImport {
    private static final Logger LOG = LoggerFactory.getLogger(TRUDImport.class);

    public static void main(String[] argv) throws SQLException, IOException {
        LOG.info("IM TRUD Import tool");

        if (argv.length != 2) {
            LOG.error("Use: TRUDImport <folder> <jdbc connection string>");
            System.exit(-1);
        }

        new Importer(argv[1]).execute(argv[0]);
    }
}
