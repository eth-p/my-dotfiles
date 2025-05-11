# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles

# ------------------------------------------------------------------------------

# @section prints a section header.
# This is used to describe the upcoming actions.
__first_section=true
@section() {
	if ! "$__first_section"; then
		printf "\n"
	fi

	printf "\033[1;36m==> %s\033[m\n" "$1" 1>&2
	__first_section=false
}

# @notice prints a message.
# This is used to inform the user of some outcome.
@notice() {
	printf "\033[1;34m[!] \033[0;34m%s\033[m\n" "$1" 1>&2
}

# ------------------------------------------------------------------------------

@create-and-overwrite() {
	if test -f "$1"; then
		@notice "updating $1"
		cat >"$1"
	else
		@notice "creating $1"
		cat >"$1"
	fi
}

@create-if-missing() {
	if test -f "$1"; then
		@notice "$1 already exists"
		return 0
	fi

	@notice "creating $1"
	cat >"$1"
}

@link-if-missing() {
	if test -f "$1"; then
		@notice "$1 already exists"
		return 0
	fi

	@notice "linking $1 -> $2"
	mkdir -p "$(dirname "$1")"
	ln -s "$2" "$1"
}

# ------------------------------------------------------------------------------

# @cleanup-file adds a file/directory to be removed when the script exits.
@cleanup-file() {
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
