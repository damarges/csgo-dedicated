#!/usr/bin/env bash

loadConfig() {
    echo "Loading config"
    yes | cp -rfa /var/csgo/cfg/. /opt/steam/csgo/cstrike/cfg/
}

storeConfig() {
    echo "Storing config"
    yes | cp -rfa /opt/steam/csgo/cstrike/cfg/. /var/csgo/cfg/
}

shutdown() {
    pkill srcds_linux
    storeConfig
    echo "Container stopped"
    exit 143;
}

term_handler() {
    echo "SIGTERM received"
    shutdown
}

install() {
    echo "Installing CS:GO Server"
    /opt/steam/steamcmd.sh +login anonymous +force_install_dir /opt/steam/csgo/ +app_update 740 validate +quit
    mv /tmp/cfg/* /opt/steam/csgo/cstrike/cfg
    cd /opt/steam/csgo/cstrike
    chown -R steam:steam /opt/steam/css
    ln -s /opt/steam/linux32 /home/steam/.steam/sdk32
    echo "Installation done"
}

update() {
    echo "Updating CS:GO Dedicated Server"
    /opt/steam/steamcmd.sh +login anonymous +app_update 740 +quit
    echo "Update done"
}

trap term_handler SIGTERM
[ ! -d "/opt/steam/csgo" ] && install || update
loadConfig
echo "Starting CS:GO Dedicated Server"
cd /opt/steam/csgo
su steam -c "./srcds_run -game csgo -port $PORT +exec server.cfg +maxplayers $CSGO_MAXPLAYERS -tickrate $CSGO_TICK +hostname $CSGO_HOSTNAME +game_type $GAMETYPE +game_mode $GAMEMODE +sv_password $CSGO_PASSWORD +rcon_password $RCON_PASSWORD +map de_dust2" & wait ${!}
echo "CS:GO dedicated died"
shutdown
