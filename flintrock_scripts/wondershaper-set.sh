#!/bin/bash

clustername=$1
bandwidth=$2  #kbps

flintrock run-command $clustername "sudo wondershaper -a eth0 -u $bandwidth -d $bandwidth"

exit 0


