#!/bin/bash


# clone sp-cache and compile
clustername=$1

#install necessary packages
flintrock run-command $clustername 'sudo yum update -y;sudo yum install java-1.8.0-openjdk* -y;export JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk";sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo;sudo sed -i s/\$releasever/7/g /etc/yum.repos.d/epel-apache-maven.repo;sudo yum -y install apache-maven;sudo yum -y install git;sudo yum -y install python2-pip;sudo yum -y install gcc-c++;'


# download sp-cache
flintrock run-command $clustername "sudo rm -R ~/SP-Cache; git clone https://github.com/yhust/SP-Cache.git;"



exit 0
