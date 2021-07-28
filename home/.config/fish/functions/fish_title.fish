# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles

function fish_title
	# WARNING:
	# Tmux integration scripts rely on the first word being the current command.
	# If it's not, integrations may not work properly.
	printf "%s %s" \
		(set -q argv[1] && echo $argv[1] || status current-command) \
		(__fish_pwd)
end

