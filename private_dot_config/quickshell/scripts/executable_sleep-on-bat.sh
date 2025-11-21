#!/usr/bin/env bash

# This script is to be executed by a system idler like `swayidle` to ensure the
# system only goes to sleep when it's not plugged in.

# The time between checks in seconds
DELTA=10

# The time to system sleep, also in seconds
TIMEOUT=120

start()
{
	local countdown=$TIMEOUT
	while true; do
		if [[ "$(cat /sys/class/power_supply/AC/online)" == "1" ]]; then
			countdown=$TIMEOUT
		else
			if (( countdown <= 0 )); then
				countdown=$TIMEOUT
				systemctl sleep
			else
				countdown=$((countdown - DELTA))
			fi
		fi
		sleep $DELTA
	done
}

start
