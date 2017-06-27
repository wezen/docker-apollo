# WebApollo
# VERSION 2.0
FROM tomcat:8-jre8
MAINTAINER Eric Rasche <esr@tamu.edu>, Nathan Dunn <nathandunn@lbl.gov>, Anthony Bretaudeau <anthony.bretaudeau@inria.fr>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update --fix-missing && \
	apt-get --no-install-recommends -y install \
	git build-essential maven libpq-dev postgresql-common openjdk-8-jdk wget \
	postgresql postgresql-client xmlstarlet netcat libpng12-dev \
	zlib1g-dev libexpat1-dev ant curl ssl-cert && \
	apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get -qq update --fix-missing && \
	apt-get --no-install-recommends -y install npm nodejs

RUN ln -s /usr/bin/nodejs /usr/bin/node && \
	npm install -g bower && \
	cp /usr/lib/jvm/java-8-openjdk-amd64/lib/tools.jar /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/tools.jar && \
	useradd -ms /bin/bash -d /apollo apollo

ENV WEBAPOLLO_VERSION 7b304aac81f7dab77165f37bf210a6b3cb1b8080
RUN curl -L https://github.com/GMOD/Apollo/archive/${WEBAPOLLO_VERSION}.tar.gz | tar xzf - --strip-components=1 -C /apollo

COPY build.sh /bin/build.sh
ADD apollo-config.groovy /apollo/apollo-config.groovy

RUN chown -R apollo:apollo /apollo
USER apollo
RUN bash /bin/build.sh
USER root

RUN rm -rf ${CATALINA_HOME}/webapps/* && \
	cp /apollo/target/apollo*.war /apollo.war

ENV CONTEXT_PATH ROOT

# Download chado schema
RUN wget --quiet https://github.com/erasche/chado-schema-builder/releases/download/1.31-jenkins97/chado-1.31.sql.gz -O /chado.sql.gz && \
	gunzip /chado.sql.gz
ADD user.sql /apollo/user.sql

ADD launch.sh /launch.sh
CMD "/launch.sh"
