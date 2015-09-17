#!/usr/bin/env bash

if  [[ $(id -u) -ne 0 ]]; then
        echo "not root, please su up and rerun script"
        exit 1
fi

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cp $dir/bin/cwput.bash /usr/bin
cp $dir/bin/cwput.start /usr/bin

mkdir -p /etc/cwput
cp -r $dir/etc/checks /etc/cwput

init=`lsof -w -a -p 1 -d txt`

if [[ $init =~ systemd ]]; then
    echo "systemd found"
    cp $dir/bin/cwput.start /usr/bin/cwput.start
    cp $dir/etc/cwput.service /etc/systemd/system
    systemctl start cwput
elif [[ $init =~ launchd ]]; then
    echo "launchd found"

else
    echo "upstart guessed"
    cp $dir/etc/cwput.conf /etc/init
    start cwput
fi
