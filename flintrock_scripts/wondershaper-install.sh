#!/bin/bash

clustername=$1

flintrock run-command $clustername "yum -y install tc iper3; git clone  https://github.com/magnific0/wondershaper.git; cd wondershaper;make install;"

exit 0


