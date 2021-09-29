#!/bin/bash

#
# Properly tunes a Minecraft server to run efficiently under the
# OpenJ9 (https://www.eclipse.org/openj9) JVM.
#
# Licensed under the MIT license.
#

## BEGIN CONFIGURATION

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

AIKAR_FLAG="-Xgcpolicy:balanced -Xdisableexplicitgc -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch ${FLAG_MEMORY} -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"

# Launch the server.
CMD="java -Xms${HEAP_SIZE}M -Xmx${HEAP_SIZE}M -Xmns${NURSERY_MINIMUM}M -Xmnx${NURSERY_MAXIMUM}M ${AIKAR_FLAG} -jar /server/${JAR_NAME} nogui"
echo "launching server with command line: ${CMD}"
## END SCRIPT

${CMD}
