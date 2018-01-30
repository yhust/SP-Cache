from scipy.stats import zipf
import os
from os.path import dirname
import numpy
import sys


'''
At master node
1. Prepare the test files;
    1.1 Generate the popularity (zipf distribution)
    1.2 decide k
    1.3 write files into Alluxio (overwrite)
2. Distribute the popularity file across the client cluster
'''

def SPTestSetUp(fileSize, zipfFactor): # file size in MB
    #settings
    fileNumber = 50
    #fileSize = 200 #MB
    #zipfFactor = 1.5
    machineNumber = 30
    SPFactor = 3



    # generate popularity vector
    popularity = list()
    for i in range(1, fileNumber+1 ,1):
        popularity.append(zipf.pmf(i, zipfFactor))
    popularity /= sum(popularity)


    tests_dir = os.path.expanduser('~') # for Linux
    #tests_dir = os.getcwd()# for mac OS
    print "tests dir:" + tests_dir

    if not os.path.exists(tests_dir+"/test_files"):
        os.makedirs(tests_dir+"/test_files")

    fw = open(tests_dir+"/test_files/popularity.txt", "wb")
    for item in popularity:
        fw.write("%s\n" % item)

    # calculate the partition_number, in the range of [1, machineNumber]
    #kVector = [max(min(int(popularity[id] * 100 * SPFactor), machineNumber),10) for id in range(0, fileNumber)]
    kVector =10* numpy.ones(fileNumber,dtype=numpy.int)
    # print partitionNumber
    fw = open(tests_dir+"/test_files/k.txt", "wb")
    for k in kVector:
        fw.write("%s\n" % k)
    fw.close()

    #create the file of given size
    with open(tests_dir+"/test_files/test_local_file", "wb") as out:
        out.seek((fileSize * 1000 * 1000) - 1)
        out.write('\0')
    out.close()

    # write the files to Alluxio given the kvalues profile
    # remember to add the path of alluxio
    os.system('alluxio runSPPrepareFile')

if __name__ == "__main__":
    SPTestSetUp(int(sys.argv[1]), float(sys.argv[2]))
