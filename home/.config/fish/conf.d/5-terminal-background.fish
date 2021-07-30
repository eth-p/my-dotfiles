# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles

if [ -f "$HOME/.local/libexec/term-query-bg" ]
	set -x TERM_BG (bash "$HOME/.local/libexec/term-query-bg" 2>/dev/null || echo "dark")
end

