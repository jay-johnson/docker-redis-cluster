#!/bin/bash

nodename="redisreplica3"

echo "SSHing into $nodename"

docker exec -t -i $nodename /bin/bash

