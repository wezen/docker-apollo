# WebApollo
# VERSION 2.0
FROM quay.io/erasche/apollo:master
RUN apk update && \
	apk add postgresql

ADD launch.sh /launch.sh
