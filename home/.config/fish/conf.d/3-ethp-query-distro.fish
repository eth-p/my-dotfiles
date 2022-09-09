# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script determines the host system information and stores it
#   in global variables.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   This sets the following environment variables:
#
#     ethp_sys_distro  -- The distro ID.
#     ethp_sys_base    -- The distro uname.
#
# =============================================================================

set -g ethp_sys_distro (uname -s | tr '[[:upper:]]' '[[:lower:]]')
set -g ethp_sys_base "$ethp_sys_distro"

if test "$ethp_sys_distro" = "linux"
	if test -n "$TERMUX_VERSION"
		set ethp_sys_distro "termux"
	else
		set ethp_sys_distro (sh -c '
			test -f /etc/lsb-release && source /etc/lsb-release;
			test -f /etc/os-release && source /etc/os-release;
			echo "$ID";
		')
	end
end
