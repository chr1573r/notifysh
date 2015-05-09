#!/bin/bash

# notify.sh - consoleX notification screen plugin

# Blinks in red/black if notifytxt file exist.
# If notification is awknowledged, notifytxt is deleted
# and notify.sh is terminated

trap "{ reset; clear; exit; }" SIGINT SIGTERM EXIT

notifytxt="~/container/persistent/notifysh/notify.txt"
alternate=true

function flasher {
	clear
	if [[ "$alternate" == true ]]; then
		tput setab 1
		alternate=false
	else
		tput setab 0
		alternate=true
	fi
	clear
	cat $notifytxt
	ackget

}

function ackget {
	if [ -f "bin/readTouch.py" ]; then
		echo "   ## Press & hold touchscreen to dismiss ##"
		sudo python ./bin/readTouch.py
		if [[ "$?" == "0" ]]; then
			rm $notifytxt
			exit
		fi
	else
		read -t 1 -n 1 -s -p "   ## Press any key to dismiss ##"
		if [[ "$?" == "0" ]]; then
			rm $notifytxt
			exit
		fi
	fi
}

while [ -f "$notifytxt" ] ; do
	clear
	tput setaf 7
	flasher
done