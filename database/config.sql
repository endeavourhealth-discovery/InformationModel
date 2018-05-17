USE config;

INSERT INTO config
(app_id, config_id, config_data)
VALUES
('information-model', 'keycloak', '{
   "realm": "endeavour",
   "realm-public-key": "",
   "auth-server-url": "https://devauth.endeavourhealth.net/auth",
   "ssl-required": "external",
   "resource": "eds-info-manager",
   "public-client": true
 }'),

('information-model', 'database', '{
   "url" : "jdbc:mysql://localhost:3306/information_model?useSSL=false",
   "username" : "root",
   "password" : ""
}'),

('information-model', 'snomed', '{
    "url" : "jdbc:mysql://localhost:3306/coding?useSSL=false",
    "username" : "root",
    "password" : ""
 }'),

('global', 'information-model-address', 'http://127.0.0.1:8080/information-model/api'),

('global', 'information-model-keycloak', '{
	"url": "https://devauth.endeavourhealth.net/auth",
	"realm": "endeavour",
	"username": "",
	"password": "",
	"client": "eds-info-manager"
}')