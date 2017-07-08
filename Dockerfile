# WebApollo
# VERSION 2.0
FROM quay.io/gmod/docker-apollo:bare
MAINTAINER Eric Rasche <esr@tamu.edu>, Anthony Bretaudeau <anthony.bretaudeau@inria.fr>, Nathan Dunn <nathandunn@lbl.gov>
RUN apk update && \
	apk add postgresql

ADD launch.sh /launch.sh
