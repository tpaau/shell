#!/usr/bin/env bash

TARGET="$HOME/.config/quickshell/"
EXCLUDE="$HOME/.config/quickshell/.qmlls.ini"

print_usage() {
	echo "Usage: $(basename "$0") [COMMAND]" >&2
	echo "" >&2
	echo "Commands:" >&2
	echo "  help, --help, -h        Show this message and exit" >&2
	echo "  status                  Get shell source lockdown status" >&2
	echo "  enable                  Enable shell source lockdown" >&2
	echo "  disable                 Disable shell source lockdown" >&2
}

lockdown_status() {
	local mutable=()
	local immutable=()

	while IFS= read -r -d '' item; do
		if [[ "$item" == "$EXCLUDE" ]]; then
			continue
		elif lsattr -d "$item" 2>/dev/null | cut -d " " -f1 | grep -q "i"; then
			immutable+=("$item")
		else
			mutable+=("$item")
		fi
	done < <(find "$TARGET" -print0)

	if (( ${#mutable[@]} == 0 )); then
		if (( ${#immutable} == 0 )); then
			echo "error: No files could be scanned" >&2
			return 1
		else
			echo "Lockdown enabled, $(( ${#mutable} + ${#immutable} )) files scanned." >&2
			return 0
		fi
	else
		if (( ${#immutable} > 0 )); then
			echo "error: Lockdown is partially enabled" >&2
			echo "Mutable files/directories:" >&2
			for item in "${mutable[@]}"; do
			  echo "  $item" >&2
			done
			echo "Immutable files/directories:" >&2
			for item in "${immutable[@]}"; do
			  echo "  $item" >&2
			done
		else
			echo "Lockdown disabled" >&2
		fi
	fi
}

main() {
	if (( $# != 1 )); then
		print_usage
		echo ""
		echo "error: Expected exactly one argument!" >&2
		return 1
	else
		if [[ "$1" == "-h" || "$1" == "--help" || "$1" == "help" ]]; then
			print_usage
			return 0
		elif [[ "$1" == "status" ]]; then
			lockdown_status
			return $?
		elif [[ "$1" == "enable" ]]; then
			run0 chattr -fR +i "$TARGET" >/dev/null 2>&1
			lockdown_status
			return $?
		elif [[ "$1" == "disable" ]]; then
			run0 chattr -fR -i "$TARGET" >/dev/null 2>&1
			lockdown_status
			return $?
		fi
	fi
}

main "$@"
