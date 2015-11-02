#!/bin/bash

source common.sh .

echo "Removing Docker Assets for Container($1)"

docker stop $1
docker rm $1
docker rmi $1
