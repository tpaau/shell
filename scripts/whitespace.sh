#!/usr/bin/env bash

out="$(find . -path ./\.git -prune -o -type f -print0 \
	| xargs -0 grep -nH --color=always -P --binary-files=without-match '[ \t]+$')"

echo -n "$out" >&2

if [[ "$out" == "" ]]; then
	echo "Ok" >&2
	exit 0
else
	exit 1
fi
