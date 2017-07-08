# WebApollo
# VERSION 2.0
FROM quay.io/gmod/docker-apollo:bare
MAINTAINER Eric Rasche <esr@tamu.edu>, Anthony Bretaudeau <anthony.bretaudeau@inria.fr>, Nathan Dunn <nathandunn@lbl.gov>
RUN apk update && \
	apk add postgresql sudo wget ca-certificates && \
	update-ca-certificates && \
	wget --quiet https://github.com/erasche/chado-schema-builder/releases/download/1.31-jenkins97/chado-1.31.sql.gz -O /chado.sql.gz && \
	gunzip /chado.sql.gz && \
	mkdir -p "/var/lib/postgres/data" && \
	chown -R postgres "/var/lib/postgres/data" && \
	chmod 700 "/var/lib/postgres/data" && \
	mkdir -p /run/postgresql && \
	chown -R postgres /run/postgresql && \
	chmod 775 /run/postgresql && \
	echo 'postgres' > /tmp/pgpass && \
	sudo -u postgres initdb --username=postgres -D /var/lib/postgres/data --auth-host=md5 --pwfile=/tmp/pgpass  && \
	sleep 5 && \
	rm -f /tmp/pgpass && \
	sudo -u postgres pg_ctl start -D /var/lib/postgres/data && \
	export PGUSER=postgres && \
	export PGPASSWORD=postgres && \
	export PGHOSTADDR=127.0.0.1 && \
	export PGPORT=5432 && \
	while ! pg_isready; do sleep 1; done; \
	sudo -u postgres createdb apollo -O postgres && \
	sudo -u postgres createdb chado -O postgres && \
	psql chado -f /chado.sql && \
	rm -f /chado.sql


ADD launch.sh /launch.sh
