# WebApollo
# VERSION 2.0
FROM quay.io/erasche/apollo:master
RUN apk update && \
	apk add postgres

ADD launch.sh /launch.sh
