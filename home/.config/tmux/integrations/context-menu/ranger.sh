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
# =============================================================================

:option: -a CMCFG_RANGER_TOGGLE_HIDDEN_BINDING C-h

# -----------------------------------------------------------------------------

menu:item "Edit" --key="e" "$(keys: F4)"

menu:separator
menu:header "ranger options"
menu:item "Hidden Files" --key="h" "$(keys: "${CMCFG_RANGE_TOGGLE_HIDDEN_BINDING[@]}")"

