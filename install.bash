#!/usr/bin/env bash

if  [[ $(id -u) -ne 0 ]]; then
        echo "not root, please su up and rerun script"
        exit 1
fi

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cp $dir/bin/cwput.bash /usr/bin
cp $dir/bin/cwput.start /usr/bin


mkdir -p /etc/cwput
if [[ "$OSTYPE" =~ darwin ]]; then
    cp -r $dir/etc/darwin/checks /etc/cwput
else
    cp -r $dir/etc/linux/checks /etc/cwput
fi

init=`lsof -w -a -p 1 -d txt`

if [[ $init =~ systemd ]]; then
    cp $dir/bin/cwput.start /usr/bin/cwput.start
    cp $dir/etc/cwput.service /etc/systemd/system
    systemctl start cwput
elif [[ $init =~ launchd ]]; then
    cp $dir/bin/cwput.start /usr/bin/cwput.start
    cp $dir/etc/com.mapbox.cwput.plist /Library/LaunchDaemons
    launchctl load /Library/LaunchDaemons/com.mapbox.cwput.plist
else
    cp $dir/etc/cwput.conf /etc/init
    start cwput
fi
