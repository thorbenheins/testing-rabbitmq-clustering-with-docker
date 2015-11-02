#!/bin/bash

source common.sh .

pushd cluster >> /dev/null
docker-compose stop
popd >> /dev/null


