#!/usr/bin/env bash

CONFIG_FILE="$HOME/.config/quickshell/cache/config.json"
term_app="$(jq -r ".preferences.terminalApp" "$CONFIG_FILE")"
"$term_app" "$@"
