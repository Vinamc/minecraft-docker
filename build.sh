#!/bin/bash

for VERSION in alpha beta delta gammar
do
    docker build -t spigot-runner:${VERSION} -f ${VERSION}.dockerfile .
    docker image tag spigot-runner:${VERSION} alexzvn/spigot-runner:${VERSION}
    docker push alexzvn/spigot-runner:${VERSION}
done
