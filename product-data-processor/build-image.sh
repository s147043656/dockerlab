#!/bin/bash

cwd=`dirname $0`
cd ${cwd}
baseDir=`pwd`
imageName=`basename ${baseDir}`
dockRepo=/home/tomcat/dock-repo
packageName=product-data-processor-1.3.2.tar.gz

echo -e "\nBuilding ${imageName} image named: ${imageName}"

if [ -f ${packageName} ]; then
  rm -f ${packageName}
fi

cp $dockRepo/${packageName} .

docker rmi ${imageName}
docker build . -t ${imageName}

rm -f ${packageName}