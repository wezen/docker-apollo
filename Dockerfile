# WebApollo
# VERSION 2.0
FROM tomcat:7
MAINTAINER Eric Rasche <esr@tamu.edu>, Nathan Dunn <nathandunn@lbl.gov>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update --fix-missing && \
    apt-get --no-install-recommends -y install \
    git build-essential maven2 openjdk-7-jdk libpq-dev postgresql-common \
    postgresql-client xmlstarlet netcat libpng12-dev zlib1g-dev libexpat1-dev \
    ant perl5 curl ssl-cert

ENV WA_VERSION 4da76927f974f3e0f0ebf4be5f7b3bf49f8929d1
RUN mkdir /apollo && mkdir /opt/apollo && \
    curl -L https://github.com/GMOD/Apollo/archive/${WA_VERSION}.tar.gz | tar xzf - --strip-components=1 -C /apollo

COPY build.sh /bin/build.sh
RUN cp /apollo/sample-docker-apollo-config.groovy /apollo/apollo-config.groovy && \
    bash /bin/build.sh && \
    rm -rf ${CATALINA_HOME}/webapps/* && \
    cp /apollo/target/apollo*.war ${CATALINA_HOME}/webapps/apollo.war
