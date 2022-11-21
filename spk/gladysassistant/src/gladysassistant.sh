#!/bin/sh

host_folder="${wizard_volume:=/volume1}/${wizard_docker_share:=/docker}/gladysassistant"


runGladys() {
    /usr/local/bin/docker run \
        --restart=unless-stopped \
        --privileged \
        --network=host \
        --name gladys \
        --log-opt max-size=100m \
        -e NODE_ENV=production \
        -e SERVER_PORT=8420 \
        -e SQLITE_FILE_PATH=$host_folder/gladys-production.db \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v $host_folder:/var/lib/gladysassistant \
        -v /etc/localtime:/etc/localtime:ro \
        -v /dev:/dev \
        gladysassistant/gladys:v4
}

start_gladys() {
    # Fix routing
    route -vn | grep 172.30.32.0 >/dev/null ||
    route add -net 172.30.32.0/23 gw 172.30.32.1

    # Run Gladys
    /usr/local/bin/docker start --attach gladys) || runGladys
}

while true; do
    start_gladys
    sleep 1
done
