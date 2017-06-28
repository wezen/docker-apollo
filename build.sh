#!/bin/bash
set -ex

cd /apollo/ && \
	./apollo deploy && \
	./apollo deploy && \
	# Move to tmp dir
	cp /apollo/target/apollo*.war /tmp/apollo.war && \
	# So we can remove ~1.6 GB of cruft from the image. Ignore errors because cannot remove parent dir /apollo/
	rm -rf /apollo/ || true && \
	# Before moving back into a standardized location (that we have write access to)
	mv /tmp/apollo.war /apollo/apollo.war

if [ -d /output/ ]; then
	cp /apollo/apollo.war /output/;
fi
