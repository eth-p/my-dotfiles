# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================


# Utility functions for detecting if using Warp.
if [ "$TERM_PROGRAM" = "WarpTerminal" ]
	function is_warp --description "Checks if the current terminal program is Warp";
		argparse "n/not" -- $argv
		if test -n "$_flag_n"; return 1; end
		return 0
	end
else
	function is_warp --description "Checks if the current terminal program is Warp";
		argparse "n/not" -- $argv
		if test -n "$_flag_n"; return 0; end
		return 1
	end
end
