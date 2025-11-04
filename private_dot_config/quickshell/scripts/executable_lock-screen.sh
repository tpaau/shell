#!/usr/bin/env bash

playerctl pause
qs ipc call sessionLock lock || swaylock
