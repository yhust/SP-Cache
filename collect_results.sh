#!/bin/bash


# $1 is the first parameter means the number of clients
# run read tests on the last $1 slaves
read -ra slave_arr -d '' <<<"$SLAVES"
#SCRIPT="cd alluxio-load-balancing; ./bin/alluxio readTest &>/dev/null &"
for ((i = 30; i <= $1 + 29; i++))
do
    echo $i
    slave="${slave_arr[$i]}"
    echo $slave
    #scp root@${slave_arr[$i]}:/root/alluxio-load-balancing/test_files/readTimes.txt test_files/$i.txt
    scp root@${slave_arr[$i]}:/root/alluxio-load-balancing/logs/readLatency.txt /root/alluxio-load-balancing/results/$i.txt
done

# Collect all the results into a single file for the convience
cd results
rm all_results.txt
cat *.txt > all_results.txt
cd ..

