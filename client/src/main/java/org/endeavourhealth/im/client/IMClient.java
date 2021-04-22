package org.endeavourhealth.im.client;

import com.fasterxml.jackson.databind.JsonNode;
import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.common.config.ConfigManager;
import org.endeavourhealth.common.security.keycloak.client.KeycloakClient;
import org.endeavourhealth.common.utility.MetricsHelper;
import org.endeavourhealth.common.utility.MetricsTimer;
import org.endeavourhealth.im.models.mapping.*;
import org.glassfish.jersey.uri.UriComponent;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class IMClient {
    private static final String base = "/client";
    private static final String baseV2 = "/api/runtime";
    private static JsonNode kcConfig;
    private static String imUrl;
    private static String imV2Url;
    private static KeycloakClient kcClient;

    // V1 / Code
    public static String getConceptIdForSchemeCode(String scheme, String code) throws Exception {
        try (MetricsTimer timer =MetricsHelper.recordTime("IMClient.getMappedCoreCodeForSchemeCode")) {
            Map<String, String> params = new HashMap<>();
            params.put("scheme", scheme);
            params.put("code", code);

            Response response = get(getImUrl(), base + "/Concept/Id", params);

            if (response.getStatus() == 200) {
                String result = response.readEntity(String.class);
                return result.isEmpty() ? null : result;
            }
            else
                throw new IOException(response.readEntity(String.class));
        }
    }

    public static String getMappedCoreCodeForSchemeCode(String scheme, String code) throws Exception {
        return getMappedCoreCodeForSchemeCode(scheme, code, false);
    }

    public static String getMappedCoreCodeForSchemeCode(String scheme, String code, boolean snomedOnly) throws Exception {
        try (MetricsTimer timer =MetricsHelper.recordTime("IMClient.getMappedCoreCodeForSchemeCode")) {
            Map<String, String> params = new HashMap<>();
            params.put("scheme", scheme);
            params.put("code", code);
            params.put("snomedOnly", ((Boolean)snomedOnly).toString());

            Response response = get(getImUrl(), base + "/Concept/Core/Code", params);

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

            Response response = get(getImUrl(), base + "/Term/Code", params);

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

            Response response = get(getImUrl(), base + "/Concept", params);

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

            Response response = get(getImUrl(), base + "/Concept/Core", params);

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

            Response response = get(getImUrl(), base + "/Concept/Code", params);

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

            Response response = get(getImUrl(), base + "/Term", params);

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

            Response response = get(getImUrl(), base + "/Term/Core", params);

            if (response.getStatus() == 200)
                return response.readEntity(Integer.class);
            else
                throw new IOException(response.readEntity(String.class));
        }
    }

    // Mapping API

    public static MapResponse getMapProperty(MapColumnRequest mapColumnRequest) throws Exception {
        try (MetricsTimer timer =MetricsHelper.recordTime("IMClient.getMapProperty")) {
            MapRequest request = new MapRequest()
                .setMapColumnRequest(mapColumnRequest);

            Response response = post(getImUrl(), base + "/Mapping", request);

            if (response.getStatus() == 200)
                return response.readEntity(MapResponse.class);
            else
                throw new IOException(response.readEntity(String.class));
        }
    }

    public static MapResponse getMapPropertyValue(MapColumnValueRequest mapColumnValueRequest) throws Exception {
        try (MetricsTimer timer = MetricsHelper.recordTime("IMClient.getMapPropertyValue")) {
            MapRequest request = new MapRequest()
                .setMapColumnValueRequest(mapColumnValueRequest);

            Response response = post(getImUrl(), base + "/Mapping", request);

            if (response.getStatus() == 200)
                return response.readEntity(MapResponse.class);
            else
                throw new IOException(response.readEntity(String.class));
        }
    }

    // Valueset API
    public static Boolean isSchemeCodeInVSet(String scheme, String code, String vSet) throws Exception {
        try (MetricsTimer timer =MetricsHelper.recordTime("IMClient.isSchemeCodeInVSet")) {
            Map<String, String> params = new HashMap<>();
            params.put("code", code);
            params.put("scheme", scheme);
            params.put("vSet", vSet);

            Response response = get(getImV2Url(), baseV2 + "/Concept/isValueSetMember", params);

            if (response.getStatus() == 200)
                return response.readEntity(Boolean.class);
            else
                throw new IOException(response.readEntity(String.class));
        }
    }

    // Private/common/helper methods
    private static Response get(String url, String path, Map<String, String> params) throws IOException {
        Client client = ClientBuilder.newClient();
        WebTarget target = client.target(url).path(path);

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
            .header("Authorization", "Bearer " + getKcClient().getToken().getToken())
            .get();
    }

    private static Response post(String url, String path, Object body) throws IOException {
        Client client = ClientBuilder.newClient();
        WebTarget target = client.target(url).path(path);

        return target
            .request()
            .header("Authorization", "Bearer " + getKcClient().getToken().getToken())
            .post(Entity.entity(body, MediaType.APPLICATION_JSON));
    }

    private static String getImUrl() {
        if (imUrl == null) {
            imUrl = ConfigManager.getConfiguration("api");
            if (imUrl == null)
                throw new IllegalStateException("information-model/api configuration not found!");

        }

        return imUrl;
    }

    private static String getImV2Url() {
        if (imV2Url == null) {
            imV2Url = ConfigManager.getConfiguration("apiv2");
            if (imV2Url == null)
                throw new IllegalStateException("information-model v2 /api configuration not found!");

        }

        return imV2Url;
    }

    private static JsonNode getKcConfig() throws IOException {
        if (kcConfig == null) {
            kcConfig = ObjectMapperPool.getInstance().readTree(ConfigManager.getConfiguration("api-internal", "information-model"));
            if (kcConfig == null)
                throw new IllegalStateException("information-model/api-internal configuration not found!");
        }

        return kcConfig;
    }

    private static KeycloakClient getKcClient() throws IOException {
        if (kcClient == null)
            kcClient = new KeycloakClient(
                getKcConfig().get("auth-server-url").asText(),
                getKcConfig().get("realm").asText(),
                getKcConfig().get("username").asText(),
                getKcConfig().get("password").asText(),
                "information-model");

        return kcClient;
    }
}
