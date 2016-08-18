#!/bin/bash

composeDir=/home/tomcat/dock-comp
deployList=`cat /$composeDir/deployment-list.txt | xargs`

echo -e "\nStarting docker deployments for: \n${deployList}\n"

for item in ${deployList}; do
  liveContainers=`docker ps | grep ${item} | awk '{print $1}' | xargs`
  docker stop ${liveContainers}
  stoppedContainers=`docker ps -a | grep ${item} | awk '{print $1}' | xargs`
  docker rm ${stoppedContainers}
  ${composeDir}/${item}/build-image.sh
done

docker-compose up -d

for seconds in 00 10 20 30 40 50 60; do
  echo -e "\n${seconds} seconds ================================================================"
  docker ps -a
  sleep 10
done
