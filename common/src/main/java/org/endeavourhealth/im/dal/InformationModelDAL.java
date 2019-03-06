package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.Concept;
import org.endeavourhealth.im.models.Status;

import java.util.List;

public interface InformationModelDAL {
    void updateDocument(int dbid, String json) throws Exception;
    int insertDocument(String json) throws Exception;

    void insertConcept(String json, Status status) throws Exception;
    void updateConcept(String id, String json, Status status) throws Exception;

    List<Concept> mru() throws Exception;
    List<Concept> search(String text) throws Exception;
    String getConceptJSON(String id) throws Exception;
    String getConceptName(String id) throws Exception;

    List<String> getDocuments() throws Exception;

    String validateIds(List<String> ids) throws Exception;

    boolean generateRuntimeFiles() throws Exception;
    void loadRuntimeFiles() throws Exception;
}
