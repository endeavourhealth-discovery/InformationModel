package org.endeavourhealth.im.client;

import com.fasterxml.jackson.databind.JsonNode;
import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.common.config.ConfigManager;
import org.endeavourhealth.common.security.keycloak.client.KeycloakClient;


import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Response;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class IMClient {
    private static final String base = "/client";
    private static JsonNode config;
    private static KeycloakClient kcClient;

    public static Integer getConceptIdForSchemeCode(String scheme, String code) throws Exception {
        return getConceptIdForSchemeCode(scheme, code, false, null);
    }

    public static Integer getConceptIdForSchemeCode(String scheme, String code, Boolean autoCreate, String term) throws Exception {
        Map<String, String> params = new HashMap<>();
        params.put("scheme", scheme);
        params.put("code", code);
        params.put("autoCreate", autoCreate.toString());
        params.put("term", term);

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
        return getConceptIdForTypeTerm(type, term, false);
    }

    public static Integer getConceptIdForTypeTerm(String type, String term, Boolean autoCreate) throws Exception {
        Map<String, String> params = new HashMap<>();
        params.put("type", type);
        params.put("term", term);
        params.put("autoCreate", autoCreate.toString());

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

    private static Response get(String path, Map<String, String> params) throws IOException {
        if (config == null)
            config = ObjectMapperPool.getInstance().readTree(ConfigManager.getConfiguration("api-internal", "information-model"));

        if (kcClient == null)
            kcClient = new KeycloakClient(
              config.get("auth-server-url").asText(),
              config.get("realm").asText(),
              config.get("username").asText(),
              config.get("password").asText(),
              "information-model");

        Client client = ClientBuilder.newClient();
        WebTarget target = client.target(config.get("im-url").asText()).path(path);

        if (params != null && !params.isEmpty()) {
            for (Map.Entry<String, String> entry: params.entrySet()) {
                target = target.queryParam(entry.getKey(), entry.getValue());
            }
        }

        return target
            .request()
            .header("Authorization", "Bearer " + kcClient.getToken().getToken())
            .get();
    }
}
