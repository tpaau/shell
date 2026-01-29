#!/usr/bin/env bash

if grep -rP "currentText == \"[^\"]*\"" .; then
	echo "Remove this before committing."
	exit 1
else
	echo "Ok" >&2
fi
