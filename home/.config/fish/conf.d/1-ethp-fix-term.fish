# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script will rewrite the $TERM environment variable to change
#   "tmux-256color" to "xterm-256color".
#
#   Doing so prevents errors in programs that rely on the termcap database.
#   Many systems don't have a definition for tmux-256color, so it's best
#   to just let them think it's xterm.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   Tmux is set to report itself as tmux-256color (to enable italics).
#   This causes issues with other programs, so this script resets the
#   $TERM variable back to something that's widely known and supported.
#
# =============================================================================

if [ -n "$TMUX" ]
	switch "$TERM"
		case "tmux-256color"
			set -x TERM "xterm-256color"
			set -x COLORTERM "truecolor"
	end
end

