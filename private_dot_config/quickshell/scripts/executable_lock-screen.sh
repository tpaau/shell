#!/usr/bin/env bash

result="$(qs ipc call sessionLock lock)" || swaylock
if (( result != 0 )); then
	swaylock
fi
