#!/usr/bin/env bash

if grep -rP "currentText == \"[^\"]*\"" config/quickshell; then
	echo "Remove this before committing."
	exit 1
else
	echo "Ok" >&2
fi
