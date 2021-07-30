# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles

# This init script will import 'session_var' variables from the fish
# shell in the pane that spawned this shell. This allows for certain
# environment variables to be copied between shells.

if status --is-interactive && functions -q session_var &>/dev/null
	set creator_session ""
	set creator_tty (tty)

	# Running with my tmux integrations?
	if [ -n "$INIT_TMUX_PANE_CREATOR" ]
		set -gx TMUX_PANE_CREATOR "$INIT_TMUX_PANE_CREATOR"
		set -ge INIT_TMUX_PANE_CREATOR
		
		set creator_tty (
			tmux display-message -t "$TMUX_PANE_CREATOR" -p "#{pane_tty}"
		)
	end

	# Get the session file associated with the pane creator tty.
	set creator_session (session_var --file-from-tty="$creator_tty")
		
	# Get the creator pid from the session file.
	if [ -f "$creator_session" ]
		set creator_pid (
			session_var --using-file="$creator_session" --meta _session_owner_pid
		)

		# Check that the owner's session advertised pid still exists.
		if kill -0 "$creator_pid" &>/dev/null
			session_var --import-from-file="$creator_session"
		else
			# If it's doesn't, we will assume that fish didn't exit cleanly
			# last time and that the session variables are stale.
			rm "$creator_session"
		end
	end

	# Set the meta key to help future shell instnaces determine if the
	# session they're inheriting from is stale (i.e. reused tty).
	session_var --set --meta "_session_owner_pid" "$fish_pid"
end

