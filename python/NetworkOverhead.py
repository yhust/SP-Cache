
import numpy
import os
import sys
from os.path import dirname
import subprocess
import time

'''
Measure the network overhead with different partition numbers from 1-30
'''


def NetworkOverhead(totalCount):


    tests_dir = os.path.expanduser('~') # for Linux
    #tests_dir = os.getcwd() # for mac OS
    print "tests dir:" + tests_dir

    #fw = open(tests_dir+"/test_files/popularity.txt", "r")


    #print popularity
    for fileId in range(0, 30):
        for i in range(0, totalCount):
            # get a file id from the popularity
            os.system('bin/alluxio runSPReadExecutor %s' % fileId)

    os.system('echo "All read requests submitted!" ')

if __name__ == "__main__":
    NetworkOverhead(int(sys.argv[1]))
