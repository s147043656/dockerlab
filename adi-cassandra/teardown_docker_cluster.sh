#!/bin/sh

NUM_NODES=$1

if [ -z "$NUM_NODES" ]; then
  echo "usage teardown_docker_cluster.sh NumNodes"
  echo "  NumNodes the number of nodes started when using start_docker_cluster.sh"
  exit 1
fi

let n=1
let NUM_NODES=NUM_NODES+1

while [ $n != $NUM_NODES ]; do
  echo "Stop node${n}"
  docker stop node${n}
  echo "Remove node${n}"
  docker rm node${n}
  let n=n+1
done

