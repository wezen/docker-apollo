#!/usr/bin/env bash
service postgresql start


echo "Postgres is up, loading chado"

WEBAPOLLO_DB_HOST="${WEBAPOLLO_DB_HOST:-127.0.0.1}"
WEBAPOLLO_DB_NAME="${WEBAPOLLO_DB_NAME:-apollo}"
WEBAPOLLO_DB_USERNAME="${WEBAPOLLO_DB_USERNAME:-apollo}"
WEBAPOLLO_DB_PASSWORD="${WEBAPOLLO_DB_PASSWORD:-apollo}"
WEBAPOLLO_HOST_FLAG="-h ${WEBAPOLLO_DB_HOST}"

# TODO: use variable throughout
#USE_CHADO="${USE_CHADO:true}"

CHADO_DB_HOST="${CHADO_DB_HOST:-127.0.0.1}"
CHADO_DB_NAME="${CHADO_DB_NAME:-apollo}"
CHADO_DB_USERNAME="${CHADO_DB_USERNAME:-apollo}"
CHADO_DB_PASSWORD="${CHADO_DB_PASSWORD:-apollo}"
CHADO_HOST_FLAG="-h ${CHADO_DB_HOST}"


export PGUSER=$WEBAPOLLO_DB_USERNAME
export PGPASSWORD=$WEBAPOLLO_DB_PASSWORD
#export DB_CONNECT=$(echo $WEBAPOLLO_DB_URI | sed 's/jdbc://g')
#while ! psql $DB_CONNECT -l; do
#    echo "Sleeping on DB"
#    sleep 1;
#done;
echo "Waiting for DB"
until pg_isready; do
	echo -n "."
	sleep 1;
done

echo "Postgres is up, configuring database"


su postgres -c "psql -lqt | cut -d \| -f 1 | grep -qw $WEBAPOLLO_DB_NAME"
if [[ "$?" == "1" ]]; then
	echo "Apollo database not found, creating..."
	su postgres -c "createdb $WEBAPOLLO_HOST_FLAG $WEBAPOLLO_DB_NAME"
	su postgres -c "psql $WEBAPOLLO_HOST_FLAG -c \"CREATE USER $WEBAPOLLO_DB_USERNAME WITH PASSWORD '$WEBAPOLLO_DB_PASSWORD';\""
	su postgres -c "psql $WEBAPOLLO_HOST_FLAG -c 'GRANT ALL PRIVILEGES ON DATABASE \"$WEBAPOLLO_DB_NAME\" to $WEBAPOLLO_DB_USERNAME;'"
fi

echo "Configuring Chado"
export PGUSER=$CHADO_DB_USERNAME
export PGPASSWORD=$CHADO_DB_PASSWORD
su postgres -c "psql -lqt | cut -d \| -f 1 | grep -qw $CHADO_DB_NAME"
if [[ "$?" == "1" ]]; then
	echo "Chado database not found, creating..."
	su postgres -c "createdb $CHADO_HOST_FLAG $CHADO_DB_NAME"
	su postgres -c "psql $CHADO_HOST_FLAG -c \"CREATE USER $CHADO_DB_USERNAME WITH PASSWORD '$CHADO_DB_PASSWORD';\""
	su postgres -c "psql $CHADO_HOST_FLAG -c 'GRANT ALL PRIVILEGES ON DATABASE \"$CHADO_DB_NAME\" to $CHADO_DB_USERNAME;'"
	su postgres -c "psql -U $CHADO_DB_USERNAME -h ${CHADO_DB_HOST} $CHADO_DB_NAME -f /chado.sql"
fi


# https://tomcat.apache.org/tomcat-8.0-doc/config/context.html#Naming
export CATALINA_HOME="${CATALINA_HOME:-/usr/local/tomcat/}"
FIXED_CTX=$(echo "${CONTEXT_PATH}" | sed 's|/|#|g')
WAR_FILE=${CATALINA_HOME}/webapps/${FIXED_CTX}.war

echo "Restarting tomcat with $CATALINA_HOME"
$CATALINA_HOME/bin/shutdown.sh
$CATALINA_HOME/bin/startup.sh

cp ${CATALINA_HOME}/apollo.war ${WAR_FILE}

if [[ ! -f "${CATALINA_HOME}/logs/catalina.out" ]]; then
	touch ${CATALINA_HOME}/logs/catalina.out
fi

tail -f ${CATALINA_HOME}/logs/catalina.out 
