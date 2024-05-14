#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This script displays a context menu for ranger, showing common actions.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   If the `tmux_integration_context` ranger plugin is installed, this will
#   have information about the currently-selected file.
#
# =============================================================================

:option: -a CMCFG_RANGER_TOGGLE_HIDDEN_BINDING C-h

# -----------------------------------------------------------------------------

file="$(tmux display-message -p "#{@ranger-current-file}")"
file_name="$(basename -- "$file")"
file_ext="${file_name##*.}"
file_ext_lower="${file_ext,,}"

# Analyze the file.
file_is_dir=false

if [[ -n "$file" ]]; then
    if [[ -d "$file" ]]; then file_is_dir=true; fi
fi

# Print the name of the selected file.
if [[ -n "$file" ]]; then
    menu:suppress_program_header
    menu:header "$file_name"
fi

# Print file-type specific actions.
case "$file_ext_lower" in
    "md") menu:item "Preview" --key="p" "$(keys: Enter)"
esac

# Print general actions.
if ! "$file_is_dir"; then
    menu:item "Edit" --key="e" "$(keys: F4)"
fi

# General options.
menu:separator
menu:header "ranger options"
menu:item "Hidden Files" --key="h" "$(keys: "${CMCFG_RANGER_TOGGLE_HIDDEN_BINDING[@]}")"
