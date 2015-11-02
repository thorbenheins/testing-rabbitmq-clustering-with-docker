#!/bin/bash

echo ""
echo "Destroying containers:"

nodelist="cluster_rabbit3_1 cluster_rabbit2_1 cluster_rabbit1_1"
docker rm $nodelist
echo "Done destroying containers"

echo ""
echo "Destroying all images"
docker rmi $(docker images -a |awk '{print $3}')
echo "Done all images"

