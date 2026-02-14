#!/usr/bin/env bash

no_fail=false
if [[ "$1" == "--no-fail" ]]; then
	no_fail=true
fi

DIR="private_dot_config/quickshell/"

content="$(find "$DIR" -type f -name "*.qml" -exec cat {} \;)"

found=false

while IFS= read -r -d "" file; do 
	name="$(basename "$file" .qml)"
	if ! echo "$content" | grep -q -e "$name\." -e "$name{" -e "$name {"; then
		echo "Found unused file: $(basename "$file")" >&2
		found=true
	fi
done < <(find "$DIR" -name "*.qml" -print0)

if [[ $found == false ]]; then
	echo "No unused QML files found" >&2
	exit 0
else
	if [[ $no_fail == false ]]; then
		exit 1
	else
		echo "Exiting with status code 0 because the \`--no-fail\` argument was passed"
	fi
fi
