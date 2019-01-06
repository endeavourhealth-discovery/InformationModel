package org.endeavourhealth.im.client;


import org.endeavourhealth.im.dal.MapJDBCDAL;
import org.endeavourhealth.im.logic.ConceptLogic;
import org.endeavourhealth.im.models.Concept;


public class IMClient {
    public static Concept getConcept(Long scheme, String code) throws Exception {
        return new MapJDBCDAL().getByCodeAndScheme(code, scheme);
//        Map<String, String> params = new HashMap<>();
//        params.put("scheme", scheme.toString());
//        params.put("code", code);
//
//        Response response = get("/api/Map", params);
//
//        if (response.getStatus() == 200)
//            return response.readEntity(Concept.class);
//        else
//            throw new IOException(response.readEntity(String.class));
    }

    public static Long getConceptId(Long scheme, String code) throws Exception {
        return getConcept(scheme, code).getId();
    }

    public static Long getConceptId(String context) throws Exception {
        return getOrCreateConcept(context, false);
    }

    public static Long getOrCreateConceptId(String context) throws Exception {
        return getOrCreateConcept(context, true);
    }

    private static Long getOrCreateConcept(String context, Boolean createMissing) throws Exception {
        return new ConceptLogic().get(context, createMissing).getId();
//        Map<String, String> params = new HashMap<>();
//        params.put("context", context);
//        params.put("createMissing", createMissing.toString());
//
//        Response response = get("/api/Concept/Context", params);
//
//        if (response.getStatus() == 200)
//            return (response.readEntity(Concept.class)).getId();
//        else
//            throw new IOException(response.readEntity(String.class));
    }

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
        String address = ConfigManager.getConfiguration("api", "information-model");

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
    } */
}
