package org.endeavourhealth.im.client;

import com.fasterxml.jackson.databind.JsonNode;
import io.swagger.annotations.ApiParam;
import org.bouncycastle.jcajce.provider.asymmetric.ec.KeyFactorySpi;
import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.common.config.ConfigManager;
import org.endeavourhealth.common.security.keycloak.client.KeycloakClient;
import org.endeavourhealth.common.utility.MetricsHelper;
import org.endeavourhealth.common.utility.MetricsTimer;
import org.glassfish.jersey.uri.UriComponent;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Response;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class IMClient {
    private static final String base = "/client";
    private static JsonNode kcConfig;
    private static String imUrl;
    private static KeycloakClient kcClient;

    // V1 / Code
    public static String getMappedCoreCodeForSchemeCode(String scheme, String code) throws Exception {
        return getMappedCoreCodeForSchemeCode(scheme, code, false);
    }

    public static String getMappedCoreCodeForSchemeCode(String scheme, String code, boolean snomedOnly) throws Exception {
        try (MetricsTimer timer =MetricsHelper.recordTime("IMClient.getMappedCoreCodeForSchemeCode")) {
            Map<String, String> params = new HashMap<>();
            params.put("scheme", scheme);
            params.put("code", code);
            params.put("snomedOnly", ((Boolean)snomedOnly).toString());

            Response response = get(base + "/Concept/Core/Code", params);

            if (response.getStatus() == 200) {
                String result = response.readEntity(String.class);
                return result.isEmpty() ? null : result;
            }
            else
                throw new IOException(response.readEntity(String.class));
        }
    }

    public static String getCodeForTypeTerm(String scheme, String context, String term) throws Exception  {
        return getCodeForTypeTerm(scheme, context, term, false);
    }

    public static String getCodeForTypeTerm(String scheme, String context, String term, boolean autoCreate) throws Exception  {
        try (MetricsTimer timer =MetricsHelper.recordTime("IMClient.getCodeForTypeTerm")) {
            Map<String, String> params = new HashMap<>();
            params.put("scheme", scheme);
            params.put("context", context);
            params.put("term", term);
            params.put("autoCreate", ((Boolean)autoCreate).toString());

            Response response = get(base + "/Term/Code", params);

            if (response.getStatus() == 200) {
                String result = response.readEntity(String.class);
                return result.isEmpty() ? null : result;
            }
            else
                throw new IOException(response.readEntity(String.class));
        }
    }

    // V2 / ConceptDbid
    public static Integer getConceptDbidForSchemeCode(String scheme, String code) throws Exception {
        return getConceptDbidForSchemeCode(scheme, code, null, false);
    }

    public static Integer getConceptDbidForSchemeCode(String scheme, String code, String term, boolean autoCreate) throws Exception {
        try (MetricsTimer timer =MetricsHelper.recordTime("IMClient.getConceptIdForSchemeCode")) {
            Map<String, String> params = new HashMap<>();
            params.put("scheme", scheme);
            params.put("code", code);
            params.put("autoCreate", ((Boolean)autoCreate).toString());
            params.put("term", term);

            Response response = get(base + "/Concept", params);

            if (response.getStatus() == 200)
                return response.readEntity(Integer.class);
            else
                throw new IOException(response.readEntity(String.class));
        }
    }

    public static Integer getMappedCoreConceptDbidForSchemeCode(String scheme, String code) throws Exception {
        try (MetricsTimer timer =MetricsHelper.recordTime("IMClient.getMappedCoreConceptIdForSchemeCode")) {
            Map<String, String> params = new HashMap<>();
            params.put("scheme", scheme);
            params.put("code", code);

            Response response = get(base + "/Concept/Core", params);

            if (response.getStatus() == 200)
                return response.readEntity(Integer.class);
            else
                throw new IOException(response.readEntity(String.class));
        }
    }

    public static String getCodeForConceptDbid(Integer conceptDbid) throws Exception {
        try (MetricsTimer timer =MetricsHelper.recordTime("IMClient.getCodeForConceptId")) {
            Map<String, String> params = new HashMap<>();
            params.put("dbid", conceptDbid.toString());

            Response response = get(base + "/Concept/Code", params);

            if (response.getStatus() == 200)
                return response.readEntity(String.class);
            else
                throw new IOException(response.readEntity(String.class));
        }
    }

    public static Integer getConceptDbidForTypeTerm(String type, String term) throws Exception {
        return getConceptDbidForTypeTerm(type, term, false);
    }

    public static Integer getConceptDbidForTypeTerm(String type, String term, boolean autoCreate) throws Exception {
        try (MetricsTimer timer =MetricsHelper.recordTime("IMClient.getConceptIdForTypeTerm")) {
            Map<String, String> params = new HashMap<>();
            params.put("type", type);
            params.put("term", term);
            params.put("autoCreate", ((Boolean)autoCreate).toString());

            Response response = get(base + "/Term", params);

            if (response.getStatus() == 200)
                return response.readEntity(Integer.class);
            else
                throw new IOException(response.readEntity(String.class));
        }
    }

    public static Integer getMappedCoreConceptDbidForTypeTerm(String type, String term) throws Exception {
        try (MetricsTimer timer =MetricsHelper.recordTime("IMClient.getConceptIdForTypeTerm")) {
            Map<String, String> params = new HashMap<>();
            params.put("type", type);
            params.put("term", term);

            Response response = get(base + "/Term/Core", params);

            if (response.getStatus() == 200)
                return response.readEntity(Integer.class);
            else
                throw new IOException(response.readEntity(String.class));
        }
    }

    private static Response get(String path, Map<String, String> params) throws IOException {
        if (kcConfig == null) {
            kcConfig = ObjectMapperPool.getInstance().readTree(ConfigManager.getConfiguration("api-internal", "information-model"));
            if (kcConfig == null)
                throw new IllegalStateException("information-model/api-internal configuration not found!");
        }

        if (kcClient == null)
            kcClient = new KeycloakClient(
              kcConfig.get("auth-server-url").asText(),
              kcConfig.get("realm").asText(),
              kcConfig.get("username").asText(),
              kcConfig.get("password").asText(),
              "information-model");

        if (imUrl == null) {
            imUrl = ConfigManager.getConfiguration("api");
            if (imUrl == null)
                throw new IllegalStateException("information-model/api configuration not found!");

        }


        Client client = ClientBuilder.newClient();
        WebTarget target = client.target(imUrl).path(path);

        if (params != null && !params.isEmpty()) {
            for (Map.Entry<String, String> entry: params.entrySet()) {
                if (entry.getValue() != null) {
                    String encoded = UriComponent.encode(entry.getValue(), UriComponent.Type.QUERY_PARAM_SPACE_ENCODED);
                    target = target.queryParam(entry.getKey(), encoded);
                }
            }
        }


        return target
            .request()
            .header("Authorization", "Bearer " + kcClient.getToken().getToken())
            .get();
    }
}
