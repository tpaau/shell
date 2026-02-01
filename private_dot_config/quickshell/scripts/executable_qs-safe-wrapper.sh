#!/usr/bin/env bash

SLEEP_TIME=3
SLEPT=false

send_warning() {
	summary="$1"
	body="$2"
	notify-send \
		-u critical \
		-a "Quickshell wrapper" \
		"$summary" \
		"$body"
}

maybe_sleep() {
	if [[ $SLEPT == false ]]; then
		SLEPT=true
		sleep $SLEEP_TIME
	fi
}

run_checks() {
	if ! swaylock -v >/dev/null 2>&1; then
		maybe_sleep
		send_warning \
			"Swaylock not found" \
			"The \`swaylock\` command was not found on your system. Please install it to ensure that your session will be locked if the Quickshell process stops."
	fi

	if [[ -w "$(which qs)" ]]; then
		maybe_sleep
		send_warning \
			"Quickshell binary is writable" \
			"The Quickshell binary in $(which qs) is writable by the current user. This can be exploited to bypass lockdown mode. Please make sure the file is only writable by root."
	fi

	# TODO: Check if any of the Niri binaries are writable by the current user
}

run_checks &

qs kill >/dev/null 2>&1
qs; ~/.config/quickshell/scripts/lock-screen.sh
