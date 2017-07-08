#!/bin/sh

# Deploy WAR file
# https://tomcat.apache.org/tomcat-8.0-doc/config/context.html#Naming
FIXED_CTX=$(echo "${CONTEXT_PATH}" | sed 's|/|#|g')
WAR_FILE=${CATALINA_HOME}/webapps/${FIXED_CTX}.war
rm -rf ${CATALINA_HOME}/webapps/*
cp /apollo/apollo.war ${WAR_FILE}

# Start the (pre-filled) database
sudo -u postgres pg_ctl start -D /var/lib/postgres/data;
while ! pg_isready; do sleep 1; done;

echo 'export PGUSER=postgres
export PGPASSWORD=postgres
export PGHOSTADDR=127.0.0.1
export PGPORT=5432
export WEBAPOLLO_DB_USERNAME=postgres
export WEBAPOLLO_DB_PASSWORD=postgres
export WEBAPOLLO_DB_URI="jdbc:postgresql://127.0.0.1:5432/apollo"
export WEBAPOLLO_CHADO_DB_USERNAME=postgres
export WEBAPOLLO_CHADO_DB_PASSWORD=postgres
export WEBAPOLLO_CHADO_DB_URI="jdbc:postgresql://127.0.0.1:5432/chado"
' > $CATALINA_HOME/bin/setenv.sh
chmod +x $CATALINA_HOME/bin/setenv.sh;

catalina.sh run
