#!/bin/bash

source common.sh . 

nodename="cluster_rabbit1_1"

echo "SSHing into $nodename"

docker exec -t -i $nodename /bin/bash

