# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script will use 'session_var' to store and copy the 'kubeswitch'
#   environment between shell instances.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   This allows pane splits or new tmux windows to copy the kubeswitch
#   environment from the pane that created it.
#
# =============================================================================

if status is-interactive && functions -q session_var kubeswitch

	# Inherit the kubeswitch environment from session variables.
	[ -n "$last_kubeswitch_kubeconfig" ] && kubeswitch -q config    "$last_kubeswitch_kubeconfig"
	[ -n "$last_kubeswitch_context" ]    && kubeswitch -q context   "$last_kubeswitch_context"
	[ -n "$last_kubeswitch_namespace" ]  && kubeswitch -q namespace "$last_kubeswitch_namespace"

	# Create a function which listens to the 'kubeswitch' event and
	# updates the session variables whenever the event is fired.
	function __ethp_kubeswitch_save --on-event='kubeswitch' \
	--description="Save kubeswitch environment to a session_var"
		session_var --set last_kubeswitch_kubeconfig "$KUBECONFIG"
		session_var --set last_kubeswitch_context    "$KUBESWITCH_CONTEXT"
		session_var --set last_kubeswitch_namespace  "$KUBESWITCH_NAMESPACE"
	end

end

