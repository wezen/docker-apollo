# WebApollo
# VERSION 2.0
FROM quay.io/erasche/apollo:master
RUN apk update && \
	apk add postgresql bash perl make gcc perl-dev musl-dev db-dev && \
	cd / && \
	wget http://jbrowse.org/wordpress/wp-content/plugins/download-monitor/download.php?id=109 -O JBrowse-1.12.3.zip && \
	unzip JBrowse-1.12.3.zip && \
	rm JBrowse-1.12.3.zip && \
	cd JBrowse-1.12.3 && \
	sed -i 's|bin/cpanm|bin/cpanm --no-wget|g' setup.sh && \
	./bin/cpanm local::lib --no-wget && \
	bash setup.sh && \
	apk del make gcc perl-dev musl-dev db-dev

ADD launch.sh /launch.sh
