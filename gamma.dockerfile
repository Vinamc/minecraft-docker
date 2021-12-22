FROM openjdk:17-alpine

LABEL maintainer="Alex"
LABEL spigot_version="server 1.18.x"

# Setup timezone
RUN apk add --no-cache tzdata
ENV TZ=UTC

RUN mkdir /server
RUN mkdir /src

WORKDIR /server

ENV GB_MEMORY=2
ENV JAR_NAME=paperclip.jar

COPY . /src

RUN sed -i 's/\r$//' /src/docker-entrypoint.sh && chmod +x /src/docker-entrypoint.sh

CMD [ "sh", "/src/gamma-entrypoint.sh" ]
