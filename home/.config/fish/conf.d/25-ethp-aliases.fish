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

# Exa
if command -vq exa
	alias ls "exa"
	alias ll "exa -l"
	alias la "exa -la"
end

# Vim
if command -vq nvim
	alias vi nvim
else if command -vq vim
	alias vi vim
end

# Kubectl
if command -vq kubectl
	alias k "kubectl"
	alias kg "kubectl get"
	alias kd "kubectl describe"
	alias klog "kubectl logs"
end

