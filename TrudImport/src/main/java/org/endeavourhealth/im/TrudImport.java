package org.endeavourhealth.im;

import org.endeavourhealth.common.config.ConfigManager;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

public class TrudImport {
    public static void main(String argv[]) throws Exception {
        System.out.println("TRUD Import util");

        ConfigManager.Initialize("information-model");

        if (argv.length != 1) {
            System.out.println("Use: TrudImport <path to extracted TRUD files>");
            System.exit(1);
        }

        LocalDateTime start = LocalDateTime.now();
        System.out.println("Starting import : " + start.toString());

        Importer importer = new Importer();

        importer.execute(argv[0]);

        LocalDateTime end = LocalDateTime.now();
        System.out.println("Import complete : " + end.toString());
        Duration time = Duration.between(start, end);
        System.out.println("Import duration : " + humanReadableFormat(time));
    }

    public static String humanReadableFormat(Duration duration) {
        return duration.toString()
            .substring(2)
            .replaceAll("(\\d[HMS])(?!$)", "$1 ")
            .toLowerCase();
    }
}