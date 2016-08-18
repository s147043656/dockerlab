#!/bin/bash

appDir=/data01/microservices
javaParam=`head -1 ${appDir}/javaparameters.conf`
appName=${appDir}/product-data-processor
appVer=1.3.2
confName=${appDir}/conf

exec java ${javaParam} -jar ${appName}-${appVer}.jar --spring.config.name=${confName} >> /dev/null 2>&1 && tail -f /dev/null
