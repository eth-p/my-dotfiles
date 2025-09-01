# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Utility functions for Bash-related things.
# ==============================================================================
# shellcheck shell=bash source-path=../../
if test -n "${__guard_lib_bash:-}"; then return 0; fi
__guard_lib_bash="${BASH_SOURCE[0]}"
# ==============================================================================

# print_and_redefine prints a message and redefines a function to print
# the same message every time it's called.
print_and_redefine() {
	printf "%s\n" "$2"
	eval "$(printf "%s() { printf '%%s\\\\n' %q ; }" "$1" "$2")"
}
