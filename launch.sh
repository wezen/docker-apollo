#!/bin/sh

# Deploy WAR file
# https://tomcat.apache.org/tomcat-8.0-doc/config/context.html#Naming
FIXED_CTX=$(echo "${CONTEXT_PATH}" | sed 's|/|#|g')
WAR_FILE=${CATALINA_HOME}/webapps/${FIXED_CTX}.war
rm -rf ${CATALINA_HOME}/webapps/*
cp /apollo/apollo.war ${WAR_FILE}

# Launch postgres
apk add sudo postgresql

mkdir -p "/var/lib/postgres/data"
chown -R postgres "/var/lib/postgres/data"
chmod 700 "/var/lib/postgres/data"

mkdir -p /run/postgresql
chown -R postgres /run/postgresql
chmod 775 /run/postgresql

# Initialize Database
echo 'postgres' > /tmp/pgpass;
sudo -u postgres initdb --username=postgres -D /var/lib/postgres/data --auth-host=md5 --pwfile=/tmp/pgpass
sleep 5;
rm -f /tmp/pgpass
sudo -u postgres pg_ctl start -D /var/lib/postgres/data

# Wait for DB to be up
while ! pg_isready; do
	echo "Sleeping on database"
	sleep 1;
done;

# Now that it is, create the databases.
echo "Postgres is up, preparing apollo and chado databases"
# These *must* be executed with sudo
sudo -u postgres createdb apollo -O postgres
sudo -u postgres createdb chado -O postgres

# Load Chado schema
export PGUSER=postgres
export PGPASSWORD=postgres
export PGHOSTADDR=127.0.0.1
export PGPORT=5432
psql chado -f /chado.sql

catalina.sh run
