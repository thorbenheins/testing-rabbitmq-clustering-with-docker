#!/bin/bash

source common.sh .

pushd cluster >> /dev/null
docker-compose up -d
popd >> /dev/null


