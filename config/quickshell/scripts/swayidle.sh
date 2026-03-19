#!/usr/bin/env bash

killall "swayidle"

SCRIPTS="$(dirname "$0")"

(swayidle -w\
	timeout 300 "$SCRIPTS/lock-screen.sh"\
	before-sleep "$SCRIPTS/lock-screen.sh"\
	lock "$SCRIPTS/lock-screen.sh") &

swayidle \
	timeout 240 "brightnessctl -s s 1%" \
	resume "brightnessctl -r" \
	timeout 250 "niri msg action power-off-monitors" \
	timeout 260 "systemctl sleep" \
	resume "brightnessctl -r"
