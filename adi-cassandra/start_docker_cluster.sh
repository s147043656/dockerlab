#!/bin/bash

# Provided without any warranty, these files are intended
# to accompany the whitepaper about DSE on Docker and are 
# not intended for production and are not actively maintained.

CASSANDRA_IMAGE=$1
NUM_NODES=$2
NODE_OPTS=$3

if [ -z "$CASSANDRA_IMAGE" ]; then
  echo "usage: start_docker_cluster.sh CassandraImageName [NumberOfNodes] [NodeOptions]"
  echo "  CassandraImageName   mandatory nam of docker image"
  echo "  NumberOfNodes how many nodes to start (default 3)"
  echo "  NodeOptions   additional options for the node (like -s or -g)"
  exit 1
fi

 [ -z "$NUM_NODES" ] && NUM_NODES=3
 [ -z "$CLUSTER_NAME" ] && CLUSTER_NAME="Test_Cluster"

echo "Run node node1"
docker run -d -t -e CLUSTER_NAME="$CLUSTER_NAME" --name node1 $CASSANDRA_IMAGE $NODE_OPTS

SEEDS=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' node1)

let n=1

while [ $n != $NUM_NODES ]; do
  let n=n+1
  echo "Run node node${n}"
  docker run -d -t -e SEEDS=$SEEDS -e CLUSTER_NAME="$CLUSTER_NAME" --name node${n} $CASSANDRA_IMAGE $NODE_OPTS
done
