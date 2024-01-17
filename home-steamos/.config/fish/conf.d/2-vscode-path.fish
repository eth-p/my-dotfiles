# my-dotfiles | Copyright (C) 2024 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script will append the vscodebin directory to the user PATH.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   Part of using VS Code Flatpak-packaged executables from a host-spawned
#   shell. This will append the directory for the executable shims to the PATH.
#
# =============================================================================
if test "$FLATPAK_ID" = "com.visualstudio.code"
	fish_add_path --path --append --move "$HOME/.local/share/vscodebin"
end
