# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Wrappers for running Nix commands or nix-shell programs without having my
# configuration fully set up.
# ==============================================================================
if test -n "${__guard_lib_system:-}"; then return 0; fi
__guard_lib_system="${BASH_SOURCE[0]}"
# ==============================================================================

user_homedir() {
	if test -n "$HOME"; then
		printf "%s\n" "$HOME"
	else
		eval "$(printf 'printf "%%s\n" %q' "$(user_username)")"
	fi
}

user_username() {
	id -un
}

is_steamos() {
	test -f /etc/steamos-release || return 1
	return 0
}
