#!/bin/bash

echo "Executing initialize-users.sh"

while [[ ( "$(mongo --quiet --eval "rs.status().ok")" != "1" ) || ! ( "$(mongo --quiet --eval "rs.status().members[0].state")" == "1" || "$(mongo --quiet --eval "rs.status().members[1].state")" == "1" || "$(mongo --quiet --eval "rs.status().members[2].state")" == "1" ) ]]
do
    echo "MongoDB not ready for user creation, retrying in 5 seconds..."
    sleep 5
done

if [[ "$(mongo --quiet --eval "db.isMaster().ismaster")" == "true" ]]
then
echo "Primary node found, creating users"
mongo --eval "adminpass = '$MONGODB_ADMIN_PASSWORD'" --shell << EOL
use admin
db.createUser(
  {
    user: "usersAdmin",
    pwd: adminpass,
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)
db.auth("usersAdmin", adminpass)
db.getSiblingDB("admin").createUser(
  {
    "user" : "cmssw",
    "pwd" : "z82pf2@6EYfD.",
    roles: [ { "role" : "clusterAdmin", "db" : "admin" } ]
  }
)
EOL
else
    echo "Replica Set not primary..."
fi

{
    "base": "",
    "client_id": "cms-go",
    "client_secret": "99ce373d-1cb1-4302-9a39-e3d56917258d",
    "iam_client_id": "cmsweb-scim-client",
    "iam_client_secret": "estbL3Q6ZSeWyiyjCnR5KZkvvLbnX3mlepBIk2XQy70zJlGB9xKU9yxHk1uFr2a1cpsmS2XkwWf2vPVlHFnlkw",
    "iam_url": "https://cms-auth.web.cern.ch",
    "oauth_url": "https://auth.cern.ch/auth/realms/cern",
    "providers": ["https://auth.cern.ch/auth/realms/cern", "https://cms-auth.web.cern.ch", "https://wlcg.cloud.cnaf.infn.it"],
    "static": "/Users/vk/Work/Languages/Go/gopath/src/github.com/vkuznet/auth-proxy-server/static/hello",
    "server_cert": "/Users/vk/certificates/tls.crt",
    "server_key": "/Users/vk/certificates/tls.key",
    "redirect_url": "http://localhost/callback",
    "hmac": "/tmp/secrets/hmac",
    "document_root": "/tmp/secrets/www",
    "cric_url": "https://cms-cric.cern.ch/api/accounts/user/query/?json&preset=roles",
    "cric_file": "/data/cric.json",
    "cms_headers": true,
    "update_cric": 36000,
    "ingress": [
        {"path":"/", "service_url":"http://cms-couchdb-svc-couchdb:5984"}
    ],
    "rootCAs": "/etc/grid-security/certificates",
    "test_log_channel": true,
    "monit_type": "cmsweb-auth",
    "monit_producer": "cmsweb-auth",
    "log_file": "/tmp/access.log",
    "metrics_port": 9091,
    "verbose": 1,
    "port": 8443
}