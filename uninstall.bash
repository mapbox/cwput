#!/usr/bin/env bash
if  [[ $(id -u) -ne 0 ]]; then
        echo "not root, please su up and rerun script"
        exit 1
fi

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

init=`lsof -w -a -p 1 -d txt`

if [[ $init =~ systemd ]]; then
    systemctl stop cwput
    rm /etc/systemd/system
elif [[ $init =~ launchd ]]; then
    launchctl unload /Library/LaunchDaemons/com.mapbox.cwput.plist
    rm /Library/LaunchDaemons/com.mapbox.cwput.plist
    rm /tmp/cwput.out
    rm /tmp/cwput.err
else
    stop cwput
    rm /etc/init/cwput.conf
fi
if [[ "$OSTYPE" =~ darwin ]]; then
    rm /usr/local/bin/cwput.bash
    rm /usr/local/bin/cwput.start
else
  rm /usr/bin/cwput.bash
  rm /usr/bin/cwput.start
fi

rm -Rf /etc/cwput
