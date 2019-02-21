package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.Concept;

import java.util.List;

public interface InformationModelDAL {
    void saveDocument(String json) throws Exception;

    void saveConcept(String json) throws Exception;

    List<Concept> mru() throws Exception;
    List<Concept> search(String text) throws Exception;
    String get(String id) throws Exception;
    String getName(String id) throws Exception;

    List<String> getDocuments() throws Exception;

    String validateIds(List<String> ids) throws Exception;
}
