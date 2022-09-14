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
		alias tree "exa --git --tree --ignore-glob='node_modules'"
	end

	# Vim
	if command -vq nvim
		alias vi nvim
	else if command -vq vim
		alias vi vim
	end

	# Clear (The tmux integration one works better)
	if functions -q __ethp_integration_clear_screen
		alias clear __ethp_integration_clear_screen
	end

	# Kubeswitch
	if functions -q kubeswitch
		kubeswitch kubectl-alias "kubectl"
		alias kk "kubeswitch"
		alias kubectx "kubeswitch context"
		alias kubens "kubeswitch namespace"
	end

	# Better-cd
	if functions -q bettercd
		alias cd "bettercd"
		alias cdun "bettercd --undo"
	end

	# Kubectl
	if command -vq kubectl
		alias k "kubectl"
		alias kg "kubectl get"
		alias kd "kubectl describe"
		alias klog "kubectl logs"
	end

	# Xclip
	if command -vq xclip && not command -vq pbcopy
		alias pbcopy "xclip -selection clipboard -in"
		alias pbpaste "xclip -selection clipboard -out"
	end

	# Fd
	if command -vq fd && command -vq as-tree
		function fdtree --wraps="fd"; fd $argv | as-tree; end
	end

	# Gotop
	if command -vq gotop
		alias top "gotop"
	end

	# Git
	if command -vq git

		function gr --description "git interactive rebase" --wraps="git rebase"
			set -l target "$argv[1]"; [ -n "$target" ] || set target "master"
			set -l hash (git rev-parse "$target") || return $status
			git rebase -i "$hash"
			return $status
		end

		alias grc "git rebase --continue"

	end

	# Tmux
	if command -vq tmux
		
		function tmux
			SHELL=(command -v fish) command tmux $argv || return $status
		end

	end

end

