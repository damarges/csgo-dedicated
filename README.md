# Counterstrike: Global Offensive (CS:GO) dedicated server
This image provides a plain CS:GO dedicated server.
It is based on latest Ubuntu image (at the time of writing these lines the latest tag is assigned to Ubuntu 20.04), installs `steamcmd` and thereafter downloads the whole dedicated game server image from valve servers (which can take a while as it is about 25GB of data).

## System Requirements
The server is not contained by the image, to keep it small.
It will download and install on first start of the container.
You will need at least **30GB** of free HDD space, for the container to inflate.

## Usage
To start the container run 

`docker run -d --init --name csgo-dedicated --restart unless-stopped -v csgo-dedicated-config:/var/csgo/cfg -p 27015:27015 -p 27015:27015/udp -e RCON_PASSWORD=mypassword -e CSS_HOSTNAME=myservername -e PORT=27015 damarges/csgo-dedicated`.

The following ENV variables can be configured to your needs

`RCON_PASSWORD` Rcon password required to control the server while running,

`CSGO_MAXPLAYERS` number of max number of players that may connect to the server

`CSGO_TICK` tickrate 64 or 128 (depending on the performance of your server)

`CSGO_PASSWORD` if you want the server to be password protected to access to play

`CSGO_HOSTNAME` how your server name should appear in the server list and ingame

`CSGO_GAMETYPE` 

`CSGO_GAMEMODE` set gametype and mode to switch game mode. change map to apply changes to that while in game



Following typical modes as example (first number is gametype, second number is game mode):

0,0 (casual game)

0,1 (competitive game)

0,2 (wingman game)

Complete list of possible game modes can be found here:

https://developer.valvesoftware.com/wiki/CSGO_Game_Mode_Commands



If you want to have the server to listen on another port, change `-e PORT=27015` and `-p 27015:27015 -p 27015:27015/udp` accordingly.
Internal and external ports must match.

The server's config folder is persisted in the named volume `csgo-dedicated-config`.
So if you want to change settings, just tap into the container, change the files within config and restart.
The changes won't get lost.
