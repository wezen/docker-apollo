# WebApollo
# VERSION 2.0
FROM tomcat:8-jre8
MAINTAINER Anthony Bretaudeau <anthony.bretaudeau@inra.fr>, Eric Rasche <esr@tamu.edu>, Nathan Dunn <nathandunn@lbl.gov>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update --fix-missing && \
    apt-get --no-install-recommends -y install \
    git build-essential maven2 openjdk-8-jdk libpq-dev postgresql-common \
    postgresql-client xmlstarlet netcat libpng12-dev zlib1g-dev libexpat1-dev \
    ant perl5 curl ssl-cert && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get -qq update --fix-missing && \
    apt-get --no-install-recommends -y install \
    nodejs

RUN npm install -g bower && \
    cp /usr/lib/jvm/java-8-openjdk-amd64/lib/tools.jar /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/tools.jar && \
    useradd -ms /bin/bash -d /apollo apollo

# RUN cpan notest install Text::Markdown  # needed for apollo release
# 2.0.5
ENV WEBAPOLLO_VERSION ba55496a9b4ee3848f3699c08706f2617a10621a
RUN curl -L https://github.com/GMOD/Apollo/archive/${WEBAPOLLO_VERSION}.tar.gz | tar xzf - --strip-components=1 -C /apollo


# RUN cpan notest install Text::Markdown  # needed for apollo release

ADD 1423_fix_auth.patch /apollo/1423_fix_auth.patch
ADD 1445_auto_add_group.diff /apollo/1445_auto_add_group.diff

RUN cd /apollo && \
    patch -p1 < 1423_fix_auth.patch && \
    patch -p1 < 1445_auto_add_group.diff && \
	./grailsw help && \
	./gradlew help

RUN mv /root/.gradle/ /apollo/.gradle/ && \
	mv /root/.grails/ /apollo/.grails/

COPY build.sh /bin/build.sh
ADD apollo-config.groovy /apollo/apollo-config.groovy

RUN chown -R apollo:apollo /apollo
USER apollo
RUN bash /bin/build.sh
USER root

ENV CONTEXT_PATH ROOT

RUN rm -rf ${CATALINA_HOME}/webapps/* && \
    cp /apollo/target/apollo*.war /apollo.war && \
    cp /apollo/target/apollo*.war ${CATALINA_HOME}/webapps/${CONTEXT_PATH}.war && \
    mkdir ${CATALINA_HOME}/webapps/${CONTEXT_PATH} && \
    cd ${CATALINA_HOME}/webapps/${CONTEXT_PATH} && \
    jar xvf ../${CONTEXT_PATH}.war && \
    cd /apollo

ADD launch.sh /launch.sh
CMD "/launch.sh"
