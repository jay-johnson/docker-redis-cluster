#!/bin/bash

nodename="redisreplica1"

echo "SSHing into $nodename"

docker exec -t -i $nodename /bin/bash

