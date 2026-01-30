#!/usr/bin/env bash

FMT=""
if qmlfmt --help >/dev/null 2>&1; then
	FMT="qmlfmt"
elif qmlformat --help >/dev/null 2>&1; then
	FMT="qmlformat"
elif qmlformat-qt6 --help >/dev/null 2>&1; then
	FMT="qmlformat-qt6"
fi

if [[ "$1" == "check" || "$1" == "--check" || "$1" == "-c" ]]; then
	echo "Checking QML format..." >&2
	while IFS= read -r -d "" file; do
		out="$("$FMT" -t --semicolon-rule essential "$file" 2>&1)"
		if [[ "$out" != "$(cat "$file")" ]]; then
			echo "Expected $out" >&2
			echo "Got: $(cat "$file")" >&2
			echo "Run \`$(basename "$0")\` without the \`--check\` flag to format" >&2
			exit 1
		fi
	done < <(find private_dot_config/quickshell/ -name "*.qml" -print0)
else
	echo "Formatting QML code..." >&2
	while IFS= read -r -d "" file; do
		"$FMT" -i -t --semicolon-rule essential "$file"
	done < <(find private_dot_config/quickshell/ -name "*.qml" -print0)
fi
