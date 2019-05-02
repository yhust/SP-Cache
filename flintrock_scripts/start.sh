#!/bin/bash


# clone sp-cache and compile
clustername=$1

flintrock run-command $clustername 'git clone '

# clear existing logs
python3 $(cd `dirname $0`; cd ..; pwd)/flintrock/standalone.py run-command gtcs "rm *.txt;rm  ~/alluxio-gtcs/*.txt;rm  ~/alluxio-gtcs/logs/*.out;rm ~/alluxio-gtcs/logs/*.log; rm ~/alluxio-gtcs/python/OpuS_log.txt;rm ~/alluxio-gtcs/python/FairRide_log.txt;"

python3 $(cd `dirname $0`; cd ..; pwd)/flintrock/standalone.py describe gtcs

# start
read -r line < $(cd `dirname $0`; cd ..; pwd)/flintrock/flintrock.txt

python3 $(cd `dirname $0`; cd ..; pwd)/flintrock/standalone.py run-command gtcs "cp ~/alluxio-gtcs/conf/alluxio-site.properties.template ~/alluxio-gtcs/conf/alluxio-site.properties; cp ~/alluxio-gtcs/conf/alluxio-env.sh.template ~/alluxio-gtcs/conf/alluxio-env.sh; echo 'alluxio.master.hostname=${line:9}' >> ~/alluxio-gtcs/conf/alluxio-site.properties; echo 'alluxio.underfs.address=hdfs://${line:9}:9000'>> ~/alluxio-gtcs/conf/alluxio-site.properties; echo ${line:9} > ~/alluxio-gtcs/conf/masters;rm  ~/alluxio-gtcs/conf/workers;touch ~/alluxio-gtcs/conf/workers"

# python3 $(cd `dirname $0`; cd ..; pwd)/flintrock/standalone.py run-command gtcs ""

i=1
value='\n'
while read -r line
do
    test $i -lt 2 && let "i++" && continue
    test $i -gt $[1+$1] && let "i++" && continue
    value=${value}"\n"${line:9}
    let "i++"
done < $(cd `dirname $0`; cd ..; pwd)/flintrock/flintrock.txt

python3 $(cd `dirname $0`; cd ..; pwd)/flintrock/standalone.py run-command gtcs "echo -e '${value}' >> ~/alluxio-gtcs/conf/workers"


read -r line < $(cd `dirname $0`; cd ..; pwd)/flintrock/flintrock.txt
ssh -o StrictHostKeyChecking=no -i $flintrockPemPath ${line} "sh ~/hadoop/sbin/stop-dfs.sh;sh ~/hadoop/sbin/start-dfs.sh;~/alluxio-gtcs/bin/alluxio format;~/alluxio-gtcs/bin/alluxio-start.sh all SudoMount"

sh $(cd `dirname $0`; pwd)/runClients.sh $1

# sh ~/hadoop/sbin/stop-dfs.sh;sh ~/hadoop/sbin/start-dfs.sh;
#python3 $(cd `dirname $0`; cd ..; pwd)/flintrock/standalone.py run-command gtcs "chmod -R 770 /mnt/"

# i=1
# while read -r line
# do
#     test $i -le 1 && let "i++" && continue
#     test $i -gt $[1+$1] && let "i++" && continue
#     ssh -o StrictHostKeyChecking=no -i .ssh/gtcs.pem ${line} "~/alluxio-gtcs/bin/alluxio-start.sh worker SudoMount"
#     let "i++"
# done < $(cd `dirname $0`; cd ..; pwd)/flintrock/flintrock.txt



exit 0
