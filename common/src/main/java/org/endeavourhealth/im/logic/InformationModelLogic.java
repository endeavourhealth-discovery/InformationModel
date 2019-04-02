package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.InformationModelDAL;
import org.endeavourhealth.im.models.Concept;
import org.endeavourhealth.im.models.SearchResult;

import java.util.List;

public class InformationModelLogic {
    private static boolean EXPORTING = false;
    private static boolean LOADING = false;

    public void generateRuntimeFiles(InformationModelDAL dal) throws Exception {
        if (EXPORTING)
            throw new IllegalStateException("Runtime file generation already in progress");

        EXPORTING = true;

        try {
            dal.generateRuntimeFiles();
        } finally {
            EXPORTING = false;
        }
    }

    public void loadRuntimeFiles(InformationModelDAL dal) throws Exception {
        if (LOADING)
            throw new IllegalStateException("Runtime file generation already in progress");

        LOADING = true;

        try {
            dal.loadRuntimeFiles();
        } finally {
            LOADING = false;
        }
    }
}
