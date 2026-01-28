#!/usr/bin/env bash

check_swaylock() {
	if ! swaylock -v >/dev/null 2>&1; then
		sleep 3; notify-send \
			-u critical \
			-a "Quickshell wrapper" \
			"Swaylock not found" "The \`swaylock\` command was not found on your system. Please install it to ensure that your session will be locked if the Quickshell process stops."
	fi
}

check_swaylock &

qs; ~/.config/quickshell/scripts/lock-screen.sh
