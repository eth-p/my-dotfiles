# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles

# C-e (default) -> Move the cursor to the end of the prompt.
# C-q           -> Move the cursor to the beginning of the prompt.
bind \cq 'commandline --cursor 0'

# M-C-K -> Clear the scrollback buffer and repaint the prompt.
# This is bound from CMD+K (alacritty) -> tmux (C-a+K) -> fish.
bind \e\cK 'printf "\x1B[2J\x1B[3J\x1B[H"; commandline -f repaint'

