#!/bin/bash

echo ""
echo "Displaying Cluster Bindings"
echo ""

rabbitmqadmin list bindings source destination routing_key --host=`docker-machine ip`

echo ""


