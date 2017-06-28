#!/usr/bin/env bash
echo "Starting tomcat with $CATALINA_HOME"
$CATALINA_HOME/bin/startup.sh 

# https://tomcat.apache.org/tomcat-8.0-doc/config/context.html#Naming
export CATALINA_HOME=/usr/local/tomcat/
FIXED_CTX=$(echo "${CONTEXT_PATH}" | sed 's|/|#|g')
WAR_FILE=${CATALINA_HOME}/webapps/${FIXED_CTX}.war

cp ${CATALINA_HOME}/apollo.war ${WAR_FILE}
tail -f ${CATALINA_HOME}/logs/catalina.out 
