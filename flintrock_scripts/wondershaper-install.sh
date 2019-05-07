#!/bin/bash

clustername=$1

flintrock run-command $clustername "sudo yum -y install tc iperf3; sudo rm -r wondershaper; git clone  https://github.com/magnific0/wondershaper.git; cd wondershaper;sudo make install;"

exit 0


