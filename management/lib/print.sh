# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Utility functions for printing output.
# ==============================================================================
if test -n "${__guard_lib_print:-}"; then return 0; fi
__guard_lib_print="${BASH_SOURCE[0]}"
# ==============================================================================

# show_section prints a section header.
# This is used to describe the upcoming actions.
__first_section=true
show_section() {
	if ! "$__first_section"; then
		printf "\n"
	fi

	printf "\033[1;36m%s\033[m\n" "$1" 1>&2
	__first_section=false
}

# show_notice prints a message.
# This is used to inform the user of some outcome.
show_notice() {
	printf "\033[1;34m[!] \033[0;34m%s\033[m\n" "$1" 1>&2
}

# show_error prints an error message.
show_error() {
	printf "\033[31m$1\033[m\n" "${@:2}" 1>&2
}
