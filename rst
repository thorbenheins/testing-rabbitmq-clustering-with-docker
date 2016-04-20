#!/bin/bash

echo ""
echo "Running Cluster Status"
echo ""

rabbitmqadmin list nodes name type running --host=`docker-machine ip`

echo ""

