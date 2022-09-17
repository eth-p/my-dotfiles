#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This script displays a context menu containing some quick actions for
#   manipulating the active pane.
#
# =============================================================================

# Pane swapping.
menu:item "Swap Up"   --key=u "swap-pane -t '${INTEGRATION_PANE}' -U"
menu:item "Swap Down" --key=d "swap-pane -t '${INTEGRATION_PANE}' -D"
menu:item "#{?pane_marked_set,,-}Swap Marked" --key=s \
	"swap-pane -t '${INTEGRATION_PANE}'"

# Pane flags.
menu:item "Zoom" --key=z "resize-pane -t '${INTEGRATION_PANE}' -Z"
menu:item "#{?pane_marked,Unmark,Mark}" --key=m \
	"select-pane -t '${INTEGRATION_PANE}' -m"

