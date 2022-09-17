#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This script will try to clear the screen and scrollback buffer of the
#   target pane. It is a hostile clear that will wipe the entire screen without
#   considering TUI programs that may rely on damage buffers for redrawing.
#
# =============================================================================

# A list of programs that should not be forcibly cleared.
:option: -a ICFG_CLEAR_IGNORED

# -----------------------------------------------------------------------------

# Some programs (e.g. ncurses, or those using damage buffers) do not like
# having the screen forcibly cleared on them, and will render garbage if done.
# These programs are explicitly excluded below:
stop() {
	echo "Clearing '${INTEGRATION_PROGRAM}' would be unsafe."
	:nothing:
	exit 0
}

case "$INTEGRATION_PROGRAM" in
	bat) stop;;
	ranger) stop;;
	less) stop;;
	vi|vim|nvim|neovim) stop;;
esac

for prog in "${ICFG_CLEAR_IGNORED[@]}"; do
	if [ "$prog" = "$INTEGRATION_PROGRAM" ]; then
		stop
	fi
done

# It's safe to send the reset command to the tmux pane.
tmux clear-history -t "$INTEGRATION_PANE"
keys: -R

