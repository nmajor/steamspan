#!/bin/bash
PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )

cd "$PARENT_PATH"

SELF_IP=`ifconfig | sed -En "s/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p" | head -n 1`
HOSTNAME=`hostname`

sed -i -e s/'HOSTNAME'/$HOSTNAME/g config.json
sed -i -e s/'SELF_IP'/$SELF_IP/g config.json

curl -X POST http://consul:8500/v1/agent/service/register -d @config.json -H 'Content-type: application/json'