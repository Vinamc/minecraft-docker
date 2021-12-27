#!/bin/bash

#
# Properly tunes a Minecraft server to run efficiently under the
# OpenJ9 (https://www.eclipse.org/openj9) JVM.
#
# Licensed under the MIT license.
#

## BEGIN CONFIGURATION

if [ not $GB_MEMORY ]
then
    GB_MEMORY=2
fi

# HEAP_SIZE: This is how much heap (in MB) you plan to allocate
#            to your server. By default, this is set to 12288MB,
#            or 12GB.

HEAP_SIZE=$(($GB_MEMORY * 1024))

# JAR_NAME:  The name of your server's JAR file. The default is
#            "paperclip.jar".
#
#            Side note: if you're not using Paper (http://papermc.io),
#            then you should really switch.
# JAR_NAME=paper-1.16.5-776.jar

## END CONFIGURATION -- DON'T TOUCH ANYTHING BELOW THIS LINE!

## BEGIN SCRIPT

# Compute the nursery size.
NURSERY_MINIMUM=$(($HEAP_SIZE / 4))
NURSERY_MAXIMUM=$(($HEAP_SIZE * 2 / 5))

# Setup Aikar's flag
if [ $HEAP_SIZE -gt 12000 ]
then
    FLAG_MEMORY="-XX:G1NewSizePercent=40 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=15 -XX:InitiatingHeapOccupancyPercent=20"
else
    FLAG_MEMORY="-XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=15"
fi

if [ $DISABLE_AIKAR_FLAG ]
then
    AIKAR_FLAG=""
else
    AIKAR_FLAG="-Xgcpolicy:balanced -Xdisableexplicitgc -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch ${FLAG_MEMORY} -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true "
fi

if [ $CUSTOM_FLAG ]
then
    CUSTOM_FLAG="${CUSTOM_FLAG} "
fi

# get 2nd number after '.' in version
VERSION_NUMBER=$(echo $VERSION | cut -d. -f2)

if [ $VERSION_NUMBER -gt 17 ]
then
    LDAP_LOG4J=""

elif [ $VERSION_NUMBER -ge 17 ]
then
    LDAP_LOG4J="-Dlog4j2.formatMsgNoLookups=true"

elif [ $VERSION_NUMBER -ge 12 ]
then
    LDAP_LOG4J="-Dlog4j.configurationFile=/src/log4j2_112-116.xml"

elif [ $VERSION_NUMBER -ge 7 ]
then
    LDAP_LOG4J="-Dlog4j.configurationFile=/src/log4j2_17-111.xml"

else
    LDAP_LOG4J=""
fi

if [ "$FIX_LOG4J_FLAG" = "false" ]
then
    FIX_LOG4J_FLAG=""
else
    FIX_LOG4J_FLAG="${LDAP_LOG4J} "
fi

# Launch the server.
CMD="java -Xms${HEAP_SIZE}M -Xmx${HEAP_SIZE}M -Xmns${NURSERY_MINIMUM}M -Xmnx${NURSERY_MAXIMUM}M -Xtune:virtualized ${FIX_LOG4J_FLAG}${AIKAR_FLAG}${CUSTOM_FLAG}-jar /server/${JAR_NAME} nogui"
echo "launching server with command line: ${CMD}"
## END SCRIPT

${CMD}
