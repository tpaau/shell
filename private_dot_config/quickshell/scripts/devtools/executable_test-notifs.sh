#!/usr/bin/env bash

COUNT=5

i=0
while (( i < COUNT )); do
	notify-send -u low -a "App1" "Test summary" "Test body"
	(( i++ ))
done

i=0
while (( i < COUNT )); do
	notify-send -u normal -a "App2" "Test summary" "Test body"
	(( i++ ))
done

i=0
while (( i < COUNT )); do
	notify-send -u critical -a "App3" "Test summary" "Test body"
	(( i++ ))
done
