#!/bin/bash

./cleanup_existing_cluster_containers.sh 

echo "Starting the Cluster on Docker Swarm"
#docker-compose up -d
export DOCKER_HOST=localhost:4000
docker-compose --x-networking --x-network-driver overlay up -d
echo "Done"


