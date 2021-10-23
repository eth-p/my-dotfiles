# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script contains common aliases and quality-of-life wrapper
#   functions.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   This adds shell command aliases.
#
# =============================================================================

if status is-interactive

	# Exa
	if command -vq exa
		alias ls "exa"
		alias ll "exa --git -l"
		alias la "exa --git -la"
	end

	# Vim
	if command -vq nvim
		alias vi nvim
	else if command -vq vim
		alias vi vim
	end

	# Kubeswitch
	if functions -q kubeswitch
		kubeswitch kubectl-alias "kubectl"
		alias kk "kubeswitch"
		alias kubectx "kubeswitch context"
		alias kubens "kubeswitch namespace"
	end

	# Kubectl
	if command -vq kubectl
		alias k "kubectl"
		alias kg "kubectl get"
		alias kd "kubectl describe"
		alias klog "kubectl logs"
	end

	# Fd
	if command -vq fd && command -vq as-tree
		function fdtree --wraps="fd"; fd $argv | as-tree; end
	end

end

