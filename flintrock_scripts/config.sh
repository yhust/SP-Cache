#!/bin/bash

clustername=$1
masterhost=$2
# compile sp-cache
#flintrock run-command $clustername "cd SP-Cache;mvn clean install -DskipTests=true -Dlicense.skip=true -Dcheckstyle.skip -Dmaven.javadoc.skip=true"


# configure master and workers 
#flintrock run-command $clustername "cp ~/SP-Cache/conf/alluxio-site.properties.template ~/SP-Cache/conf/alluxio-site.properties; cp ~/SP-Cache/conf/alluxio-env.sh.template ~/SP-Cache/conf/alluxio-env.sh;echo 'alluxio.master.hostname=$masterhost' >> ~/SP-Cache/conf/alluxio-site.properties;

flintrock run-command $clustername "rm ~/SP-Cache/conf/alluxio-env.sh; ~/SP-Cache/bin/alluxio bootstrapConf $masterhost;echo $masterhost > ~/SP-Cache/conf/masters;cp ~/hadoop/conf/slaves ~/SP-Cache/conf/workers"

exit 0
