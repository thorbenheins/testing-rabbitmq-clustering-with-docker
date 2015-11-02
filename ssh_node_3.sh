#!/bin/bash

source common.sh . 

nodename="cluster_rabbit3_1"

echo "SSHing into $nodename"

docker exec -t -i $nodename /bin/bash

