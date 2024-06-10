# my-dotfiles | Copyright (C) 2021-2024 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script will patch the "alias" function to fix the problem of
#   background jobs showing up as "aliased-command $argv".
#
# How it's used in my-dotfiles
# ----------------------------
#
#   I alias 'vi' to vim or nvim. Whenever I run `vi some_file.txt` and
#   suspend the process with Ctrl+Z, the alias obscures the command
#   arguments in the `jobs` output. This fixes that.
#
# =============================================================================

if status is-interactive
	functions alias | while read line
		switch (string trim "$line")
		# Older fish versions
		case 'echo "function $name $wraps --description $cmd_string; $prefix $body \$argv; end" | source'
			echo 'echo "function $name $wraps --description $cmd_string; eval (printf \"%s%s\" \"$prefix $body \" (printf \"%s \" (string escape -- \$argv))); end" | source'

		# fish 3.7.1
		case 'echo "function $name $wraps --description $cmd_string; $prefix $body \$argv'
			echo 'echo "function $name $wraps --description $cmd_string; eval (printf \"%s%s\" \"$prefix $body \" (printf \"%s \" (string escape -- \$argv)))'

		# Do not patch this line.
		case '*'
			echo "$line"
		end
	end | source
end

