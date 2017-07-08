# WebApollo
# VERSION 2.0
FROM quay.io/gmod/docker-apollo:bare
MAINTAINER Eric Rasche <esr@tamu.edu>, Anthony Bretaudeau <anthony.bretaudeau@inria.fr>, Nathan Dunn <nathandunn@lbl.gov>
RUN apk update && \
	apk add postgresql sudo wget ca-certificates && \
	update-ca-certificates && \
	wget --quiet https://github.com/erasche/chado-schema-builder/releases/download/1.31-jenkins97/chado-1.31.sql.gz -O /chado.sql.gz && \
	gunzip /chado.sql.gz

ADD launch.sh /launch.sh
