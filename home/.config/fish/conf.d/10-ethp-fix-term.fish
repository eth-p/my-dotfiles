# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles

# Override TERM from tmux* to xterm*
# Most systems won't have tmux* in their termcap databases.

switch "$TERM"
	case "tmux-256color"
		set TERM "xterm-256color"
end

