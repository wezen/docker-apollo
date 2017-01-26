#!/bin/bash
WAR_FILE=${CATALINA_HOME}/webapps/${CONTEXT_PATH}.war
mkdir -p $(dirname ${WAR_FILE})

cp /apollo.war ${WAR_FILE}
catalina.sh run
