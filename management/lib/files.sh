# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Utility functions for manipulating files.
# ==============================================================================
# shellcheck shell=bash source-path=../../
if test -n "${__guard_lib_files:-}"; then return 0; fi
__guard_lib_files="${BASH_SOURCE[0]}"
# ==============================================================================
source "management/lib/print.sh"

create_and_overwrite() {
	if test -f "$1"; then
		show_notice "updating $1"
		cat >"$1"
	else
		show_notice "creating $1"
		mkdir -p "$(dirname -- "$1")"
		cat >"$1"
	fi
}

create_if_missing() {
	if test -f "$1"; then
		show_notice "$1 already exists"
		return 0
	fi

	show_notice "creating $1"
	mkdir -p "$(dirname -- "$1")"
	cat >"$1"
}

link_if_missing() {
	if test -f "$1"; then
		@notice "$1 already exists"
		return 0
	fi

	show_notice "linking $1 -> $2"
	mkdir -p "$(dirname "$1")"
	ln -s "$2" "$1"
}

# cleanup_file adds a file/directory to be removed when the script exits.
cleanup_file() {
	__tempdir_cleanup_any=true
	__tempdir_cleanup_files+=("$1")
}

__tempdir_cleanup_any=false
__tempdir_cleanup_files=()
__cleanup_hook() {
	if ! "${__tempdir_cleanup_any}"; then
		return
	fi

	@section "cleaning up"
	local dir
	for dir in "${__tempdir_cleanup_files[@]}"; do
		@notice "removing: $dir"
		rm -rf "$dir"
	done
}

trap __cleanup_hook EXIT
