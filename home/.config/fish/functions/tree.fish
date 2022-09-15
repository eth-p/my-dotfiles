# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   View the directory tree using `exa`, using a pager if the output
#   is larger than the terminal.
#
# Synopsis
# --------
#
#   View the current directory tree:
#
#     tree
#
#   View the tree of another directory:
#
#     tree ~/Downloads
#
# =============================================================================

if command -vq exa
	function tree --wraps=exa
		argparse -i 'color=' 'paging=' -- $argv

		set -l ignore \
			node_modules     '// nodejs libs' \
			site-packages    '// python libs' \
			"$HOME/.cache"   '// cache data'  \
			"$HOME/.go"      '// go data'     \
			"$HOME/.rustup"  '// rustup'      \
			$ethp_tree_ignore

		# Handle color flag.
		set -l arg_color "$_flag_color"
		if test -z "$_flag_color" || test "$_flag_color" = "auto"
			if test -t 1
				set arg_color "always"
			else
				set arg_color "never"
			end
		end

		# Generate commands to execute.
		set -l tree_cmd \
			exa --git --tree \
			--ignore-glob=(string match --invert '//*' $ignore | string join -- "|") \
			--color="$arg_color" \
			$argv
		
		set -l paging_cmd $PAGER
		if test -z "$paging_cmd" && command -vq less; set paging_cmd less; end
		if test -z "$paging_cmd";                     set paging_cmd cat; end
		
		if test (basename -- "$paging_cmd[1]") = "less"
			set paging_cmd $paging_cmd -R
		end

		# Handle fake paging flag.
		if test -z "$_flag_paging" || test "$_flag_paging" = "auto"
			if test -t 1
				set _flag_paging "auto"
			else
				set _flag_paging "never"
			end
		end

		switch "$_flag_paging"
		case "never"
			$tree_cmd
			return $status

		case "always"
			$tree_cmd | $paging_cmd
			return $status

		case "auto"
			set -l out_line
			set -l out_lines
			$tree_cmd | while read out_line
				set -a out_lines $out_line
				if test (count $out_lines) -ge $LINES
					begin
						printf "%s\n" $out_lines
						cat 
					end | $paging_cmd
					set -e out_lines
					break
				end
			end
			
			# 
			set -l result $pipestatus[1]
			if count $out_lines &>/dev/null
				printf "%s\n" $out_lines
			end
			return $result
				
		case "*"
			echo "tree: Option --paging has no \"$_flag_paging\" setting (choices: always, auto, never)" 1>&2
			return 1
		end
	end
end
