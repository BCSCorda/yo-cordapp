# Base image from (http://phusion.github.io/baseimage-docker)
FROM openjdk:8u151-jre-alpine

# Override default value with 'docker build --build-arg BUILDTIME_CORDA_VERSION=version'
# example: 'docker build --build-arg BUILDTIME_CORDA_VERSION=3.1-corda -t corda/node:3.1 .'
ARG BUILDTIME_CORDA_VERSION=3.1-corda
ARG BUILDTIME_JAVA_OPTIONS

ENV CORDA_VERSION=${BUILDTIME_CORDA_VERSION}
ENV JAVA_OPTIONS=${BUILDTIME_JAVA_OPTIONS}

# Set image labels
LABEL net.corda.version = ${CORDA_VERSION} \
      maintainer = "<devops@r3.com>" \
      vendor = "R3"

RUN apk upgrade --update && \
    apk add --update --no-cache bash iputils && \
    rm -rf /var/cache/apk/* && \
    # Add user to run the app && \
    addgroup corda && \
    adduser -G corda -D -s /bin/bash corda && \
    # Create /opt/corda directory && \
    mkdir -p /opt/corda/cordapps && \
    mkdir -p /opt/corda/logs

# Copy corda jar
ADD --chown=corda:corda https://dl.bintray.com/r3/corda/net/corda/corda/${CORDA_VERSION}/corda-${CORDA_VERSION}.jar                       /opt/corda/corda.jar
ADD --chown=corda:corda https://dl.bintray.com/r3/corda/net/corda/corda-webserver/${CORDA_VERSION}/corda-webserver-${CORDA_VERSION}.jar   /opt/corda/corda-webserver.jar

COPY run-corda.sh /run-corda.sh
RUN chmod +x /run-corda.sh && \
    sync && \
    chown -R corda:corda /opt/corda

# Working directory for Corda
WORKDIR /opt/corda
ENV HOME=/opt/corda
USER corda

# Start it
CMD ["/run-corda.sh"]
