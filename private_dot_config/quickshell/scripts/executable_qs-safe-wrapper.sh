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

	# TODO: Check if swaylock is writable
	# TODO: Check if Quickshell is writable
	# TODO: Check if any of the Niri binaries are writable
}

run_checks &

qs kill >/dev/null 2>&1
qs; ~/.config/quickshell/scripts/lock-screen.sh
