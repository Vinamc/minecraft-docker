# Spigot runner
This image provide OpenJ9 java optimized with aikar flag. Come with three differences version.

## Tags version
  - `alexzvn/spigot-runner:alpha` for `server <= 1.12.x` running java 8
  - `alexzvn/spigot-runner:beta` for `1.12.x <= server <= 1.16.x`  running java 11
  - `alexzvn/spigot-runner:delta` for `server >= 1.17.x` running java 16
  - `alexzvn/spigot-runner:gamma` for `server 1.18.x` running java 17

## Environment
  - `TZ`: Timezone for container, see full list in [Wikipedia](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).
  - `GB_MEMORY`: Maximum GB ram for server, default value is `2`.
  - `JAR_NAME`: The name of your server's JAR file. The default is "paperclip.jar".  If you're not using Paper (http://papermc.io), then you should really switch.
  - `DISABLE_AIKAR_FLAG`: set to `true` if you want to disable Aikar's flag enable by default
  - `FIX_LOG4J_FLAG`: set to `false` if you want to disable them
  - `CUSTOM_FLAG`: Insert custom flag when run server

## Volumes
  - `/server` this is where your source code in container

## Commands

### Running
```bash
docker run -p 25565:25565 /path/to/server:/server -dit --name myserver alexzvn/spigot-runner:beta
```
### Access console
```bash
docker attach myserver
```
**Note:** press `Ctrl + P` and `Ctrl + Q` to exit console
