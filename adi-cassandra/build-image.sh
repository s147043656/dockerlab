#!/bin/bash

cassDist=apache-cassandra-3.7-bin.tar.gz
cassDir=apache-cassandra-bin

cwd=`dirname $0`
cd ${cwd}
baseDir=`pwd`
imageName=`basename ${baseDir}`

dockRepo=/home/tomcat/dock-repo
packageName=apache-cassandra-3.7-bin.tar.gz

echo -e "\nBuilding ${imageName} image named: ${imageName}"

if [ -f ${cassDist} ]; then
  rm -f ${cassDist}
fi

#wget "http://apache.cp.if.ua/cassandra/3.7/apache-cassandra-3.7-bin.tar.gz"
if [ -f ${packageName} ]; then
  rm -f ${packageName}
fi
cp $dockRepo/${packageName} .

if [ -d ${cassDir} ]; then
    rm -rf ${cassDir}
fi

tar -xzf ${cassDist}

tmpCassDir=`echo ${cassDist} | sed -e 's/\-bin\.tar\.gz//'`
mv ${tmpCassDir} ${cassDir}

if [ -f ${cassDir}.tar.gz ]; then
    rm -f ${cassDir}.tar.gz
fi

tar -czf ${cassDir}.tar.gz ${cassDir}

echo "Building CASSANDRA image named: cassandra"
docker rmi adi-cassandra
docker build . -t adi-cassandra && rm -rf $cassDir && rm -f ${cassDist}

rm -f ${packageName}