FROM adoptopenjdk/openjdk11-openj9:alpine

LABEL maintainer="Alex"
LABEL spigot_version="1.12.x <= server <= 1.17.x"

RUN mkdir /server
RUN mkdir /src

WORKDIR /server

ENV GB_MEMORY=2
ENV JAR_NAME=paperclip.jar

COPY . /src

CMD [ "sh", "/src/entrypoint.sh" ]