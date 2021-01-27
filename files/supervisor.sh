#!/usr/bin/env bash

loadConfig() {
    echo "Loading config"
    yes | cp -rfa /var/css/cfg/. /opt/steam/css/cstrike/cfg/
}

storeConfig() {
    echo "Storing config"
    yes | cp -rfa /opt/steam/css/cstrike/cfg/. /var/css/cfg/
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
    /opt/steam/steamcmd.sh +login anonymous +force_install_dir /opt/steam/css/ +app_update 740 validate +quit
    mv /tmp/cfg/* /opt/steam/css/cstrike/cfg
    cd /opt/steam/css/cstrike
    tar zxvf /tmp/mmsource-1.10.7-git970-linux.tar.gz
    tar zxvf /tmp/sourcemod-1.9.0-git6281-linux.tar.gz
    mv /tmp/gem_damage_report.smx addons/sourcemod/plugins
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
[ ! -d "/opt/steam/css" ] && install || update
loadConfig
echo "Starting CS:GO Dedicated Server"
cd /opt/steam/css
su steam -c "./srcds_run -game csgo -port $PORT +exec server.cfg +maxplayers $CSGO_MAXPLAYERS -tickrate $CSGO_TICK +hostname $CSGO_HOSTNAME +game_type $GAMETYPE +game_mode $GAMEMODE +sv_password $CSGO_PASSWORD +rcon_password $RCON_PASSWORD +map de_dust2" & wait ${!}
echo "CS:GO dedicated died"
shutdown
