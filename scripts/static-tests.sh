#!/usr/bin/env bash

out="$(find . -path ./\.git -prune -o -type f -not -name Notifications.qml \
	-not -name static-tests.sh -print0 \
	| xargs -0 grep -nH --color=always --binary-files=without-match "Cache\.notifications")"

echo -n "$out" >&2

if [[ "$out" == "" ]]; then
	echo "Ok, no \`Cache.notifications\` imports outside of \`Notifications\`." >&2
	exit 0
else
	exit 1
fi
