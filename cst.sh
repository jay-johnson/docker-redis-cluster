#!/bin/bash


echo ""
echo "Printing Redis Cluster Status:"
echo ""

echo "redismaster1(6379):"
redis-cli -h 127.0.0.1 -p 6379 cluster nodes
echo ""
echo "redismaster2(6380):"
redis-cli -h 127.0.0.1 -p 6380 cluster nodes
echo ""
echo "redismaster3(6381):"
redis-cli -h 127.0.0.1 -p 6381 cluster nodes
echo ""
echo "redisreplica1(6382):"
redis-cli -h 127.0.0.1 -p 6382 cluster nodes
echo ""
echo "redisreplica2(6383):"
redis-cli -h 127.0.0.1 -p 6383 cluster nodes
echo ""
echo "redisreplica3(6384):"
redis-cli -h 127.0.0.1 -p 6384 cluster nodes
echo ""

echo ""
echo "Done"
echo ""

exit 0

