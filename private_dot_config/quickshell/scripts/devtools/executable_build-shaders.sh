#!/usr/bin/env bash

SRC_DIR="shaders"
DST_DIR="shaders/qsb"

NAMES=("parallax.vert" "parallax.frag")

main() {
	mkdir -p "$DST_DIR" || return 1
	for shader in "${NAMES[@]}"
	do
		qsb-qt6 --glsl "440,330,150" -o "$DST_DIR/$shader.qsb" "$SRC_DIR/$shader"
	done

	echo "done" >&2
}

main "$@"
