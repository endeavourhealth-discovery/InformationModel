USE config;

INSERT INTO config
(app_id, config_id, config_data)
VALUES
('information-model', 'database', '{
   "url" : "jdbc:mysql://localhost:3306/information-model?useSSL=false",
   "username" : "root",
   "password" : ""
}'),
('information-model', 'api-internal', '{
	"auth-server-url" : "https://devauth.discoverydataservice.net/auth",
	"im-url" : "xxxxxxxxxx",
	"password" : "xxxxxxxxxxx",
	"realm" : "endeavour",
	"username" : "information-model-client"
}');
