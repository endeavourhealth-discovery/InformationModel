package org.endeavourhealth.im.client;


import org.endeavourhealth.common.config.ConfigManager;
import org.endeavourhealth.im.models.Concept;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Response;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class IMClient {
    public static Concept getConcept(Long scheme, String code) throws IOException {
        Map<String, String> params = new HashMap<>();
        params.put("scheme", scheme.toString());
        params.put("code", code);

        Response response = get("/api/Map", params);

        if (response.getStatus() == 200)
            return response.readEntity(Concept.class);
        else
            throw new IOException(response.readEntity(String.class));
    }

    public static Long getConceptId(Long scheme, String code) throws IOException {
        return getConcept(scheme, code).getId();
    }

    public static Long getConceptId(String context) throws IOException {
        return getOrCreateConcept(context, false);
    }

    public static Long getOrCreateConceptId(String context) throws IOException {
        return getOrCreateConcept(context, true);
    }

    private static Long getOrCreateConcept(String context, Boolean createMissing) throws IOException {
        Map<String, String> params = new HashMap<>();
        params.put("context", context);
        params.put("createMissing", createMissing.toString());

        Response response = get("/api/Concept/Context", params);

        if (response.getStatus() == 200)
            return (response.readEntity(Concept.class)).getId();
        else
            throw new IOException(response.readEntity(String.class));
    }

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
