#!/usr/bin/env bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cp $dir/bin/cwput.bash /usr/bin
cp $dir/etc/cwput.conf /etc/init
mkdir /etc/cwput
cp -r $dir/etc/checks /etc/cwput
start cwput
