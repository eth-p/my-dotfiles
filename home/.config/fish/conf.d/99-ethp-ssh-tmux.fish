# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script wraps the `ssh` command to send the current `$TMUX`
#   environment variable as `$SSH_TMUX` on the remote host.
#
#   Requires the remote host config has:
#
#       AcceptEnv SSH_TMUX
#
# How it's used in my-dotfiles
# ----------------------------
#
#   Tmux-in-tmux.
#
# =============================================================================

# Preserve the original SSH alias, if there is one.
if functions --query ssh
	functions --copy ssh __ethp_original_ssh
else
	function __ethp_original_ssh --wraps "ssh"
		command ssh $argv
		return $status
	end
end

# Create a SSH command that injects `-o SendEnv SSH_TMUX`
function ssh --wraps "ssh"
	set -l SSH_TMUX ""
	if set --query --export TMUX_PANE
		set -x SSH_TMUX "$TMUX_PANE"
	end

	__ethp_original_ssh -o "SendEnv SSH_TMUX" $argv
	return $status
end

