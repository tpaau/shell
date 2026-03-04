#!/usr/bin/env bash

SLEEP_TIME=3
SLEPT=false
SHELL_NAME="tpaau-shell"

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
}

run_checks &

mkdir -p "$HOME/.config/$SHELL_NAME"
mkdir -p "$HOME/.cache/$SHELL_NAME"
~/.config/quickshell/scripts/build-shaders.sh rebuild-if-missing &
qs kill >/dev/null 2>&1
qs; ~/.config/quickshell/scripts/lock-screen.sh
