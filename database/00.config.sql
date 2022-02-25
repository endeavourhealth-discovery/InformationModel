USE config;

INSERT INTO config
(app_id, config_id, config_data)
VALUES
('information-model', 'database', '{
   "url" : "jdbc:mysql://localhost:3306/information-model?useSSL=false",
   "username" : "xxxxxxxxxxx",
   "password" : "xxxxxxxxxxx"
}'),
('IMv2Receiver', 'database', '{
   "url" : "jdbc:mysql://localhost:3306/information-model?useSSL=false",
   "username" : "xxxxxxxxxxx",
   "password" : "xxxxxxxxxxx"
}'),
('information-model', 'api-internal', '{
	"auth-server-url" : "https://devauth.discoverydataservice.net/auth",
	"im-url" : "xxxxxxxxxx",
	"password" : "xxxxxxxxxxx",
	"realm" : "endeavour",
	"username" : "information-model-client"
}'),
('IMv1Sender','LastDate','"2021-05-31T21:24:14"'),
('IMv1Sender','S3Config','{
    "region": "eu-west-2",
    "bucket": "imv1sender",
    "accessKey": "xxxxxxxxxxx",
    "secretKey": "xxxxxxxxxxx"
}'),
('IMv2Receiver','S3Config','{
    "region": "eu-west-2",
    "bucket": "im-inbound-dev",
    "accessKey": "xxxxxxxxxxx",
    "secretKey": "xxxxxxxxxxx"
}');
