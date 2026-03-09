#!/usr/bin/env bash

# Wrapper script for the Depth Anything project. Requires the actual project to
# be cloned to `~/Downloads`. You can clone it from
# https://github.com/LiheYoung/Depth-Anything

RUN_DIR="$HOME/Downloads/Depth-Anything/"

main() {
	if [[ "$1" == "" ]]; then
		echo "Expected exactly one argument!" >&2
		return 1
	else
		local source_path="$1"
		local cwd
		cwd="$(pwd)"
		cd "$RUN_DIR" || return 1
	fi

	python run.py --grayscale --pred-only --encoder vitl --img-path "$cwd/$source_path" --outdir "$cwd"

	cd "$cwd" || return 1
}

main "$@"
