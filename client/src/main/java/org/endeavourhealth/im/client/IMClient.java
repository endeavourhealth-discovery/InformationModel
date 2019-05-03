package org.endeavourhealth.im.client;

import org.endeavourhealth.common.config.ConfigManager;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Response;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class IMClient {
    // private static InformationModelDAL db = new InformationModelJDBCDAL();
    private static final String base = "/public/Client";

    public static Integer getConceptIdForSchemeCode(String scheme, String code) throws Exception {

        Map<String, String> params = new HashMap<>();
        params.put("scheme", scheme);
        params.put("code", code);

        Response response = get(base + "/Concept", params);

        if (response.getStatus() == 200)
            return response.readEntity(Integer.class);
        else
            throw new IOException(response.readEntity(String.class));
    }

    public static Integer getMappedCoreConceptIdForSchemeCode(String scheme, String code) throws Exception {
        Map<String, String> params = new HashMap<>();
        params.put("scheme", scheme);
        params.put("code", code);

        Response response = get(base + "/Concept/Core", params);

        if (response.getStatus() == 200)
            return response.readEntity(Integer.class);
        else
            throw new IOException(response.readEntity(String.class));
    }

    public static String getCodeForConceptId(Integer conceptId) throws Exception {
        Map<String, String> params = new HashMap<>();
        params.put("dbid", conceptId.toString());

        Response response = get(base + "/Concept/Code", params);

        if (response.getStatus() == 200)
            return response.readEntity(String.class);
        else
            throw new IOException(response.readEntity(String.class));
    }

    public static Integer getConceptIdForTypeTerm(String type, String term) throws Exception {
        Map<String, String> params = new HashMap<>();
        params.put("type", type);
        params.put("term", term);

        Response response = get(base + "/Term", params);

        if (response.getStatus() == 200)
            return response.readEntity(Integer.class);
        else
            throw new IOException(response.readEntity(String.class));

    }

    public static Integer getMappedCoreConceptIdForTypeTerm(String type, String term) throws Exception {
        Map<String, String> params = new HashMap<>();
        params.put("type", type);
        params.put("term", term);

        Response response = get(base + "/Term/Core", params);

        if (response.getStatus() == 200)
            return response.readEntity(Integer.class);
        else
            throw new IOException(response.readEntity(String.class));

    }

/*
    public static Integer getMappedConceptIdForTypeTerm(String type, String term) throws Exception {
        return db.getMappedConceptIdForTypeTerm(type, term);
    }*/

    private static Response get(String path, Map<String, String> params) {
        String address = ConfigManager.getConfiguration("api-internal", "information-model");

        Client client = ClientBuilder.newClient();
        WebTarget target = client.target(address).path(path);

        if (params != null && !params.isEmpty()) {
            for (Map.Entry<String, String> entry: params.entrySet()) {
                target = target.queryParam(entry.getKey(), entry.getValue());
            }
        }

        return target
            .request()
            .get();
    }
}
