#!/bin/bash

#scriptDir=`dirname $0`
dockerComposeDir=~/dock-comp
#cd $scriptDir && cd ../$1
cd $dockerComposeDir/$1
docker build . -t $1
