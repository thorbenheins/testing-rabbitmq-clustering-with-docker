#!/bin/bash

source common.sh . 

nodename="rabbit3"

stopcommand="pushd cluster ; docker-compose stop $nodename ; popd"

echo "Ending $nodename with command: $stopcommand"

pushd cluster >> /dev/null ; docker-compose stop $nodename ; popd >> /dev/null

exit 0
