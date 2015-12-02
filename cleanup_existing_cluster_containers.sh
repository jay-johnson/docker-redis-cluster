#!/bin/bash

docker stop localhost.localdomain/redisreplica3 localhost.localdomain/redisreplica2 localhost.localdomain/redisreplica1 localhost.localdomain/redismaster1 localhost.localdomain/redismaster2 localhost.localdomain/redismaster3 &> /dev/null

docker rm localhost.localdomain/redisreplica3 localhost.localdomain/redisreplica2 localhost.localdomain/redisreplica1 localhost.localdomain/redismaster1 localhost.localdomain/redismaster2 localhost.localdomain/redismaster3 &> /dev/null

exit 0

