#!/bin/bash

source common.sh . 

echo "SSH into host($1)"

docker exec -t -i $1 /bin/bash

