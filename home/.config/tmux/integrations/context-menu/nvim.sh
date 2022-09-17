#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This script displays a context menu for vim, showing common actions.
#
# =============================================================================

:option: -a CMCFG_NVIM_UNDO_BINDING Escape Escape u
:option: -a CMCFG_NVIM_REDO_BINDING Escape Escape C-r
:option: -a CMCFG_NVIM_SAVE_BINDING Escape Escape :w Enter

# -----------------------------------------------------------------------------

menu:item "Undo" --key="C-z" "$(keys: "${CMCFG_NVIM_UNDO_BINDING[@]}")"
menu:item "Redo" --key="C-y" "$(keys: "${CMCFG_NVIM_REDO_BINDING[@]}")" 
menu:item "Save" --key="C-s" "$(keys: "${CMCFG_NVIM_SAVE_BINDING[@]}")"

if git rev-parse --show-toplevel &>/dev/null; then
	menu:item "Previous Conflict" --key="[" "$(keys: Escape Escape :ConflictMarkerPrevHunk Enter)"
	menu:item "Next Conflict" --key="]" "$(keys: Escape Escape :ConflictMarkerNextHunk Enter)"
fi

