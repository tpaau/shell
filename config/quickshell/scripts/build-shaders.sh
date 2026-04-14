#!/usr/bin/env bash

SRC_DIR="assets/shaders"
DST_DIR="$HOME/.cache/tpaau-shell/shaders-qsb"

NAMES=("parallax.vert" "parallax.frag" "ripple.frag" "ripple_sparks.frag")

main() {
	local rebuild_if_missing=false
	local msg="done"
	if (( $# == 0 || $# > 1 )); then
		echo "error: Expected exactly one argument!" >&2
		return 1
	else
		if [[ "$1" == "rebuild-if-missing" ]]; then
			rebuild_if_missing=true
			msg="Rebuilt missing shaders"
		elif [[ "$1" == "rebuild" ]]; then
			rm -rf "$DST_DIR"
			msg="Rebuilt all shaders"
		else
			echo "error: Unknown argument: \"$1\""
			return 1
		fi
	fi

	mkdir -p "$DST_DIR" || return 1
	for shader in "${NAMES[@]}"; do
		local src="$SRC_DIR/$shader"
		local dst="$DST_DIR/$shader.qsb"
		if [[ $rebuild_if_missing == true && -f "$dst" ]]; then
			continue
		fi
		qsb-qt6 --glsl "100 es,120,150" --batchable -o "$dst" "$src"
	done
	echo "$msg" >&2
}

main "$@"
