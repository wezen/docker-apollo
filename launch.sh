#!/usr/bin/env bash
service postgresql start 

echo "Starting tomcat with $CATALINA_HOME"

$CATALINA_HOME/bin/startup.sh 

#!/bin/bash
until pg_isready; do
	echo -n "."
	sleep 1;
done

echo "Postgres is up, loading chado"
su postgres -c 'createdb apollo'
su postgres -c 'createdb chado'
su postgres -c 'psql -f /apollo/user.sql'

su postgres -c 'PGPASSWORD=apollo psql -U apollo -h 127.0.0.1 chado -f /chado.sql'

# https://tomcat.apache.org/tomcat-8.0-doc/config/context.html#Naming
export CATALINA_HOME=/usr/local/tomcat/
FIXED_CTX=$(echo "${CONTEXT_PATH}" | sed 's|/|#|g')
WAR_FILE=${CATALINA_HOME}/webapps/${FIXED_CTX}.war

cp ${CATALINA_HOME}/apollo.war ${WAR_FILE}
tail -f ${CATALINA_HOME}/logs/catalina.out 
