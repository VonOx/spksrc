#!/bin/sh

CONFIG_FILE="/usr/local/gladysassistant/etc/gladysassistant.json"

runGladys() {
    GLADYS_DATA="$(jq --raw-output '.data // "/usr/share/gladysassistant"' ${CONFIG_FILE})"

    /usr/local/bin/docker rm --force hassio_supervisor >/dev/null || true
    /usr/local/bin/docker run \
        --restart=always \
        --privileged \
        --network=host \
        --name gladys \
        -e NODE_ENV=production \
        -e SERVER_PORT=8420 \
        -e TZ=Europe/Paris \
        -e SQLITE_FILE_PATH=$GLADYS_DATA/gladys-production.db \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v $GLADYS_DATA:/var/lib/gladysassistant \
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
