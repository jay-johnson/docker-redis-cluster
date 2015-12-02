## A Distributed Redis Cluster using Docker Swarm, Docker Compose, and Supervisor

### Overview

This repository will start a distributed redis cluster using docker-compose for high availability. The redis instances listen on the host node ports: 6379-6384. There are 3 master nodes and 3 replica nodes. If you are running a local Docker Swarm you can run the entire cluster of 6 nodes locally.

### How to Install

1. Make sure Swarm is installed 

  ```
  private-docker-redis-cluster $ sudo ./1_install_core.sh
  ```

1. Restart the local consul, docker daemon, swarm manager, and swarm join

  ```
  private-docker-redis-cluster $ sudo ./boot_local_docker_services.sh
  ``` 

1. Point to the Docker Swarm

  Please set the terminal environment to use the running Docker Swarm 
  
  ```
  $ export DOCKER_HOST=localhost:4000
  $ env | grep DOCKER
  DOCKER_HOST=localhost:4000
  $
  ```

1. Confirm the Docker Swarm Membership

  Running the swarm locally you should see only 1 node with something similar:

  ```
  $ docker info
  Containers: 0
  Images: 0
  Role: primary
  Strategy: spread
  Filters: health, port, dependency, affinity, constraint
  Nodes: 1
   localhost.localdomain: localhost:2375
    └ Containers: 0
    └ Reserved CPUs: 0 / 2
    └ Reserved Memory: 0 B / 4.053 GiB
    └ Labels: executiondriver=native-0.2, kernelversion=4.1.7-200.fc22.x86_64, operatingsystem=Fedora 22 (Twenty Two), storagedriver=devicemapper
  CPUs: 2
  Total Memory: 4.053 GiB
  Name: localhost.localdomain
  $
  ```

### Start the Redis Cluster 

Assuming consul, docker daemon, swarm manager, and swarm join are running with something similar to:

```
$ ps auwwx | grep consul | grep -v grep
root     29447  0.4  0.4 34110388 19204 pts/4  Sl   19:39   0:14 consul agent -server -data-dir=/tmp/consul -bind=0.0.0.0 -bootstrap-expect 1
root     31650 12.9  1.2 1329604 51208 pts/4   Sl   20:00   3:42 /usr/local/bin/docker daemon -H localhost:2375 --cluster-advertise 0.0.0.0:2375 --cluster-store consul://localhost:8500/developmentswarm
root     31738  0.0  0.5 488084 20512 pts/1    Sl   20:02   0:01 /usr/local/bin/swarm manage -H tcp://localhost:4000 --advertise localhost:4000 consul://localhost:8500/developmentswarm
root     31749  0.0  0.3 128416 14304 pts/1    Sl   20:02   0:00 /usr/local/bin/swarm join --addr=localhost:2375 consul://localhost:8500/developmentswarm
$
```
 
1. Make sure no other Redis nodes are running

  ```
  $ docker ps -a
  CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
  $ 
  ```

1. Start the Redis Cluster

  ```
  private-docker-redis-cluster $ ./start_cluster.sh 
  Starting the Cluster on Docker Swarm
  Creating redismaster1
  Creating redismaster3
  Creating redismaster2
  Creating redisreplica1
  Creating redisreplica2
  Creating redisreplica3
  Done
  private-docker-redis-cluster $
  ```

1. Confirm the Containers are running

  ```
  $ docker ps
  CONTAINER ID        IMAGE                          COMMAND                  CREATED             STATUS              PORTS                                                                              NAMES
  89f8ab731348        jayjohnson/redis-clusterable   "/bin/sh -c '. /bin/s"   4 minutes ago       Up 4 minutes        127.0.0.1:6384->6379/tcp, 127.0.0.1:16384->16379/tcp, 127.0.0.1:26384->26379/tcp   localhost.localdomain/redisreplica3
  6ff759f42bb6        jayjohnson/redis-clusterable   "/bin/sh -c '. /bin/s"   4 minutes ago       Up 4 minutes        127.0.0.1:6383->6379/tcp, 127.0.0.1:16383->16379/tcp, 127.0.0.1:26383->26379/tcp   localhost.localdomain/redisreplica2
  fe97da8b920a        jayjohnson/redis-clusterable   "/bin/sh -c '. /bin/s"   4 minutes ago       Up 4 minutes        127.0.0.1:6382->6379/tcp, 127.0.0.1:16382->16379/tcp, 127.0.0.1:26382->26379/tcp   localhost.localdomain/redisreplica1
  8ed2a60663f6        jayjohnson/redis-clusterable   "/bin/sh -c '. /bin/s"   4 minutes ago       Up 4 minutes        127.0.0.1:6380->6379/tcp, 127.0.0.1:16380->16379/tcp, 127.0.0.1:26380->26379/tcp   localhost.localdomain/redismaster2
  3a779ae52bd7        jayjohnson/redis-clusterable   "/bin/sh -c '. /bin/s"   4 minutes ago       Up 4 minutes        127.0.0.1:6381->6379/tcp, 127.0.0.1:16381->16379/tcp, 127.0.0.1:26381->26379/tcp   localhost.localdomain/redismaster3
  085b750909d5        jayjohnson/redis-clusterable   "/bin/sh -c '. /bin/s"   4 minutes ago       Up 4 minutes        127.0.0.1:6379->6379/tcp, 127.0.0.1:16379->16379/tcp, 127.0.0.1:26379->26379/tcp   localhost.localdomain/redismaster1
  $
  ```

### Confirm the Redis Cluster using the Command Line Tool


```
$ redis-cli -h 127.0.0.1 -p 6384 cluster nodes
aa81e0dc13f4985dd0b70647d338f899454326af :6379 myself,master - 0 0 6 connected
$ 
```

### Inspect the Redis Cluster Details

```
$ ./cst.sh 

Printing Redis Cluster Status:

redismaster1(6379):
399de28f4b010ae4395db704887bfdea92aa2144 :6379 myself,master - 0 0 1 connected 0-5460

redismaster2(6380):
1c62661d9235463b5f3906a687ddc4010444f4ac :6379 myself,master - 0 0 2 connected 5461-10922

redismaster3(6381):
6fc1dda1fec41b4fbb0654d926dbfe17700c412b :6379 myself,master - 0 0 3 connected 10923-16383

redisreplica1(6382):
fffa24ec3a9d8485e63bf4e0d09bb2428ca7851b :6379 myself,master - 0 0 4 connected

redisreplica2(6383):
bb6844f7b7a3ccc1c0bc392461d342037916b903 :6379 myself,master - 0 0 5 connected

redisreplica3(6384):
c05e9a770e8aa11d82793f2d1076b7a94334d83c :6379 myself,master - 0 0 6 connected


Done
$
```

### Stop the Redis Cluster

```
$ ./stop_cluster.sh 
Stopping the Cluster on Docker Swarm
Stopping redisreplica3 ... done
Stopping redisreplica2 ... done
Stopping redisreplica1 ... done
Stopping redismaster2 ... done
Stopping redismaster3 ... done
Stopping redismaster1 ... done
Cleaning up old containers for ports
Done
$
```

