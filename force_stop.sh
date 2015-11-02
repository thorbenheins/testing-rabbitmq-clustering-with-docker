#!/bin/bash

source common.sh .

nodes=["cluster_rabbit1_1 cluster_rabbit2_1 cluster_rabbit3_1"]
for node in $nodes
do
  echo "Stopping Docker Container($node)"
  docker stop $node
done

