package org.endeavourhealth.im.api.endpoints;

import io.swagger.annotations.*;

@SwaggerDefinition(
    info = @Info(
        description = "Query and manipulate the Information Model",
        version = "V1.0.0",
        title = "The Information Model API",
        termsOfService = "https://discoverdataservice.net/terms.html",
        contact = @Contact(
            name = "Support",
            email = "Support@discoverydataservice.net",
            url = "https://discoverydataservice.net"
        ),
        license = @License(
            name = "Apache 2.0",
            url = "http://www.apache.org/licenses/LICENSE-2.0"
        )
    ),
    consumes = {"application/json"},
    produces = {"application/json"},
    schemes = {SwaggerDefinition.Scheme.HTTPS},
    externalDocs = @ExternalDocs(value = "Information model", url = "https://discoverydataservice.net/informationmodel.html"),
    tags = {
        @Tag(name = "Concept", description = "API for all calls relating to Concepts"),
        @Tag(name = "Map", description = "API for all calls relating to Maps"),
        @Tag(name = "SchemaMappings", description = "API for all calls relating to schema mappings"),
        @Tag(name = "Task", description = "API for all calls relating to Tasks"),
        @Tag(name = "Term", description = "API for all calls relating to Terms"),
        @Tag(name = "View", description = "API for all calls relating to Views")
    }
)
public interface SwaggerConfig {
}
