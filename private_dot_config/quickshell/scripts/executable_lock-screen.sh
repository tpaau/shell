#!/usr/bin/env bash

# Wrapper for Quickshell's IPC screen locking.
#
# Use this instead of `qs ipc call sessionLock unsafeLock`.
#
# Return values:
# 	- 0 -> Session was locked successfully or a fallback lock was used
# 	- 1 -> Session was left unlocked

function tryFallbackLock() {
	swaylock &
}

function main() {
	qs ipc call sessionLock unsafeLock >/dev/null 2>&1
	tryFallbackLock >/dev/null 2>&1

	local qsLocked
	qsLocked="$(qs ipc prop get sessionLock isLocked)"

	if [[ "$qsLocked" == true ]]; then
		echo "Locked successfully!" >&2
		# Ensure Quickshell has the time to load the lock surface on slower
		# drives before the system goes to sleep.
		sleep 1
		return 0
	elif pgrep "swaylock"; then
		echo "Fallback lock used!" >&2
		notify-send -u critical "Session lock failed" "The Quickshell lock has failed, and a fallback lock was used instead. Please check the logs and diagnose this potentially dangerous issue."
		return 0
	else
		echo "Session left unlocked!" >&2
		notify-send -u critical "Session left unlocked" "The Quickshell lock has failed, and a fallback lock could not be used! Check the Quickshell locks and ensure the fallback lock app is installed!"
	fi
	return 1
}

main
