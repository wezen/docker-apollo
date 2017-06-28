# WebApollo
# VERSION 2.0
FROM tomcat:8-jre8
MAINTAINER Eric Rasche <esr@tamu.edu>, Anthony Bretaudeau <anthony.bretaudeau@inria.fr>, Nathan Dunn <nathandunn@lbl.gov>
ENV DEBIAN_FRONTEND noninteractive 

RUN apt-get -qq update --fix-missing && \
	apt-get --no-install-recommends -y install \
	git build-essential maven libpq-dev openjdk-8-jdk wget \
	xmlstarlet netcat libpng12-dev \
	zlib1g-dev libexpat1-dev ant curl ssl-cert

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get -qq update --fix-missing && \
	apt-get --no-install-recommends -y install nodejs && \
	apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN npm install -g bower && \
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

ENV CATALINA_HOME=/usr/local/tomcat/
RUN rm -rf ${CATALINA_HOME}/webapps/* && \
	cp /apollo/target/apollo*.war ${CATALINA_HOME}/apollo.war

ENV CONTEXT_PATH ROOT

ADD launch.sh /launch.sh
CMD "/launch.sh"

