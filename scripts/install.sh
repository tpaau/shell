#!/usr/bin/env bash

ebold() {
	echo -e "\e[1m$1\e[0m" >&2
}

print_help() {
	echo "Usage: $(basename "$0") [COMMAND]"
	echo ""
	echo "Commands:"
	echo "  -h, --help, help: Print this help message and exit"
	echo "  deps: Install the dependencies for your OS (if supported)"
	echo "  dots: Install the configuration files from this repo"
	echo "  all: Install both the dependencies and the config files"
}

install_deps() {
	echo "info: Installing dependencies" >&2
}

install_dots() {
	echo "info: Installing dotfiles" >&2
}

if [[ $# != 1 ]]; then
	echo "error: expected exactly one argument!" >&2
	exit 1
elif [[ "$1" == "-h" || "$1" == "--help" || "$1" == "help" ]]; then
	print_help
	exit $?
elif [[ "$1" == "deps" || "$1" == "dots" || "$1" == "all" ]]; then
	ebold "This project is in very early development. Only run this if you know what you're doing!"
	echo "" >&2
	ebold "This script is not designed to, but may arase some data from your device!"
	ebold "PLEASE ONLY ATTEMPT INSTALLATION ON A FRESH OS INSTALL"
	read -rp "Do you wish to continue? [y/N]: " choice 

	case $choice in
		[yY]* ) echo "Proceeding." ;;
		[nN]* ) echo "Aborting."; exit ;;
		*) echo "Aborting."; exit ;;
	esac

	if [[ "$1" == "deps" ]]; then
		install_deps
		exit $?
	elif [[ "$1" == "dots" ]]; then
		install_dots
		exit $?
	elif [[ "$1" == "all" ]]; then
		install_deps && install_dots
		exit $?
	fi
else
	echo "error: unexpected argument \"$1\"" >&2
	echo "hint: pass the \"help\" command for more options"
	exit 1
fi
