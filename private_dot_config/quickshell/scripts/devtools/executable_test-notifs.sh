#!/usr/bin/env bash

COUNT=5
APP="App"
SUMMARY="This is a test summary. It's intentionally long to test text wrapping".
BODY="This is some really long text to test how the notification content behaves, how it wraps and trims the text, etc."

i=0
while (( i < COUNT )); do
	notify-send -u low -a "$APP 1" "$SUMMARY" "$BODY"
	(( i++ ))
done

i=0
while (( i < COUNT )); do
	notify-send -u normal -a "$APP 2" "$SUMMARY" "$BODY"
	(( i++ ))
done

i=0
while (( i < COUNT )); do
	notify-send -u critical -a "$APP 3" "$SUMMARY" "$BODY"
	(( i++ ))
done
