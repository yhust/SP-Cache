#!/bin/bash



# Prepare test files
# $1: filesize in MB, $2: zipfFactor
python python/SPTestSetUp.py $1 $2

# Synchronize the test fold
rm /root/test_files/test_local_file
/root/spark-ec2/copy-dir /root/test_files


echo Done
