#!/bin/bash

nodename="redismaster3"

echo "SSHing into $nodename"

docker exec -t -i $nodename /bin/bash

