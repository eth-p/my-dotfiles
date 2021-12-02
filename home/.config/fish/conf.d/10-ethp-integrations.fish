# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script contains key bindings that will be sent by tmux or
#   the various `tmux-*` scripts in `~/.local/libexec`.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   The key binding sequences are sent by tmux to perform actions from the
#   context menu or from tmux's own key bindings.
#
# =============================================================================

if status is-interactive

	# Leader Sequence: C-S-<F12>
	set -l LEADER \e'[24;6~'

	# <Leader> o -> Visual change directory.
	# This opens `ranger` to select a new directory to change to.
	bind $LEADER'o' 'cd-ranger; commandline -f repaint'

	# <Leader> k -> Clear screen.
	# This clears the screen.
	bind $LEADER'k' '__ethp_integration_clear_screen'
	function __ethp_integration_clear_screen
		printf "\x1B[2J\x1B[3J\x1B[H";
		commandline -f repaint
	end

	# <Leader> j -> Select job.
	# This selects a background job.
	bind $LEADER'j' '__ethp_integration_select_job'
	function __ethp_integration_select_job
		jobs -q || return
		set -l selected (
			jobs |
				sed '0d' |
				awk '{printf "\x1B[34m%%%s \x1B[35m%s\x1B[0m",$1,$2; $1=$2=$3=""; print $0}' |
				fzf --layout=reverse --exit-0 --cycle --ansi \
					--height=(math (count (jobs --pid)) + 2) \
					--border=top --info=inline
		)
		test -n "$selected" && fg (echo "$selected" | cut -d' ' -f1)
		commandline -f repaint
	end

end

