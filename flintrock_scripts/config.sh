#!/bin/bash

clustername=$1
masterhost=$2
# compile sp-cache
flintrock run-command $clustername "cd SP-Cache;mvn clean install -DskipTests=true -Dlicense.skip=true -Dcheckstyle.skip -Dmaven.javadoc.skip=true"


# configure master and workers 

flintrock run-command $clustername "rm ~/SP-Cache/conf/alluxio-env.sh; ~/SP-Cache/bin/alluxio bootstrapConf $masterhost;echo $masterhost > ~/SP-Cache/conf/masters;cp ~/hadoop/conf/slaves ~/SP-Cache/conf/workers"

exit 0
