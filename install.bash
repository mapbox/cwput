#!/usr/bin/env bash

cp ./bin/cwput.bash /usr/bin
cp ./etc/cwput.conf /etc/init
mkdir /etc/cwput
cp -r ./etc/checks /etc/cwput
start cwput
