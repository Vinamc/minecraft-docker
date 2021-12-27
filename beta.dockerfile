FROM adoptopenjdk/openjdk11-openj9:alpine

LABEL maintainer="Alex"
LABEL spigot_version="1.12.x <= server <= 1.16.x"

# Setup timezone
RUN apk add --no-cache tzdata
ENV TZ=UTC

RUN mkdir /server
RUN mkdir /src

WORKDIR /server

ENV GB_MEMORY=2
ENV JAR_NAME=paperclip.jar
ENV VERSION=1.16.5

COPY . /src

RUN sed -i 's/\r$//' /src/docker-entrypoint.sh && chmod +x /src/docker-entrypoint.sh

CMD [ "sh", "/src/docker-entrypoint.sh" ]
