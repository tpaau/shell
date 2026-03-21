#!/usr/bin/env bash

ARGS=("-t" "--semicolon-rule" "essential")
FMT=""
if command -v qmlformat >/dev/null 2>&1; then
	FMT="qmlformat"
elif command -v qmlformat-qt6 >/dev/null 2>&1; then
	FMT="qmlformat-qt6"
else
	echo "No QML formatter found" >&2
	exit 1
fi

if [[ "$FMT" == "check" || "$1" == "--check" || "$1" == "-c" ]]; then
	echo "Checking QML format..." >&2
	while IFS= read -r -d "" file; do
		out="$("$FMT" "${ARGS[@]}" "$file" 2>&1)"
		if [[ "$out" != "$(cat "$file")" ]]; then
			echo "Expected: $out" >&2
			echo "Got: $(cat "$file")" >&2
			echo "Run \`$(basename "$0")\` without the \`--check\` flag to format" >&2
			exit 1
		fi
	done < <(find config/quickshell/ -name "*.qml" -print0)
else
	echo "Formatting QML code..." >&2
	while IFS= read -r -d "" file; do
		"$FMT" -i "${ARGS[@]}" "$file"
	done < <(find config/quickshell/ -name "*.qml" -print0)
fi
