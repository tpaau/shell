#!/usr/bin/env bash

# Wrapper for Quickshell's IPC screen locking.
#
# Use this instead of `qs ipc call sessionLock lock`.
#
# Return values:
# 	- 0 -> Session was locked successfully or a fallback lock was used
# 	- 1 -> Session was left unlocked

function tryFallbackLock() {
	swaylock &
	waylock &
	hyprlock &
	return 0
}

function isSessionLocked() {
	if pgrep "swaylock" || pgrep "waylock" || pgrep "hyprlock"; then
		return 0
	fi
	return 1
}

function main() {
	qs ipc call sessionLock lock >/dev/null
	tryFallbackLock >/dev/null 2>&1 &

	local qsLocked
	qsLocked="$(qs ipc call sessionLock isLocked)"

	if [[ "$qsLocked" == true ]]; then
		echo "Locked successfully!" >&2
		# Ensure Quickshell has the time to load the session lock before the
		# system goes to sleep on slower drives.
		sleep 1
		return 0
	else
		if isSessionLocked >/dev/null 2>&1; then
			echo "Fallback lock used!"
			notify-send -u critical "Session lock failed" "The Quickshell lock has failed. Fallback lock was run. Please check the logs and diagnose this potentially dangerous issue."
			return 0
		fi
		echo "Fallback lock failed!"
		notify-send -u critical "Backup lock failed" "The backup lock has failed, likely leaving your session unlocked. Please diagnose this issue immediately!"
		return 1
	fi
}

main
