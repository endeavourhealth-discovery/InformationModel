package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.SearchResult;
import org.endeavourhealth.im.models.Status;

import java.util.List;

public interface InformationModelDAL {
    int getOrCreateDocumentDBId(String url) throws Exception;

    Integer getConceptDbid(String id) throws Exception;
    int insertConcept(int docId, String id) throws Exception;
    void insertConceptPropertyData(int dbid, int property, String value) throws Exception;
    void insertConceptPropertyData(int dbid, Integer group, int property, String value) throws Exception;
    void insertConceptPropertyValue(int dbid, int propertyId, int valueId) throws Exception;
    void insertConceptPropertyValue(int dbid, Integer group, int propertyId, int valueId) throws Exception;

    Integer getConceptIdForSchemeCode(String scheme, String code) throws Exception;
    Integer getMappedCoreConceptIdForSchemeCode(String scheme, String code) throws Exception;
    Integer getConceptIdForTypeTerm(String type, String term) throws Exception;
    Integer getMappedCoreConceptIdForTypeTerm(String type, String term) throws Exception;

    String getCodeForConceptId(Integer dbid) throws Exception;









    void insertConcept(String json, Status status) throws Exception;
    void updateConcept(String id, String json, Status status) throws Exception;

    SearchResult mru() throws Exception;
    SearchResult search(String text, Integer size, Integer page, String relationship, String target) throws Exception;

    String getConceptJSON(int dbid) throws Exception;
    String getConceptJSON(String id) throws Exception;
    String getConceptName(String id) throws Exception;

    List<String> getDocuments() throws Exception;

    String validateIds(List<String> ids) throws Exception;

    boolean generateRuntimeFiles() throws Exception;
    void loadRuntimeFiles() throws Exception;


}
