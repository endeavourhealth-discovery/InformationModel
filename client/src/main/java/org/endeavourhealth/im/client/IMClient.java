package org.endeavourhealth.im.client;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.fasterxml.jackson.databind.JsonNode;
import org.apache.http.Header;
import org.endeavourhealth.common.security.keycloak.client.KeycloakClient;
import org.endeavourhealth.im.common.models.*;
import org.endeavourhealth.common.config.ConfigManager;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;


public class IMClient {
/*    public static boolean isMessageValid(Message message) {
        Response response = post("/Message/Valid", message);

        return (Boolean)response.getEntity();
    }

    public static Term getTerm(String organisation, String context, String system, String code, String termText) throws IOException {
        Map<String, String> params = new HashMap<String, String>();
        params.put("organisation", organisation);
        params.put("context", context);
        params.put("system", system);
        params.put("code", code);
        params.put("term", termText);

        Response response = get("/Term", params);

        if (response.getStatus() == 200)
            return response.readEntity(Term.class);
        else
            throw new IOException(response.readEntity(String.class));
    }

    private static <T> Response post(String path, T entity) {
        String address = ConfigManager.getConfiguration("information-model-address");

        Client client = ClientBuilder.newClient();
        return client
            .target(address)
            .path(path)
            .request()
            .post(Entity.entity(entity, MediaType.APPLICATION_JSON));
    }

    private static Response get(String path) throws IOException {
        return get(path, null);
    }

    private static Response get(String path, Map<String, String> params) throws IOException {
        String address = ConfigManager.getConfiguration("information-model-address");

        Client client = ClientBuilder.newClient();
        WebTarget target = client.target(address).path(path);

        if (params != null && !params.isEmpty()) {
            for (Map.Entry<String, String> entry: params.entrySet()) {
                target = target.queryParam(entry.getKey(), entry.getValue());
            }
        }

        Header keycloakAuth = getKeycloakAuthorization();

        return target
            .request()
            .header(keycloakAuth.getName(), keycloakAuth.getValue())
            .get();
    }

    private static Header getKeycloakAuthorization() throws IOException {
        JsonNode keycloakConfig = ConfigManager.getConfigurationAsJson("information-model-keycloak");

        KeycloakClient.init(
                keycloakConfig.get("url").asText(),
                keycloakConfig.get("realm").asText(),
                keycloakConfig.get("username").asText(),
                keycloakConfig.get("password").asText(),
                keycloakConfig.get("client").asText()
        );

        return KeycloakClient.instance().getAuthorizationHeader();
    }*/
}
