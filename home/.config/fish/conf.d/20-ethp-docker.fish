# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script will use 'session_var' to store and copy the
#   'DOCKER_CONTEXT' environment variable between shell instances.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   This allows pane splits or new tmux windows to copy the Docker context
#   from the pane that created it.
#
# =============================================================================

if status is-interactive && functions -q session_var && command -vq docker

	# Inherit the DOCKER_CONTEXT environment from session variables.
	if [ -n "$last_docker_context" ]
		set -gx DOCKER_CONTEXT "$last_docker_context"
	else
		set -gx DOCKER_CONTEXT 'default'
	end

	# Create a function which listens to the 'kubeswitch' event and
	# updates the session variables whenever the event is fired.
	function __ethp_docker_context_save --on-variable='DOCKER_CONTEXT' \
	--description="Save DOCKER_CONTEXT environment to a session_var"
		session_var --set last_docker_context "$DOCKER_CONTEXT"
	end

end

