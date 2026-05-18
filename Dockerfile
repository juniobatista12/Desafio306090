FROM node:16.16-bullseye AS node

FROM eclipse-temurin:11-jdk

WORKDIR /liferay

ENV JAVA_TOOL_OPTIONS="-XX:+UseContainerSupport -Xms512m -Xmx4g"

# Copy Node binaries and libraries from the official 16.16-alpine image
COPY --from=node /usr/local/bin/ /usr/local/bin/
COPY --from=node /usr/local/lib/ /usr/local/lib/

RUN apt-get update && apt-get install -y \
    curl \
    bash

# Instala Blade CLI
RUN curl -L https://raw.githubusercontent.com/liferay/liferay-blade-cli/master/cli/installers/global | sh


# Verify installation
RUN node -v
RUN java -version

ADD . /liferay

RUN blade server init

COPY portal-ext.properties /liferay/bundles

#RUN blade gw deploy

ENTRYPOINT [ "blade", "server", "run" ]