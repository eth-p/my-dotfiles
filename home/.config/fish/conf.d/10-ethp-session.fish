# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles

# This init script will import 'session_var' variables from the fish
# shell in the pane that spawned this shell. This allows for certain
# environment variables to be copied between shells.

if functions -q session_var &>/dev/null
	if [ -n "$INIT_TMUX_PANE_CREATOR" ]
		set -gx TMUX_PANE_CREATOR "$INIT_TMUX_PANE_CREATOR"
		set -ge INIT_TMUX_PANE_CREATOR
		session_var --import-from-tty=(
			tmux display-message -t "$TMUX_PANE_CREATOR" -p "#{pane_tty}"
		)
	end
end

